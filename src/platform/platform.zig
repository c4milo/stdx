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
//! - x86-64, on every system: CPUID leaves 1 and 7, and XCR0 through XGETBV when the system has
//!   enabled XSAVE. `dit` is `not_known`: x86-64's mode for data-independent timing, DOITM, is one
//!   the operating system sets, and user code cannot read it. `sha3` is `no`: x86-64 has no SHA-3
//!   instructions.
//! - aarch64, on every system: `ssse3` and `sse4_1` are `no`, as they are x86-64 instructions.
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
    /// The SHA-256 instructions: Arm's FEAT_SHA256, and x86-64's SHA extensions.
    sha256: Answer,
    /// The SHA-512 instructions: Arm's FEAT_SHA512, and x86-64's SHA512, whose YMM registers the
    /// system must save: `yes` there only when it saves the AVX state too.
    sha512: Answer,
    /// The SHA-3 instructions: Arm's FEAT_SHA3 (EOR3, RAX1, XAR and BCAX). `no` on x86-64.
    sha3: Answer,
    /// x86-64's SSSE3, the supplemental SSE3 instructions, which the x86-64 baseline does not
    /// hold. Code for the SHA extensions uses them beside the SHA-256 instructions. `no` on
    /// aarch64.
    ssse3: Answer,
    /// x86-64's SSE4.1, which the x86-64 baseline does not hold either. `no` on aarch64.
    sse4_1: Answer,
};

/// The answers of a source that gives none.
const unanswered: Cpu = .{ .aes_clmul = .not_known, .dit = .not_known, .sha256 = .not_known, .sha512 = .not_known, .sha3 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known };

/// The answers about the CPU this runs on, read from the source its system offers.
pub fn probe() Cpu {
    const cpu: Cpu = switch (builtin.cpu.arch) {
        .x86_64 => from_x86(read_x86()),
        .aarch64 => without_x86(probe_aarch64()),
        else => unanswered,
    };
    // x86-64 has no DIT bit a program can read, and no SHA-3 instructions.
    if (builtin.cpu.arch == .x86_64) assert(cpu.dit == .not_known and cpu.sha3 == .no);
    if (builtin.cpu.arch == .aarch64) assert(cpu.ssse3 == .no and cpu.sse4_1 == .no);
    return cpu;
}

/// An aarch64 CPU's answers, with `no` for the x86-64 instructions, which no source of an aarch64
/// system reports and no aarch64 CPU has.
fn without_x86(cpu: Cpu) Cpu {
    var answers = cpu;
    answers.ssse3 = .no;
    answers.sse4_1 = .no;
    return answers;
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

/// The four registers CPUID writes.
const Registers = struct { eax: u32, ebx: u32, ecx: u32, edx: u32 };

fn cpuid(leaf: u32, subleaf: u32) Registers {
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
        : [leaf] "{eax}" (leaf),
          [subleaf] "{ecx}" (subleaf),
    );
    return .{ .eax = eax, .ebx = ebx, .ecx = ecx, .edx = edx };
}

/// XCR0, the register state the system saves. Only after OSXSAVE says the system enabled XSAVE.
fn xgetbv_0() u64 {
    comptime assert(builtin.cpu.arch == .x86_64);
    var low: u32 = undefined;
    var high: u32 = undefined;
    asm volatile ("xgetbv"
        : [low] "={eax}" (low),
          [high] "={edx}" (high),
        : [register] "{ecx}" (@as(u32, 0)),
    );
    return @as(u64, high) << @bitSizeOf(u32) | low;
}

/// What the x86-64 probe reads: leaf 1's ECX, leaf 7's EBX and its subleaf 1's EAX, and XCR0. A
/// leaf or subleaf past the last one the CPU gives, or XCR0 with XSAVE off, reads as 0.
const X86 = struct { leaf_1_ecx: u32, leaf_7_ebx: u32, leaf_7_1_eax: u32, xcr0: u64 };

fn read_x86() X86 {
    const last_leaf = cpuid(0, 0).eax;
    const leaf_1_ecx = cpuid(constants.cpuid_leaf_features, 0).ecx;
    var reading: X86 = .{ .leaf_1_ecx = leaf_1_ecx, .leaf_7_ebx = 0, .leaf_7_1_eax = 0, .xcr0 = 0 };
    if (last_leaf >= constants.cpuid_leaf_extended) {
        const leaf_7 = cpuid(constants.cpuid_leaf_extended, 0);
        reading.leaf_7_ebx = leaf_7.ebx;
        // Leaf 7's subleaf 0 EAX is the last subleaf the CPU gives.
        if (leaf_7.eax >= 1) reading.leaf_7_1_eax = cpuid(constants.cpuid_leaf_extended, 1).eax;
    }
    if (leaf_1_ecx & constants.ecx_osxsave != 0) reading.xcr0 = xgetbv_0();
    return reading;
}

