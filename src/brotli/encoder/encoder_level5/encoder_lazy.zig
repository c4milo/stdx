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

const Buckets = buckets_module.Buckets;

/// A match and what it saves, in eighths of a bit, over its literals.
const Found = struct { position: usize, len: usize, offset: usize, saves: i64 };

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
        const taken = step_back(safety, window, found, anchor);
        commands.add(safety, window, anchor, taken.position, taken.len, taken.offset);
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
fn best(comptime safety: bool, buckets: *Buckets, window: []const u8, position: usize, end: usize, reach_len: usize, commands: anytype) ?Found {
    @setRuntimeSafety(safety);
    // Position 0 names no candidate: no octet lies before it.
    if (position == 0) {
        buckets.insert(safety, window, position);
        return null;
    }
    const low = @max(position -| reach_len, 1);
    var found: ?Found = null;
    // The last distances first: a short code, with no extra bits (RFC 7932 §4).
    for (commands.last_distances) |distance| {
        if (distance > position - low) continue;
        consider(safety, window, position, position - distance, end, commands, true, &found);
    }
    // The entries whose check matches the position's, the lowest way first.
    const slot = Buckets.slot_of(safety, window, position);
    var hits = buckets.hits(slot);
    for (0..buckets_module.ways) |_| {
        if (hits == 0) break;
        const way = @ctz(hits);
        hits &= hits - 1;
        const candidate = buckets.candidate(buckets.entries[slot.bucket][way], low, position) orelse continue;
        consider(safety, window, position, candidate, end, commands, false, &found);
    }
    buckets.insert_at(safety, slot, position);
    return found;
}

/// `found` replaced by the match of `candidate` at `position` where that saves more.
inline fn consider(comptime safety: bool, window: []const u8, position: usize, candidate: usize, end: usize, commands: anytype, last: bool, found: *?Found) void {
    @setRuntimeSafety(safety);
    // A candidate shorter than the best so far differs at the best's last octet; one whose first 4
    // octets differ, a bucket's collision, is shorter than any match.
    if (found.*) |held| {
        if (window[candidate + held.len - 1] != window[position + held.len - 1]) return;
    }
    if (read32(safety, window, candidate) != read32(safety, window, position)) return;
    const len = match_len(safety, window, candidate, position, end);
    if (len < constants.copy_length_codes[0].base) return;
    const offset = position - candidate;
    const saves = saving(len, offset, last, commands.literal_cost);
    if (saves <= 0) return;
    if (found.*) |held| {
        if (saves <= held.saves) return;
    }
    found.* = .{ .position = position, .len = len, .offset = offset, .saves = saves };
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
