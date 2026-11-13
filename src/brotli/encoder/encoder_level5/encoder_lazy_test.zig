//! The tests of encoder_lazy.zig and encoder_lazy_hits.zig: how a candidate is weighed, the
//! assembly of the search and of the probe against the Zig loops, the lazy step's margin, what the
//! lazy probe measures and refuses, and the compare at the best length.

const std = @import("std");
const testing = std.testing;
const codec = @import("codec");
const constants = @import("../../constants.zig");
const dictionary = @import("../../dictionary.zig");
const encoder_commands = @import("../encoder_commands.zig");
const buckets_module = @import("encoder_buckets.zig");
const encoder_lazy = @import("encoder_lazy.zig");
const lazy_hits = @import("encoder_lazy_hits.zig");

const Buckets = buckets_module.Buckets;
const Found = encoder_lazy.Found;
const Pick = encoder_lazy.Pick;
const lazy = encoder_lazy.lazy;
const probe = encoder_lazy.probe;
const near_limit = encoder_lazy.near_limit;
const saving = encoder_lazy.saving;
const read64 = encoder_lazy.read64;
const read_len = encoder_lazy.read_len;
const min_len = encoder_lazy.min_len;
const ways = buckets_module.ways;

test "a candidate is weighed by the octets it agrees on, 4 at least" {
    var window: [weigh_window_len]u8 = @splat('-');
    const position = weigh_window_len / 2;
    // At `short_at` 3 octets agree, at `long_at` 6 do, and at `whole_at` all 8.
    @memcpy(window[position..][0..weigh_text.len], weigh_text);
    // The filler after the text differs from the filler after each copy, so a match ends there.
    window[position + weigh_text.len] = '#';
    @memcpy(window[short_at..][0..3], weigh_text[0..3]);
    @memcpy(window[long_at..][0..6], weigh_text[0..6]);
    @memcpy(window[whole_at..][0..weigh_text.len], weigh_text);
    var pick: Pick = .{ .here = read64(true, &window, position), .cost = weigh_literal_cost };
    pick.consider(true, &window, position, window.len, short_at, .bucket);
    try testing.expectEqual(0, pick.saves);
    pick.consider(true, &window, position, window.len, long_at, .bucket);
    try testing.expect(pick.saves > 0);
    try testing.expectEqual(long_at, pick.candidate);
    try testing.expectEqual(6, pick.len);
    // All 8 agree: the candidate is measured to its end.
    pick.consider(true, &window, position, window.len, whole_at, .bucket);
    const found = pick.found(position) orelse return error.TestNoMatch;
    try testing.expectEqual(position - whole_at, found.offset);
    try testing.expectEqual(weigh_text.len, found.len);
}

const weigh_window_len = 64;
const weigh_text = "abcdefghij";
const short_at = 2;
const long_at = 8;
const whole_at = 16;
/// 8 bits a literal, in eighths of a bit.
const weigh_literal_cost = 64;

test "the assembly searches a bucket's hits as the Zig loop does" {
    if (comptime !lazy_hits.assembly_takes) return error.SkipZigTest;
    try @call(.never_inline, expect_search_seeded, .{expect_search_round});
}

test "the assembly probes a bucket's hits as the Zig loop does" {
    if (comptime !lazy_hits.assembly_takes) return error.SkipZigTest;
    try @call(.never_inline, expect_search_seeded, .{expect_probe_round});
}

/// The rounds of one seeded search: a bucket filled at a position, then both loops compared.
const Round = fn (*Buckets, []u8, usize, *codec.testing.split.Generator) anyerror!void;

