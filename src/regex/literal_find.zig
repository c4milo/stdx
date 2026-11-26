//! The search of claim R2 (decision 86): the next place of a literal, `width` octets a step.
//!
//! The library's own build takes `skip_lanes`, the width of SSE2's and NEON's registers. The
//! variant object of x86-64's AVX2 (variants.zig) builds the same search for `avx2_lanes`, and
//! `Literal.find` calls it where the caller's `platform.CpuFeatures` name AVX2. Either width keeps
//! the blocks of `literal_steps` and `literal_wide_steps` steps of `skip_lanes` octets: a block of
//! the same octets in fewer, wider steps.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const Literal = @import("literal.zig").Literal;
const lane_places = @import("lane_places.zig");

/// The octets of a narrow and of a wide block, whatever the width of a step.
const block_len = constants.literal_steps * constants.skip_lanes;
const wide_block_len = constants.literal_wide_steps * constants.skip_lanes;

/// The first offset at or after `from` where the literal stands whole in `haystack`, or null,
/// found `width` octets a step.
pub fn find(comptime width: usize, literal: *const Literal, haystack: []const u8, from: usize) ?usize {
    assert(from <= haystack.len);
    assert(literal.len >= 1);
    if (haystack.len - from < literal.len) return null;
    return search(width, literal, haystack, from, haystack.len - literal.len + 1);
}

/// `find`, for the places that start before `limit` alone. `Literal.find` searches one block this
/// way before it calls the variant object, so a text where places stand close together pays no
/// call for each. Inline: a ReleaseSafe build left it a call at each search.
pub inline fn find_before(comptime width: usize, literal: *const Literal, haystack: []const u8, from: usize, limit: usize) ?usize {
    assert(from <= haystack.len);
    assert(literal.len >= 1);
    if (haystack.len - from < literal.len) return null;
    const end = @min(haystack.len - literal.len + 1, limit);
    if (end <= from) return null;
    return search(width, literal, haystack, from, end);
}

/// The first offset at or after `from` and before `end` where `octet` stands, `width` octets a
/// step: the search of a literal of one octet that folds at no place, with no setup past a vector
/// of the octet. The last step ends at `end`, where the text holds a whole step.
pub inline fn find_octet(comptime width: usize, haystack: []const u8, from: usize, end: usize, octet: u8) ?usize {
    assert(from <= end and end <= haystack.len);
    const Step = lane_places.Places(width);
    const wanted: @Vector(width, u8) = @splat(octet);
    const all: @Vector(width, u8) = @splat(constants.octet_max);
    const none: @Vector(width, u8) = @splat(0);
    var index = from;
    // Each turn takes one step of `width` octets before `end`.
    while (end - index >= width) : (index += width) {
        const step: @Vector(width, u8) = haystack[index..][0..width].*;
        const mask = Step.of(@select(u8, step == wanted, all, none));
        if (mask != 0) return index + Step.first(mask);
    }
    if (index == end) return null;
    // Fewer than `width` octets are left. Where the text from `from` holds a step, one step that
    // ends at `end` takes them, and its places before `index` were taken already.
    if (end - from >= width) {
        const start = end - width;
        const step: @Vector(width, u8) = haystack[start..][0..width].*;
        var mask = Step.of(@select(u8, step == wanted, all, none));
        // Each set bit is one place, at most `width` of them.
        while (mask != 0) : (mask &= mask - 1) {
            const place = start + Step.first(mask);
            if (place >= index) return place;
        }
        return null;
    }
    // A text under one step: its octets one at a time.
    for (index..end) |at| {
        if (haystack[at] == octet) return at;
    }
    return null;
}

