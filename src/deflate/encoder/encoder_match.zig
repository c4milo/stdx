//! The encoder's match finder: the window of input, the hash heads and chains that find earlier
//! positions with the same four octets, and the walk that turns each position into a literal or a
//! length/distance pair of the block (RFC 1951 §4 describes the method, and leaves it free).
//!
//! A level without chains is greedy: it tries the one earlier position its hash head names and
//! takes the match it finds. A level with chains tries up to `candidates_max` earlier positions,
//! and takes a match only when the next position's is no longer, its lazy step.
//!
//! Every decision reads the window alone, with `lookahead_min` octets ahead of the position or the
//! stream's flush or end, so how the caller splits its input changes nothing (invariant 5).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Block = @import("encoder_block.zig").Block;

/// A match: its length, 0 for none, and its distance.
const Match = struct {
    len: u16 = 0,
    distance: u16 = 0,
};

pub fn Matcher(comptime level: constants.Level) type {
    return struct {
        const Self = @This();

        window: [constants.encoder_window_len]u8,
        /// The last position with each hash, and for each position the one before it with the same
        /// hash. A position of 0 names none, so the window's first octet is never a candidate.
        heads: [1 << level.hash_bits]u16,
        chain: if (level.chains) [constants.window_len]u16 else void,
        /// The window's octets that hold input, and the next position to decide.
        filled: usize,
        position: usize,
        /// The lazy step: the match found at the position before `position`, which still waits for
        /// its symbol when `waiting` is set.
        previous: Match,
        waiting: bool,

        /// Starts a stream. The heads are cleared, so no position of an earlier stream becomes a
        /// candidate, and the output is a function of this stream's input alone (invariant 5).
        /// Decision 11 allows an encoder's `init` this clear, and no other.
        pub fn init(self: *Self) void {
            @memset(&self.heads, 0);
            self.filled = 0;
            self.position = 0;
            self.previous = .{};
            self.waiting = false;
        }

        /// Copies what fits of `input` into the window. Returns how many octets.
        pub fn fill(self: *Self, input: []const u8) usize {
            const len = @min(input.len, self.window.len - self.filled);
            @memcpy(self.window[self.filled..][0..len], input[0..len]);
            self.filled += len;
            return len;
        }

        /// Whether the window is full and too few octets lie ahead to go on, so it must slide.
        pub fn must_slide(self: *const Self) bool {
            return self.filled == self.window.len and self.position + constants.lookahead_min > self.filled;
        }

        pub fn slide(self: *Self) void {
            slide_window(level, self);
        }

        /// The first position no symbol of the block covers yet: the lazy step's waiting one, or the
        /// next.
        pub fn pending_start(self: *const Self) usize {
            return self.position - @intFromBool(self.waiting);
        }

        pub fn advance(self: *Self, block: *Block, ending: bool) void {
            advance_positions(level, self, block, ending);
        }

        /// Adds the lazy step's waiting symbol when the stream flushes or ends. Returns false, and
        /// adds nothing, when the block is full.
        pub fn settle(self: *Self, block: *Block) bool {
            assert(self.position == self.filled);
            if (!self.waiting) return true;
            if (block.full()) return false;
            take_previous(level, self, block);
            return true;
        }
    };
}

/// Moves the window's second half to its first, keeping 32 KiB of history, and moves every head
/// and link with it; one that falls out of the window names none.
fn slide_window(comptime level: constants.Level, self: *Matcher(level)) void {
    assert(self.must_slide());
    const half: u16 = constants.window_len;
    @memcpy(self.window[0..half], self.window[half..]);
    self.filled -= constants.window_len;
    self.position -= constants.window_len;
    for (&self.heads) |*head| head.* = if (head.* >= half) head.* - half else 0;
    if (level.chains) {
        for (&self.chain) |*link| link.* = if (link.* >= half) link.* - half else 0;
    }
}

/// Decides positions into `block` while `lookahead_min` octets lie ahead, or up to `filled` when
/// `ending`, until the block is full. Each pass adds at most one symbol and moves on a position or
/// more.
fn advance_positions(comptime level: constants.Level, self: *Matcher(level), block: *Block, ending: bool) void {
    for (0..self.filled + 1) |_| {
        if (block.full()) return;
        const ahead = self.filled - self.position;
        if (ahead == 0 or (!ending and ahead < constants.lookahead_min)) return;
        if (level.chains) step_lazy(level, self, block, ahead) else step_greedy(level, self, block, ahead);
    }
    unreachable;
}

fn step_greedy(comptime level: constants.Level, self: *Matcher(level), block: *Block, ahead: usize) void {
    var found: Match = .{};
    if (ahead >= constants.hash_len) {
        const head = &self.heads[hash(level, self, self.position)];
        const candidate = head.*;
        head.* = @intCast(self.position);
        found = try_candidate(level, self, candidate, @min(ahead, constants.match_len_max), found);
    }
    if (found.len >= constants.match_len_taken_min) {
        block.add_pair(found.len, found.distance);
        self.position += found.len;
    } else {
        block.add_literal(self.window[self.position]);
        self.position += 1;
    }
}

