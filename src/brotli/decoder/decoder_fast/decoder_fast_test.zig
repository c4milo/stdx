//! The fast path's margins (decision 16): a long copy decoded into every room up to its length, so
//! that an iteration starts at every room the output margin allows, and writes nothing past it.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const decoder_module = @import("../decoder.zig");
const fast = @import("decoder_fast.zig");
const constants = @import("../../constants.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const CheckedDecoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits, .paths = .{ .fast_paths = false } });
const commands = @import("../decoder_commands.zig");
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

const trailer = test_stream.trailer;

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
        decoder.init(codec.Features.detect());
        const progress = try decoder.decode(input, output[0..room]);
        try testing.expectEqual(room, progress.written);
        try testing.expectEqualSlices(u8, expected[0..room], output[0..room]);
        if (room == expected.len) {
            try testing.expectEqual(.done, progress.status);
            try testing.expectEqual(input.len - trailer.len, progress.consumed);
        }
    }
}

test "a long copy that ends the stream, past the input's margin, writes nothing past any room" {
    var stream: Stream = .{};
    long_copy_stream(&stream);
    // With no octets after the stream, the copy starts with fewer than a refill's 8 left, and the
    // fast path takes it on the output's margin alone.
    const input = stream.written()[0 .. stream.written().len - trailer.len];
    var expected: [pattern.len + copy_len]u8 = undefined;
    for (&expected, 0..) |*octet, index| octet.* = pattern[index % pattern.len];
    var output: [expected.len]u8 = undefined;
    for (0..expected.len + 1) |room| {
        var decoder: Decoder = undefined;
        decoder.init(codec.Features.detect());
        const progress = try decoder.decode(input, output[0..room]);
        try testing.expectEqual(room, progress.written);
        try testing.expectEqualSlices(u8, expected[0..room], output[0..room]);
        if (room == expected.len) try testing.expectEqual(.done, progress.status);
    }
}

test "a copy or a word's rest starts the fast path with the input short, a command needs its margin" {
    const input: [fast.input_slack - 1]u8 = @splat(0);
    var bits = codec.BitReader.init(&input, .{});
    var output: [1]u8 = undefined;
    var writer = codec.Writer.init(&output);
    try testing.expect(fast.has_margin(.copy, &bits, &writer));
    try testing.expect(fast.has_margin(.dictionary_copy, &bits, &writer));
    try testing.expect(!fast.has_margin(.command, &bits, &writer));
    try testing.expect(!fast.has_margin(.literal, &bits, &writer));
    // Each needs an octet of room; each write then checks the room it stores into (decision 32).
    var no_room = codec.Writer.init(output[1..]);
    try testing.expect(!fast.has_margin(.copy, &bits, &no_room));
    const whole: [fast.input_slack]u8 = @splat(0);
    var whole_bits = codec.BitReader.init(&whole, .{});
    try testing.expect(fast.has_margin(.command, &whole_bits, &writer));
    try testing.expect(!fast.has_margin(.command, &whole_bits, &no_room));
}

test "the loop checks each write once its room is short of the margin, and against the margin before" {
    var output: [constants.chunk_len_max + constants.copy_chunk_len]u8 = undefined;
    var margin = codec.Writer.init(&output);
    try testing.expectEqual(.margin, fast.room_of(&margin));
    var short = codec.Writer.init(output[1..]);
    try testing.expectEqual(.each_write, fast.room_of(&short));
}

/// Symbol 389: insert length 0 and copy code 21, 582 and 9 extra bits, which takes a distance
/// code: here 3, the fourth last distance, 16 (RFC 7932 §4, §5). The copy follows an uncompressed
/// `pattern`, so the command has no literals and takes the straight-line command's path.
const straight_copy_symbol = 389;

