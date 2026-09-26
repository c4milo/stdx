//! Tests for the checked-path DEFLATE decoder. Streams are built here bit by bit, least significant
//! bit first with Huffman codes most significant bit first (RFC 1951 §3.1.1), with codes assigned
//! by RFC 1951 §3.2.2's algorithm. Each stream decodes in one call and under seeded splits that
//! move the state between calls (invariant 12), and each refusal names its RFC rule.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const deflate = @import("decoder.zig");
const Decoder = deflate.Decoder;
const test_stream = @import("test_stream.zig");

/// The most octets a test decodes into.
const output_len_max = 4096;

/// The seeds each stream decodes under.
const split_seeds = 200;

pub const Stream = test_stream.Stream;
pub const assign_codes = test_stream.assign_codes;

fn fresh() Decoder {
    var decoder: Decoder = undefined;
    deflate.init(&decoder, .{});
    return decoder;
}

/// Decodes the whole stream in one call.
fn decode_whole(input: []const u8, output: []u8) deflate.Error!codec.Progress {
    var decoder = fresh();
    return deflate.decode(&decoder, input, output);
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) deflate.Error!codec.Progress {
    return deflate.decode(decoder, input, output);
}

/// Requires the stream to decode to `expected`, ending exactly at its last octet, in one call and
/// under every seed's split.
pub fn expect_decodes(input: []const u8, expected: []const u8) !void {
    var output: [output_len_max]u8 = undefined;
    const whole = try decode_whole(input, &output);
    try testing.expectEqual(codec.Status.done, whole.status);
    try testing.expectEqual(input.len, whole.consumed);
    try testing.expectEqualSlices(u8, expected, output[0..whole.written]);
    for (0..split_seeds) |seed| {
        var states: [codec.split.state_slots]Decoder = undefined;
        deflate.init(&states[0], .{});
        var split_output: [output_len_max]u8 = undefined;
        const outcome = try codec.split.drive(Decoder, &states, step, input, split_output[0..expected.len], seed);
        try testing.expectEqual(codec.Status.done, outcome.status);
        try testing.expectEqual(input.len, outcome.consumed);
        try testing.expectEqualSlices(u8, expected, split_output[0..outcome.written]);
    }
}

/// Requires the stream to be refused with `expected`, in one call and under every seed's split.
pub fn expect_refused(input: []const u8, expected: deflate.Error) !void {
    var output: [output_len_max]u8 = undefined;
    try testing.expectError(expected, decode_whole(input, &output));
    try testing.expectEqual(codec.Refusal.corrupt, deflate.refusal(expected));
    for (0..split_seeds) |seed| {
        var states: [codec.split.state_slots]Decoder = undefined;
        deflate.init(&states[0], .{});
        try testing.expectError(expected, codec.split.drive(Decoder, &states, step, input, &output, seed));
    }
}

test "stored blocks, empty and not, end where the stream ends" {
    var stream: Stream = .{};
    stream.stored(false, "");
    stream.stored(false, "hello, ");
    stream.stored(true, "world");
    try expect_decodes(stream.slice(), "hello, world");
}

test "fixed-code literals, and matches that overlap their own output" {
    var stream: Stream = .{};
    stream.block_header(true, .fixed);
    for ("abc") |octet| stream.fixed_literal(octet);
    stream.fixed_pair(6, 3);
    stream.fixed_literal('x');
    stream.fixed_pair(258, 1);
    stream.fixed_literal(constants.end_of_block);
    try expect_decodes(stream.slice(), "abcabcabcx" ++ "x" ** 258);
}

