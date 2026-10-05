//! A canonical Huffman code, built from the code lengths a block gives (RFC 1951 §3.2.2), and
//! decoded one bit at a time: the checked path's decoder (decision 16).
//!
//! RFC 1951 §3.2.2 gives each length's codes consecutive values, shorter codes first, so the codes
//! of length n are the `counts[n]` values that follow the last code of length n - 1, doubled. A
//! decoder reads a code's bits most significant first and, after each bit, asks whether the value
//! so far falls among the codes of the length read so far. `symbols` lists the symbols in code
//! order, so the matching code's place among its length's codes names its symbol.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// Invariant 17's count, which test builds alone keep: every build adds the table entries it
/// touches, at most `constants.build_work_max`. In any other build the count has no size.
pub const Work = if (builtin.is_test) u64 else void;

/// A count that starts at zero.
pub const work_zero: Work = if (builtin.is_test) 0 else {};

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
pub const Counts = [constants.code_len_max + 1]u16;

/// What the read of a dynamic block's code lengths counts and lists for the builds of its two
/// codes (decision 14, S14), so that neither build passes over the lengths again: the codes of
/// each length in each alphabet, and the place of each length that is not zero.
pub const Tally = struct {
    /// The lengths of each value among the literal/length symbols, then among the distance
    /// symbols. The slot of a length of zero counts nothing a build reads.
    counts: [alphabets]Counts,
    /// Each length that is not zero, with its place among the header's lengths, in the order
    /// read: the literal/length symbols' first. A repeat lists its most places in one go, so the
    /// list holds that many past the lengths' last.
    coded: [constants.header_lengths_max + constants.repeat_previous_count_max]Listed,
    coded_len: u16,

    /// One length that is not zero, and its place among the header's lengths.
    pub const Listed = packed struct(u16) {
        place: Place,
        len: Len,
    };
    pub const Place = u12;
    pub const Len = u4;

    comptime {
        assert(constants.header_lengths_max + constants.repeat_previous_count_max <= std.math.maxInt(Place));
        assert(constants.code_len_max <= std.math.maxInt(Len));
    }

    /// The literal/length alphabet and the distance alphabet.
    pub const alphabets = 2;

    /// Empties the tally, for a new block's header.
    pub fn reset(self: *Tally) void {
        self.counts = @splat(@splat(0));
        self.coded_len = 0;
    }

    /// The alphabet a place belongs to, as an index into `counts`: the literal/length alphabet
    /// takes the header's first `literal_length_count` lengths (RFC 1951 §3.2.7).
    pub inline fn alphabet(place: usize, literal_length_count: usize) u1 {
        return @intFromBool(place >= literal_length_count);
    }

    /// The lengths the tally lists, by alphabet: the literal/length alphabet's come first, as
    /// many as its counts sum to.
    pub fn listed(self: *const Tally) [alphabets][]const Listed {
        var literal_length_codes: usize = 0;
        for (self.counts[0][1..]) |count| literal_length_codes += count;
        assert(literal_length_codes <= self.coded_len);
        return .{ self.coded[0..literal_length_codes], self.coded[literal_length_codes..self.coded_len] };
    }

    /// Counts and lists `count` lengths of `len` from place `at`, a length at a time: the checked
    /// steps' form.
    pub fn add(self: *Tally, at: usize, count: usize, len: u8, literal_length_count: usize) void {
        assert(len <= constants.code_len_max);
        assert(at + count <= constants.header_lengths_max);
        if (len == 0) return;
        for (at..at + count) |place| {
            self.counts[alphabet(place, literal_length_count)][len] += 1;
            self.coded[self.coded_len] = .{ .place = @intCast(place), .len = @intCast(len) };
            self.coded_len += 1;
        }
    }
};

