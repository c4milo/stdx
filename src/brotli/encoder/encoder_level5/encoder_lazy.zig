//! Level 5's parse (decision 62): at each position the four last distances and the 16 candidates
//! of its bucket, each match weighed by what it saves over its literals (`Commands.takes`'s cost),
//! and a lazy step: a match is held while the next position's saves more. A match then extends back
//! over the literals before it, and every position it covers joins the buckets.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");
const buckets_module = @import("encoder_buckets.zig");
const encoder_words = @import("encoder_words.zig");
const hits_aarch64 = @import("encoder_hits_aarch64.zig");
const hits_x86_64 = @import("encoder_hits_x86_64.zig");
/// The assembly that weighs a bucket's hits on this target, if one takes it (decision 66, part 5).
pub const hits_assembly = if (hits_aarch64.takes) hits_aarch64 else hits_x86_64;
pub const hits_assembly_takes = hits_aarch64.takes or hits_x86_64.takes;

const Buckets = buckets_module.Buckets;

/// A match and what it saves, in eighths of a bit, over its literals: `len` octets `offset` back, or
/// for a static dictionary word of `word_len` octets, the `len` it writes at the distance `offset`.
pub const Found = struct { position: usize, len: usize, offset: usize, saves: i64, word_len: usize = 0 };

/// The octets a parse reads at a position: a match's compare reads 8 at a time.
pub const read_len = codec.constants.match_read_len;

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
pub fn lazy(comptime safety: bool, buckets: *Buckets, window: []const u8, found: *Found, search_end: usize, end: usize, reach_len: usize, commands: anytype) usize {
    @setRuntimeSafety(safety);
    var probed = found.position + 1;
    for (0..end - found.position) |_| {
        const next_position = found.position + 1;
        if (next_position >= search_end) break;
        probed = next_position + 1;
        const next = probe(safety, buckets, window, next_position, end, reach_len, commands, found.*) orelse break;
        if (next.saves <= found.saves) break;
        // A match at a last distance keeps the next command's distance short; the next position must
        // save a margin more to break that chain (decision 66, after Google's quality 5's margin).
        // A word's distance can equal a last distance only at a stream's start, and takes no margin.
        // The ring is searched only here, where the next position already saves more.
        if (next.saves <= found.saves + constants.encoder_level5.lazy_margin and keeps_distance(found.*, commands)) break;
        found.* = next;
    }
    return probed;
}

/// The lazy step's search at `position`, for a match that saves more than `held`, the match the
/// step holds (decision 66, after the lazy search of Google's quality 5). It measures only:
/// - a last distance whose first 4 octets agree, as its short code can pay for a shorter match;
/// - a bucket's candidate that agrees on the 4 octets that end at `held`'s length, so it may be as
///   long.
/// One compare refuses each other candidate of the bucket. Records `position` in its bucket.
pub fn probe(comptime safety: bool, buckets: *Buckets, window: []const u8, position: usize, end: usize, reach_len: usize, commands: anytype, held: Found) ?Found {
    @setRuntimeSafety(safety);
    assert(position > 0 and position + read_len <= end and end <= window.len);
    assert(held.len >= min_len);
    const low = @max(position -| reach_len, 1);
    const cost = commands.literal_cost;
    var found: ?Found = null;
    const head = read32(safety, window, position);
    for (commands.last_distances) |distance| {
        if (distance > position - low) continue;
        if (read32(safety, window, position - distance) != head) continue;
        take(safety, window, position, position - distance, end, true, cost, &found);
    }
    const slot = Buckets.slot_of(safety, window, position);
    probe_hits(safety, buckets, slot, window, position, end, low, cost, held, &found);
    buckets.insert_at(safety, slot, position);
    // After a word or a match of the fewest octets, the window seldom holds a match here, and a
    // word may save more.
    const after_short = held.word_len > 0 or held.len == min_len;
    if (found == null and after_short) consider_word(safety, window, position, end, reach_len, commands, &found);
    return found;
}

/// The probe over the hits of `slot`'s bucket: each candidate `Floor` admits is measured.
inline fn probe_hits(comptime safety: bool, buckets: *const Buckets, slot: buckets_module.Slot, window: []const u8, position: usize, end: usize, low: usize, cost: u32, held: Found, found: *?Found) void {
    @setRuntimeSafety(safety);
    const floor = Floor.of(safety, window, position, end, held, cost);
    var hits = buckets.hits(slot);
    for (0..buckets_module.ways) |_| {
        if (hits == 0) break;
        const way = @ctz(hits);
        hits &= hits - 1;
        const candidate = buckets.candidate(buckets.entries[slot.bucket][way], low, position) orelse continue;
        if (!floor.admits(safety, window, position, candidate)) continue;
        take(safety, window, position, candidate, end, false, cost, found);
    }
}

