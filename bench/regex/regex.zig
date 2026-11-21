//! bench-regex: the speed of the `regex` module beside regular expression libraries in Rust, Go
//! and Zig, for decision 86. The timing is bench/timing/timing.zig's: every candidate of a row
//! interleaved in one run, the median of five runs with the spread, and the losses shown.
//!
//! The candidates are regex_engines.zig's: stdx by a searcher with its default cache, stdx by the
//! matcher alone, Rust's `regex` crate, Go's regexp, zig-regex and mvzr. stdx is built
//! ReleaseSafe and each other library ReleaseFast or its release form, all for the
//! architecture's baseline CPU (decisions 17 and 75).
//!
//! The workloads are regex_cases.zig's, in four tables:
//! - every match of a pattern in the first MiB of a corpus file, in megabytes a second;
//! - a pattern that validates each of 1,024 short texts, half of them valid, in millions of
//!   texts a second;
//! - the same with a group around each number of a date and time, by the groups' offsets;
//! - a pattern compiled and made ready for its first search, in thousands of patterns a second.
//!
//! Before a row is timed, each candidate's answer is held to Go's regexp's, which the
//! differential check holds stdx to. A candidate that refuses a pattern, or answers otherwise,
//! is named so in its cell and is not timed. stdx must give Go's answer, or the benchmark fails:
//! a fast wrong answer is no result.
//!
//! Usage: `bench_regex <name>=<path>...`, the corpus files. It prints Markdown to standard output.

const std = @import("std");
const timing = @import("timing");
const cases = @import("regex_cases.zig");
const engines = @import("regex_engines.zig");

const Engine = engines.Engine;
const engine_count = engines.names.len;

/// The seed of each validation's texts.
const texts_seed = 0x7265676578000000;

/// What a rate counts each second: megabytes of haystack, millions of texts, or thousands of
/// patterns.
const per_million = 1_000_000.0;
const per_thousand = 1_000.0;

/// The exit status of a usage error.
const usage_exit_status = 2;

/// What one call does with a compiled pattern.
const Work = enum { count, matching, groups };

/// One candidate's timed call: a pattern over a haystack or a batch of texts.
const Call = struct {
    pattern: engines.Pattern,
    input: []const u8,
    work: Work,

    /// The call's answer, or null where the candidate has no such call.
    fn answer(call: *const Call) ?usize {
        return switch (call.work) {
            .count => engines.count(call.pattern, call.input),
            .matching => engines.matching(call.pattern, call.input),
            .groups => engines.groups(call.pattern, call.input),
        };
    }

    fn run_once(context: *const anyopaque) void {
        const call: *const Call = @ptrCast(@alignCast(context));
        std.mem.doNotOptimizeAway(call.answer());
    }
};

/// One candidate's timed compile of a pattern.
const Compile = struct {
    engine: Engine,
    scratch: *const engines.Scratch,
    pattern: []const u8,

    fn run_once(context: *const anyopaque) void {
        const call: *const Compile = @ptrCast(@alignCast(context));
        std.mem.doNotOptimizeAway(engines.compile_once(call.engine, call.scratch, call.pattern));
    }
};

/// What a candidate's cell of a row holds.
const Cell = union(enum) {
    /// The candidate refuses the pattern.
    refused,
    /// The candidate's answer is not Go's.
    differs,
    /// The candidate has no such call.
    none,
    /// The candidate is timed: its place among the row's operations.
    timed: usize,
};

