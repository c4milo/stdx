//! Level 6's dear blocks' lazy loop in aarch64 assembly (decision 59, which amends decision 53 for
//! this loop): `advance_lazy` in `encoder_match_dear.zig`, with its 3-octet table, its `find`, its
//! lazy step by decision 36's score and the tail's walk inline, deciding the positions the Zig
//! loop decides into the same symbols. Its search, links, compare and moves are decision 53's
//! text.
//!
//! Its reads and writes go by address, under decision 53's bounds; the 3-octet table's hash's bits
//! keep each of its heads inside the table, and an octet each count inside its counts.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const block_module = @import("../encoder_block.zig");
const Block = block_module.Block;
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const loop_text = @import("encoder_match_lazy_aarch64_template.zig");
const dear_text = @import("encoder_match_dear_aarch64_template.zig");
const three_module = @import("encoder_match_three.zig");
const Three = three_module.Three;
const lazy_aarch64 = @import("encoder_match_lazy_aarch64.zig");

/// The level the assembly decides for: decision 53's.
pub const level_number = lazy_aarch64.level_number;

/// Whether the assembly takes the dear blocks' loop: where decision 53's loop takes the plain one.
pub fn takes(comptime level: constants.Level) bool {
    return lazy_aarch64.takes(level, false);
}

/// The loop's state, as the assembly reads and writes it: every field 8 octets, at the offsets
/// `template_arguments` names.
const State = extern struct {
    window: [*]const u8,
    heads: [*]u16,
    chain: [*]u16,
    symbols: [*]block_module.Symbol,
    literal_length_counts: [*]u16,
    /// The next position, and the block's symbols.
    position: u64,
    count: u64,
    /// The match waiting from the position before, and whether it waits.
    previous_len: u64,
    previous_distance: u64,
    waiting: u64,
    /// The first position the loop does not decide.
    end: u64,
    near_codes: [*]const block_module.CodeIndex,
    far_codes: [*]const block_module.CodeIndex,
    length_codes: [*]const block_module.CodeIndex,
    distance_counts: [*]u16,
    /// The 3-octet table's heads, and the counts its verdict reads.
    three_heads: [*]u16,
    three_octets: [*]u16,
    three_distances: [*]u16,
    /// The table's 3-octet match at the position `find` last probed, or none.
    three_len: u64,
    three_distance: u64,
};

/// `advance_lazy` of the dear blocks for a caller that checked `takes`.
pub fn advance(comptime level: constants.Level, self: *Matcher(level), block: *Block, three: *Three) void {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(takes(level));
    assert(three.live);
    const lookahead = match.lookahead_end(level, self) orelse return;
    // The end is bounded by the window too, so every position the loop inserts, a match's
    // included, fits 16 bits, and a match's compare reads inside the window.
    const end = @min(lookahead, constants.encoder_window_len - constants.lookahead_min + 1);
    // The symbols cover the octets from the first position no symbol covers yet, as they stand at
    // the loop's start and end.
    const covered_from = self.position - @intFromBool(self.waiting);
    assert(block.symbol_count <= constants.block_symbols_max);
    assert(self.waiting or self.previous.len == 0);
    var state: State = .{
        .window = &self.window,
        .heads = &self.heads,
        .chain = &self.chain,
        .symbols = &block.symbols,
        .literal_length_counts = &block.literal_length_counts,
        .position = self.position,
        .count = block.symbol_count,
        .previous_len = self.previous.len,
        .previous_distance = self.previous.distance,
        .waiting = @intFromBool(self.waiting),
        .end = end,
        .near_codes = &block_module.near_codes,
        .far_codes = &block_module.far_codes,
        .length_codes = &block_module.length_codes,
        .distance_counts = &block.distance_counts,
        .three_heads = &three.heads,
        .three_octets = &three.octets,
        .three_distances = &three.distances,
        .three_len = 0,
        .three_distance = 0,
    };
    execute(&state);
    // The loop moves forward, a match past the end by less than its length, and adds a symbol at
    // most for each position it decides.
    assert(state.position >= self.position and state.position < @max(end, self.position) + constants.match_len_max);
    assert(state.count >= block.symbol_count and state.count <= constants.block_symbols_max);
    assert(state.waiting <= 1 and (state.waiting == 1 or state.previous_len == 0));
    self.position = @intCast(state.position);
    self.previous = .{ .len = @intCast(state.previous_len), .distance = @intCast(state.previous_distance) };
    self.waiting = state.waiting == 1;
    block.symbol_count = @intCast(state.count);
    block.input_len += self.position - @intFromBool(self.waiting) - covered_from;
}

