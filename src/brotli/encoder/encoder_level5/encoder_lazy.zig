//! Level 5's parse (decision 62): at each position the four last distances and the 16 candidates
//! of its bucket, each match weighed by what it saves over its literals (`Commands.takes`'s cost),
//! and a lazy step: a match is held while the next position's saves more. A match then extends back
//! over the literals before it, and every position it covers joins the buckets.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");
const buckets_module = @import("encoder_buckets.zig");
const encoder_words = @import("encoder_words.zig");

const Buckets = buckets_module.Buckets;

/// A match and what it saves, in eighths of a bit, over its literals: `len` octets `offset` back, or
/// for a static dictionary word of `word_len` octets, the `len` it writes at the distance `offset`.
const Found = struct { position: usize, len: usize, offset: usize, saves: i64, word_len: usize = 0 };

/// The octets a parse reads at a position: a match's compare reads 8 at a time.
const read_len = codec.constants.match_read_len;

/// Parses `window[start..end]`, whose history is `window[0..start]`, into `commands`. A match
/// reaches back `reach_len` octets at most.
pub fn parse(comptime safety: bool, buckets: *Buckets, window: []const u8, start: usize, end: usize, reach_len: usize, commands: anytype) void {
    @setRuntimeSafety(safety);
    assert(start <= end and end <= window.len);
    const search_end = end -| read_len;
    var position = start;
    var anchor = start;
    for (0..end - start) |_| {
        if (position >= search_end) break;
        var found = best(safety, buckets, window, position, end, reach_len, commands) orelse {
            position += 1 + ((position - anchor) >> constants.encoder_level5.skip_log);
            continue;
        };
        const probed = lazy(safety, buckets, window, &found, search_end, end, reach_len, commands);
        // A word's start is the word's own first octet, so a word does not extend back.
        const taken = if (found.word_len > 0) found else step_back(safety, window, found, anchor);
        if (taken.word_len > 0) {
            commands.add_word(safety, window, anchor, taken.position, taken.len, taken.word_len, taken.offset);
        } else {
            commands.add(safety, window, anchor, taken.position, taken.len, taken.offset);
        }
        const match_end = taken.position + taken.len;
        const covered_end = @min(match_end, search_end);
        for (@min(probed, covered_end)..covered_end) |covered| buckets.insert(safety, window, covered);
        position = match_end;
        anchor = match_end;
    }
    commands.add_literals(safety, window[anchor..end]);
}

/// The lazy step: the next position's match replaces `found` while it saves more. Returns the first
/// position after those the probes recorded, where the covered positions start.
fn lazy(comptime safety: bool, buckets: *Buckets, window: []const u8, found: *Found, search_end: usize, end: usize, reach_len: usize, commands: anytype) usize {
    @setRuntimeSafety(safety);
    var probed = found.position + 1;
    for (0..end - found.position) |_| {
        const next_position = found.position + 1;
        if (next_position >= search_end) break;
        probed = next_position + 1;
        const next = best(safety, buckets, window, next_position, end, reach_len, commands) orelse break;
        if (next.saves <= found.saves) break;
        found.* = next;
    }
    return probed;
}

/// The match at `position` that saves the most, or none that saves anything. Records `position` in
/// its bucket.
///
/// Each candidate is weighed by its first 8 octets with no branch of its own (decision 64, part 1):
/// the octets that agree, from one XOR, and what they save, kept by a select. A candidate whose 8
/// octets all agree goes on a list, and after the scan each one is measured to its end.
fn best(comptime safety: bool, buckets: *Buckets, window: []const u8, position: usize, end: usize, reach_len: usize, commands: anytype) ?Found {
    @setRuntimeSafety(safety);
    // Position 0 names no candidate: no octet lies before it.
    if (position == 0) {
        buckets.insert(safety, window, position);
        return null;
    }
    const low = @max(position -| reach_len, 1);
    var pick: Pick = .{ .here = read64(safety, window, position), .cost = commands.literal_cost };
    // The last distances first: a short code, with no extra bits (RFC 7932 §4). On most rows a
    // last distance's first 4 octets seldom agree, so a branch on them predicts well and saves the
    // weighing.
    for (commands.last_distances) |distance| {
        if (distance > position - low) continue;
        if (read32(safety, window, position - distance) != @as(u32, @truncate(pick.here))) continue;
        pick.weigh(safety, window, position, position - distance, true, true);
    }
    // The entries whose check matches the position's, the lowest way first.
    const slot = Buckets.slot_of(safety, window, position);
    var hits = buckets.hits(slot);
    const reach: u32 = @intCast(position - low);
    for (0..buckets_module.ways) |_| {
        if (hits == 0) break;
        const way = @ctz(hits);
        hits &= hits - 1;
        // An entry of an earlier stream lies below the base, so it wraps past the reach.
        const candidate = buckets.entries[slot.bucket][way] -% buckets.base;
        const valid = candidate -% @as(u32, @intCast(low)) < reach;
        const in_reach = hidden(@as(u64, 0) -% @intFromBool(valid));
        pick.weigh(safety, window, position, (candidate & in_reach) | ((position - 1) & ~in_reach), valid, false);
    }
    buckets.insert_at(safety, slot, position);
    var found = pick.measure_long(safety, window, position, end);
    consider_word(safety, window, position, end, reach_len, commands, &found);
    return found;
}

