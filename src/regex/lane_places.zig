//! The places of a step of claims R2's and R5's searches whose lanes a compare set, as the bits
//! of a word (decision 86).
//!
//! x86-64 takes one bit from each lane of a vector with PMOVMSKB. NEON has no such instruction:
//! LLVM writes a lane's bit with an AND, a byte permute and an add across the lanes, five
//! instructions for a step of 16 lanes. SHRN narrows each lane of 16 bits to 8 bits by a shift of
//! four. Under it, each lane of 8 bits gives a nibble of the word that comes out, in one
//! instruction (Kutenin, "Porting x86 vector bitmask optimizations to Arm NEON", Arm Community,
//! 2022). A place then takes `bits_per_lane` bits of the mask, and its top bit stands for it.
const std = @import("std");
const builtin = @import("builtin");
const constants = @import("constants.zig");

/// True where a step of `width` lanes gives its places by SHRN: NEON's 16 lanes on aarch64.
pub fn narrows(comptime width: usize) bool {
    return builtin.cpu.arch == .aarch64 and width == constants.skip_lanes;
}

/// The places of a step of `width` lanes.
pub fn Places(comptime width: usize) type {
    return struct {
        const Lanes = @Vector(width, u8);

        /// The bits of the mask that stand for one place.
        pub const bits_per_lane = if (narrows(width)) constants.nibble_bits else 1;
        pub const Mask = std.meta.Int(.unsigned, width * bits_per_lane);

        /// The top bit of each nibble of a word, where SHRN gives the places.
        const top_bits: Mask = if (narrows(width)) (std.math.maxInt(u64) / constants.nibble_mask) << (constants.nibble_bits - 1) else 0;

        /// A bit for each place of `lanes` that holds all ones, where each lane holds all ones or
        /// zero, as a compare writes it. Under SHRN, the bit is the top bit of the place's nibble.
        pub inline fn of(lanes: Lanes) Mask {
            if (comptime narrows(width)) return narrow(lanes) & top_bits;
            return @bitCast(lanes != @as(Lanes, @splat(0)));
        }

        /// True when some lane of `lanes` is not zero, where each lane holds all ones or zero.
        pub inline fn any(lanes: Lanes) bool {
            if (comptime narrows(width)) return narrow(lanes) != 0;
            return @reduce(.Or, lanes) != 0;
        }

        /// The place of the lowest bit of a mask that is not zero.
        pub inline fn first(mask: Mask) usize {
            std.debug.assert(mask != 0);
            return @ctz(mask) / bits_per_lane;
        }

        /// Each lane of 16 bits shifted right by four and cut to its low 8 bits: SHRN. The lane
        /// at an even place gives its high nibble to the low nibble of an octet, and the lane
        /// after it its low nibble to the high nibble.
        inline fn narrow(lanes: Lanes) u64 {
            const pairs_len = width / @sizeOf(u16);
            const pairs: @Vector(pairs_len, u16) = @bitCast(lanes);
            const shift: @Vector(pairs_len, u4) = @splat(constants.nibble_bits);
            const octets: @Vector(pairs_len, u8) = @truncate(pairs >> shift);
            return @bitCast(octets);
        }
    };
}

const testing = std.testing;

fn expect_places(comptime width: usize) !void {
    const Step = Places(width);
    const all: @Vector(width, u8) = @splat(constants.octet_max);
    const none: @Vector(width, u8) = @splat(0);
    try testing.expect(!Step.any(none));
    try testing.expectEqual(@as(Step.Mask, 0), Step.of(none));
    // One place at a time, at each place: the mask holds that place alone.
    for (0..width) |place| {
        var lanes: [width]u8 = none;
        lanes[place] = constants.octet_max;
        try testing.expect(Step.any(lanes));
        const mask = Step.of(lanes);
        try testing.expectEqual(place, Step.first(mask));
        try testing.expectEqual(@as(Step.Mask, 0), mask & (mask - 1));
    }
    // Every place: one bit each.
    try testing.expectEqual(@as(u16, width), @popCount(Step.of(all)));
}

test "of gives one bit for each place a compare set, and any tells whether one is set" {
    try expect_places(constants.skip_lanes);
    try expect_places(constants.avx2_lanes);
}

test "the places of two set lanes come lowest first" {
    const Step = Places(constants.skip_lanes);
    var lanes: [constants.skip_lanes]u8 = @splat(0);
    lanes[3] = constants.octet_max;
    lanes[12] = constants.octet_max;
    var mask = Step.of(lanes);
    try testing.expectEqual(@as(usize, 3), Step.first(mask));
    mask &= mask - 1;
    try testing.expectEqual(@as(usize, 12), Step.first(mask));
    mask &= mask - 1;
    try testing.expectEqual(@as(Step.Mask, 0), mask);
}
