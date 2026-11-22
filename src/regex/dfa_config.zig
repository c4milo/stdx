//! The configuration of a lazy DFA, and what its scan finds (dfa.zig, decision 86).

/// Which matches a DFA reports.
pub const Kind = enum {
    /// The forward program: a thread that matches ends every thread after it, as in the matcher,
    /// so the last match a scan sees is the one a backtracking matcher finds first.
    first,
    /// Every match is kept, so the last match a scan sees is the longest. The reverse program runs
    /// this way from a match's end, to find its start.
    longest,
};

pub const Config = struct {
    /// Where the program starts.
    entry: u32,
    kind: Kind,
    /// Whether a match must start at the scan's first octet.
    anchored: bool,
    /// Claim R1: whether a forward scan that waits for a match to start skips to the next octet
    /// that can start one (dfa_skip.zig). Only for a DFA of `Kind.first` that is not anchored:
    /// an anchored scan waits for no match, and the reverse program starts where a match ends.
    skip: bool = false,
    /// Claim R2: whether that skip goes to the next place of the literal every match starts
    /// with, where the program has one (literal.zig). Only with `skip`.
    literal: bool = false,
};

/// What a scan found: the offset its last match ended at in the scan's direction, none, or
/// nothing, because the cache thrashed.
pub const Scan = union(enum) {
    gave_up,
    none,
    found: usize,

    pub fn of(last: ?usize) Scan {
        return if (last) |offset| .{ .found = offset } else .none;
    }
};
