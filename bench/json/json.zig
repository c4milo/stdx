//! bench-json: the json module's vector paths, claims J1, J2, J3 and J5 of decision 27, their
//! widths, claim J7 of decision 29, and its fast paths, claims J8 and J9 of decision 30, each off
//! against all on, measured the way
//! decisions 10, 20 and 21 fix: every candidate in this one program, interleaved in the same run,
//! five runs each, the median and the spread reported, and the losses shown. The timing is
//! bench/timing/timing.zig's.
//!
//! The candidates, per workload of json_workloads.zig:
//! - every claim on, as `encode` and `decode` run;
//! - each claim off in turn;
//! - every claim off: the scalar and checked paths alone, the reference (decision 16) and the
//!   baseline each vector path and the fast path are priced against.
//!
//! Decoding counts the text's octets; encoding counts the octets it writes. Every candidate's
//! output is compared with the reference's before any is timed. The timed decode counts each token
//! into a tally, the work the baselines do too.
//!
//! simdjson, yyjson and Zig's std.json run in the same interleaved run, after the candidates
//! (baselines/baselines.zig, decision 27).
//!
//! stdx is built for the architecture's baseline CPU and ReleaseSafe, as a caller shipping one
//! binary builds it (decisions 17 and 21), so the vectors are SSE2's and NEON's 16 octets.
//!
//! Usage: `bench_json [--profile] <name>=<path>... cldr=<directory>`. It prints Markdown tables to
//! standard output. With `--profile`, it counts the hardware counters of json_profile.zig instead
//! of timing.

const std = @import("std");
const timing = @import("timing");
const json = @import("json");
const codec = @import("codec");
const abi = @import("abi");
const workloads = @import("json_workloads.zig");
const baselines = @import("baselines/baselines.zig");
const json_profile = @import("json_profile.zig");
const Item = workloads.Item;
const Workload = workloads.Workload;

/// The candidates: every claim on, each off in turn, and every claim off.
const candidates = [_]json.Claims{.{}} ++ json.claims.each_off ++ [_]json.Claims{json.claims.scalar};
const candidate_count = candidates.len;
/// Where the candidate with every claim off stands in `candidates`.
const scalar_index = candidate_count - 1;
/// Every operation a workload's run times: the candidates, then the baselines.
const operation_count = candidate_count + baselines.count;

comptime {
    // The workloads' own calls must not share a candidate's codec (`encode` below).
    for (candidates) |claims| std.debug.assert(!std.meta.eql(claims, workloads.setup_claims));
}

/// The claims each side runs, by their place in `json.claims.each_off`: the decoder takes J3, J5,
/// J7 and J8, and the encoder J1, J2, J5, J7 and J9.
const decoder_claims = [_]usize{ 2, 3, 4, 5 };
const encoder_claims = [_]usize{ 0, 1, 3, 4, 6 };

/// A decode of every text of a workload by a candidate, one token a call.
fn Decode(comptime claims: json.Claims) type {
    return struct {
        const Self = @This();
        workload: *const Workload,
        output: []u8,
        features: codec.Features,

        fn run_once(context: *const anyopaque) void {
            const self: *const Self = @ptrCast(@alignCast(context));
            std.mem.doNotOptimizeAway(decode(claims, self.workload, self.output, self.features));
        }
    };
}

/// Decodes every text of `workload` and returns the tally of its tokens.
fn decode(comptime claims: json.Claims, workload: *const Workload, output: []u8, features: codec.Features) abi.Tally {
    var tally: abi.Tally = .{};
    for (workload.texts) |text| {
        var decoder: json.Decoder = undefined;
        decoder.init(workload.framing, features);
        var consumed: usize = 0;
        for (0..text.len + 2) |_| {
            // Inline, so every candidate's loop takes the same shape (below, in `encode`).
            const progress = @call(.always_inline, json.Decoder.decode_with, .{ &decoder, claims, text[consumed..], output, .last }) catch unreachable;
            consumed += progress.consumed;
            switch (progress.status) {
                .token => baselines.count_token(&tally, progress.kind.?, progress.written),
                .done => break,
                .needs_input, .needs_room => unreachable,
            }
        } else unreachable;
        std.debug.assert(consumed == text.len);
    }
    return tally;
}

