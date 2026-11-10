//! The fuzzer's test of base 64: each input, read as a text, decodes as one of std.base64's four
//! decoders decodes it, or is refused by all of them; and each input, read as octets, encodes in
//! both alphabets, with and without pad characters, to a text that decodes back to it, whole and
//! under a seeded split (invariant 5).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const Encoder = @import("encoder.zig").Encoder;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;

const features = codec.Features.none();

/// The longest input the fuzzer gives, and the room its texts take.
const input_len_max = 512;
const text_len_max = Encoder.encoded_len(input_len_max, true);

test "fuzz base 64 against std.base64 and its own round trip" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &.{ "", "Zm9vYmFy", "Zg==", "a-b_", "a+b/", "Zh==" } });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try decodes_as_std(input[0..input_len]);
    try round_trips(input[0..input_len], smith.value(u64));
}

fn decodes_as_std(text: []const u8) !void {
    const codecs = [_]std.base64.Codecs{ std.base64.standard, std.base64.standard_no_pad, std.base64.url_safe, std.base64.url_safe_no_pad };
    var theirs: [input_len_max]u8 = undefined;
    var ours: [input_len_max]u8 = undefined;
    var expected: ?[]const u8 = null;
    for (codecs) |entry| {
        const len = entry.Decoder.calcSizeForSlice(text) catch continue;
        entry.Decoder.decode(theirs[0..len], text) catch continue;
        expected = theirs[0..len];
        break;
    }
    var state: Decoder = undefined;
    state.init(.{}, features);
    const written = state.decode_all(text, &ours) catch return testing.expect(expected == null);
    try testing.expectEqualSlices(u8, expected orelse return error.TestUnexpectedResult, ours[0..written]);
}

/// The decoder and the end of the text it decodes, so a split call knows its piece is the last.
const SplitDecoder = struct {
    decoder: Decoder,
    text_end: usize,

    fn step(self: *SplitDecoder, input: []const u8, output: []u8) !codec.Progress {
        const piece: decoder_file.Piece = if (@intFromPtr(input.ptr) + input.len == self.text_end) .last else .more;
        return self.decoder.decode(input, output, piece);
    }
};

fn encoder_step(state: *Encoder, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
    return state.encode(input, output, flush);
}

fn round_trips(octets: []const u8, seed: u64) !void {
    var text: [text_len_max]u8 = undefined;
    var back: [input_len_max]u8 = undefined;
    inline for (.{ .standard, .url_safe }) |alphabet| {
        inline for (.{ true, false }) |padding| {
            var encoders: [codec.testing.split.state_slots]Encoder = undefined;
            encoders[0].init(.{ .alphabet = alphabet, .padding = padding }, features);
            const encoded = try codec.testing.split.drive_encoder(Encoder, &encoders, encoder_step, octets, &text, &.{}, seed);
            try testing.expectEqual(.done, encoded.status);
            try testing.expectEqual(Encoder.encoded_len(octets.len, padding), encoded.written);
            var decoders: [codec.testing.split.state_slots]SplitDecoder = undefined;
            decoders[0].decoder.init(.{}, features);
            for (&decoders) |*slot| slot.text_end = @intFromPtr(&text) + encoded.written;
            const decoded = try codec.testing.split.drive(SplitDecoder, &decoders, SplitDecoder.step, text[0..encoded.written], &back, seed);
            try testing.expectEqual(.done, decoded.status);
            try testing.expectEqualSlices(u8, octets, back[0..decoded.written]);
        }
    }
}
