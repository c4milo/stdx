//! The tests of level 5 (decision 62): streams that decode to their input through stdx's decoder,
//! within `encoded_len_max`, and the same octets under every split of the input and the output.
//! A window of 2^16 makes the window slide inside the inputs; a window of 2^19 codes a repeat from
//! farther back than level 1 reaches.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const decoder_module = @import("../../decoder/decoder.zig");
const encoder = @import("../encoder.zig");

const small_window_bits = constants.encoder_window_bits_min;
const Small = encoder.Encoder(.{ .level = constants.encoder_level5.number, .window_bits = small_window_bits });
/// A window past level 1's 2^18, small enough that the test's state fits aarch64's thread-local
/// offsets: 2^22's window and decoder would not.
const large_window_bits = 19;
const Large = encoder.Encoder(.{ .level = constants.encoder_level5.number, .window_bits = large_window_bits });

/// Several meta-blocks and more, so the window of 2^16 slides.
const input_len_max = 300_000;
/// A repeat 384 KiB back, past level 1's reach of 2^18, of 64 KiB: its distance takes 17 extra
/// bits, past level 1's 16.
const far_distance = 393_216;
const far_len = 65_536;
const far_input_len = far_distance + far_len;
const coded_slack = 4096;

threadlocal var input: [far_input_len]u8 = undefined;
threadlocal var coded: [far_input_len + coded_slack]u8 = undefined;
threadlocal var reference: [far_input_len + coded_slack]u8 = undefined;
threadlocal var decoded: [far_input_len]u8 = undefined;
threadlocal var decoder: decoder_module.Decoder(.{ .window_bits_max = large_window_bits }) = undefined;

/// The inputs: text short and long, random octets, a run, random octets then text, and pieces of
/// four alphabets in a seeded order, which one meta-block codes in blocks of several types.
const Case = enum { empty, one, short, long, random, run, mixed, alphabets };
const short_len = 700;
const long_len = 120_000;
const noise_odds = 20;

