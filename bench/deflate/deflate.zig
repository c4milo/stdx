//! bench-deflate: DEFLATE throughput over the corpora of decision 15, measured the way decision 10
//! and decision 20 fix: every candidate in this one program, interleaved in the same run, five runs
//! each, the median and the spread reported, and the losses shown. The timing is
//! bench/timing/timing.zig's.
//!
//! - The rows: one a corpus file, taken whole, but for the 1 KiB and 16 KiB HTTP bodies, which a
//!   row codes as the slices of their 1 MiB payload, one stream a slice, one after another
//!   (decision 45, bench/timing/inputs.zig).
//! - Decoding: the gzip decoders of zlib, zlib-ng, libdeflate, Wuffs and stdx over each row's
//!   streams, encoded by zlib at level 6, its default and the level HTTP servers commonly use.
//!   Throughput counts decoded octets. Each decoder's output is compared with the input before any
//!   is timed.
//! - stdx's paths: its raw DEFLATE decoder with the fast path of decision 16 and on its checked
//!   path alone, the A/B that admits the fast path, over the same streams without the container.
//!   The checked path's decoder takes claims no other candidate takes (`checked_claims`).
//! - Decision 14's claims: stdx's raw decoder with each claim off in turn against the decoder with
//!   all on (design §8 step 7), each claim's A/B, reported as the ratio of the two throughputs.
//!   S7's A/B also runs over streams zlib's fixed strategy encodes, since level 6 writes no fixed
//!   block for most of the corpus. S10's A/B decodes in calls of `split_output_len` octets: the gzip decoder, which checksums
//!   each call's output, against the raw decoder and one CRC-32 pass over the whole output after
//!   the last call.
//! - Decision 17's measurement: `bench_deflate_release_fast`, this program with stdx built
//!   ReleaseFast, prints the same A/B after it. The difference bounds what the safety checks
//!   cost; ReleaseFast is never offered to a caller.
//! - x86-64-v3: on an x86-64 host with its instructions, `bench_deflate_x86_64_v3`, this program
//!   with stdx built for x86-64-v3, prints the decoding table again after both: what a caller
//!   that builds for its servers' CPUs gets (decision 34).
//! - Encoding: the gzip encoders of zlib, zlib-ng, libdeflate and stdx at levels 1, 6 and 9, the
//!   levels decision 13 gives stdx's encoder: deflate_encode.zig.
//!
//! stdx's decoder is a candidate from design §8 step 6, its fast path from step 7, and its encoder
//! from step 9. stdx picks its checksum path from the CPU's features, as a caller does (decision
//! 21).
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
const deflate_encode = @import("deflate_encode.zig");
const inputs = timing.inputs;
const Input = inputs.Input;

/// The output each call of S10's A/B takes: a caller's buffer of a common size.
const split_output_len = 64 * 1024;

/// The zlib level whose streams the decoders are timed on.
const decode_level: c_int = 6;

/// zlib's encoder at `decode_level`, which writes one stream a part for the decoders
/// (`inputs.streams`).
const Streams = struct {
    container: oracle.Container,
    strategy: oracle.Strategy = .default,

    pub fn bound(self: Streams, part_len: usize) usize {
        return oracle.zlib_bound(self.container, part_len);
    }

    pub fn encode(self: Streams, part: []const u8, room: []u8) ?usize {
        const encoding: oracle.Encoding = .{ .container = self.container, .level = decode_level, .strategy = self.strategy };
        const result = oracle.zlib_encode(encoding, part, room);
        return if (result.verdict == .ok) result.written else null;
    }
};

/// A decode of one gzip stream by one oracle, into a buffer sized for a part.
const Decode = struct {
    output: []u8,
    decode: *const fn (oracle.Container, []const u8, []u8) oracle.Result,

    pub fn run(self: *const Decode, stream: []const u8) ?usize {
        const result = self.decode(.gzip, stream, self.output);
        return if (result.verdict == .ok) result.written else null;
    }
};

