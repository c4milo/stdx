//! Tests of the claims that wait for text (searcher_claim.zig, decision 86): a searcher judges
//! them once its searches covered enough text, and answers as the matcher answers before the
//! judgment and after it.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const Matches = @import("searcher.zig").Matches;
const Span = @import("../matcher.zig").Span;

/// What a searcher holds once it judged the claims that waited.
const Held = enum { suffix, inner, lengths, none };

/// Patterns with a claim that waits, and what each searcher holds once it judged them.
const waiting = [_]struct { pattern: []const u8, held: Held }{
    // Claim R4's third rule and its second.
    .{ .pattern = "[abx]+ +x", .held = .suffix },
    .{ .pattern = "[ab][abx]x:", .held = .suffix },
    // A literal in the match's middle too: the suffix is the better way, and claim R14 takes none.
    .{ .pattern = "[ab]+x[abx]+ +xa", .held = .suffix },
    .{ .pattern = "[ab]+x[ab]+", .held = .inner },
    .{ .pattern = "[ab]+@[ab]+", .held = .inner },
    .{ .pattern = "^a{2,5}$", .held = .lengths },
    // The walks refuse these: a part that takes the literal's first byte, a separator that the
    // part before it takes, a loop, and no literal at all.
    .{ .pattern = "[abx]+x[ab]+", .held = .none },
    .{ .pattern = "[abx ]+ +x", .held = .none },
    .{ .pattern = "^a+$", .held = .none },
    .{ .pattern = "[ab]+[ab]", .held = .none },
};

/// Patterns with no claim that waits, and whether a claim of searcher_claim.zig finds their
/// matches from `init` on.
const settled = [_]struct { pattern: []const u8, by_claim: bool }{
    // A literal, a literal that starts every match, and a set of literals: claims R2 and R5.
    .{ .pattern = "abc", .by_claim = false },
    .{ .pattern = "ab[ab]+x[ab]+", .by_claim = false },
    .{ .pattern = "ab|ba", .by_claim = false },
    .{ .pattern = "(?:ab|ba)[ab]*x[ab]+", .by_claim = false },
    // Beside a set of literals, claim R4 takes its first rule alone, which `init` judges.
    .{ .pattern = "(?:ab|ba)[abx]* +xa", .by_claim = false },
    // A pattern that starts at the text's start, and does not end at its end.
    .{ .pattern = "^ab[ab]+", .by_claim = false },
    // Claim R12, and claim R4's first rule.
    .{ .pattern = "[ab]+x$", .by_claim = true },
    .{ .pattern = "[ab]+x", .by_claim = true },
};

/// The bytes of a text that no pattern above matches, searched whole while a claim waits.
const chunk_len = 1024;
const no_match = [_]u8{':'} ** chunk_len;

/// The instructions of the fixture's reverse program.
fn reverse_len(fixture: *const Fixture) usize {
    return fixture.program.instructions.len - fixture.program.forward_len;
}

/// Requires the searcher to hold `held` and nothing else, with no claim waiting.
fn expect_held(fixture: *const Fixture, held: Held) !void {
    const searcher = &fixture.searcher;
    try testing.expect(!searcher.deferred.any());
    try testing.expectEqual(held == .suffix, searcher.suffix != null);
    // A suffix that waited is the second rule's or the third's, and keeps an account.
    try testing.expectEqual(held == .suffix, searcher.suffix_wide);
    try testing.expectEqual(held == .inner, searcher.inner != null);
    try testing.expectEqual(held == .lengths, searcher.len_span != std.math.maxInt(usize));
    try testing.expectEqual(held != .none, searcher.by_claim);
}

/// Searches texts with no match until one byte of text is left before the judgment, and
/// requires each search to count the bytes it covered and to judge nothing.
fn cover_all_but_one(fixture: *Fixture) !void {
    const searcher = &fixture.searcher;
    // Each turn but the last covers a chunk, so the turns are the chunks and one.
    for (0..searcher.deferred_left / chunk_len + 1 + 1) |_| {
        const left = searcher.deferred_left;
        if (left == 1) break;
        const len = @min(left - 1, chunk_len);
        try testing.expectEqual(@as(?Span, null), searcher.find(no_match[0..len], 0));
        try testing.expectEqual(left - len, searcher.deferred_left);
    }
    try testing.expectEqual(@as(usize, 1), searcher.deferred_left);
    try testing.expect(searcher.deferred.any() and searcher.by_claim);
    try testing.expect(searcher.suffix == null and searcher.inner == null);
    try testing.expectEqual(@as(usize, std.math.maxInt(usize)), searcher.len_span);
}

