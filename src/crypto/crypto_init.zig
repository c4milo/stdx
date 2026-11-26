//! The value a program makes once, when it starts, and passes to each call of `stdx.crypto` that
//! runs chapulin's code (decision 87 as amended on 2026-11-25). It holds the CPU features the
//! program detected once, as its codecs take them, and the random source each session and each
//! signature draws from. stdx maps the features to chapulin's description of the CPU at each call,
//! so no program names chapulin's.
//!
//! A value, and not a global that one call sets: stdx keeps no process-wide mutable state
//! (non-negotiable 8). So no call can run before the value exists, no two threads race to set it,
//! and a test passes a value of its own.
const std = @import("std");
const builtin = @import("builtin");
const chapulin = @import("chapulin");
const platform = @import("platform");

/// What `init` returns, and what each call of `stdx.crypto` that runs chapulin's code takes.
pub const Context = struct {
    /// The program's one `stdx.platform.CpuFeatures.detect()`, which its codecs take too.
    features: platform.CpuFeatures,
    /// A cryptographically secure random source. chapulin draws each session's secrets and each
    /// signature's noise from it, and from nothing else (its `RAND=session`).
    random: chapulin.tcp.RandomSource,
};

/// The value a program makes once, from its CPU features and its random source.
pub fn init(features: platform.CpuFeatures, random: chapulin.tcp.RandomSource) Context {
    const context: Context = .{ .features = features, .random = random };
    std.debug.assert(context.random.ptr == random.ptr);
    return context;
}

/// chapulin's description of the CPU for the TCP object's calls, on the calling thread.
pub fn tcp_cpu(context: Context) chapulin.tcp.Cpu {
    const stated = statement(context.features, builtin.cpu.arch);
    return cpu_of(chapulin.tcp.Cpu, context.features, stated, builtin.cpu.arch);
}

/// chapulin's description of the CPU for the QUIC object's calls, on the calling thread.
/// chapulin compiles its QUIC object apart, so the type is another type with the same fields.
pub fn quic_cpu(context: Context) chapulin.quic.Cpu {
    const stated = statement(context.features, builtin.cpu.arch);
    const cpu = cpu_of(chapulin.quic.Cpu, context.features, stated, builtin.cpu.arch);
    std.debug.assert(cpu.constant_time_multiply == stated);
    return cpu;
}

/// Whether the calling thread runs the instructions chapulin's statement covers in constant time.
/// - arm64: the thread's PSTATE.DIT, read where the features hold FEAT_DIT. A program sets it
///   with `stdx.platform.set_data_independent_timing` on each thread that runs chapulin's code.
/// - x86-64: AES-NI, PCLMULQDQ and the widening multiply are on Intel's list of instructions
///   whose time does not depend on their data, and no program can read DOITM, so stdx states it
///   for every x86-64 core.
/// - Any other architecture: no statement.
fn statement(features: platform.CpuFeatures, arch: std.Target.Cpu.Arch) bool {
    return switch (arch) {
        .aarch64 => features.dit and platform.data_independent_timing(features),
        .x86_64 => true,
        else => false,
    };
}

/// chapulin's description of the CPU (its `cpu_cfg.h`), from the program's CPU features and the
/// statement of timing. A bit that states timing is set only under the statement. A bit that
/// states presence is set where the features hold it on the architecture chapulin defines it for,
/// because chapulin refuses a bit its object does not define. `arch` is the target's, and a test
/// passes the other one.
fn cpu_of(comptime Cpu: type, features: platform.CpuFeatures, stated: bool, arch: std.Target.Cpu.Arch) Cpu {
    const arm64 = arch == .aarch64;
    const x86_64 = arch == .x86_64;
    // Arm's list under FEAT_DIT names the hash instructions. stdx states their timing on arm64
    // alone, and on x86-64 chapulin hashes in general registers.
    const hash_stated = arm64 and stated;
    // FEAT_SHA3 names EOR3, RAX1, XAR and BCAX. The EOR3 bit states EOR3 alone, which AES-GCM's
    // passes run, and the SHA-3 bit all four, which Keccak runs (chapulin's decision 244).
    const sha3_stated = hash_stated and features.sha3;
    // AES-GCM runs the carry-less multiply beside AES's rounds: PMULL on arm64, PCLMULQDQ on
    // x86-64.
    const carry_less = if (arm64) features.pmull else features.pclmul;
    return .{
        .constant_time_aes = stated and features.aes and carry_less,
        .constant_time_multiply = stated,
        .constant_time_sha256 = hash_stated and features.sha256,
        .constant_time_sha512 = hash_stated and features.sha512,
        .constant_time_sha3 = sha3_stated and !keccak_slow(features.midr),
        .constant_time_eor3 = sha3_stated,
        .avx2 = x86_64 and features.avx2,
        .vaes = x86_64 and features.vaes,
        .sve2 = arm64 and features.sve2,
    };
}