/// The answers of x86-64's CPUID and XCR0: leaf 1's ECX bits 25 and 1 for `aes_clmul`, 9 for
/// `ssse3` and 19 for `sse4_1`, leaf 7's
/// EBX bit 29 for `sha256`, and its subleaf 1's EAX bit 0 for `sha512`, with leaf 1's AVX and
/// OSXSAVE and XCR0's SSE and AVX state.
fn from_x86(reading: X86) Cpu {
    const aes = answer(reading.leaf_1_ecx & constants.ecx_aes != 0);
    const pclmulqdq = answer(reading.leaf_1_ecx & constants.ecx_pclmulqdq != 0);
    const avx_saved = reading.leaf_1_ecx & (constants.ecx_avx | constants.ecx_osxsave) == constants.ecx_avx | constants.ecx_osxsave and
        reading.xcr0 & constants.xcr0_sse_avx == constants.xcr0_sse_avx;
    return .{
        .aes_clmul = both(aes, pclmulqdq),
        .dit = .not_known,
        .sha256 = answer(reading.leaf_7_ebx & constants.leaf_7_ebx_sha != 0),
        .sha512 = answer(avx_saved and reading.leaf_7_1_eax & constants.leaf_7_1_eax_sha512 != 0),
        .sha3 = .no,
        .ssse3 = answer(reading.leaf_1_ecx & constants.ecx_ssse3 != 0),
        .sse4_1 = answer(reading.leaf_1_ecx & constants.ecx_sse4_1 != 0),
    };
}

fn probe_aarch64() Cpu {
    comptime assert(builtin.cpu.arch == .aarch64);
    const reading: Reading = switch (builtin.os.tag) {
        .linux => .{ .hwcap = hwcap_word() },
        .macos => .{ .sysctl = .{
            .aes = sysctl_flag(constants.sysctl_aes),
            .pmull = sysctl_flag(constants.sysctl_pmull),
            .dit = sysctl_flag(constants.sysctl_dit),
            .sha256 = sysctl_flag(constants.sysctl_sha256),
            .sha512 = sysctl_flag(constants.sysctl_sha512),
            .sha3 = sysctl_flag(constants.sysctl_sha3),
        } },
        else => .none,
    };
    return from_reading(reading, from_target(builtin.cpu));
}

/// What an aarch64 system's source gave: Linux's AT_HWCAP word, macOS's sysctl values, or
/// nothing, on a system `probe` has no source for.
const Reading = union(enum) {
    hwcap: usize,
    sysctl: Sysctl,
    none,
};

/// macOS's values, one for each sysctl name `probe` reads.
const Sysctl = struct { aes: Answer, pmull: Answer, dit: Answer, sha256: Answer, sha512: Answer, sha3: Answer };

/// The answers of what the source gave, with the target's in place of each it does not give.
fn from_reading(reading: Reading, target: Cpu) Cpu {
    const system = switch (reading) {
        .hwcap => |word| from_hwcap(word),
        .sysctl => |values| from_sysctl(values),
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

/// The answers of Linux's AT_HWCAP word, bits 3, 4, 24, 6, 21 and 17. `getauxval` returns 0 when it finds no
/// AT_HWCAP entry, as Zig's reader does in a program that starts in libc but whose Zig code was
/// built without it. A word of 0 is also a CPU with none of the features Linux reports, and
/// `not_known` is true of both.
fn from_hwcap(word: usize) Cpu {
    if (word == 0) return unanswered;
    const aes = answer(word & constants.hwcap_aes != 0);
    const pmull = answer(word & constants.hwcap_pmull != 0);
    return .{
        .aes_clmul = both(aes, pmull),
        .dit = answer(word & constants.hwcap_dit != 0),
        .sha256 = answer(word & constants.hwcap_sha2 != 0),
        .sha512 = answer(word & constants.hwcap_sha512 != 0),
        .sha3 = answer(word & constants.hwcap_sha3 != 0),
        .ssse3 = .not_known,
        .sse4_1 = .not_known,
    };
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

/// The answers of macOS's FEAT_AES, FEAT_PMULL, FEAT_DIT, FEAT_SHA256, FEAT_SHA512 and FEAT_SHA3.
fn from_sysctl(values: Sysctl) Cpu {
    return .{ .aes_clmul = both(values.aes, values.pmull), .dit = values.dit, .sha256 = values.sha256, .sha512 = values.sha512, .sha3 = values.sha3, .ssse3 = .not_known, .sse4_1 = .not_known };
}

/// What the build target guarantees on aarch64: `yes` for a feature its CPU model has, since a
/// program built for the model runs only on a CPU that has it, and `not_known` for the rest. Zig's
/// `aes` feature holds both the AES instructions and PMULL, and its `sha3` both FEAT_SHA512 and
/// FEAT_SHA3.
fn from_target(cpu: std.Target.Cpu) Cpu {
    const guaranteed = cpu.arch == .aarch64;
    const has_aes = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .aes);
    const has_dit = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .dit);
    const has_sha2 = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .sha2);
    const has_sha3 = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .sha3);
    return .{
        .aes_clmul = guarantee(has_aes),
        .dit = guarantee(has_dit),
        .sha256 = guarantee(has_sha2),
        .sha512 = guarantee(has_sha3),
        .sha3 = guarantee(has_sha3),
        .ssse3 = .not_known,
        .sse4_1 = .not_known,
    };
}

