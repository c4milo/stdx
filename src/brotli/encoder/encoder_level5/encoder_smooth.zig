//! Level 5's codes, each built twice (decision 66, output size). A code's description takes fewer
//! bits where neighbouring symbols share a length, since one repeat symbol then covers a run of
//! them (RFC 7932 §3.5). So the encoder smooths the counts: each stride of neighbours whose counts
//! lie within `smooth_tolerance` of the stride's mean takes that mean, and the builder gives them
//! lengths that differ less. The code built from the smoothed counts stays where its description
//! and the meta-block's symbols take fewer bits than the code built from the counts themselves.
//!
//! Google's encoder smooths its counts the same way (decision 67): the method is written again
//! here, from what a repeat symbol of RFC 7932 §3.5 covers.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_prefix = @import("../encoder_prefix.zig");

const level5 = constants.encoder_level5;

/// Builds `code` from `counts`, or from the smoothed counts where that code takes fewer bits for
/// `counts`, its description's symbols `alphabet_bits` wide in the simple form.
pub fn build(comptime n: usize, counts: *const [n]u16, code: *encoder_prefix.Code(n), alphabet_bits: u4) void {
    encoder_prefix.build(n, counts, code);
    var smoothed: [n]u16 = undefined;
    if (!smooth(n, counts, &smoothed)) return;
    var other: encoder_prefix.Code(n) = undefined;
    encoder_prefix.build(n, &smoothed, &other);
    if (bits_of(n, counts, &other, alphabet_bits) < bits_of(n, counts, code, alphabet_bits)) code.* = other;
}

/// The bits `code` takes for `counts`: its description and the symbols.
pub fn bits_of(comptime n: usize, counts: *const [n]u16, code: *const encoder_prefix.Code(n), alphabet_bits: u4) u64 {
    var bits: u64 = encoder_prefix.description_bits(n, code, alphabet_bits);
    for (counts, code.lengths) |count, len| bits += @as(u64, count) * len;
    return bits;
}

/// `counts` smoothed into `out`. False where the counts stay as they are: fewer than
/// `smooth_symbols_min` symbols occur, or no stride changed.
pub fn smooth(comptime n: usize, counts: *const [n]u16, out: *[n]u16) bool {
    out.* = counts.*;
    var end: usize = 0;
    var used: usize = 0;
    for (counts, 0..) |count, symbol| {
        if (count == 0) continue;
        end = symbol + 1;
        used += 1;
    }
    if (used < level5.smooth_symbols_min) return false;
    var kept: [n]bool = undefined;
    mark_runs(n, counts[0..end], kept[0..end]);
    var start: usize = 0;
    var sum: u64 = 0;
    for (0..end + 1) |index| {
        const closes = index == end or kept[index] or (index > start and far(counts[index], sum, index - start));
        if (closes) {
            settle(out[start..index], sum);
            start = index;
            sum = 0;
            if (index < end and kept[index]) {
                start = index + 1;
                continue;
            }
        }
        if (index < end) sum += counts[index];
    }
    return !std.mem.eql(u16, out, counts);
}

/// Marks the runs a repeat symbol takes as they are: `smooth_zero_run_min` zeros or more, or
/// `smooth_equal_run_min` equal counts or more.
fn mark_runs(comptime n: usize, counts: []const u16, kept: []bool) void {
    assert(counts.len == kept.len and counts.len <= n);
    @memset(kept, false);
    var start: usize = 0;
    for (1..counts.len + 1) |index| {
        if (index < counts.len and counts[index] == counts[start]) continue;
        const run = index - start;
        const takes = if (counts[start] == 0) run >= level5.smooth_zero_run_min else run >= level5.smooth_equal_run_min;
        if (takes) @memset(kept[start..index], true);
        start = index;
    }
}

/// Whether `count` lies farther than `smooth_tolerance` from the mean of a stride of `stride`
/// counts that sum to `sum`.
fn far(count: u16, sum: u64, stride: usize) bool {
    const scaled: i64 = @as(i64, count) * @as(i64, @intCast(stride));
    return @abs(scaled - @as(i64, @intCast(sum))) > level5.smooth_tolerance * stride;
}

