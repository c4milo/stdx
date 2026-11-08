//! The state of level 5's weighing of a bucket's hits in assembly (decision 66, part 5), which
//! `encoder_hits_aarch64.zig` and `encoder_hits_x86_64.zig` load and store, in this order.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");

pub const State = extern struct {
    window: [*]const u8,
    here: u64,
    cost: u64,
    position: u64,
    low: u64,
    reach: u64,
    base: u64,
    entries: [*]const u32,
    hits: u64,
    saves: i64,
    candidate: u64,
    long: [*]u64,
    long_count: u64,
};

/// The cost of a match with no distance bits less the most a distance's log2 adds, so that
/// `cost - 8 * clz(offset)` is `encoder_match_cost_base + 8 * log2(offset)`.
pub const cost_bias = constants.encoder_match_cost_base + (@bitSizeOf(u64) - 1) * encoder_commands.eighths;

/// The octets a candidate must agree on, and those one read compares.
pub const min_len = constants.encoder_level5.hash_len;
pub const read_len = @sizeOf(u64);

comptime {
    // aarch64's `sub` takes the bias as a 12-bit immediate.
    assert(cost_bias < 1 << 12);
    assert(encoder_commands.eighths == 1 << 3);
    assert(@offsetOf(State, "here") == 8 and @offsetOf(State, "long_count") == 12 * 8);
}
