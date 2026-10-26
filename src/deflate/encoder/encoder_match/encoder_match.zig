//! The encoder's match finder: the window of input, the hash heads and chains that find earlier
//! positions with the same four octets, and the walk that turns each position into a literal or a
//! length/distance pair of the block (RFC 1951 §4 describes the method, and leaves it free).
//!
//! A level without chains is greedy: it tries the one earlier position its hash head names and
//! takes the match it finds. A level with chains tries up to `candidates_max` earlier positions,
//! and takes a match only when the next position's is no longer, its lazy step.
//!
//! Every decision reads the window alone, with `lookahead_min` octets ahead of the position or the
//! stream's flush or end, so how the caller splits its input changes nothing (invariant 5). The
//! positions with the whole lookahead ahead go through a loop of their own, where every match may
//! run to `match_len_max` and the step's state stays in locals; the general step takes the rest.
//!
//! Every function of the match finder says whether it keeps Zig's runtime safety checks, with its
//! level's `runtime_safety` or the flag a caller copied from it: the caller's choice of decision
//! 49 (`encoder_safety.zig`).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const Block = @import("../encoder_block.zig").Block;
const Appender = @import("../encoder_block.zig").Appender;
const cost = @import("encoder_match_cost.zig");

/// What the lazy steps read for decision 42: the prices in their priced copy, nothing in the other.
pub fn CostsOf(comptime cheap: bool) type {
    return if (cheap) *const cost.Costs else void;
}
const walk = @import("encoder_match_walk.zig");
const best = walk.best;
const best_inline = walk.best_inline;
const skips_search = walk.skips_search;
const greedy = @import("encoder_match_greedy.zig");
const dear = @import("encoder_match_dear.zig");
const Three = @import("encoder_match_three.zig").Three;
const advance_greedy = greedy.advance_greedy;
const lazy_aarch64 = @import("encoder_match_lazy_aarch64.zig");
const step_greedy = greedy.step_greedy;

/// A match: its length, 0 for none, and its distance.
pub const Match = struct {
    len: u16 = 0,
    distance: u16 = 0,

    /// The match's worth in the lazy step's comparison: its length less what its distance costs in
    /// octets of literals, `lazy_distance_penalty_octets`, so a farther match must be longer to win.
    pub fn score(self: Match, comptime runtime_safety: bool) i32 {
        @setRuntimeSafety(runtime_safety);
        return @as(i32, self.len) - penalty_by_bits[@bitSizeOf(u16) - @clz(self.distance)];
    }

    /// The match's worth where a level compares by bits (`lazy_by_bits`): `lazy_length_weight`
    /// for each octet, less its distance's bit length.
    pub fn bits_score(self: Match, comptime runtime_safety: bool) i32 {
        @setRuntimeSafety(runtime_safety);
        return @as(i32, self.len) * constants.lazy_length_weight - (@bitSizeOf(u16) - @clz(self.distance));
    }
};

/// Whether the lazy step keeps `previous`, the match that waits, over `current`, the next
/// position's. By `score`: when it scores as much. By bits: unless `current` is at least as long
/// and its `bits_score` passes the waiting match's by more than `lazy_bits_margin`.
pub inline fn keeps_waiting(comptime level: constants.Level, previous: Match, current: Match) bool {
    @setRuntimeSafety(level.runtime_safety);
    if (!level.lazy_by_bits) return previous.score(level.runtime_safety) >= current.score(level.runtime_safety);
    if (current.len < previous.len) return true;
    return current.bits_score(level.runtime_safety) <= previous.bits_score(level.runtime_safety) + constants.lazy_bits_margin;
}

/// `lazy_distance_penalty_octets` by a distance's bit length: every distance of one bit length lies
/// between the same bounds, as each bound is a power of two. Bit length 0 is no distance.
const penalty_by_bits: [@bitSizeOf(u16) + 1]u8 = table: {
    var by_bits: [@bitSizeOf(u16) + 1]u8 = undefined;
    for (&by_bits, 0..) |*penalty, bits| {
        const distance_min: u32 = if (bits == 0) 0 else @as(u32, 1) << @intCast(bits - 1);
        var index: usize = 0;
        for (constants.lazy_distance_penalty_bounds) |bound| {
            if (distance_min >= bound) index += 1;
        }
        penalty.* = constants.lazy_distance_penalty_octets[index];
    }
    break :table by_bits;
};

