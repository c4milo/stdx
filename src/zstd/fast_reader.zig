//! A backward stream of the Zstandard decoder's fast paths (decision 16), read from one 8-octet
//! load at a time as the checked backward reader reads it (RFC 8878 §4.1): the sequences' stream
//! where the loop leaves it.

const std = @import("std");
const codec = @import("codec");

/// The stream's first 8 octets as a little-endian word, zero past its end when it is shorter: the
/// load of any position in the stream's first 64 bits.
pub fn head_of(octets: []const u8) u64 {
    var padded: [@sizeOf(u64)]u8 = @splat(0);
    const len = @min(octets.len, padded.len);
    @memcpy(padded[0..len], octets[0..len]);
    return std.mem.readInt(u64, &padded, .little);
}

/// A backward stream read from one 8-octet load at a time: the load's bits below the position are
/// `bits_left`, taken from the top, and a read that needs more loads again at the position (RFC
/// 8878 §4.1). A load needs `constants.fast_read_position_min` bits before the position.
pub const Reader = struct {
    octets: []const u8,
    /// The stream's first 8 octets, zero past its end when it is shorter: the load of any position
    /// in the stream's first 64 bits.
    head: u64,
    word: u64,
    /// The load's first octet, and its bits not yet read.
    start: usize,
    bits_left: usize,
    /// Whether a read reached before the stream's first bit, as the checked reader marks it.
    overflowed: bool,

    pub fn init(octets: []const u8, head: u64, at: usize) Reader {
        var reader: Reader = .{ .octets = octets, .head = head, .word = 0, .start = 0, .bits_left = 0, .overflowed = false };
        reader.load(at);
        return reader;
    }

    inline fn load(self: *Reader, at: usize) void {
        const end = std.math.divCeil(usize, at, @bitSizeOf(u8)) catch unreachable;
        if (end >= @sizeOf(u64)) {
            self.start = end - @sizeOf(u64);
            self.word = std.mem.readInt(u64, self.octets[self.start..][0..@sizeOf(u64)], .little);
        } else {
            self.start = 0;
            self.word = self.head;
        }
        self.bits_left = at - self.start * @bitSizeOf(u8);
    }

    /// The stream's position: the bits before it are not read yet.
    pub fn position(self: *const Reader) usize {
        return self.start * @bitSizeOf(u8) + self.bits_left;
    }

    /// `count` bits, the first read most significant. Bits before the stream's first read as
    /// zeros and mark the reader overflowed, as the checked reader reads them (RFC 8878 §4.1).
    pub inline fn read(self: *Reader, count: u6) u64 {
        if (count > self.bits_left) self.load(self.position());
        const mask = (@as(u64, 1) << count) - 1;
        if (count > self.bits_left) {
            // Only a load from the stream's first octet holds fewer bits than a read takes.
            const value = (self.word & ((@as(u64, 1) << @intCast(self.bits_left)) - 1)) << @intCast(count - self.bits_left);
            self.bits_left = 0;
            self.overflowed = true;
            return value & mask;
        }
        self.bits_left -= count;
        return std.math.shr(u64, self.word, self.bits_left) & mask;
    }

    /// Whether every bit was read and no read reached before the first.
    pub fn finished(self: *const Reader) bool {
        return self.position() == 0 and !self.overflowed;
    }
};

test "the fast reader reads what the checked backward reader reads, across its loads" {
    var generator = codec.split.Generator.init(1);
    var stream: [64]u8 = undefined;
    for (&stream) |*octet| octet.* = @truncate(generator.next());
    stream[stream.len - 1] |= 0x80;
    var checked = codec.BackwardBitReader.init(&stream).?;
    var fast = Reader.init(&stream, head_of(&stream), checked.position);
    // Reads of up to 31 bits, so several reads outrun one load, down to the stream's first bit and
    // past it, where both read zeros and mark themselves overflowed.
    while (!checked.overflowed) {
        const count: u6 = @intCast(generator.below(32));
        try std.testing.expectEqual(checked.read(count), fast.read(count));
        try std.testing.expectEqual(checked.position, fast.position());
        try std.testing.expectEqual(checked.overflowed, fast.overflowed);
    }
    // A stream shorter than a load reads from its padded head.
    var short = codec.BackwardBitReader.init(stream[0..5]).?;
    var short_fast = Reader.init(stream[0..5], head_of(stream[0..5]), short.position);
    while (!short.overflowed) {
        const count: u6 = @intCast(generator.below(12));
        try std.testing.expectEqual(short.read(count), short_fast.read(count));
        try std.testing.expectEqual(short.overflowed, short_fast.overflowed);
    }
}
