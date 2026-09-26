//! The encoder's Huffman codes (RFC 1951 §3.2.2): code lengths for a block's symbol counts, at most
//! 15 bits long, or 7 for the code length code (§3.2.7); the canonical codes of those lengths,
//! bit-reversed for a stream packed least significant bit first (§3.1.1); and the run-length coding
//! of a dynamic block's code lengths with symbols 16, 17 and 18 (§3.2.7).
//!
//! The lengths come from Huffman's tree, built in one pass over the sorted counts. When a length
//! passes the limit, the package-merge algorithm builds them again: it gives the least coded size
//! under the limit, but costs a pass per bit of the limit, which a block of a few hundred octets
//! would pay once per block.
//!
//! Every choice here breaks ties by symbol, so the codes are a function of the counts alone
//! (invariant 5).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

/// The most symbols a code has: the literal/length alphabet a stream may use.
pub const symbols_max = constants.literal_length_used;

/// The items one package of package-merge joins.
const package_arity = 2;

/// The most items one level of package-merge holds: every symbol, and one package for every two
/// items of the level below.
const level_len_max = package_arity * symbols_max;

/// The fewest symbols a code gives a length, so that the code is complete (RFC 1951 §3.2.2).
const coded_symbols_min = 2;

/// The nodes Huffman's tree joins into one: two, as a code of bits is binary.
const tree_arity = 2;

/// Sets `lengths` for `counts`: 0 for a symbol that does not occur, and otherwise the length of
/// its code in the code of least coded size whose lengths stay at or under `len_max`. When fewer
/// than two symbols occur, the first that do not stand in for the missing ones, so the code is
/// complete, which every decoder accepts.
pub fn build_lengths(counts: []const u16, comptime len_max: u4, lengths: []u8) void {
    assert(counts.len == lengths.len and counts.len <= symbols_max);
    assert(counts.len >= coded_symbols_min and counts.len <= @as(usize, 1) << len_max);
    @memset(lengths, 0);
    var order: [symbols_max]u16 = undefined;
    const used = sorted_symbols(counts, &order);
    if (huffman_lengths(counts, order[0..used], len_max, lengths)) return;
    package_merge(counts, order[0..used], len_max, lengths);
}

/// `build_lengths` by package-merge alone, for the tests that check it where the limit does not
/// bind.
pub fn build_lengths_package_merge(counts: []const u16, comptime len_max: u4, lengths: []u8) void {
    assert(counts.len == lengths.len and counts.len <= symbols_max);
    assert(counts.len >= coded_symbols_min and counts.len <= @as(usize, 1) << len_max);
    @memset(lengths, 0);
    var order: [symbols_max]u16 = undefined;
    const used = sorted_symbols(counts, &order);
    package_merge(counts, order[0..used], len_max, lengths);
}

/// Sets the lengths of the symbols of `order`, lightest first, to the depths of their leaves in
/// Huffman's tree: the two lightest nodes join, a leaf before a joined node of the same weight,
/// until one node remains. Returns false when a depth passes `len_max`, leaving `lengths` as they
/// were.
fn huffman_lengths(counts: []const u16, order: []const u16, len_max: u4, lengths: []u8) bool {
    assert(order.len >= coded_symbols_min and order.len <= symbols_max);
    // Leaf i is node i; joined node j is node `order.len + j`. Each node records its parent's
    // joined index, and each joined node its weight.
    var parent: [tree_arity * symbols_max]u16 = undefined;
    var joined_weights: [symbols_max]u32 = undefined;
    var queues: Queues = .{};
    const joined_count = order.len - 1;
    for (0..joined_count) |joined| {
        joined_weights[joined] = 0;
        for (0..tree_arity) |_| {
            const node = queues.take_lightest(counts, order, joined_weights[0..joined]);
            parent[node] = @intCast(joined);
            joined_weights[joined] += node_weight(counts, order, &joined_weights, node);
        }
    }
    // Each joined node's parent comes after it, and the last is the root, at depth 0.
    var depths: [symbols_max]u16 = undefined;
    var joined = joined_count - 1;
    depths[joined] = 0;
    for (0..joined_count - 1) |_| {
        joined -= 1;
        depths[joined] = depths[parent[order.len + joined]] + 1;
    }
    var depth_max: u16 = 0;
    for (parent[0..order.len]) |leaf_parent| depth_max = @max(depth_max, depths[leaf_parent] + 1);
    if (depth_max > len_max) return false;
    for (order, parent[0..order.len]) |symbol, leaf_parent| lengths[symbol] = @intCast(depths[leaf_parent] + 1);
    return true;
}

