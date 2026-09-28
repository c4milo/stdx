//! The corruptions of decision 15 for brotli: from Google's streams of the first
//! `base_input_len_max` octets of each corpus file at each of `base_encodings`, a seed makes invalid
//! ones:
//!
//! - a cut at every offset;
//! - 1 to `flips_max` flipped bits, half of them within `edge_len` of either end, where the stream
//!   header and the last meta-block's padding are;
//! - octets appended after the stream;
//! - the stream header's WBITS as the pattern RFC 7932 §9.1 calls invalid, a padding bit set in
//!   the last octet, and a stream of RFC 9841's large window.
//!
//! stdx's HTTP decoder and Google's streaming decoder each give every input a verdict. Where both
//! accept, their outputs must be identical; where the verdicts differ, an entry of
//! tools/oracle/verdicts_brotli.zig must allow the difference.

const std = @import("std");
const oracle = @import("oracle");
const codec = @import("codec");
const brotli = @import("brotli");
const verdicts = @import("verdicts");

const Decoder = brotli.HttpDecoder;

/// The prefix each base stream encodes.
pub const base_input_len_max = 4096;

/// The octets either decoder may write for one corrupted input before its verdict is "no room".
pub const output_len_max = 1 << 20;

/// The flipped-bit cases per base stream, and the most bits one flips.
const flip_cases = 48;
const flips_max = 8;

/// The octets at each end of a stream that half of the flips land in.
const edge_len = 16;

/// The appended-octet cases per base stream, and the most octets one appends.
const append_cases = 4;
const append_len_max = 16;

/// The base streams: one pass at quality 1; quality 5 with a meta-block every 1000 octets; and
/// quality 11 with the smallest window, NPOSTFIX 2 and NDIRECT 8, whose meta-blocks carry complex
/// codes, context maps and block switches.
const base_encodings = [_]oracle.BrotliEncoding{
    .{ .quality = 1, .window_bits = 16 },
    .{ .quality = 5, .flush_every = 1000 },
    .{ .quality = 11, .window_bits = 10, .postfix_bits = 2, .direct_count = 8 },
};

/// The WBITS pattern RFC 7932 §9.1 calls invalid, 0010001, and an eighth bit of 1, which makes it no
/// large window's signature (RFC 9841 §6): the first octet, least significant bit first.
const window_bits_invalid: u8 = 0x91;

/// A verdict, and where it stopped.
const Verdict = struct {
    kind: verdicts.Kind,
    consumed: usize = 0,
    written: usize = 0,
    stdx_error: []const u8 = "",
};

/// Counts for the report.
pub const Tally = struct {
    inputs: usize = 0,
    failures: usize = 0,
    allowed: usize = 0,
    /// The inputs each verdict entry allowed, in the entries' order.
    allowed_by: [verdicts.brotli_entries.len]usize = @splat(0),

    pub fn add(self: *Tally, other: Tally) void {
        self.inputs += other.inputs;
        self.failures += other.failures;
        self.allowed += other.allowed;
        for (&self.allowed_by, other.allowed_by) |*mine, theirs| mine.* += theirs;
    }
};

/// The buffers one file's corruptions share.
pub const Buffers = struct {
    base: []u8,
    corrupted: []u8,
    output: []u8,
    oracle_output: []u8,
    decoder: *Decoder,
};

/// The input a judge reads: which file, which base stream, which corruption, and the octets.
const Case = struct {
    name: []const u8,
    quality: c_int,
    what: []const u8,
    input: []const u8,
};

fn stdx_verdict(decoder: *Decoder, input: []const u8, output: []u8) Verdict {
    decoder.init(codec.Features.detect());
    const whole = decoder.decode_all(input, output) catch |err| return switch (err) {
        error.Truncated => .{ .kind = .incomplete },
        error.NoSpaceLeft => .{ .kind = .no_room },
        else => .{ .kind = .refused, .stdx_error = @errorName(err) },
    };
    return .{ .kind = .ok, .consumed = whole.consumed, .written = whole.written };
}

fn google_verdict(input: []const u8, output: []u8) Verdict {
    const result = oracle.brotli_decode_verdict(input, output);
    const kind: verdicts.Kind = switch (result.verdict) {
        .ok => .ok,
        .refused, .failed => .refused,
        .incomplete => .incomplete,
        .no_room => .no_room,
    };
    return .{ .kind = kind, .consumed = result.consumed, .written = result.written };
}

