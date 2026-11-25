//! The value a program makes once, when it starts, and passes to each call of `stdx.crypto` that
//! runs chapulin's code (decision 87 as amended on 2026-11-25). It holds what the program's one
//! probe found about the CPU, what the program states about its threads, and the random source
//! each session and each signature draws from.
//!
//! A value, and not a global that one call sets: stdx keeps no process-wide mutable state
//! (non-negotiable 8). So no call can run before the value exists, no two threads race to set it,
//! and a test passes a value of its own.
const std = @import("std");
const builtin = @import("builtin");
const chapulin = @import("chapulin");
const platform = @import("platform");

/// The timing mode of the threads that run chapulin's code. Arm's A64 reference lists the AES
/// instructions, PMULL and the widening multiplies as taking a time independent of their data
/// while PSTATE.DIT is 1. Intel's list of data operand independent timing instructions names their
/// x86-64 forms while the operating system has set DOITM. Only the program can state either mode.
/// chapulin sets and reads neither. On arm64 a program sets PSTATE.DIT on each thread with
/// `platform.set_data_independent_timing`, which no library code calls.
pub const Timing = enum {
    /// The program states nothing about its threads' mode. chapulin then runs no instruction whose
    /// timing the statement covers on a secret.
    not_stated,
    /// On arm64, a core with FEAT_DIT whose threads have set PSTATE.DIT. On x86-64, a part on
    /// Intel's list whose operating system has set DOITM.
    data_independent,
};

/// What `init` takes. The program names each field: none has a default.
pub const Options = struct {
    /// The answers of the program's one `stdx.platform.probe()`.
    probe: platform.Cpu,
    /// The mode of every thread that runs chapulin's code.
    timing: Timing,
    /// A cryptographically secure random source. chapulin draws each session's secrets and each
    /// signature's noise from it, and from nothing else (its `RAND=session`).
    random: chapulin.tcp.RandomSource,
};

/// What `init` returns: the description of the CPU in the form each chapulin object takes, and
/// the random source. A program passes `cpu` to the TCP object's sessions and calls, `quic_cpu`
/// to the QUIC object's, and `random` to both.
pub const Context = struct {
    /// The CPU as `tls.Cpu`, for `tls`, `jws`, `dnssec` and the hashes.
    cpu: chapulin.tcp.Cpu,
    /// The CPU as `quic.Cpu`, for `quic`. chapulin compiles its QUIC object apart, so the type is
    /// another type with the same fields.
    quic_cpu: chapulin.quic.Cpu,
    /// The random source of `Options.random`.
    random: chapulin.tcp.RandomSource,
};

/// The value a program makes once from its probe, its statement of timing and its random source.
pub fn init(options: Options) Context {
    const context: Context = .{
        .cpu = cpu_of(chapulin.tcp.Cpu, options, builtin.cpu.arch),
        .quic_cpu = cpu_of(chapulin.quic.Cpu, options, builtin.cpu.arch),
        .random = options.random,
    };
    // The two objects take one description, field for field.
    inline for (@typeInfo(chapulin.tcp.Cpu).@"struct".fields) |field| {
        std.debug.assert(@field(context.cpu, field.name) == @field(context.quic_cpu, field.name));
    }
    std.debug.assert(context.random.ptr == options.random.ptr);
    return context;
}

/// chapulin's description of the CPU (its `cpu_cfg.h`), from the probe's answers and the program's
/// statement of timing. A bit that states timing is set only under `data_independent`. A bit that
/// states presence is set where the probe answers `yes` on the architecture chapulin defines it
/// for, because chapulin refuses a bit its object does not define. `arch` is the target's, and a
/// test passes the other one.
fn cpu_of(comptime Cpu: type, options: Options, arch: std.Target.Cpu.Arch) Cpu {
    const cpu = options.probe;
    const arm64 = arch == .aarch64;
    const x86_64 = arch == .x86_64;
    // A core without FEAT_DIT has no PSTATE.DIT to set, so a statement of `data_independent`
    // there states nothing, and the description fails closed to the code that needs none.
    const stated = options.timing == .data_independent and !(arm64 and cpu.dit == .no);
    // Arm's list under FEAT_DIT names the hash instructions. stdx states their timing on arm64
    // alone, and on x86-64 chapulin hashes in general registers.
    const hash_stated = arm64 and stated;
    return .{
        .constant_time_aes = stated and cpu.aes_clmul == .yes,
        .constant_time_multiply = stated,
        .constant_time_sha256 = hash_stated and cpu.sha256 == .yes,
        .constant_time_sha512 = hash_stated and cpu.sha512 == .yes,
        .constant_time_sha3 = hash_stated and cpu.sha3 == .yes,
        .avx2 = x86_64 and cpu.avx2 == .yes,
        .vaes = x86_64 and cpu.vaes == .yes,
        .sve2 = arm64 and cpu.sve2 == .yes,
    };
}

