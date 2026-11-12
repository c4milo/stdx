//! The tests of encoder_split.zig: the scaled log2, a meta-block of one kind of literal, the merge's
//! prices from listed symbols, each type's counts against its blocks' literals, each type's costs,
//! rebuilt from the symbols that changed, against its counts, and the cheapest type against a
//! price from the counts.

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
    var generator = @import("codec").testing.split.Generator.init(one_kind_len);
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
    var generator = @import("codec").testing.split.Generator.init(join_seed);
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
    var generator = @import("codec").testing.split.Generator.init(mixed_len);
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

test "a type's costs, rebuilt from the symbols that changed, match its counts after each pass, and price its pieces" {
    try @call(.never_inline, expect_rebuilt_costs, .{});
}

/// Seeded meta-blocks of literals drawn from a few alphabets, through the first pass and the
/// second, the state poisoned first and reused: after each, every type's rebuilt costs must be
/// those of its counts, as a rebuild of every symbol makes them, and `cheapest` must pick the type
/// those counts price lowest.
fn expect_rebuilt_costs() !void {
    var state: Split = undefined;
    @memset(std.mem.asBytes(&state), std.math.maxInt(u8));
    var generator = @import("codec").testing.split.Generator.init(rebuilt_seed);
    var moved: usize = 0;
    for (0..rebuilt_rounds) |_| {
        const len: usize = @intCast(generator.between(level5.split_literals_min, rebuilt_len_max));
        for (state.literals[0..len], 0..) |*octet, index| {
            // Each run of literals draws from an alphabet that overlaps its neighbours'.
            const run = index / rebuilt_run_len;
            const kind = (run *% rebuilt_seed) % rebuilt_kinds;
            octet.* = @intCast(kind * rebuilt_kind_step + generator.below(rebuilt_kind_span));
        }
        state.literals_len = len;
        state.types_count = 1;
        encoder_split.seed(&state);
        // Several types, so a stale term or whole can misprice one against another.
        try testing.expect(state.types_count > 1);
        try expect_terms(&state);
        try expect_cheapest(&state, &generator);
        const seeded = state.chunk_types;
        encoder_split.move_chunks(&state);
        for (seeded[0..chunks_of(len)], state.chunk_types[0..chunks_of(len)]) |before, after| moved += @intFromBool(before != after);
        try expect_terms(&state);
        try expect_cheapest(&state, &generator);
    }
    // The pass moved chunks, so their counts left one type and joined another.
    try testing.expect(moved >= rebuilt_moved_min);
}

fn chunks_of(len: usize) usize {
    return std.math.divCeil(usize, len, level5.split_chunk_len) catch unreachable;
}

test "a type begun again takes the terms of its counts, whatever an earlier split left" {
    try @call(.never_inline, expect_begun_again, .{});
}

/// Each chunk of four symbols of its own, so each starts a type that holds it alone. Run twice on
/// one state, each type's counts at the second run's rebuilds equal its copy from the first run's,
/// and only a fresh start shows its terms stale.
fn expect_begun_again() !void {
    var state: Split = undefined;
    @memset(std.mem.asBytes(&state), std.math.maxInt(u8));
    const len = level5.split_literals_min;
    for (state.literals[0..len], 0..) |*octet, index| {
        octet.* = @intCast(index / level5.split_chunk_len * own_symbols + index % own_symbols);
    }
    state.literals_len = len;
    for (0..begun_runs) |_| {
        state.types_count = 1;
        encoder_split.seed(&state);
        try testing.expectEqual(len / level5.split_chunk_len, state.types_count);
        try expect_terms(&state);
    }
}

/// Each chunk's symbols: 64 chunks of four take the alphabet's 256.
const own_symbols = 4;
const begun_runs = 2;

/// Seeded pieces of the literals, after a switch or none: `cheapest` must give the type and the
/// cost a price from each type's counts gives, the lowest type on a tie.
fn expect_cheapest(state: *const Split, generator: anytype) !void {
    for (0..rebuilt_pieces) |_| {
        // Half the pieces are full chunks, as all but a meta-block's last are.
        const full = generator.below(rebuilt_one_in) == 0;
        const len: usize = if (full) level5.split_chunk_len else @intCast(generator.between(1, level5.split_chunk_len));
        const start: usize = @intCast(generator.below(state.literals_len - len + 1));
        const piece = state.literals[start..][0..len];
        const switched = generator.below(rebuilt_one_in) == 0;
        const previous: ?usize = if (switched) @intCast(generator.below(state.types_count)) else null;
        var best: encoder_split.Choice = .{ .type_index = 0, .cost = std.math.maxInt(u32) };
        for (0..state.types_count) |type_index| {
            const cost = price_from_counts(state, type_index, piece, previous);
            if (cost < best.cost) best = .{ .type_index = type_index, .cost = cost };
        }
        const chosen = encoder_split.cheapest(state, piece, previous);
        try testing.expectEqual(best.type_index, chosen.type_index);
        try testing.expectEqual(best.cost, chosen.cost);
    }
}

/// Rebuilds each type's costs and requires the whole and every term its counts give.
fn expect_terms(state: *Split) !void {
    for (0..state.types_count) |type_index| {
        encoder_split.rebuild_costs(state, type_index);
        var total: u32 = 0;
        for (state.counts[type_index]) |count| total += count;
        try testing.expectEqual(total, state.totals[type_index]);
        const whole = log2_scaled(rebuilt_doubled * total + rebuilt_doubled);
        try testing.expectEqual(whole, state.wholes[type_index]);
        try testing.expectEqual(whole * level5.split_chunk_len, state.chunk_wholes[type_index]);
        for (state.counts[type_index], 0..) |count, symbol| {
            try testing.expectEqual(encoder_split.log2_small(rebuilt_doubled * @as(u32, count) + 1), state.costs[symbol][type_index]);
        }
    }
}

/// The bits `piece` takes under `type_index`'s counts, with a switch from any other type.
fn price_from_counts(state: *const Split, type_index: usize, piece: []const u8, previous: ?usize) u32 {
    const counts = &state.counts[type_index];
    var total: u32 = 0;
    for (counts) |count| total += count;
    const whole = log2_scaled(rebuilt_doubled * total + rebuilt_doubled);
    var cost: u32 = 0;
    for (piece) |octet| cost += whole - encoder_split.log2_small(rebuilt_doubled * @as(u32, counts[octet]) + 1);
    if (previous) |kept| {
        if (kept != type_index) cost += level5.split_switch_cost;
    }
    return cost;
}

const rebuilt_seed = 75;
const rebuilt_rounds = 24;
const rebuilt_pieces = 64;
/// Meta-blocks of the fewest literals that split up to eight times as many.
const rebuilt_len_max = rebuilt_len_times * level5.split_literals_min;
const rebuilt_len_times = 8;
/// Literals change alphabet every this many, so the first pass starts several types.
const rebuilt_run_len = 300;
const rebuilt_kinds = 6;
/// Each alphabet starts this many symbols after the one before and spans three times as many.
const rebuilt_kind_step = 8;
const rebuilt_kind_span = rebuilt_kind_steps * rebuilt_kind_step;
const rebuilt_kind_steps = 3;
/// The seeded rounds move 26 chunks in all.
const rebuilt_moved_min = 8;
/// One piece in this many is a full chunk, and one in this many follows a switch.
const rebuilt_one_in = 2;
/// As `rebuild_costs` doubles each count and total.
const rebuilt_doubled = 2;
