//! Tests for the literal decoding fast path: seeded streams long enough for many loads, under a
//! shallow tree, the deepest one and a one-bit one, decoded on the fast path, streams interleaved
//! and one after another, and on the checked path, one stream and four, valid and with bits flipped.
//! Every way must give the same literals and the same verdict (decision 16).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const fast_literals = @import("fast_literals.zig");
const literals_section = @import("literals.zig");
const aarch64 = @import("fast_literals_aarch64.zig");
const sequences_x86_64 = @import("fast_sequences/fast_sequences_x86_64.zig");
const test_writer = @import("test_writer.zig");

/// The most literals of a stream, and the seeds each test takes. Each stream draws its count, so a
/// load meets every remainder of literals at a stream's end.
const stream_literals = 400;
const seeds = 64;

/// The trees: RFC 8878 Table 24's (literals 0 to 5 but 3, up to 4 bits); literals 0 to 11 weighing
/// 11 down to 1 and 1, up to 11 bits; literals 0 and 1 of one bit each; and literals 0 to 15 of
/// weight 1, 4 bits each, so a load's literals take its most bits.
const trees = [_][]const u8{ "\x84\x43\x20\x10", "\x8a\xba\x98\x76\x54\x32\x10", "\x80\x10", "\x8e\x11\x11\x11\x11\x11\x11\x11\x10" };

/// The streams of a four-stream section.
const streams = constants.literal_streams;

/// A literal the tree gives a code, drawn.
fn present_literal(generator: *codec.split.Generator, table: *const huffman.Table) u8 {
    const cells = table.cells[0 .. @as(usize, 1) << table.bits_max];
    return cells[generator.below(cells.len)].symbol;
}

/// A literal whose code is the tree's longest, drawn, so a load's literals take its most bits. The
/// longest codes take the table's first cells, one each.
fn deepest_literal(generator: *codec.split.Generator, table: *const huffman.Table) u8 {
    const cells = table.cells[0 .. @as(usize, 1) << table.bits_max];
    var deepest: usize = 0;
    while (deepest < cells.len and cells[deepest].bits == table.bits_max) deepest += 1;
    return cells[generator.below(deepest)].symbol;
}

const Draw = *const fn (*codec.split.Generator, *const huffman.Table) u8;

/// Seeded streams of `stream_literals` literals each, written as the checked decoder reads them.
const Streams = struct {
    writers: [streams]test_writer.StreamWriter = @splat(.{}),
    octets: [streams][]u8 = undefined,
    counts: [streams]usize = undefined,

    fn write(self: *Streams, generator: *codec.split.Generator, table: *const huffman.Table) void {
        self.write_drawn(generator, table, present_literal);
    }

    fn write_drawn(self: *Streams, generator: *codec.split.Generator, table: *const huffman.Table, draw: Draw) void {
        for (&self.writers, &self.octets, &self.counts) |*writer, *octets, *count| {
            count.* = generator.between(1, stream_literals);
            var literals: [stream_literals]u8 = undefined;
            for (literals[0..count.*]) |*literal| literal.* = draw(generator, table);
            const written = writer.write(table, literals[0..count.*]);
            octets.* = writer.octets[0..written.len];
        }
    }

    fn flip(self: *Streams, generator: *codec.split.Generator) void {
        const stream = self.octets[generator.below(streams)];
        stream[generator.below(stream.len)] ^= @as(u8, 1) << @intCast(generator.below(@bitSizeOf(u8)));
    }
};

/// The octet the output past the last stream's literals holds, which no decode may write.
const sentinel = 0xee;

/// Decodes `count` of the streams through `decode` and on the checked path, and requires the same
/// verdict and, when they decode, the same literals. The outputs lie one after another, as the
/// decoder's do, so a stream's writes past its own would change the next's, and the octets past
/// the last must stay as they were. The fast path runs with the x86-64 assembly off, and on where
/// the CPU runs it.
fn expect_alike(comptime count: usize, comptime claims: @import("claims.zig").Claims, table: *const huffman.Table, octets: [count][]const u8, counts: [count]usize) !void {
    for ([_]bool{ false, sequences_x86_64.runs(codec.Features.detect()) }) |assembly| try expect_alike_with(count, claims, table, octets, counts, assembly);
}

