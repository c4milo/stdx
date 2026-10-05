//! The prices a lazy level weighs a match with in a block whose literals are cheap (decision 42):
//! what each literal, length and distance cost in the block before, in eighths of a bit. There
//! the lazy step takes a match only when it costs fewer bits than the literals it covers.
//!
//! A literal's code carries the bits of the literals' share of the block's literal/length symbols,
//! log2 of all symbols over the literals. A parse that takes many short matches makes literals
//! rare, and so dear, and the next block's parse, priced by them, takes as many: on DNA's four
//! letters that parse is 7% larger than one of mostly literals. The prices leave the share out, so
//! a literal costs what it costs among literals.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const block_module = @import("../encoder_block.zig");
const Plan = block_module.Plan;
const Block = block_module.Block;
const codec = @import("codec");
const testing = std.testing;

/// The literals, the symbols before end-of-block (RFC 1951 §3.2.5).
const literal_count = constants.end_of_block;

/// What each symbol costs in the block before, in eighths of a bit: its code length, and a
/// length's or distance's extra bits (RFC 1951 §3.2.5).
pub const Costs = struct {
    literal: [literal_count]u8,
    /// By match length.
    length: [constants.match_len_max + 1]u8,
    /// By distance code.
    distance: [constants.distance_used]u8,
    /// The literals' cost, averaged over the block's literals.
    literal_average: u16,
};

/// What a lazy level's encoder keeps for decision 42: whether the block before had cheap literals,
/// and the prices its codes give, which hold only then.
pub const Prices = struct {
    cheap: bool,
    costs: Costs,

    /// No block before the first, so no prices.
    pub fn start(self: *Prices) void {
        self.cheap = false;
    }

    /// Prices the next block from the block just planned, `plan` its codes and `counts` its
    /// literal/length symbols (decision 42).
    pub fn update(self: *Prices, plan: *const Plan, counts: *const [constants.literal_length_used]u16) align(constants.hot_function_alignment) void {
        self.cheap = update_costs(&self.costs, plan, counts);
    }
};

/// Prices the next block from the block just planned, `plan` its codes and `counts` its
/// literal/length symbols, when its literals cost at most `cheap_literal_cost_max` among
/// themselves. Returns whether they do; `costs` holds the prices only then.
pub fn update_costs(costs: *Costs, plan: *const Plan, counts: *const [constants.literal_length_used]u16) bool {
    var symbols: u32 = 0;
    for (counts) |count| symbols += count;
    var literals: u32 = 0;
    var literal_bits: u32 = 0;
    for (counts[0..literal_count], plan.literal_length_lengths[0..literal_count]) |count, len| {
        literals += count;
        literal_bits += @as(u32, count) * len;
    }
    if (literals == 0) return false;
    // End-of-block is a symbol too, so the share is never negative.
    const share = log2_eighths(symbols) - log2_eighths(literals);
    const average = literal_bits * constants.cost_eighths_per_bit / literals;
    if (average -| share > constants.cheap_literal_cost_max) return false;
    fill(costs, plan, counts, share, literals);
    return true;
}

/// Sets every price from `plan`'s code lengths, each literal's less `share`.
fn fill(costs: *Costs, plan: *const Plan, counts: *const [constants.literal_length_used]u16, share: u32, literals: u32) void {
    assert(literals > 0);
    const lengths = &plan.literal_length_lengths;
    var weighted: u32 = 0;
    for (&costs.literal, lengths[0..literal_count], counts[0..literal_count]) |*cost, len, count| {
        // At least a bit: no literal codes in less.
        cost.* = @intCast(@max(eighths(len) -| share, constants.cost_eighths_per_bit));
        weighted += @as(u32, count) * cost.*;
    }
    costs.literal_average = @intCast(weighted / literals);
    for (&costs.length, 0..) |*cost, len| {
        if (len < constants.match_len_min) {
            cost.* = 0;
            continue;
        }
        const code = block_module.length_code(len);
        const extra: u32 = constants.length_extra_bits[code];
        cost.* = @intCast(eighths(lengths[constants.first_length_symbol + code]) + extra * constants.cost_eighths_per_bit);
    }
    for (&costs.distance, plan.distance_lengths, constants.distance_extra_bits) |*cost, len, extra| {
        cost.* = @intCast(eighths(len) + @as(u32, extra) * constants.cost_eighths_per_bit);
    }
}

/// A code length in eighths of a bit. A symbol the block left out costs the longest code.
fn eighths(len: u8) u32 {
    assert(len <= constants.code_len_max);
    return @as(u32, if (len == 0) constants.code_len_max else len) * constants.cost_eighths_per_bit;
}

/// Whether a match of `octets`, `distance` back, costs fewer bits than its octets as literals: its
/// first `priced_len_max` octets priced one by one, the rest at the literals' average. Not inline:
/// only a block with cheap literals calls it.
pub noinline fn saves_bits(costs: *const Costs, octets: []const u8, distance: u16) align(constants.hot_function_alignment) bool {
    assert(octets.len >= constants.match_len_taken_min and octets.len <= constants.match_len_max);
    assert(distance >= 1);
    const priced = octets[0..@min(octets.len, constants.priced_len_max)];
    var literal_cost: u32 = 0;
    for (priced) |octet| literal_cost += costs.literal[octet];
    literal_cost += @as(u32, @intCast(octets.len - priced.len)) * costs.literal_average;
    const match_cost = @as(u32, costs.length[octets.len]) + costs.distance[block_module.distance_code(distance)];
    return literal_cost > match_cost;
}

