//! Tests of the fast path's match copies at every distance to 256 and at lengths on each side of
//! the copies' chunks, through combined entries (S11) and plain ones, whole and with each call's
//! output in a buffer of its own, against the checked path and the octets the pairs stand for
//! (RFC 1951 §3.2.3).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const deflate = @import("decoder.zig");
const decoder_test = @import("decoder_test.zig");
const Stream = decoder_test.Stream;
const Dynamic = @import("decoder_dynamic_test.zig").Dynamic;
const test_stream = @import("../test_stream.zig");

/// The block's codes, both complete: 31 literal/length symbols of 5 bits, then one of each length
/// from 6 to 10 bits and two of 11, whose longest makes the table 11 bits wide; and 16 distance
/// symbols of 4 bits. A length of 34 or less takes 7 bits with its extra bits, which leave a
/// distance's code room in the table, so its entry combines; a longer one's does not.
const literal_bits = 5;
const distance_bits = 4;
const literals = "abcdefghijklmnop";
const long_literals = "pqrstuv";
const long_literal_bits = [long_literals.len]u8{ 6, 7, 8, 9, 10, 11, 11 };
const length_symbols = [_]u16{ 257, 258, 262, 265, 267, 268, 270, 272, 273, 274, 276, 279, 282, 284, 285 };
const distance_symbols = 16;

/// Lengths on each side of the copies' chunks of 16 octets and of each code's range.
const lens = [_]u16{ 3, 4, 8, 11, 12, 15, 16, 17, 18, 23, 26, 31, 32, 33, 34, 35, 42, 43, 47, 48, 49, 50, 59, 64, 65, 66, 99, 114, 163, 194, 227, 257, 258 };

/// The distances each stream takes: every one to 64, then each code's first and last to 256.
const distances = distances: {
    var list: [64 + 8]u16 = undefined;
    for (list[0..64], 1..) |*distance, value| distance.* = value;
    list[64..].* = .{ 65, 96, 97, 128, 129, 192, 193, 256 };
    break :distances list;
};

/// The octets of history before the pairs, and the room past the output a decode leaves, so the
/// fast path's margins hold through the stream's end.
const history_len = 256;
const room_extra = 512;
const input_padding = 16;
const output_len_max = history_len + lens.len * (constants.match_len_max + 1);
const input_len_max = test_stream.stream_len_max + input_padding;

fn block() Dynamic {
    var dynamic: Dynamic = .{ .literal_count = constants.literal_length_used, .distance_count = distance_symbols };
    for (literals) |octet| dynamic.literal_lengths[octet] = literal_bits;
    for (long_literals, long_literal_bits) |octet, bits| dynamic.literal_lengths[octet] = bits;
    dynamic.literal_lengths[constants.end_of_block] = literal_bits;
    for (length_symbols) |symbol| dynamic.literal_lengths[symbol] = literal_bits;
    for (dynamic.distance_lengths[0..distance_symbols]) |*len| len.* = distance_bits;
    return dynamic;
}

/// A stream of one block: the history, then a pair of each length at `distance`, each followed
/// by a literal; and the octets it stands for, into `expected`, whose length it returns.
fn stream_of(stream: *Stream, distance: u16, expected: *[output_len_max]u8) usize {
    const dynamic = block();
    dynamic.header(stream, true);
    var len: usize = 0;
    for (0..history_len) |index| {
        expected[len] = literals[(index * 7 + index / literals.len) % literals.len];
        dynamic.literal(stream, expected[len]);
        len += 1;
    }
    for (lens, 0..) |pair_len, index| {
        dynamic.pair(stream, pair_len, distance);
        for (0..pair_len) |_| {
            expected[len] = expected[len - distance];
            len += 1;
        }
        expected[len] = literals[index % literals.len];
        dynamic.literal(stream, expected[len]);
        len += 1;
    }
    dynamic.literal(stream, constants.end_of_block);
    return len;
}

/// The stream's octets with padding after them, so the input margin holds at its end.
fn padded(stream: *const Stream, buffer: []u8) []const u8 {
    const input = stream.slice();
    @memcpy(buffer[0..input.len], input);
    @memset(buffer[input.len..][0..input_padding], 0);
    return buffer[0 .. input.len + input_padding];
}

/// Decodes `input` in one call with `options` into room past `expected`, and requires its octets.
fn expect_whole(comptime options: deflate.Options, input: []const u8, expected: []const u8) !void {
    var decoder: deflate.Decoder = undefined;
    deflate.init(&decoder, .{});
    var output: [output_len_max + room_extra]u8 = undefined;
    const progress = try deflate.decode_with(options, &decoder, input, &output);
    try testing.expectEqual(codec.Status.done, progress.status);
    try testing.expectEqualSlices(u8, expected, output[0..progress.written]);
}

test "every distance to 256 copies each length as the checked path does, combined and plain" {
    for (distances) |distance| {
        var stream: Stream = .{};
        var expected: [output_len_max]u8 = undefined;
        const len = stream_of(&stream, distance, &expected);
        var buffer: [input_len_max]u8 = undefined;
        const input = padded(&stream, &buffer);
        try expect_whole(.{}, input, expected[0..len]);
        try expect_whole(decoder_test.combining, input, expected[0..len]);
        try expect_whole(.{ .fast_paths = false }, input, expected[0..len]);
    }
}

/// Decodes `input` in calls whose output goes to a buffer of the call's own, of a room a seed
/// draws, and requires the octets the calls append together to be `expected`.
fn expect_separate_buffers(comptime options: deflate.Options, input: []const u8, expected: []const u8, seed: u64) !void {
    var decoder: deflate.Decoder = undefined;
    deflate.init(&decoder, .{});
    var generator = codec.split.Generator.init(seed);
    var joined: [output_len_max]u8 = undefined;
    var joined_len: usize = 0;
    var consumed: usize = 0;
    // Each call before the last writes at least `room_min` octets, and the stream's octets bound
    // the calls.
    const room_min = 300;
    for (0..expected.len / room_min + 2) |_| {
        var own: [room_min * 2]u8 = @splat(0);
        const room = room_min + @as(usize, @intCast(generator.below(room_min)));
        const progress = try deflate.decode_with(options, &decoder, input[consumed..], own[0..room]);
        @memcpy(joined[joined_len..][0..progress.written], own[0..progress.written]);
        joined_len += progress.written;
        consumed += progress.consumed;
        if (progress.status == .done) break;
    } else return error.TestUnexpectedResult;
    try testing.expectEqualSlices(u8, expected, joined[0..joined_len]);
}

test "a match that reaches before a call's own output takes the window's octets" {
    const seeds = 4;
    for (distances) |distance| {
        var stream: Stream = .{};
        var expected: [output_len_max]u8 = undefined;
        const len = stream_of(&stream, distance, &expected);
        var buffer: [input_len_max]u8 = undefined;
        const input = padded(&stream, &buffer);
        for (0..seeds) |seed| {
            try expect_separate_buffers(.{}, input, expected[0..len], seed);
            try expect_separate_buffers(decoder_test.combining, input, expected[0..len], seed);
        }
    }
}
