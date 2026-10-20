//! The greedy level's loop, level 1's: a position takes the candidate its hash names, the one
//! position before it with the same hash, or a literal (decision 13). A piece of encoder_match.zig,
//! whose `advance_positions` calls `advance_greedy` and `step_greedy`.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const Block = @import("../encoder_block.zig").Block;
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const Match = match.Match;
const tail_octets = match.tail_octets;
const match_len = match.match_len;
const hash = match.hash;
const hash_of_word = match.hash_of_word;
const lookahead_end = match.lookahead_end;

/// The greedy level's positions with the whole lookahead ahead, decided until the block fills or
/// the lookahead runs out; `step_greedy` takes the positions after them.
pub fn advance_greedy(comptime level: constants.Level, self: *Matcher(level), block: *Block) void {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(!level.chains);
    const lookahead = lookahead_end(level, self) orelse return;
    // The position lives in a local through the loop, so the stores to the heads and the block do
    // not make the compiler reload it; the end is bounded by the window too, so a match's octets
    // need no bounds check.
    const end = @min(lookahead, constants.encoder_window_len - constants.match_len_max + 1);
    const start = self.position;
    var position = start;
    var symbols = block.appender(level.runtime_safety);
    while (position < end and !symbols.full()) {
        // The position's first 8 octets, least significant first; the low 4 are its hash's word.
        const later = std.mem.readInt(u64, self.window[position..][0..@sizeOf(u64)], .little);
        const word: u32 = @truncate(later);
        const head = &self.heads[hash_of_word(level, word)];
        const pair = head.*;
        head.* = (pair << @bitSizeOf(u16)) | @as(u16, @intCast(position));
        const near: u16 = @truncate(pair);
        const far: u16 = @truncate(pair >> @bitSizeOf(u16));
        const near_octets = candidate_octets(level, self, near);
        const far_octets = candidate_octets(level, self, far);
        // One branch asks whether either candidate's first 4 octets equal the position's; the
        // reach and candidate 0 are tested on the candidate a match takes.
        const near_differs = @intFromBool(@as(u32, @truncate(near_octets)) != word);
        const far_differs = @intFromBool(@as(u32, @truncate(far_octets)) != word);
        const found: Match = if (near_differs & far_differs == 1) .{} else pair_match(level, self, position, near, far, near_octets ^ later, far_octets ^ later);
        if (found.len >= constants.match_len_taken_min) {
            symbols.pair(found.len, found.distance);
            const match_end = position + found.len;
            if (found.len <= level.covered_insert_len_max) insert_match(level, self, match_end, found.len, found.distance);
            position = match_end;
        } else {
            // The word's first octet is the position's.
            symbols.literal(@truncate(word));
            position += 1;
        }
    }
    // The symbols cover every octet from `start` to `position`.
    symbols.finish(position - start);
    self.position = position;
}

/// `insert_covered` for a match the loop of positions with the whole lookahead ahead takes: the
/// lookahead holds the 4 octets of each covered position, so every one counts. The match's last 3
/// positions always join their entries, as their words reach past it, and before them a head of
/// at most twice the distance: the positions the cut keeps (`insert_covered`).
inline fn insert_match(comptime level: constants.Level, self: *Matcher(level), match_end: usize, len: usize, distance: usize) void {
    @setRuntimeSafety(level.runtime_safety);
    assert(len >= constants.match_len_taken_min and len <= constants.match_len_max);
    assert(distance >= 1);
    assert(match_end + constants.hash_len - 1 <= self.filled);
    const tail_len = constants.hash_len - 1;
    // At most `match_len_max` less 4, so it fits a u8.
    const head_len: u8 = @intCast(@min(len - constants.match_len_taken_min, 2 * distance));
    // Window positions fit 16 bits, so no sum of the first and an offset wraps. From a u16
    // position, the padded window holds a u8 of octets and 3 more, so neither slice is checked.
    const first: u16 = @truncate(match_end - tail_len - head_len);
    const head = self.window[first..][0 .. @as(usize, head_len) + tail_len];
    for (0..head_len) |offset| insert_word(level, self, head[offset..][0..constants.hash_len], first +% @as(u16, @truncate(offset)));
    const tail_at = first +% head_len;
    const tail = self.window[tail_at..][0 .. 2 * tail_len];
    inline for (0..tail_len) |offset| insert_word(level, self, tail[offset..][0..constants.hash_len], tail_at +% @as(u16, offset));
}