/// Seeded buckets and windows, at a position early in the window and at one whose matches may
/// run to the end: the assembly and the Zig loop must pick alike.
fn expect_search_seeded(comptime round_of: Round) !void {
    var buckets: Buckets = undefined;
    buckets.init();
    var window: [search_window_len]u8 = undefined;
    var generator = codec.testing.split.Generator.init(search_seed);
    for (&window) |*octet| octet.* = @truncate(generator.next());
    const positions = [_]usize{ search_young, search_window_len - search_end_room };
    for (0..search_rounds) |round| {
        const position = positions[round % positions.len];
        // Fresh octets from below the reach to past the longest copy.
        const refill = position - search_reach - search_copy_max;
        for (window[refill..@min(window.len, refill + search_refill_len)]) |*octet| octet.* = @truncate(generator.next());
        try round_of(&buckets, &window, position, &generator);
    }
}

/// Fills the position's bucket, each way empty, another check's entry, out of reach, or a
/// candidate, and may hold a best from a last distance first. Both loops must pick alike, and
/// take nothing from a bucket an earlier stream wrote last.
fn expect_search_round(buckets: *Buckets, window: []u8, position: usize, generator: *codec.testing.split.Generator) !void {
    const low = position - search_reach;
    const slot = Buckets.slot_of(true, window, position);
    for (0..ways) |way| fill_way(buckets, window, slot, position, low, way, generator);
    const stale = mark_seeded(buckets, slot, generator);
    const cost: u32 = @intCast(generator.between(search_cost_min, weigh_literal_cost));
    var pick: Pick = .{ .here = read64(true, window, position), .cost = cost };
    if (@as(u1, @truncate(generator.next())) == 0) pick.consider(true, window, position, window.len, place_seeded(window, position, low, generator), .last);
    var zig_pick = pick;
    var assembly_pick = pick;
    lazy_hits.consider(true, buckets, slot, window, position, window.len, low, &zig_pick);
    lazy_hits.consider(false, buckets, slot, window, position, window.len, low, &assembly_pick);
    try testing.expectEqual(zig_pick.found(position), assembly_pick.found(position));
    if (stale) try testing.expectEqual(pick.found(position), zig_pick.found(position));
}

/// Marks `slot`'s bucket as this stream's, its ring's next way seeded. One time in
/// `search_stale_one_in` the next stream then begins: returns whether an earlier stream wrote it.
fn mark_seeded(buckets: *Buckets, slot: buckets_module.Slot, generator: *codec.testing.split.Generator) bool {
    buckets.marks[slot.bucket] = buckets.mark_of(@intCast(generator.below(ways)));
    const stale = generator.below(search_stale_one_in) == 0;
    if (stale) buckets.start();
    return stale;
}

/// What a seeded way holds: two kinds a candidate, so most ways are candidates.
const WayKind = enum { empty, other_check, below_reach, at_position, candidate, another_candidate };

/// Fills the position's bucket as `expect_search_round` does, and holds a seeded match, as the lazy
/// step does before its probe: both loops must admit and measure alike.
fn expect_probe_round(buckets: *Buckets, window: []u8, position: usize, generator: *codec.testing.split.Generator) !void {
    const low = position - search_reach;
    const slot = Buckets.slot_of(true, window, position);
    for (0..ways) |way| fill_way(buckets, window, slot, position, low, way, generator);
    const stale = mark_seeded(buckets, slot, generator);
    const cost: u32 = @intCast(generator.between(search_cost_min, weigh_literal_cost));
    const len: usize = @intCast(generator.between(min_len, search_copy_max));
    const held: Found = .{ .position = position - 1, .len = len, .offset = lazy_other_offset, .saves = @intCast(generator.below(len * cost)) };
    var zig_found: ?Found = null;
    var assembly_found: ?Found = null;
    lazy_hits.probe(true, buckets, slot, window, position, window.len, low, cost, held, &zig_found);
    lazy_hits.probe(false, buckets, slot, window, position, window.len, low, cost, held, &assembly_found);
    try testing.expectEqual(zig_found, assembly_found);
    if (stale) try testing.expectEqual(null, zig_found);
}

