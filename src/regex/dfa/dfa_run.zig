//! The lazy DFA's runs (decision 86): the loops a scan takes octets in while each entry is a
//! plain row, and while each entry is a row that a match ended before.
//!
//! A scan leaves its loop of plain rows at an entry with `dfa_match_flag`, to keep where the
//! match ended. A text whose matches are long, such as `.*` over a long line, then left the loop
//! at each octet of a match, and each octet took the slow path's tests: claim R7's pair turn and
//! a call to take two octets, about 40 instructions an octet. The loop of matches takes such an
//! entry as a row, and the scan keeps the last match alone, where the loop ends.
//!
//! Each loop is one of its own, which no slow path joins: the compiler then gives it one branch
//! an octet. Where the slow path joined the plain loop, its latch took a second, and an EPYC
//! 9V74 ran the loop at half its speed.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

/// The table of a DFA, and the class of each octet: what each loop reads.
const Classes = [constants.octet_values]u8;

// The match flag is the entry's top bit, so an entry without it, less the flag, wraps over every
// flag: `is_matched_row` then holds it to be no row a match ended before.
comptime {
    assert(constants.dfa_match_flag == 1 << 31);
    assert(constants.dfa_flags_min > constants.dfa_row_mask);
}

/// The offset of the first octet at or after `from` whose entry from `state` is no plain row, or
/// the haystack's length, with `state` moved over the octets before it.
pub inline fn plain(table: []const u32, classes: *const Classes, haystack: []const u8, from: usize, state: *u32) usize {
    var current = state.*;
    // The loop counts the octets it took, and only its exit adds them to `from`.
    for (haystack[from..], 0..) |octet, taken| {
        // A row is under the table's length less a stride, and a class under the stride, so the
        // sum cannot wrap, and the read's bounds check holds it.
        const entry = table[current +% classes[octet]];
        if (entry >= constants.dfa_dead_flag) {
            state.* = current;
            return from + taken;
        }
        current = entry;
    }
    state.* = current;
    return haystack.len;
}

/// The offset of the first octet at or after `from` whose entry from `state` is no row with the
/// match flag alone, or the haystack's length, with `state` moved over the octets before it. A
/// match ends before each octet the loop took, so the last of them is where the scan's last
/// match ends.
pub inline fn matched(table: []const u32, classes: *const Classes, haystack: []const u8, from: usize, state: *u32) usize {
    var current = state.*;
    // As in `plain`: the loop counts the octets it took, and the sum of a row and a class cannot
    // wrap.
    for (haystack[from..], 0..) |octet, taken| {
        const entry = table[current +% classes[octet]];
        if (!is_matched_row(entry)) {
            state.* = current;
            return from + taken;
        }
        current = entry - constants.dfa_match_flag;
    }
    state.* = current;
    return haystack.len;
}

/// `matched` for a scan that reads back from `end` toward `from`: the least offset, at or after
/// `from`, from which each octet to `end` has a row with the match flag alone, read back from
/// `state`. A match starts after each octet the loop took, so the offset is where the scan's
/// last match starts, where the loop took one.
pub inline fn matched_back(table: []const u32, classes: *const Classes, haystack: []const u8, from: usize, end: usize, state: *u32) usize {
    assert(from <= end and end <= haystack.len);
    var current = state.*;
    var index = end;
    // Each turn takes the octet before `index`, so the turns are at most `end - from`.
    while (index > from) {
        const entry = table[current +% classes[haystack[index - 1]]];
        if (!is_matched_row(entry)) break;
        current = entry - constants.dfa_match_flag;
        index -= 1;
    }
    state.* = current;
    return index;
}

/// Whether an entry is a row with the match flag and no other flag. With the flag taken off, such
/// an entry is a row, and any other entry wraps or keeps a flag, the entry not yet built too.
inline fn is_matched_row(entry: u32) bool {
    return entry -% constants.dfa_match_flag < constants.dfa_flags_min;
}

const testing = std.testing;

/// A table of three rows over three classes. Row 0 leads to the match row, with a match, on
/// class 0; the match row stays where it is, with a match, on class 0; a line feed, class 1, ends
/// each, with a match from the match row and the dead flag. Class 2 leads from the match row to
/// the plain row, and from the plain row to nothing built.
const test_stride = 3;
const test_match_row = test_stride;
const test_plain_row = test_match_row + test_stride;
const test_table = [_]u32{
    constants.dfa_match_flag | test_match_row, constants.dfa_dead_flag,                            0,
    constants.dfa_match_flag | test_match_row, constants.dfa_match_flag | constants.dfa_dead_flag, test_plain_row,
    constants.dfa_unknown,                     constants.dfa_unknown,                              constants.dfa_unknown,
};

/// The classes of the table: an x, a line feed, and every other octet.
const TestClass = enum(u8) { x, line_feed, other };

fn test_classes() Classes {
    var classes: Classes = @splat(@intFromEnum(TestClass.other));
    classes['x'] = @intFromEnum(TestClass.x);
    classes['\n'] = @intFromEnum(TestClass.line_feed);
    return classes;
}

test "a run of matches stops at an entry that is dead, plain or not built, and at the text's end" {
    const classes = test_classes();
    var state: u32 = 0;
    try testing.expectEqual(@as(usize, 3), matched(&test_table, &classes, "xxx\nx", 0, &state));
    try testing.expectEqual(@as(u32, test_match_row), state);
    // A plain row stops the run; from it, the next entry is not built.
    state = 0;
    try testing.expectEqual(@as(usize, 2), matched(&test_table, &classes, "xxyx", 0, &state));
    try testing.expectEqual(@as(u32, test_match_row), state);
    state = test_plain_row;
    try testing.expectEqual(@as(usize, 1), matched(&test_table, &classes, "xx", 1, &state));
    try testing.expectEqual(@as(u32, test_plain_row), state);
    state = 0;
    try testing.expectEqual(@as(usize, 4), matched(&test_table, &classes, "xxxx", 0, &state));
    try testing.expectEqual(@as(u32, test_match_row), state);
    // The plain loop stops at the first entry with a flag.
    state = 0;
    try testing.expectEqual(@as(usize, 1), plain(&test_table, &classes, "yxx", 0, &state));
    try testing.expectEqual(@as(u32, 0), state);
}

test "a run of matches read back stops at an entry that is no match row, and at its start" {
    const classes = test_classes();
    var state: u32 = 0;
    try testing.expectEqual(@as(usize, 2), matched_back(&test_table, &classes, "x\nxxx", 0, 5, &state));
    try testing.expectEqual(@as(u32, test_match_row), state);
    state = 0;
    try testing.expectEqual(@as(usize, 1), matched_back(&test_table, &classes, "xxxx", 1, 4, &state));
    try testing.expectEqual(@as(u32, test_match_row), state);
    state = 0;
    try testing.expectEqual(@as(usize, 2), matched_back(&test_table, &classes, "xyxx", 0, 4, &state));
    state = 0;
    try testing.expectEqual(@as(usize, 0), matched_back(&test_table, &classes, "xxx", 0, 3, &state));
    try testing.expectEqual(@as(u32, test_match_row), state);
    state = test_plain_row;
    try testing.expectEqual(@as(usize, 3), matched_back(&test_table, &classes, "xxx", 0, 3, &state));
    try testing.expectEqual(@as(u32, test_plain_row), state);
}
