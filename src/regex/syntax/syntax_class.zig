//! A bracket expression of a pattern (decision 86): RFC 9485 §3's charClassExpr, with the escapes
//! of syntax_escape.zig as its items, and three forms of RE2's: a class named as `[:alpha:]`, a
//! `]` that comes first, and a `-` that starts no range.
//!
//! A class is built in the one set the parser keeps (decision 86 as amended). Under `(?i)` each
//! item is folded as it is read, and the class's `^` negates the folded items, as Go's regexp
//! folds a class. In bytes a class holds octets, and under `(?i)` its ASCII letters take their
//! other case once every item is read, before the `^`.
const std = @import("std");
const codec = @import("codec");
const constants = @import("../constants.zig");
const errors = @import("../errors.zig");
const escape = @import("syntax_escape.zig");
const utf8 = @import("utf8");
const utf8_ranges = @import("../utf8_ranges.zig");
const atom = @import("syntax_atom.zig");
const scalar_set = @import("../scalar_set.zig");
const NamedClass = scalar_set.NamedClass;
const ScalarSet = scalar_set.ScalarSet;
const posix = @import("syntax_posix.zig");
const unicode = @import("unicode");
const Encoding = @import("../program.zig").Encoding;

const Item = union(enum) {
    /// The `]` that ends the class.
    end,
    scalar: u32,
    /// `\d`, `\p{Greek}`, `[:alpha:]` and their negations.
    class: NamedClass,
};

fn take_item(reader: *codec.Reader, encoding: Encoding) errors.Error!Item {
    // RFC 9485 §3: charClassExpr ends with "]", so a pattern does not end inside a class.
    const scalar = (try utf8_ranges.take_scalar(reader)) orelse return error.MissingBracket;
    switch (scalar) {
        ']' => return .end,
        '[' => return .{ .class = try take_posix(reader) },
        '\\' => {},
        else => {
            // RFC 3629 §3: a character past U+007F is two bytes or more of UTF-8, and under
            // `Encoding.bytes` a class takes one byte.
            if (encoding == .bytes and scalar > constants.one_octet_max) return error.UnsupportedUnicode;
            return .{ .scalar = scalar };
        },
    }
    switch (try escape.take(reader, encoding)) {
        .scalar => |escaped| return .{ .scalar = escaped },
        .class => |named| return .{ .class = named },
        // RFC 9485 §3: a class holds characters, and an assertion such as \b is none.
        .look => return error.InvalidEscape,
    }
}

/// The class `[:name:]` names, whose `[` was just read.
fn take_posix(reader: *codec.Reader) errors.Error!NamedClass {
    // RFC 9485 §3: CCchar holds no "[" but an escaped one. RE2 adds "[:name:]" alone.
    if (!escape.take_if(reader, ':')) return error.InvalidClass;
    const negated = escape.take_if(reader, '^');
    var name: [posix.name_len_max]u8 = undefined;
    var len: usize = 0;
    while (len < posix.name_len_max) : (len += 1) {
        const octet = reader.take_octet() catch break;
        if (octet < 'a' or octet > 'z') {
            reader.unread(1);
            break;
        }
        name[len] = octet;
    }
    // RFC 9485 §3 holds no such form: RE2's ends with ":]".
    if (!escape.take_if(reader, ':') or !escape.take_if(reader, ']')) return error.InvalidClass;
    // RFC 9485 §3 holds no such form: RE2's names one of its fourteen classes.
    return posix.named(name[0..len], negated) orelse return error.InvalidClass;
}

