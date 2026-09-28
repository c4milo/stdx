//! The limits and the octets of the `json` module: the grammar of RFC 8259, the UTF-8 of RFC 3629,
//! the framing of RFC 7464, and the sizes of the encoder's and the decoder's states.
const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

/// The most objects and arrays one text may hold open at once. RFC 8259 §9 lets an implementation
/// limit the depth of nesting; a deeper text is `error.DepthTooLarge` in both directions. The
/// encoder and the decoder keep one bit per level, so the limit costs `depth_max / 8` octets of
/// state.
pub const depth_max: u16 = 1024;

/// The octets the encoder's and the decoder's SIMD paths take at once: 16, the width of SSE2's and
/// NEON's registers, which every x86-64 and aarch64 CPU has, so no feature detection chooses these
/// paths (decision 27). A build for a CPU with wider registers takes 16 as well; the wider widths
/// are claim J7's, which the caller's features pick at run time (decision 30).
pub const vector_len: usize = 16;

/// The octets claim J7's paths take at once on x86-64: AVX2's 32 and AVX-512's 64, in variant
/// objects compiled for those levels (decision 21), which the module calls when the caller's
/// features name the level (decision 30).
pub const avx2_vector_len: usize = 32;
pub const avx512_vector_len: usize = 64;

/// The octets of a name's or a string's run the 16-octet path takes before claim J7's kernels take
/// the rest. Lines of English text are runs of 50 to 100 octets, which ended before a kernel's call
/// paid for itself: 5% to 8% slower to encode on an AMD EPYC 9V74 with the kernels from the 17th
/// octet (design §8 step 17).
pub const wide_run_len_min: usize = 64;

/// Whether the target's vector registers hold `vector_len` octets, so the claims' vector paths are
/// on by default. Where they do not, LLVM would split each vector or run each lane in turn, and the
/// scalar paths run instead.
pub const vectors = (std.simd.suggestVectorLength(u8) orelse 0) >= vector_len;

/// The six structural characters (RFC 8259 §2).
pub const begin_array: u8 = '[';
pub const begin_object: u8 = '{';
pub const end_array: u8 = ']';
pub const end_object: u8 = '}';
pub const name_separator: u8 = ':';
pub const value_separator: u8 = ',';

/// The four octets of insignificant whitespace (RFC 8259 §2).
pub const space: u8 = ' ';
pub const horizontal_tab: u8 = '\t';
pub const line_feed: u8 = '\n';
pub const carriage_return: u8 = '\r';

/// The three literal names (RFC 8259 §3), lowercase.
pub const literal_true = "true";
pub const literal_false = "false";
pub const literal_null = "null";

/// The longest literal name.
pub const literal_len_max = literal_false.len;

/// The octets of a number (RFC 8259 §6).
pub const minus: u8 = '-';
pub const plus: u8 = '+';
pub const decimal_point: u8 = '.';
pub const zero: u8 = '0';
pub const nine: u8 = '9';
pub const exponent_lower: u8 = 'e';
pub const exponent_upper: u8 = 'E';

/// The octets of a string (RFC 8259 §7).
pub const quotation_mark: u8 = '"';
pub const reverse_solidus: u8 = '\\';
pub const solidus: u8 = '/';
pub const escape_unicode: u8 = 'u';

/// The characters a string must escape: quotation mark, reverse solidus, and U+0000 through U+001F
/// (RFC 8259 §7). `unescaped_min` is the first code point a string may carry as it is.
pub const control_max: u8 = 0x1f;
pub const unescaped_min: u8 = 0x20;

/// The escapes of RFC 8259 §7 that name a character in one letter, and the characters they name.
pub const escape_letters = "\"\\/bfnrt";
pub const escaped_characters = "\"\\/\x08\x0c\n\r\t";

/// The hexadecimal digits of a `\u` escape (RFC 8259 §7), and the value of its four digits.
pub const escape_hex_digits = 4;
pub const hex_letter_value_min = 10;
pub const hex_digits_lower = "0123456789abcdef";

/// The bits of one hexadecimal digit, and the digits of one octet.
pub const nibble_bits = 4;
pub const nibble_mask: u8 = 0x0f;
pub const hex_digits_per_octet = 2;

/// UTF-8 (RFC 3629 §3, §4). An octet below `non_ascii_min` is a character of one octet. A
/// continuation octet lies from `continuation_min` to `continuation_max` and carries
/// `continuation_bits` of the character. A first octet of two octets lies from `lead_2_min`, of
/// three from `lead_3_min`, and of four from `lead_4_min` up to `lead_4_max`.
pub const non_ascii_min: u8 = 0x80;
pub const continuation_min: u8 = 0x80;
pub const continuation_max: u8 = 0xbf;
pub const continuation_bits = 6;
pub const continuation_mask: u8 = 0x3f;
pub const lead_2_min: u8 = 0xc2;
pub const lead_3_min: u8 = 0xe0;
pub const lead_4_min: u8 = 0xf0;
pub const lead_4_max: u8 = 0xf4;