/// The first place of the literal that starts at or after `from` and before `end`, where the
/// haystack holds the literal's octets from each such place.
inline fn search(comptime width: usize, literal: *const Literal, haystack: []const u8, from: usize, end: usize) ?usize {
    // The runs of blocks, each a loop of `inline for` steps inlined here, pass Zig's default.
    @setEvalBranchQuota(constants.comptime_branch_quota);
    // A literal whose two compared places take one case each needs no OR in its loop.
    const ends_fold = literal.fold_octets[literal.first_at] | literal.fold_octets[literal.last_at] != 0;
    const wide = lanes(width, literal, ends_fold, wide_block_len / width, false, haystack, from, end);
    if (wide.found) |offset| return offset;
    const after = lanes(width, literal, ends_fold, block_len / width, false, haystack, wide.index, end);
    if (after.found) |offset| return offset;
    const step = lanes(width, literal, ends_fold, 1, false, haystack, after.index, end);
    if (step.found) |offset| return offset;
    if (step.index == end) return null;
    // Fewer than `width` places are left. Where the text holds a step's places, one step that
    // ends at `end` takes them: a text under one block took them one at a time.
    if (end >= width) return last_step(width, literal, ends_fold, haystack, step.index, end);
    const first = literal.first_at;
    const first_fold = literal.fold_octets[first];
    for (step.index..end) |index| {
        if (haystack[index + first] | first_fold == literal.octets[first] and literal.stands_at(haystack, index)) return index;
    }
    return null;
}

/// The first place of the literal from `index` to `end`, fewer than `width` places, by the step
/// of `width` places that ends at `end`. The step's places before `index` are left out: the
/// blocks passed those from `from` on, and the search does not take those before `from`.
inline fn last_step(comptime width: usize, literal: *const Literal, ends_fold: bool, haystack: []const u8, index: usize, end: usize) ?usize {
    if (ends_fold) return by_last_step(width, literal, .folding, haystack, index, end);
    if (literal.len == 1) return by_last_step(width, literal, .single, haystack, index, end);
    return by_last_step(width, literal, .plain, haystack, index, end);
}

/// `last_step` for a literal's form.
inline fn by_last_step(comptime width: usize, literal: *const Literal, comptime form: Form, haystack: []const u8, index: usize, end: usize) ?usize {
    assert(index < end and end - index < width);
    const start = end - width;
    const wanted = wanted_of(width, literal);
    const firsts = haystack[start + literal.first_at ..][0..width];
    const lasts = if (form == .single) firsts else haystack[start + literal.last_at ..][0..width];
    const Step = lane_places.Places(width);
    var mask = Step.of(both_lanes(width, form, firsts, lasts, 0, &wanted));
    // Each set bit is one place to compare, at most `width` of them.
    while (mask != 0) : (mask &= mask - 1) {
        const candidate = start + Step.first(mask);
        if (candidate >= index and literal.stands_at(haystack, candidate)) return candidate;
    }
    return null;
}

/// The octets a step's lanes are compared with, at the literal's two compared places.
inline fn wanted_of(comptime width: usize, literal: *const Literal) Wanted(width) {
    return .{
        .first = @splat(literal.octets[literal.first_at]),
        .last = @splat(literal.octets[literal.last_at]),
        .first_fold = @splat(literal.fold_octets[literal.first_at]),
        .last_fold = @splat(literal.fold_octets[literal.last_at]),
    };
}

/// What a run of blocks found: the first place of the literal, or the offset it stopped at, and
/// where it began to compare the octet at `third_at` too, if it did.
const Found = struct { found: ?usize, index: usize, third_from: ?usize = null };

/// The literal's octets at `first_at` and `last_at` that a block's lanes are compared with, and
/// what each compare ORs into the text's octets first.
fn Wanted(comptime width: usize) type {
    const Vector = @Vector(width, u8);
    return struct { first: Vector, last: Vector, first_fold: Vector, last_fold: Vector };
}

/// How a loop compares a block: the two octets as they stand, the two folded, or a literal of one
/// octet, whose first octet is its last and is compared once.
const Form = enum { plain, folding, single };

/// The run of blocks for a literal's form, with `third_at`'s octet compared at each candidate
/// where `third` holds. Inline, as it only picks a loop.
inline fn lanes(comptime width: usize, literal: *const Literal, ends_fold: bool, comptime steps: usize, comptime third: bool, haystack: []const u8, from: usize, end: usize) Found {
    if (ends_fold) return by_lanes(width, literal, .folding, steps, third, haystack, from, end);
    if (literal.len == 1) return by_lanes(width, literal, .single, steps, third, haystack, from, end);
    return by_lanes(width, literal, .plain, steps, third, haystack, from, end);
}

