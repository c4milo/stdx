//! FSE encoding (RFC 8878 §4.1): a normalized distribution for a symbol's counts, its table
//! description (§4.1.1), and the states that encode symbols in the reverse of the order a decoder
//! reads them.
//!
//! The states come from the decoder's own table, which `fse.build` gives. A symbol of probability
//! p holds, in table order, the states p to 2p - 1, and a state σ reads Accuracy_Log - floor(log2
//! σ) bits to reach the next. An encoder state x lies from 2^Accuracy_Log to twice that. Shifted
//! right until it lies from p to 2p - 1, it names the cell of state σ, and the bits shifted out are
//! the bits the decoder reads at σ to return to x.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("../constants.zig");
const fse = @import("../fse.zig");

/// The block buffer filled before the block did: the block goes out raw instead.
pub const Error = error{NoSpaceLeft};

/// Sets `distribution` to probabilities for `counts` over 2^`accuracy_log` points: every symbol
/// that occurs takes at least 1, and the most frequent symbol takes what rounding leaves over or
/// short. Ties go to the lower symbol, so the probabilities are a function of the counts alone
/// (invariant 5). `total` is the sum of `counts`, and two or more symbols occur.
pub fn normalize(counts: []const u32, total: u32, accuracy_log: u4, distribution: *fse.Distribution) void {
    assert(counts.len <= fse.symbols_max and total > 0);
    const scale = @as(u64, 1) << accuracy_log;
    var sum: u32 = 0;
    var largest: usize = 0;
    var last: usize = 0;
    for (counts, 0..) |count, symbol| {
        if (count == 0) {
            distribution.probabilities[symbol] = 0;
            continue;
        }
        const rounded = (@as(u64, count) * scale + (total >> 1)) / total;
        const probability: u32 = @intCast(@max(1, rounded));
        distribution.probabilities[symbol] = @intCast(probability);
        sum += probability;
        if (count > counts[largest]) largest = symbol;
        last = symbol;
    }
    distribution.symbol_count = @intCast(last + 1);
    distribution.accuracy_log = accuracy_log;
    settle(distribution, sum, @intCast(scale), largest);
}

/// Brings the probabilities' sum to `scale`: the most frequent symbol takes a shortfall, and an
/// excess comes off the largest probabilities, one symbol at a time, none below 1.
fn settle(distribution: *fse.Distribution, sum_first: u32, scale: u32, largest: usize) void {
    const probabilities = distribution.probabilities[0..distribution.symbol_count];
    if (sum_first <= scale) {
        probabilities[largest] += @intCast(scale - sum_first);
        return;
    }
    var excess = sum_first - scale;
    // Each round takes from the largest probability all it can spare, so the rounds end within one
    // per symbol: the probabilities above 1 hold more than the excess while it lasts.
    for (0..probabilities.len) |_| {
        if (excess == 0) return;
        var top: usize = 0;
        for (probabilities, 0..) |probability, symbol| {
            if (probability > probabilities[top]) top = symbol;
        }
        assert(probabilities[top] > 1);
        const taken = @min(excess, @as(u32, @intCast(probabilities[top] - 1)));
        probabilities[top] -= @intCast(taken);
        excess -= taken;
    }
    assert(excess == 0);
}

/// The accuracy log for `present` symbols over `total` counts: about a quarter of the counts'
/// magnitude, at least `constants.accuracy_log_offset`, and enough points for every symbol to
/// take two, at most `accuracy_log_max`.
pub fn accuracy_log_for(total: u32, present: usize, accuracy_log_max: u4) u4 {
    assert(present >= constants.fse_symbols_present_min and total > 0);
    const symbols_log = std.math.log2_int_ceil(usize, present) + 1;
    const counts_log: usize = std.math.log2_int(u32, total) -| constants.fse_counts_log_drop;
    const wanted = @max(@as(usize, constants.accuracy_log_offset), @max(symbols_log, counts_log));
    assert(symbols_log <= accuracy_log_max);
    return @intCast(@min(wanted, accuracy_log_max));
}

