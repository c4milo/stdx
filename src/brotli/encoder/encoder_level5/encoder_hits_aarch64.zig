//! Level 5's search of a bucket's hits in aarch64 assembly (decision 66, part 6, which amends
//! decision 16 for this loop): the hits newest first, each refused by one compare at the best
//! length where it cannot save more, else weighed by the octets it agrees on within the first 8
//! and kept by a select, as `Pick.consider` does in Zig. A hit that agrees on all 8 goes back to
//! the caller, which measures it to its end and enters the loop again with the hits left.
//!
//! It takes an aarch64 target built by LLVM; every other target runs another loop. Its branches
//! each refuse a candidate: out of reach, refused by the compare, or a collision, which agrees on
//! fewer than 4 octets.
//!
//! The loop's values arrive and leave in registers, not through memory: the caller's copy of the
//! search then costs no store and no load for each call. A search with no compare set runs a loop
//! without the compare's three registers, which the caller then keeps its own values in.
//!
//! Its reads go by address, without Zig's bounds checks. A hit's way is below 16, inside the
//! bucket; a candidate in reach lies below the position, whose 8 octets lie before the block's end
//! (`best`'s assertion), so each read of 8 octets stays in the window, and so does the compare's
//! read, which ends at the best length, inside the stream.

const std = @import("std");
const builtin = @import("builtin");
const constants = @import("../../constants.zig");
const assembly = @import("encoder_hits_assembly.zig");
const buckets_module = @import("encoder_buckets.zig");

const Buckets = buckets_module.Buckets;
const ways = buckets_module.ways;

/// Whether the assembly searches the hits: an aarch64 target built by LLVM.
pub const takes = builtin.cpu.arch == .aarch64 and builtin.zig_backend == .stage2_llvm;

/// The search's values, each in a register of `consider`'s text. A candidate is its position less
/// `low`, the lowest position in reach.
pub const Search = struct {
    /// The window from `low`.
    window: [*]const u8,
    here: u64,
    cost: u64,
    /// The bits `consider` clears for a hit: bits 60 to 63.
    top: u64 = std.math.maxInt(u4) << (@bitSizeOf(u64) - @bitSizeOf(u4)),
    /// `position - low`: a candidate in reach lies below it, and its distance is the reach less it.
    reach: u64,
    /// The stream's base plus `low`, modulo 2^32: an entry less it is the candidate.
    base: u64,
    entries: [*]const u32,
    /// The bucket's ring's next way plus 15: the way written `step` inserts before the last is
    /// `newest - step`, modulo 16.
    newest: u64,
    /// The hits left, bits `60 - 4 * step` to `63 - 4 * step` for the way written `step` inserts
    /// before the last.
    order: u64,
    /// The best saving plus `cost_bias`, and its candidate.
    saves: i64,
    candidate: u64,
    /// The compare at the best length: the window from `low + at`, the 8 octets from `at` at the
    /// position, and the most leading zeros of a distance whose candidate the compare may refuse;
    /// -1 for none.
    tail_window: [*]const u8,
    tail: u64,
    clz_max: i64,
};

/// What `consider` returns when no hit is left.
pub const none = std.math.maxInt(u64);

/// The search of `slot`'s hits at `position`, the best so far `saves` and `candidate`, or none
/// when no hit lies in reach. Early in a stream begun with `start`, most hits are entries of an
/// earlier stream: one compare of the bucket's 16 entries against the reach drops them first.
pub inline fn begin(buckets: *const Buckets, slot: buckets_module.Slot, window: [*]const u8, position: usize, low: usize, here: u64, cost: u32, saves: i64, candidate: usize) ?Search {
    var hits = buckets.hit_nibbles(slot);
    // Many positions of a row of literals have no hit, and then the setup costs more than the scan.
    if (hits == 0) return null;
    const base = buckets.base +% @as(u32, @truncate(low));
    if (position < constants.encoder_level5.reach_compare_len) {
        hits &= buckets.reach_nibbles(slot, base, @intCast(position - low));
        if (hits == 0) return null;
    }
    const next: u64 = buckets.next[slot.bucket] % ways;
    return .{
        .window = window + low,
        .here = here,
        .cost = cost,
        .reach = position - low,
        .base = base,
        .entries = &buckets.entries[slot.bucket],
        .newest = next + ways - 1,
        .order = std.math.rotr(u64, hits, next * @bitSizeOf(u4)),
        .saves = saves + assembly.cost_bias,
        .candidate = candidate -% low,
        .tail_window = undefined,
        .tail = undefined,
        .clz_max = -1,
    };
}

/// Sets the compare at the best length, or none for a `clz_max` of -1.
pub inline fn set_compare(search: *Search, tail_window: [*]const u8, tail: u64, clz_max: i64) void {
    search.tail_window = tail_window;
    search.tail = tail;
    search.clz_max = clz_max;
}

