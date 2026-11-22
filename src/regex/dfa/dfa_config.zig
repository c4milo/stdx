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
    /// Claim R5: whether that skip goes to the next place of one of the literals that the
    /// branches of an alternation start with, where the program has no literal of claim R2 and
    /// no assertion (literal_set.zig). Only with `skip`.
    literal_set: bool = false,
    /// Whether the searches of claims R2 and R5 run in the variant object of x86-64's AVX2,
    /// `avx2_lanes` octets a step (`Literal.wide`).
    wide: bool = false,
    /// Claim R7: whether a forward scan with no skip takes two octets a read (dfa_pairs.zig).
    pairs: bool = false,
};

/// What a visit of a scan to the state that waits goes to (dfa_wait.zig): the next octet that
/// can start a match (claim R1), the next place of the literal (claim R2), or of one of the
/// literals (claim R5).
pub const Pass = enum { octet, literal, literal_set };

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
