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

        /// Appends `octets` at once, as `push` would one by one. Only the last `capacity` stay.
        pub fn append(self: *Self, octets: []const u8) void {
            assert(self.position < capacity);
            const kept = octets[octets.len -| capacity..];
            // The octets not kept would have wrapped past where the kept ones start.
            const start = (self.position + octets.len - kept.len) & (capacity - 1);
            // From there to the ring's end, then from its start.
            const first_len = @min(kept.len, capacity - start);
            @memcpy(self.octets[start..][0..first_len], kept[0..first_len]);
            @memcpy(self.octets[0 .. kept.len - first_len], kept[first_len..]);
            self.position = (start + kept.len) & (capacity - 1);
            self.filled_len = @min(self.filled_len + octets.len, capacity);
        }

        /// Copies into `into` the octets from `distance` back, in order, as `back` would read them
        /// one by one. The caller has refused every distance past `reach()` (invariant 10), and
        /// `into` is no longer than `distance`, so every octet it reads was written before the copy.
        pub fn copy_back(self: *const Self, distance: usize, into: []u8) void {
            assert(distance >= 1 and distance <= self.filled_len);
            assert(into.len <= distance);
            const start = (self.position + capacity - distance) & (capacity - 1);
            const first_len = @min(into.len, capacity - start);
            @memcpy(into[0..first_len], self.octets[start..][0..first_len]);
            @memcpy(into[first_len..], self.octets[0 .. into.len - first_len]);
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

test "append and copy_back agree with push and back, across the ring's end" {
    var pushed: Window(8) = undefined;
    var appended: Window(8) = undefined;
    pushed.init();
    appended.init();
    var next: u8 = 0;
    for ([_]usize{ 3, 0, 4, 1, 7, 8, 13, 2 }) |len| {
        var octets: [16]u8 = undefined;
        for (octets[0..len]) |*octet| {
            octet.* = next;
            pushed.push(next);
            next +%= 1;
        }
        appended.append(octets[0..len]);
        try testing.expectEqual(pushed.reach(), appended.reach());
        try testing.expectEqual(pushed.position, appended.position);
        for (1..pushed.reach() + 1) |distance| {
            try testing.expectEqual(pushed.back(distance), appended.back(distance));
            var copied: [8]u8 = undefined;
            appended.copy_back(distance, copied[0..distance]);
            for (copied[0..distance], 0..) |octet, index| {
                try testing.expectEqual(pushed.back(distance - index), octet);
            }
        }
    }
}
