//! A fixed-length field of a stream, read across calls: a container's header or trailer, which the
//! caller may split anywhere (decision 11). Each call reads what its input holds of the field
//! through the checked reader, and the octets wait in the state until the field is whole.

const std = @import("std");
const assert = std.debug.assert;
const Reader = @import("reader.zig").Reader;

pub fn Field(comptime capacity: usize) type {
    comptime assert(capacity > 0);
    comptime assert(capacity <= std.math.maxInt(u8));
    return struct {
        const Self = @This();

        /// The field's octets read so far, from the front.
        octets: [capacity]u8,
        held_len: u8,

        /// Starts a field. Writes no octet of it.
        pub fn init(self: *Self) void {
            self.held_len = 0;
        }

        /// Reads from `reader` until the field holds `field_len` octets, or the reader is empty.
        /// Returns whether the field is whole.
        pub fn fill(self: *Self, reader: *Reader, field_len: usize) bool {
            assert(field_len <= capacity);
            assert(self.held_len <= field_len);
            const taken = reader.take_partial(field_len - self.held_len);
            @memcpy(self.octets[self.held_len..][0..taken.len], taken);
            self.held_len += @intCast(taken.len);
            return self.held_len == field_len;
        }

        /// The octets read so far.
        pub fn held(self: *const Self) []const u8 {
            return self.octets[0..self.held_len];
        }
    };
}

// Tests.

const testing = std.testing;

test "a field split across readers is whole once its last octet arrives" {
    var field: Field(4) = undefined;
    field.init();
    var first = Reader.init(&.{ 1, 2 });
    try testing.expect(!field.fill(&first, 4));
    try testing.expectEqual(2, first.consumed());
    var empty = Reader.init(&.{});
    try testing.expect(!field.fill(&empty, 4));
    var second = Reader.init(&.{ 3, 4, 5 });
    try testing.expect(field.fill(&second, 4));
    // The octet after the field stays in the reader.
    try testing.expectEqual(2, second.consumed());
    try testing.expectEqualSlices(u8, &.{ 1, 2, 3, 4 }, field.held());
}

test "a whole field reads nothing more, and init starts the next" {
    var field: Field(2) = undefined;
    field.init();
    var reader = Reader.init(&.{ 7, 8, 9 });
    try testing.expect(field.fill(&reader, 2));
    try testing.expect(field.fill(&reader, 2));
    try testing.expectEqual(2, reader.consumed());
    field.init();
    try testing.expectEqual(0, field.held().len);
    try testing.expect(!field.fill(&reader, 2));
    try testing.expectEqualSlices(u8, &.{9}, field.held());
}
