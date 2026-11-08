//! bench-profile's brotli encoding section: hardware counters for Google's brotli encoder at
//! quality 1 and stdx's at level 1, both at WBITS 18, and at quality 5 and level 5, both at WBITS
//! 22 (decision 62), per input octet. It shows where stdx's encoder spends its cycles against
//! Google's on each runner: in more instructions, or in fewer instructions a cycle, and how many
//! branches miss.
//!
//! Each encoder encodes one whole stream a part of the row's input, as bench-brotli times it
//! (`bench/brotli/brotli_encode.zig`): Google's one-call encoder, and stdx's state, started once
//! with `init` and begun for each stream with `start` (decision 60). It encodes until it has read
//! at least `encoded_input_len_min` octets. Before the counters, each stream of each part decodes
//! back to the part through Google's decoder.

const std = @import("std");
const oracle = @import("oracle");
const brotli = @import("brotli");
const timing = @import("timing");
const Counters = timing.counters.Counters;
const inputs = timing.inputs;
const Input = inputs.Input;

/// The input octets each encoder reads per row, at least, over as many encodes as that takes.
const encoded_input_len_min = 8 * 1024 * 1024;

/// The levels and the WBITS Google's quality takes beside each (decision 62).
const level1 = 1;
const level1_window_bits = 18;
const level5 = 5;
const level5_window_bits = 22;

/// Google's encoder at `quality`, one call a stream.
fn Google(comptime quality: u4, comptime window_bits: u5) type {
    return struct {
        output: []u8,

        pub fn run(self: *const @This(), input: []const u8) ?usize {
            return oracle.brotli_encode(.{ .quality = quality, .window_bits = window_bits }, input, self.output);
        }
    };
}

/// stdx's encoder at `level`, as a caller builds it. The state is placed once, started once with
/// `init`, and reached through a pointer; each encode begins its stream with `start`.
fn Stdx(comptime level: u4) type {
    return struct {
        const Encoder = brotli.Encoder(.{ .level = level });
        output: []u8,
        encoder: *Encoder,

        pub fn run(self: *const @This(), input: []const u8) ?usize {
            self.encoder.start();
            return self.encoder.encode_all(input, self.output) catch null;
        }
    };
}

/// Prints the table: each encoder over each row.
pub fn report(arena: std.mem.Allocator, out: *std.Io.Writer, counters: *const Counters, rows: []const Input) !void {
    try out.print("\n## Hardware counters per input octet, brotli encoders\n\n", .{});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |\n", .{});
    try out.print("|---|---|---|---|---|---|---|\n", .{});
    for (rows) |input| try report_row(arena, out, counters, input);
}

/// One row: each encoder's streams checked, then each counted.
fn report_row(arena: std.mem.Allocator, out: *std.Io.Writer, counters: *const Counters, input: Input) !void {
    const Stdx1 = Stdx(level1);
    const Stdx5 = Stdx(level5);
    const output_len = @max(oracle.brotli_bound(input.part_len), Stdx1.Encoder.encoded_len_max(input.part_len), Stdx5.Encoder.encoded_len_max(input.part_len));
    const google1: Google(level1, level1_window_bits) = .{ .output = try arena.alloc(u8, output_len) };
    const stdx1: Stdx1 = .{ .output = try arena.alloc(u8, output_len), .encoder = try arena.create(Stdx1.Encoder) };
    const google5: Google(level5, level5_window_bits) = .{ .output = try arena.alloc(u8, output_len) };
    const stdx5: Stdx5 = .{ .output = try arena.alloc(u8, output_len), .encoder = try arena.create(Stdx5.Encoder) };
    stdx1.encoder.init();
    stdx5.encoder.init();
    const decoded = try arena.alloc(u8, input.part_len);
    const rounds = @max(1, encoded_input_len_min / @max(1, input.len()));
    inline for (.{ google1, stdx1, google5, stdx5 }, .{ "Google q1", "stdx 1", "Google q5", "stdx 5" }) |candidate, name| {
        try expect_round_trips(candidate, input, decoded);
        counters.start();
        for (0..rounds) |_| {
            for (input.parts) |part| std.mem.doNotOptimizeAway(candidate.run(part));
        }
        const counts = counters.stop();
        const octets: f64 = @floatFromInt(rounds * input.len());
        const cycles: f64 = @floatFromInt(counts[timing.counters.cycles]);
        const instructions: f64 = @floatFromInt(counts[timing.counters.instructions]);
        const misses: f64 = @floatFromInt(counts[timing.counters.branch_misses]);
        try out.print("| {s} | {d} | {s} | {d:.2} | {d:.2} | {d:.2} | {d:.2} |\n", .{
            input.name,             input.len(),           name,
            cycles / octets,        instructions / octets, instructions / @max(1, cycles),
            misses / octets * 1024,
        });
    }
}

/// Requires `candidate`'s stream of every part of `input` to decode through Google's decoder to
/// the part.
fn expect_round_trips(candidate: anytype, input: Input, decoded: []u8) !void {
    for (input.parts) |part| {
        const stream_len = candidate.run(part) orelse return error.CandidateFailed;
        const verdict = oracle.brotli_decode_verdict(candidate.output[0..stream_len], decoded);
        if (verdict.verdict != .ok or verdict.written != part.len or !std.mem.eql(u8, part, decoded[0..verdict.written])) return error.CandidatesDisagree;
    }
}
