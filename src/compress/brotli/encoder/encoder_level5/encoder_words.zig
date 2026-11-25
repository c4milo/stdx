//! Level 5's static dictionary words (RFC 7932 §8; decision 62, as the owner's ruling of
//! 2026-11-07 amends it): a match of the input with a word's first octets, coded as the word under
//! the identity transform or OmitLast1 to OmitLast9, which drop its last 1 to 9 octets.
//!
//! A comptime table, built from the RFC's dictionary, holds for each hash of 4 octets the shortest
//! words, up to `word_ways`, that start with octets of that hash. A word's reference takes 16
//! bits: its length above its index.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const dictionary = @import("../../dictionary.zig");
const transform = @import("../../transform.zig");

const level5 = constants.encoder_level5;
const bucket_count = @as(usize, 1) << level5.word_bucket_log;
const ways = level5.word_ways;
const index_bits = std.math.log2_int(usize, std.math.maxInt(u16) + 1) - @bitSizeOf(u5);
const none = std.math.maxInt(u16);
const key_len = @sizeOf(u32);

comptime {
    // A reference holds a length up to 24 in 5 bits above an index of up to 11 bits.
    for (dictionary.bits) |word_bits| assert(word_bits <= index_bits);
    assert(constants.word_len_max < 1 << @bitSizeOf(u5));
    assert((constants.word_len_max << index_bits) + (1 << index_bits) - 1 < none);
    assert(constants.word_len_min == key_len);
}

/// A word that matches the input: the octets it writes, its length, and its word_id (RFC 7932 §8).
pub const Word = struct { written_len: usize, word_len: usize, word_id: u32 };

/// The word whose first octets the most of `window[position..end]` match, 4 at least, with the
/// transform that writes them.
pub inline fn find(comptime safety: bool, window: []const u8, position: usize, end: usize) ?Word {
    @setRuntimeSafety(safety);
    assert(position + key_len <= end and end <= window.len);
    const key = std.mem.readInt(u32, window[position..][0..key_len], .little);
    const slot = slot_of(key);
    // The frequent case, its own code (decision 66, part 3): no way's check agrees, and the
    // dictionary is not read. One read of 4 checks, in a table that stays in the first-level cache.
    // It stays in the caller; the ways that agree go to a function of their own.
    const hits = agreeing(std.mem.readInt(Hits, &checks[slot.bucket], .little), slot.check);
    if (hits == 0) return null;
    return find_among(safety, window, position, end, slot.bucket, hits);
}

/// The ways of a bucket whose check agrees: the top bit of way w's octet, in a word of the
/// bucket's 4 checks, the first way's least significant.
const Hits = u32;

/// 1 in each octet of a word, and the bits of each octet below its top bit.
const octet_ones: Hits = std.math.maxInt(Hits) / std.math.maxInt(u8);
const octet_low_bits: Hits = octet_ones * (std.math.maxInt(u8) >> 1);

comptime {
    // One word holds a bucket's checks, an octet each.
    assert(ways == @sizeOf(Hits));
}

/// The top bit of each octet of `word` that equals `check`, and no other bit. The sum takes each
/// octet's low 7 bits, so no carry leaves an octet, and it sets the top bit where one of the 7
/// differs.
///
/// A compare of 4 lanes says the same, and Zig 0.16.0's own x86-64 backend, which builds a
/// caller's Debug program on x86-64 Linux, leaves bits above the fourth in that compare's mask.
/// These are operations on one integer, which every backend computes alike.
inline fn agreeing(word: Hits, check: u8) Hits {
    const differing = word ^ (octet_ones * check);
    return ~(((differing & octet_low_bits) + octet_low_bits) | differing | octet_low_bits);
}

