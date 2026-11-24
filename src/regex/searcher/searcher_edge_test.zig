//! Tests of claims R11, R12 and R13 (decision 86). A searcher whose every match starts at the
//! text's start scans with an anchored forward DFA. A searcher whose every match ends at the
//! text's end reads back from there. A searcher whose every match is the whole text refuses a
//! text by its length. Each gives what the matcher gives.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const searcher_file = @import("searcher.zig");
const Matches = searcher_file.Matches;
const Span = @import("../matcher.zig").Span;

/// The bytes of a test's haystack: some steps of `skip_lanes` bytes, and a part of one.
const haystack_steps = 3;
const haystack_tail = 5;
const haystack_len = haystack_steps * constants.skip_lanes + haystack_tail;

/// The bytes a haystack draws from: the patterns' letters, a space, a line feed and `é`.
const alphabet = "Phabx \n\xC3\xA9";

/// The haystacks each pattern meets under each cache.
const haystacks_per_case = 8;

/// Texts that hold a match at their start, at their end, at both and at neither.
const fixed_texts = [_][]const u8{ "", "Ph", "aa", "Ph aax", "x Ph", "aaaaaa", "abx\xC3\xA9", "ax\nPh\n", "bax" };

/// Patterns whose every match starts at the text's start.
const start_patterns = [_][]const u8{
    "^Ph", "^a{2,5}$", "\\A(a|ab)(x|bx)(x*)", "^(?:ab)*", "^", "^a*?b", "(^a)b", "\\A\\bPh", "\\b^a+", "^[ab]+x",
};

/// Patterns with `^` or `\A` whose match may start elsewhere, or with neither.
const no_start_patterns = [_][]const u8{ "(?m)^a", "^a|b", "a|^b", "(?:^a)?b", "\\bPh", "a^b", "Ph" };

/// Patterns whose every match ends at the text's end, and may start anywhere.
const end_patterns = [_][]const u8{
    "Ph$",             "[ab]+x$", "\\w$",    "a*$",   "$",    "(?:a|)$", "x\\z",          "(b)*(a)x$",
    "[ab]*?\xC3\xA9$", "\\bPh$",  "(?i)ph$", "a$\\b", "\\B$", "[^x]*x$", "(a|ab)(x|bx)$",
};

/// Patterns with `$` or `\z` whose match may end elsewhere, or whose every match starts at the
/// text's start too, which claim R11 takes.
const no_end_patterns = [_][]const u8{ "(?m)x$", "x(?:$|a)", "x$|a", "a|x$", "^x$", "\\A[ab]*\\z", "x\\b", "x$a" };

/// The bytes that end half of the seeded texts: a match of most patterns, so that a search
/// from the text's end finds a match as often as none.
const ending = "Phx";

fn fill(generator: *codec.testing.split.Generator, haystack: []u8) void {
    for (haystack) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
    const ends = [_]bool{ true, false };
    if (ends[generator.below(ends.len)]) @memcpy(haystack[haystack.len - ending.len ..], ending);
}

/// Requires the fixture's searcher to give what the matcher gives on the fixed texts and on
/// seeded ones.
fn expect_agree_on_texts(fixture: *Fixture, generator: *codec.testing.split.Generator) !void {
    var haystack: [haystack_len]u8 = undefined;
    for (0..haystacks_per_case) |_| {
        fill(generator, &haystack);
        try fixture.expect_agree_everywhere(&haystack);
    }
    for (fixed_texts) |text| try fixture.expect_agree_everywhere(text);
}

/// Requires `Matches` of the fixture's searcher to give the spans and the count that a searcher
/// with claims R11 and R12 off gives.
fn expect_matches(fixture: *Fixture, plain: *Fixture, haystack: []const u8) !void {
    var expected: Matches = .{ .searcher = &plain.searcher, .haystack = haystack };
    var found: Matches = .{ .searcher = &fixture.searcher, .haystack = haystack };
    var total: u64 = 0;
    // No two matches start at one offset, so the matches are at most the offsets, and the
    // turn after the last one finds none.
    for (0..haystack.len + 1 + 1) |_| {
        const span = expected.next();
        try testing.expectEqual(span, found.next());
        if (span == null) break;
        total += 1;
    }
    var counted: Matches = .{ .searcher = &fixture.searcher, .haystack = haystack };
    try testing.expectEqual(total, counted.count());
}

