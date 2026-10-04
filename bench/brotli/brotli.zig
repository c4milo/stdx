//! bench-brotli: brotli decoding throughput over the corpora of decision 15, measured the way
//! decisions 10 and 20 fix: every candidate in this one program, interleaved in the same run, five
//! runs each, the median and the spread reported, and the losses shown. The timing is
//! bench/timing/timing.zig's.
//!
//! - The rows: one a corpus file, taken whole, but for the 1 KiB and 16 KiB HTTP bodies, which a
//!   row codes as the slices of their 1 MiB payload, one stream a slice, one after another
//!   (decision 45, bench/timing/inputs.zig).
//! - Decoding: Google's brotli decoder, an instance created and freed for each stream as its
//!   one-shot decode does, since its public API resets none, and stdx's HTTP decoder, a window of
//!   2^24 (decision 12), over each row's streams, encoded once by Google's brotli at its default
//!   quality and window. Throughput counts decoded octets. Each decoder's output is compared with
//!   the input before any is timed. Each row states its streams' size as a percentage of its
//!   octets, the ratio the decoders' speed is measured at.
//! - stdx's paths: its HTTP decoder with the fast path of decision 16 and on its checked path
//!   alone, the A/B that admits the fast path. The checked path's decoder takes claims no other
//!   candidate takes (`checked_claims`).
//! - The claims: stdx's decoder with each claim off in turn against the decoder with all on (design
//!   §8 step 12), each claim's A/B, reported as the ratio of the two throughputs.
//! - Decision 17's measurement: `bench_brotli_release_fast`, this program with stdx built
//!   ReleaseFast, prints the comparison with Google's brotli after it. The difference bounds what
//!   the safety checks cost; ReleaseFast is never offered to a caller.
//!
//! stdx's decoder picks its loop from the CPU's features, detected once when a candidate is set up,
//! as a caller does (decision 21): each detection's CPUID instructions leave a virtual machine for
//! its hypervisor.
//!
//! Google's C is built ReleaseFast. This program is built ReleaseSafe, stdx's production mode, so
//! stdx is measured as callers run it (decision 17).
//!
//! Usage: `bench_brotli <name>=<path>...`. It prints Markdown tables to standard output.

const std = @import("std");
const oracle = @import("oracle");
const timing = @import("timing");
const codec = @import("codec");
const brotli = @import("brotli");
const bench_options = @import("bench_options");
const inputs = timing.inputs;
const Input = inputs.Input;

/// Google's default quality and window, as its command-line tool takes them.
const decode_quality: c_int = 11;
const decode_window_bits: c_int = 22;

/// Google's encoder at `decode_quality` and `decode_window_bits`, which writes one stream a part
/// for the decoders (`inputs.streams`).
const Streams = struct {
    pub fn bound(_: Streams, part_len: usize) usize {
        return oracle.brotli_bound(part_len);
    }

    pub fn encode(_: Streams, part: []const u8, room: []u8) ?usize {
        return oracle.brotli_encode(.{ .quality = decode_quality, .window_bits = decode_window_bits }, part, room);
    }
};

/// A decode of one stream by Google's brotli.
const GoogleDecode = struct {
    output: []u8,

    pub fn run(self: *const GoogleDecode, stream: []const u8) ?usize {
        const result = oracle.brotli_decode_verdict(stream, self.output);
        return if (result.verdict == .ok) result.written else null;
    }
};

/// A decode of one stream by a stdx decoder taking `paths`, started with `init` and taken in one
/// call.
fn StdxDecode(comptime paths: brotli.claims.Paths) type {
    return struct {
        const Self = @This();
        pub const Decoder = brotli.Decoder(.{ .paths = paths });

        output: []u8,
        decoder: *Decoder,
        features: codec.Features,

        pub fn run(self: *const Self, stream: []const u8) ?usize {
            self.decoder.init(self.features);
            const progress = self.decoder.decode(stream, self.output) catch return null;
            return if (progress.status == .done) progress.written else null;
        }

        /// The decoder checked over `row`'s streams against its input, and placed for timing.
        fn operation(arena: std.mem.Allocator, row: Row) !timing.Operation {
            const candidate: Self = .{ .output = try arena.alloc(u8, row.input.part_len), .decoder = try arena.create(Decoder), .features = codec.Features.detect() };
            return inputs.decoder_operation(arena, candidate, row.coded, row.input);
        }
    };
}

/// The claims of the checked path's candidate. Window-once, the one claim its path reads, stays on,
/// as all on has it; word refill and chunk copies, which only the fast path reads, are off, so no
/// other candidate takes this value. LLVM inlines a function by how many callers it has, and with
/// all on's claims the two decoders shared the checked path's functions over their `Output`: in
/// both, LLVM kept a call for each literal and each octet of a copy the checked path writes, where
/// each claim candidate inlined its own.
const checked_claims: brotli.claims.Claims = .{ .word_refill = false, .chunk_copies = false };