/// `find` over the ways of `bucket` that `first_hits` names.
noinline fn find_among(comptime safety: bool, window: []const u8, position: usize, end: usize, bucket: usize, first_hits: Hits) ?Word {
    @setRuntimeSafety(safety);
    var hits = first_hits;
    var best: ?Word = null;
    for (0..ways) |_| {
        if (hits == 0) break;
        const way = @ctz(hits) / @bitSizeOf(u8);
        hits &= hits - 1;
        const reference = table[bucket][way];
        if (reference == none) continue;
        const word_len: usize = reference >> index_bits;
        const index: u32 = reference & ((1 << index_bits) - 1);
        const word = dictionary.word(word_len, index);
        const len = agreed_len(safety, word, window[position..@min(end, position + word_len)]);
        if (len < constants.word_len_min or word_len - len > level5.word_omit_max) continue;
        if (best) |held| {
            if (len <= held.written_len) continue;
        }
        const transform_id: u32 = omit_last_transforms[word_len - len];
        best = .{ .written_len = len, .word_len = word_len, .word_id = index | transform_id << dictionary.bits[word_len] };
    }
    return best;
}

fn agreed_len(comptime safety: bool, word: []const u8, input: []const u8) usize {
    @setRuntimeSafety(safety);
    for (input, word[0..input.len], 0..) |left, right, index| {
        if (left != right) return index;
    }
    return input.len;
}

/// The bucket of 4 octets, and their check: the 8 bits of the hash below the bucket's.
const Slot = struct { bucket: usize, check: u8 };

fn slot_of(key: u32) Slot {
    const product = @as(u64, key) *% codec.constants.match_hash_multiplier;
    return .{
        .bucket = @intCast(product >> (@bitSizeOf(u64) - level5.word_bucket_log)),
        .check = @truncate(product >> (@bitSizeOf(u64) - level5.word_bucket_log - @bitSizeOf(u8))),
    };
}

/// The transform_id of the identity, then of OmitLast1 to OmitLast9, each with no prefix and no
/// suffix, from RFC 7932 Appendix B's list.
pub const omit_last_transforms = ids: {
    var ids: [level5.word_omit_max + 1]u8 = undefined;
    for (&ids, 0..) |*id, omitted| {
        const kind: transform.Kind = if (omitted == 0) .identity else @enumFromInt(@intFromEnum(transform.Kind.omit_last_1) + omitted - 1);
        id.* = for (transform.table, 0..) |entry, candidate| {
            if (entry.kind == kind and entry.prefix.len == 0 and entry.suffix.len == 0) break candidate;
        } else unreachable;
    }
    break :ids ids;
};

/// Each bucket's words, the shortest first: the dictionary lists them by length, then by index.
const Tables = struct { references: [bucket_count][ways]u16, checks: [bucket_count][ways]u8 };

const tables: Tables = built: {
    @setEvalBranchQuota(table_quota);
    var built: Tables = .{ .references = @splat(@splat(none)), .checks = @splat(@splat(0)) };
    var filled: [bucket_count]u8 = @splat(0);
    for (constants.word_len_min..constants.word_len_max + 1) |word_len| {
        for (0..dictionary.word_count(word_len)) |index| {
            const word = dictionary.word(word_len, @intCast(index));
            const slot = slot_of(std.mem.readInt(u32, word[0..key_len], .little));
            if (filled[slot.bucket] == ways) continue;
            built.references[slot.bucket][filled[slot.bucket]] = @intCast(word_len << index_bits | index);
            built.checks[slot.bucket][filled[slot.bucket]] = slot.check;
            filled[slot.bucket] += 1;
        }
    }
    break :built built;
};
const table = &tables.references;
/// Each way's check, 64 KiB: an empty way's is 0, and its reference, `none`, names no word.
const checks = &tables.checks;

const table_quota = 10_000_000;

const testing = std.testing;

