//! `Searcher`: matches in a text that is all in one slice (decision 86).
//!
//! A searcher answers as `Matcher` answers, and takes a faster way to the answer where it has one.
//! A lazy DFA over the forward program reads the text once and says where the match ends. A lazy
//! DFA over the reverse program reads back from there and says where it starts. Only a caller who
//! asks for the capture groups pays for the matcher's slots, and only over the match. This is the
//! order of work Cox describes for RE2.
//!
//! Each DFA lives in a cache of a fixed size and gives up when the cache thrashes (dfa.zig). The
//! searcher then runs the matcher, so a search's worst case stays the matcher's: time linear in
//! the text.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const program_file = @import("../program.zig");
const Program = program_file.Program;
const matcher_file = @import("../matcher.zig");
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;
const dfa_file = @import("../dfa/dfa.zig");
const Dfa = dfa_file.Dfa;
const Literal = @import("../literal.zig").Literal;

/// The words of the caches' memory in one word of a searcher's memory.
const cache_words_per_word = @sizeOf(u64) / @sizeOf(u32);

/// What a faster way found: the match, or that the text holds none.
const Answer = struct { span: ?Span };

/// The claims of a searcher, each a faster way that must give the answer the plain way gives.
/// A caller turns one off to measure it, or to rule it out.
pub const Claims = struct {
    /// R1: a forward DFA that waits for a match to start skips to the next octet that can start
    /// one, `skip_lanes` octets a step. It rests where the texts hold such octets too close
    /// together for a skip to pay, and tries again later.
    start_skip: bool = true,
    /// R2: where every match starts with a literal of two octets or more, that skip goes to the
    /// next place of the literal, found with its first and last octets `skip_lanes` places a
    /// step. Where the pattern is that literal and nothing else, the searcher reads no DFA: a
    /// place of the literal is a match. Only with `start_skip`.
    literal: bool = true,
};

