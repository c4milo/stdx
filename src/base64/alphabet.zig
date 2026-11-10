//! The two alphabets of RFC 4648: base 64's (§4, Table 1) and its URL and filename safe one (§5,
//! Table 2), and the table the decoder classes each octet by.
//!
//! The two alphabets share 62 letters and differ in the letters of values 62 and 63 (RFC 4648 §5).
//! The table gives each octet its value and whether it belongs to one alphabet alone, so the
//! decoder takes either alphabet in one pass and refuses a text that mixes them.

const std = @import("std");
const constants = @import("constants.zig");

/// An alphabet of RFC 4648.
pub const Alphabet = enum {
    /// Base 64, RFC 4648 §4, Table 1.
    standard,
    /// Base 64 with the URL and filename safe alphabet, RFC 4648 §5, Table 2.
    url_safe,
};

/// The 62 letters both alphabets give values 0 to 61, in the order of their values (RFC 4648 §4,
/// Table 1; §5, Table 2).
const shared_letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

/// Values 62 and 63: "+" and "/" in Table 1 (RFC 4648 §4), "-" and "_" in Table 2 (RFC 4648 §5).
const standard_last = "+/";
const url_safe_last = "-_";

/// The letter of each 6-bit value, in each alphabet.
pub const standard_letters: *const [constants.alphabet_len]u8 = shared_letters ++ standard_last;
pub const url_safe_letters: *const [constants.alphabet_len]u8 = shared_letters ++ url_safe_last;

pub fn letters(alphabet: Alphabet) *const [constants.alphabet_len]u8 {
    return switch (alphabet) {
        .standard => standard_letters,
        .url_safe => url_safe_letters,
    };
}

/// One octet's entry in `table`: its 6-bit value in the low bits, and the alphabet it belongs to
/// alone in the two high bits. An octet in neither alphabet sets every bit.
pub const value_mask: u8 = constants.alphabet_len - 1;
pub const standard_only: u8 = 1 << constants.letter_bits;
pub const url_safe_only: u8 = standard_only << 1;
pub const not_a_letter: u8 = std.math.maxInt(u8);

/// The flags of an entry: zero for a letter both alphabets share.
pub const flags_mask: u8 = standard_only | url_safe_only;

comptime {
    std.debug.assert(value_mask & flags_mask == 0);
    std.debug.assert(not_a_letter & flags_mask == flags_mask);
}

/// The entry of every octet. The pad character is no letter here: the decoder tests for it before
/// it reads the table.
pub const table: [std.math.maxInt(u8) + 1]u8 = build_table();

fn build_table() [std.math.maxInt(u8) + 1]u8 {
    var result: [std.math.maxInt(u8) + 1]u8 = @splat(not_a_letter);
    for (shared_letters, 0..) |letter, value| result[letter] = value;
    for (standard_last, shared_letters.len..) |letter, value| result[letter] = value | standard_only;
    for (url_safe_last, shared_letters.len..) |letter, value| result[letter] = value | url_safe_only;
    return result;
}

/// The flag of the letters only `alphabet` holds.
pub fn only_flag(alphabet: Alphabet) u8 {
    return switch (alphabet) {
        .standard => standard_only,
        .url_safe => url_safe_only,
    };
}

test "each alphabet's letters give back their values, and no other octet is a letter" {
    inline for (.{ Alphabet.standard, Alphabet.url_safe }) |alphabet| {
        for (letters(alphabet), 0..) |letter, value| {
            const entry = table[letter];
            try std.testing.expectEqual(value, entry & value_mask);
            try std.testing.expect(entry == value or entry & flags_mask == only_flag(alphabet));
        }
    }
    var count: usize = 0;
    for (table) |entry| count += @intFromBool(entry != not_a_letter);
    try std.testing.expectEqual(constants.alphabet_len + standard_last.len, count);
    try std.testing.expectEqual(not_a_letter, table[constants.pad]);
}