test "a searcher whose every match starts at the text's start scans anchored, and agrees" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x7E57A);
    for (start_patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            try testing.expect(fixture.searcher.at_text and fixture.searcher.forward.config.anchored);
            // An anchored scan waits for no match, so it holds no literal to go to.
            try testing.expect(fixture.searcher.forward.literal == null and !fixture.searcher.forward.may_skip);
            try testing.expect(!fixture.searcher.at_end);
            try expect_agree_on_texts(&fixture, &generator);
        }
        // The claim off leaves the forward DFA to wait for a match.
        try fixture.init_claims(pattern, .{ .text_start = false }, sizes.most);
        try testing.expect(fixture.searcher.at_text and !fixture.searcher.forward.config.anchored);
        try expect_agree_on_texts(&fixture, &generator);
    }
}

test "a searcher whose match may start past the text's start does not scan anchored" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x7E57B);
    for (no_start_patterns) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        try testing.expect(!fixture.searcher.at_text and !fixture.searcher.forward.config.anchored);
        try expect_agree_on_texts(&fixture, &generator);
    }
}

test "a searcher whose every match ends at the text's end reads back from there, and agrees" {
    var fixture: Fixture = .{};
    var plain: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x7E57C);
    var haystack: [haystack_len]u8 = undefined;
    for (end_patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        try plain.init_claims(pattern, .{ .text_start = false, .text_end = false }, sizes.most);
        try testing.expect(!plain.searcher.at_end);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            // The search from the end takes the place of claim R4's.
            try testing.expect(fixture.searcher.at_end and fixture.searcher.suffix == null);
            try expect_agree_on_texts(&fixture, &generator);
            for (0..haystacks_per_case) |_| {
                fill(&generator, &haystack);
                try expect_matches(&fixture, &plain, &haystack);
            }
            for (fixed_texts) |text| try expect_matches(&fixture, &plain, text);
        }
    }
}

test "a searcher whose match may end before the text's end does not read back from there" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x7E57D);
    for (no_end_patterns) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        try testing.expect(!fixture.searcher.at_end);
        try expect_agree_on_texts(&fixture, &generator);
    }
    // No reverse DFA, no search from the end: the forward DFA takes the whole cache.
    try fixture.init("[ab]+x$", 0);
    try fixture.init("[ab]+x$", searcher_test.cache_sizes(&fixture.program).least - 1);
    try testing.expect(fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    try testing.expect(!fixture.searcher.at_end);
    try expect_agree_on_texts(&fixture, &generator);
}

/// The bytes of a text long enough to tell a scan of a few bytes from a scan of the text.
const long_text_len = 4096;

/// The most bytes a scan that stops at the pattern's end reads of a long text.
const few_bytes = 8;

test "an anchored scan stops where no thread is left, and reads few bytes of a long text" {
    var fixture: Fixture = .{};
    // Every place of this text holds the literal `aa`, which claim R3 goes to in turn.
    const text = [_]u8{'a'} ** long_text_len;
    // Claim R13 would refuse the text by its length, so it is off here.
    try fixture.init_claims("^a{2,5}$", .{ .length = false }, searcher_test.cache_words_max);
    try testing.expectEqual(@as(?Span, null), fixture.searcher.find(&text, 0));
    try testing.expect(!fixture.searcher.is_match(&text));
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = &text };
    try testing.expectEqual(@as(u64, 0), matches.count());
    try testing.expect(fixture.searcher.forward.cache.scanned <= few_bytes);
    // The claim off scans the text.
    try fixture.init_claims("^a{2,5}$", .{ .text_start = false, .length = false }, searcher_test.cache_words_max);
    try testing.expectEqual(@as(?Span, null), fixture.searcher.find(&text, 0));
    try testing.expect(fixture.searcher.forward.cache.scanned >= long_text_len / 2);
}

