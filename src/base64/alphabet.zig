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

/// The letters of one lookup in a `PairTable`.
pub const letters_per_pair = 2;

/// The bits two letters hold, and so the index of a `PairTable`.
pub const pair_bits = letters_per_pair * constants.letter_bits;

/// The two letters of each 12-bit value, first letter first, in each alphabet: a table of 8 KiB,
/// which stays in the first-level cache, so the encoder takes two letters a lookup.
pub const PairTable = [1 << pair_bits][letters_per_pair]u8;
pub const standard_pairs: PairTable = build_pairs(standard_letters);
pub const url_safe_pairs: PairTable = build_pairs(url_safe_letters);

/// The comptime branches a table's build takes: one for each of its entries, four times over.
const table_build_branches = 1 << (pair_bits + letters_per_pair);

pub fn pair_letters(alphabet: Alphabet) *const PairTable {
    return switch (alphabet) {
        .standard => &standard_pairs,
        .url_safe => &url_safe_pairs,
    };
}

fn build_pairs(comptime alphabet_letters: *const [constants.alphabet_len]u8) PairTable {
    @setEvalBranchQuota(table_build_branches);
    var result: PairTable = undefined;
    for (&result, 0..) |*pair, value| {
        pair.* = .{ alphabet_letters[value >> constants.letter_bits], alphabet_letters[value % constants.alphabet_len] };
    }
    return result;
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

/// The tables the decoder's quanta take their bits from: for each of a quantum's four places, each
/// octet's value shifted to that place's bits, or `quantum_refused` when the octet is no letter the
/// set takes. A quantum's four entries ORed together are its 24 bits, or hold `quantum_refused`.
/// Three sets: the letters both alphabets share, and each alphabet's letters. Each set is 4 KiB,
/// so all three stay in the first-level cache.
pub const QuantumTables = [constants.quantum_letters][std.math.maxInt(u8) + 1]u32;
pub const quantum_refused: u32 = 1 << (constants.quantum_letters * constants.letter_bits);

pub const shared_quanta: QuantumTables = build_quanta(0);
pub const standard_quanta: QuantumTables = build_quanta(standard_only);
pub const url_safe_quanta: QuantumTables = build_quanta(url_safe_only);

/// The set for a text whose letters of values 62 and 63 came from `seen`, or from neither yet.
pub fn quanta(seen: ?Alphabet) *const QuantumTables {
    const alphabet = seen orelse return &shared_quanta;
    return switch (alphabet) {
        .standard => &standard_quanta,
        .url_safe => &url_safe_quanta,
    };
}

fn build_quanta(comptime taken_flag: u8) QuantumTables {
    @setEvalBranchQuota(table_build_branches);
    var result: QuantumTables = undefined;
    for (&result, 0..) |*place, index| {
        const shift = (constants.quantum_letters - 1 - index) * constants.letter_bits;
        for (place, table) |*slot, entry| {
            const flags = entry & flags_mask;
            const taken = entry != not_a_letter and (flags == 0 or flags == taken_flag);
            slot.* = if (taken) @as(u32, entry & value_mask) << shift else quantum_refused;
        }
    }
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
