//! `zig build differential-zstd -Doracles`: design §8 step 11's check of the Zstandard decoder
//! against libzstd (decision 15).
//!
//! The matrix: the first `matrix_input_len_max` octets of every corpus file, encoded by libzstd at
//! each level of `levels` with each window log of `window_logs`, the checksum and content-size flags
//! a seed draws. stdx's HTTP instance decodes each frame whole and under a seeded split that moves
//! the state between calls (invariant 12); libzstd decodes it too; both must give back the input.
//! A file longer than the prefix also runs whole at libzstd's default level. Then two frames and a
//! skippable one between them, concatenated, must decode to both inputs. Last come the corruptions
//! of zstd_corrupt.zig, judged against libzstd's verdicts.
//!
//! The seeds come from the file's name, so a failure replays on every host.
//!
//! Usage: `differential_zstd <name>=<path>...`. Exit status 0 when every frame agrees, 1 when any
//! does not, 2 on a usage error.

const std = @import("std");
const oracle = @import("oracle");
const corpus = @import("corpus");
const codec = @import("codec");
const zstd = @import("zstd");
const zstd_corrupt = @import("zstd_corrupt.zig");
const verdicts = @import("verdicts");

/// The prefix of each file the matrix runs over: a quarter MiB.
pub const matrix_input_len_max = 256 * 1024;

/// The levels and window logs the matrix encodes with: libzstd's fastest, its default, a middle
/// and a strong level; the level's own window, the smallest, one block and the HTTP limit.
const levels = [_]c_int{ 1, 3, 9, 19 };
const window_logs = [_]c_int{ 0, 10, 17, 23 };

/// libzstd's default level, for the whole-file runs.
const whole_file_level = 3;

/// The exit status of a usage error.
const usage_exit_status = 2;

/// The skippable frame placed between two frames: its magic, size and user data.
const skippable_frame = "\x50\x2a\x4d\x18\x04\x00\x00\x00skip";

const Decoder = zstd.HttpDecoder;

/// Counts for the report.
pub const Tally = struct {
    frames: usize = 0,
    octets: usize = 0,
    failures: usize = 0,
};

/// The buffers one file's checks share.
pub const Buffers = struct {
    frame: []u8,
    output: []u8,
    oracle_output: []u8,
    decoders: *[codec.split.state_slots]Decoder,
};

fn fail(tally: *Tally, name: []const u8, what: []const u8, encoding: oracle.ZstdEncoding, detail: []const u8) void {
    tally.failures += 1;
    std.debug.print("differential-zstd FAILED: {s}, level {d}, window log {d}, checksum {}, content size {}: {s}: {s}\n", .{
        name, encoding.level, encoding.window_log, encoding.checksum, encoding.content_size, what, detail,
    });
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) zstd.Error!codec.Progress {
    return decoder.decode(input, output);
}

/// One frame of `input` at `encoding`: stdx whole, stdx under a split, and libzstd must each give
/// back `input`.
pub fn check_frame(tally: *Tally, buffers: Buffers, name: []const u8, input: []const u8, encoding: oracle.ZstdEncoding, seed: u64) void {
    tally.frames += 1;
    tally.octets += input.len;
    const frame_len = oracle.zstd_encode(encoding, input, buffers.frame) orelse return fail(tally, name, "libzstd", encoding, "did not encode");
    const frame = buffers.frame[0..frame_len];
    const oracle_len = oracle.zstd_decode(frame, buffers.oracle_output) orelse return fail(tally, name, "libzstd", encoding, "did not decode its own frame");
    if (!std.mem.eql(u8, input, buffers.oracle_output[0..oracle_len])) return fail(tally, name, "libzstd", encoding, "decoded other octets");
    buffers.decoders[0].init(codec.Features.detect());
    const whole = buffers.decoders[0].decode_all(frame, buffers.output) catch |err| return fail(tally, name, "stdx whole", encoding, @errorName(err));
    if (whole.consumed != frame.len or !std.mem.eql(u8, input, buffers.output[0..whole.written])) return fail(tally, name, "stdx whole", encoding, "decoded other octets");
    buffers.decoders[0].init(codec.Features.detect());
    const outcome = codec.split.drive(Decoder, buffers.decoders, step, frame, buffers.output, seed) catch |err| return fail(tally, name, "stdx split", encoding, @errorName(err));
    if (outcome.status != .done or !std.mem.eql(u8, input, buffers.output[0..outcome.written])) return fail(tally, name, "stdx split", encoding, "decoded other octets");
}

