//! The straight-line command of decoder_fast_command.zig (decision 16): commands of no literals
//! whose extra bits, distance or copy it leaves to the chain of phases, and the ring of last
//! distances it keeps (RFC 7932 §4, §5).

const std = @import("std");
const testing = std.testing;
const decoder_module = @import("../decoder.zig");
const constants = @import("../../constants.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;
const trailer = test_stream.trailer;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;

/// Symbol 703, insert code 23 and copy code 23 (RFC 7932 §5), whose 48 extra bits are the most a
/// command takes: 22594 and 24 extra bits, then 2118 and 24 extra bits. A skewed code gives it 15
/// bits, so that after a refill of 56 to 63 bits it leaves 41 to 48, and after 62, 47: a bit short.
/// Before it, up to 7 commands of symbol 0, insert length 0 and copy length 2 at the last distance,
/// take a bit each, so that it starts a chain at every count a refill leaves.
const widest_symbol = 703;
const widest_code = 23;
const short_symbol = 0;
const short_copy_len = 2;
const short_commands_max = 7;

/// The octets the commands of symbol 0 repeat from the last distance the ring starts with, 4, and
/// the literal the widest command inserts.
const widest_history = "abcd";
const widest_literal = 'q';

/// The zeros from the symbol 14 to the symbol 702, 688 (RFC 7932 §3.5): 3, then 8 * 1 + 3 + 1 =
/// 12, then 8 * 10 + 3 + 4 = 87, then 8 * 85 + 3 + 5 = 688.
const widest_zero_extras = [_]u8{ 0, 1, widest_third_zeros_extra, widest_fourth_zeros_extra };
const widest_third_zeros_extra = 4;
const widest_fourth_zeros_extra = 5;

/// `widest_history` uncompressed, then a meta-block of `short_commands` commands of symbol 0 and
/// the widest command, its literals and its distance code each of a code of one symbol, which
/// takes no bits.
fn widest_command_stream(stream: *Stream, short_commands: usize) void {
    const insert = constants.insert_length_codes[widest_code];
    const copy = constants.copy_length_codes[widest_code];
    stream.window_bits_16();
    stream.uncompressed(widest_history);
    stream.meta_block(true, @intCast(short_commands * short_copy_len + insert.base + copy.base));
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{widest_literal}, false);
    var repeats: [test_stream.zero_repeats_max]test_stream.LengthSymbol = undefined;
    stream.skewed_code(test_stream.zero_repeats(&widest_zero_extras, &repeats));
    // The distance code 0, the last distance.
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{0}, false);
    var lengths: [constants.insert_copy_alphabet_len]u8 = undefined;
    test_stream.skewed_lengths(&lengths, widest_symbol - 1);
    const short = test_stream.canonical(&lengths, short_symbol);
    for (0..short_commands) |_| stream.put_code(short.code, short.len);
    const widest = test_stream.canonical(&lengths, widest_symbol);
    stream.put_code(widest.code, widest.len);
    stream.put(0, insert.extra_bits);
    stream.put(0, copy.extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a command's extra bits a bit past the buffer's wait for the next refill" {
    const widest_len = constants.insert_length_codes[widest_code].base + constants.copy_length_codes[widest_code].base;
    var expected: [widest_history.len + short_commands_max * short_copy_len + widest_len]u8 = undefined;
    // Room past the stream's octets, so that the fast path's margin holds.
    var output: [expected.len + 512]u8 = undefined;
    for (0..short_commands_max + 1) |short_commands| {
        var stream: Stream = .{};
        widest_command_stream(&stream, short_commands);
        const short_len = widest_history.len + short_commands * short_copy_len;
        for (expected[0..short_len], 0..) |*octet, index| octet.* = widest_history[index % widest_history.len];
        @memset(expected[short_len..][0..widest_len], widest_literal);
        var decoder: Decoder = undefined;
        decoder.init(.{});
        const whole = try decoder.decode_all(stream.written(), &output);
        try testing.expectEqualSlices(u8, expected[0 .. short_len + widest_len], output[0..whole.written]);
    }
}

