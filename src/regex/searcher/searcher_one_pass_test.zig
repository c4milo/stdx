//! Tests of claim R6 (decision 86): a searcher that finds the groups of a one-pass pattern by one
//! thread gives what the matcher gives, and takes that way only where it holds.
const std = @import("std");
const testing = std.testing;
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;

test "a searcher gives the groups of a one-pass pattern by one thread, and of others by the matcher" {
    var fixture: Fixture = .{};
    const date = "^([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2})Z$";
    try fixture.init(date, 0);
    const words = searcher_test.cache_sizes(&fixture.program).most;
    try fixture.init(date, words);
    // `init` leaves the judgment to the first `captures`.
    try testing.expectEqual(.unknown, fixture.searcher.one_pass);
    try fixture.expect_agree("2026-11-22T03:04:05Z", 0);
    try testing.expectEqual(.at_text, fixture.searcher.one_pass);
    // The matcher's threads take no step: one thread finds the groups, with no DFA.
    fixture.searcher.matcher.work = 0;
    try fixture.expect_agree("2026-11-22T03:04:05Z", 0);
    try fixture.expect_agree("2026-11-22T03:04:05", 0);
    try testing.expectEqual(@as(@TypeOf(fixture.searcher.matcher.work), 0), fixture.searcher.matcher.work);
    // A one-pass pattern that may start anywhere: the DFAs find the start, one thread the groups.
    try fixture.init("([0-9]{2}):([0-9]{2})", words);
    try fixture.expect_agree("at 03:04 and 05:06", 0);
    try testing.expectEqual(.yes, fixture.searcher.one_pass);
    fixture.searcher.matcher.work = 0;
    try fixture.expect_agree("at 03:04 and 05:06", 0);
    try testing.expectEqual(@as(@TypeOf(fixture.searcher.matcher.work), 0), fixture.searcher.matcher.work);
    // Two threads may take one octet, so the matcher finds the groups.
    try fixture.init("(a|ab)(c)", words);
    try fixture.expect_agree("xabc", 0);
    try testing.expectEqual(.no, fixture.searcher.one_pass);
    try fixture.init_with(date, .{ .one_pass = false }, words);
    try testing.expectEqual(.no, fixture.searcher.one_pass);
    try fixture.expect_agree("2026-11-22T03:04:05Z", 0);
}
