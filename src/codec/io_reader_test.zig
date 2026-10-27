//! The tests of `IoReader`, over a decoder of a toy format: each octet decodes to itself twice,
//! octet 0 ends a stream, and octet 0xff is refused. A decoded octet can wait in the state for
//! room after the decoder took all its input, as a back-reference does in a real format. The
//! refusal's name starts with `Test`, which tells the rfc-citation rule that no RFC states it.

const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const status = @import("status.zig");
const Features = @import("features.zig").Features;
const io_reader = @import("io_reader.zig");
const io_parts = @import("io_parts.zig");

const Writer = std.Io.Writer;

const end_octet: u8 = 0;
const refused_octet: u8 = 0xff;
const copies: u2 = 2;

const Twice = struct {
    pending: u8,
    pending_count: u2,
    done: bool,

    fn init(self: *Twice, features: Features) void {
        _ = features;
        self.* = .{ .pending = 0, .pending_count = 0, .done = false };
    }

    fn decode(self: *Twice, input: []const u8, output: []u8) error{TestRefused}!status.Progress {
        // A call after `done` without `init` is a programmer error, as in every codec.
        assert(!self.done);
        var consumed: usize = 0;
        var written: usize = 0;
        for (0..input.len + output.len + 1) |_| {
            if (self.pending_count > 0) {
                if (written == output.len) return .{ .consumed = consumed, .written = written, .status = .needs_room };
                output[written] = self.pending;
                written += 1;
                self.pending_count -= 1;
                continue;
            }
            if (consumed == input.len) return .{ .consumed = consumed, .written = written, .status = .needs_input };
            const octet = input[consumed];
            consumed += 1;
            if (octet == refused_octet) return error.TestRefused;
            if (octet == end_octet) {
                self.done = true;
                return .{ .consumed = consumed, .written = written, .status = .done };
            }
            self.pending = octet;
            self.pending_count = copies;
        }
        unreachable;
    }
};

const OneStream = io_reader.IoReader(Twice, error{TestRefused}, .{ .init = Twice.init, .decode = Twice.decode, .after_done = .refuse });
const ManyStreams = io_reader.IoReader(Twice, error{TestRefused}, .{ .init = Twice.init, .decode = Twice.decode, .after_done = .restart });

test "an IoReader decodes a stream given whole, then ends with its source" {
    var source_buffer: [8]u8 = undefined;
    var source: io_parts.PartSource = undefined;
    source.init("abc\x00", 4, &source_buffer);
    var reader: OneStream = undefined;
    reader.init(&source.interface, &.{}, .{});
    var output: [16]u8 = undefined;
    try testing.expectEqualStrings("aabbcc", try io_parts.read_in_parts(&reader, &source, 0, .unlimited, &output));
    try testing.expectEqual(null, reader.failure);
    var writer: Writer = .fixed(&output);
    try testing.expectError(error.EndOfStream, reader.interface.stream(&writer, .unlimited));
}

test "an IoReader keeps its state across each ReadFailed of its source" {
    const coded = "hello, world\x00";
    for (1..4) |part_len| {
        var source_buffer: [3]u8 = undefined;
        var source: io_parts.PartSource = undefined;
        source.init(coded, 0, &source_buffer);
        var reader: OneStream = undefined;
        reader.init(&source.interface, &.{}, .{});
        var output: [32]u8 = undefined;
        try testing.expectEqualStrings("hheelllloo,,  wwoorrlldd", try io_parts.read_in_parts(&reader, &source, part_len, .unlimited, &output));
    }
}

test "an IoReader writes a decoded octet the state holds without reading its source" {
    // The source has no octet to give after "ab": a read of it would fail, and `failure` would
    // stay null. The writer takes one octet a call, so the second `b` waits in the state.
    var source_buffer: [4]u8 = undefined;
    var source: io_parts.PartSource = undefined;
    source.init("ab\x00", 2, &source_buffer);
    var reader: OneStream = undefined;
    reader.init(&source.interface, &.{}, .{});
    var output: [4]u8 = undefined;
    var writer: Writer = .fixed(&output);
    for (0..output.len) |index| {
        try testing.expectEqual(1, try reader.interface.stream(&writer, .limited(1)));
        try testing.expectEqual("aabb"[index], output[index]);
    }
    try testing.expectError(error.ReadFailed, reader.interface.stream(&writer, .limited(1)));
    try testing.expectEqual(null, reader.failure);
}

test "an IoReader refuses a stream its source ends inside, and stays stopped" {
    var source_buffer: [4]u8 = undefined;
    var source: io_parts.PartSource = undefined;
    source.init("abc", 3, &source_buffer);
    var reader: OneStream = undefined;
    reader.init(&source.interface, &.{}, .{});
    var output: [16]u8 = undefined;
    try testing.expectError(error.Truncated, io_parts.read_in_parts(&reader, &source, 0, .unlimited, &output));
    var writer: Writer = .fixed(&output);
    try testing.expectError(error.ReadFailed, reader.interface.stream(&writer, .unlimited));
    try testing.expectEqual(error.Truncated, reader.failure.?);
}

test "an IoReader passes on the decoder's refusal" {
    var source_buffer: [4]u8 = undefined;
    var source: io_parts.PartSource = undefined;
    source.init("a\xffb\x00", 4, &source_buffer);
    var reader: OneStream = undefined;
    reader.init(&source.interface, &.{}, .{});
    var output: [16]u8 = undefined;
    try testing.expectError(error.TestRefused, io_parts.read_in_parts(&reader, &source, 0, .unlimited, &output));
}

test "an IoReader of one stream refuses the octets after it, and one of many decodes them" {
    const coded = "ab\x00cd\x00";
    var source_buffer: [4]u8 = undefined;
    var output: [16]u8 = undefined;
    var source: io_parts.PartSource = undefined;
    source.init(coded, 0, &source_buffer);
    var one: OneStream = undefined;
    one.init(&source.interface, &.{}, .{});
    try testing.expectError(error.TrailingOctets, io_parts.read_in_parts(&one, &source, 1, .unlimited, &output));
    source.init(coded, 0, &source_buffer);
    var many: ManyStreams = undefined;
    many.init(&source.interface, &.{}, .{});
    try testing.expectEqualStrings("aabbccdd", try io_parts.read_in_parts(&many, &source, 1, .unlimited, &output));
}

test "an IoReader with a buffer serves peeks, and a writer with no buffer" {
    var source_buffer: [4]u8 = undefined;
    var source: io_parts.PartSource = undefined;
    source.init("xyz\x00", 4, &source_buffer);
    var reader: OneStream = undefined;
    var buffer: [3]u8 = undefined;
    reader.init(&source.interface, &buffer, .{});
    try testing.expectEqualStrings("xx", try reader.interface.peek(2));
    try testing.expectEqual('x', try reader.interface.takeByte());
    var discarding: Writer.Discarding = .init(&.{});
    try testing.expectEqual(5, try reader.interface.streamRemaining(&discarding.writer));
}

test "an IoReader asked for no octets decodes nothing and takes nothing" {
    var source_buffer: [4]u8 = undefined;
    var source: io_parts.PartSource = undefined;
    source.init("ab\x00", 3, &source_buffer);
    var reader: OneStream = undefined;
    reader.init(&source.interface, &.{}, .{});
    var output: [4]u8 = undefined;
    var writer: Writer = .fixed(&output);
    try testing.expectEqual(0, try reader.interface.stream(&writer, .nothing));
    try testing.expectEqual(0, source.read_len);
    try testing.expectEqualStrings("aabb", try io_parts.read_in_parts(&reader, &source, 0, .unlimited, &output));
}