// Tests.

const testing = std.testing;

/// A probe's answers with every feature `yes` and a core with FEAT_DIT.
const every_feature: platform.Cpu = .{
    .aes_clmul = .yes,
    .dit = .yes,
    .sha256 = .yes,
    .sha512 = .yes,
    .sha3 = .yes,
    .sve2 = .yes,
    .ssse3 = .yes,
    .sse4_1 = .yes,
    .avx2 = .yes,
    .vaes = .yes,
    .midr = null,
};

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

fn described(cpu: platform.Cpu, timing: Timing, arch: std.Target.Cpu.Arch) chapulin.tcp.Cpu {
    var counter: Counter = .{};
    return cpu_of(chapulin.tcp.Cpu, .{ .probe = cpu, .timing = timing, .random = counter.source() }, arch);
}

test "a statement of timing gives the bits of each instruction the probe found" {
    const arm = described(every_feature, .data_independent, .aarch64);
    try testing.expect(arm.constant_time_aes and arm.constant_time_multiply);
    try testing.expect(arm.constant_time_sha256 and arm.constant_time_sha512 and arm.constant_time_sha3);
    try testing.expect(arm.sve2 and !arm.avx2 and !arm.vaes);
    const x86 = described(every_feature, .data_independent, .x86_64);
    try testing.expect(x86.constant_time_aes and x86.constant_time_multiply);
    try testing.expect(!x86.constant_time_sha256 and !x86.constant_time_sha512 and !x86.constant_time_sha3);
    try testing.expect(x86.avx2 and x86.vaes and !x86.sve2);
}

test "no statement of timing gives no bit of timing, and every bit of presence" {
    inline for (.{ .aarch64, .x86_64 }) |arch| {
        const cpu = described(every_feature, .not_stated, arch);
        try testing.expect(!cpu.constant_time_aes and !cpu.constant_time_multiply);
        try testing.expect(!cpu.constant_time_sha256 and !cpu.constant_time_sha512 and !cpu.constant_time_sha3);
        try testing.expectEqual(arch == .aarch64, cpu.sve2);
        try testing.expectEqual(arch == .x86_64, cpu.avx2 and cpu.vaes);
    }
}

test "an answer other than yes gives no bit" {
    var cpu = every_feature;
    cpu.aes_clmul = .not_known;
    cpu.sha256 = .no;
    cpu.sha512 = .not_known;
    cpu.sha3 = .no;
    cpu.avx2 = .not_known;
    cpu.vaes = .no;
    cpu.sve2 = .no;
    const arm = described(cpu, .data_independent, .aarch64);
    try testing.expect(!arm.constant_time_aes and !arm.sve2);
    try testing.expect(!arm.constant_time_sha256 and !arm.constant_time_sha512 and !arm.constant_time_sha3);
    try testing.expect(arm.constant_time_multiply);
    const x86 = described(cpu, .data_independent, .x86_64);
    try testing.expect(!x86.constant_time_aes and !x86.avx2 and !x86.vaes);
    try testing.expect(x86.constant_time_multiply);
}

test "on arm64 a core without FEAT_DIT states no timing" {
    var cpu = every_feature;
    cpu.dit = .no;
    const arm = described(cpu, .data_independent, .aarch64);
    try testing.expect(!arm.constant_time_aes and !arm.constant_time_multiply);
    try testing.expect(!arm.constant_time_sha256 and arm.sve2);
    cpu.dit = .not_known;
    try testing.expect(described(cpu, .data_independent, .aarch64).constant_time_multiply);
    // x86-64 has no FEAT_DIT, and its probe answers `not_known`, so its answer reads nothing.
    cpu.dit = .no;
    try testing.expect(described(cpu, .data_independent, .x86_64).constant_time_aes);
}

test "the value keeps the caller's random source and describes the probed CPU to both objects" {
    var counter: Counter = .{};
    const context = init(.{ .probe = platform.probe(), .timing = .not_stated, .random = counter.source() });
    var bytes: [3]u8 = undefined;
    context.random.bytes(&bytes);
    try testing.expectEqualSlices(u8, &.{ 0, 1, 2 }, &bytes);
    inline for (@typeInfo(chapulin.tcp.Cpu).@"struct".fields) |field| {
        try testing.expectEqual(@field(context.cpu, field.name), @field(context.quic_cpu, field.name));
    }
}
