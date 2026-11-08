//! The value decoder's split property, over inputs the fuzzer or a seed draws (decision 61): any
//! input, valid or not, gives the same verdict whole and under seeded splits of the input, and a
//! value it decodes encodes to a text that decodes to the same value. No input may reach a panic.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const Decimal = @import("../format.zig").Decimal;
const Piece = @import("../framing.zig").Piece;
const value_decoder = @import("value_decoder.zig");
const value_encoder = @import("value_encoder.zig");

const Color = enum { red, green };
const Point = struct { x: i32, y: i64 };
const Record = struct {
    name: []const u8,
    count: ?u16,
    ratio: Decimal,
    color: Color,
    origin: Point,
    pair: [pair_len]?bool,
    depth: u8 = default_depth,
};
const pair_len = 2;
const default_depth = 1;

/// The largest input one case takes, the storage its strings take, and the room its text
/// encodes into.
const input_len_max = 256;
const storage_len = 256;
const output_len = 512;

/// The seeded cases each normal test run takes, the octets each flips at most, and the most
/// octets a split gives one call.
const seeded_cases = 2000;
const flips_max = 3;
const split_len_max = 9;
/// The calls a split may take an octet of input, so that the empty pieces leave room for the rest.
const split_calls_per_octet = 4;

/// Valid texts, whose flipped octets make most of the cases.
const texts = [_][]const u8{
    "{\"name\":\"a\\u00e9\",\"count\":7,\"ratio\":1.5,\"color\":\"red\",\"origin\":{\"x\":-1,\"y\":2},\"pair\":[true,null]}",
    "{\"pair\":[false,false],\"origin\":{\"y\":0,\"x\":0},\"color\":\"green\",\"ratio\":-0.25,\"count\":null,\"name\":\"\",\"depth\":3}",
};

/// The octets a flip writes, weighted toward the ones the grammar and the type turn on.
const flip_octets = "{}[]:,\"\\ 0123-.enul\x00\xff";

fn decode_split(input: []const u8, seed: u64, storage: []u8, record: *Record) value_decoder.Error!bool {
    var generator = codec.testing.split.Generator.init(seed);
    var state: value_decoder.ValueDecoder(Record) = undefined;
    state.init(.text, codec.Features.none());
    var consumed: usize = 0;
    // A drawn piece may be empty, so the last call takes the rest whatever the draws were.
    const calls = split_calls_per_octet * (input.len + 1);
    for (0..calls) |call| {
        const drawn = @min(consumed + @as(usize, @intCast(generator.between(0, split_len_max))), input.len);
        const end = if (call + 1 == calls) input.len else drawn;
        const piece: Piece = if (end == input.len) .last else .more;
        const progress = try state.decode(input[consumed..end], storage, piece, record);
        consumed += progress.consumed;
        if (progress.status == .done) return true;
        if (piece == .last) return false;
    }
    return false;
}

fn check(input: []const u8, seed: u64) !void {
    var storage: [storage_len]u8 = undefined;
    const whole = value_decoder.decode_value(Record, input, &storage, .text, codec.Features.none());
    var split_storage: [storage_len]u8 = undefined;
    var split_record: Record = undefined;
    const split = decode_split(input, seed, &split_storage, &split_record);
    const record = whole catch |err| {
        // A text the whole call refuses, the split calls refuse or find cut short alike.
        if (err == error.Truncated) return testing.expectEqual(false, split catch return error.TestVerdicts);
        return testing.expectError(err, split);
    };
    try testing.expect(try split);
    var output: [output_len]u8 = undefined;
    const text = try value_encoder.encode_value(Record, &record, &output, .text, codec.Features.none());
    var split_output: [output_len]u8 = undefined;
    try testing.expectEqualStrings(text, try value_encoder.encode_value(Record, &split_record, &split_output, .text, codec.Features.none()));
    var again_storage: [storage_len]u8 = undefined;
    const again = try value_decoder.decode_value(Record, text, &again_storage, .text, codec.Features.none());
    var again_output: [output_len]u8 = undefined;
    try testing.expectEqualStrings(text, try value_encoder.encode_value(Record, &again, &again_output, .text, codec.Features.none()));
}

test "every seeded corruption of a valid text decodes alike whole and split" {
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.testing.split.Generator.init(seed);
        const text = texts[generator.below(texts.len)];
        @memcpy(input[0..text.len], text);
        for (0..generator.below(flips_max + 1)) |_| {
            input[generator.below(text.len)] = flip_octets[generator.below(flip_octets.len)];
        }
        const len = if (generator.below(2) == 0) text.len else generator.below(text.len + 1);
        try check(input[0..len], generator.next());
    }
}

test "fuzz the value decoder's split property" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &texts });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check(input[0..input_len], smith.value(u64));
}
