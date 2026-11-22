//! `\p` and `\P` (decision 86 as amended): a property of the `unicode` module's tables.
//!
//! RFC 9485 §3's catEsc and complEsc name a General_Category value in braces, as `\p{Lu}`. stdx
//! reads both as RE2 does. One character may follow the `p`, as `\pL`, or a name in braces, as
//! `\p{Greek}`, and a `^` first in the braces negates it, as `\p{^Greek}`. A name is any that
//! `unicode.property` takes, compared as it compares them: `\p{old italic}` names Old_Italic.
const std = @import("std");
const codec = @import("codec");
const errors = @import("../errors.zig");
const unicode = @import("unicode");
const utf8 = @import("utf8");
const utf8_ranges = @import("../utf8_ranges.zig");
const escape = @import("syntax_escape.zig");
const NamedClass = @import("../scalar_set.zig").NamedClass;

/// The property after a `\p` that was just read, or after a `\P` with `negated`.
pub fn take(reader: *codec.Reader, negated: bool) errors.Error!NamedClass {
    // RFC 9485 §3: catEsc = "\p{" charProp "}", so a property follows the "\p".
    const first = (try utf8_ranges.take_scalar(reader)) orelse return error.InvalidProperty;
    var negate = negated;
    var name: []const u8 = undefined;
    if (first == '{') {
        // RE2's form, which RFC 9485 §3 does not hold: `\p{^Greek}` is `\P{Greek}`.
        if (escape.take_if(reader, '^')) negate = !negate;
        name = try braced(reader);
    } else {
        name = last_character(reader, first);
    }
    // RFC 9485 §3: charProp names a General_Category value. stdx takes UTS #18 RL1.2's properties
    // too, each by a name `unicode.property` takes.
    const ranges = unicode.property(name) orelse return error.InvalidProperty;
    return .{ .ranges = ranges, .negated = negate };
}

/// The octets of the character just read: a name of one character, as `\pL` has.
fn last_character(reader: *codec.Reader, first: u32) []const u8 {
    const len = utf8.encoded_len(@intCast(first));
    reader.unread(len);
    return reader.take(len) catch unreachable;
}

/// The octets after a `{` up to the `}` that ends them, which is read too.
fn braced(reader: *codec.Reader) errors.Error![]const u8 {
    const remaining = reader.remaining_len();
    for (0..remaining) |len| {
        const octet = reader.take_octet() catch unreachable;
        if (octet != '}') continue;
        reader.unread(len + 1);
        const name = reader.take(len) catch unreachable;
        _ = reader.take_octet() catch unreachable;
        return name;
    }
    // RFC 9485 §3: catEsc = "\p{" charProp "}", which ends with a "}".
    return error.InvalidProperty;
}

const testing = std.testing;

/// The property of a text, which must leave `left` octets unread.
fn take_text(text: []const u8, negated: bool, left: usize) !NamedClass {
    var reader = codec.Reader.init(text);
    const named = try take(&reader, negated);
    try testing.expectEqual(left, reader.remaining_len());
    return named;
}

test "a property is one character or a name in braces, each a name unicode.property takes" {
    const letters = unicode.property("L").?;
    try testing.expectEqual(letters.ptr, (try take_text("L", false, 0)).ranges.ptr);
    try testing.expectEqual(letters.ptr, (try take_text("{L}", false, 0)).ranges.ptr);
    try testing.expectEqual(letters.ptr, (try take_text("{Letter}x", false, 1)).ranges.ptr);
    try testing.expectEqual(unicode.property("Old_Italic").?.ptr, (try take_text("{old italic}", false, 0)).ranges.ptr);
    // One character after the `p` is the whole name: `\pLu` is `\pL` and a `u`.
    try testing.expectEqual(letters.ptr, (try take_text("Lu", false, 1)).ranges.ptr);
}

test "a ^ first in the braces negates the property, and a \\P negates it again" {
    try testing.expect(!(try take_text("{Greek}", false, 0)).negated);
    try testing.expect((try take_text("{^Greek}", false, 0)).negated);
    try testing.expect((try take_text("{Greek}", true, 0)).negated);
    try testing.expect(!(try take_text("{^Greek}", true, 0)).negated);
    try testing.expect((try take_text("L", true, 0)).negated);
}

test "a property that names nothing, or has no name or no closing brace, is refused" {
    const refused = [_][]const u8{ "", "{", "{L", "{}", "{^}", "X", "{IsGreek}", "{Latn}", "\xC3\xA9", "^L", "{ ^L}" };
    for (refused) |text| {
        var reader = codec.Reader.init(text);
        try testing.expectError(error.InvalidProperty, take(&reader, false));
    }
}
