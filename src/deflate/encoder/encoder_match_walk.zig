//! The chain walk of the encoder's lazy levels: the search for the longest match among the
//! candidates a position's hash chain names, one walk at a time (`best`), or two in one loop after
//! a taken match, so their loads overlap (`best_pair`).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const Match = match.Match;
const slot = match.slot;
const tail_octets = match.tail_octets;
const match_len = match.match_len;

/// The two searches of `best_pair`.
pub const Pair = struct {
    first: Match,
    second: Match,
};

/// One chain walk in progress: what a search keeps between candidates, so two walks can take turns
/// in one loop and their loads overlap (`best_pair`).
const Walk = struct {
    position: usize,
    /// The `len_max` octets at `position`.
    later: []const u8,
    candidate: u16,
    /// The candidates examined so far, and the most the walk examines.
    tried: u16 = 0,
    budget: u16,
    found: Match = .{},
    /// Where the 4 octets that decide a candidate against `found` start, and those 4 of `later`.
    tail: u8 = 0,
    later_tail: u32,
    /// `found` after `cut_candidates_max` candidates: the result when a cut applies to a walk that
    /// passed them.
    found_at_cut: Match = .{},
    done: bool = false,

    inline fn init(comptime level: constants.Level, self: *const Matcher(level), position: usize, len_max: usize, budget: u16) Walk {
        assert(len_max >= constants.match_len_taken_min and position + len_max <= self.filled);
        const later = self.window[position..][0..len_max];
        return .{ .position = position, .later = later, .candidate = self.chain[slot(position)], .budget = budget, .later_tail = tail_octets(later, 0) };
    }

    /// Examines the next candidate, or ends the walk: at its budget, at the chain's end, at a
    /// candidate too far, or at a match `nice_len` or `len_max` long. A match longer than `found`
    /// agrees on the 4 octets that end where `found` stops, and no match under
    /// `match_len_taken_min` is taken, so while `found` is shorter the first 4 decide. One compare
    /// of those 4 turns away most candidates before `match_len` compares from the start, and a
    /// candidate rarely passes it by chance, so its branch stays predictable.
    inline fn step(walk: *Walk, comptime level: constants.Level, self: *const Matcher(level)) void {
        if (walk.done) return;
        const candidate = walk.candidate;
        // The chain names earlier positions, each farther than the one before it.
        if (walk.tried >= walk.budget or candidate == 0 or @as(usize, candidate) + constants.encoder_distance_max < walk.position) {
            walk.done = true;
            return;
        }
        assert(candidate < walk.position);
        walk.candidate = self.chain[slot(candidate)];
        walk.tried += 1;
        if (tail_octets(self.window[candidate..], walk.tail) == walk.later_tail) {
            walk.found = longer_match(level, self, walk.position, candidate, walk.later, walk.found);
            if (walk.found.len >= level.nice_len or walk.found.len >= walk.later.len) {
                walk.done = true;
            } else {
                walk.tail = tail_of(walk.found);
                walk.later_tail = tail_octets(walk.later, walk.tail);
            }
        }
        if (walk.tried == level.cut_candidates_max) walk.found_at_cut = walk.found;
    }

    /// The walk's result: under a budget of `cut_candidates_max` when `cut`, else its own.
    inline fn result(walk: Walk, comptime level: constants.Level, cut: bool) Match {
        return if (cut and walk.tried > level.cut_candidates_max) walk.found_at_cut else walk.found;
    }
};

/// The longest match at `position` of at least `match_len_taken_min` octets, or none, among
/// `candidates_max` earlier positions with its hash, the nearest first, up to `len_max` octets; a
/// search ends early at `nice_len`. When the match waiting from the position before is
/// `previous_len` octets, `cut_len` or more, the search tries `cut_candidates_max`.
pub fn best(comptime level: constants.Level, self: *const Matcher(level), len_max: usize, previous_len: u16) Match {
    return best_inline(level, self, len_max, previous_len);
}

/// `best`, inline in its caller: level 6's positions mostly start a walk that meets a candidate or
/// two, so a call's own cost is a large share of the walk there; level 9's walks run long, and it
/// calls `best`.
pub inline fn best_inline(comptime level: constants.Level, self: *const Matcher(level), len_max: usize, previous_len: u16) Match {
    if (self.position + constants.hash_len > self.filled) return .{};
    const cut = previous_len >= level.cut_len;
    var walk = Walk.init(level, self, self.position, len_max, if (cut) level.cut_candidates_max else level.candidates_max);
    while (!walk.done) walk.step(level, self);
    return walk.found;
}

/// The lazy step's two searches after a taken match, at `position` and the next, walked in one loop
/// so their loads overlap: the first's match waits, and the second's is compared with it. The
/// second walk follows the first's match as `best` would after it: cut to `cut_candidates_max`
/// once the first is `cut_len` long, and ended once it is `lazy_len` long, when the step skips the
/// second search. Both positions have `match_len_max` octets ahead.
pub fn best_pair(comptime level: constants.Level, self: *const Matcher(level), position: usize) Pair {
    var first = Walk.init(level, self, position, constants.match_len_max, level.candidates_max);
    var second = Walk.init(level, self, position + 1, constants.match_len_max, level.candidates_max);
    // The first walk's nearest candidate often settles the second's budget, so it goes first.
    first.step(level, self);
    while (!first.done or !second.done) {
        if (first.found.len >= level.lazy_len) second.done = true;
        if (first.found.len >= level.cut_len) second.budget = level.cut_candidates_max;
        second.step(level, self);
        first.step(level, self);
    }
    return .{ .first = first.found, .second = second.result(level, first.found.len >= level.cut_len) };
}

/// Where the 4 octets that decide a candidate against `found` start: the octet after `found` ends,
/// less the 4, or the match's first octets while none is found.
inline fn tail_of(found: Match) u8 {
    assert(found.len == 0 or found.len >= constants.match_len_taken_min);
    return @intCast(found.len -| (constants.match_len_taken_min - 1));
}

/// The match at `candidate` for `position` when it is longer than `found`, else `found`.
inline fn longer_match(comptime level: constants.Level, self: *const Matcher(level), position: usize, candidate: u16, later: []const u8, found: Match) Match {
    const len = match_len(self.window[candidate..][0..later.len], later);
    if (len <= found.len) return found;
    return .{ .len = @intCast(len), .distance = @intCast(position - candidate) };
}
