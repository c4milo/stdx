//! The patterns and texts shaped for the searcher's claims, which `matcher_replay dump` draws
//! beside the patterns of tools/differential/regex_generate.zig (decision 86, design §8 parts
//! 22h and 22r).
//!
//! A pattern is a shape of runs and words: a word that starts every match, one that ends every
//! match, one inside, and an alternation of words, each beside a run that may take the word's
//! bytes. Half of the texts hold the word twice. One case in `fold_share` writes its word with
//! a place that folds, and its text then holds some of the word's letters in upper case.
const std = @import("std");
const regex_generate = @import("../differential/regex_generate.zig");
const Generator = @import("codec").testing.split.Generator;

/// The parts of a pattern shaped for the searcher's claims. A run takes some bytes, and most
/// runs take a byte of a word, so a search from the word's place must read past it.
const runs = [_][]const u8{
    "[ab]*",         "[a-c]+",          "(?:a|ba)*",          ".*",    "\\w+",   "[^b]*",   "a?",     "(?:ab)*?", "", "[b ]+", "\\w*?", "(?:[ab]|c[ab]ab)", "c", "(?i:b)*",
    // Runs whose DFA holds a state for each set of the last few bytes: more states than a small
    // cache holds, over a text of mixed letters.
    "[ab]*a[ab]{5}", "[a-c]*b[a-c]{3}", "(?:a|ba)*b[ab ]{4}",
    // Runs of one count of bytes, which may be a word's first: claim R4's second rule.
    "[a-c]", "\\w\\w", "[ab]{2}",
    // Runs of upper-case letters: a byte that a word's place takes only where the place folds.
    "[A-C]+", "[A-C]",
};
const words = [_][]const u8{ "ab", "ba", "abc", "aab", "b a", "cab", "aa", "abab" };
const tails = [_][]const u8{ "", "", "", "$", "\\b", "c*", "[ab]?" };

/// The pieces of a text for such a pattern: the words' bytes, so that a word stands in a text
/// more than once.
pub const text_pieces = [_][]const u8{ "a", "b", "ab", "ba", "c", " ", "abc", "a", "b", "AB" };

/// The pieces such a text holds at most before its two words, and after them.
const text_pieces_max = 3;

/// The letters that the nested shape's first branch takes.
const letters = [_][]const u8{ "a", "b" };

/// The shapes of such a pattern.
const Shape = enum {
    /// A run, then a word: the word ends every match.
    suffix,
    /// A word, then a run: the word starts every match.
    prefix,
    /// A run, a word, and a run: the word stands inside every match.
    inner,
    /// Two words in an alternation, then a run.
    set,
    /// A run and a word, or a word alone.
    either,
    /// `(?:[ab]|c[ab]W)W` for a word W, then a run: a match from `c` holds a shorter match that
    /// starts later and ends sooner. A search from the word's places then needs a rule, which
    /// spec/lean/Stdx/Regex/Required.lean names `NoEarlier` (`needs_no_earlier`).
    nested,
    /// A run, a space or more, then a word: claim R4's third rule, where the run takes no
    /// space.
    separated,
    /// The same, and then a run: claim R14, by the third rule for the part before the word.
    inner_separated,
};

pub fn pick(generator: *Generator, comptime list: []const []const u8) []const u8 {
    return list[generator.below(list.len)];
}

/// Adds a piece to a text where it fits.
pub fn fit(text: *std.ArrayList(u8), piece: []const u8) void {
    if (text.unusedCapacitySlice().len >= piece.len) text.appendSliceAssumeCapacity(piece);
}

fn fit_pieces(generator: *Generator, text: *std.ArrayList(u8)) void {
    for (0..generator.below(text_pieces_max + 1)) |_| fit(text, pick(generator, &text_pieces));
}

/// Draws the text of such a case. Half of the texts hold the pattern's word twice: a search
/// from the word's places then has two places to judge. For the nested shape the two words
/// follow `c` and a letter, as in `cbabab` for `(?:[ab]|c[ab]ab)ab`, which is the text that
/// holds both of that shape's matches.
fn draw_text(generator: *Generator, case: *regex_generate.Case, shape: Shape, word: []const u8, fold: Fold, text_len_max: usize) void {
    var text: std.ArrayList(u8) = .initBuffer(case.text[0..text_len_max]);
    fit_pieces(generator, &text);
    if (generator.below(2) == 0) {
        if (shape == .nested) {
            fit(&text, "c");
            fit(&text, pick(generator, &letters));
            fit_word(generator, &text, word, fold);
        } else {
            fit_word(generator, &text, word, fold);
            fit_pieces(generator, &text);
        }
        fit_word(generator, &text, word, fold);
    }
    fit_pieces(generator, &text);
    case.text_len = text.items.len;
}

/// How a case's pattern writes its word.
const Fold = enum {
    /// As it is: no place folds.
    none,
    /// In `(?i:)`: each letter's place folds.
    whole,
    /// Its first byte in `(?i:)`: that place folds, where the byte is a letter.
    first,
};

/// One case in `fold_share` writes its word with a place that folds, half of them whole.
const fold_share = 4;

/// The bytes a word takes in a pattern at most: the word, and `(?i:)` around it.
const word_pattern_len_max = 16;

/// A word as a pattern writes it.
fn word_pattern(buffer: *[word_pattern_len_max]u8, word: []const u8, fold: Fold) []const u8 {
    return switch (fold) {
        .none => word,
        .whole => std.fmt.bufPrint(buffer, "(?i:{s})", .{word}) catch unreachable,
        .first => std.fmt.bufPrint(buffer, "(?i:{s}){s}", .{ word[0..1], word[1..] }) catch unreachable,
    };
}

