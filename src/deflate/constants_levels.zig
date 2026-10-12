//! The DEFLATE encoder's levels (decisions 12 and 13) and the limits of their searches. A piece of
//! constants.zig, which stays the module's entry point and gives every name here as its own.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const match_len_max = constants.match_len_max;
const match_len_taken_min = constants.match_len_taken_min;

/// A level's match finder (decisions 12 and 13): the bits of its hash; whether it keeps a chain of
/// the earlier positions with the same hash; how many candidates it tries at a position; the match
/// length that ends its search; and the match length at or above which it takes a match at once,
/// rather than trying the next position first (its lazy step). A level without chains is greedy.
pub const Level = struct {
    hash_bits: u5,
    chains: bool,
    candidates_max: u16,
    nice_len: u16,
    lazy_len: u16,
    /// The lazy step's search tries at most `cut_candidates_max` candidates, a quarter or a third
    /// of `candidates_max`, when the match waiting from the position before is at least `cut_len`
    /// long, as a longer match then saves less. Design §8 step 9 records what the cut saves and
    /// what it costs.
    cut_len: u16,
    cut_candidates_max: u16,
    /// The greedy level makes the positions a match covers, after its first, heads too, for a match
    /// at most this long: a later match may start there, and the head then names the nearest
    /// position. A level with chains inserts every covered position and ignores this.
    covered_insert_len_max: u16,
    /// Whether the lazy step's search runs inline in its loop, over a window padded so that the
    /// search's loads carry no bounds check (`encoder_window_padding_len`). Level 6's does: most
    /// of its searches read a link or two, and a call's own cost is a large share of those.
    /// Level 9's searches run long, and it calls `best`.
    walks_inline: bool,
    /// Whether a search moves from the chain it follows to the chain of its match's tail, the 4
    /// octets a longer match holds too, when fewer candidates remain there (`best_by_tail`,
    /// decisions 46 and 48). The lazy levels do, outside a block of cheap literals: level 9's
    /// chains run to thousands of candidates, and level 6 finds in 24 links what 64 candidates
    /// of the position's own chain gave it. Such a search counts the links it reads against
    /// `candidates_max` and `cut_candidates_max`, the ones a move passes included.
    tail_chains: bool,
    /// Such a search tries a move to the tail's chain only where its own chain could still name
    /// this many candidates in reach, counted as the reach left over the gap to its next
    /// candidate: fewer cost less to read than a move costs to try, the tail's head, the links it
    /// passes and a branch that goes either way. Level 9 has 16: with 4, x-ray and shuffled dickens
    /// ran 1% to 2% slower on the runners and most other files 1% to 3% faster (decision 46).
    /// Level 6 has 48: with 16 an M1 ran six of the nine text files 1% to 5% slower than main, and
    /// with 64 level 6 wrote more than libdeflate at the mean of the 39 rows (decision 48).
    tail_move_candidates_min: u16,
    /// In a block whose literals are cheap (`cheap_literal_cost_max`), the candidates a search
    /// tries at a position. Such data, DNA's four letters say, holds long chains of short matches
    /// that the block's prices turn away, and a full budget walks them at every literal (decision
    /// 42).
    cheap_candidates_max: u16,
    /// Whether the level checks its blocks' newest symbols, and lets a block cross a slide of the
    /// window (decision 44). The lazy levels do. The greedy level ends its blocks where it did: a
    /// check and the blocks it adds cost its speed more than they take off its output.
    block_checks: bool,
    /// What decision 12 budgets for the encoder's state at this level.
    state_budget_len: usize,
};

/// The prices of a lazy level's block whose literals are cheap count eighths of a bit, fine enough
/// for the bits the literals' share of the block's symbols adds to each (decision 42).
pub const cost_eighths_per_bit = 8;

/// A lazy level prices its matches in a block after one whose literals cost at most this, in
/// eighths of a bit, among themselves: there a short match far back costs more than the literals
/// it covers (decision 42). Two and a quarter bits: DNA's four letters cost two, E.coli's blocks
/// 15 to 17 eighths, and the corpus's next cheapest block, one of xml's at level 9, 19.
pub const cheap_literal_cost_max = 2 * cost_eighths_per_bit + cost_eighths_per_bit / 4;

/// The octets of a match that its price counts one by one: the rest count at the literals' average
/// (decision 42).
pub const priced_len_max = 8;

/// What a match's distance costs the lazy step, in octets of literals, when it compares the match
/// waiting from the position before with the next position's: a farther match must be longer by
/// this much to win. A distance code's extra bits grow with the distance (RFC 1951 §3.2.5), about
/// one literal's code per 6: none under the first bound, one under the second, and so on. Each
/// bound is a power of two, so a distance's bit length names its penalty.
pub const lazy_distance_penalty_bounds = [_]u16{ 32, 512, 4096 };
pub const lazy_distance_penalty_octets = [_]u8{ 0, 1, 2, 3 };

comptime {
    assert(lazy_distance_penalty_octets.len == lazy_distance_penalty_bounds.len + 1);
    for (lazy_distance_penalty_bounds) |bound| assert(std.math.isPowerOfTwo(bound));
}

/// The links a search reads on the chain of its match's tail to pass the candidates it has tried
/// already, before it keeps the chain it follows instead: positions that close together say the
/// tail's octets recur as often as the ones the search follows (`best_by_tail`, decision 46).
pub const tail_skips_max = 4;

/// The levels of decision 13.
pub const encoder_levels = [_]u4{ 1, 6, 9 };

/// A level's parameters.
pub fn level(comptime number: u4) Level {
    return switch (number) {
        1 => .{ .hash_bits = 14, .chains = false, .candidates_max = 1, .nice_len = match_len_max, .lazy_len = 0, .cut_len = match_len_max, .cut_candidates_max = 1, .covered_insert_len_max = 8, .walks_inline = false, .tail_chains = false, .tail_move_candidates_min = 1, .cheap_candidates_max = 1, .block_checks = false, .state_budget_len = 163 * 1024 },
        6 => .{ .hash_bits = 15, .chains = true, .candidates_max = 24, .nice_len = 128, .lazy_len = 32, .cut_len = 8, .cut_candidates_max = 8, .covered_insert_len_max = 0, .walks_inline = true, .tail_chains = true, .tail_move_candidates_min = 48, .cheap_candidates_max = 16, .block_checks = true, .state_budget_len = 261 * 1024 },
        9 => .{ .hash_bits = 15, .chains = true, .candidates_max = 4096, .nice_len = match_len_max, .lazy_len = match_len_max, .cut_len = 8, .cut_candidates_max = 1024, .covered_insert_len_max = 0, .walks_inline = false, .tail_chains = true, .tail_move_candidates_min = 16, .cheap_candidates_max = 32, .block_checks = true, .state_budget_len = 260 * 1024 },
        else => @compileError("the DEFLATE encoder's levels are 1, 6 and 9 (decision 13)"),
    };
}

comptime {
    // A cut search still tries a candidate, and never more than the full search.
    for (encoder_levels) |number| {
        const chosen = level(number);
        assert(chosen.cut_candidates_max >= 1 and chosen.cut_candidates_max <= chosen.candidates_max);
        assert(chosen.cut_len >= match_len_taken_min);
        // A block with cheap literals still tries a candidate, and no more than a search's budget.
        assert(chosen.cheap_candidates_max >= 1 and chosen.cheap_candidates_max <= chosen.candidates_max);
        // A search that moves between chains needs the level's chains and a count for its moves.
        assert(!chosen.tail_chains or chosen.chains);
        assert(chosen.tail_move_candidates_min >= 1);
    }
}
