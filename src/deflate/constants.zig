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

/// The bits the fast path's tables take of a literal/length code and of a distance code (decision
/// 14, S2): one lookup decodes every code up to this long.
pub const literal_length_table_bits = 11;
pub const distance_table_bits = 8;

/// The narrower widths S2's A/B times the tables at (design §8 step 7).
pub const narrow_literal_length_table_bits = 9;
pub const narrow_distance_table_bits = 6;

comptime {
    assert(narrow_literal_length_table_bits < literal_length_table_bits);
    assert(narrow_distance_table_bits < distance_table_bits);
}

/// The octets the fast path's match copy moves at once (decision 14, S4): a 128-bit vector, or a
/// 64-bit word for a distance shorter than the vector but at least as long as the word.
pub const copy_chunk_len = 16;
pub const copy_word_len = @sizeOf(u64);

/// Invariant 17's count for one lookup table's build, at most: every entry once as the table
/// doubles, and one more for each code.
pub fn table_build_work_max(table_bits: u4, symbols: usize) usize {
    return (@as(usize, 1) << table_bits) + symbols;
}

/// The bits the fast path's table takes of a code of the code length code (decision 14, S13): that
/// code's longest, so one lookup decodes every code length symbol.
pub const code_length_table_bits = code_length_code_len_max;

/// The most bits one code length symbol takes on the fast path, its code and a repeat's extra bits
/// (RFC 1951 §3.2.7): what the code lengths' loop holds in its buffer before each symbol.
pub const code_length_symbol_bits: u7 = code_length_code_len_max + std.mem.max(u7, &repeat_extra_bits);

/// Invariant 17's count for the build of the code length code's table, at most.
pub const code_length_table_work_max = table_build_work_max(code_length_table_bits, code_length_alphabet_len);

/// Invariant 17's count for one code build, at most: the build reads each code length twice, to
/// count the lengths and to place the symbols, and writes at most one symbol per length. It also
/// makes five passes over its counts, one entry per code length value: it clears them, checks them
/// for over-subscription, checks them for completeness, sums them, and turns them into offsets.
pub fn build_work_max(lengths_len: usize) usize {
    return 3 * lengths_len + 5 * (code_len_max + 1);
}

/// Invariant 17's count for the entries a literal/length table's build writes, at most, beyond
/// `table_build_work_max`, to take the extra bits of the lengths whose code and extra bits fit the
/// table into its entries: an entry for each value of each length code's extra bits (decision 14,
/// S2).
pub const resolved_length_entries_max: usize = resolved: {
    var entries: usize = 0;
    for (length_extra_bits) |extra_bits| {
        if (extra_bits > 0) entries += @as(usize, 1) << extra_bits;
    }
    break :resolved entries;
};

/// Invariant 17's count for combining a literal/length table with its block's distances, at
/// most: every entry read, and each rewritten (lookup.zig, `combine`).
pub fn combine_work_max(table_bits: u4) usize {
    return 2 * (@as(usize, 1) << table_bits);
}

/// Invariant 17's count for a combination beyond a block's plain tables, at most: the entries of
/// the lengths the table resolves, and the combining (decision 14, S11).
pub fn combination_work_max(table_bits: u4) usize {
    return resolved_length_entries_max + combine_work_max(table_bits);
}

/// The bits the fast path decodes, at least, before a block's tables combine: a combination costs
/// `combination_work_max`, and pays off only over a long stream, so the bits before it both show
/// the stream is long and bound its cost per octet consumed.
pub const combine_bits_min = 32768;

/// The input octets a call must hold, at least, after a block's header, for the block's tables to
/// combine before `combine_bits_min` bits: a call whose input holds this much is decoding a long
/// stream. Once per call, which bounds its cost by a constant per call.
pub const combine_input_min = 16384;

/// The code lengths a dynamic block's header writes: the code length code's and the block's own.
pub const code_lengths_len = literal_length_alphabet_len + distance_alphabet_len;

/// The most code lengths a dynamic block's header gives: HLIT + 257 is 286 at most, and HDIST + 1
/// is 32 (RFC 1951 §3.2.7).
pub const header_lengths_max = literal_length_used + distance_alphabet_len;

/// The most copies of the previous length one repeat gives: symbol 16's (RFC 1951 §3.2.7).
pub const repeat_previous_count_max = repeat_count_max[0];

