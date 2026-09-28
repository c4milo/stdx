//! Writes brotli streams bit by bit for the tests (RFC 7932 §1.5.1): fields least significant bit
//! first, prefix codes most significant bit first.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Category = @import("decoder_state.zig").Category;

/// The longest stream a test writes.
pub const capacity = 8192;

/// A meta-block's MLEN - 1 in 4 nibbles, the fewest MNIBBLES gives: MLEN up to 65536 (RFC 7932
/// §9.2); the MNIBBLES code 0 says 4.
const nibbles_code_four = 0;
const four_nibbles_bits = constants.nibbles_min * constants.nibble_bits;

/// A symbol of a complex code's code length code, and its repeat's extra bits.
pub const LengthSymbol = struct { symbol: u8, extra: u8 = 0 };

/// Octets after a stream, so that the fast path's input margin holds to the stream's end: a refill
/// reads 8 octets past the bits it takes.
pub const trailer = "octets after the stream.";

/// A skewed code: a complex code whose symbols `first` and the one after it take 15 bits, with
/// code lengths 1 to 14 for the symbols 0 to 13, zeros to `first`, then 15 twice (RFC 7932 §3.5).
/// Its code length code gives 4 bits to each of the lengths 1 to 15 and to the repeat of zeros, and
/// none to the length 0 or to the repeat of the previous length, in its order from HSKIP 0; the
/// zeros come in repeats that compound (`zero_repeats`).
const skewed_code_length_len = 4;
const long_code_lengths_of_lengths = lengths: {
    var lengths: [constants.code_length_alphabet_len]u8 = @splat(skewed_code_length_len);
    for (constants.code_length_code_order, 0..) |symbol, place| {
        if (symbol == 0 or symbol == constants.repeat_previous_symbol) lengths[place] = 0;
    }
    break :lengths lengths;
};
const skewed_len_max = constants.code_len_max - 1;

/// The two longest codes a skewed code ends with.
const longest_codes = 2;

/// The most repeats of zeros a skewed code takes. A repeat of zeros right after another makes the
/// count of zeros 8 * (count - 2) + 3 + its extra bits (RFC 7932 §3.5).
pub const zero_repeats_max = 4;

