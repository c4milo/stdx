//! The chain walk of the encoder's lazy levels: the search for the longest match among the
//! candidates a position's hash chain names, one walk at a time (`best`), or two in one loop after
//! a taken match, so their loads overlap (`best_pair`). Level 9's walk also follows the chains of
//! its matches' tails (`encoder_match_walk_tail.zig`).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const Match = match.Match;
const slot = match.slot;
const tail_octets = match.tail_octets;
const match_len = match.match_len;
const best_by_tail = @import("encoder_match_walk_tail.zig").best_by_tail;

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
    /// The lowest position the walk may reach: `position` less `encoder_distance_max`, or 1, as a
    /// head or link of 0 ends the chain. One compare against it ends the walk at either.
    lowest: usize,
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
        const lowest = @max(1, position -| constants.encoder_distance_max);
        return .{ .position = position, .later = later, .candidate = self.chain[slot(position)], .lowest = lowest, .budget = budget, .later_tail = tail_octets(later, 0) };
    }

    /// Examines the next candidate, or ends the walk: at its budget, at the chain's end, at a
    /// candidate too far, or at a match `nice_len` or `len_max` long. A match longer than `found`
    /// agrees on the 4 octets that end where `found` stops, and no match under
    /// `match_len_taken_min` is taken, so while `found` is shorter the first 4 decide. One compare
    /// of those 4 turns away most candidates before `match_len` compares from the start, and a
    /// candidate rarely passes it by chance, so its branch stays predictable.
    inline fn step(walk: *Walk, comptime level: constants.Level, self: *const Matcher(level), comptime keeps_cut: bool) void {
        if (walk.done) return;
        const candidate = walk.candidate;
        // The chain names earlier positions, each farther than the one before it.
        if (walk.tried >= walk.budget or candidate < walk.lowest) {
            walk.done = true;
            return;
        }
        assert(candidate < walk.position);
        walk.candidate = self.chain[slot(candidate)];
        // Below the budget, at most `candidates_max`, which fits 16 bits.
        walk.tried +%= 1;
        if (tail_octets(self.window[candidate..], walk.tail) == walk.later_tail) {
            walk.found = longer_match(level, self, walk.position, candidate, walk.later, walk.found);
            // `found` changes only here, so the last value set within the first
            // `cut_candidates_max` candidates is `found` after them.
            if (keeps_cut and walk.tried <= level.cut_candidates_max) walk.found_at_cut = walk.found;
            if (walk.found.len >= level.nice_len or walk.found.len >= walk.later.len) {
                walk.done = true;
            } else {
                walk.tail = tail_of(walk.found);
                walk.later_tail = tail_octets(walk.later, walk.tail);
            }
        }
    }

    /// The walk's result: under a budget of `cut_candidates_max` when `cut`, else its own.
    inline fn result(walk: Walk, comptime level: constants.Level, cut: bool) Match {
        return if (cut and walk.tried > level.cut_candidates_max) walk.found_at_cut else walk.found;
    }
};

/// The longest match at `position` of at least `match_len_taken_min` octets, or none, among
/// `candidates_max` earlier positions with its hash, the nearest first, up to `len_max` octets; a
/// search ends early at `nice_len`. When the match waiting from the position before is
/// `previous_len` octets, `cut_len` or more, the search tries `cut_candidates_max`. At a level
/// with `tail_chains` those two bound the links the search reads, and it may find its match
/// among positions farther back than they would reach on the position's own chain.
pub fn best(comptime level: constants.Level, comptime cheap: bool, self: *const Matcher(level), len_max: usize, previous_len: u16) align(constants.hot_function_alignment) Match {
    return best_inline(level, cheap, self, len_max, previous_len);
}