fn straight_copy_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.uncompressed(pattern);
    stream.meta_block(true, copy_len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{straight_copy_symbol}, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{fourth_last_distance_code}, false);
    const copy = constants.copy_length_codes[long_copy_code];
    stream.put(copy_len - copy.base, copy.extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a long copy of no literals writes nothing past any room it is decoded into" {
    var stream: Stream = .{};
    straight_copy_stream(&stream);
    const input = stream.written();
    var expected: [pattern.len + copy_len]u8 = undefined;
    for (&expected, 0..) |*octet, index| octet.* = pattern[index % pattern.len];
    var output: [expected.len]u8 = undefined;
    for (pattern.len..expected.len + 1) |room| {
        var decoder: Decoder = undefined;
        decoder.init(codec.Features.detect());
        const progress = try decoder.decode(input, output[0..room]);
        try testing.expectEqual(room, progress.written);
        try testing.expectEqualSlices(u8, expected[0..room], output[0..room]);
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
    decoder.init(codec.Features.detect());
    const first = try decoder.decode(input, output[0..pattern.len]);
    try testing.expectEqual(.needs_room, first.status);
    try testing.expectEqual(pattern.len, first.written);
    const rest = try decoder.decode(input[first.consumed..], output[pattern.len..]);
    try testing.expectEqual(.done, rest.status);
    try testing.expectEqualSlices(u8, &expected, output[0..expected.len]);
}

/// The repeats of zeros of the long command's skewed codes (RFC 7932 §3.5): 377 from the symbol 14
/// to the insert-and-copy symbol 391, 7, then 8 * 5 + 3 + 5 = 48, then 8 * 46 + 3 + 6 = 377; and
/// 20 to the distance code 34, 4, then 8 * 2 + 3 + 1 = 20.
const insert_copy_zero_extras = [_]u8{ first_zeros_extra, second_zeros_extra, third_zeros_extra };
const first_zeros_extra = 4;
const second_zeros_extra = 5;
const third_zeros_extra = 6;
const distance_zero_extras = [_]u8{ 1, 1 };

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
    var repeats: [test_stream.zero_repeats_max]test_stream.LengthSymbol = undefined;
    stream.skewed_code(test_stream.zero_repeats(&insert_copy_zero_extras, &repeats));
    stream.skewed_code(test_stream.zero_repeats(&distance_zero_extras, &repeats));
    var insert_copy_lengths: [constants.insert_copy_alphabet_len]u8 = undefined;
    test_stream.skewed_lengths(&insert_copy_lengths, wide_command_symbol);
    const insert_copy = test_stream.canonical(&insert_copy_lengths, wide_command_symbol);
    stream.put_code(insert_copy.code, insert_copy.len);
    const copy = constants.copy_length_codes[wide_copy_code];
    stream.put(wide_copy_len - copy.base, copy.extra_bits);
    var distance_lengths: [constants.distance_short_codes_count + constants.distance_code_groups]u8 = undefined;
    test_stream.skewed_lengths(&distance_lengths, long_distance_code);
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
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqualSlices(u8, &expected, output[0..whole.written]);
}

/// The dictionary's last two words of 24 octets, 30 and 31 (RFC 7932 §8): two commands of insert
/// length 0 and copy length 24, copy code 12, 22 and 3 extra bits, in the symbol 196 of the cell of
/// insert codes 0 to 7 and copy codes 8 to 15 that takes a distance code. NPOSTFIX 2 and NDIRECT
/// 56 make the distances 31 and 56 the direct codes 46 and 71: word 30 of the identity transform
/// with nothing produced, and word 31 with the first word's 24 octets produced (RFC 7932 §4, §5).
const last_word_len = constants.word_len_max;
const last_word_copy_code = 12;
const last_words_symbol = 196;
const postfix_two = 2;
const direct_high_fourteen = 14;
const direct_count_56 = direct_high_fourteen << postfix_two;
const last_words_alphabet_len = constants.distance_short_codes_count + direct_count_56 + (constants.distance_code_groups << postfix_two);
const last_word_index = dictionary_word_count_24 - 1;
const dictionary_word_count_24 = 32;
const last_words = 2;

/// The direct distance code of `distance`: 16 + distance - 1 (RFC 7932 §4).
fn direct_code(distance: u16) u16 {
    return constants.distance_short_codes_count + distance - 1;
}

