//! The timing every benchmark shares, as decisions 10 and 20 fix it: every candidate of a row in
//! one program, interleaved in the same run, five runs each, and the median and the spread
//! reported.
//!
//! One run repeats an operation for at least `run_ns_min`, in batches that double in size, and
//! reads the clock once per batch. An operation of a few nanoseconds, such as a checksum over 64
//! octets, is then timed over millions of repetitions without a clock read between them.

const std = @import("std");
const platform = @import("platform");

/// Hardware counters, for bench-profile.
pub const counters = @import("counters.zig");

/// What a row codes: a corpus file whole, or a small body's slices in rotation (decision 45).
pub const inputs = @import("inputs.zig");

comptime {
    // Every benchmark program imports this module, so each exports platform's vector `memset` on
    // Linux under Zig 0.16, for stdx and for the baselines' C code alike (decision 41).
    if (platform.memset_applies) @export(&platform.memset, .{ .name = "memset" });
}

test {
    _ = inputs;
}

/// Runs per measurement; decision 10 reports the median of five.
pub const run_count = 5;

/// The least time one run spends repeating an operation.
pub const run_ns_min: i96 = 50 * std.time.ns_per_ms;

/// The most repetitions one batch makes, so a slow operation on a large input stays bounded.
const batch_len_max: usize = 1 << 20;

/// The most batches one run makes: enough to double from one repetition to `batch_len_max` and
/// then fill `run_ns_min`.
const batches_max: usize = 1 << 10;

/// Octets per megabyte and per gigabyte, as throughput is reported: powers of 10, the units
/// lzbench and the baselines use.
pub const octets_per_megabyte = 1_000_000.0;
pub const octets_per_gigabyte = 1_000_000_000.0;

/// One timed operation.
pub const Operation = struct {
    context: *const anyopaque,
    run_once: *const fn (context: *const anyopaque) void,
};

/// The median of the runs and their spread: the slowest minus the fastest, as a share of the
/// median.
pub const Summary = struct { median: f64, spread: f64 };

pub fn summarize(runs: [run_count]f64) Summary {
    var sorted = runs;
    std.mem.sort(f64, &sorted, {}, std.sort.asc(f64));
    const median = sorted[run_count / 2];
    const range = sorted[run_count - 1] - sorted[0];
    return .{ .median = median, .spread = if (median == 0) 0 else @abs(range / median) };
}

/// Nanoseconds per repetition of `operation`, over at least `run_ns_min`.
fn time_run(io: std.Io, operation: Operation) f64 {
    var repetitions: usize = 0;
    var batch_len: usize = 1;
    const start = std.Io.Timestamp.now(io, .awake);
    var elapsed: i96 = 0;
    for (0..batches_max) |_| {
        if (elapsed >= run_ns_min) break;
        for (0..batch_len) |_| operation.run_once(operation.context);
        repetitions += batch_len;
        batch_len = next_batch_len(batch_len);
        elapsed = start.durationTo(std.Io.Timestamp.now(io, .awake)).nanoseconds;
    }
    return @as(f64, @floatFromInt(elapsed)) / @as(f64, @floatFromInt(repetitions));
}

/// The length of the batch after one of `batch_len`: twice as long, up to `batch_len_max`.
fn next_batch_len(batch_len: usize) usize {
    return @min(batch_len * 2, batch_len_max);
}

/// Times each operation `run_count` times, interleaved: every candidate's first run, then every
/// candidate's second, so a change in the host's load lands on all of them alike (decision 20).
/// `runs[i]` receives operation i's nanoseconds per repetition.
pub fn time_interleaved(io: std.Io, operations: []const Operation, runs: [][run_count]f64) void {
    std.debug.assert(operations.len == runs.len);
    for (operations) |operation| operation.run_once(operation.context);
    for (0..run_count) |run| {
        for (operations, runs) |operation, *operation_runs| operation_runs[run] = time_run(io, operation);
    }
}

/// `time_interleaved`, where each run times the first `rotated_len` operations in another order:
/// run `run` starts at operation `run % rotated_len`, so none of them takes one place in every
/// round. The operations after them keep their places at the end of each round.
pub fn time_rotated(io: std.Io, operations: []const Operation, runs: [][run_count]f64, rotated_len: usize) void {
    std.debug.assert(operations.len == runs.len);
    std.debug.assert(rotated_len <= operations.len);
    for (operations) |operation| operation.run_once(operation.context);
    for (0..run_count) |run| {
        for (0..operations.len) |place| {
            const index = rotated_index(run, place, rotated_len);
            runs[index][run] = time_run(io, operations[index]);
        }
    }
}

