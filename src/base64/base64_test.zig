//! Tests of the base 64 encoder and decoder: RFC 4648 §10's vectors, every short input against
//! Zig's std.base64, each refusal, and seeded splits of the input and the output (invariant 5).

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const Alphabet = @import("alphabet.zig").Alphabet;
const encoder_file = @import("encoder.zig");
const Encoder = encoder_file.Encoder;
const decoder_file = @import("decoder.zig");
const Decoder = decoder_file.Decoder;

const features = codec.Features.none();

/// The CPU's own features, so the fast paths reach the AVX2 variant object where the CPU has it.
fn detected() codec.Features {
    return codec.Features.detect();
}

/// RFC 4648 §10's vectors: each input and its base 64 text.
const vectors = [_]struct { []const u8, []const u8 }{
    .{ "", "" },
    .{ "f", "Zg==" },
    .{ "fo", "Zm8=" },
    .{ "foo", "Zm9v" },
    .{ "foob", "Zm9vYg==" },
    .{ "fooba", "Zm9vYmE=" },
    .{ "foobar", "Zm9vYmFy" },
};

/// The most octets an exhaustive sweep encodes, and the room every test gives.
const sweep_octets_max = 2;
const room_len = 64;

/// The room the paths' comparison gives: a text of 512 octets decodes into it.
const paths_room_len = 512;

fn encode(input: []const u8, output: []u8, options: encoder_file.EncoderOptions) ![]const u8 {
    var state: Encoder = undefined;
    state.init(options, features);
    return output[0..try state.encode_all(input, output)];
}

fn decode(text: []const u8, output: []u8, options: decoder_file.DecoderOptions) (decoder_file.Error || error{NoSpaceLeft})![]const u8 {
    var state: Decoder = undefined;
    state.init(options, features);
    return output[0..try state.decode_all(text, output)];
}

test "RFC 4648 §10's vectors encode and decode" {
    var buffer: [room_len]u8 = undefined;
    var octets: [room_len]u8 = undefined;
    for (vectors) |vector| {
        const text = try encode(vector[0], &buffer, .{});
        try testing.expectEqualStrings(vector[1], text);
        try testing.expectEqual(vector[1].len, Encoder.encoded_len(vector[0].len, true));
        try testing.expectEqualStrings(vector[0], try decode(vector[1], &octets, .{}));
        try testing.expectEqual(vector[0].len, try Decoder.decoded_len(vector[1]));
        // Without the pad characters, as RFC 4648 §3.2 lets a specification choose.
        const bare = std.mem.trimEnd(u8, vector[1], "=");
        try testing.expectEqualStrings(bare, try encode(vector[0], &buffer, .{ .padding = false }));
        try testing.expectEqualStrings(vector[0], try decode(bare, &octets, .{}));
        try testing.expectEqual(vector[0].len, try Decoder.decoded_len(bare));
    }
}

test "every input of up to two octets encodes as std.base64 does, in both alphabets" {
    const codecs = [_]struct { std.base64.Codecs, Alphabet, bool }{
        .{ std.base64.standard, .standard, true },
        .{ std.base64.standard_no_pad, .standard, false },
        .{ std.base64.url_safe, .url_safe, true },
        .{ std.base64.url_safe_no_pad, .url_safe, false },
    };
    var input: [sweep_octets_max]u8 = undefined;
    var ours: [room_len]u8 = undefined;
    var theirs: [room_len]u8 = undefined;
    for (0..sweep_octets_max + 1) |len| {
        const count = @as(usize, 1) << @intCast(len * constants.octet_bits);
        for (0..count) |value| {
            std.mem.writeInt(u16, &input, @truncate(value), .little);
            for (codecs) |entry| {
                const expected = entry[0].Encoder.encode(&theirs, input[0..len]);
                const got = try encode(input[0..len], &ours, .{ .alphabet = entry[1], .padding = entry[2] });
                try testing.expectEqualStrings(expected, got);
            }
        }
    }
}

/// The octets a decoding sweep builds its texts from: some letters of each class, the pad
/// character, whitespace, and octets in neither alphabet.
const sweep_letters = "AQgw/+_-Zz09=\n \x00\xff.";

