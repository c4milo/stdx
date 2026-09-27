//! bench-zstd: Zstandard decoding throughput over the corpora of decision 15, measured the way
//! decisions 10 and 20 fix: every candidate in this one program, interleaved in the same run, five
//! runs each, the median and the spread reported, and the losses shown. The timing is
//! bench/timing/timing.zig's.
//!
//! - Decoding: libzstd's decoder, with a context kept across decodes as a server keeps one, and
//!   stdx's HTTP decoder, a window of 2^23 (decision 12), over each corpus file encoded by libzstd
//!   at `decode_level`, its default. Throughput counts decoded octets. Each decoder's output is
//!   compared with the input before any is timed.
//!
//! - stdx's paths: its HTTP decoder with the fast paths of decision 16 and on its checked path
//!   alone, the A/B that admits the fast paths.
//! - Decision 14's claims: stdx's decoder with each claim off in turn against the decoder with all
//!   on (design §8 step 11), each claim's A/B, reported as the ratio of the two throughputs.
//!
//! stdx's decoder is a candidate from design §8 step 11. It picks its checksum path from the CPU's
//! features, as a caller does (decision 21).
//!
//! libzstd's C is built ReleaseFast. This program is built ReleaseSafe, stdx's production mode, so
//! stdx is measured as callers run it (decision 17).
//!
//! Usage: `bench_zstd <name>=<path>...`. It prints Markdown tables to standard output.

const std = @import("std");
const oracle = @import("oracle");
const timing = @import("timing");
const codec = @import("codec");
const zstd = @import("zstd");

/// The libzstd level whose frames the decoders are timed on: its default.
const decode_level: c_int = 3;

/// A decode of one frame by libzstd, with a context kept across runs.
const LibzstdDecode = struct {
    frame: []const u8,
    output: []u8,
    context: *oracle.ZstdContext,

    fn run_once(context: *const anyopaque) void {
        const self: *const LibzstdDecode = @ptrCast(@alignCast(context));
        std.debug.assert(oracle.zstd_decode_with(self.context, self.frame, self.output) == self.output.len);
    }
};

/// A decode of one frame by a stdx decoder taking `paths`, started with `init` and taken in one
/// call.
fn StdxDecode(comptime paths: zstd.claims.Paths) type {
    return struct {
        const Self = @This();
        pub const Decoder = zstd.Decoder(.{ .paths = paths });

        frame: []const u8,
        output: []u8,
        decoder: *Decoder,
        features: codec.Features,

        fn run_once(context: *const anyopaque) void {
            const self: *const Self = @ptrCast(@alignCast(context));
            self.decoder.init(self.features);
            const progress = self.decoder.decode(self.frame, self.output) catch unreachable;
            std.debug.assert(progress.status == .done and progress.written == self.output.len);
        }

        fn of(arena: std.mem.Allocator, frame: []const u8, len: usize) !Self {
            return .{ .frame = frame, .output = try arena.alloc(u8, len), .decoder = try arena.create(Decoder), .features = codec.Features.detect() };
        }
    };
}

const Fast = StdxDecode(.{});
const Checked = StdxDecode(.{ .fast_paths = false });

const File = struct {
    name: []const u8,
    input: []const u8,
};

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;

    var files: std.ArrayList(File) = .empty;
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse return error.UsageNameEqualsPath;
        const input = try std.Io.Dir.cwd().readFileAlloc(io, argument[split + 1 ..], arena, .unlimited);
        try files.append(arena, .{ .name = argument[0..split], .input = input });
    }
    const context = oracle.zstd_context_create() orelse return error.OutOfMemory;
    defer oracle.zstd_context_free(context);

    try out.print("## Decoding, libzstd level {d}\n\n", .{decode_level});
    try out.print("| File | Octets | libzstd, MB/s | stdx, MB/s | stdx / libzstd |\n|---|---|---|---|---|\n", .{});
    for (files.items) |file| try report_decode(arena, io, out, file, context);
    try out.print("\n## stdx's fast paths against its checked path, libzstd level {d}\n\n", .{decode_level});
    try out.print("| File | Octets | Checked, MB/s | Fast, MB/s | Fast / checked |\n|---|---|---|---|---|\n", .{});
    for (files.items) |file| try report_paths(arena, io, out, file);
    try out.print("\n## Decision 14's claims, each off against the fast paths with all on, libzstd level {d}\n\n", .{decode_level});
    try out.print("Each claim's column is its throughput with the claim off over the throughput with all on.\n\n", .{});
    try out.print("| File | Octets | All on, MB/s |", .{});
    for (zstd.claims.each_off_names) |name| try out.print(" {s} off |", .{name});
    try out.print("\n|---|---|---|", .{});
    for (zstd.claims.each_off_names) |_| try out.print("---|", .{});
    try out.print("\n", .{});
    for (files.items) |file| try report_claims(arena, io, out, file);
    try out.flush();
}