test "every length and distance code's extra bits, across block boundaries" {
    var stream: Stream = .{};
    var expected: [output_len_max]u8 = undefined;
    var expected_len: usize = 0;
    stream.block_header(false, .stored);
    stream.align_to_octet();
    const seed_len = 600;
    stream.bits(seed_len, constants.stored_len_bits);
    stream.bits(~@as(u16, seed_len), constants.stored_len_bits);
    for (0..seed_len) |index| {
        const octet: u8 = @truncate(index *% 37 +% (index >> 3));
        stream.bits(octet, @bitSizeOf(u8));
        expected[expected_len] = octet;
        expected_len += 1;
    }
    stream.block_header(true, .fixed);
    for ([_][2]u16{ .{ 3, 1 }, .{ 11, 5 }, .{ 20, 9 }, .{ 131, 33 }, .{ 257, 129 }, .{ 100, 513 }, .{ 50, 600 } }) |pair| {
        stream.fixed_pair(pair[0], pair[1]);
        for (0..pair[0]) |_| {
            expected[expected_len] = expected[expected_len - pair[1]];
            expected_len += 1;
        }
    }
    stream.fixed_literal(constants.end_of_block);
    try expect_decodes(stream.slice(), expected[0..expected_len]);
}

test "octets after the stream stay in the input, after a block read ahead of its end" {
    var stored: Stream = .{};
    stored.stored(true, "ab");
    var fixed: Stream = .{};
    fixed.block_header(true, .fixed);
    fixed.fixed_literal('a');
    fixed.fixed_literal(constants.end_of_block);
    for ([_][]const u8{ stored.slice(), fixed.slice() }) |stream| {
        var input: [64]u8 = undefined;
        @memcpy(input[0..stream.len], stream);
        @memset(input[stream.len..][0..16], 0xee);
        var output: [16]u8 = undefined;
        const progress = try decode_whole(input[0 .. stream.len + 16], &output);
        try testing.expectEqual(codec.Status.done, progress.status);
        try testing.expectEqual(stream.len, progress.consumed);
    }
}

test "a stream cut short asks for input and has taken all of it" {
    var stream: Stream = .{};
    stream.block_header(true, .fixed);
    for ("abcdef") |octet| stream.fixed_literal(octet);
    stream.fixed_literal(constants.end_of_block);
    const whole = stream.slice();
    for (0..whole.len) |cut| {
        var output: [16]u8 = undefined;
        const progress = try decode_whole(whole[0..cut], &output);
        try testing.expectEqual(codec.Status.needs_input, progress.status);
        try testing.expectEqual(cut, progress.consumed);
    }
}

test "RFC 1951 section 3.2.3: BTYPE 11 is refused" {
    var stream: Stream = .{};
    stream.block_header(true, .reserved);
    try expect_refused(stream.slice(), error.InvalidBlockType);
}

test "RFC 1951 section 3.2.4: NLEN not LEN's complement is refused" {
    var stream: Stream = .{};
    stream.block_header(true, .stored);
    stream.align_to_octet();
    stream.bits(5, constants.stored_len_bits);
    stream.bits(5, constants.stored_len_bits);
    try expect_refused(stream.slice(), error.StoredLengthMismatch);
}

test "RFC 1951 section 3.2.6: literal/length 286 and 287, and distances 30 and 31, are refused" {
    for ([_]u16{ 286, 287 }) |symbol| {
        var stream: Stream = .{};
        stream.block_header(true, .fixed);
        stream.fixed_literal('a');
        stream.fixed_literal(symbol);
        stream.bits(0, 32);
        try expect_refused(stream.slice(), error.InvalidLiteralLength);
    }
    for ([_]u16{ 30, 31 }) |symbol| {
        var stream: Stream = .{};
        stream.block_header(true, .fixed);
        stream.fixed_literal('a');
        stream.fixed_literal(constants.first_length_symbol);
        stream.code(symbol, 5);
        stream.bits(0, 32);
        try expect_refused(stream.slice(), error.InvalidDistance);
    }
}

test "RFC 1951 section 3.2.5: code 284 with extra bits 31, a length of 258, is refused" {
    var stream: Stream = .{};
    stream.block_header(true, .fixed);
    stream.fixed_literal('a');
    stream.fixed_literal(284);
    stream.bits(31, 5);
    stream.code(0, 5);
    stream.bits(0, 32);
    try expect_refused(stream.slice(), error.InvalidLength);
}

