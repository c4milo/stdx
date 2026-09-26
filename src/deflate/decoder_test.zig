//! Tests for the checked-path DEFLATE decoder. Streams are built here bit by bit, least significant
//! bit first with Huffman codes most significant bit first (RFC 1951 §3.1.1), with codes assigned
//! by RFC 1951 §3.2.2's algorithm. Each stream decodes in one call and under seeded splits that
//! move the state between calls (invariant 12), and each refusal names its RFC rule.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const deflate = @import("decoder.zig");
const Decoder = deflate.Decoder;

/// The most octets a test stream takes, and the most a test decodes into.
const stream_len_max = 1024;
const output_len_max = 4096;

/// The seeds each stream decodes under.
const split_seeds = 200;

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
fn last_at_most(table: []const u16, value: u16) usize {
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

fn fresh() Decoder {
    var decoder: Decoder = undefined;
    deflate.init(&decoder, .{});
    return decoder;
}

/// Decodes the whole stream in one call.
fn decode_whole(input: []const u8, output: []u8) deflate.Error!codec.Progress {
    var decoder = fresh();
    return deflate.decode(&decoder, input, output);
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) deflate.Error!codec.Progress {
    return deflate.decode(decoder, input, output);
}

/// Requires the stream to decode to `expected`, ending exactly at its last octet, in one call and
/// under every seed's split.
pub fn expect_decodes(input: []const u8, expected: []const u8) !void {
    var output: [output_len_max]u8 = undefined;
    const whole = try decode_whole(input, &output);
    try testing.expectEqual(codec.Status.done, whole.status);
    try testing.expectEqual(input.len, whole.consumed);
    try testing.expectEqualSlices(u8, expected, output[0..whole.written]);
    for (0..split_seeds) |seed| {
        var states: [codec.split.state_slots]Decoder = undefined;
        deflate.init(&states[0], .{});
        var split_output: [output_len_max]u8 = undefined;
        const outcome = try codec.split.drive(Decoder, &states, step, input, split_output[0..expected.len], seed);
        try testing.expectEqual(codec.Status.done, outcome.status);
        try testing.expectEqual(input.len, outcome.consumed);
        try testing.expectEqualSlices(u8, expected, split_output[0..outcome.written]);
    }
}

/// Requires the stream to be refused with `expected`, in one call and under every seed's split.
pub fn expect_refused(input: []const u8, expected: deflate.Error) !void {
    var output: [output_len_max]u8 = undefined;
    try testing.expectError(expected, decode_whole(input, &output));
    try testing.expectEqual(codec.Refusal.corrupt, deflate.refusal(expected));
    for (0..split_seeds) |seed| {
        var states: [codec.split.state_slots]Decoder = undefined;
        deflate.init(&states[0], .{});
        try testing.expectError(expected, codec.split.drive(Decoder, &states, step, input, &output, seed));
    }
}

test "stored blocks, empty and not, end where the stream ends" {
    var stream: Stream = .{};
    stream.stored(false, "");
    stream.stored(false, "hello, ");
    stream.stored(true, "world");
    try expect_decodes(stream.slice(), "hello, world");
}

test "fixed-code literals, and matches that overlap their own output" {
    var stream: Stream = .{};
    stream.block_header(true, .fixed);
    for ("abc") |octet| stream.fixed_literal(octet);
    stream.fixed_pair(6, 3);
    stream.fixed_literal('x');
    stream.fixed_pair(258, 1);
    stream.fixed_literal(constants.end_of_block);
    try expect_decodes(stream.slice(), "abcabcabcx" ++ "x" ** 258);
}

test "every length and distance code's extra bits, across block boundaries" {
    var stream: Stream = .{};
    var expected: [output_len_max]u8 = undefined;
    var expected_len: usize = 0;
    stream.block_header(false, .stored);
    stream.align_to_octet();
    const seed_len = 600;
    stream.bits(seed_len, constants.stored_len_bits);
    stream.bits(~@as(u16, seed_len), constants.stored_len_bits);
    for (0..seed_len) |index| {
        const octet: u8 = @truncate(index *% 37 +% (index >> 3));
        stream.bits(octet, @bitSizeOf(u8));
        expected[expected_len] = octet;
        expected_len += 1;
    }
    stream.block_header(true, .fixed);
    for ([_][2]u16{ .{ 3, 1 }, .{ 11, 5 }, .{ 20, 9 }, .{ 131, 33 }, .{ 257, 129 }, .{ 100, 513 }, .{ 50, 600 } }) |pair| {
        stream.fixed_pair(pair[0], pair[1]);
        for (0..pair[0]) |_| {
            expected[expected_len] = expected[expected_len - pair[1]];
            expected_len += 1;
        }
    }
    stream.fixed_literal(constants.end_of_block);
    try expect_decodes(stream.slice(), expected[0..expected_len]);
}

test "octets after the stream stay in the input, after a block read ahead of its end" {
    var stored: Stream = .{};
    stored.stored(true, "ab");
    var fixed: Stream = .{};
    fixed.block_header(true, .fixed);
    fixed.fixed_literal('a');
    fixed.fixed_literal(constants.end_of_block);
    for ([_][]const u8{ stored.slice(), fixed.slice() }) |stream| {
        var input: [64]u8 = undefined;
        @memcpy(input[0..stream.len], stream);
        @memset(input[stream.len..][0..16], 0xee);
        var output: [16]u8 = undefined;
        const progress = try decode_whole(input[0 .. stream.len + 16], &output);
        try testing.expectEqual(codec.Status.done, progress.status);
        try testing.expectEqual(stream.len, progress.consumed);
    }
}

test "a stream cut short asks for input and has taken all of it" {
    var stream: Stream = .{};
    stream.block_header(true, .fixed);
    for ("abcdef") |octet| stream.fixed_literal(octet);
    stream.fixed_literal(constants.end_of_block);
    const whole = stream.slice();
    for (0..whole.len) |cut| {
        var output: [16]u8 = undefined;
        const progress = try decode_whole(whole[0..cut], &output);
        try testing.expectEqual(codec.Status.needs_input, progress.status);
        try testing.expectEqual(cut, progress.consumed);
    }
}

test "RFC 1951 section 3.2.3: BTYPE 11 is refused" {
    var stream: Stream = .{};
    stream.block_header(true, .reserved);
    try expect_refused(stream.slice(), error.InvalidBlockType);
}

test "RFC 1951 section 3.2.4: NLEN not LEN's complement is refused" {
    var stream: Stream = .{};
    stream.block_header(true, .stored);
    stream.align_to_octet();
    stream.bits(5, constants.stored_len_bits);
    stream.bits(5, constants.stored_len_bits);
    try expect_refused(stream.slice(), error.StoredLengthMismatch);
}

test "RFC 1951 section 3.2.6: literal/length 286 and 287, and distances 30 and 31, are refused" {
    for ([_]u16{ 286, 287 }) |symbol| {
        var stream: Stream = .{};
        stream.block_header(true, .fixed);
        stream.fixed_literal('a');
        stream.fixed_literal(symbol);
        stream.bits(0, 32);
        try expect_refused(stream.slice(), error.InvalidLiteralLength);
    }
    for ([_]u16{ 30, 31 }) |symbol| {
        var stream: Stream = .{};
        stream.block_header(true, .fixed);
        stream.fixed_literal('a');
        stream.fixed_literal(constants.first_length_symbol);
        stream.code(symbol, 5);
        stream.bits(0, 32);
        try expect_refused(stream.slice(), error.InvalidDistance);
    }
}

test "RFC 1951 section 3.2.5: code 284 with extra bits 31, a length of 258, is refused" {
    var stream: Stream = .{};
    stream.block_header(true, .fixed);
    stream.fixed_literal('a');
    stream.fixed_literal(284);
    stream.bits(31, 5);
    stream.code(0, 5);
    stream.bits(0, 32);
    try expect_refused(stream.slice(), error.InvalidLength);
}

test "invariant 10: a distance past the stream's start is refused, and the old window stays unread" {
    var stream: Stream = .{};
    stream.block_header(true, .fixed);
    stream.fixed_literal('a');
    stream.fixed_literal('b');
    stream.fixed_pair(4, 3);
    stream.fixed_literal(constants.end_of_block);
    const marker = 0x5a;
    var decoder: Decoder = undefined;
    @memset(std.mem.asBytes(&decoder), marker);
    deflate.init(&decoder, .{});
    var output: [16]u8 = @splat(0);
    try testing.expectError(error.DistanceTooFar, deflate.decode(&decoder, stream.slice(), &output));
    try testing.expect(std.mem.indexOfScalar(u8, &output, marker) == null);
    try expect_refused(stream.slice(), error.DistanceTooFar);
}

test {
    _ = @import("decoder_dynamic_test.zig");
    _ = @import("decoder_fuzz_test.zig");
    _ = @import("decoder_work_test.zig");
}
