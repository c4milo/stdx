//! The check of decision 40: on this host, `platform.probe()` gives the answers the host reports
//! through a source the probe does not read.
//! - Linux: /proc/cpuinfo, its `flags` line on x86-64 (`aes`, `pclmulqdq`) and its `Features`
//!   line on aarch64 (`aes`, `pmull`, `dit`).
//! - macOS on aarch64: `sysctl hw.optional.arm`, its `FEAT_AES`, `FEAT_PMULL` and `FEAT_DIT`.
//! - macOS on x86-64: `sysctl -n machdep.cpu.features`, its `AES` and `PCLMULQDQ`.
//!
//! The answers must be equal, `not_known` included: x86-64 reports no DIT, and a macOS release
//! older than a sysctl name reports nothing for it. The build compiles `platform` for the generic
//! CPU of the host's architecture, so no answer comes from what the build target guarantees, and
//! on Linux it builds this check twice, without libc and with it: the probe reads the auxiliary
//! vector through Zig's `getauxval` in one and libc's in the other.
//!
//! On any other host the check has no reference, says so, and passes having checked nothing.
//!
//! The check reads a file and runs a process, which no source under `src/` may do. That is why it
//! is a tool, and not a unit test of the module.
//!
//! Usage: `platform_check`
const std = @import("std");
const builtin = @import("builtin");
const platform = @import("platform");

const Answer = platform.Answer;
const Cpu = platform.Cpu;

/// The program macOS reads its sysctl values with.
const sysctl_path = "/usr/sbin/sysctl";

/// A report of the host's features and where it came from.
const Reference = struct { source: []const u8, cpu: Cpu };

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const system = @tagName(builtin.cpu.arch) ++ "-" ++ @tagName(builtin.os.tag);
    if (guarantees_a_feature(builtin.cpu)) {
        // The probe answers from the target where its source gives nothing, so a check built for
        // such a CPU would pass a probe that failed to read its source.
        std.debug.print("platform-check BROKEN: built for a CPU that guarantees a feature it checks\n", .{});
        std.process.exit(1);
    }
    const reference = try read_reference(arena, init.io) orelse {
        std.debug.print("platform-check: no reference on {s}; nothing checked\n", .{system});
        return;
    };
    const probed = platform.probe();
    std.debug.print(
        "platform-check, {s}, libc {}: the probe says aes_clmul {t}, dit {t}; {s} says {t}, {t}\n",
        .{ system, builtin.link_libc, probed.aes_clmul, probed.dit, reference.source, reference.cpu.aes_clmul, reference.cpu.dit },
    );
    if (std.meta.eql(probed, reference.cpu)) return;
    std.debug.print("platform-check FAILED: the probe and {s} disagree\n", .{reference.source});
    std.process.exit(1);
}

/// True when the build target guarantees a feature the probe answers about.
fn guarantees_a_feature(cpu: std.Target.Cpu) bool {
    return switch (cpu.arch) {
        .x86_64 => std.Target.x86.featureSetHasAny(cpu.features, .{ .aes, .pclmul }),
        .aarch64 => std.Target.aarch64.featureSetHasAny(cpu.features, .{ .aes, .dit }),
        else => false,
    };
}

