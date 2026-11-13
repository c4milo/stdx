//! Level 5's match finder (decision 62, as the owner's rulings of 2026-11-07 and 2026-11-12 amend
//! it): 2^14 buckets, each holding the last 16 positions whose first 5 octets hash to it, written
//! in a ring. A position finds its candidates among its bucket's 16, from the whole window. A side
//! table holds the newest position of each hash of 4 octets, for a match the buckets' 5 octets
//! miss (decision 66, the finder's forms).
//!
//! A bucket is one cache line of 64 octets: 16 entries of 4 octets. An entry holds a window position, and
//! above it the position's check, the 8 bits of its hash below the bucket's. One compare of the
//! bucket's 16 checks finds the entries worth reading. An entry of 0 names no candidate: a search
//! reaches no further back than position 1.
//!
//! A bucket's mark, in a table of its own, holds the tag of the stream that wrote the bucket
//! last, below the ring's next way. `start` begins the next stream with the next tag and clears
//! nothing: a bucket whose mark holds another tag has no entry for a search, and the stream's
//! first insert there empties it. `init` clears the marks alone, so no entry of uninitialized
//! memory is read. The next way takes a mark's top bits, so one wrapping add steps the ring.
//!
//! The side table keeps its entries as codec's match_finder.zig keeps its tables: the stream's
//! base, its tag shifted above every position, plus the position. Tags only grow between clears,
//! so an entry of an earlier stream lies below the base, and one range check finds an entry of
//! this stream the window still reaches.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");

const bucket_count = @as(usize, 1) << constants.encoder_level5.bucket_log;
pub const ways = constants.encoder_level5.bucket_ways;

/// The bits a position takes: a window of 2^22 and its slack are less than 2^23.
const position_bits = constants.encoder_level5.window_bits + 1;
/// The bits above the position, which hold the stream's tag in the side table.
const tag_bits = @bitSizeOf(u32) - position_bits;
/// Where an entry's check starts, above its position, and the bits below it.
const check_shift = @bitSizeOf(u32) - @bitSizeOf(u8);
const position_mask = (@as(u32, 1) << check_shift) - 1;
/// A mark's top bit says the ring has filled. Below it the ring's next way, then the stream's
/// tag: a wrapping add of `way_step` steps the ring, and its carry out of the last way sets the
/// top bit.
const full_bit: u16 = 1 << (@bitSizeOf(u16) - 1);
const way_shift = @bitSizeOf(u16) - 1 - std.math.log2(ways);
const way_step = @as(u16, 1) << way_shift;
const way_mask = ways - 1;
const mark_tag_mask = way_step - 1;
/// The octets of a bucket, which is also its alignment: a bucket lies in one cache line of 64
/// octets or more.
const bucket_len = @sizeOf([ways]u32);

