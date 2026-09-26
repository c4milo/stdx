//! Tests for the zlib decoder. Streams are built here from a header, DEFLATE blocks and ADLER32
//! (RFC 1950 §2.2). Each decodes in one call and under seeded splits that move the state between
//! calls (invariant 12), and each refusal names its RFC rule.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const checksum = @import("checksum");
const deflate = @import("deflate");
const constants = @import("constants.zig");
const zlib = @import("decoder.zig");
const Decoder = zlib.Decoder;

/// The most octets a test decodes into.
const output_len_max = 1024;

/// The seeds each stream decodes under.
const split_seeds = 200;

pub const Stream = deflate.TestStream;

/// CMF for DEFLATE with a window of `2^(window_bits_field + 8)` octets (RFC 1950 §2.2).
pub fn method_and_info(window_bits_field: u8) u8 {
    return (window_bits_field << constants.window_bits_shift) | constants.method_deflate;
}

/// CMF with the window of DEFLATE's whole 32 KiB.
pub const deflate_32k = method_and_info(constants.window_bits_field_max);

/// CMF and FLG, with the FCHECK that makes CMF * 256 + FLG a multiple of 31 (RFC 1950 §2.2).
pub fn header(stream: *Stream, cmf: u8, flags: u8) void {
    const unchecked = flags & ~constants.header_check_mask;
    const without_check = (@as(u16, cmf) << @bitSizeOf(u8)) | unchecked;
    const check: u8 = @intCast((constants.header_check_divisor - without_check % constants.header_check_divisor) % constants.header_check_divisor);
    stream.append(&.{ cmf, unchecked | check });
}

/// ADLER32 of `decoded`, most significant octet first (RFC 1950 §2.2), at the next octet.
pub fn trailer(stream: *Stream, decoded: []const u8) void {
    var octets: [constants.trailer_len]u8 = undefined;
    std.mem.writeInt(u32, &octets, checksum.adler32(.scalar, constants.adler32_initial, decoded), .big);
    stream.append(&octets);
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) zlib.Error!codec.Progress {
    return zlib.decode(decoder, input, output);
}

/// Decodes `input` in one call and under every seed, and requires `expected` and the stream's end
/// at `stream_len`.
fn expect_decodes(input: []const u8, stream_len: usize, expected: []const u8) !void {
    var output: [output_len_max]u8 = undefined;
    var decoder: Decoder = undefined;
    zlib.init(&decoder, .{});
    const progress = try zlib.decode(&decoder, input, &output);
    try testing.expectEqual(codec.Status.done, progress.status);
    try testing.expectEqual(stream_len, progress.consumed);
    try testing.expectEqualSlices(u8, expected, output[0..progress.written]);
    for (0..split_seeds) |seed| {
        var states: [codec.split.state_slots]Decoder = undefined;
        zlib.init(&states[0], .{});
        const outcome = try codec.split.drive(Decoder, &states, step, input, output[0..expected.len], seed);
        try testing.expectEqual(codec.Status.done, outcome.status);
        try testing.expectEqual(stream_len, outcome.consumed);
        try testing.expectEqualSlices(u8, expected, output[0..outcome.written]);
    }
}

/// Requires `input` refused with `expected`, of class `class`, in one call and under every seed.
fn expect_refused(input: []const u8, expected: zlib.Error, class: codec.Refusal) !void {
    var output: [output_len_max]u8 = undefined;
    var decoder: Decoder = undefined;
    zlib.init(&decoder, .{});
    try testing.expectError(expected, zlib.decode(&decoder, input, &output));
    try testing.expectEqual(class, zlib.refusal(expected));
    for (0..split_seeds) |seed| {
        var states: [codec.split.state_slots]Decoder = undefined;
        zlib.init(&states[0], .{});
        try testing.expectError(expected, codec.split.drive(Decoder, &states, step, input, &output, seed));
    }
}

const text = "a zlib stream around a stored block, a zlib stream around a stored block";

fn stored_stream(stream: *Stream, octets: []const u8) void {
    header(stream, deflate_32k, 0);
    stream.stored(true, octets);
    trailer(stream, octets);
}

test "a stream decodes to its octets, and stops at the end of ADLER32" {
    var stream: Stream = .{};
    stored_stream(&stream, text);
    const stream_len = stream.slice().len;
    try expect_decodes(stream.slice(), stream_len, text);
    // Octets after ADLER32 are not part of the stream (RFC 1950 §2.2), and stay in the input.
    stream.append("next");
    try expect_decodes(stream.slice(), stream_len, text);
}