/// `yes` for a feature the target guarantees; `not_known` otherwise.
fn guarantee(has: bool) Answer {
    return if (has) .yes else .not_known;
}

/// The system's answers, with the target's in place of each the system does not give.
fn with_target(system: Cpu, target: Cpu) Cpu {
    var cpu: Cpu = undefined;
    inline for (std.meta.fields(Cpu)) |field| @field(cpu, field.name) = or_target(@field(system, field.name), @field(target, field.name));
    return cpu;
}

fn or_target(system: Answer, target: Answer) Answer {
    // A target guarantees a feature or says nothing; it never reports an absence.
    assert(target != .no);
    return if (system == .not_known) target else system;
}

// Tests. Each states the bits it sets, so a changed constant fails it.

const testing = std.testing;

/// A `Cpu` with every SHA answer `sha`: the tests of `aes_clmul` and `dit` vary those alone.
fn cpu_of(aes_clmul: Answer, dit: Answer, sha: Answer) Cpu {
    return .{ .aes_clmul = aes_clmul, .dit = dit, .sha256 = sha, .sha512 = sha, .sha3 = sha, .ssse3 = .not_known, .sse4_1 = .not_known };
}

test "CPUID leaf 1's ECX answers aes_clmul from bits 25 and 1, and never dit" {
    const at = struct {
        fn ecx(value: u32) Cpu {
            return from_x86(.{ .leaf_1_ecx = value, .leaf_7_ebx = 0, .leaf_7_1_eax = 0, .xcr0 = 0 });
        }
    };
    try testing.expectEqual(Answer.yes, at.ecx(1 << 25 | 1 << 1).aes_clmul);
    try testing.expectEqual(Answer.yes, at.ecx(0xffff_ffff).aes_clmul);
    try testing.expectEqual(Answer.no, at.ecx(1 << 25).aes_clmul);
    try testing.expectEqual(Answer.no, at.ecx(1 << 1).aes_clmul);
    try testing.expectEqual(Answer.no, at.ecx(~@as(u32, 1 << 25 | 1 << 1)).aes_clmul);
    try testing.expectEqual(Answer.no, at.ecx(0).aes_clmul);
    for ([_]u32{ 0, 0xffff_ffff, 1 << 25 | 1 << 1 }) |value| try testing.expectEqual(Answer.not_known, at.ecx(value).dit);
}

test "CPUID leaf 1's ECX answers ssse3 from bit 9 and sse4_1 from bit 19" {
    const at = struct {
        fn ecx(value: u32) Cpu {
            return from_x86(.{ .leaf_1_ecx = value, .leaf_7_ebx = 0, .leaf_7_1_eax = 0, .xcr0 = 0 });
        }
    };
    const every = at.ecx(1 << 9 | 1 << 19);
    try testing.expectEqual(Answer.yes, every.ssse3);
    try testing.expectEqual(Answer.yes, every.sse4_1);
    try testing.expectEqual(Answer.no, every.aes_clmul);
    const ssse3 = at.ecx(1 << 9);
    try testing.expectEqual(Answer.yes, ssse3.ssse3);
    try testing.expectEqual(Answer.no, ssse3.sse4_1);
    const sse4_1 = at.ecx(1 << 19);
    try testing.expectEqual(Answer.no, sse4_1.ssse3);
    try testing.expectEqual(Answer.yes, sse4_1.sse4_1);
    const neither = at.ecx(~@as(u32, 1 << 9 | 1 << 19));
    try testing.expectEqual(Answer.no, neither.ssse3);
    try testing.expectEqual(Answer.no, neither.sse4_1);
}