/// The items of one class, added to the parser's set as they are read.
const Class = struct {
    set: *ScalarSet,
    /// `(?i)`: each item gains the scalar values that match its own without case. RFC 9485 §3
    /// gives a regexp no case-insensitive form, so this is RE2's, with UTS #18 RL1.5's folding.
    fold: bool,
    encoding: Encoding,

    /// One character, or a range from it when a `-` and a second character follow. A `-` that
    /// starts no range stands for itself, as in RE2: last in the class, or after a range.
    fn add_from(class: *Class, reader: *codec.Reader, lo: u32) errors.Error!void {
        var hi = lo;
        if (escape.take_if(reader, '-')) {
            if (escape.peek_is(reader, ']')) {
                try class.set.add_folded('-', '-', class.fold);
            } else {
                hi = switch (try take_item(reader, class.encoding)) {
                    .scalar => |scalar| scalar,
                    // RFC 9485 §3: CCE1 = CCchar "-" CCchar, and a range ends at one character.
                    else => return error.InvalidClassRange,
                };
            }
        }
        // RFC 9485 §4: a regexp means what XSD says, where a range's first character is at or
        // before its last.
        if (lo > hi) return error.InvalidClassRange;
        try class.set.add_folded(lo, hi, class.fold);
    }

    fn add_item(class: *Class, reader: *codec.Reader, item: Item) errors.Error!void {
        switch (item) {
            .end => unreachable,
            .class => |named| try class.set.add_named(named, class.fold),
            .scalar => |lo| try class.add_from(reader, lo),
        }
    }
};

/// Writes into `set` the class whose `[` was just read, normalized. A `]` that comes first stands
/// for itself, as in RE2, so a class holds at least one item. An item may hold no scalar value,
/// as `\P{Any}` holds none, and so may the class.
pub fn take(reader: *codec.Reader, flags: atom.Flags, encoding: Encoding, set: *ScalarSet) errors.Error!void {
    set.len = 0;
    var class: Class = .{ .set = set, .fold = flags.case_insensitive and encoding == .utf8, .encoding = encoding };
    const negated = escape.take_if(reader, '^');
    if (escape.take_if(reader, ']')) try class.add_from(reader, ']');
    var item = try take_item(reader, encoding);
    while (item != .end) : (item = try take_item(reader, encoding)) try class.add_item(reader, item);
    set.normalize();
    if (flags.case_insensitive and encoding == .bytes) try set.fold_ascii();
    if (negated) try set.negate();
}

const testing = std.testing;
const ScalarRange = utf8_ranges.ScalarRange;

/// The class a text holds, which must end at the text's end.
/// The class a text holds, which must end at the text's end, written into `set`.
fn take_into(set: *ScalarSet, text: []const u8, flags: atom.Flags) errors.Error!void {
    var reader = codec.Reader.init(text);
    try take(&reader, flags, .utf8, set);
    std.debug.assert(reader.remaining_len() == 0);
}

fn take_text(text: []const u8, flags: atom.Flags) errors.Error!void {
    var set_storage: [constants.class_ranges_max]utf8_ranges.ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try take_into(&set, text, flags);
}

fn expect_class(text: []const u8, flags: atom.Flags, expected: []const ScalarRange) !void {
    var set_storage: [constants.class_ranges_max]utf8_ranges.ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try take_into(&set, text, flags);
    try testing.expectEqualSlices(ScalarRange, expected, set.slice());
}

fn holds(set: *const ScalarSet, scalar: u32) bool {
    for (set.slice()) |piece| {
        if (piece.lo <= scalar and scalar <= piece.hi) return true;
    }
    return false;
}

/// Requires the class of `text` under `(?i)` to hold each scalar value of the orbits of `lo` to
/// `hi`, and no other: a second reading of the folding, one scalar value at a time.
fn expect_orbits(text: []const u8, lo: u32, hi: u32) !void {
    var wanted_storage: [constants.class_ranges_max]utf8_ranges.ScalarRange = undefined;
    var wanted = ScalarSet.init(&wanted_storage);
    for (lo..hi + 1) |scalar| {
        var current: u32 = @intCast(scalar);
        for (0..unicode.constants.orbit_len_max) |_| {
            try wanted.add(current, current);
            current = unicode.simple_fold(current);
        }
    }
    wanted.normalize();
    try expect_class(text, .{ .case_insensitive = true }, wanted.slice());
}

fn range(lo: u32, hi: u32) ScalarRange {
    return .{ .lo = lo, .hi = hi };
}

test "a class holds its characters and its ranges, joined" {
    try expect_class("abc]", .{}, &.{range('a', 'c')});
    try expect_class("a-cx-z0]", .{}, &.{ range('0', '0'), range('a', 'c'), range('x', 'z') });
    try expect_class("\xC3\xA9-\xC3\xBF]", .{}, &.{range(0xE9, 0xFF)});
    try expect_class("a-a]", .{}, &.{range('a', 'a')});
    try expect_class("\\x41-\\x{5A}]", .{}, &.{range('A', 'Z')});
    try expect_class(".*+?(){}|^$]", .{}, &.{ range('$', '$'), range('(', '+'), range('.', '.'), range('?', '?'), range('^', '^'), range('{', '}') });
}

