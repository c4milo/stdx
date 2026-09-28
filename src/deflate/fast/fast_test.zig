//! Tests of the common loop's assembly (decision 29) on literal/length codes longer than the table,
//! which it decodes from the prefix the table holds a bit at a time (RFC 1951 §3.2.2), and on the
//! entries it leaves to `decode_rare`. Each test runs the assembly the CPU runs over one block's
//! symbols, and requires it to stop at the symbol `decode_rare` takes, having written every octet
//! before it and used none of its bits. On a CPU that runs no assembly, the tests skip.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const huffman = @import("../huffman.zig");
const lookup = @import("../lookup.zig");
const test_stream = @import("../test_stream.zig");
const Dynamic = @import("../decoder/decoder_dynamic_test.zig").Dynamic;
const fast = @import("fast.zig");
const fast_aarch64 = @import("fast_aarch64.zig");
const fast_x86_64 = @import("fast_x86_64.zig");

const Stream = test_stream.Stream;

/// The literals of the dynamic block's short codes: 'a' to 'i' take 1 to 9 bits, and 'j' takes
/// 11, so the table is 11 bits wide.
const short_literals = "abcdefghij";
const short_literal_last_bits = constants.literal_length_table_bits;

/// The literals the pairs of the dynamic block alternate with, whose codes are longer than the
/// table.
const long_literals = "ABCDE";

/// The dynamic block's distance code: 16 symbols of 4 bits, distances 1 to 384.
const distance_symbols = 16;
const distance_bits = 4;

/// The literals before the pairs, and a stride through the short literals that varies them.
const history_len = 128;
const history_stride = 7;

/// The pairs a block takes at most, and the octets it stands for at most: the history, and each
/// pair with the literal after it.
const pairs_max = 32;
const output_len_max = history_len + pairs_max * (constants.match_len_max + 1);

/// The octets after a stream: the 8 a refill takes past the stream's last bits, and the 8 of the
/// margin past those.
const input_padding = 16;

comptime {
    std.debug.assert(input_padding >= 2 * fast.input_slack);
}

/// A literal/length symbol and the length of its code.
const Code = struct { u16, u4 };

/// The dynamic block: the short codes, the `long` codes, and the distance code.
fn dynamic_block(long: []const Code) Dynamic {
    var dynamic: Dynamic = .{ .literal_count = constants.literal_length_used, .distance_count = distance_symbols };
    for (short_literals[0 .. short_literals.len - 1], 1..) |octet, bits| dynamic.literal_lengths[octet] = @intCast(bits);
    dynamic.literal_lengths[short_literals[short_literals.len - 1]] = short_literal_last_bits;
    for (long) |code| dynamic.literal_lengths[code[0]] = code[1];
    for (dynamic.distance_lengths[0..distance_symbols]) |*len| len.* = distance_bits;
    return dynamic;
}

/// A block's codes as the fast path takes them, built as a decoder builds them for long input:
/// the lengths resolved and the tables combined (S11).
const Built = struct {
    literal_length_code: huffman.Code(constants.literal_length_alphabet_len),
    distance_code: huffman.Code(constants.distance_alphabet_len),
    literal_length_table: lookup.LiteralLengthTable,
    distance_table: lookup.DistanceTable,

    fn init_dynamic(self: *Built, dynamic: *const Dynamic) !void {
        var work: huffman.Work = huffman.work_zero;
        try self.literal_length_code.build(dynamic.literal_lengths[0..dynamic.literal_count], .complete, &work);
        try self.distance_code.build(dynamic.distance_lengths[0..dynamic.distance_count], .distance, &work);
        self.build_tables();
    }

    fn init_fixed(self: *Built) void {
        self.literal_length_code = huffman.fixed_literal_length;
        self.distance_code = huffman.fixed_distance;
        self.build_tables();
    }

    fn build_tables(self: *Built) void {
        _ = self.literal_length_table.build(&self.literal_length_code.counts, &self.literal_length_code.symbols, true);
        _ = self.distance_table.build(&self.distance_code.counts, &self.distance_code.symbols, false);
        _ = lookup.combine(&self.literal_length_table, &self.literal_length_code, &self.distance_table, &self.distance_code);
    }

    fn codes(self: *const Built) fast.Codes {
        return .{
            .literal_length_table = &self.literal_length_table,
            .distance_table = &self.distance_table,
            .literal_length_code = &self.literal_length_code,
            .distance_code = &self.distance_code,
        };
    }
};