comptime {
    // The checked path's candidate must not share a claim candidate's codec (`checked_claims`).
    std.debug.assert(!std.meta.eql(checked_claims, brotli.claims.Claims{}));
    for (brotli.claims.each_off) |off| std.debug.assert(!std.meta.eql(off, checked_claims));
}

const Fast = StdxDecode(.{});
const Checked = StdxDecode(.{ .fast_paths = false, .claims = checked_claims });

/// A row's input and Google's stream of each of its parts.
const Row = struct {
    input: Input,
    coded: []const []const u8,

    /// The streams' size as a percentage of the row's octets: the compression the decoders decode
    /// at.
    fn compressed_percent(self: Row) f64 {
        return inputs.compressed_percent(inputs.total_len(self.coded), self.input);
    }
};

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
    const all = try inputs.of(arena, files.items);
    // Google's encoder runs once a part, before any table: quality 11 is slow.
    const rows = try arena.alloc(Row, all.len);
    for (all, rows) |input, *row| row.* = .{ .input = input, .coded = try inputs.streams(arena, input, Streams{}) };
    const header = "| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |\n|---|---|---|---|---|---|\n";
    if (bench_options.release_fast) {
        try out.print("\n## stdx built ReleaseFast against Google's brotli, quality {d}, window {d} (decision 17)\n\n", .{ decode_quality, decode_window_bits });
        try inputs.note(out, all);
        try out.print(header, .{});
        for (rows) |row| try report_decode(arena, io, out, row);
        try out.flush();
        return;
    }
    try out.print("## Decoding, quality {d}, window {d}\n\n", .{ decode_quality, decode_window_bits });
    try inputs.note(out, all);
    try out.print(header, .{});
    for (rows) |row| try report_decode(arena, io, out, row);
    try out.print("\n## stdx's fast path against its checked path\n\n", .{});
    try inputs.note(out, all);
    try out.print("| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |\n|---|---|---|---|---|---|\n", .{});
    for (rows) |row| try report_paths(arena, io, out, row);
    try out.print("\n## The claims, each off against the fast path with all on\n\n", .{});
    try out.print("Each claim's column is its throughput with the claim off over the throughput with all on.\n\n", .{});
    try inputs.note(out, all);
    try out.print("| File | Octets | Compressed, % | All on, MB/s |", .{});
    for (brotli.claims.each_off_names) |name| try out.print(" {s} off |", .{name});
    try out.print("\n|---|---|---|---|", .{});
    for (brotli.claims.each_off_names) |_| try out.print("---|", .{});
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

/// Times each candidate, every one already checked against `row`'s input, and returns the median
/// rates and spreads.
fn time_candidates(comptime count: usize, io: std.Io, row: Row, candidates: *const [count]timing.Operation) [2][count]f64 {
    var runs: [count][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, candidates, &runs);
    return rates_of(count, &runs, row.input.len());
}

/// Prints one row of two candidates: the row's compression, their rates and spreads, and the
/// second's rate over the first's.
fn print_pair(out: *std.Io.Writer, row: Row, rates: [2][2]f64) !void {
    try out.print("| {s} | {d} | {d:.1} | {d:.1} ±{d:.1}% | {d:.1} ±{d:.1}% | {d:.2} |\n", .{
        row.input.name, row.input.len(),           row.compressed_percent(), rates[0][0], rates[1][0], rates[0][1],
        rates[1][1],    rates[0][1] / rates[0][0],
    });
}

fn report_decode(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, row: Row) !void {
    const google: GoogleDecode = .{ .output = try arena.alloc(u8, row.input.part_len) };
    // Every candidate decodes every part back before any is timed.
    const candidates = [_]timing.Operation{
        try inputs.decoder_operation(arena, google, row.coded, row.input),
        try Fast.operation(arena, row),
    };
    try print_pair(out, row, time_candidates(candidates.len, io, row, &candidates));
}

fn report_paths(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, row: Row) !void {
    const candidates = [_]timing.Operation{
        try Checked.operation(arena, row),
        try Fast.operation(arena, row),
    };
    try print_pair(out, row, time_candidates(candidates.len, io, row, &candidates));
}

fn report_claims(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, row: Row) !void {
    var candidates: [1 + brotli.claims.each_off.len]timing.Operation = undefined;
    candidates[0] = try Fast.operation(arena, row);
    inline for (brotli.claims.each_off, 1..) |off, index| {
        candidates[index] = try StdxDecode(.{ .claims = off }).operation(arena, row);
    }
    const rates = time_candidates(candidates.len, io, row, &candidates);
    try out.print("| {s} | {d} | {d:.1} | {d:.1} ±{d:.1}% |", .{ row.input.name, row.input.len(), row.compressed_percent(), rates[0][0], rates[1][0] });
    for (1..candidates.len) |index| try out.print(" {d:.2} ±{d:.1}% |", .{ rates[0][index] / rates[0][0], rates[1][index] });
    try out.print("\n", .{});
}
