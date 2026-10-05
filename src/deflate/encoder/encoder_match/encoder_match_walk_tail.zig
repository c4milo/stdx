//! The chain walk of a level whose chains run long, level 9: a search that leaves the chain it
//! follows for the chain of its match's tail when fewer candidates remain there (`best_by_tail`,
//! decision 46).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const Match = match.Match;
const slot = match.slot;
const tail_octets = match.tail_octets;
const match_len = match.match_len;
const hash_of_word = match.hash_of_word;
const tail_of = @import("encoder_match_walk.zig").tail_of;

/// A walk in progress.
const TailWalk = struct {
    found: Match = .{},
    /// The chain followed: the next position it names, and how many octets each of its positions
    /// lies after the start of its candidate. The chain of the position's own 4 octets names the
    /// candidates themselves, 0 octets after.
    link: usize,
    offset: usize = 0,
    /// Where the 4 octets that decide a candidate against `found` start, and those 4 of the
    /// position's octets.
    tail: usize = 0,
    later_tail: u32,
    /// The links the walk may still read.
    left: u32,
    /// What the loop needs at each link, kept by `follow_longer`: the lowest position of the
    /// chain followed that names a candidate in reach, and how many octets after a position of
    /// that chain its candidate's deciding 4 octets start.
    floor: usize,
    shift: usize = 0,

    /// How many of the position's octets `later` the octets at `candidate` equal, when that is
    /// more than `found` holds, else 0. A position of the tail's chain holds the tail, and mostly
    /// not the match before it: the position's first 4 octets, `later_head`, turn those away
    /// before `match_len` compares from the start.
    inline fn longer_len(walk: *const TailWalk, comptime level: constants.Level, self: *const Matcher(level), later: []const u8, later_head: u32, candidate: usize) usize {
        if (tail_octets(&self.window, candidate) != later_head) return 0;
        const len = match_len(self.window[candidate..][0..later.len], later);
        return if (len > walk.found.len) len else 0;
    }

    /// After a longer match at `candidate`, whose tail decides the candidates left: moves the
    /// walk to the tail's chain where fewer remain there (`move`).
    ///
    /// The walk has passed every candidate from `candidate` on, and with them every candidate as
    /// near as the match is long, none of which holds a longer match. Say the match lies `d`
    /// octets back and is `n` long, and a candidate `e` octets back, `e` over `d` and at most
    /// `n`, held `n + 1` of the position's octets. The `n + d` octets from the match's candidate
    /// to the match's end at the position would repeat every `d` octets and every `e`, so every
    /// greatest common divisor of the two (Fine and Wilf's theorem). The octet after the match at
    /// its candidate would then equal the octet after it at the position, and the match ended
    /// because the two differ.
    ///
    /// So each candidate left lies more than `n` octets back, and its tail lies before the
    /// position, among the positions the lazy loop has inserted: the tail's chain names it.
    /// Where none is left in reach, the walk reads no more.
    inline fn follow_longer(walk: *TailWalk, comptime level: constants.Level, self: *const Matcher(level), lowest: usize, later: []const u8, candidate: usize) void {
        // The walk's own chain has ended: it names every candidate left, so none is, and the
        // loop's next test ends the walk.
        if (walk.link < walk.floor) return;
        const passed = @min(candidate, self.position -| walk.found.len);
        if (passed <= lowest) {
            walk.left = 0;
            return;
        }
        walk.tail = tail_of(walk.found);
        walk.later_tail = tail_octets(later, walk.tail);
        if (walk.could_pay(lowest, candidate)) walk.move(level, self, passed);
        // A tail starts where a match ends, less 3 octets, so no tail starts before an earlier one.
        assert(walk.tail >= walk.offset);
        walk.floor = lowest + walk.offset;
        walk.shift = walk.tail - walk.offset;
    }

    /// Whether a move could pay after the longer match at `candidate`: the walk's own chain names
    /// its next candidate near enough that `tail_move_candidates_min` could follow at that gap
    /// before the reach's edge at `lowest`. A chain of fewer candidates costs less to read than
    /// a move.
    inline fn could_pay(walk: *const TailWalk, lowest: usize, candidate: usize) bool {
        assert(walk.link >= walk.floor);
        const gap = candidate - (walk.link - walk.offset);
        return gap * constants.tail_move_candidates_min <= candidate - lowest;
    }

    /// Moves the walk to the tail's chain when that chain names its next candidate within
    /// `tail_skips_max` links and farther back than the chain followed names its own. The walk
    /// has passed every candidate from `passed` on, and the tail of each one before lies at an
    /// inserted position. The links read come off the walk's.
    inline fn move(walk: *TailWalk, comptime level: constants.Level, self: *const Matcher(level), passed: usize) void {
        // The position that names `passed` on the tail's chain.
        const passed_from = passed + walk.tail;
        assert(passed_from <= self.position);
        var link: usize = self.heads[hash_of_word(level, walk.later_tail)];
        assert(link <= self.position);
        var skips: u32 = 0;
        while (skips < constants.tail_skips_max and link >= passed_from) : (skips += 1) link = self.chain[slot(link)];
        walk.left -|= skips;
        // A chain's next candidate is its link less its offset.
        if (link >= passed_from or link + walk.offset >= walk.link + walk.tail) return;
        walk.link = link;
        walk.offset = walk.tail;
    }
};

