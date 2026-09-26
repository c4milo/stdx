//! The corruptions of decision 15 for raw DEFLATE: from a valid stream of the first
//! `base_input_len_max` octets of each corpus file at each of `base_encodings`, a seed makes
//! invalid ones:
//!
//! - a cut at every offset;
//! - 1 to `flips_max` flipped bits, weighted toward the stream's first and last octets, where the
//!   headers and the final block's end are;
//! - octets appended after the stream;
//! - header fields set to what RFC 1951 forbids or allows only at its edge: BTYPE 11, and HLIT and
//!   HDIST at their largest values.
//!
//! stdx, zlib and Wuffs each give every input a verdict. Where all three accept, their outputs must
//! be identical, and stdx and zlib must stop at the same octet; where any verdict differs, an entry
//! of tools/oracle/verdicts.zig must allow the difference.

const std = @import("std");
const oracle = @import("oracle");
const codec = @import("codec");
const deflate = @import("deflate");
const verdicts = @import("verdicts");
const differential = @import("deflate.zig");

/// The prefix each base stream encodes.
const base_input_len_max = 4096;

/// The octets any decoder may write for one corrupted input before its verdict is "no room".
pub const output_len_max = 1 << 20;

/// The flipped-bit cases per base stream, and the most bits one flips.
const flip_cases = 48;
const flips_max = 8;

/// The octets at each end of a stream that half of the flips land in.
const edge_len = 16;

/// The appended-octet cases per base stream, and the most octets one appends.
const append_cases = 4;
const append_len_max = 16;

/// The encodings of the base streams: every strategy, and the levels that make stored, fixed and
/// dynamic blocks.
const base_encodings = [_]struct { c_int, oracle.Strategy }{
    .{ 0, .default },      .{ 1, .default }, .{ 6, .default }, .{ 9, .filtered },
    .{ 6, .huffman_only }, .{ 6, .rle },     .{ 6, .fixed },
};

/// Counts for the report.
pub const Tally = struct {
    inputs: usize = 0,
    failures: usize = 0,
    allowed: usize = 0,

    pub fn add(self: *Tally, other: Tally) void {
        self.inputs += other.inputs;
        self.failures += other.failures;
        self.allowed += other.allowed;
    }
};

/// A decoder's verdict on one input, and what it wrote.
const Verdict = struct {
    kind: verdicts.Kind,
    stdx_error: []const u8 = "",
    consumed: usize = 0,
    written: usize = 0,
};

fn stdx_verdict(buffers: differential.Buffers, input: []const u8) Verdict {
    deflate.init(&buffers.states[0], .{});
    const output = buffers.output[0..output_len_max];
    const progress = deflate.decode(&buffers.states[0], input, output) catch |err| {
        return .{ .kind = .refused, .stdx_error = @errorName(err) };
    };
    const kind: verdicts.Kind = switch (progress.status) {
        .done => .ok,
        .needs_input => .incomplete,
        .needs_room => .no_room,
    };
    return .{ .kind = kind, .consumed = progress.consumed, .written = progress.written };
}

fn oracle_verdict(result: oracle.Result) Verdict {
    const kind: verdicts.Kind = switch (result.verdict) {
        .ok => .ok,
        .refused, .failed => .refused,
        .incomplete => .incomplete,
        .no_room => .no_room,
    };
    return .{ .kind = kind, .consumed = result.consumed, .written = result.written };
}

/// Judges one input by decision 15's rules, and counts it.
fn judge(name: []const u8, what: []const u8, input: []const u8, buffers: differential.Buffers, tally: *Tally) void {
    tally.inputs += 1;
    const stdx = stdx_verdict(buffers, input);
    const zlib = oracle_verdict(oracle.zlib_decode(.raw, input, buffers.zlib_output[0..output_len_max]));
    const wuffs = oracle_verdict(oracle.wuffs_decode(.raw, input, buffers.wuffs_output[0..output_len_max]));
    if (stdx.kind == zlib.kind and zlib.kind == wuffs.kind) {
        if (outputs_agree(stdx, zlib, wuffs, buffers)) return;
        tally.failures += 1;
        std.debug.print("differential-deflate FAILED: {s}, {s}: all three {t}, with different octets or ends\n", .{ name, what, stdx.kind });
        return;
    }
    if (verdicts.find("deflate", input, stdx.kind, stdx.stdx_error, zlib.kind, wuffs.kind) != null) {
        tally.allowed += 1;
        return;
    }
    tally.failures += 1;
    std.debug.print("differential-deflate FAILED: {s}, {s}: stdx {t} {s}, zlib {t}, Wuffs {t}, and no verdict entry\n", .{
        name, what, stdx.kind, stdx.stdx_error, zlib.kind, wuffs.kind,
    });
}