/// Arm's code for itself in MIDR_EL1's implementer field, and its Neoverse N2's part.
const arm_implementer = 0x41;
const neoverse_n2_part = 0xd49;

/// Whether the core runs Keccak slower on its SHA-3 instructions than in its general registers:
/// Arm's Neoverse N2, 1.8 times slower, where chapulin's decision 240 asks a caller to leave the
/// SHA-3 bit clear. A core whose system gives no MIDR_EL1 keeps the bit.
fn keccak_slow(midr: ?platform.Midr) bool {
    const core = midr orelse return false;
    return core.implementer == arm_implementer and core.part == neoverse_n2_part;
}

// Tests.

const testing = std.testing;

/// CPU features with every instruction `cpu_of` reads, on both architectures.
const every_feature: platform.CpuFeatures = .{
    .aes = true,
    .pclmul = true,
    .pmull = true,
    .dit = true,
    .sha256 = true,
    .sha512 = true,
    .sha3 = true,
    .sve2 = true,
    .avx2 = true,
    .vaes = true,
};

fn described(features: platform.CpuFeatures, stated: bool, arch: std.Target.Cpu.Arch) chapulin.tcp.Cpu {
    return cpu_of(chapulin.tcp.Cpu, features, stated, arch);
}

test "a statement of timing gives the bits of each instruction the features hold" {
    const arm = described(every_feature, true, .aarch64);
    try testing.expect(arm.constant_time_aes and arm.constant_time_multiply);
    try testing.expect(arm.constant_time_sha256 and arm.constant_time_sha512 and arm.constant_time_sha3);
    try testing.expect(arm.sve2 and !arm.avx2 and !arm.vaes);
    const x86 = described(every_feature, true, .x86_64);
    try testing.expect(x86.constant_time_aes and x86.constant_time_multiply);
    try testing.expect(!x86.constant_time_sha256 and !x86.constant_time_sha512 and !x86.constant_time_sha3);
    try testing.expect(x86.avx2 and x86.vaes and !x86.sve2);
}

test "no statement of timing gives no bit of timing, and every bit of presence" {
    inline for (.{ .aarch64, .x86_64 }) |arch| {
        const cpu = described(every_feature, false, arch);
        try testing.expect(!cpu.constant_time_aes and !cpu.constant_time_multiply);
        try testing.expect(!cpu.constant_time_sha256 and !cpu.constant_time_sha512 and !cpu.constant_time_sha3);
        try testing.expectEqual(arch == .aarch64, cpu.sve2);
        try testing.expectEqual(arch == .x86_64, cpu.avx2 and cpu.vaes);
    }
}

test "a feature the CPU lacks gives no bit" {
    var features = every_feature;
    features.aes = false;
    features.sha256 = false;
    features.sha512 = false;
    features.sha3 = false;
    features.avx2 = false;
    features.vaes = false;
    features.sve2 = false;
    const arm = described(features, true, .aarch64);
    try testing.expect(!arm.constant_time_aes and !arm.sve2);
    try testing.expect(!arm.constant_time_sha256 and !arm.constant_time_sha512 and !arm.constant_time_sha3);
    try testing.expect(arm.constant_time_multiply);
    const x86 = described(features, true, .x86_64);
    try testing.expect(!x86.constant_time_aes and !x86.avx2 and !x86.vaes);
    try testing.expect(x86.constant_time_multiply);
}

