//! bench-profile's encoding section: hardware counters for libdeflate's and stdx's gzip encoders
//! at levels 1, 6 and 9, the levels decision 13 gives stdx's encoder, per input octet. It shows
//! where stdx's encoder spends its cycles against libdeflate's on each runner: in more
//! instructions, or in fewer instructions a cycle, and how many branches miss.
//!
//! Each encoder encodes one whole member a part of the row's input from a fresh state, as
//! bench-deflate times it (`bench/deflate/deflate_encode.zig`), until it has read at least
//! `encoded_input_len_min` octets. Before the counters, each member of each part decodes back to
//! the part through zlib.

const std = @import("std");
const oracle = @import("oracle");
const codec = @import("codec");
const gzip = @import("gzip");
const baselines = @import("baselines");
const timing = @import("timing");
const Counters = timing.counters.Counters;
const inputs = timing.inputs;
const Input = inputs.Input;

/// The levels every encoder is counted at.
const levels = [_]u4{ 1, 6, 9 };

/// The input octets each encoder reads per row and level, at least, over as many encodes as that
/// takes.
const encoded_input_len_min = 8 * 1024 * 1024;

/// libdeflate's encoder at one level.
const Libdeflate = struct {
    output: []u8,
    level: c_int,

    pub fn run(self: *const Libdeflate, input: []const u8) ?usize {
        return baselines.libdeflate_gzip_encode(self.level, input, self.output);
    }
};

/// stdx's encoder at `level`, with its runtime safety checks, as a caller builds it. The state is
/// placed once and reached through a pointer, and each encode starts it with `init`.
fn Stdx(comptime level: u4) type {
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

/// Prints the table: each encoder at each level over each row.
pub fn report(arena: std.mem.Allocator, out: *std.Io.Writer, counters: *const Counters, rows: []const Input) !void {
    try out.print("\n## Hardware counters per input octet, gzip encoders\n\n", .{});
    try inputs.note(out, rows);
    try out.print("| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |\n", .{});
    try out.print("|---|---|---|---|---|---|---|---|\n", .{});
    for (rows) |input| {
        inline for (levels) |level| try report_row(level, arena, out, counters, input);
    }
}

/// One row at one level: both encoders' members checked, then each counted.
fn report_row(comptime level: u4, arena: std.mem.Allocator, out: *std.Io.Writer, counters: *const Counters, input: Input) !void {
    const StdxLevel = Stdx(level);
    const output_len = @max(baselines.libdeflate_gzip_bound(input.part_len), StdxLevel.Encoder.encoded_len_max(input.part_len));
    const libdeflate: Libdeflate = .{ .output = try arena.alloc(u8, output_len), .level = level };
    const stdx: StdxLevel = .{ .output = try arena.alloc(u8, output_len), .encoder = try arena.create(StdxLevel.Encoder), .features = codec.Features.detect() };
    const decoded = try arena.alloc(u8, input.part_len);
    const rounds = @max(1, encoded_input_len_min / @max(1, input.len()));
    inline for (.{ libdeflate, stdx }, .{ "libdeflate", "stdx" }) |candidate, name| {
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

/// Requires `candidate`'s member of every part of `input` to decode through zlib to the part.
fn expect_round_trips(candidate: anytype, input: Input, decoded: []u8) !void {
    for (input.parts) |part| {
        const member_len = candidate.run(part) orelse return error.CandidateFailed;
        const result = oracle.zlib_decode(.gzip, candidate.output[0..member_len], decoded);
        if (result.verdict != .ok or result.written != part.len or !std.mem.eql(u8, part, decoded[0..part.len])) return error.CandidatesDisagree;
    }
}
