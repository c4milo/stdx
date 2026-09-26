//! The corruptions of decision 15 for DEFLATE and its containers: from a valid stream of the first
//! `base_input_len_max` octets of each corpus file, in each container at each of `base_encodings`,
//! a seed makes invalid ones:
//!
//! - a cut at every offset;
//! - 1 to `flips_max` flipped bits, weighted toward the stream's first and last octets, where the
//!   headers and the final block's end are;
//! - octets appended after the stream;
//! - the first block's header fields set to what RFC 1951 forbids or allows only at its edge: BTYPE
//!   11, and HLIT and HDIST at their largest values;
//! - the containers' own fields, which deflate_fields.zig sets.
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
const deflate_fields = @import("deflate_fields.zig");
const Verdict = differential.Verdict;

/// The prefix each base stream encodes.
pub const base_input_len_max = 4096;

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
    /// The inputs each verdict entry allowed, in the entries' order.
    allowed_by: [verdicts.entries.len]usize = @splat(0),

    pub fn add(self: *Tally, other: Tally) void {
        self.inputs += other.inputs;
        self.failures += other.failures;
        self.allowed += other.allowed;
        for (&self.allowed_by, other.allowed_by) |*mine, theirs| mine.* += theirs;
    }
};

fn oracle_verdict(result: oracle.Result) Verdict {
    const kind: verdicts.Kind = switch (result.verdict) {
        .ok => .ok,
        .refused, .failed => .refused,
        .incomplete => .incomplete,
        .no_room => .no_room,
    };
    return .{ .kind = kind, .consumed = result.consumed, .written = result.written };
}

/// The input a judge reads: which file, which corruption, and the corrupted octets.
pub const Case = struct {
    name: []const u8,
    container: oracle.Container,
    what: []const u8,
    input: []const u8,
};

/// Judges one input by decision 15's rules, and counts it. Returns stdx's verdict.
pub fn judge(case: Case, buffers: differential.Buffers, tally: *Tally) verdicts.Kind {
    tally.inputs += 1;
    const input = case.input;
    const stdx = differential.stdx_whole(case.container, buffers, input, buffers.output[0..output_len_max]);
    const zlib = oracle_verdict(oracle.zlib_decode(case.container, input, buffers.zlib_output[0..output_len_max]));
    const wuffs = oracle_verdict(oracle.wuffs_decode(case.container, input, buffers.wuffs_output[0..output_len_max]));
    if (stdx.kind == zlib.kind and zlib.kind == wuffs.kind) {
        if (outputs_agree(stdx, zlib, wuffs, buffers)) return stdx.kind;
        tally.failures += 1;
        std.debug.print("differential-deflate FAILED: {s}, {t}, {s}: all three {t}, with different octets or ends\n", .{
            case.name, case.container, case.what, stdx.kind,
        });
        return stdx.kind;
    }
    const facts: verdicts.Facts = .{
        .input = input,
        .stopped_in_dynamic_header = stdx.stopped_in_dynamic_header,
        .distance_count = stdx.distance_count,
        .trailer_held_len = stdx.trailer_held_len,
    };
    if (verdicts.find(differential.codec_name(case.container), facts, stdx.kind, stdx.stdx_error, zlib.kind, wuffs.kind)) |entry| {
        tally.allowed += 1;
        tally.allowed_by[entry - &verdicts.entries[0]] += 1;
        return stdx.kind;
    }
    tally.failures += 1;
    std.debug.print("differential-deflate FAILED: {s}, {t}, {s}: stdx {t} {s}, zlib {t}, Wuffs {t}, and no verdict entry\n", .{
        case.name, case.container, case.what, stdx.kind, stdx.stdx_error, zlib.kind, wuffs.kind,
    });
    return stdx.kind;
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

/// Every corruption of every base stream of one file, in every container.
pub fn check_file(name: []const u8, input: []const u8, buffers: differential.Buffers) Tally {
    var tally: Tally = .{};
    const prefix = input[0..@min(input.len, base_input_len_max)];
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(1, name));
    var base: [2 * base_input_len_max]u8 = undefined;
    for (differential.containers) |container| {
        for (base_encodings) |base_encoding| {
            const encoding: oracle.Encoding = .{ .container = container, .level = base_encoding[0], .strategy = base_encoding[1] };
            const encoded = oracle.zlib_encode(encoding, prefix, &base);
            if (encoded.verdict != .ok) {
                tally.failures += 1;
                std.debug.print("differential-deflate FAILED: {s}, {t}: zlib could not encode a base stream\n", .{ name, container });
                continue;
            }
            const case: Case = .{ .name = name, .container = container, .what = "", .input = base[0..encoded.written] };
            corrupt_stream(case, buffers, &generator, &tally);
            corrupt_block_header(case, buffers, &tally);
            deflate_fields.corrupt(case, buffers, &tally);
        }
    }
    return tally;
}

