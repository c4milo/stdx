//! Level 5's weighing of a bucket's hits in aarch64 assembly (decision 64, part 5, which amends
//! decision 16 for this loop): each hit's candidate weighed by the octets it agrees on within the
//! first 8, and kept by a select, as `Pick.weigh` does in Zig. It writes the pick and the list of
//! long candidates the Zig loop writes.
//!
//! It takes an aarch64 target built by LLVM; every other target runs the Zig loop. Two branches
//! stay, each on a case most rows seldom meet: a candidate out of reach, and a collision, a
//! candidate that agrees on fewer than 4 octets.
//!
//! Its reads go by address, without Zig's bounds checks. A hit's way is below 16, inside the
//! bucket; a candidate in reach lies below the position, whose 8 octets lie before the block's end
//! (`best`'s assertion), so each read of 8 octets stays in the window.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");

/// Whether the assembly weighs the hits: an aarch64 target built by LLVM.
pub const takes = builtin.cpu.arch == .aarch64 and builtin.zig_backend == .stage2_llvm;

/// The loop's state, in the order the text loads and stores it.
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
const cost_bias = constants.encoder_match_cost_base + (@bitSizeOf(u64) - 1) * encoder_commands.eighths;

comptime {
    // `sub` takes the bias as a 12-bit immediate.
    assert(cost_bias < 1 << 12);
    assert(encoder_commands.eighths == 1 << 3);
    assert(@offsetOf(State, "here") == 8 and @offsetOf(State, "long_count") == 12 * 8);
}

/// Weighs the hits `state` names and stores the pick back.
pub inline fn weigh(state: *State) void {
    asm volatile (text
        :
        : [state] "{x0}" (state),
        : .{ .memory = true, .nzcv = true, .x1 = true, .x2 = true, .x3 = true, .x4 = true, .x5 = true, .x6 = true, .x7 = true, .x8 = true, .x9 = true, .x10 = true, .x11 = true, .x12 = true, .x13 = true, .x15 = true, .x16 = true, .x17 = true });
}

/// x1 the window, x2 the position's 8 octets, x3 a literal's cost, x4 the position, x5 the lowest
/// position in reach, x6 the reach, x7 the stream's base, x8 the bucket's entries, x9 the hits,
/// x10 the best saving, x11 its candidate, x12 the long list, x13 its count.
const text = std.fmt.comptimePrint(
    \\ ldp x1, x2, [x0]
    \\ ldp x3, x4, [x0, #16]
    \\ ldp x5, x6, [x0, #32]
    \\ ldp x7, x8, [x0, #48]
    \\ ldp x9, x10, [x0, #64]
    \\ ldp x11, x12, [x0, #80]
    \\ ldr x13, [x0, #96]
    \\ cbz w9, 2f
    \\1:
    // The lowest hit's way, and the hit cleared.
    \\ rbit w15, w9
    \\ clz w15, w15
    \\ sub w16, w9, #1
    \\ and w9, w9, w16
    // The entry's position: an entry of an earlier stream wraps past the reach.
    \\ ldr w15, [x8, w15, uxtw #2]
    \\ sub w15, w15, w7
    \\ sub w16, w15, w5
    \\ cmp w16, w6
    \\ b.hs 3f
    // The octets that agree within the first 8.
    \\ ldr x16, [x1, x15]
    \\ eor x16, x16, x2
    \\ rbit x16, x16
    \\ clz x16, x16
    \\ lsr x16, x16, #3
    \\ cmp x16, #{[min_len]d}
    \\ b.lo 3f
    // A candidate that agrees on all 8 goes on the long list.
    \\ str x15, [x12, x13, lsl #3]
    \\ cmp x16, #{[read_len]d}
    \\ cinc x13, x13, eq
    // The saving: agreed octets at a literal's cost, less the match's cost and its offset's log2.
    \\ sub x17, x4, x15
    \\ clz x17, x17
    \\ mul x16, x16, x3
    \\ add x16, x16, x17, lsl #3
    \\ sub x16, x16, #{[cost_bias]d}
    // The best saving wins, and the first of equal savings stays.
    \\ cmp x16, x10
    \\ csel x10, x16, x10, gt
    \\ csel x11, x15, x11, gt
    \\3:
    \\ cbnz w9, 1b
    \\2:
    \\ stp x10, x11, [x0, #72]
    \\ str x13, [x0, #96]
, .{ .min_len = constants.encoder_level5.hash_len, .read_len = @sizeOf(u64), .cost_bias = cost_bias });