test "a dash stands for itself first, last, and escaped" {
    try expect_class("-a]", .{}, &.{ range('-', '-'), range('a', 'a') });
    try expect_class("a-]", .{}, &.{ range('-', '-'), range('a', 'a') });
    try expect_class("-]", .{}, &.{range('-', '-')});
    try expect_class("^-]", .{}, &.{ range(0, ','), range('.', constants.scalar_max) });
    try expect_class("a\\-z]", .{}, &.{ range('-', '-'), range('a', 'a'), range('z', 'z') });
    try expect_class("+-\\-]", .{}, &.{range('+', '-')});
    // A dash that starts no range stands for itself, and one that can start a range does.
    try expect_class("a-c-e]", .{}, &.{ range('-', '-'), range('a', 'c'), range('e', 'e') });
    try expect_class("+--]", .{}, &.{range('+', '-')});
    try expect_class("--a]", .{}, &.{range('-', 'a')});
    try expect_class("a-c-]", .{}, &.{ range('-', '-'), range('a', 'c') });
    try expect_class("---]", .{}, &.{range('-', '-')});
    try testing.expectError(error.InvalidClassRange, take_text("a--]", .{}));
}

test "a negated class holds every other scalar value" {
    try expect_class("^a]", .{}, &.{ range(0, 'a' - 1), range('a' + 1, constants.scalar_max) });
    try expect_class("^\\x00-\\x{10FFFF}]", .{}, &.{});
    try expect_class("^^]", .{}, &.{ range(0, '^' - 1), range('^' + 1, constants.scalar_max) });
}

test "a class takes the three ASCII classes and their negations as items" {
    try expect_class("\\d_]", .{}, &.{ range('0', '9'), range('_', '_') });
    try expect_class("\\w-]", .{}, &.{ range('-', '-'), range('0', '9'), range('A', 'Z'), range('_', '_'), range('a', 'z') });
    try expect_class("^\\D]", .{}, &.{range('0', '9')});
    try expect_class("\\D\\d]", .{}, &.{range(0, constants.scalar_max)});
}

test "a class under (?i) holds each orbit of its scalar values, before its negation" {
    const fold: atom.Flags = .{ .case_insensitive = true };
    try expect_class("a-c]", fold, &.{ range('A', 'C'), range('a', 'c') });
    // k's orbit holds the Kelvin sign.
    try expect_class("^k]", fold, &.{ range(0, 'J'), range('L', 'j'), range('l', 0x2129), range(0x212B, constants.scalar_max) });
    // \W is folded before it is negated, so it holds neither ſ nor the Kelvin sign, which fold
    // to s and k.
    try expect_class("\\W]", fold, &.{ range(0, '/'), range(':', '@'), range('[', '^'), range('`', '`'), range('{', 0x17E), range(0x180, 0x2129), range(0x212B, constants.scalar_max) });
    try expect_orbits("\xC3\xA9]", 0xE9, 0xE9);
    try expect_orbits("a-\xC3\xA9]", 'a', 0xE9);
    try expect_orbits("\xCF\x82]", 0x3C2, 0x3C2);
}

test "a class takes Unicode properties and their negations as items" {
    var set_storage: [constants.class_ranges_max]utf8_ranges.ScalarRange = undefined;
    var set = ScalarSet.init(&set_storage);
    try take_into(&set, "\\p{Greek}0]", .{});
    try testing.expect(holds(&set, 0x3B1) and holds(&set, '0') and !holds(&set, 'a'));
    try take_into(&set, "\\P{Greek}]", .{});
    try testing.expect(!holds(&set, 0x3B1) and holds(&set, 'a'));
    // \P{Any} holds no scalar value, and the class may hold none.
    try expect_class("\\P{Any}]", .{}, &.{});
    try expect_class("^\\P{Any}]", .{}, &.{range(0, constants.scalar_max)});
    // Under (?i), \p{Lu} holds the lowercase letters too, and \P{Lu} holds neither case.
    try take_into(&set, "\\p{Lu}]", .{ .case_insensitive = true });
    try testing.expect(holds(&set, 'a') and holds(&set, 'A'));
    try take_into(&set, "\\P{Lu}]", .{ .case_insensitive = true });
    try testing.expect(!holds(&set, 'a') and !holds(&set, 'A') and holds(&set, '1'));
    try testing.expectError(error.InvalidProperty, take_text("\\p{Nothing}]", .{}));
}

