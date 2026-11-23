//! The states a lazy DFA has built, in memory of a fixed size (decision 86).
//!
//! The cache holds four things in one slice of words: the place of each state's record; a hash
//! table that finds a state by its record; the table of entries, a row for each state; and the
//! records, each a word of flags, a word of its length in octets, and the state's seeds packed in
//! octets (dfa_record.zig). The rows take the region from its start and the records from its end,
//! so a state of a long record takes room that a short one would leave to rows: read back,
//! `\p{L}{8,13}` holds records of hundreds of seeds, where most patterns hold a few.
//!
//! A cache that is full forgets every state. It gives up when it fills again too soon after that:
//! the caller's search then leaves the DFA (constants.zig, `dfa_octets_per_state_min`).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const dfa_record = @import("dfa_record.zig");

/// The factor by which a growth multiplies the slots in use.
const slots_growth = 2;

/// The octets of a word, in which the records' octets are kept.
const word_octets = @sizeOf(u32);

pub const Cache = struct {
    /// The entries, `stride` for each state from the region's start, and the records from its
    /// end, from `record_top` on.
    table: []u32,
    /// Claim R7's entries: `pair_stride` for each of the first `pair_states` states, one for each
    /// pair of classes. An entry is the pair row of the state two octets on, or a mark that the
    /// two octets take the table. A state interned later has no pair row.
    pairs: []u32,
    pair_stride: u32,
    pair_states: u32,
    /// Where each state's record starts in `table`.
    records: []u32,
    /// The states by the hash of their records: a state's number plus one, or zero.
    slots: []u32,
    /// The slots in use: a prefix of `slots` that doubles as states join, so that `init` and a
    /// clear write `dfa_slots_first` slots, not the whole table.
    slots_used: u32,
    stride: u32,
    /// The states a cache of records of `dfa_record_words` words holds; one of longer records
    /// holds fewer.
    states_max: u32,
    state_count: u32,
    /// Where the records start: the end of `table` when it holds none.
    record_top: u32,
    /// Where a record is packed before it is found or kept: the octets of `octets_per_seed_max`
    /// for each seed a record can hold, which the caller's lists give.
    scratch: []u8,
    /// The row of the state a scan starts in, for each context behind it.
    starts: [constants.context_count]u32,
    /// The times the cache forgot its states.
    clears: u32,
    /// The octets the DFA's scans took, and the count when the cache last cleared.
    scanned: u64,
    scanned_at_clear: u64,

    /// The words a cache of `states` states takes.
    pub fn memory_len(states: usize, stride: u32) usize {
        return states * (stride + constants.dfa_words_per_state + constants.dfa_record_words);
    }

    /// The words of pair rows a cache of `words_len` words gives claim R7: at most
    /// `pair_states_max` rows, in at most a quarter of the memory, and none where the rest would
    /// hold fewer than `dfa_states_min` states.
    pub fn pair_words(words_len: usize, stride: u32, pair_stride: u32) usize {
        if (pair_stride == 0) return 0;
        const rows = @min(constants.pair_states_max, words_len / constants.pair_memory_parts / pair_stride);
        const words = rows * pair_stride;
        if (words_len - words < memory_len_min_of(stride)) return 0;
        return words;
    }

    fn memory_len_min_of(stride: u32) usize {
        return memory_len(constants.dfa_states_min, stride);
    }

    /// Divides `memory` between as many states as it holds, and the pair rows `pair_words` gives.
    /// `scratch` is where a record is packed: `octets_per_seed_max` octets for each seed.
    pub fn init(cache: *Cache, memory: []u32, stride: u32, pair_stride: u32, scratch: []u8) void {
        const pairs_len = pair_words(memory.len, stride, pair_stride);
        const pair_states: u32 = if (pairs_len == 0) 0 else @intCast(pairs_len / pair_stride);
        const rest = memory[pairs_len..];
        const states = rest.len / (stride + constants.dfa_words_per_state + constants.dfa_record_words);
        assert(states >= constants.dfa_states_min);
        const states_max: usize = @min(states, constants.dfa_row_mask / stride);
        const slots_len = states_max * (constants.dfa_words_per_state - 1);
        const region = rest[states_max + slots_len ..];
        cache.* = .{
            .table = region,
            .pairs = memory[0..pairs_len],
            .pair_stride = if (pair_states == 0) 0 else pair_stride,
            .pair_states = pair_states,
            .records = rest[0..states_max],
            .slots = rest[states_max..][0..slots_len],
            .slots_used = @intCast(@min(slots_len, constants.dfa_slots_first)),
            .stride = stride,
            .states_max = @intCast(states_max),
            .state_count = 0,
            .record_top = @intCast(region.len),
            .scratch = scratch,
            .starts = @splat(constants.dfa_unknown),
            .clears = 0,
            .scanned = 0,
            .scanned_at_clear = 0,
        };
        @memset(cache.slots[0..cache.slots_used], 0);
    }

    /// The first word of a state's record: its flags.
    pub fn head(cache: *const Cache, row: u32) u32 {
        return cache.table[cache.records[row / cache.stride]];
    }

    /// The seeds of a state, in order of preference.
    pub fn seeds(cache: *const Cache, row: u32) dfa_record.Seeds {
        return .{ .octets = cache.packed_of(row / cache.stride) };
    }

    fn packed_of(cache: *const Cache, state: u32) []const u8 {
        const record = cache.records[state];
        const len = cache.table[record + 1];
        return std.mem.sliceAsBytes(cache.table[record + constants.dfa_record_head ..])[0..len];
    }

    fn hash(flags: u32, octets: []const u8) u32 {
        var value: u32 = (constants.fnv_offset_basis ^ flags) *% constants.fnv_prime;
        for (octets) |octet| value = (value ^ octet) *% constants.fnv_prime;
        return value;
    }

    fn holds(cache: *const Cache, state: u32, flags: u32, octets: []const u8) bool {
        return cache.table[cache.records[state]] == flags and std.mem.eql(u8, cache.packed_of(state), octets);
    }

    /// The slot of the hash table that holds the state, or the empty slot where it belongs.
    fn slot_of(cache: *const Cache, flags: u32, octets: []const u8) usize {
        const used = cache.slots[0..cache.slots_used];
        var slot = hash(flags, octets) % used.len;
        for (0..used.len) |_| {
            const entry = used[slot];
            if (entry == 0 or cache.holds(entry - 1, flags, octets)) return slot;
            slot = (slot + 1) % used.len;
        }
        unreachable;
    }

    /// True when one more state would fill more than half the slots in use, and the table has
    /// slots left to take. A full table holds `states_max` states, half its slots.
    fn must_grow(cache: *const Cache) bool {
        const slots_per_state = constants.dfa_words_per_state - 1;
        return cache.slots_used < cache.slots.len and (cache.state_count + 1) * slots_per_state > cache.slots_used;
    }

    /// Doubles the slots in use, or takes them all, and places each state again by its hash.
    fn grow(cache: *Cache) void {
        assert(cache.must_grow());
        cache.slots_used = @intCast(@min(cache.slots.len, @as(usize, cache.slots_used) * slots_growth));
        @memset(cache.slots[0..cache.slots_used], 0);
        // At most `states_max` states.
        for (0..cache.state_count) |state_index| {
            const state: u32 = @intCast(state_index);
            const slot = cache.slot_of(cache.table[cache.records[state]], cache.packed_of(state));
            assert(cache.slots[slot] == 0);
            cache.slots[slot] = state + 1;
        }
    }

    /// The words between the next state's row and the records.
    fn gap(cache: *const Cache) []u32 {
        const rows_end = (@as(usize, cache.state_count) + 1) * cache.stride;
        if (rows_end >= cache.record_top) return cache.table[0..0];
        return cache.table[rows_end..cache.record_top];
    }

    /// The words of a record of `octets_len` octets.
    fn record_words(octets_len: usize) usize {
        return constants.dfa_record_head + (octets_len + word_octets - 1) / word_octets;
    }

    /// True when one more state fits: a row and a record of `octets_len` octets.
    fn has_room(cache: *const Cache, octets_len: usize) bool {
        if (cache.state_count == cache.states_max) return false;
        return cache.gap().len >= record_words(octets_len);
    }

    /// The row of the state with these flags and instructions, kept now when the cache did not
    /// hold it. Null when the cache gives up, or when no cache of this size holds the state.
    pub fn intern(cache: *Cache, flags: u32, instructions: []const u32) ?u32 {
        assert(cache.scratch.len >= instructions.len * dfa_record.octets_per_seed_max);
        const octets = cache.scratch[0..dfa_record.encode(instructions, cache.scratch).?];
        var slot = cache.slot_of(flags, octets);
        if (cache.slots[slot] != 0) return (cache.slots[slot] - 1) * cache.stride;
        if (!cache.has_room(octets.len)) {
            if (!cache.clear() or !cache.has_room(octets.len)) return null;
            slot = cache.slot_of(flags, octets);
        }
        if (cache.must_grow()) {
            cache.grow();
            slot = cache.slot_of(flags, octets);
        }
        return cache.keep(slot, flags, octets);
    }

    /// Keeps a new state: its record below the others, and its row.
    fn keep(cache: *Cache, slot: usize, flags: u32, octets: []const u8) u32 {
        const words = record_words(octets.len);
        assert(cache.gap().len >= words);
        const record = cache.record_top - @as(u32, @intCast(words));
        @memcpy(std.mem.sliceAsBytes(cache.table[record + constants.dfa_record_head ..])[0..octets.len], octets);
        cache.table[record] = flags;
        cache.table[record + 1] = @intCast(octets.len);
        cache.record_top = record;
        const state = cache.state_count;
        cache.state_count += 1;
        cache.slots[slot] = state + 1;
        cache.records[state] = record;
        @memset(cache.table[state * cache.stride ..][0..cache.stride], constants.dfa_unknown);
        if (state < cache.pair_states) @memset(cache.pairs[state * cache.pair_stride ..][0..cache.pair_stride], constants.dfa_unknown);
        return state * cache.stride;
    }

    /// Forgets every state. False when the cache filled within `dfa_octets_per_state_min` octets
    /// a state since it last cleared: it is thrashing, and the DFA gives up.
    fn clear(cache: *Cache) bool {
        const octets = cache.scanned - cache.scanned_at_clear;
        const thrashing = cache.clears > 0 and octets < @as(u64, constants.dfa_octets_per_state_min) * cache.state_count;
        cache.clears += 1;
        cache.scanned_at_clear = cache.scanned;
        cache.state_count = 0;
        cache.record_top = @intCast(cache.table.len);
        cache.starts = @splat(constants.dfa_unknown);
        cache.slots_used = @intCast(@min(cache.slots.len, constants.dfa_slots_first));
        @memset(cache.slots[0..cache.slots_used], 0);
        return !thrashing;
    }
};

