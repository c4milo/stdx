//! The limits and tables RFC 1951 fixes for every DEFLATE stream. The tables are generated at
//! comptime from the rule RFC 1951's own tables follow, and asserted against those tables' values.
const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");

/// The farthest a back-reference reaches, and so the history a decoder keeps: a distance is drawn
/// from 1 to 32,768 (RFC 1951 §3.2.5). A compliant decoder accepts the whole range (§3.3).
pub const window_len: usize = 32768;

/// The shortest and the longest match a length code expresses (RFC 1951 §3.2.5).
pub const match_len_min: usize = 3;
pub const match_len_max: usize = 258;

/// The longest code of any of the three alphabets (RFC 1951 §3.2.2, MAX_BITS; §3.2.7 limits code
/// lengths to 0 - 15).
pub const code_len_max = 15;

/// The literal/length alphabet: 0 - 255 literals, 256 the end of a block, 257 - 285 lengths
/// (RFC 1951 §3.2.5). The fixed code gives 286 and 287 lengths too, and they never occur
/// (§3.2.6).
pub const end_of_block: u16 = 256;
pub const literal_length_used = 286;
pub const literal_length_alphabet_len = 288;
pub const first_length_symbol: u16 = 257;
pub const last_length_symbol: u16 = 285;

/// The distance alphabet: 0 - 29 (RFC 1951 §3.2.5). The fixed code gives 30 and 31 5-bit codes,
/// and they never occur (§3.2.6).
pub const distance_used = 30;
pub const distance_alphabet_len = 32;

/// The code length alphabet: 0 - 15 lengths, 16 repeats the previous length, 17 and 18 repeat a
/// length of zero (RFC 1951 §3.2.7).
pub const code_length_alphabet_len = 19;
pub const repeat_previous: u8 = 16;
pub const repeat_zero_short: u8 = 17;
pub const repeat_zero_long: u8 = 18;

/// The extra bits, the least count and the greatest count of each repeat symbol, 16, 17 and 18
/// (RFC 1951 §3.2.7).
pub const repeat_extra_bits = [_]u7{ 2, 3, 7 };
pub const repeat_count_min = [_]u16{ 3, 3, 11 };
pub const repeat_count_max = [_]u16{ 6, 10, 138 };

/// The order in which a dynamic block gives the code length alphabet's code lengths (RFC 1951
/// §3.2.7).
pub const code_length_order = [code_length_alphabet_len]u8{ 16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15 };

/// The fields of a block header and of a dynamic block's header, in bits (RFC 1951 §3.2.3,
/// §3.2.7), and the offsets HLIT, HDIST and HCLEN count from.
pub const final_bits: u7 = 1;
pub const type_bits: u7 = 2;
pub const hlit_bits: u7 = 5;
pub const hdist_bits: u7 = 5;
pub const hclen_bits: u7 = 4;
pub const code_length_code_bits: u7 = 3;
pub const hlit_base: u16 = 257;
pub const hdist_base: u16 = 1;
pub const hclen_base: u16 = 4;

/// A stored block's LEN and NLEN, 16 bits each, least significant octet first (RFC 1951 §3.2.4,
/// §3.1.1).
pub const stored_len_bits: u7 = 16;
pub const stored_header_bits: u7 = 2 * stored_len_bits;

/// What decision 12 budgets for the decoder's state beside its window.
pub const decoder_state_budget_len = 16 * 1024;

/// The block types, BTYPE (RFC 1951 §3.2.3).
pub const BlockType = enum(u2) { stored = 0, fixed = 1, dynamic = 2, reserved = 3 };

/// The most bits one length/distance pair takes: a 15-bit length code, 5 extra bits, a 15-bit
/// distance code and 13 extra bits (RFC 1951 §3.2.5).
pub const pair_bits_max: u7 = code_len_max + 5 + code_len_max + 13;

/// The most bits one code length symbol takes with its extra bits (RFC 1951 §3.2.7).
pub const code_length_symbol_bits_max: u7 = code_len_max + 7;

/// The bound on a call's steps (invariant 9): each step takes at least one bit of input or writes
/// at least one octet, or ends the call, and a step that changes the phase alone is followed by one
/// that does, so a call takes at most this many steps per bit and per octet, and a few more.
pub const steps_per_unit = 2;
pub const steps_floor = 16;

/// Invariant 17's count for one code build, at most: the build reads each code length twice, to
/// count the lengths and to place the symbols, and writes at most one symbol per length. It also
/// makes five passes over its counts, one entry per code length value: it clears them, checks them
/// for over-subscription, checks them for completeness, sums them, and turns them into offsets.
pub fn build_work_max(lengths_len: usize) usize {
    return 3 * lengths_len + 5 * (code_len_max + 1);
}

/// The code lengths a dynamic block's header writes: the code length code's and the block's own.
pub const code_lengths_len = literal_length_alphabet_len + distance_alphabet_len;

/// Invariant 17's count for one dynamic block's header, at most: every code length cleared, each
/// of the code length code's written, each of the block's written, and the three codes built.
pub const block_table_work_max = code_lengths_len + code_length_alphabet_len +
    (literal_length_used + distance_alphabet_len) + build_work_max(code_length_alphabet_len) +
    build_work_max(literal_length_used) + build_work_max(distance_alphabet_len);

/// The fewest bits a code of a code the decoder accepts takes. A complete code has at least two
/// codes, so none takes less than a bit.
pub const code_bits_min = 1;

