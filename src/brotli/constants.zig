//! The limits RFC 7932 fixes for a brotli stream.
const std = @import("std");

/// The largest WBITS a stream header may carry (RFC 7932 §9.1).
pub const window_bits_max: u6 = 24;

/// The farthest a non-dictionary back-reference reaches: (1 << WBITS) - 16 (RFC 7932 §9.1).
pub const window_len_max: usize = (1 << window_bits_max) - 16;

comptime {
    std.debug.assert(window_len_max == 16 * 1024 * 1024 - 16);
}

/// DICT's length and CRC-32 as RFC 7932 Appendix A states them (claim B1).
pub const dictionary_len = 122_784;
pub const dictionary_crc32: u32 = 0x5136cb04;

/// The shortest and the longest static dictionary word (RFC 7932 §8).
pub const word_len_min = 4;
pub const word_len_max = 24;

/// The number of word transformations, and the length and CRC-32 of the octets RFC 7932 Appendix B
/// serializes them to: each prefix and a zero, the elementary transform's value, each suffix and a
/// zero (claim B1).
pub const transforms_count = 121;
pub const transforms_serialized_len = 648;
pub const transforms_crc32: u32 = 0x3d965f81;

/// The most octets a transformation adds to a base word (RFC 7932 §8), and so the longest word a
/// dictionary reference writes.
pub const transform_added_len_max = 13;
pub const transformed_word_len_max = word_len_max + transform_added_len_max;

/// Ferment's classes of octet (RFC 7932 §8): below 192, a whole UTF-8 character; below 224, the
/// first of two octets; otherwise, the first of three.
pub const ferment_two_octets_min = 192;
pub const ferment_three_octets_min = 224;

/// The octets of a character Ferment steps over past an ASCII one: two for a lead octet from
/// `ferment_two_octets_min`, three from `ferment_three_octets_min` (RFC 7932 §8).
pub const ferment_two_octets_len = 2;
pub const ferment_three_octets_len = 3;

/// What Ferment XORs into an octet (RFC 7932 §8): 32 swaps the case of an ASCII letter or of a
/// two-octet character, and 5 changes the third octet of a three-octet one.
pub const ferment_case_xor = 32;
pub const ferment_third_octet_xor = 5;

comptime {
    std.debug.assert(transformed_word_len_max == 37);
}

/// Lut0, Lut1 and Lut2 each hold one entry per octet value, with the CRC-32 RFC 7932 §7.1 states for
/// each (claim B2).
pub const lut_len = 256;
pub const lut0_crc32: u32 = 0x8e91efb7;
pub const lut1_crc32: u32 = 0xd01a32f4;
pub const lut2_crc32: u32 = 0x0dd7a0d6;

/// A literal's context ID takes 6 bits, 0 to 63, and a distance's one of 4 values (RFC 7932 §7.1,
/// §7.2).
pub const literal_context_bits = 6;
pub const literal_contexts_count = 1 << literal_context_bits;
pub const distance_contexts_count = 4;

/// MSB6 takes p1's six most significant bits: p1 shifted right by 2 (RFC 7932 §7.1).
pub const msb6_shift = @bitSizeOf(u8) - literal_context_bits;

/// Signed puts Lut2[p1] above Lut2[p2], 3 bits up (RFC 7932 §7.1).
pub const signed_shift = 3;

/// The copy length from which every distance takes the last context ID, 3 (RFC 7932 §7.2): copy
/// lengths 2, 3 and 4 take IDs 0, 1 and 2.
pub const distance_context_copy_len_min = 2;
pub const distance_context_last_copy_len = 5;

/// The longest code of a symbol's prefix code: code lengths run 0 to 15 (RFC 7932 §3.5).
pub const code_len_max = 15;

/// The code length alphabet: lengths 0 to 15, 16 to repeat the previous length and 17 to repeat a
/// zero (RFC 7932 §3.5).
pub const code_length_alphabet_len = 18;

