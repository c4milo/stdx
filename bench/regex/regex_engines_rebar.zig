//! The held-out set's candidates (decision 86 as amended): stdx's `regex`, Rust's `regex` crate
//! and Go's regexp, each behind rebar's models (regex_rebar.zig). A call takes one whole haystack
//! and gives the model's answer, so a call into Rust or Go costs little beside its work.
//!
//! - count: the matches, none inside another.
//! - count_spans: the sum of the matches' lengths in octets.
//! - count_captures: the groups that take part in each match, the whole match counted.
//! - grep: the lines that hold a match. A line ends at a line feed, which it does not hold, and
//!   a carriage return before the line feed is not part of the line either.
//! - grep_captures: count_captures over each line.
//! - compile: the pattern compiled and readied, then its count, which is the answer.
//!
//! Rust's crate takes rebar's `unicode` and `case-insensitive` options from its builder, with
//! the NFA size limit rebar's harness gives it. stdx and Go's regexp take a `(?i)` before the
//! pattern, as rebar's harness gives Go's regexp. Where `unicode` is off, rebar's harness runs
//! Rust's crate with no Unicode and RE2 in its Latin-1, and stdx runs in bytes, as Rust's crate
//! does. rebar records one count for the two modes on every such benchmark. Go's regexp has no
//! such mode.

const std = @import("std");
const codec = @import("codec");
const platform = @import("platform");
const regex = @import("regex");
const rebar = @import("regex_rebar.zig");

const Model = rebar.Model;

extern fn rust_rebar_new(pattern: [*]const u8, len: usize, unicode: bool, case_insensitive: bool) callconv(.c) ?*anyopaque;
extern fn rust_rebar_compile(pattern: [*]const u8, len: usize, unicode: bool, case_insensitive: bool) callconv(.c) bool;
extern fn rust_rebar_run(handle: *const anyopaque, model: u32, haystack: [*]const u8, len: usize) callconv(.c) u64;
extern fn go_regex_new(pattern: [*]const u8, len: usize) callconv(.c) usize;
extern fn go_regex_compile(pattern: [*]const u8, len: usize) callconv(.c) usize;
extern fn go_rebar_run(handle: usize, model: u32, haystack: [*]const u8, len: usize) callconv(.c) u64;

/// The instructions a held-out pattern takes at most: rebar's 2,663 words of 15 letters in one
/// alternation take about 40,000, and the date pattern under `(?i)` more.
const storage_len = 1 << 22;

/// stdx's side of a held-out pattern: its program in storage of its own, a searcher, and room
/// for its groups.
pub const Held = struct {
    storage: []regex.Instruction,
    memory: []u64 = &.{},
    program: regex.Program = undefined,
    searcher: regex.Searcher = undefined,
    features: platform.CpuFeatures,
    arena: std.mem.Allocator,

    pub fn create(arena: std.mem.Allocator, features: platform.CpuFeatures) !*Held {
        const held = try arena.create(Held);
        held.* = .{ .storage = try arena.alloc(regex.Instruction, storage_len), .features = features, .arena = arena };
        return held;
    }

    /// Compiles `pattern` and readies its searcher with the default cache: what a caller does
    /// before its first search. False where stdx refuses the pattern. The memory grows on the
    /// first call for a pattern, and a later call for it takes what the first left.
    pub fn ready(held: *Held, pattern: []const u8, encoding: regex.Encoding) bool {
        held.program = regex.compile(pattern, .{ .encoding = encoding }, held.storage) catch return false;
        const len = regex.Searcher.memory_len(held.program.forward_len, held.program.slot_count(), regex.constants.cache_words_default);
        if (held.memory.len < len) held.memory = held.arena.alloc(u64, len) catch return false;
        held.searcher.init(&held.program, &.{ .features = held.features }, held.memory[0..len]);
        return true;
    }

    pub fn run(held: *Held, model: Model, haystack: []const u8) u64 {
        return switch (model) {
            .count, .compile => held.count(haystack, false),
            .count_spans => held.count(haystack, true),
            .count_captures => held.count_captures(haystack),
            .grep => held.grep(haystack, false),
            .grep_captures => held.grep(haystack, true),
        };
    }

    /// The matches, or with `spans` the sum of their lengths.
    fn count(held: *Held, haystack: []const u8, spans: bool) u64 {
        var matches: regex.Matches = .{ .searcher = &held.searcher, .haystack = haystack };
        // rebar's `count` model takes the count alone, which rebar's runner asks Rust's crate for
        // with `find_iter(..).count()`: the crate finds each match's end alone, as
        // `Matches.count` does (claim R10).
        if (!spans) return matches.count();
        var sum: u64 = 0;
        while (matches.next()) |span| sum += span.len();
        return sum;
    }

    /// The groups that take part in each match. An empty match that touches the match before it
    /// is left out, as `regex.Matches` leaves it out.
    fn count_captures(held: *Held, haystack: []const u8) u64 {
        var sum: u64 = 0;
        var from: usize = 0;
        var last_end: ?u64 = null;
        // Each turn moves `from` on by an octet at least, or ends.
        for (0..haystack.len + 2) |_| {
            if (from > haystack.len) break;
            const groups = held.searcher.captures(haystack, from) orelse break;
            const span = groups.get(0).?;
            if (span.len() == 0 and last_end == span.end) {
                from = @intCast(span.end + 1);
                continue;
            }
            for (0..groups.len()) |index| sum += @intFromBool(groups.get(index) != null);
            from = @intCast(span.end);
            last_end = span.end;
        }
        return sum;
    }

    /// The lines that hold a match, or with `captures` the groups of every match of each line.
    fn grep(held: *Held, haystack: []const u8, captures: bool) u64 {
        var lines: Lines = .{ .rest = haystack };
        var sum: u64 = 0;
        while (lines.next()) |line| sum += if (captures) held.count_captures(line) else @intFromBool(held.searcher.is_match(line));
        return sum;
    }
};