/// Two distance block types of one distance each, so the second command's distance comes after a
/// block switch (RFC 7932 §6), and each type's tree: type 0 the distance 2, type 1 the distance 1,
/// NDIRECT 2's codes 17 and 16, each a code of one symbol, which takes no bits. Each command is
/// symbol 387, insert length 0 and copy code 19, 198 and 7 extra bits, and its symbol takes 3 bits
/// of a simple code of four with the tree-select bit, whose other places the symbols 0, 1 and 2
/// fill (RFC 7932 §3.4, §5). With the extra bits, 10 bits go before the switch, which needs up to
/// 54: more than a refill of 56 to 63 leaves.
const switching_distance_symbol = 387;
const switching_copy_code = 19;
const switching_copy_len = 198;
const switching_symbols = [_]u16{ 0, 1, switching_distance_symbol, last_filler_symbol };
const last_filler_symbol = 2;
const switching_commands = 2;
const two_direct_high = 2;
const two_direct_alphabet_len = constants.distance_short_codes_count + two_direct_high + constants.distance_code_groups;

/// A distance context map of two trees: the first block type's contexts take tree 0, the second's
/// tree 1, from a code of the values 0 and 1 (RFC 7932 §7.3).
fn two_tree_distance_map(stream: *Stream) void {
    stream.count(constants.context_map_trees_min);
    stream.put(0, 1);
    stream.simple_code(constants.context_map_trees_min, &.{ 0, 1 }, false);
    for (0..constants.distance_contexts_count) |_| stream.put_code(0, 1);
    for (0..constants.distance_contexts_count) |_| stream.put_code(1, 1);
    stream.put(0, 1);
}

fn distance_switch_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.uncompressed("ab");
    stream.meta_block(true, switching_commands * switching_copy_len);
    stream.count(1);
    stream.count(1);
    stream.count(constants.block_switch_types_min);
    stream.simple_code(constants.block_switch_types_min + constants.block_type_symbol_offset, &.{1}, false);
    stream.simple_code(constants.block_count_alphabet_len, &.{0}, false);
    stream.put(0, constants.block_count_codes[0].extra_bits);
    stream.put(0, constants.postfix_field_bits);
    stream.put(two_direct_high, constants.direct_field_bits);
    stream.put(0, constants.context_mode_bits);
    stream.count(1);
    two_tree_distance_map(stream);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &switching_symbols, true);
    stream.simple_code(two_direct_alphabet_len, &.{constants.distance_short_codes_count + 1}, false);
    stream.simple_code(two_direct_alphabet_len, &.{constants.distance_short_codes_count}, false);
    var lengths: [constants.insert_copy_alphabet_len]u8 = @splat(0);
    for (switching_symbols, constants.simple_code_lengths_tree_select) |symbol, len| lengths[symbol] = len;
    const code = test_stream.canonical(&lengths, switching_distance_symbol);
    const copy = constants.copy_length_codes[switching_copy_code];
    for (0..switching_commands) |command| {
        stream.put_code(code.code, code.len);
        stream.put(switching_copy_len - copy.base, copy.extra_bits);
        // The second distance's block switch: the next type, and a count of 1.
        if (command > 0) stream.put(0, constants.block_count_codes[0].extra_bits);
    }
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a distance's block switch after a command of no literals takes the next type's tree" {
    var stream: Stream = .{};
    distance_switch_stream(&stream);
    var output: [1024]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const whole = try decoder.decode_all(stream.written(), &output);
    // Distance 2 repeats "ab"; then, after the switch, distance 1 repeats the last "b".
    var expected: [2 + switching_commands * switching_copy_len]u8 = undefined;
    for (expected[0 .. 2 + switching_copy_len], 0..) |*octet, index| octet.* = "ab"[index % 2];
    @memset(expected[2 + switching_copy_len ..], 'b');
    try testing.expectEqualSlices(u8, &expected, output[0..whole.written]);
}