/// `best`, inline in its caller: level 6's positions mostly start a walk that meets a candidate or
/// two, so a call's own cost is a large share of the walk there; level 9's walks run long, and it
/// calls `best`.
pub inline fn best_inline(comptime level: constants.Level, comptime cheap: bool, self: *const Matcher(level), len_max: usize, previous_len: u16) Match {
    if (self.position + constants.hash_len > self.filled) return .{};
    const cut = previous_len >= level.cut_len;
    // A block with cheap literals walks long chains of short matches its prices turn away
    // (decision 42).
    const budget = if (cheap) level.cheap_candidates_max else if (cut) level.cut_candidates_max else level.candidates_max;
    // In a block with cheap literals every 4 octets recur about as often as any other: a move to
    // the tail's chain reads a head for each longer match and finds no fewer candidates there.
    if (level.tail_chains and !cheap) return best_by_tail(level, self, len_max, budget);
    var walk = Walk.init(level, self, self.position, len_max, budget);
    while (!walk.done) walk.step(level, self, false);
    return walk.found;
}

/// The candidates the lazy loop reads of a short chain. On the N2 a third costs the files of few
/// matches 1% to 2% for its instructions, and one leaves a branch that mispredicts.
const short_chain_len = 2;

/// Whether the read tests its nearest candidate before the rest. On aarch64 that test finds a
/// walk that runs after a literal one load in, where the last test waits on the chain's loads,
/// which the N2 takes from its level 2 cache. On x86-64, which has half the registers, LLVM
/// builds it as two branches and a rotation of seven registers, and the read retires as many
/// instructions as the walks it saves.
const tests_nearest_first = builtin.cpu.arch.isAARCH64();

/// Whether the chain at `position` holds at most `count` candidates in reach and none of them
/// starts with the position's 4 octets: a walk there finds no match.
///
/// In data that does not repeat, a chain holds no candidate, one or two about as often as each
/// other. A walk tests each candidate's reach in turn, so one of its branches mispredicts at about
/// every other position, and each miss waits on the chain's loads. This reads the first `count`
/// candidates whatever the chain holds. Where `tests_nearest_first`, a first test, on one load,
/// starts the walk where the nearest candidate holds the position's octets, as most walks that
/// run in text do. The last test, on the chain's loads, tells whether a candidate read holds
/// them or one more follows.
///
/// A candidate out of reach is read where the one before it was read, and the first at the
/// position itself, so every load stays on octets and links a walk reads. The link read there is
/// the candidate that fell out of reach, so every candidate after one out of reach is out of
/// reach too.
inline fn short_chain_misses(comptime level: constants.Level, comptime count: usize, self: *const Matcher(level), position: usize) bool {
    // Level 6's padding keeps a load at any 16-bit position inside its window, so its loads carry
    // no check; level 9's window has none, and its loads keep theirs.
    comptime assert(level.chains and count >= 1);
    const word = tail_octets(self.window[position..], 0);
    const lowest = @max(1, position -| constants.encoder_distance_max);
    // Each value is as wide as an index. A 16-bit value here would join the walk's own candidate,
    // which the compiler then keeps 16 bits wide and extends at every link.
    const nearest: usize = self.chain[slot(position)];
    var at: usize = @as(u16, @intCast(position));
    var read = nearest;
    var matched: u32 = 0;
    inline for (0..count) |index| {
        at = if (read >= lowest) read else at;
        matched |= @intFromBool(tail_octets(self.window[at..], 0) == word);
        // The 4 octets read at the position itself are its own, so a match counts only when the
        // nearest candidate is in reach.
        if (tests_nearest_first and index == 0 and (@intFromBool(nearest >= lowest) & matched) != 0) return false;
        read = self.chain[slot(at)];
    }
    const walks = (@intFromBool(nearest >= lowest) & matched) | @intFromBool(read >= lowest);
    return walks == 0;
}

/// Whether the lazy loop's position starts no search. A waiting match at least `lazy_len` long is
/// taken without one. A position after a literal starts none when its chain is short and holds
/// none of its 4 octets. A position after a match found mostly has candidates, and so do the
/// positions of a block with cheap literals, whose octets take few values (decision 42): both
/// would pay the chain's reads for nothing, and search as before.
pub inline fn skips_search(comptime level: constants.Level, comptime cheap: bool, self: *const Matcher(level), position: usize, previous_len: u16, waiting: bool) bool {
    const taken = waiting and previous_len >= level.lazy_len;
    if (cheap) return taken;
    return taken or (previous_len == 0 and short_chain_misses(level, short_chain_len, self, position));
}