test "a search from the text's end reads few bytes of a long text, and none forward" {
    var fixture: Fixture = .{};
    const text = [_]u8{'*'} ** long_text_len ++ "X";
    const pattern = "\\w$";
    try fixture.init(pattern, searcher_test.cache_words_max);
    const expected: Span = .{ .start = long_text_len, .end = long_text_len + 1 };
    try testing.expectEqual(@as(?Span, expected), fixture.searcher.find(text, 0));
    try testing.expect(fixture.searcher.is_match(text));
    try testing.expect(!fixture.searcher.is_match(text[0..long_text_len]));
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = text };
    try testing.expectEqual(@as(u64, 1), matches.count());
    try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.cache.state_count);
    try testing.expect(fixture.searcher.reverse.cache.scanned <= few_bytes);
    // The claim off scans the text forward.
    try fixture.init_claims(pattern, .{ .text_end = false }, searcher_test.cache_words_max);
    try testing.expectEqual(@as(?Span, expected), fixture.searcher.find(text, 0));
    try testing.expect(fixture.searcher.forward.cache.state_count > 0);
}

/// Patterns whose every match is the whole text, and that hold no loop.
const whole_patterns = [_][]const u8{
    "^a{2,5}$", "^((aaa)|(aa))$", "\\A[ab]x?\\z", "^$", "^(?:Ph|x)$", "^.{2}$", "^(a|ab)(x|bx)$", "(^Ph)$",
};

/// Patterns that hold a loop, or whose match may be a part of the text.
const no_whole_patterns = [_][]const u8{ "^a+$", "^ab", "ab$", "(?m)^ab$", "^a$|^b$", "^[ab]*x$", "ab" };

/// True when the fixture's searcher refuses a text of some length by claim R13.
fn refuses_by_length(fixture: *const Fixture) bool {
    return fixture.searcher.len_span != std.math.maxInt(usize);
}

test "a searcher whose every match is the whole text refuses a text by its length, and agrees" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x7E57F);
    for (whole_patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            try testing.expect(refuses_by_length(&fixture));
            try testing.expect(!fixture.searcher.at_end);
            try expect_agree_on_texts(&fixture, &generator);
        }
        // The walk takes the forward DFA's lists, so a searcher with no cache keeps no lengths.
        try fixture.init(pattern, sizes.none);
        try testing.expect(!refuses_by_length(&fixture));
        try expect_agree_on_texts(&fixture, &generator);
        try fixture.init_claims(pattern, .{ .length = false }, sizes.most);
        try testing.expect(!refuses_by_length(&fixture));
        try expect_agree_on_texts(&fixture, &generator);
    }
}

test "a searcher keeps no lengths for a pattern with a loop, or one that a part of a text matches" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x7E580);
    for (no_whole_patterns) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        try testing.expect(!refuses_by_length(&fixture));
        try expect_agree_on_texts(&fixture, &generator);
    }
}

test "a text of a length that no match has is read by no DFA, and each length of a match is" {
    var fixture: Fixture = .{};
    const text = [_]u8{'a'} ** long_text_len;
    try fixture.init("^a{2,5}$", searcher_test.cache_words_max);
    // One byte under the least length, one over the greatest, and a long text.
    for ([_]usize{ 1, 6, long_text_len }) |len| {
        try testing.expectEqual(@as(?Span, null), fixture.searcher.find(text[0..len], 0));
        try testing.expect(!fixture.searcher.is_match(text[0..len]));
        var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = text[0..len] };
        try testing.expectEqual(@as(u64, 0), matches.count());
    }
    try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.cache.state_count);
    // The least length and the greatest.
    for ([_]usize{ 2, 5 }) |len| {
        try testing.expectEqual(@as(?Span, .{ .start = 0, .end = len }), fixture.searcher.find(text[0..len], 0));
        try testing.expect(fixture.searcher.is_match(text[0..len]));
        var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = text[0..len] };
        try testing.expectEqual(@as(u64, 1), matches.count());
    }
    try testing.expect(fixture.searcher.forward.cache.state_count > 0);
}

/// The bytes of a text whose states outgrow the least cache of the pattern below.
const give_up_text_len = 600;

test "a search from the text's end whose DFA gives up takes the matcher's answer" {
    // Read backward, the pattern holds an `a` nine places behind any place: 2^9 states.
    const pattern = "(?:a|b){8}a(?:a|b)*$";
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).least);
    try testing.expect(fixture.searcher.at_end);
    var generator = codec.testing.split.Generator.init(0x7E57E);
    var text: [give_up_text_len]u8 = undefined;
    for (&text) |*octet| octet.* = "ab"[generator.below(2)];
    try fixture.expect_agree(&text, 0);
    try testing.expect(fixture.searcher.give_ups > 0);
}
