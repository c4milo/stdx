//! The scalar values of one character class, as ranges (decision 86): what a bracket expression,
//! an escape such as `\d` or `\p{Greek}`, and a `.` hold before the compiler writes them as octet
//! ranges.
//!
//! A class is built in one set. Each item adds its ranges at the end, and `fold_from` and
//! `negate_from` change the ranges from the item's first one on alone, so no item needs a set of
//! its own (decision 86 as amended on 2026-11-22).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const unicode = @import("unicode");
const ScalarRange = @import("utf8_ranges.zig").ScalarRange;

pub const Error = error{ClassTooLarge};

/// A class that an escape or a name gives: `\d`, `\s` and `\w`, RE2's named classes such as
/// `[:alpha:]`, and a Unicode property such as `\p{Greek}`.
pub const NamedClass = struct {
    /// The class's ranges, in order and apart.
    ranges: []const ScalarRange,
    /// `\D`, `[:^alpha:]` or `\P{Greek}`: every scalar value the class does not hold.
    negated: bool,
};

pub const ScalarSet = struct {
    /// The storage the ranges are written in, which the caller gives: `class_ranges_max` ranges
    /// at most, and fewer where the caller reads the pattern again in a larger set.
    ranges: []ScalarRange,
    len: u32 = 0,

    pub fn init(ranges: []ScalarRange) ScalarSet {
        assert(ranges.len <= constants.class_ranges_max);
        return .{ .ranges = ranges };
    }

    pub fn add(set: *ScalarSet, lo: u32, hi: u32) Error!void {
        assert(lo <= hi and hi <= constants.scalar_max);
        // RFC 9485 §8: an implementation that takes a regexp from an untrusted source bounds what
        // it costs. A class past the set's ranges is refused. `compile` then reads the pattern
        // again in a set of `class_ranges_max` ranges, and refuses a class past those.
        if (set.len == set.ranges.len) return error.ClassTooLarge;
        set.ranges[set.len] = .{ .lo = lo, .hi = hi };
        set.len += 1;
    }

    pub fn slice(set: *const ScalarSet) []const ScalarRange {
        return set.ranges[0..set.len];
    }

    /// Adds ranges that are in order and apart, or with `negated` every scalar value they do not
    /// hold.
    pub fn add_ranges(set: *ScalarSet, ranges: []const ScalarRange, negated: bool) Error!void {
        if (!negated) {
            for (ranges) |range| try set.add(range.lo, range.hi);
            return;
        }
        var uncovered: u32 = 0;
        for (ranges) |range| {
            assert(range.lo >= uncovered);
            if (range.lo > uncovered) try set.add(uncovered, range.lo - 1);
            uncovered = range.hi + 1;
        }
        if (uncovered <= constants.scalar_max) try set.add(uncovered, constants.scalar_max);
    }

    /// Adds the range from `lo` to `hi`, and with `fold` each scalar value that matches one of its
    /// own without case.
    pub fn add_folded(set: *ScalarSet, lo: u32, hi: u32, fold: bool) Error!void {
        const start = set.len;
        try set.add(lo, hi);
        if (fold) try set.fold_from(start);
    }

    /// Adds a named class. With `fold`, the class is folded before it is negated, and apart from
    /// the items before it: `(?i)[\W]` holds no `k`, though the Kelvin sign is no word character.
    /// Go's regexp folds each item of a class this way.
    pub fn add_named(set: *ScalarSet, named: NamedClass, fold: bool) Error!void {
        if (!fold) return set.add_ranges(named.ranges, named.negated);
        const start = set.len;
        try set.add_ranges(named.ranges, false);
        try set.fold_from(start);
        if (named.negated) try set.negate_from(start);
    }

    /// Orders the ranges and joins those that overlap or touch, so each scalar value is in one
    /// range and no two ranges could be one.
    pub fn normalize(set: *ScalarSet) void {
        set.normalize_from(0);
    }

    /// `normalize` over the ranges from `start` on. The ranges before `start` stay as they are.
    pub fn normalize_from(set: *ScalarSet, start: u32) void {
        assert(start <= set.len);
        if (set.len - start <= 1) return;
        const part = set.ranges[start..set.len];
        std.mem.sort(ScalarRange, part, {}, lower_first);
        var last: u32 = 0;
        for (part[1..]) |range| {
            if (range.lo <= part[last].hi + 1) {
                part[last].hi = @max(part[last].hi, range.hi);
                continue;
            }
            last += 1;
            part[last] = range;
        }
        set.len = start + last + 1;
    }

    /// Replaces a normalized set with every scalar value it does not hold.
    pub fn negate(set: *ScalarSet) Error!void {
        return set.negate_from(0);
    }

    /// `negate` over the normalized ranges from `start` on, in place.
    pub fn negate_from(set: *ScalarSet, start: u32) Error!void {
        assert(start <= set.len);
        const count = set.len - start;
        if (count == 0) return set.add(0, constants.scalar_max);
        const before = set.ranges[start].lo > 0;
        const after = set.ranges[set.len - 1].hi < constants.scalar_max;
        const negated_count = count - 1 + @intFromBool(before) + @intFromBool(after);
        // RFC 9485 §8: an implementation that takes a regexp from an untrusted source bounds what
        // it costs. A class past the set's ranges is refused. `compile` then reads the pattern
        // again in a set of `class_ranges_max` ranges, and refuses a class past those.
        if (start + negated_count > set.ranges.len) return error.ClassTooLarge;
        if (before) set.negate_after_gap(start, count, after) else set.negate_from_zero(start, count, after);
        set.len = start + negated_count;
    }

    /// The negation of ranges whose first starts past 0: the gap before the first range comes
    /// first, so each gap goes one place up, written from the last. Each store reads its values
    /// first, since a struct literal writes its fields in place one at a time.
    fn negate_after_gap(set: *ScalarSet, start: u32, count: u32, after: bool) void {
        const ranges = set.ranges[start..];
        if (after) ranges[count] = gap(ranges[count - 1].hi + 1, constants.scalar_max);
        var index = count - 1;
        while (index > 0) : (index -= 1) ranges[index] = gap(ranges[index - 1].hi + 1, ranges[index].lo - 1);
        ranges[0] = gap(0, ranges[0].lo - 1);
    }

    /// The negation of ranges whose first starts at 0: each gap takes the place of the range
    /// before it, written from the first.
    fn negate_from_zero(set: *ScalarSet, start: u32, count: u32, after: bool) void {
        const ranges = set.ranges[start..];
        for (0..count - 1) |index| ranges[index] = gap(ranges[index].hi + 1, ranges[index + 1].lo - 1);
        if (after) ranges[count - 1] = gap(ranges[count - 1].hi + 1, constants.scalar_max);
    }

    /// Adds to the normalized ranges from `start` on each scalar value that matches one of theirs
    /// without case, and normalizes them again: the simple case folding of UTS #18 RL1.5, whose
    /// orbits `unicode.images` gives. A pass adds the next code point of each orbit, so
    /// `orbit_len_max - 1` passes hold each orbit whole.
    pub fn fold_from(set: *ScalarSet, start: u32) Error!void {
        assert(start <= set.len);
        for (1..unicode.constants.orbit_len_max) |_| {
            const end = set.len;
            for (start..end) |index| {
                var images = unicode.images(set.ranges[index].lo, set.ranges[index].hi);
                while (images.next()) |image| {
                    if (!holds(set.ranges[start..end], image)) try set.add(image.lo, image.hi);
                }
            }
            if (set.len == end) return;
            set.normalize_from(start);
        }
    }
};

