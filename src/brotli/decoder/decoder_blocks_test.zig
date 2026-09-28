//! Compressed meta-blocks written by hand for the parts of a meta-block the fixtures do not reach:
//! block switches (RFC 7932 §6), the ring of last distances (§4), and distance contexts (§7.2).

const std = @import("std");
const testing = std.testing;
const decoder_module = @import("decoder.zig");
const constants = @import("../constants.zig");
const Stream = @import("test_stream.zig").Stream;

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;
const output_len_max = 64;

fn expect_decoded(expected: []const u8, stream: []const u8) !void {
    var decoder: Decoder = undefined;
    decoder.init(.{});
    var output: [output_len_max]u8 = undefined;
    const whole = try decoder.decode_all(stream, &output);
    try testing.expectEqual(stream.len, whole.consumed);
    try testing.expectEqualStrings(expected, output[0..whole.written]);
}

test "block switches take the next type, wrap to 0, go back to the previous, and name a type" {
    var stream: Stream = .{};
    stream.window_bits_16();
    stream.meta_block(true, 6);
    // Three literal block types: type codes 1, 0 and 3, of 1, 2 and 2 bits; one count code, 0,
    // whose counts are 1 to 4; and a first block count of 1.
    stream.count(3);
    stream.simple_code(5, &.{ 1, 0, 3 }, false);
    stream.simple_code(constants.block_count_alphabet_len, &.{0}, false);
    stream.put(0, 2);
    stream.count(1);
    stream.count(1);
    stream.put(0, 2 + 4);
    for (0..3) |_| stream.put(0, 2);
    // Three literal trees, block type t mapped to tree t in all 64 contexts; one distance tree.
    stream.count(3);
    stream.put(0, 1);
    stream.simple_code(3, &.{ 0, 1, 2 }, false);
    for (0..64) |_| stream.put_code(0b0, 1);
    for (0..64) |_| stream.put_code(0b10, 2);
    for (0..64) |_| stream.put_code(0b11, 2);
    stream.put(0, 1);
    stream.count(1);
    for ("abc") |literal| stream.simple_code(constants.literal_alphabet_len, &.{literal}, false);
    // 6 << 3: insert code 6, whose one extra bit gives 6 or 7, and the last distance.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{6 << 3}, false);
    stream.simple_code(64, &.{0}, false);
    stream.put(0, 1);
    // Type 0 for 'a'; then code 1 thrice: types 1, 2 and 0; code 0: the previous type, 2; code 3:
    // type 1. Each count code takes 2 extra bits of 0, a count of 1.
    const switches = [_]struct { u32, u5 }{ .{ 0b0, 1 }, .{ 0b0, 1 }, .{ 0b0, 1 }, .{ 0b10, 2 }, .{ 0b11, 2 } };
    for (switches) |code| {
        stream.put_code(code[0], code[1]);
        stream.put(0, 2);
    }
    try expect_decoded("abcacb", stream.written());
}

test "the distance code 0 leaves the ring of last distances as it was" {
    var stream: Stream = .{};
    stream.window_bits_16();
    stream.meta_block(true, 9);
    stream.simple_header(0, 1, 0);
    // Literals a to d take 2 bits each; each command inserts one and copies 2.
    stream.simple_code(constants.literal_alphabet_len, &.{ 'a', 'b', 'c', 'd' }, false);
    stream.simple_code(constants.insert_copy_alphabet_len, &.{128 + (1 << 3)}, false);
    // Distance codes 16 (distance 1, NDIRECT 1), 0 (the last) and 1 (the one before): 0, 10, 11.
    stream.simple_code(65, &.{ 16, 0, 1 }, false);
    // 'b' and distance 1; 'c' and the last, 1 again; 'd' and the one before the last, which
    // distance 1 pushed and code 0 did not: 4, the initial last distance.
    stream.put_code(0b01, 2);
    stream.put_code(0b0, 1);
    stream.put_code(0b10, 2);
    stream.put_code(0b10, 2);
    stream.put_code(0b11, 2);
    stream.put_code(0b11, 2);
    try expect_decoded("bbbcccdcc", stream.written());
}

test "a distance's context picks its tree from the copy length" {
    var stream: Stream = .{};
    stream.window_bits_16();
    stream.meta_block(true, 5);
    for (0..3) |_| stream.count(1);
    stream.put(0, 2);
    stream.put(2, 4);
    stream.put(0, 2);
    stream.count(1);
    // Two distance trees: contexts 0 and 1, copy lengths 2 and 3, take tree 0; 2 and 3 take tree 1.
    stream.count(2);
    stream.put(0, 1);
    stream.simple_code(2, &.{ 0, 1 }, false);
    for ([_]u32{ 0, 0, 1, 1 }) |value| stream.put_code(value, 1);
    stream.put(0, 1);
    stream.simple_code(constants.literal_alphabet_len, &.{ 'a', 'b' }, false);
    // Insert 2 and copy 3: 128 + (2 << 3) + 1.
    stream.simple_code(constants.insert_copy_alphabet_len, &.{128 + (2 << 3) + 1}, false);
    // With NDIRECT 2, tree 0's code 16 is distance 1 and tree 1's code 17 distance 2.
    stream.simple_code(66, &.{16}, false);
    stream.simple_code(66, &.{17}, false);
    stream.put_code(0, 1);
    stream.put_code(1, 1);
    try expect_decoded("abbbb", stream.written());
}
