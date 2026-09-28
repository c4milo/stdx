//! bench-profile: hardware counters for each gzip, Zstandard and brotli decoder over the corpora,
//! where the host exposes them: cycles, instructions and branch misses per decoded octet, counted
//! around the decoding alone through Linux's perf_event_open, in user space only. It shows where
//! the fast paths of design §8 steps 7, 11 and 12 spend their cycles against the baselines, and it
//! answers whether a hosted runner exposes the counters, which docs/costs.md leaves open (decision
//! 20). A host without them gets a line that says so, and the program exits 0.
//!
//! The streams are bench-deflate's, zlib's gzip at level 6, bench-zstd's, libzstd's frames at
//! level 3, and bench-brotli's, Google's brotli at quality 11 and window 22, of each file's first
//! `brotli_input_len_max` octets. Each decoder decodes each file's stream until it has written at
//! least `decoded_len_min` octets, after one decode checked against the file.
//!
//! Before the counters, on every host, it prints S2's count (decision 14): how stdx's decoder
//! took each symbol of each file's raw DEFLATE stream at the same level, by one lookup in its
//! tables, by the canonical code after a lookup, or on the checked path.
//!
//! Usage: `bench_profile <name>=<path>...`. It prints a Markdown table to standard output.

const std = @import("std");
const oracle = @import("oracle");
const codec = @import("codec");
const gzip = @import("gzip");
const deflate = @import("deflate");
const zstd = @import("zstd");
const brotli = @import("brotli");
const baselines = @import("baselines");
const timing = @import("timing");
const Counters = timing.counters.Counters;

/// The zlib level of the streams, bench-deflate's.
const encode_level: c_int = 6;

/// The libzstd level of the frames, bench-zstd's.
const zstd_level: c_int = 3;

/// Google's quality and window for the brotli streams, bench-brotli's: its command-line tool's
/// defaults.
const brotli_quality: c_int = 11;
const brotli_window_bits: c_int = 22;

/// The octets of each file the brotli streams hold, at most. Google's encoder at quality 11 would
/// add minutes to every run over whole files, and the counts per octet need no more.
const brotli_input_len_max = 1024 * 1024;

/// The octets each decoder writes per file, at least, over as many decodes as that takes.
const decoded_len_min = 16 * 1024 * 1024;

/// What a decoder needs besides the stream: stdx's states, the features they pick paths by, and
/// libzstd's context, kept across decodes as bench-zstd keeps it.
const Context = struct {
    decoder: *gzip.Decoder,
    zstd_decoder: *zstd.HttpDecoder,
    brotli_decoder: *brotli.HttpDecoder,
    features: codec.Features,
    libzstd: *oracle.ZstdContext,
};

const Candidate = struct {
    name: []const u8,
    /// One decode of the whole stream into `output`. Returns whether it wrote all of it.
    decode: *const fn (context: Context, stream: []const u8, output: []u8) bool,
};

fn decode_zlib(_: Context, stream: []const u8, output: []u8) bool {
    const result = oracle.zlib_decode(.gzip, stream, output);
    return result.verdict == .ok and result.written == output.len;
}

fn decode_zlib_ng(_: Context, stream: []const u8, output: []u8) bool {
    return baselines.zlib_ng_gzip_decode(stream, output) == output.len;
}

fn decode_libdeflate(_: Context, stream: []const u8, output: []u8) bool {
    return baselines.libdeflate_gzip_decode(stream, output) == output.len;
}

fn decode_wuffs(_: Context, stream: []const u8, output: []u8) bool {
    const result = oracle.wuffs_decode(.gzip, stream, output);
    return result.verdict == .ok and result.written == output.len;
}

fn decode_stdx(context: Context, stream: []const u8, output: []u8) bool {
    gzip.init(context.decoder, context.features);
    const progress = gzip.decode(context.decoder, stream, output) catch return false;
    return progress.status == .done and progress.written == output.len;
}

