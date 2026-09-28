//! The fast path's margins (decision 16): a long copy decoded into every room up to its length, so
//! that an iteration starts at every room the output margin allows, and writes nothing past it.

const std = @import("std");
const testing = std.testing;
const decoder_module = @import("decoder.zig");
const constants = @import("../constants.zig");
const test_stream = @import("test_stream.zig");
const Stream = test_stream.Stream;

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

/// The second stream's first meta-block: 16 literals, `pattern`, in a command of insert code 9 and
/// copy code 0 (the symbol 264), whose copy the meta-block's end cuts off (RFC 7932 §9.3).
const insert_16_symbol = 264;

/// Its last meta-block copies 100 octets from 19 back, before the call that decodes it: copy code
/// 16, 70 and 5 extra bits, with insert code 0 (the symbol 384); NPOSTFIX 1 and NDIRECT 20, whose
/// direct code 34 is the distance 19 (RFC 7932 §4, §5).
const reaching_copy_len = 100;
const reaching_copy_symbol = 384;
const reaching_copy_code = 16;
const postfix_one = 1;
const direct_high_twenty = 10;
const distance_19_code = 34;
const direct_alphabet_len = constants.distance_short_codes_count + (direct_high_twenty << postfix_one) + (constants.distance_code_groups << postfix_one);

/// Literals, then an uncompressed meta-block, then a copy that reaches past both: the call that
/// takes the copy writes the uncompressed octets first, on the checked path, so the fast path
/// starts with octets of that call behind it and the copy's source before them.
fn reaching_copy_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(false, pattern.len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{ 'a', 'b', 'c', 'd' }, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{insert_16_symbol}, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{0}, false);
    const insert = constants.insert_length_codes[insert_code];
    stream.put(pattern.len - insert.base, insert.extra_bits);
    for (pattern) |literal| stream.put_code(literal - pattern[0], literal_code_bits);
    stream.uncompressed("xyz");
    stream.meta_block(true, reaching_copy_len);
    stream.simple_header(postfix_one, direct_high_twenty, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{reaching_copy_symbol}, false);
    stream.simple_code(direct_alphabet_len, &.{distance_19_code}, false);
    const copy = constants.copy_length_codes[reaching_copy_code];
    stream.put(reaching_copy_len - copy.base, copy.extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a copy the fast path takes after checked octets reads what came before the call" {
    var stream: Stream = .{};
    reaching_copy_stream(&stream);
    const input = stream.written();
    const history = pattern ++ "xyz";
    var expected: [history.len + reaching_copy_len]u8 = undefined;
    for (&expected, 0..) |*octet, index| octet.* = history[index % history.len];
    // Room past the stream's octets, so that the fast path's margin holds for the copy.
    var output: [1024]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const first = try decoder.decode(input, output[0..pattern.len]);
    try testing.expectEqual(.needs_room, first.status);
    try testing.expectEqual(pattern.len, first.written);
    const rest = try decoder.decode(input[first.consumed..], output[pattern.len..]);
    try testing.expectEqual(.done, rest.status);
    try testing.expectEqualSlices(u8, &expected, output[0..expected.len]);
}

/// A complex code whose symbols `first` and the one after it take 15 bits: code lengths 1 to 14
/// for the symbols 0 to 13, zeros to `first`, then 15 twice (RFC 7932 §3.5). Its code length code
/// gives 4 bits to each of the lengths 1 to 15 and to the repeat of zeros, and none to the length 0
/// or to the repeat of the previous length, in its order from HSKIP 0; the zeros come in repeats
/// that compound (`zero_repeats`).
const skewed_code_length_len = 4;
const long_code_lengths_of_lengths = lengths: {
    var lengths: [constants.code_length_alphabet_len]u8 = @splat(skewed_code_length_len);
    for (constants.code_length_code_order, 0..) |symbol, place| {
        if (symbol == 0 or symbol == constants.repeat_previous_symbol) lengths[place] = 0;
    }
    break :lengths lengths;
};
const skewed_len_max = constants.code_len_max - 1;

/// The two longest codes a skewed code ends with.
const longest_codes = 2;

/// The code lengths of a skewed code: `len_max` symbols of lengths 1 to 14, then `zeros`, then the
/// two longest codes.
fn skewed_lengths(lengths: []u8, first: usize) void {
    @memset(lengths, 0);
    for (lengths[0..skewed_len_max], 1..) |*len, value| len.* = @intCast(value);
    lengths[first] = constants.code_len_max;
    lengths[first + 1] = constants.code_len_max;
}

