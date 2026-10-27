//! The tests of the gzip IoReader and IoWriter, the octets and the room given in parts.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const io = @import("io.zig");

const io_parts = codec.io_parts;
const header_len = @import("constants.zig").fixed_header_len;

const plain_len_max = 6000;
/// Room for the stream, which the text codes to fewer octets than its own.
const coded_len_max = 12_000;

test "a gzip stream round-trips through the IoWriter and the IoReader at levels 1, 6 and 9" {
    var plain_buffer: [plain_len_max]u8 = undefined;
    const plain = io_parts.fill_text(&plain_buffer);
    var storage: [coded_len_max]u8 = undefined;
    var output: [plain_len_max]u8 = undefined;
    inline for (.{ 1, 6, 9 }) |level| {
        const coded = try io_parts.expect_round_trip(io.IoWriter(.{ .level = level }), io.IoReader, plain, &storage, &output);
        try testing.expect(coded.len < plain.len);
    }
}

test "a gzip IoReader decodes every member, and refuses one its source ends inside" {
    var plain_buffer: [plain_len_max]u8 = undefined;
    const plain = io_parts.fill_text(&plain_buffer);
    var storage: [coded_len_max]u8 = undefined;
    var output: [2 * plain_len_max]u8 = undefined;
    const coded = try io_parts.expect_round_trip(io.IoWriter(.{ .level = 6 }), io.IoReader, plain, &storage, &output);
    try io_parts.expect_failure(io.IoReader, coded[0 .. coded.len - 1], error.Truncated, &output);
    // RFC 1952 §2.2: a gzip file is a series of members.
    var members: [2 * coded_len_max]u8 = undefined;
    @memcpy(members[0..coded.len], coded);
    @memcpy(members[coded.len..][0..coded.len], coded);
    var source_buffer: [13]u8 = undefined;
    var source: io_parts.PartSource = undefined;
    source.init(members[0 .. 2 * coded.len], 0, &source_buffer);
    var reader: io.IoReader = undefined;
    reader.init(&source.interface, &.{}, .{});
    const decoded = try io_parts.read_in_parts(&reader, &source, 11, .unlimited, &output);
    try testing.expectEqualSlices(u8, plain, decoded[0..plain.len]);
    try testing.expectEqualSlices(u8, plain, decoded[plain.len..]);
    // Octets after a member that do not start another fail the next member's header check.
    @memset(members[coded.len..][0..header_len], 0);
    try io_parts.expect_failure(io.IoReader, members[0 .. coded.len + header_len], error.InvalidIdentification, &output);
}
