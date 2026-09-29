//! bench-json's UTF-8 section (decisions 38 and 39): the json module's `is_utf8`, the check every
//! string's octets go through in the loops, run alone over each string workload's octets, beside
//! simdutf's `validate_utf8`, the way decisions 10, 20 and 21 fix: every candidate interleaved in
//! one run, five runs each, the median and the spread, and the losses listed. `is_utf8` runs at the
//! width the host's features pick; on a host with AVX-512 it runs a second time with AVX2 alone, so
//! one job compares the two widths. Before any is timed, every copy of the check this CPU runs and
//! simdutf must judge seeded buffers and each workload, whole and with an octet changed, alike: on a
//! runner with AVX-512 that is the only run of its copy, which the M-series host and Rosetta lack.

const std = @import("std");
const timing = @import("timing");
const json = @import("json");
const codec = @import("codec");
const baselines = @import("baselines/baselines.zig");
const workloads = @import("json_workloads.zig");
const Workload = workloads.Workload;

/// The candidates, in the order the table shows them; the third runs only on a host with AVX-512.
const Candidate = enum { stdx, simdutf, stdx_avx2 };
const candidate_count = std.enums.values(Candidate).len;

/// One candidate's validation of one buffer, as a `timing.Operation`.
const Validate = struct {
    octets: []const u8,
    candidate: Candidate,
    features: codec.Features,

    fn run_once(context: *const anyopaque) void {
        const self: *const Validate = @ptrCast(@alignCast(context));
        std.mem.doNotOptimizeAway(self.verdict(self.octets));
    }

    fn verdict(self: *const Validate, octets: []const u8) bool {
        return switch (self.candidate) {
            .simdutf => baselines.simdutf_validate_utf8(octets),
            .stdx, .stdx_avx2 => json.is_utf8(octets, self.features),
        };
    }
};

/// The host's features, and the same with AVX-512 off: `is_utf8`'s copy at AVX2's width.
fn features_of(candidate: Candidate) codec.Features {
    var features = codec.Features.detect();
    if (candidate == .stdx_avx2) features.avx512 = false;
    return features;
}

/// The candidates this host runs: the third where the host has AVX-512.
fn candidates_run() []const Candidate {
    const all = comptime std.enums.values(Candidate);
    return if (codec.Features.detect().avx512) all else all[0 .. candidate_count - 1];
}

/// Seeded buffers the cross-check judges: their count and longest length, past the widest copy's
/// groups of 256 octets, and the share of them with an octet drawn at random.
const cross_check_buffers = 20000;
const cross_check_len_max = 1100;
const random_octet_per_mille = 5;
const per_mille = 1000;

/// A character of 1 to 4 octets drawn from the ranges RFC 3629 §4 allows, or with `random_octets`
/// now and then any octet at all.
fn draw(random: std.Random, random_octets: bool, out: []u8) usize {
    if (random_octets and random.uintLessThan(u32, per_mille) < random_octet_per_mille) {
        out[0] = random.int(u8);
        return 1;
    }
    const code_point: u21 = switch (random.uintLessThan(u8, 8)) {
        0 => random.intRangeLessThan(u21, 0x80, 0x800),
        1 => random.intRangeLessThan(u21, 0x800, 0xd800),
        2 => random.intRangeLessThan(u21, 0xe000, 0x10000),
        3 => random.intRangeLessThan(u21, 0x10000, 0x110000),
        else => random.intRangeLessThan(u21, 0x20, 0x7f),
    };
    return std.unicode.utf8Encode(code_point, out) catch unreachable;
}

/// Requires every candidate this host runs, and `is_utf8` with no features, the module's own 16
/// lanes, to judge `octets` alike.
fn expect_alike(octets: []const u8) !void {
    const reference = json.is_utf8(octets, codec.Features.none());
    for (candidates_run()) |candidate| {
        if (candidate == .simdutf and !baselines.simdutf_built()) continue;
        const validate: Validate = .{ .octets = octets, .candidate = candidate, .features = features_of(candidate) };
        if (validate.verdict(octets) == reference) continue;
        std.debug.print("bench-json: {t} judges {d} octets {} and the module's own 16 lanes {}\n", .{ candidate, octets.len, !reference, reference });
        return error.CandidatesDiffer;
    }
}

/// The cross-check: seeded buffers of characters, half with random octets among them, then each
/// workload whole and with its middle octet and its last changed.
fn cross_check(arena: std.mem.Allocator, strings: []const []const u8) !void {
    var prng = std.Random.DefaultPrng.init(0x38_39);
    const random = prng.random();
    const buffer = try arena.alloc(u8, cross_check_len_max + json.constants.utf8_len_max);
    for (0..cross_check_buffers) |index| {
        const len_wanted = random.uintAtMost(usize, cross_check_len_max);
        var len: usize = 0;
        while (len < len_wanted) len += draw(random, index % 2 == 0, buffer[len..]);
        try expect_alike(buffer[0..len]);
    }
    for (strings) |octets| {
        try expect_alike(octets);
        if (octets.len == 0) continue;
        const changed = try arena.dupe(u8, octets);
        for ([_]usize{ changed.len / 2, changed.len - 1 }) |at| {
            const kept = changed[at];
            changed[at] = 0x80;
            try expect_alike(changed);
            changed[at] = kept;
        }
    }
}

