//! The calling thread's mode of data-independent timing, which a program reads and sets
//! (decision 40 as amended on 2026-11-25).
//!
//! On arm64 the mode is PSTATE.DIT. While it is 1, the instructions Arm's A64 reference lists take
//! a time that does not depend on the values they process. User code reads it with one `mrs` and
//! sets it with one `msr`, and the kernel keeps it for the thread. Each is an instruction, and
//! neither is a syscall. On a core without FEAT_DIT each instruction faults, so each call takes
//! the program's `CpuFeatures` and runs neither unless `dit` is true.
//!
//! On x86-64 the mode is DOITM, a bit of the model-specific register IA32_UARCH_MISC_CTL. Only the
//! operating system reads or writes it, so these calls answer false and refuse to set it.
//!
//! Each call acts on the calling thread alone. A program calls `set_data_independent_timing` on
//! each thread that runs code whose timing must not depend on a secret.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const CpuFeatures = @import("platform_cpu_features.zig").CpuFeatures;

/// Whether the calling thread's timing is data-independent: true when its PSTATE.DIT is 1. False
/// when it is 0, when `features` holds no FEAT_DIT, so that the read could fault, and on every
/// architecture but arm64, where no program can read the mode. `features` holds the program's
/// one `CpuFeatures.detect()`.
pub fn data_independent_timing(features: CpuFeatures) bool {
    // The register exists on arm64 alone, so another target compiles no `mrs`.
    if (comptime builtin.cpu.arch != .aarch64) return false;
    if (!readable(features, builtin.cpu.arch)) return false;
    return dit_of(read_dit());
}

/// Whether a program may read and write the DIT register: an arm64 core that has FEAT_DIT. On any
/// other core the instruction faults.
fn readable(features: CpuFeatures, arch: std.Target.Cpu.Arch) bool {
    return arch == .aarch64 and features.dit;
}

/// Sets the calling thread's PSTATE.DIT when `enabled` is true, and clears it when it is false.
/// `features` holds the program's one `CpuFeatures.detect()`. Returns true when the thread now
/// holds the mode `enabled` names, and false where it cannot set the mode: x86-64, where only the
/// operating system sets DOITM, another architecture, and an arm64 core whose `features` hold no
/// FEAT_DIT.
pub fn set_data_independent_timing(features: CpuFeatures, enabled: bool) bool {
    if (comptime builtin.cpu.arch != .aarch64) return false;
    if (!readable(features, builtin.cpu.arch)) return false;
    write_dit(register_of(enabled));
    assert(dit_of(read_dit()) == enabled);
    return true;
}

/// PSTATE.DIT in a value of the DIT register.
fn dit_of(register: u64) bool {
    return register & constants.dit_bit != 0;
}

/// The value of the DIT register that sets PSTATE.DIT to `enabled`.
fn register_of(enabled: bool) u64 {
    return if (enabled) constants.dit_bit else 0;
}

// The DIT register under its encoding, S3_3_C4_C2_5, which an assembler takes for any CPU model,
// where the name DIT needs the target feature `dit`.

fn read_dit() u64 {
    return asm volatile ("mrs %[register], s3_3_c4_c2_5"
        : [register] "=r" (-> u64),
    );
}

fn write_dit(register: u64) void {
    asm volatile ("msr s3_3_c4_c2_5, %[register]"
        :
        : [register] "r" (register),
    );
}

// Tests.

const testing = std.testing;

test "PSTATE.DIT is bit 24 of the register, and no other bit" {
    try testing.expect(dit_of(1 << 24));
    try testing.expect(!dit_of(0));
    try testing.expect(!dit_of(~@as(u64, 1 << 24)));
    try testing.expectEqual(@as(u64, 1 << 24), register_of(true));
    try testing.expectEqual(@as(u64, 0), register_of(false));
}

test "only an arm64 core whose features hold FEAT_DIT has its register read" {
    try testing.expect(readable(.{ .dit = true }, .aarch64));
    try testing.expect(!readable(.{ .dit = true }, .x86_64));
    try testing.expect(!readable(.{}, .aarch64));
    try testing.expect(!readable(.{ .sha3 = true, .sve2 = true, .aes = true }, .aarch64));
}

test "a core without FEAT_DIT has no mode to read or set" {
    var features = CpuFeatures.detect();
    features.dit = false;
    try testing.expect(!data_independent_timing(features));
    try testing.expect(!set_data_independent_timing(features, true));
}

test "the calling thread's mode follows each set, and returns to what it was" {
    const features = CpuFeatures.detect();
    const before = data_independent_timing(features);
    if (builtin.cpu.arch != .aarch64 or !features.dit) {
        try testing.expect(!before);
        try testing.expect(!set_data_independent_timing(features, true));
        return;
    }
    defer assert(set_data_independent_timing(features, before));
    try testing.expect(set_data_independent_timing(features, true));
    try testing.expect(data_independent_timing(features));
    try testing.expect(set_data_independent_timing(features, false));
    try testing.expect(!data_independent_timing(features));
}