const testing = std.testing;
const test_stride = 6;

/// A test cache's scratch: the octets of the longest record a test interns.
threadlocal var test_scratch: [test_memory_len * word_octets * dfa_record.octets_per_seed_max]u8 = undefined;

/// A state's seeds, read into `buffer`.
fn seeds_of(cache: *const Cache, row: u32, buffer: []u32) []const u32 {
    var seeds = cache.seeds(row);
    var len: usize = 0;
    while (seeds.next()) |seed| : (len += 1) buffer[len] = seed;
    return buffer[0..len];
}
const test_states = 24;
const test_memory_len = test_states * (test_stride + constants.dfa_words_per_state + constants.dfa_record_words);

test "intern gives one row to one record, and another to a record that differs in a word" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0, &test_scratch);
    try testing.expectEqual(@as(u32, test_states), cache.states_max);
    const first = cache.intern(1, &.{ 4, 9 }).?;
    try testing.expectEqual(first, cache.intern(1, &.{ 4, 9 }).?);
    const flags = cache.intern(5, &.{ 4, 9 }).?;
    const order = cache.intern(1, &.{ 9, 4 }).?;
    const shorter = cache.intern(1, &.{4}).?;
    const empty = cache.intern(1, &.{}).?;
    const rows = [_]u32{ first, flags, order, shorter, empty };
    for (rows, 0..) |row, index| {
        try testing.expectEqual(@as(u32, @intCast(index * test_stride)), row);
    }
    try testing.expectEqual(@as(u32, 5), cache.state_count);
    try testing.expectEqual(@as(u32, 5), cache.head(flags));
    var buffer: [test_stride]u32 = undefined;
    try testing.expectEqualSlices(u32, &.{ 9, 4 }, seeds_of(&cache, order, &buffer));
    try testing.expectEqualSlices(u32, &.{}, seeds_of(&cache, empty, &buffer));
    for (cache.table[first..][0..test_stride]) |entry| try testing.expectEqual(@as(u32, constants.dfa_unknown), entry);
}

