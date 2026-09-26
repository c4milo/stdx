//! Tests for the gzip encoder: each level's header, and every member decoding to its input through
//! stdx's gzip decoder, whole and under seeded splits (invariant 5).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const deflate = @import("deflate");
const gzip_decoder = @import("decoder.zig");
const encoder = @import("encoder.zig");

const text = "a gzip member of the encoder, a gzip member of the encoder, and more of it";

fn Step(comptime level: u4) type {
    return struct {
        const Encoder = encoder.Encoder(.{ .level = level });
        fn step(state: *Encoder, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return state.encode(input, output, flush);
        }
    };
}

test "each level's header holds no time, an unknown host and the level's XFL (RFC 1952 section 2.3.1)" {
    const extra_flags = [_]u8{ 4, 0, 2 };
    inline for (deflate.constants.encoder_levels, extra_flags) |level, xfl| {
        var state: Step(level).Encoder = undefined;
        state.init(.{});
        var output: [256]u8 = undefined;
        const written = try state.encode_all(text, &output);
        try testing.expectEqualSlices(u8, &.{ 0x1f, 0x8b, 8, 0, 0, 0, 0, 0, xfl, 255 }, output[0..10]);
        try testing.expect(written <= Step(level).Encoder.encoded_len_max(text.len));
        var decoder: gzip_decoder.Decoder = undefined;
        gzip_decoder.init(&decoder, .{});
        var decoded: [text.len]u8 = undefined;
        const whole = try gzip_decoder.decode_all(&decoder, output[0..written], &decoded);
        try testing.expectEqual(written, whole.consumed);
        try testing.expectEqualStrings(text, decoded[0..whole.written]);
        for (0..50) |seed| {
            var states: [codec.split.state_slots]Step(level).Encoder = undefined;
            states[0].init(.{});
            var split: [256]u8 = undefined;
            const outcome = try codec.split.drive_encoder(Step(level).Encoder, &states, Step(level).step, text, &split, &.{ 10, 40 }, seed);
            try testing.expectEqual(.done, outcome.status);
            gzip_decoder.init(&decoder, .{});
            const split_whole = try gzip_decoder.decode_all(&decoder, split[0..outcome.written], &decoded);
            try testing.expectEqualStrings(text, decoded[0..split_whole.written]);
        }
    }
}
