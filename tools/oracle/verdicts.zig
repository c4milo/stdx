//! The verdict entries of decision 15: every case where stdx, zlib and Wuffs do not all give an
//! input the same verdict, with the RFC section that decides it and the decision behind stdx's
//! choice. A differential check that finds a disagreement no entry matches fails, and adding an
//! entry is a change to a check, so it carries its mutation results.
//!
//! An entry matches a disagreement by the verdicts, stdx's with its error's name when it refused
//! and each oracle's, and by `holds`, which reads the input and says whether it has the entry's
//! shape. Verdicts alone would let an entry cover a disagreement with another cause. `shape` says
//! in prose what `holds` checks.

const std = @import("std");

/// A verdict of any decoder: the stream ended and every check passed; the input was refused; the
/// input ended before the stream did; or the output filled first.
pub const Kind = enum { ok, refused, incomplete, no_room };

pub const Entry = struct {
    codec: []const u8,
    shape: []const u8,
    /// Whether an input has the shape.
    holds: *const fn (input: []const u8) bool,
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
        .codec = "deflate",
        .shape = "the first block is dynamic and its HDIST declares 31 or 32 distance codes",
        .holds = first_block_declares_unused_distance_codes,
        .stdx = .incomplete,
        .zlib = .refused,
        .wuffs = .refused,
        .rfc = "RFC 1951 §3.2.7 gives HDIST the range 1 to 32, and §3.3 requires a decoder to " ++
            "accept every stream that conforms",
        .decision = "decision 15: where the RFC says must, stdx does what it says; distance codes " ++
            "30 and 31 are refused where they appear (RFC 1951 §3.2.6), not where HDIST declares them",
    },
};

/// The number of distance codes RFC 1951 §3.2.6 uses; HDIST can declare two more.
const distance_codes_used = 30;

/// Whether a raw DEFLATE stream's first block is dynamic and its HDIST (RFC 1951 §3.2.7) declares
/// more than the 30 distance codes RFC 1951 §3.2.6 uses. The header's fields are packed least
/// significant bit first (RFC 1951 §3.1.1): BFINAL, BTYPE, HLIT, then HDIST.
fn first_block_declares_unused_distance_codes(input: []const u8) bool {
    if (input.len < 2) return false;
    const header = std.mem.readInt(u16, input[0..2], .little);
    const block_type = (header >> 1) & 0b11;
    const distance_count = ((header >> 8) & 0b11111) + 1;
    return block_type == 0b10 and distance_count > distance_codes_used;
}

/// The entry that allows these verdicts on this input, or null.
pub fn find(codec: []const u8, input: []const u8, stdx: Kind, stdx_error: []const u8, zlib: Kind, wuffs: Kind) ?*const Entry {
    for (&entries) |*entry| {
        if (!std.mem.eql(u8, entry.codec, codec)) continue;
        if (entry.stdx != stdx or entry.zlib != zlib or entry.wuffs != wuffs) continue;
        if (!std.mem.eql(u8, entry.stdx_error, stdx_error)) continue;
        if (!entry.holds(input)) continue;
        return entry;
    }
    return null;
}

test "every entry cites an RFC section and a decision" {
    for (entries) |entry| {
        try std.testing.expect(std.mem.indexOf(u8, entry.rfc, "RFC ") != null);
        try std.testing.expect(std.mem.indexOf(u8, entry.rfc, "§") != null);
        try std.testing.expect(entry.decision.len > 0);
        try std.testing.expect((entry.stdx == .refused) == (entry.stdx_error.len > 0));
    }
}

test "the HDIST entry holds for 31 and 32 declared distance codes in a dynamic first block only" {
    // BFINAL 1, BTYPE 10, HLIT 0; then HDIST in the low five bits of the second octet.
    try std.testing.expect(first_block_declares_unused_distance_codes(&.{ 0b101, 30 }));
    try std.testing.expect(first_block_declares_unused_distance_codes(&.{ 0b101, 31 }));
    try std.testing.expect(!first_block_declares_unused_distance_codes(&.{ 0b101, 29 }));
    try std.testing.expect(!first_block_declares_unused_distance_codes(&.{ 0b011, 31 }));
    try std.testing.expect(!first_block_declares_unused_distance_codes(&.{0b101}));
    const allowed = find("deflate", &.{ 0b101, 31 }, .incomplete, "", .refused, .refused);
    try std.testing.expect(allowed != null);
    try std.testing.expect(find("deflate", &.{ 0b101, 29 }, .incomplete, "", .refused, .refused) == null);
    try std.testing.expect(find("deflate", &.{ 0b101, 31 }, .ok, "", .refused, .refused) == null);
}
