//! `zig build differential-checksum -Doracles`: design §8 step 4's check that stdx's CRC-32 and
//! Adler-32 give the values of the RFCs' own sample code, zlib and Wuffs.
//!
//! The implementations compared:
//! - every path of stdx's checksum module this CPU runs, as `codec.Features.detect()` finds it;
//! - RFC 1952 §8's update_crc and RFC 1950 §9's update_adler32, compiled from the RFCs' text;
//! - zlib's crc32_z and adler32_z;
//! - Wuffs's hashers, which start from the value of no octets and so join only from it.
//!
//! For every corpus file, each check runs:
//! - at every length from 0 to `len_max`, at an offset into the file the file's seed draws, from
//!   the value of no octets and from a start the seed draws;
//! - over the whole file, whole and under a split the seed draws, for each stdx path.
//!
//! The seed of a file is the hash of its name, so a failure replays on every host.
//!
//! Before any value, the check requires `codec.Features.detect()` to find every feature Zig's own
//! detection found on the build host, so a path detection misses fails the check rather than go
//! untested.
//!
//! Usage: `differential_checksum <name>=<path>...`. Exit status 0 when every value agrees, 1 when
//! any does not, 2 on a usage error.

const std = @import("std");
const builtin = @import("builtin");
const oracle = @import("oracle");
const corpus = @import("corpus");
const codec = @import("codec");
const checksum = @import("checksum");
const host_features = @import("host_features");

/// The longest piece checked at every length (design §8 step 4).
pub const len_max = 4096;

/// The exit status of a usage error.
const usage_exit_status = 2;

/// The most pieces one seeded split cuts a file into, so a split of a 50 MB file stays bounded.
const split_calls_max = 1 << 24;

/// One check: its name, the value of no octets, and how each implementation computes it.
const Check = struct {
    name: []const u8,
    initial: u32,
    /// A start value the seed draws, valid for the check.
    draw_start: *const fn (generator: *codec.split.Generator) u32,
    rfc: *const fn (u32, []const u8) u32,
    zlib: *const fn (u32, []const u8) u32,
    wuffs: *const fn ([]const u8) u32,
    /// Every stdx path this CPU runs, as functions of the start and the octets: the first
    /// `paths_len` of `path_slots`.
    path_slots: [paths_max]Path = undefined,
    paths_len: usize = 0,

    fn paths(self: *const Check) []const Path {
        return self.path_slots[0..self.paths_len];
    }

    fn add_path(self: *Check, path: Path) void {
        self.path_slots[self.paths_len] = path;
        self.paths_len += 1;
    }
};

/// The most paths one check has.
const paths_max = 4;

/// One stdx path, by name.
const Path = struct {
    name: []const u8,
    update: *const fn (u32, []const u8) u32,
};

fn draw_crc32_start(generator: *codec.split.Generator) u32 {
    return @truncate(generator.next());
}

fn draw_adler32_start(generator: *codec.split.Generator) u32 {
    const s1: u32 = @intCast(generator.below(checksum.constants.adler32_base));
    const s2: u32 = @intCast(generator.below(checksum.constants.adler32_base));
    return (s2 << @bitSizeOf(u16)) | s1;
}

/// Each CRC-32 path as a function of the start and the octets.
fn crc32_path(comptime path: checksum.Crc32Path) Path {
    const Update = struct {
        fn update(crc: u32, octets: []const u8) u32 {
            return checksum.crc32(path, crc, octets);
        }
    };
    return .{ .name = @tagName(path), .update = Update.update };
}

/// Each Adler-32 path as a function of the start and the octets.
fn adler32_path(comptime path: checksum.Adler32Path) Path {
    const Update = struct {
        fn update(adler: u32, octets: []const u8) u32 {
            return checksum.adler32(path, adler, octets);
        }
    };
    return .{ .name = @tagName(path), .update = Update.update };
}

/// Counts for the report.
const Tally = struct {
    compared: usize = 0,
    failures: usize = 0,
};

/// One comparison: the value stdx or an oracle gave against the value RFC sample code gave.
const Case = struct {
    file: []const u8,
    check: []const u8,
    who: []const u8,
    offset: usize,
    len: usize,
    start: u32,
};

fn expect_equal(tally: *Tally, case: Case, wanted: u32, got: u32) void {
    tally.compared += 1;
    if (wanted == got) return;
    tally.failures += 1;
    // The tests break a path on purpose, and count its failures rather than print them.
    if (builtin.is_test) return;
    std.debug.print("differential-checksum FAILED: {s}: {s} by {s}, offset {d} length {d} from 0x{x:0>8}: " ++
        "0x{x:0>8}, the RFC's code gives 0x{x:0>8}\n", .{
        case.file, case.check, case.who, case.offset, case.len, case.start, got, wanted,
    });
}

