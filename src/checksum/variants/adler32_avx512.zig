//! Adler-32 with 64-octet vectors, two to a block: the x86-64 AVX-512 variant object of decision
//! 21, called only when `Features.avx512` is set.

const constants = @import("../constants.zig");
const adler32_vector = @import("../adler32_vector.zig");

/// The octets of one AVX-512 register.
const register_len = 64;

/// The octets of one block: two registers, as the vector path takes two of its own.
const block_len = constants.adler32_registers_per_block * register_len;

/// The Adler-32 value after `len` octets from `adler`.
export fn stdx_checksum_adler32_avx512(adler: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return adler32_vector.update(block_len, adler, octets_pointer[0..len]);
}
