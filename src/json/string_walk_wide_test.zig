//! The decoder's walk at 32 octets a block past a run's ASCII (string_walk_wide.zig) against the
//! walk at 16: `copy_rest` must take and write the same octets, or leave the string to the checked
//! path at both widths. Seeded strings of Cyrillic and CJK characters, ASCII, escapes and octets
//! UTF-8 rules out; a stop at every lane of two blocks; characters across a block's edge; short
//! inputs and rooms; and the hand-off from the ASCII loop at every lane. On x86-64 with AVX2 the
//! wide walk judges UTF-8 by the lookup, and elsewhere by the compares.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const claims = @import("claims.zig");
const wide = @import("wide.zig");
const wide_walk = @import("string_walk_wide.zig");
const loop_string = @import("decoder/decoder_loop/decoder_loop_string.zig");

const narrow_len = constants.vector_len;
const wide_len = wide_walk.block_len;

/// The longest string a test walks, and its room: unescaping never writes more than it reads.
const string_blocks_max = 8;
const string_len_max = string_blocks_max * wide_len;

fn level_here() wide.Level {
    return wide.Level.of(codec.Features.detect());
}

/// Requires `copy_rest` to copy `rest` alike at both widths into `room_len` octets: the same
/// octets taken and written, or the string left to the checked path at both.
fn expect_same_copy(rest: []const u8, room_len: usize) !void {
    var narrow_room: [string_len_max]u8 = undefined;
    var wide_room: [string_len_max]u8 = undefined;
    const level = level_here();
    const by_narrow = loop_string.copy_rest(claims.vector, narrow_len, level, rest, narrow_room[0..room_len]);
    const by_wide = loop_string.copy_rest(claims.vector, wide_len, level, rest, wide_room[0..room_len]);
    try testing.expectEqual(by_narrow, by_wide);
    if (by_narrow) |copied| try testing.expectEqualSlices(u8, narrow_room[0..copied.output_len], wide_room[0..copied.output_len]);
}

/// A string of `len` octets that starts with a Cyrillic character, so the walk goes to its blocks
/// at the first octet, then `filler` to its end, closed by a quotation mark at `len`.
fn led_string(storage: []u8, len: usize, filler: u8) []u8 {
    const lead = "д";
    @memcpy(storage[0..lead.len], lead);
    @memset(storage[lead.len..len], filler);
    storage[len] = constants.quotation_mark;
    return storage[0 .. len + 1];
}

/// What stops a run, or ends it with the string: each must stop both walks at the same octet.
const stops = [_][]const u8{
    "\"",           "\\n",          "\\u0436",          "\\\\",
    "\x00",         "\x1f",         "\x80",             "\xbf",
    "\xc0\x80",     "\xc1\xbf",     "\xf5\x80\x80\x80", "\xff",
    "\xe0\x80\x80", "\xed\xa0\x80", "\xf0\x80\x80\x80", "\xf4\x90\x80\x80",
    "\xd0",         "\xe4\xb8",     "\xf0\x9f\x98",
};

test "a stop at every lane of two wide blocks stops both widths alike" {
    for (stops) |stop| {
        for (0..2 * wide_len) |lane| {
            var storage: [string_len_max]u8 = undefined;
            const string = led_string(&storage, 4 * wide_len, 'a');
            const at = @max(lane, "д".len);
            @memcpy(string[at..][0..stop.len], stop);
            for ([_]usize{ string.len, string.len / 2, wide_len + 1 }) |room_len| try expect_same_copy(string, room_len);
        }
    }
}

/// Characters of every length that UTF-8 holds, and one first octet each with what follows it cut.
const characters = [_][]const u8{ "ж", "中", "😀", "\xd0a", "\xe4\xb8a", "\xf0\x9f\x98a" };

test "a character across a wide block's edge is judged alike at both widths" {
    for (characters) |character| {
        for (wide_len - character.len..wide_len + 1) |start| {
            for ([_]usize{ 0, wide_len }) |block| {
                var storage: [string_len_max]u8 = undefined;
                const string = led_string(&storage, 4 * wide_len, 'b');
                @memcpy(string[block + start ..][0..character.len], character);
                try expect_same_copy(string, string.len);
            }
        }
    }
}

/// Requires the walk to stop alike at both widths over `stretch`, whether or not a quotation mark
/// closes it: where it stopped, and the octets it wrote.
fn expect_same_walk(stretch: []const u8, room_len: usize) !void {
    var narrow_room: [string_len_max]u8 = undefined;
    var wide_room: [string_len_max]u8 = undefined;
    const level = level_here();
    const by_narrow = loop_string.walk_stretch(claims.vector, narrow_len, level, stretch, narrow_room[0..room_len]);
    const by_wide = loop_string.walk_stretch(claims.vector, wide_len, level, stretch, wide_room[0..room_len]);
    try testing.expectEqual(by_narrow, by_wide);
    const written = room_len - by_narrow.output_left;
    try testing.expectEqualSlices(u8, narrow_room[0..written], wide_room[0..written]);
}

test "short strings and rooms, cut at every octet, stop both walks at the same octet" {
    // Runs of 56 octets between escapes, so a wide block passes a character's edge before each.
    const text = ("дж中😀 ab" ** 4 ++ "\\n") ** 4;
    for (0..3 * wide_len) |len| {
        for ([_]usize{ len, len / 2, len -| 1, len + 1 }) |room_len| {
            try expect_same_walk(text[0..len], @min(room_len, string_len_max));
        }
    }
}

test "the hand-off from the ASCII loop at every lane goes on alike at both widths" {
    for (0..4 * narrow_len) |ascii_len| {
        var storage: [string_len_max]u8 = undefined;
        @memset(storage[0..ascii_len], 'c');
        const rest = "жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж\\tжжжжжжжжжжжжжжжж\"";
        @memcpy(storage[ascii_len..][0..rest.len], rest);
        try expect_same_copy(storage[0 .. ascii_len + rest.len], string_len_max);
    }
}

/// What a seeded string draws from: characters of every length, ASCII, escapes, and seldom an
/// octet UTF-8 rules out or a control character a string must escape.
const pieces = [_][]const u8{ "д", "ж", "中", "語", "😀", "a", " ", "\\n", "\\\"", "\\u0436", "\\ud83d\\ude00" };
const refused = [_][]const u8{ "\x80", "\xc0", "\xff", "\x01", "\xed\xa0\x80", "\xe4\xb8" };
const seeded_cases = 2000;

test "seeded strings of Cyrillic and CJK characters, escapes and refused octets copy alike at both widths" {
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        var storage: [string_len_max]u8 = undefined;
        var len: usize = 0;
        const refuses = generator.below(8) == 0;
        while (len + 16 < string_len_max) {
            const piece = if (refuses and generator.below(64) == 0) refused[@intCast(generator.below(refused.len))] else pieces[@intCast(generator.below(pieces.len))];
            @memcpy(storage[len..][0..piece.len], piece);
            len += piece.len;
            if (generator.below(string_len_max) == 0) break;
        }
        storage[len] = constants.quotation_mark;
        const room_len: usize = @intCast(generator.below(len + 2));
        try expect_same_copy(storage[0 .. len + 1], room_len);
    }
}
