//! The encoder's match finder: the window of input, the hash heads and chains that find earlier
//! positions with the same four octets, and the walk that turns each position into a literal or a
//! length/distance pair of the block (RFC 1951 §4 describes the method, and leaves it free).
//!
//! A level without chains is greedy: it tries the one earlier position its hash head names and
//! takes the match it finds. A level with chains tries up to `candidates_max` earlier positions,
//! and takes a match only when the next position's is no longer, its lazy step.
//!
//! Every decision reads the window alone, with `lookahead_min` octets ahead of the position or the
//! stream's flush or end, so how the caller splits its input changes nothing (invariant 5). The
//! positions with the whole lookahead ahead go through a loop of their own, where every match may
//! run to `match_len_max` and the step's state stays in locals; the general step takes the rest.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Block = @import("encoder_block.zig").Block;

/// A match: its length, 0 for none, and its distance.
const Match = struct {
    len: u16 = 0,
    distance: u16 = 0,

    /// The match's worth in the lazy step's comparison: its length less what its distance costs in
    /// octets of literals, `lazy_distance_penalty_octets`, so a farther match must be longer to win.
    fn score(self: Match) i32 {
        return @as(i32, self.len) - penalty_by_bits[@bitSizeOf(u16) - @clz(self.distance)];
    }
};

/// `lazy_distance_penalty_octets` by a distance's bit length: every distance of one bit length lies
/// between the same bounds, as each bound is a power of two. Bit length 0 is no distance.
const penalty_by_bits: [@bitSizeOf(u16) + 1]u8 = table: {
    var by_bits: [@bitSizeOf(u16) + 1]u8 = undefined;
    for (&by_bits, 0..) |*penalty, bits| {
        const distance_min: u32 = if (bits == 0) 0 else @as(u32, 1) << @intCast(bits - 1);
        var index: usize = 0;
        for (constants.lazy_distance_penalty_bounds) |bound| {
            if (distance_min >= bound) index += 1;
        }
        penalty.* = constants.lazy_distance_penalty_octets[index];
    }
    break :table by_bits;
};

/// A hash of `hash_bits` bits: every index of the heads and no other, so a head read by it needs no
/// bounds check.
fn Hash(comptime level: constants.Level) type {
    return std.meta.Int(.unsigned, level.hash_bits);
}

/// A position's slot in the chain: its low bits, which name every slot and no other.
const Slot = std.meta.Int(.unsigned, std.math.log2_int(usize, constants.window_len));

comptime {
    assert(1 << @bitSizeOf(Slot) == constants.window_len);
}

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
    slide_positions(&self.heads, half);
    if (level.chains) slide_positions(&self.chain, half);
}

/// The positions a vector op moves at once.
const slide_vector_len = 16;

/// Subtracts `half` from every position, saturating at 0, none, `slide_vector_len` positions at a
/// time.
fn slide_positions(positions: []u16, half: u16) void {
    comptime assert(constants.window_len % slide_vector_len == 0);
    assert(positions.len % slide_vector_len == 0);
    const Vector = @Vector(slide_vector_len, u16);
    const halves: Vector = @splat(half);
    for (0..positions.len / slide_vector_len) |index| {
        const chunk = positions[index * slide_vector_len ..][0..slide_vector_len];
        chunk.* = @as(Vector, chunk.*) -| halves;
    }
}

/// Decides positions into `block` while `lookahead_min` octets lie ahead, or up to `filled` when
/// `ending`, until the block is full: the positions with the whole lookahead in their loop first,
/// then the rest a step at a time. Each step adds at most one symbol and moves on a position or
/// more.
fn advance_positions(comptime level: constants.Level, self: *Matcher(level), block: *Block, ending: bool) void {
    if (level.chains) advance_lazy(level, self, block) else advance_greedy(level, self, block);
    for (0..self.filled + 1) |_| {
        if (block.full()) return;
        const ahead = self.filled - self.position;
        if (ahead == 0 or (!ending and ahead < constants.lookahead_min)) return;
        if (level.chains) step_lazy(level, self, block, ahead) else step_greedy(level, self, block, ahead);
    }
    unreachable;
}

