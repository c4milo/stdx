//! The verdict entries of decision 15: every case where stdx, zlib and Wuffs do not all give an
//! input the same verdict, with the RFC section that decides it and the decision behind stdx's
//! choice. A differential check that finds a disagreement no entry matches fails, and adding an
//! entry is a change to a check, so it carries its mutation results.
//!
//! An entry matches a disagreement by the verdicts, stdx's with its error's name when it refused
//! and each oracle's, and by `holds`, which reads the facts the check gathered about the input and
//! says whether it has the entry's shape. Verdicts alone would let an entry cover a disagreement
//! with another cause. `shape` says in prose what `holds` checks.

const std = @import("std");

/// A verdict of any decoder: the stream ended and every check passed; the input was refused; the
/// input ended before the stream did; or the output filled first.
pub const Kind = enum { ok, refused, incomplete, no_room };

/// What the differential check knows about an input: its octets, and where stdx's DEFLATE decoder
/// stopped in it.
pub const Facts = struct {
    input: []const u8,
    /// Whether stdx stopped inside a dynamic block's header, and the distance codes its HDIST
    /// declares (RFC 1951 §3.2.7).
    stopped_in_dynamic_header: bool = false,
    distance_count: u16 = 0,
    /// The octets of a container's trailer stdx held when it stopped after the DEFLATE stream.
    trailer_held_len: usize = 0,
};

pub const Entry = struct {
    /// The stdx modules whose decoders the entry covers.
    codecs: []const []const u8,
    shape: []const u8,
    /// Whether an input has the shape.
    holds: *const fn (facts: Facts) bool,
    stdx: Kind,
    /// The name of stdx's error, when it refused.
    stdx_error: []const u8 = "",
    zlib: Kind,
    wuffs: Kind,
    rfc: []const u8,
    decision: []const u8,
};

pub const entries = [_]Entry{
    .{
        .codecs = &.{ "deflate", "zlib", "gzip" },
        .shape = "stdx stopped for input inside a dynamic block's header whose HDIST declares 31 or 32 " ++
            "distance codes",
        .holds = in_header_with_unused_distance_codes,
        .stdx = .incomplete,
        .zlib = .refused,
        .wuffs = .refused,
        .rfc = "RFC 1951 §3.2.7 gives HDIST the range 1 to 32, and §3.3 requires a decoder to " ++
            "accept every stream that conforms",
        .decision = "decision 15: where the RFC says must, stdx does what it says; distance codes " ++
            "30 and 31 are refused where they appear (RFC 1951 §3.2.6), not where HDIST declares them",
    },
    .{
        .codecs = &.{"zlib"},
        .shape = "CINFO declares a window smaller than a distance the stream takes",
        .holds = window_below_32k,
        .stdx = .refused,
        .stdx_error = "DistanceTooFar",
        .zlib = .ok,
        .wuffs = .ok,
        .rfc = "RFC 1950 §2.2: CINFO is the base-2 logarithm of the window the encoder used, and " ++
            "RFC 1950 states no decoder rule for a distance past it",
        .decision = "decision 12: stdx refuses a distance past the window CINFO declares, failing " ++
            "closed as decision 15 rules; both oracles decode it",
    },
    .{
        .codecs = &.{"gzip"},
        .shape = "FLG sets FHCRC, and the CRC16 does not match the header",
        .holds = header_crc_set,
        .stdx = .refused,
        .stdx_error = "HeaderChecksumMismatch",
        .zlib = .refused,
        .wuffs = .ok,
        .rfc = "RFC 1952 §2.3.1: the CRC16 is the two least significant octets of the header's " ++
            "CRC-32; §2.3.1.2 lets a decoder skip it",
        .decision = "decision 15: stdx checks the CRC16 when FHCRC is set, which Wuffs skips",
    },
    .{
        .codecs = &.{"gzip"},
        .shape = "FLG sets a reserved bit and FEXTRA, which Wuffs reads past before it refuses",
        .holds = reserved_flag_set,
        .stdx = .refused,
        .stdx_error = "ReservedFlagSet",
        .zlib = .refused,
        .wuffs = .incomplete,
        .rfc = "RFC 1952 §2.3.1.2: a compliant decompressor must give an error indication if any " ++
            "reserved bit is non-zero",
        .decision = "decision 15: where the RFC says must, stdx does what it says, at the header",
    },
    .{
        .codecs = &.{"gzip"},
        .shape = "CRC32 is whole and does not match, and the input ends before ISIZE does",
        .holds = trailer_without_size,
        .stdx = .refused,
        .stdx_error = "ChecksumMismatch",
        .zlib = .refused,
        .wuffs = .incomplete,
        .rfc = "RFC 1952 §2.3.1: CRC32 is the CRC-32 of the decoded octets, and §2.3.1.2 lets a " ++
            "decoder skip it",
        .decision = "decision 15: stdx checks CRC32, and refuses as soon as its four octets are in, " ++
            "as zlib does; Wuffs waits for ISIZE",
    },
};

