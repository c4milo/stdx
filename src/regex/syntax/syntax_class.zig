//! A bracket expression of a pattern (decision 86): RFC 9485 §3's charClassExpr, with the escapes
//! of syntax_escape.zig as its items, and three forms of RE2's: a class named as `[:alpha:]`, a
//! `]` that comes first, and a `-` that starts no range.
const std = @import("std");
const codec = @import("codec");
const constants = @import("../constants.zig");
const errors = @import("../errors.zig");
const escape = @import("syntax_escape.zig");
const utf8 = @import("utf8");
const utf8_ranges = @import("../utf8_ranges.zig");
const atom = @import("syntax_atom.zig");
const ScalarSet = @import("../scalar_set.zig").ScalarSet;
const posix = @import("syntax_posix.zig");
const Posix = posix.Posix;

const Item = union(enum) {
    /// The `]` that ends the class.
    end,
    scalar: u32,
    class: escape.Perl,
    posix: Posix,
};

fn take_item(reader: *codec.Reader) errors.Error!Item {
    // RFC 9485 §3: charClassExpr ends with "]", so a pattern does not end inside a class.
    const scalar = (try utf8_ranges.take_scalar(reader)) orelse return error.MissingBracket;
    switch (scalar) {
        ']' => return .end,
        '[' => return .{ .posix = try take_posix(reader) },
        '\\' => {},
        else => return .{ .scalar = scalar },
    }
    switch (try escape.take(reader)) {
        .scalar => |escaped| return .{ .scalar = escaped },
        .class => |perl| return .{ .class = perl },
        // RFC 9485 §3: a class holds characters, and an assertion such as \b is none.
        .look => return error.InvalidEscape,
    }
}

/// The class `[:name:]` names, whose `[` was just read.
fn take_posix(reader: *codec.Reader) errors.Error!Posix {
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
    return Posix.named(name[0..len], negated) orelse return error.InvalidClass;
}

/// The scalar values a class names, before its negation.
const Class = struct {
    set: ScalarSet = .{},
    /// True when the pattern wrote a scalar value past U+007F into the class.
    past_ascii: bool = false,

    /// One character, or a range from it when a `-` and a second character follow. A `-` that
    /// starts no range stands for itself, as in RE2: last in the class, or after a range.
    fn add_from(class: *Class, reader: *codec.Reader, lo: u32) errors.Error!void {
        var hi = lo;
        if (escape.take_if(reader, '-')) {
            if (escape.peek_is(reader, ']')) {
                try class.set.add('-', '-');
            } else {
                hi = switch (try take_item(reader)) {
                    .scalar => |scalar| scalar,
                    // RFC 9485 §3: CCE1 = CCchar "-" CCchar, and a range ends at one character.
                    else => return error.InvalidClassRange,
                };
            }
        }
        // RFC 9485 §4: a regexp means what XSD says, where a range's first character is at or
        // before its last.
        if (lo > hi) return error.InvalidClassRange;
        class.past_ascii = class.past_ascii or hi > constants.one_octet_max;
        try class.set.add(lo, hi);
    }

    fn add_item(class: *Class, reader: *codec.Reader, item: Item) errors.Error!void {
        switch (item) {
            .end => unreachable,
            .class => |perl| try perl.add_to(&class.set),
            .posix => |named| try named.add_to(&class.set),
            .scalar => |lo| try class.add_from(reader, lo),
        }
    }
};

/// The set of the class whose `[` was just read. A `]` that comes first stands for itself, as in
/// RE2, so a class holds at least one item.
pub fn take(reader: *codec.Reader, flags: atom.Flags) errors.Error!ScalarSet {
    var class: Class = .{};
    const negated = escape.take_if(reader, '^');
    if (escape.take_if(reader, ']')) try class.add_from(reader, ']');
    var item = try take_item(reader);
    while (item != .end) : (item = try take_item(reader)) try class.add_item(reader, item);
    std.debug.assert(class.set.len > 0);
    if (flags.case_insensitive) {
        // RFC 9485 §3 gives a regexp no case-insensitive form: `(?i)` is RE2's, and stdx folds
        // the ASCII letters alone (decision 86).
        if (class.past_ascii) return error.UnsupportedCaseFolding;
        try class.set.fold_ascii();
    }
    class.set.normalize();
    if (negated) try class.set.negate();
    return class.set;
}

const testing = std.testing;
const ScalarRange = utf8_ranges.ScalarRange;

/// The class a text holds, which must end at the text's end.
fn take_text(text: []const u8, flags: atom.Flags) errors.Error!ScalarSet {
    var reader = codec.Reader.init(text);
    const set = try take(&reader, flags);
    std.debug.assert(reader.remaining_len() == 0);
    return set;
}

fn expect_class(text: []const u8, flags: atom.Flags, expected: []const ScalarRange) !void {
    const set = try take_text(text, flags);
    try testing.expectEqualSlices(ScalarRange, expected, set.slice());
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

test "a class under (?i) gains the other case of its ASCII letters before its negation" {
    try expect_class("a-c]", .{ .case_insensitive = true }, &.{ range('A', 'C'), range('a', 'c') });
    try expect_class("^k]", .{ .case_insensitive = true }, &.{ range(0, 'J'), range('L', 'j'), range('l', constants.scalar_max) });
    // The negated ASCII classes pass U+007F, and the pattern wrote no such scalar value.
    try expect_class("\\W]", .{ .case_insensitive = true }, &.{ range(0, '/'), range(':', '@'), range('[', '^'), range('`', '`'), range('{', constants.scalar_max) });
    try testing.expectError(error.UnsupportedCaseFolding, take_text("\xC3\xA9]", .{ .case_insensitive = true }));
    try testing.expectError(error.UnsupportedCaseFolding, take_text("a-\xC3\xA9]", .{ .case_insensitive = true }));
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
    try expect_class("[:upper:]]", .{ .case_insensitive = true }, &.{ range('A', 'Z'), range('a', 'z') });
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
