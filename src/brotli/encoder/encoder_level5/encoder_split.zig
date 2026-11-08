//! Level 5's literal blocks (RFC 7932 §6; decision 62, as the owner's ruling of 2026-11-07 orders
//! its forms): a meta-block's literals, cut into chunks of `split_chunk_len`, go to block types
//! whose literals code alike, and each type takes a prefix code of its own.
//!
//! The first pass gives each chunk the type whose code takes it in the fewest bits, or a new type
//! when that costs more than `split_threshold` past the chunk's own entropy. Each later pass moves
//! every chunk to its cheapest type, a switch from the chunk before costing `split_switch_cost`.
//! The types are then numbered in the order they first occur, so the first block is type 0, and
//! runs of one type join into blocks. Where the split prices above one code, one block remains.
//!
//! Every cost is an integer in 1/64 bit from `log2_scaled`, so the split is a function of the
//! meta-block's literals alone (invariant 5).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");

const level5 = constants.encoder_level5;
pub const types_max = constants.block_types_max;
const alphabet_len = constants.literal_alphabet_len;
const chunk_len = level5.split_chunk_len;
const len_max = constants.encoder_meta_block_len_max;
/// The most chunks, and so blocks, of a meta-block.
pub const chunks_max = std.math.divCeil(usize, len_max, chunk_len) catch unreachable;
const shift = level5.split_cost_shift;
const lanes = level5.split_lanes;
const Lanes = @Vector(lanes, u16);
/// A cost no chunk reaches, for the lanes past the last type.
const cost_none = std.math.maxInt(u16);

comptime {
    // A type's count of literals fits 16 bits, and so does a chunk's cost with a switch's: a
    // symbol's cost is 18 bits at most, in 1/64 bit.
    assert(len_max <= std.math.maxInt(u16));
    assert(chunk_len * ((@bitSizeOf(u16) + 2) << shift) + level5.split_switch_cost < cost_none);
    assert(types_max <= std.math.maxInt(u8) + 1 and types_max % lanes == 0);
}

/// log2(x) in 1/64 bit, for x of 1 or more: the place of x's top bit, and the 6 bits below it
/// through a table of log2(1 + i/64).
pub fn log2_scaled(x: u32) u32 {
    assert(x > 0);
    const top: u5 = @intCast(@bitSizeOf(u32) - 1 - @clz(x));
    const fraction: u32 = if (top >= shift) (x >> (top - shift)) else (x << (shift - top));
    return (@as(u32, top) << shift) + fraction_table[fraction & ((1 << shift) - 1)];
}

/// `log2_scaled` of the counts below `small_len`, which most of a meta-block's costs take.
inline fn log2_small(x: u32) u32 {
    if (x < small_len) return small_table[x];
    return log2_scaled(x);
}

const small_len = 1024;
const small_table_quota = 100_000;
const small_table = table: {
    @setEvalBranchQuota(small_table_quota);
    var entries: [small_len]u16 = undefined;
    entries[0] = 0;
    for (entries[1..], 1..) |*entry, index| entry.* = log2_scaled(index);
    break :table entries;
};

const fraction_table = table: {
    var entries: [1 << shift]u32 = undefined;
    for (&entries, 0..) |*entry, index| {
        const value: f64 = 1.0 + @as(f64, @floatFromInt(index)) / (1 << shift);
        entry.* = @intFromFloat(@round(@log2(value) * (1 << shift)));
    }
    break :table entries;
};

pub const Split = struct {
    /// The meta-block's literals in order.
    literals: [len_max]u8,
    literals_len: usize,
    chunk_types: [chunks_max]u8,
    types_count: usize,
    /// The blocks: each one's type and literals.
    block_types: [chunks_max]u8,
    block_lens: [chunks_max]u16,
    blocks_count: usize,
    /// Each type's literal counts, and each octet's cost under each type in 1/64 bit, the types
    /// side by side so one vector add prices a literal under 16 of them.
    counts: [types_max][alphabet_len]u16,
    costs: [alphabet_len][types_max]u16,

    fn chunks_count(self: *const Split) usize {
        return std.math.divCeil(usize, self.literals_len, chunk_len) catch unreachable;
    }

    fn chunk(self: *const Split, index: usize) []const u8 {
        const start = index * chunk_len;
        return self.literals[start..@min(start + chunk_len, self.literals_len)];
    }
};

