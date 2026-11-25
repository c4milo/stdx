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
        if (matches.position <= matches.haystack.len and holds_none(matches.searcher, matches.haystack.len, matches.position)) {
            matches.position = matches.haystack.len + 1;
            return 0;
        }
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
/// It does not judge claim R13's least length: `count` judges it once, before its first search,
/// and a check here changed how the compiler built the DFA's loop that is inlined below it.
fn find_end(searcher: *Searcher, haystack: []const u8, from: usize) ?usize {
    assert(counts_ends(searcher));
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

/// True when claim R13 refuses the text from `position` by its length alone: it is shorter than
/// the least match, or a pattern of the whole text cannot match a text this long. A searcher
/// whose claims wait counts the text first, and one whose claim keeps an account pays each search
/// to it, so those two search.
fn holds_none(searcher: *const Searcher, len: usize, position: usize) bool {
    assert(position <= len);
    if (searcher.deferred.any() or searcher.inner != null or searcher.suffix_wide) return false;
    return len - position < searcher.len_min or searcher.excludes(len);
}

/// Claim R10: true where a count finds each match's end alone. A literal's claims find the
/// match with no DFA. Claims R4, R12 and R14 find its start first, claim R13 may read no text,
/// and a claim that waits is judged by a search, so their counts take `find`.
fn counts_ends(searcher: *const Searcher) bool {
    return searcher.count_ends and searcher.exact == null and !searcher.exact_set and !searcher.by_claim;
}

const testing = std.testing;
const searcher_test = @import("searcher_test.zig");

fn expect_matches(pattern: []const u8, haystack: []const u8, expected: []const [constants.group_slots]u64) !void {
    var fixture: searcher_test.Fixture = .{};
    for ([_]usize{ searcher_test.cache_words_max, 0 }) |cache| {
        try fixture.init(pattern, cache);
        var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = haystack };
        for (expected) |span| {
            try testing.expectEqual(@as(?Span, .{ .start = span[0], .end = span[1] }), matches.next());
        }
        try testing.expectEqual(@as(?Span, null), matches.next());
        try testing.expectEqual(@as(?Span, null), matches.next());
    }
}

test "Matches gives every match in order, each search from the end of the match before" {
    try expect_matches("a+", "baaa a", &.{ .{ 1, 4 }, .{ 5, 6 } });
    try expect_matches("abc", "abcabc", &.{ .{ 0, 3 }, .{ 3, 6 } });
    try expect_matches("aa", "aaaaa", &.{ .{ 0, 2 }, .{ 2, 4 } });
    try expect_matches("x", "abc", &.{});
    try expect_matches("\\b\\w+\\b", "one two", &.{ .{ 0, 3 }, .{ 4, 7 } });
}

test "Matches leaves out an empty match that touches the match before it" {
    try expect_matches("a*", "baaa", &.{ .{ 0, 0 }, .{ 1, 4 } });
    try expect_matches("a*", "baaab", &.{ .{ 0, 0 }, .{ 1, 4 }, .{ 5, 5 } });
    try expect_matches("", "ab", &.{ .{ 0, 0 }, .{ 1, 1 }, .{ 2, 2 } });
    try expect_matches("", "", &.{.{ 0, 0 }});
    try expect_matches("a|", "aba", &.{ .{ 0, 1 }, .{ 2, 3 } });
    try expect_matches("$", "ab", &.{.{ 2, 2 }});
}

test "Matches gives no empty match inside the UTF-8 of a scalar value" {
    try expect_matches("", "\xC3\xA9\xE6\x97\xA5", &.{ .{ 0, 0 }, .{ 2, 2 }, .{ 5, 5 } });
    try expect_matches("\\B", "a\xF0\x9F\x98\x80", &.{.{ 5, 5 }});
    try expect_matches("x*", "\xC3\xA9x", &.{ .{ 0, 0 }, .{ 2, 3 } });
}
