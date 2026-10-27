//! `zig build differential-zstd-encode -Doracles`: design §8 step 13's check of the Zstandard
//! encoder against libzstd's decoder and stdx's (decision 15).
//!
//! - Every corpus file whole at levels 1 and 3: `encode_all`, within `encoded_len_max`, decodes to
//!   the file through stdx and libzstd, in a frame whose Window_Size is at most 8,000,000 octets
//!   (decision 12).
//! - Every file's first `prefix_len_max` octets at each level, with and without a checksum: the
//!   same round trip; an encode with seeded flush points, after each of which stdx's decoder gives
//!   exactly the input so far; and seeded splits with those flush points, which give the same
//!   octets (invariant 5).
//! - The SHA-256 of every `encode_all` output, compared with the list in zstd_encode_hashes.zig,
//!   so the octets match on every host and in every build mode (invariant 5). With `--record` it
//!   prints the list instead, as Zig source.
//!
//! The seeds come from the file's name, so a failure replays on every host.
//!
//! Usage: `differential_zstd_encode [--record] <name>=<path>...`. Exit status 0 when every check
//! passes, 1 when any fails, 2 on a usage error.

const std = @import("std");
const oracle = @import("oracle");
const corpus = @import("corpus");
const codec = @import("codec");
const zstd = @import("zstd");
const hashes = @import("zstd_encode_hashes.zig");

/// The prefix of each file the checksums, flushes and splits run over: a quarter MiB.
const prefix_len_max = 256 * 1024;

/// The most flush points a seed draws for one encode, and the octets each flush may add: the
/// Block_Header of the block it cut short.
const flush_points_max = 8;
const flush_overhead_len_max = 3;

/// The seeded splits each prefix runs under.
const split_seeds = 2;

/// The largest Window_Size an HTTP frame may ask for (RFC 9659 §3, decision 12).
const http_window_len_max = 8_000_000;

/// The exit status of a usage error.
const usage_exit_status = 2;

const levels = [_]u4{ 1, 3 };

/// What an encode covers: a whole file, or its prefix with or without a checksum.
const Scope = enum { whole, prefix, checksum };

fn Encoder(comptime level: u4, comptime with_checksum: bool) type {
    return zstd.Encoder(.{ .level = level, .checksum = with_checksum });
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
    decoder: *zstd.HttpDecoder,
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
            std.debug.print("differential-zstd-encode: {s} is not <name>=<path>\n", .{argument});
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
        std.debug.print("differential-zstd-encode FAILED: the build passed {d} files, not the {d} of decision 15\n", .{ parsed.names.items.len, corpus.names.len });
        std.process.exit(1);
    }
    var run: Run = .{ .arena = arena, .record = parsed.record, .encoded = &.{}, .decoded = &.{}, .split = &.{}, .decoder = try arena.create(zstd.HttpDecoder) };
    var out: std.ArrayList(u8) = .empty;
    if (parsed.record) try out.appendSlice(arena, hashes_header);
    for (parsed.names.items, parsed.paths.items) |name, path| {
        const input = try std.Io.Dir.cwd().readFileAlloc(init.io, path, arena, .unlimited);
        const failures_before = run.failures;
        try check_file(&run, name, input, &out);
        std.debug.print("differential-zstd-encode: {s}: {d} failed\n", .{ name, run.failures - failures_before });
    }
    if (parsed.record) {
        try out.appendSlice(arena, "};\n");
        try std.Io.File.stdout().writeStreamingAll(init.io, out.items);
    }
    std.debug.print("differential-zstd-encode: {d} files, {d} checks, {d} failed\n", .{ parsed.names.items.len, run.checks, run.failures });
    if (run.failures != 0) std.process.exit(1);
}