/// One way of `slot`'s bucket, as a seeded kind makes it.
fn fill_way(buckets: *Buckets, window: []u8, slot: buckets_module.Slot, position: usize, low: usize, way: usize, generator: *codec.testing.split.Generator) void {
    const kind: WayKind = @enumFromInt(generator.below(@typeInfo(WayKind).@"enum".fields.len));
    buckets.entries[slot.bucket][way] = switch (kind) {
        .empty => 0,
        // A check one bit from the slot's, with a position in reach.
        .other_check => Buckets.entry_of(slot.check ^ 1, low),
        // A position below `low` lies out of reach.
        .below_reach => Buckets.entry_of(slot.check, @intCast(generator.between(1, low - 1))),
        // The position's own entry, which no search may take.
        .at_position => Buckets.entry_of(slot.check, position),
        .candidate, .another_candidate => Buckets.entry_of(slot.check, place_seeded(window, position, low, generator)),
    };
}

/// A candidate from `low` up that repeats the position's octets for a seeded length, then one
/// that differs: fewer than 4 make a collision. Near the end a copy may run to it.
fn place_seeded(window: []u8, position: usize, low: usize, generator: *codec.testing.split.Generator) usize {
    const len: usize = @intCast(@min(generator.below(search_copy_max), window.len - position));
    const at: usize = @intCast(generator.between(low, position - len - 1));
    place(window, position, .{ .at = at, .len = len });
    return at;
}

test "the search refuses a near collision of 3 octets and an entry at the position" {
    try @call(.never_inline, expect_search_refusals, .{});
}

/// A bucket that holds a collision 8 octets back, which agrees on 3 octets, and the position's own
/// entry. At 8 bits a literal and so near, the collision would save more than its literals; each
/// loop must refuse both, at a position early in the window and at one near its end.
fn expect_search_refusals() !void {
    var buckets: Buckets = undefined;
    buckets.init();
    var window: [search_window_len]u8 = undefined;
    var generator = codec.testing.split.Generator.init(search_seed);
    for (&window) |*octet| octet.* = @truncate(generator.next());
    for ([_]usize{ search_young, search_window_len - search_end_room }) |position| {
        const slot = Buckets.slot_of(true, &window, position);
        place(&window, position, .{ .at = position - refusal_distance, .len = min_len - 1 });
        const entries = [_]usize{ position - refusal_distance, position };
        buckets.entries[slot.bucket] = @splat(0);
        for (entries, 0..) |entry, way| buckets.entries[slot.bucket][way] = Buckets.entry_of(slot.check, entry);
        buckets.marks[slot.bucket] = buckets.mark_of(entries.len);
        inline for (.{ true, false }) |safety| {
            var pick: Pick = .{ .here = read64(true, &window, position), .cost = weigh_literal_cost };
            lazy_hits.consider(safety, &buckets, slot, &window, position, window.len, position - search_reach, &pick);
            try testing.expectEqual(null, pick.found(position));
        }
    }
}

/// A distance whose log2 of 3 bits lets 3 octets at 8 bits each pass a match's cost.
const refusal_distance = 8;

test "the compare at the best length is set only where its read stays inside the stream" {
    const Hits = lazy_hits.Assembly;
    var window: [guard_window_len]u8 = @splat(0);
    const position = guard_window_len / 2;
    const end = window.len;
    var search: Hits.Search = undefined;
    const cases = [_]struct { len: usize, compares: bool }{
        // A best that runs to the end: a compare there would read past it.
        .{ .len = end - position, .compares = false },
        // One octet shorter: the compare reads up to the end.
        .{ .len = end - position - 1, .compares = true },
        // Shorter than the octets one compare reads.
        .{ .len = read_len - 1, .compares = false },
    };
    for (cases) |case| {
        const saves = saving(case.len, guard_offset, false, weigh_literal_cost);
        lazy_hits.compare_at_len(true, Hits, &window, position, end, 1, case.len, saves, weigh_literal_cost, &search);
        try testing.expectEqual(case.compares, Hits.compares(&search));
    }
}

const guard_window_len = 64;
const guard_offset = 16;