/// Splits the literals of `commands`, a meta-block's from `window[start..]`, into blocks.
pub fn split(comptime safety: bool, self: *Split, window: []const u8, start: usize, commands: anytype) void {
    @setRuntimeSafety(safety);
    gather(safety, self, window, start, commands);
    self.types_count = 1;
    if (self.literals_len < level5.split_literals_min) return make_one(self, &commands.literal_counts);
    // The seed leaves each type's counts those of its chunks; a pass moves chunks, and the counts
    // follow before the next pass and after the numbering.
    seed(self);
    if (self.types_count > 1) {
        for (0..level5.split_passes) |pass| {
            if (pass > 0) recount(self);
            move_chunks(self);
        }
        recount(self);
        merge_types(self);
        number_types(self);
        recount(self);
    }
    if (self.types_count > 1 and price_split(self) >= price_one(&commands.literal_counts)) return make_one(self, &commands.literal_counts);
    join_blocks(self);
}

/// Puts every literal, whose counts are `literal_counts`, in one block of type 0.
pub fn make_one(self: *Split, literal_counts: *const [alphabet_len]u16) void {
    @memset(self.chunk_types[0..self.chunks_count()], 0);
    self.types_count = 1;
    self.counts[0] = literal_counts.*;
    join_blocks(self);
}

fn gather(comptime safety: bool, self: *Split, window: []const u8, start: usize, commands: anytype) void {
    @setRuntimeSafety(safety);
    var position = start;
    var len: usize = 0;
    for (commands.commands[0..commands.count]) |command| {
        @memcpy(self.literals[len..][0..command.insert_len], window[position..][0..command.insert_len]);
        len += command.insert_len;
        position += @as(usize, command.insert_len) + command.copy_len;
    }
    assert(len == commands.literals_len);
    self.literals_len = len;
}

/// The first pass: each chunk to the cheapest type so far, or to a new type of its own.
fn seed(self: *Split) void {
    clear_group(self, 0);
    self.counts[0] = @splat(0);
    self.chunk_types[0] = 0;
    add_chunk(self, 0, self.chunk(0));
    rebuild_costs(self, 0);
    // A type's costs are rebuilt after `split_refresh_chunks` chunks, or an eighth of those it
    // holds when that is more: the costs move less as a type grows.
    var since_rebuild: [types_max]u16 = undefined;
    var held: [types_max]u16 = undefined;
    since_rebuild[0] = 0;
    held[0] = 1;
    for (1..self.chunks_count()) |index| {
        const piece = self.chunk(index);
        const best = cheapest(self, piece, null);
        var chosen = best.type_index;
        // A cost within the threshold starts no type whatever the chunk's entropy, so that is
        // computed only past it.
        const fits = best.cost <= level5.split_threshold or best.cost <= own_cost(piece) + level5.split_threshold;
        if (!fits and self.types_count < types_max) {
            chosen = self.types_count;
            if (chosen % lanes == 0) clear_group(self, chosen);
            self.types_count += 1;
            self.counts[chosen] = @splat(0);
            since_rebuild[chosen] = level5.split_refresh_chunks;
            held[chosen] = 0;
        }
        add_chunk(self, chosen, piece);
        since_rebuild[chosen] += 1;
        held[chosen] += 1;
        if (since_rebuild[chosen] >= @max(level5.split_refresh_chunks, held[chosen] / level5.split_refresh_share)) {
            rebuild_costs(self, chosen);
            since_rebuild[chosen] = 0;
        }
        self.chunk_types[index] = @intCast(chosen);
    }
}

/// Zeroes the costs of the 16 types from `first`, so the lanes past the last type add no stale
/// cost: `cheapest` sums every lane of a group.
fn clear_group(self: *Split, first: usize) void {
    for (&self.costs) |*row| row[first..][0..lanes].* = @splat(0);
}

/// A later pass: each chunk to the type that takes it and its switch in the fewest bits.
fn move_chunks(self: *Split) void {
    for (0..self.types_count) |type_index| rebuild_costs(self, type_index);
    for (0..self.chunks_count()) |index| {
        const previous: ?usize = if (index == 0) null else self.chunk_types[index - 1];
        self.chunk_types[index] = @intCast(cheapest(self, self.chunk(index), previous).type_index);
    }
}

const Choice = struct { type_index: usize, cost: u32 };

