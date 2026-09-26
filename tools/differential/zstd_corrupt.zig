//! The corruptions of decision 15 for Zstandard: from libzstd's frames of the first
//! `base_input_len_max` octets of each corpus file at each of `base_encodings`, a seed makes
//! invalid ones:
//!
//! - a cut at every offset;
//! - 1 to `flips_max` flipped bits, half of them within `edge_len` of either end, where the frame
//!   header and the Content_Checksum are;
//! - octets appended after the frame;
//! - the frame header's fields: the reserved bit and the unused bit set, a reserved Block_Type, a
//!   Window_Descriptor of exactly 2^23 and one past it, a Dictionary_ID, a Frame_Content_Size one
//!   off, and a wrong Content_Checksum.
//!
//! stdx's HTTP decoder and libzstd's streaming decoder, limited to the same window of 2^23, each
//! give every input a verdict. Where both accept, their outputs must be identical; where the
//! verdicts differ, an entry of tools/oracle/verdicts.zig must allow the difference.

const std = @import("std");
const oracle = @import("oracle");
const codec = @import("codec");
const zstd = @import("zstd");
const verdicts = @import("verdicts");

const constants = zstd.constants;
const Decoder = zstd.HttpDecoder;

/// The prefix each base frame encodes.
pub const base_input_len_max = 4096;

/// The octets either decoder may write for one corrupted input before its verdict is "no room".
pub const output_len_max = 1 << 20;

/// libzstd's window limit: the HTTP instance's 2^23 (RFC 9659 §3).
const window_log_max = 23;

/// The flipped-bit cases per base frame, and the most bits one flips.
const flip_cases = 48;
const flips_max = 8;

/// The octets at each end of a frame that half of the flips land in.
const edge_len = 16;

/// The appended-octet cases per base frame, and the most octets one appends.
const append_cases = 4;
const append_len_max = 16;

/// The most octets a header rewrite adds: a 1-octet Dictionary_ID.
const added_len_max = 1;

/// The base frames: a single segment with its checksum and content size; a Window_Descriptor with
/// neither; and 1 KiB windows, so 1 KiB blocks, whose later blocks repeat tables and trees.
const base_encodings = [_]oracle.ZstdEncoding{
    .{ .level = 1 },
    .{ .level = 3, .checksum = false, .content_size = false },
    .{ .level = 19, .window_log = 10 },
};

/// Frame_Header_Descriptor's Unused_Bit, which a decoder must not interpret (RFC 8878
/// §3.1.1.1.1.3).
const descriptor_unused: u8 = 0x10;

/// Window_Descriptor for exactly 2^23 (Exponent 13, Mantissa 0), and for an eighth more.
const window_http: u8 = 13 << constants.window_exponent_shift;
const window_past_http: u8 = window_http | 1;

/// The Dictionary_ID a rewrite adds, in one octet (Dictionary_ID_Flag 1).
const dictionary_id = 7;
const dictionary_flag_one_octet = 1;

/// Block_Type 3, Reserved, in a Block_Header's first octet (RFC 8878 §3.1.1.2.2).
const block_type_reserved: u8 = 3 << constants.block_type_shift;

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
    allowed_by: [verdicts.zstd_entries.len]usize = @splat(0),

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

