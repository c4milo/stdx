//! aarch64 Linux's source for `probe` (decision 40): the AT_HWCAP and AT_HWCAP2 words, which
//! `getauxval` reads from the auxiliary vector the kernel wrote into the process's memory at
//! start, and MIDR_EL1, which `mrs` reads where AT_HWCAP has HWCAP_CPUID. Linux traps that read and
//! emulates it, so the probe makes no syscall and opens no file.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

const platform = @import("platform.zig");
const constants = platform.constants;
const Answer = platform.Answer;
const Cpu = platform.Cpu;
const Midr = platform.Midr;
const answer_file = @import("platform_answer.zig");
const answer = answer_file.answer;
const both = answer_file.both;
const unanswered = answer_file.unanswered;

/// Linux's AT_HWCAP and AT_HWCAP2 words, and MIDR_EL1 where AT_HWCAP lets a program read it.
pub const Hwcap = struct { word: usize, word2: usize, midr: ?u64 };

/// What Linux gives: its two words, and MIDR_EL1 where the first lets a program read it.
pub fn read() Hwcap {
    return reading(auxiliary(std.elf.AT_HWCAP), auxiliary(std.elf.AT_HWCAP2), read_midr);
}

/// The words, and MIDR_EL1 through `midr_of` only where `word` lets a program read it.
fn reading(word: usize, word2: usize, comptime midr_of: fn () u64) Hwcap {
    return .{ .word = word, .word2 = word2, .midr = if (reads_midr(word)) midr_of() else null };
}

/// One entry of Linux's auxiliary vector. A program that links libc starts in libc, which keeps
/// the vector itself, so Zig's reader finds nothing there; libc's `getauxval` reads the same memory.
fn auxiliary(comptime entry: comptime_int) usize {
    if (builtin.link_libc) return std.c.getauxval(entry);
    return std.os.linux.getauxval(entry);
}

/// Whether Linux emulates a read of MIDR_EL1 for this program: AT_HWCAP's HWCAP_CPUID.
fn reads_midr(word: usize) bool {
    return word & constants.hwcap_cpuid != 0;
}

/// MIDR_EL1, through `mrs`. Linux traps the read and emulates it, so call this only where
/// `reads_midr` holds: elsewhere the read raises SIGILL.
fn read_midr() u64 {
    comptime assert(builtin.cpu.arch == .aarch64 and builtin.os.tag == .linux);
    return asm volatile ("mrs %[midr], MIDR_EL1"
        : [midr] "=r" (-> u64),
    );
}

/// MIDR_EL1's fields, each from its place in the register.
fn from_midr(value: u64) Midr {
    return .{
        .implementer = @truncate(value >> constants.midr_implementer_shift),
        .variant = @truncate(value >> constants.midr_variant_shift),
        .architecture = @truncate(value >> constants.midr_architecture_shift),
        .part = @truncate(value >> constants.midr_part_shift),
        .revision = @truncate(value >> constants.midr_revision_shift),
    };
}

/// The answers of Linux's words and MIDR_EL1. AT_HWCAP2 answers `sve2` only beside an AT_HWCAP
/// word: without one, `getauxval` found no vector, and its 0 says nothing.
pub fn from_linux(linux: Hwcap) Cpu {
    // A program reads MIDR_EL1 only where AT_HWCAP said it may.
    assert(linux.midr == null or reads_midr(linux.word));
    var cpu = from_hwcap(linux.word);
    if (linux.word == 0) return cpu;
    cpu.sve2 = answer(linux.word2 & constants.hwcap2_sve2 != 0);
    cpu.midr = if (linux.midr) |value| from_midr(value) else null;
    return cpu;
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
        .sve2 = .not_known,
        .ssse3 = .not_known,
        .sse4_1 = .not_known,
        .avx2 = .not_known,
        .vaes = .not_known,
        .midr = null,
    };
}

// Tests. Each states the bits it sets, so a changed constant fails it.

const testing = std.testing;

