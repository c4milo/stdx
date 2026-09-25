//! Adler-32 by dot products, for every variant object with an instruction that multiplies octets
//! in groups of four and adds each group's products into a 32-bit lane: Arm's UDOT, x86's VPDPBUSD,
//! or VPMADDUBSW followed by VPMADDWD. Each object supplies `Dot`; this file holds the rest.
//!
//! A block is `register_count` registers of `Dot.register_len` octets, `block_len` in all. The path
//! keeps three kinds of vectors of 32-bit lanes:
//!
//! - `sums`, every octet so far added up; each block's octets are added up first, by a short chain
//!   of `Dot.sums` that the next block does not wait on;
//! - `sums_before`, the value `sums` had before each block, added up;
//! - `weighted`, one per register, the dot products of its octets with their weights: `block_len`
//!   for a block's first octet down to 1 for its last, less `weight_shift`, which centers them on
//!   zero when `Dot` takes signed weights, so every weight fits one octet.
//!
//! After a run of blocks, with s1 and s2 as they were before it (RFC 1950 §2.2): s1 gains the sums;
//! s2 gains `block_len` times s1 per block, `block_len` times the sums before each block, and the
//! weighted sums with `weight_shift` times the run's octets added back.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

/// Signed weights are shifted down by half the block length, which centers them on zero.
const center_divisor = 2;

/// The sum 0 + 1 + … + (B − 1), which bounds how often a lane of `sums_before` gains a lane of
/// `sums`, is at most B² over this.
const triangle_divisor = 2;

/// Adler-32 over `Dot`'s registers, `register_count` to a block, with `Next` for the octets after
/// the last whole block. `Dot` has:
/// - `register_len`, the octets of one register;
/// - `lane_octets`, the most octets `sums` adds into one 32-bit lane of one register;
/// - `signed_weights`, true when `weighted` takes each weight as a signed octet, and `weight_max`,
///   the largest weight it takes, signed or not;
/// - `weighted(accumulator, octets, weights)`, adding into each 32-bit lane the products of its four
///   octets with their weights;
/// - `sums(accumulator, octets)`, adding the octets into the lanes, in any grouping.
pub fn Kernel(comptime Dot: type, comptime register_count: usize, comptime Next: type) type {
    const register_len = Dot.register_len;
    const Octets = @Vector(register_len, u8);
    const Lanes = @Vector(register_len / @sizeOf(u32), u32);
    return struct {
        pub const block_len = register_count * register_len;

        /// What each weight is less than the true one, `block_len` down to 1.
        pub const weight_shift = if (Dot.signed_weights) block_len / center_divisor else 0;

        const weights: [register_count]Octets = block_weights(register_count, register_len, weight_shift);

        pub const blocks_per_run_max = run_blocks_max(Dot, register_count);

        comptime {
            // The largest weight fits what `Dot` takes, and a signed weight's most negative, 1 less
            // `weight_shift`, fits a signed octet.
            assert(block_len - weight_shift <= Dot.weight_max);
            assert(!Dot.signed_weights or weight_shift - 1 <= -@as(isize, std.math.minInt(i8)));
            assert(before_fits(Dot, register_count, blocks_per_run_max));
            assert(weighted_fits(Dot, register_count, blocks_per_run_max));
        }

        /// The Adler-32 value after the octets, from `adler`. The octets after the last whole
        /// block take `Next`.
        pub fn update(adler: u32, octets: []const u8) u32 {
            var s1: u64 = adler & std.math.maxInt(u16);
            var s2: u64 = adler >> @bitSizeOf(u16);
            assert(s1 < constants.adler32_base and s2 < constants.adler32_base);
            const whole_len = octets.len - octets.len % block_len;
            const blocks = std.mem.bytesAsSlice([block_len]u8, octets[0..whole_len]);
            var start: usize = 0;
            while (start < blocks.len) {
                const run = blocks[start..@min(blocks.len, start + blocks_per_run_max)];
                const run_s1, const run_s2 = run_sums(run);
                s2 += block_len * run.len * s1 + run_s2;
                s1 += run_s1;
                s1 %= constants.adler32_base;
                s2 %= constants.adler32_base;
                start += run.len;
            }
            const blocks_value: u32 = @intCast((s2 << @bitSizeOf(u16)) | s1);
            return Next.update(blocks_value, octets[whole_len..]);
        }

        /// What one run adds to s1, and to s2 beyond `block_len` times s1 per block.
        fn run_sums(run: []const [block_len]u8) struct { u64, u64 } {
            var sums: Lanes = @splat(0);
            var sums_before: Lanes = @splat(0);
            var weighted: [register_count]Lanes = @splat(@splat(0));
            for (run) |*block| {
                // No lane can overflow within a run of `blocks_per_run_max` blocks, so the
                // additions wrap rather than check.
                sums_before +%= sums;
                var block_sums: Lanes = @splat(0);
                inline for (0..register_count) |register| {
                    const register_octets: Octets = block[register * register_len ..][0..register_len].*;
                    block_sums = Dot.sums(block_sums, register_octets);
                    weighted[register] = Dot.weighted(weighted[register], register_octets, weights[register]);
                }
                sums +%= block_sums;
            }
            var all_weighted = weighted[0];
            inline for (weighted[1..]) |lanes| all_weighted +%= lanes;
            const run_s1 = reduce(Lanes, sums);
            const before: i64 = @intCast(reduce(Lanes, sums_before));
            const len: i64 = block_len;
            const shift: i64 = weight_shift;
            const weighted_sum = reduce_weighted(Lanes, Dot.signed_weights, all_weighted);
            const run_s2 = len * before + weighted_sum + shift * @as(i64, @intCast(run_s1));
            return .{ run_s1, @intCast(run_s2) };
        }
    };
}

