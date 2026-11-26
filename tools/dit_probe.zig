//! A probe of PSTATE.DIT on a Linux arm64 host whose kernel may hide FEAT_DIT: it prints the
//! auxiliary vector's DIT bit, then sets the mode, reads it back, and clears it, on this thread
//! and on a new one. An instruction the core lacks ends the process with SIGILL.
const std = @import("std");
const builtin = @import("builtin");

/// Linux's HWCAP_DIT, bit 24 of AT_HWCAP on arm64.
const hwcap_dit: usize = 1 << 24;
/// PSTATE.DIT as `mrs` reads it: bit 24 (Arm ARM, C5.2.4).
const dit_bit: u64 = 1 << 24;

fn read_dit() u64 {
    return asm volatile ("mrs %[value], s3_3_c4_c2_5"
        : [value] "=r" (-> u64),
    );
}

fn set_dit() void {
    asm volatile (
        \\.inst 0xd503415f
        \\isb
        ::: .{ .memory = true });
}

fn clear_dit() void {
    asm volatile (
        \\.inst 0xd503405f
        \\isb
        ::: .{ .memory = true });
}

fn round(label: []const u8) void {
    const before = read_dit() & dit_bit != 0;
    set_dit();
    const set = read_dit() & dit_bit != 0;
    clear_dit();
    const cleared = read_dit() & dit_bit != 0;
    std.debug.print("{s}: dit before={} after set={} after clear={}\n", .{ label, before, set, cleared });
}

pub fn main() !void {
    comptime std.debug.assert(builtin.cpu.arch == .aarch64);
    const hwcap = std.os.linux.getauxval(std.elf.AT_HWCAP);
    std.debug.print("hwcap=0x{x} hwcap_dit={}\n", .{ hwcap, hwcap & hwcap_dit != 0 });
    round("main thread");
    const thread = try std.Thread.spawn(.{}, round, .{"new thread"});
    thread.join();
}