/// A hash of `hash_bits` bits: every index of the heads and no other, so a head read by it needs no
/// bounds check.
fn Hash(comptime level: constants.Level) type {
    return std.meta.Int(.unsigned, level.hash_bits);
}

/// A position's slot in the chain: its low bits, which name every slot and no other.
const Slot = std.meta.Int(.unsigned, std.math.log2_int(usize, constants.window_len));

comptime {
    assert(1 << @bitSizeOf(Slot) == constants.window_len);
}

pub fn Matcher(comptime level: constants.Level) type {
    return struct {
        const Self = @This();

        /// The input, in its first `encoder_window_len` octets, and at level 6, whose walks run
        /// inline (`search`), `encoder_window_padding_len` octets that no read reaches.
        window: [constants.encoder_window_len + (if (level.walks_inline) constants.encoder_window_padding_len else 0)]u8,
        /// The last position with each hash, and for each position the one before it with the same
        /// hash. A position of 0 names none, so the window's first octet is never a candidate.
        heads: [1 << level.hash_bits]u16,
        chain: if (level.chains) [constants.window_len]u16 else void,
        /// The window's octets that hold input, and the next position to decide.
        filled: usize,
        position: usize,
        /// The lazy step: the match found at the position before `position`, which still waits for
        /// its symbol when `waiting` is set.
        previous: Match,
        waiting: bool,

        /// Starts a stream. The heads are cleared, so no position of an earlier stream becomes a
        /// candidate, and the output is a function of this stream's input alone (invariant 5).
        /// Decision 11 allows an encoder's `init` this clear, and no other.
        pub fn init(self: *Self) void {
            @setRuntimeSafety(level.runtime_safety);
            @memset(&self.heads, 0);
            self.filled = 0;
            self.position = 0;
            self.previous = .{};
            self.waiting = false;
        }

        /// Copies what fits of `input` into the window. Returns how many octets.
        pub fn fill(self: *Self, input: []const u8) usize {
            @setRuntimeSafety(level.runtime_safety);
            const len = @min(input.len, constants.encoder_window_len - self.filled);
            @memcpy(self.window[self.filled..][0..len], input[0..len]);
            self.filled += len;
            return len;
        }

        /// Whether the window is full and too few octets lie ahead to go on, so it must slide.
        pub fn must_slide(self: *const Self) bool {
            @setRuntimeSafety(level.runtime_safety);
            return self.filled == constants.encoder_window_len and self.position + constants.lookahead_min > self.filled;
        }

        pub fn slide(self: *Self) void {
            @setRuntimeSafety(level.runtime_safety);
            slide_window(level, self);
        }

        /// The first position no symbol of the block covers yet: the lazy step's waiting one, or the
        /// next.
        pub fn pending_start(self: *const Self) usize {
            @setRuntimeSafety(level.runtime_safety);
            return self.position - @intFromBool(self.waiting);
        }

        pub fn advance(self: *Self, block: *Block, ending: bool) void {
            @setRuntimeSafety(level.runtime_safety);
            if (level.block_checks) advance_rounds(level, false, self, block, ending, {}) else advance_positions(level, false, self, block, ending, {});
        }

        /// `advance` in a block after one with cheap literals, its matches priced by `costs`
        /// (decision 42): a copy of the steps of its own, so every other block runs the steps it
        /// ran before.
        pub fn advance_priced(self: *Self, block: *Block, ending: bool, costs: *const cost.Costs) void {
            @setRuntimeSafety(level.runtime_safety);
            comptime assert(level.chains);
            if (level.block_checks) advance_rounds(level, true, self, block, ending, costs) else advance_positions(level, true, self, block, ending, costs);
        }

        /// `advance` in a block after one with dear literals, which takes matches of 3 octets
        /// from `three`'s table: a third copy of the steps (`encoder_match_dear.zig`).
        pub fn advance_dear(self: *Self, block: *Block, ending: bool, three: *Three) void {
            @setRuntimeSafety(level.runtime_safety);
            dear.advance(level, self, block, ending, three);
        }

        /// Adds the lazy step's waiting symbol when the stream flushes or ends. Returns false, and
        /// adds nothing, when the block is full.
        pub fn settle(self: *Self, block: *Block) bool {
            @setRuntimeSafety(level.runtime_safety);
            assert(self.position == self.filled);
            if (!self.waiting) return true;
            if (block.full()) return false;
            take_previous(level, self, block);
            return true;
        }
    };
}

