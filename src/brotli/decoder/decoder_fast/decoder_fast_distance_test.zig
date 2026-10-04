//! A distance's tree in the fast path's straight loop (RFC 7932 §7.3): each distance context, the
//! copy lengths 2, 3, 4 and 5 and above, with a tree of its own, before and after a dictionary word.

const std = @import("std");
const codec = @import("codec");
const testing = std.testing;
const decoder_module = @import("../decoder.zig");
const constants = @import("../../constants.zig");
const dictionary = @import("../../dictionary.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;
const trailer = test_stream.trailer;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const CheckedDecoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits, .paths = .{ .fast_paths = false } });
const test_window_bits = 16;

/// The octets before the commands, none alike, so that a copy from a wrong distance differs.
const history = "abcdefghijklmnop";

/// A command of no literals: its copy length, its insert-and-copy symbol, 128 and the copy code in
/// the cell of explicit distances (RFC 7932 §5), and the distance its context's tree gives.
const Command = struct { copy_len: u16, symbol: u16, distance: u16 };

/// NDIRECT 4 (RFC 7932 §4): the direct codes 16 to 19 are the distances 1 to 4, and the alphabet.
const four_direct_high = 4;
const direct_first_code = constants.distance_short_codes_count;
const distance_alphabet_len = constants.distance_short_codes_count + four_direct_high + constants.distance_code_groups;

/// The third context's tree gives the distance 600, past every octet produced, a dictionary word
/// of the copy's 4 octets with the identity transform (RFC 7932 §8). With NPOSTFIX 0 and NDIRECT 4
/// that is the distance code 34, 8 extra bits over the offset (2 << 8) - 4, NDIRECT and 1 (§4).
const word_distance = 600;
const word_len = 4;
const word_distance_code = 34;
const word_extra_bits = 8;
const word_offset = (constants.coded_distance_base << word_extra_bits) - constants.coded_distance_bias + four_direct_high + 1;

/// The four symbols a simple code of four gives 2 bits each (RFC 7932 §3.4): no literals and the
/// copy lengths 2, 3, 4 and 9, in the cell of explicit distances (§5).
const symbol_bits = 2;
const copy_2_symbol = 128;
const copy_3_symbol = 129;
const copy_4_symbol = 130;
const copy_9_symbol = 135;
const symbols = [_]u16{ copy_2_symbol, copy_3_symbol, copy_4_symbol, copy_9_symbol };
const output_len_max = 64;

fn commands_len(commands: []const Command) u32 {
    var len: u32 = 0;
    for (commands) |command| len += command.copy_len;
    return len;
}

/// `history` uncompressed, then a meta-block of `commands`: NTREESD 4, whose map names tree c for
/// the distance context c (RFC 7932 §7.3), the trees of the distances 1, 2, the word's and 4.
fn contexts_stream(stream: *Stream, commands: []const Command) void {
    stream.window_bits_16();
    stream.uncompressed(history);
    stream.meta_block(true, commands_len(commands));
    stream.count(1);
    stream.count(1);
    stream.count(1);
    stream.put(0, constants.postfix_field_bits);
    stream.put(four_direct_high, constants.direct_field_bits);
    stream.put(0, constants.context_mode_bits);
    stream.count(1);
    // NTREESD 4 and the distance context map: no run-length codes, a code of the values 0 to 3, 2
    // bits each, and no inverse move-to-front transform.
    stream.count(constants.distance_contexts_count);
    stream.put(0, 1);
    var trees: [constants.distance_contexts_count]u16 = undefined;
    for (&trees, 0..) |*tree, id| tree.* = @intCast(id);
    stream.simple_code(constants.distance_contexts_count, &trees, false);
    for (0..constants.distance_contexts_count) |id| stream.put_code(@intCast(id), symbol_bits);
    stream.put(0, 1);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &symbols, false);
    stream.simple_code(distance_alphabet_len, &.{direct_first_code}, false);
    stream.simple_code(distance_alphabet_len, &.{direct_first_code + 1}, false);
    stream.simple_code(distance_alphabet_len, &.{word_distance_code}, false);
    stream.simple_code(distance_alphabet_len, &.{direct_first_code + constants.distance_contexts_count - 1}, false);
    for (commands) |command| {
        stream.put_code(@intCast(std.mem.indexOfScalar(u16, &symbols, command.symbol).?), symbol_bits);
        if (command.distance == word_distance) stream.put(word_distance - word_offset, word_extra_bits);
    }
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

/// What the commands write after `history`, into `expected`: the octets it takes.
fn contexts_expected(expected: []u8, commands: []const Command) usize {
    @memcpy(expected[0..history.len], history);
    var len: usize = history.len;
    for (commands) |command| {
        if (command.distance == word_distance) {
            const index: u32 = @intCast(word_distance - len - 1);
            @memcpy(expected[len..][0..word_len], dictionary.word(word_len, index));
            len += word_len;
            continue;
        }
        for (0..command.copy_len) |_| {
            expected[len] = expected[len - command.distance];
            len += 1;
        }
    }
    return len;
}

