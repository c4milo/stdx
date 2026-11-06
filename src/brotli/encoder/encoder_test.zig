//! The tests of the brotli encoder: streams that decode to their input through stdx's decoder;
//! `encoded_len_max`; the same octets under every split of the input and the output, flush points
//! included (invariant 5); a flush that makes every octet so far decode; an uncompressed
//! meta-block that puts back the last distances its parse moved; and `start` against `init`.
//!
//! The encoders take a window of `test_window_bits`, and live on the stack of a function the
//! compiler may not inline, one at a time. `differential-brotli-encode` checks the level's own
//! window over the corpus.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const decoder_module = @import("../decoder/decoder.zig");
const encoder = @import("encoder.zig");

/// Several meta-blocks and more, so the window of 2^16 slides.
const input_len_max = 409_600;
const test_window_bits = constants.encoder_window_bits_min;

/// Room past the input's length for the stream's and meta-blocks' headers.
const coded_slack = 1024;

/// One octet in `noise_odds` of the text is noise.
const noise_odds = 20;

/// Buffers that outlive one test's stack frame.
threadlocal var input: [input_len_max]u8 = undefined;
threadlocal var coded: [input_len_max + coded_slack]u8 = undefined;
threadlocal var reference: [input_len_max + coded_slack]u8 = undefined;
threadlocal var decoded: [input_len_max]u8 = undefined;
threadlocal var decoder: decoder_module.Decoder(.{ .window_bits_max = test_window_bits }) = undefined;

const Encoder = encoder.Encoder(.{ .level = 1, .window_bits = test_window_bits });

fn step(state: *Encoder, piece: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
    return state.encode(piece, output, flush);
}

