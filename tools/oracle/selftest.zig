//! `zig build oracle-selftest -Doracles`: design §8 step 2's check that the two DEFLATE oracles
//! agree with each other before either judges stdx.
//!
//! For every corpus file, zlib encodes the file at every level (0 to 9) and every strategy, in all
//! three containers, and zlib and Wuffs each decode every stream. Both must end the stream, consume
//! every octet zlib wrote, and write the file back octet for octet. Two oracles that disagree on
//! valid input would make every later verdict of decision 15 meaningless.
//!
//! The 150 settings run over the first `matrix_input_len_max` octets of each file. A file longer
//! than that also runs whole, at zlib's default level and strategy, in all three containers, so
//! every octet of every corpus file goes through both oracles.
//!
//! Usage: `oracle_selftest <name>=<path>...`. Exit status 0 when every stream agrees, 1 when any
//! does not, 2 on a usage error.

const std = @import("std");
const oracle = @import("oracle");

/// The prefix of each file the full matrix of settings runs over. 1 MiB keeps a run over Silesia
/// within minutes on a hosted runner while covering every block type and window distance zlib uses.
pub const matrix_input_len_max: usize = 1 << 20;

/// zlib's default level, used for the whole-file runs.
pub const whole_file_level: c_int = 6;

/// The exit status of a usage error.
const usage_exit_status = 2;

/// Every corpus file of decision 15 by the name build/oracle.zig gives it. The self-test refuses
/// to run over any other set, so a file the build drops or adds is a failure, not a quieter run.
pub const corpus_names = [_][]const u8{
    "silesia/dickens",            "silesia/mozilla",               "silesia/mr",            "silesia/nci",
    "silesia/ooffice",            "silesia/osdb",                  "silesia/reymont",       "silesia/samba",
    "silesia/sao",                "silesia/webster",               "silesia/x-ray",         "silesia/xml",
    "canterbury/alice29.txt",     "canterbury/asyoulik.txt",       "canterbury/cp.html",    "canterbury/fields.c",
    "canterbury/grammar.lsp",     "canterbury/kennedy.xls",        "canterbury/lcet10.txt", "canterbury/plrabn12.txt",
    "canterbury/ptt5",            "canterbury/sum",                "canterbury/xargs.1",    "canterbury-large/E.coli",
    "canterbury-large/bible.txt", "canterbury-large/world192.txt", "http/html-1k",          "http/html-16k",
    "http/html-1m",               "http/json-1k",                  "http/json-16k",         "http/json-1m",
    "http/js-1k",                 "http/js-16k",                   "http/js-1m",            "http/css-1k",
    "http/css-16k",               "http/css-1m",
};

/// True when `names` holds every name of `corpus_names` once and nothing else.
pub fn is_whole_corpus(names: []const []const u8) bool {
    if (names.len != corpus_names.len) return false;
    for (corpus_names) |wanted| {
        var found: usize = 0;
        for (names) |name| {
            if (std.mem.eql(u8, name, wanted)) found += 1;
        }
        if (found != 1) return false;
    }
    return true;
}

/// Every container, level and strategy zlib offers: 3 * 10 * 5 settings.
pub const matrix = build_matrix();

fn build_matrix() [3 * (oracle.level_max + 1) * 5]oracle.Encoding {
    var settings: [3 * (oracle.level_max + 1) * 5]oracle.Encoding = undefined;
    var index: usize = 0;
    for ([_]oracle.Container{ .raw, .zlib, .gzip }) |container| {
        var level: c_int = 0;
        while (level <= oracle.level_max) : (level += 1) {
            for (std.enums.values(oracle.Strategy)) |strategy| {
                settings[index] = .{ .container = container, .level = level, .strategy = strategy };
                index += 1;
            }
        }
    }
    return settings;
}

/// One oracle's decode of a stream.
pub const Decoded = struct {
    result: oracle.Result,
    output: []const u8,
};

/// Why a stream failed the check, when it did.
pub const Disagreement = union(enum) {
    /// The oracle did not end the stream with every check passed.
    verdict: oracle.Verdict,
    /// The oracle stopped before, or read past, the octets zlib wrote.
    consumed: usize,
    /// The oracle wrote a different number of octets than the input held.
    written: usize,
    /// The first octet where the oracle's output differs from the input.
    octet: usize,
};