/// The longest text the decoding sweep builds.
const sweep_letters_max = 4;

test "every short text decodes as one of std.base64's four decoders does, or is refused by all" {
    var text: [sweep_letters_max]u8 = undefined;
    for (0..sweep_letters_max + 1) |len| {
        const count = std.math.pow(usize, sweep_letters.len, len);
        for (0..count) |number| {
            var rest = number;
            for (text[0..len]) |*octet| {
                octet.* = sweep_letters[rest % sweep_letters.len];
                rest /= sweep_letters.len;
            }
            try expect_as_std(text[0..len]);
        }
    }
}

/// Requires the decoder to take `text` when one of std's decoders takes it, to the same octets,
/// and to refuse it when every one of them does.
fn expect_as_std(text: []const u8) !void {
    const codecs = [_]std.base64.Codecs{ std.base64.standard, std.base64.standard_no_pad, std.base64.url_safe, std.base64.url_safe_no_pad };
    var theirs: [room_len]u8 = undefined;
    var ours: [room_len]u8 = undefined;
    var expected: ?[]const u8 = null;
    for (codecs) |entry| {
        const len = entry.Decoder.calcSizeForSlice(text) catch continue;
        entry.Decoder.decode(theirs[0..len], text) catch continue;
        expected = theirs[0..len];
        break;
    }
    try expect_paths_agree(text);
    const got = decode(text, &ours, .{}) catch return testing.expect(expected == null);
    try testing.expectEqualStrings(expected orelse return error.TestUnexpectedResult, got);
    try testing.expectEqual(got.len, try Decoder.decoded_len(text));
}

/// Decodes `text` whole with the claims given.
fn decode_claims(comptime claims: decoder_file.Claims, text: []const u8, output: []u8) (decoder_file.Error || error{NoSpaceLeft})![]const u8 {
    var state: Decoder = undefined;
    state.init(.{}, if (claims.whole_quanta) detected() else features);
    const progress = try state.decode_with(claims, text, output, .last);
    const whole = codec.whole(progress) catch return error.NoSpaceLeft;
    return output[0..whole.written];
}

/// Requires decision 16's fast path to give the checked path's octets and verdict for `text`.
pub fn expect_paths_agree(text: []const u8) !void {
    var fast_out: [paths_room_len]u8 = undefined;
    var checked_out: [paths_room_len]u8 = undefined;
    const checked = decode_claims(.{ .whole_quanta = false }, text, &checked_out);
    const fast = decode_claims(.{}, text, &fast_out);
    if (checked) |octets| {
        try testing.expectEqualSlices(u8, octets, try fast);
    } else |err| try testing.expectError(err, fast);
}

test "the encoder's fast path writes the checked path's letters for every length and offset" {
    var input: [paths_room_len / 2]u8 = undefined;
    for (&input, 0..) |*octet, index| octet.* = @truncate(index *% 2654435761 >> 7);
    var fast_text: [paths_room_len]u8 = undefined;
    var checked_text: [paths_room_len]u8 = undefined;
    for (0..input.len) |len| {
        inline for (.{ Alphabet.standard, Alphabet.url_safe }) |alphabet| {
            var fast_state: Encoder = undefined;
            var checked_state: Encoder = undefined;
            fast_state.init(.{ .alphabet = alphabet }, detected());
            checked_state.init(.{ .alphabet = alphabet }, features);
            const fast = fast_state.encode_with(.{}, input[0..len], &fast_text, .finish);
            const checked = checked_state.encode_with(.{ .whole_groups = false }, input[0..len], &checked_text, .finish);
            try testing.expectEqual(checked, fast);
            try testing.expectEqualStrings(checked_text[0..checked.written], fast_text[0..fast.written]);
            try expect_paths_agree(fast_text[0..fast.written]);
        }
    }
}