/// Judges `input` as `what` in the stream's file and container.
pub fn judge_as(stream: Case, what: []const u8, input: []const u8, buffers: differential.Buffers, tally: *Tally) void {
    _ = judge(.{ .name = stream.name, .container = stream.container, .what = what, .input = input }, buffers, tally);
}

/// Judges `input`, a rewrite that stays valid, and requires stdx to decode it, so a rewrite that
/// broke the stream cannot pass as an agreement.
pub fn judge_valid_as(stream: Case, what: []const u8, input: []const u8, buffers: differential.Buffers, tally: *Tally) void {
    const kind = judge(.{ .name = stream.name, .container = stream.container, .what = what, .input = input }, buffers, tally);
    if (kind == .ok) return;
    tally.failures += 1;
    std.debug.print("differential-deflate FAILED: {s}, {t}, {s}: a valid rewrite, and stdx gave {t}\n", .{
        stream.name, stream.container, what, kind,
    });
}

fn corrupt_stream(stream: Case, buffers: differential.Buffers, generator: *codec.split.Generator, tally: *Tally) void {
    const valid = stream.input;
    var corrupted: [2 * base_input_len_max + append_len_max]u8 = undefined;
    for (0..valid.len) |cut| judge_as(stream, "a cut", valid[0..cut], buffers, tally);
    for (0..flip_cases) |_| {
        @memcpy(corrupted[0..valid.len], valid);
        for (0..generator.between(1, flips_max)) |_| {
            const octet = flipped_octet(generator, valid.len);
            corrupted[octet] ^= @as(u8, 1) << @intCast(generator.below(@bitSizeOf(u8)));
        }
        judge_as(stream, "flipped bits", corrupted[0..valid.len], buffers, tally);
    }
    for (0..append_cases) |_| {
        @memcpy(corrupted[0..valid.len], valid);
        const appended = generator.between(1, append_len_max);
        for (corrupted[valid.len..][0..appended]) |*octet| octet.* = @truncate(generator.next());
        judge_as(stream, "octets appended", corrupted[0 .. valid.len + appended], buffers, tally);
    }
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
fn corrupt_block_header(stream: Case, buffers: differential.Buffers, tally: *Tally) void {
    const start = deflate_fields.deflate_start(stream.container);
    const valid = stream.input;
    if (valid.len < start + 3) return;
    var corrupted: [2 * base_input_len_max]u8 = undefined;
    @memcpy(corrupted[0..valid.len], valid);
    // BTYPE, bits 1 and 2 of the block's first octet (RFC 1951 §3.2.3), set to 11.
    corrupted[start] |= 0b110;
    judge_as(stream, "BTYPE 11", corrupted[0..valid.len], buffers, tally);
    // A dynamic first block: HLIT is bits 3 to 7 of its first octet, HDIST bits 0 to 4 of the
    // second (RFC 1951 §3.2.7).
    if ((valid[start] >> 1) & 0b11 != 2) return;
    for ([_]u8{ 29, 30, 31 }) |hlit| {
        @memcpy(corrupted[0..valid.len], valid);
        corrupted[start] = (corrupted[start] & 0b111) | (hlit << 3);
        judge_as(stream, "HLIT at its edge", corrupted[0..valid.len], buffers, tally);
    }
    for ([_]u8{ 29, 30, 31 }) |hdist| {
        @memcpy(corrupted[0..valid.len], valid);
        corrupted[start + 1] = (corrupted[start + 1] & 0b1110_0000) | hdist;
        judge_as(stream, "HDIST at its edge", corrupted[0..valid.len], buffers, tally);
    }
}
