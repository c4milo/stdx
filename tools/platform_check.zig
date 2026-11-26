//! The check of decision 40: on this host, `platform.CpuFeatures.detect()` gives the features the
//! host reports through a source that detection does not read.
//! - Linux on x86-64: /proc/cpuinfo, its `vendor_id` line and its `flags` line.
//! - Linux on aarch64: /proc/cpuinfo, its `Features` line. Where it names `cpuid`, the MIDR is the
//!   one a core's `CPU implementer`, `CPU variant`, `CPU part` and `CPU revision` lines give: the
//!   core whose values match detection's, or the first core. Linux prints `CPU architecture: 8`
//!   for each core, which stands for MIDR_EL1's 0xf.
//! - macOS on aarch64: `sysctl hw.optional`, its `armv8_crc32` and its `arm.FEAT_` names.
//! - macOS on x86-64: `sysctl -n machdep.cpu.vendor machdep.cpu.features
//!   machdep.cpu.leaf7_features`.
//!
//! A report covers some of the fields of `CpuFeatures`, and the check compares those alone:
//! - A field the report names a feature for is true where the report holds the feature, and false
//!   where it does not. A field that needs more than one feature, as `vaes` needs AVX2, VAES and
//!   VPCLMULQDQ, is true only where the report holds each.
//! - A field of the other architecture is false, and `midr` is null on x86-64 and on a Mac, since
//!   detection sets none of them there.
//! - `madd_addend_slow` names no instruction, and no aarch64 report covers it. On a Mac, `avx512`
//!   and `vnni` are left out too: macOS saves the AVX-512 registers only from a thread's first use
//!   of them, so XCR0 can say nothing where the CPU has them.
//! - A macOS release older than a sysctl name reports nothing for it, and the field is left out.
//!
//! The build compiles `platform` for the generic CPU of the host's architecture, so no feature
//! comes from what the build target guarantees. On Linux it builds this check twice, without libc
//! and with it: detection reads the auxiliary vector through Zig's `getauxval` in one and libc's
//! in the other.
//!
//! On any other host the check has no reference, says so, and passes having checked nothing.
//!
//! A hypervisor may hide FEAT_DIT from /proc/cpuinfo on a core that implements it, and detection
//! then reports it by the core's MIDR. There the check runs PSTATE.DIT's own instructions in place
//! of the report, and passes the field only when the mode sets, holds and clears
//! (platform_check_dit.zig, decision 40 as amended on 2026-11-26).
//!
//! The check reads a file and runs a process, which no source under `src/` may do. That is why it
//! is a tool, and not a unit test of the module.
//!
//! Usage: `platform_check`
const std = @import("std");
const builtin = @import("builtin");
const platform = @import("platform");
const platform_check_dit = @import("platform_check_dit.zig");

const CpuFeatures = platform.CpuFeatures;
const Midr = platform.Midr;

/// The program macOS reads its sysctl values with.
const sysctl_path = "/usr/sbin/sysctl";

/// The fields of aarch64's features, which detection never sets on x86-64.
const aarch64_fields = [_][]const u8{ "crc32", "pmull", "dotprod", "madd_addend_slow", "sha3", "sve2", "dit" };

/// The fields of x86-64's features, which detection never sets on aarch64.
const x86_fields = [_][]const u8{ "ssse3", "sse4_1", "pclmul", "avx2", "avx512", "vpclmul", "vnni", "bmi2", "vpmullq_fast", "lazy_loop_fast", "vaes" };

