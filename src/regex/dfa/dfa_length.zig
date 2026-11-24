//! The least and the greatest count of bytes that a part of a program takes (claim R4's second
//! rule, decision 86), where a walk of the part finds both within a few levels.
//!
//! The walk takes the program one byte at a time, as a scan does, with every byte at once. A
//! level holds the instructions a match waits at after as many bytes as the level's number.
//! The first level that reaches `match` is the least length, and the last one is the greatest.
//!
//! - An assertion passes whatever stands around it, so the walk reads no text. A match then
//!   takes one of the walk's paths: none is shorter than the least, and none longer than the
//!   greatest.
//! - The caller names the most levels it has a use for, and the walk gives no lengths where a
//!   level past them holds an instruction. A part with a loop has a level after every level,
//!   and stops there.
//! - A level may hold most of the part's instructions, so the walk also stops at
//!   `length_steps_per_instruction` steps for each instruction.
//!
//! The walk takes the DFA's own lists, as claim R4's other walks do, so it needs no memory. The
//! lengths of a whole pattern come from the parser, which keeps them as it reads the pattern
//! (`Program.match_len_min`).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Dfa = @import("dfa.zig").Dfa;

/// The counts of bytes between which every match of a part of a program lies, both included.
pub const Lengths = struct { least: usize, most: usize };

/// The counts of bytes that the DFA's program takes from `entry` to `match`. Null where a match
/// may take more than `most_max` bytes, where the walk passes its budget, or where the program
/// reaches no `match` from `entry`.
pub fn from(dfa: *Dfa, entry: u32, most_max: usize) ?Lengths {
    assert(dfa.cache.table.len > 0);
    const budget = dfa.visited.sparse.len * constants.length_steps_per_instruction;
    var steps: usize = 0;
    var least: ?usize = null;
    var most: usize = 0;
    dfa.next.clear();
    _ = dfa.next.insert(entry);
    for (0..most_max + 1) |level| {
        const closed = close(dfa);
        steps += closed.steps + step(dfa);
        if (steps > budget) return null;
        if (closed.reached) {
            if (least == null) least = level;
            most = level;
        }
        if (dfa.next.len == 0) {
            const first = least orelse return null;
            assert(first <= most and most <= level);
            return .{ .least = first, .most = most };
        }
    }
    // A level past `most_max` holds an instruction.
    return null;
}

/// Builds a level's threads from its seeds, which `dfa.next` holds. Each instruction goes on the
/// stack once, the first time the walk meets it. An assertion passes.
fn close(dfa: *Dfa) struct { reached: bool, steps: usize } {
    dfa.visited.clear();
    dfa.threads_len = 0;
    var reached = false;
    var stack_len: usize = 0;
    for (dfa.next.slice()) |seed| stack_len = push(dfa, stack_len, seed);
    var steps: usize = 0;
    for (0..dfa.visited.dense.len) |_| {
        if (stack_len == 0) break;
        stack_len -= 1;
        steps += 1;
        const index = dfa.stack[stack_len];
        const instruction = dfa.instructions[index];
        switch (instruction.kind) {
            .range, .ranges => {
                dfa.threads[dfa.threads_len] = index;
                dfa.threads_len += 1;
                continue;
            },
            .match => reached = true,
            .fail => {},
            .jump, .save, .look => stack_len = push(dfa, stack_len, instruction.out),
            .split => {
                stack_len = push(dfa, stack_len, instruction.out);
                stack_len = push(dfa, stack_len, instruction.arg);
            },
        }
    }
    assert(stack_len == 0);
    return .{ .reached = reached, .steps = steps };
}

/// Gives every byte to each thread at once: the next level's seeds are the instructions a
/// thread goes to over any byte. The steps it took: one for each target.
fn step(dfa: *Dfa) usize {
    dfa.next.clear();
    var steps: usize = 0;
    for (dfa.threads[0..dfa.threads_len]) |index| {
        const instruction = dfa.instructions[index];
        if (instruction.kind == .range) {
            _ = dfa.next.insert(instruction.out);
            steps += 1;
            continue;
        }
        // A node's ranges are reached through it alone, each with a target of its own.
        for (dfa.instructions[index + 1 ..][0..instruction.arg]) |member| _ = dfa.next.insert(member.out);
        steps += instruction.arg;
    }
    return steps;
}

