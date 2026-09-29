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
const codec = @import("codec");
const constants = @import("../constants.zig");

/// The most symbols a code has: the literal/length alphabet a stream may use.
pub const symbols_max = constants.literal_length_used;

/// The items one package of package-merge joins.
const package_arity = 2;

/// The fewest symbols a code gives a length, so that the code is complete (RFC 1951 §3.2.2).
const coded_symbols_min = 2;

/// The nodes Huffman's tree joins into one: two, as a code of bits is binary.
const tree_arity = 2;

/// The symbols of the alphabet whose counts or lengths `Pointer`, a pointer to an array, points
/// at. Every scratch array of a build is sized by it, so a small alphabet's build fills only small
/// arrays: a safe build fills an `undefined` local, and a large one through `memset`.
fn alphabet_len(comptime Pointer: type) usize {
    return @typeInfo(@typeInfo(Pointer).pointer.child).array.len;
}

/// Sets `lengths` for `counts`: 0 for a symbol that does not occur, and otherwise the length of
/// its code in the code of least coded size whose lengths stay at or under `len_max`. When fewer
/// than two symbols occur, the first that do not stand in for the missing ones, so the code is
/// complete, which every decoder accepts.
pub fn build_lengths(counts: anytype, comptime len_max: u4, lengths: *[alphabet_len(@TypeOf(counts))]u8) void {
    var listed: [alphabet_len(@TypeOf(counts))]u16 = undefined;
    _ = build_lengths_listed(counts, len_max, lengths, &listed);
}

/// `build_lengths`, which also lists in `listed` every symbol it gives a length, in increasing
/// order, for `build_codes_listed`. Returns how many.
pub fn build_lengths_listed(counts: anytype, comptime len_max: u4, lengths: *[alphabet_len(@TypeOf(counts))]u8, listed: *[alphabet_len(@TypeOf(counts))]u16) usize {
    const n = comptime alphabet_len(@TypeOf(counts));
    comptime assert(n >= coded_symbols_min and n <= symbols_max and n <= @as(usize, 1) << len_max);
    codec.fill(lengths, 0);
    const used = listed_symbols(n, counts, listed);
    var order: [n]u16 = undefined;
    sort_by_weight(n, counts, listed[0..used], order[0..used]);
    if (!huffman_lengths(n, counts, order[0..used], len_max, lengths)) package_merge(n, counts, order[0..used], len_max, lengths);
    return used;
}

/// `build_lengths` by package-merge alone, for the tests that check it where the limit does not
/// bind.
pub fn build_lengths_package_merge(counts: anytype, comptime len_max: u4, lengths: *[alphabet_len(@TypeOf(counts))]u8) void {
    const n = comptime alphabet_len(@TypeOf(counts));
    comptime assert(n >= coded_symbols_min and n <= symbols_max and n <= @as(usize, 1) << len_max);
    codec.fill(lengths, 0);
    var listed: [n]u16 = undefined;
    const used = listed_symbols(n, counts, &listed);
    var order: [n]u16 = undefined;
    sort_by_weight(n, counts, listed[0..used], order[0..used]);
    package_merge(n, counts, order[0..used], len_max, lengths);
}