/// The octets of each string workload: one string of a file's octets. The text of `\u` escapes
/// decodes to the same octets as the text it came from, and is left out.
fn strings_of(arena: std.mem.Allocator, all: []const Workload) ![]const []const u8 {
    var strings: std.ArrayList([]const u8) = .empty;
    for (all) |*workload| {
        if (workload.decode_only or workload.items.len != 1 or workload.items[0].len != 1 or workload.items[0][0].token != .string) continue;
        try strings.append(arena, workload.items[0][0].octets);
    }
    return strings.items;
}

/// Prints the section: every string workload's octets, the raw UTF-8 of each, validated whole.
pub fn report(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, all: []const Workload) !void {
    try out.print("\n## UTF-8 validation against simdutf\n\n", .{});
    try out.print("stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.2.1's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged {d} seeded buffers and each workload, whole and changed, alike.\n\n", .{cross_check_buffers});
    if (!baselines.simdutf_built()) {
        try out.print("simdutf is not built on this host (decision 10).\n", .{});
        return;
    }
    const strings = try strings_of(arena, all);
    try cross_check(arena, strings);
    try out.print("| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |\n|---|---|---|---|---|---|---|\n", .{});
    var losses: std.ArrayList([]const u8) = .empty;
    var string_index: usize = 0;
    for (all) |*workload| {
        if (workload.decode_only or workload.items.len != 1 or workload.items[0].len != 1 or workload.items[0][0].token != .string) continue;
        const octets = strings[string_index];
        string_index += 1;
        const row = try time_row(arena, io, octets);
        try print_row(out, workload.name, octets.len, row);
        // Decision 20's noise floor: the larger of 5% and the two spreads.
        const ratio = row.median[@intFromEnum(Candidate.stdx)] / row.median[@intFromEnum(Candidate.simdutf)];
        if (ratio < 1 - @max(0.05, @max(row.spread[@intFromEnum(Candidate.stdx)], row.spread[@intFromEnum(Candidate.simdutf)]))) try losses.append(arena, try std.fmt.allocPrint(arena, "- {s}: stdx runs at {d:.3} of simdutf.\n", .{ workload.name, ratio }));
        try out.flush();
    }
    try out.print("\n## Losses to simdutf\n\n", .{});
    if (losses.items.len == 0) try out.print("None.\n", .{});
    for (losses.items) |loss| try out.print("{s}", .{loss});
}

/// One workload's medians and spreads, by `Candidate`; a candidate this host does not run is 0.
const Row = struct { median: [candidate_count]f64 = @splat(0), spread: [candidate_count]f64 = @splat(0) };

fn time_row(arena: std.mem.Allocator, io: std.Io, octets: []const u8) !Row {
    const run = candidates_run();
    var operations: [candidate_count]timing.Operation = undefined;
    for (run, 0..) |candidate, index| {
        const state = try arena.create(Validate);
        state.* = .{ .octets = octets, .candidate = candidate, .features = features_of(candidate) };
        operations[index] = .{ .context = state, .run_once = Validate.run_once };
    }
    var runs: [candidate_count][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, operations[0..run.len], runs[0..run.len]);
    var row: Row = .{};
    for (run, runs[0..run.len]) |candidate, candidate_runs| {
        const summary = timing.summarize(candidate_runs);
        row.median[@intFromEnum(candidate)] = timing.megabytes_per_second(octets.len, summary.median);
        row.spread[@intFromEnum(candidate)] = summary.spread;
    }
    return row;
}

fn print_row(out: *std.Io.Writer, name: []const u8, len: usize, row: Row) !void {
    const stdx = @intFromEnum(Candidate.stdx);
    const simdutf = @intFromEnum(Candidate.simdutf);
    const avx2 = @intFromEnum(Candidate.stdx_avx2);
    try out.print("| {s} | {d} | {d:.1} ± {d:.1}% | {d:.1} ± {d:.1}% | {d:.3} |", .{ name, len, row.median[stdx], row.spread[stdx] * 100, row.median[simdutf], row.spread[simdutf] * 100, row.median[stdx] / row.median[simdutf] });
    if (row.median[avx2] == 0) return out.print(" — | — |\n", .{});
    try out.print(" {d:.1} ± {d:.1}% | {d:.3} |\n", .{ row.median[avx2], row.spread[avx2] * 100, row.median[stdx] / row.median[avx2] });
}