/// Text-like input: words with seeded noise, which repeats as a body of text does.
fn fill_text(generator: *codec.testing.split.Generator, octets: []u8) void {
    const words = [_][]const u8{ "octet ", "window ", "stream ", "the ", "of ", "match ", "brotli ", "meta ", "a ", "coded " };
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

/// The inputs the encoder codes: empty, one octet, text short and long, random octets, a run, and
/// random octets then text, whose first meta-block goes out uncompressed.
const Case = enum { empty, one, short, medium, long, whole, random, run, mixed };
const short_len = 300;
const medium_len = 5000;
const long_len = 140_000;

fn input_of(case: Case) []const u8 {
    var generator = codec.testing.split.Generator.init(@intFromEnum(case));
    const len: usize = switch (case) {
        .empty => 0,
        .one => 1,
        .short => short_len,
        .medium => medium_len,
        .long => long_len,
        .whole, .random, .run, .mixed => input_len_max,
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

const cases = std.enums.values(Case);

/// Decodes `stream` through stdx's decoder and requires `expected`.
fn expect_decodes(stream: []const u8, expected: []const u8) !void {
    decoder.init(.{});
    const whole = try decoder.decode_all(stream, &decoded);
    try testing.expectEqual(stream.len, whole.consumed);
    try testing.expectEqualSlices(u8, expected, decoded[0..whole.written]);
}

/// Text and runs compress to less than this share of their octets.
const compressed_ratio_min = 2;

test "streams decode to their input, within encoded_len_max" {
    try @call(.never_inline, expect_streams, .{});
}

fn expect_streams() !void {
    var state: Encoder = undefined;
    for (cases) |case| {
        const plain = input_of(case);
        state.init();
        const written = try state.encode_all(plain, &coded);
        try testing.expect(written <= Encoder.encoded_len_max(plain.len));
        try expect_decodes(coded[0..written], plain);
        const compresses = @intFromEnum(case) >= @intFromEnum(Case.medium) and case != .random and case != .mixed;
        if (compresses) try testing.expect(written < plain.len / compressed_ratio_min);
    }
}

test "a stream's octets are the same under every split of its input and output" {
    var generator = codec.testing.split.Generator.init(11);
    for (cases) |case| try @call(.never_inline, expect_splits, .{ &generator, input_of(case) });
}

/// The seeded splits each input runs under, with this many flush points.
const split_seeds = 4;
const split_points = 3;
/// An input this long or shorter takes no flush points.
const split_points_len_min = 2;

fn expect_splits(generator: *codec.testing.split.Generator, plain: []const u8) !void {
    var states: [codec.testing.split.state_slots]Encoder = undefined;
    var points: [split_points]usize = undefined;
    var point_count: usize = 0;
    if (plain.len > split_points_len_min) {
        for (&points) |*point| point.* = generator.between(1, plain.len - 1);
        std.sort.pdq(usize, &points, {}, std.sort.asc(usize));
        point_count = points.len;
    }
    const reference_len = try encode_at_points(&states[0], plain, points[0..point_count]);
    try expect_decodes(reference[0..reference_len], plain);
    for (0..split_seeds) |seed| {
        states[0].init();
        const outcome = try codec.testing.split.drive_encoder(Encoder, &states, step, plain, &coded, points[0..point_count], seed);
        try testing.expectEqual(.done, outcome.status);
        try testing.expectEqualSlices(u8, reference[0..reference_len], coded[0..outcome.written]);
    }
}

/// Encodes `plain` into `reference` in one call per flush point and one for the end, each with all
/// the room. Returns the octets written.
fn encode_at_points(state: *Encoder, plain: []const u8, points: []const usize) !usize {
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

test "a flush makes every octet so far decode" {
    try @call(.never_inline, expect_flush_decodes, .{});
}

/// The flush test flushes at this many points of a long input, each at a seeded place, and after
/// each length of a short input up to `flush_short_len_max`, whose bits before the flush take
/// every count.
const flush_points = 8;
const flush_seed = 17;
const flush_short_len_max = 64;

fn expect_flush_decodes() !void {
    var state: Encoder = undefined;
    var generator = codec.testing.split.Generator.init(flush_seed);
    const long = input_of(.long);
    for (0..flush_points) |_| try expect_flush_at(&state, long[0..generator.between(1, long.len - 1)]);
    const short = input_of(.short);
    for (1..flush_short_len_max + 1) |len| try expect_flush_at(&state, short[0..len]);
}

/// Flushes `plain` as a stream's first input, and requires every octet of it to decode.
fn expect_flush_at(state: *Encoder, plain: []const u8) !void {
    state.init();
    const progress = state.encode(plain, &coded, .flush);
    try testing.expectEqual(.needs_input, progress.status);
    // RFC 7932 §9.2: the flush ends on an octet boundary, so no bit waits.
    try testing.expectEqual(0, state.bits.count);
    decoder.init(.{});
    const partial = try decoder.decode(coded[0..progress.written], &decoded);
    try testing.expectEqual(.needs_input, partial.status);
    try testing.expectEqualSlices(u8, plain, decoded[0..partial.written]);
}

test "no match reaches past the window's last distance" {
    try @call(.never_inline, expect_reach_kept, .{});
}

/// A repeat at a distance the window holds but RFC 7932 §9.1 gives to the dictionary: the window
/// less `reach_probe_short` octets, past its largest backward distance.
const reach_probe_short = 8;
const reach_probe_len = 256;
const reach_probe_seed = 19;

fn expect_reach_kept() !void {
    var state: Encoder = undefined;
    var generator = codec.testing.split.Generator.init(reach_probe_seed);
    const distance = (1 << test_window_bits) - reach_probe_short;
    const len = distance + constants.encoder_meta_block_len_max;
    for (input[0..len]) |*octet| octet.* = @truncate(generator.next());
    // Repeats in the second meta-block of the first's octets, where a parse starts again.
    const first = constants.encoder_meta_block_len_max + reach_probe_short;
    @memcpy(input[first..][0..reach_probe_len], input[first - distance ..][0..reach_probe_len]);
    state.init();
    const written = try state.encode_all(input[0..len], &coded);
    try expect_decodes(coded[0..written], input[0..len]);
}

test "an uncompressed meta-block puts back the last distances its parse moved" {
    try @call(.never_inline, expect_distances_restored, .{});
}

/// The distances test: random octets, with a repeat at distance 28 in the first meta-block and
/// another in the second.
const restore_seed = 13;
const restore_len = 720;
const restore_flush = 600;
const restore_first_from = 2;
const restore_first_to = 30;
const restore_first_len = 6;
const restore_second_from = 622;
const restore_second_to = 650;
const restore_second_len = 20;
const Repeat = struct { from: usize, to: usize, len: usize };
const restore_repeats = [_]Repeat{
    .{ .from = restore_first_from, .to = restore_first_to, .len = restore_first_len },
    .{ .from = restore_second_from, .to = restore_second_to, .len = restore_second_len },
};

fn expect_distances_restored() !void {
    // The parse takes the first repeat and pushes 28, but the meta-block goes out uncompressed,
    // which RFC 7932 §4 says moves no distance.
    var state: Encoder = undefined;
    var generator = codec.testing.split.Generator.init(restore_seed);
    for (input[0..restore_len]) |*octet| octet.* = @truncate(generator.next());
    for (restore_repeats) |repeat| @memcpy(input[repeat.to..][0..repeat.len], input[repeat.from..][0..repeat.len]);
    state.init();
    const first = state.encode(input[0..restore_flush], &coded, .flush);
    try testing.expectEqual(.needs_input, first.status);
    try testing.expect(state.commands.count > 0);
    try testing.expectEqualSlices(u32, &constants.last_distances_initial, &state.commands.last_distances);
    const second = state.encode(input[restore_flush..restore_len], coded[first.written..], .finish);
    try testing.expectEqual(.done, second.status);
    try expect_decodes(coded[0 .. first.written + second.written], input[0..restore_len]);
}

test "a stream begun with start writes the octets of one begun with init" {
    try @call(.never_inline, expect_start_equals_init, .{});
}

fn expect_start_equals_init() !void {
    var started: Encoder = undefined;
    started.init();
    for ([_]Case{ .long, .whole, .whole, .medium, .run, .mixed, .short }, 0..) |case, index| {
        if (index > 0) started.start();
        const plain = input_of(case);
        const written = try started.encode_all(plain, &coded);
        var fresh: Encoder = undefined;
        fresh.init();
        const fresh_written = try fresh.encode_all(plain, &reference);
        try testing.expectEqualSlices(u8, reference[0..fresh_written], coded[0..written]);
    }
}
