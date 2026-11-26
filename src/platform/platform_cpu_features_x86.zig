//! x86-64's detection of `CpuFeatures` (decision 21): the CPUID leaves and XCR0 that it reads,
//! and the features they report. platform_cpu_features.zig calls `detect` on an x86-64 host, and
//! the module's root does not export this file.

const std = @import("std");
const builtin = @import("builtin");
const constants = @import("constants.zig");
const CpuFeatures = @import("platform_cpu_features.zig").CpuFeatures;

/// The bits of CPUID and XCR0 that detection reads, as the Intel and AMD manuals number them.
const x86 = struct {
    const leaf_vendor = 0;
    // Leaf 0's vendor string, "AuthenticAMD" or "GenuineIntel", four octets to EBX, EDX and ECX in
    // that order.
    const vendor_amd_ebx = 0x6874_7541;
    const vendor_amd_edx = 0x6974_6e65;
    const vendor_amd_ecx = 0x444d_4163;
    const vendor_intel_ebx = 0x756e_6547;
    const vendor_intel_edx = 0x4965_6e69;
    const vendor_intel_ecx = 0x6c65_746e;
    const leaf_features = 1;
    const leaf_extended_features = 7;
    // Leaf 1, ECX: bits 1, 9, 19, 27 and 28, and AES-NI's bit 25.
    const ecx_aes = constants.ecx_aes;
    const ecx_pclmulqdq = 0x0000_0002;
    const ecx_ssse3 = 0x0000_0200;
    const ecx_sse4_1 = 0x0008_0000;
    const ecx_osxsave = 0x0800_0000;
    const ecx_avx = 0x1000_0000;
    // Leaf 7, EBX: bits 5, 8, 16, 17, 30 and 31; ECX: bits 10 and 11.
    const ebx_avx2 = 0x0000_0020;
    const ebx_bmi2 = 0x0000_0100;
    const ebx_avx512f = 0x0001_0000;
    const ebx_avx512dq = 0x0002_0000;
    const ebx_avx512bw = 0x4000_0000;
    const ebx_avx512vl = 0x8000_0000;
    const ecx_vpclmulqdq = 0x0000_0400;
    const ecx_avx512_vnni = 0x0000_0800;
    // Leaf 7, EBX bit 29, the SHA extensions; ECX bit 9, VAES; and subleaf 1's EAX bit 0, SHA512.
    const ebx_sha = constants.leaf_7_ebx_sha;
    const ecx_vaes = constants.leaf_7_ecx_vaes;
    const eax_sha512 = constants.leaf_7_1_eax_sha512;
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

pub fn detect() CpuFeatures {
    return from_x86(read());
}

/// The registers of this CPU that detection reads.
fn read() X86Registers {
    if (builtin.cpu.arch != .x86_64) unreachable;
    const vendor = cpuid(x86.leaf_vendor, 0);
    const basic = cpuid(x86.leaf_features, 0);
    const saves_registers = all(basic.ecx, x86.ecx_osxsave | x86.ecx_avx);
    const extended = cpuid(x86.leaf_extended_features, 0);
    // Leaf 7's subleaf 0 EAX is the last subleaf the CPU gives.
    const extended_1_eax = if (extended.eax >= 1) cpuid(x86.leaf_extended_features, 1).eax else 0;
    return .{
        .vendor_amd = vendor.ebx == x86.vendor_amd_ebx and vendor.edx == x86.vendor_amd_edx and vendor.ecx == x86.vendor_amd_ecx,
        .vendor_intel = vendor.ebx == x86.vendor_intel_ebx and vendor.edx == x86.vendor_intel_edx and vendor.ecx == x86.vendor_intel_ecx,
        .leaf_1_ecx = basic.ecx,
        .leaf_7_ebx = extended.ebx,
        .leaf_7_ecx = extended.ecx,
        .leaf_7_1_eax = extended_1_eax,
        // XGETBV faults unless the operating system enabled it, which OSXSAVE reports.
        .xcr0 = if (saves_registers) xgetbv() else 0,
    };
}

/// The registers x86-64 detection reads: whether CPUID leaf 0 names AMD or Intel, leaf 1's ECX,
/// leaf 7's EBX and ECX, its subleaf 1's EAX, and XCR0, which is 0 when the operating system saves
/// no extended registers.
const X86Registers = struct { vendor_amd: bool, vendor_intel: bool, leaf_1_ecx: u32, leaf_7_ebx: u32, leaf_7_ecx: u32, leaf_7_1_eax: u32, xcr0: u64 };

/// The features the registers report. AVX2, AVX-512, VPCLMULQDQ, SHA512 and VAES need the
/// operating system to save the registers they use, which XCR0 reports.
fn from_x86(registers: X86Registers) CpuFeatures {
    const ymm = registers.xcr0 & x86.xcr0_ymm == x86.xcr0_ymm;
    const zmm = ymm and registers.xcr0 & x86.xcr0_zmm == x86.xcr0_zmm;
    const avx512_bits = x86.ebx_avx512f | x86.ebx_avx512bw | x86.ebx_avx512dq | x86.ebx_avx512vl;
    const avx512 = zmm and all(registers.leaf_7_ebx, avx512_bits);
    const avx2 = ymm and all(registers.leaf_7_ebx, x86.ebx_avx2);
    return .{
        .ssse3 = all(registers.leaf_1_ecx, x86.ecx_ssse3),
        .pclmul = all(registers.leaf_1_ecx, x86.ecx_pclmulqdq | x86.ecx_sse4_1),
        .avx2 = avx2,
        .bmi2 = all(registers.leaf_1_ecx, x86.ecx_ssse3) and all(registers.leaf_7_ebx, x86.ebx_bmi2),
        .avx512 = avx512,
        .vpmullq_fast = avx512 and registers.vendor_amd,
        .lazy_loop_fast = registers.vendor_intel,
        .vpclmul = ymm and all(registers.leaf_7_ecx, x86.ecx_vpclmulqdq),
        .vnni = zmm and all(registers.leaf_7_ecx, x86.ecx_avx512_vnni),
        .aes = all(registers.leaf_1_ecx, x86.ecx_aes),
        // Code for the SHA extensions uses SSSE3 and SSE4.1 beside them.
        .sha256 = all(registers.leaf_1_ecx, x86.ecx_ssse3 | x86.ecx_sse4_1) and all(registers.leaf_7_ebx, x86.ebx_sha),
        .sha512 = ymm and all(registers.leaf_7_1_eax, x86.eax_sha512),
        .vaes = avx2 and all(registers.leaf_7_ecx, x86.ecx_vaes | x86.ecx_vpclmulqdq),
    };
}

// Tests.

const testing = std.testing;

test "the x86-64 registers map each feature, and XCR0 gates the vector registers" {
    const every: X86Registers = .{
        .vendor_amd = true,
        .vendor_intel = false,
        .leaf_1_ecx = 0x0000_0002 | 0x0008_0000,
        .leaf_7_ebx = 0x0000_0020 | 0x0001_0000 | 0x0002_0000 | 0x4000_0000 | 0x8000_0000,
        .leaf_7_ecx = 0x0000_0400 | 0x0000_0800,
        .leaf_7_1_eax = 0,
        .xcr0 = 0b1110_0111,
    };
    const all_x86: CpuFeatures = .{ .pclmul = true, .avx2 = true, .avx512 = true, .vpclmul = true, .vnni = true, .vpmullq_fast = true };
    try testing.expectEqual(all_x86, from_x86(every));
    // The same features on an Intel CPU, whose VPMULLQ is slow.
    var intel = every;
    intel.vendor_amd = false;
    intel.vendor_intel = true;
    try testing.expectEqual(CpuFeatures{ .pclmul = true, .avx2 = true, .avx512 = true, .vpclmul = true, .vnni = true, .lazy_loop_fast = true }, from_x86(intel));
    // VPCLMULQDQ without VNNI, as on the first CPUs with both AVX-512 and VPCLMULQDQ.
    var no_vnni = intel;
    no_vnni.leaf_7_ecx = 0x0000_0400;
    try testing.expectEqual(CpuFeatures{ .pclmul = true, .avx2 = true, .avx512 = true, .vpclmul = true, .lazy_loop_fast = true }, from_x86(no_vnni));
    // No YMM state saved: nothing that uses YMM or ZMM, whatever CPUID says.
    var no_ymm = every;
    no_ymm.xcr0 = 0b011;
    try testing.expectEqual(CpuFeatures{ .pclmul = true }, from_x86(no_ymm));
    // YMM saved but not ZMM: AVX2 and VPCLMULQDQ, no AVX-512.
    var no_zmm = every;
    no_zmm.xcr0 = 0b111;
    try testing.expectEqual(CpuFeatures{ .pclmul = true, .avx2 = true, .vpclmul = true }, from_x86(no_zmm));
    // PCLMULQDQ without SSE4.1, and AVX-512 F without BW. VNNI is reported as the CPU reports it;
    // each path that uses it requires AVX-512 as well.
    var partial = every;
    partial.leaf_1_ecx = 0x0000_0002;
    partial.leaf_7_ebx = 0x0000_0020 | 0x0001_0000 | 0x0002_0000 | 0x8000_0000;
    try testing.expectEqual(CpuFeatures{ .avx2 = true, .vpclmul = true, .vnni = true }, from_x86(partial));
    // AVX-512 F, BW and VL without DQ, whose VPMULLQ the XXH64 path runs: no AVX-512.
    var no_dq = every;
    no_dq.leaf_7_ebx = 0x0000_0020 | 0x0001_0000 | 0x4000_0000 | 0x8000_0000;
    try testing.expectEqual(CpuFeatures{ .pclmul = true, .avx2 = true, .vpclmul = true, .vnni = true }, from_x86(no_dq));
}

test "SSSE3 counts alone, BMI2 only with SSSE3, and neither needs a register saved" {
    const both: X86Registers = .{ .vendor_amd = false, .vendor_intel = false, .leaf_1_ecx = 0x0000_0200, .leaf_7_ebx = 0x0000_0100, .leaf_7_ecx = 0, .leaf_7_1_eax = 0, .xcr0 = 0 };
    try testing.expectEqual(CpuFeatures{ .ssse3 = true, .bmi2 = true }, from_x86(both));
    var no_ssse3 = both;
    no_ssse3.leaf_1_ecx = 0;
    try testing.expectEqual(CpuFeatures{}, from_x86(no_ssse3));
    var no_bmi2 = both;
    no_bmi2.leaf_7_ebx = 0;
    try testing.expectEqual(CpuFeatures{ .ssse3 = true }, from_x86(no_bmi2));
}

test "AES alone, SHA-256 with SSSE3 and SSE4.1, SHA-512 with YMM, and VAES with AVX2 and VPCLMULQDQ" {
    const every: X86Registers = .{
        .vendor_amd = false,
        .vendor_intel = false,
        .leaf_1_ecx = x86.ecx_aes | x86.ecx_ssse3 | x86.ecx_sse4_1,
        .leaf_7_ebx = x86.ebx_sha | x86.ebx_avx2,
        .leaf_7_ecx = x86.ecx_vaes | x86.ecx_vpclmulqdq,
        .leaf_7_1_eax = x86.eax_sha512,
        .xcr0 = x86.xcr0_ymm | 1,
    };
    const found = from_x86(every);
    try testing.expect(found.aes and found.sha256 and found.sha512 and found.vaes);
    try testing.expectEqual(CpuFeatures{ .aes = true }, from_x86(.{ .vendor_amd = false, .vendor_intel = false, .leaf_1_ecx = x86.ecx_aes, .leaf_7_ebx = 0, .leaf_7_ecx = 0, .leaf_7_1_eax = 0, .xcr0 = 0 }));
    var no_sse4_1 = every;
    no_sse4_1.leaf_1_ecx = x86.ecx_aes | x86.ecx_ssse3;
    try testing.expect(!from_x86(no_sse4_1).sha256);
    var no_ssse3 = every;
    no_ssse3.leaf_1_ecx = x86.ecx_aes | x86.ecx_sse4_1;
    try testing.expect(!from_x86(no_ssse3).sha256);
    // No YMM state saved: no SHA512 and no VAES, whatever CPUID says.
    var no_ymm = every;
    no_ymm.xcr0 = 0b011;
    try testing.expect(!from_x86(no_ymm).sha512 and !from_x86(no_ymm).vaes and from_x86(no_ymm).sha256);
    var no_vpclmul = every;
    no_vpclmul.leaf_7_ecx = x86.ecx_vaes;
    try testing.expect(!from_x86(no_vpclmul).vaes);
    var no_avx2 = every;
    no_avx2.leaf_7_ebx = x86.ebx_sha;
    try testing.expect(!from_x86(no_avx2).vaes);
}

test "detection reads leaf 1, leaf 7 and leaf 7's subleaf 1 as CPUID gives them" {
    // XCR0 is not compared: detection reads it only beside AVX.
    if (builtin.cpu.arch != .x86_64) return error.SkipZigTest;
    const by_detection = read();
    const extended = cpuid(x86.leaf_extended_features, 0);
    try testing.expectEqual(cpuid(x86.leaf_features, 0).ecx, by_detection.leaf_1_ecx);
    try testing.expectEqual(extended.ebx, by_detection.leaf_7_ebx);
    try testing.expectEqual(extended.ecx, by_detection.leaf_7_ecx);
    // Leaf 7's subleaf 0 EAX is the last subleaf the CPU gives, and 0 means it gives no subleaf 1.
    const subleaf_1_eax = if (extended.eax >= 1) cpuid(x86.leaf_extended_features, 1).eax else 0;
    try testing.expectEqual(subleaf_1_eax, by_detection.leaf_7_1_eax);
}

test "detection takes level 6's assembly loop on a CPU whose leaf 0 names Intel, and on no other" {
    const vendors = [_]struct { amd: bool, intel: bool }{ .{ .amd = false, .intel = true }, .{ .amd = true, .intel = false }, .{ .amd = false, .intel = false } };
    for (vendors) |vendor| {
        const registers: X86Registers = .{ .vendor_amd = vendor.amd, .vendor_intel = vendor.intel, .leaf_1_ecx = 0, .leaf_7_ebx = 0, .leaf_7_ecx = 0, .leaf_7_1_eax = 0, .xcr0 = 0 };
        try testing.expectEqual(vendor.intel, from_x86(registers).lazy_loop_fast);
    }
    // Leaf 0's registers spell the vendor's name, 4 octets each, least significant first.
    try testing.expectEqualStrings("GenuineIntel", std.mem.asBytes(&[_]u32{ x86.vendor_intel_ebx, x86.vendor_intel_edx, x86.vendor_intel_ecx }));
    try testing.expectEqualStrings("AuthenticAMD", std.mem.asBytes(&[_]u32{ x86.vendor_amd_ebx, x86.vendor_amd_edx, x86.vendor_amd_ecx }));
    try testing.expect(!CpuFeatures.target().lazy_loop_fast);
}