fn expect_alike_with(comptime count: usize, comptime claims: @import("claims.zig").Claims, table: *const huffman.Table, octets: [count][]const u8, counts: [count]usize, assembly: bool) !void {
    var fast_buffer: [count * stream_literals + stream_literals]u8 = @splat(sentinel);
    var checked_buffer: [count * stream_literals]u8 = undefined;
    var fast_outputs: [count][]u8 = undefined;
    var checked_outputs: [count][]u8 = undefined;
    var start: usize = 0;
    for (&fast_outputs, &checked_outputs, counts) |*fast, *checked, literals| {
        fast.* = fast_buffer[start..][0..literals];
        checked.* = checked_buffer[start..][0..literals];
        start += literals;
    }
    const fast = literals_section.decode_streams(.{ .claims = claims }, count, table, octets, fast_outputs, assembly);
    var checked: literals_section.Error!void = {};
    for (octets, checked_outputs) |stream, output| {
        checked = huffman.decode_stream(table, stream, output);
        if (checked) |_| {} else |_| break;
    }
    try testing.expectEqual(checked, fast);
    if (fast) |_| {
        try testing.expectEqualSlices(u8, checked_buffer[0..start], fast_buffer[0..start]);
    } else |_| {}
    try testing.expect(std.mem.allEqual(u8, fast_buffer[start..], sentinel));
}

/// The four streams as the decoder takes them.
fn four_of(set: *const Streams) [streams][]const u8 {
    var four: [streams][]const u8 = undefined;
    for (&four, set.octets) |*stream, octets| stream.* = octets;
    return four;
}

fn expect_each_way(table: *const huffman.Table, set: *const Streams) !void {
    const four = four_of(set);
    try expect_alike(streams, .{}, table, four, set.counts);
    try expect_alike(streams, .{ .interleaved_streams = false }, table, four, set.counts);
    try expect_alike(1, .{}, table, .{set.octets[0]}, .{set.counts[0]});
}

test "long streams decode alike on the fast path, interleaved and one by one, and the checked path" {
    for (trees) |tree| {
        var table: huffman.Table = undefined;
        _ = try huffman.read_tree(tree, &table);
        // One literal a lookup, then pairs (Z2).
        for (0..2) |_| {
            for (0..seeds) |seed| {
                var generator = codec.split.Generator.init(seed);
                var set: Streams = .{};
                set.write(&generator, &table);
                try expect_each_way(&table, &set);
                // A flipped bit: the streams no longer end where their literals do, or decode others.
                set.flip(&generator);
                try expect_each_way(&table, &set);
            }
            fast_literals.build_pairs(&table);
        }
    }
}

/// Requires each of the table's pairs to name the literal its cell's code begins with, and the
/// literal after it when that one's code ends within the table's width; returns how many do.
fn expect_pairs(table: *const huffman.Table) !u32 {
    const len = @as(usize, 1) << table.bits_max;
    var doubles: u32 = 0;
    for (table.pairs[0..len], table.cells[0..len], 0..) |pair, first, index| {
        // The literal after the first, from the bits past its code, if its code ends in them.
        const second = table.cells[(index << @intCast(first.bits)) & (len - 1)];
        const both = first.bits + second.bits <= table.bits_max;
        try testing.expectEqual(first.symbol, @as(u8, @truncate(pair.literals)));
        try testing.expectEqual(@as(u8, 1) + @intFromBool(both), pair.count);
        try testing.expectEqual(if (both) first.bits + second.bits else first.bits, pair.bits);
        if (both) try testing.expectEqual(second.symbol, @as(u8, @truncate(pair.literals >> @bitSizeOf(u8))));
        doubles += @intFromBool(both);
    }
    return doubles;
}

test "a table's pairs hold what its cells give two at a time, and its share counts them" {
    var octets: [deepening_tree_len_max]u8 = undefined;
    for (0..trees.len + constants.huffman_bits_max) |which| {
        const tree = if (which < trees.len) trees[which] else deepening_tree(@intCast(which - trees.len + 1), &octets);
        var table: huffman.Table = undefined;
        _ = try huffman.read_tree(tree, &table);
        fast_literals.build_pairs(&table);
        const doubles = try expect_pairs(&table);
        // Every cell is as likely as another, so the share is the fraction of pairs of two.
        try testing.expectEqual((doubles << constants.pair_share_bits) >> table.bits_max, table.pair_share());
    }
}

