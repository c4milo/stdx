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
    return table.build(&code.counts, &code.symbols, @TypeOf(table.*) == lookup.LiteralLengthTable);
}

/// The canonical decode of the bits of `index` in a table of `bits`, followed by ones: the canonical
/// decode needs at most 15.
fn decode(code: anytype, index: usize, bits: u6) huffman.Decoded {
    return code.decode(index | (~@as(u64, 0) << bits), constants.code_len_max);
}

/// The entry the canonical decode says `index` of a table of `bits` holds: the symbol whose code
/// its bits start with, and for a length whose code and extra bits fit a table that resolves
/// lengths, the whole length its extra bits give, which the bits after the code in `index` hold.
fn expected_entry(code: anytype, index: usize, bits: u4, comptime entry_of: fn (u16, u4) lookup.Entry, comptime resolves_lengths: bool) lookup.Entry {
    const symbol = switch (decode(code, index, bits)) {
        .symbol => |symbol| symbol,
        .invalid => return lookup.Entry.invalid,
        .needs_bits => unreachable,
    };
    if (symbol.len > bits) {
        // The prefix, most significant bit first: the index's bits in the order the stream gave.
        var prefix: u16 = 0;
        for (0..bits) |bit| prefix = prefix << 1 | @as(u16, @intCast((index >> @intCast(bit)) & 1));
        return lookup.Entry.long(prefix, bits);
    }
    const entry = entry_of(symbol.value, @intCast(symbol.len));
    if (!resolves_lengths or !entry.direct or !entry.extra or entry.used_bits > bits) return entry;
    const extra_bits: u6 = entry.used_bits - entry.code_bits;
    const extra = (index >> @intCast(symbol.len)) & ((@as(usize, 1) << extra_bits) - 1);
    return lookup.resolved_length_entry(symbol.value, @intCast(symbol.len), @intCast(extra));
}

/// Requires every entry of `table` to say what the canonical decode of its index says, the
/// lengths' extra bits resolved when the table is the literal/length table `build` resolves.
fn expect_agrees(comptime Table: type, table: *const Table, lengths: []const u8, completeness: huffman.Completeness, comptime entry_of: fn (u16, u4) lookup.Entry) !void {
    try expect_agrees_resolved(Table, table, lengths, completeness, entry_of, Table == lookup.LiteralLengthTable);
}

fn expect_agrees_resolved(comptime Table: type, table: *const Table, lengths: []const u8, completeness: huffman.Completeness, comptime entry_of: fn (u16, u4) lookup.Entry, comptime resolves: bool) !void {
    var code: huffman.Code(constants.literal_length_alphabet_len) = undefined;
    var work: huffman.Work = 0;
    try code.build(lengths, completeness, &work);
    for (0..@as(usize, 1) << table.bits) |index| {
        try testing.expectEqual(expected_entry(&code, index, table.bits, entry_of, resolves), table.lookup(index));
    }
}

test "the fixed tables agree with RFC 1951 section 3.2.6's codes" {
    try testing.expectEqual(9, lookup.fixed_literal_length.bits);
    try testing.expectEqual(5, lookup.fixed_distance.bits);
    try expect_agrees(lookup.LiteralLengthTable, &lookup.fixed_literal_length, &constants.fixed_literal_length_lengths, .complete, lookup.literal_length_entry);
    try expect_agrees(lookup.DistanceTable, &lookup.fixed_distance, &constants.fixed_distance_lengths, .complete, lookup.distance_entry);
    // RFC 1951 §3.2.6: literal/length values 286 - 287 and distance codes 30 - 31 never occur.
    try testing.expectEqual(lookup.Other.invalid, lookup.literal_length_entry(286, 8).other);
    try testing.expectEqual(lookup.Other.invalid, lookup.distance_entry(30, 5).other);
}

test "RFC 1951 section 3.2.5: a resolved length of 258 from code 284 is invalid, and 257 and 258 from 285 are not" {
    const code_bits = 5;
    const from_284 = lookup.resolved_length_entry(284, code_bits, 30);
    try testing.expect(from_284.direct and !from_284.extra);
    try testing.expectEqual(257, from_284.value);
    try testing.expectEqual(code_bits + 5, from_284.used_bits);
    try testing.expectEqual(lookup.Other.invalid, lookup.resolved_length_entry(284, code_bits, 31).other);
    try testing.expectEqual(constants.match_len_max, lookup.resolved_length_entry(285, code_bits, 0).value);
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
    try testing.expectEqual(lookup.Other.invalid, table.lookup(0).other);
    try testing.expectEqual(lookup.Other.invalid, table.lookup(1).other);
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
        // Built plain, the table holds each length's base and leaves its extra bits in the stream.
        var code: huffman.Code(constants.literal_length_alphabet_len) = undefined;
        var work: huffman.Work = 0;
        try code.build(&lengths, .complete, &work);
        _ = table.build(&code.counts, &code.symbols, false);
        try expect_agrees_resolved(lookup.LiteralLengthTable, &table, &lengths, .complete, lookup.literal_length_entry, false);
    }
}

