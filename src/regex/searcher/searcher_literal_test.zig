//! Tests of claim R2 (decision 86): a searcher that goes to the next place of the literal every
//! match starts with, or that reads no DFA where the pattern is that literal, gives what the
//! matcher gives.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const Matches = @import("searcher.zig").Matches;
const Span = @import("../matcher.zig").Span;

/// The octets of a test's haystack: some steps of `skip_lanes` octets, and a part of one.
const haystack_steps = 6;
const haystack_tail = 7;
pub const haystack_len = haystack_steps * constants.skip_lanes + haystack_tail;

/// The octets a haystack draws from. Each pattern below starts and ends its literal with these,
/// so that the first and the last octet of a literal often stand at their distance where the
/// whole literal does not, and the search must compare and go on.
pub const alphabet = "PhaPoh \xC3\xA9";

/// Patterns that are their literal, and patterns that start with one and go on.
pub const patterns = [_][]const u8{
    "Pharaoh", "Ph",             "PaP",         "\xC3\xA9h", "h",       "(Ph)",  "Ph[ao]+h",
    "Pha*",    "PhaPoh(?:Ph|a)", "h \xC3\xA9+", "Ph.h",      "aP[^ ]*", "Ph|Pa",
};

/// The forward scans of one `expect_agree` of a text that holds a match: `find`, and `captures`.
const scans_of_expect_agree = 2;

fn fill(generator: *codec.testing.split.Generator, haystack: []u8) void {
    for (haystack) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
}

test "a searcher that goes to a literal's places gives what the matcher gives, from every offset" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x2E7A);
    var haystack: [haystack_len]u8 = undefined;
    for (patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            for (0..8) |_| {
                fill(&generator, &haystack);
                try fixture.expect_agree_everywhere(&haystack);
            }
        }
    }
}

/// The octets a haystack of the assertions' test draws from: word octets, a space and a line
/// feed, so that each assertion holds at some places of the literal and fails at others.
pub const looks_alphabet = "Phah \n_";

/// Patterns with an assertion before, inside or after their literal (claim R3).
pub const looks_patterns = [_][]const u8{
    "\\bPh", "Ph\\b",      "\\bPh\\b", "\\BPh",      "(?m)^Ph",  "Ph$",       "(?m)Ph$",
    "^Ph",   "\\bPh[ah]+", "a\\bh",    "\\b(?:Ph)+", "\\bha\\B", "(?m)^h a$", "\\bPha*\\b",
};

test "a searcher that goes to the literal after an assertion gives what the matcher gives" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x100C);
    var haystack: [haystack_len]u8 = undefined;
    for (looks_patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            try testing.expect(fixture.searcher.forward.looks_for_literal());
            for (0..8) |_| {
                for (&haystack) |*octet| octet.* = looks_alphabet[generator.below(looks_alphabet.len)];
                try fixture.expect_agree_everywhere(&haystack);
            }
        }
    }
}

/// The octets of a test of literals that fold: both cases of each letter, and octets that end
/// a word or a line.
pub const folds_alphabet = "pPhHaA x\n";

/// Patterns with a literal that takes a letter in either case, as a whole pattern, before more of
/// it, after an assertion, and as the suffix that every match ends with.
pub const folds_patterns = [_][]const u8{
    "(?i)ph", "(?i)pha+", "(?i:p)h", "(?i)p[ah]+", "\\b(?i)ph\\b", "(?i)ph$", "[ah]+(?i)x", "(?i)hx", "[aX]+(?i)x",
};

test "a searcher that goes to a literal that folds gives what the matcher gives" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0xF01E);
    var haystack: [haystack_len]u8 = undefined;
    for (folds_patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            for (0..8) |_| {
                for (&haystack) |*octet| octet.* = folds_alphabet[generator.below(folds_alphabet.len)];
                try fixture.expect_agree_everywhere(&haystack);
            }
        }
    }
    // The first place of the suffix folds, and the part before it takes the upper case.
    try fixture.init("[aX]+(?i)x", searcher_test.cache_sizes(&fixture.program).most);
    try testing.expect(fixture.searcher.suffix == null);
    try fixture.init("[ah]+(?i)x", searcher_test.cache_sizes(&fixture.program).most);
    try testing.expectEqualStrings("x", fixture.searcher.suffix.?.slice());
    try fixture.expect_agree_everywhere("aXahX ax");
}