/// The window, in refills: its last position lies far from the first.
const search_window_refills = 16;
const search_window_len = search_window_refills * search_refill_len;
const search_young = search_refill_len;
/// One search in this many reads a bucket an earlier stream wrote last.
const search_stale_one_in = 8;
const search_reach = 2000;
const search_refill_len = 4096;
const search_seed = 68;
const search_rounds = 2000;
const search_copy_max = 40;
/// The octets after the last position: fewer than the longest copy, so a match runs to the end.
const search_end_room = 24;
const search_cost_min = 16;

test "the lazy step keeps a match at a last distance unless the next saves a margin more" {
    try @call(.never_inline, expect_lazy_margin, .{});
}

const LazyCase = struct { offset: usize, word_len: usize, behind: i64, switches: bool };

/// A window of seeded octets with one repeat: `lazy_repeat_len` octets from `lazy_source` again
/// one past `lazy_position`, which the buckets hold. A match held at `lazy_position` saves `behind`
/// less than that repeat; the lazy step must replace it or keep it as its distance rules.
fn expect_lazy_margin() !void {
    var buckets: Buckets = undefined;
    var commands: encoder_commands.WideCommands = undefined;
    var window: [lazy_window_len]u8 = undefined;
    var generator = codec.testing.split.Generator.init(lazy_window_len);
    for (&window) |*octet| octet.* = @truncate(generator.next());
    const next_position = lazy_position + 1;
    @memcpy(window[next_position..][0..lazy_repeat_len], window[lazy_source..][0..lazy_repeat_len]);
    // The octets after the repeat differ, so the match ends there.
    window[next_position + lazy_repeat_len] = ~window[lazy_source + lazy_repeat_len];
    const next_saves = saving(lazy_repeat_len, next_position - lazy_source, false, constants.encoder_literal_cost_initial);
    const margin = constants.encoder_level5.lazy_margin;
    const last = constants.last_distances_initial[0];
    const cases = [_]LazyCase{
        // A last distance, the next within the margin: kept.
        .{ .offset = last, .word_len = 0, .behind = margin, .switches = false },
        // A last distance, the next past the margin: replaced.
        .{ .offset = last, .word_len = 0, .behind = margin + 1, .switches = true },
        // No last distance: any greater saving replaces it, and an equal one does not.
        .{ .offset = lazy_other_offset, .word_len = 0, .behind = 1, .switches = true },
        .{ .offset = lazy_other_offset, .word_len = 0, .behind = 0, .switches = false },
        // A word takes no margin, whatever its distance.
        .{ .offset = last, .word_len = constants.word_len_min, .behind = 1, .switches = true },
    };
    for (cases) |case| {
        buckets.init();
        commands.init();
        buckets.insert(true, &window, lazy_source);
        var found: Found = .{ .position = lazy_position, .len = constants.word_len_min, .offset = case.offset, .saves = next_saves - case.behind, .word_len = case.word_len };
        _ = lazy(true, &buckets, &window, &found, window.len - read_len, window.len, window.len, &commands);
        const expected: usize = if (case.switches) next_position else lazy_position;
        try testing.expectEqual(expected, found.position);
    }
}

const lazy_window_len = 512;
const lazy_position = 300;
const lazy_source = 40;
const lazy_repeat_len = 12;
/// A distance the ring of last distances does not hold at a stream's start.
const lazy_other_offset = 100;

test "a shorter candidate is near where its distance's bits pay for the octet it lacks" {
    // A held match of 10 octets 2^16 back, at 41 eighths a literal, saves 410 - 96 - 128 eighths.
    // One octet shorter saves 273 less its distance's bits: more while they stay below 87 eighths,
    // which no whole count of bits equals, so the limit rounds up to 2^11.
    const cost = 41;
    const held: Found = .{ .position = 0, .len = 10, .offset = 65536, .saves = saving(10, 65536, false, cost) };
    const near = near_limit(held, cost);
    try testing.expectEqual(2048, near);
    // One octet shorter: just inside the limit it saves more, and at the limit it does not.
    try testing.expect(saving(9, near - 1, false, cost) > held.saves);
    try testing.expect(saving(9, near, false, cost) <= held.saves);
    // A held match at a last distance takes no extra bits, so no distance is near enough.
    const last: Found = .{ .position = 0, .len = 10, .offset = 4, .saves = saving(10, 4, true, cost) };
    try testing.expectEqual(0, near_limit(last, cost));
}

