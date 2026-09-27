//! Tests for the Literals_Section: each header form of RFC 8878 §3.1.1.3.1.1 for each kind, one
//! and four Huffman-coded streams, a treeless section reusing the tree before it, and each refusal.

const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");
const literals = @import("literals.zig");
const StreamWriter = @import("test_writer.zig").StreamWriter;

/// The literals a block may regenerate in these tests: Block_Maximum_Size.
const len_max: u32 = constants.block_len_max;

/// The bits before a Huffman-coded header's sizes: Literals_Block_Type and Size_Format.
const kind_and_format_bits = 4;

/// The longest literals section header, in octets.
const header_len_max = 5;

/// The streams of a 4-stream section, and the octets of one Jump_Table entry.
const streams = constants.literal_streams;
const jump_entry_len = @sizeOf(u16);

/// Literals_Block_Type (RFC 8878 §3.1.1.3.1.1, Table 13).
const compressed_kind = 2;
const treeless_kind = 3;

const Fixture = struct {
    table: huffman.Table = undefined,
    table_valid: bool = false,
    buffer: [constants.block_len_max]u8 = undefined,

    fn tables(self: *Fixture) literals.Tables {
        return .{ .table = &self.table, .table_valid = &self.table_valid, .buffer = &self.buffer };
    }
};

/// A Huffman-coded section's header: the kind, Size_Format, then Regenerated_Size and
/// Compressed_Size in the widths the format gives, least significant bit first.
fn compressed_header(kind: u2, format: u2, len: u32, compressed_len: u32, octets: *[header_len_max]u8) []const u8 {
    const size_bits = constants.literals_compressed_size_bits[format];
    const value: u64 = kind | @as(u64, format) << constants.literals_size_format_shift | @as(u64, len) << kind_and_format_bits |
        @as(u64, compressed_len) << (kind_and_format_bits + size_bits);
    std.mem.writeInt(u40, octets, @intCast(value), .little);
    return octets[0 .. (kind_and_format_bits + constants.literals_compressed_sizes * @as(usize, size_bits)) / @bitSizeOf(u8)];
}

test "raw literals in each header form stay in the block, after the header" {
    var fixture: Fixture = .{};
    // One octet: Size_Format 0, 5 bits of size.
    const short = [_]u8{ 5 << 3, 'a', 'b', 'c', 'd', 'e', 'x' };
    const one = try literals.read(&short, len_max, fixture.tables());
    try testing.expectEqual(literals.Section{ .source = .block, .len = 5, .offset = 1, .octet = 0, .section_len = 6 }, one);
    // Two octets: Size_Format 01, 12 bits.
    var two_form: [2 + 1000]u8 = undefined;
    two_form[0] = 1 << 2 | (1000 & 0xf) << 4;
    two_form[1] = 1000 >> 4;
    const two = try literals.read(&two_form, len_max, fixture.tables());
    try testing.expectEqual(literals.Section{ .source = .block, .len = 1000, .offset = 2, .octet = 0, .section_len = 1002 }, two);
}

test "repeated literals in the three-octet form keep one octet" {
    var fixture: Fixture = .{};
    const len: u32 = 70_000;
    const block = [_]u8{ 1 | 3 << 2 | (len & 0xf) << 4, (len >> 4) & 0xff, len >> 12, 'z' };
    const section = try literals.read(&block, len_max, fixture.tables());
    try testing.expectEqual(literals.Section{ .source = .repeated, .len = len, .offset = 0, .octet = 'z', .section_len = 4 }, section);
}

