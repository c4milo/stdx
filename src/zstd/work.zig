//! Invariant 17's count for the Zstandard decoder: each cell a table build fills, and each symbol a
//! table description or a stream decodes. A test build keeps it; elsewhere it is `void` and costs
//! nothing. decoder/decoder_work_test.zig bounds it on decision 15's worst cases.

const builtin = @import("builtin");

pub const Work = if (builtin.is_test) u64 else void;

pub const zero: Work = if (builtin.is_test) 0 else {};

/// `count` as a count of work.
pub fn of(count: usize) Work {
    return if (builtin.is_test) count else {};
}

pub fn add(work: *Work, count: Work) void {
    if (builtin.is_test) work.* += count;
}