test "the lazy probe measures a candidate as long as the held match, or one octet shorter and near" {
    try @call(.never_inline, expect_probe_rules, .{});
}

/// A held match of `held_len` octets that saves `held_saves`, and the length of the match the
/// probe must return. With `last`, the candidate is a last distance and no bucket holds it.
const ProbeCase = struct { held_len: usize, held_saves: i64, last: bool = false, collision: bool = false, found_len: ?usize };

/// A window of seeded octets where `lazy_repeat_len` octets from `lazy_source` come again at
/// `lazy_position`: the one candidate. The probe measures it or refuses it as its rules say.
fn expect_probe_rules() !void {
    var buckets: Buckets = undefined;
    var commands: encoder_commands.WideCommands = undefined;
    var window: [lazy_window_len]u8 = undefined;
    var generator = codec.testing.split.Generator.init(probe_seed);
    for (&window) |*octet| octet.* = @truncate(generator.next());
    @memcpy(window[lazy_position..][0..lazy_repeat_len], window[lazy_source..][0..lazy_repeat_len]);
    // The octets after the repeat differ, so the match ends there.
    window[lazy_position + lazy_repeat_len] = ~window[lazy_source + lazy_repeat_len];
    const distance = lazy_position - lazy_source;
    const cases = [_]ProbeCase{
        // As long as the held match: measured, whatever the held match saves.
        .{ .held_len = lazy_repeat_len, .held_saves = probe_saves_high, .found_len = lazy_repeat_len },
        // One octet shorter, and near enough for what the held match saves: measured.
        .{ .held_len = lazy_repeat_len + 1, .held_saves = probe_saves_low, .found_len = lazy_repeat_len },
        // One octet shorter, but not near enough: refused.
        .{ .held_len = lazy_repeat_len + 1, .held_saves = probe_saves_high, .found_len = null },
        // Two octets shorter: refused, however near.
        .{ .held_len = lazy_repeat_len + probe_two_octets, .held_saves = probe_saves_low, .found_len = null },
        // A collision, whose tail agrees and whose first octets do not: no match.
        .{ .held_len = lazy_repeat_len, .held_saves = probe_saves_high, .collision = true, .found_len = null },
        // A last distance: measured, however short against the held match.
        .{ .held_len = probe_long_len, .held_saves = probe_saves_high, .last = true, .found_len = lazy_repeat_len },
    };
    for (cases) |case| {
        buckets.init();
        commands.init();
        if (case.last) commands.last_distances[0] = distance else buckets.insert(true, &window, lazy_source);
        // The bucket keeps the candidate's entry and check; its first octet then differs, as a
        // collision's does.
        if (case.collision) window[lazy_source] = ~window[lazy_source];
        const held: Found = .{ .position = lazy_position - 1, .len = case.held_len, .offset = lazy_other_offset, .saves = case.held_saves };
        const found = probe(true, &buckets, &window, lazy_position, window.len, window.len, &commands, held);
        if (case.collision) window[lazy_source] = ~window[lazy_source];
        const len: ?usize = if (found) |match| match.len else null;
        try testing.expectEqual(case.found_len, len);
    }
    // The two savings put the candidate's distance inside and outside the near limit.
    const cost = constants.encoder_literal_cost_initial;
    var shorter: Found = .{ .position = 0, .len = lazy_repeat_len + 1, .offset = lazy_other_offset, .saves = probe_saves_low };
    try testing.expect(near_limit(shorter, cost) > distance);
    shorter.saves = probe_saves_high;
    try testing.expect(near_limit(shorter, cost) <= distance);
}

