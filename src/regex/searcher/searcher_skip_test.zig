//! Tests of claim R1 (decision 86): a searcher whose forward DFA skips to the next octet that can
//! start a match gives what the matcher gives, and what a searcher that skips nothing gives.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_file = @import("searcher.zig");
const Searcher = searcher_file.Searcher;
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;

/// The octets of a test's haystack: some steps of `skip_lanes` octets, and a part of one.
const haystack_steps = 8;
const haystack_tail = 5;
const haystack_len = haystack_steps * constants.skip_lanes + haystack_tail;

/// The steps the longest gap of a haystack takes, and the octets of its longest word.
const gap_steps_max = 3;
const word_len_max = 6;

/// The octets a haystack draws from where it holds no gap: the letters the patterns start with
/// and go on with, a space, a digit and a character of two octets.
const alphabet = "abcqyzPhAB 01\xC3\xA9";

/// Fills a haystack with gaps of `x`, which no pattern here starts with, and a few octets of
/// `alphabet` between them, so that a skip ends in each part of a step.
fn fill(generator: *codec.testing.split.Generator, haystack: []u8) void {
    var index: usize = 0;
    while (index < haystack.len) {
        const gap = @min(haystack.len - index, generator.below(gap_steps_max * constants.skip_lanes));
        @memset(haystack[index..][0..gap], 'x');
        index += gap;
        const word = @min(haystack.len - index, generator.below(word_len_max));
        for (haystack[index..][0..word]) |*octet| octet.* = alphabet[generator.below(alphabet.len)];
        index += word;
    }
}

/// Compiles `pattern` and gives the searcher room for thousands of states, with claim R4 off so
/// that the forward DFA reads the text and skips.
fn init_roomy(fixture: *Fixture, pattern: []const u8) !void {
    try fixture.init(pattern, 0);
    try fixture.init_with(pattern, searcher_test.no_suffix, searcher_test.cache_sizes(&fixture.program).most);
}

const patterns = [_][]const u8{
    "Ph",      "ab|cq|yz",   "(?i)ph",    "[0-9]+", "q[a-c]*y", "\xC3\xA9+", "[AB][a-c]+ [AB]",
    "q",       "a|\xC3\xA9", "[^x]",      "[^x]+z", "b*",       "\\bq",      "q$",
    "(a|b)+c", "y*z",        "[a-cq]{2}", "x",      "xx+y",     "h.",        ".y",
};

test "a searcher that skips gives what the matcher gives, from every offset, under every cache size" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x51C1);
    var haystack: [haystack_len]u8 = undefined;
    for (patterns) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            for (0..4) |_| {
                fill(&generator, &haystack);
                try fixture.expect_agree_everywhere(&haystack);
            }
        }
    }
}

test "a searcher skips only where one state waits for a match to start" {
    var fixture: Fixture = .{};
    const haystack = "x" ** haystack_len;
    // One octet starts a match, and the state that waits is known after a search. A pattern that
    // starts with a literal of two octets goes to claim R2 instead.
    try init_roomy(&fixture, "P[hi]");
    try fixture.expect_agree(haystack, 0);
    try testing.expect(fixture.searcher.forward.skip_known);
    try testing.expect(fixture.searcher.forward.idle != constants.dfa_unknown);
    for (0..constants.octet_values) |octet| try testing.expectEqual(octet == 'P', fixture.searcher.forward.skip.starts[octet]);
    // A pattern that matches the empty string: a match starts at every octet but one that
    // continues a character of UTF-8.
    try init_roomy(&fixture, "b*");
    try fixture.expect_agree(haystack, 0);
    for (0..constants.octet_values) |octet| {
        const continues = octet >= constants.continuation_min and octet <= constants.continuation_max;
        try testing.expectEqual(!continues, fixture.searcher.forward.skip.starts[octet]);
    }
    // A pattern with an assertion: the state that waits differs by the octet behind it.
    try init_roomy(&fixture, "\\bq");
    try fixture.expect_agree(haystack, 0);
    try testing.expect(!fixture.searcher.forward.skip_known);
    // The reverse DFA starts at a match's end and waits for nothing.
    try testing.expect(!fixture.searcher.reverse.skip_known);
}

