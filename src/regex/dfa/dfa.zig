//! A lazy DFA over one program (decision 86): the states the matcher's lists would hold, each
//! built the first time a search reaches it and kept in a cache the caller's memory bounds.
//!
//! A state is the instructions a search waits at, in order of preference, and what the octet
//! behind it is to an assertion. A table holds, for each state and each class of octets, the
//! state that follows. An octet whose entry is known costs one read of the table, whatever the
//! pattern. An entry not yet known is built as the matcher builds a position's threads, without
//! the capture slots, which is why a DFA says where a match ends and not what its groups hold.
//!
//! The states of a pattern can be exponentially many, so the cache is a fixed size. When it
//! fills, every state is forgotten and the search goes on. When it fills again within
//! `dfa_octets_per_state_min` octets a state, the DFA gives up, and its caller runs the matcher,
//! whose cost has no such cliff. Cox's RE2 and Rust's regex bound a lazy DFA the same way.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const program_file = @import("../program.zig");
const Program = program_file.Program;
const Instruction = program_file.Instruction;
const Context = program_file.Context;
const NodeSet = @import("dfa_node_set.zig").NodeSet;
const Cache = @import("dfa_cache.zig").Cache;
const Skip = @import("dfa_skip.zig").Skip;
const Literal = @import("../literal.zig").Literal;
const LiteralSet = @import("../literal_set.zig").LiteralSet;
const dfa_literal = @import("dfa_literal.zig");
const dfa_wait = @import("dfa_wait.zig");
const dfa_window = @import("dfa_window.zig");
const dfa_reverse = @import("dfa_reverse.zig");
const dfa_pairs = @import("dfa_pairs.zig");
const dfa_run = @import("dfa_run.zig");
const dfa_close = @import("dfa_close.zig");
const dfa_stay = @import("dfa_stay.zig");
const dfa_init = @import("dfa_init.zig");

const dfa_config = @import("dfa_config.zig");
pub const Kind = dfa_config.Kind;
pub const Config = dfa_config.Config;
pub const Scan = dfa_config.Scan;
const Block = dfa_config.Block;

/// The lists a DFA builds a state with, and their words (dfa_init.zig).
pub const sparse_lists = dfa_init.sparse_lists;
pub const node_lists = dfa_init.node_lists;
pub const lists_len = dfa_init.lists_len;
pub const nodes_of = dfa_init.nodes_of;
pub const cache_len_min = dfa_init.cache_len_min;

/// The bit of a record's first word that says a match may still start at the state.
pub const restart_bit = 1 << constants.context_bits;
pub const context_mask = restart_bit - 1;

/// The bit of a record's first word that says the state starts a scan from the DFA's second
/// start: it takes the program at `Dfa.second_entry`, and no match starts after it
/// (dfa_second.zig).
pub const second_bit = restart_bit << 1;

