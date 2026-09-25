//! The CPU features a codec's SIMD paths may use, detected at run time (decision 21).
//!
//! The caller calls `Features.detect()` once and passes the value to each codec's `init`, which
//! keeps it in the codec's state; stdx keeps no copy of its own (invariant 4). A caller may pass
//! `Features.target()`, what the build target guarantees, to skip detection, and a test may pass
//! any set, `Features.none()` included, to reach every path the host supports.
//!
//! Detection reads no file and makes no syscall (invariant 2). On x86-64 it runs the CPUID and
//! XGETBV instructions. On aarch64 Linux it reads the kernel's hardware capability word through
//! `std.os.linux.getauxval`, which reads the auxiliary vector the kernel wrote into the process's
//! memory at start. Every aarch64 Mac has the CRC32 and PMULL instructions. Elsewhere, detection
//! gives the build target's features.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

pub const Features = struct {
    /// x86-64: PCLMULQDQ, with SSE4.1.
    pclmul: bool = false,
    /// x86-64: AVX2, with the operating system saving the YMM registers.
    avx2: bool = false,
    /// x86-64: AVX-512 F, BW and VL, with the operating system saving the ZMM registers.
    avx512: bool = false,
    /// x86-64: VPCLMULQDQ, carry-less multiplication on YMM and ZMM registers.
    vpclmul: bool = false,
    /// aarch64: the CRC32 instructions, whose polynomial is gzip's (RFC 1952 §8).
    crc32: bool = false,
    /// aarch64: PMULL, polynomial multiplication of 64-bit lanes.
    pmull: bool = false,

    /// No feature: every codec takes its scalar paths.
    pub fn none() Features {
        return .{};
    }

    /// The features the build target guarantees, known at compile time.
    pub fn target() Features {
        return comptime from_target(builtin.cpu);
    }

    /// The features of the CPU this runs on. Never fewer than `target()`, since a program built
    /// for more than the CPU has would not run.
    pub fn detect() Features {
        const detected = switch (builtin.cpu.arch) {
            .x86_64 => detect_x86_64(),
            .aarch64 => detect_aarch64(),
            else => target(),
        };
        return detected.with(target());
    }

    /// The features both sets hold.
    pub fn intersect(self: Features, other: Features) Features {
        var result: Features = .{};
        inline for (std.meta.fields(Features)) |field| {
            @field(result, field.name) = @field(self, field.name) and @field(other, field.name);
        }
        return result;
    }

    /// The features either set holds.
    pub fn with(self: Features, other: Features) Features {
        var result: Features = .{};
        inline for (std.meta.fields(Features)) |field| {
            @field(result, field.name) = @field(self, field.name) or @field(other, field.name);
        }
        return result;
    }
};

fn from_target(cpu: std.Target.Cpu) Features {
    return switch (cpu.arch) {
        .x86_64 => .{
            .pclmul = has_x86(cpu, .pclmul) and has_x86(cpu, .sse4_1),
            .avx2 = has_x86(cpu, .avx2),
            .avx512 = has_x86(cpu, .avx512f) and has_x86(cpu, .avx512bw) and has_x86(cpu, .avx512vl),
            .vpclmul = has_x86(cpu, .vpclmulqdq),
        },
        .aarch64 => .{
            .crc32 = std.Target.aarch64.featureSetHas(cpu.features, .crc),
            .pmull = std.Target.aarch64.featureSetHas(cpu.features, .aes),
        },
        else => .{},
    };
}

fn has_x86(cpu: std.Target.Cpu, feature: std.Target.x86.Feature) bool {
    return std.Target.x86.featureSetHas(cpu.features, feature);
}

/// The bits of CPUID and XCR0 that detection reads, as the Intel and AMD manuals number them.
const x86 = struct {
    const leaf_features = 1;
    const leaf_extended_features = 7;
    // Leaf 1, ECX: bits 1, 19, 27 and 28.
    const ecx_pclmulqdq = 0x0000_0002;
    const ecx_sse4_1 = 0x0008_0000;
    const ecx_osxsave = 0x0800_0000;
    const ecx_avx = 0x1000_0000;
    // Leaf 7, EBX: bits 5, 16, 30 and 31; ECX: bit 10.
    const ebx_avx2 = 0x0000_0020;
    const ebx_avx512f = 0x0001_0000;
    const ebx_avx512bw = 0x4000_0000;
    const ebx_avx512vl = 0x8000_0000;
    const ecx_vpclmulqdq = 0x0000_0400;
    /// XCR0: the operating system saves the XMM and YMM registers.
    const xcr0_ymm = 0b110;
    /// XCR0: it also saves the opmask and ZMM registers.
    const xcr0_zmm = 0b1110_0000;
};

const Registers = struct { eax: u32, ebx: u32, ecx: u32, edx: u32 };

