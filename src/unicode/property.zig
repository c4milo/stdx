//! The ranges of the property a name names: a General_Category value, a group of them, a Script,
//! or one of Any, ASCII and Assigned (UTS #18 RL1.2 and §1.2.5).
//!
//! A name compares by rule UAX44-LM3 (UAX #44 §5.9.3): case does not count, nor do whitespace, `_`
//! and `-`. Of whitespace, the space alone does not count, so `"Old Italic"` names Old_Italic and a
//! tab names nothing. A case is an ASCII letter's: no name holds another letter. UAX44-LM3 also
//! drops a prefix "is", and UTS #18 §1.2.4 leaves that out of a regular expression's names, so
//! `"IsGreek"` names nothing. A General_Category value has each name PropertyValueAliases.txt gives
//! it (UAX #44 §5.8.2), and a Script has its long name alone, as Scripts.txt writes it.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const entries = @import("entries.zig");
const tables = @import("unicode_tables.zig");
const Range = entries.Range;

/// The ranges of the property `name` names, in order and apart, or null when it names none.
pub fn property(name: []const u8) ?[]const Range {
    var storage: [constants.property_name_len_max]u8 = undefined;
    const key = normalized(name, &storage) orelse return null;
    const index = std.sort.binarySearch(entries.Property, &tables.properties, key, compare) orelse return null;
    const ranges = tables.properties[index].ranges;
    assert(ranges.len > 0 and ranges[ranges.len - 1].hi <= constants.code_point_max);
    return ranges;
}

fn compare(key: []const u8, entry: entries.Property) std.math.Order {
    return std.mem.order(u8, key, entry.name);
}

/// `name` as the tables hold their names: lowercase, without the space, `_` and `-`. Null when
/// more is left than the longest name holds. No name is empty, so an empty result names nothing.
fn normalized(name: []const u8, storage: *[constants.property_name_len_max]u8) ?[]const u8 {
    var len: usize = 0;
    for (name) |octet| {
        // UAX #44 §5.9.3, UAX44-LM3: whitespace, `_` and `-` do not count, of whitespace the space.
        if (octet == ' ' or octet == '_' or octet == '-') continue;
        if (len == storage.len) return null;
        storage[len] = std.ascii.toLower(octet);
        len += 1;
    }
    return storage[0..len];
}

// Tests.

const testing = std.testing;

fn expect_same(name: []const u8, other: []const u8) !void {
    try testing.expectEqual(property(name).?.ptr, property(other).?.ptr);
}

fn holds(ranges: []const Range, code_point: u32) bool {
    const index = std.sort.partitionPoint(Range, ranges, code_point, below);
    return index < ranges.len and ranges[index].lo <= code_point;
}

fn below(code_point: u32, range: Range) bool {
    return range.hi < code_point;
}

test "a name compares without case, the space, underscores and hyphens" {
    try expect_same("Lu", "Uppercase_Letter");
    try expect_same("Lu", "uppercase letter");
    try expect_same("Lu", "UPPERCASE-LETTER");
    try expect_same("Lu", " l u ");
    try expect_same("L", "Letter");
    try expect_same("Old_Italic", "old italic");
    try expect_same("Old_Italic", "OldItalic");
    // PropertyValueAliases.txt gives Cc a third name, and P and M a second one each.
    try expect_same("Cc", "cntrl");
    try expect_same("P", "punct");
    try expect_same("M", "Combining_Mark");
    try expect_same("LC", "Cased_Letter");
    try expect_same("Cn", "Unassigned");
}

test "a name with an is prefix, a script's code, other whitespace or nothing left names nothing" {
    const refused = [_][]const u8{
        "IsGreek", "isL", "Latn",    "Zyyy",            "Unknown", "L&", "gc=L", "Script=Greek",
        "L\t",     "\tL", "L\u{a0}", "\u{212a}atakana", "",        " ",  "__",   "-",
        "Lu Ll",   "L.",
    };
    for (refused) |name| try testing.expectEqual(null, property(name));
}

test "the longest name fits, and a name of one more letter names nothing" {
    try testing.expect(property("Inscriptional_Parthian") != null);
    try testing.expectEqual(null, property("Inscriptional_Parthianx"));
    // What does not count does not take room.
    try testing.expect(property("  Inscriptional - Parthian  ") != null);
    var longest: usize = 0;
    for (tables.properties) |entry| longest = @max(longest, entry.name.len);
    try testing.expectEqual(constants.property_name_len_max, longest);
}

