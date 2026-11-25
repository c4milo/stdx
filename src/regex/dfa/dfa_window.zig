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
//! search from the window gives the matcher's answer. Where every match holds one literal of a
//! set instead, `dfa_window_set.window_set_of` reads the set, and claim R5's `LiteralSet` finds
//! its places (spec/lean/Stdx/Regex/RulesWindowSet.lean).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Literal = @import("../literal.zig").Literal;
const LiteralSet = @import("../literal_set.zig").LiteralSet;
const Config = @import("dfa_config.zig").Config;
const dfa_file = @import("dfa.zig");
const Dfa = dfa_file.Dfa;
const Scan = dfa_file.Scan;

/// The literals of a window over a set, with what the seeded check reads of each way: the
/// instruction of the reverse program that takes its literal first, and the one that reads the
/// part of a match before the literal.
pub const Set = struct {
    literals: LiteralSet,
    cuts: [constants.window_ways_max]u32,
    befores: [constants.window_ways_max]u32,
};

/// What a window goes to: the places of one literal, or of any literal of a set.
pub const Finder = union(enum) {
    one: Literal,
    set: Set,

    /// The first place at or after `from`, or null.
    fn find(finder: *const Finder, haystack: []const u8, from: usize) ?usize {
        return switch (finder.*) {
            .one => |*literal| literal.find(haystack, from),
            .set => |*set| set.literals.find(haystack, from),
        };
    }
};

/// A literal that every match holds, or one literal of a set, and the most bytes of a match
/// before it.
pub const Window = struct {
    finder: Finder,
    /// The most bytes that the part of a match before the literal takes.
    lead: u32,
    /// The instruction of the reverse program that reads the part of a match before one
    /// literal, which the seeded check reads. A set holds one for each way.
    before: u32,
    /// What the scan learned of the text: no place of the literal stands from `searched` up to
    /// `place`, and the literal stands at `place`, or `place` is the text's length.
    searched: usize = no_search,
    place: usize = 0,
};

/// Takes the searches of the CPU's features that `config` names, as claim R5's set takes them
/// in `Dfa.init`.
pub fn ready(window: *Window, config: *const Config) void {
    switch (window.finder) {
        .one => |*literal| literal.wide = config.wide,
        .set => |*set| {
            set.literals.wide = config.wide;
            set.literals.ssse3 = config.ssse3;
        },
    }
}

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
        window.place = window.finder.find(haystack, from) orelse haystack.len;
    }
    if (window.place == haystack.len) return haystack.len;
    const start = @max(from, window.place -| window.lead);
    assert(start <= window.place);
    return if (dfa.skip.starts[haystack[start]]) start else dfa.skip.next(haystack, start + 1);
}
