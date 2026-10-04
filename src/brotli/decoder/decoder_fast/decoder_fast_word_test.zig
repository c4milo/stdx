//! Dictionary words in the fast path's straight loop (RFC 7932 §8): what a word leaves for the
//! commands after it, p1 and p2 and the bits, with the room and the trailer the loop needs.

const std = @import("std");
const codec = @import("codec");
const testing = std.testing;
const decoder_module = @import("../decoder.zig");
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const dictionary = @import("../../dictionary.zig");
const transform = @import("../../transform.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;
const trailer = test_stream.trailer;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;

/// Word 0 of length 4 with transform 23, OmitLast3 with no prefix or suffix (RFC 7932 §8, Appendix
/// B): the word's first octet alone. Its reference is the index and the transform above NDBITS.
const short_word_len = 4;
const omit_last_3 = 23;
const short_word_id = omit_last_3 << dictionary.bits[short_word_len];

/// Two commands in UTF8 mode (RFC 7932 §5, §7.1): symbol 138, the literal 'a' and a copy of 4 past
/// the one octet produced, the word; then symbol 136, one literal, whose context map names tree 1,
/// 'x', at the ID the word's octet and p2 'a' give, and tree 0, 'a', elsewhere. The meta-block's end
/// cuts the second copy off. The word's distance, 1 + 1 + its reference, is the distance code 40,
/// NPOSTFIX and NDIRECT 0, with 13 extra bits over the offset (2 << 13) - 4 (§4).
const short_copy_symbol = 136;
const short_word_symbol = 138;
const short_word_distance_code = 40;
const short_word_extra_bits = 13;
const short_word_offset = (constants.coded_distance_base << short_word_extra_bits) - constants.coded_distance_bias;
const short_word_distance = 1 + 1 + short_word_id;
const short_word_output_len = 3;

fn short_word_stream(stream: *Stream) void {
    const word_octet = dictionary.word(short_word_len, 0)[0];
    stream.window_bits_16();
    stream.meta_block(true, short_word_output_len);
    stream.count(1);
    stream.count(1);
    stream.count(1);
    stream.put(0, constants.postfix_field_bits);
    stream.put(0, constants.direct_field_bits);
    stream.put(@intFromEnum(context.Mode.utf8), constants.context_mode_bits);
    // NTREESL 2 and the literal context map: no run-length codes, a code of the values 0 and 1, 1
    // bit each, and no inverse move-to-front transform; NTREESD 1.
    stream.count(constants.context_map_trees_min);
    stream.put(0, 1);
    stream.simple_code(constants.context_map_trees_min, &.{ 0, 1 }, false);
    for (0..constants.literal_contexts_count) |id| stream.put_code(@intFromBool(id == context.literal_id(.utf8, word_octet, 'a')), 1);
    stream.put(0, 1);
    stream.count(1);
    stream.simple_code(constants.literal_alphabet_len, &.{'a'}, false);
    stream.simple_code(constants.literal_alphabet_len, &.{'x'}, false);
    // Symbol 136 takes the code 0 and symbol 138 the code 1.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{ short_copy_symbol, short_word_symbol }, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{short_word_distance_code}, false);
    stream.put_code(1, 1);
    stream.put(short_word_distance - 1 - short_word_offset, short_word_extra_bits);
    stream.put_code(0, 1);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a word of one octet moves p2 as a literal does, for the next literal's context" {
    const word_octet = dictionary.word(short_word_len, 0)[0];
    // p2 'a' and p2 0, the one before the word, give the next literal different IDs.
    try testing.expect(context.literal_id(.utf8, word_octet, 'a') != context.literal_id(.utf8, word_octet, 0));
    try testing.expect(context.literal_id(.utf8, 0, 0) != context.literal_id(.utf8, word_octet, 'a'));
    var stream: Stream = .{};
    short_word_stream(&stream);
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqualSlices(u8, &.{ 'a', word_octet, 'x' }, output[0..whole.written]);
}

/// Word 0 of length 4 with transform 42, OmitLast4 with no prefix or suffix (RFC 7932 §8, Appendix
/// B): no octet at all. Two commands in UTF8 mode (§5, §7.1): symbol 146, the literals "ab" and a
/// copy of 4 past the two octets produced, the word; then symbol 136, one literal, whose context
/// map names tree 1, 'x', at the ID p1 'b' and p2 'a' give, and tree 0, of 'a' and 'b', elsewhere.
/// The word's distance, 2 + 1 + its reference, is the distance code 42, 14 extra bits over the
/// offset (2 << 14) - 4 (§4).
const empty_word_symbol = 146;
const omit_last_4 = 42;
const empty_word_literals = "ab";
const empty_word_id = omit_last_4 << dictionary.bits[short_word_len];
const empty_word_distance = empty_word_literals.len + 1 + empty_word_id;
const empty_word_distance_code = 42;
const empty_word_extra_bits = 14;
const empty_word_offset = (constants.coded_distance_base << empty_word_extra_bits) - constants.coded_distance_bias;
const empty_word_output = "abx";

fn empty_word_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, empty_word_output.len);
    stream.count(1);
    stream.count(1);
    stream.count(1);
    stream.put(0, constants.postfix_field_bits);
    stream.put(0, constants.direct_field_bits);
    stream.put(@intFromEnum(context.Mode.utf8), constants.context_mode_bits);
    // NTREESL 2 and the literal context map, as `short_word_stream` writes them; NTREESD 1.
    stream.count(constants.context_map_trees_min);
    stream.put(0, 1);
    stream.simple_code(constants.context_map_trees_min, &.{ 0, 1 }, false);
    for (0..constants.literal_contexts_count) |id| stream.put_code(@intFromBool(id == context.literal_id(.utf8, 'b', 'a')), 1);
    stream.put(0, 1);
    stream.count(1);
    stream.simple_code(constants.literal_alphabet_len, &.{ 'a', 'b' }, false);
    stream.simple_code(constants.literal_alphabet_len, &.{'x'}, false);
    // Symbol 136 takes the code 0 and symbol 146 the code 1; 'a' the code 0 and 'b' 1.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{ short_copy_symbol, empty_word_symbol }, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{empty_word_distance_code}, false);
    stream.put_code(1, 1);
    stream.put_code(0, 1);
    stream.put_code(1, 1);
    stream.put(empty_word_distance - 1 - empty_word_offset, empty_word_extra_bits);
    stream.put_code(0, 1);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a word of no octets leaves p1 and p2 for the next literal's context" {
    // The contexts before the word, and p1 with any other p2, take the other tree.
    const after_word = context.literal_id(.utf8, 'b', 'a');
    try testing.expect(after_word != context.literal_id(.utf8, 0, 0) and after_word != context.literal_id(.utf8, 'a', 0));
    try testing.expect(after_word != context.literal_id(.utf8, 'b', 0));
    var word: [constants.transformed_word_len_max]u8 = undefined;
    try testing.expectEqual(0, transform.apply(omit_last_4, dictionary.word(short_word_len, 0), &word));
    var stream: Stream = .{};
    empty_word_stream(&stream);
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqualStrings(empty_word_output, output[0..whole.written]);
}