/// When all three agree on the verdict: the same octets written, and for a stream that ended,
/// stdx and zlib stopping at the same octet.
fn outputs_agree(stdx: Verdict, zlib: Verdict, wuffs: Verdict, buffers: differential.Buffers) bool {
    switch (stdx.kind) {
        .refused, .incomplete => return true,
        .ok, .no_room => {},
    }
    if (stdx.written != zlib.written or stdx.written != wuffs.written) return false;
    if (stdx.kind == .ok and stdx.consumed != zlib.consumed) return false;
    const written = buffers.output[0..stdx.written];
    return std.mem.eql(u8, written, buffers.zlib_output[0..stdx.written]) and
        std.mem.eql(u8, written, buffers.wuffs_output[0..stdx.written]);
}

/// Every corruption of every base stream of one file.
pub fn check_file(name: []const u8, input: []const u8, buffers: differential.Buffers) Tally {
    var tally: Tally = .{};
    const prefix = input[0..@min(input.len, base_input_len_max)];
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(1, name));
    var base: [2 * base_input_len_max]u8 = undefined;
    for (base_encodings) |base_encoding| {
        const encoding: oracle.Encoding = .{ .container = .raw, .level = base_encoding[0], .strategy = base_encoding[1] };
        const encoded = oracle.zlib_encode(encoding, prefix, &base);
        if (encoded.verdict != .ok) {
            tally.failures += 1;
            std.debug.print("differential-deflate FAILED: {s}: zlib could not encode a base stream\n", .{name});
            continue;
        }
        corrupt_stream(name, base[0..encoded.written], buffers, &generator, &tally);
    }
    return tally;
}

fn corrupt_stream(name: []const u8, stream: []const u8, buffers: differential.Buffers, generator: *codec.split.Generator, tally: *Tally) void {
    var corrupted: [2 * base_input_len_max + append_len_max]u8 = undefined;
    for (0..stream.len) |cut| judge(name, "a cut", stream[0..cut], buffers, tally);
    for (0..flip_cases) |_| {
        @memcpy(corrupted[0..stream.len], stream);
        for (0..generator.between(1, flips_max)) |_| {
            const octet = flipped_octet(generator, stream.len);
            corrupted[octet] ^= @as(u8, 1) << @intCast(generator.below(@bitSizeOf(u8)));
        }
        judge(name, "flipped bits", corrupted[0..stream.len], buffers, tally);
    }
    for (0..append_cases) |_| {
        @memcpy(corrupted[0..stream.len], stream);
        const appended = generator.between(1, append_len_max);
        for (corrupted[stream.len..][0..appended]) |*octet| octet.* = @truncate(generator.next());
        judge(name, "octets appended", corrupted[0 .. stream.len + appended], buffers, tally);
    }
    corrupt_fields(name, stream, buffers, tally);
}

/// An octet to flip: half the time within `edge_len` of either end.
fn flipped_octet(generator: *codec.split.Generator, len: usize) usize {
    const edge = @min(edge_len, len);
    return switch (generator.below(4)) {
        0 => generator.below(edge),
        1 => len - 1 - generator.below(edge),
        else => generator.below(len),
    };
}

/// The first block's header fields at the values RFC 1951 forbids or allows only at its edge.
fn corrupt_fields(name: []const u8, stream: []const u8, buffers: differential.Buffers, tally: *Tally) void {
    if (stream.len < 3) return;
    var corrupted: [2 * base_input_len_max]u8 = undefined;
    @memcpy(corrupted[0..stream.len], stream);
    // BTYPE, bits 1 and 2 of the first octet (RFC 1951 §3.2.3), set to 11.
    corrupted[0] |= 0b110;
    judge(name, "BTYPE 11", corrupted[0..stream.len], buffers, tally);
    // A dynamic first block: HLIT is bits 3 to 7 of the first octet, HDIST bits 0 to 4 of the
    // second (RFC 1951 §3.2.7).
    if ((stream[0] >> 1) & 0b11 != 2) return;
    for ([_]u8{ 29, 30, 31 }) |hlit| {
        @memcpy(corrupted[0..stream.len], stream);
        corrupted[0] = (corrupted[0] & 0b111) | (hlit << 3);
        judge(name, "HLIT at its edge", corrupted[0..stream.len], buffers, tally);
    }
    for ([_]u8{ 29, 30, 31 }) |hdist| {
        @memcpy(corrupted[0..stream.len], stream);
        corrupted[1] = (corrupted[1] & 0b1110_0000) | hdist;
        judge(name, "HDIST at its edge", corrupted[0..stream.len], buffers, tally);
    }
}
