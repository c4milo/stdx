//! Adler-32 in blocks of `lanes` octets, one octet per vector lane: the module's vector path at the
//! target's width, and the body of the AVX2 variant object at 32 octets (decision 21).
//!
//! RFC 1950 §2.2 defines s1 as 1 plus the sum of the octets, and s2 as the sum of every value s1
//! takes. Over a run of blocks, each lane keeps two sums: `sums`, the octets it has seen, and
//! `sums_before`, the value `sums` had before each block, added up. After the run, with s1 and s2
//! as they were before it:
//!
//! - s1 gains the octets: the lanes of `sums`, added.
//! - s2 gains `lanes` times s1 per block; `lanes` times the lanes of `sums_before`, added, which is
//!   what the earlier blocks of the run added to s1 before each block; and each lane of `sums`
//!   times its weight, `lanes` for a block's first octet down to 1 for its last, which is how
//!   many times an octet enters s2 within its own block.
//!
//! A block costs two vector additions and no multiplication. A run stays within RFC 1950 §8.2's
//! bound on octets between reductions, which also keeps every lane within 32 bits.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const adler32_scalar = @import("adler32_scalar.zig");

/// The Adler-32 value after the octets, from `adler`, in blocks of `lanes` octets. The octets
/// after the last whole block take the scalar path.
pub fn update(comptime lanes: usize, adler: u32, octets: []const u8) u32 {
    const Wide = @Vector(lanes, u32);
    const Long = @Vector(lanes, u64);
    const weights: Wide = comptime descending(lanes);
    const blocks_per_run = constants.adler32_deferral_len / lanes;
    comptime assert(blocks_per_run > 0);
    var s1: u64 = adler & std.math.maxInt(u16);
    var s2: u64 = adler >> @bitSizeOf(u16);
    assert(s1 < constants.adler32_base and s2 < constants.adler32_base);
    var rest = octets;
    while (rest.len >= lanes) {
        const blocks = @min(rest.len / lanes, blocks_per_run);
        var sums: Wide = @splat(0);
        var sums_before: Wide = @splat(0);
        for (0..blocks) |block| {
            const block_octets: @Vector(lanes, u8) = rest[block * lanes ..][0..lanes].*;
            sums_before += sums;
            sums += @as(Wide, block_octets);
        }
        const before = @reduce(.Add, @as(Long, sums_before));
        s2 += lanes * (blocks * s1 + before) + @reduce(.Add, @as(Long, sums * weights));
        s1 += @reduce(.Add, @as(Long, sums));
        s1 %= constants.adler32_base;
        s2 %= constants.adler32_base;
        rest = rest[blocks * lanes ..];
    }
    const blocks_value: u32 = @intCast((s2 << @bitSizeOf(u16)) | s1);
    return adler32_scalar.update(blocks_value, rest);
}

/// The weight of each lane: `lanes` for a block's first octet down to 1 for its last.
fn descending(comptime lanes: usize) @Vector(lanes, u32) {
    var weights: [lanes]u32 = undefined;
    for (&weights, 0..) |*weight, index| weight.* = @intCast(lanes - index);
    return weights;
}
