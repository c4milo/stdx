//! Adler-32 with 32-octet vectors: the x86-64 variant object of decision 21, compiled with AVX2
//! whatever the module's target, and called only when `Features.avx2` is set.

const adler32_vector = @import("../adler32_vector.zig");

/// The octets of one AVX2 register.
const lanes = 32;

/// The Adler-32 value after `len` octets from `adler`.
export fn stdx_checksum_adler32_avx2(adler: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return adler32_vector.update(lanes, adler, octets_pointer[0..len]);
}
