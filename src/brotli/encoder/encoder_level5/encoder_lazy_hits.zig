//! Level 5's search of a position's bucket (decision 66, part 6), as quality 5 orders its search:
//! the hits newest first, each measured to its end as it is weighed, after a compare at the best
//! length that refuses most of them before their first octets are read. `Pick.consider` holds the
//! rule. `encoder_hits_aarch64.zig` and `encoder_hits_x86_64.zig` run the loop in assembly where
//! they take the target and the loop runs unchecked; the Zig loop here is the reference whose
//! choice they make.

const std = @import("std");
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");
const buckets_module = @import("encoder_buckets.zig");
const encoder_lazy = @import("encoder_lazy.zig");
const hits_aarch64 = @import("encoder_hits_aarch64.zig");
const hits_x86_64 = @import("encoder_hits_x86_64.zig");
const hits_assembly = @import("encoder_hits_assembly.zig");

const Buckets = buckets_module.Buckets;
const Pick = encoder_lazy.Pick;
const Found = encoder_lazy.Found;
const ways = buckets_module.ways;
const read_len = encoder_lazy.read_len;
const read64 = encoder_lazy.read64;
const cost_bias = hits_assembly.cost_bias;

/// The assembly that searches a bucket's hits on this target, if one takes it.
pub const Assembly = if (hits_aarch64.takes) hits_aarch64 else hits_x86_64;
pub const assembly_takes = hits_aarch64.takes or hits_x86_64.takes;

/// Considers the hits of `slot`'s bucket at `position` into `pick`, the newest first: in assembly
/// for the unchecked loop, else in Zig.
pub inline fn consider(comptime safety: bool, buckets: *const Buckets, slot: buckets_module.Slot, window: []const u8, position: usize, end: usize, low: usize, pick: *Pick) void {
    @setRuntimeSafety(safety);
    if (comptime assembly_takes and !safety) return consider_assembly(safety, Assembly, buckets, slot, window, position, end, low, pick);
    var hits = buckets.hits(slot);
    // Many positions of a row of literals have no hit, and then the setup costs more than the scan.
    if (hits == 0) return;
    // Early in a stream begun with `start`, most hits are entries of an earlier stream.
    if (position < constants.encoder_level5.reach_compare_len) {
        hits &= buckets.reach_bits(slot, buckets.entry_at(slot.check, low), @intCast(position - low));
        if (hits == 0) return;
    }
    const next = buckets.next_of(slot);
    // Bit j of `order` is the way written j inserts before the last.
    var order = std.math.rotl(u16, @bitReverse(hits), next);
    for (0..ways) |_| {
        if (order == 0) break;
        const step = @ctz(order);
        order &= order - 1;
        const way = (next + ways - 1 - step) % ways;
        const candidate = buckets.candidate(slot, buckets.entries[slot.bucket][way], low, position) orelse continue;
        pick.consider(safety, window, position, end, candidate, .bucket);
    }
}

/// `consider` in `Hits`'s assembly: the loop returns each hit that agrees on all 8 octets, and this
/// measures it and enters the loop again with the hits left.
pub inline fn consider_assembly(comptime safety: bool, comptime Hits: type, buckets: *const Buckets, slot: buckets_module.Slot, window: []const u8, position: usize, end: usize, low: usize, pick: *Pick) void {
    @setRuntimeSafety(safety);
    var search = Hits.begin(buckets, slot, window.ptr, position, low, pick.here, pick.cost, pick.saves, pick.candidate) orelse return;
    // The candidate whose length `pick.len` holds.
    var known = search.candidate;
    compare_at_len(safety, Hits, window, position, end, low, pick.len, pick.saves, pick.cost, &search);
    // Each pass takes one hit at least.
    for (0..ways) |_| {
        const pending = if (Hits.compares(&search)) Hits.consider(&search) else Hits.consider_first(&search);
        if (pending == Hits.none) break;
        const candidate = pending + low;
        const len = encoder_lazy.match_len(safety, window, candidate, position, end);
        const saves = encoder_lazy.saving(len, position - candidate, false, pick.cost);
        if (saves + cost_bias > search.saves) {
            search.saves = saves + cost_bias;
            search.candidate = pending;
            known = pending;
            pick.len = len;
            compare_at_len(safety, Hits, window, position, end, low, len, saves, pick.cost, &search);
        }
        if (search.order == 0) break;
    }
    pick.saves = search.saves - cost_bias;
    pick.candidate = search.candidate +% low;
    // A hit the loop kept agrees on fewer than 8 octets, all it has.
    if (search.candidate != known) pick.len = @ctz(pick.here ^ read64(safety, window, pick.candidate)) / @bitSizeOf(u8);
}

