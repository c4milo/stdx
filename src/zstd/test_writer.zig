//! Writers the zstd tests encode with: bits written forward as a Zstandard compressor writes them,
//! and a Huffman-coded stream as RFC 8878 §4.2.2 reads it. Test code only; the decoder never
//! imports it.

const std = @import("std");
const huffman = @import("huffman.zig");

/// The octets a written stream takes at most: 300 literals of up to 11 bits.
const stream_capacity = 512;

/// Encodes literals as RFC 8878 §4.2.2 reads them: codes written forward from the last literal
/// to the first, each most significant bit last, then the final 1 bit.
pub const StreamWriter = struct {
    octets: [stream_capacity]u8 = @splat(0),
    bits_written: usize = 0,

    fn put_bit(self: *StreamWriter, bit: u1) void {
        const octet_bits = @bitSizeOf(u8);
        if (bit == 1) self.octets[self.bits_written / octet_bits] |= @as(u8, 1) << @intCast(self.bits_written % octet_bits);
        self.bits_written += 1;
    }

    /// The table's code of `symbol`: its first cell's index, shifted to the code's length.
    fn code_of(table: *const huffman.Table, symbol: u8) struct { u16, u8 } {
        for (table.cells[0 .. @as(usize, 1) << table.bits_max], 0..) |cell, index| {
            if (cell.symbol == symbol) return .{ @intCast(index >> @intCast(table.bits_max - cell.bits)), cell.bits };
        }
        unreachable;
    }

    pub fn write(self: *StreamWriter, table: *const huffman.Table, literals: []const u8) []const u8 {
        var index = literals.len;
        while (index > 0) {
            index -= 1;
            const code, const bits = code_of(table, literals[index]);
            // The reader takes the bit written last first, as the code's most significant.
            for (0..bits) |bit| self.put_bit(@intCast((code >> @intCast(bit)) & 1));
        }
        self.put_bit(1);
        return self.octets[0 .. std.math.divCeil(usize, self.bits_written, @bitSizeOf(u8)) catch unreachable];
    }
};

/// The octets a forward bit stream in these tests takes at most.
const bits_capacity = 256;

/// Bits written forward, each octet filled from its least significant bit, ended by the final 1
/// bit a backward reader starts below (RFC 8878 §4.1, §3.1.1.3.2.1.2).
pub const BitWriter = struct {
    octets: [bits_capacity]u8 = @splat(0),
    bits_written: usize = 0,

    pub fn put(self: *BitWriter, value: u64, count: usize) void {
        const octet_bits = @bitSizeOf(u8);
        for (0..count) |bit| {
            if ((value >> @intCast(bit)) & 1 != 0) self.octets[self.bits_written / octet_bits] |= @as(u8, 1) << @intCast(self.bits_written % octet_bits);
            self.bits_written += 1;
        }
    }

    /// Writes the final 1 bit and returns the stream.
    pub fn finish(self: *BitWriter) []const u8 {
        self.put(1, 1);
        return self.octets[0 .. std.math.divCeil(usize, self.bits_written, @bitSizeOf(u8)) catch unreachable];
    }
};