/// A `Cpu` from an AT_HWCAP word alone, with every SHA answer `sha`.
fn cpu_of(aes_clmul: Answer, dit: Answer, sha: Answer) Cpu {
    return .{ .aes_clmul = aes_clmul, .dit = dit, .sha256 = sha, .sha512 = sha, .sha3 = sha, .sve2 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known, .avx2 = .not_known, .vaes = .not_known, .midr = null };
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
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .no, .sha256 = .yes, .sha512 = .no, .sha3 = .no, .sve2 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known, .avx2 = .not_known, .vaes = .not_known, .midr = null }, sha256);
    const sha512 = from_hwcap(1 << 21);
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .no, .sha256 = .no, .sha512 = .yes, .sha3 = .no, .sve2 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known, .avx2 = .not_known, .vaes = .not_known, .midr = null }, sha512);
    const sha3 = from_hwcap(1 << 17);
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .no, .sha256 = .no, .sha512 = .no, .sha3 = .yes, .sve2 = .not_known, .ssse3 = .not_known, .sse4_1 = .not_known, .avx2 = .not_known, .vaes = .not_known, .midr = null }, sha3);
}

test "MIDR_EL1's fields come from bits 31 to 24, 23 to 20, 19 to 16, 15 to 4 and 3 to 0" {
    // Arm's Neoverse N2, r0p0, and Apple's M1 as a virtual machine reports it.
    try testing.expectEqual(Midr{ .implementer = 0x41, .variant = 0, .architecture = 0xf, .part = 0xd49, .revision = 0 }, from_midr(0x410f_d490));
    try testing.expectEqual(Midr{ .implementer = 0x61, .variant = 0, .architecture = 0xf, .part = 0, .revision = 0 }, from_midr(0x610f_0000));
    // Every field differs from its neighbours, and the bits above 31 are not MIDR_EL1's.
    try testing.expectEqual(Midr{ .implementer = 0xa5, .variant = 0x3, .architecture = 0xc, .part = 0x9e1, .revision = 0x7 }, from_midr(0xffff_ffff_a53c_9e17));
}

test "a program reads MIDR_EL1 only where AT_HWCAP has HWCAP_CPUID, bit 11" {
    try testing.expect(reads_midr(1 << 11));
    try testing.expect(reads_midr(~@as(usize, 0)));
    try testing.expect(!reads_midr(~@as(usize, 1 << 11)));
    try testing.expect(!reads_midr(0));
}

test "AT_HWCAP2's bit 1 answers sve2, and MIDR_EL1 answers midr, beside an AT_HWCAP word" {
    const word: usize = 1 << 3 | 1 << 4 | 1 << 11;
    const n2 = from_linux(.{ .word = word, .word2 = 1 << 1, .midr = 0x410f_d490 });
    try testing.expectEqual(Answer.yes, n2.sve2);
    try testing.expectEqual(Midr{ .implementer = 0x41, .variant = 0, .architecture = 0xf, .part = 0xd49, .revision = 0 }, n2.midr.?);
    try testing.expectEqual(Answer.yes, n2.aes_clmul);
    const without = from_linux(.{ .word = word, .word2 = ~@as(usize, 1 << 1), .midr = null });
    try testing.expectEqual(Answer.no, without.sve2);
    try testing.expectEqual(null, without.midr);
    // Without an AT_HWCAP word, AT_HWCAP2 says nothing.
    try testing.expectEqual(unanswered, from_linux(.{ .word = 0, .word2 = 1 << 1, .midr = null }));
}

test "the reading asks for MIDR_EL1 only where AT_HWCAP has HWCAP_CPUID" {
    const stand_in = struct {
        fn midr() u64 {
            return 0x410f_d490;
        }
    };
    try testing.expectEqual(Hwcap{ .word = 1 << 11, .word2 = 1 << 1, .midr = 0x410f_d490 }, reading(1 << 11, 1 << 1, stand_in.midr));
    try testing.expectEqual(Hwcap{ .word = 1 << 3, .word2 = 1 << 1, .midr = null }, reading(1 << 3, 1 << 1, stand_in.midr));
    try testing.expectEqual(Hwcap{ .word = 0, .word2 = 0, .midr = null }, reading(0, 0, stand_in.midr));
}

test "the probe on aarch64 Linux reads MIDR_EL1 exactly where AT_HWCAP lets it" {
    if (builtin.cpu.arch != .aarch64 or builtin.os.tag != .linux) return error.SkipZigTest;
    const linux = read();
    try testing.expectEqual(reads_midr(linux.word), linux.midr != null);
    if (linux.midr) |value| try testing.expectEqual(@as(u4, 0xf), from_midr(value).architecture);
}
