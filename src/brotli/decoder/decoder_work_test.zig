//! Invariant 17's check for the brotli decoder, on decision 15's worst cases:
//!
//! - a literal context map of 256 block types and 256 trees whose inverse move-to-front moves 255
//!   values for each entry: the most work per bit consumed, and the most in one call;
//! - a block switch before every insert-and-copy symbol, literal and distance (claim B3);
//! - 256 insert-and-copy codes, each a complex code of 12 bits: the most work per bit of a prefix
//!   code;
//! - literals that take no bits;
//! - commands whose dictionary word a transform empties, which write nothing.
//!
//! The decoder's count of symbols decoded and entries written is what each stream asks for, and
//! stays within `constants.work_per_octet_max` per octet consumed, `constants.work_per_written_max`
//! per octet written and `constants.work_per_call_max` per call.

const std = @import("std");
const testing = std.testing;
const decoder_module = @import("decoder.zig");
const constants = @import("../constants.zig");
const dictionary = @import("../dictionary.zig");
const state_module = @import("decoder_state.zig");
const test_stream = @import("test_stream.zig");
const Stream = test_stream.Stream;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;

/// The octets a stream decodes to at most.
const output_len_max = 4096;

/// Whether a call's count stays within invariant 17's bound.
pub fn within_bound(work: u64, consumed: usize, written: usize) bool {
    return work <= constants.work_per_octet_max * consumed + constants.work_per_written_max * written + constants.work_per_call_max;
}

/// Decodes `input` in one call, and requires `expected`, the count `work`, and the bound.
fn expect_whole(input: []const u8, expected: []const u8, work: u64) !void {
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [output_len_max]u8 = undefined;
    const whole = try decoder.decode_all(input, &output);
    try testing.expectEqual(input.len, whole.consumed);
    try testing.expectEqualStrings(expected, output[0..whole.written]);
    try testing.expectEqual(work, decoder.state.work);
    try testing.expect(within_bound(decoder.state.work, whole.consumed, whole.written));
}

/// A lookup table's root, which a code with no code longer than the root's bits fills alone.
const root_len = 1 << constants.table_root_bits;

/// The count of a simple code of one symbol: the symbol, and the root, whose every entry names it.
const single_code_work = 1 + root_len;

/// The count of a simple code of two symbols: the symbols, and the root.
const pair_code_work = constants.code_symbols_min + root_len;

/// The literal the streams write, and the one the second tree of the second worst case writes.
const literal = 'a';
const second_literal = 'b';

/// The distance alphabet of NPOSTFIX 0 and NDIRECT 0 (RFC 7932 §4).
const distance_alphabet_len = constants.distance_short_codes_count + constants.distance_code_groups;

/// The insert-and-copy symbol 8: insert length 1, copy length 2 and the last distance, whose copy
/// a meta-block that ends after the literal ignores (RFC 7932 §5, §9.3).
const insert_one_symbol = 8;

/// A command of one literal that ends its meta-block: its insert-and-copy symbol and its literal.
const one_literal_command_work = 1 + 1;

/// The block type code's symbol 1, the type after the current one, and the block count code's
/// symbol 0, whose 2 extra bits give the counts 1 to 4 (RFC 7932 §6).
const next_type_symbol = 1;
const first_count_code = 0;
const count_extra_bits = constants.block_count_codes[first_count_code].extra_bits;

/// NBLTYPES `types_count` for a category, a block type code and a block count code of one symbol
/// each, the next type and counts of 1 when the extra bits are 0, and a first block count of 1.
fn switching_category(stream: *Stream, types_count: u16) void {
    stream.count(types_count);
    stream.simple_code(types_count + constants.block_type_symbol_offset, &.{next_type_symbol}, false);
    stream.simple_code(constants.block_count_alphabet_len, &.{first_count_code}, false);
    stream.put(0, count_extra_bits);
}

/// The count of `switching_category`: its two codes, and its first count's symbol.
const switching_category_work = single_code_work + single_code_work + 1;