/// The first way `decoded` fails to reproduce `expected` from a stream of `encoded_len` octets, or
/// null when it reproduces it exactly.
pub fn judge(expected: []const u8, encoded_len: usize, decoded: Decoded) ?Disagreement {
    if (decoded.result.verdict != .ok) return .{ .verdict = decoded.result.verdict };
    if (decoded.result.consumed != encoded_len) return .{ .consumed = decoded.result.consumed };
    if (decoded.result.written != expected.len) return .{ .written = decoded.result.written };
    const differs = std.mem.indexOfDiff(u8, expected, decoded.output[0..decoded.result.written]);
    if (differs) |offset| return .{ .octet = offset };
    return null;
}

/// Buffers for one file, sized once for its longest stream.
const Buffers = struct {
    encoded: []u8,
    zlib_output: []u8,
    wuffs_output: []u8,
};

/// Counts for the report.
const Tally = struct {
    streams: usize = 0,
    /// Decodes made: two per stream zlib encoded, one per oracle.
    decodes: usize = 0,
    octets: usize = 0,
    failures: usize = 0,
};

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    if (args.len < 2) {
        std.debug.print("usage: oracle_selftest <name>=<path>...\n", .{});
        std.process.exit(usage_exit_status);
    }
    var names: std.ArrayList([]const u8) = .empty;
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse argument.len;
        try names.append(arena, argument[0..split]);
    }
    if (!is_whole_corpus(names.items)) {
        std.debug.print("oracle-selftest FAILED: the build passed {d} files, not the {d} of decision 15\n", .{
            names.items.len, corpus_names.len,
        });
        std.process.exit(1);
    }
    var total: Tally = .{};
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse {
            std.debug.print("oracle-selftest: {s} is not <name>=<path>\n", .{argument});
            std.process.exit(usage_exit_status);
        };
        const name = argument[0..split];
        const input = try std.Io.Dir.cwd().readFileAlloc(init.io, argument[split + 1 ..], arena, .unlimited);
        const tally = try check_file(arena, name, input);
        std.debug.print("oracle-selftest: {s}: {d} octets, {d} streams, {d} failed\n", .{
            name, input.len, tally.streams, tally.failures,
        });
        total.streams += tally.streams;
        total.octets += tally.octets;
        total.failures += tally.failures;
    }
    std.debug.print("oracle-selftest: {d} files, {d} streams, {d} octets decoded twice each, {d} failed\n", .{
        args.len - 1, total.streams, total.octets, total.failures,
    });
    if (total.failures != 0) std.process.exit(1);
}

fn check_file(arena: std.mem.Allocator, name: []const u8, input: []const u8) !Tally {
    const buffers: Buffers = .{
        .encoded = try arena.alloc(u8, oracle.zlib_bound(.gzip, input.len)),
        .zlib_output = try arena.alloc(u8, input.len),
        .wuffs_output = try arena.alloc(u8, input.len),
    };
    defer arena.free(buffers.encoded);
    var tally: Tally = .{};
    const prefix = input[0..@min(input.len, matrix_input_len_max)];
    for (matrix) |encoding| check_stream(name, encoding, prefix, buffers, &tally);
    if (input.len > prefix.len) {
        for ([_]oracle.Container{ .raw, .zlib, .gzip }) |container| {
            const encoding: oracle.Encoding = .{ .container = container, .level = whole_file_level, .strategy = .default };
            check_stream(name, encoding, input, buffers, &tally);
        }
    }
    return tally;
}