/// Makes `at`, whose 4 octets `octets` holds, the later position of its hash's entry.
inline fn insert_word(comptime level: constants.Level, self: *Matcher(level), octets: *const [constants.hash_len]u8, at: u16) void {
    @setRuntimeSafety(level.runtime_safety);
    const head = &self.heads[hash_of_word(level, std.mem.readInt(u32, octets, .little))];
    head.* = (head.* << @bitSizeOf(u16)) | at;
}

/// The 8 octets at `candidate`, least significant first. A candidate lies before the position, so
/// the octets are input.
inline fn candidate_octets(comptime level: constants.Level, self: *const Matcher(level), candidate: u16) u64 {
    @setRuntimeSafety(level.runtime_safety);
    return std.mem.readInt(u64, self.window[candidate..][0..@sizeOf(u64)], .little);
}

/// The match at `position` from the bucket's `near` and `far` positions, when the first 4 octets of
/// one or both equal the position's: the longer, the near one on a tie, of those that name a
/// position in reach (`greedy_match`). Each difference is a candidate's first 8 octets XOR the
/// position's, so below 8 a length is the count of its low zero octets. A candidate whose first 4
/// octets differ is shorter than one whose octets equal. Only the candidate taken is tested
/// against the reach and position 0; when it fails, `fallback_match` decides.
inline fn pair_match(comptime level: constants.Level, self: *const Matcher(level), position: usize, near: u16, far: u16, near_difference: u64, far_difference: u64) Match {
    @setRuntimeSafety(level.runtime_safety);
    assert(position + constants.match_len_max <= constants.encoder_window_len);
    // A zero difference counts 8 until its compare goes on from octet 8.
    var near_len: usize = @ctz(near_difference) / @bitSizeOf(u8);
    var far_len: usize = @ctz(far_difference) / @bitSizeOf(u8);
    if (@intFromBool(near_difference == 0) | @intFromBool(far_difference == 0) == 1) {
        if (near_difference == 0) near_len = long_len(level, self, position, near);
        // A near match of `match_len_max` octets leaves the far one nothing to win.
        if (far_difference == 0 and near_len < constants.match_len_max) far_len = long_len(level, self, position, far);
    }
    const take_far = far_len > near_len;
    const source: usize = if (take_far) far else near;
    if (!in_reach(position, source)) return fallback_match(position, near, far, near_len, take_far);
    return .{ .len = @intCast(if (take_far) far_len else near_len), .distance = @intCast(position - source) };
}

/// Whether `candidate` names a position the match at `position` may reach: not 0, and no farther
/// back than `encoder_distance_max`.
inline fn in_reach(position: usize, candidate: usize) bool {
    if (candidate == 0) return false;
    assert(candidate < position);
    return position - candidate <= constants.encoder_distance_max;
}

/// The match when the candidate `pair_match` took fails `in_reach`. A bucket's near position is
/// never below its far one: inserts come in rising order, and a slide lowers both alike. So when
/// the near one failed, the far one fails too; when the far one failed, the near one is the match
/// if its first 4 octets equal the position's and it lies in reach.
fn fallback_match(position: usize, near: u16, far: u16, near_len: usize, took_far: bool) Match {
    assert(near >= far);
    if (!took_far or near_len < constants.match_len_taken_min or !in_reach(position, near)) return .{};
    return .{ .len = @intCast(near_len), .distance = @intCast(position - near) };
}

/// A candidate's length when its first 8 octets equal the position's: 8, and the compare from
/// octet 8 on.
inline fn long_len(comptime level: constants.Level, self: *const Matcher(level), position: usize, candidate: u16) usize {
    @setRuntimeSafety(level.runtime_safety);
    const equal_len = @sizeOf(u64);
    const later = self.window[position + equal_len ..][0 .. constants.match_len_max - equal_len];
    const earlier = self.window[@as(usize, candidate) + equal_len ..][0 .. constants.match_len_max - equal_len];
    return equal_len + match_len(level.runtime_safety, earlier, later);
}