const candidates = [_]Candidate{
    .{ .name = "zlib", .decode = decode_zlib },
    .{ .name = "zlib-ng", .decode = decode_zlib_ng },
    .{ .name = "libdeflate", .decode = decode_libdeflate },
    .{ .name = "Wuffs", .decode = decode_wuffs },
    .{ .name = "stdx", .decode = decode_stdx },
};

fn decode_libzstd(context: Context, frame: []const u8, output: []u8) bool {
    return oracle.zstd_decode_with(context.libzstd, frame, output) == output.len;
}

fn decode_stdx_zstd(context: Context, frame: []const u8, output: []u8) bool {
    context.zstd_decoder.init(context.features);
    const progress = context.zstd_decoder.decode(frame, output) catch return false;
    return progress.status == .done and progress.written == output.len;
}

const zstd_candidates = [_]Candidate{
    .{ .name = "libzstd", .decode = decode_libzstd },
    .{ .name = "stdx", .decode = decode_stdx_zstd },
};

fn decode_google_brotli(_: Context, stream: []const u8, output: []u8) bool {
    const result = oracle.brotli_decode_verdict(stream, output);
    return result.verdict == .ok and result.written == output.len;
}

fn decode_stdx_brotli(context: Context, stream: []const u8, output: []u8) bool {
    context.brotli_decoder.init(context.features);
    const progress = context.brotli_decoder.decode(stream, output) catch return false;
    return progress.status == .done and progress.written == output.len;
}

const brotli_candidates = [_]Candidate{
    .{ .name = "Google", .decode = decode_google_brotli },
    .{ .name = "stdx", .decode = decode_stdx_brotli },
};

/// The stream a section's decoders take for `input`.
const Encode = *const fn (arena: std.mem.Allocator, input: []const u8) anyerror![]const u8;

fn gzip_stream(arena: std.mem.Allocator, input: []const u8) anyerror![]const u8 {
    const encoded = try arena.alloc(u8, oracle.zlib_bound(.gzip, input.len));
    const encoding: oracle.Encoding = .{ .container = .gzip, .level = encode_level, .strategy = .default };
    return encoded[0..oracle.zlib_encode(encoding, input, encoded).written];
}

fn zstd_frame(arena: std.mem.Allocator, input: []const u8) anyerror![]const u8 {
    const encoded = try arena.alloc(u8, oracle.zstd_bound(input.len));
    const frame_len = oracle.zstd_encode(.{ .level = zstd_level }, input, encoded) orelse return error.EncodeFailed;
    return encoded[0..frame_len];
}

fn brotli_stream(arena: std.mem.Allocator, input: []const u8) anyerror![]const u8 {
    const encoded = try arena.alloc(u8, oracle.brotli_bound(input.len));
    const encoding: oracle.BrotliEncoding = .{ .quality = brotli_quality, .window_bits = brotli_window_bits };
    const stream_len = oracle.brotli_encode(encoding, input, encoded) orelse return error.EncodeFailed;
    return encoded[0..stream_len];
}

/// Prints S2's count for one file: the symbols of its raw DEFLATE stream, and how stdx took them.
fn report_lookups(arena: std.mem.Allocator, out: *std.Io.Writer, name: []const u8, input: []const u8) !void {
    const encoded = try arena.alloc(u8, oracle.zlib_bound(.raw, input.len));
    const encoding: oracle.Encoding = .{ .container = .raw, .level = encode_level, .strategy = .default };
    const stream = encoded[0..oracle.zlib_encode(encoding, input, encoded).written];
    const output = try arena.alloc(u8, input.len);
    const decoder = try arena.create(deflate.Decoder);
    deflate.init(decoder, .{});
    var lookups: deflate.Lookups = .{};
    const progress = try deflate.decode_counting(.{}, decoder, stream, output, &lookups);
    if (progress.status != .done or !std.mem.eql(u8, input, output)) return error.CandidateDisagrees;
    const symbols = lookups.table + lookups.canonical + lookups.checked;
    const share = @as(f64, @floatFromInt(lookups.table)) / @as(f64, @floatFromInt(@max(1, symbols)));
    try out.print("| {s} | {d} | {d} | {d} | {d} | {d:.4} |\n", .{ name, symbols, lookups.table, lookups.canonical, lookups.checked, share });
}