/// The positions before `end` have `lookahead_min` octets ahead, so a match there may run to
/// `match_len_max` and every position it covers has `hash_len` octets: `end` is the first position
/// without them, or none when the window holds too little.
fn lookahead_end(comptime level: constants.Level, self: *const Matcher(level)) ?usize {
    if (self.filled < constants.lookahead_min) return null;
    return self.filled - constants.lookahead_min + 1;
}

/// The lazy levels' positions with the whole lookahead ahead, decided until the block fills or the
/// lookahead runs out; `step_lazy` takes the positions after them. The step's state, the position
/// and the waiting match, lives in locals through the loop.
fn advance_lazy(comptime level: constants.Level, self: *Matcher(level), block: *Block) void {
    comptime assert(level.chains);
    const end = lookahead_end(level, self) orelse return;
    var position = self.position;
    var previous = self.previous;
    var waiting = self.waiting;
    while (position < end and !block.full()) {
        self.position = position;
        insert(level, self, position);
        // A waiting match at least `lazy_len` long is taken without a search here.
        const skip = waiting and previous.len >= level.lazy_len;
        assert(waiting or previous.len == 0);
        const current = if (skip) Match{} else best(level, self, constants.match_len_max, previous.len);
        if (waiting and previous.len >= constants.match_len_taken_min and previous.score() >= current.score()) {
            position = take_waiting(level, self, block, position, previous);
            waiting = false;
            previous = .{};
            continue;
        }
        if (waiting) block.add_literal(self.window[position - 1]);
        previous = current;
        waiting = true;
        position += 1;
    }
    self.position = position;
    self.previous = previous;
    self.waiting = waiting;
}

/// Adds the match waiting from the position before `position`, every position it covers joining
/// the chains, as a later match may start there. Returns the first position after it.
fn take_waiting(comptime level: constants.Level, self: *Matcher(level), block: *Block, position: usize, previous: Match) usize {
    assert(previous.len >= constants.match_len_taken_min);
    const match_end = position - 1 + previous.len;
    assert(match_end + constants.hash_len <= self.filled);
    for (position + 1..match_end) |covered| insert(level, self, covered);
    block.add_pair(previous.len, previous.distance);
    return match_end;
}

/// The greedy level's positions with the whole lookahead ahead, decided until the block fills or
/// the lookahead runs out; `step_greedy` takes the positions after them.
fn advance_greedy(comptime level: constants.Level, self: *Matcher(level), block: *Block) void {
    comptime assert(!level.chains);
    const end = lookahead_end(level, self) orelse return;
    while (self.position < end and !block.full()) {
        const position = self.position;
        const word = std.mem.readInt(u32, self.window[position..][0..constants.hash_len], .little);
        const head = &self.heads[hash_of_word(level, word)];
        const candidate = head.*;
        head.* = @intCast(position);
        const found = greedy_match_word(level, self, candidate, word);
        if (found.len >= constants.match_len_taken_min) {
            block.add_pair(found.len, found.distance);
            const match_end = position + found.len;
            if (found.len <= level.covered_insert_len_max) insert_covered(level, self, match_end);
            self.position = match_end;
        } else {
            // The word's first octet is the position's.
            block.add_literal(@truncate(word));
            self.position = position + 1;
        }
    }
}

/// `greedy_match` at a position whose 4 octets `word` holds, with `match_len_max` octets ahead.
fn greedy_match_word(comptime level: constants.Level, self: *const Matcher(level), candidate: u16, word: u32) Match {
    assert(self.position + constants.match_len_max <= self.filled);
    if (candidate == 0 or @as(usize, candidate) + constants.encoder_distance_max < self.position) return .{};
    assert(candidate < self.position);
    if (tail_octets(self.window[candidate..], 0) != word) return .{};
    const len = match_len(self.window[candidate..][0..constants.match_len_max], self.window[self.position..][0..constants.match_len_max]);
    return .{ .len = @intCast(len), .distance = @intCast(self.position - candidate) };
}

