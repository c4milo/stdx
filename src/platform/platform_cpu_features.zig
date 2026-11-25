//! The CPU features a codec's SIMD paths may use, detected at run time (decision 21). The type
//! is `platform.CpuFeatures` (decisions 21 and 40 as amended on 2026-11-24).
//!
//! The caller calls `CpuFeatures.detect()` once and passes the value to each codec's `init`, which
//! keeps it in the codec's state; stdx keeps no copy of its own (invariant 4). A caller may pass
//! `CpuFeatures.target()`, what the build target guarantees, to skip detection, and a test may pass
//! any set, `CpuFeatures.none()` included, to reach every path the host supports. A codec names
//! the type and never calls `detect`. Outside this module, only a test under `src/` calls it, and
//! the `cpu-probe` lint rule holds that (invariant 14).
//!
//! Detection reads no file and makes no syscall (invariant 2). On x86-64 it runs the CPUID and
//! XGETBV instructions. On aarch64 Linux it reads the kernel's hardware capability word through
//! `getauxval`, Zig's or libc's, which reads the auxiliary vector the kernel wrote into the
//! process's memory at start. Every aarch64 Mac has the CRC32 and PMULL instructions. Elsewhere, detection
//! gives the build target's features.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const x86_file = @import("platform_cpu_features_x86.zig");

pub const CpuFeatures = struct {
    /// x86-64: SSSE3's PSHUFB, a lookup of 16 entries for each of 16 lanes, which needs no
    /// register the operating system saves beyond SSE2's.
    ssse3: bool = false,
    /// x86-64: PCLMULQDQ, with SSE4.1.
    pclmul: bool = false,
    /// x86-64: AVX2, with the operating system saving the YMM registers.
    avx2: bool = false,
    /// x86-64: AVX-512 F, BW, DQ and VL, with the operating system saving the ZMM registers: the
    /// features the AVX-512 variant objects are compiled for (decision 21).
    avx512: bool = false,
    /// x86-64: VPCLMULQDQ, carry-less multiplication on YMM and ZMM registers.
    vpclmul: bool = false,
    /// x86-64: AVX512_VNNI's VPDPBUSD, dot products of octets, with the ZMM registers saved.
    vnni: bool = false,
    /// x86-64: BMI2's SHLX, SHRX and BZHI, with SSSE3's PSHUFB: what the Zstandard decoder's x86-64
    /// assembly runs (decision 23). Neither needs the operating system to save a register.
    bmi2: bool = false,
    /// x86-64: VPMULLQ, AVX-512 DQ's multiply of 64-bit lanes, as fast as a scalar multiply. It
    /// chooses a path rather than naming an instruction: an AMD CPU with AVX-512, Zen 4 or later,
    /// takes 3 cycles, and Intel's take about 15 (design §8 step 10, decision 21).
    vpmullq_fast: bool = false,
    /// x86-64: an Intel CPU, on which the DEFLATE encoder's level 6 runs its assembly loop
    /// (decision 54). It chooses a path rather than naming an instruction, as `vpmullq_fast` does:
    /// the loop ran Intel's Xeons faster and AMD's EPYC 7763 slower. No build target sets it.
    lazy_loop_fast: bool = false,
    /// aarch64: the CRC32 instructions, whose polynomial is gzip's (RFC 1952 §8).
    crc32: bool = false,
    /// aarch64: PMULL, polynomial multiplication of 64-bit lanes.
    pmull: bool = false,
    /// aarch64: the DotProd extension's UDOT and SDOT, dot products of octets.
    dotprod: bool = false,
    /// aarch64: MADD's addend waits for its multiply, so a chain of values through the addend takes
    /// the multiply's latency at each step, as on Apple's M-series cores. It chooses a path rather
    /// than naming an instruction: XXH64's round is such a chain, which its aarch64 path breaks, at
    /// no gain on a Neoverse N2 (design §8 step 10, decision 21).
    madd_addend_slow: bool = false,
    /// AES's round instructions: AES-NI on x86-64, FEAT_AES on aarch64. The carry-less multiply
    /// beside them is `pclmul` or `pmull`.
    aes: bool = false,
    /// The SHA-256 instructions: x86-64's SHA extensions with SSSE3 and SSE4.1, which code for
    /// them uses beside them, and aarch64's FEAT_SHA256.
    sha256: bool = false,
    /// The SHA-512 instructions: x86-64's SHA512, with the operating system saving the YMM
    /// registers, and aarch64's FEAT_SHA512.
    sha512: bool = false,
    /// aarch64: FEAT_SHA3, the SHA-3 instructions EOR3, RAX1, XAR and BCAX.
    sha3: bool = false,
    /// aarch64: FEAT_SVE2, the second Scalable Vector Extension, whose XAR rotates the XOR of two
    /// vectors.
    sve2: bool = false,
    /// aarch64: FEAT_DIT, the PSTATE.DIT bit, under which the instructions Arm lists take a time
    /// that does not depend on the values they process. `data_independent_timing` reads a thread's
    /// bit, and `set_data_independent_timing` sets it.
    dit: bool = false,
    /// x86-64: VAES and VPCLMULQDQ on the YMM registers, with `avx2`.
    vaes: bool = false,

    /// No feature: every codec takes its scalar paths.
    pub fn none() CpuFeatures {
        return .{};
    }

    /// The features the build target guarantees, known at compile time.
    pub fn target() CpuFeatures {
        return comptime from_target(builtin.cpu);
    }

    /// The features of the CPU this runs on. Never fewer than `target()`, since a program built
    /// for more than the CPU has would not run.
    pub fn detect() CpuFeatures {
        return detect_cpu().with(target());
    }

    /// The features both sets hold.
    pub fn intersect(self: CpuFeatures, other: CpuFeatures) CpuFeatures {
        var result: CpuFeatures = .{};
        inline for (std.meta.fields(CpuFeatures)) |field| {
            @field(result, field.name) = @field(self, field.name) and @field(other, field.name);
        }
        return result;
    }

    /// The features either set holds.
    pub fn with(self: CpuFeatures, other: CpuFeatures) CpuFeatures {
        var result: CpuFeatures = .{};
        inline for (std.meta.fields(CpuFeatures)) |field| {
            @field(result, field.name) = @field(self, field.name) or @field(other, field.name);
        }
        return result;
    }
};