/// The lazy step's two searches after a taken match, at `position` and the next, walked in one loop
/// so their loads overlap: the first's match waits, and the second's is compared with it. The
/// second walk follows the first's match as `best` would after it: cut to `cut_candidates_max`
/// once the first is `cut_len` long, and ended once it is `lazy_len` long, when the step skips the
/// second search. Both positions have `match_len_max` octets ahead.
pub fn best_pair(comptime level: constants.Level, comptime cheap: bool, self: *const Matcher(level), position: usize) Pair {
    const budget = if (cheap) level.cheap_candidates_max else level.candidates_max;
    var first = Walk.init(level, self, position, constants.match_len_max, budget);
    var second = Walk.init(level, self, position + 1, constants.match_len_max, budget);
    // The first walk's nearest candidate often settles the second's budget, so it goes first.
    first.step(level, self, false);
    follow(level, first.found, &second);
    while (!first.done or !second.done) {
        second.step(level, self, true);
        const found_len = first.found.len;
        first.step(level, self, false);
        // Only a longer match changes what the second walk does.
        if (first.found.len != found_len) follow(level, first.found, &second);
    }
    return .{ .first = first.found, .second = second.result(level, first.found.len >= level.cut_len) };
}

/// Makes a pair's second walk follow the first's match `found`: ended once it is `lazy_len` long,
/// and cut to `cut_candidates_max` once it is `cut_len` long.
inline fn follow(comptime level: constants.Level, found: Match, second: *Walk) void {
    if (found.len >= level.lazy_len) second.done = true;
    if (found.len >= level.cut_len) second.budget = level.cut_candidates_max;
}

/// Where the 4 octets that decide a candidate against `found` start: the octet after `found` ends,
/// less the 4, or the match's first octets while none is found.
pub inline fn tail_of(found: Match) u8 {
    assert(found.len == 0 or found.len >= constants.match_len_taken_min);
    return @intCast(found.len -| (constants.match_len_taken_min - 1));
}

/// The match at `candidate` for `position` when it is longer than `found`, else `found`.
inline fn longer_match(comptime level: constants.Level, self: *const Matcher(level), position: usize, candidate: u16, later: []const u8, found: Match) Match {
    const len = match_len(self.window[candidate..][0..later.len], later);
    if (len <= found.len) return found;
    return .{ .len = @intCast(len), .distance = @intCast(position - candidate) };
}

// Tests of `short_chain_misses`: chains set by hand in a window of zeros, then a seeded window
// whose chains are built as the lazy loop builds them.

const testing = std.testing;
const codec = @import("codec");

/// The lazy levels, which read short chains: level 6, whose window is padded and whose walks run
/// inline, and level 9.
const short_level_number = 6;
const long_level_number = 9;
const short_level = constants.level(short_level_number);
const long_level = constants.level(long_level_number);

/// The 4 octets a test's position holds, and 4 that differ from them.
const position_octets = "ABCD";
const other_octets = "ABCE";

/// One candidate of a test's chain: its position, and whether it holds the position's octets.
const Link = struct { at: u16, holds: bool = false };

/// Makes `matcher` a window of zeros that holds `position_octets` at `position`, whose chain names
/// `links`, the nearest first: each link's own link is the next, and the last's none.
fn set_chain(comptime level: constants.Level, matcher: *Matcher(level), position: usize, links: []const Link) void {
    matcher.init();
    @memset(&matcher.window, 0);
    @memset(&matcher.chain, 0);
    matcher.filled = constants.encoder_window_len;
    @memcpy(matcher.window[position..][0..position_octets.len], position_octets);
    var from = position;
    for (links) |link| {
        matcher.chain[slot(from)] = link.at;
        @memcpy(matcher.window[link.at..][0..position_octets.len], if (link.holds) position_octets else other_octets);
        from = link.at;
    }
}

