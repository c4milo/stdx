//! bench-regex: the speed of the `regex` module beside regular expression libraries in Rust, Go
//! and Zig, for decision 86. The timing is bench/timing/timing.zig's: every candidate of a row
//! interleaved in one run, the median of five runs with the spread, and the losses shown.
//!
//! The candidates are regex_engines.zig's: stdx by a searcher with its default cache, the same
//! with claims R1 to R5 off, stdx by the matcher alone, Rust's `regex` crate, Go's regexp,
//! zig-regex and mvzr, and last in each round stdx again, as the first. stdx is built
//! ReleaseSafe and each other library ReleaseFast or its release form, all for the
//! architecture's baseline CPU (decisions 17 and 75).
//!
//! The workloads are regex_cases.zig's, in four tables:
//! - every match of a pattern in a haystack of 1 MiB, both ends of each match, in megabytes a
//!   second;
//! - a pattern that validates each of 65,536 short texts, about half of them valid, in
//!   millions of texts a second;
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

/// The seed of each validation's texts, and of the haystack in four scripts.
const texts_seed = 0x7265676578000000;
const scripts_seed = 0x7363726970747300;

/// What a rate counts each second: megabytes of haystack, millions of texts, or thousands of
/// patterns.
const per_million = 1_000_000.0;
const per_thousand = 1_000.0;

/// The exit status of a usage error.
const usage_exit_status = 2;

/// What one call does with a compiled pattern, and what it does it to.
const Work = union(enum) {
    find_all: []const u8,
    matching: engines.Texts,
    groups: engines.Texts,
};

/// What a call answers: a count or a sum, and for a search the sum of its matches' offsets too.
const Answer = struct { count: usize, offsets: u64 = 0 };

/// One candidate's timed call: a pattern over a haystack or a batch of texts.
const Call = struct {
    pattern: engines.Pattern,
    work: Work,

    /// The call's answer, or null where the candidate has no such call.
    fn answer(call: *const Call) ?Answer {
        switch (call.work) {
            .find_all => |haystack| {
                const found = engines.find_all(call.pattern, haystack);
                return .{ .count = found.matches, .offsets = found.offsets };
            },
            .matching => |texts| return .{ .count = engines.matching(call.pattern, texts) },
            .groups => |texts| return .{ .count = engines.groups(call.pattern, texts) orelse return null },
        }
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
    /// stdx's speed over its own with claims R1 to R5 off, over Rust's and over Go's.
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
        for (ratio_bases) |other| {
            const rate = rates[@intFromEnum(other)] orelse {
                try out.writeAll(" |");
                continue;
            };
            if (stdx / rate < small_ratio) try out.print(" {d:.4} |", .{stdx / rate}) else try out.print(" {d:.2} |", .{stdx / rate});
        }
        try out.writeAll("\n");
    }
};

/// A pattern as the candidates take it: Rust's regex takes `rust` where it is not null.
const Forms = struct {
    pattern: []const u8,
    rust: ?[]const u8 = null,

    fn of(forms: Forms, engine: Engine) []const u8 {
        return if (engine == .rust) forms.rust orelse forms.pattern else forms.pattern;
    }
};

/// Compiles a pattern for every candidate and holds each one's answer to Go's. stdx must give
/// Go's answer.
fn prepare(arena: std.mem.Allocator, calls: *[engine_count]Call, row: *Row, forms: Forms, work: Work) !Answer {
    const go = (try engines.compile(.go, arena, forms.pattern)) orelse return error.GoRefusesThePattern;
    const expected = (Call{ .pattern = go, .work = work }).answer().?;
    for (std.enums.values(Engine)) |engine| {
        const index = @intFromEnum(engine);
        const compiled = (try engines.compile(engine, arena, forms.of(engine))) orelse {
            row.cells[index] = .refused;
            continue;
        };
        calls[index] = .{ .pattern = compiled, .work = work };
        const answer = calls[index].answer() orelse {
            row.cells[index] = .none;
            continue;
        };
        if (!std.meta.eql(answer, expected)) {
            std.debug.print("bench-regex: {s} gives {d} and offsets {d} for `{s}`, and Go's regexp gives {d} and {d}\n", .{ engines.names[index], answer.count, answer.offsets, forms.pattern, expected.count, expected.offsets });
            row.cells[index] = .differs;
            continue;
        }
        row.add(engine, .{ .context = &calls[index], .run_once = Call.run_once });
    }
    const ours = [_]Engine{ .stdx, .stdx_no_skip, .stdx_matcher, .stdx_again };
    const agree = for (ours) |engine| {
        if (row.cells[@intFromEnum(engine)] != .timed) break false;
    } else true;
    if (!agree) {
        std.debug.print("bench-regex: stdx does not give Go's answer for `{s}`\n", .{forms.pattern});
        return error.CandidatesDisagree;
    }
    return expected;
}