/// The octets a block's symbols stand for.
const Expected = struct {
    octets: [output_len_max]u8 = undefined,
    len: usize = 0,

    fn literal(self: *Expected, octet: u8) void {
        self.octets[self.len] = octet;
        self.len += 1;
    }

    /// A match's octets, one at a time from `distance` back (RFC 1951 §3.2.3).
    fn match(self: *Expected, len: u16, distance: u16) void {
        for (0..len) |_| self.literal(self.octets[self.len - distance]);
    }

    fn slice(self: *const Expected) []const u8 {
        return self.octets[0..self.len];
    }
};

/// Whether the CPU runs an assembly of the common loop.
fn assembly_runs() bool {
    if (comptime fast_aarch64.takes(.{})) return true;
    return (comptime fast_x86_64.takes(.{})) and fast.assembly_runs(codec.Features.detect());
}

/// The common loop's assembly the CPU runs, for a caller that checked `assembly_runs`.
fn common(loop: *fast.Loop, codes: fast.Codes) fast.Stop {
    if (comptime fast_aarch64.takes(.{})) return fast_aarch64.decode_common(loop, codes);
    if (comptime fast_x86_64.takes(.{})) return fast_x86_64.decode_common(loop, codes);
    unreachable;
}

/// How the loop's bit buffer starts: empty, or full with the input's first 8 octets, as a state
/// the checked reader filled can bring it.
const Buffer = enum { empty, full };

/// Runs the assembly over `input`, a block's symbols after its header, and requires it to stop for
/// `decode_rare` at the symbol `last`, having written `expected` and used none of `last`'s bits.
/// The input is padded and the output has room past `expected`, so the margins hold through
/// `last`.
fn expect_stops_at(built: *const Built, input: []const u8, expected: []const u8, last: u16) !void {
    return expect_stops_from(.empty, built, input, expected, last);
}

/// `expect_stops_at`, the bit buffer starting as `buffer` says.
fn expect_stops_from(buffer: Buffer, built: *const Built, input: []const u8, expected: []const u8, last: u16) !void {
    var padded: [test_stream.stream_len_max + input_padding]u8 = @splat(0);
    @memcpy(padded[0..input.len], input);
    var output: [output_len_max + fast.output_slack]u8 = @splat(0);
    const taken: usize = if (buffer == .full) @sizeOf(u64) else 0;
    var loop: fast.Loop = .{
        .input = &padded,
        .rest = padded[taken..],
        .buffer = if (buffer == .full) std.mem.readInt(u64, padded[0..@sizeOf(u64)], .little) else 0,
        .count = if (buffer == .full) @as(u32, @bitSizeOf(u64)) else 0,
        .output = output[0 .. expected.len + fast.output_slack],
        .written = 0,
        .literal_length_entries = &built.literal_length_table.entries,
        .literal_length_mask = built.literal_length_table.mask(),
        .distance_entries = &built.distance_table.entries,
        .distance_mask = built.distance_table.mask(),
        .distance_max = constants.window_len,
        .lengths_resolved = built.literal_length_table.resolved,
    };
    try testing.expectEqual(fast.Stop.rare, common(&loop, built.codes()));
    try testing.expectEqualSlices(u8, expected, output[0..loop.written]);
    const available: u7 = @intCast(@min(loop.count, constants.code_len_max));
    const next = built.literal_length_code.decode(loop.buffer, available);
    try testing.expectEqual(last, next.symbol.value);
}

/// Writes the history's literals.
fn history(dynamic: *const Dynamic, stream: *Stream, expected: *Expected) void {
    for (0..history_len) |index| {
        const octet = short_literals[(index * history_stride + index / short_literals.len) % short_literals.len];
        dynamic.literal(stream, octet);
        expected.literal(octet);
    }
}

