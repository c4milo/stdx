//! bench-brotli: brotli decoding throughput over the corpora of decision 15, measured the way
//! decisions 10 and 20 fix: every candidate in this one program, interleaved in the same run, five
//! runs each, the median and the spread reported, and the losses shown. The timing is
//! bench/timing/timing.zig's.
//!
//! - Decoding: Google's brotli decoder, an instance created and freed for each stream as its
//!   one-shot decode does, since its public API resets none, and stdx's HTTP decoder, a window of
//!   2^24 (decision 12), over each corpus file encoded once by Google's brotli at its default
//!   quality and window. Throughput counts decoded octets. Each decoder's output is compared with
//!   the input before any is timed. Each row states the stream's size as a percentage of the
//!   file's, the ratio the decoders' speed is measured at.
//! - stdx's paths: its HTTP decoder with the fast path of decision 16 and on its checked path
//!   alone, the A/B that admits the fast path. The checked path's decoder takes claims no other
//!   candidate takes (`checked_claims`).
//! - The claims: stdx's decoder with each claim off in turn against the decoder with all on (design
//!   §8 step 12), each claim's A/B, reported as the ratio of the two throughputs.
//! - Decision 17's measurement: `bench_brotli_release_fast`, this program with stdx built
//!   ReleaseFast, prints the comparison with Google's brotli after it. The difference bounds what
//!   the safety checks cost; ReleaseFast is never offered to a caller.
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

/// Google's default quality and window, as its command-line tool takes them.
const decode_quality: c_int = 11;
const decode_window_bits: c_int = 22;

/// A decode of one stream by Google's brotli.
const GoogleDecode = struct {
    stream: []const u8,
    output: []u8,

    fn run_once(context: *const anyopaque) void {
        const self: *const GoogleDecode = @ptrCast(@alignCast(context));
        const result = oracle.brotli_decode_verdict(self.stream, self.output);
        std.debug.assert(result.verdict == .ok and result.written == self.output.len);
    }
};

