//! The lookup tables against a canonical decoder that reads a code one bit at a time, the way RFC
//! 7932 §3.2 defines it, over random complete codes of the largest alphabets.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const prefix = @import("prefix.zig");

const LiteralTable = prefix.Table(constants.literal_table_len_max, constants.table_root_bits);
const InsertCopyTable = prefix.Table(constants.insert_copy_table_len_max, constants.table_root_bits);

/// The symbol a canonical code gives the bits, read most significant first one at a time, and its
/// length; null when the bits end first.
fn reference_decode(lengths: []const u8, bits: u64, available: u7) ?struct { value: u16, len: u7 } {
    var counts: [constants.code_len_max + 1]u16 = @splat(0);
    for (lengths) |len| counts[len] += 1;
    counts[0] = 0;
    var code: u32 = 0;
    var first: u32 = 0;
    var index: u32 = 0;
    for (1..constants.code_len_max + 1) |len| {
        if (len > available) return null;
        code |= @intCast((bits >> @intCast(len - 1)) & 1);
        const count: u32 = counts[len];
        if (code - first < count) return .{ .value = nth_symbol_of_len(lengths, len, code - first), .len = @intCast(len) };
        index += count;
        first = (first + count) << 1;
        code <<= 1;
    }
    unreachable;
}

/// The `rank`th symbol, in symbol order, whose code is `len` bits long.
fn nth_symbol_of_len(lengths: []const u8, len: usize, rank: u32) u16 {
    var left = rank;
    for (lengths, 0..) |symbol_len, symbol| {
        if (symbol_len != len) continue;
        if (left == 0) return @intCast(symbol);
        left -= 1;
    }
    unreachable;
}

/// Random lengths of a complete code of `count` symbols out of `lengths.len`: two leaves of depth
/// 1, then a random leaf shorter than the longest code split in two until there are `count`, placed
/// on the first `count` symbols of a random order of the alphabet.
fn random_lengths(generator: *codec.split.Generator, lengths: []u8, count: usize) void {
    var depths: [constants.insert_copy_alphabet_len]u8 = undefined;
    depths[0] = 1;
    depths[1] = 1;
    var leaves: usize = constants.code_symbols_min;
    // A leaf shorter than the longest code is almost every leaf, so few draws miss.
    for (0..count * constants.code_len_max) |_| {
        if (leaves == count) break;
        const at = generator.below(leaves);
        if (depths[at] == constants.code_len_max) continue;
        depths[at] += 1;
        depths[leaves] = depths[at];
        leaves += 1;
    }
    std.debug.assert(leaves == count);
    var order: [constants.insert_copy_alphabet_len]u16 = undefined;
    for (order[0..lengths.len], 0..) |*symbol, index| symbol.* = @intCast(index);
    @memset(lengths, 0);
    for (0..count) |index| {
        std.mem.swap(u16, &order[index], &order[index + generator.below(lengths.len - index)]);
        lengths[order[index]] = depths[index];
    }
}

/// The entries a table of `lengths` takes: its root, and for each root entry whose codes are
/// longer, a second level of 1 << (the longest of them - `table_root_bits`) entries.
fn reference_table_len(lengths: []const u8) usize {
    var counts: [constants.code_len_max + 1]u32 = @splat(0);
    for (lengths) |len| counts[len] += 1;
    counts[0] = 0;
    var next: [constants.code_len_max + 1]u32 = @splat(0);
    var code: u32 = 0;
    for (1..constants.code_len_max + 1) |len| {
        code = (code + counts[len - 1]) << 1;
        next[len] = code;
    }
    var longest: [1 << constants.table_root_bits]u8 = @splat(0);
    for (lengths) |len| {
        if (len <= constants.table_root_bits) continue;
        const root = next[len] >> @intCast(len - constants.table_root_bits);
        next[len] += 1;
        longest[root] = @max(longest[root], len);
    }
    var table_len: usize = 1 << constants.table_root_bits;
    for (longest) |len| {
        if (len > 0) table_len += @as(usize, 1) << @intCast(len - constants.table_root_bits);
    }
    return table_len;
}

fn expect_table_matches(table: anytype, lengths: []const u8) !void {
    for (0..1 << constants.code_len_max) |bits| {
        const expected = reference_decode(lengths, bits, constants.code_len_max).?;
        const decoded = table.decode(bits, constants.code_len_max).symbol;
        try testing.expectEqual(expected.value, decoded.value);
        try testing.expectEqual(expected.len, decoded.len);
        // With one bit fewer than the code takes, the table asks for more.
        try testing.expectEqual(.needs_bits, std.meta.activeTag(table.decode(bits, expected.len - 1)));
    }
}

