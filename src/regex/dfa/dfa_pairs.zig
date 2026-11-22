//! Claim R7 (decision 86): a forward scan with no skip takes two octets for one read of the
//! cache, where the program has few classes of octets.
//!
//! A plain scan reads one entry for each octet, and each read waits for the read before it: the
//! entry is the row of the next read. On a core whose loads take four or five cycles, that chain
//! bounds the scan, whatever else the core could do. A table indexed by the state and a pair of
//! classes halves the chain. Each state keeps a second row, of `pair_stride` entries, built as
//! scans meet its pairs. An entry holds the pair row of the state two octets on, so the loop's
//! one add and one read stay as they are, two octets a turn.
//!
//! A pair whose first or second octet leads to an entry with a flag, a match or a dead state,
//! gets the mark `pair_single`: the scan takes those two octets one at a time, as a scan with no
//! claim does, so the claim changes no answer. A cache that clears while a pair is built keeps
//! no entry for it, as `Dfa.build_entry` keeps none.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const program_file = @import("../program.zig");
const Program = program_file.Program;
const dfa_file = @import("dfa.zig");
const Dfa = dfa_file.Dfa;
const Scan = dfa_file.Scan;

/// The octets one entry of a pair row takes.
pub const pair_octets = 2;

/// The mark of a pair that the scan takes one octet at a time. It is under `dfa_unknown`, so it
/// is no entry still to build, and at `dfa_flags_min` or over, so it is no pair row.
pub const pair_single = constants.dfa_flags_min;

/// The shift from a state's row of the table to its pair row: the least that gives each pair of
/// classes an entry. Null where the program has more than `pair_classes_max` classes, whose pair
/// rows would crowd the cache.
pub fn shift_of(program: *const Program, stride: u32) ?u5 {
    if (program.class_count > constants.pair_classes_max) return null;
    const pairs = @as(u32, program.class_count) * program.class_count;
    var shift: u5 = 0;
    // At most `pair_classes_max` squared over a stride of one: a few turns.
    while ((stride << shift) < pairs) shift += 1;
    return shift;
}

/// Each octet's class times the class count: the first octet's part of a pair's column.
pub fn first_columns(classes: *const [constants.octet_values]u8, class_count: u32) [constants.octet_values]u16 {
    assert(class_count <= constants.pair_classes_max);
    var columns: [constants.octet_values]u16 = undefined;
    for (&columns, classes) |*column, class| column.* = @intCast(@as(u32, class) * class_count);
    return columns;
}

/// Takes the octets from `from` two a turn while the pair row holds an entry for their pair.
/// Stops where fewer than two octets are left, or at a pair to build or to take one at a time.
pub inline fn run(dfa: *const Dfa, haystack: []const u8, from: usize, state: *u32) usize {
    const pairs = dfa.cache.pairs;
    const shift = dfa.pair_shift;
    var current = state.* << shift;
    var index = from;
    // Each turn takes two octets.
    while (haystack.len - index >= pair_octets) {
        // A pair row is under the pairs' length less a pair stride, and a column under the
        // stride, so the sum cannot wrap, and the read's bounds check holds it.
        const column = @as(u32, dfa.first_columns[haystack[index]]) + dfa.classes[haystack[index + 1]];
        const entry = pairs[current +% column];
        if (entry >= constants.dfa_flags_min) break;
        current = entry;
        index += pair_octets;
    }
    state.* = current >> shift;
    return index;
}

/// What claim R7 did in one turn of a plain scan: gave the scan's answer, took octets and two
/// more, or left the rest of the turn to the table.
pub const Turn = union(enum) { done: Scan, next, table };

/// One turn of a plain scan under claim R7, from a state with a pair row: a run of pairs, and
/// the two octets after it one at a time. The table takes the turn from a state with no pair
/// row, and the last octet of a text.
pub inline fn turn(dfa: *Dfa, haystack: []const u8, at: *usize, earliest: bool, state: *u32, last: *?usize) Turn {
    if (state.* >= dfa.cache.pair_states * dfa.cache.stride) return .table;
    at.* = run(dfa, haystack, at.*, state);
    if (haystack.len - at.* < pair_octets) return .table;
    switch (steps(dfa, haystack, at.*, earliest, state, last)) {
        .done => |scan| return .{ .done = scan },
        .next => |next| at.* = next,
    }
    return .next;
}

/// What two single steps from `at` gave: the scan's answer, or the offset after them.
pub const Steps = union(enum) { done: Scan, next: usize };

/// Takes the two octets at `at` one at a time, as a scan with no claim does, and keeps their
/// pair's entry: the pair row two octets on, or `pair_single` where a step met a flag.
pub fn steps(dfa: *Dfa, haystack: []const u8, at: usize, earliest: bool, state: *u32, last: *?usize) Steps {
    assert(haystack.len - at >= pair_octets);
    const row = state.*;
    const column = @as(u32, dfa.first_columns[haystack[at]]) + dfa.classes[haystack[at + 1]];
    const clears = dfa.cache.clears;
    var plain = true;
    var current = row;
    for (at..at + pair_octets) |index| {
        const octet = haystack[index];
        const entry = dfa.cache.table[current +% dfa.classes[octet]];
        const known = dfa.resolve(current, octet, entry, index) orelse return .{ .done = .gave_up };
        if (known >= constants.dfa_flags_min) plain = false;
        if (known & constants.dfa_match_flag != 0) last.* = index;
        if (known & constants.dfa_dead_flag != 0 or (earliest and last.* != null)) {
            keep(dfa, row, column, clears, constants.dfa_unknown, plain);
            return .{ .done = Scan.of(last.*) };
        }
        current = known & constants.dfa_row_mask;
    }
    keep(dfa, row, column, clears, current, plain);
    state.* = current;
    return .{ .next = at + pair_octets };
}

/// Keeps a pair's entry, where the cache did not clear while the pair was built. A state with no
/// pair row is reached by the mark: the scan goes on from it one octet at a time.
fn keep(dfa: *Dfa, row: u32, column: u32, clears: u32, next: u32, plain: bool) void {
    if (dfa.cache.clears != clears) return;
    const rows_end = dfa.cache.pair_states * dfa.cache.stride;
    assert(row < rows_end);
    dfa.cache.pairs[(row << dfa.pair_shift) + column] = if (plain and next < rows_end) next << dfa.pair_shift else pair_single;
}
