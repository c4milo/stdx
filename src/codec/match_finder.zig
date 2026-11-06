//! The match finder of the brotli encoder (decision 62), written from the Zstandard encoder's
//! (decisions 57 and 60): it turns one block of the window into matches and the literals between
//! them, which a sink records in its codec's form. The Zstandard encoder keeps its own copy, as the
//! owner ruled once a pair showed the move cost it speed.
//! Its tables hash each position's first `short_hash_len` octets into one table; a level with a
//! long table also hashes the first 8 octets into a second, larger one, prefers a match the long
//! table finds, and tries the next position's long match before it takes a short one. Both try the
//! sink's repeat offset before the tables, and both step faster through octets that find nothing.
//!
//! A sink holds three calls: `add(window, anchor, position, len, offset)` records the literals
//! from `anchor` to `position` and a match of `len` octets `offset` back; `add_literals(octets)`
//! records the literals after the last match; and `repeat_offset()` names the offset tried first,
//! Zstandard's Repeated_Offset1 (RFC 8878 §3.1.1.5) or brotli's last distance (RFC 7932 §4).
//!
//! A table entry holds a window position, and above it the tag of the frame that stored it: the
//! frame's base, its tag shifted above every position, plus the position. Tags only grow between
//! clears, so an entry of an earlier frame lies below the base, and one range check finds an entry
//! of this frame that the window still reaches. An entry of position 0 names no candidate, so a
//! frame's first octet never starts a match. `init` clears the tables once; `start` begins the next
//! frame by moving to the next tag, and clears them again only when the tags run out (decision 60).
//! So every choice reads only the window's octets from the frame's start to the block's end, and
//! the matches are a function of the input alone (invariant 5).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// A level's match finder.
pub const Level = struct {
    /// Log2 of the window: the history a match reaches, which the frame's Window_Descriptor names.
    window_log: u5,
    /// Log2 of the short table's entries, and the octets its hash reads.
    short_hash_log: u5,
    short_hash_len: u4,
    /// Log2 of the long table's entries, which hash 8 octets; 0 for a level with one table.
    long_hash_log: u5,
    /// The farthest a match reaches back; null for one octet less than the window. A format whose
    /// longest distances name something other than the window names a shorter reach.
    reach_max: ?u32 = null,
    /// False runs the finder's functions without Zig's checks, for a codec whose entry in
    /// decision 16 rules it; the default keeps them.
    runtime_safety: bool = true,
};

/// The farthest a match of `level` reaches back.
fn reach(comptime level: Level) usize {
    const window_reach = (@as(usize, 1) << level.window_log) - 1;
    const level_reach = level.reach_max orelse return window_reach;
    comptime std.debug.assert(level_reach > 0 and level_reach <= window_reach);
    return level_reach;
}

/// The tables of `level`'s match finder.
pub fn Matcher(comptime level: Level) type {
    return struct {
        const Self = @This();

        short: [@as(usize, 1) << level.short_hash_log]u32,
        long: if (level.long_hash_log > 0) [@as(usize, 1) << level.long_hash_log]u32 else void,
        /// The frame's tag, from 1 up, and its base: the tag above every position.
        tag: u32,
        base: u32,

        /// Empties the tables, so no position of an earlier frame or of uninitialized memory names a
        /// candidate (invariant 4), and starts the first frame's tag.
        pub fn init(self: *Self) void {
            clear(level, self);
        }

        /// Begins the next frame of a matcher `init` started: the next tag, which no entry holds, or
        /// a clear when the tags ran out.
        pub fn start(self: *Self) void {
            self.tag += 1;
            if (self.tag == @as(u64, 1) << tag_bits(level)) return clear(level, self);
            self.base = self.tag << position_bits(level);
        }

        /// Moves every position of this frame `shift` octets down, after the window slid by that
        /// much. A position that slid out becomes 0.
        pub fn slide(self: *Self, shift: u32) void {
            slide_entries(&self.short, self.base, shift);
            if (level.long_hash_log > 0) slide_entries(&self.long, self.base, shift);
        }

        /// Parses `window[first..end]`, whose history is `window[0..first]`, into `sink`. A match
        /// ends at `end` at the latest, and reaches back less than the window's length.
        pub fn parse(self: *Self, window: []const u8, first: usize, end: usize, sink: anytype) void {
            parse_block(level, self, window, first, end, sink);
        }
    };
}

