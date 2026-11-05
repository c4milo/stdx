//! One block of the encoder's frame (RFC 8878 §3.1.1.2): the octets from the last block's end to
//! the input's, written as an RLE_Block when they are one octet repeated, else as a
//! Compressed_Block when that is smaller than the octets, else as a Raw_Block. A piece of
//! encoder.zig, whose `encode` calls `write`.
//!
//! The Repeated_Offsets and the sequence tables of a block that does not go out compressed are
//! put back as they were, as RFC 8878 §3.1.1.5 and §3.1.1.3.2.1 read them only from compressed
//! blocks.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const encoder_frame = @import("encoder_frame.zig");
const encoder_literals = @import("encoder_literals.zig");
const encoder_match = @import("encoder_match.zig");
const encoder_sequences = @import("encoder_sequences.zig");

/// Writes the block of the window's octets from `self.encoded_end` to `self.filled_end` into
/// `self.out`, after the frame's header when the frame has none yet. `last` ends the frame, with
/// its checksum when the options ask for one.
pub fn write(self: anytype, last: bool) void {
    const start = self.encoded_end;
    const end = self.filled_end;
    const len = end - start;
    assert(len <= constants.block_len_max and self.out_start == self.out_end);
    var writer = codec.Writer.init(&self.out);
    if (!self.header_written) write_frame_header(self, &writer, last, len);
    const block = self.window[start..end];
    const header_at = writer.position;
    writer.position += constants.block_header_len;
    const block_type = write_content(self, &writer, block);
    var header_writer = codec.Writer.init(writer.octets[header_at..][0..constants.block_header_len]);
    // RFC 8878 §3.1.1.2.3: an RLE_Block's Block_Size counts the octets it repeats.
    const size = if (block_type == .compressed) writer.position - header_at - constants.block_header_len else len;
    encoder_frame.write_block_header(&header_writer, last, block_type, size) catch unreachable;
    if (@TypeOf(self.*).checksum_enabled) {
        self.digest.update(block);
        // RFC 8878 §3.1.1: the low 4 octets of XXH64, least significant first.
        if (last) writer.write_int(u32, @truncate(self.digest.final()), .little) catch unreachable;
    }
    self.encoded_end = end;
    self.out_start = 0;
    self.out_end = writer.position;
}

/// The frame's header, before its first block. A frame whose first block is its last is
/// single-segment (RFC 8878 §3.1.1.1.1.2).
fn write_frame_header(self: anytype, writer: *codec.Writer, last: bool, len: usize) void {
    encoder_frame.write_header(writer, .{
        .window_log = @TypeOf(self.*).window_log,
        .content_len = if (last) len else null,
        .checksum = @TypeOf(self.*).checksum_enabled,
    }) catch unreachable;
    self.header_written = true;
}

/// Writes `block`'s content after its header, and returns its Block_Type.
fn write_content(self: anytype, writer: *codec.Writer, block: []const u8) encoder_frame.BlockType {
    if (block.len > 1 and repeats_one_octet(block)) {
        writer.write_octet(block[0]) catch unreachable;
        return .rle;
    }
    const content_at = writer.position;
    if (block.len > 0 and try_compressed(self, writer, block)) return .compressed;
    writer.position = content_at;
    writer.write_all(block) catch unreachable;
    return .raw;
}

fn repeats_one_octet(block: []const u8) bool {
    for (block[1..]) |octet| {
        if (octet != block[0]) return false;
    }
    return true;
}

/// Parses `block` and writes it as a Compressed_Block's sections into room one octet short of
/// the block's own length. Returns false, and puts the state back, when the sections do not fit.
fn try_compressed(self: anytype, writer: *codec.Writer, block: []const u8) bool {
    const saved_repeats = self.repeats;
    self.sequences.count = 0;
    var parsed: encoder_match.Block = .{ .sequences = &self.sequences, .literals = &self.literals, .literals_len = 0, .repeats = &self.repeats };
    self.matcher.parse(&self.window, self.encoded_end, self.filled_end, &parsed);
    // RFC 8878 §3.1.1.2.4 advises a Raw_Block where the compressed one is no smaller.
    var room = codec.Writer.init(writer.octets[writer.position..][0 .. block.len - 1]);
    write_sections(self, &room, parsed.literals[0..parsed.literals_len]) catch {
        self.repeats = saved_repeats;
        return false;
    };
    if (self.sequences.count > 0) self.tables.commit();
    writer.position += room.position;
    return true;
}

fn write_sections(self: anytype, writer: *codec.Writer, literals: []const u8) encoder_literals.Error!void {
    try encoder_literals.write_section(writer, literals, &self.literals_scratch);
    try encoder_sequences.write_section(writer, &self.sequences, &self.codes, &self.tables);
}