/// A row as it is timed: each candidate's cell, and the operations of those that are timed.
const Row = struct {
    cells: [engine_count]Cell = undefined,
    operations: [engine_count]timing.Operation = undefined,
    timed: usize = 0,

    fn add(row: *Row, engine: Engine, operation: timing.Operation) void {
        row.cells[@intFromEnum(engine)] = .{ .timed = row.timed };
        row.operations[row.timed] = operation;
        row.timed += 1;
    }

    /// Times the row and prints its cells, with `items` of the row's unit in one operation, and
    /// stdx's speed over Rust's and over Go's.
    fn print(row: *const Row, io: std.Io, out: *std.Io.Writer, items: f64) !void {
        var runs: [engine_count][timing.run_count]f64 = undefined;
        timing.time_interleaved(io, row.operations[0..row.timed], runs[0..row.timed]);
        var rates: [engine_count]?f64 = @splat(null);
        for (row.cells, &rates) |cell, *rate| {
            switch (cell) {
                .refused => try out.writeAll(" refused |"),
                .differs => try out.writeAll(" differs |"),
                .none => try out.writeAll(" none |"),
                .timed => |index| {
                    const summary = timing.summarize(runs[index]);
                    rate.* = items / (summary.median / std.time.ns_per_s);
                    try out.print(" {d:.2} ± {d:.1}% |", .{ rate.*.?, summary.spread * 100 });
                },
            }
        }
        const stdx = rates[@intFromEnum(Engine.stdx)].?;
        for ([_]Engine{ .rust, .go }) |other| {
            if (rates[@intFromEnum(other)]) |rate| try out.print(" {d:.2} |", .{stdx / rate}) else try out.writeAll(" |");
        }
        try out.writeAll("\n");
    }
};

/// Compiles a pattern for every candidate and holds each one's answer to Go's. stdx must give
/// Go's answer.
fn prepare(arena: std.mem.Allocator, calls: *[engine_count]Call, row: *Row, pattern: []const u8, input: []const u8, work: Work) !usize {
    const go = (try engines.compile(.go, arena, pattern)) orelse return error.GoRefusesThePattern;
    const expected = (Call{ .pattern = go, .input = input, .work = work }).answer().?;
    for (std.enums.values(Engine)) |engine| {
        const index = @intFromEnum(engine);
        const compiled = (try engines.compile(engine, arena, pattern)) orelse {
            row.cells[index] = .refused;
            continue;
        };
        calls[index] = .{ .pattern = compiled, .input = input, .work = work };
        const answer = calls[index].answer() orelse {
            row.cells[index] = .none;
            continue;
        };
        if (answer != expected) {
            std.debug.print("bench-regex: {s} gives {d} for `{s}`, and Go's regexp gives {d}\n", .{ engines.names[index], answer, pattern, expected });
            row.cells[index] = .differs;
            continue;
        }
        row.add(engine, .{ .context = &calls[index], .run_once = Call.run_once });
    }
    if (row.cells[@intFromEnum(Engine.stdx)] != .timed or row.cells[@intFromEnum(Engine.stdx_matcher)] != .timed) {
        std.debug.print("bench-regex: stdx does not give Go's answer for `{s}`\n", .{pattern});
        return error.CandidatesDisagree;
    }
    return expected;
}

fn print_head(out: *std.Io.Writer, title: []const u8, first: []const u8, second: []const u8) !void {
    try out.print("## {s}\n\n| {s} | {s} |", .{ title, first, second });
    for (engines.names) |name| try out.print(" {s} |", .{name});
    try out.writeAll(" stdx / Rust regex | stdx / Go regexp |\n|---|---|");
    for (0..engine_count + 2) |_| try out.writeAll("---|");
    try out.writeAll("\n");
}

/// The corpus file a name gives, cut to a haystack's length.
fn haystack_of(files: []const File, name: []const u8) ![]const u8 {
    for (files) |file| {
        if (std.mem.eql(u8, file.name, name)) return file.octets[0..@min(file.octets.len, cases.haystack_len_max)];
    }
    std.debug.print("bench-regex: the build passed no {s}\n", .{name});
    return error.CorpusFileMissing;
}

const File = struct { name: []const u8, octets: []const u8 };

