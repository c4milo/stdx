//! Claim R5's fingerprint (decision 86 as amended): the two offsets of a set's literals whose
//! octets Teddy's tables and the compares take, and the literals of each of Teddy's buckets.
//!
//! The offsets are the two whose worst rank over the literals sums the least, by
//! `literal_rank.zig`'s rank of each octet's kind.
//!
//! Literals whose two octets share their low nibbles share a bucket. The case forms of a word do:
//! a capital and its lowercase letter differ in their high nibble alone. So their bucket's tables
//! take the octets of those forms and no more, where a bucket of unrelated literals takes each
//! mix of their nibbles. Where more than `teddy_buckets` pairs of low nibbles stand, the pairs in
//! their order share the buckets evenly.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const literal_rank = @import("literal_rank.zig");
const literal_set = @import("literal_set.zig");
const LiteralSet = literal_set.LiteralSet;

/// Writes the set's offsets, its buckets and Teddy's tables, from its `count` literals of `len`
/// octets.
pub fn prepare(set: *LiteralSet) void {
    assert(set.count >= constants.literal_set_count_min and set.count <= constants.literal_set_max);
    assert(set.len >= constants.literal_prefix_len_min and set.len <= constants.literal_len_max);
    const offsets = offsets_of(set);
    set.first_at = offsets.first;
    set.last_at = offsets.last;
    fill_buckets(set);
    fill_heads(set);
    set.teddy = .of(set);
}

/// Writes the head of each literal of `order`, its first `head_len` octets or its `len` where
/// fewer.
fn fill_heads(set: *LiteralSet) void {
    const head_len = literal_set.head_len;
    const len: usize = @min(set.len, head_len);
    set.head_mask = if (len == head_len) std.math.maxInt(u64) else (@as(u64, 1) << @intCast(len * @bitSizeOf(u8))) - 1;
    for (set.heads[0..set.count], set.order[0..set.count]) |*head, literal| {
        var padded: [head_len]u8 = @splat(0);
        @memcpy(padded[0..len], set.octets[literal][0..len]);
        head.* = std.mem.readInt(u64, &padded, .little);
    }
}

/// The two offsets below `len` whose worst ranks over the literals sum the least.
fn offsets_of(set: *const LiteralSet) literal_rank.Offsets {
    const past_ascii = mostly_past_ascii(set);
    var ranks: [constants.literal_len_max]u8 = undefined;
    for (ranks[0..set.len], 0..) |*worst, offset| worst.* = worst_rank(set, offset, past_ascii);
    return literal_rank.rarest_pair(ranks[0..set.len]);
}

fn worst_rank(set: *const LiteralSet, offset: usize, past_ascii: bool) u8 {
    var worst: u8 = 0;
    for (set.octets[0..set.count]) |*octets| worst = @max(worst, @intFromEnum(literal_rank.rank(octets[offset], past_ascii)));
    return worst;
}

/// True when more than half of the set's octets are past ASCII.
fn mostly_past_ascii(set: *const LiteralSet) bool {
    var past: usize = 0;
    for (set.octets[0..set.count]) |*octets| {
        for (octets[0..set.len]) |octet| past += @intFromBool(octet > constants.one_octet_max);
    }
    return literal_rank.mostly(past, @as(usize, set.count) * set.len);
}

/// The low nibbles of a literal's two octets.
fn key_of(set: *const LiteralSet, literal: usize) u8 {
    const octets = &set.octets[literal];
    return (octets[set.first_at] & constants.nibble_mask) << constants.nibble_bits | (octets[set.last_at] & constants.nibble_mask);
}

/// Writes `order` and `bucket_starts`: the literals sorted by their key, each key's literals in
/// one bucket, and the keys spread evenly over the buckets in their order.
fn fill_buckets(set: *LiteralSet) void {
    const count = set.count;
    for (set.order[0..count], 0..) |*literal, index| literal.* = @intCast(index);
    std.sort.insertion(u8, set.order[0..count], set, key_less);
    var buckets: [constants.literal_set_max]u8 = undefined;
    const keys = key_count(set);
    var key: usize = 0;
    for (set.order[0..count], 0..) |literal, index| {
        if (index > 0 and key_of(set, literal) != key_of(set, set.order[index - 1])) key += 1;
        buckets[index] = @intCast(key * constants.teddy_buckets / keys);
    }
    // The buckets grow along `order`, so each starts where the literals of the ones before end.
    var bucket: usize = 0;
    set.bucket_starts[0] = 0;
    for (buckets[0..count], 0..) |literal_bucket, index| {
        while (bucket < literal_bucket) : (bucket += 1) set.bucket_starts[bucket + 1] = @intCast(index);
    }
    while (bucket < constants.teddy_buckets) : (bucket += 1) set.bucket_starts[bucket + 1] = count;
}

