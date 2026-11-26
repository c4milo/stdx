//! Claim R2's count of a literal's places (decision 86): what `Matches.count` asks of a pattern
//! that is its literal, in one pass over the text. The search of `literal_find.zig` returns at
//! each place, and a count of many places then paid a call and a search's setup for each.
//!
//! The count takes the search's blocks and steps, its compares of the octets at `first_at` and
//! `last_at`, and its compare of the octet at `third_at` after blocks that held no place. Each
//! candidate at or past the end of the last place counted that holds the literal whole is a
//! place, so no place counted stands inside another.
const std = @import("std");
const assert = std.debug.assert;
const Literal = @import("literal.zig").Literal;
const lane_places = @import("lane_places.zig");
const literal_find = @import("literal_find.zig");

/// The places a count has found, and the offset where the next one may start.
const Tally = struct { places: usize = 0, at: usize };

/// The count of the places of the literal from `from` on, none inside another, found `width`
/// octets a step. Writes the end of the last place to `last_end` where there is one.
pub fn count_places(comptime width: usize, literal: *const Literal, haystack: []const u8, from: usize, last_end: *usize) usize {
    assert(from <= haystack.len);
    assert(literal.len >= 1);
    if (haystack.len - from < literal.len) return 0;
    const end = haystack.len - literal.len + 1;
    // As `literal_find.search` picks its loop: a literal whose two compared places take one case
    // each needs no OR.
    const ends_fold = literal.fold_octets[literal.first_at] | literal.fold_octets[literal.last_at] != 0;
    var tally: Tally = .{ .at = from };
    if (ends_fold) {
        count_by(width, literal, .folding, haystack, from, end, &tally);
    } else if (literal.len == 1) {
        count_by(width, literal, .single, haystack, from, end, &tally);
    } else {
        count_by(width, literal, .plain, haystack, from, end, &tally);
    }
    if (tally.places != 0) last_end.* = tally.at;
    return tally.places;
}

/// `count_places` for a literal's form: whole blocks of `wide_block_len` octets, then whole
/// steps, then the places left after them.
inline fn count_by(comptime width: usize, literal: *const Literal, comptime form: literal_find.Form, haystack: []const u8, from: usize, end: usize, tally: *Tally) void {
    // The runs of steps, each a loop of `inline for` steps inlined here, pass Zig's default.
    @setEvalBranchQuota(@import("constants.zig").comptime_branch_quota);
    const steps = literal_find.wide_block_len / width;
    const index = count_blocks(width, literal, form, steps, haystack, from, end, tally);
    const after = count_blocks(width, literal, form, 1, haystack, index, end, tally);
    if (after == end) return;
    // Fewer than `width` places are left. Where the text holds a step's places, one step that
    // ends at `end` takes them.
    if (end >= width) return count_step(width, literal, form, haystack, end - width, tally);
    count_each(literal, haystack, after, end, tally);
}

/// Where a run of blocks stopped, and whether the run after it compares the octet at `third_at`.
const Stop = struct { index: usize, third: bool };

/// Counts the places of the whole blocks of `steps` steps from `from`, and gives the offset of
/// the first block that does not fit before `end`. As in the search of `literal_find.zig`, the
/// blocks compare the octet at `third_at` too after `literal_third_misses` blocks whose
/// candidates held no place, and stop after a block that held a place, where a search returns.
inline fn count_blocks(comptime width: usize, literal: *const Literal, comptime form: literal_find.Form, comptime steps: usize, haystack: []const u8, from: usize, end: usize, tally: *Tally) usize {
    var stop: Stop = .{ .index = from, .third = false };
    // Each turn but the last ends with a run of one block or more, so the turns are at most the
    // blocks and one.
    for (0..(end - from) / (steps * width) + 1) |_| {
        const next = if (stop.third)
            count_run(width, literal, form, steps, true, haystack, stop.index, end, tally, {})
        else
            count_run(width, literal, form, steps, false, haystack, stop.index, end, tally, {});
        if (next.third == stop.third) return next.index;
        stop = next;
    }
    unreachable;
}

