//! The compare of a literal's octets with a text's, a word at a time (claims R2 and R5,
//! decision 86).
const std = @import("std");
const assert = std.debug.assert;

/// The octets of the words that a compare of a literal reads at once.
const word_len = @sizeOf(u64);
const half_word_len = @sizeOf(u32);

/// True when `text` holds the octets of `wanted` from its start.
pub fn equal(text: []const u8, wanted: []const u8) bool {
    return compare(false, text, wanted, &.{});
}

/// True when each octet of `text`, ORed with the octet at its place in `folds`, equals the octet
/// at its place in `wanted`: `case_bit` in `folds` takes a letter in either case.
pub inline fn folded(text: []const u8, wanted: []const u8, folds: []const u8) bool {
    return compare(true, text, wanted, folds);
}

/// True when each octet of `text`, with `folding` ORed with the octet at its place in `folds`,
/// equals the octet at its place in `wanted`. A text of a word or more compares words, the last
/// of them read where it ends, over the one before; a text of 4 to 7 octets two words of 4 the
/// same way, and a shorter text its octets one at a time. A compare of `literal_len_max` octets
/// so reads four words. `std.mem.eql` was a call, which took about 50 instructions to compare 15
/// octets on aarch64.
inline fn compare(comptime folding: bool, text: []const u8, wanted: []const u8, folds: []const u8) bool {
    assert(wanted.len >= text.len and (!folding or folds.len >= text.len));
    const len = text.len;
    if (len >= word_len) return compare_words(u64, folding, text, wanted, folds);
    if (len >= half_word_len) return compare_words(u32, folding, text, wanted, folds);
    // At most three places.
    for (text, wanted[0..len], 0..) |octet, want, place| {
        const fold = if (folding) folds[place] else 0;
        if (octet | fold != want) return false;
    }
    return true;
}

/// `compare` by words of `Word`, for a text of one word or more: each word from the text's start,
/// and last the word that ends where the text does.
inline fn compare_words(comptime Word: type, comptime folding: bool, text: []const u8, wanted: []const u8, folds: []const u8) bool {
    const size = @sizeOf(Word);
    assert(text.len >= size);
    for (0..(text.len - 1) / size) |turn| {
        if (!words_equal(Word, folding, text, wanted, folds, turn * size)) return false;
    }
    return words_equal(Word, folding, text, wanted, folds, text.len - size);
}

/// True when the word of `text` at `at` equals the word of `wanted` there, with `folding` once
/// the word of `folds` there is ORed into it.
inline fn words_equal(comptime Word: type, comptime folding: bool, text: []const u8, wanted: []const u8, folds: []const u8, at: usize) bool {
    const size = @sizeOf(Word);
    var octets = std.mem.readInt(Word, text[at..][0..size], .little);
    if (folding) octets |= std.mem.readInt(Word, folds[at..][0..size], .little);
    return octets == std.mem.readInt(Word, wanted[at..][0..size], .little);
}

const testing = std.testing;
const constants = @import("constants.zig");
const Generator = @import("codec").testing.split.Generator;

/// True when each octet of `text`, ORed with its fold, equals the octet of `wanted`: what
/// `folded` must give.
fn folded_plain(text: []const u8, wanted: []const u8, folds: []const u8) bool {
    for (text, wanted[0..text.len], folds[0..text.len]) |octet, want, fold| {
        if (octet | fold != want) return false;
    }
    return true;
}

/// The octets a test's literal draws from: letters, and `@` and its fold.
const test_octets = "abcz@`";

/// True on half the draws of `generator`.
fn coin(generator: *Generator) bool {
    return generator.next() & 1 == 0;
}

/// One literal of `len` octets that the seed draws, and a text that holds it with a place in
/// either case, and one octet changed at a place the seed picks, or none.
fn expect_compare(generator: *Generator, len: usize) !void {
    var wanted: [constants.literal_len_max]u8 = undefined;
    var folds: [constants.literal_len_max]u8 = undefined;
    for (&wanted, &folds) |*want, *fold| {
        fold.* = if (coin(generator)) constants.case_bit else 0;
        want.* = test_octets[generator.below(test_octets.len)] | fold.*;
    }
    var text: [constants.literal_len_max]u8 = undefined;
    for (&text, wanted, folds) |*octet, want, fold| octet.* = if (coin(generator)) want ^ fold else want;
    if (len > 0 and coin(generator)) text[generator.below(len)] ^= 1;
    try testing.expectEqual(folded_plain(text[0..len], &wanted, &folds), folded(text[0..len], &wanted, &folds));
    try testing.expectEqual(std.mem.eql(u8, text[0..len], wanted[0..len]), equal(text[0..len], wanted[0..len]));
}

test "equal and folded give what a compare of each octet gives, at every length to the longest" {
    var generator = Generator.init(0xC0DE);
    for (0..constants.literal_len_max + 1) |len| {
        for (0..constants.literal_len_max) |_| try expect_compare(&generator, len);
    }
}
