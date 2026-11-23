//! The capture groups of a match, read in place from the searcher's slots (searcher.zig, decision
//! 86).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Span = @import("../matcher.zig").Span;

/// The capture groups of a match, the whole match first: two slots for each group, which the
/// searcher's search wrote and which `get` reads in place, as Rust's crate reads its slots. They
/// hold until the searcher's next search. A copy into spans cost rebar's lexer row, whose 89
/// groups are unset but for one or two, 15% of its instructions (design §8 part 22n).
pub const Groups = struct {
    slots: []const u64,

    /// The groups, the whole match counted.
    pub fn len(groups: Groups) usize {
        assert(groups.slots.len % constants.group_slots == 0);
        return groups.slots.len / constants.group_slots;
    }

    /// The span of group `index`, or null where the group took no part in the match.
    pub fn get(groups: Groups, index: usize) ?Span {
        const pair = groups.slots[index * constants.group_slots ..][0..constants.group_slots];
        // As `Matcher.group` reads them: a path that passes a group's opening save passes its
        // closing save, so a finished search leaves both slots set or neither.
        if (pair[0] == constants.slot_unset or pair[1] == constants.slot_unset) return null;
        assert(pair[0] <= pair[1]);
        return .{ .start = pair[0], .end = pair[1] };
    }
};