/// The candidates that agree on all of the first `read_len` octets: a list for the last
/// distances and one for the bucket's ways.
const last_long_max = constants.last_distances_count;
const long_max = buckets_module.ways;

/// The best candidate so far by its first `read_len` octets, and those that agree on all of them.
const Pick = struct {
    here: u64,
    cost: u32,
    saves: i64 = 0,
    candidate: usize = 0,
    long: [long_max]usize = undefined,
    long_count: usize = 0,
    last_long: [last_long_max]usize = undefined,
    last_long_count: usize = 0,

    /// Weighs `candidate`, a match only when `valid`, with no branch: a collision or a candidate
    /// out of reach agrees on fewer than `min_len` octets, and its saving is below 0.
    inline fn weigh(self: *Pick, comptime safety: bool, window: []const u8, position: usize, candidate: usize, valid: bool, comptime last: bool) void {
        @setRuntimeSafety(safety);
        const agreed: usize = @ctz(self.here ^ read64(safety, window, candidate)) / @bitSizeOf(u8);
        const len = agreed & hidden(@as(u64, 0) -% @intFromBool(valid and agreed >= min_len));
        const saves = saving(len, position - candidate, last, self.cost);
        // A mask, not a branch: a branch here mispredicts on most rows.
        const better = saves > self.saves;
        const keep = hidden(@as(u64, 0) -% @intFromBool(better));
        self.saves = @bitCast((@as(u64, @bitCast(saves)) & keep) | (@as(u64, @bitCast(self.saves)) & ~keep));
        self.candidate = (candidate & keep) | (self.candidate & ~keep);
        if (last) {
            self.last_long[self.last_long_count] = candidate;
            self.last_long_count += @intFromBool(len == read_len);
        } else {
            self.long[self.long_count] = candidate;
            self.long_count += @intFromBool(len == read_len);
        }
    }

    /// The best match, after each candidate that agreed on `read_len` octets is measured to its
    /// end: the same match a scan of every candidate to its end would choose.
    inline fn measure_long(self: *Pick, comptime safety: bool, window: []const u8, position: usize, end: usize) ?Found {
        @setRuntimeSafety(safety);
        var len: usize = @ctz(self.here ^ read64(safety, window, self.candidate)) / @bitSizeOf(u8);
        for (self.last_long[0..self.last_long_count]) |candidate| self.measure(safety, window, position, end, candidate, true, &len);
        for (self.long[0..self.long_count]) |candidate| self.measure(safety, window, position, end, candidate, false, &len);
        if (self.saves <= 0) return null;
        return .{ .position = position, .len = len, .offset = position - self.candidate, .saves = self.saves };
    }

    fn measure(self: *Pick, comptime safety: bool, window: []const u8, position: usize, end: usize, candidate: usize, last: bool, len: *usize) void {
        @setRuntimeSafety(safety);
        const long_len = match_len(safety, window, candidate, position, end);
        const saves = saving(long_len, position - candidate, last, self.cost);
        if (saves <= self.saves) return;
        self.saves = saves;
        self.candidate = candidate;
        len.* = long_len;
    }
};

/// `value`, which LLVM cannot see through: a mask it hides keeps a select a select, where LLVM would
/// turn it into a branch that mispredicts on most rows (decision 64, part 1). The self-hosted
/// backends take the value as it is.
inline fn hidden(value: u64) u64 {
    if (builtin.zig_backend != .stage2_llvm) return value;
    return asm (""
        : [result] "=r" (-> u64),
        : [value] "0" (value),
    );
}

/// The fewest octets a candidate must agree on: the hash's 4, as a bucket's entries share them.
const min_len = constants.encoder_level5.hash_len;

