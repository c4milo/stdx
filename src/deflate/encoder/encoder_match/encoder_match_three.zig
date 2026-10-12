//! Matches of 3 octets at a lazy level (decision 50): what the encoder keeps for them beside the
//! match finder.
//! The finder's hash covers 4 octets, so a match of `match_len_min` comes from a table of its
//! own, the latest position with each hash of 3 octets. Three literals of text cost about what
//! such a match does, and the table costs every position a load and a store, so only a block
//! whose literals are dear keeps it (`encoder_match_dear.zig` holds that block's steps).
//!
//! A block after one that took none takes them when that block's literals were dear (`dear`). A
//! block after one that took them takes them too when they paid there (`paid`): the block's
//! symbols priced by their own frequencies as they are, against the same symbols with each
//! 3-octet match turned back into its three literals. One match's price against its literals
//! cannot tell: a parse that takes many makes the literals left rare, and so dear, which makes
//! the next block's matches look cheaper still, whatever they save. On mr each match looked 5
//! bits cheaper than its literals, and the file came out 1.3% larger.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const block_module = @import("../encoder_block.zig");
const Plan = block_module.Plan;
const Block = block_module.Block;
const Split = @import("../encoder_split.zig").Split;
const match = @import("encoder_match.zig");
const Match = match.Match;

/// The literals, the symbols before end-of-block (RFC 1951 §3.2.5).
const literal_count = constants.end_of_block;

/// A hash of 3 octets: every index of the table and no other.
const Hash = std.meta.Int(.unsigned, constants.three_hash_bits);

/// Where the hash of a word's first 3 octets lies in the product of the whole word and
/// `hash_multiplier`: above the product's low bits, as many as the word shifted by an octet
/// would lose off the top. The product of `word << 8` is this product shifted by an octet, so
/// its top `three_hash_bits` bits are this product's from here up, and depend on the first 3
/// octets alone.
const hash_shift = @bitSizeOf(u32) - @bitSizeOf(u8) - constants.three_hash_bits;

comptime {
    // A block's 3-octet matches hold three octets each, and no count of them wraps.
    assert(constants.match_len_min * constants.block_symbols_max <= std.math.maxInt(u16));
    assert(constants.three_distance_max <= constants.encoder_distance_max);
    // A wait fits its 8 bits, and grows.
    assert(constants.three_wait_max <= std.math.maxInt(u8) and constants.three_wait_growth > 1);
}

/// What the 3-octet table's candidate gives a position: whether it holds all 4 of the position's
/// octets within a match's reach, and the 3-octet match with it, or none.
pub const Probe = struct { four: bool, three: Match };

/// The counts of some symbols: those of a block, or of the symbols a cut holds for the next.
pub const Counts = struct {
    literal_length: *const [constants.literal_length_used]u16,
    distance: *const [constants.distance_used]u16,
};

