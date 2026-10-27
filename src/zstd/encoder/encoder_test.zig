//! The tests of the Zstandard encoder: frames that decode to their input through stdx's decoder at
//! both levels, with and without a checksum; frames whose content is one block single-segment;
//! `encoded_len_max`; and the same octets under every split of the input and the output, flush
//! points included (invariant 5).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const decoder_module = @import("../decoder/decoder.zig");
const frame = @import("../frame.zig");
const encoder = @import("encoder.zig");

const input_len_max = 614_400;

/// Room past the input's length for a frame's header, blocks' headers and checksum.
const coded_slack = 1024;

/// One octet in `noise_odds` of the text is noise.
const noise_odds = 20;

/// State that outlives one test's stack frame: encoders and decoders hold megabytes.
threadlocal var input: [input_len_max]u8 = undefined;
threadlocal var coded: [input_len_max + coded_slack]u8 = undefined;
threadlocal var reference: [input_len_max + coded_slack]u8 = undefined;
threadlocal var decoded: [input_len_max]u8 = undefined;
threadlocal var decoder: decoder_module.Decoder(.{ .window_len_max = 1 << constants.encoder_window_log_max }) = undefined;

fn Step(comptime options: encoder.EncoderOptions) type {
    return struct {
        const Encoder = encoder.Encoder(options);
        threadlocal var states: [codec.split.state_slots]Encoder = undefined;
        fn step(state: *Encoder, piece: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return state.encode(piece, output, flush);
        }
    };
}

