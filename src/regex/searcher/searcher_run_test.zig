//! Tests of the DFA's loops of matches (dfa_run.zig): a searcher whose matches are long, read
//! forward and back, gives what the matcher gives, with the claims and without those whose loops
//! take matches, in a cache that holds its states and in one that clears.
const std = @import("std");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const Claims = @import("searcher.zig").Claims;

/// Patterns whose matches run long: through every octet of a line, into a word, read back from a
/// literal at the end, and over letters of two octets, whose matches end before every second one.
const patterns = [_][]const u8{ ".*.*=.*", ".*=", "[a-z]+", "\\w+=\\w*", "(?s).*x", "[a-z]*a[a-z]*", "[а-я]{3,5}", "[α-ω]+" };

/// Texts with long runs, lines that end them, and runs that reach the text's ends.
const texts = [_][]const u8{
    "x=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "abc=def\nghij=klmn=op\n\n=qq",
    "aaaa xyz=aaaa\nqq x aaaaaaaa=",
    "=\n=aaaaaaaaaaaaaaaaaaaaaaaaaaa x",
    "αβγδε ζη θικλμνξ ο",
    "Шерлок Холмс и доктор Ватсон",
};

/// The claims a test runs under: all of them, none of R7's pairs, and no skip, which leaves the
/// plain scan to each pattern.
const claims = [_]Claims{ .{}, .{ .pairs = false }, .{ .start_skip = false } };

test "a searcher whose matches run long gives what the matcher gives, forward and back" {
    var fixture: Fixture = .{};
    for (patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for (claims) |claim| {
            for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
                try fixture.init_claims(pattern, claim, cache_words);
                for (texts) |text| try fixture.expect_agree_everywhere(text);
            }
        }
    }
}
