//! The check that ties `utf8_ranges.Splitter` to the definitions spec/lean/Stdx/Regex/Utf8.lean proves
//! (decisions 28 and 86). `sequences_iff` there says the sequences of a range hold the UTF-8 of
//! each scalar value of the range and nothing else. This test requires the Zig splitter to give
//! the same sequences, in the same order, for each range of utf8_split_vectors.txt, which
//! spec/lean/Vectors.lean writes from those definitions.
const std = @import("std");
const testing = std.testing;
const utf8_ranges = @import("utf8_ranges.zig");

const vectors = @embedFile("utf8_split_vectors.txt");
const radix = 10;

/// The ranges the file holds: every pair of its 35 scalar values, the first at most the last.
const ranges_expected = 630;

/// The next number of a line, up to `end`, which the line then starts after.
fn take_number(comptime T: type, line: *[]const u8, end: u8) !T {
    const len = std.mem.findScalar(u8, line.*, end) orelse line.len;
    const number = try std.fmt.parseInt(T, line.*[0..len], radix);
    line.* = line.*[@min(len + 1, line.len)..];
    return number;
}

/// One sequence of a line, after its bar: `first-last` for each octet, a space between.
fn expect_sequence(text: []const u8, sequence: utf8_ranges.Sequence) !void {
    var rest = std.mem.trim(u8, text, " ");
    for (sequence.ranges[0..sequence.len]) |range| {
        try testing.expectEqual(range.lo, try take_number(u8, &rest, '-'));
        try testing.expectEqual(range.hi, try take_number(u8, &rest, ' '));
    }
    try testing.expectEqual(@as(usize, 0), rest.len);
}

fn expect_line(line: []const u8) !void {
    var parts = std.mem.splitScalar(u8, line, '|');
    var range = std.mem.trim(u8, parts.first(), " ");
    const lo = try take_number(u32, &range, ' ');
    const hi = try take_number(u32, &range, ' ');
    var splitter = utf8_ranges.Splitter.init(lo, hi);
    while (parts.next()) |text| {
        const sequence = splitter.next() orelse return error.TestSequenceMissing;
        try expect_sequence(text, sequence);
    }
    try testing.expectEqual(@as(?utf8_ranges.Sequence, null), splitter.next());
}

test "the splitter gives the sequences the proved definitions give, for each range of the vectors" {
    var lines = std.mem.tokenizeScalar(u8, vectors, '\n');
    var ranges: usize = 0;
    while (lines.next()) |line| {
        if (line[0] == '#') continue;
        try expect_line(line);
        ranges += 1;
    }
    try testing.expectEqual(@as(usize, ranges_expected), ranges);
}
