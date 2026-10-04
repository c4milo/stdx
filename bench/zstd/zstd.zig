//! bench-zstd: Zstandard decoding throughput over the corpora of decision 15, measured the way
//! decisions 10 and 20 fix: every candidate in this one program, interleaved in the same run, five
//! runs each, the median and the spread reported, and the losses shown. The timing is
//! bench/timing/timing.zig's.
//!
//! - The rows: one a corpus file, taken whole, but for the 1 KiB and 16 KiB HTTP bodies, which a
//!   row codes as the slices of their 1 MiB payload, one frame a slice, one after another
//!   (decision 45, bench/timing/inputs.zig).
//! - Decoding: libzstd's decoder, with a context kept across decodes as a server keeps one, and
//!   stdx's HTTP decoder, a window of 2^23 (decision 12), over each row's frames, encoded by
//!   libzstd at `decode_level`, its default. Throughput counts decoded octets. Each decoder's
//!   output is compared with the input before any is timed.
//!
//! - stdx's paths: its HTTP decoder with the fast paths of decision 16 and on its checked path
//!   alone, the A/B that admits the fast paths.
//! - Decision 14's claims: stdx's decoder with each claim off in turn against the decoder with all
//!   on (design §8 step 11), each claim's A/B, reported as the ratio of the two throughputs.
//!
//! - Decision 17's measurement: `bench_zstd_release_fast`, this program with stdx built
//!   ReleaseFast, prints the comparison with libzstd after it. The difference bounds what the
//!   safety checks cost; ReleaseFast is never offered to a caller.
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
const bench_options = @import("bench_options");
const inputs = timing.inputs;
const Input = inputs.Input;

/// The libzstd level whose frames the decoders are timed on: its default.
const decode_level: c_int = 3;

/// libzstd's encoder at `decode_level`, which writes one frame a part for the decoders
/// (`inputs.streams`).
const Frames = struct {
    pub fn bound(_: Frames, part_len: usize) usize {
        return oracle.zstd_bound(part_len);
    }

    pub fn encode(_: Frames, part: []const u8, room: []u8) ?usize {
        return oracle.zstd_encode(.{ .level = decode_level }, part, room);
    }
};

/// A decode of one frame by libzstd, with a context kept across runs.
const LibzstdDecode = struct {
    output: []u8,
    context: *oracle.ZstdContext,

    pub fn run(self: *const LibzstdDecode, frame: []const u8) ?usize {
        return oracle.zstd_decode_with(self.context, frame, self.output);
    }
};

/// A decode of one frame by a stdx decoder taking `paths`, started with `init` and taken in one
/// call.
fn StdxDecode(comptime paths: zstd.claims.Paths) type {
    return struct {
        const Self = @This();
        pub const Decoder = zstd.Decoder(.{ .paths = paths });

        output: []u8,
        decoder: *Decoder,
        features: codec.Features,

        pub fn run(self: *const Self, frame: []const u8) ?usize {
            self.decoder.init(self.features);
            const progress = self.decoder.decode(frame, self.output) catch return null;
            return if (progress.status == .done) progress.written else null;
        }

        /// The decoder checked over `coded` against `input`, and placed for timing.
        fn operation(arena: std.mem.Allocator, coded: []const []const u8, input: Input) !timing.Operation {
            const candidate: Self = .{ .output = try arena.alloc(u8, input.part_len), .decoder = try arena.create(Decoder), .features = codec.Features.detect() };
            return inputs.decoder_operation(arena, candidate, coded, input);
        }
    };
}

