//! The matcher's tests: what each form of the syntax matches, the order of preference between
//! alternatives, and the same answer however the text is cut into pieces (invariant 5).
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const compiler = @import("compile.zig");
const errors = @import("errors.zig");
const matcher_file = @import("matcher.zig");
const Program = @import("program.zig").Program;
const Instruction = @import("program.zig").Instruction;
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;

/// The instructions and the capture groups a test's pattern may take.
pub const storage_len = 2048;
pub const groups_len = 8;
pub const memory_len = Matcher.memory_len(storage_len, groups_len * constants.group_slots);

/// A program and a matcher for it, in the test's own memory.
pub const Fixture = struct {
    storage: [storage_len]Instruction = undefined,
    memory: [memory_len]u64 = undefined,
    program: Program = undefined,
    matcher: Matcher = undefined,

    pub fn init(fixture: *Fixture, pattern: []const u8, options: matcher_file.Options) errors.Error!void {
        fixture.program = try compiler.compile(pattern, .{}, &fixture.storage);
        std.debug.assert(fixture.program.group_count <= groups_len);
        fixture.matcher.init(&fixture.program, options, &fixture.memory);
    }
};

/// A group's span, or null where the group took no part.
pub const Group = ?[constants.group_slots]u64;

/// One pattern over one text: the groups of its first match, the whole match first, or no group
/// where the text holds no match.
pub const Case = struct {
    pattern: []const u8,
    text: []const u8,
    groups: []const Group,
};

fn expect_groups(matcher: *const Matcher, expected: []const Group) !void {
    for (expected, 0..) |group, index| {
        const found = matcher.group(@intCast(index));
        const span = group orelse {
            try testing.expectEqual(@as(?Span, null), found);
            continue;
        };
        try testing.expectEqual(@as(?Span, .{ .start = span[0], .end = span[1] }), found);
    }
}

/// The case's text given whole.
pub fn expect_whole(fixture: *Fixture, case: Case) !void {
    fixture.matcher.start(null, 0);
    const end = fixture.matcher.search(case.text, .last);
    if (case.groups.len == 0) return testing.expectEqual(matcher_file.Status.no_match, end.status);
    try testing.expectEqual(matcher_file.Status.match, end.status);
    try expect_groups(&fixture.matcher, case.groups);
}

/// How a search ended, kept outside the matcher, which the split driver moves.
pub const Ended = struct {
    status: matcher_file.Status = .needs_input,
    groups: [groups_len]?Span = @splat(null),
};

/// A matcher as the split driver of `codec` drives it (decision 15): the driver cuts the text
/// into the pieces a seed draws, and moves the state from one slot to the other between calls,
/// so a matcher that kept a pointer into itself reads garbage (invariant 12).
const Driven = struct {
    matcher: Matcher,
    /// The address past the text's last octet, which tells the call whose piece ends the text.
    text_end: usize,
    ended: *Ended,

    fn step(driven: *Driven, input: []const u8, output: []u8) !codec.Progress {
        std.debug.assert(output.len == 0);
        const piece: matcher_file.Piece = if (@intFromPtr(input.ptr) + input.len == driven.text_end) .last else .more;
        const taken = driven.matcher.search(input, piece);
        if (taken.status == .needs_input) return .{ .consumed = taken.consumed, .written = 0, .status = .needs_input };
        driven.ended.status = taken.status;
        if (taken.status == .match) {
            for (&driven.ended.groups, 0..) |*group, index| group.* = driven.matcher.group(@intCast(index));
        }
        return .{ .consumed = taken.consumed, .written = 0, .status = .done };
    }
};

/// A search of `text` in the pieces a seed draws, with the matcher moved between calls.
pub fn search_split(fixture: *Fixture, options: matcher_file.Options, text: []const u8, seed: u64) !Ended {
    var ended: Ended = .{};
    var states: [codec.testing.split.state_slots]Driven = undefined;
    states[0].matcher.init(&fixture.program, options, &fixture.memory);
    for (&states) |*state| {
        state.text_end = @intFromPtr(text.ptr) + text.len;
        state.ended = &ended;
    }
    const outcome = try codec.testing.split.drive(Driven, &states, Driven.step, text, &.{}, seed);
    try testing.expectEqual(codec.Status.done, outcome.status);
    try testing.expect(outcome.consumed <= text.len);
    return ended;
}

