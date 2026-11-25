//! How claim R15 builds its automaton (aho_corasick.zig) in the words of a searcher's cache.
//!
//! The forward program of a trie (literal_trie.zig) is a graph: each node is a chain of splits,
//! each to a branch that takes one octet or to a jump to the end. Equal nodes are written once, so
//! one node of the program stands for many starts of literals. The automaton needs one node for
//! each start, so the build reads the program from its entry, breadth first, and gives each start
//! a node of its own. Four passes follow:
//!
//! - `unfold` writes the nodes, each node's children together, in the order of the program's
//!   branches, and keeps where the end stands among them.
//! - `rank_ends` walks the nodes depth first, each node's branches and end in the program's order,
//!   and counts the ends: a literal's rank is its place in the order the program prefers.
//! - `link` gives each node its fail node, and the longest literal its text ends with.
//! - `write_rows` packs the arrays together and gives the first nodes a full row.
//!
//! The build refuses a program that is not a trie's: one with any other instruction, a node with
//! two branches by one octet, a literal past `automaton_depth_max` octets, or a match of no octet.
//! It refuses an automaton the words do not hold. The matcher then answers, as before.
const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const program_file = @import("program.zig");
const Program = program_file.Program;
const Instruction = program_file.Instruction;
const aho = @import("aho_corasick.zig");
const Automaton = aho.Automaton;
const none = aho.none;
const is_continuation = @import("utf8_ranges.zig").is_continuation;

/// An end's place among a node's branches that names none.
const no_end = std.math.maxInt(u16);

/// The branches of a place of the program, in its order, and where the end stands among them.
const Branches = struct {
    octets: [constants.automaton_branches_max]u8 = undefined,
    nexts: [constants.automaton_branches_max]u32 = undefined,
    len: u16 = 0,
    end: u16 = no_end,
};

/// The node arrays while the build writes them, each of `capacity` entries.
const Arrays = struct {
    first_child: []u32,
    /// The program's place of each node while `unfold` reads the program, then its fail node.
    fail: []u32,
    /// The end's place among each node's branches while `unfold` writes it, then its rank.
    rank: []u32,
    words: []u32,
};

/// Builds the automaton of `program` in `automaton.memory`. False where the program is not a
/// trie's, or the words do not hold its automaton. A build that returns false wrote nothing, so
/// the DFAs whose words these are still answer.
pub noinline fn build(automaton: *Automaton, program: *const Program) bool {
    const capacity = automaton.memory.len / aho.words_per_node;
    const count = measure(program, capacity) orelse return false;
    // The nodes, the classes and a row for the root at least.
    const needed = aho.words_per_node * @as(usize, count) + aho.classes_words + program.class_count;
    if (needed > automaton.memory.len) return false;
    var rest = automaton.memory;
    const arrays: Arrays = .{
        .first_child = take(&rest, capacity),
        .fail = take(&rest, capacity),
        .rank = take(&rest, capacity),
        .words = take(&rest, capacity),
    };
    unfold(program, arrays, count);
    rank_ends(arrays, count);
    link(arrays, count);
    write_rows(automaton, program, arrays, count);
    return true;
}

/// The first `len` words of `rest`, which then holds the words after them.
fn take(rest: *[]u32, len: usize) []u32 {
    const taken = rest.*[0..len];
    rest.* = rest.*[len..];
    return taken;
}

/// One place of the depth-first walk of `measure`: the program's place and its next branch.
const Place = struct { place: u32, next: u16 };

/// The nodes of the program's trie, from a depth-first walk that writes nothing. Null where the
/// program is not a trie's, a literal passes `automaton_depth_max` octets, or the nodes pass
/// `limit`.
fn measure(program: *const Program, limit: usize) ?u32 {
    var branches: Branches = .{};
    if (!root_ok(program, &branches)) return null;
    var places: [constants.automaton_depth_max + 1]Place = undefined;
    places[0] = .{ .place = program.forward, .next = 0 };
    var depth: usize = 1;
    var count: usize = 1;
    // Each turn goes down a branch to a new node or leaves one: two for each node at most.
    for (0..limit + limit + 1) |_| {
        if (depth == 0) return @intCast(count);
        const top = &places[depth - 1];
        walk_place(program, top.place, &branches) orelse return null;
        if (has_twice(&branches)) return null;
        if (top.next == branches.len) {
            depth -= 1;
            continue;
        }
        if (depth == places.len or count == limit) return null;
        places[depth] = .{ .place = branches.nexts[top.next], .next = 0 };
        top.next += 1;
        depth += 1;
        count += 1;
    }
    return null;
}