/// Moves the window's second half to its first, keeping 32 KiB of history, and moves every head
/// and link with it; one that falls out of the window names none.
fn slide_window(comptime level: constants.Level, self: *Matcher(level)) void {
    @setRuntimeSafety(level.runtime_safety);
    assert(self.must_slide());
    const half: u16 = constants.window_len;
    @memcpy(self.window[0..half], self.window[half..constants.encoder_window_len]);
    self.filled -= constants.window_len;
    self.position -= constants.window_len;
    slide_positions(level.runtime_safety, &self.heads, half);
    if (level.chains) slide_positions(level.runtime_safety, &self.chain, half);
}

/// The positions a vector op moves at once.
const slide_vector_len = 16;

/// Subtracts `half` from every position, saturating at 0, none, `slide_vector_len` positions at a
/// time.
pub fn slide_positions(comptime runtime_safety: bool, positions: []u16, half: u16) void {
    @setRuntimeSafety(runtime_safety);
    comptime assert(constants.window_len % slide_vector_len == 0);
    assert(positions.len % slide_vector_len == 0);
    const Vector = @Vector(slide_vector_len, u16);
    const halves: Vector = @splat(half);
    for (0..positions.len / slide_vector_len) |index| {
        const chunk = positions[index * slide_vector_len ..][0..slide_vector_len];
        chunk.* = @as(Vector, chunk.*) -| halves;
    }
}

/// `advance_positions` in rounds that stop at the block's limit (decision 44). A round shows the
/// loops the window only as far as the lookahead of as many positions as the limit leaves
/// symbols: a position decided adds a symbol at most, so the round adds no more. To the loops a
/// round is a call whose input ended there, which changes no decision (invariant 5), so they run
/// the code they ran without a limit. The last positions before a flush or the stream's end, fewer
/// than `lookahead_min`, are decided a step at a time and may pass the limit by as many symbols.
fn advance_rounds(comptime level: constants.Level, comptime cheap: bool, self: *Matcher(level), block: *Block, ending: bool, costs: CostsOf(cheap)) void {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(level.block_checks);
    const filled = self.filled;
    for (0..filled + 1) |_| {
        // The symbols the block takes before its limit.
        const room: usize = block.limit - block.symbol_count;
        assert(room > 0);
        self.filled = @min(filled, self.position + room + (constants.lookahead_min - 1));
        const whole = self.filled == filled;
        advance_positions(level, cheap, self, block, ending and whole, costs);
        if (whole or block.at_limit()) break;
    } else unreachable;
    self.filled = filled;
}

/// Decides positions into `block` while `lookahead_min` octets lie ahead, or up to `filled` when
/// `ending`, until the block is full: the positions with the whole lookahead in their loop first,
/// then the rest a step at a time. Each step adds at most one symbol and moves on a position or
/// more. `cheap` compiles in the prices of decision 42, `costs`. Never inline, so a round calls
/// the code a call ran before the rounds.
noinline fn advance_positions(comptime level: constants.Level, comptime cheap: bool, self: *Matcher(level), block: *Block, ending: bool, costs: CostsOf(cheap)) align(constants.hot_function_alignment) void {
    @setRuntimeSafety(level.runtime_safety);
    if (level.chains) advance_lazy(level, cheap, self, block, costs) else advance_greedy(level, self, block);
    for (0..self.filled + 1) |_| {
        if (block.full()) return;
        const ahead = self.filled - self.position;
        if (ahead == 0 or (!ending and ahead < constants.lookahead_min)) return;
        if (level.chains) step_lazy(level, cheap, self, block, ahead, costs) else step_greedy(level, self, block, ahead);
    }
    unreachable;
}