/// A range from values read before the store: a call's arguments are values, where a struct
/// literal's fields could read the place it writes.
fn gap(lo: u32, hi: u32) ScalarRange {
    assert(lo <= hi);
    return .{ .lo = lo, .hi = hi };
}

fn lower_first(_: void, left: ScalarRange, right: ScalarRange) bool {
    return left.lo < right.lo;
}

/// Whether one of ranges that are in order and apart holds all of `range`.
fn holds(ranges: []const ScalarRange, range: ScalarRange) bool {
    const index = std.sort.partitionPoint(ScalarRange, ranges, range.lo, ends_below);
    return index < ranges.len and ranges[index].lo <= range.lo and range.hi <= ranges[index].hi;
}

fn ends_below(lo: u32, range: ScalarRange) bool {
    return range.hi < lo;
}

const testing = std.testing;

fn expect_ranges(set: *const ScalarSet, expected: []const ScalarRange) !void {
    try testing.expectEqualSlices(ScalarRange, expected, set.slice());
}

test "normalize orders the ranges and joins those that overlap or touch" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add('m', 'p');
    try set.add('a', 'c');
    try set.add('d', 'f');
    try set.add('n', 'z');
    try set.add('0', '0');
    set.normalize();
    try expect_ranges(&set, &.{ .{ .lo = '0', .hi = '0' }, .{ .lo = 'a', .hi = 'f' }, .{ .lo = 'm', .hi = 'z' } });
}