/// The case's text given in the pieces a seed draws.
fn expect_split(fixture: *Fixture, case: Case, seed: u64) !void {
    const ended = try search_split(fixture, .{ .captures = .groups }, case.text, seed);
    if (case.groups.len == 0) return testing.expectEqual(matcher_file.Status.no_match, ended.status);
    try testing.expectEqual(matcher_file.Status.match, ended.status);
    for (case.groups, 0..) |group, index| {
        const expected: ?Span = if (group) |span| .{ .start = span[0], .end = span[1] } else null;
        try testing.expectEqual(expected, ended.groups[index]);
    }
}

const split_seeds = 24;

pub fn expect_cases(cases: []const Case) !void {
    var fixture: Fixture = .{};
    for (cases) |case| {
        try fixture.init(case.pattern, .{ .captures = .groups });
        try expect_whole(&fixture, case);
        for (0..split_seeds) |seed| try expect_split(&fixture, case, seed);
    }
}

fn g(start: u64, end: u64) Group {
    return .{ start, end };
}

test "a literal matches where its octets first stand" {
    try expect_cases(&.{
        .{ .pattern = "abc", .text = "xabcx", .groups = &.{g(1, 4)} },
        .{ .pattern = "abc", .text = "abc", .groups = &.{g(0, 3)} },
        .{ .pattern = "abc", .text = "ababc", .groups = &.{g(2, 5)} },
        .{ .pattern = "abc", .text = "ab", .groups = &.{} },
        .{ .pattern = "abc", .text = "", .groups = &.{} },
        .{ .pattern = "", .text = "abc", .groups = &.{g(0, 0)} },
        .{ .pattern = "", .text = "", .groups = &.{g(0, 0)} },
        .{ .pattern = "aab", .text = "aaab", .groups = &.{g(1, 4)} },
    });
}

test "a quantifier takes as much as it can, and a lazy one as little" {
    try expect_cases(&.{
        .{ .pattern = "a*", .text = "aaa", .groups = &.{g(0, 3)} },
        .{ .pattern = "a*", .text = "baaa", .groups = &.{g(0, 0)} },
        .{ .pattern = "a+", .text = "baaa", .groups = &.{g(1, 4)} },
        .{ .pattern = "a+", .text = "bbb", .groups = &.{} },
        .{ .pattern = "a?", .text = "aa", .groups = &.{g(0, 1)} },
        .{ .pattern = "a*?", .text = "aaa", .groups = &.{g(0, 0)} },
        .{ .pattern = "a+?", .text = "aaa", .groups = &.{g(0, 1)} },
        .{ .pattern = "a??", .text = "a", .groups = &.{g(0, 0)} },
        .{ .pattern = "a.*c", .text = "abcabc", .groups = &.{g(0, 6)} },
        .{ .pattern = "a.*?c", .text = "abcabc", .groups = &.{g(0, 3)} },
        .{ .pattern = "(?U)a.*c", .text = "abcabc", .groups = &.{g(0, 3)} },
        .{ .pattern = "(?U)a.*?c", .text = "abcabc", .groups = &.{g(0, 6)} },
        .{ .pattern = "x*", .text = "aaxx", .groups = &.{g(0, 0)} },
    });
}

test "a range quantifier counts its operand" {
    try expect_cases(&.{
        .{ .pattern = "a{2}", .text = "aaa", .groups = &.{g(0, 2)} },
        .{ .pattern = "a{2}", .text = "a", .groups = &.{} },
        .{ .pattern = "a{2,}", .text = "aaaa", .groups = &.{g(0, 4)} },
        .{ .pattern = "a{2,}", .text = "a", .groups = &.{} },
        .{ .pattern = "a{2,3}", .text = "aaaa", .groups = &.{g(0, 3)} },
        .{ .pattern = "a{2,3}?", .text = "aaaa", .groups = &.{g(0, 2)} },
        .{ .pattern = "a{2,}?", .text = "aaaa", .groups = &.{g(0, 2)} },
        .{ .pattern = "a{0}", .text = "a", .groups = &.{g(0, 0)} },
        .{ .pattern = "a{0,2}", .text = "", .groups = &.{g(0, 0)} },
        .{ .pattern = "a{0,2}b", .text = "aaab", .groups = &.{g(1, 4)} },
        .{ .pattern = "(ab){2}", .text = "ababab", .groups = &.{ g(0, 4), g(2, 4) } },
        .{ .pattern = "(a{2}){2}", .text = "aaaaa", .groups = &.{ g(0, 4), g(2, 4) } },
        .{ .pattern = "x{3}", .text = "xx", .groups = &.{} },
        .{ .pattern = "(a{1,2}){2}", .text = "aaa", .groups = &.{ g(0, 3), g(2, 3) } },
        .{ .pattern = "[ab]{3,5}c", .text = "ababababc", .groups = &.{g(3, 9)} },
        .{ .pattern = "(a|b){2,3}", .text = "abab", .groups = &.{ g(0, 3), g(2, 3) } },
        .{ .pattern = "a{000002}", .text = "aaa", .groups = &.{g(0, 2)} },
    });
}