/// The positions before `end` have `lookahead_min` octets ahead, so a match there may run to
/// `match_len_max` and every position it covers has `hash_len` octets: `end` is the first position
/// without them, or none when the window holds too little.
pub fn lookahead_end(comptime level: constants.Level, self: *const Matcher(level)) ?usize {
    @setRuntimeSafety(level.runtime_safety);
    if (self.filled < constants.lookahead_min) return null;
    return self.filled - constants.lookahead_min + 1;
}

/// The lazy levels' positions with the whole lookahead ahead, decided until the block fills or the
/// lookahead runs out; `step_lazy` takes the positions after them. The step's state, the position
/// and the waiting match, lives in locals through the loop. `cheap` compiles in the prices of
/// decision 42.
fn advance_lazy(comptime level: constants.Level, comptime cheap: bool, self: *Matcher(level), block: *Block, costs: CostsOf(cheap)) void {
    @setRuntimeSafety(level.runtime_safety);
    if (comptime lazy_aarch64.takes(level, cheap)) return lazy_aarch64.advance(level, self, block);
    advance_lazy_zig(level, cheap, self, block, costs);
}

/// `advance_lazy` in Zig: every level, block and target the assembly does not take, and the
/// reference the assembly must match (decision 53).
pub fn advance_lazy_zig(comptime level: constants.Level, comptime cheap: bool, self: *Matcher(level), block: *Block, costs: CostsOf(cheap)) void {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(level.chains);
    const lookahead = lookahead_end(level, self) orelse return;
    // The end is bounded by the window too, so every position the loop inserts, a match's
    // included, fits the heads' 16 bits and its hash's octets need no bounds check.
    const end = @min(lookahead, constants.encoder_window_len - constants.lookahead_min + 1);
    var state: LazyState = .{ .position = self.position, .previous = self.previous, .waiting = self.waiting };
    // The symbols cover the octets from the first position no symbol covers yet, as they stand at
    // the loop's start and end, so the loop adds their count once.
    const covered_from = state.position - @intFromBool(state.waiting);
    var symbols = block.appender(level.runtime_safety);
    while (state.position < end and !symbols.full()) {
        insert(level, self, state.position);
        var current: Match = .{};
        assert(state.waiting or state.previous.len == 0);
        self.position = state.position;
        // A position before `end` has `lookahead_min` octets ahead, so the search needs no guard.
        // At level 6 the short chain's read and the tail's walk test their candidates against
        // one edge.
        // Level 9 computes the edge in its read and in `best`, in its own form: with this form its
        // code on aarch64 retired more instructions.
        const lowest: ?usize = if (level.walks_inline) lowest_of(level.runtime_safety, state.position) else null;
        if (!skips_search(level, cheap, self, state.position, lowest, state.previous.len, state.waiting)) current = search(level, cheap, false, self, constants.match_len_max, state.previous.len, lowest);
        decide_lazy(level, cheap, self, costs, &symbols, &state, current);
    }
    symbols.finish(state.position - @intFromBool(state.waiting) - covered_from);
    self.position = state.position;
    self.previous = state.previous;
    self.waiting = state.waiting;
}

/// The lazy step's search: `best_inline` at level 6, whose walks mostly meet a candidate or two,
/// and a call to `best` at level 9, whose walks run long. `guarded` is `best_inline`'s, and `best`
/// always tests the guard. `lowest` is `best_inline`'s, and `best` always computes it itself.
pub inline fn search(comptime level: constants.Level, comptime cheap: bool, comptime guarded: bool, self: *const Matcher(level), len_max: usize, previous_len: u16, lowest: ?usize) Match {
    @setRuntimeSafety(level.runtime_safety);
    return if (level.walks_inline) best_inline(level, cheap, guarded, self, len_max, previous_len, lowest) else best(level, cheap, self, len_max, previous_len);
}

/// The lazy step's state through `advance_lazy`: the next position, and the match waiting from the
/// position before it when `waiting`.
const LazyState = struct {
    position: usize,
    previous: Match,
    waiting: bool,
};

