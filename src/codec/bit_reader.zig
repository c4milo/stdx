//! The checked bit reader of every codec that packs its codes least significant bit first: DEFLATE
//! (RFC 1951 §3.1.1) and brotli (RFC 7932 §1.5.1). Bits are taken from each octet starting at its
//! least significant bit, and octets in order.
//!
//! A streaming call builds a `BitReader` over its input and the `Bits` its state kept from the call
//! before, and hands the `Bits` back to its state at the end. The refill here is the checked one:
//! it takes one octet at a time through `Reader`, and only while the buffer holds fewer bits than
//! the caller asked for. The 8-octet refill of decision 14's claim S1 is a fast path of step 7.
//!
//! Decision 11's read-ahead rule is `unread_whole_octets`: at the end of a call that does not return
//! `needs_input`, a codec hands back every whole octet it took and has not used, so the octets
//! after a stream's end stay in the caller's input.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const Reader = @import("reader.zig").Reader;

/// The bits a stream took from its input and has not used, kept in a codec's state between calls.
/// The low `count` bits of `buffer` are valid, the oldest in bit 0.
pub const Bits = struct {
    buffer: u64 = 0,
    count: u7 = 0,

    fn check(self: Bits) void {
        assert(self.count <= constants.bit_buffer_bits);
        assert(self.count == constants.bit_buffer_bits or self.buffer >> @intCast(self.count) == 0);
    }
};

pub const BitReader = struct {
    reader: Reader,
    bits: Bits,

    /// A reader over one call's `input`, continuing from the `bits` the state kept.
    pub fn init(input: []const u8, bits: Bits) BitReader {
        bits.check();
        return .{ .reader = Reader.init(input), .bits = bits };
    }

    /// Makes at least `count` bits available, taking whole octets from the input as needed. Returns
    /// false when the input runs out first; the octets it took stay in the buffer, and the caller
    /// returns `needs_input`.
    pub fn ensure(self: *BitReader, count: u7) bool {
        assert(count <= constants.ensure_bits_max);
        while (self.bits.count < count) {
            const octet = self.reader.read_octet() catch return false;
            self.bits.buffer |= @as(u64, octet) << @intCast(self.bits.count);
            self.bits.count += @bitSizeOf(u8);
        }
        assert(self.bits.count <= constants.bit_buffer_bits);
        return true;
    }

    /// The next `count` bits, least significant first, without using them. `ensure(count)` must
    /// have returned true.
    pub fn peek(self: *const BitReader, count: u7) u64 {
        assert(count <= self.bits.count);
        assert(count <= constants.ensure_bits_max);
        return self.bits.buffer & low_mask(count);
    }

    /// Uses the next `count` bits. `ensure(count)` must have returned true.
    pub fn consume(self: *BitReader, count: u7) void {
        assert(count <= self.bits.count);
        self.bits.buffer = if (count == constants.bit_buffer_bits) 0 else self.bits.buffer >> @intCast(count);
        self.bits.count -= count;
        self.bits.check();
    }

    /// The next `count` bits, used, or null when the input runs out first.
    pub fn read(self: *BitReader, count: u7) ?u64 {
        if (!self.ensure(count)) return null;
        const value = self.peek(count);
        self.consume(count);
        return value;
    }

    /// Drops the bits left in the octet being read, so the next read starts on an octet boundary,
    /// as a stored block's LEN does (RFC 1951 §3.2.4).
    pub fn align_to_octet(self: *BitReader) void {
        self.consume(self.bits.count % @bitSizeOf(u8));
        assert(self.bits.count % @bitSizeOf(u8) == 0);
    }

    /// Hands back every whole octet this call took from its input and has not used (decision 11).
    /// Octets the state brought from an earlier call stay in the buffer, because this call's input
    /// does not hold them.
    pub fn unread_whole_octets(self: *BitReader) void {
        const whole = @min(self.bits.count / @bitSizeOf(u8), self.reader.consumed());
        self.reader.unread(whole);
        self.bits.count -= @intCast(whole * @bitSizeOf(u8));
        self.bits.buffer &= low_mask(self.bits.count);
        self.bits.check();
    }

    /// The octets of this call's input taken so far.
    pub fn consumed(self: *const BitReader) usize {
        return self.reader.consumed();
    }

    /// The bits to keep in the state for the next call.
    pub fn finish(self: *const BitReader) Bits {
        self.bits.check();
        return self.bits;
    }
};

fn low_mask(count: u7) u64 {
    assert(count <= constants.bit_buffer_bits);
    if (count == constants.bit_buffer_bits) return std.math.maxInt(u64);
    return (@as(u64, 1) << @intCast(count)) - 1;
}

test {
    _ = @import("bit_reader_test.zig");
}