/// NPOSTFIX 0 and NDIRECT's high bits `direct_high`, then a context mode of LSB6 for each of
/// `literal_types` literal block types (RFC 7932 §9.2).
fn distance_parameters_and_modes(stream: *Stream, direct_high: u4, literal_types: usize) void {
    stream.put(0, constants.postfix_field_bits);
    stream.put(direct_high, constants.direct_field_bits);
    for (0..literal_types) |_| stream.put(0, constants.context_mode_bits);
}

/// A context map of one tree, which a meta-block writes as NTREES 1, and its count: the entries
/// cleared, 64 for one literal block type and 4 for one distance block type.
const one_tree_maps_work = constants.literal_contexts_count + constants.distance_contexts_count;

/// The first worst case's map: 64 contexts for each of 256 block types.
const moved_map_len = constants.literal_contexts_count * constants.block_types_max;

/// The count of each of its entries: its value, which takes no bits, the 255 values the inverse
/// move-to-front moves before it and the one it moves to the front, and the check that every tree
/// appears.
const moved_entry_work = 1 + constants.trees_max + 1;

/// The first worst case: one literal after a literal context map of 256 block types and 256 trees,
/// whose entries all take the value 255 from a code of one symbol, which takes no bits. Its inverse
/// move-to-front (RFC 7932 §7.3) takes each entry's value from the end of the list and moves the
/// 255 values before it, so the map holds every tree, each in turn. Returns its count.
fn moved_map_stream(stream: *Stream) u64 {
    stream.window_bits_16();
    stream.meta_block(true, 1);
    switching_category(stream, constants.block_types_max);
    stream.count(1);
    stream.count(1);
    distance_parameters_and_modes(stream, 0, constants.block_types_max);
    // NTREESL 256, RLEMAX 0, the map's code of the one symbol 255, and the IMTF bit; NTREESD 1.
    stream.count(constants.trees_max);
    stream.put(0, 1);
    stream.simple_code(constants.trees_max, &.{constants.trees_max - 1}, false);
    stream.put(1, 1);
    stream.count(1);
    for (0..constants.trees_max) |_| stream.simple_code(constants.literal_alphabet_len, &.{literal}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{insert_one_symbol}, false);
    stream.simple_code(distance_alphabet_len, &.{0}, false);
    return switching_category_work + single_code_work + moved_map_len * moved_entry_work + constants.distance_contexts_count +
        constants.trees_max * single_code_work + single_code_work + single_code_work + one_literal_command_work;
}

/// The count of the calls that decode `input` an octet at a time, and the most one call took.
const Calls = struct { work: u64, call_work_max: u64, written: usize };

/// Decodes `input` an octet at a time into room for `output_len`, and requires every call to stay
/// within the bound.
fn decode_by_octets(input: []const u8, output_len: usize) !Calls {
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [output_len_max]u8 = undefined;
    var calls: Calls = .{ .work = 0, .call_work_max = 0, .written = 0 };
    var consumed: usize = 0;
    for (0..input.len + output_len + 1) |_| {
        const before = decoder.state.work;
        const progress = try decoder.decode(input[consumed..@min(consumed + 1, input.len)], output[calls.written..output_len]);
        const call_work = decoder.state.work - before;
        try testing.expect(within_bound(call_work, progress.consumed, progress.written));
        calls.call_work_max = @max(calls.call_work_max, call_work);
        consumed += progress.consumed;
        calls.written += progress.written;
        if (progress.status == .done) {
            calls.work = decoder.state.work;
            return calls;
        }
    }
    return error.TestUnexpectedResult;
}

test "the most moved context map costs the count it asks for, within the bound per call" {
    var stream: Stream = .{};
    const work = moved_map_stream(&stream);
    try expect_whole(stream.written(), "a", work);
    const calls = try decode_by_octets(stream.written(), 1);
    try testing.expectEqual(work, calls.work);
    // The call that takes the IMTF bit moves the whole map, which no one octet pays for: the bound
    // per call does.
    try testing.expect(calls.call_work_max >= moved_map_len * constants.trees_max);
    try testing.expect(calls.call_work_max > constants.work_per_octet_max);
}

/// The second worst case's commands, and the octets each writes: its literal, copied twice.
const switched_commands = 64;
const switched_command_len = 3;

/// The insert-and-copy symbol 136: insert length 1, copy length 2 and a distance code (RFC 7932
/// §5).
const insert_one_coded_symbol = 136;

