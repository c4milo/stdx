//! The tests of the brotli IoReader, the octets given in parts, over the module's fixtures.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const io = @import("io.zig");

const io_parts = codec.io_parts;

/// A window of 2^18 octets, so the test's reader fits its stack.
const test_window_bits = 18;
const TestReader = io.IoReader(.{ .window_bits_max = test_window_bits });

const coded = @embedFile("fixtures/text-q5-w16.br");
const plain = @embedFile("fixtures/text.txt");

test "a brotli IoReader decodes a stream given in parts" {
    var output: [plain.len]u8 = undefined;
    for ([_]usize{ 1, 7, 100 }) |part_len| {
        var source_buffer: [11]u8 = undefined;
        var source: io_parts.PartSource = undefined;
        source.init(coded, 0, &source_buffer);
        var reader: TestReader = undefined;
        reader.init(&source.interface, &.{}, .{});
        try testing.expectEqualSlices(u8, plain, try io_parts.read_in_parts(&reader, &source, part_len, .limited(part_len * 3), &output));
    }
}

test "a brotli IoReader refuses a stream its source ends inside, and octets after it" {
    var output: [plain.len]u8 = undefined;
    try io_parts.expect_failure(TestReader, coded[0 .. coded.len - 1], error.Truncated, &output);
    try io_parts.expect_failure(TestReader, coded ++ "\x00", error.TrailingOctets, &output);
}