/// Decodes every text of `workload` and returns a hash of its tokens, so candidates compare
/// before any is timed.
fn tokens_hash(comptime claims: json.Claims, workload: *const Workload, output: []u8, features: codec.Features) u64 {
    var hash = std.hash.Wyhash.init(0);
    for (workload.texts) |text| {
        var decoder: json.Decoder = undefined;
        decoder.init(workload.framing, features);
        var consumed: usize = 0;
        for (0..text.len + 2) |_| {
            // Inline, so every candidate's loop takes the same shape (below, in `encode`).
            const progress = @call(.always_inline, json.Decoder.decode_with, .{ &decoder, claims, text[consumed..], output, .last }) catch unreachable;
            consumed += progress.consumed;
            switch (progress.status) {
                .token => {
                    hash.update(&.{@intFromEnum(progress.kind.?)});
                    hash.update(output[0..progress.written]);
                },
                .done => break,
                .needs_input, .needs_room => unreachable,
            }
        } else unreachable;
        std.debug.assert(consumed == text.len);
    }
    return hash.final();
}

/// An encode of every text of a workload by a candidate, one call a token.
fn Encode(comptime claims: json.Claims) type {
    return struct {
        const Self = @This();
        workload: *const Workload,
        output: []u8,
        features: codec.Features,

        fn run_once(context: *const anyopaque) void {
            const self: *const Self = @ptrCast(@alignCast(context));
            std.mem.doNotOptimizeAway(encode(claims, self.workload, self.output, self.features));
        }
    };
}

/// Encodes every text of `workload` into `output` and returns how many octets it wrote.
fn encode(comptime claims: json.Claims, workload: *const Workload, output: []u8, features: codec.Features) usize {
    var written: usize = 0;
    for (workload.items) |items| {
        var encoder: json.Encoder = undefined;
        encoder.init(workload.framing, features);
        for (items) |item| {
            // Inline, so every candidate's loop takes the same shape. LLVM inlines a codec by how
            // many callers it has, and in bench run 36411317000 the workloads' own calls gave two
            // candidates a second one: every claim on read CLDR's texts, and every claim off built
            // the others. Those two alone called their codec once a token, and the ratios on texts
            // of short tokens measured that call, not the claims. The workloads now take
            // `setup_claims`.
            const progress = @call(.always_inline, json.Encoder.encode_with, .{ &encoder, claims, item.token, item.octets, output[written..] }) catch unreachable;
            written += progress.written;
        }
        std.debug.assert(encoder.is_done());
    }
    return written;
}

/// The median throughput of each operation, in MB/s, and its spread, a share of the median.
const Rates = struct { median: [operation_count]f64, spread: [operation_count]f64 };

fn rates_of(runs: *const [operation_count][timing.run_count]f64, octets: usize) Rates {
    var rates: Rates = undefined;
    for (runs, 0..) |candidate_runs, index| {
        const summary = timing.summarize(candidate_runs);
        rates.median[index] = timing.megabytes_per_second(octets, summary.median);
        rates.spread[index] = summary.spread;
    }
    return rates;
}

/// One side of one workload: every operation, checked against the reference before any runs, and
/// the octets one run of each counts.
const Side = struct {
    operations: [operation_count]timing.Operation,
    octets: usize,
};

/// The decoding side of `workload`: each candidate must count the tokens the reference counts and
/// write the same octets for them, and each baseline, whose inputs `prepared` holds, must count
/// them too.
fn decoding(arena: std.mem.Allocator, workload: *const Workload, prepared: *const baselines.Prepared) !Side {
    const output = try arena.alloc(u8, @max(workload.content_len_max, 1));
    const features = codec.Features.detect();
    var side: Side = .{ .operations = undefined, .octets = workload.octets };
    const reference = decode(json.claims.scalar, workload, output, features);
    const reference_hash = tokens_hash(json.claims.scalar, workload, output, features);
    inline for (candidates, 0..) |claims, index| {
        const state = try arena.create(Decode(claims));
        state.* = .{ .workload = workload, .output = output, .features = features };
        if (!std.meta.eql(decode(claims, workload, output, features), reference)) return error.CandidatesDiffer;
        if (tokens_hash(claims, workload, output, features) != reference_hash) return error.CandidatesDiffer;
        side.operations[index] = .{ .context = state, .run_once = Decode(claims).run_once };
    }
    side.operations[candidate_count..].* = try baselines.decode_operations(prepared, reference);
    return side;
}

/// The encoding side of `workload`: each candidate must write the reference's octets, and each
/// baseline's text must decode to what the reference's does.
fn encoding(arena: std.mem.Allocator, workload: *const Workload, prepared: *const baselines.Prepared) !Side {
    var output_len: usize = 0;
    for (workload.items) |items| output_len += workloads.encoded_len_max(items);
    const output = try arena.alloc(u8, output_len);
    const features = codec.Features.detect();
    const reference = try arena.dupe(u8, output[0..encode(json.claims.scalar, workload, output, features)]);
    var side: Side = .{ .operations = undefined, .octets = reference.len };
    inline for (candidates, 0..) |claims, index| {
        const state = try arena.create(Encode(claims));
        state.* = .{ .workload = workload, .output = output, .features = features };
        const len = encode(claims, workload, output, features);
        if (!std.mem.eql(u8, reference, output[0..len])) return error.CandidatesDiffer;
        side.operations[index] = .{ .context = state, .run_once = Encode(claims).run_once };
    }
    const storage = try arena.alloc(u8, output_len);
    side.operations[candidate_count..].* = try baselines.encode_operations(prepared, workload, storage);
    return side;
}

