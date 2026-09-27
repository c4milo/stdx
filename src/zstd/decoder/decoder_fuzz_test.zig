//! The Zstandard decoder's split property, over inputs the fuzzer or a seed draws: any input, valid
//! or not, decoded in one call and under a seeded split that moves the state between calls, gives
//! the same octets, the same verdict and the same `consumed` (decision 11; invariants 5, 12 and
//! 13). The checked path alone gives them too, and so does each claim of decision 14 off, so the
//! fast paths write what the checked path writes (decision 16). No input may reach a panic.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const decoder_module = @import("decoder.zig");
const decoder_test = @import("decoder_test.zig");
const constants = @import("../constants.zig");
const claims = @import("../claims.zig");
const huffman = @import("../huffman.zig");
const StreamWriter = @import("../test_writer.zig").StreamWriter;
const fast_sequences_test = @import("../fast_sequences_test.zig");
const Decoder = decoder_test.Decoder;
const FrameWriter = decoder_test.FrameWriter;

/// The largest input and output one case takes.
const input_len_max = 1024;
const output_len_max = 8192;

/// The seeded cases each normal test run takes, and the bits each flips at most.
const seeded_cases = 3000;
const flips_max = 4;

/// What one way of decoding gave.
const Verdict = union(enum) {
    progress: codec.Progress,
    refused: decoder_module.Error,
};

fn verdict_of(result: decoder_module.Error!codec.Progress) Verdict {
    const progress = result catch |err| return .{ .refused = err };
    return .{ .progress = progress };
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) decoder_module.Error!codec.Progress {
    return decoder.decode(input, output);
}

/// Decodes `input` in one call through `paths`, and requires the verdict and octets of `whole`.
fn check_paths(comptime paths: claims.Paths, input: []const u8, whole: Verdict, whole_output: []const u8) !void {
    const Other = decoder_module.Decoder(.{ .window_len_max = constants.block_len_max, .paths = paths });
    var decoder: Other = undefined;
    decoder.init(.{});
    var output: [output_len_max]u8 = undefined;
    const verdict = verdict_of(decoder.decode(input, &output));
    try testing.expectEqual(whole, verdict);
    if (whole == .progress) try testing.expectEqualSlices(u8, whole_output[0..whole.progress.written], output[0..whole.progress.written]);
}

/// Decodes `input` in one call and under `seed`'s split, and in one call through the checked path
/// alone and with each claim off, and requires all to agree.
fn check_split(input: []const u8, seed: u64) !void {
    var states: [codec.split.state_slots]Decoder = undefined;
    var whole_output: [output_len_max]u8 = undefined;
    states[0].init(.{});
    const whole = verdict_of(states[0].decode(input, &whole_output));
    try check_paths(.{ .fast_paths = false }, input, whole, &whole_output);
    inline for (claims.each_off) |off| try check_paths(.{ .claims = off }, input, whole, &whole_output);
    states[0].init(.{});
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

/// A skippable frame of 12 octets of user data, the third kind of valid frame to corrupt.
const skippable_frame = "\x5e\x2a\x4d\x18\x0c\x00\x00\x00user data 12";

/// The valid frames to corrupt: raw, repeated and compressed blocks with a checksum; and a raw block
/// then Huffman-coded literals with a sequence, under a Window_Descriptor.
fn valid_frames(standard: *FrameWriter, marker: *FrameWriter) !void {
    _ = decoder_test.standard_frame(standard);
    var tree: huffman.Table = undefined;
    _ = try huffman.read_tree(decoder_test.table_24_tree, &tree);
    var stream_writer: StreamWriter = .{};
    decoder_test.marker_frame(marker, stream_writer.write(&tree, decoder_test.marker_literals));
}

/// The seed of the frame of many sequences the corruptions start from.
const many_sequences_seed = 7;

test "every seeded corruption of a valid frame decodes alike in one call and split" {
    var standard: FrameWriter = .{};
    var marker: FrameWriter = .{};
    try valid_frames(&standard, &marker);
    var many: FrameWriter = .{};
    _ = try fast_sequences_test.seeded_frame(&many, many_sequences_seed, .{});
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const frames = [_][]const u8{ standard.written(), marker.written(), skippable_frame, many.written() };
        const valid = frames[generator.below(frames.len)];
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
    var standard: FrameWriter = .{};
    var marker: FrameWriter = .{};
    try valid_frames(&standard, &marker);
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "\x28\xb5\x2f\xfd", standard.written(), marker.written(), skippable_frame } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check_split(input[0..input_len], smith.value(u64));
}
