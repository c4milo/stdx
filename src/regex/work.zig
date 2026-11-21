//! Invariant 18's count for the matcher: each instruction a position's threads try, and each
//! thread an octet is given to. A test build keeps it; elsewhere it is `void` and costs nothing.
//! matcher_work_test.zig bounds it on the patterns that make a backtracking matcher exponential.

const builtin = @import("builtin");

pub const Work = if (builtin.is_test) u64 else void;

pub const zero: Work = if (builtin.is_test) 0 else {};

pub fn add(work: *Work, count: usize) void {
    if (builtin.is_test) work.* += count;
}