test "a searcher reads no DFA for a pattern that is its literal, and skips to the literal of one that goes on" {
    var fixture: Fixture = .{};
    const sizes_of = searcher_test.cache_sizes;
    try fixture.init("Pharaoh", 0);
    try fixture.init("Pharaoh", sizes_of(&fixture.program).most);
    try testing.expectEqualStrings("Pharaoh", fixture.searcher.exact.?.slice());
    try fixture.expect_agree("xx Pharaoh xx", 0);
    // The DFAs built no state: the literal's places answered.
    try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.cache.state_count);
    try testing.expectEqual(@as(u32, 0), fixture.searcher.reverse.cache.state_count);
    try fixture.init("Ph[ao]+h", sizes_of(&fixture.program).most);
    try testing.expect(fixture.searcher.exact == null);
    try testing.expectEqualStrings("Ph", fixture.searcher.forward.literal.?.slice());
    // With no assertion, R1's state that waits takes the skip, not claim R3's scan.
    try testing.expect(!fixture.searcher.forward.looks_for_literal());
    // The skip passed the octets before each place of `Ph`: a visit passed more than one octet.
    const haystack = "xxxxxxxxxxxxxxxxxxxxPhoh" ++ "x" ** (2 * constants.skip_lanes) ++ "Phah";
    try fixture.expect_agree(haystack, 0);
    try fixture.expect_agree_everywhere(haystack);
    try testing.expect(fixture.searcher.forward.skip_octets >= 2 * constants.skip_lanes);
    // The skip goes from one place of `Ph` to the next, and stops at no `P` between them: one
    // visit for each of the two scans of `expect_agree`. R1's skip would stop at each `P`.
    const visits = fixture.searcher.forward.skip_visits;
    try fixture.expect_agree("Px" ** (2 * constants.skip_lanes) ++ "Phoh", 0);
    try testing.expectEqual(visits + scans_of_expect_agree, fixture.searcher.forward.skip_visits);
    // Without a cache the matcher answers alone, and no literal stands in for it: `is_match`
    // readies the matcher to keep no slot, and the matcher reads the text.
    // The searcher before held the literal: a DFA that `init` refused must not hand it on.
    try fixture.init("Pharaoh", sizes_of(&fixture.program).most);
    try fixture.init("Pharaoh", 0);
    try fixture.expect_agree("xx Pharaoh xx", 0);
    try testing.expect(!fixture.searcher.forward_ready);
    try testing.expect(fixture.searcher.exact == null);
    try testing.expect(fixture.searcher.is_match("xx Pharaoh xx"));
    try testing.expectEqual(.none, fixture.searcher.matcher.options.captures);
    try testing.expect(fixture.searcher.matcher.position > 0);
}

test "a searcher with claim R2 off, or with R1 off, searches for no literal" {
    var fixture: Fixture = .{};
    try fixture.init("Pharaoh", 0);
    const words = searcher_test.cache_sizes(&fixture.program).most;
    try fixture.init_claims("Pharaoh", .{ .literal = false }, words);
    try testing.expect(fixture.searcher.exact == null);
    try testing.expect(fixture.searcher.forward.literal == null);
    try fixture.expect_agree("xx Pharaoh xx", 0);
    try fixture.init_claims("Ph[ao]+h", .{ .start_skip = false }, words);
    try testing.expect(fixture.searcher.forward.literal == null);
    try fixture.expect_agree("xx Phoh xx", 0);
    // An assertion before the literal: claim R3 goes to the literal after it.
    try fixture.init("\\bPh", words);
    try testing.expectEqualStrings("Ph", fixture.searcher.forward.literal.?.slice());
    try testing.expect(fixture.searcher.forward.looks_for_literal());
    try fixture.expect_agree("xPh Ph", 0);
    try fixture.init_claims("\\bPh", .{ .literal = false }, words);
    try testing.expect(!fixture.searcher.forward.looks_for_literal());
}

test "a searcher goes on to the literal's next place where the assertion before it fails" {
    var fixture: Fixture = .{};
    try fixture.init("\\bPh", 0);
    try fixture.init("\\bPh", searcher_test.cache_sizes(&fixture.program).most);
    // The first place of `Ph` stands after a word octet, so `\b` fails there. The scan waits
    // again, and passes the octets up to the next place.
    const haystack = "xPh" ++ "x" ** (2 * constants.skip_lanes) ++ " Ph";
    try fixture.expect_agree_everywhere(haystack);
    const skipped = fixture.searcher.forward.skip_octets;
    try fixture.expect_agree(haystack, 0);
    try testing.expect(fixture.searcher.forward.skip_octets - skipped >= 2 * constants.skip_lanes);
}

/// The octets of a test of literal sets: the literals' octets, and octets none starts with.
pub const sets_alphabet = "abcdxhefg AIJs";

/// Patterns whose branches each start with a literal (claim R5).
pub const sets_patterns = [_][]const u8{
    "Ab|Is|Ja", "Abraham|Isaac|Jacob|Joseph", "(?:ab|cd)+x", "(ab|cd|efg)h", "ab|abc", "ba|ab|ca", "(?:ab|cd)(?:ef|gh)",
};

