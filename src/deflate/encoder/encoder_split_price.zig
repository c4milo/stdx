//! What a check of decision 44 prices: a block's symbols by their entropy, in eighths of a bit,
//! and an estimate of its dynamic header. A check prices the block's newest symbols and all its
//! symbols in one pass over the counts, `tally_vector_len` counts at a time: Zig 0.16 turns no
//! loop into vector code, so the vectors are written out.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const cost = @import("encoder_match/encoder_match_cost.zig");

/// log2 in eighths of a bit, the unit of decision 42's prices, and the table of its fractions.
const log2_eighths = cost.log2_eighths;
const fraction_eighths = cost.fraction_eighths;
const fraction_bits = cost.fraction_bits;

/// What a price counts for a dynamic header beside its symbols' lengths, in eighths of a bit.
const header_eighths: u64 = constants.header_estimate_bits * constants.cost_eighths_per_bit;

/// A block's price in eighths of a bit, from its counts: its symbols' entropy and an estimate of
/// its dynamic header.
pub fn block(literal_length: []const u16, distance: []const u16) u64 {
    return tally(literal_length).eighths() + tally(distance).eighths() + header_eighths;
}

/// A check's prices, in eighths of a bit.
pub const Check = struct {
    /// The block's newest symbols coded apart from the rest, without an end-of-block of their own.
    newest: u64,
    /// The newest symbols as a block, end-of-block included: what `block` gives their counts.
    newest_block: u64,
    /// All the block's symbols together.
    together: u64,
};

/// Prices a check from the counts of all the block's symbols and of those before its newest.
/// End-of-block is counted once in both, so the newest symbols' counts hold none.
pub fn check(literal_length: []const u16, literal_length_before: []const u16, distance: []const u16, distance_before: []const u16) Check {
    const literal_lengths = tally_check(literal_length, literal_length_before);
    const distances = tally_check(distance, distance_before);
    // As a block, the newest symbols end with end-of-block: a symbol more, with a code of its
    // own, and a count of 1, whose log2 is 0.
    var ended = literal_lengths.newest;
    ended.total += 1;
    ended.used += 1;
    const newest_distances = distances.newest.eighths() + header_eighths;
    return .{
        .newest = literal_lengths.newest.eighths() + newest_distances,
        .newest_block = ended.eighths() + newest_distances,
        .together = literal_lengths.together.eighths() + distances.together.eighths() + header_eighths,
    };
}

/// One alphabet's part of a price: its symbols, the sum of each count times its log2 in eighths of
/// a bit, and the symbols with a count.
const Tally = struct {
    total: u32,
    weighted: u32,
    used: u32,

    /// The bits the symbols take coded by their own frequencies, in eighths of a bit, with each
    /// symbol's length in the header.
    fn eighths(self: Tally) u64 {
        if (self.total == 0) return 0;
        const header: u64 = self.used * constants.header_estimate_symbol_bits * constants.cost_eighths_per_bit;
        // No count's log2 is above the total's, so the weighted sum is the total's at most.
        return @as(u64, self.total) * log2_eighths(self.total) - self.weighted + header;
    }
};

/// The counts one vector op of a tally takes.
const tally_vector_len = 8;
const Counts = @Vector(tally_vector_len, u16);
const Products = @Vector(tally_vector_len, u32);

/// The most a block's counts sum to: its symbols and end-of-block.
const total_max = constants.block_symbols_max + 1;

/// What the masks of `Sums.add` and `log2_eighths_each` leave of a count and of its log2.
const count_mask = std.math.maxInt(i16);
const log2_mask = std.math.maxInt(i8);

comptime {
    assert(total_max <= count_mask);
    assert(log2_eighths(total_max) <= log2_mask);
    // No count's log2 is above the total's, so the products sum to the total times its log2 at
    // most (`Tally.eighths` subtracts on that).
    assert(total_max * log2_eighths(total_max) <= std.math.maxInt(u32));
}