fn cpuid(leaf: u32, subleaf: u32) Registers {
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

fn xgetbv() u64 {
    var low: u32 = undefined;
    var high: u32 = undefined;
    asm volatile ("xgetbv"
        : [low] "={eax}" (low),
          [high] "={edx}" (high),
        : [register] "{ecx}" (@as(u32, 0)),
    );
    return (@as(u64, high) << @bitSizeOf(u32)) | low;
}

fn all(value: u32, bits: u32) bool {
    return value & bits == bits;
}

fn detect_x86_64() Features {
    if (builtin.cpu.arch != .x86_64) unreachable;
    const basic = cpuid(x86.leaf_features, 0);
    const saves_registers = all(basic.ecx, x86.ecx_osxsave | x86.ecx_avx);
    const extended = cpuid(x86.leaf_extended_features, 0);
    return from_x86(.{
        .leaf_1_ecx = basic.ecx,
        .leaf_7_ebx = extended.ebx,
        .leaf_7_ecx = extended.ecx,
        // XGETBV faults unless the operating system enabled it, which OSXSAVE reports.
        .xcr0 = if (saves_registers) xgetbv() else 0,
    });
}

/// The registers x86-64 detection reads: CPUID leaf 1's ECX, leaf 7's EBX and ECX, and XCR0,
/// which is 0 when the operating system saves no extended registers.
const X86Registers = struct { leaf_1_ecx: u32, leaf_7_ebx: u32, leaf_7_ecx: u32, xcr0: u64 };

/// The features the registers report. AVX2, AVX-512 and VPCLMULQDQ need the operating system to
/// save the registers they use, which XCR0 reports.
fn from_x86(registers: X86Registers) Features {
    const ymm = registers.xcr0 & x86.xcr0_ymm == x86.xcr0_ymm;
    const zmm = ymm and registers.xcr0 & x86.xcr0_zmm == x86.xcr0_zmm;
    const avx512_bits = x86.ebx_avx512f | x86.ebx_avx512bw | x86.ebx_avx512vl;
    return .{
        .pclmul = all(registers.leaf_1_ecx, x86.ecx_pclmulqdq | x86.ecx_sse4_1),
        .avx2 = ymm and all(registers.leaf_7_ebx, x86.ebx_avx2),
        .avx512 = zmm and all(registers.leaf_7_ebx, avx512_bits),
        .vpclmul = ymm and all(registers.leaf_7_ecx, x86.ecx_vpclmulqdq),
    };
}

/// The bits of Linux's arm64 hardware capability word that detection reads.
const hwcap = struct {
    // Bits 4 and 7 of AT_HWCAP.
    const pmull = 0x10;
    const crc32 = 0x80;
};

fn detect_aarch64() Features {
    if (builtin.cpu.arch != .aarch64) unreachable;
    return switch (builtin.os.tag) {
        .linux => from_hwcap(std.os.linux.getauxval(std.elf.AT_HWCAP)),
        // Every aarch64 Mac is an Apple M-series part, which has both.
        .macos => .{ .crc32 = true, .pmull = true },
        else => Features.target(),
    };
}

fn from_hwcap(word: usize) Features {
    return .{ .crc32 = word & hwcap.crc32 != 0, .pmull = word & hwcap.pmull != 0 };
}

// Tests.

const testing = std.testing;

test "detect finds at least what the target guarantees" {
    const detected = Features.detect();
    const target_features = Features.target();
    try testing.expectEqual(target_features, detected.intersect(target_features));
}

test "none holds nothing, and intersect and with combine field by field" {
    try testing.expectEqual(Features{}, Features.none());
    const left: Features = .{ .pclmul = true, .avx2 = true };
    const right: Features = .{ .avx2 = true, .crc32 = true };
    try testing.expectEqual(Features{ .avx2 = true }, left.intersect(right));
    try testing.expectEqual(Features{ .pclmul = true, .avx2 = true, .crc32 = true }, left.with(right));
}

test "the x86-64 registers map each feature, and XCR0 gates the vector registers" {
    const every: X86Registers = .{
        .leaf_1_ecx = 0x0000_0002 | 0x0008_0000,
        .leaf_7_ebx = 0x0000_0020 | 0x0001_0000 | 0x4000_0000 | 0x8000_0000,
        .leaf_7_ecx = 0x0000_0400,
        .xcr0 = 0b1110_0111,
    };
    try testing.expectEqual(Features{ .pclmul = true, .avx2 = true, .avx512 = true, .vpclmul = true }, from_x86(every));
    // No YMM state saved: nothing that uses YMM or ZMM, whatever CPUID says.
    var no_ymm = every;
    no_ymm.xcr0 = 0b011;
    try testing.expectEqual(Features{ .pclmul = true }, from_x86(no_ymm));
    // YMM saved but not ZMM: AVX2 and VPCLMULQDQ, no AVX-512.
    var no_zmm = every;
    no_zmm.xcr0 = 0b111;
    try testing.expectEqual(Features{ .pclmul = true, .avx2 = true, .vpclmul = true }, from_x86(no_zmm));
    // PCLMULQDQ without SSE4.1, and AVX-512 F without BW.
    var partial = every;
    partial.leaf_1_ecx = 0x0000_0002;
    partial.leaf_7_ebx = 0x0000_0020 | 0x0001_0000 | 0x8000_0000;
    try testing.expectEqual(Features{ .avx2 = true, .vpclmul = true }, from_x86(partial));
}

test "the hardware capability word maps CRC32 and PMULL" {
    try testing.expectEqual(Features{ .crc32 = true, .pmull = true }, from_hwcap(0b1001_0000));
    try testing.expectEqual(Features{ .crc32 = true }, from_hwcap(0b1000_0000));
    try testing.expectEqual(Features{}, from_hwcap(0b0110_1111));
}

test "detection on this host finds what its architecture's feature set should" {
    const detected = Features.detect();
    switch (builtin.cpu.arch) {
        .aarch64 => if (builtin.os.tag == .macos) try testing.expect(detected.crc32 and detected.pmull),
        .x86_64 => try testing.expect(!detected.crc32 and !detected.pmull),
        else => try testing.expectEqual(Features.target(), detected),
    }
}