/// Symbol 64, no literals and copy code 8, a copy of 10 or 11 at the last distance, 4, with 1 extra
/// bit (RFC 7932 §5): with nothing produced, word 3 of length 10 (§8). Then symbol 136, the literal
/// 'b' and a copy the meta-block's end cuts off. A word takes no bits of its own, and a loop that
/// took the command's extra bits again would read the second symbol and 'b' a bit late.
const last_word_symbol = 64;
const last_word_copy_code = 8;
const last_word_len = 10;
const last_word_index = constants.last_distances_initial[0] - 1;

fn last_word_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, last_word_len + 1);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{ 'a', 'b' }, false);
    // Symbol 64 takes the code 0 and symbol 136 the code 1; 'a' the code 0 and 'b' 1.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{ last_word_symbol, short_copy_symbol }, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{0}, false);
    stream.put_code(0, 1);
    stream.put(last_word_len - constants.copy_length_codes[last_word_copy_code].base, constants.copy_length_codes[last_word_copy_code].extra_bits);
    stream.put_code(1, 1);
    stream.put_code(1, 1);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a word at the last distance takes no bits of its own" {
    // Copy code 8 gives 10 or 11 with 1 extra bit.
    try testing.expectEqual(last_word_len, constants.copy_length_codes[last_word_copy_code].base);
    try testing.expectEqual(1, constants.copy_length_codes[last_word_copy_code].extra_bits);
    var stream: Stream = .{};
    last_word_stream(&stream);
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    const word = dictionary.word(last_word_len, last_word_index);
    try testing.expectEqualSlices(u8, word, output[0..last_word_len]);
    try testing.expectEqualStrings("b", output[last_word_len..whole.written]);
}

/// Two distance block types (RFC 7932 §6), the first for one distance: symbol 130, no literals and
/// a copy of 4 at the direct distance 1 past nothing produced, word 0 of length 4 (§8), whose
/// distance takes the first block's element; then symbol 128, a copy of 2, whose distance switches
/// to the second type, whose tree names distance 2 where the first's names 1. NDIRECT 2 (§4).
const counted_word_symbol = 130;
const counted_copy_symbol = 128;
const counted_direct_high = 2;
const counted_alphabet_len = constants.distance_short_codes_count + counted_direct_high + constants.distance_code_groups;
const counted_copy_len = 2;