/// Every check of one file: the whole file at each level, then its prefix at each level, with and
/// without a checksum.
fn check_file(run: *Run, name: []const u8, input: []const u8, out: *std.ArrayList(u8)) !void {
    const len_max = Encoder(1, true).encoded_len_max(input.len) + flush_points_max * flush_overhead_len_max;
    if (run.encoded.len < len_max) run.encoded = try run.arena.alloc(u8, len_max);
    if (run.split.len < len_max) run.split = try run.arena.alloc(u8, len_max);
    if (run.decoded.len < input.len + 1) run.decoded = try run.arena.alloc(u8, input.len + 1);
    const prefix = input[0..@min(input.len, prefix_len_max)];
    inline for (levels) |level| {
        try check_whole(level, false, run, name, input, .whole, out);
        try check_whole(level, false, run, name, prefix, .prefix, out);
        try check_whole(level, true, run, name, prefix, .checksum, out);
        try check_flushes(level, false, run, name, prefix);
        try check_flushes(level, true, run, name, prefix);
    }
}

const hashes_header =
    \\//! The SHA-256 of every `encode_all` output differential-zstd-encode checks (decision 15,
    \\//! invariant 5): the file, the level, whether the encode covers the whole file, its prefix, or
    \\//! its prefix with a checksum, and the hash. `zig build differential-zstd-encode -Doracles --
    \\//! --record` prints it.
    \\
    \\pub const entries = [_]struct { []const u8, u4, []const u8, []const u8 }{
    \\
;

fn fail(run: *Run, name: []const u8, level: u4, what: []const u8) void {
    run.failures += 1;
    std.debug.print("differential-zstd-encode FAILED: {s}, level {d}: {s}\n", .{ name, level, what });
}

/// `encode_all` of `input`: within the bound, decoded by stdx and libzstd, and hashed.
fn check_whole(comptime level: u4, comptime with_checksum: bool, run: *Run, name: []const u8, input: []const u8, scope: Scope, out: *std.ArrayList(u8)) !void {
    run.checks += 1;
    const E = Encoder(level, with_checksum);
    const state = try run.arena.create(E);
    defer run.arena.destroy(state);
    state.init(codec.Features.detect());
    const written = state.encode_all(input, run.encoded) catch return fail(run, name, level, "encode_all ran out of room");
    if (written > E.encoded_len_max(input.len)) return fail(run, name, level, "the output passed encoded_len_max");
    const frame = run.encoded[0..written];
    try check_decoders(level, run, name, input, frame);
    var digest: [std.crypto.hash.sha2.Sha256.digest_length]u8 = undefined;
    std.crypto.hash.sha2.Sha256.hash(frame, &digest, .{});
    const hex = std.fmt.bytesToHex(digest, .lower);
    if (run.record) {
        try out.print(run.arena, "    .{{ \"{s}\", {d}, \"{t}\", \"{s}\" }},\n", .{ name, level, scope, &hex });
        return;
    }
    const expected = recorded(name, level, scope) orelse return fail(run, name, level, "no hash is recorded; run with --record");
    if (!std.mem.eql(u8, expected, &hex)) fail(run, name, level, "the output's SHA-256 is not the one recorded");
}

/// The recorded hash of an encode, if any.
fn recorded(name: []const u8, level: u4, scope: Scope) ?[]const u8 {
    for (hashes.entries) |entry| {
        if (std.mem.eql(u8, entry[0], name) and entry[1] == level and std.mem.eql(u8, entry[2], @tagName(scope))) return entry[3];
    }
    return null;
}

/// The frame decodes to `input` through stdx and libzstd, and asks for a window an HTTP decoder
/// takes.
fn check_decoders(level: u4, run: *Run, name: []const u8, input: []const u8, frame: []const u8) !void {
    run.decoder.init(codec.Features.detect());
    const whole = run.decoder.decode_all(frame, run.decoded) catch return fail(run, name, level, "stdx's decoder refused it");
    if (whole.consumed != frame.len or !std.mem.eql(u8, input, run.decoded[0..whole.written])) return fail(run, name, level, "stdx's decoder gave other octets");
    const by_libzstd = oracle.zstd_decode(frame, run.decoded) orelse return fail(run, name, level, "libzstd refused it");
    if (!std.mem.eql(u8, input, run.decoded[0..by_libzstd])) return fail(run, name, level, "libzstd gave other octets");
    // RFC 9659 §3, decision 12: the HTTP levels never ask for more than 8,000,000 octets.
    if (window_len(frame) > http_window_len_max) fail(run, name, level, "the frame asks for a window over 8,000,000 octets");
}

/// The Window_Size `frame`'s header asks for, read here rather than through stdx's decoder (RFC
/// 8878 §3.1.1.1.2): Frame_Content_Size for a single-segment frame, which the encoder writes only
/// for one block, else 2^(10 + Exponent) plus an eighth of it per Mantissa.
fn window_len(frame: []const u8) u64 {
    const descriptor = frame[magic_len];
    if (descriptor & single_segment_flag != 0) return block_len_max;
    const window_descriptor = frame[magic_len + 1];
    const base = @as(u64, 1) << @intCast(window_log_min + (window_descriptor >> mantissa_bits));
    return base + base / (1 << mantissa_bits) * (window_descriptor & ((1 << mantissa_bits) - 1));
}

/// The fields of RFC 8878 §3.1.1 and §3.1.1.1 the window's reading takes.
const magic_len = 4;
const single_segment_flag = 0x20;
const window_log_min = 10;
const mantissa_bits = 3;
const block_len_max = 128 * 1024;

/// Seeded flush points in `input`, ascending and before its end, where the finish falls.
fn draw_points(name: []const u8, level: u4, with_checksum: bool, input_len: usize, points: *[flush_points_max]usize) []const usize {
    if (input_len == 0) return points[0..0];
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(@as(u64, level) * 2 + @intFromBool(with_checksum), name));
    const count = generator.below(flush_points_max + 1);
    for (points[0..count]) |*point| point.* = generator.below(input_len);
    std.mem.sort(usize, points[0..count], {}, std.sort.asc(usize));
    return points[0..count];
}