fn check_stream(name: []const u8, encoding: oracle.Encoding, input: []const u8, buffers: Buffers, tally: *Tally) void {
    tally.streams += 1;
    tally.octets += input.len;
    const encoded = oracle.zlib_encode(encoding, input, buffers.encoded);
    if (encoded.verdict != .ok or encoded.consumed != input.len) {
        report(name, encoding, "zlib's encoder", .{ .verdict = encoded.verdict });
        tally.failures += 1;
        return;
    }
    const stream = buffers.encoded[0..encoded.written];
    const decoders = .{
        .{ "zlib", oracle.zlib_decode, buffers.zlib_output },
        .{ "Wuffs", oracle.wuffs_decode, buffers.wuffs_output },
    };
    inline for (decoders) |decoder| {
        tally.decodes += 1;
        const result = decoder[1](encoding.container, stream, decoder[2]);
        if (judge(input, stream.len, .{ .result = result, .output = decoder[2] })) |disagreement| {
            report(name, encoding, decoder[0], disagreement);
            tally.failures += 1;
        }
    }
}

fn report(name: []const u8, encoding: oracle.Encoding, who: []const u8, disagreement: Disagreement) void {
    std.debug.print("oracle-selftest FAILED: {s}, {t} level {d} {t}: {s}: {any}\n", .{
        name, encoding.container, encoding.level, encoding.strategy, who, disagreement,
    });
}

// Tests. The oracles themselves are tested in oracle.zig; these pin the matrix and the judgement.

const testing = std.testing;

test "the matrix holds every container, level and strategy once" {
    try testing.expectEqual(150, matrix.len);
    for ([_]oracle.Container{ .raw, .zlib, .gzip }) |container| {
        var level: c_int = 0;
        while (level <= oracle.level_max) : (level += 1) {
            for (std.enums.values(oracle.Strategy)) |strategy| {
                const wanted: oracle.Encoding = .{ .container = container, .level = level, .strategy = strategy };
                try testing.expectEqual(1, count_in_matrix(wanted));
            }
        }
    }
}

fn count_in_matrix(wanted: oracle.Encoding) usize {
    var found: usize = 0;
    for (matrix) |encoding| {
        const same = encoding.container == wanted.container and encoding.level == wanted.level and
            encoding.strategy == wanted.strategy;
        if (same) found += 1;
    }
    return found;
}

test "judge passes an exact reproduction and names each kind of failure" {
    const expected = "octets";
    const ok: oracle.Result = .{ .verdict = .ok, .consumed = 9, .written = expected.len };
    try testing.expectEqual(null, judge(expected, 9, .{ .result = ok, .output = "octets" }));

    var refused = ok;
    refused.verdict = .refused;
    try testing.expectEqual(Disagreement{ .verdict = .refused }, judge(expected, 9, .{ .result = refused, .output = "octets" }).?);
    try testing.expectEqual(Disagreement{ .consumed = 9 }, judge(expected, 10, .{ .result = ok, .output = "octets" }).?);

    var short = ok;
    short.written = 5;
    try testing.expectEqual(Disagreement{ .written = 5 }, judge(expected, 9, .{ .result = short, .output = "octet" }).?);
    try testing.expectEqual(Disagreement{ .octet = 3 }, judge(expected, 9, .{ .result = ok, .output = "octXts" }).?);
}

test "check_stream counts a stream both oracles reproduce, and counts nothing failed" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const input = "the same eight octets, the same eight octets, the same eight octets";
    const tally = try check_file(arena_state.allocator(), "sample", input);
    try testing.expectEqual(matrix.len, tally.streams);
    try testing.expectEqual(2 * matrix.len, tally.decodes);
    try testing.expectEqual(0, tally.failures);
}

test "the corpus is decision 15's 38 files, and a set with one dropped or added is refused" {
    try testing.expectEqual(38, corpus_names.len);
    try testing.expect(is_whole_corpus(&corpus_names));
    try testing.expect(!is_whole_corpus(corpus_names[1..]));
    var doubled = corpus_names;
    doubled[1] = doubled[0];
    try testing.expect(!is_whole_corpus(&doubled));
    const added = corpus_names ++ [_][]const u8{"silesia/extra"};
    try testing.expect(!is_whole_corpus(&added));
}

test "check_file runs a long file whole as well as through the matrix" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const input = try arena.alloc(u8, matrix_input_len_max + 1);
    for (input, 0..) |*octet, index| octet.* = @truncate(index % 251);
    const tally = try check_file(arena, "long", input);
    try testing.expectEqual(matrix.len + 3, tally.streams);
    try testing.expectEqual(0, tally.failures);
}