fn counted_word_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, short_word_len + counted_copy_len);
    stream.count(1);
    stream.count(1);
    // NBLTYPESD 2: the block type code of symbol 1, the next type; the count code of symbol 0, whose
    // 2 extra bits give 1 to 4; the first block's count, 1.
    stream.count(constants.block_switch_types_min);
    stream.simple_code(constants.block_switch_types_min + constants.block_type_symbol_offset, &.{1}, false);
    stream.simple_code(constants.block_count_alphabet_len, &.{0}, false);
    stream.put(0, constants.block_count_codes[0].extra_bits);
    stream.put(0, constants.postfix_field_bits);
    stream.put(counted_direct_high, constants.direct_field_bits);
    stream.put(0, constants.context_mode_bits);
    stream.count(1);
    // NTREESD 2: each block type's contexts take the tree of its number, from a code of the values
    // 0 and 1, 1 bit each.
    stream.count(constants.context_map_trees_min);
    stream.put(0, 1);
    stream.simple_code(constants.context_map_trees_min, &.{ 0, 1 }, false);
    for (0..constants.distance_contexts_count) |_| stream.put_code(0, 1);
    for (0..constants.distance_contexts_count) |_| stream.put_code(1, 1);
    stream.put(0, 1);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    // Symbol 128 takes the code 0 and symbol 130 the code 1.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{ counted_copy_symbol, counted_word_symbol }, false);
    stream.simple_code(counted_alphabet_len, &.{constants.distance_short_codes_count}, false);
    stream.simple_code(counted_alphabet_len, &.{constants.distance_short_codes_count + 1}, false);
    stream.put_code(1, 1);
    // The second symbol, then the switch: its type code takes no bits, its count 2 extra bits.
    stream.put_code(0, 1);
    stream.put(0, constants.block_count_codes[0].extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a word's distance takes its block's element" {
    var stream: Stream = .{};
    counted_word_stream(&stream);
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    const word = dictionary.word(short_word_len, 0);
    try testing.expectEqualSlices(u8, word, output[0..short_word_len]);
    // Distance 2 repeats the word's last two octets.
    try testing.expectEqualSlices(u8, word[short_word_len - counted_copy_len ..], output[short_word_len..whole.written]);
}

/// Symbol 140, the literal 'a' and a copy of 6 past the one octet produced (RFC 7932 §5): word 0 of
/// length 6 with transform 70, whose reference, the transform above NDBITS 11, makes the distance
/// 143,362 (§8). With NPOSTFIX and NDIRECT 0 that is the distance code 46, 16 extra bits over the
/// offset (2 << 16) - 4 (§4): more extra bits than any shorter distance takes.
const far_word_symbol = 140;
const far_word_len = 6;
const far_word_transform = 70;
const far_word_id = far_word_transform << dictionary.bits[far_word_len];
const far_word_distance = 1 + 1 + far_word_id;
const far_word_distance_code = 46;
const far_word_extra_bits = 16;
const far_word_offset = (constants.coded_distance_base << far_word_extra_bits) - constants.coded_distance_bias;

fn far_word_stream(stream: *Stream, output_len: u32) void {
    stream.window_bits_16();
    stream.meta_block(true, output_len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'a'}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{far_word_symbol}, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{far_word_distance_code}, false);
    stream.put(far_word_distance - 1 - far_word_offset, far_word_extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a word whose distance takes 16 extra bits decodes on the fast path" {
    var word: [constants.transformed_word_len_max]u8 = undefined;
    const word_len = transform.apply(far_word_transform, dictionary.word(far_word_len, 0), &word);
    var stream: Stream = .{};
    far_word_stream(&stream, @intCast(1 + word_len));
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(codec.Features.detect());
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqual('a', output[0]);
    try testing.expectEqualSlices(u8, word[0..word_len], output[1..whole.written]);
}

