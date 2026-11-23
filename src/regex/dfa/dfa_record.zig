//! The seeds of a lazy DFA's state as its cache keeps them (decision 86 as amended): each seed,
//! an instruction's number, as its difference from the seed before it, in octets of seven bits.
//!
//! A state's seeds are the instructions its threads go on from, in order of preference, so the
//! record keeps their order. Read back, a state of `\p{L}{8,13}` holds hundreds of seeds, most
//! near each other in the program, so most differences take one or two octets where a word takes
//! four. Rust's regex crate packs its states' instructions the same way (regex-automata 0.4.19,
//! `util/determinize/state.rs`).
//!
//! A difference is signed, so it is first mapped to an unsigned value: zero, minus one, one,
//! minus two, and so on, to 0, 1, 2, 3. Each octet then holds seven bits of it, the lowest first,
//! and its high bit says whether more octets follow.
const std = @import("std");
const assert = std.debug.assert;

/// The bits of a difference each octet holds.
const value_bits = 7;

/// The bit of an octet that says more octets of the difference follow.
const more_bit: u8 = 1 << value_bits;

/// The bits of a difference between two instructions' numbers, as `zigzag` maps it.
const difference_bits = @bitSizeOf(u32) + 1;

/// The octets of the longest difference.
pub const octets_per_seed_max = (difference_bits + value_bits - 1) / value_bits;

/// A signed difference as an unsigned value: 0, -1, 1, -2, 2 to 0, 1, 2, 3, 4.
fn zigzag(difference: i64) u64 {
    return @bitCast((difference << 1) ^ (difference >> (@bitSizeOf(i64) - 1)));
}

fn unzigzag(value: u64) i64 {
    const half: i64 = @intCast(value >> 1);
    return if (value & 1 == 0) half else -half - 1;
}

/// Writes `seeds` into `out`, and gives the count of octets written, or null where `out` is too
/// short for them.
pub fn encode(seeds: []const u32, out: []u8) ?usize {
    var len: usize = 0;
    var last: u32 = 0;
    for (seeds) |seed| {
        if (out.len - len < octets_of(seed, last)) return null;
        len += put(out[len..], seed, last);
        last = seed;
    }
    return len;
}

/// The octets the difference from `last` to `seed` takes.
fn octets_of(seed: u32, last: u32) usize {
    var value = zigzag(@as(i64, seed) - @as(i64, last));
    var octets: usize = 1;
    // At most `octets_per_seed_max` turns.
    while (value >= more_bit) : (octets += 1) value >>= value_bits;
    return octets;
}

/// Writes the difference from `last` to `seed` at the start of `out`, which holds the longest, and
/// gives its count of octets.
fn put(out: []u8, seed: u32, last: u32) usize {
    var value = zigzag(@as(i64, seed) - @as(i64, last));
    var len: usize = 0;
    // At most `octets_per_seed_max` turns, as `difference_bits` bound the value.
    while (value >= more_bit) : (len += 1) {
        out[len] = @as(u8, @truncate(value)) | more_bit;
        value >>= value_bits;
    }
    out[len] = @intCast(value);
    return len + 1;
}

/// The seeds of a record, in order.
pub const Seeds = struct {
    octets: []const u8,
    at: usize = 0,
    last: u32 = 0,

    pub fn next(seeds: *Seeds) ?u32 {
        if (seeds.at == seeds.octets.len) return null;
        var value: u64 = 0;
        var shift: u6 = 0;
        // At most `octets_per_seed_max` octets, as `encode` wrote them.
        for (0..octets_per_seed_max) |_| {
            const octet = seeds.octets[seeds.at];
            seeds.at += 1;
            value |= @as(u64, octet & (more_bit - 1)) << shift;
            if (octet & more_bit == 0) break;
            shift += value_bits;
        }
        seeds.last = @intCast(@as(i64, seeds.last) + unzigzag(value));
        return seeds.last;
    }
};

const testing = std.testing;

test "seeds come back in their order, near ones in one octet, far ones in more" {
    const seeds = [_]u32{ 40_000, 40_001, 39_999, 40_063, 40_064, 0, std.math.maxInt(u32), 0 };
    var out: [seeds.len * octets_per_seed_max]u8 = undefined;
    const len = encode(&seeds, &out).?;
    var read: Seeds = .{ .octets = out[0..len] };
    for (seeds) |seed| try testing.expectEqual(seed, read.next().?);
    try testing.expect(read.next() == null);
    // A difference of one, of minus two, and of 64 (two octets: zigzag gives 128).
    var near: [octets_per_seed_max]u8 = undefined;
    try testing.expectEqual(@as(usize, 1), put(&near, 40_001, 40_000));
    try testing.expectEqual(@as(usize, 1), put(&near, 39_999, 40_001));
    try testing.expectEqual(@as(usize, 2), put(&near, 40_064, 40_000));
    try testing.expectEqual(@as(usize, octets_per_seed_max), put(&near, std.math.maxInt(u32), 0));
}

test "an encoding that does not fit gives null, and one that just fits is written" {
    const seeds = [_]u32{ 10, 12, 500, 9 };
    var room: [16]u8 = undefined;
    const len = encode(&seeds, &room).?;
    var exact: [16]u8 = undefined;
    try testing.expectEqual(len, encode(&seeds, exact[0..len]).?);
    try testing.expectEqualSlices(u8, room[0..len], exact[0..len]);
    try testing.expect(encode(&seeds, exact[0 .. len - 1]) == null);
    try testing.expectEqual(@as(usize, 0), encode(&.{}, exact[0..0]).?);
}