fn step_lazy(comptime level: constants.Level, self: *Matcher(level), block: *Block, ahead: usize) void {
    if (ahead >= constants.hash_len) insert(level, self, self.position);
    // A waiting match at least `lazy_len` long is taken without a search here.
    const skip = self.waiting and self.previous.len >= level.lazy_len;
    const current = if (skip) Match{} else best(level, self, @min(ahead, constants.match_len_max));
    if (self.waiting and self.previous.len >= constants.match_len_taken_min and self.previous.len >= current.len) {
        const end = self.position - 1 + self.previous.len;
        // Every position the match covers joins the chains, as a later match may start there.
        for (self.position + 1..end) |covered| {
            if (covered + constants.hash_len <= self.filled) insert(level, self, covered);
        }
        take_previous(level, self, block);
        return;
    }
    if (self.waiting) block.add_literal(self.window[self.position - 1]);
    self.previous = current;
    self.waiting = true;
    self.position += 1;
}

/// Adds the waiting position's symbol, and moves past what it covers.
fn take_previous(comptime level: constants.Level, self: *Matcher(level), block: *Block) void {
    assert(self.waiting);
    self.waiting = false;
    if (self.previous.len >= constants.match_len_taken_min) {
        block.add_pair(self.previous.len, self.previous.distance);
        self.position += self.previous.len - 1;
    } else {
        block.add_literal(self.window[self.position - 1]);
    }
    self.previous = .{};
}

/// The longest match at `position` among `candidates_max` earlier positions with its hash, the
/// nearest first, up to `len_max` octets; a search ends early at `nice_len`. When the match waiting
/// from the position before is at least `cut_len` long, the search tries `cut_candidates_max`.
fn best(comptime level: constants.Level, self: *const Matcher(level), len_max: usize) Match {
    var found: Match = .{};
    if (self.position + constants.hash_len > self.filled) return found;
    // No match waits without the lazy step's position before (`take_previous` clears it).
    assert(self.waiting or self.previous.len == 0);
    const cut = self.previous.len >= level.cut_len;
    const candidates_max = if (cut) level.cut_candidates_max else level.candidates_max;
    var candidate = self.chain[self.position % constants.window_len];
    for (0..candidates_max) |_| {
        if (candidate == 0 or self.position - candidate > constants.encoder_distance_max) break;
        found = try_candidate(level, self, candidate, len_max, found);
        if (found.len >= level.nice_len) break;
        candidate = self.chain[candidate % constants.window_len];
    }
    return found;
}

/// `found`, or the match at `candidate` when it is longer and near enough.
fn try_candidate(comptime level: constants.Level, self: *const Matcher(level), candidate: u16, len_max: usize, found: Match) Match {
    if (candidate == 0 or candidate >= self.position) return found;
    const distance = self.position - candidate;
    if (distance > constants.encoder_distance_max) return found;
    // A match longer than `found` agrees on the 4 octets that end where `found` stops, and no
    // match under `match_len_taken_min` is taken, so while `found` is shorter the first 4 decide.
    // One compare of those 4 turns away most candidates before `match_len` compares from the
    // start, and a candidate rarely passes it by chance, so its branch stays predictable.
    const window = self.window[0..self.filled];
    if (found.len >= len_max) return found;
    const tail = @max(found.len + 1, constants.match_len_taken_min) - constants.match_len_taken_min;
    if (tail_octets(window, candidate + tail) != tail_octets(window, self.position + tail)) return found;
    const len = match_len(window, candidate, self.position, len_max);
    if (len <= found.len) return found;
    return .{ .len = @intCast(len), .distance = @intCast(distance) };
}

/// The `match_len_taken_min` octets at `at`, least significant first.
fn tail_octets(window: []const u8, at: usize) u32 {
    comptime assert(constants.match_len_taken_min == @sizeOf(u32));
    return std.mem.readInt(u32, window[at..][0..constants.match_len_taken_min], .little);
}

/// Adds `at` to its hash's chain.
fn insert(comptime level: constants.Level, self: *Matcher(level), at: usize) void {
    const head = &self.heads[hash(level, self, at)];
    self.chain[at % constants.window_len] = head.*;
    head.* = @intCast(at);
}

/// The hash of the 4 octets at `at`, least significant first (decision 14, E1).
fn hash(comptime level: constants.Level, self: *const Matcher(level), at: usize) usize {
    const octets = std.mem.readInt(u32, self.window[at..][0..constants.hash_len], .little);
    return (octets *% constants.hash_multiplier) >> @intCast(@bitSizeOf(u32) - @as(u6, level.hash_bits));
}

/// How many octets from `earlier` equal those from `later`, up to `len_max`: 8 octets at a time,
/// the first that differs found by the trailing zeros of their XOR (decision 14, E1).
fn match_len(window: []const u8, earlier: usize, later: usize, len_max: usize) usize {
    assert(earlier < later and later + len_max <= window.len);
    const word_len = @sizeOf(u64);
    var len: usize = 0;
    for (0..len_max / word_len) |_| {
        const a = std.mem.readInt(u64, window[earlier + len ..][0..word_len], .little);
        const b = std.mem.readInt(u64, window[later + len ..][0..word_len], .little);
        const differ = a ^ b;
        if (differ != 0) return len + @ctz(differ) / @bitSizeOf(u8);
        len += word_len;
    }
    for (0..len_max - len) |_| {
        if (window[earlier + len] != window[later + len]) break;
        len += 1;
    }
    return len;
}
