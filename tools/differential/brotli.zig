//! `zig build differential-brotli -Doracles`: design §8 step 12's check of the brotli decoder against
//! Google's brotli (decision 15).
//!
//! The matrix: the first `matrix_input_len_max` octets of every corpus file, encoded by Google's
//! brotli at each quality of `qualities` with each WBITS of `window_bits`, NPOSTFIX, NDIRECT and a
//! flush interval a seed draws. stdx's HTTP instance decodes each stream whole and under a seeded
//! split that moves the state between calls (invariant 12); Google's decoder decodes it too; both
//! must give back the input. A file longer than the prefix also runs whole at `whole_file_quality`.
//! Last come the corruptions of brotli_corrupt.zig, judged against Google's verdicts.
//!
//! The seeds come from the file's name, so a failure replays on every host.
//!
//! Usage: `differential_brotli <name>=<path>...`. Exit status 0 when every stream agrees, 1 when any
//! does not, 2 on a usage error.

const std = @import("std");
const oracle = @import("oracle");
const corpus = @import("corpus");
const codec = @import("codec");
const brotli = @import("brotli");
const brotli_corrupt = @import("brotli_corrupt.zig");
const verdicts = @import("verdicts");

/// The prefix of each file the matrix runs over: a quarter MiB.
pub const matrix_input_len_max = 256 * 1024;

/// The qualities and WBITS the matrix encodes with: the two one-pass qualities, the middle, a strong
/// one and the strongest; the default window, the smallest, a small one and the largest (RFC 7932
/// §9.1). Quality 11 is slow, so it takes the default and the smallest window alone.
const qualities = [_]c_int{ 0, 1, 5, 9 };
const window_bits = [_]c_int{ 22, 10, 16, 24 };
const strongest_quality = 11;
const strongest_window_bits = [_]c_int{ 22, 10 };

/// The quality of the whole-file runs: the middle one, which servers use for content they compress
/// per response.
const whole_file_quality = 5;

/// NPOSTFIX 0 to 3 and NDIRECT's four high bits (RFC 7932 §4, §9.2), and the flush intervals a seed
/// draws from: none, or a meta-block every so many octets.
const postfix_bits_max = 3;
const direct_high_max = 15;
const flush_intervals = [_]usize{ 0, 0, 1000, 65536 };

/// The exit status of a usage error.
const usage_exit_status = 2;

const Decoder = brotli.HttpDecoder;

/// Counts for the report.
pub const Tally = struct {
    streams: usize = 0,
    octets: usize = 0,
    failures: usize = 0,
};

/// The buffers one file's checks share.
pub const Buffers = struct {
    stream: []u8,
    output: []u8,
    oracle_output: []u8,
    decoders: *[codec.split.state_slots]Decoder,
};

fn fail(tally: *Tally, name: []const u8, what: []const u8, encoding: oracle.BrotliEncoding, detail: []const u8) void {
    tally.failures += 1;
    std.debug.print("differential-brotli FAILED: {s}, quality {d}, WBITS {d}, NPOSTFIX {?d}, NDIRECT {?d}, flush every {d}: {s}: {s}\n", .{
        name, encoding.quality, encoding.window_bits, encoding.postfix_bits, encoding.direct_count, encoding.flush_every, what, detail,
    });
}

fn step(decoder: *Decoder, input: []const u8, output: []u8) brotli.Error!codec.Progress {
    return decoder.decode(input, output);
}

/// One stream of `input` at `encoding`: stdx whole, stdx under a split, and Google's decoder must
/// each give back `input`.
pub fn check_stream(tally: *Tally, buffers: Buffers, name: []const u8, input: []const u8, encoding: oracle.BrotliEncoding, seed: u64) void {
    tally.streams += 1;
    tally.octets += input.len;
    const stream_len = oracle.brotli_encode(encoding, input, buffers.stream) orelse return fail(tally, name, "Google's brotli", encoding, "did not encode");
    const stream = buffers.stream[0..stream_len];
    const google = oracle.brotli_decode_verdict(stream, buffers.oracle_output);
    if (google.verdict != .ok or !std.mem.eql(u8, input, buffers.oracle_output[0..google.written])) return fail(tally, name, "Google's brotli", encoding, "did not decode its own stream");
    buffers.decoders[0].init(codec.Features.detect());
    const whole = buffers.decoders[0].decode_all(stream, buffers.output) catch |err| return fail(tally, name, "stdx whole", encoding, @errorName(err));
    if (whole.consumed != stream.len or !std.mem.eql(u8, input, buffers.output[0..whole.written])) return fail(tally, name, "stdx whole", encoding, "decoded other octets");
    buffers.decoders[0].init(codec.Features.detect());
    const outcome = codec.split.drive(Decoder, buffers.decoders, step, stream, buffers.output, seed) catch |err| return fail(tally, name, "stdx split", encoding, @errorName(err));
    if (outcome.status != .done or !std.mem.eql(u8, input, buffers.output[0..outcome.written])) return fail(tally, name, "stdx split", encoding, "decoded other octets");
}

