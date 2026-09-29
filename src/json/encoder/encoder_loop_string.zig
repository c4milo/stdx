//! Claim J11's names and strings that are not all plain ASCII (decision 16's JSON encoder token
//! loop): it copies the runs a string carries as they are, plain ASCII and whole UTF-8 characters
//! (RFC 8259 §7, RFC 3629 §4), and writes each octet a string must escape as encoder_content.zig
//! does. Left to the checked path an octet at a time, strings with escapes encoded 2 to 4 times
//! slower than simdjson's on the N2 (design §8 step 18).
//!
//! Anything else leaves the string, whole, to the checked path, which names every refusal: a
//! character UTF-8 rules out or that the string cuts, and a room too short for the string. It reads
//! and writes the slices it is given, whose bounds Zig checks (ReleaseSafe).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const scan = @import("../scan.zig");
const wide = @import("../wide.zig");
const Claims = @import("../claims.zig").Claims;
const string_walk = @import("../string_walk.zig");
const Walk = string_walk.Walk;
const Stop = string_walk.Stop;

/// The octets of the two-character escape of a quotation mark, a reverse solidus or a control
/// character that has one, and of `\u00` and two digits for a control character that has none.
const letter_escape_len = 2;
const control_escape_len = constants.control_escape_prefix.len + constants.hex_digits_per_octet;

/// The escape letter of each control character that has one, or null. A quotation mark's and a
/// reverse solidus's letters are themselves.
const escape_letters = table: {
    var letters: [constants.unescaped_min]?u8 = @splat(null);
    for (constants.escape_letters, constants.escaped_characters) |letter, character| {
        if (character < constants.unescaped_min) letters[character] = letter;
    }
    break :table letters;
};

/// Writes the content of a string whose octets are `octets` into `room`, escaped as RFC 8259 §7
/// requires, and returns how many octets it wrote; or null where the checked path must take it.
pub fn copy_escaped(comptime claims: Claims, level: wide.Level, octets: []const u8, room: []u8) ?usize {
    var walk: Walk = .{ .input = octets, .output = room };
    // Each pass takes at least one octet, or returns.
    for (0..octets.len + 1) |_| {
        // Short of a block, or with claim J5 off, the run's scans take the octets.
        const stop: Stop = if (claims.utf8_vectors) walk.take_blocks(octets, room) else .short;
        switch (stop) {
            .ruled_out => return null,
            .short => walk.take_run(claims, level),
            .octet => {},
        }
        if (walk.input.len == 0) return room.len - walk.output.len;
        const octet = walk.input[0];
        // A character UTF-8 rules out or the string cuts, or an octet the room stopped.
        if (octet >= constants.non_ascii_min or scan.is_plain_ascii(octet)) return null;
        walk.take(1, escape(octet, walk.output) orelse return null);
    }
    unreachable;
}

/// Writes the escape of `octet`, a quotation mark, a reverse solidus or a control character (RFC
/// 8259 §7), at the start of `room`: its two-character form where it has one, and else `\u00` and
/// two lowercase digits. Returns its length, or null when `room` is too short for it.
fn escape(octet: u8, room: []u8) ?usize {
    assert(octet < constants.unescaped_min or octet == constants.quotation_mark or octet == constants.reverse_solidus);
    const letter = if (octet < constants.unescaped_min) escape_letters[octet] else octet;
    if (letter) |named| {
        if (room.len < letter_escape_len) return null;
        room[0..letter_escape_len].* = .{ constants.reverse_solidus, named };
        return letter_escape_len;
    }
    if (room.len < control_escape_len) return null;
    room[0..constants.control_escape_prefix.len].* = constants.control_escape_prefix.*;
    room[constants.control_escape_prefix.len..][0..constants.hex_digits_per_octet].* = .{
        constants.hex_digits_lower[octet >> constants.nibble_bits],
        constants.hex_digits_lower[octet & constants.nibble_mask],
    };
    return control_escape_len;
}