/// gzip's trailer: CRC32, then ISIZE, four octets each (RFC 1952 §2.3).
const trailer_crc32_len = 4;
const trailer_len = 8;

fn trailer_without_size(facts: Facts) bool {
    return facts.trailer_held_len >= trailer_crc32_len and facts.trailer_held_len < trailer_len;
}

/// The number of distance codes RFC 1951 §3.2.6 uses; HDIST can declare two more.
const distance_codes_used = 30;

fn in_header_with_unused_distance_codes(facts: Facts) bool {
    return facts.stopped_in_dynamic_header and facts.distance_count > distance_codes_used;
}

/// CMF's CINFO, its high four bits, below 7, a window below 32 KiB (RFC 1950 §2.2).
const window_bits_shift = 4;
const window_bits_field_max = 7;

fn window_below_32k(facts: Facts) bool {
    if (facts.input.len == 0) return false;
    return facts.input[0] >> window_bits_shift < window_bits_field_max;
}

/// FLG, the fourth octet of a gzip member, its FHCRC bit and its reserved bits (RFC 1952 §2.3.1).
const flags_offset = 3;
const flag_header_crc: u8 = 1 << 1;
const flag_extra: u8 = 1 << 2;
const flags_reserved: u8 = 0b1110_0000;

fn header_crc_set(facts: Facts) bool {
    return facts.input.len > flags_offset and facts.input[flags_offset] & flag_header_crc != 0;
}

fn reserved_flag_set(facts: Facts) bool {
    if (facts.input.len <= flags_offset) return false;
    const flags = facts.input[flags_offset];
    return flags & flags_reserved != 0 and flags & flag_extra != 0;
}

/// The entry that allows these verdicts on this input, or null.
pub fn find(codec: []const u8, facts: Facts, stdx: Kind, stdx_error: []const u8, zlib: Kind, wuffs: Kind) ?*const Entry {
    for (&entries) |*entry| {
        if (!names(entry.codecs, codec)) continue;
        if (entry.stdx != stdx or entry.zlib != zlib or entry.wuffs != wuffs) continue;
        if (!std.mem.eql(u8, entry.stdx_error, stdx_error)) continue;
        if (!entry.holds(facts)) continue;
        return entry;
    }
    return null;
}

/// What the Zstandard check knows about an input: its octets.
pub const ZstdFacts = struct {
    input: []const u8,
};

/// A verdict entry of the Zstandard decoder, whose one oracle is libzstd's streaming decoder
/// limited to the same window.
pub const ZstdEntry = struct {
    shape: []const u8,
    /// Whether an input has the shape.
    holds: *const fn (facts: ZstdFacts) bool,
    stdx: Kind,
    /// The name of stdx's error, when it refused.
    stdx_error: []const u8 = "",
    libzstd: Kind,
    rfc: []const u8,
    decision: []const u8,
};