/// A report of the host's features, where it came from, and the fields it covers.
const Reference = struct {
    source: []const u8,
    /// The features the report holds, in the fields it covers alone.
    features: CpuFeatures = .{},
    /// True for each field the report covers. Its `midr` stays null: `midr_covered` says whether
    /// the report covers that field.
    covered: CpuFeatures = .{},
    midr_covered: bool = false,

    /// Records that the report gives `field` as `present`.
    fn give(self: *Reference, comptime field: []const u8, present: bool) void {
        @field(self.covered, field) = true;
        @field(self.features, field) = present;
    }

    /// Records that the report gives the core as `midr`.
    fn give_midr(self: *Reference, midr: ?Midr) void {
        self.midr_covered = true;
        self.features.midr = midr;
    }

    /// Records each of `fields` as absent.
    fn absent(self: *Reference, comptime fields: []const []const u8) void {
        inline for (fields) |field| self.give(field, false);
    }

    /// The fields of `detected` that this report covers.
    fn covered_of(self: Reference, detected: CpuFeatures) CpuFeatures {
        var compared = detected.intersect(self.covered);
        compared.midr = if (self.midr_covered) detected.midr else null;
        return compared;
    }
};

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const system = @tagName(builtin.cpu.arch) ++ "-" ++ @tagName(builtin.os.tag);
    if (!std.meta.eql(CpuFeatures.target(), CpuFeatures.none())) {
        // Detection adds what the target guarantees, so a check built for such a CPU would pass a
        // detection that failed to read its source.
        std.debug.print("platform-check BROKEN: built for a CPU that guarantees a feature\n", .{});
        std.process.exit(1);
    }
    const detected = CpuFeatures.detect();
    var reference = try read_reference(arena, init.io, detected.midr) orelse {
        std.debug.print("platform-check: no reference on {s}; nothing checked\n", .{system});
        return;
    };
    const reported = reference.features.dit;
    reference.features.dit = platform_check_dit.reported_dit(reference.covered.dit, reported, detected, platform_check_dit.holds) catch {
        std.debug.print("platform-check FAILED: detection reports FEAT_DIT, and PSTATE.DIT does not hold\n", .{});
        std.process.exit(1);
    };
    if (reference.features.dit != reported) {
        std.debug.print("platform-check: {s} hides FEAT_DIT, and PSTATE.DIT sets, holds and clears\n", .{reference.source});
    }
    const compared = reference.covered_of(detected);
    std.debug.print(
        "platform-check, {s}, libc {}: detection gives {any}; {s} gives {any}\n",
        .{ system, builtin.link_libc, compared, reference.source, reference.features },
    );
    if (std.meta.eql(compared, reference.features)) return;
    std.debug.print("platform-check FAILED: detection and {s} disagree\n", .{reference.source});
    std.process.exit(1);
}

/// The host's report, or null on a host the check has no source for. On Linux the MIDR is the
/// core whose lines match `detected`, or the first core's when none does.
fn read_reference(arena: std.mem.Allocator, io: std.Io, detected: ?Midr) !?Reference {
    switch (builtin.os.tag) {
        .linux => {
            const text = try read_cpuinfo(arena, io);
            return from_cpuinfo(builtin.cpu.arch, text, detected) orelse error.NoFeaturesLine;
        },
        .macos => return switch (builtin.cpu.arch) {
            .aarch64 => from_sysctl_arm(try run_sysctl(arena, io, &.{ sysctl_path, "hw.optional" })),
            .x86_64 => from_machdep(try run_sysctl(arena, io, &.{
                sysctl_path,
                "-n",
                "machdep.cpu.vendor",
                "machdep.cpu.features",
                "machdep.cpu.leaf7_features",
            })),
            else => null,
        },
        else => return null,
    }
}

/// /proc/cpuinfo, read to its end. Its size reads as 0, so a positional reader, which stops at the
/// size, would find it empty.
fn read_cpuinfo(arena: std.mem.Allocator, io: std.Io) ![]const u8 {
    const file = try std.Io.Dir.openFileAbsolute(io, "/proc/cpuinfo", .{});
    defer file.close(io);
    var reader = file.readerStreaming(io, &.{});
    return reader.interface.allocRemaining(arena, .unlimited);
}

/// What `sysctl` prints, or an error when it does not exit 0.
fn run_sysctl(arena: std.mem.Allocator, io: std.Io, argv: []const []const u8) ![]const u8 {
    const result = try std.process.run(arena, io, .{ .argv = argv });
    switch (result.term) {
        .exited => |code| if (code == 0) return result.stdout,
        else => {},
    }
    std.debug.print("platform-check: {s} failed: {s}\n", .{ argv[1], result.stderr });
    return error.SysctlFailed;
}

