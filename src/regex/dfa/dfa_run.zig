//! The lazy DFA's runs (decision 86): the loops a scan takes octets in while each entry is a
//! plain row, and, once a match ended, while each entry is a row with the match flag or none.
//!
//! A scan leaves its loop of plain rows at an entry with `dfa_match_flag`, to keep where the
//! match ended. A text whose matches are long, such as `.*` over a long line, then left the loop
//! at each octet of a match, and each octet took the slow path's tests: claim R7's pair turn and
//! a call to take two octets, about 40 instructions an octet. The loop of matches takes such an
//! entry as a row, and the scan keeps the last match alone, where the loop ends. Where the entry
//! that ends the loop is dead, the scan ends there too, with no turn of its own loop.
//!
//! Each loop is one of its own, which no slow path joins: the compiler then gives it one branch
//! an octet. Where the slow path joined the plain loop, its latch took a second, and an EPYC
//! 9V74 ran the loop at half its speed.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Scan = @import("dfa_config.zig").Scan;

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
    var index = from;
    // `plain_unroll` octets a turn, with one test of the loop for them all: each turn takes them.
    for (0..(haystack.len - from) / plain_unroll) |_| {
        const octets = haystack[index..][0..plain_unroll];
        inline for (octets, 0..) |octet, lane| {
            const entry = table[current +% classes[octet]];
            if (entry >= constants.dfa_flags_min) {
                state.* = current;
                return index + lane;
            }
            current = entry;
        }
        index += plain_unroll;
    }
    // The loop counts the octets it took, and only its exit adds them to `index`.
    for (haystack[index..], 0..) |octet, taken| {
        // A row is under the table's length less a stride, and a class under the stride, so the
        // sum cannot wrap, and the read's bounds check holds it.
        const entry = table[current +% classes[octet]];
        if (entry >= constants.dfa_flags_min) {
            state.* = current;
            return index + taken;
        }
        current = entry;
    }
    state.* = current;
    return haystack.len;
}

/// The octets one turn of `plain`'s loop takes.
const plain_unroll = 4;

/// The offset of the first octet at or after `from` whose entry from `state` is no row, with the
/// match flag or none, or the haystack's length, with `state` moved over the octets before it.
/// A match ends before each octet whose entry had the flag, and `last` becomes the last of them.
/// The loop takes plain rows too: in a text of letters past ASCII, as `\p{L}{8,13}` reads in
/// Russian, a match ends before every second octet, and a loop of flagged rows alone took one.
/// It stops at a plain row that follows `dfa_run_plain_rows_max` others, so that the scan's loops
/// take a long run of them.
pub inline fn matched(table: []const u32, classes: *const Classes, haystack: []const u8, from: usize, state: *u32, last: *usize) usize {
    var current = state.*;
    var ended = last.*;
    var plains: u32 = 0;
    // As in `plain`: the loop counts the octets it took, and the sum of a row and a class cannot
    // wrap.
    for (haystack[from..], 0..) |octet, taken| {
        const entry = table[current +% classes[octet]];
        const plain_row = entry < constants.dfa_flags_min;
        if (!plain_row and !is_matched_row(entry) or plain_row and plains == constants.dfa_run_plain_rows_max) {
            state.* = current;
            last.* = ended;
            return from + taken;
        }
        if (plain_row) {
            plains += 1;
            current = entry;
            continue;
        }
        plains = 0;
        ended = from + taken;
        current = entry - constants.dfa_match_flag;
    }
    state.* = current;
    last.* = ended;
    return haystack.len;
}

/// `matched` for a scan that reads back from `end` toward `from`: the least offset, at or after
/// `from`, from which each octet to `end` has a row, with the match flag or none, read back from
/// `state`. A match starts after each octet whose entry had the flag, and `last` becomes the
/// least such offset.
pub inline fn matched_back(table: []const u32, classes: *const Classes, haystack: []const u8, from: usize, end: usize, state: *u32, last: *usize) usize {
    assert(from <= end and end <= haystack.len);
    var current = state.*;
    var started = last.*;
    var index = end;
    // Each turn takes the octet before `index`, so the turns are at most `end - from`.
    while (index > from) {
        const entry = table[current +% classes[haystack[index - 1]]];
        if (entry < constants.dfa_dead_flag) {
            current = entry;
        } else {
            if (!is_matched_row(entry)) break;
            started = index;
            current = entry - constants.dfa_match_flag;
        }
        index -= 1;
    }
    state.* = current;
    last.* = started;
    return index;
}

