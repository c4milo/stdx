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
    var reader = codec.BitReader.init(octets, .{});
    // RFC 8878 §4.1.1: the description starts with Accuracy_Log - 5 in 4 bits.
    const low_bits = reader.read(constants.accuracy_log_field_bits) orelse return error.FseDescriptionTruncated;
    const accuracy_log = low_bits + constants.accuracy_log_offset;
    // RFC 8878 §3.1.1.3.2.1 and §4.2.1.2 give each table its largest accuracy log.
    if (accuracy_log > accuracy_log_max) return error.FseAccuracyLogTooLarge;
    distribution.accuracy_log = @intCast(accuracy_log);
    const table_len: u32 = @as(u32, 1) << @intCast(accuracy_log);
    var distributed: u32 = 0;
    var symbol: u16 = 0;
    var present: u16 = 0;
    for (0..symbols_max + 1) |_| {
        if (distributed >= table_len) break;
        // RFC 8878 §4.1.1: a distribution names no symbol past the alphabet's last.
        if (symbol >= symbol_limit) return error.FseDistributionInvalid;
        const probability = try read_probability(&reader, table_len - distributed);
        distribution.probabilities[symbol] = probability;
        distributed += if (probability < 0) 1 else @as(u32, @intCast(probability));
        present += @intFromBool(probability != 0);
        symbol += 1;
        if (probability == 0) symbol = try skip_zeros(&reader, distribution, symbol, symbol_limit);
    }
    // RFC 8878 §4.1.1: the total reaches exactly 2^Accuracy_Log, over two or more symbols.
    if (distributed != table_len or present < constants.fse_symbols_present_min) return error.FseDistributionInvalid;
    distribution.symbol_count = symbol;
    const bits_read = octets.len * @bitSizeOf(u8) - reader.reader.remaining_len() * @bitSizeOf(u8) - reader.bits.count;
    return (bits_read + @bitSizeOf(u8) - 1) / @bitSizeOf(u8);
}

/// One probability, when `left` points of the table remain to distribute (RFC 8878 §4.1.1, Table
/// 20): values from 0 to `left + 1`, the smaller ones in one bit fewer. Returns Value - 1.
fn read_probability(reader: *codec.BitReader, left: u32) Error!i16 {
    const value_max = left + 1;
    const bits: u7 = @intCast(std.math.log2_int(u32, value_max) + 1);
    const threshold = (@as(u32, 1) << @intCast(bits)) - 1 - value_max;
    const low_bits = bits - 1;
    // RFC 8878 §4.1.1: a description the block ends inside is corrupt.
    if (!reader.ensure(low_bits)) return error.FseDescriptionTruncated;
    const low: u32 = @intCast(reader.peek(low_bits));
    if (low < threshold) {
        reader.consume(low_bits);
        return @intCast(@as(i32, @intCast(low)) - 1);
    }
    // RFC 8878 §4.1.1: as above, for a value of the full width.
    if (!reader.ensure(bits)) return error.FseDescriptionTruncated;
    const read: u32 = @intCast(reader.peek(bits));
    reader.consume(bits);
    const value = if (read >= @as(u32, 1) << @intCast(low_bits)) read - threshold else read;
    return @intCast(@as(i32, @intCast(value)) - 1);
}

/// After a probability of zero, the 2-bit repeat flags: each names up to 3 more zeros, and a 3
/// says another flag follows (RFC 8878 §4.1.1). Returns the next symbol.
fn skip_zeros(reader: *codec.BitReader, distribution: *Distribution, first: u16, symbol_limit: u16) Error!u16 {
    var symbol = first;
    for (0..symbols_max + 1) |_| {
        // RFC 8878 §4.1.1: a repeat flag the block ends inside is corrupt.
        const repeat: u16 = @intCast(reader.read(constants.fse_repeat_flag_bits) orelse return error.FseDescriptionTruncated);
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
    const table_len: u32 = @as(u32, 1) << distribution.accuracy_log;
    const probabilities = distribution.probabilities[0..distribution.symbol_count];
    // "Less than 1" symbols take one cell each from the table's end back, and reset the state.
    var high: u32 = table_len;
    for (probabilities, 0..) |probability, symbol| {
        if (probability >= 0) continue;
        high -= 1;
        table.cells[high].symbol = @intCast(symbol);
    }
    try spread(log_max, table, probabilities, high);
    assign_baselines(log_max, table, probabilities);
}

/// The step of RFC 8878 §4.1.1's spread for a table of `table_len` cells.
fn spread_step(table_len: u32) u32 {
    return (table_len >> constants.fse_spread_half_shift) + (table_len >> constants.fse_spread_eighth_shift) + constants.fse_spread_add;
}

/// Spreads every other symbol over the cells below `high`, in symbol order, stepping as RFC 8878
/// §4.1.1 gives and skipping the cells of "less than 1" symbols.
fn spread(comptime log_max: u4, table: *Table(log_max), probabilities: []const i16, high: u32) Error!void {
    const table_len: u32 = @as(u32, 1) << table.accuracy_log;
    const mask = table_len - 1;
    const step = spread_step(table_len);
    var position: u32 = 0;
    for (probabilities, 0..) |probability, symbol| {
        if (probability <= 0) continue;
        for (0..@as(usize, @intCast(probability))) |_| {
            table.cells[position].symbol = @intCast(symbol);
            position = (position + step) & mask;
            // At most `table_len - high` cells are taken, so this ends within as many steps.
            for (0..table_len) |_| {
                if (position < high) break;
                position = (position + step) & mask;
            }
        }
    }
    // RFC 8878 §4.1.1: the step is odd, so it visits every cell once; ending anywhere but 0 means
    // the probabilities did not fill the cells below `high`.
    if (position != 0) return error.FseDistributionInvalid;
}

/// Each cell's Number_of_Bits and Baseline: a symbol's cells, in table order, take the states
/// from its probability up, and the lower states read one bit more (RFC 8878 §4.1.1, Table 21).
fn assign_baselines(comptime log_max: u4, table: *Table(log_max), probabilities: []const i16) void {
    var next_states: [symbols_max]u32 = undefined;
    for (probabilities, next_states[0..probabilities.len]) |probability, *next| next.* = if (probability < 0) 1 else @intCast(probability);
    const table_len: u32 = @as(u32, 1) << table.accuracy_log;
    for (table.cells[0..table_len]) |*cell| {
        const state = next_states[cell.symbol];
        next_states[cell.symbol] += 1;
        const bits: u5 = @intCast(table.accuracy_log - std.math.log2_int(u32, state));
        cell.bits = bits;
        cell.baseline = @intCast((state << bits) - table_len);
    }
}

/// A table whose every state decodes `symbol` and reads no bits: RLE_Mode (RFC 8878
/// §3.1.1.3.2.1).
pub fn build_rle(comptime log_max: u4, table: *Table(log_max), symbol: u8) void {
    table.accuracy_log = 0;
    table.cells[0] = .{ .symbol = symbol, .bits = 0, .baseline = 0 };
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