test "an N2 keeps EOR3's bit and loses the SHA-3 bit, and every other core keeps both" {
    var n2 = every_feature;
    n2.midr = .{ .implementer = 0x41, .variant = 0, .architecture = 0xf, .part = 0xd49, .revision = 0 };
    const on_n2 = described(n2, true, .aarch64);
    try testing.expect(on_n2.constant_time_eor3 and !on_n2.constant_time_sha3 and on_n2.constant_time_aes);
    // Another Arm part, an Apple core and a system that gives no MIDR_EL1 keep both bits.
    var n1 = n2;
    n1.midr.?.part = 0xd0c;
    var apple = n2;
    apple.midr.?.implementer = 0x61;
    for ([_]platform.CpuFeatures{ n1, apple, every_feature }) |features| {
        const cpu = described(features, true, .aarch64);
        try testing.expect(cpu.constant_time_eor3 and cpu.constant_time_sha3);
    }
    // Neither bit without the statement, without FEAT_SHA3, or on x86-64.
    try testing.expect(!described(n1, false, .aarch64).constant_time_eor3);
    var no_sha3 = n1;
    no_sha3.sha3 = false;
    try testing.expect(!described(no_sha3, true, .aarch64).constant_time_eor3);
    try testing.expect(!described(n1, true, .x86_64).constant_time_eor3);
}

test "AES's bit needs the carry-less multiply of its own architecture" {
    var no_pmull = every_feature;
    no_pmull.pmull = false;
    try testing.expect(!described(no_pmull, true, .aarch64).constant_time_aes);
    try testing.expect(described(no_pmull, true, .x86_64).constant_time_aes);
    var no_pclmul = every_feature;
    no_pclmul.pclmul = false;
    try testing.expect(!described(no_pclmul, true, .x86_64).constant_time_aes);
    try testing.expect(described(no_pclmul, true, .aarch64).constant_time_aes);
}

test "x86-64 states its timing, arm64 states the thread's PSTATE.DIT, and another states none" {
    try testing.expect(statement(.{}, .x86_64));
    try testing.expect(!statement(.{}, .riscv64));
    try testing.expect(!statement(.{ .dit = false }, .aarch64));
    // arm64 reads the calling thread's mode, which no other host has: there the read is false.
    const features = platform.CpuFeatures.detect();
    const read = platform.data_independent_timing(features);
    try testing.expectEqual(read, statement(features, .aarch64));
    if (builtin.cpu.arch != .aarch64) try testing.expect(!statement(.{ .dit = true }, .aarch64));
}

/// A fixed source for the tests, which writes the bytes of a counter. It is no random source.
const Counter = struct {
    count: u8 = 0,

    fn fill(pointer: *anyopaque, bytes: []u8) void {
        const counter: *Counter = @ptrCast(@alignCast(pointer));
        for (bytes) |*byte| {
            byte.* = counter.count;
            counter.count +%= 1;
        }
    }

    fn source(counter: *Counter) chapulin.tcp.RandomSource {
        return .{ .ptr = counter, .fillFn = fill };
    }
};

test "the value keeps the program's features and random source, and both objects get one description" {
    var counter: Counter = .{};
    const features = platform.CpuFeatures.detect();
    const context = init(features, counter.source());
    try testing.expectEqual(features, context.features);
    var bytes: [3]u8 = undefined;
    context.random.bytes(&bytes);
    try testing.expectEqualSlices(u8, &.{ 0, 1, 2 }, &bytes);
    const tcp = tcp_cpu(context);
    const quic = quic_cpu(context);
    inline for (@typeInfo(chapulin.tcp.Cpu).@"struct".fields) |field| {
        try testing.expectEqual(@field(tcp, field.name), @field(quic, field.name));
    }
}
