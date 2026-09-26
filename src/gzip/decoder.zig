//! The gzip decoder (RFC 1952): one member, its header with the optional fields FLG names, the
//! DEFLATE stream through `deflate`'s decoder, and CRC32 and ISIZE over every octet that stream
//! wrote.
//!
//! The decoder reports `done` at the end of a member, with the octets after it left in the input;
//! the caller calls `init` and decodes the next member from them (decision 11, RFC 1952 §2.2). It
//! skips FEXTRA, FNAME and FCOMMENT without storing them, with no limit on their length but the
//! input's, and checks the CRC16 when FHCRC is set (decision 15). The CRC-32 runs over each call's
//! output once, while it is still in cache (decision 14, S10).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const checksum = @import("checksum");
const deflate = @import("deflate");
const constants = @import("constants.zig");

/// Every way a member breaks RFC 1952, and every way its DEFLATE stream breaks RFC 1951.
pub const Corrupt = deflate.Corrupt || error{
    InvalidIdentification,
    InvalidMethod,
    ReservedFlagSet,
    HeaderChecksumMismatch,
    ChecksumMismatch,
    SizeMismatch,
};

/// Every valid feature the decoder refuses: none.
pub const Unsupported = deflate.Unsupported;

pub const Error = Corrupt || Unsupported;

/// The class of every error `decode` returns (decision 11).
pub fn refusal(err: Error) codec.Refusal {
    inline for (@typeInfo(Unsupported).error_set orelse &.{}) |unsupported| {
        if (err == @field(anyerror, unsupported.name)) return .unsupported;
    }
    return .corrupt;
}

/// The parts of a member, in the order RFC 1952 §2.3 gives them.
const Phase = enum(u8) { header, extra_len, extra, name, comment, header_crc, stream, trailer, done, refused };

/// The optional parts of the header, each with the FLG bit that says it is present.
const optional_parts = [_]struct { Phase, u8 }{
    .{ .extra_len, constants.flag_extra },
    .{ .name, constants.flag_name },
    .{ .comment, constants.flag_comment },
    .{ .header_crc, constants.flag_header_crc },
};

pub const Decoder = struct {
    /// The decoder of the DEFLATE stream between the header and the trailer.
    stream: deflate.Decoder,
    phase: Phase,
    /// FLG.
    flags: u8,
    /// A fixed-length part of the header, or the trailer, as far as the calls so far have read it.
    field: codec.Field(constants.fixed_header_len),
    /// The octets of the extra field not yet skipped.
    extra_left: u16,
    /// The CRC-32 of the header's octets so far, which the CRC16 checks when FHCRC is set.
    header_crc: u32,
    /// The CRC-32 and the length, modulo 2^32, of every octet written so far, and the path that
    /// computes the CRC-32 (decision 21).
    crc32: u32,
    size: u32,
    crc32_path: checksum.Crc32Path,
};

comptime {
    assert(@sizeOf(Decoder) <= @sizeOf(deflate.Decoder) + constants.decoder_state_extra_len);
}

/// Starts a member. Writes no octet of the window (decision 11).
pub fn init(decoder: *Decoder, features: codec.Features) void {
    deflate.init(&decoder.stream, features);
    decoder.phase = .header;
    decoder.flags = 0;
    decoder.field.init();
    decoder.extra_left = 0;
    decoder.header_crc = constants.crc32_initial;
    decoder.crc32 = constants.crc32_initial;
    decoder.size = 0;
    decoder.crc32_path = checksum.Crc32Path.fastest(checksum.Features.from(features));
}

/// Where a call stands: the octets of its input read and of its output written.
const Cursor = struct { consumed: usize = 0, written: usize = 0 };

/// Decodes as much of `input` into `output` as both allow, up to the end of one member (decision
/// 11).
pub fn decode(decoder: *Decoder, input: []const u8, output: []u8) Error!codec.Progress {
    codec.check_entry(input, output);
    // A call after `done` or after a refusal, without `init`, is a programmer error (decision 11).
    assert(decoder.phase != .done and decoder.phase != .refused);
    var cursor: Cursor = .{};
    const status = run(decoder, input, output, &cursor) catch |err| {
        decoder.phase = .refused;
        return err;
    };
    // Invariant 11: `done` only after CRC32 and ISIZE matched the octets written.
    if (status == .done) assert(held_trailer_int(decoder, 0) == decoder.crc32 and held_trailer_int(decoder, 1) == decoder.size);
    const progress: codec.Progress = .{ .consumed = cursor.consumed, .written = cursor.written, .status = status };
    codec.check_progress(input.len, output.len, progress);
    return progress;
}

