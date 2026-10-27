//! The match finder of the encoder's levels (decision 12): it turns one block of the window into
//! sequences and literals. Level 1 hashes each position's first `short_hash_len` octets into one
//! table. Level 3 also hashes the first 8 octets into a second, larger table, prefers a match the
//! long table finds, and tries the next position's long match before it takes a short one. Both
//! try Repeated_Offset1 before the tables, and both step faster through octets that find nothing.
//!
//! A table holds window positions, 0 for none, so a frame's first octet never starts a match. Every
//! choice reads only the window's octets from the frame's start to the block's end, so the
//! sequences are a function of the input alone (invariant 5).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const encoder_repeat = @import("encoder_repeat.zig");
const encoder_sequences = @import("encoder_sequences.zig");

/// A level's match finder.
pub const Level = struct {
    /// Log2 of the window: the history a match reaches, which the frame's Window_Descriptor names.
    window_log: u5,
    /// Log2 of the short table's entries, and the octets its hash reads.
    short_hash_log: u5,
    short_hash_len: u4,
    /// Log2 of the long table's entries, which hash 8 octets; 0 for a level with one table.
    long_hash_log: u5,
};

/// What a block's parse fills: its sequences and the literals between them.
pub const Block = struct {
    sequences: *encoder_sequences.Sequences,
    literals: []u8,
    literals_len: usize,
    repeats: *encoder_repeat.Repeats,

    /// Records a sequence of the literals from `anchor` to `position` and a match of `len` at
    /// `offset`, as RFC 8878 §3.1.1.4 executes it.
    fn add(self: *Block, window: []const u8, anchor: usize, position: usize, len: usize, offset: usize) void {
        const literals_len = position - anchor;
        self.add_literals(window[anchor..position]);
        const sequences = self.sequences;
        const index = sequences.count;
        assert(index < constants.block_sequences_max and len >= constants.match_length_baselines[0]);
        sequences.literals_lens[index] = @intCast(literals_len);
        sequences.match_lens[index] = @intCast(len);
        sequences.offset_values[index] = encoder_repeat.offset_value(self.repeats, @intCast(offset), @intCast(literals_len));
        sequences.count = index + 1;
    }

    fn add_literals(self: *Block, octets: []const u8) void {
        @memcpy(self.literals[self.literals_len..][0..octets.len], octets);
        self.literals_len += octets.len;
    }
};

/// The tables of `level`'s match finder.
pub fn Matcher(comptime level: Level) type {
    return struct {
        const Self = @This();

        short: [@as(usize, 1) << level.short_hash_log]u32,
        long: if (level.long_hash_log > 0) [@as(usize, 1) << level.long_hash_log]u32 else void,

        /// Empties the tables, so no position of an earlier frame or of uninitialized memory names a
        /// candidate (invariant 4).
        pub fn init(self: *Self) void {
            @memset(&self.short, 0);
            if (level.long_hash_log > 0) @memset(&self.long, 0);
        }

        /// Moves every position `shift` octets down, after the window slid by that much. A position
        /// that slid out becomes 0.
        pub fn slide(self: *Self, shift: u32) void {
            for (&self.short) |*entry| entry.* -|= shift;
            if (level.long_hash_log > 0) slide_entries(&self.long, shift);
        }

        /// Parses `window[start..end]`, whose history is `window[0..start]`, into `block`. A match
        /// ends at `end` at the latest, and reaches back less than the window's length.
        pub fn parse(self: *Self, window: []const u8, start: usize, end: usize, block: *Block) void {
            parse_block(level, self, window, start, end, block);
        }
    };
}

fn slide_entries(entries: []u32, shift: u32) void {
    for (entries) |*entry| entry.* -|= shift;
}

fn parse_block(comptime level: Level, self: *Matcher(level), window: []const u8, start: usize, end: usize, block: *Block) void {
    assert(start <= end and end <= window.len and end - start <= constants.block_len_max);
    var position = start;
    var anchor = start;
    // A hash reads 8 octets, so a position searches only with 8 ahead; the last few octets go out
    // as literals.
    const search_end = end -| constants.match_read_len;
    for (0..end - start) |_| {
        if (position >= search_end) break;
        const found = find(level, self, window, position, anchor, end, block.repeats[0]) orelse {
            position += 1 + ((position - anchor) >> constants.match_skip_log);
            continue;
        };
        block.add(window, anchor, found.position, found.len, found.offset);
        const match_end = found.position + found.len;
        insert(level, self, window, found.position + constants.match_insert_skip, match_end, search_end);
        position = match_end;
        anchor = match_end;
    }
    block.add_literals(window[anchor..end]);
}

