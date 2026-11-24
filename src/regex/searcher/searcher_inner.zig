//! Claim R14 (decision 86): a search from the places of a literal that every match holds in its
//! middle, as `@` in `\w+@\w+`.
//!
//! At each place of the literal, the reverse DFA reads back through the part of the program
//! before the literal, from its second start, to the least start of that part. The forward DFA
//! then reads from that start, anchored there, and gives the match's end.
//!
//! - `dfa_suffix.holds` holds for the part before the literal. So one start has one place, a
//!   later place has a later start, and the first place whose two scans find a match gives the
//!   match that a forward search finds first (dfa_suffix.zig).
//! - A forward scan that finds no match from a start shows that no match holds the literal at
//!   that place: a match from a later start with the same place would give one from this start.
//! - A reverse scan stops as claim R4's does. A forward scan that finds no match may read far
//!   past its place. The search then leaves the places where the next one stands before the
//!   byte that scan stopped at, and the searcher's plain search answers. So each byte is read
//!   a bounded number of times, and the search stays linear in the text.
//!
//! A search from the places pays where the places stand far apart, and loses where they stand
//! close together or a forward scan reads far and finds no match. A pattern does not say which
//! text it meets, so each searcher keeps an `Account` of its searches, and the claim rests
//! where it loses, as claim R1's skip rests (dfa_wait.zig). A searcher with the claim pays a
//! call for each search, at rest too, so a claim that loses after its longest rest is dropped.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Span = @import("../matcher.zig").Span;
const Literal = @import("../literal.zig").Literal;
const Dfa = @import("../dfa/dfa.zig").Dfa;
const dfa_reverse = @import("../dfa/dfa_reverse.zig");
const dfa_second = @import("../dfa/dfa_second.zig");

/// What a search from the literal's places found.
pub const Found = union(enum) {
    /// The first match at or after `from`, or that the text holds none.
    answer: ?Span,
    /// The claim rests, or the search left the places: the plain search answers.
    plain,
    /// A DFA gave up.
    gave_up,
};

/// One searcher's account of claim R14, in bytes of a plain scan. A search from the places
/// gains the bytes of text it covered, which a plain scan reads one by one. It pays
/// `inner_place_bytes` for each place, and the bytes of each forward scan that found no match.
pub const Account = struct {
    /// What the claim holds: the credit of `inner_credit_bytes` it starts a trial with, and
    /// what its searches gained less what they paid, up to `inner_balance_max`.
    balance: usize = constants.inner_credit_bytes,
    /// The bytes of text the plain search still covers before the claim tries again. Zero
    /// while the claim searches.
    rest: usize = 0,
    /// The trials that lost one after another: each doubles the rest, up to
    /// `inner_rest_doublings_max` times.
    poor_trials: u8 = 0,
    /// True once a trial lost after the longest rest: the claim loses on this searcher's
    /// texts, and the searcher drops it.
    dropped: bool = false,

    /// True when a search that covered `covered` bytes and paid `paid` has lost more than the
    /// account holds.
    fn overdrawn(account: *const Account, covered: usize, paid: usize) bool {
        return account.balance + covered < paid;
    }

    /// Closes a search from the places, which covered `covered` bytes and paid `paid`. A
    /// search that lost more than the account holds starts a rest, or drops the claim where
    /// the rest before it was the longest. An account at `inner_balance_max` has earned back
    /// what a trial may lose, so its next rest is the first one's.
    fn settle(account: *Account, covered: usize, paid: usize) void {
        assert(account.rest == 0 and !account.dropped);
        if (account.overdrawn(covered, paid)) {
            if (account.poor_trials > constants.inner_rest_doublings_max) {
                account.dropped = true;
                return;
            }
            account.rest = @as(usize, constants.inner_rest_bytes) << @intCast(account.poor_trials);
            account.poor_trials += 1;
            account.balance = constants.inner_credit_bytes;
            return;
        }
        account.balance = @min(account.balance + covered - paid, constants.inner_balance_max);
        if (account.balance == constants.inner_balance_max) account.poor_trials = 0;
    }

    /// Counts `covered` bytes of text that a plain search covered toward the rest. The claim
    /// tries again once the rest is over.
    pub fn pass(account: *Account, covered: usize) void {
        account.rest -|= covered;
    }
};

/// What the two scans of one place found.
const Place = union(enum) {
    gave_up,
    /// No match holds the literal at the place, and the scans read no byte past it.
    none,
    /// No match holds the literal at the place. The forward scan read from `start` to `stop`.
    read: struct { start: usize, stop: usize },
    match: Span,
};

/// The first match at or after `from`, found from the places of `literal` in turn. `forward` and
/// `reverse` are the searcher's DFAs, and the reverse DFA's second start is the part of the
/// program before the literal.
pub fn find(account: *Account, forward: *Dfa, reverse: *Dfa, literal: *const Literal, haystack: []const u8, from: usize) Found {
    assert(from <= haystack.len);
    assert(!account.dropped);
    if (account.rest != 0) return .plain;
    var at = from;
    // Where the last forward scan that found no match stopped.
    var read_to = from;
    var paid: usize = 0;
    // Each turn goes on from one byte past the place before, so the turns are at most the bytes
    // from `from` and one.
    for (0..haystack.len - from + 1) |_| {
        const place = literal.find(haystack, at) orelse break;
        paid += constants.inner_place_bytes;
        // The plain search answers where the next place stands before the byte the last forward
        // scan stopped at, and where the places cost more than the account holds.
        if (place < read_to or account.overdrawn(place - from, paid)) {
            account.settle(place - from, paid);
            return .plain;
        }
        switch (scan_place(forward, reverse, haystack, from, place)) {
            .gave_up => return .gave_up,
            .none => {},
            .read => |scan| {
                read_to = scan.stop;
                paid += scan.stop - scan.start;
            },
            .match => |span| {
                account.settle(@as(usize, @intCast(span.end)) - from, paid);
                return .{ .answer = span };
            },
        }
        at = place + 1;
    }
    account.settle(haystack.len - from, paid);
    return .{ .answer = null };
}

/// The two scans of the literal's place at `place`: back to the start of the part before it,
/// and forward from that start.
fn scan_place(forward: *Dfa, reverse: *Dfa, haystack: []const u8, from: usize, place: usize) Place {
    const start = switch (dfa_reverse.scan_second(reverse, haystack, from, place)) {
        .gave_up => return .gave_up,
        .none => return .none,
        .found => |offset| offset,
    };
    return switch (dfa_second.scan_forward(forward, haystack, start)) {
        .gave_up => .gave_up,
        .found => |end| .{ .match = .{ .start = start, .end = end } },
        .none => |stop| .{ .read = .{ .start = start, .stop = stop } },
    };
}
