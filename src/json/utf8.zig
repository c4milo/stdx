//! UTF-8 validation, one octet at a time, as RFC 3629 §4's syntax defines it: the scalar path the
//! encoder and the decoder check every non-ASCII octet of a string with, which keeps a character
//! split across calls in its state, and the reference the vector path of claim J5 must match.
//!
//! JSON text exchanged between systems must be UTF-8 (RFC 8259 §8.1), and a string holds
//! characters (RFC 8259 §7), so the encoder refuses input that is not UTF-8 and the decoder refuses
//! a text that is not.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// Where a validation stands between octets.
pub const Utf8 = struct {
    /// The continuation octets the character in progress still needs: 0 between characters.
    needed: u2 = 0,
    /// The least and the greatest octet the next continuation octet may be.
    low: u8 = constants.continuation_min,
    high: u8 = constants.continuation_max,

    /// True between characters, when no continuation octet is owed.
    pub fn between_characters(self: Utf8) bool {
        return self.needed == 0;
    }

    /// Takes the next octet. Returns false when UTF-8 cannot hold it there (RFC 3629 §4), and then
    /// the state is left as it was.
    pub fn accept(self: *Utf8, octet: u8) bool {
        if (self.needed > 0) return self.accept_continuation(octet);
        if (octet < constants.non_ascii_min) return true;
        return self.accept_first(octet);
    }

    fn accept_continuation(self: *Utf8, octet: u8) bool {
        assert(self.needed > 0);
        if (octet < self.low or octet > self.high) return false;
        self.needed -= 1;
        self.low = constants.continuation_min;
        self.high = constants.continuation_max;
        return true;
    }

    /// Takes the first octet of a character of two to four octets (RFC 3629 §4: UTF8-2, UTF8-3 and
    /// UTF8-4), and the range of the octet after it.
    fn accept_first(self: *Utf8, octet: u8) bool {
        assert(self.needed == 0 and octet >= constants.non_ascii_min);
        if (octet < constants.lead_2_min or octet >= constants.invalid_min) return false;
        self.needed = 1 + @as(u2, @intFromBool(octet >= constants.lead_3_min)) + @intFromBool(octet >= constants.lead_4_min);
        self.low = switch (octet) {
            constants.lead_3_overlong => constants.lead_3_overlong_second_min,
            constants.lead_4_overlong => constants.lead_4_overlong_second_min,
            else => constants.continuation_min,
        };
        self.high = switch (octet) {
            constants.lead_3_surrogate => constants.lead_3_surrogate_second_max,
            constants.lead_4_largest => constants.lead_4_largest_second_max,
            else => constants.continuation_max,
        };
        return true;
    }
};

/// The octets of the character that starts `octets`, when they hold all of it and it is UTF-8, or
/// null.
pub fn character_len(octets: []const u8) ?usize {
    var utf8: Utf8 = .{};
    for (octets, 1..) |octet, len| {
        if (!utf8.accept(octet)) return null;
        if (utf8.between_characters()) return len;
    }
    return null;
}

// Tests.

const testing = std.testing;

fn is_utf8(octets: []const u8) bool {
    var utf8: Utf8 = .{};
    for (octets) |octet| {
        if (!utf8.accept(octet)) return false;
    }
    return utf8.between_characters();
}

