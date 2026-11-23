//! Tests of the copy of a match's groups (`copy_groups`): a pattern of more groups than one
//! compare judges gives each group as the matcher gives it.
const std = @import("std");
const testing = std.testing;
const constants = @import("../constants.zig");
const compiler = @import("../compile.zig");
const program_file = @import("../program.zig");
const matcher_file = @import("../matcher.zig");
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;
const Searcher = @import("searcher.zig").Searcher;

/// Eighteen groups and the whole match: two blocks of eight that one compare judges, and three
/// groups after them. Each match sets the whole match's group and one other.
const pattern = "(a)|(b)|(c)|(d)|(e)|(f)|(g)|(h)|(i)|(j)|(k)|(l)|(m)|(n)|(o)|(p)|(qq)|(r)z?";

/// The instructions of the pattern at most, its groups with the whole match, and the cache.
const storage_len = 512;
const groups_len = 19;
const cache_words = 4096;

threadlocal var storage: [storage_len]program_file.Instruction = undefined;
threadlocal var memory: [Searcher.memory_len(storage_len, groups_len * constants.group_slots, cache_words)]u64 = undefined;
threadlocal var reference_memory: [Matcher.memory_len(storage_len, groups_len * constants.group_slots)]u64 = undefined;

test "a match's groups are those the matcher gives, where the pattern has more than copy_lanes" {
    const program = try compiler.compile(pattern, .{}, &storage);
    try testing.expectEqual(@as(u32, groups_len), program.group_count);
    var searcher: Searcher = undefined;
    searcher.init(&program, &.{ .features = .{} }, &memory);
    var reference: Matcher = undefined;
    reference.init(&program, .{ .captures = .groups }, &reference_memory);
    const haystack = "xa b qq rz h p q r";
    var groups: [groups_len]?Span = undefined;
    for (0..haystack.len + 1) |from| {
        const expected = reference.find(haystack, from);
        try testing.expectEqual(expected != null, searcher.captures(haystack, from, &groups));
        if (expected == null) continue;
        for (groups, 0..) |group, index| try testing.expectEqual(reference.group(@intCast(index)), group);
    }
}