test "one Huffman-coded stream decodes, and a treeless section reuses its tree" {
    // RFC 8878 Table 24: literals 0 to 4 weigh 4, 3, 2, 0 and 1, and 5's weight of 1 is deduced.
    const tree = [_]u8{ constants.huffman_direct_symbols_offset + 5, 0x43, 0x20, 0x10 };
    var fixture: Fixture = .{};
    const text = [_]u8{ 0, 1, 1, 5, 2, 4, 0, 0, 2, 5, 1 };
    var built: huffman.Table = undefined;
    _ = try huffman.read_tree(&tree, &built);
    var writer: StreamWriter = .{};
    const stream = writer.write(&built, &text);
    var block: [64]u8 = undefined;
    var header: [header_len_max]u8 = undefined;
    const head = compressed_header(compressed_kind, 0, text.len, @intCast(tree.len + stream.len), &header);
    @memcpy(block[0..head.len], head);
    @memcpy(block[head.len..][0..tree.len], &tree);
    @memcpy(block[head.len + tree.len ..][0..stream.len], stream);
    const section = try literals.read(&block, len_max, fixture.tables());
    try testing.expectEqual(literals.Source.buffer, section.source);
    try testing.expectEqual(head.len + tree.len + stream.len, section.section_len);
    try testing.expectEqualSlices(u8, &text, fixture.buffer[0..text.len]);
    // A treeless section: the same stream without the tree.
    const treeless_head = compressed_header(treeless_kind, 0, text.len, @intCast(stream.len), &header);
    @memcpy(block[0..treeless_head.len], treeless_head);
    @memcpy(block[treeless_head.len..][0..stream.len], stream);
    @memset(&fixture.buffer, 0);
    _ = try literals.read(&block, len_max, fixture.tables());
    try testing.expectEqualSlices(u8, &text, fixture.buffer[0..text.len]);
    var fresh: Fixture = .{};
    try testing.expectError(error.TreelessWithoutTree, literals.read(&block, len_max, fresh.tables()));
}

/// A 4-stream section of `text` with `tree`, the streams split as RFC 8878 §3.1.1.3.1.6 splits
/// them: (Regenerated_Size + 3) / 4 literals each, the last holding what remains.
fn four_streams(tree: []const u8, built: *const huffman.Table, text: []const u8, block: []u8) []const u8 {
    const segment_len = (text.len + streams - 1) / streams;
    var writers: [streams]StreamWriter = @splat(.{});
    var written: [streams][]const u8 = undefined;
    for (&written, &writers, 0..) |*stream, *writer, index| {
        const start = @min(index * segment_len, text.len);
        const end = if (index == streams - 1) text.len else @min(start + segment_len, text.len);
        stream.* = writer.write(built, text[start..end]);
    }
    var at: usize = header_len_max + tree.len;
    @memcpy(block[header_len_max..at], tree);
    for (written[0 .. streams - 1]) |stream| {
        std.mem.writeInt(u16, block[at..][0..jump_entry_len], @intCast(stream.len), .little);
        at += jump_entry_len;
    }
    for (written) |stream| {
        @memcpy(block[at..][0..stream.len], stream);
        at += stream.len;
    }
    var header: [header_len_max]u8 = undefined;
    const widest_format = constants.literals_compressed_size_bits.len - 1;
    const head = compressed_header(compressed_kind, widest_format, @intCast(text.len), @intCast(at - header_len_max), &header);
    @memcpy(block[0..header_len_max], head);
    return block[0..at];
}

test "four Huffman-coded streams decode in order, the last holding what remains" {
    const tree = [_]u8{ constants.huffman_direct_symbols_offset + 5, 0x43, 0x20, 0x10 };
    const alphabet = [_]u8{ 0, 1, 2, 4, 5 };
    var built: huffman.Table = undefined;
    _ = try huffman.read_tree(&tree, &built);
    for ([_]usize{ 6, 7, 8, 9, 20, 101 }) |len| {
        var text: [101]u8 = undefined;
        for (text[0..len], 0..) |*literal, index| literal.* = alphabet[(index * 7 + index / 3) % alphabet.len];
        var block: [256]u8 = undefined;
        const section_octets = four_streams(&tree, &built, text[0..len], &block);
        var fixture: Fixture = .{};
        const section = try literals.read(section_octets, len_max, fixture.tables());
        try testing.expectEqual(section_octets.len, section.section_len);
        try testing.expectEqualSlices(u8, text[0..len], fixture.buffer[0..len]);
    }
}