/// The bits a table entry's position takes: the window and a block are less than twice the
/// window.
fn position_bits(comptime level: Level) u5 {
    return level.window_log + 1;
}

/// The bits above the position, which hold the frame's tag.
fn tag_bits(comptime level: Level) u6 {
    return @bitSizeOf(u32) - @as(u6, position_bits(level));
}

fn clear(comptime level: Level, self: *Matcher(level)) void {
    @memset(&self.short, 0);
    if (level.long_hash_log > 0) @memset(&self.long, 0);
    self.tag = 1;
    self.base = @as(u32, 1) << position_bits(level);
}

/// Moves this frame's entries `shift` positions down, and empties the ones that slid out and every
/// earlier frame's, which lie below `base` and name no candidate anyway. A select on
/// `constants.match_slide_lanes` entries at a time, not a branch: after `start` the tables mix both
/// kinds, and a branch on them would mispredict. The subtraction wraps, as a checked one would
/// branch on each entry; an entry above `kept_min` holds more than `shift`, so it never wraps.
fn slide_entries(entries: []u32, base: u32, shift: u32) void {
    const Lanes = @Vector(constants.match_slide_lanes, u32);
    assert(entries.len % constants.match_slide_lanes == 0);
    const kept_min: Lanes = @splat(base + shift);
    const shifts: Lanes = @splat(shift);
    const empty: Lanes = @splat(0);
    for (0..entries.len / constants.match_slide_lanes) |index| {
        const lanes = entries[index * constants.match_slide_lanes ..][0..constants.match_slide_lanes];
        const held: Lanes = lanes.*;
        lanes.* = @select(u32, held > kept_min, held -% shifts, empty);
    }
}

fn parse_block(comptime level: Level, self: *Matcher(level), window: []const u8, start: usize, end: usize, sink: anytype) void {
    @setRuntimeSafety(level.runtime_safety);
    assert(start <= end and end <= window.len);
    // Every position, below `end`, fits below the base's tag.
    assert(end <= @as(usize, 1) << position_bits(level));
    var position = start;
    var anchor = start;
    // A hash reads 8 octets, so a position searches only with 8 ahead; the last few octets go out
    // as literals.
    const search_end = end -| constants.match_read_len;
    for (0..end - start) |_| {
        if (position >= search_end) break;
        const found = worth(level.runtime_safety, sink, find(level, self, window, position, anchor, end, sink.repeat_offset())) orelse {
            position += 1 + ((position - anchor) >> constants.match_skip_log);
            continue;
        };
        sink.add(window, anchor, found.position, found.len, found.offset);
        const match_end = found.position + found.len;
        insert(level, self, window, found.position + constants.match_insert_skip, match_end, search_end);
        position = match_end;
        anchor = match_end;
    }
    sink.add_literals(window[anchor..end]);
}

/// `found`, unless the sink has a `takes` and it refuses the match: a codec may judge a match
/// worth less than the literals it replaces.
inline fn worth(comptime safety: bool, sink: anytype, found: ?Found) ?Found {
    @setRuntimeSafety(safety);
    const match = found orelse return null;
    const Sink = @typeInfo(@TypeOf(sink)).pointer.child;
    if (@hasDecl(Sink, "takes") and !sink.takes(match.len, match.offset)) return null;
    return match;
}