comptime {
    assert(std.math.isPowerOfTwo(ways) and ways <= std.math.maxInt(u8) + 1);
    // `hits` takes the bucket's checks as one mask of 16 bits.
    assert(ways == @bitSizeOf(u16));
    assert((@as(usize, 1) << constants.encoder_level5.window_bits) + constants.encoder_level5.slack_len < @as(usize, 1) << position_bits);
    // A position lies below an entry's check, and a tag above a way fits a mark.
    assert(position_bits <= check_shift);
    assert(tag_bits <= way_shift);
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
    /// Each bucket's 16 entries, one cache line: a position below its check.
    entries: [bucket_count][ways]u32 align(bucket_len),
    /// Each bucket's mark: the tag of the stream that wrote it last, below its ring's next way.
    marks: [bucket_count]u16,
    /// The newest position of each hash of 4 octets, the stream's base plus the position.
    side: [side_count]u32,
    /// The stream's tag, from 1 up, and its base: the tag above every position.
    tag: u32,
    base: u32,

    /// Empties the buckets, so no position of an earlier stream or of uninitialized memory names a
    /// candidate (invariant 4), and starts the first stream's tag. It writes no entry: a mark of
    /// 0 holds no stream's tag, so a search reads no entry before an insert empties its bucket.
    pub fn init(self: *Buckets) void {
        self.clear();
    }

    /// Begins the next stream of buckets `init` started: the next tag, which no mark and no entry
    /// of the side table holds, or a clear when the tags ran out. It clears nothing else, a
    /// constant cost: each bucket's first insert of the stream empties it and starts its ring at
    /// its first way, so the stream fills the ways in the order a stream after `init` does. The
    /// parse tries them in that order, and the first of two equal matches wins (invariant 5).
    pub fn start(self: *Buckets) void {
        self.tag += 1;
        if (self.tag == @as(u32, 1) << tag_bits) return self.clear();
        self.base = self.tag << position_bits;
    }

    fn clear(self: *Buckets) void {
        for (&self.entries) |*bucket| bucket.* = @splat(0);
        self.marks = @splat(0);
        self.side = @splat(0);
        self.tag = 1;
        self.base = @as(u32, 1) << position_bits;
    }

    /// Moves every position of this stream `shift` octets down, after the window slid by that
    /// much. A position that slid out becomes 0, and so does every earlier stream's in the side
    /// table; a bucket an earlier stream wrote last holds no entry, and stays as it is.
    pub fn slide(self: *Buckets, shift: u32) void {
        const kept_min = self.base + shift;
        for (&self.entries, &self.marks) |*bucket, mark| {
            if (!self.wrote(mark)) continue;
            for (bucket) |*entry| entry.* = if (entry.* & position_mask > shift) entry.* - shift else 0;
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

    /// Asks the cache for `slot`'s bucket and its mark before a search reads them.
    pub inline fn prefetch(self: *const Buckets, slot: Slot) void {
        @prefetch(&self.entries[slot.bucket], .{});
        @prefetch(&self.marks[slot.bucket], .{});
    }

    /// The entry of `position` in a bucket: the position below `check`.
    pub inline fn entry_of(check: u8, position: usize) u32 {
        return @as(u32, check) << check_shift | @as(u32, @truncate(position));
    }

    /// The mark of a bucket this stream wrote last, whose ring's next way is `next`.
    pub inline fn mark_of(self: *const Buckets, next: usize) u16 {
        return @as(u16, @truncate(self.tag)) | @as(u16, @truncate(next)) << way_shift;
    }

    /// The ways of the bucket `mark` belongs to that this stream wrote, a bit each: every way
    /// once the ring filled, else those below its next way, and none for another stream's bucket.
    inline fn written_ways(self: *const Buckets, mark: u16) u16 {
        return @truncate(self.written_bits(mark, 1));
    }

    /// `written_ways` with `width` bits a way, way w's from bit `width * w` up.
    inline fn written_bits(self: *const Buckets, mark: u16, comptime width: u6) u64 {
        const live: u64 = 0 -% @as(u64, @intFromBool(self.wrote(mark)));
        const next: u6 = @as(u4, @truncate(mark >> way_shift));
        const filled = (@as(u64, 1) << (next * width)) -% 1 | (0 -% @as(u64, mark >> (@bitSizeOf(u16) - 1)));
        return live & filled;
    }

    /// Whether this stream wrote the bucket `mark` belongs to: else the bucket holds no entry.
    inline fn wrote(self: *const Buckets, mark: u16) bool {
        return (mark ^ @as(u16, @truncate(self.tag))) & mark_tag_mask == 0;
    }

    /// The ring's next way of `slot`'s bucket, which this stream wrote: a search reads it after
    /// a hit, and only such a bucket has one.
    pub inline fn next_of(self: *const Buckets, slot: Slot) usize {
        return (self.marks[slot.bucket] >> way_shift) & way_mask;
    }

    /// The entries of `slot`'s bucket whose check is `slot`'s, a bit each: none where an earlier
    /// stream wrote the bucket last.
    pub inline fn hits(self: *const Buckets, slot: Slot) u16 {
        const lanes: u16 = @bitCast(self.check_lanes(slot));
        return lanes & self.written_ways(self.marks[slot.bucket]);
    }

    /// The entries of `slot`'s bucket whose check is `slot`'s, 4 bits each: way w's are bits 4w to
    /// 4w + 3. One narrowing shift makes it from the compare of 16 lanes.
    pub inline fn hit_nibbles(self: *const Buckets, slot: Slot) u64 {
        return nibbles(self.check_lanes(slot)) & self.written_bits(self.marks[slot.bucket], @bitSizeOf(u4));
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
    /// the side table, over the position its 4 octets named before. The stream's first insert in
    /// a bucket empties it first, and starts its ring. The stream's values are read before the
    /// first store, which the compiler cannot show leaves them.
    pub inline fn insert_at(self: *Buckets, comptime safety: bool, slot: Slot, position: usize) void {
        @setRuntimeSafety(safety);
        const side_entry = self.base +% @as(u32, @truncate(position));
        const mark = self.marks[slot.bucket];
        const stream_mark: u16 = if (self.wrote(mark)) mark else @truncate(self.tag);
        self.entries[slot.bucket][(stream_mark >> way_shift) & way_mask] = entry_of(slot.check, position);
        self.marks[slot.bucket] = (stream_mark +% way_step) | (stream_mark & full_bit);
        self.side[slot.side] = side_entry;
    }

    /// The position `entry` of `slot`'s bucket names, when it holds `slot`'s check and lies from
    /// `low` up and before `position`. `low` is 1 at least, so an entry of 0 names none.
    pub inline fn candidate(slot: Slot, entry: u32, low: usize, position: usize) ?usize {
        const lowest = entry_of(slot.check, low);
        if (entry < lowest or entry >= entry_of(slot.check, position)) return null;
        return entry & position_mask;
    }

    /// The position the side table names for `slot`, when it lies in this stream from `low` up and
    /// before `position`: the newest whose 4 octets hash as `slot`'s do.
    pub inline fn side_candidate(self: *const Buckets, slot: Slot, low: usize, position: usize) ?usize {
        const entry = self.side[slot.side];
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
/// A position between two repeats, whose octets no other position stored has.
const lone_position = 100;
/// The inserts into one bucket: its ways twice over, so the ring writes over them once, and one
/// more, so the ring's next way is not its first when the stream ends.
const rounds = 2;
const fill_count = rounds * ways + 1;
/// The hits of a bucket whose first two ways alone hold the slot's check.
const first_two_ways: u16 = 0b11;

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
    // A side table, a bucket and its mark that name a position before `init`, as memory a caller
    // did not clear may: `init` must leave none a search takes.
    buckets.side = @splat((@as(u32, 1) << position_bits) + repeat_step);
    buckets.entries[slot.bucket] = @splat(Buckets.entry_of(slot.check, repeat_step));
    buckets.tag = 1;
    buckets.marks[slot.bucket] = buckets.mark_of(0);
    buckets.init();
    try testing.expectEqual(0, buckets.hits(slot));
    try testing.expectEqual(0, buckets.hit_nibbles(slot));
    for (0..side_count) |place| try testing.expectEqual(null, buckets.side_candidate(.{ .bucket = 0, .check = 0, .side = place }, 1, test_end));
    for (1..fill_count + 1) |index| buckets.insert(true, &window_octets, index * repeat_step);
    var named: usize = 0;
    for (buckets.entries[slot.bucket]) |entry| {
        const position = Buckets.candidate(slot, entry, 1, test_end) orelse continue;
        try testing.expect(position > (fill_count - ways) * repeat_step and position <= fill_count * repeat_step);
        named += 1;
    }
    try testing.expectEqual(ways, named);
    try testing.expectEqual(std.math.maxInt(u16), buckets.hits(slot));
    try testing.expectEqual(fill_count % ways, buckets.next_of(slot));
    // The side table names the newest of them.
    try testing.expectEqual(fill_count * repeat_step, buckets.side_candidate(slot, 1, test_end));
    // A new stream finds none of them, and its first insert empties the bucket and starts its
    // ring at the first way.
    buckets.start();
    try testing.expectEqual(0, buckets.hits(slot));
    try testing.expectEqual(null, buckets.side_candidate(slot, 1, test_end));
    buckets.insert(true, &window_octets, before_slide);
    try testing.expectEqual(1, buckets.hits(slot));
    try testing.expectEqual(1, buckets.next_of(slot));
    try testing.expectEqual(before_slide, Buckets.candidate(slot, buckets.entries[slot.bucket][0], 1, test_end));
    buckets.insert(true, &window_octets, after_slide);
    try testing.expectEqual(first_two_ways, buckets.hits(slot));
    try testing.expectEqual(@popCount(first_two_ways), buckets.next_of(slot));
    try expect_slide(buckets, &window_octets, slot);
}

/// A slide moves this stream's entries down and empties those that slid out. A bucket an earlier
/// stream wrote last holds no entry, and the slide leaves it as it is.
fn expect_slide(buckets: *Buckets, window_octets: []const u8, slot: Slot) !void {
    // Other octets below the slide, which the side table names until then.
    const lone = Buckets.slot_of(true, window_octets, lone_position);
    try testing.expect(lone.side != slot.side and lone.bucket != slot.bucket);
    buckets.insert(true, window_octets, lone_position);
    try testing.expectEqual(lone_position, buckets.side_candidate(lone, 1, test_end));
    // A bucket this stream has not written, which holds an earlier stream's entries.
    const stale = for (0..bucket_count) |bucket| {
        if (bucket != slot.bucket and bucket != lone.bucket) break bucket;
    } else unreachable;
    const stale_entry = Buckets.entry_of(slot.check, after_slide);
    buckets.entries[stale] = @splat(stale_entry);
    buckets.marks[stale] = buckets.mark_of(0) - 1;
    try testing.expectEqual(before_slide, buckets.entries[slot.bucket][0] & position_mask);
    buckets.slide(slide_by);
    try testing.expectEqual(kept_at, buckets.side_candidate(slot, 1, test_end));
    try testing.expectEqual(null, buckets.side_candidate(lone, 1, test_end));
    var kept: usize = 0;
    for (buckets.entries[slot.bucket]) |entry| {
        if (Buckets.candidate(slot, entry, 1, test_end)) |position| {
            try testing.expectEqual(kept_at, position);
            kept += 1;
        }
    }
    try testing.expectEqual(1, kept);
    // The position that slid out left no entry, and the earlier stream's bucket is as it was.
    try testing.expectEqual(0, buckets.entries[slot.bucket][0]);
    for (buckets.entries[stale]) |entry| try testing.expectEqual(stale_entry, entry);
    // The tags run out, and a later stream takes this stream's tag again: no stream finds one
    // of its entries.
    for (0..@as(usize, 1) << tag_bits) |_| {
        buckets.start();
        try testing.expectEqual(0, buckets.hits(slot));
        try testing.expectEqual(null, buckets.side_candidate(slot, 1, test_end));
    }
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

test "a bucket's masks set a way whose check is the slot's, a bit or 4 bits each" {
    try @call(.never_inline, expect_masks, .{});
}

/// Entries in one bucket, each with the slot's check, with a check one bit from it, or with a
/// seeded one, and a seeded next way in its mark. The masks must set the ways whose check is the
/// slot's, 4 bits a way in the nibble mask, and none under the mark of an earlier stream.
fn expect_masks() !void {
    var buckets_state: Buckets = undefined;
    const buckets = &buckets_state;
    buckets.init();
    // The next tag: a mark of the first is an earlier stream's.
    buckets.start();
    var generator = codec.testing.split.Generator.init(mask_seed);
    const slot: Slot = .{ .bucket = 0, .check = mask_check, .side = 0 };
    for (0..mask_rounds) |_| {
        var expected: u16 = 0;
        for (0..ways) |way| {
            const kind: CheckKind = @enumFromInt(generator.below(@typeInfo(CheckKind).@"enum".fields.len));
            const check: u8 = switch (kind) {
                .equal => mask_check,
                .low_bit => mask_check ^ 1,
                .top_bit => mask_check ^ (1 << (@bitSizeOf(u8) - 1)),
                .seeded => @truncate(generator.next()),
            };
            buckets.entries[0][way] = Buckets.entry_of(check, @intCast(generator.below(mask_position)));
            if (check == mask_check) expected |= @as(u16, 1) << @intCast(way);
        }
        const next: usize = @intCast(generator.below(ways));
        buckets.marks[0] = buckets.mark_of(next);
        try testing.expectEqual(expected, buckets.hits(slot));
        try testing.expectEqual(spread(expected), buckets.hit_nibbles(slot));
        try testing.expectEqual(next, buckets.next_of(slot));
        buckets.marks[0] -= 1;
        try testing.expectEqual(0, buckets.hits(slot));
        try testing.expectEqual(0, buckets.hit_nibbles(slot));
    }
}

/// What a way's check is in the masks' test.
const CheckKind = enum { equal, low_bit, top_bit, seeded };

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
        try testing.expectEqual(case.named, Buckets.candidate(slot, Buckets.entry_of(case.check, case.position), mask_low, mask_position));
    }
    // An empty entry names none, for a slot whose check is 0 too.
    try testing.expectEqual(null, Buckets.candidate(.{ .bucket = 0, .check = 0, .side = 0 }, 0, 1, mask_position));
}
