//! A compressed block's Literals_Section (RFC 8878 §3.1.1.3.1): the literals raw, as one octet
//! repeated, or Huffman-coded in one stream or four, whichever is smallest. A Huffman-coded
//! section that comes out no smaller than the raw literals is rewound and written raw.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const encoder_huffman = @import("encoder_huffman.zig");

pub const Error = encoder_huffman.Error;

/// Literals_Block_Type (RFC 8878 §3.1.1.3.1.1, Table 13).
const BlockType = enum(u2) { raw = 0, rle = 1, compressed = 2 };

/// The scratch of a section: its code and the description's.
pub const Scratch = struct {
    code: encoder_huffman.Code,
    huffman: encoder_huffman.Scratch,
};

/// Writes the Literals_Section of `literals`.
pub fn write_section(writer: *codec.Writer, literals: []const u8, scratch: *Scratch) Error!void {
    assert(literals.len <= constants.block_len_max);
    if (literals.len == 0) return write_raw(writer, literals);
    var counts: [constants.literal_symbols]u32 = @splat(0);
    for (literals) |literal| counts[literal] += 1;
    const present = present_count(&counts);
    if (present == 1) return write_rle(writer, literals[0], literals.len);
    if (literals.len < constants.literals_compressed_len_min) return write_raw(writer, literals);
    const start = writer.position;
    encoder_huffman.build(&counts, &scratch.code);
    const stream_count: usize = if (literals.len < constants.literals_four_streams_len_min) 1 else constants.literal_streams;
    // The streams alone, by the code's lengths, against the raw octets: a code that saves less
    // than a description costs is not tried.
    const streams_len = encoder_huffman.streams_len(&scratch.code, &counts, stream_count);
    if (streams_len + constants.literals_description_len_guess >= literals.len) return write_raw(writer, literals);
    write_compressed(writer, literals, stream_count, scratch) catch {
        writer.position = start;
        return write_raw(writer, literals);
    };
    if (writer.position - start >= literals.len + raw_header_len(literals.len)) {
        writer.position = start;
        return write_raw(writer, literals);
    }
}

/// The literals whose count is not zero, `literal_sum_lanes` counts a step.
fn present_count(counts: *const [constants.literal_symbols]u32) u32 {
    const Lanes = @Vector(constants.literal_sum_lanes, u32);
    var present: Lanes = @splat(0);
    for (0..constants.literal_symbols / constants.literal_sum_lanes) |step| {
        const lanes: Lanes = counts[step * constants.literal_sum_lanes ..][0..constants.literal_sum_lanes].*;
        present +%= @select(u32, lanes > @as(Lanes, @splat(0)), @as(Lanes, @splat(1)), @as(Lanes, @splat(0)));
    }
    return @reduce(.Add, present);
}

/// The octets of a raw or RLE section's header for `size` literals: 1 below 32, 2 below 4096,
/// else 3 (RFC 8878 §3.1.1.3.1.1).
fn raw_header_len(size: usize) usize {
    if (size <= constants.literals_size_one_octet_max) return 1;
    if (size <= constants.literals_size_two_octet_max) return constants.literals_raw_header_two;
    return constants.literals_raw_header_three;
}

/// The header of a raw or RLE section: Literals_Block_Type, Size_Format, then Regenerated_Size,
/// least significant first (RFC 8878 §3.1.1.3.1.1).
fn write_raw_header(writer: *codec.Writer, block_type: BlockType, size: usize) Error!void {
    const kind: u32 = @intFromEnum(block_type);
    switch (raw_header_len(size)) {
        // Size_Format 00: Regenerated_Size in the top 5 bits.
        1 => try writer.write_octet(@intCast(kind | size << constants.literals_size_one_octet_shift)),
        // Size_Format 01 and 11: 12 and 20 bits from bit 4.
        constants.literals_raw_header_two => try writer.write_int(u16, @intCast(kind | constants.literals_size_format_two << constants.literals_size_format_shift | size << constants.literals_size_shift), .little),
        else => {
            const header: u32 = @intCast(kind | constants.literals_size_format_three << constants.literals_size_format_shift | size << constants.literals_size_shift);
            try writer.write_int(u16, @truncate(header), .little);
            try writer.write_octet(@intCast(header >> @bitSizeOf(u16)));
        },
    }
}