pub const Dfa = struct {
    instructions: []const Instruction,
    config: Config,
    has_looks: bool,
    encoding: program_file.Encoding,
    /// True when claim R1 is on and one state waits for a match to start whatever octet stands
    /// behind it. A program with an assertion has one such state for each context, so it has
    /// no skip.
    may_skip: bool,
    classes: [constants.octet_values]u8,
    /// One octet of each class, which stands for the class when a state is built.
    representatives: [constants.octet_values]u8,
    class_count: u32,
    /// Claim R7: the shift from a row of the table to the state's pair row, and each octet's
    /// class times the class count. The cache's `pair_stride` is zero where the claim is off.
    pair_shift: u5,
    first_columns: [constants.octet_values]u16,
    cache: Cache,
    /// The instructions the state being built passed through.
    visited: NodeSet,
    /// The instructions the state being built leads to, in order of preference.
    next: NodeSet,
    threads: []u32,
    threads_len: u32,
    stack: []u32,
    stack_len: u32,
    /// True when the state being built reached `match`.
    reached: bool,
    /// Where the scan last counted its octets from.
    mark: usize,
    /// Claim R1. The octets a match can start with, known once a scan asked for them.
    skip: Skip,
    /// Claim R2. The literal every match starts with, where the skip goes instead. In a program
    /// with an assertion, the literal after the assertions at its start (claim R3).
    literal: ?Literal,
    /// Claim R5. The literals one of which every match starts with, where the skip goes instead.
    literals: ?LiteralSet,
    /// The window: a literal near every match's start, where neither R2 nor R5 holds one.
    window: ?dfa_window.Window = null,
    /// Claim R3: the program holds an assertion and `literal`, and the scan goes to the literal
    /// from each state with no thread, which `build` marks with `dfa_skip_flag`.
    looking: bool,
    skip_known: bool,
    /// The row of the state that waits for a match to start, with no thread: a scan in it may
    /// skip. `dfa_unknown` where the DFA skips nothing, or the cache holds no such state now.
    idle: u32,
    /// The visits of scans to that state since the skip was last judged, and the octets the
    /// visits passed. Claim R3's scan adds the octets it passes, and judges none.
    skip_visits: u32,
    skip_octets: u64,
    /// True while the skip is off because it was judged poor, until the scans took
    /// `skip_rest_octets` more octets: the count of scanned octets at which it is tried again.
    skip_off: bool,
    skip_retry_at: u64,
    /// The trials that judged the skip poor since one judged it good, up to
    /// `skip_rest_doublings_max`: each doubles the rest.
    skip_poor_trials: u6,
    /// Where a scan from the second start takes the program: the DFA's own entry, unless a
    /// searcher names another (claim R14, dfa_second.zig).
    second_entry: u32,
    /// Claim R9: the states that stay, and the clears of the cache when the records were made.
    stays: [constants.stay_records]dfa_stay.Stay,
    stays_clears: u32,

    /// How a DFA takes its memory (dfa_init.zig): with lists of its own, or with lists that the
    /// program's other DFA takes too.
    pub const memory_len_min = dfa_init.memory_len_min;
    pub const init = dfa_init.init;
    pub const init_sharing = dfa_init.init_sharing;

    pub fn looks_for_literal(dfa: *const Dfa) bool {
        return dfa.looking;
    }

    /// The offset where the forward program's match from `from` ends, as the matcher finds it, or
    /// with `earliest` the first offset where any match ends. Inline, with the loops of R1 and of
    /// no claim, so that a text with many matches makes no call for each: a search inlines it.
    pub inline fn scan_forward(dfa: *Dfa, haystack: []const u8, from: usize, earliest: bool) Scan {
        assert(from <= haystack.len and dfa.cache.table.len > 0);
        const behind: Context = if (from == 0) .edge else dfa.context_of(haystack[from - 1]);
        const state = dfa.start(behind) orelse return .gave_up;
        dfa.mark = from;
        // Claims R1 and R3 have loops of their own, so a scan that takes neither pays two tests.
        if (dfa.looking) return dfa_literal.scan(dfa, &dfa.literal.?, haystack, from, earliest);
        if (dfa.skips_from(state)) return dfa.scan_skipping(haystack, from, earliest, state);
        return dfa.scan_plain(haystack, from, earliest, state);
    }

    /// A forward scan that takes no claim: one entry of the table an octet. Inline, so that a
    /// scan of a short text makes no call more than it made before the claims.
    inline fn scan_plain(dfa: *Dfa, haystack: []const u8, from: usize, earliest: bool, first: u32) Scan {
        var state = first;
        var last: ?usize = null;
        var at = from;
        // Each turn takes the octets up to one whose entry is no plain row, and that octet, so the
        // turns are at most the octets from `from` and one.
        for (0..haystack.len - from + 1) |_| {
            switch (dfa_pairs.turn(dfa, haystack, &at, earliest, &state, &last)) {
                .done => |scan| return scan,
                .next => continue,
                .table => {},
            }
            at = dfa_run.plain(dfa.cache.table, &dfa.classes, haystack, at, &state);
            if (at == haystack.len) break;
            const octet = haystack[at];
            const entry = dfa.cache.table[state +% dfa.classes[octet]];
            const known = dfa.resolve(state, octet, entry, at) orelse return .gave_up;
            if (known & constants.dfa_match_flag != 0) last = at;
            if (known & constants.dfa_dead_flag != 0 or (earliest and last != null)) return Scan.of(last);
            state = known & constants.dfa_row_mask;
            at += 1;
            dfa.stay_past(haystack, &at, known, &last);
            if (dfa.take_matches(known & constants.dfa_match_flag != 0, haystack, &at, &state, &last)) |scan| return scan;
        }
        dfa.tally(haystack.len);
        if (dfa.matches_at_end(state, .edge)) last = haystack.len;
        return Scan.of(last);
    }

    /// A forward scan under claim R1: the state that waits for a match to start stays where it
    /// is over an octet that starts none, so the scan goes to the next octet that can. Claim R2
    /// takes a copy of the loop of its own, so that R1's loop holds no test of R2.
    inline fn scan_skipping(dfa: *Dfa, haystack: []const u8, from: usize, earliest: bool, first: u32) Scan {
        if (dfa.literal != null) return dfa.skip_loop_literal(haystack, from, earliest, first);
        // A window over a set holds its literals in `literals`, so the window goes first.
        if (dfa.window != null) return dfa_window.scan(dfa, haystack, from, earliest, first);
        if (dfa.literals != null) return dfa.skip_loop_literal_set(haystack, from, earliest, first);
        return dfa.skip_loop(.octet, haystack, from, earliest, first);
    }

    /// Claim R2's copy, out of line: a search with a literal makes few scans, and a scan of R1
    /// alone, which a text with many matches makes many of, inlines into its caller.
    noinline fn skip_loop_literal(dfa: *Dfa, haystack: []const u8, from: usize, earliest: bool, first: u32) Scan {
        return dfa.skip_loop(.literal, haystack, from, earliest, first);
    }

    /// Claim R5's copy, out of line as R2's is.
    noinline fn skip_loop_literal_set(dfa: *Dfa, haystack: []const u8, from: usize, earliest: bool, first: u32) Scan {
        return dfa.skip_loop(.literal_set, haystack, from, earliest, first);
    }

    pub inline fn skip_loop(dfa: *Dfa, comptime how: dfa_config.Pass, haystack: []const u8, from: usize, earliest: bool, first: u32) Scan {
        var state = first;
        var last: ?usize = null;
        const table = dfa.cache.table;
        const classes = &dfa.classes;
        var idle = dfa.idle;
        var index = from;
        while (index < haystack.len) {
            if (state == idle) {
                index = dfa_wait.pass(dfa, how, haystack, index);
                idle = dfa.idle;
                if (index == haystack.len) break;
            }
            const octet = haystack[index];
            // As in `scan_plain`, the sum of a row and a class cannot wrap.
            const entry = table[state +% classes[octet]];
            index += 1;
            if (entry < constants.dfa_flags_min) {
                state = entry;
                continue;
            }
            switch (dfa.settle(state, octet, entry, index - 1, earliest, &last)) {
                .done => |scan| return scan,
                .entry => |known| {
                    state = known & constants.dfa_row_mask;
                    dfa.stay_past(haystack, &index, known, &last);
                },
            }
            if (dfa.take_matches(last == index - 1, haystack, &index, &state, &last)) |scan| return scan;
            // The state just built may be the one that waits, and a cache that cleared gave it a
            // new row.
            idle = dfa.idle;
        }
        dfa.tally(haystack.len);
        if (dfa.matches_at_end(state, .edge)) last = haystack.len;
        return Scan.of(last);
    }

    /// What a forward scan does with an entry that is no plain state: the entry is built where
    /// the table does not hold it, a match that ended before the octet at `index` is kept in
    /// `last`, and the scan ends where no later octet can change its answer. Otherwise the
    /// entry, with its flags.
    inline fn settle(dfa: *Dfa, state: u32, octet: u8, entry: u32, index: usize, earliest: bool, last: *?usize) union(enum) { done: Scan, entry: u32 } {
        const known = dfa.resolve(state, octet, entry, index) orelse return .{ .done = .gave_up };
        if (known & constants.dfa_match_flag != 0) last.* = index;
        if (known & constants.dfa_dead_flag != 0 or (earliest and last.* != null)) return .{ .done = Scan.of(last.*) };
        return .{ .entry = known };
    }

    /// Claim R9: where the entry the scan read before `at` leads back to its state, the scan goes
    /// past the octets over which the state stays (dfa_stay.zig).
    pub inline fn stay_past(dfa: *Dfa, haystack: []const u8, at: *usize, known: u32, last: *?usize) void {
        if (known & constants.dfa_skip_flag != 0) at.* = dfa_stay.pass(dfa, haystack, at.*, known & constants.dfa_row_mask, known, last);
    }

    /// Where a match ended before the octet at `at - 1`, the octets from `at` whose entries are
    /// rows, in the loop of matches (dfa_run.zig). Only a scan that wants the last match takes
    /// it. The scan's answer where the entry that ended the run is dead.
    inline fn take_matches(dfa: *const Dfa, matched: bool, haystack: []const u8, at: *usize, state: *u32, last: *?usize) ?Scan {
        if (!matched) return null;
        assert(last.* == at.* - 1);
        var ended = at.* - 1;
        at.* = dfa_run.matched(dfa.cache.table, &dfa.classes, haystack, at.*, state, &ended);
        last.* = ended;
        if (at.* == haystack.len) return null;
        return dfa_run.end_of_run(dfa.cache.table, &dfa.classes, haystack, at.*, state.*, last.*, at.*);
    }

    /// The reverse scan, in a file of its own.
    pub const scan_reverse = dfa_reverse.scan;

    /// Adds the octets a scan took since its last count, which the cache weighs its states by.
    pub fn tally(dfa: *Dfa, index: usize) void {
        dfa.cache.scanned += if (index > dfa.mark) index - dfa.mark else dfa.mark - index;
        dfa.mark = index;
    }

    /// The entry of a state for an octet: the table's, or one built now. Null when the DFA gives
    /// up. Inline, so a scan that meets an entry the table holds makes no call: a short text
    /// that no pattern matches ends at such an entry.
    pub inline fn resolve(dfa: *Dfa, state: u32, octet: u8, entry: u32, index: usize) ?u32 {
        return if (entry != constants.dfa_unknown) entry else dfa.build_entry(state, octet, index);
    }

    /// Builds the entry of a state for an octet, which the table does not hold.
    fn build_entry(dfa: *Dfa, state: u32, octet: u8, index: usize) ?u32 {
        dfa.tally(index);
        const class = dfa.classes[octet];
        const clears = dfa.cache.clears;
        const built = dfa.build(state, class) orelse return null;
        // A cache that cleared while it kept the new state holds the old state no more.
        if (dfa.cache.clears == clears) dfa.cache.table[state + class] = built;
        return built;
    }

    /// The state a scan starts in, behind which stands an octet of `behind`'s context.
    pub inline fn start(dfa: *Dfa, behind: Context) ?u32 {
        const context: Context = if (dfa.has_looks) behind else .other;
        var row = dfa.cache.starts[@intFromEnum(context)];
        if (row == constants.dfa_unknown) {
            dfa.next.clear();
            row = dfa.cache.intern(@intFromEnum(context) | restart_bit, dfa.next.slice()) orelse return null;
            dfa.cache.starts[@intFromEnum(context)] = row;
            // Where the DFA knows the state that waits, it is this state, which the cache held
            // before the call: `build` forgets the state's row when the cache clears.
            assert(dfa.idle == constants.dfa_unknown or dfa.idle == row);
        }
        return row;
    }

    /// True when the scan that starts in `row` skips. Inline: the one test of `scan_forward`.
    inline fn skips_from(dfa: *Dfa, row: u32) bool {
        return dfa.may_skip and dfa_wait.waits(dfa, row);
    }

    /// The entry for one class of octets from a state: the state's threads, each given the
    /// class's octet.
    fn build(dfa: *Dfa, state: u32, class: u32) ?u32 {
        const octet = dfa.representatives[class];
        const head = dfa.cache.head(state);
        // No match starts before a continuation octet of UTF-8, as in the matcher. The reverse
        // program starts where a match ends, which is after any octet.
        const may_start = dfa.config.kind == .longest or dfa.encoding.may_start_at(octet);
        const matched = dfa.close(state, dfa.context_of(octet), may_start);
        dfa.step(octet);
        var flags: u32 = if (matched) constants.dfa_match_flag else 0;
        const restart = head & restart_bit != 0 and head & second_bit == 0 and dfa.restarts_after(matched);
        if (dfa.next.len == 0 and !restart) return constants.dfa_dead_flag | flags;
        // Claim R3: no thread, and a match may start; the scan goes to the literal from here. Under
        // `Kind.first` a match ends the restart, so such a state follows no match: the scan loses none.
        if (dfa.next.len == 0 and dfa.looking) {
            assert(!matched);
            flags |= constants.dfa_skip_flag;
        }
        const next_head = @intFromEnum(dfa.context_of(octet)) | (if (restart) @as(u32, restart_bit) else 0);
        const clears = dfa.cache.clears;
        const interned = dfa.cache.intern(next_head, dfa.next.slice());
        // A cache that cleared holds no state under its old row, also where it then gave up.
        if (dfa.cache.clears != clears) dfa.idle = constants.dfa_unknown;
        const row = interned orelse return null;
        // Claim R9: the state stays where it is over the class's octets.
        if (dfa_stay.marks(dfa, state, row, clears)) flags |= constants.dfa_skip_flag;
        // The state with no thread that may still start a match is the one that waits.
        if (dfa.next.len == 0 and dfa_wait.skips(dfa) and dfa.skip_known) dfa.idle = row;
        return row | flags;
    }

    /// What an octet is to an assertion. A program with no assertion reads none, so its states
    /// keep one context and are fewer.
    pub fn context_of(dfa: *const Dfa, octet: u8) Context {
        return if (dfa.has_looks) Context.of(octet) else .other;
    }

    /// True when a match may still start after a state whose threads did or did not match. Under
    /// `Kind.first` no match starts after one was found, as in the matcher.
    fn restarts_after(dfa: *const Dfa, matched: bool) bool {
        return !dfa.config.anchored and !(matched and dfa.config.kind == .first);
    }

    /// Gives an octet to each thread, in order. The instructions that take it are the next state.
    pub fn step(dfa: *Dfa, octet: u8) void {
        dfa.next.clear();
        for (dfa.threads[0..dfa.threads_len]) |index| {
            if (program_file.step(dfa.instructions, index, octet)) |next| _ = dfa.next.insert(next);
        }
    }

    /// True when a state matches where the scan stops, with an octet of `ahead`'s context, or
    /// none, after it.
    /// Inline: each scan that reaches the text's end reads it, and a text of a line makes a scan
    /// of each line. Its entry is built out of line.
    pub inline fn matches_at_end(dfa: *Dfa, state: u32, ahead: Context) bool {
        const column = state + dfa.class_count + @intFromEnum(ahead);
        const known = dfa.cache.table[column];
        if (known != constants.dfa_unknown) return known & constants.dfa_match_flag != 0;
        return dfa.build_end(state, ahead, column);
    }

    fn build_end(dfa: *Dfa, state: u32, ahead: Context, column: u32) bool {
        const matched = dfa.close(state, ahead, true);
        dfa.cache.table[column] = constants.dfa_dead_flag | (if (matched) @as(u32, constants.dfa_match_flag) else 0);
        return matched;
    }

    /// Builds a state's threads (dfa_close.zig).
    pub const close = dfa_close.close;
};

test {
    _ = @import("dfa_cache.zig");
    _ = @import("dfa_close.zig");
    _ = @import("dfa_node_set.zig");
    _ = @import("dfa_init.zig");
    _ = @import("dfa_skip.zig");
    _ = @import("dfa_suffix.zig");
    _ = @import("dfa_wait.zig");
    _ = @import("dfa_length.zig");
    _ = @import("dfa_inner.zig");
    _ = @import("dfa_window_set.zig");
    _ = @import("dfa_second.zig");
}
