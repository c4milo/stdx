//! Tests for the DEFLATE encoder: every output decodes to its input through stdx's decoder at every
//! level; the output is the same whole and under seeded splits of input and output, with the state
//! moved between calls (invariants 5 and 12); after each flush the output so far decodes to the
//! input so far; and `encoded_len_max` holds on input that does not compress.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const decoder = @import("../decoder/decoder.zig");
const encoder_module = @import("encoder.zig");

const levels = constants.encoder_levels;

/// The most octets a test encodes, 150 KiB: past two slides of the window.
const input_len_max = 153_600;

/// The longest run of one kind in mixed input, and the kinds a mixed input mixes.
const run_len_max = 2000;
const mixed_kinds = 3;

/// The kinds of input: words from a small vocabulary, random octets, zeros, and the three mixed.
const Kind = enum { words, random, zeros, mixed };

/// Fills `input` with `kind`, drawn from `seed`.
fn fill(input: []u8, kind: Kind, seed: u64) void {
    var generator = codec.split.Generator.init(seed);
    var index: usize = 0;
    for (0..input.len) |_| {
        if (index == input.len) break;
        const part = if (kind == .mixed) @as(Kind, @enumFromInt(generator.below(mixed_kinds))) else kind;
        const run = input[index..][0..@min(input.len - index, 1 + generator.below(run_len_max))];
        switch (part) {
            .words => write_words(run, &generator),
            .random => for (run) |*octet| {
                octet.* = @truncate(generator.next());
            },
            .zeros => @memset(run, 0),
            .mixed => unreachable,
        }
        index += run.len;
    }
}

fn write_words(target: []u8, generator: *codec.split.Generator) void {
    const words = [_][]const u8{ "the ", "stream ", "encoder ", "window ", "of ", "a ", "match ", "block ", "octets ", "and " };
    var at: usize = 0;
    for (0..target.len) |_| {
        if (at == target.len) break;
        const word = words[generator.below(words.len)];
        const len = @min(word.len, target.len - at);
        @memcpy(target[at..][0..len], word[0..len]);
        at += len;
    }
}

/// Decodes `stream` with stdx's decoder and requires `expected` and the stream's end at its last
/// octet.
fn expect_decodes_to(stream: []const u8, expected: []const u8) !void {
    var output: [input_len_max + 1]u8 = undefined;
    var state: decoder.Decoder = undefined;
    decoder.init(&state, codec.Features.detect());
    const whole = try decoder.decode_all(&state, stream, &output);
    try testing.expectEqual(stream.len, whole.consumed);
    try testing.expectEqualSlices(u8, expected, output[0..whole.written]);
}

/// The encoded length of `input` at `level`, written into `output`.
fn encode_whole(comptime level: u4, input: []const u8, output: []u8) !usize {
    const Encoder = encoder_module.Encoder(.{ .level = level });
    var state: Encoder = undefined;
    state.init(.{});
    return state.encode_all(input, output);
}

test "every level's output decodes to its input, within encoded_len_max" {
    var input: [input_len_max]u8 = undefined;
    var output: [input_len_max + 1024]u8 = undefined;
    const lens = [_]usize{ 0, 1, 5, 300, 20_000, 70_000, input_len_max };
    inline for (levels) |level| {
        const Encoder = encoder_module.Encoder(.{ .level = level });
        for (std.enums.values(Kind)) |kind| {
            for (lens, 0..) |len, seed| {
                // Level 9's long chains make word input slow in a Debug build, so it takes less.
                const taken = if (level == 9 and kind == .words) @min(len, 20_000) else len;
                fill(input[0..taken], kind, seed);
                const written = try encode_whole(level, input[0..taken], &output);
                try testing.expect(written <= Encoder.encoded_len_max(taken));
                try expect_decodes_to(output[0..written], input[0..taken]);
            }
        }
    }
}

fn Step(comptime level: u4) type {
    return struct {
        const Encoder = encoder_module.Encoder(.{ .level = level });
        fn step(state: *Encoder, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return state.encode(input, output, flush);
        }
    };
}

test "every split of input and output gives the same octets, the state moved between calls" {
    var input: [80 * 1024]u8 = undefined;
    fill(&input, .mixed, 3);
    var whole: [input.len + 1024]u8 = undefined;
    var split: [whole.len]u8 = undefined;
    inline for (levels) |level| {
        const S = Step(level);
        const whole_len = try encode_whole(level, &input, &whole);
        for (0..8) |seed| {
            var states: [codec.split.state_slots]S.Encoder = undefined;
            states[0].init(.{});
            const outcome = try codec.split.drive_encoder(S.Encoder, &states, S.step, &input, &split, &.{}, seed);
            try testing.expectEqual(.done, outcome.status);
            try testing.expectEqual(input.len, outcome.consumed);
            try testing.expectEqualSlices(u8, whole[0..whole_len], split[0..outcome.written]);
        }
    }
}

