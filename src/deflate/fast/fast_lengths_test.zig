//! Tests for the DEFLATE header's fast paths (fast_lengths.zig): the code length code's table
//! against the canonical decode, and the loops against the checked steps, over headers whose code
//! length code and code length symbols a seed draws. A drawn header seldom gives codes the decoder
//! accepts, so most end in a refusal, which each path must give alike with the same lengths read.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const huffman = @import("../huffman.zig");
const test_stream = @import("../test_stream.zig");
const deflate = @import("../decoder/decoder.zig");
const fast_lengths = @import("fast_lengths.zig");

const Stream = test_stream.Stream;
pub const Generator = codec.split.Generator;
pub const alphabet_len = constants.code_length_alphabet_len;
pub const CodeLengths = [alphabet_len]u8;
const codes_min = test_stream.complete_codes_min;

/// The seeds the code length codes and the headers are drawn from.
const code_seeds = 400;
const header_seeds = 600;

/// The zero octets after a header, two margins, so the loops' margin holds to its end, and the
/// room a decode writes into: a drawn header's codes may decode the padding to a few octets.
const padding_margins = 2;
pub const padding_len = padding_margins * fast_lengths.input_slack;
pub const output_len = 4096;

/// What each path's state holds in every octet before `init`: a path that reads what it did not
/// write gives what another path does not.
pub const loop_fill = 0x5a;
pub const loop_off_fill = 0xa5;
pub const tally_off_fill = 0x96;
pub const checked_fill = 0x33;

/// A complete code of the code length alphabet with `codes` codes, drawn from `generator`
/// (test_stream.zig).
pub fn draw_code(generator: *Generator, codes: usize) CodeLengths {
    var lengths: CodeLengths = undefined;
    test_stream.draw_complete_code(generator, &lengths, codes, constants.code_length_code_len_max);
    return lengths;
}

test "the table gives every index the symbol and the length the canonical code gives it" {
    for (0..code_seeds) |seed| {
        var generator = Generator.init(seed);
        const lengths = draw_code(&generator, @intCast(generator.between(codes_min, alphabet_len)));
        var work = huffman.work_zero;
        var code: fast_lengths.CodeLengthCode = undefined;
        try code.build(&lengths, .complete, &work);
        var table: fast_lengths.Table = undefined;
        @memset(std.mem.asBytes(&table), 0xff);
        const written = table.build(&code);
        try testing.expectEqual(fast_lengths.Table.len + code.code_count, written);
        for (0..fast_lengths.Table.len) |index| {
            const decoded = code.decode(index, constants.code_length_table_bits);
            const entry = table.look_up(index);
            try testing.expectEqual(decoded.symbol.value, entry.symbol);
            try testing.expectEqual(decoded.symbol.len, entry.code_bits);
            // The bits above the table's index choose nothing.
            try testing.expectEqual(entry, table.look_up(index | @as(u64, 0xa5) << constants.code_length_table_bits));
        }
    }
}