/// A decode of one stream by a stdx decoder taking `paths`, started with `init` and taken in one
/// call.
fn StdxDecode(comptime paths: brotli.claims.Paths) type {
    return struct {
        const Self = @This();
        pub const Decoder = brotli.Decoder(.{ .paths = paths });

        stream: []const u8,
        output: []u8,
        decoder: *Decoder,

        fn run_once(context: *const anyopaque) void {
            const self: *const Self = @ptrCast(@alignCast(context));
            self.decoder.init(codec.Features.detect());
            const progress = self.decoder.decode(self.stream, self.output) catch unreachable;
            std.debug.assert(progress.status == .done and progress.written == self.output.len);
        }

        fn of(arena: std.mem.Allocator, stream: []const u8, len: usize) !Self {
            return .{ .stream = stream, .output = try arena.alloc(u8, len), .decoder = try arena.create(Decoder) };
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

/// A corpus file and Google's stream of it.
const File = struct {
    name: []const u8,
    input: []const u8,
    stream: []const u8,

    /// The stream's size as a percentage of the file's: the compression the decoders decode at.
    fn compressed_percent(self: File) f64 {
        return 100 * @as(f64, @floatFromInt(self.stream.len)) / @as(f64, @floatFromInt(self.input.len));
    }
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
        try files.append(arena, .{ .name = argument[0..split], .input = input, .stream = try stream_of(arena, input) });
    }
    const header = "| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |\n|---|---|---|---|---|---|\n";
    if (bench_options.release_fast) {
        try out.print("\n## stdx built ReleaseFast against Google's brotli, quality {d}, window {d} (decision 17)\n\n", .{ decode_quality, decode_window_bits });
        try out.print(header, .{});
        for (files.items) |file| try report_decode(arena, io, out, file);
        try out.flush();
        return;
    }
    try out.print("## Decoding, quality {d}, window {d}\n\n", .{ decode_quality, decode_window_bits });
    try out.print(header, .{});
    for (files.items) |file| try report_decode(arena, io, out, file);
    try out.print("\n## stdx's fast path against its checked path\n\n", .{});
    try out.print("| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |\n|---|---|---|---|---|---|\n", .{});
    for (files.items) |file| try report_paths(arena, io, out, file);
    try out.print("\n## The claims, each off against the fast path with all on\n\n", .{});
    try out.print("Each claim's column is its throughput with the claim off over the throughput with all on.\n\n", .{});
    try out.print("| File | Octets | Compressed, % | All on, MB/s |", .{});
    for (brotli.claims.each_off_names) |name| try out.print(" {s} off |", .{name});
    try out.print("\n|---|---|---|---|", .{});
    for (brotli.claims.each_off_names) |_| try out.print("---|", .{});
    try out.print("\n", .{});
    for (files.items) |file| try report_claims(arena, io, out, file);
    try out.flush();
}

/// Google's stream of `input` at `decode_quality` and `decode_window_bits`.
fn stream_of(arena: std.mem.Allocator, input: []const u8) ![]const u8 {
    const encoded = try arena.alloc(u8, oracle.brotli_bound(input.len));
    const stream_len = oracle.brotli_encode(.{ .quality = decode_quality, .window_bits = decode_window_bits }, input, encoded) orelse return error.EncodeFailed;
    return encoded[0..stream_len];
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

/// Times each candidate over `file`'s stream after checking it decodes the file, and returns the
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

/// Prints one row of two candidates: the file's compression, their rates and spreads, and the
/// second's rate over the first's.
fn print_pair(out: *std.Io.Writer, file: File, rates: [2][2]f64) !void {
    try out.print("| {s} | {d} | {d:.1} | {d:.1} ±{d:.1}% | {d:.1} ±{d:.1}% | {d:.2} |\n", .{
        file.name,   file.input.len,            file.compressed_percent(), rates[0][0], rates[1][0], rates[0][1],
        rates[1][1], rates[0][1] / rates[0][0],
    });
}

fn report_decode(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const google: GoogleDecode = .{ .stream = file.stream, .output = try arena.alloc(u8, file.input.len) };
    const stdx = try Fast.of(arena, file.stream, file.input.len);
    const candidates = [_]timing.Operation{
        .{ .context = &google, .run_once = GoogleDecode.run_once },
        .{ .context = &stdx, .run_once = Fast.run_once },
    };
    try print_pair(out, file, try time_candidates(candidates.len, io, file, &candidates, &.{ google.output, stdx.output }));
}

fn report_paths(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const checked = try Checked.of(arena, file.stream, file.input.len);
    const fast = try Fast.of(arena, file.stream, file.input.len);
    const candidates = [_]timing.Operation{
        .{ .context = &checked, .run_once = Checked.run_once },
        .{ .context = &fast, .run_once = Fast.run_once },
    };
    try print_pair(out, file, try time_candidates(candidates.len, io, file, &candidates, &.{ checked.output, fast.output }));
}

/// One decode per claim off, each of its own type.
const ClaimsOff = claims_off: {
    var types: [brotli.claims.each_off.len]type = undefined;
    for (brotli.claims.each_off, 0..) |off, index| types[index] = StdxDecode(.{ .claims = off });
    break :claims_off std.meta.Tuple(&types);
};

fn report_claims(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const all_on = try Fast.of(arena, file.stream, file.input.len);
    var candidates: [1 + brotli.claims.each_off.len]timing.Operation = undefined;
    var outputs: [candidates.len][]const u8 = undefined;
    candidates[0] = .{ .context = &all_on, .run_once = Fast.run_once };
    outputs[0] = all_on.output;
    var offs: ClaimsOff = undefined;
    inline for (brotli.claims.each_off, 0..) |off, index| {
        const Off = StdxDecode(.{ .claims = off });
        offs[index] = try Off.of(arena, file.stream, file.input.len);
        candidates[1 + index] = .{ .context = &offs[index], .run_once = Off.run_once };
        outputs[1 + index] = offs[index].output;
    }
    const rates = try time_candidates(candidates.len, io, file, &candidates, &outputs);
    try out.print("| {s} | {d} | {d:.1} | {d:.1} ±{d:.1}% |", .{ file.name, file.input.len, file.compressed_percent(), rates[0][0], rates[1][0] });
    for (1..candidates.len) |index| try out.print(" {d:.2} ±{d:.1}% |", .{ rates[0][index] / rates[0][0], rates[1][index] });
    try out.print("\n", .{});
}
