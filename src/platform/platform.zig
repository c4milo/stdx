//! platform: what the CPU a program runs on offers, read once when the program starts
//! (decision 40, design §3).
//!
//! It holds two reads of the CPU, and a program makes each once, at start:
//! - `CpuFeatures.detect()` gives a `CpuFeatures`, the booleans a codec's fast paths read and the
//!   instructions `stdx.crypto` runs. A program passes it to each codec's `init` and to
//!   `crypto.init` (decisions 21 and 40 as amended on 2026-11-25, platform_cpu_features.zig).
//! - `probe()` gives a `Cpu`, the `yes`, `no` and `not_known` answers of the same instructions.
//!   `CpuFeatures` now holds each of them as a boolean, and `probe` stays until the programs
//!   that read a `Cpu` read `CpuFeatures` instead.
//!
//! stdx keeps no copy of either (invariant 4). The codecs import this module for the type
//! `CpuFeatures` alone. Outside it, only a test under `src/` calls `probe` or `CpuFeatures.detect`,
//! and the `cpu-probe` lint rule holds that (decisions 21 and 40 as amended on 2026-11-24,
//! invariant 14).
//!
//! `probe` is the one call in stdx that may make a syscall (invariant 2), because a program makes it
//! once and no codec path runs it. Each system answers from its own source:
//! - x86-64, on every system: CPUID leaves 1 and 7, and XCR0 through XGETBV when the system has
//!   enabled XSAVE. `dit` is `not_known`: x86-64's mode for data-independent timing, DOITM, is one
//!   the operating system sets, and user code cannot read it. `sha3` is `no`: x86-64 has no SHA-3
//!   instructions. `sve2` is `no`, and `midr` is null: MIDR_EL1 is Arm's register.
//!   platform_x86.zig holds this probe.
//! - aarch64, on every system: `ssse3`, `sse4_1`, `avx2` and `vaes` are `no`, as they are x86-64
//!   instructions.
//! - aarch64 Linux: the AT_HWCAP and AT_HWCAP2 words, through `getauxval`, which reads the
//!   auxiliary vector the kernel wrote into the process's memory at start. No syscall. Where
//!   AT_HWCAP has HWCAP_CPUID, `mrs` reads MIDR_EL1, an instruction the kernel emulates.
//! - aarch64 macOS: `sysctlbyname`, a syscall, one for each feature. `midr` is null: macOS gives
//!   a program no read of MIDR_EL1.
//! - Any other aarch64 system, and an answer the system's source does not give: `yes` for a feature
//!   the build target guarantees, and `not_known` otherwise.
//! - Any other architecture: `not_known`.
//!
//! `probe` only reads. It changes no CPU state, and sets no PSTATE.DIT. A program that wants the
//! mode calls `set_data_independent_timing` on each thread, and `data_independent_timing` reads
//! it: one instruction each on arm64, and no syscall (platform_timing.zig).
//!
//! The module imports nothing, so a codec that imports it reaches no other module through it.
//!
//! The module also holds `memset`, a vector `memset` that a program exports from its root on Linux
//! under Zig 0.16, where `memset_applies` holds (platform_memset.zig, decision 41 as amended).
//! Each call to `memset` in the program then runs it: from stdx's modules and from its C code.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

pub const constants = @import("constants.zig");
const platform_x86 = @import("platform_x86.zig");
const platform_linux = @import("platform_linux.zig");
const answer_file = @import("platform_answer.zig");
const memset_file = @import("platform_memset.zig");
const cpu_features_file = @import("platform_cpu_features.zig");
const timing_file = @import("platform_timing.zig");

/// The CPU features a codec's SIMD paths and `stdx.crypto` may use: a program calls
/// `CpuFeatures.detect()` once and passes the value to each codec's `init` and to `crypto.init`
/// (decisions 21 and 40 as amended on 2026-11-25).
pub const CpuFeatures = cpu_features_file.CpuFeatures;

/// Whether the calling thread's timing is data-independent: its PSTATE.DIT on arm64, and false
/// elsewhere (decision 40 as amended on 2026-11-25).
pub const data_independent_timing = timing_file.data_independent_timing;
/// Sets or clears the calling thread's PSTATE.DIT on arm64, and returns false where it cannot.
pub const set_data_independent_timing = timing_file.set_data_independent_timing;