/// Every implementation of `check` over `octets` from `start`, against the RFC's code. Wuffs
/// joins when `start` is the value of no octets.
fn compare(check: Check, tally: *Tally, case: Case, octets: []const u8) void {
    const wanted = check.rfc(case.start, octets);
    var named = case;
    named.who = "zlib";
    expect_equal(tally, named, wanted, check.zlib(case.start, octets));
    if (case.start == check.initial) {
        named.who = "Wuffs";
        expect_equal(tally, named, wanted, check.wuffs(octets));
    }
    for (check.paths()) |path| {
        named.who = path.name;
        expect_equal(tally, named, wanted, path.update(case.start, octets));
    }
}

/// Every length from 0 to `len_max`, at seeded offsets, from the initial value and a seeded start.
fn check_lengths(check: Check, tally: *Tally, file: []const u8, input: []const u8, generator: *codec.split.Generator) void {
    for (0..@min(input.len, len_max) + 1) |len| {
        const offset = draw_offset(generator, input.len, len);
        const octets = input[offset..][0..len];
        const case: Case = .{ .file = file, .check = check.name, .who = "", .offset = offset, .len = len, .start = check.initial };
        compare(check, tally, case, octets);
        var drawn = case;
        drawn.start = check.draw_start(generator);
        compare(check, tally, drawn, octets);
    }
}

/// An offset at which `len` octets fit in an input of `input_len`, drawn from the generator.
fn draw_offset(generator: *codec.split.Generator, input_len: usize, len: usize) usize {
    return @intCast(generator.below(input_len - len + 1));
}

/// The whole file, whole and under a seeded split, for every stdx path.
fn check_whole(check: Check, tally: *Tally, file: []const u8, input: []const u8, seed: u64) void {
    const case: Case = .{ .file = file, .check = check.name, .who = "", .offset = 0, .len = input.len, .start = check.initial };
    compare(check, tally, case, input);
    const wanted = check.rfc(check.initial, input);
    for (check.paths()) |path| {
        var schedule = codec.split.Schedule.init(seed);
        var value = check.initial;
        var position: usize = 0;
        for (0..split_calls_max) |_| {
            if (position == input.len) break;
            const piece_len = schedule.piece_len(input.len - position);
            value = path.update(value, input[position..][0..piece_len]);
            position += piece_len;
        }
        var named = case;
        named.who = path.name;
        expect_equal(tally, named, wanted, if (position == input.len) value else ~wanted);
    }
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    var names: std.ArrayList([]const u8) = .empty;
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse {
            std.debug.print("differential-checksum: {s} is not <name>=<path>\n", .{argument});
            std.process.exit(usage_exit_status);
        };
        try names.append(arena, argument[0..split]);
    }
    if (!corpus.is_whole(names.items)) {
        std.debug.print("differential-checksum FAILED: the build passed {d} files, not the {d} of decision 15\n", .{
            names.items.len, corpus.names.len,
        });
        std.process.exit(1);
    }
    const features = codec.Features.detect();
    if (missed_feature(features)) |name| {
        std.debug.print("differential-checksum FAILED: detection misses {s}, which the build host has\n", .{name});
        std.process.exit(1);
    }
    const wanted: checksum.Features = .{ .pclmul = features.pclmul, .avx2 = features.avx2, .crc32 = features.crc32 };
    const checks = build_checks(wanted);
    std.debug.print("differential-checksum: CRC-32 paths {s}; Adler-32 paths {s}\n", .{
        path_names(arena, checks[0].paths()), path_names(arena, checks[1].paths()),
    });
    var total: Tally = .{};
    for (args[1..], names.items) |argument, name| {
        const input = try std.Io.Dir.cwd().readFileAlloc(init.io, argument[name.len + 1 ..], arena, .unlimited);
        const tally = check_file(&checks, name, input);
        std.debug.print("differential-checksum: {s}: {d} octets, {d} values compared, {d} failed\n", .{
            name, input.len, tally.compared, tally.failures,
        });
        total.compared += tally.compared;
        total.failures += tally.failures;
        arena.free(input);
    }
    std.debug.print("differential-checksum: {d} files, {d} values compared, {d} failed\n", .{
        names.items.len, total.compared, total.failures,
    });
    if (total.failures != 0) std.process.exit(1);
}

/// The first feature the build host has and `detected` lacks, or null.
fn missed_feature(detected: codec.Features) ?[]const u8 {
    inline for (.{ "pclmul", "avx2", "crc32", "pmull" }) |name| {
        if (@field(host_features, name) and !@field(detected, name)) return name;
    }
    return null;
}