fn reduce(comptime Lanes: type, lanes: Lanes) u64 {
    return @reduce(.Add, @as(@Vector(@typeInfo(Lanes).vector.len, u64), lanes));
}

/// The weighted lanes added up, each read as a signed 32-bit value when the weights are signed.
fn reduce_weighted(comptime Lanes: type, comptime signed: bool, lanes: Lanes) i64 {
    const len = @typeInfo(Lanes).vector.len;
    if (!signed) return @intCast(reduce(Lanes, lanes));
    const signed_lanes: @Vector(len, i32) = @bitCast(lanes);
    return @reduce(.Add, @as(@Vector(len, i64), signed_lanes));
}

/// The weights of each register of a block: `block_len` for its first octet down to 1 for its last,
/// less `shift`, each as the octet `Dot.weighted` takes, signed or not.
fn block_weights(comptime register_count: usize, comptime register_len: usize, comptime shift: usize) [register_count]@Vector(register_len, u8) {
    const block_len = register_count * register_len;
    var result: [register_count][register_len]u8 = undefined;
    for (0..register_count) |register| {
        for (0..register_len) |index| {
            const weight: isize = @as(isize, @intCast(block_len - register * register_len - index)) - @as(isize, @intCast(shift));
            result[register][index] = @bitCast(@as(i8, @truncate(weight)));
        }
    }
    var vectors: [register_count]@Vector(register_len, u8) = undefined;
    for (&vectors, result) |*vector, octets| vector.* = octets;
    return vectors;
}

/// The largest power of two of blocks a run may take, so that no 32-bit lane overflows.
fn run_blocks_max(comptime Dot: type, comptime register_count: usize) usize {
    var blocks: usize = 1;
    while (before_fits(Dot, register_count, blocks << 1) and weighted_fits(Dot, register_count, blocks << 1)) blocks <<= 1;
    return blocks;
}

/// True when a lane of `sums_before` stays within 32 bits over a run of `blocks` blocks: a lane of
/// `sums` gains at most `lane_octets` octets of 255 from each register per block.
fn before_fits(comptime Dot: type, comptime register_count: usize, comptime blocks: usize) bool {
    const gain = register_count * Dot.lane_octets * std.math.maxInt(u8);
    return gain * blocks * blocks / triangle_divisor <= std.math.maxInt(u32);
}

/// True when the registers' `weighted` lanes, added together, stay within 31 bits over a run of
/// `blocks` blocks: each gains at most four octets of 255 times `weight_max` per block.
fn weighted_fits(comptime Dot: type, comptime register_count: usize, comptime blocks: usize) bool {
    const gain = register_count * @sizeOf(u32) * std.math.maxInt(u8) * Dot.weight_max;
    return gain * blocks <= std.math.maxInt(i32);
}
