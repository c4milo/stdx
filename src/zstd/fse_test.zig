//! Tests for FSE tables: the default tables equal RFC 8878 Appendix A's, distributions read back
//! what a writer of §4.1.1's format wrote, the baselines of §4.1.1's example, and each refusal.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("constants.zig");
const fse = @import("fse.zig");
const DescriptionWriter = @import("test_writer.zig").DescriptionWriter;

/// A row of RFC 8878 Appendix A: Symbol, Number_Of_Bits and Base, by state.
const Row = struct { u8, u8, u16 };

fn expect_rows(comptime log_max: u4, table: *const fse.Table(log_max), rows: []const Row) !void {
    try testing.expectEqual(rows.len, table.entries().len);
    for (table.entries(), rows) |cell, row| {
        const symbol, const bits, const baseline = row;
        try testing.expectEqual(symbol, cell.symbol);
        try testing.expectEqual(bits, cell.bits);
        try testing.expectEqual(baseline, cell.baseline);
    }
}

test "the default tables are RFC 8878 Appendix A's, without erratum 6441's duplicate rows" {
    // Transcribed from docs/rfcs/rfc8878.txt Appendix A. Erratum 6441 (verified) removes the
    // first row of each table, an all-zero duplicate of state 0.
    const literals_length = [_]Row{ .{ 0, 4, 0 }, .{ 0, 4, 16 }, .{ 1, 5, 32 }, .{ 3, 5, 0 }, .{ 4, 5, 0 }, .{ 6, 5, 0 }, .{ 7, 5, 0 }, .{ 9, 5, 0 }, .{ 10, 5, 0 }, .{ 12, 5, 0 }, .{ 14, 6, 0 }, .{ 16, 5, 0 }, .{ 18, 5, 0 }, .{ 19, 5, 0 }, .{ 21, 5, 0 }, .{ 22, 5, 0 }, .{ 24, 5, 0 }, .{ 25, 5, 32 }, .{ 26, 5, 0 }, .{ 27, 6, 0 }, .{ 29, 6, 0 }, .{ 31, 6, 0 }, .{ 0, 4, 32 }, .{ 1, 4, 0 }, .{ 2, 5, 0 }, .{ 4, 5, 32 }, .{ 5, 5, 0 }, .{ 7, 5, 32 }, .{ 8, 5, 0 }, .{ 10, 5, 32 }, .{ 11, 5, 0 }, .{ 13, 6, 0 }, .{ 16, 5, 32 }, .{ 17, 5, 0 }, .{ 19, 5, 32 }, .{ 20, 5, 0 }, .{ 22, 5, 32 }, .{ 23, 5, 0 }, .{ 25, 4, 0 }, .{ 25, 4, 16 }, .{ 26, 5, 32 }, .{ 28, 6, 0 }, .{ 30, 6, 0 }, .{ 0, 4, 48 }, .{ 1, 4, 16 }, .{ 2, 5, 32 }, .{ 3, 5, 32 }, .{ 5, 5, 32 }, .{ 6, 5, 32 }, .{ 8, 5, 32 }, .{ 9, 5, 32 }, .{ 11, 5, 32 }, .{ 12, 5, 32 }, .{ 15, 6, 0 }, .{ 17, 5, 32 }, .{ 18, 5, 32 }, .{ 20, 5, 32 }, .{ 21, 5, 32 }, .{ 23, 5, 32 }, .{ 24, 5, 32 }, .{ 35, 6, 0 }, .{ 34, 6, 0 }, .{ 33, 6, 0 }, .{ 32, 6, 0 } };
    const match_length = [_]Row{ .{ 0, 6, 0 }, .{ 1, 4, 0 }, .{ 2, 5, 32 }, .{ 3, 5, 0 }, .{ 5, 5, 0 }, .{ 6, 5, 0 }, .{ 8, 5, 0 }, .{ 10, 6, 0 }, .{ 13, 6, 0 }, .{ 16, 6, 0 }, .{ 19, 6, 0 }, .{ 22, 6, 0 }, .{ 25, 6, 0 }, .{ 28, 6, 0 }, .{ 31, 6, 0 }, .{ 33, 6, 0 }, .{ 35, 6, 0 }, .{ 37, 6, 0 }, .{ 39, 6, 0 }, .{ 41, 6, 0 }, .{ 43, 6, 0 }, .{ 45, 6, 0 }, .{ 1, 4, 16 }, .{ 2, 4, 0 }, .{ 3, 5, 32 }, .{ 4, 5, 0 }, .{ 6, 5, 32 }, .{ 7, 5, 0 }, .{ 9, 6, 0 }, .{ 12, 6, 0 }, .{ 15, 6, 0 }, .{ 18, 6, 0 }, .{ 21, 6, 0 }, .{ 24, 6, 0 }, .{ 27, 6, 0 }, .{ 30, 6, 0 }, .{ 32, 6, 0 }, .{ 34, 6, 0 }, .{ 36, 6, 0 }, .{ 38, 6, 0 }, .{ 40, 6, 0 }, .{ 42, 6, 0 }, .{ 44, 6, 0 }, .{ 1, 4, 32 }, .{ 1, 4, 48 }, .{ 2, 4, 16 }, .{ 4, 5, 32 }, .{ 5, 5, 32 }, .{ 7, 5, 32 }, .{ 8, 5, 32 }, .{ 11, 6, 0 }, .{ 14, 6, 0 }, .{ 17, 6, 0 }, .{ 20, 6, 0 }, .{ 23, 6, 0 }, .{ 26, 6, 0 }, .{ 29, 6, 0 }, .{ 52, 6, 0 }, .{ 51, 6, 0 }, .{ 50, 6, 0 }, .{ 49, 6, 0 }, .{ 48, 6, 0 }, .{ 47, 6, 0 }, .{ 46, 6, 0 } };
    const offset = [_]Row{ .{ 0, 5, 0 }, .{ 6, 4, 0 }, .{ 9, 5, 0 }, .{ 15, 5, 0 }, .{ 21, 5, 0 }, .{ 3, 5, 0 }, .{ 7, 4, 0 }, .{ 12, 5, 0 }, .{ 18, 5, 0 }, .{ 23, 5, 0 }, .{ 5, 5, 0 }, .{ 8, 4, 0 }, .{ 14, 5, 0 }, .{ 20, 5, 0 }, .{ 2, 5, 0 }, .{ 7, 4, 16 }, .{ 11, 5, 0 }, .{ 17, 5, 0 }, .{ 22, 5, 0 }, .{ 4, 5, 0 }, .{ 8, 4, 16 }, .{ 13, 5, 0 }, .{ 19, 5, 0 }, .{ 1, 5, 0 }, .{ 6, 4, 16 }, .{ 10, 5, 0 }, .{ 16, 5, 0 }, .{ 28, 5, 0 }, .{ 27, 5, 0 }, .{ 26, 5, 0 }, .{ 25, 5, 0 }, .{ 24, 5, 0 } };
    const literals_table = comptime fse.default_table(constants.accuracy_log_max, constants.literals_length_default_accuracy_log, &constants.literals_length_default);
    const match_table = comptime fse.default_table(constants.accuracy_log_max, constants.match_length_default_accuracy_log, &constants.match_length_default);
    const offset_table = comptime fse.default_table(constants.accuracy_log_max, constants.offset_default_accuracy_log, &constants.offset_default);
    try expect_rows(constants.accuracy_log_max, &literals_table, &literals_length);
    try expect_rows(constants.accuracy_log_max, &match_table, &match_length);
    try expect_rows(constants.accuracy_log_max, &offset_table, &offset);
}

