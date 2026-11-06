//! Level 1's parse in one loop (decision 62, the owner's ruling of 2026-11-06): the positions of a
//! meta-block, each probed in codec's match finder's tables, with each match handed to the
//! commands as it is found. It writes the octets the shared finder's parse writes, which stays the
//! reference (`EncoderOptions.lean_parse` off), and differs from it in form alone: one loop, a
//! candidate's range checked by one compare, and no sink between the parse and the commands.
//!
//! A position tries, in order, the last distance after a literal, the long table's entry, the
//! short table's entry, and then the long table at the next position; a match extends back over
//! the literals before it and forward to the meta-block's end. The commands refuse a match worth
//! less than its literals (`Commands.takes`), and the parse then moves on as after a miss.

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const encoder_commands = @import("encoder_commands.zig");

const finder = codec.match_finder;
const read_len = codec.constants.match_read_len;

/// A match: where it starts, and the position it copies from.
const Match = struct { position: usize, candidate: usize };

/// The entries that name a candidate at one position: those `limit` octets back or fewer, and
/// never the position itself. `limit` is the window's reach, or less near the stream's start,
/// where it keeps position 0 out as codec's match_finder.zig does.
const Range = struct {
    position: usize,
    entry: u32,
    limit: u32,

    inline fn at(comptime safety: bool, base: u32, position: usize, reach_len: usize) Range {
        @setRuntimeSafety(safety);
        const limit = if (position > reach_len) reach_len else position -| 1;
        return .{ .position = position, .entry = base +% @as(u32, @truncate(position)), .limit = @intCast(limit) };
    }

    /// The position `held` names, when the range holds it: a distance from 1 to `limit`. The
    /// subtractions wrap, so one compare refuses an entry at the position or past it, and one
    /// further back than `limit`, an earlier frame's among them.
    inline fn candidate(self: Range, comptime safety: bool, held: u32) ?usize {
        @setRuntimeSafety(safety);
        const distance = self.entry -% held;
        if (distance -% 1 >= self.limit) return null;
        return self.position - distance;
    }
};

/// Parses `window[start..end]`, whose history is `window[0..start]`, into `commands`.
pub fn parse(comptime level: finder.Level, comptime safety: bool, matcher: *finder.Matcher(level), window: []const u8, start: usize, end: usize, commands: *encoder_commands.Commands) void {
    @setRuntimeSafety(safety);
    assert(start <= end and end <= window.len and level.long_hash_log > 0);
    const search_end = end -| read_len;
    var position = start;
    var anchor = start;
    for (0..end - start) |_| {
        if (position >= search_end) break;
        const match = find(level, safety, matcher, window, position, anchor, end, commands.repeat_offset()) orelse {
            position += 1 + ((position - anchor) >> codec.constants.match_skip_log);
            continue;
        };
        const found = extend(safety, window, match, anchor, end);
        if (!commands.takes(safety, found.len, found.offset)) {
            position += 1 + ((position - anchor) >> codec.constants.match_skip_log);
            continue;
        }
        commands.add(safety, window, anchor, found.position, found.len, found.offset);
        const match_end = found.position + found.len;
        insert(level, safety, matcher, window, found.position + codec.constants.match_insert_skip, match_end, search_end);
        position = match_end;
        anchor = match_end;
    }
    commands.add_literals(safety, window[anchor..end]);
}

/// The candidate at `position`, or at the octet after it from the long table, as codec's finder
/// tries them. Records `position` in both tables either way.
inline fn find(comptime level: finder.Level, comptime safety: bool, matcher: *finder.Matcher(level), window: []const u8, position: usize, anchor: usize, end: usize, repeat_offset: u32) ?Match {
    @setRuntimeSafety(safety);
    const word = read64(safety, window, position);
    const range = Range.at(safety, matcher.base, position, reach(level));
    const short_slot = &matcher.short[hash(safety, word, level.short_hash_len, level.short_hash_log)];
    const long_slot = &matcher.long[hash(safety, word, codec.constants.long_hash_len, level.long_hash_log)];
    const short_held = short_slot.*;
    const long_held = long_slot.*;
    short_slot.* = range.entry;
    long_slot.* = range.entry;
    // The last distance, after at least one literal.
    if (position != anchor and repeat_offset -% 1 < range.limit) {
        if (read32(safety, window, position - repeat_offset) == @as(u32, @truncate(word))) return .{ .position = position, .candidate = position - repeat_offset };
    }
    if (range.candidate(safety, long_held)) |candidate| {
        if (read64(safety, window, candidate) == word) return .{ .position = position, .candidate = candidate };
    }
    const short_candidate = range.candidate(safety, short_held) orelse return null;
    if (read32(safety, window, short_candidate) != @as(u32, @truncate(word))) return null;
    if (position + 1 + read_len <= end) {
        if (long_next(level, safety, matcher, window, position + 1, matcher.base)) |candidate| return .{ .position = position + 1, .candidate = candidate };
    }
    return .{ .position = position, .candidate = short_candidate };
}