/// The first place of the literal that a whole block of `steps` steps holds, or the offset of
/// the first block that does not fit before `end`. A block tests all its steps before it looks
/// for a place in one, so a block with no candidate costs one branch. Inline: as a call, its
/// per-search setup costs a text whose places stand close together about 4% more instructions.
/// Without `third`, a run of a literal that has a third offset goes on with `third` after
/// `literal_third_misses` blocks whose candidates held no place.
inline fn by_lanes(comptime width: usize, literal: *const Literal, comptime form: Form, comptime steps: usize, comptime third: bool, haystack: []const u8, from: usize, end: usize) Found {
    comptime assert(block_len % width == 0 and wide_block_len % width == 0);
    const steps_len = steps * width;
    const first = literal.first_at;
    const last = literal.last_at;
    const wanted = wanted_of(width, literal);
    var misses: usize = 0;
    var index = from;
    // A block reads `steps_len` octets from `index + first` and as many from `index + last`, whose
    // last is `end + steps_len - 2 + last`, under the haystack's length. `third_at` is under the
    // literal's length too.
    while (end - index >= steps_len) : (index += steps_len) {
        const firsts = haystack[index + first ..][0..steps_len];
        const lasts = if (form == .single) firsts else haystack[index + last ..][0..steps_len];
        // Most blocks hold no candidate. One test of all the steps says so.
        if (any_candidate(width, form, steps, firsts, lasts, &wanted)) {
            // So LLVM keeps the wanted octets in registers through the loop, and writes them to
            // the stack around this path's compare, a call, alone.
            @branchHint(.unlikely);
            if (first_stands(width, literal, form, steps, third, firsts, lasts, &wanted, haystack, index)) |place| {
                return .{ .found = place, .index = index };
            }
            if (!third and missed(literal, &misses)) return with_third(width, literal, form, steps, haystack, index + steps_len, end);
        }
    }
    return .{ .found = null, .index = index };
}

/// Counts a block whose candidates held no place in `misses`, and gives true once they are
/// `literal_third_misses`. A literal with no third offset counts none: its candidates are its
/// places.
inline fn missed(literal: *const Literal, misses: *usize) bool {
    misses.* += @intFromBool(literal.third_at != literal.first_at);
    return misses.* == constants.literal_third_misses;
}

/// The run of blocks from `from` that compares the octet at `third_at` too, and says so. Out of
/// `by_lanes`'s loop: it is the one call of the run with `third`.
inline fn with_third(comptime width: usize, literal: *const Literal, comptime form: Form, comptime steps: usize, haystack: []const u8, from: usize, end: usize) Found {
    var rest = by_lanes(width, literal, form, steps, true, haystack, from, end);
    rest.third_from = from;
    return rest;
}

/// The text's octets of one step at the literal's two compared places, folded where the literal
/// folds.
inline fn step_lanes(comptime width: usize, comptime form: Form, firsts: anytype, lasts: anytype, comptime at: usize, wanted: *const Wanted(width)) Pair(width) {
    const first: @Vector(width, u8) = firsts[at..][0..width].*;
    if (form == .single) return .{ .first = first, .last = first };
    const last: @Vector(width, u8) = lasts[at..][0..width].*;
    if (form == .plain) return .{ .first = first, .last = last };
    return .{ .first = first | wanted.first_fold, .last = last | wanted.last_fold };
}

/// The text's octets of one step at the literal's `first_at` and at its `last_at`.
fn Pair(comptime width: usize) type {
    return struct { first: @Vector(width, u8), last: @Vector(width, u8) };
}