/// Decides the positions `State` describes, and stores the state back.
noinline fn execute(state: *State) void {
    asm volatile (template
        :
        : [state] "{x0}" (state),
        : .{
          .memory = true,
          .nzcv = true,
          .x1 = true,
          .x2 = true,
          .x3 = true,
          .x4 = true,
          .x5 = true,
          .x6 = true,
          .x7 = true,
          .x8 = true,
          .x9 = true,
          .x10 = true,
          .x11 = true,
          .x12 = true,
          .x13 = true,
          .x14 = true,
          .x15 = true,
          .x16 = true,
          .x17 = true,
          .x19 = true,
          .x20 = true,
          .x21 = true,
          .x22 = true,
          .x23 = true,
          .x24 = true,
          .x25 = true,
          .x26 = true,
          .x27 = true,
          .x28 = true,
        });
}

/// The level's settings the text writes.
const settings_of = constants.level(level_number);

/// The shift of a `cmp` immediate that counts in units of 4096 (`lsl #12`).
const immediate_shift = 12;

/// The octets of a match the compare takes 8 at a time: every whole word of `match_len_max`.
const words_len = constants.match_len_max - constants.match_len_max % @sizeOf(u64);

comptime {
    // The fields `ldp` loads and `stp` stores in pairs are adjacent.
    for ([_][2][]const u8{
        .{ "window", "heads" },         .{ "chain", "symbols" },
        .{ "position", "count" },       .{ "previous_len", "previous_distance" },
        .{ "near_codes", "far_codes" }, .{ "length_codes", "distance_counts" },
    }) |pair| assert(@offsetOf(State, pair[1]) == @offsetOf(State, pair[0]) + @sizeOf(u64));
    // The chain's slot is a position's low 15 bits, its mask 0x7fff; heads, links and counts are
    // 2 octets, symbols 4 (shifts of 1 and 2).
    assert(constants.window_len == 1 << 15 and @sizeOf(u16) == 2 and @sizeOf(block_module.Symbol) == 4);
    // A symbol's length less 3 in bits 0 to 7, its distance in 8 to 23, its code from 24.
    assert(@bitOffsetOf(block_module.Symbol, "value") == 0 and @bitOffsetOf(block_module.Symbol, "distance") == 8);
    assert(@bitOffsetOf(block_module.Symbol, "distance_code") == 24 and @sizeOf(block_module.CodeIndex) == 1);
    // The hash of 4 octets: the product's top `hash_bits` bits (`hash_of_word`).
    assert(constants.hash_len == @sizeOf(u32) and settings_of.hash_bits < @bitSizeOf(u32));
    // The count's bound as a 12-bit immediate shifted by 12.
    assert(constants.block_symbols_max % (1 << 12) == 0 and constants.block_symbols_max >> 12 < 1 << 12);
    // Immediates of `cmp` and `mov` the text writes.
    assert(settings_of.lazy_len < 1 << 12 and settings_of.cut_len < 1 << 12 and settings_of.nice_len < 1 << 12);
    assert(settings_of.candidates_max < 1 << 16 and settings_of.cut_candidates_max < 1 << 16 and constants.encoder_distance_max < 1 << 16);
    assert(settings_of.tail_move_candidates_min < 1 << 16 and constants.match_len_taken_min < 1 << 12);
    // A match ends the walk at `nice_len`, which `match_len_max` passes, so the text tests one.
    assert(settings_of.nice_len <= constants.match_len_max);
    // The compare: 32 whole words, then 2 octets.
    assert(words_len + 2 == constants.match_len_max and words_len / @sizeOf(u64) == 32);
    // A tail starts 3 octets before a match's end (`tail_of`).
    assert(constants.match_len_taken_min - 1 == 3);
    // Decision 52's compare: a weight of 4, a shift of 2.
    assert(constants.lazy_length_weight == 1 << 2);
    // The distance codes (`distance_code`): the near table below 256 octets, the far one by 128.
    assert(block_module.near_distances == 256 and block_module.far_distance_shift == 7);
    assert(constants.first_length_symbol == 257 and constants.match_len_min == 3);
    // The tail's skips the text unrolls.
    assert(constants.tail_skips_max == 4);
    // The dear text's pairs and the table: a hash of `three_hash_bits` bits from the product's bits
    // above `three_shift`, heads of 2 octets, counts of 2 octets per octet and per distance code.
    assert(@offsetOf(State, "three_distance") == @offsetOf(State, "three_len") + @sizeOf(u64));
    assert(three_shift == @bitSizeOf(u32) - @bitSizeOf(u8) - constants.three_hash_bits and constants.three_distance_max < 1 << 16);
    // Decision 36's penalty: one octet for each bound a distance reaches, the bounds immediates of
    // `cmp`.
    assert(std.mem.eql(u8, &constants.lazy_distance_penalty_octets, &[_]u8{ 0, 1, 2, 3 }));
    for (constants.lazy_distance_penalty_bounds) |bound| assert(bound < 1 << 12 or bound % (1 << 12) == 0);
    // The settings `best_by_tail` reads at this settings_of.
    assert(settings_of.tail_chains and settings_of.walks_inline and settings_of.lazy_by_bits and settings_of.chains);
}