/// NDIRECT 1, whose direct distance code 16 is the distance 1 (RFC 7932 §4), and the distance
/// alphabet it gives with NPOSTFIX 0.
const one_direct = 1;
const direct_distance_code = constants.distance_short_codes_count;
const one_direct_alphabet_len = distance_alphabet_len + one_direct;

/// A context map of two trees for two block types of `contexts_count` contexts each: RLEMAX 0, a
/// code of the values 0 and 1, the first type's contexts 0 and the second's 1, and no IMTF.
fn split_map(stream: *Stream, contexts_count: usize) void {
    stream.count(constants.context_map_trees_min);
    stream.put(0, 1);
    stream.simple_code(constants.context_map_trees_min, &.{ 0, 1 }, false);
    for (0..contexts_count) |_| stream.put_code(0, 1);
    for (0..contexts_count) |_| stream.put_code(1, 1);
    stream.put(0, 1);
}

/// The count of `split_map`: its code, then for each entry its value and the check.
fn split_map_work(contexts_count: usize) u64 {
    return pair_code_work + constants.block_switch_types_min * contexts_count * (1 + 1);
}

/// The second worst case (claim B3): two block types in each category, whose blocks are one symbol
/// long, so that a block switch comes before every insert-and-copy symbol, literal and distance but
/// the first of each. Type 0 takes literal tree 0, 'a', and distance tree 0; type 1 the trees 1,
/// 'b'. Every command writes its literal and copies it twice from distance 1. Returns its count.
fn switched_stream(stream: *Stream) u64 {
    stream.window_bits_16();
    stream.meta_block(true, switched_commands * switched_command_len);
    for (0..state_module.categories_count) |_| switching_category(stream, constants.block_switch_types_min);
    distance_parameters_and_modes(stream, one_direct, constants.block_switch_types_min);
    split_map(stream, constants.literal_contexts_count);
    split_map(stream, constants.distance_contexts_count);
    stream.simple_code(constants.literal_alphabet_len, &.{literal}, false);
    stream.simple_code(constants.literal_alphabet_len, &.{second_literal}, false);
    for (0..constants.block_switch_types_min) |_| stream.simple_code(constants.insert_copy_alphabet_len, &.{insert_one_coded_symbol}, false);
    for (0..constants.block_switch_types_min) |_| stream.simple_code(one_direct_alphabet_len, &.{direct_distance_code}, false);
    // After the first command, each command's three block switches: types of no bits, and counts
    // of 1 in their extra bits.
    for (1..switched_commands) |_| stream.put(0, state_module.categories_count * count_extra_bits);
    const header_work = state_module.categories_count * switching_category_work + split_map_work(constants.literal_contexts_count) +
        split_map_work(constants.distance_contexts_count) + state_module.categories_count * constants.block_switch_types_min * single_code_work;
    // Each command's three symbols, and every block switch's type and count.
    const command_symbols = state_module.categories_count;
    const switch_symbols = state_module.categories_count * (1 + 1);
    return header_work + switched_commands * command_symbols + (switched_commands - 1) * switch_symbols;
}

test "a block switch before every symbol builds no table: each costs its two symbols alone" {
    var stream: Stream = .{};
    const work = switched_stream(&stream);
    var expected: [switched_commands * switched_command_len]u8 = undefined;
    for (0..switched_commands) |command| @memset(expected[command * switched_command_len ..][0..switched_command_len], "ab"[command % 2]);
    try expect_whole(stream.written(), &expected, work);
}

/// The third worst case's first octets, in an uncompressed meta-block, and the 2 it copies.
const history = "abcd";
const copied_len = 2;

/// A complex code of 12 bits: HSKIP 0, the code length code's lengths 1 for the code lengths 1 and
/// 2, the first two in its order, and the code lengths 1 for the symbols 0 and 1 (RFC 7932 §3.5).
const code_length_lengths = [_]u8{ 1, 1 };
const code_lengths = [_]test_stream.LengthSymbol{ .{ .symbol = 1 }, .{ .symbol = 1 } };