/// Whether a compare at the best length is set.
pub inline fn compares(search: *const Search) bool {
    return search.clz_max >= 0;
}

/// Considers the hits `search.order` names, the newest first, until one agrees on all 8 octets:
/// returns it, for the caller to measure, or `none` when no hit is left.
pub inline fn consider(search: *Search) u64 {
    var order = search.order;
    var saves = search.saves;
    var candidate = search.candidate;
    var pending: u64 = undefined;
    asm volatile (consider_text
        : [order] "={x9}" (order),
          [saves] "={x10}" (saves),
          [candidate] "={x11}" (candidate),
          [pending] "={x15}" (pending),
        : [newest] "{x0}" (search.newest),
          [window] "{x1}" (search.window),
          [here] "{x2}" (search.here),
          [cost] "{x3}" (search.cost),
          [top] "{x4}" (search.top),
          [reach] "{x6}" (search.reach),
          [base] "{x7}" (search.base),
          [entries] "{x8}" (search.entries),
          [order_in] "{x9}" (order),
          [saves_in] "{x10}" (saves),
          [candidate_in] "{x11}" (candidate),
          [tail_window] "{x12}" (search.tail_window),
          [tail] "{x13}" (search.tail),
          [clz_max] "{x14}" (search.clz_max),
        : .{ .memory = true, .nzcv = true, .x16 = true, .x17 = true });
    search.order = order;
    search.saves = saves;
    search.candidate = candidate;
    return pending;
}

/// `consider` while no compare at the best length is set.
pub inline fn consider_first(search: *Search) u64 {
    var order = search.order;
    var saves = search.saves;
    var candidate = search.candidate;
    var pending: u64 = undefined;
    asm volatile (consider_first_text
        : [order] "={x9}" (order),
          [saves] "={x10}" (saves),
          [candidate] "={x11}" (candidate),
          [pending] "={x15}" (pending),
        : [newest] "{x0}" (search.newest),
          [window] "{x1}" (search.window),
          [here] "{x2}" (search.here),
          [cost] "{x3}" (search.cost),
          [top] "{x4}" (search.top),
          [reach] "{x6}" (search.reach),
          [base] "{x7}" (search.base),
          [entries] "{x8}" (search.entries),
          [order_in] "{x9}" (order),
          [saves_in] "{x10}" (saves),
          [candidate_in] "{x11}" (candidate),
        : .{ .memory = true, .nzcv = true, .x16 = true, .x17 = true });
    search.order = order;
    search.saves = saves;
    search.candidate = candidate;
    return pending;
}

