//! The fast path's margins (decision 16): a long copy decoded into every room up to its length, so
//! that an iteration starts at every room the output margin allows, and writes nothing past it.

const std = @import("std");
const testing = std.testing;
const decoder_module = @import("decoder.zig");
const constants = @import("../constants.zig");
const Stream = @import("test_stream.zig").Stream;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;

/// The pattern the stream's literals write, and the copy that repeats it from 16 octets back, the
/// fourth last distance the ring starts with (RFC 7932 §4).
const pattern = "abcdabcdabcdabcd";
const copy_len = 1000;
const fourth_last_distance_code = 3;

/// The insert-and-copy symbol 525, in the cell of insert codes 8 to 15 and copy codes 16 to 23:
/// insert code 9, 14 and 2 extra bits, and copy code 21, 582 and 9 extra bits (RFC 7932 §5).
const long_copy_symbol = 525;
const insert_code = 9;
const long_copy_code = 21;

/// Octets after the stream, so that the input's margin holds to the stream's end: a refill reads 8
/// octets past the bits it takes.
const trailer = "octets after the stream.";

/// A simple code of four symbols gives each 2 bits (RFC 7932 §3.4).
const literal_code_bits = 2;

/// The stream: `pattern`'s literals, each of a 2-bit code, and a copy of `copy_len` octets 16 back.
fn long_copy_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, pattern.len + copy_len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{ 'a', 'b', 'c', 'd' }, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{long_copy_symbol}, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{fourth_last_distance_code}, false);
    const insert = constants.insert_length_codes[insert_code];
    const copy = constants.copy_length_codes[long_copy_code];
    stream.put(pattern.len - insert.base, insert.extra_bits);
    stream.put(copy_len - copy.base, copy.extra_bits);
    // The four literals' codes are 00, 01, 10 and 11, in the order of their symbols.
    for (pattern) |literal| stream.put_code(literal - pattern[0], literal_code_bits);
    const end = stream.bit_len;
    stream.bit_len = std.mem.alignForward(usize, end, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a long copy writes nothing past any room it is decoded into" {
    var stream: Stream = .{};
    long_copy_stream(&stream);
    const input = stream.written();
    var expected: [pattern.len + copy_len]u8 = undefined;
    for (&expected, 0..) |*octet, index| octet.* = pattern[index % pattern.len];
    var output: [expected.len]u8 = undefined;
    for (0..expected.len + 1) |room| {
        var decoder: Decoder = undefined;
        decoder.init(.{});
        const progress = try decoder.decode(input, output[0..room]);
        try testing.expectEqual(room, progress.written);
        try testing.expectEqualSlices(u8, expected[0..room], output[0..room]);
        if (room == expected.len) {
            try testing.expectEqual(.done, progress.status);
            try testing.expectEqual(input.len - trailer.len, progress.consumed);
        }
    }
}
