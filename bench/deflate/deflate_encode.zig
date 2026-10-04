//! bench-deflate's encoding section: the gzip encoders of zlib, zlib-ng, libdeflate and stdx at
//! levels 1, 6 and 9, the levels decision 13 gives stdx's encoder (design §8 step 9).
//!
//! - Each operation encodes one whole member a part of the row's input from a fresh state, as a
//!   caller encoding one response does: the baselines allocate and free their state inside it, and
//!   stdx starts its state with `init`. A file taken whole is one part; a small HTTP body is the
//!   slices of its payload (decision 45, bench/timing/inputs.zig).
//! - Throughput counts input octets. The ratio is input octets over encoded octets, and decision
//!   14's E3 prices stdx's ratio against zlib's at the same level.
//! - Each library means its own search by a level, so a row compares what each calls level 1, 6 or
//!   9.
//! - Every candidate's member of every part decodes back to the part through zlib before any is
//!   timed.

const std = @import("std");
const oracle = @import("oracle");
const timing = @import("timing");
const codec = @import("codec");
const gzip = @import("gzip");
const baselines = @import("baselines");
const inputs = timing.inputs;
const Input = inputs.Input;

/// The levels every encoder is timed at.
const levels = [_]u4{ 1, 6, 9 };

/// The candidates, in the tables' order; stdx is last.
const candidate_names = [_][]const u8{ "zlib", "zlib-ng", "libdeflate", "stdx" };
const candidate_count = candidate_names.len;
const stdx_index = candidate_count - 1;

/// One row's input at one level: each candidate's median throughput, its spread in percent, and
/// its ratio.
const Row = struct {
    name: []const u8,
    input_len: usize,
    level: u4,
    rates: [candidate_count]f64,
    spreads: [candidate_count]f64,
    ratios: [candidate_count]f64,
};

/// An encode of one gzip member by zlib, the oracle, at one level.
const ZlibEncode = struct {
    output: []u8,
    level: c_int,

    pub fn run(self: *const ZlibEncode, input: []const u8) ?usize {
        const encoding: oracle.Encoding = .{ .container = .gzip, .level = self.level, .strategy = .default };
        const result = oracle.zlib_encode(encoding, input, self.output);
        return if (result.verdict == .ok) result.written else null;
    }
};

/// An encode of one gzip member by a baseline that is not an oracle, at one level.
const BaselineEncode = struct {
    output: []u8,
    level: c_int,
    encode_with: *const fn (c_int, []const u8, []u8) ?usize,

    pub fn run(self: *const BaselineEncode, input: []const u8) ?usize {
        return self.encode_with(self.level, input, self.output);
    }
};

/// An encode of one gzip member by stdx's encoder at `level`, in one call. The state is placed
/// once and reached through a pointer, and each encode starts it with `init`.
fn StdxEncode(comptime level: u4) type {
    return struct {
        const Self = @This();
        const Encoder = gzip.Encoder(.{ .level = level });

        output: []u8,
        encoder: *Encoder,
        features: codec.Features,

        pub fn run(self: *const Self, input: []const u8) ?usize {
            self.encoder.init(self.features);
            return self.encoder.encode_all(input, self.output) catch null;
        }
    };
}

/// Times every candidate over every row's input at every level, then prints the speed table and
/// the ratio table.
pub fn report(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, all: []const Input) !void {
    var rows: std.ArrayList(Row) = .empty;
    for (all) |input| {
        inline for (levels) |level| try rows.append(arena, try measure(level, arena, io, input));
    }
    try out.print("\n## Encoding speed, gzip\n\n", .{});
    try inputs.note(out, all);
    try print_header(out, "MB/s", "stdx / zlib");
    for (rows.items) |row| {
        try out.print("| {s} | {d} | {d} |", .{ row.name, row.input_len, row.level });
        for (row.rates, row.spreads) |rate, spread| try out.print(" {d:.1} ± {d:.1}% |", .{ rate, spread });
        try out.print(" {d:.2} |\n", .{row.rates[stdx_index] / row.rates[0]});
    }
    try out.print("\n## Encoding ratio, gzip\n\n", .{});
    try inputs.note(out, all);
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

/// One row: each candidate encodes every part of `input` and its members are decoded back, then
/// all are timed interleaved.
fn measure(comptime level: u4, arena: std.mem.Allocator, io: std.Io, input: Input) !Row {
    const Stdx = StdxEncode(level);
    const output_len = @max(oracle.zlib_bound(.gzip, input.part_len), baselines.libdeflate_gzip_bound(input.part_len), Stdx.Encoder.encoded_len_max(input.part_len));
    const zlib: ZlibEncode = .{ .output = try arena.alloc(u8, output_len), .level = level };
    const zlib_ng: BaselineEncode = .{ .output = try arena.alloc(u8, output_len), .level = level, .encode_with = baselines.zlib_ng_gzip_encode };
    const libdeflate: BaselineEncode = .{ .output = try arena.alloc(u8, output_len), .level = level, .encode_with = baselines.libdeflate_gzip_encode };
    const stdx: Stdx = .{ .output = try arena.alloc(u8, output_len), .encoder = try arena.create(Stdx.Encoder), .features = codec.Features.detect() };
    var row: Row = .{ .name = input.name, .input_len = input.len(), .level = level, .rates = undefined, .spreads = undefined, .ratios = undefined };
    var candidates: [candidate_count]timing.Operation = undefined;
    const decoded = try arena.alloc(u8, input.part_len);
    inline for (.{ zlib, zlib_ng, libdeflate, stdx }, 0..) |candidate, index| {
        const encoded_len = try encoded_len_of(candidate, input, decoded);
        row.ratios[index] = @as(f64, @floatFromInt(input.len())) / @as(f64, @floatFromInt(encoded_len));
        candidates[index] = try inputs.operation(arena, candidate, input.parts);
    }
    var runs: [candidate_count][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    for (runs, &row.rates, &row.spreads) |candidate_runs, *rate, *spread| {
        const summary = timing.summarize(candidate_runs);
        rate.* = timing.megabytes_per_second(input.len(), summary.median);
        spread.* = summary.spread * 100;
    }
    return row;
}

/// Requires `candidate`'s member of every part of `input` to decode through zlib to the part.
/// Returns the octets of the members together.
fn encoded_len_of(candidate: anytype, input: Input, decoded: []u8) !usize {
    var encoded_len: usize = 0;
    for (input.parts) |part| {
        const member_len = candidate.run(part) orelse return error.CandidateFailed;
        try expect_round_trip(candidate.output[0..member_len], part, decoded);
        encoded_len += member_len;
    }
    return encoded_len;
}

/// Requires `member` to decode through zlib to `input`.
fn expect_round_trip(member: []const u8, input: []const u8, decoded: []u8) !void {
    const result = oracle.zlib_decode(.gzip, member, decoded);
    if (result.verdict != .ok or result.written != input.len or result.consumed != member.len) return error.CandidatesDisagree;
    if (!std.mem.eql(u8, input, decoded)) return error.CandidatesDisagree;
}
