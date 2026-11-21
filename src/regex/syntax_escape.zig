//! What follows a reverse solidus in a pattern (decision 86): RFC 9485 §3's SingleCharEsc, and the
//! escapes stdx adds from RE2's syntax.
const std = @import("std");
const codec = @import("codec");
const constants = @import("constants.zig");
const errors = @import("errors.zig");
const utf8 = @import("utf8.zig");
const Look = @import("program.zig").Look;
const ScalarSet = @import("scalar_set.zig").ScalarSet;

/// `\d`, `\s` and `\w`, which hold ASCII characters alone, as RE2's do.
pub const Perl = struct {
    kind: enum { digit, space, word },
    /// `\D`, `\S` or `\W`: every scalar value the class does not hold.
    negated: bool,

    /// Adds the scalar values of the class to a set.
    pub fn add_to(perl: Perl, set: *ScalarSet) errors.Error!void {
        var class: ScalarSet = .{};
        switch (perl.kind) {
            .digit => try class.add('0', '9'),
            .space => {
                try class.add('\t', '\n');
                try class.add('\x0C', '\r');
                try class.add(' ', ' ');
            },
            .word => {
                try class.add('0', '9');
                try class.add('A', 'Z');
                try class.add('_', '_');
                try class.add('a', 'z');
            },
        }
        if (perl.negated) try class.negate();
        for (class.slice()) |range| try set.add(range.lo, range.hi);
    }
};

pub const Escape = union(enum) {
    scalar: u32,
    look: Look,
    class: Perl,
};

/// The escape whose reverse solidus was just read.
pub fn take(reader: *codec.Reader) errors.Error!Escape {
    // RFC 9485 §3: SingleCharEsc = "\" and one character, so a pattern does not end at a "\".
    const scalar = (try utf8.take_scalar(reader)) orelse return error.InvalidEscape;
    return switch (scalar) {
        'A' => .{ .look = .behind_text },
        'z' => .{ .look = .ahead_text },
        'b' => .{ .look = .word_boundary },
        'B' => .{ .look = .not_word_boundary },
        'd' => .{ .class = .{ .kind = .digit, .negated = false } },
        'D' => .{ .class = .{ .kind = .digit, .negated = true } },
        's' => .{ .class = .{ .kind = .space, .negated = false } },
        'S' => .{ .class = .{ .kind = .space, .negated = true } },
        'w' => .{ .class = .{ .kind = .word, .negated = false } },
        'W' => .{ .class = .{ .kind = .word, .negated = true } },
        'n' => .{ .scalar = '\n' },
        'r' => .{ .scalar = '\r' },
        't' => .{ .scalar = '\t' },
        'f' => .{ .scalar = '\x0C' },
        'v' => .{ .scalar = '\x0B' },
        'a' => .{ .scalar = '\x07' },
        'x' => .{ .scalar = try hex(reader) },
        '0'...'9' => .{ .scalar = try octal(reader, scalar) },
        else => .{ .scalar = try other(scalar) },
    };
}

/// An escape that is one character and names itself, or one stdx refuses.
fn other(scalar: u32) errors.Error!u32 {
    switch (scalar) {
        '!'...'/', ':'...'@', '['...'`', '{'...'~' => return scalar,
        // RFC 9485 §3: charClassEsc is \p{...} or \P{...}, whose tables are a later step.
        'p', 'P' => return error.UnsupportedProperty,
        // RFC 9485 §3: SingleCharEsc names the characters a "\" may precede, and stdx adds the
        // ones above.
        else => return error.InvalidEscape,
    }
}

/// The next octet's value as an octal digit, read only when it is one.
fn take_octal_digit(reader: *codec.Reader) ?u32 {
    const octet = reader.take_octet() catch return null;
    if (octet >= '0' and octet <= '7') return octet - '0';
    reader.unread(1);
    return null;
}

/// An octal escape, as RE2 reads one: `\0` and up to two octal digits after it, or a digit from
/// 1 to 7 and one or two octal digits after it. A digit from 1 to 9 alone is how other engines
/// write a backreference.
fn octal(reader: *codec.Reader, first: u32) errors.Error!u32 {
    var value: u32 = first - '0';
    var count: u32 = 1;
    if (first <= '7') {
        while (count < constants.octal_digits_max) : (count += 1) {
            const digit = take_octal_digit(reader) orelse break;
            value = value * constants.octal_base + digit;
        }
    }
    // RFC 9485 §1: a regexp has no backreference. No automaton of a fixed size matches one.
    if (first != '0' and count == 1) return error.UnsupportedBackreference;
    return value;
}

