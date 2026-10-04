//! bench-profile: hardware counters for each gzip, Zstandard and brotli decoder over the corpora,
//! where the host exposes them: cycles, instructions and branch misses per decoded octet, counted
//! around the decoding alone through Linux's perf_event_open, in user space only. It shows where
//! the fast paths of design §8 steps 7, 11 and 12 spend their cycles against the baselines, and it
//! answers whether a hosted runner exposes the counters, which docs/costs.md leaves open (decision
//! 20). A host without them gets a line that says so, and the program exits 0.
//!
//! The rows are the benchmarks': one a corpus file, taken whole, but for the 1 KiB and 16 KiB HTTP
//! bodies, which a row decodes as the slices of their 1 MiB payload, one stream a slice, one after
//! another (decision 45, bench/timing/inputs.zig). The streams are bench-deflate's, zlib's gzip at
//! level 6, bench-zstd's, libzstd's frames at level 3, and bench-brotli's, Google's brotli at
//! quality 11 and window 22, of each file's first `brotli_input_len_max` octets. Each decoder
//! decodes each row's streams until it has written at least `decoded_len_min` octets, after one
//! decode of each checked against its part.
//!
//! Before the counters, on every host, it prints S2's count (decision 14): how stdx's decoder
//! took each symbol of each file's raw DEFLATE stream at the same level, by one lookup in its
//! tables, by the canonical code after a lookup, or on the checked path.
//!
//! Usage: `bench_profile <name>=<path>...`. It prints Markdown tables to standard output.

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
const inputs = timing.inputs;
const Input = inputs.Input;

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

/// The octets each decoder writes per row, at least, over as many decodes as that takes.
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

    /// One decode of each of `coded`, in order, into `output`. Returns whether every one wrote all
    /// of it.
    fn decode_each(self: Candidate, context: Context, coded: []const []const u8, output: []u8) bool {
        var decoded = true;
        for (coded) |stream| decoded = self.decode(context, stream, output) and decoded;
        return decoded;
    }
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

/// zlib's encoder at `encode_level`, which writes one stream a part in `container`
/// (`inputs.streams`).
const ZlibStreams = struct {
    container: oracle.Container,

    pub fn bound(self: ZlibStreams, part_len: usize) usize {
        return oracle.zlib_bound(self.container, part_len);
    }

    pub fn encode(self: ZlibStreams, part: []const u8, room: []u8) ?usize {
        const encoding: oracle.Encoding = .{ .container = self.container, .level = encode_level, .strategy = .default };
        const result = oracle.zlib_encode(encoding, part, room);
        return if (result.verdict == .ok) result.written else null;
    }
};

/// libzstd's encoder at `zstd_level`, which writes one frame a part.
const ZstdFrames = struct {
    pub fn bound(_: ZstdFrames, part_len: usize) usize {
        return oracle.zstd_bound(part_len);
    }

    pub fn encode(_: ZstdFrames, part: []const u8, room: []u8) ?usize {
        return oracle.zstd_encode(.{ .level = zstd_level }, part, room);
    }
};

/// Google's encoder at `brotli_quality` and `brotli_window_bits`, which writes one stream a part.
const BrotliStreams = struct {
    pub fn bound(_: BrotliStreams, part_len: usize) usize {
        return oracle.brotli_bound(part_len);
    }

    pub fn encode(_: BrotliStreams, part: []const u8, room: []u8) ?usize {
        return oracle.brotli_encode(.{ .quality = brotli_quality, .window_bits = brotli_window_bits }, part, room);
    }
};

/// Prints S2's count for one row: the symbols of its raw DEFLATE streams, and how stdx took them.
fn report_lookups(arena: std.mem.Allocator, out: *std.Io.Writer, input: Input) !void {
    const coded = try inputs.streams(arena, input, ZlibStreams{ .container = .raw });
    const output = try arena.alloc(u8, input.part_len);
    const decoder = try arena.create(deflate.Decoder);
    var lookups: deflate.Lookups = .{};
    for (coded, input.parts) |stream, part| {
        deflate.init(decoder, .{});
        const progress = try deflate.decode_counting(.{}, decoder, stream, output, &lookups);
        if (progress.status != .done or !std.mem.eql(u8, part, output)) return error.CandidateDisagrees;
    }
    const symbols = lookups.table + lookups.canonical + lookups.checked;
    const share = @as(f64, @floatFromInt(lookups.table)) / @as(f64, @floatFromInt(@max(1, symbols)));
    try out.print("| {s} | {d} | {d} | {d} | {d} | {d:.4} |\n", .{ input.name, symbols, lookups.table, lookups.canonical, lookups.checked, share });
}

