//! The tests of the shared match finder, through a sink of its own: its matches and literals,
//! copied back as a decoder copies them, give the block back, at a level with one table and at one
//! with two; and `start` moves to the next tag. Each codec's own sink has its tests beside it.

const std = @import("std");
const testing = std.testing;
const split = @import("split.zig");
const constants = @import("constants.zig");
const match_finder = @import("match_finder.zig");

/// Levels with small tables, so the tables fill and collide: one table, and two.
const window_log = 17;
const short_hash_log = 12;
const short_hash_len = 5;
const long_hash_log = 13;
const levels = [_]match_finder.Level{
    .{ .window_log = window_log, .short_hash_log = short_hash_log, .short_hash_len = short_hash_len, .long_hash_log = 0 },
    .{ .window_log = window_log, .short_hash_log = short_hash_log, .short_hash_len = short_hash_len, .long_hash_log = long_hash_log },
};

/// The test's window: the levels' window and a block of the same length.
const window_len = (1 << window_log) + (1 << window_log);
/// Every match takes 4 octets at least, so a window holds fewer matches than this.
const matches_max = window_len / match_len_min;
const match_len_min = 4;

/// One octet in `noise_odds` is noise; the rest are words.
const noise_odds = 10;

/// State that outlives one test's stack frame.
threadlocal var window: [window_len]u8 = undefined;
threadlocal var output: [window_len]u8 = undefined;
threadlocal var sink: Sink = undefined;

/// A sink that keeps each match's literals, length and offset, and the last offset as its repeat,
/// as brotli's last distance is.
const Sink = struct {
    literals: [window_len]u8,
    literals_len: usize,
    literal_lens: [matches_max]u32,
    lens: [matches_max]u32,
    offsets: [matches_max]u32,
    count: usize,
    last_offset: u32,

    fn reset(self: *Sink) void {
        self.literals_len = 0;
        self.count = 0;
        self.last_offset = 1;
    }

    pub fn add(self: *Sink, octets: []const u8, anchor: usize, position: usize, len: usize, offset: usize) void {
        self.add_literals(octets[anchor..position]);
        self.literal_lens[self.count] = @intCast(position - anchor);
        self.lens[self.count] = @intCast(len);
        self.offsets[self.count] = @intCast(offset);
        self.count += 1;
        self.last_offset = @intCast(offset);
    }

    pub fn add_literals(self: *Sink, octets: []const u8) void {
        @memcpy(self.literals[self.literals_len..][0..octets.len], octets);
        self.literals_len += octets.len;
    }

    pub fn repeat_offset(self: *const Sink) u32 {
        return self.last_offset;
    }

    /// Copies the matches and the literals back from `start`, as a decoder would.
    fn execute(self: *const Sink, start: usize) usize {
        var at = start;
        var literal: usize = 0;
        for (self.literal_lens[0..self.count], self.lens[0..self.count], self.offsets[0..self.count]) |literal_len, len, offset| {
            @memcpy(output[at..][0..literal_len], self.literals[literal..][0..literal_len]);
            literal += literal_len;
            at += literal_len;
            for (0..len) |_| {
                output[at] = output[at - offset];
                at += 1;
            }
        }
        const rest = self.literals_len - literal;
        @memcpy(output[at..][0..rest], self.literals[literal..][0..rest]);
        return at + rest;
    }
};

/// Fills `octets` with text-like runs: words from a small set, with seeded noise.
fn fill(generator: *split.Generator, octets: []u8) void {
    const words = [_][]const u8{ "octet ", "window ", "stream ", "the ", "of ", "match ", "brotli ", "frame " };
    var at: usize = 0;
    for (0..octets.len) |_| {
        if (at == octets.len) break;
        if (generator.below(noise_odds) == 0) {
            octets[at] = @truncate(generator.next());
            at += 1;
            continue;
        }
        const word = words[generator.below(words.len)];
        const len = @min(word.len, octets.len - at);
        @memcpy(octets[at..][0..len], word[0..len]);
        at += len;
    }
}

test "a block's matches and literals copy back into the block, at both levels" {
    inline for (levels) |level| {
        var generator = split.Generator.init(9);
        const Matcher = match_finder.Matcher(level);
        var matcher: Matcher = undefined;
        matcher.init();
        fill(&generator, &window);
        var start: usize = 0;
        var matches_total: usize = 0;
        for (0..6) |_| {
            const end = @min(start + generator.between(0, 1 << window_log), window.len);
            sink.reset();
            matcher.parse(&window, start, end, &sink);
            try testing.expectEqual(end, sink.execute(start));
            try testing.expectEqualSlices(u8, window[start..end], output[start..end]);
            for (sink.lens[0..sink.count], sink.offsets[0..sink.count]) |len, offset| {
                try testing.expect(len >= match_len_min and offset > 0 and offset < 1 << level.window_log);
            }
            matches_total += sink.count;
            start = end;
        }
        // Text repeats, so most octets go into matches.
        try testing.expect(matches_total > 0);
    }
}

test "start moves to the next tag, and clears the tables once the tags run out" {
    const level = levels[1];
    const Matcher = match_finder.Matcher(level);
    var matcher: Matcher = undefined;
    matcher.init();
    var generator = split.Generator.init(14);
    fill(&generator, &window);
    sink.reset();
    matcher.parse(&window, 0, 1 << window_log, &sink);
    try testing.expectEqual(1, matcher.tag);
    matcher.start();
    try testing.expectEqual(2, matcher.tag);
    // Every entry of the first frame lies below the second frame's base, so none names a
    // candidate there.
    var held: usize = 0;
    for (matcher.short) |entry| {
        held += @intFromBool(entry != 0);
        try testing.expect(entry < matcher.base);
    }
    for (matcher.long) |entry| try testing.expect(entry < matcher.base);
    try testing.expect(held > 0);
    // The window of 2^17 leaves 14 bits of tag: the start after the last tag clears the tables.
    matcher.tag = (1 << 14) - 1;
    matcher.start();
    try testing.expectEqual(1, matcher.tag);
    for (matcher.short) |entry| try testing.expectEqual(0, entry);
    for (matcher.long) |entry| try testing.expectEqual(0, entry);
    try testing.expect(constants.match_read_len <= @sizeOf(u64));
}
