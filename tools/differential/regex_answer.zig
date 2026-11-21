//! What one engine makes of a pattern and a text, for `zig build differential-regex` (decision
//! 86), and stdx's side of the check: a pattern compiled once, and its match in each text by a
//! `regex.Searcher`.

const std = @import("std");
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

    /// Prints the answer, for a failure's line.
    pub fn print(answer: *const Answer) void {
        switch (answer.kind) {
            .refused => std.debug.print("refused {s}", .{answer.refusal}),
            .none => std.debug.print("no match", .{}),
            .match => for (0..answer.groups) |index| {
                std.debug.print("{s}{d}-{d}", .{ if (index == 0) "" else " ", answer.offsets[2 * index], answer.offsets[2 * index + 1] });
            },
        }
    }
};

/// stdx's side: one pattern at a time, compiled into storage of its own.
pub const Stdx = struct {
    storage: []regex.Instruction,
    /// A searcher's memory for the largest program the storage holds.
    memory: []u64,
    program: regex.Program = undefined,
    /// The name of the error `compile` gave the pattern, or nothing when it compiled.
    refusal: []const u8 = "",

    pub fn init(allocator: std.mem.Allocator) !Stdx {
        const memory_len = regex.Searcher.memory_len(storage_len, 2 * groups_max, regex.constants.cache_words_default);
        return .{
            .storage = try allocator.alloc(regex.Instruction, storage_len),
            .memory = try allocator.alloc(u64, memory_len),
        };
    }

    pub fn deinit(stdx: *Stdx, allocator: std.mem.Allocator) void {
        allocator.free(stdx.storage);
        allocator.free(stdx.memory);
    }

    pub fn compile(stdx: *Stdx, pattern: []const u8) void {
        stdx.refusal = "";
        stdx.program = regex.compile(pattern, .{}, stdx.storage) catch |err| {
            stdx.refusal = @errorName(err);
            return;
        };
        if (stdx.program.group_count > groups_max) stdx.refusal = groups_refusal;
    }

    /// The match of the compiled pattern in `text`, by a searcher with `cache_words` words of
    /// cache. With no cache the searcher has no DFA, and the matcher answers alone.
    pub fn answer(stdx: *Stdx, text: []const u8, cache_words: usize) Answer {
        if (stdx.refusal.len != 0) return .{ .kind = .refused, .refusal = stdx.refusal };
        const program = &stdx.program;
        var searcher: regex.Searcher = undefined;
        searcher.init(program, stdx.memory[0..regex.Searcher.memory_len(program.forward_len, program.slot_count(), cache_words)]);
        var groups: [groups_max]?regex.Span = undefined;
        if (!searcher.captures(text, 0, groups[0..program.group_count])) return .{ .kind = .none };
        var result: Answer = .{ .kind = .match, .groups = program.group_count };
        for (groups[0..program.group_count], 0..) |group, index| {
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
    for ([_]usize{ regex.constants.cache_words_default, 0 }) |cache_words| {
        const found = stdx.answer("xb", cache_words);
        try testing.expectEqual(Answer.Kind.match, found.kind);
        try testing.expectEqualSlices(i64, &.{ 1, 2, -1, -1, 1, 2 }, found.offsets[0 .. 2 * found.groups]);
        try testing.expectEqual([2]usize{ 1, 2 }, found.whole().?);
        try testing.expectEqual(Answer.Kind.none, stdx.answer("c", cache_words).kind);
    }
    stdx.compile("\\C");
    const refused = stdx.answer("a", 0);
    try testing.expectEqual(Answer.Kind.refused, refused.kind);
    try testing.expectEqualStrings("InvalidEscape", refused.refusal);
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
