//! bench-checksum: CRC-32 and Adler-32 throughput, for design §8 step 4 and decision 14's claim
//! S9. The timing is bench/timing/timing.zig's: every candidate of a row interleaved in one run,
//! the median of five runs with the spread, and the losses shown.
//!
//! The candidates:
//! - every path of stdx's checksum module this CPU runs, as `codec.Features.detect()` finds it,
//!   with stdx built for the architecture's baseline CPU and ReleaseSafe, as a caller shipping one
//!   binary builds it (decisions 17 and 21);
//! - zlib, Wuffs, libdeflate and zlib-ng, each built ReleaseFast for the host with its own
//!   run-time dispatch.
//!
//! The sizes run from 64 octets to 1 MiB: a decoder hands its checksum each call's output, which
//! is as small or as large as the caller's buffer. No candidate's speed depends on the octets'
//! values, so the input is SplitMix64's output rather than a corpus file.
//!
//! Usage: `bench_checksum`. It prints Markdown tables to standard output.

const std = @import("std");
const timing = @import("timing");
const oracle = @import("oracle");
const baselines = @import("baselines");
const codec = @import("codec");
const checksum = @import("checksum");

/// The sizes timed, in octets.
const sizes = [_]usize{ 64, 1024, 16 * 1024, 1024 * 1024 };

/// The seed of the input.
const input_seed = 0;

/// The most candidates one check has: stdx's paths and four baselines.
const candidates_max = 8;

/// One implementation of a check, as a function of the start and the octets.
const Candidate = struct {
    name: []const u8,
    update: *const fn (u32, []const u8) u32,
    /// True for a stdx path, false for a baseline.
    stdx: bool,
};

/// One check and its candidates on this CPU.
const Check = struct {
    name: []const u8,
    initial: u32,
    /// The stdx path `fastest` picks on this CPU, by its name among the candidates.
    fastest: []const u8,
    slots: [candidates_max]Candidate = undefined,
    len: usize = 0,

    fn add(self: *Check, candidate: Candidate) void {
        self.slots[self.len] = candidate;
        self.len += 1;
    }

    fn candidates(self: *const Check) []const Candidate {
        return self.slots[0..self.len];
    }
};

/// One timed call: a candidate over one input.
const Call = struct {
    candidate: Candidate,
    input: []const u8,
    initial: u32,

    fn run_once(context: *const anyopaque) void {
        const self: *const Call = @ptrCast(@alignCast(context));
        std.mem.doNotOptimizeAway(self.candidate.update(self.initial, self.input));
    }
};

fn crc32_path(comptime path: checksum.Crc32Path) Candidate {
    const Update = struct {
        fn update(crc: u32, octets: []const u8) u32 {
            return checksum.crc32(path, crc, octets);
        }
    };
    return .{ .name = "stdx " ++ @tagName(path), .update = Update.update, .stdx = true };
}

fn adler32_path(comptime path: checksum.Adler32Path) Candidate {
    const Update = struct {
        fn update(adler: u32, octets: []const u8) u32 {
            return checksum.adler32(path, adler, octets);
        }
    };
    return .{ .name = "stdx " ++ @tagName(path), .update = Update.update, .stdx = true };
}

fn wuffs_crc32(_: u32, octets: []const u8) u32 {
    return oracle.wuffs_crc32(octets);
}

fn wuffs_adler32(_: u32, octets: []const u8) u32 {
    return oracle.wuffs_adler32(octets);
}

