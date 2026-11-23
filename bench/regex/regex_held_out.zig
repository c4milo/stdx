//! bench-regex's held-out set (decision 86 as amended): rebar's curated benchmarks whose engines
//! name Go's regexp or RE2, which regex_rebar.zig lists. The patterns of the other tables were
//! written for this benchmark; rebar's author chose these. Design §8 part 22n tuned stdx on
//! them since, so they no longer show how stdx runs on patterns its tuning did not see.
//!
//! Each benchmark's pattern and haystack are built as rebar builds them, from the files of rebar's
//! commit that the build fetches. Every candidate's answer is held to the count rebar's definition
//! gives Go's regexp before it is timed. stdx, Rust's crate and Go's regexp are timed, each round
//! from one place later than the round before, with stdx again last in each round. zig-regex and
//! mvzr are not: the other tables time them at a hundredth to a four-thousandth of stdx's speed,
//! and a haystack here holds up to 32 MB.

const std = @import("std");
const codec = @import("codec");
const timing = @import("timing");
const engines = @import("regex_engines.zig");
const held = @import("regex_engines_rebar.zig");
const rebar = @import("regex_rebar.zig");
const table = @import("regex_table.zig");

const Engine = engines.Engine;
const engine_count = engines.names.len;
const Row = table.Row;
const File = table.File;

/// The name a file of rebar takes on the benchmark's command line: `rebar/` and its path under
/// rebar's `benchmarks/`.
pub const file_prefix = "rebar/";

/// What a rate counts each second: megabytes of haystack, or thousands of patterns.
const per_thousand = 1_000.0;

/// The candidates the held-out set times.
const timed = [_]Engine{ .stdx, .rust, .go, .stdx_again };

/// The longest name of a rebar file on the command line.
const file_name_len_max = 256;

/// A rebar file the build passed, by its directory and path under rebar's `benchmarks/`.
fn file_of(files: []const File, directory: []const u8, path: []const u8) ![]const u8 {
    var buffer: [file_name_len_max]u8 = undefined;
    const wanted = try std.fmt.bufPrint(&buffer, "{s}{s}/{s}", .{ file_prefix, directory, path });
    for (files) |file| {
        if (std.mem.eql(u8, file.name, wanted)) return file.octets;
    }
    std.debug.print("bench-regex: the build passed no rebar file {s}\n", .{wanted});
    return error.CorpusFileMissing;
}

/// rebar's `utf8-lossy`: each maximal part of an invalid UTF-8 sequence becomes U+FFFD, as Rust's
/// `String::from_utf8_lossy` replaces it.
fn utf8_lossy(arena: std.mem.Allocator, octets: []const u8) ![]const u8 {
    var out: std.ArrayList(u8) = .empty;
    var index: usize = 0;
    while (index < octets.len) {
        const valid = valid_prefix(octets[index..]);
        if (valid.whole) {
            try out.appendSlice(arena, octets[index..][0..valid.len]);
        } else {
            try out.appendSlice(arena, "\u{FFFD}");
        }
        index += valid.len;
    }
    return out.items;
}

/// The octets of the sequence that starts `octets`: a whole scalar value's, or the longest start
/// of one, at least one octet, which `whole` false marks.
fn valid_prefix(octets: []const u8) struct { len: usize, whole: bool } {
    const lead = octets[0];
    if (lead < 0x80) return .{ .len = 1, .whole = true };
    // The octets that follow the lead, and the range the first of them must fall in (RFC 3629 §4).
    const shape: struct { follow: usize, low: u8, high: u8 } = switch (lead) {
        0xC2...0xDF => .{ .follow = 1, .low = 0x80, .high = 0xBF },
        0xE0 => .{ .follow = 2, .low = 0xA0, .high = 0xBF },
        0xE1...0xEC, 0xEE...0xEF => .{ .follow = 2, .low = 0x80, .high = 0xBF },
        0xED => .{ .follow = 2, .low = 0x80, .high = 0x9F },
        0xF0 => .{ .follow = 3, .low = 0x90, .high = 0xBF },
        0xF1...0xF3 => .{ .follow = 3, .low = 0x80, .high = 0xBF },
        0xF4 => .{ .follow = 3, .low = 0x80, .high = 0x8F },
        else => return .{ .len = 1, .whole = false },
    };
    var taken: usize = 0;
    while (taken < shape.follow and 1 + taken < octets.len) : (taken += 1) {
        const octet = octets[1 + taken];
        const low: u8 = if (taken == 0) shape.low else 0x80;
        const high: u8 = if (taken == 0) shape.high else 0xBF;
        if (octet < low or octet > high) break;
    }
    return .{ .len = 1 + taken, .whole = taken == shape.follow };
}

