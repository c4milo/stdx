//! The brotli fast path's copies (decision 16, S4): a back-reference copied within the caller's
//! output in chunks that may overrun into the margin, or from the window for the octets before the
//! call's output.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

/// Copies `len` octets to `target` from `distance` before it, within `output`: in chunks (S4) when
/// `chunks` holds, and an octet at a time otherwise.
pub inline fn within(comptime chunks: bool, output: []u8, target: usize, distance: usize, len: usize) void {
    assert(distance >= 1 and distance <= target);
    if (chunks) copy_within(output, target, distance, len) else copy_exact(output, target, distance, len);
}

/// Copies a back-reference that reaches before this call's output: its first octets from the
/// window, whose newest octet is the one before `start` in the output, and the rest from the
/// output, an octet at a time. The caller has kept `distance` within the octets produced and the
/// window (RFC 7932 §4, §9.1).
pub fn from_window(window: anytype, output: []u8, target: usize, start: usize, distance: usize, len: usize) void {
    assert(distance > target);
    assert(start <= target);
    const window_len = @min(len, distance - target);
    window.copy_back(distance - target + start, output[target..][0..window_len]);
    if (window_len == len) return;
    copy_exact(output, target + window_len, distance, len - window_len);
}

/// Copies `len` octets to `target` from `distance` before it, an octet at a time, so the copy reads
/// what it wrote when it overlaps itself, and writes nothing past `len`.
inline fn copy_exact(output: []u8, target: usize, distance: usize, len: usize) void {
    const source = target - distance;
    for (0..len) |index| output[target + index] = output[source + index];
}

/// Copies `len` octets to `target` from `distance` before it: in chunks of `copy_chunk_len` or
/// `copy_word_len` octets where the distance leaves room for one, a fill for a distance of 1, and
/// an octet at a time otherwise. A chunk may write up to its length less one past `len`, into the
/// margin, and reads only octets written before.
inline fn copy_within(output: []u8, target: usize, distance: usize, len: usize) void {
    if (distance >= constants.copy_chunk_len) {
        copy_chunks(constants.copy_chunk_len, output, target, distance, len);
    } else if (distance >= constants.copy_word_len) {
        copy_chunks(constants.copy_word_len, output, target, distance, len);
    } else if (distance == 1) {
        fill(output, target, output[target - 1], len);
    } else {
        copy_exact(output, target, distance, len);
    }
}

/// Copies `len` octets in chunks of `chunk_len`, which the distance is at least, so each chunk reads
/// octets written before it.
inline fn copy_chunks(comptime chunk_len: usize, output: []u8, target: usize, distance: usize, len: usize) void {
    const source = target - distance;
    const chunks = std.math.divCeil(usize, len, chunk_len) catch unreachable;
    for (0..chunks) |chunk| {
        const offset = chunk * chunk_len;
        output[target + offset ..][0..chunk_len].* = output[source + offset ..][0..chunk_len].*;
    }
}

/// Writes `len` copies of `octet`, a chunk at a time.
inline fn fill(output: []u8, target: usize, octet: u8, len: usize) void {
    const chunk: [constants.copy_chunk_len]u8 = @splat(octet);
    const chunks = std.math.divCeil(usize, len, constants.copy_chunk_len) catch unreachable;
    for (0..chunks) |index| output[target + index * constants.copy_chunk_len ..][0..constants.copy_chunk_len].* = chunk;
}

// Tests.

const testing = std.testing;

test "a chunked copy writes what an exact copy writes, at every short distance" {
    for (1..constants.copy_chunk_len * 2 + 1) |distance| {
        var chunked: [constants.chunk_len_max + constants.copy_chunk_len]u8 = undefined;
        var exact: [constants.chunk_len_max + constants.copy_chunk_len]u8 = undefined;
        for (chunked[0..distance], exact[0..distance], 0..) |*a, *b, index| {
            a.* = @intCast(index + 1);
            b.* = @intCast(index + 1);
        }
        const len = constants.chunk_len_max - distance;
        within(true, &chunked, distance, distance, len);
        within(false, &exact, distance, distance, len);
        try testing.expectEqualSlices(u8, exact[0 .. distance + len], chunked[0 .. distance + len]);
    }
}
