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
