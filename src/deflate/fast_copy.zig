//! The fast path's match copies (decision 14, S4): in chunks inside this call's output, overrunning
//! into the room the margin leaves, and octet by octet from the window, where a match reaches
//! before this call's output. Split from fast.zig, which decodes the pairs they copy.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const constants = @import("constants.zig");

/// The room after a match's target that the wide loop's margin leaves: a longest match and the
/// overrun of its last chunk.
pub const room_len = constants.match_len_max + constants.copy_chunk_len;

/// The history a match copied from the window reaches.
pub const Window = struct {
    window: *codec.Window(constants.window_len),
    /// Where the output stands in the window: the octets before it are in the window.
    synced: usize,
    /// The farthest distance the stream may take (`limit_window`).
    distance_max: usize,
};

/// Copies a match from anywhere in the history: from this call's output, in chunks when `chunked`
/// (S4) and an octet at a time otherwise, or from the window. Returns false, having copied nothing,
/// for a distance past the history or the container's window.
pub inline fn copy_match(comptime chunked: bool, output: []u8, written: usize, history: Window, distance: usize, len: usize) bool {
    if (distance <= written and distance <= history.distance_max) {
        if (chunked) copy_within(output, written, distance, len) else copy_exact(output, written, distance, len);
        return true;
    }
    return copy_from_window(output, written, history, distance, len);
}

/// Copies a match that reaches before this call's output: its first octets from the window, the
/// rest from the output, octet by octet. Returns false, having copied nothing, for a distance past
/// the history or the container's window, which the checked path refuses. It copies from the ring
/// by an index it wraps itself, so it calls no function.
inline fn copy_from_window(output: []u8, written: usize, history: Window, distance: usize, len: usize) bool {
    assert(distance > written or distance > history.distance_max);
    assert(history.synced <= written);
    const reach = @min(constants.window_len, history.window.reach() + written - history.synced);
    if (distance > reach or distance > history.distance_max) return false;
    const from_window = @min(len, distance - written);
    // The window's newest octet is the one before `synced`.
    const first = history.window.ring_index(distance - written + history.synced);
    for (output[written..][0..from_window], 0..) |*into, index| {
        into.* = history.window.octets[(first + index) % constants.window_len];
    }
    if (from_window == len) return true;
    // The rest, when a match runs from the window into this call's output, is short.
    copy_exact(output, written + from_window, distance, len - from_window);
    return true;
}

/// Copies `len` octets to `target` from `distance` before it, octet by octet, so the copy reads
/// what it wrote when the match overlaps itself, and writes nothing past `len`.
pub inline fn copy_exact(output: []u8, target: usize, distance: usize, len: usize) void {
    const source = target - distance;
    for (0..len) |index| output[target + index] = output[source + index];
}

/// Copies `len` octets to `target` from `distance` before it: in chunks of `copy_chunk_len` or
/// `copy_word_len` octets where the distance leaves room for one, a fill for a distance of 1, and
/// octet by octet otherwise. A chunk may write up to its length less one past `len`, into the
/// room, and reads only octets written before.
inline fn copy_within(output: []u8, target: usize, distance: usize, len: usize) void {
    const source = target - distance;
    if (distance >= constants.copy_chunk_len) {
        copy_chunks(constants.copy_chunk_len, output, target, distance, len);
    } else if (distance >= constants.copy_word_len) {
        copy_chunks(constants.copy_word_len, output, target, distance, len);
    } else if (distance == 1) {
        fill(output, target, output[source], len);
    } else {
        for (0..len) |index| output[target + index] = output[source + index];
    }
}

/// The chunks a match copy writes before it looks at the length: most matches are that short.
const chunks_unconditional = 2;

/// The chunks of `chunk_len` octets the room after a match's target holds: enough for a longest
/// match, and each chunk ends inside the room.
fn chunks_max(comptime chunk_len: usize) usize {
    return (room_len - chunk_len) / chunk_len + 1;
}

comptime {
    for ([_]usize{ constants.copy_chunk_len, constants.copy_word_len }) |chunk_len| {
        assert(chunks_max(chunk_len) * chunk_len >= constants.match_len_max);
        assert(chunks_max(chunk_len) * chunk_len <= room_len);
    }
}

/// Copies `len` octets in chunks of `chunk_len`: the first `chunks_unconditional` whatever the
/// length, and the rest in a loop. One span holds every octet the copy reads and writes, from the
/// source to the end of the room after the target, so it is bounded once, and every chunk sits
/// at an offset its length covers.
pub inline fn copy_chunks(comptime chunk_len: usize, output: []u8, target: usize, distance: usize, len: usize) void {
    const span = output[target - distance ..][0 .. distance + room_len];
    const into = span[distance..][0..room_len];
    inline for (0..chunks_unconditional) |chunk| {
        into[chunk * chunk_len ..][0..chunk_len].* = span[chunk * chunk_len ..][0..chunk_len].*;
    }
    if (len <= chunks_unconditional * chunk_len) return;
    for (chunks_unconditional..chunks_max(chunk_len)) |chunk| {
        if (chunk * chunk_len >= len) return;
        into[chunk * chunk_len ..][0..chunk_len].* = span[chunk * chunk_len ..][0..chunk_len].*;
    }
}

/// Writes `len` copies of `octet`, a chunk at a time, into the room after `target`.
fn fill(output: []u8, target: usize, octet: u8, len: usize) void {
    const chunk_len = constants.copy_chunk_len;
    const chunk: [chunk_len]u8 = @splat(octet);
    const into = output[target..][0..room_len];
    for (0..chunks_max(chunk_len)) |index| {
        if (index * chunk_len >= len) return;
        into[index * chunk_len ..][0..chunk_len].* = chunk;
    }
}

/// For each distance below a chunk, the index of each octet of a match's first chunk in the chunk
/// before the target: the octet the distance before it, taken modulo the distance. And the least
/// multiple of the distance a chunk long at least, which the rest of the match copies from.
pub const Repeats = extern struct {
    indices: [constants.copy_chunk_len][constants.copy_chunk_len]u8,
    steps: [constants.copy_chunk_len]u8,
};

pub const repeats: Repeats = table: {
    const chunk_len = constants.copy_chunk_len;
    var table: Repeats = .{ .indices = @splat(@splat(0)), .steps = @splat(0) };
    for (1..chunk_len) |distance| {
        for (&table.indices[distance], 0..) |*index, place| index.* = chunk_len - distance + place % distance;
        table.steps[distance] = (chunk_len + distance - 1) / distance * distance;
    }
    break :table table;
};

test "each distance below a chunk repeats its octets through a match's first chunk" {
    for (1..constants.copy_chunk_len) |distance| {
        const step = repeats.steps[distance];
        try std.testing.expect(step % distance == 0 and step >= constants.copy_chunk_len and step < constants.copy_chunk_len + distance);
        for (repeats.indices[distance], 0..) |index, place| {
            // The octet `distance` before each octet of the chunk, in the chunk before it.
            try std.testing.expectEqual(constants.copy_chunk_len - distance + place % distance, index);
            try std.testing.expect(index < constants.copy_chunk_len);
        }
    }
}