/// The fewest code length symbols that write a dynamic block's code lengths: at least 257 + 1,
/// and one symbol writes at most 138 (RFC 1951 §3.2.7).
pub const code_length_symbols_min = std.math.divCeil(usize, hlit_base + hdist_base, repeat_count_max[repeat_zero_long - repeat_previous]) catch unreachable;

/// The fewest bits a dynamic block the decoder accepts can take (RFC 1951 §3.2.7): BFINAL, BTYPE,
/// HLIT, HDIST and HCLEN; the four shortest code length code lengths HCLEN allows; the fewest code
/// length symbols; and an end-of-block code.
pub const dynamic_block_bits_min = final_bits + type_bits + hlit_bits + hdist_bits + hclen_bits +
    hclen_base * code_length_code_bits + code_length_symbols_min * code_bits_min + code_bits_min;

/// A dynamic block's table work spread over its fewest octets.
pub const table_work_per_octet_max = std.math.divCeil(usize, block_table_work_max * @bitSizeOf(u8), dynamic_block_bits_min) catch unreachable;

/// Invariant 17's bound per octet consumed: the table work, and one symbol decoded per bit, since
/// every symbol the decoder accepts takes a bit.
pub const work_per_octet_max = table_work_per_octet_max + @bitSizeOf(u8);

/// The most symbols one step decodes: a literal/length symbol and a distance.
pub const decodes_per_step_max = 2;

/// Invariant 17's bound per call, beyond `work_per_octet_max` per octet consumed: a call can
/// finish the table work of a block whose bits an earlier call consumed and start the next one's,
/// decode a symbol per bit the state carried in, and decode the symbols of a step it ends on for
/// want of bits.
pub const work_per_call_max = 2 * block_table_work_max + codec.constants.bit_buffer_bits + decodes_per_step_max;

/// Each length code's least length and extra bits, codes 257 to 285 (RFC 1951 §3.2.5).
pub const length_base: [literal_length_used - first_length_symbol]u16 = length_table().base;
pub const length_extra_bits: [literal_length_used - first_length_symbol]u7 = length_table().extra;

/// Each distance code's least distance and extra bits, codes 0 to 29 (RFC 1951 §3.2.5).
pub const distance_base: [distance_used]u16 = distance_table().base;
pub const distance_extra_bits: [distance_used]u7 = distance_table().extra;

fn Table(comptime len: usize) type {
    return struct { base: [len]u16, extra: [len]u7 };
}

/// RFC 1951 §3.2.5's rule for lengths: codes 257 - 264 take no extra bits, then each group of four
/// codes takes one more bit than the group before; 285 is 258 alone.
fn length_table() Table(literal_length_used - first_length_symbol) {
    const len = literal_length_used - first_length_symbol;
    var table: Table(len) = undefined;
    var base: u16 = match_len_min;
    for (0..len - 1) |index| {
        const extra: u7 = if (index < 8) 0 else @intCast(index / 4 - 1);
        table.base[index] = base;
        table.extra[index] = extra;
        base += @as(u16, 1) << @intCast(extra);
    }
    table.base[len - 1] = match_len_max;
    table.extra[len - 1] = 0;
    return table;
}

/// RFC 1951 §3.2.5's rule for distances: codes 0 - 3 take no extra bits, then each pair of codes
/// takes one more bit than the pair before.
fn distance_table() Table(distance_used) {
    var table: Table(distance_used) = undefined;
    var base: u16 = 1;
    for (0..distance_used) |index| {
        const extra: u7 = if (index < 4) 0 else @intCast(index / 2 - 1);
        table.base[index] = base;
        table.extra[index] = extra;
        base +%= @as(u16, 1) << @intCast(extra);
    }
    return table;
}

/// The fixed literal/length code lengths (RFC 1951 §3.2.6).
pub const fixed_literal_length_lengths: [literal_length_alphabet_len]u8 = fixed: {
    var lengths: [literal_length_alphabet_len]u8 = undefined;
    for (&lengths, 0..) |*len, symbol| {
        len.* = if (symbol < 144) 8 else if (symbol < 256) 9 else if (symbol < 280) 7 else 8;
    }
    break :fixed lengths;
};

/// The fixed distance code lengths: 5 bits for all 32 codes (RFC 1951 §3.2.6).
pub const fixed_distance_lengths: [distance_alphabet_len]u8 = @splat(5);

comptime {
    assert(std.math.isPowerOfTwo(window_len));
    assert(match_len_max < window_len);
    // The ends of each row of RFC 1951 §3.2.5's tables.
    assert(length_base[0] == 3 and length_extra_bits[0] == 0);
    assert(length_base[265 - 257] == 11 and length_extra_bits[265 - 257] == 1);
    assert(length_base[273 - 257] == 35 and length_extra_bits[273 - 257] == 3);
    assert(length_base[284 - 257] == 227 and length_extra_bits[284 - 257] == 5);
    assert(length_base[285 - 257] == 258 and length_extra_bits[285 - 257] == 0);
    assert(distance_base[4] == 5 and distance_extra_bits[4] == 1);
    assert(distance_base[19] == 769 and distance_extra_bits[19] == 8);
    assert(distance_base[29] == 24577 and distance_extra_bits[29] == 13);
    // The last distance code reaches the window's whole length.
    assert(distance_base[29] + (1 << 13) - 1 == window_len);
    assert(pair_bits_max == 48);
    assert(code_length_symbols_min == 2);
    assert(dynamic_block_bits_min == 32);
    for (repeat_extra_bits, repeat_count_min, repeat_count_max) |extra, min, max| {
        assert(max == min + (1 << extra) - 1);
    }
}
