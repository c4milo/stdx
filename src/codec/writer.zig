//! The checked octet writer every codec writes through (CLAUDE.md, Conventions; decision 16).
//!
//! It fills a slice the caller owns, from the front, and never past its end: a whole write checks
//! the room left first and returns `error.NoSpaceLeft` when too little is, and a partial write
//! writes what fits and says how much. A streaming codec keeps what it could not write in its own
//! state and returns `needs_room`, so any room, down to one octet, makes progress (decision 11).

const std = @import("std");
const assert = std.debug.assert;

pub const Writer = struct {
    octets: []u8,
    /// The number of octets written so far, from the front.
    position: usize = 0,

    pub fn init(octets: []u8) Writer {
        return .{ .octets = octets };
    }

    /// The room left.
    pub fn room_len(self: *const Writer) usize {
        assert(self.position <= self.octets.len);
        return self.octets.len - self.position;
    }

    /// The octets written so far: what a streaming call reports as written.
    pub fn written(self: *const Writer) []const u8 {
        assert(self.position <= self.octets.len);
        return self.octets[0..self.position];
    }

    /// Writes one octet, or returns `error.NoSpaceLeft` when the output is full.
    pub fn write_octet(self: *Writer, octet: u8) error{NoSpaceLeft}!void {
        if (self.room_len() == 0) return error.NoSpaceLeft;
        self.octets[self.position] = octet;
        self.position += 1;
    }

    /// Writes all of `octets`, or returns `error.NoSpaceLeft` and writes nothing.
    pub fn write_all(self: *Writer, octets: []const u8) error{NoSpaceLeft}!void {
        if (octets.len > self.room_len()) return error.NoSpaceLeft;
        @memcpy(self.octets[self.position..][0..octets.len], octets);
        self.position += octets.len;
        assert(self.position <= self.octets.len);
    }

    /// Writes as much of `octets` as fits and returns how many it wrote.
    pub fn write_partial(self: *Writer, octets: []const u8) usize {
        const len = @min(octets.len, self.room_len());
        @memcpy(self.octets[self.position..][0..len], octets[0..len]);
        self.position += len;
        return len;
    }

    /// Writes an integer in the given byte order, or returns `error.NoSpaceLeft` and writes
    /// nothing.
    pub fn write_int(self: *Writer, comptime T: type, value: T, endian: std.builtin.Endian) error{NoSpaceLeft}!void {
        comptime assert(@typeInfo(T).int.bits % @bitSizeOf(u8) == 0);
        var octets: [@sizeOf(T)]u8 = undefined;
        std.mem.writeInt(T, &octets, value, endian);
        try self.write_all(&octets);
    }
};

// Tests. Every refusal of the writer has one.

const testing = std.testing;

test "write_octet fills the output and refuses past its end" {
    var buffer: [2]u8 = undefined;
    var writer = Writer.init(&buffer);
    try writer.write_octet('a');
    try writer.write_octet('b');
    try testing.expectError(error.NoSpaceLeft, writer.write_octet('c'));
    try testing.expectEqualStrings("ab", writer.written());
}

test "write_all refuses what does not fit and writes nothing of it" {
    var buffer: [5]u8 = undefined;
    var writer = Writer.init(&buffer);
    try writer.write_all("oct");
    try testing.expectError(error.NoSpaceLeft, writer.write_all("ets"));
    try testing.expectEqual(2, writer.room_len());
    try testing.expectEqualStrings("oct", writer.written());
}

test "write_partial writes what fits, down to nothing" {
    var buffer: [4]u8 = undefined;
    var writer = Writer.init(&buffer);
    try testing.expectEqual(4, writer.write_partial("octets"));
    try testing.expectEqual(0, writer.write_partial("more"));
    try testing.expectEqualStrings("octe", writer.written());
}

test "write_int writes each byte order, and a short write writes nothing" {
    var buffer: [5]u8 = undefined;
    var writer = Writer.init(&buffer);
    try writer.write_int(u16, 0x1234, .big);
    try writer.write_int(u16, 0x1234, .little);
    try testing.expectError(error.NoSpaceLeft, writer.write_int(u16, 0x5678, .little));
    try testing.expectEqualSlices(u8, &.{ 0x12, 0x34, 0x34, 0x12 }, writer.written());
}
