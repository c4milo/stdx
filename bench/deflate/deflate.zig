//! bench-deflate: DEFLATE throughput over the corpora of decision 15, measured the way decision 10
//! and decision 20 fix: every candidate in this one program, interleaved in the same run, five runs
//! each, the median and the spread reported, and the losses shown. The timing is
//! bench/timing/timing.zig's.
//!
//! - Decoding: the gzip decoders of zlib, zlib-ng, libdeflate, Wuffs and stdx over each corpus file,
//!   encoded by zlib at level 6, its default and the level HTTP servers commonly use. Throughput
//!   counts decoded octets. Each decoder's output is compared with the input before any is timed.
//! - stdx's paths: its raw DEFLATE decoder with the fast path of decision 16 and on its checked
//!   path alone, the A/B that admits the fast path, over the same streams without the container.
//! - Decision 14's claims: stdx's raw decoder with each claim off in turn against the decoder with
//!   all on (design §8 step 7), each claim's A/B, reported as the ratio of the two throughputs.
//!   S10's A/B decodes in calls of `split_output_len` octets: the gzip decoder, which checksums
//!   each call's output, against the raw decoder and one CRC-32 pass over the whole output after
//!   the last call.
//! - Decision 17's measurement: `bench_deflate_release_fast`, this program with stdx built
//!   ReleaseFast, prints the same A/B after it. The difference bounds what the safety checks
//!   cost; ReleaseFast is never offered to a caller.
//! - Encoding: zlib's gzip encoder at levels 1, 6 and 9, the levels decision 13 gives stdx's
//!   encoder. Throughput counts input octets, and the ratio is input octets over encoded octets.
//!
//! stdx's decoder is a candidate from design §8 step 6, and its fast path from step 7; its encoder
//! joins at step 9. stdx picks its checksum path from the CPU's features, as a caller does
//! (decision 21).
//!
//! The candidates' C is built ReleaseFast. This program is built ReleaseSafe, stdx's production
//! mode, so stdx's candidates will be measured as callers run them (decision 17).
//!
//! Usage: `bench_deflate <name>=<path>...`. It prints Markdown tables to standard output.

const std = @import("std");
const oracle = @import("oracle");
const timing = @import("timing");
const codec = @import("codec");
const deflate = @import("deflate");
const gzip = @import("gzip");
const baselines = @import("baselines");
const bench_options = @import("bench_options");
const checksum = @import("checksum");

/// The output each call of S10's A/B takes: a caller's buffer of a common size.
const split_output_len = 64 * 1024;

/// The zlib level whose streams the decoders are timed on.
const decode_level: c_int = 6;

/// The levels the encoder is timed at.
const encode_levels = [_]c_int{ 1, 6, 9 };

/// A decode of one gzip stream by one oracle, into a buffer sized for its output.
const Decode = struct {
    stream: []const u8,
    output: []u8,
    decode: *const fn (oracle.Container, []const u8, []u8) oracle.Result,

    fn run_once(context: *const anyopaque) void {
        const self: *const Decode = @ptrCast(@alignCast(context));
        const result = self.decode(.gzip, self.stream, self.output);
        std.debug.assert(result.verdict == .ok);
    }
};

/// A decode of one gzip stream by a baseline that is not an oracle.
const BaselineDecode = struct {
    stream: []const u8,
    output: []u8,
    decode: *const fn ([]const u8, []u8) ?usize,

    fn run_once(context: *const anyopaque) void {
        const self: *const BaselineDecode = @ptrCast(@alignCast(context));
        std.debug.assert(self.decode(self.stream, self.output) == self.output.len);
    }
};

/// A decode of one gzip stream by stdx's decoder, in one call.
const StdxDecode = struct {
    stream: []const u8,
    output: []u8,
    decoder: *gzip.Decoder,
    features: codec.Features,

    fn run_once(context: *const anyopaque) void {
        const self: *const StdxDecode = @ptrCast(@alignCast(context));
        gzip.init(self.decoder, self.features);
        const progress = gzip.decode(self.decoder, self.stream, self.output) catch unreachable;
        std.debug.assert(progress.status == .done and progress.written == self.output.len);
    }
};

/// A decode of one raw DEFLATE stream by stdx's decoder on the paths `options` names, in one call.
fn RawDecode(comptime options: deflate.Options) type {
    return struct {
        const Self = @This();

        stream: []const u8,
        output: []u8,
        decoder: *deflate.Decoder,

        fn run_once(context: *const anyopaque) void {
            const self: *const Self = @ptrCast(@alignCast(context));
            deflate.init(self.decoder, .{});
            const progress = deflate.decode_with(options, self.decoder, self.stream, self.output) catch unreachable;
            std.debug.assert(progress.status == .done and progress.written == self.output.len);
        }
    };
}

