//! The brotli oracle of decision 8, Google's brotli, as Zig calls over `tools/oracle/oracle_brotli.c`,
//! which calls it through its public API alone. tools/oracle/oracle.zig exports these.

const std = @import("std");
const Result = @import("oracle.zig").Result;

extern fn oracle_brotli_bound(input_len: usize) usize;
extern fn oracle_brotli_encode(quality: c_int, window_bits: c_int, large_window: c_int, postfix_bits: c_int, direct_count: c_int, flush_every: usize, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) usize;
extern fn oracle_brotli_decode_verdict(input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) Result;

/// The parameters of one stream of Google's encoder.
pub const BrotliEncoding = struct {
    /// Quality 0 to 11, and WBITS 10 to 24.
    quality: c_int,
    window_bits: c_int = 22,
    /// RFC 9841's large window, which stdx refuses (decision 13).
    large_window: bool = false,
    /// NPOSTFIX and NDIRECT (RFC 7932 §4), or null for the encoder's own.
    postfix_bits: ?u2 = null,
    direct_count: ?u8 = null,
    /// A flush, which ends a meta-block, after every this many octets; 0 for none.
    flush_every: usize = 0,
};

/// The most octets Google's encoder writes for `input_len` octets.
pub fn brotli_bound(input_len: usize) usize {
    return oracle_brotli_bound(input_len);
}

/// Google's stream of `input` into `output`, or null when its encoder failed or `output` had no
/// room.
pub fn brotli_encode(encoding: BrotliEncoding, input: []const u8, output: []u8) ?usize {
    const postfix_bits: c_int = if (encoding.postfix_bits) |bits| bits else -1;
    const direct_count: c_int = if (encoding.direct_count) |count| count else -1;
    const written = oracle_brotli_encode(encoding.quality, encoding.window_bits, @intFromBool(encoding.large_window), postfix_bits, direct_count, encoding.flush_every, input.ptr, input.len, output.ptr, output.len);
    return if (written == std.math.maxInt(usize)) null else written;
}

/// Google's verdict on `input` through its streaming decoder, with all of the input and the output.
pub fn brotli_decode_verdict(input: []const u8, output: []u8) Result {
    return oracle_brotli_decode_verdict(input.ptr, input.len, output.ptr, output.len);
}

// Tests.

const testing = std.testing;

test "Google's brotli decodes its own stream, reports a cut input and a full output, and refuses a large window" {
    const input = "brotli brotli brotli, a stream of RFC 7932 " ** 8;
    var stream: [1024]u8 = undefined;
    const stream_len = brotli_encode(.{ .quality = 9, .window_bits = 16, .flush_every = 100 }, input, &stream).?;
    var output: [1024]u8 = undefined;
    const whole = brotli_decode_verdict(stream[0..stream_len], &output);
    try testing.expectEqual(.ok, whole.verdict);
    try testing.expectEqual(stream_len, whole.consumed);
    try testing.expectEqualStrings(input, output[0..whole.written]);
    try testing.expectEqual(.incomplete, brotli_decode_verdict(stream[0 .. stream_len - 1], &output).verdict);
    try testing.expectEqual(.no_room, brotli_decode_verdict(stream[0..stream_len], output[0..10]).verdict);
    const large_len = brotli_encode(.{ .quality = 5, .large_window = true, .window_bits = 26 }, input, &stream).?;
    try testing.expectEqual(.refused, brotli_decode_verdict(stream[0..large_len], &output).verdict);
}

test "Google's encoder takes NPOSTFIX and NDIRECT" {
    const input = "0123456789abcdef" ** 64;
    var stream: [2048]u8 = undefined;
    const stream_len = brotli_encode(.{ .quality = 11, .window_bits = 18, .postfix_bits = 2, .direct_count = 12 }, input, &stream).?;
    var output: [2048]u8 = undefined;
    const whole = brotli_decode_verdict(stream[0..stream_len], &output);
    try testing.expectEqual(.ok, whole.verdict);
    try testing.expectEqualStrings(input, output[0..whole.written]);
}