pub const zstd_entries = [_]ZstdEntry{
    .{
        .shape = "Window_Descriptor declares a window past 2^23, and Frame_Content_Size is at most 2^23",
        .holds = window_past_http_with_small_content,
        .stdx = .refused,
        .stdx_error = "WindowTooLarge",
        .libzstd = .ok,
        .rfc = "RFC 9659 §3: encoders must not generate frames requiring a Window_Size over 8 MB, and " ++
            "§4 has decoders fail such frames; RFC 8878 §3.1.1.1.2 lets a decoder refuse a window past its limit",
        .decision = "decision 12: the HTTP instance refuses a declared Window_Size past 2^23, whatever the " ++
            "Frame_Content_Size; libzstd bounds the window it needs by Frame_Content_Size",
    },
    .{
        .shape = "a Huffman-coded literals stream is not read exactly to its first bit, in a frame " ++
            "without Content_Checksum",
        .holds = frame_without_checksum,
        .stdx = .refused,
        .stdx_error = "HuffmanStreamNotConsumed",
        .libzstd = .ok,
        .rfc = "RFC 8878 §4.2.2: if a stream is not entirely and exactly consumed, the decoding process " ++
            "is considered faulty",
        .decision = "decision 15: where the RFC says must, stdx does what it says; libzstd decodes such a " ++
            "stream, and with no Content_Checksum nothing else refuses the frame",
    },
};

/// A Zstandard frame's Magic_Number, least significant octet first, and where its
/// Frame_Header_Descriptor lies (RFC 8878 §3.1.1).
const zstd_magic = [_]u8{ 0x28, 0xb5, 0x2f, 0xfd };
const zstd_descriptor_offset = 4;

/// Frame_Header_Descriptor's fields, and the field lengths its flags give (RFC 8878 §3.1.1.1.1).
const zstd_single_segment: u8 = 0x20;
const zstd_checksum_flag: u8 = 0x04;
const zstd_dictionary_mask: u8 = 0x03;
const zstd_content_size_shift = 6;
const zstd_dictionary_lens = [_]usize{ 0, 1, 2, 4 };
const zstd_content_size_lens = [_]usize{ 0, 2, 4, 8 };
const zstd_content_size_two_octet_offset = 256;

/// Window_Descriptor's Exponent and Mantissa (RFC 8878 §3.1.1.1.2), and the HTTP instance's limit.
const zstd_window_log_min = 10;
const zstd_exponent_shift = 3;
const zstd_mantissa_mask: u8 = 0x07;
const zstd_http_window_len: u64 = 1 << 23;

fn zstd_descriptor(input: []const u8) ?u8 {
    if (input.len <= zstd_descriptor_offset or !std.mem.startsWith(u8, input, &zstd_magic)) return null;
    return input[zstd_descriptor_offset];
}

fn zstd_window_len(descriptor: u8) u64 {
    const base = @as(u64, 1) << @intCast(zstd_window_log_min + (descriptor >> zstd_exponent_shift));
    return base + (base >> zstd_exponent_shift) * (descriptor & zstd_mantissa_mask);
}

fn window_past_http_with_small_content(facts: ZstdFacts) bool {
    const descriptor = zstd_descriptor(facts.input) orelse return false;
    const flag = descriptor >> zstd_content_size_shift;
    if (descriptor & zstd_single_segment != 0 or flag == 0) return false;
    const window_at = zstd_descriptor_offset + 1;
    const content_at = window_at + 1 + zstd_dictionary_lens[descriptor & zstd_dictionary_mask];
    const content_field_len = zstd_content_size_lens[flag];
    if (facts.input.len < content_at + content_field_len) return false;
    // Frame_Content_Size, least significant octet first (RFC 8878 §3.1.1.1.4).
    var content_len: u64 = 0;
    for (facts.input[content_at..][0..content_field_len], 0..) |octet, index| content_len |= @as(u64, octet) << @intCast(8 * index);
    if (content_field_len == 2) content_len += zstd_content_size_two_octet_offset;
    return zstd_window_len(facts.input[window_at]) > zstd_http_window_len and content_len <= zstd_http_window_len;
}

