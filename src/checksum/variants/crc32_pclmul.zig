//! CRC-32 by carry-less multiplication: the x86-64 variant object of decision 21, compiled with
//! SSE4.1 and PCLMULQDQ whatever the module's target, and called only when `Features.pclmul` is
//! set.
//!
//! The octets are read as four 128-bit lanes. Each step folds every lane forward by 512 bits: a
//! lane holding the polynomial l·x^64 + h (l its first 64 bits, h its last, in the reflected order
//! of RFC 1952 §8) becomes l·x^576 + h·x^512 reduced modulo the CRC polynomial, each product one
//! carry-less multiplication, XORed into the lane 64 octets on. The four lanes then fold into one,
//! 16 octets at a time, and the table path reduces the last lane and takes the tail.
//!
//! Every multiplier is x^n mod P, derived here at comptime from the polynomial: nothing is copied
//! from another implementation (decision 9). The fuzzer and the tests hold this path to the table
//! path on every input.

const std = @import("std");
const constants = @import("../constants.zig");
const crc32_table = @import("../crc32_table.zig");

/// A 128-bit lane as its two 64-bit halves, the operands of one carry-less multiplication each.
const Lane = @Vector(constants.crc32_lane_len / @sizeOf(u64), u64);

/// The bits one lane holds, and the lanes folded per step.
const lane_bits = constants.crc32_lane_len * @bitSizeOf(u8);
const lanes_per_fold = constants.crc32_fold_len / constants.crc32_lane_len;

/// The coefficient of x^31, the top bit of a 32-bit polynomial.
const top_bit: u32 = 0x8000_0000;

/// x^n modulo the CRC polynomial, bit d the coefficient of x^d.
fn x_power_mod(n: usize) u32 {
    // The largest power is x^575, a few branches per bit.
    @setEvalBranchQuota(constants.crc32_fold_len * lane_bits);
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

const fold_four = fold_by(lanes_per_fold * lane_bits);
const fold_one = fold_by(lane_bits);

fn product_of_first_halves(lane: Lane, by: Lane) Lane {
    return asm ("pclmulqdq $0x00, %[by], %[lane]"
        : [out] "=x" (-> Lane),
        : [lane] "0" (lane),
          [by] "x" (by),
    );
}

fn product_of_last_halves(lane: Lane, by: Lane) Lane {
    return asm ("pclmulqdq $0x11, %[by], %[lane]"
        : [out] "=x" (-> Lane),
        : [lane] "0" (lane),
          [by] "x" (by),
    );
}

fn fold(lane: Lane, by: Lane, next: Lane) Lane {
    return product_of_first_halves(lane, by) ^ product_of_last_halves(lane, by) ^ next;
}

fn load(octets: []const u8, at: usize) Lane {
    return @bitCast(octets[at..][0..constants.crc32_lane_len].*);
}

/// The CRC register after `len` octets from `register`, as crc32_table.update_register gives it.
export fn stdx_checksum_crc32_pclmul(register: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    const octets = octets_pointer[0..len];
    if (len < constants.crc32_fold_len) return crc32_table.update_register(register, octets);
    var lanes: [lanes_per_fold]Lane = undefined;
    for (&lanes, 0..) |*lane, index| lane.* = load(octets, index * constants.crc32_lane_len);
    // The register enters as the first 32 bits of the message, XORed in.
    lanes[0] ^= Lane{ register, 0 };
    var position: usize = constants.crc32_fold_len;
    while (len - position >= constants.crc32_fold_len) : (position += constants.crc32_fold_len) {
        for (&lanes, 0..) |*lane, index| {
            lane.* = fold(lane.*, fold_four, load(octets, position + index * constants.crc32_lane_len));
        }
    }
    var lane = lanes[0];
    for (lanes[1..]) |next| lane = fold(lane, fold_one, next);
    while (len - position >= constants.crc32_lane_len) : (position += constants.crc32_lane_len) {
        lane = fold(lane, fold_one, load(octets, position));
    }
    // The lane is a message of 16 octets whose CRC, from a zero register, is the register so far.
    const lane_octets: [constants.crc32_lane_len]u8 = @bitCast(lane);
    const folded = crc32_table.update_register(0, &lane_octets);
    return crc32_table.update_register(folded, octets[position..]);
}
