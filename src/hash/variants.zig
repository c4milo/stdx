//! The root of the checksum module's variant objects (decision 21). The build compiles this file
//! once per feature level, each time for a CPU with that level's features and with
//! `@import("variant_level").level` naming the level, and links each object into the checksum
//! module. Each object exports its level's kernels alone, so no two define the same symbol.
//!
//! The module calls a kernel only when the caller's `Features` say the CPU has its level.

const std = @import("std");
const level = @import("variant_level").level;

/// The object traps on a panic, with none of std's stack-trace code, which each object would
/// otherwise carry a copy of: some 430 KB of text in each (decision 21 as amended on
/// 2026-11-22). The program's own handler reports the trap, and the stack through the kernel.
/// Each check still calls a panic function, out of line, which decision 51's count reads.
pub const panic = std.debug.FullPanic(panic_trap);

noinline fn panic_trap(message: []const u8, first_trace_address: ?usize) noreturn {
    _ = message;
    _ = first_trace_address;
    @trap();
}

comptime {
    switch (level) {
        .x86_64_pclmul => _ = @import("variants/crc32_pclmul.zig"),
        .x86_64_vpclmul => _ = @import("variants/crc32_vpclmul.zig"),
        .x86_64_avx512 => {
            _ = @import("variants/crc32_avx512.zig");
            _ = @import("variants/adler32_avx512.zig");
            _ = @import("variants/xxh64_avx512.zig");
        },
        .x86_64_avx2 => _ = @import("variants/adler32_avx2.zig"),
        .x86_64_avx512_vnni => _ = @import("variants/adler32_vnni.zig"),
        .aarch64_crc_pmull => _ = @import("variants/crc32_armv8.zig"),
        .aarch64_dotprod => _ = @import("variants/adler32_udot.zig"),
        // No checksum kernel takes SSSE3 alone, and `levels_of` builds no such object.
        .x86_64_ssse3 => {},
    }
}