test "an alternation prefers its first alternative that matches" {
    try expect_cases(&.{
        .{ .pattern = "a|b", .text = "b", .groups = &.{g(0, 1)} },
        .{ .pattern = "foo|foobar", .text = "foobar", .groups = &.{g(0, 3)} },
        .{ .pattern = "foobar|foo", .text = "foobar", .groups = &.{g(0, 6)} },
        .{ .pattern = "a||b", .text = "b", .groups = &.{g(0, 0)} },
        .{ .pattern = "|a", .text = "a", .groups = &.{g(0, 0)} },
        .{ .pattern = "a|", .text = "a", .groups = &.{g(0, 1)} },
        .{ .pattern = "b+|ab+", .text = "abbb", .groups = &.{g(0, 4)} },
        .{ .pattern = "x|y|z", .text = "abz", .groups = &.{g(2, 3)} },
        .{ .pattern = "(a|ab)(c|bcd)(d*)", .text = "abcd", .groups = &.{ g(0, 4), g(0, 1), g(1, 4), g(4, 4) } },
        .{ .pattern = "(a|ab)(bc|c)?", .text = "abc", .groups = &.{ g(0, 3), g(0, 1), g(1, 3) } },
    });
}

test "a group captures the last text it matched, and nothing where it took no part" {
    try expect_cases(&.{
        .{ .pattern = "(a+)(b+)", .text = "aabbb", .groups = &.{ g(0, 5), g(0, 2), g(2, 5) } },
        .{ .pattern = "(a)|(b)", .text = "b", .groups = &.{ g(0, 1), null, g(0, 1) } },
        .{ .pattern = "((a)(b))", .text = "ab", .groups = &.{ g(0, 2), g(0, 2), g(0, 1), g(1, 2) } },
        .{ .pattern = "(a)(b)?", .text = "a", .groups = &.{ g(0, 1), g(0, 1), null } },
        .{ .pattern = "(a|b)*", .text = "abab", .groups = &.{ g(0, 4), g(3, 4) } },
        .{ .pattern = "(a|(b))+", .text = "ba", .groups = &.{ g(0, 2), g(1, 2), g(0, 1) } },
        .{ .pattern = "()", .text = "a", .groups = &.{ g(0, 0), g(0, 0) } },
        .{ .pattern = "(?:a)(b)", .text = "ab", .groups = &.{ g(0, 2), g(1, 2) } },
        .{ .pattern = "x(a*)y", .text = "xy", .groups = &.{ g(0, 2), g(1, 1) } },
    });
}

test "a loop over an operand that matches the empty string ends as a backtracking matcher ends it" {
    try expect_cases(&.{
        .{ .pattern = "(a*)*", .text = "b", .groups = &.{ g(0, 0), g(0, 0) } },
        .{ .pattern = "(a*)+", .text = "b", .groups = &.{ g(0, 0), g(0, 0) } },
        .{ .pattern = "(a*)*", .text = "aa", .groups = &.{ g(0, 2), g(0, 2) } },
        .{ .pattern = "(|a)*", .text = "aa", .groups = &.{ g(0, 0), g(0, 0) } },
        .{ .pattern = "(|a)+", .text = "aa", .groups = &.{ g(0, 0), g(0, 0) } },
        .{ .pattern = "(a|)*", .text = "aa", .groups = &.{ g(0, 2), g(1, 2) } },
        .{ .pattern = "(a?)*?b", .text = "aab", .groups = &.{ g(0, 3), g(1, 2) } },
        .{ .pattern = "(^)*", .text = "a", .groups = &.{ g(0, 0), g(0, 0) } },
    });
}

