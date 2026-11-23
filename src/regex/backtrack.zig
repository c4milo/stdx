//! Claim R8 (decision 86 as amended): the capture groups of a match whose span the DFAs found, by
//! a backtracker that visits each instruction at each offset of the span once.
//!
//! The matcher keeps a thread for each instruction that waits for an octet, and each thread copies
//! the slots of every group as it moves. A backtracker follows one path at a time, in the order of
//! preference, and writes a slot only where its path passes a save. Where the path fails, its
//! saves are undone. The first path that reaches `match` is the match the matcher finds first.
//!
//! A bit for each pair of an instruction and an offset says the pair was visited. A path that
//! comes to a visited pair would fail as the first path there did, since a path that reached
//! `match` from there would have ended the search. So each pair costs one visit, and a search
//! costs at most the program's instructions times the span's octets and one. RE2's BitState and
//! Rust's regex crate's `BoundedBacktracker` search the same way, in a bitmap of a bounded size
//! (Cox, "Regular Expression Matching in the Wild", 2010).
//!
//! The DFAs found where the match ends, so no path takes an octet past the end: a path that would
//! is one the matcher prefers, and it fails, or it would be the match. The bits and the stack take
//! the matcher's two tables of slots, which only the matcher's own search writes. Where they are
//! too small, `find` gives null and the matcher finds the groups.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Context = program_file.Context;
const Instruction = program_file.Instruction;
const matcher_file = @import("matcher.zig");
const Matcher = matcher_file.Matcher;
const Span = matcher_file.Span;

/// The bit of a stack entry's first word that says the entry restores a slot. The first word then
/// names the slot and the second holds its old value. Without the bit, the first word names an
/// instruction and the second an offset.
const restore_flag: u64 = 1 << (@bitSizeOf(u64) - 1);

/// The words of one stack entry.
const entry_words = 2;

/// The visited bits one word holds.
const bits_per_word = @bitSizeOf(u64);

/// The match that starts at `start` and ends at `end`, which the matcher finds anchored at
/// `start`, with its groups in the matcher's slots of its best match, which the search writes
/// as it goes. Null where the matcher's tables are too small
/// for the span's bits or for the stack the search needs: the matcher's own search then finds the
/// groups. The matcher must keep every group's slots.
pub fn find(matcher: *Matcher, haystack: []const u8, start: usize, end: usize) ?Span {
    assert(start <= end and end <= haystack.len);
    assert(matcher.slots_len == matcher.program.slot_count());
    const positions = end - start + 1;
    const bits = @as(usize, matcher.program.forward_len) * positions;
    const words = (bits + bits_per_word - 1) / bits_per_word;
    if (words > matcher.seed_slots.len) return null;
    // The bits of a span fit the matcher's tables, so its positions fit a u32 by far.
    if (positions > std.math.maxInt(u32)) return null;
    if (matcher.one_pass_table == .held) matcher.one_pass_table = .none;
    matcher.start(if (start == 0) null else haystack[start - 1], start);
    // The matcher takes its two tables one after the other, so the stack takes what the bits
    // leave of the first and all of the second.
    assert(matcher.seed_slots.ptr + matcher.seed_slots.len == matcher.thread_slots.ptr);
    const tables = matcher.seed_slots.ptr[0 .. matcher.seed_slots.len + matcher.thread_slots.len];
    var search: Search = .{
        .instructions = matcher.program.instructions[0..matcher.program.forward_len],
        .haystack = haystack,
        .start = start,
        .end = end,
        .positions = @intCast(positions),
        .visited = tables[0..words],
        .stack = tables[words..],
        .slots = matcher.best(),
    };
    // A loop of stores: the bits of a short span are a few words, which a call costs more than.
    for (search.visited) |*word| word.* = 0;
    // A loop of stores, where `@memset` of a few slots costs a call that writes an octet a step.
    for (search.slots) |*slot| slot.* = constants.slot_unset;
    const matched = search.run(matcher.program.forward) orelse return null;
    // The DFAs found a match from `start` that ends at `end`, so the first path reaches one.
    assert(matched);
    matcher.matched = true;
    matcher.finished = true;
    return matcher.span();
}

/// How a path ended: at `match`, failed, or with no room on the stack for an entry it must keep.
const Outcome = enum { matched, failed, full };

