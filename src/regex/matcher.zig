//! `Matcher`: a program run over a text that arrives in pieces (decision 86).
//!
//! This is Pike's simulation of Thompson's automaton. A thread is an instruction and the capture
//! slots that led to it. The matcher holds every thread that can still match, in the order a
//! backtracking matcher would try them, and takes each octet once for all of them. A list holds
//! an instruction once, so a list holds at most the program's instructions, and an octet costs at
//! most that many steps: time linear in the text for any pattern.
//!
//! The match is the one a backtracking matcher finds first, RE2's leftmost-first: it starts at the
//! first octet where any match starts, and a thread that matches ends every thread after it in
//! the order.
//!
//! No match starts before a continuation octet of UTF-8. A program takes whole sequences alone,
//! so only an empty match could start there, and it would cut a scalar value in two.
//!
//! The matcher is the module's reference: `Searcher`'s faster paths must give what it gives.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Program = program_file.Program;
const Context = program_file.Context;
const SparseSet = @import("sparse_set.zig").SparseSet;
const is_continuation = @import("utf8_ranges.zig").is_continuation;
const work_file = @import("work.zig");

/// What the caller says about the input of one call.
pub const Piece = enum {
    /// More of the text follows this input.
    more,
    /// The text ends where this input ends.
    last,
};

pub const Status = enum {
    /// The call took all of its input, and the search is not decided.
    needs_input,
    /// The search found its match, which `span` and `group` give.
    match,
    /// The text holds no match.
    no_match,
};

/// What one call did.
pub const Step = struct {
    /// Octets of the input taken. A search that ends takes no octet past the one that decided it.
    consumed: usize,
    status: Status,
};

/// A part of the text, by the offsets of its first octet and of the octet after its last.
pub const Span = struct {
    start: u64,
    end: u64,

    pub fn len(span: Span) u64 {
        return span.end - span.start;
    }

    /// The octets of the span, in a haystack whose first octet has offset 0.
    pub fn slice(span: Span, haystack: []const u8) []const u8 {
        return haystack[@intCast(span.start)..@intCast(span.end)];
    }
};

/// The slots a matcher keeps for each thread. Each thread copies its slots as it moves, so fewer
/// slots cost less.
pub const Captures = enum {
    /// No offset: the search says only whether the text holds a match, and ends at the first one.
    none,
    /// The whole match.
    span,
    /// The whole match and every capture group.
    groups,
};

pub const Options = struct {
    /// Whether a match must start at the search's first octet.
    anchored: bool = false,
    captures: Captures = .span,
};

/// How far a position's threads are built. The seeds' threads need no octet of the text the
/// program does not read, so a match they reach is known at once. A thread that starts at the
/// position waits for the position's octet, which says whether a match may start there.
const Closed = enum(u8) { none, seeds, all };

/// The bit of a stack entry that says it restores a slot, and the bits that name the slot. An
/// entry without the bit names an instruction to visit.
const restore_flag = constants.hole_flag;
const restore_mask = constants.hole_none;

/// The lists of instruction indexes a matcher keeps: two sets of two lists each, the threads and
/// the stack.
const lists_len = 6;

/// The tables of slots a matcher keeps, one row for each instruction: the seeds' and the threads'.
const slot_tables = 2;

/// The rows of slots beside the tables: the thread being followed, and the best match.
const slot_rows = 2;

/// The instruction indexes one word of memory holds.
const indexes_per_word = @sizeOf(u64) / @sizeOf(u32);