test "an anchor holds at the text's ends, and at each line's under (?m)" {
    try expect_cases(&.{
        .{ .pattern = "^abc$", .text = "abc", .groups = &.{g(0, 3)} },
        .{ .pattern = "^abc$", .text = "xabc", .groups = &.{} },
        .{ .pattern = "^abc$", .text = "abc\n", .groups = &.{} },
        .{ .pattern = "^b$", .text = "a\nb\nc", .groups = &.{} },
        .{ .pattern = "(?m)^b$", .text = "a\nb\nc", .groups = &.{g(2, 3)} },
        .{ .pattern = "(?m)^", .text = "a\nb", .groups = &.{g(0, 0)} },
        .{ .pattern = "(?m)$", .text = "a\nb", .groups = &.{g(1, 1)} },
        .{ .pattern = "(?m)a$\n^b", .text = "a\nb", .groups = &.{g(0, 3)} },
        .{ .pattern = "$", .text = "abc", .groups = &.{g(3, 3)} },
        .{ .pattern = "^", .text = "abc", .groups = &.{g(0, 0)} },
        .{ .pattern = "a$", .text = "aa", .groups = &.{g(1, 2)} },
        .{ .pattern = "\\Aa", .text = "ba", .groups = &.{} },
        .{ .pattern = "(?m)\\Ab", .text = "a\nb", .groups = &.{} },
        .{ .pattern = "(?m)a\\z", .text = "a\nb", .groups = &.{} },
        .{ .pattern = "a\\z", .text = "ba", .groups = &.{g(1, 2)} },
        .{ .pattern = "^$", .text = "", .groups = &.{g(0, 0)} },
        .{ .pattern = "^*a", .text = "a", .groups = &.{g(0, 1)} },
    });
}

test "a word boundary lies where a word character meets none" {
    try expect_cases(&.{
        .{ .pattern = "\\bfoo\\b", .text = "a foo b", .groups = &.{g(2, 5)} },
        .{ .pattern = "\\bfoo\\b", .text = "afoo foob foo", .groups = &.{g(10, 13)} },
        .{ .pattern = "\\Bfoo", .text = "afoo", .groups = &.{g(1, 4)} },
        .{ .pattern = "\\Bfoo", .text = "foo", .groups = &.{} },
        .{ .pattern = "\\B", .text = "", .groups = &.{g(0, 0)} },
        .{ .pattern = "\\b", .text = "", .groups = &.{} },
        .{ .pattern = "\\b", .text = " a", .groups = &.{g(1, 1)} },
        .{ .pattern = "a\\b", .text = "ab a", .groups = &.{g(3, 4)} },
        .{ .pattern = "\\b\\w+\\b", .text = "  hello_1 x", .groups = &.{g(2, 9)} },
        .{ .pattern = "x\\b\xC3\xA9", .text = "x\xC3\xA9", .groups = &.{g(0, 3)} },
    });
}

test "a class holds its characters, and a negated one every other scalar value" {
    try expect_cases(&.{
        .{ .pattern = "[a-c]+", .text = "xabcabcx", .groups = &.{g(1, 7)} },
        .{ .pattern = "[^a-c]+", .text = "abcxyzabc", .groups = &.{g(3, 6)} },
        .{ .pattern = "\\d+", .text = "abc123def", .groups = &.{g(3, 6)} },
        .{ .pattern = "\\D+", .text = "123abc456", .groups = &.{g(3, 6)} },
        .{ .pattern = "\\w+\\s\\w+", .text = "hello world!", .groups = &.{g(0, 11)} },
        .{ .pattern = "\\S+", .text = " \t\n\x0C\rab ", .groups = &.{g(5, 7)} },
        .{ .pattern = "\\s", .text = "a\x0Bb\x0C", .groups = &.{g(3, 4)} },
        .{ .pattern = "[\\d\\-x]+", .text = "ab1-x2c", .groups = &.{g(2, 6)} },
        .{ .pattern = "[.]", .text = "a.b", .groups = &.{g(1, 2)} },
        .{ .pattern = "\\.", .text = "a.b", .groups = &.{g(1, 2)} },
        .{ .pattern = "[^\\x00-\\x{10FFFF}]", .text = "abc", .groups = &.{} },
        .{ .pattern = "a[^\\x00-\\x{10FFFF}]|b", .text = "ab", .groups = &.{g(1, 2)} },
        .{ .pattern = "\\]\\}", .text = "x]}", .groups = &.{g(1, 3)} },
    });
}

