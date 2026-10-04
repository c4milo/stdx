//! The distance codes of the largest distance alphabet, NPOSTFIX 3 and NDIRECT 120 (RFC 7932 §4),
//! in the fast path's loops and on the checked path: the code a distance table's entry holds in 10
//! bits, and the count of the code's extra bits above it.

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
const output_len = 1 << test_window_bits;

/// NPOSTFIX 3 and NDIRECT 120: 16 short codes, 120 direct ones and 48 << 3 coded ones, 520 codes.
const postfix_bits = 3;
const direct_high = 15;
const direct_count = direct_high << postfix_bits;
const coded_first = constants.distance_short_codes_count + direct_count;
const alphabet_len = coded_first + (constants.distance_code_groups << postfix_bits);

/// Symbol 130: no literals, and a copy of 4 at an explicit distance (RFC 7932 §5).
const copy_symbol = 130;
const copy_len = 4;

/// The octets before the commands, each unlike the one 120, 121 or 129 before it.
const history_len = 160;
const history_step = 7;

/// The last direct code, the distance NDIRECT, of no extra bits; and the first coded code, of one
/// extra bit: the distances NDIRECT + 1 and NDIRECT + 1 + (1 << NPOSTFIX).
const last_direct_code = coded_first - 1;
const first_coded_extra_bits = 1;
const distances = [_]u32{ direct_count, direct_count + 1, direct_count + 1 + (1 << postfix_bits) };

/// A code past 511, of 24 extra bits: its distance is past every window and every dictionary word.
const far_code = 512;
const far_extra_bits = 24;
const far_extra = 0x800001;

/// The stream's start: the history, then a last meta-block of `len` octets whose commands are
/// symbol 130 alone, with the distance codes `codes` in a simple code.
fn start(stream: *Stream, history: []const u8, len: u32, codes: []const u16) void {
    stream.window_bits_16();
    stream.uncompressed(history);
    stream.meta_block(true, len);
    stream.simple_header(postfix_bits, direct_high, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{copy_symbol}, false);
    stream.simple_code(alphabet_len, codes, false);
}

fn finish(stream: *Stream) void {
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "the last direct distance code takes no extra bits and the first coded one takes one, in the loop and on the checked path" {
    try testing.expectEqual(constants.distance_alphabet_len_max, alphabet_len);
    var history: [history_len]u8 = undefined;
    for (&history, 0..) |*octet, index| octet.* = @truncate(index * history_step);
    var stream: Stream = .{};
    // The last direct code takes the code 0 and the first coded code the code 1.
    start(&stream, &history, distances.len * copy_len, &.{ last_direct_code, coded_first });
    stream.put_code(0, 1);
    stream.put_code(1, 1);
    stream.put(0, first_coded_extra_bits);
    stream.put_code(1, 1);
    stream.put(1, first_coded_extra_bits);
    finish(&stream);
    var expected: [history_len + distances.len * copy_len]u8 = undefined;
    @memcpy(expected[0..history_len], &history);
    for (distances, 0..) |distance, command| {
        const at = history_len + command * copy_len;
        for (at..at + copy_len) |octet| expected[octet] = expected[octet - distance];
    }
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

test "a distance code past 511 keeps its ten bits: the loop refuses its distance as the checked path does" {
    try testing.expect(far_code < alphabet_len);
    const history: [history_len]u8 = @splat('h');
    var stream: Stream = .{};
    start(&stream, &history, copy_len, &.{far_code});
    // The code's one symbol takes no bits: the stream holds its extra bits alone.
    stream.put(far_extra, far_extra_bits);
    finish(&stream);
    var output: [output_len]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    // RFC 7932 §8: a transform_id greater than 120 should be rejected as invalid. The code less its
    // tenth bit is the code 0, the last distance, which the history holds.
    try testing.expectError(error.InvalidDictionaryReference, decoder.decode_all(stream.written(), &output));
    var checked: CheckedDecoder = undefined;
    checked.init(codec.Features.detect());
    try testing.expectError(error.InvalidDictionaryReference, checked.decode_all(stream.written(), &output));
}