test "a searcher judges a claim that waits once its searches covered the text of its program, and no sooner" {
    var fixture: Fixture = .{ .judged = false };
    for (waiting) |case| {
        try fixture.init(case.pattern, searcher_test.cache_words_max);
        try testing.expect(fixture.searcher.deferred.any() and fixture.searcher.by_claim);
        try testing.expectEqual(reverse_len(&fixture) * constants.claim_text_per_instruction, fixture.searcher.deferred_left);
        try cover_all_but_one(&fixture);
        // The byte that was left: the search that covers it judges the claims.
        try testing.expectEqual(@as(?Span, null), fixture.searcher.find(no_match[0..1], 0));
        try expect_held(&fixture, case.held);
    }
}

test "a searcher with no claim that waits holds none from init on" {
    var fixture: Fixture = .{ .judged = false };
    for (settled) |case| {
        try fixture.init(case.pattern, searcher_test.cache_words_max);
        try testing.expect(!fixture.searcher.deferred.any());
        try testing.expectEqual(case.by_claim, fixture.searcher.by_claim);
    }
    // A claim that is off waits for nothing.
    try fixture.init_claims("[ab]+x[ab]+", .{ .inner = false }, searcher_test.cache_words_max);
    try testing.expect(!fixture.searcher.deferred.any() and !fixture.searcher.by_claim);
    try fixture.init_claims("[abx]+ +x", .{ .suffix = false, .inner = false }, searcher_test.cache_words_max);
    try testing.expect(!fixture.searcher.deferred.any() and !fixture.searcher.by_claim);
    try fixture.init_claims("^a{2,5}$", .{ .length = false }, searcher_test.cache_words_max);
    try testing.expect(!fixture.searcher.deferred.any() and !fixture.searcher.by_claim);
    // With claim R1 off, the searcher goes to no place.
    try fixture.init_claims("[abx]+ +x", .{ .start_skip = false }, searcher_test.cache_words_max);
    try testing.expect(!fixture.searcher.deferred.any() and !fixture.searcher.by_claim);
    // With claim R4 off, claim R14 still waits.
    try fixture.init_claims("[ab]+x[ab]+", .{ .suffix = false }, searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.deferred.inner and !fixture.searcher.deferred.suffix);
    // A literal of one byte waits for no second rule: `init` judged the first, which takes it.
    try fixture.init("[abx]+x", searcher_test.cache_words_max);
    try testing.expect(!fixture.searcher.deferred.suffix and fixture.searcher.deferred.inner);
    // Without a reverse DFA no claim reads back, and none waits to.
    try fixture.init("[ab]+x[ab]+", 0);
    try fixture.init("[ab]+x[ab]+", searcher_test.cache_sizes(&fixture.program).least - 1);
    try testing.expect(fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    try testing.expect(!fixture.searcher.deferred.any() and !fixture.searcher.by_claim);
}

test "a search that the DFAs answer with no match runs no matcher, with a claim and with none" {
    var fixture: Fixture = .{};
    // No claim at all, a claim that waits, and claim R4's first rule.
    const patterns = [_][]const u8{ "[ab]+[ab]", "[ab]+@[ab]+", "[ab]+x" };
    for (patterns, 0..) |pattern, index| {
        fixture.judged = index != 1;
        try fixture.init(pattern, searcher_test.cache_words_max);
        const searcher = &fixture.searcher;
        try testing.expectEqual(index != 0, searcher.by_claim);
        searcher.matcher.work = 0;
        try testing.expectEqual(@as(?Span, null), searcher.find(no_match[0 .. chunk_len / 2], 0));
        try testing.expect(searcher.captures(no_match[0 .. chunk_len / 2], 0) == null);
        try testing.expect(!searcher.is_match(no_match[0 .. chunk_len / 2]));
        try testing.expectEqual(@as(@TypeOf(searcher.matcher.work), 0), searcher.matcher.work);
    }
}

/// A text with one match of `[ab]+@[ab]+`, which ends two bytes before the text does.
const one_match = "::ab@ba::";
const one_match_end = 7;

test "each search counts the text it is given, from where it starts to the text's end" {
    var fixture: Fixture = .{ .judged = false };
    try fixture.init("[ab]+@[ab]+", searcher_test.cache_words_max);
    const searcher = &fixture.searcher;
    var left = searcher.deferred_left;
    const span: Span = .{ .start = 2, .end = one_match_end };
    // The match ends before the text does, and the search counts the text whole: a pattern of
    // empty matches covers no byte and reads them all.
    try testing.expectEqual(@as(?Span, span), searcher.find(one_match, 0));
    left -= one_match.len;
    try testing.expectEqual(left, searcher.deferred_left);
    try testing.expectEqual(@as(?Span, null), searcher.find(one_match, one_match_end));
    left -= one_match.len - one_match_end;
    try testing.expectEqual(left, searcher.deferred_left);
    try testing.expect(searcher.captures(one_match, 0) != null);
    left -= one_match.len;
    try testing.expectEqual(left, searcher.deferred_left);
    try testing.expect(searcher.is_match(one_match));
    left -= one_match.len;
    try testing.expectEqual(left, searcher.deferred_left);
    // A count searches from the text's start, and again from the match's end.
    var matches: Matches = .{ .searcher = searcher, .haystack = one_match };
    try testing.expectEqual(@as(u64, 1), matches.count());
    left -= one_match.len + (one_match.len - one_match_end);
    try testing.expectEqual(left, searcher.deferred_left);
    try testing.expect(searcher.deferred.any());
}

test "a pattern of empty matches is judged by the text its searches are given" {
    var fixture: Fixture = .{ .judged = false };
    // Each match is empty, so a search covers no byte: rebar's `slow/quadratic-regex-1x`.
    try fixture.init("(?:a+){4}|", searcher_test.cache_words_max);
    const text = "aaa";
    try testing.expect(fixture.searcher.deferred.any());
    // Each count gives its first search the text whole, so the counts are at most the bytes
    // that are left, and one.
    for (0..fixture.searcher.deferred_left + 1) |_| {
        if (!fixture.searcher.deferred.any()) break;
        var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = text };
        try testing.expectEqual(@as(u64, text.len + 1), matches.count());
    }
    try expect_held(&fixture, .none);
}

