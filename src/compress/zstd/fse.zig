//! FSE decoding tables (RFC 8878 §4.1): reading a table description (§4.1.1), building the table
//! a distribution gives, and the tables of the default distributions, built at comptime (§3.1.1.3.2.2,
//! decision 14's Z3).
//!
//! A table has 2^Accuracy_Log cells. Each names the symbol its state decodes and how to reach the
//! next state: read Number_of_Bits bits and add Baseline (§4.1).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");
const work_module = @import("work.zig");
const fast_reader = @import("fast_reader.zig");
const Work = work_module.Work;

/// One cell: the symbol a state decodes, and the bits and Baseline that give the next state.
pub const Entry = packed struct(u32) {
    symbol: u8,
    bits: u8,
    baseline: u16,
};

/// A decoding table of up to 2^`log_max` cells.
pub fn Table(comptime log_max: u4) type {
    return struct {
        cells: [1 << log_max]Entry,
        accuracy_log: u4,
        /// Invariant 17's count for the last build: its cells and its distribution's symbols.
        work: Work,

        pub fn entries(self: *const @This()) []const Entry {
            return self.cells[0 .. @as(usize, 1) << self.accuracy_log];
        }
    };
}

/// The most symbols a distribution describes: a Huffman weight table covers weights 0 to 11, and
/// the largest sequence alphabet, match length codes, has 53.
pub const symbols_max = constants.match_length_symbols;

/// A normalized distribution: each symbol's probability, -1 meaning "less than 1" (§4.1.1).
pub const Distribution = struct {
    probabilities: [symbols_max]i16,
    symbol_count: u16,
    accuracy_log: u4,
};

/// Every way a table description breaks RFC 8878 §4.1.1.
pub const Error = error{
    FseAccuracyLogTooLarge,
    FseDistributionInvalid,
    FseDescriptionTruncated,
};

/// The branches comptime may take building a default table: every cell's spread and baseline.
const default_table_eval_quota = 100_000;

/// Reads the distribution the description at the start of `octets` gives, for an alphabet of
/// `symbol_limit` symbols and an accuracy log of at most `accuracy_log_max`. Returns the octets
/// the description takes: a round number, whatever the last one leaves unused (RFC 8878 §4.1.1).
pub fn read_distribution(octets: []const u8, symbol_limit: u16, accuracy_log_max: u4, distribution: *Distribution) Error!usize {
    assert(symbol_limit <= symbols_max);
    const bits_len = octets.len * @bitSizeOf(u8);
    // RFC 8878 §4.1.1: the description starts with Accuracy_Log - 5 in 4 bits.
    if (bits_len < constants.accuracy_log_field_bits) return error.FseDescriptionTruncated;
    const low_bits: u4 = @truncate(fast_reader.forward(octets, 0));
    const accuracy_log = @as(u32, low_bits) + constants.accuracy_log_offset;
    // RFC 8878 §3.1.1.3.2.1 and §4.2.1.2 give each table its largest accuracy log.
    if (accuracy_log > accuracy_log_max) return error.FseAccuracyLogTooLarge;
    distribution.accuracy_log = @intCast(accuracy_log);
    var at: usize = constants.accuracy_log_field_bits;
    // The points of the table's 2^Accuracy_Log not yet given: a probability is at most this many.
    var left: u32 = @as(u32, 1) << @intCast(accuracy_log);
    var symbol: u16 = 0;
    var present: u16 = 0;
    for (0..symbols_max + 1) |_| {
        if (left == 0) break;
        // RFC 8878 §4.1.1: a distribution names no symbol past the alphabet's last.
        if (symbol >= symbol_limit) return error.FseDistributionInvalid;
        const probability = try read_probability(octets, &at, left);
        distribution.probabilities[symbol] = probability;
        left -= if (probability < 0) 1 else @as(u32, @intCast(probability));
        present += @intFromBool(probability != 0);
        symbol += 1;
        if (probability == 0) symbol = try skip_zeros(octets, &at, distribution, symbol, symbol_limit);
    }
    // RFC 8878 §4.1.1: the total reaches exactly 2^Accuracy_Log, over two or more symbols.
    if (left != 0 or present < constants.fse_symbols_present_min) return error.FseDistributionInvalid;
    distribution.symbol_count = symbol;
    return std.math.divCeil(usize, at, @bitSizeOf(u8)) catch unreachable;
}

