//! CRC-32 by carry-less multiplication: the x86-64 variant object of decision 21, compiled with
//! SSE4.1 and PCLMULQDQ whatever the module's target, and called only when `Features.pclmul` is
//! set. The folding is crc32_fold.zig's; this file supplies PCLMULQDQ, and the table path takes
//! the last lane and the tail.

const constants = @import("../constants.zig");
const crc32_table = @import("../crc32_table.zig");
const crc32_fold = @import("crc32_fold.zig");
const Lane = crc32_fold.Lane;

const Multiply = struct {
    pub fn first_halves(lane: Lane, by: Lane) Lane {
        return asm ("pclmulqdq $0x00, %[by], %[lane]"
            : [out] "=x" (-> Lane),
            : [lane] "0" (lane),
              [by] "x" (by),
        );
    }

    pub fn last_halves(lane: Lane, by: Lane) Lane {
        return asm ("pclmulqdq $0x11, %[by], %[lane]"
            : [out] "=x" (-> Lane),
            : [lane] "0" (lane),
              [by] "x" (by),
        );
    }
};

const Folding = crc32_fold.Folding(Multiply, constants.crc32_lanes_pclmul, crc32_table.update_register);

/// The CRC register after `len` octets from `register`, as crc32_table.update_register gives it.
export fn stdx_checksum_crc32_pclmul(register: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return Folding.update(register, octets_pointer[0..len]);
}