/// An encoding at `quality` and `window`, with NPOSTFIX, NDIRECT and a flush interval the seed draws.
fn seeded_encoding(generator: *codec.split.Generator, quality: c_int, window: c_int) oracle.BrotliEncoding {
    const postfix_bits: u2 = @intCast(generator.below(postfix_bits_max + 1));
    return .{
        .quality = quality,
        .window_bits = window,
        .postfix_bits = postfix_bits,
        .direct_count = @intCast(generator.below(direct_high_max + 1) << postfix_bits),
        .flush_every = flush_intervals[generator.below(flush_intervals.len)],
    };
}

/// Every check of one file.
pub fn check_file(tally: *Tally, buffers: Buffers, name: []const u8, input: []const u8) void {
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(0, name));
    const prefix = input[0..@min(input.len, matrix_input_len_max)];
    for (qualities) |quality| {
        for (window_bits) |window| check_stream(tally, buffers, name, prefix, seeded_encoding(&generator, quality, window), generator.next());
    }
    for (strongest_window_bits) |window| check_stream(tally, buffers, name, prefix, seeded_encoding(&generator, strongest_quality, window), generator.next());
    if (input.len > prefix.len) check_stream(tally, buffers, name, input, .{ .quality = whole_file_quality }, generator.next());
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    var names: std.ArrayList([]const u8) = .empty;
    var paths: std.ArrayList([]const u8) = .empty;
    for (args[1..]) |argument| {
        const split = std.mem.indexOfScalar(u8, argument, '=') orelse {
            std.debug.print("differential-brotli: {s} is not <name>=<path>\n", .{argument});
            std.process.exit(usage_exit_status);
        };
        try names.append(arena, argument[0..split]);
        try paths.append(arena, argument[split + 1 ..]);
    }
    if (!corpus.is_whole(names.items)) {
        std.debug.print("differential-brotli FAILED: the build passed {d} files, not the {d} of decision 15\n", .{ names.items.len, corpus.names.len });
        std.process.exit(1);
    }
    const decoders = try arena.create([codec.split.state_slots]Decoder);
    const corrupt_buffers: brotli_corrupt.Buffers = .{
        .base = try arena.alloc(u8, oracle.brotli_bound(brotli_corrupt.base_input_len_max)),
        .corrupted = try arena.alloc(u8, brotli_corrupt.corrupted_len(oracle.brotli_bound(brotli_corrupt.base_input_len_max))),
        .output = try arena.alloc(u8, brotli_corrupt.output_len_max),
        .oracle_output = try arena.alloc(u8, brotli_corrupt.output_len_max),
        .decoder = &decoders[0],
    };
    var total: Tally = .{};
    var corrupt_total: brotli_corrupt.Tally = .{};
    for (names.items, paths.items) |name, path| {
        const input = try std.Io.Dir.cwd().readFileAlloc(init.io, path, arena, .unlimited);
        const buffers: Buffers = .{
            .stream = try arena.alloc(u8, oracle.brotli_bound(input.len)),
            .output = try arena.alloc(u8, input.len + 1),
            .oracle_output = try arena.alloc(u8, input.len + 1),
            .decoders = decoders,
        };
        var tally: Tally = .{};
        check_file(&tally, buffers, name, input);
        const corrupt_tally = brotli_corrupt.check_file(name, input, corrupt_buffers);
        corrupt_total.add(corrupt_tally);
        std.debug.print("differential-brotli: {s}: {d} streams, {d} failed; {d} corrupted inputs, {d} allowed, {d} failed\n", .{
            name, tally.streams, tally.failures, corrupt_tally.inputs, corrupt_tally.allowed, corrupt_tally.failures,
        });
        total.streams += tally.streams;
        total.octets += tally.octets;
        total.failures += tally.failures;
    }
    for (verdicts.brotli_entries, corrupt_total.allowed_by) |entry, allowed| {
        std.debug.print("differential-brotli: {d} allowed: {s}\n", .{ allowed, entry.shape });
    }
    std.debug.print("differential-brotli: corruptions: {d} inputs, {d} allowed by verdict entries, {d} failed\n", .{
        corrupt_total.inputs, corrupt_total.allowed, corrupt_total.failures,
    });
    std.debug.print("differential-brotli: {d} files, {d} streams, {d} failed\n", .{ names.items.len, total.streams, total.failures + corrupt_total.failures });
    if (total.failures != 0 or corrupt_total.failures != 0) std.process.exit(1);
}
