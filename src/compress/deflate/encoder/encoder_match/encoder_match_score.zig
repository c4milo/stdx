//! A match, and how the lazy step compares two of them: the match that waits from a position
//! against the match a later position found (decisions 36, 52 and 72). A piece of
//! `encoder_match.zig`, which gives `Match` and `keeps_waiting` as its own.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");

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
    return keeps_by_bits(level.runtime_safety, previous, current);
}

/// `keeps_waiting` at a level that holds matches (decision 72): by bits in a block whose gate is
/// `live`, as a held match is compared, and as the level compared before in a block that holds
/// none, so a stream's first block writes what it wrote before.
pub inline fn keeps(comptime level: constants.Level, live: bool, previous: Match, current: Match) bool {
    @setRuntimeSafety(level.runtime_safety);
    if (level.second and live) return keeps_by_bits(level.runtime_safety, previous, current);
    return keeps_waiting(level, previous, current);
}

/// `keeps_waiting` by bits.
inline fn keeps_by_bits(comptime runtime_safety: bool, previous: Match, current: Match) bool {
    @setRuntimeSafety(runtime_safety);
    if (current.len < previous.len) return true;
    return current.bits_score(runtime_safety) <= previous.bits_score(runtime_safety) + constants.lazy_bits_margin;
}

/// Whether the lazy step holds `previous`, a match it keeps over the next position's, for one
/// position more before it takes it (decision 72). A match of `lazy_len` octets is taken at once.
/// A held match that loses adds two literals, so the block must have room for two symbols before
/// its `limit`: `count` is the symbols it holds. The count and the limit follow from the symbols
/// alone, so how the caller splits its input changes no answer (invariant 5).
pub inline fn holds(comptime level: constants.Level, previous: Match, count: usize, limit: usize) bool {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(level.second);
    return previous.len < level.lazy_len and count + held_symbols_max <= limit;
}

/// Whether a block's lazy steps hold matches (decision 72), decided at each block's end from the
/// held matches decided since the block before ended. Each held match costs a search. Data whose
/// held matches seldom lose to the second position's does not pay that back: a block that lost
/// fewer than one in `second_win_divisor` stops the next blocks, for a wait that grows with each
/// such block in a row, as decision 50's wait does for the matches of 3 octets. Such a block stops
/// its own holds too, once `second_check_holds` of them tell. A stream's first block holds none:
/// a short stream pays the searches for few octets, and writes what it wrote before.
pub const Gate = struct {
    live: bool,
    /// The held matches decided since the last block's end, and those among them that the second
    /// position's match won over.
    holds: u32,
    wins: u32,
    /// The block ends still to wait before the steps hold matches again, and the wait that the
    /// next block of too few wins sets.
    wait: u8,
    penalty: u8,

    /// Starts a stream: its first block holds no match, and the next one does.
    pub fn start(self: *align(1) Gate) void {
        self.* = .{ .live = false, .holds = 0, .wins = 0, .wait = 1, .penalty = 1 };
    }

    /// Counts a held match decided, `won` when the second position's match won over it, and stops
    /// the block's holds when its first `second_check_holds` lost too few, or its first
    /// `second_retry_check_holds` after a block that lost too few. A block decides fewer
    /// held matches than it holds symbols, so no count wraps.
    pub inline fn count(self: *align(1) Gate, won: bool) void {
        self.holds +%= 1;
        self.wins +%= @intFromBool(won);
        const check_holds: u32 = if (self.penalty > 1) constants.second_retry_check_holds else constants.second_check_holds;
        if (self.holds == check_holds and !self.enough()) self.live = false;
    }

    /// Whether the held matches counted lost at least one in `second_win_divisor`.
    fn enough(self: *align(1) const Gate) bool {
        return @as(u64, self.wins) * constants.second_win_divisor >= self.holds;
    }

    /// At a block's end: decides whether the next block's steps hold matches. A block that held
    /// fewer than `second_holds_min` changes nothing.
    pub fn end_block(self: *align(1) Gate) void {
        if (self.holds >= constants.second_holds_min) {
            if (self.enough()) self.penalty = 1 else self.fail();
        } else if (!self.live) {
            assert(self.wait > 0);
            self.wait -= 1;
            self.live = self.wait == 0;
        }
        self.holds = 0;
        self.wins = 0;
    }

    /// After a block of too few wins: waits `penalty` block ends, and `second_wait_growth` times
    /// as many the next time in a row, `second_wait_max` at most.
    fn fail(self: *align(1) Gate) void {
        self.live = false;
        self.wait = self.penalty;
        // In 16 bits: the product passes the wait's 8 before the cut to `second_wait_max`.
        const grown = @as(u16, self.penalty) * constants.second_wait_growth;
        self.penalty = @intCast(@min(grown, constants.second_wait_max));
    }
};

comptime {
    assert(constants.second_wait_max <= std.math.maxInt(u8) and constants.second_wait_growth >= 1);
}

/// A held match starts this many positions before the position that decides it: its own, the
/// position it held against, and then the second.
pub const held_back = 2;

/// The symbols a held match adds at most when it is decided: the two literals before the match
/// that wins.
pub const held_symbols_max = 2;

/// Whether `current`, the match of the second position after a held match's, wins over
/// `previous`, the held match (decision 72): when it is at least as long and its `bits_score`
/// passes the held match's by more than `lazy_second_bits_margin`.
pub inline fn second_wins(comptime level: constants.Level, previous: Match, current: Match) bool {
    @setRuntimeSafety(level.runtime_safety);
    comptime assert(level.second);
    if (current.len < previous.len) return false;
    return current.bits_score(level.runtime_safety) > previous.bits_score(level.runtime_safety) + constants.lazy_second_bits_margin;
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

test "second_wins takes a match of equal length only when its distance is 7 bits shorter" {
    const level = comptime constants.level(9);
    const held: Match = .{ .len = 10, .distance = 1 << 12 };
    // Equal length: the bit lengths 13 and 6 differ by 7, which passes the margin of 6.
    try std.testing.expect(second_wins(level, held, .{ .len = 10, .distance = 1 << 5 }));
    try std.testing.expect(!second_wins(level, held, .{ .len = 10, .distance = 1 << 6 }));
    // One octet longer weighs 4 bits: the distance may then be 3 bits shorter, and no less.
    try std.testing.expect(second_wins(level, held, .{ .len = 11, .distance = 1 << 9 }));
    try std.testing.expect(!second_wins(level, held, .{ .len = 11, .distance = 1 << 10 }));
    // Two octets longer pass the margin at an equal distance, and a shorter match never wins.
    try std.testing.expect(second_wins(level, held, .{ .len = 12, .distance = 1 << 12 }));
    try std.testing.expect(!second_wins(level, held, .{ .len = 9, .distance = 1 }));
    try std.testing.expect(!second_wins(level, held, .{}));
}

test "holds refuses a match taken at once and a block without room for two symbols" {
    const level = comptime constants.level(9);
    const found: Match = .{ .len = 20, .distance = 100 };
    try std.testing.expect(holds(level, found, 10, 12));
    try std.testing.expect(!holds(level, found, 11, 12));
    try std.testing.expect(!holds(level, .{ .len = level.lazy_len, .distance = 100 }, 10, 12));
}

test {
    _ = @import("encoder_match_score_test.zig");
    _ = @import("encoder_match_score_gate_test.zig");
}
