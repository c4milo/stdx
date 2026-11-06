//! The tests of the encoder's prefix codes: each description, read by a reader written in this file
//! from RFC 7932 §3.4 and §3.5, gives the lengths the code holds, and the code is complete, at most
//! 15 bits, and prefers the frequent symbols.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const encoder_prefix = @import("encoder_prefix.zig");

/// RFC 7932 §3.5's fixed code of the code length code's lengths, read a bit at a time: the length
/// whose code the bits so far spell.
fn read_fixed_length(reader: *codec.BitReader) !u8 {
    var value: u8 = 0;
    for (0..constants.code_length_code_length_bits_max) |bit| {
        value |= @as(u8, @intCast(reader.read(1) orelse return error.Truncated)) << @intCast(bit);
        for (constants.code_length_code_length_codes, 0..) |fixed, len| {
            if (fixed.len == bit + 1 and fixed.code == value) return @intCast(len);
        }
    }
    return error.TestBadFixedCode;
}

/// A symbol of the canonical code of `lengths`, read most significant bit of the code first.
fn read_symbol(reader: *codec.BitReader, lengths: []const u8) !usize {
    var code: u32 = 0;
    var first: u32 = 0;
    var counted: u32 = 0;
    for (1..constants.code_len_max + 1) |len| {
        code = (code << 1) | @as(u32, @intCast(reader.read(1) orelse return error.Truncated));
        // The canonical codes of RFC 7932 §3.2: each length's first code follows the shorter ones.
        first = (first + counted) << 1;
        counted = count_of_length(lengths, len);
        if (code >= first and code < first + counted) return nth_of_length(lengths, len, code - first);
    }
    return error.TestBadCode;
}

fn count_of_length(lengths: []const u8, len: usize) u32 {
    var count: u32 = 0;
    for (lengths) |l| count += @intFromBool(l == len);
    return count;
}

/// The symbol of the `index`th code of `len` bits, in order of symbol.
fn nth_of_length(lengths: []const u8, len: usize, index: u32) usize {
    var left = index;
    for (lengths, 0..) |l, symbol| {
        if (l != len) continue;
        if (left == 0) return symbol;
        left -= 1;
    }
    unreachable;
}

/// Reads one description into `lengths`.
fn read_description(reader: *codec.BitReader, lengths: []u8, alphabet_bits: u4) !void {
    @memset(lengths, 0);
    const kind = reader.read(constants.prefix_kind_bits) orelse return error.Truncated;
    if (kind == constants.prefix_kind_simple) return read_simple(reader, lengths, alphabet_bits);
    var length_code: [constants.code_length_alphabet_len]u8 = @splat(0);
    try read_length_code(reader, @intCast(kind), &length_code);
    try read_lengths(reader, &length_code, lengths);
}

/// The code length code's lengths after HSKIP's skipped ones, up to a complete code.
fn read_length_code(reader: *codec.BitReader, skip: usize, length_code: []u8) !void {
    var space: u32 = 0;
    for (constants.code_length_code_order[skip..]) |symbol| {
        const len = try read_fixed_length(reader);
        length_code[symbol] = len;
        if (len != 0) space += @as(u32, constants.code_length_code_space) >> @intCast(len);
        if (space == constants.code_length_code_space) break;
    }
    try testing.expectEqual(constants.code_length_code_space, space);
}

/// A code's lengths, read as code length symbols until the code is complete.
fn read_lengths(reader: *codec.BitReader, length_code: []const u8, lengths: []u8) !void {
    var state: LengthsRead = .{ .lengths = lengths };
    for (0..lengths.len) |_| {
        if (state.space == constants.code_lengths_space) break;
        const symbol = try read_symbol(reader, length_code);
        if (symbol < constants.repeat_previous_symbol) {
            state.add(@intCast(symbol), 1);
            state.last_repeat = null;
            continue;
        }
        try state.repeat(reader, @intCast(symbol));
    }
    try testing.expectEqual(constants.code_lengths_space, state.space);
}

/// The lengths read so far, the previous nonzero one, and the repeat a next repeat extends.
const LengthsRead = struct {
    lengths: []u8,
    at: usize = 0,
    previous: u8 = constants.previous_len_initial,
    last_repeat: ?u8 = null,
    count: usize = 0,
    space: u32 = 0,

    fn add(self: *LengthsRead, len: u8, times: usize) void {
        for (0..times) |_| {
            self.lengths[self.at] = len;
            self.at += 1;
            if (len != 0) self.space += @as(u32, constants.code_lengths_space) >> @intCast(len);
        }
        if (len != 0) self.previous = len;
    }

    /// A 16 or a 17 with its extra bits: a repeat after one of the same kind extends its count
    /// (RFC 7932 §3.5).
    fn repeat(self: *LengthsRead, reader: *codec.BitReader, symbol: u8) !void {
        const zero = symbol == constants.repeat_zero_symbol;
        const extra_bits: u7 = if (zero) constants.repeat_zero_extra_bits else constants.repeat_previous_extra_bits;
        const digit = reader.read(extra_bits) orelse return error.Truncated;
        const before = if (self.last_repeat != null and self.last_repeat.? == symbol) self.count else 0;
        const count: usize = if (before == 0) constants.repeat_len_min + digit else ((before - constants.repeat_count_offset) << @intCast(extra_bits)) + constants.repeat_len_min + digit;
        self.add(if (zero) 0 else self.previous, count - before);
        self.count = count;
        self.last_repeat = symbol;
    }
};

