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
        const word = std.mem.readInt(u32, self.window[position..][0..constants.hash_len], .little);
        const head = &self.heads[hash_of_word(level, word)];
        const pair = head.*;
        head.* = (pair << @bitSizeOf(u16)) | @as(u16, @intCast(position));
        const found = pair_match(level, self, position, pair, word);
        if (found.len >= constants.match_len_taken_min) {
            symbols.pair(found.len, found.distance);
            const match_end = position + found.len;
            if (found.len <= level.covered_insert_len_max) insert_covered(level, self, position, match_end, found.distance);
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

/// The longer of the matches at the two positions `pair` holds, the later on a tie, at `position`,
/// whose 4 octets `word` holds, with `match_len_max` octets ahead. A candidate goes on to
/// `match_len` only when its first 4 octets equal `word`.
inline fn pair_match(comptime level: constants.Level, self: *const Matcher(level), position: usize, pair: u32, word: u32) Match {
    @setRuntimeSafety(level.runtime_safety);
    assert(position + constants.match_len_max <= constants.encoder_window_len);
    const near: u16 = @truncate(pair);
    const far: u16 = @truncate(pair >> @bitSizeOf(u16));
    const near_ok = starts_alike(level, self, position, near, word);
    const far_ok = starts_alike(level, self, position, far, word);
    if (!near_ok and !far_ok) return .{};
    const later = self.window[position..][0..constants.match_len_max];
    const near_len = if (near_ok) match_len(level.runtime_safety, self.window[near..][0..constants.match_len_max], later) else 0;
    const far_len = if (far_ok) match_len(level.runtime_safety, self.window[far..][0..constants.match_len_max], later) else 0;
    const take_far = far_len > near_len;
    const len = if (take_far) far_len else near_len;
    const source: usize = if (take_far) far else near;
    return .{ .len = @intCast(len), .distance = @intCast(position - source) };
}

/// Whether `candidate` is a position within reach of `position` whose first 4 octets equal `word`.
inline fn starts_alike(comptime level: constants.Level, self: *const Matcher(level), position: usize, candidate: u16, word: u32) bool {
    @setRuntimeSafety(level.runtime_safety);
    if (candidate == 0 or @as(usize, candidate) + constants.encoder_distance_max < position) return false;
    assert(candidate < position);
    return tail_octets(level.runtime_safety, self.window[candidate..], 0) == word;
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