/// An encode of one input by zlib at one level.
const Encode = struct {
    input: []const u8,
    output: []u8,
    level: c_int,

    fn run_once(context: *const anyopaque) void {
        const self: *const Encode = @ptrCast(@alignCast(context));
        const encoding: oracle.Encoding = .{ .container = .gzip, .level = self.level, .strategy = .default };
        std.debug.assert(oracle.zlib_encode(encoding, self.input, self.output).verdict == .ok);
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
        try files.append(arena, .{ .name = argument[0..split], .input = input });
    }

    if (bench_options.release_fast) {
        try out.print("\n## stdx built ReleaseFast: its fast path against its checked path (decision 17)\n\n", .{});
        try out.print("| File | Octets | Checked, MB/s | Fast, MB/s | Fast / checked |\n|---|---|---|---|---|\n", .{});
        for (files.items) |file| try report_paths(arena, io, out, file);
        try out.flush();
        return;
    }
    try out.print("## Decoding, gzip at zlib level {d}\n\n", .{decode_level});
    try out.print("| File | Octets | zlib, MB/s | zlib-ng, MB/s | libdeflate, MB/s | Wuffs, MB/s | stdx, MB/s | stdx / fastest |\n", .{});
    try out.print("|---|---|---|---|---|---|---|---|\n", .{});
    for (files.items) |file| try report_decode(arena, io, out, file);
    try out.print("\n## stdx's fast path against its checked path, raw DEFLATE at zlib level {d}\n\n", .{decode_level});
    try out.print("| File | Octets | Checked, MB/s | Fast, MB/s | Fast / checked |\n|---|---|---|---|---|\n", .{});
    for (files.items) |file| try report_paths(arena, io, out, file);
    try out.print("\n## Decision 14's claims, each off against the fast path with all on, raw DEFLATE at zlib level {d}\n\n", .{decode_level});
    try out.print("Each claim's column is its throughput with the claim off over the throughput with all on.\n\n", .{});
    try out.print("| File | Octets | All on, MB/s |", .{});
    for (deflate.claims.each_off_names) |name| try out.print(" {s} off |", .{name});
    try out.print("\n|---|---|---|", .{});
    for (deflate.claims.each_off_names) |_| try out.print("---|", .{});
    try out.print("\n", .{});
    for (files.items) |file| try report_claims(arena, io, out, file);
    try out.print("\n## S10: the checksum over each call's output against one pass after the stream, calls of {d} octets\n\n", .{split_output_len});
    try out.print("| File | Octets | Per call, MB/s | After the stream, MB/s | After / per call |\n|---|---|---|---|---|\n", .{});
    for (files.items) |file| try report_checksum_order(arena, io, out, file);
    try out.print("\n## Encoding, gzip\n\n", .{});
    try out.print("| File | Octets | Level | zlib, MB/s | Ratio |\n|---|---|---|---|---|\n", .{});
    for (files.items) |file| {
        for (encode_levels) |level| try report_encode(arena, io, out, file, level);
    }
    try out.flush();
}

const File = struct {
    name: []const u8,
    input: []const u8,
};

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

fn report_decode(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const encoded = try arena.alloc(u8, oracle.zlib_bound(.gzip, file.input.len));
    const encoding: oracle.Encoding = .{ .container = .gzip, .level = decode_level, .strategy = .default };
    const stream = encoded[0..oracle.zlib_encode(encoding, file.input, encoded).written];
    const zlib: Decode = .{ .stream = stream, .output = try arena.alloc(u8, file.input.len), .decode = oracle.zlib_decode };
    const zlib_ng: BaselineDecode = .{ .stream = stream, .output = try arena.alloc(u8, file.input.len), .decode = baselines.zlib_ng_gzip_decode };
    const libdeflate: BaselineDecode = .{ .stream = stream, .output = try arena.alloc(u8, file.input.len), .decode = baselines.libdeflate_gzip_decode };
    const wuffs: Decode = .{ .stream = stream, .output = try arena.alloc(u8, file.input.len), .decode = oracle.wuffs_decode };
    const stdx: StdxDecode = .{
        .stream = stream,
        .output = try arena.alloc(u8, file.input.len),
        .decoder = try arena.create(gzip.Decoder),
        .features = codec.Features.detect(),
    };
    const candidates = [_]timing.Operation{
        .{ .context = &zlib, .run_once = Decode.run_once },
        .{ .context = &zlib_ng, .run_once = BaselineDecode.run_once },
        .{ .context = &libdeflate, .run_once = BaselineDecode.run_once },
        .{ .context = &wuffs, .run_once = Decode.run_once },
        .{ .context = &stdx, .run_once = StdxDecode.run_once },
    };
    // Every candidate decodes the input back before any is timed.
    for (candidates) |candidate| candidate.run_once(candidate.context);
    for ([_][]const u8{ zlib.output, zlib_ng.output, libdeflate.output, wuffs.output, stdx.output }) |output| {
        if (!std.mem.eql(u8, file.input, output)) return error.CandidatesDisagree;
    }
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, file.input.len);
    const fastest_other = @max(@max(rates[0][0], rates[0][1]), @max(rates[0][2], rates[0][3]));
    try out.print("| {s} | {d} |", .{ file.name, file.input.len });
    for (rates[0], rates[1]) |rate, spread| try out.print(" {d:.0} ± {d:.1}% |", .{ rate, spread });
    try out.print(" {d:.2} |\n", .{rates[0][4] / fastest_other});
}

