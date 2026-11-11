//! The held matches of a level whose lazy step tries a second position (decision 72,
//! `Level.second`): the lazy loop and the last positions' step of a round whose gate lets it hold
//! matches, or that starts with a match held. A level that holds no match compiles none of it,
//! and every other round runs the loop of `encoder_match.zig` as it was: those rounds' code is
//! the code before decision 72.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const block_module = @import("../encoder_block.zig");
const Block = block_module.Block;
const Appender = block_module.Appender;
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const Match = match.Match;
const CostsOf = match.CostsOf;
const score = @import("encoder_match_score.zig");
const walk = @import("encoder_match_walk.zig");

/// The matcher's `held` at a level that holds a match, and nothing at another.
pub fn Held(comptime level: constants.Level) type {
    return if (level.second) bool else void;
}

/// The matcher's `gate` at a level that holds a match, and nothing at another.
pub fn GateOf(comptime level: constants.Level) type {
    return if (level.second) score.Gate else void;
}

/// Starts a stream with no match held and, at a level that holds matches, its gate.
pub fn start(comptime level: constants.Level, self: *Matcher(level)) void {
    if (level.second) {
        self.held = false;
        self.gate.start();
    }
}

/// Whether the matcher holds a match: never at a level that holds none.
pub inline fn is_held(comptime level: constants.Level, self: *const Matcher(level)) bool {
    return if (level.second) self.held else false;
}

/// Whether the matcher's gate lets this block hold matches: never at a level that holds none.
pub inline fn gate_live(comptime level: constants.Level, self: *const Matcher(level)) bool {
    return if (level.second) self.gate.live else false;
}

/// The lazy loop's state in a block that holds matches: the next position, the match waiting
/// from the position before it when `waiting`, whether that match is `held` against the position
/// before too, the block's `limit`, which `score.holds` reads, and the gate's `live`.
const State = struct {
    position: usize,
    previous: Match,
    waiting: bool,
    held: bool,
    limit: usize,
    live: bool,
};

/// `match.advance_lazy_zig` in a round whose gate lets it hold matches, or that starts with a match
/// held: the positions with the whole lookahead ahead, decided until the block fills or the
/// lookahead runs out. A match the lazy step keeps over the next position's is held for one
/// position more (`score.holds`), and `decide_held` decides it there. While the gate is stopped,
/// the loop holds none and compares as a block that holds none does.
pub fn advance_lazy(comptime level: constants.Level, comptime cheap: bool, self: *Matcher(level), block: *Block, costs: CostsOf(cheap)) void {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(level.second and level.chains);
    const lookahead = match.lookahead_end(level, self) orelse return;
    // The end is bounded by the window too, so every position the loop inserts, a match's
    // included, fits the heads' 16 bits and its hash's octets need no bounds check.
    const end = @min(lookahead, constants.encoder_window_len - constants.lookahead_min + 1);
    var state: State = .{ .position = self.position, .previous = self.previous, .waiting = self.waiting, .held = self.held, .limit = block.limit, .live = self.gate.live };
    // The symbols cover the octets from the first position no symbol covers yet, as they stand at
    // the loop's start and end, so the loop adds their count once.
    const covered_from = state.position - @intFromBool(state.waiting) - @intFromBool(state.held);
    var symbols = block.appender(level.runtime_safety);
    while (state.position < end and !symbols.full()) {
        match.insert(level, self, state.position);
        assert(state.waiting or state.previous.len == 0);
        self.position = state.position;
        // In the loop, and not in the step that holds the match: called from there, this block
        // ran 4% to 7% more instructions on data that holds few matches.
        if (state.held) {
            decide_held(level, self, &symbols, &state);
            continue;
        }
        decide_lazy(level, cheap, self, costs, &symbols, &state, found_at(level, cheap, self, &state));
    }
    symbols.finish(state.position - @intFromBool(state.waiting) - @intFromBool(state.held) - covered_from);
    self.position = state.position;
    self.previous = state.previous;
    self.waiting = state.waiting;
    self.held = state.held;
}

/// The match the loop's position finds, as `match.advance_lazy_zig` finds it: none where it
/// starts no search. A position before the loop's end has `lookahead_min` octets ahead, so the
/// search needs no guard.
inline fn found_at(comptime level: constants.Level, comptime cheap: bool, self: *const Matcher(level), state: *const State) Match {
    @setRuntimeSafety(level.runtime_safety);
    const lowest: ?usize = if (level.walks_inline) match.lowest_of(level.runtime_safety, state.position) else null;
    if (walk.skips_search(level, cheap, self, state.position, lowest, state.previous.len, state.waiting)) return .{};
    return match.search(level, cheap, false, self, constants.match_len_max, state.previous.len, lowest);
}

/// Takes the waiting match when it is worth at least the `current` one, or holds it where the
/// gate and the block's room let it; else adds the position before as a literal and lets
/// `current` wait.
fn decide_lazy(comptime level: constants.Level, comptime cheap: bool, self: *Matcher(level), costs: CostsOf(cheap), symbols: *Appender(level.runtime_safety), state: *State, current: Match) void {
    @setRuntimeSafety(level.runtime_safety);
    if (state.waiting and state.previous.len >= constants.match_len_taken_min and score.keeps(level, state.live, state.previous, current) and match.accepted(level, cheap, self, costs, state.position, state.previous)) {
        if (state.live and score.holds(level, state.previous, symbols.count, state.limit)) {
            state.held = true;
            state.position += 1;
            return;
        }
        state.position = take_waiting(level, self, symbols, state.position, state.previous, 1);
        state.waiting = false;
        state.previous = .{};
        return;
    }
    if (state.waiting) symbols.literal(self.window[state.position - 1]);
    state.previous = current;
    state.waiting = true;
    state.position += 1;
}