test "every table takes the entries its codes need, decodes every value as the canonical code does, and asks for bits it lacks" {
    var generator = codec.split.Generator.init(0);
    for (0..24) |_| {
        var lengths: [constants.literal_alphabet_len]u8 = undefined;
        random_lengths(&generator, &lengths, generator.between(2, lengths.len));
        var table: LiteralTable = undefined;
        try testing.expectEqual(reference_table_len(&lengths), table.build(&lengths));
        try expect_table_matches(&table, &lengths);
    }
    for (0..8) |_| {
        var lengths: [constants.insert_copy_alphabet_len]u8 = undefined;
        random_lengths(&generator, &lengths, generator.between(2, lengths.len));
        var table: InsertCopyTable = undefined;
        try testing.expectEqual(reference_table_len(&lengths), table.build(&lengths));
        try expect_table_matches(&table, &lengths);
    }
}

test "a code with longer codes and none of the root's length links them past the copies of the root" {
    // Lengths 1 to 7, then four of 9: the root is half copied when the codes of 9 link second
    // levels at the root entries 127 and 255 (RFC 7932 §3.2).
    const short_lengths = [_]u8{ 1, 2, 3, 4, 5, 6, 7 };
    const long_codes = 4;
    var lengths: [constants.literal_alphabet_len]u8 = @splat(0);
    @memcpy(lengths[0..short_lengths.len], &short_lengths);
    @memset(lengths[short_lengths.len..][0..long_codes], constants.table_root_bits + 1);
    var table: LiteralTable = undefined;
    try testing.expectEqual(reference_table_len(&lengths), table.build(&lengths));
    try expect_table_matches(&table, &lengths);
}

test "RFC 7932 §3.2's example: lengths (3, 3, 3, 3, 3, 2, 4, 4) give the codes it lists" {
    var table: prefix.Table(32, 3) = undefined;
    const lengths = [_]u8{ 3, 3, 3, 3, 3, 2, 4, 4 };
    // The root, and one second level of 2 entries for the root entry of 111.
    try testing.expectEqual(8 + 2, table.build(&lengths));
    // A 010, B 011, C 100, D 101, E 110, F 00, G 1110, H 1111: most significant bit first, so the
    // stream holds each reversed.
    const codes = [_]struct { u32, u5 }{ .{ 0b010, 3 }, .{ 0b110, 3 }, .{ 0b001, 3 }, .{ 0b101, 3 }, .{ 0b011, 3 }, .{ 0b00, 2 }, .{ 0b0111, 4 }, .{ 0b1111, 4 } };
    for (codes, 0..) |code, symbol| {
        const decoded = table.decode(code[0], code[1]);
        try testing.expectEqual(symbol, decoded.symbol.value);
        try testing.expectEqual(code[1], decoded.symbol.len);
    }
}

test "a code of one symbol takes no bits" {
    var table: InsertCopyTable = undefined;
    try testing.expectEqual(1 << constants.table_root_bits, table.build_single(703));
    const decoded = table.decode(0, 0);
    try testing.expectEqual(703, decoded.symbol.value);
    try testing.expectEqual(0, decoded.symbol.len);
}

test "the fixed code of the code length code's lengths" {
    const codes = [_]struct { u32, u5 }{ .{ 0b00, 2 }, .{ 0b0111, 4 }, .{ 0b011, 3 }, .{ 0b10, 2 }, .{ 0b01, 2 }, .{ 0b1111, 4 } };
    for (codes, 0..) |code, value| {
        // RFC 7932 §3.5 prints each code as it appears in the stream: its first bit rightmost.
        const decoded = prefix.decode_code_length_code_length(code[0], code[1]).?;
        try testing.expectEqual(value, decoded.value);
        try testing.expectEqual(code[1], decoded.len);
        // With a bit fewer than its code takes, the code is not whole.
        const cut = code[0] & ((@as(u32, 1) << (code[1] - 1)) - 1);
        try testing.expectEqual(null, prefix.decode_code_length_code_length(cut, code[1] - 1));
        if (code[1] > 2) try testing.expectEqual(null, prefix.decode_code_length_code_length(code[0], code[1] - 1));
    }
    try testing.expectEqual(null, prefix.decode_code_length_code_length(0, 1));
}
