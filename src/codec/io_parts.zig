//! The source and the destination that the tests of every `IoReader` and `IoWriter` use (decision
//! 56). Each gives its octets or its room in parts, as a request body arrives and as a socket
//! drains. The source fails with `error.ReadFailed` until the test gives it more octets, and the
//! destination fails with `error.WriteFailed` until the test gives it more room.

const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const Generator = @import("split.zig").Generator;

const Reader = std.Io.Reader;
const Writer = std.Io.Writer;
const Limit = std.Io.Limit;

/// The helpers below bound their loops at this many calls for each octet of input and of room,
/// plus `calls_extra`. Each call takes an octet, writes one, or fails once before the test gives
/// more.
const calls_per_octet = 4;
const calls_extra = 4;

/// A `std.Io.Reader` over `octets`, of which the test gives a part at a time. It fails with
/// `error.EndOfStream` after it gave the last octet.
pub const PartSource = struct {
    interface: Reader,
    octets: []const u8,
    /// The octets of `octets` given so far.
    given_len: usize,
    /// The octets of `octets` read so far.
    read_len: usize,

    const vtable: Reader.VTable = .{ .stream = stream };

    pub fn init(self: *PartSource, octets: []const u8, given_len: usize, buffer: []u8) void {
        assert(given_len <= octets.len);
        self.interface = .{ .vtable = &vtable, .buffer = buffer, .seek = 0, .end = 0 };
        self.octets = octets;
        self.given_len = given_len;
        self.read_len = 0;
    }

    /// Gives `len` more octets, or every octet left.
    pub fn give(self: *PartSource, len: usize) void {
        self.given_len = @min(self.octets.len, self.given_len + len);
    }

    fn stream(interface: *Reader, destination: *Writer, limit: Limit) Reader.StreamError!usize {
        const self: *PartSource = @alignCast(@fieldParentPtr("interface", interface));
        if (self.read_len == self.octets.len) return error.EndOfStream;
        if (self.read_len == self.given_len) return error.ReadFailed;
        const len = try destination.write(limit.sliceConst(self.octets[self.read_len..self.given_len]));
        self.read_len += len;
        return len;
    }
};

/// A `std.Io.Writer` into `storage`, of which the test gives room a part at a time. It takes
/// octets through its buffer only, which is all that `IoWriter` writes through.
pub const RoomDestination = struct {
    interface: Writer,
    storage: []u8,
    /// The octets of `storage` the test allows so far.
    room_len: usize,
    /// The octets of `storage` written so far.
    written_len: usize,

    const vtable: Writer.VTable = .{ .drain = drain };

    pub fn init(self: *RoomDestination, storage: []u8, room_len: usize, buffer: []u8) void {
        assert(room_len <= storage.len);
        self.interface = .{ .vtable = &vtable, .buffer = buffer, .end = 0 };
        self.storage = storage;
        self.room_len = room_len;
        self.written_len = 0;
    }

    /// Gives `len` more octets of room, or all the room left.
    pub fn give(self: *RoomDestination, len: usize) void {
        self.room_len = @min(self.storage.len, self.room_len + len);
    }

    /// The octets written, the ones still in the buffer excluded.
    pub fn written(self: *const RoomDestination) []const u8 {
        return self.storage[0..self.written_len];
    }

    fn drain(interface: *Writer, data: []const []const u8, splat: usize) Writer.Error!usize {
        _ = data;
        _ = splat;
        const self: *RoomDestination = @alignCast(@fieldParentPtr("interface", interface));
        assert(interface.end > 0);
        const len = @min(interface.end, self.room_len - self.written_len);
        if (len == 0) return error.WriteFailed;
        @memcpy(self.storage[self.written_len..][0..len], interface.buffer[0..len]);
        self.written_len += len;
        @memmove(interface.buffer[0 .. interface.end - len], interface.buffer[len..interface.end]);
        interface.end -= len;
        return 0;
    }
};

test "a part source fails with ReadFailed until the test gives it octets, then ends" {
    var buffer: [4]u8 = undefined;
    var source: PartSource = undefined;
    source.init("abcdef", 2, &buffer);
    try std.testing.expectEqualStrings("ab", try source.interface.peekGreedy(1));
    source.interface.toss(2);
    try std.testing.expectError(error.ReadFailed, source.interface.peekGreedy(1));
    source.give(10);
    try std.testing.expectEqualStrings("cdef", try source.interface.take(4));
    try std.testing.expectError(error.EndOfStream, source.interface.peekGreedy(1));
}

test "a room destination fails with WriteFailed until the test gives it room" {
    var storage: [6]u8 = undefined;
    var buffer: [4]u8 = undefined;
    var destination: RoomDestination = undefined;
    destination.init(&storage, 2, &buffer);
    try destination.interface.writeAll("abcd");
    try std.testing.expectError(error.WriteFailed, destination.interface.flush());
    try std.testing.expectEqualStrings("ab", destination.written());
    destination.give(10);
    try destination.interface.flush();
    try std.testing.expectEqualStrings("abcd", destination.written());
}

