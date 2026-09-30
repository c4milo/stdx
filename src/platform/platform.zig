//! platform: what the CPU a program runs on offers, read once when the program starts
//! (decision 40, design §3).
//!
//! A program calls `probe()` once, at start, and passes the fields of the `Cpu` it returns to the
//! code that asks: to a TLS stack's configuration, for example, which hands them to each session.
//! It is the shape of `codec.Features.detect()`, which a program calls once and passes to each
//! codec's `init`. stdx keeps no copy of the answers (invariant 4).
//!
//! `probe` is the one call in stdx that may make a syscall (invariant 2), because a program makes it
//! once and no codec path runs it: no other stdx module imports this one (invariant 14). Each system
//! answers from its own source:
//! - x86-64, on every system: CPUID leaf 1's ECX. `dit` is `not_known`: x86-64's mode for
//!   data-independent timing, DOITM, is one the operating system sets, and user code cannot read it.
//! - aarch64 Linux: the AT_HWCAP word, through `getauxval`, which reads the auxiliary vector the
//!   kernel wrote into the process's memory at start. No syscall.
//! - aarch64 macOS: `sysctlbyname`, a syscall, one for each feature.
//! - Any other aarch64 system, and an answer the system's source does not give: `yes` for a feature
//!   the build target guarantees, and `not_known` otherwise.
//! - Any other architecture: `not_known`.
//!
//! `probe` only reads. It changes no CPU state, and sets no PSTATE.DIT.
//!
//! The module imports nothing. It runs CPUID itself rather than import `codec`'s, so the module
//! graph gives it no edge.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

pub const constants = @import("constants.zig");

/// One answer about the CPU.
pub const Answer = enum {
    /// The CPU has the feature.
    yes,
    /// The CPU lacks the feature.
    no,
    /// Nothing the program can read says whether the CPU has the feature.
    not_known,
};

/// Every answer `probe` gives.
pub const Cpu = struct {
    /// The AES instructions and a carry-less multiply of two 64-bit values: AES-NI and PCLMULQDQ on
    /// x86-64, the AES instructions and PMULL on aarch64. `yes` only when the CPU has both.
    aes_clmul: Answer,
    /// Arm's FEAT_DIT: the PSTATE.DIT bit, under which the instructions Arm lists take a time that
    /// does not depend on the values they process. `not_known` on x86-64.
    dit: Answer,
};

/// The answers of a source that gives none.
const unanswered: Cpu = .{ .aes_clmul = .not_known, .dit = .not_known };

/// The answers about the CPU this runs on, read from the source its system offers.
pub fn probe() Cpu {
    const cpu: Cpu = switch (builtin.cpu.arch) {
        .x86_64 => from_leaf_1_ecx(cpuid_leaf_1_ecx()),
        .aarch64 => probe_aarch64(),
        else => unanswered,
    };
    // x86-64 has no DIT bit a program can read.
    if (builtin.cpu.arch == .x86_64) assert(cpu.dit == .not_known);
    return cpu;
}

/// `yes` when the source reports the feature, `no` when it reports its absence.
fn answer(present: bool) Answer {
    return if (present) .yes else .no;
}

/// The answer for two features taken together: `no` when either is absent, `yes` when both are
/// present, and `not_known` otherwise.
fn both(first: Answer, second: Answer) Answer {
    if (first == .no or second == .no) return .no;
    if (first == .yes and second == .yes) return .yes;
    return .not_known;
}

/// CPUID leaf 1's ECX. The instruction writes four registers, and `probe` reads ECX alone.
fn cpuid_leaf_1_ecx() u32 {
    comptime assert(builtin.cpu.arch == .x86_64);
    var eax: u32 = undefined;
    var ebx: u32 = undefined;
    var ecx: u32 = undefined;
    var edx: u32 = undefined;
    asm volatile ("cpuid"
        : [eax] "={eax}" (eax),
          [ebx] "={ebx}" (ebx),
          [ecx] "={ecx}" (ecx),
          [edx] "={edx}" (edx),
        : [leaf] "{eax}" (constants.cpuid_leaf_features),
          [subleaf] "{ecx}" (@as(u32, 0)),
    );
    return ecx;
}

/// The answers of CPUID leaf 1's ECX, bits 25 and 1.
fn from_leaf_1_ecx(ecx: u32) Cpu {
    const aes = answer(ecx & constants.ecx_aes != 0);
    const pclmulqdq = answer(ecx & constants.ecx_pclmulqdq != 0);
    return .{ .aes_clmul = both(aes, pclmulqdq), .dit = .not_known };
}

fn probe_aarch64() Cpu {
    comptime assert(builtin.cpu.arch == .aarch64);
    const reading: Reading = switch (builtin.os.tag) {
        .linux => .{ .hwcap = hwcap_word() },
        .macos => .{ .sysctl = .{
            .aes = sysctl_flag(constants.sysctl_aes),
            .pmull = sysctl_flag(constants.sysctl_pmull),
            .dit = sysctl_flag(constants.sysctl_dit),
        } },
        else => .none,
    };
    return from_reading(reading, from_target(builtin.cpu));
}

