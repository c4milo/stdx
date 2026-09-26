//! The fields RFC 1950 fixes for every zlib stream.
const std = @import("std");
const assert = std.debug.assert;
const deflate = @import("deflate");

/// CMF and FLG, an octet each (RFC 1950 §2.2).
pub const header_len = 2;

/// CM, the low four bits of CMF: 8 is DEFLATE, the one method RFC 1950 §2.2 defines.
pub const method_mask: u8 = 0x0f;
pub const method_deflate: u8 = 8;

/// CINFO, the high four bits of CMF: the base-2 logarithm of the window, minus eight. Values above
/// 7 are not allowed (RFC 1950 §2.2).
pub const window_bits_shift = 4;
pub const window_bits_offset = 8;
pub const window_bits_field_max = 7;

/// FCHECK, the low five bits of FLG, makes CMF * 256 + FLG, read most significant octet first, a
/// multiple of 31 (RFC 1950 §2.2).
pub const header_check_mask: u8 = 0x1f;
pub const header_check_divisor = 31;

/// FDICT, bit 5 of FLG (RFC 1950 §2.2).
pub const preset_dictionary_flag: u8 = 1 << 5;

/// ADLER32, most significant octet first (RFC 1950 §2.1, §2.2).
pub const trailer_len = 4;

/// The Adler-32 of no octets: s1 starts at 1 and s2 at 0 (RFC 1950 §2.2).
pub const adler32_initial: u32 = 1;

/// What decision 12 budgets for the decoder's state beside DEFLATE's.
pub const decoder_state_extra_len = 16;

/// The phases one call can pass through: the header, the DEFLATE stream and the trailer.
pub const phases_per_call_max = 3;

comptime {
    // CINFO 7 is DEFLATE's whole window (RFC 1950 §2.2).
    assert(1 << (window_bits_field_max + window_bits_offset) == deflate.constants.window_len);
    assert(header_len <= trailer_len);
}
