//! The classes a bracket expression names as `[:name:]` (decision 86). RFC 9485 §3 holds no such
//! form: it is RE2's, with RE2's fourteen names, each a set of ASCII characters.
const std = @import("std");
const errors = @import("errors.zig");
const ScalarSet = @import("scalar_set.zig").ScalarSet;
const ScalarRange = @import("utf8_ranges.zig").ScalarRange;

/// The longest name: `xdigit` and its like have six letters.
pub const name_len_max = 6;

const Entry = struct {
    name: []const u8,
    ranges: []const ScalarRange,
};

fn r(lo: u8, hi: u8) ScalarRange {
    return .{ .lo = lo, .hi = hi };
}

/// Each name and the ASCII characters it holds, as RE2's syntax lists them.
const entries = [_]Entry{
    .{ .name = "alnum", .ranges = &.{ r('0', '9'), r('A', 'Z'), r('a', 'z') } },
    .{ .name = "alpha", .ranges = &.{ r('A', 'Z'), r('a', 'z') } },
    .{ .name = "ascii", .ranges = &.{r('\x00', '\x7F')} },
    .{ .name = "blank", .ranges = &.{ r('\t', '\t'), r(' ', ' ') } },
    .{ .name = "cntrl", .ranges = &.{ r('\x00', '\x1F'), r('\x7F', '\x7F') } },
    .{ .name = "digit", .ranges = &.{r('0', '9')} },
    .{ .name = "graph", .ranges = &.{r('!', '~')} },
    .{ .name = "lower", .ranges = &.{r('a', 'z')} },
    .{ .name = "print", .ranges = &.{r(' ', '~')} },
    .{ .name = "punct", .ranges = &.{ r('!', '/'), r(':', '@'), r('[', '`'), r('{', '~') } },
    .{ .name = "space", .ranges = &.{ r('\t', '\r'), r(' ', ' ') } },
    .{ .name = "upper", .ranges = &.{r('A', 'Z')} },
    .{ .name = "word", .ranges = &.{ r('0', '9'), r('A', 'Z'), r('_', '_'), r('a', 'z') } },
    .{ .name = "xdigit", .ranges = &.{ r('0', '9'), r('A', 'F'), r('a', 'f') } },
};

/// One named class of a bracket expression.
pub const Posix = struct {
    ranges: []const ScalarRange,
    /// `[:^name:]`: every scalar value the class does not hold.
    negated: bool,

    /// The class a name gives, or null where RE2 has no such name.
    pub fn named(name: []const u8, negated: bool) ?Posix {
        for (entries) |entry| {
            if (std.mem.eql(u8, entry.name, name)) return .{ .ranges = entry.ranges, .negated = negated };
        }
        return null;
    }

    /// Adds the scalar values of the class to a set.
    pub fn add_to(posix: Posix, set: *ScalarSet) errors.Error!void {
        var class: ScalarSet = .{};
        for (posix.ranges) |range| try class.add(range.lo, range.hi);
        if (posix.negated) try class.negate();
        for (class.slice()) |range| try set.add(range.lo, range.hi);
    }
};

const testing = std.testing;
const constants = @import("constants.zig");

fn holds(set: *const ScalarSet, scalar: u32) bool {
    for (set.slice()) |range| {
        if (range.lo <= scalar and scalar <= range.hi) return true;
    }
    return false;
}

/// The characters a name holds, as a second spelling of RE2's list for the tests to judge by.
fn expect_named(name: []const u8, held: []const u8, refused: []const u8) !void {
    var set: ScalarSet = .{};
    try Posix.named(name, false).?.add_to(&set);
    for (held) |octet| try testing.expect(holds(&set, octet));
    for (refused) |octet| try testing.expect(!holds(&set, octet));
    try testing.expect(!holds(&set, constants.one_octet_max + 1));
    var rest: ScalarSet = .{};
    try Posix.named(name, true).?.add_to(&rest);
    for (held) |octet| try testing.expect(!holds(&rest, octet));
    for (refused) |octet| try testing.expect(holds(&rest, octet));
    try testing.expect(holds(&rest, constants.scalar_max));
}

test "each of the fourteen names holds RE2's characters, and its negation the rest" {
    try expect_named("alnum", "09AZaz", "/:@[`{_ ");
    try expect_named("alpha", "AZaz", "09@[`{_");
    try expect_named("ascii", "\x00az\x7F", "");
    try expect_named("blank", "\t ", "\n\r\x0B\x0Ca");
    try expect_named("cntrl", "\x00\x1F\x7F", " ~a");
    try expect_named("digit", "0123456789", "/:a");
    try expect_named("graph", "!~aZ0", " \x7F\x1F");
    try expect_named("lower", "az", "AZ`{0");
    try expect_named("print", " ~aZ0", "\x1F\x7F");
    try expect_named("punct", "!/:@[`{~", "09AZaz \x7F");
    try expect_named("space", "\t\n\x0B\x0C\r ", "\x08\x0E!a");
    try expect_named("upper", "AZ", "az@[0");
    try expect_named("word", "09AZaz_", "/:@[`{ -");
    try expect_named("xdigit", "09AFaf", "/:@G`g");
}

test "a name RE2 does not list gives no class" {
    try testing.expectEqual(@as(?Posix, null), Posix.named("letter", false));
    try testing.expectEqual(@as(?Posix, null), Posix.named("", false));
    try testing.expectEqual(@as(?Posix, null), Posix.named("Alpha", false));
    try testing.expectEqual(@as(?Posix, null), Posix.named("alph", false));
    for (entries) |entry| try testing.expect(entry.name.len <= name_len_max);
}