test "the tables hold each name in order, as normalized writes it" {
    var storage: [constants.property_name_len_max]u8 = undefined;
    for (tables.properties, 0..) |entry, index| {
        try testing.expectEqualStrings(entry.name, normalized(entry.name, &storage).?);
        if (index > 0) try testing.expectEqual(.lt, std.mem.order(u8, tables.properties[index - 1].name, entry.name));
    }
}

test "each property's ranges are in order and apart, within the codespace" {
    for (tables.properties) |entry| {
        try testing.expect(entry.ranges.len > 0);
        try testing.expect(entry.ranges[entry.ranges.len - 1].hi <= constants.code_point_max);
        for (entry.ranges, 0..) |range, index| {
            try testing.expect(range.lo <= range.hi);
            if (index > 0) try testing.expect(range.lo > entry.ranges[index - 1].hi + 1);
        }
    }
}

test "Any, ASCII and Assigned are what UTS #18 §1.2.5 says" {
    try testing.expectEqualSlices(Range, &.{.{ .lo = 0, .hi = constants.code_point_max }}, property("Any").?);
    try testing.expectEqualSlices(Range, &.{.{ .lo = 0, .hi = 0x7F }}, property("ASCII").?);
    // Assigned is \P{Cn}: the two lists take turns from 0 to the end of the codespace. U+0000 is a
    // control, and U+10FFFF a noncharacter, which Cn holds.
    const lists = [_][]const Range{ property("Assigned").?, property("Cn").? };
    var next = [_]usize{ 0, 0 };
    var expected_lo: u32 = 0;
    var turn: usize = 0;
    while (next[turn] < lists[turn].len) : (turn ^= 1) {
        const range = lists[turn][next[turn]];
        try testing.expectEqual(expected_lo, range.lo);
        expected_lo = range.hi + 1;
        next[turn] += 1;
    }
    try testing.expectEqual(@as(u32, constants.code_point_max + 1), expected_lo);
    try testing.expectEqual(lists[0].len, next[0]);
    try testing.expectEqual(lists[1].len, next[1]);
}

test "the General_Category values of two letters hold each code point once" {
    const names = [_][]const u8{
        "Lu", "Ll", "Lt", "Lm", "Lo", "Mn", "Mc", "Me", "Nd", "Nl", "No", "Pc", "Pd", "Ps", "Pe",
        "Pi", "Pf", "Po", "Sm", "Sc", "Sk", "So", "Zs", "Zl", "Zp", "Cc", "Cf", "Cs", "Co", "Cn",
    };
    var total: u64 = 0;
    for (names) |name| {
        for (property(name).?) |range| total += range.hi - range.lo + 1;
    }
    try testing.expectEqual(@as(u64, constants.code_point_max + 1), total);
    // Spot checks against what each value's description in UAX #44 §5.7.1 says.
    try testing.expect(holds(property("Lu").?, 'A') and !holds(property("Lu").?, 'a'));
    try testing.expect(holds(property("Nd").?, '7') and holds(property("Cs").?, 0xD800));
    try testing.expect(holds(property("Greek").?, 0x3B1) and !holds(property("Greek").?, 'a'));
}

test "LC and the groups of one letter hold the code points of their values" {
    const groups = [_]struct { []const u8, []const []const u8 }{
        .{ "LC", &.{ "Lu", "Ll", "Lt" } },
        .{ "L", &.{ "Lu", "Ll", "Lt", "Lm", "Lo" } },
        .{ "Z", &.{ "Zs", "Zl", "Zp" } },
    };
    for (groups) |entry| {
        var total: u64 = 0;
        for (entry[1]) |part| {
            for (property(part).?) |range| {
                try testing.expect(holds(property(entry[0]).?, range.lo) and holds(property(entry[0]).?, range.hi));
                total += range.hi - range.lo + 1;
            }
        }
        var group_total: u64 = 0;
        for (property(entry[0]).?) |range| group_total += range.hi - range.lo + 1;
        try testing.expectEqual(total, group_total);
    }
}