/// Takes the waiting match when it is worth at least the `current` one, else adds the position
/// before as a literal and lets `current` wait.
fn decide_lazy(comptime level: constants.Level, comptime cheap: bool, self: *Matcher(level), costs: CostsOf(cheap), symbols: *Appender(level.runtime_safety), state: *LazyState, current: Match) void {
    @setRuntimeSafety(level.runtime_safety);
    if (state.waiting and state.previous.len >= constants.match_len_taken_min and keeps_waiting(level, state.previous, current) and accepted(level, cheap, self, costs, state.position, state.previous)) {
        state.position = take_waiting(level, self, symbols, state.position, state.previous);
        state.waiting = false;
        state.previous = .{};
        return;
    }
    if (state.waiting) symbols.literal(self.window[state.position - 1]);
    state.previous = current;
    state.waiting = true;
    state.position += 1;
}

/// Whether the lazy step may take `found`, the match waiting from the position before `position`:
/// always, unless the block before had cheap literals, when the match must cost fewer bits than the
/// literals it covers (decision 42).
inline fn accepted(comptime level: constants.Level, comptime cheap: bool, self: *const Matcher(level), costs: CostsOf(cheap), position: usize, found: Match) bool {
    @setRuntimeSafety(level.runtime_safety);
    return if (cheap) cost.saves_bits(costs, self.window[position - 1 ..][0..found.len], found.distance) else true;
}

/// Adds the match waiting from the position before `position`, every position it covers joining
/// the chains, as a later match may start there. Returns the first position after it. Inline, as
/// each copy of the lazy loop calls it once a match (decision 42).
inline fn take_waiting(comptime level: constants.Level, self: *Matcher(level), symbols: *Appender(level.runtime_safety), position: usize, previous: Match) usize {
    @setRuntimeSafety(level.runtime_safety);
    assert(previous.len >= constants.match_len_taken_min);
    const match_end = position - 1 + previous.len;
    assert(match_end + constants.hash_len <= self.filled);
    // A window position fits 16 bits. Counted in 16 bits, the covered positions need no check of
    // their own against the heads' 16 bits or the window's end.
    const covered_end: u16 = @intCast(match_end);
    var covered: u16 = @intCast(position + 1);
    while (covered < covered_end) : (covered += 1) insert(level, self, covered);
    symbols.pair(previous.len, previous.distance);
    return match_end;
}

/// One lazy step at a position with `ahead` octets ahead, fewer than the lookahead.
fn step_lazy(comptime level: constants.Level, comptime cheap: bool, self: *Matcher(level), block: *Block, ahead: usize, costs: CostsOf(cheap)) void {
    @setRuntimeSafety(level.runtime_safety);
    if (ahead >= constants.hash_len) insert(level, self, self.position);
    // A waiting match at least `lazy_len` long is taken without a search here.
    const skip = self.waiting and self.previous.len >= level.lazy_len;
    // No match waits without the lazy step's position before (`take_previous` clears it).
    assert(self.waiting or self.previous.len == 0);
    // Fewer than `hash_len` octets may lie ahead here, so the search tests the guard.
    const current = if (skip) Match{} else search(level, cheap, true, self, @min(ahead, constants.match_len_max), self.previous.len, null);
    if (self.waiting and self.previous.len >= constants.match_len_taken_min and keeps_waiting(level, self.previous, current) and accepted(level, cheap, self, costs, self.position, self.previous)) {
        const end = self.position - 1 + self.previous.len;
        // Every position the match covers joins the chains, as a later match may start there.
        for (self.position + 1..end) |covered| {
            if (covered + constants.hash_len <= self.filled) insert(level, self, covered);
        }
        take_previous(level, self, block);
        return;
    }
    if (self.waiting) block.add_literal(level.runtime_safety, self.window[self.position - 1]);
    self.previous = current;
    self.waiting = true;
    self.position += 1;
}

