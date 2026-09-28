//! The decoder's split property, over inputs the fuzzer or a seed draws: any input, valid or not,
//! gives the same tokens and verdict one token a call, under seeded splits that move the state
//! between calls, and with every claim off or on (decision 21; invariants 5, 12 and 13). No input
//! may reach a panic.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const decoder_test = @import("decoder_test.zig");

/// The largest input one case takes.
const input_len_max = 1024;

/// The seeded cases each normal test run takes, the octets each flips at most, and the splits
/// each case is decoded under.
const seeded_cases = 1500;
const flips_max = 4;
const case_seeds = 3;

/// Valid texts, whose flipped octets make most of the cases.
const texts = [_][]const u8{
    "{\"Image\":{\"Width\":800,\"Height\":600,\"Title\":\"View from 15th Floor\",\"Animated\":false,\"IDs\":[116,943,234,38793]}}",
    "[{\"precision\":\"zip\",\"Latitude\":37.7668,\"Longitude\":-122.3959,\"Address\":\"\",\"City\":\"SAN FRANCISCO\"}]",
    " { \"a\" : [ 1e-5 , -0 , true , null , \"\\u00e9\\uD834\\uDD1E\\n\" ] } ",
    "\"caf\xc3\xa9 \xe2\x82\xac \xf0\x9d\x84\x9e\"",
    "\x1e{\"time\":1234.567,\"name\":\"transport:packet_sent\",\"data\":{\"raw\":\"00ff\"}}\n",
};

/// The octets a flip writes, weighted toward the ones the grammar turns on.
const flip_octets = "{}[]:,\"\\ \t\n\x1e0-.eEtfnu\x00\x1f\x80\xc3\xed\xef\xff";

fn check(input: []const u8, seed: u64) !void {
    _ = try decoder_test.expect_consistent(.text, input, 0);
    _ = try decoder_test.expect_consistent(.sequence, input, 0);
    for (0..case_seeds) |index| {
        var expected: decoder_test.Transcript = .{};
        var transcript: decoder_test.Transcript = .{};
        for ([_]@import("../framing.zig").Framing{ .text, .sequence }) |framing| {
            expected.len = 0;
            transcript.len = 0;
            const verdict = decoder_test.decode_whole(.{}, framing, input, &expected);
            try testing.expectEqual(verdict, try decoder_test.decode_split(framing, input, seed +% index, &transcript));
            try testing.expectEqualStrings(expected.slice(), transcript.slice());
        }
    }
}

test "every seeded corruption of a valid text decodes alike every way" {
    var input: [input_len_max]u8 = undefined;
    for (0..seeded_cases) |seed| {
        var generator = codec.split.Generator.init(seed);
        const text = texts[generator.below(texts.len)];
        @memcpy(input[0..text.len], text);
        for (0..generator.below(flips_max + 1)) |_| {
            input[generator.below(text.len)] = flip_octets[generator.below(flip_octets.len)];
        }
        const len = if (generator.below(2) == 0) text.len else generator.below(text.len + 1);
        try check(input[0..len], generator.next());
    }
}

test "fuzz the decoder's split property" {
    try testing.fuzz({}, fuzz_one, .{ .corpus = &texts });
}

fn fuzz_one(_: void, smith: *testing.Smith) anyerror!void {
    var input: [input_len_max]u8 = undefined;
    const input_len = smith.slice(&input);
    try check(input[0..input_len], smith.value(u64));
}
