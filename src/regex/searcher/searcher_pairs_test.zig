//! Tests of claim R7 (decision 86): a searcher whose forward scans take two octets a read gives
//! what the matcher gives, where its pair rows fill, where its cache clears while pairs are
//! built, and where more states than `pair_states_max` reach no pair row.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const dfa_pairs = @import("../dfa/dfa_pairs.zig");

/// The octets of a test's haystack: a part of a validation's text, of a word and of a line.
const haystack_len = 97;

/// The octets a haystack draws from: digits, letters of both cases, the separators of the
/// patterns below, a line feed and a space.
const alphabet = "0a9fZ-:T.@_ing\n x";

/// Patterns with at most `pair_classes_max` classes whose forward scans take no skip: each holds
/// an assertion, or starts with a class that is in most octets.
const patterns = [_][]const u8{
    "^[0-9a-f]{4}-[0-9a-f]{2}$", "^[a-z0-9._-]+@[a-z0-9.-]+\\.[a-z]{2,}$", "^[0-9]{2}:[0-9]{2}T$",
    "[a-z]+ing",                 "\\b[a-z]+\\b",                           "(?m)^[a-z]+$",
    "[0-9]+",                    "[a-z]*a[a-z]",                           "x[0-9]+:",
};

/// The texts a test draws for each pattern and cache, and the seed it draws them from.
const texts_per_case = 6;
const seed = 0x9A1E;

/// The most multiples of the least cache the search for a small cache with pair rows tries.
const multiples_max = 64;

fn fill(generator: *codec.testing.split.Generator, haystack: []u8) void {
    for (haystack) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
}

/// The least multiple of the least cache under which the forward DFA has pair rows: a cache
/// that clears often while it builds them.
fn small_pairs_cache(fixture: *Fixture, pattern: []const u8) !usize {
    try fixture.init(pattern, 0);
    const least = searcher_test.cache_sizes(&fixture.program).least;
    for (1..multiples_max + 1) |multiple| {
        try fixture.init(pattern, least * multiple);
        if (fixture.searcher.forward.cache.pair_states > 0) return least * multiple;
    }
    return error.TestNoPairRows;
}

fn expect_agree_random(fixture: *Fixture, generator: *codec.testing.split.Generator) !void {
    var haystack: [haystack_len]u8 = undefined;
    for (0..texts_per_case) |_| {
        fill(generator, &haystack);
        try fixture.expect_agree_everywhere(&haystack);
    }
}

test "a searcher that takes two octets a read gives what the matcher gives, in caches that clear" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(seed);
    for (patterns) |pattern| {
        try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
        try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
        try testing.expect(fixture.searcher.forward.cache.pair_states > 0);
        try expect_agree_random(&fixture, &generator);
        const small = try small_pairs_cache(&fixture, pattern);
        try fixture.init(pattern, small);
        try expect_agree_random(&fixture, &generator);
        // The claim off gives the same answers, with no pair row.
        try fixture.init_claims(pattern, .{ .pairs = false }, searcher_test.cache_sizes(&fixture.program).most);
        try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.cache.pair_states);
        try expect_agree_random(&fixture, &generator);
    }
}

test "states past the ones with pair rows take the table, and the answers stay the matcher's" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(seed + 1);
    // The eighth octet from the end is an `a`: 2^8 states, more than `pair_states_max`.
    const pattern = "(?:a|b)*a[ab]{7}\\b";
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
    const pair_states = fixture.searcher.forward.cache.pair_states;
    try testing.expect(pair_states > 0 and pair_states <= constants.pair_states_max);
    var haystack: [haystack_len]u8 = undefined;
    for (0..texts_per_case) |_| {
        for (&haystack) |*octet| octet.* = "ab "[generator.below(3)];
        try fixture.expect_agree_everywhere(&haystack);
    }
    try testing.expect(fixture.searcher.forward.cache.state_count > pair_states);
}

test "a program with more classes than pair_classes_max gets no pair row" {
    var fixture: Fixture = .{};
    // Each letter of the literal is a class of its own.
    const pattern = "[0-9]+abcdefghijklmnopqrstuvwxyzABCDEFGH";
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
    try testing.expect(fixture.program.class_count > constants.pair_classes_max);
    try testing.expectEqual(@as(u32, 0), fixture.searcher.forward.cache.pair_states);
    try fixture.expect_agree_everywhere("12abcdefghijklmnopqrstuvwxyzABCDEFGH 3abc");
}

test "a pair whose first step clears the cache keeps no entry under the row it started from" {
    var fixture: Fixture = .{};
    const pattern = "[0-9]+x";
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
    try fixture.init(pattern, searcher_test.cache_sizes(&fixture.program).most);
    const dfa = &fixture.searcher.forward;
    try testing.expect(dfa.cache.pair_states > 0);
    var state = dfa.start(.edge).?;
    try testing.expectEqual(@as(u32, 0), state);
    // The cache counts itself full, so the state the first step builds clears it and takes row
    // 0, the row the pair started from.
    dfa.cache.state_count = dfa.cache.states_max;
    var last: ?usize = null;
    const text = "12";
    const column = @as(u32, dfa.first_columns[text[0]]) + dfa.classes[text[1]];
    _ = dfa_pairs.steps(dfa, text, 0, false, &state, &last);
    try testing.expectEqual(@as(u32, 1), dfa.cache.clears);
    try testing.expectEqual(@as(u32, constants.dfa_unknown), dfa.cache.pairs[column]);
    // The search still gives the matcher's answers.
    try fixture.expect_agree_everywhere("12x 3x 45");
}