/// `found` replaced by the static dictionary word the input at `position` matches, where that
/// saves more. A word's distance is past the farthest the window reaches, by 1 and its word_id
/// (RFC 7932 §8). The window holds the stream from its start, or 2^WBITS octets of history after a
/// slide, past `reach_len`, so the reach is `position` or `reach_len`.
fn consider_word(comptime safety: bool, window: []const u8, position: usize, end: usize, reach_len: usize, commands: anytype, found: *?Found) void {
    @setRuntimeSafety(safety);
    if (found.*) |held| {
        if (held.len >= constants.word_len_max) return;
    }
    const word = encoder_words.find(safety, window, position, end) orelse return;
    const distance = @min(reach_len, position) + 1 + word.word_id;
    const saves = saving(word.written_len, distance, false, commands.literal_cost);
    if (saves <= 0) return;
    if (found.*) |held| {
        if (saves <= held.saves) return;
    }
    found.* = .{ .position = position, .len = word.written_len, .offset = distance, .saves = saves, .word_len = word.word_len };
}

/// What a match saves over its literals, in eighths of a bit, as `Commands.takes` weighs it: a
/// last distance codes with no extra bits.
fn saving(len: usize, offset: usize, last: bool, literal_cost: u32) i64 {
    const distance_bits: usize = if (last) 0 else @as(usize, std.math.log2_int(usize, offset)) * encoder_commands.eighths;
    const cost: i64 = @intCast(constants.encoder_match_cost_base + distance_bits);
    return @as(i64, @intCast(len * literal_cost)) - cost;
}

/// `found` extended back over the literals from `anchor` while the octets before both agree.
fn step_back(comptime safety: bool, window: []const u8, found: Found, anchor: usize) Found {
    @setRuntimeSafety(safety);
    var position = found.position;
    var len = found.len;
    for (0..found.position - anchor) |_| {
        if (position - found.offset == 0) break;
        if (window[position - 1] != window[position - 1 - found.offset]) break;
        position -= 1;
        len += 1;
    }
    return .{ .position = position, .len = len, .offset = found.offset, .saves = found.saves };
}

/// The octets from `candidate` and from `position` that agree, up to `end`.
fn match_len(comptime safety: bool, window: []const u8, candidate: usize, position: usize, end: usize) usize {
    @setRuntimeSafety(safety);
    assert(candidate < position and position <= end);
    const limit = end - position;
    var len: usize = 0;
    for (0..limit / @sizeOf(u64)) |_| {
        const difference = read64(safety, window, candidate + len) ^ read64(safety, window, position + len);
        if (difference != 0) return len + @ctz(difference) / @bitSizeOf(u8);
        len += @sizeOf(u64);
    }
    for (0..limit - len) |_| {
        if (window[candidate + len] != window[position + len]) break;
        len += 1;
    }
    return len;
}

inline fn read32(comptime safety: bool, window: []const u8, position: usize) u32 {
    @setRuntimeSafety(safety);
    return std.mem.readInt(u32, window[position..][0..@sizeOf(u32)], .little);
}

inline fn read64(comptime safety: bool, window: []const u8, position: usize) u64 {
    @setRuntimeSafety(safety);
    return std.mem.readInt(u64, window[position..][0..@sizeOf(u64)], .little);
}

const testing = std.testing;

test "a candidate is weighed by the octets it agrees on, 4 at least" {
    var window: [weigh_window_len]u8 = @splat('-');
    const position = weigh_window_len / 2;
    // At `short_at` 3 octets agree, at `long_at` 6 do; a candidate out of reach agrees on none.
    @memcpy(window[position..][0..weigh_text.len], weigh_text);
    @memcpy(window[short_at..][0..3], weigh_text[0..3]);
    @memcpy(window[long_at..][0..6], weigh_text[0..6]);
    var pick: Pick = .{ .here = read64(true, &window, position), .cost = weigh_literal_cost };
    pick.weigh(true, &window, position, short_at, true, false);
    try testing.expectEqual(0, pick.saves);
    pick.weigh(true, &window, position, long_at, false, false);
    try testing.expectEqual(0, pick.saves);
    pick.weigh(true, &window, position, long_at, true, false);
    try testing.expect(pick.saves > 0);
    try testing.expectEqual(long_at, pick.candidate);
}

const weigh_window_len = 64;
const weigh_text = "abcdefghij";
const short_at = 4;
const long_at = 12;
/// 8 bits a literal, in eighths of a bit.
const weigh_literal_cost = 64;