/// A stride of `smooth_stride_min` counts or more takes their mean, rounded; a stride with a count
/// takes 1 at least, so its symbols keep a code.
fn settle(stride: []u16, sum: u64) void {
    if (stride.len < level5.smooth_stride_min) return;
    var mean = (sum + stride.len / 2) / stride.len;
    if (mean == 0 and sum > 0) mean = 1;
    @memset(stride, @intCast(mean));
}

const testing = std.testing;

test "a stride of near counts takes its mean, and a run a repeat takes stays" {
    // 16 symbols occur. 5, 6, 4, 7 lie within 4 of their mean and take 6 (22 / 4 rounded); 40
    // ends the stride. The 5 zeros and the 7 counts of 9 stay; 1, 2, 1, 3, 2 take 2.
    const counts = [_]u16{ 5, 6, 4, 7, 40, 0, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 1, 2, 1, 3, 2, 0 };
    var out: [counts.len]u16 = undefined;
    try testing.expect(smooth(counts.len, &counts, &out));
    const expected = [_]u16{ 6, 6, 6, 6, 40, 0, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 2, 2, 2, 2, 2, 0 };
    try testing.expectEqualSlices(u16, &expected, &out);
}

test "fewer than 16 symbols, or strides of fewer than 4, leave the counts as they are" {
    const few = [_]u16{ 5, 6, 4, 7, 5, 6, 4, 7, 5, 6, 4, 7, 5, 6, 4, 0 };
    var out: [few.len]u16 = undefined;
    try testing.expect(!smooth(few.len, &few, &out));
    try testing.expectEqualSlices(u16, &few, &out);
    // Each count lies past 4 of the one before, so each stride holds one count.
    const apart = [_]u16{ 1, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 10 };
    var apart_out: [apart.len]u16 = undefined;
    try testing.expect(!smooth(apart.len, &apart, &apart_out));
}

test "the code built from smoothed counts stays only where it takes fewer bits" {
    // Seeded counts: each code `build` keeps takes the fewer bits of the two, and among the seeds
    // each of the two wins at least once.
    var generator = codec.testing.split.Generator.init(constants.literal_alphabet_len);
    var smoothed_won = false;
    var plain_won = false;
    for (0..seeds) |_| {
        var counts: [constants.literal_alphabet_len]u16 = @splat(0);
        const spread = 1 + generator.below(spread_max);
        for (counts[0..seeded_symbols]) |*count| count.* = @intCast(base_count + generator.below(spread));
        var code: encoder_prefix.Code(constants.literal_alphabet_len) = undefined;
        build(counts.len, &counts, &code, constants.literal_alphabet_bits);
        var plain: encoder_prefix.Code(constants.literal_alphabet_len) = undefined;
        encoder_prefix.build(counts.len, &counts, &plain);
        const plain_bits = bits_of(counts.len, &counts, &plain, constants.literal_alphabet_bits);
        var smoothed_counts: [constants.literal_alphabet_len]u16 = undefined;
        var smoothed_bits = plain_bits;
        if (smooth(counts.len, &counts, &smoothed_counts)) {
            var smoothed: encoder_prefix.Code(constants.literal_alphabet_len) = undefined;
            encoder_prefix.build(counts.len, &smoothed_counts, &smoothed);
            smoothed_bits = bits_of(counts.len, &counts, &smoothed, constants.literal_alphabet_bits);
        }
        try testing.expectEqual(@min(plain_bits, smoothed_bits), bits_of(counts.len, &counts, &code, constants.literal_alphabet_bits));
        smoothed_won = smoothed_won or smoothed_bits < plain_bits;
        plain_won = plain_won or plain_bits < smoothed_bits;
    }
    try testing.expect(smoothed_won and plain_won);
}

const seeds = 64;
const seeded_symbols = 64;
const base_count = 1;
/// The counts' spread, up to 3 times the tolerance: near counts smooth well, far ones do not.
const spread_max = 3 * level5.smooth_tolerance;
