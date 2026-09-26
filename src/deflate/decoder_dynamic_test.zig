//! Tests for the DEFLATE decoder's dynamic blocks (RFC 1951 §3.2.7): the header, the code lengths
//! and their repeats, the codes built from them, and every refusal decision 15 lists for them.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const deflate = @import("decoder.zig");
const decoder_test = @import("decoder_test.zig");
const Stream = decoder_test.Stream;

/// A complete code for the code length alphabet: 13 symbols of 4 bits and 6 of 5, since
/// 13/16 + 6/32 = 1 (RFC 1951 §3.2.2). The long codes go to the last six symbols of
/// `code_length_order`, the lengths an encoder is least likely to use.
const short_code_bits = 4;
const long_code_bits = 5;
const long_code_count = 6;
const code_length_lengths: [constants.code_length_alphabet_len]u8 = lengths: {
    var lengths: [constants.code_length_alphabet_len]u8 = @splat(short_code_bits);
    for (constants.code_length_order[constants.code_length_alphabet_len - long_code_count ..]) |symbol| {
        lengths[symbol] = long_code_bits;
    }
    break :lengths lengths;
};
const code_length_codes = decoder_test.assign_codes(constants.code_length_alphabet_len, code_length_lengths);

/// A dynamic block's code lengths and the codes they assign.
const Dynamic = struct {
    literal_lengths: [constants.literal_length_alphabet_len]u8 = @splat(0),
    literal_count: u16,
    distance_lengths: [constants.distance_alphabet_len]u8 = @splat(0),
    distance_count: u16,

    fn literal_codes(self: *const Dynamic) [constants.literal_length_alphabet_len]u16 {
        return decoder_test.assign_codes(constants.literal_length_alphabet_len, self.literal_lengths);
    }

    fn distance_codes(self: *const Dynamic) [constants.distance_alphabet_len]u16 {
        return decoder_test.assign_codes(constants.distance_alphabet_len, self.distance_lengths);
    }

    /// The block header and the counts, and the code length code's lengths (RFC 1951 §3.2.7).
    fn header_start(self: *const Dynamic, stream: *Stream, last: bool) void {
        stream.block_header(last, .dynamic);
        stream.bits(self.literal_count - constants.hlit_base, constants.hlit_bits);
        stream.bits(self.distance_count - constants.hdist_base, constants.hdist_bits);
        stream.bits(constants.code_length_alphabet_len - constants.hclen_base, constants.hclen_bits);
        for (constants.code_length_order) |symbol| stream.bits(code_length_lengths[symbol], constants.code_length_code_bits);
    }

    /// The whole header, with the code lengths run-length coded as RFC 1951 §3.2.7 allows.
    fn header(self: *const Dynamic, stream: *Stream, last: bool) void {
        self.header_start(stream, last);
        var sequence: [constants.literal_length_alphabet_len + constants.distance_alphabet_len]u8 = undefined;
        @memcpy(sequence[0..self.literal_count], self.literal_lengths[0..self.literal_count]);
        @memcpy(sequence[self.literal_count..][0..self.distance_count], self.distance_lengths[0..self.distance_count]);
        write_lengths(stream, sequence[0 .. self.literal_count + self.distance_count]);
    }

    fn literal(self: *const Dynamic, stream: *Stream, symbol: u16) void {
        stream.code(self.literal_codes()[symbol], self.literal_lengths[symbol]);
    }

    fn distance(self: *const Dynamic, stream: *Stream, symbol: u16) void {
        stream.code(self.distance_codes()[symbol], self.distance_lengths[symbol]);
    }
};

fn code_length_symbol(stream: *Stream, symbol: u8, extra: u64) void {
    stream.code(code_length_codes[symbol], code_length_lengths[symbol]);
    if (symbol >= constants.repeat_previous) stream.bits(extra, constants.repeat_extra_bits[symbol - constants.repeat_previous]);
}

fn repeat_min(symbol: u8) u16 {
    return constants.repeat_count_min[symbol - constants.repeat_previous];
}

/// Writes one repeat symbol for as much of a run of `run` as it takes, and returns how much.
fn write_repeat(stream: *Stream, symbol: u8, run: usize) usize {
    const kind = symbol - constants.repeat_previous;
    const count = @min(run, constants.repeat_count_max[kind]);
    code_length_symbol(stream, symbol, count - constants.repeat_count_min[kind]);
    return count;
}

