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

/// The rest of a string's content, from `rest`, its input after the octets already copied, into
/// `room`, the output after them, whose runs `level`'s scans take. Returns what it took, or null
/// where the checked path must take the string.
pub fn copy_rest(comptime claims: Claims, level: wide.Level, rest: []const u8, room: []u8) ?Copied {
    var copied: Copied = .{ .input_len = 0, .output_len = 0 };
    // Each pass takes at least one octet, or returns.
    for (0..rest.len + 1) |_| {
        const window = rest[copied.input_len..][0..@min(rest.len - copied.input_len, room.len - copied.output_len)];
        const run_len = run_of(claims, level, window);
        scan.copy(room[copied.output_len..][0..run_len], window[0..run_len]);
        copied.input_len += run_len;
        copied.output_len += run_len;
        if (copied.input_len == rest.len) return null;
        const escape = switch (rest[copied.input_len]) {
            constants.quotation_mark => return copied,
            constants.reverse_solidus => unescape(rest[copied.input_len..], room[copied.output_len..]) orelse return null,
            else => return null,
        };
        copied.input_len += escape.input_len;
        copied.output_len += escape.output_len;
    }
    unreachable;
}

/// The run of octets a string carries as they are that starts `window`: plain ASCII at `level`'s
/// width (claim J7), and past a non-ASCII octet, whole UTF-8 characters too (claim J5).
inline fn run_of(comptime claims: Claims, level: wide.Level, window: []const u8) usize {
    const plain_len = wide.plain_len(level.with(claims), window);
    if (plain_len == window.len or window[plain_len] < constants.non_ascii_min) return plain_len;
    const rest = window[plain_len..];
    return plain_len + if (claims.utf8_vectors) scan.content_len_vector(constants.vector_len, rest) else scan.content_len_scalar(rest);
}

/// Writes the character the escape that starts `escape` names (RFC 8259 §7) at the start of
/// `room`, and returns the octets it took and wrote; or null for an escape the checked path
/// refuses, one the input cuts, and a room too short for its character.
fn unescape(escape: []const u8, room: []u8) ?Copied {
    assert(escape[0] == constants.reverse_solidus);
    if (escape.len < letter_escape_len or room.len == 0) return null;
    if (escape[1] == constants.escape_unicode) return unescape_unicode(escape, room);
    room[0] = escaped_characters[escape[1]] orelse return null;
    return .{ .input_len = letter_escape_len, .output_len = 1 };
}

/// A `\u` escape, or a high surrogate's and the low one's after it (RFC 8259 §7), written as the
/// UTF-8 of the character it names. A surrogate alone names none (RFC 8259 §8.2).
fn unescape_unicode(escape: []const u8, room: []u8) ?Copied {
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
    return .{ .input_len = if (high) pair_escape_len else unicode_escape_len, .output_len = len };
}

/// The code unit of the `\u` escape at `offset` in `escape`, from its four hexadecimal digits of
/// either case; or null when the escape is not there, or cut, or a digit is not one.
fn code_unit(escape: []const u8, offset: usize) ?u16 {
    if (escape.len - offset < unicode_escape_len) return null;
    if (escape[offset] != constants.reverse_solidus or escape[offset + 1] != constants.escape_unicode) return null;
    var unit: u16 = 0;
    for (escape[offset + letter_escape_len ..][0..constants.escape_hex_digits]) |digit| {
        unit = unit << constants.nibble_bits | (hex_value(digit) orelse return null);
    }
    return unit;
}