test "the omitted octets name the identity and OmitLast1 to OmitLast9" {
    // RFC 7932 Appendix B: the identity is 0, OmitLast1 is 12 and OmitLast9 is 64.
    try testing.expectEqual(0, omit_last_transforms[0]);
    try testing.expectEqual(omit_last_1_id, omit_last_transforms[1]);
    try testing.expectEqual(omit_last_9_id, omit_last_transforms[level5.word_omit_max]);
}

const omit_last_1_id = 12;
const omit_last_9_id = 64;

test "a word the input holds is found, whole or less its last octets" {
    const word = dictionary.word(test_word_len, test_word_index);
    var window: [test_window_len]u8 = @splat('#');
    @memcpy(window[test_at..][0..word.len], word);
    const whole = find(true, &window, test_at, window.len) orelse return error.TestNotFound;
    try testing.expect(whole.written_len >= word.len);
    // The word less its last octet: a word that long, or this one under OmitLast1.
    window[test_at + word.len - 1] = '#';
    const less = find(true, &window, test_at, window.len) orelse return error.TestNotFound;
    try testing.expectEqual(word.len - 1, less.written_len);
}

test "a word found leaves at most 9 of its octets out" {
    // A long word whose first octets alone the input holds: OmitLast9 drops no more than 9.
    const word = dictionary.word(long_word_len, test_word_index);
    for (constants.word_len_min..long_word_len + 1) |kept| {
        var window: [test_window_len]u8 = @splat('#');
        @memcpy(window[test_at..][0..kept], word[0..kept]);
        const found = find(true, &window, test_at, window.len) orelse continue;
        try testing.expect(found.word_len - found.written_len <= level5.word_omit_max);
        try testing.expect(found.written_len <= kept);
    }
}

const long_word_len = 20;
const test_word_len = 9;
const test_word_index = 100;
const test_window_len = 64;
const test_at = 8;

test "the agreeing ways are the octets equal to the check, and no other" {
    var generator = codec.testing.split.Generator.init(agreeing_seed);
    for (0..agreeing_rounds) |_| {
        const check: u8 = @truncate(generator.next());
        var octets: [ways]u8 = undefined;
        var expected: Hits = 0;
        for (&octets, 0..) |*octet, way| {
            const kind: OctetKind = @enumFromInt(generator.below(@typeInfo(OctetKind).@"enum".fields.len));
            octet.* = switch (kind) {
                .equal => check,
                .top_bit => check ^ top_bit,
                .low_bit => check ^ 1,
                .every_bit => ~check,
                .seeded => @truncate(generator.next()),
            };
            if (octet.* == check) expected |= @as(Hits, top_bit) << @intCast(way * @bitSizeOf(u8));
        }
        try testing.expectEqual(expected, agreeing(std.mem.readInt(Hits, &octets, .little), check));
    }
}

/// What an octet of the test's word holds: the check, the check with its top bit, its low bit or
/// every bit changed, or a seeded octet.
const OctetKind = enum { equal, top_bit, low_bit, every_bit, seeded };
const top_bit: u8 = 1 << (@bitSizeOf(u8) - 1);
const agreeing_seed = 52;
const agreeing_rounds = 4096;

test "a word is found from each way of its bucket" {
    // A bucket whose 4 ways each hold a word, and no way the check of the way opposite: the ways
    // read in the other order would then name another word for each.
    const bucket = for (table, checks, 0..) |references, way_checks, index| {
        if (std.mem.indexOfScalar(u16, &references, none) != null) continue;
        if (way_checks[0] != way_checks[ways - 1] and way_checks[1] != way_checks[ways - 1 - 1]) break index;
    } else return error.TestNoMixedBucket;
    for (table[bucket]) |reference| {
        const word = dictionary.word(reference >> index_bits, reference & ((1 << index_bits) - 1));
        var window: [test_window_len]u8 = @splat('#');
        @memcpy(window[test_at..][0..word.len], word);
        const found = find(true, &window, test_at, window.len) orelse return error.TestNotFound;
        try testing.expectEqual(word.len, found.written_len);
    }
}