pub const Matcher = struct {
    program: Program,
    options: Options,
    /// The slots each thread keeps, and the most the matcher's memory has room for.
    slots_len: u32,
    slots_max: u32,
    /// The instructions to start from at the position, in order of preference, before any
    /// assertion at the position is judged.
    seeds: SparseSet,
    /// Every instruction the position's threads passed through.
    visited: SparseSet,
    /// The instructions that wait for the position's octet, in order of preference.
    threads: []u32,
    threads_len: u32,
    stack: []u32,
    stack_values: []u64,
    stack_len: u32,
    seed_slots: []u64,
    thread_slots: []u64,
    /// Two rows of `slots_max` slots: the thread being followed, then the best match so far.
    rows: []u64,
    /// The offset of the next octet.
    position: u64,
    behind: Context,
    /// True while a match may still start at the position.
    restart: bool,
    matched: bool,
    /// How far the position's threads are built.
    closed: Closed,
    finished: bool,
    /// Invariant 18's count, which a test build keeps.
    work: work_file.Work,

    /// The words of memory a matcher needs for a program of `instructions_len` forward
    /// instructions and `slots_len` slots a thread.
    pub fn memory_len(instructions_len: u32, slots_len: u32) usize {
        const count: usize = instructions_len;
        const narrow = lists_len * count + 1;
        const wide = slot_tables * count * slots_len + slot_rows * slots_len + count + 1;
        return wide + (narrow + indexes_per_word - 1) / indexes_per_word;
    }

    /// The slots a thread keeps under `captures`.
    pub fn slots_of(program: *const Program, captures: Captures) u32 {
        return switch (captures) {
            .none => 0,
            .span => constants.group_slots,
            .groups => program.slot_count(),
        };
    }

    /// Readies a matcher for `program`, at the start of a text. The memory is the matcher's until
    /// the caller is done with it, and holds at least `memory_len` words.
    pub fn init(matcher: *Matcher, program: *const Program, options: Options, memory: []u64) void {
        const count: usize = program.forward_len;
        const slots_len = slots_of(program, options.captures);
        assert(count > 0 and count <= constants.instructions_max);
        assert(memory.len >= memory_len(program.forward_len, slots_len));
        var wide = memory;
        const seed_slots = take(&wide, count * slots_len);
        const thread_slots = take(&wide, count * slots_len);
        const rows = take(&wide, slot_rows * slots_len);
        const stack_values = take(&wide, count + 1);
        var narrow: []u32 = std.mem.bytesAsSlice(u32, std.mem.sliceAsBytes(wide));
        matcher.* = .{
            .program = program.*,
            .options = options,
            .slots_len = slots_len,
            .slots_max = slots_len,
            .seeds = SparseSet.init(take(&narrow, count), take(&narrow, count)),
            .visited = SparseSet.init(take(&narrow, count), take(&narrow, count)),
            .threads = take(&narrow, count),
            .threads_len = 0,
            .stack = take(&narrow, count + 1),
            .stack_values = stack_values,
            .stack_len = 0,
            .seed_slots = seed_slots,
            .thread_slots = thread_slots,
            .rows = rows,
            .position = 0,
            .behind = .edge,
            .restart = true,
            .matched = false,
            .closed = .none,
            .finished = false,
            .work = work_file.zero,
        };
    }

    /// Changes what the next searches do. The slots they keep must fit the memory `init` took,
    /// which holds the slots of the options it was given.
    pub fn configure(matcher: *Matcher, options: Options) void {
        const slots_len = slots_of(&matcher.program, options.captures);
        assert(slots_len <= matcher.slots_max);
        matcher.options = options;
        matcher.slots_len = slots_len;
    }

    /// The slots of the thread being followed.
    fn current(matcher: *const Matcher) []u64 {
        return matcher.rows[0..matcher.slots_len];
    }

    /// The slots of the best match so far.
    fn best(matcher: *const Matcher) []u64 {
        return matcher.rows[matcher.slots_max..][0..matcher.slots_len];
    }

    /// Starts a new search. `behind` is the octet before the search's first, or null when the
    /// text starts there, and `offset` is the first octet's offset, which every span counts from.
    pub fn start(matcher: *Matcher, behind: ?u8, offset: u64) void {
        matcher.seeds.clear();
        matcher.threads_len = 0;
        matcher.position = offset;
        matcher.behind = if (behind) |octet| Context.of(octet) else .edge;
        matcher.restart = true;
        matcher.matched = false;
        matcher.closed = .none;
        matcher.finished = false;
    }

    /// Takes the next piece of the text. The search ends with `match` or `no_match`, and a caller
    /// then reads `span` or calls `start`.
    pub fn search(matcher: *Matcher, input: []const u8, piece: Piece) Step {
        assert(!matcher.finished);
        var index: usize = 0;
        while (index <= input.len) : (index += 1) {
            if (matcher.closed != .all) {
                if (!matcher.close(input, index, piece)) break;
                if (matcher.decided()) return matcher.finish(index);
            }
            if (index == input.len) break;
            matcher.step(input[index]);
        }
        assert(index == input.len);
        if (piece == .last) return matcher.finish(index);
        return .{ .consumed = index, .status = .needs_input };
    }

    /// The whole match of a search that ended with `match`, or null under `Captures.none`.
    pub fn span(matcher: *const Matcher) ?Span {
        return matcher.group(0);
    }

    /// The part of the text a capture group matched, or null when the group took no part in the
    /// match or the matcher kept no slot for it.
    pub fn group(matcher: *const Matcher, index: u32) ?Span {
        assert(matcher.finished and matcher.matched);
        const first = index * constants.group_slots;
        if (first + 1 >= matcher.slots_len) return null;
        const found = matcher.best();
        if (found[first] == constants.slot_unset or found[first + 1] == constants.slot_unset) return null;
        assert(found[first] <= found[first + 1]);
        return .{ .start = found[first], .end = found[first + 1] };
    }

    /// The first match at or after `from` in a text that is all in `haystack`, or null.
    pub fn find(matcher: *Matcher, haystack: []const u8, from: usize) ?Span {
        assert(from <= haystack.len);
        matcher.start(if (from == 0) null else haystack[from - 1], from);
        const end = matcher.search(haystack[from..], .last);
        assert(end.status != .needs_input);
        return if (end.status == .match) matcher.span() else null;
    }

    /// What the octet after the position is to an assertion, or null when the matcher must wait
    /// for it. A program with no assertion that reads ahead waits for nothing.
    fn ahead(matcher: *const Matcher, input: []const u8, index: usize, piece: Piece) ?Context {
        if (index < input.len) return Context.of(input[index]);
        if (piece == .last) return .edge;
        return if (matcher.program.reads_ahead) null else .other;
    }

    /// True when no thread waits for an octet and none can start: the search is over.
    fn decided(matcher: *const Matcher) bool {
        if (matcher.matched and matcher.slots_len == 0) return true;
        return matcher.threads_len == 0 and (matcher.matched or !matcher.restart);
    }

    fn finish(matcher: *Matcher, consumed: usize) Step {
        assert(matcher.closed == .all);
        matcher.finished = true;
        return .{ .consumed = consumed, .status = if (matcher.matched) .match else .no_match };
    }

    fn slots(matcher: *const Matcher, table: []u64, index: u32) []u64 {
        return table[index * matcher.slots_len ..][0..matcher.slots_len];
    }

    /// Builds the position's threads: from each seed in order, then from the program's start
    /// while a match may still start here. False when the build must wait for the next octet.
    fn close(matcher: *Matcher, input: []const u8, index: usize, piece: Piece) bool {
        if (matcher.closed == .none) {
            const context = matcher.ahead(input, index, piece) orelse return false;
            matcher.close_seeds(context);
        }
        if (matcher.restart) {
            if (index == input.len and piece == .more) return false;
            const context: Context = if (index < input.len) Context.of(input[index]) else .edge;
            if (index == input.len or !is_continuation(input[index])) matcher.close_start(context);
            matcher.restart = matcher.restart and !matcher.options.anchored;
        }
        matcher.closed = .all;
        return true;
    }

    /// The threads of the seeds. A thread that reaches `match` ends the build, because every
    /// thread after it is one a backtracking matcher would not try.
    fn close_seeds(matcher: *Matcher, ahead_context: Context) void {
        assert(matcher.closed == .none);
        matcher.visited.clear();
        matcher.threads_len = 0;
        for (matcher.seeds.slice()) |seed| {
            @memcpy(matcher.current(), matcher.slots(matcher.seed_slots, seed));
            if (matcher.follow(seed, ahead_context)) break;
        }
        matcher.take_match();
        matcher.closed = .seeds;
    }

    /// The threads of a match that starts at the position, after every seed's.
    fn close_start(matcher: *Matcher, ahead_context: Context) void {
        assert(matcher.closed == .seeds and matcher.restart);
        @memset(matcher.current(), constants.slot_unset);
        _ = matcher.follow(matcher.program.forward, ahead_context);
        matcher.take_match();
    }

    /// Where the last thread is `match`, keeps its slots as the best match so far. No match
    /// starts after it.
    fn take_match(matcher: *Matcher) void {
        if (!matcher.at_match()) return;
        matcher.threads_len -= 1;
        @memcpy(matcher.best(), matcher.slots(matcher.thread_slots, matcher.threads[matcher.threads_len]));
        matcher.matched = true;
        matcher.restart = false;
    }

    fn push(matcher: *Matcher, entry: u32, value: u64) void {
        matcher.stack[matcher.stack_len] = entry;
        matcher.stack_values[matcher.stack_len] = value;
        matcher.stack_len += 1;
    }

    /// Follows every path from `seed` that takes no octet, the preferred branch of each split
    /// first. True when a path reached `match`, which is then the last thread.
    fn follow(matcher: *Matcher, seed: u32, ahead_context: Context) bool {
        assert(matcher.stack_len == 0);
        matcher.push(seed, 0);
        while (matcher.stack_len > 0) {
            assert(matcher.stack_len <= constants.instructions_max);
            matcher.stack_len -= 1;
            const entry = matcher.stack[matcher.stack_len];
            if (entry & restore_flag != 0) {
                matcher.current()[entry & restore_mask] = matcher.stack_values[matcher.stack_len];
                continue;
            }
            var next: ?u32 = entry;
            while (next) |index| next = matcher.visit(index, ahead_context);
            if (matcher.at_match()) {
                matcher.stack_len = 0;
                return true;
            }
        }
        return false;
    }

    fn at_match(matcher: *const Matcher) bool {
        if (matcher.threads_len == 0) return false;
        return matcher.program.instructions[matcher.threads[matcher.threads_len - 1]].kind == .match;
    }

    /// One instruction of a path. Gives the instruction the path goes on to, or null where the
    /// path ends: at an instruction that waits for an octet, at `match`, at an assertion that
    /// does not hold, or at an instruction another path of the position reached first.
    fn visit(matcher: *Matcher, index: u32, ahead_context: Context) ?u32 {
        work_file.add(&matcher.work, 1);
        if (!matcher.visited.insert(index)) return null;
        const instruction = matcher.program.instructions[index];
        switch (instruction.kind) {
            .jump => return instruction.out,
            .split => {
                matcher.push(instruction.arg, 0);
                return instruction.out;
            },
            .save => {
                if (instruction.arg < matcher.slots_len) {
                    matcher.push(instruction.arg | restore_flag, matcher.current()[instruction.arg]);
                    matcher.current()[instruction.arg] = matcher.position;
                }
                return instruction.out;
            },
            .look => return if (instruction.look.holds(matcher.behind, ahead_context)) instruction.out else null,
            .range, .match => {
                matcher.threads[matcher.threads_len] = index;
                matcher.threads_len += 1;
                @memcpy(matcher.slots(matcher.thread_slots, index), matcher.current());
                return null;
            },
            .fail => return null,
        }
    }

    /// Gives the position's octet to each thread, in order. The threads that take it are the next
    /// position's seeds.
    fn step(matcher: *Matcher, octet: u8) void {
        assert(matcher.closed == .all);
        work_file.add(&matcher.work, matcher.threads_len);
        matcher.seeds.clear();
        for (matcher.threads[0..matcher.threads_len]) |index| {
            const instruction = matcher.program.instructions[index];
            if (!instruction.takes(octet)) continue;
            if (!matcher.seeds.insert(instruction.out)) continue;
            @memcpy(matcher.slots(matcher.seed_slots, instruction.out), matcher.slots(matcher.thread_slots, index));
        }
        matcher.position += 1;
        matcher.behind = Context.of(octet);
        matcher.closed = .none;
    }
};

fn take(memory: anytype, len: usize) @TypeOf(memory.*) {
    const taken = memory.*[0..len];
    memory.* = memory.*[len..];
    return taken;
}

test {
    _ = @import("matcher_test.zig");
}