pub const Stream = struct {
    octets: [capacity]u8 = @splat(0),
    bit_len: usize = 0,

    /// An integer field of `bit_count` bits, least significant first.
    pub fn put(self: *Stream, value: u64, bit_count: u7) void {
        for (0..bit_count) |index| {
            const bit: u8 = @intCast((value >> @intCast(index)) & 1);
            self.octets[self.bit_len / @bitSizeOf(u8)] |= bit << @intCast(self.bit_len % @bitSizeOf(u8));
            self.bit_len += 1;
        }
    }

    /// A prefix code of `len` bits, most significant first.
    pub fn put_code(self: *Stream, code: u32, len: u5) void {
        for (0..len) |index| self.put((code >> @intCast(len - 1 - index)) & 1, 1);
    }

    /// The octets written, the last padded with zeros.
    pub fn written(self: *const Stream) []const u8 {
        return self.octets[0 .. std.math.divCeil(usize, self.bit_len, @bitSizeOf(u8)) catch unreachable];
    }

    /// WBITS 10: 1, then 000, then 010 (RFC 7932 §9.1), the smallest window, 1008 octets.
    pub fn window_bits_10(self: *Stream) void {
        self.put(1, 1);
        self.put(0, constants.window_bits_field_bits);
        self.put(constants.window_bits_min - constants.window_bits_long_base, constants.window_bits_field_bits);
    }

    /// An uncompressed meta-block of `octets` (RFC 7932 §9.2), from an octet boundary.
    pub fn uncompressed(self: *Stream, octets: []const u8) void {
        self.meta_block(false, @intCast(octets.len));
        // ISUNCOMPRESSED replaces the 0 `meta_block` wrote last.
        self.bit_len -= 1;
        self.put(1, 1);
        self.bit_len = std.mem.alignForward(usize, self.bit_len, @bitSizeOf(u8));
        @memcpy(self.octets[self.bit_len / @bitSizeOf(u8) ..][0..octets.len], octets);
        self.bit_len += octets.len * @bitSizeOf(u8);
    }

    /// WBITS 16: one 0 bit (RFC 7932 §9.1).
    pub fn window_bits_16(self: *Stream) void {
        self.put(0, 1);
    }

    /// A meta-block header of MLEN `len`, up to 65536, in 4 nibbles (RFC 7932 §9.2): ISLAST, a 0
    /// ISLASTEMPTY when last, MNIBBLES, MLEN - 1, and a 0 ISUNCOMPRESSED when not last.
    pub fn meta_block(self: *Stream, last: bool, len: u32) void {
        self.put(@intFromBool(last), 1);
        if (last) self.put(0, 1);
        self.put(nibbles_code_four, constants.nibbles_field_bits);
        self.put(len - 1, four_nibbles_bits);
        if (!last) self.put(0, 1);
    }

    /// The empty last meta-block that ends a stream: ISLAST and ISLASTEMPTY.
    pub fn end(self: *Stream) void {
        self.put((1 << constants.last_flags_bits) - 1, constants.last_flags_bits);
    }

    /// NBLTYPESx or NTREESx (RFC 7932 §9.2): a 0 bit for 1, otherwise n and n bits of the rest.
    pub fn count(self: *Stream, value: u16) void {
        assert(value >= 1);
        if (value == 1) return self.put(0, 1);
        const extra_bits = std.math.log2_int(u16, value - 1);
        self.put(1, 1);
        self.put(extra_bits, constants.count_field_bits);
        self.put(value - 1 - (@as(u16, 1) << extra_bits), extra_bits);
    }

    /// One block type in each category, NPOSTFIX, NDIRECT's four high bits, one context mode, and
    /// one tree in each context map: the header of the simplest compressed meta-block.
    pub fn simple_header(self: *Stream, postfix_bits: u2, direct_high: u4, mode: u2) void {
        for (0..@typeInfo(Category).@"enum".fields.len) |_| self.count(1);
        self.put(postfix_bits, constants.postfix_field_bits);
        self.put(direct_high, constants.direct_field_bits);
        self.put(mode, constants.context_mode_bits);
        self.count(1);
        self.count(1);
    }

    /// A simple prefix code (RFC 7932 §3.4) over `alphabet_len` symbols.
    pub fn simple_code(self: *Stream, alphabet_len: u16, symbols: []const u16, tree_select: bool) void {
        self.put(constants.prefix_kind_simple, constants.prefix_kind_bits);
        self.put(symbols.len - 1, constants.simple_count_bits);
        const bits = std.math.log2_int_ceil(u16, alphabet_len);
        for (symbols) |symbol| self.put(symbol, bits);
        if (symbols.len == constants.simple_symbols_max) self.put(@intFromBool(tree_select), 1);
    }

    /// A complex prefix code (RFC 7932 §3.5): HSKIP, the lengths of the code length code in the
    /// RFC's order from HSKIP, then the code length symbols in the canonical code those lengths give.
    pub fn complex_code(self: *Stream, skip: u2, code_length_lengths: []const u8, symbols: []const LengthSymbol) void {
        self.put(skip, constants.prefix_kind_bits);
        var lengths: [constants.code_length_alphabet_len]u8 = @splat(0);
        for (code_length_lengths, skip..) |len, place| {
            const fixed = constants.code_length_code_length_codes[len];
            self.put(fixed.code, fixed.len);
            lengths[constants.code_length_code_order[place]] = len;
        }
        for (symbols) |symbol| {
            const code = canonical(&lengths, symbol.symbol);
            self.put_code(code.code, code.len);
            if (symbol.symbol == constants.repeat_previous_symbol) self.put(symbol.extra, constants.repeat_previous_extra_bits);
            if (symbol.symbol == constants.repeat_zero_symbol) self.put(symbol.extra, constants.repeat_zero_extra_bits);
        }
    }

    /// The code length symbols of a skewed code, the zeros in `repeats`.
    pub fn skewed_code(self: *Stream, repeats: []const LengthSymbol) void {
        var symbols: [skewed_len_max + zero_repeats_max + longest_codes]LengthSymbol = undefined;
        for (symbols[0..skewed_len_max], 1..) |*symbol, len| symbol.* = .{ .symbol = @intCast(len) };
        @memcpy(symbols[skewed_len_max..][0..repeats.len], repeats);
        const tail = skewed_len_max + repeats.len;
        symbols[tail] = .{ .symbol = constants.code_len_max };
        symbols[tail + 1] = .{ .symbol = constants.code_len_max };
        self.complex_code(0, &long_code_lengths_of_lengths, symbols[0 .. tail + longest_codes]);
    }
};

/// The code RFC 7932 §3.2's algorithm gives `symbol` from `lengths`.
pub fn canonical(lengths: []const u8, symbol: usize) struct { code: u32, len: u5 } {
    var counts: [constants.code_len_max + 1]u32 = @splat(0);
    for (lengths) |len| counts[len] += 1;
    counts[0] = 0;
    var next: [constants.code_len_max + 1]u32 = @splat(0);
    var code: u32 = 0;
    for (1..constants.code_len_max + 1) |bits| {
        code = (code + counts[bits - 1]) << 1;
        next[bits] = code;
    }
    for (lengths[0..symbol]) |len| {
        if (len != 0) next[len] += 1;
    }
    assert(lengths[symbol] != 0);
    return .{ .code = next[lengths[symbol]], .len = @intCast(lengths[symbol]) };
}

/// The code lengths of a skewed code: symbols of lengths 1 to 14, then zeros, then the two longest
/// codes, at `first` and the symbol after it.
pub fn skewed_lengths(lengths: []u8, first: usize) void {
    @memset(lengths, 0);
    for (lengths[0..skewed_len_max], 1..) |*len, value| len.* = @intCast(value);
    lengths[first] = constants.code_len_max;
    lengths[first + 1] = constants.code_len_max;
}

/// The repeats of zeros whose extra bits are `extras`, in `repeats`.
pub fn zero_repeats(extras: []const u8, repeats: *[zero_repeats_max]LengthSymbol) []const LengthSymbol {
    for (extras, 0..) |extra, index| repeats[index] = .{ .symbol = constants.repeat_zero_symbol, .extra = extra };
    return repeats[0..extras.len];
}
