//! Claim J10's strings past their plain ASCII (decision 16's JSON decoder token loop): a name's or
//! a string's content once its run of plain ASCII stops at an octet other than its closing
//! quotation mark. It copies the runs a string carries as they are, plain ASCII and whole UTF-8
//! characters (RFC 8259 §7, RFC 3629 §4), and writes each escape RFC 8259 §7 names as the UTF-8 of
//! its character, as decoder_string.zig does. Left to the checked path, the loop's strings with
//! escapes ran 3 to 9 times slower than simdjson's on the N2 (design §8 step 18).
//!
//! Anything else leaves the string, whole, to the checked path, which names every refusal: an
//! escape it refuses or that the input cuts, a lone surrogate, a control character, a character
//! UTF-8 rules out or that the input cuts, and input or room that ends first. It reads and writes
//! the slices it is given, whose bounds Zig checks (ReleaseSafe).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const scan = @import("../scan.zig");
const wide = @import("../wide.zig");
const Claims = @import("../claims.zig").Claims;
const string_walk = @import("../string_walk.zig");
const Walk = string_walk.Walk;
const hex_value = @import("decoder_string.zig").hex_value;

/// What a string's content took: its octets in the input, up to its closing quotation mark, and
/// the octets written for them.
pub const Copied = struct { input_len: usize, output_len: usize };

/// The octets of an escape of a reverse solidus and a letter, of one of `\u` and its digits, and of
/// a surrogate pair's two.
const letter_escape_len = 2;
const unicode_escape_len = letter_escape_len + constants.escape_hex_digits;
const pair_escape_len = unicode_escape_len + unicode_escape_len;

/// The character each escape letter names, or null for an octet that is no escape letter.
const escaped_characters = table: {
    var characters: [std.math.maxInt(u8) + 1]?u8 = @splat(null);
    for (constants.escape_letters, constants.escaped_characters) |letter, character| characters[letter] = character;
    break :table characters;
};

/// Each octet's value as a hexadecimal digit of either case, or `not_hex_digit` for an octet that
/// is none: a load a digit, and one test for a `\u` escape's four, where `hex_value`'s ranges took
/// tests at each digit.
const hex_digit_values = table: {
    var values: [std.math.maxInt(u8) + 1]u8 = @splat(not_hex_digit);
    for (&values, 0..) |*value, octet| value.* = hex_value(octet) orelse not_hex_digit;
    break :table values;
};
/// Past `hex_digit_max`, the largest digit's value, so four values OR'd together pass it when one
/// of them is no digit's.
const not_hex_digit = std.math.maxInt(u8);
const hex_digit_max = constants.nibble_mask;

/// The rest of a string's content, from `rest`, its input after the octets already copied, into
/// `room`, the output after them, whose runs `level`'s scans take. Returns what it took, or null
/// where the checked path must take the string.
pub fn copy_rest(comptime claims: Claims, level: wide.Level, rest: []const u8, room: []u8) ?Copied {
    var walk: Walk = .{ .input = rest, .output = room };
    // Each pass takes at least one octet, or returns.
    for (0..rest.len + 1) |_| {
        // An escape that follows an escape is taken at once, with no block walked to find it: a text
        // of lines that end in a carriage return and a line feed has two at each line's end.
        if (walk.input.len == 0 or walk.input[0] != constants.reverse_solidus) {
            if (!walk.take_to_stop(claims, level, rest, room)) return null;
            if (walk.input.len == 0) return null;
        }
        const escape = switch (walk.input[0]) {
            constants.quotation_mark => return .{ .input_len = rest.len - walk.input.len, .output_len = room.len - walk.output.len },
            constants.reverse_solidus => unescape(walk.input, walk.output) orelse return null,
            else => return null,
        };
        walk.take(escape.input_len, escape.output_len);
    }
    unreachable;
}