/// A decode of one gzip stream by a baseline that is not an oracle.
const BaselineDecode = struct {
    output: []u8,
    decode: *const fn ([]const u8, []u8) ?usize,

    pub fn run(self: *const BaselineDecode, stream: []const u8) ?usize {
        return self.decode(stream, self.output);
    }
};

/// A decode of one gzip stream by stdx's decoder, in one call.
const StdxDecode = struct {
    output: []u8,
    decoder: *gzip.Decoder,
    features: codec.Features,

    pub fn run(self: *const StdxDecode, stream: []const u8) ?usize {
        gzip.init(self.decoder, self.features);
        const progress = gzip.decode(self.decoder, stream, self.output) catch return null;
        return if (progress.status == .done) progress.written else null;
    }
};

/// A decode of one raw DEFLATE stream by stdx's decoder on the paths `options` names, in one call,
/// with the CPU's features, as the gzip decode takes them, so it runs the assembly of decision 29
/// wherever the CPU does.
fn RawDecode(comptime options: deflate.Options) type {
    return struct {
        const Self = @This();

        output: []u8,
        decoder: *deflate.Decoder,
        features: codec.Features,

        pub fn run(self: *const Self, stream: []const u8) ?usize {
            deflate.init(self.decoder, self.features);
            // Out of line, so every candidate's entry takes the same shape. LLVM inlines a function
            // by how many callers it has, and the gzip decoder and S10's decodes call all on's
            // entry through `deflate.decode`, so LLVM kept that one out of line and inlined each
            // other candidate's here.
            const progress = @call(.never_inline, deflate.decode_with, .{ options, self.decoder, stream, self.output }) catch return null;
            return if (progress.status == .done) progress.written else null;
        }
    };
}

/// The claims of the checked path's candidate. Those its path reads, window-once, the comptime fixed
/// tables and the tables' widths, stay as all on has them; word refill and chunk copies, which only
/// the fast path reads, are off, so no other candidate takes this value. With all on's claims, the
/// two decoders shared the checked path's functions over the claims, a block's header, a stored
/// block's copy and a dynamic block's code lengths, and LLVM kept them out of line in both, where
/// each claim candidate inlined its own.
const checked_claims: deflate.Claims = .{ .word_refill = false, .chunk_copies = false };

comptime {
    // The checked path's candidate must not share a claim candidate's codec (`checked_claims`).
    std.debug.assert(!std.meta.eql(checked_claims, deflate.Claims{}));
    for (deflate.claims.each_off) |off| std.debug.assert(!std.meta.eql(off, checked_claims));
}

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

    if (bench_options.release_fast) {
        try out.print("\n## stdx built ReleaseFast: its fast path against its checked path (decision 17)\n\n", .{});
        try inputs.note(out, rows);
        try out.print("| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |\n|---|---|---|---|---|---|\n", .{});
        for (rows) |row| try report_paths(arena, io, out, row);
        try out.flush();
        return;
    }
    if (bench_options.x86_64_v3) {
        try out.print("\n## Decoding, gzip at zlib level {d}, stdx built for x86-64-v3\n\n", .{decode_level});
        try report_decodes(arena, io, out, rows);
        try out.flush();
        return;
    }
    try out.print("## Decoding, gzip at zlib level {d}\n\n", .{decode_level});
    try report_decodes(arena, io, out, rows);
    try out.print("\n## stdx's fast path against its checked path, raw DEFLATE at zlib level {d}\n\n", .{decode_level});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |\n|---|---|---|---|---|---|\n", .{});
    for (rows) |row| try report_paths(arena, io, out, row);
    try out.print("\n## Decision 14's claims, each off against the fast path with all on, raw DEFLATE at zlib level {d}\n\n", .{decode_level});
    try out.print("Each claim's column is its throughput with the claim off over the throughput with all on.\n\n", .{});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Compressed, % | All on, MB/s |", .{});
    for (deflate.claims.each_off_names) |name| try out.print(" {s} off |", .{name});
    try out.print("\n|---|---|---|---|", .{});
    for (deflate.claims.each_off_names) |_| try out.print("---|", .{});
    try out.print("\n", .{});
    for (rows) |row| try report_claims(arena, io, out, row);
    try out.print("\n## S7 on fixed-code streams: zlib's fixed strategy at level {d}, raw DEFLATE\n\n", .{decode_level});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Compressed, % | All on, MB/s | S7 comptime fixed tables off, MB/s | Off / on |\n|---|---|---|---|---|---|\n", .{});
    for (rows) |row| try report_fixed_tables(arena, io, out, row);
    try out.print("\n## S10: the checksum over each call's output against one pass after the stream, calls of {d} octets\n\n", .{split_output_len});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Compressed, % | Per call, MB/s | After the stream, MB/s | After / per call |\n|---|---|---|---|---|---|\n", .{});
    for (rows) |row| try report_checksum_order(arena, io, out, row);
    try deflate_encode.report(arena, io, out, rows);
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