fn frame_without_checksum(facts: ZstdFacts) bool {
    const descriptor = zstd_descriptor(facts.input) orelse return false;
    return descriptor & zstd_checksum_flag == 0;
}

/// The index in `zstd_entries` of the entry that allows the disagreement, if one does.
pub fn find_zstd(facts: ZstdFacts, stdx: Kind, stdx_error: []const u8, libzstd: Kind) ?usize {
    for (zstd_entries, 0..) |entry, index| {
        if (entry.stdx != stdx or entry.libzstd != libzstd) continue;
        if (!std.mem.eql(u8, entry.stdx_error, stdx_error)) continue;
        if (!entry.holds(facts)) continue;
        return index;
    }
    return null;
}

fn names(codecs: []const []const u8, codec: []const u8) bool {
    for (codecs) |name| {
        if (std.mem.eql(u8, name, codec)) return true;
    }
    return false;
}

test "every entry cites an RFC section and a decision" {
    for (entries) |entry| {
        try std.testing.expect(std.mem.indexOf(u8, entry.rfc, "RFC ") != null);
        try std.testing.expect(std.mem.indexOf(u8, entry.rfc, "§") != null);
        try std.testing.expect(entry.decision.len > 0);
        try std.testing.expect(entry.codecs.len > 0);
        try std.testing.expect((entry.stdx == .refused) == (entry.stdx_error.len > 0));
    }
    for (zstd_entries) |entry| {
        try std.testing.expect(std.mem.indexOf(u8, entry.rfc, "RFC ") != null);
        try std.testing.expect(std.mem.indexOf(u8, entry.rfc, "§") != null);
        try std.testing.expect(entry.decision.len > 0);
        try std.testing.expect((entry.stdx == .refused) == (entry.stdx_error.len > 0));
    }
}

test "the HDIST entry holds where stdx stopped in a header declaring 31 or 32 distance codes" {
    const in_header: Facts = .{ .input = "", .stopped_in_dynamic_header = true, .distance_count = 31 };
    for ([_][]const u8{ "deflate", "zlib", "gzip" }) |codec| {
        try std.testing.expect(find(codec, in_header, .incomplete, "", .refused, .refused) != null);
    }
    try std.testing.expect(find("zstd", in_header, .incomplete, "", .refused, .refused) == null);
    const thirty: Facts = .{ .input = "", .stopped_in_dynamic_header = true, .distance_count = 30 };
    try std.testing.expect(find("deflate", thirty, .incomplete, "", .refused, .refused) == null);
    const elsewhere: Facts = .{ .input = "", .distance_count = 32 };
    try std.testing.expect(find("deflate", elsewhere, .incomplete, "", .refused, .refused) == null);
    try std.testing.expect(find("deflate", in_header, .ok, "", .refused, .refused) == null);
}

test "the CINFO entry holds for a zlib window below 32 KiB, refused as DistanceTooFar" {
    const cinfo_6: Facts = .{ .input = &.{ 0x68, 0x81 } };
    const cinfo_7: Facts = .{ .input = &.{ 0x78, 0x9c } };
    try std.testing.expect(find("zlib", cinfo_6, .refused, "DistanceTooFar", .ok, .ok) != null);
    try std.testing.expect(find("zlib", cinfo_7, .refused, "DistanceTooFar", .ok, .ok) == null);
    try std.testing.expect(find("zlib", cinfo_6, .refused, "InvalidCode", .ok, .ok) == null);
    try std.testing.expect(find("deflate", cinfo_6, .refused, "DistanceTooFar", .ok, .ok) == null);
    try std.testing.expect(find("zlib", .{ .input = "" }, .refused, "DistanceTooFar", .ok, .ok) == null);
}