fn read_reference(arena: std.mem.Allocator, io: std.Io) !?Reference {
    switch (builtin.os.tag) {
        .linux => {
            const text = try read_cpuinfo(arena, io);
            const cpu = from_cpuinfo(builtin.cpu.arch, text) orelse return error.NoFeaturesLine;
            return .{ .source = "/proc/cpuinfo", .cpu = cpu };
        },
        .macos => return switch (builtin.cpu.arch) {
            .aarch64 => .{
                .source = "sysctl hw.optional.arm",
                .cpu = from_sysctl_arm(try run_sysctl(arena, io, &.{ sysctl_path, "hw.optional.arm" })),
            },
            .x86_64 => .{
                .source = "sysctl machdep.cpu.features",
                .cpu = from_machdep(try run_sysctl(arena, io, &.{ sysctl_path, "-n", "machdep.cpu.features" })),
            },
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

/// The answers a Linux /proc/cpuinfo gives on `arch`, or null when it holds no line of features.
fn from_cpuinfo(arch: std.Target.Cpu.Arch, text: []const u8) ?Cpu {
    switch (arch) {
        .x86_64 => {
            const words = value_of(text, "flags") orelse return null;
            return .{ .aes_clmul = both(has_word(words, "aes"), has_word(words, "pclmulqdq")), .dit = .not_known };
        },
        .aarch64 => {
            const words = value_of(text, "Features") orelse return null;
            const dit: Answer = if (has_word(words, "dit")) .yes else .no;
            return .{ .aes_clmul = both(has_word(words, "aes"), has_word(words, "pmull")), .dit = dit };
        },
        else => return null,
    }
}

/// The answers `sysctl hw.optional.arm` gives: 1 is `yes`, 0 is `no`, and a name it does not
/// print is `not_known`.
fn from_sysctl_arm(text: []const u8) Cpu {
    const aes = sysctl_answer(text, "hw.optional.arm.FEAT_AES");
    const pmull = sysctl_answer(text, "hw.optional.arm.FEAT_PMULL");
    const aes_clmul: Answer = if (aes == .no or pmull == .no) .no else if (aes == .yes and pmull == .yes) .yes else .not_known;
    return .{ .aes_clmul = aes_clmul, .dit = sysctl_answer(text, "hw.optional.arm.FEAT_DIT") };
}

/// The answers of the words `sysctl -n machdep.cpu.features` prints.
fn from_machdep(text: []const u8) Cpu {
    return .{ .aes_clmul = both(has_word(text, "AES"), has_word(text, "PCLMULQDQ")), .dit = .not_known };
}

fn sysctl_answer(text: []const u8, name: []const u8) Answer {
    const value = std.mem.trim(u8, value_of(text, name) orelse return .not_known, " \t");
    if (std.mem.eql(u8, value, "1")) return .yes;
    if (std.mem.eql(u8, value, "0")) return .no;
    return .not_known;
}

fn both(first: bool, second: bool) Answer {
    return if (first and second) .yes else .no;
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
    "flags\t\t: fpu vme sse sse2 pni pclmulqdq ssse3 sse4_1 aes xsave avx vaes vpclmulqdq\n" ++
    "vmx flags\t: vnmi preemption_timer\n" ++
    "bugs\t\t: sysret_ss_attrs\n";

const aarch64_cpuinfo = "processor\t: 0\n" ++
    "BogoMIPS\t: 2000.00\n" ++
    "Features\t: fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics dit uscat sveaes svepmull\n" ++
    "CPU implementer\t: 0x41\n";

test "the flags line of x86-64's cpuinfo answers from aes and pclmulqdq alone" {
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .not_known }, from_cpuinfo(.x86_64, x86_64_cpuinfo).?);
    const no_aes = "flags\t\t: fpu pclmulqdq vaes vpclmulqdq\nvmx flags\t: aes\n";
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .not_known }, from_cpuinfo(.x86_64, no_aes).?);
    const no_pclmulqdq = "flags\t\t: fpu aes vpclmulqdq\n";
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .not_known }, from_cpuinfo(.x86_64, no_pclmulqdq).?);
    try testing.expectEqual(null, from_cpuinfo(.x86_64, "vmx flags\t: aes pclmulqdq\n"));
}

test "the Features line of aarch64's cpuinfo answers from aes, pmull and dit alone" {
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .yes }, from_cpuinfo(.aarch64, aarch64_cpuinfo).?);
    const no_pmull = "Features\t: fp asimd aes svepmull dit\n";
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .yes }, from_cpuinfo(.aarch64, no_pmull).?);
    const no_aes_no_dit = "Features\t: fp asimd sveaes pmull uscat\n";
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .no }, from_cpuinfo(.aarch64, no_aes_no_dit).?);
    try testing.expectEqual(null, from_cpuinfo(.aarch64, x86_64_cpuinfo));
    try testing.expectEqual(null, from_cpuinfo(.riscv64, aarch64_cpuinfo));
}

test "the generic CPU guarantees no feature the check reads, and a named model does" {
    try testing.expect(!guarantees_a_feature(std.Target.Cpu.Model.generic(.aarch64).toCpu(.aarch64)));
    try testing.expect(!guarantees_a_feature(std.Target.Cpu.Model.generic(.x86_64).toCpu(.x86_64)));
    try testing.expect(guarantees_a_feature(std.Target.aarch64.cpu.apple_m1.toCpu(.aarch64)));
    try testing.expect(guarantees_a_feature(std.Target.aarch64.cpu.neoverse_n2.toCpu(.aarch64)));
    try testing.expect(guarantees_a_feature(std.Target.x86.cpu.haswell.toCpu(.x86_64)));
    // x86-64-v3, a psABI level, names neither AES-NI nor PCLMULQDQ.
    try testing.expect(!guarantees_a_feature(std.Target.x86.cpu.x86_64_v3.toCpu(.x86_64)));
}

test "sysctl's FEAT_ values answer 1 as yes, 0 as no, and a missing name as not_known" {
    const every = "hw.optional.arm.FEAT_AES: 1\nhw.optional.arm.FEAT_PMULL: 1\nhw.optional.arm.FEAT_DIT: 1\n";
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .yes }, from_sysctl_arm(every));
    const no_pmull = "hw.optional.arm.FEAT_AES: 1\nhw.optional.arm.FEAT_PMULL: 0\nhw.optional.arm.FEAT_DIT: 0\n";
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .no }, from_sysctl_arm(no_pmull));
    const older = "hw.optional.arm.FEAT_AES: 1\nhw.optional.arm.FEAT_SHA1: 1\n";
    try testing.expectEqual(Cpu{ .aes_clmul = .not_known, .dit = .not_known }, from_sysctl_arm(older));
    try testing.expectEqual(Cpu{ .aes_clmul = .yes, .dit = .not_known }, from_machdep("FPU SSE AES PCLMULQDQ SSE4.1\n"));
    try testing.expectEqual(Cpu{ .aes_clmul = .no, .dit = .not_known }, from_machdep("FPU SSE AES VPCLMULQDQ\n"));
}