/// An encode flushing at seeded points, the output after each decoding to the input so far, and
/// seeded splits with the same points giving the same octets.
fn check_flushes(comptime level: u4, comptime with_checksum: bool, run: *Run, name: []const u8, input: []const u8) !void {
    run.checks += 1;
    const E = Encoder(level, with_checksum);
    var points_buffer: [flush_points_max]usize = undefined;
    const points = draw_points(name, level, with_checksum, input.len, &points_buffer);
    const states = try run.arena.create([codec.split.state_slots]E);
    defer run.arena.destroy(states);
    states[0].init(codec.Features.detect());
    var written: usize = 0;
    var consumed: usize = 0;
    for (points) |point| {
        const progress = states[0].encode(input[consumed..point], run.encoded[written..], .flush);
        if (progress.status != .needs_input or progress.consumed != point - consumed) return fail(run, name, level, "a flush did not take its input");
        consumed = point;
        written += progress.written;
        try check_flushed(level, run, name, input[0..point], run.encoded[0..written]);
    }
    const last = states[0].encode(input[consumed..], run.encoded[written..], .finish);
    if (last.status != .done) return fail(run, name, level, "the flushed encode did not end");
    written += last.written;
    try check_decoders(level, run, name, input, run.encoded[0..written]);
    const step = struct {
        fn call(state: *E, piece: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return state.encode(piece, output, flush);
        }
    }.call;
    for (0..split_seeds) |seed| {
        states[0].init(codec.Features.detect());
        const outcome = try codec.split.drive_encoder(E, states, step, input, run.split, points, std.hash.Wyhash.hash(seed, name));
        if (outcome.status != .done or !std.mem.eql(u8, run.encoded[0..written], run.split[0..outcome.written])) return fail(run, name, level, "a split gave other octets");
    }
}

/// The output so far decodes through stdx's decoder to exactly the input so far, and asks for more.
fn check_flushed(level: u4, run: *Run, name: []const u8, input: []const u8, frame: []const u8) !void {
    run.decoder.init(codec.Features.detect());
    const progress = run.decoder.decode(frame, run.decoded) catch return fail(run, name, level, "stdx refused a flushed frame");
    if (progress.status != .needs_input or !std.mem.eql(u8, input, run.decoded[0..progress.written])) return fail(run, name, level, "a flush left input undecodable");
}