/// False where the root is a trie's no root: it ends a match of no octet, or it goes on by a
/// continuation byte in UTF-8, where no match starts (`Encoding.may_start_at`).
fn root_ok(program: *const Program, branches: *Branches) bool {
    walk_place(program, program.forward, branches) orelse return false;
    if (branches.end != no_end) return false;
    if (program.encoding != .utf8) return true;
    for (branches.octets[0..branches.len]) |octet| {
        if (is_continuation(octet)) return false;
    }
    return true;
}

/// The places a walk of `walk_place` still goes to, the next last.
const Walk = struct {
    stack: [constants.automaton_walk_stack]u32 = undefined,
    top: usize = 0,

    fn push(walk: *Walk, place: u32) ?void {
        if (walk.top == walk.stack.len) return null;
        walk.stack[walk.top] = place;
        walk.top += 1;
    }

    fn pop(walk: *Walk) ?u32 {
        if (walk.top == 0) return null;
        walk.top -= 1;
        return walk.stack[walk.top];
    }
};

/// The branches of the program's place `start`, and the end's place among them: a walk through
/// saves, jumps and splits, a split's first way first. Null where the walk meets another kind of
/// instruction, or a branch takes more than one octet, or it passes its bounds.
fn walk_place(program: *const Program, start: u32, branches: *Branches) ?void {
    branches.len = 0;
    branches.end = no_end;
    var walk: Walk = .{};
    walk.push(start) orelse unreachable;
    for (0..constants.automaton_walk_max) |_| {
        const place = walk.pop() orelse return;
        visit(program.instructions[place], &walk, branches) orelse return null;
    }
    return null;
}

/// One instruction of a walk. Null where it is no trie's.
fn visit(instruction: Instruction, walk: *Walk, branches: *Branches) ?void {
    switch (instruction.kind) {
        .save, .jump => return walk.push(instruction.out),
        // The second way waits below the first.
        .split => {
            walk.push(instruction.arg) orelse return null;
            return walk.push(instruction.out);
        },
        .range => {
            if (instruction.lo != instruction.hi or branches.len == branches.octets.len) return null;
            branches.octets[branches.len] = instruction.lo;
            branches.nexts[branches.len] = instruction.out;
            branches.len += 1;
        },
        // The first end the order reaches is the one that counts.
        .match => {
            if (branches.end == no_end) branches.end = branches.len;
        },
        else => return null,
    }
}

/// True where two branches take one octet: the program is then no trie, whose node goes on by
/// each octet once.
fn has_twice(branches: *const Branches) bool {
    var seen: [constants.octet_values]bool = @splat(false);
    for (branches.octets[0..branches.len]) |octet| {
        if (seen[octet]) return true;
        seen[octet] = true;
    }
    return false;
}

/// Writes the `count` nodes that `measure` found, breadth first from the program's entry.
fn unfold(program: *const Program, arrays: Arrays, count: u32) void {
    arrays.fail[0] = program.forward;
    arrays.words[0] = aho.pack(0, 0, 0, 0);
    var tail: u32 = 1;
    var branches: Branches = .{};
    // Each turn writes one node's children.
    for (0..count) |turn| {
        const head: u32 = @intCast(turn);
        assert(head < tail);
        // `measure` walked each place, and found it a trie's.
        walk_place(program, arrays.fail[head], &branches) orelse unreachable;
        assert(branches.len <= count - tail);
        const depth = aho.depth_of(arrays.words[head]);
        arrays.first_child[head] = tail;
        arrays.rank[head] = branches.end;
        arrays.words[head] = aho.pack(aho.label_of(arrays.words[head]), depth, 0, @intCast(branches.len));
        for (branches.octets[0..branches.len], branches.nexts[0..branches.len]) |octet, next| {
            arrays.fail[tail] = next;
            arrays.words[tail] = aho.pack(octet, depth + 1, 0, 0);
            tail += 1;
        }
    }
    assert(tail == count);
}

/// The turns of `rank_ends` for each node at most: its end, the branch that leads to it, and its
/// leaving.
const rank_turns_per_node = 3;

/// One node of the depth-first walk: its next branch, and its end's place, or `no_end` once the
/// walk counted it.
const Frame = struct { node: u32, next: u16, end: u16 };

/// Gives each node that ends a literal its rank, in the order the program prefers: a node's
/// branches and its end in the program's order, each branch's literals before what comes after
/// it. Writes each such node's literal length, and `none` for the rank of every other node.
fn rank_ends(arrays: Arrays, count: u32) void {
    var frames: [constants.automaton_depth_max + 1]Frame = undefined;
    frames[0] = .{ .node = 0, .next = 0, .end = take_end(arrays, 0) };
    var top: usize = 1;
    var rank: u32 = 0;
    // Each turn counts an end, goes down a branch, or leaves a node: at most three for each node.
    for (0..rank_turns_per_node * @as(usize, count) + 1) |_| {
        if (top == 0) return;
        const frame = &frames[top - 1];
        const word = arrays.words[frame.node];
        if (frame.next == frame.end) {
            arrays.rank[frame.node] = rank;
            rank += 1;
            const depth = aho.depth_of(word);
            arrays.words[frame.node] = aho.pack(aho.label_of(word), depth, depth, aho.branches_of(word));
            frame.end = no_end;
            continue;
        }
        if (frame.next == aho.branches_of(word)) {
            top -= 1;
            continue;
        }
        const child = arrays.first_child[frame.node] + frame.next;
        frame.next += 1;
        assert(top < frames.len);
        frames[top] = .{ .node = child, .next = 0, .end = take_end(arrays, child) };
        top += 1;
    }
    unreachable;
}

