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

/// A decode of one frame by stdx's HTTP decoder, started with `init` and taken in one call.
const StdxDecode = struct {
    frame: []const u8,
    output: []u8,
    decoder: *zstd.HttpDecoder,
    features: codec.Features,

    fn run_once(context: *const anyopaque) void {
        const self: *const StdxDecode = @ptrCast(@alignCast(context));
        self.decoder.init(self.features);
        const progress = self.decoder.decode(self.frame, self.output) catch unreachable;
        std.debug.assert(progress.status == .done and progress.written == self.output.len);
    }
};

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
    const decoder = try arena.create(zstd.HttpDecoder);

    try out.print("## Decoding, libzstd level {d}\n\n", .{decode_level});
    try out.print("| File | Octets | libzstd, MB/s | stdx, MB/s | stdx / libzstd |\n|---|---|---|---|---|\n", .{});
    for (files.items) |file| try report_decode(arena, io, out, file, context, decoder);
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

fn report_decode(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File, context: *oracle.ZstdContext, decoder: *zstd.HttpDecoder) !void {
    const encoded = try arena.alloc(u8, oracle.zstd_bound(file.input.len));
    const frame_len = oracle.zstd_encode(.{ .level = decode_level }, file.input, encoded) orelse return error.EncodeFailed;
    const frame = encoded[0..frame_len];
    const libzstd: LibzstdDecode = .{ .frame = frame, .output = try arena.alloc(u8, file.input.len), .context = context };
    const stdx: StdxDecode = .{ .frame = frame, .output = try arena.alloc(u8, file.input.len), .decoder = decoder, .features = codec.Features.detect() };
    const candidates = [_]timing.Operation{
        .{ .context = &libzstd, .run_once = LibzstdDecode.run_once },
        .{ .context = &stdx, .run_once = StdxDecode.run_once },
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
