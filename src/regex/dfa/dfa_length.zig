//! The least and the greatest count of bytes that a program takes, or a part of one (claim R13,
//! and claim R4's second rule, decision 86).
//!
//! An assertion passes whatever stands around it, so neither way reads a text. A match then
//! takes one of the program's paths: none is shorter than the least, and none longer than the
//! greatest.
//!
//! - `of` gives a whole program's lengths by one pass, depth first. A node's lengths are those
//!   of the nodes it goes to, and one byte more where it takes a byte. The pass computes each
//!   node once, so it takes a step for each instruction, however many paths the program has.
//!   A program with a loop has no greatest length, and the pass stops at the loop.
//! - `from` gives the lengths of a part that may hold a loop past its use, by a walk of at most
//!   as many levels as its caller names. The walk takes the program one byte at a time, as a
//!   scan does, with every byte at once. A level holds the instructions a match waits at after
//!   as many bytes as the level's number. The first level that reaches `match` is the least
//!   length, and the last one is the greatest. A level may hold most of the program's
//!   instructions, so the walk also stops at `length_steps_per_instruction` steps for each
//!   instruction.
//!
//! Both take the DFA's own lists, as claim R4's other walks do, so they need no memory. A
//! searcher makes them once its searches were given enough text (searcher_claim.zig).
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("../constants.zig");
const Instruction = @import("../program.zig").Instruction;
const Dfa = @import("dfa.zig").Dfa;

/// The instructions a split goes to.
const split_targets = 2;

/// The counts of bytes between which every match of a part of a program lies, both included,
/// and the most bytes that any path of the part takes, whether it reaches `match` or not.
pub const Lengths = struct { least: usize, most: usize, bound: usize };

/// A node that the pass did not meet yet, one whose targets it is still at, and one that reaches
/// no `match`, in the list of least lengths. A length is under each: a path takes at most one
/// byte a node.
const unseen = std.math.maxInt(u32);
const open = unseen - 1;
const none = open - 1;

/// The counts of bytes that a match of the DFA's program takes (claim R13). Null where the
/// program holds a loop, so that a match may take any count of bytes, or reaches no `match`.
pub fn of(dfa: *Dfa) ?Lengths {
    assert(dfa.cache.table.len > 0);
    // The lists that find a set's member are as long as the program, and hold each node's
    // lengths for the pass. A set is empty after it, whatever its list holds.
    const least = dfa.visited.sparse;
    const most = dfa.next.sparse;
    const base = dfa.visited.base;
    assert(least.len == most.len and base == dfa.next.base);
    assert(least.len < none);
    dfa.visited.clear();
    dfa.next.clear();
    @memset(least, unseen);
    if (!pass(dfa, dfa.config.entry)) return null;
    const first = least[dfa.config.entry - base];
    if (first == none) return null;
    const last = most[dfa.config.entry - base];
    assert(first <= last and last <= least.len);
    return .{ .least = first, .most = last, .bound = last };
}

/// Computes the lengths of each node that `entry` reaches, the targets of a node before the
/// node. False where a node reaches itself. The stack holds the nodes whose targets the pass is
/// still at, and `dfa.threads` holds, for each of them, how many targets it has named.
fn pass(dfa: *Dfa, entry: u32) bool {
    const least = dfa.visited.sparse;
    const base = dfa.visited.base;
    var depth: usize = enter(dfa, 0, entry);
    // A turn names one target of a node, or closes one node. A node has a target for each
    // range it holds, one more for a split, and closes once.
    for (0..least.len + least.len + dfa.stack.len) |_| {
        if (depth == 0) break;
        const node = dfa.stack[depth - 1];
        const named = dfa.threads[depth - 1];
        if (named == target_count(dfa.instructions[node])) {
            close_node(dfa, node);
            depth -= 1;
            continue;
        }
        dfa.threads[depth - 1] = named + 1;
        const target = target_of(dfa.instructions, node, named);
        switch (least[target - base]) {
            unseen => depth = enter(dfa, depth, target),
            // The node is one of those the pass is still at: a loop.
            open => return false,
            else => {},
        }
    }
    assert(depth == 0);
    return true;
}

/// Puts `node` on the stack as the pass meets it. The depth after it.
fn enter(dfa: *Dfa, depth: usize, node: u32) usize {
    const least = dfa.visited.sparse;
    assert(least[node - dfa.visited.base] == unseen);
    // The stack holds each node once at most.
    assert(depth < dfa.threads.len);
    least[node - dfa.visited.base] = open;
    dfa.stack[depth] = node;
    dfa.threads[depth] = 0;
    return depth + 1;
}

/// How many instructions a node goes to.
fn target_count(instruction: Instruction) u32 {
    return switch (instruction.kind) {
        .match, .fail => 0,
        .range, .jump, .save, .look => 1,
        .split => split_targets,
        // A node's ranges are reached through it alone, each with a target of its own.
        .ranges => instruction.arg,
    };
}

/// The target of the node at `node` that `ordinal` counts, from 0.
fn target_of(instructions: []const Instruction, node: u32, ordinal: u32) u32 {
    const instruction = instructions[node];
    assert(ordinal < target_count(instruction));
    return switch (instruction.kind) {
        .match, .fail => unreachable,
        .range, .jump, .save, .look => instruction.out,
        .split => if (ordinal == 0) instruction.out else instruction.arg,
        .ranges => instructions[node + 1 + ordinal].out,
    };
}