test "each refusal names its cause" {
    var octets: [room_len]u8 = undefined;
    const cases = [_]struct { []const u8, decoder_file.Error }{
        .{ "Zm9v Yg==", error.InvalidCharacter },
        .{ "Zm9vYg==\n", error.InvalidPadding },
        .{ "a+b_", error.MixedAlphabets },
        .{ "a-b/", error.MixedAlphabets },
        .{ "Zm9vY", error.InvalidLength },
        .{ "Zg=", error.InvalidPadding },
        .{ "Zg===", error.InvalidPadding },
        .{ "Z===", error.InvalidPadding },
        .{ "=Zg=", error.InvalidPadding },
        .{ "Zh==", error.NonCanonical },
        .{ "Zm9=", error.NonCanonical },
        .{ "Zh", error.NonCanonical },
    };
    for (cases) |case| try testing.expectError(case[1], decode(case[0], &octets, .{}));
    try testing.expectError(error.InvalidCharacter, decode("ab-_", &octets, .{ .accept = .standard }));
    try testing.expectError(error.InvalidCharacter, decode("ab+/", &octets, .{ .accept = .url_safe }));
    try testing.expectError(error.InvalidPadding, decode("Zg", &octets, .{ .padding = .required }));
    try testing.expectError(error.InvalidPadding, decode("Zg==", &octets, .{ .padding = .refused }));
    try testing.expectError(error.NoSpaceLeft, decode("Zm9vYmFy", octets[0..5], .{}));
}

test "decoded_len refuses the lengths no text has" {
    try testing.expectError(error.InvalidPadding, Decoder.decoded_len("Zg="));
    try testing.expectError(error.InvalidPadding, Decoder.decoded_len("Zm9vY="));
    try testing.expectError(error.InvalidLength, Decoder.decoded_len("Zm9vY"));
    try testing.expectEqual(4, try Decoder.decoded_len("Zm9vYg=="));
}

test "the decoder says which alphabet a text used" {
    var state: Decoder = undefined;
    var octets: [room_len]u8 = undefined;
    inline for (.{ .{ "ab+/", Alphabet.standard }, .{ "ab-_", Alphabet.url_safe } }) |case| {
        state.init(.{}, features);
        _ = try state.decode_all(case[0], &octets);
        try testing.expectEqual(case[1], state.alphabet().?);
    }
    state.init(.{}, features);
    _ = try state.decode_all("Zm9v", &octets);
    try testing.expectEqual(null, state.alphabet());
}

/// The longest input the split tests draw, and the seeds each runs.
const split_input_len_max = 200;
const split_seeds = 64;
const split_flush_points = 3;

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

test "a seeded split of the input and the output changes no octet (invariant 5)" {
    var generator = codec.testing.split.Generator.init(1);
    var input: [split_input_len_max]u8 = undefined;
    var whole: [split_input_len_max * 2]u8 = undefined;
    var split_out: [split_input_len_max * 2]u8 = undefined;
    var back: [split_input_len_max]u8 = undefined;
    for (0..split_seeds) |seed| {
        const len = generator.below(split_input_len_max);
        for (input[0..len]) |*octet| octet.* = @truncate(generator.next());
        const padding = generator.below(2) == 0;
        const text = try encode(input[0..len], &whole, .{ .padding = padding });
        var encoders: [codec.testing.split.state_slots]Encoder = undefined;
        encoders[0].init(.{ .padding = padding }, features);
        // Flush points, ascending and before the input's end: a flush ends no text (decision 68).
        var points: [split_flush_points]usize = undefined;
        const points_len: usize = if (len > split_flush_points) split_flush_points else 0;
        for (points[0..points_len], 0..) |*point, index| point.* = (index + 1) * len / (split_flush_points + 1);
        const encoded = try codec.testing.split.drive_encoder(Encoder, &encoders, encoder_step, input[0..len], &split_out, points[0..points_len], seed);
        try testing.expectEqual(.done, encoded.status);
        try testing.expectEqualStrings(text, split_out[0..encoded.written]);
        var decoders: [codec.testing.split.state_slots]SplitDecoder = undefined;
        decoders[0].decoder.init(.{}, features);
        for (&decoders) |*slot| slot.text_end = @intFromPtr(text.ptr) + text.len;
        const decoded = try codec.testing.split.drive(SplitDecoder, &decoders, SplitDecoder.step, text, &back, seed);
        try testing.expectEqual(.done, decoded.status);
        try testing.expectEqualSlices(u8, input[0..len], back[0..decoded.written]);
    }
}