/// The decoding table: every gzip decoder over each row.
fn report_decodes(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, rows: []const Input) !void {
    try inputs.note(out, rows);
    try out.print("| File | Octets | Compressed, % | zlib, MB/s | zlib-ng, MB/s | libdeflate, MB/s | Wuffs, MB/s | stdx, MB/s | stdx / fastest |\n", .{});
    try out.print("|---|---|---|---|---|---|---|---|---|\n", .{});
    for (rows) |row| try report_decode(arena, io, out, row);
}

fn report_decode(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, input: Input) !void {
    const coded = try inputs.streams(arena, input, Streams{ .container = .gzip });
    const zlib: Decode = .{ .output = try arena.alloc(u8, input.part_len), .decode = oracle.zlib_decode };
    const zlib_ng: BaselineDecode = .{ .output = try arena.alloc(u8, input.part_len), .decode = baselines.zlib_ng_gzip_decode };
    const libdeflate: BaselineDecode = .{ .output = try arena.alloc(u8, input.part_len), .decode = baselines.libdeflate_gzip_decode };
    const wuffs: Decode = .{ .output = try arena.alloc(u8, input.part_len), .decode = oracle.wuffs_decode };
    const stdx: StdxDecode = .{ .output = try arena.alloc(u8, input.part_len), .decoder = try arena.create(gzip.Decoder), .features = codec.Features.detect() };
    // Every candidate decodes every part back before any is timed.
    var candidates: [5]timing.Operation = undefined;
    inline for (.{ zlib, zlib_ng, libdeflate, wuffs, stdx }, 0..) |candidate, index| {
        candidates[index] = try inputs.decoder_operation(arena, candidate, coded, input);
    }
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, input.len());
    const fastest_other = @max(@max(rates[0][0], rates[0][1]), @max(rates[0][2], rates[0][3]));
    try out.print("| {s} | {d} | {d:.1} |", .{ input.name, input.len(), compressed_percent(coded, input) });
    for (rates[0], rates[1]) |rate, spread| try out.print(" {d:.0} ± {d:.1}% |", .{ rate, spread });
    try out.print(" {d:.2} |\n", .{rates[0][4] / fastest_other});
}

fn report_paths(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, input: Input) !void {
    const coded = try inputs.streams(arena, input, Streams{ .container = .raw });
    const candidates = [_]timing.Operation{
        try raw_candidate(.{ .fast_paths = false, .claims = checked_claims }, arena, coded, input),
        try raw_candidate(.{}, arena, coded, input),
    };
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, input.len());
    try out.print("| {s} | {d} | {d:.1} | {d:.0} ± {d:.1}% | {d:.0} ± {d:.1}% | {d:.2} |\n", .{
        input.name,                input.len(), compressed_percent(coded, input), rates[0][0], rates[1][0], rates[0][1], rates[1][1],
        rates[0][1] / rates[0][0],
    });
}

/// The streams' size as a percentage of the row's octets: the compression the decoders decode at.
fn compressed_percent(coded: []const []const u8, input: Input) f64 {
    return inputs.compressed_percent(inputs.total_len(coded), input);
}

/// A raw decode on `options`'s paths, checked over `coded` against `input` and placed for timing.
fn raw_candidate(comptime options: deflate.Options, arena: std.mem.Allocator, coded: []const []const u8, input: Input) !timing.Operation {
    const candidate: RawDecode(options) = .{ .output = try arena.alloc(u8, input.part_len), .decoder = try arena.create(deflate.Decoder), .features = codec.Features.detect() };
    return inputs.decoder_operation(arena, candidate, coded, input);
}