test "after each flush the output so far decodes to the input so far, and splits agree" {
    var input: [70 * 1024]u8 = undefined;
    fill(&input, .mixed, 5);
    const points = [_]usize{ 0, 1, 1000, 1000, 40_000, 66_000 };
    inline for (levels) |level| {
        const S = Step(level);
        var state: S.Encoder = undefined;
        state.init(.{});
        var output: [input.len + 1024]u8 = undefined;
        var written: usize = 0;
        var consumed: usize = 0;
        for (points) |point| {
            const progress = state.encode(input[consumed..point], output[written..], .flush);
            try testing.expectEqual(.needs_input, progress.status);
            consumed += progress.consumed;
            written += progress.written;
            try expect_prefix_decodes(output[0..written], input[0..point]);
        }
        const last = state.encode(input[consumed..], output[written..], .finish);
        try testing.expectEqual(.done, last.status);
        written += last.written;
        try expect_decodes_to(output[0..written], &input);
        for (0..4) |seed| {
            var states: [codec.split.state_slots]S.Encoder = undefined;
            states[0].init(.{});
            var split: [output.len]u8 = undefined;
            const outcome = try codec.split.drive_encoder(S.Encoder, &states, S.step, &input, &split, &points, seed);
            try testing.expectEqualSlices(u8, output[0..written], split[0..outcome.written]);
        }
    }
}

/// Requires the stream so far to decode to `expected` and to ask for more: a flush leaves the
/// stream open, on an octet boundary.
fn expect_prefix_decodes(stream: []const u8, expected: []const u8) !void {
    var output: [input_len_max]u8 = undefined;
    var state: decoder.Decoder = undefined;
    decoder.init(&state, codec.Features.detect());
    const progress = try decoder.decode(&state, stream, &output);
    try testing.expectEqual(.needs_input, progress.status);
    try testing.expectEqualSlices(u8, expected, output[0..progress.written]);
}

test "encoded_len_max holds where short repeats keep stored blocks across the window's slides" {
    // Random octets with a short repeat now and then: each block prices stored but covers more
    // input than it has symbols, so the slides cut blocks where the symbol limit does not.
    var input: [input_len_max]u8 = undefined;
    fill(&input, .random, 13);
    var generator = codec.split.Generator.init(13);
    var at: usize = repeat_start;
    for (0..input.len) |_| {
        if (at + repeat_len >= input.len) break;
        @memcpy(input[at..][0..repeat_len], input[at - repeat_distance ..][0..repeat_len]);
        at += repeat_gap_min + generator.below(repeat_gap_min);
    }
    var output: [input.len + 1024]u8 = undefined;
    inline for (levels) |level| {
        const written = try encode_whole(level, &input, &output);
        try testing.expect(written <= encoder_module.Encoder(.{ .level = level }).encoded_len_max(input.len));
        try expect_decodes_to(output[0..written], &input);
    }
}

/// The short repeats: where the first starts, the octets each copies, how far back, and the least
/// gap between two.
const repeat_start = 1000;
const repeat_len = 8;
const repeat_distance = 500;
const repeat_gap_min = 900;

test "an empty stream is one final fixed block holding end-of-block alone" {
    var output: [16]u8 = undefined;
    inline for (levels) |level| {
        const written = try encode_whole(level, "", &output);
        // BFINAL 1, BTYPE 01, then code 256, seven zeros (RFC 1951 §3.2.6): 0b00000011, 0.
        try testing.expectEqualSlices(u8, &.{ 0x03, 0x00 }, output[0..written]);
    }
}

test "encode_all names an output too small" {
    var input: [1000]u8 = undefined;
    fill(&input, .random, 9);
    var output: [100]u8 = undefined;
    inline for (levels) |level| try testing.expectError(error.NoSpaceLeft, encode_whole(level, &input, &output));
}

