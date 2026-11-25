//! The window (decision 86): a literal that every match holds at most `lead` bytes after its
//! start, as `ing` in `\s[a-zA-Z]{0,12}ing\s`.
//!
//! No match starts more than `lead` bytes before the first place of the literal. So the forward
//! scan's state that waits goes to `lead` bytes before the next place, and from there to the next
//! byte that can start a match, as claim R1's skip does. Every byte from there on goes through
//! the DFA, so the part of a match before the literal may hold the literal's bytes, which claim
//! R4's rules and claim R14's refuse.
//!
//! `dfa_inner.window_of` reads the literal and the bound from the reverse program.
//! spec/lean/Stdx/Regex/RulesWindow.lean decides the same rule from a program, and proves that a
//! search from the window gives the matcher's answer.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Literal = @import("../literal.zig").Literal;
const dfa_file = @import("dfa.zig");
const Dfa = dfa_file.Dfa;
const Scan = dfa_file.Scan;

/// A literal that every match holds, and the most bytes of a match before it.
pub const Window = struct {
    literal: Literal,
    /// The most bytes that the part of a match before the literal takes.
    lead: u32,
    /// The instruction of the reverse program that reads the part of a match before the
    /// literal, which the seeded check reads.
    before: u32,
    /// What the scan learned of the text: no place of the literal stands from `searched` up to
    /// `place`, and the literal stands at `place`, or `place` is the text's length.
    searched: usize = no_search,
    place: usize = 0,
};

/// A scan that has not searched for the literal yet.
const no_search = std.math.maxInt(usize);

/// `Dfa.scan_forward` for a DFA with a window, from the state that waits at `first`. Out of
/// line, as claim R2's copy of the loop is.
pub noinline fn scan(dfa: *Dfa, haystack: []const u8, from: usize, earliest: bool, first: u32) Scan {
    assert(dfa.window != null and dfa.literal == null and dfa.literals == null);
    // What a scan learned of one text holds for that text alone.
    dfa.window.?.searched = no_search;
    return dfa.skip_loop(.window, haystack, from, earliest, first);
}

/// A visit of a scan to the state that waits, at `from`: the first offset at or after `from`
/// and at or after `lead` bytes before the literal's next place, whose byte can start a match.
/// The haystack's length where no place is left, since no match starts then.
pub fn pass(dfa: *Dfa, haystack: []const u8, from: usize) usize {
    assert(from < haystack.len);
    const window = &dfa.window.?;
    // The next place is the one learned where the scan has not passed it, since no place stands
    // between the offset it searched from and it. The scan only goes forward.
    if (window.searched > from or window.place < from) {
        window.searched = from;
        window.place = window.literal.find(haystack, from) orelse haystack.len;
    }
    if (window.place == haystack.len) return haystack.len;
    const start = @max(from, window.place -| window.lead);
    assert(start <= window.place);
    return if (dfa.skip.starts[haystack[start]]) start else dfa.skip.next(haystack, start + 1);
}
