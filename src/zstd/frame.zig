//! A Zstandard frame's header (RFC 8878 §3.1.1.1): its descriptor, the window it asks for, its
//! Dictionary_ID and its Frame_Content_Size, read from the header whole.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");

/// What a frame's header says.
pub const Header = struct {
    /// Window_Size: the history the frame's offsets reach (RFC 8878 §3.1.1.1.2).
    window_len: u64,
    /// Frame_Content_Size, when the header gives it (RFC 8878 §3.1.1.1.4).
    content_len: ?u64,
    /// Content_Checksum_Flag (RFC 8878 §3.1.1.1.1.5).
    has_checksum: bool,
};

/// Every way a frame header breaks RFC 8878 §3.1.1.1.
pub const Corrupt = error{ReservedBitSet};

/// Every valid frame header the decoder refuses.
pub const Unsupported = error{ WindowTooLarge, DictionaryUnsupported };

pub const Error = Corrupt || Unsupported;

/// The octets of the header whose Frame_Header_Descriptor is `descriptor`, descriptor included
/// (RFC 8878 §3.1.1.1).
pub fn header_len(descriptor: u8) usize {
    const single = descriptor & constants.descriptor_single_segment != 0;
    const window_descriptor_len: usize = @intFromBool(!single);
    return 1 + window_descriptor_len + dictionary_id_len(descriptor) + content_size_len(descriptor);
}

/// DID_Field_Size (RFC 8878 §3.1.1.1.1.6, Table 5).
fn dictionary_id_len(descriptor: u8) usize {
    return constants.dictionary_id_field_lens[descriptor & constants.descriptor_dictionary_mask];
}

/// FCS_Field_Size: by Frame_Content_Size_Flag, and 1 when the flag is 0 in a single-segment frame
/// (RFC 8878 §3.1.1.1.1.1, Table 4).
fn content_size_len(descriptor: u8) usize {
    const flag = descriptor >> constants.descriptor_content_size_shift;
    if (flag == 0) return @intFromBool(descriptor & constants.descriptor_single_segment != 0);
    return constants.content_size_field_lens[flag];
}

/// Reads the whole header `octets`, for a decoder whose window holds `window_len_max` octets.
pub fn read(octets: []const u8, window_len_max: u64) Error!Header {
    assert(octets.len == header_len(octets[0]));
    var reader = codec.Reader.init(octets);
    const descriptor = reader.read_octet() catch unreachable;
    // RFC 8878 §3.1.1.1.1.4: a decoder must ensure the reserved bit is not set.
    if (descriptor & constants.descriptor_reserved != 0) return error.ReservedBitSet;
    const single = descriptor & constants.descriptor_single_segment != 0;
    const window_descriptor: ?u8 = if (single) null else reader.read_octet() catch unreachable;
    const dictionary_id = read_little(&reader, dictionary_id_len(descriptor));
    const content_len = read_content_len(&reader, content_size_len(descriptor));
    // RFC 8878 §5: Dictionary_ID 0 names no dictionary. Any other needs one, which stdx does not
    // take (decision 13).
    if (dictionary_id != 0) return error.DictionaryUnsupported;
    // RFC 8878 §3.1.1.1.2: without Window_Descriptor, Window_Size is Frame_Content_Size.
    const window_len = if (window_descriptor) |value| window_len_of(value) else content_len.?;
    // RFC 8878 §3.1.1.1.2 and §3.1.1.1.1.2 let a decoder refuse a window beyond its limit; RFC 9659
    // §3 sets the HTTP instance's (decision 12).
    if (window_len > window_len_max) return error.WindowTooLarge;
    return .{ .window_len = window_len, .content_len = content_len, .has_checksum = descriptor & constants.descriptor_checksum != 0 };
}

/// A field of `len` octets, least significant first, or 0 for none (RFC 8878 §3.1.1.1.3).
fn read_little(reader: *codec.Reader, len: usize) u64 {
    var value: u64 = 0;
    for (0..len) |index| {
        const octet = reader.read_octet() catch unreachable;
        value |= @as(u64, octet) << @intCast(index * @bitSizeOf(u8));
    }
    return value;
}

/// Frame_Content_Size, least significant octet first, 256 added to a 2-octet field (RFC 8878
/// §3.1.1.1.4), or null when the header gives none.
fn read_content_len(reader: *codec.Reader, len: usize) ?u64 {
    if (len == 0) return null;
    const value = read_little(reader, len);
    return if (len == constants.content_size_offset_field_len) value + constants.content_size_two_octet_offset else value;
}

/// Window_Size from Window_Descriptor: windowBase = 2^(10 + Exponent), plus windowBase / 8 times
/// Mantissa (RFC 8878 §3.1.1.1.2).
pub fn window_len_of(descriptor: u8) u64 {
    const log = constants.window_log_min + (descriptor >> constants.window_exponent_shift);
    const base = @as(u64, 1) << @intCast(log);
    return base + (base >> constants.window_mantissa_shift) * (descriptor & constants.window_mantissa_mask);
}

// Tests.

const testing = std.testing;

test "Window_Size is 2^(10 + Exponent) plus an eighth of it per Mantissa" {
    try testing.expectEqual(1024, window_len_of(0));
    try testing.expectEqual(1024 + 128 * 7, window_len_of(7));
    // Exponent 13, Mantissa 0: 2^23, the HTTP instance's limit.
    try testing.expectEqual(constants.http_window_len, window_len_of(13 << 3));
    // The largest: (1 << 41) + 7 * (1 << 38) (RFC 8878 §3.1.1.1.2).
    try testing.expectEqual((1 << 41) + 7 * (1 << 38), window_len_of(0xff));
}

test "a header's fields, and the windows and dictionaries it refuses" {
    const limit = constants.http_window_len;
    // Window_Descriptor for 8 MiB, no Dictionary_ID, no Frame_Content_Size, checksum on.
    try testing.expectEqual(Header{ .window_len = limit, .content_len = null, .has_checksum = true }, try read(&.{ 0x04, 13 << 3 }, limit));
    // Single segment with a 1-octet Frame_Content_Size of 200: the window is 200.
    try testing.expectEqual(Header{ .window_len = 200, .content_len = 200, .has_checksum = false }, try read(&.{ 0x20, 200 }, limit));
    // A 2-octet Frame_Content_Size adds 256.
    try testing.expectEqual(Header{ .window_len = 256 + 0x0102, .content_len = 256 + 0x0102, .has_checksum = false }, try read(&.{ 0x60, 0x02, 0x01 }, limit));
    // 8 MiB + 1/8 is past the HTTP instance's limit; a single segment of 2^23 + 1 too.
    try testing.expectError(error.WindowTooLarge, read(&.{ 0x00, 13 << 3 | 1 }, limit));
    try testing.expectError(error.WindowTooLarge, read(&.{ 0xa0, 0x01, 0x00, 0x80, 0x00 }, limit));
    // A 1-octet Dictionary_ID of 0 names none; of 7, one.
    try testing.expectEqual(Header{ .window_len = 1024, .content_len = null, .has_checksum = false }, try read(&.{ 0x01, 0x00, 0x00 }, limit));
    try testing.expectError(error.DictionaryUnsupported, read(&.{ 0x01, 0x00, 0x07 }, limit));
    try testing.expectError(error.ReservedBitSet, read(&.{ 0x08, 0x00 }, limit));
}