test "a symbol of probability 5 in 128 states takes RFC 8878 §4.1.1's widths and baselines" {
    // Table 21: states in order read 5, 5, 5, 4 and 4 bits from baselines 32, 64, 96, 0 and 16.
    var distribution: fse.Distribution = .{ .probabilities = undefined, .symbol_count = 2, .accuracy_log = 7 };
    distribution.probabilities[0] = 5;
    distribution.probabilities[1] = 123;
    var table: fse.Table(constants.accuracy_log_max) = undefined;
    try fse.build(constants.accuracy_log_max, &table, &distribution);
    var widths: [5]struct { u8, u16 } = undefined;
    var found: usize = 0;
    for (table.entries()) |cell| {
        if (cell.symbol != 0) continue;
        widths[found] = .{ cell.bits, cell.baseline };
        found += 1;
    }
    try testing.expectEqual(5, found);
    try testing.expectEqualSlices(struct { u8, u16 }, &.{ .{ 5, 32 }, .{ 5, 64 }, .{ 5, 96 }, .{ 4, 0 }, .{ 4, 16 } }, &widths);
}

/// The kinds of seeded probability: zero, "less than 1", and a count of cells.
const probability_kinds = 4;

/// A seeded count of cells takes up to a third of those left, so later symbols get some.
const share_divisor = 3;

/// A seeded distribution of `symbol_count` symbols over 2^`accuracy_log` points, with zeros and
/// "less than 1" probabilities among them.
fn seeded_distribution(generator: *codec.split.Generator, symbol_count: u16, accuracy_log: u4) fse.Distribution {
    var distribution: fse.Distribution = .{ .probabilities = @splat(0), .symbol_count = symbol_count, .accuracy_log = accuracy_log };
    var left: i32 = @as(i32, 1) << accuracy_log;
    for (0..symbol_count - 1) |symbol| {
        const kind = generator.below(probability_kinds);
        const probability: i16 = switch (kind) {
            0 => 0,
            1 => -1,
            else => @intCast(@min(left - 1, @as(i32, @intCast(generator.below(@intCast(@max(1, @divTrunc(left, share_divisor)))))) + 1)),
        };
        if (left <= 1) break;
        distribution.probabilities[symbol] = probability;
        left -= if (probability < 0) 1 else probability;
    }
    distribution.probabilities[symbol_count - 1] = @intCast(left);
    return distribution;
}

