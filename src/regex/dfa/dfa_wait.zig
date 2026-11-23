//! Claim R1's state that waits (decision 86): the state of a forward DFA with no thread, from
//! which a match may still start, the octets it learns can start one, and the judgment that
//! rests the skip where its visits pass too few octets. `dfa_skip.zig` holds the search for the
//! next such octet.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Dfa = @import("dfa.zig").Dfa;
const Skip = @import("dfa_skip.zig").Skip;
const Pass = @import("dfa_config.zig").Pass;
const is_continuation = @import("../utf8_ranges.zig").is_continuation;

/// Readies the skip where a scan starts in `row`: it ends a rest that is over, and takes
/// `row` as the state that waits where the DFA knows none. True when the scan skips.
pub inline fn waits(dfa: *Dfa, row: u32) bool {
    assert(dfa.may_skip);
    if (dfa.skip_off and dfa.cache.scanned >= dfa.skip_retry_at) dfa.skip_off = false;
    if (!skips(dfa)) return false;
    if (dfa.idle == constants.dfa_unknown) wait_at(dfa, row);
    assert(dfa.idle == row);
    return true;
}

/// True when a scan may skip: `may_skip`, and the skip is not resting.
pub fn skips(dfa: *const Dfa) bool {
    return dfa.may_skip and !dfa.skip_off;
}

/// A visit of a scan to the state that waits, at an octet of the haystack: the offset of the
/// next octet that can start a match, which is `from` where its own octet can. With
/// `how` at `.literal`, the next place of the literal (claim R2), and at `.literal_set`, of one of
/// the literals (claim R5).
pub fn pass(dfa: *Dfa, comptime how: Pass, haystack: []const u8, from: usize) usize {
    const index = switch (how) {
        .literal => dfa.literal.?.find(haystack, from) orelse haystack.len,
        .literal_set => dfa.literals.?.find(haystack, from) orelse haystack.len,
        .octet => if (dfa.skip.starts[haystack[from]]) from else dfa.skip.next(haystack, from + 1),
    };
    dfa.skip_octets += index - from;
    dfa.skip_visits += 1;
    if (dfa.skip_visits == constants.skip_trial_visits) judge_skip(dfa);
    return index;
}

/// True where the DFA holds claim R2's literal or R5's set, which every match starts with.
pub inline fn has_literal(dfa: *const Dfa) bool {
    return dfa.literal != null or dfa.literals != null;
}

/// The first offset at or after `from` where a match can start by claim R2 or R5: the next place
/// of the DFA's literal, or of one of its literals. Null where none stands from `from` on, so that
/// no match starts there.
pub fn first_start(dfa: *const Dfa, haystack: []const u8, from: usize) ?usize {
    assert(has_literal(dfa));
    if (dfa.literal) |*literal| return literal.find(haystack, from);
    return dfa.literals.?.find(haystack, from);
}

/// Turns the skip off where its visits passed too few octets to pay for themselves, until
/// the scans took `skip_rest_octets` more octets.
fn judge_skip(dfa: *Dfa) void {
    const poor = dfa.skip_octets < @as(u64, dfa.skip_visits) * constants.skip_octets_per_visit_min;
    dfa.skip_visits = 0;
    dfa.skip_octets = 0;
    if (!poor) {
        dfa.skip_poor_trials = 0;
        return;
    }
    dfa.skip_off = true;
    dfa.skip_retry_at = dfa.cache.scanned + (@as(u64, constants.skip_rest_octets) << dfa.skip_poor_trials);
    dfa.skip_poor_trials = @min(dfa.skip_poor_trials + 1, constants.skip_rest_doublings_max);
    dfa.idle = constants.dfa_unknown;
}

/// Takes `row` as the state that waits for a match to start, and learns once which octets
/// can start one: those the state does not answer by staying where it is.
fn wait_at(dfa: *Dfa, row: u32) void {
    if (!dfa.skip_known) {
        var class_starts: [constants.octet_values]bool = undefined;
        for (0..dfa.class_count) |class| {
            const octet = dfa.representatives[class];
            const matched = dfa.close(row, dfa.context_of(octet), !is_continuation(octet));
            dfa.step(octet);
            class_starts[class] = matched or dfa.next.len != 0;
        }
        var starts: [constants.octet_values]bool = undefined;
        for (&starts, dfa.classes) |*start_here, class| start_here.* = class_starts[class];
        dfa.skip = Skip.init(&starts);
        dfa.skip_known = true;
    }
    dfa.idle = row;
}
