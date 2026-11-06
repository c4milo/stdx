//! bench-brotli's encoding section (design §8 step 14). The owner ruled on 2026-11-05 that stdx's
//! level 1 rivals Google's quality 1 and level 5 its quality 5, with decision 12's windows: WBITS
//! 18 at level 1 and 22 at level 5 (decision 62).
//!
//! - The first tables time stdx's level 1 and Google's quality 1 at WBITS 18, interleaved, and
//!   stdx's level 1 with its hot loops checked, decision 16's price of the checks. The last times
//!   Google alone: quality 1 at its default WBITS 22, and quality 5.
//! - Each operation encodes one whole stream of a part of the row's input. Google's encoder takes a
//!   new instance a stream, as its one-call API does. stdx's state is placed once, started once
//!   with `init`, and begun for each stream with `start` (decision 60), as a server keeps one per
//!   connection. A file taken whole is one part; a small HTTP body is the slices of its payload
//!   (decision 45, bench/timing/inputs.zig).
//! - Throughput counts input octets. The ratio is input octets over encoded octets.
//! - Every stream of every part decodes back to the part through Google's decoder before any is
//!   timed.

const std = @import("std");
const oracle = @import("oracle");
const timing = @import("timing");
const brotli = @import("brotli");
const inputs = timing.inputs;
const Input = inputs.Input;

/// The settings Google's encoder is timed at: a quality and its WBITS.
const Setting = struct { quality: c_int, window_bits: c_int };
const settings = [_]Setting{
    .{ .quality = 1, .window_bits = 22 },
    .{ .quality = 5, .window_bits = 22 },
};

/// The setting stdx's level 1 is timed against.
const level1_rival: Setting = .{ .quality = 1, .window_bits = 18 };

const candidate_names = [_][]const u8{ "Google q1", "stdx 1", "stdx 1 checked" };
const candidate_count = candidate_names.len;
/// The default encoder's column, which the bar reads.
const stdx_index = 1;

/// One row's input with both candidates: each one's median throughput, its spread in percent, and
/// its ratio.
const PairRow = struct {
    name: []const u8,
    input_len: usize,
    rates: [candidate_count]f64,
    spreads: [candidate_count]f64,
    ratios: [candidate_count]f64,
};

/// An encode of one stream by stdx's level 1, in one call, through a state kept across streams;
/// with `unchecked`, the hot loops run without Zig's checks, as decision 16 rules by default.
fn StdxEncode(comptime unchecked: bool) type {
    return struct {
        const Self = @This();
        const Encoder = brotli.Encoder(.{ .level = 1, .unchecked_loops = unchecked });

        output: []u8,
        encoder: *Encoder,

        pub fn run(self: *const Self, input: []const u8) ?usize {
            self.encoder.start();
            return self.encoder.encode_all(input, self.output) catch null;
        }
    };
}

/// One row's input at one setting: the median throughput, its spread in percent, and the ratio.
const Row = struct {
    name: []const u8,
    input_len: usize,
    setting: Setting,
    rate: f64,
    spread: f64,
    ratio: f64,
};

/// An encode of one stream by Google's encoder at one setting.
const GoogleEncode = struct {
    output: []u8,
    setting: Setting,

    pub fn run(self: *const GoogleEncode, input: []const u8) ?usize {
        return oracle.brotli_encode(.{ .quality = self.setting.quality, .window_bits = self.setting.window_bits }, input, self.output);
    }
};

/// Times stdx's level 1 against Google's quality 1 over every row's input, then Google alone at
/// every other setting, then prints the tables.
pub fn report(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, all: []const Input) !void {
    var pairs: std.ArrayList(PairRow) = .empty;
    for (all) |input| try pairs.append(arena, try measure_pair(arena, io, input));
    try print_pairs(out, all, pairs.items);
    var rows: std.ArrayList(Row) = .empty;
    for (all) |input| {
        for (settings) |setting| try rows.append(arena, try measure(setting, arena, io, input));
    }
    try out.print("\n## Encoding, Google's brotli\n\n", .{});
    try inputs.note(out, all);
    try out.print("| File | Octets | Quality | WBITS | Google, MB/s | Ratio |\n|---|---|---|---|---|---|\n", .{});
    for (rows.items) |row| {
        try out.print("| {s} | {d} | {d} | {d} | {d:.1} ± {d:.1}% | {d:.3} |\n", .{ row.name, row.input_len, row.setting.quality, row.setting.window_bits, row.rate, row.spread, row.ratio });
    }
}