/// The input a judge reads: which file, which base frame, which corruption, and the octets.
const Case = struct {
    name: []const u8,
    level: c_int,
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

fn libzstd_verdict(input: []const u8, output: []u8) Verdict {
    const result = oracle.zstd_decode_verdict(input, output, window_log_max);
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
    const libzstd = libzstd_verdict(case.input, buffers.oracle_output[0..output_len_max]);
    if (stdx.kind == libzstd.kind) {
        if (outputs_agree(stdx, libzstd, buffers)) return stdx.kind;
        tally.failures += 1;
        std.debug.print("differential-zstd FAILED: {s}, level {d}, {s}: both {t}, with different octets or ends\n", .{
            case.name, case.level, case.what, stdx.kind,
        });
        return stdx.kind;
    }
    if (verdicts.find_zstd(.{ .input = case.input }, stdx.kind, stdx.stdx_error, libzstd.kind)) |entry| {
        tally.allowed += 1;
        // Through a slice: the entries may be none, and an empty array takes no index.
        const allowed_by: []usize = &tally.allowed_by;
        allowed_by[entry] += 1;
        return stdx.kind;
    }
    tally.failures += 1;
    std.debug.print("differential-zstd FAILED: {s}, level {d}, {s}: stdx {t} {s}, libzstd {t}, and no verdict entry\n", .{
        case.name, case.level, case.what, stdx.kind, stdx.stdx_error, libzstd.kind,
    });
    return stdx.kind;
}

/// When both accept, or both run out of room: the same octets written, and at `ok`, the same end.
fn outputs_agree(stdx: Verdict, libzstd: Verdict, buffers: Buffers) bool {
    switch (stdx.kind) {
        .refused, .incomplete, .no_room => return true,
        .ok => {},
    }
    if (stdx.written != libzstd.written or stdx.consumed != libzstd.consumed) return false;
    return std.mem.eql(u8, buffers.output[0..stdx.written], buffers.oracle_output[0..stdx.written]);
}

fn judge_as(base: Case, what: []const u8, input: []const u8, buffers: Buffers, tally: *Tally) void {
    _ = judge(.{ .name = base.name, .level = base.level, .what = what, .input = input }, buffers, tally);
}

/// Judges `input`, a rewrite that stays valid, and requires stdx to decode it, so a rewrite that
/// broke the frame cannot pass as an agreement.
fn judge_valid_as(base: Case, what: []const u8, input: []const u8, buffers: Buffers, tally: *Tally) void {
    const kind = judge(.{ .name = base.name, .level = base.level, .what = what, .input = input }, buffers, tally);
    if (kind == .ok) return;
    tally.failures += 1;
    std.debug.print("differential-zstd FAILED: {s}, level {d}, {s}: a valid rewrite, and stdx gave {t}\n", .{
        base.name, base.level, what, kind,
    });
}

/// Every corruption of every base frame of one file.
pub fn check_file(name: []const u8, input: []const u8, buffers: Buffers) Tally {
    var tally: Tally = .{};
    const prefix = input[0..@min(input.len, base_input_len_max)];
    var generator = codec.split.Generator.init(std.hash.Wyhash.hash(1, name));
    for (base_encodings) |encoding| {
        const frame_len = oracle.zstd_encode(encoding, prefix, buffers.base) orelse {
            tally.failures += 1;
            std.debug.print("differential-zstd FAILED: {s}, level {d}: libzstd could not encode a base frame\n", .{ name, encoding.level });
            continue;
        };
        const base: Case = .{ .name = name, .level = encoding.level, .what = "", .input = buffers.base[0..frame_len] };
        judge_valid_as(base, "the base frame", base.input, buffers, &tally);
        corrupt_frame(base, buffers, &generator, &tally);
        corrupt_header(base, buffers, &tally);
    }
    return tally;
}

fn corrupt_frame(base: Case, buffers: Buffers, generator: *codec.split.Generator, tally: *Tally) void {
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

/// Where a frame's header fields lie (RFC 8878 §3.1.1.1).
const Layout = struct {
    /// Frame_Header_Descriptor's offset, and Window_Descriptor's when the frame has one.
    descriptor: usize,
    window: ?usize,
    /// Frame_Content_Size's offset and octets, which a single segment's flag 0 makes 1.
    content_size: usize,
    content_size_len: usize,
    /// The first Block_Header's offset.
    block: usize,
    has_checksum: bool,
};

fn layout_of(frame: []const u8) Layout {
    const at = constants.magic_len;
    const descriptor = frame[at];
    const single = descriptor & constants.descriptor_single_segment != 0;
    const window_len: usize = @intFromBool(!single);
    const dictionary_len = constants.dictionary_id_field_lens[descriptor & constants.descriptor_dictionary_mask];
    const flag = descriptor >> constants.descriptor_content_size_shift;
    const content_size_len: usize = if (flag == 0) @intFromBool(single) else constants.content_size_field_lens[flag];
    const content_size = at + 1 + window_len + dictionary_len;
    return .{
        .descriptor = at,
        .window = if (single) null else at + 1,
        .content_size = content_size,
        .content_size_len = content_size_len,
        .block = content_size + content_size_len,
        .has_checksum = descriptor & constants.descriptor_checksum != 0,
    };
}

/// A copy of the base frame in the corruption buffer, to rewrite one field of.
fn copy(base: Case, buffers: Buffers) []u8 {
    const rewritten = buffers.corrupted[0..base.input.len];
    @memcpy(rewritten, base.input);
    return rewritten;
}

fn corrupt_header(base: Case, buffers: Buffers, tally: *Tally) void {
    const layout = layout_of(base.input);
    var rewritten = copy(base, buffers);
    rewritten[layout.descriptor] |= constants.descriptor_reserved;
    judge_as(base, "the reserved bit set", rewritten, buffers, tally);
    rewritten = copy(base, buffers);
    rewritten[layout.descriptor] |= descriptor_unused;
    judge_valid_as(base, "the unused bit set", rewritten, buffers, tally);
    rewritten = copy(base, buffers);
    rewritten[layout.block] |= block_type_reserved;
    judge_as(base, "a reserved Block_Type", rewritten, buffers, tally);
    if (layout.window) |window| {
        rewritten = copy(base, buffers);
        rewritten[window] = window_http;
        judge_valid_as(base, "a Window_Descriptor of 2^23", rewritten, buffers, tally);
        rewritten[window] = window_past_http;
        judge_as(base, "a Window_Descriptor past 2^23", rewritten, buffers, tally);
    }
    judge_as(base, "a Dictionary_ID", with_dictionary(base, layout, buffers), buffers, tally);
    if (layout.content_size_len > 0) {
        rewritten = copy(base, buffers);
        // The least significant octet first (RFC 8878 §3.1.1.1.4): one more, or one less at 255.
        rewritten[layout.content_size] = if (rewritten[layout.content_size] == std.math.maxInt(u8)) std.math.maxInt(u8) - 1 else rewritten[layout.content_size] + 1;
        judge_as(base, "a Frame_Content_Size one off", rewritten, buffers, tally);
    }
    if (layout.has_checksum) {
        rewritten = copy(base, buffers);
        rewritten[rewritten.len - 1] ^= 1;
        judge_as(base, "a wrong Content_Checksum", rewritten, buffers, tally);
    }
}

/// The base frame with a 1-octet Dictionary_ID inserted before Frame_Content_Size.
fn with_dictionary(base: Case, layout: Layout, buffers: Buffers) []const u8 {
    const valid = base.input;
    const rewritten = buffers.corrupted[0 .. valid.len + added_len_max];
    @memcpy(rewritten[0..layout.content_size], valid[0..layout.content_size]);
    rewritten[layout.descriptor] = valid[layout.descriptor] & ~constants.descriptor_dictionary_mask | dictionary_flag_one_octet;
    rewritten[layout.content_size] = dictionary_id;
    @memcpy(rewritten[layout.content_size + added_len_max ..], valid[layout.content_size..]);
    return rewritten;
}

/// The octets `buffers.corrupted` needs: a base frame and the most any corruption adds.
pub fn corrupted_len(base_len: usize) usize {
    return base_len + @max(append_len_max, added_len_max);
}
