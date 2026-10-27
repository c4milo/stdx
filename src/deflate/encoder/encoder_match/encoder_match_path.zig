//! Level 9's parse along the path of least price in bits (decision 56): a run of positions is
//! searched, each position's longer matches kept, and the symbols chosen are those whose prices
//! sum least from the run's start to its end. The prices are the bit lengths of the block's codes
//! so far, and the run is parsed twice: the second time with the prices of the first parse added.
//! A piece of encoder_match.zig, whose `advance` calls `advance_path` at a level with `path`.
//!
//! Runs start where the last one's symbols end, and a run is parsed only when the window holds
//! its positions and the lookahead after them, or the window is full, or the stream ends. So the
//! runs, and the octets, are a function of the stream's input alone, whatever its calls' split
//! (invariant 5).

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../../constants.zig");
const block_module = @import("../encoder_block.zig");
const Block = block_module.Block;
const code = @import("../encoder_code.zig");
const match = @import("encoder_match.zig");
const Matcher = match.Matcher;
const Match = match.Match;
const walk_tail = @import("encoder_match_walk_tail.zig");

/// The positions a run decides. No step crosses a run's end.
const run_len = constants.path_run_len;
const span_max = run_len;
/// A price per position of the span, and one per position a match from its last can reach.
const reach_len = span_max + constants.match_len_max + 1;

/// A symbol of the path: a literal, `len` 1 and its octet in `distance`, or a match.
pub const Step = packed struct(u32) {
    len: u16 = 0,
    distance: u16 = 0,
};

/// The bits a code gives a symbol the block has not used yet.
const unused_bits = constants.code_len_max;

pub const Path = struct {
    /// The least price of reaching each position of the run from its start, and the step that
    /// ends there.
    price: [reach_len]u32,
    step: [reach_len]Step,
    /// The steps chosen, in order, which the block takes as its rounds allow.
    queue: [span_max]Step,
    queue_len: u16,
    queue_next: u16,
    /// The first position not on its chain yet: a run's second search inserts none.
    inserted_end: usize,
    /// The latest position with each 3 octets' hash, for matches of 3 octets, and the candidate
    /// each position of the run found there in the first search, for the second.
    three_heads: [1 << constants.three_hash_bits]u16,
    three_found: [span_max]u16,
    /// The chain link each position of the run took the slot of: a position 32 KiB back, still
    /// in reach of the run's first positions, which the second search must read again.
    chain_before: [span_max]u16,
    /// The counts of the last block the prices came from, for the prices of a block with no
    /// symbols yet, and whether the stream has one.
    last_literal_length: [constants.literal_length_used]u16,
    last_distance: [constants.distance_used]u16,
    has_last: bool,

    pub fn start(self: *Path) void {
        self.queue_len = 0;
        self.queue_next = 0;
        self.inserted_end = 0;
        self.has_last = false;
        @memset(&self.three_heads, 0);
    }

    /// Moves every position with a slide of the window.
    pub fn slide(self: *Path) void {
        assert(self.inserted_end >= constants.window_len);
        self.inserted_end -= constants.window_len;
        match.slide_positions(true, &self.three_heads, constants.window_len);
    }
};

/// The bits each choice costs: a literal's code, a length's code and extra bits, and a distance
/// code's code and extra bits (RFC 1951 §3.2.5).
const Prices = struct {
    literal: [256]u32,
    length: [constants.match_len_max + 1]u32,
    distance: [constants.distance_used]u32,

    fn of(literal_length: *const [constants.literal_length_used]u16, distance: *const [constants.distance_used]u16) Prices {
        var literal_length_bits: [constants.literal_length_used]u8 = undefined;
        var distance_bits: [constants.distance_used]u8 = undefined;
        code.build_lengths(literal_length, constants.code_len_max, &literal_length_bits);
        code.build_lengths(distance, constants.code_len_max, &distance_bits);
        return from_bits(&literal_length_bits, &distance_bits);
    }

    fn from_bits(literal_length_bits: *const [constants.literal_length_used]u8, distance_bits: *const [constants.distance_used]u8) Prices {
        var prices: Prices = undefined;
        for (0..256) |octet| prices.literal[octet] = bits_or_unused(literal_length_bits[octet]);
        prices.length[0] = 0;
        prices.length[1] = 0;
        prices.length[2] = 0;
        for (constants.match_len_min..constants.match_len_max + 1) |len| {
            const index = block_module.length_code(true, len);
            prices.length[len] = bits_or_unused(literal_length_bits[constants.first_length_symbol + @as(usize, index)]) + constants.length_extra_bits[index];
        }
        for (0..constants.distance_used) |index| prices.distance[index] = bits_or_unused(distance_bits[index]) + constants.distance_extra_bits[index];
        return prices;
    }

    /// A stream's first prices: each literal by its share of the run's octets, the lengths and
    /// distances by the fixed codes' bits (RFC 1951 §3.2.6).
    fn seeded(octets: []const u8) Prices {
        var counts: [constants.literal_length_used]u16 = @splat(0);
        for (octets) |octet| counts[octet] +|= 1;
        var literal_length_bits: [constants.literal_length_used]u8 = undefined;
        code.build_lengths(&counts, constants.code_len_max, &literal_length_bits);
        for (constants.first_length_symbol..constants.literal_length_used) |symbol| literal_length_bits[symbol] = if (symbol < 280) 7 else 8;
        const distance_bits: [constants.distance_used]u8 = @splat(5);
        return from_bits(&literal_length_bits, &distance_bits);
    }

    fn match_price(self: *const Prices, len: usize, distance: usize) u32 {
        return self.length[len] + self.distance[block_module.distance_code(true, distance)];
    }
};

