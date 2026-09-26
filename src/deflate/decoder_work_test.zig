//! Invariant 17's check for the DEFLATE decoder, on decision 15's worst cases: minimal dynamic
//! blocks, each of which makes the decoder clear its code lengths and build three codes for a dozen
//! octets, and a block of one-bit literals, eight symbols an octet. The decoder's count of table
//! entries touched and symbols decoded is what each stream asks for, and stays within
//! `constants.work_per_octet_max` per octet consumed and `constants.work_per_call_max` per call,
//! whether the stream comes whole or an octet per call.

const std = @import("std");
const testing = std.testing;
const constants = @import("constants.zig");
const deflate = @import("decoder.zig");
const Stream = @import("decoder_test.zig").Stream;

/// The minimal blocks of the first worst case, the one-bit literals of the second, and the
/// literals that end the stream decoded an octet at a time.
const minimal_blocks = 48;
const literals = 4096;
const split_literals = 1024;

/// The code lengths the code length code gives a length: 1 for symbol 1 and for symbol 18, which
/// writes 11 to 138 zeros, and none for the rest. HCLEN covers `code_length_order` up to symbol 1.
const code_length_count = 18;
const zeros_symbol = constants.repeat_zero_long;
const zeros_extra_bits = constants.repeat_extra_bits[zeros_symbol - constants.repeat_previous];
const zeros_min = constants.repeat_count_min[zeros_symbol - constants.repeat_previous];
const zeros_max = constants.repeat_count_max[zeros_symbol - constants.repeat_previous];

/// The code length code's codes (RFC 1951 §3.2.2): symbol 1 is 0 and symbol 18 is 1.
fn code_length_symbol(stream: *Stream, symbol: u16) void {
    stream.code(@intFromBool(symbol == zeros_symbol), 1);
}

/// Writes `count` zero code lengths, and returns the code length symbols that took.
fn zeros(stream: *Stream, count: usize) usize {
    var left = count;
    var symbols: usize = 0;
    while (left > 0) : (symbols += 1) {
        const run = @min(left, zeros_max);
        std.debug.assert(run >= zeros_min);
        code_length_symbol(stream, zeros_symbol);
        stream.bits(run - zeros_min, zeros_extra_bits);
        left -= run;
    }
    return symbols;
}

/// A block's HLIT + 257 and HDIST + 1.
const Shape = struct { literal_length_count: u16, distance_count: u16 };

/// The two ends of both counts.
const shapes = [_]Shape{
    .{ .literal_length_count = constants.hlit_base, .distance_count = constants.hdist_base },
    .{ .literal_length_count = constants.literal_length_used, .distance_count = constants.distance_alphabet_len },
};

/// A dynamic block whose only literal/length codes are literal 0 and end-of-block, a bit each, and
/// whose distance code is one code of one bit or none (RFC 1951 §3.2.7). It holds `literal_count`
/// zeros and its end. Returns the count the decoder keeps for it: its code lengths cleared, the
/// code length code's lengths written and its code built, a decode per code length symbol, the
/// block's code lengths written and its two codes built, and a decode per symbol.
fn minimal_block(stream: *Stream, last: bool, shape: Shape, literal_count: usize) u64 {
    const literal_length_count = shape.literal_length_count;
    const distance_count = shape.distance_count;
    stream.block_header(last, .dynamic);
    stream.bits(literal_length_count - constants.hlit_base, constants.hlit_bits);
    stream.bits(distance_count - constants.hdist_base, constants.hdist_bits);
    stream.bits(code_length_count - constants.hclen_base, constants.hclen_bits);
    for (constants.code_length_order[0..code_length_count]) |symbol| {
        stream.bits(@intFromBool(symbol == 1 or symbol == zeros_symbol), constants.code_length_code_bits);
    }
    code_length_symbol(stream, 1);
    var code_length_symbols = 1 + zeros(stream, constants.end_of_block - 1);
    code_length_symbol(stream, 1);
    code_length_symbols += 1;
    const rest = literal_length_count - constants.end_of_block - 1 + distance_count;
    if (rest == 1) {
        code_length_symbol(stream, 1);
        code_length_symbols += 1;
    } else {
        code_length_symbols += zeros(stream, rest);
    }
    for (0..literal_count) |_| stream.code(0, 1);
    stream.code(1, 1);
    // The lookup tables of one-bit codes hold two entries. The distance table is cleared first,
    // because a code of one code or none is incomplete, and its one code, if any, written after.
    const table_entries = 2;
    const distance_table_work: u64 = table_entries + @as(u64, @intFromBool(rest == 1));
    return constants.code_lengths_len + code_length_count + constants.build_work_max(constants.code_length_alphabet_len) +
        code_length_symbols + literal_length_count + distance_count + constants.build_work_max(literal_length_count) +
        constants.build_work_max(distance_count) + table_entries + distance_table_work + literal_count + 1;
}

/// `block_count` minimal blocks at both ends of HLIT and HDIST, the last holding `literal_count`
/// literals. Returns the count the decoder keeps for them.
fn worst_case(stream: *Stream, block_count: usize, literal_count: usize) u64 {
    std.debug.assert(block_count >= 1);
    var work: u64 = 0;
    for (0..block_count - 1) |index| work += minimal_block(stream, false, shapes[index % shapes.len], 0);
    return work + minimal_block(stream, true, shapes[0], literal_count);
}

fn expect_bounded(work: u64, consumed: usize) !void {
    try testing.expect(work <= constants.work_per_octet_max * consumed + constants.work_per_call_max);
}

/// Decodes a worst case in one call, and requires the count it asks for, within the bound.
fn expect_whole(block_count: usize, literal_count: usize) !void {
    var stream: Stream = .{};
    const work = worst_case(&stream, block_count, literal_count);
    var decoder: deflate.Decoder = undefined;
    deflate.init(&decoder, .{});
    var output: [literals]u8 = undefined;
    const progress = try deflate.decode(&decoder, stream.slice(), &output);
    try testing.expectEqual(.done, progress.status);
    try testing.expectEqual(stream.slice().len, progress.consumed);
    try testing.expectEqual(literal_count, progress.written);
    try testing.expectEqual(work, decoder.work);
    try expect_bounded(decoder.work, progress.consumed);
}

test "minimal dynamic blocks cost at most the bound per octet" {
    try expect_whole(minimal_blocks, 0);
}

test "a block of one-bit literals costs at most the bound per octet" {
    try expect_whole(1, literals);
}

test "the worst case an octet at a time costs at most the bound per call" {
    var stream: Stream = .{};
    const work = worst_case(&stream, minimal_blocks, split_literals);
    const input = stream.slice();
    var decoder: deflate.Decoder = undefined;
    deflate.init(&decoder, .{});
    var output: [split_literals]u8 = undefined;
    var consumed: usize = 0;
    var written: usize = 0;
    var calls: usize = 0;
    for (0..input.len + split_literals) |_| {
        const before = decoder.work;
        const end = @min(consumed + 1, input.len);
        const progress = try deflate.decode(&decoder, input[consumed..end], output[written..]);
        try expect_bounded(decoder.work - before, progress.consumed);
        consumed += progress.consumed;
        written += progress.written;
        calls += 1;
        if (progress.status == .done) break;
    } else return error.TestUnexpectedResult;
    try testing.expectEqual(input.len, consumed);
    try testing.expectEqual(split_literals, written);
    // A call that ends for want of bits wastes at most the decodes of the step it ends on.
    try testing.expect(decoder.work >= work);
    try testing.expect(decoder.work <= work + calls * constants.decodes_per_step_max);
}
