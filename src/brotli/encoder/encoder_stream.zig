//! One meta-block of the encoder's stream (RFC 7932 §9): the octets from the last meta-block's end
//! to the input's, after the stream header when the stream has none yet. A piece of encoder.zig,
//! whose `encode` calls `write`.
//!
//! Meta-blocks need not end on an octet boundary, so the bits after the last whole octet stay in
//! the encoder's state for the next one. A meta-block that codes to more octets than its input goes
//! out uncompressed, and the last distances go back to what they were, as RFC 7932 §4 moves them
//! only for the commands of a compressed meta-block.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const encoder_commands = @import("encoder_commands.zig");
const encoder_meta_block = @import("encoder_meta_block.zig");
const encoder_parse = @import("encoder_parse/encoder_parse.zig");

/// What ends the meta-block: more input follows it, a flush brings the stream to an octet boundary
/// after it, or it is the stream's last.
pub const End = enum { more, flush, last };

/// Writes the meta-block of the window's octets from `self.encoded_end` to `self.filled_end` into
/// `self.out`, as whole octets; the bits past them wait in `self.bits`.
pub fn write(self: anytype, end: End) void {
    assert(self.out_start == self.out_end);
    var writer = codec.BitWriter.init(&self.out, self.bits);
    if (!self.header_written) {
        write_stream_header(&writer, @TypeOf(self.*).window_bits) catch unreachable;
        self.header_written = true;
    }
    const block = self.window[self.encoded_end..self.filled_end];
    if (block.len > 0) write_block(self, &writer, block, end == .last) else if (end == .last) {
        encoder_meta_block.write_empty_last(&writer) catch unreachable;
    }
    // RFC 7932 §9.2: the bits after the last meta-block to the octet's end are zeros.
    if (end == .last) pad(&writer) catch unreachable;
    // RFC 7932 §9.2: an empty metadata meta-block brings a flushed stream to an octet boundary.
    if (end == .flush and writer.bits_to_octet() > 0) encoder_meta_block.write_flush(&writer) catch unreachable;
    assert(writer.drain());
    self.bits = writer.bits;
    self.encoded_end = self.filled_end;
    self.out_start = 0;
    self.out_end = writer.writer.position;
}

/// The block as a compressed meta-block, or uncompressed when that takes fewer octets.
fn write_block(self: anytype, writer: *codec.BitWriter, block: []const u8, last: bool) void {
    const saved_bits = writer.bits;
    const saved_position = writer.writer.position;
    const saved_distances = self.commands.last_distances;
    self.commands.reset();
    const Self = @TypeOf(self.*);
    const safety = Self.runtime_safety;
    if (Self.lean_parse) {
        encoder_parse.parse(Self.finder_level, safety, &self.matcher, &self.window, self.encoded_end, self.filled_end, &self.commands);
    } else {
        var sink: encoder_commands.Sink(safety) = .{ .commands = &self.commands };
        self.matcher.parse(&self.window, self.encoded_end, self.filled_end, &sink);
    }
    self.commands.close();
    const raw_len = block.len + constants.encoder_uncompressed_overhead;
    const written = encoder_meta_block.write_compressed(safety, writer, block, &self.commands, &self.codes, last);
    // The next meta-block's parse weighs a match against this one's literal code.
    self.commands.weigh_literals(&self.codes.literal.lengths);
    if (written) {
        if (writer.writer.position - saved_position <= raw_len) return;
    } else |_| {}
    writer.bits = saved_bits;
    writer.writer.position = saved_position;
    self.commands.last_distances = saved_distances;
    encoder_meta_block.write_uncompressed(writer, block) catch unreachable;
    if (last) encoder_meta_block.write_empty_last(writer) catch unreachable;
}

/// WBITS's code (RFC 7932 §9.1): 0 for 16; for 18 to 24, 1 then WBITS - 17 in 3 bits; for 17 and
/// 10 to 15, 1, three 0 bits, and then WBITS - 8 in 3 bits, except 0 for 17.
fn write_stream_header(writer: *codec.BitWriter, window_bits: u5) error{NoSpaceLeft}!void {
    if (window_bits == constants.window_bits_short) return put(writer, 0, 1);
    if (window_bits >= constants.window_bits_medium_base + 1) {
        return put(writer, (@as(u64, window_bits - constants.window_bits_medium_base) << 1) | 1, 1 + constants.window_bits_field_bits);
    }
    const long: u64 = if (window_bits == constants.window_bits_medium_base) 0 else window_bits - constants.window_bits_long_base;
    return put(writer, (long << (1 + constants.window_bits_field_bits)) | 1, 1 + constants.window_bits_field_bits + constants.window_bits_field_bits);
}

fn pad(writer: *codec.BitWriter) error{NoSpaceLeft}!void {
    return put(writer, 0, writer.bits_to_octet());
}

fn put(writer: *codec.BitWriter, value: u64, count: u7) error{NoSpaceLeft}!void {
    if (!writer.make_room(count)) return error.NoSpaceLeft;
    writer.put(value, count);
}
