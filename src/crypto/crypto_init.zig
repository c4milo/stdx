//! The value a program makes once, when it starts, and calls through (decision 87 as amended on
//! 2026-11-25 and 2026-11-26). It holds the CPU features the program detected once, as its codecs
//! take them, and the random source each session and each signature draws from. A program calls
//! the hashes as `crypto.hash.sha256(...)` and signs as `crypto.jws.sign(...)`, and passes the value
//! to a session's `init`, as it passes an allocator.
//!
//! `init` maps the features to chapulin's descriptions of the CPU once, so a call does no mapping.
//! On arm64 a call reads the calling thread's PSTATE.DIT, one `mrs`, and takes the description that
//! states the timing or the one that does not. No program names chapulin's description.
//!
//! A value, and not a global that one call sets: stdx keeps no process-wide mutable state
//! (non-negotiable 8). So no call can run before the value exists, no two threads race to set it,
//! and a test passes a value of its own.
const std = @import("std");
const builtin = @import("builtin");
const chapulin = @import("chapulin");
const platform = @import("platform");
const hash_file = @import("crypto_hash.zig");
const jws_file = @import("crypto_jws.zig");

/// What `init` returns, which a program calls through.
pub const Context = struct {
    /// chapulin's hashes, HMAC and HKDF: `crypto.hash.sha256(&digest, bytes)`.
    hash: hash_file,
    /// JSON Web Signatures: `crypto.jws.sign(&out, key, input)`.
    jws: jws_file,
    /// The program's one `stdx.platform.CpuFeatures.detect()`, which its codecs take too.
    features: platform.CpuFeatures,
    /// A cryptographically secure random source. chapulin draws each session's secrets and each
    /// signature's noise from it, and from nothing else (its `RAND=session`). `std.Random` wraps
    /// any generator, so stdx cannot check it: src/crypto/README.md shows a program wrap
    /// `io.randomSecure`, which threads may share.
    random: chapulin.tcp.RandomSource,
    /// chapulin's descriptions of the CPU for the TCP object's calls and the QUIC object's, which
    /// `init` makes. stdx's own: a program reads neither, and neither holds a type of chapulin's.
    tcp_description: Description(chapulin.tcp),
    quic_description: Description(chapulin.quic),
};

/// chapulin's description of the CPU for `Object`'s calls: its C value, made once, under the
/// statement of timing and without it, and where the statement comes from.
pub fn Description(comptime Object: type) type {
    return struct {
        const Self = @This();

        /// The program's features, which `on_thread` maps for a call that takes chapulin's
        /// description: a session's `init`, a key reader and a signature.
        features: platform.CpuFeatures,
        /// chapulin's C value (its `cpu_cfg.h`) under the statement and without it, which `init`
        /// computes once, so a hash hands it to the C call with no conversion. 0 in a device
        /// object, which takes none.
        stated_bits: u32,
        unstated_bits: u32,
        statement: Statement,

        /// chapulin's description for the calling thread.
        pub fn on_thread(self: *const Self) Object.Cpu {
            return cpu_of(Object.Cpu, self.features, self.statement.holds(), builtin.cpu.arch);
        }

        /// The C value of the description for the calling thread.
        pub fn bits_on_thread(self: *const Self) u32 {
            return if (self.statement.holds()) self.stated_bits else self.unstated_bits;
        }
    };
}

/// Where the statement of timing comes from, by the architecture and its features.
pub const Statement = enum {
    /// x86-64: stdx states it for every core.
    always,
    /// arm64 without FEAT_DIT, and every other architecture.
    never,
    /// arm64 with FEAT_DIT: the calling thread's PSTATE.DIT.
    thread_dit,

    fn holds(statement: Statement) bool {
        return switch (statement) {
            .always => true,
            .never => false,
            .thread_dit => platform.data_independent_timing(.{ .dit = true }),
        };
    }
};

/// The value a program makes once, from its CPU features and its random source.
pub fn init(features: platform.CpuFeatures, random: chapulin.tcp.RandomSource) Context {
    const tcp = description_of(chapulin.tcp, features, builtin.cpu.arch);
    const context: Context = .{
        .hash = .{ .description = tcp },
        .jws = .{ .description = tcp, .random = random },
        .features = features,
        .random = random,
        .tcp_description = tcp,
        .quic_description = description_of(chapulin.quic, features, builtin.cpu.arch),
    };
    std.debug.assert(context.random.ptr == random.ptr and context.jws.random.ptr == random.ptr);
    return context;
}