/// A vector `memset`, which a program exports as `memset` where `memset_applies` holds.
pub const memset = memset_file.memset;
/// True on Linux under Zig 0.16, where a program exports `memset`.
pub const memset_applies = memset_file.applies;
const both = answer_file.both;
const unanswered = answer_file.unanswered;

/// One answer about the CPU.
pub const Answer = enum {
    /// The CPU has the feature.
    yes,
    /// The CPU lacks the feature.
    no,
    /// Nothing the program can read says whether the CPU has the feature.
    not_known,
};

/// The fields of Arm's MIDR_EL1, the Main ID Register, as Arm's Architecture Reference Manual names
/// them. A program tells one core from another by its implementer and part.
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
    /// Arm's FEAT_SVE2, the second Scalable Vector Extension, whose XAR rotates the XOR of two
    /// vectors. `no` on x86-64.
    sve2: Answer,
    /// x86-64's SSSE3, the supplemental SSE3 instructions, which the x86-64 baseline does not
    /// hold. Code for the SHA extensions uses them beside the SHA-256 instructions. `no` on
    /// aarch64.
    ssse3: Answer,
    /// x86-64's SSE4.1, which the x86-64 baseline does not hold either. `no` on aarch64.
    sse4_1: Answer,
    /// x86-64's AVX2, whose YMM registers the system must save: `yes` only when it saves the AVX
    /// state too. `no` on aarch64.
    avx2: Answer,
    /// x86-64's VAES and VPCLMULQDQ, the AES rounds and the carry-less multiply on YMM registers.
    /// `yes` only when the CPU has both and `avx2` is `yes`. `no` on aarch64.
    vaes: Answer,
    /// MIDR_EL1 of the core the probe ran on. On a system with cores of more than one kind, a
    /// thread may run on another kind after the probe. null where the system gives a program no
    /// read of it: x86-64, macOS, and Linux without HWCAP_CPUID.
    midr: ?Midr,
};

/// The answers about the CPU this runs on, read from the source its system offers.
pub fn probe() Cpu {
    const cpu: Cpu = switch (builtin.cpu.arch) {
        .x86_64 => platform_x86.from_x86(platform_x86.read_x86()),
        .aarch64 => without_x86(probe_aarch64()),
        else => unanswered,
    };
    // x86-64 has no DIT bit a program can read, no SHA-3 instructions, no SVE2 and no MIDR_EL1.
    if (builtin.cpu.arch == .x86_64) assert(cpu.dit == .not_known and cpu.sha3 == .no);
    if (builtin.cpu.arch == .x86_64) assert(cpu.sve2 == .no and cpu.midr == null);
    if (builtin.cpu.arch == .x86_64) assert(cpu.vaes != .yes or cpu.avx2 == .yes);
    if (builtin.cpu.arch == .aarch64) assert(cpu.ssse3 == .no and cpu.sse4_1 == .no and cpu.avx2 == .no and cpu.vaes == .no);
    return cpu;
}

/// An aarch64 CPU's answers, with `no` for the x86-64 instructions, which no source of an aarch64
/// system reports and no aarch64 CPU has.
fn without_x86(cpu: Cpu) Cpu {
    var answers = cpu;
    answers.ssse3 = .no;
    answers.sse4_1 = .no;
    answers.avx2 = .no;
    answers.vaes = .no;
    return answers;
}

fn probe_aarch64() Cpu {
    comptime assert(builtin.cpu.arch == .aarch64);
    const reading: Reading = switch (builtin.os.tag) {
        .linux => .{ .hwcap = platform_linux.read() },
        .macos => .{ .sysctl = .{
            .aes = sysctl_flag(constants.sysctl_aes),
            .pmull = sysctl_flag(constants.sysctl_pmull),
            .dit = sysctl_flag(constants.sysctl_dit),
            .sha256 = sysctl_flag(constants.sysctl_sha256),
            .sha512 = sysctl_flag(constants.sysctl_sha512),
            .sha3 = sysctl_flag(constants.sysctl_sha3),
            .sve2 = sysctl_flag(constants.sysctl_sve2),
        } },
        else => .none,
    };
    return from_reading(reading, from_target(builtin.cpu));
}

