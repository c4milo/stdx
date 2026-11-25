//! Tests of a DFA's second start under a cache that fills (dfa_second.zig, decision 86): a
//! searcher that judges claim R14 after its searches filled the forward DFA's cache gives what
//! the matcher gives.
//!
//! `tools/matcher_model_check.sh` found the case on 2026-11-25 (design §8 part 22h). The
//! second start was a new state for a full cache, which cleared. The DFA kept the row of the
//! state that waits (dfa_wait.zig), a row of the cache before the clear, and the next scan's
//! start halted at its assertion.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;

/// A pattern whose forward DFA holds a state for each set of its last bytes, so that a text of
/// mixed letters fills a small cache, and whose every match holds ` aa` in its middle.
const pattern = "([ab]*a[ab]{5}) +(aa)[ab]?";

/// The pieces of a text: the pattern's letters, its literal, and bytes that start no match.
const pieces = [_][]const u8{ "ab", "a", "b", "ba", " aa", " ", "c", "AB", "abab", "bbaa" };

/// The bytes of a text. A searcher waits for `claim_text_per_instruction` bytes for each
/// instruction of its reverse program before it judges claim R14: more than one text of this
/// length, and fewer than two.
const text_len = 700;

/// The seeded texts, each for a new searcher.
const rounds = 64;

/// The words of cache a searcher takes: the least power of two, from `cache_shift_min`, at
/// which both its DFAs start.
const cache_shift_min = 4;
const cache_shift_max = std.math.log2_int(usize, searcher_test.cache_words_max);

/// Readies the fixture's searcher with the least cache at which both its DFAs start, and with
/// its claims not judged yet.
fn init_small(fixture: *Fixture) !void {
    fixture.judged = false;
    fixture.fresh_account = false;
    for (cache_shift_min..cache_shift_max + 1) |shift| {
        try fixture.init(pattern, @as(usize, 1) << @intCast(shift));
        if (fixture.searcher.forward_ready and fixture.searcher.reverse_ready) return;
    }
    return error.TestNoCache;
}

fn fill(generator: *codec.testing.split.Generator, text: *[text_len]u8) void {
    var len: usize = 0;
    // Each turn adds one piece of one byte or more, so the turns are at most the bytes.
    for (0..text_len) |_| {
        const piece = pieces[generator.below(pieces.len)];
        if (piece.len > text_len - len) break;
        @memcpy(text[len..][0..piece.len], piece);
        len += piece.len;
    }
    @memset(text[len..], 'c');
}

test "a searcher that judges claim R14 after its cache filled gives what the matcher gives" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x5EC0);
    var text: [text_len]u8 = undefined;
    var judged_after_clear: usize = 0;
    for (0..rounds) |_| {
        try init_small(&fixture);
        fill(&generator, &text);
        const expected = fixture.reference.find(&text, 0);
        // The first search judges no claim that waits, and fills the cache.
        try testing.expect(fixture.searcher.deferred.inner);
        try testing.expectEqual(expected, fixture.searcher.find(&text, 0));
        const clears = fixture.searcher.forward.cache.clears;
        // The second search judges the claim, and its forward scan takes the second start.
        try testing.expectEqual(expected != null, fixture.searcher.is_match(&text));
        try testing.expect(!fixture.searcher.deferred.any());
        // The searches after it start at the DFA's first start again.
        try testing.expectEqual(expected, fixture.searcher.find(&text, 0));
        try testing.expectEqual(expected != null, fixture.searcher.is_match(&text));
        try testing.expectEqual(fixture.reference.find(&text, text_len / 2), fixture.searcher.find(&text, text_len / 2));
        judged_after_clear += @intFromBool(clears > 0 and fixture.searcher.inner != null);
    }
    // Some searchers took the claim after their cache cleared: the case this test holds.
    try testing.expect(judged_after_clear > 0);
}
