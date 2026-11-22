//! The simple case folding, as each code point's next code point in its case orbit.
//!
//! UTS #18 RL1.5 asks a regular expression that matches without case for the simple case folding,
//! the lines of CaseFolding.txt of status C and S. Two code points match under it when they fold to
//! one code point, and the code points that fold to one make an orbit. `simple_fold` gives the next
//! code point of an orbit in ascending order, and the first after the last, so it walks each orbit
//! in a cycle of at most `orbit_len_max` steps. `images` gives the next code points of a range's
//! code points as ranges, for a caller that folds a set of ranges.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const entries = @import("entries.zig");
const tables = @import("unicode_tables.zig");
const Range = entries.Range;
const FoldRun = entries.FoldRun;

/// The next code point of `code_point`'s case orbit, or `code_point` when its orbit holds it alone.
pub fn simple_fold(code_point: u32) u32 {
    assert(code_point <= constants.code_point_max);
    const index = first_run(code_point);
    if (index == tables.fold_runs.len or tables.fold_runs[index].lo > code_point) return code_point;
    return next_in(tables.fold_runs[index], code_point);
}

/// The ranges that hold the next code point of each code point from `lo` to `hi`, one range a call
/// of `next`. A range may also hold code points from `lo` to `hi`, so a caller adds each to a set
/// that holds them.
pub fn images(lo: u32, hi: u32) Images {
    assert(lo <= hi and hi <= constants.code_point_max);
    return .{ .lo = lo, .hi = hi, .index = first_run(lo) };
}

pub const Images = struct {
    lo: u32,
    hi: u32,
    /// The next run of `tables.fold_runs` to read.
    index: usize,

    /// The next range, or null after the last. Each call reads one run of the tables.
    pub fn next(found: *Images) ?Range {
        if (found.index == tables.fold_runs.len) return null;
        const run = tables.fold_runs[found.index];
        if (run.lo > found.hi) return null;
        found.index += 1;
        const lo = @max(run.lo, found.lo);
        const hi = @min(run.hi, found.hi);
        assert(lo <= hi);
        return switch (run.step) {
            .offset => .{ .lo = next_in(run, lo), .hi = next_in(run, hi) },
            // A pair's two code points go to each other, so the pairs that `lo` to `hi` touch are
            // the code points and their next ones.
            .pairs => .{ .lo = run.lo + ((lo - run.lo) & ~@as(u32, 1)), .hi = run.lo + ((hi - run.lo) | 1) },
        };
    }
};

/// The index of the first run that reaches `code_point`, or the runs' count.
fn first_run(code_point: u32) usize {
    return std.sort.partitionPoint(FoldRun, &tables.fold_runs, code_point, ends_below);
}

fn ends_below(code_point: u32, run: FoldRun) bool {
    return run.hi < code_point;
}

fn next_in(run: FoldRun, code_point: u32) u32 {
    assert(run.lo <= code_point and code_point <= run.hi);
    return switch (run.step) {
        .offset => |offset| @intCast(@as(i64, code_point) + offset),
        .pairs => if ((code_point - run.lo) & 1 == 0) code_point + 1 else code_point - 1,
    };
}

// Tests.

const testing = std.testing;

test "simple_fold walks each orbit in ascending order and back to its first code point" {
    const orbits = [_][]const u32{
        &.{ 'A', 'a' },
        // The Kelvin sign folds to k, as K does.
        &.{ 'K', 'k', 0x212A },
        // The capital sharp s folds to the small one under status S.
        &.{ 0xDF, 0x1E9E },
        &.{ 0x345, 0x399, 0x3B9, 0x1FBE },
        &.{ 0x100, 0x101 },
        // Cherokee's small letters fold to its capitals, which come first.
        &.{ 0x13A0, 0xAB70 },
    };
    for (orbits) |orbit| {
        for (orbit, 0..) |code_point, index| try testing.expectEqual(orbit[(index + 1) % orbit.len], simple_fold(code_point));
    }
    // A code point no folding names is its orbit alone, the first and the last of the codespace too.
    for ([_]u32{ '1', 0x130, 0, constants.code_point_max }) |code_point| try testing.expectEqual(code_point, simple_fold(code_point));
}

test "every orbit is a cycle in ascending order of at most orbit_len_max code points" {
    var largest: usize = 0;
    var code_point: u32 = 0;
    while (code_point <= constants.code_point_max) : (code_point += 1) {
        var len: usize = 1;
        var current = simple_fold(code_point);
        var wraps: usize = @intFromBool(current < code_point);
        while (current != code_point) : (len += 1) {
            try testing.expect(len < constants.orbit_len_max);
            const next = simple_fold(current);
            wraps += @intFromBool(next < current);
            current = next;
        }
        // A cycle in ascending order goes down once, from its last code point to its first.
        try testing.expectEqual(@intFromBool(len > 1), wraps);
        largest = @max(largest, len);
    }
    try testing.expectEqual(constants.orbit_len_max, largest);
}

test "images of each code point hold its next code point, and no code point past the two" {
    var code_point: u32 = 0;
    while (code_point <= constants.code_point_max) : (code_point += 1) {
        var found = images(code_point, code_point);
        var next_held = simple_fold(code_point) == code_point;
        while (found.next()) |range| {
            for ([_]u32{ range.lo, range.hi }) |end| try testing.expect(end == code_point or end == simple_fold(code_point));
            next_held = next_held or (range.lo <= simple_fold(code_point) and simple_fold(code_point) <= range.hi);
        }
        try testing.expect(next_held);
    }
}

test "images of a range give one range for each run it meets" {
    var letters = images('A', 'z');
    try testing.expectEqual(Range{ .lo = 'a', .hi = 'z' }, letters.next().?);
    // k's run is its own: its next code point is the Kelvin sign.
    try testing.expectEqual(Range{ .lo = 'A', .hi = 'J' }, letters.next().?);
    try testing.expectEqual(Range{ .lo = 0x212A, .hi = 0x212A }, letters.next().?);
    try testing.expectEqual(Range{ .lo = 'L', .hi = 'R' }, letters.next().?);
    // From 0x101 to 0x104 the pairs run from 0x100 to 0x105.
    var pairs = images(0x101, 0x104);
    try testing.expectEqual(Range{ .lo = 0x100, .hi = 0x105 }, pairs.next().?);
    try testing.expectEqual(null, pairs.next());
    var none = images('0', '9');
    try testing.expectEqual(null, none.next());
}