const Fast = StdxDecode(.{});
const Checked = StdxDecode(.{ .fast_paths = false });

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;

    var files: std.ArrayList(inputs.File) = .empty;
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse return error.UsageNameEqualsPath;
        const octets = try std.Io.Dir.cwd().readFileAlloc(io, argument[split + 1 ..], arena, .unlimited);
        try files.append(arena, .{ .name = argument[0..split], .octets = octets });
    }
    const rows = try inputs.of(arena, files.items);
    const context = oracle.zstd_context_create() orelse return error.OutOfMemory;
    defer oracle.zstd_context_free(context);

    if (bench_options.release_fast) {
        try out.print("\n## stdx built ReleaseFast against libzstd, libzstd level {d} (decision 17)\n\n", .{decode_level});
        try inputs.note(out, rows);
        try out.print("| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |\n|---|---|---|---|---|---|\n", .{});
        for (rows) |row| try report_decode(arena, io, out, row, context);
        try out.flush();
        return;
    }
    try out.print("## Decoding, libzstd level {d}\n\n", .{decode_level});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |\n|---|---|---|---|---|---|\n", .{});
    for (rows) |row| try report_decode(arena, io, out, row, context);
    try out.print("\n## stdx's fast paths against its checked path, libzstd level {d}\n\n", .{decode_level});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |\n|---|---|---|---|---|---|\n", .{});
    for (rows) |row| try report_paths(arena, io, out, row);
    try out.print("\n## Decision 14's claims, each off against the fast paths with all on, libzstd level {d}\n\n", .{decode_level});
    try out.print("Each claim's column is its throughput with the claim off over the throughput with all on.\n\n", .{});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Compressed, % | All on, MB/s |", .{});
    for (zstd.claims.each_off_names) |name| try out.print(" {s} off |", .{name});
    try out.print("\n|---|---|---|---|", .{});
    for (zstd.claims.each_off_names) |_| try out.print("---|", .{});
    try out.print("\n", .{});
    for (rows) |row| try report_claims(arena, io, out, row);
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

/// The frames' size as a percentage of the row's octets: the compression the decoders decode at.
fn compressed_percent(coded: []const []const u8, input: Input) f64 {
    return inputs.compressed_percent(inputs.total_len(coded), input);
}

/// Times each candidate, every one already checked against `input`, and returns the median rates
/// and spreads.
fn time_candidates(comptime count: usize, io: std.Io, input: Input, candidates: *const [count]timing.Operation) [2][count]f64 {
    var runs: [count][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, candidates, &runs);
    return rates_of(count, &runs, input.len());
}

/// Prints one row of two candidates: the row's compression, their rates and spreads, and the
/// second's rate over the first's.
fn print_pair(out: *std.Io.Writer, input: Input, coded: []const []const u8, rates: [2][2]f64) !void {
    try out.print("| {s} | {d} | {d:.1} | {d:.1} ±{d:.1}% | {d:.1} ±{d:.1}% | {d:.2} |\n", .{
        input.name,  input.len(),               compressed_percent(coded, input), rates[0][0], rates[1][0], rates[0][1],
        rates[1][1], rates[0][1] / rates[0][0],
    });
}

fn report_decode(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, input: Input, context: *oracle.ZstdContext) !void {
    const coded = try inputs.streams(arena, input, Frames{});
    const libzstd: LibzstdDecode = .{ .output = try arena.alloc(u8, input.part_len), .context = context };
    // Every candidate decodes every part back before any is timed.
    const candidates = [_]timing.Operation{
        try inputs.decoder_operation(arena, libzstd, coded, input),
        try Fast.operation(arena, coded, input),
    };
    try print_pair(out, input, coded, time_candidates(candidates.len, io, input, &candidates));
}

fn report_paths(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, input: Input) !void {
    const coded = try inputs.streams(arena, input, Frames{});
    const candidates = [_]timing.Operation{
        try Checked.operation(arena, coded, input),
        try Fast.operation(arena, coded, input),
    };
    try print_pair(out, input, coded, time_candidates(candidates.len, io, input, &candidates));
}

fn report_claims(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, input: Input) !void {
    const coded = try inputs.streams(arena, input, Frames{});
    var candidates: [1 + zstd.claims.each_off.len]timing.Operation = undefined;
    candidates[0] = try Fast.operation(arena, coded, input);
    inline for (zstd.claims.each_off, 1..) |off, index| {
        candidates[index] = try StdxDecode(.{ .claims = off }).operation(arena, coded, input);
    }
    const rates = time_candidates(candidates.len, io, input, &candidates);
    try out.print("| {s} | {d} | {d:.1} | {d:.1} ±{d:.1}% |", .{ input.name, input.len(), compressed_percent(coded, input), rates[0][0], rates[1][0] });
    for (1..candidates.len) |index| try out.print(" {d:.2} ±{d:.1}% |", .{ rates[0][index] / rates[0][0], rates[1][index] });
    try out.print("\n", .{});
}