/// The median rate of each candidate's runs over `len` octets, and its spread in percent.
fn rates_of(comptime count: usize, runs: *const [count][timing.run_count]f64, len: usize) [2][count]f64 {
    var result: [2][count]f64 = undefined;
    for (runs, 0..) |candidate_runs, index| {
        const summary = timing.summarize(candidate_runs);
        result[0][index] = timing.megabytes_per_second(len, summary.median);
        result[1][index] = summary.spread * 100;
    }
    return result;
}

/// libzstd's frame of `file` at `decode_level`.
fn frame_of(arena: std.mem.Allocator, file: File) ![]const u8 {
    const encoded = try arena.alloc(u8, oracle.zstd_bound(file.input.len));
    const frame_len = oracle.zstd_encode(.{ .level = decode_level }, file.input, encoded) orelse return error.EncodeFailed;
    return encoded[0..frame_len];
}

fn report_decode(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File, context: *oracle.ZstdContext) !void {
    const frame = try frame_of(arena, file);
    const libzstd: LibzstdDecode = .{ .frame = frame, .output = try arena.alloc(u8, file.input.len), .context = context };
    const stdx = try Fast.of(arena, frame, file.input.len);
    const candidates = [_]timing.Operation{
        .{ .context = &libzstd, .run_once = LibzstdDecode.run_once },
        .{ .context = &stdx, .run_once = Fast.run_once },
    };
    // Every candidate decodes the input back before any is timed.
    for (candidates) |candidate| candidate.run_once(candidate.context);
    for ([_][]const u8{ libzstd.output, stdx.output }) |output| {
        if (!std.mem.eql(u8, file.input, output)) return error.CandidatesDisagree;
    }
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, file.input.len);
    try out.print("| {s} | {d} | {d:.1} ±{d:.1}% | {d:.1} ±{d:.1}% | {d:.2} |\n", .{
        file.name,                 file.input.len, rates[0][0], rates[1][0], rates[0][1], rates[1][1],
        rates[0][1] / rates[0][0],
    });
}

/// Times each candidate over `file`'s frame after checking it decodes the file, and returns the
/// median rates and spreads.
fn time_candidates(comptime count: usize, io: std.Io, file: File, candidates: *const [count]timing.Operation, outputs: *const [count][]const u8) ![2][count]f64 {
    for (candidates) |candidate| candidate.run_once(candidate.context);
    for (outputs) |output| {
        if (!std.mem.eql(u8, file.input, output)) return error.CandidatesDisagree;
    }
    var runs: [count][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, candidates, &runs);
    return rates_of(count, &runs, file.input.len);
}

fn report_paths(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const frame = try frame_of(arena, file);
    const checked = try Checked.of(arena, frame, file.input.len);
    const fast = try Fast.of(arena, frame, file.input.len);
    const candidates = [_]timing.Operation{
        .{ .context = &checked, .run_once = Checked.run_once },
        .{ .context = &fast, .run_once = Fast.run_once },
    };
    const rates = try time_candidates(candidates.len, io, file, &candidates, &.{ checked.output, fast.output });
    try out.print("| {s} | {d} | {d:.1} ±{d:.1}% | {d:.1} ±{d:.1}% | {d:.2} |\n", .{
        file.name,                 file.input.len, rates[0][0], rates[1][0], rates[0][1], rates[1][1],
        rates[0][1] / rates[0][0],
    });
}

/// One decode per claim off, each of its own type.
const ClaimsOff = claims_off: {
    var types: [zstd.claims.each_off.len]type = undefined;
    for (zstd.claims.each_off, 0..) |off, index| types[index] = StdxDecode(.{ .claims = off });
    break :claims_off std.meta.Tuple(&types);
};

fn report_claims(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const frame = try frame_of(arena, file);
    const all_on = try Fast.of(arena, frame, file.input.len);
    var candidates: [1 + zstd.claims.each_off.len]timing.Operation = undefined;
    var outputs: [candidates.len][]const u8 = undefined;
    candidates[0] = .{ .context = &all_on, .run_once = Fast.run_once };
    outputs[0] = all_on.output;
    var offs: ClaimsOff = undefined;
    inline for (zstd.claims.each_off, 0..) |off, index| {
        const Off = StdxDecode(.{ .claims = off });
        offs[index] = try Off.of(arena, frame, file.input.len);
        candidates[1 + index] = .{ .context = &offs[index], .run_once = Off.run_once };
        outputs[1 + index] = offs[index].output;
    }
    const rates = try time_candidates(candidates.len, io, file, &candidates, &outputs);
    try out.print("| {s} | {d} | {d:.1} ±{d:.1}% |", .{ file.name, file.input.len, rates[0][0], rates[1][0] });
    for (1..candidates.len) |index| try out.print(" {d:.2} ±{d:.1}% |", .{ rates[0][index] / rates[0][0], rates[1][index] });
    try out.print("\n", .{});
}