/// A dynamic block's header, written a code length symbol at a time with a code length code of the
/// test's own (RFC 1951 §3.2.7).
pub const Header = struct {
    stream: Stream = .{},
    lengths: CodeLengths,
    codes: [alphabet_len]u16,
    total: u16,
    filled: u16 = 0,

    /// BFINAL, BTYPE and the counts, then the code length code's lengths through the last symbol
    /// of `code_length_order` that has one, and four at least.
    pub fn init(lengths: CodeLengths, literal_length_count: u16, distance_count: u16) Header {
        var header: Header = .{ .lengths = lengths, .codes = test_stream.assign_codes(alphabet_len, lengths), .total = literal_length_count + distance_count };
        var count: u16 = constants.hclen_base;
        for (constants.code_length_order, 0..) |symbol, index| {
            if (lengths[symbol] != 0) count = @max(count, @as(u16, @intCast(index + 1)));
        }
        header.stream.block_header(true, .dynamic);
        header.stream.bits(literal_length_count - constants.hlit_base, constants.hlit_bits);
        header.stream.bits(distance_count - constants.hdist_base, constants.hdist_bits);
        header.stream.bits(count - constants.hclen_base, constants.hclen_bits);
        for (constants.code_length_order[0..count]) |symbol| header.stream.bits(lengths[symbol], constants.code_length_code_bits);
        return header;
    }

    /// One code length symbol, with a repeat's extra bits `extra`. Counts the lengths it gives.
    pub fn give(self: *Header, value: u8, extra: u64) void {
        std.debug.assert(self.lengths[value] != 0);
        self.stream.code(self.codes[value], self.lengths[value]);
        if (value < constants.repeat_previous) {
            self.filled += 1;
            return;
        }
        const kind = value - constants.repeat_previous;
        self.stream.bits(extra, constants.repeat_extra_bits[kind]);
        self.filled += constants.repeat_count_min[kind] + @as(u16, @intCast(extra));
    }

    /// The header's octets, with `padding_len` zero octets after them.
    pub fn padded(self: *const Header, buffer: *[test_stream.stream_len_max + padding_len]u8) []const u8 {
        return self.padded_with(0, buffer);
    }

    /// The header's octets, with `padding_len` octets of `fill` after them.
    pub fn padded_with(self: *const Header, fill: u8, buffer: *[test_stream.stream_len_max + padding_len]u8) []const u8 {
        const octets = self.stream.slice();
        @memcpy(buffer[0..octets.len], octets);
        @memset(buffer[octets.len..][0..padding_len], fill);
        return buffer[0 .. octets.len + padding_len];
    }
};

/// A header whose code length code and symbols `seed` draws: symbols with a code, each with any
/// extra bits, until the lengths are all given or passed. So it may start with a repeat of no
/// length and may pass its last length, both of which the decoder refuses.
fn draw_header(seed: u64) Header {
    var generator = Generator.init(seed);
    const lengths = draw_code(&generator, @intCast(generator.between(codes_min, alphabet_len)));
    const literal_length_count: u16 = @intCast(generator.between(constants.hlit_base, constants.literal_length_used));
    const distance_count: u16 = @intCast(generator.between(constants.hdist_base, constants.distance_alphabet_len));
    var header = Header.init(lengths, literal_length_count, distance_count);
    var coded: [alphabet_len]u8 = undefined;
    var coded_len: usize = 0;
    for (lengths, 0..) |len, value| {
        if (len == 0) continue;
        coded[coded_len] = @intCast(value);
        coded_len += 1;
    }
    // Each symbol gives a length at least.
    for (0..header.total) |_| {
        if (header.filled >= header.total) break;
        const value = coded[@intCast(generator.below(coded_len))];
        const extra_bits: u6 = if (value < constants.repeat_previous) 0 else @intCast(constants.repeat_extra_bits[value - constants.repeat_previous]);
        header.give(value, generator.below(@as(u64, 1) << extra_bits));
    }
    return header;
}

/// A block's two codes, as a decode of its header built them.
pub const Codes = struct {
    literal_length: huffman.Code(constants.literal_length_alphabet_len),
    distance: huffman.Code(constants.distance_alphabet_len),

    pub fn expect_equal(self: *const Codes, other: *const Codes) !void {
        inline for (.{ "literal_length", "distance" }) |name| {
            const mine = &@field(self, name);
            const theirs = &@field(other, name);
            try testing.expectEqualSlices(u16, &mine.counts, &theirs.counts);
            try testing.expectEqual(mine.code_count, theirs.code_count);
            try testing.expectEqualSlices(u16, mine.symbols[0..mine.code_count], theirs.symbols[0..theirs.code_count]);
        }
    }
};

/// What a decode of a header left: how the call ended, the code lengths it read, and the codes it
/// built from them, which a decode that ended in a refusal may not have.
pub const Read = struct {
    result: deflate.Error!codec.Progress,
    read_len: u16,
    lengths: fast_lengths.Lengths,
    codes: Codes,
    output: [output_len]u8,

    pub fn expect_equal(self: *const Read, other: *const Read) !void {
        try testing.expectEqual(self.result, other.result);
        try testing.expectEqual(self.read_len, other.read_len);
        try testing.expectEqualSlices(u8, self.lengths[0..self.read_len], other.lengths[0..other.read_len]);
        const progress = self.result catch return;
        try self.codes.expect_equal(&other.codes);
        try testing.expectEqualSlices(u8, self.output[0..progress.written], other.output[0..progress.written]);
    }
};

