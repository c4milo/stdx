//! The DEFLATE decoder's split property, over inputs the fuzzer or a seed draws: any input, valid
//! or not, decoded in one call and under a seeded split that moves the state between calls, gives
//! the same octets, the same verdict and the same `consumed` (decision 11; invariants 5, 12 and 13).
//! The checked path alone gives them too, so the fast path writes what the checked path writes
//! (decision 16). No input may reach a panic.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const deflate = @import("decoder.zig");
const decoder_test = @import("decoder_test.zig");
const Decoder = deflate.Decoder;
const Stream = decoder_test.Stream;

/// The largest input and output one case takes.
const input_len_max = 1024;
const output_len_max = 8192;

/// The seeded cases each normal test run takes, and the bits each flips at most.
const seeded_cases = 3000;
const flips_max = 4;

/// What one way of decoding gave.
const Verdict = union(enum) {
    progress: codec.Progress,
    refused: deflate.Error,
};

fn verdict_of(result: deflate.Error!codec.Progress) Verdict {
    const progress = result catch |err| return .{ .refused = err };
    return .{ .progress = progress };
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) deflate.Error!codec.Progress {
    return deflate.decode(decoder, input, output);
}

/// Decodes `input` in one call and under `seed`'s split, and in one call through the checked path
/// alone, and requires the three to agree.
fn check_split(input: []const u8, seed: u64) !void {
    var whole_output: [output_len_max]u8 = undefined;
    var decoder: Decoder = undefined;
    deflate.init(&decoder, .{});
    const whole = verdict_of(deflate.decode(&decoder, input, &whole_output));
    var checked_output: [output_len_max]u8 = undefined;
    deflate.init(&decoder, .{});
    const checked = verdict_of(deflate.decode_with(.{ .fast_paths = false }, &decoder, input, &checked_output));
    try testing.expectEqual(checked, whole);
    if (whole == .progress) try testing.expectEqualSlices(u8, checked_output[0..whole.progress.written], whole_output[0..whole.progress.written]);
    var states: [codec.split.state_slots]Decoder = undefined;
    deflate.init(&states[0], .{});
    var split_output: [output_len_max]u8 = undefined;
    const outcome = codec.split.drive(Decoder, &states, step, input, &split_output, seed) catch |err| {
        try testing.expectEqual(Verdict{ .refused = @errorCast(err) }, whole);
        return;
    };
    const progress = switch (whole) {
        .progress => |progress| progress,
        .refused => |err| return testing.expectEqual(Verdict{ .refused = err }, Verdict{ .progress = .{ .consumed = outcome.consumed, .written = outcome.written, .status = outcome.status } }),
    };
    try testing.expectEqual(progress.status, outcome.status);
    try testing.expectEqual(progress.written, outcome.written);
    try testing.expectEqual(progress.consumed, outcome.consumed);
    try testing.expectEqualSlices(u8, whole_output[0..progress.written], split_output[0..outcome.written]);
}

/// The matches of the stream to corrupt: one that repeats its literals, and a longest one.
const short_match_len = 20;
const long_match_distance = 30;

/// A valid stream of every block type to corrupt: a stored block, a fixed block with matches, and
/// a stored block again.
fn valid_stream(stream: *Stream) void {
    stream.stored(false, "the stored block, the stored block");
    stream.block_header(false, .fixed);
    for ("abcdefgh") |octet| stream.fixed_literal(octet);
    stream.fixed_pair(short_match_len, @intCast("abcdefgh".len));
    stream.fixed_pair(constants.match_len_max, long_match_distance);
    stream.fixed_literal(constants.end_of_block);
    stream.stored(true, "end");
}

test "every seeded corruption of a valid stream decodes alike in one call and split" {
    var stream: Stream = .{};
    valid_stream(&stream);
    const valid = stream.slice();
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        @memcpy(input[0..valid.len], valid);
        const flips = generator.below(flips_max + 1);
        for (0..flips) |_| {
            const bit = generator.below(valid.len * @bitSizeOf(u8));
            input[bit / @bitSizeOf(u8)] ^= @as(u8, 1) << @intCast(bit % @bitSizeOf(u8));
        }
        const len = if (generator.below(2) == 0) valid.len else generator.below(valid.len + 1);
        try check_split(input[0..len], generator.next());
    }
}

test "fuzz the decoder's split property" {
    var stream: Stream = .{};
    valid_stream(&stream);
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "\x03\x00", stream.slice() } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check_split(input[0..input_len], smith.value(u64));
}
