//! The checked octet reader every codec parses through (CLAUDE.md, Conventions; decision 16).
//!
//! It reads a slice the caller already has, from the front, and never past its end: every read
//! checks the octets left first and returns `error.Truncated` when too few are. A streaming codec
//! turns `Truncated` into `needs_input` and keeps what it has read so far in its own state, so a
//! field split across calls is read in pieces.
//!
//! The byte order is always stated at the read: DEFLATE's containers disagree on it, since zlib
//! stores numbers most significant octet first (RFC 1950 §2.1) and gzip least significant first
//! (RFC 1952 §2.1).

const std = @import("std");
const assert = std.debug.assert;

pub const Reader = struct {
    octets: []const u8,
    /// The number of octets read so far, from the front.
    position: usize = 0,

    pub fn init(octets: []const u8) Reader {
        return .{ .octets = octets };
    }

    /// The octets not yet read.
    pub fn remaining_len(self: *const Reader) usize {
        assert(self.position <= self.octets.len);
        return self.octets.len - self.position;
    }

    /// The octets read so far: what a streaming call reports as consumed.
    pub fn consumed(self: *const Reader) usize {
        assert(self.position <= self.octets.len);
        return self.position;
    }

    /// The next octet, or `error.Truncated` when none is left.
    pub fn read_octet(self: *Reader) error{Truncated}!u8 {
        if (self.remaining_len() == 0) return error.Truncated;
        const octet = self.octets[self.position];
        self.position += 1;
        return octet;
    }

    /// The next `@sizeOf(T)` octets as an integer in the given byte order, or `error.Truncated`
    /// when fewer are left, in which case nothing is read.
    pub fn read_int(self: *Reader, comptime T: type, endian: std.builtin.Endian) error{Truncated}!T {
        comptime assert(@typeInfo(T).int.bits % @bitSizeOf(u8) == 0);
        const octets = try self.take(@sizeOf(T));
        return std.mem.readInt(T, octets[0..@sizeOf(T)], endian);
    }

    /// The next `len` octets, or `error.Truncated` when fewer are left, in which case nothing is
    /// read.
    pub fn take(self: *Reader, len: usize) error{Truncated}![]const u8 {
        if (len > self.remaining_len()) return error.Truncated;
        const octets = self.octets[self.position..][0..len];
        self.position += len;
        assert(self.position <= self.octets.len);
        return octets;
    }

    /// As many of the next `len_max` octets as are left, possibly none.
    pub fn take_partial(self: *Reader, len_max: usize) []const u8 {
        const len = @min(len_max, self.remaining_len());
        const octets = self.octets[self.position..][0..len];
        self.position += len;
        return octets;
    }

    /// Hands back the last `len` octets read, so the caller reads them again. A decoder uses it to
    /// return octets it read ahead past the end of its stream (decision 11).
    pub fn unread(self: *Reader, len: usize) void {
        assert(len <= self.position);
        self.position -= len;
    }
};

// Tests. Every refusal of the reader has one.

const testing = std.testing;

test "read_octet reads in order and refuses past the end" {
    var reader = Reader.init(&.{ 1, 2 });
    try testing.expectEqual(1, try reader.read_octet());
    try testing.expectEqual(2, try reader.read_octet());
    try testing.expectError(error.Truncated, reader.read_octet());
    try testing.expectEqual(2, reader.consumed());
}

test "read_int reads each byte order, and a short read reads nothing" {
    var reader = Reader.init(&.{ 0x12, 0x34, 0x56, 0x78, 0x9a });
    try testing.expectEqual(0x1234, try reader.read_int(u16, .big));
    try testing.expectEqual(0x7856, try reader.read_int(u16, .little));
    try testing.expectError(error.Truncated, reader.read_int(u16, .little));
    try testing.expectEqual(4, reader.consumed());
    try testing.expectEqual(0x9a, try reader.read_octet());
}

test "take refuses a length past the end and reads nothing" {
    var reader = Reader.init("octets");
    try testing.expectEqualStrings("oct", try reader.take(3));
    try testing.expectError(error.Truncated, reader.take(4));
    try testing.expectEqual(3, reader.remaining_len());
    try testing.expectEqualStrings("ets", try reader.take(3));
    try testing.expectEqualStrings("", try reader.take(0));
}

test "take_partial takes what is left, and unread hands octets back" {
    var reader = Reader.init("octets");
    try testing.expectEqualStrings("octets", reader.take_partial(100));
    try testing.expectEqualStrings("", reader.take_partial(1));
    reader.unread(2);
    try testing.expectEqual(4, reader.consumed());
    try testing.expectEqualStrings("ts", try reader.take(2));
}