/// All ones in each lane of the step at `at` where the octet at `first_at` stands in `firsts`
/// and the octet at `last_at` at the same place in `lasts`, and zero in the others.
inline fn both_lanes(comptime width: usize, comptime form: Form, firsts: anytype, lasts: anytype, comptime at: usize, wanted: *const Wanted(width)) @Vector(width, u8) {
    const all: @Vector(width, u8) = @splat(constants.octet_max);
    const none: @Vector(width, u8) = @splat(0);
    const pair = step_lanes(width, form, firsts, lasts, at, wanted);
    const first_here = @select(u8, pair.first == wanted.first, all, none);
    if (form == .single) return first_here;
    return first_here & @select(u8, pair.last == wanted.last, all, none);
}

/// True when some place of a block holds the octet at `first_at` in `firsts` and the octet at
/// `last_at` at the same place in `lasts`.
inline fn any_candidate(comptime width: usize, comptime form: Form, comptime steps: usize, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: *const Wanted(width)) bool {
    var any: @Vector(width, u8) = @splat(0);
    inline for (0..steps) |step| any |= both_lanes(width, form, firsts, lasts, step * width, wanted);
    return lane_places.Places(width).any(any);
}

/// The first place of the block from `index` where the literal stands whole, among those where
/// its octets at `first_at` and `last_at` stand. With a bit a place, the block's places are one
/// mask, which one loop takes a bit at a time. A loop for each step's mask cost x86-64 a branch
/// for each step, which a text of many candidates mispredicts: rows whose literal stands every
/// line or so ran 6% to 12% slower, with fewer instructions (design §8 part 22n).
inline fn first_stands(comptime width: usize, literal: *const Literal, comptime form: Form, comptime steps: usize, comptime third: bool, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: *const Wanted(width), haystack: []const u8, index: usize) ?usize {
    if (comptime third) {
        // Most blocks lose every candidate at the third octet. One test of all the steps says so.
        var any: @Vector(width, u8) = @splat(0);
        inline for (0..steps) |step| any |= candidate_lanes(width, literal, form, steps, third, firsts, lasts, wanted, haystack, index, step);
        if (!lane_places.Places(width).any(any)) return null;
    }
    if (comptime lane_places.narrows(width)) return first_stands_by_step(width, literal, form, steps, third, firsts, lasts, wanted, haystack, index);
    const Step = lane_places.Places(width);
    const BlockMask = std.meta.Int(.unsigned, steps * width);
    var mask: BlockMask = 0;
    inline for (0..steps) |step| mask |= @as(BlockMask, Step.of(candidate_lanes(width, literal, form, steps, third, firsts, lasts, wanted, haystack, index, step))) << step * width;
    // Each set bit is one place to compare, at most `steps * width` of them.
    while (mask != 0) : (mask &= mask - 1) {
        const candidate = index + @ctz(mask);
        if (literal.stands_at(haystack, candidate)) return candidate;
    }
    return null;
}

/// `first_stands` where SHRN gives the places: a step's places are a word of their own, so that
/// no mask of four bits a place is wider than a word.
inline fn first_stands_by_step(comptime width: usize, literal: *const Literal, comptime form: Form, comptime steps: usize, comptime third: bool, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: *const Wanted(width), haystack: []const u8, index: usize) ?usize {
    const Step = lane_places.Places(width);
    var masks: [steps]Step.Mask = undefined;
    inline for (&masks, 0..) |*mask, step| mask.* = Step.of(candidate_lanes(width, literal, form, steps, third, firsts, lasts, wanted, haystack, index, step));
    for (masks, 0..) |step_mask, step| {
        var mask = step_mask;
        // Each set bit is one place to compare, at most `width` of them.
        while (mask != 0) : (mask &= mask - 1) {
            const candidate = index + step * width + Step.first(mask);
            if (literal.stands_at(haystack, candidate)) return candidate;
        }
    }
    return null;
}

