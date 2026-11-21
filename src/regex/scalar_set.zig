//! The scalar values of one character class, as ranges (decision 86): what a bracket expression,
//! an escape such as `\d` and a `.` hold before the compiler writes them as octet ranges.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const ScalarRange = @import("utf8.zig").ScalarRange;

pub const Error = error{ClassTooLarge};

pub const ScalarSet = struct {
    ranges: [constants.class_ranges_max]ScalarRange = undefined,
    len: u32 = 0,

    pub fn add(set: *ScalarSet, lo: u32, hi: u32) Error!void {
        assert(lo <= hi and hi <= constants.scalar_max);
        // RFC 9485 §8: an implementation that takes a regexp from an untrusted source bounds what
        // it costs. A class past `class_ranges_max` ranges is refused.
        if (set.len == constants.class_ranges_max) return error.ClassTooLarge;
        set.ranges[set.len] = .{ .lo = lo, .hi = hi };
        set.len += 1;
    }

    pub fn slice(set: *const ScalarSet) []const ScalarRange {
        return set.ranges[0..set.len];
    }

    /// Orders the ranges and joins those that overlap or touch, so each scalar value is in one
    /// range and no two ranges could be one.
    pub fn normalize(set: *ScalarSet) void {
        if (set.len == 0) return;
        for (1..set.len) |unsorted| {
            var index = unsorted;
            while (index > 0 and set.ranges[index - 1].lo > set.ranges[index].lo) : (index -= 1) {
                std.mem.swap(ScalarRange, &set.ranges[index - 1], &set.ranges[index]);
            }
        }
        var last: u32 = 0;
        for (set.ranges[1..set.len]) |range| {
            if (range.lo <= set.ranges[last].hi + 1) {
                set.ranges[last].hi = @max(set.ranges[last].hi, range.hi);
            } else {
                last += 1;
                set.ranges[last] = range;
            }
        }
        set.len = last + 1;
    }

    /// Replaces a normalized set with every scalar value it does not hold.
    pub fn negate(set: *ScalarSet) Error!void {
        var rest: ScalarSet = .{};
        var uncovered: u32 = 0;
        for (set.slice()) |range| {
            assert(range.lo >= uncovered);
            if (range.lo > uncovered) try rest.add(uncovered, range.lo - 1);
            uncovered = range.hi + 1;
        }
        if (uncovered <= constants.scalar_max) try rest.add(uncovered, constants.scalar_max);
        set.* = rest;
    }

    /// Adds the other case of each ASCII letter the set holds.
    pub fn fold_ascii(set: *ScalarSet) Error!void {
        const len = set.len;
        for (0..len) |index| {
            try set.add_other_case(set.ranges[index], 'a', 'z');
            try set.add_other_case(set.ranges[index], 'A', 'Z');
        }
    }

    /// The letters of one case run in one order with one value of `ascii_case_bit`, so the part of
    /// a range inside them maps to a range of the other case.
    fn add_other_case(set: *ScalarSet, range: ScalarRange, first_letter: u8, last_letter: u8) Error!void {
        const lo = @max(range.lo, first_letter);
        const hi = @min(range.hi, last_letter);
        if (lo <= hi) try set.add(lo ^ constants.ascii_case_bit, hi ^ constants.ascii_case_bit);
    }

    /// True when a range of the set passes U+007F.
    pub fn holds_past_ascii(set: *const ScalarSet) bool {
        for (set.slice()) |range| {
            if (range.hi > constants.one_octet_max) return true;
        }
        return false;
    }
};

const testing = std.testing;

fn expect_ranges(set: *const ScalarSet, expected: []const ScalarRange) !void {
    try testing.expectEqualSlices(ScalarRange, expected, set.slice());
}

test "normalize orders the ranges and joins those that overlap or touch" {
    var set: ScalarSet = .{};
    try set.add('m', 'p');
    try set.add('a', 'c');
    try set.add('d', 'f');
    try set.add('n', 'z');
    try set.add('0', '0');
    set.normalize();
    try expect_ranges(&set, &.{ .{ .lo = '0', .hi = '0' }, .{ .lo = 'a', .hi = 'f' }, .{ .lo = 'm', .hi = 'z' } });
}

test "normalize keeps apart two ranges with a scalar value between them" {
    var set: ScalarSet = .{};
    try set.add('c', 'd');
    try set.add('a', 'a');
    set.normalize();
    try expect_ranges(&set, &.{ .{ .lo = 'a', .hi = 'a' }, .{ .lo = 'c', .hi = 'd' } });
}

test "normalize keeps a range inside another as the outer one" {
    var set: ScalarSet = .{};
    try set.add('a', 'z');
    try set.add('c', 'd');
    set.normalize();
    try expect_ranges(&set, &.{.{ .lo = 'a', .hi = 'z' }});
}

test "negate gives the scalar values between the ranges, and before and after them" {
    var set: ScalarSet = .{};
    try set.add('b', 'c');
    try set.add('x', 'x');
    set.normalize();
    try set.negate();
    try expect_ranges(&set, &.{
        .{ .lo = 0, .hi = 'a' },
        .{ .lo = 'd', .hi = 'w' },
        .{ .lo = 'y', .hi = constants.scalar_max },
    });
    try set.negate();
    try expect_ranges(&set, &.{ .{ .lo = 'b', .hi = 'c' }, .{ .lo = 'x', .hi = 'x' } });
}

test "negate of every scalar value is empty, and of nothing is every scalar value" {
    var set: ScalarSet = .{};
    try set.negate();
    try expect_ranges(&set, &.{.{ .lo = 0, .hi = constants.scalar_max }});
    try set.negate();
    try expect_ranges(&set, &.{});
}

test "fold_ascii adds the other case of the letters alone" {
    var set: ScalarSet = .{};
    try set.add('X', 'c');
    try set.fold_ascii();
    set.normalize();
    // X to Z gain x to z, a to c gain A to C, and the six octets between the cases gain nothing.
    try expect_ranges(&set, &.{ .{ .lo = 'A', .hi = 'C' }, .{ .lo = 'X', .hi = 'c' }, .{ .lo = 'x', .hi = 'z' } });
    var digits: ScalarSet = .{};
    try digits.add('0', '@');
    try digits.add('[', '`');
    try digits.add('{', 0xFF);
    try digits.fold_ascii();
    try testing.expectEqual(@as(u32, 3), digits.len);
}

test "add refuses a range past the class's limit" {
    var set: ScalarSet = .{};
    for (0..constants.class_ranges_max) |index| try set.add(@intCast(2 * index), @intCast(2 * index));
    try testing.expectError(error.ClassTooLarge, set.add(0x1000, 0x1000));
    try testing.expectEqual(@as(u32, constants.class_ranges_max), set.len);
}

test "holds_past_ascii reads the last scalar value of each range" {
    var set: ScalarSet = .{};
    try set.add('a', constants.one_octet_max);
    try testing.expect(!set.holds_past_ascii());
    try set.add('z', constants.one_octet_max + 1);
    try testing.expect(set.holds_past_ascii());
}
