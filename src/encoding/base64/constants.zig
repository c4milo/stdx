//! The limits RFC 4648 fixes for base 64 (§4) and for its URL and filename safe alphabet (§5).
const std = @import("std");

/// The octets of one input group: three 8-bit groups make 24 bits (RFC 4648 §4).
pub const group_octets = 3;

/// The letters of one encoding quantum: the 24 bits as four 6-bit groups (RFC 4648 §4).
pub const quantum_letters = 4;

/// The bits each letter holds (RFC 4648 §4).
pub const letter_bits = 6;

/// The bits of one octet.
pub const octet_bits = 8;

/// The letters of each alphabet: one for each value of 6 bits (RFC 4648 §4, Table 1).
pub const alphabet_len = 64;

/// The letters a final quantum of exactly 8 bits writes before its two pad characters, case (2) of
/// RFC 4648 §4.
pub const one_octet_letters = 2;

/// The letters a final quantum of exactly 16 bits writes before its one pad character, case (3) of
/// RFC 4648 §4.
pub const two_octet_letters = 3;

/// The pad character (RFC 4648 §4).
pub const pad = '=';

/// The pad characters that follow a final quantum of 8 bits and of 16 bits (RFC 4648 §4, cases (2)
/// and (3)): the letters a quantum lacks.
pub fn pads_after(letters: usize) usize {
    std.debug.assert(letters == one_octet_letters or letters == two_octet_letters);
    return quantum_letters - letters;
}

comptime {
    std.debug.assert(group_octets * octet_bits == quantum_letters * letter_bits);
    std.debug.assert(1 << letter_bits == alphabet_len);
    std.debug.assert(one_octet_letters * letter_bits >= octet_bits);
    std.debug.assert(two_octet_letters * letter_bits >= 2 * octet_bits);
}
