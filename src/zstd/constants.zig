//! The limits and tables RFC 8878 and RFC 9659 fix for Zstandard.
const std = @import("std");
const assert = std.debug.assert;

/// The Window_Size every decoder of the `zstd` content coding must support, and the most an
/// encoder of it may require (RFC 9659 §3). The RFC writes "8 MB". Decision 12 reads it as 2^23
/// octets for a decoder, which covers both readings of "MB", 10^6 octets and 2^20.
pub const http_window_len: u64 = 8 * 1024 * 1024;

/// The most octets one block holds, compressed or decompressed: Block_Maximum_Size is the smaller
/// of Window_Size and 128 KB (RFC 8878 §3.1.1.2.4).
pub const block_len_max: usize = 128 * 1024;

/// A Zstandard frame's Magic_Number, and the first and last of a skippable frame's, each read
/// least significant octet first (RFC 8878 §3.1.1, §3.1.2).
pub const frame_magic: u32 = 0xFD2FB528;
pub const skippable_magic_first: u32 = 0x184D2A50;
pub const skippable_magic_last: u32 = 0x184D2A5F;

/// The bits of a skippable frame's Magic_Number that vary, all in its first octet (RFC 8878
/// §3.1.2).
pub const skippable_magic_variable_mask: u8 = 0x0F;

comptime {
    assert(skippable_magic_last - skippable_magic_first == skippable_magic_variable_mask);
}

/// The octets of a Magic_Number, and of a skippable frame's Frame_Size (RFC 8878 §3.1.2).
pub const magic_len = 4;
pub const skippable_size_len = 4;

/// The longest Frame_Header: its descriptor, Window_Descriptor, a 4-octet Dictionary_ID and an
/// 8-octet Frame_Content_Size (RFC 8878 §3.1.1.1).
pub const frame_header_len_max = 14;

/// Frame_Header_Descriptor's fields (RFC 8878 §3.1.1.1.1, Table 3).
pub const descriptor_content_size_shift = 6;
pub const descriptor_single_segment: u8 = 0x20;
pub const descriptor_reserved: u8 = 0x08;
pub const descriptor_checksum: u8 = 0x04;
pub const descriptor_dictionary_mask: u8 = 0x03;

/// FCS_Field_Size for each Frame_Content_Size_Flag, the flag 0 taking 1 octet only with
/// Single_Segment_Flag (RFC 8878 §3.1.1.1.1.1, Table 4).
pub const content_size_field_lens = [_]u8{ 0, 2, 4, 8 };

/// What a 2-octet Frame_Content_Size adds to the value it holds (RFC 8878 §3.1.1.1.4).
pub const content_size_two_octet_offset = 256;
pub const content_size_offset_field_len = 2;

/// What the decoder holds besides its window: a gathered block and its literals, each
/// Block_Maximum_Size, and 32 KiB for its Huffman and FSE tables (decision 12).
pub const decoder_state_extra_len = 2 * block_len_max + 32 * 1024;

/// A decoding call's steps: a few per octet it reads or writes, as a step reads or writes an octet
/// or moves to the next part, plus a few to end a frame.
pub const decoder_steps_per_octet = 4;
pub const decoder_steps_floor = 16;

/// The passes one call of a block's execution takes at most: each copies an octet or decodes a
/// sequence, and a block holds at most Block_Maximum_Size of each.
pub const block_execute_passes_max = 2 * block_len_max + 2;

/// DID_Field_Size for each Dictionary_ID_Flag (RFC 8878 §3.1.1.1.1.6, Table 5).
pub const dictionary_id_field_lens = [_]u8{ 0, 1, 2, 4 };

/// Window_Descriptor: Exponent in its top 5 bits and Mantissa in its low 3, with windowLog =
/// 10 + Exponent and windowAdd = (windowBase / 8) * Mantissa (RFC 8878 §3.1.1.1.2).
pub const window_exponent_shift = 3;
pub const window_mantissa_mask: u8 = 0x07;
pub const window_log_min = 10;
pub const window_mantissa_shift = 3;

/// The octets of a Block_Header, and its fields, least significant octet first (RFC 8878
/// §3.1.1.2, Table 9).
pub const block_header_len = 3;
pub const block_last_mask: u32 = 0x1;
pub const block_type_shift = 1;
pub const block_type_mask: u32 = 0x3;
pub const block_size_shift = 3;

/// The octets of a Content_Checksum (RFC 8878 §3.1.1).
pub const checksum_len = 4;