fn push(dfa: *Dfa, stack_len: usize, index: u32) usize {
    if (!dfa.visited.insert(index)) return stack_len;
    dfa.stack[stack_len] = index;
    return stack_len + 1;
}

const testing = std.testing;
const compiler = @import("../compile.zig");
const program_file = @import("../program.zig");

/// Instructions enough for the tests' patterns, and a cache enough for a DFA of each.
const test_storage_len = 2048;
const test_memory_len = 32768;

/// More levels than a test's pattern with no loop has.
const test_levels = 64;

/// The lengths of `pattern`'s matches as the walk of its forward program finds them, in
/// `most_max` levels.
fn lengths_of(pattern: []const u8, most_max: usize) !?Lengths {
    var storage: [test_storage_len]program_file.Instruction = undefined;
    var memory: [test_memory_len]u32 = undefined;
    const program = try compiler.compile(pattern, .{}, &storage);
    var dfa: Dfa = undefined;
    try testing.expect(dfa.init(&program, .{ .entry = program.forward, .kind = .first, .anchored = true }, &memory));
    return from(&dfa, program.forward, most_max);
}

test "the walk finds the least and the greatest length of a pattern with no loop" {
    const cases = [_]struct { pattern: []const u8, least: usize, most: usize }{
        .{ .pattern = "", .least = 0, .most = 0 },
        .{ .pattern = "abc", .least = 3, .most = 3 },
        .{ .pattern = "^a{2,5}$", .least = 2, .most = 5 },
        .{ .pattern = "^((aaa)|(aa))$", .least = 2, .most = 3 },
        .{ .pattern = "a?b?c?", .least = 0, .most = 3 },
        .{ .pattern = "(?:a|bcd|)x", .least = 1, .most = 4 },
        .{ .pattern = "\\bab\\b|\\Bx", .least = 1, .most = 2 },
        // A scalar value takes one to four bytes of UTF-8.
        .{ .pattern = "^.{3}$", .least = 3, .most = 12 },
        .{ .pattern = "[a\xC3\xA9]{2}", .least = 2, .most = 4 },
    };
    for (cases) |case| {
        const lengths = (try lengths_of(case.pattern, test_levels)).?;
        try testing.expectEqual(case.least, lengths.least);
        try testing.expectEqual(case.most, lengths.most);
        // The greatest length is the fewest levels that give the lengths.
        try testing.expectEqual(@as(?Lengths, lengths), try lengths_of(case.pattern, case.most));
        if (case.most > 0) try testing.expectEqual(@as(?Lengths, null), try lengths_of(case.pattern, case.most - 1));
    }
}

test "the walk gives no lengths for a pattern with a loop, or with no match" {
    for ([_][]const u8{ "a*", "^a+$", "a{2,}", "(?:ab)*c", "x(?:|a)*", "\\w{10,}" }) |pattern| {
        try testing.expectEqual(@as(?Lengths, null), try lengths_of(pattern, test_levels));
    }
    try testing.expectEqual(@as(?Lengths, null), try lengths_of("[^\\x00-\\x{10FFFF}]", test_levels));
}

test "the walk stops at its budget of steps" {
    // Each level of this pattern holds most of its instructions, so the walk's steps grow with
    // the square of the pattern's length, and pass a budget that grows with the length.
    const levels = 4 * 40;
    try testing.expectEqual(@as(?Lengths, null), try lengths_of("(?:a|aa|aaa|aaaa){40}", levels));
    // The same choice fewer times fits the budget.
    const lengths = (try lengths_of("(?:a|aa|aaa|aaaa){2}", levels)).?;
    try testing.expectEqual(@as(usize, 2), lengths.least);
    try testing.expectEqual(@as(usize, 8), lengths.most);
}
