//! Tests for the fast path's lookup tables: every entry agrees with the canonical decode of
//! huffman.zig, which follows RFC 1951 §3.2.2 bit by bit.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const lookup = @import("lookup.zig");

/// Requires every entry of `table` to say what the canonical decode of its index says.
fn expect_agrees(comptime Table: type, table: *const Table, lengths: []const u8, completeness: huffman.Completeness, comptime entry_of: fn (u16, u4) lookup.Entry) !void {
    var code: huffman.Code(constants.literal_length_alphabet_len) = undefined;
    var work: huffman.Work = 0;
    try code.build(lengths, completeness, &work);
    const size = @as(usize, 1) << table.bits;
    for (0..size) |index| {
        const entry = table.lookup(index);
        // The index's bits, then ones: the canonical decode needs at most 15.
        const bits = index | (~@as(u64, 0) << table.bits);
        switch (code.decode(bits, constants.code_len_max)) {
            .symbol => |symbol| if (symbol.len <= table.bits) {
                try testing.expectEqual(entry_of(symbol.value, @intCast(symbol.len)), entry);
            } else {
                try testing.expectEqual(lookup.Kind.long, entry.kind);
            },
            .invalid => try testing.expectEqual(lookup.Kind.invalid, entry.kind),
            .needs_bits => unreachable,
        }
    }
}

test "the fixed tables agree with RFC 1951 section 3.2.6's codes" {
    try testing.expectEqual(9, lookup.fixed_literal_length.bits);
    try testing.expectEqual(5, lookup.fixed_distance.bits);
    try expect_agrees(lookup.LiteralLengthTable, &lookup.fixed_literal_length, &constants.fixed_literal_length_lengths, .complete, lookup.literal_length_entry);
    try expect_agrees(lookup.DistanceTable, &lookup.fixed_distance, &constants.fixed_distance_lengths, .complete, lookup.distance_entry);
    // RFC 1951 §3.2.6: literal/length values 286 - 287 and distance codes 30 - 31 never occur.
    try testing.expectEqual(lookup.Kind.invalid, lookup.literal_length_entry(286, 8).kind);
    try testing.expectEqual(lookup.Kind.invalid, lookup.distance_entry(30, 5).kind);
}

test "codes longer than the table mark their prefixes long" {
    // One code of each length from 1 to 15, and a second of 15: a complete code.
    var lengths: [constants.literal_length_alphabet_len]u8 = @splat(0);
    for (0..constants.code_len_max) |index| lengths[index] = @intCast(index + 1);
    lengths[constants.end_of_block] = constants.code_len_max;
    var table: lookup.LiteralLengthTable = undefined;
    const written = table.build(&lengths);
    try testing.expectEqual(constants.literal_length_table_bits, table.bits);
    // 2^11 entries for the codes of 1 to 11 bits and the one prefix of the longer codes, which
    // each of the five longer codes writes.
    try testing.expectEqual((1 << 11) - 1 + 5, written);
    try expect_agrees(lookup.LiteralLengthTable, &table, &lengths, .complete, lookup.literal_length_entry);
}

test "a table is as wide as its longest code" {
    var lengths: [constants.literal_length_alphabet_len]u8 = @splat(0);
    lengths[0] = 1;
    lengths[constants.end_of_block] = 2;
    lengths[constants.first_length_symbol] = 2;
    var table: lookup.LiteralLengthTable = undefined;
    try testing.expectEqual(4, table.build(&lengths));
    try testing.expectEqual(2, table.bits);
    try expect_agrees(lookup.LiteralLengthTable, &table, &lengths, .complete, lookup.literal_length_entry);
}

test "RFC 1951 section 3.2.7's incomplete distance codes leave the unused values invalid" {
    var table: lookup.DistanceTable = undefined;
    const single = [_]u8{ 0, 1 };
    try testing.expectEqual(3, table.build(&single));
    try expect_agrees(lookup.DistanceTable, &table, &single, .distance, lookup.distance_entry);
    const none = [_]u8{ 0, 0 };
    _ = table.build(&none);
    try testing.expectEqual(lookup.Kind.invalid, table.lookup(0).kind);
    try testing.expectEqual(lookup.Kind.invalid, table.lookup(1).kind);
}

test "every seeded complete code's table agrees with the canonical decode" {
    for (0..200) |seed| {
        var generator = codec.split.Generator.init(seed);
        var lengths: [constants.literal_length_used]u8 = @splat(0);
        const symbols = generator.between(2, constants.literal_length_used);
        complete_lengths(&generator, lengths[0..symbols]);
        shuffle(&generator, &lengths);
        var table: lookup.LiteralLengthTable = undefined;
        _ = table.build(&lengths);
        try expect_agrees(lookup.LiteralLengthTable, &table, &lengths, .complete, lookup.literal_length_entry);
    }
}

/// Lengths of a complete code for every symbol of `lengths`: starting from one leaf of no bits,
/// splits a seeded leaf in two until there are as many leaves as symbols, deepening no leaf past
/// 15 bits (RFC 1951 §3.2.7).
fn complete_lengths(generator: *codec.split.Generator, lengths: []u8) void {
    lengths[0] = 0;
    for (1..lengths.len) |leaves| {
        var leaf: usize = @intCast(generator.below(leaves));
        // A leaf that can deepen exists: fewer than 2^15 leaves are all at 15 bits.
        while (lengths[leaf] == constants.code_len_max) leaf = (leaf + 1) % leaves;
        lengths[leaf] += 1;
        lengths[leaves] = lengths[leaf];
    }
}

fn shuffle(generator: *codec.split.Generator, lengths: []u8) void {
    for (1..lengths.len) |index| {
        const other: usize = @intCast(generator.below(index + 1));
        std.mem.swap(u8, &lengths[index], &lengths[other]);
    }
}