/// The lines of a text from `start` up to `end`, each with its line feed, as rebar's
/// `line-start` and `line-end` take them.
fn line_range(octets: []const u8, start: ?u32, end: ?u32) []const u8 {
    const first = line_offset(octets, start orelse 0);
    const last = if (end) |line| line_offset(octets, line) else octets.len;
    return octets[first..@max(first, last)];
}

/// Where line `line` starts, counting from 0, or the text's end where it has fewer lines.
fn line_offset(octets: []const u8, line: u32) usize {
    var offset: usize = 0;
    for (0..line) |_| {
        const feed = std.mem.indexOfScalarPos(u8, octets, offset, '\n') orelse return octets.len;
        offset = feed + 1;
    }
    return offset;
}

fn haystack_of(arena: std.mem.Allocator, files: []const File, haystack: rebar.Haystack) ![]const u8 {
    switch (haystack) {
        .text => |text| {
            const out = try arena.alloc(u8, text.octets.len * text.repeat);
            for (0..text.repeat) |copy| @memcpy(out[copy * text.octets.len ..][0..text.octets.len], text.octets);
            return out;
        },
        .file => |file| {
            var octets = try file_of(files, "haystacks", file.path);
            if (file.utf8_lossy) octets = try utf8_lossy(arena, octets);
            return line_range(octets, file.line_start, file.line_end);
        },
    }
}

/// rebar's escape of a literal: a `\` before each octet its syntax gives a meaning.
fn escape(arena: std.mem.Allocator, out: *std.ArrayList(u8), literal: []const u8) !void {
    for (literal) |octet| {
        if (std.mem.indexOfScalar(u8, "\\.+*?()|[]{}^$#&-~", octet) != null) try out.append(arena, '\\');
        try out.append(arena, octet);
    }
}

/// A pattern as rebar builds it, with a `(?i)` before it where `flag` asks for one.
fn pattern_of(arena: std.mem.Allocator, files: []const File, bench: rebar.Bench, flag: bool) ![]const u8 {
    var out: std.ArrayList(u8) = .empty;
    if (flag and bench.case_insensitive) try out.appendSlice(arena, "(?i)");
    switch (bench.pattern) {
        .text => |text| try out.appendSlice(arena, text),
        .file => |file| {
            const text = try file_of(files, "regexes", file.path);
            if (!file.alternate) {
                try out.appendSlice(arena, std.mem.trim(u8, text, " \t\r\n"));
                return out.items;
            }
            var lines: held.Lines = .{ .rest = text };
            var first = true;
            while (lines.next()) |line| {
                if (!first) try out.append(arena, '|');
                first = false;
                try out.appendSlice(arena, "(?:");
                if (file.literal) try escape(arena, &out, line) else try out.appendSlice(arena, line);
                try out.append(arena, ')');
            }
        },
    }
    return out.items;
}

/// One candidate's call on one benchmark: a model over the haystack, or a compile.
const Call = struct {
    engine: Engine,
    bench: rebar.Bench,
    pattern: []const u8,
    haystack: []const u8,
    stdx: *held.Held,
    rust: ?*anyopaque = null,
    go: usize = 0,

    fn answer(call: *const Call) u64 {
        return switch (call.engine) {
            .rust => held.rust_run(call.rust.?, call.bench.model, call.haystack),
            .go => held.go_run(call.go, call.bench.model, call.haystack),
            else => call.stdx.run(call.bench.model, call.haystack),
        };
    }

    fn compile(call: *const Call) bool {
        return switch (call.engine) {
            .rust => held.rust_compile(call.pattern, call.bench),
            .go => held.go_compile(call.pattern),
            else => call.stdx.ready(call.pattern),
        };
    }

    fn run_once(context: *const anyopaque) void {
        const call: *const Call = @ptrCast(@alignCast(context));
        if (call.bench.model == .compile) {
            std.mem.doNotOptimizeAway(call.compile());
        } else {
            std.mem.doNotOptimizeAway(call.answer());
        }
    }
};

