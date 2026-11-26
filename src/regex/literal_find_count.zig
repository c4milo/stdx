//! Claim R2's count of a literal's places (decision 86): what `Matches.count` asks of a pattern
//! that is its literal, in one pass over the text. The search of `literal_find.zig` returns at
//! each place, and a count of many places then paid a call and a search's setup for each.
//!
//! The count takes the search's blocks and steps, and its compares of the octets at `first_at`
//! and `last_at`. Each candidate at or past the end of the last place counted that holds the
//! literal whole is a place, so no place counted stands inside another.
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
    const index = count_run(width, literal, form, steps, haystack, from, end, tally);
    const after = count_run(width, literal, form, 1, haystack, index, end, tally);
    if (after == end) return;
    // Fewer than `width` places are left. Where the text holds a step's places, one step that
    // ends at `end` takes them.
    if (end >= width) return count_step(width, literal, form, haystack, end - width, tally);
    count_each(literal, haystack, after, end, tally);
}

/// Counts the places of the whole runs of `steps` steps from `index`, and gives the offset of the
/// first run that does not fit before `end`. A run tests all its steps before it looks at one, so
/// a run with no candidate costs one branch.
inline fn count_run(comptime width: usize, literal: *const Literal, comptime form: literal_find.Form, comptime steps: usize, haystack: []const u8, from: usize, end: usize, tally: *Tally) usize {
    const wanted = literal_find.wanted_of(width, literal);
    const run_len = steps * width;
    var index = from;
    // A run reads `run_len` octets from `index + first_at` and as many from `index + last_at`,
    // whose last is under the haystack's length while `index` stands `run_len` before `end`.
    while (end - index >= run_len) : (index += run_len) {
        const firsts = haystack[index + literal.first_at ..][0..run_len];
        const lasts = if (form == .single) firsts else haystack[index + literal.last_at ..][0..run_len];
        if (!literal_find.any_candidate(width, form, steps, firsts, lasts, &wanted)) continue;
        inline for (0..steps) |step| {
            const mask = lane_places.Places(width).of(literal_find.both_lanes(width, form, firsts, lasts, step * width, &wanted));
            tally_mask(width, literal, haystack, index + step * width, mask, tally);
        }
    }
    return index;
}

/// Counts the places of the step of `width` places from `start`. Its places before the offset
/// where the runs stopped were taken already: each was counted, stood inside a place counted, or
/// does not hold the literal, so `tally_mask` passes it.
inline fn count_step(comptime width: usize, literal: *const Literal, comptime form: literal_find.Form, haystack: []const u8, start: usize, tally: *Tally) void {
    const wanted = literal_find.wanted_of(width, literal);
    const firsts = haystack[start + literal.first_at ..][0..width];
    const lasts = if (form == .single) firsts else haystack[start + literal.last_at ..][0..width];
    const mask = lane_places.Places(width).of(literal_find.both_lanes(width, form, firsts, lasts, 0, &wanted));
    tally_mask(width, literal, haystack, start, mask, tally);
}

/// Counts each place of a step's mask, at `start` and on, that stands at or past the end of the
/// last place counted, where the literal stands whole.
inline fn tally_mask(comptime width: usize, literal: *const Literal, haystack: []const u8, start: usize, step_mask: lane_places.Places(width).Mask, tally: *Tally) void {
    const Step = lane_places.Places(width);
    var mask = step_mask;
    // Each set bit is one candidate, at most `width` of them.
    while (mask != 0) : (mask &= mask - 1) {
        const candidate = start + Step.first(mask);
        if (candidate < tally.at) continue;
        // A literal of one octet takes its place with the compare.
        if (literal.len > 1 and !literal.stands_at(haystack, candidate)) continue;
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
