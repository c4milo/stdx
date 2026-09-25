//! The dot products of adler32_dot.zig on x86-64, for registers of `register_len` octets: 32 with
//! AVX2, 64 with AVX-512 BW, and 64 with AVX512_VNNI's VPDPBUSD, which does the weighted products
//! and their sums in one instruction. VPMADDUBSW multiplies each unsigned octet by a signed weight and adds
//! neighbouring products into 16 bits, which holds them while every weight is below 64 and a half;
//! VPMADDWD by ones adds neighbouring 16-bit sums into 32 bits; VPSADBW adds each eight octets into
//! a 64-bit lane. This file exports nothing.

const std = @import("std");

pub fn Dot(comptime len: usize) type {
    const Octets = @Vector(len, u8);
    const Pairs = @Vector(len / @sizeOf(u16), i16);
    const Lanes = @Vector(len / @sizeOf(u32), u32);
    const Eights = @Vector(len / @sizeOf(u64), u64);
    return struct {
        pub const register_len = len;

        comptime {
            // Two products of an octet and a weight fit a signed 16-bit sum.
            std.debug.assert(2 * std.math.maxInt(u8) * len <= std.math.maxInt(i16));
        }

        pub fn weighted(accumulator: Lanes, octets: Octets, weights: Octets) Lanes {
            const pairs = asm ("vpmaddubsw %[weights], %[octets], %[out]"
                : [out] "=x" (-> Pairs),
                : [octets] "x" (octets),
                  [weights] "x" (weights),
            );
            const ones: Pairs = @splat(1);
            const quads = asm ("vpmaddwd %[ones], %[pairs], %[out]"
                : [out] "=x" (-> Lanes),
                : [pairs] "x" (pairs),
                  [ones] "x" (ones),
            );
            return accumulator +% quads;
        }

        pub fn sums(accumulator: Lanes, octets: Octets) Lanes {
            const zero: Octets = @splat(0);
            const eights = asm ("vpsadbw %[zero], %[octets], %[out]"
                : [out] "=x" (-> Eights),
                : [octets] "x" (octets),
                  [zero] "x" (zero),
            );
            return accumulator +% @as(Lanes, @bitCast(eights));
        }
    };
}

/// The dot products with VPDPBUSD on 64-octet registers: each 32-bit lane gains the four products
/// of an unsigned octet and a signed weight.
pub fn DotVnni(comptime len: usize) type {
    const Octets = @Vector(len, u8);
    const Lanes = @Vector(len / @sizeOf(u32), u32);
    return struct {
        pub const register_len = len;

        pub fn weighted(accumulator: Lanes, octets: Octets, weights: Octets) Lanes {
            return asm ("vpdpbusd %[weights], %[octets], %[out]"
                : [out] "=x" (-> Lanes),
                : [accumulator] "0" (accumulator),
                  [octets] "x" (octets),
                  [weights] "x" (weights),
            );
        }

        pub const sums = Dot(len).sums;
    };
}
