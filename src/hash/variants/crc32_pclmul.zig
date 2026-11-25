//! CRC-32 by carry-less multiplication: the x86-64 variant object of decision 21, compiled with
//! SSE4.1 and PCLMULQDQ whatever the module's target, and called only when `Features.pclmul` is
//! set. The folding is crc32_fold.zig's over pclmul.zig's multiplications, and the table path
//! takes the last lane and the tail.

const pclmul = @import("pclmul.zig");

/// The CRC register after `len` octets from `register`, as crc32_table.update_register gives it.
export fn stdx_checksum_crc32_pclmul(register: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return pclmul.Folding.update(register, octets_pointer[0..len]);
}