/// Judges one input by decision 15's rules, and counts it. Returns stdx's verdict.
fn judge(case: Case, buffers: Buffers, tally: *Tally) verdicts.Kind {
    tally.inputs += 1;
    const stdx = stdx_verdict(buffers.decoder, case.input, buffers.output[0..output_len_max]);
    const google = google_verdict(case.input, buffers.oracle_output[0..output_len_max]);
    if (stdx.kind == google.kind) {
        if (outputs_agree(stdx, google, buffers)) return stdx.kind;
        tally.failures += 1;
        std.debug.print("differential-brotli FAILED: {s}, quality {d}, {s}: both {t}, with different octets or ends\n", .{
            case.name, case.quality, case.what, stdx.kind,
        });
        return stdx.kind;
    }
    if (verdicts.find_brotli(.{ .input = case.input, .oracle_consumed = google.consumed }, stdx.kind, stdx.stdx_error, google.kind)) |entry| {
        tally.allowed += 1;
        // Through a slice: the entries may be none, and an empty array takes no index.
        const allowed_by: []usize = &tally.allowed_by;
        allowed_by[entry] += 1;
        return stdx.kind;
    }
    tally.failures += 1;
    std.debug.print("differential-brotli FAILED: {s}, quality {d}, {s}: stdx {t} {s}, Google's brotli {t}, and no verdict entry\n", .{
        case.name, case.quality, case.what, stdx.kind, stdx.stdx_error, google.kind,
    });
    return stdx.kind;
}

/// When both accept: the same octets written, and the same end.
fn outputs_agree(stdx: Verdict, google: Verdict, buffers: Buffers) bool {
    switch (stdx.kind) {
        .refused, .incomplete, .no_room => return true,
        .ok => {},
    }
    if (stdx.written != google.written or stdx.consumed != google.consumed) return false;
    return std.mem.eql(u8, buffers.output[0..stdx.written], buffers.oracle_output[0..stdx.written]);
}

fn judge_as(base: Case, what: []const u8, input: []const u8, buffers: Buffers, tally: *Tally) void {
    _ = judge(.{ .name = base.name, .quality = base.quality, .what = what, .input = input }, buffers, tally);
}

/// Every corruption of every base stream of one file.
pub fn check_file(name: []const u8, input: []const u8, buffers: Buffers) Tally {
    var tally: Tally = .{};
    const prefix = input[0..@min(input.len, base_input_len_max)];
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(1, name));
    for (base_encodings) |encoding| {
        const stream_len = oracle.brotli_encode(encoding, prefix, buffers.base) orelse {
            tally.failures += 1;
            std.debug.print("differential-brotli FAILED: {s}, quality {d}: Google's brotli could not encode a base stream\n", .{ name, encoding.quality });
            continue;
        };
        const base: Case = .{ .name = name, .quality = encoding.quality, .what = "", .input = buffers.base[0..stream_len] };
        if (judge(.{ .name = name, .quality = encoding.quality, .what = "the base stream", .input = base.input }, buffers, &tally) != .ok) {
            tally.failures += 1;
            std.debug.print("differential-brotli FAILED: {s}, quality {d}: stdx did not decode the base stream\n", .{ name, encoding.quality });
        }
        corrupt_stream(base, buffers, &generator, &tally);
        corrupt_header(base, buffers, &tally);
    }
    const large_len = oracle.brotli_encode(.{ .quality = 5, .large_window = true, .window_bits = 26 }, prefix, buffers.base) orelse return tally;
    judge_as(.{ .name = name, .quality = 5, .what = "", .input = &.{} }, "a large window's stream", buffers.base[0..large_len], buffers, &tally);
    return tally;
}

fn corrupt_stream(base: Case, buffers: Buffers, generator: *codec.split.Generator, tally: *Tally) void {
    const valid = base.input;
    const corrupted = buffers.corrupted;
    for (0..valid.len) |cut| judge_as(base, "a cut", valid[0..cut], buffers, tally);
    for (0..flip_cases) |_| {
        @memcpy(corrupted[0..valid.len], valid);
        for (0..generator.between(1, flips_max)) |_| {
            const octet = flipped_octet(generator, valid.len);
            corrupted[octet] ^= @as(u8, 1) << @intCast(generator.below(@bitSizeOf(u8)));
        }
        judge_as(base, "flipped bits", corrupted[0..valid.len], buffers, tally);
    }
    for (0..append_cases) |_| {
        @memcpy(corrupted[0..valid.len], valid);
        const appended = generator.between(1, append_len_max);
        for (corrupted[valid.len..][0..appended]) |*octet| octet.* = @truncate(generator.next());
        judge_as(base, "octets appended", corrupted[0 .. valid.len + appended], buffers, tally);
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

fn corrupt_header(base: Case, buffers: Buffers, tally: *Tally) void {
    var rewritten = buffers.corrupted[0..base.input.len];
    @memcpy(rewritten, base.input);
    rewritten[0] = window_bits_invalid;
    judge_as(base, "WBITS's invalid pattern", rewritten, buffers, tally);
    @memcpy(rewritten, base.input);
    // The last octet's highest bit is padding unless the stream's last bit landed there.
    if (rewritten[rewritten.len - 1] & 0x80 == 0) {
        rewritten[rewritten.len - 1] |= 0x80;
        judge_as(base, "a padding bit set", rewritten, buffers, tally);
    }
}

/// The octets `buffers.corrupted` needs: a base stream and the most any corruption adds.
pub fn corrupted_len(base_len: usize) usize {
    return base_len + append_len_max;
}
