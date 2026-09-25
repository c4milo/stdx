//! Adler-32 by AVX512_VNNI dot products: the x86-64 variant object of decision 21 for CPUs with
//! AVX-512 and VNNI, called only when `Features` has `avx512` and `vnni`. The path is
//! adler32_dot.zig's over x86_dot.zig's VPDPBUSD on 64-octet registers.

const constants = @import("../constants.zig");
const adler32_scalar = @import("../adler32_scalar.zig");
const adler32_dot = @import("adler32_dot.zig");
const x86_dot = @import("x86_dot.zig");

/// The octets of one AVX-512 register.
const register_len = 64;

const Short = adler32_dot.Kernel(x86_dot.DotVnni(register_len), constants.adler32_x86_registers_short, adler32_scalar);
const Kernel = adler32_dot.Kernel(x86_dot.DotVnni(register_len), constants.adler32_x86_registers, Short);

/// The Adler-32 value after `len` octets from `adler`.
export fn stdx_checksum_adler32_vnni(adler: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return Kernel.update(adler, octets_pointer[0..len]);
}
