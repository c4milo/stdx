//! Tests of `Encoding.bytes` (decision 86 as amended): `.`, a class and an escape such as `\xE9`
//! take one byte each, a character past U+007F matches its UTF-8, a byte past 0x7F has no
//! case and no class, and a match may start before any byte. The searcher's faster ways must
//! give what the matcher gives there too.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const compiler = @import("../compile.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const Matches = @import("searcher.zig").Matches;
const Span = @import("../matcher.zig").Span;
const Instruction = @import("../program.zig").Instruction;
const Encoding = @import("../program.zig").Encoding;

/// The most matches a case of the tests below names.
const spans_max = 4;

/// A case: a pattern, a text, and the spans of its matches in each encoding.
const Case = struct {
    pattern: []const u8,
    text: []const u8,
    bytes: []const Span,
    utf8: []const Span,
};

fn span(start: u64, end: u64) Span {
    return .{ .start = start, .end = end };
}

/// Requires the searcher to give `expected` from `next` and its count from `count`, and every
/// faster way of it to give what the matcher gives.
fn expect_spans(fixture: *Fixture, text: []const u8, expected: []const Span) !void {
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = text };
    var found: [spans_max]Span = undefined;
    var len: usize = 0;
    while (matches.next()) |next| : (len += 1) {
        if (len == spans_max) return error.TestTooManyMatches;
        found[len] = next;
    }
    try testing.expectEqualSlices(Span, expected, found[0..len]);
    var counted: Matches = .{ .searcher = &fixture.searcher, .haystack = text };
    try testing.expectEqual(@as(u64, len), counted.count());
    try fixture.expect_agree_everywhere(text);
}

test "in bytes each atom takes bytes of any value, and a match may start before any byte" {
    const cases = [_]Case{
        // A line of bytes that are not UTF-8 is a line in bytes, and none in UTF-8.
        .{ .pattern = "(?m)^.+$", .text = "ab\n\xFF\xFE\nc\x80d\n\xC3\xA9", .bytes = &.{ span(0, 2), span(3, 5), span(6, 9), span(10, 12) }, .utf8 = &.{ span(0, 2), span(10, 12) } },
        // An empty match starts before a continuation byte in bytes alone.
        .{ .pattern = "", .text = "\x80\x80", .bytes = &.{ span(0, 0), span(1, 1), span(2, 2) }, .utf8 = &.{span(2, 2)} },
        // `\xE9` is one byte in bytes, and the two of `é`'s UTF-8 otherwise.
        .{ .pattern = "\\xE9", .text = "\xC3\xA9\xE9", .bytes = &.{span(2, 3)}, .utf8 = &.{span(0, 2)} },
        // A character past U+007F is its UTF-8 in both.
        .{ .pattern = "\xC3\xA9", .text = "\xC3\xA9\xE9", .bytes = &.{span(0, 2)}, .utf8 = &.{span(0, 2)} },
        // Past 0x7F a byte has no case in bytes, as an escape or as a character's UTF-8.
        .{ .pattern = "(?i)\\xE9", .text = "\xC9\xE9\xC3\x89", .bytes = &.{span(1, 2)}, .utf8 = &.{span(2, 4)} },
        .{ .pattern = "(?i)\xC3\xA9", .text = "\xC3\xA9\xC3\x89", .bytes = &.{span(0, 2)}, .utf8 = &.{ span(0, 2), span(2, 4) } },
        .{ .pattern = "(?i)[\\xC0-\\xC9]", .text = "\xE9\xC9", .bytes = &.{span(1, 2)}, .utf8 = &.{} },
        // `(?i)` folds ASCII in bytes, with no Kelvin sign, in a literal and in a class.
        .{ .pattern = "(?i)k", .text = "Kk\xE2\x84\xAA", .bytes = &.{ span(0, 1), span(1, 2) }, .utf8 = &.{ span(0, 1), span(1, 2), span(2, 5) } },
        .{ .pattern = "(?i)[k]", .text = "Kk\xE2\x84\xAA", .bytes = &.{ span(0, 1), span(1, 2) }, .utf8 = &.{ span(0, 1), span(1, 2), span(2, 5) } },
        .{ .pattern = "(?i)\\x6B", .text = "Kk", .bytes = &.{ span(0, 1), span(1, 2) }, .utf8 = &.{ span(0, 1), span(1, 2) } },
        .{ .pattern = "(?i)[^k]", .text = "Kkx\xFF", .bytes = &.{ span(2, 3), span(3, 4) }, .utf8 = &.{span(2, 3)} },
        // A negated class takes any byte it does not name.
        .{ .pattern = "[^a]", .text = "a\xFF", .bytes = &.{span(1, 2)}, .utf8 = &.{} },
        .{ .pattern = "\\W", .text = "a\xFF", .bytes = &.{span(1, 2)}, .utf8 = &.{} },
        // `(?s).` takes a line feed, and any other byte, in bytes.
        .{ .pattern = "(?s).", .text = "\n\x80", .bytes = &.{ span(0, 1), span(1, 2) }, .utf8 = &.{span(0, 1)} },
        // Groups at the text's start, which one thread finds with no DFA (claim R6).
        .{ .pattern = "^(\\x80)(b)", .text = "\x80b", .bytes = &.{span(0, 2)}, .utf8 = &.{} },
        // A match that starts at a continuation byte, found from its suffix (claim R4).
        .{ .pattern = "[\\x80-\\xBF]+xyz", .text = "a\x80\xBFxyz", .bytes = &.{span(1, 6)}, .utf8 = &.{} },
    };
    var fixture: Fixture = .{};
    for (cases) |case| {
        for ([_]Encoding{ .bytes, .utf8 }) |encoding| {
            fixture.encoding = encoding;
            try fixture.init(case.pattern, searcher_test.cache_words_max);
            try expect_spans(&fixture, case.text, if (encoding == .bytes) case.bytes else case.utf8);
        }
    }
}

