//! The octets a match can start with, and the search for the next one (decision 86, claim R1).
//!
//! A lazy DFA that waits for a match to start takes each octet that cannot start one and stays
//! where it is. `Skip` finds the next octet that can, with no read of the DFA's table: a few
//! octets one at a time, then `skip_lanes` octets a step, where at most `skip_ranges_max` ranges
//! hold every such octet. A pattern that starts with a literal, with one of a few letters or
//! with a class of a few ranges has such ranges. The DFA then reads its table from that octet
//! on, so the answer is the one it gives with no skip.
//!
//! A skip pays where the octets that can start a match are far apart. Where they are close, as
//! the letters of `[a-z]+ing` are in prose, each visit to the state that waits passes few octets
//! and costs a branch the CPU cannot predict. The DFA counts both and turns its skip off there
//! (`skip_trial_visits`, `skip_octets_per_visit_min`), and tries it again after
//! `skip_rest_octets`, since a text's parts differ.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const lane_places = @import("../lane_places.zig");

/// The octets from `lo` on, `span` more than one of them.
pub const Range = struct { lo: u8, span: u8 };

const Lanes = @Vector(constants.skip_lanes, u8);
const Step = lane_places.Places(constants.skip_lanes);

/// A set of octets as at most `skip_ranges_max` ranges, which a step judges `skip_lanes` octets
/// against (claims R1 and R9).
pub const Ranges = struct {
    /// The ranges. A range that is not used repeats the first.
    ranges: [constants.skip_ranges_max]Range,
    /// True when the ranges hold every octet of the set, so a step may judge `skip_lanes` octets.
    whole: bool,
    /// The ranges in use, from 1 to `skip_ranges_max` where the ranges are whole.
    count: u8 = 0,

    pub fn of(set: *const [constants.octet_values]bool) Ranges {
        var ranges: Ranges = .{ .ranges = undefined, .whole = true };
        var count: usize = 0;
        var octet: usize = 0;
        while (octet < constants.octet_values) {
            if (!set[octet]) {
                octet += 1;
                continue;
            }
            const lo = octet;
            while (octet < constants.octet_values and set[octet]) octet += 1;
            if (count < constants.skip_ranges_max) ranges.ranges[count] = .{ .lo = @intCast(lo), .span = @intCast(octet - 1 - lo) };
            count += 1;
        }
        ranges.whole = count > 0 and count <= constants.skip_ranges_max;
        if (ranges.whole) {
            @memset(ranges.ranges[count..], ranges.ranges[0]);
            ranges.count = @intCast(count);
        }
        return ranges;
    }

    /// The first offset at or after `from` whose octet is in a range, where a whole step of
    /// `skip_lanes` octets holds it, or the offset of the first step that does not fit. A set of
    /// one or two ranges judges each step by those alone, and not by a range repeated.
    pub fn first(ranges: *const Ranges, haystack: []const u8, from: usize) usize {
        assert(ranges.whole);
        inline for (1..constants.skip_ranges_max) |count| {
            if (ranges.count == count) return first_by(count, ranges, haystack, from);
        }
        return first_by(constants.skip_ranges_max, ranges, haystack, from);
    }

    /// `first` for `count` ranges. A turn of `skip_steps` steps judges them all and takes one
    /// branch: a text whose start octets are far apart costs one branch for each turn. The steps
    /// then find the first octet in the turn that holds one, and judge the octets after a turn.
    fn first_by(comptime count: usize, ranges: *const Ranges, haystack: []const u8, from: usize) usize {
        assert(count <= constants.skip_ranges_max);
        const turn_len = constants.skip_steps * constants.skip_lanes;
        var index = from;
        while (haystack.len - index >= turn_len) : (index += turn_len) {
            var any: Lanes = @splat(0);
            inline for (0..constants.skip_steps) |step| any |= ranges.lanes_in(count, haystack[index + step * constants.skip_lanes ..][0..constants.skip_lanes].*);
            if (Step.any(any)) break;
        }
        while (haystack.len - index >= constants.skip_lanes) : (index += constants.skip_lanes) {
            const hits = ranges.lanes_in(count, haystack[index..][0..constants.skip_lanes].*);
            if (Step.any(hits)) return index + Step.first(Step.of(hits));
        }
        return index;
    }

    /// All ones in each lane whose octet is in one of the first `count` ranges, and zero in the
    /// others.
    inline fn lanes_in(ranges: *const Ranges, comptime count: usize, octets: Lanes) Lanes {
        var in_range: @Vector(constants.skip_lanes, bool) = @splat(false);
        // An octet is in a range when its distance from the range's first octet, as an unsigned
        // number, is at most the range's span.
        inline for (0..count) |range| {
            const lo: Lanes = @splat(ranges.ranges[range].lo);
            const span: Lanes = @splat(ranges.ranges[range].span);
            in_range = @select(bool, octets -% lo <= span, @as(@Vector(constants.skip_lanes, bool), @splat(true)), in_range);
        }
        return @select(u8, in_range, @as(Lanes, @splat(constants.octet_max)), @as(Lanes, @splat(0)));
    }
};

