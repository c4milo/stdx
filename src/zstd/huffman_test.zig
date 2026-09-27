//! Tests for Huffman-coded literals: RFC 8878 §4.2.1's example tree, seeded trees and streams a
//! test writer encodes, and each refusal. FSE-compressed weights are checked against libzstd's
//! streams by the differential check (design §8 step 11).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const fse = @import("fse.zig");
const huffman = @import("huffman.zig");
const test_writer = @import("test_writer.zig");
const StreamWriter = test_writer.StreamWriter;

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

/// Weights 0 to 2 at 0, 31 and 1 of 32 cells (Accuracy_Log 5): the first cell is weight 1 and
/// reads one bit for its next state, and weight 1's cells of the higher states read none (RFC 8878
/// §4.1.1).
const skewed_accuracy_log = 5;
const skewed_probabilities = [_]i16{ 0, (1 << skewed_accuracy_log) - 1, 1 };

fn skewed_weights() fse.Distribution {
    var distribution: fse.Distribution = .{ .probabilities = undefined, .symbol_count = skewed_probabilities.len, .accuracy_log = skewed_accuracy_log };
    @memcpy(distribution.probabilities[0..skewed_probabilities.len], &skewed_probabilities);
    return distribution;
}

/// The octets a tree description takes at most: its header, below 128, and as many after it.
const tree_capacity = constants.huffman_direct_header_min;

/// A tree description of FSE-compressed weights: `distribution`'s description, then `stream`.
fn tree_of(distribution: *const fse.Distribution, stream: []const u8, tree: *[tree_capacity]u8) []const u8 {
    var description: test_writer.DescriptionWriter = .{};
    description.write(distribution);
    const description_len = std.math.divCeil(usize, description.bits_written, @bitSizeOf(u8)) catch unreachable;
    tree[0] = @intCast(description_len + stream.len);
    @memcpy(tree[1..][0..description_len], description.octets[0..description_len]);
    @memcpy(tree[1 + description_len ..][0..stream.len], stream);
    return tree[0 .. 1 + description_len + stream.len];
}

/// A tree description of FSE-compressed weights whose stream holds State1 and State2 both `state`,
/// and after them `ones` bits of 1, which the states' updates read.
fn compressed_tree(distribution: *const fse.Distribution, state: u32, ones: usize, tree: *[tree_capacity]u8) []const u8 {
    var bits: test_writer.BitWriter = .{};
    // Written first, so read last.
    for (0..ones) |_| bits.put(1, 1);
    bits.put(state, distribution.accuracy_log);
    bits.put(state, distribution.accuracy_log);
    return tree_of(distribution, bits.finish(), tree);
}

const WeightTable = fse.Table(constants.huffman_weights_accuracy_log_max);

/// FSE-compressed weights as RFC 8878 §4.2.1.2 reads them, through the checked backward reader:
/// two states taking turns, State1 first, until an update reads past the stream's start, when the
/// other state's weight is the last. The reference the tree's read must agree with.
fn reference_weights(table: *const WeightTable, stream: []const u8, weights: *huffman.Weights) huffman.Error!void {
    // RFC 8878 §4.2.1.2 and §4.2.2: the stream's last octet holds its final 1 bit.
    var reader = codec.BackwardBitReader.init(stream) orelse return error.HuffmanWeightsInvalid;
    var states: [weight_states]u64 = undefined;
    for (&states) |*state| state.* = reader.read(table.accuracy_log);
    weights.init();
    var count: usize = 0;
    for (0..constants.literal_symbols) |_| {
        for (0..states.len) |current| {
            // RFC 8878 §4.2.1.2: at most 255 weights precede the last.
            if (count == constants.literal_symbols - 1) return error.HuffmanWeightsInvalid;
            const cell = table.entries()[@intCast(states[current])];
            weights.put(@intCast(count), cell.symbol);
            count += 1;
            states[current] = cell.baseline + reader.read(@intCast(cell.bits));
            if (!reader.overflowed) continue;
            weights.put(@intCast(count), table.entries()[@intCast(states[states.len - 1 - current])].symbol);
            weights.written = @intCast(count + 1);
            return;
        }
    }
    // RFC 8878 §4.2.1.2: the loop above ends at the 255th weight or earlier.
    return error.HuffmanWeightsInvalid;
}

/// The states that take turns decoding FSE-compressed weights (RFC 8878 §4.2.1.2).
const weight_states = 2;

/// The kinds of seeded weight probability: zero, "less than 1", and a share of the points left, at
/// most half of them.
const weight_probability_kinds = 4;
const share_divisor = 2;