test "a closing bracket that comes first stands for itself" {
    try expect_class("]]", .{}, &.{range(']', ']')});
    try expect_class("]a]", .{}, &.{ range(']', ']'), range('a', 'a') });
    try expect_class("^]a]", .{}, &.{ range(0, '\\'), range('^', '`'), range('b', constants.scalar_max) });
    try expect_class("]-a]", .{}, &.{range(']', 'a')});
    try expect_class("]-]", .{}, &.{ range('-', '-'), range(']', ']') });
    try testing.expectError(error.MissingBracket, take_text("]", .{}));
    try testing.expectError(error.MissingBracket, take_text("^]", .{}));
}

test "a class takes RE2's named classes, and their negations" {
    try expect_class("[:digit:]]", .{}, &.{range('0', '9')});
    try expect_class("[:alpha:]_]", .{}, &.{ range('A', 'Z'), range('_', '_'), range('a', 'z') });
    try expect_class("[:^ascii:]]", .{}, &.{range(constants.one_octet_max + 1, constants.scalar_max)});
    try expect_class("^[:^digit:]]", .{}, &.{range('0', '9')});
    try expect_class("[:upper:]]", .{ .case_insensitive = true }, &.{ range('A', 'Z'), range('a', 'z'), range(0x17F, 0x17F), range(0x212A, 0x212A) });
    try expect_class("a[:blank:]-]", .{}, &.{ range('\t', '\t'), range(' ', ' '), range('-', '-'), range('a', 'a') });
    try testing.expectError(error.InvalidClass, take_text("[:letter:]]", .{}));
    try testing.expectError(error.InvalidClass, take_text("[:alpha]", .{}));
    try testing.expectError(error.InvalidClass, take_text("[:alpha:", .{}));
    try testing.expectError(error.InvalidClass, take_text("[:Alpha:]]", .{}));
    try testing.expectError(error.InvalidClass, take_text("[:alphabetical:]]", .{}));
    try testing.expectError(error.InvalidClass, take_text("[::]]", .{}));
    try testing.expectError(error.InvalidClassRange, take_text("a-[:digit:]]", .{}));
}

test "take refuses each class that neither RFC 9485 §3 nor RE2 holds" {
    try testing.expectError(error.MissingBracket, take_text("abc", .{}));
    try testing.expectError(error.MissingBracket, take_text("", .{}));
    try testing.expectError(error.MissingBracket, take_text("a-", .{}));
    try testing.expectError(error.InvalidClass, take_text("a[]", .{}));
    try testing.expectError(error.InvalidClass, take_text("[a]]", .{}));
    try testing.expectError(error.InvalidClassRange, take_text("z-a]", .{}));
    try testing.expectError(error.InvalidClassRange, take_text("a-\\d]", .{}));
    try testing.expectError(error.InvalidClass, take_text("a-[]", .{}));
    try testing.expectError(error.InvalidEscape, take_text("\\b]", .{}));
    try testing.expectError(error.InvalidEscape, take_text("\\", .{}));
    try testing.expectError(error.InvalidUtf8, take_text("\xFF]", .{}));
}

test "a class past class_ranges_max ranges is refused" {
    var text: [4 * constants.class_ranges_max + 8]u8 = undefined;
    var len: usize = 0;
    // Every second scalar value from U+0100 on: no two join.
    for (0..constants.class_ranges_max + 1) |index| {
        const code_point: u21 = @intCast(0x100 + 2 * index);
        const count = utf8.encoded_len(code_point);
        utf8.encode(code_point, text[len..][0..count]);
        len += count;
    }
    text[len] = ']';
    try testing.expectError(error.ClassTooLarge, take_text(text[0 .. len + 1], .{}));
}
