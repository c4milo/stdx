//! CRC-32 by carry-less multiplication of 256-bit registers: the x86-64 variant object of decision
//! 21 for CPUs with AVX2 and VPCLMULQDQ, compiled with both whatever the module's target, and
//! called only when `Features` has `vpclmul` and `avx2`. Each VPCLMULQDQ multiplies both lanes of a
//! register, so a step folds eight lanes with four registers. The folding is crc32_fold.zig's;
//! PCLMULQDQ folds the lanes into one at the end, and the table path takes the tail.

const constants = @import("../constants.zig");
const crc32_table = @import("../crc32_table.zig");
const crc32_fold = @import("crc32_fold.zig");
const pclmul = @import("pclmul.zig");

/// The lanes of one 256-bit register.
const width = 2;

const Wide = @Vector(width * @typeInfo(crc32_fold.Lane).vector.len, u64);

const MultiplyWide = struct {
    pub fn first_halves(lanes: Wide, by: Wide) Wide {
        return asm ("vpclmulqdq $0x00, %[by], %[lanes], %[out]"
            : [out] "=x" (-> Wide),
            : [lanes] "x" (lanes),
              [by] "x" (by),
        );
    }

    pub fn last_halves(lanes: Wide, by: Wide) Wide {
        return asm ("vpclmulqdq $0x11, %[by], %[lanes], %[out]"
            : [out] "=x" (-> Wide),
            : [lanes] "x" (lanes),
              [by] "x" (by),
        );
    }
};

const register_count = constants.crc32_lanes_vpclmul / width;
const Narrow = crc32_fold.Folding(pclmul.MultiplyVex, constants.crc32_lanes_vpclmul, crc32_table.update_register);
const Folding = crc32_fold.WideFolding(MultiplyWide, width, register_count, Narrow, pclmul.FoldingVex);

/// The CRC register after `len` octets from `register`, as crc32_table.update_register gives it.
export fn stdx_checksum_crc32_vpclmul(register: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return Folding.update(register, octets_pointer[0..len]);
}