/// Counts the places of the whole blocks of `steps` steps from `from`, until a block does not fit
/// before `end` or the run after it compares the octet at `third_at` where this one does not, or
/// the reverse.
inline fn count_run(comptime width: usize, literal: *const Literal, comptime form: literal_find.Form, comptime steps: usize, comptime third: bool, haystack: []const u8, from: usize, end: usize, tally: *Tally, misses: anytype) Stop {
    const wanted = literal_find.wanted_of(width, literal);
    const run_len = steps * width;
    // The offsets and the tally stay in registers through the loop, as in the search: a write
    // through `tally` could change `literal` as far as LLVM knows, and it read both offsets again
    // for each block.
    const first = literal.first_at;
    const last = literal.last_at;
    var counted = tally.*;
    defer tally.* = counted;
    var blocks_missed: usize = 0;
    var index = from;
    // A block reads `run_len` octets from `index + first_at`, `index + last_at` and
    // `index + third_at`, whose last is under the haystack's length while `index` stands
    // `run_len` before `end`.
    while (end - index >= run_len) : (index += run_len) {
        const firsts = haystack[index + first ..][0..run_len];
        const lasts = if (form == .single) firsts else haystack[index + last ..][0..run_len];
        switch (count_block(width, literal, form, steps, third, firsts, lasts, &wanted, haystack, index, &counted, misses)) {
            .none => {},
            .placed => {
                if (third) return .{ .index = index + run_len, .third = false };
                blocks_missed = 0;
            },
            .missed => if (!third and literal_find.missed(literal, &blocks_missed)) {
                return .{ .index = index + run_len, .third = true };
            },
        }
    }
    return .{ .index = index, .third = third };
}

/// What a block held: no candidate that a run compares, candidates and no place, or a place.
const Block = enum { none, missed, placed };

/// Counts the places of the block of `steps` steps at `index`, whose octets at `first_at` and
/// `last_at` are `firsts` and `lasts`. A block tests all its steps before it looks at one, so a
/// block with no candidate costs one branch. No branch hint: `@branchHint(.unlikely)`, as in the
/// search, kept the loop's registers for a block with no candidate, and spilled them around each
/// block with one, which cost a text of many places more than it saved a text of none.
inline fn count_block(comptime width: usize, literal: *const Literal, comptime form: literal_find.Form, comptime steps: usize, comptime third: bool, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: anytype, haystack: []const u8, index: usize, tally: *Tally, misses: anytype) Block {
    if (!literal_find.any_candidate(width, form, steps, firsts, lasts, wanted)) return .none;
    // Most blocks lose every candidate at the third octet, as in the search. One test of all the
    // steps says so.
    if (third and !any_third(width, literal, form, steps, firsts, lasts, wanted, haystack, index)) return .none;
    const places = tally.places;
    inline for (0..steps) |step| {
        const lanes = literal_find.candidate_lanes(width, literal, form, steps, third, firsts, lasts, wanted, haystack, index, step);
        tally_mask(width, literal, haystack, index + step * width, lane_places.Places(width).of(lanes), tally, misses);
    }
    return if (tally.places != places) .placed else .missed;
}

/// True when some place of the block at `index` holds the literal's octets at `first_at`,
/// `last_at` and `third_at`.
inline fn any_third(comptime width: usize, literal: *const Literal, comptime form: literal_find.Form, comptime steps: usize, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: anytype, haystack: []const u8, index: usize) bool {
    var any: @Vector(width, u8) = @splat(0);
    inline for (0..steps) |step| any |= literal_find.candidate_lanes(width, literal, form, steps, true, firsts, lasts, wanted, haystack, index, step);
    return lane_places.Places(width).any(any);
}

/// Counts the places of the step of `width` places from `start`. Its places before the offset
/// where the runs stopped were taken already: each was counted, stood inside a place counted, or
/// does not hold the literal, so `tally_mask` passes it.
inline fn count_step(comptime width: usize, literal: *const Literal, comptime form: literal_find.Form, haystack: []const u8, start: usize, tally: *Tally) void {
    const wanted = literal_find.wanted_of(width, literal);
    const firsts = haystack[start + literal.first_at ..][0..width];
    const lasts = if (form == .single) firsts else haystack[start + literal.last_at ..][0..width];
    const mask = lane_places.Places(width).of(literal_find.both_lanes(width, form, firsts, lasts, 0, &wanted));
    tally_mask(width, literal, haystack, start, mask, tally, {});
}

