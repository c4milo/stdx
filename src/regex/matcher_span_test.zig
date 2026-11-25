//! The matcher's search for a span alone, which keeps `group_slots` slots a thread and copies
//! them by two moves (`copy_slots`): it gives the span that a search for every group gives, from
//! every offset.
const std = @import("std");
const testing = std.testing;
const matcher_test = @import("matcher_test.zig");
const Fixture = matcher_test.Fixture;

/// Patterns whose threads carry different starts from one position to the next: a loop, an
/// alternation whose branches end apart, and a class.
const patterns = [_][]const u8{ "a+b", "x(?:ab|a)c", "[0-9]+", "(?:a|ab)(?:c|bcd)", "b(a)*?c" };

const texts = [_][]const u8{ "", "aab", "xabcxac", "12 345 6", "abcd ac abcd", "baac bc" };

test "a search for the span alone gives the span a search for every group gives" {
    var span: Fixture = .{};
    var groups: Fixture = .{};
    var matches: usize = 0;
    for (patterns) |pattern| {
        try span.init(pattern, .{ .captures = .span });
        try groups.init(pattern, .{ .captures = .groups });
        for (texts) |text| {
            for (0..text.len + 1) |from| {
                const expected = groups.matcher.find(text, from);
                try testing.expectEqual(expected, span.matcher.find(text, from));
                matches += @intFromBool(expected != null);
            }
        }
    }
    // Most searches find a match, so the spans are compared and not only their absence.
    try testing.expect(matches > patterns.len * texts.len);
}
