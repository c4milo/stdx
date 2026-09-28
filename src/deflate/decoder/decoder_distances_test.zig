//! Tests of the fast path's match copies at every distance to 256 and at lengths on each side of
//! the copies' chunks, through combined entries (S11) and plain ones, whole and with each call's
//! output in a buffer of its own, against the checked path and the octets the pairs stand for
//! (RFC 1951 §3.2.3). The decodes take the CPU's features, so they run the assembly of decision 29
//! wherever the CPU does.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const deflate = @import("decoder.zig");
const decoder_test = @import("decoder_test.zig");
const Stream = decoder_test.Stream;
const Dynamic = @import("decoder_dynamic_test.zig").Dynamic;
const test_stream = @import("../test_stream.zig");

/// The block's codes, both complete: 63 literal/length symbols of 6 bits, every length and the end
/// of the block among them, then one each of 7 to 10 bits and two of 11, whose longest makes the
/// table 11 bits wide; and 16 distance symbols of 4 bits. A length of 18 or less takes 7 bits with
/// its extra bits, which leave a distance's code room in the table, so its entry combines; a longer
/// one's does not.
const literal_bits = 6;
const distance_bits = 4;
const distance_symbols = 16;
const literals = "abcdefghijklmnopqrstuvwxyzABCDEFG";
const long_literals = "HIJKLM";

/// The distances a stream takes one by one, from 1; past them, each code's first and last, its
/// two ends.
const near_distances = 64;
const code_ends = 2;
const distances_max = near_distances + code_ends * distance_symbols;

/// The octets of history before the pairs, a stride through the literals that varies them, and
/// the room past the output a decode leaves, so the fast path's margins hold through the end.
const history_len = 256;
const history_stride = 7;
const room_extra = 512;
const input_padding = 16;
/// The lengths a stream takes at most, and the octets its output and input hold at most.
const lens_max = 128;
const output_len_max = history_len + lens_max * (constants.match_len_max + 1);
const input_len_max = test_stream.stream_len_max + input_padding;
/// The room a call of `expect_separate_buffers` has, at least and at most, and its calls beyond one
/// per `room_min` octets: the history's, and the last, which may write fewer.
const room_min = 300;
const room_max = 600;
const calls_extra = 2;

fn block() Dynamic {
    var dynamic: Dynamic = .{ .literal_count = constants.literal_length_used, .distance_count = distance_symbols };
    for (literals) |octet| dynamic.literal_lengths[octet] = literal_bits;
    dynamic.literal_lengths[constants.end_of_block] = literal_bits;
    for (constants.first_length_symbol..constants.literal_length_used) |symbol| dynamic.literal_lengths[symbol] = literal_bits;
    // Each longer code takes half the room of the one before, and the last two share the last.
    for (long_literals, 0..) |octet, index| {
        dynamic.literal_lengths[octet] = @intCast(@min(literal_bits + 1 + index, constants.literal_length_table_bits));
    }
    for (dynamic.distance_lengths[0..distance_symbols]) |*len| len.* = distance_bits;
    return dynamic;
}

/// Each length code's first and last length, and each multiple of a chunk with the lengths
/// beside it, into `lens`, sorted, once each; returns how many.
fn lens_of(lens: *[lens_max]u16) usize {
    var taken: [constants.match_len_max + 1]bool = @splat(false);
    for (constants.length_base, constants.length_extra_bits) |base, extra_bits| {
        taken[base] = true;
        taken[@min(base + (@as(u16, 1) << @intCast(extra_bits)) - 1, constants.match_len_max)] = true;
    }
    var chunks: usize = constants.copy_chunk_len;
    while (chunks <= constants.match_len_max) : (chunks += constants.copy_chunk_len) {
        for (chunks - 1..@min(chunks + 1, constants.match_len_max) + 1) |len| taken[len] = true;
    }
    var count: usize = 0;
    for (taken, 0..) |is_taken, len| {
        if (!is_taken) continue;
        lens[count] = @intCast(len);
        count += 1;
    }
    return count;
}

/// The distances to test: every one to `near_distances`, then each code's first and last up to
/// the block's last distance symbol; returns how many.
fn distances_of(distances: *[distances_max]u16) usize {
    for (distances[0..near_distances], 1..) |*distance, value| distance.* = @intCast(value);
    var count: usize = near_distances;
    const first_far = test_stream.last_at_most(&constants.distance_base, near_distances) + 1;
    for (first_far..distance_symbols) |symbol| {
        distances[count] = constants.distance_base[symbol];
        distances[count + 1] = constants.distance_base[symbol + 1] - 1;
        count += code_ends;
    }
    return count;
}