/// The longest code of the code length code: its code lengths run 0 to 5 (RFC 7932 §3.5).
pub const code_length_code_len_max = 5;

/// The alphabets of RFC 7932 §3.3 whose sizes the format fixes.
pub const literal_alphabet_len = 256;
pub const insert_copy_alphabet_len = 704;
pub const block_count_alphabet_len = 26;

/// The most block types of a category and the most prefix trees of a context map: NBLTYPESx and
/// NTREESx run 1 to 256 (RFC 7932 §9.2), so a block type code's alphabet takes up to 258 symbols.
pub const block_types_max = 256;
pub const trees_max = 256;
pub const block_type_alphabet_len_max = block_types_max + block_type_symbol_offset;

/// The distance parameters of RFC 7932 §4: NPOSTFIX 0 to 3, NDIRECT 0 to 120 in steps of
/// 1 << NPOSTFIX, and the largest alphabet they give, 16 + NDIRECT + (48 << NPOSTFIX).
pub const postfix_bits_max = 3;
pub const direct_count_max = 120;
pub const distance_short_codes_count = 16;
pub const distance_extra_bits_max = 24;
pub const distance_code_groups = 48;
pub const distance_alphabet_len_max = distance_short_codes_count + direct_count_max + (distance_code_groups << postfix_bits_max);

/// RLEMAX of a context map, 0 to 16 (RFC 7932 §7.3), and so the largest alphabet of a context map's
/// prefix code.
pub const run_length_codes_max = 16;
pub const context_map_alphabet_len_max = trees_max + run_length_codes_max;

/// The ring of last distances and the values it starts from: last 4, then 11, 15 and 16 (RFC 7932
/// §4).
pub const last_distances_count = 4;
pub const last_distances_initial = [last_distances_count]u32{ 4, 11, 15, 16 };

/// Each short distance code, 0 to 15, as the last distance it starts from, 0 for the last and 1 for
/// the one before, and what it adds to that distance (RFC 7932 §4).
pub const distance_short_codes = [distance_short_codes_count]struct { last: u2, delta: i3 }{
    .{ .last = 0, .delta = 0 },  .{ .last = 1, .delta = 0 }, .{ .last = 2, .delta = 0 },  .{ .last = 3, .delta = 0 },
    .{ .last = 0, .delta = -1 }, .{ .last = 0, .delta = 1 }, .{ .last = 0, .delta = -2 }, .{ .last = 0, .delta = 2 },
    .{ .last = 0, .delta = -3 }, .{ .last = 0, .delta = 3 }, .{ .last = 1, .delta = -1 }, .{ .last = 1, .delta = 1 },
    .{ .last = 1, .delta = -2 }, .{ .last = 1, .delta = 2 }, .{ .last = 1, .delta = -3 }, .{ .last = 1, .delta = 3 },
};

/// A length code's first length and extra bits, as the tables of RFC 7932 §5 and §6 give them.
pub const LengthCode = struct { base: u32, extra_bits: u5 };

/// The insert length codes, 0 to 23 (RFC 7932 §5).
pub const insert_length_codes = [_]LengthCode{
    .{ .base = 0, .extra_bits = 0 },     .{ .base = 1, .extra_bits = 0 },     .{ .base = 2, .extra_bits = 0 },
    .{ .base = 3, .extra_bits = 0 },     .{ .base = 4, .extra_bits = 0 },     .{ .base = 5, .extra_bits = 0 },
    .{ .base = 6, .extra_bits = 1 },     .{ .base = 8, .extra_bits = 1 },     .{ .base = 10, .extra_bits = 2 },
    .{ .base = 14, .extra_bits = 2 },    .{ .base = 18, .extra_bits = 3 },    .{ .base = 26, .extra_bits = 3 },
    .{ .base = 34, .extra_bits = 4 },    .{ .base = 50, .extra_bits = 4 },    .{ .base = 66, .extra_bits = 5 },
    .{ .base = 98, .extra_bits = 5 },    .{ .base = 130, .extra_bits = 6 },   .{ .base = 194, .extra_bits = 7 },
    .{ .base = 322, .extra_bits = 8 },   .{ .base = 578, .extra_bits = 9 },   .{ .base = 1090, .extra_bits = 10 },
    .{ .base = 2114, .extra_bits = 12 }, .{ .base = 6210, .extra_bits = 14 }, .{ .base = 22594, .extra_bits = 24 },
};

