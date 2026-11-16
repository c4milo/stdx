//! Level 5's codes, built from smoothed counts (decision 66, output size). A code's description
//! takes fewer bits where neighbouring symbols share a length, since one repeat symbol then covers a
//! run of them (RFC 7932 §3.5). So the encoder smooths the counts: each stride of neighbours whose
//! counts lie within `smooth_tolerance` of the stride's mean takes that mean, and the builder gives
//! them lengths that differ less.
//!
//! Each code is built once. A second build from the counts themselves, the cheaper of the two
//! kept, gave the bodies of 1 KiB 0.1% to 0.4% less output and took 30% of their speed (runs
//! 43982334119 and 43982344482).
//!
//! Google's encoder smooths its counts the same way (decision 67): the method is written again
//! here, from what a repeat symbol of RFC 7932 §3.5 covers.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const encoder_prefix = @import("../encoder_prefix.zig");

const level5 = constants.encoder_level5;

/// Builds `code` from the smoothed counts of `counts`. Each symbol a count names keeps a code, as
/// `settle` gives each stride with a count 1 at least.
pub fn build(comptime n: usize, counts: *const [n]u16, code: *encoder_prefix.Code(n)) void {
    var smoothed: [n]u16 = undefined;
    if (smooth(n, counts, &smoothed)) return encoder_prefix.build(n, &smoothed, code);
    encoder_prefix.build(n, counts, code);
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
    // 5, 6, 4, 7 lie within 4 of their mean and take 6 (22 / 4 rounded); 40 ends the stride. The
    // 5 zeros and the 7 counts of 9 stay; 1, 2, 1, 3, 2 take 2. 10 and 14 lie 4 apart, within the
    // tolerance, and take 12. A stride of one count and zeros takes 1, so the count keeps a code.
    const counts = [_]u16{ 5, 6, 4, 7, 40, 0, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 1, 2, 1, 3, 2, 30, 10, 14, 10, 14, 30, 0, 1, 0, 0, 30 };
    var out: [counts.len]u16 = undefined;
    try testing.expect(smooth(counts.len, &counts, &out));
    const expected = [_]u16{ 6, 6, 6, 6, 40, 0, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 2, 2, 2, 2, 2, 30, 12, 12, 12, 12, 30, 1, 1, 1, 1, 30 };
    try testing.expectEqualSlices(u16, &expected, &out);
}

test "fewer than 16 symbols, or strides of fewer than 4, leave the counts as they are" {
    // 15 symbols occur: no change. With a 16th, the stride takes its mean.
    const few = [_]u16{ 5, 6, 4, 7, 5, 6, 4, 7, 5, 6, 4, 7, 5, 6, 4, 0 };
    var out: [few.len]u16 = undefined;
    try testing.expect(!smooth(few.len, &few, &out));
    try testing.expectEqualSlices(u16, &few, &out);
    var enough = few;
    enough[few.len - 1] = 7;
    try testing.expect(smooth(enough.len, &enough, &out));
    // Each count lies past 4 of the one before, so each stride holds one count.
    const apart = [_]u16{ 1, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 10 };
    var apart_out: [apart.len]u16 = undefined;
    try testing.expect(!smooth(apart.len, &apart, &apart_out));
}

test "a code built from smoothed counts gives each symbol a count names a code" {
    // Seeded counts, some zero: the code is the smoothed counts' code, and no symbol that occurs
    // lacks a length.
    var generator = codec.testing.split.Generator.init(constants.literal_alphabet_len);
    for (0..seeds) |_| {
        var counts: [constants.literal_alphabet_len]u16 = @splat(0);
        const spread = 1 + generator.below(spread_max);
        for (counts[0..seeded_symbols]) |*count| count.* = @intCast(generator.below(spread));
        // A code needs a symbol.
        counts[0] += 1;
        var code: encoder_prefix.Code(constants.literal_alphabet_len) = undefined;
        build(counts.len, &counts, &code);
        var smoothed: [constants.literal_alphabet_len]u16 = undefined;
        var expected: encoder_prefix.Code(constants.literal_alphabet_len) = undefined;
        if (smooth(counts.len, &counts, &smoothed)) {
            encoder_prefix.build(counts.len, &smoothed, &expected);
        } else {
            encoder_prefix.build(counts.len, &counts, &expected);
        }
        try testing.expectEqualSlices(u8, &expected.lengths, &code.lengths);
        for (counts, code.lengths) |count, len| {
            if (count > 0) try testing.expect(len > 0 or code.simple_count == 1);
        }
    }
}

const seeds = 64;
const seeded_symbols = 64;
/// The counts' spread, up to 3 times the tolerance: near counts smooth well, far ones do not.
const spread_max = 3 * level5.smooth_tolerance;
