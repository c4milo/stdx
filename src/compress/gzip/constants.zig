//! The fields RFC 1952 fixes for every gzip member.
const std = @import("std");
const assert = std.debug.assert;
const deflate_constants = @import("deflate").constants;

/// ID1, ID2, CM, FLG, MTIME, XFL and OS: the part of the header every member has (RFC 1952 §2.3).
pub const fixed_header_len = 10;

/// Where ID1, ID2, CM and FLG sit in it.
pub const identification_1_offset = 0;
pub const identification_2_offset = 1;
pub const method_offset = 2;
pub const flags_offset = 3;
pub const modification_time_offset = 4;
pub const extra_flags_offset = 8;
pub const operating_system_offset = 9;

/// ID1 and ID2 (RFC 1952 §2.3.1).
pub const identification_1: u8 = 0x1f;
pub const identification_2: u8 = 0x8b;

/// CM 8 is DEFLATE; 0 - 7 are reserved (RFC 1952 §2.3.1).
pub const method_deflate: u8 = 8;

/// The bits of FLG (RFC 1952 §2.3.1). FTEXT, bit 0, is ignored, as §2.3.1.2 allows.
pub const flag_header_crc: u8 = 1 << 1;
pub const flag_extra: u8 = 1 << 2;
pub const flag_name: u8 = 1 << 3;
pub const flag_comment: u8 = 1 << 4;
pub const flags_reserved: u8 = 0b1110_0000;

/// XLEN and the CRC16, two octets each, least significant first (RFC 1952 §2.1, §2.3).
pub const extra_len_len = 2;
pub const header_crc_len = 2;

/// The octet that ends FNAME and FCOMMENT (RFC 1952 §2.3.1).
pub const field_terminator: u8 = 0;

/// CRC32 and ISIZE, four octets each, least significant first (RFC 1952 §2.1, §2.3).
pub const trailer_len = 8;
pub const trailer_crc32_len = 4;

/// The octets of the shortest DEFLATE stream: one final block of the fixed codes that holds
/// end-of-block alone, 3 bits of header and a 7-bit code (RFC 1951 §3.2.3, §3.2.6).
pub const deflate_stream_len_min = std.math.divCeil(
    usize,
    deflate_constants.final_bits + deflate_constants.type_bits + deflate_constants.fixed_literal_length_lengths[deflate_constants.end_of_block],
    @bitSizeOf(u8),
) catch unreachable;

/// The fewest octets a member takes: the fixed header, the shortest DEFLATE stream, and the
/// trailer (RFC 1952 §2.3).
pub const member_len_min = fixed_header_len + deflate_stream_len_min + trailer_len;

/// What the encoder's header holds beside ID1, ID2 and CM (RFC 1952 §2.3.1): no FLG bit; MTIME 0,
/// no time, so no clock reaches the output (invariant 5); OS 255, unknown, the same on every host;
/// and XFL, 4 for the fastest level, 2 for the strongest, and 0 for the others.
pub const encoder_flags: u8 = 0;
pub const encoder_modification_time: u32 = 0;
pub const encoder_operating_system: u8 = 255;
pub fn extra_flags(comptime level: u4) u8 {
    return switch (level) {
        1 => 4,
        6 => 0,
        9 => 2,
        else => @compileError("the gzip encoder's levels are 1, 6 and 9 (decision 13)"),
    };
}

/// The CRC-32 of no octets (RFC 1952 §8).
pub const crc32_initial: u32 = 0;

/// What decision 12 budgets for the decoder's state beside DEFLATE's.
pub const decoder_state_extra_len = 32;

/// The phases one call can pass through: the fixed header, XLEN, the extra field, FNAME,
/// FCOMMENT, the CRC16, the DEFLATE stream and the trailer.
pub const phases_per_call_max = 8;

comptime {
    assert(trailer_len <= fixed_header_len);
    assert(extra_len_len <= fixed_header_len and header_crc_len <= fixed_header_len);
    assert(2 * trailer_crc32_len == trailer_len);
    assert(flags_reserved & (flag_header_crc | flag_extra | flag_name | flag_comment) == 0);
}
