//! bench-zstd's encoding section: libzstd's encoder and stdx's at levels 1 and 3, the levels
//! decision 13 gives stdx's encoder (design §8 step 13).
//!
//! - Each operation encodes one whole frame of a part of the row's input, with a state kept across
//!   frames, as a server keeps one per connection or thread: libzstd's context, set once to the
//!   level, and stdx's state, started once with `init` and begun for each frame with `start`
//!   (decision 60). A file taken whole is one part; a small HTTP body is the slices of its payload
//!   (decision 45, bench/timing/inputs.zig).
//! - Throughput counts input octets. The ratio is input octets over encoded octets.
//! - Each library means its own search by a level, so a row compares what each calls level 1 or 3.
//!   Neither writes a checksum.
//! - Every candidate's frame of every part decodes back to the part through libzstd before any is
//!   timed.

const std = @import("std");
const oracle = @import("oracle");
const timing = @import("timing");
const codec = @import("codec");
const zstd = @import("zstd");
const inputs = timing.inputs;
const Input = inputs.Input;

/// The levels every encoder is timed at.
const levels = [_]u4{ 1, 3 };

const candidate_names = [_][]const u8{ "libzstd", "stdx" };
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

/// An encode of one frame by libzstd at one level, with no checksum, through a context kept
/// across frames.
const LibzstdEncode = struct {
    output: []u8,
    context: *oracle.zstd_encoder.Context,

    pub fn run(self: *const LibzstdEncode, input: []const u8) ?usize {
        return oracle.zstd_encoder.encode(self.context, input, self.output);
    }
};

/// An encode of one frame by stdx's encoder at `level`, in one call. The state is placed once,
/// started once with `init`, and reached through a pointer; each encode begins its frame with
/// `start`.
fn StdxEncode(comptime level: u4) type {
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

/// Times every candidate over every row's input at every level, then prints the speed table and
/// the ratio table.
pub fn report(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, all: []const Input) !void {
    var rows: std.ArrayList(Row) = .empty;
    for (all) |input| {
        inline for (levels) |level| try rows.append(arena, try measure(level, arena, io, input));
    }
    try out.print("\n## Encoding speed\n\n", .{});
    try inputs.note(out, all);
    try print_header(out, "MB/s");
    for (rows.items) |row| {
        try out.print("| {s} | {d} | {d} |", .{ row.name, row.input_len, row.level });
        for (row.rates, row.spreads) |rate, spread| try out.print(" {d:.1} ± {d:.1}% |", .{ rate, spread });
        try out.print(" {d:.2} |\n", .{row.rates[stdx_index] / row.rates[0]});
    }
    try out.print("\n## Encoding ratio\n\n", .{});
    try inputs.note(out, all);
    try print_header(out, "ratio");
    for (rows.items) |row| {
        try out.print("| {s} | {d} | {d} |", .{ row.name, row.input_len, row.level });
        for (row.ratios) |ratio| try out.print(" {d:.3} |", .{ratio});
        try out.print(" {d:.3} |\n", .{row.ratios[stdx_index] / row.ratios[0]});
    }
}

/// A table's header: each candidate's column in `unit`, then stdx over libzstd.
fn print_header(out: *std.Io.Writer, unit: []const u8) !void {
    try out.print("| File | Octets | Level |", .{});
    for (candidate_names) |name| try out.print(" {s}, {s} |", .{ name, unit });
    try out.print(" stdx / libzstd |\n|---|---|---|", .{});
    for (0..candidate_count + 1) |_| try out.print("---|", .{});
    try out.print("\n", .{});
}

/// One row: each candidate encodes every part of `input` and its frames are decoded back, then
/// both are timed interleaved.
fn measure(comptime level: u4, arena: std.mem.Allocator, io: std.Io, input: Input) !Row {
    const Stdx = StdxEncode(level);
    const output_len = @max(oracle.zstd_bound(input.part_len), Stdx.Encoder.encoded_len_max(input.part_len));
    const context = oracle.zstd_encoder.create(level) orelse return error.OutOfMemory;
    defer oracle.zstd_encoder.free(context);
    const libzstd: LibzstdEncode = .{ .output = try arena.alloc(u8, output_len), .context = context };
    const stdx: Stdx = .{ .output = try arena.alloc(u8, output_len), .encoder = try arena.create(Stdx.Encoder) };
    stdx.encoder.init(codec.Features.detect());
    var row: Row = .{ .name = input.name, .input_len = input.len(), .level = level, .rates = undefined, .spreads = undefined, .ratios = undefined };
    var candidates: [candidate_count]timing.Operation = undefined;
    const decoded = try arena.alloc(u8, input.part_len);
    inline for (.{ libzstd, stdx }, 0..) |candidate, index| {
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

/// Requires `candidate`'s frame of every part of `input` to decode through libzstd to the part.
/// Returns the octets of the frames together.
fn encoded_len_of(candidate: anytype, input: Input, decoded: []u8) !usize {
    var encoded_len: usize = 0;
    for (input.parts) |part| {
        const frame_len = candidate.run(part) orelse return error.CandidateFailed;
        const written = oracle.zstd_decode(candidate.output[0..frame_len], decoded) orelse return error.CandidatesDisagree;
        if (written != part.len or !std.mem.eql(u8, part, decoded[0..written])) return error.CandidatesDisagree;
        encoded_len += frame_len;
    }
    return encoded_len;
}