/// The copy length codes, 0 to 23 (RFC 7932 §5).
pub const copy_length_codes = [_]LengthCode{
    .{ .base = 2, .extra_bits = 0 },   .{ .base = 3, .extra_bits = 0 },     .{ .base = 4, .extra_bits = 0 },
    .{ .base = 5, .extra_bits = 0 },   .{ .base = 6, .extra_bits = 0 },     .{ .base = 7, .extra_bits = 0 },
    .{ .base = 8, .extra_bits = 0 },   .{ .base = 9, .extra_bits = 0 },     .{ .base = 10, .extra_bits = 1 },
    .{ .base = 12, .extra_bits = 1 },  .{ .base = 14, .extra_bits = 2 },    .{ .base = 18, .extra_bits = 2 },
    .{ .base = 22, .extra_bits = 3 },  .{ .base = 30, .extra_bits = 3 },    .{ .base = 38, .extra_bits = 4 },
    .{ .base = 54, .extra_bits = 4 },  .{ .base = 70, .extra_bits = 5 },    .{ .base = 102, .extra_bits = 5 },
    .{ .base = 134, .extra_bits = 6 }, .{ .base = 198, .extra_bits = 7 },   .{ .base = 326, .extra_bits = 8 },
    .{ .base = 582, .extra_bits = 9 }, .{ .base = 1094, .extra_bits = 10 }, .{ .base = 2118, .extra_bits = 24 },
};

/// The block count codes, 0 to 25 (RFC 7932 §6).
pub const block_count_codes = [_]LengthCode{
    .{ .base = 1, .extra_bits = 2 },     .{ .base = 5, .extra_bits = 2 },      .{ .base = 9, .extra_bits = 2 },
    .{ .base = 13, .extra_bits = 2 },    .{ .base = 17, .extra_bits = 3 },     .{ .base = 25, .extra_bits = 3 },
    .{ .base = 33, .extra_bits = 3 },    .{ .base = 41, .extra_bits = 3 },     .{ .base = 49, .extra_bits = 4 },
    .{ .base = 65, .extra_bits = 4 },    .{ .base = 81, .extra_bits = 4 },     .{ .base = 97, .extra_bits = 4 },
    .{ .base = 113, .extra_bits = 5 },   .{ .base = 145, .extra_bits = 5 },    .{ .base = 177, .extra_bits = 5 },
    .{ .base = 209, .extra_bits = 5 },   .{ .base = 241, .extra_bits = 6 },    .{ .base = 305, .extra_bits = 6 },
    .{ .base = 369, .extra_bits = 7 },   .{ .base = 497, .extra_bits = 8 },    .{ .base = 753, .extra_bits = 9 },
    .{ .base = 1265, .extra_bits = 10 }, .{ .base = 2289, .extra_bits = 11 },  .{ .base = 4337, .extra_bits = 12 },
    .{ .base = 8433, .extra_bits = 13 }, .{ .base = 16625, .extra_bits = 24 },
};

/// The last length each table's last code reaches, as RFC 7932 §5 and §6 print them.
pub const insert_len_max = 16_799_809;
pub const copy_len_max = 16_779_333;
pub const block_count_max = 16_793_840;

comptime {
    // Each table's ranges follow one another with no gap, up to the last length the RFC prints.
    for ([_]struct { []const LengthCode, u32, u32 }{
        .{ &insert_length_codes, 0, insert_len_max },
        .{ &copy_length_codes, 2, copy_len_max },
        .{ &block_count_codes, 1, block_count_max },
    }) |table| {
        var next = table[1];
        for (table[0]) |code| {
            std.debug.assert(code.base == next);
            next = code.base + (@as(u32, 1) << code.extra_bits);
        }
        std.debug.assert(next - 1 == table[2]);
    }
    std.debug.assert(insert_length_codes.len == 24 and copy_length_codes.len == 24);
    std.debug.assert(block_count_codes.len == block_count_alphabet_len);
}

