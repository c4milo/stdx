//! costs: the microbenchmarks behind docs/costs.md (design §8 step 2, decisions 14 and 20).
//!
//! Each row measures one machine operation that a speed claim of decision 14 prices itself
//! against. Each is run `run_count` times, and a row prints the median time per operation and the
//! spread: the gap between the slowest and the fastest run, as a share of the median.
//!
//! The benchmark is built ReleaseFast. It measures what the machine does, and a bounds check in
//! the measured loop would add its own cost to every row. The library is never built this way
//! (decision 17); this program is a measuring device.
//!
//! Usage: `costs`. It prints one Markdown table row per cost to standard output. The workflow of
//! decision 20 pins it to one core and records the run beside the table.

const std = @import("std");

/// Runs per row; decision 10 reports the median of five.
pub const run_count = 5;

/// Octets in the L1-resident chain: small enough for any L1 data cache stdx runs on.
const l1_chain_len = 16 << 10;

/// Octets in the chain that misses every cache level: far past any last-level cache.
const memory_chain_len = 1 << 30;

/// Octets between two nodes of the memory chain: one cache line each.
const cache_line_len = 64;

/// Loads per timed run of a chain.
const chain_steps = 20_000_000;

/// Branches per timed run, over a table of this many entries.
const branch_steps = 50_000_000;
const branch_table_len = 1 << 20;

/// Copies per timed run.
const small_copy_len = 64;
const small_copy_steps = 50_000_000;
const large_copy_len = 32 << 10;
const large_copy_steps = 100_000;

/// Refills per timed run, over an L1-resident input.
const refill_input_len = 16 << 10;
const refill_steps = 50_000_000;

/// Vector compares per timed run.
const vector_len = 32;
const vector_steps = 50_000_000;

/// The seed of every table this program draws. Fixed, so every run measures the same tables.
const seed = 0x5eed_c057;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    var random_state = std.Random.DefaultPrng.init(seed);
    const random = random_state.random();

    var stdout_buffer: [4096]u8 = undefined;
    // Streaming, not positional: when stdout is a file the caller already wrote to, a positional
    // writer starts at offset 0 and overwrites what bench/costs/run.sh put before the table.
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;
    try out.print("| Cost | Median, ns | Spread |\n|---|---|---|\n", .{});

    const l1_chain = try build_chain(gpa, random, l1_chain_len / @sizeOf(u32), 1);
    defer gpa.free(l1_chain);
    try report(out, "An L1 hit", try measure(io, l1_chain, chase, chain_steps));

    const memory_chain = try build_chain(gpa, random, memory_chain_len / cache_line_len, cache_line_len / @sizeOf(u32));
    defer gpa.free(memory_chain);
    try report(out, "A cache miss to main memory", try measure(io, memory_chain, chase, chain_steps));

    const branches = try Branches.init(gpa, random);
    defer branches.deinit(gpa);
    const random_ns = try measure(io, branches.random_bits, branch_on, branch_steps);
    const zeros_ns = try measure(io, branches.zero_bits, branch_on, branch_steps);
    const straight_ns = try measure(io, branches.zero_bits, no_branch, branch_steps);
    // Half of the random branches mispredict, so the difference per branch is half a mispredict.
    try report(out, "A branch mispredict", difference(random_ns, zeros_ns, 2));
    try report(out, "A predicted branch", difference(zeros_ns, straight_ns, 1));

    const copies = try Copies.init(gpa, random);
    defer copies.deinit(gpa);
    try report(out, "A copy of 64 octets", try measure(io, copies, copy_small, small_copy_steps));
    try report(out, "A copy of 32 KiB", try measure(io, copies, copy_large, large_copy_steps));

    const refill_input = try gpa.alloc(u8, refill_input_len);
    defer gpa.free(refill_input);
    random.bytes(refill_input);
    try report(out, "A 64-bit bit-buffer refill", try measure(io, refill_input, refill, refill_steps));

    try report(out, "A 32-octet vector compare", try measure(io, copies, compare_vectors, vector_steps));
    try out.flush();
}

/// A row's runs: the time per operation of each.
const Runs = [run_count]f64;

