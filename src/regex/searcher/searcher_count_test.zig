//! Tests of claim R10 (decision 86): `Matches.count` gives the count of the matches `next` gives,
//! and reads no match back to its start where the forward DFA finds its end.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const generate = @import("../generate_test.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const Matches = @import("searcher.zig").Matches;
const Span = @import("../matcher.zig").Span;

/// Patterns of empty matches, of matches that touch, of scalar values of more than one octet, and
/// of each claim that finds a match: a literal, a set of literals, a suffix, and the text's start.
const patterns = [_][]const u8{
    "a+",             "a*",          "",        "a|",        "$",              "\\b\\w+\\b",
    "x*",
    "[a-cé]{2,3}",
    ".*[^A-Z]|[A-Z]", "abc",         "foo|bar", "[a-z]+ing", "^(a|ab)(c|bcd)", "\\Aa|b\\z",
    "(?m)^[a-z]*$",   "[^ ]+ [^ ]+", "\\B",
    "é|ab*",
};

/// The octets a text draws from: the letters of the patterns, separators, and the two octets of
/// `é`, drawn whole.
const alphabet = [_][]const u8{ "a", "b", "c", "x", "A", " ", "\n", "ing", "foo", "\xC3\xA9" };

/// The texts each case draws, the parts of a text, and the seed they come from.
const texts_per_case = 8;
const parts_max = 24;
const seed = 0xC0047;

/// The most octets of a part of the alphabet, and of a text.
const part_len_max = 3;
const text_len_max = part_len_max * parts_max;

fn fill(generator: *codec.testing.split.Generator, buffer: *[text_len_max]u8) []const u8 {
    var len: usize = 0;
    for (0..generator.below(parts_max + 1)) |_| {
        const part = alphabet[generator.below(alphabet.len)];
        @memcpy(buffer[len..][0..part.len], part);
        len += part.len;
    }
    return buffer[0..len];
}

/// Requires `count` to give the count of the matches `next` gives, and to leave none for `next`.
fn expect_count(fixture: *Fixture, haystack: []const u8) !void {
    var spans: Matches = .{ .searcher = &fixture.searcher, .haystack = haystack };
    var expected: u64 = 0;
    while (spans.next()) |_| expected += 1;
    var counted: Matches = .{ .searcher = &fixture.searcher, .haystack = haystack };
    try testing.expectEqual(expected, counted.count());
    try testing.expect(counted.position > haystack.len);
    try testing.expectEqual(@as(?Span, null), counted.next());
}

test "count gives the count of the matches next gives, in every cache, with the claim on and off" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(seed);
    var buffer: [text_len_max]u8 = undefined;
    for (patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least, sizes.none }) |cache_words| {
            for ([_]bool{ true, false }) |count_ends| {
                try fixture.init_claims(pattern, .{ .count_ends = count_ends }, cache_words);
                for (0..texts_per_case) |_| try expect_count(&fixture, fill(&generator, &buffer));
            }
        }
    }
}

const generated_patterns = 300;

test "count gives the count of the matches next gives, for generated patterns and texts" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(seed + 1);
    var pattern_buffer: [generate.pattern_len_max]u8 = undefined;
    var text_buffer: [generate.text_len_max]u8 = undefined;
    for (0..generated_patterns) |round| {
        const pattern = generate.pattern(&generator, &pattern_buffer);
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        try fixture.init(pattern, if (round & 1 == 0) sizes.most else sizes.least);
        for (0..texts_per_case) |_| try expect_count(&fixture, generate.text(&generator, &text_buffer));
    }
}

test "a count reads no match back to its start" {
    var fixture: Fixture = .{};
    const haystack = "a aa aaa b bb";
    try fixture.init("a+|b+", searcher_test.cache_words_max);
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = haystack };
    try testing.expectEqual(@as(u64, 5), matches.count());
    try testing.expectEqual(@as(u32, 0), fixture.searcher.reverse.cache.state_count);
    // The claim off reads each match back.
    try fixture.init_claims("a+|b+", .{ .count_ends = false }, searcher_test.cache_words_max);
    matches = .{ .searcher = &fixture.searcher, .haystack = haystack };
    try testing.expectEqual(@as(u64, 5), matches.count());
    try testing.expect(fixture.searcher.reverse.cache.state_count > 0);
}

test "a count takes the forward DFA where the reverse DFA did not start" {
    var fixture: Fixture = .{};
    const pattern = "(a|b)+c";
    try fixture.init(pattern, 0);
    // Under the two leasts, the forward DFA takes the whole cache, and the reverse one none.
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).least - 1);
    try testing.expect(fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    try expect_count(&fixture, "abc ac bbbc c abab");
    try testing.expect(fixture.searcher.forward.cache.state_count > 0);
}

test "a count by a literal's claim reads no forward DFA" {
    var fixture: Fixture = .{};
    // A literal, a set of literals, and a suffix, which claim R4 reads back from.
    for ([_][]const u8{ "abc", "foo|bar", "[0-9]+ing" }) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = "abc foo bar abcabc 12ing" };
        try testing.expect(matches.count() > 0);
        try testing.expect(fixture.searcher.exact != null or fixture.searcher.exact_set or fixture.searcher.suffix != null);
        try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.cache.state_count);
    }
}

/// The octets of a text whose states outgrow the least cache of the pattern below.
const give_up_text_len = 600;

test "a count whose DFA gives up counts it, and stops trying the DFA at the limit" {
    const pattern = "(a|b)*a(a|b){8}c";
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    try fixture.init_claims(pattern, .{ .suffix = false }, searcher_test.cache_sizes(&fixture.program).least);
    var generator = codec.testing.split.Generator.init(seed + 2);
    var text: [give_up_text_len]u8 = undefined;
    for (&text) |*octet| octet.* = "ab"[generator.below(2)];
    // The count's own scan gives up, and so does the search that then finds no match.
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = &text };
    try testing.expectEqual(@as(u64, 0), matches.count());
    try testing.expectEqual(@as(u32, 2), fixture.searcher.give_ups);
    fixture.searcher.give_ups = constants.dfa_give_ups_max;
    const scanned = fixture.searcher.forward.cache.scanned;
    matches = .{ .searcher = &fixture.searcher, .haystack = &text };
    try testing.expectEqual(@as(u64, 0), matches.count());
    try testing.expectEqual(scanned, fixture.searcher.forward.cache.scanned);
}
