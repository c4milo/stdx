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