/// Builds one side of a workload: `decoding` or `encoding`.
const Build = fn (arena: std.mem.Allocator, workload: *const Workload, prepared: *const baselines.Prepared) anyerror!Side;

/// Times every operation of one side of `workload`, interleaved.
fn time(arena: std.mem.Allocator, io: std.Io, workload: *const Workload, comptime build: Build) !Rates {
    var baseline_memory: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer baseline_memory.deinit();
    var prepared = try baselines.prepare(baseline_memory.allocator(), workload);
    defer prepared.deinit();
    const side = try build(arena, workload, &prepared);
    var runs: [operation_count][timing.run_count]f64 = undefined;
    timing.time_interleaved(io, &side.operations, &runs);
    return rates_of(&runs, side.octets);
}

/// stdx's throughput with every claim on, beside the baselines'.
fn baseline_row(workload: *const Workload, rates: Rates, octets: usize) baselines.Row {
    var row: baselines.Row = .{ .name = workload.name, .octets = octets, .median = undefined, .spread = undefined };
    row.median[0] = rates.median[0];
    row.spread[0] = rates.spread[0];
    for (0..baselines.count) |index| {
        row.median[1 + index] = rates.median[candidate_count + index];
        row.spread[1 + index] = rates.spread[candidate_count + index];
    }
    return row;
}

/// A claim whose path lost to the scalar one: off ran faster than on by more than the noise.
const Loss = struct { workload: []const u8, side: []const u8, claim: usize, ratio: f64 };

/// The noise floor of decision 20: the larger of 5% and the spreads of the two candidates.
fn noise(rates: Rates, index: usize) f64 {
    return @max(0.05, @max(rates.spread[0], rates.spread[index]));
}

fn report_row(out: *std.Io.Writer, workload: *const Workload, rates: Rates, claims: []const usize, octets: usize) !void {
    try out.print("| {s} | {d} | {d:.1} ± {d:.1}% |", .{ workload.name, octets, rates.median[0], rates.spread[0] * 100 });
    for (claims) |claim| try out.print(" {d:.3} |", .{rates.median[claim + 1] / rates.median[0]});
    try out.print(" {d:.3} |\n", .{rates.median[scalar_index] / rates.median[0]});
}

fn record_losses(arena: std.mem.Allocator, losses: *std.ArrayList(Loss), workload: *const Workload, side: []const u8, rates: Rates, claims: []const usize) !void {
    for (claims) |claim| {
        const ratio = rates.median[claim + 1] / rates.median[0];
        if (ratio > 1 + noise(rates, claim + 1)) try losses.append(arena, .{ .workload = workload.name, .side = side, .claim = claim, .ratio = ratio });
    }
    const all_off = rates.median[scalar_index] / rates.median[0];
    if (all_off > 1 + noise(rates, scalar_index)) try losses.append(arena, .{ .workload = workload.name, .side = side, .claim = json.claims.each_off.len, .ratio = all_off });
}

fn header(out: *std.Io.Writer, title: []const u8, claims: []const usize, octets_are: []const u8) !void {
    try out.print("\n## {s}\n\nEach claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. {s}\n\n", .{ title, octets_are });
    try out.print("| Workload | Octets | All on, MB/s |", .{});
    for (claims) |claim| try out.print(" {s} off |", .{json.claims.each_off_names[claim]});
    try out.print(" All off |\n|---|---|---|", .{});
    for (claims) |_| try out.print("---|", .{});
    try out.print("---|\n", .{});
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;
    const args = try init.minimal.args.toSlice(arena);
    const profiling = args.len > 1 and std.mem.eql(u8, args[1], "--profile");
    const all = try load(arena, io, if (profiling) args[2..] else args[1..]);
    if (profiling) {
        try profile(arena, out, all);
        return out.flush();
    }
    var losses: std.ArrayList(Loss) = .empty;
    const decoding_rows = try arena.alloc(baselines.Row, all.len);
    const encoding_rows = try arena.alloc(baselines.Row, all.len);

    try header(out, "Decoding", &decoder_claims, "Octets are the text's.");
    for (all, decoding_rows) |*workload, *row| {
        const rates = try time(arena, io, workload, decoding);
        row.* = baseline_row(workload, rates, workload.octets);
        try report_row(out, workload, rates, &decoder_claims, workload.octets);
        try record_losses(arena, &losses, workload, "decoding", rates, &decoder_claims);
        try out.flush();
    }
    try header(out, "Encoding", &encoder_claims, "Octets are the ones written.");
    for (all, encoding_rows) |*workload, *row| {
        const rates = try time(arena, io, workload, encoding);
        row.* = baseline_row(workload, rates, workload.octets);
        try report_row(out, workload, rates, &encoder_claims, workload.octets);
        try record_losses(arena, &losses, workload, "encoding", rates, &encoder_claims);
        try out.flush();
    }
    try out.print("\n## Losses\n\nEach workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.\n\n", .{});
    if (losses.items.len == 0) try out.print("None.\n", .{});
    for (losses.items) |loss| {
        const name = if (loss.claim < json.claims.each_off.len) json.claims.each_off_names[loss.claim] else "every claim";
        try out.print("- {s}, {s}: {s} off runs at {d:.3} of all on.\n", .{ loss.workload, loss.side, name, loss.ratio });
    }
    try baselines.report(out, decoding_rows, encoding_rows);
    try out.flush();
}

