//! What a decode may use, and what it counts. `decode` takes the defaults; the tests, the fuzzer
//! and the benchmarks switch the rest (decision 16, design §8 step 7).

const Claims = @import("claims.zig").Claims;

pub const Options = struct {
    /// The fast path of decision 16, for the symbols of a block while the margins hold.
    fast_paths: bool = true,
    /// Decision 14's claims, which the benchmark switches off one at a time (claims.zig).
    claims: Claims = .{},
    /// Counts how each symbol was decoded, S2's test (decision 14). `decode_counting` sets it, and
    /// `decode_with` refuses it.
    count_lookups: bool = false,
};

/// How a decode took its symbols. A literal/length symbol and a distance count once each.
pub const Lookups = struct {
    /// By one lookup in the fast path's tables (decision 14, S2).
    table: u64 = 0,
    /// By the canonical code, after a lookup found a code longer than the table.
    canonical: u64 = 0,
    /// By the checked path.
    checked: u64 = 0,

    pub fn add(self: *Lookups, other: Lookups) void {
        self.table += other.table;
        self.canonical += other.canonical;
        self.checked += other.checked;
    }
};

/// Where a decode on `options` counts: the caller's `Lookups` when it counts, and nothing when it
/// does not, so a decode that does not count carries no counter.
pub fn Counter(comptime options: Options) type {
    return if (options.count_lookups) *Lookups else void;
}
