//! The limits of the `codec` module: the bit buffer every least-significant-bit-first codec reads
//! through, and the schedules the split driver draws for every codec's tests.
const std = @import("std");

/// The width of the bit buffer. DEFLATE and brotli pack their codes least significant bit first
/// (RFC 1951 §3.1.1, RFC 7932 §1.5.1), and a 64-bit buffer holds several codes between refills.
pub const bit_buffer_bits: u7 = 64;

/// The most bits one `BitReader.ensure` may ask for. The checked refill adds whole octets while the
/// buffer holds fewer bits than asked, so it can end holding up to 7 bits more than asked for, and
/// that must still fit the buffer.
pub const ensure_bits_max: u7 = bit_buffer_bits - @bitSizeOf(u8) + 1;

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

/// The octet the split driver writes over a state's old slot after moving it.
pub const moved_state_fill: u8 = 0xaa;

/// The most calls the split driver makes per octet of input and room, beyond
/// `driver_calls_floor`. A codec that needs more is not making progress (invariant 8).
pub const driver_calls_per_octet_max: usize = 4;
pub const driver_calls_floor: usize = 64;

comptime {
    std.debug.assert(ensure_bits_max + @bitSizeOf(u8) - 1 <= bit_buffer_bits);
    std.debug.assert(short_piece_len_max < long_piece_len_max);
    var total: u8 = 0;
    for (piece_weights) |weight| total += weight;
    std.debug.assert(total == piece_weight_total);
}
