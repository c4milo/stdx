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
const std = @import("std");
const assert = std.debug.assert;
const Span = @import("../matcher.zig").Span;
const Literal = @import("../literal.zig").Literal;
const Dfa = @import("../dfa/dfa.zig").Dfa;
const dfa_reverse = @import("../dfa/dfa_reverse.zig");
const dfa_second = @import("../dfa/dfa_second.zig");

/// What a search from the literal's places found.
pub const Found = union(enum) {
    /// The first match at or after `from`, or that the text holds none.
    answer: ?Span,
    /// The search left the places, to keep its time linear: the plain search answers.
    plain,
    /// A DFA gave up.
    gave_up,
};

/// The first match at or after `from`, found from the places of `literal` in turn. `forward` and
/// `reverse` are the searcher's DFAs, and the reverse DFA's second start is the part of the
/// program before the literal.
pub fn find(forward: *Dfa, reverse: *Dfa, literal: *const Literal, haystack: []const u8, from: usize) Found {
    assert(from <= haystack.len);
    var at = from;
    // Where the last forward scan that found no match stopped.
    var read_to = from;
    // Each turn goes on from one byte past the place before, so the turns are at most the bytes
    // from `from` and one.
    for (0..haystack.len - from + 1) |_| {
        const place = literal.find(haystack, at) orelse return .{ .answer = null };
        if (place < read_to) return .plain;
        switch (dfa_reverse.scan_second(reverse, haystack, from, place)) {
            .gave_up => return .gave_up,
            .none => {},
            .found => |start| switch (dfa_second.scan_forward(forward, haystack, start)) {
                .gave_up => return .gave_up,
                .found => |end| return .{ .answer = .{ .start = start, .end = end } },
                .none => |stop| read_to = stop,
            },
        }
        at = place + 1;
    }
    return .{ .answer = null };
}