/// The operation that run `run` of `time_rotated` times at `place`.
fn rotated_index(run: usize, place: usize, rotated_len: usize) usize {
    if (place >= rotated_len) return place;
    return (place + run) % rotated_len;
}

test "a rotated run times each operation once, and each rotated one a place earlier each run" {
    const operations_len = 5;
    const rotated_len = operations_len - 1;
    for (0..run_count) |run| {
        var seen: [operations_len]bool = @splat(false);
        for (0..operations_len) |place| {
            const index = rotated_index(run, place, rotated_len);
            try std.testing.expect(!seen[index]);
            seen[index] = true;
            // An operation past `rotated_len` keeps its place.
            if (place >= rotated_len) try std.testing.expectEqual(place, index);
        }
        // The run starts one operation later than the run before.
        try std.testing.expectEqual(run % rotated_len, rotated_index(run, 0, rotated_len));
    }
    // With none rotated, each run keeps the order of `time_interleaved`.
    for (0..operations_len) |place| try std.testing.expectEqual(place, rotated_index(run_count - 1, place, 0));
}

/// The additions of the slower operation in the test of `time_rotated`.
const test_additions = 1 << 12;

fn run_nothing(_: *const anyopaque) void {}

fn run_additions(_: *const anyopaque) void {
    var sum: usize = 0;
    for (0..test_additions) |index| sum +%= index;
    std.mem.doNotOptimizeAway(sum);
}

test "time_rotated gives each operation its own time, whatever place a run times it at" {
    const context: u8 = 0;
    const operations = [_]Operation{
        .{ .context = &context, .run_once = run_nothing },
        .{ .context = &context, .run_once = run_additions },
    };
    var runs: [operations.len][run_count]f64 = undefined;
    time_rotated(std.testing.io, &operations, &runs, operations.len);
    for (0..run_count) |run| try std.testing.expect(runs[1][run] > runs[0][run]);
}

/// Megabytes per second for `octets` octets taking `ns` nanoseconds.
pub fn megabytes_per_second(octets: usize, ns: f64) f64 {
    return @as(f64, @floatFromInt(octets)) / octets_per_megabyte / (ns / std.time.ns_per_s);
}

/// Gigabytes per second for `octets` octets taking `ns` nanoseconds.
pub fn gigabytes_per_second(octets: usize, ns: f64) f64 {
    return @as(f64, @floatFromInt(octets)) / octets_per_gigabyte / (ns / std.time.ns_per_s);
}

// Tests.

const testing = std.testing;

test "summarize takes the median and the spread as a share of it" {
    const summary = summarize(.{ 12, 10, 11, 14, 9 });
    try testing.expectEqual(11, summary.median);
    try testing.expectApproxEqAbs(5.0 / 11.0, summary.spread, 1e-9);
}

test "throughput is megabytes or gigabytes, powers of 10 octets, per second" {
    try testing.expectApproxEqAbs(1.0, megabytes_per_second(1_000_000, std.time.ns_per_s), 1e-12);
    try testing.expectApproxEqAbs(2000.0, megabytes_per_second(2_000_000, std.time.ns_per_ms), 1e-9);
    try testing.expectApproxEqAbs(2.0, gigabytes_per_second(2_000_000, std.time.ns_per_ms), 1e-9);
}

const Counter = struct {
    count: usize = 0,

    fn run_once(context: *const anyopaque) void {
        const self: *Counter = @ptrCast(@alignCast(@constCast(context)));
        self.count += 1;
    }
};

test "batches double up to the cap" {
    try testing.expectEqual(2, next_batch_len(1));
    try testing.expectEqual(64, next_batch_len(32));
    try testing.expectEqual(batch_len_max, next_batch_len(batch_len_max / 2));
    try testing.expectEqual(batch_len_max, next_batch_len(batch_len_max / 2 + 1));
    try testing.expectEqual(batch_len_max, next_batch_len(batch_len_max));
}

test "a run times every repetition it made" {
    var counter: Counter = .{};
    const ns = time_run(testing.io, .{ .context = &counter, .run_once = Counter.run_once });
    try testing.expect(ns > 0);
    // The repetitions times the time of each is the run's time: at least the minimum, and no more
    // than the last doubled batch's overshoot allows.
    const total_ns = @as(f64, @floatFromInt(counter.count)) * ns;
    try testing.expect(total_ns >= @as(f64, @floatFromInt(run_ns_min)));
    try testing.expect(total_ns <= @as(f64, @floatFromInt(4 * run_ns_min)));
}
