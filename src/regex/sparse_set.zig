//! A set of instruction indexes that keeps the order they joined in, with a test for membership
//! and a clear that each cost a constant (decision 86). A matcher's lists are these: the order is
//! the order of preference, and a list is cleared once for each octet.
const std = @import("std");
const assert = std.debug.assert;

pub const SparseSet = struct {
    /// The members, in the order they joined.
    dense: []u32,
    /// Where each value sits in `dense`, for the values that are members.
    sparse: []u32,
    len: u32 = 0,

    /// A set of the values below `dense.len`. `sparse` is cleared once, here, so no test for
    /// membership reads an octet that nothing wrote.
    pub fn init(dense: []u32, sparse: []u32) SparseSet {
        assert(dense.len == sparse.len);
        @memset(sparse, 0);
        return .{ .dense = dense, .sparse = sparse };
    }

    pub fn contains(set: *const SparseSet, value: u32) bool {
        const index = set.sparse[value];
        return index < set.len and set.dense[index] == value;
    }

    /// Adds a value. False when the set held it.
    pub fn insert(set: *SparseSet, value: u32) bool {
        if (set.contains(value)) return false;
        set.sparse[value] = set.len;
        set.dense[set.len] = value;
        set.len += 1;
        return true;
    }

    pub fn clear(set: *SparseSet) void {
        set.len = 0;
    }

    pub fn slice(set: *const SparseSet) []const u32 {
        return set.dense[0..set.len];
    }
};

const testing = std.testing;

test "a set keeps the order its members joined in, each once" {
    var dense: [8]u32 = undefined;
    var sparse: [8]u32 = undefined;
    var set = SparseSet.init(&dense, &sparse);
    try testing.expect(set.insert(5));
    try testing.expect(set.insert(0));
    try testing.expect(set.insert(7));
    try testing.expect(!set.insert(5));
    try testing.expect(!set.insert(0));
    try testing.expectEqualSlices(u32, &.{ 5, 0, 7 }, set.slice());
    try testing.expect(set.contains(7) and !set.contains(1) and !set.contains(6));
}

test "a cleared set holds no member it held before" {
    var dense: [4]u32 = undefined;
    var sparse: [4]u32 = undefined;
    var set = SparseSet.init(&dense, &sparse);
    for (0..4) |value| try testing.expect(set.insert(@intCast(value)));
    set.clear();
    for (0..4) |value| try testing.expect(!set.contains(@intCast(value)));
    try testing.expect(set.insert(3));
    try testing.expect(!set.contains(0));
    try testing.expectEqualSlices(u32, &.{3}, set.slice());
}
