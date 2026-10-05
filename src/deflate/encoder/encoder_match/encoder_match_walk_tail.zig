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
        const passed = @min(candidate, self.position -| walk.found.len);
        if (passed <= lowest) {
            walk.left = 0;
            return;
        }
        walk.tail = tail_of(walk.found);
        walk.later_tail = tail_octets(later, walk.tail);
        walk.move(level, self, passed);
        // A tail starts where a match ends, less 3 octets, so no tail starts before an earlier one.
        assert(walk.tail >= walk.offset);
        walk.floor = lowest + walk.offset;
        walk.shift = walk.tail - walk.offset;
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

// Tests: chains set by hand in a window of zeros around a position whose octets do not recur, then
// a seeded window of repeats whose chains are built as the lazy loop builds them.

const testing = std.testing;
const codec = @import("codec");
const best_inline = @import("encoder_match_walk.zig").best_inline;

const tail_level_number = 9;
const tail_level = constants.level(tail_level_number);
const TailMatcher = Matcher(tail_level);

/// A hand-set test's position, with every distance before it and `match_len_max` octets after.
const test_position = 40_000;

/// The seed of a hand-set test's octets, and the values they take: none is 0, the window's rest.
const octets_seed = 46;
const octets_values = std.math.maxInt(u8);

/// The octets at a hand-set test's position: no 4 of them recur among them.
fn position_octets() [constants.match_len_max]u8 {
    var octets: [constants.match_len_max]u8 = undefined;
    var generator = codec.split.Generator.init(octets_seed);
    for (&octets) |*octet| octet.* = @intCast(1 + generator.below(octets_values));
    return octets;
}

/// Makes `matcher` a window of zeros with `octets` at `test_position` and no chain.
fn set_window(matcher: *TailMatcher, octets: []const u8) void {
    matcher.init();
    @memset(&matcher.window, 0);
    @memset(&matcher.chain, 0);
    matcher.filled = constants.encoder_window_len;
    matcher.position = test_position;
    @memcpy(matcher.window[test_position..][0..octets.len], octets);
}

/// One position of a hand-set chain, `distance` before `test_position`, and the octets it holds:
/// `len` of the position's, from the octet `from`. A candidate holds them from 0, and a zero
/// follows, so it matches `len` octets. A position of the tail's chain that names no candidate
/// holds the tail alone.
const Planted = struct { distance: u16, len: u16 = 0, from: u16 = 0 };

/// Writes each of `planted` into the window and links them in order, the nearest first, as the
/// chain `first` starts.
fn plant_chain(matcher: *TailMatcher, octets: []const u8, first: *u16, planted: []const Planted) void {
    var link = first;
    for (planted) |one| {
        const at = test_position - one.distance;
        @memcpy(matcher.window[at..][0..one.len], octets[one.from..][0..one.len]);
        link.* = at;
        link = &matcher.chain[slot(at)];
    }
    link.* = 0;
}

/// The chain of the test position's own 4 octets.
fn plant_candidates(matcher: *TailMatcher, octets: []const u8, planted: []const Planted) void {
    plant_chain(matcher, octets, &matcher.chain[slot(test_position)], planted);
}

/// The chain of the tail of a match `len` octets long. Each of `planted` holds its candidate's
/// octets from the tail on, so its distance is its candidate's less the tail's place.
fn plant_tail(matcher: *TailMatcher, octets: []const u8, len: u16, planted: []const Planted) void {
    const tail = tail_of(.{ .len = len });
    plant_chain(matcher, octets, &matcher.heads[hash_of_word(tail_level, tail_octets(octets, tail))], planted);
}

/// The lengths of the hand-set tests' matches: the nearest candidate's, the tail it leaves, and
/// two longer ones.
const near_len = 10;
const near_tail = near_len - (constants.match_len_taken_min - 1);
const longer_len = 20;
const far_len = 40;

/// A scene's candidates that are no fillers, the nearest and the far: the links the tail's walk
/// reads to the far one.
const scene_ends = 2;

