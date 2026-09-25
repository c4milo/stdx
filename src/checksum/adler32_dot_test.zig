//! Tests for the dot-product Adler-32 of variants/adler32_dot.zig, on any CPU: a dot product
//! written lane by lane stands in for UDOT, VPDPBUSD and VPMADDUBSW, so the path's own logic is
//! held to RFC 1950 §9's sample code at every register width the objects use.

const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const adler32_scalar = @import("adler32_scalar.zig");
const adler32_dot = @import("variants/adler32_dot.zig");

/// The octets each 32-bit lane of a dot product takes.
const group_len = @sizeOf(u32);

/// A dot product lane by lane, shaped as one of the objects' instructions: `signed` weights or
/// not, `weight_max` the largest, and `lane_octets` the octets `sums` adds into one lane: 4 as UDOT
/// and VPDPBUSD by ones do, or 8 into every other lane as VPSADBW does.
fn Software(comptime len: usize, comptime signed: bool, comptime max: comptime_int, comptime octets_per_lane: usize) type {
    return struct {
        pub const register_len = len;
        pub const lane_octets = octets_per_lane;
        pub const signed_weights = signed;
        pub const weight_max = max;
        const Lanes = @Vector(len / group_len, u32);

        pub fn weighted(accumulator: Lanes, octets: @Vector(len, u8), weights: @Vector(len, u8)) Lanes {
            var result: [len / group_len]u32 = accumulator;
            const octet_array: [len]u8 = octets;
            const weight_array: [len]u8 = weights;
            for (octet_array, weight_array, 0..) |octet, weight, index| {
                const value: i32 = if (signed) @as(i8, @bitCast(weight)) else weight;
                result[index / group_len] +%= @bitCast(@as(i32, octet) * value);
            }
            return result;
        }

        pub fn sums(accumulator: Lanes, octets: @Vector(len, u8)) Lanes {
            var result: [len / group_len]u32 = accumulator;
            const octet_array: [len]u8 = octets;
            for (octet_array, 0..) |octet, index| {
                const lane = if (octets_per_lane == group_len) index / group_len else index / octets_per_lane * lanes_per_sad;
                result[lane] +%= octet;
            }
            return result;
        }
    };
}

/// The 32-bit lanes of one 64-bit lane of VPSADBW.
const lanes_per_sad = @sizeOf(u64) / group_len;

/// The octets of a NEON, an AVX2 and an AVX-512 register.
const neon_len = 16;
const avx2_len = 32;
const avx512_len = 64;

/// The largest weight VPMADDUBSW's 16-bit pair sums hold.
const pair_weight_max = 64;

/// The objects' shapes: UDOT, VPMADDUBSW on 32 and 64 octets, and VPDPBUSD.
const Udot = Software(neon_len, false, std.math.maxInt(u8), group_len);
const Avx2 = Software(avx2_len, true, pair_weight_max, @sizeOf(u64));
const Avx512 = Software(avx512_len, true, pair_weight_max, @sizeOf(u64));
const Vnni = Software(avx512_len, true, std.math.maxInt(i8), group_len);

/// VPDPBUSD's shape with the blocks taken in turn by two sets of weighted sums.
const VnniInTurn = struct {
    pub const register_len = Vnni.register_len;
    pub const lane_octets = Vnni.lane_octets;
    pub const signed_weights = Vnni.signed_weights;
    pub const weight_max = Vnni.weight_max;
    pub const accumulator_sets = 2;
    pub const weighted = Vnni.weighted;
    pub const sums = Vnni.sums;
};

/// The x86 shapes on 128-bit registers, as the short blocks take them.
const Short128 = Software(neon_len, true, pair_weight_max, @sizeOf(u64));
const VnniShort128 = Software(neon_len, true, std.math.maxInt(i8), group_len);

/// RFC 1950 §9's update_adler32, reducing after every octet.
fn reference(adler: u32, octets: []const u8) u32 {
    var s1: u32 = adler & std.math.maxInt(u16);
    var s2: u32 = adler >> @bitSizeOf(u16);
    for (octets) |octet| {
        s1 = (s1 + octet) % constants.adler32_base;
        s2 = (s2 + s1) % constants.adler32_base;
    }
    return (s2 << @bitSizeOf(u16)) + s1;
}

/// The largest start: both sums one below the modulus.
const start_max: u32 = ((constants.adler32_base - 1) << @bitSizeOf(u16)) | (constants.adler32_base - 1);

test "the dot-product path equals the reference in every object's shape" {
    var octets: [1024 + 64]u8 = undefined;
    for (&octets, 0..) |*octet, index| octet.* = @truncate(index *% 2654435761 >> 11);
    inline for (.{ .{ Udot, Udot }, .{ Avx2, Short128 }, .{ Avx512, Short128 }, .{ Vnni, VnniShort128 }, .{ VnniInTurn, VnniShort128 } }) |shape| {
        const Dot = shape[0];
        const Short = adler32_dot.Kernel(shape[1], 2, adler32_scalar);
        const Kernel = adler32_dot.Kernel(Dot, 128 / Dot.register_len, Short);
        for (0..64) |offset| {
            var len: usize = 0;
            while (len <= 1024) : (len += if (len < 300) 1 else 29) {
                const input = octets[offset..][0..len];
                try testing.expectEqual(reference(start_max, input), Kernel.update(start_max, input));
                try testing.expectEqual(reference(start_max, input), Short.update(start_max, input));
            }
        }
    }
}

test "the dot-product path holds its lanes over a whole run of 0xff" {
    inline for (.{ Udot, Avx2, Avx512, Vnni, VnniInTurn }) |Dot| {
        const Kernel = adler32_dot.Kernel(Dot, 128 / Dot.register_len, adler32_scalar);
        const len = (Kernel.blocks_per_run_max + 1) * Kernel.block_len + 7;
        const ones: [len]u8 = @splat(0xff);
        try testing.expectEqual(reference(start_max, &ones), Kernel.update(start_max, &ones));
    }
}
