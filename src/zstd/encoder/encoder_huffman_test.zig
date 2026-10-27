//! The tests of Huffman coding, each read back through the decoder's `read_tree` and
//! `decode_stream`.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const huffman = @import("../huffman.zig");
const encoder_huffman = @import("encoder_huffman.zig");

const message_len_max = 4096;

/// The octets a tree and a stream of `message_len_max` literals take at most.
const coded_len_max = 8192;

/// A message of `alphabet` literals from `first` on, skewed so that low ones come often and some
/// come once: deep codes that pass 11 bits before the limit.
fn draw_message(generator: *codec.split.Generator, message: []u8, first: usize, alphabet: usize) void {
    for (message) |*literal| {
        const skew = generator.below(alphabet);
        literal.* = @intCast(first + generator.below(skew + 1));
    }
}

fn expect_round_trip(message: []const u8) !void {
    var counts: [constants.literal_symbols]u32 = @splat(0);
    for (message) |literal| counts[literal] += 1;
    var code: encoder_huffman.Code = undefined;
    encoder_huffman.build(&counts, &code);
    var kraft: u32 = 0;
    for (code.lengths) |length| {
        try testing.expect(length <= constants.huffman_bits_max);
        if (length > 0) kraft += @as(u32, 1) << @intCast(constants.huffman_bits_max - length);
    }
    try testing.expectEqual(@as(u32, 1) << constants.huffman_bits_max, kraft);

    var octets: [coded_len_max]u8 = undefined;
    var writer = codec.Writer.init(&octets);
    var scratch: encoder_huffman.Scratch = undefined;
    encoder_huffman.write_tree(&writer, &code, &scratch) catch |err| {
        // Only weights that FSE cannot take and that are too many to write directly fail.
        try testing.expect(code.last > constants.huffman_direct_symbols_max);
        return err;
    };
    const tree_len = writer.position;
    var bits = codec.BitWriter.init(octets[tree_len..], .{});
    try encoder_huffman.write_stream(&bits, &code, message);
    const stream = bits.writer.written();
    try testing.expectEqual(encoder_huffman.streams_len(&code, &counts, 1), stream.len);

    var table: huffman.Table = undefined;
    try testing.expectEqual(tree_len, try huffman.read_tree(octets[0..tree_len], &table));
    try testing.expectEqual(code.bits_max, table.bits_max);
    var decoded: [message_len_max]u8 = undefined;
    try huffman.decode_stream(&table, stream, decoded[0..message.len]);
    try testing.expectEqualSlices(u8, message, decoded[0..message.len]);
}

test "Huffman-coded literals decode through the decoder's tree and stream" {
    var generator = codec.split.Generator.init(4);
    var message: [message_len_max]u8 = undefined;
    for (0..300) |_| {
        const len = generator.between(2, message_len_max);
        const alphabet = generator.between(2, constants.literal_symbols);
        const first = generator.below(constants.literal_symbols - alphabet + 1);
        draw_message(&generator, message[0..len], first, alphabet);
        // Two literals occur at least.
        message[0] = @intCast(first);
        message[1] = @intCast(first + alphabet - 1);
        expect_round_trip(message[0..len]) catch |err| switch (err) {
            error.NoSpaceLeft => continue,
            else => return err,
        };
    }
}

test "counts that double make codes past 11 bits, which the limit brings back" {
    var message: [message_len_max]u8 = undefined;
    var len: usize = 0;
    // Literal i occurs 2^i times for 13 literals: Huffman's tree is 12 deep.
    for (0..13) |literal| {
        const count = @as(usize, 1) << @intCast(@min(literal, 10));
        @memset(message[len..][0..count], @intCast(literal * 7));
        len += count;
    }
    try expect_round_trip(message[0..len]);
}

test "two literals take one bit each, and the description writes one weight directly" {
    try expect_round_trip("abababbbba");
}

test "literals over 128 take the FSE-compressed description" {
    var message: [600]u8 = undefined;
    for (&message, 0..) |*literal, index| literal.* = @intCast(200 + index % 50 - (index % 7));
    try expect_round_trip(&message);
}

test "deep trees whose repair overshoots get their room back, and stay whole" {
    // Counts that grow by a seeded factor, reset now and then: Huffman's tree passes 11 bits, and
    // bringing its leaves up to 11 often leaves the code short, which the repair fills again.
    var generator = codec.split.Generator.init(12);
    for (0..300) |_| {
        var counts: [constants.literal_symbols]u32 = @splat(0);
        draw_deep(&generator, &counts);
        var code: encoder_huffman.Code = undefined;
        encoder_huffman.build(&counts, &code);
        try expect_whole(&code, &counts);
        try expect_literals_round_trip(&counts);
    }
}

/// Counts that grow by a factor from 5/4 to 2, reset to a few one time in four.
fn draw_deep(generator: *codec.split.Generator, counts: *[constants.literal_symbols]u32) void {
    const used = generator.between(deep_used_min, constants.literal_symbols);
    const growth_quarters = generator.between(deep_growth_quarters_min, deep_growth_quarters_max);
    var weight: u64 = 1;
    for (0..used) |index| {
        counts[(index * deep_stride + generator.below(deep_jitter)) % constants.literal_symbols] += @intCast(@min(weight, deep_weight_max));
        weight = weight * growth_quarters / deep_growth_quarters_unit + 1;
        if (generator.below(deep_reset_odds) == 0) weight = generator.between(1, deep_reset_max);
    }
}

const deep_used_min = 14;
const deep_growth_quarters_min = 5;
const deep_growth_quarters_max = 8;
const deep_growth_quarters_unit = 4;
const deep_stride = 7;
const deep_jitter = 3;
const deep_weight_max = 1_073_741_824;
const deep_reset_odds = 4;
const deep_reset_max = 5;

/// Every literal that occurs has a length of at most 11, and the code's Kraft sum is whole.
fn expect_whole(code: *const encoder_huffman.Code, counts: *const [constants.literal_symbols]u32) !void {
    var kraft: u32 = 0;
    for (code.lengths, counts) |length, count| {
        try testing.expectEqual(count > 0, length > 0);
        try testing.expect(length <= constants.huffman_bits_max);
        if (length > 0) kraft += @as(u32, 1) << @intCast(constants.huffman_bits_max - length);
    }
    try testing.expectEqual(@as(u32, 1) << constants.huffman_bits_max, kraft);
}

/// A message of every literal that occurs once decodes back, where its description fits.
fn expect_literals_round_trip(counts: *const [constants.literal_symbols]u32) !void {
    var message: [constants.literal_symbols]u8 = undefined;
    var len: usize = 0;
    for (counts, 0..) |count, literal| {
        if (count == 0) continue;
        message[len] = @intCast(literal);
        len += 1;
    }
    if (len < constants.fse_symbols_present_min) return;
    expect_round_trip(message[0..len]) catch |err| switch (err) {
        error.NoSpaceLeft => {},
        else => return err,
    };
}
