//! A canonical Huffman code, built from the code lengths a block gives (RFC 1951 §3.2.2), and
//! decoded one bit at a time: the checked path's decoder (decision 16).
//!
//! RFC 1951 §3.2.2 gives each length's codes consecutive values, shorter codes first, so the codes
//! of length n are the `counts[n]` values that follow the last code of length n - 1, doubled. A
//! decoder reads a code's bits most significant first and, after each bit, asks whether the value
//! so far falls among the codes of the length read so far. `symbols` lists the symbols in code
//! order, so the matching code's place among its length's codes names its symbol.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// How a set of code lengths fails to form a code the decoder accepts.
pub const BuildError = error{
    /// More codes of some length than the lengths before them leave room for (RFC 1951 §3.2.2).
    OverSubscribedCode,
    /// Codes that leave values unused, which decision 15 refuses but for the distance code's two
    /// cases RFC 1951 §3.2.7 describes.
    IncompleteCode,
};

/// Which incomplete codes a build accepts.
pub const Completeness = enum {
    /// Every code must be complete.
    complete,
    /// A distance code may also be empty, when the block holds literals alone, or a single code
    /// of one bit (RFC 1951 §3.2.7).
    distance,
};

/// What a decode found in the bits it was given.
pub const Decoded = union(enum) {
    /// A symbol, and the length of its code in bits.
    symbol: struct { value: u16, len: u7 },
    /// The bits end before a code does.
    needs_bits,
    /// The bits match no code: an unused value of an incomplete code.
    invalid,
};

/// The number of codes of each length, 1 to 15; `counts[0]` is unused.
const Counts = [constants.code_len_max + 1]u16;

pub fn Code(comptime alphabet_len: usize) type {
    return struct {
        const Self = @This();

        counts: Counts,
        /// The symbols with a code, in code order: by length, then by symbol.
        symbols: [alphabet_len]u16,

        /// The code the lengths define, one length per symbol, 0 for a symbol with no code.
        pub fn build(self: *Self, lengths: []const u8, completeness: Completeness) BuildError!void {
            assert(lengths.len <= alphabet_len);
            return build_code(&self.counts, &self.symbols, lengths, completeness);
        }

        /// The symbol whose code starts `bits`, least significant bit first, of which `available`
        /// are present.
        pub fn decode(self: *const Self, bits: u64, available: u7) Decoded {
            return decode_code(&self.counts, &self.symbols, bits, available);
        }
    };
}

fn build_code(counts: *Counts, symbols: []u16, lengths: []const u8, completeness: Completeness) BuildError!void {
    counts.* = @splat(0);
    for (lengths) |len| {
        assert(len <= constants.code_len_max);
        counts[len] += 1;
    }
    counts[0] = 0;
    // The values left unused after each length: one value of no bits, doubled per bit.
    var left: i32 = 1;
    for (counts[1..]) |count| {
        left = (left << 1) - count;
        // RFC 1951 §3.2.2: more codes of a length than the shorter codes leave values for form no
        // prefix code.
        if (left < 0) return error.OverSubscribedCode;
    }
    // RFC 1951 §3.2.7 describes the only incomplete codes decision 15 accepts.
    if (left > 0 and !accepts_incomplete(counts.*, completeness)) return error.IncompleteCode;
    place_symbols(counts.*, symbols, lengths);
}