/// The report a Linux /proc/cpuinfo gives on `arch`, or null when it holds no line of features.
fn from_cpuinfo(arch: std.Target.Cpu.Arch, text: []const u8, detected: ?Midr) ?Reference {
    return switch (arch) {
        .x86_64 => from_x86_flags(value_of(text, "flags") orelse return null, value_of(text, "vendor_id") orelse ""),
        .aarch64 => from_aarch64_cpuinfo(text, detected),
        else => null,
    };
}

/// The report of aarch64's `Features` line, and the core's MIDR where the line names `cpuid`.
fn from_aarch64_cpuinfo(text: []const u8, detected: ?Midr) ?Reference {
    const words = value_of(text, "Features") orelse return null;
    var reference = from_aarch64_features(words);
    reference.give_midr(if (has_word(words, "cpuid")) core_midr(text, detected) else null);
    return reference;
}

/// The MIDR of the core in `text` whose lines give `detected`, or of the first core when none
/// does, or null when no core's lines parse. Each core's lines follow its `processor` line.
fn core_midr(text: []const u8, detected: ?Midr) ?Midr {
    var first: ?Midr = null;
    var cores = std.mem.splitSequence(u8, text, "\nprocessor");
    while (cores.next()) |core| {
        const midr = midr_of(core) orelse continue;
        if (detected != null and std.meta.eql(midr, detected.?)) return midr;
        if (first == null) first = midr;
    }
    return first;
}

/// The MIDR one core's lines give. Linux prints the architecture as 8 for every core, which
/// stands for MIDR_EL1's 0xf.
fn midr_of(core: []const u8) ?Midr {
    const architecture = std.mem.trim(u8, value_of(core, "CPU architecture") orelse return null, " \t");
    if (!std.mem.eql(u8, architecture, "8")) return null;
    return .{
        .implementer = number(u8, core, "CPU implementer") orelse return null,
        .variant = number(u4, core, "CPU variant") orelse return null,
        .architecture = 0xf,
        .part = number(u12, core, "CPU part") orelse return null,
        .revision = number(u4, core, "CPU revision") orelse return null,
    };
}

/// The number a line gives, as 0x41 or as 1.
fn number(comptime T: type, core: []const u8, name: []const u8) ?T {
    const text = std.mem.trim(u8, value_of(core, name) orelse return null, " \t");
    return std.fmt.parseInt(T, text, 0) catch null;
}

/// The report of x86-64's `flags` and `vendor_id` lines. Linux clears `avx` where the operating
/// system saves no YMM registers, and `avx512f` where it saves no ZMM registers.
fn from_x86_flags(words: []const u8, vendor: []const u8) Reference {
    const has = struct {
        fn all(line: []const u8, comptime names: []const []const u8) bool {
            inline for (names) |name| {
                if (!has_word(line, name)) return false;
            }
            return true;
        }
    }.all;
    const avx512 = has(words, &.{ "avx512f", "avx512bw", "avx512dq", "avx512vl" });
    const amd = has_word(vendor, "AuthenticAMD");
    var reference: Reference = .{ .source = "/proc/cpuinfo" };
    reference.give("ssse3", has(words, &.{"ssse3"}));
    reference.give("sse4_1", has(words, &.{"sse4_1"}));
    reference.give("pclmul", has(words, &.{ "pclmulqdq", "sse4_1" }));
    reference.give("avx2", has(words, &.{"avx2"}));
    reference.give("avx512", avx512);
    reference.give("vpclmul", has(words, &.{ "avx", "vpclmulqdq" }));
    reference.give("vnni", has(words, &.{ "avx512f", "avx512_vnni" }));
    reference.give("bmi2", has(words, &.{ "ssse3", "bmi2" }));
    reference.give("vpmullq_fast", avx512 and amd);
    reference.give("lazy_loop_fast", has_word(vendor, "GenuineIntel"));
    reference.give("aes", has(words, &.{"aes"}));
    reference.give("sha256", has(words, &.{ "sha_ni", "ssse3", "sse4_1" }));
    reference.give("sha512", has(words, &.{ "avx", "sha512" }));
    reference.give("vaes", has(words, &.{ "avx2", "vaes", "vpclmulqdq" }));
    reference.absent(&aarch64_fields);
    reference.give_midr(null);
    return reference;
}