/// Adds the waiting position's symbol, and moves past what it covers.
fn take_previous(comptime level: constants.Level, self: *Matcher(level), block: *Block) align(constants.hot_function_alignment) void {
    @setRuntimeSafety(level.runtime_safety);
    assert(self.waiting);
    self.waiting = false;
    if (self.previous.len >= constants.match_len_taken_min) {
        block.add_pair(level.runtime_safety, self.previous.len, self.previous.distance);
        self.position += self.previous.len - 1;
    } else {
        block.add_literal(level.runtime_safety, self.window[self.position - 1]);
    }
    self.previous = .{};
}

/// The `match_len_taken_min` octets of `run` at `at`, least significant first.
pub inline fn tail_octets(comptime runtime_safety: bool, run: []const u8, at: usize) u32 {
    @setRuntimeSafety(runtime_safety);
    comptime assert(constants.match_len_taken_min == @sizeOf(u32));
    return std.mem.readInt(u32, run[at..][0..constants.match_len_taken_min], .little);
}

/// A position's slot in the chain.
pub inline fn slot(position: usize) Slot {
    return @truncate(position);
}

/// The lowest position a candidate of `position` may lie at: `position` less
/// `encoder_distance_max`, or 1, as a head or link of 0 ends a chain.
///
/// This equals `@max(1, position -| encoder_distance_max)` at every position. Above
/// `encoder_distance_max` the difference is 1 or more, so both forms give it. At or below it the
/// saturated difference is 0, so both forms give 1. This form needs one compare and one
/// subtraction, and the subtraction cannot overflow after the compare.
pub inline fn lowest_of(comptime runtime_safety: bool, position: usize) usize {
    @setRuntimeSafety(runtime_safety);
    return if (position > constants.encoder_distance_max) position - constants.encoder_distance_max else 1;
}

test "lowest_of equals the saturated difference with a floor of 1 at every window position" {
    for (0..constants.encoder_window_len + 1) |position| {
        try std.testing.expectEqual(@max(1, position -| constants.encoder_distance_max), lowest_of(true, position));
    }
}

/// Adds `at` to its hash's chain.
inline fn insert(comptime level: constants.Level, self: *Matcher(level), at: usize) void {
    @setRuntimeSafety(level.runtime_safety);
    const head = &self.heads[hash(level, self, at)];
    self.chain[slot(at)] = head.*;
    head.* = @intCast(at);
}

/// The hash of the 4 octets at `at`, least significant first (decision 14, E1).
pub inline fn hash(comptime level: constants.Level, self: *const Matcher(level), at: usize) Hash(level) {
    @setRuntimeSafety(level.runtime_safety);
    return hash_of_word(level, std.mem.readInt(u32, self.window[at..][0..constants.hash_len], .little));
}

/// `hash` of 4 octets already read least significant first: the product's top `hash_bits` bits,
/// which the truncation keeps whole.
pub inline fn hash_of_word(comptime level: constants.Level, octets: u32) Hash(level) {
    @setRuntimeSafety(level.runtime_safety);
    return @truncate((octets *% constants.hash_multiplier) >> @intCast(@bitSizeOf(u32) - @as(u6, level.hash_bits)));
}

/// How many octets from the start of `earlier` equal those of `later`: 8 octets at a time, the
/// first that differs found by the trailing zeros of their XOR (decision 14, E1). Both runs are
/// walked as slices of words and then of octets, so no read checks its bounds on its own.
pub fn match_len(comptime runtime_safety: bool, earlier: []const u8, later: []const u8) align(constants.hot_function_alignment) usize {
    @setRuntimeSafety(runtime_safety);
    assert(earlier.len == later.len and earlier.len <= constants.match_len_max);
    const word_len = @sizeOf(u64);
    const words_len = earlier.len - earlier.len % word_len;
    var len: usize = 0;
    for (std.mem.bytesAsSlice(u64, earlier[0..words_len]), std.mem.bytesAsSlice(u64, later[0..words_len])) |a, b| {
        // Read least significant octet first, the XOR's lowest set bit lies in the first octet that
        // differs.
        const differ = std.mem.nativeToLittle(u64, a ^ b);
        if (differ != 0) return len + @ctz(differ) / @bitSizeOf(u8);
        len += word_len;
    }
    for (earlier[words_len..], later[words_len..]) |a, b| {
        if (a != b) break;
        len += 1;
    }
    return len;
}
