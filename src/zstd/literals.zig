//! A compressed block's Literals_Section (RFC 8878 §3.1.1.3.1): its header, then raw literals, one
//! literal repeated, or Huffman-coded streams, one or four, after an optional tree description.
//!
//! The section is read from a whole block in memory. Raw literals stay in the block, named by
//! their offset, and a repeated literal stays one octet; Huffman-coded literals are decoded into
//! the caller's buffer. The state keeps offsets rather than slices, so it holds no pointer
//! (invariant 12).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const huffman = @import("huffman.zig");

/// Where a block's literals are.
pub const Source = enum(u8) {
    /// In the block, from `Section.offset`.
    block,
    /// One octet, `Section.octet`, repeated.
    repeated,
    /// In the literals buffer, from 0.
    buffer,
};

/// The literals of one block.
pub const Section = struct {
    source: Source,
    /// Regenerated_Size: how many literals there are.
    len: u32,
    /// For `block`, where they start in the block.
    offset: u32,
    /// For `repeated`, the octet.
    octet: u8,
    /// The octets of the block the section takes, header included.
    section_len: u32,
};

/// Every way a Literals_Section breaks RFC 8878 §3.1.1.3.1.
pub const Error = huffman.Error || error{
    LiteralsTruncated,
    LiteralsTooLong,
    TreelessWithoutTree,
    JumpTableInvalid,
};

/// Literals_Block_Type (RFC 8878 §3.1.1.3.1.1, Table 13).
const Kind = enum(u2) { raw = 0, repeated = 1, compressed = 2, treeless = 3 };

/// The bits before the sizes: Literals_Block_Type and Size_Format.
const kind_and_format_bits = 4;

/// Raw and repeated literals' Size_Format: a single bit of 0 takes one octet and 5 bits of size;
/// 01 takes two octets and 12 bits; 11 takes three octets and 20 bits (RFC 8878 §3.1.1.3.1.1).
const short_format_bit: u8 = 0x1;
const short_size_shift = 3;
const two_octet_format = 1;
const long_size_shift = 4;

/// What the Huffman-coded kinds need besides the block: the table a treeless section reuses,
/// whether a Huffman-coded section in this frame built it, and the buffer literals decode into.
pub const Tables = struct {
    table: *huffman.Table,
    table_valid: *bool,
    buffer: []u8,
};

/// Reads the Literals_Section at the start of `block`, whose literals may number at most
/// `literals_len_max`, Block_Maximum_Size (RFC 8878 §3.1.1.2.4).
pub fn read(block: []const u8, literals_len_max: u32, tables: Tables) Error!Section {
    assert(tables.buffer.len >= literals_len_max);
    var reader = codec.Reader.init(block);
    // RFC 8878 §3.1.1.3.1.1: the header's first octet is always present.
    const first = reader.read_octet() catch return error.LiteralsTruncated;
    const kind: Kind = @enumFromInt(first & constants.literals_type_mask);
    const format = (first >> constants.literals_size_format_shift) & constants.literals_size_format_mask;
    return switch (kind) {
        .raw, .repeated => read_uncompressed(&reader, first, format, kind, literals_len_max),
        .compressed, .treeless => read_compressed(&reader, first, format, kind, literals_len_max, tables),
    };
}

/// Raw_Literals_Block and RLE_Literals_Block (RFC 8878 §3.1.1.3.1.2, §3.1.1.3.1.3).
fn read_uncompressed(reader: *codec.Reader, first: u8, format: u8, kind: Kind, literals_len_max: u32) Error!Section {
    const len = try uncompressed_size(reader, first, format);
    // RFC 8878 §3.1.1.2.4: a block regenerates at most Block_Maximum_Size octets.
    if (len > literals_len_max) return error.LiteralsTooLong;
    const header_len: u32 = @intCast(reader.consumed());
    if (kind == .repeated) {
        // RFC 8878 §3.1.1.3.1.3: the section holds the one octet to repeat.
        const octet = reader.read_octet() catch return error.LiteralsTruncated;
        return .{ .source = .repeated, .len = len, .offset = 0, .octet = octet, .section_len = header_len + 1 };
    }
    // RFC 8878 §3.1.1.3.1.2: Regenerated_Size raw octets follow the header.
    _ = reader.take(len) catch return error.LiteralsTruncated;
    return .{ .source = .block, .len = len, .offset = header_len, .octet = 0, .section_len = header_len + len };
}

