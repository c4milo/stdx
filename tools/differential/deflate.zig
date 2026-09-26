//! `zig build differential-deflate -Doracles`: design §8 step 5's check of the DEFLATE decoder
//! against zlib and Wuffs (decision 15), over raw DEFLATE streams.
//!
//! The matrix: the first `matrix_input_len_max` octets of every corpus file, encoded by zlib at
//! every level (0 to 9) and every strategy, with the window bits (9 to 15), the memory level (1 to
//! 9) and up to `flush_points_drawn_max` flush points of every kind a seed draws. Each stream is
//! decoded by stdx under a seeded split that moves the state between calls (invariant 12), and by
//! zlib and Wuffs; each must end the stream, give back the input, and stdx and zlib must stop at
//! the stream's last octet. A file longer than the prefix also runs whole, at zlib's default.
//!
//! The corruptions of deflate_corrupt.zig follow, judged against zlib's and Wuffs's verdicts.
//!
//! The seeds come from the file's name, so a failure replays on every host.
//!
//! Usage: `differential_deflate <name>=<path>...`. Exit status 0 when every stream agrees, 1 when
//! any does not, 2 on a usage error.

const std = @import("std");
const oracle = @import("oracle");
const corpus = @import("corpus");
const codec = @import("codec");
const deflate = @import("deflate");
const deflate_corrupt = @import("deflate_corrupt.zig");

/// The prefix of each file the matrix runs over: a quarter MiB, eight windows of history.
pub const matrix_input_len_max = 256 * 1024;

/// The most flush points a seed draws for one encode.
const flush_points_drawn_max = 8;

/// The window bits and memory levels zlib's encoder takes (zlib.h, deflateInit2).
const window_bits_min = 9;
const mem_level_min = 1;
const mem_level_max = 9;

/// zlib's default level, for the whole-file runs.
const whole_file_level = 6;

/// The exit status of a usage error.
const usage_exit_status = 2;

/// The flush kinds a seed draws from.
const flush_kinds = [_]oracle.Flush{ .partial, .sync, .full, .block };

/// Counts for the report.
pub const Tally = struct {
    streams: usize = 0,
    octets: usize = 0,
    failures: usize = 0,
};

/// The buffers one file's checks reuse.
pub const Buffers = struct {
    encoded: []u8,
    output: []u8,
    zlib_output: []u8,
    wuffs_output: []u8,
    states: *[codec.split.state_slots]deflate.Decoder,
};

fn step(decoder: *deflate.Decoder, input: []const u8, output: []u8) deflate.Error!codec.Progress {
    return deflate.decode(decoder, input, output);
}

/// stdx's decode of `stream` under `seed`'s split.
pub fn stdx_split(buffers: Buffers, stream: []const u8, output: []u8, seed: u64) !codec.split.Outcome {
    deflate.init(&buffers.states[0], .{});
    return codec.split.drive(deflate.Decoder, buffers.states, step, stream, output, seed);
}

/// A seeded encoding: its settings and flush points.
const Setting = struct {
    encoding: oracle.Encoding,
    points: [flush_points_drawn_max]oracle.FlushPoint,
    point_count: usize,
};

fn draw_setting(generator: *codec.split.Generator, level: c_int, strategy: oracle.Strategy, input_len: usize) Setting {
    var setting: Setting = .{
        .encoding = .{
            .container = .raw,
            .level = level,
            .strategy = strategy,
            .window_bits = @intCast(generator.between(window_bits_min, oracle.window_bits_max)),
            .mem_level = @intCast(generator.between(mem_level_min, mem_level_max)),
        },
        .points = undefined,
        .point_count = generator.below(flush_points_drawn_max + 1),
    };
    var positions: [flush_points_drawn_max]usize = undefined;
    for (positions[0..setting.point_count]) |*position| position.* = generator.below(input_len + 1);
    std.mem.sort(usize, positions[0..setting.point_count], {}, std.sort.asc(usize));
    for (setting.points[0..setting.point_count], positions[0..setting.point_count]) |*point, position| {
        point.* = .{ .position = position, .flush = flush_kinds[generator.below(flush_kinds.len)] };
    }
    return setting;
}