test "a searcher with the claim off learns no start octet and gives the same matches" {
    var fixture: Fixture = .{};
    var generator = codec.testing.split.Generator.init(0x0FF);
    var haystack: [haystack_len]u8 = undefined;
    for (patterns) |pattern| {
        try init_roomy(&fixture, pattern);
        const cache_words = searcher_test.cache_sizes(&fixture.program).most;
        var plain_memory: [searcher_test.memory_len]u64 = undefined;
        var plain: Searcher = undefined;
        const len = Searcher.memory_len(fixture.program.forward_len, fixture.program.slot_count(), cache_words);
        plain.init_with(&fixture.program, .{ .start_skip = false }, plain_memory[0..len]);
        fill(&generator, &haystack);
        for (0..haystack.len + 1) |from| {
            try testing.expectEqual(plain.find(&haystack, from), fixture.searcher.find(&haystack, from));
        }
        try testing.expectEqual(plain.is_match(&haystack), fixture.searcher.is_match(&haystack));
        try testing.expect(!plain.forward.skip_known);
        try testing.expectEqual(@as(u32, constants.dfa_unknown), plain.forward.idle);
    }
}

/// The runs of letters in the haystack of the test below, the letters of a run, and the octets
/// of the gap before each run. A run builds fewer states than the least cache holds, so the
/// cache fills at most once in a run, and a gap holds more than `dfa_octets_per_state_min`
/// octets for each state of that cache, so a cache that fills in the next run does not thrash.
const clear_runs = 12;
const clear_run_len = 40;
const clear_gap_len = 640;

/// The clears the test's scan must pass at least.
const clears_min = 3;

/// Where the letter stands that decides whether a run matches the pattern of that test, counted
/// from the run's end: the `a` before the six letters and the `c`.
const clear_decides_from_end = 8;

test "a skip follows the state that waits through a cache that clears" {
    // The DFA of this pattern remembers the last seven letters, so the runs of letters build
    // more states than the least cache holds, and the cache clears in most runs. Only the last
    // run holds a match, so one scan passes every gap.
    const pattern = "z(a|b)*a(a|b){6}c";
    const letter_that_decides = clear_run_len - clear_decides_from_end;
    var fixture: Fixture = .{};
    try fixture.init(pattern, 0);
    try fixture.init_with(pattern, searcher_test.no_suffix, searcher_test.cache_sizes(&fixture.program).least);
    var generator = codec.testing.split.Generator.init(0xC1EA);
    var haystack: [clear_runs * (clear_gap_len + clear_run_len)]u8 = undefined;
    for (0..clear_runs) |run| {
        const part = haystack[run * (clear_gap_len + clear_run_len) ..][0 .. clear_gap_len + clear_run_len];
        @memset(part[0..clear_gap_len], 'x');
        const letters = part[clear_gap_len..];
        for (letters) |*octet| octet.* = if (generator.next() & 1 == 0) 'a' else 'b';
        letters[0] = 'z';
        letters[letters.len - 1] = 'c';
        letters[letter_that_decides] = if (run == clear_runs - 1) 'a' else 'b';
    }
    const forward = &fixture.searcher.forward;
    // What the haystack's sizes rest on.
    try testing.expect(forward.cache.states_max > clear_run_len);
    try testing.expect(clear_gap_len >= constants.dfa_octets_per_state_min * forward.cache.states_max);
    const expected = fixture.reference.find(&haystack, 0);
    try testing.expect(expected != null and expected.?.start > haystack.len - clear_run_len - 1);
    try testing.expectEqual(expected, fixture.searcher.find(&haystack, 0));
    try testing.expectEqual(@as(u32, 0), fixture.searcher.give_ups);
    try testing.expect(forward.cache.clears >= clears_min);
    // The scan skipped each gap, the ones after a clear among them: it found the state that
    // waits again under its new row.
    try testing.expect(forward.skip_visits < constants.skip_trial_visits);
    try testing.expect(forward.skip_octets >= clear_runs * (clear_gap_len - 1));
    try fixture.expect_agree_everywhere(haystack[haystack.len - clear_gap_len - clear_run_len ..]);
}

