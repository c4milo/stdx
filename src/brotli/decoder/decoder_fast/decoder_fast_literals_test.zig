//! The fast path's literal runs (decoder_fast_literals.zig): a block type whose context mode is not
//! the one the literal tables' entries were built for takes its context IDs from p1 and p2 (RFC
//! 7932 §7.1).

const std = @import("std");
const testing = std.testing;
const decoder_module = @import("../decoder.zig");
const constants = @import("../../constants.zig");
const context = @import("../../context.zig");
const test_stream = @import("../test_stream.zig");
const Stream = test_stream.Stream;
const trailer = test_stream.trailer;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const CheckedDecoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits, .paths = .{ .fast_paths = false } });
const fast = @import("decoder_fast.zig");
const test_window_bits = 16;

/// Two literal block types, LSB6 then MSB6, the first for one literal and the second for two (RFC
/// 7932 §6, §7.1), so the entries hold LSB6's parts, the first block type's. Every context of the
/// first type takes tree 0, 'a'. The second type's first literal has p1 'a' and p2 0, the stream's
/// first (RFC 7932 §7.1): MSB6 takes p1, and its context takes tree 0, while the contexts of LSB6's
/// part of 'a' and of MSB6 of p2 take tree 1, 'b'. So the literals are "aaa".
const mixed_literals = "aaa";
const first_tree_literal = 'a';
const second_tree_literal = 'b';
const lsb6_after_a = context.literal_id(.lsb6, first_tree_literal, 0);
const msb6_of_first_p2 = context.literal_id(.msb6, 0, first_tree_literal);

/// Symbol 24: insert length 3 and copy length 2 at the last distance, whose copy the meta-block's
/// end cuts off (RFC 7932 §5, §9.3).
const three_literals_symbol = 24;

/// The first block count, 1, and the second block's, 2: count code 0, 1 and 2 extra bits (RFC 7932
/// §6).
const second_count_extra = 1;

/// NTREESL 2 and the literal context map (RFC 7932 §7.3): no run-length codes, a code of the values
/// 0 and 1, which takes 1 bit each, and no inverse move-to-front transform.
fn mixed_literal_map(stream: *Stream) void {
    stream.count(constants.context_map_trees_min);
    stream.put(0, 1);
    stream.simple_code(constants.context_map_trees_min, &.{ 0, 1 }, false);
    for (0..constants.literal_contexts_count) |_| stream.put_code(0, 1);
    for (0..constants.literal_contexts_count) |id| stream.put_code(@intFromBool(id == lsb6_after_a or id == msb6_of_first_p2), 1);
    stream.put(0, 1);
}

fn mixed_modes_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, mixed_literals.len);
    stream.count(constants.block_switch_types_min);
    stream.simple_code(constants.block_switch_types_min + constants.block_type_symbol_offset, &.{1}, false);
    stream.simple_code(constants.block_count_alphabet_len, &.{0}, false);
    stream.put(0, constants.block_count_codes[0].extra_bits);
    stream.count(1);
    stream.count(1);
    stream.put(0, constants.postfix_field_bits);
    stream.put(0, constants.direct_field_bits);
    stream.put(@intFromEnum(context.Mode.lsb6), constants.context_mode_bits);
    stream.put(@intFromEnum(context.Mode.msb6), constants.context_mode_bits);
    mixed_literal_map(stream);
    stream.count(1);
    stream.simple_code(constants.literal_alphabet_len, &.{first_tree_literal}, false);
    stream.simple_code(constants.literal_alphabet_len, &.{second_tree_literal}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{three_literals_symbol}, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{0}, false);
    // Each code has one symbol and takes no bits: the first literal, then the switch to the second
    // type, its count's extra bits, and the two literals.
    stream.put(second_count_extra, constants.block_count_codes[0].extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
}

test "a block type of another mode than the entries' takes its own context IDs" {
    var stream: Stream = .{};
    mixed_modes_stream(&stream);
    // Room past the stream's octets, so that the fast path's margin holds.
    var output: [512]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const whole = try decoder.decode_all(stream.written(), &output);
    try testing.expectEqualStrings(mixed_literals, output[0..whole.written]);
}

