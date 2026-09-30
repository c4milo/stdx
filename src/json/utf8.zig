//! UTF-8 validation, one octet at a time, as RFC 3629 §4's syntax defines it: the scalar path the
//! encoder and the decoder check every non-ASCII octet of a string with, which keeps a character
//! split across calls in its state, and the reference the vector path of claim J5 must match. And
//! the UTF-8 of a code point (RFC 3629 §3), which the decoder writes for a `\u` escape.
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

/// The steps of spec/lean/Stdx/Json/Utf8.lean's machine, which the proofs there hold to RFC 3629
/// §4 (decision 28): a line per state and octet, the state as `Utf8`'s fields, the octet, and then
/// the fields after it or `refused`. `zig build lean` checks the file is what that machine gives.
const Proved = struct {
    const vectors = @embedFile("utf8_vectors.txt");
    const states = 8;
    const octets = 256;
    const radix = 10;
    /// A state's fields: `needed`, `low` and `high`.
    const state_len = 3;
    /// A refused step's fields: a state, the octet and `refused`.
    const refused_len = 5;
    /// A step's fields: a state, the octet and the state after it.
    const step_len = 7;

    fn step(line: []const u8) !void {
        var fields: [step_len][]const u8 = undefined;
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        var len: usize = 0;
        while (tokens.next()) |token| : (len += 1) {
            if (len == step_len) return error.TestVectorTooLong;
            fields[len] = token;
        }
        const before = try state(fields[0..state_len]);
        const octet = try std.fmt.parseInt(u8, fields[state_len], radix);
        var utf8 = before;
        if (len == refused_len) {
            try testing.expectEqualStrings("refused", fields[state_len + 1]);
            try testing.expect(!utf8.accept(octet));
            return testing.expectEqual(before, utf8);
        }
        try testing.expectEqual(step_len, len);
        try testing.expect(utf8.accept(octet));
        try testing.expectEqual(try state(fields[state_len + 1 ..]), utf8);
    }

    fn state(fields: []const []const u8) !Utf8 {
        return .{
            .needed = try std.fmt.parseInt(u2, fields[0], radix),
            .low = try std.fmt.parseInt(u8, fields[1], radix),
            .high = try std.fmt.parseInt(u8, fields[state_len - 1], radix),
        };
    }
};

test "Utf8 takes every step of the machine proved to accept exactly RFC 3629 §4's UTF-8" {
    var lines = std.mem.splitScalar(u8, Proved.vectors, '\n');
    try testing.expect(std.mem.startsWith(u8, lines.first(), "#"));
    var steps: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        try Proved.step(line);
        steps += 1;
    }
    try testing.expectEqual(Proved.states * Proved.octets, steps);
    try testing.expectEqual(Utf8{}, try Proved.state(&.{ "0", "128", "191" }));
}

test "encode writes every code point outside the surrogates as std.unicode does" {
    for (0..constants.code_point_max + 1) |value| {
        const code_point: u21 = @intCast(value);
        if (code_point >= constants.high_surrogate_min and code_point <= constants.surrogate_max) continue;
        var expected: [constants.utf8_len_max]u8 = undefined;
        const expected_len = try std.unicode.utf8Encode(code_point, &expected);
        try testing.expectEqual(expected_len, encoded_len(code_point));
        var octets: [constants.utf8_len_max]u8 = undefined;
        encode(code_point, octets[0..expected_len]);
        try testing.expectEqualSlices(u8, expected[0..expected_len], octets[0..expected_len]);
    }
}
