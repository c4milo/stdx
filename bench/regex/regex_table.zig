//! bench-regex's tables: a candidate's cell, a row as it is timed, and a table's head
//! (decision 86). The search, text and compile tables and the held-out set print through them.

const std = @import("std");
const timing = @import("timing");
const engines = @import("regex_engines.zig");

const Engine = engines.Engine;
const engine_count = engines.names.len;

/// A corpus file the build passes: its name, and its octets.
pub const File = struct { name: []const u8, octets: []const u8 };

/// What a candidate's cell of a row holds.
pub const Cell = union(enum) {
    /// The candidate refuses the pattern.
    refused,
    /// The candidate's answer is not Go's.
    differs,
    /// The candidate has no such call.
    none,
    /// The candidate is not timed on the held-out set (regex_held_out.zig).
    untimed,
    /// The candidate is timed: its place among the row's operations.
    timed: usize,
};

/// A row as it is timed: each candidate's cell, and the operations of those that are timed.
pub const Row = struct {
    cells: [engine_count]Cell = undefined,
    operations: [engine_count]timing.Operation = undefined,
    timed: usize = 0,

    pub fn add(row: *Row, engine: Engine, operation: timing.Operation) void {
        row.cells[@intFromEnum(engine)] = .{ .timed = row.timed };
        row.operations[row.timed] = operation;
        row.timed += 1;
    }

    /// Times the row and prints its cells, with `items` of the row's unit in one operation, and
    /// stdx's speed over its own with claims R1 to R5 off, over Rust's and over Go's.
    pub fn print(row: *const Row, io: std.Io, out: *std.Io.Writer, items: f64) !void {
        var runs: [engine_count][timing.run_count]f64 = undefined;
        timing.time_rotated(io, row.operations[0..row.timed], runs[0..row.timed], row.rotated_len());
        var rates: [engine_count]?f64 = @splat(null);
        for (row.cells, &rates) |cell, *rate| {
            switch (cell) {
                .refused => try out.writeAll(" refused |"),
                .differs => try out.writeAll(" differs |"),
                .none => try out.writeAll(" none |"),
                .untimed => try out.writeAll(" not timed |"),
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

    /// The operations a round times in another order each run: all but `stdx, again`, which
    /// stays last in each round (decision 86).
    fn rotated_len(row: *const Row) usize {
        const again = row.cells[@intFromEnum(Engine.stdx_again)];
        if (again == .timed and again.timed == row.timed - 1) return row.timed - 1;
        return row.timed;
    }
};

/// The candidates a row gives stdx's speed over, a column each: stdx with claims R1 to R5 off,
/// the claims' A/B in one run (decision 86); stdx again, the same code path timed last in each
/// round; and two baselines.
const ratio_bases = [_]Engine{ .stdx_no_skip, .stdx_again, .rust, .go };

/// A ratio under this is printed with four decimals, where two would leave no digit.
const small_ratio = 0.1;

pub fn print_head(out: *std.Io.Writer, title: []const u8, first: []const u8, second: []const u8) !void {
    try out.print("## {s}\n\n| {s} | {s} |", .{ title, first, second });
    for (engines.names) |name| try out.print(" {s} |", .{name});
    for (ratio_bases) |base| try out.print(" stdx / {s} |", .{engines.names[@intFromEnum(base)]});
    try out.writeAll("\n|---|---|");
    for (0..engine_count + ratio_bases.len) |_| try out.writeAll("---|");
    try out.writeAll("\n");
}

/// The most places a test's log holds.
const log_len_max = 64;

/// The most octets a test's row writes.
const output_len_max = 1024;

/// The places a test's operations ran at, one entry for each change of operation.
const Log = struct {
    places: [log_len_max]u8 = undefined,
    len: usize = 0,

    fn write(log: *Log, place: u8) void {
        if (log.len > 0 and log.places[log.len - 1] == place) return;
        std.debug.assert(log.len < log_len_max);
        log.places[log.len] = place;
        log.len += 1;
    }
};

/// A test's operation: it writes its place to the log.
const Recorded = struct {
    place: u8,
    log: *Log,

    fn run_once(context: *const anyopaque) void {
        const recorded: *const Recorded = @ptrCast(@alignCast(context));
        recorded.log.write(recorded.place);
    }
};

test "a row times stdx again last in each round, and starts the others one place later" {
    var log: Log = .{};
    const timed = [_]Engine{ .stdx, .rust, .go, .stdx_again };
    var recorded: [timed.len]Recorded = undefined;
    var row: Row = .{ .cells = @splat(.none) };
    for (timed, &recorded, 0..) |engine, *entry, place| {
        entry.* = .{ .place = @intCast(place), .log = &log };
        row.add(engine, .{ .context = entry, .run_once = Recorded.run_once });
    }
    var buffer: [output_len_max]u8 = undefined;
    var out: std.Io.Writer = .fixed(&buffer);
    try row.print(std.testing.io, &out, 1);
    // A first call of each, then the five rounds: stdx, Rust and Go from places 0, 1, 2, 0 and 1.
    const expected = [_]u8{ 0, 1, 2, 3, 0, 1, 2, 3, 1, 2, 0, 3, 2, 0, 1, 3, 0, 1, 2, 3, 1, 2, 0, 3 };
    try std.testing.expectEqualSlices(u8, &expected, log.places[0..log.len]);
}

test "a row whose stdx again is not timed last rotates every candidate" {
    var log: Log = .{};
    var recorded: Recorded = .{ .place = 0, .log = &log };
    const operation: timing.Operation = .{ .context = &recorded, .run_once = Recorded.run_once };
    var row: Row = .{ .cells = @splat(.none) };
    row.add(.stdx, operation);
    try std.testing.expectEqual(@as(usize, 1), row.rotated_len());
    row.add(.stdx_again, operation);
    try std.testing.expectEqual(@as(usize, 1), row.rotated_len());
    row.add(.rust, operation);
    try std.testing.expectEqual(@as(usize, 3), row.rotated_len());
}
