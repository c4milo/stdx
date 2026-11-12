//! What level 5's searches of a bucket's hits in assembly share (decision 66, parts 5 and 6):
//! `encoder_hits_aarch64.zig` and `encoder_hits_x86_64.zig` reckon a saving and refuse a
//! candidate as `Pick.consider` does in Zig.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");

/// The cost of a match with no distance bits less the most a distance's log2 adds, so that
/// `cost - 8 * clz(offset)` is `encoder_match_cost_base + 8 * log2(offset)`. The loops keep each
/// saving plus this bias: agreed octets at a literal's cost, and 8 for each leading zero.
pub const cost_bias = constants.encoder_match_cost_base + (@bitSizeOf(u64) - 1) * encoder_commands.eighths;

/// The octets a candidate must agree on, and those one read compares.
pub const min_len = constants.encoder_level5.match_len_min;
pub const read_len = @sizeOf(u64);

comptime {
    // The loops multiply a leading zero by 8 with a shift of 3.
    assert(encoder_commands.eighths == 1 << 3);
    // The loops take a candidate whose low 4 octets differ as a collision.
    assert(min_len == @sizeOf(u32));
}