/// Word 30 at distance 31 with nothing produced, then word 31 at 24 + 32 = 56.
fn last_words_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, last_words * last_word_len);
    stream.simple_header(postfix_two, direct_high_fourteen, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{last_words_symbol}, false);
    // Distance codes 46 and 71 take 1 bit each: 0 and 1.
    stream.simple_code(last_words_alphabet_len, &.{ direct_code(last_word_index), direct_code(last_word_len + last_word_index + 1) }, false);
    const copy = constants.copy_length_codes[last_word_copy_code];
    stream.put(last_word_len - copy.base, copy.extra_bits);
    stream.put_code(0, 1);
    stream.put(last_word_len - copy.base, copy.extra_bits);
    stream.put_code(1, 1);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "the dictionary's last words decode on the fast path, the last from its exact copy" {
    var stream: Stream = .{};
    last_words_stream(&stream);
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    const dictionary = @import("../../dictionary.zig");
    try testing.expectEqualSlices(u8, dictionary.data[dictionary.data.len - last_words * last_word_len ..], output[0..whole.written]);
}

test "the dictionary's last words write nothing past any room, the wide word nor the exact one" {
    var stream: Stream = .{};
    last_words_stream(&stream);
    const dictionary = @import("../../dictionary.zig");
    const expected = dictionary.data[dictionary.data.len - last_words * last_word_len ..];
    var output: [last_words * last_word_len]u8 = undefined;
    for (0..expected.len + 1) |room| {
        var decoder: Decoder = undefined;
        decoder.init(codec.Features.detect());
        const progress = try decoder.decode(stream.written(), output[0..room]);
        try testing.expectEqual(room, progress.written);
        try testing.expectEqualSlices(u8, expected[0..room], output[0..room]);
    }
}

test "the rest of a word the checked path started writes nothing past the next call's room" {
    var stream: Stream = .{};
    last_words_stream(&stream);
    const dictionary = @import("../../dictionary.zig");
    const expected = dictionary.data[dictionary.data.len - last_words * last_word_len ..];
    var output: [last_words * last_word_len]u8 = undefined;
    // A first call cuts the first word; the second's room holds some of its rest, or all.
    for (1..last_word_len) |first| {
        for (0..expected.len - first + 1) |second| {
            var decoder: Decoder = undefined;
            decoder.init(codec.Features.detect());
            const one = try decoder.decode(stream.written(), output[0..first]);
            const two = try decoder.decode(stream.written()[one.consumed..], output[first..][0..second]);
            try testing.expectEqual(second, two.written);
            try testing.expectEqualSlices(u8, expected[0 .. first + second], output[0 .. first + second]);
        }
    }
}

/// Symbols 32 and 128 (RFC 7932 §5): insert length 4 and copy length 2 at the last distance, which
/// no distance code follows; then the first symbol that takes a distance code, insert length 0 and
/// copy length 2. NDIRECT 1 makes its code 16 the distance 1.
const implicit_symbol = 32;
const explicit_symbol = 128;
const one_direct_high = 1;
const one_direct_alphabet_len = constants.distance_short_codes_count + one_direct_high + constants.distance_code_groups;

fn distance_boundary_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, "abcdabbb".len);
    stream.simple_header(0, one_direct_high, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{ 'a', 'b', 'c', 'd' }, false);
    // Symbol 32 takes the code 0 and symbol 128 the code 1.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{ implicit_symbol, explicit_symbol }, false);
    stream.simple_code(one_direct_alphabet_len, &.{constants.distance_short_codes_count}, false);
    stream.put_code(0, 1);
    for ("abcd") |literal| stream.put_code(literal - 'a', literal_code_bits);
    stream.put_code(1, 1);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "the first symbol of a distance code takes its code, and the one before it the last distance" {
    var stream: Stream = .{};
    distance_boundary_stream(&stream);
    // Room past the stream's octets, so that the fast path's margin holds.
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    // The last distance, 4, copies "ab"; distance 1 copies "b" twice.
    try testing.expectEqualStrings("abcdabbb", output[0..whole.written]);
}