/// A node's end's place, which `unfold` kept in its rank, and `none` in its place.
fn take_end(arrays: Arrays, node: u32) u16 {
    const end: u16 = @intCast(arrays.rank[node]);
    arrays.rank[node] = none;
    return end;
}

/// The child of `node` by `octet` in the arrays, or null.
fn child_of(arrays: Arrays, node: u32, octet: u8) ?u32 {
    const first = arrays.first_child[node];
    for (arrays.words[first..][0..aho.branches_of(arrays.words[node])], first..) |word, index| {
        if (aho.label_of(word) == octet) return @intCast(index);
    }
    return null;
}

/// The node after `from` reads `octet`, by children and fail nodes, while `link` writes them.
fn step(arrays: Arrays, from: u32, octet: u8) u32 {
    var node = from;
    for (0..constants.automaton_depth_max + 1) |_| {
        if (child_of(arrays, node, octet)) |found| return found;
        if (node == 0) return 0;
        node = arrays.fail[node];
    }
    unreachable;
}

/// Gives each node its fail node, and the longest literal its text ends with: its own, or its
/// fail node's. Breadth first, so each fail node is final before a node reads it.
fn link(arrays: Arrays, count: u32) void {
    arrays.fail[0] = 0;
    for (0..count) |index| {
        const node: u32 = @intCast(index);
        const first = arrays.first_child[node];
        for (first..first + aho.branches_of(arrays.words[node])) |child_index| {
            const child: u32 = @intCast(child_index);
            const word = arrays.words[child];
            const fail = if (node == 0) 0 else step(arrays, arrays.fail[node], aho.label_of(word));
            arrays.fail[child] = fail;
            if (aho.out_of(word) != 0) continue;
            const fail_word = arrays.words[fail];
            arrays.words[child] = aho.pack(aho.label_of(word), aho.depth_of(word), aho.out_of(fail_word), aho.branches_of(word));
            arrays.rank[child] = arrays.rank[fail];
        }
    }
}

/// Packs the arrays to `count` entries each, copies the program's classes of octets after them,
/// and writes a full row for each of the first nodes, as many as the words left hold, the root's
/// at least.
fn write_rows(automaton: *Automaton, program: *const Program, arrays: Arrays, count: u32) void {
    const memory = automaton.memory;
    const classes_at = aho.words_per_node * @as(usize, count);
    const rows_at = classes_at + aho.classes_words;
    const row_nodes: u32 = @intCast(@min(count, (memory.len - rows_at) / program.class_count));
    assert(row_nodes > 0);
    // Each array moves down, the first not at all, so each move copies to a lower place, past
    // the arrays it moved before.
    var rest = memory;
    automaton.first_child = take(&rest, count);
    assert(automaton.first_child.ptr == arrays.first_child.ptr);
    automaton.fail = take(&rest, count);
    @memmove(automaton.fail, arrays.fail[0..count]);
    automaton.rank = take(&rest, count);
    @memmove(automaton.rank, arrays.rank[0..count]);
    automaton.words = take(&rest, count);
    @memmove(automaton.words, arrays.words[0..count]);
    automaton.nodes = count;
    const classes = std.mem.sliceAsBytes(memory[classes_at..rows_at]);
    @memcpy(classes, &program.classes);
    automaton.classes = classes;
    automaton.class_count = program.class_count;
    automaton.rows = memory[rows_at..][0 .. @as(usize, row_nodes) * program.class_count];
    // Some octet of each class: each octet a literal takes is a class of its own.
    var octet_of: [constants.octet_values]u8 = undefined;
    for (0..constants.octet_values) |octet| octet_of[program.classes[octet]] = @intCast(octet);
    automaton.row_nodes = 0;
    for (0..row_nodes) |index| {
        const node: u32 = @intCast(index);
        const row = automaton.rows[index * program.class_count ..][0..program.class_count];
        for (row, 0..) |*entry, class| {
            // A fail node is less deep, so it comes first, and its row is written.
            entry.* = automaton.child(node, octet_of[class]) orelse
                if (node == 0) 0 else automaton.rows[@as(usize, automaton.fail[node]) * program.class_count + class];
        }
    }
    automaton.row_nodes = row_nodes;
}
