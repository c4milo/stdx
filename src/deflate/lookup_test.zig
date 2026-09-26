//! Tests for the fast path's lookup tables: every entry agrees with the canonical decode of
//! huffman.zig, which follows RFC 1951 §3.2.2 bit by bit.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const lookup = @import("lookup.zig");

/// Builds `table` from the canonical code of `lengths`, and returns the entries the build wrote.
fn build(table: anytype, lengths: []const u8, completeness: huffman.Completeness) !usize {
    var code: huffman.Code(constants.literal_length_alphabet_len) = undefined;
    var work: huffman.Work = 0;
    try code.build(lengths, completeness, &work);
    return table.build(&code.counts, &code.symbols);
}

/// The canonical decode of the bits of `index` in a table of `bits`, followed by ones: the canonical
/// decode needs at most 15.
fn decode(code: anytype, index: usize, bits: u6) huffman.Decoded {
    return code.decode(index | (~@as(u64, 0) << bits), constants.code_len_max);
}

/// The entry the canonical decode says `index` of a table of `bits` holds: the symbol whose code
/// its bits start with.
fn expected_entry(code: anytype, index: usize, bits: u4, comptime entry_of: fn (u16, u4) lookup.Entry) lookup.Entry {
    const symbol = switch (decode(code, index, bits)) {
        .symbol => |symbol| symbol,
        .invalid => return .{ .used_bits = 0, .code_bits = 0, .kind = .invalid, .value = 0 },
        .needs_bits => unreachable,
    };
    if (symbol.len > bits) return .{ .used_bits = 0, .code_bits = 0, .kind = .long, .value = 0 };
    return entry_of(symbol.value, @intCast(symbol.len));
}

/// Requires every entry of `table` to say what the canonical decode of its index says.
fn expect_agrees(comptime Table: type, table: *const Table, lengths: []const u8, completeness: huffman.Completeness, comptime entry_of: fn (u16, u4) lookup.Entry) !void {
    var code: huffman.Code(constants.literal_length_alphabet_len) = undefined;
    var work: huffman.Work = 0;
    try code.build(lengths, completeness, &work);
    for (0..@as(usize, 1) << table.bits) |index| {
        try testing.expectEqual(expected_entry(&code, index, table.bits, entry_of), table.lookup(index));
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
    const written = try build(&table, &lengths, .complete);
    try testing.expectEqual(constants.literal_length_table_bits, table.bits);
    // 2^11 entries as the table doubles from two, and one for each of the 16 codes, of which the
    // five longer than the table write their shared prefix.
    try testing.expectEqual((1 << 11) + 16, written);
    try expect_agrees(lookup.LiteralLengthTable, &table, &lengths, .complete, lookup.literal_length_entry);
}

test "a table is as wide as its longest code" {
    var lengths: [constants.literal_length_alphabet_len]u8 = @splat(0);
    lengths[0] = 1;
    lengths[constants.end_of_block] = 2;
    lengths[constants.first_length_symbol] = 2;
    var table: lookup.LiteralLengthTable = undefined;
    // Four entries, and three codes.
    try testing.expectEqual(4 + 3, try build(&table, &lengths, .complete));
    try testing.expectEqual(2, table.bits);
    try expect_agrees(lookup.LiteralLengthTable, &table, &lengths, .complete, lookup.literal_length_entry);
}

test "RFC 1951 section 3.2.7's incomplete distance codes leave the unused values invalid" {
    var table: lookup.DistanceTable = undefined;
    const single = [_]u8{ 0, 1 };
    try testing.expectEqual(2 + 1, try build(&table, &single, .distance));
    try expect_agrees(lookup.DistanceTable, &table, &single, .distance, lookup.distance_entry);
    const none = [_]u8{ 0, 0 };
    _ = try build(&table, &none, .distance);
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
        _ = try build(&table, &lengths, .complete);
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
