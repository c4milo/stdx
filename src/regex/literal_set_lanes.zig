//! Claim R5's compares for a set of fewer than `teddy_count_min` literals (decision 86): each
//! literal's two octets against the text's, `width` octets a step, where Teddy's lookups would
//! cost more, and the places a block's compares find.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const lane_places = @import("lane_places.zig");
const LiteralSet = @import("literal_set.zig").LiteralSet;

/// The octets of a block, whatever the width of a step.
const block_len = constants.literal_steps * constants.skip_lanes;

/// The search's steps for a vector of `width` octets and a set of `count` literals.
pub fn Lanes(comptime width: usize, comptime count: usize) type {
    comptime assert(block_len % width == 0);
    return struct {
        pub const Vector = @Vector(width, u8);
        pub const Step = lane_places.Places(width);
        pub const steps = block_len / width;
        pub const step_width = width;

        /// Each literal's octets at `first_at` and `last_at`, in every lane.
        pub const Wanted = struct { firsts: [count]Vector, lasts: [count]Vector };

        /// All ones in each lane of the step at `at` where some literal's octet at `first_at`
        /// stands in `firsts` and its octet at `last_at` at the same place in `lasts`.
        pub inline fn both_lanes(firsts: *const [block_len]u8, lasts: *const [block_len]u8, comptime at: usize, wanted: *const Wanted) Vector {
            const all: Vector = @splat(constants.octet_max);
            const none: Vector = @splat(0);
            const first: Vector = firsts[at..][0..width].*;
            const last: Vector = lasts[at..][0..width].*;
            var both = none;
            inline for (0..count) |literal| {
                const first_here = @select(u8, first == wanted.firsts[literal], all, none);
                const last_here = @select(u8, last == wanted.lasts[literal], all, none);
                both |= first_here & last_here;
            }
            return both;
        }

        /// True when some place of a block holds some literal's octet at `first_at` in `firsts`
        /// and its octet at `last_at` at the same place in `lasts`.
        pub inline fn any_candidate(firsts: *const [block_len]u8, lasts: *const [block_len]u8, wanted: *const Wanted) bool {
            var any: Vector = @splat(0);
            inline for (0..steps) |step| any |= both_lanes(firsts, lasts, step * width, wanted);
            return Step.any(any);
        }
    };
}

/// The first place of the block from `index` where a literal of the set stands whole, among those
/// where some literal's two octets stand, by the compares of `Search`: one mask for the block,
/// with a bit a place, as `literal_find.zig` takes it, or a word for each step of SHRN's nibbles.
pub inline fn first_stands(comptime Search: type, set: *const LiteralSet, firsts: *const [block_len]u8, lasts: *const [block_len]u8, wanted: *const Search.Wanted, haystack: []const u8, index: usize) ?usize {
    if (comptime lane_places.narrows(Search.step_width)) return first_stands_by_step(Search, set, firsts, lasts, wanted, haystack, index);
    const BlockMask = std.meta.Int(.unsigned, block_len);
    var mask: BlockMask = 0;
    inline for (0..Search.steps) |step| mask |= @as(BlockMask, Search.Step.of(Search.both_lanes(firsts, lasts, step * Search.step_width, wanted))) << step * Search.step_width;
    // Each set bit is one place to compare, at most `block_len` of them.
    while (mask != 0) : (mask &= mask - 1) {
        const candidate = index + @ctz(mask);
        if (set.stands_at(haystack, candidate)) return candidate;
    }
    return null;
}

/// `first_stands` where SHRN gives the places, a word for each step.
inline fn first_stands_by_step(comptime Search: type, set: *const LiteralSet, firsts: *const [block_len]u8, lasts: *const [block_len]u8, wanted: *const Search.Wanted, haystack: []const u8, index: usize) ?usize {
    var masks: [Search.steps]Search.Step.Mask = undefined;
    inline for (&masks, 0..) |*mask, step| mask.* = Search.Step.of(Search.both_lanes(firsts, lasts, step * Search.step_width, wanted));
    for (masks, 0..) |step_mask, step| {
        var mask = step_mask;
        // Each set bit is one place to compare, at most `width` of them.
        while (mask != 0) : (mask &= mask - 1) {
            const candidate = index + step * Search.step_width + Search.Step.first(mask);
            if (set.stands_at(haystack, candidate)) return candidate;
        }
    }
    return null;
}
