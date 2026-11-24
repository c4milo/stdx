//! What one engine makes of a pattern and a text, for `zig build differential-regex` (decision
//! 86), and stdx's side of the check: a pattern compiled once, and its match in each text by two
//! searchers that live as long as the pattern. One has a cache, so the states its DFAs build for
//! one text serve the next. The other has none, so the matcher answers alone.

const std = @import("std");
const codec = @import("codec");
const platform = @import("platform");
const regex = @import("regex");

/// The most groups the pattern of a case holds, the whole match counted.
pub const groups_max = 64;

/// The instructions the program of a case may take.
const storage_len = 1 << 16;

/// What `Stdx.compile` says of a pattern with more groups than `groups_max`.
const groups_refusal = "more groups than the check holds";

/// An engine's verdict on a pattern and a text.
pub const Answer = struct {
    kind: Kind,
    /// The name of stdx's error, when stdx refused the pattern.
    refusal: []const u8 = "",
    /// The groups of a match, the whole match first.
    groups: usize = 0,
    /// The start and the end of each group, -1 twice where a group took no part.
    offsets: [2 * groups_max]i64 = undefined,

    pub const Kind = enum { refused, none, match };

    /// True when two engines say the same: both refuse, both find nothing, or both find the same
    /// groups at the same offsets.
    pub fn eql(a: *const Answer, b: *const Answer) bool {
        if (a.kind != b.kind) return false;
        if (a.kind != .match) return true;
        return a.groups == b.groups and std.mem.eql(i64, a.offsets[0 .. 2 * a.groups], b.offsets[0 .. 2 * b.groups]);
    }

    /// The start and the end of the whole match.
    pub fn whole(answer: *const Answer) ?[2]usize {
        if (answer.kind != .match) return null;
        return .{ @intCast(answer.offsets[0]), @intCast(answer.offsets[1]) };
    }

    /// Writes the answer, for a failure's line.
    pub fn write(answer: *const Answer, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        switch (answer.kind) {
            .refused => try writer.print("refused {s}", .{answer.refusal}),
            .none => try writer.writeAll("no match"),
            .match => for (0..answer.groups) |index| {
                try writer.print("{s}{d}-{d}", .{ if (index == 0) "" else " ", answer.offsets[2 * index], answer.offsets[2 * index + 1] });
            },
        }
    }
};

/// The two ways stdx answers: a searcher with a cache for its DFAs, and one with none.
pub const Way = enum { cached, alone };