/// Decodes every member of a gzip file, one after another (RFC 1952 §2.2), from a decoder `init`
/// started (decision 11). The input ending inside a member is `error.Truncated`, and the output
/// filling first is `error.NoSpaceLeft`. Octets after a member that do not start another fail that
/// member's header check (decision 15).
pub fn decode_all(decoder: *Decoder, input: []const u8, output: []u8) (Error || codec.Incomplete)!codec.Whole {
    var total: codec.Whole = .{ .consumed = 0, .written = 0 };
    // Each member takes at least `member_len_min` octets, so this many calls end the input.
    for (0..input.len / constants.member_len_min + 1) |_| {
        const member = try codec.whole(try decode(decoder, input[total.consumed..], output[total.written..]));
        assert(member.consumed >= constants.member_len_min);
        total.consumed += member.consumed;
        total.written += member.written;
        if (total.consumed == input.len) return total;
        init(decoder, decoder.stream.features);
    }
    unreachable;
}

fn run(decoder: *Decoder, input: []const u8, output: []u8, cursor: *Cursor) Error!codec.Status {
    for (0..constants.phases_per_call_max) |_| {
        const status = switch (decoder.phase) {
            .header => try read_header(decoder, input, cursor),
            .extra_len => read_extra_len(decoder, input, cursor),
            .extra => skip_extra(decoder, input, cursor),
            .name, .comment => skip_terminated(decoder, input, cursor),
            .header_crc => try read_header_crc(decoder, input, cursor),
            .stream => try decode_stream(decoder, input, output, cursor),
            .trailer => try read_trailer(decoder, input, cursor),
            .done, .refused => unreachable,
        };
        if (status) |ended| return ended;
    }
    // Each phase runs at most once a call, and the trailer ends it.
    unreachable;
}

/// The part of the member after `after`: the next optional part FLG names, or the DEFLATE stream.
fn next_phase(flags: u8, after: Phase) Phase {
    for (optional_parts) |part| {
        if (@intFromEnum(part[0]) <= @intFromEnum(after)) continue;
        if (flags & part[1] != 0) return part[0];
    }
    return .stream;
}

fn enter(decoder: *Decoder, phase: Phase) void {
    decoder.field.init();
    decoder.phase = phase;
}

/// Adds header octets to the CRC-32 the CRC16 checks, when FHCRC says there is one.
fn hash_header(decoder: *Decoder, octets: []const u8) void {
    if (decoder.flags & constants.flag_header_crc == 0) return;
    decoder.header_crc = checksum.crc32(decoder.crc32_path, decoder.header_crc, octets);
}

/// Reads the field up to `field_len` octets from the call's input. Returns whether it is whole.
fn read_field(decoder: *Decoder, input: []const u8, cursor: *Cursor, field_len: usize) bool {
    var reader = codec.Reader.init(input[cursor.consumed..]);
    const whole = decoder.field.fill(&reader, field_len);
    cursor.consumed += reader.consumed();
    return whole;
}

fn read_header(decoder: *Decoder, input: []const u8, cursor: *Cursor) Error!?codec.Status {
    if (!read_field(decoder, input, cursor, constants.fixed_header_len)) return .needs_input;
    const header = decoder.field.held()[0..constants.fixed_header_len];
    // RFC 1952 §2.3.1.2: a decompressor must check ID1, ID2 and CM.
    if (header[constants.identification_1_offset] != constants.identification_1) return error.InvalidIdentification;
    // RFC 1952 §2.3.1.2: a decompressor must check ID1, ID2 and CM.
    if (header[constants.identification_2_offset] != constants.identification_2) return error.InvalidIdentification;
    // RFC 1952 §2.3.1: CM 8 is DEFLATE, and 0 - 7 are reserved.
    if (header[constants.method_offset] != constants.method_deflate) return error.InvalidMethod;
    const flags = header[constants.flags_offset];
    // RFC 1952 §2.3.1.2: a decompressor must give an error if any reserved bit is nonzero.
    if (flags & constants.flags_reserved != 0) return error.ReservedFlagSet;
    decoder.flags = flags;
    hash_header(decoder, header);
    enter(decoder, next_phase(flags, .header));
    return null;
}

