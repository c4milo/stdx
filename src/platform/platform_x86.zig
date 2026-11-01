//! platform's x86-64 probe (decision 40): CPUID leaves 1 and 7, and XCR0 through XGETBV when the
//! system has enabled XSAVE. platform.zig's `probe` calls `read` and `answers` on x86-64 alone.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

const platform = @import("platform.zig");
const constants = platform.constants;
const Answer = platform.Answer;
const Cpu = platform.Cpu;
const answer = platform.answer;
const both = platform.both;

/// The four registers CPUID writes.
const Registers = struct { eax: u32, ebx: u32, ecx: u32, edx: u32 };

/// The CPU's own CPUID and XGETBV, the source `read_x86` reads on a running x86-64 CPU.
const Hardware = struct {
    const cpuid = cpuid_of_cpu;
    const xgetbv_0 = xgetbv_0_of_cpu;
};

fn cpuid_of_cpu(leaf: u32, subleaf: u32) Registers {
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
fn xgetbv_0_of_cpu() u64 {
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

/// What the x86-64 probe reads: leaf 1's ECX, leaf 7's EBX and ECX and its subleaf 1's EAX, and
/// XCR0. A leaf or subleaf past the last one the CPU gives, or XCR0 with XSAVE off, reads as 0.
pub const X86 = struct { leaf_1_ecx: u32, leaf_7_ebx: u32, leaf_7_ecx: u32, leaf_7_1_eax: u32, xcr0: u64 };

pub fn read_x86() X86 {
    return read_from(Hardware);
}

/// What `Source`'s `cpuid` and `xgetbv_0` give. Tests pass a source of fixed registers.
fn read_from(comptime Source: type) X86 {
    const cpuid = Source.cpuid;
    const last_leaf = cpuid(0, 0).eax;
    const leaf_1_ecx = cpuid(constants.cpuid_leaf_features, 0).ecx;
    var reading: X86 = .{ .leaf_1_ecx = leaf_1_ecx, .leaf_7_ebx = 0, .leaf_7_ecx = 0, .leaf_7_1_eax = 0, .xcr0 = 0 };
    if (last_leaf >= constants.cpuid_leaf_extended) {
        const leaf_7 = cpuid(constants.cpuid_leaf_extended, 0);
        reading.leaf_7_ebx = leaf_7.ebx;
        reading.leaf_7_ecx = leaf_7.ecx;
        // Leaf 7's subleaf 0 EAX is the last subleaf the CPU gives.
        if (leaf_7.eax >= 1) reading.leaf_7_1_eax = cpuid(constants.cpuid_leaf_extended, 1).eax;
    }
    if (leaf_1_ecx & constants.ecx_osxsave != 0) reading.xcr0 = Source.xgetbv_0();
    return reading;
}

/// The answers of x86-64's CPUID and XCR0:
/// - leaf 1's ECX bits 25 and 1 for `aes_clmul`, 9 for `ssse3` and 19 for `sse4_1`;
/// - leaf 7's EBX bit 29 for `sha256` and bit 5 for `avx2`, and its ECX bits 9 and 10 for `vaes`;
/// - leaf 7's subleaf 1 EAX bit 0 for `sha512`.
/// `sha512`, `avx2` and `vaes` take YMM registers, so each is `yes` only with leaf 1's AVX and
/// OSXSAVE and XCR0's SSE and AVX state. `vaes` also needs `avx2`.
pub fn from_x86(reading: X86) Cpu {
    const aes = answer(reading.leaf_1_ecx & constants.ecx_aes != 0);
    const pclmulqdq = answer(reading.leaf_1_ecx & constants.ecx_pclmulqdq != 0);
    const avx_saved = reading.leaf_1_ecx & (constants.ecx_avx | constants.ecx_osxsave) == constants.ecx_avx | constants.ecx_osxsave and
        reading.xcr0 & constants.xcr0_sse_avx == constants.xcr0_sse_avx;
    const avx2 = avx_saved and reading.leaf_7_ebx & constants.leaf_7_ebx_avx2 != 0;
    const vaes_vpclmulqdq = constants.leaf_7_ecx_vaes | constants.leaf_7_ecx_vpclmulqdq;
    return .{
        .aes_clmul = both(aes, pclmulqdq),
        .dit = .not_known,
        .sha256 = answer(reading.leaf_7_ebx & constants.leaf_7_ebx_sha != 0),
        .sha512 = answer(avx_saved and reading.leaf_7_1_eax & constants.leaf_7_1_eax_sha512 != 0),
        .sha3 = .no,
        .ssse3 = answer(reading.leaf_1_ecx & constants.ecx_ssse3 != 0),
        .sse4_1 = answer(reading.leaf_1_ecx & constants.ecx_sse4_1 != 0),
        .avx2 = answer(avx2),
        .vaes = answer(avx2 and reading.leaf_7_ecx & vaes_vpclmulqdq == vaes_vpclmulqdq),
    };
}

// Tests. Each states the bits it sets, so a changed constant fails it.

const testing = std.testing;

test "CPUID leaf 1's ECX answers aes_clmul from bits 25 and 1, and never dit" {
    const at = struct {
        fn ecx(value: u32) Cpu {
            return from_x86(.{ .leaf_1_ecx = value, .leaf_7_ebx = 0, .leaf_7_ecx = 0, .leaf_7_1_eax = 0, .xcr0 = 0 });
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
            return from_x86(.{ .leaf_1_ecx = value, .leaf_7_ebx = 0, .leaf_7_ecx = 0, .leaf_7_1_eax = 0, .xcr0 = 0 });
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

test "CPUID leaf 7 answers sha256 from EBX bit 29, sha512 from subleaf 1 EAX bit 0 with AVX saved, and sha3 no" {
    // leaf 1's ECX with AVX and OSXSAVE, and XCR0 with the SSE and AVX state.
    const avx_ecx: u32 = 1 << 28 | 1 << 27;
    const avx_xcr0: u64 = 1 << 1 | 1 << 2;
    const sha = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = 1 << 29, .leaf_7_ecx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = avx_xcr0 });
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .not_known, .sha256 = .yes, .sha512 = .yes, .sha3 = .no, .ssse3 = .no, .sse4_1 = .no, .avx2 = .no, .vaes = .no }, sha);
    const no_sha256 = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = ~@as(u32, 1 << 29), .leaf_7_ecx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = avx_xcr0 });
    try testing.expectEqual(Answer.no, no_sha256.sha256);
    try testing.expectEqual(Answer.yes, no_sha256.sha512);
    const no_sha512 = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = 1 << 29, .leaf_7_ecx = 0, .leaf_7_1_eax = ~@as(u32, 1 << 0), .xcr0 = avx_xcr0 });
    try testing.expectEqual(Answer.no, no_sha512.sha512);
    // The SHA-512 instructions take YMM registers: without AVX, OSXSAVE or the saved state, no.
    const no_avx = from_x86(.{ .leaf_1_ecx = 1 << 27, .leaf_7_ebx = 0, .leaf_7_ecx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = avx_xcr0 });
    const no_osxsave = from_x86(.{ .leaf_1_ecx = 1 << 28, .leaf_7_ebx = 0, .leaf_7_ecx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = avx_xcr0 });
    const no_ymm_state = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = 0, .leaf_7_ecx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = 1 << 1 });
    const no_sse_state = from_x86(.{ .leaf_1_ecx = avx_ecx, .leaf_7_ebx = 0, .leaf_7_ecx = 0, .leaf_7_1_eax = 1 << 0, .xcr0 = 1 << 2 });
    for ([_]Cpu{ no_avx, no_osxsave, no_ymm_state, no_sse_state }) |cpu| try testing.expectEqual(Answer.no, cpu.sha512);
}

