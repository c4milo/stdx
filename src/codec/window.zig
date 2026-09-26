//! The history a decoder's back-references reach: the last `capacity` octets a stream wrote, in a
//! ring (decision 11; invariant 10).
//!
//! `init` writes no octet of the ring. It sets the count of octets written since `init` to zero,
//! and a read reaches only octets that count covers. A decoder refuses a distance past `reach()`
//! with an error its RFC cites before it calls `back`, and `back` asserts the same bound, so a
//! decoder that forgot the refusal stops instead of copying the previous stream's octets, which a
//! pooled decoder's ring still holds and which may belong to another peer.

const std = @import("std");
const assert = std.debug.assert;

pub fn Window(comptime capacity: usize) type {
    comptime assert(std.math.isPowerOfTwo(capacity));
    return struct {
        const Self = @This();

        /// The ring. Only the octets `reach()` covers were written by this stream.
        octets: [capacity]u8,
        /// Where the next octet goes.
        position: usize,
        /// The octets written since `init`, up to `capacity`.
        filled_len: usize,

        pub fn init(self: *Self) void {
            self.position = 0;
            self.filled_len = 0;
        }

        /// The farthest distance a back-reference may take: the octets written since `init`, up
        /// to `capacity`.
        pub fn reach(self: *const Self) usize {
            assert(self.filled_len <= capacity);
            return self.filled_len;
        }

        /// Appends one octet.
        pub fn push(self: *Self, octet: u8) void {
            assert(self.position < capacity);
            self.octets[self.position] = octet;
            self.position = (self.position + 1) & (capacity - 1);
            self.filled_len = @min(self.filled_len + 1, capacity);
        }

        /// The octet `distance` back from the next one. The caller has refused every distance past
        /// `reach()` (invariant 10).
        pub fn back(self: *const Self, distance: usize) u8 {
            assert(distance >= 1);
            assert(distance <= self.filled_len);
            return self.octets[(self.position + capacity - distance) & (capacity - 1)];
        }
    };
}

// Tests.

const testing = std.testing;

test "back reads what push wrote, across the ring's end" {
    var window: Window(8) = undefined;
    window.init();
    try testing.expectEqual(0, window.reach());
    for (0..11) |index| window.push(@intCast(index));
    try testing.expectEqual(8, window.reach());
    try testing.expectEqual(10, window.back(1));
    try testing.expectEqual(3, window.back(8));
}

test "init leaves the ring's octets and reaches none of them" {
    var window: Window(8) = undefined;
    @memset(&window.octets, 0x5a);
    window.init();
    try testing.expectEqual(0, window.reach());
    window.push(1);
    try testing.expectEqual(1, window.reach());
    try testing.expectEqual(1, window.back(1));
    // The ring still holds the old octets, which no read may reach.
    try testing.expectEqual(0x5a, window.octets[5]);
}
