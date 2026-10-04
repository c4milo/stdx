//! Where a lazy level's block ends beyond its size (decision 44): before its newest symbols when
//! they code in fewer bits in a block of their own, and not at a slide of the window when it codes
//! for less than its stored form. The encoder keeps this file's state beside the block.
//!
//! Every `block_chunk_symbols` symbols, a check prices the block's newest symbols, those since the
//! last check, apart from the rest and together with them, by their entropy and an estimate of a
//! dynamic header each (`encoder_split_price.zig`). When apart costs less, the block ends before
//! them, and they start the next block. The same check prices fewer newest symbols at a slide, at
//! a flush and at the stream's end. At a slide, a block whose fixed code, or failing that its
//! plan, prices below its stored form goes on across it; the symbols before the slide can then
//! only be coded, as their octets leave the window, and if the block's end finds the stored form
//! cheapest, they go out alone, coded, and the rest starts the next block. So no block costs more
//! than its octets stored.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const block_module = @import("encoder_block.zig");
const price = @import("encoder_split_price.zig");
const Block = block_module.Block;
const Symbol = block_module.Symbol;

/// What the encoder keeps for decision 44 beside a block: outside the block, so the block's
/// fields stay where the match finder's loops and the writer read them.
pub const Split = struct {
    /// Where the newest symbols start, and the octets before them.
    chunk_start: u16,
    chunk_input_len: usize,
    /// The counts of the symbols before `chunk_start`, end-of-block's included; after a cut, the
    /// counts of the symbols carried, without it.
    literal_length_counts: [constants.literal_length_used]u16,
    distance_counts: [constants.distance_used]u16,
    /// The symbols before the window's last slide, and the octets they cover, which left it.
    slid_count: u16,
    slid_len: usize,
    /// After a cut, the symbols past `symbol_count` that start the next block, and their octets.
    carried_count: u16,
    carried_len: usize,
    /// The price of the symbols before `chunk_start` as a block, 0 when not known; after a cut, of
    /// the symbols carried.
    before_price: u64,
    /// The last check's prices, of all the block's symbols and of its newest as a block of their
    /// own, 0 when not known, and the symbols the block held then: the prices hold while it holds
    /// as many.
    together_price: u64,
    newest_price: u64,
    priced_count: u16,
};

/// Starts a block's split state: no slide, nothing carried, no check yet, and the newest symbols
/// from its end.
pub fn start(block: *Block, split: *Split) void {
    split.slid_count = 0;
    split.slid_len = 0;
    split.carried_count = 0;
    split.carried_len = 0;
    split.together_price = 0;
    split.newest_price = 0;
    split.priced_count = 0;
    begin_chunk(block, split);
}

/// Starts the newest symbols at the block's end, and its next check `block_chunk_symbols` after.
/// The symbols before them take the last check's price of the block, when it priced the block as
/// it stands: after a check that found no split, the next check's rest is that check's whole
/// block.
pub fn begin_chunk(block: *Block, split: *Split) void {
    split.before_price = last_price(block, split, split.together_price);
    split.chunk_start = block.symbol_count;
    split.chunk_input_len = block.input_len;
    split.literal_length_counts = block.literal_length_counts;
    split.distance_counts = block.distance_counts;
    block.limit = @min(block.symbol_count + constants.block_chunk_symbols, constants.block_symbols_max);
}

/// `checked`, one of the last check's prices, when the block holds the symbols that check priced;
/// else 0, not known.
fn last_price(block: *const Block, split: *const Split, checked: u64) u64 {
    return if (split.priced_count == block.symbol_count) checked else 0;
}

