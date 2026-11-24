//! Tests of claim R4 (decision 86): a searcher that reads back from the places of the literal
//! every match ends with gives what the matcher gives.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const Span = @import("../matcher.zig").Span;
const dfa_suffix = @import("../dfa/dfa_suffix.zig");

/// The octets of a test's haystack: some steps of `skip_lanes` octets, and a part of one.
const haystack_steps = 6;
const haystack_tail = 7;
const haystack_len = haystack_steps * constants.skip_lanes + haystack_tail;

/// The octets a haystack draws from: the suffixes below, and octets the parts before them take.
pub const alphabet = "abx: \n\xC3\xA9";

/// Patterns that end with a literal whose first octet no part before it takes, and their
/// literals.
pub const suffix_cases = [_]struct { pattern: []const u8, suffix: []const u8 }{
    .{ .pattern = "[ab]+x", .suffix = "x" },
    .{ .pattern = "[ab][ab ]*x:", .suffix = "x:" },
    .{ .pattern = "(?m)^[ab]+:", .suffix = ":" },
    .{ .pattern = "[a ][^x:\n]{3}x", .suffix = "x" },
    .{ .pattern = "\\b[ab]+x", .suffix = "x" },
    .{ .pattern = "[ab]+x\\b", .suffix = "x" },
    .{ .pattern = "[ab]+x$", .suffix = "x" },
    .{ .pattern = "(?:a|bb)x", .suffix = "x" },
    .{ .pattern = "(?:a|)x", .suffix = "x" },
    .{ .pattern = "(b)*(a)x(:)", .suffix = "ax:" },
    .{ .pattern = "[ab]*?\xC3\xA9", .suffix = "\xC3\xA9" },
    .{ .pattern = "(?:ab|b )+x", .suffix = "x" },
    // A suffix that overlaps itself: a place that starts no match may hold the start of one.
    .{ .pattern = "(?:b|\\B)aa", .suffix = "aa" },
};

/// Patterns that end with a literal whose first octet a part before it takes: claim R4 would
/// give a later start, or a shorter match, than the matcher.
const refused = [_][]const u8{
    "(?:a..|)x", "[ax]+x",       "(?:xa)+", "x+", "(?:x:|a)+x:", "[^b]+x", "(?:a.\\B|)x",
    // A class of three octets is one `ranges` node, read back too: one that takes the suffix's
    // first octet, and one past which the walk reaches it.
    "[ :x]+x",   "(?:x[ :b]|)x",
};

/// Texts on which a search that took a suffix it must refuse, or passed a place it must read,
/// gives another answer than the matcher.
const fixed_texts = [_][]const u8{ "aaa xaaa", "ab axx: x", "a x ax:", "axbx" };

fn fill(generator: *codec.testing.split.Generator, haystack: []u8) void {
    for (haystack) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
}

test "a searcher that reads back from the literal every match ends with gives what the matcher gives" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x5FF1);
    var haystack: [haystack_len]u8 = undefined;
    for (suffix_cases) |case| {
        try fixture.init(case.pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            // Claim R12 takes `[ab]+x$` from the text's end, so it is off here.
            try fixture.init_claims(case.pattern, .{ .text_end = false }, cache_words);
            try testing.expectEqualStrings(case.suffix, fixture.searcher.suffix.?.slice());
            for (0..8) |_| {
                fill(&generator, &haystack);
                try fixture.expect_agree_everywhere(&haystack);
            }
            for (fixed_texts) |text| try fixture.expect_agree_everywhere(text);
        }
    }
}

test "a searcher takes no suffix whose first octet the part before it takes, and still agrees" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x5FF2);
    var haystack: [haystack_len]u8 = undefined;
    for (refused) |pattern| {
        try fixture.init(pattern, 0);
        try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
        try testing.expect(fixture.searcher.suffix == null);
        for (0..8) |_| {
            fill(&generator, &haystack);
            try fixture.expect_agree_everywhere(&haystack);
        }
        for (fixed_texts) |text| try fixture.expect_agree_everywhere(text);
    }
}