test "invariant 10: a distance past the stream's start is refused, and the old window stays unread" {
    var stream: Stream = .{};
    stream.block_header(true, .fixed);
    stream.fixed_literal('a');
    stream.fixed_literal('b');
    stream.fixed_pair(4, 3);
    stream.fixed_literal(constants.end_of_block);
    const marker = 0x5a;
    var decoder: Decoder = undefined;
    @memset(std.mem.asBytes(&decoder), marker);
    deflate.init(&decoder, .{});
    var output: [16]u8 = @splat(0);
    try testing.expectError(error.DistanceTooFar, deflate.decode(&decoder, stream.slice(), &output));
    try testing.expect(std.mem.indexOfScalar(u8, &output, marker) == null);
    try expect_refused(stream.slice(), error.DistanceTooFar);
}

/// The literals before the pair that reaches back past a container's window.
const literals_before_pair = 300;

/// A fixed block of `literals_before_pair` literals, then a shortest match at `distance`.
fn literals_then_pair(stream: *Stream, distance: u16) void {
    stream.block_header(true, .fixed);
    for (0..literals_before_pair) |_| stream.fixed_literal('a');
    stream.fixed_pair(constants.match_len_min, distance);
    stream.fixed_literal(constants.end_of_block);
}

test "a distance past the window a container declares is refused, and one at its edge is not" {
    var decoder: Decoder = undefined;
    var output: [output_len_max]u8 = undefined;
    var at_edge: Stream = .{};
    literals_then_pair(&at_edge, 256);
    deflate.init(&decoder, .{});
    deflate.limit_window(&decoder, 256);
    const progress = try deflate.decode(&decoder, at_edge.slice(), &output);
    try testing.expectEqual(codec.Status.done, progress.status);
    try testing.expectEqual(303, progress.written);
    var past_edge: Stream = .{};
    literals_then_pair(&past_edge, 257);
    deflate.init(&decoder, .{});
    deflate.limit_window(&decoder, 256);
    try testing.expectError(error.DistanceTooFar, deflate.decode(&decoder, past_edge.slice(), &output));
    // Without the limit, the whole window is in reach.
    deflate.init(&decoder, .{});
    try testing.expectEqual(codec.Status.done, (try deflate.decode(&decoder, past_edge.slice(), &output)).status);
}

test "a distance of 32,768, the whole window, is in reach without a limit (RFC 1951 section 3.3)" {
    // A stored block of a window's octets, not the last: BFINAL 0 and BTYPE 00, padded to the
    // octet, then LEN and NLEN.
    const stored_header_len = 5;
    var input: [stored_header_len + constants.window_len + 8]u8 = undefined;
    input[0] = 0;
    std.mem.writeInt(u16, input[1..3], constants.window_len, .little);
    std.mem.writeInt(u16, input[3..5], ~@as(u16, constants.window_len), .little);
    for (input[stored_header_len..][0..constants.window_len], 0..) |*octet, index| octet.* = @truncate(index *% 7);
    var tail: Stream = .{};
    tail.block_header(true, .fixed);
    tail.fixed_pair(3, constants.window_len);
    tail.fixed_literal(constants.end_of_block);
    const input_len = stored_header_len + constants.window_len + tail.slice().len;
    @memcpy(input[stored_header_len + constants.window_len .. input_len], tail.slice());
    var decoder: Decoder = undefined;
    deflate.init(&decoder, .{});
    var output: [constants.window_len + 3]u8 = undefined;
    const progress = try deflate.decode(&decoder, input[0..input_len], &output);
    try testing.expectEqual(codec.Status.done, progress.status);
    try testing.expectEqual(output.len, progress.written);
    try testing.expectEqualSlices(u8, output[0..3], output[constants.window_len..]);
}

test {
    _ = @import("decoder_dynamic_test.zig");
    _ = @import("decoder_fuzz_test.zig");
    _ = @import("decoder_work_test.zig");
}
