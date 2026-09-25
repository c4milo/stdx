//! The constants of the three checks: CRC-32 (RFC 1952 §8), Adler-32 (RFC 1950 §2.2, §8.2, §9)
//! and the sizes of their paths.
const std = @import("std");

/// CRC-32's generator polynomial, bit-reversed as RFC 1952 §8's make_crc_table writes it:
/// x^32 + x^26 + x^23 + ... + 1 with the x^32 term dropped and the order of the rest reversed.
pub const crc32_polynomial_reflected: u32 = 0xedb88320;

/// The same polynomial in its normal bit order: bit d is the coefficient of x^d.
pub const crc32_polynomial: u32 = 0x04c11db7;

/// The one's complement RFC 1952 §8's update_crc applies on entry and on exit.
pub const crc32_conditioning: u32 = 0xffff_ffff;

/// The octets the slice-by-8 table path takes per step, and so the number of 256-entry tables.
pub const crc32_slice_len = 8;

/// The octets of one 128-bit lane of the folding paths.
pub const crc32_lane_len = 16;

/// The lanes the PCLMULQDQ path folds per step.
pub const crc32_lanes_pclmul = 4;

/// The lanes the VPCLMULQDQ path folds per step, two to a 256-bit register.
pub const crc32_lanes_vpclmul = 8;

/// The lanes the AVX-512 path folds per step, four to a 512-bit register.
pub const crc32_lanes_avx512 = 16;

/// The shortest input the AVX-512 path takes: one step. A shorter one takes the VPCLMULQDQ path,
/// whose object runs the 128-bit folding faster (docs/design.md §8 step 4).
pub const crc32_avx512_len_min = crc32_lanes_avx512 * crc32_lane_len;

/// The lanes the PMULL path folds per step. Of 4, 8 and 16, 8 measured fastest from 1 KiB on
/// aarch64 (docs/design.md §8 step 4).
pub const crc32_lanes_pmull = 8;

/// The lanes the PMULL path folds per step on an input too short for `crc32_lanes_pmull`, which
/// measured faster than the CRC32 instructions alone from 64 octets.
pub const crc32_lanes_pmull_short = 4;

/// The chains of CRC32 instructions the combined aarch64 path runs beside its folding: enough that
/// the integer unit never waits on one chain's latency.
pub const crc32_streams = 3;

/// The steps of a long block of the combined path, and the octets each chain takes per step. Of
/// the mixes measured on a Neoverse N2 runner, 128 octets folded to 40 on each chain was fastest
/// from 16 KiB (docs/design.md §8 step 4).
pub const crc32_combined_long_iterations = 32;
pub const crc32_combined_long_stream_step_len = 40;

/// The steps of a short block, 896 octets, which measured faster on the N2 runner than folding
/// alone from 1 KiB, and the octets each chain takes per step.
pub const crc32_combined_short_iterations = 4;
pub const crc32_combined_short_stream_step_len = 32;

/// The most lanes a folding path folds per step, which bounds the comptime work of its multipliers.
pub const crc32_lanes_max = 16;

/// The octets of one vector register when the target suggests no vector width: 128 bits, the
/// width SSE2 and NEON share.
pub const adler32_vector_len_fallback = 16;

/// The vector registers one block of Adler-32's vector path takes.
pub const adler32_registers_per_block = 2;

/// The octets of one block of Adler-32's dot-product paths: the most whose weights, 128 down to 1,
/// fit UDOT's unsigned octets, and centered on zero, x86's signed ones.
pub const adler32_dot_block_len = 128;

/// The registers of each block after the last whole 128-octet block: two on aarch64, one on x86-64.
pub const adler32_udot_registers_short = 2;
pub const adler32_x86_registers_short = 1;

/// Adler-32's modulus, the largest prime below 65536 (RFC 1950 §9, BASE).
pub const adler32_base: u32 = 65521;

/// Adler-32's starting value: s1 = 1 and s2 = 0 (RFC 1950 §2.2).
pub const adler32_initial: u32 = 1;

/// The most octets Adler-32 may add before its sums must be reduced modulo `adler32_base`, so
/// that s2 stays within 32 bits: RFC 1950 §8.2 gives 5552, and `adler32_deferral_holds` checks it.
pub const adler32_deferral_len: usize = 5552;

/// True when `len` octets of 255, added to sums that start just below the modulus, keep s2 within
/// 32 bits: 255·len·(len+1)/2 + (len+1)·(base−1) ≤ 2^32 − 1.
pub fn adler32_deferral_holds(len: u64) bool {
    const worst = 255 * len * (len + 1) / 2 + (len + 1) * (adler32_base - 1);
    return worst <= std.math.maxInt(u32);
}

comptime {
    // RFC 1950 §8.2's bound is the largest that holds.
    std.debug.assert(adler32_deferral_holds(adler32_deferral_len));
    std.debug.assert(!adler32_deferral_holds(adler32_deferral_len + 1));
    std.debug.assert(@bitReverse(crc32_polynomial) == crc32_polynomial_reflected);
    std.debug.assert(crc32_lanes_pclmul <= crc32_lanes_max and crc32_lanes_pmull <= crc32_lanes_max);
}