/// The report of aarch64's `Features` line. `asimddp` is the DotProd extension.
fn from_aarch64_features(words: []const u8) Reference {
    var reference: Reference = .{ .source = "/proc/cpuinfo" };
    reference.give("crc32", has_word(words, "crc32"));
    reference.give("pmull", has_word(words, "pmull"));
    reference.give("dotprod", has_word(words, "asimddp"));
    reference.give("aes", has_word(words, "aes"));
    reference.give("sha256", has_word(words, "sha2"));
    reference.give("sha512", has_word(words, "sha512"));
    reference.give("sha3", has_word(words, "sha3"));
    reference.give("sve2", has_word(words, "sve2"));
    reference.give("dit", has_word(words, "dit"));
    reference.absent(&x86_fields);
    return reference;
}

/// The report `sysctl hw.optional` gives on an aarch64 Mac: 1 is present, 0 is absent, and a name
/// it does not print leaves its field out.
fn from_sysctl_arm(text: []const u8) Reference {
    var reference: Reference = .{ .source = "sysctl hw.optional" };
    give_sysctl(&reference, "crc32", text, "hw.optional.armv8_crc32");
    give_sysctl(&reference, "pmull", text, "hw.optional.arm.FEAT_PMULL");
    give_sysctl(&reference, "dotprod", text, "hw.optional.arm.FEAT_DotProd");
    give_sysctl(&reference, "aes", text, "hw.optional.arm.FEAT_AES");
    give_sysctl(&reference, "sha256", text, "hw.optional.arm.FEAT_SHA256");
    give_sysctl(&reference, "sha512", text, "hw.optional.arm.FEAT_SHA512");
    give_sysctl(&reference, "sha3", text, "hw.optional.arm.FEAT_SHA3");
    give_sysctl(&reference, "sve2", text, "hw.optional.arm.FEAT_SVE2");
    give_sysctl(&reference, "dit", text, "hw.optional.arm.FEAT_DIT");
    reference.absent(&x86_fields);
    // macOS gives a program no read of MIDR_EL1.
    reference.give_midr(null);
    return reference;
}

/// Records `field` from the value of the sysctl `name` in `text`, where `text` holds one.
fn give_sysctl(reference: *Reference, comptime field: []const u8, text: []const u8, name: []const u8) void {
    const value = std.mem.trim(u8, value_of(text, name) orelse return, " \t");
    if (std.mem.eql(u8, value, "1")) reference.give(field, true);
    if (std.mem.eql(u8, value, "0")) reference.give(field, false);
}

/// The report of the words `sysctl -n machdep.cpu.vendor machdep.cpu.features
/// machdep.cpu.leaf7_features` prints. No Intel Mac has the SHA-512 instructions, and none is an
/// AMD part.
fn from_machdep(text: []const u8) Reference {
    var reference: Reference = .{ .source = "sysctl machdep.cpu" };
    reference.give("ssse3", has_word(text, "SSSE3"));
    reference.give("sse4_1", has_word(text, "SSE4.1"));
    reference.give("pclmul", has_word(text, "PCLMULQDQ") and has_word(text, "SSE4.1"));
    reference.give("avx2", has_word(text, "AVX2"));
    reference.give("vpclmul", has_word(text, "AVX1.0") and has_word(text, "VPCLMULQDQ"));
    reference.give("bmi2", has_word(text, "SSSE3") and has_word(text, "BMI2"));
    reference.give("vpmullq_fast", false);
    reference.give("lazy_loop_fast", has_word(text, "GenuineIntel"));
    reference.give("aes", has_word(text, "AES"));
    reference.give("sha256", has_word(text, "SHA") and has_word(text, "SSSE3") and has_word(text, "SSE4.1"));
    reference.give("sha512", false);
    reference.give("vaes", has_word(text, "AVX2") and has_word(text, "VAES") and has_word(text, "VPCLMULQDQ"));
    reference.absent(&aarch64_fields);
    reference.give_midr(null);
    return reference;
}

/// What follows the colon on the first line whose name, before the colon, is `name`.
fn value_of(text: []const u8, name: []const u8) ?[]const u8 {
    var lines = std.mem.splitScalar(u8, text, '\n');
    while (lines.next()) |line| {
        const colon = std.mem.indexOfScalar(u8, line, ':') orelse continue;
        if (std.mem.eql(u8, std.mem.trim(u8, line[0..colon], " \t"), name)) return line[colon + 1 ..];
    }
    return null;
}