/// The code length symbols of a skewed code, the zeros in `repeats`.
fn put_skewed_code(stream: *Stream, repeats: []const test_stream.LengthSymbol) void {
    var symbols: [skewed_len_max + zero_repeats_max + longest_codes]test_stream.LengthSymbol = undefined;
    for (symbols[0..skewed_len_max], 1..) |*symbol, len| symbol.* = .{ .symbol = @intCast(len) };
    @memcpy(symbols[skewed_len_max..][0..repeats.len], repeats);
    const tail = skewed_len_max + repeats.len;
    symbols[tail] = .{ .symbol = constants.code_len_max };
    symbols[tail + 1] = .{ .symbol = constants.code_len_max };
    stream.complex_code(0, &long_code_lengths_of_lengths, symbols[0 .. tail + longest_codes]);
}

/// The most repeats of zeros a skewed code takes, and the ones each takes: 377 zeros to the
/// insert-and-copy symbol 391, 7, then 8 * 5 + 3 + 5 = 48, then 8 * 46 + 3 + 6 = 377; and 20 to
/// the distance code 34, 4, then 8 * 2 + 3 + 1 = 20 (RFC 7932 §3.5).
const zero_repeats_max = 3;
const insert_copy_zero_extras = [_]u8{ first_zeros_extra, second_zeros_extra, third_zeros_extra };
const first_zeros_extra = 4;
const second_zeros_extra = 5;
const third_zeros_extra = 6;
const distance_zero_extras = [_]u8{ 1, 1 };

fn zero_repeats(extras: []const u8, repeats: *[zero_repeats_max]test_stream.LengthSymbol) []const test_stream.LengthSymbol {
    for (extras, 0..) |extra, index| repeats[index] = .{ .symbol = constants.repeat_zero_symbol, .extra = extra };
    return repeats[0..extras.len];
}

/// The long command: insert-and-copy symbol 391, insert length 0 and copy code 23, 2118 and 24
/// extra bits; distance code 34 with NPOSTFIX 0 and NDIRECT 0, 2045 and 10 extra bits (RFC 7932
/// §4, §5). The symbols take 15 bits each, and with the extra bits, 64 bits: more than one refill.
const wide_command_symbol = 391;
const wide_copy_len = 2118;
const wide_copy_code = 23;
const long_distance_code = 34;
const long_distance = 2045;
const long_distance_extra_bits = 10;

/// An uncompressed meta-block of `long_distance` octets, then a meta-block of the long command.
fn long_codes_stream(stream: *Stream, history: []const u8) void {
    stream.window_bits_16();
    stream.uncompressed(history);
    stream.meta_block(true, wide_copy_len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    var repeats: [zero_repeats_max]test_stream.LengthSymbol = undefined;
    put_skewed_code(stream, zero_repeats(&insert_copy_zero_extras, &repeats));
    put_skewed_code(stream, zero_repeats(&distance_zero_extras, &repeats));
    var insert_copy_lengths: [constants.insert_copy_alphabet_len]u8 = undefined;
    skewed_lengths(&insert_copy_lengths, wide_command_symbol);
    const insert_copy = test_stream.canonical(&insert_copy_lengths, wide_command_symbol);
    stream.put_code(insert_copy.code, insert_copy.len);
    const copy = constants.copy_length_codes[wide_copy_code];
    stream.put(wide_copy_len - copy.base, copy.extra_bits);
    var distance_lengths: [constants.distance_short_codes_count + constants.distance_code_groups]u8 = undefined;
    skewed_lengths(&distance_lengths, long_distance_code);
    const distance = test_stream.canonical(&distance_lengths, long_distance_code);
    stream.put_code(distance.code, distance.len);
    stream.put(0, long_distance_extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a command whose symbols and extra bits pass one refill decodes on the fast path" {
    var history: [long_distance]u8 = undefined;
    for (&history, 0..) |*octet, index| octet.* = @truncate(index * 7 + 3);
    var stream: Stream = .{};
    long_codes_stream(&stream, &history);
    var expected: [long_distance + wide_copy_len]u8 = undefined;
    for (&expected, 0..) |*octet, index| octet.* = history[index % long_distance];
    // Room past the stream's octets, so that the fast path's margin holds for the command.
    var output: [expected.len + 512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqualSlices(u8, &expected, output[0..whole.written]);
}