/// `both_lanes` for the step `step` of the block at `index`, and where `third` holds, the lanes
/// where the literal's octet at `third_at` stands too. The block's octets from `index + third_at`
/// are read in the haystack, which holds them as it holds those from `index + last_at`.
inline fn candidate_lanes(comptime width: usize, literal: *const Literal, comptime form: Form, comptime steps: usize, comptime third: bool, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: *const Wanted(width), haystack: []const u8, index: usize, comptime step: usize) @Vector(width, u8) {
    const both = both_lanes(width, form, firsts, lasts, step * width, wanted);
    if (comptime !third) return both;
    const all: @Vector(width, u8) = @splat(constants.octet_max);
    const none: @Vector(width, u8) = @splat(0);
    const lane: @Vector(width, u8) = haystack[index + literal.third_at + step * width ..][0..width].*;
    const octet: @Vector(width, u8) = @splat(literal.octets[literal.third_at]);
    const fold: @Vector(width, u8) = @splat(literal.fold_octets[literal.third_at]);
    return both & @select(u8, lane | fold == octet, all, none);
}

const testing = std.testing;

/// The blocks after the misses in the test of `third_from`: one that compares a third octet and
/// holds a place that misses, then the block that holds the literal.
const test_blocks_after = 2;
const test_blocks = constants.literal_third_misses + test_blocks_after;

test "a run compares a third octet once literal_third_misses blocks held candidates but no place" {
    @setEvalBranchQuota(constants.comptime_branch_quota);
    const needle = "aeaeaeaeae";
    var literal: Literal = .{ .octets = undefined, .len = needle.len, .exact = true };
    @memcpy(literal.octets[0..needle.len], needle);
    literal.prepare();
    try testing.expectEqual(@as(u8, 1), literal.third_at);
    // Each block holds `a` and the `e` nine octets on at its start, and not the literal.
    var text: [test_blocks * wide_block_len + needle.len]u8 = @splat('x');
    for (0..test_blocks) |block| {
        text[block * wide_block_len] = needle[literal.first_at];
        text[block * wide_block_len + literal.last_at] = needle[literal.last_at];
    }
    const place = (test_blocks - 1) * wide_block_len + needle.len;
    @memcpy(text[place..][0..needle.len], needle);
    const end = text.len - needle.len + 1;
    const run = lanes(constants.skip_lanes, &literal, false, wide_block_len / constants.skip_lanes, false, &text, 0, end);
    try testing.expectEqual(@as(?usize, place), run.found);
    try testing.expectEqual(@as(?usize, constants.literal_third_misses * wide_block_len), run.third_from);
    // With one miss fewer, the run finds the literal before it would compare a third octet.
    const early = (constants.literal_third_misses - 1) * wide_block_len + needle.len;
    @memcpy(text[early..][0..needle.len], needle);
    const sooner = lanes(constants.skip_lanes, &literal, false, wide_block_len / constants.skip_lanes, false, &text, 0, end);
    try testing.expectEqual(@as(?usize, early), sooner.found);
    try testing.expectEqual(@as(?usize, null), sooner.third_from);
}

/// The texts of the test of `find_octet`: up to `octet_text_steps` steps of the widest search
/// and a part of one, so that each width takes whole steps and a last step that ends where the
/// text does.
const octet_text_steps = 3;
const octet_text_len = octet_text_steps * constants.avx2_lanes + constants.skip_lanes + 1;

/// The first place of `octet` from `from` to `end`, one octet at a time: what `find_octet` must give.
fn find_octet_plain(haystack: []const u8, from: usize, end: usize, octet: u8) ?usize {
    for (from..end) |at| {
        if (haystack[at] == octet) return at;
    }
    return null;
}

test "find_octet gives the first place of an octet from every offset to every end, at each width" {
    var generator = @import("codec").testing.split.Generator.init(0x0C7E);
    var text: [octet_text_len]u8 = undefined;
    for (0..64) |_| {
        // Few places of the octet, so that most steps hold none and some hold several.
        for (&text) |*octet| octet.* = if (generator.below(8) == 0) 'x' else 'y';
        for (0..text.len + 1) |end| {
            for (0..end + 1) |from| {
                const expected = find_octet_plain(&text, from, end, 'x');
                try testing.expectEqual(expected, find_octet(constants.skip_lanes, &text, from, end, 'x'));
                try testing.expectEqual(expected, find_octet(constants.avx2_lanes, &text, from, end, 'x'));
            }
        }
    }
}