test "a new tree drops the pairs of the one before" {
    var table: huffman.Table = undefined;
    _ = try huffman.read_tree(trees[1], &table);
    fast_literals.build_pairs(&table);
    _ = try huffman.read_tree(trees[0], &table);
    try testing.expect(!table.pairs_ready);
    var generator = codec.split.Generator.init(3);
    var set: Streams = .{};
    set.write(&generator, &table);
    try expect_each_way(&table, &set);
}

/// The octets of the deepest tree `deepening_tree` writes: its header, then 11 weights.
const deepening_tree_len_max = 1 + (constants.huffman_bits_max + constants.huffman_weights_per_octet - 1) / constants.huffman_weights_per_octet;

/// A tree whose longest code takes `bits_max` bits: literals 0 to `bits_max - 1` weighing
/// `bits_max` down to 1, and literal `bits_max` weighing 1, written directly (RFC 8878 §4.2.1.1).
fn deepening_tree(bits_max: u4, octets: *[deepening_tree_len_max]u8) []const u8 {
    const per_octet = constants.huffman_weights_per_octet;
    octets.* = @splat(0);
    octets[0] = constants.huffman_direct_symbols_offset + @as(u8, bits_max);
    for (0..bits_max) |literal| {
        const weight: u8 = @intCast(bits_max - literal);
        // The first weight of an octet takes its top half (RFC 8878 §4.2.1.1).
        octets[1 + literal / per_octet] |= if (literal % per_octet == 0) weight << constants.huffman_weight_bits else weight;
    }
    return octets[0 .. 1 + (bits_max + per_octet - 1) / per_octet];
}

test "the fast path leaves no literal of a valid stream to the checked decoder" {
    for (trees) |tree| {
        var table: huffman.Table = undefined;
        _ = try huffman.read_tree(tree, &table);
        for (0..seeds) |seed| {
            var generator = codec.split.Generator.init(seed);
            var set: Streams = .{};
            set.write(&generator, &table);
            inline for ([_]@import("claims.zig").Claims{ .{}, .{ .interleaved_streams = false } }) |claims| {
                for ([_]bool{ false, sequences_x86_64.runs(codec.Features.detect()) }) |assembly| try expect_all_decoded(claims, &table, &set, assembly);
            }
        }
    }
}

/// Decodes `set` on the fast path alone, and requires every literal of every stream and every
/// stream read to its first bit.
fn expect_all_decoded(comptime claims: @import("claims.zig").Claims, table: *const huffman.Table, set: *const Streams, assembly: bool) !void {
    var buffers: [streams][stream_literals]u8 = undefined;
    var outputs: [streams][]u8 = undefined;
    var readers: [streams]codec.BackwardBitReader = undefined;
    for (&outputs, &buffers, set.counts, &readers, set.octets) |*output, *buffer, count, *reader, octets| {
        output.* = buffer[0..count];
        reader.* = codec.BackwardBitReader.init(octets).?;
    }
    try testing.expectEqual(set.counts, fast_literals.decode(streams, claims, table, four_of(set), outputs, &readers, assembly));
    for (readers) |reader| try testing.expect(reader.finished());
}

test "every longest code from 1 to 11 bits decodes alike on each path, each its own loop" {
    for (0..2 * constants.huffman_bits_max) |which| {
        const bits_max = which % constants.huffman_bits_max + 1;
        var octets: [deepening_tree_len_max]u8 = undefined;
        var table: huffman.Table = undefined;
        _ = try huffman.read_tree(deepening_tree(@intCast(bits_max), &octets), &table);
        try testing.expectEqual(bits_max, table.bits_max);
        // The second round decodes in pairs (Z2).
        if (which >= constants.huffman_bits_max) fast_literals.build_pairs(&table);
        for (0..seeds / 8) |seed| {
            var generator = codec.split.Generator.init(seed);
            // Literals of every code, then of the longest alone, so a load's literals take its
            // most bits.
            for ([_]Draw{ present_literal, deepest_literal }) |draw| {
                var set: Streams = .{};
                set.write_drawn(&generator, &table, draw);
                try expect_each_way(&table, &set);
                set.flip(&generator);
                try expect_each_way(&table, &set);
            }
        }
    }
}

test "a stream that ends in an octet of 0 sends every stream to the checked path, refusals in order" {
    var table: huffman.Table = undefined;
    _ = try huffman.read_tree(trees[0], &table);
    var generator = codec.split.Generator.init(1);
    var set: Streams = .{};
    set.write(&generator, &table);
    // The second stream's last octet cleared, and a bit of the first flipped: the checked path
    // refuses the first stream before it reaches the second.
    set.octets[1][set.octets[1].len - 1] = 0;
    const four = four_of(&set);
    try expect_alike(streams, .{}, &table, four, set.counts);
    set.octets[0][0] ^= 1;
    try expect_alike(streams, .{}, &table, four, set.counts);
}

