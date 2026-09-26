//! `zig build differential-deflate -Doracles`: design §8 steps 5 and 6's check of the DEFLATE,
//! zlib and gzip decoders against zlib and Wuffs (decision 15), over all three containers.
//!
//! The matrix: the first `matrix_input_len_max` octets of every corpus file, encoded by zlib in
//! each container at every level (0 to 9) and every strategy, with the window bits (9 to 15), the memory level (1 to
//! 9) and up to `flush_points_drawn_max` flush points of every kind a seed draws. Each stream is
//! decoded by stdx under a seeded split that moves the state between calls (invariant 12), and by
//! zlib and Wuffs; each must end the stream, give back the input, and stdx and zlib must stop at
//! the stream's last octet. A file longer than the prefix also runs whole, at zlib's default.
//!
//! The corruptions of deflate_corrupt.zig and deflate_fields.zig follow, judged against zlib's and
//! Wuffs's verdicts.
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
const zlib = @import("zlib");
const gzip = @import("gzip");
const verdicts = @import("verdicts");
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

/// The containers, in the order the matrix and the corruptions run them.
pub const containers = std.enums.values(oracle.Container);

/// The states a split moves between, for each container's decoder.
pub const States = struct {
    raw: [codec.split.state_slots]deflate.Decoder,
    zlib: [codec.split.state_slots]zlib.Decoder,
    gzip: [codec.split.state_slots]gzip.Decoder,
};

/// The buffers one file's checks reuse.
pub const Buffers = struct {
    encoded: []u8,
    output: []u8,
    zlib_output: []u8,
    wuffs_output: []u8,
    states: *States,
};

/// stdx's module for a container.
fn Codec(comptime container: oracle.Container) type {
    return switch (container) {
        .raw => deflate,
        .zlib => zlib,
        .gzip => gzip,
    };
}

/// The name of stdx's module for a container, as the verdict entries give it.
pub fn codec_name(container: oracle.Container) []const u8 {
    return switch (container) {
        .raw => "deflate",
        .zlib => "zlib",
        .gzip => "gzip",
    };
}

/// stdx's decode of `stream` under `seed`'s split.
pub fn stdx_split(container: oracle.Container, buffers: Buffers, stream: []const u8, output: []u8, seed: u64) !codec.split.Outcome {
    switch (container) {
        inline else => |known| {
            const module = Codec(known);
            const states = &@field(buffers.states, @tagName(known));
            module.init(&states[0], .{});
            return codec.split.drive(module.Decoder, states, module.decode, stream, output, seed);
        },
    }
}

/// A decoder's verdict on one input, and what it wrote. For stdx, where its DEFLATE decoder
/// stopped as well.
pub const Verdict = struct {
    kind: verdicts.Kind,
    stdx_error: []const u8 = "",
    consumed: usize = 0,
    written: usize = 0,
    stopped_in_dynamic_header: bool = false,
    distance_count: u16 = 0,
    trailer_held_len: usize = 0,
};

/// Where stdx stopped: inside a dynamic block's header, or in a container's trailer after the
/// DEFLATE stream ended.
fn stopped_at(decoder: anytype, verdict: Verdict) Verdict {
    var result = verdict;
    const stream = deflate_decoder(decoder);
    result.stopped_in_dynamic_header = switch (stream.phase) {
        .table_counts, .code_length_code, .code_lengths => !stream.fixed_codes,
        else => false,
    };
    result.distance_count = stream.distance_count;
    if (@TypeOf(decoder.*) != deflate.Decoder and stream.phase == .done) {
        result.trailer_held_len = decoder.field.held().len;
    }
    return result;
}

/// The DEFLATE decoder inside a container's decoder.
fn deflate_decoder(decoder: anytype) *const deflate.Decoder {
    return if (@TypeOf(decoder.*) == deflate.Decoder) decoder else &decoder.stream;
}

/// stdx's decode of `input` in one call.
pub fn stdx_whole(container: oracle.Container, buffers: Buffers, input: []const u8, output: []u8) Verdict {
    switch (container) {
        inline else => |known| {
            const module = Codec(known);
            const decoder = &@field(buffers.states, @tagName(known))[0];
            module.init(decoder, .{});
            const progress = module.decode(decoder, input, output) catch |err| {
                return stopped_at(decoder, .{ .kind = .refused, .stdx_error = @errorName(err) });
            };
            const kind: verdicts.Kind = switch (progress.status) {
                .done => .ok,
                .needs_input => .incomplete,
                .needs_room => .no_room,
            };
            return stopped_at(decoder, .{ .kind = kind, .consumed = progress.consumed, .written = progress.written });
        },
    }
}