/// What a bucket's candidate must agree on for the probe to measure it: the 4 octets `tail` at
/// `at`, which end at the held match's length, or, nearer than `near`, the 4 octets one before.
const Floor = struct {
    at: usize,
    tail: u32,
    near: usize,
    shorter_tail: u32,

    inline fn of(comptime safety: bool, window: []const u8, position: usize, end: usize, held: Found, cost: u32) Floor {
        @setRuntimeSafety(safety);
        // Where `held`'s length passes the block's end, no candidate is as long: the first 4
        // octets stand for the tail, and every true candidate is measured.
        const at = if (position + held.len <= end) held.len - @sizeOf(u32) else 0;
        return .{
            .at = at,
            .tail = read32(safety, window, position + at),
            // A candidate one octet shorter agrees on the 4 octets one before the tail's; none
            // is, where `held` has the fewest octets a match takes.
            .near = if (at > 0) near_limit(held, cost) else 0,
            .shorter_tail = read32(safety, window, position + at -| 1),
        };
    }

    inline fn admits(self: Floor, comptime safety: bool, window: []const u8, position: usize, candidate: usize) bool {
        @setRuntimeSafety(safety);
        if (read32(safety, window, candidate + self.at) == self.tail) return true;
        if (position - candidate >= self.near) return false;
        return read32(safety, window, candidate + self.at - 1) == self.shorter_tail;
    }
};

/// The distance below which a candidate one octet shorter than `held` can save more than `held`
/// does: it saves `(held.len - 1) * cost` less a match's cost and 8 eighths for each bit of its
/// distance's log2, as `saving` weighs it. 0 where no distance is near enough.
pub fn near_limit(held: Found, cost: u32) usize {
    const most: i64 = @as(i64, @intCast((held.len - 1) * cost)) - constants.encoder_match_cost_base;
    const slack = most - held.saves;
    if (slack <= 0) return 0;
    const bits: usize = @intCast(@divFloor(slack + encoder_commands.eighths - 1, encoder_commands.eighths));
    return @as(usize, 1) << @intCast(@min(bits, @bitSizeOf(usize) - 1));
}

/// `found` replaced by `candidate`'s match where it has the fewest octets a match takes and saves
/// more.
inline fn take(comptime safety: bool, window: []const u8, position: usize, candidate: usize, end: usize, last: bool, cost: u32, found: *?Found) void {
    @setRuntimeSafety(safety);
    const len = match_len(safety, window, candidate, position, end);
    if (len < min_len) return;
    keep(position, candidate, len, last, cost, found);
}

/// `found` replaced by `candidate`'s match of `len` octets where it saves more.
inline fn keep(position: usize, candidate: usize, len: usize, last: bool, cost: u32, found: *?Found) void {
    const saves = saving(len, position - candidate, last, cost);
    if (found.*) |best_so_far| {
        if (saves <= best_so_far.saves) return;
    }
    found.* = .{ .position = position, .len = len, .offset = position - candidate, .saves = saves };
}

/// Whether `found` is a match at one of the last distances, whose short code the next command's
/// distance then takes (RFC 7932 §4).
fn keeps_distance(found: Found, commands: anytype) bool {
    return found.word_len == 0 and std.mem.indexOfScalar(u32, &commands.last_distances, @intCast(found.offset)) != null;
}

/// The match at `position` that saves the most, or none that saves anything. Records `position` in
/// its bucket.
fn best(comptime safety: bool, buckets: *Buckets, window: []const u8, position: usize, end: usize, reach_len: usize, commands: anytype) ?Found {
    @setRuntimeSafety(safety);
    // Position 0 names no candidate: no octet lies before it.
    if (position == 0) {
        buckets.insert(safety, window, position);
        return null;
    }
    // `match_len`'s bounds, once for every candidate of the position.
    assert(position + read_len <= end and end <= window.len);
    const low = @max(position -| reach_len, 1);
    var pick: Pick = .{ .here = read64(safety, window, position), .cost = commands.literal_cost };
    // The last distances first: a short code, with no extra bits (RFC 7932 §4).
    for (commands.last_distances) |distance| {
        if (distance > position - low) continue;
        if (read32(safety, window, position - distance) != @as(u32, @truncate(pick.here))) continue;
        pick.weigh(safety, window, position, position - distance, .last);
    }
    // The entries whose check matches the position's, the lowest way first.
    const slot = Buckets.slot_of(safety, window, position);
    weigh_hits(safety, buckets, slot, window, position, low, &pick);
    buckets.insert_at(safety, slot, position);
    var found = pick.measure_long(safety, window, position, end);
    // The words only where the window gave no match.
    if (found == null) consider_word(safety, window, position, end, reach_len, commands, &found);
    return found;
}

