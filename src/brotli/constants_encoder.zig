//! The brotli encoder's limits and the fields of the meta-blocks it writes (decision 62). A piece
//! of constants.zig, which stays the module's entry point and gives every name here as its own.
const std = @import("std");
const constants = @import("constants.zig");

/// The most code length code lengths HSKIP leaves out (RFC 7932 §3.5).
pub const code_length_skip_max = 3;
/// The encoder's largest alphabet, the insert-and-copy code's: a complex code's lengths, and so its
/// code length symbols, number this many at most (RFC 7932 §3.3, §3.5).
pub const encoder_code_alphabet_len_max = constants.insert_copy_alphabet_len;
/// The most repeat symbols one run of lengths takes: each adds two bits or more to a count, and a
/// run is shorter than the largest alphabet (RFC 7932 §3.5).
pub const repeat_digits_max = 6;

comptime {
    std.debug.assert(encoder_code_alphabet_len_max < (1 << (constants.repeat_previous_extra_bits * repeat_digits_max)));
}

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
/// Level 1's match finder: a table of 2^14 entries hashing 5 octets, and one of 2^14 hashing 8,
/// whose longer matches it prefers (decision 62).
pub const encoder_level1_hash_log = 14;
pub const encoder_level1_hash_len = 5;
pub const encoder_level1_long_hash_log = 14;
/// Level 5 (decision 62).
pub const encoder_level5 = struct {
    /// The level's number in `EncoderOptions`.
    pub const number = 5;
    /// WBITS (decision 12): a window of 2^22 octets.
    pub const window_bits = 22;
    /// The match finder, the owner's rulings of 2026-11-07 and 2026-11-12: 2^14 buckets, each the
    /// last 16 positions whose first 5 octets hash to it, 1 MiB in all. A hash of 5 octets keeps
    /// a bucket's ways for positions that agree on 5, where a hash of 4 fills them with the
    /// newest of a common 4 (decision 66, the finder's forms).
    pub const bucket_log = 14;
    pub const bucket_ways = 16;
    pub const hash_len = 5;
    /// The fewest octets a match copies.
    pub const match_len_min = 4;
    /// The side table, for the matches of `match_len_min` octets the buckets no longer find: the
    /// newest position of each hash of that many octets, 2^12 entries. Its 16 KiB stay in the L1
    /// cache.
    pub const side_log = 12;
    /// The octets at a stream's start where a search first drops the entries of an earlier stream
    /// with one compare of the bucket's 16, 256 KiB. After `start` most hits there are such
    /// entries; later the stream's own entries hold most ways, and the compare costs more than it
    /// saves (decision 66, part 6).
    pub const reach_compare_len = 1 << 18;
    /// The positions after a miss the parse tries before it steps faster, as a log2: 2^8 literals.
    pub const skip_log = 8;
    /// The window's room past its history: the window slides once this much input has gone into
    /// meta-blocks, so it moves the history and the buckets 16 times less often than once a
    /// meta-block, for 1 MiB more.
    pub const slack_len = 1_048_576;
    /// The literal blocks (RFC 7932 §6), the owner's ruling of 2026-11-07. A meta-block's literals
    /// go in chunks of 32 to block types; the costs count in 1/64 bit.
    pub const split_chunk_len = 32;
    pub const split_cost_shift = 6;
    /// A chunk starts a new type when its cost under the best type passes its own entropy by
    /// 100 bits; a switch costs about 12 bits.
    pub const split_threshold = 100 << split_cost_shift;
    pub const split_switch_cost = 12 << split_cost_shift;
    /// The passes that move each chunk to its cheapest type, and the chunks a type takes between
    /// two rebuilds of its costs in the first pass.
    pub const split_passes = 1;
    pub const split_refresh_chunks = 4;
    pub const split_refresh_share = 8;
    /// The fewest literals a meta-block splits: below them a second code's description costs more
    /// than a split saves, as on the HTTP bodies of 1 KiB.
    pub const split_literals_min = 2048;
    /// The types one vector of 16-bit lanes prices a chunk under at once.
    pub const split_lanes = 16;
    /// A tree's description, as the split prices it: about 30 bits and 4 bits a symbol.
    pub const split_tree_cost = 30 << split_cost_shift;
    pub const split_symbol_cost = 4 << split_cost_shift;
    /// RLEMAX of the literal context map: a run code of 6 covers a type's 64 zeros (RFC 7932 §7.3).
    pub const map_run_length_codes = 6;
    /// The static dictionary's words (RFC 7932 §8), the owner's ruling of 2026-11-07: 2^14 buckets
    /// of the 4 shortest words whose first 4 octets hash to each, 128 KiB of comptime data, and
    /// the octets a match may leave of a word's end, those OmitLast1 to OmitLast9 drop.
    pub const word_bucket_log = 14;
    pub const word_ways = 4;
    pub const word_omit_max = 9;
    /// The saving, in eighths of a bit, by which the lazy step's next position must pass a match at
    /// a last distance to replace it: 6 bits, about what the next command's distance then costs.
    pub const lazy_margin = 48;
};
/// A literal's cost in eighths of a bit before the first meta-block's code: 8 bits.
pub const encoder_literal_cost_initial = 64;
/// A match's cost in eighths of a bit besides its distance's extra bits, which `takes` adds as
/// the log2 of its offset: an insert-and-copy symbol and a distance code (RFC 7932 §4, §5).
pub const encoder_match_cost_base = 12 * 8;
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
/// The insert lengths below `encoder_small_insert_len` with the copy lengths below
/// `encoder_small_copy_len` take their insert-and-copy symbol from one table.
pub const encoder_small_insert_len = 16;
pub const encoder_small_copy_len = 32;
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
/// The literals the writer puts with one put, and the most bits a put takes: a store follows each
/// put, so the bit buffer holds fewer than 8 bits before it (encoder_write.zig).
pub const encoder_literals_per_put = 3;
pub const encoder_put_bits_max = 56;

/// The counts one vector multiply takes, where the parse weighs the literal code
/// (encoder_commands.zig).
pub const encoder_scan_lanes = 16;
/// The literals the writer puts between checks of its room.
pub const encoder_literal_chunk_len = 64;

comptime {
    std.debug.assert(encoder_meta_block_len_max < 1 << (encoder_length_nibbles * constants.nibble_bits));
    std.debug.assert(encoder_meta_block_len_max <= 1 << encoder_window_bits_min);
    std.debug.assert(encoder_level1_window_bits <= constants.window_bits_max);
}