/// One probability, when `left` points of the table remain to give (RFC 8878 §4.1.1, Table 20):
/// values from 0 to `left + 1`, those below a threshold in one bit fewer. Returns Value - 1, and
/// moves `at` past the value's bits. Both widths come from one load, and a select picks one.
inline fn read_probability(octets: []const u8, at: *usize, left: u32) Error!i16 {
    const value_max = left + 1;
    // `left` is from 1 to 2^9, so the full width is from 2 to 10 bits, and 2^width passes
    // `value_max`: no step wraps.
    const width: u5 = @intCast(std.math.log2_int(u32, value_max) + 1);
    const half = @as(u32, 1) << (width - 1);
    const threshold = (half << 1) -% 1 -% value_max;
    const bits: u32 = @truncate(fast_reader.forward(octets, at.*));
    const low = bits & (half - 1);
    const full = bits & ((half << 1) - 1);
    const short = low < threshold;
    const value = if (short) low else if (full >= half) full - threshold else full;
    const used = width - @intFromBool(short);
    // RFC 8878 §4.1.1: a description the block ends inside is corrupt. A short value whose bits
    // pass the end reads zeros there, but its own width already passes it.
    if (at.* + used > octets.len * @bitSizeOf(u8)) return error.FseDescriptionTruncated;
    at.* += used;
    return @intCast(@as(i32, @intCast(value)) - 1);
}

/// After a probability of zero, the 2-bit repeat flags: each names up to 3 more zeros, and a 3
/// says another flag follows (RFC 8878 §4.1.1). Returns the next symbol.
fn skip_zeros(octets: []const u8, at: *usize, distribution: *Distribution, first: u16, symbol_limit: u16) Error!u16 {
    var symbol = first;
    for (0..symbols_max + 1) |_| {
        // RFC 8878 §4.1.1: a repeat flag the block ends inside is corrupt.
        if (at.* + constants.fse_repeat_flag_bits > octets.len * @bitSizeOf(u8)) return error.FseDescriptionTruncated;
        const repeat: u16 = @as(u2, @truncate(fast_reader.forward(octets, at.*)));
        at.* += constants.fse_repeat_flag_bits;
        // RFC 8878 §4.1.1: zeros may not run past the alphabet's last symbol.
        if (symbol + repeat > symbol_limit) return error.FseDistributionInvalid;
        set_zeros(&distribution.probabilities, symbol, repeat);
        symbol += repeat;
        if (repeat != constants.fse_repeat_flag_more) return symbol;
    }
    // RFC 8878 §4.1.1: more repeat flags than the alphabet has symbols.
    return error.FseDistributionInvalid;
}

/// Sets `count` probabilities from `start` to zero, a run the caller checked fits the alphabet.
fn set_zeros(probabilities: *[symbols_max]i16, start: u16, count: u16) void {
    assert(start + count <= symbols_max);
    @memset(probabilities[start..][0..count], 0);
}

/// Builds the table `distribution` gives (RFC 8878 §4.1.1).
pub fn build(comptime log_max: u4, table: *Table(log_max), distribution: *const Distribution) Error!void {
    assert(distribution.accuracy_log <= log_max);
    table.accuracy_log = distribution.accuracy_log;
    table.work = work_module.of(try build_cells(Entry, entry_of, 1 << symbol_index_bits, &table.cells, distribution));
}

fn entry_of(symbol: u8) Entry {
    return .{ .symbol = symbol, .bits = 0, .baseline = 0 };
}

