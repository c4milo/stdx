//! `Matches`: every match of a haystack in order, as a searcher finds them, and their count
//! (claim R10, decision 86).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Span = @import("../matcher.zig").Span;
const Literal = @import("../literal.zig").Literal;
const Searcher = @import("searcher.zig").Searcher;

/// Every match of a haystack in order, none inside another: each search starts where the match
/// before it ended. An empty match that touches the match before it is left out, as RE2 and Go's
/// regexp leave it out.
///
/// One search costs time linear in the haystack. A pattern whose every search reads far past its
/// match, such as `a|a.*z` over a text of `a` alone, costs every match that much, so the whole
/// walk can cost the square of the haystack's length. Decision 86 records it.
pub const Matches = struct {
    searcher: *Searcher,
    haystack: []const u8,
    /// Where the next search starts. Past the haystack's end, no match is left.
    position: usize = 0,
    /// Where the last match ended.
    last_end: ?usize = null,

    pub fn next(matches: *Matches) ?Span {
        if (matches.position > matches.haystack.len) return null;
        if (matches.searcher.exact) |*literal| return matches.next_exact(literal);
        var found = matches.searcher.find(matches.haystack, matches.position);
        if (found) |span| {
            // An empty match that touches the match before it: the next match starts at least one
            // octet on. No match starts inside a scalar value, so one octet on is far enough.
            if (span.len() == 0 and matches.last_end == span.end) found = matches.find_after(span);
        }
        const span = found orelse {
            matches.position = matches.haystack.len + 1;
            return null;
        };
        matches.position = @intCast(span.end);
        matches.last_end = matches.position;
        return span;
    }

    /// The count of the matches `next` would give from here, which leaves none for `next` to
    /// give. A count needs each match's end alone (claim R10).
    pub fn count(matches: *Matches) u64 {
        var total: u64 = 0;
        const by_ends = counts_ends(matches.searcher);
        // Each turn counts a match that ends past the last one, or the first match: at most the
        // haystack's offsets and one. No match is left after that many.
        for (0..matches.haystack.len + 1) |_| {
            if (matches.position > matches.haystack.len) break;
            const end = if (by_ends) matches.next_end() else matches.next_span_end();
            matches.position = end orelse break;
            matches.last_end = end;
            total += 1;
        }
        matches.position = matches.haystack.len + 1;
        return total;
    }

    /// The end of the match `next` gives, for a searcher that finds each match whole.
    fn next_span_end(matches: *Matches) ?usize {
        const span = matches.next() orelse return null;
        return @intCast(span.end);
    }

    /// The end of the match `next` would give. A search starts at the last match's end, so a
    /// match that ends there is an empty one that touches the match before it, and the search
    /// goes on one octet on, as `next` does.
    fn next_end(matches: *Matches) ?usize {
        const end = find_end(matches.searcher, matches.haystack, matches.position) orelse return null;
        if (matches.last_end != end) return end;
        const from = end + 1;
        if (from > matches.haystack.len) return null;
        return find_end(matches.searcher, matches.haystack, from);
    }

    /// `next` for a pattern that is its literal (claim R2): each place of the literal is a match
    /// of one octet or more, so none is empty.
    fn next_exact(matches: *Matches, literal: *const Literal) ?Span {
        const start = literal.find(matches.haystack, matches.position) orelse {
            matches.position = matches.haystack.len + 1;
            return null;
        };
        matches.position = start + literal.len;
        matches.last_end = matches.position;
        return .{ .start = @intCast(start), .end = @intCast(matches.position) };
    }

    fn find_after(matches: *Matches, empty: Span) ?Span {
        const from: usize = @intCast(empty.end + 1);
        if (from > matches.haystack.len) return null;
        return matches.searcher.find(matches.haystack, from);
    }
};

/// Where the first match at or after `from` ends, or null where none does, for a searcher
/// that `counts_ends`. Where its forward DFA is ready and has not given up too often, the
/// DFA finds the end alone, with no read back to the start. Otherwise `find` finds the match.
fn find_end(searcher: *Searcher, haystack: []const u8, from: usize) ?usize {
    assert(counts_ends(searcher));
    if (searcher.excludes(haystack.len)) return null;
    if (searcher.forward_ready and searcher.give_ups < constants.dfa_give_ups_max) {
        switch (searcher.forward.scan_forward(haystack, from, false)) {
            .gave_up => searcher.give_ups += 1,
            .none => return null,
            .found => |end| return end,
        }
    }
    const span = searcher.find(haystack, from) orelse return null;
    return @intCast(span.end);
}

/// Claim R10: true where a count finds each match's end alone. A literal's claims find the
/// match with no DFA, and claims R4, R12 and R14 find its start first, so their counts take
/// `find`.
fn counts_ends(searcher: *const Searcher) bool {
    return searcher.count_ends and searcher.exact == null and !searcher.exact_set and searcher.suffix == null and !searcher.at_end and searcher.inner == null;
}