test "a skip that passes few octets a visit rests and is tried again, and one that passes many stays on" {
    var fixture: Fixture = .{};
    // Letters with a space after each few: every letter can start a match of the pattern, so a
    // visit to the state that waits passes one octet or none.
    var dense: [32 * constants.skip_trial_visits]u8 = undefined;
    for (&dense, 0..) |*octet, index| octet.* = if (index % 4 == 3) ' ' else "abc"[index % 3];
    try init_roomy(&fixture, "[a-c]+z");
    try fixture.expect_agree(&dense, 0);
    try testing.expect(fixture.searcher.forward.skip_off);
    try testing.expectEqual(@as(u32, constants.dfa_unknown), fixture.searcher.forward.idle);
    // The searcher still answers as the matcher does, with its skip off.
    dense[dense.len - 1] = 'z';
    try fixture.expect_agree(&dense, 0);
    try fixture.expect_agree(&dense, dense.len - 3);
    dense[dense.len - 1] = ' ';
    // After `skip_rest_octets` more octets the skip is tried again, and a text of far gaps keeps
    // it on.
    try testing.expect(fixture.searcher.forward.skip_off);
    const gaps = "x" ** (8 * constants.skip_octets_per_visit_min);
    for (0..constants.skip_rest_octets / gaps.len + 1) |_| try testing.expect(fixture.searcher.find(gaps, 0) == null);
    try testing.expect(!fixture.searcher.forward.skip_off);
    try testing.expect(fixture.searcher.forward.idle != constants.dfa_unknown);
    // The dense text turns it off again, and each trial that fails after another doubles the
    // rest, up to a limit.
    try fixture.expect_agree(&dense, 0);
    try testing.expect(fixture.searcher.forward.skip_off);
    const forward = &fixture.searcher.forward;
    var poor_trials: u6 = 1;
    for (0..constants.skip_rest_doublings_max + 2) |_| {
        try testing.expect(forward.skip_off);
        try testing.expectEqual(poor_trials, forward.skip_poor_trials);
        const retry_at = forward.skip_retry_at;
        // No trial comes before the rest is over.
        while (forward.cache.scanned + dense.len < retry_at) {
            try testing.expect(fixture.searcher.find(&dense, 0) == null);
            try testing.expectEqual(retry_at, forward.skip_retry_at);
        }
        // The next scans try the skip once more, and it fails again: the new rest is the last
        // one doubled, up to the limit.
        for (0..2) |_| try testing.expect(fixture.searcher.find(&dense, 0) == null);
        try testing.expect(forward.skip_retry_at >= retry_at + (@as(u64, constants.skip_rest_octets) << poor_trials));
        poor_trials = @min(poor_trials + 1, constants.skip_rest_doublings_max);
    }
    // A `q` after each long gap: a visit passes the gap.
    var sparse: [4 * constants.skip_octets_per_visit_min * constants.skip_trial_visits]u8 = undefined;
    for (&sparse, 0..) |*octet, index| octet.* = if (index % (2 * constants.skip_octets_per_visit_min) == 0) 'q' else 'x';
    try init_roomy(&fixture, "q[yz]");
    try fixture.expect_agree(&sparse, 0);
    try testing.expect(!fixture.searcher.forward.skip_off);
    try testing.expect(fixture.searcher.forward.idle != constants.dfa_unknown);
    // The judgment came at least once, and counted anew after it.
    try testing.expect(fixture.searcher.forward.skip_visits < constants.skip_trial_visits);
}
