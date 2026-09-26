//! The phases of the Zstandard decoder: each takes what the call's input or output allows and
//! returns the status that ends the call, or null to take the next step (decision 11).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const checksum = @import("checksum");
const constants = @import("constants.zig");
const frame = @import("frame.zig");
const block = @import("block.zig");
const decoder = @import("decoder.zig");

const DecoderOptions = decoder.DecoderOptions;
const Error = decoder.Error;
const Status = codec.Status;

fn Self(comptime options: DecoderOptions) type {
    return decoder.Decoder(options);
}

/// A field held whole, least significant octet first.
fn held_int(comptime T: type, field_octets: []const u8) T {
    return std.mem.readInt(T, field_octets[0 .. @bitSizeOf(T) / @bitSizeOf(u8)], .little);
}

/// Magic_Number, least significant octet first: a Zstandard frame's, or a skippable frame's
/// (RFC 8878 §3.1.1, §3.1.2).
pub fn read_magic(comptime options: DecoderOptions, self: *Self(options), reader: *codec.Reader) Error!?Status {
    if (!self.field.fill(reader, constants.magic_len)) return .needs_input;
    const magic = held_int(u32, self.field.held());
    self.field.init();
    if (magic == constants.frame_magic) {
        self.phase = .frame_header;
        return null;
    }
    // RFC 8878 §3.1: a stream is Zstandard frames and skippable frames, nothing else.
    if (magic < constants.skippable_magic_first or magic > constants.skippable_magic_last) return error.InvalidMagic;
    self.phase = .skippable_size;
    return null;
}

/// Frame_Header: its descriptor first, which tells how long the rest is (RFC 8878 §3.1.1.1).
pub fn read_frame_header(comptime options: DecoderOptions, self: *Self(options), reader: *codec.Reader) Error!?Status {
    // The descriptor tells the header's length; a call that held it already reads on from it.
    if (self.field.held().len == 0 and !self.field.fill(reader, 1)) return .needs_input;
    const header_len = frame.header_len(self.field.held()[0]);
    if (!self.field.fill(reader, header_len)) return .needs_input;
    self.header = try frame.read(self.field.held(), options.window_len_max);
    self.field.init();
    // A frame starts from nothing: no history, table, tree or offset of the frame before
    // (RFC 8878 §3.1: each frame decodes independently; invariant 10).
    self.window.init();
    self.tables.init();
    self.huffman_valid = false;
    self.repeats = constants.repeated_offsets_initial;
    self.frame_len = 0;
    self.hash = checksum.Xxh64.init(self.hash_path, 0);
    self.block_len_max = @intCast(@min(self.header.window_len, constants.block_len_max));
    self.phase = .block_header;
    return null;
}

/// A skippable frame's Frame_Size, least significant octet first (RFC 8878 §3.1.2).
pub fn read_skippable_size(comptime options: DecoderOptions, self: *Self(options), reader: *codec.Reader) Error!?Status {
    if (!self.field.fill(reader, constants.skippable_size_len)) return .needs_input;
    self.skip_left = held_int(u32, self.field.held());
    self.field.init();
    self.phase = .skippable_data;
    return null;
}

/// A skippable frame's User_Data, skipped (RFC 8878 §3.1.2).
pub fn skip(comptime options: DecoderOptions, self: *Self(options), reader: *codec.Reader) Error!?Status {
    const skipped = reader.take_partial(self.skip_left);
    self.skip_left -= @intCast(skipped.len);
    if (self.skip_left > 0) return .needs_input;
    self.phase = .done;
    return .done;
}

/// Block_Header, least significant octet first: Last_Block, Block_Type and Block_Size (RFC 8878
/// §3.1.1.2).
pub fn read_block_header(comptime options: DecoderOptions, self: *Self(options), reader: *codec.Reader) Error!?Status {
    if (!self.field.fill(reader, constants.block_header_len)) return .needs_input;
    const header = held_int(u24, self.field.held());
    self.field.init();
    self.last_block = header & constants.block_last_mask != 0;
    const block_type: decoder.BlockType = @enumFromInt((header >> constants.block_type_shift) & constants.block_type_mask);
    self.block_len = header >> constants.block_size_shift;
    // RFC 8878 §3.1.1.2.3 and §3.1.1.2.4: Block_Size is at most Block_Maximum_Size, for a raw
    // block's content, a repeated block's length and a compressed block's content alike.
    if (self.block_len > self.block_len_max) return error.BlockTooLong;
    self.block_left = self.block_len;
    self.phase = switch (block_type) {
        .raw => .raw_block,
        .repeated => .repeated_octet,
        .compressed => .gather,
        // RFC 8878 §3.1.1.2.2: a reserved Block_Type is corrupt data.
        .reserved => return error.ReservedBlockType,
    };
    return null;
}

