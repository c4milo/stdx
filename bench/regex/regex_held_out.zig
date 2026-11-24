//! bench-regex's two sets of rebar's benchmarks (decision 86 as amended), which regex_rebar.zig
//! lists: each one whose engines name Go's regexp or RE2. The patterns of the other tables were
//! written for this benchmark; rebar's author chose these. `curated` is rebar's curated set,
//! which design §8 part 22n tuned stdx on. `others` is every other definition but rebar's tests:
//! no work on stdx has measured them, and no change is judged on them.
//!
//! Each benchmark's pattern and haystack are built as rebar builds them, from the files of rebar's
//! commit that the build fetches. Every candidate's answer is held to the count rebar's definition
//! gives its engine before it is timed, RE2's for stdx. stdx, Rust's crate and Go's regexp are timed, each round
//! from one place later than the round before, with stdx again last in each round. zig-regex and
//! mvzr are not: the other tables time them at a hundredth to a four-thousandth of stdx's speed,
//! and a haystack here holds up to 40 MB.

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

/// The white space rebar's `trim` takes from both ends of a haystack.
const white_space = " \t\r\n\x0b\x0c";

/// A haystack as rebar builds it: lossy UTF-8, then `trim`, then the line range or `repeat`, then
/// `append` (rebar's FORMAT.md, `haystack`).
fn haystack_of(arena: std.mem.Allocator, files: []const File, haystack: rebar.Haystack) ![]const u8 {
    switch (haystack) {
        .text => |text| {
            const out = try arena.alloc(u8, text.octets.len * text.repeat);
            for (0..text.repeat) |copy| @memcpy(out[copy * text.octets.len ..][0..text.octets.len], text.octets);
            return appended(arena, out, text.append);
        },
        .file => |file| {
            var octets = try file_of(files, "haystacks", file.path);
            if (file.utf8_lossy) octets = try utf8_lossy(arena, octets);
            if (file.trim) octets = std.mem.trim(u8, octets, white_space);
            return appended(arena, line_range(octets, file.line_start, file.line_end), file.append);
        },
    }
}

/// `octets` with `tail` after them.
fn appended(arena: std.mem.Allocator, octets: []const u8, tail: []const u8) ![]const u8 {
    if (tail.len == 0) return octets;
    return std.mem.concat(arena, u8, &.{ octets, tail });
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
            try out.appendSlice(arena, file.prepend);
            try file_pattern(arena, &out, try file_of(files, "regexes", file.path), file.alternate, file.literal);
            try out.appendSlice(arena, file.append);
        },
    }
    return out.items;
}