fn report_searches(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator, files: []const File) !void {
    try out.writeAll("The patterns of the search table:\n\n");
    for (cases.searches) |search| try out.print("- {s}, in {s}: `{s}`\n", .{ search.name, search.file, search.pattern });
    try out.writeAll("\n");
    try print_head(out, "Search in 1 MiB, MB/s", "Pattern", "Matches");
    for (cases.searches) |search| {
        const haystack = try haystack_of(files, search.file);
        var calls: [engine_count]Call = undefined;
        var row: Row = .{};
        const matches = try prepare(arena, &calls, &row, search.pattern, haystack, .count);
        try out.print("| {s} | {d} |", .{ search.name, matches });
        try row.print(io, out, @as(f64, @floatFromInt(haystack.len)) / timing.octets_per_megabyte);
        try out.flush();
    }
    try out.writeAll("\n");
}

fn report_texts(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator, title: []const u8, validations: []const cases.Validation, work: Work) !void {
    try print_head(out, title, "Pattern", "Texts that match");
    for (validations, 0..) |validation, index| {
        var batch: std.ArrayList(u8) = .empty;
        const valid = try cases.write_texts(validation.kind, texts_seed + index, &batch, arena);
        var calls: [engine_count]Call = undefined;
        var row: Row = .{};
        const answer = try prepare(arena, &calls, &row, validation.pattern, batch.items, work);
        if (work == .matching and answer != valid) return error.ValidTextsDoNotMatch;
        try out.print("| {s} | {d} |", .{ validation.name, valid });
        try row.print(io, out, @as(f64, cases.texts_per_validation) / per_million);
        try out.flush();
    }
    try out.writeAll("\n");
}

fn report_compiles(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator) !void {
    const scratch = try engines.Scratch.init(arena);
    try print_head(out, "Compile, thousands of patterns a second", "Pattern", "Octets");
    var patterns: [cases.validations.len + cases.searches.len]struct { name: []const u8, pattern: []const u8 } = undefined;
    for (cases.validations, 0..) |validation, index| patterns[index] = .{ .name = validation.name, .pattern = validation.pattern };
    for (cases.searches, cases.validations.len..) |search, index| patterns[index] = .{ .name = search.name, .pattern = search.pattern };
    for (patterns) |entry| {
        var compiles: [engine_count]Compile = undefined;
        var row: Row = .{};
        for (std.enums.values(Engine)) |engine| {
            const index = @intFromEnum(engine);
            compiles[index] = .{ .engine = engine, .scratch = &scratch, .pattern = entry.pattern };
            if (!engines.compile_once(engine, &scratch, entry.pattern)) {
                row.cells[index] = .refused;
                continue;
            }
            row.add(engine, .{ .context = &compiles[index], .run_once = Compile.run_once });
        }
        try out.print("| {s} | {d} |", .{ entry.name, entry.pattern.len });
        try row.print(io, out, 1.0 / per_thousand);
        try out.flush();
    }
    try out.writeAll("\n");
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_buffer: [4096]u8 = undefined;
    var stdout = std.Io.File.stdout().writerStreaming(io, &stdout_buffer);
    const out = &stdout.interface;
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    var files: std.ArrayList(File) = .empty;
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse {
            std.debug.print("bench-regex: {s} is not <name>=<path>\n", .{argument});
            std.process.exit(usage_exit_status);
        };
        const wanted = for (cases.searches) |search| {
            if (std.mem.eql(u8, search.file, argument[0..split])) break true;
        } else false;
        if (!wanted) continue;
        const octets = try std.Io.Dir.cwd().readFileAlloc(io, argument[split + 1 ..], arena, .unlimited);
        try files.append(arena, .{ .name = argument[0..split], .octets = octets });
    }
    try report_searches(io, out, arena, files.items);
    try report_texts(io, out, arena, "Match short texts, millions of texts a second", &cases.validations, .matching);
    try report_texts(io, out, arena, "Capture groups of short texts, millions of texts a second", &.{cases.groups_validation}, .groups);
    try report_compiles(io, out, arena);
    try out.flush();
}

test {
    _ = cases;
}
