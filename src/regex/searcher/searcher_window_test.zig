//! Tests of the window (decision 86, dfa_window.zig): a searcher whose forward DFA's state that
//! waits goes to the bytes before a literal's next place gives what the matcher gives, and goes
//! there only for a literal that every match holds after a part of a bounded length.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const searcher_test = @import("searcher_test.zig");
const Fixture = searcher_test.Fixture;
const Matches = @import("searcher.zig").Matches;

/// Patterns whose part before the literal may hold the literal's bytes, which claim R14's rules
/// refuse, and takes a bounded count of bytes.
const windows = [_][]const u8{
    "[a-c]{0,3}ab[a-c]*",
    "[a-c]?[a-c]?ab",
    // Ways of one, two and three bytes, which start with classes, so claim R5 holds none.
    "(?:[a-z]|[a-z]c|[a-z]ab)bab[ab]",
    "\\s[a-zA-Z]{0,12}ing\\s",
    "[ab ]{1,4}(?i:a)b[ab]*",
};

test "a searcher takes the window for a literal after a part of a bounded length" {
    // The window's literal and the most bytes of a match before it, for each pattern.
    const expected = [windows.len]struct { literal: []const u8, lead: u32 }{
        .{ .literal = "ab", .lead = 3 },
        .{ .literal = "ab", .lead = 2 },
        .{ .literal = "bab", .lead = 3 },
        .{ .literal = "ing", .lead = 13 },
        .{ .literal = "ab", .lead = 4 },
    };
    var fixture: Fixture = .{ .encoding = .bytes };
    for (windows, expected) |pattern, wanted| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        const window = fixture.searcher.forward.window orelse return error.TestExpectedWindow;
        try testing.expect(std.ascii.eqlIgnoreCase(wanted.literal, window.finder.one.slice()));
        try testing.expectEqual(wanted.lead, window.lead);
        try testing.expect(fixture.searcher.inner == null and fixture.searcher.suffix == null);
    }
    // Of two literals as long, the one with the shorter part before it: `ab` after at most one
    // byte, and not the second `ab`, after at most six.
    try fixture.init("[a-c]?ab[a-c]{0,3}ab[a-c]", searcher_test.cache_words_max);
    try testing.expectEqual(@as(u32, 1), fixture.searcher.forward.window.?.lead);
    // The bound counts bytes: in UTF-8, `é` takes two. RE2's `\s` is ASCII's white space in
    // UTF-8 too.
    var utf8: Fixture = .{};
    try utf8.init("[\xC3\xA9a-c]{0,2}ab[a-c]*", searcher_test.cache_words_max);
    try testing.expectEqual(@as(u32, 4), utf8.searcher.forward.window.?.lead);
    try utf8.init("\\s[a-zA-Z]{0,12}ing\\s", searcher_test.cache_words_max);
    try testing.expectEqual(@as(u32, 13), utf8.searcher.forward.window.?.lead);
}

test "a searcher takes no window where the part before the literal has no bound, or another claim holds" {
    var fixture: Fixture = .{ .encoding = .bytes };
    const others = [_][]const u8{
        // A loop before the literal: no bound.
        "[a-c]*ab[a-c]*",
        // Past `window_lead_max` bytes.
        "[a-c]{0,17}ab[a-c]*",
        // Claim R2's literal, claim R14's, claim R4's and claim R5's literals.
        "ab[a-c]*",
        "[a-c]+@[a-c]+",
        "[0-9]{0,3}ab",
        "(?:ab|cd)[a-c]*",
        "(?:a|bc|cab)bab[ab]",
        // Claim R14's second rule holds, and R14 takes the literal before the window may.
        "[a-c]{2}xy[a-c]+",
        // A literal of one byte.
        "[a-c]{0,3}a[0-9]",
        // A way that holds no literal.
        "[a-c]{0,3}ab|[0-9]",
    };
    for (others) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        try testing.expect(fixture.searcher.forward.window == null);
    }
    // A claim that is off.
    try fixture.init_claims("[a-c]{0,3}ab[a-c]*", .{ .window = false }, searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.forward.window == null);
    // A program with an assertion has no claim R1, which the window takes.
    try fixture.init("\\b[a-c]{0,3}ab[a-c]*", searcher_test.cache_words_max);
    try testing.expect(fixture.searcher.forward.window == null);
}