/// Regenerated_Size of a raw or repeated section, least significant octet first.
fn uncompressed_size(reader: *codec.Reader, first: u8, format: u8) Error!u32 {
    if (format & short_format_bit == 0) return first >> short_size_shift;
    const low: u32 = first >> long_size_shift;
    // RFC 8878 §3.1.1.3.1.1: Size_Format 01 and 11 take two and three header octets.
    const second = reader.read_octet() catch return error.LiteralsTruncated;
    if (format == two_octet_format) return low | @as(u32, second) << long_size_shift;
    // RFC 8878 §3.1.1.3.1.1: the third octet of Size_Format 11.
    const third = reader.read_octet() catch return error.LiteralsTruncated;
    return low | @as(u32, second) << long_size_shift | @as(u32, third) << (long_size_shift + @bitSizeOf(u8));
}

/// Compressed_Literals_Block and Treeless_Literals_Block (RFC 8878 §3.1.1.3.1.4).
fn read_compressed(reader: *codec.Reader, first: u8, format: u8, kind: Kind, literals_len_max: u32, tables: Tables) Error!Section {
    const size_bits = constants.literals_compressed_size_bits[format];
    const header_bits = kind_and_format_bits + constants.literals_compressed_sizes * @as(u32, size_bits);
    const header_len = header_bits / @bitSizeOf(u8);
    var header: u64 = first;
    for (1..header_len) |index| {
        // RFC 8878 §3.1.1.3.1.1: the header takes 3, 4 or 5 octets by Size_Format.
        const octet = reader.read_octet() catch return error.LiteralsTruncated;
        header |= @as(u64, octet) << @intCast(index * @bitSizeOf(u8));
    }
    const size_mask = (@as(u64, 1) << size_bits) - 1;
    const len: u32 = @intCast((header >> kind_and_format_bits) & size_mask);
    const compressed_len: u32 = @intCast((header >> (kind_and_format_bits + size_bits)) & size_mask);
    // RFC 8878 §3.1.1.2.4: a block regenerates at most Block_Maximum_Size octets.
    if (len > literals_len_max) return error.LiteralsTooLong;
    // RFC 8878 §3.1.1.3.1.1: Compressed_Size octets follow the header.
    const content = reader.take(compressed_len) catch return error.LiteralsTruncated;
    var content_reader = codec.Reader.init(content);
    if (kind == .compressed) {
        const tree_len = try huffman.read_tree(content, tables.table);
        tables.table_valid.* = true;
        _ = content_reader.take(tree_len) catch unreachable;
    } else if (!tables.table_valid.*) {
        // RFC 8878 §3.1.1.3.1.1: a treeless section with no earlier tree in the frame is corrupt.
        return error.TreelessWithoutTree;
    }
    const streams = content_reader.take(content_reader.remaining_len()) catch unreachable;
    const output = literals_output(tables.buffer, len);
    if (constants.literals_compressed_streams[format] == 1) {
        try huffman.decode_stream(tables.table, streams, output);
    } else {
        try decode_four(tables.table, streams, output);
    }
    return .{ .source = .buffer, .len = len, .offset = 0, .octet = 0, .section_len = @intCast(header_len + compressed_len) };
}

/// The first `len` octets of the literals buffer, `len` checked against Block_Maximum_Size.
fn literals_output(buffer: []u8, len: u32) []u8 {
    assert(len <= buffer.len);
    return buffer[0..len];
}

/// Four Huffman-coded streams after a Jump_Table of three 2-octet sizes, each stream regenerating
/// (Regenerated_Size + 3) / 4 literals but the last (RFC 8878 §3.1.1.3.1.6).
fn decode_four(table: *const huffman.Table, streams: []const u8, output: []u8) Error!void {
    // RFC 8878 §3.1.1.3.1.6, erratum 7297: fewer than 6 octets, or 6 literals, cannot hold four
    // streams, as Stream4_Size would underflow.
    if (streams.len < constants.four_streams_len_min or output.len < constants.four_streams_len_min) return error.JumpTableInvalid;
    var reader = codec.Reader.init(streams);
    var sizes: [constants.literal_streams]usize = undefined;
    var total: usize = 0;
    for (sizes[0 .. constants.literal_streams - 1]) |*size| {
        size.* = reader.read_int(u16, .little) catch unreachable;
        total += size.*;
    }
    // RFC 8878 §3.1.1.3.1.6: the first three streams' sizes may not exceed Total_Streams_Size.
    if (total > streams.len - constants.jump_table_len) return error.JumpTableInvalid;
    sizes[constants.literal_streams - 1] = streams.len - constants.jump_table_len - total;
    const segment_len = (output.len + constants.literal_streams - 1) / constants.literal_streams;
    for (sizes, 0..) |size, index| {
        const stream = reader.take(size) catch unreachable;
        const start = index * segment_len;
        const end = if (index == constants.literal_streams - 1) output.len else start + segment_len;
        try huffman.decode_stream(table, stream, output[start..end]);
    }
}

test {
    _ = @import("literals_test.zig");
}
