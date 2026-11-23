//! Tests of claim R9 (decision 86): a searcher whose forward scans go past the octets a state stays
//! over gives what the matcher gives, a state whose runs are short loses its flag, and at most
//! `stay_records` states hold it.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const Dfa = @import("../dfa/dfa.zig").Dfa;
const Matches = @import("searcher.zig").Matches;
const Span = @import("../matcher.zig").Span;

/// The octets of a test's haystack: runs of one octet each, long enough for steps of
/// `skip_lanes` octets.
const haystack_len = 160;

/// The longest run a test's haystack holds.
const run_len_max = 72;

/// The octets a haystack draws its runs from: the letters and separators of the patterns below.
const alphabet = "AZaceqx=\n 0";

/// Patterns whose forward states stay over runs: of a class, of its complement, of every octet
/// but a line feed, with the match flag and without, and of a set of more ranges than a step of
/// a skip judges. Each ends with a class, where it could end with a literal, so that claim R4
/// leaves the scans to the DFAs.
const patterns = [_][]const u8{
    ".*[^A-Z]|[A-Z]", ".*.*=.*",    "a[^=]*[=0]",    "[a-z]+",      "x[0-9]*[qZ]",
    "(?s).*0",        "[ace]+[xz]", "[^\\n]*[\\n=]", "A[a-z ]*Z|=", "(?:a|c)+x?",
};

/// The texts a test draws for each pattern and cache, and the seed it draws them from.
const texts_per_case = 4;
const seed = 0x57A7;

/// Fills a haystack with runs of one octet each, of a length a seed draws.
fn fill(generator: *codec.testing.split.Generator, haystack: []u8) void {
    var index: usize = 0;
    while (index < haystack.len) {
        const octet = alphabet[generator.below(alphabet.len)];
        const len = @min(haystack.len - index, 1 + generator.below(run_len_max));
        @memset(haystack[index..][0..len], octet);
        index += len;
    }
}

/// The rows of a DFA's states whose entries hold `dfa_skip_flag`. Each such entry leads back to
/// its own state.
fn flagged_rows(dfa: *const Dfa) !usize {
    var count: usize = 0;
    for (0..dfa.cache.state_count) |index| {
        const row: u32 = @intCast(index * dfa.cache.stride);
        var flagged = false;
        for (dfa.cache.table[row..][0..dfa.class_count]) |entry| {
            if (entry == constants.dfa_unknown or entry & constants.dfa_skip_flag == 0) continue;
            try testing.expectEqual(row, entry & constants.dfa_row_mask);
            flagged = true;
        }
        count += @intFromBool(flagged);
    }
    return count;
}

/// The records a DFA holds: the states that took the flag since its cache last cleared.
fn claimed(dfa: *const Dfa) usize {
    var count: usize = 0;
    for (dfa.stays) |stay| count += @intFromBool(stay.row != constants.dfa_unknown);
    return count;
}

fn expect_agree_random(fixture: *Fixture, generator: *codec.testing.split.Generator) !void {
    var haystack: [haystack_len]u8 = undefined;
    for (0..texts_per_case) |_| {
        fill(generator, &haystack);
        try fixture.expect_agree_everywhere(&haystack);
    }
}

test "a searcher that skips the octets a state stays over gives what the matcher gives" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(seed);
    for (patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            try expect_agree_random(&fixture, &generator);
            try testing.expect(try flagged_rows(&fixture.searcher.forward) <= constants.stay_records);
            // A cache that holds every state keeps the record of each state that took the flag,
            // judged or not. One that clears often may have just forgotten every record.
            try testing.expect(claimed(&fixture.searcher.forward) > 0 or cache_words == sizes.least);
        }
        // The claim off gives the same answers, with no flag.
        try fixture.init_claims(pattern, .{ .stays = false }, sizes.most);
        try expect_agree_random(&fixture, &generator);
        try testing.expectEqual(@as(usize, 0), try flagged_rows(&fixture.searcher.forward));
    }
}

/// A word of two letters: the state after its first letter stays over the second alone.
const short_word = "ab ";

/// A word of many letters, over which a state stays.
const long_word = "qqqqqqqqqqqqqqqqqqq ";

/// The text of a test whose searches visit one state many times: `skip_trial_visits` words.
const visits_text_len = short_word.len * constants.skip_trial_visits;

test "a state whose runs are long keeps its flag" {
    var fixture: Fixture = .{};
    // Each search reads to the text's end in the state that stays over capitals.
    try fixture.init(".*[^A-Z]|[A-Z]", searcher_test.cache_words_max);
    var haystack: [constants.skip_trial_visits + run_len_max]u8 = @splat('A');
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = &haystack };
    var count: usize = 0;
    while (matches.next()) |_| count += 1;
    try testing.expectEqual(haystack.len, count);
    try testing.expectEqual(@as(usize, 1), try flagged_rows(&fixture.searcher.forward));
}

test "a state whose runs are short loses its flag" {
    var fixture: Fixture = .{};
    // The state after a letter stays over the next letter alone: a run of one octet a word.
    try fixture.init("[a-z]+[0-9]", searcher_test.cache_words_max);
    var haystack: [visits_text_len]u8 = undefined;
    for (&haystack, 0..) |*octet, index| octet.* = short_word[index % short_word.len];
    try testing.expectEqual(@as(?Span, null), fixture.searcher.find(&haystack, 0));
    try testing.expectEqual(@as(usize, 0), try flagged_rows(&fixture.searcher.forward));
    var poor: usize = 0;
    for (fixture.searcher.forward.stays) |stay| poor += @intFromBool(stay.poor);
    try testing.expect(poor > 0);
    // The answers stay the matcher's.
    try fixture.expect_is_match_agrees(&haystack);
}