/// The type whose costs take `piece` in the fewest bits, a type other than `previous` paying a
/// switch.
fn cheapest(self: *const Split, piece: []const u8, previous: ?usize) Choice {
    const groups = std.math.divCeil(usize, self.types_count, lanes) catch unreachable;
    var sums: [types_max / lanes]Lanes = @splat(@splat(0));
    for (piece) |octet| {
        const row = &self.costs[octet];
        for (sums[0..groups], 0..) |*sum, group| sum.* += row[group * lanes ..][0..lanes].*;
    }
    var best: Choice = .{ .type_index = 0, .cost = std.math.maxInt(u32) };
    for (sums[0..groups], 0..) |sum, group| {
        const first = group * lanes;
        var priced = sum;
        if (previous) |kept| priced += switch_costs(first, kept);
        // The lanes past the last type take no chunk.
        const index: Lanes = std.simd.iota(u16, lanes) + @as(Lanes, @splat(@intCast(first)));
        priced = @select(u16, index < @as(Lanes, @splat(@intCast(self.types_count))), priced, @as(Lanes, @splat(cost_none)));
        const least = @reduce(.Min, priced);
        if (least >= best.cost) continue;
        const at: u16 = @bitCast(priced == @as(Lanes, @splat(least)));
        best = .{ .type_index = first + @ctz(at), .cost = least };
    }
    return best;
}

/// A switch's cost in each lane from `first` but the lane of the type `kept`.
fn switch_costs(first: usize, kept: usize) Lanes {
    const index: Lanes = std.simd.iota(u16, lanes) + @as(Lanes, @splat(@intCast(first)));
    return @select(u16, index == @as(Lanes, @splat(@intCast(kept))), @as(Lanes, @splat(0)), @as(Lanes, @splat(level5.split_switch_cost)));
}

/// The bits `piece` takes under a code of its own counts, its entropy.
fn own_cost(piece: []const u8) u32 {
    // Only the octets of `piece` are read, so only theirs are cleared.
    var counts: [alphabet_len]u8 = undefined;
    for (piece) |octet| counts[octet] = 0;
    for (piece) |octet| counts[octet] += 1;
    const total = log2_scaled(@intCast(piece.len));
    var cost: u32 = 0;
    for (piece) |octet| cost += total - log2_small(counts[octet]);
    return cost;
}

fn add_chunk(self: *Split, type_index: usize, piece: []const u8) void {
    for (piece) |octet| self.counts[type_index][octet] += 1;
}

/// Each symbol's cost under `type_index`'s counts, one half added to each so no cost is endless:
/// counts and total are doubled, so the half is an integer.
const doubled = 2;

fn rebuild_costs(self: *Split, type_index: usize) void {
    var total: u32 = 0;
    for (self.counts[type_index]) |count| total += count;
    const whole = log2_scaled(doubled * total + doubled);
    for (&self.costs, self.counts[type_index]) |*row, count| {
        row[type_index] = @intCast(whole - log2_small(doubled * @as(u32, count) + 1));
    }
}

/// Joins each type to the earlier one whose joined counts save the most bits, where any does: a
/// chunk across two kinds of literal starts a type of its own, which the passes do not empty.
fn merge_types(self: *Split) void {
    var prices: [types_max]u64 = undefined;
    var into: [types_max]u8 = undefined;
    for (0..self.types_count) |type_index| {
        prices[type_index] = price_counts(&self.counts[type_index]);
        into[type_index] = @intCast(type_index);
    }
    for (1..self.types_count) |later| {
        const best = best_join(self, &prices, &into, later) orelse continue;
        for (&self.counts[best.into], self.counts[later]) |*count, added| count.* += added;
        prices[best.into] = best.price;
        into[later] = @intCast(best.into);
    }
    for (self.chunk_types[0..self.chunks_count()]) |*type_index| type_index.* = into[type_index.*];
}

const Join = struct { into: usize, price: u64 };

/// The earlier type still kept whose counts joined with `later`'s price lowest, if that is below
/// the two apart.
fn best_join(self: *const Split, prices: *const [types_max]u64, into: *const [types_max]u8, later: usize) ?Join {
    var best: ?Join = null;
    var best_saving: u64 = 0;
    for (0..later) |earlier| {
        if (into[earlier] != earlier) continue;
        var joined: [alphabet_len]u16 = undefined;
        for (&joined, self.counts[earlier], self.counts[later]) |*count, left, right| count.* = left + right;
        const price = price_counts(&joined);
        const apart = prices[earlier] + prices[later];
        if (price >= apart or apart - price <= best_saving) continue;
        best_saving = apart - price;
        best = .{ .into = earlier, .price = price };
    }
    return best;
}