/// Text-like input: words with seeded noise, which repeats as a body of text does.
fn fill_text(generator: *codec.split.Generator, octets: []u8) void {
    const words = [_][]const u8{ "octet ", "window ", "stream ", "the ", "of ", "match ", "zstd ", "frame ", "a ", "coded " };
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

/// The inputs every level encodes: empty, one octet, text short and long, random octets, a run.
const Case = enum { empty, one, short, medium, long, whole, random, run };
const short_len = 300;
const medium_len = 5000;
const long_len = 140_000;

fn input_of(case: Case) []const u8 {
    var generator = codec.split.Generator.init(@intFromEnum(case));
    const len: usize = switch (case) {
        .empty => 0,
        .one => 1,
        .short => short_len,
        .medium => medium_len,
        .long => long_len,
        .whole, .random, .run => input_len_max,
    };
    switch (case) {
        .random => for (input[0..len]) |*octet| {
            octet.* = @truncate(generator.next());
        },
        .run => @memset(input[0..len], 'z'),
        else => fill_text(&generator, input[0..len]),
    }
    return input[0..len];
}

const cases = std.enums.values(Case);

/// Decodes `frame_octets` through stdx's decoder and requires `expected`.
fn expect_decodes(frame_octets: []const u8, expected: []const u8) !void {
    decoder.init(.{});
    const whole = try decoder.decode_all(frame_octets, &decoded);
    try testing.expectEqual(frame_octets.len, whole.consumed);
    try testing.expectEqualSlices(u8, expected, decoded[0..whole.written]);
}

test "frames decode to their input at both levels, with and without a checksum" {
    inline for (.{ 1, 3 }) |level| {
        inline for (.{ false, true }) |with_checksum| {
            const Encoder = Step(.{ .level = level, .checksum = with_checksum }).Encoder;
            const state = &Step(.{ .level = level, .checksum = with_checksum }).states[0];
            for (cases) |case| {
                const plain = input_of(case);
                state.init(.{});
                const written = try state.encode_all(plain, &coded);
                try testing.expect(written <= Encoder.encoded_len_max(plain.len));
                try expect_decodes(coded[0..written], plain);
                const descriptor = coded[constants.magic_len];
                const header = try frame.read(coded[constants.magic_len..][0..frame.header_len(descriptor)], 1 << constants.encoder_window_log_max);
                try testing.expectEqual(with_checksum, header.has_checksum);
                // A frame of one block states its size, and asks no larger window than it.
                if (plain.len <= constants.block_len_max) try testing.expectEqual(@as(u64, plain.len), header.window_len);
                // Text and runs compress; random octets go out raw.
                if (@intFromEnum(case) >= @intFromEnum(Case.medium) and case != .random) try testing.expect(written < plain.len / 2);
            }
        }
    }
}

test "a frame's octets are the same under every split of its input and output" {
    const options: encoder.EncoderOptions = .{ .level = 3, .window_log = 17 };
    const S = Step(options);
    var generator = codec.split.Generator.init(11);
    for (cases) |case| {
        const plain = input_of(case)[0..@min(input_of(case).len, 300_000)];
        // Flush points at seeded places, ascending, before the input's end.
        var points: [3]usize = undefined;
        var point_count: usize = 0;
        if (plain.len > 2) {
            for (&points) |*point| point.* = generator.between(1, plain.len - 1);
            std.sort.pdq(usize, &points, {}, std.sort.asc(usize));
            point_count = points.len;
        }
        const reference_len = try encode_at_points(&S.states[0], plain, points[0..point_count]);
        try expect_decodes(reference[0..reference_len], plain);
        for (0..4) |seed| {
            S.states[0].init(.{});
            const outcome = try codec.split.drive_encoder(S.Encoder, &S.states, S.step, plain, &coded, points[0..point_count], seed);
            try testing.expectEqual(.done, outcome.status);
            try testing.expectEqualSlices(u8, reference[0..reference_len], coded[0..outcome.written]);
        }
    }
}

/// Encodes `plain` into `reference` in one call per flush point and one for the end, each with
/// all the room. Returns the octets written.
fn encode_at_points(state: anytype, plain: []const u8, points: []const usize) !usize {
    state.init(.{});
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
    const options: encoder.EncoderOptions = .{ .level = 1 };
    const state = &Step(options).states[0];
    const plain = input_of(.long);
    state.init(.{});
    const half = plain.len / 2;
    const progress = state.encode(plain[0..half], &coded, .flush);
    try testing.expectEqual(.needs_input, progress.status);
    decoder.init(.{});
    const partial = try decoder.decode(coded[0..progress.written], &decoded);
    try testing.expectEqual(.needs_input, partial.status);
    try testing.expectEqualSlices(u8, plain[0..half], decoded[0..partial.written]);
}

test "a raw block puts back the Repeated_Offsets its parse moved" {
    // A first block of 600 random octets, flushed, with octets 2 to 6 again at 30: the parse
    // takes that match at offset 28, which moves Repeated_Offset1 to 28, but five octets do not pay
    // for a sequence, so the block goes out raw, which RFC 8878 §3.1.1.5 says moves no offset. The
    // second block repeats at offset 28 after literals, which an encoder that kept the parse's
    // offsets would write as Offset_Value 1, naming the decoder's Repeated_Offset1 of 1.
    const options: encoder.EncoderOptions = .{ .level = 1 };
    const state = &Step(options).states[0];
    var generator = codec.split.Generator.init(13);
    for (input[0..720]) |*octet| octet.* = @truncate(generator.next());
    @memcpy(input[30..35], input[2..7]);
    @memcpy(input[650..670], input[622..642]);
    state.init(.{});
    const first = state.encode(input[0..600], &coded, .flush);
    try testing.expectEqual(.needs_input, first.status);
    // The block after the 6-octet frame header is raw: Block_Type 0 (RFC 8878 §3.1.1.2.2).
    try testing.expectEqual(0, (coded[6] >> 1) & 3);
    try testing.expect(state.sequences.count > 0);
    try testing.expectEqualSlices(u32, &constants.repeated_offsets_initial, &state.repeats);
    const second = state.encode(input[600..720], coded[first.written..], .finish);
    try testing.expectEqual(.done, second.status);
    try expect_decodes(coded[0 .. first.written + second.written], input[0..720]);
}