/// The first and the last length of length code `symbol`: 257 for code 284, as 258 has code 285
/// alone (RFC 1951 §3.2.5).
fn code_lens(symbol: u16) struct { first: u16, last: u16 } {
    const index = symbol - constants.first_length_symbol;
    const first = constants.length_base[index];
    const last = first + (@as(u16, 1) << @intCast(constants.length_extra_bits[index])) - 1;
    return .{ .first = first, .last = if (last == constants.match_len_max and first != last) last - 1 else last };
}

/// Requires the assembly to decode, after the history, a pair of each first and last length of
/// each length code among `long`, at `distances` in turn, each followed by a long literal, and to
/// stop at the block's end.
fn expect_long_pairs(built: *const Built, dynamic: *const Dynamic, long: []const Code, distances: []const u16) !void {
    var stream: Stream = .{};
    var expected: Expected = .{};
    history(dynamic, &stream, &expected);
    var pairs: usize = 0;
    for (long) |code| {
        if (code[0] < constants.first_length_symbol) continue;
        const lens = code_lens(code[0]);
        for ([_]u16{ lens.first, lens.last }) |len| {
            const distance = distances[pairs % distances.len];
            dynamic.pair(&stream, len, distance);
            expected.match(len, distance);
            const octet = long_literals[pairs % long_literals.len];
            dynamic.literal(&stream, octet);
            expected.literal(octet);
            pairs += 1;
        }
    }
    dynamic.literal(&stream, constants.end_of_block);
    try expect_stops_at(built, stream.slice(), expected.slice(), constants.end_of_block);
}

/// Requires the assembly to stop, after the history, at a pair of each length code among `long`
/// whose match reaches past the output.
fn expect_far_pairs_stop(built: *const Built, dynamic: *const Dynamic, long: []const Code) !void {
    for (long) |code| {
        if (code[0] < constants.first_length_symbol) continue;
        var stream: Stream = .{};
        var expected: Expected = .{};
        history(dynamic, &stream, &expected);
        dynamic.pair(&stream, code_lens(code[0]).last, history_len + 1);
        try expect_stops_at(built, stream.slice(), expected.slice(), code[0]);
    }
}

test "the assembly decodes each literal and length whose code is longer than the table" {
    if (!assembly_runs()) return error.SkipZigTest;
    // Three codes each of 12, 13 and 14 bits and six of 15: with the short codes, a complete code
    // (RFC 1951 §3.2.2), as 3/2^12 + 3/2^13 + 3/2^14 + 6/2^15 and 1/2^11 make 1/2^9, what 'a' to
    // 'i' leave. The block's end and every length among them, each with and without extra bits.
    const long = [_]Code{
        .{ 'A', 12 }, .{ 265, 12 }, .{ 285, 12 },
        .{ 'B', 13 }, .{ 269, 13 }, .{ 273, 13 },
        .{ 'C', 14 }, .{ 277, 14 }, .{ 281, 14 },
        .{ 'D', 15 }, .{ 'E', 15 }, .{ constants.end_of_block, 15 },
        .{ 257, 15 }, .{ 283, 15 }, .{ 284, 15 },
    };
    const dynamic = dynamic_block(&long);
    var built: Built = undefined;
    try built.init_dynamic(&dynamic);
    // Distances below a chunk, from one chunk to two, and past two.
    try expect_long_pairs(&built, &dynamic, &long, &.{ 1, 3, 8, 15, 16, 17, 31, 32, 33, 64, 100, 128 });
    try expect_far_pairs_stop(&built, &dynamic, &long);
}