/// The descriptions of `Object` for `features` on `arch`.
fn description_of(comptime Object: type, features: platform.CpuFeatures, arch: std.Target.Cpu.Arch) Description(Object) {
    const stated = cpu_of(Object.Cpu, features, true, arch);
    const unstated = cpu_of(Object.Cpu, features, false, arch);
    std.debug.assert(stated.constant_time_multiply and !unstated.constant_time_multiply);
    return .{
        .features = features,
        .stated_bits = bits_of(Object, stated),
        .unstated_bits = bits_of(Object, unstated),
        .statement = statement_of(features, arch),
    };
}

/// chapulin's C value of `cpu`, in a host object, whose options take a description. A device
/// object takes none, and chapulin names its `cpu_bits` there in a compile error.
fn bits_of(comptime Object: type, cpu: Object.Cpu) u32 {
    if (@FieldType(Object.ClientOptions, "cpu") == void) return 0;
    return Object.cpu_bits(cpu);
}

/// chapulin's description of the CPU for the TCP object's calls, on the calling thread.
pub fn tcp_cpu(context: Context) chapulin.tcp.Cpu {
    return context.tcp_description.on_thread();
}

/// chapulin's description of the CPU for the QUIC object's calls, on the calling thread.
/// chapulin compiles its QUIC object apart, so the type is another type with the same fields.
pub fn quic_cpu(context: Context) chapulin.quic.Cpu {
    return context.quic_description.on_thread();
}

/// Where the statement comes from on `arch`.
/// - arm64: the thread's PSTATE.DIT, read where the features hold FEAT_DIT, without which the read
///   faults. A program sets it with `stdx.platform.set_data_independent_timing` on each thread that
///   runs chapulin's code.
/// - x86-64: AES-NI, PCLMULQDQ and the widening multiply are on Intel's list of instructions
///   whose time does not depend on their data, and no program can read DOITM, so stdx states it
///   for every x86-64 core, as the owner ruled on 2026-11-26.
/// - Any other architecture: no statement.
fn statement_of(features: platform.CpuFeatures, arch: std.Target.Cpu.Arch) Statement {
    return switch (arch) {
        .aarch64 => if (features.dit) .thread_dit else .never,
        .x86_64 => .always,
        else => .never,
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
    try testing.expectEqual(Statement.always, statement_of(.{}, .x86_64));
    try testing.expectEqual(Statement.never, statement_of(.{ .dit = true }, .riscv64));
    try testing.expectEqual(Statement.never, statement_of(.{ .dit = false }, .aarch64));
    try testing.expectEqual(Statement.thread_dit, statement_of(.{ .dit = true }, .aarch64));
    try testing.expect(Statement.always.holds() and !Statement.never.holds());
    // arm64 reads the calling thread's mode, which no other host has: there the read is false.
    try testing.expectEqual(platform.data_independent_timing(.{ .dit = true }), Statement.thread_dit.holds());
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
    // The hash and the signer hold the TCP object's descriptions, and the signer the random source.
    try testing.expectEqual(context.tcp_description, context.hash.description);
    try testing.expectEqual(context.tcp_description, context.jws.description);
    try testing.expectEqual(context.random.ptr, context.jws.random.ptr);
}

test "a call takes the description that init made for the thread's statement" {
    var counter: Counter = .{};
    const features = platform.CpuFeatures.detect();
    const context = init(features, counter.source());
    const statement = statement_of(features, builtin.cpu.arch);
    const expected = described(features, statement.holds(), builtin.cpu.arch);
    try testing.expectEqual(expected, tcp_cpu(context));
    // The C values are chapulin's of the descriptions under the statement and without it.
    const stated = chapulin.tcp.cpu_bits(described(features, true, builtin.cpu.arch));
    const unstated = chapulin.tcp.cpu_bits(described(features, false, builtin.cpu.arch));
    try testing.expectEqual(stated, context.tcp_description.stated_bits);
    try testing.expectEqual(unstated, context.tcp_description.unstated_bits);
    try testing.expectEqual(chapulin.tcp.cpu_bits(tcp_cpu(context)), context.tcp_description.bits_on_thread());
    // A statement that holds takes the stated one, and one that does not the other.
    var always = context.tcp_description;
    always.statement = .always;
    try testing.expect(always.on_thread().constant_time_multiply);
    try testing.expectEqual(stated, always.bits_on_thread());
    always.statement = .never;
    try testing.expect(!always.on_thread().constant_time_multiply);
    try testing.expectEqual(unstated, always.bits_on_thread());
}