/// Encodes `input` with `setting`, and requires stdx, zlib and Wuffs to decode it back.
fn check_stream(name: []const u8, setting: Setting, input: []const u8, buffers: Buffers, seed: u64, tally: *Tally) void {
    tally.streams += 1;
    tally.octets += input.len;
    const encoded = oracle.zlib_encode_flushing(setting.encoding, input, buffers.encoded, setting.points[0..setting.point_count]) catch {
        return fail(tally, name, setting, "the drawn flush points", "were out of order");
    };
    if (encoded.verdict != .ok or encoded.consumed != input.len) {
        return fail(tally, name, setting, "zlib's encoder", "did not end its stream");
    }
    const stream = buffers.encoded[0..encoded.written];
    const outcome = stdx_split(buffers, stream, buffers.output[0..input.len], seed) catch |err| {
        std.debug.print("differential-deflate FAILED: {s}, level {d} {t}, seed {d}: stdx refused it: {t}\n", .{
            name, setting.encoding.level, setting.encoding.strategy, seed, err,
        });
        tally.failures += 1;
        return;
    };
    if (outcome.status != .done) return fail(tally, name, setting, "stdx", "did not end the stream");
    if (outcome.consumed != stream.len) return fail(tally, name, setting, "stdx", "did not stop at the stream's end");
    if (!std.mem.eql(u8, input, buffers.output[0..outcome.written])) return fail(tally, name, setting, "stdx", "gave other octets");
    const zlib = oracle.zlib_decode(.raw, stream, buffers.zlib_output);
    if (zlib.verdict != .ok or zlib.consumed != stream.len or !std.mem.eql(u8, input, buffers.zlib_output[0..zlib.written])) {
        return fail(tally, name, setting, "zlib", "disagreed with the input");
    }
    const wuffs = oracle.wuffs_decode(.raw, stream, buffers.wuffs_output);
    if (wuffs.verdict != .ok or !std.mem.eql(u8, input, buffers.wuffs_output[0..wuffs.written])) {
        return fail(tally, name, setting, "Wuffs", "disagreed with the input");
    }
}

fn fail(tally: *Tally, name: []const u8, setting: Setting, who: []const u8, what: []const u8) void {
    tally.failures += 1;
    std.debug.print("differential-deflate FAILED: {s}, level {d} {t}, window bits {d}, memory level {d}, {d} flush points: {s} {s}\n", .{
        name,                       setting.encoding.level, setting.encoding.strategy, setting.encoding.window_bits,
        setting.encoding.mem_level, setting.point_count,    who,                       what,
    });
}

/// Every level and strategy over the prefix, then the whole file at zlib's default.
fn check_matrix(name: []const u8, input: []const u8, buffers: Buffers, tally: *Tally) void {
    const prefix = input[0..@min(input.len, matrix_input_len_max)];
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(0, name));
    var level: c_int = 0;
    while (level <= oracle.level_max) : (level += 1) {
        for (std.enums.values(oracle.Strategy)) |strategy| {
            const setting = draw_setting(&generator, level, strategy, prefix.len);
            check_stream(name, setting, prefix, buffers, generator.next(), tally);
        }
    }
    if (input.len > prefix.len) {
        const setting: Setting = .{
            .encoding = .{ .container = .raw, .level = whole_file_level, .strategy = .default },
            .points = undefined,
            .point_count = 0,
        };
        check_stream(name, setting, input, buffers, generator.next(), tally);
    }
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    var names: std.ArrayList([]const u8) = .empty;
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse {
            std.debug.print("differential-deflate: {s} is not <name>=<path>\n", .{argument});
            std.process.exit(usage_exit_status);
        };
        try names.append(arena, argument[0..split]);
    }
    if (!corpus.is_whole(names.items)) {
        std.debug.print("differential-deflate FAILED: the build passed {d} files, not the {d} of decision 15\n", .{
            names.items.len, corpus.names.len,
        });
        std.process.exit(1);
    }
    const states = try arena.create([codec.split.state_slots]deflate.Decoder);
    var matrix: Tally = .{};
    var corruptions: deflate_corrupt.Tally = .{};
    for (args[1..], names.items) |argument, name| {
        const input = try std.Io.Dir.cwd().readFileAlloc(init.io, argument[name.len + 1 ..], arena, .unlimited);
        const encoded_len = oracle.zlib_bound(.raw, input.len) + oracle.flush_points_max * oracle.flush_overhead_len_max;
        const buffers: Buffers = .{
            .encoded = try arena.alloc(u8, encoded_len),
            .output = try arena.alloc(u8, @max(input.len, deflate_corrupt.output_len_max)),
            .zlib_output = try arena.alloc(u8, @max(input.len, deflate_corrupt.output_len_max)),
            .wuffs_output = try arena.alloc(u8, @max(input.len, deflate_corrupt.output_len_max)),
            .states = states,
        };
        var file_tally: Tally = .{};
        check_matrix(name, input, buffers, &file_tally);
        const file_corruptions = deflate_corrupt.check_file(name, input, buffers);
        std.debug.print("differential-deflate: {s}: {d} streams, {d} failed; {d} corruptions, {d} failed, {d} allowed by a verdict entry\n", .{
            name, file_tally.streams, file_tally.failures, file_corruptions.inputs, file_corruptions.failures, file_corruptions.allowed,
        });
        matrix.streams += file_tally.streams;
        matrix.octets += file_tally.octets;
        matrix.failures += file_tally.failures;
        corruptions.add(file_corruptions);
    }
    std.debug.print("differential-deflate: {d} files, {d} streams of {d} octets, {d} failed; {d} corruptions, {d} failed, {d} allowed by a verdict entry\n", .{
        names.items.len, matrix.streams, matrix.octets, matrix.failures, corruptions.inputs, corruptions.failures, corruptions.allowed,
    });
    if (matrix.failures != 0 or corruptions.failures != 0) std.process.exit(1);
}