/// Sets the lengths of the symbols of `order`, lightest first, to the depths of their leaves in
/// Huffman's tree: the two lightest nodes join, a leaf before a joined node of the same weight,
/// until one node remains. Returns false when a depth passes `len_max`, leaving `lengths` as they
/// were.
fn huffman_lengths(comptime n: usize, counts: *const [n]u16, order: []const u16, len_max: u4, lengths: *[n]u8) bool {
    assert(order.len >= coded_symbols_min and order.len <= n);
    // Leaf i is node i; joined node j is node `order.len + j`. Each node records its parent's
    // joined index, and each joined node its weight.
    var parent: [tree_arity * n]u16 = undefined;
    var joined_weights: [n]u32 = undefined;
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
    var depths: [n]u16 = undefined;
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
fn package_merge(comptime n: usize, counts: *const [n]u16, order: []const u16, comptime len_max: u4, lengths: *[n]u8) void {
    const used = order.len;
    // Level 0 holds the leaves alone; each level above merges them with the packages of the level
    // below, and remembers which of its items are packages.
    var packages: [len_max]std.StaticBitSet(package_arity * n) = undefined;
    var level_len: [len_max]usize = undefined;
    var below: [package_arity * n]u32 = undefined;
    var above: [package_arity * n]u32 = undefined;
    for (order, 0..) |symbol, index| below[index] = weight(counts[symbol]);
    packages[0] = .initEmpty();
    level_len[0] = used;
    for (1..len_max) |level| {
        level_len[level] = merge(n, counts, order, below[0..level_len[level - 1]], &above, &packages[level]);
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

/// Writes into `listed` the symbols that occur, in increasing order, with the first that do not
/// occur added until there are two, still in increasing order. Returns how many.
fn listed_symbols(comptime n: usize, counts: *const [n]u16, listed: *[n]u16) usize {
    var used: usize = 0;
    // Every symbol is written at the next slot, and only one that occurs keeps it: no branch on
    // the counts.
    for (counts, 0..) |count, symbol| {
        listed[used] = @intCast(symbol);
        used += @intFromBool(count != 0);
    }
    for (counts, 0..) |count, symbol| {
        if (used >= coded_symbols_min) break;
        if (count != 0) continue;
        listed[used] = @intCast(symbol);
        used += 1;
    }
    // A filler added after the one symbol that occurs may come before it.
    if (listed[0] > listed[1]) std.mem.swap(u16, &listed[0], &listed[1]);
    return used;
}

/// The values one counting pass sorts by: an octet of the weight.
const pass_buckets = 1 << @bitSizeOf(u8);

/// Writes `from`, which lists symbols in increasing order, into `to` lightest first and by symbol
/// among equals: a counting sort on the weight's low octet, then one on its high octet when any
/// weight has one, each stable, so no compare depends on the data. Each pass counts only up to the
/// heaviest octet it sorts by, so a small block's sort costs what its weights reach.
fn sort_by_weight(comptime n: usize, counts: *const [n]u16, from: []const u16, to: []u16) void {
    assert(from.len == to.len and from.len <= n);
    if (comptime n <= insertion_sort_alphabet_len_max) return insertion_sort_by_weight(counts, from, to);
    var weight_max: u32 = 0;
    for (from) |symbol| weight_max = @max(weight_max, weight(counts[symbol]));
    if (weight_max < pass_buckets) {
        counting_pass(counts, from, to, 0, weight_max + 1);
        return;
    }
    var scratch: [n]u16 = undefined;
    counting_pass(counts, from, scratch[0..from.len], 0, pass_buckets);
    counting_pass(counts, scratch[0..from.len], to, @bitSizeOf(u8), (weight_max >> @bitSizeOf(u8)) + 1);
}

/// The largest alphabet sorted by insertion rather than by counting passes: the distance code's and
/// the code length code's. Their few symbols cost fewer compares than a counting pass's buckets
/// cost to clear.
const insertion_sort_alphabet_len_max = constants.distance_used;

/// `sort_by_weight` by insertion, on a key of each symbol's weight above its number: the same
/// order, lightest first and by symbol among equals.
fn insertion_sort_by_weight(counts: []const u16, from: []const u16, to: []u16) void {
    assert(from.len == to.len);
    for (from, 0..) |symbol, index| {
        const key = sort_key(counts, symbol);
        var at = index;
        for (0..index) |_| {
            if (sort_key(counts, to[at - 1]) < key) break;
            to[at] = to[at - 1];
            at -= 1;
        }
        to[at] = symbol;
    }
}

/// A symbol's weight above its number, so keys order by weight and then by symbol.
inline fn sort_key(counts: []const u16, symbol: u16) u32 {
    return (weight(counts[symbol]) << @bitSizeOf(u16)) | symbol;
}

/// One stable counting pass over `bucket_count` buckets: writes `from` into `to` ordered by the
/// octet of each symbol's weight `shift` bits up, equals in their order.
fn counting_pass(counts: []const u16, from: []const u16, to: []u16, shift: u4, bucket_count: usize) void {
    assert(from.len == to.len and bucket_count <= pass_buckets);
    var starts: [pass_buckets]u16 = undefined;
    codec.fill(std.mem.sliceAsBytes(starts[0..bucket_count]), 0);
    for (from) |symbol| starts[bucket_of(counts, symbol, shift)] += 1;
    var start: u16 = 0;
    for (starts[0..bucket_count]) |*bucket_start| {
        const bucket_len = bucket_start.*;
        bucket_start.* = start;
        start += bucket_len;
    }
    for (from) |symbol| {
        const bucket = bucket_of(counts, symbol, shift);
        to[starts[bucket]] = symbol;
        starts[bucket] += 1;
    }
}

/// The octet of a symbol's weight `shift` bits up.
inline fn bucket_of(counts: []const u16, symbol: u16, shift: u4) u8 {
    return @truncate(weight(counts[symbol]) >> shift);
}

/// One level of package-merge: the leaves and the packages of pairs of `below`, merged lightest
/// first, a leaf before a package of the same weight. Writes the weights into `above` and marks
/// the packages. Returns the level's length.
fn merge(comptime n: usize, counts: *const [n]u16, order: []const u16, below: []const u32, above: *[package_arity * n]u32, packages: *std.StaticBitSet(package_arity * n)) usize {
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
        reversed.* = reverse_bits(next[len], len);
        next[len] += 1;
    }
}

/// `build_codes` for the symbols of `listed`, in increasing order, which are every symbol with a
/// length; every other code is set to 0. A code is built only for a symbol the block uses, and no
/// branch asks which those are.
pub fn build_codes_listed(lengths: []const u8, listed: []const u16, codes: []u16) void {
    assert(lengths.len == codes.len and listed.len <= lengths.len);
    codec.fill(std.mem.sliceAsBytes(codes), 0);
    var counts: [constants.code_len_max + 1]u16 = @splat(0);
    for (listed) |symbol| counts[lengths[symbol]] += 1;
    assert(counts[0] == 0);
    var next: [constants.code_len_max + 1]u16 = @splat(0);
    var code: u16 = 0;
    for (1..constants.code_len_max + 1) |len| {
        // RFC 1951 §3.2.2, step 2: the first code of each length.
        code = (code + counts[len - 1]) << 1;
        next[len] = code;
    }
    for (listed) |symbol| {
        // RFC 1951 §3.2.2, step 3: consecutive codes for the symbols of one length, in order.
        const len = lengths[symbol];
        codes[symbol] = reverse_bits(next[len], len);
        next[len] += 1;
    }
}

/// The low `len` bits of `code`, reversed: an octet table, as most targets have no instruction
/// that reverses bits.
inline fn reverse_bits(code: u16, len: u8) u16 {
    const reversed = (@as(u16, reversed_octets[@as(u8, @truncate(code))]) << @bitSizeOf(u8)) | reversed_octets[@as(u8, @truncate(code >> @bitSizeOf(u8)))];
    return reversed >> @intCast(@bitSizeOf(u16) - @as(u5, @intCast(len)));
}

/// Each octet with its bits reversed.
const reversed_octets: [1 << @bitSizeOf(u8)]u8 = table: {
    var octets: [1 << @bitSizeOf(u8)]u8 = undefined;
    for (&octets, 0..) |*reversed, octet| reversed.* = @bitReverse(@as(u8, @intCast(octet)));
    break :table octets;
};

/// One symbol of the code length alphabet, and the value of its extra bits (RFC 1951 §3.2.7).
pub const Item = struct {
    symbol: u8,
    extra: u8 = 0,
};

/// The most items a dynamic header's code lengths take: one for each length.
pub const items_max = constants.literal_length_used + constants.distance_used;

/// Writes `first` and then `second` as one sequence of code length symbols (RFC 1951 §3.2.7): a
/// run of zeros as 17 or 18, a run of one length as the length and 16, and the rest one symbol
/// each. A run may cross from `first` into `second`, as §3.2.7 lets it cross from the literal and
/// length lengths into the distance lengths. Returns how many.
pub fn run_lengths(first: []const u8, second: []const u8, items: *[items_max]Item) usize {
    const total = first.len + second.len;
    assert(total <= items_max);
    var count: usize = 0;
    var index: usize = 0;
    // Each pass writes at least one item and takes at least one length.
    for (0..total) |_| {
        if (index == total) break;
        const len = length_at(first, second, index);
        var run: usize = 1;
        for (index + 1..total) |next| {
            if (length_at(first, second, next) != len) break;
            run += 1;
        }
        count += run_items(len, run, items[count..]);
        index += run;
    }
    assert(index == total);
    return count;
}

/// The length at `index` of `first` and then `second`.
inline fn length_at(first: []const u8, second: []const u8, index: usize) u8 {
    return if (index < first.len) first[index] else second[index - first.len];
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
