//! bench-brotli's encoding section: Google's encoder, measured before stdx's encoder exists (design
//! §8 step 14), so the step's record takes its targets from numbers. The owner ruled on 2026-11-05
//! that stdx's level 1 rivals quality 1 and level 5 quality 5, with decision 12's windows: WBITS 18
//! at level 1 and 22 at level 5. Quality 1 is also timed at Google's default WBITS 22.
//!
//! - Each operation encodes one whole stream of a part of the row's input. Google's encoder takes a
//!   new instance a stream, as its one-call API does. A file taken whole is one part; a small
//!   HTTP body is the slices of its payload (decision 45, bench/timing/inputs.zig).
//! - Throughput counts input octets. The ratio is input octets over encoded octets.
//! - Every stream of every part decodes back to the part through Google's decoder before any is
//!   timed.

const std = @import("std");
const oracle = @import("oracle");
const timing = @import("timing");
const inputs = timing.inputs;
const Input = inputs.Input;

/// The settings Google's encoder is timed at: a quality and its WBITS.
const Setting = struct { quality: c_int, window_bits: c_int };
const settings = [_]Setting{
    .{ .quality = 1, .window_bits = 18 },
    .{ .quality = 1, .window_bits = 22 },
    .{ .quality = 5, .window_bits = 22 },
};

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

/// Times Google's encoder over every row's input at every setting, then prints the table.
pub fn report(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, all: []const Input) !void {
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

/// One row: Google's encoder codes every part of `input`, its streams are decoded back, then it
/// is timed.
fn measure(setting: Setting, arena: std.mem.Allocator, io: std.Io, input: Input) !Row {
    const google: GoogleEncode = .{ .output = try arena.alloc(u8, oracle.brotli_bound(input.part_len)), .setting = setting };
    const decoded = try arena.alloc(u8, input.part_len);
    var encoded_len: usize = 0;
    for (input.parts) |part| {
        const stream_len = google.run(part) orelse return error.CandidateFailed;
        const verdict = oracle.brotli_decode_verdict(google.output[0..stream_len], decoded);
        if (verdict.verdict != .ok or verdict.written != part.len or !std.mem.eql(u8, part, decoded[0..verdict.written])) return error.CandidatesDisagree;
        encoded_len += stream_len;
    }
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