/// Counts each place of a step's mask, at `start` and on, that stands at or past the end of the
/// last place counted, where the literal stands whole. `misses` counts the others that hold no
/// place, where it is a counter.
inline fn tally_mask(comptime width: usize, literal: *const Literal, haystack: []const u8, start: usize, step_mask: lane_places.Places(width).Mask, tally: *Tally, misses: anytype) void {
    const Step = lane_places.Places(width);
    var mask = step_mask;
    // Each set bit is one candidate, at most `width` of them.
    while (mask != 0) : (mask &= mask - 1) {
        const candidate = start + Step.first(mask);
        if (candidate < tally.at) continue;
        // A literal of one octet takes its place with the compare.
        if (literal.len > 1 and !literal.stands_at(haystack, candidate)) {
            literal_find.count_miss(misses);
            continue;
        }
        tally.places += 1;
        tally.at = candidate + literal.len;
    }
}

/// Counts the places from `from` to `end` one at a time: a text under one step.
fn count_each(literal: *const Literal, haystack: []const u8, from: usize, end: usize, tally: *Tally) void {
    for (from..end) |index| {
        if (index < tally.at or !literal.stands_at(haystack, index)) continue;
        tally.places += 1;
        tally.at = index + literal.len;
    }
}

const testing = std.testing;
const constants = @import("constants.zig");

/// The octets of the test's texts, at most: whole blocks of the widest count and a part of one,
/// so that a count takes blocks, steps and its last step, or its places one at a time.
const test_blocks = 2;
const test_text_len = test_blocks * literal_find.wide_block_len + constants.avx2_lanes + constants.literal_len_max;

/// The count and the end of the last place that a loop of `find` gives from `from`.
fn count_plain(literal: *const Literal, haystack: []const u8, from: usize, last_end: *usize) usize {
    var count: usize = 0;
    var at = from;
    // Each turn counts one place, at most one for each octet.
    for (0..haystack.len + 1) |_| {
        const place = literal_find.find(constants.skip_lanes, literal, haystack, at, {}) orelse break;
        count += 1;
        at = place + literal.len;
        last_end.* = at;
    }
    return count;
}

/// Requires the count at each width to give the count and the end of a loop of `find`.
fn expect_count(literal: *const Literal, haystack: []const u8, from: usize) !void {
    var expected_end: usize = 0;
    const expected = count_plain(literal, haystack, from, &expected_end);
    inline for (.{ constants.skip_lanes, constants.avx2_lanes }) |width| {
        var last_end: usize = 0;
        try testing.expectEqual(expected, count_places(width, literal, haystack, from, &last_end));
        if (expected != 0) try testing.expectEqual(expected_end, last_end);
    }
}

test "count_places gives the count of a loop of find, none inside another, at each width" {
    var generator = @import("codec").testing.split.Generator.init(0xC0E7);
    // `aba` stands at overlapping places in `ababa`, and `a` is a literal of one octet.
    const needles = [_][]const u8{ "aba", "a", "ab", "abxab" };
    var text: [test_text_len]u8 = undefined;
    for (needles) |needle| {
        var literal: Literal = .{ .octets = undefined, .len = @intCast(needle.len), .exact = true };
        @memcpy(literal.octets[0..needle.len], needle);
        literal.prepare();
        for (0..64) |_| {
            for (&text) |*octet| octet.* = "abx"[generator.below("abx".len)];
            const len = generator.below(text.len + 1);
            try expect_count(&literal, text[0..len], generator.below(len + 1));
        }
    }
}

