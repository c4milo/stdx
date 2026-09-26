//! The DEFLATE decoder's reading of a dynamic block's header, on the checked path (RFC 1951
//! §3.2.7): HLIT, HDIST and HCLEN, the code length code, the code lengths it codes, and the
//! block's codes and lookup tables built from them. Split from decoder.zig, which dispatches to it.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const decoder_module = @import("decoder.zig");
const Decoder = decoder_module.Decoder;
const Error = decoder_module.Error;
const count_work = decoder_module.count_work;
const low_bits = decoder_module.low_bits;

/// Reads HLIT, HDIST and HCLEN (RFC 1951 §3.2.7), and clears the code lengths the header fills.
pub fn read_table_counts(decoder: *Decoder, bits: *codec.BitReader) Error!?codec.Status {
    if (!bits.ensure(constants.hlit_bits + constants.hdist_bits + constants.hclen_bits)) return .needs_input;
    const literal_length_count = constants.hlit_base + @as(u16, @intCast(bits.read(constants.hlit_bits).?));
    decoder.distance_count = constants.hdist_base + @as(u16, @intCast(bits.read(constants.hdist_bits).?));
    decoder.code_length_count = constants.hclen_base + @as(u16, @intCast(bits.read(constants.hclen_bits).?));
    // RFC 1951 §3.2.7: HLIT gives 257 - 286 literal/length codes.
    if (literal_length_count > constants.literal_length_used) return error.TooManyLiteralLengthCodes;
    decoder.literal_length_count = literal_length_count;
    decoder.lengths = @splat(0);
    count_work(decoder, decoder.lengths.len);
    decoder.header_index = 0;
    decoder.phase = .code_length_code;
    return null;
}

/// Reads one 3-bit code length of the code length alphabet, or builds that code after the last.
pub fn read_code_length_code(decoder: *Decoder, bits: *codec.BitReader) Error!?codec.Status {
    if (decoder.header_index == decoder.code_length_count) {
        try decoder.code_length_code.build(decoder.lengths[0..constants.code_length_alphabet_len], .complete, &decoder.work);
        decoder.header_index = 0;
        decoder.phase = .code_lengths;
        return null;
    }
    const len = bits.read(constants.code_length_code_bits) orelse return .needs_input;
    decoder.lengths[constants.code_length_order[decoder.header_index]] = @intCast(len);
    count_work(decoder, 1);
    decoder.header_index += 1;
    return null;
}

/// Reads the code length symbols, with their repeats' extra bits, while the input holds them, then
/// builds the block's codes after the last length.
pub fn read_code_lengths(decoder: *Decoder, bits: *codec.BitReader) Error!?codec.Status {
    const total = decoder.literal_length_count + decoder.distance_count;
    // Each symbol writes at least one length.
    for (0..total - decoder.header_index) |_| {
        if (decoder.header_index == total) break;
        if (try read_code_length(decoder, bits, total)) |status| return status;
    }
    assert(decoder.header_index == total);
    try build_block_codes(decoder);
    decoder.phase = .symbols;
    return null;
}

/// Reads one code length symbol, with a repeat's extra bits.
fn read_code_length(decoder: *Decoder, bits: *codec.BitReader, total: u16) Error!?codec.Status {
    _ = bits.ensure(constants.code_length_symbol_bits_max);
    const available = @min(bits.bits.count, codec.constants.ensure_bits_max);
    const buffer = bits.peek(available);
    const decoded = decoder.code_length_code.decode(buffer, available);
    count_work(decoder, 1);
    const symbol = switch (decoded) {
        .symbol => |symbol| symbol,
        .needs_bits => return .needs_input,
        // A complete code has no unused value; the code length code is built complete.
        .invalid => unreachable,
    };
    const repeat = try code_length_repeat(decoder, symbol.value, buffer >> @intCast(symbol.len), available - symbol.len) orelse return .needs_input;
    // RFC 1951 §3.2.7: all code lengths form one sequence of HLIT + HDIST + 258 values, which a
    // repeat may cross but not pass.
    if (decoder.header_index + repeat.count > total) return error.RepeatPastEnd;
    fill_lengths(&decoder.lengths, decoder.header_index, repeat.count, repeat.len);
    count_work(decoder, repeat.count);
    decoder.header_index += repeat.count;
    bits.consume(symbol.len + repeat.extra_bits);
    return null;
}

const Repeat = struct { len: u8, count: u16, extra_bits: u7 };

/// The code lengths one code length symbol stands for, or null when its extra bits are not all
/// present (RFC 1951 §3.2.7).
fn code_length_repeat(decoder: *const Decoder, symbol: u16, extra: u64, available: u7) Error!?Repeat {
    if (symbol < constants.repeat_previous) return .{ .len = @intCast(symbol), .count = 1, .extra_bits = 0 };
    const kind = symbol - constants.repeat_previous;
    const extra_bits = constants.repeat_extra_bits[kind];
    if (extra_bits > available) return null;
    const count = constants.repeat_count_min[kind] + @as(u16, @intCast(extra & low_bits(extra_bits)));
    if (symbol != constants.repeat_previous) return .{ .len = 0, .count = count, .extra_bits = extra_bits };
    // RFC 1951 §3.2.7: 16 copies the previous code length, and the first has none.
    if (decoder.header_index == 0) return error.RepeatWithoutLength;
    return .{ .len = decoder.lengths[decoder.header_index - 1], .count = count, .extra_bits = extra_bits };
}

fn fill_lengths(lengths: []u8, start: usize, count: usize, len: u8) void {
    assert(start + count <= lengths.len);
    // Most symbols write one length, which a call to memset would cost more than.
    if (count == 1) {
        lengths[start] = len;
    } else {
        @memset(lengths[start..][0..count], len);
    }
}

/// Builds a dynamic block's literal/length and distance codes from the lengths just read.
fn build_block_codes(decoder: *Decoder) Error!void {
    const literal_lengths = decoder.lengths[0..decoder.literal_length_count];
    // RFC 1951 §3.2.7: every block ends with symbol 256, so its code must have a length.
    if (literal_lengths[constants.end_of_block] == 0) return error.MissingEndOfBlock;
    try decoder.literal_length_code.build(literal_lengths, .complete, &decoder.work);
    const distance_lengths = decoder.lengths[decoder.literal_length_count..][0..decoder.distance_count];
    try decoder.distance_code.build(distance_lengths, .distance, &decoder.work);
    count_work(decoder, decoder.literal_length_table.build(&decoder.literal_length_code.counts, &decoder.literal_length_code.symbols));
    count_work(decoder, decoder.distance_table.build(&decoder.distance_code.counts, &decoder.distance_code.symbols));
}
