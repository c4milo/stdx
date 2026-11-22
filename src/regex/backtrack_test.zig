//! Tests of claim R8 (backtrack.zig): the backtracker gives the match and the groups the matcher
//! gives, from each start where the matcher finds a match, and gives way where its tables are too
//! small.
const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const compiler = @import("compile.zig");
const generate = @import("generate_test.zig");
const matcher_test = @import("matcher_test.zig");
const program_file = @import("program.zig");
const matcher_file = @import("matcher.zig");
const backtrack = @import("backtrack.zig");
const searcher_test = @import("searcher/searcher_test.zig");
const Matcher = matcher_file.Matcher;
const Generator = codec.testing.split.Generator;

/// A program and a matcher anchored at a search's start, in the memory its slots take and no more,
/// so the tables the backtracker takes are as small as a caller's.
const Fixture = struct {
    storage: [matcher_test.storage_len]program_file.Instruction = undefined,
    memory: [matcher_test.memory_len]u64 = undefined,
    program: program_file.Program = undefined,
    matcher: Matcher = undefined,

    fn init(fixture: *Fixture, pattern: []const u8) !void {
        fixture.program = try compiler.compile(pattern, .{}, &fixture.storage);
        if (fixture.program.group_count > matcher_test.groups_len) return error.TestTooManyGroups;
        const len = Matcher.memory_len(fixture.program.forward_len, fixture.program.slot_count());
        fixture.matcher.init(&fixture.program, .{ .captures = .groups, .anchored = true }, fixture.memory[0..len]);
    }
};

/// The patterns a seed draws, and the texts a seed draws for each.
const random_patterns = 3000;
const random_texts = 8;

/// What one start gave: no match, a match the backtracker found as the matcher does, or a match
/// whose tables were too small.
const Outcome = enum { none, found, gave_way };

fn expect_groups(fixture: *Fixture, reference: *Fixture, text: []const u8, start: usize) !Outcome {
    const expected = reference.matcher.find(text, start) orelse return .none;
    const found = backtrack.find(&fixture.matcher, text, start, @intCast(expected.end)) orelse return .gave_way;
    try testing.expectEqual(expected, found);
    for (0..fixture.program.group_count) |group| {
        try testing.expectEqual(reference.matcher.group(@intCast(group)), fixture.matcher.group(@intCast(group)));
    }
    return .found;
}

test "find gives the match and the groups the matcher gives, from each start where one starts" {
    var fixture: Fixture = .{};
    var reference: Fixture = .{};
    var generator = Generator.init(0xBAC7);
    var pattern_buffer: [generate.pattern_len_max]u8 = undefined;
    var text_buffer: [generate.text_len_max]u8 = undefined;
    var counts: std.EnumArray(Outcome, usize) = .initFill(0);
    for (0..random_patterns) |_| {
        const pattern = generate.pattern(&generator, &pattern_buffer);
        try fixture.init(pattern);
        try reference.init(pattern);
        for (0..random_texts) |_| {
            const text = generate.text(&generator, &text_buffer);
            for (0..text.len + 1) |start| counts.getPtr(try expect_groups(&fixture, &reference, text, start)).* += 1;
        }
    }
    // A seed of 3,000 patterns gave 51,178 matches, of which 37 gave way: a stack that outgrew
    // the tables of a pattern of nested loops. The bound catches a backtracker that gives way at
    // more than one start in 500.
    try testing.expect(counts.get(.found) > random_patterns);
    try testing.expect(counts.get(.gave_way) * 500 < counts.get(.found));
}

test "a path that fails gives back each slot it wrote" {
    var fixture: Fixture = .{};
    var reference: Fixture = .{};
    // The first branch writes both groups and fails at `y`; the match takes the second branch.
    for ([_][]const u8{ "(a)(b)y|a(b)z", "(?:(a)|(a)(b))c", "(a*)+b|(a)c", "((a)|b)*c" }) |pattern| {
        try fixture.init(pattern);
        try reference.init(pattern);
        for ([_][]const u8{ "abz", "abc", "ac", "aac", "babac" }) |text| {
            for (0..text.len + 1) |start| try testing.expect(try expect_groups(&fixture, &reference, text, start) != .gave_way);
        }
    }
}

/// A text longer than the visited bits of a program of one group hold: two slots of the group's
/// tables a pair of instruction and offset hold `constants.group_slots * 64` offsets.
const long_text_len = 600;

/// A text whose every octet pushes a split and two restores, more than the stack of a short
/// program holds.
const deep_text_len = 60;

