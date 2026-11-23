//! Tests of a match's groups (`Groups`): a pattern of many groups gives each group as the matcher
//! gives it, read in place from the searcher's slots.
const std = @import("std");
const testing = std.testing;
const constants = @import("../constants.zig");
const compiler = @import("../compile.zig");
const program_file = @import("../program.zig");
const matcher_file = @import("../matcher.zig");
const Matcher = matcher_file.Matcher;
const Searcher = @import("searcher.zig").Searcher;

/// Eighteen groups and the whole match. Each match sets the whole match's group and one other.
const pattern = "(a)|(b)|(c)|(d)|(e)|(f)|(g)|(h)|(i)|(j)|(k)|(l)|(m)|(n)|(o)|(p)|(qq)|(r)z?";

/// The instructions of the pattern at most, its groups with the whole match, and the cache.
const storage_len = 512;
const groups_len = 19;
const cache_words = 4096;

threadlocal var storage: [storage_len]program_file.Instruction = undefined;
threadlocal var memory: [Searcher.memory_len(storage_len, groups_len * constants.group_slots, cache_words)]u64 = undefined;
threadlocal var reference_memory: [Matcher.memory_len(storage_len, groups_len * constants.group_slots)]u64 = undefined;

test "a match's groups are those the matcher gives, for a pattern of many groups" {
    const program = try compiler.compile(pattern, .{}, &storage);
    try testing.expectEqual(@as(u32, groups_len), program.group_count);
    var searcher: Searcher = undefined;
    searcher.init(&program, &.{ .features = .{} }, &memory);
    var reference: Matcher = undefined;
    reference.init(&program, .{ .captures = .groups }, &reference_memory);
    const haystack = "xa b qq rz h p q r";
    for (0..haystack.len + 1) |from| {
        const expected = reference.find(haystack, from);
        const found = searcher.captures(haystack, from);
        try testing.expectEqual(expected != null, found != null);
        const groups = found orelse continue;
        try testing.expectEqual(@as(usize, groups_len), groups.len());
        for (0..groups_len) |index| try testing.expectEqual(reference.group(@intCast(index)), groups.get(index));
    }
}

test "a program of no group but the whole match takes its group from the DFAs" {
    const program = try compiler.compile("a+b", .{}, &storage);
    try testing.expectEqual(@as(u32, 1), program.group_count);
    var searcher: Searcher = undefined;
    searcher.init(&program, &.{ .features = .{} }, &memory);
    const groups = searcher.captures("xaab ab", 1) orelse return error.TestNoMatch;
    try testing.expectEqual(@as(usize, 1), groups.len());
    try testing.expectEqual(@as(?matcher_file.Span, .{ .start = 1, .end = 4 }), groups.get(0));
    // The matcher took no part: it has finished no search.
    try testing.expect(!searcher.matcher.finished);
}