/// The speed table and the ratio table of stdx's level 1 against Google's quality 1.
fn print_pairs(out: *std.Io.Writer, all: []const Input, pairs: []const PairRow) !void {
    try out.print("\n## Encoding speed, level 1 at WBITS 18\n\n", .{});
    try inputs.note(out, all);
    try print_header(out, "MB/s");
    for (pairs) |row| {
        try out.print("| {s} | {d} |", .{ row.name, row.input_len });
        for (row.rates, row.spreads) |rate, spread| try out.print(" {d:.1} ± {d:.1}% |", .{ rate, spread });
        try out.print(" {d:.2} |\n", .{row.rates[stdx_index] / row.rates[0]});
    }
    try out.print("\n## Encoding ratio, level 1 at WBITS 18\n\n", .{});
    try inputs.note(out, all);
    try print_header(out, "ratio");
    for (pairs) |row| {
        try out.print("| {s} | {d} |", .{ row.name, row.input_len });
        for (row.ratios) |ratio| try out.print(" {d:.3} |", .{ratio});
        try out.print(" {d:.3} |\n", .{row.ratios[stdx_index] / row.ratios[0]});
    }
}

/// A table's header: each candidate's column in `unit`, then stdx over Google.
fn print_header(out: *std.Io.Writer, unit: []const u8) !void {
    try out.print("| File | Octets |", .{});
    for (candidate_names) |name| try out.print(" {s}, {s} |", .{ name, unit });
    try out.print(" stdx / Google |\n|---|---|", .{});
    for (0..candidate_count + 1) |_| try out.print("---|", .{});
    try out.print("\n", .{});
}

/// One row of the pair: each candidate encodes every part of `input` and its streams are decoded
/// back, then both are timed interleaved.
fn measure_pair(arena: std.mem.Allocator, io: std.Io, input: Input) !PairRow {
    const Checked = StdxEncode(false);
    const Unchecked = StdxEncode(true);
    const output_len = @max(oracle.brotli_bound(input.part_len), Unchecked.Encoder.encoded_len_max(input.part_len));
    const google: GoogleEncode = .{ .output = try arena.alloc(u8, output_len), .setting = level1_rival };
    const stdx: Unchecked = .{ .output = try arena.alloc(u8, output_len), .encoder = try arena.create(Unchecked.Encoder) };
    stdx.encoder.init();
    const checked: Checked = .{ .output = try arena.alloc(u8, output_len), .encoder = try arena.create(Checked.Encoder) };
    checked.encoder.init();
    var row: PairRow = .{ .name = input.name, .input_len = input.len(), .rates = undefined, .spreads = undefined, .ratios = undefined };
    var candidates: [candidate_count]timing.Operation = undefined;
    const decoded = try arena.alloc(u8, input.part_len);
    inline for (.{ google, stdx, checked }, 0..) |candidate, index| {
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

/// Requires `candidate`'s stream of every part of `input` to decode through Google's decoder to the
/// part. Returns the octets of the streams together.
fn encoded_len_of(candidate: anytype, input: Input, decoded: []u8) !usize {
    var encoded_len: usize = 0;
    for (input.parts) |part| {
        const stream_len = candidate.run(part) orelse return error.CandidateFailed;
        const verdict = oracle.brotli_decode_verdict(candidate.output[0..stream_len], decoded);
        if (verdict.verdict != .ok or verdict.written != part.len or !std.mem.eql(u8, part, decoded[0..verdict.written])) return error.CandidatesDisagree;
        encoded_len += stream_len;
    }
    return encoded_len;
}

/// One row: Google's encoder codes every part of `input`, its streams are decoded back, then it
/// is timed.
fn measure(setting: Setting, arena: std.mem.Allocator, io: std.Io, input: Input) !Row {
    const google: GoogleEncode = .{ .output = try arena.alloc(u8, oracle.brotli_bound(input.part_len)), .setting = setting };
    const decoded = try arena.alloc(u8, input.part_len);
    const encoded_len = try encoded_len_of(google, input, decoded);
    var candidates = [_]timing.Operation{try inputs.operation(arena, google, input.parts)};
    var runs: [1][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &candidates, &runs);
    const summary = timing.summarize(runs[0]);
    return .{
        .name = input.name,
        .input_len = input.len(),
        .setting = setting,
        .rate = timing.megabytes_per_second(input.len(), summary.median),
        .spread = summary.spread * 100,
        .ratio = @as(f64, @floatFromInt(input.len())) / @as(f64, @floatFromInt(encoded_len)),
    };
}
