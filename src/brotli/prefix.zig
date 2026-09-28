//! brotli's prefix codes (RFC 7932 §3): canonical codes built from code lengths (§3.2) and decoded
//! one bit at a time, the checked path's decoder (decision 16), and the fixed code §3.5 gives the
//! lengths of the code length code.
//!
//! RFC 7932 §3.2 gives each length's codes consecutive values, shorter codes first, as RFC 1951
//! does. A decoder reads a code's bits most significant first (§1.5.1) and, after each bit, asks
//! whether the value so far falls among the codes of the length read so far. `symbols` lists the
//! symbols in code order, so the matching code's place among its length's codes names its symbol.
//!
//! Every code a stream may define is complete, or has one symbol whose code takes no bits (§3.4,
//! §3.5): the decoder's reader checks the lengths against the RFC's sums before it builds a code,
//! so a build only asserts, and a decode always finds a symbol once it has the bits.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// The number of codes of each length, 1 to 15; `counts[0]` is unused.
const Counts = [constants.code_len_max + 1]u16;

/// What a decode found in the bits it was given.
pub const Decoded = union(enum) {
    /// A symbol, and the length of its code in bits: 0 for a code of one symbol.
    symbol: struct { value: u16, len: u7 },
    /// The bits end before a code does.
    needs_bits,
};

pub fn Code(comptime alphabet_len: usize) type {
    return struct {
        const Self = @This();

        counts: Counts,
        /// The number of symbols with a code: 1 for a code whose one symbol takes no bits.
        code_count: u16,
        /// The symbols with a code, in code order: by length, then by symbol.
        symbols: [alphabet_len]u16,

        /// The code of one symbol, which takes no bits (RFC 7932 §3.4, NSYM = 1; §3.5).
        pub fn build_single(self: *Self, symbol: u16) void {
            assert(symbol < alphabet_len);
            self.counts = @splat(0);
            self.code_count = 1;
            self.symbols[0] = symbol;
        }

        /// The canonical code the lengths define, one per symbol, 0 for a symbol with no code (RFC
        /// 7932 §3.2). The caller has checked that they form a complete code of two symbols or more.
        pub fn build(self: *Self, lengths: []const u8) void {
            assert(lengths.len <= alphabet_len);
            self.counts = @splat(0);
            for (lengths) |len| {
                assert(len <= constants.code_len_max);
                self.counts[len] += 1;
            }
            self.counts[0] = 0;
            assert(is_complete(self.counts));
            self.code_count = 0;
            for (self.counts[1..]) |count| self.code_count += count;
            assert(self.code_count >= constants.code_symbols_min);
            place_symbols(self.counts, &self.symbols, lengths);
        }

        /// The symbol whose code starts `bits`, least significant bit first, of which `available`
        /// are present.
        pub fn decode(self: *const Self, bits: u64, available: u7) Decoded {
            if (self.code_count == 1) return .{ .symbol = .{ .value = self.symbols[0], .len = 0 } };
            var code: u32 = 0; // The bits read so far, first bit most significant.
            var first: u32 = 0; // The first code of the length read so far.
            var index: u32 = 0; // The place of that length's first code in `symbols`.
            for (1..constants.code_len_max + 1) |len| {
                if (len > available) return .needs_bits;
                code |= @intCast((bits >> @intCast(len - 1)) & 1);
                const count: u32 = self.counts[len];
                if (code - first < count) {
                    return .{ .symbol = .{ .value = self.symbols[index + code - first], .len = @intCast(len) } };
                }
                index += count;
                first = (first + count) << 1;
                code <<= 1;
            }
            // A complete code has a symbol for every value of `code_len_max` bits.
            unreachable;
        }
    };
}

/// Whether the counts leave no value unused: each length's codes take their share of the values of
/// `code_len_max` bits, and the shares sum to all of them.
fn is_complete(counts: Counts) bool {
    var used: u32 = 0;
    for (counts[1..], 1..) |count, len| used += @as(u32, count) << @intCast(constants.code_len_max - len);
    return used == 1 << constants.code_len_max;
}