test "a distribution reads back as it was written, taking a round number of octets" {
    for (0..300) |seed| {
        var generator = codec.split.Generator.init(seed);
        const accuracy_log: u4 = @intCast(5 + generator.below(5));
        const symbol_count: u16 = @intCast(2 + generator.below(constants.match_length_symbols - 1));
        const written = seeded_distribution(&generator, symbol_count, accuracy_log);
        var writer: DescriptionWriter = .{};
        writer.write(&written);
        var read: fse.Distribution = undefined;
        const present = count_present(&written);
        if (present < 2) continue;
        const octets_len = try fse.read_distribution(&writer.octets, constants.match_length_symbols, constants.accuracy_log_max, &read);
        try testing.expectEqual((writer.bits_written + 7) / 8, octets_len);
        try testing.expectEqual(written.accuracy_log, read.accuracy_log);
        try testing.expectEqualSlices(i16, trimmed(&written), read.probabilities[0..read.symbol_count]);
        var table: fse.Table(constants.accuracy_log_max) = undefined;
        try fse.build(constants.accuracy_log_max, &table, &read);
        try expect_cells_follow(&table, &read);
    }
}

fn count_present(distribution: *const fse.Distribution) usize {
    var present: usize = 0;
    for (distribution.probabilities[0..distribution.symbol_count]) |probability| present += @intFromBool(probability != 0);
    return present;
}

/// The probabilities up to the last present symbol, which is where a description stops.
fn trimmed(distribution: *const fse.Distribution) []const i16 {
    var len = distribution.symbol_count;
    while (distribution.probabilities[len - 1] == 0) len -= 1;
    return distribution.probabilities[0..len];
}

/// Each symbol holds as many cells as its probability, one for "less than 1", and every cell's
/// next states stay inside the table.
fn expect_cells_follow(table: *const fse.Table(constants.accuracy_log_max), distribution: *const fse.Distribution) !void {
    var counts: [fse.symbols_max]u32 = @splat(0);
    for (table.entries()) |cell| {
        counts[cell.symbol] += 1;
        try testing.expect(@as(u32, cell.baseline) + (@as(u32, 1) << @intCast(cell.bits)) <= table.entries().len);
    }
    for (distribution.probabilities[0..distribution.symbol_count], counts[0..distribution.symbol_count]) |probability, count| {
        try testing.expectEqual(@as(u32, if (probability < 0) 1 else @intCast(probability)), count);
    }
}

test "an accuracy log past the table's largest, a total past the table, and a cut description are refused" {
    // Accuracy_Log 5 + 5 = 10, past the sequence tables' 9.
    try testing.expectError(error.FseAccuracyLogTooLarge, fse.read_distribution(&.{ 0x05, 0xff, 0xff }, 36, 9, undefined));
    var distribution: fse.Distribution = undefined;
    try testing.expectError(error.FseDescriptionTruncated, fse.read_distribution(&.{0x00}, 36, 9, &distribution));
    // One symbol of probability 32, the whole of a 5-bit table: fewer than two symbols.
    var writer: DescriptionWriter = .{};
    var single: fse.Distribution = .{ .probabilities = @splat(0), .symbol_count = 1, .accuracy_log = 5 };
    single.probabilities[0] = 32;
    writer.write(&single);
    try testing.expectError(error.FseDistributionInvalid, fse.read_distribution(&writer.octets, 36, 9, &distribution));
    // A description naming a symbol past a 2-symbol alphabet.
    var three: fse.Distribution = .{ .probabilities = @splat(0), .symbol_count = 3, .accuracy_log = 5 };
    three.probabilities[0] = 10;
    three.probabilities[1] = 11;
    three.probabilities[2] = 11;
    writer = .{};
    writer.write(&three);
    try testing.expectError(error.FseDistributionInvalid, fse.read_distribution(&writer.octets, 2, 9, &distribution));
}

test "a distribution whose probabilities miss the table's cells builds no table" {
    // 16 and 15 of 32 cells: the spread's steps end one step short of the cell they started from.
    var distribution: fse.Distribution = .{ .probabilities = undefined, .symbol_count = 2, .accuracy_log = 5 };
    distribution.probabilities[0] = 16;
    distribution.probabilities[1] = 15;
    var table: fse.Table(constants.accuracy_log_max) = undefined;
    try testing.expectError(error.FseDistributionInvalid, fse.build(constants.accuracy_log_max, &table, &distribution));
}
