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
const lazy_hits = @import("encoder_lazy_hits.zig");
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
        // The bucket the next search reads, so that its cache misses overlap the inserts. Past the
        // last search, the bucket of the last position searched: a prefetch no search needs.
        buckets.prefetch(Buckets.slot_of(safety, window, @min(match_end, search_end - 1)));
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
    const here = read64(safety, window, position);
    // The bucket first, so its cache misses overlap the last distances' compares.
    const slot = Buckets.slot_of_word(here);
    buckets.prefetch(slot);
    // The next position's bucket too, which the next lazy step reads: its 5 octets are in `here`.
    buckets.prefetch(Buckets.slot_of_word(here >> @bitSizeOf(u8)));
    const head: u32 = @truncate(here);
    for (commands.last_distances) |distance| {
        if (distance > position - low) continue;
        if (read32(safety, window, position - distance) != head) continue;
        take(safety, window, position, position - distance, end, true, cost, &found);
    }
    lazy_hits.probe(safety, buckets, slot, window, position, end, low, cost, held, &found);
    buckets.insert_at(safety, slot, position);
    // After a word or a match of the fewest octets, the window seldom holds a match here, and a
    // word may save more.
    const after_short = held.word_len > 0 or held.len == min_len;
    if (found == null and after_short) consider_word(safety, window, position, end, reach_len, commands, &found);
    return found;
}

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
pub inline fn take(comptime safety: bool, window: []const u8, position: usize, candidate: usize, end: usize, last: bool, cost: u32, found: *?Found) void {
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
pub fn best(comptime safety: bool, buckets: *Buckets, window: []const u8, position: usize, end: usize, reach_len: usize, commands: anytype) ?Found {
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
    // The bucket first, so its cache misses overlap the last distances' compares.
    const slot = Buckets.slot_of_word(pick.here);
    buckets.prefetch(slot);
    // The next position's bucket too, which the next search or the lazy probe reads.
    buckets.prefetch(Buckets.slot_of_word(pick.here >> @bitSizeOf(u8)));
    // The last distances first: a short code, with no extra bits (RFC 7932 §4).
    for (commands.last_distances) |distance| {
        if (distance > position - low) continue;
        if (read32(safety, window, position - distance) != @as(u32, @truncate(pick.here))) continue;
        pick.consider(safety, window, position, end, position - distance, .last);
    }
    lazy_hits.consider(safety, buckets, slot, window, position, end, low, &pick);
    // The side table's candidate only where the last distances and the bucket gave no match: it
    // agrees on 4 octets, and the bucket's candidates on 5 (decision 66, the finder's forms).
    if (pick.saves <= 0) {
        if (buckets.side_candidate(slot, low, position)) |candidate| pick.consider(safety, window, position, end, candidate, .bucket);
    }
    buckets.insert_at(safety, slot, position);
    var found = pick.found(position);
    // The words only where the window gave no match.
    if (found == null) consider_word(safety, window, position, end, reach_len, commands, &found);
    return found;
}

/// Where a candidate comes from: the ring of last distances, whose short codes take no extra bits,
/// or the bucket.
const Source = enum { last, bucket };

/// The choice of match at a position (decision 66, part 6), which the assembly makes too:
/// 1. Each candidate, the last distances first and then the bucket's hits newest first, weighs the
///    octets it agrees on within the first `read_len`; fewer than `min_len` weigh nothing. One
///    that agrees on all `read_len` is measured to its end.
/// 2. The best saving wins, and the first of equal savings stays.
/// 3. One compare at the best length refuses a candidate that cannot save more, before its first
///    octets are read. It refuses only what rule 2 would not keep, so the choice is the same.
pub const Pick = struct {
    here: u64,
    cost: u32,
    saves: i64 = 0,
    candidate: usize = 0,
    /// The octets the best match so far agrees on.
    len: usize = 0,

    /// Weighs `candidate` by the octets it agrees on, and measures a long one to its end, unless
    /// one compare shows it saves no more than the best so far.
    pub fn consider(self: *Pick, comptime safety: bool, window: []const u8, position: usize, end: usize, candidate: usize, comptime source: Source) void {
        @setRuntimeSafety(safety);
        const last = source == .last;
        // The octets at the best length first: one compare there refuses most candidates, before
        // their first octets are read.
        if (self.saves_no_more(safety, window, position, end, candidate, last, self.len)) return;
        const agreed: usize = @ctz(self.here ^ read64(safety, window, candidate)) / @bitSizeOf(u8);
        if (agreed < min_len) return;
        var len = agreed;
        if (agreed == read_len) len = match_len(safety, window, candidate, position, end);
        const saves = saving(len, position - candidate, last, self.cost);
        if (saves <= self.saves) return;
        self.saves = saves;
        self.candidate = candidate;
        self.len = len;
    }

    /// The best match, or none that saves anything.
    pub fn found(self: *const Pick, position: usize) ?Found {
        if (self.saves <= 0) return null;
        return .{ .position = position, .len = self.len, .offset = position - self.candidate, .saves = self.saves };
    }

    /// Whether one compare shows that `candidate` saves no more than the best so far, which is
    /// `len` octets long. `saving` grows with the length, so when a match of `len` octets at the
    /// candidate's distance saves no more, a candidate no longer than `len` saves no more. One that
    /// differs in the 8 octets up to octet `len` is no longer.
    inline fn saves_no_more(self: *const Pick, comptime safety: bool, window: []const u8, position: usize, end: usize, candidate: usize, last: bool, len: usize) bool {
        @setRuntimeSafety(safety);
        // A best shorter than `read_len` octets takes no compare; one that runs to the end, none
        // past it.
        if (len < read_len or len >= end - position) return false;
        if (saving(len, position - candidate, last, self.cost) > self.saves) return false;
        const at = len + 1 - read_len;
        return read64(safety, window, candidate + at) != read64(safety, window, position + at);
    }
};

/// The fewest octets a candidate must agree on: the hash's 4, which a bucket's entries share.
pub const min_len = constants.encoder_level5.match_len_min;

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
pub fn match_len(comptime safety: bool, window: []const u8, candidate: usize, position: usize, end: usize) usize {
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

pub inline fn read32(comptime safety: bool, window: []const u8, position: usize) u32 {
    @setRuntimeSafety(safety);
    return std.mem.readInt(u32, window[position..][0..@sizeOf(u32)], .little);
}

pub inline fn read64(comptime safety: bool, window: []const u8, position: usize) u64 {
    @setRuntimeSafety(safety);
    return std.mem.readInt(u64, window[position..][0..@sizeOf(u64)], .little);
}

test {
    _ = @import("encoder_lazy_test.zig");
    _ = @import("encoder_side_test.zig");
}