/// What an aarch64 system's source gave: Linux's AT_HWCAP word, macOS's three sysctl values, or
/// nothing, on a system `probe` has no source for.
const Reading = union(enum) {
    hwcap: usize,
    sysctl: struct { aes: Answer, pmull: Answer, dit: Answer },
    none,
};

/// The answers of what the source gave, with the target's in place of each it does not give.
fn from_reading(reading: Reading, target: Cpu) Cpu {
    const system = switch (reading) {
        .hwcap => |word| from_hwcap(word),
        .sysctl => |values| from_sysctl(values.aes, values.pmull, values.dit),
        .none => unanswered,
    };
    return with_target(system, target);
}

/// Linux's AT_HWCAP word. A program that links libc starts in libc, which keeps the auxiliary
/// vector itself, so Zig's reader finds nothing there; libc's `getauxval` reads the same memory.
fn hwcap_word() usize {
    if (builtin.link_libc) return std.c.getauxval(std.elf.AT_HWCAP);
    return std.os.linux.getauxval(std.elf.AT_HWCAP);
}

/// The answers of Linux's AT_HWCAP word, bits 3, 4 and 24. `getauxval` returns 0 when it finds no
/// AT_HWCAP entry, as Zig's reader does in a program that starts in libc but whose Zig code was
/// built without it. A word of 0 is also a CPU with none of the features Linux reports, and
/// `not_known` is true of both.
fn from_hwcap(word: usize) Cpu {
    if (word == 0) return unanswered;
    const aes = answer(word & constants.hwcap_aes != 0);
    const pmull = answer(word & constants.hwcap_pmull != 0);
    return .{ .aes_clmul = both(aes, pmull), .dit = answer(word & constants.hwcap_dit != 0) };
}

/// The answer of one of macOS's sysctl names, read as a 32-bit integer.
fn sysctl_flag(name: [:0]const u8) Answer {
    comptime assert(builtin.os.tag == .macos);
    var value: i32 = 0;
    var value_len: usize = @sizeOf(i32);
    if (std.c.sysctlbyname(name, &value, &value_len, null, 0) != 0) return .not_known;
    if (value_len != @sizeOf(i32)) return .not_known;
    return from_flag(value);
}

/// A sysctl value of 1 is `yes` and 0 is `no`. Anything else is not a value macOS gives the names
/// `probe` reads, and says nothing.
fn from_flag(value: i32) Answer {
    return switch (value) {
        1 => .yes,
        0 => .no,
        else => .not_known,
    };
}

/// The answers of macOS's FEAT_AES, FEAT_PMULL and FEAT_DIT.
fn from_sysctl(aes: Answer, pmull: Answer, dit: Answer) Cpu {
    return .{ .aes_clmul = both(aes, pmull), .dit = dit };
}

/// What the build target guarantees on aarch64: `yes` for a feature its CPU model has, since a
/// program built for the model runs only on a CPU that has it, and `not_known` for the rest. Zig's
/// `aes` feature holds both the AES instructions and PMULL.
fn from_target(cpu: std.Target.Cpu) Cpu {
    const guaranteed = cpu.arch == .aarch64;
    const has_aes = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .aes);
    const has_dit = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .dit);
    return .{
        .aes_clmul = if (has_aes) .yes else .not_known,
        .dit = if (has_dit) .yes else .not_known,
    };
}

/// The system's answers, with the target's in place of each the system does not give.
fn with_target(system: Cpu, target: Cpu) Cpu {
    return .{
        .aes_clmul = or_target(system.aes_clmul, target.aes_clmul),
        .dit = or_target(system.dit, target.dit),
    };
}

fn or_target(system: Answer, target: Answer) Answer {
    // A target guarantees a feature or says nothing; it never reports an absence.
    assert(target != .no);
    return if (system == .not_known) target else system;
}

// Tests. Each states the bits it sets, so a changed constant fails it.

const testing = std.testing;

test "CPUID leaf 1's ECX answers aes_clmul from bits 25 and 1, and never dit" {
    const yes: Cpu = .{ .aes_clmul = .yes, .dit = .not_known };
    const no: Cpu = .{ .aes_clmul = .no, .dit = .not_known };
    try testing.expectEqual(yes, from_leaf_1_ecx(1 << 25 | 1 << 1));
    try testing.expectEqual(yes, from_leaf_1_ecx(0xffff_ffff));
    try testing.expectEqual(no, from_leaf_1_ecx(1 << 25));
    try testing.expectEqual(no, from_leaf_1_ecx(1 << 1));
    try testing.expectEqual(no, from_leaf_1_ecx(~@as(u32, 1 << 25 | 1 << 1)));
    try testing.expectEqual(no, from_leaf_1_ecx(0));
}