/// `input` with a file taken whole cut to its first `len_max` octets. A row of slices stays as it
/// is: its payload holds no more than a MiB.
fn limited(arena: std.mem.Allocator, input: Input, len_max: usize) !Input {
    if (input.parts.len != 1 or input.part_len <= len_max) return input;
    const parts = try arena.alloc([]const u8, 1);
    parts[0] = input.parts[0][0..len_max];
    return .{ .name = input.name, .parts = parts, .part_len = len_max };
}

/// One table of counters: each of `section`'s decoders over the streams `encoder` writes for each
/// row, a file taken whole cut to its first `input_len_max` octets, after one decode of each
/// stream checked against its part.
fn report_counters(arena: std.mem.Allocator, out: *std.Io.Writer, counters: *const Counters, context: Context, section: []const Candidate, encoder: anytype, input_len_max: usize, rows: []const Input) !void {
    try inputs.note(out, rows);
    try out.print("| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |\n", .{});
    try out.print("|---|---|---|---|---|---|---|\n", .{});
    for (rows) |row| {
        const input = try limited(arena, row, input_len_max);
        const coded = try inputs.streams(arena, input, encoder);
        const output = try arena.alloc(u8, input.part_len);
        const rounds = @max(1, decoded_len_min / @max(1, input.len()));
        for (section) |candidate| {
            for (coded, input.parts) |stream, part| {
                if (!candidate.decode(context, stream, output) or !std.mem.eql(u8, part, output)) return error.CandidateDisagrees;
            }
            counters.start();
            for (0..rounds) |_| std.mem.doNotOptimizeAway(candidate.decode_each(context, coded, output));
            const counts = counters.stop();
            const octets: f64 = @floatFromInt(rounds * input.len());
            const cycles: f64 = @floatFromInt(counts[timing.counters.cycles]);
            const instructions: f64 = @floatFromInt(counts[timing.counters.instructions]);
            const misses: f64 = @floatFromInt(counts[timing.counters.branch_misses]);
            try out.print("| {s} | {d} | {s} | {d:.2} | {d:.2} | {d:.2} | {d:.2} |\n", .{
                input.name,             input.len(),           candidate.name,
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
    var files: std.ArrayList(inputs.File) = .empty;
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse return error.UsageNameEqualsPath;
        const octets = try std.Io.Dir.cwd().readFileAlloc(io, argument[split + 1 ..], arena, .unlimited);
        try files.append(arena, .{ .name = argument[0..split], .octets = octets });
    }
    const rows = try inputs.of(arena, files.items);
    try out.print("## S2: how stdx's decoder took each symbol, raw DEFLATE at zlib level {d}\n\n", .{encode_level});
    try inputs.note(out, rows);
    try out.print("| File | Symbols | One lookup | Canonical code | Checked path | One lookup, share |\n", .{});
    try out.print("|---|---|---|---|---|---|\n", .{});
    for (rows) |row| try report_lookups(arena, out, row);
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
    try report_counters(arena, out, &counters, context, &candidates, ZlibStreams{ .container = .gzip }, std.math.maxInt(usize), rows);
    try out.print("\n## Hardware counters per decoded octet, Zstandard at libzstd level {d}\n\n", .{zstd_level});
    try report_counters(arena, out, &counters, context, &zstd_candidates, ZstdFrames{}, std.math.maxInt(usize), rows);
    try out.print("\n## Hardware counters per decoded octet, brotli at quality {d}, window {d}, first {d} KiB\n\n", .{ brotli_quality, brotli_window_bits, brotli_input_len_max / 1024 });
    try report_counters(arena, out, &counters, context, &brotli_candidates, BrotliStreams{}, brotli_input_len_max, rows);
    try out.flush();
}
