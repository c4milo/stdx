//! bench-profile's Zstandard encoding section: hardware counters for libzstd's and stdx's
//! Zstandard encoders at levels 1 and 3, the levels decision 13 gives stdx's encoder, per input
//! octet. It shows where stdx's encoder spends its cycles against libzstd's on each runner: in
//! more instructions, or in fewer instructions a cycle, and how many branches miss.
//!
//! Each encoder encodes one whole frame a part of the row's input with a state kept across frames,
//! as bench-zstd times it (`bench/zstd/zstd_encode.zig`): libzstd's context, set once to the level,
//! and stdx's state, started once with `init` and begun for each frame with `start` (decision 60).
//! It encodes until it has read at least `encoded_input_len_min` octets. Before the counters, each
//! frame of each part decodes back to the part through libzstd.

const std = @import("std");
const oracle = @import("oracle");
const codec = @import("codec");
const zstd = @import("zstd");
const timing = @import("timing");
const Counters = timing.counters.Counters;
const inputs = timing.inputs;
const Input = inputs.Input;

/// The levels every encoder is counted at.
const levels = [_]u4{ 1, 3 };

/// The input octets each encoder reads per row and level, at least, over as many encodes as that
/// takes.
const encoded_input_len_min = 8 * 1024 * 1024;

/// libzstd's encoder at one level, with no checksum, through a context kept across frames.
const Libzstd = struct {
    output: []u8,
    context: *oracle.zstd_encoder.Context,

    pub fn run(self: *const Libzstd, input: []const u8) ?usize {
        return oracle.zstd_encoder.encode(self.context, input, self.output);
    }
};

/// stdx's encoder at `level`, with its runtime safety checks, as a caller builds it. The state is
/// placed once, started once with `init`, and reached through a pointer; each encode begins its
/// frame with `start`.
fn Stdx(comptime level: u4) type {
    return struct {
        const Self = @This();
        const Encoder = zstd.Encoder(.{ .level = level });

        output: []u8,
        encoder: *Encoder,

        pub fn run(self: *const Self, input: []const u8) ?usize {
            self.encoder.start();
            return self.encoder.encode_all(input, self.output) catch null;
        }
    };
}

/// Prints the table: each encoder at each level over each row.
pub fn report(arena: std.mem.Allocator, out: *std.Io.Writer, counters: *const Counters, rows: []const Input) !void {
    try out.print("\n## Hardware counters per input octet, Zstandard encoders\n\n", .{});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |\n", .{});
    try out.print("|---|---|---|---|---|---|---|---|\n", .{});
    for (rows) |input| {
        inline for (levels) |level| try report_row(level, arena, out, counters, input);
    }
}

/// One row at one level: both encoders' frames checked, then each counted.
fn report_row(comptime level: u4, arena: std.mem.Allocator, out: *std.Io.Writer, counters: *const Counters, input: Input) !void {
    const StdxLevel = Stdx(level);
    const output_len = @max(oracle.zstd_bound(input.part_len), StdxLevel.Encoder.encoded_len_max(input.part_len));
    const context = oracle.zstd_encoder.create(level) orelse return error.OutOfMemory;
    defer oracle.zstd_encoder.free(context);
    const libzstd: Libzstd = .{ .output = try arena.alloc(u8, output_len), .context = context };
    const stdx: StdxLevel = .{ .output = try arena.alloc(u8, output_len), .encoder = try arena.create(StdxLevel.Encoder) };
    stdx.encoder.init(codec.Features.detect());
    const decoded = try arena.alloc(u8, input.part_len);
    const rounds = @max(1, encoded_input_len_min / @max(1, input.len()));
    inline for (.{ libzstd, stdx }, .{ "libzstd", "stdx" }) |candidate, name| {
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
        try out.print("| {s} | {d} | {d} | {s} | {d:.2} | {d:.2} | {d:.2} | {d:.2} |\n", .{
            input.name,      input.len(),           level,                          name,
            cycles / octets, instructions / octets, instructions / @max(1, cycles), misses / octets * 1024,
        });
    }
}

/// Requires `candidate`'s frame of every part of `input` to decode through libzstd to the part.
fn expect_round_trips(candidate: anytype, input: Input, decoded: []u8) !void {
    for (input.parts) |part| {
        const frame_len = candidate.run(part) orelse return error.CandidateFailed;
        const written = oracle.zstd_decode(candidate.output[0..frame_len], decoded) orelse return error.CandidatesDisagree;
        if (written != part.len or !std.mem.eql(u8, part, decoded[0..written])) return error.CandidatesDisagree;
    }
}