test "the forms of RE2's syntax beside RFC 9485's match as RE2 matches them" {
    try expect_cases(&.{
        .{ .pattern = "[[:digit:]]+", .text = "ab123c", .groups = &.{g(2, 5)} },
        .{ .pattern = "[[:^alpha:]]+", .text = "ab12 \xC3\xA9c", .groups = &.{g(2, 7)} },
        .{ .pattern = "[[:upper:][:digit:]_]+", .text = "aB_9z", .groups = &.{g(1, 4)} },
        .{ .pattern = "(?i)[[:lower:]]+", .text = "1aBc2", .groups = &.{g(1, 4)} },
        .{ .pattern = "[]a]+", .text = "x]a]y", .groups = &.{g(1, 4)} },
        .{ .pattern = "[^]a]+", .text = "]ab]", .groups = &.{g(2, 3)} },
        .{ .pattern = "[a-c-e]+", .text = "da-ecf", .groups = &.{g(1, 5)} },
        .{ .pattern = "[--/]+", .text = "a-./b", .groups = &.{g(1, 4)} },
        .{ .pattern = "\\141\\0", .text = "ba\x00", .groups = &.{g(1, 3)} },
        .{ .pattern = "\\0600", .text = "x00", .groups = &.{g(1, 3)} },
        .{ .pattern = "[\\60-\\071]+", .text = "a0189b", .groups = &.{g(1, 5)} },
        .{ .pattern = "\\x{00000061}", .text = "ba", .groups = &.{g(1, 2)} },
    });
}

test "a scalar value past U+007F matches as its UTF-8, and no octet that is not UTF-8 matches" {
    try expect_cases(&.{
        .{ .pattern = "\xC3\xA9", .text = "caf\xC3\xA9", .groups = &.{g(3, 5)} },
        .{ .pattern = ".", .text = "\xC3\xA9", .groups = &.{g(0, 2)} },
        .{ .pattern = ".+", .text = "\xE6\x97\xA5\xE6\x9C\xAC\xE8\xAA\x9E", .groups = &.{g(0, 9)} },
        .{ .pattern = "[\xCE\xB1-\xCF\x89]+", .text = "abc\xCE\xB1\xCE\xB2\xCE\xB3def", .groups = &.{g(3, 9)} },
        .{ .pattern = "\\x{1F600}", .text = "a\xF0\x9F\x98\x80", .groups = &.{g(1, 5)} },
        .{ .pattern = "\\xe9", .text = "\xC3\xA9", .groups = &.{g(0, 2)} },
        .{ .pattern = "[^a]", .text = "\xFF", .groups = &.{} },
        .{ .pattern = "[^a]", .text = "a\xFF\xC3\xA9", .groups = &.{g(2, 4)} },
        .{ .pattern = ".", .text = "\xC3", .groups = &.{} },
        .{ .pattern = ".", .text = "\xED\xA0\x80", .groups = &.{} },
        .{ .pattern = ".", .text = "\xC0\x80a", .groups = &.{g(2, 3)} },
        .{ .pattern = ".", .text = "\n", .groups = &.{} },
        .{ .pattern = "(?s).", .text = "\n", .groups = &.{g(0, 1)} },
        .{ .pattern = "a.c", .text = "a\nc a\xE2\x82\xACc", .groups = &.{g(4, 9)} },
        .{ .pattern = "(.)(.)", .text = "\xC3\xA9\xF0\x9F\x98\x80", .groups = &.{ g(0, 6), g(0, 2), g(2, 6) } },
    });
}

test "no match starts inside the UTF-8 of a scalar value" {
    try expect_cases(&.{
        .{ .pattern = "\\B", .text = "a\xE6\x97\xA5", .groups = &.{g(4, 4)} },
        .{ .pattern = "\\B", .text = "a\xC3\xA9", .groups = &.{g(3, 3)} },
        .{ .pattern = "\\B|x", .text = "a\xF0\x9F\x98\x80x", .groups = &.{g(5, 6)} },
        .{ .pattern = "", .text = "\xC3\xA9", .groups = &.{g(0, 0)} },
        .{ .pattern = "$", .text = "\xC3\xA9", .groups = &.{g(2, 2)} },
        .{ .pattern = "\\B", .text = "\x80\x80", .groups = &.{g(2, 2)} },
    });
    var fixture: Fixture = .{};
    try fixture.init("", .{});
    try testing.expectEqual(@as(?Span, .{ .start = 2, .end = 2 }), fixture.matcher.find("\xC3\xA9", 1));
    try fixture.init("", .{ .anchored = true });
    try testing.expectEqual(@as(?Span, null), fixture.matcher.find("\xC3\xA9", 1));
}

