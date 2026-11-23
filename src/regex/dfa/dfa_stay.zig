//! Claim R9 (decision 86): a state that stays where it is over a run of octets, and the skip past
//! the run.
//!
//! A forward scan can read a long run of octets in one state, as `.*[^A-Z]` reads a text of
//! capitals or `.*=` reads to the next equals sign. Each octet's entry leads back to the state.
//! `Dfa.build` marks such an entry with `dfa_skip_flag`, so the scan's loop leaves there. The
//! skip then reads the octets one at a time against the table, `skip_scalar_run` of them, and
//! then `skip_lanes` octets a step against the ranges of the octets that leave the state. It stops
//! at the first octet whose entry is another, so the answer is the one the scan gives with no
//! skip. An entry the table does not hold yet counts as one that leaves.
//!
//! A run of a few octets costs more to skip than to read. A state takes the flag only while it
//! holds one of the DFA's `stay_records` records, and its visits are judged as claim R1 judges its
//! own (`skip_trial_visits`, `stay_octets_per_visit_min`). A state whose visits passed too few
//! octets loses the flag from its entries, and its record goes to the next state that stays. A
//! state that finds every record held by a state still in trial, or judged good, takes no flag.
//! So a pattern with many states that stay over short runs, as each copy of `[a-z]+` in
//! `(?:[A-Z][a-z]+\s*){10,100}` stays, pays for the trials of a few of them at a time.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Dfa = @import("dfa.zig").Dfa;
const Ranges = @import("dfa_skip.zig").Ranges;

/// What a DFA keeps of one state that stays.
pub const Stay = struct {
    /// The state's row, or `dfa_unknown` where the record holds none.
    row: u32 = constants.dfa_unknown,
    /// The entry of the octets the state stays over: its row and `dfa_skip_flag`, with
    /// `dfa_match_flag` where a match ends before each of them.
    entry: u32 = constants.dfa_unknown,
    /// The octets whose entry from the state is another, where `known`.
    exits: Ranges = .{ .ranges = undefined, .whole = false },
    known: bool = false,
    /// The visits since the state was last judged, and the octets they passed.
    visits: u32 = 0,
    octets: u64 = 0,
    /// True where the visits passed too few octets: the state's entries lost the flag.
    poor: bool = false,
};

/// The records of a new DFA, or of one whose cache cleared: none.
pub const empty: [constants.stay_records]Stay = @splat(.{});

/// The record of `row`, or null where it holds none. A cache that cleared holds none of the rows
/// the records name.
fn find(dfa: *Dfa, row: u32) ?*Stay {
    if (dfa.stays_clears != dfa.cache.clears) {
        dfa.stays = empty;
        dfa.stays_clears = dfa.cache.clears;
    }
    for (&dfa.stays) |*stay| {
        if (stay.row == row) return stay;
    }
    return null;
}

/// The record of `row`: its own, or one that holds no state or a state judged poor, whose entries
/// lost the flag. Null where every record holds another state still in trial or judged good.
fn claim(dfa: *Dfa, row: u32) ?*Stay {
    if (find(dfa, row)) |stay| return stay;
    for (&dfa.stays) |*stay| {
        if (stay.row != constants.dfa_unknown and !stay.poor) continue;
        stay.* = .{ .row = row };
        return stay;
    }
    return null;
}

/// True where `Dfa.build` marks the entry from `state` to `row` with `dfa_skip_flag`: the claim
/// is on, the entry leads back to the state, the cache did not clear since `clears` while the
/// entry was built, and the state holds a record and was not judged poor. A new entry that leads
/// back changes the octets that leave the state, so its record learns them again.
pub fn marks(dfa: *Dfa, state: u32, row: u32, clears: u32) bool {
    if (!dfa.config.stays or row != state or dfa.cache.clears != clears) return false;
    const stay = claim(dfa, state) orelse return false;
    stay.known = false;
    return !stay.poor;
}

/// A visit of a scan to a state that stays, after it read the octet before `at` with `entry`:
/// the offset of the first octet at or after `at` whose entry from `state` is another, or the
/// haystack's length. Where the entry holds the match flag, a match ended before each octet it
/// passed, and `last` becomes the last of them.
pub fn pass(dfa: *Dfa, haystack: []const u8, at: usize, state: u32, entry: u32, last: *?usize) usize {
    assert(entry & constants.dfa_skip_flag != 0 and entry & constants.dfa_row_mask == state);
    assert(at <= haystack.len);
    const stay = ready(dfa, state, entry);
    const table = dfa.cache.table;
    const classes = &dfa.classes;
    var index = at;
    // A run that ends within a few octets, as most do where the state is left often, costs no
    // step of `skip_lanes` octets.
    const near = @min(haystack.len, at + constants.skip_scalar_run);
    while (index < near and table[state +% classes[haystack[index]]] == entry) index += 1;
    if (index == near and stay.exits.whole) index = stay.exits.first(haystack, index);
    // Each turn takes one octet: at most the haystack's octets from `index`.
    while (index < haystack.len and table[state +% classes[haystack[index]]] == entry) index += 1;
    if (entry & constants.dfa_match_flag != 0 and index > at) last.* = index - 1;
    stay.visits += 1;
    stay.octets += index - at + 1;
    if (stay.visits == constants.skip_trial_visits) judge(dfa, stay);
    return index;
}

/// The record of `state`, with the octets that leave it under `entry`. Each entry with the flag
/// leads back to a state that holds a record: a record goes to another state only once its own
/// entries lost the flag, and a cache that clears forgets every entry.
fn ready(dfa: *Dfa, state: u32, entry: u32) *Stay {
    const stay = find(dfa, state).?;
    assert(!stay.poor);
    if (stay.entry != entry or !stay.known) {
        var leaves: [constants.octet_values]bool = undefined;
        for (&leaves, dfa.classes) |*leave, class| leave.* = dfa.cache.table[state + class] != entry;
        stay.entry = entry;
        stay.exits = Ranges.of(&leaves);
        stay.known = true;
    }
    return stay;
}

/// Keeps a state's skip where its visits passed `stay_octets_per_visit_min` octets each on
/// average. Otherwise each entry of its row that leads back to it loses the flag, and the scan's
/// loop reads those octets as it reads any other. Claim R7 took each pair with such an entry one
/// octet at a time (`pair_single`), so the state's pair row is forgotten too, and its pairs are
/// built again.
fn judge(dfa: *Dfa, stay: *Stay) void {
    const poor = stay.octets < @as(u64, stay.visits) * constants.stay_octets_per_visit_min;
    stay.visits = 0;
    stay.octets = 0;
    if (!poor) return;
    stay.poor = true;
    const row = dfa.cache.table[stay.row..][0..dfa.class_count];
    for (row) |*entry| {
        if (entry.* == constants.dfa_unknown or entry.* & constants.dfa_row_mask != stay.row) continue;
        entry.* &= ~@as(u32, constants.dfa_skip_flag);
    }
    const cache = &dfa.cache;
    if (stay.row < cache.pair_states * cache.stride) @memset(cache.pairs[stay.row << dfa.pair_shift ..][0..cache.pair_stride], constants.dfa_unknown);
}
