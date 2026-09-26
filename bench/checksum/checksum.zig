//! bench-checksum: CRC-32 and Adler-32 throughput, for design §8 step 4 and decision 14's claim
//! S9, and XXH64's, for step 10. The timing is bench/timing/timing.zig's: every candidate of a row
//! interleaved in one run, the median of five runs with the spread, and the losses shown.
//!
//! The candidates:
//! - every path of stdx's checksum module this CPU runs, as `codec.Features.detect()` finds it,
//!   with stdx built for the architecture's baseline CPU and ReleaseSafe, as a caller shipping one
//!   binary builds it (decisions 17 and 21);
//! - zlib, Wuffs, libdeflate and zlib-ng, each built ReleaseFast for the host with its own
//!   run-time dispatch.
//! - XXH64 against libzstd's copy of xxHash's XXH64, which libzstd's library exports, and beside
//!   stdx's fastest CRC-32 path, the check a gzip decoder pays, so the two checks' costs compare
//!   within one run.
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

/// The baselines each check is timed against: zlib, Wuffs, libdeflate and zlib-ng.
const baseline_count = 4;

/// The most candidates one check has: every path of the check with the most, and the baselines.
const candidates_max: usize = @as(usize, @max(
    std.enums.values(checksum.Crc32Path).len,
    std.enums.values(checksum.Adler32Path).len,
)) + baseline_count;

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
    const wanted = checksum.Features.from(features);
    const checks = build_checks(wanted);
    for (checks) |check| {
        try check_agrees(check, input);
        try report_check(io, out, check, input);
    }
    try report_xxh64(io, out, checks[0], wanted, input);
    try out.flush();
}

/// One timed XXH64 of one input by one path, from seed 0.
const Xxh64Call = struct {
    input: []const u8,
    path: checksum.Xxh64Path,

    fn run_once(context: *const anyopaque) void {
        const self: *const Xxh64Call = @ptrCast(@alignCast(context));
        std.mem.doNotOptimizeAway(checksum.xxh64(self.path, 0, self.input));
    }
};

/// One timed XXH64 of one input by libzstd, from seed 0.
const ZstdXxh64Call = struct {
    input: []const u8,

    fn run_once(context: *const anyopaque) void {
        const self: *const ZstdXxh64Call = @ptrCast(@alignCast(context));
        std.mem.doNotOptimizeAway(oracle.zstd_xxh64(0, self.input));
    }
};

/// The XXH64 paths, libzstd's XXH64 and the CRC-32 path one row times.
const xxh64_candidates_max = std.enums.values(checksum.Xxh64Path).len + 2;

/// XXH64 at every size by every path this CPU runs, interleaved with the fastest stdx path of
/// `crc32`. The last column is decision 21's A/B: the fastest path over the scalar path.
fn report_xxh64(io: std.Io, out: *std.Io.Writer, crc32: Check, features: checksum.Features, input: []const u8) !void {
    const fastest_crc32 = for (crc32.candidates()) |candidate| {
        if (std.mem.eql(u8, candidate.name, crc32.fastest)) break candidate;
    } else unreachable;
    var paths: [xxh64_candidates_max]checksum.Xxh64Path = undefined;
    var paths_len: usize = 0;
    for (std.enums.values(checksum.Xxh64Path)) |path| {
        if (!path.runs_on(features)) continue;
        if (checksum.xxh64(path, 0, input) != oracle.zstd_xxh64(0, input)) return error.CandidatesDisagree;
        paths[paths_len] = path;
        paths_len += 1;
    }
    const fastest = checksum.Xxh64Path.fastest(features);
    try out.print("## XXH64, GB/s\n\n| Octets |", .{});
    for (paths[0..paths_len]) |path| try out.print(" stdx {s} |", .{@tagName(path)});
    try out.print(" libzstd | CRC-32 by {s} | {s} / scalar | {s} / libzstd | {s} / CRC-32 |\n|---|", .{
        fastest_crc32.name, @tagName(fastest), @tagName(fastest), @tagName(fastest),
    });
    for (0..paths_len + 5) |_| try out.print("---|", .{});
    try out.print("\n", .{});
    for (sizes) |size| try report_xxh64_size(io, out, paths[0..paths_len], fastest, fastest_crc32, crc32.initial, input[0..size]);
    try out.print("\n", .{});
}

fn report_xxh64_size(io: std.Io, out: *std.Io.Writer, paths: []const checksum.Xxh64Path, fastest: checksum.Xxh64Path, crc32: Candidate, crc32_initial: u32, input: []const u8) !void {
    var calls: [xxh64_candidates_max]Xxh64Call = undefined;
    var operations: [xxh64_candidates_max]timing.Operation = undefined;
    for (paths, 0..) |path, index| {
        calls[index] = .{ .input = input, .path = path };
        operations[index] = .{ .context = &calls[index], .run_once = Xxh64Call.run_once };
    }
    const zstd: ZstdXxh64Call = .{ .input = input };
    operations[paths.len] = .{ .context = &zstd, .run_once = ZstdXxh64Call.run_once };
    const crc: Call = .{ .candidate = crc32, .input = input, .initial = crc32_initial };
    operations[paths.len + 1] = .{ .context = &crc, .run_once = Call.run_once };
    const count = paths.len + 2;
    var runs: [xxh64_candidates_max][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, operations[0..count], runs[0..count]);
    var rates: [xxh64_candidates_max]f64 = undefined;
    try out.print("| {d} |", .{input.len});
    for (runs[0..count], rates[0..count]) |candidate_runs, *rate| {
        const summary = timing.summarize(candidate_runs);
        rate.* = timing.gigabytes_per_second(input.len, summary.median);
        try out.print(" {d:.2} ± {d:.1}% |", .{ rate.*, summary.spread * 100 });
    }
    const fastest_rate = rates[std.mem.indexOfScalar(checksum.Xxh64Path, paths, fastest).?];
    try out.print(" {d:.2} | {d:.2} | {d:.2} |\n", .{ fastest_rate / rates[0], fastest_rate / rates[paths.len], fastest_rate / rates[paths.len + 1] });
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
