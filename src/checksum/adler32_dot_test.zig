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

fn Software(comptime len: usize) type {
    return struct {
        pub const register_len = len;
        const Lanes = @Vector(len / group_len, u32);

        pub fn weighted(accumulator: Lanes, octets: @Vector(len, u8), weights: @Vector(len, u8)) Lanes {
            var result: [len / group_len]u32 = accumulator;
            const octet_array: [len]u8 = octets;
            const weight_array: [len]u8 = weights;
            for (octet_array, weight_array, 0..) |octet, weight, index| result[index / group_len] +%= @as(u32, octet) * weight;
            return result;
        }

        pub fn sums(accumulator: Lanes, octets: @Vector(len, u8)) Lanes {
            var result: [len / group_len]u32 = accumulator;
            const octet_array: [len]u8 = octets;
            for (octet_array, 0..) |octet, index| result[index / group_len] +%= octet;
            return result;
        }
    };
}

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

test "the dot-product path equals the reference at every register width and count" {
    var octets: [1024 + 64]u8 = undefined;
    for (&octets, 0..) |*octet, index| octet.* = @truncate(index *% 2654435761 >> 11);
    inline for (.{ .{ 16, 8 }, .{ 16, 4 }, .{ 32, 4 }, .{ 64, 1 }, .{ 64, 4 } }) |shape| {
        const Short = adler32_dot.Kernel(Software(shape[0]), 1, adler32_scalar);
        const Kernel = adler32_dot.Kernel(Software(shape[0]), shape[1], Short);
        for (0..64) |offset| {
            var len: usize = 0;
            while (len <= 1024) : (len += if (len < 300) 1 else 29) {
                const input = octets[offset..][0..len];
                try testing.expectEqual(reference(start_max, input), Kernel.update(start_max, input));
            }
        }
    }
}

test "the dot-product path holds its lanes over a whole run of 0xff" {
    inline for (.{ .{ 16, 8 }, .{ 64, 4 } }) |shape| {
        const Kernel = adler32_dot.Kernel(Software(shape[0]), shape[1], adler32_scalar);
        const len = (Kernel.blocks_per_run_max + 1) * Kernel.block_len + 7;
        const ones: [len]u8 = @splat(0xff);
        try testing.expectEqual(reference(start_max, &ones), Kernel.update(start_max, &ones));
    }
}
