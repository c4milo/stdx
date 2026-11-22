//! Claim R3 (decision 86): the forward scan of a DFA whose program holds an assertion and a
//! literal that every match starts with, after any assertion at its start, as in `\bword\b`.
//!
//! Claim R1's skip needs one state that waits for a match to start, whatever octet stands behind
//! it. A program with an assertion has one such state for each context of the octet behind, so
//! R1 is off for it. This scan goes to the literal's next place instead, and starts there in the
//! start state of the octet behind that place: the state the DFA would be in had a match been
//! able to start nowhere before. No match starts before a place of the literal, so the answer is
//! the one the DFA gives with no skip.
//!
//! A state with no thread that may still start a match is such a start state. `Dfa.build` marks
//! the entries that lead to one with `dfa_idle_flag`, so the scan's loop reads one entry an
//! octet, as the plain loop does, and tests one bound.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Context = program_file.Context;
const dfa_file = @import("dfa.zig");
const Dfa = dfa_file.Dfa;
const Scan = dfa_file.Scan;
const Literal = @import("literal.zig").Literal;

/// The scan of `Dfa.scan_forward` from `from`, for a DFA that looks for its literal.
pub fn scan(dfa: *Dfa, literal: *const Literal, haystack: []const u8, from: usize, earliest: bool) Scan {
    assert(dfa.looks_for_literal());
    var last: ?usize = null;
    var index = from;
    // Each turn starts at the state that waits and goes to the literal's next place, which is
    // past the place before, so the turns are at most the haystack's octets and one.
    for (0..haystack.len - from + 1) |_| {
        const place = literal.find(haystack, index) orelse break;
        dfa.skip_octets += place - index;
        index = place;
        const behind: Context = if (index == 0) .edge else Context.of(haystack[index - 1]);
        const start = dfa.start(behind) orelse return .gave_up;
        switch (run(dfa, haystack, index, start, earliest, &last)) {
            .done => |answer| return answer,
            .waits => |at| index = at,
        }
    }
    // No place of the literal is left, so no match starts after `index`, and the scan passes the
    // rest of the text.
    dfa.skip_octets += haystack.len - index;
    dfa.tally(haystack.len);
    return Scan.of(last);
}

/// The DFA's run from the start state at `from` until the scan's answer is known, or until the
/// DFA waits again for a match to start at `waits`.
fn run(dfa: *Dfa, haystack: []const u8, from: usize, first: u32, earliest: bool, last: *?usize) union(enum) { done: Scan, waits: usize } {
    const table = dfa.cache.table;
    const classes = &dfa.classes;
    var state = first;
    for (haystack[from..], from..) |octet, index| {
        const entry = table[state + classes[octet]];
        if (entry < constants.dfa_flags_min) {
            state = entry;
            continue;
        }
        const known = dfa.resolve(state, octet, entry, index) orelse return .{ .done = .gave_up };
        if (known & constants.dfa_match_flag != 0) last.* = index;
        if (known & constants.dfa_dead_flag != 0 or (earliest and last.* != null)) return .{ .done = Scan.of(last.*) };
        // A state with no thread, which follows no match (`Dfa.build`): the next match starts at
        // a place of the literal.
        if (known & constants.dfa_idle_flag != 0) return .{ .waits = index + 1 };
        state = known & constants.dfa_row_mask;
    }
    dfa.tally(haystack.len);
    if (dfa.matches_at_end(state, .edge)) last.* = haystack.len;
    return .{ .done = Scan.of(last.*) };
}