fn hex_digit(octet: u8) ?u32 {
    return switch (octet) {
        '0'...'9' => octet - '0',
        'a'...'f' => octet - 'a' + constants.decimal_base,
        'A'...'F' => octet - 'A' + constants.decimal_base,
        else => null,
    };
}

/// The next octet's value as a hexadecimal digit, read only when it is one.
fn take_hex_digit(reader: *codec.Reader) ?u32 {
    const octet = reader.take_octet() catch return null;
    if (hex_digit(octet)) |digit| return digit;
    reader.unread(1);
    return null;
}

/// `\xHH`, or `\x{H...}` of one digit or more: one Unicode scalar value.
fn hex(reader: *codec.Reader) errors.Error!u32 {
    const braced = take_if(reader, '{');
    var value: u32 = 0;
    var count: u32 = 0;
    // A value past U+10FFFF stays one past it, so no count of digits overflows.
    while (braced or count < constants.hex_short_digits) : (count += 1) {
        const digit = take_hex_digit(reader) orelse break;
        value = @min(value * constants.hex_base + digit, constants.scalar_max + 1);
    }
    // RFC 9485 §3 holds no such escape: it is RE2's, two digits or braces around one or more.
    if (count == 0 or (!braced and count != constants.hex_short_digits)) return error.InvalidEscape;
    // RFC 9485 §3 has no such escape: the braces RE2 gives it close after the digits.
    if (braced and !take_if(reader, '}')) return error.InvalidEscape;
    // RFC 3629 §3: a scalar value is at most U+10FFFF and is no surrogate.
    if (value > constants.scalar_max or utf8.is_surrogate(value)) return error.InvalidScalarValue;
    return value;
}

/// Reads the next octet when it is `expected`.
pub fn take_if(reader: *codec.Reader, expected: u8) bool {
    const octet = reader.take_octet() catch return false;
    if (octet == expected) return true;
    reader.unread(1);
    return false;
}

/// True when the next octet is `expected`. Nothing is read.
pub fn peek_is(reader: *codec.Reader, expected: u8) bool {
    if (!take_if(reader, expected)) return false;
    reader.unread(1);
    return true;
}

const testing = std.testing;

fn take_text(text: []const u8) errors.Error!Escape {
    var reader = codec.Reader.init(text);
    return take(&reader);
}

test "take names each escape stdx adds to RFC 9485's" {
    try testing.expectEqual(Look.behind_text, (try take_text("A")).look);
    try testing.expectEqual(Look.ahead_text, (try take_text("z")).look);
    try testing.expectEqual(Look.word_boundary, (try take_text("b")).look);
    try testing.expectEqual(Look.not_word_boundary, (try take_text("B")).look);
    try testing.expectEqual(@as(u32, '\n'), (try take_text("n")).scalar);
    try testing.expectEqual(@as(u32, '\r'), (try take_text("r")).scalar);
    try testing.expectEqual(@as(u32, '\t'), (try take_text("t")).scalar);
    try testing.expectEqual(@as(u32, 0x0C), (try take_text("f")).scalar);
    try testing.expectEqual(@as(u32, 0x0B), (try take_text("v")).scalar);
    try testing.expectEqual(@as(u32, 0x07), (try take_text("a")).scalar);
    try testing.expect((try take_text("D")).class.negated);
    try testing.expect(!(try take_text("w")).class.negated);
}

test "take gives each ASCII punctuation character as itself, and no letter or digit" {
    for ("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~") |octet| {
        try testing.expectEqual(@as(u32, octet), (try take_text(&.{octet})).scalar);
    }
    for ("cegGhijklmoqQuyZ") |octet| try testing.expectError(error.InvalidEscape, take_text(&.{octet}));
    try testing.expectError(error.InvalidEscape, take_text(" "));
    try testing.expectError(error.InvalidEscape, take_text("\xC3\xA9"));
    try testing.expectError(error.InvalidEscape, take_text(""));
}