/// Whether the block's newest symbols code in fewer bits in a block of their own than with the
/// rest, each block priced by its symbols' entropy and an estimated header. A block's first
/// symbols have no rest.
pub fn splits(block: *Block, split: *Split) bool {
    assert(block.symbol_count > split.chunk_start);
    // With nothing carried, `split`'s counts are those of the block's first symbols, none above
    // the count of all of them.
    assert(split.carried_count == 0);
    split.priced_count = block.symbol_count;
    split.together_price = 0;
    split.newest_price = 0;
    if (split.chunk_start == 0) return false;
    const known = split.before_price;
    const before = if (known != 0) known else price.block(&split.literal_length_counts, &split.distance_counts);
    const priced = price.check(&block.literal_length_counts, &split.literal_length_counts, &block.distance_counts, &split.distance_counts);
    split.together_price = priced.together;
    split.newest_price = priced.newest_block;
    const partial = block.symbol_count - split.chunk_start < constants.block_chunk_symbols;
    const margin = if (partial) priced.together / constants.partial_chunk_margin_divisor else 0;
    return before + priced.newest + margin < priced.together;
}

/// Ends the block before its newest symbols, which start the next block once it is written, at
/// the price the last check gave them.
pub fn cut_at_chunk(block: *Block, split: *Split) void {
    cut(block, split, split.chunk_start, split.chunk_input_len, last_price(block, split, split.newest_price));
}

/// Ends the block before the window's last slide: its symbols after the slide start the next
/// block. The counts of those before are counted again, as no check kept them.
pub fn cut_at_slide(block: *Block, split: *Split) void {
    assert(split.slid_count > 0);
    @memset(&split.literal_length_counts, 0);
    @memset(&split.distance_counts, 0);
    split.literal_length_counts[constants.end_of_block] = 1;
    for (block.symbols[0..split.slid_count]) |symbol| {
        if (symbol.distance == 0) {
            split.literal_length_counts[symbol.value] += 1;
        } else {
            split.literal_length_counts[constants.first_length_symbol + block_module.length_code_of(symbol.value)] += 1;
            split.distance_counts[symbol.distance_code] += 1;
        }
    }
    cut(block, split, split.slid_count, split.slid_len, 0);
}

/// Keeps the block's first `at` symbols, their counts those in `split`, and holds the rest, with
/// their counts in `split`, for the next block; `carried_price` is the rest's price as a block, 0
/// when not known.
fn cut(block: *Block, split: *Split, at: u16, input_len_before: usize, carried_price: u64) void {
    assert(at > 0 and at < block.symbol_count);
    swap_carried(&block.literal_length_counts, &split.literal_length_counts);
    swap_carried(&block.distance_counts, &split.distance_counts);
    assert(block.literal_length_counts[constants.end_of_block] == 1);
    split.carried_count = block.symbol_count - at;
    split.carried_len = block.input_len - input_len_before;
    split.before_price = carried_price;
    block.symbol_count = at;
    block.input_len = input_len_before;
}

/// Leaves in `all` the counts in `before`, and in `before` those `all` held beyond them.
fn swap_carried(all: []u16, before: []u16) void {
    for (all, before) |*all_count, *before_count| {
        const carried = all_count.* - before_count.*;
        all_count.* = before_count.*;
        before_count.* = carried;
    }
}

/// Undoes `cut`: the block holds all its symbols again, its newest starting where they did.
pub fn uncut(block: *Block, split: *Split) void {
    assert(split.carried_count > 0);
    swap_kept(&block.literal_length_counts, &split.literal_length_counts);
    swap_kept(&block.distance_counts, &split.distance_counts);
    block.symbol_count += split.carried_count;
    block.input_len += split.carried_len;
    split.carried_count = 0;
    split.carried_len = 0;
    split.before_price = 0;
}

/// Undoes `swap_carried`: `kept` holds all the counts again, and `carried` those `kept` held.
fn swap_kept(kept: []u16, carried: []u16) void {
    for (kept, carried) |*kept_count, *carried_count| {
        const before = kept_count.*;
        kept_count.* = before + carried_count.*;
        carried_count.* = before;
    }
}

/// Keeps the block across a slide of the window: its symbols so far can only be coded from here,
/// and its newest symbols start after them. The caller moves `input_start` past the slide.
pub fn commit(block: *Block, split: *Split) void {
    assert(block.symbol_count > 0 and split.carried_count == 0);
    split.slid_count = block.symbol_count;
    split.slid_len = block.input_len;
    begin_chunk(block, split);
}

