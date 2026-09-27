//! The copies of the Zstandard decoder's sequence execution fast path (decision 16, claim Z4 of
//! decision 14): literal runs and matches moved `constants.copy_chunk_len` octets at a time into the
//! caller's output, overrunning by less than a chunk into the room the fast path's margin leaves.
//!
//! A copy slices each side once for all its chunks, so one bounds check covers them, and asserts
//! nothing: it runs once per sequence, and decision 17 keeps assertions out of per-symbol loops.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Claims = @import("../claims.zig").Claims;

/// The chunks that cover `len` octets, one at least: the first chunk moves whatever the length, so
/// a run of none costs no branch.
inline fn chunks_of(comptime chunk_len: usize, len: usize) usize {
    return @max(1, std.math.divCeil(usize, len, chunk_len) catch unreachable);
}

/// Copies `len` octets from `from` to `to` in chunks of `chunk_len`, the first whatever the length.
/// Each chunk reads octets written before it: `from` ends before `to` starts, or starts at least
/// `chunk_len` before it.
inline fn move_chunks(comptime chunk_len: usize, to: []u8, from: []const u8, len: usize) void {
    const chunks = chunks_of(chunk_len, len);
    const into = to[0 .. chunks * chunk_len];
    const out_of = from[0 .. chunks * chunk_len];
    for (0..chunks) |chunk| into[chunk * chunk_len ..][0..chunk_len].* = out_of[chunk * chunk_len ..][0..chunk_len].*;
}

/// Where the fast path may take literals up to, from a section of `section_len` literals in
/// `literal_source`, or repeating one octet when `from_source` is false: past that index, the
/// source holds the chunk `overrun_of` says a copy of them may read past a run.
pub inline fn literals_end_of(comptime from_source: bool, comptime claims: Claims, section_len: u32, literal_source: []const u8) usize {
    if (!from_source or !claims.chunk_copies) return section_len;
    return @min(section_len, literal_source.len -| constants.copy_chunk_len);
}

/// The octets a copy of literals may read past a run: a chunk's, when it copies them from a source
/// in chunks.
pub inline fn overrun_of(comptime from_source: bool, comptime claims: Claims) usize {
    return if (from_source and claims.chunk_copies) constants.copy_chunk_len else 0;
}

/// Copies `len` octets of `source` from `start` to `target`: in chunks of `copy_chunk_len`, which
/// overrun both by less than one, where `source` holds a chunk past the run, and exactly otherwise.
pub inline fn copy_run(comptime claims: Claims, output: []u8, target: usize, source: []const u8, start: usize, len: usize) void {
    if (!claims.chunk_copies or source.len - start < len + constants.copy_chunk_len) {
        @memcpy(output[target..][0..len], source[start..][0..len]);
        return;
    }
    copy_run_chunks(output, target, source, start, len);
}

/// `copy_run` in chunks, for a caller that found a chunk past the run in `source`. Most runs fit
/// the first chunk.
pub inline fn copy_run_chunks(output: []u8, target: usize, source: []const u8, start: usize, len: usize) void {
    const chunk_len = constants.copy_chunk_len;
    output[target..][0..chunk_len].* = source[start..][0..chunk_len].*;
    if (len > chunk_len) move_chunks(chunk_len, output[target + chunk_len ..], source[start + chunk_len ..], len - chunk_len);
}

/// Writes `len` copies of `octet` at `target`: in chunks of `copy_chunk_len`, which overrun by less
/// than one, or exactly.
pub inline fn fill_run(comptime claims: Claims, output: []u8, target: usize, octet: u8, len: usize) void {
    const chunk_len = constants.copy_chunk_len;
    if (!claims.chunk_copies) {
        @memset(output[target..][0..len], octet);
        return;
    }
    const chunks = chunks_of(chunk_len, len);
    const into = output[target..][0 .. chunks * chunk_len];
    const chunk: [chunk_len]u8 = @splat(octet);
    for (0..chunks) |index| into[index * chunk_len ..][0..chunk_len].* = chunk;
}

/// Copies `len` octets to `target` from `distance` before it, a distance of 1 or more: in chunks
/// of `copy_chunk_len` or `copy_word_len` where the distance leaves room for one, by
/// `copy_pattern` below that, and exactly without the claim. A chunk may write less than its length
/// past `len`, into the margin, and reads only octets written before.
pub inline fn copy_within(comptime claims: Claims, output: []u8, target: usize, distance: usize, len: usize) void {
    const source = target - distance;
    const chunk_len = constants.copy_chunk_len;
    if (claims.chunk_copies and distance >= chunk_len) {
        // Most matches fit the first chunk.
        output[target..][0..chunk_len].* = output[source..][0..chunk_len].*;
        if (len > chunk_len) move_chunks(chunk_len, output[target + chunk_len ..], output[source + chunk_len ..], len - chunk_len);
    } else if (claims.chunk_copies and distance >= constants.copy_word_len) {
        move_chunks(constants.copy_word_len, output[target..], output[source..], len);
    } else if (claims.chunk_copies) {
        copy_pattern(output, target, distance, len);
    } else if (distance >= len) {
        @memcpy(output[target..][0..len], output[source..][0..len]);
    } else if (distance == 1) {
        @memset(output[target..][0..len], output[source]);
    } else {
        for (0..len) |index| output[target + index] = output[source + index];
    }
}

