//! The constants of the three checks: CRC-32 (RFC 1952 §8), Adler-32 (RFC 1950 §2.2, §8.2, §9),
//! XXH64 (docs/specs/xxhash_spec.md, "XXH64 Algorithm Description", decision 18) and the sizes of
//! their paths.
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

/// The octets of one block after the last whole 128-octet block: two 128-bit registers, whose sums
/// reduce in fewer instructions than a wider register's.
pub const adler32_dot_short_block_len = 32;

/// The octets of one 128-bit register, the width of every dot-product path's short blocks.
pub const adler32_short_register_len = 16;

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

/// XXH64's five primes (xxhash_spec.md, XXH64 "Overview").
pub const xxh64_prime_1: u64 = 0x9E3779B185EBCA87;
pub const xxh64_prime_2: u64 = 0xC2B2AE3D27D4EB4F;
pub const xxh64_prime_3: u64 = 0x165667B19E3779F9;
pub const xxh64_prime_4: u64 = 0x85EBCA77C2B2AE63;
pub const xxh64_prime_5: u64 = 0x27D4EB2F165667C5;

/// The octets of an XXH64 stripe, the lanes it divides into, and the octets of a lane, each read
/// least significant octet first (xxhash_spec.md, XXH64 Step 2).
pub const xxh64_stripe_len = 32;
pub const xxh64_lanes = 4;
pub const xxh64_lane_len = 8;

/// The octets of the 32-bit word Step 5 reads after the whole lanes of the remaining input.
pub const xxh64_word_len = 4;

/// The shortest run of whole stripes the AVX-512 path takes; a shorter one takes the scalar path.
/// On an AMD EPYC 9V74 runner the AVX-512 path ran at 0.51 of the scalar path's speed over 64
/// octets and at 1.05 over 1 KiB, as its accumulators cross into a vector register and back once
/// a call (design §8 step 10).
pub const xxh64_avx512_len_min = 1024;

/// The left rotation of Step 2's round.
pub const xxh64_round_rotation = 31;

/// The left rotation of each accumulator before Step 3 adds them, in lane order.
pub const xxh64_convergence_rotations = [xxh64_lanes]u6{ 1, 7, 12, 18 };

/// Step 5's left rotations after a lane, a 32-bit word and an octet of the remaining input.
pub const xxh64_lane_rotation = 27;
pub const xxh64_word_rotation = 23;
pub const xxh64_octet_rotation = 11;

/// Step 6's final mix: for each shift, the accumulator takes the exclusive-or of itself shifted
/// right, then is multiplied by the prime; then one last shift and exclusive-or.
pub const xxh64_avalanche_shifts = [_]u6{ 33, 29 };
pub const xxh64_avalanche_primes = [_]u64{ xxh64_prime_2, xxh64_prime_3 };
pub const xxh64_avalanche_last_shift = 32;

comptime {
    std.debug.assert(xxh64_lanes * xxh64_lane_len == xxh64_stripe_len);
    std.debug.assert(xxh64_word_len * 2 == xxh64_lane_len);
    // RFC 1950 §8.2's bound is the largest that holds.
    std.debug.assert(adler32_deferral_holds(adler32_deferral_len));
    std.debug.assert(!adler32_deferral_holds(adler32_deferral_len + 1));
    std.debug.assert(@bitReverse(crc32_polynomial) == crc32_polynomial_reflected);
    std.debug.assert(crc32_lanes_pclmul <= crc32_lanes_max and crc32_lanes_pmull <= crc32_lanes_max);
}
