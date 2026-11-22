//! Tests of claim R4 (decision 86): a searcher that reads back from the places of the literal
//! every match ends with gives what the matcher gives.
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
const refused = [_][]const u8{ "(?:a..|)x", "[ax]+x", "(?:xa)+", "x+", "(?:x:|a)+x:", "[^b]+x", "(?:a.\\B|)x" };

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
            try fixture.init(case.pattern, cache_words);
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
    try fixture.init_with("[ab]+x", .{ .suffix = false }, words);
    try testing.expect(fixture.searcher.suffix == null);
    try fixture.expect_agree("ab abx", 0);
    try fixture.init_with("[ab]+x", .{ .start_skip = false }, words);
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