fn has_word(words: []const u8, word: []const u8) bool {
    var iterator = std.mem.tokenizeAny(u8, words, " \t\n");
    while (iterator.next()) |candidate| {
        if (std.mem.eql(u8, candidate, word)) return true;
    }
    return false;
}

// Tests. Each fixture is shaped as the host prints it.

const testing = std.testing;

const x86_64_cpuinfo = "processor\t: 0\n" ++
    "vendor_id\t: AuthenticAMD\n" ++
    "flags\t\t: fpu vme sse sse2 pni pclmulqdq ssse3 sse4_1 aes xsave avx avx2 bmi2 vaes vpclmulqdq " ++
    "avx512f avx512dq avx512bw avx512vl avx512_vnni sha_ni\n" ++
    "vmx flags\t: vnmi preemption_timer sha512\n" ++
    "bugs\t\t: sysret_ss_attrs\n";

const aarch64_cpuinfo = "processor\t: 0\n" ++
    "BogoMIPS\t: 2000.00\n" ++
    "Features\t: fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics asimddp dit uscat sveaes svepmull\n" ++
    "CPU implementer\t: 0x41\n";

test "the flags line of x86-64's cpuinfo gives each feature from its own words" {
    const zen4 = from_cpuinfo(.x86_64, x86_64_cpuinfo, null).?;
    try testing.expectEqual(CpuFeatures{
        .ssse3 = true,
        .sse4_1 = true,
        .pclmul = true,
        .avx2 = true,
        .avx512 = true,
        .vpclmul = true,
        .vnni = true,
        .bmi2 = true,
        .vpmullq_fast = true,
        .aes = true,
        .sha256 = true,
        .vaes = true,
    }, zen4.features);
    // The words of `vmx flags` are no features, and the report covers every field.
    var every = CpuFeatures{};
    inline for (std.meta.fields(CpuFeatures)) |field| {
        if (field.type == bool) @field(every, field.name) = true;
    }
    try testing.expectEqual(every, zen4.covered);
    try testing.expect(zen4.midr_covered and zen4.features.midr == null);
    try testing.expectEqual(null, from_cpuinfo(.x86_64, "vmx flags\t: aes pclmulqdq\n", null));
}

test "a field that needs more than one word is false where one is missing" {
    const at = struct {
        fn flags(comptime words: []const u8) CpuFeatures {
            return from_cpuinfo(.x86_64, "vendor_id\t: GenuineIntel\nflags\t\t: fpu sse2 " ++ words ++ "\n", null).?.features;
        }
    };
    try testing.expect(at.flags("ssse3 sse4_1 sha_ni").sha256);
    try testing.expect(!at.flags("ssse3 sha_ni").sha256 and !at.flags("sse4_1 sha_ni").sha256);
    try testing.expect(!at.flags("pclmulqdq").pclmul and at.flags("pclmulqdq sse4_1").pclmul);
    try testing.expect(at.flags("sse4_1").sse4_1 and !at.flags("sse4_2").sse4_1);
    try testing.expect(at.flags("avx2 vaes vpclmulqdq").vaes and !at.flags("avx2 vaes").vaes);
    try testing.expect(!at.flags("vaes vpclmulqdq").vaes);
    try testing.expect(!at.flags("vpclmulqdq").vpclmul and at.flags("avx vpclmulqdq").vpclmul);
    try testing.expect(!at.flags("sha512").sha512 and at.flags("avx sha512").sha512);
    try testing.expect(!at.flags("avx512f avx512bw avx512dq").avx512);
    try testing.expect(!at.flags("avx512_vnni").vnni and at.flags("avx512f avx512_vnni").vnni);
    try testing.expect(!at.flags("bmi2").bmi2 and at.flags("ssse3 bmi2").bmi2);
}