/// Three commands of no literals and copy length 2 after "abcdefgh" (RFC 7932 §4, §5): symbol 128
/// with the direct distance 3, which goes into the ring of last distances; symbol 0, whose last
/// distance, 3, does not; then symbol 128 with the distance code 1, the second last distance, 4.
/// NDIRECT 3 makes its last direct code, 18, the distance 3.
const ring_history = "abcdefgh";
const ring_commands = 3;
const ring_copy_len = 2;
const three_direct_high = 3;
const three_direct_alphabet_len = constants.distance_short_codes_count + three_direct_high + constants.distance_code_groups;
const direct_three_code = constants.distance_short_codes_count + three_direct_high - 1;
const second_last_code = 1;

fn ring_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.uncompressed(ring_history);
    stream.meta_block(true, ring_commands * ring_copy_len);
    stream.simple_header(0, three_direct_high, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    // Symbol 0 takes the code 0 and symbol 128 the code 1; distance code 1 the code 0 and code 18
    // the code 1.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{ 0, constants.insert_copy_last_distance_symbols }, false);
    stream.simple_code(three_direct_alphabet_len, &.{ second_last_code, direct_three_code }, false);
    stream.put_code(1, 1);
    stream.put_code(1, 1);
    stream.put_code(0, 1);
    stream.put_code(1, 1);
    stream.put_code(0, 1);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "the last distance a command of no literals reuses stays out of the ring" {
    var stream: Stream = .{};
    ring_stream(&stream);
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const whole = try decoder.decode_all(stream.written(), &output);
    // Distance 3 copies "fg", the last distance "hf", and the second last, 4, "fg".
    try testing.expectEqualStrings("abcdefghfghffg", output[0..whole.written]);
}

/// Symbol 539, insert code 11 and copy code 19 (RFC 7932 §5): 32 literals, 26 and 3 extra bits,
/// then a copy of 250, 198 and 7 extra bits, at the fourth last distance, 16. The literals repeat
/// "abcd" from a simple code of four, 2 bits each; the copy goes on with it.
const room_symbol = 539;
const room_insert_code = 11;
const room_copy_code = 19;
const room_literals_len = 32;
const room_copy_len = 250;
const room_pattern = "abcd";
/// A simple code of four symbols gives each 2 bits (RFC 7932 §3.4).
const room_literal_code_bits = 2;
/// The distance code 3: the fourth last distance (RFC 7932 §4).
const fourth_last_distance_code = constants.last_distances_count - 1;

fn room_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, room_literals_len + room_copy_len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{ 'a', 'b', 'c', 'd' }, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{room_symbol}, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{fourth_last_distance_code}, false);
    const insert = constants.insert_length_codes[room_insert_code];
    const copy = constants.copy_length_codes[room_copy_code];
    stream.put(room_literals_len - insert.base, insert.extra_bits);
    stream.put(room_copy_len - copy.base, copy.extra_bits);
    // The four literals' codes are 00, 01, 10 and 11, in the order of their symbols.
    for (0..room_literals_len) |index| stream.put_code(@intCast(index % room_pattern.len), room_literal_code_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a copy after a command's literals waits for the output's margin, at every room" {
    var stream: Stream = .{};
    room_stream(&stream);
    const input = stream.written();
    var expected: [room_literals_len + room_copy_len]u8 = undefined;
    for (&expected, 0..) |*octet, index| octet.* = room_pattern[index % room_pattern.len];
    var output: [expected.len]u8 = undefined;
    for (0..expected.len + 1) |room| {
        var decoder: Decoder = undefined;
        decoder.init(.{});
        const progress = try decoder.decode(input, output[0..room]);
        try testing.expectEqual(room, progress.written);
        try testing.expectEqualSlices(u8, expected[0..room], output[0..room]);
    }
}
