//! CRC-32 by folding with carry-less multiplication, for every variant object that has it: x86-64's
//! PCLMULQDQ and aarch64's PMULL. Each object supplies the two multiplications; this file holds
//! the rest.
//!
//! The octets are read as `lane_count` 128-bit lanes. Each step folds every lane forward by
//! `lane_count` lanes: a lane holding the polynomial l·x^64 + h (l its first 64 bits, h its last,
//! in the reflected order of RFC 1952 §8) becomes l·x^(n+64) + h·x^n reduced modulo the CRC
//! polynomial, each product one carry-less multiplication, XORed into the lane n bits on. The lanes
//! then fold into one, 16 octets at a time, and the object's `finish` reduces the last lane and
//! takes the tail.
//!
//! Every multiplier is x^n mod P, derived here at comptime from the polynomial: nothing is copied
//! from another implementation (decision 9). The tests and the fuzzer hold every path to the table
//! path.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

/// A 128-bit lane as its two 64-bit halves, the operands of one carry-less multiplication each.
pub const Lane = @Vector(constants.crc32_lane_len / @sizeOf(u64), u64);

/// The bits one lane holds.
const lane_bits = constants.crc32_lane_len * @bitSizeOf(u8);

/// The coefficient of x^31, the top bit of a 32-bit polynomial.
const top_bit: u32 = 0x8000_0000;

/// x^n modulo the CRC polynomial, bit d the coefficient of x^d.
fn x_power_mod(n: usize) u32 {
    // A few branches per power of x, for the largest fold the objects use.
    @setEvalBranchQuota(constants.crc32_lanes_max * lane_bits * constants.crc32_slice_len);
    var remainder: u32 = 1;
    for (0..n) |_| {
        const carry = remainder & top_bit != 0;
        remainder <<= 1;
        if (carry) remainder ^= constants.crc32_polynomial;
    }
    return remainder;
}

/// The 64-bit operand that multiplies a reflected 64-bit half by x^n modulo the polynomial, placed
/// so the 128-bit product lines up with a lane. It is x·(x^(n-1) mod P), congruent to x^n, in the
/// reflected order.
fn multiplier(n: usize) u64 {
    return @bitReverse(@as(u64, x_power_mod(n - 1)));
}

/// The multipliers that move a lane forward by `bits`: its first half by bits + 64, its last by
/// bits.
fn fold_by(bits: usize) Lane {
    return .{ multiplier(bits + @bitSizeOf(u64)), multiplier(bits) };
}

fn load(octets: []const u8, at: usize) Lane {
    return @bitCast(octets[at..][0..constants.crc32_lane_len].*);
}

/// Folding over `lane_count` lanes with `Multiply`'s two carry-less multiplications, which take
/// the lanes' first halves and their last halves; `finish(register, octets)` is the object's
/// fastest path for short inputs, and takes the last lane and the tail.
pub fn Folding(
    comptime Multiply: type,
    comptime lane_count: usize,
    comptime finish: fn (u32, []const u8) u32,
) type {
    comptime assert(lane_count >= 1 and lane_count <= constants.crc32_lanes_max);
    return struct {
        const step_len = lane_count * constants.crc32_lane_len;
        const fold_all = fold_by(lane_count * lane_bits);
        const fold_one = fold_by(lane_bits);

        fn fold(lane: Lane, by: Lane, next: Lane) Lane {
            return Multiply.first_halves(lane, by) ^ Multiply.last_halves(lane, by) ^ next;
        }

        /// The CRC register after the octets, from `register`, as crc32_table.update_register
        /// gives it.
        pub fn update(register: u32, octets: []const u8) u32 {
            if (octets.len < step_len) return finish(register, octets);
            var lanes: [lane_count]Lane = undefined;
            for (&lanes, 0..) |*lane, index| lane.* = load(octets, index * constants.crc32_lane_len);
            // The register enters as the first 32 bits of the message, XORed in.
            lanes[0] ^= Lane{ register, 0 };
            var position: usize = step_len;
            while (octets.len - position >= step_len) : (position += step_len) {
                // One bounds check per step rather than one per lane.
                const step = octets[position..][0..step_len];
                inline for (&lanes, 0..) |*lane, index| {
                    lane.* = fold(lane.*, fold_all, load(step, index * constants.crc32_lane_len));
                }
            }
            var lane = lanes[0];
            for (lanes[1..]) |next| lane = fold(lane, fold_one, next);
            while (octets.len - position >= constants.crc32_lane_len) : (position += constants.crc32_lane_len) {
                lane = fold(lane, fold_one, load(octets, position));
            }
            assert(octets.len - position < constants.crc32_lane_len);
            // The lane is a message of 16 octets whose CRC, from a zero register, is the register
            // so far.
            const lane_octets: [constants.crc32_lane_len]u8 = @bitCast(lane);
            return finish(finish(0, &lane_octets), octets[position..]);
        }
    };
}