test "at most stay_records states hold the flag, and the others read their runs" {
    var fixture: Fixture = .{};
    // Each copy of `[a-z]+` stays in a state of its own over a word's letters.
    const pattern = "(?:[a-z]+ ){12}[0-9]";
    try fixture.init(pattern, searcher_test.cache_words_max);
    var haystack: [haystack_len + haystack_len]u8 = undefined;
    for (&haystack, 0..) |*octet, index| octet.* = long_word[index % long_word.len];
    try fixture.expect_is_match_agrees(&haystack);
    try testing.expectEqual(@as(usize, constants.stay_records), try flagged_rows(&fixture.searcher.forward));
    try fixture.expect_agree(&haystack, 0);
}

test "a match ends before each octet that a state with the match flag stays over" {
    var fixture: Fixture = .{};
    try fixture.init("[a-z]+", searcher_test.cache_words_max);
    var haystack: [haystack_len]u8 = @splat('q');
    haystack[0] = '0';
    haystack[haystack.len - 1] = '0';
    try testing.expectEqual(@as(?Span, .{ .start = 1, .end = haystack.len - 1 }), fixture.searcher.find(&haystack, 0));
    try testing.expectEqual(@as(usize, 1), try flagged_rows(&fixture.searcher.forward));
    try fixture.expect_agree_everywhere(&haystack);
}

test "claim R9 is off in a DFA where claim R3 takes the flag" {
    var fixture: Fixture = .{};
    try fixture.init("\\bfoo[a-z]*\\b", searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.forward.looks_for_literal());
    try testing.expect(!fixture.searcher.forward.config.stays);
    try fixture.expect_agree_everywhere("a foozzzzzzzzzzzzzzzzzzzzzzzz foo b");
}

/// The record of the state that took the flag first, which a test's pattern makes the one whose
/// runs it reads.
fn first_record(dfa: *const Dfa) !@import("../dfa/dfa_stay.zig").Stay {
    for (dfa.stays) |stay| {
        if (stay.row != constants.dfa_unknown) return stay;
    }
    return error.TestNoRecord;
}

test "a state judged poor gets its pair row back" {
    var fixture: Fixture = .{};
    // With no skip, the scan reads pairs, and a pair from the state after a letter takes its
    // flag: claim R7 took it one octet at a time until the state was judged.
    try fixture.init_claims("[a-z]+[0-9]", .{ .start_skip = false }, searcher_test.cache_words_max);
    var haystack: [visits_text_len + run_len_max]u8 = undefined;
    for (&haystack, 0..) |*octet, index| octet.* = short_word[index % short_word.len];
    try testing.expectEqual(@as(?Span, null), fixture.searcher.find(&haystack, 0));
    const dfa = &fixture.searcher.forward;
    const stay = try first_record(dfa);
    try testing.expect(stay.poor);
    try testing.expect(stay.row < dfa.cache.pair_states * dfa.cache.stride);
    const column = @as(u32, dfa.first_columns['b']) + dfa.classes[' '];
    try testing.expect(dfa.cache.pairs[(stay.row << dfa.pair_shift) + column] < constants.dfa_flags_min);
}

test "a cache that clears forgets every record" {
    var fixture: Fixture = .{};
    // The copies of `[a-z]+` take every record. The state after `!` is one the words do not reach.
    const pattern = "(?:[a-z]+ ){12}[0-9]|![a-z]*";
    try fixture.init_claims(pattern, .{ .start_skip = false }, searcher_test.cache_words_max);
    var words: [haystack_len + haystack_len]u8 = undefined;
    for (&words, 0..) |*octet, index| octet.* = long_word[index % long_word.len];
    try testing.expect(!fixture.searcher.is_match(&words));
    try testing.expectEqual(@as(usize, constants.stay_records), claimed(&fixture.searcher.forward));
    // The state after `!` is built in a full cache, which clears. Then that state stays over the
    // run of letters, and takes the one record.
    fixture.searcher.forward.cache.state_count = fixture.searcher.forward.cache.states_max;
    var run: [run_len_max]u8 = @splat('q');
    run[0] = '!';
    try testing.expectEqual(@as(?Span, .{ .start = 0, .end = run.len }), fixture.searcher.find(&run, 0));
    try testing.expect(fixture.searcher.forward.cache.clears > 0);
    try testing.expectEqual(@as(usize, 1), claimed(&fixture.searcher.forward));
}

test "a state that comes to stay over another class learns that its octets no longer leave it" {
    var fixture: Fixture = .{};
    try fixture.init("[xw][0-9a-z]*[!?]", searcher_test.cache_words_max);
    // The state after `x` stays over the letters first, so the digits are still octets that
    // leave it, and then over the digits.
    var haystack: [run_len_max + run_len_max + 1]u8 = undefined;
    haystack[0] = 'x';
    @memset(haystack[1..][0..run_len_max], 'a');
    @memset(haystack[1 + run_len_max ..], '0');
    try testing.expectEqual(@as(?Span, null), fixture.searcher.find(&haystack, 0));
    const exits = (try first_record(&fixture.searcher.forward)).exits;
    try testing.expect(exits.whole);
    for (exits.ranges) |range| try testing.expect('0' -% range.lo > range.span);
    try fixture.expect_agree_everywhere(&haystack);
}