/// Weighs the hits of `slot`'s bucket into `pick`: in assembly for the unchecked loop
/// (decision 66, part 5), else in Zig, the reference the assembly makes the same choice as.
inline fn weigh_hits(comptime safety: bool, buckets: *const Buckets, slot: buckets_module.Slot, window: []const u8, position: usize, low: usize, pick: *Pick) void {
    @setRuntimeSafety(safety);
    var hits = buckets.hits(slot);
    // Many positions of a row of literals have no hit, and then the state costs more than the scan.
    if (hits == 0) return;
    if (comptime hits_assembly_takes and !safety) {
        var state: hits_assembly.State = .{
            .window = window.ptr,
            .here = pick.here,
            .cost = pick.cost,
            .position = position,
            .low = low,
            .reach = position - low,
            .base = buckets.base,
            .entries = &buckets.entries[slot.bucket],
            .hits = hits,
            .saves = pick.saves,
            .candidate = pick.candidate,
            .long = &pick.long,
            .long_count = pick.long_count,
        };
        hits_assembly.weigh(&state);
        pick.saves = state.saves;
        pick.candidate = state.candidate;
        pick.long_count = state.long_count;
        return;
    }
    for (0..buckets_module.ways) |_| {
        if (hits == 0) break;
        const way = @ctz(hits);
        hits &= hits - 1;
        const candidate = buckets.candidate(buckets.entries[slot.bucket][way], low, position) orelse continue;
        pick.weigh(safety, window, position, candidate, .bucket);
    }
}

/// Where a candidate comes from: the ring of last distances, whose short codes take no extra bits,
/// or the bucket.
const Source = enum { last, bucket };

/// The choice of match at a position (decision 66, part 5), which the assembly makes too:
/// 1. Each candidate, the last distances first and then the bucket's hits by way, weighs the
///    octets it agrees on within the first `read_len`; fewer than `min_len` weigh nothing.
/// 2. The best saving wins, and the first of equal savings stays.
/// 3. Each candidate that agreed on all `read_len` octets is then measured to its end, the last
///    distances first, and wins only by a greater saving.
pub const Pick = struct {
    here: u64,
    cost: u32,
    saves: i64 = 0,
    candidate: usize = 0,
    /// The candidates that agreed on all `read_len` octets, by source.
    last_long: [constants.last_distances_count]usize = undefined,
    last_long_count: usize = 0,
    long: [buckets_module.ways]usize = undefined,
    long_count: usize = 0,

    pub fn weigh(self: *Pick, comptime safety: bool, window: []const u8, position: usize, candidate: usize, comptime source: Source) void {
        @setRuntimeSafety(safety);
        const agreed: usize = @ctz(self.here ^ read64(safety, window, candidate)) / @bitSizeOf(u8);
        if (agreed < min_len) return;
        if (agreed == read_len) self.keep_long(candidate, source);
        const saves = saving(agreed, position - candidate, source == .last, self.cost);
        if (saves <= self.saves) return;
        self.saves = saves;
        self.candidate = candidate;
    }

    fn keep_long(self: *Pick, candidate: usize, comptime source: Source) void {
        switch (source) {
            .last => {
                self.last_long[self.last_long_count] = candidate;
                self.last_long_count += 1;
            },
            .bucket => {
                self.long[self.long_count] = candidate;
                self.long_count += 1;
            },
        }
    }

    /// The best match by rule 3, or none that saves anything.
    pub fn measure_long(self: *Pick, comptime safety: bool, window: []const u8, position: usize, end: usize) ?Found {
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

/// The fewest octets a candidate must agree on: the hash's 4, which a bucket's entries share.
pub const min_len = constants.encoder_level5.hash_len;

/// `found` replaced by the static dictionary word the input at `position` matches, where that
/// saves more. A word's distance is past the farthest the window reaches, by 1 and its word_id
/// (RFC 7932 §8). The window holds the stream from its start, or 2^WBITS octets of history after a
/// slide, past `reach_len`, so the reach is `position` or `reach_len`.
inline fn consider_word(comptime safety: bool, window: []const u8, position: usize, end: usize, reach_len: usize, commands: anytype, found: *?Found) void {
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
pub fn saving(len: usize, offset: usize, last: bool, literal_cost: u32) i64 {
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

/// The octets from `candidate` and from `position` that agree, up to `end`. The caller asserts
/// `position`'s bounds once for all its candidates (decision 66, part 4): each candidate lies
/// below `position`, by the bucket's range test or a last distance's reach.
fn match_len(comptime safety: bool, window: []const u8, candidate: usize, position: usize, end: usize) usize {
    @setRuntimeSafety(safety);
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

pub inline fn read64(comptime safety: bool, window: []const u8, position: usize) u64 {
    @setRuntimeSafety(safety);
    return std.mem.readInt(u64, window[position..][0..@sizeOf(u64)], .little);
}

test {
    _ = @import("encoder_lazy_test.zig");
}
