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

/// The comptime branches every `x_power_mod` evaluated together may take: one per power of x, for
/// every multiplier of a variant object, with room to spare.
const x_power_quota = 4_000_000;

/// x^n modulo the CRC polynomial, bit d the coefficient of x^d.
pub fn x_power_mod(comptime n: usize) u32 {
    @setEvalBranchQuota(x_power_quota);
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
fn multiplier(comptime n: usize) u64 {
    return @bitReverse(@as(u64, x_power_mod(n - 1)));
}

/// The multipliers that move a lane forward by `bits`: its first half by bits + 64, its last by
/// bits.
fn fold_by(comptime bits: usize) Lane {
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
        pub const step_len = lane_count * constants.crc32_lane_len;
        const fold_all = fold_by(lane_count * lane_bits);
        const fold_one = fold_by(lane_bits);

        fn fold(lane: Lane, by: Lane, next: Lane) Lane {
            return Multiply.first_halves(lane, by) ^ Multiply.last_halves(lane, by) ^ next;
        }

        /// The lanes of a first step, with `register` entered as the first 32 bits of the
        /// message, XORed in.
        pub fn start(register: u32, step: *const [step_len]u8) [lane_count]Lane {
            var lanes: [lane_count]Lane = undefined;
            for (&lanes, 0..) |*lane, index| lane.* = load(step, index * constants.crc32_lane_len);
            lanes[0] ^= Lane{ register, 0 };
            return lanes;
        }

        /// Folds every lane forward over one more step.
        pub fn fold_step(lanes: *[lane_count]Lane, step: *const [step_len]u8) void {
            inline for (lanes, 0..) |*lane, index| {
                lane.* = fold(lane.*, fold_all, load(step, index * constants.crc32_lane_len));
            }
        }

        /// The lanes folded into one, and then over each whole lane of `rest`. Returns the lane
        /// and the octets of `rest` it did not take.
        fn fold_rest(lanes: [lane_count]Lane, rest: []const u8) struct { Lane, []const u8 } {
            // Each lane folds straight to the last by its own distance, so the multiplications
            // do not wait on one another.
            var lane = lanes[lane_count - 1];
            inline for (lanes[0 .. lane_count - 1], 0..) |earlier, index| {
                const by = comptime fold_by((lane_count - 1 - index) * lane_bits);
                lane ^= Multiply.first_halves(earlier, by) ^ Multiply.last_halves(earlier, by);
            }
            var position: usize = 0;
            while (rest.len - position >= constants.crc32_lane_len) : (position += constants.crc32_lane_len) {
                lane = fold(lane, fold_one, load(rest, position));
            }
            assert(rest.len - position < constants.crc32_lane_len);
            return .{ lane, rest[position..] };
        }

        /// The CRC register the lanes stand for, after the octets of `rest`.
        pub fn finish_lanes(lanes: [lane_count]Lane, rest: []const u8) u32 {
            const lane, const tail = fold_rest(lanes, rest);
            // The lane is a message of 16 octets whose CRC, from a zero register, is the register
            // so far.
            const lane_octets: [constants.crc32_lane_len]u8 = @bitCast(lane);
            return finish(finish(0, &lane_octets), tail);
        }

        /// The CRC register after the octets, from `register`, as crc32_table.update_register
        /// gives it.
        pub fn update(register: u32, octets: []const u8) u32 {
            if (octets.len < step_len) return finish(register, octets);
            var lanes = start(register, octets[0..step_len]);
            var position: usize = step_len;
            while (octets.len - position >= step_len) : (position += step_len) {
                // One bounds check per step rather than one per lane.
                fold_step(&lanes, octets[position..][0..step_len]);
            }
            return finish_lanes(lanes, octets[position..]);
        }
    };
}

/// Folding with registers of `width` lanes: 256-bit registers of two lanes, or 512-bit ones of four,
/// each carry-less multiplication taking every lane of its register at once. `register_count`
/// registers fold per step. At the end the registers fold into one, which folds on over each whole
/// register of what is left; `Narrow`, a `Folding` of `width` lanes, folds that register's lanes
/// into one and takes the tail, and `Short` takes an input too short for one step.
pub fn WideFolding(
    comptime MultiplyWide: type,
    comptime width: usize,
    comptime register_count: usize,
    comptime Narrow: type,
    comptime Short: type,
) type {
    const Wide = @Vector(width * @typeInfo(Lane).vector.len, u64);
    const register_len = width * constants.crc32_lane_len;
    const register_bits = width * lane_bits;
    return struct {
        pub const step_len = register_count * register_len;

        /// The multipliers that move every lane of a register forward by `bits`.
        fn wide_fold_by(comptime bits: usize) Wide {
            return @bitCast([_]Lane{fold_by(bits)} ** width);
        }

        fn wide_fold(wide: Wide, comptime by: Wide, next: Wide) Wide {
            return MultiplyWide.first_halves(wide, by) ^ MultiplyWide.last_halves(wide, by) ^ next;
        }

        fn load_wide(octets: []const u8, at: usize) Wide {
            return @bitCast(octets[at..][0..register_len].*);
        }

        /// The CRC register after the octets, from `register`, as crc32_table.update_register
        /// gives it.
        pub fn update(register: u32, octets: []const u8) u32 {
            if (octets.len < step_len) return Short.update(register, octets);
            var registers: [register_count]Wide = undefined;
            for (&registers, 0..) |*wide, index| wide.* = load_wide(octets, index * register_len);
            // The register enters as the first 32 bits of the message, XORed in.
            registers[0][0] ^= register;
            var position: usize = step_len;
            while (octets.len - position >= step_len) : (position += step_len) {
                const step = octets[position..][0..step_len];
                inline for (&registers, 0..) |*wide, index| {
                    wide.* = wide_fold(wide.*, comptime wide_fold_by(register_count * register_bits), load_wide(step, index * register_len));
                }
            }
            // Each register folds straight to the last by its own distance, then the last folds
            // on over whole registers of the rest.
            var last = registers[register_count - 1];
            inline for (registers[0 .. register_count - 1], 0..) |earlier, index| {
                last = wide_fold(earlier, comptime wide_fold_by((register_count - 1 - index) * register_bits), last);
            }
            while (octets.len - position >= register_len) : (position += register_len) {
                last = wide_fold(last, comptime wide_fold_by(register_bits), load_wide(octets, position));
            }
            const lanes: [width]Lane = @bitCast(last);
            return Narrow.finish_lanes(lanes, octets[position..]);
        }
    };
}