/// The longest Huffman code (RFC 8878 §4.2.1), and so the widest Huffman decoding table.
pub const huffman_bits_max = 11;

/// The literal values a Huffman tree covers, 0 to 255 (RFC 8878 §4.2.1.2).
pub const literal_symbols = 256;

/// A Huffman_Tree_Description's header byte: below this, the weights are FSE-compressed in that
/// many octets; from it, Number_of_Symbols = headerByte - 127 weights follow, two to an octet
/// (RFC 8878 §4.2.1.1).
pub const huffman_direct_header_min = 128;
pub const huffman_direct_symbols_offset = 127;

/// The largest accuracy log of the FSE table that compresses Huffman weights (RFC 8878 §4.2.1.2).
pub const huffman_weights_accuracy_log_max = 6;

/// The largest Weight, as a Huffman code is at most `huffman_bits_max` bits long
/// (RFC 8878 §4.2.1).
pub const huffman_weight_max = huffman_bits_max;

/// An FSE table description's Accuracy_Log is its first 4 bits plus this (RFC 8878 §4.1.1).
pub const accuracy_log_field_bits = 4;
pub const accuracy_log_offset = 5;

/// The fewest symbols of nonzero probability an FSE distribution holds (RFC 8878 §4.1.1).
pub const fse_symbols_present_min = 2;

/// The step of RFC 8878 §4.1.1's spread: (tableSize >> 1) + (tableSize >> 3) + 3.
pub const fse_spread_half_shift = 1;
pub const fse_spread_eighth_shift = 3;
pub const fse_spread_add = 3;

/// An FSE description's zero-probability repeat flag: 2 bits, a 3 saying another flag follows
/// (RFC 8878 §4.1.1).
pub const fse_repeat_flag_bits = 2;
pub const fse_repeat_flag_more = 3;

/// A directly written Huffman weight: 4 bits, two to an octet, the first in the top half
/// (RFC 8878 §4.2.1.1).
pub const huffman_weight_bits = 4;
pub const huffman_weights_per_octet = 2;
pub const huffman_weight_mask: u8 = 0xf;

/// The largest accuracy log of each sequence table (RFC 8878 §3.1.1.3.2.1), and the widest FSE
/// table any of them builds.
pub const literals_length_accuracy_log_max = 9;
pub const match_length_accuracy_log_max = 9;
pub const offset_accuracy_log_max = 8;
pub const accuracy_log_max = 9;

/// The symbols of each sequence code: literals length codes 0 to 35, match length codes 0 to 52
/// (RFC 8878 §3.1.1.3.2.1.1).
pub const literals_length_symbols = 36;
pub const match_length_symbols = 53;

/// The largest offset code the decoder takes: 31, as the reference decoder supports and RFC 8878
/// §3.1.1.3.2.1.1 allows a decoder to limit N. Past the window, an offset is refused anyway.
pub const offset_code_max = 31;
pub const offset_symbols = offset_code_max + 1;

/// The Literals_Section_Header's fields (RFC 8878 §3.1.1.3.1.1).
pub const literals_type_mask: u8 = 0x3;
pub const literals_size_format_shift = 2;
pub const literals_size_format_mask: u8 = 0x3;

/// The widths of a Huffman-coded literals section's Regenerated_Size and Compressed_Size, and the
/// streams it holds, by Size_Format (RFC 8878 §3.1.1.3.1.1).
pub const literals_compressed_size_bits = [_]u5{ 10, 10, 14, 18 };
pub const literals_compressed_streams = [_]u8{ 1, literal_streams, literal_streams, literal_streams };

/// The two sizes a Huffman-coded literals section's header holds: Regenerated_Size and
/// Compressed_Size (RFC 8878 §3.1.1.3.1.1).
pub const literals_compressed_sizes = 2;

/// The octets of a Jump_Table, and the fewest a 4-stream literals section's Compressed_Size may
/// hold: its jump table, or Stream4_Size underflows (RFC 8878 §3.1.1.3.1.6, erratum 7297).
pub const jump_table_len = 6;
pub const four_streams_len_min = jump_table_len;

/// The literal streams of a 4-stream Huffman-coded literals section (RFC 8878 §3.1.1.3.1.6).
pub const literal_streams = 4;

/// Number_of_Sequences: one octet below 128, two below 255, three from 255 with 0x7F00 added
/// (RFC 8878 §3.1.1.3.2.1).
pub const sequences_one_octet_max = 127;
pub const sequences_two_octet_max = 254;
pub const sequences_long_offset = 0x7F00;
pub const sequences_two_octet_base = 128;

