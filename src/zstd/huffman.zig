//! Huffman-coded literals (RFC 8878 §4.2): a tree description's weights, read directly or
//! FSE-compressed (§4.2.1.1, §4.2.1.2); the decoding table they give (§4.2.1, §4.2.1.3); and a
//! stream decoded backward through it (§4.2.2).
//!
//! The table has 2^Max_Number_of_Bits cells. The next Max_Number_of_Bits bits of a stream, the
//! first read most significant, index the cell that names the symbol and its Number_of_Bits.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const fse = @import("fse.zig");

/// One cell: the symbol whose code begins these bits, and the code's Number_of_Bits.
pub const Entry = packed struct(u16) {
    symbol: u8,
    bits: u8,
};

pub const Table = struct {
    cells: [1 << constants.huffman_bits_max]Entry,
    /// Max_Number_of_Bits.
    bits_max: u4,
};

/// Every way a Huffman tree description or stream breaks RFC 8878 §4.2.
pub const Error = fse.Error || error{
    HuffmanTreeTruncated,
    HuffmanWeightsInvalid,
    /// The stream's last octet is 0, so it holds no final 1 bit.
    HuffmanStreamUnterminated,
    /// The literals did not read the stream exactly to its first bit.
    HuffmanStreamNotConsumed,
};

/// The weights an FSE-compressed description's table covers: 0 to `huffman_weight_max`.
const weight_symbols = constants.huffman_weight_max + 1;

/// The states that take turns decoding FSE-compressed weights (RFC 8878 §4.2.1.2).
const weight_states = 2;

/// The weights read for literals 0 up to the last present one, which is not written.
pub const Weights = struct {
    values: [constants.literal_symbols]u8,
    /// The literals whose weights were written; the last present literal is this one.
    written: u16,
};

/// Reads the Huffman_Tree_Description at the start of `octets` into `table`. Returns the octets
/// it takes (RFC 8878 §3.1.1.3.1.5).
pub fn read_tree(octets: []const u8, table: *Table) Error!usize {
    // RFC 8878 §4.2.1.1: a tree description starts with its header byte.
    if (octets.len == 0) return error.HuffmanTreeTruncated;
    const header = octets[0];
    var weights: Weights = undefined;
    const description_len = if (header < constants.huffman_direct_header_min)
        try read_compressed_weights(octets[1..], header, &weights)
    else
        try read_direct_weights(octets[1..], header - constants.huffman_direct_symbols_offset, &weights);
    try build(&weights, table);
    return 1 + description_len;
}

/// Weights written directly, 4 bits each, the first in an octet's top half (RFC 8878 §4.2.1.1).
fn read_direct_weights(octets: []const u8, count: u16, weights: *Weights) Error!usize {
    const per_octet = constants.huffman_weights_per_octet;
    const octets_len = (count + per_octet - 1) / per_octet;
    // RFC 8878 §4.2.1.1: the weights take ceiling(Number_of_Symbols / 2) octets.
    if (octets.len < octets_len) return error.HuffmanTreeTruncated;
    for (0..count) |index| {
        const octet = octets[index / per_octet];
        weights.values[index] = if (index % per_octet == 0) octet >> constants.huffman_weight_bits else octet & constants.huffman_weight_mask;
    }
    weights.written = count;
    return octets_len;
}

/// Weights FSE-compressed in `compressed_len` octets: a table description, then a backward stream
/// two states share, the first decoding the even-numbered weights (RFC 8878 §4.2.1.2).
fn read_compressed_weights(octets: []const u8, compressed_len: u8, weights: *Weights) Error!usize {
    // RFC 8878 §4.2.1.1: the FSE-compressed weights take headerByte octets.
    if (octets.len < compressed_len) return error.HuffmanTreeTruncated;
    const compressed = octets[0..compressed_len];
    var distribution: fse.Distribution = undefined;
    const description_len = try fse.read_distribution(compressed, weight_symbols, constants.huffman_weights_accuracy_log_max, &distribution);
    var table: fse.Table(constants.huffman_weights_accuracy_log_max) = undefined;
    try fse.build(constants.huffman_weights_accuracy_log_max, &table, &distribution);
    // RFC 8878 §4.2.1.2: the table description and its stream fit the compressed size.
    if (description_len > compressed.len) return error.HuffmanTreeTruncated;
    // RFC 8878 §4.2.1.2 and §4.2.2: the stream's last octet holds its final 1 bit.
    var reader = codec.BackwardBitReader.init(compressed[description_len..]) orelse return error.HuffmanWeightsInvalid;
    try decode_weights(&table, &reader, weights);
    return compressed_len;
}