/// Invariant 17's count for one dynamic block's header, at most: every code length cleared, each
/// of the code length code's written, each of the block's written, the three codes built, the code
/// length code's table and its lengths cleared again for the code lengths' loop (S13), and the
/// fast path's two lookup tables.
pub const block_table_work_max = code_lengths_len + code_length_alphabet_len +
    (literal_length_used + distance_alphabet_len) + build_work_max(code_length_alphabet_len) +
    build_work_max(literal_length_used) + build_work_max(distance_alphabet_len) +
    code_length_table_work_max + code_length_alphabet_len +
    table_build_work_max(literal_length_table_bits, literal_length_used) +
    table_build_work_max(distance_table_bits, distance_alphabet_len);

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

/// The combinations' work spread over the bits that pay for each (`combine_bits_min`).
pub const combine_work_per_octet_max = std.math.divCeil(usize, combination_work_max(literal_length_table_bits) * @bitSizeOf(u8), combine_bits_min) catch unreachable;

/// Invariant 17's bound per octet consumed: the table work, the combinations' work, and one symbol
/// decoded per bit, since every symbol the decoder accepts takes a bit.
pub const work_per_octet_max = table_work_per_octet_max + combine_work_per_octet_max + @bitSizeOf(u8);

/// The most symbols one step decodes: a literal/length symbol and a distance.
pub const decodes_per_step_max = 2;

/// Invariant 17's bound per call, beyond `work_per_octet_max` per octet consumed: a call can
/// finish the table work of a block whose bits an earlier call consumed and start the next one's,
/// make a combination whose bits earlier calls decoded and one for its long input
/// (`combine_input_min`), decode a symbol per bit the state carried in, and decode the symbols of a
/// step it ends on for want of bits.
pub const work_per_call_max = 2 * block_table_work_max + 2 * combination_work_max(literal_length_table_bits) +
    codec.constants.bit_buffer_bits + decodes_per_step_max;

/// The encoder's window: the 32 KiB of history its matches reach, and 32 KiB of input ahead of the
/// position it encodes (decision 12).
pub const encoder_window_len = 2 * window_len;

/// The octets level 6's window array holds past `encoder_window_len`, which no read reaches. A
/// chain walk loads 4 octets at a candidate, a `u16` position, plus an offset into the match, a
/// `u8`, and compares up to `match_len_max` octets from the candidate. With these octets every such
/// load lies inside the array whatever those values are, so the compiler drops its bounds check.
/// Level 6's walks run inline in its lazy loop. Level 9's walk is a call, and without the check
/// x86-64 kept the walk's candidate on the stack across the call inside it (design §8 step 9);
/// level 1 walks no chain.
pub const encoder_window_padding_len = std.math.maxInt(u8) + match_len_taken_min - 1;

comptime {
    const array_len = encoder_window_len + encoder_window_padding_len;
    assert(std.math.maxInt(u16) + std.math.maxInt(u8) + match_len_taken_min <= array_len);
    assert(std.math.maxInt(u16) + match_len_max <= array_len);
}

/// The alignment of the encoder's hot functions: a 64-octet line, so that a function's loops sit
/// where its own code puts them, and not where the functions before it end, which every change to
/// them moves. Decision 44's checks changed no instruction of the match finder's loops and started
/// three of them 16 or 32 octets into the lines main starts them on: an EPYC 7763 ran five files
/// 1.3% to 5% slower at level 1, whose output was main's, in both runs (37168945298 and
/// 37168947275), and none once the functions started on lines (37173839885).
pub const hot_function_alignment = 64;

/// The octets the encoder's hash reads at a position (decision 14, E1).
pub const hash_len = 4;

/// The input ahead of a position the encoder needs before it decides that position's symbol: a
/// longest match, and the hash of the last position the match covers. With less, it waits for input
/// unless the caller flushes or finishes, so how the caller splits its input changes no output
/// octet (invariant 5).
pub const lookahead_min = match_len_max + hash_len;

/// The farthest distance the encoder takes: the window, less the `lookahead_min` of history a slide
/// of the window can drop. Every candidate this near stays in the window wherever a slide falls, so
/// the slides change no match (invariant 5).
pub const encoder_distance_max = window_len - lookahead_min;

