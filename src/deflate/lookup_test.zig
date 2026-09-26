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
/// its bits start with, or with `pairs`, both literals when a second one's code follows whole.
fn expected_entry(code: anytype, index: usize, bits: u4, pairs: bool, comptime entry_of: fn (u16, u4) lookup.Entry) lookup.Entry {
    const first = switch (decode(code, index, bits)) {
        .symbol => |symbol| symbol,
        .invalid => return .{ .code_bits = 0, .extra_bits = 0, .kind = .invalid, .value = 0 },
        .needs_bits => unreachable,
    };
    if (first.len > bits) return .{ .code_bits = 0, .extra_bits = 0, .kind = .long, .value = 0 };
    const single = entry_of(first.value, @intCast(first.len));
    if (!pairs or single.kind != .literal or first.len >= bits) return single;
    const second = switch (decode(code, index >> @intCast(first.len), bits - @as(u4, @intCast(first.len)))) {
        .symbol => |symbol| symbol,
        .invalid, .needs_bits => return single,
    };
    if (second.value >= constants.end_of_block or first.len + second.len > bits) return single;
    return .{
        .code_bits = @intCast(first.len + second.len),
        .extra_bits = 0,
        .kind = .literal_pair,
        .value = first.value | second.value << @bitSizeOf(u8),
    };
}

/// Requires every entry of `table` to say what the canonical decode of its index says.
fn expect_agrees(comptime Table: type, table: *const Table, lengths: []const u8, completeness: huffman.Completeness, comptime entry_of: fn (u16, u4) lookup.Entry) !void {
    var code: huffman.Code(constants.literal_length_alphabet_len) = undefined;
    var work: huffman.Work = 0;
    try code.build(lengths, completeness, &work);
    const pairs = Table == lookup.LiteralLengthTable;
    for (0..@as(usize, 1) << table.bits) |index| {
        try testing.expectEqual(expected_entry(&code, index, table.bits, pairs, entry_of), table.lookup(index));
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
    // 2^11 entries as the table doubles from two, one for each of the 16 codes, of which the five
    // longer than the table write their shared prefix, and one for each of the 55 pairs of the
    // literals of 1 to 10 bits whose lengths sum to 11 or less.
    try testing.expectEqual((1 << 11) + 16 + 55, written);
    try expect_agrees(lookup.LiteralLengthTable, &table, &lengths, .complete, lookup.literal_length_entry);
}

test "a table is as wide as its longest code" {
    var lengths: [constants.literal_length_alphabet_len]u8 = @splat(0);
    lengths[0] = 1;
    lengths[constants.end_of_block] = 2;
    lengths[constants.first_length_symbol] = 2;
    var table: lookup.LiteralLengthTable = undefined;
    // Four entries, three codes, and literal 0 twice.
    try testing.expectEqual(4 + 3 + 1, try build(&table, &lengths, .complete));
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

test "a pair holds the two literals the canonical decode reads, and nothing else pairs" {
    // Length code 257 takes 1 bit, literals 'a' to 'd' take 2 to 5, and literal 'e' and
    // end-of-block the last two codes of 6.
    var lengths: [constants.literal_length_alphabet_len]u8 = @splat(0);
    for ("abcd", 2..) |symbol, len| lengths[symbol] = @intCast(len);
    lengths['e'] = 6;
    lengths[constants.end_of_block] = 6;
    lengths[constants.first_length_symbol] = 1;
    var table: lookup.LiteralLengthTable = undefined;
    // The table doubles to 64 entries from two, the 7 codes each write one, and each of the 6
    // pairs one, which the doublings after copy to the 11 indexes counted below.
    try testing.expectEqual(64 + 7 + 6, try build(&table, &lengths, .complete));
    var code: huffman.Code(constants.literal_length_alphabet_len) = undefined;
    var work: huffman.Work = 0;
    try code.build(&lengths, .complete, &work);
    var pairs: usize = 0;
    for (0..@as(usize, 1) << table.bits) |index| {
        const entry = table.lookup(index);
        const first = code.decode(index, table.bits).symbol;
        if (entry.kind != .literal_pair) {
            try testing.expectEqual(lookup.literal_length_entry(first.value, @intCast(first.len)), entry);
            continue;
        }
        pairs += 1;
        const second = code.decode(index >> @intCast(first.len), table.bits - first.len).symbol;
        try testing.expect(first.value < constants.end_of_block and second.value < constants.end_of_block);
        try testing.expectEqual(first.len + second.len, entry.code_bits);
        try testing.expectEqual(first.value | second.value << 8, entry.value);
    }
    // In the 4 bits after 'a', 'a', 'b' and 'c' fit in 4, 2 and 1 indexes; in the 3 after 'b',
    // 'a' and 'b' in 2 and 1; in the 2 after 'c', 'a' in 1. The length code takes half of each.
    try testing.expectEqual(4 + 2 + 1 + 2 + 1 + 1, pairs);
}