fn key_less(set: *const LiteralSet, left: u8, right: u8) bool {
    return key_of(set, left) < key_of(set, right);
}

/// The keys the set's literals hold, `order` sorted by key.
fn key_count(set: *const LiteralSet) usize {
    var keys: usize = 1;
    for (1..set.count) |index| {
        keys += @intFromBool(key_of(set, set.order[index]) != key_of(set, set.order[index - 1]));
    }
    return keys;
}

const testing = std.testing;

fn set_of(literals: []const []const u8) LiteralSet {
    var set: LiteralSet = .{ .octets = undefined, .count = @intCast(literals.len), .len = constants.literal_len_max };
    for (literals, 0..) |literal, index| {
        @memcpy(set.octets[index][0..literal.len], literal);
        set.len = @min(set.len, @as(u8, @intCast(literal.len)));
    }
    prepare(&set);
    return set;
}

test "prepare keeps an English set's first and last octets, and takes a Cyrillic set's continuations" {
    // The long s, 0xC5 0xBF, is one of `(?i)sherlock`'s case forms of `s`.
    const english = set_of(&.{ "Sher", "sher", "SHER", "\xc5\xbfhe", "\xc5\xbfHe" });
    try testing.expectEqual(@as(u8, 0), english.first_at);
    try testing.expectEqual(@as(u8, 3), english.last_at);
    // Ш and ш, then е and Е: lead octets at 0 and 2, continuations at 1 and 3.
    const cyrillic = set_of(&.{ "\xd0\xa8\xd0\xb5", "\xd1\x88\xd0\xb5", "\xd0\xa8\xd0\x95" });
    try testing.expectEqual(@as(u8, 1), cyrillic.first_at);
    try testing.expectEqual(@as(u8, 3), cyrillic.last_at);
    // A capital at 1 outranks the lowercase letters at 0, 2 and 3, and 3 is the widest apart.
    const marked = set_of(&.{ "aBcd", "eFgh" });
    try testing.expectEqual(@as(u8, 1), marked.first_at);
    try testing.expectEqual(@as(u8, 3), marked.last_at);
}

/// The bucket that holds `literal`.
fn bucket_of(set: *const LiteralSet, literal: usize) usize {
    for (0..constants.teddy_buckets) |bucket| {
        for (set.order[set.bucket_starts[bucket]..set.bucket_starts[bucket + 1]]) |member| {
            if (member == literal) return bucket;
        }
    }
    unreachable;
}

test "prepare puts the case forms of a word in one bucket, and other words in others" {
    // `Shed` shares the low nibble of `Sher`'s first octet and not of its last.
    const set = set_of(&.{ "Sher", "Wats", "sher", "wats", "SHER", "Hudd", "Shed" });
    try testing.expectEqual(@as(u8, 0), set.bucket_starts[0]);
    try testing.expectEqual(set.count, set.bucket_starts[constants.teddy_buckets]);
    try testing.expectEqual(bucket_of(&set, 0), bucket_of(&set, 2));
    try testing.expectEqual(bucket_of(&set, 0), bucket_of(&set, 4));
    try testing.expectEqual(bucket_of(&set, 1), bucket_of(&set, 3));
    try testing.expect(bucket_of(&set, 0) != bucket_of(&set, 1));
    try testing.expect(bucket_of(&set, 0) != bucket_of(&set, 5));
    try testing.expect(bucket_of(&set, 1) != bucket_of(&set, 5));
    try testing.expect(bucket_of(&set, 0) != bucket_of(&set, 6));
}

test "prepare spreads more keys than buckets evenly, each literal in one bucket" {
    var literals: [constants.literal_set_max][2]u8 = undefined;
    var slices: [constants.literal_set_max][]const u8 = undefined;
    for (&literals, &slices, 0..) |*literal, *slice, index| {
        literal.* = .{ @intCast('A' + index % constants.nibbles), @intCast('0' + index / constants.nibbles) };
        slice.* = literal;
    }
    const set = set_of(&slices);
    var seen: [constants.literal_set_max]bool = @splat(false);
    for (0..constants.teddy_buckets) |bucket| {
        const members = set.order[set.bucket_starts[bucket]..set.bucket_starts[bucket + 1]];
        try testing.expectEqual(constants.literal_set_max / constants.teddy_buckets, members.len);
        for (members) |member| {
            try testing.expect(!seen[member]);
            seen[member] = true;
        }
    }
}