/// Starts the next block with the symbols the last cut held, once the block before them is
/// written. Their octets follow its octets in the window.
pub fn carry(block: *Block, split: *Split) void {
    const count = split.carried_count;
    assert(count > 0 and block.symbol_count > 0);
    const from = block.symbol_count;
    const carried_price = split.before_price;
    @memmove(block.symbols[0..count], block.symbols[from..][0..count]);
    block.literal_length_counts = split.literal_length_counts;
    block.literal_length_counts[constants.end_of_block] = 1;
    block.distance_counts = split.distance_counts;
    block.input_start += block.input_len - split.slid_len;
    block.input_len = split.carried_len;
    block.symbol_count = count;
    start(block, split);
    split.before_price = carried_price;
}

const testing = std.testing;
const codec = @import("codec");

/// A block and its split state, started as the encoder starts them.
const Started = struct {
    block: Block,
    split: Split,

    fn init(self: *Started, input_start: usize) void {
        self.block.reset(input_start);
        start(&self.block, &self.split);
    }
};

/// Adds `count` literals to `block`, drawn from `letters` letters from `first` on.
fn add_letters(block: *Block, count: usize, first: u8, letters: u8, seed: u64) void {
    var generator = codec.split.Generator.init(seed);
    for (0..count) |_| block.add_literal(first + @as(u8, @intCast(generator.below(letters))));
}

test "newest symbols split off when they share no literal with the rest, and stay when alike" {
    var state: Started = undefined;
    state.init(0);
    const block = &state.block;
    const split = &state.split;
    add_letters(block, constants.block_chunk_symbols, 'a', test_letters, 1);
    // A block's first symbols have no rest to split from.
    try testing.expect(!splits(block, split));
    begin_chunk(block, split);
    add_letters(block, constants.block_chunk_symbols, 'A', test_letters, 2);
    try testing.expect(splits(block, split));
    state.init(0);
    add_letters(block, constants.block_chunk_symbols, 'a', test_letters, 3);
    begin_chunk(block, split);
    add_letters(block, constants.block_chunk_symbols, 'a', test_letters, 4);
    try testing.expect(!splits(block, split));
}

const test_letters = 16;

/// Adds the symbols the price test's blocks hold after their first: letters, one literal many
/// times, and pairs.
fn add_newest(block: *Block) void {
    add_letters(block, newest_letters, 'A', test_letters, newest_seed);
    for (0..newest_repeats) |_| block.add_literal('z');
    for (0..newest_pairs) |index| block.add_pair(constants.match_len_min + index % newest_pair_lens, 1 + index % newest_pair_distances);
}

const newest_letters = 1200;
const newest_seed = 10;
const newest_repeats = 1100;
const newest_pairs = 500;
const newest_pair_lens = 9;
const newest_pair_distances = 700;

test "a check prices the block and its newest symbols as their counts price alone, and keeps both" {
    var state: Started = undefined;
    state.init(0);
    const block = &state.block;
    const split = &state.split;
    add_letters(block, 3000, 'a', test_letters, 9);
    for (0..1500) |_| block.add_literal('z');
    for (0..800) |index| block.add_pair(3 + index % 250, 1 + index * 37 % 30_000);
    try testing.expect(!splits(block, split));
    begin_chunk(block, split);
    try testing.expectEqual(@as(u64, 0), split.before_price);
    add_newest(block);
    _ = splits(block, split);
    try testing.expectEqual(price.block(&block.literal_length_counts, &block.distance_counts), split.together_price);
    var newest: Block = undefined;
    newest.reset(0);
    add_newest(&newest);
    const newest_price = price.block(&newest.literal_length_counts, &newest.distance_counts);
    try testing.expectEqual(newest_price, split.newest_price);
    // With no split, the next check's rest is this check's block, at its price.
    var joined = state;
    begin_chunk(&joined.block, &joined.split);
    try testing.expectEqual(split.together_price, joined.split.before_price);
    // A symbol more, and the last check's prices no longer hold.
    joined = state;
    joined.block.add_literal('q');
    begin_chunk(&joined.block, &joined.split);
    try testing.expectEqual(@as(u64, 0), joined.split.before_price);
    // With a split, the next block's rest is the newest symbols, at their price.
    cut_at_chunk(block, split);
    carry(block, split);
    try testing.expectEqual(newest_price, split.before_price);
    try testing.expectEqual(newest_price, price.block(&split.literal_length_counts, &split.distance_counts));
}

