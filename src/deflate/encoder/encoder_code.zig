//! The encoder's Huffman codes (RFC 1951 §3.2.2): code lengths for a block's symbol counts, at most
//! 15 bits long, or 7 for the code length code (§3.2.7); the canonical codes of those lengths,
//! bit-reversed for a stream packed least significant bit first (§3.1.1). The run-length coding of
//! a dynamic block's code lengths with symbols 16, 17 and 18 (§3.2.7) is in `encoder_code_runs.zig`.
//!
//! The lengths come from Huffman's tree, built in one pass over the sorted counts. When a length
//! passes the limit, the package-merge algorithm builds them again: it gives the least coded size
//! under the limit, but costs a pass per bit of the limit, which a block of a few hundred octets
//! would pay once per block.
//!
//! Every choice here breaks ties by symbol, so the codes are a function of the counts alone
//! (invariant 5).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
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

/// A symbol's weight above its number, so that keys order by weight and then by symbol. The sort
/// and the tree's passes read keys in order, where a list of symbols had each look its count up.
pub const Key = u32;

/// The bits a key's weight sits above: its symbol's.
const key_weight_shift = @bitSizeOf(u16);

/// What a symbol standing in for a missing one weighs: as one that occurs once.
const filler_weight = 1;

inline fn key_of(weight: u32, symbol: usize) Key {
    // No symbol is cut: an alphabet holds `symbols_max` at most.
    return (weight << key_weight_shift) | @as(u16, @truncate(symbol));
}

comptime {
    assert(symbols_max <= std.math.maxInt(u16));
}

inline fn symbol_of(key: Key) u16 {
    return @truncate(key);
}

inline fn weight_of(key: Key) u32 {
    return key >> key_weight_shift;
}

/// How many symbols a code gives each length.
pub const LengthCounts = [constants.code_len_max + 1]u16;

/// Sets `lengths` for `counts`: 0 for a symbol that does not occur, and otherwise the length of
/// its code in the code of least coded size whose lengths stay at or under `len_max`. When fewer
/// than two symbols occur, the first that do not stand in for the missing ones, so the code is
/// complete, which every decoder accepts.
pub fn build_lengths(counts: anytype, comptime len_max: u4, lengths: *[alphabet_len(@TypeOf(counts))]u8) void {
    var listed: [alphabet_len(@TypeOf(counts))]Key = undefined;
    var length_counts: LengthCounts = undefined;
    _ = build_lengths_listed(counts, len_max, lengths, &listed, &length_counts);
}

/// `build_lengths`, which also lists in `listed` the key of every symbol it gives a length, in
/// increasing order of symbol, and sets `length_counts` to how many symbols take each length,
/// both for `build_codes_listed`. Returns how many it listed.
pub fn build_lengths_listed(counts: anytype, comptime len_max: u4, lengths: *[alphabet_len(@TypeOf(counts))]u8, listed: *[alphabet_len(@TypeOf(counts))]Key, length_counts: *LengthCounts) usize {
    const n = comptime alphabet_len(@TypeOf(counts));
    comptime assert(n >= coded_symbols_min and n <= symbols_max and n <= @as(usize, 1) << len_max);
    @memset(lengths, 0);
    const used = list_keys(n, counts, listed);
    var order: [n]Key = undefined;
    // The sort's scratch, and then the tree's nodes.
    var work: [n]u32 = undefined;
    sort_keys(n, listed[0..used], order[0..used], work[0..used]);
    if (!huffman_lengths(n, order[0..used], work[0..used], len_max, lengths, length_counts)) {
        package_merge(n, order[0..used], len_max, lengths);
        length_counts.* = @splat(0);
        for (order[0..used]) |key| length_counts[lengths[symbol_of(key)]] += 1;
    }
    return used;
}