/// Readies one candidate for a benchmark and holds its answer to rebar's count. Go's regexp must
/// give the count, since the count is the one rebar's definition gives it.
fn prepare(call: *Call, row: *Row, stdx_pattern: []const u8, rust_pattern: []const u8) !void {
    const index = @intFromEnum(call.engine);
    const ready = switch (call.engine) {
        .rust => ready: {
            call.rust = held.rust_new(rust_pattern, call.bench);
            break :ready call.rust != null;
        },
        .go => ready: {
            call.go = held.go_new(stdx_pattern) orelse 0;
            break :ready call.go != 0;
        },
        else => call.stdx.ready(stdx_pattern),
    };
    call.pattern = if (call.engine == .rust) rust_pattern else stdx_pattern;
    if (!ready) {
        row.cells[index] = .refused;
        if (call.engine == .go) return error.GoRefusesThePattern;
        return;
    }
    const answer = call.answer();
    if (answer != call.bench.count) {
        std.debug.print("bench-regex: {s} gives {d} for {s}, and rebar gives {d}\n", .{ engines.names[index], answer, call.bench.name, call.bench.count });
        row.cells[index] = .differs;
        if (call.engine == .go) return error.GoDisagreesWithRebar;
        return;
    }
    row.add(call.engine, .{ .context = call, .run_once = Call.run_once });
}

const Section = enum { searches, compiles };

/// stdx's two candidates, each with storage for any held-out pattern, which every row reuses.
const Stdx = struct { first: *held.Held, again: *held.Held };

fn report_section(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator, files: []const File, stdx: Stdx, section: Section) !void {
    if (section == .searches) {
        try table.print_head(out, "Held-out search, rebar's curated set, MB/s", "Benchmark", "Answer");
    } else {
        try table.print_head(out, "Held-out compile, rebar's curated set, thousands of patterns a second", "Benchmark", "Answer");
    }
    for (rebar.benches) |bench| {
        if ((bench.model == .compile) != (section == .compiles)) continue;
        const haystack = try haystack_of(arena, files, bench.haystack);
        const stdx_pattern = try pattern_of(arena, files, bench, true);
        const rust_pattern = try pattern_of(arena, files, bench, false);
        const calls = try arena.alloc(Call, timed.len);
        var row: Row = .{ .cells = @splat(.untimed) };
        for (calls, timed) |*call, engine| {
            call.* = .{ .engine = engine, .bench = bench, .pattern = stdx_pattern, .haystack = haystack, .stdx = if (engine == .stdx_again) stdx.again else stdx.first };
            try prepare(call, &row, stdx_pattern, rust_pattern);
        }
        try out.print("| {s} | {d} |", .{ bench.name, bench.count });
        const items = if (section == .searches) @as(f64, @floatFromInt(haystack.len)) / timing.octets_per_megabyte else 1.0 / per_thousand;
        try row.print(io, out, items);
        try out.flush();
    }
    try out.writeAll("\n");
}

/// The held-out set's two tables: the searches in megabytes of haystack a second, and the
/// compiles in thousands of patterns a second.
pub fn report(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator, features: codec.Features, files: []const File) !void {
    try out.print("The held-out set: every benchmark of rebar's curated set, at commit {s}, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and design §8 part 22n tuned stdx on them since. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.\n\n", .{rebar.commit});
    const stdx: Stdx = .{ .first = try held.Held.create(arena, features), .again = try held.Held.create(arena, features) };
    try report_section(io, out, arena, files, stdx, .searches);
    try report_section(io, out, arena, files, stdx, .compiles);
}

const testing = std.testing;

test "utf8_lossy replaces each maximal part of an invalid sequence, as Rust's lossy decode does" {
    const cases = [_]struct { in: []const u8, out: []const u8 }{
        .{ .in = "a\xC3\xA9b", .out = "a\xC3\xA9b" },
        .{ .in = "a\xFFb", .out = "a\u{FFFD}b" },
        // A lead and one valid follow of three: one replacement for both.
        .{ .in = "\xE2\x82b", .out = "\u{FFFD}b" },
        // A surrogate's lead and follow are two maximal parts.
        .{ .in = "\xED\xA0\x80", .out = "\u{FFFD}\u{FFFD}\u{FFFD}" },
        .{ .in = "\xF0\x9F\x98", .out = "\u{FFFD}" },
        .{ .in = "\xC0\xAF", .out = "\u{FFFD}\u{FFFD}" },
    };
    var arena: std.heap.ArenaAllocator = .init(testing.allocator);
    defer arena.deinit();
    for (cases) |case| try testing.expectEqualStrings(case.out, try utf8_lossy(arena.allocator(), case.in));
}

test "line_range keeps lines from line_start up to line_end, each with its line feed" {
    try testing.expectEqualStrings("b\nc\n", line_range("a\nb\nc\nd", 1, 3));
    try testing.expectEqualStrings("a\nb\n", line_range("a\nb\nc", null, 2));
    try testing.expectEqualStrings("c", line_range("a\nb\nc", 2, null));
    try testing.expectEqualStrings("", line_range("a\nb", 5, 9));
}