test "the AT_HWCAP word answers aes_clmul from bits 3 and 4, and dit from bit 24" {
    const every: usize = 1 << 3 | 1 << 4 | 1 << 24;
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .yes }, from_hwcap(every));
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .no }, from_hwcap(1 << 3 | 1 << 4));
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .yes }, from_hwcap(1 << 4 | 1 << 24));
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .yes }, from_hwcap(1 << 3 | 1 << 24));
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .no }, from_hwcap(~every));
    try testing.expectEqual(unanswered, from_hwcap(0));
}

test "a sysctl value of 1 is yes, 0 is no, and anything else says nothing" {
    try testing.expectEqual(Answer.yes, from_flag(1));
    try testing.expectEqual(Answer.no, from_flag(0));
    try testing.expectEqual(Answer.not_known, from_flag(2));
    try testing.expectEqual(Answer.not_known, from_flag(-1));
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .no }, from_sysctl(.yes, .yes, .no));
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .yes }, from_sysctl(.yes, .no, .yes));
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .not_known }, from_sysctl(.no, .yes, .not_known));
    try testing.expectEqual(Cpu{ .aes_clmul = .not_known, .dit = .yes }, from_sysctl(.not_known, .yes, .yes));
}

test "two features together are no when either is absent, and yes only when both are present" {
    const answers = [_]Answer{ .yes, .no, .not_known };
    const expected = [3][3]Answer{
        .{ .yes, .no, .not_known },
        .{ .no, .no, .no },
        .{ .not_known, .no, .not_known },
    };
    for (answers, expected) |first, row| {
        for (answers, row) |second, want| try testing.expectEqual(want, both(first, second));
    }
}

test "the target guarantees each aarch64 feature its CPU model has, and nothing else" {
    const models = [_]struct { model: *const std.Target.Cpu.Model, want: Cpu }{
        .{ .model = &std.Target.aarch64.cpu.apple_m1, .want = .{ .aes_clmul = .yes, .dit = .yes } },
        .{ .model = &std.Target.aarch64.cpu.neoverse_n1, .want = .{ .aes_clmul = .yes, .dit = .not_known } },
        .{ .model = &std.Target.aarch64.cpu.neoverse_n2, .want = .{ .aes_clmul = .not_known, .dit = .yes } },
        .{ .model = &std.Target.aarch64.cpu.generic, .want = unanswered },
    };
    for (models) |entry| try testing.expectEqual(entry.want, from_target(entry.model.toCpu(.aarch64)));
    try testing.expectEqual(unanswered, from_target(std.Target.x86.cpu.x86_64_v4.toCpu(.x86_64)));
}

test "the target fills only the answers the system does not give" {
    const target: Cpu = .{ .aes_clmul = .yes, .dit = .not_known };
    try testing.expectEqual(target, with_target(unanswered, target));
    const system: Cpu = .{ .aes_clmul = .no, .dit = .yes };
    try testing.expectEqual(system, with_target(system, target));
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .no }, with_target(.{ .aes_clmul = .not_known, .dit = .no }, target));
}

test "an aarch64 reading answers from its source, and from the target where the source gives nothing" {
    const m1 = from_target(std.Target.aarch64.cpu.apple_m1.toCpu(.aarch64));
    const n1 = from_target(std.Target.aarch64.cpu.neoverse_n1.toCpu(.aarch64));
    // A system with no source answers what the target guarantees.
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .yes }, from_reading(.none, m1));
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .not_known }, from_reading(.none, n1));
    // A word of 0 is no word.
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .not_known }, from_reading(.{ .hwcap = 0 }, n1));
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .yes }, from_reading(.{ .hwcap = 1 << 3 | 1 << 24 }, n1));
    const older_macos: Reading = .{ .sysctl = .{ .aes = .yes, .pmull = .yes, .dit = .not_known } };
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .not_known }, from_reading(older_macos, n1));
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .yes }, from_reading(older_macos, m1));
}

test "the probe on this host answers from its system's source, and holds what the target guarantees" {
    const cpu = probe();
    const target = from_target(builtin.cpu);
    if (target.aes_clmul == .yes) try testing.expectEqual(Answer.yes, cpu.aes_clmul);
    if (target.dit == .yes) try testing.expectEqual(Answer.yes, cpu.dit);
    switch (builtin.cpu.arch) {
        .x86_64 => {
            try testing.expect(cpu.aes_clmul != .not_known);
            try testing.expectEqual(Answer.not_known, cpu.dit);
        },
        .aarch64 => switch (builtin.os.tag) {
            .linux, .macos => try testing.expect(cpu.aes_clmul != .not_known and cpu.dit != .not_known),
            else => try testing.expectEqual(target, cpu),
        },
        else => try testing.expectEqual(unanswered, cpu),
    }
}
