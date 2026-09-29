//! bench-synth: a temporary experiment for https://github.com/c4milo/stdx/issues/13 that never
//! lands. Times libdeflate's and stdx's gzip decoders over synthetic streams whose symbol
//! statistics vary one at a time (gen.py), interleaved, five runs each, and prints a Markdown
//! table with the ratio.
//!
//! Usage: `bench_synth <name>=<path.gz>...`.

const std = @import("std");
const timing = @import("timing");
const codec = @import("codec");
const gzip = @import("gzip");
const baselines = @import("baselines");

/// A gzip member's ISIZE: its decoded length modulo 2^32, least significant octet first (RFC 1952
/// §2.3.1), in the member's last four octets.
const trailer_len = 8;

const BaselineDecode = struct {
    stream: []const u8,
    output: []u8,

    fn run_once(context: *const anyopaque) void {
        const self: *const BaselineDecode = @ptrCast(@alignCast(context));
        std.debug.assert(baselines.libdeflate_gzip_decode(self.stream, self.output) == self.output.len);
    }
};

const StdxDecode = struct {
    stream: []const u8,
    output: []u8,
    decoder: *gzip.Decoder,
    features: codec.Features,

    fn run_once(context: *const anyopaque) void {
        const self: *const StdxDecode = @ptrCast(@alignCast(context));
        gzip.init(self.decoder, self.features);
        const progress = gzip.decode(self.decoder, self.stream, self.output) catch unreachable;
        std.debug.assert(progress.status == .done and progress.written == self.output.len);
    }
};

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;
    try out.print("## Synthetic streams, gzip\n\n| Stream | Octets | libdeflate, MB/s | stdx, MB/s | stdx / libdeflate |\n|---|---|---|---|---|\n", .{});
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse return error.UsageNameEqualsPath;
        const stream = try std.Io.Dir.cwd().readFileAlloc(io, argument[split + 1 ..], arena, .unlimited);
        if (stream.len < trailer_len) return error.StreamTooShort;
        const decoded_len = std.mem.readInt(u32, stream[stream.len - 4 ..][0..4], .little);
        const libdeflate: BaselineDecode = .{ .stream = stream, .output = try arena.alloc(u8, decoded_len) };
        const stdx: StdxDecode = .{
            .stream = stream,
            .output = try arena.alloc(u8, decoded_len),
            .decoder = try arena.create(gzip.Decoder),
            .features = codec.Features.detect(),
        };
        const candidates = [_]timing.Operation{
            .{ .context = &libdeflate, .run_once = BaselineDecode.run_once },
            .{ .context = &stdx, .run_once = StdxDecode.run_once },
        };
        for (candidates) |candidate| candidate.run_once(candidate.context);
        if (!std.mem.eql(u8, libdeflate.output, stdx.output)) return error.CandidatesDisagree;
        var runs: [candidates.len][timing.run_count]f64 = undefined;
        timing.time_interleaved(io, &candidates, &runs);
        var rates: [candidates.len]f64 = undefined;
        for (&runs, 0..) |*candidate_runs, index| rates[index] = timing.megabytes_per_second(decoded_len, timing.summarize(candidate_runs.*).median);
        try out.print("| {s} | {d} | {d:.0} | {d:.0} | {d:.3} |\n", .{ argument[0..split], decoded_len, rates[0], rates[1], rates[1] / rates[0] });
        try out.flush();
    }
}
