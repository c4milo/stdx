//! `zig build differential-encode -Doracles`: design §8 step 9's check of the DEFLATE, zlib and
//! gzip encoders against the reference decoders (decision 15).
//!
//! - Every corpus file whole, as raw DEFLATE at each level: `encode_all`, within
//!   `encoded_len_max`, decodes to the file through stdx, zlib and Wuffs.
//! - Every file's first `prefix_len_max` octets in each container at each level: the same round
//!   trip; an encode with seeded flush points, after each of which stdx's decoder gives exactly the
//!   input so far; and two seeded splits with those flush points, which give the same octets
//!   (invariant 5).
//! - The SHA-256 of every `encode_all` output, compared with the list in encode_hashes.zig, so the
//!   octets match on every host and in every build mode (invariant 5). With `--record` it prints
//!   the list instead, as Zig source.
//!
//! The seeds come from the file's name, so a failure replays on every host.
//!
//! Usage: `differential_encode [--record] <name>=<path>...`. Exit status 0 when every check
//! passes, 1 when any fails, 2 on a usage error.

const std = @import("std");
const oracle = @import("oracle");
const corpus = @import("corpus");
const codec = @import("codec");
const deflate = @import("deflate");
const zlib = @import("zlib");
const gzip = @import("gzip");
const hashes = @import("encode_hashes.zig");

/// The prefix of each file the containers, flushes and splits run over: a quarter MiB.
const prefix_len_max = 256 * 1024;

/// The most flush points a seed draws for one encode, and the octets each flush may add: an empty
/// stored block, and the header of the block it cut short.
const flush_points_max = 8;
const flush_overhead_len_max = 16;

/// The seeded splits each prefix runs under.
const split_seeds = 2;

/// The octets a container adds around the stream, at most: gzip's header and trailer.
const containers_len_max = 18;

/// The step between containers in the flush points' seed, past every level.
const containers_seed_step = 16;

/// The exit status of a usage error.
const usage_exit_status = 2;

const levels = deflate.constants.encoder_levels;
const containers = std.enums.values(oracle.Container);

/// What an encode covers: a whole file, or its prefix.
const Scope = enum { whole, prefix };

/// The encoder of a container at a level.
fn Encoder(comptime container: oracle.Container, comptime level: u4) type {
    return switch (container) {
        .raw => deflate.Encoder(.{ .level = level }),
        .zlib => zlib.Encoder(.{ .level = level }),
        .gzip => gzip.Encoder(.{ .level = level }),
    };
}

/// stdx's decoder of a container.
fn Decoder(comptime container: oracle.Container) type {
    return switch (container) {
        .raw => deflate,
        .zlib => zlib,
        .gzip => gzip,
    };
}

/// One run's buffers and counts.
const Run = struct {
    arena: std.mem.Allocator,
    record: bool,
    checks: usize = 0,
    failures: usize = 0,
    encoded: []u8,
    decoded: []u8,
    split: []u8,
};

/// The command line: whether to record, and the corpus files' names and paths.
const Arguments = struct {
    record: bool = false,
    names: std.ArrayList([]const u8) = .empty,
    paths: std.ArrayList([]const u8) = .empty,
};

fn parse(arena: std.mem.Allocator, args: []const [:0]const u8) !Arguments {
    var parsed: Arguments = .{};
    for (args) |argument| {
        if (std.mem.eql(u8, argument, "--record")) {
            parsed.record = true;
            continue;
        }
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse {
            std.debug.print("differential-encode: {s} is not <name>=<path>\n", .{argument});
            std.process.exit(usage_exit_status);
        };
        try parsed.names.append(arena, argument[0..split]);
        try parsed.paths.append(arena, argument[split + 1 ..]);
    }
    return parsed;
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    const parsed = try parse(arena, args[1..]);
    if (!corpus.is_whole(parsed.names.items)) {
        std.debug.print("differential-encode FAILED: the build passed {d} files, not the {d} of decision 15\n", .{ parsed.names.items.len, corpus.names.len });
        std.process.exit(1);
    }
    var run: Run = .{ .arena = arena, .record = parsed.record, .encoded = &.{}, .decoded = &.{}, .split = &.{} };
    var out: std.ArrayList(u8) = .empty;
    if (parsed.record) try out.appendSlice(arena, hashes_header);
    for (parsed.names.items, parsed.paths.items) |name, path| {
        const input = try std.Io.Dir.cwd().readFileAlloc(init.io, path, arena, .unlimited);
        const failures_before = run.failures;
        try check_file(&run, name, input, &out);
        std.debug.print("differential-encode: {s}: {d} failed\n", .{ name, run.failures - failures_before });
    }
    if (parsed.record) {
        try out.appendSlice(arena, "};\n");
        try std.Io.File.stdout().writeStreamingAll(init.io, out.items);
    }
    std.debug.print("differential-encode: {d} files, {d} checks, {d} failed\n", .{ parsed.names.items.len, run.checks, run.failures });
    if (run.failures != 0) std.process.exit(1);
}

