//! Claim R15 in the searcher: once both DFAs gave up for good on a trie, the automaton answers
//! each call as the matcher does (searcher_automaton.zig).
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const searcher_file = @import("searcher.zig");
const Matches = searcher_file.Matches;
const State = @import("../aho_corasick.zig").State;
const Generator = codec.testing.split.Generator;

/// More literals than claim R5 takes, so that the compiler takes a trie.
const literals_extra = 6;
const literals_count = constants.literal_set_max + literals_extra;
const literal_len_max = 5;
const literal_octets = "abc";
const text_octets = "abcd";
const texts_per_pattern = 8;
const patterns = 8;
const pattern_len_max = literals_count * (literal_len_max + 1);
const text_len = 64;

fn less(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.order(u8, left, right) == .lt;
}

/// Sorted literals of up to `literal_len_max` octets from `abc`, so that the compiler takes a trie.
fn trie_pattern(generator: *Generator, octets: *[literals_count][literal_len_max]u8, pattern: *[pattern_len_max]u8) []const u8 {
    var literals: [literals_count][]const u8 = undefined;
    for (&literals, octets) |*literal, *own| {
        const len = generator.between(1, literal_len_max);
        for (own[0..len]) |*octet| octet.* = literal_octets[generator.below(literal_octets.len)];
        literal.* = own[0..len];
    }
    std.sort.pdq([]const u8, &literals, {}, less);
    var len: usize = 0;
    for (literals, 0..) |literal, index| {
        if (index > 0) {
            pattern[len] = '|';
            len += 1;
        }
        @memcpy(pattern[len..][0..literal.len], literal);
        len += literal.len;
    }
    return pattern[0..len];
}

/// Requires each call of the searcher to give the matcher's answer over texts a seed draws, and a
/// count of the matches to give the matcher's count.
fn expect_texts(fixture: *Fixture, generator: *Generator) !void {
    var text: [text_len]u8 = undefined;
    for (0..texts_per_pattern) |_| {
        for (&text) |*octet| octet.* = text_octets[generator.below(text_octets.len)];
        try fixture.expect_agree_everywhere(&text);
        var count: u64 = 0;
        var from: usize = 0;
        while (fixture.reference.find(&text, from)) |span| : (count += 1) from = @intCast(span.end);
        var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = &text };
        try testing.expectEqual(count, matches.count());
    }
}

test "once both DFAs gave up for good, the automaton gives what the matcher gives" {
    var generator = Generator.init(0x15);
    var octets: [literals_count][literal_len_max]u8 = undefined;
    var pattern: [pattern_len_max]u8 = undefined;
    for (0..patterns) |_| {
        var fixture: Fixture = .{};
        try fixture.init(trie_pattern(&generator, &octets, &pattern), searcher_test.cache_words_max);
        fixture.searcher.give_ups = constants.dfa_give_ups_max;
        try expect_texts(&fixture, &generator);
        try testing.expectEqual(State.ready, fixture.searcher.trie.state);
    }
}

test "with the claim off, or a program that is no trie's, the matcher answers after the DFAs" {
    var generator = Generator.init(0x16);
    var octets: [literals_count][literal_len_max]u8 = undefined;
    var pattern: [pattern_len_max]u8 = undefined;
    var fixture: Fixture = .{};
    try fixture.init_claims(trie_pattern(&generator, &octets, &pattern), .{ .automaton = false }, searcher_test.cache_words_max);
    fixture.searcher.give_ups = constants.dfa_give_ups_max;
    try expect_texts(&fixture, &generator);
    try testing.expectEqual(State.refused, fixture.searcher.trie.state);
    try fixture.init("(a|b)*a(a|b){3}c", searcher_test.cache_words_max);
    fixture.searcher.give_ups = constants.dfa_give_ups_max;
    try expect_texts(&fixture, &generator);
    try testing.expectEqual(State.refused, fixture.searcher.trie.state);
}

test "a trie's automaton waits while the DFAs still answer" {
    var generator = Generator.init(0x17);
    var octets: [literals_count][literal_len_max]u8 = undefined;
    var pattern: [pattern_len_max]u8 = undefined;
    var fixture: Fixture = .{};
    try fixture.init(trie_pattern(&generator, &octets, &pattern), searcher_test.cache_words_max);
    try expect_texts(&fixture, &generator);
    try testing.expectEqual(@as(u32, 0), fixture.searcher.give_ups);
    try testing.expectEqual(State.waiting, fixture.searcher.trie.state);
}

test "the automaton answers a trie whose reverse DFA did not start, and the forward DFA counts before" {
    var generator = Generator.init(0x18);
    var octets: [literals_count][literal_len_max]u8 = undefined;
    var pattern: [pattern_len_max]u8 = undefined;
    var fixture: Fixture = .{};
    const trie = trie_pattern(&generator, &octets, &pattern);
    try fixture.init(trie, 0);
    // Room for the forward DFA alone: the searcher gives it the whole cache.
    const dfa_file = @import("../dfa/dfa.zig");
    const forward_least = dfa_file.Dfa.memory_len_min(&fixture.program, fixture.program.forward);
    try fixture.init(trie, (forward_least + 1) / 2);
    try testing.expect(fixture.searcher.forward_ready and !fixture.searcher.reverse_ready);
    var text: [text_len]u8 = undefined;
    for (&text) |*octet| octet.* = text_octets[generator.below(text_octets.len)];
    // A count takes the forward DFA alone, and builds no automaton.
    var count: u64 = 0;
    var from: usize = 0;
    while (fixture.reference.find(&text, from)) |span| : (count += 1) from = @intCast(span.end);
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = &text };
    try testing.expectEqual(count, matches.count());
    try testing.expectEqual(State.waiting, fixture.searcher.trie.state);
    // A search needs both DFAs: the automaton answers it, and every call after it.
    try expect_texts(&fixture, &generator);
    try testing.expectEqual(State.ready, fixture.searcher.trie.state);
    try testing.expect(!fixture.searcher.forward_ready);
}

test "the automaton waits while a claim waits, as the claim's judgment takes the DFAs' lists" {
    var generator = Generator.init(0x19);
    var octets: [literals_count][literal_len_max]u8 = undefined;
    var pattern: [pattern_len_max]u8 = undefined;
    var fixture: Fixture = .{ .judged = false };
    try fixture.init(trie_pattern(&generator, &octets, &pattern), searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.deferred.any());
    fixture.searcher.give_ups = constants.dfa_give_ups_max;
    // One search of a short text covers too little for the judgment: the matcher answers it,
    // and the automaton is not built.
    try fixture.expect_agree("abcabc", 0);
    try testing.expect(fixture.searcher.deferred.any());
    try testing.expectEqual(State.waiting, fixture.searcher.trie.state);
    // The matcher answers until the searches covered what the claims wait for, and the
    // automaton after their judgment.
    try expect_texts(&fixture, &generator);
    try testing.expect(!fixture.searcher.deferred.any());
    try testing.expectEqual(State.ready, fixture.searcher.trie.state);
    try expect_texts(&fixture, &generator);
}