/// A hand-set chain of the position's own octets: the nearest candidate, which matches `near_len`
/// octets, then `fillers` candidates that hold the position's first 4 octets and no more, `gap`
/// apart, then the far candidate, which matches `far_len`.
const Scene = struct {
    near: u16 = 1000,
    fillers: u16 = 6,
    gap: u16 = 1000,
    far: u16 = 9000,

    /// The far candidate's place on the chain of the nearest candidate's tail.
    fn far_on_tail(scene: Scene) Planted {
        return .{ .distance = scene.far - near_tail, .len = far_len - near_tail, .from = near_tail };
    }

    /// The nearest filler's place on that chain, were it to hold the tail: its octets there are
    /// the tail's alone, so the filler stays 4 octets long.
    fn filler_on_tail(scene: Scene) Planted {
        return .{ .distance = scene.near + scene.gap - near_tail, .len = constants.match_len_taken_min, .from = near_tail };
    }

    fn plant(comptime scene: Scene, matcher: *TailMatcher, octets: []const u8) void {
        var planted: [scene.fillers + scene_ends]Planted = undefined;
        planted[0] = .{ .distance = scene.near, .len = near_len };
        for (planted[1..][0..scene.fillers], 1..) |*one, nth| one.* = .{ .distance = @intCast(scene.near + nth * scene.gap), .len = constants.match_len_taken_min };
        planted[scene.fillers + 1] = .{ .distance = scene.far, .len = far_len };
        assert(planted[scene.fillers].distance < scene.far);
        plant_candidates(matcher, octets, &planted);
    }
};

/// The links a plain walk reads to the scene's far candidate: every filler on its way.
fn plain_links(scene: Scene) u16 {
    return scene.fillers + scene_ends;
}

test "a walk reaches a far candidate through its match's tail in the links a plain walk spends on nearer ones" {
    const scene: Scene = .{};
    const octets = position_octets();
    var matcher: TailMatcher = undefined;
    set_window(&matcher, &octets);
    scene.plant(&matcher, &octets);
    plant_tail(&matcher, &octets, near_len, &.{scene.far_on_tail()});
    const far: Match = .{ .len = far_len, .distance = scene.far };
    const near: Match = .{ .len = near_len, .distance = scene.near };
    try testing.expectEqual(far, best_by_tail(tail_level, &matcher, constants.match_len_max, scene_ends));
    try testing.expectEqual(near, best_by_tail(tail_level, &matcher, constants.match_len_max, scene_ends - 1));
    // A tail's chain whose next candidate is the walk's own next one is no shorter way: the walk
    // keeps its chain, the fillers first.
    plant_tail(&matcher, &octets, near_len, &.{ scene.filler_on_tail(), scene.far_on_tail() });
    try testing.expectEqual(far, best_by_tail(tail_level, &matcher, constants.match_len_max, plain_links(scene)));
    try testing.expectEqual(near, best_by_tail(tail_level, &matcher, constants.match_len_max, plain_links(scene) - 1));
}

/// The tail's chain with `count` positions of candidates the walk has passed, then `last`: all
/// but one are nearer than the nearest candidate's own, hold its tail and name no candidate, and
/// one is the nearest candidate's own, which another string of the tail's hash would put there.
fn plant_passed_tail(comptime scene: Scene, matcher: *TailMatcher, octets: []const u8, comptime count: usize, last: Planted) void {
    var planted: [count + 1]Planted = undefined;
    for (planted[0 .. count - 1], 1..) |*one, nth| one.* = .{ .distance = @intCast(nth * (scene.near / count)), .len = constants.match_len_taken_min, .from = near_tail };
    planted[count - 1] = .{ .distance = scene.near - near_tail };
    planted[count] = last;
    plant_tail(matcher, octets, near_len, &planted);
}

