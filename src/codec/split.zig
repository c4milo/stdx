//! The seeded split driver every codec's tests use (decision 15, design §8 step 3).
//!
//! A codec's output must not depend on how its caller splits the input and the output across calls
//! (invariant 5). The driver proves that for one seed at a time: it feeds a streaming call pieces of
//! input and pieces of room whose sizes the seed draws, from the kinds decision 15 names: empty,
//! one octet, short, long, or everything left. Before the second call, and before about one later
//! call in `constants.state_move_period`, it copies the state to its other slot and fills the old
//! slot with `constants.moved_state_fill`, so a state that kept a pointer into itself reads garbage
//! and the test fails (invariant 12). After every call it checks invariants 7 and 8.
//!
//! The seed drives `Generator`, SplitMix64, which is this file's own. It chooses how a test splits
//! a stream and nothing else: no codec reads it, so no codec's output depends on it (invariant 3).
//! The same seed replays the same schedule on every host.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const Progress = @import("status.zig").Progress;
const check_progress = @import("status.zig").check_progress;

/// SplitMix64: a 64-bit state advanced by a fixed odd increment and mixed on the way out.
pub const Generator = struct {
    state: u64,

    const increment: u64 = 0x9e3779b97f4a7c15;
    const multiplier_one: u64 = 0xbf58476d1ce4e5b9;
    const multiplier_two: u64 = 0x94d049bb133111eb;
    const shift_one: u6 = 30;
    const shift_two: u6 = 27;
    const shift_three: u6 = 31;

    pub fn init(seed: u64) Generator {
        return .{ .state = seed };
    }

    pub fn next(self: *Generator) u64 {
        self.state +%= increment;
        var mixed = self.state;
        mixed = (mixed ^ (mixed >> shift_one)) *% multiplier_one;
        mixed = (mixed ^ (mixed >> shift_two)) *% multiplier_two;
        return mixed ^ (mixed >> shift_three);
    }

    /// A number below `bound`, which must be positive.
    pub fn below(self: *Generator, bound: u64) u64 {
        assert(bound > 0);
        return @intCast((@as(u128, self.next()) * bound) >> @bitSizeOf(u64));
    }

    /// A number from `low` to `high`, both included.
    pub fn between(self: *Generator, low: u64, high: u64) u64 {
        assert(low <= high);
        return low + self.below(high - low + 1);
    }
};

/// The two places the driver keeps a state, so it can move the state from one to the other.
pub const state_slots = 2;

/// The piece kinds of decision 15, in the order `constants.piece_weights` weighs them.
pub const Piece = enum { empty, one, short, long, rest };

/// The sizes one seed draws.
pub const Schedule = struct {
    generator: Generator,

    pub fn init(seed: u64) Schedule {
        return .{ .generator = Generator.init(seed) };
    }

    /// The length of the next piece, when `available` octets are left to give.
    pub fn piece_len(self: *Schedule, available: usize) usize {
        const len: usize = switch (self.piece()) {
            .empty => 0,
            .one => 1,
            .short => self.generator.between(constants.short_piece_len_min, constants.short_piece_len_max),
            .long => self.generator.between(constants.short_piece_len_max + 1, constants.long_piece_len_max),
            .rest => available,
        };
        return @min(len, available);
    }

    /// Whether to move the state before the next call.
    pub fn move_state(self: *Schedule) bool {
        return self.generator.below(constants.state_move_period) == 0;
    }

    fn piece(self: *Schedule) Piece {
        var draw = self.generator.below(constants.piece_weight_total);
        for (constants.piece_weights, 0..) |weight, index| {
            if (draw < weight) return @enumFromInt(index);
            draw -= weight;
        }
        unreachable;
    }
};

/// Where a driven stream stopped.
pub const Outcome = struct {
    /// Octets of the input consumed, and of the output written, over every call.
    consumed: usize,
    written: usize,
    /// The status of the last call: `done`, or `needs_input` with all the input given, or
    /// `needs_room` with all the output given.
    status: @import("status.zig").Status,
    calls: usize,
};

/// Drives `step(state, input_piece, output_piece)` over all of `input` and `output`, with the pieces
/// `seed` draws, until the stream is done or has nothing more to take or no more room. The state
/// starts in `states[0]` and moves between the two slots. Returns `error.TestNoProgress` when the
/// calls outrun `constants.driver_calls_per_octet_max` per octet (invariant 8).
pub fn drive(
    comptime State: type,
    states: *[state_slots]State,
    step: anytype,
    input: []const u8,
    output: []u8,
    seed: u64,
) !Outcome {
    var schedule = Schedule.init(seed);
    var outcome: Outcome = .{ .consumed = 0, .written = 0, .status = .needs_input, .calls = 0 };
    var slot: usize = 0;
    const calls_max = constants.driver_calls_floor +
        constants.driver_calls_per_octet_max * (input.len + output.len);
    while (outcome.calls < calls_max) : (outcome.calls += 1) {
        // The first move comes before the second call, so every stream that takes more than one
        // call moves at least once; later moves are drawn.
        if (outcome.calls == 1 or (outcome.calls > 1 and schedule.move_state())) slot = move(State, states, slot);
        const input_left = input.len - outcome.consumed;
        const room_left = output.len - outcome.written;
        const input_piece = input[outcome.consumed..][0..schedule.piece_len(input_left)];
        const output_piece = output[outcome.written..][0..schedule.piece_len(room_left)];
        const progress: Progress = try step(&states[slot], input_piece, output_piece);
        check_progress(input_piece.len, output_piece.len, progress);
        outcome.consumed += progress.consumed;
        outcome.written += progress.written;
        outcome.status = progress.status;
        if (is_final(progress, input_piece.len == input_left, output_piece.len == room_left)) {
            outcome.calls += 1;
            return outcome;
        }
    }
    return error.TestNoProgress;
}

/// True when a call's status ends the drive: the stream is done, or it wants what is no longer
/// there to give.
fn is_final(progress: Progress, gave_all_input: bool, gave_all_room: bool) bool {
    return switch (progress.status) {
        .done => true,
        .needs_input => gave_all_input,
        .needs_room => gave_all_room,
    };
}

/// Copies the state to the other slot, fills the old one, and returns the new slot.
fn move(comptime State: type, states: *[state_slots]State, slot: usize) usize {
    const other = 1 - slot;
    states[other] = states[slot];
    @memset(std.mem.asBytes(&states[slot]), constants.moved_state_fill);
    return other;
}

test {
    _ = @import("split_test.zig");
}
