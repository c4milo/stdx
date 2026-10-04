//! Tests for the encoder's codes: the lengths of both builders against Huffman's coded size where
//! the limit does not bind, every code complete by the decoder's own check, each canonical code
//! decoded back to its symbol, and the code length symbols expanded back to the lengths.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const huffman = @import("../huffman.zig");
const code = @import("encoder_code.zig");

/// The coded size of `counts` under `lengths`, in bits.
fn coded_bits(counts: []const u16, lengths: []const u8) u64 {
    var bits: u64 = 0;
    for (counts, lengths) |count, len| bits += @as(u64, count) * len;
    return bits;
}

/// The coded size of an unlimited Huffman code for `counts`: each merge of the two lightest nodes
/// adds their weight once more (RFC 1951 §3.2.2 names no builder; this is Huffman's).
fn huffman_bits(counts: []const u16) u64 {
    var nodes: [code.symbols_max]u64 = undefined;
    var len: usize = 0;
    for (counts) |count| {
        if (count == 0) continue;
        nodes[len] = count;
        len += 1;
    }
    var bits: u64 = 0;
    for (0..counts.len) |_| {
        if (len <= 1) break;
        std.mem.sort(u64, nodes[0..len], {}, std.sort.asc(u64));
        const merged = nodes[0] + nodes[1];
        bits += merged;
        nodes[0] = merged;
        nodes[1] = nodes[len - 1];
        len -= 1;
    }
    return bits;
}

/// Requires the lengths complete, within `len_max`, and accepted by the decoder's builder.
fn expect_complete(comptime alphabet_len: usize, lengths: []const u8, len_max: u4) !void {
    var kraft: u64 = 0;
    for (lengths) |len| {
        try testing.expect(len <= len_max);
        if (len > 0) kraft += @as(u64, 1) << @intCast(constants.code_len_max - len);
    }
    try testing.expectEqual(@as(u64, 1) << constants.code_len_max, kraft);
    var decoder_code: huffman.Code(alphabet_len) = undefined;
    var work: huffman.Work = huffman.work_zero;
    try decoder_code.build(lengths, .complete, &work);
}

test "both builders give Huffman's coded size where 15 bits do not bind" {
    for (0..100) |seed| {
        var generator = codec.split.Generator.init(seed);
        var counts: [constants.literal_length_used]u16 = @splat(0);
        const symbols = generator.between(2, counts.len);
        // Counts within a factor of two keep Huffman's code under 15 bits; a quarter are 0.
        for (counts[0..symbols]) |*count| count.* = if (generator.below(4) == 0) 0 else @intCast(500 + generator.below(500));
        counts[0] += 1;
        counts[1] += 1;
        var lengths: [counts.len]u8 = undefined;
        inline for (.{ code.build_lengths, code.build_lengths_package_merge }) |build| {
            build(&counts, constants.code_len_max, &lengths);
            try expect_complete(constants.literal_length_alphabet_len, &lengths, constants.code_len_max);
            try testing.expectEqual(huffman_bits(&counts), coded_bits(&counts, &lengths));
        }
    }
}

test "counts that would need codes past 15 bits get codes of 15" {
    // Fibonacci counts make Huffman's code one bit deeper per symbol: 24 symbols, 23 bits.
    var counts: [24]u16 = undefined;
    counts[0] = 1;
    counts[1] = 1;
    for (2..counts.len) |index| counts[index] = counts[index - 1] + counts[index - 2];
    var lengths: [counts.len]u8 = undefined;
    code.build_lengths(&counts, constants.code_len_max, &lengths);
    try testing.expectEqual(constants.code_len_max, std.mem.max(u8, &lengths));
    try expect_complete(constants.distance_alphabet_len, &lengths, constants.code_len_max);
    try testing.expect(coded_bits(&counts, &lengths) >= huffman_bits(&counts));
    // The code length code's limit of 7 bits (RFC 1951 §3.2.7).
    var short: [constants.code_length_alphabet_len]u16 = counts[0..constants.code_length_alphabet_len].*;
    var short_lengths: [short.len]u8 = undefined;
    code.build_lengths(&short, 7, &short_lengths);
    try testing.expectEqual(7, std.mem.max(u8, &short_lengths));
    try expect_complete(constants.code_length_alphabet_len, &short_lengths, 7);
}

test "a code with one symbol or none still codes two, one bit each" {
    var counts: [constants.distance_used]u16 = @splat(0);
    var lengths: [counts.len]u8 = undefined;
    code.build_lengths(&counts, constants.code_len_max, &lengths);
    try testing.expectEqualSlices(u8, &.{ 1, 1 }, lengths[0..2]);
    try testing.expectEqual(2, std.mem.count(u8, &lengths, &.{1}));
    counts[7] = 4;
    code.build_lengths(&counts, constants.code_len_max, &lengths);
    try testing.expectEqual(1, lengths[0]);
    try testing.expectEqual(1, lengths[7]);
    try testing.expectEqual(2, std.mem.count(u8, &lengths, &.{1}));
}