/// Copies `len` octets from `distance` before `target`, a distance under `copy_word_len`: the first
/// `copy_word_len` octets one at a time, each the octet `distance` before it; past them the octets
/// repeat every multiple of `distance`, so the rest move `copy_word_len` at a time from the least
/// multiple that is at least `copy_word_len` back. Writes up to `copy_word_len` past `len`.
inline fn copy_pattern(output: []u8, target: usize, distance: usize, len: usize) void {
    const word = constants.copy_word_len;
    const pattern = output[target - distance ..][0 .. word + distance];
    for (pattern[distance..], 0..) |*octet, index| octet.* = pattern[index];
    if (len <= word) return;
    const period = distance * (std.math.divCeil(usize, word, distance) catch unreachable);
    move_chunks(word, output[target + word ..], output[target + word - period ..], len - word);
}

/// Copies a match of `len` octets to `target` from `distance` before it, where the call's own
/// output holds only the last `own_len` octets of that history: what lies before from the window,
/// and the rest from the output.
pub fn copy_from_window(comptime Window: type, comptime claims: Claims, window: *const Window, output: []u8, target: usize, distance: usize, own_len: usize, len: usize) void {
    assert(distance > own_len);
    const copied = @min(len, distance - own_len);
    window.copy_back(distance - own_len, output[target..][0..copied]);
    if (copied < len) copy_within(claims, output, target + copied, distance, len - copied);
}

/// Whether `copy_from_window_chunks` can copy a match of `len` octets from `distance` before a
/// target past the call's own `own_len` octets: the window reaches that far, and the window's part
/// does not wrap past the end of its ring and leaves the ring a chunk's room past it.
pub inline fn window_chunks_fit(comptime Window: type, comptime claims: Claims, window: *const Window, distance: usize, own_len: usize, len: usize) bool {
    if (!claims.chunk_copies or distance - own_len > window.reach()) return false;
    const copied = @min(len, distance - own_len);
    return chunks_of(constants.copy_chunk_len, copied) * constants.copy_chunk_len <= window.ring_back(distance - own_len).len;
}

/// `copy_from_window`, with the window's part in chunks, for a match `window_chunks_fit` admits.
pub inline fn copy_from_window_chunks(comptime Window: type, comptime claims: Claims, window: *const Window, output: []u8, target: usize, distance: usize, own_len: usize, len: usize) void {
    const copied = @min(len, distance - own_len);
    move_chunks(constants.copy_chunk_len, output[target..], window.ring_back(distance - own_len), copied);
    if (copied < len) copy_within(claims, output, target + copied, distance, len - copied);
}

const testing = std.testing;

test "the literals a source's chunked copies may take leave a chunk of the source past them" {
    var source: [100]u8 = undefined;
    for (&source, 0..) |*octet, index| octet.* = @truncate(index);
    for ([_]usize{ 0, 1, 15, 16, 17, 99, 100 }) |source_len| {
        for ([_]u32{ 0, 1, 50, 84, 85, 200 }) |section_len| {
            const end = literals_end_of(true, .{}, section_len, source[0..source_len]);
            try testing.expect(end <= section_len);
            // Past a source shorter than a chunk the caller takes nothing; past any other, every
            // run that ends by `end` leaves a chunk of the source for its last chunk to read.
            if (source_len >= constants.copy_chunk_len) try testing.expect(end + overrun_of(true, .{}) <= source_len);
            try testing.expectEqual(section_len, literals_end_of(false, .{}, section_len, source[0..source_len]));
            try testing.expectEqual(section_len, literals_end_of(true, .{ .chunk_copies = false }, section_len, source[0..source_len]));
        }
    }
}

test "a window part copies in chunks only where the ring holds a chunk past it, as the ring's copy does" {
    const codec = @import("codec");
    const Window = codec.Window(64);
    var window: Window = undefined;
    window.init();
    var history: [100]u8 = undefined;
    for (&history, 0..) |*octet, index| octet.* = @truncate(index * 7 + 1);
    // The ring wraps: its next octet goes at 36, and the history before it runs back past its end.
    window.append(&history);
    const own = [_]u8{ 0xa5, 0x5a, 0x33 };
    for (0..own.len + 1) |own_len| {
        for (own_len + 1..own_len + window.reach() + 1) |distance| {
            for ([_]usize{ 1, 5, 16, 17, 40 }) |len| {
                // The call's own output, then the match, then a margin for the chunks' overrun.
                var chunked: [own.len + 40 + 2 * constants.copy_chunk_len]u8 = @splat(0);
                var exact: [chunked.len]u8 = @splat(0);
                @memcpy(chunked[0..own_len], own[0..own_len]);
                @memcpy(exact[0..own_len], own[0..own_len]);
                copy_from_window(Window, .{}, &window, &exact, own_len, distance, own_len, len);
                if (!window_chunks_fit(Window, .{}, &window, distance, own_len, len)) continue;
                copy_from_window_chunks(Window, .{}, &window, &chunked, own_len, distance, own_len, len);
                try testing.expectEqualSlices(u8, exact[0 .. own_len + len], chunked[0 .. own_len + len]);
            }
        }
    }
}