test "an aarch64 CPU answers no for the x86-64 instructions, whatever its source said" {
    const answers = without_x86(unanswered);
    try testing.expectEqual(Answer.no, answers.ssse3);
    try testing.expectEqual(Answer.no, answers.sse4_1);
    try testing.expectEqual(Answer.not_known, answers.sha256);
}

test "CPUID leaf 7 answers sha256 from EBX bit 29, sha512 from subleaf 1 EAX bit 0 with AVX saved, and sha3 no" {
    // leaf 1's ECX with AVX and OSXSAVE, and XCR0 with the SSE and AVX state.
    const avx_ecx: u32 = 1 << 28 | 1 << 27;
    const avx_xcr0: u64 = 1 << 1 | 1 << 2;
    const sha = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = 1 << 29, .leaf_7_1_eax = 1 << 0, .xcr0 = avx_xcr0 });
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .not_known, .sha256 = .yes, .sha512 = .yes, .sha3 = .no, .ssse3 = .no, .sse4_1 = .no }, sha);
    const no_sha256 = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = ~@as(u32, 1 << 29), .leaf_7_1_eax = 1 << 0, .xcr0 = avx_xcr0 });
    try testing.expectEqual(Answer.no, no_sha256.sha256);
    try testing.expectEqual(Answer.yes, no_sha256.sha512);
    const no_sha512 = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = 1 << 29, .leaf_7_1_eax = ~@as(u32, 1 << 0), .xcr0 = avx_xcr0 });
    try testing.expectEqual(Answer.no, no_sha512.sha512);
    // The SHA-512 instructions take YMM registers: without AVX, OSXSAVE or the saved state, no.
    const no_avx = from_x86(.{ .leaf_1_ecx = 1 << 27, .leaf_7_ebx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = avx_xcr0 });
    const no_osxsave = from_x86(.{ .leaf_1_ecx = 1 << 28, .leaf_7_ebx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = avx_xcr0 });
    const no_ymm_state = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = 1 << 1 });
    const no_sse_state = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = 1 << 2 });
    for ([_]Cpu{ no_avx, no_osxsave, no_ymm_state, no_sse_state }) |cpu| try testing.expectEqual(Answer.no, cpu.sha512);
}

test "the AT_HWCAP word answers aes_clmul from bits 3 and 4, and dit from bit 24" {
    const every: usize = 1 << 3 | 1 << 4 | 1 << 24;
    try testing.expectEqual(cpu_of(.yes, .yes, .no), from_hwcap(every));
    try testing.expectEqual(cpu_of(.yes, .no, .no), from_hwcap(1 << 3 | 1 << 4));
    try testing.expectEqual(cpu_of(.no, .yes, .no), from_hwcap(1 << 4 | 1 << 24));
    try testing.expectEqual(cpu_of(.no, .yes, .no), from_hwcap(1 << 3 | 1 << 24));
    try testing.expectEqual(cpu_of(.no, .no, .no), from_hwcap(1 << 5));
    try testing.expectEqual(unanswered, from_hwcap(0));
}

test "the AT_HWCAP word answers sha256 from bit 6, sha512 from bit 21 and sha3 from bit 17" {
    const shas: usize = 1 << 6 | 1 << 21 | 1 << 17;
    try testing.expectEqual(cpu_of(.no, .no, .yes), from_hwcap(shas));
    try testing.expectEqual(cpu_of(.yes, .yes, .no), from_hwcap(~shas));
    const sha256 = from_hwcap(1 << 6);
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .no, .sha256 = .yes, .sha512 = .no, .sha3 = .no, .ssse3 = .not_known, .sse4_1 = .not_known }, sha256);
    const sha512 = from_hwcap(1 << 21);
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .no, .sha256 = .no, .sha512 = .yes, .sha3 = .no, .ssse3 = .not_known, .sse4_1 = .not_known }, sha512);
    const sha3 = from_hwcap(1 << 17);
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .no, .sha256 = .no, .sha512 = .no, .sha3 = .yes, .ssse3 = .not_known, .sse4_1 = .not_known }, sha3);
}

