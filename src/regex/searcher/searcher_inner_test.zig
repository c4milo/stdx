//! Tests of claim R14 (decision 86): a searcher that goes to the places of a literal in the
//! middle of every match gives what the matcher gives.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const Matches = @import("searcher.zig").Matches;
const Span = @import("../matcher.zig").Span;
const Context = @import("../program.zig").Context;

/// The octets of a test's haystack: some steps of `skip_lanes` octets, and a part of one.
const haystack_steps = 5;
const haystack_tail = 3;
const haystack_len = haystack_steps * constants.skip_lanes + haystack_tail;

/// The octets a haystack draws from: the patterns' letters and literals, separators and `é`.
const alphabet = "abx:y \n\xC3\xA9";

/// The haystacks each pattern meets under each cache.
const haystacks_per_case = 8;

/// Texts on which a search from a literal's places that broke a rule gives another answer than
/// the matcher.
const fixed_texts = [_][]const u8{
    "",      "axb",       "ab xa axxb",    "a x:b ax:b", "axaxaxax", "ax ax bxy bx", "a  xa b",
    "xaxbx", "ab:x:ba::", "ba xab\nab xa", "abxab::ab",  "axyaxy:",  "bxxxa",        "ax bxa",
};

/// Patterns that hold a literal in the middle of every match, after a part that one of claim
/// R4's rules holds for, and their literals.
const inner_cases = [_]struct { pattern: []const u8, literal: []const u8 }{
    // The part before the literal takes no byte that is the literal's first.
    .{ .pattern = "[ab]+x[ab]+", .literal = "x" },
    .{ .pattern = "[ab]+x:[ab]*", .literal = "x:" },
    .{ .pattern = "[ab]*x(?:a|b)", .literal = "x" },
    .{ .pattern = "([ab]+)x([ab]+)", .literal = "x" },
    .{ .pattern = "\\b[ab]+x[ab]+\\b", .literal = "x" },
    .{ .pattern = "[ab]+x[^:]*:y?", .literal = "x" },
    .{ .pattern = "[ab]+x(?:[^:]*:|y)", .literal = "x" },
    // The longest of two literals.
    .{ .pattern = "[ab]+x[ab]+::[ab]+", .literal = "::" },
    // The part before the literal takes one count of bytes.
    .{ .pattern = "[abx][ab]x:[ab]+", .literal = "x:" },
    // A literal whose places may share a byte: in `bxxxa` the second place gives the match.
    .{ .pattern = "[abx]{2}xx[ab]", .literal = "xx" },
    // It ends with a separator, of a class and of one byte.
    .{ .pattern = "[abx]+[ :]+xa[ab ]*b", .literal = "xa" },
    .{ .pattern = "[abx]+ +xa[ab]+", .literal = " xa" },
};

/// Patterns that the claim leaves to the others: no rule holds for the part before the
/// literal, no one literal stands in every match, or the literal starts or ends every match.
const refused = [_][]const u8{
    "[abx]+x[ab]+", "(?:[ab]x)+a",   "[ab]+x|[ab]+:", "[ab]+(?:x|:)[ab]+", "x[ab]+", "[ab]+x", "[ab]+[ab]+",
    "[abx]*x+[ab]", "[ab ]+ +x[ab]", "\\bx[ab]+",
};

/// Patterns with a literal in their middle that another claim finds the matches of: a literal
/// that ends every match, the text's end, the text's start, a literal that starts every match,
/// and a set of literals.
const others = [_][]const u8{ "[ab]+x[ab]*:", "[ab]+x[ab]+$", "^[ab]+x[ab]+", "ab[ab]*x[ab]+", "(?:ab|ba)[ab]*x[ab]+" };

fn fill(generator: *codec.testing.split.Generator, haystack: []u8) void {
    for (haystack) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
}

/// Requires the fixture's searcher to give what the matcher gives on the fixed texts and on
/// seeded ones, and `Matches` to give the spans that a searcher with the claim off gives.
fn expect_agree_on_texts(fixture: *Fixture, plain: *Fixture, generator: *codec.testing.split.Generator) !void {
    var haystack: [haystack_len]u8 = undefined;
    for (0..haystacks_per_case) |_| {
        fill(generator, &haystack);
        try fixture.expect_agree_everywhere(&haystack);
        try expect_matches(fixture, plain, &haystack);
    }
    for (fixed_texts) |text| {
        try fixture.expect_agree_everywhere(text);
        try expect_matches(fixture, plain, text);
    }
}

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

