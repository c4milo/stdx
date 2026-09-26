//! The checked bit writer of every codec that packs its codes least significant bit first: DEFLATE
//! (RFC 1951 §3.1.1) and brotli (RFC 7932 §1.5.1). Codes go into a 64-bit buffer, the oldest bit at
//! bit 0, and whole octets leave it through `Writer`, one at a time, while the output has room.
//!
//! A streaming call builds a `BitWriter` over its output and the `Bits` its state kept from the
//! call before, and hands the `Bits` back at the end. An encoder puts a code only when the buffer
//! has room for it, draining whole octets first (`make_room`). When the output fills, the bits
//! wait in the state for the next call's room, so any room, down to one octet, makes progress
//! (decision 11).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const Writer = @import("writer.zig").Writer;
const Bits = @import("bit_reader.zig").Bits;

pub const BitWriter = struct {
    writer: Writer,
    bits: Bits,

    /// A writer over one call's `output`, continuing from the `bits` the state kept.
    pub fn init(output: []u8, bits: Bits) BitWriter {
        assert(bits.count == constants.bit_buffer_bits or bits.buffer >> @intCast(bits.count) == 0);
        return .{ .writer = Writer.init(output), .bits = bits };
    }

    /// Whether `count` more bits fit the buffer.
    pub fn has_room(self: *const BitWriter, count: u7) bool {
        return self.bits.count + count <= constants.bit_buffer_bits;
    }

    /// Makes room for `count` bits, writing whole octets to the output as needed. Returns false
    /// when the output fills first; the bits stay in the buffer, and the caller returns
    /// `needs_room`.
    pub fn make_room(self: *BitWriter, count: u7) bool {
        assert(count <= constants.bit_buffer_bits - @bitSizeOf(u8) + 1);
        if (self.has_room(count)) return true;
        _ = self.drain();
        return self.has_room(count);
    }

    /// Puts the low `count` bits of `value`, the least significant first. The buffer must have
    /// room, and `value` no bit above `count`.
    pub fn put(self: *BitWriter, value: u64, count: u7) void {
        assert(self.has_room(count));
        assert(count == constants.bit_buffer_bits or value >> @intCast(count) == 0);
        if (count == 0) return;
        self.bits.buffer |= value << @intCast(self.bits.count);
        self.bits.count += count;
    }

    /// Writes whole octets while the output has room. Returns whether no whole octet is left in
    /// the buffer.
    pub fn drain(self: *BitWriter) bool {
        for (0..constants.bit_buffer_bits / @bitSizeOf(u8)) |_| {
            if (self.bits.count < @bitSizeOf(u8)) return true;
            self.writer.write_octet(@truncate(self.bits.buffer)) catch return false;
            self.bits.buffer >>= @bitSizeOf(u8);
            self.bits.count -= @bitSizeOf(u8);
        }
        return self.bits.count < @bitSizeOf(u8);
    }

    /// The bits that bring the buffer to an octet boundary, which `put` fills with zeros.
    pub fn bits_to_octet(self: *const BitWriter) u7 {
        return (@bitSizeOf(u8) - self.bits.count % @bitSizeOf(u8)) % @bitSizeOf(u8);
    }
};

// Tests.

const testing = std.testing;

test "codes leave least significant bit first, a whole octet at a time" {
    var output: [4]u8 = undefined;
    var writer = BitWriter.init(&output, .{});
    // 3 bits of 0b101, then 7 of 0b1100110: bits 0-2 and 3-9 of the stream (RFC 1951 §3.1.1).
    writer.put(0b101, 3);
    writer.put(0b1100110, 7);
    try testing.expect(writer.drain());
    try testing.expectEqualSlices(u8, &.{0b00110101}, writer.writer.written());
    try testing.expectEqual(2, writer.bits.count);
    try testing.expectEqual(6, writer.bits_to_octet());
    writer.put(0, writer.bits_to_octet());
    try testing.expect(writer.drain());
    try testing.expectEqualSlices(u8, &.{ 0b00110101, 0b11 }, writer.writer.written());
}

test "a full output keeps the bits in the buffer for the next call" {
    var output: [1]u8 = undefined;
    var writer = BitWriter.init(&output, .{});
    writer.put(0xabcd, 16);
    try testing.expect(!writer.drain());
    try testing.expectEqualSlices(u8, &.{0xcd}, writer.writer.written());
    var next: [1]u8 = undefined;
    writer = BitWriter.init(&next, writer.bits);
    try testing.expect(writer.drain());
    try testing.expectEqualSlices(u8, &.{0xab}, writer.writer.written());
}

test "make_room drains to fit a code, and says when the output is full" {
    var output: [1]u8 = undefined;
    var writer = BitWriter.init(&output, .{});
    writer.put(0xffff_ffff_ffff, 48);
    try testing.expect(!writer.has_room(20));
    // One octet of room brings the buffer to 40 bits, and 20 more fit; 32 more do not.
    try testing.expect(writer.make_room(20));
    try testing.expect(!writer.make_room(32));
    try testing.expectEqual(40, writer.bits.count);
}
