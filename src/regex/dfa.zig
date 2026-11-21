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
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Program = program_file.Program;
const Instruction = program_file.Instruction;
const Context = program_file.Context;
const SparseSet = @import("sparse_set.zig").SparseSet;
const Cache = @import("dfa_cache.zig").Cache;
const is_continuation = @import("utf8_ranges.zig").is_continuation;

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
};

/// What a scan found: the offset its last match ended at in the scan's direction, none, or
/// nothing, because the cache thrashed.
pub const Scan = union(enum) {
    gave_up,
    none,
    found: usize,

    fn of(last: ?usize) Scan {
        return if (last) |offset| .{ .found = offset } else .none;
    }
};

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
        const len = program.instructions.len;
        var rest = memory;
        dfa.* = .{
            .instructions = program.instructions,
            .config = config,
            .has_looks = program.has_looks,
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
            .cache = undefined,
        };
        for (0..constants.octet_values) |octet| {
            const reversed: u8 = @intCast(constants.octet_max - octet);
            dfa.representatives[dfa.classes[reversed]] = reversed;
        }
        dfa.cache.init(rest, stride_of(program));
        return true;
    }

    /// The offset where the forward program's match from `from` ends, as the matcher finds it, or
    /// with `earliest` the first offset where any match ends.
    pub fn scan_forward(dfa: *Dfa, haystack: []const u8, from: usize, earliest: bool) Scan {
        assert(from <= haystack.len);
        const behind: Context = if (from == 0) .edge else Context.of(haystack[from - 1]);
        var state = dfa.start(behind) orelse return .gave_up;
        var last: ?usize = null;
        dfa.mark = from;
        // The table and the classes stay where they are while a scan runs, so the loop reads them
        // through locals: a store through `dfa` then reloads neither.
        const table = dfa.cache.table;
        const classes = &dfa.classes;
        for (haystack[from..], from..) |octet, index| {
            const entry = table[state + classes[octet]];
            if (entry < constants.dfa_dead_flag) {
                state = entry;
                continue;
            }
            const known = dfa.resolve(state, octet, entry, index) orelse return .gave_up;
            if (known & constants.dfa_match_flag != 0) last = index;
            if (known & constants.dfa_dead_flag != 0 or (earliest and last != null)) return Scan.of(last);
            state = known & constants.dfa_row_mask;
        }
        dfa.tally(haystack.len);
        if (dfa.matches_at_end(state, .edge)) last = haystack.len;
        return Scan.of(last);
    }

    /// The least offset at or after `from` where a match that ends at `end` starts. The DFA runs
    /// the reverse program from `end` toward `from`.
    pub fn scan_reverse(dfa: *Dfa, haystack: []const u8, from: usize, end: usize) Scan {
        assert(from <= end and end <= haystack.len);
        const behind: Context = if (end == haystack.len) .edge else Context.of(haystack[end]);
        var state = dfa.start(behind) orelse return .gave_up;
        var last: ?usize = null;
        dfa.mark = end;
        const table = dfa.cache.table;
        const classes = &dfa.classes;
        var index = end;
        while (index > from) {
            index -= 1;
            const octet = haystack[index];
            const entry = table[state + classes[octet]];
            if (entry < constants.dfa_dead_flag) {
                state = entry;
                continue;
            }
            const known = dfa.resolve(state, octet, entry, index) orelse return .gave_up;
            if (known & constants.dfa_match_flag != 0) last = index + 1;
            if (known & constants.dfa_dead_flag != 0) return Scan.of(last);
            state = known & constants.dfa_row_mask;
        }
        dfa.tally(from);
        const ahead: Context = if (from == 0) .edge else Context.of(haystack[from - 1]);
        if (dfa.matches_at_end(state, ahead)) last = from;
        return Scan.of(last);
    }

    /// Adds the octets a scan took since its last count, which the cache weighs its states by.
    fn tally(dfa: *Dfa, index: usize) void {
        dfa.cache.scanned += if (index > dfa.mark) index - dfa.mark else dfa.mark - index;
        dfa.mark = index;
    }

    /// The entry of a state for an octet, built when the table does not hold it. Null when the
    /// DFA gives up.
    fn resolve(dfa: *Dfa, state: u32, octet: u8, entry: u32, index: usize) ?u32 {
        if (entry != constants.dfa_unknown) return entry;
        dfa.tally(index);
        const class = dfa.classes[octet];
        const clears = dfa.cache.clears;
        const built = dfa.build(state, class) orelse return null;
        // A cache that cleared while it kept the new state holds the old state no more.
        if (dfa.cache.clears == clears) dfa.cache.table[state + class] = built;
        return built;
    }

    /// The state a scan starts in, behind which stands an octet of `behind`'s context.
    fn start(dfa: *Dfa, behind: Context) ?u32 {
        const context: Context = if (dfa.has_looks) behind else .other;
        const known = dfa.cache.starts[@intFromEnum(context)];
        if (known != constants.dfa_unknown) return known;
        dfa.next.clear();
        const row = dfa.cache.intern(@intFromEnum(context) | restart_bit, dfa.next.slice()) orelse return null;
        dfa.cache.starts[@intFromEnum(context)] = row;
        return row;
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
        const flags: u32 = if (matched) constants.dfa_match_flag else 0;
        const restart = head & restart_bit != 0 and dfa.restarts_after(matched);
        if (dfa.next.len == 0 and !restart) return constants.dfa_dead_flag | flags;
        const next_head = @intFromEnum(dfa.context_of(octet)) | (if (restart) @as(u32, restart_bit) else 0);
        const row = dfa.cache.intern(next_head, dfa.next.slice()) orelse return null;
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
    fn matches_at_end(dfa: *Dfa, state: u32, ahead: Context) bool {
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
}