/// Writes a node's lengths from those of its targets, which the pass computed: the least of
/// their least lengths and the greatest of their greatest, and one byte more where the node
/// takes a byte. A target that reaches no `match` holds `none`, which is over every least
/// length, and a greatest length of 0, so it changes neither.
fn close_node(dfa: *Dfa, node: u32) void {
    const least = dfa.visited.sparse;
    const most = dfa.next.sparse;
    const base = dfa.visited.base;
    const instruction = dfa.instructions[node];
    assert(least[node - base] == open);
    var low: u32 = if (instruction.kind == .match) 0 else none;
    var high: u32 = 0;
    for (0..target_count(instruction)) |ordinal| {
        const target = target_of(dfa.instructions, node, @intCast(ordinal));
        const target_low = least[target - base];
        assert(target_low != unseen and target_low != open);
        low = @min(low, target_low);
        high = @max(high, most[target - base]);
    }
    const takes_a_byte = instruction.kind == .range or instruction.kind == .ranges;
    if (takes_a_byte and low != none) {
        low += 1;
        high += 1;
    }
    least[node - base] = low;
    most[node - base] = high;
}

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
            // The level after this one holds no instruction, so no path takes more bytes.
            return .{ .least = first, .most = most, .bound = level };
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
const dfa_config = @import("dfa_config.zig");

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

/// The lengths of `pattern`'s matches as one pass of its forward program finds them.
fn lengths_by_pass(pattern: []const u8) !?Lengths {
    var storage: [test_storage_len]program_file.Instruction = undefined;
    var memory: [test_memory_len]u32 = undefined;
    const program = try compiler.compile(pattern, .{}, &storage);
    var dfa: Dfa = undefined;
    try testing.expect(dfa.init(&program, .{ .entry = program.forward, .kind = .first, .anchored = true }, &memory));
    return of(&dfa);
}

test "the walk and the pass find the least and the greatest length of a pattern with no loop" {
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
        // One way of the choice reaches no match, after a byte, and changes neither length.
        .{ .pattern = "(?:a[^\\x00-\\x{10FFFF}]|bc)d?", .least = 2, .most = 3 },
    };
    for (cases) |case| {
        const lengths = (try lengths_of(case.pattern, test_levels)).?;
        try testing.expectEqual(case.least, lengths.least);
        try testing.expectEqual(case.most, lengths.most);
        try testing.expectEqual(@as(?Lengths, lengths), try lengths_by_pass(case.pattern));
        // The greatest length is the fewest levels that give the lengths.
        try testing.expectEqual(@as(?Lengths, lengths), try lengths_of(case.pattern, case.most));
        if (case.most > 0) try testing.expectEqual(@as(?Lengths, null), try lengths_of(case.pattern, case.most - 1));
    }
}

test "the walk and the pass give no lengths for a pattern with a loop, or with no match" {
    // The last two hold a loop after a choice, and a loop that one way of a choice passes by.
    const loops = [_][]const u8{ "a*", "^a+$", "a{2,}", "(?:ab)*c", "x(?:|a)*", "\\w{10,}", "(?:a|b)c*", "a(?:b|c+)d" };
    for (loops) |pattern| {
        try testing.expectEqual(@as(?Lengths, null), try lengths_of(pattern, test_levels));
        try testing.expectEqual(@as(?Lengths, null), try lengths_by_pass(pattern));
    }
    // No match at once, after a byte, and after each way of a choice.
    const no_match = [_][]const u8{ "[^\\x00-\\x{10FFFF}]", "a[^\\x00-\\x{10FFFF}]", "(?:a|bc)[^\\x00-\\x{10FFFF}]" };
    for (no_match) |pattern| {
        try testing.expectEqual(@as(?Lengths, null), try lengths_of(pattern, test_levels));
        try testing.expectEqual(@as(?Lengths, null), try lengths_by_pass(pattern));
    }
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

test "the pass computes each node once, and gives the lengths that the walk's budget refuses" {
    const cases = [_]struct { pattern: []const u8, least: usize, most: usize }{
        .{ .pattern = "(?:a|aa|aaa|aaaa){40}", .least = 40, .most = 160 },
        // Each of the 24 scalar values takes one to four bytes, by a tree of nodes.
        .{ .pattern = "^.{24}$", .least = 24, .most = 96 },
        .{ .pattern = "^(?:a|bc|def){2,5}x?$", .least = 2, .most = 16 },
    };
    for (cases) |case| {
        try testing.expectEqual(@as(?Lengths, null), try lengths_of(case.pattern, case.most));
        const lengths = (try lengths_by_pass(case.pattern)).?;
        try testing.expectEqual(case.least, lengths.least);
        try testing.expectEqual(case.most, lengths.most);
    }
}

test "the pass leaves the DFA's two sets empty, and a scan after it gives its answer" {
    var storage: [test_storage_len]program_file.Instruction = undefined;
    var memory: [test_memory_len]u32 = undefined;
    const program = try compiler.compile("^(?:ab|c){2,3}$", .{}, &storage);
    var dfa: Dfa = undefined;
    try testing.expect(dfa.init(&program, .{ .entry = program.forward, .kind = .first, .anchored = true }, &memory));
    // The first scan builds some of the DFA's states, and the second one the others.
    const short = dfa.scan_forward("abc", 0, false);
    const lengths = of(&dfa).?;
    try testing.expectEqual(@as(usize, 2), lengths.least);
    try testing.expectEqual(@as(usize, 6), lengths.most);
    try testing.expectEqual(@as(u32, 0), dfa.visited.len);
    try testing.expectEqual(@as(u32, 0), dfa.next.len);
    try testing.expectEqual(short, dfa.scan_forward("abc", 0, false));
    try testing.expectEqual(dfa_config.Scan{ .found = 5 }, dfa.scan_forward("ababc", 0, false));
    try testing.expectEqual(dfa_config.Scan.none, dfa.scan_forward("abx", 0, false));
}
