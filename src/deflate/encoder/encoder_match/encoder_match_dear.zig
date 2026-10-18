//! The lazy steps of a block that takes matches of 3 octets, one after a block whose literals are
//! dear (decision 50, `encoder_match_three.zig`): a copy of the steps of its own, as a block of
//! cheap literals has (decision 42), so every other block runs the steps it ran before.
//!
//! What differs from `encoder_match.zig`'s steps:
//! - Every position joins the 3-octet table beside its chain.
//! - A position after a literal, or after a 3-octet match that waits, reads no short chain. It
//!   reads its chain's nearest candidate and the table's, each on no branch, and searches where
//!   either holds its 4 octets. Where neither does, a position after a literal takes the table's
//!   candidate as a 3-octet match when that holds 3.
//! - The lazy step takes a 3-octet match that waits unless the next position's search finds a
//!   match that scores more.
//!
//! Data whose literals are dear repeats little: most of its positions find no match of 4, and a
//! short chain's read costs them more than the matches it finds beyond the nearest candidate
//! save. The table's candidate finds the nearest of those matches again, as it is the nearest
//! position that holds even 3 of the octets.

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const block_module = @import("../encoder_block.zig");
const Block = block_module.Block;
const Appender = block_module.Appender;
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const Match = match.Match;
const three_module = @import("encoder_match_three.zig");
const Three = three_module.Three;

/// `Matcher.advance_dear`: the positions, in rounds that stop at the block's limit as the rounds
/// of every lazy block do (decision 44): a round shows the loops the window only as far as the
/// lookahead of as many positions as the limit leaves symbols.
pub fn advance(comptime level: constants.Level, self: *Matcher(level), block: *Block, ending: bool, three: *Three) void {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(level.three and level.block_checks);
    const filled = self.filled;
    for (0..filled + 1) |_| {
        // The symbols the block takes before its limit.
        const room: usize = block.limit - block.symbol_count;
        assert(room > 0);
        self.filled = @min(filled, self.position + room + (constants.lookahead_min - 1));
        const whole = self.filled == filled;
        advance_positions(level, self, block, ending and whole, three);
        if (whole or block.at_limit()) break;
    } else unreachable;
    self.filled = filled;
}

/// Decides positions into `block` while `lookahead_min` octets lie ahead, or up to `filled` when
/// `ending`, until the block is full: the positions with the whole lookahead in their loop
/// first, then the rest a step at a time. Each step adds at most one symbol.
noinline fn advance_positions(comptime level: constants.Level, self: *Matcher(level), block: *Block, ending: bool, three: *Three) align(constants.hot_function_alignment) void {
    @setRuntimeSafety(level.runtime_safety);
    advance_lazy(level, self, block, three);
    for (0..self.filled + 1) |_| {
        if (block.full()) return;
        const ahead = self.filled - self.position;
        if (ahead == 0 or (!ending and ahead < constants.lookahead_min)) return;
        step(level, self, block, ahead, three);
    }
    unreachable;
}

/// The lazy step's state through `advance_lazy`: the next position, and the match waiting from
/// the position before it when `waiting`.
const State = struct {
    position: usize,
    previous: Match,
    waiting: bool,
};

/// The positions with the whole lookahead ahead, decided until the block fills or the lookahead
/// runs out, with the step's state in locals through the loop.
fn advance_lazy(comptime level: constants.Level, self: *Matcher(level), block: *Block, three: *Three) void {
    @setRuntimeSafety(level.runtime_safety);
    const lookahead = match.lookahead_end(level, self) orelse return;
    // The end is bounded by the window too, so every position the loop inserts fits 16 bits.
    const end = @min(lookahead, constants.encoder_window_len - constants.lookahead_min + 1);
    var state: State = .{ .position = self.position, .previous = self.previous, .waiting = self.waiting };
    const covered_from = state.position - @intFromBool(state.waiting);
    var symbols = block.appender(level.runtime_safety);
    while (state.position < end and !symbols.full()) {
        const word = match.tail_octets(level.runtime_safety, &self.window, state.position);
        insert_word(level, self, state.position, word);
        const nearest = three.insert(level.runtime_safety, word, state.position);
        assert(state.waiting or state.previous.len == 0);
        const current = find(level, self, state.position, word, nearest, constants.match_len_max, state.previous.len);
        decide(level, self, three, &symbols, &state, current);
    }
    symbols.finish(state.position - @intFromBool(state.waiting) - covered_from);
    self.position = state.position;
    self.previous = state.previous;
    self.waiting = state.waiting;
}