/// The features detection finds, before the target's are added.
fn detect_cpu() CpuFeatures {
    return switch (builtin.cpu.arch) {
        .x86_64 => x86_file.detect(),
        .aarch64 => detect_aarch64(),
        else => CpuFeatures.target(),
    };
}

fn from_target(cpu: std.Target.Cpu) CpuFeatures {
    return switch (cpu.arch) {
        .x86_64 => .{
            .ssse3 = has_x86(cpu, .ssse3),
            .pclmul = has_x86(cpu, .pclmul) and has_x86(cpu, .sse4_1),
            .avx2 = has_x86(cpu, .avx2),
            .bmi2 = has_x86(cpu, .bmi2) and has_x86(cpu, .ssse3),
            .avx512 = has_avx512(cpu),
            .vpmullq_fast = has_avx512(cpu) and std.mem.startsWith(u8, cpu.model.name, amd_model_prefix),
            .vpclmul = has_x86(cpu, .vpclmulqdq),
            .vnni = has_x86(cpu, .avx512vnni),
            .aes = has_x86(cpu, .aes),
            .sha256 = has_x86(cpu, .sha) and has_x86(cpu, .ssse3) and has_x86(cpu, .sse4_1),
            .sha512 = has_x86(cpu, .sha512) and has_x86(cpu, .avx),
            .vaes = has_x86(cpu, .vaes) and has_x86(cpu, .vpclmulqdq) and has_x86(cpu, .avx2),
        },
        .aarch64 => .{
            .crc32 = std.Target.aarch64.featureSetHas(cpu.features, .crc),
            .pmull = std.Target.aarch64.featureSetHas(cpu.features, .aes),
            .dotprod = std.Target.aarch64.featureSetHas(cpu.features, .dotprod),
            .madd_addend_slow = std.mem.startsWith(u8, cpu.model.name, apple_model_prefix),
            .aes = has_aarch64(cpu, .aes),
            .sha256 = has_aarch64(cpu, .sha2),
            // Zig's `sha3` names FEAT_SHA512 and FEAT_SHA3 together.
            .sha512 = has_aarch64(cpu, .sha3),
            .sha3 = has_aarch64(cpu, .sha3),
            .sve2 = has_aarch64(cpu, .sve2),
            .dit = has_aarch64(cpu, .dit),
        },
        else => .{},
    };
}

/// The prefix of Zig's names for Apple's cores.
const apple_model_prefix = "apple_";

fn has_x86(cpu: std.Target.Cpu, feature: std.Target.x86.Feature) bool {
    return std.Target.x86.featureSetHas(cpu.features, feature);
}