test "is_match alone covers the text that claim R13 waits for, and then refuses a text by its length" {
    var fixture: Fixture = .{ .judged = false };
    try fixture.init("^a{2,5}$", searcher_test.cache_words_max);
    const searcher = &fixture.searcher;
    const text = "aaa";
    // Each turn covers the text, so the turns are the text's share of what is left, and one.
    for (0..searcher.deferred_left / text.len + 1) |_| {
        if (!searcher.deferred.any()) break;
        try testing.expect(searcher.is_match(text));
    }
    try expect_held(&fixture, .lengths);
    try testing.expect(!searcher.is_match("a") and searcher.is_match("aaaaa") and !searcher.is_match("aaaaaa"));
}

/// The bytes of a seeded text, and the texts each pattern meets: enough to cover what its
/// claims wait for, from every offset.
const text_len = 83;
const texts_per_pattern = 24;
const alphabet = "abx: @\n";

test "a searcher gives what the matcher gives before it judges a claim, as it judges it, and after" {
    var fixture: Fixture = .{ .judged = false };
    var generator = codec.testing.split.Generator.init(0xC1A13);
    var text: [text_len]u8 = undefined;
    for (waiting) |case| {
        try fixture.init(case.pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(case.pattern, cache_words);
            try testing.expect(fixture.searcher.deferred.any());
            for (0..texts_per_pattern) |_| {
                for (&text) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
                try fixture.expect_agree_everywhere(&text);
            }
            try expect_held(&fixture, case.held);
        }
    }
}
