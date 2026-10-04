//! Tests for where the encoder ends its blocks (decision 44), through whole streams: a block that
//! crossed a slide of the window and ends cheapest stored, the checks of a block's newest symbols
//! at the stream's end, at a flush and at a slide, and seeded inputs of stretches that differ.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const encoder_module = @import("encoder.zig");
const shared = @import("encoder_test.zig");

const levels = constants.encoder_levels;

/// The levels that check their blocks (decision 44).
const checked_levels = checked: {
    var list: []const u4 = &.{};
    for (levels) |level| {
        if (constants.level(level).block_checks) list = list ++ [_]u4{level};
    }
    break :checked list;
};

/// The values an octet takes, and the literals the fixed code gives 8 bits, 0 to 143 (RFC 1951
/// §3.2.6).
const octet_values = std.math.maxInt(u8) + 1;
const fixed_short_literals = 144;

/// Fills `target` with octets drawn below `bound`.
fn fill_below(target: []u8, generator: *codec.split.Generator, bound: usize) void {
    for (target) |*octet| octet.* = @intCast(generator.below(bound));
}

/// The octets `expect_flushes_decode`'s output holds past its input: the blocks' headers and the
/// flushes' empty stored blocks.
const output_slack_len = 1024;

/// Encodes `input` at `level` with a flush at each of `points`: the output so far must decode to
/// the input so far at each, and the whole to `input`. Returns the octets written by the last
/// flush.
fn expect_flushes_decode(comptime level: u4, input: []const u8, points: []const usize) !usize {
    const Encoder = encoder_module.Encoder(.{ .level = level });
    var state: Encoder = undefined;
    state.init(.{});
    var output: [shared.input_len_max + output_slack_len]u8 = undefined;
    var written: usize = 0;
    var consumed: usize = 0;
    for (points) |point| {
        const progress = state.encode(input[consumed..point], output[written..], .flush);
        try testing.expectEqual(.needs_input, progress.status);
        consumed += progress.consumed;
        written += progress.written;
        try shared.expect_prefix_decodes(output[0..written], input[0..point]);
    }
    const last = state.encode(input[consumed..], output[written..], .finish);
    try testing.expectEqual(.done, last.status);
    try shared.expect_decodes_to(output[0 .. written + last.written], input);
    return written;
}

test "a block that crossed a slide and ends cheapest stored goes out coded to the slide, then stored" {
    // A flush starts a block a little before the window's first slide. Its octets up to the slide
    // are literals under 144, 8 bits each in the fixed code and so a few bits under their stored
    // form (RFC 1951 §3.2.4 and §3.2.6): the block crosses the slide. Random octets follow, so at
    // its end the stored form is cheapest, with its first octets gone from the window. The block
    // ends at the symbol limit, at the stream's end, and at a flush.
    var input: [crossing_len]u8 = undefined;
    var generator = codec.split.Generator.init(41);
    fill_below(&input, &generator, octet_values);
    fill_below(input[crossing_flush..][0..crossing_low_len], &generator, fixed_short_literals);
    const after = crossing_flush + crossing_low_len;
    inline for (levels) |level| {
        _ = try expect_flushes_decode(level, &input, &.{crossing_flush});
        _ = try expect_flushes_decode(level, input[0 .. after + crossing_short_len], &.{crossing_flush});
        _ = try expect_flushes_decode(level, input[0 .. after + crossing_short_len], &.{ crossing_flush, after + crossing_short_len / 2 });
    }
    // With literals of 9 bits among the first, the fixed code no longer beats the stored form, nor
    // does a code of the block's own: the block ends at the slide.
    for (input[crossing_flush..][0..crossing_long_literals]) |*octet| {
        octet.* = @intCast(fixed_short_literals + generator.below(octet_values - fixed_short_literals));
    }
    inline for (levels) |level| _ = try expect_flushes_decode(level, &input, &.{crossing_flush});
}

/// Where the crossing test's flush starts a block, `crossing_lead_len` octets before the window's
/// first slide; the literals under 144 from there, past the slide; the random octets that fill the
/// block after them, or fewer than fill it; and how many of the first literals take 9 bits when
/// the block must not cross.
const crossing_lead_len = 200;
const crossing_flush = constants.encoder_window_len - constants.lookahead_min - crossing_lead_len;
const crossing_low_len = 216;
const crossing_short_len = 8000;
const crossing_long_literals = 40;
const crossing_len = crossing_flush + crossing_low_len + constants.block_symbols_max + constants.block_chunk_symbols;

test "few newest symbols that code apart leave the block at the end, at a flush and at a slide" {
    // Letters of 7 bits, with hardly a match among them, so a symbol an octet, then random octets,
    // fewer than a check's worth of symbols. Joined to the letters' block the random octets would
    // take its codes, 9 bits and more each; in a block of their own they are stored.
    var generator = codec.split.Generator.init(47);
    var input: [newest_letters_len + newest_random_len + newest_tail_len]u8 = undefined;
    fill_below(&input, &generator, letter_values);
    fill_below(input[newest_letters_len..][0..newest_random_len], &generator, octet_values);
    const end = newest_letters_len + newest_random_len;
    // At a slide: the random octets run from past a check up to the window's first slide.
    var sliding: [newest_slide_point + newest_tail_len]u8 = undefined;
    fill_below(&sliding, &generator, letter_values);
    fill_below(sliding[newest_slide_start..newest_slide_point], &generator, octet_values);
    var output: [sliding.len + output_slack_len]u8 = undefined;
    inline for (checked_levels) |level| {
        const letters = try shared.encode_whole(level, input[0..newest_letters_len], &output);
        const whole = try shared.encode_whole(level, input[0..end], &output);
        try testing.expect(whole <= letters + newest_random_len + newest_slack_len);
        const flushed = try expect_flushes_decode(level, &input, &.{end});
        try testing.expect(flushed <= letters + newest_random_len + newest_slack_len);
        const before = try shared.encode_whole(level, sliding[0..newest_slide_start], &output);
        const behind = try shared.encode_whole(level, sliding[newest_slide_point..], &output);
        const all = try shared.encode_whole(level, &sliding, &output);
        try testing.expect(all <= before + (newest_slide_point - newest_slide_start) + behind + newest_slide_slack_len);
    }
}

