//! Huffman-coded literals (RFC 8878 §4.2): a tree description's weights, read directly or
//! FSE-compressed (§4.2.1.1, §4.2.1.2); the decoding table they give (§4.2.1, §4.2.1.3); and a
//! stream decoded backward through it (§4.2.2).
//!
//! The table has 2^Max_Number_of_Bits cells. The next Max_Number_of_Bits bits of a stream, the
//! first read most significant, index the cell that names the symbol and its Number_of_Bits.
//!
//! A tree's read is much of a small body's cost. It works in the table's scratch, which a safe
//! build does not fill as it fills an `undefined` local. FSE-compressed weights decode several to
//! an 8-octet load, each counted as it comes; then the literals are placed by weight, and the
//! shortest runs of cells go several literals to a store.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const work_module = @import("work.zig");
const Work = work_module.Work;
const fse = @import("fse.zig");
const fast_reader = @import("fast_reader.zig");

/// One cell: the code's Number_of_Bits, and the symbol whose code begins these bits. The length
/// comes first, in the low octet, so a shift by the cell's low bits uses the code.
pub const Entry = packed struct(u16) {
    bits: u8,
    symbol: u8,
};

pub const Table = struct {
    /// 2^Max_Number_of_Bits cells, then room for the last store of a fill to pass them.
    cells: [(1 << constants.huffman_bits_max) + fill_group_len]Entry,
    /// Max_Number_of_Bits.
    bits_max: u4,
    /// Invariant 17's count for the last tree read: its cells, its weights, and the cells and
    /// symbols of the FSE table that decoded them, if one did.
    work: Work,
    /// Where a tree's read works; nothing a stream's decoding reads.
    scratch: Scratch,
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

/// A weight's index into an array of 16, which holds every weight 4 bits give.
const weight_index_bits = 4;

/// The weights read for literals 0 up to the last present one, which is not written, and their
/// tally, which the table's build reads.
pub const Weights = struct {
    values: [constants.literal_symbols]u8,
    /// The literals whose weights were written; the last present literal is this one.
    written: u16,
    tally: Tally,

    /// No weight written.
    pub fn init(self: *Weights) void {
        self.written = 0;
        self.tally = .zero;
    }

    /// Writes `literal`'s weight and tallies it.
    pub fn put(self: *Weights, literal: u8, weight: u8) void {
        self.values[literal] = weight;
        self.tally.add(weight);
    }
};

/// What the table's build needs of the weights, counted as each is written: a reader keeps it in
/// a local, where no write of a weight can alias it.
pub const Tally = struct {
    /// How many of the weights take each value.
    counts: [1 << weight_index_bits]u16,
    /// The sum of 2^(Weight-1) over the weights, a weight of 0 adding none (RFC 8878 §4.2.1).
    sum: u32,

    pub const zero: Tally = .{ .counts = @splat(0), .sum = 0 };

    /// Tallies a weight, below 16 as 4 bits or the weight table's 12 symbols hold it. At most 256
    /// are tallied, so no count or sum wraps.
    pub inline fn add(self: *Tally, weight: u8) void {
        const index: u4 = @truncate(weight);
        self.counts[index] +%= 1;
        self.sum +%= (@as(u32, 1) << index) >> 1;
    }
};

/// What a tree's read works on: its weights, its literals placed by weight, and the table that
/// decodes FSE-compressed weights.
const Scratch = struct {
    weights: Weights,
    sorted: [sorted_len]u8,
    distribution: fse.Distribution,
    weight_table: WeightTable,
};

/// The bits of a place in `sorted`, which index it whole: the literals placed by weight, the place
/// past them where literals of weight 0 go, and room for a run's last load to pass them.
const sorted_index_bits = 9;
const sorted_len = 1 << sorted_index_bits;

comptime {
    assert(constants.literal_symbols + 1 + fill_group_len <= sorted_len);
    assert(constants.huffman_weight_max < 1 << weight_index_bits and @sizeOf(Entry) == @sizeOf(u16));
}

/// Reads the Huffman_Tree_Description at the start of `octets` into `table`. Returns the octets
/// it takes (RFC 8878 §3.1.1.3.1.5).
pub fn read_tree(octets: []const u8, table: *Table) Error!usize {
    // RFC 8878 §4.2.1.1: a tree description starts with its header byte.
    if (octets.len == 0) return error.HuffmanTreeTruncated;
    const header = octets[0];
    const scratch = &table.scratch;
    var weights_work = work_module.zero;
    const description_len = if (header < constants.huffman_direct_header_min)
        try read_compressed_weights(octets[1..], header, scratch, &weights_work)
    else
        try read_direct_weights(octets[1..], header - constants.huffman_direct_symbols_offset, &scratch.weights);
    try build(&scratch.weights, table);
    work_module.add(&table.work, weights_work);
    return 1 + description_len;
}

/// Weights written directly, 4 bits each, the first in an octet's top half (RFC 8878 §4.2.1.1).
fn read_direct_weights(octets: []const u8, count: u16, weights: *Weights) Error!usize {
    const per_octet = constants.huffman_weights_per_octet;
    const octets_len = (count + per_octet - 1) / per_octet;
    // RFC 8878 §4.2.1.1: the weights take ceiling(Number_of_Symbols / 2) octets.
    if (octets.len < octets_len) return error.HuffmanTreeTruncated;
    var tally: Tally = .zero;
    for (weights.values[0..count], 0..) |*weight, index| {
        const octet = octets[index / per_octet];
        weight.* = if (index % per_octet == 0) octet >> constants.huffman_weight_bits else octet & constants.huffman_weight_mask;
        tally.add(weight.*);
    }
    weights.written = count;
    weights.tally = tally;
    return octets_len;
}

/// Weights FSE-compressed in `compressed_len` octets: a table description, then a backward stream
/// two states share, the first decoding the even-numbered weights (RFC 8878 §4.2.1.2).
fn read_compressed_weights(octets: []const u8, compressed_len: u8, scratch: *Scratch, work: *Work) Error!usize {
    // RFC 8878 §4.2.1.1: the FSE-compressed weights take headerByte octets.
    if (octets.len < compressed_len) return error.HuffmanTreeTruncated;
    const compressed = octets[0..compressed_len];
    const description_len = try fse.read_distribution(compressed, weight_symbols, constants.huffman_weights_accuracy_log_max, &scratch.distribution);
    const table = &scratch.weight_table;
    try fse.build(constants.huffman_weights_accuracy_log_max, table, &scratch.distribution);
    // RFC 8878 §4.2.1.2: the table description and its stream fit the compressed size.
    if (description_len > compressed.len) return error.HuffmanTreeTruncated;
    // RFC 8878 §4.2.1.2 and §4.2.2: the stream's last octet holds its final 1 bit.
    var reader = codec.BackwardBitReader.init(compressed[description_len..]) orelse return error.HuffmanWeightsInvalid;
    // State1 is read first, then State2 (RFC 8878 §4.2.1.2).
    const state1 = reader.read(table.accuracy_log);
    const state2 = reader.read(table.accuracy_log);
    try decode_weights(table, reader.octets, .{ state1, state2 }, reader.position, reader.overflowed, &scratch.weights);
    work.* = table.work;
    return compressed_len;
}

/// The passes of `decode_weights` that write 255 weights, the most before the last.
const weight_passes_max = (constants.literal_symbols - 1) / constants.weights_per_load + 1;

comptime {
    assert(constants.weights_per_load % weight_states == 0);
}

/// Decodes weights with two states taking turns until a state's update needs more bits than the
/// stream has left, reading zeros past its start; the other state's symbol is then the last (RFC
/// 8878 §4.2.1.2). A pass decodes `constants.weights_per_load` weights from one 8-octet load,
/// which holds their bits, or all the stream has left within its first 64 bits.
fn decode_weights(table: *const WeightTable, stream: []const u8, first: [weight_states]u64, position_first: usize, overflowed: bool, weights: *Weights) Error!void {
    var states = first;
    var tally: Tally = .zero;
    // RFC 8878 §4.2.1.2: a stream that ends inside the first states ends at the first update.
    if (overflowed) {
        for (weights.values[0..weight_states], states) |*weight, state| {
            weight.* = weight_cell(table, state).symbol;
            tally.add(weight.*);
        }
        weights.written = weight_states;
        weights.tally = tally;
        return;
    }
    const head = fast_reader.head_of(stream);
    var position = position_first;
    var count: usize = 0;
    for (0..weight_passes_max) |_| {
        var word = fast_reader.leading(stream, head, position);
        inline for (0..constants.weights_per_load) |index| {
            const current = index % weight_states;
            // RFC 8878 §4.2.1.2: at most 255 weights precede the last, as literals span 0 to 255.
            if (count == constants.literal_symbols - 1) return error.HuffmanWeightsInvalid;
            const cell = weight_cell(table, states[current]);
            weights.values[@as(u8, @truncate(count))] = cell.symbol;
            tally.add(cell.symbol);
            count += 1;
            // RFC 8878 §4.2.1.2: an update that needs more bits than remain ends the weights.
            if (cell.bits > position) {
                const last = weight_cell(table, states[weight_states - 1 - current]).symbol;
                weights.values[@as(u8, @truncate(count))] = last;
                tally.add(last);
                weights.written = @intCast(count + 1);
                weights.tally = tally;
                return;
            }
            // The cell's bits lead the word; a cell of none reads none, whatever the shift.
            const bits: u6 = @truncate(cell.bits);
            states[current] = cell.baseline + ((word >> 1) >> ~bits);
            word <<= bits;
            position -= cell.bits;
        }
    }
    // Each pass writes `weights_per_load` weights, so the count reaches 255 within the passes.
    unreachable;
}

/// The table that decodes FSE-compressed weights.
const WeightTable = fse.Table(constants.huffman_weights_accuracy_log_max);

/// The cell of `state`, which a state read from the table's own widths never passes: below its 2^6
/// cells, so the truncation changes none, and a cell's bits are at most 6.
fn weight_cell(table: *const WeightTable, state: u64) fse.Entry {
    return table.cells[@as(std.math.Log2Int(@TypeOf(table.cells.len)), @truncate(state))];
}

/// Builds the table the weights give: the last present literal's weight completes the sum of
/// 2^(Weight-1) to the next power of 2, which gives Max_Number_of_Bits; codes go out from the
/// lowest weight up, in literal order within a weight (RFC 8878 §4.2.1, §4.2.1.3).
pub fn build(weights: *Weights, table: *Table) Error!void {
    // RFC 8878 §4.2.1: literals 0 to 255, so at most 255 weights precede the last one.
    if (weights.written == 0 or weights.written >= constants.literal_symbols) return error.HuffmanWeightsInvalid;
    // RFC 8878 §4.2.1: the last literal completes a sum of at least one present weight.
    if (weights.tally.sum == 0) return error.HuffmanWeightsInvalid;
    const bits_max = std.math.log2_int(u32, weights.tally.sum) + 1;
    // RFC 8878 §4.2.1: no code is longer than 11 bits, and no weight passes Max_Number_of_Bits. A
    // weight adds 2^(Weight-1) to the sum, so one past 11 alone gives a sum past 2^11, and none
    // passes Max_Number_of_Bits, whose power of 2 the sum is below.
    if (bits_max > constants.huffman_bits_max) return error.HuffmanWeightsInvalid;
    const rest = (@as(u32, 1) << bits_max) - weights.tally.sum;
    // The last weight must complete the sum to a power of 2 (RFC 8878 §4.2.1).
    if (!std.math.isPowerOfTwo(rest)) return error.HuffmanWeightsInvalid;
    weights.put(@intCast(weights.written), std.math.log2_int(u32, rest) + 1);
    table.bits_max = @intCast(bits_max);
    try fill(weights, table);
    table.work = work_module.of((@as(usize, 1) << table.bits_max) + weights.written + 1);
}

/// Gives each literal 2^(Weight-1) consecutive cells, the lowest weights first and literal order
/// within a weight (RFC 8878 §4.2.1): the literals placed by weight, then each weight's cells
/// filled in turn, which the table's longest code bounds.
fn fill(weights: *const Weights, table: *Table) Error!void {
    // RFC 8878 §4.2.1: Max_Number_of_Bits is the tree's depth, which only literals of weight 1 reach.
    if (weights.tally.counts[1] == 0) return error.HuffmanWeightsInvalid;
    const sorted = &table.scratch.sorted;
    place_by_weight(weights, sorted);
    const cells: *[table.cells.len]u16 = @ptrCast(&table.cells);
    var cell: usize = 0;
    var first: usize = 0;
    // A weight past Max_Number_of_Bits has no literal, so its wrapped length writes nothing.
    inline for (1..constants.huffman_weight_max + 1) |weight| {
        const count = weights.tally.counts[weight];
        fill_weight(weight, cells[cell..], sorted[first..], count, @as(u8, table.bits_max) +% 1 -% @as(u8, weight));
        cell += @as(usize, count) << (weight - 1);
        first += count;
    }
    assert(cell == @as(usize, 1) << table.bits_max);
}

/// Places the literals by weight, from weight 1 up, in literal order within one (RFC 8878
/// §4.2.1.3): each weight's first place is the count of the lighter ones. A literal of weight 0
/// goes to the one place past them all, which nothing reads, so no literal takes a branch.
fn place_by_weight(weights: *const Weights, sorted: *[sorted_len]u8) void {
    var places: [1 << weight_index_bits]u16 = @splat(constants.literal_symbols);
    var place: u16 = 0;
    for (places[1..], weights.tally.counts[1..]) |*first, count| {
        first.* = place;
        place +%= count;
    }
    // At most 256 literals take places, each below `sorted_len`, and a literal is below 256.
    for (weights.values[0 .. weights.written + 1], 0..) |weight, literal| {
        const index: u4 = @truncate(weight);
        sorted[@as(std.meta.Int(.unsigned, sorted_index_bits), @truncate(places[index]))] = @truncate(literal);
        places[index] +%= @intFromBool(weight != 0);
    }
}

/// The cells one store of a fill writes: 8, 16 octets.
const fill_group_len = 8;

/// Fills the cells of the `count` literals of `weight` in `literals`: 2^(Weight-1) each, naming
/// the literal and its code's `bits`. A literal of a run shorter than a store shares its store with
/// the next; the last store may pass the weight's cells by fewer than a store's, into the next
/// weight's, which it fills after, or into the table's room past its cells.
inline fn fill_weight(comptime weight: usize, cells: []u16, literals: []const u8, count: usize, bits: u8) void {
    const run_len = 1 << (weight - 1);
    if (run_len < fill_group_len) {
        const per_store = fill_group_len / run_len;
        const Group = @Vector(per_store, u16);
        for (0..std.math.divCeil(usize, count, per_store) catch unreachable) |store| {
            const group: @Vector(per_store, u8) = literals[store * per_store ..][0..per_store].*;
            const entries = @as(Group, group) << @splat(@bitSizeOf(u8)) | @as(Group, @splat(bits));
            cells[store * fill_group_len ..][0..fill_group_len].* = @shuffle(u16, entries, undefined, run_mask(per_store));
        }
        return;
    }
    for (literals[0..count], 0..) |literal, index| {
        const entry: u16 = @as(u16, literal) << @bitSizeOf(u8) | bits;
        const store: [fill_group_len]u16 = @splat(entry);
        const run = cells[index * run_len ..][0..run_len];
        for (0..run_len / fill_group_len) |group| run[group * fill_group_len ..][0..fill_group_len].* = store;
    }
}

/// The shuffle that repeats each of a store's `per_store` entries over its run of cells.
fn run_mask(comptime per_store: usize) @Vector(fill_group_len, i32) {
    var mask: [fill_group_len]i32 = undefined;
    for (&mask, 0..) |*lane, cell| lane.* = @intCast(cell / (fill_group_len / per_store));
    return mask;
}

/// Decodes `output.len` literals from the Huffman-coded stream `octets`, which must end exactly at
/// its first bit (RFC 8878 §4.2.2).
pub fn decode_stream(table: *const Table, octets: []const u8, output: []u8) Error!void {
    // RFC 8878 §4.2.2: the stream's last octet holds its final 1 bit, so it is not 0.
    var reader = codec.BackwardBitReader.init(octets) orelse return error.HuffmanStreamUnterminated;
    return decode_rest(table, &reader, output);
}

/// Decodes `output.len` literals from `reader`, where a fast path may have left it, then requires
/// the stream to end exactly at its first bit (RFC 8878 §4.2.2).
pub fn decode_rest(table: *const Table, reader: *codec.BackwardBitReader, output: []u8) Error!void {
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