/// Patterns that end with a literal whose first byte the part before it takes, and that the
/// second rule or the third takes: that part takes one count of bytes, or it ends with a
/// separator.
const wide_cases = [_]struct { pattern: []const u8, suffix: []const u8 }{
    // One count of bytes, up to `suffix_before_len_max`.
    .{ .pattern = "[ab][abx]x:", .suffix = "x:" },
    .{ .pattern = "\\bx[ab]xa", .suffix = "xa" },
    .{ .pattern = "[abx]{8}xx", .suffix = "xx" },
    .{ .pattern = "[abx](?:a|x)xa", .suffix = "xa" },
    // A separator: a space, a line feed or a colon, which the rest of the pattern takes nowhere.
    .{ .pattern = "[abx]+[ :]+xb", .suffix = "xb" },
    .{ .pattern = "[abx]+[ \n]+ab", .suffix = "ab" },
    // A separator of one byte, which the literal starts with.
    .{ .pattern = "[abx]+ +x", .suffix = " x" },
    .{ .pattern = "[abx]+\n+ab", .suffix = "\nab" },
    .{ .pattern = "[abx]+ {2,}x:", .suffix = " x:" },
    // A run of two bytes: the separator's last byte, and the one byte it must hold.
    .{ .pattern = "[abx]+ + x", .suffix = "  x" },
    .{ .pattern = "[^ \\n]+[ \\n]+xa", .suffix = "xa" },
    .{ .pattern = "[abx]+ +(?i)x", .suffix = " x" },
    .{ .pattern = "[abx]+[ :]+xa", .suffix = "xa" },
    .{ .pattern = "[abx]+ +x\\b", .suffix = " x" },
    .{ .pattern = "(?:[ab]+x)+ +x", .suffix = " x" },
};

/// Patterns that no rule takes, each with a text on which a search from the literal's places
/// gives another match than the matcher, or a text that the patterns before it share.
const wide_refused = [_]struct { pattern: []const u8, text: []const u8 }{
    // The part before the separator takes the separator's byte.
    .{ .pattern = "[abx ]+ +x", .text = "a x  x" },
    // The literal holds the separator's byte.
    .{ .pattern = "[ab]+[x ]+xx", .text = "a xxx" },
    // The part before the literal may be empty, so it holds no separator.
    .{ .pattern = "(?:[abx]+ +)?xa", .text = "xa xa" },
    .{ .pattern = "[abx]+ *xa", .text = "axa xa" },
    // A range of the pattern holds a byte of the separator and a byte that is not.
    .{ .pattern = "[abx]+[ a]xb", .text = "xa axb xb" },
    // The separator's byte comes again before the part that takes the literal's bytes.
    .{ .pattern = "[ab]+ +[abx]* +x", .text = "a  x  x" },
    // One count of bytes past `suffix_before_len_max`.
    .{ .pattern = "[abx]{9}xx", .text = "abxabxabxxxabxabxabxxx" },
    // Two counts of bytes.
    .{ .pattern = "[abx]{1,2}xx", .text = "axxx" },
    // The separator holds the other case of the literal's first byte.
    .{ .pattern = "[ab]+[X ]+(?i)xa", .text = "a X xa a Xxa" },
    // The literal is one byte twice, which the part before it takes in a run.
    .{ .pattern = "[ab]+x+x", .text = "axxx" },
    // A range that holds a byte of the separator and a byte that is not, and a byte of the
    // separator before it.
    .{ .pattern = "[abx]*:[a ][ :]+xb", .text = "b:a x: :xb" },
    // One branch of the part before the literal holds the literal: the match from 0 ends at the
    // second place, and a search from the first place gives the match from 1. The Lean model of
    // the search gives this text (spec/lean/Stdx/Regex/Required.lean, `needs_no_earlier`).
    .{ .pattern = "(?:[a-z]|[0-9][a-z]ab)ab", .text = "1xabab" },
    // A literal of one byte, which the second rule and the third leave to the forward DFA.
    .{ .pattern = "[abx]x", .text = "axx" },
    .{ .pattern = "[abx]+[ :]+x", .text = "a x:x" },
};

comptime {
    std.debug.assert(constants.suffix_before_len_max == 8);
}

test "a searcher takes a suffix by the second rule and by the third, and gives what the matcher gives" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x5FF5);
    var haystack: [haystack_len]u8 = undefined;
    for (wide_cases) |case| {
        try fixture.init(case.pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(case.pattern, cache_words);
            try testing.expectEqualStrings(case.suffix, fixture.searcher.suffix.?.slice());
            // The first rule refuses each: the part before the literal takes its first byte.
            try testing.expect(dfa_suffix.suffix_of(&fixture.searcher.reverse, &fixture.program, .first) == null);
            for (0..8) |_| {
                fill(&generator, &haystack);
                try fixture.expect_agree_everywhere(&haystack);
            }
            for (fixed_texts) |text| try fixture.expect_agree_everywhere(text);
            for (wide_refused) |refusal| try fixture.expect_agree_everywhere(refusal.text);
        }
    }
}

