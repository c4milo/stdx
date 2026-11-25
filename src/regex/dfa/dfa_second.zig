//! A DFA's second start (claim R14, decision 86): a state from which a scan takes the program
//! at `Dfa.second_entry`, with no match that starts after the scan's first byte.
//!
//! A searcher that goes to the places of a literal in a match's middle makes two such scans for
//! a place. The reverse DFA reads back from the place through the part of the program before the
//! literal, which starts at its second entry. The forward DFA then reads from the start that
//! scan found, anchored there, where its own scans wait for a match at every byte.
//!
//! The states of such a scan are states of the DFA's own cache. The start state alone differs,
//! by `second_bit` in its record, so a second start costs a searcher no memory.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Context = @import("../program.zig").Context;
const dfa_file = @import("dfa.zig");
const Dfa = dfa_file.Dfa;
const dfa_run = @import("dfa_run.zig");

/// The state a scan from the second start begins in, behind which stands a byte of `behind`'s
/// context. Null when the DFA gives up.
pub fn start(dfa: *Dfa, behind: Context) ?u32 {
    const context: Context = if (dfa.has_looks) behind else .other;
    const slot = constants.context_count + @as(usize, @intFromEnum(context));
    var row = dfa.cache.starts[slot];
    if (row == constants.dfa_unknown) {
        dfa.next.clear();
        const head = @intFromEnum(context) | dfa_file.restart_bit | dfa_file.second_bit;
        const clears = dfa.cache.clears;
        const interned = dfa.cache.intern(head, dfa.next.slice());
        // A cache that cleared holds no state under its old row, as in `Dfa.build`.
        if (dfa.cache.clears != clears) dfa.idle = constants.dfa_unknown;
        row = interned orelse return null;
        dfa.cache.starts[slot] = row;
    }
    return row;
}

/// What a forward scan from the second start found.
pub const Forward = union(enum) {
    gave_up,
    /// No match starts at the scan's first byte. The offset is where the scan stopped: at the
    /// byte that no thread took, or at the text's end.
    none: usize,
    /// Where the match that starts at the scan's first byte ends, as the matcher finds it.
    found: usize,

    fn of(last: ?usize, stop: usize) Forward {
        return if (last) |end| .{ .found = end } else .{ .none = stop };
    }
};

/// The forward program's match that starts at `from`, as the matcher finds it anchored there.
/// The scan takes two loops of `Dfa.scan_plain`: a run of plain rows, and a state that stays
/// (claim R9). It takes a run of matches one entry a byte: a match of a place is short beside
/// the text, and the loop of matches would leave no trace for a test to hold it by.
pub fn scan_forward(dfa: *Dfa, haystack: []const u8, from: usize) Forward {
    assert(from <= haystack.len and dfa.cache.table.len > 0);
    assert(dfa.config.kind == .first and dfa.second_entry == dfa.config.entry);
    const behind: Context = if (from == 0) .edge else dfa.context_of(haystack[from - 1]);
    var state = start(dfa, behind) orelse return .gave_up;
    var last: ?usize = null;
    dfa.mark = from;
    var at = from;
    // Each turn takes the bytes up to one whose entry is no plain row, and that byte, so the
    // turns are at most the bytes from `from` and one.
    for (0..haystack.len - from + 1) |_| {
        at = dfa_run.plain(dfa.cache.table, &dfa.classes, haystack, at, &state);
        if (at == haystack.len) break;
        const octet = haystack[at];
        const entry = dfa.cache.table[state +% dfa.classes[octet]];
        const known = dfa.resolve(state, octet, entry, at) orelse return .gave_up;
        if (known & constants.dfa_match_flag != 0) last = at;
        if (known & constants.dfa_dead_flag != 0) return Forward.of(last, at);
        state = known & constants.dfa_row_mask;
        at += 1;
        dfa.stay_past(haystack, &at, known, &last);
    }
    dfa.tally(haystack.len);
    if (dfa.matches_at_end(state, .edge)) last = haystack.len;
    return Forward.of(last, haystack.len);
}