/// Reads `reader` into `output` until it ends, at most `limit` octets a call. Gives `source`
/// `part_len` more octets after each `error.ReadFailed` that left `reader.failure` null, and
/// returns the octets read when one leaves it null with `part_len` zero. Returns the reader's
/// failure as an error.
pub fn read_in_parts(reader: anytype, source: *PartSource, part_len: usize, limit: Limit, output: []u8) ![]const u8 {
    var writer: Writer = .fixed(output);
    for (0..(source.octets.len + output.len) * calls_per_octet + calls_extra) |_| {
        _ = reader.interface.stream(&writer, limit) catch |err| switch (err) {
            error.EndOfStream => return writer.buffered(),
            error.ReadFailed => {
                if (reader.failure) |failure| return failure;
                if (part_len == 0) return writer.buffered();
                source.give(part_len);
                continue;
            },
            error.WriteFailed => unreachable,
        };
    }
    unreachable;
}

/// Writes `octets` to `writer`, giving `destination` `room_len` more octets of room after each
/// `error.WriteFailed`.
pub fn write_in_parts(writer: anytype, destination: *RoomDestination, octets: []const u8, room_len: usize) !void {
    var index: usize = 0;
    for (0..octets.len * calls_per_octet + calls_extra) |_| {
        if (index == octets.len) return;
        index += writer.interface.write(octets[index..]) catch {
            destination.give(room_len);
            continue;
        };
    }
    unreachable;
}

/// Calls `writer.interface.flush`, or `writer.finish` when `finish` is true, giving `destination`
/// `room_len` more octets of room after each `error.WriteFailed`.
pub fn end_in_parts(writer: anytype, destination: *RoomDestination, finish: bool, room_len: usize) !void {
    for (0..destination.storage.len * calls_per_octet + calls_extra) |_| {
        const result = if (finish) writer.finish() else writer.interface.flush();
        result catch {
            destination.give(room_len);
            continue;
        };
        return;
    }
    unreachable;
}

/// The sizes the round trip draws its parts at: the writer's and the destination's buffers, the
/// room the destination gains and the octets the source gains at each failure, and the most octets
/// the reader writes in one call.
const round_trip_writer_buffer_len = 61;
const round_trip_destination_buffer_len = 29;
const round_trip_room_part_len = 7;
const round_trip_source_buffer_len = 13;
const round_trip_source_part_len = 5;
const round_trip_read_len_max = 97;
/// The round trip writes its text in this many parts, with a flush after the first.
const round_trip_parts = 2;

/// Encodes `plain` through a `Writer` into `storage`, and decodes it back through a `Reader`, the
/// octets and the room given in parts. Halfway, the writer flushes, and the octets written so far
/// must decode to the first half (decision 11). Returns the stream.
pub fn expect_round_trip(comptime EncoderWriter: type, comptime DecoderReader: type, plain: []const u8, storage: []u8, output: []u8) ![]const u8 {
    var destination_buffer: [round_trip_destination_buffer_len]u8 = undefined;
    var destination: RoomDestination = undefined;
    destination.init(storage, 0, &destination_buffer);
    var writer_buffer: [round_trip_writer_buffer_len]u8 = undefined;
    var writer: EncoderWriter = undefined;
    writer.init(&destination.interface, &writer_buffer, .{});
    const half = plain.len / round_trip_parts;
    try write_in_parts(&writer, &destination, plain[0..half], round_trip_room_part_len);
    try end_in_parts(&writer, &destination, false, round_trip_room_part_len);

    var source_buffer: [round_trip_source_buffer_len]u8 = undefined;
    var source: PartSource = undefined;
    var reader: DecoderReader = undefined;
    // The source holds the whole storage, so it fails with `error.ReadFailed` after the flush's
    // octets, as a body that has more to come.
    source.init(storage, destination.written_len, &source_buffer);
    reader.init(&source.interface, &.{}, .{});
    try testing.expectEqualSlices(u8, plain[0..half], try read_in_parts(&reader, &source, 0, .unlimited, output));

    try write_in_parts(&writer, &destination, plain[half..], round_trip_room_part_len);
    try end_in_parts(&writer, &destination, true, round_trip_room_part_len);
    const coded = destination.written();
    source.init(coded, 0, &source_buffer);
    reader.init(&source.interface, &.{}, .{});
    try testing.expectEqualSlices(u8, plain, try read_in_parts(&reader, &source, round_trip_source_part_len, .limited(round_trip_read_len_max), output));
    return coded;
}

/// Requires a `DecoderReader` over all of `coded` to stop with `expected`.
pub fn expect_failure(comptime DecoderReader: type, coded: []const u8, expected: anyerror, output: []u8) !void {
    var source_buffer: [round_trip_source_buffer_len]u8 = undefined;
    var source: PartSource = undefined;
    source.init(coded, coded.len, &source_buffer);
    var reader: DecoderReader = undefined;
    reader.init(&source.interface, &.{}, .{});
    try testing.expectError(expected, read_in_parts(&reader, &source, 0, .unlimited, output));
}

/// The words `fill_text` draws from.
const words = [_][]const u8{ "the ", "stream ", "octet ", "window ", "of ", "a ", "coded ", "body, ", "and ", "match. " };

/// Fills `buffer` with words a seeded generator draws, which repeat as text does.
pub fn fill_text(buffer: []u8) []const u8 {
    var generator = Generator.init(buffer.len);
    var len: usize = 0;
    for (0..buffer.len) |_| {
        const word = words[@intCast(generator.below(words.len))];
        if (len + word.len > buffer.len) break;
        @memcpy(buffer[len..][0..word.len], word);
        len += word.len;
    }
    return buffer[0..len];
}
