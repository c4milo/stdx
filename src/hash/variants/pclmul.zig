//! PCLMULQDQ's two carry-less multiplications, and the folding over them, which both x86-64 CRC-32
//! objects use. This file exports nothing, so each object that imports it defines only its own
//! kernel.

const constants = @import("../constants.zig");
const crc32_table = @import("../crc32_table.zig");
const crc32_fold = @import("crc32_fold.zig");
const Lane = crc32_fold.Lane;

pub const Multiply = struct {
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

/// The same multiplications in the VEX encoding, for objects that also use 256-bit or 512-bit
/// registers: on Intel CPUs, the legacy encoding after a wider register was written costs a
/// transition of the vector state on every call.
pub const MultiplyVex = struct {
    pub fn first_halves(lane: Lane, by: Lane) Lane {
        return asm ("vpclmulqdq $0x00, %[by], %[lane], %[out]"
            : [out] "=x" (-> Lane),
            : [lane] "x" (lane),
              [by] "x" (by),
        );
    }

    pub fn last_halves(lane: Lane, by: Lane) Lane {
        return asm ("vpclmulqdq $0x11, %[by], %[lane], %[out]"
            : [out] "=x" (-> Lane),
            : [lane] "x" (lane),
              [by] "x" (by),
        );
    }
};

/// Folding over `crc32_lanes_pclmul` lanes, with the table path for the last lane and the tail.
pub const Folding = crc32_fold.Folding(Multiply, constants.crc32_lanes_pclmul, crc32_table.update_register);

/// The same folding in the VEX encoding.
pub const FoldingVex = crc32_fold.Folding(MultiplyVex, constants.crc32_lanes_pclmul, crc32_table.update_register);
