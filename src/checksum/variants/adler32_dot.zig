//! Adler-32 by dot products, for every variant object with an instruction that multiplies octets
//! in groups of four and adds each group's products into a 32-bit lane: Arm's UDOT, x86's VPDPBUSD,
//! or VPMADDUBSW followed by VPMADDWD. Each object supplies `Dot`; this file holds the rest.
//!
//! A block is `register_count` registers of `Dot.register_len` octets. For each register the path
//! keeps three vectors of 32-bit lanes:
//!
//! - `sums`, the register's octets added up, by a dot product with ones or by `Dot.sums`;
//! - `sums_before`, the value `sums` had before each block, added up;
//! - `weighted`, the dot product of the register's octets with the weights `register_len` down to
//!   1, the same for every register, so each weight fits the signed octet VPMADDUBSW takes.
//!
//! After a run of blocks, with s1 and s2 as they were before it (RFC 1950 §2.2): s1 gains the sums;
//! s2 gains `block_len` times s1 per block, `block_len` times the sums before each block, the
//! weighted sums, and for each register the octets of the registers after it in the block times
//! `register_len`, since its weights count from its own end and not from the block's.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

/// The most a 32-bit lane of `sums` gains per block: eight octets of 255, from VPSADBW.
const lane_gain_max = @sizeOf(u64) * std.math.maxInt(u8);

/// The sum 0 + 1 + … + (B − 1), which bounds how often a lane of `sums_before` gains a lane of
/// `sums`, is at most B² over this.
const triangle_divisor = 2;

/// Adler-32 over `Dot`'s registers, `register_count` to a block, with `Next` for the octets after
/// the last whole block. `Dot` has:
/// - `register_len`, the octets of one register;
/// - `weighted(accumulator, octets, weights)`, adding into each 32-bit lane the products of its four
///   octets with their weights;
/// - `sums(accumulator, octets)`, adding the octets into the lanes, in any grouping.
pub fn Kernel(comptime Dot: type, comptime register_count: usize, comptime Next: type) type {
    const register_len = Dot.register_len;
    const Octets = @Vector(register_len, u8);
    const Lanes = @Vector(register_len / @sizeOf(u32), u32);
    return struct {
        pub const block_len = register_count * register_len;
        const weights: Octets = descending(register_len);

        /// The blocks one run takes: few enough that no 32-bit lane overflows once the registers'
        /// lanes are added together. A lane of `sums_before` gains at most a lane of `sums` per
        /// block, which gains at most `lane_gain_max`.
        pub const blocks_per_run_max = run_blocks_max(register_count);

        comptime {
            assert(before_fits(register_count, blocks_per_run_max));
            // A lane of `weighted` gains four octets of 255 times weights of at most `register_len`.
            const weighted_gain_max = @sizeOf(u32) * std.math.maxInt(u8) * register_len;
            assert(register_count * weighted_gain_max * blocks_per_run_max <= std.math.maxInt(u32));
        }

        /// The Adler-32 value after the octets, from `adler`. The octets after the last whole
        /// block take the scalar path.
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
            var sums: [register_count]Lanes = @splat(@splat(0));
            var sums_before: [register_count]Lanes = @splat(@splat(0));
            var weighted: [register_count]Lanes = @splat(@splat(0));
            for (run) |*block| {
                inline for (0..register_count) |register| {
                    const register_octets: Octets = block[register * register_len ..][0..register_len].*;
                    // No lane can overflow within a run of `blocks_per_run_max` blocks, so the
                    // additions wrap rather than check.
                    sums_before[register] +%= sums[register];
                    sums[register] = Dot.sums(sums[register], register_octets);
                    weighted[register] = Dot.weighted(weighted[register], register_octets, weights);
                }
            }
            return finish_run(register_count, register_len, Lanes, sums, sums_before, weighted);
        }
    };
}

/// The largest power of two of blocks a run of `register_count` registers per block may take, so
/// that no 32-bit lane overflows once the registers' lanes are added together. A lane of
/// `sums_before` gains at most a lane of `sums` per block, which gains at most `lane_gain_max`.
fn run_blocks_max(comptime register_count: usize) usize {
    var blocks: usize = 1;
    while (before_fits(register_count, blocks << 1)) blocks <<= 1;
    return blocks;
}

/// True when the registers' lanes of `sums_before`, added together, stay within 32 bits over a run
/// of `blocks` blocks.
fn before_fits(comptime register_count: usize, comptime blocks: usize) bool {
    return register_count * lane_gain_max * blocks * blocks / triangle_divisor <= std.math.maxInt(u32);
}

/// The weights of a register: `len` for its first octet down to 1 for its last.
fn descending(comptime len: usize) @Vector(len, u8) {
    var result: [len]u8 = undefined;
    for (&result, 0..) |*weight, index| weight.* = @intCast(len - index);
    return result;
}

fn reduce(comptime Lanes: type, lanes: Lanes) u64 {
    return @reduce(.Add, @as(@Vector(@typeInfo(Lanes).vector.len, u64), lanes));
}

/// What one run adds to s1, and to s2 beyond `block_len` times s1 per block, from each register's
/// three vectors.
fn finish_run(
    comptime register_count: usize,
    comptime register_len: usize,
    comptime Lanes: type,
    sums: [register_count]Lanes,
    sums_before: [register_count]Lanes,
    weighted: [register_count]Lanes,
) struct { u64, u64 } {
    // The registers' lanes added together, and for each register the sums of the registers before
    // it added up: the octets that each later register's weights do not count.
    var all_sums = sums[0];
    var all_before = sums_before[0];
    var all_weighted = weighted[0];
    var later = sums[0];
    inline for (1..register_count) |register| {
        all_sums +%= sums[register];
        all_before +%= sums_before[register];
        all_weighted +%= weighted[register];
        if (register + 1 < register_count) later +%= all_sums;
    }
    const offsets: u64 = if (register_count > 1) reduce(Lanes, later) else 0;
    const block_len = register_count * register_len;
    const s2 = block_len * reduce(Lanes, all_before) + reduce(Lanes, all_weighted) + register_len * offsets;
    return .{ reduce(Lanes, all_sums), s2 };
}
