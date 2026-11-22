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
const SparseSet = @import("../sparse_set.zig").SparseSet;
const Cache = @import("dfa_cache.zig").Cache;
const Skip = @import("dfa_skip.zig").Skip;
const Literal = @import("../literal.zig").Literal;
const dfa_literal = @import("dfa_literal.zig");
const dfa_reverse = @import("dfa_reverse.zig");
const is_continuation = @import("../utf8_ranges.zig").is_continuation;

const dfa_config = @import("dfa_config.zig");
pub const Kind = dfa_config.Kind;
pub const Config = dfa_config.Config;
pub const Scan = dfa_config.Scan;

/// The lists a DFA builds a state with, each as long as the program: two sets of two lists, the
/// threads and the stack.
const lists_len = 6;

/// The bit of a record's first word that says a match may still start at the state.
const restart_bit = 1 << constants.context_bits;
const context_mask = restart_bit - 1;

pub const Dfa = struct {
    instructions: []const Instruction,
    config: Config,
    has_looks: bool,
    /// True when claim R1 is on and one state waits for a match to start whatever octet stands
    /// behind it. A program with an assertion has one such state for each context, so it has
    /// no skip.
    may_skip: bool,
    classes: [constants.octet_values]u8,
    /// One octet of each class, which stands for the class when a state is built.
    representatives: [constants.octet_values]u8,
    class_count: u32,
    cache: Cache,
    /// The instructions the state being built passed through.
    visited: SparseSet,
    /// The instructions the state being built leads to, in order of preference.
    next: SparseSet,
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
    /// Claim R3: the program holds an assertion and `literal`, and the scan goes to the literal
    /// from each state with no thread, which `build` marks with `dfa_idle_flag`.
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

    /// The words of memory a DFA needs before its cache holds `dfa_states_min` states.
    pub fn memory_len_min(program: *const Program) usize {
        return scratch_len(program) + Cache.memory_len(constants.dfa_states_min, stride_of(program));
    }

    fn scratch_len(program: *const Program) usize {
        return lists_len * program.instructions.len + 1;
    }

    /// A row of the table: one entry for each class of octets, and one for each context the text
    /// can end in.
    fn stride_of(program: *const Program) u32 {
        return @as(u32, program.class_count) + constants.context_count;
    }

    /// Readies a DFA in `memory`. False when the memory is under `memory_len_min`, and the DFA
    /// must not be used.
    pub fn init(dfa: *Dfa, program: *const Program, config: Config, memory: []u32) bool {
        if (memory.len < memory_len_min(program)) return false;
        assert(!config.skip or (config.kind == .first and !config.anchored));
        assert(!config.literal or config.skip);
        const len = program.instructions.len;
        var rest = memory;
        dfa.* = .{
            .instructions = program.instructions,
            .config = config,
            .has_looks = program.has_looks,
            .may_skip = config.skip and !program.has_looks,
            .classes = program.classes,
            .representatives = undefined,
            .class_count = program.class_count,
            .visited = SparseSet.init(take(&rest, len), take(&rest, len)),
            .next = SparseSet.init(take(&rest, len), take(&rest, len)),
            .threads = take(&rest, len),
            .threads_len = 0,
            .stack = take(&rest, len + 1),
            .stack_len = 0,
            .reached = false,
            .mark = 0,
            .skip = undefined,
            .literal = if (config.literal and config.skip) Literal.of(program, program.has_looks) else null,
            .looking = false,
            .skip_known = false,
            .idle = constants.dfa_unknown,
            .skip_visits = 0,
            .skip_octets = 0,
            .skip_off = false,
            .skip_retry_at = 0,
            .skip_poor_trials = 0,
            .cache = undefined,
        };
        for (0..constants.octet_values) |octet| {
            const reversed: u8 = @intCast(constants.octet_max - octet);
            dfa.representatives[dfa.classes[reversed]] = reversed;
        }
        dfa.looking = program.has_looks and dfa.literal != null;
        dfa.cache.init(rest, stride_of(program));
        return true;
    }

    pub fn looks_for_literal(dfa: *const Dfa) bool {
        return dfa.looking;
    }

    /// The offset where the forward program's match from `from` ends, as the matcher finds it, or
    /// with `earliest` the first offset where any match ends.
    pub fn scan_forward(dfa: *Dfa, haystack: []const u8, from: usize, earliest: bool) Scan {
        assert(from <= haystack.len);
        const behind: Context = if (from == 0) .edge else Context.of(haystack[from - 1]);
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
        // The table and the classes stay where they are while a scan runs, so the loop reads them
        // through locals: a store through `dfa` then reloads neither.
        const table = dfa.cache.table;
        const classes = &dfa.classes;
        // The loop counts the octets it took, and only the slow path adds them to `from`: an offset
        // kept beside them costs an add and its overflow check an octet.
        for (haystack[from..], 0..) |octet, taken| {
            // A row is under the table's length less a stride, and a class under the stride, so
            // the sum cannot wrap, and the read's bounds check holds it.
            const entry = table[state +% classes[octet]];
            if (entry < constants.dfa_dead_flag) {
                state = entry;
                continue;
            }
            const index = from + taken;
            const known = dfa.resolve(state, octet, entry, index) orelse return .gave_up;
            if (known & constants.dfa_match_flag != 0) last = index;
            if (known & constants.dfa_dead_flag != 0 or (earliest and last != null)) return Scan.of(last);
            state = known & constants.dfa_row_mask;
        }
        dfa.tally(haystack.len);
        if (dfa.matches_at_end(state, .edge)) last = haystack.len;
        return Scan.of(last);
    }

    /// A forward scan under claim R1: the state that waits for a match to start stays where it
    /// is over an octet that starts none, so the scan goes to the next octet that can. Claim R2
    /// takes a copy of the loop of its own, so that R1's loop holds no test of R2.
    noinline fn scan_skipping(dfa: *Dfa, haystack: []const u8, from: usize, earliest: bool, first: u32) Scan {
        if (dfa.literal != null) return dfa.skip_loop(true, haystack, from, earliest, first);
        return dfa.skip_loop(false, haystack, from, earliest, first);
    }

    fn skip_loop(dfa: *Dfa, comptime by_literal: bool, haystack: []const u8, from: usize, earliest: bool, first: u32) Scan {
        var state = first;
        var last: ?usize = null;
        const table = dfa.cache.table;
        const classes = &dfa.classes;
        var idle = dfa.idle;
        var index = from;
        while (index < haystack.len) {
            if (state == idle) {
                index = dfa.pass(by_literal, haystack, index);
                idle = dfa.idle;
                if (index == haystack.len) break;
            }
            const octet = haystack[index];
            // As in `scan_plain`, the sum of a row and a class cannot wrap.
            const entry = table[state +% classes[octet]];
            index += 1;
            if (entry < constants.dfa_dead_flag) {
                state = entry;
                continue;
            }
            switch (dfa.settle(state, octet, entry, index - 1, earliest, &last)) {
                .done => |scan| return scan,
                .state => |row| state = row,
            }
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
    /// `last`, and the scan ends where no later octet can change its answer.
    fn settle(dfa: *Dfa, state: u32, octet: u8, entry: u32, index: usize, earliest: bool, last: *?usize) union(enum) { done: Scan, state: u32 } {
        const known = dfa.resolve(state, octet, entry, index) orelse return .{ .done = .gave_up };
        if (known & constants.dfa_match_flag != 0) last.* = index;
        if (known & constants.dfa_dead_flag != 0 or (earliest and last.* != null)) return .{ .done = Scan.of(last.*) };
        return .{ .state = known & constants.dfa_row_mask };
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
    pub fn start(dfa: *Dfa, behind: Context) ?u32 {
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
        return dfa.may_skip and dfa.waits(row);
    }

    /// Readies the skip where a scan starts in `row`: it ends a rest that is over, and takes
    /// `row` as the state that waits where the DFA knows none. True when the scan skips.
    fn waits(dfa: *Dfa, row: u32) bool {
        assert(dfa.may_skip);
        if (dfa.skip_off and dfa.cache.scanned >= dfa.skip_retry_at) dfa.skip_off = false;
        if (!dfa.skips()) return false;
        if (dfa.idle == constants.dfa_unknown) dfa.wait_at(row);
        assert(dfa.idle == row);
        return true;
    }

    /// True when a scan may skip: `may_skip`, and the skip is not resting.
    fn skips(dfa: *const Dfa) bool {
        return dfa.may_skip and !dfa.skip_off;
    }

    /// A visit of a scan to the state that waits, at an octet of the haystack: the offset of the
    /// next octet that can start a match, which is `from` where its own octet can. With
    /// `by_literal`, the next place of the literal (claim R2).
    fn pass(dfa: *Dfa, comptime by_literal: bool, haystack: []const u8, from: usize) usize {
        var index = from;
        if (by_literal) {
            index = dfa.literal.?.find(haystack, from) orelse haystack.len;
        } else if (!dfa.skip.starts[haystack[from]]) index = dfa.skip.next(haystack, from + 1);
        dfa.skip_octets += index - from;
        dfa.skip_visits += 1;
        if (dfa.skip_visits == constants.skip_trial_visits) dfa.judge_skip();
        return index;
    }

    /// Turns the skip off where its visits passed too few octets to pay for themselves, until
    /// the scans took `skip_rest_octets` more octets.
    fn judge_skip(dfa: *Dfa) void {
        const poor = dfa.skip_octets < @as(u64, dfa.skip_visits) * constants.skip_octets_per_visit_min;
        dfa.skip_visits = 0;
        dfa.skip_octets = 0;
        if (!poor) {
            dfa.skip_poor_trials = 0;
            return;
        }
        dfa.skip_off = true;
        dfa.skip_retry_at = dfa.cache.scanned + (@as(u64, constants.skip_rest_octets) << dfa.skip_poor_trials);
        dfa.skip_poor_trials = @min(dfa.skip_poor_trials + 1, constants.skip_rest_doublings_max);
        dfa.idle = constants.dfa_unknown;
    }

    /// Takes `row` as the state that waits for a match to start, and learns once which octets
    /// can start one: those the state does not answer by staying where it is.
    fn wait_at(dfa: *Dfa, row: u32) void {
        if (!dfa.skip_known) {
            var class_starts: [constants.octet_values]bool = undefined;
            for (0..dfa.class_count) |class| {
                const octet = dfa.representatives[class];
                const matched = dfa.close(row, dfa.context_of(octet), !is_continuation(octet));
                dfa.step(octet);
                class_starts[class] = matched or dfa.next.len != 0;
            }
            var starts: [constants.octet_values]bool = undefined;
            for (&starts, dfa.classes) |*start_here, class| start_here.* = class_starts[class];
            dfa.skip = Skip.init(&starts);
            dfa.skip_known = true;
        }
        dfa.idle = row;
    }

    /// The entry for one class of octets from a state: the state's threads, each given the
    /// class's octet.
    fn build(dfa: *Dfa, state: u32, class: u32) ?u32 {
        const octet = dfa.representatives[class];
        const head = dfa.cache.head(state);
        // No match starts before a continuation octet of UTF-8, as in the matcher. The reverse
        // program starts where a match ends, which is after any octet.
        const may_start = dfa.config.kind == .longest or !is_continuation(octet);
        const matched = dfa.close(state, dfa.context_of(octet), may_start);
        dfa.step(octet);
        var flags: u32 = if (matched) constants.dfa_match_flag else 0;
        const restart = head & restart_bit != 0 and dfa.restarts_after(matched);
        if (dfa.next.len == 0 and !restart) return constants.dfa_dead_flag | flags;
        // Claim R3: no thread, and a match may start; the scan goes to the literal from here. Under
        // `Kind.first` a match ends the restart, so such a state follows no match: the scan loses none.
        if (dfa.next.len == 0 and dfa.looking) {
            assert(!matched);
            flags |= constants.dfa_idle_flag;
        }
        const next_head = @intFromEnum(dfa.context_of(octet)) | (if (restart) @as(u32, restart_bit) else 0);
        const clears = dfa.cache.clears;
        const interned = dfa.cache.intern(next_head, dfa.next.slice());
        // A cache that cleared holds no state under its old row, also where it then gave up.
        if (dfa.cache.clears != clears) dfa.idle = constants.dfa_unknown;
        const row = interned orelse return null;
        // The state with no thread that may still start a match is the one that waits.
        if (dfa.next.len == 0 and dfa.skips() and dfa.skip_known) dfa.idle = row;
        return row | flags;
    }

    /// What an octet is to an assertion. A program with no assertion reads none, so its states
    /// keep one context and are fewer.
    fn context_of(dfa: *const Dfa, octet: u8) Context {
        return if (dfa.has_looks) Context.of(octet) else .other;
    }

    /// True when a match may still start after a state whose threads did or did not match. Under
    /// `Kind.first` no match starts after one was found, as in the matcher.
    fn restarts_after(dfa: *const Dfa, matched: bool) bool {
        return !dfa.config.anchored and !(matched and dfa.config.kind == .first);
    }

    /// Gives an octet to each thread, in order. The instructions that take it are the next state.
    fn step(dfa: *Dfa, octet: u8) void {
        dfa.next.clear();
        for (dfa.threads[0..dfa.threads_len]) |index| {
            const instruction = dfa.instructions[index];
            if (instruction.takes(octet)) _ = dfa.next.insert(instruction.out);
        }
    }

    /// True when a state matches where the scan stops, with an octet of `ahead`'s context, or
    /// none, after it.
    pub fn matches_at_end(dfa: *Dfa, state: u32, ahead: Context) bool {
        const column = state + dfa.class_count + @intFromEnum(ahead);
        const known = dfa.cache.table[column];
        if (known != constants.dfa_unknown) return known & constants.dfa_match_flag != 0;
        const matched = dfa.close(state, ahead, true);
        dfa.cache.table[column] = constants.dfa_dead_flag | (if (matched) @as(u32, constants.dfa_match_flag) else 0);
        return matched;
    }

    /// Builds a state's threads, as `Matcher.close` does, with no slot. True when a thread reached
    /// `match`; under `Kind.first` the build ends there.
    fn close(dfa: *Dfa, state: u32, ahead: Context, may_start: bool) bool {
        const head = dfa.cache.head(state);
        const behind: Context = @enumFromInt(head & context_mask);
        dfa.visited.clear();
        dfa.threads_len = 0;
        dfa.reached = false;
        for (dfa.cache.seeds(state)) |seed| {
            dfa.follow(seed, behind, ahead);
            if (dfa.reached and dfa.config.kind == .first) return true;
        }
        if (head & restart_bit != 0 and may_start) dfa.follow(dfa.config.entry, behind, ahead);
        return dfa.reached;
    }

    fn follow(dfa: *Dfa, seed: u32, behind: Context, ahead: Context) void {
        assert(dfa.stack_len == 0);
        dfa.stack[0] = seed;
        dfa.stack_len = 1;
        while (dfa.stack_len > 0) {
            assert(dfa.stack_len <= constants.instructions_max);
            dfa.stack_len -= 1;
            var path: ?u32 = dfa.stack[dfa.stack_len];
            while (path) |index| path = dfa.visit(index, behind, ahead);
            if (dfa.reached and dfa.config.kind == .first) {
                dfa.stack_len = 0;
                return;
            }
        }
    }

    fn visit(dfa: *Dfa, index: u32, behind: Context, ahead: Context) ?u32 {
        if (!dfa.visited.insert(index)) return null;
        const instruction = dfa.instructions[index];
        switch (instruction.kind) {
            .jump, .save => return instruction.out,
            .split => {
                dfa.stack[dfa.stack_len] = instruction.arg;
                dfa.stack_len += 1;
                return instruction.out;
            },
            .look => return if (instruction.look.holds(behind, ahead)) instruction.out else null,
            .range => {
                dfa.threads[dfa.threads_len] = index;
                dfa.threads_len += 1;
                return null;
            },
            .match => {
                dfa.reached = true;
                return null;
            },
            .fail => return null,
        }
    }
};

fn take(memory: *[]u32, len: usize) []u32 {
    const taken = memory.*[0..len];
    memory.* = memory.*[len..];
    return taken;
}

test {
    _ = @import("dfa_cache.zig");
    _ = @import("dfa_skip.zig");
    _ = @import("dfa_suffix.zig");
}