test "the gzip entries hold for FHCRC and for a reserved bit, and for nothing else" {
    const with_crc: Facts = .{ .input = &.{ 0x1f, 0x8b, 8, 0b10 } };
    const reserved: Facts = .{ .input = &.{ 0x1f, 0x8b, 8, 0b0100_0100 } };
    const plain: Facts = .{ .input = &.{ 0x1f, 0x8b, 8, 0b1_1101 } };
    try std.testing.expect(find("gzip", with_crc, .refused, "HeaderChecksumMismatch", .refused, .ok) != null);
    try std.testing.expect(find("gzip", plain, .refused, "HeaderChecksumMismatch", .refused, .ok) == null);
    try std.testing.expect(find("gzip", reserved, .refused, "ReservedFlagSet", .refused, .incomplete) != null);
    try std.testing.expect(find("gzip", plain, .refused, "ReservedFlagSet", .refused, .incomplete) == null);
    const reserved_alone: Facts = .{ .input = &.{ 0x1f, 0x8b, 8, 0b0100_0000 } };
    try std.testing.expect(find("gzip", reserved_alone, .refused, "ReservedFlagSet", .refused, .incomplete) == null);
    try std.testing.expect(find("gzip", .{ .input = &.{ 0x1f, 0x8b, 8 } }, .refused, "ReservedFlagSet", .refused, .incomplete) == null);
}

test "the CRC32 entry holds while ISIZE is still missing, and not once it is in" {
    for ([_]usize{ 4, 5, 6, 7 }) |held| {
        const facts: Facts = .{ .input = "", .trailer_held_len = held };
        try std.testing.expect(find("gzip", facts, .refused, "ChecksumMismatch", .refused, .incomplete) != null);
    }
    for ([_]usize{ 0, 3, 8 }) |held| {
        const facts: Facts = .{ .input = "", .trailer_held_len = held };
        try std.testing.expect(find("gzip", facts, .refused, "ChecksumMismatch", .refused, .incomplete) == null);
    }
}

test "the Zstandard window entry holds past 2^23 with a Frame_Content_Size within it, and not otherwise" {
    // Frame_Content_Size_Flag 1: 256 + 0x0f00 = 4096 octets; Window_Descriptor 13 << 3 | 1.
    const past: ZstdFacts = .{ .input = &.{ 0x28, 0xb5, 0x2f, 0xfd, 0x40, 0x69, 0x00, 0x0f } };
    try std.testing.expect(find_zstd(past, .refused, "WindowTooLarge", .ok) != null);
    try std.testing.expect(find_zstd(past, .refused, "WindowTooLarge", .refused) == null);
    // Exactly 2^23; no Frame_Content_Size; one past 2^23 in 4 octets.
    const exact: ZstdFacts = .{ .input = &.{ 0x28, 0xb5, 0x2f, 0xfd, 0x40, 0x68, 0x00, 0x0f } };
    const unsized: ZstdFacts = .{ .input = &.{ 0x28, 0xb5, 0x2f, 0xfd, 0x00, 0x69 } };
    const large: ZstdFacts = .{ .input = &.{ 0x28, 0xb5, 0x2f, 0xfd, 0x80, 0x69, 0x01, 0x00, 0x80, 0x00 } };
    for ([_]ZstdFacts{ exact, unsized, large, .{ .input = "" } }) |facts| {
        try std.testing.expect(find_zstd(facts, .refused, "WindowTooLarge", .ok) == null);
    }
}

test "the Zstandard Huffman entry holds in a frame without Content_Checksum alone" {
    const without: ZstdFacts = .{ .input = &.{ 0x28, 0xb5, 0x2f, 0xfd, 0x00 } };
    const with: ZstdFacts = .{ .input = &.{ 0x28, 0xb5, 0x2f, 0xfd, 0x04 } };
    try std.testing.expect(find_zstd(without, .refused, "HuffmanStreamNotConsumed", .ok) != null);
    try std.testing.expect(find_zstd(with, .refused, "HuffmanStreamNotConsumed", .ok) == null);
    try std.testing.expect(find_zstd(without, .refused, "HuffmanStreamUnterminated", .ok) == null);
    try std.testing.expect(find_zstd(.{ .input = "\x28\xb5" }, .refused, "HuffmanStreamNotConsumed", .ok) == null);
}
