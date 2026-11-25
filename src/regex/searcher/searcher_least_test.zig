//! Tests of claim R13's least length (decision 86): the compiler counts the fewest bytes a match
//! takes (`Program.len_min`), and a searcher refuses a text with fewer bytes after a search's
//! start. Each answer is the matcher's.
const std = @import("std");
const testing = std.testing;
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const searcher_file = @import("searcher.zig");
const Matches = searcher_file.Matches;
const Span = @import("../matcher.zig").Span;

test "the compiler counts the fewest bytes a match takes" {
    const cases = [_]struct { pattern: []const u8, least: u32 }{
        .{ .pattern = "\\w{10,}", .least = 10 },
        .{ .pattern = "a|bcd", .least = 1 },
        .{ .pattern = "(?:abc)?", .least = 0 },
        .{ .pattern = "^a{2,5}$", .least = 2 },
        .{ .pattern = "\\bab(?:cd|e)", .least = 3 },
        .{ .pattern = "(?:foo|barbaz)+x", .least = 4 },
        .{ .pattern = "(a)(b{3})c*", .least = 4 },
        .{ .pattern = "Sherlock|Holmes|Watson", .least = 6 },
        .{ .pattern = "[a-z]{2}(?:[0-9]|xyz){2}", .least = 4 },
    };
    var fixture: Fixture = .{ .encoding = .bytes };
    for (cases) |case| {
        try fixture.init(case.pattern, searcher_test.cache_words_max);
        try testing.expectEqual(case.least, fixture.program.len_min);
        try testing.expectEqual(@as(usize, case.least), fixture.searcher.len_min);
    }
    // In UTF-8, `é` and `à` take two bytes each, and a class of ASCII one.
    var utf8: Fixture = .{};
    try utf8.init("[\xC3\xA9\xC3\xA0]{3}", searcher_test.cache_words_max);
    try testing.expectEqual(@as(u32, 6), utf8.program.len_min);
    try utf8.init("[a\xC3\xA9]{3}", searcher_test.cache_words_max);
    try testing.expectEqual(@as(u32, 3), utf8.program.len_min);
    // With the claim off, the searcher takes no least length.
    try fixture.init_claims("\\w{10,}", .{ .length = false }, searcher_test.cache_words_max);
    try testing.expectEqual(@as(usize, 0), fixture.searcher.len_min);
}

/// The letters of a test trie's words: `b` and two of them, more words than claim R5 takes.
const trie_letters = "abcdefghij";
const trie_words = trie_letters.len * trie_letters.len;

/// The words `baa` to `bjj`, then `shortest`. The trie sorts its literals by their bytes, so
/// `a` comes first among them and `z` last.
fn trie_pattern(comptime shortest: u8) []const u8 {
    comptime {
        @setEvalBranchQuota(trie_words * trie_letters.len);
        var pattern: []const u8 = "";
        for (0..trie_words) |word| {
            pattern = pattern ++ "b" ++ [_]u8{ trie_letters[word / trie_letters.len], trie_letters[word % trie_letters.len], '|' };
        }
        pattern = pattern ++ [_]u8{shortest};
        const whole = pattern[0..pattern.len].*;
        return &whole;
    }
}

test "the compiler counts a trie's shortest literal, first or last" {
    comptime std.debug.assert(trie_words > constants.literal_set_max);
    var fixture: Fixture = .{ .encoding = .bytes };
    inline for ("az") |shortest| {
        try fixture.init(comptime trie_pattern(shortest), searcher_test.cache_words_max);
        // A trie shares `b`, so its program takes fewer instructions than its words' bytes.
        try testing.expect(fixture.program.forward_len < trie_words * 2);
        try testing.expectEqual(@as(u32, 1), fixture.program.len_min);
        try fixture.expect_agree_everywhere("xaz");
    }
}