test "a searcher gives the match from the text's start where a later place ends it" {
    var fixture: Fixture = .{};
    try fixture.init("(?:[a-z]|[0-9][a-z]ab)ab", searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.suffix == null and fixture.searcher.inner == null);
    try testing.expectEqual(@as(?Span, .{ .start = 0, .end = 6 }), fixture.searcher.find("1xabab", 0));
    // The same part before a literal in a match's middle.
    try fixture.init("(?:[a-z]|[0-9][a-z]ab)ab[xy]", searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.suffix == null and fixture.searcher.inner == null);
    try testing.expectEqual(@as(?Span, .{ .start = 0, .end = 7 }), fixture.searcher.find("1xababx", 0));
    try fixture.expect_agree_everywhere("1xababx 1xabab xabx");
}

test "a searcher takes no suffix that no rule takes, and still agrees" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x5FF6);
    var haystack: [haystack_len]u8 = undefined;
    for (wide_refused) |refusal| {
        try fixture.init(refusal.pattern, 0);
        try fixture.init(refusal.pattern, searcher_test.cache_sizes(&fixture.program).most);
        try testing.expect(fixture.searcher.suffix == null);
        try fixture.expect_agree_everywhere(refusal.text);
        for (0..8) |_| {
            fill(&generator, &haystack);
            try fixture.expect_agree_everywhere(&haystack);
        }
    }
}

test "a searcher whose forward DFA goes to a set of literals takes a suffix by the first rule alone" {
    var fixture: Fixture = .{};
    // The part before the literal takes one count of bytes, and its branches start with `ax`
    // or `xb`, which claim R5 takes.
    try fixture.init("(?:ax|xb)[ab]xa", searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.forward.literals != null);
    try testing.expect(fixture.searcher.suffix == null);
    try fixture.expect_agree_everywhere("axaxa xbbxa axbx");
    // The first rule holds for this one: no part before the `:` takes it.
    try fixture.init("(?:ax|xb)[ab]:", searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.forward.literals != null);
    try testing.expectEqualStrings(":", fixture.searcher.suffix.?.slice());
    try fixture.expect_agree_everywhere("axa: xbb: axb");
}

test "a class of letters before a word, and words apart before a name, each read back from the literal" {
    var fixture: Fixture = .{};
    try fixture.init("[a-z]shing", searcher_test.cache_words_max);
    try testing.expectEqualStrings("shing", fixture.searcher.suffix.?.slice());
    try fixture.expect_agree_everywhere("fishing shing washing xshing Ashing wishin");
    try fixture.init("\\w+\\s+Holmes", searcher_test.cache_words_max);
    try testing.expectEqualStrings("Holmes", fixture.searcher.suffix.?.slice());
    try fixture.expect_agree_everywhere("Holmes Holmes, Mr. Sherlock  Holmes\tHolmes xHolmes");
    // The forward DFA reads no text: the search goes from the literal's places.
    try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.cache.state_count);
}

/// The parts a generated pattern draws for what stands before its literal, and its literals.
const generated_parts = [_][]const u8{ "[ab]", "[abx]", "x", "a", " ", "[ :]", "[^ ]", "\\b", "(?:a|xb)", "[x ]", ":" };
const generated_counts = [_][]const u8{ "", "", "+", "*", "?", "{2}", "{1,2}" };
const generated_literals = [_][]const u8{ "x", "x:", "ab", "xa", " x" };

/// The patterns the test below generates, the parts of each at most, and its texts.
const generated_patterns = 600;
const generated_parts_max = 4;
const generated_texts = 3;

/// The bytes of the longest generated pattern: each part with its count, and the literal.
const generated_pattern_len_max = generated_parts_max * ("(?:a|xb)".len + "{1,2}".len) + "x:".len;

fn generate(generator: *codec.testing.split.Generator, buffer: *[generated_pattern_len_max]u8) []const u8 {
    var len: usize = 0;
    for (0..1 + generator.below(generated_parts_max)) |_| {
        for ([_][]const u8{ generated_parts[generator.below(generated_parts.len)], generated_counts[generator.below(generated_counts.len)] }) |piece| {
            @memcpy(buffer[len..][0..piece.len], piece);
            len += piece.len;
        }
    }
    const literal = generated_literals[generator.below(generated_literals.len)];
    @memcpy(buffer[len..][0..literal.len], literal);
    return buffer[0 .. len + literal.len];
}

