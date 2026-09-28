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
