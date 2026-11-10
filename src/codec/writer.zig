//! The checked octet writer every codec writes through (CLAUDE.md, Conventions; decision 16).
//!
//! It fills a slice the caller owns, from the front, and never past its end: a whole write checks
//! the room left first and returns `error.NoSpaceLeft` when too little is, and a partial write
//! writes what fits and says how much. A streaming codec keeps what it could not write in its own
//! state and returns `needs_room`, so any room, down to one octet, makes progress (decision 11).
//!
//! A short copy can make no call (decision 70): `write_all_short` and `write_partial_short` copy
//! up to 16 octets inline, and `write_first` moves a token's octets from a longer window in one
//! move.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

pub const Writer = struct {
    octets: []u8,
    /// The number of octets written so far, from the front.
    position: usize = 0,

    pub fn init(octets: []u8) Writer {
        return .{ .octets = octets };
    }

    /// The room left.
    pub fn room_len(self: *const Writer) usize {
        assert(self.position <= self.octets.len);
        return self.octets.len - self.position;
    }

    /// The octets written so far: what a streaming call reports as written.
    pub fn written(self: *const Writer) []const u8 {
        assert(self.position <= self.octets.len);
        return self.octets[0..self.position];
    }

    /// Writes one octet, or returns `error.NoSpaceLeft` when the output is full.
    pub fn write_octet(self: *Writer, octet: u8) error{NoSpaceLeft}!void {
        if (self.room_len() == 0) return error.NoSpaceLeft;
        self.octets[self.position] = octet;
        self.position += 1;
    }

    /// Writes all of `octets`, or returns `error.NoSpaceLeft` and writes nothing.
    pub fn write_all(self: *Writer, octets: []const u8) error{NoSpaceLeft}!void {
        if (octets.len > self.room_len()) return error.NoSpaceLeft;
        @memcpy(self.octets[self.position..][0..octets.len], octets);
        self.position += octets.len;
        assert(self.position <= self.octets.len);
    }

    /// Writes the first `len` octets of `window`, or returns `error.NoSpaceLeft` and writes nothing.
    /// Where `window` and the room both hold `constants.write_first_move_len` octets and `len` is
    /// no more, it moves that many in one load and one store, with no call: the octets past `len`
    /// land in room the writer does not count as written, and the next write goes over them
    /// (decision 11). A longer copy takes `@memcpy`, a call.
    pub inline fn write_first(self: *Writer, window: []const u8, len: usize) error{NoSpaceLeft}!void {
        assert(len <= window.len);
        const room = self.room_len();
        if (len > room) return error.NoSpaceLeft;
        const move_len = constants.write_first_move_len;
        if (len <= move_len and window.len >= move_len and room >= move_len) {
            self.octets[self.position..][0..move_len].* = window[0..move_len].*;
        } else {
            @memcpy(self.octets[self.position..][0..len], window[0..len]);
        }
        self.position += len;
        assert(self.position <= self.octets.len);
    }

    /// Writes as much of `octets` as fits and returns how many it wrote.
    pub fn write_partial(self: *Writer, octets: []const u8) usize {
        const len = @min(octets.len, self.room_len());
        @memcpy(self.octets[self.position..][0..len], octets[0..len]);
        self.position += len;
        return len;
    }

    /// `write_all`, for octets that are most often short: up to `constants.write_first_move_len`
    /// they copy inline, with no call (decision 70). A codec whose writes are long or few keeps
    /// `write_all`: inline, the copy made the Zstandard encoder's small frames slower on x86-64.
    pub fn write_all_short(self: *Writer, octets: []const u8) error{NoSpaceLeft}!void {
        if (octets.len > self.room_len()) return error.NoSpaceLeft;
        copy(self.octets[self.position..][0..octets.len], octets);
        self.position += octets.len;
        assert(self.position <= self.octets.len);
    }

    /// `write_partial`, for octets that are most often short, as `write_all_short` is.
    pub fn write_partial_short(self: *Writer, octets: []const u8) usize {
        const len = @min(octets.len, self.room_len());
        copy(self.octets[self.position..][0..len], octets[0..len]);
        self.position += len;
        return len;
    }

    /// Writes an integer in the given byte order, or returns `error.NoSpaceLeft` and writes
    /// nothing.
    pub fn write_int(self: *Writer, comptime T: type, value: T, endian: std.builtin.Endian) error{NoSpaceLeft}!void {
        comptime assert(@typeInfo(T).int.bits % @bitSizeOf(u8) == 0);
        var octets: [@sizeOf(T)]u8 = undefined;
        std.mem.writeInt(T, &octets, value, endian);
        try self.write_all(&octets);
    }
};