test "a move passes tail_skips_max positions of candidates tried, and each counts as a link" {
    const scene: Scene = .{};
    const octets = position_octets();
    var matcher: TailMatcher = undefined;
    set_window(&matcher, &octets);
    scene.plant(&matcher, &octets);
    plant_passed_tail(scene, &matcher, &octets, constants.tail_skips_max, scene.far_on_tail());
    const links = scene_ends + constants.tail_skips_max;
    try testing.expectEqual(far_len, best_by_tail(tail_level, &matcher, constants.match_len_max, links).len);
    try testing.expectEqual(near_len, best_by_tail(tail_level, &matcher, constants.match_len_max, links - 1).len);
}

test "past tail_skips_max positions of candidates tried the walk keeps its chain" {
    const scene: Scene = .{};
    const octets = position_octets();
    var matcher: TailMatcher = undefined;
    set_window(&matcher, &octets);
    // The longer candidate is next on both chains.
    const longer: Planted = .{ .distance = scene.near + scene.gap, .len = longer_len };
    plant_candidates(&matcher, &octets, &.{ .{ .distance = scene.near, .len = near_len }, longer });
    plant_passed_tail(scene, &matcher, &octets, constants.tail_skips_max + 1, .{ .distance = longer.distance - near_tail, .len = longer_len - near_tail, .from = near_tail });
    const links = scene_ends + constants.tail_skips_max;
    try testing.expectEqual(longer_len, best_by_tail(tail_level, &matcher, constants.match_len_max, links).len);
    try testing.expectEqual(near_len, best_by_tail(tail_level, &matcher, constants.match_len_max, links - 1).len);
}

test "a tail's chain names a candidate at the reach's edge, and none one octet past it" {
    const octets = position_octets();
    var matcher: TailMatcher = undefined;
    const edge = constants.encoder_distance_max;
    inline for (.{ edge, edge + 1 }) |distance| {
        const scene: Scene = .{ .far = distance };
        set_window(&matcher, &octets);
        scene.plant(&matcher, &octets);
        plant_tail(&matcher, &octets, near_len, &.{scene.far_on_tail()});
        const expected: Match = if (distance == edge) .{ .len = far_len, .distance = edge } else .{ .len = near_len, .distance = scene.near };
        try testing.expectEqual(expected, best_by_tail(tail_level, &matcher, constants.match_len_max, tail_level.candidates_max));
    }
}

/// The octets a period repeats in the overlap test, and the match the candidate a period back
/// gives.
const period = 10;
const periodic_len = 60;

test "a walk passes the candidates as near as its match is long, and moves to the tail's chain past them" {
    // The position's first octets repeat with a period, so the candidate a period back matches
    // them all, and its tail lies past the position: the tail's chain names the candidates
    // farther back than the match is long, and no nearer one holds a longer match. With fillers
    // the walk moves and reads none; with none both chains name the far candidate next, and the
    // walk keeps its chain.
    inline for (.{ Scene{}, Scene{ .fillers = 0 } }) |scene| {
        var octets = position_octets();
        for (octets[period..periodic_len], period..) |*octet, index| octet.* = octets[index - period];
        var matcher: TailMatcher = undefined;
        set_window(&matcher, &octets);
        const far_matched = periodic_len + far_len;
        var planted: [scene.fillers + scene_ends]Planted = undefined;
        planted[0] = .{ .distance = period, .len = period };
        for (planted[1..][0..scene.fillers], 1..) |*one, nth| one.* = .{ .distance = @intCast(nth * scene.gap), .len = constants.match_len_taken_min };
        planted[scene.fillers + 1] = .{ .distance = scene.far, .len = far_matched };
        plant_candidates(&matcher, &octets, &planted);
        const tail = tail_of(.{ .len = periodic_len });
        plant_tail(&matcher, &octets, periodic_len, &.{.{ .distance = scene.far - tail, .len = far_matched - tail, .from = tail }});
        // Two links either way: the candidate a period back, then the far one.
        try testing.expectEqual(far_matched, best_by_tail(tail_level, &matcher, constants.match_len_max, scene_ends).len);
        try testing.expectEqual(periodic_len, best_by_tail(tail_level, &matcher, constants.match_len_max, scene_ends - 1).len);
    }
}