test "an octal escape is a zero or two to three octal digits, as RE2 reads one" {
    try testing.expectEqual(@as(u32, 0), (try take_text("0")).scalar);
    try testing.expectEqual(@as(u32, '0'), (try take_text("060")).scalar);
    try testing.expectEqual(@as(u32, 'a'), (try take_text("141")).scalar);
    try testing.expectEqual(@as(u32, 1), (try take_text("01")).scalar);
    try testing.expectEqual(@as(u32, 0o12), (try take_text("12")).scalar);
    try testing.expectEqual(@as(u32, 0o777), (try take_text("777")).scalar);
    // A third digit after a zero, a fourth digit, and a digit past 7 are left unread.
    var reader = codec.Reader.init("0600");
    try testing.expectEqual(@as(u32, '0'), (try take(&reader)).scalar);
    try testing.expectEqual(@as(usize, 1), reader.remaining_len());
    reader = codec.Reader.init("608");
    try testing.expectEqual(@as(u32, '0'), (try take(&reader)).scalar);
    try testing.expectEqual(@as(usize, 1), reader.remaining_len());
    reader = codec.Reader.init("018");
    try testing.expectEqual(@as(u32, 1), (try take(&reader)).scalar);
    try testing.expectEqual(@as(usize, 1), reader.remaining_len());
    reader = codec.Reader.init("1411");
    try testing.expectEqual(@as(u32, 'a'), (try take(&reader)).scalar);
    try testing.expectEqual(@as(usize, 1), reader.remaining_len());
}

test "take refuses a backreference and a property by their own errors" {
    for ("123456789") |octet| try testing.expectError(error.UnsupportedBackreference, take_text(&.{octet}));
    for ([_][]const u8{ "1a", "7.", "8", "81", "90", "18", "1" }) |text| {
        try testing.expectError(error.UnsupportedBackreference, take_text(text));
    }
    try testing.expectError(error.UnsupportedProperty, take_text("p{L}"));
    try testing.expectError(error.UnsupportedProperty, take_text("PL"));
}

test "a hex escape is two digits, or one or more in braces, that name a scalar value" {
    try testing.expectEqual(@as(u32, 0x41), (try take_text("x41")).scalar);
    try testing.expectEqual(@as(u32, 0xFF), (try take_text("xfF")).scalar);
    try testing.expectEqual(@as(u32, 0xA), (try take_text("x{a}")).scalar);
    try testing.expectEqual(@as(u32, 0x10FFFF), (try take_text("x{10FFFF}")).scalar);
    try testing.expectEqual(@as(u32, 0xD7FF), (try take_text("x{D7FF}")).scalar);
    try testing.expectError(error.InvalidEscape, take_text("x4"));
    try testing.expectError(error.InvalidEscape, take_text("x4g"));
    try testing.expectError(error.InvalidEscape, take_text("x"));
    try testing.expectError(error.InvalidEscape, take_text("x{}"));
    try testing.expectError(error.InvalidEscape, take_text("x{41"));
    try testing.expectEqual(@as(u32, 0x41), (try take_text("x{0000041}")).scalar);
    try testing.expectEqual(@as(u32, 0x61), (try take_text("x{00000061}")).scalar);
    try testing.expectError(error.InvalidScalarValue, take_text("x{FFFFFFFFFFFFFFFFFFFF}"));
    try testing.expectError(error.InvalidEscape, take_text("x{4g}"));
    try testing.expectError(error.InvalidScalarValue, take_text("x{110000}"));
    try testing.expectError(error.InvalidScalarValue, take_text("x{D800}"));
    try testing.expectError(error.InvalidScalarValue, take_text("x{DFFF}"));
}

test "a hex escape of two digits leaves the octets after it unread" {
    var reader = codec.Reader.init("x41b");
    try testing.expectEqual(@as(u32, 0x41), (try take(&reader)).scalar);
    try testing.expectEqual(@as(usize, 1), reader.remaining_len());
}

fn expect_class(perl: Perl, held: []const u8, refused: []const u8) !void {
    var set: ScalarSet = .{};
    try perl.add_to(&set);
    for (held) |octet| try testing.expect(holds(&set, octet));
    for (refused) |octet| try testing.expect(!holds(&set, octet));
}

fn holds(set: *const ScalarSet, scalar: u32) bool {
    for (set.slice()) |range| {
        if (range.lo <= scalar and scalar <= range.hi) return true;
    }
    return false;
}

test "the three classes hold RE2's ASCII characters, and their negations the rest" {
    try expect_class(.{ .kind = .digit, .negated = false }, "0159", "/:aA ");
    try expect_class(.{ .kind = .space, .negated = false }, "\t\n\x0C\r ", "\x08\x0B\x0E\x1F!a");
    try expect_class(.{ .kind = .word, .negated = false }, "09AZaz_", "/:@[`{ -");
    try expect_class(.{ .kind = .digit, .negated = true }, "/:aA \x00", "0159");
    try expect_class(.{ .kind = .word, .negated = true }, "/:@[`{ -", "09AZaz_");
    var set: ScalarSet = .{};
    try (Perl{ .kind = .space, .negated = true }).add_to(&set);
    try testing.expect(holds(&set, constants.scalar_max));
    try testing.expect(holds(&set, 0xE9));
}
