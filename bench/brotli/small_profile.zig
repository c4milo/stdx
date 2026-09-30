//! small_profile: one corpus file's stream, encoded by Google's brotli at quality 11 and window 22
//! as bench-brotli encodes it, decoded again and again for a given time by stdx's HTTP decoder or by
//! Google's, so that a sampling profiler finds where each decoder's time goes. An experiment's
//! program, built as bench-brotli is: ReleaseSafe for the baseline CPU, the features detected once.
//!
//! Usage: `small_profile <stdx|google> <milliseconds> <path> [octets]`. With `octets`, each decoder
//! gets only the stream's first octets, so it reads the header and stops. It prints the decodes it made.

const std = @import("std");
const oracle = @import("oracle");
const codec = @import("codec");
const brotli = @import("brotli");

comptime {
    // The benchmark programs' vector `memset`, for both decoders alike.
    _ = @import("timing");
}

/// Decodes between two reads of the clock.
const batch_len = 1000;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    if (args.len != 4 and args.len != 5) return error.Usage;
    const google = std.mem.eql(u8, args[1], "google");
    const duration_ns = @as(i96, try std.fmt.parseInt(u32, args[2], 10)) * std.time.ns_per_ms;
    const input = try std.Io.Dir.cwd().readFileAlloc(io, args[3], arena, .unlimited);
    const encoded = try arena.alloc(u8, oracle.brotli_bound(input.len));
    const stream_len = oracle.brotli_encode(.{ .quality = 11, .window_bits = 22 }, input, encoded) orelse return error.EncodeFailed;
    const kept = if (args.len == 5) try std.fmt.parseInt(usize, args[4], 10) else stream_len;
    const stream = encoded[0..@min(kept, stream_len)];
    const whole = stream.len == stream_len;
    const output = try arena.alloc(u8, input.len);
    const decoder = try arena.create(brotli.HttpDecoder);
    const features = codec.Features.detect();
    var decodes: usize = 0;
    const start = std.Io.Timestamp.now(io, .awake);
    while (start.durationTo(std.Io.Timestamp.now(io, .awake)).nanoseconds < duration_ns) {
        for (0..batch_len) |_| {
            if (google) {
                const result = oracle.brotli_decode_verdict(stream, output);
                std.debug.assert(!whole or (result.verdict == .ok and result.written == output.len));
            } else {
                decoder.init(features);
                const progress = decoder.decode(stream, output) catch unreachable;
                std.debug.assert(if (whole) progress.status == .done and progress.written == output.len else progress.status == .needs_input);
            }
        }
        decodes += batch_len;
    }
    if (whole and !std.mem.eql(u8, input, output)) return error.DecodersDisagree;
    std.debug.print("{s}: {d} decodes of {d} octets\n", .{ args[1], decodes, input.len });
}