pub const Skip = struct {
    /// True for each octet a match can start with.
    starts: [constants.octet_values]bool,
    /// The octets a match can start with, as ranges.
    ranges: Ranges,

    pub fn init(starts: *const [constants.octet_values]bool) Skip {
        return .{ .starts = starts.*, .ranges = Ranges.of(starts) };
    }

    /// The first offset at or after `from` whose octet can start a match, or the haystack's
    /// length where none is left.
    pub fn next(skip: *const Skip, haystack: []const u8, from: usize) usize {
        assert(from <= haystack.len);
        // A dense set, such as the letters in prose, ends most skips within a few octets, where
        // a step of `skip_lanes` octets would cost more than it saves.
        const near = @min(haystack.len, from + constants.skip_scalar_run);
        for (haystack[from..near], from..) |octet, index| {
            if (skip.starts[octet]) return index;
        }
        const far = if (skip.ranges.whole) skip.ranges.first(haystack, near) else near;
        for (haystack[far..], far..) |octet, index| {
            if (skip.starts[octet]) return index;
        }
        return haystack.len;
    }
};

const testing = std.testing;
const Generator = @import("codec").testing.split.Generator;

fn starts_of(octets: []const u8) [constants.octet_values]bool {
    var starts: [constants.octet_values]bool = @splat(false);
    for (octets) |octet| starts[octet] = true;
    return starts;
}

/// The first start octet at or after `from`, one octet at a time: what `next` must give.
fn next_plain(starts: *const [constants.octet_values]bool, haystack: []const u8, from: usize) usize {
    for (haystack[from..], from..) |octet, index| {
        if (starts[octet]) return index;
    }
    return haystack.len;
}

test "init gives the start octets as ranges where three hold them" {
    const one = Skip.init(&starts_of("P"));
    try testing.expect(one.ranges.whole);
    try testing.expectEqual(@as(u8, 1), one.ranges.count);
    try testing.expectEqual(Range{ .lo = 'P', .span = 0 }, one.ranges.ranges[0]);
    try testing.expectEqual(one.ranges.ranges[0], one.ranges.ranges[2]);
    const letters = Skip.init(&starts_of("AIJpqr"));
    try testing.expect(letters.ranges.whole);
    try testing.expectEqualSlices(Range, &.{ .{ .lo = 'A', .span = 0 }, .{ .lo = 'I', .span = 1 }, .{ .lo = 'p', .span = 2 } }, &letters.ranges.ranges);
    try testing.expectEqual(@as(u8, 3), letters.ranges.count);
    const four = Skip.init(&starts_of("aceg"));
    try testing.expect(!four.ranges.whole);
    const edges = Skip.init(&starts_of("\x00\xFF"));
    try testing.expectEqualSlices(Range, &.{ .{ .lo = 0, .span = 0 }, .{ .lo = 0xFF, .span = 0 }, .{ .lo = 0, .span = 0 } }, &edges.ranges.ranges);
    try testing.expectEqual(@as(u8, 2), edges.ranges.count);
    const none = Skip.init(&starts_of(""));
    try testing.expect(!none.ranges.whole);
    const every: [constants.octet_values]bool = @splat(true);
    const all = Skip.init(&every);
    try testing.expect(all.ranges.whole);
    try testing.expectEqual(Range{ .lo = 0, .span = 0xFF }, all.ranges.ranges[0]);
}

/// Fills a haystack with octets that start nothing and `count` octets of `set` at places a seed
/// draws, so that skips of each length are taken: none, one in the first lanes, one in a later
/// step, and one in the last octets.
fn scatter(generator: *Generator, haystack: []u8, set: []const u8, count: usize) void {
    @memset(haystack, 'x');
    if (set.len == 0) return;
    for (0..count) |_| haystack[generator.below(haystack.len)] = set[generator.below(set.len)];
}

test "next gives the first start octet from every offset, as a walk of one octet at a time gives it" {
    var haystack: [200]u8 = undefined;
    var generator = Generator.init(0x5C1B);
    const sets = [_][]const u8{ "P", "AIJ", "0123456789", "aceg", "\x00\xFF", "", "Pp\xC3" };
    for (sets) |set| {
        const starts = starts_of(set);
        const skip = Skip.init(&starts);
        for (0..64) |round| {
            scatter(&generator, &haystack, set, round % 4);
            const len = generator.below(haystack.len + 1);
            for (0..len + 1) |from| {
                try testing.expectEqual(next_plain(&starts, haystack[0..len], from), skip.next(haystack[0..len], from));
            }
        }
    }
}

test "next judges each octet of a step by its own range" {
    const skip = Skip.init(&starts_of("0123456789"));
    // A turn of `skip_steps` steps, then a step: each place of a turn and of a step after it.
    var haystack: [(constants.skip_steps + 1) * constants.skip_lanes + constants.skip_scalar_run]u8 = undefined;
    // The octets beside a range's ends are not in it: one below its first and one above its last.
    for (&haystack, 0..) |*octet, index| octet.* = if (index % 2 == 0) '/' else ':';
    try testing.expectEqual(haystack.len, skip.next(&haystack, 0));
    for (constants.skip_scalar_run..haystack.len) |at| {
        haystack[at] = '0';
        try testing.expectEqual(at, skip.next(&haystack, 0));
        haystack[at] = '9';
        try testing.expectEqual(at, skip.next(&haystack, 0));
        haystack[at] = '/';
    }
}
