//! The root of the json module's variant object (decisions 21, 30 and 36). The build compiles this
//! file for the one x86-64 level claim J7 takes, AVX2, for a CPU with its features and with
//! `@import("variant_level").level` naming it, and links the object into the json module.
//!
//! The module calls a level's scans only when the caller's `platform.CpuFeatures` name the level
//! (wide.zig).

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
        .x86_64_avx2 => {
            _ = @import("variants/scan_wide.zig");
            _ = @import("variants/loop_string.zig");
            _ = @import("variants/scan_utf8.zig");
        },
        // Decision 39's check alone takes AVX-512's width; the loops keep AVX2's (wide.zig).
        .x86_64_avx512 => _ = @import("variants/scan_utf8.zig"),
        else => {},
    }
}