/// Copies `source` into `destination`, of the same length, with no call up to
/// `constants.write_first_move_len` octets: two moves of 8 or 4 octets that overlap and stay inside
/// both, and below 4 octets the first, the last and the middle one, which cover them all. A
/// longer copy takes `@memcpy`, a call.
inline fn copy(destination: []u8, source: []const u8) void {
    const len = source.len;
    assert(destination.len == len);
    if (len > constants.write_first_move_len) return @memcpy(destination, source);
    inline for (.{ @sizeOf(u64), @sizeOf(u32) }) |move_len| {
        if (len >= move_len) {
            destination[0..move_len].* = source[0..move_len].*;
            destination[len - move_len ..][0..move_len].* = source[len - move_len ..][0..move_len].*;
            return;
        }
    }
    if (len == 0) return;
    destination[0] = source[0];
    destination[len - 1] = source[len - 1];
    destination[len >> 1] = source[len >> 1];
}

// Tests. Every refusal of the writer has one.

const testing = std.testing;

test "write_octet fills the output and refuses past its end" {
    var buffer: [2]u8 = undefined;
    var writer = Writer.init(&buffer);
    try writer.write_octet('a');
    try writer.write_octet('b');
    try testing.expectError(error.NoSpaceLeft, writer.write_octet('c'));
    try testing.expectEqualStrings("ab", writer.written());
}

test "write_all refuses what does not fit and writes nothing of it" {
    var buffer: [5]u8 = undefined;
    var writer = Writer.init(&buffer);
    try writer.write_all("oct");
    try testing.expectError(error.NoSpaceLeft, writer.write_all("ets"));
    try testing.expectEqual(2, writer.room_len());
    try testing.expectEqualStrings("oct", writer.written());
}

test "write_partial writes what fits, down to nothing" {
    var buffer: [4]u8 = undefined;
    var writer = Writer.init(&buffer);
    try testing.expectEqual(4, writer.write_partial("octets"));
    try testing.expectEqual(0, writer.write_partial("more"));
    try testing.expectEqualStrings("octe", writer.written());
}

test "write_int writes each byte order, and a short write writes nothing" {
    var buffer: [5]u8 = undefined;
    var writer = Writer.init(&buffer);
    try writer.write_int(u16, 0x1234, .big);
    try writer.write_int(u16, 0x1234, .little);
    try testing.expectError(error.NoSpaceLeft, writer.write_int(u16, 0x5678, .little));
    try testing.expectEqualSlices(u8, &.{ 0x12, 0x34, 0x34, 0x12 }, writer.written());
}

test "write_all_short refuses what does not fit and writes nothing of it" {
    var buffer: [5]u8 = undefined;
    var writer = Writer.init(&buffer);
    try writer.write_all_short("oct");
    try testing.expectError(error.NoSpaceLeft, writer.write_all_short("ets"));
    try testing.expectEqual(2, writer.room_len());
    try testing.expectEqualStrings("oct", writer.written());
}

test "write_partial_short writes what fits, down to nothing" {
    var buffer: [4]u8 = undefined;
    var writer = Writer.init(&buffer);
    try testing.expectEqual(4, writer.write_partial_short("octets"));
    try testing.expectEqual(0, writer.write_partial_short("more"));
    try testing.expectEqualStrings("octe", writer.written());
}