test "a searcher that goes to the places of a literal in a match's middle gives what the matcher gives" {
    var fixture: Fixture = .{};
    var plain: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x1AAE0);
    for (inner_cases) |case| {
        try fixture.init(case.pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        try plain.init_claims(case.pattern, .{ .inner = false }, sizes.most);
        try testing.expect(plain.searcher.inner == null);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(case.pattern, cache_words);
            try testing.expectEqualStrings(case.literal, fixture.searcher.inner.?.slice());
            try expect_agree_on_texts(&fixture, &plain, &generator);
        }
    }
}

test "a searcher goes to no literal that a rule does not hold for, or that is not in a match's middle" {
    var fixture: Fixture = .{};
    var plain: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x1AAE1);
    for (refused) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        try plain.init_claims(pattern, .{ .inner = false }, searcher_test.cache_words_max);
        try testing.expect(fixture.searcher.inner == null);
        try expect_agree_on_texts(&fixture, &plain, &generator);
    }
    for (others) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        try plain.init_claims(pattern, .{ .inner = false }, searcher_test.cache_words_max);
        try testing.expect(fixture.searcher.inner == null);
        try expect_agree_on_texts(&fixture, &plain, &generator);
    }
    // The literal `x` stands after ten literals of the reverse program, which take every try.
    try fixture.init("[ab]+(?:a:|b:|y:|aa|bb|ab|ba|ya|yb|yy)?x[ab]+", searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.inner == null);
    try fixture.init("[ab]+(?:a:|b:)?x[ab]+", searcher_test.cache_words_max);
    try testing.expectEqualStrings("x", fixture.searcher.inner.?.slice());
    // With claim R4 off, the literal that ends every match is still not claim R14's.
    try fixture.init_claims("[ab]+x", .{ .suffix = false }, searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.suffix == null and fixture.searcher.inner == null);
    // With claim R1 off, the searcher goes to no place.
    try fixture.init_claims("[ab]+x[ab]+", .{ .start_skip = false }, searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.inner == null);
    // Without a reverse DFA, the forward DFA takes the whole cache and no claim reads back.
    try fixture.init("[ab]+x[ab]+", 0);
    try fixture.init("[ab]+x[ab]+", searcher_test.cache_sizes(&fixture.program).least - 1);
    try testing.expect(fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    try testing.expect(fixture.searcher.inner == null);
}

/// The slot of the state that a forward scan with no anchor starts in, for a program with no
/// assertion: a search from a literal's places leaves it unknown.
const plain_start = @intFromEnum(Context.other);

/// The octets of a text long enough to tell a scan of a few octets from a scan of the text.
const long_text_len = 4096;

/// The most octets a scan from a literal's place reads of the long text.
const few_bytes = 16;

test "a search from a literal's places scans from each place alone, and no text before it" {
    var fixture: Fixture = .{};
    const text = [_]u8{' '} ** long_text_len ++ "ab@cd ";
    try fixture.init("\\w+@\\w+", searcher_test.cache_words_max);
    try testing.expectEqualStrings("@", fixture.searcher.inner.?.slice());
    const expected: Span = .{ .start = long_text_len, .end = long_text_len + "ab@cd".len };
    try testing.expectEqual(@as(?Span, expected), fixture.searcher.find(text, 0));
    try testing.expect(fixture.searcher.is_match(text));
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = text };
    try testing.expectEqual(@as(u64, 1), matches.count());
    // No scan started where a forward search starts, and each DFA read a few bytes.
    try testing.expectEqual(@as(u32, constants.dfa_unknown), fixture.searcher.forward.cache.starts[plain_start]);
    try testing.expect(fixture.searcher.forward.cache.scanned <= few_bytes);
    try testing.expect(fixture.searcher.reverse.cache.scanned <= few_bytes);
    // The claim off scans the text forward.
    try fixture.init_claims("\\w+@\\w+", .{ .inner = false }, searcher_test.cache_words_max);
    try testing.expectEqual(@as(?Span, expected), fixture.searcher.find(text, 0));
    try testing.expect(fixture.searcher.forward.cache.starts[plain_start] != constants.dfa_unknown);
}

