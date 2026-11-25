//! The root of the base64 module's variant object (decisions 21 and 68). The build compiles this
//! file for x86-64 with AVX2, with `@import("variant_level").level` naming the level, and links the
//! object into the module. The module calls its kernels only when the caller's
//! `platform.CpuFeatures` name AVX2 (fast.zig).

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
        .x86_64_avx2 => _ = @import("variants/base64_avx2.zig"),
        else => {},
    }
}