pub const Searcher = struct {
    matcher: Matcher,
    forward: Dfa,
    reverse: Dfa,
    /// True when each DFA's cache has room for `dfa_states_min` states.
    forward_ready: bool,
    reverse_ready: bool,
    /// The searches in which a DFA gave up.
    give_ups: u32,
    /// Claim R2: the pattern, where it is a literal and nothing else.
    exact: ?Literal,

    /// The words of memory a searcher takes for a program of `forward_len` forward instructions
    /// and `slots_len` slots, with `cache_words` words for its two caches. A cache too small for a
    /// DFA costs speed and no answer.
    pub fn memory_len(forward_len: u32, slots_len: u32, cache_words: usize) usize {
        return Matcher.memory_len(forward_len, slots_len) + cache_words;
    }

    /// Readies a searcher for `program`. The memory is the searcher's until the caller is done
    /// with it, and holds at least `memory_len` words with no cache.
    pub fn init(searcher: *Searcher, program: *const Program, memory: []u64) void {
        searcher.init_with(program, .{}, memory);
    }

    /// `init`, with the claims the caller names.
    pub fn init_with(searcher: *Searcher, program: *const Program, claims: Claims, memory: []u64) void {
        const matcher_len = Matcher.memory_len(program.forward_len, program.slot_count());
        assert(memory.len >= matcher_len);
        searcher.matcher.init(program, .{ .captures = .groups }, memory[0..matcher_len]);
        const cache: []u32 = std.mem.bytesAsSlice(u32, std.mem.sliceAsBytes(memory[matcher_len..]));
        const has_reverse = program.reverse != program_file.no_entry;
        const forward_len = if (has_reverse) cache.len / constants.dfa_cache_parts * constants.dfa_forward_parts else cache.len;
        searcher.forward_ready = searcher.forward.init(
            program,
            .{ .entry = program.forward, .kind = .first, .anchored = false, .skip = claims.start_skip, .literal = claims.start_skip and claims.literal },
            cache[0..forward_len],
        );
        searcher.reverse_ready = has_reverse and searcher.reverse.init(
            program,
            .{ .entry = program.reverse, .kind = .longest, .anchored = true },
            cache[forward_len..],
        );
        searcher.give_ups = 0;
        // A DFA that `init` refused holds no literal. Without a cache the matcher answers alone.
        searcher.exact = null;
        if (searcher.forward_ready) {
            if (searcher.forward.literal) |literal| searcher.exact = if (literal.exact) literal else null;
        }
    }

    /// True when the haystack holds a match.
    pub fn is_match(searcher: *Searcher, haystack: []const u8) bool {
        if (searcher.exact) |*literal| return literal.find(haystack, 0) != null;
        if (searcher.forward_ready and searcher.give_ups < constants.dfa_give_ups_max) {
            switch (searcher.forward.scan_forward(haystack, 0, true)) {
                .gave_up => searcher.give_ups += 1,
                .none => return false,
                .found => return true,
            }
        }
        searcher.matcher.configure(.{ .captures = .none });
        searcher.matcher.start(null, 0);
        return searcher.matcher.search(haystack, .last).status == .match;
    }

    /// The first match at or after `from`, or null. To find the match after one, search from its
    /// end, or one scalar value past it where the match is empty.
    pub fn find(searcher: *Searcher, haystack: []const u8, from: usize) ?Span {
        assert(from <= haystack.len);
        if (searcher.find_by_dfa(haystack, from)) |answer| return answer.span;
        searcher.matcher.configure(.{ .captures = .span });
        return searcher.matcher.find(haystack, from);
    }

    /// The first match at or after `from`, with the span of each capture group in `groups`: the
    /// whole match first. A group that took no part in the match is null. False when the haystack
    /// holds no match, and `groups` is then left as it was.
    pub fn captures(searcher: *Searcher, haystack: []const u8, from: usize, groups: []?Span) bool {
        assert(from <= haystack.len);
        assert(groups.len == searcher.matcher.program.group_count);
        var anchor = from;
        var anchored = false;
        if (searcher.find_by_dfa(haystack, from)) |answer| {
            const span = answer.span orelse return false;
            anchor = @intCast(span.start);
            anchored = true;
        }
        searcher.matcher.configure(.{ .captures = .groups, .anchored = anchored });
        if (searcher.matcher.find(haystack, anchor) == null) {
            assert(!anchored);
            return false;
        }
        for (groups, 0..) |*group, index| group.* = searcher.matcher.group(@intCast(index));
        return true;
    }

    /// The match as the two DFAs find it, or null when the searcher has no DFA for the search or
    /// one gave up.
    fn find_by_dfa(searcher: *Searcher, haystack: []const u8, from: usize) ?Answer {
        if (searcher.exact) |*literal| {
            const start = literal.find(haystack, from) orelse return .{ .span = null };
            return .{ .span = .{ .start = start, .end = start + literal.len } };
        }
        if (!searcher.forward_ready or !searcher.reverse_ready) return null;
        if (searcher.give_ups >= constants.dfa_give_ups_max) return null;
        const end = switch (searcher.forward.scan_forward(haystack, from, false)) {
            .gave_up => return searcher.gave_up(),
            .none => return .{ .span = null },
            .found => |offset| offset,
        };
        const start = switch (searcher.reverse.scan_reverse(haystack, from, end)) {
            .gave_up => return searcher.gave_up(),
            // The forward program matched text that ends at `end`, so the reverse program matches
            // it read backward.
            .none => unreachable,
            .found => |offset| offset,
        };
        return .{ .span = .{ .start = start, .end = end } };
    }

    fn gave_up(searcher: *Searcher) ?Answer {
        searcher.give_ups += 1;
        return null;
    }
};

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

    fn find_after(matches: *Matches, empty: Span) ?Span {
        const from: usize = @intCast(empty.end + 1);
        if (from > matches.haystack.len) return null;
        return matches.searcher.find(matches.haystack, from);
    }
};

test {
    _ = @import("searcher_test.zig");
    _ = @import("searcher_skip_test.zig");
    _ = @import("searcher_literal_test.zig");
}
