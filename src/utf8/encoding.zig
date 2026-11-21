//! The UTF-8 of one code point (RFC 3629 §3): its length, its octets, and the code point that the
//! octets of one character hold.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// The octets of `code_point`'s UTF-8, for a code point that is no surrogate and at most U+10FFFF
/// (RFC 3629 §3).
pub inline fn encoded_len(code_point: u21) usize {
    assert(code_point <= constants.code_point_max);
    return 1 + @as(usize, @intFromBool(code_point > constants.one_octet_max)) + @intFromBool(code_point > constants.two_octets_max) + @intFromBool(code_point > constants.three_octets_max);
}

/// Writes `code_point`'s UTF-8 into `octets`, `encoded_len` of them (RFC 3629 §3). Inline, one length
/// at a time: std.unicode's `utf8Encode` took a call at each `\u` escape, about an eighth of
/// decoding a text of them on the N2 (design §8 step 18).
pub inline fn encode(code_point: u21, octets: []u8) void {
    inline for (1..constants.utf8_len_max + 1) |len| {
        if (octets.len == len) {
            octets[0..len].* = encoded(len, code_point);
            return;
        }
    }
    unreachable;
}

/// `code_point`'s UTF-8 in `len` octets: the first holds `len`'s mark and the highest bits, and each
/// after it the continuation octet's mark and the next `continuation_bits` (RFC 3629 §3).
pub inline fn encoded(comptime len: usize, code_point: u21) [len]u8 {
    var octets: [len]u8 = undefined;
    octets[0] = constants.lead_marks[len] | @as(u8, @intCast(code_point >> (len - 1) * constants.continuation_bits));
    inline for (1..len) |index| {
        const bits: u8 = @truncate(code_point >> (len - 1 - index) * constants.continuation_bits);
        octets[index] = constants.continuation_min | (bits & constants.continuation_mask);
    }
    return octets;
}

/// The code point of the one character that `character` holds (RFC 3629 §3). The caller checked
/// the octets, with `character_len` or a `Validator`: they are one whole character of UTF-8.
pub fn decode(character: []const u8) u21 {
    assert(character.len >= 1 and character.len <= constants.utf8_len_max);
    assert(character.len == 1 or character[0] >= constants.lead_marks[character.len]);
    var code_point: u21 = character[0] ^ constants.lead_marks[character.len];
    for (character[1..]) |octet| {
        code_point = (code_point << constants.continuation_bits) | (octet & constants.continuation_mask);
    }
    return code_point;
}

// Tests.

const testing = std.testing;
const character_len = @import("validator.zig").character_len;

fn is_surrogate(code_point: u21) bool {
    return code_point >= constants.surrogate_min and code_point <= constants.surrogate_max;
}

test "encode writes every code point outside the surrogates as std.unicode does" {
    for (0..constants.code_point_max + 1) |value| {
        const code_point: u21 = @intCast(value);
        if (is_surrogate(code_point)) continue;
        var expected: [constants.utf8_len_max]u8 = undefined;
        const expected_len = try std.unicode.utf8Encode(code_point, &expected);
        try testing.expectEqual(expected_len, encoded_len(code_point));
        var octets: [constants.utf8_len_max]u8 = undefined;
        encode(code_point, octets[0..expected_len]);
        try testing.expectEqualSlices(u8, expected[0..expected_len], octets[0..expected_len]);
    }
}

test "decode gives back every code point that encode writes, and character_len its length" {
    for (0..constants.code_point_max + 1) |value| {
        const code_point: u21 = @intCast(value);
        if (is_surrogate(code_point)) continue;
        var octets: [constants.utf8_len_max]u8 = undefined;
        const len = encoded_len(code_point);
        encode(code_point, octets[0..len]);
        try testing.expectEqual(len, character_len(octets[0..len]).?);
        try testing.expectEqual(code_point, decode(octets[0..len]));
    }
}

test "decode reads the first and the last code point of each length" {
    try testing.expectEqual(0x00, decode("\x00"));
    try testing.expectEqual(0x7f, decode("\x7f"));
    try testing.expectEqual(0x80, decode("\xc2\x80"));
    try testing.expectEqual(0x7ff, decode("\xdf\xbf"));
    try testing.expectEqual(0x800, decode("\xe0\xa0\x80"));
    try testing.expectEqual(0xffff, decode("\xef\xbf\xbf"));
    try testing.expectEqual(0x10000, decode("\xf0\x90\x80\x80"));
    try testing.expectEqual(0x10ffff, decode("\xf4\x8f\xbf\xbf"));
}