/// stdx's side: one pattern at a time, compiled into storage of its own. A `Stdx` stays where it
/// is while it holds a pattern: its searchers point at its program.
pub const Stdx = struct {
    storage: []regex.Instruction,
    /// Each searcher's memory, for the largest program the storage holds.
    memory: [way_count][]u64,
    program: regex.Program = undefined,
    searchers: [way_count]regex.Searcher = undefined,
    /// The name of the error `compile` gave the pattern, or nothing when it compiled.
    refusal: []const u8 = "",
    /// The host's CPU features, detected once, so that the check holds each search the host
    /// runs to the oracle.
    features: platform.CpuFeatures = .{},

    const way_count = std.meta.fields(Way).len;

    fn cache_words(way: Way) usize {
        return switch (way) {
            .cached => regex.constants.cache_words_default,
            .alone => 0,
        };
    }

    pub fn init(allocator: std.mem.Allocator) !Stdx {
        var stdx: Stdx = .{ .storage = try allocator.alloc(regex.Instruction, storage_len), .memory = undefined, .features = platform.CpuFeatures.detect() };
        for (&stdx.memory, 0..) |*memory, way| {
            memory.* = try allocator.alloc(u64, regex.Searcher.memory_len(storage_len, 2 * groups_max, cache_words(@enumFromInt(way))));
        }
        return stdx;
    }

    pub fn deinit(stdx: *Stdx, allocator: std.mem.Allocator) void {
        allocator.free(stdx.storage);
        for (stdx.memory) |memory| allocator.free(memory);
    }

    pub fn compile(stdx: *Stdx, pattern: []const u8) void {
        stdx.refusal = "";
        stdx.program = regex.compile(pattern, .{}, stdx.storage) catch |err| {
            stdx.refusal = @errorName(err);
            return;
        };
        if (stdx.program.group_count > groups_max) {
            stdx.refusal = groups_refusal;
            return;
        }
        const program = &stdx.program;
        for (&stdx.searchers, stdx.memory, 0..) |*searcher, memory, way| {
            const len = regex.Searcher.memory_len(program.forward_len, program.slot_count(), cache_words(@enumFromInt(way)));
            searcher.init(program, &.{ .features = stdx.features }, memory[0..len]);
        }
    }

    /// The match of the compiled pattern in `text`, by one of the pattern's two searchers.
    pub fn answer(stdx: *Stdx, text: []const u8, way: Way) Answer {
        if (stdx.refusal.len != 0) return .{ .kind = .refused, .refusal = stdx.refusal };
        const program = &stdx.program;
        const searcher = &stdx.searchers[@intFromEnum(way)];
        const groups = searcher.captures(text, 0) orelse return .{ .kind = .none };
        var result: Answer = .{ .kind = .match, .groups = program.group_count };
        for (0..groups.len()) |index| {
            const group = groups.get(index);
            result.offsets[2 * index] = if (group) |span| @intCast(span.start) else -1;
            result.offsets[2 * index + 1] = if (group) |span| @intCast(span.end) else -1;
        }
        return result;
    }
};

const testing = std.testing;

test "Stdx gives a match's groups, no match, and a refusal by its error's name" {
    var stdx = try Stdx.init(testing.allocator);
    defer stdx.deinit(testing.allocator);
    stdx.compile("(a)|(b)");
    for ([_]Way{ .cached, .alone }) |way| {
        // A second text, and the first again: a searcher serves each text of its pattern.
        for (0..2) |_| {
            const found = stdx.answer("xb", way);
            try testing.expectEqual(Answer.Kind.match, found.kind);
            try testing.expectEqualSlices(i64, &.{ 1, 2, -1, -1, 1, 2 }, found.offsets[0 .. 2 * found.groups]);
            try testing.expectEqual([2]usize{ 1, 2 }, found.whole().?);
            try testing.expectEqual(Answer.Kind.none, stdx.answer("c", way).kind);
        }
    }
    stdx.compile("\\C");
    const refused = stdx.answer("a", .alone);
    try testing.expectEqual(Answer.Kind.refused, refused.kind);
    try testing.expectEqualStrings("InvalidEscape", refused.refusal);
}

test "write spells a refusal, no match, and each group of a match" {
    var buffer: [64]u8 = undefined;
    var writer: std.Io.Writer = .fixed(&buffer);
    var found: Answer = .{ .kind = .match, .groups = 2 };
    found.offsets[0..4].* = .{ 0, 3, -1, -1 };
    try found.write(&writer);
    try writer.writeAll("; ");
    try (Answer{ .kind = .none }).write(&writer);
    try writer.writeAll("; ");
    try (Answer{ .kind = .refused, .refusal = "InvalidEscape" }).write(&writer);
    try testing.expectEqualStrings("0-3 -1--1; no match; refused InvalidEscape", writer.buffered());
}

test "eql compares the kind, and the groups of two matches" {
    var one: Answer = .{ .kind = .match, .groups = 1 };
    one.offsets[0] = 0;
    one.offsets[1] = 2;
    var other = one;
    try testing.expect(one.eql(&other));
    other.offsets[1] = 3;
    try testing.expect(!one.eql(&other));
    const none: Answer = .{ .kind = .none };
    try testing.expect(!one.eql(&none));
    const refused: Answer = .{ .kind = .refused, .refusal = "InvalidEscape" };
    const refused_too: Answer = .{ .kind = .refused };
    try testing.expect(refused.eql(&refused_too));
}