/// Lists the symbols in code order.
fn place_symbols(counts: Counts, symbols: []u16, lengths: []const u8) void {
    var offsets: Counts = undefined;
    offsets[1] = 0;
    for (1..constants.code_len_max) |len| offsets[len + 1] = offsets[len] + counts[len];
    for (lengths, 0..) |len, symbol| {
        if (len == 0) continue;
        symbols[offsets[len]] = @intCast(symbol);
        offsets[len] += 1;
    }
}

/// A code length of the code length code, and the bits its fixed code takes (RFC 7932 §3.5).
pub const CodeLengthCodeLength = struct { value: u8, len: u7 };

/// The code length the fixed code of RFC 7932 §3.5 gives the bits, least significant first, or null
/// when fewer than its code's bits are present. The code is a prefix code, so at most one of its
/// codes matches the bits present.
pub fn decode_code_length_code_length(bits: u64, available: u7) ?CodeLengthCodeLength {
    for (constants.code_length_code_length_codes, 0..) |code, value| {
        if (code.len > available) continue;
        if (bits & ((@as(u64, 1) << code.len) - 1) == code.code) return .{ .value = @intCast(value), .len = code.len };
    }
    return null;
}

// Tests.

const testing = std.testing;

/// The bits of a code as a stream holds them: its first bit, the most significant, in bit 0.
fn stream_bits(code: u32, len: u5) u64 {
    var bits: u64 = 0;
    for (0..len) |index| bits |= @as(u64, (code >> @intCast(len - 1 - index)) & 1) << @intCast(index);
    return bits;
}

test "RFC 7932 §3.2's example: lengths (3, 3, 3, 3, 3, 2, 4, 4) give the codes it lists" {
    var code: Code(8) = undefined;
    code.build(&.{ 3, 3, 3, 3, 3, 2, 4, 4 });
    // A 010, B 011, C 100, D 101, E 110, F 00, G 1110, H 1111.
    const codes = [_]struct { u32, u5 }{ .{ 0b010, 3 }, .{ 0b011, 3 }, .{ 0b100, 3 }, .{ 0b101, 3 }, .{ 0b110, 3 }, .{ 0b00, 2 }, .{ 0b1110, 4 }, .{ 0b1111, 4 } };
    for (codes, 0..) |expected, symbol| {
        const decoded = code.decode(stream_bits(expected[0], expected[1]), expected[1]);
        try testing.expectEqual(symbol, decoded.symbol.value);
        try testing.expectEqual(expected[1], decoded.symbol.len);
    }
}

test "a decode that lacks its code's bits asks for more" {
    var code: Code(8) = undefined;
    code.build(&.{ 3, 3, 3, 3, 3, 2, 4, 4 });
    try testing.expectEqual(.needs_bits, std.meta.activeTag(code.decode(stream_bits(0b1110, 4), 3)));
    try testing.expectEqual(.needs_bits, std.meta.activeTag(code.decode(0, 1)));
}

test "a code of one symbol takes no bits" {
    var code: Code(704) = undefined;
    code.build_single(703);
    const decoded = code.decode(0, 0);
    try testing.expectEqual(703, decoded.symbol.value);
    try testing.expectEqual(0, decoded.symbol.len);
}

test "the fixed code of the code length code's lengths" {
    const codes = [_]struct { u32, u5 }{ .{ 0b00, 2 }, .{ 0b0111, 4 }, .{ 0b011, 3 }, .{ 0b10, 2 }, .{ 0b01, 2 }, .{ 0b1111, 4 } };
    for (codes, 0..) |code, value| {
        // RFC 7932 §3.5 prints each code as it appears in the stream: its first bit rightmost.
        const decoded = decode_code_length_code_length(code[0], code[1]).?;
        try testing.expectEqual(value, decoded.value);
        try testing.expectEqual(code[1], decoded.len);
        if (code[1] > 2) try testing.expectEqual(null, decode_code_length_code_length(code[0], code[1] - 1));
    }
    try testing.expectEqual(null, decode_code_length_code_length(0, 1));
}