const Search = struct {
    instructions: []const Instruction,
    haystack: []const u8,
    start: usize,
    end: usize,
    /// The span's offsets and one, which a pair's bit multiplies by its instruction: a u32, so
    /// the product of two u32 values and an offset fit a u64 with no check.
    positions: u32,
    visited: []u64,
    stack: []u64,
    stack_len: usize = 0,
    slots: []u64,

    /// True where a path from `entry` at the span's start reaches `match`, false where none
    /// does, and null where the stack has no room for an entry the search must keep.
    fn run(search: *Search, entry: u32) ?bool {
        if (!search.push(entry, search.start)) return null;
        // Each entry is pushed by a split or a save that a visit passed, so the entries are at
        // most the pairs and one, and each turn takes one.
        for (0..search.instructions.len * @as(usize, search.positions) + 1) |_| {
            if (search.stack_len == 0) return false;
            search.stack_len -= entry_words;
            const first = search.stack[search.stack_len];
            const second = search.stack[search.stack_len + 1];
            if (first & restore_flag != 0) {
                search.slots[@intCast(first & ~restore_flag)] = second;
                continue;
            }
            switch (search.follow(@intCast(first), @intCast(second))) {
                .matched => return true,
                .failed => {},
                .full => return null,
            }
        }
        return false;
    }

    /// Follows one path from `index` at `at`, the preferred branch of each split first, until it
    /// fails or reaches `match`.
    fn follow(search: *Search, index: u32, at: usize) Outcome {
        var instruction_index = index;
        var position = at;
        // Each step visits a pair for the first time, so the steps are at most the pairs.
        for (0..search.instructions.len * @as(usize, search.positions)) |_| {
            if (!search.visit(instruction_index, position)) return .failed;
            switch (search.step(instruction_index, position)) {
                .next => |next| {
                    instruction_index = next.index;
                    position = next.at;
                },
                .done => |outcome| return outcome,
            }
        }
        return .failed;
    }

    /// Where a path goes on: an instruction, at an offset.
    const Next = struct { index: u32, at: usize };

    /// Where one instruction of a path goes on, or how the path ended.
    const Step = union(enum) { next: Next, done: Outcome };

    /// One instruction of a path at `at`: where its path goes on, or how the path ended.
    fn step(search: *Search, index: u32, at: usize) Step {
        const instruction = search.instructions[index];
        switch (instruction.kind) {
            .match => {
                assert(at == search.end);
                return .{ .done = .matched };
            },
            .fail => return .{ .done = .failed },
            .jump => {},
            .split => return search.split(instruction, at),
            .save => if (instruction.arg < search.slots.len) {
                if (!search.push_restore(instruction.arg)) return .{ .done = .full };
                search.slots[instruction.arg] = at;
            },
            .look => if (!instruction.look.holds(search.behind(at), search.ahead(at))) return .{ .done = .failed },
            .range => {
                if (!search.takes(instruction, at)) return .{ .done = .failed };
                return .{ .next = .{ .index = instruction.out, .at = at + 1 } };
            },
            .ranges => {
                const next = search.taken(index, at) orelse return .{ .done = .failed };
                return .{ .next = .{ .index = next, .at = at + 1 } };
            },
        }
        return .{ .next = .{ .index = instruction.out, .at = at } };
    }

    /// A split at `at`: its other branch pushed, and its preferred branch followed. In a lazy
    /// loop, whose other branch is its node, where the way out fails at once, as it does at each
    /// octet the loop takes, the node's path goes on with no entry pushed. A chain of an
    /// alternation's splits keeps `push`, whose walk skips the branches that fail.
    fn split(search: *Search, instruction: Instruction, at: usize) Step {
        if (is_node(search.instructions[instruction.arg]) and search.fails_at_once(instruction.out, at)) {
            return .{ .next = .{ .index = instruction.arg, .at = at } };
        }
        if (!search.push(instruction.arg, at)) return .{ .done = .full };
        return .{ .next = .{ .index = instruction.out, .at = at } };
    }

    /// Marks a pair as visited. False where it was.
    fn visit(search: *Search, index: u32, at: usize) bool {
        // The offset is under `positions`: both it and the index are u32 values, so on a 64-bit
        // target the product and the sum cannot overflow, and the compiler checks neither. The
        // read's bounds check holds the bit.
        const offset: u32 = @truncate(at -% search.start);
        const bit = @as(usize, index) * search.positions + offset;
        const word = &search.visited[bit / bits_per_word];
        const mask = @as(u64, 1) << @intCast(bit % bits_per_word);
        if (word.* & mask != 0) return false;
        word.* |= mask;
        return true;
    }

    /// Pushes the path from `index` at `at`, past the alternatives that would fail at their first
    /// instruction: ranges that do not take the octet at `at`. Each split of a class's
    /// alternatives names a range first, so the alternatives of an octet that a path took leave
    /// no entry behind it. False where the stack is full. Inline, as `fails_at_once` is: as calls
    /// in a ReleaseSafe build, the two took the lexer row 12% more instructions.
    inline fn push(search: *Search, index: u32, at: usize) bool {
        const first = search.worth(index, at) orelse return true;
        if (search.stack_len + entry_words > search.stack.len) return false;
        search.stack[search.stack_len] = first;
        search.stack[search.stack_len + 1] = at;
        search.stack_len += entry_words;
        return true;
    }

    /// The first instruction of the path from `index` at `at`, past the preferred branches of
    /// its splits that fail at once, or null where the path itself fails at once. Skipping such a
    /// branch is what visiting it would do, less its bits.
    fn worth(search: *const Search, index: u32, at: usize) ?u32 {
        var first = index;
        // Each turn passes one split, and the walk stops after `skip_splits_max` of them, so a
        // push costs a bounded walk.
        for (0..constants.backtrack_skip_splits_max) |_| {
            const instruction = search.instructions[first];
            if (instruction.kind != .split) return if (search.fails_at_once(first, at)) null else first;
            if (!search.fails_at_once(instruction.out, at)) return first;
            first = instruction.arg;
        }
        return first;
    }

    /// True where the path from `index` at `at` fails before it takes an octet or splits: its
    /// saves and jumps lead to a range that does not take the octet at `at`, or to an assertion
    /// that does not hold there. A save that a failed path passed writes nothing that lasts.
    inline fn fails_at_once(search: *const Search, index: u32, at: usize) bool {
        var next = index;
        // A path that takes no octet and does not split holds no loop: at most the program.
        for (0..search.instructions.len) |_| {
            const instruction = search.instructions[next];
            switch (instruction.kind) {
                .range => return !search.takes(instruction, at),
                .ranges => return search.taken(next, at) == null,
                .look => if (!instruction.look.holds(search.behind(at), search.ahead(at))) return true,
                .save, .jump => {},
                .fail => return true,
                .split, .match => return false,
            }
            next = instruction.out;
        }
        return false;
    }

    /// True where the range takes the octet at `at`, which is before the span's end. Inline: a
    /// ReleaseSafe build left it a call at each range a path passes.
    inline fn takes(search: *const Search, range: Instruction, at: usize) bool {
        return at < search.end and range.takes(search.haystack[at]);
    }

    /// The instruction the `ranges` at `index` goes to after it takes the octet at `at`, which is
    /// before the span's end, or null where it does not take it.
    fn taken(search: *const Search, index: u32, at: usize) ?u32 {
        if (at >= search.end) return null;
        return program_file.step_ranges(search.instructions, index, search.haystack[at]);
    }

    /// Pushes an entry that gives `slot` its value back when the search returns to it.
    fn push_restore(search: *Search, slot: u32) bool {
        if (search.stack_len + entry_words > search.stack.len) return false;
        search.stack[search.stack_len] = slot | restore_flag;
        search.stack[search.stack_len + 1] = search.slots[slot];
        search.stack_len += entry_words;
        return true;
    }

    fn behind(search: *const Search, at: usize) Context {
        return if (at == 0) .edge else Context.of(search.haystack[at - 1]);
    }

    fn ahead(search: *const Search, at: usize) Context {
        return if (at == search.haystack.len) .edge else Context.of(search.haystack[at]);
    }
};

fn is_node(instruction: Instruction) bool {
    return instruction.kind == .range or instruction.kind == .ranges;
}

test {
    _ = @import("backtrack_test.zig");
}