/// x0 the newest way plus 16 less 1, x1 the window from the lowest position in reach, x2 the
/// position's 8 octets, x3 a literal's cost, x4 bits 60 to 63, x6 the reach, x7 the stream's base
/// plus the lowest position, x8 the bucket's entries, x9 the hits in order, x10 the best saving
/// plus `cost_bias`, x11 its candidate, x12 to x14 the compare at the best length; x15 the
/// candidate to measure. A candidate's distance's leading zeros go in x17.
const pick =
    \\ cbz x9, 8f
    \\1:
    // The newest hit's way, and the hit cleared: 4 bits a way.
    \\ clz x15, x9
    \\ lsr x16, x4, x15
    \\ bic x9, x9, x16
    \\ sub w15, w0, w15, lsr #2
    \\ and w15, w15, #15
    // The candidate: an entry of an earlier stream or past the position wraps past the reach.
    \\ ldr w15, [x8, w15, uxtw #2]
    \\ sub w15, w15, w7
    \\ cmp w15, w6
    \\ b.hs 3f
    \\
;

const distance =
    \\ sub x17, x6, x15
    \\ clz x17, x17
    \\
;

/// A candidate no nearer than the best saves more only when it is longer: 8 octets that differ up
/// to the best length refuse it. A best that a shorter match took since saves more, so the compare
/// still refuses only what saves no more.
const compare =
    \\ cmp x17, x14
    \\ b.gt 2f
    \\ ldr x16, [x12, x15]
    \\ cmp x16, x13
    \\ b.ne 3f
    \\2:
    \\
;

/// All 8 octets agree: the caller measures the candidate. Fewer than the first 4: a collision.
const agree =
    \\ ldr x16, [x1, x15]
    \\ eor x16, x16, x2
    \\ cbz x16, 9f
    \\ cbnz w16, 3f
    \\
;

/// The saving plus `cost_bias`: agreed octets at a literal's cost, and 8 for each leading zero of
/// the distance. The best saving wins, and the first of equal savings stays.
const weigh =
    \\ rbit x16, x16
    \\ clz x16, x16
    \\ lsr x16, x16, #3
    \\ mul x16, x16, x3
    \\ add x16, x16, x17, lsl #3
    \\ cmp x16, x10
    \\ csel x10, x16, x10, gt
    \\ csel x11, x15, x11, gt
    \\3:
    \\ cbnz x9, 1b
    \\8:
    \\ mov x15, #-1
    \\9:
;

const consider_text = pick ++ distance ++ compare ++ agree ++ weigh;
// With no compare, the distance waits until a candidate agrees.
const consider_first_text = pick ++ agree ++ distance ++ weigh;

/// The lazy step's probe of a bucket's hits, each a register of `probe`'s text: the hits in way
/// order, each admitted by `Floor`'s compare. A candidate is its position less `low`.
pub const Probe = struct {
    /// The window from `low` and the floor's offset, and from one octet before it.
    tail_window: [*]const u8,
    shorter_window: [*]const u8,
    reach: u64,
    /// The stream's base plus `low`, modulo 2^32: an entry less it is the candidate.
    base: u64,
    entries: [*]const u32,
    /// The hits left, bit 4w for way w.
    order: u64,
    /// The floor: the 4 octets at its offset, and nearer than `near`, the 4 octets one before.
    near: u64,
    tail: u64,
    shorter_tail: u64,
};

/// One bit of each way's 4 in a mask of `hit_nibbles`, so a cleared bit clears its way.
const way_bits = std.math.maxInt(u64) / std.math.maxInt(u4);

/// The probe of `slot`'s hits at `position`, as `begin` finds them, or none when no hit lies in
/// reach. `at`, `tail`, `near` and `shorter_tail` are the floor's.
pub inline fn probe_begin(buckets: *const Buckets, slot: buckets_module.Slot, window: [*]const u8, position: usize, low: usize, at: usize, tail: u32, near: usize, shorter_tail: u32) ?Probe {
    var hits = buckets.hit_nibbles(slot);
    if (hits == 0) return null;
    const base = buckets.base +% @as(u32, @truncate(low));
    if (position < constants.encoder_level5.reach_compare_len) {
        hits &= buckets.reach_nibbles(slot, base, @intCast(position - low));
        if (hits == 0) return null;
    }
    return .{
        .tail_window = window + low + at,
        .shorter_window = window + low + at - 1,
        .reach = position - low,
        .base = base,
        .entries = &buckets.entries[slot.bucket],
        .order = hits & way_bits,
        .near = near,
        .tail = tail,
        .shorter_tail = shorter_tail,
    };
}

/// Takes the hits `probe.order` names, the lowest way first, until the floor admits one: returns
/// it, for the caller to measure, or `none` when no hit is left.
pub inline fn probe(search: *Probe) u64 {
    var order = search.order;
    var pending: u64 = undefined;
    asm volatile (probe_text
        : [order] "={x9}" (order),
          [pending] "={x15}" (pending),
        : [reach] "{x6}" (search.reach),
          [base] "{x7}" (search.base),
          [entries] "{x8}" (search.entries),
          [order_in] "{x9}" (order),
          [shorter_tail] "{x10}" (search.shorter_tail),
          [near] "{x11}" (search.near),
          [tail_window] "{x12}" (search.tail_window),
          [tail] "{x13}" (search.tail),
          [shorter_window] "{x14}" (search.shorter_window),
        : .{ .memory = true, .nzcv = true, .x16 = true, .x17 = true });
    search.order = order;
    return pending;
}

/// x6 the reach, x7 the stream's base plus the lowest position, x8 the bucket's entries, x9 the
/// hits, x10 to x14 the floor; x15 the candidate to measure. The lowest way first: its bit, the
/// way's 4 bits' lowest, cleared.
const probe_text =
    \\ cbz x9, 8f
    \\1:
    \\ rbit x15, x9
    \\ clz x15, x15
    \\ sub x16, x9, #1
    \\ and x9, x9, x16
    \\ lsr w15, w15, #2
    // The candidate: an entry of an earlier stream or past the position wraps past the reach.
    \\ ldr w15, [x8, w15, uxtw #2]
    \\ sub w15, w15, w7
    \\ cmp w15, w6
    \\ b.hs 3f
    // The floor: the 4 octets that end at the held match's length, or, for a candidate nearer
    // than `near`, the 4 octets one before.
    \\ ldr w16, [x12, x15]
    \\ cmp w16, w13
    \\ b.eq 9f
    \\ sub x17, x6, x15
    \\ cmp x17, x11
    \\ b.hs 3f
    \\ ldr w16, [x14, x15]
    \\ cmp w16, w10
    \\ b.eq 9f
    \\3:
    \\ cbnz x9, 1b
    \\8:
    \\ mov x15, #-1
    \\9:
;