/// Sets the loop's compare at the best length, as `Pick.saves_no_more` makes it for a bucket's
/// candidate: none when the best is shorter than 8 octets or runs to the end.
pub fn compare_at_len(comptime safety: bool, comptime Hits: type, window: []const u8, position: usize, end: usize, low: usize, len: usize, saves: i64, cost: u32, search: *Hits.Search) void {
    @setRuntimeSafety(safety);
    if (len < read_len or len >= end - position) return Hits.set_compare(search, undefined, undefined, -1);
    const at = len + 1 - read_len;
    // saving(len, offset) <= saves, where saving = len * cost + 8 * clz(offset) - cost_bias.
    const bound = saves + cost_bias - @as(i64, @intCast(len * cost));
    const clz_max = if (bound < 0) -1 else @divFloor(bound, encoder_commands.eighths);
    Hits.set_compare(search, window.ptr + low + at, read64(safety, window, position + at), clz_max);
}

/// The lazy step's probe over the hits of `slot`'s bucket, the lowest way first: each candidate
/// `Floor` admits is measured. In assembly for the unchecked loop, else in Zig.
pub inline fn probe(comptime safety: bool, buckets: *const Buckets, slot: buckets_module.Slot, window: []const u8, position: usize, end: usize, low: usize, cost: u32, held: Found, found: *?Found) void {
    @setRuntimeSafety(safety);
    const floor = Floor.of(safety, window, position, end, held, cost);
    if (comptime assembly_takes and !safety) return probe_assembly(safety, Assembly, buckets, slot, window, position, end, low, cost, floor, found);
    var hits = buckets.hits(slot);
    for (0..buckets_module.ways) |_| {
        if (hits == 0) break;
        const way = @ctz(hits);
        hits &= hits - 1;
        const candidate = buckets.candidate(slot, buckets.entries[slot.bucket][way], low, position) orelse continue;
        if (!floor.admits(safety, window, position, candidate)) continue;
        encoder_lazy.take(safety, window, position, candidate, end, false, cost, found);
    }
}

/// What a bucket's candidate must agree on for the probe to measure it: the 4 octets `tail` at
/// `at`, which end at the held match's length, or, nearer than `near`, the 4 octets one before.
pub const Floor = struct {
    at: usize,
    tail: u32,
    near: usize,
    shorter_tail: u32,

    inline fn of(comptime safety: bool, window: []const u8, position: usize, end: usize, held: Found, cost: u32) Floor {
        @setRuntimeSafety(safety);
        // Where `held`'s length passes the block's end, no candidate is as long: the first 4
        // octets stand for the tail, and every true candidate is measured.
        const at = if (position + held.len <= end) held.len - @sizeOf(u32) else 0;
        return .{
            .at = at,
            .tail = encoder_lazy.read32(safety, window, position + at),
            // A candidate one octet shorter agrees on the 4 octets one before the tail's; none
            // is, where `held` has the fewest octets a match takes.
            .near = if (at > 0) encoder_lazy.near_limit(held, cost) else 0,
            .shorter_tail = encoder_lazy.read32(safety, window, position + at -| 1),
        };
    }

    inline fn admits(self: Floor, comptime safety: bool, window: []const u8, position: usize, candidate: usize) bool {
        @setRuntimeSafety(safety);
        if (encoder_lazy.read32(safety, window, candidate + self.at) == self.tail) return true;
        if (position - candidate >= self.near) return false;
        return encoder_lazy.read32(safety, window, candidate + self.at - 1) == self.shorter_tail;
    }
};

/// `probe` in `Hits`'s assembly: the loop returns each hit the floor admits, and this measures it
/// and enters the loop again with the hits left.
inline fn probe_assembly(comptime safety: bool, comptime Hits: type, buckets: *const Buckets, slot: buckets_module.Slot, window: []const u8, position: usize, end: usize, low: usize, cost: u32, floor: Floor, found: *?Found) void {
    @setRuntimeSafety(safety);
    var search = Hits.probe_begin(buckets, slot, window.ptr, position, low, floor.at, floor.tail, floor.near, floor.shorter_tail) orelse return;
    // Each pass takes one hit at least.
    for (0..ways) |_| {
        const pending = Hits.probe(&search);
        if (pending == Hits.none) break;
        encoder_lazy.take(safety, window, position, pending + low, end, false, cost, found);
        if (search.order == 0) break;
    }
}

const testing = std.testing;

test "the compare at the best length is set only where its read stays inside the stream" {
    var window: [guard_window_len]u8 = @splat(0);
    const position = guard_window_len / 2;
    const end = window.len;
    var search: Assembly.Search = undefined;
    const cases = [_]struct { len: usize, compares: bool }{
        // A best that runs to the end: a compare there would read past it.
        .{ .len = end - position, .compares = false },
        // One octet shorter: the compare reads up to the end.
        .{ .len = end - position - 1, .compares = true },
        // Shorter than the octets one compare reads.
        .{ .len = read_len - 1, .compares = false },
    };
    for (cases) |case| {
        const saves = encoder_lazy.saving(case.len, guard_offset, false, guard_literal_cost);
        compare_at_len(true, Assembly, &window, position, end, 1, case.len, saves, guard_literal_cost, &search);
        try testing.expectEqual(case.compares, Assembly.compares(&search));
    }
}

const guard_window_len = 64;
const guard_offset = 16;
/// 8 bits a literal, in eighths of a bit.
const guard_literal_cost = 64;
