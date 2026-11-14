//! Level 5's match finder (decision 62, as the owner's rulings of 2026-11-07 and 2026-11-12 amend
//! it): 2^14 buckets, each holding the last 16 positions whose first 5 octets hash to it, written
//! in a ring. A position finds its candidates among its bucket's 16, from the whole window. A side
//! table holds the newest position of each hash of 4 octets, for a match the buckets' 5 octets
//! miss (decision 66, the finder's forms).
//!
//! A bucket is one cache line of 64 octets: 16 entries of 4 octets. An entry holds the stream's
//! offset plus a window position, and above them the position's check: the 8 bits of its hash
//! below the bucket's. One compare of the bucket's 16 checks finds the entries worth reading.
//!
//! Each stream adds an offset to every position it records: 1 after `init`, then the sum of the
//! earlier streams' window ends. An entry of an earlier stream lies below the offset, and the
//! range check that refuses an entry out of reach refuses it too. In a stream's first 256 KiB,
//! where most entries are an earlier stream's, one compare of the 16 entries against the reach
//! finds the entries worth reading instead. The side table keeps its entries the same way.
//!
//! `start` clears no entry: it starts each bucket's ring again, 16 KiB. It clears the buckets and
//! the side table as `init` does only when the offsets run out.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");

const bucket_count = @as(usize, 1) << constants.encoder_level5.bucket_log;
pub const ways = constants.encoder_level5.bucket_ways;

/// The bits a position takes: a window of 2^22 and its slack are less than 2^23.
const position_bits = constants.encoder_level5.window_bits + 1;
/// Where an entry's check starts, above its position, and the bits below it.
const check_shift = @bitSizeOf(u32) - @bitSizeOf(u8);
const position_mask = (@as(u32, 1) << check_shift) - 1;
/// The most a stream's offset may be: its window's positions stay below the check.
const offset_max = position_mask + 1 - (@as(u32, 1) << position_bits);
/// The octets of a bucket, which is also its alignment: a bucket lies in one cache line of 64
/// octets or more.
const bucket_len = @sizeOf([ways]u32);

comptime {
    assert(std.math.isPowerOfTwo(ways) and ways <= std.math.maxInt(u8) + 1);
    // `hits` takes the bucket's checks as one mask of 16 bits.
    assert(ways == @bitSizeOf(u16));
    assert((@as(usize, 1) << constants.encoder_level5.window_bits) + constants.encoder_level5.slack_len < @as(usize, 1) << position_bits);
    // An offset and a position lie below an entry's check.
    assert(position_bits < check_shift);
    assert(std.math.isPowerOfTwo(bucket_len));
}

/// A position's bucket, and its check: the 8 bits of its hash below the bucket's, which the bucket
/// keeps above each entry's position, so one compare of 16 lanes finds the entries worth reading.
/// And its place in the side table.
pub const Slot = struct { bucket: usize, check: u8, side: usize };

const side_count = @as(usize, 1) << constants.encoder_level5.side_log;
/// The bits of a word of 8 octets the buckets' hash leaves out: its last 3 octets.
const unhashed_bits = (@sizeOf(u64) - constants.encoder_level5.hash_len) * @bitSizeOf(u8);

comptime {
    // The side table's hash takes the 4 octets a match needs at least, a word's low half.
    assert(constants.encoder_level5.match_len_min == @sizeOf(u32));
    assert(constants.encoder_level5.hash_len > constants.encoder_level5.match_len_min and constants.encoder_level5.hash_len < @sizeOf(u64));
}

/// The hash's bits below the bucket's that make a check.
const hash_check_shift = @bitSizeOf(u64) - constants.encoder_level5.bucket_log - @bitSizeOf(u8);

