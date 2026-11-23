//! The reverse scan of a DFA (decision 86): the DFA of the reverse program reads back from where
//! a match ends, toward where the search started, and says where the match starts.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Context = @import("../program.zig").Context;
const dfa_file = @import("dfa.zig");
const Dfa = dfa_file.Dfa;
const Scan = dfa_file.Scan;
const dfa_run = @import("dfa_run.zig");

/// The least offset at or after `from` where a match that ends at `end` starts. The DFA runs
/// the reverse program from `end` toward `from`. Inline: a search makes one for each match.
pub inline fn scan(dfa: *Dfa, haystack: []const u8, from: usize, end: usize) Scan {
    assert(from <= end and end <= haystack.len);
    const behind: Context = if (end == haystack.len) .edge else dfa.context_of(haystack[end]);
    var state = dfa.start(behind) orelse return .gave_up;
    var last: ?usize = null;
    dfa.mark = end;
    const table = dfa.cache.table;
    const classes = &dfa.classes;
    var index = end;
    while (index > from) {
        index -= 1;
        const octet = haystack[index];
        // As in `Dfa.scan_plain`, the sum of a row and a class cannot wrap.
        const entry = table[state +% classes[octet]];
        if (entry < constants.dfa_dead_flag) {
            state = entry;
            continue;
        }
        if (settle(dfa, haystack, from, &index, &state, entry, &last)) |answer| return answer;
    }
    dfa.tally(from);
    const ahead: Context = if (from == 0) .edge else Context.of(haystack[from - 1]);
    if (dfa.matches_at_end(state, ahead)) last = from;
    return Scan.of(last);
}

/// What the reverse scan does with an entry at `index` that is no plain row: the entry is built
/// where the table does not hold it, and a match that starts after the octet is kept in `last`.
/// The loop of matches then takes the octets before it whose entries are rows. The scan's
/// answer where no earlier octet can change it.
inline fn settle(dfa: *Dfa, haystack: []const u8, from: usize, index: *usize, state: *u32, entry: u32, last: *?usize) ?Scan {
    const known = dfa.resolve(state.*, haystack[index.*], entry, index.*) orelse return .gave_up;
    if (known & constants.dfa_match_flag != 0) last.* = index.* + 1;
    if (known & constants.dfa_dead_flag != 0) return Scan.of(last.*);
    state.* = known & constants.dfa_row_mask;
    if (known & constants.dfa_match_flag != 0) {
        var started = index.* + 1;
        index.* = dfa_run.matched_back(dfa.cache.table, &dfa.classes, haystack, from, index.*, state, &started);
        last.* = started;
        if (index.* == from) return null;
        // A match that starts after the octet before `index` starts at `index`.
        return dfa_run.end_of_run(dfa.cache.table, &dfa.classes, haystack, index.* - 1, state.*, last.*, index.*);
    }
    return null;
}
