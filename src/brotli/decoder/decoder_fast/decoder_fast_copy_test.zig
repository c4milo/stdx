//! The fast path's copies (decision 16, S4): a copy of each kind, at a distance its steps do not
//! divide, from octets that repeat only at that distance, decoded into every room up to two margins
//! past its end, so that the loop takes it in the rooms that hold its margin, with octets past the
//! room that nothing may write.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const decoder_module = @import("../decoder.zig");
const fast = @import("decoder_fast.zig");
const constants = @import("../../constants.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;

/// NPOSTFIX 3 and NDIRECT's high bits 13: 104 direct codes, 16 to 119, the distances 1 to 104
/// (RFC 7932 §4), and the alphabet they give.
const postfix_three = 3;
const direct_high_thirteen = 13;
const direct_codes_first = constants.distance_short_codes_count - 1;
const distance_alphabet_len = constants.distance_short_codes_count + (direct_high_thirteen << postfix_three) + (constants.distance_code_groups << postfix_three);

/// A copy's length, and the insert-and-copy symbol and copy code that give it: insert code 0, in the
/// cell of insert codes 0 to 7 and copy codes 16 to 23 (RFC 7932 §5), a command of no literals
/// whose copy takes a distance code.
const Copy = struct { len: u16, symbol: u16, code: u8 };

/// The octets the pattern takes: each differs from those within `distance_max` of it.
const pattern_step = 37;
const pattern_start = 11;
const pattern_modulus = 251;

/// The rooms past the copy's end, and past the room an octet no pattern holds, each over two
/// margins, more than a command writes.
const sentinel = 0xff;
const margins = 2;
const past_len = margins * fast.output_margin;

const distance_max = 100;
const copy_len_max = 961;

fn pattern_octet(index: usize) u8 {
    return @intCast((index * pattern_step + pattern_start) % pattern_modulus);
}

/// The stream: an uncompressed `distance` octets of the pattern, then a meta-block of one command,
/// the copy from `distance` back.
fn copy_stream(stream: *Stream, distance: u8, copy: Copy) void {
    var pattern: [distance_max]u8 = undefined;
    for (pattern[0..distance], 0..) |*octet, index| octet.* = pattern_octet(index);
    stream.window_bits_16();
    stream.uncompressed(pattern[0..distance]);
    stream.meta_block(true, copy.len);
    stream.simple_header(postfix_three, direct_high_thirteen, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{0}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{copy.symbol}, false);
    stream.simple_code(distance_alphabet_len, &.{direct_codes_first + distance}, false);
    const code = constants.copy_length_codes[copy.code];
    stream.put(copy.len - code.base, code.extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (test_stream.trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

/// The stream: an uncompressed `distance` octets of the pattern, then a meta-block of `count`
/// commands, each a copy of 2 from `distance` back, of no bits: symbol 128, insert code 0 and copy
/// code 0 in the cell of explicit distances (RFC 7932 §5), and one direct code. A copy at a distance
/// of a chunk or more stores two chunks whatever its length, the most past its length.
fn short_copies_stream(stream: *Stream, distance: u8, count: u32) void {
    var pattern: [distance_max]u8 = undefined;
    for (pattern[0..distance], 0..) |*octet, index| octet.* = pattern_octet(index);
    stream.window_bits_16();
    stream.uncompressed(pattern[0..distance]);
    stream.meta_block(true, count * short_copy_len);
    stream.simple_header(postfix_three, direct_high_thirteen, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{0}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{short_copy_symbol}, false);
    stream.simple_code(distance_alphabet_len, &.{direct_codes_first + distance}, false);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (test_stream.trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}
const short_copy_symbol = 128;
const short_copy_len = 2;
const short_copies_count = 200;

fn check_rooms(distance: u8, copy: Copy) !void {
    var stream: Stream = .{};
    copy_stream(&stream, distance, copy);
    try check_stream_rooms(stream.written(), distance, distance + copy.len);
}

/// Decodes `input`, `len` octets of the pattern repeated every `distance`, into every room up to two
/// margins past its end, each followed by octets that nothing may write.
fn check_stream_rooms(input: []const u8, distance: u8, len: usize) !void {
    var expected: [distance_max + copy_len_max]u8 = undefined;
    for (expected[0..len], 0..) |*octet, index| octet.* = pattern_octet(index % distance);
    var output: [distance_max + copy_len_max + past_len + past_len]u8 = undefined;
    for (0..len + past_len + 1) |room| {
        @memset(&output, sentinel);
        var decoder: Decoder = undefined;
        decoder.init(codec.Features.detect());
        const progress = try decoder.decode(input, output[0..room]);
        const written = @min(room, len);
        try testing.expectEqual(written, progress.written);
        try testing.expectEqualSlices(u8, expected[0..written], output[0..written]);
        for (output[room..]) |octet| try testing.expectEqual(sentinel, octet);
        if (room >= len) try testing.expectEqual(.done, progress.status);
    }
}

test "short copies at a distance of chunks write nothing past any room, each checked as it comes" {
    var stream: Stream = .{};
    short_copies_stream(&stream, distance_max, short_copies_count);
    try check_stream_rooms(stream.written(), distance_max, distance_max + short_copies_count * short_copy_len);
}

test "a copy of each kind writes its octets into every room, and nothing past it" {
    // A distance for each kind of copy: an octet at a time, a fill, words of 8, and chunks of 16 at
    // three distances.
    const distances = [_]u8{ 5, 1, 12, 20, 40, 100 };
    // A copy within a chunk, of copy code 18 (134 and 6 extra bits), and one past it, of copy code
    // 21 (582 and 9 extra bits): each a whole number of chunks and an octet, so that the last
    // chunk stores the most past the copy's end.
    const copies = [_]Copy{ .{ .len = 193, .symbol = 386, .code = 18 }, .{ .len = copy_len_max, .symbol = 389, .code = 21 } };
    for (distances) |distance| {
        for (copies) |copy| try check_rooms(distance, copy);
    }
}