/// The longest match at the matcher's position of at least `match_len_taken_min` octets, or none,
/// up to `len_max` octets, the nearest of the longest, as `best_inline` finds it. `budget` bounds
/// the links the walk reads, a move's included.
///
/// A candidate longer than the match found holds the match's tail, the 4 octets that end one past
/// it, `tail` octets after its own start. Every inserted position that holds those 4 octets is on
/// their chain. So each candidate left is named twice: by the chain the walk follows, and by the
/// tail's chain, `tail` octets after its start. The walk needs one of the two, and the chain with
/// fewer positions costs less: in a JSON text thousands of positions hold a key's first 4 octets,
/// and few hold the 4 that end one octet into its value.
///
/// After each longer match the walk reads the tail's chain from its head, its newest position,
/// past the positions whose candidates it has passed: `tail_skips_max` links at most, as a tail
/// whose positions lie closer than that recurs as often as the octets the walk follows. It moves
/// there when that chain's next candidate lies farther back than its own chain's. A chain that
/// ends, or leaves the reach, ends the walk: no candidate left is longer.
pub inline fn best_by_tail(comptime level: constants.Level, self: *const Matcher(level), len_max: usize, budget: u16) Match {
    comptime assert(level.tail_chains);
    const position = self.position;
    assert(len_max >= constants.match_len_taken_min and position + len_max <= self.filled);
    const later = self.window[position..][0..len_max];
    // Position 0 names no candidate, as a head or link of 0 ends a chain.
    const lowest = @max(1, position -| constants.encoder_distance_max);
    const later_head = tail_octets(later, 0);
    var walk: TailWalk = .{ .link = self.chain[slot(position)], .later_tail = later_head, .left = budget, .floor = lowest };
    // One compare ends the walk at the reach's edge and at a chain's end.
    while (walk.left != 0 and walk.link >= walk.floor) {
        const link = walk.link;
        walk.link = self.chain[slot(link)];
        walk.left -= 1;
        if (tail_octets(&self.window, link +% walk.shift) != walk.later_tail) continue;
        const candidate = link - walk.offset;
        assert(candidate < position);
        const len = walk.longer_len(level, self, later, later_head, candidate);
        if (len == 0) continue;
        walk.found = .{ .len = @intCast(len), .distance = @intCast(position - candidate) };
        if (len >= level.nice_len or len >= later.len) break;
        walk.follow_longer(level, self, lowest, later, candidate);
    }
    return walk.found;
}

test {
    _ = @import("encoder_match_walk_tail_test.zig");
}
