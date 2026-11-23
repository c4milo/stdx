//! The copy of a match's groups from the matcher's slots into the caller's spans (searcher.zig,
//! decision 86).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const matcher_file = @import("../matcher.zig");
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;

/// The groups of the matcher's match, read from its slots in one pass: what `Matcher.group`
/// gives for each, with no call for each.
pub fn copy_groups(matcher: *const Matcher, groups: []?Span) void {
    assert(matcher.finished and matcher.matched);
    const slots = matcher.best();
    assert(slots.len == groups.len * constants.group_slots);
    // Most groups of a pattern of many took no part in a match: `copy_lanes` at a time, the
    // slots of such groups are judged in one compare. A pattern of fewer groups keeps one loop.
    const blocks = groups.len / copy_lanes;
    for (0..blocks) |block| {
        const first = block * copy_lanes;
        const lanes: @Vector(copy_lanes * constants.group_slots, u64) = slots[first * constants.group_slots ..][0 .. copy_lanes * constants.group_slots].*;
        if (@reduce(.And, lanes == @as(@TypeOf(lanes), @splat(constants.slot_unset)))) {
            @memset(groups[first..][0..copy_lanes], null);
            continue;
        }
        for (first..first + copy_lanes) |index| copy_group(slots, groups, index);
    }
    for (blocks * copy_lanes..groups.len) |index| copy_group(slots, groups, index);
}

/// The groups `copy_groups` judges in one compare. A copy of the lexer row of rebar's, whose 89
/// groups are unset but for one or two, took 9.5% fewer instructions (design §8 part 22n).
const copy_lanes = 8;

inline fn copy_group(slots: []const u64, groups: []?Span, index: usize) void {
    const start = slots[index * constants.group_slots];
    const end = slots[index * constants.group_slots + 1];
    groups[index] = if (start == constants.slot_unset or end == constants.slot_unset) null else .{ .start = start, .end = end };
}
