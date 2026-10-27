//! The tests of `IoWriter`, over an encoder of a toy format: each octet encodes to itself, a flush
//! writes `|` after the octets taken since the last flush, and the end of the stream is `.`.

const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const status = @import("status.zig");
const Features = @import("features.zig").Features;
const io_writer = @import("io_writer.zig");
const io_parts = @import("io_parts.zig");

const flush_marker: u8 = '|';
const end_marker: u8 = '.';

const Copy = struct {
    /// Whether octets were taken since the last flush.
    unflushed: bool,
    /// The marker the encoder still has to write, or 0.
    owed: u8,
    done: bool,

    pub fn init(self: *Copy, features: Features) void {
        _ = features;
        self.* = .{ .unflushed = false, .owed = 0, .done = false };
    }

    pub fn encode(self: *Copy, input: []const u8, output: []u8, mode: status.Flush) status.Progress {
        assert(!self.done);
        const len = @min(input.len, output.len);
        @memcpy(output[0..len], input[0..len]);
        if (len > 0) self.unflushed = true;
        if (len < input.len) return .{ .consumed = len, .written = len, .status = .needs_room };
        if (self.owed == 0) self.owed = switch (mode) {
            .none => return .{ .consumed = len, .written = len, .status = .needs_input },
            .flush => if (self.unflushed) flush_marker else return .{ .consumed = len, .written = len, .status = .needs_input },
            .finish => end_marker,
        };
        if (len == output.len) return .{ .consumed = len, .written = len, .status = .needs_room };
        output[len] = self.owed;
        self.unflushed = false;
        self.done = self.owed == end_marker;
        self.owed = 0;
        return .{ .consumed = len, .written = len + 1, .status = if (self.done) .done else .needs_input };
    }

    pub fn encoded_len_max(input_len: usize) usize {
        return input_len + 1;
    }
};

const CopyWriter = io_writer.IoWriter(Copy, 0);

test "an IoWriter encodes what the caller writes, flushes, and ends the stream" {
    var storage: [32]u8 = undefined;
    var destination_buffer: [4]u8 = undefined;
    var destination: io_parts.RoomDestination = undefined;
    destination.init(&storage, storage.len, &destination_buffer);
    var buffer: [3]u8 = undefined;
    var writer: CopyWriter = undefined;
    writer.init(&destination.interface, &buffer, .{});
    try writer.interface.writeAll("hello");
    try writer.interface.flush();
    // A second flush with nothing written since writes no marker.
    try writer.interface.flush();
    try testing.expectEqualStrings("hello|", destination.written());
    try writer.interface.writeAll("world");
    try writer.finish();
    try testing.expectEqualStrings("hello|world.", destination.written());
}

test "an IoWriter keeps its state across each WriteFailed of its destination" {
    for (1..4) |room_len| {
        for ([_]usize{ 0, 1, 5 }) |buffer_len| {
            var storage: [32]u8 = undefined;
            var destination_buffer: [2]u8 = undefined;
            var destination: io_parts.RoomDestination = undefined;
            destination.init(&storage, 0, &destination_buffer);
            var buffer: [5]u8 = undefined;
            var writer: CopyWriter = undefined;
            writer.init(&destination.interface, buffer[0..buffer_len], .{});
            try io_parts.write_in_parts(&writer, &destination, "hello", room_len);
            try io_parts.end_in_parts(&writer, &destination, false, room_len);
            try io_parts.write_in_parts(&writer, &destination, "world", room_len);
            try io_parts.end_in_parts(&writer, &destination, true, room_len);
            try testing.expectEqualStrings("hello|world.", destination.written());
        }
    }
}

test "an IoWriter encodes a repeated slice" {
    var storage: [16]u8 = undefined;
    var destination_buffer: [16]u8 = undefined;
    var destination: io_parts.RoomDestination = undefined;
    destination.init(&storage, storage.len, &destination_buffer);
    var writer: CopyWriter = undefined;
    writer.init(&destination.interface, &.{}, .{});
    try writer.interface.splatByteAll('x', 4);
    // `writeSplatAll` writes into the array it takes, so it gets one it may write.
    var data = [_][]const u8{ "", "ab" };
    try writer.interface.writeSplatAll(&data, 2);
    try writer.finish();
    try testing.expectEqualStrings("xxxxabab.", destination.written());
}

test "an IoWriter's drain takes the first slice that is not empty, else the repeated one" {
    var storage: [16]u8 = undefined;
    var destination_buffer: [16]u8 = undefined;
    var destination: io_parts.RoomDestination = undefined;
    destination.init(&storage, storage.len, &destination_buffer);
    var writer: CopyWriter = undefined;
    writer.init(&destination.interface, &.{}, .{});
    const drain = writer.interface.vtable.drain;
    try testing.expectEqual(2, try drain(&writer.interface, &.{ "", "ab" }, 3));
    try testing.expectEqual(0, try drain(&writer.interface, &.{ "", "cd" }, 0));
    try testing.expectEqual(1, try drain(&writer.interface, &.{ "", "e", "fg" }, 1));
    try writer.finish();
    try testing.expectEqualStrings("abe.", destination.written());
}

test "an IoWriter encodes its buffered octets before the octets of a write that does not fit" {
    var storage: [16]u8 = undefined;
    var destination_buffer: [16]u8 = undefined;
    var destination: io_parts.RoomDestination = undefined;
    destination.init(&storage, storage.len, &destination_buffer);
    var buffer: [3]u8 = undefined;
    var writer: CopyWriter = undefined;
    writer.init(&destination.interface, &buffer, .{});
    try writer.interface.writeAll("ab");
    try writer.interface.writeAll("cdef");
    try writer.finish();
    try testing.expectEqualStrings("abcdef.", destination.written());
}