/// A tally's partial sums, one in each lane. A block's counts sum to `total_max` at most, so no
/// lane wraps: not the counts' 16 bits, nor the products' 32.
const Sums = struct {
    total: Counts = @splat(0),
    weighted: Products = @splat(0),
    used: Counts = @splat(0),

    /// Adds a vector of counts; a count of 0 adds nothing.
    inline fn add(self: *Sums, counts: Counts) void {
        self.total +%= counts;
        // The mask changes no count. It tells the compiler that both factors fit 15 bits, which
        // x86-64 multiplies and adds in pairs with one instruction.
        const bounded = counts & @as(Counts, @splat(count_mask));
        self.weighted +%= @as(Products, bounded) *% @as(Products, log2_eighths_each(counts));
        self.used +%= @intFromBool(counts != @as(Counts, @splat(0)));
    }

    fn sum(self: Sums) Tally {
        return .{ .total = @reduce(.Add, self.total), .weighted = @reduce(.Add, self.weighted), .used = @reduce(.Add, self.used) };
    }
};

/// One alphabet's tally from its counts.
fn tally(counts: []const u16) align(constants.hot_function_alignment) Tally {
    var sums: Sums = .{};
    var index: usize = 0;
    while (index + tally_vector_len <= counts.len) : (index += tally_vector_len) {
        sums.add(counts[index..][0..tally_vector_len].*);
    }
    sums.add(padded(counts[index..]));
    return sums.sum();
}

/// A check's two tallies of one alphabet.
const CheckTally = struct { newest: Tally, together: Tally };

/// Tallies one alphabet for a check in one pass: `together` the counts in `all`, and `newest`
/// those in `all` and not in `before`. No count of a block's first symbols is above the count of
/// all of them, so no difference wraps.
fn tally_check(all: []const u16, before: []const u16) align(constants.hot_function_alignment) CheckTally {
    assert(all.len == before.len);
    var newest: Sums = .{};
    var together: Sums = .{};
    var index: usize = 0;
    while (index + tally_vector_len <= all.len) : (index += tally_vector_len) {
        const all_counts: Counts = all[index..][0..tally_vector_len].*;
        const before_counts: Counts = before[index..][0..tally_vector_len].*;
        together.add(all_counts);
        newest.add(all_counts -% before_counts);
    }
    const all_counts = padded(all[index..]);
    together.add(all_counts);
    newest.add(all_counts -% padded(before[index..]));
    return .{ .newest = newest.sum(), .together = together.sum() };
}

/// An alphabet's last counts, fewer than a vector holds, with zeros after them.
fn padded(rest: []const u16) Counts {
    assert(rest.len < tally_vector_len);
    var counts: [tally_vector_len]u16 = @splat(0);
    @memcpy(counts[0..rest.len], rest);
    return counts;
}

const fraction_mask = (1 << fraction_bits) - 1;

/// A float's fraction bits, and the bias of its exponent (IEEE 754 binary32).
const float_fraction_bits = std.math.floatMantissaBits(f32);
const float_exponent_bias = std.math.floatExponentMax(f32);

/// `fraction_eighths[k]` is `k`, and one more for the four `k` from `round_up_first` on: of
/// `k + round_up_first`, those alone have bit `round_up_bit` set.
const round_up_first = 2;
const round_up_bit = 2;

comptime {
    for (fraction_eighths, 0..) |eighths, k| assert(eighths == k + (((k + round_up_first) >> round_up_bit) & 1));
    // `log2_eighths` never falls as its count grows: no fraction's eighths are below the one
    // before, and none reaches a whole bit.
    for (fraction_eighths[1..], fraction_eighths[0 .. fraction_eighths.len - 1]) |eighths, before| assert(eighths >= before);
    assert(fraction_eighths[fraction_eighths.len - 1] < constants.cost_eighths_per_bit);
    // A count converts to a float exactly.
    assert(total_max < 1 << (float_fraction_bits + 1));
}

/// `log2_eighths` of each count at once, read from the count as a float: a count converts
/// exactly, the float's exponent is the place of the count's leading one, and its fraction's
/// first bits are the bits after it. A count of 0 gives a value its product with the count hides.
inline fn log2_eighths_each(counts: Counts) Counts {
    const floats: @Vector(tally_vector_len, f32) = @floatFromInt(@as(@Vector(tally_vector_len, i32), counts));
    const fields: Products = @bitCast(floats);
    // The biased exponent, and under it the fraction's first `fraction_bits` bits.
    const leading: Counts = @truncate(fields >> @splat(float_fraction_bits - fraction_bits));
    const unrounded = leading -% @as(Counts, @splat(float_exponent_bias << fraction_bits));
    const fraction = unrounded & @as(Counts, @splat(fraction_mask));
    const rounding = ((fraction +% @as(Counts, @splat(round_up_first))) >> @splat(round_up_bit)) & @as(Counts, @splat(1));
    // The mask changes no count's log2: it bounds the factor, as `Sums.add` bounds the count.
    return (unrounded +% rounding) & @as(Counts, @splat(log2_mask));
}

