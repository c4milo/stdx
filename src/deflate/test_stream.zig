//! A bit writer that builds DEFLATE streams for tests, this module's and its containers': least
//! significant bit first, with Huffman codes most significant bit first (RFC 1951 §3.1.1), and
//! codes assigned by RFC 1951 §3.2.2's algorithm. The library never calls it.

const std = @import("std");
const codec = @import("codec");
const constants = @import("constants.zig");

/// The most octets a test stream takes.
pub const stream_len_max = 1024;

/// Builds a stream bit by bit.
pub const Stream = struct {
    octets: [stream_len_max]u8 = @splat(0),
    bit_len: usize = 0,

    /// A data element, least significant bit first (RFC 1951 §3.1.1).
    pub fn bits(self: *Stream, value: u64, count: usize) void {
        for (0..count) |index| {
            const bit: u8 = @intCast((value >> @intCast(index)) & 1);
            self.octets[self.bit_len / @bitSizeOf(u8)] |= bit << @intCast(self.bit_len % @bitSizeOf(u8));
            self.bit_len += 1;
        }
    }

    /// A Huffman code, most significant bit first (RFC 1951 §3.1.1).
    pub fn code(self: *Stream, value: u16, len: usize) void {
        for (0..len) |index| self.bits((value >> @intCast(len - 1 - index)) & 1, 1);
    }

    /// Whole octets from the next octet boundary, as a stored block's data or a container's
    /// header and trailer take them.
    pub fn append(self: *Stream, octets: []const u8) void {
        self.align_to_octet();
        for (octets) |octet| self.bits(octet, @bitSizeOf(u8));
    }

    pub fn align_to_octet(self: *Stream) void {
        self.bit_len = std.mem.alignForward(usize, self.bit_len, @bitSizeOf(u8));
    }

    pub fn slice(self: *const Stream) []const u8 {
        return self.octets[0 .. std.math.divCeil(usize, self.bit_len, @bitSizeOf(u8)) catch unreachable];
    }

    pub fn block_header(self: *Stream, last: bool, block_type: constants.BlockType) void {
        self.bits(@intFromBool(last), constants.final_bits);
        self.bits(@intFromEnum(block_type), constants.type_bits);
    }

    pub fn stored(self: *Stream, last: bool, octets: []const u8) void {
        self.block_header(last, .stored);
        self.align_to_octet();
        self.bits(octets.len, constants.stored_len_bits);
        self.bits(~@as(u16, @intCast(octets.len)), constants.stored_len_bits);
        for (octets) |octet| self.bits(octet, @bitSizeOf(u8));
    }

    pub fn fixed_literal(self: *Stream, symbol: u16) void {
        self.code(fixed_literal_codes[symbol], constants.fixed_literal_length_lengths[symbol]);
    }

    /// A length/distance pair in the fixed codes (RFC 1951 §3.2.5, §3.2.6).
    pub fn fixed_pair(self: *Stream, len: u16, distance: u16) void {
        const length_index = last_at_most(&constants.length_base, len);
        self.fixed_literal(constants.first_length_symbol + @as(u16, @intCast(length_index)));
        self.bits(len - constants.length_base[length_index], constants.length_extra_bits[length_index]);
        const distance_index = last_at_most(&constants.distance_base, distance);
        self.code(@intCast(distance_index), constants.fixed_distance_lengths[distance_index]);
        self.bits(distance - constants.distance_base[distance_index], constants.distance_extra_bits[distance_index]);
    }
};

/// The index of the last entry of an ascending table at most `value`.
pub fn last_at_most(table: []const u16, value: u16) usize {
    var found: usize = 0;
    for (table, 0..) |entry, index| {
        if (entry <= value) found = index;
    }
    return found;
}

/// The codes RFC 1951 §3.2.2's algorithm assigns to the lengths.
pub fn assign_codes(comptime len: usize, lengths: [len]u8) [len]u16 {
    var counts: [constants.code_len_max + 1]u16 = @splat(0);
    for (lengths) |bit_len| counts[bit_len] += 1;
    counts[0] = 0;
    var next_code: [constants.code_len_max + 1]u16 = @splat(0);
    var code: u16 = 0;
    for (1..constants.code_len_max + 1) |bits| {
        code = (code + counts[bits - 1]) << 1;
        next_code[bits] = code;
    }
    var codes: [len]u16 = @splat(0);
    for (lengths, 0..) |bit_len, symbol| {
        if (bit_len == 0) continue;
        codes[symbol] = next_code[bit_len];
        next_code[bit_len] += 1;
    }
    return codes;
}

const fixed_literal_codes = assign_codes(constants.literal_length_alphabet_len, constants.fixed_literal_length_lengths);

/// The fewest codes a complete code holds: two of one bit (RFC 1951 §3.2.2).
pub const complete_codes_min = 2;

/// Gives `lengths` a complete code of `codes` codes, none longer than `len_max` bits, drawn from
/// `generator`: a code of no bits, split in two a length longer until `codes` exist or none can
/// split, and given to the symbols in an order the generator draws (RFC 1951 §3.2.2). A symbol
/// without a code gets 0.
pub fn draw_complete_code(generator: *codec.split.Generator, lengths: []u8, codes: usize, len_max: u8) void {
    std.debug.assert(codes >= complete_codes_min and codes <= lengths.len);
    var lens: [constants.literal_length_alphabet_len]u8 = @splat(0);
    lens[0] = 1;
    lens[1] = 1;
    var count: usize = complete_codes_min;
    // Each round splits a code or finds none to split.
    for (0..lengths.len) |_| {
        if (count == codes) break;
        const from: usize = @intCast(generator.below(count));
        const picked = for (0..count) |offset| {
            const index = (from + offset) % count;
            if (lens[index] < len_max) break index;
        } else break;
        lens[picked] += 1;
        lens[count] = lens[picked];
        count += 1;
    }
    @memset(lengths, 0);
    var symbols: [constants.literal_length_alphabet_len]u16 = undefined;
    for (symbols[0..lengths.len], 0..) |*symbol, index| symbol.* = @intCast(index);
    for (0..count) |index| {
        const other = index + @as(usize, @intCast(generator.below(lengths.len - index)));
        std.mem.swap(u16, &symbols[index], &symbols[other]);
        lengths[symbols[index]] = lens[index];
    }
}