/// The multiplier of the encoder's hash of 4 octets: 2^32 over the golden ratio, whose product
/// spreads the octets' bits across the high bits the hash keeps (decision 14, E1).
pub const hash_multiplier: u32 = 0x9e37_79b1;

/// The shortest match the encoder takes: the octets its hash covers. A shorter one comes only from
/// a hash collision, and three literals cost about what it does.
pub const match_len_taken_min = hash_len;

/// The symbols a block holds before the encoder ends it (decision 12).
pub const block_symbols_max = 16384;

/// The symbols a block takes between two checks of whether its newest ones code in fewer bits in a
/// block of their own, at a level that checks (decision 44). A block a check ends holds this many
/// symbols or more, unless a slide of the window, a flush or the stream's end cut its first
/// symbols short, and `encoded_len_max` counts those blocks apart.
pub const block_chunk_symbols = 4096;

/// What a check of decision 44 counts for a dynamic header (RFC 1951 §3.2.7): bits for each symbol
/// with a code, which its length takes in the header, and bits for the rest of the header.
pub const header_estimate_symbol_bits = 5;
pub const header_estimate_bits = 40;

/// A check of fewer than `block_chunk_symbols` newest symbols, at a slide or a flush or the end,
/// ends the block before them only when apart saves this fraction of their price together, 1 in
/// this many: few symbols' entropy undercounts what their codes cost (decision 44).
pub const partial_chunk_margin_divisor = 256;

/// The bound on an encoder call's steps (invariant 9): each step takes input, writes output,
/// decides positions into the block, checks the block's newest symbols, or ends a block, and a
/// call checks and ends at most a few blocks of the input its window already held.
pub const encoder_steps_per_octet = 8;
pub const encoder_steps_floor = 64;

/// The longest code of the code length code (RFC 1951 §3.2.7).
pub const code_length_code_len_max = 7;

/// The most octets one stored block holds: LEN takes 16 bits (RFC 1951 §3.2.4).
pub const stored_len_max = std.math.maxInt(u16);

// The encoder's levels and the limits of their searches: constants_levels.zig holds them, a piece
// of this file, and each of their names is one of this file's.
const levels = @import("constants_levels.zig");
pub const Level = levels.Level;
pub const cost_eighths_per_bit = levels.cost_eighths_per_bit;
pub const cheap_literal_cost_max = levels.cheap_literal_cost_max;
pub const priced_len_max = levels.priced_len_max;
pub const lazy_distance_penalty_bounds = levels.lazy_distance_penalty_bounds;
pub const lazy_distance_penalty_octets = levels.lazy_distance_penalty_octets;
pub const tail_skips_max = levels.tail_skips_max;
pub const three_hash_bits = levels.three_hash_bits;
pub const three_distance_max = levels.three_distance_max;
pub const dear_literal_cost_min = levels.dear_literal_cost_min;
pub const dear_symbol_cost_min = levels.dear_symbol_cost_min;
pub const three_saving_divisor = levels.three_saving_divisor;
pub const three_wait_max = levels.three_wait_max;
pub const three_wait_growth = levels.three_wait_growth;
pub const encoder_levels = levels.encoder_levels;
pub const level = levels.level;

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
    // Four length codes each take 1 to 5 extra bits (RFC 1951 §3.2.5).
    assert(resolved_length_entries_max == 4 * (2 + 4 + 8 + 16 + 32));
    // A block that crossed no slide holds at most the window's input, which one stored block holds.
    assert(encoder_window_len - lookahead_min <= stored_len_max);
    assert(block_symbols_max * @sizeOf(u32) + encoder_window_len <= level(1).state_budget_len);
    // A block's checks fall between its first symbol and its last.
    assert(block_chunk_symbols < block_symbols_max and block_symbols_max % block_chunk_symbols == 0);
    assert(code_length_symbols_min == 2);
    assert(header_lengths_max <= code_lengths_len);
    assert(repeat_previous_count_max == 6);
    assert(dynamic_block_bits_min == 32);
    // A length of the code length code takes 3 bits, so its codes take 7 at most (RFC 1951 §3.2.7),
    // and a symbol with a repeat's 7 extra bits 14.
    assert(code_length_code_len_max == (1 << code_length_code_bits) - 1);
    assert(code_length_symbol_bits == 14);
    for (repeat_extra_bits, repeat_count_min, repeat_count_max) |extra, min, max| {
        assert(max == min + (1 << extra) - 1);
    }
}