/// What an aarch64 system's source gave: Linux's words and MIDR_EL1, macOS's sysctl values, or
/// nothing, on a system `probe` has no source for.
const Reading = union(enum) {
    hwcap: platform_linux.Hwcap,
    sysctl: Sysctl,
    none,
};

/// macOS's values, one for each sysctl name `probe` reads.
const Sysctl = struct { aes: Answer, pmull: Answer, dit: Answer, sha256: Answer, sha512: Answer, sha3: Answer, sve2: Answer };

/// The answers of what the source gave, with the target's in place of each it does not give.
fn from_reading(reading: Reading, target: Cpu) Cpu {
    const system = switch (reading) {
        .hwcap => |linux| platform_linux.from_linux(linux),
        .sysctl => |values| from_sysctl(values),
        .none => unanswered,
    };
    return with_target(system, target);
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

/// The answers of macOS's FEAT_AES, FEAT_PMULL, FEAT_DIT, FEAT_SHA256, FEAT_SHA512, FEAT_SHA3 and
/// FEAT_SVE2.
fn from_sysctl(values: Sysctl) Cpu {
    return .{ .aes_clmul = both(values.aes, values.pmull), .dit = values.dit, .sha256 = values.sha256, .sha512 = values.sha512, .sha3 = values.sha3, .sve2 = values.sve2, .ssse3 = .not_known, .sse4_1 = .not_known, .avx2 = .not_known, .vaes = .not_known, .midr = null };
}

/// What the build target guarantees on aarch64: `yes` for a feature its CPU model has, since a
/// program built for the model runs only on a CPU that has it, and `not_known` for the rest. Zig's
/// `aes` feature holds both the AES instructions and PMULL, and its `sha3` both FEAT_SHA512 and
/// FEAT_SHA3. A target names no core, so `midr` is null.
fn from_target(cpu: std.Target.Cpu) Cpu {
    const guaranteed = cpu.arch == .aarch64;
    const has_aes = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .aes);
    const has_dit = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .dit);
    const has_sha2 = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .sha2);
    const has_sha3 = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .sha3);
    const has_sve2 = guaranteed and std.Target.aarch64.featureSetHas(cpu.features, .sve2);
    return .{
        .aes_clmul = guarantee(has_aes),
        .dit = guarantee(has_dit),
        .sha256 = guarantee(has_sha2),
        .sha512 = guarantee(has_sha3),
        .sha3 = guarantee(has_sha3),
        .sve2 = guarantee(has_sve2),
        .ssse3 = .not_known,
        .sse4_1 = .not_known,
        .avx2 = .not_known,
        .vaes = .not_known,
        .midr = null,
    };
}

/// `yes` for a feature the target guarantees; `not_known` otherwise.
fn guarantee(has: bool) Answer {
    return if (has) .yes else .not_known;
}

/// The system's answers, with the target's in place of each the system does not give. `midr` is
/// the system's alone.
fn with_target(system: Cpu, target: Cpu) Cpu {
    assert(target.midr == null);
    var cpu = system;
    inline for (std.meta.fields(Cpu)) |field| {
        if (field.type == Answer) @field(cpu, field.name) = or_target(@field(system, field.name), @field(target, field.name));
    }
    return cpu;
}

fn or_target(system: Answer, target: Answer) Answer {
    // A target guarantees a feature or says nothing; it never reports an absence.
    assert(target != .no);
    return if (system == .not_known) target else system;
}

// Tests. Each states the bits it sets, so a changed constant fails it.

const testing = std.testing;

test {
    _ = platform_x86;
    _ = platform_linux;
    _ = memset_file;
    _ = cpu_features_file;
    _ = timing_file;
}

/// A `Cpu` with every SHA answer `sha`: the tests of `aes_clmul` and `dit` vary those alone.
fn cpu_of(aes_clmul: Answer, dit: Answer, sha: Answer) Cpu {
    return .{ .aes_clmul = aes_clmul, .dit = dit, .sha256 = sha, .sha512 = sha, .sha3 = sha, .sve2 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known, .avx2 = .not_known, .vaes = .not_known, .midr = null };
}