/// Decodes weights with two states taking turns until a state's update reads past the stream's
/// start, which reads zeros there; the other state's symbol is then the last (RFC 8878 §4.2.1.2).
fn decode_weights(table: *const fse.Table(constants.huffman_weights_accuracy_log_max), reader: *codec.BackwardBitReader, weights: *Weights) Error!void {
    const cells = table.entries();
    // State1 is read first, then State2 (RFC 8878 §4.2.1.2).
    var states: [weight_states]usize = undefined;
    for (&states) |*state| state.* = reader.read(table.accuracy_log);
    var count: usize = 0;
    // Every weight takes a turn; at most `literal_symbols - 1` are written (RFC 8878 §4.2.1.2).
    for (0..constants.literal_symbols) |turn| {
        const current = turn % states.len;
        // RFC 8878 §4.2.1.2: at most 255 weights, as literals span 0 to 255 and the last is unwritten.
        if (count == weights.values.len - 1) return error.HuffmanWeightsInvalid;
        const cell = fse_cell(cells, states[current]);
        weights.values[count] = cell.symbol;
        count += 1;
        states[current] = @as(usize, cell.baseline) + reader.read(@intCast(cell.bits));
        if (!reader.overflowed) continue;
        weights.values[count] = fse_cell(cells, states[1 - current]).symbol;
        weights.written = @intCast(count + 1);
        return;
    }
    // RFC 8878 §4.2.1.2: the loop above ends at the 255th weight or earlier.
    return error.HuffmanWeightsInvalid;
}

/// The cell of `state`, which a state read from a table's own widths never passes.
fn fse_cell(cells: []const fse.Entry, state: usize) fse.Entry {
    assert(state < cells.len);
    return cells[state];
}

/// Builds the table the weights give: the last present literal's weight completes the sum of
/// 2^(Weight-1) to the next power of 2, which gives Max_Number_of_Bits; codes go out from the
/// lowest weight up, in literal order within a weight (RFC 8878 §4.2.1, §4.2.1.3).
pub fn build(weights: *Weights, table: *Table) Error!void {
    // RFC 8878 §4.2.1: literals 0 to 255, so at most 255 weights precede the last one.
    if (weights.written == 0 or weights.written >= constants.literal_symbols) return error.HuffmanWeightsInvalid;
    var sum: u32 = 0;
    for (weights.values[0..weights.written]) |weight| {
        // RFC 8878 §4.2.1: a weight is at most Max_Number_of_Bits, itself at most 11.
        if (weight > constants.huffman_weight_max) return error.HuffmanWeightsInvalid;
        if (weight > 0) sum += @as(u32, 1) << @intCast(weight - 1);
    }
    // RFC 8878 §4.2.1: the last literal completes a sum of at least one present weight.
    if (sum == 0) return error.HuffmanWeightsInvalid;
    const bits_max = std.math.log2_int(u32, sum) + 1;
    // RFC 8878 §4.2.1: no code is longer than 11 bits.
    if (bits_max > constants.huffman_bits_max) return error.HuffmanWeightsInvalid;
    const rest = (@as(u32, 1) << bits_max) - sum;
    // The last weight must complete the sum to a power of 2 (RFC 8878 §4.2.1).
    if (!std.math.isPowerOfTwo(rest)) return error.HuffmanWeightsInvalid;
    weights.values[weights.written] = std.math.log2_int(u32, rest) + 1;
    table.bits_max = @intCast(bits_max);
    fill(weights.values[0 .. weights.written + 1], table);
}

/// Gives each literal 2^(Weight-1) consecutive cells, the lowest weights first.
fn fill(weights: []const u8, table: *Table) void {
    var position: usize = 0;
    for (1..@as(usize, table.bits_max) + 1) |weight| {
        const cells_len = @as(usize, 1) << @intCast(weight - 1);
        const bits: u8 = @intCast(table.bits_max + 1 - weight);
        for (weights, 0..) |literal_weight, symbol| {
            if (literal_weight != weight) continue;
            @memset(table.cells[position..][0..cells_len], .{ .symbol = @intCast(symbol), .bits = bits });
            position += cells_len;
        }
    }
    assert(position == @as(usize, 1) << table.bits_max);
}

/// Decodes `output.len` literals from the Huffman-coded stream `octets`, which must end exactly at
/// its first bit (RFC 8878 §4.2.2).
pub fn decode_stream(table: *const Table, octets: []const u8, output: []u8) Error!void {
    // RFC 8878 §4.2.2: the stream's last octet holds its final 1 bit, so it is not 0.
    var reader = codec.BackwardBitReader.init(octets) orelse return error.HuffmanStreamUnterminated;
    for (output) |*literal| {
        const cell = huffman_cell(table, reader.peek(table.bits_max));
        literal.* = cell.symbol;
        reader.consume(@intCast(cell.bits));
    }
    // RFC 8878 §4.2.2: a stream not entirely and exactly consumed is faulty.
    if (!reader.finished()) return error.HuffmanStreamNotConsumed;
}

/// The cell the next `bits_max` bits index, which never pass the table's 2^`bits_max` cells.
fn huffman_cell(table: *const Table, index: u64) Entry {
    assert(index < @as(u64, 1) << table.bits_max);
    return table.cells[@intCast(index)];
}

test {
    _ = @import("huffman_test.zig");
}
