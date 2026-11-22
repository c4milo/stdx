//! The fuzzer's test of `regex` (decision 15): any octets as a pattern compile or are refused, and
//! over any octets as a text, the searcher's faster ways and a text cut into pieces give what the
//! matcher gives over the text whole.
const std = @import("std");
const testing = std.testing;
const matcher_test = @import("matcher_test.zig");
const searcher_test = @import("searcher/searcher_test.zig");
const Span = @import("matcher.zig").Span;

/// The longest pattern and the longest text the fuzzer gives.
const pattern_len_max = 64;
const text_len_max = 96;

test "fuzz regex: the searcher and a text in pieces against the matcher" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{
        "",
        "a+b",
        "(a|ab)(c|bcd)(d*)",
        "\\bfoo\\b",
        "[^a-c]{2,3}?$",
        "(?i)x(?-i)y|\\B",
        "(a*)*b",
        "\xE6\x97\xA5.+",
    } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var pattern: [pattern_len_max]u8 = undefined;
    const pattern_len = smith.slice(&pattern);
    var text: [text_len_max]u8 = undefined;
    const text_len = smith.slice(&text);
    const seed = smith.value(u64);
    var fixture: searcher_test.Fixture = .{};
    fixture.init(pattern[0..pattern_len], 0) catch return;
    if (fixture.program.group_count > matcher_test.groups_len) return;
    const sizes = searcher_test.cache_sizes(&fixture.program);
    try fixture.init(pattern[0..pattern_len], if (seed & 1 == 0) sizes.least else sizes.most);
    try fixture.expect_agree_everywhere(text[0..text_len]);
    try expect_pieces_agree(&fixture, text[0..text_len], seed);
}

/// The matcher over the text in the pieces a seed draws, moved between calls, gives what it
/// gives over the text whole.
fn expect_pieces_agree(fixture: *searcher_test.Fixture, text: []const u8, seed: u64) !void {
    const whole = fixture.reference.find(text, 0);
    var groups: [matcher_test.groups_len]?Span = @splat(null);
    const count = fixture.program.group_count;
    if (whole != null) {
        for (groups[0..count], 0..) |*group, index| group.* = fixture.reference.group(@intCast(index));
    }
    var pieces: matcher_test.Fixture = .{};
    pieces.program = fixture.program;
    const ended = try matcher_test.search_split(&pieces, .{ .captures = .groups }, text, seed);
    if ((ended.status == .match) != (whole != null)) return error.TestPiecesDisagree;
    try testing.expectEqualSlices(?Span, groups[0..count], ended.groups[0..count]);
}