/// `cpu` with `sve2` as given.
fn with_sve2(cpu: Cpu, sve2: Answer) Cpu {
    var answers = cpu;
    answers.sve2 = sve2;
    return answers;
}

test "an aarch64 CPU answers no for the x86-64 instructions, whatever its source said" {
    const answers = without_x86(unanswered);
    try testing.expectEqual(Answer.no, answers.ssse3);
    try testing.expectEqual(Answer.no, answers.sse4_1);
    try testing.expectEqual(Answer.no, answers.avx2);
    try testing.expectEqual(Answer.no, answers.vaes);
    try testing.expectEqual(Answer.not_known, answers.sha256);
}

test "a sysctl value of 1 is yes, 0 is no, and anything else says nothing" {
    try testing.expectEqual(Answer.yes, from_flag(1));
    try testing.expectEqual(Answer.no, from_flag(0));
    try testing.expectEqual(Answer.not_known, from_flag(2));
    try testing.expectEqual(Answer.not_known, from_flag(-1));
    const values: Sysctl = .{ .aes = .yes, .pmull = .no, .dit = .yes, .sha256 = .yes, .sha512 = .no, .sha3 = .not_known, .sve2 = .yes };
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .yes, .sha256 = .yes, .sha512 = .no, .sha3 = .not_known, .sve2 = .yes, .ssse3 = .not_known, .sse4_1 = .not_known, .avx2 = .not_known, .vaes = .not_known, .midr = null }, from_sysctl(values));
    const older: Sysctl = .{ .aes = .not_known, .pmull = .yes, .dit = .yes, .sha256 = .not_known, .sha512 = .not_known, .sha3 = .not_known, .sve2 = .not_known };
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
        .{ .model = &std.Target.aarch64.cpu.neoverse_n1, .want = .{ .aes_clmul = .yes, .dit = .not_known, .sha256 = .yes, .sha512 = .not_known, .sha3 = .not_known, .sve2 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known, .avx2 = .not_known, .vaes = .not_known, .midr = null } },
        .{ .model = &std.Target.aarch64.cpu.neoverse_n2, .want = with_sve2(cpu_of(.not_known, .yes, .not_known), .yes) },
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

test "the target fills sve2 where the system says nothing, and the MIDR stays the system's" {
    const n2: Midr = .{ .implementer = 0x41, .variant = 0, .architecture = 0xf, .part = 0xd49, .revision = 0 };
    var system = cpu_of(.yes, .yes, .yes);
    system.midr = n2;
    const target = with_sve2(cpu_of(.not_known, .not_known, .not_known), .yes);
    const cpu = with_target(system, target);
    try testing.expectEqual(Answer.yes, cpu.sve2);
    try testing.expectEqual(n2, cpu.midr.?);
    try testing.expectEqual(Answer.no, with_target(with_sve2(system, .no), target).sve2);
    try testing.expectEqual(null, with_target(cpu_of(.yes, .yes, .yes), target).midr);
}

test "an aarch64 reading answers from its source, and from the target where the source gives nothing" {
    const m1 = from_target(std.Target.aarch64.cpu.apple_m1.toCpu(.aarch64));
    const n1 = from_target(std.Target.aarch64.cpu.neoverse_n1.toCpu(.aarch64));
    // A system with no source answers what the target guarantees.
    try testing.expectEqual(m1, from_reading(.none, m1));
    try testing.expectEqual(n1, from_reading(.none, n1));
    // A word of 0 is no word.
    try testing.expectEqual(n1, from_reading(.{ .hwcap = .{ .word = 0, .word2 = 0, .midr = null } }, n1));
    // An AT_HWCAP word beside an AT_HWCAP2 of 0 is a CPU without SVE2.
    try testing.expectEqual(with_sve2(cpu_of(.no, .yes, .no), .no), from_reading(.{ .hwcap = .{ .word = 1 << 3 | 1 << 24, .word2 = 0, .midr = null } }, cpu_of(.not_known, .not_known, .not_known)));
    const older_macos: Reading = .{ .sysctl = .{ .aes = .yes, .pmull = .yes, .dit = .not_known, .sha256 = .not_known, .sha512 = .not_known, .sha3 = .not_known, .sve2 = .not_known } };
    try testing.expectEqual(cpu_of(.yes, .yes, .yes), from_reading(older_macos, m1));
    try testing.expectEqual(n1, from_reading(older_macos, n1));
}

