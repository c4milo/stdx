//! Tests for Huffman-coded literals: RFC 8878 §4.2.1's example tree, seeded trees and streams a
//! test writer encodes, and each refusal. FSE-compressed weights are checked against libzstd's
//! streams by the differential check (design §8 step 11).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const StreamWriter = @import("test_writer.zig").StreamWriter;

test "RFC 8878 §4.2.1's weights give Table 25's codes" {
    // Tables 23 and 24: literals 0 to 4 weigh 4, 3, 2, 0 and 1; literal 5's weight of 1 is deduced.
    // Header 127 + 5 names 5 weights, two to an octet, the first in the top half.
    const description = [_]u8{ constants.huffman_direct_symbols_offset + 5, 0x43, 0x20, 0x10 };
    var table: huffman.Table = undefined;
    try testing.expectEqual(description.len, try huffman.read_tree(&description, &table));
    try testing.expectEqual(4, table.bits_max);
    // Table 25: 4 is 0000, 5 is 0001, 2 is 001, 1 is 01 and 0 is 1.
    const codes = [_]struct { u8, u4, u8 }{ .{ 4, 0b0000, 4 }, .{ 5, 0b0001, 4 }, .{ 2, 0b0010, 3 }, .{ 1, 0b0100, 2 }, .{ 0, 0b1000, 1 } };
    for (codes) |code| {
        const cell = table.cells[code[1]];
        try testing.expectEqual(code[0], cell.symbol);
        try testing.expectEqual(code[2], cell.bits);
    }
}

/// A seeded weight is below this, so the sum of up to 100 of them stays within 11 bits.
const seeded_weight_limit = 6;

/// The draws a seeded literal takes at most to land on one with a nonzero weight.
const literal_draws_max = 1000;

/// Seeded weights for `count` literals, each 0 to 5, then the weights that bring the sum of
/// 2^(Weight-1) within one power of 2 of the next power of 2, which the deduced last weight fills.
fn seeded_weights(generator: *codec.split.Generator, count: u16, weights: *huffman.Weights) void {
    for (weights.values[0..count]) |*weight| weight.* = @intCast(generator.below(seeded_weight_limit));
    weights.values[0] = 1 + weights.values[0];
    weights.written = count;
    var sum: u32 = 0;
    for (weights.values[0..count]) |weight| sum += if (weight > 0) @as(u32, 1) << @intCast(weight - 1) else 0;
    var rest = (@as(u32, 1) << @intCast(std.math.log2_int(u32, sum) + 1)) - sum;
    while (!std.math.isPowerOfTwo(rest)) {
        const lowest = rest & (~rest +% 1);
        weights.values[weights.written] = @intCast(@ctz(lowest) + 1);
        weights.written += 1;
        rest -= lowest;
    }
}

test "seeded trees decode the literals a writer encodes with them" {
    var built: usize = 0;
    for (0..400) |seed| {
        var generator = codec.split.Generator.init(seed);
        var weights: huffman.Weights = undefined;
        seeded_weights(&generator, @intCast(1 + generator.below(100)), &weights);
        var table: huffman.Table = undefined;
        try huffman.build(&weights, &table);
        built += 1;
        var literals: [300]u8 = undefined;
        const count = generator.below(literals.len);
        for (literals[0..count]) |*literal| literal.* = present_literal(&generator, &weights);
        var writer: StreamWriter = .{};
        const stream = writer.write(&table, literals[0..count]);
        var decoded: [300]u8 = undefined;
        try huffman.decode_stream(&table, stream, decoded[0..count]);
        try testing.expectEqualSlices(u8, literals[0..count], decoded[0..count]);
        // One literal too few leaves bits unread; one too many reads past the start.
        if (count > 0) try testing.expectError(error.HuffmanStreamNotConsumed, huffman.decode_stream(&table, stream, decoded[0 .. count - 1]));
        try testing.expectError(error.HuffmanStreamNotConsumed, huffman.decode_stream(&table, stream, decoded[0 .. count + 1]));
    }
    try testing.expectEqual(400, built);
}

/// A seeded literal with a nonzero weight, the deduced last one included.
fn present_literal(generator: *codec.split.Generator, weights: *const huffman.Weights) u8 {
    for (0..literal_draws_max) |_| {
        const literal = generator.below(@as(u64, weights.written) + 1);
        if (weights.values[literal] != 0) return @intCast(literal);
    }
    return 0;
}

test "weights that give a code past 11 bits, or no power of 2, and a last octet of 0 are refused" {
    var table: huffman.Table = undefined;
    // A weight of 12, past Max_Number_of_Bits' 11.
    var heavy: huffman.Weights = .{ .values = undefined, .written = 2 };
    heavy.values[0] = 12;
    heavy.values[1] = 1;
    try testing.expectError(error.HuffmanWeightsInvalid, huffman.build(&heavy, &table));
    // Weights 11 and 11: a sum of 2048, which needs a 12-bit code for the last literal.
    var long: huffman.Weights = .{ .values = undefined, .written = 2 };
    long.values[0] = 11;
    long.values[1] = 11;
    try testing.expectError(error.HuffmanWeightsInvalid, huffman.build(&long, &table));
    // Weights 2, 1 and 1 sum to 4: the next power of 2 is 8, and 4 more is one weight of 3.
    var fitting: huffman.Weights = .{ .values = undefined, .written = 3 };
    fitting.values[0] = 2;
    fitting.values[1] = 1;
    fitting.values[2] = 1;
    try huffman.build(&fitting, &table);
    try testing.expectEqual(3, table.bits_max);
    // Weights 3 and 1 sum to 5: the next power of 2 is 8, and 8 - 5 = 3 is no power of 2.
    var odd: huffman.Weights = .{ .values = undefined, .written = 2 };
    odd.values[0] = 3;
    odd.values[1] = 1;
    try testing.expectError(error.HuffmanWeightsInvalid, huffman.build(&odd, &table));
    try testing.expectError(error.HuffmanStreamUnterminated, huffman.decode_stream(&table, &.{ 0x12, 0 }, &.{}));
    try testing.expectError(error.HuffmanTreeTruncated, huffman.read_tree(&.{ constants.huffman_direct_symbols_offset + 5, 0x43 }, &table));
}