/// The bits after the leading one that `log2_eighths` reads.
pub const fraction_bits = std.math.log2_int(u32, constants.cost_eighths_per_bit);

/// log2 of `n` in eighths of a bit: the leading one's place, and the eighth the next
/// `fraction_bits` bits give, rounded.
pub fn log2_eighths(n: u32) u32 {
    assert(n > 0);
    const whole: u32 = @bitSizeOf(u32) - 1 - @clz(n);
    const mask = (1 << fraction_bits) - 1;
    const fraction = if (whole >= fraction_bits) (n >> @intCast(whole - fraction_bits)) & mask else (n << @intCast(fraction_bits - whole)) & mask;
    return whole * constants.cost_eighths_per_bit + fraction_eighths[fraction];
}

/// log2(1 + k / 8) in eighths of a bit, rounded, for each fraction k the leading one's next bits
/// give.
pub const fraction_eighths: [1 << fraction_bits]u8 = table: {
    var table: [1 << fraction_bits]u8 = undefined;
    for (&table, 0..) |*entry, k| {
        const fraction: f64 = @as(f64, @floatFromInt(k)) / constants.cost_eighths_per_bit;
        entry.* = @intFromFloat(@round(constants.cost_eighths_per_bit * @log2(1.0 + fraction)));
    }
    break :table table;
};

test "log2 in eighths of a bit is exact at powers of two and within an eighth between" {
    try std.testing.expectEqual(@as(u32, 0), log2_eighths(1));
    try std.testing.expectEqual(@as(u32, 8), log2_eighths(2));
    try std.testing.expectEqual(@as(u32, 13 * 8), log2_eighths(1 << 13));
    for ([_]u32{ 3, 5, 6, 7, 9, 100, 1000, 12345, 16385 }) |n| {
        const exact = constants.cost_eighths_per_bit * @log2(@as(f64, @floatFromInt(n)));
        try std.testing.expect(@abs(@as(f64, @floatFromInt(log2_eighths(n))) - exact) <= 1.0);
    }
}

test "four letters' literals are cheap and priced less their share; text's are not cheap" {
    var block: Block = undefined;
    var plan: Plan = undefined;
    var costs: Costs = undefined;
    var generator = codec.split.Generator.init(5);
    // Four letters a fifth of the symbols, pairs the rest: the letters code in 4 or 5 bits, about
    // 2 among the literals.
    block.reset(0);
    for (0..dna_literals) |_| block.add_literal(dna_letters[generator.below(dna_letters.len)]);
    for (0..dna_pairs) |_| block.add_pair(5 + generator.below(4), 1000 + generator.below(20_000));
    block_module.plan(&block, false, 0, &plan);
    try testing.expect(update_costs(&costs, &plan, &block.literal_length_counts));
    for (dna_letters) |letter| {
        try testing.expect(costs.literal[letter] < @as(u32, plan.literal_length_lengths[letter]) * constants.cost_eighths_per_bit);
    }
    try testing.expect(costs.literal_average <= constants.cheap_literal_cost_max);
    // Forty letters as literals alone: over 5 bits each.
    block.reset(0);
    for (0..text_literals) |_| block.add_literal(@intCast('A' + generator.below(text_letters)));
    block_module.plan(&block, false, 0, &plan);
    try testing.expect(!update_costs(&costs, &plan, &block.literal_length_counts));
}

const dna_letters = "acgt";
const dna_literals = 2000;
const dna_pairs = 8000;
const text_literals = 8000;
const text_letters = 40;

test "a match in a cheap block is taken only when its literals cost more bits" {
    const unit = constants.cost_eighths_per_bit;
    var costs: Costs = undefined;
    @memset(&costs.literal, 2 * unit);
    costs.literal['x'] = 9 * unit;
    costs.literal_average = 3 * unit;
    @memset(&costs.length, 4 * unit);
    for (&costs.distance, constants.distance_extra_bits) |*cost, extra| cost.* = (5 + @as(u8, extra)) * unit;
    // 10,000 back: 12 extra bits, so a match costs 21 bits.
    const far = 10_000;
    try testing.expect(!saves_bits(&costs, "acgtac", far));
    try testing.expect(saves_bits(&costs, "acgtac", 4));
    try testing.expect(saves_bits(&costs, "xxxa", far));
    // Ten letters: 8 priced at 2 bits, 2 at the average's 3, 22 bits.
    try testing.expect(saves_bits(&costs, "acgtacgtac", far));
    // 5,000 back: 11 extra bits, 20 bits, what eight letters and two at the average cost less 2.
    try testing.expect(!saves_bits(&costs, "acgtacgta", 5_000));
    costs.literal_average = 4 * unit;
    // 20 bits each: equal is not fewer.
    try testing.expect(!saves_bits(&costs, "acgtacgta", 5_000));
}