/// Symbol 194: insert length 0 and copy code 10, 14 and 2 extra bits, in the cell of insert codes 0
/// to 7 and copy codes 8 to 15 (RFC 7932 §5); its distance code 0 is the last distance, 4 at a
/// stream's start, which code 0 never pushes (RFC 7932 §4). Each command copies 16 octets of
/// `pattern`, whose period is 4, from 4 back.
const short_copy_symbol = 194;
const short_copy_code = 10;
const short_copy_len = 16;
const short_copies = 40;
const last_distance_code = 0;

/// The stream: an uncompressed `pattern`, then `short_copies` commands of one copy each, 2 bits a
/// command, so that one pass of the loop takes many commands and the room ends inside them; zeros
/// after the trailer keep the input's margin to the last command.
fn short_copies_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.uncompressed(pattern);
    stream.meta_block(true, short_copies * short_copy_len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{short_copy_symbol}, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{last_distance_code}, false);
    const copy = constants.copy_length_codes[short_copy_code];
    for (0..short_copies) |_| stream.put(short_copy_len - copy.base, copy.extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
    for (0..fast.input_slack) |_| stream.put(0, @bitSizeOf(u8));
}

test "many short copies write nothing past any room, the margin checked for each command" {
    var stream: Stream = .{};
    short_copies_stream(&stream);
    const input = stream.written();
    var expected: [pattern.len + short_copies * short_copy_len]u8 = undefined;
    for (&expected, 0..) |*octet, index| octet.* = pattern[index % pattern.len];
    var output: [expected.len]u8 = undefined;
    for (0..expected.len + 1) |room| {
        var decoder: Decoder = undefined;
        decoder.init(codec.Features.detect());
        const progress = try decoder.decode(input, output[0..room]);
        try testing.expectEqual(room, progress.written);
        try testing.expectEqualSlices(u8, expected[0..room], output[0..room]);
        if (room == expected.len) try testing.expectEqual(.done, progress.status);
    }
}

/// Symbol 472: insert code 19, 578 and 9 extra bits, and copy code 0, in the cell of insert codes 16
/// to 23 and copy codes 0 to 7 (RFC 7932 §5): an insert of `long_insert_len` literals that ends the
/// meta-block, so no copy follows (RFC 7932 §9.3).
const long_insert_symbol = 472;
const long_insert_code = 19;
const long_insert_len = 600;

/// The stream: one command of `long_insert_len` literals of `pattern`'s four symbols, 2 bits each,
/// under one tree, so that the loop takes several runs of a chunk and p1 and p2 come from its
/// one-table run.
fn long_insert_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, long_insert_len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{ 'a', 'b', 'c', 'd' }, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{long_insert_symbol}, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{last_distance_code}, false);
    const insert = constants.insert_length_codes[long_insert_code];
    stream.put(long_insert_len - insert.base, insert.extra_bits);
    for (0..long_insert_len) |index| stream.put_code(pattern[index % pattern.len] - pattern[0], literal_code_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
    for (0..fast.input_slack) |_| stream.put(0, @bitSizeOf(u8));
}

test "a long insert takes several runs, each within the room, and leaves p1 and p2 as the checked path does" {
    try testing.expectEqual(long_insert_code, commands.command_codes[long_insert_symbol].insert_code);
    try testing.expectEqual(0, commands.command_codes[long_insert_symbol].copy_code);
    var stream: Stream = .{};
    long_insert_stream(&stream);
    const input = stream.written();
    var expected: [long_insert_len]u8 = undefined;
    for (&expected, 0..) |*octet, index| octet.* = pattern[index % pattern.len];
    var output: [expected.len]u8 = undefined;
    for (0..expected.len + 1) |room| {
        var decoder: Decoder = undefined;
        decoder.init(codec.Features.detect());
        const progress = try decoder.decode(input, output[0..room]);
        try testing.expectEqual(room, progress.written);
        try testing.expectEqualSlices(u8, expected[0..room], output[0..room]);
        if (room < expected.len) continue;
        try testing.expectEqual(.done, progress.status);
        var checked: CheckedDecoder = undefined;
        checked.init(codec.Features.detect());
        var checked_output: [expected.len]u8 = undefined;
        _ = try checked.decode(input, &checked_output);
        try testing.expectEqual(checked.state.p1, decoder.state.p1);
        try testing.expectEqual(checked.state.p2, decoder.state.p2);
    }
}
