//! XXH64's Step 2 by AVX-512: the x86-64 AVX-512 variant object of decision 21, called only when
//! `Features.avx512` is set. The four accumulators sit in one 256-bit register, so a stripe's four
//! rounds are one VPMULLQ of its lanes, an add, a VPROLQ and a VPMULLQ, which AVX-512 DQ and VL
//! give 64-bit lanes (docs/specs/xxhash_spec.md, XXH64 Step 2).

const std = @import("std");
const builtin = @import("builtin");
const constants = @import("../constants.zig");

const Lanes = @Vector(constants.xxh64_lanes, u64);

comptime {
    // A stripe's lanes load as the vector's elements, which reads each least significant octet
    // first (Step 2) only on a little-endian target, as x86-64 is.
    std.debug.assert(builtin.cpu.arch.endian() == .little);
}

/// Step 2 over `stripes` whole stripes at `octets`, from and into `accumulators`.
export fn stdx_checksum_xxh64_avx512(accumulators: *[constants.xxh64_lanes]u64, octets: [*]const u8, stripes: usize) callconv(.c) void {
    const prime_1: Lanes = @splat(constants.xxh64_prime_1);
    const prime_2: Lanes = @splat(constants.xxh64_prime_2);
    var lanes: Lanes = accumulators.*;
    for (0..stripes) |index| {
        // Least significant octet first (Step 2), on this little-endian target.
        const stripe: Lanes = @bitCast(octets[index * constants.xxh64_stripe_len ..][0..constants.xxh64_stripe_len].*);
        lanes = std.math.rotl(Lanes, lanes +% stripe *% prime_2, constants.xxh64_round_rotation) *% prime_1;
    }
    accumulators.* = lanes;
}
