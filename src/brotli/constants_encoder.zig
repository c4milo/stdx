//! The brotli encoder's limits and the fields of the meta-blocks it writes (decision 62). A piece
//! of constants.zig, which stays the module's entry point and gives every name here as its own.
const std = @import("std");
const constants = @import("constants.zig");

/// The most octets of input a meta-block takes: the shared prefix code builder counts symbols in
/// 16 bits, so a meta-block's counts stay below 65,536 (decision 62).
pub const encoder_meta_block_len_max = 65535;
/// The most commands a meta-block holds: each copies 4 octets at least, and one more inserts the
/// literals after the last match.
pub const encoder_commands_max = encoder_meta_block_len_max / 4 + 1;
/// A distance's code of 16 or more (RFC 7932 §4, NPOSTFIX and NDIRECT 0): distance + 3 lies from
/// 2 << ndistbits up to 4 << ndistbits.
pub const distance_offset = 3;
pub const distance_prefix_base = 2;
/// Two codes for each count of extra bits: the bit below distance + 3's top bit picks one.
pub const distance_codes_per_extra_bits = 2;
/// The categories of block types: literals, insert-and-copy lengths and distances (RFC 7932 §6).
pub const block_categories = 3;
/// The widths of a simple code's symbols (RFC 7932 §3.4): the bits that hold every symbol of the
/// alphabet.
pub const literal_alphabet_bits = 8;
pub const insert_copy_alphabet_bits = 10;
/// The encoder's distance alphabet, with NPOSTFIX and NDIRECT 0: 16 short codes and 48 with extra
/// bits (RFC 7932 §4), and the width of its symbols in a simple code.
pub const encoder_distance_alphabet_len = constants.distance_short_codes_count + constants.distance_code_groups;
pub const encoder_distance_alphabet_bits = 6;
/// NBLTYPESx and NTREESx of 1 take one 0 bit (RFC 7932 §9.2).
pub const encoder_count_one_bits = 1;
/// NTREESL and NTREESD: the counts of trees a meta-block's header gives (RFC 7932 §9.2).
pub const encoder_tree_counts = 2;
/// ISLAST and ISLASTEMPTY both set: the empty last meta-block (RFC 7932 §9.2).
pub const encoder_last_empty_flags = 0b11;
/// The nibbles of MLEN - 1 in every meta-block the encoder writes: a meta-block of 65,536 octets
/// or fewer (RFC 7932 §9.2).
pub const encoder_length_nibbles = 4;
/// WBITS of level 1 (decision 62, decision 12): a window of 2^18 octets.
pub const encoder_level1_window_bits = 18;
/// The fewest WBITS the encoder takes: a window that holds a whole meta-block.
pub const encoder_window_bits_min = constants.window_bits_short;
/// Level 1's match finder: one table of 2^15 entries, hashing 5 octets (decision 62).
pub const encoder_level1_hash_log = 15;
pub const encoder_level1_hash_len = 5;
/// The octets of the stream header: WBITS takes 7 bits at most (RFC 7932 §9.1).
pub const encoder_stream_header_len_max = 1;
/// The octets an uncompressed meta-block adds to its input: the bits a previous meta-block left,
/// 7 at most, and a header of 20 bits, padded to an octet (RFC 7932 §9.2).
pub const encoder_uncompressed_overhead = 5;
/// The octet of the empty last meta-block (RFC 7932 §9.2).
pub const encoder_last_len = 1;
/// The octets of the empty metadata meta-block a flush writes, with the bits before it.
pub const encoder_flush_len_max = 2;
/// The encoder's buffer: the stream header, a meta-block no longer than its uncompressed form,
/// and the empty last meta-block or a flush.
pub const encoder_out_len = encoder_stream_header_len_max + encoder_meta_block_len_max + encoder_uncompressed_overhead + encoder_last_len + encoder_flush_len_max;
/// The rounds of the encoder's loop: two for each meta-block of a call's input, and four for the
/// meta-block at the input's end and what follows it.
pub const encoder_rounds_per_block = 2;
pub const encoder_rounds_extra = 4;

/// The insert-and-copy symbols' tables: one for a distance the stream holds, one for the last
/// distance, which a symbol below 128 leaves out (RFC 7932 §5).
pub const encoder_distance_kinds = 2;
/// The lengths below this take their insert or copy length code from a table; a longer one searches
/// RFC 7932 §5's table.
pub const encoder_length_table_len = 128;
/// The branches the compiler may take to work out the table of insert-and-copy symbols.
pub const encoder_symbol_table_quota = 100_000;
/// The most bits one command puts besides its literals: a symbol of the longest code, insert and
/// copy extra bits, and a distance's code and extra bits, below WBITS 24's (RFC 7932 §3.5, §4,
/// §5).
pub const encoder_command_bits_max = constants.code_len_max + extra_bits_last(&constants.insert_length_codes) +
    extra_bits_last(&constants.copy_length_codes) + constants.code_len_max + constants.window_bits_max;

fn extra_bits_last(comptime table: []const constants.LengthCode) u32 {
    return table[table.len - 1].extra_bits;
}
/// The literals the writer puts with one put: two codes of 15 bits fit the bit buffer after a store.
pub const encoder_literals_per_put = 2;
/// The literals the writer puts between checks of its room.
pub const encoder_literal_chunk_len = 64;

comptime {
    std.debug.assert(encoder_meta_block_len_max < 1 << (encoder_length_nibbles * constants.nibble_bits));
    std.debug.assert(encoder_meta_block_len_max <= 1 << encoder_window_bits_min);
    std.debug.assert(encoder_level1_window_bits <= constants.window_bits_max);
}