fn report_paths(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const encoded = try arena.alloc(u8, oracle.zlib_bound(.raw, file.input.len));
    const encoding: oracle.Encoding = .{ .container = .raw, .level = decode_level, .strategy = .default };
    const stream = encoded[0..oracle.zlib_encode(encoding, file.input, encoded).written];
    const checked: RawDecode(.{ .fast_paths = false }) = .{
        .stream = stream,
        .output = try arena.alloc(u8, file.input.len),
        .decoder = try arena.create(deflate.Decoder),
    };
    const fast: RawDecode(.{}) = .{
        .stream = stream,
        .output = try arena.alloc(u8, file.input.len),
        .decoder = try arena.create(deflate.Decoder),
    };
    const candidates = [_]timing.Operation{
        .{ .context = &checked, .run_once = @TypeOf(checked).run_once },
        .{ .context = &fast, .run_once = @TypeOf(fast).run_once },
    };
    for (candidates) |candidate| candidate.run_once(candidate.context);
    if (!std.mem.eql(u8, file.input, checked.output) or !std.mem.eql(u8, file.input, fast.output)) return error.CandidatesDisagree;
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, file.input.len);
    try out.print("| {s} | {d} | {d:.0} ± {d:.1}% | {d:.0} ± {d:.1}% | {d:.2} |\n", .{
        file.name,                 file.input.len, rates[0][0], rates[1][0], rates[0][1], rates[1][1],
        rates[0][1] / rates[0][0],
    });
}

fn report_encode(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File, level: c_int) !void {
    const output = try arena.alloc(u8, oracle.zlib_bound(.gzip, file.input.len));
    const encode: Encode = .{ .input = file.input, .output = output, .level = level };
    var runs: [1][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &.{.{ .context = &encode, .run_once = Encode.run_once }}, &runs);
    const summary = timing.summarize(runs[0]);
    const encoding: oracle.Encoding = .{ .container = .gzip, .level = level, .strategy = .default };
    const encoded_len = oracle.zlib_encode(encoding, file.input, output).written;
    const ratio = @as(f64, @floatFromInt(file.input.len)) / @as(f64, @floatFromInt(encoded_len));
    try out.print("| {s} | {d} | {d} | {d:.1} ± {d:.1}% | {d:.3} |\n", .{
        file.name,                                                   file.input.len,       level,
        timing.megabytes_per_second(file.input.len, summary.median), summary.spread * 100, ratio,
    });
}

/// The raw DEFLATE stream zlib encodes from `input` at `decode_level`.
fn raw_stream(arena: std.mem.Allocator, input: []const u8) ![]const u8 {
    const encoded = try arena.alloc(u8, oracle.zlib_bound(.raw, input.len));
    const encoding: oracle.Encoding = .{ .container = .raw, .level = decode_level, .strategy = .default };
    return encoded[0..oracle.zlib_encode(encoding, input, encoded).written];
}

/// A raw decode on `options`'s paths, placed for timing.
fn raw_candidate(comptime options: deflate.Options, arena: std.mem.Allocator, stream: []const u8, len: usize) !struct { timing.Operation, []const u8 } {
    const Candidate = RawDecode(options);
    const candidate = try arena.create(Candidate);
    candidate.* = .{ .stream = stream, .output = try arena.alloc(u8, len), .decoder = try arena.create(deflate.Decoder) };
    return .{ .{ .context = candidate, .run_once = Candidate.run_once }, candidate.output };
}

