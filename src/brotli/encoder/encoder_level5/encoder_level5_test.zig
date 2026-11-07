//! The tests of level 5 (decision 62): streams that decode to their input through stdx's decoder,
//! within `encoded_len_max`, and the same octets under every split of the input and the output.
//! A window of 2^16 makes the window slide inside the inputs; the level's own window of 2^22 codes
//! a repeat from farther back than level 1 reaches.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const decoder_module = @import("../../decoder/decoder.zig");
const encoder = @import("../encoder.zig");

const small_window_bits = constants.encoder_window_bits_min;
const Small = encoder.Encoder(.{ .level = constants.encoder_level5.number, .window_bits = small_window_bits });
const Large = encoder.Encoder(.{ .level = constants.encoder_level5.number });

/// Several meta-blocks and more, so the window of 2^16 slides.
const input_len_max = 300_000;
/// A repeat 1.5 MiB back, past level 1's reach of 2^18, of 64 KiB.
const far_distance = 1_572_864;
const far_len = 65_536;
const far_input_len = far_distance + far_len;
const coded_slack = 4096;

threadlocal var input: [far_input_len]u8 = undefined;
threadlocal var coded: [far_input_len + coded_slack]u8 = undefined;
threadlocal var reference: [far_input_len + coded_slack]u8 = undefined;
threadlocal var decoded: [far_input_len]u8 = undefined;
threadlocal var decoder: decoder_module.Decoder(.{ .window_bits_max = constants.encoder_level5.window_bits }) = undefined;
threadlocal var small: [codec.testing.split.state_slots]Small = undefined;
threadlocal var large: Large = undefined;

/// The inputs: text short and long, random octets, a run, and random octets then text.
const Case = enum { empty, one, short, long, random, run, mixed };
const short_len = 700;
const long_len = 120_000;
const noise_odds = 20;

fn fill_text(generator: *codec.testing.split.Generator, octets: []u8) void {
    const words = [_][]const u8{ "octet ", "window ", "stream ", "the ", "of ", "match ", "brotli ", "level ", "a ", "bucket " };
    var at: usize = 0;
    for (0..octets.len) |_| {
        if (at == octets.len) break;
        if (generator.below(noise_odds) == 0) {
            octets[at] = @truncate(generator.next());
            at += 1;
            continue;
        }
        const word = words[generator.below(words.len)];
        const len = @min(word.len, octets.len - at);
        @memcpy(octets[at..][0..len], word[0..len]);
        at += len;
    }
}

fn input_of(case: Case) []const u8 {
    var generator = codec.testing.split.Generator.init(@intFromEnum(case));
    const len: usize = switch (case) {
        .empty => 0,
        .one => 1,
        .short => short_len,
        .long => long_len,
        .random, .run, .mixed => input_len_max,
    };
    switch (case) {
        .random => for (input[0..len]) |*octet| {
            octet.* = @truncate(generator.next());
        },
        .run => @memset(input[0..len], 'z'),
        .mixed => {
            for (input[0..long_len]) |*octet| octet.* = @truncate(generator.next());
            fill_text(&generator, input[long_len..len]);
        },
        else => fill_text(&generator, input[0..len]),
    }
    return input[0..len];
}

fn expect_decodes(stream: []const u8, expected: []const u8) !void {
    decoder.init(.{});
    const whole = try decoder.decode_all(stream, &decoded);
    try testing.expectEqual(stream.len, whole.consumed);
    try testing.expectEqualSlices(u8, expected, decoded[0..whole.written]);
}

/// Text and runs compress to less than this share of their octets.
const compressed_ratio_min = 2;

test "level 5's streams decode to their input, within encoded_len_max" {
    for (std.enums.values(Case)) |case| {
        const plain = input_of(case);
        small[0].init();
        const written = try small[0].encode_all(plain, &coded);
        try testing.expect(written <= Small.encoded_len_max(plain.len));
        try expect_decodes(coded[0..written], plain);
        const compresses = case == .long or case == .run;
        if (compresses) try testing.expect(written < plain.len / compressed_ratio_min);
    }
}

fn step(state: *Small, piece: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
    return state.encode(piece, output, flush);
}

/// The seeded splits each input runs under, and its flush points.
const split_seeds = 3;
const split_points = 3;
const split_seed = 29;

test "level 5's octets are the same under every split of its input and output" {
    var generator = codec.testing.split.Generator.init(split_seed);
    for (std.enums.values(Case)) |case| {
        const plain = input_of(case);
        var points: [split_points]usize = undefined;
        var count: usize = 0;
        if (plain.len > split_points) {
            for (&points) |*point| point.* = generator.between(1, plain.len - 1);
            std.sort.pdq(usize, &points, {}, std.sort.asc(usize));
            count = points.len;
        }
        const reference_len = try encode_at_points(&small[0], plain, points[0..count]);
        try expect_decodes(reference[0..reference_len], plain);
        for (0..split_seeds) |seed| {
            small[0].init();
            const outcome = try codec.testing.split.drive_encoder(Small, &small, step, plain, &coded, points[0..count], seed);
            try testing.expectEqual(.done, outcome.status);
            try testing.expectEqualSlices(u8, reference[0..reference_len], coded[0..outcome.written]);
        }
    }
}

fn encode_at_points(state: *Small, plain: []const u8, points: []const usize) !usize {
    state.init();
    var written: usize = 0;
    var start: usize = 0;
    for (points) |point| {
        const progress = state.encode(plain[start..point], reference[written..], .flush);
        try testing.expectEqual(.needs_input, progress.status);
        written += progress.written;
        start = point;
    }
    const progress = state.encode(plain[start..], reference[written..], .finish);
    try testing.expectEqual(.done, progress.status);
    return written + progress.written;
}

test "level 5 copies from farther back than level 1's window" {
    // A random block, a run of one octet, whose positions all join one bucket and leave the
    // block's entries in theirs, and the block again: only a match 1.5 MiB back codes it short.
    var generator = codec.testing.split.Generator.init(far_distance);
    for (input[0..far_len]) |*octet| octet.* = @truncate(generator.next());
    @memset(input[far_len..far_distance], run_octet);
    for (input[far_distance..far_input_len]) |*octet| octet.* = @truncate(generator.next());
    large.init();
    const without = try large.encode_all(input[0..far_input_len], &reference);
    @memcpy(input[far_distance..][0..far_len], input[0..far_len]);
    large.init();
    const with = try large.encode_all(input[0..far_input_len], &coded);
    try expect_decodes(coded[0..with], input[0..far_input_len]);
    try testing.expect(with + far_len / 2 < without);
}

/// The run between the far test's blocks.
const run_octet = 'z';
