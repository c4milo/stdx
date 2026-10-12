//! Tests that pin level 6's `lazy_len` and `nice_len` from both sides. Each input is built so that
//! the limit as it stands, one more and one less leave three different sets of symbols, and each
//! level's output for it is recorded: a limit that moves by one changes level 6's.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const shared = @import("encoder_test.zig");

const levels = constants.encoder_levels;

/// The scenes of each kind an input holds, a scene's parts, and the random octets after each part.
const scenes = 20;
const scene_parts = 3;
const gap_len = 8;

/// The octets a waiting scene's phrase runs past the match that waits at its start.
const waiting_rest_len = 3;

/// The octets of a nearer scene's phrase: more than any `nice_len` under `match_len_max`.
const nearer_phrase_len = 200;

/// The octets an output may run past the longest input, as random octets do not compress.
const output_slack_len = 1024;

/// Writes `parts` at `at`, each followed by `gap_len` random octets, and returns the end.
fn write_parts(input: []u8, at: usize, generator: *codec.split.Generator, parts: [scene_parts][]const u8) usize {
    var end = at;
    for (parts) |part| {
        @memcpy(input[end..][0..part.len], part);
        end += part.len;
        for (input[end..][0..gap_len]) |*octet| octet.* = @truncate(generator.next());
        end += gap_len;
    }
    return end;
}

/// The octets of one scene whose waiting match is `waiting_len` long.
fn waiting_scene_len(waiting_len: usize) usize {
    return (waiting_len + waiting_rest_len - 1) + waiting_len + (waiting_len + waiting_rest_len) + scene_parts * gap_len;
}

/// Writes one scene at `at` and returns its end: a phrase of random octets, and before it, apart,
/// its octets from the second on and its first `waiting_len` octets. At the phrase a match of
/// `waiting_len` octets waits; the next position holds one `waiting_rest_len - 1` octets longer,
/// and after the waiting match too few octets are left for any match.
fn write_waiting_scene(input: []u8, at: usize, generator: *codec.split.Generator, waiting_len: usize) usize {
    var phrase: [constants.match_len_max]u8 = undefined;
    const phrase_len = waiting_len + waiting_rest_len;
    for (phrase[0..phrase_len]) |*octet| octet.* = @truncate(generator.next());
    return write_parts(input, at, generator, .{ phrase[1..phrase_len], phrase[0..waiting_len], phrase[0..phrase_len] });
}

/// The octets of one scene whose nearer match is `nearer_len` long.
fn nearer_scene_len(nearer_len: usize) usize {
    return nearer_phrase_len + nearer_len + nearer_phrase_len + scene_parts * gap_len;
}

/// Writes one scene at `at` and returns its end: a phrase of random octets, and before it the
/// whole phrase and, nearer, its first `nearer_len` octets. A search at the phrase meets the
/// match of `nearer_len` octets first, and the whole phrase only when it goes on.
fn write_nearer_scene(input: []u8, at: usize, generator: *codec.split.Generator, nearer_len: usize) usize {
    var phrase: [nearer_phrase_len]u8 = undefined;
    for (&phrase) |*octet| octet.* = @truncate(generator.next());
    return write_parts(input, at, generator, .{ &phrase, phrase[0..nearer_len], &phrase });
}

/// Requires each level's output for `input` to decode to it and to be the one `recorded`.
fn expect_recorded(input: []const u8, recorded: [levels.len]struct { usize, u64 }) !void {
    var output: [shared.input_len_max + output_slack_len]u8 = undefined;
    inline for (levels, recorded) |level, expected| {
        const written = try shared.encode_whole(level, input, &output);
        try shared.expect_decodes_to(output[0..written], input);
        try testing.expectEqual(expected[0], written);
        try testing.expectEqual(expected[1], std.hash.Wyhash.hash(0, output[0..written]));
    }
}

test "each level's output where matches of 32 and of 31 octets wait before a longer one is the one recorded here" {
    // Level 6 takes a waiting match of `lazy_len` octets, 32, with no look at the next position,
    // and looks there when 31 wait. Either side of that limit leaves other symbols here.
    const long = 32;
    const short = 31;
    var input: [scenes * (waiting_scene_len(long) + waiting_scene_len(short))]u8 = undefined;
    var generator = codec.split.Generator.init(31);
    var at: usize = 0;
    for (0..scenes) |_| {
        at = write_waiting_scene(&input, at, &generator, long);
        at = write_waiting_scene(&input, at, &generator, short);
    }
    try testing.expectEqual(input.len, at);
    try expect_recorded(&input, .{
        .{ 2656, 0x73aede5e9a6ac491 },
        .{ 2616, 0x04b86f83d1de6796 },
        .{ 2579, 0x5fe9b99aabbe87f0 },
    });
}

test "each level's output where a nearer match of 128 or of 127 octets stands before a longer one is the one recorded here" {
    // Level 6's search ends at a match of `nice_len` octets, 128, and goes on to the longer one
    // behind a match of 127. Either side of that limit leaves other symbols here.
    const nice = 128;
    const under = 127;
    var input: [scenes * (nearer_scene_len(nice) + nearer_scene_len(under))]u8 = undefined;
    var generator = codec.split.Generator.init(37);
    var at: usize = 0;
    for (0..scenes) |_| {
        at = write_nearer_scene(&input, at, &generator, nice);
        at = write_nearer_scene(&input, at, &generator, under);
    }
    try testing.expectEqual(input.len, at);
    try expect_recorded(&input, .{
        .{ 9314, 0x2f93b5184f035889 },
        .{ 9275, 0xaf26f89a63631754 },
        .{ 9215, 0xc4ee8d683f05bb7a },
    });
}
