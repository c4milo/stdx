//! bench-json's `--profile` mode, which `zig build bench-profile` runs (design §8 step 17): the
//! hardware counters of stdx's JSON decoder and encoder and of the baselines, per token and per
//! octet, over one workload of each shape. It shows how many instructions and branch misses each
//! spends on a token, the costs decision 30's structural index is priced against.
//!
//! Each operation is one bench-json times, built and checked the same way (json.zig). It runs
//! once, then as many times as it takes to count `counted_len_min` octets, between the counters of
//! bench/timing/counters.zig.

const std = @import("std");
const timing = @import("timing");
const baselines = @import("baselines/baselines.zig");
const workloads = @import("json_workloads.zig");
const Workload = workloads.Workload;
const counters = timing.counters;

const mebibyte = 1 << 20;

/// The octets each operation counts, at least, over as many runs as that takes.
const counted_len_min = 16 * mebibyte;

/// The workloads the profile counts, by the start of their names: CLDR's texts, the qlog-shaped
/// log, an English text as a string, a JSON text as a string, the non-ASCII text and a hex string.
const profiled = [_][]const u8{
    "CLDR",
    "qlog",
    "string: silesia/dickens",
    "string: http/json-1m",
    "string: dickens as",
    "hex: silesia/dickens",
};

/// Where the operations the profile counts stand in a side's operations: stdx with every claim
/// on, stdx with every claim off, and the first baseline, which the others follow in
/// `baselines.names` order.
pub const Places = struct { all_on: usize, all_off: usize, first_baseline: usize };

/// Whether the profile counts `workload`.
pub fn is_profiled(workload: *const Workload) bool {
    for (profiled) |prefix| {
        if (std.mem.startsWith(u8, workload.name, prefix)) return true;
    }
    return false;
}

/// The tokens of every text of `workload`, as stdx's decoder reads them and its encoder takes them.
fn tokens_of(workload: *const Workload) usize {
    var tokens: usize = 0;
    for (workload.items) |items| tokens += items.len;
    return tokens;
}

/// Prints the line a host without the counters gets instead of the tables.
pub fn unavailable(out: *std.Io.Writer, reason: []const u8) !void {
    try out.print("\n## Hardware counters per JSON token\n\nHardware counters are unavailable: {s}.\n", .{reason});
}

pub fn header(out: *std.Io.Writer, side: []const u8) !void {
    try out.print("\n## Hardware counters per JSON token, {s}\n\n", .{side});
    try out.print("A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over {d} MiB at least.\n\n", .{counted_len_min / mebibyte});
    try out.print("| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |\n", .{});
    try out.print("|---|---|---|---|---|---|---|---|---|\n", .{});
}

/// Counts stdx with every claim on and off, and each baseline this host builds, over one side of
/// `workload`, whose runs each count `octets`, and prints a row for each.
pub fn rows(out: *std.Io.Writer, open: *const counters.Counters, workload: *const Workload, operations: []const timing.Operation, octets: usize, places: Places) !void {
    try row(out, open, workload, operations[places.all_on], octets, "stdx, every claim on");
    try row(out, open, workload, operations[places.all_off], octets, "stdx, every claim off");
    for (baselines.names, baselines.built(), 0..) |name, is_built, index| {
        if (is_built) try row(out, open, workload, operations[places.first_baseline + index], octets, name);
    }
}

fn row(out: *std.Io.Writer, open: *const counters.Counters, workload: *const Workload, operation: timing.Operation, octets: usize, name: []const u8) !void {
    const rounds = @max(1, counted_len_min / @max(1, octets));
    operation.run_once(operation.context);
    open.start();
    for (0..rounds) |_| operation.run_once(operation.context);
    const counts = open.stop();
    const tokens: f64 = @floatFromInt(rounds * tokens_of(workload));
    const counted: f64 = @floatFromInt(rounds * octets);
    const cycles: f64 = @floatFromInt(counts[counters.cycles]);
    const instructions: f64 = @floatFromInt(counts[counters.instructions]);
    const misses: f64 = @floatFromInt(counts[counters.branch_misses]);
    try out.print("| {s} | {d} | {d} | {s} | {d:.1} | {d:.1} | {d:.3} | {d:.2} | {d:.2} |\n", .{
        workload.name,                  tokens_of(workload),   octets,          name,
        cycles / tokens,                instructions / tokens, misses / tokens, cycles / counted,
        instructions / @max(1, cycles),
    });
}