/// Adds a word to a text where it fits. For a word with a place that folds, each letter is in
/// upper case in half of the draws, so the text holds the word where only a fold reads it.
fn fit_word(generator: *Generator, text: *std.ArrayList(u8), word: []const u8, fold: Fold) void {
    if (text.unusedCapacitySlice().len < word.len) return;
    for (word) |byte| {
        const upper = fold != .none and std.ascii.isLower(byte) and generator.below(2) == 0;
        text.appendAssumeCapacity(if (upper) std.ascii.toUpper(byte) else byte);
    }
}

/// Draws a case shaped for the searcher's claims, with a text of at most `text_len_max` bytes.
pub fn draw(generator: *Generator, case: *regex_generate.Case, text_len_max: usize) void {
    case.* = .{};
    var pattern: std.ArrayList(u8) = .initBuffer(&case.pattern.octets);
    const run = pick(generator, &runs);
    const word = pick(generator, &words);
    const other = pick(generator, &words);
    const second = pick(generator, &runs);
    const shape: Shape = @enumFromInt(generator.below(std.meta.fields(Shape).len));
    const fold: Fold = switch (generator.below(2 * fold_share)) {
        0 => .whole,
        1 => .first,
        else => .none,
    };
    var word_buffer: [word_pattern_len_max]u8 = undefined;
    write_pattern(&pattern, shape, run, word_pattern(&word_buffer, word, fold), other, second);
    pattern.appendSliceAssumeCapacity(pick(generator, &tails));
    case.pattern.len = pattern.items.len;
    draw_text(generator, case, shape, word, fold, text_len_max);
}

/// Writes the pattern of a shape from its parts.
fn write_pattern(pattern: *std.ArrayList(u8), shape: Shape, run: []const u8, word: []const u8, other: []const u8, second: []const u8) void {
    switch (shape) {
        .suffix => pattern.printAssumeCapacity("{s}{s}", .{ run, word }),
        .prefix => pattern.printAssumeCapacity("{s}{s}", .{ word, run }),
        .inner => pattern.printAssumeCapacity("{s}{s}{s}", .{ run, word, second }),
        .set => pattern.printAssumeCapacity("(?:{s}|{s}){s}", .{ word, other, run }),
        .either => pattern.printAssumeCapacity("(?:{s}{s}|{s})", .{ run, word, other }),
        .nested => pattern.printAssumeCapacity("(?:[ab]|c[ab]{s}){s}{s}", .{ word, word, second }),
        .separated => pattern.printAssumeCapacity("{s} +{s}", .{ run, word }),
        .inner_separated => pattern.printAssumeCapacity("{s} +{s}{s}", .{ run, word, second }),
    }
}

const testing = std.testing;

/// The longest text a test draws.
const test_text_len_max = 12;

test "a drawn case holds a pattern and a text, and some words fold" {
    var generator = Generator.init(1);
    var case: regex_generate.Case = .{};
    var folded: usize = 0;
    var upper: usize = 0;
    const cases = 256;
    for (0..cases) |_| {
        draw(&generator, &case, test_text_len_max);
        try testing.expect(case.pattern.len > 0 and !case.overflowed());
        try testing.expect(case.text_len <= test_text_len_max);
        folded += @intFromBool(std.mem.indexOf(u8, case.pattern.slice(), "(?i:") != null);
        for (case.text[0..case.text_len]) |byte| {
            if (std.ascii.isUpper(byte)) {
                upper += 1;
                break;
            }
        }
    }
    // One case in four folds its word, and the run `(?i:b)*` folds too.
    try testing.expect(folded > cases / 8 and folded < cases / 2);
    try testing.expect(upper > 0 and upper < cases);
}

test "a text holds a word in upper case only where the word folds" {
    var generator = Generator.init(1);
    var buffer: [test_text_len_max]u8 = undefined;
    var upper: usize = 0;
    var lower: usize = 0;
    const draws = 64;
    for (0..draws) |_| {
        var text: std.ArrayList(u8) = .initBuffer(&buffer);
        fit_word(&generator, &text, "ab c", .none);
        try testing.expectEqualStrings("ab c", text.items);
        text.clearRetainingCapacity();
        fit_word(&generator, &text, "ab c", .whole);
        try testing.expect(std.ascii.eqlIgnoreCase("ab c", text.items));
        upper += @intFromBool(!std.mem.eql(u8, "ab c", text.items));
        lower += @intFromBool(std.mem.eql(u8, "ab c", text.items));
    }
    try testing.expect(upper > 0 and lower > 0);
    // A word that does not fit is left out.
    var text: std.ArrayList(u8) = .initBuffer(buffer[0..3]);
    fit_word(&generator, &text, "ab c", .whole);
    try testing.expectEqual(@as(usize, 0), text.items.len);
}

test "a word is written whole, in a fold, or with its first byte in a fold" {
    var buffer: [word_pattern_len_max]u8 = undefined;
    try testing.expectEqualStrings("abc", word_pattern(&buffer, "abc", .none));
    try testing.expectEqualStrings("(?i:abc)", word_pattern(&buffer, "abc", .whole));
    try testing.expectEqualStrings("(?i:a)bc", word_pattern(&buffer, "abc", .first));
    try testing.expectEqualStrings("(?i:b) a", word_pattern(&buffer, "b a", .first));
}
