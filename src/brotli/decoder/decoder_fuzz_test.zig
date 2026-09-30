//! The brotli decoder's split property, over inputs the fuzzer or a seed draws: any input, valid or
//! not, decoded in one call and under a seeded split that moves the state between calls, gives the
//! same octets, the same verdict and the same `consumed` (decision 11; invariants 5, 12 and 13), and
//! so does the checked path alone (decision 16). No input may reach a panic, and no call may work
//! past invariant 17's bound.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const decoder_module = @import("decoder.zig");
const work_test = @import("decoder_work_test.zig");

const Decoder = decoder_module.Decoder(.{ .window_bits_max = test_window_bits });
const test_window_bits = 16;
const claims = @import("../claims.zig");

/// The largest input and output one case takes.
const input_len_max = 2048;
const output_len_max = 8192;

/// The seeded cases each normal test run takes, and the bits each flips at most.
const seeded_cases = 1500;
const flips_max = 4;

/// The valid streams the corruptions start from: an uncompressed meta-block, metadata, and
/// compressed meta-blocks of text and of binary octets.
const valid_streams = [_][]const u8{
    @embedFile("../fixtures/hello-q0-w16.br"),
    @embedFile("../fixtures/hello-comment.br"),
    @embedFile("../fixtures/text-q0-w16.br"),
    @embedFile("../fixtures/text-q5-w16.br"),
    @embedFile("../fixtures/text-q11-w10.br"),
    @embedFile("../fixtures/wave-q11-w16.br"),
};

/// What one way of decoding gave.
const Verdict = union(enum) {
    progress: codec.Progress,
    refused: decoder_module.Error,
};

fn verdict_of(result: decoder_module.Error!codec.Progress) Verdict {
    const progress = result catch |err| return .{ .refused = err };
    return .{ .progress = progress };
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) (decoder_module.Error || error{TestWorkPastBound})!codec.Progress {
    const before = decoder.state.work;
    const progress = try decoder.decode(input, output);
    if (!work_test.within_bound(decoder.state.work - before, progress.consumed, progress.written)) return error.TestWorkPastBound;
    return progress;
}

/// Decodes `input` in one call, and requires its count within invariant 17's bound.
fn decode_whole(decoder: *Decoder, input: []const u8, output: []u8) !Verdict {
    decoder.init(codec.Features.detect());
    const verdict = verdict_of(decoder.decode(input, output));
    switch (verdict) {
        .progress => |progress| try testing.expect(work_test.within_bound(decoder.state.work, progress.consumed, progress.written)),
        .refused => {},
    }
    return verdict;
}

/// The zero octets after each input the paths decode, so that the fast path's input margin holds
/// at the input's last commands, and the fast path meets what is there (decision 16).
const padding_len = 16;

/// Decodes `input`, padded, in one call with the checked path alone, and with the fast path with
/// every claim on and with each off, and requires the same verdict and octets of all (decision
/// 16). Each decode keeps its decoder in a frame of its own.
noinline fn check_paths(unpadded: []const u8) !void {
    var padded: [input_len_max + padding_len]u8 = undefined;
    @memcpy(padded[0..unpadded.len], unpadded);
    @memset(padded[unpadded.len..][0..padding_len], 0);
    const input = padded[0 .. unpadded.len + padding_len];
    var checked_output: [output_len_max]u8 = undefined;
    const checked = decode_with(.{ .fast_paths = false }, input, &checked_output);
    try expect_paths(.{}, input, checked, &checked_output);
    inline for (claims.each_off) |off| try expect_paths(.{ .claims = off }, input, checked, &checked_output);
}

/// Decodes `input` in one call with `paths`, in a frame of its own.
noinline fn decode_with(comptime paths: claims.Paths, input: []const u8, output: *[output_len_max]u8) Verdict {
    var decoder: decoder_module.Decoder(.{ .window_bits_max = test_window_bits, .paths = paths }) = undefined;
    decoder.init(codec.Features.detect());
    return verdict_of(decoder.decode(input, output));
}

/// Decodes `input` with `paths`, and requires the verdict and the octets `expected` gave.
noinline fn expect_paths(comptime paths: claims.Paths, input: []const u8, expected: Verdict, expected_output: *const [output_len_max]u8) !void {
    var output: [output_len_max]u8 = undefined;
    const verdict = decode_with(paths, input, &output);
    try testing.expectEqual(expected, verdict);
    switch (verdict) {
        .progress => |progress| try testing.expectEqualSlices(u8, expected_output[0..progress.written], output[0..progress.written]),
        .refused => {},
    }
}

/// Decodes `input` in one call and under `seed`'s split, and requires both to agree.
noinline fn check_split(input: []const u8, seed: u64) !void {
    var states: [codec.split.state_slots]Decoder = undefined;
    var whole_output: [output_len_max]u8 = undefined;
    const whole = try decode_whole(&states[0], input, &whole_output);
    states[0].init(codec.Features.detect());
    var split_output: [output_len_max]u8 = undefined;
    const outcome = codec.split.drive(Decoder, &states, step, input, &split_output, seed) catch |err| {
        if (err == error.TestWorkPastBound) return err;
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

test "every seeded corruption of a valid stream decodes alike in one call and split" {
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const valid = valid_streams[generator.below(valid_streams.len)];
        @memcpy(input[0..valid.len], valid);
        for (0..generator.below(flips_max + 1)) |_| {
            const bit = generator.below(valid.len * @bitSizeOf(u8));
            input[bit / @bitSizeOf(u8)] ^= @as(u8, 1) << @intCast(bit % @bitSizeOf(u8));
        }
        const len = if (generator.below(2) == 0) valid.len else generator.below(valid.len + 1);
        try check_split(input[0..len], generator.next());
        try check_paths(input[0..len]);
    }
}

test "fuzz the decoder's split property" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &valid_streams });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check_split(input[0..input_len], smith.value(u64));
    try check_paths(input[0..input_len]);
}