/// Two frames with a skippable frame between them: every frame decodes, and the octets follow on.
fn check_frames(tally: *Tally, buffers: Buffers, name: []const u8, input: []const u8) void {
    const half = input.len / 2;
    const encoding: oracle.ZstdEncoding = .{ .level = whole_file_level };
    const first_len = oracle.zstd_encode(encoding, input[0..half], buffers.frame) orelse return fail(tally, name, "libzstd", encoding, "did not encode");
    @memcpy(buffers.frame[first_len..][0..skippable_frame.len], skippable_frame);
    const second_start = first_len + skippable_frame.len;
    const second_len = oracle.zstd_encode(encoding, input[half..], buffers.frame[second_start..]) orelse return fail(tally, name, "libzstd", encoding, "did not encode");
    const frames = buffers.frame[0 .. second_start + second_len];
    tally.frames += 1;
    buffers.decoders[0].init(codec.Features.detect());
    const whole = buffers.decoders[0].decode_all(frames, buffers.output) catch |err| return fail(tally, name, "stdx frames", encoding, @errorName(err));
    if (!std.mem.eql(u8, input, buffers.output[0..whole.written])) fail(tally, name, "stdx frames", encoding, "decoded other octets");
}

/// Every check of one file.
pub fn check_file(tally: *Tally, buffers: Buffers, name: []const u8, input: []const u8) void {
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(0, name));
    const prefix = input[0..@min(input.len, matrix_input_len_max)];
    for (levels) |level| {
        for (window_logs) |window_log| {
            const encoding: oracle.ZstdEncoding = .{ .level = level, .window_log = window_log, .checksum = generator.below(2) == 0, .content_size = generator.below(2) == 0 };
            check_frame(tally, buffers, name, prefix, encoding, generator.next());
        }
    }
    if (input.len > prefix.len) check_frame(tally, buffers, name, input, .{ .level = whole_file_level }, generator.next());
    check_frames(tally, buffers, name, prefix);
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    var names: std.ArrayList([]const u8) = .empty;
    var paths: std.ArrayList([]const u8) = .empty;
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse {
            std.debug.print("differential-zstd: {s} is not <name>=<path>\n", .{argument});
            std.process.exit(usage_exit_status);
        };
        try names.append(arena, argument[0..split]);
        try paths.append(arena, argument[split + 1 ..]);
    }
    if (!corpus.is_whole(names.items)) {
        std.debug.print("differential-zstd FAILED: the build passed {d} files, not the {d} of decision 15\n", .{ names.items.len, corpus.names.len });
        std.process.exit(1);
    }
    const decoders = try arena.create([codec.split.state_slots]Decoder);
    const base_len = oracle.zstd_bound(zstd_corrupt.base_input_len_max);
    const corrupt_buffers: zstd_corrupt.Buffers = .{
        .base = try arena.alloc(u8, base_len),
        .corrupted = try arena.alloc(u8, zstd_corrupt.corrupted_len(base_len)),
        .output = try arena.alloc(u8, zstd_corrupt.output_len_max),
        .oracle_output = try arena.alloc(u8, zstd_corrupt.output_len_max),
        .decoder = &decoders[0],
    };
    var total: Tally = .{};
    var corrupt_total: zstd_corrupt.Tally = .{};
    for (names.items, paths.items) |name, path| {
        const input = try std.Io.Dir.cwd().readFileAlloc(init.io, path, arena, .unlimited);
        const buffers: Buffers = .{
            .frame = try arena.alloc(u8, 2 * oracle.zstd_bound(input.len) + skippable_frame.len),
            .output = try arena.alloc(u8, input.len + 1),
            .oracle_output = try arena.alloc(u8, input.len + 1),
            .decoders = decoders,
        };
        var tally: Tally = .{};
        check_file(&tally, buffers, name, input);
        const corrupt_tally = zstd_corrupt.check_file(name, input, corrupt_buffers);
        corrupt_total.add(corrupt_tally);
        std.debug.print("differential-zstd: {s}: {d} frames, {d} failed; {d} corrupted inputs, {d} allowed, {d} failed\n", .{
            name, tally.frames, tally.failures, corrupt_tally.inputs, corrupt_tally.allowed, corrupt_tally.failures,
        });
        total.frames += tally.frames;
        total.octets += tally.octets;
        total.failures += tally.failures;
    }
    for (verdicts.zstd_entries, corrupt_total.allowed_by) |entry, allowed| {
        std.debug.print("differential-zstd: {d} allowed: {s}\n", .{ allowed, entry.shape });
    }
    std.debug.print("differential-zstd: corruptions: {d} inputs, {d} allowed by verdict entries, {d} failed\n", .{
        corrupt_total.inputs, corrupt_total.allowed, corrupt_total.failures,
    });
    std.debug.print("differential-zstd: {d} files, {d} frames, {d} failed\n", .{ names.items.len, total.frames, total.failures + corrupt_total.failures });
    if (total.failures != 0 or corrupt_total.failures != 0) std.process.exit(1);
}