test "a full cache forgets its states and goes on, the first time" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0, &test_scratch);
    for (0..test_states) |state| try testing.expect(cache.intern(0, &.{@intCast(state)}) != null);
    try testing.expectEqual(@as(u32, 0), cache.clears);
    cache.starts[0] = 0;
    const row = cache.intern(0, &.{test_states}).?;
    try testing.expectEqual(@as(u32, 0), row);
    try testing.expectEqual(@as(u32, 1), cache.clears);
    try testing.expectEqual(@as(u32, 1), cache.state_count);
    try testing.expectEqual(@as(u32, constants.dfa_unknown), cache.starts[0]);
    // A state the cache held before the clear is a new state after it.
    try testing.expectEqual(@as(u32, test_stride), cache.intern(0, &.{0}).?);
}

fn fill(cache: *Cache, first: u32) ?u32 {
    var last: ?u32 = null;
    for (0..test_states + 1) |state| {
        last = cache.intern(first, &.{@intCast(state)}) orelse return null;
    }
    return last;
}

test "a cache that fills again within ten octets a state gives up, and one that scanned more goes on" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0, &test_scratch);
    try testing.expect(fill(&cache, 0) != null);
    try testing.expectEqual(@as(u32, 1), cache.clears);
    // The second fill scans exactly ten octets a state: not under the limit, so the cache clears.
    cache.scanned += constants.dfa_octets_per_state_min * test_states;
    try testing.expect(fill(&cache, 1) != null);
    try testing.expectEqual(@as(u32, 2), cache.clears);
    // The third scans one octet fewer, and the cache gives up.
    cache.scanned += constants.dfa_octets_per_state_min * test_states - 1;
    try testing.expectEqual(@as(?u32, null), fill(&cache, 2));
    try testing.expectEqual(@as(u32, 3), cache.clears);
    // After it gave up, the cache is empty and takes states again.
    try testing.expect(cache.intern(3, &.{1}) != null);
}

