//! Huffman-coded literals (RFC 8878 §4.2): code lengths for a block's literal counts, at most 11
//! bits long; the prefix codes §4.2.1.3 assigns them; the tree description (§4.2.1), its weights
//! direct or FSE-compressed, whichever is shorter; and the streams, written so that a decoder
//! reads them backward (§4.2.2).
//!
//! The lengths are the depths of Huffman's tree over the sorted counts. When a depth passes 11,
//! the deep leaves come up to 11, and the shallowest leaves under 11 go down a level until the
//! code's Kraft sum is whole again. Every tie breaks by symbol, so the codes are a function of the
//! counts alone (invariant 5).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const fse = @import("../fse.zig");
const encoder_fse = @import("encoder_fse.zig");

pub const Error = encoder_fse.Error;

/// The symbols of a literal alphabet, and the deepest code (RFC 8878 §4.2.1).
const symbols = constants.literal_symbols;
const bits_max = constants.huffman_bits_max;

/// The weights an FSE description covers: 0 to 11.
const weight_symbols = constants.huffman_weight_max + 1;

/// The children a node of Huffman's tree joins: a code of bits is binary.
const tree_arity = 2;

/// The nodes of Huffman's tree over every literal: the leaves, and one fewer joined nodes.
const tree_nodes_max = tree_arity * symbols;

/// The states that take turns over FSE-compressed weights (RFC 8878 §4.2.1.2).
const weight_states = 2;

/// A code: each literal's length, 0 for one that does not occur, and its prefix code.
pub const Code = struct {
    lengths: [symbols]u8,
    codes: [symbols]u16,
    /// Max_Number_of_Bits: the longest length.
    bits_max: u4,
    /// The last literal that occurs, whose weight the description leaves out.
    last: u8,
};

/// Sets `code` to the code of least coded size under 11 bits that the repair finds for `counts`,
/// where two literals or more occur.
pub fn build(counts: *const [symbols]u32, code: *Code) void {
    var order: [symbols]u16 = undefined;
    const used = sort_literals(counts, &order);
    assert(used >= constants.fse_symbols_present_min);
    @memset(&code.lengths, 0);
    var depths: [tree_nodes_max]u8 = undefined;
    tree_depths(counts, order[0..used], &depths);
    for (order[0..used], depths[0..used]) |literal, depth| code.lengths[literal] = depth;
    limit_lengths(code, order[0..used]);
    assign_codes(code, @intCast(std.mem.max(u16, order[0..used])));
}

/// Lists the literals that occur in `order`, lightest first, ties by literal. Returns how many.
fn sort_literals(counts: *const [symbols]u32, order: *[symbols]u16) usize {
    var used: usize = 0;
    for (counts, 0..) |count, literal| {
        if (count == 0) continue;
        order[used] = @intCast(literal);
        used += 1;
    }
    const Context = struct {
        counts: *const [symbols]u32,
        fn lighter(context: @This(), left: u16, right: u16) bool {
            const left_count = context.counts[left];
            const right_count = context.counts[right];
            return left_count < right_count or (left_count == right_count and left < right);
        }
    };
    std.sort.pdq(u16, order[0..used], Context{ .counts = counts }, Context.lighter);
    return used;
}

/// The depth of each leaf of Huffman's tree over the literals of `order`, lightest first, into
/// `depths` in the same order. Two queues join the two lightest nodes, a leaf before a joined
/// node of the same weight.
fn tree_depths(counts: *const [symbols]u32, order: []const u16, depths: *[tree_nodes_max]u8) void {
    const leaves = order.len;
    var weights: [tree_nodes_max]u64 = undefined;
    var parents: [tree_nodes_max]u16 = undefined;
    for (order, weights[0..leaves]) |literal, *weight| weight.* = counts[literal];
    var leaf: usize = 0;
    var joined: usize = leaves;
    const root = tree_arity * leaves - tree_arity;
    for (leaves..root + 1) |node| {
        var children: [tree_arity]usize = undefined;
        for (&children) |*child| {
            const take_leaf = leaf < leaves and (joined == node or weights[leaf] <= weights[joined]);
            if (take_leaf) {
                child.* = leaf;
                leaf += 1;
            } else {
                child.* = joined;
                joined += 1;
            }
        }
        weights[node] = weights[children[0]] + weights[children[1]];
        parents[children[0]] = @intCast(node);
        parents[children[1]] = @intCast(node);
    }
    depths[root] = 0;
    var node = root;
    for (0..root) |_| {
        node -= 1;
        depths[node] = depths[parents[node]] + 1;
    }
}