fn report_claims(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, input: Input) !void {
    const coded = try inputs.streams(arena, input, Streams{ .container = .raw });
    const claims = deflate.claims.each_off;
    var candidates: [1 + claims.len]timing.Operation = undefined;
    candidates[0] = try raw_candidate(.{}, arena, coded, input);
    inline for (claims, 1..) |off, index| candidates[index] = try raw_candidate(.{ .claims = off }, arena, coded, input);
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, input.len());
    try out.print("| {s} | {d} | {d:.1} | {d:.0} ± {d:.1}% |", .{ input.name, input.len(), compressed_percent(coded, input), rates[0][0], rates[1][0] });
    for (rates[0][1..], rates[1][1..]) |rate, spread| try out.print(" {d:.2} ± {d:.1}% |", .{ rate / rates[0][0], spread });
    try out.print("\n", .{});
}

/// A decode in calls of `split_output_len` octets: gzip's, which checksums each call's output, or
/// the raw decoder's with one CRC-32 pass over the whole output after the last call.
const SplitDecode = struct {
    output: []u8,
    gzip_decoder: *gzip.Decoder,
    raw_decoder: *deflate.Decoder,
    features: codec.Features,
    checksum_after: bool,

    pub fn run(self: *const SplitDecode, stream: []const u8) ?usize {
        if (self.checksum_after) {
            deflate.init(self.raw_decoder, self.features);
            const written = split(deflate.Decoder, self.raw_decoder, deflate.decode, stream, self.output);
            const path = checksum.Crc32Path.fastest(checksum.Features.from(self.features));
            std.mem.doNotOptimizeAway(checksum.crc32(path, gzip.constants.crc32_initial, self.output[0..written]));
            return written;
        }
        gzip.init(self.gzip_decoder, self.features);
        return split(gzip.Decoder, self.gzip_decoder, gzip.decode, stream, self.output);
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

fn report_checksum_order(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, input: Input) !void {
    const gzip_coded = try inputs.streams(arena, input, Streams{ .container = .gzip });
    const raw_coded = try inputs.streams(arena, input, Streams{ .container = .raw });
    const per_call: SplitDecode = .{
        .output = try arena.alloc(u8, input.part_len),
        .gzip_decoder = try arena.create(gzip.Decoder),
        .raw_decoder = try arena.create(deflate.Decoder),
        .features = codec.Features.detect(),
        .checksum_after = false,
    };
    var after = per_call;
    after.output = try arena.alloc(u8, input.part_len);
    after.checksum_after = true;
    const candidates = [_]timing.Operation{
        try inputs.decoder_operation(arena, per_call, gzip_coded, input),
        try inputs.decoder_operation(arena, after, raw_coded, input),
    };
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, input.len());
    try out.print("| {s} | {d} | {d:.1} | {d:.0} ± {d:.1}% | {d:.0} ± {d:.1}% | {d:.2} |\n", .{
        input.name,                input.len(), compressed_percent(gzip_coded, input), rates[0][0], rates[1][0], rates[0][1], rates[1][1],
        rates[0][1] / rates[0][0],
    });
}

fn report_fixed_tables(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, input: Input) !void {
    const coded = try inputs.streams(arena, input, Streams{ .container = .raw, .strategy = .fixed });
    const candidates = [_]timing.Operation{
        try raw_candidate(.{}, arena, coded, input),
        try raw_candidate(.{ .claims = .{ .comptime_fixed_tables = false } }, arena, coded, input),
    };
    var runs: [candidates.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const rates = rates_of(candidates.len, &runs, input.len());
    try out.print("| {s} | {d} | {d:.1} | {d:.0} ± {d:.1}% | {d:.0} ± {d:.1}% | {d:.2} |\n", .{
        input.name,                input.len(), compressed_percent(coded, input), rates[0][0], rates[1][0], rates[0][1], rates[1][1],
        rates[0][1] / rates[0][0],
    });
}