/// Numbers the types in the order they first occur, dropping those no chunk took.
fn number_types(self: *Split) void {
    const none = std.math.maxInt(u16);
    var numbers: [types_max]u16 = @splat(none);
    var next: u16 = 0;
    for (self.chunk_types[0..self.chunks_count()]) |*type_index| {
        if (numbers[type_index.*] == none) {
            numbers[type_index.*] = next;
            next += 1;
        }
        type_index.* = @intCast(numbers[type_index.*]);
    }
    self.types_count = next;
}

/// Each type's counts from the chunks it holds.
fn recount(self: *Split) void {
    for (self.counts[0..self.types_count]) |*counts| counts.* = @splat(0);
    for (0..self.chunks_count()) |index| add_chunk(self, self.chunk_types[index], self.chunk(index));
}

fn join_blocks(self: *Split) void {
    self.blocks_count = 0;
    for (0..self.chunks_count()) |index| {
        const len: u16 = @intCast(self.chunk(index).len);
        const type_index = self.chunk_types[index];
        if (self.blocks_count > 0 and self.block_types[self.blocks_count - 1] == type_index) {
            self.block_lens[self.blocks_count - 1] += len;
            continue;
        }
        self.block_types[self.blocks_count] = type_index;
        self.block_lens[self.blocks_count] = len;
        self.blocks_count += 1;
    }
}

/// The bits a code of `counts` takes, with its description as the split prices it.
fn price_counts(counts: *const [alphabet_len]u16) u64 {
    var total: u32 = 0;
    for (counts) |count| total += count;
    if (total == 0) return 0;
    const whole = log2_scaled(total);
    var cost: u64 = level5.split_tree_cost;
    for (counts) |count| {
        if (count == 0) continue;
        cost += @as(u64, count) * (whole - log2_scaled(count)) + level5.split_symbol_cost;
    }
    return cost;
}

fn price_split(self: *const Split) u64 {
    var cost: u64 = 0;
    for (self.counts[0..self.types_count]) |*counts| cost += price_counts(counts);
    var switches: u64 = 0;
    for (1..self.chunks_count()) |index| {
        if (self.chunk_types[index] != self.chunk_types[index - 1]) switches += 1;
    }
    return cost + switches * level5.split_switch_cost;
}

fn price_one(literal_counts: *const [alphabet_len]u16) u64 {
    return price_counts(literal_counts);
}

const testing = std.testing;

test "log2_scaled gives log2 in 1/64 bit" {
    try testing.expectEqual(0, log2_scaled(1));
    try testing.expectEqual(1 << shift, log2_scaled(2));
    try testing.expectEqual(10 << shift, log2_scaled(1024));
    // log2(3) is 1.585, 101 in 1/64 bit.
    try testing.expectEqual(log2_three, log2_scaled(3));
}

/// log2(3) in 1/64 bit.
const log2_three = 101;

test "literals of one kind take one block of type 0, whatever the state held before" {
    try @call(.never_inline, expect_one_kind, .{});
}

/// Literals of one kind in a meta-block that splits: the split must write each chunk's type, the
/// first included, and not read what the state held (invariant 4).
fn expect_one_kind() !void {
    var state: Split = undefined;
    @memset(std.mem.asBytes(&state), std.math.maxInt(u8));
    var window: [one_kind_len]u8 = undefined;
    var generator = @import("codec").testing.split.Generator.init(one_kind_len);
    for (&window) |*octet| octet.* = 'a' + @as(u8, @intCast(generator.below(one_kind_alphabet)));
    var commands: encoder_commands.WideCommands = undefined;
    commands.init();
    commands.add_literals(true, &window);
    commands.close();
    split(true, &state, &window, 0, &commands);
    try testing.expectEqual(1, state.types_count);
    try testing.expectEqual(1, state.blocks_count);
    try testing.expectEqual(0, state.block_types[0]);
}

/// Twice the fewest literals a meta-block splits, of 16 letters.
const one_kind_len = one_kind_times * level5.split_literals_min;
const one_kind_times = 2;
const one_kind_alphabet = 16;