test "a distance code longer than its table stops the loop, whatever bits follow it" {
    if (!assembly_runs()) return error.SkipZigTest;
    // Literal 'a' takes the code 0, and lengths 3 and 4 the last two of 6 bits: a complete code
    // (RFC 1951 §3.2.2). Distance symbols 0 to 7 take 1 to 8 bits and 8 and 9 take 9, past the
    // distance table's 8. Symbol 8's code, 111111110, then its three extra bits, 0 for a distance
    // of 17, and the 60 zeros of 60 'a's leave the buffer past the table's bits all zero, so an
    // entry that is not a distance's, taken as one, would give a distance the output holds.
    var dynamic: Dynamic = .{ .literal_count = constants.first_length_symbol + 2, .distance_count = 10 };
    for ("abcd", 1..) |octet, bits| dynamic.literal_lengths[octet] = @intCast(bits);
    dynamic.literal_lengths[constants.end_of_block] = 5;
    dynamic.literal_lengths[constants.first_length_symbol] = 6;
    dynamic.literal_lengths[constants.first_length_symbol + 1] = 6;
    for (dynamic.distance_lengths[0..8], 1..) |*len, bits| len.* = @intCast(bits);
    dynamic.distance_lengths[8] = 9;
    dynamic.distance_lengths[9] = 9;
    var built: Built = undefined;
    try built.init_dynamic(&dynamic);
    var stream: Stream = .{};
    var expected: Expected = .{};
    for (0..history_len * 3) |index| {
        const octet = "bcd"[(index * history_stride + index / 3) % 3];
        dynamic.literal(&stream, octet);
        expected.literal(octet);
    }
    dynamic.pair(&stream, 3, 17);
    for (0..60) |_| dynamic.literal(&stream, 'a');
    try expect_stops_at(&built, stream.slice(), expected.slice(), constants.first_length_symbol);
}

test "a run's last literal waits for the refill when the buffer, full at the start, holds 10 bits" {
    if (!assembly_runs()) return error.SkipZigTest;
    // Literals 0 to 127 take 10 bits and 128 to 255 take 11, the block's end 1 and lengths 3 and 4
    // take 2 and 4: 128/1024 + 128/2048 + 1/2 + 1/4 + 1/16 = 1, a complete code (RFC 1951
    // §3.2.2). A buffer full at the start holds as many bits as its count, so after four literals
    // of 11 bits and one of 10 it holds 10: the next literal's 11th bit is not in it yet.
    var dynamic: Dynamic = .{ .literal_count = constants.first_length_symbol + 2, .distance_count = 1 };
    for (dynamic.literal_lengths[0..128]) |*len| len.* = 10;
    for (dynamic.literal_lengths[128..constants.end_of_block]) |*len| len.* = 11;
    dynamic.literal_lengths[constants.end_of_block] = 1;
    dynamic.literal_lengths[constants.first_length_symbol] = 2;
    dynamic.literal_lengths[constants.first_length_symbol + 1] = 4;
    dynamic.distance_lengths[0] = 1;
    var built: Built = undefined;
    try built.init_dynamic(&dynamic);
    // The next literal is one whose code's last bit, the one the buffer lacks, is 1.
    const codes = test_stream.assign_codes(constants.literal_length_alphabet_len, dynamic.literal_lengths);
    var next: u16 = 132;
    while (codes[next] & 1 == 0) next += 1;
    var stream: Stream = .{};
    var expected: Expected = .{};
    for ([_]u16{ 128, 129, 130, 131, 0, next }) |octet| {
        dynamic.literal(&stream, octet);
        expected.literal(@intCast(octet));
    }
    dynamic.literal(&stream, constants.end_of_block);
    try expect_stops_from(.full, &built, stream.slice(), expected.slice(), constants.end_of_block);
}

test "the block's end and a symbol that never occurs stop the loop, whatever the unused lengths hold" {
    if (!assembly_runs()) return error.SkipZigTest;
    // The fixed code's table is 9 bits wide, and the block's end takes 7 and 286 8 (RFC 1951
    // §3.2.6). The lengths up to the width hold no long code; here they match any value and name
    // literals, so a loop that took either entry as a long code's would write a literal and go on.
    var built: Built = undefined;
    built.init_fixed();
    const table = &built.literal_length_table;
    const first_literal = std.mem.indexOfScalar(u16, &built.literal_length_code.symbols, 0).?;
    for (table.long_codes[1 .. @as(usize, table.bits) + 1]) |*codes| {
        codes.* = .{ .first = 0, .count = std.math.maxInt(u16), .index = @intCast(first_literal) };
    }
    for ([_]u16{ constants.end_of_block, constants.literal_length_used }) |last| {
        var stream: Stream = .{};
        var expected: Expected = .{};
        for (0..history_len) |index| {
            const octet = short_literals[index % short_literals.len];
            stream.fixed_literal(octet);
            expected.literal(octet);
        }
        stream.fixed_literal(last);
        try expect_stops_at(&built, stream.slice(), expected.slice(), last);
    }
}