/// `prefixed_pairs` pairs of commands of no literals (RFC 7932 §5). First symbol 130, a copy of 4 at
/// a distance past every octet produced: with 37k octets produced, word 1023 - 37k of length 4 with
/// transform 41, the prefix " the " and no suffix, 9 octets (§8, Appendix B); with NPOSTFIX and
/// NDIRECT 0 that distance is the code 42, 14 extra bits over the offset (2 << 14) - 4 (§4). Then
/// symbol 196, a copy of 28, copy code 12 and 3 extra bits, at the distance code 0, the last
/// distance, 4 (§4): the word's last 4 octets, repeated. `transform.apply_wide` copies
/// `transform.body_copy_len` octets after the prefix, 1 octet more than a command of 4 octets and
/// the two chunks kept past it take, and the copy brings a word to every room from 36 octets up:
/// only the check of a word's own room keeps that octet inside the output, in the loop and in the
/// Zig the loop leaves the word to.
const prefixed_word_symbol = 130;
const prefixed_copy_symbol = 196;
const prefixed_word_transform = 41;
const prefixed_word_prefix = " the ";
const prefixed_word_output_len = prefixed_word_prefix.len + short_word_len;
const prefixed_copy_len = 28;
const prefixed_copy_code = 12;
const prefixed_pair_len = prefixed_word_output_len + prefixed_copy_len;
const prefixed_pairs = 28;
const prefixed_word_index_first = (1 << dictionary.bits[short_word_len]) - 1;
const prefixed_word_distance = 1 + (prefixed_word_transform << dictionary.bits[short_word_len]) + prefixed_word_index_first;
const prefixed_word_distance_code = 42;
const prefixed_word_extra_bits = 14;
const prefixed_word_offset = (constants.coded_distance_base << prefixed_word_extra_bits) - constants.coded_distance_bias;
const prefixed_room_past = 512;

fn prefixed_pairs_stream(stream: *Stream) void {
    const copy = constants.copy_length_codes[prefixed_copy_code];
    stream.window_bits_16();
    stream.meta_block(true, prefixed_pairs * prefixed_pair_len);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{'q'}, false);
    // Symbol 130 takes the code 0 and symbol 196 the code 1; the distance code 0 the code 0 and
    // the code 42 the code 1.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{ prefixed_word_symbol, prefixed_copy_symbol }, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{ 0, prefixed_word_distance_code }, false);
    for (0..prefixed_pairs) |_| {
        stream.put_code(0, 1);
        stream.put_code(1, 1);
        stream.put(prefixed_word_distance - 1 - prefixed_word_offset, prefixed_word_extra_bits);
        stream.put_code(1, 1);
        stream.put(prefixed_copy_len - copy.base, copy.extra_bits);
        stream.put_code(0, 1);
    }
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

/// What the pairs write, into `expected`.
fn prefixed_pairs_expected(expected: *[prefixed_pairs * prefixed_pair_len]u8) !void {
    for (0..prefixed_pairs) |pair| {
        const at = pair * prefixed_pair_len;
        const index: u32 = @intCast(prefixed_word_index_first - at);
        var word: [constants.transformed_word_len_max]u8 = undefined;
        const word_len = transform.apply(prefixed_word_transform, dictionary.word(short_word_len, index), &word);
        try testing.expectEqual(prefixed_word_output_len, word_len);
        @memcpy(expected[at..][0..word_len], word[0..word_len]);
        for (at + word_len..at + prefixed_pair_len) |octet| expected[octet] = expected[octet - constants.last_distances_initial[0]];
    }
}

test "words behind a prefix write nothing past any room, in the loop or in the Zig it leaves them to" {
    // The prefix puts the body's copy past the 4 octets of the command and the two chunks.
    try testing.expectEqualStrings(prefixed_word_prefix, transform.table[prefixed_word_transform].prefix);
    try testing.expect(prefixed_word_prefix.len + transform.body_copy_len > short_word_len + constants.copy_chunk_len + constants.copy_chunk_len);
    try testing.expectEqual(prefixed_copy_len, constants.copy_length_codes[prefixed_copy_code].base + 6);
    var stream: Stream = .{};
    prefixed_pairs_stream(&stream);
    var expected: [prefixed_pairs * prefixed_pair_len]u8 = undefined;
    try prefixed_pairs_expected(&expected);
    // Two sentinels, since an octet of DICT may equal one of them.
    for ([_]u8{ 0xff, 0x00 }) |sentinel| {
        var output: [expected.len + prefixed_room_past + prefixed_room_past]u8 = undefined;
        for (0..expected.len + prefixed_room_past + 1) |room| {
            @memset(&output, sentinel);
            var decoder: Decoder = undefined;
            decoder.init(codec.Features.detect());
            const progress = try decoder.decode(stream.written(), output[0..room]);
            const written = @min(room, expected.len);
            try testing.expectEqual(written, progress.written);
            try testing.expectEqualSlices(u8, expected[0..written], output[0..written]);
            for (output[room..]) |octet| try testing.expectEqual(sentinel, octet);
        }
    }
}