/// Times `run_count` runs of `body(context, steps)` and returns each run's nanoseconds per step.
fn measure(io: std.Io, context: anytype, comptime body: anytype, steps: usize) !Runs {
    var runs: Runs = undefined;
    // One untimed run warms the caches, the branch predictors and the page tables.
    std.mem.doNotOptimizeAway(body(context, steps));
    for (&runs) |*run| {
        const start = std.Io.Timestamp.now(io, .awake);
        std.mem.doNotOptimizeAway(body(context, steps));
        const elapsed = start.durationTo(std.Io.Timestamp.now(io, .awake));
        run.* = @as(f64, @floatFromInt(elapsed.nanoseconds)) / @as(f64, @floatFromInt(steps));
    }
    return runs;
}

/// The per-run difference between two rows, divided by `divisor`.
fn difference(minuend: Runs, subtrahend: Runs, divisor: f64) Runs {
    var runs: Runs = undefined;
    for (&runs, minuend, subtrahend) |*run, left, right| run.* = (left - right) * divisor;
    return runs;
}

/// The median of the runs and their spread: the slowest minus the fastest, as a share of the
/// median.
pub const Summary = struct { median: f64, spread: f64 };

pub fn summarize(runs: Runs) Summary {
    var sorted = runs;
    std.mem.sort(f64, &sorted, {}, std.sort.asc(f64));
    const median = sorted[run_count / 2];
    const range = sorted[run_count - 1] - sorted[0];
    return .{ .median = median, .spread = if (median == 0) 0 else @abs(range / median) };
}

fn report(out: *std.Io.Writer, name: []const u8, runs: Runs) !void {
    const summary = summarize(runs);
    try out.print("| {s} | {d:.2} | {d:.1}% |\n", .{ name, summary.median, summary.spread * 100 });
}

/// A cycle through `node_count` nodes in a shuffled order, one node every `stride` words, so each
/// step of `chase` waits for the load before it. Each node links to the next in the shuffled order
/// and the last to the first, which makes one cycle through every node whatever the shuffle.
fn build_chain(gpa: std.mem.Allocator, random: std.Random, node_count: usize, stride: usize) ![]u32 {
    const order = try gpa.alloc(u32, node_count);
    defer gpa.free(order);
    for (order, 0..) |*node, index| node.* = @intCast(index);
    var index = node_count - 1;
    while (index > 0) : (index -= 1) {
        const other = random.uintLessThan(usize, index + 1);
        std.mem.swap(u32, &order[index], &order[other]);
    }
    const words = try gpa.alloc(u32, node_count * stride);
    @memset(words, 0);
    for (order, 0..) |node, position| {
        const next = order[(position + 1) % node_count];
        words[@as(usize, node) * stride] = next * @as(u32, @intCast(stride));
    }
    return words;
}

fn chase(words: []const u32, steps: usize) u32 {
    var word: u32 = 0;
    for (0..steps) |_| word = words[word];
    return word;
}

const Branches = struct {
    random_bits: []u8,
    zero_bits: []u8,

    fn init(gpa: std.mem.Allocator, random: std.Random) !Branches {
        const random_bits = try gpa.alloc(u8, branch_table_len);
        for (random_bits) |*bit| bit.* = random.int(u1);
        const zero_bits = try gpa.alloc(u8, branch_table_len);
        @memset(zero_bits, 0);
        return .{ .random_bits = random_bits, .zero_bits = zero_bits };
    }

    fn deinit(self: Branches, gpa: std.mem.Allocator) void {
        gpa.free(self.random_bits);
        gpa.free(self.zero_bits);
    }
};

// Each side of the branch is a call the compiler may not inline, so it cannot turn the branch
// into a conditional move.
noinline fn taken(value: u64) u64 {
    return value +% 0x9e3779b97f4a7c15;
}

noinline fn not_taken(value: u64) u64 {
    return value ^ 0x5bd1e995;
}

fn branch_on(bits: []const u8, steps: usize) u64 {
    var value: u64 = 0;
    for (0..steps) |step| {
        value = if (bits[step & (branch_table_len - 1)] != 0) taken(value) else not_taken(value);
    }
    return value;
}

