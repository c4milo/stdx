//! The account of a claim that goes to the places of a literal, and may lose by it (decision
//! 86): claim R4's second and third rules, and claim R14.
//!
//! A search from the places pays where they stand far apart. It loses where they stand close
//! together, where a scan from a place reads far and finds no match, and on a text too short
//! to hide the cost of its start. A pattern does not say which text it meets. So a searcher
//! keeps an account of the claim's searches, and the claim rests where it loses, as claim R1's
//! skip rests (dfa_wait.zig).
//!
//! A searcher with such a claim pays a call for each search, at rest too. So a claim that
//! loses after its longest rest is dropped, and the searcher takes the search it had before.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Span = @import("../matcher.zig").Span;
const Literal = @import("../literal.zig").Literal;

/// What a search from a literal's places found.
pub const Found = union(enum) {
    /// The first match at or after `from`, or that the text holds none.
    answer: ?Span,
    /// The claim rests, or the search left the places: the plain search answers.
    plain,
    /// A DFA gave up.
    gave_up,
};

/// One searcher's account of such a claim, in bytes of a plain scan. A search from the places
/// that answers gains the bytes of text it covered, which a plain scan reads one by one. It
/// pays `account_place_bytes` for each place, `account_miss_bytes` for each candidate of the
/// literal that held no place, and the bytes of each forward scan that found no match. A search
/// that leaves its places to the plain search gains nothing.
pub const Account = struct {
    /// What the claim holds: the credit of `account_credit_bytes` it starts a trial with, and
    /// what its searches gained less what they paid, up to `account_balance_max`.
    balance: usize = constants.account_credit_bytes,
    /// The bytes of text the plain search still covers before the claim tries again. Zero
    /// while the claim searches.
    rest: usize = 0,
    /// The trials that lost one after another: each doubles the rest, up to
    /// `account_rest_doublings_max` times.
    poor_trials: u8 = 0,
    /// True once a trial lost after the longest rest: the claim loses on this searcher's
    /// texts, and the searcher drops it.
    dropped: bool = false,

    /// True when a search that covered `covered` bytes and paid `paid` has lost more than the
    /// account holds.
    pub fn overdrawn(account: *const Account, covered: usize, paid: usize) bool {
        return account.balance + covered < paid;
    }

    /// Closes a search from the places, which covered `covered` bytes and paid `paid`. A
    /// search that lost more than the account holds starts a rest, or drops the claim where
    /// the rest before it was the longest. An account at `account_balance_max` has earned back
    /// what a trial may lose, so its next rest is the first one's.
    pub fn settle(account: *Account, covered: usize, paid: usize) void {
        assert(account.rest == 0 and !account.dropped);
        if (account.overdrawn(covered, paid)) {
            if (account.poor_trials > constants.account_rest_doublings_max) {
                account.dropped = true;
                return;
            }
            account.rest = @as(usize, constants.account_rest_bytes) << @intCast(account.poor_trials);
            account.poor_trials += 1;
            account.balance = constants.account_credit_bytes;
            return;
        }
        account.balance = @min(account.balance + covered - paid, constants.account_balance_max);
        if (account.balance == constants.account_balance_max) account.poor_trials = 0;
    }

    /// Counts `covered` bytes of text that a plain search covered toward the rest. The claim
    /// tries again once the rest is over.
    pub fn pass(account: *Account, covered: usize) void {
        account.rest -|= covered;
    }
};

/// The next place of `literal` at or after `from`, with each candidate that held no place
/// charged to `paid`. A literal whose octets the text holds often has many such candidates,
/// and a search of a text with no place would otherwise seem to gain its bytes for nothing.
pub fn find_charged(literal: *const Literal, haystack: []const u8, from: usize, paid: *usize) ?usize {
    var misses: usize = 0;
    const place = literal.find_counting(haystack, from, &misses);
    // Most searches meet no such candidate, and pay nothing here.
    if (misses != 0) {
        assert(misses <= haystack.len - from);
        paid.* +|= misses *| constants.account_miss_bytes;
    }
    return place;
}

const testing = std.testing;

/// What a test's search pays past what the account holds: the least that starts a rest.
const test_loss = constants.account_credit_bytes + 1;