/// Writes `distribution` as RFC 8878 §4.1.1 describes it, least significant bit first, and pads
/// the description to a whole octet.
pub fn write_distribution(writer: *codec.BitWriter, distribution: *const fse.Distribution) Error!void {
    const probabilities = distribution.probabilities[0..distribution.symbol_count];
    try put(writer, distribution.accuracy_log - constants.accuracy_log_offset, constants.accuracy_log_field_bits);
    var left: u32 = @as(u32, 1) << distribution.accuracy_log;
    var symbol: usize = 0;
    for (0..probabilities.len) |_| {
        if (left == 0) break;
        const probability = probabilities[symbol];
        try put_value(writer, @intCast(probability + 1), left);
        left -= if (probability < 0) 1 else @intCast(probability);
        symbol += 1;
        if (probability == 0) symbol = try put_zeros(writer, probabilities, symbol);
    }
    // RFC 8878 §4.1.1: the description consumes a round number of octets.
    try put(writer, 0, writer.bits_to_octet());
}

/// After a probability of zero, the 2-bit repeat flags of the zeros that follow it: each names
/// up to 3, and a 3 says another flag follows (RFC 8878 §4.1.1). Returns the next symbol.
fn put_zeros(writer: *codec.BitWriter, probabilities: []const i16, first: usize) Error!usize {
    var zeros: usize = 0;
    for (probabilities[first..]) |probability| {
        if (probability != 0) break;
        zeros += 1;
    }
    const more = constants.fse_repeat_flag_more;
    for (0..zeros / more + 1) |round| {
        const flag = @min(zeros - round * more, more);
        try put(writer, flag, constants.fse_repeat_flag_bits);
    }
    return first + zeros;
}

/// One probability's Value, when `left` points of the table remain to give: values below a
/// threshold in one bit fewer, as RFC 8878 §4.1.1's Table 20 reads them.
fn put_value(writer: *codec.BitWriter, value: u32, left: u32) Error!void {
    const value_max = left + 1;
    const width: u7 = std.math.log2_int(u32, value_max) + 1;
    const threshold = (@as(u32, 1) << @intCast(width)) - 1 - value_max;
    if (value < threshold) return put(writer, value, width - 1);
    if (value < @as(u32, 1) << @intCast(width - 1)) return put(writer, value, width);
    return put(writer, value + threshold, width);
}

fn put(writer: *codec.BitWriter, value: u64, count: u7) Error!void {
    if (!writer.make_room(count)) return error.NoSpaceLeft;
    writer.put(value, count);
}

/// The states that encode the symbols of one distribution, of up to 2^`log_max` cells and
/// `symbol_limit` symbols.
pub fn EncodeTable(comptime log_max: u4, comptime symbol_limit: usize) type {
    return struct {
        const Self = @This();

        accuracy_log: u4,
        /// Every cell's index, its symbol's cells together in table order, symbol by symbol.
        cells: [1 << log_max]u16,
        /// Where each symbol's cells start in `cells`.
        starts: [symbol_limit]u16,
        /// Each symbol's probability, a "less than 1" taken as 1, as the decoder's states take it.
        probabilities: [symbol_limit]u16,

        /// Builds the states of `distribution` from the decoder's table of it.
        pub fn build(self: *Self, distribution: *const fse.Distribution, scratch: *fse.Table(log_max)) void {
            build_table(log_max, self, distribution, scratch);
        }

        /// The state the last symbol encoded ends in: its cell of the lowest state, which reads at
        /// least one bit, as the end of a Huffman weight stream needs (RFC 8878 §4.2.1.2).
        pub fn first_state(self: *const Self, symbol: u8) u32 {
            assert(self.probabilities[symbol] > 0);
            return (@as(u32, 1) << self.accuracy_log) + self.cells[self.starts[symbol]];
        }

        /// The bits that move `state` back to the state before it, and the cell of `symbol` that
        /// state is. The caller writes the bits, the low `.count` of `.value`.
        pub inline fn step(self: *const Self, state: *u32, symbol: u8) Step {
            return step_state(self, state, symbol);
        }

        /// The state's cell, which the decoder reads first, in `accuracy_log` bits.
        pub fn final_value(self: *const Self, state: u32) u32 {
            return state - (@as(u32, 1) << self.accuracy_log);
        }

        /// The bits, in 1/256ths, that `counts` take under this table: each symbol about
        /// Accuracy_Log - log2(probability) bits. Null when a symbol that occurs has no cell.
        pub fn cost(self: *const Self, counts: []const u32) ?u64 {
            return cost_of(self, counts);
        }
    };
}