pub const Three = struct {
    /// The latest position with each hash of 3 octets, kept while `live`.
    heads: [1 << constants.three_hash_bits]u16,
    /// The octets inside the 3-octet matches taken since the last block ended, and those
    /// matches' distance codes.
    octets: [literal_count]u16,
    distances: [constants.distance_used]u16,
    /// Whether the block takes 3-octet matches.
    live: bool,
    /// The block ends to pass before the next try, and what the next block they do not pay in
    /// sets it to.
    wait: u8,
    penalty: u8,

    /// Starts a stream: no 3-octet matches before a block's literals are dear. The table is
    /// cleared when a block first keeps it, so a stream that keeps none pays for no clear.
    pub fn start(self: *Three) void {
        self.live = false;
        self.wait = 0;
        self.penalty = 1;
        self.forget();
    }

    pub fn forget(self: *Three) void {
        @memset(&self.octets, 0);
        @memset(&self.distances, 0);
    }

    /// Moves every position with a slide of the window; one that falls out names position 0.
    pub fn slide(self: *Three) void {
        assert(self.live);
        match.slide_positions(true, &self.heads, constants.window_len);
    }

    /// Makes `at`, whose 4 octets are `word` least significant first, the latest position with
    /// its first 3 octets' hash. Returns the position it takes the place of.
    pub inline fn insert(self: *Three, comptime runtime_safety: bool, word: u32, at: usize) u16 {
        @setRuntimeSafety(runtime_safety);
        // The word's own product, which the chain's hash of 4 octets takes too (`hash_of_word`):
        // one multiply gives both hashes.
        const product = word *% constants.hash_multiplier;
        const index: Hash = @truncate(product >> hash_shift);
        const head = &self.heads[index];
        const before = head.*;
        head.* = @intCast(at);
        return before;
    }

    /// Counts a 3-octet match the block takes: its octets, the first 3 of `word`, and its
    /// distance's code.
    pub inline fn tally(self: *Three, comptime runtime_safety: bool, word: u32, distance_index: block_module.CodeIndex) void {
        @setRuntimeSafety(runtime_safety);
        // No count wraps: a block's symbols are `block_symbols_max` at most, each a match of
        // three octets at most, which the comptime assert above requires to fit 16 bits.
        inline for (0..constants.match_len_min) |index| {
            const octet: u8 = @truncate(word >> (index * @bitSizeOf(u8)));
            self.octets[octet] +%= 1;
        }
        self.distances[distance_index] +%= 1;
    }

    /// `update` at the end of `block`, whose plan is `plan`: with the block's counts, and those
    /// of the symbols `split` carries to the next block when a cut holds some. With none
    /// carried, `split`'s counts are of the block's own first symbols, and are left out.
    pub fn end_block(self: *Three, plan: *const Plan, cheap: bool, block: *const Block, split: *const Split) void {
        const counts: Counts = .{ .literal_length = &block.literal_length_counts, .distance = &block.distance_counts };
        const carried: Counts = .{ .literal_length = &split.literal_length_counts, .distance = &split.distance_counts };
        self.update(plan, cheap, counts, if (split.carried_count > 0) carried else null);
    }

    /// At a block's end, the stream's last excepted: decides whether the next block takes
    /// 3-octet matches. `plan` is the block's, and `block` its counts, as `dear` reads them.
    /// `carried` holds the counts of the symbols a cut holds for the next block, or null: `paid`
    /// reads every symbol added since the last block ended, as the matches were counted. A
    /// block of cheap literals (decision 42) takes none.
    pub fn update(self: *Three, plan: *const Plan, cheap: bool, block: Counts, carried: ?Counts) void {
        const was = self.live;
        if (was) {
            self.live = self.paid_since(block, carried);
            if (self.live) self.penalty = 1 else self.fail();
        } else if (self.wait > 0) {
            self.wait -= 1;
        } else {
            self.live = dear(plan, block.literal_length);
        }
        if (cheap) self.live = false;
        // The table holds nothing of the blocks that did not keep it.
        if (self.live and !was) @memset(&self.heads, 0);
        self.forget();
    }

    /// After a block the matches did not pay in: waits `penalty` block ends, and
    /// `three_wait_growth` times as many the next time in a row, `three_wait_max` at most.
    fn fail(self: *Three) void {
        self.wait = self.penalty;
        // In 16 bits: the product passes the wait's 8 before the cut to `three_wait_max`.
        const grown = @as(u16, self.penalty) * constants.three_wait_growth;
        self.penalty = @intCast(@min(grown, constants.three_wait_max));
    }

    /// `paid` over the block's symbols and the carried ones together.
    fn paid_since(self: *const Three, block: Counts, carried: ?Counts) bool {
        var literal_length = block.literal_length.*;
        var distance = block.distance.*;
        if (carried) |more| {
            // Both are counts of one block's symbols, 16,385 at most together.
            for (&literal_length, more.literal_length) |*all, count| all.* += count;
            for (&distance, more.distance) |*all, count| all.* += count;
        }
        return self.paid(&literal_length, &distance);
    }

    /// Whether the 3-octet matches taken since the last block ended saved
    /// `three_saving_divisor`'s share of what the symbols cost without them: both priced by the
    /// symbols' own frequencies (`entropy`), with the extra bits the matches' distances add.
    pub fn paid(self: *const Three, literal_length: *const [constants.literal_length_used]u16, distance: *const [constants.distance_used]u16) bool {
        var without_literal_length = literal_length.*;
        var without_distance = distance.*;
        var taken: u32 = 0;
        var extra: u64 = 0;
        for (&without_distance, self.distances, constants.distance_extra_bits) |*all, three, extra_bits| {
            // Every match counted is among the symbols.
            const moved = @min(all.*, three);
            all.* -= moved;
            taken += moved;
            extra += @as(u64, moved) * extra_bits;
        }
        if (taken == 0) return false;
        without_literal_length[constants.first_length_symbol] -|= @intCast(taken);
        for (without_literal_length[0..literal_count], self.octets) |*all, inside| all.* +|= inside;
        const with = entropy(literal_length) + entropy(distance) + extra * fine_per_bit;
        const without = entropy(&without_literal_length) + entropy(&without_distance);
        return saves(with, without);
    }
};

/// Whether symbols that cost `with` save `three_saving_divisor`'s share of `without`, what they
/// cost with no 3-octet match.
pub fn saves(with: u64, without: u64) bool {
    return with + without / constants.three_saving_divisor < without;
}

