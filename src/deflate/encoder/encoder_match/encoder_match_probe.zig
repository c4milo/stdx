//! PROBE, never lands (2026-10-20): delays that price level 1's two chains. `live` picks which
//! path's next position waits 8 dependent operations: none, a taken match's, or a literal's. In
//! every build the same assembly runs at both places with the same operands, so the builds differ
//! only in the register each operation reads and writes.

const builtin = @import("builtin");

pub const Site = enum { none, match, literal };
pub const live: Site = .literal;

fn template(comptime on: bool) []const u8 {
    return switch (builtin.cpu.arch) {
        // An even count of xors gives the value back. Off, the chain runs on x16, which nothing reads.
        .aarch64 => if (on) "eor %[out], %[out], #1\n" ** 8 else "eor x16, %[out], #1\n" ++ "eor x16, x16, #1\n" ** 7,
        .x86_64 => "movq %[out], %%r11\n" ++ (if (on) "xorq $1, %[out]\n" else "xorq $1, %%r11\n") ** 8,
        else => @compileError("probe: aarch64 and x86-64 only"),
    };
}

/// `at`, 8 operations later when `on`; otherwise 8 operations on a register nothing reads.
pub inline fn delay(comptime on: bool, at: [*]const u8) [*]const u8 {
    return switch (builtin.cpu.arch) {
        .aarch64 => asm (template(on)
            : [out] "=r" (-> [*]const u8),
            : [in] "0" (at),
            : .{ .x16 = true }),
        .x86_64 => asm (template(on)
            : [out] "=r" (-> [*]const u8),
            : [in] "0" (at),
            : .{ .r11 = true, .cc = true }),
        else => at,
    };
}