test "each distance context takes its own tree, before a word and after it" {
    // A copy of each context, then the word, then a copy of each context again: the loop takes
    // the later ones with the tables' pointer it loads again after the word's call.
    const commands = [_]Command{
        .{ .copy_len = 2, .symbol = copy_2_symbol, .distance = 1 },
        .{ .copy_len = 3, .symbol = copy_3_symbol, .distance = 2 },
        .{ .copy_len = 9, .symbol = copy_9_symbol, .distance = 4 },
        .{ .copy_len = word_len, .symbol = copy_4_symbol, .distance = word_distance },
        .{ .copy_len = 2, .symbol = copy_2_symbol, .distance = 1 },
        .{ .copy_len = 3, .symbol = copy_3_symbol, .distance = 2 },
        .{ .copy_len = 9, .symbol = copy_9_symbol, .distance = 4 },
    };
    // The word's reference is the identity transform's: below the count of words of 4 octets.
    try testing.expect(word_distance < @as(u32, 1) << dictionary.bits[word_len]);
    var stream: Stream = .{};
    contexts_stream(&stream, &commands);
    var expected: [history.len + output_len_max]u8 = undefined;
    const len = contexts_expected(&expected, &commands);
    try testing.expectEqual(history.len + commands_len(&commands), len);
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqualSlices(u8, expected[0..len], output[0..whole.written]);
    var checked_output: [512]u8 = undefined;
    var checked: CheckedDecoder = undefined;
    checked.init(codec.Features.detect());
    const checked_whole = try checked.decode_all(stream.written(), &checked_output);
    try testing.expectEqualSlices(u8, expected[0..len], checked_output[0..checked_whole.written]);
}

/// Two distance block types (RFC 7932 §6), each with a tree of its own for every context (§7.3):
/// four commands of symbol 128, no literals and a copy of 2. The first block holds one distance, 3,
/// the direct code 18 of NDIRECT 5 (§4); the switch before the second command starts a block of 4
/// of the second type, whose tree gives 5, the direct code 20. The chain takes the second distance,
/// with its block switch, and the loop the third and the fourth, from the tables of the block type
/// it starts with.
const typed_direct_high = 5;
const typed_alphabet_len = constants.distance_short_codes_count + typed_direct_high + constants.distance_code_groups;
const typed_first_distance = 3;
const typed_second_distance = 5;
const typed_copy_len = 2;
const typed_commands = 4;
const typed_second_block_extra = 3;

fn typed_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.uncompressed(history);
    stream.meta_block(true, typed_commands * typed_copy_len);
    stream.count(1);
    stream.count(1);
    // NBLTYPESD 2: the block type code of the symbol 1, the next type; the count code of the symbol
    // 0, whose 2 extra bits give 1 to 4; the first block's count, 1.
    stream.count(constants.block_switch_types_min);
    stream.simple_code(constants.block_switch_types_min + constants.block_type_symbol_offset, &.{1}, false);
    stream.simple_code(constants.block_count_alphabet_len, &.{0}, false);
    stream.put(0, constants.block_count_codes[0].extra_bits);
    stream.put(0, constants.postfix_field_bits);
    stream.put(typed_direct_high, constants.direct_field_bits);
    stream.put(0, constants.context_mode_bits);
    stream.count(1);
    // NTREESD 2 and the distance context map: a code of the values 0 and 1, 1 bit each; the first
    // block type's contexts take tree 0 and the second's tree 1.
    stream.count(constants.context_map_trees_min);
    stream.put(0, 1);
    stream.simple_code(constants.context_map_trees_min, &.{ 0, 1 }, false);
    for (0..constants.distance_contexts_count) |_| stream.put_code(0, 1);
    for (0..constants.distance_contexts_count) |_| stream.put_code(1, 1);
    stream.put(0, 1);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{copy_2_symbol}, false);
    stream.simple_code(typed_alphabet_len, &.{direct_first_code + typed_first_distance - 1}, false);
    stream.simple_code(typed_alphabet_len, &.{direct_first_code + typed_second_distance - 1}, false);
    // Every symbol takes no bits: the stream holds the second block's count alone, 4.
    stream.put(typed_second_block_extra, constants.block_count_codes[0].extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "the loop takes a distance's tree from the block type it starts with" {
    var stream: Stream = .{};
    typed_stream(&stream);
    var expected: [history.len + typed_commands * typed_copy_len]u8 = undefined;
    @memcpy(expected[0..history.len], history);
    var len: usize = history.len;
    for (0..typed_commands) |command| {
        const distance: usize = if (command == 0) typed_first_distance else typed_second_distance;
        for (0..typed_copy_len) |_| {
            expected[len] = expected[len - distance];
            len += 1;
        }
    }
    // The two trees give the later commands different octets.
    try testing.expect(expected[len - 1 - typed_second_distance] != expected[len - 1 - typed_first_distance] or expected[len - typed_copy_len - typed_second_distance] != expected[len - typed_copy_len - typed_first_distance]);
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqualSlices(u8, &expected, output[0..whole.written]);
}
