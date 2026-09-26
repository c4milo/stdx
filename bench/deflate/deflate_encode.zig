//! bench-deflate's encoding section: the gzip encoders of zlib, zlib-ng, libdeflate and stdx at
//! levels 1, 6 and 9, the levels decision 13 gives stdx's encoder (design §8 step 9).
//!
//! - Each operation encodes one whole member from a fresh state, as a caller encoding one response
//!   does: the baselines allocate and free their state inside it, and stdx starts its state with
//!   `init`.
//! - Throughput counts input octets. The ratio is input octets over encoded octets, and decision
//!   14's E3 prices stdx's ratio against zlib's at the same level.
//! - Each library means its own search by a level, so a row compares what each calls level 1, 6 or
//!   9.
//! - Every candidate's member decodes back to the input through zlib before any is timed.

const std = @import("std");
const oracle = @import("oracle");
const timing = @import("timing");
const codec = @import("codec");
const gzip = @import("gzip");
const baselines = @import("baselines");

/// The levels every encoder is timed at.
const levels = [_]u4{ 1, 6, 9 };

/// The candidates, in the tables' order; stdx is last.
const candidate_names = [_][]const u8{ "zlib", "zlib-ng", "libdeflate", "stdx" };
const candidate_count = candidate_names.len;
const stdx_index = candidate_count - 1;

/// One file at one level: each candidate's median throughput, its spread in percent, and its
/// ratio.
const Row = struct {
    name: []const u8,
    input_len: usize,
    level: u4,
    rates: [candidate_count]f64,
    spreads: [candidate_count]f64,
    ratios: [candidate_count]f64,
};

/// An encode by zlib, the oracle, at one level.
const ZlibEncode = struct {
    input: []const u8,
    output: []u8,
    level: c_int,

    fn encode(self: *const ZlibEncode) ?usize {
        const encoding: oracle.Encoding = .{ .container = .gzip, .level = self.level, .strategy = .default };
        const result = oracle.zlib_encode(encoding, self.input, self.output);
        return if (result.verdict == .ok) result.written else null;
    }

    fn run_once(context: *const anyopaque) void {
        const self: *const ZlibEncode = @ptrCast(@alignCast(context));
        std.debug.assert(self.encode() != null);
    }
};

/// An encode by a baseline that is not an oracle, at one level.
const BaselineEncode = struct {
    input: []const u8,
    output: []u8,
    level: c_int,
    encode_with: *const fn (c_int, []const u8, []u8) ?usize,

    fn encode(self: *const BaselineEncode) ?usize {
        return self.encode_with(self.level, self.input, self.output);
    }

    fn run_once(context: *const anyopaque) void {
        const self: *const BaselineEncode = @ptrCast(@alignCast(context));
        std.debug.assert(self.encode() != null);
    }
};

/// An encode by stdx's gzip encoder at `level`, in one call.
fn StdxEncode(comptime level: u4) type {
    return struct {
        const Self = @This();
        const Encoder = gzip.Encoder(.{ .level = level });

        input: []const u8,
        output: []u8,
        encoder: *Encoder,
        features: codec.Features,

        fn encode(self: *const Self) ?usize {
            self.encoder.init(self.features);
            return self.encoder.encode_all(self.input, self.output) catch null;
        }

        fn run_once(context: *const anyopaque) void {
            const self: *const Self = @ptrCast(@alignCast(context));
            std.debug.assert(self.encode() != null);
        }
    };
}