test "an empty stream's ADLER32 is 1" {
    var stream: Stream = .{};
    stored_stream(&stream, "");
    try testing.expectEqualSlices(u8, &.{ 0, 0, 0, 1 }, stream.slice()[stream.slice().len - 4 ..]);
    try expect_decodes(stream.slice(), stream.slice().len, "");
}

test "FLEVEL is ignored, as RFC 1950 section 2.3 allows" {
    for (0..4) |level| {
        var stream: Stream = .{};
        header(&stream, deflate_32k, @intCast(level << 6));
        stream.stored(true, text);
        trailer(&stream, text);
        try expect_decodes(stream.slice(), stream.slice().len, text);
    }
}

test "a cut stream needs input, and is never done before its last octet" {
    var stream: Stream = .{};
    stored_stream(&stream, text);
    const whole = stream.slice();
    var output: [output_len_max]u8 = undefined;
    for (0..whole.len) |cut| {
        var decoder: Decoder = undefined;
        zlib.init(&decoder, .{});
        const progress = try zlib.decode(&decoder, whole[0..cut], &output);
        try testing.expectEqual(codec.Status.needs_input, progress.status);
        try testing.expectEqual(cut, progress.consumed);
    }
}

test "each header field RFC 1950 requires a decompressor to check is refused" {
    var bad_check: Stream = .{};
    bad_check.append(&.{ 0x78, 0x9d });
    try expect_refused(bad_check.slice(), error.InvalidHeaderCheck, .corrupt);
    var method_7: Stream = .{};
    header(&method_7, 0x77, 0);
    try expect_refused(method_7.slice(), error.InvalidMethod, .corrupt);
    var method_15: Stream = .{};
    header(&method_15, 0x7f, 0);
    try expect_refused(method_15.slice(), error.InvalidMethod, .corrupt);
    var window_8: Stream = .{};
    header(&window_8, 0x88, 0);
    try expect_refused(window_8.slice(), error.InvalidWindowSize, .corrupt);
    var dictionary: Stream = .{};
    header(&dictionary, deflate_32k, 0x20);
    dictionary.append(&.{ 0, 0, 0, 1 });
    try expect_refused(dictionary.slice(), error.PresetDictionary, .unsupported);
}

test "a wrong ADLER32 is refused, whichever octet differs" {
    var stream: Stream = .{};
    stored_stream(&stream, text);
    const len = stream.slice().len;
    for (1..5) |from_end| {
        var corrupt = stream;
        corrupt.octets[len - from_end] ^= 0x10;
        try expect_refused(corrupt.slice(), error.ChecksumMismatch, .corrupt);
    }
}

test "the DEFLATE stream's refusals pass through" {
    var stream: Stream = .{};
    header(&stream, deflate_32k, 0);
    stream.block_header(true, .reserved);
    try expect_refused(stream.slice(), error.InvalidBlockType, .corrupt);
}

/// A stream of CINFO `window_bits_field`: a stored block of `prefix`, then a fixed block with a
/// shortest match at `distance`.
fn windowed_stream(stream: *Stream, window_bits_field: u8, prefix: []const u8, distance: u16, decoded: []const u8) void {
    header(stream, method_and_info(window_bits_field), 0);
    stream.stored(false, prefix);
    stream.block_header(true, .fixed);
    stream.fixed_pair(deflate.constants.match_len_min, distance);
    stream.fixed_literal(deflate.constants.end_of_block);
    trailer(stream, decoded);
}

test "a distance past the window CINFO declares is refused (decision 12)" {
    var prefix: [300]u8 = undefined;
    for (&prefix, 0..) |*octet, index| octet.* = @truncate(index);
    var decoded: [303]u8 = undefined;
    @memcpy(decoded[0..300], &prefix);
    @memcpy(decoded[300..], prefix[300 - 257 ..][0..3]);
    // CINFO 0, a window of 256 octets.
    var too_far: Stream = .{};
    windowed_stream(&too_far, 0, &prefix, 257, &decoded);
    try expect_refused(too_far.slice(), error.DistanceTooFar, .corrupt);
    // CINFO 1, a window of 512 octets.
    var in_reach: Stream = .{};
    windowed_stream(&in_reach, 1, &prefix, 257, &decoded);
    try expect_decodes(in_reach.slice(), in_reach.slice().len, &decoded);
}

test {
    _ = @import("decoder_fuzz_test.zig");
}