test "count_places counts a literal whose place folds in either case" {
    var generator = @import("codec").testing.split.Generator.init(0xF07D);
    var literal: Literal = .{ .octets = undefined, .len = 2, .exact = true, .folds = 1 };
    @memcpy(literal.octets[0..2], "ab");
    literal.prepare();
    var text: [test_text_len]u8 = undefined;
    for (0..64) |_| {
        for (&text) |*octet| octet.* = "aAbx"[generator.below("aAbx".len)];
        const len = generator.below(text.len + 1);
        try expect_count(&literal, text[0..len], generator.below(len + 1));
    }
}

/// The blocks of the tests of the switch to `third_at` after its `literal_third_misses` blocks
/// whose candidate holds no place: a block that holds the literal, then one more miss.
const switch_blocks_after = 2;
const switch_blocks = constants.literal_third_misses + switch_blocks_after;
const switch_steps = literal_find.wide_block_len / constants.skip_lanes;

/// A literal whose `third_at` is 1, and a text of `switch_blocks` blocks, each with a candidate at
/// its start that holds the octets at `first_at` and `last_at` but not the one at `third_at`.
const Switch = struct {
    const needle = "aeaeaeaeae";
    literal: Literal = .{ .octets = undefined, .len = needle.len, .exact = true },
    text: [switch_blocks * literal_find.wide_block_len + needle.len]u8 = @splat('x'),

    fn init(fixture: *Switch) !void {
        @memcpy(fixture.literal.octets[0..needle.len], needle);
        fixture.literal.prepare();
        try testing.expectEqual(@as(u8, 1), fixture.literal.third_at);
        for (0..switch_blocks) |block| {
            fixture.text[block * literal_find.wide_block_len] = needle[fixture.literal.first_at];
            fixture.text[block * literal_find.wide_block_len + fixture.literal.last_at] = needle[fixture.literal.last_at];
        }
    }

    /// Writes the literal in the block `block`, after its candidate.
    fn place_in(fixture: *Switch, block: usize) void {
        @memcpy(fixture.text[block * literal_find.wide_block_len + needle.len ..][0..needle.len], needle);
    }

    fn run(fixture: *Switch, comptime third: bool, from: usize, tally: *Tally, misses: *usize) Stop {
        const end = fixture.text.len - needle.len + 1;
        return count_run(constants.skip_lanes, &fixture.literal, .plain, switch_steps, third, &fixture.text, from, end, tally, misses);
    }
};

test "a count compares the octet at third_at after literal_third_misses blocks held no place" {
    @setEvalBranchQuota(constants.comptime_branch_quota);
    var fixture: Switch = .{};
    try fixture.init();
    fixture.place_in(constants.literal_third_misses);
    var tally: Tally = .{ .at = 0 };
    var misses: usize = 0;
    const plain = fixture.run(false, 0, &tally, &misses);
    const misses_end = constants.literal_third_misses * literal_find.wide_block_len;
    try testing.expectEqual(Stop{ .index = misses_end, .third = true }, plain);
    try testing.expectEqual(constants.literal_third_misses, misses);
    try testing.expectEqual(@as(usize, 0), tally.places);
    // The octet at `third_at` drops the block's candidate, and its place ends the compare.
    const third = fixture.run(true, plain.index, &tally, &misses);
    try testing.expectEqual(Stop{ .index = misses_end + literal_find.wide_block_len, .third = false }, third);
    try testing.expectEqual(constants.literal_third_misses, misses);
    try testing.expectEqual(@as(usize, 1), tally.places);
}

test "a block that holds a place starts the count of a count's misses again" {
    @setEvalBranchQuota(constants.comptime_branch_quota);
    var fixture: Switch = .{};
    try fixture.init();
    // The block that would be the last miss holds a place, and the misses after it are fewer.
    fixture.place_in(constants.literal_third_misses - 1);
    var tally: Tally = .{ .at = 0 };
    var misses: usize = 0;
    const plain = fixture.run(false, 0, &tally, &misses);
    try testing.expectEqual(Stop{ .index = switch_blocks * literal_find.wide_block_len, .third = false }, plain);
    try testing.expectEqual(@as(usize, 1), tally.places);
    // Each block's candidate is a miss, that of the block with the place too.
    try testing.expectEqual(switch_blocks, misses);
}