/// Brings every length to at most 11 and keeps the code whole: Σ 2^(11 - length) equal to 2^11.
fn limit_lengths(code: *Code, order: []const u16) void {
    const whole: u32 = 1 << bits_max;
    var sum: u32 = 0;
    for (order) |literal| {
        code.lengths[literal] = @min(code.lengths[literal], bits_max);
        sum += whole >> @intCast(code.lengths[literal]);
    }
    // Too long a code: the deepest leaves under 11, lightest first, go down a level, each
    // taking 2^(10 - length) off the sum. Each round takes at least 1, so the sum comes down.
    for (0..whole) |_| {
        if (sum <= whole) break;
        const literal = deepest_under_max(code, order);
        sum -= whole >> @intCast(code.lengths[literal] + 1);
        code.lengths[literal] += 1;
    }
    // A code with room left: the heaviest leaves whose rise fits the room come up a level.
    for (0..whole) |_| {
        if (sum == whole) break;
        const literal = heaviest_fitting(code, order, whole - sum);
        sum += whole >> @intCast(code.lengths[literal]);
        code.lengths[literal] -= 1;
    }
    assert(sum == whole);
}

/// The lightest literal of the greatest length under 11.
fn deepest_under_max(code: *const Code, order: []const u16) u16 {
    var best: ?u16 = null;
    for (order) |literal| {
        const length = code.lengths[literal];
        if (length >= bits_max) continue;
        if (best == null or length > code.lengths[best.?]) best = literal;
    }
    return best.?;
}

/// The heaviest literal whose length, one shorter, adds no more than `room` to the sum.
fn heaviest_fitting(code: *const Code, order: []const u16, room: u32) u16 {
    var index = order.len;
    for (0..order.len) |_| {
        index -= 1;
        const literal = order[index];
        const length = code.lengths[literal];
        if (length > 1 and (@as(u32, 1) << bits_max) >> @intCast(length) <= room) return literal;
    }
    unreachable;
}

/// The prefix codes of RFC 8878 §4.2.1.3: from the lowest weight up, literal order within a
/// weight, each code the one after the last, halved at each step up a weight. One pass counts the
/// literals of each length, from which each length's first code follows; a second gives each
/// literal the next code of its length. Both stop at `last`, the last literal that occurs.
fn assign_codes(code: *Code, last: u8) void {
    var length_counts: [bits_max + 1]u32 = @splat(0);
    for (code.lengths[0 .. @as(usize, last) + 1]) |length| length_counts[length] += 1;
    assert(code.lengths[last] != 0);
    var longest: u8 = 0;
    for (length_counts[1..], 1..) |count, length| {
        if (count > 0) longest = @intCast(length);
    }
    code.bits_max = @intCast(longest);
    code.last = last;
    var next_codes: [bits_max + 1]u32 = @splat(0);
    var next: u32 = 0;
    var length = longest;
    for (0..longest) |_| {
        next_codes[length] = next;
        next += length_counts[length];
        assert(next % tree_arity == 0 or length == 1);
        next /= tree_arity;
        length -= 1;
    }
    for (code.lengths[0 .. @as(usize, last) + 1], code.codes[0 .. @as(usize, last) + 1]) |literal_length, *prefix| {
        prefix.* = @intCast(next_codes[literal_length]);
        next_codes[literal_length] += 1;
    }
}

/// The weight of a literal of `length`: Max_Number_of_Bits + 1 - Number_of_Bits, 0 for none.
fn weight_of(code: *const Code, length: u8) u8 {
    return if (length == 0) 0 else code.bits_max + 1 - length;
}

/// The octets the coded literals take: their codes' bits, and the final 1 bit, per stream.
pub fn streams_len(code: *const Code, counts: *const [symbols]u32, stream_count: usize) usize {
    const lanes_len = constants.literal_sum_lanes;
    const Lanes = @Vector(lanes_len, u32);
    var bits: Lanes = @splat(0);
    for (0..symbols / lanes_len) |step| {
        const lane_counts: Lanes = counts[step * lanes_len ..][0..lanes_len].*;
        const lane_lengths: @Vector(lanes_len, u8) = code.lengths[step * lanes_len ..][0..lanes_len].*;
        // The counts sum to a block's literals at most, each of at most 11 bits: no lane wraps.
        bits +%= lane_counts *% @as(Lanes, lane_lengths);
    }
    // Each stream adds its final bit and rounds up to an octet.
    return @as(usize, @reduce(.Add, bits)) / @bitSizeOf(u8) + stream_count;
}

/// The scratch of a description's FSE-compressed weights.
pub const Scratch = struct {
    table: encoder_fse.EncodeTable(constants.huffman_weights_accuracy_log_max, weight_symbols),
    decoder_table: fse.Table(constants.huffman_weights_accuracy_log_max),
    compressed: [constants.huffman_direct_header_min]u8,
};

