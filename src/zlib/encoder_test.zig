//! Tests for the zlib encoder: each level's header, and every stream decoding to its input through
//! stdx's zlib decoder, whole and under seeded splits (invariant 5).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const deflate = @import("deflate");
const zlib_decoder = @import("decoder.zig");
const encoder = @import("encoder.zig");

const text = "a zlib stream of the encoder, a zlib stream of the encoder, and more of it";

fn Step(comptime level: u4) type {
    return struct {
        const Encoder = encoder.Encoder(.{ .level = level });
        fn step(state: *Encoder, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return state.encode(input, output, flush);
        }
    };
}

test "each level's header names DEFLATE, a 32 KiB window and the level (RFC 1950 section 2.2)" {
    const headers = [_][2]u8{ .{ 0x78, 0x01 }, .{ 0x78, 0x9c }, .{ 0x78, 0xda } };
    inline for (deflate.constants.encoder_levels, headers) |level, expected| {
        var state: Step(level).Encoder = undefined;
        state.init(.{});
        var output: [256]u8 = undefined;
        const written = try state.encode_all(text, &output);
        try testing.expectEqualSlices(u8, &expected, output[0..2]);
        try testing.expect(written <= Step(level).Encoder.encoded_len_max(text.len));
        var decoder: zlib_decoder.Decoder = undefined;
        zlib_decoder.init(&decoder, .{});
        var decoded: [text.len]u8 = undefined;
        const whole = try zlib_decoder.decode_all(&decoder, output[0..written], &decoded);
        try testing.expectEqual(written, whole.consumed);
        try testing.expectEqualStrings(text, decoded[0..whole.written]);
        for (0..50) |seed| {
            var states: [codec.split.state_slots]Step(level).Encoder = undefined;
            states[0].init(.{});
            var split: [256]u8 = undefined;
            const outcome = try codec.split.drive_encoder(Step(level).Encoder, &states, Step(level).step, text, &split, &.{ 10, 40 }, seed);
            try testing.expectEqual(.done, outcome.status);
            zlib_decoder.init(&decoder, .{});
            const split_whole = try zlib_decoder.decode_all(&decoder, split[0..outcome.written], &decoded);
            try testing.expectEqualStrings(text, decoded[0..split_whole.written]);
        }
    }
}