/// Two literal block types: the first of one tree, 'a' and ' ' at 1 bit each, for four literals
/// "aaa "; the second in UTF8 mode, whose context map names tree 1, 'y', at the one context p1 ' '
/// and p2 'a' give (RFC 7932 §7.1, §7.3), and tree 0 elsewhere. So the second type's literal is 'y'
/// only with p2 as the first block's run left it; p2's part of the ID differs from p1's. The command
/// is symbol 40, insert length 5 and copy code 0, whose copy the meta-block's end cuts off.
const one_tree_literals = "aaa ";
const one_tree_symbols = [_]u16{ ' ', 'a' };
const utf8_tree_literal = 'y';
const five_literals_symbol = 40;
const first_block_count_extra = 3;
/// The run's last two literals, p1 and p2 of the next (RFC 7932 §7.1).
const run_p1 = one_tree_literals[one_tree_literals.len - 1];
const run_p2 = one_tree_literals[one_tree_literals.len - context_octets];
const context_octets = 2;
const utf8_after_run = context.literal_id(.utf8, run_p1, run_p2);

fn one_tree_then_utf8_stream(stream: *Stream) void {
    stream.window_bits_16();
    stream.meta_block(true, one_tree_literals.len + 1);
    stream.count(constants.block_switch_types_min);
    stream.simple_code(constants.block_switch_types_min + constants.block_type_symbol_offset, &.{1}, false);
    stream.simple_code(constants.block_count_alphabet_len, &.{0}, false);
    stream.put(first_block_count_extra, constants.block_count_codes[0].extra_bits);
    stream.count(1);
    stream.count(1);
    stream.put(0, constants.postfix_field_bits);
    stream.put(0, constants.direct_field_bits);
    stream.put(@intFromEnum(context.Mode.lsb6), constants.context_mode_bits);
    stream.put(@intFromEnum(context.Mode.utf8), constants.context_mode_bits);
    stream.count(constants.context_map_trees_min);
    stream.put(0, 1);
    stream.simple_code(constants.context_map_trees_min, &.{ 0, 1 }, false);
    for (0..constants.literal_contexts_count) |_| stream.put_code(0, 1);
    for (0..constants.literal_contexts_count) |id| stream.put_code(@intFromBool(id == utf8_after_run), 1);
    stream.put(0, 1);
    stream.count(1);
    stream.simple_code(constants.literal_alphabet_len, &one_tree_symbols, false);
    stream.simple_code(constants.literal_alphabet_len, &.{utf8_tree_literal}, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{five_literals_symbol}, false);
    stream.simple_code(constants.distance_short_codes_count + constants.distance_code_groups, &.{0}, false);
    // The symbol takes no bits; the first block's literals 1 bit each, in the order of the two
    // symbols' values; then the switch, its count's extra bits, and the second type's literal of no
    // bits.
    for (one_tree_literals) |literal| stream.put_code(@intFromBool(literal == one_tree_symbols[1]), 1);
    stream.put(0, constants.block_count_codes[0].extra_bits);
    stream.bit_len = std.mem.alignForward(usize, stream.bit_len, @bitSizeOf(u8));
    for (trailer) |octet| stream.put(octet, @bitSizeOf(u8));
    for (0..fast.input_slack) |_| stream.put(0, @bitSizeOf(u8));
}

test "a block type of one tree leaves p1 and p2 for the context of the next block type's literals" {
    // p2's part of the context ID tells ' ' from 'a', so a p2 left as p1 picks another tree.
    try testing.expect(context.p2_part(.utf8, run_p1) != context.p2_part(.utf8, run_p2));
    var stream: Stream = .{};
    one_tree_then_utf8_stream(&stream);
    const input = stream.written();
    const expected = one_tree_literals ++ [_]u8{utf8_tree_literal};
    // A room past the margin, so that the fast path takes the first block's run.
    var output: [fast.output_margin + expected.len]u8 = undefined;
    var decoder: Decoder = undefined;
    decoder.init(.{});
    const progress = try decoder.decode(input, &output);
    try testing.expectEqual(expected.len, progress.written);
    try testing.expectEqualSlices(u8, expected, output[0..expected.len]);
    var checked: CheckedDecoder = undefined;
    checked.init(.{});
    var checked_output: [output.len]u8 = undefined;
    const checked_progress = try checked.decode(input, &checked_output);
    try testing.expectEqual(checked_progress.written, progress.written);
    try testing.expectEqualSlices(u8, checked_output[0..checked_progress.written], output[0..progress.written]);
}
