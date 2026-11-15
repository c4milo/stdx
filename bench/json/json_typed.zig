//! bench-json's table of a dependent's message shapes, the workloads named `messages:`,
//! through `TextWriter`'s methods against serde_json's typed code: the messages' fields as Rust
//! types, serialized by code of the form serde's derive generates, as Buffa writes them
//! (bench/json/rust; decision 81). The token baselines of baselines.zig drive
//! serde_json from tokens, a cost a typed caller does not pay.
//!
//! Both write every message of a workload, one text after another, timed interleaved: the median
//! of five runs and the spread. Each must write the same octets.

const std = @import("std");
const timing = @import("timing");
const json = @import("json");
const codec = @import("codec");
const abi = @import("abi");
const workloads = @import("json_workloads.zig");
const baselines = @import("baselines/baselines.zig");
const calls = @import("json_calls.zig");
const Workload = workloads.Workload;

extern fn stdx_bench_serde_built() c_int;
extern fn stdx_bench_serde_typed_new() ?*anyopaque;
extern fn stdx_bench_serde_typed_add(typed: *anyopaque, tokens: [*]const abi.Token, len: usize) c_int;
extern fn stdx_bench_serde_typed_encode(typed: *const anyopaque, out: [*]u8, out_len: usize) usize;
extern fn stdx_bench_serde_typed_free(typed: *anyopaque) void;

/// The prefix of the workloads this table takes.
const prefix = "messages:";

/// serde_json's typed messages and the room it writes them into.
const Serde = struct {
    typed: *anyopaque,
    output: []u8,

    fn run_once(context: *const anyopaque) void {
        const self: *const Serde = @ptrCast(@alignCast(context));
        std.mem.doNotOptimizeAway(stdx_bench_serde_typed_encode(self.typed, self.output.ptr, self.output.len));
    }
};

/// Prints the table, or says why it has no rows.
pub fn report(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, all: []const Workload) !void {
    try out.print("\n## Messages against serde_json's typed code\n\n", .{});
    if (stdx_bench_serde_built() == 0) return out.print("serde_json is not built on this host.\n", .{});
    try out.print("stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.\n\n", .{});
    try out.print("| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |\n|---|---|---|---|---|\n", .{});
    for (all) |*workload| {
        if (!std.mem.startsWith(u8, workload.name, prefix)) continue;
        try row(arena, io, out, workload);
        try out.flush();
    }
}

fn row(arena: std.mem.Allocator, io: std.Io, out: *std.Io.Writer, workload: *const Workload) !void {
    var baseline_memory: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer baseline_memory.deinit();
    var prepared = try baselines.prepare(baseline_memory.allocator(), workload);
    defer prepared.deinit();
    const typed = stdx_bench_serde_typed_new() orelse return error.BaselineRefused;
    defer stdx_bench_serde_typed_free(typed);
    for (prepared.tokens) |tokens| {
        if (stdx_bench_serde_typed_add(typed, tokens.ptr, tokens.len) != 0) return error.BaselineRefused;
    }
    var output_len: usize = 0;
    for (workload.items) |items| output_len += workloads.encoded_len_max(items);
    const features = codec.Features.detect();
    const stdx_output = try arena.alloc(u8, output_len);
    const serde_output = try arena.alloc(u8, output_len);
    const stdx_len = calls.encode(.{}, .methods, workload, stdx_output, features);
    const serde_len = stdx_bench_serde_typed_encode(typed, serde_output.ptr, serde_output.len);
    if (!std.mem.eql(u8, stdx_output[0..stdx_len], serde_output[0..serde_len])) return error.CandidatesDiffer;
    const methods = try arena.create(calls.Encode(.{}, .methods));
    methods.* = .{ .workload = workload, .output = stdx_output, .features = features };
    const serde: Serde = .{ .typed = typed, .output = serde_output };
    const operations = [_]timing.Operation{
        .{ .context = methods, .run_once = calls.Encode(.{}, .methods).run_once },
        .{ .context = &serde, .run_once = Serde.run_once },
    };
    var runs: [operations.len][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &operations, &runs);
    const stdx_rate = timing.summarize(rates(runs[0], stdx_len));
    const serde_rate = timing.summarize(rates(runs[1], serde_len));
    try out.print("| {s} | {d} | {d:.1} ± {d:.1}% | {d:.1} ± {d:.1}% | {d:.3} |\n", .{ workload.name, stdx_len, stdx_rate.median, stdx_rate.spread * 100, serde_rate.median, serde_rate.spread * 100, stdx_rate.median / serde_rate.median });
}

/// Each run's throughput, in MB/s, from its time in nanoseconds.
fn rates(runs: [timing.run_count]f64, octets: usize) [timing.run_count]f64 {
    var out: [timing.run_count]f64 = undefined;
    for (runs, &out) |ns, *rate| rate.* = timing.megabytes_per_second(octets, ns);
    return out;
}