pub const Buckets = struct {
    /// Each bucket's 16 entries, one cache line: the stream's offset plus a position, below its
    /// check.
    entries: [bucket_count][ways]u32 align(bucket_len),
    /// Each bucket's ring: the way its next insert writes, modulo 16.
    next: [bucket_count]u8,
    /// The newest position of each hash of 4 octets, the stream's offset plus the position.
    side: [side_count]u32,
    /// What the stream adds to each position it records: the sum of the earlier streams' window
    /// ends since the last clear, 1 at least. An earlier stream's entry lies below it.
    offset: u32,

    /// Empties the buckets, so no position of uninitialized memory names a candidate (invariant
    /// 4), and starts the first stream.
    pub fn init(self: *Buckets) void {
        self.clear();
    }

    /// Begins the next stream, after one whose window ended at `window_end`: an offset past
    /// every entry, or a clear when the offsets ran out. Each bucket's ring starts again at its
    /// first way, so the stream fills the ways in the order a stream after `init` does: the
    /// parse tries them in that order, and the first of two equal matches wins (invariant 5).
    /// That clears 16 KiB, a constant.
    pub fn start(self: *Buckets, window_end: usize) void {
        assert(window_end < @as(usize, 1) << position_bits);
        self.next = @splat(0);
        self.offset += @intCast(window_end);
        if (self.offset > offset_max) self.clear();
    }

    fn clear(self: *Buckets) void {
        for (&self.entries) |*bucket| bucket.* = @splat(0);
        self.next = @splat(0);
        self.side = @splat(0);
        self.offset = 1;
    }

    /// Moves every position of this stream `shift` octets down, after the window slid by that
    /// much. A position that slid out becomes 0, and so does every earlier stream's.
    pub fn slide(self: *Buckets, shift: u32) void {
        const kept_min = self.offset + shift;
        for (&self.entries) |*bucket| {
            for (bucket) |*entry| entry.* = if (entry.* & position_mask > kept_min) entry.* - shift else 0;
        }
        for (&self.side) |*entry| entry.* = if (entry.* > kept_min) entry.* - shift else 0;
    }

    /// The slot of `position`, whose 8 octets the window holds: the bucket and check of its first
    /// 5 octets, and the side table's place of its first 4.
    pub inline fn slot_of(comptime safety: bool, window: []const u8, position: usize) Slot {
        @setRuntimeSafety(safety);
        return slot_of_word(std.mem.readInt(u64, window[position..][0..@sizeOf(u64)], .little));
    }

    /// The slot of a position whose octets are `word`, least significant first. The shift drops
    /// the octets past the fifth, and the side table's hash takes the first 4.
    pub inline fn slot_of_word(word: u64) Slot {
        const product = (word << unhashed_bits) *% codec.constants.match_hash_multiplier;
        const short = @as(u64, @as(u32, @truncate(word))) *% codec.constants.match_hash_multiplier;
        return .{
            .bucket = @intCast(product >> (@bitSizeOf(u64) - constants.encoder_level5.bucket_log)),
            .check = @truncate(product >> hash_check_shift),
            .side = @intCast(short >> (@bitSizeOf(u64) - constants.encoder_level5.side_log)),
        };
    }

    /// The bucket of the 5 octets at `position`.
    pub inline fn bucket_of(comptime safety: bool, window: []const u8, position: usize) usize {
        return slot_of(safety, window, position).bucket;
    }

    /// Asks the cache for `slot`'s bucket and its ring's next way before a search reads them.
    pub inline fn prefetch(self: *const Buckets, slot: Slot) void {
        @prefetch(&self.entries[slot.bucket], .{});
        @prefetch(&self.next[slot.bucket], .{});
    }

    /// The entry of `position` in a bucket: the position below `check`.
    pub inline fn entry_of(check: u8, position: usize) u32 {
        return @as(u32, check) << check_shift | @as(u32, @truncate(position));
    }

    /// The entry of `position` in this stream, below `check`.
    pub inline fn entry_at(self: *const Buckets, check: u8, position: usize) u32 {
        return entry_of(check, self.offset + @as(u32, @truncate(position)));
    }

    /// The ring's next way of `slot`'s bucket.
    pub inline fn next_of(self: *const Buckets, slot: Slot) usize {
        return self.next[slot.bucket] % ways;
    }

    /// The entries of `slot`'s bucket whose check is `slot`'s, a bit each.
    pub inline fn hits(self: *const Buckets, slot: Slot) u16 {
        return @bitCast(self.check_lanes(slot));
    }

    /// The entries of `slot`'s bucket whose check is `slot`'s, 4 bits each: way w's are bits 4w to
    /// 4w + 3. One narrowing shift makes it from the compare of 16 lanes.
    pub inline fn hit_nibbles(self: *const Buckets, slot: Slot) u64 {
        return nibbles(self.check_lanes(slot));
    }

    /// The ways of `slot`'s bucket in reach, a bit each as `hits` sets them: an entry less `base`,
    /// the entry of the lowest position with the slot's check, is in reach below `reach`. These
    /// are hits too. An earlier stream's entry wraps past the reach. So does an entry with
    /// another check: `base` plus `reach` is at most 2^24, as no offset plus a position passes
    /// the check.
    pub inline fn reach_bits(self: *const Buckets, slot: Slot, base: u32, reach: u32) u16 {
        return @bitCast(self.reach_lanes(slot, base, reach));
    }

    /// The ways of `slot`'s bucket in reach, 4 bits each as `hit_nibbles` sets them.
    pub inline fn reach_nibbles(self: *const Buckets, slot: Slot, base: u32, reach: u32) u64 {
        return nibbles(self.reach_lanes(slot, base, reach));
    }

    inline fn reach_lanes(self: *const Buckets, slot: Slot, base: u32, reach: u32) @Vector(ways, bool) {
        const Entries = @Vector(ways, u32);
        const entries: Entries = self.entries[slot.bucket];
        return entries -% @as(Entries, @splat(base)) < @as(Entries, @splat(reach));
    }

    inline fn check_lanes(self: *const Buckets, slot: Slot) @Vector(ways, bool) {
        const Entries = @Vector(ways, u32);
        const Checks = @Vector(ways, u8);
        const entries: Entries = self.entries[slot.bucket];
        const entry_checks: Checks = @truncate(entries >> @as(@Vector(ways, std.math.Log2Int(u32)), @splat(check_shift)));
        return entry_checks == @as(Checks, @splat(slot.check));
    }

    /// 4 bits for each lane: each pair of 8-bit lanes, shifted right by 4 and narrowed to 8 bits,
    /// keeps the low lane's high half and the high lane's low half.
    inline fn nibbles(lanes: @Vector(ways, bool)) u64 {
        const Lanes = @Vector(ways, u8);
        const pair_count = ways / @sizeOf(u16);
        const octets: Lanes = @select(u8, lanes, @as(Lanes, @splat(std.math.maxInt(u8))), @as(Lanes, @splat(0)));
        const pairs: @Vector(pair_count, u16) = @bitCast(octets);
        return @bitCast(@as(@Vector(pair_count, u8), @truncate(pairs >> @splat(@bitSizeOf(u4)))));
    }

    /// Records `position` in its bucket, over the oldest entry.
    pub inline fn insert(self: *Buckets, comptime safety: bool, window: []const u8, position: usize) void {
        @setRuntimeSafety(safety);
        self.insert_at(safety, slot_of(safety, window, position), position);
    }

    /// Records `position` in `slot`: in its bucket below its check, over the oldest entry, and in
    /// the side table, over the position its 4 octets named before.
    pub inline fn insert_at(self: *Buckets, comptime safety: bool, slot: Slot, position: usize) void {
        @setRuntimeSafety(safety);
        const way = self.next[slot.bucket] % ways;
        self.entries[slot.bucket][way] = self.entry_at(slot.check, position);
        self.next[slot.bucket] = @intCast(way + 1);
        self.side[slot.side] = self.offset + @as(u32, @truncate(position));
    }

    /// The position `entry` of `slot`'s bucket names, when it holds `slot`'s check and lies in
    /// this stream from `low` up and before `position`.
    pub inline fn candidate(self: *const Buckets, slot: Slot, entry: u32, low: usize, position: usize) ?usize {
        if (entry < self.entry_at(slot.check, low) or entry >= self.entry_at(slot.check, position)) return null;
        return (entry & position_mask) - self.offset;
    }

    /// The position the side table names for `slot`, when it lies in this stream from `low` up and
    /// before `position`: the newest whose 4 octets hash as `slot`'s do.
    pub inline fn side_candidate(self: *const Buckets, slot: Slot, low: usize, position: usize) ?usize {
        const entry = self.side[slot.side];
        if (entry < self.offset + @as(u32, @truncate(low)) or entry >= self.offset + @as(u32, @truncate(position))) return null;
        return entry - self.offset;
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
/// A position between two repeats, whose octets no other position stored has.
const lone_position = 100;
/// The inserts into one bucket: its ways twice over, so the ring writes over them once, and one
/// more, so the ring's next way is not its first when the stream ends.
const rounds = 2;
const fill_count = rounds * ways + 1;
/// The inserts of the second stream before its slide: its first ways.
const second_stream_ways = 2;

/// The buckets live on the stack of a function the compiler may not inline: 1 MiB of thread-local
/// state would add to every test's, past aarch64's offsets.
fn expect_bucket() !void {
    var buckets_state: Buckets = undefined;
    var window_octets: [test_window_len]u8 = undefined;
    const buckets = &buckets_state;
    // The same 5 octets every `repeat_step`: one bucket fills, its ring keeping the last `ways`.
    for (&window_octets, 0..) |*octet, index| {
        octet.* = if (index % repeat_step < constants.encoder_level5.hash_len) 'a' else @truncate(index);
    }
    const slot = Buckets.slot_of(true, &window_octets, repeat_step);
    // An empty way's check is 0: the counts of hits below take another check.
    try testing.expect(slot.check != 0);
    // A side table and a bucket that name a position of the first stream before `init`, as memory
    // a caller did not clear may: `init` must leave none a search takes.
    buckets.side = @splat(1 + repeat_step);
    buckets.entries[slot.bucket] = @splat(Buckets.entry_of(slot.check, 1 + repeat_step));
    buckets.init();
    try testing.expectEqual(0, buckets.hits(slot));
    for (0..side_count) |place| try testing.expectEqual(null, buckets.side_candidate(.{ .bucket = 0, .check = 0, .side = place }, 1, test_end));
    for (1..fill_count + 1) |index| buckets.insert(true, &window_octets, index * repeat_step);
    try expect_named(buckets, slot, (fill_count - ways) * repeat_step, ways);
    try testing.expectEqual(std.math.maxInt(u16), buckets.hits(slot));
    try testing.expectEqual(fill_count % ways, buckets.next_of(slot));
    // The side table names the newest of them, to a search after it but not to its own.
    try testing.expectEqual(fill_count * repeat_step, buckets.side_candidate(slot, 1, test_end));
    try testing.expectEqual(null, buckets.side_candidate(slot, 1, fill_count * repeat_step));
    // A new stream finds none of them, and its ring starts again at the first way.
    buckets.start(test_window_len);
    try expect_named(buckets, slot, 0, 0);
    try testing.expectEqual(0, buckets.next_of(slot));
    try testing.expectEqual(null, buckets.side_candidate(slot, 1, test_end));
    buckets.insert(true, &window_octets, before_slide);
    try testing.expectEqual(1, buckets.next_of(slot));
    try testing.expectEqual(before_slide, buckets.candidate(slot, buckets.entries[slot.bucket][0], 1, test_end));
    buckets.insert(true, &window_octets, after_slide);
    try expect_named(buckets, slot, before_slide - 1, second_stream_ways);
    try expect_slide(buckets, &window_octets, slot);
}

/// `count` entries of `slot`'s bucket name a candidate, each above `above` and at most
/// `fill_count` repeats in.
fn expect_named(buckets: *const Buckets, slot: Slot, above: usize, count: usize) !void {
    var named: usize = 0;
    for (buckets.entries[slot.bucket]) |entry| {
        const position = buckets.candidate(slot, entry, 1, test_end) orelse continue;
        try testing.expect(position > above and position <= fill_count * repeat_step);
        named += 1;
    }
    try testing.expectEqual(count, named);
}

/// A slide moves this stream's entries down, and empties those that slid out and an earlier
/// stream's.
fn expect_slide(buckets: *Buckets, window_octets: []const u8, slot: Slot) !void {
    // Other octets below the slide, which the side table names until then.
    const lone = Buckets.slot_of(true, window_octets, lone_position);
    try testing.expect(lone.side != slot.side and lone.bucket != slot.bucket);
    buckets.insert(true, window_octets, lone_position);
    try testing.expectEqual(lone_position, buckets.side_candidate(lone, 1, test_end));
    // The ways past the stream's own hold the earlier stream's entries.
    const earlier_ways = buckets.entries[slot.bucket][second_stream_ways..];
    for (earlier_ways) |entry| try testing.expect(entry != 0);
    try testing.expectEqual(buckets.offset + before_slide, buckets.entries[slot.bucket][0] & position_mask);
    buckets.slide(slide_by);
    try testing.expectEqual(kept_at, buckets.side_candidate(slot, 1, test_end));
    try testing.expectEqual(0, buckets.side[lone.side]);
    try testing.expectEqual(kept_at, buckets.candidate(slot, buckets.entries[slot.bucket][1], 1, test_end));
    // The position that slid out left no entry, and neither did the earlier stream.
    try testing.expectEqual(0, buckets.entries[slot.bucket][0]);
    for (earlier_ways) |entry| try testing.expectEqual(0, entry);
}

test "a stream's offset keeps the window's last position below its entry's check" {
    try @call(.never_inline, expect_offsets, .{});
}

/// The last position a search may start at, as a window and its slack are shorter than 2^23, and
/// the check that a carry out of the position before it would change.
const last_position = (@as(usize, 1) << position_bits) - 1;
const top_check = std.math.maxInt(u8);
/// The way of the widest reach's own entry.
const own_way = 1;

/// The offset may reach `offset_max` and no further: the next `start` clears the buckets.
fn expect_offsets() !void {
    var buckets_state: Buckets = undefined;
    const buckets = &buckets_state;
    buckets.init();
    const slot: Slot = .{ .bucket = 0, .check = top_check, .side = 0 };
    buckets.offset = offset_max - 1;
    buckets.start(1);
    try testing.expectEqual(offset_max, buckets.offset);
    buckets.insert_at(true, slot, last_position - 1);
    try testing.expectEqual(1, buckets.hits(slot));
    try testing.expectEqual(last_position - 1, buckets.candidate(slot, buckets.entries[0][0], 1, last_position));
    try testing.expectEqual(last_position - 1, buckets.side_candidate(slot, 1, last_position));
    // The widest reach at the largest offset: an entry whose check is one above the slot's, at
    // position 0 of an earlier stream, lies just past it. The slot's own entry lies in it.
    const below: Slot = .{ .bucket = 0, .check = top_check - 1, .side = 0 };
    buckets.entries[0][0] = Buckets.entry_of(top_check, 0);
    buckets.entries[0][own_way] = buckets.entry_at(below.check, 1);
    const reach_widest: u32 = last_position - 1;
    try testing.expectEqual(@as(u16, 1) << own_way, buckets.reach_bits(below, buckets.entry_at(below.check, 1), reach_widest));
    buckets.start(1);
    try testing.expectEqual(1, buckets.offset);
    try testing.expectEqual(0, buckets.hits(slot));
    try testing.expectEqual(null, buckets.side_candidate(slot, 1, last_position));
}

test "a slot takes 5 octets for its bucket and check, and the first 4 for the side table" {
    var generator = codec.testing.split.Generator.init(slot_seed);
    for (0..slot_rounds) |_| {
        const word = generator.next();
        const slot = Buckets.slot_of_word(word);
        // The sixth octet changes nothing.
        const sixth = Buckets.slot_of_word(word ^ (@as(u64, slot_flip) << (constants.encoder_level5.hash_len * @bitSizeOf(u8))));
        try testing.expectEqual(slot, sixth);
        // The fifth changes the bucket or the check, and leaves the side table's place.
        const fifth = Buckets.slot_of_word(word ^ (@as(u64, slot_flip) << (constants.encoder_level5.match_len_min * @bitSizeOf(u8))));
        try testing.expect(fifth.bucket != slot.bucket or fifth.check != slot.check);
        try testing.expectEqual(slot.side, fifth.side);
        // The fourth changes the side table's place.
        const fourth = Buckets.slot_of_word(word ^ (@as(u64, slot_flip) << ((constants.encoder_level5.match_len_min - 1) * @bitSizeOf(u8))));
        try testing.expect(fourth.side != slot.side);
    }
}

/// Seeded words, and the bit the test flips in one octet of each.
const slot_seed = 77;
const slot_rounds = 64;
const slot_flip = 0x10;

test "a bucket's masks set a way with the slot's check, and among them one in reach" {
    try @call(.never_inline, expect_masks, .{});
}

/// Entries in one bucket: this stream's in reach, below the reach or past the position, and a
/// first stream's, the first ways at each edge and the rest seeded, each with the slot's check, a
/// check one bit from it, or a seeded one, in a seeded ring. The check masks must set the ways
/// with the slot's check, and the reach masks those where `candidate` names a position. The
/// nibble masks spread the bit masks 4 bits a way.
fn expect_masks() !void {
    var buckets_state: Buckets = undefined;
    const buckets = &buckets_state;
    buckets.init();
    // A first stream: an entry just below the offset is its.
    buckets.start(mask_position);
    var generator = codec.testing.split.Generator.init(mask_seed);
    const slot: Slot = .{ .bucket = 0, .check = mask_check, .side = 0 };
    // The position, the last in reach, the lowest, the one below it, the first stream's last, and
    // the stream's position 0.
    const offset = buckets.offset;
    const edges = [_]u32{ offset + mask_position, offset + mask_position - 1, offset + mask_low, offset + mask_low - 1, offset - 1, offset };
    const base = buckets.entry_at(mask_check, mask_low);
    for (0..mask_rounds) |_| {
        var hits: u16 = 0;
        var in_reach: u16 = 0;
        for (0..ways) |way| {
            const check = check_seeded(&generator);
            const seeded: u32 = @intCast(generator.below(offset + mask_position));
            const entry = Buckets.entry_of(check, if (way < edges.len) edges[way] else seeded);
            buckets.entries[0][way] = entry;
            if (check == mask_check) hits |= @as(u16, 1) << @intCast(way);
            if (buckets.candidate(slot, entry, mask_low, mask_position) != null) in_reach |= @as(u16, 1) << @intCast(way);
        }
        buckets.next[0] = @truncate(generator.next());
        try testing.expectEqual(hits, buckets.hits(slot));
        try testing.expectEqual(spread(hits), buckets.hit_nibbles(slot));
        try testing.expectEqual(in_reach, buckets.reach_bits(slot, base, mask_position - mask_low));
        try testing.expectEqual(spread(in_reach), buckets.reach_nibbles(slot, base, mask_position - mask_low));
        try testing.expectEqual(buckets.next[0] % ways, buckets.next_of(slot));
    }
}

/// What a way's check is in the masks' test.
const CheckKind = enum { equal, low_bit, top_bit, seeded };

/// A way's check, of a seeded kind.
fn check_seeded(generator: *codec.testing.split.Generator) u8 {
    const kind: CheckKind = @enumFromInt(generator.below(@typeInfo(CheckKind).@"enum".fields.len));
    return switch (kind) {
        .equal => mask_check,
        .low_bit => mask_check ^ 1,
        .top_bit => mask_check ^ (1 << (@bitSizeOf(u8) - 1)),
        .seeded => @truncate(generator.next()),
    };
}

/// Each bit of `bits` as the 4 bits of way's nibble.
fn spread(bits: u16) u64 {
    var nibbles: u64 = 0;
    for (0..ways) |way| {
        if (bits >> @intCast(way) & 1 != 0) nibbles |= @as(u64, std.math.maxInt(u4)) << @intCast(way * @bitSizeOf(u4));
    }
    return nibbles;
}

const mask_seed = 69;
const mask_rounds = 200;
const mask_low = 1000;
const mask_position = 3000;
const mask_check: u8 = 0x5a;

test "an entry names a candidate with the slot's check, from the lowest position to the one before" {
    try @call(.never_inline, expect_candidates, .{});
}

/// After a stream whose window ended at `mask_position`, an entry of this stream in reach names
/// its position, and an earlier stream's entry names none.
fn expect_candidates() !void {
    var buckets_state: Buckets = undefined;
    const buckets = &buckets_state;
    buckets.init();
    buckets.start(mask_position);
    const slot: Slot = .{ .bucket = 0, .check = mask_check, .side = 0 };
    const cases = [_]struct { check: u8, position: usize, named: ?usize }{
        // The position's own entry, the last in reach, the lowest, and the one below it.
        .{ .check = mask_check, .position = mask_position, .named = null },
        .{ .check = mask_check, .position = mask_position - 1, .named = mask_position - 1 },
        .{ .check = mask_check, .position = mask_low, .named = mask_low },
        .{ .check = mask_check, .position = mask_low - 1, .named = null },
        // A check below the slot's and one above it, each with a position in reach.
        .{ .check = mask_check - 1, .position = mask_low, .named = null },
        .{ .check = mask_check + 1, .position = mask_low, .named = null },
    };
    for (cases) |case| {
        try testing.expectEqual(case.named, buckets.candidate(slot, buckets.entry_at(case.check, case.position), mask_low, mask_position));
    }
    // The earlier stream's entries of the positions in reach, and an empty entry, name none.
    for ([_]u32{ mask_low, mask_position - 1, 0 }) |position| {
        try testing.expectEqual(null, buckets.candidate(slot, Buckets.entry_of(mask_check, 1 + position), mask_low, mask_position));
    }
    try testing.expectEqual(null, buckets.candidate(.{ .bucket = 0, .check = 0, .side = 0 }, 0, 1, mask_position));
}
