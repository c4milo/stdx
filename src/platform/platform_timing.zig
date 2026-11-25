//! The calling thread's mode of data-independent timing, which a program reads and sets
//! (decision 40 as amended on 2026-11-25).
//!
//! On arm64 the mode is PSTATE.DIT. While it is 1, the instructions Arm's A64 reference lists take
//! a time that does not depend on the values they process. User code reads it with one `mrs` and
//! sets it with one `msr`, and the kernel keeps it for the thread. Each is an instruction, and
//! neither is a syscall. On a core without FEAT_DIT each instruction faults, so each call takes
//! the probe's answers and runs neither unless `dit` is `yes`.
//!
//! On x86-64 the mode is DOITM, a bit of the model-specific register IA32_UARCH_MISC_CTL. Only the
//! operating system reads or writes it, so these calls answer `not_known` and refuse to set it.
//!
//! Each call acts on the calling thread alone. A program calls `set_data_independent_timing` on
//! each thread that runs code whose timing must not depend on a secret.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const platform = @import("platform.zig");
const Answer = platform.Answer;
const Cpu = platform.Cpu;

/// The calling thread's mode: `yes` when its timing is data-independent, `no` when it is not or
/// the core cannot hold the mode, and `not_known` where a program cannot read it. `cpu` holds the
/// answers of the program's probe.
pub fn data_independent_timing(cpu: Cpu) Answer {
    // The register exists on arm64 alone, so another target compiles no `mrs`.
    if (comptime builtin.cpu.arch != .aarch64) return .not_known;
    if (answer_unread(cpu, builtin.cpu.arch)) |answer| return answer;
    return if (dit_of(read_dit())) .yes else .no;
}

/// The answer that needs no read of the register, or null when only the register holds it.
fn answer_unread(cpu: Cpu, arch: std.Target.Cpu.Arch) ?Answer {
    if (arch != .aarch64) return .not_known;
    // `no`: the core has no PSTATE.DIT. `not_known`: the read could fault.
    if (cpu.dit != .yes) return cpu.dit;
    return null;
}

/// Sets the calling thread's PSTATE.DIT when `enabled` is true, and clears it when it is false.
/// `cpu` holds the answers of the program's probe. Returns true when the thread now holds the mode
/// `enabled` names, and false where it cannot set the mode: x86-64, where only the operating system
/// sets DOITM, another architecture, and an arm64 core the probe does not answer FEAT_DIT `yes` for.
pub fn set_data_independent_timing(cpu: Cpu, enabled: bool) bool {
    if (comptime builtin.cpu.arch != .aarch64) return false;
    // A mode the read cannot hold is a mode the write cannot set.
    if (answer_unread(cpu, builtin.cpu.arch) != null) return false;
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

test "only an arm64 core the probe answers FEAT_DIT yes for has its register read" {
    var cpu = platform.probe();
    cpu.dit = .yes;
    try testing.expectEqual(@as(?Answer, null), answer_unread(cpu, .aarch64));
    try testing.expectEqual(@as(?Answer, .not_known), answer_unread(cpu, .x86_64));
    cpu.dit = .no;
    try testing.expectEqual(@as(?Answer, .no), answer_unread(cpu, .aarch64));
    cpu.dit = .not_known;
    try testing.expectEqual(@as(?Answer, .not_known), answer_unread(cpu, .aarch64));
}

test "a core without FEAT_DIT has no mode to read or set, and one that may lack it is not read" {
    var cpu = platform.probe();
    cpu.dit = .no;
    try testing.expectEqual(if (builtin.cpu.arch == .aarch64) Answer.no else Answer.not_known, data_independent_timing(cpu));
    try testing.expect(!set_data_independent_timing(cpu, true));
    cpu.dit = .not_known;
    try testing.expectEqual(Answer.not_known, data_independent_timing(cpu));
    try testing.expect(!set_data_independent_timing(cpu, true));
}

test "the calling thread's mode follows each set, and returns to what it was" {
    const cpu = platform.probe();
    const before = data_independent_timing(cpu);
    if (builtin.cpu.arch != .aarch64 or cpu.dit != .yes) {
        try testing.expectEqual(if (builtin.cpu.arch == .aarch64) cpu.dit else Answer.not_known, before);
        try testing.expect(!set_data_independent_timing(cpu, true));
        return;
    }
    defer assert(set_data_independent_timing(cpu, before == .yes));
    try testing.expect(set_data_independent_timing(cpu, true));
    try testing.expectEqual(Answer.yes, data_independent_timing(cpu));
    try testing.expect(set_data_independent_timing(cpu, false));
    try testing.expectEqual(Answer.no, data_independent_timing(cpu));
}