fn fill_text(generator: *codec.split.Generator, octets: []u8) void {
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

/// One meta-block of pieces, each `piece_len` random octets of one of four alphabets of 16
/// octets, the alphabet seeded: its literals have no matches, and code shorter in blocks.
const alphabets_len = 60_000;
const piece_len = 600;
const alphabet_firsts = [_]u8{ 'a', '0', 'A', high_first };
/// The first octet of the alphabet past ASCII.
const high_first = 0x80;
const alphabet_len = 16;

fn fill_alphabets(generator: *codec.split.Generator, octets: []u8) void {
    var start: usize = 0;
    for (0..octets.len / piece_len) |_| {
        const first = alphabet_firsts[generator.below(alphabet_firsts.len)];
        for (octets[start..][0..piece_len]) |*octet| octet.* = first + @as(u8, @intCast(generator.below(alphabet_len)));
        start += piece_len;
    }
}

fn input_of(case: Case) []const u8 {
    var generator = codec.split.Generator.init(@intFromEnum(case));
    const len: usize = switch (case) {
        .empty => 0,
        .one => 1,
        .short => short_len,
        .long => long_len,
        .random, .run, .mixed => input_len_max,
        .alphabets => alphabets_len,
    };
    switch (case) {
        .random => for (input[0..len]) |*octet| {
            octet.* = @truncate(generator.next());
        },
        .run => @memset(input[0..len], 'z'),
        .alphabets => fill_alphabets(&generator, input[0..len]),
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

/// The bits a literal of one of the four alphabets takes at most: 4 in its block's code, and a
/// part of a bit for the blocks' switches and the codes' descriptions.
const alphabet_bits_max = 5;

/// Text and runs compress to less than this share of their octets.
const compressed_ratio_min = 2;

test "level 5's streams decode to their input, within encoded_len_max" {
    try @call(.never_inline, expect_streams, .{});
}

/// The encoders live on the stack of functions the compiler may not inline, as level 1's tests
/// keep theirs: thread-local state this large would pass aarch64's offsets.
fn expect_streams() !void {
    var small: [1]Small = undefined;
    for (std.enums.values(Case)) |case| {
        const plain = input_of(case);
        small[0].init();
        const written = try small[0].encode_all(plain, &coded);
        try testing.expect(written <= Small.encoded_len_max(plain.len));
        try expect_decodes(coded[0..written], plain);
        const compresses = case == .long or case == .run;
        if (compresses) try testing.expect(written < plain.len / compressed_ratio_min);
        // The four alphabets take a block type each at least, a chunk across two of them perhaps
        // one more, and 4 bits a literal or less.
        if (case == .alphabets) {
            try testing.expect(small[0].codes.split.types_count >= alphabet_firsts.len);
            try testing.expect(written * @bitSizeOf(u8) < plain.len * alphabet_bits_max);
        }
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
    try @call(.never_inline, expect_splits, .{});
}

fn expect_splits() !void {
    var small: [codec.split.state_slots]Small = undefined;
    var generator = codec.split.Generator.init(split_seed);
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
            const outcome = try codec.split.drive_encoder(Small, &small, step, plain, &coded, points[0..count], seed);
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
    try @call(.never_inline, expect_far_copy, .{});
}

fn expect_far_copy() !void {
    var large: Large = undefined;
    // A random block, a run of one octet, whose positions all join one bucket and leave the
    // block's entries in theirs, and the block again: only a match 384 KiB back codes it short.
    var generator = codec.split.Generator.init(far_distance);
    for (input[0..far_len]) |*octet| octet.* = @truncate(generator.next());
    @memset(input[far_len..far_distance], run_octet);
    for (input[far_distance..far_input_len]) |*octet| octet.* = @truncate(generator.next());
    large.init();
    const without = try large.encode_all(input[0..far_input_len], &reference);
    @memcpy(input[far_distance..][0..far_len], input[0..far_len]);
    large.init();
    const with = try large.encode_all(input[0..far_input_len], &coded);
    try expect_decodes(coded[0..with], input[0..far_input_len]);
    try testing.expect(with + far_saved_min < without);
}

/// What the far repeat saves at least: half its octets.
const far_saved_min = 32_768;

/// The run between the far test's blocks.
const run_octet = 'z';

test "a stream begun with start writes the octets of one begun with init" {
    try @call(.never_inline, expect_start_equals_init, .{});
}

/// After a stream whose literals split into blocks, so stale types and bucket entries are left,
/// each input must code as it does after `init` (invariant 5, decision 60).
fn expect_start_equals_init() !void {
    var small: Small = undefined;
    for (std.enums.values(Case)) |case| {
        small.init();
        _ = try small.encode_all(input_of(.alphabets), &coded);
        small.start();
        const plain = input_of(case);
        const started = try small.encode_all(plain, &coded);
        small.init();
        const fresh = try small.encode_all(plain, &reference);
        try testing.expectEqualSlices(u8, reference[0..fresh], coded[0..started]);
    }
}

test "level 5's octets do not depend on the memory its state held before init" {
    try @call(.never_inline, expect_memory_unread, .{});
}

/// Two encoders whose memory held other octets before `init` write the same octets: the state
/// reads nothing it did not write (invariant 4). The text and the text after random octets give
/// meta-blocks of one literal type, the alphabets one of several.
fn expect_memory_unread() !void {
    var states: [state_fills.len]Small = undefined;
    for (&states, state_fills) |*state, fill| @memset(std.mem.asBytes(state), fill);
    for ([_]Case{ .long, .mixed, .alphabets }) |case| {
        const plain = input_of(case);
        states[0].init();
        const first = try states[0].encode_all(plain, &reference);
        states[1].init();
        const second = try states[1].encode_all(plain, &coded);
        try testing.expectEqualSlices(u8, reference[0..first], coded[0..second]);
    }
}

/// The octets the two encoders' memory holds before `init`.
const state_fills = [_]u8{ 0, std.math.maxInt(u8) };