fn read_simple(reader: *codec.BitReader, lengths: []u8, alphabet_bits: u4) !void {
    const count = (reader.read(constants.simple_count_bits) orelse return error.Truncated) + 1;
    var symbols: [constants.simple_symbols_max]u64 = undefined;
    var listed: usize = 0;
    for (&symbols) |*symbol| {
        if (listed == count) break;
        symbol.* = reader.read(alphabet_bits) orelse return error.Truncated;
        listed += 1;
    }
    const tree_select = listed == constants.simple_symbols_max and (reader.read(1) orelse return error.Truncated) == 1;
    if (listed == 1) return;
    const fixed: []const u8 = if (tree_select) &constants.simple_code_lengths_tree_select else constants.simple_code_lengths[listed - constants.code_symbols_min];
    for (symbols[0..listed], fixed) |symbol, len| set_length(lengths, symbol, len);
}

/// Gives the symbol a description named its length, without an index the description chose.
fn set_length(lengths: []u8, symbol: u64, len: u8) void {
    for (lengths, 0..) |*length, candidate| {
        if (candidate == symbol) length.* = len;
    }
}

/// Room for a description and a test's message.
const round_trip_len = 4096;

/// Builds the code of `counts`, writes its description and a symbol stream of `message`, and reads
/// both back.
fn expect_round_trip(comptime n: usize, counts: *const [n]u16, message: []const u16, alphabet_bits: u4) !void {
    var code: encoder_prefix.Code(n) = undefined;
    encoder_prefix.build(n, counts, &code);
    var octets: [round_trip_len]u8 = undefined;
    var writer = codec.BitWriter.init(&octets, .{});
    try encoder_prefix.write(n, &writer, &code, alphabet_bits);
    for (message) |symbol| try encoder_prefix.put_symbol(n, &writer, &code, symbol);
    writer.put(0, writer.bits_to_octet());
    try testing.expect(writer.drain());
    var reader = codec.BitReader.init(writer.writer.written(), .{});
    var lengths: [n]u8 = undefined;
    try read_description(&reader, &lengths, alphabet_bits);
    try testing.expectEqualSlices(u8, &code.lengths, &lengths);
    if (code.simple_count == 1) return;
    for (message) |symbol| try testing.expectEqual(@as(usize, symbol), try read_symbol(&reader, &lengths));
}

test "codes of one to four symbols take the simple form, the most frequent first" {
    var counts: [256]u16 = @splat(0);
    counts['a'] = 9;
    try expect_round_trip(256, &counts, &.{ 'a', 'a' }, 8);
    // One symbol alone: NSYM 1, which takes no bits, with no stand-in beside it.
    var single: encoder_prefix.Code(256) = undefined;
    encoder_prefix.build(256, &counts, &single);
    try testing.expectEqual(1, single.simple_count);
    try testing.expectEqual(0, single.lengths['a']);
    counts['b'] = 1;
    try expect_round_trip(256, &counts, &.{ 'a', 'b', 'a' }, 8);
    counts['c'] = 2;
    try expect_round_trip(256, &counts, &.{ 'c', 'b', 'a' }, 8);
    counts['d'] = 1;
    // 9 outweighs 1 + 1, so the tree-select bit gives 'a' a code of one bit.
    var code: encoder_prefix.Code(256) = undefined;
    encoder_prefix.build(256, &counts, &code);
    try testing.expect(code.tree_select);
    try testing.expectEqual(1, code.lengths['a']);
    try expect_round_trip(256, &counts, &.{ 'd', 'c', 'b', 'a' }, 8);
}

test "seeded counts take complex codes of at most 15 bits that read back" {
    var generator = codec.testing.split.Generator.init(62);
    for (0..300) |_| {
        var counts: [704]u16 = @splat(0);
        const used = generator.between(5, 704);
        for (0..used) |_| {
            const symbol = generator.below(704);
            // Skewed counts, some long runs of equal lengths, some of zeros.
            counts[symbol] +|= @intCast(@as(u64, 1) << @intCast(generator.below(14)));
        }
        var message: [64]u16 = undefined;
        var filled: usize = 0;
        for (&counts, 0..) |count, symbol| {
            if (count == 0 or filled == message.len) continue;
            message[filled] = @intCast(symbol);
            filled += 1;
        }
        try expect_round_trip(704, &counts, message[0..filled], 10);
    }
}

test "a code of equal lengths repeats the initial 8 at once" {
    var counts: [256]u16 = @splat(1);
    try expect_round_trip(256, &counts, &.{ 0, 255, 128 }, 8);
    var code: encoder_prefix.Code(256) = undefined;
    encoder_prefix.build(256, &counts, &code);
    try testing.expectEqual(8, code.lengths[17]);
}