test "a sysctl value of 1 is yes, 0 is no, and anything else says nothing" {
    try testing.expectEqual(Answer.yes, from_flag(1));
    try testing.expectEqual(Answer.no, from_flag(0));
    try testing.expectEqual(Answer.not_known, from_flag(2));
    try testing.expectEqual(Answer.not_known, from_flag(-1));
    const values: Sysctl = .{ .aes = .yes, .pmull = .no, .dit = .yes, .sha256 = .yes, .sha512 = .no, .sha3 = .not_known };
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .yes, .sha256 = .yes, .sha512 = .no, .sha3 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known }, from_sysctl(values));
    const older: Sysctl = .{ .aes = .not_known, .pmull = .yes, .dit = .yes, .sha256 = .not_known, .sha512 = .not_known, .sha3 = .not_known };
    try testing.expectEqual(cpu_of(.not_known, .yes, .not_known), from_sysctl(older));
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
        .{ .model = &std.Target.aarch64.cpu.apple_m1, .want = cpu_of(.yes, .yes, .yes) },
        .{ .model = &std.Target.aarch64.cpu.neoverse_n1, .want = .{ .aes_clmul = .yes, .dit = .not_known, .sha256 = .yes, .sha512 = .not_known, .sha3 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known } },
        .{ .model = &std.Target.aarch64.cpu.neoverse_n2, .want = cpu_of(.not_known, .yes, .not_known) },
        .{ .model = &std.Target.aarch64.cpu.generic, .want = unanswered },
    };
    for (models) |entry| try testing.expectEqual(entry.want, from_target(entry.model.toCpu(.aarch64)));
    try testing.expectEqual(unanswered, from_target(std.Target.x86.cpu.x86_64_v4.toCpu(.x86_64)));
}

test "the target fills only the answers the system does not give" {
    const target = cpu_of(.yes, .not_known, .yes);
    try testing.expectEqual(target, with_target(unanswered, target));
    const system = cpu_of(.no, .yes, .no);
    try testing.expectEqual(system, with_target(system, target));
    try testing.expectEqual(cpu_of(.yes, .no, .yes), with_target(cpu_of(.not_known, .no, .not_known), target));
}

test "an aarch64 reading answers from its source, and from the target where the source gives nothing" {
    const m1 = from_target(std.Target.aarch64.cpu.apple_m1.toCpu(.aarch64));
    const n1 = from_target(std.Target.aarch64.cpu.neoverse_n1.toCpu(.aarch64));
    // A system with no source answers what the target guarantees.
    try testing.expectEqual(m1, from_reading(.none, m1));
    try testing.expectEqual(n1, from_reading(.none, n1));
    // A word of 0 is no word.
    try testing.expectEqual(n1, from_reading(.{ .hwcap = 0 }, n1));
    try testing.expectEqual(cpu_of(.no, .yes, .no), from_reading(.{ .hwcap = 1 << 3 | 1 << 24 }, cpu_of(.not_known, .not_known, .not_known)));
    const older_macos: Reading = .{ .sysctl = .{ .aes = .yes, .pmull = .yes, .dit = .not_known, .sha256 = .not_known, .sha512 = .not_known, .sha3 = .not_known } };
    try testing.expectEqual(cpu_of(.yes, .yes, .yes), from_reading(older_macos, m1));
    try testing.expectEqual(n1, from_reading(older_macos, n1));
}

test "the probe on this host answers from its system's source, and holds what the target guarantees" {
    const cpu = probe();
    const target = from_target(builtin.cpu);
    inline for (std.meta.fields(Cpu)) |field| {
        if (@field(target, field.name) == .yes) try testing.expectEqual(Answer.yes, @field(cpu, field.name));
    }
    switch (builtin.cpu.arch) {
        .x86_64 => {
            try testing.expect(cpu.aes_clmul != .not_known and cpu.sha256 != .not_known and cpu.sha512 != .not_known);
            try testing.expectEqual(Answer.not_known, cpu.dit);
            try testing.expectEqual(Answer.no, cpu.sha3);
            try testing.expect(cpu.ssse3 != .not_known and cpu.sse4_1 != .not_known);
        },
        .aarch64 => switch (builtin.os.tag) {
            .linux => inline for (std.meta.fields(Cpu)) |field| try testing.expect(@field(cpu, field.name) != .not_known),
            .macos => try testing.expect(cpu.aes_clmul != .not_known and cpu.dit != .not_known and cpu.ssse3 == .no and cpu.sse4_1 == .no),
            else => try testing.expectEqual(without_x86(target), cpu),
        },
        else => try testing.expectEqual(unanswered, cpu),
    }
}