/// The scan's answer where the entry of the octet at `at` from `state`, read once a run of
/// matches stopped there, is dead: `flagged` where a match ended at the octet too, and `last`
/// otherwise. Null where the scan goes on. A scan that ends at such an entry then makes no turn
/// of its loop to read it again.
pub inline fn end_of_run(table: []const u32, classes: *const Classes, haystack: []const u8, at: usize, state: u32, last: ?usize, flagged: usize) ?Scan {
    assert(at < haystack.len);
    const entry = table[state +% classes[haystack[at]]];
    // `dfa_unknown` holds the dead flag too: the scan's loop builds the entry not yet built.
    if (entry == constants.dfa_unknown or entry & constants.dfa_dead_flag == 0) return null;
    return Scan.of(if (entry & constants.dfa_match_flag != 0) flagged else last);
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
/// the plain row, and from the plain row to itself; the plain row's other entries are not built.
const test_stride = 3;
const test_match_row = test_stride;
const test_plain_row = test_match_row + test_stride;
const test_table = [_]u32{
    constants.dfa_match_flag | test_match_row, constants.dfa_dead_flag,                            0,
    constants.dfa_match_flag | test_match_row, constants.dfa_match_flag | constants.dfa_dead_flag, test_plain_row,
    constants.dfa_unknown,                     constants.dfa_unknown,                              test_plain_row,
};

/// The classes of the table: an x, a line feed, and every other octet.
const TestClass = enum(u8) { x, line_feed, other };

fn test_classes() Classes {
    var classes: Classes = @splat(@intFromEnum(TestClass.other));
    classes['x'] = @intFromEnum(TestClass.x);
    classes['\n'] = @intFromEnum(TestClass.line_feed);
    return classes;
}

/// Where a run stopped, the state it stopped in and the offset of its last match.
const TestRun = struct { at: usize, state: u32, last: usize };

fn expect_run(expected: TestRun, at: usize, state: u32, last: usize) !void {
    try testing.expectEqual(expected, TestRun{ .at = at, .state = state, .last = last });
}

test "a run of matches takes plain rows too, and stops at an entry that is dead or not built" {
    const classes = test_classes();
    var state: u32 = 0;
    var last: usize = 0;
    var at = matched(&test_table, &classes, "xxx\nx", 0, &state, &last);
    try expect_run(.{ .at = 3, .state = test_match_row, .last = 2 }, at, state, last);
    // A plain row goes on, and the last match stays where it was; from the plain row, the next
    // entry is not built.
    state = 0;
    at = matched(&test_table, &classes, "xxyx", 0, &state, &last);
    try expect_run(.{ .at = 3, .state = test_plain_row, .last = 1 }, at, state, last);
    state = test_plain_row;
    last = 0;
    at = matched(&test_table, &classes, "xx", 1, &state, &last);
    try expect_run(.{ .at = 1, .state = test_plain_row, .last = 0 }, at, state, last);
    state = 0;
    at = matched(&test_table, &classes, "xxxx", 0, &state, &last);
    try expect_run(.{ .at = 4, .state = test_match_row, .last = 3 }, at, state, last);
    // The plain loop stops at the first entry with a flag.
    state = 0;
    try testing.expectEqual(@as(usize, 1), plain(&test_table, &classes, "yxx", 0, &state));
    try testing.expectEqual(@as(u32, 0), state);
}

test "a run of matches stops at a plain row after the plain rows of one UTF-8 sequence" {
    const classes = test_classes();
    var state: u32 = 0;
    var last: usize = 9;
    // The match row, then plain rows from the first `y` on: the run takes three and stops.
    const at = matched(&test_table, &classes, "xyyyyyx", 0, &state, &last);
    try expect_run(.{ .at = 1 + constants.dfa_run_plain_rows_max, .state = test_plain_row, .last = 0 }, at, state, last);
}

/// A table of two rows over the classes of `TestClass`, where a match ends before every second
/// octet, as in a script of two octets a letter: from the match row an x leads to the plain row,
/// and from the plain row a line feed leads back to the match row, with a match.
const test_letter_plain = test_stride;
const test_letter_table = [_]u32{
    test_letter_plain,       constants.dfa_dead_flag,  constants.dfa_dead_flag,
    constants.dfa_dead_flag, constants.dfa_match_flag, constants.dfa_dead_flag,
};

test "a run of matches counts the plain rows of one sequence, not of the run" {
    const classes = test_classes();
    const text = "x\nx\nx\nx\nx\nx\n";
    var state: u32 = 0;
    var last: usize = 0;
    const at = matched(&test_letter_table, &classes, text, 0, &state, &last);
    try expect_run(.{ .at = text.len, .state = 0, .last = text.len - 1 }, at, state, last);
}

test "a run of matches read back takes plain rows too, and stops at its start" {
    const classes = test_classes();
    var state: u32 = 0;
    var last: usize = 9;
    var index = matched_back(&test_table, &classes, "x\nxxx", 0, 5, &state, &last);
    try expect_run(.{ .at = 2, .state = test_match_row, .last = 3 }, index, state, last);
    state = 0;
    index = matched_back(&test_table, &classes, "xxxx", 1, 4, &state, &last);
    try expect_run(.{ .at = 1, .state = test_match_row, .last = 2 }, index, state, last);
    state = 0;
    index = matched_back(&test_table, &classes, "xyxx", 0, 4, &state, &last);
    try expect_run(.{ .at = 1, .state = test_plain_row, .last = 3 }, index, state, last);
    state = 0;
    index = matched_back(&test_table, &classes, "xxx", 0, 3, &state, &last);
    try expect_run(.{ .at = 0, .state = test_match_row, .last = 1 }, index, state, last);
    state = test_plain_row;
    last = 9;
    index = matched_back(&test_table, &classes, "xxx", 0, 3, &state, &last);
    try expect_run(.{ .at = 3, .state = test_plain_row, .last = 9 }, index, state, last);
}

test "the entry after a run gives the scan's answer where it is dead" {
    const classes = test_classes();
    const flagged: usize = 7;
    try testing.expectEqual(Scan{ .found = flagged }, end_of_run(&test_table, &classes, "\n", 0, test_match_row, 2, flagged).?);
    try testing.expectEqual(Scan{ .found = 2 }, end_of_run(&test_table, &classes, "\n", 0, 0, 2, flagged).?);
    try testing.expectEqual(Scan.none, end_of_run(&test_table, &classes, "\n", 0, 0, null, flagged).?);
    try testing.expectEqual(@as(?Scan, null), end_of_run(&test_table, &classes, "x", 0, test_plain_row, 2, flagged));
    try testing.expectEqual(@as(?Scan, null), end_of_run(&test_table, &classes, "y", 0, test_match_row, 2, flagged));
}
