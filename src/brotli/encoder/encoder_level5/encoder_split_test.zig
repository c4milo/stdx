//! The tests of encoder_split.zig: the scaled log2, a meta-block of one kind of literal, the merge's
//! prices from listed symbols, and each type's counts against its blocks' literals.

const std = @import("std");
const testing = std.testing;
const constants = @import("../../constants.zig");
const encoder_commands = @import("../encoder_commands.zig");
const encoder_split = @import("encoder_split.zig");

const Split = encoder_split.Split;
const split = encoder_split.split;
const log2_scaled = encoder_split.log2_scaled;
const list_symbols = encoder_split.list_symbols;
const join_into = encoder_split.join_into;
const price_joined = encoder_split.price_joined;
const price_counts = encoder_split.price_counts;
const types_max = encoder_split.types_max;
const alphabet_len = constants.literal_alphabet_len;
const level5 = constants.encoder_level5;
const shift = level5.split_cost_shift;

test "log2_scaled gives log2 in 1/64 bit" {
    try testing.expectEqual(0, log2_scaled(1));
    try testing.expectEqual(1 << shift, log2_scaled(2));
    try testing.expectEqual(10 << shift, log2_scaled(1024));
    // log2(3) is 1.585, 101 in 1/64 bit.
    try testing.expectEqual(log2_three, log2_scaled(3));
}

/// log2(3) in 1/64 bit.
const log2_three = 101;

test "literals of one kind take one block of type 0, whatever the state held before" {
    try @call(.never_inline, expect_one_kind, .{});
}

/// Literals of one kind in a meta-block that splits: the split must write each chunk's type, the
/// first included, and not read what the state held (invariant 4).
fn expect_one_kind() !void {
    var state: Split = undefined;
    @memset(std.mem.asBytes(&state), std.math.maxInt(u8));
    var window: [one_kind_len]u8 = undefined;
    var generator = @import("codec").split.Generator.init(one_kind_len);
    for (&window) |*octet| octet.* = 'a' + @as(u8, @intCast(generator.below(one_kind_alphabet)));
    var commands: encoder_commands.WideCommands = undefined;
    commands.init();
    commands.add_literals(true, &window);
    commands.close();
    split(true, &state, &window, 0, &commands);
    try testing.expectEqual(1, state.types_count);
    try testing.expectEqual(1, state.blocks_count);
    try testing.expectEqual(0, state.block_types[0]);
}

/// Twice the fewest literals a meta-block splits, of 16 letters.
const one_kind_len = one_kind_times * level5.split_literals_min;
const one_kind_times = 2;
const one_kind_alphabet = 16;

test "a join's price from the listed symbols equals the price of the joined counts" {
    try @call(.never_inline, expect_join_prices, .{});
}

fn expect_join_prices() !void {
    var state: Split = undefined;
    var generator = @import("codec").split.Generator.init(join_seed);
    for (0..join_rounds) |_| {
        // Two types of seeded counts, some symbols in one, some in both, most in neither; now and
        // then a type with none.
        for (state.counts[0..join_types]) |*counts| {
            counts.* = @splat(0);
            for (0..generator.below(join_symbols_max)) |_| counts[generator.below(alphabet_len)] = @intCast(generator.below(join_count_max) + 1);
        }
        for (0..join_types) |type_index| list_symbols(&state, type_index);
        var joined: [alphabet_len]u16 = undefined;
        for (&joined, state.counts[0], state.counts[1]) |*count, left, right| count.* = left + right;
        try testing.expectEqual(price_counts(&joined), price_joined(&state, 0, 1));
        join_into(&state, 0, 1);
        try testing.expectEqualSlices(u16, &joined, &state.counts[0]);
        try testing.expectEqual(price_counts(&joined), price_counts(&state.counts[0]));
    }
}

const join_seed = 66;
const join_rounds = 200;
const join_types = 2;
const join_symbols_max = 64;
const join_count_max = 300;

test "each type's counts are those of the literals in its blocks" {
    try @call(.never_inline, expect_counts_follow, .{});
}

/// Pieces of four alphabets in a seeded order, which split into several types: after the pass,
/// the merge and the numbering, each type's counts must be its blocks' literals' (invariant 4's
/// counterpart for the codes: a code built from wrong counts misprices its own literals).
fn expect_counts_follow() !void {
    var state: Split = undefined;
    var window: [mixed_len]u8 = undefined;
    var generator = @import("codec").split.Generator.init(mixed_len);
    var at: usize = 0;
    for (0..mixed_len / mixed_piece_len) |_| {
        const first = mixed_firsts[generator.below(mixed_firsts.len)];
        for (window[at..][0..mixed_piece_len]) |*octet| octet.* = first + @as(u8, @intCast(generator.below(one_kind_alphabet)));
        at += mixed_piece_len;
    }
    var commands: encoder_commands.WideCommands = undefined;
    commands.init();
    commands.add_literals(true, &window);
    commands.close();
    split(true, &state, &window, 0, &commands);
    try testing.expect(state.types_count > 1);
    var counted: [types_max][alphabet_len]u16 = undefined;
    for (counted[0..state.types_count]) |*counts| counts.* = @splat(0);
    var start: usize = 0;
    for (state.block_types[0..state.blocks_count], state.block_lens[0..state.blocks_count]) |type_index, len| {
        for (window[start..][0..len]) |octet| counted[type_index][octet] += 1;
        start += len;
    }
    for (counted[0..state.types_count], state.counts[0..state.types_count]) |*expected, *actual| try testing.expectEqualSlices(u16, expected, actual);
}

const mixed_len = mixed_pieces * mixed_piece_len;
const mixed_pieces = 16;
const mixed_piece_len = 600;
const mixed_firsts = [_]u8{ 'a', '0', 'A', mixed_high_first };
const mixed_high_first = 0x80;
