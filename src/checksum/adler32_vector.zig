//! Adler-32 in blocks of `block_len` octets, one octet per vector lane: the module's vector path at
//! the target's width, and the body of the AVX2 variant object (decision 21).
//!
//! RFC 1950 §2.2 defines s1 as 1 plus the sum of the octets, and s2 as the sum of every value s1
//! takes. Over a run of blocks, the path keeps:
//!
//! - `columns`: for each position in a block, the sum of the octets at that position, in 16-bit
//!   lanes;
//! - `run_sum`: the sum of the run's octets so far, one horizontal add per block;
//! - `run_sum_before`: `run_sum` as it stood before each block, added up.
//!
//! After the run, with s1 and s2 as they were before it, s1 gains `run_sum`, and s2 gains
//! `block_len` times s1 per block, `block_len` times `run_sum_before`, and each column times its
//! weight: `block_len` for a block's first position down to 1 for its last, the number of times an
//! octet at that position enters s2 within its own block.
//!
//! A block costs one widening vector addition, one horizontal addition and two scalar additions,
//! and no multiplication. A run ends before a 16-bit column could overflow.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const adler32_scalar = @import("adler32_scalar.zig");

/// The most blocks one run takes: a column adds one octet per block, and stays within 16 bits.
const blocks_per_run_max = std.math.maxInt(u16) / std.math.maxInt(u8);

/// The Adler-32 value after the octets, from `adler`, in blocks of `block_len` octets. The octets
/// after the last whole block take the scalar path.
pub fn update(comptime block_len: usize, adler: u32, octets: []const u8) u32 {
    const Octets = @Vector(block_len, u8);
    const Columns = @Vector(block_len, u16);
    const Wide = @Vector(block_len, u32);
    const weights: Wide = comptime descending(block_len);
    // A block's sum fits the 16-bit lanes it is added in.
    comptime assert(block_len * std.math.maxInt(u8) <= std.math.maxInt(u16));
    comptime assert(block_len * block_len * std.math.maxInt(u16) <= std.math.maxInt(u32));
    var s1: u64 = adler & std.math.maxInt(u16);
    var s2: u64 = adler >> @bitSizeOf(u16);
    assert(s1 < constants.adler32_base and s2 < constants.adler32_base);
    const whole_len = octets.len - octets.len % block_len;
    const blocks = std.mem.bytesAsSlice([block_len]u8, octets[0..whole_len]);
    var start: usize = 0;
    while (start < blocks.len) {
        const run = blocks[start..@min(blocks.len, start + blocks_per_run_max)];
        var columns: Columns = @splat(0);
        var run_sum: u64 = 0;
        var run_sum_before: u64 = 0;
        for (run) |block| {
            const block_octets: Octets = block;
            const wide: Columns = block_octets;
            // No sum below can overflow: a run holds at most `blocks_per_run_max` blocks. The
            // additions wrap rather than check, since ReleaseSafe's check of a vector addition
            // costs more than the addition.
            run_sum_before +%= run_sum;
            run_sum +%= @reduce(.Add, wide);
            columns +%= wide;
        }
        // Each column is below 2^16 and each weight at most `block_len`, so the sum fits 32 bits.
        const weighted: u64 = @reduce(.Add, @as(Wide, columns) *% weights);
        s2 += block_len * (run.len * s1 + run_sum_before) + weighted;
        s1 += run_sum;
        s1 %= constants.adler32_base;
        s2 %= constants.adler32_base;
        start += run.len;
    }
    const blocks_value: u32 = @intCast((s2 << @bitSizeOf(u16)) | s1);
    return adler32_scalar.update(blocks_value, octets[whole_len..]);
}

/// The weight of each position: `block_len` for a block's first octet down to 1 for its last.
fn descending(comptime block_len: usize) @Vector(block_len, u32) {
    var weights: [block_len]u32 = undefined;
    for (&weights, 0..) |*weight, index| weight.* = @intCast(block_len - index);
    return weights;
}
