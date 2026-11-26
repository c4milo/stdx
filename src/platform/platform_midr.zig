//! `CpuFeatures.midr`: the Main ID Register, MIDR_EL1, of the aarch64 core that detection ran on
//! (decision 40 as amended on 2026-11-19 and on 2026-11-26). A program tells one core from another
//! by its implementer and part, as chapulin's decision 240 asks a caller to tell Arm's Neoverse N2.
//!
//! On aarch64 Linux, `mrs` reads the register where AT_HWCAP has HWCAP_CPUID. Linux traps the read
//! and emulates it, and returns the value of the core where the read ran (the kernel's
//! Documentation/arch/arm64/cpu-feature-registers.rst, sections 2 and 4). So the read makes no
//! syscall and opens no file. Without the bit, the read raises SIGILL, so detection makes it only
//! where the bit is set. macOS gives a program no read of the register, and x86-64 has none.
//!
//! On a system with cores of more than one kind, a thread may run on another kind after detection.
//! The field names the core where detection ran.

const std = @import("std");
const builtin = @import("builtin");
const constants = @import("constants.zig");

/// The fields of Arm's MIDR_EL1, as Arm's Architecture Reference Manual names them.
pub const Midr = struct {
    /// The code Arm assigns the core's maker: 0x41 is Arm, and 0x61 is Apple.
    implementer: u8,
    /// The part's major revision.
    variant: u4,
    /// 0xf on every core that states its features in the ID registers, as arm64 Linux requires.
    architecture: u4,
    /// The maker's number for the core.
    part: u12,
    /// The part's minor revision.
    revision: u4,
};

/// MIDR_EL1 of this core, where AT_HWCAP's `word` lets a program read it, and null elsewhere.
pub fn read(word: usize) ?Midr {
    return reading(word, read_register);
}

/// MIDR_EL1 through `register_of` only where `word` has HWCAP_CPUID. A test passes a stand-in.
fn reading(word: usize, comptime register_of: fn () u64) ?Midr {
    if (!readable(word)) return null;
    return from_register(register_of());
}

/// Whether Linux emulates a read of MIDR_EL1 for this program: AT_HWCAP's HWCAP_CPUID.
fn readable(word: usize) bool {
    return word & constants.hwcap_cpuid != 0;
}

/// MIDR_EL1, through `mrs`. Call it only where `readable` holds: elsewhere the read raises SIGILL.
fn read_register() u64 {
    if (builtin.cpu.arch != .aarch64 or builtin.os.tag != .linux) unreachable;
    return asm volatile ("mrs %[midr], MIDR_EL1"
        : [midr] "=r" (-> u64),
    );
}

/// MIDR_EL1's fields, each from its place in the register.
pub fn from_register(value: u64) Midr {
    return .{
        .implementer = @truncate(value >> constants.midr_implementer_shift),
        .variant = @truncate(value >> constants.midr_variant_shift),
        .architecture = @truncate(value >> constants.midr_architecture_shift),
        .part = @truncate(value >> constants.midr_part_shift),
        .revision = @truncate(value >> constants.midr_revision_shift),
    };
}

// Tests.

const testing = std.testing;

test "MIDR_EL1's fields come from bits 31 to 24, 23 to 20, 19 to 16, 15 to 4 and 3 to 0" {
    // Arm's Neoverse N2, r0p0, and Apple's M1 as a virtual machine reports it.
    try testing.expectEqual(Midr{ .implementer = 0x41, .variant = 0, .architecture = 0xf, .part = 0xd49, .revision = 0 }, from_register(0x410f_d490));
    try testing.expectEqual(Midr{ .implementer = 0x61, .variant = 0, .architecture = 0xf, .part = 0, .revision = 0 }, from_register(0x610f_0000));
    // Every field differs from its neighbours, and the bits above 31 are not MIDR_EL1's.
    try testing.expectEqual(Midr{ .implementer = 0xa5, .variant = 0x3, .architecture = 0xc, .part = 0x9e1, .revision = 0x7 }, from_register(0xffff_ffff_a53c_9e17));
}

test "a program reads MIDR_EL1 only where AT_HWCAP has HWCAP_CPUID, bit 11" {
    try testing.expect(readable(1 << 11));
    try testing.expect(readable(~@as(usize, 0)));
    try testing.expect(!readable(~@as(usize, 1 << 11)));
    try testing.expect(!readable(0));
    const stand_in = struct {
        fn register() u64 {
            return 0x410f_d490;
        }
    };
    try testing.expectEqual(from_register(0x410f_d490), reading(1 << 11 | 1 << 3, stand_in.register).?);
    try testing.expectEqual(null, reading(1 << 3, stand_in.register));
    try testing.expectEqual(null, reading(0, stand_in.register));
}

test "detection on aarch64 Linux reads MIDR_EL1 exactly where AT_HWCAP lets it" {
    if (builtin.cpu.arch != .aarch64 or builtin.os.tag != .linux) return error.SkipZigTest;
    const word = if (builtin.link_libc) std.c.getauxval(std.elf.AT_HWCAP) else std.os.linux.getauxval(std.elf.AT_HWCAP);
    const midr = read(word);
    try testing.expectEqual(readable(word), midr != null);
}
