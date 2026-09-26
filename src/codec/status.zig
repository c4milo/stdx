//! The status, the counts and the flush modes of every codec's streaming call, and the checks that
//! every call's exit makes (decision 11; invariants 7 and 8).

const std = @import("std");
const assert = std.debug.assert;

/// How a streaming call ended.
pub const Status = enum {
    /// The call took all of its input and the stream is not finished.
    needs_input,
    /// The call filled all of its output, and has more to write or input left to take.
    needs_room,
    /// The stream ended, and every check its format carries passed (invariant 11).
    done,
};

/// What a streaming call did.
pub const Progress = struct {
    /// Octets of the input taken. The caller never presents them again.
    consumed: usize,
    /// Octets of the output that hold data, from its start. The octets past them are scratch.
    written: usize,
    status: Status,
};

/// What a whole-buffer helper did (decision 11): the octets of the input its stream took, and the
/// octets it wrote from the output's start.
pub const Whole = struct {
    consumed: usize,
    written: usize,
};

/// The operational errors of a whole-buffer helper (decision 11): the input ended before the stream
/// did, or the output filled before the stream ended.
pub const Incomplete = error{ Truncated, NoSpaceLeft };

/// The whole-buffer form of a streaming call's progress, when that call had all the input and all
/// the output: its counts at `done`, and an error for a status that asks for more.
pub fn whole(progress: Progress) Incomplete!Whole {
    return switch (progress.status) {
        .done => .{ .consumed = progress.consumed, .written = progress.written },
        .needs_input => error.Truncated,
        .needs_room => error.NoSpaceLeft,
    };
}

/// What an encoder's caller says about the input it passes (decision 11).
pub const Flush = enum {
    /// More input follows; the encoder may hold input back to find matches.
    none,
    /// Write everything taken so far, so a decoder can produce all of it; the stream continues.
    flush,
    /// No input follows this call's; end the stream.
    finish,
};

/// The two classes of refusal a decoder's errors fall into (decision 11): the input breaks its
/// RFC, or it uses a feature stdx refuses.
pub const Refusal = enum { corrupt, unsupported };

/// True when `input` and `output` share any octet. Comparing the slices' addresses changes no
/// output.
pub fn overlap(input: []const u8, output: []const u8) bool {
    if (input.len == 0 or output.len == 0) return false;
    const input_start = @intFromPtr(input.ptr);
    const output_start = @intFromPtr(output.ptr);
    return input_start < output_start + output.len and output_start < input_start + input.len;
}

/// The check every streaming call makes at its entry: the input and the output do not overlap
/// (decision 11).
pub fn check_entry(input: []const u8, output: []const u8) void {
    assert(!overlap(input, output));
}

/// How a call's exit breaks invariant 7.
pub const Violation = enum {
    /// Invariant 7: more octets consumed than the input held.
    consumed_past_input,
    /// Invariant 7: more octets written than the output held.
    written_past_output,
    /// Invariant 7: `needs_input` with input left.
    needs_input_with_input_left,
    /// Invariant 7: `needs_room` with room left.
    needs_room_with_room_left,
};

/// The first way a call's exit breaks invariant 7, for an input of `input_len` octets and an output
/// of `output_len` octets, or null when it breaks none. Invariant 8 follows from it: a call that
/// returns `needs_input` took all of a non-empty input, and one that returns `needs_room` filled a
/// non-empty output, so either made progress unless its slice was empty.
pub fn violation(input_len: usize, output_len: usize, progress: Progress) ?Violation {
    if (progress.consumed > input_len) return .consumed_past_input;
    if (progress.written > output_len) return .written_past_output;
    return switch (progress.status) {
        .needs_input => if (progress.consumed != input_len) .needs_input_with_input_left else null,
        .needs_room => if (progress.written != output_len) .needs_room_with_room_left else null,
        .done => null,
    };
}

/// The check every streaming call makes at its exit (invariant 7, and invariant 8 with it).
pub fn check_progress(input_len: usize, output_len: usize, progress: Progress) void {
    assert(violation(input_len, output_len, progress) == null);
}

// Tests. `violation` and `overlap` carry the logic, so a test can show each case; the assertions
// that call them are the production check.

const testing = std.testing;

test "violation allows each status the counts explain" {
    try testing.expectEqual(null, violation(4, 4, .{ .consumed = 4, .written = 2, .status = .needs_input }));
    try testing.expectEqual(null, violation(4, 4, .{ .consumed = 1, .written = 4, .status = .needs_room }));
    try testing.expectEqual(null, violation(4, 4, .{ .consumed = 2, .written = 1, .status = .done }));
    try testing.expectEqual(null, violation(0, 4, .{ .consumed = 0, .written = 0, .status = .needs_input }));
    try testing.expectEqual(null, violation(4, 0, .{ .consumed = 0, .written = 0, .status = .needs_room }));
    try testing.expectEqual(null, violation(4, 4, .{ .consumed = 0, .written = 0, .status = .done }));
}

test "violation names each way a call's exit breaks invariant 7" {
    try testing.expectEqual(.consumed_past_input, violation(4, 4, .{ .consumed = 5, .written = 0, .status = .done }).?);
    try testing.expectEqual(.written_past_output, violation(4, 4, .{ .consumed = 0, .written = 5, .status = .done }).?);
    try testing.expectEqual(.needs_input_with_input_left, violation(4, 4, .{ .consumed = 3, .written = 0, .status = .needs_input }).?);
    try testing.expectEqual(.needs_room_with_room_left, violation(4, 4, .{ .consumed = 0, .written = 3, .status = .needs_room }).?);
    try testing.expectEqual(.needs_room_with_room_left, violation(4, 4, .{ .consumed = 0, .written = 0, .status = .needs_room }).?);
    try testing.expectEqual(.needs_input_with_input_left, violation(4, 4, .{ .consumed = 0, .written = 0, .status = .needs_input }).?);
}

test "whole gives the counts at done, and an error for each status that asks for more" {
    try testing.expectEqual(Whole{ .consumed = 3, .written = 7 }, try whole(.{ .consumed = 3, .written = 7, .status = .done }));
    try testing.expectError(error.Truncated, whole(.{ .consumed = 3, .written = 7, .status = .needs_input }));
    try testing.expectError(error.NoSpaceLeft, whole(.{ .consumed = 3, .written = 7, .status = .needs_room }));
}

test "overlap finds a shared octet, and not an adjacent or an empty slice" {
    var buffer: [8]u8 = undefined;
    try testing.expect(!overlap(buffer[0..4], buffer[4..8]));
    try testing.expect(!overlap(buffer[4..8], buffer[0..4]));
    try testing.expect(!overlap(buffer[0..0], buffer[0..8]));
    try testing.expect(overlap(buffer[0..5], buffer[4..8]));
    try testing.expect(overlap(buffer[4..8], buffer[0..5]));
    try testing.expect(overlap(buffer[2..3], buffer[0..8]));
}
