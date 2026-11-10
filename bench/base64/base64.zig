//! bench-base64: base 64 throughput, for decision 68. The timing is bench/timing/timing.zig's: every
//! candidate of a row interleaved in one run, the median of five runs with the spread, and the
//! losses shown.
//!
//! The candidates, for the encoder and for the decoder, each with the standard alphabet and its pad
//! characters:
//! - Rust's `base64` crate 0.23.1, the crate connect-rust's Buffa uses, and Go's encoding/base64,
//!   which Go's protojson uses: the bar (decision 68);
//! - Zig's std.base64, for reference;
//! - stdx's `base64`, built for the architecture's baseline CPU and ReleaseSafe, as a caller
//!   shipping one binary builds it (decision 17), with the features `Features.detect()` finds, so
//!   x86-64 with AVX2 takes the variant object's kernels, and a new state begun for each text;
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

/// The candidates of each table, in this order.
const candidates = [_][]const u8{ "Rust base64", "Go encoding/base64", "std.base64", "stdx", "stdx, checked path" };
const rust = 0;
const go = 1;
const zig_std = 2;
const stdx = 3;
const checked = 4;

extern fn rust_base64_encode(input: [*]const u8, len: usize, output: [*]u8, room: usize) callconv(.c) usize;
extern fn rust_base64_decode(text: [*]const u8, len: usize, output: [*]u8, room: usize) callconv(.c) usize;
extern fn go_base64_encode(input: [*]const u8, len: usize, output: [*]u8, room: usize) callconv(.c) i64;
extern fn go_base64_decode(text: [*]const u8, len: usize, output: [*]u8, room: usize) callconv(.c) i64;

/// The CPU's features, as a caller detects them once and passes them to each codec (decision 21).
var features: codec.Features = .{};

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
        rust => rust_base64_encode(input.ptr, input.len, output.ptr, output.len),
        go => @intCast(go_base64_encode(input.ptr, input.len, output.ptr, output.len)),
        zig_std => std.base64.standard.Encoder.encode(output, input).len,
        stdx => state.encode_with(.{}, input, output, .finish).written,
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
        rust => blk: {
            const len = rust_base64_decode(text.ptr, text.len, output.ptr, output.len);
            if (len == std.math.maxInt(usize)) return error.Refused;
            break :blk len;
        },
        go => blk: {
            const len = go_base64_decode(text.ptr, text.len, output.ptr, output.len);
            if (len < 0) return error.Refused;
            break :blk @intCast(len);
        },
        zig_std => blk: {
            const len = try std.base64.standard.Decoder.calcSizeForSlice(text);
            try std.base64.standard.Decoder.decode(output[0..len], text);
            break :blk len;
        },
        stdx => (try state.decode_with(.{}, text, output, .last)).written,
        else => (try state.decode_with(.{ .whole_quanta = false }, text, output, .last)).written,
    };
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;
    const arena = init.arena.allocator();
    features = codec.Features.detect();

    const size_max = sizes[sizes.len - 1];
    const input = try arena.alloc(u8, size_max);
    var generator = codec.testing.split.Generator.init(input_seed);
    for (input) |*octet| octet.* = @truncate(generator.next());
    const text = try arena.alloc(u8, base64.Encoder.encoded_len(size_max, true));
    const letters = try arena.alloc(u8, text.len);
    // Go's DecodedLen counts a text's pad characters as octets, so the room holds a group more.
    const back = try arena.alloc(u8, size_max + base64.constants.group_octets);

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
        for (0..candidates.len) |kind| {
            const len = encode(kind, input[0..size], letters);
            if (!std.mem.eql(u8, letters[0..len], reference)) {
                std.debug.print("bench-base64: {s} encodes {d} octets otherwise\n", .{ candidates[kind], size });
                return error.CandidatesDisagree;
            }
            const decoded = decode(kind, reference, back) catch |err| {
                std.debug.print("bench-base64: {s} refused the text of {d} octets\n", .{ candidates[kind], size });
                return err;
            };
            if (!std.mem.eql(u8, back[0..decoded], input[0..size])) return error.CandidatesDisagree;
        }
    }
}

const Direction = enum { encode, decode };

fn report(io: std.Io, out: *std.Io.Writer, direction: Direction, input: []const u8, text: []u8, letters: []u8, back: []u8) !void {
    try out.print("## base 64 {s}, GB/s of octets\n\n| Octets |", .{@tagName(direction)});
    for (candidates) |name| try out.print(" {s} |", .{name});
    try out.print(" stdx / fastest of Rust and Go | stdx / std.base64 | stdx / checked path |\n|---|", .{});
    for (0..candidates.len + 3) |_| try out.print("---|", .{});
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
        const bar = @max(rates[rust], rates[go]);
        try out.print(" {d:.2} | {d:.2} | {d:.2} |\n", .{ rates[stdx] / bar, rates[stdx] / rates[zig_std], rates[stdx] / rates[checked] });
    }
    try out.print("\n", .{});
}