/// Requires `block`'s counts to be those of its symbols, end-of-block's included.
fn expect_counts(block: *const Block) !void {
    var literal_length = [_]u16{0} ** constants.literal_length_used;
    var distance = [_]u16{0} ** constants.distance_used;
    literal_length[constants.end_of_block] = 1;
    for (block.symbols[0..block.symbol_count]) |symbol| {
        if (symbol.distance == 0) {
            literal_length[symbol.value] += 1;
        } else {
            literal_length[constants.first_length_symbol + block_module.length_code_of(symbol.value)] += 1;
            distance[symbol.distance_code] += 1;
        }
    }
    try testing.expectEqualSlices(u16, &literal_length, &block.literal_length_counts);
    try testing.expectEqualSlices(u16, &distance, &block.distance_counts);
}

test "a cut keeps the symbols before it, uncut gives all back, and carry starts the next block" {
    var state: Started = undefined;
    state.init(100);
    const block = &state.block;
    const split = &state.split;
    add_letters(block, 3000, 'a', test_letters, 5);
    for (0..1000) |index| block.add_pair(4 + index % 50, 1 + index % 30_000);
    begin_chunk(block, split);
    const before = block.symbol_count;
    const before_len = block.input_len;
    add_letters(block, 500, 'A', test_letters, 6);
    for (0..700) |index| block.add_pair(3 + index % 200, 7 + index);
    // The check prices the symbols the cut holds back.
    _ = splits(block, split);
    const all = state;
    cut_at_chunk(block, split);
    try testing.expectEqual(before, block.symbol_count);
    try testing.expectEqual(before_len, block.input_len);
    try testing.expectEqual(all.split.newest_price, split.before_price);
    try expect_counts(block);
    uncut(block, split);
    try testing.expectEqual(all.block.symbol_count, block.symbol_count);
    try testing.expectEqualSlices(u16, &all.block.literal_length_counts, &block.literal_length_counts);
    try testing.expectEqualSlices(u16, &all.block.distance_counts, &block.distance_counts);
    try testing.expectEqual(@as(u64, 0), split.before_price);
    cut_at_chunk(block, split);
    carry(block, split);
    try testing.expectEqual(all.block.symbol_count - before, block.symbol_count);
    try testing.expectEqual(all.block.input_len - before_len, block.input_len);
    try testing.expectEqual(100 + before_len, block.input_start);
    try testing.expectEqualSlices(Symbol, all.block.symbols[before..all.block.symbol_count], block.symbols[0..block.symbol_count]);
    try expect_counts(block);
}

test "a cut at the last slide counts the symbols before it again" {
    var state: Started = undefined;
    state.init(0);
    const block = &state.block;
    const split = &state.split;
    add_letters(block, 2000, 'a', test_letters, 7);
    for (0..300) |index| block.add_pair(5 + index % 9, 1 + index % 4000);
    commit(block, split);
    const slid = block.symbol_count;
    const slid_len = block.input_len;
    block.input_start = 9;
    add_letters(block, 900, 'Q', test_letters, 8);
    cut_at_slide(block, split);
    try testing.expectEqual(slid, block.symbol_count);
    try testing.expectEqual(slid_len, block.input_len);
    try expect_counts(block);
    carry(block, split);
    try testing.expectEqual(@as(u16, 900), block.symbol_count);
    try testing.expectEqual(@as(usize, 9), block.input_start);
    try expect_counts(block);
}