/// Writes the Huffman_Tree_Description of `code` (RFC 8878 §4.2.1): the FSE-compressed weights
/// where they take fewer octets, else the direct ones. Fails where neither fits: more than 128
/// weights that FSE cannot take, which the caller writes as raw literals instead.
pub fn write_tree(writer: *codec.Writer, code: *const Code, scratch: *Scratch) Error!void {
    var weights: [symbols]u8 = undefined;
    const count: usize = code.last;
    for (weights[0..count], code.lengths[0..count]) |*weight, length| weight.* = weight_of(code, length);
    const compressed_len = compress_weights(weights[0..count], scratch);
    const direct_len = if (count <= constants.huffman_direct_symbols_max) (count + 1) / constants.huffman_weights_per_octet else null;
    if (compressed_len) |len| {
        if (direct_len == null or len < direct_len.?) {
            // RFC 8878 §4.2.1.1: a header below 128 is the length of the FSE-compressed weights.
            try writer.write_octet(@intCast(len));
            return writer.write_all(scratch.compressed[0..len]);
        }
    }
    if (direct_len == null) return error.NoSpaceLeft;
    // RFC 8878 §4.2.1.1: a header of 128 or more gives Number_of_Symbols + 127, then the weights
    // 4 bits each, the first in an octet's top half.
    try writer.write_octet(@intCast(count + constants.huffman_direct_symbols_offset));
    var index: usize = 0;
    for (0..direct_len.?) |_| {
        const high = weights[index];
        const low = if (index + 1 < count) weights[index + 1] else 0;
        try writer.write_octet(high << constants.huffman_weight_bits | low);
        index += constants.huffman_weights_per_octet;
    }
}

/// Compresses `weights` into `scratch.compressed` with two states taking turns (RFC 8878
/// §4.2.1.2). Returns its length, or null where the weights take fewer than two values or the
/// result passes 127 octets.
fn compress_weights(weights: []const u8, scratch: *Scratch) ?usize {
    var counts: [weight_symbols]u32 = @splat(0);
    for (weights) |weight| counts[weight] += 1;
    var present: usize = 0;
    for (counts) |count| present += @intFromBool(count > 0);
    if (present < constants.fse_symbols_present_min) return null;
    const accuracy_log = encoder_fse.accuracy_log_for(@intCast(weights.len), present, constants.huffman_weights_accuracy_log_max);
    var distribution: fse.Distribution = undefined;
    encoder_fse.normalize(&counts, @intCast(weights.len), accuracy_log, &distribution);
    scratch.table.build(&distribution, &scratch.decoder_table);
    var writer = codec.BitWriter.init(scratch.compressed[0 .. scratch.compressed.len - 1], .{});
    encoder_fse.write_distribution(&writer, &distribution) catch return null;
    write_weight_states(&writer, &scratch.table, weights) catch return null;
    if (!writer.drain()) return null;
    return writer.writer.position;
}

/// The weights' backward stream: State1 decodes the even weights and State2 the odd ones. The
/// update after the second-to-last weight must need more bits than remain, which its cell of
/// lowest state does, and then the other state's weight is the last (RFC 8878 §4.2.1.2).
fn write_weight_states(writer: *codec.BitWriter, table: anytype, weights: []const u8) Error!void {
    const count = weights.len;
    assert(count >= weight_states);
    var states: [weight_states]u32 = undefined;
    for (count - weight_states..count) |last| states[last % weight_states] = table.first_state(weights[last]);
    var index = count - weight_states;
    for (0..count - weight_states) |_| {
        index -= 1;
        const bits = table.step(&states[index % weight_states], weights[index]);
        try put(writer, bits.value, bits.count);
    }
    // State1 is read first, so it is written last.
    try put(writer, table.final_value(states[1]), table.accuracy_log);
    try put(writer, table.final_value(states[0]), table.accuracy_log);
    try put_final_bit(writer);
}

/// Writes `literals` as one Huffman-coded stream: codes from the last literal to the first, then
/// the final 1 bit, so a decoder reads them backward in order (RFC 8878 §4.2.2).
pub fn write_stream(writer: *codec.BitWriter, code: *const Code, literals: []const u8) Error!void {
    var index = literals.len;
    // A store leaves at most 7 bits, and five codes of at most 11 bits fit the 57 above them.
    if (!writer.drain()) return error.NoSpaceLeft;
    const batch = constants.huffman_codes_per_store;
    for (0..literals.len / batch) |_| {
        if (!writer.has_store_room()) break;
        // The batch's codes joined, the first in the low bits, go into the buffer in one put.
        var value: u64 = 0;
        var count: u7 = 0;
        inline for (0..batch) |_| {
            index -= 1;
            const literal = literals[index];
            value |= @as(u64, code.codes[literal]) << @intCast(count);
            count += @intCast(code.lengths[literal]);
        }
        writer.put(value, count);
        writer.store();
    }
    for (0..index) |_| {
        index -= 1;
        const literal = literals[index];
        try put(writer, code.codes[literal], @intCast(code.lengths[literal]));
    }
    try put_final_bit(writer);
}

/// The final 1 bit, then zeros to the octet's end (RFC 8878 §4.2.2).
pub fn put_final_bit(writer: *codec.BitWriter) Error!void {
    try put(writer, 1, 1);
    try put(writer, 0, writer.bits_to_octet());
    if (!writer.drain()) return error.NoSpaceLeft;
}

fn put(writer: *codec.BitWriter, value: u64, count: u7) Error!void {
    if (!writer.make_room(count)) return error.NoSpaceLeft;
    writer.put(value, count);
}

test {
    _ = @import("encoder_huffman_test.zig");
}