fn write_raw(writer: *codec.Writer, literals: []const u8) Error!void {
    try write_raw_header(writer, .raw, literals.len);
    try writer.write_all(literals);
}

fn write_rle(writer: *codec.Writer, literal: u8, size: usize) Error!void {
    try write_raw_header(writer, .rle, size);
    try writer.write_octet(literal);
}

/// The width of Regenerated_Size and Compressed_Size, and the header's octets, for sizes up to
/// `size` in `stream_count` streams (RFC 8878 §3.1.1.3.1.1).
const CompressedFormat = struct { size_format: u2, size_bits: u5, header_len: usize };

fn compressed_format(size: usize, stream_count: usize) CompressedFormat {
    const bits = constants.literals_compressed_size_bits;
    if (stream_count == 1) {
        assert(size < @as(usize, 1) << bits[0]);
        return .{ .size_format = 0, .size_bits = bits[0], .header_len = constants.literals_compressed_header_lens[0] };
    }
    for (1..bits.len) |format| {
        if (size < @as(usize, 1) << bits[format]) return .{ .size_format = @intCast(format), .size_bits = bits[format], .header_len = constants.literals_compressed_header_lens[format] };
    }
    unreachable;
}

/// A Huffman-coded section: its header, the tree description, the jump table for four streams,
/// and the streams; the header and the jump table are written once the streams' sizes are known.
fn write_compressed(writer: *codec.Writer, literals: []const u8, stream_count: usize, scratch: *Scratch) Error!void {
    // A Compressed_Size at most Regenerated_Size, as a larger one goes out raw, fits the same width.
    const format = compressed_format(literals.len, stream_count);
    const header_at = writer.position;
    if (writer.room_len() < format.header_len) return error.NoSpaceLeft;
    writer.position += format.header_len;
    const content_at = writer.position;
    try encoder_huffman.write_tree(writer, &scratch.code, &scratch.huffman);
    if (stream_count == 1) {
        try write_stream(writer, &scratch.code, literals);
    } else {
        try write_four_streams(writer, &scratch.code, literals);
    }
    const compressed_len = writer.position - content_at;
    if (compressed_len >= @as(usize, 1) << format.size_bits) return error.NoSpaceLeft;
    const header: u64 = @as(u64, @intFromEnum(BlockType.compressed)) |
        @as(u64, format.size_format) << constants.literals_size_format_shift |
        @as(u64, literals.len) << constants.literals_size_shift |
        @as(u64, compressed_len) << (constants.literals_size_shift + format.size_bits);
    var header_writer = codec.Writer.init(writer.octets[header_at..][0..format.header_len]);
    for (0..format.header_len) |index| try header_writer.write_octet(@truncate(header >> @intCast(index * @bitSizeOf(u8))));
}

fn write_stream(writer: *codec.Writer, code: *const encoder_huffman.Code, literals: []const u8) Error!void {
    var bits = codec.BitWriter.init(writer.octets[writer.position..], .{});
    try encoder_huffman.write_stream(&bits, code, literals);
    writer.position += bits.writer.position;
}

/// Four streams: the first three of (Regenerated_Size + 3) / 4 literals each, the fourth the rest,
/// after the Jump_Table of the first three's sizes (RFC 8878 §3.1.1.3.1.6).
fn write_four_streams(writer: *codec.Writer, code: *const encoder_huffman.Code, literals: []const u8) Error!void {
    const segment_len = (literals.len + constants.literal_streams - 1) / constants.literal_streams;
    assert(literals.len > (constants.literal_streams - 1) * segment_len);
    const table_at = writer.position;
    if (writer.room_len() < constants.jump_table_len) return error.NoSpaceLeft;
    writer.position += constants.jump_table_len;
    var table = codec.Writer.init(writer.octets[table_at..][0..constants.jump_table_len]);
    for (0..constants.literal_streams) |stream| {
        const first = stream * segment_len;
        const end = if (stream + 1 == constants.literal_streams) literals.len else first + segment_len;
        const stream_at = writer.position;
        try write_stream(writer, code, literals[first..end]);
        if (stream + 1 == constants.literal_streams) break;
        const stream_len = writer.position - stream_at;
        if (stream_len > std.math.maxInt(u16)) return error.NoSpaceLeft;
        try table.write_int(u16, @intCast(stream_len), .little);
    }
}

test {
    _ = @import("encoder_literals_test.zig");
}