/// Patterns each of whose matches holds one literal of a set after a part of a bounded length,
/// and no one literal in every match.
const window_sets = [_][]const u8{
    "([A-Za-z]awyer|[A-Za-z]inn)\\s",
    "(?:[a-z]{0,2}xy|[a-z]zw)[a-c]",
    "(?:[a-z]?abc|[a-z]?xab|[a-z]?zz)",
    // The shortest literal first.
    "([A-Za-z]inn|[A-Za-z]awyer)\\s",
    // Two splits that each hold a set, in both orders: the longer literals win.
    "(?:[A-Za-z]wxyz|[A-Za-z]abcd)(?:[a-c]pq|[a-c]rs)",
    "(?:[a-c]pq|[a-c]rs)(?:[A-Za-z]wxyz|[A-Za-z]abcd)",
};

test "a searcher takes a window over a set where each match holds one literal of the set" {
    // The set's literals, cut to the shortest's bytes, and the most bytes before one.
    const expected = [window_sets.len]struct { count: u8, len: u8, lead: u32 }{
        .{ .count = 2, .len = 3, .lead = 1 },
        .{ .count = 2, .len = 2, .lead = 2 },
        .{ .count = 3, .len = 2, .lead = 1 },
        .{ .count = 2, .len = 3, .lead = 1 },
        .{ .count = 2, .len = 4, .lead = 1 },
        .{ .count = 2, .len = 4, .lead = 4 },
    };
    var fixture: Fixture = .{ .encoding = .bytes };
    for (window_sets, expected) |pattern, wanted| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        const window = fixture.searcher.forward.window orelse return error.TestExpectedWindow;
        const set = &window.finder.set;
        try testing.expectEqual(wanted.count, set.literals.count);
        try testing.expectEqual(wanted.len, set.literals.len);
        try testing.expectEqual(wanted.lead, window.lead);
    }
    // A way whose literal folds, a way past the bound, a literal of one byte, a way with no
    // literal, and a match that passes no way: no set.
    const others = [_][]const u8{
        "(?:[a-z]xy|[a-z](?i:zw))[a-c]",
        "(?:[a-z]{0,20}xy|[a-z]zw)[a-c]",
        "(?:[a-z]xy|[a-z]z)[a-c]",
        "(?:[a-z]xy|[a-z]zw|[0-9])[a-c]",
        "(?:[a-z]xy|[a-z]zw)[a-c]|q[a-c]",
    };
    for (others) |pattern| {
        try fixture.init(pattern, searcher_test.cache_words_max);
        try testing.expect(fixture.searcher.forward.window == null);
    }
}

/// The bytes a haystack draws from: each case's literal and its parts, and a space.
const alphabet = "aabbcing ABxyzwrnie";

/// The bytes of a test's haystack: some steps of `skip_lanes` bytes, and a part of one.
const haystack_steps = 6;
const haystack_tail = 7;
const haystack_len = haystack_steps * constants.skip_lanes + haystack_tail;

test "a searcher with a window gives what the matcher gives, from every offset and in a small cache" {
    var fixture: Fixture = .{ .encoding = .bytes };
    var generator = codec.testing.split.Generator.init(0x51D0);
    var haystack: [haystack_len]u8 = undefined;
    for (windows ++ window_sets) |pattern| {
        try fixture.init(pattern, 0);
        const sizes = searcher_test.cache_sizes(&fixture.program);
        for ([_]usize{ sizes.most, sizes.least }) |cache_words| {
            try fixture.init(pattern, cache_words);
            try testing.expect(fixture.searcher.forward.window != null);
            for (0..8) |_| {
                for (&haystack) |*byte| byte.* = alphabet[generator.below(alphabet.len)];
                try fixture.expect_agree_everywhere(&haystack);
            }
        }
    }
}

test "a searcher with a window reads no DFA between two places far apart" {
    var fixture: Fixture = .{ .encoding = .bytes };
    const far = 4 * constants.skip_lanes;
    // Letters that the part before the literal takes, far from each place of `ing`.
    const haystack = " " ++ "x" ** far ++ " bring " ++ "y" ** far ++ " sing ";
    try fixture.init("\\s[a-zA-Z]{0,12}ing\\s", 0);
    try fixture.expect_agree_everywhere(haystack);
    try fixture.init("\\s[a-zA-Z]{0,12}ing\\s", searcher_test.cache_words_max);
    var matches: Matches = .{ .searcher = &fixture.searcher, .haystack = haystack };
    try testing.expectEqual(@as(u64, 2), matches.count());
    // The scans passed most of the letters before each place with no state of the DFA: the
    // second scan, after the first match, learned the second place anew.
    try testing.expect(fixture.searcher.forward.skip_octets >= 2 * (far - constants.window_lead_max));
}