/// Writes the character the escape that starts `escape` names (RFC 8259 §7) at the start of
/// `room`, and returns the octets it took and wrote; or null for an escape the checked path
/// refuses, one the input cuts, and a room too short for its character. Inline, as are the
/// functions it calls: out of line, each escape paid a call and returned what it took through
/// memory, about a third of decoding a text of `\u` escapes.
inline fn unescape(escape: []const u8, room: []u8) ?Copied {
    assert(escape[0] == constants.reverse_solidus);
    if (escape.len < letter_escape_len or room.len == 0) return null;
    if (escape[1] == constants.escape_unicode) return unescape_unicode(escape, room);
    room[0] = escaped_characters[escape[1]] orelse return null;
    return .{ .input_len = letter_escape_len, .output_len = 1 };
}

/// A `\u` escape, or a high surrogate's and the low one's after it (RFC 8259 §7), written as the
/// UTF-8 of the character it names. A surrogate alone names none (RFC 8259 §8.2).
inline fn unescape_unicode(escape: []const u8, room: []u8) ?Copied {
    const unit = code_unit(escape, 0) orelse return null;
    const high = unit >= constants.high_surrogate_min and unit < constants.low_surrogate_min;
    if (!high and unit >= constants.low_surrogate_min and unit <= constants.surrogate_max) return null;
    var code_point: u21 = unit;
    if (high) {
        const low = code_unit(escape, unicode_escape_len) orelse return null;
        if (low < constants.low_surrogate_min or low > constants.surrogate_max) return null;
        const high_bits: u21 = unit - constants.high_surrogate_min;
        const low_bits: u21 = low - constants.low_surrogate_min;
        code_point = constants.supplementary_min + ((high_bits << constants.surrogate_bits) | low_bits);
    }
    // No surrogate, and at most U+10FFFF, so UTF-8 holds it (RFC 3629 §3).
    const len = std.unicode.utf8CodepointSequenceLength(code_point) catch unreachable;
    if (room.len < len) return null;
    _ = std.unicode.utf8Encode(code_point, room[0..len]) catch unreachable;
    const first: Copied = .{ .input_len = if (high) pair_escape_len else unicode_escape_len, .output_len = len };
    return unicode_run(escape, room, first);
}

/// `taken`, and the `\u` escapes that follow it at once while each names a character that is no
/// surrogate and the room holds its UTF-8 (RFC 8259 §7): a text whose non-ASCII characters are all
/// escaped, as Python's json.dumps writes by default, takes a word's with no walk between them.
inline fn unicode_run(escape: []const u8, room: []u8, taken: Copied) Copied {
    var run = taken;
    for (0..escape.len / unicode_escape_len) |_| {
        const unit = code_unit(escape[run.input_len..], 0) orelse break;
        if (unit >= constants.high_surrogate_min and unit <= constants.surrogate_max) break;
        const len = std.unicode.utf8CodepointSequenceLength(unit) catch unreachable;
        if (room.len - run.output_len < len) break;
        _ = std.unicode.utf8Encode(unit, room[run.output_len..][0..len]) catch unreachable;
        run.input_len += unicode_escape_len;
        run.output_len += len;
    }
    return run;
}

/// The code unit of the `\u` escape at `offset` in `escape`, from its four hexadecimal digits of
/// either case; or null when the escape is not there, or cut, or a digit is not one.
inline fn code_unit(escape: []const u8, offset: usize) ?u16 {
    if (escape.len - offset < unicode_escape_len) return null;
    if (escape[offset] != constants.reverse_solidus or escape[offset + 1] != constants.escape_unicode) return null;
    var unit: u16 = 0;
    var any: u8 = 0;
    for (escape[offset + letter_escape_len ..][0..constants.escape_hex_digits]) |digit| {
        const value = hex_digit_values[digit];
        any |= value;
        unit = unit << constants.nibble_bits | (value & hex_digit_max);
    }
    return if (any > hex_digit_max) null else unit;
}