/// The match at `position`, or at the octet after it for level 3's long table, extended back over
/// literals that match too: Repeated_Offset1's first, then the tables'. The tables record
/// `position` either way.
fn find(comptime level: Level, self: *Matcher(level), window: []const u8, position: usize, anchor: usize, end: usize, repeat_offset: u32) ?Found {
    const low = position -| ((@as(usize, 1) << level.window_log) - 1);
    const word = read64(window, position);
    const short_candidate = swap(&self.short[hash(word, level.short_hash_len, level.short_hash_log)], position);
    const long_candidate = if (level.long_hash_log > 0) swap(&self.long[hash(word, constants.long_hash_len, level.long_hash_log)], position) else 0;
    // Repeated_Offset1 after at least one literal, where Offset_Value 1 names it (RFC 8878
    // §3.1.1.5).
    if (position > anchor and repeat_offset <= position - low and position - repeat_offset > 0) {
        const candidate = position - repeat_offset;
        if (read32(window, candidate) == @as(u32, @truncate(word))) return extend(window, position, candidate, anchor, end);
    }
    if (level.long_hash_log > 0 and usable(long_candidate, position, low) and read64(window, long_candidate) == word) {
        return extend(window, position, long_candidate, anchor, end);
    }
    if (!usable(short_candidate, position, low) or read32(window, short_candidate) != @as(u32, @truncate(word))) return null;
    if (level.long_hash_log > 0 and position + 1 + constants.match_read_len <= end) {
        if (long_next(level, self, window, position + 1, low)) |candidate| return extend(window, position + 1, candidate, anchor, end);
    }
    return extend(window, position, short_candidate, anchor, end);
}

/// Stores `position` in `slot` and returns what it held.
inline fn swap(slot: *u32, position: usize) u32 {
    const held = slot.*;
    slot.* = @intCast(position);
    return held;
}

/// Level 3's long match at `position`, the octet after a short one, which it records in the long
/// table.
fn long_next(comptime level: Level, self: *Matcher(level), window: []const u8, position: usize, low: usize) ?u32 {
    const word = read64(window, position);
    const candidate = swap(&self.long[hash(word, constants.long_hash_len, level.long_hash_log)], position);
    if (usable(candidate, position, low) and read64(window, candidate) == word) return candidate;
    return null;
}

/// Records positions inside a match in the tables: every `constants.match_insert_step`th from
/// `first`, and the one `constants.match_insert_tail` before its end, which later matches often
/// continue from.
fn insert(comptime level: Level, self: *Matcher(level), window: []const u8, first: usize, match_end: usize, search_end: usize) void {
    const last = @min(match_end, search_end);
    var at = first;
    for (0..constants.block_len_max) |_| {
        if (at + constants.match_insert_tail > last) break;
        record(level, self, window, at);
        at += constants.match_insert_step;
    }
    if (last >= constants.match_insert_tail and last - constants.match_insert_tail >= first) record(level, self, window, last - constants.match_insert_tail);
}

fn record(comptime level: Level, self: *Matcher(level), window: []const u8, position: usize) void {
    const word = read64(window, position);
    self.short[hash(word, level.short_hash_len, level.short_hash_log)] = @intCast(position);
    if (level.long_hash_log > 0) self.long[hash(word, constants.long_hash_len, level.long_hash_log)] = @intCast(position);
}

/// Whether `candidate`, from a table, names an earlier position the window still reaches.
fn usable(candidate: u32, position: usize, low: usize) bool {
    return candidate != 0 and candidate >= low and candidate < position;
}

/// A match: where it starts, its length and its offset.
const Found = struct { position: usize, len: usize, offset: usize };

/// A match of `candidate` at `position`, extended back over the literals from `anchor` while the
/// octets before both agree, and forward to `end`. The loop's count stops it at `anchor`, and the
/// offset stays the one the window reached, as both move back together.
fn extend(window: []const u8, position_first: usize, candidate_first: usize, anchor: usize, end: usize) Found {
    var position = position_first;
    var candidate = candidate_first;
    for (0..position_first - anchor) |_| {
        if (candidate == 0) break;
        if (window[position - 1] != window[candidate - 1]) break;
        position -= 1;
        candidate -= 1;
    }
    const len = match_len(window, candidate, position, end);
    return .{ .position = position, .len = len, .offset = position - candidate };
}

/// The octets from `candidate` and from `position` that agree, up to `end`.
pub fn match_len(window: []const u8, candidate: usize, position: usize, end: usize) usize {
    assert(candidate < position and position <= end);
    const limit = end - position;
    var len: usize = 0;
    for (0..limit / @sizeOf(u64)) |_| {
        const difference = read64(window, candidate + len) ^ read64(window, position + len);
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
inline fn hash(word: u64, comptime len: u4, comptime log: u5) usize {
    const kept = word << (@bitSizeOf(u64) - @as(u7, len) * @bitSizeOf(u8));
    return @intCast((kept *% constants.match_hash_multiplier) >> (@bitSizeOf(u64) - @as(u7, log)));
}

inline fn read64(window: []const u8, position: usize) u64 {
    return std.mem.readInt(u64, window[position..][0..@sizeOf(u64)], .little);
}

inline fn read32(window: []const u8, position: usize) u32 {
    return std.mem.readInt(u32, window[position..][0..@sizeOf(u32)], .little);
}

test {
    _ = @import("encoder_match_test.zig");
}
