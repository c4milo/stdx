//! bench-deflate: DEFLATE throughput over the corpora of decision 15, measured the way decision 10
//! and decision 20 fix: every candidate in this one program, interleaved in the same run, five runs
//! each, the median and the spread reported, and the losses shown. The timing is
//! bench/timing/timing.zig's.
//!
//! - Decoding: zlib's and Wuffs's gzip decoders over each corpus file, encoded by zlib at level 6,
//!   its default and the level HTTP servers commonly use. Throughput counts decoded octets.
//! - Encoding: zlib's gzip encoder at levels 1, 6 and 9, the levels decision 13 gives stdx's
//!   encoder. Throughput counts input octets, and the ratio is input octets over encoded octets.
//!
//! stdx's decoder and encoder join the candidates in the steps that write them (design §8 steps 5,
//! 7 and 9), and zlib-ng and libdeflate at step 7.
//!
//! The candidates' C is built ReleaseFast. This program is built ReleaseSafe, stdx's production
//! mode, so stdx's candidates will be measured as callers run them (decision 17).
//!
//! Usage: `bench_deflate <name>=<path>...`. It prints Markdown tables to standard output.

const std = @import("std");
const oracle = @import("oracle");
const timing = @import("timing");

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

    try out.print("## Decoding, gzip at zlib level {d}\n\n", .{decode_level});
    try out.print("| File | Octets | zlib, MB/s | Wuffs, MB/s | Wuffs / zlib |\n|---|---|---|---|---|\n", .{});
    for (files.items) |file| try report_decode(arena, io, out, file);
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

fn report_decode(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, file: File) !void {
    const encoded = try arena.alloc(u8, oracle.zlib_bound(.gzip, file.input.len));
    const encoding: oracle.Encoding = .{ .container = .gzip, .level = decode_level, .strategy = .default };
    const stream = encoded[0..oracle.zlib_encode(encoding, file.input, encoded).written];
    const zlib_output = try arena.alloc(u8, file.input.len);
    const wuffs_output = try arena.alloc(u8, file.input.len);
    const zlib: Decode = .{ .stream = stream, .output = zlib_output, .decode = oracle.zlib_decode };
    const wuffs: Decode = .{ .stream = stream, .output = wuffs_output, .decode = oracle.wuffs_decode };
    var runs: [2][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &.{
        .{ .context = &zlib, .run_once = Decode.run_once },
        .{ .context = &wuffs, .run_once = Decode.run_once },
    }, &runs);
    const zlib_summary = timing.summarize(runs[0]);
    const wuffs_summary = timing.summarize(runs[1]);
    const zlib_rate = timing.megabytes_per_second(file.input.len, zlib_summary.median);
    const wuffs_rate = timing.megabytes_per_second(file.input.len, wuffs_summary.median);
    try out.print("| {s} | {d} | {d:.0} ± {d:.1}% | {d:.0} ± {d:.1}% | {d:.2} |\n", .{
        file.name,              file.input.len,
        zlib_rate,              zlib_summary.spread * 100,
        wuffs_rate,             wuffs_summary.spread * 100,
        wuffs_rate / zlib_rate,
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
