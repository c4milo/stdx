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
    // A rebuild compares a type's counts a vector of `lanes` at a time.
    assert(alphabet_len % lanes == 0);
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
pub inline fn log2_small(x: u32) u32 {
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
    /// Each type's literal counts, and each octet's term of its cost under each type in 1/64 bit,
    /// the types side by side so one vector add prices a literal under 16 of them. A literal's
    /// cost is its type's whole less its term.
    counts: [types_max][alphabet_len]u16,
    costs: [alphabet_len][types_max]u16,
    wholes: [types_max]u16,
    /// Each type's whole times `chunk_len`: the whole of a full chunk, which every chunk but a
    /// meta-block's last is.
    chunk_wholes: [types_max]u16,
    /// Each type's counts when its costs were last rebuilt: a symbol whose count differs has a
    /// stale term.
    rebuilt: [types_max][alphabet_len]u16,
    /// For the merge: each type's symbols that occur, how many, and its literals.
    listed: [types_max][alphabet_len]u8,
    listed_len: [types_max]u16,
    totals: [types_max]u32,

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
    // Each step leaves each type's counts those of its chunks: a pass moves a chunk's counts with
    // it, the merge adds a type's to the one it joins, and the numbering moves them to the number.
    seed(self);
    if (self.types_count > 1) {
        for (0..level5.split_passes) |_| move_chunks(self);
        merge_types(self);
        number_types(self);
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
        position += command.insert_len + encoder_commands.written_of(command);
    }
    assert(len == commands.literals_len);
    self.literals_len = len;
}

