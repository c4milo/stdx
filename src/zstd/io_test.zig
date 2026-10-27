//! The tests of the Zstandard IoReader and IoWriter, the octets and the room given in parts, over
//! frames written here and frames the encoder writes.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const io = @import("io.zig");

const io_parts = codec.io_parts;

/// The smallest window the decoder takes, so the test's reader fits its stack.
const TestReader = io.IoReader(.{ .window_len_max = @import("constants.zig").block_len_max });

/// Three frames (RFC 8878 §3.1): "hello", a skippable frame of 3 octets, and " world". Each
/// Zstandard frame is its magic number, a Frame_Header_Descriptor with Single_Segment_Flag set and
/// a 1-octet Frame_Content_Size (§3.1.1.1), and one last Raw_Block (§3.1.1.2), every number least
/// significant octet first.
const frames = "\x28\xb5\x2f\xfd" ++ "\x20\x05" ++ "\x29\x00\x00" ++ "hello" ++
    "\x50\x2a\x4d\x18" ++ "\x03\x00\x00\x00" ++ "abc" ++
    "\x28\xb5\x2f\xfd" ++ "\x20\x06" ++ "\x31\x00\x00" ++ " world";

test "a Zstandard IoReader decodes every frame, a skippable one among them" {
    var output: [32]u8 = undefined;
    for (1..4) |part_len| {
        var source_buffer: [5]u8 = undefined;
        var source: io_parts.PartSource = undefined;
        source.init(frames, 0, &source_buffer);
        var reader: TestReader = undefined;
        reader.init(&source.interface, &.{}, .{});
        try testing.expectEqualStrings("hello world", try io_parts.read_in_parts(&reader, &source, part_len, .limited(part_len), &output));
    }
}

test "a Zstandard IoReader refuses a frame its source ends inside, and octets that start none" {
    var output: [32]u8 = undefined;
    try io_parts.expect_failure(TestReader, frames[0 .. frames.len - 1], error.Truncated, &output);
    try io_parts.expect_failure(TestReader, frames ++ "\x00\x00\x00\x00", error.InvalidMagic, &output);
}

test "a Zstandard stream round-trips through the IoWriter and the IoReader at levels 1 and 3" {
    var plain_buffer: [6000]u8 = undefined;
    const plain = io_parts.fill_text(&plain_buffer);
    var storage: [12_000]u8 = undefined;
    var output: [6000]u8 = undefined;
    inline for (.{ 1, 3 }) |level| {
        // A window of a block, which the test's reader holds.
        const coded = try io_parts.expect_round_trip(io.IoWriter(.{ .level = level, .window_log = 17 }), TestReader, plain, &storage, &output);
        try testing.expect(coded.len < plain.len);
    }
}