/// The insert-and-copy length symbols of RFC 7932 §5 come in cells of 64: each cell gives the first
/// insert length code and the first copy length code of its symbols, and bits 3 to 5 and 0 to 2 of
/// a symbol add to them. Symbols below 128 take the last distance as their distance.
pub const insert_copy_cell_bits = 6;
pub const insert_copy_code_bits = 3;
pub const insert_copy_cells = [_]struct { insert: u5, copy: u5 }{
    .{ .insert = 0, .copy = 0 },  .{ .insert = 0, .copy = 8 },   .{ .insert = 0, .copy = 0 },
    .{ .insert = 0, .copy = 8 },  .{ .insert = 8, .copy = 0 },   .{ .insert = 8, .copy = 8 },
    .{ .insert = 0, .copy = 16 }, .{ .insert = 16, .copy = 0 },  .{ .insert = 8, .copy = 16 },
    .{ .insert = 16, .copy = 8 }, .{ .insert = 16, .copy = 16 },
};
pub const insert_copy_last_distance_symbols = 128;

comptime {
    std.debug.assert(insert_copy_cells.len << insert_copy_cell_bits == insert_copy_alphabet_len);
}

/// The window's size is (1 << WBITS) - 16 (RFC 7932 §9.1), with WBITS 10 to 24.
pub const window_bits_min = 10;
pub const window_len_gap = 16;

/// WBITS's code (RFC 7932 §9.1): a 0 bit is 16; else three bits n above it give 17 + n when n is
/// not 0; else three more m give 8 + m, 17 for m = 0, and the invalid pattern for m = 1, which RFC
/// 9841 §6 makes the start of a large window's signature when an eighth bit of 0 follows.
pub const window_bits_short = 16;
pub const window_bits_medium_base = 17;
pub const window_bits_long_base = 8;
pub const window_bits_field_bits = 3;
pub const window_bits_large_signature_m = 1;

/// MNIBBLES's code (RFC 7932 §9.2): 2 bits, 3 for 0 nibbles and n for n + 4 nibbles. MLEN - 1
/// takes MNIBBLES nibbles, and MSKIPLEN - 1 MSKIPBYTES octets.
pub const nibbles_field_bits = 2;
pub const nibbles_metadata_code = 3;
pub const nibbles_min = 4;
pub const nibble_bits = 4;
pub const skip_bytes_field_bits = 2;

/// The largest MLEN: 1 << 24 octets, 6 nibbles of MLEN - 1 (RFC 7932 §9.2).
pub const meta_block_len_max = 1 << 24;

/// The block count a category with one block type starts from, which no meta-block exhausts (RFC
/// 7932 §10).
pub const block_count_single_type = 16_777_216;

/// NBLTYPESx's and NTREESx's code (RFC 7932 §9.2): a 0 bit is 1; else three bits n above it, and n
/// bits above those, give (1 << n) + 1 + the n bits.
pub const count_field_bits = 3;

/// The context mode of a literal block type takes 2 bits (RFC 7932 §7.1), NPOSTFIX 2 and the four
/// most significant bits of NDIRECT 4 (RFC 7932 §9.2).
pub const context_mode_bits = 2;
pub const postfix_field_bits = 2;
pub const direct_field_bits = 4;

/// RLEMAX's code (RFC 7932 §7.3): a 0 bit is 0; else four bits above it give RLEMAX - 1.
pub const run_length_field_bits = 4;

/// A simple prefix code (RFC 7932 §3.4): the 2 bits that start every prefix code are 1 for a simple
/// one and otherwise HSKIP; NSYM - 1 takes 2 bits, and NSYM runs 1 to 4.
pub const prefix_kind_bits = 2;
pub const prefix_kind_simple = 1;
pub const simple_count_bits = 2;
pub const simple_symbols_max = 4;