/// The match at `position`, whose 4 octets are `word`, up to `len_max` octets, with the match
/// of `previous_len` octets waiting from the position before, 0 for none. `nearest` is the
/// 3-octet table's candidate.
///
/// After a match of 4 octets or more the position searches as another block's does, and not at
/// all once the match is `lazy_len` long. Else it searches where its chain's nearest candidate
/// or the table's holds its 4 octets, and a position after a literal that finds none takes the
/// table's 3-octet match.
inline fn find(comptime level: constants.Level, self: *Matcher(level), position: usize, word: u32, nearest: u16, len_max: usize, previous_len: u16) Match {
    @setRuntimeSafety(level.runtime_safety);
    assert(len_max >= constants.hash_len);
    if (previous_len > constants.match_len_min) {
        if (previous_len >= level.lazy_len) return .{};
        return search_at(level, self, position, len_max, previous_len);
    }
    const probed = three_module.probe(level.runtime_safety, &self.window, position, word, nearest);
    const holds = @intFromBool(probed.four) | @intFromBool(nearest_holds(level, self, position, word));
    var found: Match = .{};
    if (holds != 0) found = search_at(level, self, position, len_max, previous_len);
    if (found.len != 0 or previous_len != 0) return found;
    return probed.three;
}

/// Whether this block's search at level 6 tests the guard of `best_inline`, which its callers
/// make dead. Level 9's search calls `best`, which always tests it. On x86-64 the test costs 5
/// instructions a search. On aarch64 LLVM builds the loop without it with more instructions a
/// position: x-ray 0.68 and ooffice 0.16 more an octet under callgrind.
const searches_guarded = builtin.cpu.arch != .x86_64;

/// `match.search` at `position`, which the matcher is told here: the loop keeps its position in
/// a local, and most positions of such a block search nothing. Both callers of `find` give it
/// `len_max` octets ahead of `position`, so the guard never holds.
inline fn search_at(comptime level: constants.Level, self: *Matcher(level), position: usize, len_max: usize, previous_len: u16) Match {
    @setRuntimeSafety(level.runtime_safety);
    self.position = position;
    return match.search(level, false, searches_guarded, self, len_max, previous_len);
}

/// Whether the nearest candidate of `position`'s chain lies in reach and holds `word`, its 4
/// octets. The octets are read whatever the candidate, a position of the window as any other,
/// so that no branch waits on whether the chain names one: data that does not repeat answers
/// that either way.
pub inline fn nearest_holds(comptime level: constants.Level, self: *const Matcher(level), position: usize, word: u32) bool {
    @setRuntimeSafety(level.runtime_safety);
    const candidate: usize = self.chain[match.slot(position)];
    const lowest = @max(1, position -| constants.encoder_distance_max);
    const holds = @intFromBool(candidate >= lowest) & @intFromBool(match.tail_octets(level.runtime_safety, &self.window, candidate) == word);
    return holds != 0;
}

/// Takes the waiting match when it scores at least what the `current` one does, else adds the
/// position before as a literal and lets `current` wait.
fn decide(comptime level: constants.Level, self: *Matcher(level), three: *Three, symbols: *Appender(level.runtime_safety), state: *State, current: Match) void {
    @setRuntimeSafety(level.runtime_safety);
    if (state.waiting and state.previous.len >= constants.match_len_min and outscores(level, state.previous, current)) {
        state.position = take_waiting(level, self, three, symbols, state.position, state.previous);
        state.waiting = false;
        state.previous = .{};
        return;
    }
    if (state.waiting) symbols.literal(self.window[state.position - 1]);
    state.previous = current;
    state.waiting = true;
    state.position += 1;
}