test "a stream that holds more bits than its literals take is refused as on the checked path" {
    for (trees) |tree| {
        var table: huffman.Table = undefined;
        _ = try huffman.read_tree(tree, &table);
        var generator = codec.split.Generator.init(2);
        var set: Streams = .{};
        set.write(&generator, &table);
        // A load's worth of literals and fewer, from a stream of up to 400: the stream's bits
        // outlast them, and the margin of literals alone must stop the loop.
        const per_load = fast_literals.literals_per_load(table.bits_max);
        for ([_]usize{ per_load - 1, per_load, per_load + 1 }) |count| {
            if (count > set.counts[0]) continue;
            try expect_alike(1, .{}, &table, .{set.octets[0]}, .{count});
        }
    }
}

test "four streams that hold more bits than their literals take stop at their outputs" {
    var octets: [deepening_tree_len_max]u8 = undefined;
    for (0..trees.len + constants.huffman_bits_max) |which| {
        const tree = if (which < trees.len) trees[which] else deepening_tree(@intCast(which - trees.len + 1), &octets);
        var table: huffman.Table = undefined;
        _ = try huffman.read_tree(tree, &table);
        // One literal a lookup, then pairs (Z2), whose stores need twice the room.
        for (0..2) |_| {
            var generator = codec.split.Generator.init(which);
            var set: Streams = .{};
            set.write_drawn(&generator, &table, deepest_literal);
            // Outputs of half the literals, and of a few: the streams' bits outlast them, so only the
            // outputs' room may stop the loops.
            var halves: [streams]usize = undefined;
            var few: [streams]usize = undefined;
            for (&halves, &few, set.counts) |*half, *some, count| {
                half.* = count / 2;
                some.* = @min(count, 9);
            }
            try expect_alike(streams, .{}, &table, four_of(&set), halves);
            try expect_alike(streams, .{}, &table, four_of(&set), few);
            // Outputs of whole passes, where a pass of pairs of one literal each leaves room for
            // one more pass of literals but not of pairs' stores.
            const pass = aarch64.per_pass(table.bits_max);
            var whole: [streams]usize = undefined;
            for (&whole, set.counts) |*len, count| len.* = @min(count, 3 * pass);
            try expect_alike(streams, .{}, &table, four_of(&set), whole);
            fast_literals.build_pairs(&table);
        }
    }
}

test "four streams too short for their literals are refused as on the checked path" {
    // Streams of no bits and of a few, each for more literals than their bits hold: the loops must
    // not start on them, so no position passes a stream's first bit.
    var octets: [deepening_tree_len_max]u8 = undefined;
    var table: huffman.Table = undefined;
    _ = try huffman.read_tree(deepening_tree(constants.huffman_bits_max, &octets), &table);
    for (0..2) |_| {
        for ([_][]const u8{ "\x01", "\x03", "\x0f", "\xff\x01" }) |stream| {
            for ([_]usize{ 4, 8, 16 }) |count| try expect_alike(streams, .{}, &table, @splat(stream), @splat(count));
        }
        fast_literals.build_pairs(&table);
    }
}

test "four short streams of the shortest code under a deep tree decode alike" {
    // A tree of up to 11 bits whose literal 0 takes one: a stream of a few such literals holds far
    // fewer bits than a pass of the deepest codes needs, so the loops must not start on it.
    var octets: [deepening_tree_len_max]u8 = undefined;
    var table: huffman.Table = undefined;
    _ = try huffman.read_tree(deepening_tree(constants.huffman_bits_max, &octets), &table);
    try testing.expectEqual(1, table.cells[(@as(usize, 1) << table.bits_max) - 1].bits);
    for (0..2) |_| {
        for (1..24) |count| {
            var writers: [streams]test_writer.StreamWriter = @splat(.{});
            var four: [streams][]const u8 = undefined;
            const zeros: [24]u8 = @splat(0);
            for (&writers, &four) |*writer, *stream| stream.* = writer.write(&table, zeros[0..count]);
            try expect_alike(streams, .{}, &table, four, @splat(count));
        }
        fast_literals.build_pairs(&table);
    }
}