/// Builds the table `distribution` gives into the start of `cells` (RFC 8878 §4.1.1): each state's
/// cell is its symbol's cell as `make` gives it, with the state's Number_of_Bits in its `bits` and
/// its Baseline in its `baseline`. `make` takes every symbol below `symbol_limit`, and the
/// distribution names none past it. Returns invariant 17's count: the cells and the distribution's
/// symbols.
pub fn build_cells(comptime Cell: type, comptime make: fn (u8) Cell, comptime symbol_limit: usize, cells: []Cell, distribution: *const Distribution) Error!usize {
    const table_len = @as(usize, 1) << distribution.accuracy_log;
    assert(distribution.accuracy_log <= constants.accuracy_log_max and table_len <= cells.len);
    assert(distribution.symbol_count <= symbol_limit);
    const probabilities = distribution.probabilities[0..distribution.symbol_count];
    const table = cells[0..table_len];
    // RFC 8878 §4.1.1: the step is odd, so it visits every cell once; ending anywhere but 0 means
    // the probabilities did not fill the cells below the "less than 1" symbols'.
    if (spread(Cell, table, probabilities) != 0) return error.FseDistributionInvalid;
    switch (distribution.accuracy_log) {
        inline constants.accuracy_log_offset...constants.accuracy_log_max => |accuracy_log| assign_baselines(Cell, make, symbol_limit, accuracy_log, table, probabilities),
        // RFC 8878 §4.1.1's field gives Accuracy_Log 5 at least, and the default tables 5 and 6.
        else => unreachable,
    }
    return table_len + probabilities.len;
}

/// The step of RFC 8878 §4.1.1's spread for a table of `table_len` cells.
fn spread_step(table_len: usize) usize {
    return (table_len >> constants.fse_spread_half_shift) + (table_len >> constants.fse_spread_eighth_shift) + constants.fse_spread_add;
}

/// Spreads the symbols over `table`, each cell holding its symbol in its `baseline` for
/// `assign_baselines`: "less than 1" symbols one cell each from the table's end back, then every
/// other symbol in symbol order, stepping as RFC 8878 §4.1.1 gives and skipping their cells.
/// Returns where the steps end.
fn spread(comptime Cell: type, table: []Cell, probabilities: []const i16) usize {
    var high: usize = table.len;
    for (probabilities, 0..) |probability, symbol| {
        if (probability >= 0) continue;
        high -= 1;
        table[high] = holding(Cell, @intCast(symbol));
    }
    const mask = table.len - 1;
    const step = spread_step(table.len);
    // The steps taken times the step, masked only where a cell is written, so a step waits on one
    // add. Two rounds of the table's cells at most, far below its overflow.
    var walked: usize = 0;
    for (probabilities, 0..) |probability, symbol| {
        if (probability <= 0) continue;
        const cell = holding(Cell, @intCast(symbol));
        for (0..@as(usize, @intCast(probability))) |_| {
            walked = past_high(walked, step, mask, high);
            table[walked & mask] = cell;
            walked +%= step;
        }
    }
    return past_high(walked, step, mask, high) & mask;
}

/// `walked` stepped past the cells from `high` on, which hold "less than 1" symbols: within one
/// round of the table's cells, as fewer lie there.
inline fn past_high(walked: usize, step: usize, mask: usize, high: usize) usize {
    var at = walked;
    for (0..mask + 1) |_| {
        if (at & mask < high) return at;
        at +%= step;
    }
    return at;
}

/// A cell that holds `symbol` in its `baseline`, as the spread leaves it.
inline fn holding(comptime Cell: type, symbol: u8) Cell {
    var cell: Cell = @bitCast(@as(std.meta.Int(.unsigned, @bitSizeOf(Cell)), 0));
    cell.baseline = symbol;
    return cell;
}

/// The bits that index every symbol of the largest alphabet, match length codes' 53.
const symbol_index_bits = 6;

comptime {
    assert(symbols_max <= 1 << symbol_index_bits);
}