test "the vendor_id line gives the two fields that choose a path" {
    const avx512 = "flags\t\t: avx512f avx512bw avx512dq avx512vl\n";
    const intel = from_cpuinfo(.x86_64, "vendor_id\t: GenuineIntel\n" ++ avx512, null).?.features;
    try testing.expect(intel.lazy_loop_fast and !intel.vpmullq_fast);
    const amd = from_cpuinfo(.x86_64, "vendor_id\t: AuthenticAMD\n" ++ avx512, null).?.features;
    try testing.expect(!amd.lazy_loop_fast and amd.vpmullq_fast);
    const amd_without_avx512 = from_cpuinfo(.x86_64, "vendor_id\t: AuthenticAMD\nflags\t\t: avx2\n", null).?.features;
    try testing.expect(!amd_without_avx512.vpmullq_fast);
}

test "the Features line of aarch64's cpuinfo gives each feature from its own word" {
    const n1 = from_cpuinfo(.aarch64, aarch64_cpuinfo, null).?;
    try testing.expectEqual(CpuFeatures{ .crc32 = true, .pmull = true, .dotprod = true, .aes = true, .sha256 = true, .dit = true }, n1.features);
    try testing.expect(!n1.covered.madd_addend_slow and n1.covered.avx2 and n1.covered.sve2);
    const every = from_cpuinfo(.aarch64, "Features\t: fp asimd aes pmull sha2 sha3 sha512 sve2 dit\n", null).?.features;
    try testing.expect(every.sha3 and every.sha512 and every.sve2);
    // SVE's own words are not the features.
    const sve = from_cpuinfo(.aarch64, "Features\t: fp asimd sve svesha3 sveaes svepmull\n", null).?.features;
    try testing.expectEqual(CpuFeatures{}, sve);
    try testing.expectEqual(null, from_cpuinfo(.aarch64, x86_64_cpuinfo, null));
    try testing.expectEqual(null, from_cpuinfo(.riscv64, aarch64_cpuinfo, null));
}

test "sysctl's values give 1 as present and 0 as absent, and a missing name leaves its field out" {
    const every = "hw.optional.armv8_crc32: 1\nhw.optional.arm.FEAT_PMULL: 1\nhw.optional.arm.FEAT_DotProd: 1\n" ++
        "hw.optional.arm.FEAT_AES: 1\nhw.optional.arm.FEAT_SHA256: 1\nhw.optional.arm.FEAT_SHA512: 1\n" ++
        "hw.optional.arm.FEAT_SHA3: 1\nhw.optional.arm.FEAT_SVE2: 0\nhw.optional.arm.FEAT_DIT: 1\n";
    const m1 = from_sysctl_arm(every);
    try testing.expectEqual(CpuFeatures{ .crc32 = true, .pmull = true, .dotprod = true, .aes = true, .sha256 = true, .sha512 = true, .sha3 = true, .dit = true }, m1.features);
    try testing.expect(m1.covered.sve2 and !m1.covered.madd_addend_slow);
    const older = from_sysctl_arm("hw.optional.arm.FEAT_AES: 1\nhw.optional.arm.FEAT_SHA1: 1\nhw.optional.arm.FEAT_DIT: 2\n");
    try testing.expect(older.covered.aes and older.features.aes and older.midr_covered);
    try testing.expect(!older.covered.sve2 and !older.covered.sha256 and !older.covered.dit);
}

test "machdep's words give each x86-64 feature, and no Intel Mac has SHA-512 or AMD's path" {
    const ice_lake = from_machdep("GenuineIntel\nFPU SSE AES PCLMULQDQ SSSE3 SSE4.1 AVX1.0\nAVX2 BMI2 SHA VAES VPCLMULQDQ AVX512F\n");
    try testing.expectEqual(CpuFeatures{
        .ssse3 = true,
        .sse4_1 = true,
        .pclmul = true,
        .avx2 = true,
        .vpclmul = true,
        .bmi2 = true,
        .lazy_loop_fast = true,
        .aes = true,
        .sha256 = true,
        .vaes = true,
    }, ice_lake.features);
    try testing.expect(!ice_lake.covered.avx512 and !ice_lake.covered.vnni and ice_lake.covered.sha512);
    const without_sse4_1 = from_machdep("GenuineIntel\nFPU SSE AES PCLMULQDQ SSSE3\nAVX2 SHA VAES\n").features;
    try testing.expect(!without_sse4_1.pclmul and !without_sse4_1.sha256 and !without_sse4_1.sse4_1);
}