/// The first pass: each chunk to the cheapest type so far, or to a new type of its own.
pub fn seed(self: *Split) void {
    clear_group(self, 0);
    start_type(self, 0);
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
            start_type(self, chosen);
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

/// Zeroes the costs and wholes of the 16 types from `first`, so the lanes past the last type add
/// no stale cost: `cheapest` sums and multiplies every lane of a group.
fn clear_group(self: *Split, first: usize) void {
    for (&self.costs) |*row| row[first..][0..lanes].* = @splat(0);
    self.wholes[first..][0..lanes].* = @splat(0);
    self.chunk_wholes[first..][0..lanes].* = @splat(0);
}

/// A later pass: each chunk to the type that takes it and its switch in the fewest bits.
pub fn move_chunks(self: *Split) void {
    for (0..self.types_count) |type_index| rebuild_costs(self, type_index);
    for (0..self.chunks_count()) |index| {
        const previous: ?usize = if (index == 0) null else self.chunk_types[index - 1];
        const moved = cheapest(self, self.chunk(index), previous).type_index;
        const held = self.chunk_types[index];
        if (moved == held) continue;
        const piece = self.chunk(index);
        for (piece) |octet| {
            self.counts[held][octet] -= 1;
            self.counts[moved][octet] += 1;
        }
        self.totals[held] -= @intCast(piece.len);
        self.totals[moved] += @intCast(piece.len);
        self.chunk_types[index] = @intCast(moved);
    }
}

pub const Choice = struct { type_index: usize, cost: u32 };

/// The type whose costs take `piece` in the fewest bits, a type other than `previous` paying a
/// switch.
pub fn cheapest(self: *const Split, piece: []const u8, previous: ?usize) Choice {
    assert(piece.len > 0 and piece.len <= chunk_len);
    const groups = std.math.divCeil(usize, self.types_count, lanes) catch unreachable;
    assert(groups > 0 and groups <= groups_max);
    // A loop for each count of groups keeps the sums in registers.
    return switch (groups) {
        inline 1...groups_max => |count| cheapest_of(count, self, piece, previous),
        else => unreachable,
    };
}

/// The groups of `lanes` types side by side.
const groups_max = types_max / lanes;

fn cheapest_of(comptime groups: usize, self: *const Split, piece: []const u8, previous: ?usize) Choice {
    var sums: [groups]Lanes = @splat(@splat(0));
    for (piece) |octet| {
        const row = &self.costs[octet];
        // No lane wraps: a chunk's terms sum to less than `cost_none`, by the comptime assert on
        // `chunk_len`, and `cheapest` takes no piece longer (decision 17).
        inline for (&sums, 0..) |*sum, group| sum.* +%= row[group * lanes ..][0..lanes].*;
    }
    var best: Choice = .{ .type_index = 0, .cost = std.math.maxInt(u32) };
    const len: Lanes = @splat(@intCast(piece.len));
    const full = piece.len == chunk_len;
    for (sums, 0..) |sum, group| {
        const first = group * lanes;
        // Each literal's cost is its type's whole less its term; no term passes its whole.
        const wholes: Lanes = if (full) self.chunk_wholes[first..][0..lanes].* else len * @as(Lanes, self.wholes[first..][0..lanes].*);
        var priced = wholes - sum;
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

/// Begins `type_index` with no literal. `clear_group` zeroed its terms and whole in this split, and
/// a count of zero has a term of zero, so its terms are those of the counts it starts with.
fn start_type(self: *Split, type_index: usize) void {
    comptime assert(log2_scaled(doubled * 0 + 1) == 0);
    assert(self.wholes[type_index] == 0);
    self.counts[type_index] = @splat(0);
    self.rebuilt[type_index] = @splat(0);
    self.totals[type_index] = 0;
}

fn add_chunk(self: *Split, type_index: usize, piece: []const u8) void {
    for (piece) |octet| self.counts[type_index][octet] += 1;
    self.totals[type_index] += @intCast(piece.len);
}

/// Each symbol's cost under `type_index`'s counts, one half added to each so no cost is endless:
/// counts and total are doubled, so the half is an integer.
const doubled = 2;

/// The whole of `type_index`'s costs from its total, and the term of each symbol whose count
/// differs from the last rebuild's, 16 counts compared at a time: the others' terms stand.
pub fn rebuild_costs(self: *Split, type_index: usize) void {
    const whole = log2_scaled(doubled * self.totals[type_index] + doubled);
    self.wholes[type_index] = @intCast(whole);
    self.chunk_wholes[type_index] = @intCast(whole * chunk_len);
    const counts = &self.counts[type_index];
    const rebuilt = &self.rebuilt[type_index];
    for (0..alphabet_len / lanes) |block| {
        const first = block * lanes;
        const now: Lanes = counts[first..][0..lanes].*;
        const changed: u16 = @bitCast(now != @as(Lanes, rebuilt[first..][0..lanes].*));
        if (changed == 0) continue;
        rebuilt[first..][0..lanes].* = now;
        rebuild_terms(self, type_index, first, changed);
    }
}

/// The terms of the symbols from `first` whose bits `changed` holds.
fn rebuild_terms(self: *Split, type_index: usize, first: usize, changed: u16) void {
    var bits = changed;
    for (0..lanes) |_| {
        if (bits == 0) break;
        const symbol = first + @ctz(bits);
        bits &= bits - 1;
        self.costs[symbol][type_index] = @intCast(log2_small(doubled * @as(u32, self.counts[type_index][symbol]) + 1));
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
        list_symbols(self, type_index);
    }
    for (1..self.types_count) |later| {
        const best = best_join(self, &prices, &into, later) orelse continue;
        join_into(self, best.into, later);
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
        const price = price_joined(self, earlier, later);
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
    move_counts(self, &numbers);
    self.types_count = next;
}

/// Moves each kept type's counts to its number, in place: along each chain of numbers, one type's
/// counts are carried to the next's place until a place that holds none still needed.
fn move_counts(self: *Split, numbers: *const [types_max]u16) void {
    const none = std.math.maxInt(u16);
    var moved: [types_max]bool = @splat(false);
    for (0..self.types_count) |start| {
        if (numbers[start] == none or moved[start]) continue;
        var carried = self.counts[start];
        var at = start;
        for (0..self.types_count) |_| {
            const place = numbers[at];
            moved[at] = true;
            const needed = numbers[place] != none and !moved[place];
            if (!needed) {
                self.counts[place] = carried;
                break;
            }
            const next = self.counts[place];
            self.counts[place] = carried;
            carried = next;
            at = place;
        }
    }
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

/// Lists `type_index`'s symbols that occur, and its literals.
pub fn list_symbols(self: *Split, type_index: usize) void {
    var len: u16 = 0;
    var total: u32 = 0;
    for (self.counts[type_index], 0..) |count, symbol| {
        self.listed[type_index][len] = @intCast(symbol);
        len += @intFromBool(count != 0);
        total += count;
    }
    self.listed_len[type_index] = len;
    self.totals[type_index] = total;
}

/// Adds `later`'s counts to `into`'s, and its symbols to `into`'s list.
pub fn join_into(self: *Split, into: usize, later: usize) void {
    for (self.listed[later][0..self.listed_len[later]]) |symbol| {
        if (self.counts[into][symbol] == 0) {
            self.listed[into][self.listed_len[into]] = symbol;
            self.listed_len[into] += 1;
        }
        self.counts[into][symbol] += self.counts[later][symbol];
    }
    self.totals[into] += self.totals[later];
}

/// `price_counts` of the two types' counts joined, from their symbols that occur: the same sum,
/// over fewer symbols than the alphabet's 256 (decision 66, the split's cost).
pub fn price_joined(self: *const Split, earlier: usize, later: usize) u64 {
    // A type the pass emptied holds no literal; two of them joined cost nothing, as in
    // `price_counts`.
    const total = self.totals[earlier] + self.totals[later];
    if (total == 0) return 0;
    const whole = log2_scaled(total);
    var cost: u64 = level5.split_tree_cost;
    for (self.listed[earlier][0..self.listed_len[earlier]]) |symbol| {
        const count: u32 = @as(u32, self.counts[earlier][symbol]) + self.counts[later][symbol];
        cost += @as(u64, count) * (whole - log2_small(count)) + level5.split_symbol_cost;
    }
    for (self.listed[later][0..self.listed_len[later]]) |symbol| {
        if (self.counts[earlier][symbol] != 0) continue;
        const count: u32 = self.counts[later][symbol];
        cost += @as(u64, count) * (whole - log2_small(count)) + level5.split_symbol_cost;
    }
    return cost;
}

/// The bits a code of `counts` takes, with its description as the split prices it.
pub fn price_counts(counts: *const [alphabet_len]u16) u64 {
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

test {
    _ = @import("encoder_split_test.zig");
}