/// The longest copy the test of `copy` makes: past the short copies, into `@memcpy`'s.
const copy_test_len_max = constants.write_first_move_len + @sizeOf(u64);

/// The octets the test of `copy` keeps on each side of the destination, and the octet they hold,
/// which no source octet equals.
const copy_test_guard_len = @sizeOf(u64);
const copy_test_guard_octet: u8 = 0xff;

test "copy writes every length, short and long, at every alignment, and nothing around it" {
    var source: [copy_test_len_max]u8 = undefined;
    // Each octet differs from the others and from the guard, so a move from the wrong place shows.
    for (&source, 0..) |*octet, index| octet.* = @intCast(index + 1);
    for (0..copy_test_guard_len) |alignment| {
        for (0..copy_test_len_max + 1) |len| {
            var buffer: [copy_test_len_max + copy_test_guard_len + copy_test_guard_len]u8 = @splat(copy_test_guard_octet);
            const start = copy_test_guard_len + alignment;
            copy(buffer[start..][0..len], source[0..len]);
            try testing.expectEqualSlices(u8, source[0..len], buffer[start..][0..len]);
            for (buffer[0..start]) |octet| try testing.expectEqual(copy_test_guard_octet, octet);
            for (buffer[start + len ..]) |octet| try testing.expectEqual(copy_test_guard_octet, octet);
        }
    }
}

/// The window the tests of `write_first` copy from: longer than one move, each octet its own.
const first_test_window = "abcdefghijklmnopqrstuvwxyz0123456789";

/// `first_test_window` as a slice whose length the compiler does not know, as a codec's input is:
/// with a known length, a read past it fails to compile rather than fail the test.
fn first_test_source() []const u8 {
    var source: []const u8 = first_test_window;
    _ = &source;
    return source;
}

test "write_first writes a window's first octets, moving past them only into room it does not count" {
    const source = first_test_source();
    var buffer: [first_test_window.len]u8 = @splat(0);
    var writer = Writer.init(&buffer);
    try writer.write_first(source, 3);
    try writer.write_first(source[10..], 2);
    try testing.expectEqualStrings("abckl", writer.written());
    // A token as long as one move, and one longer, which takes `@memcpy`.
    try writer.write_first(source, constants.write_first_move_len);
    try testing.expectEqualStrings(source[0..constants.write_first_move_len], writer.written()[5..]);
    var long: [first_test_window.len]u8 = undefined;
    var long_writer = Writer.init(&long);
    try long_writer.write_first(source, source.len);
    try testing.expectEqualStrings(first_test_window, long_writer.written());
}

test "write_first refuses what does not fit, and copies alone where the window or the room is short" {
    const source = first_test_source();
    var buffer: [constants.write_first_move_len]u8 = @splat(0);
    var writer = Writer.init(&buffer);
    // The first write has a whole move's room, and leaves the window's next octets past its own.
    try writer.write_first(source, 4);
    try testing.expectEqualStrings(source[0..constants.write_first_move_len], &buffer);
    // The room left is shorter than a move: the copy writes the token's octets alone, and leaves
    // the first move's octets past them.
    try writer.write_first(source[20..], 3);
    try testing.expectEqualStrings("abcduvw", writer.written());
    try testing.expectEqual(first_test_window[writer.position], buffer[writer.position]);
    try testing.expectError(error.NoSpaceLeft, writer.write_first(source, writer.room_len() + 1));
    try testing.expectEqualStrings("abcduvw", writer.written());
    // A window shorter than a move, and one a move long at the source's end: the copy reads the
    // window's octets alone.
    var short: [first_test_window.len]u8 = @splat(0);
    var short_writer = Writer.init(&short);
    try short_writer.write_first(source[0..5], 5);
    try testing.expectEqualStrings("abcde", short_writer.written());
    try testing.expectEqual(@as(u8, 0), short[5]);
    try short_writer.write_first(source[source.len - constants.write_first_move_len ..], 2);
    try testing.expectEqualStrings("abcdeuv", short_writer.written());
}