/// The pattern of a file: its text trimmed, or each line an alternative in a group of its own.
fn file_pattern(arena: std.mem.Allocator, out: *std.ArrayList(u8), text: []const u8, alternate: bool, literal: bool) !void {
    if (!alternate) return out.appendSlice(arena, std.mem.trim(u8, text, white_space));
    var lines: held.Lines = .{ .rest = text };
    var first = true;
    while (lines.next()) |line| {
        if (!first) try out.append(arena, '|');
        first = false;
        try out.appendSlice(arena, "(?:");
        if (literal) try escape(arena, out, line) else try out.appendSlice(arena, line);
        try out.append(arena, ')');
    }
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

/// Compiles one candidate's pattern for a benchmark and takes its answer, or gives null where the
/// candidate refuses the pattern.
fn ready(call: *Call, stdx_pattern: []const u8, rust_pattern: []const u8) ?u64 {
    const compiled = switch (call.engine) {
        .rust => compiled: {
            call.rust = held.rust_new(rust_pattern, call.bench);
            break :compiled call.rust != null;
        },
        .go => compiled: {
            call.go = held.go_new(stdx_pattern) orelse 0;
            break :compiled call.go != 0;
        },
        else => call.stdx.ready(stdx_pattern),
    };
    call.pattern = if (call.engine == .rust) rust_pattern else stdx_pattern;
    if (!compiled) return null;
    return call.answer();
}

/// Holds one candidate's answer to its engine's count, and times its operation where they agree.
fn admit(row: *Row, engine: Engine, operation: timing.Operation, answer: ?u64, counts: rebar.Counts) void {
    const index = @intFromEnum(engine);
    const given = answer orelse {
        row.cells[index] = .refused;
        return;
    };
    if (given != count_of(counts, engine)) {
        row.cells[index] = .differs;
        return;
    }
    row.add(engine, operation);
}

/// The count rebar's definition gives a candidate's engine: Go's regexp's, Rust's crate's, and
/// RE2's for stdx, whose syntax and reading of invalid UTF-8 are RE2's.
fn count_of(counts: rebar.Counts, engine: Engine) u64 {
    return switch (engine) {
        .go => counts.go,
        .rust => counts.rust,
        else => counts.re2,
    };
}

const Section = enum { searches, compiles };

/// One of rebar's two sets: its benchmarks, and the title of each of its tables.
const Set = struct { benches: []const rebar.Bench, search_title: []const u8, compile_title: []const u8 };

/// rebar's curated set, which design §8 part 22n tuned stdx on.
const curated: Set = .{
    .benches = &rebar.curated,
    .search_title = "Held-out search, rebar's curated set, MB/s",
    .compile_title = "Held-out compile, rebar's curated set, thousands of patterns a second",
};

/// Every other definition of rebar but its tests, which no work on stdx has measured.
const others: Set = .{
    .benches = &rebar.others,
    .search_title = "Search, rebar's other benchmarks, MB/s",
    .compile_title = "Compile, rebar's other benchmarks, thousands of patterns a second",
};

/// stdx's two candidates, each with storage for any held-out pattern, which every row reuses.
const Stdx = struct { first: *held.Held, again: *held.Held };

fn report_section(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator, files: []const File, stdx: Stdx, set: Set, section: Section) !void {
    const title = if (section == .searches) set.search_title else set.compile_title;
    try table.print_head(out, title, "Benchmark", "Answer");
    for (set.benches) |bench| {
        if ((bench.model == .compile) != (section == .compiles)) continue;
        try report_row(io, out, arena, files, stdx, bench, section);
    }
    try out.writeAll("\n");
}

/// Readies each candidate for one benchmark, holds its answer to Go's, and times the ones that
/// agree.
fn report_row(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator, files: []const File, stdx: Stdx, bench: rebar.Bench, section: Section) !void {
    const haystack = try haystack_of(arena, files, bench.haystack);
    const stdx_pattern = try pattern_of(arena, files, bench, true);
    const rust_pattern = try pattern_of(arena, files, bench, false);
    const calls = try arena.alloc(Call, timed.len);
    var answers: [timed.len]?u64 = undefined;
    for (calls, timed, &answers) |*call, engine, *answer| {
        call.* = .{ .engine = engine, .bench = bench, .pattern = stdx_pattern, .haystack = haystack, .stdx = if (engine == .stdx_again) stdx.again else stdx.first };
        answer.* = ready(call, stdx_pattern, rust_pattern);
    }
    var row: Row = .{ .cells = @splat(.untimed) };
    for (calls, answers) |*call, answer| admit(&row, call.engine, .{ .context = call, .run_once = Call.run_once }, answer, bench.count);
    for (timed, answers) |engine, answer| {
        if (row.cells[@intFromEnum(engine)] != .differs) continue;
        std.debug.print("bench-regex: {s} gives {d} for {s}, and rebar gives {d}\n", .{ engines.names[@intFromEnum(engine)], answer.?, bench.name, count_of(bench.count, engine) });
    }
    try print_count(out, bench);
    const items = if (section == .searches) @as(f64, @floatFromInt(haystack.len)) / timing.octets_per_megabyte else 1.0 / per_thousand;
    try row.print(io, out, items);
    try out.flush();
}

/// A row's name and its count, or each engine's where rebar gives them different counts.
fn print_count(out: *std.Io.Writer, bench: rebar.Bench) !void {
    const counts = bench.count;
    if (counts.go == counts.rust and counts.go == counts.re2) return out.print("| {s} | {d} |", .{ bench.name, counts.go });
    try out.print("| {s} | Go {d}, Rust {d}, RE2 {d} |", .{ bench.name, counts.go, counts.rust, counts.re2 });
}

/// Each of rebar's two sets in two tables: the searches in megabytes of haystack a second, and the
/// compiles in thousands of patterns a second.
pub fn report(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator, features: codec.Features, files: []const File) !void {
    try out.print("rebar's benchmarks, at commit {s}: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no work on stdx has measured them. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, whose syntax and reading of invalid UTF-8 are RE2's. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.\n\n", .{rebar.commit});
    const stdx: Stdx = .{ .first = try held.Held.create(arena, features), .again = try held.Held.create(arena, features) };
    for ([_]Set{ curated, others }) |set| {
        try report_section(io, out, arena, files, stdx, set, .searches);
        try report_section(io, out, arena, files, stdx, set, .compiles);
    }
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

test "haystack_of trims, then cuts the lines, then appends, in rebar's order" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const files = [_]File{.{ .name = "rebar/haystacks/h.txt", .octets = "\n a\nb\nc \n" }};
    const file: rebar.Haystack = .{ .file = .{ .path = "h.txt", .trim = true, .line_start = 1, .append = "Z" } };
    try testing.expectEqualStrings("b\ncZ", try haystack_of(arena, &files, file));
    const text: rebar.Haystack = .{ .text = .{ .octets = "ab", .repeat = 2, .append = "!" } };
    try testing.expectEqualStrings("abab!", try haystack_of(arena, &files, text));
}

test "pattern_of puts a file's prepend and append around its alternation" {
    var arena_state = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const files = [_]File{.{ .name = "rebar/regexes/k.txt", .octets = "if\nfor\n" }};
    const bench: rebar.Bench = .{
        .name = "test",
        .model = .count,
        .pattern = .{ .file = .{ .path = "k.txt", .alternate = true, .prepend = "\\b(", .append = ")\\b" } },
        .case_insensitive = true,
        .haystack = .{ .text = .{ .octets = "" } },
        .count = .all(0),
    };
    try testing.expectEqualStrings("(?i)\\b((?:if)|(?:for))\\b", try pattern_of(arena, &files, bench, true));
    try testing.expectEqualStrings("\\b((?:if)|(?:for))\\b", try pattern_of(arena, &files, bench, false));
}

test "admit times each candidate whose answer is its engine's count, and names the others" {
    var row: Row = .{ .cells = @splat(.untimed) };
    const context: u8 = 0;
    const operation: timing.Operation = .{ .context = &context, .run_once = run_nothing };
    // stdx gives RE2's count, Rust's crate gives Go's and not its own, Go gives its own, and stdx
    // again refuses the pattern.
    const counts: rebar.Counts = .{ .go = 4, .rust = 3, .re2 = 5 };
    const answers = [timed.len]?u64{ 5, 4, 4, null };
    for (timed, answers) |engine, answer| admit(&row, engine, operation, answer, counts);
    try testing.expect(row.cells[@intFromEnum(Engine.stdx)] == .timed);
    try testing.expect(row.cells[@intFromEnum(Engine.rust)] == .differs);
    try testing.expect(row.cells[@intFromEnum(Engine.go)] == .timed);
    try testing.expect(row.cells[@intFromEnum(Engine.stdx_again)] == .refused);
    try testing.expectEqual(@as(usize, 2), row.timed);
}

fn run_nothing(_: *const anyopaque) void {}

test "count_of gives Go's regexp, Rust's crate and stdx the counts of their engines" {
    const counts: rebar.Counts = .{ .go = 4, .rust = 3, .re2 = 2 };
    try testing.expectEqual(@as(u64, 4), count_of(counts, .go));
    try testing.expectEqual(@as(u64, 3), count_of(counts, .rust));
    try testing.expectEqual(@as(u64, 2), count_of(counts, .stdx));
    try testing.expectEqual(@as(u64, 2), count_of(counts, .stdx_again));
}

test "print_count writes one count, or each engine's where rebar gives them different counts" {
    var buffer: [256]u8 = undefined;
    var out: std.Io.Writer = .fixed(&buffer);
    var bench: rebar.Bench = .{ .name = "a", .model = .count, .pattern = .{ .text = "" }, .haystack = .{ .text = .{ .octets = "" } }, .count = .all(7) };
    try print_count(&out, bench);
    bench.count = .{ .go = 4, .rust = 3, .re2 = 2 };
    try print_count(&out, bench);
    try testing.expectEqualStrings("| a | 7 || a | Go 4, Rust 3, RE2 2 |", out.buffered());
}