/// Its count: the code length code's lengths cleared and its two read, its table, the alphabet's
/// lengths cleared, its two code lengths read, and the root.
const complex_code_work = constants.code_length_alphabet_len + code_length_lengths.len + constants.code_length_table_len +
    constants.insert_copy_alphabet_len + code_lengths.len + root_len;

/// A literal code whose code lengths skip 97 symbols in three repeats of zeros, then give 'a' and
/// 'b' 1 bit each: HSKIP 0, and the code length code's lengths 1 for the code lengths 1 and 17, the
/// first and the seventh in its order (RFC 7932 §3.5). The repeats reach 3, then 8 * (3 - 2) + 3 +
/// 2 = 13, then 8 * (13 - 2) + 3 + 6 = 97.
const second_repeat_extra = 2;
const third_repeat_extra = 6;
const repeated_zeros = literal;
const repeated_code_length_lengths = [_]u8{ 1, 0, 0, 0, 0, 0, 1 };
const repeated_code_lengths = [_]test_stream.LengthSymbol{
    .{ .symbol = constants.repeat_zero_symbol },
    .{ .symbol = constants.repeat_zero_symbol, .extra = second_repeat_extra },
    .{ .symbol = constants.repeat_zero_symbol, .extra = third_repeat_extra },
    .{ .symbol = 1 },
    .{ .symbol = 1 },
};

/// Its count: the code length code's lengths cleared and its seven read, its table, the alphabet's
/// lengths cleared, its five symbols, the zeros its repeats write, and the root.
const repeated_code_work = constants.code_length_alphabet_len + repeated_code_length_lengths.len + constants.code_length_table_len +
    constants.literal_alphabet_len + repeated_code_lengths.len + repeated_zeros + root_len;

/// The third worst case: after `history`, a meta-block of 256 insert-and-copy block types, each
/// type's code a complex code of 12 bits, and a literal code of repeats. Symbol 0, insert length 0
/// and copy length 2 at the last distance, 4, copies the first two octets. Returns its count.
fn complex_codes_stream(stream: *Stream) u64 {
    stream.window_bits_16();
    stream.uncompressed(history);
    stream.meta_block(true, copied_len);
    stream.count(1);
    switching_category(stream, constants.block_types_max);
    stream.count(1);
    distance_parameters_and_modes(stream, 0, 1);
    stream.count(1);
    stream.count(1);
    stream.complex_code(0, &repeated_code_length_lengths, &repeated_code_lengths);
    for (0..constants.block_types_max) |_| stream.complex_code(0, &code_length_lengths, &code_lengths);
    stream.simple_code(distance_alphabet_len, &.{0}, false);
    stream.put_code(0, 1);
    return switching_category_work + one_tree_maps_work + repeated_code_work + constants.block_types_max * complex_code_work + single_code_work + 1;
}

test "256 complex codes of 12 bits cost the count they ask for, within the bound" {
    var stream: Stream = .{};
    const work = complex_codes_stream(&stream);
    try expect_whole(stream.written(), "abcdab", work);
}

/// The fourth worst case's literals, and its insert-and-copy symbol 488: insert code 21, whose
/// lengths are 2114 and 12 extra bits, and copy length 2 (RFC 7932 §5).
const free_literals = output_len_max;
const free_insert_symbol = 488;
const free_insert_code = 21;

/// The fourth worst case: one command of `free_literals` literals whose code has one symbol, so that
/// none takes a bit. Returns the count of all but the literals.
fn free_literals_stream(stream: *Stream) u64 {
    stream.window_bits_16();
    stream.meta_block(true, free_literals);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{literal}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{free_insert_symbol}, false);
    stream.simple_code(distance_alphabet_len, &.{0}, false);
    const insert = constants.insert_length_codes[free_insert_code];
    stream.put(free_literals - insert.base, insert.extra_bits);
    return one_tree_maps_work + single_code_work + single_code_work + single_code_work + 1;
}

