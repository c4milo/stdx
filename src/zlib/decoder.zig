//! The zlib decoder (RFC 1950): the two-octet header, the DEFLATE stream through `deflate`'s
//! decoder, and ADLER32 over every octet that stream wrote.
//!
//! The header and the trailer are read through `codec.Field`, so the caller may split them
//! anywhere. The DEFLATE decoder reads the stream from the call's input directly and hands back the
//! octets it read past the stream's end (decision 11), so the trailer starts where it stopped. The
//! Adler-32 runs over each call's output once, while it is still in cache (decision 14, S10).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const checksum = @import("checksum");
const deflate = @import("deflate");
const constants = @import("constants.zig");

/// Every way a stream breaks RFC 1950, and every way its DEFLATE stream breaks RFC 1951.
pub const Corrupt = deflate.Corrupt || error{
    InvalidHeaderCheck,
    InvalidMethod,
    InvalidWindowSize,
    ChecksumMismatch,
};

/// Every valid feature the decoder refuses: a preset dictionary, which RFC 1950 §2.3 lets a
/// format that names none refuse (decision 13).
pub const Unsupported = deflate.Unsupported || error{PresetDictionary};

pub const Error = Corrupt || Unsupported;

/// The class of every error `decode` returns (decision 11).
pub fn refusal(err: Error) codec.Refusal {
    inline for (@typeInfo(Unsupported).error_set orelse &.{}) |unsupported| {
        if (err == @field(anyerror, unsupported.name)) return .unsupported;
    }
    return .corrupt;
}

const Phase = enum(u8) { header, stream, trailer, done, refused };

pub const Decoder = struct {
    /// The decoder of the DEFLATE stream between the header and the trailer.
    stream: deflate.Decoder,
    phase: Phase,
    /// The header, then the trailer, as far as the calls so far have read it.
    field: codec.Field(constants.trailer_len),
    /// The Adler-32 of every octet written so far, and the path that computes it (decision 21).
    adler32: u32,
    adler32_path: checksum.Adler32Path,
};

comptime {
    assert(@sizeOf(Decoder) <= @sizeOf(deflate.Decoder) + constants.decoder_state_extra_len);
}

/// Starts a stream. Writes no octet of the window (decision 11).
pub fn init(decoder: *Decoder, features: codec.Features) void {
    deflate.init(&decoder.stream, features);
    decoder.phase = .header;
    decoder.field.init();
    decoder.adler32 = constants.adler32_initial;
    decoder.adler32_path = checksum.Adler32Path.fastest(checksum.Features.from(features));
}

/// Where a call stands: the octets of its input read and of its output written.
const Cursor = struct { consumed: usize = 0, written: usize = 0 };

/// Decodes as much of `input` into `output` as both allow (decision 11).
pub fn decode(decoder: *Decoder, input: []const u8, output: []u8) Error!codec.Progress {
    codec.check_entry(input, output);
    // A call after `done` or after a refusal, without `init`, is a programmer error (decision 11).
    assert(decoder.phase != .done and decoder.phase != .refused);
    var cursor: Cursor = .{};
    const status = run(decoder, input, output, &cursor) catch |err| {
        decoder.phase = .refused;
        return err;
    };
    // Invariant 11: `done` only after ADLER32 matched the octets written.
    if (status == .done) assert(held_adler32(decoder) == decoder.adler32);
    const progress: codec.Progress = .{ .consumed = cursor.consumed, .written = cursor.written, .status = status };
    codec.check_progress(input.len, output.len, progress);
    return progress;
}

/// Decodes a whole stream in one call (decision 11). The input ending before the stream does is
/// `error.Truncated`, and the output filling first is `error.NoSpaceLeft`. Octets after the stream
/// stay the caller's: `consumed` says where it ended.
pub fn decode_all(decoder: *Decoder, input: []const u8, output: []u8) (Error || codec.Incomplete)!codec.Whole {
    return codec.whole(try decode(decoder, input, output));
}

fn run(decoder: *Decoder, input: []const u8, output: []u8, cursor: *Cursor) Error!codec.Status {
    for (0..constants.phases_per_call_max) |_| {
        const status = switch (decoder.phase) {
            .header => try read_header(decoder, input, cursor),
            .stream => try decode_stream(decoder, input, output, cursor),
            .trailer => try read_trailer(decoder, input, cursor),
            .done, .refused => unreachable,
        };
        if (status) |ended| return ended;
    }
    // The trailer ends the call with `done` or `needs_input`, so no call passes it.
    unreachable;
}

/// Reads the field up to `field_len` octets from the call's input. Returns whether it is whole.
fn read_field(decoder: *Decoder, input: []const u8, cursor: *Cursor, field_len: usize) bool {
    var reader = codec.Reader.init(input[cursor.consumed..]);
    const whole = decoder.field.fill(&reader, field_len);
    cursor.consumed += reader.consumed();
    return whole;
}

fn read_header(decoder: *Decoder, input: []const u8, cursor: *Cursor) Error!?codec.Status {
    if (!read_field(decoder, input, cursor, constants.header_len)) return .needs_input;
    const header = decoder.field.held()[0..constants.header_len];
    const method_and_info = header[0];
    const flags = header[1];
    // RFC 1950 §2.3: a decompressor must check CMF and FLG; §2.2: CMF * 256 + FLG, most
    // significant octet first, is a multiple of 31.
    if (std.mem.readInt(u16, header, .big) % constants.header_check_divisor != 0) return error.InvalidHeaderCheck;
    // RFC 1950 §2.3: a decompressor must give an error if CM is not 8.
    if (method_and_info & constants.method_mask != constants.method_deflate) return error.InvalidMethod;
    const window_bits_field = method_and_info >> constants.window_bits_shift;
    // RFC 1950 §2.2: values of CINFO above 7 are not allowed.
    if (window_bits_field > constants.window_bits_field_max) return error.InvalidWindowSize;
    // RFC 1950 §2.3: a decompressor must reject FDICT when the format around it uses no preset
    // dictionary.
    if (flags & constants.preset_dictionary_flag != 0) return error.PresetDictionary;
    deflate.limit_window(&decoder.stream, @as(usize, 1) << @intCast(window_bits_field + constants.window_bits_offset));
    decoder.field.init();
    decoder.phase = .stream;
    return null;
}

fn decode_stream(decoder: *Decoder, input: []const u8, output: []u8, cursor: *Cursor) Error!?codec.Status {
    const room = output[cursor.written..];
    const progress = try deflate.decode(&decoder.stream, input[cursor.consumed..], room);
    decoder.adler32 = checksum.adler32(decoder.adler32_path, decoder.adler32, room[0..progress.written]);
    cursor.consumed += progress.consumed;
    cursor.written += progress.written;
    if (progress.status != .done) return progress.status;
    decoder.phase = .trailer;
    return null;
}

fn read_trailer(decoder: *Decoder, input: []const u8, cursor: *Cursor) Error!?codec.Status {
    if (!read_field(decoder, input, cursor, constants.trailer_len)) return .needs_input;
    // RFC 1950 §2.3: a decompressor must check ADLER32.
    if (held_adler32(decoder) != decoder.adler32) return error.ChecksumMismatch;
    decoder.phase = .done;
    return .done;
}

/// ADLER32 as the trailer holds it, most significant octet first (RFC 1950 §2.2).
fn held_adler32(decoder: *const Decoder) u32 {
    assert(decoder.field.held().len == constants.trailer_len);
    return std.mem.readInt(u32, decoder.field.held()[0..constants.trailer_len], .big);
}

test {
    _ = @import("decoder_test.zig");
}