/// `greedy_match` at `position`, whose 4 octets `word` holds, with `match_len_max` octets ahead.
fn greedy_match_word(comptime level: constants.Level, self: *const Matcher(level), position: usize, candidate: u16, word: u32) Match {
    @setRuntimeSafety(level.runtime_safety);
    assert(position + constants.match_len_max <= constants.encoder_window_len);
    if (candidate == 0 or @as(usize, candidate) + constants.encoder_distance_max < position) return .{};
    assert(candidate < position);
    if (tail_octets(level.runtime_safety, self.window[candidate..], 0) != word) return .{};
    const len = match_len(level.runtime_safety, self.window[candidate..][0..constants.match_len_max], self.window[position..][0..constants.match_len_max]);
    return .{ .len = @intCast(len), .distance = @intCast(position - candidate) };
}

/// One greedy step at a position with `ahead` octets ahead, fewer than the lookahead.
pub fn step_greedy(comptime level: constants.Level, self: *Matcher(level), block: *Block, ahead: usize) void {
    @setRuntimeSafety(level.runtime_safety);
    var found: Match = .{};
    if (ahead >= constants.hash_len) {
        const head = &self.heads[hash(level, self, self.position)];
        const pair = head.*;
        head.* = (pair << @bitSizeOf(u16)) | @as(u16, @intCast(self.position));
        const len_max = @min(ahead, constants.match_len_max);
        found = greedy_match(level, self, @truncate(pair), len_max);
        const other = greedy_match(level, self, @truncate(pair >> @bitSizeOf(u16)), len_max);
        if (other.len > found.len) found = other;
    }
    if (found.len >= constants.match_len_taken_min) {
        block.add_pair(level.runtime_safety, found.len, found.distance);
        const match_end = self.position + found.len;
        if (found.len <= level.covered_insert_len_max) insert_covered(level, self, self.position, match_end, found.distance);
        self.position = match_end;
    } else {
        block.add_literal(level.runtime_safety, self.window[self.position]);
        self.position += 1;
    }
}

/// Makes every position the match at `position` covers, after its first, its hash's head, so a
/// later match may start there and the head names the nearest position. Only positions with
/// `hash_len` octets in the window count. The 4 octets slide through a word: one octet loaded per
/// position. Inline, as a call's setup cost level 1 more than the few inserts of a short match.
inline fn insert_covered(comptime level: constants.Level, self: *Matcher(level), position: usize, end: usize, distance: usize) void {
    @setRuntimeSafety(level.runtime_safety);
    assert(position < end and end <= self.filled);
    assert(distance >= 1);
    const last = @min(end, self.filled - (constants.hash_len - 1));
    // A covered position whose 4 octets the match repeats `distance` and twice `distance` later
    // leaves its entry before the match ends: both later positions join the same entry after it,
    // and an entry keeps its last two. Its insert changes no entry, so the inserts start where the
    // match's last word less twice the distance does.
    const repeats_end = @min(last, end - (constants.hash_len - 1));
    const first = @max(position + 1, repeats_end -| 2 * distance);
    var covered = first;
    while (covered < last) : (covered += 1) {
        const word = std.mem.readInt(u32, self.window[covered..][0..constants.hash_len], .little);
        const head = &self.heads[hash_of_word(level, word)];
        head.* = (head.* << @bitSizeOf(u16)) | @as(u16, @truncate(covered));
    }
}

/// The match at `candidate`, of at least `match_len_taken_min` octets, or none: the greedy level's
/// one candidate, the head. Its first 4 octets decide before `match_len` compares.
fn greedy_match(comptime level: constants.Level, self: *const Matcher(level), candidate: u16, len_max: usize) Match {
    @setRuntimeSafety(level.runtime_safety);
    assert(len_max >= constants.match_len_taken_min and self.position + len_max <= self.filled);
    if (candidate == 0 or @as(usize, candidate) + constants.encoder_distance_max < self.position) return .{};
    assert(candidate < self.position);
    const later = self.window[self.position..][0..len_max];
    if (tail_octets(level.runtime_safety, self.window[candidate..], 0) != tail_octets(level.runtime_safety, later, 0)) return .{};
    const len = match_len(level.runtime_safety, self.window[candidate..][0..len_max], later);
    return .{ .len = @intCast(len), .distance = @intCast(self.position - candidate) };
}