/// The match at `position`, or at the octet after it for a long table, extended back over literals
/// that match too: the repeat offset's first, then the tables'. The tables record
/// `position` either way.
fn find(comptime level: Level, self: *Matcher(level), window: []const u8, position: usize, anchor: usize, end: usize, repeat_offset: u32) ?Found {
    @setRuntimeSafety(level.runtime_safety);
    // The lowest position a candidate takes: the window's reach, and never position 0.
    const low = @max(position -| reach(level), 1);
    const bounds = Bounds.at(self.base, position, low);
    const word = read64(level.runtime_safety, window, position);
    const short_entry = swap(level.runtime_safety, &self.short[hash(level.runtime_safety, word, level.short_hash_len, level.short_hash_log)], bounds.entry);
    const long_entry = if (level.long_hash_log > 0) swap(level.runtime_safety, &self.long[hash(level.runtime_safety, word, constants.long_hash_len, level.long_hash_log)], bounds.entry) else 0;
    if (repeat_candidate(level.runtime_safety, window, position, anchor, low, repeat_offset, word)) |candidate| return extend(level.runtime_safety, window, position, candidate, anchor, end);
    if (level.long_hash_log > 0) {
        if (bounds.candidate(long_entry)) |candidate| {
            if (read64(level.runtime_safety, window, candidate) == word) return extend(level.runtime_safety, window, position, candidate, anchor, end);
        }
    }
    const short_candidate = bounds.candidate(short_entry) orelse return null;
    if (read32(level.runtime_safety, window, short_candidate) != @as(u32, @truncate(word))) return null;
    if (level.long_hash_log > 0 and position + 1 + constants.match_read_len <= end) {
        // The next position's own range: its window's reach starts an octet later.
        const next = Bounds.at(self.base, position + 1, @max(position + 1 -| reach(level), 1));
        if (long_next(level, self, window, position + 1, next)) |candidate| return extend(level.runtime_safety, window, position + 1, candidate, anchor, end);
    }
    return extend(level.runtime_safety, window, position, short_candidate, anchor, end);
}

/// The repeat offset's candidate after at least one literal, where the codecs name it the cheapest,
/// when it lies at `low` or above and its first 4 octets agree with `word`'s. A position
/// after a literal lies above `low`, so the subtraction never wraps.
inline fn repeat_candidate(comptime safety: bool, window: []const u8, position: usize, anchor: usize, low: usize, repeat_offset: u32, word: u64) ?usize {
    @setRuntimeSafety(safety);
    if (position == anchor or repeat_offset > position - low) return null;
    const candidate = position - repeat_offset;
    if (read32(safety, window, candidate) != @as(u32, @truncate(word))) return null;
    return candidate;
}

/// Stores `position`'s entry in `slot` and returns the entry it held.
inline fn swap(comptime safety: bool, slot: *u32, entry: u32) u32 {
    @setRuntimeSafety(safety);
    const held = slot.*;
    slot.* = entry;
    return held;
}

/// The entries one position reads and writes: its own, and the range of entries that name a
/// candidate there. The range starts at the window's reach, never at position 0, and ends before
/// the position; an earlier frame's entries lie below `base`. A position fits below the base's tag
/// (`parse_block`), so the additions never wrap and the truncations lose no bit.
const Bounds = struct {
    base: u32,
    lowest: u32,
    entry: u32,

    inline fn at(base: u32, position: usize, low: usize) Bounds {
        return .{
            .base = base,
            .lowest = base +% @as(u32, @truncate(low)),
            .entry = base +% @as(u32, @truncate(position)),
        };
    }

    /// The position `entry` names, when it lies in the range.
    inline fn candidate(self: Bounds, entry: u32) ?u32 {
        if (entry < self.lowest or entry >= self.entry) return null;
        return entry -% self.base;
    }
};

