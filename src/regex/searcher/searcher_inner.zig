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
//! text it meets, so each searcher keeps an account of its searches, and the claim rests or is
//! dropped where it loses (searcher_account.zig).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Span = @import("../matcher.zig").Span;
const Literal = @import("../literal.zig").Literal;
const Dfa = @import("../dfa/dfa.zig").Dfa;
const dfa_reverse = @import("../dfa/dfa_reverse.zig");
const dfa_second = @import("../dfa/dfa_second.zig");
const searcher_account = @import("searcher_account.zig");
const Account = searcher_account.Account;
const Found = searcher_account.Found;

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
    // A search pays for its start as for a place: its calls cost as much, and a text of short
    // lines with no place would pay nothing for them.
    var paid: usize = constants.account_place_bytes;
    // Each turn goes on from one byte past the place before, so the turns are at most the bytes
    // from `from` and one.
    for (0..haystack.len - from + 1) |_| {
        const place = literal.find(haystack, at) orelse break;
        paid += constants.account_place_bytes;
        // The plain search answers where the next place stands before the byte the last forward
        // scan stopped at, and where the places cost more than the account holds. It reads the
        // text again from `from`, so this search gained nothing for what it paid.
        if (place < read_to or account.overdrawn(place - from, paid)) {
            account.settle(0, paid);
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
/// and forward from that start. Out of line, so that a search of a text with no place sets up
/// no frame for the scans.
noinline fn scan_place(forward: *Dfa, reverse: *Dfa, haystack: []const u8, from: usize, place: usize) Place {
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