test "normalize keeps apart two ranges with a scalar value between them" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add('c', 'd');
    try set.add('a', 'a');
    set.normalize();
    try expect_ranges(&set, &.{ .{ .lo = 'a', .hi = 'a' }, .{ .lo = 'c', .hi = 'd' } });
}

test "normalize keeps a range inside another as the outer one" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add('a', 'z');
    try set.add('c', 'd');
    set.normalize();
    try expect_ranges(&set, &.{.{ .lo = 'a', .hi = 'z' }});
}

test "normalize_from leaves the ranges before its start as they are" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add('x', 'z');
    try set.add('c', 'd');
    try set.add('a', 'b');
    set.normalize_from(1);
    try expect_ranges(&set, &.{ .{ .lo = 'x', .hi = 'z' }, .{ .lo = 'a', .hi = 'd' } });
}

test "negate gives the scalar values between the ranges, and before and after them" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
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

test "negate of ranges at either end of the codespace gives no range past them" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add(0, 'a');
    try set.add('m', 'n');
    try set.add('x', constants.scalar_max);
    try set.negate();
    try expect_ranges(&set, &.{ .{ .lo = 'b', .hi = 'l' }, .{ .lo = 'o', .hi = 'w' } });
    var first_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var first = ScalarSet.init(&first_storage);
    try first.add(0, 'a');
    try first.negate();
    try expect_ranges(&first, &.{.{ .lo = 'b', .hi = constants.scalar_max }});
}

test "negate of every scalar value is empty, and of nothing is every scalar value" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.negate();
    try expect_ranges(&set, &.{.{ .lo = 0, .hi = constants.scalar_max }});
    try set.negate();
    try expect_ranges(&set, &.{});
}

test "negate_from negates the ranges from its start on alone" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add('a', 'a');
    try set.add('m', 'p');
    try set.negate_from(1);
    try expect_ranges(&set, &.{ .{ .lo = 'a', .hi = 'a' }, .{ .lo = 0, .hi = 'l' }, .{ .lo = 'q', .hi = constants.scalar_max } });
}

test "negate refuses a negation past the class's limit, and keeps the set" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    for (0..constants.class_ranges_max) |index| try set.add(@intCast(2 * index + 1), @intCast(2 * index + 1));
    try testing.expectError(error.ClassTooLarge, set.negate());
    try testing.expectEqual(@as(u32, constants.class_ranges_max), set.len);
    try testing.expectEqual(@as(u32, 1), set.ranges[0].lo);
}

test "add_ranges adds ranges, or every scalar value they do not hold" {
    const ranges = [_]ScalarRange{ .{ .lo = 'a', .hi = 'c' }, .{ .lo = 'x', .hi = 'z' } };
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add_ranges(&ranges, false);
    try expect_ranges(&set, &ranges);
    var rest_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var rest = ScalarSet.init(&rest_storage);
    try rest.add_ranges(&ranges, true);
    try expect_ranges(&rest, &.{ .{ .lo = 0, .hi = '`' }, .{ .lo = 'd', .hi = 'w' }, .{ .lo = '{', .hi = constants.scalar_max } });
    var none_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var none = ScalarSet.init(&none_storage);
    try none.add_ranges(&.{.{ .lo = 0, .hi = constants.scalar_max }}, true);
    try expect_ranges(&none, &.{});
}

test "fold_from adds each scalar value's whole orbit, and nothing to a range with none" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add('k', 'k');
    try set.fold_from(0);
    // k's orbit holds K, k and the Kelvin sign.
    try expect_ranges(&set, &.{ .{ .lo = 'K', .hi = 'K' }, .{ .lo = 'k', .hi = 'k' }, .{ .lo = 0x212A, .hi = 0x212A } });
    var iota_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var iota = ScalarSet.init(&iota_storage);
    // U+0345 folds to ι, whose orbit holds four: the last pass reaches U+1FBE.
    try iota.add(0x345, 0x345);
    try iota.fold_from(0);
    try expect_ranges(&iota, &.{ .{ .lo = 0x345, .hi = 0x345 }, .{ .lo = 0x399, .hi = 0x399 }, .{ .lo = 0x3B9, .hi = 0x3B9 }, .{ .lo = 0x1FBE, .hi = 0x1FBE } });
    var digits_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var digits = ScalarSet.init(&digits_storage);
    try digits.add('0', '9');
    try digits.fold_from(0);
    try expect_ranges(&digits, &.{.{ .lo = '0', .hi = '9' }});
}