/// `build_lengths` by package-merge alone, for the tests that check it where the limit does not
/// bind.
pub fn build_lengths_package_merge(counts: anytype, comptime len_max: u4, lengths: *[alphabet_len(@TypeOf(counts))]u8) void {
    const n = comptime alphabet_len(@TypeOf(counts));
    comptime assert(n >= coded_symbols_min and n <= symbols_max and n <= @as(usize, 1) << len_max);
    @memset(lengths, 0);
    var listed: [n]Key = undefined;
    const used = list_keys(n, counts, &listed);
    var order: [n]Key = undefined;
    var scratch: [n]Key = undefined;
    sort_keys(n, listed[0..used], order[0..used], scratch[0..used]);
    package_merge(n, order[0..used], len_max, lengths);
}

/// Sets the lengths of the symbols of `order`, lightest first, to the depths of their leaves in
/// Huffman's tree: the two lightest nodes join, a leaf before a joined node of the same weight,
/// until one node remains. Sets `length_counts` to how many leaves each depth holds. Returns false
/// when a depth passes `len_max`, leaving `lengths` as they were.
///
/// Moffat and Katajainen's in-place method (1995) computes the depths in one array of the weights,
/// `nodes`, lightest first, in three passes: the joins, each joined node's depth, and each leaf's.
/// A leaf is never shallower than a heavier one, as the joins take the lighter nodes first, so the
/// depths the third pass hands out from the heaviest leaf down are each leaf's own.
fn huffman_lengths(comptime n: usize, order: []const Key, nodes: []u32, len_max: u4, lengths: *[n]u8, length_counts: *LengthCounts) bool {
    assert(order.len >= coded_symbols_min and order.len <= n and nodes.len == order.len);
    weights_of(order, nodes);
    join_in_place(nodes);
    depths_in_place(nodes);
    leaf_depths_in_place(nodes, length_counts);
    // The lightest leaf is the deepest.
    if (nodes[0] > len_max) return false;
    for (order, nodes) |key, depth| lengths[symbol_of(key)] = @intCast(depth);
    return true;
}

/// The keys one vector op of `weights_of` and `max_key` takes.
const keys_vector_len = 8;

/// Sets `weights` to the weights of `keys`, `keys_vector_len` at a time: Zig 0.16 turns no loop
/// into vector code, so the vectors are written out.
fn weights_of(keys: []const Key, weights: []u32) void {
    assert(keys.len == weights.len);
    const Keys = @Vector(keys_vector_len, Key);
    var index: usize = 0;
    while (index + keys_vector_len <= keys.len) : (index += keys_vector_len) {
        weights[index..][0..keys_vector_len].* = @as(Keys, keys[index..][0..keys_vector_len].*) >> @splat(key_weight_shift);
    }
    for (keys[index..], weights[index..]) |key, *weight| weight.* = weight_of(key);
}

/// The largest of `keys`, 0 for none.
fn max_key(keys: []const Key) Key {
    const Keys = @Vector(keys_vector_len, Key);
    var maxima: Keys = @splat(0);
    var index: usize = 0;
    while (index + keys_vector_len <= keys.len) : (index += keys_vector_len) {
        maxima = @max(maxima, @as(Keys, keys[index..][0..keys_vector_len].*));
    }
    var largest = @reduce(.Max, maxima);
    for (keys[index..]) |key| largest = @max(largest, key);
    return largest;
}

/// The first pass: joined node `next` takes slot `next`, and holds its weight until a later node
/// joins it, which then leaves its parent's slot there. Leaves come from `leaf` on and joined
/// nodes from `root` on, the lighter first and a leaf on a tie.
fn join_in_place(nodes: []u32) align(constants.hot_function_alignment) void {
    const count = nodes.len;
    nodes[0] += nodes[1];
    var root: usize = 0;
    var leaf: usize = tree_arity;
    for (1..count - 1) |next| {
        // Every joined node before `next` exists, and none is `next` itself.
        assert(root < next and leaf > next);
        if (leaf >= count or nodes[root] < nodes[leaf]) {
            nodes[next] = nodes[root];
            nodes[root] = @intCast(next);
            root += 1;
        } else {
            nodes[next] = nodes[leaf];
            leaf += 1;
        }
        if (leaf >= count or (root < next and nodes[root] < nodes[leaf])) {
            assert(root < next);
            nodes[next] += nodes[root];
            nodes[root] = @intCast(next);
            root += 1;
        } else {
            nodes[next] += nodes[leaf];
            leaf += 1;
        }
    }
}

