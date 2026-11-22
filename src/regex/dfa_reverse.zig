//! The reverse scan of a DFA (decision 86): the DFA of the reverse program reads back from where
//! a match ends, toward where the search started, and says where the match starts.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const Context = @import("program.zig").Context;
const dfa_file = @import("dfa.zig");
const Dfa = dfa_file.Dfa;
const Scan = dfa_file.Scan;

/// The least offset at or after `from` where a match that ends at `end` starts. The DFA runs
/// the reverse program from `end` toward `from`.
pub fn scan(dfa: *Dfa, haystack: []const u8, from: usize, end: usize) Scan {
    assert(from <= end and end <= haystack.len);
    const behind: Context = if (end == haystack.len) .edge else Context.of(haystack[end]);
    var state = dfa.start(behind) orelse return .gave_up;
    var last: ?usize = null;
    dfa.mark = end;
    const table = dfa.cache.table;
    const classes = &dfa.classes;
    var index = end;
    while (index > from) {
        index -= 1;
        const octet = haystack[index];
        const entry = table[state + classes[octet]];
        if (entry < constants.dfa_dead_flag) {
            state = entry;
            continue;
        }
        const known = dfa.resolve(state, octet, entry, index) orelse return .gave_up;
        if (known & constants.dfa_match_flag != 0) last = index + 1;
        if (known & constants.dfa_dead_flag != 0) return Scan.of(last);
        state = known & constants.dfa_row_mask;
    }
    dfa.tally(from);
    const ahead: Context = if (from == 0) .edge else Context.of(haystack[from - 1]);
    if (dfa.matches_at_end(state, ahead)) last = from;
    return Scan.of(last);
}