test "a searcher refuses a text shorter than its least match, wherever the pattern stands" {
    var fixture: Fixture = .{ .encoding = .bytes };
    try fixture.init("\\w{10,}", searcher_test.cache_words_max);
    // Nine bytes, and ten.
    try testing.expect(!fixture.searcher.is_match("abcdefghi"));
    try testing.expect(fixture.searcher.is_match("abcdefghij"));
    try testing.expectEqual(@as(?Span, null), fixture.searcher.find("xxabcdefghi", 2));
    try testing.expect(fixture.searcher.find("xabcdefghij", 1) != null);
    try testing.expect(fixture.searcher.captures("abcdefghi", 0) == null);
    var short: Matches = .{ .searcher = &fixture.searcher, .haystack = "abc def ghi" };
    try testing.expectEqual(@as(u64, 0), short.count());
    var long: Matches = .{ .searcher = &fixture.searcher, .haystack = "abcdefghij klmnopqrstu" };
    try testing.expectEqual(@as(u64, 2), long.count());
    // A pattern of the whole text, refused by its length in `Matches.count` too.
    try fixture.init("^a{2,5}$", searcher_test.cache_words_max);
    var whole: Matches = .{ .searcher = &fixture.searcher, .haystack = "aaaaaa" };
    try testing.expectEqual(@as(u64, 0), whole.count());
    var fits: Matches = .{ .searcher = &fixture.searcher, .haystack = "aaaa" };
    try testing.expectEqual(@as(u64, 1), fits.count());
}

test "a searcher with a least length gives what the matcher gives on texts near that length" {
    var fixture: Fixture = .{ .encoding = .bytes };
    const patterns = [_][]const u8{ "\\w{4,}", "ab(?:cd|e)f", "a[bc]{2}d?" };
    const texts = [_][]const u8{ "", "a", "ab", "abc", "abcd", "abcde", "abcdef", "xabcdef", "abef", "abbd", "abcbd" };
    for (patterns) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        for (texts) |text| try fixture.expect_agree_everywhere(text);
    }
}

test "a count of a text shorter than the least match pays a claim's account, as a search does" {
    // Claim R14 and claim R4's wide suffix keep an account. A search pays its start to it, or
    // counts the text toward a rest, so a count of a short text searches too.
    const cases = [_]struct { pattern: []const u8, text: []const u8 }{
        .{ .pattern = "[ab]+x[ab]+", .text = "ax" },
        .{ .pattern = "[abx]+ +xa", .text = "a x" },
    };
    var counted: Fixture = .{ .fresh_account = false };
    var searched: Fixture = .{ .fresh_account = false };
    for (cases) |case| {
        for ([_]usize{ 0, constants.account_rest_bytes }) |rest| {
            try counted.init(case.pattern, searcher_test.cache_words_max);
            try searched.init(case.pattern, searcher_test.cache_words_max);
            try testing.expect(counted.searcher.inner != null or counted.searcher.suffix_wide);
            try testing.expect(case.text.len < counted.searcher.len_min);
            counted.searcher.account.rest = rest;
            searched.searcher.account.rest = rest;
            var matches: Matches = .{ .searcher = &counted.searcher, .haystack = case.text };
            try testing.expectEqual(@as(u64, 0), matches.count());
            try testing.expectEqual(@as(?Span, null), searched.searcher.find(case.text, 0));
            try testing.expectEqual(searched.searcher.account, counted.searcher.account);
            // At rest, the text counts toward the rest.
            if (rest > 0) try testing.expectEqual(rest - case.text.len, counted.searcher.account.rest);
        }
    }
}

test "a searcher refuses a short text before a DFA builds a state for it" {
    var fixture: Fixture = .{ .encoding = .bytes };
    try fixture.init("\\w{10,}", searcher_test.cache_words_max);
    const searcher = &fixture.searcher;
    try testing.expectEqual(@as(u32, 0), searcher.forward.cache.state_count);
    // Nine bytes and seven: `is_match`, `find` and `count` each refuse them by their length.
    try testing.expect(!searcher.is_match("abcdefghi"));
    try testing.expectEqual(@as(?Span, null), searcher.find("xabcdefghi", 1));
    var matches: Matches = .{ .searcher = searcher, .haystack = "abc def" };
    try testing.expectEqual(@as(u64, 0), matches.count());
    try testing.expectEqual(@as(u32, 0), searcher.forward.cache.state_count);
    // A text of the least length is searched.
    try testing.expect(searcher.is_match("abcdefghij"));
    try testing.expect(searcher.forward.cache.state_count > 0);
}