test "CPUID leaf 7 answers avx2 from EBX bit 5 and vaes from ECX bits 9 and 10, each with AVX saved" {
    // leaf 1's ECX with AVX and OSXSAVE, and XCR0 with the SSE and AVX state.
    const avx_ecx: u32 = 1 << 28 | 1 << 27;
    const avx_xcr0: u64 = 1 << 1 | 1 << 2;
    const at = struct {
        fn of(leaf_1_ecx: u32, ebx: u32, ecx: u32, xcr0: u64) Cpu {
            return from_x86(.{ .leaf_1_ecx = leaf_1_ecx, .leaf_7_ebx = ebx, .leaf_7_ecx = ecx, .leaf_7_1_eax = 0, .xcr0 = xcr0 });
        }
    };
    const every = at.of(avx_ecx, 1 << 5, 1 << 9 | 1 << 10, avx_xcr0);
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .not_known, .sha256 = .no, .sha512 = .no, .sha3 = .no, .ssse3 = .no, .sse4_1 = .no, .avx2 = .yes, .vaes = .yes }, every);
    const avx2_alone = at.of(avx_ecx, 1 << 5, ~@as(u32, 1 << 9 | 1 << 10), avx_xcr0);
    try testing.expectEqual(Answer.yes, avx2_alone.avx2);
    try testing.expectEqual(Answer.no, avx2_alone.vaes);
    // VAES without VPCLMULQDQ, or VPCLMULQDQ without VAES, is no.
    try testing.expectEqual(Answer.no, at.of(avx_ecx, 1 << 5, 1 << 9, avx_xcr0).vaes);
    try testing.expectEqual(Answer.no, at.of(avx_ecx, 1 << 5, 1 << 10, avx_xcr0).vaes);
    // The VAES bits without AVX2 are no for both.
    const no_avx2 = at.of(avx_ecx, ~@as(u32, 1 << 5), 1 << 9 | 1 << 10, avx_xcr0);
    try testing.expectEqual(Answer.no, no_avx2.avx2);
    try testing.expectEqual(Answer.no, no_avx2.vaes);
    // Without AVX, OSXSAVE or the saved state, both are no.
    const unsaved = [_]Cpu{
        at.of(1 << 27, 1 << 5, 1 << 9 | 1 << 10, avx_xcr0),
        at.of(1 << 28, 1 << 5, 1 << 9 | 1 << 10, avx_xcr0),
        at.of(avx_ecx, 1 << 5, 1 << 9 | 1 << 10, 1 << 1),
        at.of(avx_ecx, 1 << 5, 1 << 9 | 1 << 10, 1 << 2),
    };
    for (unsaved) |cpu| {
        try testing.expectEqual(Answer.no, cpu.avx2);
        try testing.expectEqual(Answer.no, cpu.vaes);
    }
}