test "a record longer than the region is refused, with the cache left empty" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0, &test_scratch);
    // Seeds one apart take one octet each: the region holds its octets less one row and a head.
    const room = (cache.table.len - test_stride - constants.dfa_record_head) * word_octets;
    var long: [test_memory_len * word_octets]u32 = undefined;
    for (&long, 0..) |*seed, index| seed.* = @intCast(index);
    try testing.expectEqual(@as(?u32, null), cache.intern(0, long[0 .. room + 1]));
    try testing.expectEqual(@as(u32, 0), cache.state_count);
    try testing.expectEqual(@as(?u32, 0), cache.intern(0, long[0..room]));
    var buffer: [test_memory_len * word_octets]u32 = undefined;
    try testing.expectEqualSlices(u32, long[0..room], seeds_of(&cache, 0, &buffer));
}

test "long records take the room of rows that no state took" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0, &test_scratch);
    // Records of twice the planned words, each seed one after the last: one octet each, and two
    // for the first of a record past the first.
    var long: [2 * constants.dfa_record_words * word_octets]u32 = undefined;
    var states: u32 = 0;
    for (0..test_states) |state| {
        for (&long, 0..) |*seed, index| seed.* = @intCast(state * long.len + index);
        if (cache.intern(0, &long) == null or cache.clears > 0) break;
        states += 1;
    }
    // Records kept apart from the rows, in `dfa_record_words` words a state, held fewer.
    const record_words = constants.dfa_record_head + (long.len + 1 + word_octets - 1) / word_octets;
    const apart = test_states * constants.dfa_record_words / record_words;
    try testing.expect(states > apart);
    try testing.expect(states < test_states);
}

test "two records that differ in their flags alone are two states, where their hashes meet" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0, &test_scratch);
    const instructions = [_]u32{ 3, 8 };
    var octets: [instructions.len * dfa_record.octets_per_seed_max]u8 = undefined;
    const packed_octets = octets[0..dfa_record.encode(&instructions, &octets).?];
    const first_flags: u32 = 1;
    // The flags after `first_flags` whose record falls in the same slot of the hash table.
    var second_flags: u32 = first_flags + 1;
    const slot = Cache.hash(first_flags, packed_octets) % cache.slots_used;
    while (Cache.hash(second_flags, packed_octets) % cache.slots_used != slot) second_flags += 1;
    const first = cache.intern(first_flags, &instructions).?;
    const second = cache.intern(second_flags, &instructions).?;
    try testing.expect(first != second);
    try testing.expectEqual(first, cache.intern(first_flags, &instructions).?);
    try testing.expectEqual(second, cache.intern(second_flags, &instructions).?);
    try testing.expectEqual(second_flags, cache.head(second));
}

/// The states of the growth test's cache: enough that its table doubles twice.
const grow_states = 100;
const grow_memory_len = grow_states * (test_stride + constants.dfa_words_per_state + constants.dfa_record_words);
/// What the growth test's memory holds before `init`: no slot of it may be read as a state.
const grow_fill = 0xA5A5_A5A5;

test "the hash table grows as states join, reads no slot init did not write, and finds each state" {
    var memory: [grow_memory_len]u32 = undefined;
    @memset(&memory, grow_fill);
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0, &test_scratch);
    try testing.expectEqual(@as(u32, constants.dfa_slots_first), cache.slots_used);
    var rows: [grow_states]u32 = undefined;
    for (&rows, 0..) |*row, state| row.* = cache.intern(0, &.{@intCast(state)}).?;
    try testing.expectEqual(@as(u32, @intCast(cache.slots.len)), cache.slots_used);
    for (rows, 0..) |row, state| {
        try testing.expectEqual(@as(u32, @intCast(state * test_stride)), row);
        try testing.expectEqual(row, cache.intern(0, &.{@intCast(state)}).?);
    }
    try testing.expectEqual(@as(u32, grow_states), cache.state_count);
    // A clear goes back to the first slots.
    try testing.expect(cache.clear());
    try testing.expectEqual(@as(u32, constants.dfa_slots_first), cache.slots_used);
    try testing.expectEqual(@as(u32, 0), cache.intern(0, &.{1}).?);
}