const probe_seed = 66;
/// What a held match saves, in eighths of a bit: with the first, a candidate one octet shorter
/// than 13 octets is near up to 512 octets back, and with the second up to 16.
const probe_saves_low = 600;
const probe_saves_high = 640;
const probe_two_octets = 2;
/// A held match far longer than the repeat.
const probe_long_len = 20;

test "the lazy probe searches a word after a word or a match of the fewest octets" {
    try @call(.never_inline, expect_probe_words, .{});
}

/// A window that holds a dictionary word at `lazy_position` and no other match. The probe finds
/// the word after a held word and after a held match of the fewest octets, and not after a longer
/// match.
fn expect_probe_words() !void {
    var buckets: Buckets = undefined;
    var commands: encoder_commands.WideCommands = undefined;
    var window: [lazy_window_len]u8 = @splat('#');
    const word = dictionary.word(probe_word_len, probe_word_index);
    @memcpy(window[lazy_position..][0..word.len], word);
    const helds = [_]Found{
        .{ .position = lazy_position - 1, .len = probe_word_len, .offset = lazy_other_offset, .saves = 1, .word_len = probe_word_len },
        .{ .position = lazy_position - 1, .len = min_len, .offset = lazy_other_offset, .saves = 1 },
        .{ .position = lazy_position - 1, .len = read_len, .offset = lazy_other_offset, .saves = 1 },
    };
    const searched = [_]bool{ true, true, false };
    for (helds, searched) |held, expected| {
        buckets.init();
        commands.init();
        const found = probe(true, &buckets, &window, lazy_position, window.len, window.len, &commands, held);
        try testing.expectEqual(expected, found != null);
        if (found) |match| try testing.expect(match.word_len > 0);
    }
}

const probe_word_len = 9;
const probe_word_index = 100;

test "a long candidate is measured unless one compare shows it saves no more" {
    // The cases at the compare's limits, in the order the pick weighs them. `expected` is the
    // index of the candidate that must win.
    const cases = [_]MeasureCase{
        // A farther candidate as long as the best saves no more, but a nearer and shorter one can.
        .{ .cost = measure_cost_low, .placed = &.{ .{ .at = measure_position - 3000, .len = 40 }, .{ .at = measure_position - 100, .len = 38 } }, .expected = 1 },
        // At a distance of the same bits, one octet longer saves more.
        .{ .cost = weigh_literal_cost, .placed = &.{ .{ .at = measure_position - 600, .len = 30 }, .{ .at = measure_position - 700, .len = 31 } }, .expected = 1 },
        // The best is shorter than the octets the compare reads: the long candidate is measured.
        .{ .cost = measure_cost_short, .placed = &.{ .{ .at = measure_position - 8, .len = 6 }, .{ .at = measure_position - 2000, .len = 9 } }, .expected = 1 },
        // The best runs to the end, past which the compare would read.
        .{ .cost = weigh_literal_cost, .position = measure_window_len - measure_tail_len, .placed = &.{ .{ .at = measure_window_len - measure_tail_len - 100, .len = measure_tail_len }, .{ .at = measure_window_len - measure_tail_len - 1000, .len = measure_tail_len } }, .expected = 0 },
    };
    for (cases, 0..) |case, index| try @call(.never_inline, expect_measure_case, .{ case, index });
    try @call(.never_inline, expect_measure_seeded, .{});
}

/// A candidate at `at`, which repeats the octets at the position for `len` octets.
const Placed = struct { at: usize, len: usize };
const MeasureCase = struct { cost: u32, position: usize = measure_position, placed: []const Placed, expected: usize };