/// Whether the lazy step keeps `previous`, a match that waits, over `current`: when it scores as
/// much. Any match scores at least what none does, which is asked first, as most waiting
/// matches of a block whose literals are dear meet none.
inline fn outscores(comptime level: constants.Level, previous: Match, current: Match) bool {
    @setRuntimeSafety(level.runtime_safety);
    if (current.len == 0) return true;
    return previous.score(level.runtime_safety) >= current.score(level.runtime_safety);
}

/// Adds the match waiting from the position before `position`, every position it covers joining
/// the chains and the table, and counts it for `three` when it holds 3 octets. Returns the
/// first position after it.
inline fn take_waiting(comptime level: constants.Level, self: *Matcher(level), three: *Three, symbols: *Appender(level.runtime_safety), position: usize, previous: Match) usize {
    @setRuntimeSafety(level.runtime_safety);
    assert(previous.len >= constants.match_len_min);
    const match_end = position - 1 + previous.len;
    assert(match_end + constants.hash_len <= self.filled);
    // A window position fits 16 bits, so the covered positions need no check of their own.
    const covered_end: u16 = @intCast(match_end);
    var covered: u16 = @intCast(position + 1);
    while (covered < covered_end) : (covered += 1) insert_both(level, self, three, covered);
    const distance_index = block_module.distance_code(level.runtime_safety, previous.distance);
    if (previous.len == constants.match_len_min) three.tally(level.runtime_safety, match.tail_octets(level.runtime_safety, &self.window, position - 1), distance_index);
    symbols.pair_coded(previous.len, previous.distance, distance_index);
    return match_end;
}

/// One lazy step at a position with `ahead` octets ahead, fewer than the lookahead. A position
/// with fewer than `hash_len` ahead joins nothing and finds no match.
fn step(comptime level: constants.Level, self: *Matcher(level), block: *Block, ahead: usize, three: *Three) void {
    @setRuntimeSafety(level.runtime_safety);
    // No match waits without the lazy step's position before (`take_previous` clears it).
    assert(self.waiting or self.previous.len == 0);
    var current: Match = .{};
    if (ahead >= constants.hash_len) {
        const word = match.tail_octets(level.runtime_safety, &self.window, self.position);
        insert_word(level, self, self.position, word);
        const nearest = three.insert(level.runtime_safety, word, self.position);
        current = find(level, self, self.position, word, nearest, @min(ahead, constants.match_len_max), self.previous.len);
    }
    if (self.waiting and self.previous.len >= constants.match_len_min and outscores(level, self.previous, current)) {
        const end = self.position - 1 + self.previous.len;
        // Every position the match covers joins the chains, as a later match may start there.
        for (self.position + 1..end) |covered| {
            if (covered + constants.hash_len <= self.filled) insert_both(level, self, three, covered);
        }
        take_previous(level, self, block);
        return;
    }
    if (self.waiting) block.add_literal(level.runtime_safety, self.window[self.position - 1]);
    self.previous = current;
    self.waiting = true;
    self.position += 1;
}

/// Adds the waiting position's match, and moves past what it covers. Not counted for the
/// table's verdict: a stream's last positions and those before a flush come here, a few.
fn take_previous(comptime level: constants.Level, self: *Matcher(level), block: *Block) void {
    @setRuntimeSafety(level.runtime_safety);
    assert(self.waiting and self.previous.len >= constants.match_len_min);
    self.waiting = false;
    block.add_pair(level.runtime_safety, self.previous.len, self.previous.distance);
    self.position += self.previous.len - 1;
    self.previous = .{};
}

/// Adds `at`, whose 4 octets are `word`, to its hash's chain.
inline fn insert_word(comptime level: constants.Level, self: *Matcher(level), at: usize, word: u32) void {
    @setRuntimeSafety(level.runtime_safety);
    const head = &self.heads[match.hash_of_word(level, word)];
    self.chain[match.slot(at)] = head.*;
    head.* = @intCast(at);
}

/// Adds `at` to its hash's chain and to `three`'s table.
inline fn insert_both(comptime level: constants.Level, self: *Matcher(level), three: *Three, at: usize) void {
    @setRuntimeSafety(level.runtime_safety);
    const word = match.tail_octets(level.runtime_safety, &self.window, at);
    insert_word(level, self, at, word);
    _ = three.insert(level.runtime_safety, word, at);
}

test {
    _ = @import("encoder_match_dear_test.zig");
}