/// The most candidates the tests read: each count from one, the lazy loop's among them.
const count_max = 4;

comptime {
    assert(short_chain_len < count_max);
}

/// `short_chain_misses` of `count` candidates at `position`, over the chain `set_chain` makes of
/// `links`, at one level.
fn misses_at(comptime level: constants.Level, comptime count: usize, position: usize, links: []const Link) bool {
    var matcher: Matcher(level) = undefined;
    set_chain(level, &matcher, position, links);
    return short_chain_misses(level, count, &matcher, position);
}

/// `misses_at` at both lazy levels, which give one answer.
fn misses(comptime count: usize, position: usize, links: []const Link) !bool {
    const answer = misses_at(short_level, count, position, links);
    try testing.expectEqual(answer, misses_at(long_level, count, position, links));
    return answer;
}

/// The octets between a test chain's candidates.
const link_gap = 1000;

/// A chain of `count` candidates in reach of `position`, the nearest `link_gap` before it and each
/// `link_gap` before the last, none holding the position's octets.
fn spaced(buffer: []Link, position: usize, count: usize) []Link {
    for (buffer[0..count], 1..) |*link, nth| link.* = .{ .at = @intCast(position - nth * link_gap) };
    return buffer[0..count];
}

test "a chain of up to the count of candidates read, none holding the position's octets, misses" {
    const position = 40_000;
    inline for (1..count_max + 1) |count| {
        var buffer: [count]Link = undefined;
        for (0..count + 1) |held| try testing.expect(try misses(count, position, spaced(&buffer, position, held)));
    }
}

test "a candidate read that holds the position's octets, or one after those read, does not miss" {
    const position = 40_000;
    inline for (1..count_max + 1) |count| {
        var buffer: [count + 1]Link = undefined;
        for (0..count) |index| {
            // The candidates before it and after it, as many as are read, hold other octets.
            const links = spaced(&buffer, position, count);
            links[index].holds = true;
            try testing.expect(!try misses(count, position, links));
        }
        try testing.expect(!try misses(count, position, spaced(&buffer, position, count + 1)));
    }
}

test "each candidate's reach ends at encoder_distance_max" {
    const position = 40_000;
    const farthest = position - constants.encoder_distance_max;
    inline for (1..count_max + 1) |count| {
        var buffer: [count + 1]Link = undefined;
        for (0..count + 1) |index| {
            const links = spaced(&buffer, position, index + 1);
            // At the farthest distance a candidate read counts by what it holds, and the one
            // after those read starts a walk whatever it holds.
            links[index] = .{ .at = farthest };
            try testing.expectEqual(index < count, try misses(count, position, links));
            links[index] = .{ .at = farthest, .holds = true };
            try testing.expect(!try misses(count, position, links));
            // One octet farther it is no candidate.
            links[index] = .{ .at = farthest - 1, .holds = true };
            try testing.expect(try misses(count, position, links));
        }
    }
}

test "position 0 names no candidate, and position 1 is one" {
    const position = 100;
    inline for (1..count_max + 1) |count| {
        try testing.expect(try misses(count, position, &.{.{ .at = 0, .holds = true }}));
        try testing.expect(!try misses(count, position, &.{.{ .at = 1, .holds = true }}));
        try testing.expect(try misses(count, position, &.{.{ .at = 1 }}));
    }
}

test "the link in a slot whose candidate fell out of reach is not followed" {
    // A candidate out of reach shares its slot with the position `window_len` after it, so the
    // link there may name a candidate in reach that holds the position's octets.
    const position = 40_000;
    const stale = 5_000;
    const named = 37_500;
    inline for (1..count_max + 1) |count| {
        var buffer: [count + 1]Link = undefined;
        for (0..count) |index| {
            const links = spaced(&buffer, position, index + 2);
            links[index] = .{ .at = stale, .holds = true };
            links[index + 1] = .{ .at = named, .holds = true };
            try testing.expect(try misses(count, position, links));
        }
    }
}

