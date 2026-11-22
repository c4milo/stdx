//! Tests of claim R2 (decision 86): a searcher that goes to the next place of the literal every
//! match starts with, or that reads no DFA where the pattern is that literal, gives what the
//! matcher gives.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;

/// The octets of a test's haystack: some steps of `skip_lanes` octets, and a part of one.
const haystack_steps = 6;
const haystack_tail = 7;
const haystack_len = haystack_steps * constants.skip_lanes + haystack_tail;

/// The octets a haystack draws from. Each pattern below starts and ends its literal with these,
/// so that the first and the last octet of a literal often stand at their distance where the
/// whole literal does not, and the search must compare and go on.
const alphabet = "PhaPoh \xC3\xA9";

/// Patterns that are their literal, and patterns that start with one and go on.
const patterns = [_][]const u8{
    "Pharaoh", "Ph",             "PaP",         "\xC3\xA9h", "h",       "(Ph)",  "Ph[ao]+h",
    "Pha*",    "PhaPoh(?:Ph|a)", "h \xC3\xA9+", "Ph.h",      "aP[^ ]*", "Ph|Pa",
};

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
const looks_alphabet = "Phah \n_";

/// Patterns with an assertion before, inside or after their literal (claim R3).
const looks_patterns = [_][]const u8{
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
    try fixture.init_with("Pharaoh", .{ .literal = false }, words);
    try testing.expect(fixture.searcher.exact == null);
    try testing.expect(fixture.searcher.forward.literal == null);
    try fixture.expect_agree("xx Pharaoh xx", 0);
    try fixture.init_with("Ph[ao]+h", .{ .start_skip = false }, words);
    try testing.expect(fixture.searcher.forward.literal == null);
    try fixture.expect_agree("xx Phoh xx", 0);
    // An assertion before the literal: claim R3 goes to the literal after it.
    try fixture.init("\\bPh", words);
    try testing.expectEqualStrings("Ph", fixture.searcher.forward.literal.?.slice());
    try testing.expect(fixture.searcher.forward.looks_for_literal());
    try fixture.expect_agree("xPh Ph", 0);
    try fixture.init_with("\\bPh", .{ .literal = false }, words);
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