/// Places one case's candidates in a window of octets seeded by `index`, and requires the pick to
/// take the expected one, as the reference does.
fn expect_measure_case(case: MeasureCase, index: usize) !void {
    var window: [measure_window_len]u8 = undefined;
    var generator = codec.testing.split.Generator.init(index);
    for (&window) |*octet| octet.* = @truncate(generator.next());
    const position = case.position;
    for (case.placed) |placed| place(&window, position, placed);
    const found = measure_all(&window, position, case.cost, case.placed) orelse return error.TestNoMatch;
    try testing.expectEqual(position - case.placed[case.expected].at, found.offset);
    try testing.expectEqual(case.placed[case.expected].len, found.len);
    try testing.expectEqual(reference_found(&window, position, case.cost, case.placed), found);
}

/// Seeded sets of candidates, each `measure_slot_len` octets apart, measured against the
/// reference, which measures every candidate to its end.
fn expect_measure_seeded() !void {
    var window: [measure_window_len]u8 = undefined;
    var generator = codec.testing.split.Generator.init(measure_seed);
    const costs = [_]u32{ measure_cost_low, measure_cost_short, weigh_literal_cost };
    for (0..measure_rounds) |_| {
        for (&window) |*octet| octet.* = @truncate(generator.next());
        var placed: [buckets_module.ways]Placed = undefined;
        const count: usize = @intCast(generator.between(measure_count_min, buckets_module.ways));
        for (placed[0..count], 0..) |*one, index| {
            const turn: usize = @intCast(generator.below(measure_position / measure_slot_len / buckets_module.ways));
            one.* = .{ .at = (turn * buckets_module.ways + index) * measure_slot_len, .len = @intCast(generator.between(min_len - 1, measure_copy_max)) };
            place(&window, measure_position, one.*);
        }
        const cost = costs[@intCast(generator.below(costs.len))];
        try testing.expectEqual(reference_found(&window, measure_position, cost, placed[0..count]), measure_all(&window, measure_position, cost, placed[0..count]));
    }
}

/// Copies the octets at `position` to `placed.at` for `placed.len` octets, then one that differs.
fn place(window: []u8, position: usize, placed: Placed) void {
    @memcpy(window[placed.at..][0..placed.len], window[position..][0..placed.len]);
    if (position + placed.len < window.len) window[placed.at + placed.len] = ~window[position + placed.len];
}

/// The pick's match from the candidates, considered in order as a bucket's.
fn measure_all(window: []const u8, position: usize, cost: u32, placed: []const Placed) ?Found {
    var pick: Pick = .{ .here = read64(true, window, position), .cost = cost };
    for (placed) |one| pick.consider(true, window, position, window.len, one.at, .bucket);
    return pick.found(position);
}

/// The pick's match with no compare before a measure: each candidate measured to its end, and kept
/// only when it saves more than the one kept before it.
fn reference_found(window: []const u8, position: usize, cost: u32, placed: []const Placed) ?Found {
    var best: ?Found = null;
    for (placed) |one| {
        const len = agreeing_len(window, position, one.at);
        if (len < min_len) continue;
        const saves = saving(len, position - one.at, false, cost);
        if (saves <= (if (best) |found| found.saves else 0)) continue;
        best = .{ .position = position, .len = len, .offset = position - one.at, .saves = saves };
    }
    return best;
}

/// The octets from `at` that equal those from `position`, up to the window's end.
fn agreeing_len(window: []const u8, position: usize, at: usize) usize {
    var len: usize = 0;
    for (0..window.len - position) |_| {
        if (window[at + len] != window[position + len]) break;
        len += 1;
    }
    return len;
}

const measure_window_len = 4096;
const measure_position = 3500;
const measure_seed = 67;
const measure_rounds = 400;
/// The fewest candidates a seeded set holds: one to be the best, one to be measured against it.
const measure_count_min = 2;
/// Candidates lie this many octets apart, so a copy and the octet that ends it fit between two.
const measure_slot_len = 72;
const measure_copy_max = 64;
/// The octets from the last case's position to the window's end.
const measure_tail_len = 40;
/// Literal costs, in eighths of a bit, where length counts less against distance.
const measure_cost_low = 16;
const measure_cost_short = 24;