/// The two checks, with the paths a CPU with `features` runs.
fn build_checks(features: checksum.Features) [2]Check {
    var crc32: Check = .{
        .name = "CRC-32",
        .initial = 0,
        .draw_start = draw_crc32_start,
        .rfc = oracle.rfc1952_update_crc,
        .zlib = oracle.zlib_crc32,
        .wuffs = oracle.wuffs_crc32,
    };
    inline for (comptime std.enums.values(checksum.Crc32Path)) |path| {
        if (path.runs_on(features)) crc32.add_path(crc32_path(path));
    }
    var adler32: Check = .{
        .name = "Adler-32",
        .initial = checksum.constants.adler32_initial,
        .draw_start = draw_adler32_start,
        .rfc = oracle.rfc1950_update_adler32,
        .zlib = oracle.zlib_adler32,
        .wuffs = oracle.wuffs_adler32,
    };
    inline for (comptime std.enums.values(checksum.Adler32Path)) |path| {
        if (path.runs_on(features)) adler32.add_path(adler32_path(path));
    }
    return .{ crc32, adler32 };
}

fn path_names(arena: std.mem.Allocator, paths: []const Path) []const u8 {
    var names: std.ArrayList(u8) = .empty;
    for (paths, 0..) |path, index| {
        if (index > 0) names.appendSlice(arena, ", ") catch return "?";
        names.appendSlice(arena, path.name) catch return "?";
    }
    return names.items;
}

fn check_file(checks: []const Check, name: []const u8, input: []const u8) Tally {
    var tally: Tally = .{};
    const seed = std.hash.Wyhash.hash(0, name);
    for (checks) |check| {
        var generator = codec.split.Generator.init(seed);
        check_lengths(check, &tally, name, input, &generator);
        check_whole(check, &tally, name, input, seed);
    }
    return tally;
}

// Tests. They check the check: that it compares what it says, and that a wrong path fails it.

const testing = std.testing;

test "every implementation agrees over a sample, and every length is compared" {
    const checks = build_checks(.{});
    var input: [len_max + 100]u8 = undefined;
    for (&input, 0..) |*octet, index| octet.* = @truncate(index *% 2654435761 >> 13);
    const tally = check_file(&checks, "sample", &input);
    try testing.expectEqual(0, tally.failures);
    // Per check and length: zlib and each path from two starts, Wuffs from one; then the whole
    // input by every implementation and every path again under the split.
    const crc32_per_len = 2 * (1 + checks[0].paths_len) + 1;
    const adler32_per_len = 2 * (1 + checks[1].paths_len) + 1;
    const whole = (2 + checks[0].paths_len * 2) + (2 + checks[1].paths_len * 2);
    try testing.expectEqual((len_max + 1) * (crc32_per_len + adler32_per_len) + whole, tally.compared);
}

test "detection on this host finds what the build host's CPU has" {
    try testing.expectEqual(null, missed_feature(codec.Features.detect()));
    // With nothing detected, every feature the host has is missed.
    const host_has_any = host_features.pclmul or host_features.avx2 or host_features.crc32 or host_features.pmull;
    try testing.expectEqual(host_has_any, missed_feature(.{}) != null);
}

test "the offsets spread over the input and every piece fits" {
    var generator = codec.split.Generator.init(0);
    const input_len = 3 * len_max;
    var offsets_seen: usize = 0;
    var offset_max: usize = 0;
    for (0..len_max + 1) |len| {
        const offset = draw_offset(&generator, input_len, len);
        try testing.expect(offset + len <= input_len);
        if (offset != 0) offsets_seen += 1;
        offset_max = @max(offset_max, offset);
    }
    try testing.expect(offsets_seen > len_max / 2);
    try testing.expect(offset_max > input_len / 2);
}

fn wrong_update(value: u32, octets: []const u8) u32 {
    return if (octets.len == len_max / 2) value ^ 1 else checksum.crc32(.table, value, octets);
}

test "a path that is wrong at one length fails the check" {
    var checks = build_checks(.{});
    checks[0].paths_len = 0;
    checks[0].add_path(.{ .name = "wrong", .update = wrong_update });
    var input: [len_max + 1]u8 = undefined;
    for (&input, 0..) |*octet, index| octet.* = @truncate(index);
    const tally = check_file(checks[0..1], "sample", &input);
    // From the initial value and from the drawn start, and in the split if it cuts that length.
    try testing.expect(tally.failures >= 2);
    try testing.expect(tally.failures <= 3);
}