/// The octets that cannot appear in UTF-8 (RFC 3629 §4): 0xC0 and 0xC1, which would start an
/// overlong form of a character of one octet, and 0xF5 up.
pub const overlong_lead_2_min: u8 = 0xc0;
pub const invalid_min: u8 = 0xf5;

/// The least first octet of a character that reaches a given number of octets past itself, indexed
/// by that number: 0xC0 up reaches 1, 0xE0 up 2, and 0xF0 up 3 (RFC 3629 §3). Index 0 is unused.
pub const reaching_lead_min = [_]u8{ 0, 0xc0, 0xe0, 0xf0 };

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

/// The most octets one character takes in UTF-8 (RFC 3629 §3).
pub const utf8_len_max = 4;

/// UTF-16's surrogates, which a `\u` escape may name (RFC 8259 §7): a high surrogate from
/// `high_surrogate_min` and a low one from `low_surrogate_min` to `surrogate_max`. A pair names
/// the code point `supplementary_min` plus the high one's 10 bits and then the low one's.
pub const high_surrogate_min: u16 = 0xd800;
pub const low_surrogate_min: u16 = 0xdc00;
pub const surrogate_max: u16 = 0xdfff;
pub const surrogate_bits = 10;
pub const supplementary_min: u21 = 0x10000;

/// The byte order mark, U+FEFF in UTF-8 (RFC 8259 §8.1).
pub const byte_order_mark = "\xef\xbb\xbf";

/// The record separator that starts each text of a sequence (RFC 7464 §2.1, §2.2).
pub const record_separator: u8 = 0x1e;

/// The escape of a control character with no letter of its own: `\u00` and two digits.
pub const control_escape_prefix = "\\u00";
pub const control_escape_len = control_escape_prefix.len + 2;

/// The longest escape the encoder writes for one octet of a string.
pub const escape_len_max = control_escape_len;

/// A number is represented in base 10 (RFC 8259 §6).
pub const decimal_base = 10;

/// The most decimal digits of a 64-bit unsigned integer: 18446744073709551615.
pub const unsigned_digits_max = 20;

/// The most digits a fixed-point decimal's fraction takes: 10^19 - 1 is the largest such fraction
/// a 64-bit integer holds.
pub const fraction_digits_max = 19;

/// The longest number the encoder formats: a minus sign, 20 digits, a decimal point and 19 more.
pub const number_text_len_max = 1 + unsigned_digits_max + 1 + fraction_digits_max;

/// The most octets the encoder holds back when the output has no room for them: a record
/// separator, a value separator, and the longest number or literal name.
pub const pending_len_max = 1 + 1 + number_text_len_max;

/// The parts of one token the encoder writes in turn: its opening, its content and its closing.
pub const token_parts = 3;

/// The most steps one decoder call takes before it returns: a sequence's record separators, the
/// check for a byte order mark, one name separator or value separator, and the next token, each
/// with the whitespace before it.
pub const decoder_steps_max = 4;

comptime {
    assert(depth_max % @bitSizeOf(u8) == 0);
    assert(vector_len >= utf8_len_max);
    // The width is SSE2's and NEON's on every target, never the target's own (decision 27), and
    // every x86-64 and aarch64 CPU has one of the two.
    assert(vector_len * @bitSizeOf(u8) == 128);
    if (builtin.cpu.arch == .x86_64 or builtin.cpu.arch == .aarch64) assert(vectors);
    assert(escape_letters.len == escaped_characters.len);
    assert(control_max + 1 == unescaped_min);
    assert(hex_digits_lower.len == 1 << nibble_bits);
    assert(literal_true.len <= literal_len_max and literal_null.len <= literal_len_max);
    assert(escape_len_max <= pending_len_max);
    assert(std.math.maxInt(u64) / std.math.pow(u64, 10, unsigned_digits_max - 1) < 10);
    assert(std.math.pow(u64, 10, fraction_digits_max) - 1 <= std.math.maxInt(u64));
    assert(lead_marks.len == utf8_len_max + 1);
    assert(reaching_lead_min.len == utf8_len_max);
    for (1..utf8_len_max) |back| assert(reaching_lead_min[back] == lead_marks[back + 1]);
    assert(hex_digits_per_octet * nibble_bits == @bitSizeOf(u8));
    assert(lead_marks[2] == overlong_lead_2_min and lead_marks[3] == lead_3_min and lead_marks[4] == lead_4_min);
    assert(continuation_mask + 1 == 1 << continuation_bits);
    assert(high_surrogate_min + (1 << surrogate_bits) == low_surrogate_min);
}