fn accepts_incomplete(counts: Counts, completeness: Completeness) bool {
    if (completeness != .distance) return false;
    var total: u32 = 0;
    for (counts[1..]) |count| total += count;
    return total == 0 or (total == 1 and counts[1] == 1);
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

fn decode_code(counts: *const Counts, symbols: []const u16, bits: u64, available: u7) Decoded {
    var code: i32 = 0; // The bits read so far, first bit most significant.
    var first: i32 = 0; // The first code of the length read so far.
    var index: i32 = 0; // The place of that length's first code in `symbols`.
    for (1..constants.code_len_max + 1) |len| {
        if (len > available) return .needs_bits;
        code |= @intCast((bits >> @intCast(len - 1)) & 1);
        const count: i32 = counts[len];
        if (code - first < count) {
            return .{ .symbol = .{ .value = symbols[@intCast(index + code - first)], .len = @intCast(len) } };
        }
        index += count;
        first = (first + count) << 1;
        code <<= 1;
    }
    return .invalid;
}

/// The fixed codes of RFC 1951 §3.2.6, built once at comptime.
pub const fixed_literal_length: Code(constants.literal_length_alphabet_len) = fixed: {
    @setEvalBranchQuota(fixed_build_quota);
    var code: Code(constants.literal_length_alphabet_len) = undefined;
    code.build(&constants.fixed_literal_length_lengths, .complete) catch unreachable;
    break :fixed code;
};
pub const fixed_distance: Code(constants.distance_alphabet_len) = fixed: {
    @setEvalBranchQuota(fixed_build_quota);
    var code: Code(constants.distance_alphabet_len) = undefined;
    code.build(&constants.fixed_distance_lengths, .complete) catch unreachable;
    break :fixed code;
};

/// The comptime branches building a fixed code takes: a few per symbol.
const fixed_build_quota = 10_000;

// Tests.

const testing = std.testing;

/// The bits of `code`, `len` bits long, as a decoder reads them: first bit most significant, packed
/// least significant bit first (RFC 1951 §3.1.1).
fn packed_code(code: u16, len: u4) u64 {
    return @bitReverse(code) >> @intCast(@bitSizeOf(u16) - @as(u5, len));
}

test "RFC 1951 section 3.2.2's example: lengths (3, 3, 3, 3, 3, 2, 4, 4)" {
    var code: Code(8) = undefined;
    try code.build(&.{ 3, 3, 3, 3, 3, 2, 4, 4 }, .complete);
    // The codes the RFC lists: A 010, B 011, C 100, D 101, E 110, F 00, G 1110, H 1111.
    const expected = [_]struct { u16, u4 }{ .{ 0b010, 3 }, .{ 0b011, 3 }, .{ 0b100, 3 }, .{ 0b101, 3 }, .{ 0b110, 3 }, .{ 0b00, 2 }, .{ 0b1110, 4 }, .{ 0b1111, 4 } };
    for (expected, 0..) |pair, symbol| {
        const decoded = code.decode(packed_code(pair[0], pair[1]), 15);
        try testing.expectEqual(@as(u16, @intCast(symbol)), decoded.symbol.value);
        try testing.expectEqual(pair[1], decoded.symbol.len);
    }
}

test "the fixed literal/length code gives RFC 1951 section 3.2.6's codes" {
    const cases = [_]struct { u16, u16, u4 }{ .{ 0, 0b00110000, 8 }, .{ 143, 0b10111111, 8 }, .{ 144, 0b110010000, 9 }, .{ 255, 0b111111111, 9 }, .{ 256, 0, 7 }, .{ 279, 0b0010111, 7 }, .{ 280, 0b11000000, 8 }, .{ 287, 0b11000111, 8 } };
    for (cases) |case| {
        const decoded = fixed_literal_length.decode(packed_code(case[1], case[2]), 15);
        try testing.expectEqual(case[0], decoded.symbol.value);
        try testing.expectEqual(case[2], decoded.symbol.len);
    }
}

test "a code too short for its bits waits, and an unused value is invalid" {
    try testing.expectEqual(Decoded.needs_bits, fixed_literal_length.decode(packed_code(0b110010000, 9), 8));
    var code: Code(constants.distance_alphabet_len) = undefined;
    try code.build(&.{ 0, 1 }, .distance);
    try testing.expectEqual(@as(u16, 1), code.decode(0, 15).symbol.value);
    try testing.expectEqual(Decoded.invalid, code.decode(1, 15));
}

test "over-subscribed and incomplete codes are refused, but for RFC 1951 section 3.2.7's cases" {
    var code: Code(constants.distance_alphabet_len) = undefined;
    try testing.expectError(error.OverSubscribedCode, code.build(&.{ 1, 1, 1 }, .complete));
    try testing.expectError(error.IncompleteCode, code.build(&.{ 1, 2 }, .complete));
    try testing.expectError(error.IncompleteCode, code.build(&.{ 1, 0 }, .complete));
    try testing.expectError(error.IncompleteCode, code.build(&.{ 2, 0 }, .distance));
    try testing.expectError(error.IncompleteCode, code.build(&.{ 1, 2 }, .distance));
    try code.build(&.{ 0, 0, 0 }, .distance);
    try code.build(&.{ 0, 1, 0 }, .distance);
    try code.build(&.{ 1, 1 }, .complete);
}