/// The letters the newest-symbols test draws: 128 values, 7 bits each, all under 144.
const letter_values = 128;
/// The letters before the random octets, `newest_checks` checks' worth of symbols and a few more,
/// so the last check falls among letters; the random octets; and the letters after a flush or a
/// slide.
const newest_checks = 2;
const newest_spare_len = 64;
const newest_letters_len = newest_checks * constants.block_chunk_symbols + newest_spare_len;
const newest_random_len = 1536;
const newest_tail_len = 4096;
/// What the random octets' block may cost past the octets themselves: the letters stored with
/// them at 8 bits where coded they took 7, a stored block's header and a flush's.
const newest_slack_len = 96;
/// The window's first slide, and where the random octets before it start: `newest_slide_spare_len`
/// octets past the fifteenth check, the third of the fourth block of 16,384 symbols, which a few
/// matches move.
const newest_slide_point = constants.encoder_window_len - constants.lookahead_min;
const newest_slide_checks = 15;
const newest_slide_spare_len = 512;
const newest_slide_start = newest_slide_checks * constants.block_chunk_symbols + newest_slide_spare_len;
/// As `newest_slack_len`, for the letters stored with the random octets before the slide.
const newest_slide_slack_len = 160;

/// Fills `input` with stretches that differ, each `stretch_len_max` octets at most.
fn fill_stretches(input: []u8, generator: *codec.split.Generator) void {
    var at: usize = 0;
    for (0..input.len) |_| {
        if (at == input.len) break;
        const len = @min(1 + generator.below(stretch_len_max), input.len - at);
        fill_stretch(input[0 .. at + len], at, generator);
        at += len;
    }
}

/// What a stretch holds: random octets over a seeded count of values, a copy of earlier octets,
/// one octet repeated, or random octets under 144.
const Stretch = enum { values, copy, run, short_literals };

/// Fills `input` from `at` on with one stretch of a seeded kind.
fn fill_stretch(input: []u8, at: usize, generator: *codec.split.Generator) void {
    const stretch = input[at..];
    const kinds = std.enums.values(Stretch);
    switch (kinds[generator.below(kinds.len)]) {
        .values => fill_below(stretch, generator, generator.between(stretch_values_min, octet_values)),
        .copy => {
            // The octets `distance` back, which a stretch at the input's start has none of.
            const distance = if (at == 0) 0 else 1 + generator.below(@min(at, constants.encoder_distance_max));
            for (stretch, at..) |*octet, index| octet.* = if (distance == 0) 0 else input[index - distance];
        },
        .run => @memset(stretch, @intCast(generator.below(octet_values))),
        .short_literals => fill_below(stretch, generator, fixed_short_literals),
    }
}

/// The stretches test's inputs: how many, their length at most, a stretch's, and the flush points
/// each draws at most. A stretch of random octets draws from `stretch_values_min` values or more:
/// fewer make chains that level 9 walks too long in a Debug build.
const stretch_cases = 8;
const stretches_len_max = 143_360;
const stretch_len_max = 24_576;
const stretch_values_min = 16;
const stretch_points_max = 3;

/// Encodes `input` at `level` under two seeded splits, with a flush at each of `points`: both give
/// the same octets, which decode to `input`.
fn expect_splits_agree(comptime level: u4, input: []const u8, points: []const usize, seed: u64) !void {
    const Encoder = encoder_module.Encoder(.{ .level = level });
    const step = struct {
        fn call(state: *Encoder, piece: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return state.encode(piece, output, flush);
        }
    }.call;
    var states: [codec.split.state_slots]Encoder = undefined;
    var first: [stretches_len_max + output_slack_len]u8 = undefined;
    states[0].init(.{});
    const outcome = try codec.split.drive_encoder(Encoder, &states, step, input, &first, points, seed);
    try testing.expectEqual(.done, outcome.status);
    try testing.expectEqual(input.len, outcome.consumed);
    var second: [first.len]u8 = undefined;
    states[0].init(.{});
    const again = try codec.split.drive_encoder(Encoder, &states, step, input, &second, points, seed +% 1);
    try testing.expectEqualSlices(u8, first[0..outcome.written], second[0..again.written]);
    try shared.expect_decodes_to(first[0..outcome.written], input);
}

test "seeded inputs of stretches that differ decode to themselves at every level, and splits agree" {
    // Stretches that code well beside stretches that do not, across slides of the window and
    // flushes: blocks end before newest symbols, cross slides, and fall back to their stored form.
    var input: [stretches_len_max]u8 = undefined;
    for (0..stretch_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const len = generator.between(stretches_len_max / 2, stretches_len_max);
        fill_stretches(input[0..len], &generator);
        var points: [stretch_points_max]usize = undefined;
        const count = generator.below(stretch_points_max + 1);
        for (points[0..count]) |*point| point.* = generator.below(len);
        std.mem.sort(usize, points[0..count], {}, std.sort.asc(usize));
        inline for (levels) |level| try expect_splits_agree(level, input[0..len], points[0..count], generator.next());
    }
}
