//! Claim R13 (decision 86): the least and the greatest count of bytes a match of a program
//! takes, where a walk of the program finds both within a budget.
//!
//! The walk takes the program one byte at a time, as a scan does, with every byte at once. A
//! level holds the instructions a match waits at after as many bytes as the level's number.
//! The first level that reaches `match` is the least length, and the last one is the greatest.
//!
//! - An assertion passes whatever stands around it, so the walk reads no text. A match then
//!   takes one of the walk's paths: none is shorter than the least, and none longer than the
//!   greatest.
//! - A program with a loop has a level after every level, so its walk does not end. The walk
//!   stops at `length_steps_per_instruction` steps for each instruction, and gives no lengths.
//!
//! The walk takes the DFA's own lists, as claim R4's walk does, so it needs no memory.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Dfa = @import("dfa.zig").Dfa;

/// The counts of bytes between which every match of a program lies, both included.
pub const Lengths = struct {
    least: usize,
    most: usize,

    /// True when no text of `len` bytes is a match.
    pub fn exclude(lengths: Lengths, len: usize) bool {
        return len < lengths.least or len > lengths.most;
    }
};

/// The lengths of the matches of the DFA's program. Null where the walk passes its budget, as
/// for a program with a loop, or the program reaches no `match`.
pub fn of(dfa: *Dfa) ?Lengths {
    assert(dfa.cache.table.len > 0);
    const budget = dfa.visited.sparse.len * constants.length_steps_per_instruction;
    var steps: usize = 0;
    var least: ?usize = null;
    var most: usize = 0;
    dfa.next.clear();
    _ = dfa.next.insert(dfa.config.entry);
    // A level with a seed takes a step or more, so the levels are at most the budget and one.
    for (0..budget + 1) |level| {
        if (dfa.next.len == 0) {
            const first = least orelse return null;
            assert(first <= most and most < level);
            return .{ .least = first, .most = most };
        }
        const closed = close(dfa);
        steps += closed.steps + step(dfa);
        if (steps > budget) return null;
        if (!closed.reached) continue;
        if (least == null) least = level;
        most = level;
    }
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

/// The lengths of `pattern`'s matches as the walk of its forward program finds them.
fn lengths_of(pattern: []const u8, encoding: program_file.Encoding) !?Lengths {
    var storage: [test_storage_len]program_file.Instruction = undefined;
    var memory: [test_memory_len]u32 = undefined;
    const program = try compiler.compile(pattern, .{ .encoding = encoding }, &storage);
    var dfa: Dfa = undefined;
    try testing.expect(dfa.init(&program, .{ .entry = program.forward, .kind = .first, .anchored = true }, &memory));
    return of(&dfa);
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
        .{ .pattern = "\xE2\x82\xAC", .least = 3, .most = 3 },
    };
    for (cases) |case| {
        const lengths = (try lengths_of(case.pattern, .utf8)).?;
        try testing.expectEqual(case.least, lengths.least);
        try testing.expectEqual(case.most, lengths.most);
        try testing.expect(!lengths.exclude(case.least) and !lengths.exclude(case.most));
        try testing.expect(lengths.exclude(case.most + 1));
        if (case.least > 0) try testing.expect(lengths.exclude(case.least - 1));
    }
    // In bytes, `.` takes one byte.
    const bytes = (try lengths_of("^.{249}$", .bytes)).?;
    try testing.expectEqual(@as(usize, 249), bytes.least);
    try testing.expectEqual(@as(usize, 249), bytes.most);
}

test "the walk gives no lengths for a pattern with a loop, or with no match" {
    for ([_][]const u8{ "a*", "^a+$", "a{2,}", "(?:ab)*c", "x(?:|a)*", "\\w{10,}" }) |pattern| {
        try testing.expectEqual(@as(?Lengths, null), try lengths_of(pattern, .utf8));
    }
    try testing.expectEqual(@as(?Lengths, null), try lengths_of("[^\\x00-\\x{10FFFF}]", .utf8));
}

test "the walk stops at its budget of steps" {
    // Each level of this pattern holds most of its instructions, so the walk's steps grow with
    // the square of the pattern's length, and pass a budget that grows with the length.
    const pattern = "(?:a|aa|aaa|aaaa){40}";
    try testing.expectEqual(@as(?Lengths, null), try lengths_of(pattern, .utf8));
    // The same choice fewer times fits the budget.
    const lengths = (try lengths_of("(?:a|aa|aaa|aaaa){2}", .utf8)).?;
    try testing.expectEqual(@as(usize, 2), lengths.least);
    try testing.expectEqual(@as(usize, 8), lengths.most);
}