/// A seeded encoding: its settings and flush points.
const Setting = struct {
    encoding: oracle.Encoding,
    points: [flush_points_drawn_max]oracle.FlushPoint,
    point_count: usize,
};

fn draw_setting(generator: *codec.split.Generator, container: oracle.Container, level: c_int, strategy: oracle.Strategy, input_len: usize) Setting {
    var setting: Setting = .{
        .encoding = .{
            .container = container,
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
    const container = setting.encoding.container;
    const outcome = stdx_split(container, buffers, stream, buffers.output[0..input.len], seed) catch |err| {
        std.debug.print("differential-deflate FAILED: {s}, {t}, level {d} {t}, seed {d}: stdx refused it: {t}\n", .{
            name, container, setting.encoding.level, setting.encoding.strategy, seed, err,
        });
        tally.failures += 1;
        return;
    };
    if (outcome.status != .done) return fail(tally, name, setting, "stdx", "did not end the stream");
    if (outcome.consumed != stream.len) return fail(tally, name, setting, "stdx", "did not stop at the stream's end");
    if (!std.mem.eql(u8, input, buffers.output[0..outcome.written])) return fail(tally, name, setting, "stdx", "gave other octets");
    const by_zlib = oracle.zlib_decode(container, stream, buffers.zlib_output);
    if (by_zlib.verdict != .ok or by_zlib.consumed != stream.len or !std.mem.eql(u8, input, buffers.zlib_output[0..by_zlib.written])) {
        return fail(tally, name, setting, "zlib", "disagreed with the input");
    }
    const wuffs = oracle.wuffs_decode(container, stream, buffers.wuffs_output);
    if (wuffs.verdict != .ok or !std.mem.eql(u8, input, buffers.wuffs_output[0..wuffs.written])) {
        return fail(tally, name, setting, "Wuffs", "disagreed with the input");
    }
}

fn fail(tally: *Tally, name: []const u8, setting: Setting, who: []const u8, what: []const u8) void {
    tally.failures += 1;
    std.debug.print("differential-deflate FAILED: {s}, {t}, level {d} {t}, window bits {d}, memory level {d}, {d} flush points: {s} {s}\n", .{
        name,                         setting.encoding.container, setting.encoding.level, setting.encoding.strategy,
        setting.encoding.window_bits, setting.encoding.mem_level, setting.point_count,    who,
        what,
    });
}

/// Every container, level and strategy over the prefix, then the whole file at zlib's default.
fn check_matrix(name: []const u8, input: []const u8, buffers: Buffers, tally: *Tally) void {
    const prefix = input[0..@min(input.len, matrix_input_len_max)];
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(0, name));
    for (containers) |container| {
        var level: c_int = 0;
        while (level <= oracle.level_max) : (level += 1) {
            for (std.enums.values(oracle.Strategy)) |strategy| {
                const setting = draw_setting(&generator, container, level, strategy, prefix.len);
                check_stream(name, setting, prefix, buffers, generator.next(), tally);
            }
        }
        if (input.len > prefix.len) {
            const setting: Setting = .{
                .encoding = .{ .container = container, .level = whole_file_level, .strategy = .default },
                .points = undefined,
                .point_count = 0,
            };
            check_stream(name, setting, input, buffers, generator.next(), tally);
        }
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
    const states = try arena.create(States);
    var matrix: Tally = .{};
    var corruptions: deflate_corrupt.Tally = .{};
    for (args[1..], names.items) |argument, name| {
        const input = try std.Io.Dir.cwd().readFileAlloc(init.io, argument[name.len + 1 ..], arena, .unlimited);
        const encoded_len = oracle.zlib_bound(.gzip, input.len) + oracle.flush_points_max * oracle.flush_overhead_len_max;
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
    for (verdicts.entries, corruptions.allowed_by) |entry, allowed| {
        std.debug.print("differential-deflate: {d} allowed: {s}\n", .{ allowed, entry.shape });
    }
    if (matrix.failures != 0 or corruptions.failures != 0) std.process.exit(1);
}
