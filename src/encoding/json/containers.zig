//! The kind of each open container of a text, an object or an array (RFC 8259 §4 and §5), one bit
//! for each depth up to `constants.depth_max`, for the decoder and the encoder. It reads and writes
//! its bits through a pointer: `std.StaticBitSet`'s `isSet` takes the set by value, and the token
//! loops copied all 128 octets of it to the stack at each read (design §8 step 18).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// The word the bits are kept in, and its bits.
const Mask = u64;
const mask_bits = @bitSizeOf(Mask);

comptime {
    assert(constants.depth_max % mask_bits == 0);
}

pub const Containers = struct {
    /// Bit `d` holds when the container at depth `d + 1` is an object, and is clear for an array.
    masks: [constants.depth_max / mask_bits]Mask,

    /// No container open.
    pub const empty: Containers = .{ .masks = @splat(0) };

    /// True when the container at depth `index + 1` is an object.
    pub inline fn is_object(self: *const Containers, index: usize) bool {
        assert(index < constants.depth_max);
        return self.masks[index / mask_bits] & bit_of(index) != 0;
    }

    /// Records the container at depth `index + 1` as an object, or as an array.
    pub inline fn set(self: *Containers, index: usize, object: bool) void {
        assert(index < constants.depth_max);
        const mask = &self.masks[index / mask_bits];
        mask.* = if (object) mask.* | bit_of(index) else mask.* & ~bit_of(index);
    }

    /// True when both hold the same bits.
    pub fn eql(self: *const Containers, other: *const Containers) bool {
        return std.mem.eql(Mask, &self.masks, &other.masks);
    }
};

inline fn bit_of(index: usize) Mask {
    return @as(Mask, 1) << @intCast(index % mask_bits);
}

const testing = std.testing;

test "each depth's bit holds what was set there last, and no other depth's" {
    var containers: Containers = .empty;
    const depths = [_]usize{ 0, 1, mask_bits - 1, mask_bits, constants.depth_max - 1 };
    for (depths) |index| {
        containers.set(index, true);
        try testing.expect(containers.is_object(index));
    }
    for (0..constants.depth_max) |index| {
        try testing.expectEqual(std.mem.indexOfScalar(usize, &depths, index) != null, containers.is_object(index));
    }
    containers.set(mask_bits, false);
    try testing.expect(!containers.is_object(mask_bits) and containers.is_object(mask_bits - 1));
    var other: Containers = .empty;
    try testing.expect(!containers.eql(&other));
    for (depths) |index| other.set(index, index != mask_bits);
    try testing.expect(containers.eql(&other));
}