test "the read takes leaf 1's ECX, leaf 7's EBX and ECX, its subleaf 1's EAX and XCR0, and only those" {
    // A source of fixed registers whose leaf 7 gives `last_subleaf` as its last subleaf.
    const Fixed = struct {
        fn of(comptime last_subleaf: u32) type {
            return struct {
                fn cpuid(leaf: u32, subleaf: u32) Registers {
                    return switch (leaf) {
                        0 => .{ .eax = 7, .ebx = 0xa1, .ecx = 0xa2, .edx = 0xa3 },
                        1 => .{ .eax = 0xb0, .ebx = 0xb1, .ecx = 1 << 27 | 0xb2, .edx = 0xb3 },
                        7 => if (subleaf == 0) .{ .eax = last_subleaf, .ebx = 0xc1, .ecx = 0xc2, .edx = 0xc3 } else .{ .eax = 0xd0, .ebx = 0xd1, .ecx = 0xd2, .edx = 0xd3 },
                        else => unreachable,
                    };
                }
                fn xgetbv_0() u64 {
                    return 0xe0;
                }
            };
        }
    };
    try testing.expectEqual(X86{ .leaf_1_ecx = 1 << 27 | 0xb2, .leaf_7_ebx = 0xc1, .leaf_7_ecx = 0xc2, .leaf_7_1_eax = 0xd0, .xcr0 = 0xe0 }, read_from(Fixed.of(1)));
    // Leaf 7's subleaf 0 says it is the last: subleaf 1 reads as 0.
    try testing.expectEqual(X86{ .leaf_1_ecx = 1 << 27 | 0xb2, .leaf_7_ebx = 0xc1, .leaf_7_ecx = 0xc2, .leaf_7_1_eax = 0, .xcr0 = 0xe0 }, read_from(Fixed.of(0)));
}