/// The second pass: each joined node's depth from its parent's, the root, the last, at 0.
fn depths_in_place(nodes: []u32) align(constants.hot_function_alignment) void {
    const count = nodes.len;
    var next = count - tree_arity;
    nodes[next] = 0;
    for (0..count - tree_arity) |_| {
        next -= 1;
        assert(nodes[next] > next);
        nodes[next] = nodes[nodes[next]] + 1;
    }
}

/// The third pass: at each depth from the root down, the nodes there that are not joined nodes are
/// leaves, which take their depth from the heaviest slot down. `length_counts` takes how many
/// leaves each depth holds, up to the longest length a code may have; a deeper leaf is the
/// caller's to refuse.
fn leaf_depths_in_place(nodes: []u32, length_counts: *LengthCounts) align(constants.hot_function_alignment) void {
    const count = nodes.len;
    length_counts.* = @splat(0);
    // Joined nodes not yet counted, from the root down, and the next leaf slot, from the end.
    var joined_left: usize = count - 1;
    var next: usize = count;
    var available: usize = 1;
    for (0..count) |depth| {
        if (available == 0) break;
        var joined: usize = 0;
        for (0..joined_left) |_| {
            if (nodes[joined_left - 1] != depth) break;
            joined += 1;
            joined_left -= 1;
        }
        assert(joined <= available and available - joined <= next);
        const leaves = available - joined;
        if (depth < length_counts.len) length_counts[depth] = @intCast(leaves);
        for (0..leaves) |_| {
            next -= 1;
            nodes[next] = @intCast(depth);
        }
        available = tree_arity * joined;
    }
    assert(next == 0 and joined_left == 0);
}

/// Sets the lengths of the symbols of `order`, lightest first, by package-merge.
fn package_merge(comptime n: usize, order: []const Key, comptime len_max: u4, lengths: *[n]u8) void {
    const used = order.len;
    // Level 0 holds the leaves alone; each level above merges them with the packages of the level
    // below, and remembers which of its items are packages.
    var packages: [len_max]std.StaticBitSet(package_arity * n) = undefined;
    var level_len: [len_max]usize = undefined;
    var below: [package_arity * n]u32 = undefined;
    var above: [package_arity * n]u32 = undefined;
    for (order, 0..) |key, index| below[index] = weight_of(key);
    packages[0] = .initEmpty();
    level_len[0] = used;
    for (1..len_max) |level| {
        level_len[level] = merge(n, order, below[0..level_len[level - 1]], &above, &packages[level]);
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
        for (order[0..leaves]) |key| lengths[symbol_of(key)] += 1;
        chosen = package_arity * (chosen - leaves);
    }
    assert(chosen == 0);
}

/// Writes into `listed` the key of each symbol that occurs, in increasing order of symbol, with
/// the first that do not occur added until there are two, still in increasing order. Returns how
/// many.
fn list_keys(comptime n: usize, counts: *const [n]u16, listed: *[n]Key) usize {
    var used: usize = 0;
    // A group of counts that are all 0 is passed by with one test, as a small block leaves most of
    // an alphabet unused.
    var base: usize = 0;
    while (base + list_group_len <= n) : (base += list_group_len) {
        const group = counts[base..][0..list_group_len];
        if (@reduce(.Or, @as(@Vector(list_group_len, u16), group.*)) == 0) continue;
        used = list_group(n, group, base, listed, used);
    }
    used = list_group(n, counts[base..], base, listed, used);
    for (counts, 0..) |count, symbol| {
        if (used >= coded_symbols_min) break;
        if (count != 0) continue;
        listed[used] = key_of(filler_weight, symbol);
        used += 1;
    }
    // A filler added after the one symbol that occurs may come before it.
    if (symbol_of(listed[0]) > symbol_of(listed[1])) std.mem.swap(Key, &listed[0], &listed[1]);
    return used;
}