test "each level's output for a seeded input is the one recorded here" {
    // Any change to what the encoder decides changes these; a change meant to must record new ones.
    const recorded = [_]struct { usize, u64 }{
        .{ 49533, 0x0e2a4aaf8b9007a9 },
        .{ 45857, 0x48a59473a824db0a },
        .{ 45748, 0x390bb9aacdb8e0ab },
    };
    var input: [120 * 1024]u8 = undefined;
    fill(&input, .mixed, 11);
    var output: [input.len + 1024]u8 = undefined;
    inline for (levels, recorded) |level, expected| {
        const written = try encode_whole(level, &input, &output);
        try testing.expectEqual(expected[0], written);
        try testing.expectEqual(expected[1], std.hash.Wyhash.hash(0, output[0..written]));
    }
}

test "each level's output for two seeded letters, whose chains run long, is the one recorded here" {
    // Two letters make 16 strings of 4 octets, so the chains run long: level 9's cut searches here
    // try all `cut_candidates_max` candidates hundreds of times.
    const recorded = [_]struct { usize, u64 }{
        .{ 6026, 0xed9e40967cddbb1d },
        .{ 3974, 0x0cc72cd22fbd5b30 },
        .{ 4040, 0x751006431eb75e28 },
    };
    var input: [letters_len]u8 = undefined;
    var generator = codec.split.Generator.init(17);
    for (&input) |*octet| octet.* = 'a' + @as(u8, @intCast(generator.below(letters)));
    var output: [input.len + 1024]u8 = undefined;
    inline for (levels, recorded) |level, expected| {
        const written = try encode_whole(level, &input, &output);
        try testing.expectEqual(expected[0], written);
        try testing.expectEqual(expected[1], std.hash.Wyhash.hash(0, output[0..written]));
    }
}

/// The octets of the seeded letters the second recorded output encodes, and how many letters.
const letters_len = 24_576;
const letters = 2;

test "a stream that ends or flushes as the window fills gives the same octets under every split" {
    // The input fills the window exactly at `encoder_window_len` octets, and at every
    // `window_len` after. A caller that gives those octets with `none` and then finishes or
    // flushes with an empty call gets the octets of one call (invariant 5).
    var input: [window_full_lens[window_full_lens.len - 1]]u8 = undefined;
    fill(&input, .mixed, 19);
    inline for (levels) |level| {
        for (window_full_lens) |len| try expect_empty_finish_agrees(level, input[0..len]);
        try expect_flush_splits_agree(level, &input, window_full_lens[0]);
    }
}

/// The lengths at which the input fills the window: the first fill, and the fill after a slide.
const window_full_lens = [_]usize{ constants.encoder_window_len, constants.encoder_window_len + constants.window_len };

/// Room for the stream of the longest input there with one flush in it. The flush adds at most two
/// blocks' headers, the block it cuts short and its empty stored block, which an empty stream's
/// `encoded_len_max` counts.
const window_full_output_len = encoder_module.Encoder(.{}).encoded_len_max(window_full_lens[window_full_lens.len - 1]) +
    encoder_module.Encoder(.{}).encoded_len_max(0);

/// Requires `input` given with `none`, then an empty `finish`, to encode as `encode_all` does.
fn expect_empty_finish_agrees(comptime level: u4, input: []const u8) !void {
    var whole: [window_full_output_len]u8 = undefined;
    const whole_len = try encode_whole(level, input, &whole);
    var split: [whole.len]u8 = undefined;
    var state: Step(level).Encoder = undefined;
    state.init(.{});
    const given = state.encode(input, &split, .none);
    const last = state.encode("", split[given.written..], .finish);
    try testing.expectEqual(.done, last.status);
    try testing.expectEqualSlices(u8, whole[0..whole_len], split[0 .. given.written + last.written]);
}

/// Requires every seeded split with a flush at `point` to encode as a flush carried by the call
/// that gives the octets before it.
fn expect_flush_splits_agree(comptime level: u4, input: []const u8, point: usize) !void {
    const S = Step(level);
    var carried: [window_full_output_len]u8 = undefined;
    var state: S.Encoder = undefined;
    state.init(.{});
    const first = state.encode(input[0..point], &carried, .flush);
    const last = state.encode(input[point..], carried[first.written..], .finish);
    try testing.expectEqual(.done, last.status);
    const carried_len = first.written + last.written;
    for (0..flush_split_seeds) |seed| {
        var states: [codec.split.state_slots]S.Encoder = undefined;
        states[0].init(.{});
        var split: [carried.len]u8 = undefined;
        const outcome = try codec.split.drive_encoder(S.Encoder, &states, S.step, input, &split, &.{point}, seed);
        try testing.expectEqualSlices(u8, carried[0..carried_len], split[0..outcome.written]);
    }
}

/// The seeded splits the flush at a full window is driven under.
const flush_split_seeds = 8;