fn bits_or_unused(bits: u8) u32 {
    return if (bits == 0) unused_bits else bits;
}

/// The longer matches a search meets, nearest first.
const Record = struct {
    found: [constants.match_len_max]Match = undefined,
    len: usize = 0,

    pub fn add(self: *Record, found: Match) void {
        assert(self.len < self.found.len);
        self.found[self.len] = found;
        self.len += 1;
    }
};

/// The parse of the run from the matcher's position: `run_end` the first position it decides
/// none of, `span_end` the first it searches none of. Fills the queue with the steps that start
/// before `run_end`, and returns the octets they cover.
fn parse_run(comptime level: constants.Level, self: *Matcher(level), block: *const Block, run_end: usize, span_end: usize) usize {
    const path = &self.path;
    const start = self.position;
    assert(start < run_end and run_end <= span_end and span_end - start <= span_max);
    // Every position before the run is on its chain: the steps after a flush insert their own.
    path.inserted_end = @max(path.inserted_end, start);
    var prices: Prices = undefined;
    if (block.symbol_count > 0) {
        prices = Prices.of(&block.literal_length_counts, &block.distance_counts);
        path.last_literal_length = block.literal_length_counts;
        path.last_distance = block.distance_counts;
        path.has_last = true;
    } else if (path.has_last) {
        prices = Prices.of(&path.last_literal_length, &path.last_distance);
    } else prices = Prices.seeded(self.window[start..span_end]);
    search_run(level, self, &prices, span_end);
    restore(level, self, span_end);
    // The second parse, priced by the block so far and the first parse's steps.
    var literal_length = block.literal_length_counts;
    var distance = block.distance_counts;
    tally_path(path, span_end - start, &literal_length, &distance);
    prices = Prices.of(&literal_length, &distance);
    search_run(level, self, &prices, span_end);
    self.position = start;
    return queue_path(path, span_end - start, run_end - start);
}

/// Prices every position from the matcher's position to `span_end`.
fn search_run(comptime level: constants.Level, self: *Matcher(level), prices: *const Prices, span_end: usize) void {
    const path = &self.path;
    const start = self.position;
    const span = span_end - start;
    @memset(path.price[0 .. span + 1], std.math.maxInt(u32));
    path.price[0] = 0;
    for (0..span) |index| {
        const position = start + index;
        const here = path.price[index];
        const octet = self.window[position];
        relax(path, index + 1, here + prices.literal[octet], .{ .len = 1, .distance = octet });
        if (position >= path.inserted_end) {
            path.chain_before[index] = self.chain[match.slot(position)];
            insert(level, self, position);
            path.inserted_end = position + 1;
        }
        // The matches at the position: up to the span's end, so no step crosses it.
        const len_max = @min(constants.match_len_max, span_end - position);
        if (len_max < constants.match_len_min) continue;
        relax_three(level, self, prices, index, position);
        if (len_max < constants.match_len_taken_min) continue;
        var record: Record = .{};
        self.position = position;
        _ = walk_tail.best_by_tail(level, self, len_max, level.candidates_max, null, &record);
        var from: usize = constants.match_len_taken_min;
        for (record.found[0..record.len]) |found| {
            var len = from;
            while (len <= found.len) : (len += 1) relax(path, index + len, here + prices.match_price(len, found.distance), .{ .len = @intCast(len), .distance = found.distance });
            from = @as(usize, found.len) + 1;
        }
    }
    self.position = start;
}

