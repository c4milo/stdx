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