test "each canonical code, reversed, decodes to its symbol" {
    var generator = codec.split.Generator.init(7);
    var counts: [constants.literal_length_used]u16 = undefined;
    for (&counts) |*count| count.* = @intCast(generator.below(300));
    var lengths: [counts.len]u8 = undefined;
    code.build_lengths(&counts, constants.code_len_max, &lengths);
    var codes: [counts.len]u16 = undefined;
    code.build_codes(&lengths, &codes);
    var decoder_code: huffman.Code(constants.literal_length_alphabet_len) = undefined;
    var work: huffman.Work = huffman.work_zero;
    try decoder_code.build(&lengths, .complete, &work);
    for (lengths, codes, 0..) |len, reversed, symbol| {
        if (len == 0) continue;
        const decoded = decoder_code.decode(reversed, @intCast(len)).symbol;
        try testing.expectEqual(symbol, decoded.value);
        try testing.expectEqual(len, decoded.len);
    }
}

/// The lengths `items` stand for (RFC 1951 §3.2.7).
fn expand(items: []const code.Item, lengths: []u8) usize {
    var len: usize = 0;
    for (items) |item| {
        if (item.symbol < constants.repeat_previous) {
            lengths[len] = item.symbol;
            len += 1;
            continue;
        }
        const kind = item.symbol - constants.repeat_previous;
        const run = constants.repeat_count_min[kind] + item.extra;
        const value = if (item.symbol == constants.repeat_previous) lengths[len - 1] else 0;
        @memset(lengths[len..][0..run], value);
        len += run;
    }
    return len;
}

test "code lengths as runs: zeros as 17 and 18, a repeated length as 16, and back" {
    const lengths = [_]u8{0} ** 20 ++ [_]u8{5} ** 8 ++ [_]u8{3} ++ [_]u8{0} ** 7 ++ [_]u8{4} ++ [_]u8{0} ** 11 ++ [_]u8{2};
    var items: [code.items_max]code.Item = undefined;
    var counts: code.ItemCounts = undefined;
    const count = code.run_lengths(&lengths, &.{}, &items, &counts);
    // 20 zeros are 18 with 9; the first 5 is itself and 6 more are 16 with 3, the last 5 itself;
    // 7 zeros are 17 with 4; 11 zeros, the fewest 18 takes, are 18 with 0.
    const expected = [_]code.Item{
        .{ .symbol = 18, .extra = 9 }, .{ .symbol = 5 },              .{ .symbol = 16, .extra = 3 },
        .{ .symbol = 5 },              .{ .symbol = 3 },              .{ .symbol = 17, .extra = 4 },
        .{ .symbol = 4 },              .{ .symbol = 18, .extra = 0 }, .{ .symbol = 2 },
    };
    try testing.expectEqualSlices(code.Item, &expected, items[0..count]);
    try expect_counts(items[0..count], &counts);
    for (0..200) |seed| {
        var generator = codec.split.Generator.init(seed);
        var random: [code.items_max]u8 = undefined;
        const len = generator.between(1, random.len);
        for (random[0..len]) |*value| value.* = if (generator.below(3) == 0) @intCast(generator.below(16)) else 0;
        const random_count = code.run_lengths(random[0..len], &.{}, &items, &counts);
        var expanded: [code.items_max]u8 = undefined;
        try testing.expectEqual(len, expand(items[0..random_count], &expanded));
        try testing.expectEqualSlices(u8, random[0..len], expanded[0..len]);
        try expect_counts(items[0..random_count], &counts);
    }
}

/// Requires `counts` to say how often each code length symbol occurs among `items`.
fn expect_counts(items: []const code.Item, counts: *const code.ItemCounts) !void {
    var expected: code.ItemCounts = @splat(0);
    for (items) |item| expected[item.symbol] += 1;
    try testing.expectEqualSlices(u16, &expected, counts);
}

test "code lengths split across the two tables give the items of one sequence" {
    // RFC 1951 §3.2.7: a run may cross from the literal and length lengths into the distance
    // lengths, so the items cannot depend on where the first table ends.
    var whole_items: [code.items_max]code.Item = undefined;
    var split_items: [code.items_max]code.Item = undefined;
    for (0..100) |seed| {
        var generator = codec.split.Generator.init(seed);
        var lengths: [code.items_max]u8 = undefined;
        const len = generator.between(2, lengths.len);
        // Long runs of few values, so runs often cross a split.
        var value: u8 = 0;
        for (lengths[0..len]) |*length| {
            if (generator.below(8) == 0) value = @intCast(generator.below(4));
            length.* = value;
        }
        var whole_counts: code.ItemCounts = undefined;
        var split_counts: code.ItemCounts = undefined;
        const whole_count = code.run_lengths(lengths[0..len], &.{}, &whole_items, &whole_counts);
        for (1..len) |at| {
            const split_count = code.run_lengths(lengths[0..at], lengths[at..len], &split_items, &split_counts);
            try testing.expectEqualSlices(code.Item, whole_items[0..whole_count], split_items[0..split_count]);
            try testing.expectEqualSlices(u16, &whole_counts, &split_counts);
        }
    }
}
