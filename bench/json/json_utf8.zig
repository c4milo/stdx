//! bench-json's UTF-8 section (decision 38): the json module's `is_utf8`, the check every string's
//! octets go through in the loops, run alone over each string workload's octets, beside simdutf's
//! `validate_utf8`, the way decisions 10, 20 and 21 fix: both interleaved in one run, five runs
//! each, the median and the spread, and the losses listed. Each candidate must judge every buffer
//! as the other does before any is timed.

const std = @import("std");
const timing = @import("timing");
const json = @import("json");
const codec = @import("codec");
const baselines = @import("baselines/baselines.zig");
const workloads = @import("json_workloads.zig");
const Workload = workloads.Workload;

/// The two candidates, in the order the table shows them.
const candidate_count = 2;
const stdx_index = 0;
const simdutf_index = 1;

/// One candidate's validation of one buffer, as a `timing.Operation`.
fn Validate(comptime candidate: usize) type {
    return struct {
        octets: []const u8,
        features: codec.Features,

        fn run_once(context: *const anyopaque) void {
            const self: *const @This() = @ptrCast(@alignCast(context));
            const verdict = if (candidate == stdx_index) json.is_utf8(self.octets, self.features) else baselines.simdutf_validate_utf8(self.octets);
            std.mem.doNotOptimizeAway(verdict);
        }
    };
}

fn operation(arena: std.mem.Allocator, comptime candidate: usize, octets: []const u8) !timing.Operation {
    const state = try arena.create(Validate(candidate));
    state.* = .{ .octets = octets, .features = codec.Features.detect() };
    return .{ .context = state, .run_once = Validate(candidate).run_once };
}

/// Prints the section: every string workload's octets, the raw UTF-8 of each, validated whole.
pub fn report(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, all: []const Workload) !void {
    try out.print("\n## UTF-8 validation against simdutf\n\n", .{});
    try out.print("stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets, beside simdutf 9.2.1's `validate_utf8` in the same run. Each ratio is stdx's throughput over simdutf's; below 1, simdutf is faster. simdutf picks its kernel at run time.\n\n", .{});
    if (!baselines.simdutf_built()) {
        try out.print("simdutf is not built on this host (decision 10).\n", .{});
        return;
    }
    try out.print("| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf |\n|---|---|---|---|---|\n", .{});
    var losses: std.ArrayList([]const u8) = .empty;
    for (all) |*workload| {
        // The string workloads, each one string of a file's octets; the text of `\u` escapes decodes
        // to the same octets as the text it came from, and is left out.
        if (workload.decode_only or workload.items.len != 1 or workload.items[0].len != 1 or workload.items[0][0].token != .string) continue;
        const octets = workload.items[0][0].octets;
        if (json.is_utf8(octets, codec.Features.detect()) != baselines.simdutf_validate_utf8(octets)) return error.CandidatesDiffer;
        var operations = [candidate_count]timing.Operation{ try operation(arena, stdx_index, octets), try operation(arena, simdutf_index, octets) };
        var runs: [candidate_count][timing.run_count]f64 = undefined;
        timing.time_interleaved(io, &operations, &runs);
        var median: [candidate_count]f64 = undefined;
        var spread: [candidate_count]f64 = undefined;
        for (runs, 0..) |candidate_runs, index| {
            const summary = timing.summarize(candidate_runs);
            median[index] = timing.megabytes_per_second(octets.len, summary.median);
            spread[index] = summary.spread;
        }
        const ratio = median[stdx_index] / median[simdutf_index];
        try out.print("| {s} | {d} | {d:.1} ± {d:.1}% | {d:.1} ± {d:.1}% | {d:.3} |\n", .{ workload.name, octets.len, median[stdx_index], spread[stdx_index] * 100, median[simdutf_index], spread[simdutf_index] * 100, ratio });
        // Decision 20's noise floor: the larger of 5% and the two spreads.
        if (ratio < 1 - @max(0.05, @max(spread[stdx_index], spread[simdutf_index]))) try losses.append(arena, try std.fmt.allocPrint(arena, "- {s}: stdx runs at {d:.3} of simdutf.\n", .{ workload.name, ratio }));
        try out.flush();
    }
    try out.print("\n## Losses to simdutf\n\n", .{});
    if (losses.items.len == 0) try out.print("None.\n", .{});
    for (losses.items) |loss| try out.print("{s}", .{loss});
}
