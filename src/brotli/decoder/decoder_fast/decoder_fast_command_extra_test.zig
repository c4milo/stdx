//! A command whose insert length and copy length take 32 extra bits together (RFC 7932 §5), in the
//! fast path's loops and on the checked path: the count an insert-and-copy table's entry holds
//! above its symbol.

const std = @import("std");
const codec = @import("codec");
const testing = std.testing;
const decoder_module = @import("../decoder.zig");
const constants = @import("../../constants.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;
const trailer = test_stream.trailer;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const CheckedDecoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits, .paths = .{ .fast_paths = false } });
const test_window_bits = 16;

/// The octets before the command.
const history = "abcdefghijklmnop";

/// The insert length code 18, of 8 extra bits, and the copy length code 23, of 24 (RFC 7932 §5): the
/// symbol of the cell of the insert codes 16 to 23 and the copy codes 16 to 23, the alphabet's last
/// 64 symbols, which takes an explicit distance.
const insert_code = 18;
const copy_code = 23;
const cell_first_code = 16;
const cell_symbols = 1 << constants.insert_copy_cell_bits;
const cell_first_symbol = constants.insert_copy_alphabet_len - cell_symbols;
const symbol = cell_first_symbol + ((insert_code - cell_first_code) << constants.insert_copy_code_bits) + (copy_code - cell_first_code);
const extra_bits_wanted = 32;

/// The extra bits' values: the insert length's with its highest bit set, and the copy length's as
/// high as a meta-block of 4 nibbles holds, so that a count a bit short reads other lengths.
const insert_extra = 0x95;
const copy_extra = 0x8005;

/// A distance alphabet of NPOSTFIX 0 and NDIRECT 0 (RFC 7932 §4), whose code 0 is the last distance,
/// 4 at a stream's start.
const distance_alphabet_len = constants.distance_short_codes_count + constants.distance_code_groups;
const last_distance_code = 0;
const output_len = 1 << test_window_bits;

test "a command takes the 32 extra bits its codes give, in the loop and on the checked path" {
    const insert = constants.insert_length_codes[insert_code];
    const copy = constants.copy_length_codes[copy_code];
    try testing.expectEqual(extra_bits_wanted, @as(u32, insert.extra_bits) + copy.extra_bits);
    const insert_len: u32 = insert.base + insert_extra;
    const copy_len: u32 = copy.base + copy_extra;
    var stream: Stream = .{};
    stream.window_bits_16();
    stream.uncompressed(history);
    stream.meta_block(true, insert_len + copy_len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{symbol}, false);
    stream.simple_code(distance_alphabet_len, &.{last_distance_code}, false);
    // Each code holds one symbol, of no bits: the stream holds the command's extra bits alone.
    stream.put(insert_extra, insert.extra_bits);
    stream.put(copy_extra, copy.extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
    // The literals, then a copy of them from the last distance.
    var expected: [history.len + insert.base + insert_extra + copy.base + copy_extra]u8 = @splat('q');
    @memcpy(expected[0..history.len], history);
    var output: [output_len]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqualSlices(u8, &expected, output[0..whole.written]);
    var checked_output: [output_len]u8 = undefined;
    var checked: CheckedDecoder = undefined;
    checked.init(codec.Features.detect());
    const checked_whole = try checked.decode_all(stream.written(), &checked_output);
    try testing.expectEqualSlices(u8, &expected, checked_output[0..checked_whole.written]);
}