/// A scene whose fillers take a plain walk's whole budget at level 9, `long_gap` octets apart,
/// before the far candidate.
const long_gap = 6;
const long_far = 30_000;
const long_scene: Scene = .{ .fillers = tail_level.candidates_max, .gap = long_gap, .far = long_far };

test "level 9's search moves to the tail's chain, but not in a block of cheap literals" {
    const octets = position_octets();
    var matcher: TailMatcher = undefined;
    set_window(&matcher, &octets);
    long_scene.plant(&matcher, &octets);
    plant_tail(&matcher, &octets, near_len, &.{long_scene.far_on_tail()});
    try testing.expectEqual(far_len, best_inline(tail_level, false, &matcher, constants.match_len_max, 0).len);
    try testing.expectEqual(near_len, best_inline(tail_level, true, &matcher, constants.match_len_max, 0).len);
}

/// The longest match at `position`, the nearest of the longest, by a compare at every start in
/// reach that holds the position's first 4 octets.
fn longest_plainly(matcher: *const TailMatcher, position: usize, len_max: usize) Match {
    const lowest = @max(1, position -| constants.encoder_distance_max);
    const later = matcher.window[position..][0..len_max];
    var found: Match = .{};
    var candidate = position;
    while (candidate > lowest) {
        candidate -= 1;
        if (tail_octets(matcher.window[candidate..], 0) != tail_octets(later, 0)) continue;
        const len = match_len(matcher.window[candidate..][0..len_max], later);
        if (len > found.len) found = .{ .len = @intCast(len), .distance = @intCast(position - candidate) };
    }
    return found;
}

/// The seeded window: runs of fresh octets of `seeded_values` values, up to `fresh_len_max` long,
/// one run in `fresh_share`, and copies of earlier octets up to `copy_len_max` long from up to
/// `copy_distance_max` back, which repeat with a period where the distance is the shorter.
const seeded_seed = 9;
const seeded_values = 8;
const fresh_share = 3;
const fresh_len_max = 12;
const copy_len_max = 300;
const copy_distance_max = 20_000;

fn fill_repeats(window: []u8) void {
    var generator = codec.split.Generator.init(seeded_seed);
    var at: usize = 0;
    while (at < window.len) {
        const fresh = at == 0 or generator.below(fresh_share) == 0;
        const len: usize = @intCast(@min(window.len - at, 1 + generator.below(if (fresh) fresh_len_max else copy_len_max)));
        const distance: usize = if (fresh) 0 else @intCast(1 + generator.below(@min(at, copy_distance_max)));
        for (window[at..][0..len], at..) |*octet, index| octet.* = if (fresh) 'a' + @as(u8, @intCast(generator.below(seeded_values))) else window[index - distance];
        at += len;
    }
}

/// One position in this many of the seeded window's is searched, and a match is found at more
/// than one in `found_share` of those.
const searched_stride = 53;
const found_share = 2;

test "over a seeded window of repeats a walk with links to spare finds the longest match in reach, the nearest" {
    var matcher: TailMatcher = undefined;
    matcher.init();
    fill_repeats(matcher.window[0..constants.encoder_window_len]);
    matcher.filled = constants.encoder_window_len;
    // Every position joins its chain as the lazy loop's insert joins it, past a slide's worth of
    // positions, so later positions take the slots of earlier ones.
    const positions = constants.encoder_window_len - constants.lookahead_min;
    var searched: usize = 0;
    var matched: usize = 0;
    for (1..positions) |position| {
        const head = &matcher.heads[hash_of_word(tail_level, tail_octets(matcher.window[position..], 0))];
        matcher.chain[slot(position)] = head.*;
        head.* = @intCast(position);
        if (position % searched_stride != 0) continue;
        matcher.position = position;
        const expected = longest_plainly(&matcher, position, constants.match_len_max);
        try testing.expectEqual(expected, best_by_tail(tail_level, &matcher, constants.match_len_max, std.math.maxInt(u16)));
        searched += 1;
        matched += @intFromBool(expected.len > 0);
    }
    try testing.expect(matched > searched / found_share);
}