/// A seeded distribution of the 12 weights at an accuracy log of 5 or 6, with zeros and "less than
/// 1" probabilities among them, the last weight taking the points left.
fn seeded_weight_distribution(generator: *codec.split.Generator) fse.Distribution {
    const accuracy_log: u4 = @intCast(constants.accuracy_log_offset + generator.below(constants.huffman_weights_accuracy_log_max + 1 - constants.accuracy_log_offset));
    var distribution: fse.Distribution = .{ .probabilities = @splat(0), .symbol_count = constants.huffman_weight_max + 1, .accuracy_log = accuracy_log };
    var left: i16 = @as(i16, 1) << accuracy_log;
    for (distribution.probabilities[0..constants.huffman_weight_max]) |*probability| {
        if (left <= 1) break;
        probability.* = switch (generator.below(weight_probability_kinds)) {
            0 => 0,
            1 => -1,
            else => @intCast(1 + generator.below(@intCast(@divTrunc(left, share_divisor)))),
        };
        left -= if (probability.* < 0) 1 else probability.*;
    }
    distribution.probabilities[constants.huffman_weight_max] = left;
    return distribution;
}

/// The octets of a seeded weights stream at most, so a tree's description and stream stay below 128.
const seeded_stream_len_max = 64;

test "FSE-compressed weights give their tree, and the count holds the table that decoded them" {
    // State1 and State2 both 0, weight 1; State1's next state then reads past the stream's start,
    // so State2's weight is the last (RFC 8878 §4.2.1.2). Literal 2's weight of 2 is deduced.
    const distribution = skewed_weights();
    var tree_octets: [tree_capacity]u8 = undefined;
    const tree = compressed_tree(&distribution, 0, 0, &tree_octets);
    var table: huffman.Table = undefined;
    try testing.expectEqual(tree.len, try huffman.read_tree(tree, &table));
    try testing.expectEqual(2, table.bits_max);
    // Codes: literal 2 is 1, literal 0 is 00 and literal 1 is 01.
    try testing.expectEqual(2, table.cells[0b10].symbol);
    try testing.expectEqual(0, table.cells[0b00].symbol);
    try testing.expectEqual(1, table.cells[0b01].symbol);
    // Invariant 17: 4 cells and 3 weights, and the FSE table's 32 cells and 3 symbols.
    try testing.expectEqual(4 + 3 + 32 + 3, table.work);
}

test "FSE-compressed weights whose stream ends inside its first states are those two states'" {
    // One octet of four bits: State1 reads them and a zero past the start, 11110, cell 30, whose
    // weight 1 reads no bits; State2 reads zeros, cell 0, weight 1. The stream ended inside the first
    // states, so their weights are the only ones (RFC 8878 §4.2.1.2), and literal 2's is deduced: 2.
    const distribution = skewed_weights();
    var tree_octets: [tree_capacity]u8 = undefined;
    var table: huffman.Table = undefined;
    _ = try huffman.read_tree(tree_of(&distribution, &.{0b0001_1111}, &tree_octets), &table);
    try testing.expectEqual(2, table.bits_max);
    try testing.expectEqual(2, table.cells[0b10].symbol);
    try testing.expectEqual(1, table.cells[0b10].bits);
}

test "FSE-compressed weights past the 255 that may precede the last are refused" {
    // Of 32 cells, weight 2 takes cell 9 and weight 1 the rest, and weight 1's cells from 1 on read
    // no bits, each next state 1 or 2 cells lower: from 31 down to 9, 12 weights, whose 5 bits of 1
    // go back to 31. Each state takes 12 weights to 5 bits, so 120 bits hold more than 255.
    const distribution = skewed_weights();
    var weight_table: fse.Table(constants.huffman_weights_accuracy_log_max) = undefined;
    try fse.build(constants.huffman_weights_accuracy_log_max, &weight_table, &distribution);
    try testing.expectEqual(2, weight_table.cells[9].symbol);
    var tree_octets: [tree_capacity]u8 = undefined;
    var table: huffman.Table = undefined;
    try testing.expectError(error.HuffmanWeightsInvalid, huffman.read_tree(compressed_tree(&distribution, 31, 120, &tree_octets), &table));
}

test "seeded FSE-compressed weights decode as the checked backward reader reads them" {
    var agreed: usize = 0;
    for (0..1000) |seed| {
        var generator = codec.split.Generator.init(seed);
        const distribution = seeded_weight_distribution(&generator);
        var present: usize = 0;
        for (distribution.probabilities[0..distribution.symbol_count]) |probability| present += @intFromBool(probability != 0);
        if (present < constants.fse_symbols_present_min) continue;
        var weight_table: WeightTable = undefined;
        try fse.build(constants.huffman_weights_accuracy_log_max, &weight_table, &distribution);
        var stream: [seeded_stream_len_max]u8 = undefined;
        const stream_len = generator.between(1, stream.len);
        for (stream[0..stream_len]) |*octet| octet.* = @truncate(generator.next());
        stream[stream_len - 1] |= 1;
        var tree_octets: [tree_capacity]u8 = undefined;
        var table: huffman.Table = undefined;
        const got = huffman.read_tree(tree_of(&distribution, stream[0..stream_len], &tree_octets), &table);
        var expected: huffman.Weights = undefined;
        reference_weights(&weight_table, stream[0..stream_len], &expected) catch |err| {
            try testing.expectError(err, got);
            continue;
        };
        // The weights read alike, whatever tree they give, and so does the tree or its refusal.
        const read = &table.scratch.weights;
        try testing.expectEqual(expected.written, read.written);
        try testing.expectEqualSlices(u8, expected.values[0..expected.written], read.values[0..expected.written]);
        var expected_table: huffman.Table = undefined;
        if (huffman.build(&expected, &expected_table)) |_| {
            _ = try got;
            try testing.expectEqualSlices(huffman.Entry, expected_table.cells[0 .. @as(usize, 1) << expected_table.bits_max], table.cells[0 .. @as(usize, 1) << table.bits_max]);
        } else |err| try testing.expectError(err, got);
        agreed += 1;
    }
    try testing.expect(agreed > 500);
}