/// Times every candidate over every file at every level, then prints the speed table and the
/// ratio table.
pub fn report(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, files: anytype) !void {
    var rows: std.ArrayList(Row) = .empty;
    for (files) |file| {
        inline for (levels) |level| try rows.append(arena, try measure(level, arena, io, file.name, file.input));
    }
    try out.print("\n## Encoding speed, gzip\n\n", .{});
    try print_header(out, "MB/s", "stdx / zlib");
    for (rows.items) |row| {
        try out.print("| {s} | {d} | {d} |", .{ row.name, row.input_len, row.level });
        for (row.rates, row.spreads) |rate, spread| try out.print(" {d:.1} ± {d:.1}% |", .{ rate, spread });
        try out.print(" {d:.2} |\n", .{row.rates[stdx_index] / row.rates[0]});
    }
    try out.print("\n## Encoding ratio, gzip\n\n", .{});
    try print_header(out, "ratio", "stdx / zlib");
    for (rows.items) |row| {
        try out.print("| {s} | {d} | {d} |", .{ row.name, row.input_len, row.level });
        for (row.ratios) |ratio| try out.print(" {d:.3} |", .{ratio});
        try out.print(" {d:.3} |\n", .{row.ratios[stdx_index] / row.ratios[0]});
    }
}

fn print_header(out: *std.Io.Writer, unit: []const u8, last: []const u8) !void {
    try out.print("| File | Octets | Level |", .{});
    for (candidate_names) |name| try out.print(" {s}, {s} |", .{ name, unit });
    try out.print(" {s} |\n|---|---|---|", .{last});
    for (0..candidate_count + 1) |_| try out.print("---|", .{});
    try out.print("\n", .{});
}

/// One row: each candidate encodes `input` once and its member is decoded back, then all are
/// timed interleaved.
fn measure(comptime level: u4, arena: std.mem.Allocator, io: std.Io, name: []const u8, input: []const u8) !Row {
    const output_len = @max(oracle.zlib_bound(.gzip, input.len), baselines.libdeflate_gzip_bound(input.len), StdxEncode(level).Encoder.encoded_len_max(input.len));
    const zlib: ZlibEncode = .{ .input = input, .output = try arena.alloc(u8, output_len), .level = level };
    const zlib_ng: BaselineEncode = .{ .input = input, .output = try arena.alloc(u8, output_len), .level = level, .encode_with = baselines.zlib_ng_gzip_encode };
    const libdeflate: BaselineEncode = .{ .input = input, .output = try arena.alloc(u8, output_len), .level = level, .encode_with = baselines.libdeflate_gzip_encode };
    const stdx: StdxEncode(level) = .{
        .input = input,
        .output = try arena.alloc(u8, output_len),
        .encoder = try arena.create(StdxEncode(level).Encoder),
        .features = codec.Features.detect(),
    };
    const members = [candidate_count]?usize{ zlib.encode(), zlib_ng.encode(), libdeflate.encode(), stdx.encode() };
    const outputs = [candidate_count][]const u8{ zlib.output, zlib_ng.output, libdeflate.output, stdx.output };
    var row: Row = .{ .name = name, .input_len = input.len, .level = level, .rates = undefined, .spreads = undefined, .ratios = undefined };
    const decoded = try arena.alloc(u8, input.len);
    for (members, outputs, &row.ratios) |member_len, output, *ratio| {
        const len = member_len orelse return error.CandidateFailed;
        try expect_round_trip(output[0..len], input, decoded);
        ratio.* = @as(f64, @floatFromInt(input.len)) / @as(f64, @floatFromInt(len));
    }
    const candidates = [candidate_count]timing.Operation{
        .{ .context = &zlib, .run_once = ZlibEncode.run_once },
        .{ .context = &zlib_ng, .run_once = BaselineEncode.run_once },
        .{ .context = &libdeflate, .run_once = BaselineEncode.run_once },
        .{ .context = &stdx, .run_once = @TypeOf(stdx).run_once },
    };
    var runs: [candidate_count][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    for (runs, &row.rates, &row.spreads) |candidate_runs, *rate, *spread| {
        const summary = timing.summarize(candidate_runs);
        rate.* = timing.megabytes_per_second(input.len, summary.median);
        spread.* = summary.spread * 100;
    }
    return row;
}

/// Requires `member` to decode through zlib to `input`.
fn expect_round_trip(member: []const u8, input: []const u8, decoded: []u8) !void {
    const result = oracle.zlib_decode(.gzip, member, decoded);
    if (result.verdict != .ok or result.written != input.len or result.consumed != member.len) return error.CandidatesDisagree;
    if (!std.mem.eql(u8, input, decoded)) return error.CandidatesDisagree;
}
