//! corpus_cut: cuts one HTTP-shaped payload into the three sizes decision 15 names.
//!
//! It reads its sources in the order given, joins them into one run of octets, and writes the first
//! 1 KiB, 16 KiB and 1 MiB of that run as `<kind>-1k`, `<kind>-16k` and `<kind>-1m`. A run shorter
//! than a piece repeats from its start until the piece is full, which only Bootstrap's CSS needs
//! (decision 15 records what the repetition does to the ratios). A source that is a directory
//! stands for every file under it whose name ends in `--extension`, in the order of their paths,
//! which is how the CLDR JSON files join.
//!
//! Usage: `corpus_cut <output-dir> <kind> [--extension <suffix>] <source>...`
//!
//! Exit status 0 when all three pieces are written, 1 when a source cannot be read or holds
//! nothing, 2 on a usage error.

const std = @import("std");

/// The three sizes of decision 15, each with the suffix of its file name.
pub const pieces = [_]Piece{
    .{ .suffix = "1k", .len = 1 << 10 },
    .{ .suffix = "16k", .len = 16 << 10 },
    .{ .suffix = "1m", .len = 1 << 20 },
};

pub const Piece = struct {
    suffix: []const u8,
    len: usize,
};

/// The exit status of a usage error.
const usage_exit_status = 2;

/// The first `len` octets of `run`, repeated from its start when it is shorter. `run` must hold
/// at least one octet.
pub fn cut(output: []u8, run: []const u8) void {
    std.debug.assert(run.len != 0);
    var filled: usize = 0;
    while (filled < output.len) {
        const take = @min(run.len, output.len - filled);
        @memcpy(output[filled..][0..take], run[0..take]);
        filled += take;
    }
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);
    if (args.len < 4) usage();
    const output_directory = args[1];
    const kind = args[2];
    var sources = args[3..];
    var extension: []const u8 = "";
    if (std.mem.eql(u8, sources[0], "--extension")) {
        if (sources.len < 3) usage();
        extension = sources[1];
        sources = sources[2..];
    }

    var run: std.ArrayList(u8) = .empty;
    for (sources) |source| try append_source(arena, io, &run, source, extension);
    if (run.items.len == 0) {
        std.debug.print("corpus_cut: the sources of {s} hold no octets\n", .{kind});
        std.process.exit(1);
    }

    var directory = try std.Io.Dir.cwd().createDirPathOpen(io, output_directory, .{});
    defer directory.close(io);
    for (pieces) |piece| {
        const output = try arena.alloc(u8, piece.len);
        cut(output, run.items);
        const name = try std.fmt.allocPrint(arena, "{s}-{s}", .{ kind, piece.suffix });
        try directory.writeFile(io, .{ .sub_path = name, .data = output });
    }
}

fn usage() noreturn {
    std.debug.print("usage: corpus_cut <output-dir> <kind> [--extension <suffix>] <source>...\n", .{});
    std.process.exit(usage_exit_status);
}

/// Appends one source's octets: a file whole, or every file under a directory whose name ends in
/// `extension`, in the order of their paths.
fn append_source(
    arena: std.mem.Allocator,
    io: std.Io,
    run: *std.ArrayList(u8),
    source: []const u8,
    extension: []const u8,
) !void {
    const stat = try std.Io.Dir.cwd().statFile(io, source, .{});
    if (stat.kind != .directory) {
        const octets = try std.Io.Dir.cwd().readFileAlloc(io, source, arena, .unlimited);
        return run.appendSlice(arena, octets);
    }
    var directory = try std.Io.Dir.cwd().openDir(io, source, .{ .iterate = true });
    defer directory.close(io);
    var names: std.ArrayList([]const u8) = .empty;
    var walker = try directory.walk(arena);
    defer walker.deinit();
    while (try walker.next(io)) |entry| {
        if (entry.kind != .file or !std.mem.endsWith(u8, entry.basename, extension)) continue;
        try names.append(arena, try arena.dupe(u8, entry.path));
    }
    std.mem.sort([]const u8, names.items, {}, less_than);
    for (names.items) |name| {
        const octets = try directory.readFileAlloc(io, name, arena, .unlimited);
        try run.appendSlice(arena, octets);
    }
}

fn less_than(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.order(u8, left, right) == .lt;
}

// Tests.

const testing = std.testing;

test "the pieces are 1 KiB, 16 KiB and 1 MiB" {
    try testing.expectEqual(1024, pieces[0].len);
    try testing.expectEqual(16384, pieces[1].len);
    try testing.expectEqual(1048576, pieces[2].len);
}

test "cut takes a prefix of a long run" {
    var output: [4]u8 = undefined;
    cut(&output, "abcdefgh");
    try testing.expectEqualStrings("abcd", &output);
}

test "cut repeats a short run from its start until the piece is full" {
    var output: [8]u8 = undefined;
    cut(&output, "abc");
    try testing.expectEqualStrings("abcabcab", &output);
}

test "cut of a run exactly as long as the piece copies it once" {
    var output: [3]u8 = undefined;
    cut(&output, "abc");
    try testing.expectEqualStrings("abc", &output);
}