test "bytes refuses what names Unicode past ASCII where it takes one byte, and UTF-8 takes it" {
    var storage: [@import("../matcher_test.zig").storage_len]Instruction = undefined;
    const refused = [_][]const u8{ "\\x{100}", "\\777", "[\\x{100}]", "\\p{Greek}", "\\PL", "[\\pL]", "[\xC3\xA9]", "[a-\xC3\xA9]" };
    for (refused) |pattern| {
        try testing.expectError(error.UnsupportedUnicode, compiler.compile(pattern, .{ .encoding = .bytes }, &storage));
        // UTF-8 takes each, here in a forward program alone, which the storage holds.
        _ = try compiler.compile(pattern, .{ .reverse = false }, &storage);
    }
    // The pattern is UTF-8 in both: a raw byte past 0x7F alone is refused, and `\xFF` names it.
    try testing.expectError(error.InvalidUtf8, compiler.compile("\xFF+", .{ .encoding = .bytes }, &storage));
    var fixture: Fixture = .{ .encoding = .bytes };
    try fixture.init("\\xFF+", searcher_test.cache_words_max);
    try expect_spans(&fixture, "a\xFF\xFFb", &.{span(1, 3)});
    // A range of a class may end at an escape past 0x7F.
    try fixture.init("[a-\\xE9]+", searcher_test.cache_words_max);
    try expect_spans(&fixture, "\xC0b\xEA", &.{span(0, 2)});
}

/// Patterns whose matches may start before a continuation byte in bytes, for each faster way:
/// a literal, a set of literals, a suffix, one-pass groups, and a DFA.
const patterns = [_][]const u8{
    ".",          "\\xA9",           "\\x80|\\xBF\\xA9", "[\\x80-\\xBF]+xy", "(\\xC3|\\x80)(\\xA9|b)",
    "(?i)\\xE9+", "[^a\\n]{2}",      "\\b\\w+\\b",       "(?m)^.*$",         "\\B",
    "a*",         "\\W+|[^\\x00-~]", "(?s).\\xFF",       "\xC3\xA9|\\xE9",   "(?i)[a-z\\xC0]+",
};

/// The bytes a text draws from: ASCII, continuation bytes, lead bytes, and bytes that UTF-8
/// never holds.
const alphabet = "ab xyA\n\x80\xA9\xBF\xC0\xC3\xC9\xE9\xFE\xFF";

const texts_per_pattern = 16;
const text_len_max = 24;
const seed = 0x1A71;

test "the searcher gives what the matcher gives in bytes, in every cache" {
    var fixture: Fixture = .{ .encoding = .bytes };
    var generator = codec.testing.split.Generator.init(seed);
    var text: [text_len_max]u8 = undefined;
    for (patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least, sizes.none }) |cache_words| {
            try fixture.init(pattern, cache_words);
            for (0..texts_per_pattern) |_| {
                const len = generator.below(text_len_max + 1);
                for (text[0..len]) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
                try fixture.expect_agree_everywhere(text[0..len]);
            }
        }
    }
}
