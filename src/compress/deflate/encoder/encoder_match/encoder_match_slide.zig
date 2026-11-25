//! The slide of the encoder's window: its second half moves to its first, and every head and link
//! moves with it. A piece of `encoder_match.zig`, which gives `slide_positions` as its own.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const Matcher = @import("encoder_match.zig").Matcher;

/// Moves the window's second half to its first, keeping 32 KiB of history, and moves every head
/// and link with it; one that falls out of the window names none.
pub fn slide_window(comptime level: constants.Level, self: *Matcher(level)) void {
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