/// The loop's text, with the offsets and constants it names filled in.
const template = fill(text: {
    var text: []const u8 = loop_text.prologue ++ "\n" ++ dear_text.position ++ "\n" ++ dear_text.find ++ "\n" ++ loop_text.search ++ "\n" ++ loop_text.link ++ "\n";
    for (0..words_len / @sizeOf(u64)) |_| text = text ++ loop_text.compare_word ++ "\n";
    text = text ++ loop_text.compare_end ++ "\n" ++ loop_text.longer ++ "\n";
    for (0..constants.tail_skips_max) |_| text = text ++ loop_text.skip ++ "\n";
    break :text text ++ loop_text.moved ++ "\n" ++ dear_text.decide ++ "\n" ++ dear_text.take ++ "\n" ++ loop_text.exit ++ "\n";
}, template_arguments);

/// The shift of the 3-octet hash in the word's product (`Three.insert`).
const three_shift = @bitSizeOf(u32) - @bitSizeOf(u8) - constants.three_hash_bits;

/// The comptime branches `fill` takes: a few for each octet of the text and each name.
const fill_quota = 10_000_000;

/// `text` with each `{[name]}` of `arguments`' fields replaced by the field's value in decimal.
fn fill(comptime text: []const u8, comptime arguments: anytype) []const u8 {
    @setEvalBranchQuota(fill_quota);
    comptime var out: []const u8 = text;
    inline for (@typeInfo(@TypeOf(arguments)).@"struct".fields) |field| {
        const key = "{[" ++ field.name ++ "]}";
        const value = std.fmt.comptimePrint("{d}", .{@field(arguments, field.name)});
        comptime var replaced: []const u8 = "";
        comptime var at: usize = 0;
        inline while (std.mem.indexOfPos(u8, out, at, key)) |found| {
            replaced = replaced ++ out[at..found] ++ value;
            at = found + key.len;
        }
        out = replaced ++ out[at..];
    }
    // Every name the text writes is filled.
    if (std.mem.indexOf(u8, out, "{[") != null) @compileError("a name of the text has no value");
    return out;
}

const template_arguments = .{
    .window = @offsetOf(State, "window"),
    .chain = @offsetOf(State, "chain"),
    .literal_length_counts = @offsetOf(State, "literal_length_counts"),
    .position = @offsetOf(State, "position"),
    .previous_len = @offsetOf(State, "previous_len"),
    .waiting = @offsetOf(State, "waiting"),
    .end = @offsetOf(State, "end"),
    .near_codes = @offsetOf(State, "near_codes"),
    .length_codes = @offsetOf(State, "length_codes"),
    .multiplier_low = constants.hash_multiplier & std.math.maxInt(u16),
    .multiplier_high = constants.hash_multiplier >> @bitSizeOf(u16),
    .hash_shift = @bitSizeOf(u32) - @as(u32, settings_of.hash_bits),
    .symbols_max_high = constants.block_symbols_max >> immediate_shift,
    .distance_max = constants.encoder_distance_max,
    .lazy_len = settings_of.lazy_len,
    .candidates_max = settings_of.candidates_max,
    .cut_candidates_max = settings_of.cut_candidates_max,
    .cut_len = settings_of.cut_len,
    .nice_len = settings_of.nice_len,
    .words_len = words_len,
    .words_len_plus_one = words_len + 1,
    .tail_back = constants.match_len_taken_min - 1,
    .move_candidates_min = settings_of.tail_move_candidates_min,
    .match_len_taken_min = constants.match_len_taken_min,
    .weight_shift = std.math.log2_int(u32, constants.lazy_length_weight),
    .margin = constants.lazy_bits_margin,
    .far_shift = block_module.far_distance_shift,
    .near_distances = block_module.near_distances,
    .match_len_min = constants.match_len_min,
    .distance_at = @bitOffsetOf(block_module.Symbol, "distance"),
    .code_at = @bitOffsetOf(block_module.Symbol, "distance_code"),
    .first_length_symbol = constants.first_length_symbol,
    .three_heads = @offsetOf(State, "three_heads"),
    .three_octets = @offsetOf(State, "three_octets"),
    .three_distances = @offsetOf(State, "three_distances"),
    .three_len = @offsetOf(State, "three_len"),
    .three_shift = three_shift,
    .three_mask = (1 << constants.three_hash_bits) - 1,
    .three_distance_max = constants.three_distance_max,
    .bound_near = constants.lazy_distance_penalty_bounds[0],
    .bound_middle = constants.lazy_distance_penalty_bounds[1],
    .bound_far = constants.lazy_distance_penalty_bounds[constants.lazy_distance_penalty_bounds.len - 1],
};

test {
    _ = @import("encoder_match_dear_aarch64_test.zig");
}