/// A match of 3 octets at the latest position with the same first 3 octets, in
/// `three_distance_max`: the 3-octet table of decision 50, kept by the path.
fn relax_three(comptime level: constants.Level, self: *Matcher(level), prices: *const Prices, index: usize, position: usize) void {
    const path = &self.path;
    const word = std.mem.readInt(u32, self.window[position..][0..@sizeOf(u32)], .little);
    const slot = &path.three_heads[three_hash(word)];
    const candidate: usize = slot.*;
    path.three_found[index] = slot.*;
    slot.* = @intCast(position);
    if (candidate == 0 or candidate >= position or position - candidate > constants.three_distance_max) return;
    const mask = (1 << 24) - 1;
    if (std.mem.readInt(u32, self.window[candidate..][0..@sizeOf(u32)], .little) & mask != word & mask) return;
    const distance = position - candidate;
    relax(path, index + constants.match_len_min, path.price[index] + prices.match_price(constants.match_len_min, distance), .{ .len = constants.match_len_min, .distance = @intCast(distance) });
}

/// The 3-octet hash's shift: the bits of the product that only the word's first 3 octets set.
const three_shift = @bitSizeOf(u32) - @bitSizeOf(u8) - constants.three_hash_bits;

fn three_hash(word: u32) usize {
    return @as(u32, @truncate((word *% constants.hash_multiplier) >> three_shift)) & ((1 << constants.three_hash_bits) - 1);
}

/// Undoes the first search's inserts, the latest first: each chain link and each 3-octet
/// candidate holds the head its position replaced. So the second search reads the heads the
/// first read, at every position.
fn restore(comptime level: constants.Level, self: *Matcher(level), span_end: usize) void {
    const path = &self.path;
    const start = self.position;
    var position = span_end;
    while (position > start) {
        position -= 1;
        self.heads[match.hash(level, self, position)] = self.chain[match.slot(position)];
        self.chain[match.slot(position)] = path.chain_before[position - start];
        const word = std.mem.readInt(u32, self.window[position..][0..@sizeOf(u32)], .little);
        path.three_heads[three_hash(word)] = path.three_found[position - start];
    }
    path.inserted_end = start;
}

inline fn relax(path: *Path, at: usize, price: u32, step: Step) void {
    if (price < path.price[at]) {
        path.price[at] = price;
        path.step[at] = step;
    }
}

fn insert(comptime level: constants.Level, self: *Matcher(level), at: usize) void {
    const head = &self.heads[match.hash(level, self, at)];
    self.chain[match.slot(at)] = head.*;
    head.* = @intCast(at);
}

/// Adds the path's steps from `span` back to the start to the counts.
fn tally_path(path: *const Path, span: usize, literal_length: *[constants.literal_length_used]u16, distance: *[constants.distance_used]u16) void {
    var at = span;
    while (at > 0) {
        const step = path.step[at];
        if (step.len == 1) literal_length[step.distance] +|= 1 else {
            literal_length[constants.first_length_symbol + @as(usize, block_module.length_code(true, step.len))] +|= 1;
            distance[block_module.distance_code(true, step.distance)] +|= 1;
        }
        at -= step.len;
    }
}

/// Puts the path's steps that start before `run` into the queue, in order. Returns the octets
/// they cover.
fn queue_path(path: *Path, span: usize, run: usize) usize {
    var count: usize = 0;
    var at = span;
    while (at > 0) {
        path.queue[count] = path.step[at];
        count += 1;
        at -= path.step[at].len;
    }
    std.mem.reverse(Step, path.queue[0..count]);
    var kept: usize = 0;
    var covered: usize = 0;
    while (kept < count and covered < run) : (kept += 1) covered += path.queue[kept].len;
    path.queue_len = @intCast(kept);
    path.queue_next = 0;
    return covered;
}

/// Decides positions into `block` along the path, a run at a time, until the block reaches its
/// limit, the positions with the whole lookahead ahead end, or the window needs more input.
/// Returns whether the positions after them are the stream's last, for the steps.
pub fn advance_path(comptime level: constants.Level, self: *Matcher(level), block: *Block, ending: bool) void {
    const path = &self.path;
    assert(!self.waiting);
    for (0..self.filled + 1) |_| {
        // The queue first: its steps go into the block as its limit allows.
        if (path.queue_next < path.queue_len) {
            var symbols = block.appender(level.runtime_safety);
            const from = self.position;
            while (path.queue_next < path.queue_len and symbols.count < block.limit and !symbols.full()) : (path.queue_next += 1) {
                const step = path.queue[path.queue_next];
                if (step.len == 1) symbols.literal(@intCast(step.distance)) else symbols.pair(step.len, step.distance);
                self.position += step.len;
            }
            symbols.finish(self.position - from);
            if (path.queue_next < path.queue_len) return;
        }
        if (block.full() or block.at_limit()) return;
        const lookahead = match.lookahead_end(level, self) orelse return;
        const searchable = @min(lookahead, constants.encoder_window_len - constants.lookahead_min + 1);
        const start = self.position;
        if (start >= searchable) return;
        const wanted = start + run_len;
        if (searchable < wanted and !ending and self.filled < constants.encoder_window_len) return;
        const run_end = @min(wanted, searchable);
        _ = parse_run(level, self, block, run_end, run_end);
    } else unreachable;
}