/// Decides a held match at `state.position`, the second position after its own, which the loop
/// has joined to its chain. When that position's match wins (`second_wins`), the two positions
/// before it become literals and its match waits. Else the held match is taken.
fn decide_held(comptime level: constants.Level, self: *Matcher(level), symbols: *Appender(level.runtime_safety), state: *State) void {
    @setRuntimeSafety(level.runtime_safety);
    assert(state.held and state.waiting and state.previous.len >= constants.match_len_taken_min);
    const current = walk.best_second(level, self, constants.match_len_max, state.previous.len);
    state.held = false;
    const won = score.second_wins(level, state.previous, current);
    self.gate.count(won);
    state.live = self.gate.live;
    if (won) {
        symbols.literal(self.window[state.position - score.held_back]);
        symbols.literal(self.window[state.position - 1]);
        state.previous = current;
        state.position += 1;
        return;
    }
    state.position = take_waiting(level, self, symbols, state.position, state.previous, score.held_back);
    state.waiting = false;
    state.previous = .{};
}

/// Adds the match waiting from `back` positions before `position`, 1 or a held match's 2, every
/// position it covers after `position` joining the chains, as a later match may start there.
/// Returns the first position after it.
inline fn take_waiting(comptime level: constants.Level, self: *Matcher(level), symbols: *Appender(level.runtime_safety), position: usize, previous: Match, comptime back: usize) usize {
    @setRuntimeSafety(level.runtime_safety);
    assert(previous.len >= constants.match_len_taken_min);
    const match_end = position - back + previous.len;
    assert(match_end > position and match_end + constants.hash_len <= self.filled);
    // A window position fits 16 bits. Counted in 16 bits, the covered positions need no check of
    // their own against the heads' 16 bits or the window's end.
    const covered_end: u16 = @intCast(match_end);
    var covered: u16 = @intCast(position + 1);
    while (covered < covered_end) : (covered += 1) match.insert(level, self, covered);
    symbols.pair(previous.len, previous.distance);
    return match_end;
}

/// `match.step_lazy` in the rounds of `advance_lazy`: one lazy step at a position with `ahead`
/// octets ahead, fewer than the lookahead.
pub fn step_lazy(comptime level: constants.Level, comptime cheap: bool, self: *Matcher(level), block: *Block, ahead: usize, costs: CostsOf(cheap)) void {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(level.second);
    if (ahead >= constants.hash_len) match.insert(level, self, self.position);
    if (self.held) return step_held(level, self, block, ahead);
    // A waiting match at least `lazy_len` long is taken without a search here.
    const skip = self.waiting and self.previous.len >= level.lazy_len;
    // No match waits without the lazy step's position before (`take_previous` clears it).
    assert(self.waiting or self.previous.len == 0);
    // Fewer than `hash_len` octets may lie ahead here, so the search tests the guard.
    const current = if (skip) Match{} else match.search(level, cheap, true, self, @min(ahead, constants.match_len_max), self.previous.len, null);
    if (self.waiting and self.previous.len >= constants.match_len_taken_min and score.keeps(level, self.gate.live, self.previous, current) and match.accepted(level, cheap, self, costs, self.position, self.previous)) {
        if (self.gate.live and score.holds(level, self.previous, block.symbol_count, block.limit)) {
            self.held = true;
            self.position += 1;
            return;
        }
        take_covering(level, self, block, 1);
        return;
    }
    if (self.waiting) block.add_literal(level.runtime_safety, self.window[self.position - 1]);
    self.previous = current;
    self.waiting = true;
    self.position += 1;
}

/// Decides a held match at the position, with `ahead` octets ahead, which the caller has joined
/// to its chain where its hash's octets lie in the input: the search tests its guard.
fn step_held(comptime level: constants.Level, self: *Matcher(level), block: *Block, ahead: usize) void {
    @setRuntimeSafety(level.runtime_safety);
    assert(self.held and self.waiting and self.previous.len >= constants.match_len_taken_min);
    const current = walk.best_second(level, self, @min(ahead, constants.match_len_max), self.previous.len);
    self.held = false;
    const won = score.second_wins(level, self.previous, current);
    self.gate.count(won);
    if (won) {
        block.add_literal(level.runtime_safety, self.window[self.position - score.held_back]);
        block.add_literal(level.runtime_safety, self.window[self.position - 1]);
        self.previous = current;
        self.position += 1;
        return;
    }
    take_covering(level, self, block, score.held_back);
}

/// Takes the match waiting from `back` positions before the position, 1 or a held match's 2.
/// Every position it covers after the position joins the chains, as a later match may start
/// there.
fn take_covering(comptime level: constants.Level, self: *Matcher(level), block: *Block, comptime back: usize) void {
    @setRuntimeSafety(level.runtime_safety);
    const end = self.position - back + self.previous.len;
    for (self.position + 1..end) |covered| {
        if (covered + constants.hash_len <= self.filled) match.insert(level, self, covered);
    }
    assert(self.waiting and self.previous.len >= constants.match_len_taken_min);
    self.waiting = false;
    block.add_pair(level.runtime_safety, self.previous.len, self.previous.distance);
    self.position += self.previous.len - back;
    self.previous = .{};
}