/// The candidates a row gives stdx's speed over, a column each: stdx with claims R1 to R5 off,
/// the claims' A/B in one run (decision 86); stdx again, the same code path timed last in each
/// round; and two baselines.
const ratio_bases = [_]Engine{ .stdx_no_skip, .stdx_again, .rust, .go };

/// A ratio under this is printed with four decimals, where two would leave no digit.
const small_ratio = 0.1;

fn print_head(out: *std.Io.Writer, title: []const u8, first: []const u8, second: []const u8) !void {
    try out.print("## {s}\n\n| {s} | {s} |", .{ title, first, second });
    for (engines.names) |name| try out.print(" {s} |", .{name});
    for (ratio_bases) |base| try out.print(" stdx / {s} |", .{engines.names[@intFromEnum(base)]});
    try out.writeAll("\n|---|---|");
    for (0..engine_count + ratio_bases.len) |_| try out.writeAll("---|");
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
    try out.writeAll("`stdx` is a searcher with its cache, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.\n\n");
    try out.writeAll("The patterns of the search table:\n\n");
    for (cases.searches) |search| {
        try out.print("- {s}, in {s}: `{s}`", .{ search.name, search.file, search.pattern });
        if (search.rust) |form| try out.print(", which Rust's regex takes as `{s}`", .{form});
        try out.writeAll("\n");
    }
    try out.writeAll("\n");
    try print_head(out, "Search in 1 MiB, MB/s", "Pattern", "Matches");
    for (cases.searches) |search| {
        const haystack = try haystack_of(files, search.file);
        var calls: [engine_count]Call = undefined;
        var row: Row = .{};
        const found = try prepare(arena, &calls, &row, .{ .pattern = search.pattern, .rust = search.rust }, .{ .find_all = haystack });
        try out.print("| {s} | {d} |", .{ search.name, found.count });
        try row.print(io, out, @as(f64, @floatFromInt(haystack.len)) / timing.octets_per_megabyte);
        try out.flush();
    }
    try out.writeAll("\n");
}

/// Whether a table of short texts times a match of each text or its capture groups.
const TextWork = enum { matching, groups };

fn report_texts(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator, title: []const u8, validations: []const cases.Validation, what: TextWork) !void {
    try print_head(out, title, "Pattern", "Texts that match");
    for (validations, 0..) |validation, index| {
        var batch: cases.Batch = .{};
        try cases.write_texts(validation.kind, texts_seed + index, &batch, arena);
        const texts: engines.Texts = .{ .octets = batch.octets.items, .ends = batch.ends.items };
        var calls: [engine_count]Call = undefined;
        var row: Row = .{};
        const answer = try prepare(arena, &calls, &row, .{ .pattern = validation.pattern }, if (what == .matching) .{ .matching = texts } else .{ .groups = texts });
        if (what == .matching and answer.count != batch.valid) return error.ValidTextsDoNotMatch;
        const valid = batch.valid;
        try out.print("| {s} | {d} |", .{ validation.name, valid });
        try row.print(io, out, @as(f64, cases.texts_per_validation) / per_million);
        try out.flush();
    }
    try out.writeAll("\n");
}

fn report_compiles(io: std.Io, out: *std.Io.Writer, arena: std.mem.Allocator) !void {
    const scratch = try engines.Scratch.init(arena);
    try print_head(out, "Compile, thousands of patterns a second", "Pattern", "Octets");
    var patterns: [cases.validations.len + cases.searches.len]struct { name: []const u8, forms: Forms } = undefined;
    for (cases.validations, 0..) |validation, index| patterns[index] = .{ .name = validation.name, .forms = .{ .pattern = validation.pattern } };
    for (cases.searches, cases.validations.len..) |search, index| patterns[index] = .{ .name = search.name, .forms = .{ .pattern = search.pattern, .rust = search.rust } };
    for (patterns) |entry| {
        var compiles: [engine_count]Compile = undefined;
        var row: Row = .{};
        for (std.enums.values(Engine)) |engine| {
            const index = @intFromEnum(engine);
            compiles[index] = .{ .engine = engine, .scratch = &scratch, .pattern = entry.forms.of(engine) };
            if (!engines.compile_once(engine, &scratch, entry.forms.of(engine))) {
                row.cells[index] = .refused;
                continue;
            }
            row.add(engine, .{ .context = &compiles[index], .run_once = Compile.run_once });
        }
        try out.print("| {s} | {d} |", .{ entry.name, entry.forms.pattern.len });
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
    const scripts = try arena.alloc(u8, cases.haystack_len_max);
    try files.append(arena, .{ .name = cases.scripts, .octets = scripts[0..cases.write_scripts(scripts_seed, scripts)] });
    try report_searches(io, out, arena, files.items);
    try report_texts(io, out, arena, "Match short texts, millions of texts a second", &cases.validations, .matching);
    try report_texts(io, out, arena, "Capture groups of short texts, millions of texts a second", &.{cases.groups_validation}, .groups);
    try report_compiles(io, out, arena);
    try out.flush();
}

test {
    _ = cases;
}