/// A stream of one block: the history, then a pair of each of `lens` at `distance`, each followed
/// by a literal; and the octets it stands for, into `expected`, whose length it returns.
fn stream_of(stream: *Stream, lens: []const u16, distance: u16, expected: *[output_len_max]u8) usize {
    const dynamic = block();
    dynamic.header(stream, true);
    var len: usize = 0;
    for (0..history_len) |index| {
        expected[len] = literals[(index * history_stride + index / literals.len) % literals.len];
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
    deflate.init(&decoder, codec.Features.detect());
    var output: [output_len_max + room_extra]u8 = undefined;
    const progress = try deflate.decode_with(options, &decoder, input, &output);
    try testing.expectEqual(codec.Status.done, progress.status);
    try testing.expectEqualSlices(u8, expected, output[0..progress.written]);
}

/// Decodes `input` in calls whose output goes to a buffer of the call's own: the history alone
/// first, so the next call starts at the pairs, each of which reaches before the call's output,
/// then rooms a seed draws. Requires the octets the calls append together to be `expected`.
fn expect_separate_buffers(comptime options: deflate.Options, input: []const u8, expected: []const u8, seed: u64) !void {
    var decoder: deflate.Decoder = undefined;
    deflate.init(&decoder, codec.Features.detect());
    var generator = codec.split.Generator.init(seed);
    var joined: [output_len_max]u8 = undefined;
    var joined_len: usize = 0;
    var consumed: usize = 0;
    // Each call before the last fills its room, so the expected octets bound the calls.
    for (0..expected.len / room_min + calls_extra) |call| {
        var own: [room_max]u8 = @splat(0);
        const drawn = room_min + @as(usize, @intCast(generator.below(room_max - room_min)));
        const room = if (call == 0) history_len else drawn;
        const progress = try deflate.decode_with(options, &decoder, input[consumed..], own[0..room]);
        @memcpy(joined[joined_len..][0..progress.written], own[0..progress.written]);
        joined_len += progress.written;
        consumed += progress.consumed;
        if (progress.status == .done) break;
    } else return error.TestUnexpectedResult;
    try testing.expectEqualSlices(u8, expected, joined[0..joined_len]);
}

test "every distance to 256 copies each length as the checked path does, in one buffer and many" {
    var lens: [lens_max]u16 = undefined;
    const lens_len = lens_of(&lens);
    var distances: [distances_max]u16 = undefined;
    const seeds = 2;
    for (distances[0..distances_of(&distances)]) |distance| {
        var stream: Stream = .{};
        var expected: [output_len_max]u8 = undefined;
        const len = stream_of(&stream, lens[0..lens_len], distance, &expected);
        var buffer: [input_len_max]u8 = undefined;
        const input = padded(&stream, &buffer);
        try expect_whole(.{}, input, expected[0..len]);
        try expect_whole(decoder_test.combining, input, expected[0..len]);
        try expect_whole(.{ .fast_paths = false }, input, expected[0..len]);
        for (0..seeds) |seed| {
            try expect_separate_buffers(.{}, input, expected[0..len], seed);
            try expect_separate_buffers(decoder_test.combining, input, expected[0..len], seed);
        }
    }
}

test "RFC 1951 section 3.2.5: 258 from code 284 is refused where the fast path meets it" {
    // Code 284 and extra bits 31 after 300 octets of history, at a distance of each of the
    // copies: two chunks or more, one chunk to two, and below a chunk.
    const history = 300;
    for ([_]u16{ 100, 20, 5 }) |distance| {
        var stream: Stream = .{};
        stream.block_header(true, .fixed);
        for (0..history) |index| stream.fixed_literal(literals[index % literals.len]);
        stream.fixed_literal(constants.last_length_symbol - 1);
        stream.bits(std.math.maxInt(u5), 5);
        const distance_index = test_stream.last_at_most(&constants.distance_base, distance);
        stream.code(@intCast(distance_index), 5);
        stream.bits(distance - constants.distance_base[distance_index], constants.distance_extra_bits[distance_index]);
        stream.fixed_literal(constants.end_of_block);
        try decoder_test.expect_refused(stream.slice(), error.InvalidLength);
    }
}

test "a distance past the window a container declares is refused from combined and plain entries" {
    // A window of 128 octets, and pairs 200 back: a length of 17, whose entry combines, and one of
    // 100, whose entry does not.
    const window_len = 128;
    for ([_]u16{ 17, 100 }) |len| {
        var stream: Stream = .{};
        const dynamic = block();
        dynamic.header(&stream, true);
        for (0..history_len) |index| dynamic.literal(&stream, literals[index % literals.len]);
        dynamic.pair(&stream, len, 200);
        dynamic.literal(&stream, constants.end_of_block);
        var buffer: [input_len_max]u8 = undefined;
        const input = padded(&stream, &buffer);
        inline for (.{ deflate.Options{}, decoder_test.combining }) |options| {
            var decoder: deflate.Decoder = undefined;
            deflate.init(&decoder, codec.Features.detect());
            deflate.limit_window(&decoder, window_len);
            var output: [output_len_max + room_extra]u8 = undefined;
            try testing.expectError(error.DistanceTooFar, deflate.decode_with(options, &decoder, input, &output));
        }
    }
}