test "find gives way where the visited bits or the stack do not fit the matcher's tables" {
    var fixture: Fixture = .{};
    const long = "a" ** long_text_len;
    try fixture.init("(a+)");
    try testing.expectEqual(null, backtrack.find(&fixture.matcher, long, 0, long.len));
    const deep = "a" ** deep_text_len;
    try fixture.init("(a)*");
    const forward_len: usize = fixture.program.forward_len;
    try testing.expect(forward_len * (deep.len + 1) <= fixture.matcher.seed_slots.len * @bitSizeOf(u64));
    try testing.expectEqual(null, backtrack.find(&fixture.matcher, deep, 0, deep.len));
    // The searcher then finds the groups with the matcher.
    var searching: searcher_test.Fixture = .{};
    for ([_][]const u8{ "(a+)", "(a)*" }) |pattern| {
        try searching.init(pattern, searcher_test.cache_words_max);
        try searching.expect_agree(long, 0);
        try searching.expect_agree(deep, 0);
    }
}

test "a searcher finds the groups of a pattern that is not one-pass with no step of the matcher" {
    var searching: searcher_test.Fixture = .{};
    for ([_]bool{ true, false }) |backtrack_on| {
        try searching.init_claims("(a|ab)(c)", .{ .backtrack = backtrack_on }, searcher_test.cache_words_max);
        try searching.expect_agree("xabc abc", 0);
        searching.searcher.matcher.work = 0;
        try searching.expect_agree("xabc abc", 0);
        try testing.expectEqual(backtrack_on, searching.searcher.matcher.work == 0);
    }
    // A pattern of no group but the whole match needs no path: the DFAs give its span.
    try searching.init("a+b", searcher_test.cache_words_max);
    searching.searcher.matcher.work = 0;
    try searching.expect_agree("xaab", 0);
    try testing.expectEqual(0, searching.searcher.matcher.work);
}

/// A line longer than the stack of a short program holds where each octet leaves the other
/// alternatives of `.` behind it, and well under the room its visited bits take.
const line_len = 100;

test "the alternatives that fail at once leave no entry on the stack" {
    var fixture: Fixture = .{};
    var reference: Fixture = .{};
    const line = "a" ** line_len ++ "!";
    // A group inside the loop pushes two entries an octet to restore its slots, so the loops
    // here hold none.
    for ([_][]const u8{ "(.*)!", "(?:x|.)*(!)", "(?:\\w|\\d)+(!)" }) |pattern| {
        try fixture.init(pattern);
        try reference.init(pattern);
        // The tables hold far fewer entries than the line's octets times the alternatives of `.`.
        try testing.expect(fixture.matcher.thread_slots.len < line.len * 4);
        try testing.expectEqual(.found, try expect_groups(&fixture, &reference, line, 0));
    }
}

/// The visited bits a search left in the matcher's first table.
fn visited_bits(fixture: *const Fixture, span_len: usize) usize {
    const bits = @as(usize, fixture.program.forward_len) * (span_len + 1);
    const words = (bits + @bitSizeOf(u64) - 1) / @bitSizeOf(u64);
    var count: usize = 0;
    for (fixture.matcher.seed_slots[0..words]) |word| count += @popCount(word);
    return count;
}

test "the branches that fail at once take no visited bit" {
    var fixture: Fixture = .{};
    var reference: Fixture = .{};
    // Each branch after the first starts with a save and an octet, or an assertion, that fails
    // at the text's first octet, so the search skips it and visits the first branch and the
    // last. The counts are the bits those visits take: a search that visits a skipped branch
    // takes more.
    const cases = [_]struct { pattern: []const u8, bits: usize }{
        .{ .pattern = "(a)|(b)|(c)|(d)", .bits = 9 },
        .{ .pattern = "(?:x|\\Bd|(d))", .bits = 8 },
    };
    for (cases) |case| {
        try fixture.init(case.pattern);
        try reference.init(case.pattern);
        try testing.expectEqual(.found, try expect_groups(&fixture, &reference, "d", 0));
        try testing.expectEqual(case.bits, visited_bits(&fixture, 1));
    }
}

test "a pattern of no group but the whole match takes the DFAs' span, with no backtracker" {
    var searching: searcher_test.Fixture = .{};
    try searching.init_claims("a+b", .{ .backtrack = false }, searcher_test.cache_words_max);
    searching.searcher.matcher.work = 0;
    try searching.expect_agree("xaab", 0);
    try testing.expectEqual(0, searching.searcher.matcher.work);
}