test "an account keeps what its searches gained less what they paid, up to its bound" {
    var account: Account = .{};
    try testing.expectEqual(@as(usize, constants.account_credit_bytes), account.balance);
    account.settle(100, constants.account_place_bytes);
    try testing.expectEqual(@as(usize, constants.account_credit_bytes + 100 - constants.account_place_bytes), account.balance);
    // A search that pays all the account holds and all it covered leaves nothing, and no rest.
    account.settle(7, account.balance + 7);
    try testing.expectEqual(@as(usize, 0), account.balance);
    try testing.expect(account.rest == 0 and account.poor_trials == 0 and !account.dropped);
    try testing.expect(!account.overdrawn(7, 7) and account.overdrawn(7, 8));
    // A gain past the bound stops there.
    account.settle(constants.account_balance_max + 1, 0);
    try testing.expectEqual(@as(usize, constants.account_balance_max), account.balance);
}

test "a search that loses more than the account holds starts a rest, and the plain search's text ends it" {
    var account: Account = .{};
    // A gain first, so that the account holds more than its credit when the search loses.
    account.settle(constants.account_place_bytes, 0);
    account.settle(0, account.balance + 1);
    try testing.expectEqual(@as(usize, constants.account_rest_bytes), account.rest);
    try testing.expectEqual(@as(u8, 1), account.poor_trials);
    // The next trial starts with the credit, and with nothing of what the account held.
    try testing.expectEqual(@as(usize, constants.account_credit_bytes), account.balance);
    account.pass(constants.account_rest_bytes - 1);
    try testing.expectEqual(@as(usize, 1), account.rest);
    // A search that covers more than is left ends the rest, and leaves no debt.
    account.pass(constants.account_rest_bytes);
    try testing.expectEqual(@as(usize, 0), account.rest);
    try testing.expect(!account.dropped);
}

test "each trial that loses after another doubles the rest, and one that loses after the longest drops the claim" {
    var account: Account = .{};
    for (0..constants.account_rest_doublings_max + 1) |trial| {
        account.settle(0, test_loss);
        try testing.expectEqual(@as(usize, constants.account_rest_bytes) << @intCast(trial), account.rest);
        try testing.expect(!account.dropped);
        account.pass(account.rest);
    }
    account.settle(0, test_loss);
    try testing.expect(account.dropped and account.rest == 0);
}

test "a trial that earns the account's bound makes the next rest the first one's" {
    var account: Account = .{};
    account.settle(0, test_loss);
    account.pass(account.rest);
    account.settle(0, test_loss);
    account.pass(account.rest);
    try testing.expectEqual(@as(u8, 2), account.poor_trials);
    // One byte short of the bound keeps the count of the trials that lost.
    account.settle(constants.account_balance_max - constants.account_credit_bytes - 1, 0);
    try testing.expectEqual(@as(u8, 2), account.poor_trials);
    account.settle(1, 0);
    try testing.expectEqual(@as(u8, 0), account.poor_trials);
    account.settle(0, constants.account_balance_max + 1);
    try testing.expectEqual(@as(usize, constants.account_rest_bytes), account.rest);
}

test "find_charged charges each candidate that held no place, and gives the place" {
    var literal: Literal = .{ .octets = undefined, .len = 3, .exact = true };
    @memcpy(literal.octets[0..3], "x:y");
    literal.prepare();
    // Each copy changes the octet at neither compared offset: a candidate and no place.
    var text = "x:y x:y x:y x:y".*;
    const other = 3 - literal.first_at - literal.last_at;
    for (0..3) |copy| text[copy * "x:y ".len + other] = '!';
    var paid: usize = 1;
    try testing.expectEqual(@as(?usize, 12), find_charged(&literal, &text, 0, &paid));
    try testing.expectEqual(@as(usize, 1 + 3 * constants.account_miss_bytes), paid);
    paid = 0;
    try testing.expectEqual(@as(?usize, null), find_charged(&literal, text[0..11], 4, &paid));
    try testing.expectEqual(@as(usize, 2 * constants.account_miss_bytes), paid);
    paid = 0;
    try testing.expectEqual(@as(?usize, null), find_charged(&literal, text[0..11], 8, &paid));
    try testing.expectEqual(@as(usize, constants.account_miss_bytes), paid);
}