/// The code lengths, with runs of zeros as 17 and 18 and runs of a length as 16.
fn write_lengths(stream: *Stream, lengths: []const u8) void {
    var index: usize = 0;
    while (index < lengths.len) {
        var run: usize = 1;
        while (index + run < lengths.len and lengths[index + run] == lengths[index]) run += 1;
        if (lengths[index] == 0 and run >= repeat_min(constants.repeat_zero_long)) {
            index += write_repeat(stream, constants.repeat_zero_long, run);
        } else if (lengths[index] == 0 and run >= repeat_min(constants.repeat_zero_short)) {
            index += write_repeat(stream, constants.repeat_zero_short, run);
        } else if (run > repeat_min(constants.repeat_previous)) {
            code_length_symbol(stream, lengths[index], 0);
            index += 1 + write_repeat(stream, constants.repeat_previous, run - 1);
        } else {
            code_length_symbol(stream, lengths[index], 0);
            index += 1;
        }
    }
}

/// A block whose literal/length code gives 'a' - 'd', 256 and lengths 3 - 5 (codes 257 - 259)
/// three bits each, eight codes in all, and whose distance code gives distances 1 and 2 one bit
/// each.
const small_code_bits = 3;
const small_length_symbols = 3;

fn small_block() Dynamic {
    const literal_count = constants.first_length_symbol + small_length_symbols;
    var block: Dynamic = .{ .literal_count = literal_count, .distance_count = constants.hdist_base + 1 };
    for ("abcd") |symbol| block.literal_lengths[symbol] = small_code_bits;
    for (constants.end_of_block..literal_count) |symbol| block.literal_lengths[symbol] = small_code_bits;
    block.distance_lengths[0] = 1;
    block.distance_lengths[1] = 1;
    return block;
}

test "a dynamic block's codes, from lengths that use every repeat symbol" {
    const block = small_block();
    var stream: Stream = .{};
    block.header(&stream, true);
    for ("abcd") |symbol| block.literal(&stream, symbol);
    block.literal(&stream, 257); // length 3
    block.distance(&stream, 1); // distance 2
    block.literal(&stream, 259); // length 5
    block.distance(&stream, 0); // distance 1
    block.literal(&stream, constants.end_of_block);
    try decoder_test.expect_decodes(stream.slice(), "abcdcdcccccc");
}

test "codes longer than the fast path's tables decode alike, literals, lengths and distances" {
    // Literals 'a' to 'n' take 1 to 14 bits, and end-of-block and length code 257 take the two
    // 15-bit codes left: a complete code (RFC 1951 §3.2.2).
    var block: Dynamic = .{ .literal_count = constants.literal_length_used, .distance_count = constants.distance_used };
    for (0..constants.code_len_max - 1) |index| block.literal_lengths['a' + index] = @intCast(index + 1);
    block.literal_lengths[constants.end_of_block] = constants.code_len_max;
    block.literal_lengths[constants.first_length_symbol] = constants.code_len_max;
    // Distance codes 0 to 13 take 14 bits down to 1, and code 14 the second 14-bit code, so
    // distances 1 and 2 take codes longer than the distance table.
    const distance_symbols = constants.code_len_max - 1;
    for (0..distance_symbols) |index| block.distance_lengths[index] = @intCast(distance_symbols - index);
    block.distance_lengths[distance_symbols] = distance_symbols;
    var stream: Stream = .{};
    block.header(&stream, true);
    for ("abcdefghijklmn") |symbol| block.literal(&stream, symbol);
    // Length 3 at distance 2, then at distance 1.
    block.literal(&stream, constants.first_length_symbol);
    block.distance(&stream, 1);
    block.literal(&stream, constants.first_length_symbol);
    block.distance(&stream, 0);
    block.literal(&stream, 'n');
    // Runs of literals that start with a long code: 14 bits, then four of 11.
    const run = "nkkkk";
    for (0..16) |_| {
        for (run) |symbol| block.literal(&stream, symbol);
    }
    block.literal(&stream, constants.end_of_block);
    try decoder_test.expect_decodes(stream.slice(), "abcdefghijklmnmnmmmmn" ++ run ** 16);
}

/// The literals of the test below: 0 to 127 take `narrow_literal_bits`, and 128 to 255
/// `wide_literal_bits`.
const narrow_literal_bits = 10;
const wide_literal_bits = 11;
const wide_literal_first = 128;
const wide_literals_len = 600;
/// The seeded sequences of those literals the test decodes.
const wide_literal_seeds = 16;