test "a flag holds from where it stands to the end of its group" {
    try expect_cases(&.{
        .{ .pattern = "(?i)abc", .text = "xABcx", .groups = &.{g(1, 4)} },
        .{ .pattern = "(?i)[a-c]+", .text = "ABCabc", .groups = &.{g(0, 6)} },
        .{ .pattern = "(?i)[^a]", .text = "Aab", .groups = &.{g(2, 3)} },
        .{ .pattern = "a(?i)b", .text = "aB", .groups = &.{g(0, 2)} },
        .{ .pattern = "a(?i)b", .text = "AB", .groups = &.{} },
        .{ .pattern = "(?i:a)b", .text = "Ab", .groups = &.{g(0, 2)} },
        .{ .pattern = "(?i:a)b", .text = "AB", .groups = &.{} },
        .{ .pattern = "((?i)a)b", .text = "AB", .groups = &.{} },
        .{ .pattern = "((?i)a)b", .text = "Ab", .groups = &.{ g(0, 2), g(0, 1) } },
        .{ .pattern = "(?i)a(?-i)b", .text = "Ab", .groups = &.{g(0, 2)} },
        .{ .pattern = "(?i)a(?-i)b", .text = "AB", .groups = &.{} },
        .{ .pattern = "(?is)A.", .text = "a\n", .groups = &.{g(0, 2)} },
        .{ .pattern = "(?s-i:.)", .text = "\n", .groups = &.{g(0, 1)} },
        .{ .pattern = "(?i)\\x41", .text = "a", .groups = &.{g(0, 1)} },
        .{ .pattern = "(?i)@\\[`\\{", .text = "@[`{", .groups = &.{g(0, 4)} },
        .{ .pattern = "(?i)@", .text = "`", .groups = &.{} },
        .{ .pattern = "(?i)k", .text = "\xE2\x84\xAA", .groups = &.{g(0, 3)} },
    });
}

test "Unicode's properties and case folding match as Go's regexp matches them" {
    // Go 1.27.4's regexp found each case's groups. Each property's program fits `storage_len`,
    // which `\\pL`'s 7,350 instructions do not: the parser's tests and the oracle check take it.
    try expect_cases(&.{
        .{ .pattern = "(?i)\\x{212A}", .text = "k", .groups = &.{g(0, 1)} },
        .{ .pattern = "(?i)\xC3\xA9", .text = "x\xC3\x89x", .groups = &.{g(1, 3)} },
        .{ .pattern = "(?i)\xCF\x83", .text = "\xCF\x82", .groups = &.{g(0, 2)} },
        .{ .pattern = "(?i)\xC3\x9F", .text = "\xE1\xBA\x9E", .groups = &.{g(0, 3)} },
        .{ .pattern = "(?i)s", .text = "\xC5\xBF", .groups = &.{g(0, 2)} },
        .{ .pattern = "(?i)\\x{345}", .text = "\xE1\xBE\xBE", .groups = &.{g(0, 3)} },
        .{ .pattern = "\\p{Greek}+", .text = "a\xCE\xB1\xCE\xB2\xCE\xB3b", .groups = &.{g(1, 7)} },
        .{ .pattern = "\\p{Han}+", .text = "1\xE6\x97\xA5\xE6\x9C\xAC2", .groups = &.{g(1, 7)} },
        .{ .pattern = "\\P{Greek}+", .text = "\xCE\xB1\xCE\xB212\xCE\xB3", .groups = &.{g(4, 6)} },
        .{ .pattern = "\\P{^Greek}+", .text = "ab\xCE\xB1\xCE\xB2", .groups = &.{g(2, 6)} },
        .{ .pattern = "[\\p{Greek}\\d]+", .text = "a\xCE\xB11\xCE\xB2b", .groups = &.{g(1, 6)} },
        .{ .pattern = "[^\\p{Han}]+", .text = "\xE6\x97\xA5 12\xE6\x9C\xAC", .groups = &.{g(3, 6)} },
        .{ .pattern = "(?i)\\p{Lu}+", .text = "1aBc2", .groups = &.{g(1, 4)} },
        .{ .pattern = "(?i)\\P{Lu}+", .text = "aB12", .groups = &.{g(2, 4)} },
        .{ .pattern = "(?i)[^k]", .text = "\xE2\x84\xAAb", .groups = &.{g(3, 4)} },
        .{ .pattern = "(?i)[\\W]", .text = "k\xE2\x84\xAA-", .groups = &.{g(4, 5)} },
        .{ .pattern = "\\p{Any}+", .text = "a\n\xE6\x97\xA5", .groups = &.{g(0, 5)} },
        .{ .pattern = "\\P{Any}", .text = "abc", .groups = &.{} },
        .{ .pattern = "[\\P{Any}a]", .text = "ba", .groups = &.{g(1, 2)} },
        .{ .pattern = "\\p{ASCII}+", .text = "\xC3\xA9 ab", .groups = &.{g(2, 5)} },
        .{ .pattern = "\\p{Nd}+", .text = "a\xD9\xA34", .groups = &.{g(1, 4)} },
    });
}