/// One greedy step at a position with `ahead` octets ahead, fewer than the lookahead.
fn step_greedy(comptime level: constants.Level, self: *Matcher(level), block: *Block, ahead: usize) void {
    var found: Match = .{};
    if (ahead >= constants.hash_len) {
        const head = &self.heads[hash(level, self, self.position)];
        const candidate = head.*;
        head.* = @intCast(self.position);
        found = greedy_match(level, self, candidate, @min(ahead, constants.match_len_max));
    }
    if (found.len >= constants.match_len_taken_min) {
        block.add_pair(found.len, found.distance);
        const match_end = self.position + found.len;
        if (found.len <= level.covered_insert_len_max) insert_covered(level, self, match_end);
        self.position = match_end;
    } else {
        block.add_literal(self.window[self.position]);
        self.position += 1;
    }
}

/// Makes every position a match covers, after its first, its hash's head, so a later match may
/// start there and the head names the nearest position. Only positions with `hash_len` octets in
/// the window count. The 4 octets slide through a word: one octet loaded per position.
fn insert_covered(comptime level: constants.Level, self: *Matcher(level), end: usize) void {
    assert(self.position < end and end <= self.filled);
    const first = self.position + 1;
    const last = @min(end, self.filled - (constants.hash_len - 1));
    if (last <= first) return;
    var word = std.mem.readInt(u32, self.window[self.position..][0..constants.hash_len], .little);
    for (self.window[first + constants.hash_len - 1 .. last + constants.hash_len - 1], first..) |octet, covered| {
        word = (word >> @bitSizeOf(u8)) | (@as(u32, octet) << (@bitSizeOf(u32) - @bitSizeOf(u8)));
        self.heads[hash_of_word(level, word)] = @truncate(covered);
    }
}