test "fold_from folds the ranges from its start on alone" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add('a', 'a');
    try set.add(0x101, 0x102);
    try set.fold_from(1);
    // ā and Ă are pairs with Ā and ă: from U+0100 to U+0103.
    try expect_ranges(&set, &.{ .{ .lo = 'a', .hi = 'a' }, .{ .lo = 0x100, .hi = 0x103 } });
}

test "add_named folds a negated class before it negates it" {
    const word = NamedClass{ .ranges = &.{ .{ .lo = '0', .hi = '9' }, .{ .lo = 'A', .hi = 'Z' }, .{ .lo = '_', .hi = '_' }, .{ .lo = 'a', .hi = 'z' } }, .negated = true };
    var folded_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var folded = ScalarSet.init(&folded_storage);
    try folded.add_named(word, true);
    // \w folds to hold ſ and the Kelvin sign, so its negation holds neither, nor any letter.
    for ([_]u32{ 'k', 'K', 's', 0x17F, 0x212A }) |scalar| try testing.expect(!holds(folded.slice(), .{ .lo = scalar, .hi = scalar }));
    try testing.expect(holds(folded.slice(), .{ .lo = '-', .hi = '-' }));
    var plain_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var plain = ScalarSet.init(&plain_storage);
    try plain.add_named(word, false);
    try testing.expect(holds(plain.slice(), .{ .lo = 0x212A, .hi = 0x212A }));
}

test "add_folded adds a range and its orbits, or the range alone" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try set.add_folded('0', '0', true);
    try set.add_folded('s', 's', true);
    try expect_ranges(&set, &.{ .{ .lo = '0', .hi = '0' }, .{ .lo = 'S', .hi = 'S' }, .{ .lo = 's', .hi = 's' }, .{ .lo = 0x17F, .hi = 0x17F } });
    var plain_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var plain = ScalarSet.init(&plain_storage);
    try plain.add_folded('s', 's', false);
    try expect_ranges(&plain, &.{.{ .lo = 's', .hi = 's' }});
}

/// One bit for each code point: those an orbit took.
const Taken = std.bit_set.StaticBitSet(constants.scalar_max + 1);

/// Whether `code_point` is the first code point of an orbit of two or more.
fn first_of_orbit(code_point: u32) bool {
    var member = unicode.simple_fold(code_point);
    if (member == code_point) return false;
    for (0..unicode.constants.orbit_len_max) |_| {
        if (member < code_point) return false;
        member = unicode.simple_fold(member);
        if (member == code_point) return true;
    }
    unreachable;
}

/// Whether a code point of the orbit from `first` touches one of `taken`.
fn orbit_touches(taken: *const Taken, first: u32) bool {
    var member = first;
    for (0..unicode.constants.orbit_len_max) |_| {
        if ((member > 0 and taken.isSet(member - 1)) or (member < constants.scalar_max and taken.isSet(member + 1))) return true;
        member = unicode.simple_fold(member);
        if (member == first) return false;
    }
    unreachable;
}

fn add_orbit(set: *ScalarSet, taken: *Taken, first: u32) Error!void {
    var member = first;
    for (0..unicode.constants.orbit_len_max) |_| {
        taken.set(member);
        try set.add(member, member);
        member = unicode.simple_fold(member);
        if (member == first) return;
    }
}

test "fold_from adds nothing to whole orbits, though they hold most of the set's room" {
    // Each orbit whose code points touch none taken before, whole: no fold adds a range to them.
    // A fold that added each range's images though the set held them would pass the limit.
    var taken = Taken.initEmpty();
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    var code_point: u32 = 0;
    while (code_point <= constants.scalar_max) : (code_point += 1) {
        if (first_of_orbit(code_point) and !orbit_touches(&taken, code_point)) try add_orbit(&set, &taken, code_point);
    }
    set.normalize();
    const len = set.len;
    try testing.expect(len > constants.class_ranges_max / 2);
    try set.fold_from(0);
    try testing.expectEqual(len, set.len);
}

test "add refuses a range past the class's limit" {
    var set_storage: [constants.class_ranges_max]ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    for (0..constants.class_ranges_max) |index| try set.add(@intCast(2 * index), @intCast(2 * index));
    try testing.expectError(error.ClassTooLarge, set.add(0x10000, 0x10000));
    try testing.expectEqual(@as(u32, constants.class_ranges_max), set.len);
}