const Runs = struct { text: []const u8, consumed: usize, span: ?Span };

fn expect_run(pattern: []const u8, options: matcher_file.Options, run: Runs) !void {
    var fixture: Fixture = .{};
    try fixture.init(pattern, options);
    const step = fixture.matcher.search(run.text, .last);
    try testing.expectEqual(run.consumed, step.consumed);
    try testing.expectEqual(run.span != null, step.status == .match);
    if (run.span != null and options.captures != .none) try testing.expectEqual(run.span, fixture.matcher.span());
}

test "a search takes no octet past the one that decided it" {
    // A literal is decided at its last octet, with no octet read after it.
    try expect_run("abc", .{}, .{ .text = "xabcyyy", .consumed = 4, .span = .{ .start = 1, .end = 4 } });
    // A loop is decided by the first octet it does not take.
    try expect_run("a+", .{}, .{ .text = "aabbb", .consumed = 3, .span = .{ .start = 0, .end = 2 } });
    // An alternative that could still match longer keeps the search open past the match.
    try expect_run("a|a.*z", .{}, .{ .text = "abcd", .consumed = 1, .span = .{ .start = 0, .end = 1 } });
    try expect_run("a.*z|a", .{}, .{ .text = "abcd", .consumed = 4, .span = .{ .start = 0, .end = 1 } });
    // An anchored search ends at the first octet no thread takes.
    try expect_run("abc", .{ .anchored = true }, .{ .text = "xabc", .consumed = 1, .span = null });
    try expect_run("abc", .{}, .{ .text = "xabx", .consumed = 4, .span = null });
}

test "an anchored search matches at its first octet alone" {
    try expect_run("b+", .{ .anchored = true }, .{ .text = "abb", .consumed = 1, .span = null });
    try expect_run("b+", .{ .anchored = true }, .{ .text = "bba", .consumed = 3, .span = .{ .start = 0, .end = 2 } });
    try expect_run("", .{ .anchored = true }, .{ .text = "abc", .consumed = 0, .span = .{ .start = 0, .end = 0 } });
    try expect_run("a*?", .{ .anchored = true }, .{ .text = "aaa", .consumed = 0, .span = .{ .start = 0, .end = 0 } });
}

test "a search for no capture ends at the first match it reaches" {
    try expect_run("a.*z|a", .{ .captures = .none }, .{ .text = "abcd", .consumed = 1, .span = .{ .start = 0, .end = 1 } });
    try expect_run("a+", .{ .captures = .none }, .{ .text = "xaaaa", .consumed = 2, .span = .{ .start = 1, .end = 2 } });
    try expect_run("a+", .{ .captures = .none }, .{ .text = "xyz", .consumed = 3, .span = null });
    var fixture: Fixture = .{};
    try fixture.init("(a)(b)", .{ .captures = .none });
    try testing.expectEqual(matcher_file.Status.match, fixture.matcher.search("ab", .last).status);
    try testing.expectEqual(@as(?Span, null), fixture.matcher.span());
    try fixture.init("(a)(b)", .{ .captures = .span });
    try testing.expectEqual(matcher_file.Status.match, fixture.matcher.search("ab", .last).status);
    try testing.expectEqual(@as(?Span, .{ .start = 0, .end = 2 }), fixture.matcher.span());
    try testing.expectEqual(@as(?Span, null), fixture.matcher.group(1));
}