fn sink(comptime options: DecoderOptions, self: *Self(options), output: []u8, written: usize) block.Sink(@TypeOf(self.window)) {
    return .{ .output = output, .written = written, .window = &self.window, .hash = &self.hash, .frame_len = &self.frame_len };
}

/// A raw block's octets, from the input to the output as both allow (RFC 8878 §3.1.1.2.2).
pub fn copy_raw(comptime options: DecoderOptions, self: *Self(options), reader: *codec.Reader, output: []u8, written: *usize) Error!?Status {
    var into = sink(options, self, output, written.*);
    const octets = reader.take_partial(@min(self.block_left, into.room()));
    @memcpy(into.output[into.written..][0..octets.len], octets);
    into.commit(octets.len);
    written.* = into.written;
    self.block_left -= @intCast(octets.len);
    if (self.block_left == 0) return end_block(options, self);
    return if (reader.remaining_len() == 0) .needs_input else .needs_room;
}

/// A repeated block's one octet (RFC 8878 §3.1.1.2.2).
pub fn read_repeated_octet(comptime options: DecoderOptions, self: *Self(options), reader: *codec.Reader) Error!?Status {
    self.repeated = reader.read_octet() catch return .needs_input;
    self.phase = .repeated_block;
    return null;
}

/// A repeated block's octet, Block_Size times, as the output has room (RFC 8878 §3.1.1.2.2).
pub fn write_repeated(comptime options: DecoderOptions, self: *Self(options), output: []u8, written: *usize) Error!?Status {
    var into = sink(options, self, output, written.*);
    const len = @min(self.block_left, into.room());
    @memset(into.output[into.written..][0..len], self.repeated);
    into.commit(len);
    written.* = into.written;
    self.block_left -= @intCast(len);
    if (self.block_left == 0) return end_block(options, self);
    return .needs_room;
}

/// A compressed block's octets, gathered until it is whole, then its sections read (RFC 8878
/// §3.1.1.3).
pub fn gather(comptime options: DecoderOptions, self: *Self(options), reader: *codec.Reader) Error!?Status {
    const filled = self.block_len - self.block_left;
    const octets = reader.take_partial(self.block_left);
    @memcpy(self.block_octets[filled..][0..octets.len], octets);
    self.block_left -= @intCast(octets.len);
    if (self.block_left > 0) return .needs_input;
    try block.prepare(&self.run, context(options, self));
    self.phase = .execute;
    return null;
}

fn context(comptime options: DecoderOptions, self: *Self(options)) block.Context {
    return .{
        .block = self.block_octets[0..self.block_len],
        .literals_buffer = &self.literals_buffer,
        .huffman = .{ .table = &self.huffman_table, .table_valid = &self.huffman_valid, .buffer = &self.literals_buffer },
        .tables = &self.tables,
        .repeats = &self.repeats,
        .block_len_max = self.block_len_max,
        .window_len = self.header.window_len,
    };
}

/// A compressed block's sequences, as the output has room (RFC 8878 §3.1.1.4).
pub fn execute(comptime options: DecoderOptions, self: *Self(options), output: []u8, written: *usize) Error!?Status {
    var into = sink(options, self, output, written.*);
    const ended = try block.execute(@TypeOf(self.window), &self.run, context(options, self), &into);
    written.* = into.written;
    if (!ended) return .needs_room;
    return end_block(options, self);
}

/// The next block, the checksum, or the frame's end.
fn end_block(comptime options: DecoderOptions, self: *Self(options)) Error!?Status {
    if (self.header.content_len) |content_len| {
        // RFC 8878 §3.1.1.1.4 and §8: a frame decodes to Frame_Content_Size octets, no more.
        if (self.frame_len > content_len) return error.ContentSizeMismatch;
    }
    if (!self.last_block) {
        self.phase = .block_header;
        return null;
    }
    if (self.header.has_checksum) {
        self.phase = .checksum;
        return null;
    }
    return end_frame(options, self);
}

/// Content_Checksum, least significant octet first: the low 32 bits of XXH64 of the frame's
/// octets from seed 0 (RFC 8878 §3.1.1).
pub fn read_checksum(comptime options: DecoderOptions, self: *Self(options), reader: *codec.Reader) Error!?Status {
    if (!self.field.fill(reader, constants.checksum_len)) return .needs_input;
    const wanted = held_int(u32, self.field.held());
    self.field.init();
    // RFC 8878 §3.1.1: the checksum is XXH64's low 4 octets over the decoded data.
    if (wanted != @as(u32, @truncate(self.hash.final()))) return error.ChecksumMismatch;
    return end_frame(options, self);
}

fn end_frame(comptime options: DecoderOptions, self: *Self(options)) Error!?Status {
    if (self.header.content_len) |content_len| {
        // RFC 8878 §3.1.1.1.4: Frame_Content_Size is the decompressed size.
        if (self.frame_len != content_len) return error.ContentSizeMismatch;
    }
    self.phase = .done;
    return .done;
}