test "a report compares the fields it covers, and no other" {
    var reference: Reference = .{ .source = "a test" };
    reference.give("aes", true);
    reference.give("sha3", false);
    try testing.expectEqual(CpuFeatures{ .aes = true }, reference.covered_of(.{ .aes = true, .sha3 = false, .avx2 = true, .midr = neoverse_n2 }));
    try testing.expect(!std.meta.eql(reference.features, reference.covered_of(.{ .sha3 = true })));
    reference.give_midr(neoverse_n2);
    try testing.expectEqual(neoverse_n2, reference.covered_of(.{ .midr = neoverse_n2 }).midr.?);
    try testing.expect(!std.meta.eql(reference.features, reference.covered_of(.{ .aes = true, .midr = cortex_a55 })));
}

/// Two cores of different kinds, as a big.LITTLE system's /proc/cpuinfo lists them.
const two_cores = "processor\t: 0\n" ++
    "Features\t: fp asimd aes pmull sha2 cpuid sve2\n" ++
    "CPU implementer\t: 0x41\nCPU architecture: 8\nCPU variant\t: 0x1\nCPU part\t: 0xd05\nCPU revision\t: 0\n\n" ++
    "processor\t: 1\n" ++
    "Features\t: fp asimd aes pmull sha2 cpuid sve2\n" ++
    "CPU implementer\t: 0x41\nCPU architecture: 8\nCPU variant\t: 0x0\nCPU part\t: 0xd49\nCPU revision\t: 2\n";

const cortex_a55: Midr = .{ .implementer = 0x41, .variant = 1, .architecture = 0xf, .part = 0xd05, .revision = 0 };
const neoverse_n2: Midr = .{ .implementer = 0x41, .variant = 0, .architecture = 0xf, .part = 0xd49, .revision = 2 };

test "the MIDR is the core whose lines match detection's, or the first core's, where cpuid is named" {
    try testing.expectEqual(neoverse_n2, from_cpuinfo(.aarch64, two_cores, neoverse_n2).?.features.midr.?);
    try testing.expectEqual(cortex_a55, from_cpuinfo(.aarch64, two_cores, cortex_a55).?.features.midr.?);
    try testing.expectEqual(cortex_a55, from_cpuinfo(.aarch64, two_cores, null).?.features.midr.?);
    // Without cpuid, detection reads no MIDR, whatever the lines say.
    const without_cpuid = "processor\t: 0\nFeatures\t: fp asimd sve2\nCPU implementer\t: 0x41\nCPU architecture: 8\n" ++
        "CPU variant\t: 0x0\nCPU part\t: 0xd49\nCPU revision\t: 2\n";
    const reference = from_cpuinfo(.aarch64, without_cpuid, neoverse_n2).?;
    try testing.expect(reference.midr_covered and reference.features.midr == null);
}

test "a core's lines give its MIDR in hexadecimal and decimal, and Linux's architecture 8 is 0xf" {
    const core = "\t: 3\nCPU implementer\t: 0x61\nCPU architecture: 8\nCPU variant\t: 0x2\nCPU part\t: 0x022\nCPU revision\t: 11\n";
    try testing.expectEqual(Midr{ .implementer = 0x61, .variant = 2, .architecture = 0xf, .part = 0x22, .revision = 11 }, midr_of(core).?);
    try testing.expectEqual(null, midr_of("CPU implementer\t: 0x41\nCPU architecture: 7\nCPU variant\t: 0x0\nCPU part\t: 0xd49\nCPU revision\t: 0\n"));
    try testing.expectEqual(null, midr_of("CPU implementer\t: 0x41\nCPU architecture: 8\nCPU variant\t: 0x0\nCPU revision\t: 0\n"));
    try testing.expectEqual(null, midr_of("CPU implementer\t: 0x141\nCPU architecture: 8\nCPU variant\t: 0x0\nCPU part\t: 0xd49\nCPU revision\t: 0\n"));
}

test "this build's target guarantees no feature" {
    try testing.expectEqual(CpuFeatures.none(), CpuFeatures.target());
}

test {
    _ = platform_check_dit;
}
