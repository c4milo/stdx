//! The fields RFC 1952 fixes for every gzip member.
const std = @import("std");
const assert = std.debug.assert;

/// ID1, ID2, CM, FLG, MTIME, XFL and OS: the part of the header every member has (RFC 1952 §2.3).
pub const fixed_header_len = 10;

/// Where ID1, ID2, CM and FLG sit in it.
pub const identification_1_offset = 0;
pub const identification_2_offset = 1;
pub const method_offset = 2;
pub const flags_offset = 3;

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