test "a searcher that goes to the places of a literal set gives what the matcher gives" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x5E76);
    var haystack: [haystack_len]u8 = undefined;
    for (sets_patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            try testing.expect(fixture.searcher.forward.literals != null);
            for (0..8) |_| {
                for (&haystack) |*octet| octet.* = sets_alphabet[generator.below(sets_alphabet.len)];
                try fixture.expect_agree_everywhere(&haystack);
            }
        }
    }
}

test "a searcher goes from one place of a literal set to the next, and stops at no octet between" {
    // A class follows the set, so the DFA reads each match.
    const pattern = "(?:Ab|Is)[xy]";
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    const words = searcher_test.cache_sizes(&fixture.program).most;
    try fixture.init(pattern, words);
    try testing.expect(!fixture.searcher.exact_set);
    // R1's skip would stop at each `A` and `I`; the set's search makes one visit a scan.
    const haystack = "AxIx" ** constants.skip_lanes ++ "Isx";
    try fixture.expect_agree(haystack, 0);
    const visits = fixture.searcher.forward.skip_visits;
    try fixture.expect_agree(haystack, 0);
    try testing.expectEqual(visits + scans_of_expect_agree, fixture.searcher.forward.skip_visits);
    try fixture.init_claims(pattern, .{ .literal_set = false }, words);
    try testing.expect(fixture.searcher.forward.literals == null);
    try fixture.expect_agree(haystack, 0);
    try fixture.init_claims(pattern, .{ .start_skip = false }, words);
    try testing.expect(fixture.searcher.forward.literals == null);
}

test "a set of literals and nothing else gives its matches with no DFA, its first branch first" {
    var fixture: Fixture = .{};
    const cases = [_]struct { pattern: []const u8, haystack: []const u8 }{
        .{ .pattern = "ab|abc", .haystack = "xabcx abc ab" },
        .{ .pattern = "abc|ab", .haystack = "xabcx abc ab" },
        .{ .pattern = "Abraham|Isaac|Jacob|Joseph", .haystack = "Isaac and Jacob, Josep, Joseph, Abrah Abraham" },
        .{ .pattern = "(?:ab|cd)", .haystack = "acdab" ++ "x" ** constants.skip_lanes ++ "abcd" },
        // At 0 the prefix `aa` stands and no literal does; the match `aab` starts one octet on.
        .{ .pattern = "aab|ab", .haystack = "aaab xaab" },
    };
    for (cases) |case| {
        try fixture.init(case.pattern, 0);
        try fixture.init(case.pattern, searcher_test.cache_sizes(&fixture.program).most);
        try testing.expect(fixture.searcher.exact_set);
        for (0..case.haystack.len + 1) |from| try fixture.expect_agree(case.haystack, from);
        // The searcher read every match from the set: its DFAs took no visit.
        try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.skip_visits);
    }
    // With claim R5 off, the DFAs read the same matches.
    try fixture.init_claims("ab|abc", .{ .literal_set = false }, searcher_test.cache_sizes(&fixture.program).most);
    try testing.expect(!fixture.searcher.exact_set);
    try fixture.expect_agree("xabcx abc ab", 0);
}

test "is_match scans no DFA for a text where no literal stands, and finds the match where one does" {
    var fixture: Fixture = .{};
    // A literal, and a set of literals, each followed by more of the pattern.
    for ([_][]const u8{ "Ph[ao]+h", "(?:Ph|Pa)[ao]+h" }) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        const dfa = &fixture.searcher.forward;
        try testing.expect(dfa.literal != null or dfa.literals != null);
        try testing.expect(!fixture.searcher.is_match("aoh aoh hhh Poh"));
        try testing.expectEqual(@as(u32, 0), dfa.cache.state_count);
        try testing.expect(fixture.searcher.is_match("aoh Phaoh"));
        try testing.expect(dfa.cache.state_count > 0);
        // The scan starts at the literal's place: claim R1's skip passes no octet before it.
        try testing.expectEqual(@as(u64, 0), dfa.skip_octets);
        try testing.expect(!fixture.searcher.is_match("aoh Ph h"));
    }
}

test "the matches of a pattern that is its literal are its places, and the walk ends past the text" {
    var fixture: Fixture = .{};
    try fixture.init("Pha", searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.exact != null);
    const haystack = "aPhaPhaxPha";
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = haystack };
    const literal_len = 3;
    for ([_]usize{ 1, 4, 8 }) |start| {
        try testing.expectEqual(@as(?Span, .{ .start = start, .end = start + literal_len }), matches.next());
    }
    try testing.expectEqual(@as(?Span, null), matches.next());
    try testing.expect(matches.position > haystack.len);
}