fn has_aarch64(cpu: std.Target.Cpu, feature: std.Target.aarch64.Feature) bool {
    return std.Target.aarch64.featureSetHas(cpu.features, feature);
}

fn has_avx512(cpu: std.Target.Cpu) bool {
    return has_x86(cpu, .avx512f) and has_x86(cpu, .avx512bw) and has_x86(cpu, .avx512dq) and has_x86(cpu, .avx512vl);
}

/// The prefix of Zig's names for AMD's Zen cores, the only x86-64 models a target names by vendor.
const amd_model_prefix = "znver";

/// The bits of Linux's arm64 hardware capability words that detection reads.
const hwcap = struct {
    // Bits 4, 7 and 20 of AT_HWCAP.
    const pmull = 0x10;
    const crc32 = 0x80;
    const dotprod = 0x10_0000;
    // Bits 3, 6, 21, 17 and 24 of AT_HWCAP, and bit 1 of AT_HWCAP2, which `probe` reads too.
    const aes = constants.hwcap_aes;
    const sha2 = constants.hwcap_sha2;
    const sha512 = constants.hwcap_sha512;
    const sha3 = constants.hwcap_sha3;
    const dit = constants.hwcap_dit;
    const sve2 = constants.hwcap2_sve2;
};

fn detect_aarch64() CpuFeatures {
    if (builtin.cpu.arch != .aarch64) unreachable;
    return switch (builtin.os.tag) {
        .linux => from_hwcap(hwcap_word(std.elf.AT_HWCAP), hwcap_word(std.elf.AT_HWCAP2)),
        // Every aarch64 Mac is an Apple M-series part, which has these and whose MADD's addend
        // waits for its multiply. No M-series part has SVE2 outside SME's streaming mode.
        .macos => .{
            .crc32 = true,
            .pmull = true,
            .dotprod = true,
            .madd_addend_slow = true,
            .aes = true,
            .sha256 = true,
            .sha512 = true,
            .sha3 = true,
            .dit = true,
        },
        else => CpuFeatures.target(),
    };
}

/// One of Linux's hardware capability words, AT_HWCAP or AT_HWCAP2. A program that links libc
/// starts in libc, which keeps the auxiliary vector itself, so Zig's own reader of it, which the
/// Zig start code fills, finds nothing there; libc's getauxval reads the same memory.
fn hwcap_word(entry: usize) usize {
    if (builtin.link_libc) return std.c.getauxval(entry);
    return std.os.linux.getauxval(entry);
}

/// The features of Linux's AT_HWCAP word, and of its AT_HWCAP2 word, `word2`, for SVE2.
fn from_hwcap(word: usize, word2: usize) CpuFeatures {
    return .{
        .crc32 = word & hwcap.crc32 != 0,
        .pmull = word & hwcap.pmull != 0,
        .dotprod = word & hwcap.dotprod != 0,
        .aes = word & hwcap.aes != 0,
        .sha256 = word & hwcap.sha2 != 0,
        .sha512 = word & hwcap.sha512 != 0,
        .sha3 = word & hwcap.sha3 != 0,
        .dit = word & hwcap.dit != 0,
        .sve2 = word2 & hwcap.sve2 != 0,
    };
}

// Tests.

const testing = std.testing;

test {
    _ = x86_file;
}

test "detection alone finds at least what the target guarantees" {
    // The target's features are those of the CPU the tests run on, or fewer, so detection must
    // find each of them without `detect` adding them.
    const target_features = CpuFeatures.target();
    try testing.expectEqual(target_features, detect_cpu().intersect(target_features));
    try testing.expectEqual(target_features, CpuFeatures.detect().intersect(target_features));
}

test "none holds nothing, and intersect and with combine field by field" {
    try testing.expectEqual(CpuFeatures{}, CpuFeatures.none());
    const left: CpuFeatures = .{ .pclmul = true, .avx2 = true };
    const right: CpuFeatures = .{ .avx2 = true, .crc32 = true };
    try testing.expectEqual(CpuFeatures{ .avx2 = true }, left.intersect(right));
    try testing.expectEqual(CpuFeatures{ .pclmul = true, .avx2 = true, .crc32 = true }, left.with(right));
}

test "an Apple core's target has MADD's slow addend, and a Neoverse N2's does not" {
    try testing.expect(from_target(std.Target.aarch64.cpu.apple_m1.toCpu(.aarch64)).madd_addend_slow);
    try testing.expect(!from_target(std.Target.aarch64.cpu.neoverse_n2.toCpu(.aarch64)).madd_addend_slow);
}