test "runs of 10- and 11-bit literals decode alike at every alignment of the refill" {
    // End-of-block takes 1 bit, and length codes 257 and 258 take 2 and 4, so with the literals
    // 128/1024 + 128/2048 + 1/2 + 1/4 + 1/16 = 1, a complete code (RFC 1951 §3.2.2).
    var block: Dynamic = .{ .literal_count = constants.first_length_symbol + 2, .distance_count = constants.hdist_base + 1 };
    for (0..wide_literal_first) |symbol| block.literal_lengths[symbol] = narrow_literal_bits;
    for (wide_literal_first..constants.end_of_block) |symbol| block.literal_lengths[symbol] = wide_literal_bits;
    block.literal_lengths[constants.end_of_block] = 1;
    block.literal_lengths[constants.first_length_symbol] = 2;
    block.literal_lengths[constants.first_length_symbol + 1] = 4;
    block.distance_lengths[0] = 1;
    block.distance_lengths[1] = 1;
    for (0..wide_literal_seeds) |seed| try expect_literals_decode(&block, seed);
}

/// Requires a seeded sequence of `block`'s literals to decode. A run of these literals leaves
/// fewer bits than a table code takes at some alignments of the refill, and there the next lookup
/// waits for the refill.
fn expect_literals_decode(block: *const Dynamic, seed: u64) !void {
    var stream: Stream = .{};
    block.header(&stream, true);
    var expected: [wide_literals_len]u8 = undefined;
    var generator = codec.split.Generator.init(seed);
    for (&expected) |*octet| {
        octet.* = @intCast(generator.below(constants.end_of_block));
        block.literal(&stream, octet.*);
    }
    block.literal(&stream, constants.end_of_block);
    try decoder_test.expect_decodes(stream.slice(), &expected);
}

test "a call that ends in a dynamic header leaves the fast path's octets in the window" {
    // A fixed block of 300 literals, which the fast path and its tail decode whole when the input
    // goes on, then a dynamic block whose match reaches back to the first literal. At some cut the
    // first call ends in the dynamic block's header, with the checked path never having run.
    var stream: Stream = .{};
    stream.block_header(false, .fixed);
    var expected: [300 + 3 + 1]u8 = undefined;
    for (expected[0..300], 0..) |*octet, index| {
        octet.* = @truncate(index *% 13);
        stream.fixed_literal(octet.*);
    }
    stream.fixed_literal(constants.end_of_block);
    // 'x', end-of-block and length code 257 take 1, 2 and 2 bits; distance codes 0 and 16 a bit
    // each, and code 16 takes 7 extra bits for 257 to 384 (RFC 1951 §3.2.5).
    var block: Dynamic = .{ .literal_count = constants.first_length_symbol + 1, .distance_count = 17 };
    block.literal_lengths['x'] = 1;
    block.literal_lengths[constants.end_of_block] = 2;
    block.literal_lengths[constants.first_length_symbol] = 2;
    block.distance_lengths[0] = 1;
    block.distance_lengths[16] = 1;
    block.header(&stream, true);
    block.literal(&stream, constants.first_length_symbol);
    block.distance(&stream, 16);
    stream.bits(300 - 257, 7);
    block.literal(&stream, 'x');
    block.literal(&stream, constants.end_of_block);
    @memcpy(expected[300..][0..3], expected[0..3]);
    expected[303] = 'x';
    const input = stream.slice();
    for (1..input.len) |cut| {
        var decoder: deflate.Decoder = undefined;
        deflate.init(&decoder, .{});
        var output: [expected.len]u8 = undefined;
        const first = try deflate.decode(&decoder, input[0..cut], &output);
        try testing.expectEqual(codec.Status.needs_input, first.status);
        const second = try deflate.decode(&decoder, input[first.consumed..], output[first.written..]);
        try testing.expectEqual(codec.Status.done, second.status);
        try testing.expectEqualSlices(u8, &expected, output[0 .. first.written + second.written]);
    }
}

test "RFC 1951 section 3.2.7: a single one-bit distance code, and no distance code at all" {
    var single = small_block();
    single.distance_lengths[1] = 0;
    var stream: Stream = .{};
    single.header(&stream, false);
    single.literal(&stream, 'a');
    single.literal(&stream, 257);
    single.distance(&stream, 0);
    single.literal(&stream, constants.end_of_block);
    var none = small_block();
    none.distance_lengths = @splat(0);
    none.distance_count = 1;
    none.header(&stream, true);
    none.literal(&stream, 'b');
    none.literal(&stream, constants.end_of_block);
    try decoder_test.expect_decodes(stream.slice(), "aaaab");
}

test "RFC 1951 section 3.2.7: HDIST of 32 distance codes is accepted" {
    var block = small_block();
    block.distance_count = 32;
    for (&block.distance_lengths) |*len| len.* = 5;
    var stream: Stream = .{};
    block.header(&stream, true);
    block.literal(&stream, 'c');
    block.literal(&stream, 258);
    block.distance(&stream, 0);
    block.literal(&stream, constants.end_of_block);
    try decoder_test.expect_decodes(stream.slice(), "ccccc");
}