/// The complex code's code length code (RFC 7932 §3.5): its lengths come in this order of code
/// length symbols, their sum of 32 >> length must reach 32, and the symbol lengths' sum of 32768 >>
/// length must reach 32768. A repeat of the previous length takes 2 extra bits and starts from 3,
/// and a repeat of zeros 3 and starts from 3; before any length, the previous length is 8.
pub const code_length_code_order = [code_length_alphabet_len]u8{ 1, 2, 3, 4, 0, 5, 17, 6, 16, 7, 8, 9, 10, 11, 12, 13, 14, 15 };
pub const code_length_code_space = 32;
pub const code_lengths_space = 32768;
pub const repeat_previous_symbol = 16;
pub const repeat_zero_symbol = 17;
pub const repeat_previous_extra_bits = 2;
pub const repeat_zero_extra_bits = 3;
pub const repeat_len_min = 3;
pub const previous_len_initial = 8;

/// The steps one decoding call takes at most, per bit of its input and octet of its output, and
/// beyond them: each step takes a bit, writes an octet, or moves between phases a bounded number of
/// times before one that does.
pub const decoder_steps_per_unit = 8;
pub const decoder_steps_floor = 64;

/// The fixed code of the code length code's lengths takes 2 to 4 bits (RFC 7932 §3.5).
pub const code_length_code_length_bits_max = 4;

/// The fixed code of the code length code's lengths, 0 to 5 in turn (RFC 7932 §3.5): each code as
/// the RFC prints it, first bit rightmost, so it matches the stream's bits least significant first.
pub const CodeLengthCodeLengthCode = struct { code: u4, len: u3 };
pub const code_length_code_length_codes = [_]CodeLengthCodeLengthCode{
    .{ .code = 0b00, .len = 2 }, .{ .code = 0b0111, .len = 4 }, .{ .code = 0b011, .len = 3 },
    .{ .code = 0b10, .len = 2 }, .{ .code = 0b01, .len = 2 },   .{ .code = 0b1111, .len = 4 },
};

/// A code built from code lengths has two symbols or more: a code of one symbol takes no bits (RFC
/// 7932 §3.4, §3.5).
pub const code_symbols_min = 2;

/// A simple code's lengths in the order of its symbols (RFC 7932 §3.4): for NSYM 2, 3 and 4, and for
/// NSYM 4 with the tree-select bit set.
pub const simple_code_lengths = [_][]const u8{ &.{ 1, 1 }, &.{ 1, 2, 2 }, &.{ 2, 2, 2, 2 } };
pub const simple_code_lengths_tree_select = [_]u8{ 1, 2, 3, 3 };

/// A repeated code 16 or 17 makes the count factor * (count - 2) plus its own (RFC 7932 §3.5).
pub const repeat_count_offset = 2;

/// ISLAST and ISLASTEMPTY, the first two bits of a last meta-block's header (RFC 7932 §9.2).
pub const last_flags_bits = 2;

/// A category has block-switch codes when it has two block types or more, and a context map is
/// coded when it has two trees or more (RFC 7932 §9.2).
pub const block_switch_types_min = 2;
pub const context_map_trees_min = 2;

/// Block type codes 2 to 257 are the block types 0 to 255 (RFC 7932 §6), so a block type code's
/// alphabet has NBLTYPES + 2 symbols.
pub const block_type_symbol_offset = 2;

/// A coded distance's offset, ((2 + (hcode & 1)) << ndistbits) - 4 (RFC 7932 §4).
pub const coded_distance_base = 2;
pub const coded_distance_bias = 4;

/// The octets a decoder takes beside its window's octets (decision 12): the ring's two counters and
/// the checked path's state, of which the prefix codes of every tree take 783,872 and the context
/// maps 17,408. Pinned, so that the state grows only by a change of this line.
pub const decoder_state_len = 805_016;
