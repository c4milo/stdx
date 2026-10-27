//! The tests of the raw DEFLATE IoReader and IoWriter, the octets and the room given in parts.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const io = @import("io.zig");

const io_parts = codec.io_parts;

const plain_len_max = 6000;
/// Room for the stream, which the text codes to fewer octets than its own.
const coded_len_max = 12_000;

test "a raw DEFLATE stream round-trips through the IoWriter and the IoReader at levels 1, 6 and 9" {
    var plain_buffer: [plain_len_max]u8 = undefined;
    const plain = io_parts.fill_text(&plain_buffer);
    var storage: [coded_len_max]u8 = undefined;
    var output: [plain_len_max]u8 = undefined;
    inline for (.{ 1, 6, 9 }) |level| {
        const coded = try io_parts.expect_round_trip(io.IoWriter(.{ .level = level }), io.IoReader, plain, &storage, &output);
        try testing.expect(coded.len < plain.len);
    }
}

test "a raw DEFLATE IoReader refuses a stream its source ends inside, and octets after it" {
    var plain_buffer: [plain_len_max]u8 = undefined;
    const plain = io_parts.fill_text(&plain_buffer);
    var storage: [coded_len_max]u8 = undefined;
    var output: [plain_len_max]u8 = undefined;
    const coded = try io_parts.expect_round_trip(io.IoWriter(.{ .level = 6 }), io.IoReader, plain, &storage, &output);
    try io_parts.expect_failure(io.IoReader, coded[0 .. coded.len - 1], error.Truncated, &output);
    storage[coded.len] = 0;
    try io_parts.expect_failure(io.IoReader, storage[0 .. coded.len + 1], error.TrailingOctets, &output);
}