/// Decodes `input` in two calls cut at `cut`, or in one when `cut` is its length, on `options`.
/// The state starts as `fill` in every octet, so a path that reads what it did not write shows.
pub fn read_header(comptime options: deflate.Options, input: []const u8, cut: usize, fill: u8) Read {
    var decoder: deflate.Decoder = undefined;
    @memset(std.mem.asBytes(&decoder), fill);
    deflate.init(&decoder, codec.Features.detect());
    var read: Read = .{ .result = undefined, .read_len = 0, .lengths = undefined, .codes = undefined, .output = undefined };
    read.result = decode_cut(options, &decoder, input, cut, &read.output);
    // A decode that passed the header read every length; one refused inside it stopped at one.
    read.read_len = if (@intFromEnum(decoder.phase) == code_lengths_phase or read.result == error.RepeatPastEnd or read.result == error.RepeatWithoutLength) decoder.header_index else decoder.literal_length_count + decoder.distance_count;
    read.lengths = decoder.lengths;
    read.codes = .{ .literal_length = decoder.literal_length_code, .distance = decoder.distance_code };
    return read;
}

/// The decoder's phase while it reads code lengths, as its enum numbers it (decoder.zig).
const code_lengths_phase = 5;

fn decode_cut(comptime options: deflate.Options, decoder: *deflate.Decoder, input: []const u8, cut: usize, output: *[output_len]u8) deflate.Error!codec.Progress {
    const first = try deflate.decode_with(options, decoder, input[0..cut], output);
    if (cut == input.len or first.status != .needs_input) return first;
    const second = try deflate.decode_with(options, decoder, input[first.consumed..], output[first.written..]);
    return .{ .consumed = first.consumed + second.consumed, .written = first.written + second.written, .status = second.status };
}

pub const loop_off: deflate.Options = .{ .claims = .{ .code_lengths_loop = false } };
pub const tally_off: deflate.Options = .{ .claims = .{ .tallied_codes = false } };
pub const checked: deflate.Options = .{ .fast_paths = false };

/// Requires the loops, the loops without the tally of the lengths (S14), the checked steps under
/// the fast path, and the checked path alone to leave the same lengths, build the same codes and
/// end alike, over `input` whole.
pub fn expect_paths_agree(input: []const u8) !Read {
    const with_loop = read_header(.{}, input, input.len, loop_fill);
    try with_loop.expect_equal(&read_header(tally_off, input, input.len, tally_off_fill));
    try with_loop.expect_equal(&read_header(loop_off, input, input.len, loop_off_fill));
    try with_loop.expect_equal(&read_header(checked, input, input.len, checked_fill));
    return with_loop;
}

test "the loops read a drawn header as the checked steps do, whole" {
    var refused: usize = 0;
    for (0..header_seeds) |seed| {
        const header = draw_header(seed);
        var buffer: [test_stream.stream_len_max + padding_len]u8 = undefined;
        const read = try expect_paths_agree(header.padded(&buffer));
        if (read.result == error.RepeatPastEnd or read.result == error.RepeatWithoutLength) refused += 1;
    }
    // The seeds draw both kinds of header: those whose lengths are all read, and those refused
    // at a repeat.
    try testing.expect(refused > header_seeds / 16 and refused < header_seeds - header_seeds / 16);
}

test "the loops read a drawn header as the checked steps do, cut at every octet" {
    for (0..header_seeds / 8) |seed| {
        const header = draw_header(seed);
        var buffer: [test_stream.stream_len_max + padding_len]u8 = undefined;
        const input = header.padded(&buffer);
        const whole = read_header(checked, input, input.len, checked_fill);
        for (1..input.len) |cut| try whole.expect_equal(&read_header(.{}, input, cut, loop_fill));
    }
}

/// A code length code for the lengths 0 and `plain_len` and the three repeats: 0, `plain_len` and
/// 18 take `short_code_bits`, and 16 and 17 `long_code_bits`, a complete code.
const plain_len = 8;
const short_code_bits = 2;
const long_code_bits = 3;