/// The loop of `branch_on` with the branch replaced by arithmetic on the same load: it reads the
/// same octet and makes one call per step, so the difference is the compare and the branch.
fn no_branch(bits: []const u8, steps: usize) u64 {
    var value: u64 = 0;
    for (0..steps) |step| {
        value = not_taken(value +% bits[step & (branch_table_len - 1)]);
    }
    return value;
}

const Copies = struct {
    source: []u8,
    destination: []u8,

    fn init(gpa: std.mem.Allocator, random: std.Random) !Copies {
        const source = try gpa.alloc(u8, large_copy_len + vector_len);
        random.bytes(source);
        const destination = try gpa.alloc(u8, large_copy_len + vector_len);
        @memcpy(destination, source);
        // One octet in every 97 differs, so the vector compare finds a difference at varying
        // positions.
        var index: usize = 0;
        while (index < destination.len) : (index += 97) destination[index] +%= 1;
        return .{ .source = source, .destination = destination };
    }

    fn deinit(self: Copies, gpa: std.mem.Allocator) void {
        gpa.free(self.source);
        gpa.free(self.destination);
    }
};

fn copy_small(copies: Copies, steps: usize) u8 {
    const mask = (4 << 10) - 1;
    for (0..steps) |step| {
        const offset = (step * small_copy_len) & mask;
        @memcpy(copies.destination[offset..][0..small_copy_len], copies.source[offset..][0..small_copy_len]);
        std.mem.doNotOptimizeAway(copies.destination.ptr);
    }
    return copies.destination[0];
}

fn copy_large(copies: Copies, steps: usize) u8 {
    for (0..steps) |_| {
        @memcpy(copies.destination[0..large_copy_len], copies.source[0..large_copy_len]);
        std.mem.doNotOptimizeAway(copies.destination.ptr);
    }
    return copies.destination[0];
}

/// A refill of claim S1 followed by a consume of 7 to 22 bits, the width a symbol and its extra
/// bits take, so the refill cannot be hoisted out of the loop.
fn refill(input: []const u8, steps: usize) u64 {
    var bits: u64 = 0;
    var count: u6 = 0;
    var position: usize = 0;
    var sum: u64 = 0;
    for (0..steps) |_| {
        bits |= std.mem.readInt(u64, input[position..][0..8], .little) << count;
        position += (63 - @as(usize, count)) >> 3;
        count |= 56;
        const take: u6 = 7 + @as(u6, @truncate(bits & 15));
        sum +%= bits & ((@as(u64, 1) << take) - 1);
        bits >>= take;
        count -= take;
        if (position + 8 > input.len) position = 0;
    }
    return sum;
}

fn compare_vectors(copies: Copies, steps: usize) u32 {
    const mask = large_copy_len - 1;
    var sum: u32 = 0;
    for (0..steps) |step| {
        const offset = (step * 7) & mask;
        const left: @Vector(vector_len, u8) = copies.source[offset..][0..vector_len].*;
        const right: @Vector(vector_len, u8) = copies.destination[offset..][0..vector_len].*;
        const equal: u32 = @bitCast(left == right);
        sum +%= @ctz(~equal);
    }
    return sum;
}

// Tests.

const testing = std.testing;

test "summarize takes the median and the spread as a share of it" {
    const summary = summarize(.{ 12, 10, 11, 14, 9 });
    try testing.expectEqual(11, summary.median);
    try testing.expectApproxEqAbs(5.0 / 11.0, summary.spread, 1e-9);
}

test "a chain is one cycle through every node" {
    var random_state = std.Random.DefaultPrng.init(seed);
    const chain = try build_chain(testing.allocator, random_state.random(), 64, 4);
    defer testing.allocator.free(chain);
    var word: u32 = 0;
    var steps: usize = 0;
    while (true) {
        word = chain[word];
        steps += 1;
        if (word == 0) break;
        try testing.expect(steps < 64);
    }
    try testing.expectEqual(64, steps);
}

test "the refill loop reads inside its input" {
    var input: [refill_input_len]u8 = @splat(0xa5);
    std.mem.doNotOptimizeAway(refill(&input, 100_000));
}
