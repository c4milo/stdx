//! The checked backward bit reader of Zstandard's Huffman and FSE bitstreams (RFC 8878 §4.1,
//! §4.2.2, §3.1.1.3.2.1.2). The compressor writes bits forward, each octet filled from its least
//! significant bit, then a single 1 bit and zeros to the octet's end. The decoder reads from that
//! 1 bit back toward the stream's first bit.
//!
//! The stream is whole in memory: a Zstandard block is gathered before its streams are read
//! (decision 12). A read takes the `count` bits just below the reading position as one number,
//! least significant octet first (RFC 8878 §4.1), so the bit read first is the number's most
//! significant. Bits before the stream's first read as zeros and set `overflowed`, as the FSE
//! stream of Huffman weights allows (RFC 8878 §4.2.1.2); every other stream must end exactly at
//! its first bit, which `finished` reports.

const std = @import("std");
const assert = std.debug.assert;

/// The most bits one read takes.
pub const read_bits_max = 57;

pub const BackwardBitReader = struct {
    octets: []const u8,
    /// The bits not yet read: the stream's bits below this position, bit i being bit i % 8 of
    /// octet i / 8.
    position: usize,
    /// Whether a read reached before the stream's first bit.
    overflowed: bool,

    /// A reader of `octets`, from just below the final 1 bit of its last octet. Null when the
    /// stream is empty or its last octet is 0, which holds no final bit (RFC 8878 §4.2.2).
    pub fn init(octets: []const u8) ?BackwardBitReader {
        if (octets.len == 0) return null;
        const last = octets[octets.len - 1];
        // RFC 8878 §4.2.2: the last octet holds the final 1 bit, so it cannot be 0.
        if (last == 0) return null;
        const final_bit = @bitSizeOf(u8) - 1 - @clz(last);
        return .{ .octets = octets, .position = (octets.len - 1) * @bitSizeOf(u8) + final_bit, .overflowed = false };
    }

    /// The next `count` bits as one number, the first to be read most significant, without using
    /// them. Bits before the stream's first read as zeros.
    pub fn peek(self: *const BackwardBitReader, count: u6) u64 {
        assert(count <= read_bits_max);
        if (count == 0) return 0;
        if (count > self.position) return self.bits(0, self.position) << @intCast(count - self.position);
        return self.bits(self.position - count, count);
    }

    /// Uses the next `count` bits. Using more than remain sets `overflowed`.
    pub fn consume(self: *BackwardBitReader, count: u6) void {
        assert(count <= read_bits_max);
        if (count > self.position) {
            self.overflowed = true;
            self.position = 0;
            return;
        }
        self.position -= count;
    }

    /// The next `count` bits, used.
    pub fn read(self: *BackwardBitReader, count: u6) u64 {
        const value = self.peek(count);
        self.consume(count);
        return value;
    }

    /// The bits not yet read.
    pub fn remaining_bits(self: *const BackwardBitReader) usize {
        return self.position;
    }

    /// Whether every bit was read and no read reached before the first.
    pub fn finished(self: *const BackwardBitReader) bool {
        return self.position == 0 and !self.overflowed;
    }

    /// `len` bits of the stream from bit `start`, the first of them least significant.
    fn bits(self: *const BackwardBitReader, start: usize, len: usize) u64 {
        assert(len <= read_bits_max and start + len <= self.octets.len * @bitSizeOf(u8));
        if (len == 0) return 0;
        const first = start / @bitSizeOf(u8);
        const last = (start + len - 1) / @bitSizeOf(u8);
        var value: u64 = 0;
        // At most 8 octets: 57 bits from any bit of an octet end within the eighth.
        for (self.octets[first .. last + 1], 0..) |octet, index| value |= @as(u64, octet) << @intCast(index * @bitSizeOf(u8));
        value >>= @intCast(start % @bitSizeOf(u8));
        return value & ((@as(u64, 1) << @intCast(len)) - 1);
    }
};

// Tests.

const testing = std.testing;

test "the final 1 bit and the padding above it are not data" {
    // Bits written forward: 0b101 then 0b1100 in the low 7 bits, then the final bit.
    const stream = [_]u8{0b1110_0101};
    var reader = BackwardBitReader.init(&stream).?;
    try testing.expectEqual(7, reader.remaining_bits());
    // Read backward: the last field written comes first.
    try testing.expectEqual(0b1100, reader.read(4));
    try testing.expectEqual(0b101, reader.read(3));
    try testing.expect(reader.finished());
}

test "a read spans octets, least significant octet first" {
    // 12 bits 0xabc then the final bit at bit 12.
    const stream = [_]u8{ 0xbc, 0x1a };
    var reader = BackwardBitReader.init(&stream).?;
    try testing.expectEqual(0xa, reader.read(4));
    try testing.expectEqual(0xbc, reader.read(8));
    try testing.expect(reader.finished());
}

test "an empty stream or a last octet of 0 holds no final bit" {
    try testing.expectEqual(null, BackwardBitReader.init(&.{}));
    try testing.expectEqual(null, BackwardBitReader.init(&.{ 0x12, 0 }));
}

test "bits before the first read as zeros and mark the reader overflowed" {
    const stream = [_]u8{0b0000_0111};
    var reader = BackwardBitReader.init(&stream).?;
    try testing.expectEqual(2, reader.remaining_bits());
    try testing.expectEqual(0b1100, reader.read(4));
    try testing.expect(reader.overflowed);
    try testing.expect(!reader.finished());
}

test "57 bits read at any alignment" {
    var stream: [9]u8 = undefined;
    for (&stream, 0..) |*octet, index| octet.* = @truncate(index *% 0x9d + 0x31);
    // The final bit is bit 7 of the ninth octet, so 71 bits of data lie below it.
    stream[8] = 0x80;
    const whole = std.mem.readInt(u72, &stream, .little);
    for (0..8) |skip| {
        var reader = BackwardBitReader.init(&stream).?;
        _ = reader.read(@intCast(skip));
        const start = 71 - skip - read_bits_max;
        try testing.expectEqual(@as(u64, @truncate(whole >> @intCast(start))) & ((@as(u64, 1) << read_bits_max) - 1), reader.peek(read_bits_max));
    }
}
