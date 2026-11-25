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

/// The first place of the literal that starts at or after `from` and before `end`, where the
/// haystack holds the literal's octets from each such place.
inline fn search(comptime width: usize, literal: *const Literal, haystack: []const u8, from: usize, end: usize) ?usize {
    // A literal whose two compared places take one case each needs no OR in its loop.
    const ends_fold = literal.fold_octets[literal.first_at] | literal.fold_octets[literal.last_at] != 0;
    const wide = lanes(width, literal, ends_fold, wide_block_len / width, haystack, from, end);
    if (wide.found) |offset| return offset;
    const after = lanes(width, literal, ends_fold, block_len / width, haystack, wide.index, end);
    if (after.found) |offset| return offset;
    const step = lanes(width, literal, ends_fold, 1, haystack, after.index, end);
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

/// What a run of blocks found: the first place of the literal, or the offset it stopped at.
const Found = struct { found: ?usize, index: usize };

/// The literal's octets at `first_at` and `last_at` that a block's lanes are compared with, and
/// what each compare ORs into the text's octets first.
fn Wanted(comptime width: usize) type {
    const Vector = @Vector(width, u8);
    return struct { first: Vector, last: Vector, first_fold: Vector, last_fold: Vector };
}

/// How a loop compares a block: the two octets as they stand, the two folded, or a literal of one
/// octet, whose first octet is its last and is compared once.
const Form = enum { plain, folding, single };

/// The run of blocks for a literal's form. Inline, as it only picks a loop.
inline fn lanes(comptime width: usize, literal: *const Literal, ends_fold: bool, comptime steps: usize, haystack: []const u8, from: usize, end: usize) Found {
    if (ends_fold) return by_lanes(width, literal, .folding, steps, haystack, from, end);
    if (literal.len == 1) return by_lanes(width, literal, .single, steps, haystack, from, end);
    return by_lanes(width, literal, .plain, steps, haystack, from, end);
}

/// The first place of the literal that a whole block of `steps` steps holds, or the offset of
/// the first block that does not fit before `end`. A block tests all its steps before it looks
/// for a place in one, so a block with no candidate costs one branch. Inline: as a call, its
/// per-search setup costs a text whose places stand close together about 4% more instructions.
inline fn by_lanes(comptime width: usize, literal: *const Literal, comptime form: Form, comptime steps: usize, haystack: []const u8, from: usize, end: usize) Found {
    comptime assert(block_len % width == 0 and wide_block_len % width == 0);
    const steps_len = steps * width;
    const first = literal.first_at;
    const last = literal.last_at;
    const wanted = wanted_of(width, literal);
    var index = from;
    // A block reads `steps_len` octets from `index + first` and as many from `index + last`, whose
    // last is `end + steps_len - 2 + last`, under the haystack's length.
    while (end - index >= steps_len) : (index += steps_len) {
        const firsts = haystack[index + first ..][0..steps_len];
        const lasts = if (form == .single) firsts else haystack[index + last ..][0..steps_len];
        // Most blocks hold no candidate. One test of all the steps says so.
        if (any_candidate(width, form, steps, firsts, lasts, &wanted)) {
            // So LLVM keeps the wanted octets in registers through the loop, and writes them to
            // the stack around this path's compare, a call, alone.
            @branchHint(.unlikely);
            if (first_stands(width, literal, form, steps, firsts, lasts, &wanted, haystack, index)) |place| {
                return .{ .found = place, .index = index };
            }
        }
    }
    return .{ .found = null, .index = index };
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
inline fn first_stands(comptime width: usize, literal: *const Literal, comptime form: Form, comptime steps: usize, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: *const Wanted(width), haystack: []const u8, index: usize) ?usize {
    if (comptime lane_places.narrows(width)) return first_stands_by_step(width, literal, form, steps, firsts, lasts, wanted, haystack, index);
    const Step = lane_places.Places(width);
    const BlockMask = std.meta.Int(.unsigned, steps * width);
    var mask: BlockMask = 0;
    inline for (0..steps) |step| mask |= @as(BlockMask, Step.of(both_lanes(width, form, firsts, lasts, step * width, wanted))) << step * width;
    // Each set bit is one place to compare, at most `steps * width` of them.
    while (mask != 0) : (mask &= mask - 1) {
        const candidate = index + @ctz(mask);
        if (literal.stands_at(haystack, candidate)) return candidate;
    }
    return null;
}

/// `first_stands` where SHRN gives the places: a step's places are a word of their own, so that
/// no mask of four bits a place is wider than a word.
inline fn first_stands_by_step(comptime width: usize, literal: *const Literal, comptime form: Form, comptime steps: usize, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: *const Wanted(width), haystack: []const u8, index: usize) ?usize {
    const Step = lane_places.Places(width);
    var masks: [steps]Step.Mask = undefined;
    inline for (&masks, 0..) |*mask, step| mask.* = Step.of(both_lanes(width, form, firsts, lasts, step * width, wanted));
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