/// Symbol_Compression_Modes: each mode's shift, the mask of a mode, and the reserved low bits
/// (RFC 8878 §3.1.1.3.2.1, Table 14).
pub const literals_length_mode_shift = 6;
pub const offset_mode_shift = 4;
pub const match_length_mode_shift = 2;
pub const mode_mask: u8 = 0x3;
pub const modes_reserved_mask: u8 = 0x3;

/// The starting Repeated_Offsets (RFC 8878 §3.1.1.5).
pub const repeated_offsets_initial = [3]u32{ 1, 4, 8 };

/// Offset_Values 1 to 3 name a Repeated_Offset; above 3, the offset is Offset_Value - 3 (RFC 8878
/// §3.1.1.4).
pub const repeat_offset_values = 3;

/// Each literals length code's Baseline and Number_of_Bits (RFC 8878 §3.1.1.3.2.1.1, Table 16).
pub const literals_length_baselines = [literals_length_symbols]u32{
    0,    1,     2,     3,     4,  5,  6,  7,  8,  9,  10,  11,  12,  13,   14,   15,
    16,   18,    20,    22,    24, 28, 32, 40, 48, 64, 128, 256, 512, 1024, 2048, 4096,
    8192, 16384, 32768, 65536,
};
pub const literals_length_extra_bits = [literals_length_symbols]u5{
    0,  0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0,  0,
    1,  1,  1,  1,  2, 2, 3, 3, 4, 6, 7, 8, 9, 10, 11, 12,
    13, 14, 15, 16,
};

/// Each match length code's Baseline and Number_of_Bits (RFC 8878 §3.1.1.3.2.1.1, Table 17).
pub const match_length_baselines = [match_length_symbols]u32{
    3,    4,    5,     6,     7,     8,  9,  10, 11, 12, 13, 14,  15,  16,  17,   18,
    19,   20,   21,    22,    23,    24, 25, 26, 27, 28, 29, 30,  31,  32,  33,   34,
    35,   37,   39,    41,    43,    47, 51, 59, 67, 83, 99, 131, 259, 515, 1027, 2051,
    4099, 8195, 16387, 32771, 65539,
};
pub const match_length_extra_bits = [match_length_symbols]u5{
    0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0,
    0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0,
    1,  1,  1,  1,  2,  2, 3, 3, 4, 4, 5, 7, 8, 9, 10, 11,
    12, 13, 14, 15, 16,
};

/// The default distributions of the three sequence codes and their accuracy logs; -1 is a "less
/// than 1" probability (RFC 8878 §3.1.1.3.2.2).
pub const literals_length_default_accuracy_log = 6;
pub const literals_length_default = [literals_length_symbols]i16{
    4,  3,  2,  2,  2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1,
    2,  2,  2,  2,  2, 2, 2, 2, 2, 3, 2, 1, 1, 1, 1, 1,
    -1, -1, -1, -1,
};
pub const match_length_default_accuracy_log = 6;
pub const match_length_default = [match_length_symbols]i16{
    1,  4,  3,  2,  2,  2, 2, 2, 2, 1, 1, 1, 1, 1, 1,  1,
    1,  1,  1,  1,  1,  1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  1,
    1,  1,  1,  1,  1,  1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1,
    -1, -1, -1, -1, -1,
};
pub const offset_default_accuracy_log = 5;
pub const offset_default = [29]i16{
    1, 1, 1, 1, 1, 1, 2, 2, 2,  1,  1,  1,  1,  1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1,
};

comptime {
    assert(std.math.isPowerOfTwo(http_window_len));
    assert(block_len_max <= http_window_len);
    assert(literals_length_baselines[literals_length_symbols - 1] + (1 << literals_length_extra_bits[literals_length_symbols - 1]) - 1 == 131071);
    assert(match_length_baselines[match_length_symbols - 1] + (1 << match_length_extra_bits[match_length_symbols - 1]) - 1 == 131074);
    assert(literals_length_accuracy_log_max <= accuracy_log_max and offset_accuracy_log_max <= accuracy_log_max);
    for ([_][]const i16{ &literals_length_default, &match_length_default, &offset_default }, [_]u5{ literals_length_default_accuracy_log, match_length_default_accuracy_log, offset_default_accuracy_log }) |distribution, log| {
        var total: u32 = 0;
        for (distribution) |probability| total += if (probability < 0) 1 else @intCast(probability);
        assert(total == 1 << log);
    }
}