test "Table 26's literals \"0145\" decode from the bitstream erratum 8195 corrects" {
    // RFC 8878 §4.2.2's Table 26 gives literals 4 and 5 each other's codes from Table 25; erratum
    // 8195 (reported) makes it agree, and the bitstream is 00000001 00001101. Read backward: the
    // final bit, then 1 (literal 0), 01 (1), 0000 (4) and 0001 (5).
    const description = [_]u8{ constants.huffman_direct_symbols_offset + 5, 0x43, 0x20, 0x10 };
    var table: huffman.Table = undefined;
    _ = try huffman.read_tree(&description, &table);
    var decoded: [4]u8 = undefined;
    try huffman.decode_stream(&table, &.{ 0b0000_0001, 0b0000_1101 }, &decoded);
    try testing.expectEqualSlices(u8, &.{ 0, 1, 4, 5 }, &decoded);
    // The bitstream as the RFC prints it decodes to 0, 1, 5 and 4.
    try huffman.decode_stream(&table, &.{ 0b0001_0000, 0b0000_1101 }, &decoded);
    try testing.expectEqualSlices(u8, &.{ 0, 1, 5, 4 }, &decoded);
}

/// A seeded weight is below this, so the sum of up to 100 of them stays within 11 bits.
const seeded_weight_limit = 6;

/// The draws a seeded literal takes at most to land on one with a nonzero weight.
const literal_draws_max = 1000;

/// Seeded weights for `count` literals, each 0 to 5 but the first, which is 1 so the tree reaches
/// Max_Number_of_Bits; then the weights that bring the sum of 2^(Weight-1) within one power of 2 of
/// the next power of 2, which the deduced last weight fills.
fn seeded_weights(generator: *codec.split.Generator, count: u16, weights: *huffman.Weights) void {
    weights.init();
    weights.put(0, 1);
    for (1..count) |literal| weights.put(@intCast(literal), @intCast(generator.below(seeded_weight_limit)));
    weights.written = count;
    var rest = (@as(u32, 1) << @intCast(std.math.log2_int(u32, weights.tally.sum) + 1)) - weights.tally.sum;
    while (!std.math.isPowerOfTwo(rest)) {
        const lowest = rest & (~rest +% 1);
        weights.put(@intCast(weights.written), @intCast(@ctz(lowest) + 1));
        weights.written += 1;
        rest -= lowest;
    }
}

/// Weights written through `put`, as the readers write them.
fn weights_of(values: []const u8) huffman.Weights {
    var weights: huffman.Weights = undefined;
    weights.init();
    for (values, 0..) |weight, literal| weights.put(@intCast(literal), weight);
    weights.written = @intCast(values.len);
    return weights;
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
    var heavy = weights_of(&.{ 12, 1 });
    try testing.expectError(error.HuffmanWeightsInvalid, huffman.build(&heavy, &table));
    // Weights 11 and 11: a sum of 2048, which needs a 12-bit code for the last literal.
    var long = weights_of(&.{ 11, 11 });
    try testing.expectError(error.HuffmanWeightsInvalid, huffman.build(&long, &table));
    // Weights 2, 1 and 1 sum to 4: the next power of 2 is 8, and 4 more is one weight of 3.
    var fitting = weights_of(&.{ 2, 1, 1 });
    try huffman.build(&fitting, &table);
    try testing.expectEqual(3, table.bits_max);
    // Weights 3 and 1 sum to 5: the next power of 2 is 8, and 8 - 5 = 3 is no power of 2.
    var odd = weights_of(&.{ 3, 1 });
    try testing.expectError(error.HuffmanWeightsInvalid, huffman.build(&odd, &table));
    // Weights 3 and 2 sum to 6, and the last is 2: Max_Number_of_Bits 3, yet no code is 3 bits.
    var shallow = weights_of(&.{ 3, 2 });
    try testing.expectError(error.HuffmanWeightsInvalid, huffman.build(&shallow, &table));
    try testing.expectError(error.HuffmanStreamUnterminated, huffman.decode_stream(&table, &.{ 0x12, 0 }, &.{}));
    try testing.expectError(error.HuffmanTreeTruncated, huffman.read_tree(&.{ constants.huffman_direct_symbols_offset + 5, 0x43 }, &table));
}