/// The counts `list_keys` tests at once for any that occurs.
const list_group_len = 16;

/// Writes the keys of the symbols of `group` that occur, the first of them symbol `base`, into
/// `listed` after its first `listed_len`. Returns how many `listed` then holds. Every symbol's key
/// is written at the next slot, and only one that occurs keeps it: no branch on the counts.
inline fn list_group(comptime n: usize, group: []const u16, base: usize, listed: *[n]Key, listed_len: usize) usize {
    var used = listed_len;
    for (group, base..) |count, symbol| {
        listed[used] = key_of(count, symbol);
        used += @intFromBool(count != 0);
    }
    return used;
}

/// The values one counting pass sorts by: an octet of the weight.
const pass_buckets = 1 << @bitSizeOf(u8);

/// Writes `from`, keys in increasing order of symbol, into `to` in increasing order: lightest
/// first and by symbol among equals. A counting sort on the weight's low octet, then one on its
/// high octet when any weight has one, through `scratch`, each stable, so no compare depends on
/// the data. Each pass counts only up to the heaviest octet it sorts by, so a small block's sort
/// costs what its weights reach.
fn sort_keys(comptime n: usize, from: []const Key, to: []Key, scratch: []Key) void {
    assert(from.len == to.len and from.len == scratch.len and from.len <= n);
    if (comptime n <= insertion_sort_alphabet_len_max) return insertion_sort(from, to);
    const weight_max = weight_of(max_key(from));
    if (weight_max < pass_buckets) return counting_pass(from, to, key_weight_shift, weight_max + 1);
    counting_pass(from, scratch, key_weight_shift, pass_buckets);
    counting_pass(scratch, to, key_weight_shift + @bitSizeOf(u8), (weight_max >> @bitSizeOf(u8)) + 1);
}

/// The largest alphabet sorted by insertion rather than by counting passes: the distance code's and
/// the code length code's. Their few symbols cost fewer compares than a counting pass's buckets
/// cost to clear.
const insertion_sort_alphabet_len_max = constants.distance_used;

/// `sort_keys` by insertion: the same order, as no two keys are equal.
fn insertion_sort(from: []const Key, to: []Key) align(constants.hot_function_alignment) void {
    assert(from.len == to.len);
    for (from, 0..) |key, index| {
        var at = index;
        for (0..index) |_| {
            if (to[at - 1] < key) break;
            to[at] = to[at - 1];
            at -= 1;
        }
        to[at] = key;
    }
}

/// One stable counting pass over `bucket_count` buckets: writes `from` into `to` ordered by the
/// octet of each key `shift` bits up, equals in their order.
fn counting_pass(from: []const Key, to: []Key, shift: u5, bucket_count: usize) align(constants.hot_function_alignment) void {
    assert(from.len == to.len and bucket_count <= pass_buckets);
    var starts: [pass_buckets]u16 = undefined;
    @memset(starts[0..bucket_count], 0);
    for (from) |key| starts[bucket_of(key, shift)] += 1;
    var start: u16 = 0;
    for (starts[0..bucket_count]) |*bucket_start| {
        const bucket_len = bucket_start.*;
        bucket_start.* = start;
        start += bucket_len;
    }
    for (from) |key| {
        const bucket = bucket_of(key, shift);
        to[starts[bucket]] = key;
        starts[bucket] += 1;
    }
}

/// The octet of a key `shift` bits up.
inline fn bucket_of(key: Key, shift: u5) u8 {
    return @truncate(key >> shift);
}