test "a long section of a tree whose codes pair builds the pairs, and a short or flat one does not" {
    // The tree above: codes of 1 to 4 bits, where 11 of every 16 lookups find two literals, past
    // the half that repays the pairs (claim Z2), which a section does from 4 literals a cell, 64.
    const paired_tree = [_]u8{ constants.huffman_direct_symbols_offset + 5, 0x43, 0x20, 0x10 };
    // 16 literals of weight 1, the last deduced: 4-bit codes, no two of which fit in 4 bits.
    const flat_tree = [_]u8{ constants.huffman_direct_symbols_offset + 15, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x10 };
    const pairs_len = constants.pairs_literals_per_cell << 4;
    const cases = [_]struct { []const u8, usize, bool }{
        .{ &paired_tree, pairs_len - 1, false },
        .{ &paired_tree, pairs_len, true },
        .{ &flat_tree, pairs_len, false },
    };
    const alphabet = [_]u8{ 0, 1, 2, 4, 5 };
    for (cases) |case| {
        const tree, const len, const paired = case;
        var built: huffman.Table = undefined;
        _ = try huffman.read_tree(tree, &built);
        var text: [pairs_len]u8 = undefined;
        for (text[0..len], 0..) |*literal, index| literal.* = alphabet[index % alphabet.len];
        var block: [256]u8 = undefined;
        var fixture: Fixture = .{};
        _ = try literals.read(four_streams(tree, &built, text[0..len], &block), len_max, fixture.tables());
        try testing.expectEqual(paired, fixture.table.pairs_ready);
        try testing.expectEqualSlices(u8, text[0..len], fixture.buffer[0..len]);
    }
}

test "too many literals, a cut section, and a jump table past its streams are refused" {
    const tree = [_]u8{ constants.huffman_direct_symbols_offset + 5, 0x43, 0x20, 0x10 };
    var fixture: Fixture = .{};
    // 5 raw literals where the block holds 3.
    try testing.expectError(error.LiteralsTruncated, literals.read(&.{ 5 << 3, 'a', 'b', 'c' }, len_max, fixture.tables()));
    // 20 literals where Block_Maximum_Size is 16.
    try testing.expectError(error.LiteralsTooLong, literals.read(&.{ 20 << 3, 'a' }, 16, fixture.tables()));
    var header: [header_len_max]u8 = undefined;
    // Four streams with a Compressed_Size of 5, under the jump table's 6 (erratum 7297).
    var block: [32]u8 = @splat(0x80);
    const head = compressed_header(treeless_kind, 1, 8, 5, &header);
    @memcpy(block[0..head.len], head);
    fixture.table_valid = true;
    _ = try huffman.read_tree(&tree, &fixture.table);
    try testing.expectError(error.JumpTableInvalid, literals.read(&block, len_max, fixture.tables()));
    // A jump table naming 3 streams of 20 octets in a Compressed_Size of 20.
    const long_head = compressed_header(treeless_kind, 1, 8, 20, &header);
    @memcpy(block[0..long_head.len], long_head);
    for (0..3) |index| std.mem.writeInt(u16, block[long_head.len + 2 * index ..][0..2], 20, .little);
    try testing.expectError(error.JumpTableInvalid, literals.read(&block, len_max, fixture.tables()));
    // Streams of 5 octets each in 20: 15 fits the section but not the 14 its jump table leaves.
    for (0..3) |index| std.mem.writeInt(u16, block[long_head.len + 2 * index ..][0..2], 5, .little);
    try testing.expectError(error.JumpTableInvalid, literals.read(&block, len_max, fixture.tables()));
    // Five literals in four streams: Regenerated_Size under 6 (erratum 7297).
    const few_head = compressed_header(treeless_kind, 1, 5, 10, &header);
    @memcpy(block[0..few_head.len], few_head);
    for (0..3) |index| std.mem.writeInt(u16, block[few_head.len + 2 * index ..][0..2], 1, .little);
    try testing.expectError(error.JumpTableInvalid, literals.read(&block, len_max, fixture.tables()));
}
