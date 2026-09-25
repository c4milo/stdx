//! Adler-32 by AVX2 dot products: the x86-64 variant object of decision 21, compiled with AVX2
//! whatever the module's target, and called only when `Features.avx2` is set. The path is
//! adler32_dot.zig's over x86_dot.zig's instructions on 32-octet registers.

const constants = @import("../constants.zig");
const adler32_scalar = @import("../adler32_scalar.zig");
const adler32_dot = @import("adler32_dot.zig");
const x86_dot = @import("x86_dot.zig");

/// The octets of one AVX2 register.
const register_len = 32;

const Short = adler32_dot.Kernel(x86_dot.Dot(register_len), constants.adler32_x86_registers_short, adler32_scalar);
const Kernel = adler32_dot.Kernel(x86_dot.Dot(register_len), constants.adler32_x86_registers, Short);

/// The Adler-32 value after `len` octets from `adler`.
export fn stdx_checksum_adler32_avx2(adler: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return Kernel.update(adler, octets_pointer[0..len]);
}