test "the probe on this host answers from its system's source, and holds what the target guarantees" {
    const cpu = probe();
    const target = from_target(builtin.cpu);
    try expect_target_held(cpu, target);
    switch (builtin.cpu.arch) {
        .x86_64 => try expect_x86_host(cpu),
        .aarch64 => try expect_aarch64_host(cpu, target),
        else => try testing.expectEqual(unanswered, cpu),
    }
}

/// Each feature the target guarantees, `cpu` has.
fn expect_target_held(cpu: Cpu, target: Cpu) !void {
    inline for (std.meta.fields(Cpu)) |field| {
        if (field.type != Answer) continue;
        if (@field(target, field.name) == .yes) try testing.expectEqual(Answer.yes, @field(cpu, field.name));
    }
}

/// An x86-64 host answers each feature but DIT, which no program reads there.
fn expect_x86_host(cpu: Cpu) !void {
    try testing.expect(cpu.aes_clmul != .not_known and cpu.sha256 != .not_known and cpu.sha512 != .not_known);
    try testing.expectEqual(Answer.not_known, cpu.dit);
    try testing.expectEqual(Answer.no, cpu.sha3);
    try testing.expect(cpu.ssse3 != .not_known and cpu.sse4_1 != .not_known);
    try testing.expect(cpu.avx2 != .not_known and cpu.vaes != .not_known);
    try testing.expectEqual(Answer.no, cpu.sve2);
    try testing.expectEqual(null, cpu.midr);
}

/// Linux answers every feature on aarch64, macOS those its sysctl names give, and any other
/// system what the target guarantees.
fn expect_aarch64_host(cpu: Cpu, target: Cpu) !void {
    switch (builtin.os.tag) {
        .linux => inline for (std.meta.fields(Cpu)) |field| {
            if (field.type == Answer) try testing.expect(@field(cpu, field.name) != .not_known);
        },
        .macos => {
            try testing.expect(cpu.aes_clmul != .not_known and cpu.dit != .not_known and cpu.ssse3 == .no and cpu.sse4_1 == .no and cpu.avx2 == .no and cpu.vaes == .no);
            try testing.expectEqual(null, cpu.midr);
        },
        else => try testing.expectEqual(without_x86(target), cpu),
    }
}

test "CpuFeatures.detect agrees with probe on each instruction both read" {
    // probe's `yes` and `no` say what the host's source reports, and `not_known` says nothing, so
    // the test reads the first two alone. On x86-64, CpuFeatures' SHA-256 needs SSSE3 and SSE4.1
    // beside the SHA extensions, and its AES needs the carry-less multiply to answer `aes_clmul`.
    const cpu = probe();
    const features = CpuFeatures.detect();
    const x86_64 = builtin.cpu.arch == .x86_64;
    const carry_less = if (x86_64) features.pclmul else features.pmull;
    try expect_agrees(cpu.aes_clmul, features.aes and carry_less);
    try expect_agrees(if (x86_64) both(both(cpu.sha256, cpu.ssse3), cpu.sse4_1) else cpu.sha256, features.sha256);
    try expect_agrees(cpu.sha512, features.sha512);
    try expect_agrees(cpu.sha3, features.sha3);
    try expect_agrees(cpu.sve2, features.sve2);
    try expect_agrees(cpu.dit, features.dit);
    try expect_agrees(cpu.avx2, features.avx2);
    try expect_agrees(cpu.vaes, features.vaes);
}

/// A feature is true where the probe answers `yes` and false where it answers `no`.
fn expect_agrees(answer: Answer, feature: bool) !void {
    if (answer == .not_known) return;
    try testing.expectEqual(answer == .yes, feature);
}
