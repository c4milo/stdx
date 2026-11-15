//! The tests of the brotli IoReader, the octets given in parts, over the module's fixtures.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const io = @import("io.zig");

const io_parts = codec.testing.io_parts;

/// A window of 2^18 octets, so the test's reader fits its stack.
const test_window_bits = 18;
const TestReader = io.IoReader(.{ .window_bits_max = test_window_bits });

const coded = @embedFile("fixtures/text-q5-w16.br");
const plain = @embedFile("fixtures/text.txt");

test "a brotli IoReader decodes a stream given in parts" {
    var output: [plain.len]u8 = undefined;
    for ([_]usize{ 1, 7, 100 }) |part_len| {
        var source_buffer: [11]u8 = undefined;
        var source: io_parts.PartSource = undefined;
        source.init(coded, 0, &source_buffer);
        var reader: TestReader = undefined;
        reader.init(&source.interface, &.{}, .{});
        try testing.expectEqualSlices(u8, plain, try io_parts.read_in_parts(&reader, &source, part_len, .limited(part_len * 3), &output));
    }
}

test "a brotli IoReader refuses a stream its source ends inside, and octets after it" {
    var output: [plain.len]u8 = undefined;
    try io_parts.expect_failure(TestReader, coded[0 .. coded.len - 1], error.Truncated, &output);
    try io_parts.expect_failure(TestReader, coded ++ "\x00", error.TrailingOctets, &output);
}

const encoder = @import("encoder/encoder.zig");

/// The text the writer's tests code, and the room they give the destination at each failure.
const text_len = 6000;
const room_part_len = 7;
/// The room the tests give a stream, a multiple of its input's octets: a stream takes fewer.
const stream_room_factor = 2;
/// The writer's buffer and the destination's: small, so a write takes several calls.
const writer_buffer_len = 61;
const destination_buffer_len = 29;

// Level 5's writer and the reader take 6 MiB together, past what a test's stack is sure to hold:
// the round trip runs at level 1, and the next test holds level 5 to `encode_all`.
test "a brotli stream round-trips through the IoWriter and the IoReader" {
    var plain_buffer: [text_len]u8 = undefined;
    const text = io_parts.fill_text(&plain_buffer);
    var storage: [stream_room_factor * text_len]u8 = undefined;
    var output: [text_len]u8 = undefined;
    const Writer = io.IoWriter(.{ .level = 1, .window_bits = test_window_bits });
    const stream = try @call(.never_inline, io_parts.expect_round_trip, .{ Writer, TestReader, text, &storage, &output });
    try testing.expect(stream.len < text.len);
}

test "the brotli IoWriter writes the octets encode_all writes, the room given in parts" {
    var plain_buffer: [text_len]u8 = undefined;
    const text = io_parts.fill_text(&plain_buffer);
    inline for (.{ 1, 5 }) |level| {
        const options: encoder.EncoderOptions = .{ .level = level, .window_bits = test_window_bits };
        var whole: [stream_room_factor * text_len]u8 = undefined;
        var parts: [stream_room_factor * text_len]u8 = undefined;
        const whole_len = try @call(.never_inline, encode_whole, .{ options, text, &whole });
        const parts_len = try @call(.never_inline, encode_in_parts, .{ options, text, &parts });
        try testing.expectEqualSlices(u8, whole[0..whole_len], parts[0..parts_len]);
    }
}

/// The stream `encode_all` writes for `text`, in one call.
fn encode_whole(comptime options: encoder.EncoderOptions, text: []const u8, storage: []u8) !usize {
    var state: encoder.Encoder(options) = undefined;
    state.init(.{});
    return state.encode_all(text, storage);
}

/// The stream the IoWriter writes for `text`, the text and the room given in parts, and no flush
/// before `finish`.
fn encode_in_parts(comptime options: encoder.EncoderOptions, text: []const u8, storage: []u8) !usize {
    var destination_buffer: [destination_buffer_len]u8 = undefined;
    var destination: io_parts.RoomDestination = undefined;
    destination.init(storage, 0, &destination_buffer);
    var writer_buffer: [writer_buffer_len]u8 = undefined;
    var writer: io.IoWriter(options) = undefined;
    writer.init(&destination.interface, &writer_buffer, .{});
    try io_parts.write_in_parts(&writer, &destination, text, room_part_len);
    try io_parts.end_in_parts(&writer, &destination, true, room_part_len);
    return destination.written_len;
}

/// Octets that do not compress: a flush writes all that the encoder holds back of them, as
/// uncompressed meta-blocks. The destination has room for all of them, so one call of the flush
/// writes them, in parts of the destination's buffer.
const random_len = 65_000;
const random_seed = 79;

test "a brotli IoWriter's flush writes every octet the encoder holds back" {
    try @call(.never_inline, expect_flush_whole, .{});
}

/// Random octets written, then a flush: the octets written so far decode to all of them.
fn expect_flush_whole() !void {
    var random: [random_len]u8 = undefined;
    var generator = codec.testing.split.Generator.init(random_seed);
    for (&random) |*octet| octet.* = @truncate(generator.next());
    var storage: [stream_room_factor * random_len]u8 = undefined;
    var destination_buffer: [destination_buffer_len]u8 = undefined;
    var destination: io_parts.RoomDestination = undefined;
    destination.init(&storage, storage.len, &destination_buffer);
    var writer: io.IoWriter(.{ .level = 1 }) = undefined;
    writer.init(&destination.interface, &.{}, .{});
    try io_parts.write_in_parts(&writer, &destination, &random, room_part_len);
    try io_parts.end_in_parts(&writer, &destination, false, room_part_len);
    var output: [random_len]u8 = undefined;
    var source_buffer: [destination_buffer_len]u8 = undefined;
    var source: io_parts.PartSource = undefined;
    source.init(&storage, destination.written_len, &source_buffer);
    var reader: TestReader = undefined;
    reader.init(&source.interface, &.{}, .{});
    try testing.expectEqualSlices(u8, &random, try io_parts.read_in_parts(&reader, &source, 0, .unlimited, &output));
}