test "the hardware capability word maps CRC32 and PMULL" {
    try testing.expectEqual(CpuFeatures{ .crc32 = true, .pmull = true }, from_hwcap(0b1001_0000, 0));
    try testing.expectEqual(CpuFeatures{ .crc32 = true }, from_hwcap(0b1000_0000, 0));
    try testing.expectEqual(CpuFeatures{ .dotprod = true }, from_hwcap(0x10_0000, 0));
    // Every other bit of the first 25 maps to nothing.
    const mapped = hwcap.crc32 | hwcap.pmull | hwcap.dotprod | hwcap.aes | hwcap.sha2 | hwcap.sha512 | hwcap.sha3 | hwcap.dit;
    try testing.expectEqual(CpuFeatures{}, from_hwcap(0x1ff_ffff & ~@as(usize, mapped), ~@as(usize, hwcap.sve2)));
}

test "the hardware capability words map the instructions of stdx.crypto, each from its own bit" {
    try testing.expectEqual(CpuFeatures{ .aes = true }, from_hwcap(hwcap.aes, 0));
    try testing.expectEqual(CpuFeatures{ .sha256 = true }, from_hwcap(hwcap.sha2, 0));
    try testing.expectEqual(CpuFeatures{ .sha512 = true }, from_hwcap(hwcap.sha512, 0));
    try testing.expectEqual(CpuFeatures{ .sha3 = true }, from_hwcap(hwcap.sha3, 0));
    try testing.expectEqual(CpuFeatures{ .dit = true }, from_hwcap(hwcap.dit, 0));
    try testing.expectEqual(CpuFeatures{ .sve2 = true }, from_hwcap(0, hwcap.sve2));
    // AT_HWCAP2's bit names SVE2 there alone, and AT_HWCAP's bit 1 is not it.
    try testing.expect(!from_hwcap(hwcap.sve2, 0).sve2);
}

test "the targets of an Apple M1 and a Neoverse N2 give the instructions of stdx.crypto they have" {
    const m1 = from_target(std.Target.aarch64.cpu.apple_m1.toCpu(.aarch64));
    try testing.expect(m1.aes and m1.sha256 and m1.sha512 and m1.sha3 and m1.dit and !m1.sve2);
    const n2 = from_target(std.Target.aarch64.cpu.neoverse_n2.toCpu(.aarch64));
    try testing.expect(n2.sve2 and n2.dit);
    // A Cortex-A72 has FEAT_SHA256 and no FEAT_SHA512: Zig names the second `sha3`.
    const a72 = from_target(std.Target.aarch64.cpu.cortex_a72.toCpu(.aarch64));
    try testing.expect(a72.aes and a72.sha256 and !a72.sha512 and !a72.sha3 and !a72.dit);
    const x86_64 = from_target(std.Target.x86.cpu.x86_64.toCpu(.x86_64));
    try testing.expect(!x86_64.aes and !x86_64.sha256 and !x86_64.sha512 and !x86_64.vaes);
    const zen4 = from_target(std.Target.x86.cpu.znver4.toCpu(.x86_64));
    try testing.expect(zen4.aes and zen4.sha256 and zen4.vaes and !zen4.sha3 and !zen4.dit);
}

test "the target's SSSE3 counts alone, and its BMI2 only with SSSE3" {
    var cpu = std.Target.x86.cpu.x86_64.toCpu(.x86_64);
    try testing.expect(!from_target(cpu).ssse3);
    cpu.features.addFeature(@intFromEnum(std.Target.x86.Feature.bmi2));
    try testing.expect(!from_target(cpu).bmi2);
    cpu.features.addFeature(@intFromEnum(std.Target.x86.Feature.ssse3));
    try testing.expect(from_target(cpu).bmi2);
    try testing.expect(from_target(cpu).ssse3);
}

test "detection on this host finds what its architecture's feature set should" {
    const detected = CpuFeatures.detect();
    switch (builtin.cpu.arch) {
        .aarch64 => if (builtin.os.tag == .macos) {
            try testing.expect(detected.crc32 and detected.pmull and detected.dotprod and detected.madd_addend_slow);
            try testing.expect(detected.aes and detected.sha256 and detected.sha512 and detected.sha3 and detected.dit);
        },
        .x86_64 => try testing.expect(!detected.crc32 and !detected.pmull and !detected.dotprod and !detected.sha3 and !detected.sve2 and !detected.dit),
        else => try testing.expectEqual(CpuFeatures.target(), detected),
    }
}