test "combining joins each resolved length with the distance code after it, where the code fits" {
    for (0..500) |seed| {
        var generator = codec.split.Generator.init(seed);
        var literal_lengths: [constants.literal_length_used]u8 = @splat(0);
        deal(&generator, &literal_lengths, generator.between(2, combining_symbols_max), constants.first_length_symbol);
        var distance_lengths: [constants.distance_used]u8 = @splat(0);
        deal(&generator, &distance_lengths, generator.between(2, constants.distance_used), constants.distance_used);
        var work: huffman.Work = 0;
        var literal_length_code: huffman.Code(constants.literal_length_alphabet_len) = undefined;
        try literal_length_code.build(&literal_lengths, .complete, &work);
        var distance_code: huffman.Code(constants.distance_alphabet_len) = undefined;
        try distance_code.build(&distance_lengths, .complete, &work);
        var literal_length_table: lookup.LiteralLengthTable = undefined;
        _ = literal_length_table.build(&literal_length_code.counts, &literal_length_code.symbols, true);
        var distance_table: lookup.DistanceTable = undefined;
        _ = distance_table.build(&distance_code.counts, &distance_code.symbols, false);
        const entries = literal_length_table.entries;
        const touched = lookup.combine(&literal_length_table, &distance_table);
        try testing.expect(touched <= constants.combine_work_max(literal_length_table.bits));
        for (0..@as(usize, 1) << literal_length_table.bits) |index| {
            const expected = expected_combined(entries[index], index, literal_length_table.bits, distance_table.bits, &distance_code);
            try testing.expectEqual(expected, literal_length_table.lookup(index));
        }
    }
}

/// The literal/length symbols the combining test's codes take at most: few enough that lengths get
/// short codes.
const combining_symbols_max = 48;

/// The entry `index` of a table of `bits` holds after combining, from the one it held before,
/// `plain`: a resolved length whose index holds the whole code of the distance after it, a code
/// the distance table holds, takes that code; any other stays.
fn expected_combined(plain: lookup.Entry, index: usize, bits: u4, distance_bits: u4, distance_code: anytype) lookup.Entry {
    if (!plain.direct or plain.extra or plain.used_bits >= bits) return plain;
    const rest_bits: u7 = bits - plain.used_bits;
    const decoded = distance_code.decode(index >> @intCast(plain.used_bits), rest_bits);
    const symbol = switch (decoded) {
        .symbol => |symbol| symbol,
        .needs_bits, .invalid => return plain,
    };
    if (symbol.len > distance_bits) return plain;
    return lookup.combined_entry(plain, lookup.distance_entry(symbol.value, @intCast(symbol.len)), @intCast(symbol.value));
}

/// Gives the lengths of a seeded complete code over `count` symbols to symbols of `lengths` the
/// generator draws, half of them from `favored` on, where a literal/length code's lengths start.
fn deal(generator: *codec.split.Generator, lengths: []u8, count: usize, favored: usize) void {
    var code: [constants.literal_length_used]u8 = @splat(0);
    complete_lengths(generator, code[0..count]);
    for (code[0..count]) |len| lengths[free_symbol(generator, lengths, favored)] = len;
}

/// The ranges `free_symbol` draws from alike: below `favored`, and from it on.
const ranges = 2;

/// A symbol of `lengths` with no length yet: drawn below `favored` or from it on, alike, and the
/// next free one from there. One exists, since a code has fewer symbols than its alphabet.
fn free_symbol(generator: *codec.split.Generator, lengths: []const u8, favored: usize) usize {
    const favor = favored < lengths.len and generator.below(ranges) == 0;
    const start = if (favor) favored else 0;
    const end = if (favor or favored >= lengths.len) lengths.len else favored;
    var symbol: usize = start + @as(usize, @intCast(generator.below(end - start)));
    for (0..lengths.len) |_| {
        if (lengths[symbol] == 0) return symbol;
        symbol = (symbol + 1) % lengths.len;
    }
    unreachable;
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