/// What `candidate`, the position `Three.insert` gave, holds of `word`, the 4 octets at
/// `position`, on no branch: data whose literals are dear answers each either way about as
/// often. `four`: all 4 within `encoder_distance_max`, at the nearest position that holds them,
/// as none nearer holds even 3; position 0 names no candidate of a search. `three`: the match
/// with it when it holds the first 3 within `three_distance_max`. There position 0 is read as
/// any other position: the octets at it are the window's, and a match with them is a match.
pub inline fn probe(comptime runtime_safety: bool, window: []const u8, position: usize, word: u32, candidate: u16) Probe {
    @setRuntimeSafety(runtime_safety);
    const differ = word ^ std.mem.readInt(u32, window[candidate..][0..constants.hash_len], .little);
    // Neither difference wraps in an encoder. The table names a position before this one, or 0.
    // And this one is not 0: a block that takes these matches follows a block with a literal,
    // and a slide leaves the position past `window_len` less the lookahead. A test may give
    // position 0 its own: there the second wraps to the largest value, which names no match.
    const beyond = position -% candidate -% 1;
    const four = @intFromBool(differ == 0) & @intFromBool(candidate != 0) & @intFromBool(beyond < constants.encoder_distance_max);
    const three = @intFromBool(differ << @bitSizeOf(u8) == 0) & @intFromBool(beyond < constants.three_distance_max);
    // The sum is a distance within `three_distance_max`.
    return .{ .four = four != 0, .three = if (three != 0) .{ .len = constants.match_len_min, .distance = @intCast(beyond +% 1) } else .{} };
}

/// Whether a block's literals are dear: their codes, of `plan`'s lengths, take at least
/// `dear_literal_cost_min` each at the mean, and `dear_symbol_cost_min` for each of the block's
/// literal/length symbols.
pub fn dear(plan: *const Plan, counts: *const [constants.literal_length_used]u16) bool {
    var symbols: u32 = 0;
    for (counts) |each| symbols += each;
    var literals: u32 = 0;
    var literal_bits: u32 = 0;
    for (counts[0..literal_count], plan.literal_length_lengths[0..literal_count]) |each, len| {
        literals += each;
        literal_bits += @as(u32, each) * len;
    }
    const eighths = literal_bits * constants.cost_eighths_per_bit;
    return eighths >= literals * constants.dear_literal_cost_min and eighths >= symbols * constants.dear_symbol_cost_min;
}

/// The units of `log2_fine` in a bit. `log2_eighths` reads 3 bits after a count's leading one
/// and is up to a sixth of a bit under, more than `three_saving_divisor` tells apart; with 8
/// bits the log2 is under by less than a 100th.
pub const fine_per_bit = 256;
const fine_bits = std.math.log2_int(u32, fine_per_bit);

/// The comptime branches building `fine_table` takes.
const fine_table_quota = 10_000;

/// log2(1 + k / 256) in 256ths of a bit, rounded, for each k under 256.
const fine_table: [fine_per_bit]u16 = table: {
    @setEvalBranchQuota(fine_table_quota);
    var table: [fine_per_bit]u16 = undefined;
    for (&table, 0..) |*entry, k| {
        const fraction: f64 = @as(f64, @floatFromInt(k)) / fine_per_bit;
        entry.* = @intFromFloat(@round(fine_per_bit * @log2(1.0 + fraction)));
    }
    break :table table;
};

/// log2 of `n` in 256ths of a bit: the leading one's place, and the table's entry for the 8 bits
/// after it.
pub fn log2_fine(n: u32) u32 {
    assert(n > 0);
    const whole: u32 = @bitSizeOf(u32) - 1 - @clz(n);
    const mask = fine_per_bit - 1;
    const fraction = if (whole >= fine_bits) (n >> @intCast(whole - fine_bits)) & mask else (n << @intCast(fine_bits - whole)) & mask;
    return whole * fine_per_bit + fine_table[fraction];
}

/// What symbols with these counts cost coded by their own frequencies, in 256ths of a bit, with
/// `header_estimate_symbol_bits` for each symbol with a count, as a check of decision 44 counts
/// a header.
pub fn entropy(counts: []const u16) u64 {
    var total: u32 = 0;
    var weighted: u64 = 0;
    var used: u32 = 0;
    for (counts) |each| {
        if (each == 0) continue;
        total += each;
        weighted += @as(u64, each) * log2_fine(each);
        used += 1;
    }
    if (total == 0) return 0;
    // No count's log2 is above the total's, so the weighted sum is the total's at most.
    return @as(u64, total) * log2_fine(total) - weighted + @as(u64, used) * constants.header_estimate_symbol_bits * fine_per_bit;
}

test {
    _ = @import("encoder_match_three_test.zig");
}
