//! The gzip decoder's split property, over inputs the fuzzer or a seed draws: any input, valid or
//! not, decoded in one call and under a seeded split that moves the state between calls, gives the
//! same octets, the same verdict and the same `consumed` (decision 11; invariants 5, 12 and 13).
//! No input may reach a panic.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const deflate = @import("deflate");
const gzip = @import("decoder.zig");
const decoder_test = @import("decoder_test.zig");
const Decoder = gzip.Decoder;
const Stream = decoder_test.Stream;

/// The largest input and output one case takes.
const input_len_max = 1024;
const output_len_max = 4096;

/// The seeded cases each normal test run takes, and the bits each flips at most.
const seeded_cases = 2000;
const flips_max = 4;

/// What one way of decoding gave.
const Verdict = union(enum) {
    progress: codec.Progress,
    refused: gzip.Error,
};

fn step(decoder: *Decoder, input: []const u8, output: []u8) gzip.Error!codec.Progress {
    return gzip.decode(decoder, input, output);
}

/// Decodes `input` in one call and under `seed`'s split, and requires the two to agree.
fn check_split(input: []const u8, seed: u64) !void {
    var whole_output: [output_len_max]u8 = undefined;
    var decoder: Decoder = undefined;
    gzip.init(&decoder, .{});
    const whole: Verdict = if (gzip.decode(&decoder, input, &whole_output)) |progress| .{ .progress = progress } else |err| .{ .refused = err };
    var states: [codec.split.state_slots]Decoder = undefined;
    gzip.init(&states[0], .{});
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

/// A valid member to corrupt: every optional field, a stored block, then a fixed block of literals
/// and a match.
fn valid_stream(stream: *Stream) void {
    const stored = "the stored block of a gzip member";
    const literals = "fixed";
    decoder_test.header(stream, .{ .extra = "AB\x01\x00x", .name = "n", .comment = "c", .header_crc = true });
    stream.stored(false, stored);
    stream.block_header(true, .fixed);
    for (literals) |literal| stream.fixed_literal(literal);
    stream.fixed_pair(literals.len, literals.len);
    stream.fixed_literal(deflate.constants.end_of_block);
    decoder_test.trailer(stream, stored ++ literals ++ literals);
}

test "every seeded corruption of a valid stream decodes alike in one call and split" {
    var stream: Stream = .{};
    valid_stream(&stream);
    const valid = stream.slice();
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        @memcpy(input[0..valid.len], valid);
        for (0..generator.below(flips_max + 1)) |_| {
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
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "\x1f\x8b\x08", stream.slice() } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check_split(input[0..input_len], smith.value(u64));
}
