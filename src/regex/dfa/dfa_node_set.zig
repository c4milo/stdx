//! A DFA's set of instructions (decision 86 as amended on 2026-11-25): its members in the order
//! they joined, with a test for membership and a clear that each cost a constant, as
//! `SparseSet`'s. Its list that finds a member is found by the member's node number, which
//! `compile` writes in `Instruction.node`, so it takes a word for each node of the DFA's program.
//! Found by the instruction's index, it took a word for each instruction: the read-back program
//! of `\p{L}` holds 1,768 instructions and 1,222 nodes, and the forward one 1,348 and 303.
const std = @import("std");
const assert = std.debug.assert;
const program_file = @import("../program.zig");
const Instruction = program_file.Instruction;

pub const NodeSet = struct {
    /// The members' instruction indexes, in the order they joined.
    dense: []u32,
    /// Where each member sits in `dense`, at its node's number.
    sparse: []u32,
    /// The whole program, whose nodes hold their numbers.
    instructions: []const Instruction,
    /// The instructions of the DFA's half of the program, nodes and ranges, which bound a walk.
    program_len: u32,
    len: u32 = 0,

    /// A set of the nodes of a half of `instructions` that holds `program_len` instructions and
    /// `dense.len` nodes. `sparse` is cleared once, here, so no test for membership reads a word
    /// that nothing wrote.
    pub fn init(dense: []u32, sparse: []u32, instructions: []const Instruction, program_len: u32) NodeSet {
        assert(dense.len == sparse.len and sparse.len <= program_len);
        @memset(sparse, 0);
        return .{ .dense = dense, .sparse = sparse, .instructions = instructions, .program_len = program_len };
    }

    /// The slot of `sparse` that the node at `value` takes. A range that a `ranges` node holds
    /// is no node, and its `no_node` passes the list's end.
    pub fn key(set: *const NodeSet, value: u32) u32 {
        return set.instructions[value].node;
    }

    pub fn contains(set: *const NodeSet, value: u32) bool {
        const index = set.sparse[set.key(value)];
        return index < set.len and set.dense[index] == value;
    }

    /// Adds a node. False when the set held it.
    pub fn insert(set: *NodeSet, value: u32) bool {
        const node = set.key(value);
        const index = set.sparse[node];
        if (index < set.len and set.dense[index] == value) return false;
        assert(set.len < set.dense.len);
        set.sparse[node] = set.len;
        set.dense[set.len] = value;
        set.len += 1;
        return true;
    }

    pub fn clear(set: *NodeSet) void {
        set.len = 0;
    }

    pub fn slice(set: *const NodeSet) []const u32 {
        return set.dense[0..set.len];
    }
};

const testing = std.testing;

/// A test's program as `compile` numbers it: a forward half, then a half of a split, a `ranges`
/// node of one range, and `match`, whose nodes are numbered from 0.
const test_forward_len = 3;
const test_split = test_forward_len;
const test_node = test_split + 1;
const test_member = test_node + 1;
const test_match = test_member + 1;
const test_len = test_match + 1;
const test_nodes = test_len - test_forward_len - 1;

fn test_program() [test_len]Instruction {
    var instructions: [test_len]Instruction = @splat(.{ .kind = .match });
    instructions[test_split] = .{ .kind = .split, .out = test_node, .arg = test_match, .node = 0 };
    instructions[test_node] = .{ .kind = .ranges, .arg = 1, .node = 1 };
    instructions[test_member] = .{ .kind = .range, .lo = 'a', .hi = 'a', .out = test_match, .node = program_file.no_node };
    instructions[test_match] = .{ .kind = .match, .node = test_nodes - 1 };
    return instructions;
}

test "a node set keeps the order its members joined in, each once, found by their numbers" {
    const instructions = test_program();
    var dense: [test_nodes]u32 = undefined;
    var sparse: [test_nodes]u32 = undefined;
    var set = NodeSet.init(&dense, &sparse, &instructions, test_len - test_forward_len);
    try testing.expect(set.insert(test_match));
    try testing.expect(set.insert(test_split));
    try testing.expect(!set.insert(test_match));
    try testing.expect(set.contains(test_split) and set.contains(test_match) and !set.contains(test_node));
    try testing.expect(set.insert(test_node));
    try testing.expectEqualSlices(u32, &.{ test_match, test_split, test_node }, set.slice());
    set.clear();
    try testing.expect(!set.contains(test_split) and !set.contains(test_node) and !set.contains(test_match));
    try testing.expect(set.insert(test_node));
    try testing.expectEqualSlices(u32, &.{test_node}, set.slice());
}