/// The long table's match at `position`, the octet after a short one, which it records in the long
/// table.
fn long_next(comptime level: Level, self: *Matcher(level), window: []const u8, position: usize, bounds: Bounds) ?u32 {
    @setRuntimeSafety(level.runtime_safety);
    const word = read64(level.runtime_safety, window, position);
    const entry = swap(level.runtime_safety, &self.long[hash(level.runtime_safety, word, constants.long_hash_len, level.long_hash_log)], bounds.entry);
    const candidate = bounds.candidate(entry) orelse return null;
    if (read64(level.runtime_safety, window, candidate) == word) return candidate;
    return null;
}

/// Records positions inside a match in the tables: every `constants.match_insert_step`th from
/// `first`, and the one `constants.match_insert_tail` before its end, which later matches often
/// continue from.
fn insert(comptime level: Level, self: *Matcher(level), window: []const u8, first: usize, match_end: usize, search_end: usize) void {
    @setRuntimeSafety(level.runtime_safety);
    const last = @min(match_end, search_end);
    if (last < first + constants.match_insert_tail) return;
    // The positions from `first`, a step apart, that lie `match_insert_tail` or more before `last`.
    const tail_first = last - constants.match_insert_tail;
    for (0..(tail_first - first) / constants.match_insert_step + 1) |index| {
        record(level, self, window, first + index * constants.match_insert_step);
    }
    record(level, self, window, tail_first);
}

fn record(comptime level: Level, self: *Matcher(level), window: []const u8, position: usize) void {
    @setRuntimeSafety(level.runtime_safety);
    const word = read64(level.runtime_safety, window, position);
    const entry = self.base +% @as(u32, @truncate(position));
    self.short[hash(level.runtime_safety, word, level.short_hash_len, level.short_hash_log)] = entry;
    if (level.long_hash_log > 0) self.long[hash(level.runtime_safety, word, constants.long_hash_len, level.long_hash_log)] = entry;
}

/// A match: where it starts, its length and its offset.
const Found = struct { position: usize, len: usize, offset: usize };

/// A match of `candidate` at `position`, extended back over the literals from `anchor` while the
/// octets before both agree, and forward to `end`. The loop's count stops it at `anchor`, and the
/// offset stays the one the window reached, as both move back together.
fn extend(comptime safety: bool, window: []const u8, position_first: usize, candidate_first: usize, anchor: usize, end: usize) align(constants.match_function_alignment) Found {
    @setRuntimeSafety(safety);
    var position = position_first;
    var candidate = candidate_first;
    for (0..position_first - anchor) |_| {
        if (candidate == 0) break;
        if (window[position - 1] != window[candidate - 1]) break;
        position -= 1;
        candidate -= 1;
    }
    const len = match_len(safety, window, candidate, position, end);
    return .{ .position = position, .len = len, .offset = position - candidate };
}

/// The octets from `candidate` and from `position` that agree, up to `end`.
fn match_len(comptime safety: bool, window: []const u8, candidate: usize, position: usize, end: usize) usize {
    @setRuntimeSafety(safety);
    assert(candidate < position and position <= end);
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

/// The hash of `word`'s first `len` octets, `log` bits wide.
inline fn hash(comptime safety: bool, word: u64, comptime len: u4, comptime log: u5) usize {
    @setRuntimeSafety(safety);
    const kept = word << (@bitSizeOf(u64) - @as(u7, len) * @bitSizeOf(u8));
    return @intCast((kept *% constants.match_hash_multiplier) >> (@bitSizeOf(u64) - @as(u7, log)));
}

inline fn read64(comptime safety: bool, window: []const u8, position: usize) u64 {
    @setRuntimeSafety(safety);
    return std.mem.readInt(u64, window[position..][0..@sizeOf(u64)], .little);
}

inline fn read32(comptime safety: bool, window: []const u8, position: usize) u32 {
    @setRuntimeSafety(safety);
    return std.mem.readInt(u32, window[position..][0..@sizeOf(u32)], .little);
}

test {
    _ = @import("match_finder_test.zig");
}
