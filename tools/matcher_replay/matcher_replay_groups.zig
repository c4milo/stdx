//! The capture groups of a `groups` line, and whether a matcher or a searcher gives them
//! (decision 86, design §8 part 22h).
//!
//! The Lean side writes a `groups` line after a search's `find` line: the groups of the
//! search's match, the whole match first, as the slots of the model's threads hold them
//! (spec/lean/Stdx/Regex/Captures.lean). A group is `<start>:<end>`, or `-` where it took no part
//! in the match. The line `groups <low> none` says that the search finds no match.
const std = @import("std");
const regex = @import("regex");

/// The groups a line holds at most: the whole match, and the groups of a program that keeps
/// `slots_max` slots.
pub fn Buffer(comptime slots_max: usize) type {
    return [slots_max / regex.constants.group_slots]?regex.Span;
}

const radix = 10;

/// Reads a line's groups after its offset, into `buffer`. Null for `none`.
pub fn read(tokens: *std.mem.TokenIterator(u8, .scalar), buffer: []?regex.Span) !?[]const ?regex.Span {
    const first = tokens.next() orelse return error.VectorShort;
    if (std.mem.eql(u8, first, "none")) return null;
    const count = try std.fmt.parseInt(usize, first, radix);
    if (count == 0 or count > buffer.len) return error.VectorGroups;
    for (buffer[0..count]) |*group| {
        const word = tokens.next() orelse return error.VectorShort;
        group.* = try span_of(word);
    }
    if (tokens.next() != null) return error.VectorGroups;
    return buffer[0..count];
}

/// A group from its word: `-`, or a start and an end with `:` between them.
fn span_of(word: []const u8) !?regex.Span {
    if (std.mem.eql(u8, word, "-")) return null;
    const colon = std.mem.indexOfScalar(u8, word, ':') orelse return error.VectorGroups;
    const start = try std.fmt.parseInt(u64, word[0..colon], radix);
    const end = try std.fmt.parseInt(u64, word[colon + 1 ..], radix);
    if (start > end) return error.VectorGroups;
    return .{ .start = start, .end = end };
}

fn same(found: ?regex.Span, wanted: ?regex.Span) bool {
    const span = found orelse return wanted == null;
    const other = wanted orelse return false;
    return span.start == other.start and span.end == other.end;
}

/// True when a matcher's last search, which kept a slot for each group and gave `found`, holds
/// the groups of a line.
pub fn matcher_gives(matcher: *const regex.Matcher, found: ?regex.Span, wanted: ?[]const ?regex.Span) bool {
    const groups = wanted orelse return found == null;
    if (found == null or matcher.program.group_count != groups.len) return false;
    for (groups, 0..) |group, index| {
        if (!same(matcher.group(@intCast(index)), group)) return false;
    }
    return true;
}

/// True when a searcher's `captures` for a search of `text` from `low` gives the groups of a
/// line.
pub fn searcher_gives(searcher: *regex.Searcher, text: []const u8, low: usize, wanted: ?[]const ?regex.Span) bool {
    const found = searcher.captures(text, low);
    const groups = wanted orelse return found == null;
    const held = found orelse return false;
    if (held.len() != groups.len) return false;
    for (groups, 0..) |group, index| {
        if (!same(held.get(index), group)) return false;
    }
    return true;
}

const testing = std.testing;
const platform = @import("platform");
const test_slots_max = 8;
const test_instructions_max = 64;

test "a matcher and a searcher are held to each group of a line, and to their count" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const storage = try arena.allocator().alloc(regex.Instruction, test_instructions_max);
    const program = try regex.compile("(a+)(b)?c", .{}, storage);
    var matcher: regex.Matcher = undefined;
    matcher.init(&program, .{ .captures = .groups }, try arena.allocator().alloc(u64, regex.Matcher.memory_len(program.forward_len, program.slot_count())));
    var searcher: regex.Searcher = undefined;
    const words = regex.Searcher.memory_len(program.forward_len, program.slot_count(), regex.constants.cache_words_default);
    searcher.init(&program, &.{ .features = platform.CpuFeatures.detect() }, try arena.allocator().alloc(u64, words));
    const whole: regex.Span = .{ .start = 1, .end = 4 };
    const first: regex.Span = .{ .start = 1, .end = 3 };
    const right = [_]?regex.Span{ whole, first, null };
    const lines = [_]struct { groups: ?[]const ?regex.Span, gives: bool }{
        .{ .groups = &right, .gives = true },
        // Another span of the last group but one, a last group that took part, one group
        // fewer, one more, and no match.
        .{ .groups = &.{ whole, .{ .start = 1, .end = 2 }, null }, .gives = false },
        .{ .groups = &.{ whole, first, .{ .start = 3, .end = 3 } }, .gives = false },
        .{ .groups = &.{ whole, first }, .gives = false },
        .{ .groups = &.{ whole, first, null, null }, .gives = false },
        .{ .groups = null, .gives = false },
    };
    for (lines) |line| {
        try testing.expectEqual(line.gives, matcher_gives(&matcher, matcher.find("xaac", 0), line.groups));
        try testing.expectEqual(line.gives, searcher_gives(&searcher, "xaac", 0, line.groups));
    }
    // A text with no match gives `none`, and no groups.
    try testing.expect(matcher_gives(&matcher, matcher.find("xaa", 0), null));
    try testing.expect(searcher_gives(&searcher, "xaa", 0, null));
    try testing.expect(!matcher_gives(&matcher, matcher.find("xaa", 0), &right));
    try testing.expect(!searcher_gives(&searcher, "xaa", 0, &right));
}

fn test_read(line: []const u8, buffer: *Buffer(test_slots_max)) !?[]const ?regex.Span {
    var tokens = std.mem.tokenizeScalar(u8, line, ' ');
    return read(&tokens, buffer);
}

test "a line's groups are spans, or nothing where a group took no part" {
    var buffer: Buffer(test_slots_max) = undefined;
    try testing.expect(try test_read("none", &buffer) == null);
    const groups = (try test_read("3 1:4 - 3:3", &buffer)).?;
    try testing.expectEqual(@as(usize, 3), groups.len);
    try testing.expect(same(groups[0], .{ .start = 1, .end = 4 }));
    try testing.expect(groups[1] == null);
    try testing.expect(same(groups[2], .{ .start = 3, .end = 3 }));
    try testing.expect(!same(groups[0], .{ .start = 1, .end = 5 }));
    try testing.expect(!same(groups[0], .{ .start = 0, .end = 4 }));
    try testing.expect(!same(groups[0], null) and !same(null, groups[0]));
    // A count of none, more groups than the buffer holds, fewer words than the count, more
    // words, a word with no colon, and an end before its start.
    try testing.expectError(error.VectorGroups, test_read("0", &buffer));
    try testing.expectError(error.VectorGroups, test_read("5 - - - - -", &buffer));
    try testing.expectError(error.VectorShort, test_read("2 1:4", &buffer));
    try testing.expectError(error.VectorGroups, test_read("1 1:4 -", &buffer));
    try testing.expectError(error.VectorGroups, test_read("1 14", &buffer));
    try testing.expectError(error.VectorGroups, test_read("1 4:1", &buffer));
    try testing.expectError(error.VectorShort, test_read("", &buffer));
}
