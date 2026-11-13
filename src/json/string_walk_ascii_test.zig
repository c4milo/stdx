//! The walk's ASCII loop at 64 octets a pass, in the walks whose blocks are the wide ones
//! (decision 80), against the walks at 16. The decoder's `copy_rest` and `walk_stretch` must take
//! and write the same octets, or leave the string to the checked path, at both widths; the
//! encoder's `copy_escaped` must write the same octets, or leave the string, at both. Plain ASCII
//! with a stop at every lane of three passes; inputs and rooms of every length around a pass's
//! edge; and seeded text whose runs between escapes vary in length, as silesia/reymont's do.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const claims = @import("claims.zig");
const wide = @import("wide.zig");
const wide_walk = @import("string_walk_wide.zig");
const loop_string = @import("decoder/decoder_loop/decoder_loop_string.zig");
const encoder_string = @import("encoder/encoder_loop/encoder_loop_string.zig");
const wide_test = @import("string_walk_wide_test.zig");

const pass_len = constants.ascii_pass_len;

/// The passes a test's string spans, past which a block of 16 is left.
const passes = 3;

/// The longest string a test walks: `passes` passes and a block of 16 past them.
const string_len_max = passes * pass_len + constants.vector_len;

/// The rooms each string is copied into.
const room_count = 6;

/// A string of `len` octets of `filler`, closed by a quotation mark at `len`.
fn ascii_string(storage: []u8, len: usize, filler: u8) []u8 {
    @memset(storage[0..len], filler);
    storage[len] = constants.quotation_mark;
    return storage[0 .. len + 1];
}

/// The rooms a string of `len` octets is copied into: every one, and those around a pass's edge.
fn rooms(len: usize) [room_count]usize {
    return .{ len + 1, len, len -| 1, pass_len + 1, pass_len, pass_len - 1 };
}

test "a stop at every lane of three passes stops both widths alike" {
    for (wide_test.stops) |stop| {
        for (0..3 * pass_len) |lane| {
            var storage: [string_len_max + 8]u8 = undefined;
            const string = ascii_string(&storage, string_len_max, 'a');
            @memcpy(string[lane..][0..stop.len], stop);
            for (rooms(string.len)) |room_len| try wide_test.expect_same_copy(string, @min(room_len, string.len));
        }
    }
}

test "inputs and rooms of every length around a pass's edge stop both walks alike" {
    var storage: [string_len_max + 8]u8 = undefined;
    // Escapes 40 octets apart, so a pass holds one or none, and a run crosses a pass's edge.
    const text = ("a" ** 38 ++ "\\n") ** 7;
    @memcpy(storage[0..string_len_max], text[0..string_len_max]);
    for (0..string_len_max + 1) |len| {
        for (rooms(len)) |room_len| try wide_test.expect_same_walk(storage[0..len], @min(room_len, string_len_max));
    }
}

test "the encoder escapes or leaves a stop at every lane of three passes alike at both widths" {
    for (wide_test.raw_stops) |stop| {
        for (0..3 * pass_len) |lane| {
            var storage: [string_len_max + 8]u8 = undefined;
            const string = ascii_string(&storage, string_len_max, 'a')[0..string_len_max];
            @memcpy(string[lane..][0..stop.len], stop);
            const room_lens = [_]usize{ 6 * string_len_max, string.len + 1, string.len, pass_len + 1, pass_len, pass_len - 1 };
            for (room_lens) |room_len| try wide_test.expect_same_escape(string, room_len);
        }
    }
}

/// What seeded text draws between its runs of ASCII: escapes, a quotation mark, characters of
/// two to four octets, and seldom an octet UTF-8 rules out or a control character.
const between = [_][]const u8{ "\\\\", "\\n", "\\\"", "\\u0436", "ж", "中", "😀" };
const refused = [_][]const u8{ "\x80", "\xff", "\x01", "\xe4\xb8" };
const raw_between = [_][]const u8{ "\\", "\n", "\"", "\t", "ж", "中", "😀" };
const seeded_cases = 2000;

/// The longest run of plain ASCII seeded text holds, and how seldom it draws from `refused`: one
/// text in `refusing_one_in`, and in it one piece in `refused_one_in`.
const run_len_max = 100;
const refusing_one_in = 8;
const refused_one_in = 16;

/// Seeded text: runs of plain ASCII from 0 to `run_len_max` octets long, each followed by a piece
/// of `pieces` or, seldom, of `refused`. Returns its length.
fn seeded_text(generator: *codec.testing.split.Generator, storage: []u8, pieces: []const []const u8) usize {
    const refuses = generator.below(refusing_one_in) == 0;
    var len: usize = 0;
    // Each pass adds a piece of an octet at least, or returns.
    for (0..storage.len + 1) |_| {
        const run_len: usize = @intCast(generator.below(run_len_max + 1));
        const piece = if (refuses and generator.below(refused_one_in) == 0) refused[@intCast(generator.below(refused.len))] else pieces[@intCast(generator.below(pieces.len))];
        if (len + run_len + piece.len + 1 > storage.len) return len;
        @memset(storage[len..][0..run_len], 'r');
        len += run_len;
        @memcpy(storage[len..][0..piece.len], piece);
        len += piece.len;
    }
    unreachable;
}

test "seeded text with runs of every length between escapes copies alike at both widths" {
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        var storage: [string_len_max + 8]u8 = undefined;
        const len = seeded_text(&generator, storage[0..string_len_max], &between);
        storage[len] = constants.quotation_mark;
        const room_len: usize = @intCast(generator.below(len + 2));
        try wide_test.expect_same_copy(storage[0 .. len + 1], room_len);
    }
}

test "the encoder writes seeded text with runs of every length alike at both widths" {
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        var storage: [string_len_max]u8 = undefined;
        const len = seeded_text(&generator, &storage, &raw_between);
        const room_len: usize = if (generator.below(2) == 0) 6 * string_len_max else @intCast(generator.below(2 * len + 2));
        try wide_test.expect_same_escape(storage[0..len], room_len);
    }
}

/// A run of plain ASCII of 257 passes, closed by a quotation mark: the walk's passes over it are
/// counted, so a pass that took one octet fewer than it loaded would run out of passes. Past the
/// first block's octets, such a walk needs a run of about 9,100 octets to run out.
const long_passes = 257;
const long_len = long_passes * pass_len;

test "a run of plain ASCII of 257 passes copies alike at both widths" {
    const level = wide.Level.of(codec.Features.detect());
    var storage: [long_len + 1]u8 = undefined;
    const string = ascii_string(&storage, long_len, 'l');
    var narrow_room: [long_len + 1]u8 = undefined;
    var wide_room: [long_len + 1]u8 = undefined;
    const by_narrow = loop_string.copy_rest(claims.vector, constants.vector_len, level, string, &narrow_room);
    const by_wide = loop_string.copy_rest(claims.vector, wide_walk.block_len, level, string, &wide_room);
    try testing.expectEqual(by_narrow, by_wide);
    try testing.expectEqualSlices(u8, narrow_room[0..long_len], wide_room[0..long_len]);
    const escaped_narrow = encoder_string.copy_escaped(claims.vector, constants.vector_len, level, string[0..long_len], &narrow_room);
    const escaped_wide = encoder_string.copy_escaped(claims.vector, wide_walk.block_len, level, string[0..long_len], &wide_room);
    try testing.expectEqual(escaped_narrow, escaped_wide);
    try testing.expectEqualSlices(u8, narrow_room[0..long_len], wide_room[0..long_len]);
}