/// One level of package-merge: the leaves and the packages of pairs of `below`, merged lightest
/// first, a leaf before a package of the same weight. Writes the weights into `above` and marks
/// the packages. Returns the level's length.
fn merge(comptime n: usize, order: []const Key, below: []const u32, above: *[package_arity * n]u32, packages: *std.StaticBitSet(package_arity * n)) usize {
    packages.* = .initEmpty();
    const package_count = below.len / package_arity;
    var leaf: usize = 0;
    var package: usize = 0;
    for (0..order.len + package_count) |index| {
        const package_weight = if (package < package_count) below[package_arity * package] + below[package_arity * package + 1] else std.math.maxInt(u32);
        if (leaf < order.len and weight_of(order[leaf]) <= package_weight) {
            above[index] = weight_of(order[leaf]);
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
    var counts: LengthCounts = @splat(0);
    for (lengths) |len| counts[len] += 1;
    counts[0] = 0;
    var next = first_codes(&counts);
    for (lengths, codes) |len, *reversed| {
        if (len == 0) continue;
        // RFC 1951 §3.2.2, step 3: consecutive codes for the symbols of one length, in order.
        reversed.* = reverse_bits(next[len], len);
        next[len] += 1;
    }
}

/// `build_codes` for the symbols of `listed`, keys in increasing order of symbol, which are every
/// symbol with a length, `length_counts` of each length; every other code is set to 0. A code is
/// built only for a symbol the block uses, and no branch asks which those are.
pub fn build_codes_listed(lengths: []const u8, listed: []const Key, length_counts: *const LengthCounts, codes: []u16) align(constants.hot_function_alignment) void {
    assert(lengths.len == codes.len and listed.len <= lengths.len);
    assert(length_counts[0] == 0);
    @memset(codes, 0);
    var next = first_codes(length_counts);
    for (listed) |key| {
        // RFC 1951 §3.2.2, step 3: consecutive codes for the symbols of one length, in order.
        const symbol = symbol_of(key);
        const len = lengths[symbol];
        codes[symbol] = reverse_bits(next[len], len);
        next[len] += 1;
    }
}

/// The first code of each length, for `counts` symbols of each (RFC 1951 §3.2.2, step 2).
fn first_codes(counts: *const LengthCounts) LengthCounts {
    var next: LengthCounts = @splat(0);
    var code: u16 = 0;
    for (1..constants.code_len_max + 1) |len| {
        code = (code + counts[len - 1]) << 1;
        next[len] = code;
    }
    return next;
}

/// Whether the target reverses a register's bits with one instruction, as aarch64 does.
const reverses_by_instruction = builtin.cpu.arch.isAARCH64();

/// The low `len` bits of `code`, reversed: one instruction on aarch64, and elsewhere an octet
/// table, as x86-64 has no instruction that reverses bits.
inline fn reverse_bits(code: u16, len: u8) u16 {
    const shift: u4 = @intCast(@bitSizeOf(u16) - @as(u5, @intCast(len)));
    if (reverses_by_instruction) return @bitReverse(code) >> shift;
    const reversed = (@as(u16, reversed_octets[@as(u8, @truncate(code))]) << @bitSizeOf(u8)) | reversed_octets[@as(u8, @truncate(code >> @bitSizeOf(u8)))];
    return reversed >> shift;
}

/// Each octet with its bits reversed.
const reversed_octets: [1 << @bitSizeOf(u8)]u8 = table: {
    var octets: [1 << @bitSizeOf(u8)]u8 = undefined;
    for (&octets, 0..) |*reversed, octet| reversed.* = @bitReverse(@as(u8, @intCast(octet)));
    break :table octets;
};

/// The run-length coding of a dynamic block's code lengths (RFC 1951 §3.2.7), in a file of its own.
const runs = @import("encoder_code_runs.zig");
pub const Item = runs.Item;
pub const items_max = runs.items_max;
pub const ItemCounts = runs.Counts;
pub const run_lengths = runs.run_lengths;

test {
    _ = @import("encoder_code_test.zig");
}