test "a program with no assertion that reads ahead reports its match before the next octet arrives" {
    var fixture: Fixture = .{};
    try fixture.init("abc", .{});
    const step = fixture.matcher.search("xabc", .more);
    try testing.expectEqual(matcher_file.Status.match, step.status);
    try testing.expectEqual(@as(usize, 4), step.consumed);
    // `$` reads the octet ahead, so the same text decides nothing until that octet or the end.
    try fixture.init("abc$", .{});
    try testing.expectEqual(matcher_file.Status.needs_input, fixture.matcher.search("xabc", .more).status);
    try testing.expectEqual(matcher_file.Status.match, fixture.matcher.search("", .last).status);
    try testing.expectEqual(@as(?Span, .{ .start = 1, .end = 4 }), fixture.matcher.span());
    try fixture.init("abc$", .{});
    try testing.expectEqual(matcher_file.Status.needs_input, fixture.matcher.search("xabc", .more).status);
    const more = fixture.matcher.search("d", .more);
    try testing.expectEqual(matcher_file.Status.needs_input, more.status);
    try testing.expectEqual(matcher_file.Status.no_match, fixture.matcher.search("", .last).status);
}

test "start gives a search the octet behind its first, and the offset its spans count from" {
    var fixture: Fixture = .{};
    try fixture.init("^a", .{});
    fixture.matcher.start('x', 100);
    try testing.expectEqual(matcher_file.Status.no_match, fixture.matcher.search("a", .last).status);
    try fixture.init("(?m)^a", .{});
    fixture.matcher.start('\n', 100);
    try testing.expectEqual(matcher_file.Status.match, fixture.matcher.search("a", .last).status);
    try testing.expectEqual(@as(?Span, .{ .start = 100, .end = 101 }), fixture.matcher.span());
    try fixture.init("\\bb", .{});
    fixture.matcher.start('a', 7);
    try testing.expectEqual(matcher_file.Status.no_match, fixture.matcher.search("b", .last).status);
    fixture.matcher.start(' ', 7);
    try testing.expectEqual(matcher_file.Status.match, fixture.matcher.search("b", .last).status);
    try testing.expectEqual(@as(?Span, .{ .start = 7, .end = 8 }), fixture.matcher.span());
}

test "find searches a haystack from an offset, with the octet before it behind" {
    var fixture: Fixture = .{};
    try fixture.init("\\bab", .{});
    const haystack = "ab cab ab";
    try testing.expectEqual(@as(?Span, .{ .start = 0, .end = 2 }), fixture.matcher.find(haystack, 0));
    try testing.expectEqual(@as(?Span, .{ .start = 7, .end = 9 }), fixture.matcher.find(haystack, 1));
    try testing.expectEqual(@as(?Span, .{ .start = 7, .end = 9 }), fixture.matcher.find(haystack, 7));
    try testing.expectEqual(@as(?Span, null), fixture.matcher.find(haystack, 8));
    try testing.expectEqual(@as(?Span, null), fixture.matcher.find(haystack, haystack.len));
    try testing.expectEqualSlices(u8, "ab", fixture.matcher.find(haystack, 3).?.slice(haystack));
}

test "one matcher serves search after search, each from a clean start" {
    var fixture: Fixture = .{};
    try fixture.init("(a)|(b)", .{ .captures = .groups });
    try expect_whole(&fixture, .{ .pattern = "", .text = "b", .groups = &.{ g(0, 1), null, g(0, 1) } });
    try expect_whole(&fixture, .{ .pattern = "", .text = "a", .groups = &.{ g(0, 1), g(0, 1), null } });
    try expect_whole(&fixture, .{ .pattern = "", .text = "c", .groups = &.{} });
    try expect_whole(&fixture, .{ .pattern = "", .text = "cb", .groups = &.{ g(1, 2), null, g(1, 2) } });
}

test "memory_len is what init takes from its memory" {
    var fixture: Fixture = .{};
    fixture.program = try compiler.compile("(a|b)+c", .{}, &fixture.storage);
    const slots_len = Matcher.slots_of(&fixture.program, .groups);
    try testing.expectEqual(@as(u32, 4), slots_len);
    const len = Matcher.memory_len(fixture.program.forward_len, slots_len);
    const guard: u64 = 0xA5A5_A5A5_A5A5_A5A5;
    @memset(&fixture.memory, guard);
    fixture.matcher.init(&fixture.program, .{ .captures = .groups }, fixture.memory[0..len]);
    try testing.expectEqual(matcher_file.Status.match, fixture.matcher.search("xxababc", .last).status);
    try testing.expectEqual(@as(?Span, .{ .start = 2, .end = 7 }), fixture.matcher.span());
    for (fixture.memory[len..]) |word| try testing.expectEqual(guard, word);
}