/// The long table's candidate at `position`, the octet after a short match, which it records.
inline fn long_next(comptime level: finder.Level, comptime safety: bool, matcher: *finder.Matcher(level), window: []const u8, position: usize, base: u32) ?usize {
    @setRuntimeSafety(safety);
    const word = read64(safety, window, position);
    const next = Range.at(safety, base, position, reach(level));
    const slot = &matcher.long[hash(safety, word, codec.constants.long_hash_len, level.long_hash_log)];
    const held = slot.*;
    slot.* = next.entry;
    const candidate = next.candidate(safety, held) orelse return null;
    if (read64(safety, window, candidate) == word) return candidate;
    return null;
}

const Found = struct { position: usize, len: usize, offset: usize };

/// `match` extended back over the literals from `anchor` while the octets before both agree, and
/// forward to `end`.
inline fn extend(comptime safety: bool, window: []const u8, match: Match, anchor: usize, end: usize) Found {
    @setRuntimeSafety(safety);
    var position = match.position;
    var candidate = match.candidate;
    for (0..match.position - anchor) |_| {
        if (candidate == 0 or window[position - 1] != window[candidate - 1]) break;
        position -= 1;
        candidate -= 1;
    }
    return .{ .position = position, .len = match_len(safety, window, candidate, position, end), .offset = position - candidate };
}

/// The octets from `candidate` and from `position` that agree, up to `end`.
inline fn match_len(comptime safety: bool, window: []const u8, candidate: usize, position: usize, end: usize) usize {
    @setRuntimeSafety(safety);
    const limit = end - position;
    var len: usize = 0;
    for (0..limit / @sizeOf(u64)) |_| {
        const difference = read64(safety, window, candidate + len) ^ read64(safety, window, position + len);
        if (difference != 0) return len + @ctz(difference) / @bitSizeOf(u8);
        len += @sizeOf(u64);
    }
    for (0..limit - len) |_| {
        if (window[candidate + len] != window[position + len]) break;
        len += 1;
    }
    return len;
}

/// Records positions inside a match in both tables, as codec's finder does: every
/// `match_insert_step`th from `first`, and the one `match_insert_tail` before its end.
inline fn insert(comptime level: finder.Level, comptime safety: bool, matcher: *finder.Matcher(level), window: []const u8, first: usize, match_end: usize, search_end: usize) void {
    @setRuntimeSafety(safety);
    const last = @min(match_end, search_end);
    if (last < first + codec.constants.match_insert_tail) return;
    const tail_first = last - codec.constants.match_insert_tail;
    for (0..(tail_first - first) / codec.constants.match_insert_step + 1) |index| {
        record(level, safety, matcher, window, first + index * codec.constants.match_insert_step);
    }
    record(level, safety, matcher, window, tail_first);
}

inline fn record(comptime level: finder.Level, comptime safety: bool, matcher: *finder.Matcher(level), window: []const u8, position: usize) void {
    @setRuntimeSafety(safety);
    const word = read64(safety, window, position);
    const entry = matcher.base +% @as(u32, @truncate(position));
    matcher.short[hash(safety, word, level.short_hash_len, level.short_hash_log)] = entry;
    matcher.long[hash(safety, word, codec.constants.long_hash_len, level.long_hash_log)] = entry;
}

/// The farthest a match reaches back (codec's `Level.reach_max`).
fn reach(comptime level: finder.Level) usize {
    return level.reach_max orelse (@as(usize, 1) << level.window_log) - 1;
}

/// The hash of `word`'s first `len` octets, `log` bits wide, as codec's finder takes it.
inline fn hash(comptime safety: bool, word: u64, comptime len: u4, comptime log: u5) usize {
    @setRuntimeSafety(safety);
    const kept = word << (@bitSizeOf(u64) - @as(u7, len) * @bitSizeOf(u8));
    return @intCast((kept *% codec.constants.match_hash_multiplier) >> (@bitSizeOf(u64) - @as(u7, log)));
}

inline fn read64(comptime safety: bool, window: []const u8, position: usize) u64 {
    @setRuntimeSafety(safety);
    return std.mem.readInt(u64, window[position..][0..@sizeOf(u64)], .little);
}

inline fn read32(comptime safety: bool, window: []const u8, position: usize) u32 {
    @setRuntimeSafety(safety);
    return std.mem.readInt(u32, window[position..][0..@sizeOf(u32)], .little);
}