test "a search whose forward scan read past the next place leaves the places to the plain search" {
    var fixture: Fixture = .{};
    // From the first place, the forward scan reads `[^:]*` to the text's end and finds no `:`.
    const pattern = "[ab]+x(?:[^:]*:|y)";
    try fixture.init(pattern, searcher_test.cache_words_max);
    try testing.expectEqualStrings("x", fixture.searcher.inner.?.slice());
    const expected: Span = .{ .start = 6, .end = 9 };
    try testing.expectEqual(@as(?Span, expected), fixture.searcher.find("ax ax bxy bx", 0));
    try testing.expect(fixture.searcher.forward.cache.starts[plain_start] != constants.dfa_unknown);
    try testing.expectEqual(@as(u32, 0), fixture.searcher.give_ups);
    // A text whose first place gives the match leaves the plain search alone.
    try fixture.init(pattern, searcher_test.cache_words_max);
    try testing.expectEqual(@as(?Span, .{ .start = 1, .end = 4 }), fixture.searcher.find(" axy ax bx", 0));
    try testing.expectEqual(@as(u32, constants.dfa_unknown), fixture.searcher.forward.cache.starts[plain_start]);
    // So does a text whose first place gives none, where the forward scan stopped before the
    // next place.
    try fixture.init("[ab]+x[ab]+", searcher_test.cache_words_max);
    try testing.expectEqual(@as(?Span, .{ .start = 3, .end = 6 }), fixture.searcher.find("ax bxa", 0));
    try testing.expectEqual(@as(u32, constants.dfa_unknown), fixture.searcher.forward.cache.starts[plain_start]);
}

/// The octets of a text whose states outgrow the least cache of the pattern below.
const give_up_text_len = 600;

test "a search from a literal's places whose DFA gives up takes the matcher's answer" {
    // Read backward from the literal, the part before it holds `aa` nine places behind any
    // place: 2^9 states and more.
    // The pattern holds `aa` after a part of one count of bytes, and `xx` after a part that
    // cannot hold an `x`: two literals as long, and the search goes to `xx`.
    const pattern = "[ab]{8}aa[ab]*xx[ab]+";
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).least);
    try testing.expectEqualStrings("xx", fixture.searcher.inner.?.slice());
    var generator = codec.testing.split.Generator.init(0x1AAE2);
    var text: [give_up_text_len]u8 = undefined;
    for (&text) |*octet| octet.* = "ab"[generator.below("ab".len)];
    @memcpy(text[text.len - "xxa".len ..], "xxa");
    try fixture.expect_agree(&text, 0);
    try testing.expect(fixture.searcher.give_ups > 0);
}

/// The parts a generated pattern draws for what stands around its literal, and its literals.
const generated_parts = [_][]const u8{ "[ab]", "[abx]", "x", "a", " ", "[ :]", "[^ ]", "\\b", "(?:a|xb)", "[x ]", ":", "y", "[^:]" };
const generated_counts = [_][]const u8{ "", "", "+", "*", "?", "{2}", "{1,2}" };
const generated_literals = [_][]const u8{ "x", "x:", "ab", "xa", " x", "y", "::" };

/// The patterns the test below generates, the parts on each side of a literal at most, and the
/// texts of a pattern.
const generated_patterns = 800;
const generated_parts_max = 3;
const generated_texts = 3;

/// The bytes of the longest generated pattern: each part with its count, on both sides of the
/// literal.
const generated_sides = 2;
const generated_pattern_len_max = generated_sides * generated_parts_max * ("(?:a|xb)".len + "{1,2}".len) + "x:".len;

fn generate_side(generator: *codec.testing.split.Generator, buffer: []u8, len: *usize) void {
    for (0..1 + generator.below(generated_parts_max)) |_| {
        for ([_][]const u8{ generated_parts[generator.below(generated_parts.len)], generated_counts[generator.below(generated_counts.len)] }) |piece| {
            @memcpy(buffer[len.*..][0..piece.len], piece);
            len.* += piece.len;
        }
    }
}

fn generate(generator: *codec.testing.split.Generator, buffer: *[generated_pattern_len_max]u8) []const u8 {
    var len: usize = 0;
    generate_side(generator, buffer, &len);
    const literal = generated_literals[generator.below(generated_literals.len)];
    @memcpy(buffer[len..][0..literal.len], literal);
    len += literal.len;
    generate_side(generator, buffer, &len);
    return buffer[0..len];
}

test "a searcher gives what the matcher gives for generated patterns with a literal in their middle" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x1AAE3);
    var buffer: [generated_pattern_len_max]u8 = undefined;
    var haystack: [haystack_len]u8 = undefined;
    var taken: u32 = 0;
    for (0..generated_patterns) |_| {
        const pattern = generate(&generator, &buffer);
        try fixture.init(pattern, searcher_test.cache_words_max);
        taken += @intFromBool(fixture.searcher.inner != null);
        for (0..generated_texts) |_| {
            fill(&generator, &haystack);
            try fixture.expect_agree_everywhere(&haystack);
        }
        for (fixed_texts) |text| try fixture.expect_agree_everywhere(text);
    }
    // The generator draws patterns that the claim takes and patterns that it leaves.
    try testing.expect(taken > generated_patterns / 16 and taken < generated_patterns - generated_patterns / 16);
}
