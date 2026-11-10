//! Level 5's weighing of a bucket's hits in aarch64 assembly (decision 66, part 5, which amends
//! decision 16 for this loop): each hit's candidate weighed by the octets it agrees on within the
//! first 8, and kept by a select, as `Pick.weigh` does in Zig. It writes the pick and the list of
//! long candidates the Zig loop writes.
//!
//! It takes an aarch64 target built by LLVM; every other target runs the Zig loop. Two branches
//! stay, each on a case most rows seldom meet: a candidate out of reach, and a collision, a
//! candidate that agrees on fewer than 4 octets.
//!
//! The loop's values arrive and leave in registers, not through `State` in memory: the caller's
//! copy of the state then costs no store and no load for each search.
//!
//! Its reads go by address, without Zig's bounds checks. A hit's way is below 16, inside the
//! bucket; a candidate in reach lies below the position, whose 8 octets lie before the block's end
//! (`best`'s assertion), so each read of 8 octets stays in the window.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const assembly = @import("encoder_hits_assembly.zig");

/// Whether the assembly weighs the hits: an aarch64 target built by LLVM.
pub const takes = builtin.cpu.arch == .aarch64 and builtin.zig_backend == .stage2_llvm;

pub const State = assembly.State;

/// Weighs the hits `state` names and stores the pick back.
pub inline fn weigh(state: *State) void {
    // The text spends the hits, and moves the pick and the long list's count: each is a register
    // the text takes and gives back.
    var hits = state.hits;
    var saves = state.saves;
    var candidate = state.candidate;
    var long_count = state.long_count;
    asm volatile (text
        : [hits] "={x9}" (hits),
          [saves] "={x10}" (saves),
          [candidate] "={x11}" (candidate),
          [long_count] "={x13}" (long_count),
        : [window] "{x1}" (state.window),
          [here] "{x2}" (state.here),
          [cost] "{x3}" (state.cost),
          [position] "{x4}" (state.position),
          [low] "{x5}" (state.low),
          [reach] "{x6}" (state.reach),
          [base] "{x7}" (state.base),
          [entries] "{x8}" (state.entries),
          [hits_in] "{x9}" (hits),
          [saves_in] "{x10}" (saves),
          [candidate_in] "{x11}" (candidate),
          [long] "{x12}" (state.long),
          [long_count_in] "{x13}" (long_count),
        : .{ .memory = true, .nzcv = true, .x15 = true, .x16 = true, .x17 = true });
    state.saves = saves;
    state.candidate = candidate;
    state.long_count = long_count;
}

/// x1 the window, x2 the position's 8 octets, x3 a literal's cost, x4 the position, x5 the lowest
/// position in reach, x6 the reach, x7 the stream's base, x8 the bucket's entries, x9 the hits,
/// x10 the best saving, x11 its candidate, x12 the long list, x13 its count.
const text = std.fmt.comptimePrint(
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
, .{ .min_len = assembly.min_len, .read_len = assembly.read_len, .cost_bias = assembly.cost_bias });