/// A haystack's lines, as rebar's models split them: at each line feed, with a carriage return
/// before it left out, and no empty line after the last line feed.
pub const Lines = struct {
    rest: []const u8,

    pub fn next(lines: *Lines) ?[]const u8 {
        if (lines.rest.len == 0) return null;
        const end = std.mem.indexOfScalar(u8, lines.rest, '\n') orelse lines.rest.len;
        var line = lines.rest[0..end];
        lines.rest = lines.rest[@min(end + 1, lines.rest.len)..];
        if (line.len > 0 and line[line.len - 1] == '\r') line = line[0 .. line.len - 1];
        return line;
    }
};

/// Rust's crate with rebar's options, or null where it refuses the pattern.
pub fn rust_new(pattern: []const u8, bench: rebar.Bench) ?*anyopaque {
    return rust_rebar_new(pattern.ptr, pattern.len, bench.unicode, bench.case_insensitive);
}

/// The encoding stdx reads a benchmark in: bytes where rebar's `unicode` is off, as rebar's
/// harness gives Rust's crate, and UTF-8 where it is on.
pub fn encoding_of(bench: rebar.Bench) regex.Encoding {
    return if (bench.unicode) .utf8 else .bytes;
}

pub fn rust_compile(pattern: []const u8, bench: rebar.Bench) bool {
    return rust_rebar_compile(pattern.ptr, pattern.len, bench.unicode, bench.case_insensitive);
}

pub fn rust_run(handle: *const anyopaque, model: Model, haystack: []const u8) u64 {
    return rust_rebar_run(handle, @intFromEnum(model), haystack.ptr, haystack.len);
}

/// Go's regexp, or null where it refuses the pattern.
pub fn go_new(pattern: []const u8) ?usize {
    const handle = go_regex_new(pattern.ptr, pattern.len);
    return if (handle == 0) null else handle;
}

pub fn go_compile(pattern: []const u8) bool {
    return go_regex_compile(pattern.ptr, pattern.len) != 0;
}

pub fn go_run(handle: usize, model: Model, haystack: []const u8) u64 {
    return go_rebar_run(handle, @intFromEnum(model), haystack.ptr, haystack.len);
}

const testing = std.testing;

fn expect_lines(haystack: []const u8, expected: []const []const u8) !void {
    var lines: Lines = .{ .rest = haystack };
    for (expected) |line| try testing.expectEqualStrings(line, lines.next().?);
    try testing.expectEqual(null, lines.next());
}

test "a haystack's lines end at a line feed, drop a carriage return, and leave no empty last line" {
    try expect_lines("a\nb", &.{ "a", "b" });
    try expect_lines("a\r\nb\n", &.{ "a", "b" });
    try expect_lines("a\n\nb\n", &.{ "a", "", "b" });
    try expect_lines("\n", &.{""});
    try expect_lines("", &.{});
    try expect_lines("a\r", &.{"a"});
}

test "stdx reads a benchmark in bytes where rebar's unicode is off, and in UTF-8 where it is on" {
    var bench = rebar.curated[0];
    bench.unicode = false;
    try testing.expectEqual(regex.Encoding.bytes, encoding_of(bench));
    bench.unicode = true;
    try testing.expectEqual(regex.Encoding.utf8, encoding_of(bench));
}
