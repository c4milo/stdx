//! The octets and the code points of UTF-8 (RFC 3629 §3 and §4), which the `utf8` module and the
//! modules that import it read (decision 86).
const std = @import("std");
const assert = std.debug.assert;

/// An octet below `non_ascii_min` is a character of one octet. A continuation octet lies from
/// `continuation_min` to `continuation_max` and carries `continuation_bits` of the character. A
/// first octet of two octets lies from `lead_2_min`, of three from `lead_3_min`, and of four from
/// `lead_4_min` up to `lead_4_max` (RFC 3629 §3, §4).
pub const non_ascii_min: u8 = 0x80;
pub const continuation_min: u8 = 0x80;
pub const continuation_max: u8 = 0xbf;
pub const continuation_bits = 6;
pub const continuation_mask: u8 = 0x3f;
pub const lead_2_min: u8 = 0xc2;
pub const lead_3_min: u8 = 0xe0;
pub const lead_4_min: u8 = 0xf0;
pub const lead_4_max: u8 = 0xf4;

/// The first of the octets from 0xF5 up, which cannot appear in UTF-8 (RFC 3629 §4): each would
/// start a code point past U+10FFFF.
pub const invalid_min: u8 = 0xf5;

/// The first octets whose second octet has a narrower range than `continuation_min` to
/// `continuation_max` (RFC 3629 §4): E0 takes A0 to BF, ED takes 80 to 9F, F0 takes 90 to BF, and
/// F4 takes 80 to 8F. Each rules out an overlong form, a surrogate, or a code point past U+10FFFF.
pub const lead_3_overlong: u8 = 0xe0;
pub const lead_3_overlong_second_min: u8 = 0xa0;
pub const lead_3_surrogate: u8 = 0xed;
pub const lead_3_surrogate_second_max: u8 = 0x9f;
pub const lead_4_overlong: u8 = 0xf0;
pub const lead_4_overlong_second_min: u8 = 0x90;
pub const lead_4_largest: u8 = 0xf4;
pub const lead_4_largest_second_max: u8 = 0x8f;

/// The mark each length of character sets in its first octet, which the character's bits follow,
/// indexed by the length (RFC 3629 §3). A character of one octet has none.
pub const lead_marks = [_]u8{ 0, 0, 0xc0, 0xe0, 0xf0 };

/// The code points each length of UTF-8 reaches, and the last code point (RFC 3629 §3).
pub const one_octet_max: u21 = 0x7f;
pub const two_octets_max: u21 = 0x7ff;
pub const three_octets_max: u21 = 0xffff;
pub const code_point_max: u21 = 0x10ffff;

/// The first and the last surrogate. UTF-8 encodes none of them (RFC 3629 §3).
pub const surrogate_min: u21 = 0xd800;
pub const surrogate_max: u21 = 0xdfff;

/// The most octets one character takes in UTF-8 (RFC 3629 §3).
pub const utf8_len_max = 4;

comptime {
    assert(lead_marks.len == utf8_len_max + 1);
    assert(lead_marks[3] == lead_3_min and lead_marks[4] == lead_4_min);
    assert(continuation_mask + 1 == 1 << continuation_bits);
    assert(continuation_max - continuation_min == continuation_mask);
    assert(one_octet_max + 1 == non_ascii_min);
    assert(lead_4_max + 1 == invalid_min);
    // The surrogates are the code points that 0xED starts with a second octet past
    // `lead_3_surrogate_second_max`.
    const surrogate_lead = lead_marks[3] | (surrogate_min >> 2 * continuation_bits);
    assert(surrogate_lead == lead_3_surrogate);
    const surrogate_second = continuation_min | ((surrogate_min >> continuation_bits) & continuation_mask);
    assert(surrogate_second == lead_3_surrogate_second_max + 1);
}
