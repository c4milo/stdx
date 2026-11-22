//! The states a lazy DFA has built, in memory of a fixed size (decision 86).
//!
//! The cache holds four things in one slice of words: the table of entries, a row for each state;
//! the place of each state's record; a hash table that finds a state by its record; and the
//! records, each a word of flags, a length and the state's instructions.
//!
//! A cache that is full forgets every state. It gives up when it fills again too soon after that:
//! the caller's search then leaves the DFA (constants.zig, `dfa_octets_per_state_min`).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");

/// The factor by which a growth multiplies the slots in use.
const slots_growth = 2;

pub const Cache = struct {
    /// The entries: `stride` for each state.
    table: []u32,
    /// Claim R7's entries: `pair_stride` for each of the first `pair_states` states, one for each
    /// pair of classes. An entry is the pair row of the state two octets on, or a mark that the
    /// two octets take the table. A state interned later has no pair row.
    pairs: []u32,
    pair_stride: u32,
    pair_states: u32,
    /// Where each state's record starts in `arena`.
    records: []u32,
    /// The states by the hash of their records: a state's number plus one, or zero.
    slots: []u32,
    /// The slots in use: a prefix of `slots` that doubles as states join, so that `init` and a
    /// clear write `dfa_slots_first` slots, not the whole table.
    slots_used: u32,
    arena: []u32,
    stride: u32,
    states_max: u32,
    state_count: u32,
    arena_len: u32,
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
    pub fn init(cache: *Cache, memory: []u32, stride: u32, pair_stride: u32) void {
        const pairs_len = pair_words(memory.len, stride, pair_stride);
        const pair_states: u32 = if (pairs_len == 0) 0 else @intCast(pairs_len / pair_stride);
        const rest = memory[pairs_len..];
        const states = rest.len / (stride + constants.dfa_words_per_state + constants.dfa_record_words);
        assert(states >= constants.dfa_states_min);
        const states_max: usize = @min(states, constants.dfa_row_mask / stride);
        const slots_len = states_max * (constants.dfa_words_per_state - 1);
        const rows = states_max * stride;
        cache.* = .{
            .table = rest[0..rows],
            .pairs = memory[0..pairs_len],
            .pair_stride = if (pair_states == 0) 0 else pair_stride,
            .pair_states = pair_states,
            .records = rest[rows..][0..states_max],
            .slots = rest[rows + states_max ..][0..slots_len],
            .slots_used = @intCast(@min(slots_len, constants.dfa_slots_first)),
            .arena = rest[rows + states_max * constants.dfa_words_per_state ..],
            .stride = stride,
            .states_max = @intCast(states_max),
            .state_count = 0,
            .arena_len = 0,
            .starts = @splat(constants.dfa_unknown),
            .clears = 0,
            .scanned = 0,
            .scanned_at_clear = 0,
        };
        @memset(cache.slots[0..cache.slots_used], 0);
    }

    /// The first word of a state's record: its flags.
    pub fn head(cache: *const Cache, row: u32) u32 {
        return cache.arena[cache.records[row / cache.stride]];
    }

    /// The instructions of a state, in order of preference.
    pub fn seeds(cache: *const Cache, row: u32) []const u32 {
        const record = cache.records[row / cache.stride];
        return cache.arena[record + constants.dfa_record_head ..][0..cache.arena[record + 1]];
    }

    fn hash(flags: u32, instructions: []const u32) u32 {
        var value: u32 = (constants.fnv_offset_basis ^ flags) *% constants.fnv_prime;
        for (instructions) |instruction| value = (value ^ instruction) *% constants.fnv_prime;
        return value;
    }

    fn holds(cache: *const Cache, state: u32, flags: u32, instructions: []const u32) bool {
        const row = state * cache.stride;
        return cache.head(row) == flags and std.mem.eql(u32, cache.seeds(row), instructions);
    }

    /// The slot of the hash table that holds the state, or the empty slot where it belongs.
    fn slot_of(cache: *const Cache, flags: u32, instructions: []const u32) usize {
        const used = cache.slots[0..cache.slots_used];
        var slot = hash(flags, instructions) % used.len;
        for (0..used.len) |_| {
            const entry = used[slot];
            if (entry == 0 or cache.holds(entry - 1, flags, instructions)) return slot;
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
        for (0..cache.state_count) |state| {
            const row: u32 = @intCast(state * cache.stride);
            const slot = cache.slot_of(cache.head(row), cache.seeds(row));
            assert(cache.slots[slot] == 0);
            cache.slots[slot] = @intCast(state + 1);
        }
    }

    fn has_room(cache: *const Cache, instructions_len: usize) bool {
        if (cache.state_count == cache.states_max) return false;
        return cache.arena.len - cache.arena_len >= constants.dfa_record_head + instructions_len;
    }

    /// The row of the state with these flags and instructions, kept now when the cache did not
    /// hold it. Null when the cache gives up, or when no cache of this size holds the state.
    pub fn intern(cache: *Cache, flags: u32, instructions: []const u32) ?u32 {
        var slot = cache.slot_of(flags, instructions);
        if (cache.slots[slot] != 0) return (cache.slots[slot] - 1) * cache.stride;
        if (!cache.has_room(instructions.len)) {
            if (!cache.clear() or !cache.has_room(instructions.len)) return null;
            slot = cache.slot_of(flags, instructions);
        }
        if (cache.must_grow()) {
            cache.grow();
            slot = cache.slot_of(flags, instructions);
        }
        const state = cache.state_count;
        cache.state_count += 1;
        cache.slots[slot] = state + 1;
        cache.records[state] = cache.arena_len;
        cache.arena[cache.arena_len] = flags;
        cache.arena[cache.arena_len + 1] = @intCast(instructions.len);
        @memcpy(cache.arena[cache.arena_len + constants.dfa_record_head ..][0..instructions.len], instructions);
        cache.arena_len += @intCast(constants.dfa_record_head + instructions.len);
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
        cache.arena_len = 0;
        cache.starts = @splat(constants.dfa_unknown);
        cache.slots_used = @intCast(@min(cache.slots.len, constants.dfa_slots_first));
        @memset(cache.slots[0..cache.slots_used], 0);
        return !thrashing;
    }
};

const testing = std.testing;
const test_stride = 6;
const test_states = 24;
const test_memory_len = test_states * (test_stride + constants.dfa_words_per_state + constants.dfa_record_words);

test "intern gives one row to one record, and another to a record that differs in a word" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0);
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
    try testing.expectEqualSlices(u32, &.{ 9, 4 }, cache.seeds(order));
    try testing.expectEqualSlices(u32, &.{}, cache.seeds(empty));
    for (cache.table[first..][0..test_stride]) |entry| try testing.expectEqual(@as(u32, constants.dfa_unknown), entry);
}

test "a full cache forgets its states and goes on, the first time" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0);
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
    cache.init(&memory, test_stride, 0);
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

test "a record longer than the whole arena is refused, with the cache left empty" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0);
    var long: [test_memory_len]u32 = undefined;
    for (&long, 0..) |*word, index| word.* = @intCast(index);
    try testing.expectEqual(@as(?u32, null), cache.intern(0, &long));
    try testing.expectEqual(@as(u32, 0), cache.state_count);
    try testing.expect(cache.intern(0, long[0 .. cache.arena.len - constants.dfa_record_head]) != null);
}

test "two records that differ in their flags alone are two states, where their hashes meet" {
    var memory: [test_memory_len]u32 = undefined;
    var cache: Cache = undefined;
    cache.init(&memory, test_stride, 0);
    const instructions = [_]u32{ 3, 8 };
    const first_flags: u32 = 1;
    // The flags after `first_flags` whose record falls in the same slot of the hash table.
    var second_flags: u32 = first_flags + 1;
    const slot = Cache.hash(first_flags, &instructions) % cache.slots_used;
    while (Cache.hash(second_flags, &instructions) % cache.slots_used != slot) second_flags += 1;
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
    cache.init(&memory, test_stride, 0);
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
