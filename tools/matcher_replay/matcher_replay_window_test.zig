//! Tests of the replay's claim lines of the window (src/regex/dfa/dfa_window.zig and
//! src/regex/dfa/dfa_window_set.zig): a searcher that read a long text must hold the literal,
//! or the set's ways, and the bound that the line names.
const std = @import("std");
const matcher_replay = @import("../matcher_replay.zig");
const matcher_replay_test = @import("matcher_replay_test.zig");
const Replay = matcher_replay.Replay;
const replay_text = matcher_replay.replay_text;
const answered_groups = matcher_replay_test.answered_groups;
const testing = std.testing;

test "a replay requires the searcher that read a long text to hold the ways of a claim windows line" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const window = try answered_groups(arena.allocator(), "(?:[a-z]xy|[a-z]zw)[a-c]", "0axyb", "find 0 1 5", "groups 0 1 1:5");
    const at = std.mem.indexOf(u8, window, "\nclaim windows ") orelse return error.TestExpectedWindow;
    const line = window[at + 1 ..][0..std.mem.indexOfScalar(u8, window[at + 1 ..], '\n').?];
    var replay = try Replay.init(arena.allocator());
    try testing.expect(replay_text(&replay, window) == null);
    try testing.expectEqual(@as(usize, 1), replay.claims);
    // Its words: the rule, the set's width, the bound, the ways' length and their bytes, the
    // first way's cut first.
    var words: std.ArrayList([]const u8) = .empty;
    var tokens = std.mem.tokenizeScalar(u8, line, ' ');
    while (tokens.next()) |word| try words.append(arena.allocator(), word);
    try testing.expectEqualStrings("2", words.items[2]);
    try testing.expectEqualStrings("1", words.items[3]);
    const lines = [_][]const u8{
        // Another width, another bound, another cut, and another byte of the last literal.
        try changed_word(arena.allocator(), words.items, 2, 1),
        try changed_word(arena.allocator(), words.items, 3, 2),
        try changed_word(arena.allocator(), words.items, 5, 1),
        try changed_word(arena.allocator(), words.items, words.items.len - 1, 1),
    };
    for (lines) |other| {
        const changed = try std.mem.replaceOwned(u8, arena.allocator(), window, line, other);
        try testing.expect(!std.mem.eql(u8, changed, window));
        var wrong = try Replay.init(arena.allocator());
        const failed = replay_text(&wrong, changed) orelse return error.TestExpectedFailure;
        try testing.expectEqual(error.ClaimDiffers, failed.cause);
    }
}

/// A line of `words` whose word at `at`, a number, is `more` larger.
fn changed_word(arena: std.mem.Allocator, words: []const []const u8, at: usize, more: u32) ![]const u8 {
    var out: std.ArrayList(u8) = .empty;
    for (words, 0..) |word, place| {
        if (place > 0) try out.append(arena, ' ');
        if (place != at) {
            try out.appendSlice(arena, word);
            continue;
        }
        try out.print(arena, "{d}", .{(try std.fmt.parseInt(u32, word, 10)) + more});
    }
    return out.items;
}

test "a replay requires the searcher that read a long text to hold the window of a claim line" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const window = try answered_groups(arena.allocator(), "[a-c]{0,3}ab[a-c]", "xcabc", "find 0 1 5", "groups 0 1 1:5");
    const at = std.mem.indexOf(u8, window, "\nclaim window ") orelse return error.TestExpectedWindow;
    const line = window[at + 1 ..][0..std.mem.indexOfScalar(u8, window[at + 1 ..], '\n').?];
    var replay = try Replay.init(arena.allocator());
    try testing.expect(replay_text(&replay, window) == null);
    try testing.expectEqual(@as(usize, 1), replay.claims);
    // Its words: the rule, `before`, the bound, the literal's length and its bytes.
    var words = std.mem.tokenizeScalar(u8, line, ' ');
    var parts: [7][]const u8 = undefined;
    for (&parts) |*part| part.* = words.next() orelse return error.TestExpectedWord;
    try testing.expectEqualStrings("3", parts[3]);
    const before = parts[2];
    const lines = [_][]const u8{
        // Another bound, another `before`, and another literal.
        try std.fmt.allocPrint(arena.allocator(), "claim window {s} 4 2 97 98", .{before}),
        try std.fmt.allocPrint(arena.allocator(), "claim window {d} 3 2 97 98", .{(try std.fmt.parseInt(u32, before, 10)) + 1}),
        try std.fmt.allocPrint(arena.allocator(), "claim window {s} 3 2 97 99", .{before}),
        // The same literal and bound under claim R14's word.
        try std.fmt.allocPrint(arena.allocator(), "claim inner {s} 2 97 98", .{before}),
    };
    for (lines) |other| {
        const changed = try std.mem.replaceOwned(u8, arena.allocator(), window, line, other);
        try testing.expect(!std.mem.eql(u8, changed, window));
        var wrong = try Replay.init(arena.allocator());
        const failed = replay_text(&wrong, changed) orelse return error.TestExpectedFailure;
        try testing.expectEqual(error.ClaimDiffers, failed.cause);
    }
}
