//! The limits of the `codec` module: the bit buffer every least-significant-bit-first codec reads
//! through, and the schedules the split driver draws for every codec's tests.
const std = @import("std");

/// The octets `Writer.write_first` moves in one load and one store, with no call: a token's few
/// octets cost a call to `memcpy` more than its copy (decision 70).
pub const write_first_move_len: usize = 2 * @sizeOf(u64);

/// The width of the bit buffer. DEFLATE and brotli pack their codes least significant bit first
/// (RFC 1951 §3.1.1, RFC 7932 §1.5.1), and a 64-bit buffer holds several codes between refills.
pub const bit_buffer_bits: u7 = 64;

/// The most bits one `BitReader.ensure` may ask for. The checked refill adds whole octets while the
/// buffer holds fewer bits than asked, so it can end holding up to 7 bits more than asked for, and
/// that must still fit the buffer.
pub const ensure_bits_max: u7 = bit_buffer_bits - @bitSizeOf(u8) + 1;

/// `IoWriter` bounds the rounds of a flush or a finish by this many times the octets that the
/// encoder's `encoded_len_max` allows for its held and buffered input. One stream's bound covers
/// the octets those inputs code to, and the second covers a flush's empty block (decision 56).
pub const io_flush_rounds_factor: usize = 2;

/// The split driver's piece sizes (decision 15): an empty piece, one octet, a short piece of
/// `short_piece_len_min` to `short_piece_len_max` octets, a long piece of up to
/// `long_piece_len_max` octets, or everything left.
pub const short_piece_len_min: usize = 2;
pub const short_piece_len_max: usize = 16;
pub const long_piece_len_max: usize = 4096;

/// The split driver draws one of these piece kinds for every input piece and every output room,
/// each with this weight out of `piece_weight_total`: empty, one octet, short, long, everything.
pub const piece_weights = [_]u8{ 1, 2, 2, 2, 1 };
pub const piece_weight_total: u8 = 8;

/// The split driver moves the state to the other slot before the second call and before about one
/// later call in this many, so a state holding a pointer into itself reads what the driver wrote
/// over the old slot (invariant 12).
pub const state_move_period: u64 = 4;

/// The split driver passes `none` on about one call in this many whose input piece reaches a flush
/// point or the input's end, and leaves the `flush` or `finish` to the next call, which then has no
/// input: a caller that writes its last octets, then flushes or ends the stream with an empty call
/// (invariant 5).
pub const flush_hold_period: u64 = 2;

/// The octet the split driver writes over a state's old slot after moving it.
pub const moved_state_fill: u8 = 0xaa;

/// The most calls the split driver makes per octet of input and room, beyond
/// `driver_calls_floor`. A codec that needs more is not making progress (invariant 8).
pub const driver_calls_per_octet_max: usize = 4;
pub const driver_calls_floor: usize = 64;

/// The encoders' prefix codes (prefix_code.zig): at most 15 bits a code, as both DEFLATE (RFC
/// 1951 §3.2.2) and brotli (RFC 7932 §3.5) bound them.
pub const prefix_code_len_max = 15;
/// The most symbols a prefix code has: brotli's insert-and-copy alphabet (RFC 7932 §5).
pub const prefix_code_symbols_max = 704;
/// The largest alphabet the builder sorts by insertion rather than by counting passes: DEFLATE's
/// 30 distance codes and both code length codes. Their few symbols cost fewer compares than a
/// counting pass's buckets cost to clear.
pub const prefix_code_insertion_sort_len_max = 30;
/// The alignment of the builder's hot functions: a 64-octet line, as DEFLATE's
/// `hot_function_alignment` explains.
pub const prefix_code_function_alignment = 64;

/// The match finder of the encoders' fast levels (match_finder.zig).
/// The octets a match finder's hash reads at a position: a position searches only with this many
/// ahead in its block.
pub const match_read_len = 8;

/// The octets the long table of level 3 hashes.
pub const long_hash_len = 8;

/// The odd multiplier of the tables' hash: the top bits of a word times it name a slot.
pub const match_hash_multiplier: u64 = 0x9E3779B185EBCA87;

/// A search that finds nothing steps 1 + (literals since the last match >> this): through octets
/// that do not repeat, the steps grow, so a block of them costs little.
pub const match_skip_log = 6;

/// After a match, the tables record its position plus `match_insert_skip`, then every
/// `match_insert_step`th position, then the one `match_insert_tail` before its end.
pub const match_insert_skip = 2;
pub const match_insert_step = 8;
pub const match_insert_tail = 2;

/// The table entries one step of a slide moves: two 128-bit vectors of u32 on aarch64, one of
/// 256 bits with AVX2. Every table holds a power of two of entries, at least this many.
pub const match_slide_lanes = 8;

comptime {
    std.debug.assert(ensure_bits_max + @bitSizeOf(u8) - 1 <= bit_buffer_bits);
    std.debug.assert(short_piece_len_max < long_piece_len_max);
    var total: u8 = 0;
    for (piece_weights) |weight| total += weight;
    std.debug.assert(total == piece_weight_total);
}