test "literals of no bits cost one each, the bound per octet written" {
    var stream: Stream = .{};
    const header_work = free_literals_stream(&stream);
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [free_literals]u8 = undefined;
    // With no room, the call takes the whole stream and stops at the first literal.
    const first = try decoder.decode(stream.written(), output[0..0]);
    try testing.expectEqual(.needs_room, first.status);
    try testing.expectEqual(stream.written().len, first.consumed);
    try testing.expectEqual(header_work, decoder.state.work);
    const rest = try decoder.decode("", &output);
    try testing.expectEqual(.done, rest.status);
    try testing.expectEqual(free_literals, rest.written);
    try testing.expectEqual(header_work + free_literals, decoder.state.work);
    // The call takes no input and follows no bits, so the bound per octet written alone pays.
    try testing.expect(free_literals <= constants.work_per_written_max * rest.written);
    for (output) |octet| try testing.expectEqual(literal, octet);
}

/// The fifth worst case's commands, which write nothing.
const empty_commands = 100;

/// The insert-and-copy symbol 130: insert length 0, copy length 4 and a distance code (RFC 7932 §5).
const empty_word_symbol = 130;
const empty_word_len = constants.word_len_min;

/// Transform 54, OmitFirst9, which leaves nothing of a word of 4 (RFC 7932 Appendix B).
const omit_first_nine = 54;

/// Distance code 43, with NPOSTFIX 0 and NDIRECT 0: 14 extra bits over ((2 + 1) << 14) - 4 + 1
/// (RFC 7932 §4). With nothing produced, the distance d names word d - 1 (RFC 7932 §8): transform
/// `omit_first_nine` of word 0 of length 4.
const empty_word_distance_code = 43;
const empty_word_extra_bits = 14;
const empty_word_distance_base = 49149;
const empty_word_distance = (omit_first_nine << dictionary.bits[empty_word_len]) + 1;

/// The fifth worst case's header: one block type in each category, and codes of one symbol but
/// the insert-and-copy code, whose symbol 8 takes the code 0 and symbol 130 the code 1.
fn empty_words_header(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, 1);
    stream.simple_header(0, 0, 0);
    stream.simple_code(constants.literal_alphabet_len, &.{literal}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{ insert_one_symbol, empty_word_symbol }, false);
    stream.simple_code(distance_alphabet_len, &.{empty_word_distance_code}, false);
}

/// The fifth worst case: `empty_commands` commands whose dictionary word transform 54 empties, then
/// a command of one literal. The insert-and-copy code takes 1 bit, the literal and distance codes
/// none. Returns its count.
fn empty_words_stream(stream: *Stream) u64 {
    empty_words_header(stream);
    for (0..empty_commands) |_| {
        stream.put_code(1, 1);
        stream.put(empty_word_distance - empty_word_distance_base, empty_word_extra_bits);
    }
    stream.put_code(0, 1);
    // Each empty command's insert-and-copy symbol and distance.
    const empty_command_work = 1 + 1;
    return one_tree_maps_work + single_code_work + pair_code_work + single_code_work +
        empty_commands * empty_command_work + one_literal_command_work;
}

test "commands that write nothing cost their symbols, and their distances' bits pay for them" {
    var stream: Stream = .{};
    const work = empty_words_stream(&stream);
    try expect_whole(stream.written(), "a", work);
    const calls = try decode_by_octets(stream.written(), 1);
    try testing.expectEqual(work, calls.work);
    try testing.expectEqual(1, calls.written);
}

test "a category of one block type never switches, however many commands write nothing" {
    // RFC 7932 §9.3 reads no block switch in a category of one block type, whose count §10 starts
    // at 16,777,216. Commands of empty words write nothing, so a meta-block may hold more of them:
    // the counts here are where 16,777,215 of them would leave the insert-and-copy and distance
    // categories.
    var header: Stream = .{};
    empty_words_header(&header);
    var stream: Stream = .{};
    _ = empty_words_stream(&stream);
    const header_len = header.bit_len / @bitSizeOf(u8);
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [1]u8 = undefined;
    const first = try decoder.decode(stream.written()[0..header_len], &output);
    try testing.expectEqual(.needs_input, first.status);
    for ([_]state_module.Category{ .insert_copy, .distance }) |category| decoder.state.blocks[@intFromEnum(category)].count_left = 1;
    const whole = try decoder.decode_all(stream.written()[first.consumed..], &output);
    try testing.expectEqualStrings("a", output[0..whole.written]);
    try testing.expectEqual(1, decoder.state.blocks[@intFromEnum(state_module.Category.insert_copy)].count_left);
}