/// The fronts of Huffman's two queues: the leaves, lightest first, and the joined nodes, which
/// come out lightest first because each joins two nodes no lighter than the one before.
const Queues = struct {
    leaf: usize = 0,
    joined: usize = 0,

    /// Takes the lightest node at either front, a leaf when the weights tie. Returns its node
    /// number.
    fn take_lightest(queues: *Queues, counts: []const u16, order: []const u16, joined_weights: []const u32) usize {
        const leaf_left = queues.leaf < order.len;
        const joined_left = queues.joined < joined_weights.len;
        assert(leaf_left or joined_left);
        if (leaf_left and (!joined_left or weight(counts[order[queues.leaf]]) <= joined_weights[queues.joined])) {
            queues.leaf += 1;
            return queues.leaf - 1;
        }
        queues.joined += 1;
        return order.len + queues.joined - 1;
    }
};

/// The weight of `node`: its symbol's for a leaf, the sum of its two for a joined node.
fn node_weight(counts: []const u16, order: []const u16, joined_weights: []const u32, node: usize) u32 {
    return if (node < order.len) weight(counts[order[node]]) else joined_weights[node - order.len];
}

/// Sets the lengths of the symbols of `order`, lightest first, by package-merge.
fn package_merge(counts: []const u16, order: []const u16, comptime len_max: u4, lengths: []u8) void {
    const used = order.len;
    // Level 0 holds the leaves alone; each level above merges them with the packages of the level
    // below, and remembers which of its items are packages.
    var packages: [len_max]std.StaticBitSet(level_len_max) = undefined;
    var level_len: [len_max]usize = undefined;
    var below: [level_len_max]u32 = undefined;
    var above: [level_len_max]u32 = undefined;
    for (order, 0..) |symbol, index| below[index] = weight(counts[symbol]);
    packages[0] = .initEmpty();
    level_len[0] = used;
    for (1..len_max) |level| {
        level_len[level] = merge(counts, order, below[0..level_len[level - 1]], &above, &packages[level]);
        below = above;
    }
    // The 2n - 2 lightest items of the top level choose the lengths: each leaf among them, at any
    // level, adds a bit to its symbol's code (RFC 1951 §3.2.2's lengths, found by package-merge).
    var chosen = package_arity * (used - 1);
    var level: usize = len_max;
    for (0..len_max) |_| {
        level -= 1;
        assert(chosen <= level_len[level]);
        var leaves: usize = 0;
        for (0..chosen) |index| leaves += @intFromBool(!packages[level].isSet(index));
        for (order[0..leaves]) |symbol| lengths[symbol] += 1;
        chosen = package_arity * (chosen - leaves);
    }
    assert(chosen == 0);
}

/// A count as a package-merge weight. A symbol standing in for a missing one weighs as one that
/// occurs once.
fn weight(count: u16) u32 {
    return @max(count, 1);
}

/// Writes into `order` the symbols that occur, lightest first and by symbol among equals, with the
/// first that do not occur added until there are two. Returns how many.
fn sorted_symbols(counts: []const u16, order: *[symbols_max]u16) usize {
    var used: usize = 0;
    for (counts, 0..) |count, symbol| {
        if (count == 0) continue;
        order[used] = @intCast(symbol);
        used += 1;
    }
    for (counts, 0..) |count, symbol| {
        if (used >= coded_symbols_min) break;
        if (count != 0) continue;
        order[used] = @intCast(symbol);
        used += 1;
    }
    std.sort.pdq(u16, order[0..used], counts, lighter);
    return used;
}

fn lighter(counts: []const u16, a: u16, b: u16) bool {
    const weight_a = weight(counts[a]);
    const weight_b = weight(counts[b]);
    return weight_a < weight_b or (weight_a == weight_b and a < b);
}