fn read_extra_len(decoder: *Decoder, input: []const u8, cursor: *Cursor) ?codec.Status {
    if (!read_field(decoder, input, cursor, constants.extra_len_len)) return .needs_input;
    const extra_len = decoder.field.held()[0..constants.extra_len_len];
    hash_header(decoder, extra_len);
    // XLEN, least significant octet first (RFC 1952 §2.1, §2.3).
    decoder.extra_left = std.mem.readInt(u16, extra_len, .little);
    enter(decoder, .extra);
    return null;
}

fn skip_extra(decoder: *Decoder, input: []const u8, cursor: *Cursor) ?codec.Status {
    var reader = codec.Reader.init(input[cursor.consumed..]);
    const skipped = reader.take_partial(decoder.extra_left);
    hash_header(decoder, skipped);
    decoder.extra_left -= @intCast(skipped.len);
    cursor.consumed += reader.consumed();
    if (decoder.extra_left > 0) return .needs_input;
    enter(decoder, next_phase(decoder.flags, .extra));
    return null;
}

/// Skips FNAME or FCOMMENT through its terminating zero.
fn skip_terminated(decoder: *Decoder, input: []const u8, cursor: *Cursor) ?codec.Status {
    var reader = codec.Reader.init(input[cursor.consumed..]);
    defer cursor.consumed += reader.consumed();
    for (0..reader.remaining_len()) |_| {
        const octet = reader.read_octet() catch unreachable;
        hash_header(decoder, &.{octet});
        if (octet == constants.field_terminator) {
            enter(decoder, next_phase(decoder.flags, decoder.phase));
            return null;
        }
    }
    return .needs_input;
}

fn read_header_crc(decoder: *Decoder, input: []const u8, cursor: *Cursor) Error!?codec.Status {
    if (!read_field(decoder, input, cursor, constants.header_crc_len)) return .needs_input;
    // The CRC16, least significant octet first (RFC 1952 §2.1).
    const header_crc = std.mem.readInt(u16, decoder.field.held()[0..constants.header_crc_len], .little);
    // RFC 1952 §2.3.1: the CRC16 is the two least significant octets of the header's CRC-32.
    if (header_crc != @as(u16, @truncate(decoder.header_crc))) return error.HeaderChecksumMismatch;
    enter(decoder, .stream);
    return null;
}

fn decode_stream(decoder: *Decoder, input: []const u8, output: []u8, cursor: *Cursor) Error!?codec.Status {
    const room = output[cursor.written..];
    const progress = try deflate.decode(&decoder.stream, input[cursor.consumed..], room);
    decoder.crc32 = checksum.crc32(decoder.crc32_path, decoder.crc32, room[0..progress.written]);
    decoder.size +%= @truncate(progress.written);
    cursor.consumed += progress.consumed;
    cursor.written += progress.written;
    if (progress.status != .done) return progress.status;
    enter(decoder, .trailer);
    return null;
}

/// Reads CRC32 and ISIZE, and compares each as soon as its octets are in, so a member whose CRC32
/// is wrong is refused before its ISIZE arrives.
fn read_trailer(decoder: *Decoder, input: []const u8, cursor: *Cursor) Error!?codec.Status {
    const whole = read_field(decoder, input, cursor, constants.trailer_len);
    if (decoder.field.held().len >= constants.trailer_crc32_len) {
        // The decoder checks CRC32 and ISIZE, which RFC 1952 §2.3.1.2 lets it skip (decision 15).
        if (held_trailer_int(decoder, 0) != decoder.crc32) return error.ChecksumMismatch;
    }
    if (!whole) return .needs_input;
    // RFC 1952 §2.3.1: ISIZE is the decoded length modulo 2^32, checked as decision 15 rules.
    if (held_trailer_int(decoder, 1) != decoder.size) return error.SizeMismatch;
    decoder.phase = .done;
    return .done;
}

/// CRC32, the trailer's first number, or ISIZE, its second, least significant octet first (RFC
/// 1952 §2.1, §2.3).
fn held_trailer_int(decoder: *const Decoder, index: usize) u32 {
    assert(index * constants.trailer_crc32_len < constants.trailer_len);
    assert(decoder.field.held().len >= (index + 1) * constants.trailer_crc32_len);
    const octets = decoder.field.held()[index * constants.trailer_crc32_len ..][0..constants.trailer_crc32_len];
    return std.mem.readInt(u32, octets, .little);
}

test {
    _ = @import("decoder_test.zig");
}
