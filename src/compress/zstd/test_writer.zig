//! Writers the zstd tests encode with: bits written forward as a Zstandard compressor writes them,
//! a Huffman-coded stream as RFC 8878 §4.2.2 reads it, and an FSE table description as §4.1.1
//! reads it. Test code only; the decoder never imports it.

const std = @import("std");
const constants = @import("constants.zig");
const fse = @import("fse.zig");
const huffman = @import("huffman.zig");

/// The most literals a written stream holds.
const stream_literals_max = 400;

/// The octets a written stream takes at most: `stream_literals_max` literals of up to 11 bits, and
/// the final 1 bit.
const stream_capacity = std.math.divCeil(usize, stream_literals_max * constants.huffman_bits_max + 1, @bitSizeOf(u8)) catch unreachable;

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
const bits_capacity = 1024;

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

/// The octets a written description takes at most: 53 symbols of up to 10 bits and their flags.
const description_capacity = 128;

/// Writes `distribution` in RFC 8878 §4.1.1's format, least significant bit first.
pub const DescriptionWriter = struct {
    octets: [description_capacity]u8 = @splat(0),
    bits_written: usize = 0,

    fn put(self: *DescriptionWriter, value: u32, count: usize) void {
        const octet_bits = @bitSizeOf(u8);
        for (0..count) |bit| {
            if ((value >> @intCast(bit)) & 1 != 0) self.octets[self.bits_written / octet_bits] |= @as(u8, 1) << @intCast(self.bits_written % octet_bits);
            self.bits_written += 1;
        }
    }

    pub fn write(self: *DescriptionWriter, distribution: *const fse.Distribution) void {
        self.put(distribution.accuracy_log - constants.accuracy_log_offset, constants.accuracy_log_field_bits);
        var left: u32 = @as(u32, 1) << distribution.accuracy_log;
        var symbol: usize = 0;
        while (left > 0) {
            const probability = distribution.probabilities[symbol];
            self.put_value(@intCast(probability + 1), left);
            left -= if (probability < 0) 1 else @intCast(probability);
            symbol += 1;
            if (probability != 0) continue;
            var zeros: u32 = 0;
            while (symbol + zeros < distribution.symbol_count and distribution.probabilities[symbol + zeros] == 0) zeros += 1;
            symbol += zeros;
            const more = constants.fse_repeat_flag_more;
            for (0..fse.symbols_max) |_| {
                const flag = @min(zeros, more);
                self.put(flag, constants.fse_repeat_flag_bits);
                if (flag < more) break;
                zeros -= more;
            }
        }
    }

    /// Table 20's inverse: small values in one bit fewer.
    fn put_value(self: *DescriptionWriter, value: u32, left: u32) void {
        const value_max = left + 1;
        const bits = std.math.log2_int(u32, value_max) + 1;
        const threshold = (@as(u32, 1) << @intCast(bits)) - 1 - value_max;
        if (value < threshold) return self.put(value, bits - 1);
        if (value < @as(u32, 1) << @intCast(bits - 1)) return self.put(value, bits);
        self.put(value + threshold, bits);
    }
};