/// What `skips_search` answers at one level, in each state the lazy loop tells apart.
fn expect_skips(comptime level: constants.Level) !void {
    const position = 40_000;
    var matcher: Matcher(level) = undefined;
    set_chain(level, &matcher, position, &.{});
    // After a literal, in a block whose literals are not cheap.
    try testing.expect(skips_search(level, false, &matcher, position, 0, true));
    try testing.expect(skips_search(level, false, &matcher, position, 0, false));
    // A position after a match found, and one in a block of cheap literals, search as before.
    try testing.expect(!skips_search(level, false, &matcher, position, constants.match_len_taken_min, true));
    try testing.expect(!skips_search(level, true, &matcher, position, 0, true));
    // A chain that holds the position's octets starts its walk.
    set_chain(level, &matcher, position, &.{.{ .at = position - link_gap, .holds = true }});
    try testing.expect(!skips_search(level, false, &matcher, position, 0, true));
    // A waiting match of `lazy_len` is taken with no search, in every block.
    try testing.expect(skips_search(level, false, &matcher, position, level.lazy_len, true));
    try testing.expect(skips_search(level, true, &matcher, position, level.lazy_len, true));
}

test "a search is skipped where a short chain misses after a literal, and where a long match waits" {
    try expect_skips(short_level);
    try expect_skips(long_level);
}

/// `short_chain_misses`, by a walk that tests one candidate after another.
fn misses_plainly(comptime level: constants.Level, count: usize, matcher: *const Matcher(level), position: usize) bool {
    const lowest = @max(1, position -| constants.encoder_distance_max);
    const word = tail_octets(matcher.window[position..], 0);
    var candidate = matcher.chain[slot(position)];
    for (0..count) |_| {
        if (candidate < lowest) return true;
        if (tail_octets(matcher.window[candidate..], 0) == word) return false;
        candidate = matcher.chain[slot(candidate)];
    }
    return candidate < lowest;
}

/// The values a seeded window's octets take: few enough that 4 octets recur, and enough that most
/// positions with one hash hold other octets.
const seeded_values = 16;

/// The seed of the seeded window.
const seeded_seed = 29;

/// Each answer is given at more than one position in this many of a seeded window's.
const answer_share = 4;

/// Over a seeded window at one level: the answer is a plain walk's at every count, and where it
/// misses, the level's search finds no match.
fn expect_seeded(comptime level: constants.Level) !void {
    var matcher: Matcher(level) = undefined;
    matcher.init();
    var generator = codec.split.Generator.init(seeded_seed);
    for (matcher.window[0..constants.encoder_window_len]) |*octet| octet.* = 'a' + @as(u8, @intCast(generator.below(seeded_values)));
    matcher.filled = constants.encoder_window_len;
    // Every position joins its chain as the lazy loop's insert joins it, past a slide's worth of
    // positions, so later positions take the slots of earlier ones.
    const positions = constants.encoder_window_len - constants.lookahead_min;
    const hash_shift = @bitSizeOf(u32) - @as(u6, level.hash_bits);
    var missed: usize = 0;
    for (1..positions) |position| {
        const word = tail_octets(matcher.window[position..], 0);
        const head = &matcher.heads[(word *% constants.hash_multiplier) >> hash_shift];
        matcher.chain[slot(position)] = head.*;
        head.* = @intCast(position);
        matcher.position = position;
        inline for (1..count_max + 1) |count| try testing.expectEqual(misses_plainly(level, count, &matcher, position), short_chain_misses(level, count, &matcher, position));
        const expected = misses_plainly(level, short_chain_len, &matcher, position);
        if (!expected) continue;
        try testing.expectEqual(0, best_inline(level, false, &matcher, constants.match_len_max, 0).len);
        missed += 1;
    }
    // Both answers occur often.
    try testing.expect(missed > positions / answer_share and missed < positions - positions / answer_share);
}

test "over a seeded window the answer is a plain walk's, and where it misses a search finds none" {
    try expect_seeded(short_level);
    try expect_seeded(long_level);
}