/// The Number_of_Bits and Baseline of every state of a table of 2^`accuracy_log` cells, in the places
/// `Cell` holds them, the rest of the cell 0 (RFC 8878 §4.1.1, Table 21). A state lies from 1 to
/// below 2^(Accuracy_Log+1): its highest bit gives the bits it reads, and it shifted by them lies
/// from 2^Accuracy_Log to twice that, the Baseline above 2^Accuracy_Log.
fn state_fields(comptime Cell: type, comptime accuracy_log: u4) [1 << (accuracy_log + 1)]std.meta.Int(.unsigned, @bitSizeOf(Cell)) {
    @setEvalBranchQuota(default_table_eval_quota);
    const Bits = std.meta.Int(.unsigned, @bitSizeOf(Cell));
    var fields: [1 << (accuracy_log + 1)]Bits = @splat(0);
    for (fields[1..], 1..) |*field, state| {
        const bits = accuracy_log - std.math.log2_int(usize, state);
        var cell: Cell = @bitCast(@as(Bits, 0));
        cell.bits = bits;
        cell.baseline = @intCast((state << bits) - (1 << accuracy_log));
        field.* = @bitCast(cell);
    }
    return fields;
}

/// Each cell's Number_of_Bits and Baseline: a symbol's cells, in table order, take the states
/// from its probability up, and the lower states read one bit more (RFC 8878 §4.1.1, Table 21).
/// Each symbol's cell is made once, with no bits and a Baseline of 0, and each state's is it with
/// the state's fields, which comptime computed, added.
fn assign_baselines(comptime Cell: type, comptime make: fn (u8) Cell, comptime symbol_limit: usize, comptime accuracy_log: u4, table: []Cell, probabilities: []const i16) void {
    const fields = comptime state_fields(Cell, accuracy_log);
    // Each symbol's cell but for its state's fields, which comptime builds from `make`: a local
    // array would be filled with 0xaa on every build in ReleaseSafe.
    const symbol_cells = comptime symbol_cells_of(Cell, make, symbol_limit);
    var next_states: [1 << symbol_index_bits]u16 = undefined;
    for (probabilities, next_states[0..probabilities.len]) |probability, *next| {
        next.* = if (probability < 0) 1 else @intCast(probability);
    }
    for (table) |*cell| {
        // The spread left a symbol below 64, and a state is below 2^(Accuracy_Log+1), the fields'
        // length, so the truncations change none.
        const symbol: u6 = @truncate(cell.baseline);
        const state = next_states[symbol];
        next_states[symbol] +%= 1;
        cell.* = @bitCast(symbol_cells[symbol] | fields[@as(std.math.IntFittingRange(0, fields.len - 1), @truncate(state))]);
    }
}

/// The cell `make` gives each symbol below `symbol_limit`, 0 past it.
fn symbol_cells_of(comptime Cell: type, comptime make: fn (u8) Cell, comptime symbol_limit: usize) [1 << symbol_index_bits]std.meta.Int(.unsigned, @bitSizeOf(Cell)) {
    var cells: [1 << symbol_index_bits]std.meta.Int(.unsigned, @bitSizeOf(Cell)) = @splat(0);
    for (cells[0..symbol_limit], 0..) |*cell, symbol| cell.* = @bitCast(make(symbol));
    return cells;
}

/// The table of a default distribution, built at comptime (RFC 8878 §3.1.1.3.2.2).
pub fn default_table(comptime log_max: u4, comptime accuracy_log: u4, comptime probabilities: []const i16) Table(log_max) {
    @setEvalBranchQuota(default_table_eval_quota);
    var distribution: Distribution = .{ .probabilities = undefined, .symbol_count = probabilities.len, .accuracy_log = accuracy_log };
    @memcpy(distribution.probabilities[0..probabilities.len], probabilities);
    var table: Table(log_max) = undefined;
    build(log_max, &table, &distribution) catch unreachable;
    return table;
}

test {
    _ = @import("fse_test.zig");
}