/// Every check of one file: the whole file raw at each level, then its prefix in each container.
fn check_file(run: *Run, name: []const u8, input: []const u8, out: *std.ArrayList(u8)) !void {
    const len_max = deflate.Encoder(.{ .level = 1 }).encoded_len_max(input.len) + containers_len_max + flush_points_max * flush_overhead_len_max;
    if (run.encoded.len < len_max) run.encoded = try run.arena.alloc(u8, len_max);
    if (run.split.len < len_max) run.split = try run.arena.alloc(u8, len_max);
    if (run.decoded.len < input.len + 1) run.decoded = try run.arena.alloc(u8, input.len + 1);
    inline for (levels) |level| try check_whole(.raw, level, run, name, input, .whole, out);
    const prefix = input[0..@min(input.len, prefix_len_max)];
    inline for (containers) |container| {
        inline for (levels) |level| {
            try check_whole(container, level, run, name, prefix, .prefix, out);
            try check_flushes(container, level, run, name, prefix);
        }
    }
}

const hashes_header =
    \\//! The SHA-256 of every `encode_all` output differential-encode checks (decision 15, invariant
    \\//! 5): the file, the container, the level, whether the encode covers the whole file or its
    \\//! prefix, and the hash. `zig build differential-encode -Doracles -- --record` prints it.
    \\
    \\pub const entries = [_]struct { []const u8, []const u8, u4, []const u8, []const u8 }{
    \\
;

fn fail(run: *Run, name: []const u8, container: oracle.Container, level: u4, what: []const u8) void {
    run.failures += 1;
    std.debug.print("differential-encode FAILED: {s}, {t}, level {d}: {s}\n", .{ name, container, level, what });
}

/// `encode_all` of `input`: within the bound, decoded by stdx, zlib and Wuffs, and hashed.
fn check_whole(comptime container: oracle.Container, comptime level: u4, run: *Run, name: []const u8, input: []const u8, scope: Scope, out: *std.ArrayList(u8)) !void {
    run.checks += 1;
    const E = Encoder(container, level);
    const state = try run.arena.create(E);
    defer run.arena.destroy(state);
    state.init(codec.Features.detect());
    const written = state.encode_all(input, run.encoded) catch return fail(run, name, container, level, "encode_all ran out of room");
    if (written > E.encoded_len_max(input.len)) return fail(run, name, container, level, "the output passed encoded_len_max");
    const stream = run.encoded[0..written];
    try check_decoders(container, level, run, name, input, stream);
    var digest: [std.crypto.hash.sha2.Sha256.digest_length]u8 = undefined;
    std.crypto.hash.sha2.Sha256.hash(stream, &digest, .{});
    const hex = std.fmt.bytesToHex(digest, .lower);
    if (run.record) {
        try out.print(run.arena, "    .{{ \"{s}\", \"{t}\", {d}, \"{t}\", \"{s}\" }},\n", .{ name, container, level, scope, &hex });
        return;
    }
    const expected = recorded(name, container, level, scope) orelse return fail(run, name, container, level, "no hash is recorded; run with --record");
    if (!std.mem.eql(u8, expected, &hex)) fail(run, name, container, level, "the output's SHA-256 is not the one recorded");
}

/// The recorded hash of an encode, if any.
fn recorded(name: []const u8, container: oracle.Container, level: u4, scope: Scope) ?[]const u8 {
    for (hashes.entries) |entry| {
        if (std.mem.eql(u8, entry[0], name) and std.mem.eql(u8, entry[1], @tagName(container)) and
            entry[2] == level and std.mem.eql(u8, entry[3], @tagName(scope))) return entry[4];
    }
    return null;
}

/// The stream decodes to `input` through stdx, zlib and Wuffs, each ending at its last octet.
fn check_decoders(comptime container: oracle.Container, comptime level: u4, run: *Run, name: []const u8, input: []const u8, stream: []const u8) !void {
    const module = Decoder(container);
    const state = try run.arena.create(module.Decoder);
    defer run.arena.destroy(state);
    module.init(state, codec.Features.detect());
    const whole = module.decode_all(state, stream, run.decoded) catch return fail(run, name, container, level, "stdx's decoder refused it");
    if (whole.consumed != stream.len or !std.mem.eql(u8, input, run.decoded[0..whole.written])) return fail(run, name, container, level, "stdx's decoder gave other octets");
    const by_zlib = oracle.zlib_decode(container, stream, run.decoded);
    if (by_zlib.verdict != .ok or by_zlib.consumed != stream.len or !std.mem.eql(u8, input, run.decoded[0..by_zlib.written])) return fail(run, name, container, level, "zlib disagreed");
    const by_wuffs = oracle.wuffs_decode(container, stream, run.decoded);
    if (by_wuffs.verdict != .ok or !std.mem.eql(u8, input, run.decoded[0..by_wuffs.written])) return fail(run, name, container, level, "Wuffs disagreed");
}

/// Seeded flush points in `input`, ascending and before its end, where the finish falls.
fn draw_points(name: []const u8, container: oracle.Container, level: u4, input_len: usize, points: *[flush_points_max]usize) []const usize {
    if (input_len == 0) return points[0..0];
    const seed = @as(u64, level) + @as(u64, @intCast(@intFromEnum(container))) * containers_seed_step;
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(seed, name));
    const count = generator.below(flush_points_max + 1);
    for (points[0..count]) |*point| point.* = generator.below(input_len);
    std.mem.sort(usize, points[0..count], {}, std.sort.asc(usize));
    return points[0..count];
}