fn build_checks(features: checksum.Features) [2]Check {
    var crc32: Check = .{ .name = "CRC-32", .initial = 0, .fastest = "" };
    inline for (comptime std.enums.values(checksum.Crc32Path)) |path| {
        if (path.runs_on(features)) crc32.add(crc32_path(path));
        if (path == checksum.Crc32Path.fastest(features)) crc32.fastest = crc32_path(path).name;
    }
    crc32.add(.{ .name = "zlib", .update = oracle.zlib_crc32, .stdx = false });
    crc32.add(.{ .name = "Wuffs", .update = wuffs_crc32, .stdx = false });
    crc32.add(.{ .name = "libdeflate", .update = baselines.libdeflate_crc32, .stdx = false });
    crc32.add(.{ .name = "zlib-ng", .update = baselines.zlib_ng_crc32, .stdx = false });

    var adler32: Check = .{ .name = "Adler-32", .initial = checksum.constants.adler32_initial, .fastest = "" };
    inline for (comptime std.enums.values(checksum.Adler32Path)) |path| {
        if (path.runs_on(features)) adler32.add(adler32_path(path));
        if (path == checksum.Adler32Path.fastest(features)) adler32.fastest = adler32_path(path).name;
    }
    adler32.add(.{ .name = "zlib", .update = oracle.zlib_adler32, .stdx = false });
    adler32.add(.{ .name = "Wuffs", .update = wuffs_adler32, .stdx = false });
    adler32.add(.{ .name = "libdeflate", .update = baselines.libdeflate_adler32, .stdx = false });
    adler32.add(.{ .name = "zlib-ng", .update = baselines.zlib_ng_adler32, .stdx = false });
    return .{ crc32, adler32 };
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;

    const input = try init.arena.allocator().alloc(u8, sizes[sizes.len - 1]);
    var generator = codec.split.Generator.init(input_seed);
    for (input) |*octet| octet.* = @truncate(generator.next());

    const features = codec.Features.detect();
    const wanted: checksum.Features = .{
        .pclmul = features.pclmul,
        .avx2 = features.avx2,
        .vpclmul = features.vpclmul,
        .avx512 = features.avx512,
        .crc32 = features.crc32,
        .pmull = features.pmull,
    };
    for (build_checks(wanted)) |check| {
        try check_agrees(check, input);
        try report_check(io, out, check, input);
    }
    try out.flush();
}

/// Refuses to time candidates that disagree: a fast wrong answer is not a result.
fn check_agrees(check: Check, input: []const u8) !void {
    for (sizes) |size| {
        const wanted = check.candidates()[0].update(check.initial, input[0..size]);
        for (check.candidates()) |candidate| {
            if (candidate.update(check.initial, input[0..size]) != wanted) {
                std.debug.print("bench-checksum: {s} by {s} disagrees at {d} octets\n", .{ check.name, candidate.name, size });
                return error.CandidatesDisagree;
            }
        }
    }
}

fn report_check(io: std.Io, out: *std.Io.Writer, check: Check, input: []const u8) !void {
    try out.print("## {s}, GB/s\n\n| Octets |", .{check.name});
    for (check.candidates()) |candidate| try out.print(" {s} |", .{candidate.name});
    try out.print(" {s} / fastest baseline |\n|---|", .{check.fastest});
    for (check.candidates()) |_| try out.print("---|", .{});
    try out.print("---|\n", .{});
    for (sizes) |size| try report_size(io, out, check, input[0..size]);
    try out.print("\n", .{});
}

fn report_size(io: std.Io, out: *std.Io.Writer, check: Check, input: []const u8) !void {
    var calls: [candidates_max]Call = undefined;
    var operations: [candidates_max]timing.Operation = undefined;
    for (check.candidates(), 0..) |candidate, index| {
        calls[index] = .{ .candidate = candidate, .input = input, .initial = check.initial };
        operations[index] = .{ .context = &calls[index], .run_once = Call.run_once };
    }
    var runs: [candidates_max][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, operations[0..check.len], runs[0..check.len]);
    try out.print("| {d} |", .{input.len});
    var fastest_rate: f64 = 0;
    var baseline_rate: f64 = 0;
    var baseline_name: []const u8 = "";
    for (check.candidates(), runs[0..check.len]) |candidate, candidate_runs| {
        const summary = timing.summarize(candidate_runs);
        const rate = timing.gigabytes_per_second(input.len, summary.median);
        try out.print(" {d:.2} ± {d:.1}% |", .{ rate, summary.spread * 100 });
        if (std.mem.eql(u8, candidate.name, check.fastest)) fastest_rate = rate;
        if (!candidate.stdx and rate > baseline_rate) {
            baseline_rate = rate;
            baseline_name = candidate.name;
        }
    }
    try out.print(" {d:.2} ({s}) |\n", .{ fastest_rate / baseline_rate, baseline_name });
}
