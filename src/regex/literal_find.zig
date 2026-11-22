//! The search of claim R2 (decision 86): the next place of a literal, `width` octets a step.
//!
//! The library's own build takes `skip_lanes`, the width of SSE2's and NEON's registers. The
//! variant object of x86-64's AVX2 (variants.zig) builds the same search for `avx2_lanes`, and
//! `Literal.find` calls it where the caller's `codec.Features` name AVX2. Either width keeps the
//! blocks of `literal_steps` and `literal_wide_steps` steps of `skip_lanes` octets: a block of
//! the same octets in fewer, wider steps.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const Literal = @import("literal.zig").Literal;

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
/// call for each.
pub fn find_before(comptime width: usize, literal: *const Literal, haystack: []const u8, from: usize, limit: usize) ?usize {
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
    // A literal whose first and last places take one case each needs no OR in its loop.
    const ends_fold = literal.fold_at(0) | literal.fold_at(literal.len - 1) != 0;
    const wide = lanes(width, literal, ends_fold, wide_block_len / width, haystack, from, end);
    if (wide.found) |offset| return offset;
    const after = lanes(width, literal, ends_fold, block_len / width, haystack, wide.index, end);
    if (after.found) |offset| return offset;
    const first_fold = literal.fold_at(0);
    for (after.index..end) |index| {
        if (haystack[index] | first_fold == literal.octets[0] and literal.stands_at(haystack, index)) return index;
    }
    return null;
}

/// What a run of blocks found: the first place of the literal, or the offset it stopped at.
const Found = struct { found: ?usize, index: usize };

/// The first and last octets a block's lanes are compared with, and what each compare ORs into
/// the text's octets first.
fn Wanted(comptime width: usize) type {
    const Vector = @Vector(width, u8);
    return struct { first: Vector, last: Vector, first_fold: Vector, last_fold: Vector };
}

/// How a loop compares a block: the first and last octets as they stand, the two folded, or a
/// literal of one octet, whose first octet is its last and is compared once.
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
    const last = literal.len - 1;
    const wanted: Wanted(width) = .{
        .first = @splat(literal.octets[0]),
        .last = @splat(literal.octets[last]),
        .first_fold = @splat(literal.fold_at(0)),
        .last_fold = @splat(literal.fold_at(last)),
    };
    var index = from;
    // A block reads `steps_len` octets from `index` and as many from `index + last`, whose last
    // is `end + steps_len - 2 + last`, under the haystack's length.
    while (end - index >= steps_len) : (index += steps_len) {
        const firsts = haystack[index..][0..steps_len];
        const lasts = if (form == .single) firsts else haystack[index + last ..][0..steps_len];
        // Most blocks hold no candidate. One reduction says so, where a mask costs a reduction
        // for each step on Arm, which has no instruction that gathers lane bits.
        if (!any_candidate(width, form, steps, firsts, lasts, &wanted)) continue;
        var mask = candidates(width, form, steps, firsts, lasts, &wanted);
        // Each set bit is one place to compare, at most `steps_len` of them.
        while (mask != 0) : (mask &= mask - 1) {
            const candidate = index + @ctz(mask);
            if (literal.stands_at(haystack, candidate)) return .{ .found = candidate, .index = index };
        }
    }
    return .{ .found = null, .index = index };
}

/// The text's octets of one step at the literal's first and last places, folded where the
/// literal folds.
inline fn step_lanes(comptime width: usize, comptime form: Form, firsts: anytype, lasts: anytype, comptime at: usize, wanted: *const Wanted(width)) Pair(width) {
    const first: @Vector(width, u8) = firsts[at..][0..width].*;
    if (form == .single) return .{ .first = first, .last = first };
    const last: @Vector(width, u8) = lasts[at..][0..width].*;
    if (form == .plain) return .{ .first = first, .last = last };
    return .{ .first = first | wanted.first_fold, .last = last | wanted.last_fold };
}

/// The text's octets of one step at the literal's first and at its last place.
fn Pair(comptime width: usize) type {
    return struct { first: @Vector(width, u8), last: @Vector(width, u8) };
}

/// True when some place of a block holds the first octet in `firsts` and the last octet at the
/// same place in `lasts`.
inline fn any_candidate(comptime width: usize, comptime form: Form, comptime steps: usize, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: *const Wanted(width)) bool {
    const all: @Vector(width, u8) = @splat(constants.octet_max);
    const none: @Vector(width, u8) = @splat(0);
    var any = none;
    inline for (0..steps) |step| {
        const pair = step_lanes(width, form, firsts, lasts, step * width, wanted);
        const first_here = @select(u8, pair.first == wanted.first, all, none);
        if (form == .single) {
            any |= first_here;
            continue;
        }
        const last_here = @select(u8, pair.last == wanted.last, all, none);
        any |= first_here & last_here;
    }
    return @reduce(.Or, any) != 0;
}

/// A bit for each place of a block where the first octet stands in `firsts` and the last octet
/// at the same place in `lasts`, the block read from the literal's last octet on.
inline fn candidates(comptime width: usize, comptime form: Form, comptime steps: usize, firsts: *const [steps * width]u8, lasts: *const [steps * width]u8, wanted: *const Wanted(width)) std.meta.Int(.unsigned, steps * width) {
    const BlockMask = std.meta.Int(.unsigned, steps * width);
    var mask: BlockMask = 0;
    inline for (0..steps) |step| {
        const at = step * width;
        const pair = step_lanes(width, form, firsts, lasts, at, wanted);
        const first_here = pair.first == wanted.first;
        const both = if (form == .single) first_here else @select(bool, first_here, pair.last == wanted.last, @as(@Vector(width, bool), @splat(false)));
        const step_mask: std.meta.Int(.unsigned, width) = @bitCast(both);
        mask |= @as(BlockMask, step_mask) << at;
    }
    return mask;
}