/// An encode flushing at seeded points, the output after each decoding to the input so far, and
/// seeded splits with the same points giving the same octets.
fn check_flushes(comptime container: oracle.Container, comptime level: u4, run: *Run, name: []const u8, input: []const u8) !void {
    run.checks += 1;
    const E = Encoder(container, level);
    var points_buffer: [flush_points_max]usize = undefined;
    const points = draw_points(name, container, level, input.len, &points_buffer);
    const states = try run.arena.create([codec.split.state_slots]E);
    defer run.arena.destroy(states);
    states[0].init(codec.Features.detect());
    var written: usize = 0;
    var consumed: usize = 0;
    for (points) |point| {
        const progress = states[0].encode(input[consumed..point], run.encoded[written..], .flush);
        if (progress.status != .needs_input or progress.consumed != point - consumed) return fail(run, name, container, level, "a flush did not take its input");
        consumed = point;
        written += progress.written;
        try check_flushed(container, level, run, name, input[0..point], run.encoded[0..written]);
    }
    const last = states[0].encode(input[consumed..], run.encoded[written..], .finish);
    if (last.status != .done) return fail(run, name, container, level, "the flushed encode did not end");
    written += last.written;
    try check_decoders(container, level, run, name, input, run.encoded[0..written]);
    const step = struct {
        fn call(state: *E, piece: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return state.encode(piece, output, flush);
        }
    }.call;
    for (0..split_seeds) |seed| {
        states[0].init(codec.Features.detect());
        const outcome = try codec.split.drive_encoder(E, states, step, input, run.split, points, std.hash.Wyhash.hash(seed, name));
        if (outcome.status != .done or !std.mem.eql(u8, run.encoded[0..written], run.split[0..outcome.written])) return fail(run, name, container, level, "a split gave other octets");
    }
}

/// The output so far decodes through stdx's decoder to exactly the input so far, and asks for more.
fn check_flushed(comptime container: oracle.Container, comptime level: u4, run: *Run, name: []const u8, input: []const u8, stream: []const u8) !void {
    const module = Decoder(container);
    const state = try run.arena.create(module.Decoder);
    defer run.arena.destroy(state);
    module.init(state, codec.Features.detect());
    const progress = module.decode(state, stream, run.decoded) catch return fail(run, name, container, level, "stdx refused a flushed stream");
    if (progress.status != .needs_input or !std.mem.eql(u8, input, run.decoded[0..progress.written])) return fail(run, name, container, level, "a flush left input undecodable");
}