test "RFC 1951 section 3.2.7: HLIT of 286 codes, the most, is accepted" {
    var block = small_block();
    block.literal_count = constants.literal_length_used;
    block.literal_lengths[258] = 0;
    block.literal_lengths[285] = small_code_bits;
    var stream: Stream = .{};
    block.header(&stream, true);
    block.literal(&stream, 'd');
    block.literal(&stream, 285);
    block.distance(&stream, 0);
    block.literal(&stream, constants.end_of_block);
    try decoder_test.expect_decodes(stream.slice(), "d" ** 259);
}

test "RFC 1951 section 3.2.7: HLIT past 286 codes is refused" {
    var block = small_block();
    block.literal_count = 287;
    var stream: Stream = .{};
    block.header(&stream, true);
    try decoder_test.expect_refused(stream.slice(), error.TooManyLiteralLengthCodes);
}

test "over-subscribed and incomplete literal/length codes are refused" {
    var over = small_block();
    over.literal_lengths['e'] = 3;
    var stream: Stream = .{};
    over.header(&stream, true);
    try decoder_test.expect_refused(stream.slice(), error.OverSubscribedCode);
    var incomplete = small_block();
    incomplete.literal_lengths['d'] = 0;
    stream = .{};
    incomplete.header(&stream, true);
    try decoder_test.expect_refused(stream.slice(), error.IncompleteCode);
}

test "a code without the end-of-block symbol is refused" {
    var block = small_block();
    block.literal_lengths[constants.end_of_block] = 0;
    block.literal_lengths['e'] = 3;
    var stream: Stream = .{};
    block.header(&stream, true);
    try decoder_test.expect_refused(stream.slice(), error.MissingEndOfBlock);
}

test "RFC 1951 section 3.2.7: a repeat with nothing before it, and one past the end, are refused" {
    const block = small_block();
    var stream: Stream = .{};
    block.header_start(&stream, true);
    code_length_symbol(&stream, constants.repeat_previous, 0);
    stream.bits(0, 64);
    try decoder_test.expect_refused(stream.slice(), error.RepeatWithoutLength);
    stream = .{};
    block.header_start(&stream, true);
    for (0..2) |_| code_length_symbol(&stream, constants.repeat_zero_long, 127);
    code_length_symbol(&stream, 3, 0);
    code_length_symbol(&stream, constants.repeat_zero_long, 0);
    stream.bits(0, 64);
    try decoder_test.expect_refused(stream.slice(), error.RepeatPastEnd);
}

test "an incomplete code length code is refused" {
    var stream: Stream = .{};
    stream.block_header(true, .dynamic);
    stream.bits(0, constants.hlit_bits + constants.hdist_bits);
    stream.bits(0, constants.hclen_bits);
    // Four code length codes of length 1, 2, 3 and 0: 1/2 + 1/4 + 1/8 leaves 1/8 unused.
    for ([_]u8{ 1, 2, 3, 0 }) |len| stream.bits(len, constants.code_length_code_bits);
    stream.bits(0, 64);
    try decoder_test.expect_refused(stream.slice(), error.IncompleteCode);
    // A single code of one bit, which only the distance code may be (RFC 1951 §3.2.7).
    stream = .{};
    stream.block_header(true, .dynamic);
    stream.bits(0, constants.hlit_bits + constants.hdist_bits);
    stream.bits(0, constants.hclen_bits);
    for ([_]u8{ 0, 0, 0, 1 }) |len| stream.bits(len, constants.code_length_code_bits);
    stream.bits(0, 64);
    try decoder_test.expect_refused(stream.slice(), error.IncompleteCode);
}

test "RFC 1951 section 3.2.7: an unused distance value, and a length with no distance code, are refused" {
    var single = small_block();
    single.distance_lengths[0] = 0;
    var stream: Stream = .{};
    single.header(&stream, true);
    single.literal(&stream, 'a');
    single.literal(&stream, 257);
    stream.bits(1, 1); // The single distance code is 0; 1 names nothing.
    stream.bits(0, 64);
    try decoder_test.expect_refused(stream.slice(), error.InvalidCode);
    var none = small_block();
    none.distance_lengths = @splat(0);
    none.distance_count = 1;
    stream = .{};
    none.header(&stream, true);
    none.literal(&stream, 'a');
    none.literal(&stream, 257);
    stream.bits(0, 64);
    try decoder_test.expect_refused(stream.slice(), error.InvalidCode);
}

test "every refusal is corrupt input, not a feature refused" {
    inline for (@typeInfo(deflate.Corrupt).error_set.?) |corrupt| {
        try testing.expectEqual(codec.Refusal.corrupt, deflate.refusal(@field(anyerror, corrupt.name)));
    }
}