const testing = std.testing;
const codec = @import("codec");

test "the log2 a float gives is log2_eighths for every count a block holds" {
    var first: u16 = 1;
    while (first <= total_max) : (first += tally_vector_len) {
        var counts: [tally_vector_len]u16 = undefined;
        for (&counts, 0..) |*count, lane| count.* = first + @as(u16, @intCast(lane));
        const each: [tally_vector_len]u16 = log2_eighths_each(counts);
        for (each, counts) |eighths, count| try testing.expectEqual(log2_eighths(count), eighths);
    }
}

/// One alphabet's tally, count by count.
fn reference_tally(counts: []const u16) Tally {
    var result: Tally = .{ .total = 0, .weighted = 0, .used = 0 };
    for (counts) |count| {
        if (count == 0) continue;
        result.total += count;
        result.weighted += count * log2_eighths(count);
        result.used += 1;
    }
    return result;
}

/// Fills `all` with counts that sum to `total_max` at most, 1 in `zero_odds` of them 0 and 1 in
/// `large_odds` as large as the sum allows, the rest `small_count_max` at most, and `before` with
/// a part of each.
fn fill_counts(generator: *codec.split.Generator, all: []u16, before: []u16) void {
    var left: usize = total_max;
    for (all, before) |*all_count, *before_count| {
        const large = generator.below(large_odds) == 0;
        const count = if (generator.below(zero_odds) == 0) 0 else generator.below(@min(left, if (large) left else small_count_max) + 1);
        left -= count;
        all_count.* = @intCast(count);
        before_count.* = @intCast(generator.below(count + 1));
    }
}

const zero_odds = 3;
const large_odds = 16;
const small_count_max = 200;

test "a tally in vectors is its counts added one by one, the last counts of an alphabet included" {
    var generator = codec.split.Generator.init(11);
    for (0..500) |_| {
        var all: [constants.literal_length_used]u16 = undefined;
        var before: [constants.literal_length_used]u16 = undefined;
        // Every length of an alphabet's last counts, from none to a vector less one.
        const len = all.len - generator.below(2 * tally_vector_len);
        fill_counts(&generator, all[0..len], before[0..len]);
        var newest: [constants.literal_length_used]u16 = undefined;
        for (newest[0..len], all[0..len], before[0..len]) |*count, all_count, before_count| count.* = all_count - before_count;
        try testing.expectEqual(reference_tally(all[0..len]), tally(all[0..len]));
        const both = tally_check(all[0..len], before[0..len]);
        try testing.expectEqual(reference_tally(all[0..len]), both.together);
        try testing.expectEqual(reference_tally(newest[0..len]), both.newest);
    }
}

test "a price is its counts' entropy, some bits for each code and some for the header" {
    // 4096 literals, 3 in 4 of them one letter, and end-of-block. In eighths of a bit, log2 of
    // 4097 is 96, of 3072 93 and of 1024 80; end-of-block's count of 1 has a log2 of 0.
    var literal_length = [_]u16{0} ** constants.literal_length_used;
    literal_length['a'] = 3072;
    literal_length['b'] = 1024;
    literal_length[constants.end_of_block] = 1;
    const distance = [_]u16{0} ** constants.distance_used;
    const entropy = 4097 * 96 - 3072 * 93 - 1024 * 80;
    const header = (3 * constants.header_estimate_symbol_bits + constants.header_estimate_bits) * constants.cost_eighths_per_bit;
    try testing.expectEqual(@as(u64, entropy + header), block(&literal_length, &distance));
    // A check's newest symbols have no end-of-block; as a block they have one.
    var before = [_]u16{0} ** constants.literal_length_used;
    before['a'] = 2048;
    before[constants.end_of_block] = 1;
    var newest = [_]u16{0} ** constants.literal_length_used;
    newest['a'] = 1024;
    newest['b'] = 1024;
    const priced = check(&literal_length, &before, &distance, &distance);
    try testing.expectEqual(block(&literal_length, &distance), priced.together);
    try testing.expectEqual(block(&newest, &distance), priced.newest);
    newest[constants.end_of_block] = 1;
    try testing.expectEqual(block(&newest, &distance), priced.newest_block);
}