fn repeats_code() CodeLengths {
    var lengths: CodeLengths = @splat(0);
    lengths[0] = short_code_bits;
    lengths[plain_len] = short_code_bits;
    lengths[constants.repeat_previous] = long_code_bits;
    lengths[constants.repeat_zero_short] = long_code_bits;
    lengths[constants.repeat_zero_long] = short_code_bits;
    return lengths;
}

test "a repeat of the previous length in the array's last octets is left to the checked steps" {
    // 318 lengths, the most: zeros, then 8 once and three more of it by a repeat, as the last
    // four. One store of eight octets has no room there. The zeros before them come as 1 to 4
    // short runs and a long one, so the loop meets the repeat with its buffer at several fills.
    for (1..5) |short_runs| {
        var header = Header.init(repeats_code(), constants.literal_length_used, constants.distance_alphabet_len);
        header.give(constants.repeat_zero_long, 127);
        header.give(constants.repeat_zero_long, 127);
        for (0..short_runs) |_| header.give(constants.repeat_zero_short, 0);
        header.give(constants.repeat_zero_long, 27 - 3 * short_runs);
        header.give(8, 0);
        header.give(constants.repeat_previous, 0);
        try testing.expectEqual(header.total, header.filled);
        // Octets of ones follow, so the loop hands the reader back with their bits loaded past
        // its count, which the checked steps refuse to find there.
        var buffer: [test_stream.stream_len_max + padding_len]u8 = undefined;
        const read = try expect_paths_agree(header.padded_with(0xff, &buffer));
        try testing.expectEqual(header.total, read.read_len);
        try testing.expectEqualSlices(u8, &.{ 0, 8, 8, 8, 8 }, read.lengths[header.total - 5 .. header.total]);
    }
}

test "a repeat's copies end where its count ends, and a run of zeros follows them" {
    // 8, then five more of it, then zeros to the end, which the loop takes without a store: a
    // copy too many would stay.
    var header = Header.init(repeats_code(), constants.hlit_base, constants.hdist_base);
    header.give(8, 0);
    header.give(constants.repeat_previous, 2);
    header.give(constants.repeat_zero_long, 127);
    header.give(constants.repeat_zero_long, 103);
    try testing.expectEqual(header.total, header.filled);
    var buffer: [test_stream.stream_len_max + padding_len]u8 = undefined;
    const read = try expect_paths_agree(header.padded(&buffer));
    try testing.expectEqual(header.total, read.read_len);
    try testing.expectEqualSlices(u8, &.{ 8, 8, 8, 8, 8, 8, 0, 0, 0, 0 }, read.lengths[0..10]);
}

test "a run of zeros over the code length code's own lengths leaves zeros" {
    // The code length code's lengths sit where the first code lengths go, at 0, 8, 16, 17 and 18.
    // The header's first symbol is a run of 138 zeros, which covers them.
    var header = Header.init(repeats_code(), constants.hlit_base, constants.hdist_base);
    header.give(constants.repeat_zero_long, 127);
    header.give(constants.repeat_zero_long, 109);
    try testing.expectEqual(header.total, header.filled);
    var buffer: [test_stream.stream_len_max + padding_len]u8 = undefined;
    const read = try expect_paths_agree(header.padded(&buffer));
    try testing.expectEqual(header.total, read.read_len);
    try testing.expect(std.mem.allEqual(u8, read.lengths[0..header.total], 0));
    try testing.expectEqual(error.MissingEndOfBlock, read.result);
}

test "the checked path alone builds no table for the code length code" {
    var header = Header.init(repeats_code(), constants.hlit_base, constants.hdist_base);
    header.give(constants.repeat_zero_long, 127);
    header.give(constants.repeat_zero_long, 109);
    var buffer: [test_stream.stream_len_max + padding_len]u8 = undefined;
    const input = header.padded(&buffer);
    const marker = 0x77;
    inline for (.{ checked, loop_off }) |options| {
        var decoder: deflate.Decoder = undefined;
        @memset(std.mem.asBytes(&decoder), marker);
        deflate.init(&decoder, codec.Features.detect());
        var output: [output_len]u8 = undefined;
        try testing.expectError(error.MissingEndOfBlock, deflate.decode_with(options, &decoder, input, &output));
        try testing.expect(std.mem.allEqual(u8, std.mem.asBytes(&decoder.code_length_table), marker));
    }
}