/// One level of package-merge: the leaves and the packages of pairs of `below`, merged lightest
/// first, a leaf before a package of the same weight. Writes the weights into `above` and marks
/// the packages. Returns the level's length.
fn merge(counts: []const u16, order: []const u16, below: []const u32, above: *[level_len_max]u32, packages: *std.StaticBitSet(level_len_max)) usize {
    packages.* = .initEmpty();
    const package_count = below.len / package_arity;
    var leaf: usize = 0;
    var package: usize = 0;
    for (0..order.len + package_count) |index| {
        const package_weight = if (package < package_count) below[package_arity * package] + below[package_arity * package + 1] else std.math.maxInt(u32);
        if (leaf < order.len and weight(counts[order[leaf]]) <= package_weight) {
            above[index] = weight(counts[order[leaf]]);
            leaf += 1;
        } else {
            above[index] = package_weight;
            packages.set(index);
            package += 1;
        }
    }
    return order.len + package_count;
}

/// Sets `codes` to the canonical codes of `lengths` (RFC 1951 §3.2.2), each bit-reversed so it
/// leaves least significant bit first (§3.1.1).
pub fn build_codes(lengths: []const u8, codes: []u16) void {
    assert(lengths.len == codes.len);
    var counts: [constants.code_len_max + 1]u16 = @splat(0);
    for (lengths) |len| counts[len] += 1;
    counts[0] = 0;
    var next: [constants.code_len_max + 1]u16 = @splat(0);
    var code: u16 = 0;
    for (1..constants.code_len_max + 1) |len| {
        // RFC 1951 §3.2.2, step 2: the first code of each length.
        code = (code + counts[len - 1]) << 1;
        next[len] = code;
    }
    for (lengths, codes) |len, *reversed| {
        if (len == 0) continue;
        // RFC 1951 §3.2.2, step 3: consecutive codes for the symbols of one length, in order.
        reversed.* = @bitReverse(next[len]) >> @intCast(@bitSizeOf(u16) - @as(u5, @intCast(len)));
        next[len] += 1;
    }
}

/// One symbol of the code length alphabet, and the value of its extra bits (RFC 1951 §3.2.7).
pub const Item = struct {
    symbol: u8,
    extra: u8 = 0,
};

/// The most items a dynamic header's code lengths take: one for each length.
pub const items_max = constants.literal_length_used + constants.distance_used;

/// Writes `lengths` as code length symbols (RFC 1951 §3.2.7): a run of zeros as 17 or 18, a
/// run of one length as the length and 16, and the rest one symbol each. Returns how many.
pub fn run_lengths(lengths: []const u8, items: *[items_max]Item) usize {
    assert(lengths.len <= items_max);
    var count: usize = 0;
    var index: usize = 0;
    // Each pass writes at least one item and takes at least one length.
    for (0..lengths.len) |_| {
        if (index == lengths.len) break;
        var run: usize = 1;
        for (lengths[index + 1 ..]) |len| {
            if (len != lengths[index]) break;
            run += 1;
        }
        count += run_items(lengths[index], run, items[count..]);
        index += run;
    }
    assert(index == lengths.len);
    return count;
}

/// Writes a run of `run` lengths `len` as items, and returns how many.
fn run_items(len: u8, run: usize, items: []Item) usize {
    var left = run;
    var count: usize = 0;
    if (len != 0) {
        items[0] = .{ .symbol = len };
        left -= 1;
        count = 1;
    }
    for (0..run) |_| {
        const repeat = repeat_for(len, left) orelse break;
        const kind = repeat - constants.repeat_previous;
        const taken = @min(left, constants.repeat_count_max[kind]);
        items[count] = .{ .symbol = repeat, .extra = @intCast(taken - constants.repeat_count_min[kind]) };
        count += 1;
        left -= taken;
    }
    for (items[count..][0..left]) |*item| item.* = .{ .symbol = len };
    return count + left;
}

/// The repeat symbol for `left` more lengths `len`, or null when too few are left for one
/// (RFC 1951 §3.2.7).
fn repeat_for(len: u8, left: usize) ?u8 {
    if (len != 0) return if (left >= constants.repeat_count_min[0]) constants.repeat_previous else null;
    const long = constants.repeat_zero_long - constants.repeat_previous;
    const short = constants.repeat_zero_short - constants.repeat_previous;
    if (left >= constants.repeat_count_min[long]) return constants.repeat_zero_long;
    if (left >= constants.repeat_count_min[short]) return constants.repeat_zero_short;
    return null;
}

test {
    _ = @import("encoder_code_test.zig");
}