/// RFC 3629 §4's syntax spelled out a second time, apart from `Utf8`, for the tests to judge by.
const Rules = struct {
    const one_octet_max = 0x7f;
    const two_octets_first_min = 0xc2;
    const two_octets_first_max = 0xdf;
    const three_octets_first_min = 0xe0;
    const three_octets_first_max = 0xef;
    const four_octets_first_min = 0xf0;
    const four_octets_first_max = 0xf4;
    const tail_min = 0x80;
    const tail_max = 0xbf;
    /// UTF8-3's `%xE0 %xA0-BF` and `%xED %x80-9F`, and UTF8-4's `%xF0 %x90-BF` and `%xF4 %x80-8F`.
    const after_e0_min = 0xa0;
    const surrogates_first = 0xed;
    const after_ed_max = 0x9f;
    const after_f0_min = 0x90;
    const after_f4_max = 0x8f;
    const two_octets = 2;
    const three_octets = 3;
    const four_octets = 4;

    fn is_utf8(octets: []const u8) bool {
        var index: usize = 0;
        while (index < octets.len) index += character(octets[index..]) orelse return false;
        return true;
    }

    fn character(octets: []const u8) ?usize {
        const first = octets[0];
        if (first <= one_octet_max) return 1;
        const len = length(first) orelse return null;
        if (octets.len < len or !second_in_range(first, octets[1])) return null;
        for (octets[two_octets..len]) |octet| {
            if (octet < tail_min or octet > tail_max) return null;
        }
        return len;
    }

    fn length(first: u8) ?usize {
        if (first >= two_octets_first_min and first <= two_octets_first_max) return two_octets;
        if (first >= three_octets_first_min and first <= three_octets_first_max) return three_octets;
        if (first >= four_octets_first_min and first <= four_octets_first_max) return four_octets;
        return null;
    }

    fn second_in_range(first: u8, second: u8) bool {
        const low: u8 = if (first == three_octets_first_min) after_e0_min else if (first == four_octets_first_min) after_f0_min else tail_min;
        const high: u8 = if (first == surrogates_first) after_ed_max else if (first == four_octets_first_max) after_f4_max else tail_max;
        return second >= low and second <= high;
    }
};

test "every sequence of up to three octets is judged as RFC 3629 §4 judges it" {
    var octets: [3]u8 = undefined;
    for (0..256) |first| for (0..256) |second| for (0..256) |third| {
        octets = .{ @intCast(first), @intCast(second), @intCast(third) };
        try testing.expectEqual(Rules.is_utf8(octets[0..3]), is_utf8(octets[0..3]));
        try testing.expectEqual(Rules.is_utf8(octets[0..2]), is_utf8(octets[0..2]));
        try testing.expectEqual(Rules.is_utf8(octets[0..1]), is_utf8(octets[0..1]));
    };
}

test "every sequence of four octets at each range's edges is judged as RFC 3629 §4 judges it" {
    const edges = [_]u8{ 0x00, 0x7f, 0x80, 0x8f, 0x90, 0x9f, 0xa0, 0xbf, 0xc0, 0xc1, 0xc2, 0xdf, 0xe0, 0xe1, 0xec, 0xed, 0xee, 0xef, 0xf0, 0xf1, 0xf3, 0xf4, 0xf5, 0xff };
    var octets: [4]u8 = undefined;
    for (edges) |a| for (edges) |b| for (edges) |c| for (edges) |d| {
        octets = .{ a, b, c, d };
        try testing.expectEqual(Rules.is_utf8(&octets), is_utf8(&octets));
    };
}

test "a refused octet leaves the state as it was" {
    var utf8: Utf8 = .{};
    try testing.expect(utf8.accept(0xe0));
    const before = utf8;
    try testing.expect(!utf8.accept(0x9f));
    try testing.expectEqual(before, utf8);
    try testing.expect(utf8.accept(0xa0));
    try testing.expect(utf8.accept(0x80));
    try testing.expect(utf8.between_characters());
}

test "character_len takes one whole character, and nothing of a cut or invalid one" {
    try testing.expectEqual(1, character_len("a").?);
    try testing.expectEqual(2, character_len("\xc3\xa9x").?);
    try testing.expectEqual(3, character_len("\xe2\x82\xac").?);
    try testing.expectEqual(4, character_len("\xf0\x9d\x84\x9e").?);
    try testing.expectEqual(null, character_len("\xf0\x9d\x84"));
    try testing.expectEqual(null, character_len("\xed\xa0\x80"));
    try testing.expectEqual(null, character_len(""));
}
