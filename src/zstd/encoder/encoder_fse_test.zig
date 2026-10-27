//! The tests of FSE encoding, each read back through the decoder's own code: `fse.read_distribution`
//! for a description, and the decoder's table for the states.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../constants.zig");
const fse = @import("../fse.zig");
const encoder_fse = @import("encoder_fse.zig");

const Table = encoder_fse.EncodeTable(constants.accuracy_log_max, fse.symbols_max);

/// A drawn count is zero about one time in `zero_odds`, else from 1 to `count_max`.
const zero_odds = 3;
const count_max = 1000;

/// The octets a test stream takes at most.
const stream_len_max = 1024;

/// Counts a seeded generator draws for `symbols` symbols, about a third of them zero in runs.
fn draw_counts(generator: *codec.split.Generator, counts: []u32) u32 {
    var total: u32 = 0;
    for (counts) |*count| {
        count.* = if (generator.below(zero_odds) == 0) 0 else @intCast(generator.below(count_max) + 1);
        total += count.*;
    }
    // Two symbols occur at least.
    for (counts[0..constants.fse_symbols_present_min]) |*count| {
        if (count.* == 0) {
            count.* = 1;
            total += 1;
        }
    }
    return total;
}

test "a normalized distribution sums to its scale, and every symbol that occurs keeps a point" {
    var generator = codec.split.Generator.init(1);
    for (0..200) |_| {
        var counts: [fse.symbols_max]u32 = undefined;
        const symbols = generator.between(2, fse.symbols_max);
        const total = draw_counts(&generator, counts[0..symbols]);
        var present: usize = 0;
        for (counts[0..symbols]) |count| present += @intFromBool(count > 0);
        const accuracy_log = encoder_fse.accuracy_log_for(total, present, constants.accuracy_log_max);
        var distribution: fse.Distribution = undefined;
        encoder_fse.normalize(counts[0..symbols], total, accuracy_log, &distribution);
        var sum: u32 = 0;
        for (distribution.probabilities[0..distribution.symbol_count], counts[0..distribution.symbol_count]) |probability, count| {
            try testing.expect(probability >= 0);
            try testing.expectEqual(count > 0, probability > 0);
            sum += @intCast(probability);
        }
        try testing.expectEqual(@as(u32, 1) << accuracy_log, sum);
    }
}

test "a written description reads back as the same distribution" {
    var generator = codec.split.Generator.init(2);
    for (0..200) |_| {
        var counts: [fse.symbols_max]u32 = undefined;
        const symbols = generator.between(2, fse.symbols_max);
        const total = draw_counts(&generator, counts[0..symbols]);
        var present: usize = 0;
        for (counts[0..symbols]) |count| present += @intFromBool(count > 0);
        const accuracy_log = encoder_fse.accuracy_log_for(total, present, constants.accuracy_log_max);
        var distribution: fse.Distribution = undefined;
        encoder_fse.normalize(counts[0..symbols], total, accuracy_log, &distribution);
        var octets: [128]u8 = undefined;
        var writer = codec.BitWriter.init(&octets, .{});
        try encoder_fse.write_distribution(&writer, &distribution);
        try testing.expect(writer.drain());
        var read: fse.Distribution = undefined;
        const read_len = try fse.read_distribution(writer.writer.written(), fse.symbols_max, constants.accuracy_log_max, &read);
        try testing.expectEqual(writer.writer.written().len, read_len);
        try testing.expectEqual(distribution.accuracy_log, read.accuracy_log);
        try testing.expectEqual(distribution.symbol_count, read.symbol_count);
        try testing.expectEqualSlices(i16, distribution.probabilities[0..distribution.symbol_count], read.probabilities[0..read.symbol_count]);
    }
}

test "symbols encoded backward decode forward through the decoder's table" {
    var generator = codec.split.Generator.init(3);
    for (0..100) |_| {
        var counts: [fse.symbols_max]u32 = undefined;
        const symbols = generator.between(2, fse.symbols_max);
        const total = draw_counts(&generator, counts[0..symbols]);
        var present: usize = 0;
        for (counts[0..symbols]) |count| present += @intFromBool(count > 0);
        var distribution: fse.Distribution = undefined;
        encoder_fse.normalize(counts[0..symbols], total, encoder_fse.accuracy_log_for(total, present, constants.accuracy_log_max), &distribution);
        var scratch: fse.Table(constants.accuracy_log_max) = undefined;
        var table: Table = undefined;
        table.build(&distribution, &scratch);
        var message: [300]u8 = undefined;
        const message_len = generator.between(1, message.len);
        draw_message(&generator, counts[0..symbols], message[0..message_len]);
        try expect_round_trip(&table, scratch.entries(), message[0..message_len]);
    }
}

/// Symbols that occur, drawn with no weight in particular.
fn draw_message(generator: *codec.split.Generator, counts: []const u32, message: []u8) void {
    for (message) |*symbol| {
        var drawn: usize = generator.below(counts.len);
        for (0..counts.len) |_| {
            if (counts[drawn] > 0) break;
            drawn = (drawn + 1) % counts.len;
        }
        symbol.* = @intCast(drawn);
    }
}

/// Encodes `message` backward through `table`, and requires the decoder's `cells` to read it forward.
fn expect_round_trip(table: *const Table, cells: []const fse.Entry, message: []const u8) !void {
    var octets: [stream_len_max]u8 = undefined;
    var writer = codec.BitWriter.init(&octets, .{});
    var state = table.first_state(message[message.len - 1]);
    var index = message.len - 1;
    for (0..message.len - 1) |_| {
        index -= 1;
        const bits = table.step(&state, message[index]);
        try testing.expect(writer.make_room(bits.count));
        writer.put(bits.value, bits.count);
    }
    try testing.expect(writer.make_room(table.accuracy_log + 1));
    writer.put(table.final_value(state), table.accuracy_log);
    writer.put(1, 1);
    writer.put(0, writer.bits_to_octet());
    try testing.expect(writer.drain());
    var reader = codec.BackwardBitReader.init(writer.writer.written()).?;
    var cell: usize = @intCast(reader.read(table.accuracy_log));
    for (message, 0..) |symbol, at| {
        try testing.expectEqual(symbol, cells[cell].symbol);
        if (at + 1 == message.len) break;
        cell = cells[cell].baseline + @as(usize, @intCast(reader.read(@intCast(cells[cell].bits))));
    }
    try testing.expect(!reader.overflowed);
    try testing.expectEqual(0, reader.position);
}

test "a symbol costs Accuracy_Log less log2 of its probability, in 1/256ths of a bit" {
    try testing.expectEqual(constants.cost_fraction, encoder_fse.symbol_cost(6, 32));
    try testing.expectEqual(6 * constants.cost_fraction, encoder_fse.symbol_cost(6, 1));
    try testing.expectEqual(0, encoder_fse.symbol_cost(6, 64));
}