fn report_claims(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const stream = try raw_stream(arena, file.input);
    const claims = deflate.claims.each_off;
    var candidates: [1 + claims.len]timing.Operation = undefined;
    var outputs: [1 + claims.len][]const u8 = undefined;
    candidates[0], outputs[0] = try raw_candidate(.{}, arena, stream, file.input.len);
    inline for (claims, 1..) |off, index| {
        candidates[index], outputs[index] = try raw_candidate(.{ .claims = off }, arena, stream, file.input.len);
    }
    for (candidates) |candidate| candidate.run_once(candidate.context);
    for (outputs) |output| {
        if (!std.mem.eql(u8, file.input, output)) return error.CandidatesDisagree;
    }
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, file.input.len);
    try out.print("| {s} | {d} | {d:.0} ± {d:.1}% |", .{ file.name, file.input.len, rates[0][0], rates[1][0] });
    for (rates[0][1..], rates[1][1..]) |rate, spread| try out.print(" {d:.2} ± {d:.1}% |", .{ rate / rates[0][0], spread });
    try out.print("\n", .{});
}

/// A decode in calls of `split_output_len` octets: gzip's, which checksums each call's output, or
/// the raw decoder's with one CRC-32 pass over the whole output after the last call.
const SplitDecode = struct {
    stream: []const u8,
    output: []u8,
    gzip_decoder: *gzip.Decoder,
    raw_decoder: *deflate.Decoder,
    features: codec.Features,
    checksum_after: bool,

    fn run_once(context: *const anyopaque) void {
        const self: *const SplitDecode = @ptrCast(@alignCast(context));
        if (self.checksum_after) {
            deflate.init(self.raw_decoder, .{});
            const written = split(deflate.Decoder, self.raw_decoder, deflate.decode, self.stream, self.output);
            const path = checksum.Crc32Path.fastest(checksum.Features.from(self.features));
            std.mem.doNotOptimizeAway(checksum.crc32(path, gzip.constants.crc32_initial, self.output[0..written]));
        } else {
            gzip.init(self.gzip_decoder, self.features);
            _ = split(gzip.Decoder, self.gzip_decoder, gzip.decode, self.stream, self.output);
        }
    }

    /// Decodes the whole stream into `output`, `split_output_len` octets of room a call. Returns the
    /// octets written.
    fn split(comptime Decoder: type, decoder: *Decoder, decode: anytype, stream: []const u8, output: []u8) usize {
        var consumed: usize = 0;
        var written: usize = 0;
        for (0..output.len / split_output_len + 2) |_| {
            const room = output[written..@min(output.len, written + split_output_len)];
            const progress = decode(decoder, stream[consumed..], room) catch unreachable;
            consumed += progress.consumed;
            written += progress.written;
            if (progress.status == .done) return written;
        }
        unreachable;
    }
};

fn report_checksum_order(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const encoded = try arena.alloc(u8, oracle.zlib_bound(.gzip, file.input.len));
    const encoding: oracle.Encoding = .{ .container = .gzip, .level = decode_level, .strategy = .default };
    const gzip_stream = encoded[0..oracle.zlib_encode(encoding, file.input, encoded).written];
    const per_call: SplitDecode = .{
        .stream = gzip_stream,
        .output = try arena.alloc(u8, file.input.len),
        .gzip_decoder = try arena.create(gzip.Decoder),
        .raw_decoder = try arena.create(deflate.Decoder),
        .features = codec.Features.detect(),
        .checksum_after = false,
    };
    const after: SplitDecode = .{
        .stream = try raw_stream(arena, file.input),
        .output = try arena.alloc(u8, file.input.len),
        .gzip_decoder = per_call.gzip_decoder,
        .raw_decoder = per_call.raw_decoder,
        .features = per_call.features,
        .checksum_after = true,
    };
    const candidates = [_]timing.Operation{
        .{ .context = &per_call, .run_once = SplitDecode.run_once },
        .{ .context = &after, .run_once = SplitDecode.run_once },
    };
    for (candidates) |candidate| candidate.run_once(candidate.context);
    if (!std.mem.eql(u8, file.input, per_call.output) or !std.mem.eql(u8, file.input, after.output)) return error.CandidatesDisagree;
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, file.input.len);
    try out.print("| {s} | {d} | {d:.0} ± {d:.1}% | {d:.0} ± {d:.1}% | {d:.2} |\n", .{
        file.name,                 file.input.len, rates[0][0], rates[1][0], rates[0][1], rates[1][1],
        rates[0][1] / rates[0][0],
    });
}
