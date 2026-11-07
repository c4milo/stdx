//! Level 5's match finder (decision 62, as the owner's ruling of 2026-11-07 amends it): 2^14
//! buckets, each holding the last 16 positions whose first 4 octets hash to it, written in a ring.
//! A position finds its candidates among its bucket's 16, from the whole window.
//!
//! An entry holds a window position, and above it the tag of the stream that stored it, as codec's
//! match_finder.zig keeps its tables: the stream's base, its tag shifted above every position, plus
//! the position. Tags only grow between clears, so an entry of an earlier stream lies below the
//! base, and one range check finds an entry of this stream the window still reaches. An entry of
//! position 0 names no candidate. `init` clears the buckets once; `start` begins the next stream
//! with the next tag, and clears them again only when the tags run out.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");

const bucket_count = @as(usize, 1) << constants.encoder_level5.bucket_log;
pub const ways = constants.encoder_level5.bucket_ways;

/// The bits a position takes: a window of 2^22 and a meta-block are less than 2^23.
const position_bits = constants.encoder_level5.window_bits + 1;
/// The bits above the position, which hold the stream's tag.
const tag_bits = @bitSizeOf(u32) - position_bits;

comptime {
    assert(std.math.isPowerOfTwo(ways) and ways <= std.math.maxInt(u8) + 1);
    assert((@as(usize, 1) << constants.encoder_level5.window_bits) + constants.encoder_meta_block_len_max < @as(usize, 1) << position_bits);
}

pub const Buckets = struct {
    entries: [bucket_count][ways]u32,
    /// Each bucket's next slot in its ring.
    next: [bucket_count]u8,
    /// The stream's tag, from 1 up, and its base: the tag above every position.
    tag: u32,
    base: u32,

    /// Empties the buckets, so no position of an earlier stream or of uninitialized memory names a
    /// candidate (invariant 4), and starts the first stream's tag.
    pub fn init(self: *Buckets) void {
        self.clear();
    }

    /// Begins the next stream of buckets `init` started: the next tag, which no entry holds, or a
    /// clear when the tags ran out.
    pub fn start(self: *Buckets) void {
        self.tag += 1;
        if (self.tag == @as(u64, 1) << tag_bits) return self.clear();
        self.base = self.tag << position_bits;
    }

    fn clear(self: *Buckets) void {
        for (&self.entries) |*bucket| bucket.* = @splat(0);
        self.next = @splat(0);
        self.tag = 1;
        self.base = @as(u32, 1) << position_bits;
    }

    /// Moves every position of this stream `shift` octets down, after the window slid by that
    /// much. A position that slid out, and every earlier stream's, becomes 0.
    pub fn slide(self: *Buckets, shift: u32) void {
        const kept_min = self.base + shift;
        for (&self.entries) |*bucket| {
            for (bucket) |*entry| entry.* = if (entry.* > kept_min) entry.* - shift else 0;
        }
    }

    /// The bucket of the 4 octets at `position`.
    pub inline fn bucket_of(comptime safety: bool, window: []const u8, position: usize) usize {
        @setRuntimeSafety(safety);
        const word = std.mem.readInt(u32, window[position..][0..@sizeOf(u32)], .little);
        return @intCast((@as(u64, word) *% codec.constants.match_hash_multiplier) >> (@bitSizeOf(u64) - constants.encoder_level5.bucket_log));
    }

    /// Records `position` in its bucket, over the oldest entry.
    pub inline fn insert(self: *Buckets, comptime safety: bool, window: []const u8, position: usize) void {
        @setRuntimeSafety(safety);
        const bucket = bucket_of(safety, window, position);
        const slot = self.next[bucket] % ways;
        self.entries[bucket][slot] = self.base +% @as(u32, @truncate(position));
        self.next[bucket] = @truncate(slot + 1);
    }

    /// The position `entry` names when it lies in this stream from `low` up and before `position`.
    pub inline fn candidate(self: *const Buckets, entry: u32, low: usize, position: usize) ?usize {
        const lowest = self.base +% @as(u32, @truncate(low));
        const own = self.base +% @as(u32, @truncate(position));
        if (entry < lowest or entry >= own) return null;
        return entry - self.base;
    }
};

const testing = std.testing;

test "a bucket keeps its last positions, a stream's own, and slides them" {
    const State = struct {
        threadlocal var buckets: Buckets = undefined;
        threadlocal var window: [4096]u8 = undefined;
    };
    const buckets = &State.buckets;
    buckets.init();
    // The same 4 octets every 64: one bucket fills, its ring keeping the last `ways`.
    for (&State.window, 0..) |*octet, index| octet.* = if (index % 64 < 4) 'a' else @truncate(index);
    const bucket = Buckets.bucket_of(true, &State.window, 64);
    for (1..2 * ways + 1) |index| buckets.insert(true, &State.window, index * 64);
    var named: usize = 0;
    for (buckets.entries[bucket]) |entry| {
        const position = buckets.candidate(entry, 1, 4000) orelse continue;
        try testing.expect(position > ways * 64 and position <= 2 * ways * 64);
        named += 1;
    }
    try testing.expectEqual(ways, named);
    // A new stream's tag names none of them.
    buckets.start();
    for (buckets.entries[bucket]) |entry| try testing.expectEqual(null, buckets.candidate(entry, 1, 4000));
    // A slide moves this stream's entries down and empties those that slid out.
    buckets.insert(true, &State.window, 1024);
    buckets.insert(true, &State.window, 2048);
    buckets.slide(1536);
    var kept: usize = 0;
    for (buckets.entries[bucket]) |entry| {
        if (buckets.candidate(entry, 1, 4000)) |position| {
            try testing.expectEqual(512, position);
            kept += 1;
        }
    }
    try testing.expectEqual(1, kept);
}