pub fn Code(comptime alphabet_len: usize) type {
    return struct {
        const Self = @This();

        counts: Counts,
        /// The number of symbols with a code.
        code_count: u16,
        /// The symbols with a code, in code order: by length, then by symbol.
        symbols: [alphabet_len]u16,

        /// The code the lengths define, one length per symbol, 0 for a symbol with no code. The
        /// build adds its table entries to `work`.
        pub fn build(self: *Self, lengths: []const u8, completeness: Completeness, work: *Work) BuildError!void {
            assert(lengths.len <= alphabet_len);
            if (builtin.is_test) work.* += constants.build_work_max(lengths.len);
            try build_code(&self.counts, &self.symbols, lengths, completeness);
            self.code_count = 0;
            for (self.counts[1..]) |count| self.code_count += count;
        }

        /// As `build` over `lengths_len` lengths, from what the read of them tallied: the `counts`
        /// of each length, and the `coded` lengths that are not zero with their places,
        /// ascending, where `base` is the place of the alphabet's first symbol. It passes over
        /// the symbols with a code alone. Invariant 17 counts it as `build`: the tally of a
        /// length stands for the build's two reads of it, and the tally's clear for the counts'.
        pub fn build_tallied(self: *Self, lengths_len: usize, counts: *const Counts, coded: []const Tally.Listed, base: u16, completeness: Completeness, work: *Work) BuildError!void {
            assert(lengths_len <= alphabet_len and coded.len <= lengths_len);
            if (builtin.is_test) work.* += constants.build_work_max(lengths_len);
            self.counts = counts.*;
            self.counts[0] = 0;
            try check_counts(&self.counts, completeness);
            place_coded(&self.counts, &self.symbols, coded, base);
            self.code_count = @intCast(coded.len);
        }

        /// The symbol whose code starts `bits`, least significant bit first, of which `available`
        /// are present.
        pub fn decode(self: *const Self, bits: u64, available: u7) Decoded {
            return decode_code(&self.counts, &self.symbols, self.code_count, bits, available);
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
    try check_counts(counts, completeness);
    place_symbols(counts.*, symbols, lengths);
}

/// Whether the codes `counts` gives each length form a code the decoder accepts.
fn check_counts(counts: *const Counts, completeness: Completeness) BuildError!void {
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
}

/// Lists the symbols in code order, as `place_symbols` does, from the `coded` lengths of those
/// that have a code: `base` is the place of the alphabet's first symbol.
fn place_coded(counts: *const Counts, symbols: []u16, coded: []const Tally.Listed, base: u16) void {
    var offsets: Counts = undefined;
    offsets[0] = 0;
    offsets[1] = 0;
    for (1..constants.code_len_max) |len| offsets[len + 1] = offsets[len] + counts[len];
    for (coded) |listed| {
        assert(listed.len != 0 and listed.place >= base);
        // A length's type holds every index of `offsets` and no other. The sums stay within the
        // alphabet, which the counts' check bounds, so neither wraps.
        const slot = &offsets[listed.len];
        symbols[slot.*] = listed.place - base;
        slot.* +%= 1;
    }
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

fn decode_code(counts: *const Counts, symbols: []const u16, code_count: u16, bits: u64, available: u7) Decoded {
    var code: i32 = 0; // The bits read so far, first bit most significant.
    var first: i32 = 0; // The first code of the length read so far.
    var index: i32 = 0; // The place of that length's first code in `symbols`.
    for (1..constants.code_len_max + 1) |len| {
        // No code is this long, so the bits read so far match none, whatever bits follow: an
        // unused value of an incomplete code is known as soon as its bits are.
        if (index == code_count) return .invalid;
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
    var work = work_zero;
    code.build(&constants.fixed_literal_length_lengths, .complete, &work) catch unreachable;
    break :fixed code;
};
pub const fixed_distance: Code(constants.distance_alphabet_len) = fixed: {
    @setEvalBranchQuota(fixed_build_quota);
    var code: Code(constants.distance_alphabet_len) = undefined;
    var work = work_zero;
    code.build(&constants.fixed_distance_lengths, .complete, &work) catch unreachable;
    break :fixed code;
};

/// The comptime branches building a fixed code takes: a few per symbol.
const fixed_build_quota = 10_000;

// Tests.

const testing = std.testing;
const codec = @import("codec");
const test_stream = @import("test_stream.zig");

/// The bits of `code`, `len` bits long, as a decoder reads them: first bit most significant, packed
/// least significant bit first (RFC 1951 §3.1.1).
fn packed_code(code: u16, len: u4) u64 {
    return @bitReverse(code) >> @intCast(@bitSizeOf(u16) - @as(u5, len));
}

test "RFC 1951 section 3.2.2's example: lengths (3, 3, 3, 3, 3, 2, 4, 4)" {
    var work: Work = 0;
    var code: Code(8) = undefined;
    try code.build(&.{ 3, 3, 3, 3, 3, 2, 4, 4 }, .complete, &work);
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
    var work: Work = 0;
    try testing.expectEqual(Decoded.needs_bits, fixed_literal_length.decode(packed_code(0b110010000, 9), 8));
    var code: Code(constants.distance_alphabet_len) = undefined;
    try code.build(&.{ 0, 1 }, .distance, &work);
    try testing.expectEqual(@as(u16, 1), code.decode(0, 15).symbol.value);
    try testing.expectEqual(Decoded.invalid, code.decode(1, 15));
}

test "an unused value is invalid as soon as its bits are read, not after the longest code's" {
    var work: Work = 0;
    var code: Code(constants.distance_alphabet_len) = undefined;
    try code.build(&.{ 0, 0 }, .distance, &work);
    try testing.expectEqual(Decoded.invalid, code.decode(0, 0));
    try code.build(&.{ 0, 1 }, .distance, &work);
    try testing.expectEqual(Decoded.invalid, code.decode(1, 1));
    try testing.expectEqual(Decoded.needs_bits, code.decode(0, 0));
}

test "over-subscribed and incomplete codes are refused, but for RFC 1951 section 3.2.7's cases" {
    var work: Work = 0;
    var code: Code(constants.distance_alphabet_len) = undefined;
    try testing.expectError(error.OverSubscribedCode, code.build(&.{ 1, 1, 1 }, .complete, &work));
    try testing.expectError(error.IncompleteCode, code.build(&.{ 1, 2 }, .complete, &work));
    try testing.expectError(error.IncompleteCode, code.build(&.{ 1, 0 }, .complete, &work));
    try testing.expectError(error.IncompleteCode, code.build(&.{ 2, 0 }, .distance, &work));
    try testing.expectError(error.IncompleteCode, code.build(&.{ 1, 2 }, .distance, &work));
    try code.build(&.{ 0, 0, 0 }, .distance, &work);
    try code.build(&.{ 0, 1, 0 }, .distance, &work);
    try code.build(&.{ 1, 1 }, .complete, &work);
}

/// The seeds the tally's test draws its lengths from.
const tally_seeds = 600;

/// What the tally and each code hold in every octet before the test writes them: a build that
/// reads what none wrote gives what the other does not.
const tally_fill = 0xa5;
const scanned_fill = 0x5a;
const tallied_fill = 0x33;

/// The kinds of lengths the tally's test draws for an alphabet, each as likely: no code or one;
/// lengths at random; and, twice, a complete code.
const length_kinds = 4;

/// Of the draws of no code or one, how many there are of each: one.
const none_or_one = 2;

/// Lengths for an alphabet, drawn from `generator`: no code or one of one bit, lengths at random,
/// which seldom form a code the decoder accepts, or a complete code.
fn draw_lengths(generator: *codec.split.Generator, lengths: []u8) void {
    @memset(lengths, 0);
    switch (generator.below(length_kinds)) {
        0 => if (generator.below(none_or_one) == 0) {
            lengths[@intCast(generator.below(lengths.len))] = 1;
        },
        1 => for (lengths) |*len| {
            len.* = @intCast(generator.below(constants.code_len_max + 1));
        },
        else => if (lengths.len >= test_stream.complete_codes_min) {
            const codes: usize = @intCast(generator.between(test_stream.complete_codes_min, lengths.len));
            test_stream.draw_complete_code(generator, lengths, codes, constants.code_len_max);
        },
    }
}

/// Requires a build from the tally's `counts` and `coded` to end as a build from `lengths` does,
/// with the same count of work, and to leave the same code.
fn expect_tallied(comptime alphabet_len: usize, lengths: []const u8, counts: *const Counts, coded: []const Tally.Listed, base: u16, completeness: Completeness) !void {
    var scanned: Code(alphabet_len) = undefined;
    var tallied: Code(alphabet_len) = undefined;
    @memset(std.mem.asBytes(&scanned), scanned_fill);
    @memset(std.mem.asBytes(&tallied), tallied_fill);
    var scanned_work: Work = 0;
    var tallied_work: Work = 0;
    const scanned_result = scanned.build(lengths, completeness, &scanned_work);
    try testing.expectEqual(scanned_result, tallied.build_tallied(lengths.len, counts, coded, base, completeness, &tallied_work));
    try testing.expectEqual(scanned_work, tallied_work);
    scanned_result catch return;
    try testing.expectEqualSlices(u16, &scanned.counts, &tallied.counts);
    try testing.expectEqual(scanned.code_count, tallied.code_count);
    try testing.expectEqualSlices(u16, scanned.symbols[0..scanned.code_count], tallied.symbols[0..tallied.code_count]);
}

test "a code built from a tally of its lengths is the code built from the lengths (decision 14, S14)" {
    var accepted: usize = 0;
    for (0..tally_seeds) |seed| {
        var generator = codec.split.Generator.init(seed);
        const literal_length_count: u16 = @intCast(generator.between(constants.hlit_base, constants.literal_length_used));
        const distance_count: u16 = @intCast(generator.between(constants.hdist_base, constants.distance_alphabet_len));
        var lengths: [constants.header_lengths_max]u8 = undefined;
        const literal_lengths = lengths[0..literal_length_count];
        const distance_lengths = lengths[literal_length_count..][0..distance_count];
        draw_lengths(&generator, literal_lengths);
        draw_lengths(&generator, distance_lengths);
        // The tally takes the lengths in runs of one value, as a header's symbols give them, which
        // may run from one alphabet into the other (RFC 1951 §3.2.7).
        var tally: Tally = undefined;
        @memset(std.mem.asBytes(&tally), tally_fill);
        tally.reset();
        const total = literal_length_count + distance_count;
        var at: usize = 0;
        for (0..total) |_| {
            if (at == total) break;
            const same = std.mem.indexOfNone(u8, lengths[at..total], &.{lengths[at]}) orelse total - at;
            const count: usize = @intCast(generator.between(1, @min(same, constants.repeat_previous_count_max)));
            tally.add(at, count, lengths[at], literal_length_count);
            at += count;
        }
        const listed = tally.listed();
        try expect_tallied(constants.literal_length_alphabet_len, literal_lengths, &tally.counts[0], listed[0], 0, .complete);
        try expect_tallied(constants.distance_alphabet_len, distance_lengths, &tally.counts[1], listed[1], literal_length_count, .distance);
        var work: Work = 0;
        var code: Code(constants.literal_length_alphabet_len) = undefined;
        if (code.build(literal_lengths, .complete, &work)) |_| {
            accepted += 1;
        } else |_| {}
    }
    // The seeds draw both kinds of lengths: those that form a code, and those refused.
    try testing.expect(accepted > tally_seeds / 4 and accepted < tally_seeds - tally_seeds / 4);
}