/// One lazy step at a position with `ahead` octets ahead, fewer than the lookahead.
fn step_lazy(comptime level: constants.Level, self: *Matcher(level), block: *Block, ahead: usize) void {
    if (ahead >= constants.hash_len) insert(level, self, self.position);
    // A waiting match at least `lazy_len` long is taken without a search here.
    const skip = self.waiting and self.previous.len >= level.lazy_len;
    // No match waits without the lazy step's position before (`take_previous` clears it).
    assert(self.waiting or self.previous.len == 0);
    const current = if (skip) Match{} else best(level, self, @min(ahead, constants.match_len_max), self.previous.len);
    if (self.waiting and self.previous.len >= constants.match_len_taken_min and self.previous.score() >= current.score()) {
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

/// The longest match at `position` of at least `match_len_taken_min` octets, or none, among
/// `candidates_max` earlier positions with its hash, the nearest first, up to `len_max` octets; a
/// search ends early at `nice_len`. When the match waiting from the position before is
/// `previous_len` octets, `cut_len` or more, the search tries `cut_candidates_max`.
fn best(comptime level: constants.Level, self: *const Matcher(level), len_max: usize, previous_len: u16) Match {
    var found: Match = .{};
    if (self.position + constants.hash_len > self.filled) return found;
    assert(len_max >= constants.match_len_taken_min and self.position + len_max <= self.filled);
    const cut = previous_len >= level.cut_len;
    const candidates_max = if (cut) level.cut_candidates_max else level.candidates_max;
    const later = self.window[self.position..][0..len_max];
    // A match longer than `found` agrees on the 4 octets that end where `found` stops, and no
    // match under `match_len_taken_min` is taken, so while `found` is shorter the first 4 decide.
    // One compare of those 4 turns away most candidates before `match_len` compares from the
    // start, and a candidate rarely passes it by chance, so its branch stays predictable.
    var tail: u8 = 0;
    var later_tail = tail_octets(later, tail);
    var candidate = self.chain[slot(self.position)];
    for (0..candidates_max) |_| {
        // The chain names earlier positions, each farther than the one before it.
        if (candidate == 0 or @as(usize, candidate) + constants.encoder_distance_max < self.position) break;
        assert(candidate < self.position);
        const next = self.chain[slot(candidate)];
        if (tail_octets(self.window[candidate..], tail) == later_tail) {
            found = longer_match(level, self, candidate, later, found);
            if (found.len >= level.nice_len or found.len >= len_max) break;
            tail = tail_of(found);
            later_tail = tail_octets(later, tail);
        }
        candidate = next;
    }
    return found;
}

/// Where the 4 octets that decide a candidate against `found` start: the octet after `found` ends,
/// less the 4, or the match's first octets while none is found.
inline fn tail_of(found: Match) u8 {
    assert(found.len == 0 or found.len >= constants.match_len_taken_min);
    return @intCast(found.len -| (constants.match_len_taken_min - 1));
}

/// The match at `candidate` when it is longer than `found`, else `found`.
inline fn longer_match(comptime level: constants.Level, self: *const Matcher(level), candidate: u16, later: []const u8, found: Match) Match {
    const len = match_len(self.window[candidate..][0..later.len], later);
    if (len <= found.len) return found;
    return .{ .len = @intCast(len), .distance = @intCast(self.position - candidate) };
}

/// The match at `candidate`, of at least `match_len_taken_min` octets, or none: the greedy level's
/// one candidate, the head. Its first 4 octets decide before `match_len` compares.
fn greedy_match(comptime level: constants.Level, self: *const Matcher(level), candidate: u16, len_max: usize) Match {
    assert(len_max >= constants.match_len_taken_min and self.position + len_max <= self.filled);
    if (candidate == 0 or @as(usize, candidate) + constants.encoder_distance_max < self.position) return .{};
    assert(candidate < self.position);
    const later = self.window[self.position..][0..len_max];
    if (tail_octets(self.window[candidate..], 0) != tail_octets(later, 0)) return .{};
    const len = match_len(self.window[candidate..][0..len_max], later);
    return .{ .len = @intCast(len), .distance = @intCast(self.position - candidate) };
}

/// The `match_len_taken_min` octets of `run` at `at`, least significant first.
inline fn tail_octets(run: []const u8, at: usize) u32 {
    comptime assert(constants.match_len_taken_min == @sizeOf(u32));
    return std.mem.readInt(u32, run[at..][0..constants.match_len_taken_min], .little);
}

/// A position's slot in the chain.
inline fn slot(position: usize) Slot {
    return @truncate(position);
}

/// Adds `at` to its hash's chain.
inline fn insert(comptime level: constants.Level, self: *Matcher(level), at: usize) void {
    const head = &self.heads[hash(level, self, at)];
    self.chain[slot(at)] = head.*;
    head.* = @intCast(at);
}

/// The hash of the 4 octets at `at`, least significant first (decision 14, E1).
inline fn hash(comptime level: constants.Level, self: *const Matcher(level), at: usize) Hash(level) {
    return hash_of_word(level, std.mem.readInt(u32, self.window[at..][0..constants.hash_len], .little));
}

/// `hash` of 4 octets already read least significant first: the product's top `hash_bits` bits,
/// which the truncation keeps whole.
inline fn hash_of_word(comptime level: constants.Level, octets: u32) Hash(level) {
    return @truncate((octets *% constants.hash_multiplier) >> @intCast(@bitSizeOf(u32) - @as(u6, level.hash_bits)));
}

/// How many octets from the start of `earlier` equal those of `later`: 8 octets at a time, the
/// first that differs found by the trailing zeros of their XOR (decision 14, E1). Both runs are
/// walked as slices of words and then of octets, so no read checks its bounds on its own.
fn match_len(earlier: []const u8, later: []const u8) usize {
    assert(earlier.len == later.len and earlier.len <= constants.match_len_max);
    const word_len = @sizeOf(u64);
    const words_len = earlier.len - earlier.len % word_len;
    var len: usize = 0;
    for (std.mem.bytesAsSlice(u64, earlier[0..words_len]), std.mem.bytesAsSlice(u64, later[0..words_len])) |a, b| {
        // Read least significant octet first, the XOR's lowest set bit lies in the first octet that
        // differs.
        const differ = std.mem.nativeToLittle(u64, a ^ b);
        if (differ != 0) return len + @ctz(differ) / @bitSizeOf(u8);
        len += word_len;
    }
    for (earlier[words_len..], later[words_len..]) |a, b| {
        if (a != b) break;
        len += 1;
    }
    return len;
}