test "a searcher gives what the matcher gives for generated patterns that end with a literal" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x5FF7);
    var buffer: [generated_pattern_len_max]u8 = undefined;
    var haystack: [haystack_len]u8 = undefined;
    var taken: u32 = 0;
    for (0..generated_patterns) |_| {
        const pattern = generate(&generator, &buffer);
        try fixture.init(pattern, searcher_test.cache_words_max);
        taken += @intFromBool(fixture.searcher.suffix != null);
        for (0..generated_texts) |_| {
            fill(&generator, &haystack);
            try fixture.expect_agree_everywhere(&haystack);
        }
        for (wide_refused) |refusal| try fixture.expect_agree_everywhere(refusal.text);
    }
    // The generator draws patterns that each rule takes and patterns that none takes.
    try testing.expect(taken > generated_patterns / 8 and taken < generated_patterns - generated_patterns / 8);
}

test "a searcher takes no suffix where a literal starts every match, or every match starts the text" {
    var fixture: Fixture = .{};
    const cases = [_][]const u8{ "ab[ab]*x", "\\bab[ab]*x", "^[ab]+x", "\\A[ab]+x", "[ab]+[x:]" };
    for (cases) |pattern| {
        try fixture.init(pattern, 0);
        try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
        try testing.expect(fixture.searcher.suffix == null);
        try fixture.expect_agree_everywhere("ab ab:x abx");
    }
    // A text start under `(?m)` is a line's start, which a match may follow anywhere.
    try fixture.init("(?m)^[ab]+x", searcher_test.cache_sizes(&fixture.program).most);
    try testing.expectEqualStrings("x", fixture.searcher.suffix.?.slice());
}

test "a searcher with claim R4 off, or with R1 off, reads back from no suffix" {
    var fixture: Fixture = .{};
    try fixture.init("[ab]+x", 0);
    const words = searcher_test.cache_sizes(&fixture.program).most;
    try fixture.init_claims("[ab]+x", .{ .suffix = false }, words);
    try testing.expect(fixture.searcher.suffix == null);
    try fixture.expect_agree("ab abx", 0);
    try fixture.init_claims("[ab]+x", .{ .start_skip = false }, words);
    try testing.expect(fixture.searcher.suffix == null);
    try fixture.expect_agree("ab abx", 0);
}

test "a pattern whose forward DFA outgrows the least cache reads back from its suffix and never gives up" {
    // The forward DFA of this pattern remembers the last eight letters, and gives up in the least
    // cache (searcher_test.zig). The reverse DFA reads at most nine octets back from each `c`.
    const pattern = "(a|b)*a(a|b){8}c";
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).least);
    try testing.expectEqualStrings("c", fixture.searcher.suffix.?.slice());
    var generator = codec.testing.split.Generator.init(0x5FF3);
    var text: [600]u8 = undefined;
    for (0..2 * constants.dfa_give_ups_max) |_| {
        for (&text) |*octet| octet.* = "abbbbac"[generator.below(7)];
        try fixture.expect_agree(&text, 0);
        try fixture.expect_is_match_agrees(&text);
    }
    // No search, `is_match` among them, read the forward DFA.
    try testing.expectEqual(@as(u32, 0), fixture.searcher.give_ups);
    try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.cache.state_count);
}

test "a reverse DFA that gives up at a place hands the search to the matcher" {
    // Read back from `c`, the DFA remembers the last nine letters: more states than the least
    // cache holds. Every match ends at the one `c`, after a run of letters.
    const pattern = "x[ab]{8}a[ab]*c";
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).least);
    try testing.expectEqualStrings("c", fixture.searcher.suffix.?.slice());
    var generator = codec.testing.split.Generator.init(0x5FF4);
    var text: [give_up_text_len]u8 = undefined;
    for (&text) |*octet| octet.* = if (generator.next() & 1 == 0) 'a' else 'b';
    @memcpy(text[0..match_head.len], match_head);
    text[text.len - 1] = 'c';
    try fixture.expect_agree(&text, 0);
    try testing.expect(fixture.searcher.give_ups > 0);
}

/// A text of letters that the reverse DFA reads back over, past the least cache's states, and
/// the start of the one match it holds.
const give_up_text_len = 600;
const match_head = "xabababab" ++ "a";