/// One table of counters: each of `section`'s decoders over the stream of each file's first
/// `input_len_max` octets, after one decode checked against them.
fn report_counters(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, counters: *const Counters, context: Context, section: []const Candidate, encode: Encode, input_len_max: usize, arguments: []const []const u8) !void {
    try out.print("| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |\n", .{});
    try out.print("|---|---|---|---|---|---|---|\n", .{});
    for (arguments) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse return error.UsageNameEqualsPath;
        const file = try std.Io.Dir.cwd().readFileAlloc(io, argument[split + 1 ..], arena, .unlimited);
        const input = file[0..@min(file.len, input_len_max)];
        const stream = try encode(arena, input);
        const output = try arena.alloc(u8, input.len);
        const rounds = @max(1, decoded_len_min / @max(1, input.len));
        for (section) |candidate| {
            if (!candidate.decode(context, stream, output) or !std.mem.eql(u8, input, output)) return error.CandidateDisagrees;
            counters.start();
            for (0..rounds) |_| std.mem.doNotOptimizeAway(candidate.decode(context, stream, output));
            const counts = counters.stop();
            const octets: f64 = @floatFromInt(rounds * input.len);
            const cycles: f64 = @floatFromInt(counts[timing.counters.cycles]);
            const instructions: f64 = @floatFromInt(counts[timing.counters.instructions]);
            const misses: f64 = @floatFromInt(counts[timing.counters.branch_misses]);
            try out.print("| {s} | {d} | {s} | {d:.2} | {d:.2} | {d:.2} | {d:.2} |\n", .{
                argument[0..split],     input.len,             candidate.name,
                cycles / octets,        instructions / octets, instructions / @max(1, cycles),
                misses / octets * 1024,
            });
        }
    }
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;
    try out.print("## S2: how stdx's decoder took each symbol, raw DEFLATE at zlib level {d}\n\n", .{encode_level});
    try out.print("| File | Symbols | One lookup | Canonical code | Checked path | One lookup, share |\n", .{});
    try out.print("|---|---|---|---|---|---|\n", .{});
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse return error.UsageNameEqualsPath;
        const input = try std.Io.Dir.cwd().readFileAlloc(io, argument[split + 1 ..], arena, .unlimited);
        try report_lookups(arena, out, argument[0..split], input);
    }
    if (comptime !timing.counters.available) {
        try out.print("\n## Hardware counters per decoded octet\n\nHardware counters are read through Linux's perf_event_open; this host is not Linux.\n", .{});
        try out.flush();
        return;
    }
    const counters = Counters.open() catch {
        try out.print("\n## Hardware counters per decoded octet\n\nHardware counters are unavailable on this host: perf_event_open refused them.\n", .{});
        try out.flush();
        return;
    };
    const libzstd = oracle.zstd_context_create() orelse return error.OutOfMemory;
    const context: Context = .{
        .decoder = try arena.create(gzip.Decoder),
        .zstd_decoder = try arena.create(zstd.HttpDecoder),
        .brotli_decoder = try arena.create(brotli.HttpDecoder),
        .features = codec.Features.detect(),
        .libzstd = libzstd,
    };
    try out.print("\n## Hardware counters per decoded octet, gzip at zlib level {d}\n\n", .{encode_level});
    try report_counters(arena, io, out, &counters, context, &candidates, gzip_stream, std.math.maxInt(usize), args[1..]);
    try out.print("\n## Hardware counters per decoded octet, Zstandard at libzstd level {d}\n\n", .{zstd_level});
    try report_counters(arena, io, out, &counters, context, &zstd_candidates, zstd_frame, std.math.maxInt(usize), args[1..]);
    try out.print("\n## Hardware counters per decoded octet, brotli at quality {d}, window {d}, first {d} KiB\n\n", .{ brotli_quality, brotli_window_bits, brotli_input_len_max / 1024 });
    try report_counters(arena, io, out, &counters, context, &brotli_candidates, brotli_stream, brotli_input_len_max, args[1..]);
    try out.flush();
}
