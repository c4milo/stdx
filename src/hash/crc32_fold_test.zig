//! Tests for the folding of variants/crc32_fold.zig, on any CPU. A carry-less multiplication
//! written as a loop over bits stands in for PCLMULQDQ, VPCLMULQDQ and PMULL, so the folding's own
//! logic, the multipliers, the lanes of each register width, the register's entry and the final
//! reduction, is held to the table path whatever instructions the host has.

const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const crc32_table = @import("crc32_table.zig");
const crc32_fold = @import("variants/crc32_fold.zig");
const Lane = crc32_fold.Lane;

/// The 64-bit halves of a lane.
const halves = @typeInfo(Lane).vector.len;

/// The lanes of a 256-bit and of a 512-bit register, and the registers a wide step folds.
const width_256 = 2;
const width_512 = 4;
const registers_per_step = 4;

/// The longest input the test takes, and the alignments it starts at.
const len_max = 1024;
const offsets = constants.crc32_lane_len;

/// The lengths past which the test steps by more than one octet, and by how much.
const every_len_max = 300;
const len_stride = 37;

/// The linear congruential generator the sample is drawn from, as C's rand() is often written.
const sample_multiplier: u32 = 1103515245;
const sample_increment: u32 = 12345;
const sample_shift = 16;

/// The carry-less product of two 64-bit values, bit by bit.
fn carryless(a: u64, b: u64) u128 {
    var product: u128 = 0;
    for (0..@bitSizeOf(u64)) |bit| {
        if (b >> @intCast(bit) & 1 != 0) product ^= @as(u128, a) << @intCast(bit);
    }
    return product;
}

/// The product of the chosen half of each 128-bit lane of `lanes` and of `by`, as PCLMULQDQ
/// computes it lane by lane: 0 takes the first halves, 1 the last.
fn multiply_lanes(comptime Vector: type, lanes: Vector, by: Vector, comptime half: usize) Vector {
    const len = @typeInfo(Vector).vector.len;
    var result: [len]u64 = undefined;
    inline for (0..len / halves) |lane| {
        const product = carryless(lanes[halves * lane + half], by[halves * lane + half]);
        result[halves * lane] = @truncate(product);
        result[halves * lane + 1] = @truncate(product >> @bitSizeOf(u64));
    }
    return result;
}

fn Software(comptime Vector: type) type {
    return struct {
        pub fn first_halves(lanes: Vector, by: Vector) Vector {
            return multiply_lanes(Vector, lanes, by, 0);
        }

        pub fn last_halves(lanes: Vector, by: Vector) Vector {
            return multiply_lanes(Vector, lanes, by, 1);
        }
    };
}

const Short = crc32_fold.Folding(Software(Lane), constants.crc32_lanes_pclmul, crc32_table.update_register);
const Eight = crc32_fold.Folding(Software(Lane), constants.crc32_lanes_vpclmul, crc32_table.update_register);
const Sixteen = crc32_fold.Folding(Software(Lane), constants.crc32_lanes_avx512, crc32_table.update_register);
const Two = crc32_fold.Folding(Software(Lane), width_256, crc32_table.update_register);
const Four = crc32_fold.Folding(Software(Lane), width_512, crc32_table.update_register);
const Wide256 = crc32_fold.WideFolding(Software(@Vector(width_256 * halves, u64)), width_256, registers_per_step, Two, Short);
const Wide512 = crc32_fold.WideFolding(Software(@Vector(width_512 * halves, u64)), width_512, registers_per_step, Four, Short);

/// A fixed, irregular input.
fn sample() [len_max + offsets]u8 {
    var octets: [len_max + offsets]u8 = undefined;
    var value: u32 = constants.crc32_polynomial;
    for (&octets) |*octet| {
        value = value *% sample_multiplier +% sample_increment;
        octet.* = @truncate(value >> sample_shift);
    }
    return octets;
}

test "folding over 4, 8 and 16 lanes, and over 256-bit and 512-bit registers, equals the table" {
    const octets = sample();
    const updates = .{ Short.update, Eight.update, Sixteen.update, Wide256.update, Wide512.update };
    for (0..offsets) |offset| {
        var len: usize = 0;
        while (len <= len_max) : (len += if (len < every_len_max) 1 else len_stride) {
            const input = octets[offset..][0..len];
            const register: u32 = @truncate(len *% 0x9e3779b9);
            const wanted = crc32_table.update_register(register, input);
            inline for (updates) |update| try testing.expectEqual(wanted, update(register, input));
        }
    }
}

test "x_power_mod gives x^n modulo the polynomial" {
    // x^31 needs no reduction; x^32 is the polynomial's terms below x^32.
    try testing.expectEqual(0x8000_0000, crc32_fold.x_power_mod(31));
    try testing.expectEqual(constants.crc32_polynomial, crc32_fold.x_power_mod(32));
    // x^33 is x times x^32: the polynomial's low terms shifted once, with no x^32 term to reduce.
    try testing.expectEqual(0x0982_3b6e, crc32_fold.x_power_mod(33));
}