/// `--profile`: json_profile.zig's counters over both sides of the workloads it takes.
fn profile(arena: std.mem.Allocator, out: *std.Io.Writer, all: []const Workload) !void {
    if (comptime !timing.counters.available) return json_profile.unavailable(out, "they are read through Linux's perf_event_open, and this host is not Linux");
    const open = timing.counters.Counters.open() catch return json_profile.unavailable(out, "perf_event_open refused them");
    try profile_side(arena, out, &open, all, "decoding", decoding);
    try profile_side(arena, out, &open, all, "encoding", encoding);
}

fn profile_side(arena: std.mem.Allocator, out: *std.Io.Writer, open: *const timing.counters.Counters, all: []const Workload, side_name: []const u8, comptime build: Build) !void {
    const places: json_profile.Places = .{ .all_on = 0, .all_off = scalar_index, .first_baseline = candidate_count };
    try json_profile.header(out, side_name);
    for (all) |*workload| {
        if (!json_profile.is_profiled(workload)) continue;
        var baseline_memory: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
        defer baseline_memory.deinit();
        var prepared = try baselines.prepare(baseline_memory.allocator(), workload);
        defer prepared.deinit();
        const side = try build(arena, workload, &prepared);
        try json_profile.rows(out, open, workload, &side.operations, side.octets, places);
        try out.flush();
    }
}

/// The workloads, from the corpus files and the CLDR directory `args` name.
fn load(arena: std.mem.Allocator, io: std.Io, args: []const [:0]const u8) ![]const Workload {
    var files: std.ArrayList(workloads.File) = .empty;
    var cldr: std.ArrayList(workloads.File) = .empty;
    for (args) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse return error.UsageNameEqualsPath;
        const name = argument[0..split];
        const path = argument[split + 1 ..];
        if (std.mem.eql(u8, name, "cldr")) {
            try read_directory(arena, io, path, &cldr);
            continue;
        }
        try files.append(arena, .{ .name = name, .octets = try std.Io.Dir.cwd().readFileAlloc(io, path, arena, .unlimited) });
    }
    if (cldr.items.len == 0) return error.UsageNoCldr;
    var all: std.ArrayList(Workload) = .empty;
    try all.append(arena, try workloads.cldr(arena, cldr.items));
    try all.append(arena, try workloads.qlog(arena));
    try all.appendSlice(arena, try workloads.strings(arena, files.items));
    for (files.items) |file| {
        if (std.mem.eql(u8, file.name, "silesia/dickens")) try all.append(arena, try workloads.non_ascii(arena, file.octets));
    }
    try all.appendSlice(arena, try workloads.hex(arena, files.items));
    return all.toOwnedSlice(arena);
}

/// Every `.json` file of `path`, in name order.
fn read_directory(arena: std.mem.Allocator, io: std.Io, path: []const u8, files: *std.ArrayList(workloads.File)) !void {
    var directory = try std.Io.Dir.cwd().openDir(io, path, .{ .iterate = true });
    defer directory.close(io);
    var iterator = directory.iterate();
    while (try iterator.next(io)) |entry| {
        if (entry.kind != .file or !std.mem.endsWith(u8, entry.name, ".json")) continue;
        const octets = try directory.readFileAlloc(io, entry.name, arena, .unlimited);
        try files.append(arena, .{ .name = try arena.dupe(u8, entry.name), .octets = octets });
    }
    std.mem.sort(workloads.File, files.items, {}, struct {
        fn less(_: void, left: workloads.File, right: workloads.File) bool {
            return std.mem.lessThan(u8, left.name, right.name);
        }
    }.less);
}
