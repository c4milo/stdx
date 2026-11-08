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

/// The bits a position takes: a window of 2^22 and its slack are less than 2^23.
const position_bits = constants.encoder_level5.window_bits + 1;
/// The bits above the position, which hold the stream's tag.
const tag_bits = @bitSizeOf(u32) - position_bits;

comptime {
    assert(std.math.isPowerOfTwo(ways) and ways <= std.math.maxInt(u8) + 1);
    // `hits` takes the bucket's checks as one mask of 16 bits.
    assert(ways == @bitSizeOf(u16));
    assert((@as(usize, 1) << constants.encoder_level5.window_bits) + constants.encoder_level5.slack_len < @as(usize, 1) << position_bits);
}

/// A position's bucket, and its check: the 8 bits of its hash below the bucket's, which the bucket
/// keeps beside each entry, so one compare of 16 lanes finds the entries worth reading.
pub const Slot = struct { bucket: usize, check: u8 };

/// The hash's bits below the bucket's that make a check.
const check_shift = @bitSizeOf(u64) - constants.encoder_level5.bucket_log - @bitSizeOf(u8);

pub const Buckets = struct {
    entries: [bucket_count][ways]u32,
    checks: [bucket_count][ways]u8,
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
    /// clear when the tags ran out. Each bucket's ring starts again at its first way, so the stream
    /// fills the ways in the order a stream after `init` does: the parse tries them in that order,
    /// and the first of two equal matches wins (invariant 5). That clears 16 KiB, a constant.
    pub fn start(self: *Buckets) void {
        self.next = @splat(0);
        self.tag += 1;
        if (self.tag == @as(u64, 1) << tag_bits) return self.clear();
        self.base = self.tag << position_bits;
    }

    fn clear(self: *Buckets) void {
        for (&self.entries) |*bucket| bucket.* = @splat(0);
        for (&self.checks) |*bucket| bucket.* = @splat(0);
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

    /// The bucket and check of the 4 octets at `position`.
    pub inline fn slot_of(comptime safety: bool, window: []const u8, position: usize) Slot {
        @setRuntimeSafety(safety);
        const word = std.mem.readInt(u32, window[position..][0..@sizeOf(u32)], .little);
        const product = @as(u64, word) *% codec.constants.match_hash_multiplier;
        return .{ .bucket = @intCast(product >> (@bitSizeOf(u64) - constants.encoder_level5.bucket_log)), .check = @truncate(product >> check_shift) };
    }

    /// The bucket of the 4 octets at `position`.
    pub inline fn bucket_of(comptime safety: bool, window: []const u8, position: usize) usize {
        return slot_of(safety, window, position).bucket;
    }

    /// The entries of `slot`'s bucket whose check is `slot`'s, a bit each.
    pub inline fn hits(self: *const Buckets, slot: Slot) u16 {
        const Lanes = @Vector(ways, u8);
        const lanes: Lanes = self.checks[slot.bucket];
        return @bitCast(lanes == @as(Lanes, @splat(slot.check)));
    }

    /// Records `position` in its bucket, over the oldest entry.
    pub inline fn insert(self: *Buckets, comptime safety: bool, window: []const u8, position: usize) void {
        @setRuntimeSafety(safety);
        self.insert_at(safety, slot_of(safety, window, position), position);
    }

    /// Records `position` in `slot`, its bucket and check, over the oldest entry.
    pub inline fn insert_at(self: *Buckets, comptime safety: bool, slot: Slot, position: usize) void {
        @setRuntimeSafety(safety);
        const way = self.next[slot.bucket] % ways;
        self.entries[slot.bucket][way] = self.base +% @as(u32, @truncate(position));
        self.checks[slot.bucket][way] = slot.check;
        self.next[slot.bucket] = @truncate(way + 1);
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
    try @call(.never_inline, expect_bucket, .{});
}

/// The bucket test's window, the step between its repeats, and the positions it reads below and
/// slides by: positions `before_slide` and `after_slide` stored, the window slid by `slide_by`,
/// keeps only the second, at `kept_at`.
const test_window_len = 4096;
const repeat_step = 64;
const test_end = 4000;
const before_slide = 1024;
const after_slide = 2048;
const slide_by = 1536;
const kept_at = after_slide - slide_by;
/// The inserts into one bucket: its ways twice over, so the ring writes over the first half.
const rounds = 2;

/// The buckets live on the stack of a function the compiler may not inline: 1 MiB of thread-local
/// state would add to every test's, past aarch64's offsets.
fn expect_bucket() !void {
    var buckets_state: Buckets = undefined;
    var window_octets: [test_window_len]u8 = undefined;
    const buckets = &buckets_state;
    buckets.init();
    // The same 4 octets every `repeat_step`: one bucket fills, its ring keeping the last `ways`.
    for (&window_octets, 0..) |*octet, index| {
        octet.* = if (index % repeat_step < constants.encoder_level5.hash_len) 'a' else @truncate(index);
    }
    const bucket = Buckets.bucket_of(true, &window_octets, repeat_step);
    for (1..rounds * ways + 1) |index| buckets.insert(true, &window_octets, index * repeat_step);
    var named: usize = 0;
    for (buckets.entries[bucket]) |entry| {
        const position = buckets.candidate(entry, 1, test_end) orelse continue;
        try testing.expect(position > ways * repeat_step and position <= rounds * ways * repeat_step);
        named += 1;
    }
    try testing.expectEqual(ways, named);
    // A new stream's tag names none of them.
    buckets.start();
    for (buckets.entries[bucket]) |entry| try testing.expectEqual(null, buckets.candidate(entry, 1, test_end));
    // A slide moves this stream's entries down and empties those that slid out.
    buckets.insert(true, &window_octets, before_slide);
    buckets.insert(true, &window_octets, after_slide);
    buckets.slide(slide_by);
    var kept: usize = 0;
    for (buckets.entries[bucket]) |entry| {
        if (buckets.candidate(entry, 1, test_end)) |position| {
            try testing.expectEqual(kept_at, position);
            kept += 1;
        }
    }
    try testing.expectEqual(1, kept);
}
