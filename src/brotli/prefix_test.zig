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

/// Symbols of a test code spread over a literal alphabet: every `spread_stride`th from
/// `spread_offset`, so that runs of one length hold one symbol and the lists hold many.
const spread_stride = 16;
const spread_offset = 3;
/// A complete code within and past the root: 1 to 14 bits once each and 15 bits twice, a Kraft
/// sum of 1.
const spread_codes = constants.code_len_max + 1;
/// A complete code within the root: two codes of 2 bits and four of 3 bits.
const within_short_len = 2;
const within_short_codes = 2;
const within_long_len = 3;
const within_long_codes = 4;

/// Requires the runs' build and the sorted build to write the same table from `lengths`, the runs
/// appended as the reader appends them: one per maximal stretch of one length.
fn expect_builds_alike(lengths: []const u8) !void {
    const counts = prefix.counts_of(lengths);
    var buffer: [constants.literal_alphabet_len]prefix.Coded = undefined;
    const sorted = prefix.sort_canonical(lengths, &counts, &buffer);
    var ranges: prefix.Ranges = undefined;
    ranges.reset();
    var start: usize = 0;
    for (0..lengths.len) |_| {
        if (start >= lengths.len) break;
        var end = start + 1;
        while (end < lengths.len and lengths[end] == lengths[start]) end += 1;
        if (lengths[start] != 0) ranges.append(lengths[start], @intCast(start), @intCast(end - start));
        start = end;
    }
    const Literal = prefix.Table(constants.literal_table_len_max, constants.table_root_bits);
    var by_sort: Literal = undefined;
    var by_runs: Literal = undefined;
    const sorted_len = by_sort.build_sorted(sorted, &counts);
    const runs_len = by_runs.build_ranged(&ranges, &counts);
    try testing.expectEqual(sorted_len, runs_len);
    try testing.expectEqualSlices(prefix.Entry, by_sort.entries[0..sorted_len], by_runs.entries[0..runs_len]);
}

test "the runs' build writes the table the sorted build writes, within the root and past it" {
    var spread: [constants.literal_alphabet_len]u8 = @splat(0);
    for (0..spread_codes) |index| spread[index * spread_stride + spread_offset] = @intCast(@min(index + 1, constants.code_len_max));
    try expect_builds_alike(&spread);
    var within: [constants.literal_alphabet_len]u8 = @splat(0);
    for (0..within_short_codes) |index| within[index * spread_stride + spread_offset] = within_short_len;
    for (within_short_codes..within_short_codes + within_long_codes) |index| within[index * spread_stride + spread_offset] = within_long_len;
    try expect_builds_alike(&within);
}

test "the build within the root writes the table the sorted build writes" {
    // Complete codes of the code length code's shape: 18 symbols, lengths of at most 5 bits.
    const within_root_cases = [_][constants.code_length_alphabet_len]u8{
        .{ 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        .{ 1, 0, 2, 0, 3, 0, 4, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0 },
        .{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 },
        .{ 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 0 },
        .{ 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0 },
        .{ 2, 0, 0, 2, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0 },
    };
    const CodeLengthTable = prefix.Table(constants.code_length_table_len, constants.code_length_table_root_bits);
    for (within_root_cases) |lengths| {
        const counts = prefix.counts_of(&lengths);
        var by_sort: CodeLengthTable = undefined;
        var within: CodeLengthTable = undefined;
        const sorted_len = by_sort.build(&lengths);
        const within_len = within.build_within_root(&lengths, &counts);
        try testing.expectEqual(sorted_len, within_len);
        try testing.expectEqualSlices(prefix.Entry, by_sort.entries[0..sorted_len], within.entries[0..within_len]);
    }
}

test "a code whose longest code takes each length up to the root's repeats the root's first entries across it" {
    for (1..constants.table_root_bits + 1) |longest| {
        // Lengths 1 to `longest` - 1 once each and `longest` twice: a complete code (RFC 7932 §3.2)
        // whose fill doubles the root to 1 << `longest` entries, and then repeats them.
        var lengths: [constants.literal_alphabet_len]u8 = @splat(0);
        for (0..longest) |symbol| lengths[symbol * spread_stride + spread_offset] = @intCast(symbol + 1);
        lengths[longest * spread_stride + spread_offset] = @intCast(longest);
        var table: LiteralTable = undefined;
        try testing.expectEqual(reference_table_len(&lengths), table.build(&lengths));
        try expect_table_matches(&table, &lengths);
        try expect_builds_alike(&lengths);
    }
}

/// The orders of a simple code's four symbols.
const simple_orders = 24;

/// The `index`th of the orders of `symbols`: each place takes one of the symbols left, in the mixed
/// radix of how many are left.
fn nth_order(symbols: [constants.simple_symbols_max]u16, index: usize) [constants.simple_symbols_max]u16 {
    var left = symbols;
    var left_count: usize = left.len;
    var rest = index;
    var order: [constants.simple_symbols_max]u16 = undefined;
    for (&order) |*symbol| {
        const pick = rest % left_count;
        rest /= left_count;
        symbol.* = left[pick];
        left[pick] = left[left_count - 1];
        left_count -= 1;
    }
    return order;
}

test "a simple code's table is the canonical code of its lengths, in every order of its symbols" {
    const symbols = [constants.simple_symbols_max]u16{ 200, 7, 64, 255 };
    const shapes = constants.simple_code_lengths ++ [_][]const u8{&constants.simple_code_lengths_tree_select};
    for (shapes, 0..) |shape, shape_index| {
        const tree_select = shape_index == constants.simple_code_lengths.len;
        for (0..simple_orders) |order_index| {
            const order = nth_order(symbols, order_index);
            const coded = order[0..shape.len];
            var lengths: [constants.literal_alphabet_len]u8 = @splat(0);
            for (coded, shape) |symbol, len| lengths[symbol] = len;
            var canonical: LiteralTable = undefined;
            var simple: LiteralTable = undefined;
            const canonical_len = canonical.build(&lengths);
            try testing.expectEqual(canonical_len, simple.build_simple(coded, tree_select));
            try testing.expectEqualSlices(prefix.Entry, canonical.entries[0..canonical_len], simple.entries[0..canonical_len]);
        }
    }
}

test "each run takes one slot, and the largest alphabet holds a run for each symbol" {
    var ranges: prefix.Ranges = undefined;
    ranges.reset();
    // Lengths 1 and 2 in turn: no symbol's run continues its length's run before it.
    for (0..constants.insert_copy_alphabet_len) |symbol| {
        ranges.append(@intCast(1 + symbol % 2), @intCast(symbol), 1);
        try testing.expectEqual(symbol + 1, ranges.count);
    }
    // A symbol after its length's last run joins it and takes no slot.
    var joined: prefix.Ranges = undefined;
    joined.reset();
    joined.append(1, 0, 1);
    joined.append(1, 1, 2);
    try testing.expectEqual(1, joined.count);
    try testing.expectEqual(3, joined.ranges[0].count);
}
