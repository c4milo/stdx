//! The encoder's frame: its magic number and Frame_Header (RFC 8878 §3.1.1, §3.1.1.1), each
//! block's Block_Header (§3.1.1.2), and the Content_Checksum (§3.1.1).
//!
//! A frame whose content is one block is single-segment and states Frame_Content_Size, so its
//! Window_Size is its content's size. Any other frame states its window in Window_Descriptor
//! and leaves its size unknown, as the encoder streams it.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");

pub const Error = error{NoSpaceLeft};

/// Block_Type (RFC 8878 §3.1.1.2.2, Table 10).
pub const BlockType = enum(u2) { raw = 0, rle = 1, compressed = 2 };

/// What the Frame_Header says: the window of a frame of many blocks, or the content size of a
/// single-segment one, and whether a checksum ends the frame.
pub const Header = struct {
    window_log: u5,
    content_len: ?usize,
    checksum: bool,
};

/// Writes the magic number and the Frame_Header (RFC 8878 §3.1.1.1), every field least
/// significant octet first.
pub fn write_header(writer: *codec.Writer, header: Header) Error!void {
    try writer.write_int(u32, constants.frame_magic, .little);
    var descriptor: u8 = 0;
    if (header.checksum) descriptor |= constants.descriptor_checksum;
    const content_len = header.content_len orelse {
        assert(header.window_log >= constants.window_log_min);
        try writer.write_octet(descriptor);
        // RFC 8878 §3.1.1.1.2: Window_Size is 2^(10 + Exponent), with no Mantissa.
        return writer.write_octet(@as(u8, header.window_log - constants.window_log_min) << constants.window_exponent_shift);
    };
    // RFC 8878 §3.1.1.1.1.2: a single-segment frame states Frame_Content_Size, in the fewest of
    // 1, 2 or 4 octets (Table 4, Table 7).
    descriptor |= constants.descriptor_single_segment;
    if (content_len <= std.math.maxInt(u8)) {
        try writer.write_octet(descriptor);
        return writer.write_octet(@intCast(content_len));
    }
    if (content_len < constants.content_size_two_octet_offset + (1 << @bitSizeOf(u16))) {
        try writer.write_octet(descriptor | 1 << constants.descriptor_content_size_shift);
        return writer.write_int(u16, @intCast(content_len - constants.content_size_two_octet_offset), .little);
    }
    try writer.write_octet(descriptor | constants.content_size_flag_four << constants.descriptor_content_size_shift);
    try writer.write_int(u32, @intCast(content_len), .little);
}

/// Writes a Block_Header: Last_Block, Block_Type and Block_Size, in 3 octets least significant
/// first (RFC 8878 §3.1.1.2).
pub fn write_block_header(writer: *codec.Writer, last: bool, block_type: BlockType, size: usize) Error!void {
    assert(size <= constants.block_len_max);
    const value: u32 = @as(u32, @intFromBool(last)) |
        @as(u32, @intFromEnum(block_type)) << constants.block_type_shift |
        @as(u32, @intCast(size)) << constants.block_size_shift;
    try writer.write_int(u16, @truncate(value), .little);
    try writer.write_octet(@intCast(value >> @bitSizeOf(u16)));
}

test "a header reads back through the decoder's frame reader" {
    const frame = @import("../frame.zig");
    const cases = [_]Header{
        .{ .window_log = 19, .content_len = null, .checksum = false },
        .{ .window_log = 21, .content_len = null, .checksum = true },
        .{ .window_log = 19, .content_len = 0, .checksum = false },
        .{ .window_log = 19, .content_len = 255, .checksum = true },
        .{ .window_log = 19, .content_len = 256, .checksum = false },
        .{ .window_log = 19, .content_len = 65_791, .checksum = false },
        .{ .window_log = 19, .content_len = 65_792, .checksum = false },
        .{ .window_log = 19, .content_len = constants.block_len_max, .checksum = false },
    };
    for (cases) |case| {
        var octets: [constants.magic_len + constants.frame_header_len_max]u8 = undefined;
        var writer = codec.Writer.init(&octets);
        try write_header(&writer, case);
        const written = writer.written();
        try std.testing.expectEqual(constants.frame_magic, std.mem.readInt(u32, written[0..4], .little));
        const descriptor = written[constants.magic_len];
        try std.testing.expectEqual(written.len - constants.magic_len, frame.header_len(descriptor));
        const read = try frame.read(written[constants.magic_len..], constants.http_window_len);
        try std.testing.expectEqual(case.checksum, read.has_checksum);
        if (case.content_len) |len| {
            try std.testing.expectEqual(@as(u64, len), read.content_len.?);
            try std.testing.expectEqual(@as(u64, len), read.window_len);
        } else {
            try std.testing.expectEqual(@as(u64, 1) << case.window_log, read.window_len);
        }
    }
}
