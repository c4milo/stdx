//! bench-base64: base 64 throughput, for decision 68. The timing is bench/timing/timing.zig's: every
//! candidate of a row interleaved in one run, the median of five runs with the spread, and the
//! losses shown.
//!
//! The candidates, for the encoder and for the decoder:
//! - Zig's std.base64, with the standard alphabet and its pad characters;
//! - stdx's `base64`, built for the architecture's baseline CPU and ReleaseSafe, as a caller
//!   shipping one binary builds it (decision 17), a new state begun for each text;
//! - the same with decision 16's fast path off, the checked path it is measured against.
//!
//! The sizes run from 60 octets, the pieces a JSON encoder writes an octet string in, to 1 MiB. No
//! candidate's speed depends on the octets' values, so the input is SplitMix64's output.
//!
//! Usage: `bench_base64`. It prints Markdown tables to standard output.

const std = @import("std");
const timing = @import("timing");
const codec = @import("codec");
const base64 = @import("base64");

/// The octets of each row's input.
const sizes = [_]usize{ 60, 1024, 6144, 65536, 1 << 20 };

/// The seed of the input's octets.
const input_seed = 0x6261736536340000;

/// The candidates of each table.
const candidates = [_][]const u8{ "std.base64", "stdx", "stdx, checked path" };

const features = codec.Features.none();

const EncodeCall = struct {
    input: []const u8,
    output: []u8,
    kind: usize,

    fn run_once(context: *const anyopaque) void {
        const self: *const EncodeCall = @ptrCast(@alignCast(context));
        std.mem.doNotOptimizeAway(encode(self.kind, self.input, self.output));
    }
};

fn encode(kind: usize, input: []const u8, output: []u8) usize {
    var state: base64.Encoder = undefined;
    state.init(.{}, features);
    return switch (kind) {
        0 => std.base64.standard.Encoder.encode(output, input).len,
        1 => state.encode_with(.{}, input, output, .finish).written,
        else => state.encode_with(.{ .whole_groups = false }, input, output, .finish).written,
    };
}

const DecodeCall = struct {
    text: []const u8,
    output: []u8,
    kind: usize,

    fn run_once(context: *const anyopaque) void {
        const self: *const DecodeCall = @ptrCast(@alignCast(context));
        std.mem.doNotOptimizeAway(decode(self.kind, self.text, self.output) catch unreachable);
    }
};

fn decode(kind: usize, text: []const u8, output: []u8) !usize {
    var state: base64.Decoder = undefined;
    state.init(.{}, features);
    return switch (kind) {
        0 => blk: {
            const len = try std.base64.standard.Decoder.calcSizeForSlice(text);
            try std.base64.standard.Decoder.decode(output[0..len], text);
            break :blk len;
        },
        1 => (try state.decode_with(.{}, text, output, .last)).written,
        else => (try state.decode_with(.{ .whole_quanta = false }, text, output, .last)).written,
    };
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;
    const arena = init.arena.allocator();

    const size_max = sizes[sizes.len - 1];
    const input = try arena.alloc(u8, size_max);
    var generator = codec.testing.split.Generator.init(input_seed);
    for (input) |*octet| octet.* = @truncate(generator.next());
    const text = try arena.alloc(u8, base64.Encoder.encoded_len(size_max, true));
    const letters = try arena.alloc(u8, text.len);
    const back = try arena.alloc(u8, size_max);

    try check_agrees(input, text, letters, back);
    try report(io, out, .encode, input, text, letters, back);
    try report(io, out, .decode, input, text, letters, back);
    try out.flush();
}

/// Refuses to time candidates that disagree: a fast wrong answer is not a result.
fn check_agrees(input: []const u8, text: []u8, letters: []u8, back: []u8) !void {
    for (sizes) |size| {
        const text_len = base64.Encoder.encoded_len(size, true);
        const reference = std.base64.standard.Encoder.encode(text[0..text_len], input[0..size]);
        for (1..candidates.len) |kind| {
            const len = encode(kind, input[0..size], letters);
            if (!std.mem.eql(u8, letters[0..len], reference)) return error.CandidatesDisagree;
            const decoded = try decode(kind, reference, back);
            if (!std.mem.eql(u8, back[0..decoded], input[0..size])) return error.CandidatesDisagree;
        }
    }
}

const Direction = enum { encode, decode };

fn report(io: std.Io, out: *std.Io.Writer, direction: Direction, input: []const u8, text: []u8, letters: []u8, back: []u8) !void {
    try out.print("## base 64 {s}, GB/s of octets\n\n| Octets |", .{@tagName(direction)});
    for (candidates) |name| try out.print(" {s} |", .{name});
    try out.print(" stdx / std.base64 | stdx / checked path |\n|---|", .{});
    for (0..candidates.len + 2) |_| try out.print("---|", .{});
    try out.print("\n", .{});
    for (sizes) |size| {
        const text_len = base64.Encoder.encoded_len(size, true);
        _ = std.base64.standard.Encoder.encode(text[0..text_len], input[0..size]);
        var encodes: [candidates.len]EncodeCall = undefined;
        var decodes: [candidates.len]DecodeCall = undefined;
        var operations: [candidates.len]timing.Operation = undefined;
        for (0..candidates.len) |kind| {
            encodes[kind] = .{ .input = input[0..size], .output = letters, .kind = kind };
            decodes[kind] = .{ .text = text[0..text_len], .output = back, .kind = kind };
            operations[kind] = switch (direction) {
                .encode => .{ .context = &encodes[kind], .run_once = EncodeCall.run_once },
                .decode => .{ .context = &decodes[kind], .run_once = DecodeCall.run_once },
            };
        }
        var runs: [candidates.len][timing.run_count]f64 = undefined;
        timing.time_interleaved(io, &operations, &runs);
        var rates: [candidates.len]f64 = undefined;
        try out.print("| {d} |", .{size});
        for (runs, &rates) |candidate_runs, *rate| {
            const summary = timing.summarize(candidate_runs);
            rate.* = timing.gigabytes_per_second(size, summary.median);
            try out.print(" {d:.2} ± {d:.1}% |", .{ rate.*, summary.spread * 100 });
        }
        try out.print(" {d:.2} | {d:.2} |\n", .{ rates[1] / rates[0], rates[1] / rates[2] });
    }
    try out.print("\n", .{});
}