/// The bits one encoded symbol writes: the low `count` bits of `value`.
pub const Step = struct { value: u32, count: u5 };

fn build_table(comptime log_max: u4, self: anytype, distribution: *const fse.Distribution, scratch: *fse.Table(log_max)) void {
    const symbol_limit = self.probabilities.len;
    assert(distribution.symbol_count <= symbol_limit);
    assert(distribution.accuracy_log <= log_max);
    fse.build(log_max, scratch, distribution) catch unreachable;
    self.accuracy_log = distribution.accuracy_log;
    var start: u16 = 0;
    for (&self.probabilities, &self.starts, 0..) |*probability, *symbol_start, symbol| {
        const given = if (symbol < distribution.symbol_count) distribution.probabilities[symbol] else 0;
        probability.* = if (given < 0) 1 else @intCast(given);
        symbol_start.* = start;
        start += probability.*;
    }
    assert(start == @as(u32, 1) << self.accuracy_log);
    var placed = self.starts;
    for (scratch.entries(), 0..) |entry, cell| {
        self.cells[placed[entry.symbol]] = @intCast(cell);
        placed[entry.symbol] += 1;
    }
}

inline fn step_state(self: anytype, state: *u32, symbol: u8) Step {
    const probability: u32 = self.probabilities[symbol];
    assert(probability > 0);
    const floor_log = std.math.log2_int(u32, probability);
    var count: u5 = @intCast(@as(u32, self.accuracy_log) - floor_log);
    if (state.* < probability << count) count -= 1;
    const value = state.* & ((@as(u32, 1) << count) - 1);
    const rank = (state.* >> count) - probability;
    state.* = (@as(u32, 1) << self.accuracy_log) + self.cells[self.starts[symbol] + rank];
    return .{ .value = value, .count = count };
}

fn cost_of(self: anytype, counts: []const u32) ?u64 {
    var bits: u64 = 0;
    for (counts, 0..) |count, symbol| {
        if (count == 0) continue;
        if (symbol >= self.probabilities.len or self.probabilities[symbol] == 0) return null;
        bits += count * symbol_cost(self.accuracy_log, self.probabilities[symbol]);
    }
    return bits;
}

/// log2 of 1 to 2^`constants.accuracy_log_max`, in 1/256ths of a bit, computed at comptime.
const log2_fractions = blk: {
    @setEvalBranchQuota(constants.cost_table_eval_quota);
    var table: [(1 << constants.accuracy_log_max) + 1]u16 = undefined;
    table[0] = 0;
    for (table[1..], 1..) |*entry, value| {
        entry.* = @intFromFloat(@round(std.math.log2(@as(f64, @floatFromInt(value))) * constants.cost_fraction));
    }
    break :blk table;
};

/// The bits, in 1/256ths, one symbol of `probability` takes in a table of `accuracy_log`.
pub fn symbol_cost(accuracy_log: u4, probability: u32) u32 {
    assert(probability > 0 and probability <= @as(u32, 1) << accuracy_log);
    return @as(u32, accuracy_log) * constants.cost_fraction - log2_fractions[probability];
}

test {
    _ = @import("encoder_fse_test.zig");
}
