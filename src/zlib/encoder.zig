//! The zlib encoder (RFC 1950): CMF and FLG, the DEFLATE stream of `deflate`'s encoder, and
//! ADLER32 over every octet the stream took, most significant octet first (§2.1, §2.2). CMF names
//! DEFLATE with a window of 32 KiB, FLG the level, and no preset dictionary. The Adler-32 runs over
//! each call's input once (decision 14, S10).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const checksum = @import("checksum");
const deflate = @import("deflate");
const constants = @import("constants.zig");

/// The parts of a stream, in the order RFC 1950 §2.2 gives them.
const Phase = enum(u8) { header, stream, trailer, done };

pub fn Encoder(comptime options: deflate.EncoderOptions) type {
    return struct {
        const Self = @This();

        stream: deflate.Encoder(options),
        phase: Phase,
        /// The octets of the header or the trailer written so far.
        field_written: u8,
        adler32: u32,
        adler32_path: checksum.Adler32Path,

        /// Starts a stream, with the caller's CPU features (decision 21).
        pub fn init(self: *Self, features: codec.Features) void {
            self.stream.init(features);
            self.phase = .header;
            self.field_written = 0;
            self.adler32 = constants.adler32_initial;
            self.adler32_path = checksum.Adler32Path.fastest(checksum.Features.from(features));
        }

        /// Encodes as much of `input` into `output` as both allow (decision 11).
        pub fn encode(self: *Self, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return encode_call(options, self, input, output, flush);
        }

        /// Encodes all of `input` as one stream in one call (decision 11).
        pub fn encode_all(self: *Self, input: []const u8, output: []u8) error{NoSpaceLeft}!usize {
            const progress = self.encode(input, output, .finish);
            return switch (progress.status) {
                .done => progress.written,
                .needs_room => error.NoSpaceLeft,
                .needs_input => unreachable,
            };
        }

        /// The most octets `encode_all` writes for `input_len` octets.
        pub fn encoded_len_max(input_len: usize) usize {
            return constants.header_len + deflate.Encoder(options).encoded_len_max(input_len) + constants.trailer_len;
        }
    };
}

/// CMF and FLG: DEFLATE, a window of 32 KiB, the level, no preset dictionary, and FCHECK (RFC 1950
/// §2.2).
fn header(comptime level: u4) [constants.header_len]u8 {
    const cmf: u8 = constants.method_deflate | constants.window_bits_field_max << constants.window_bits_shift;
    const flags: u8 = constants.level_field(level) << constants.level_shift;
    // RFC 1950 §2.2: FCHECK makes CMF * 256 + FLG a multiple of 31.
    const check = (constants.header_check_divisor - (@as(u16, cmf) << @bitSizeOf(u8) | flags) % constants.header_check_divisor) % constants.header_check_divisor;
    return .{ cmf, flags | @as(u8, @intCast(check)) };
}

fn encode_call(comptime options: deflate.EncoderOptions, self: *Encoder(options), input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
    codec.check_entry(input, output);
    assert(self.phase != .done);
    var writer = codec.Writer.init(output);
    var consumed: usize = 0;
    const status = run(options, self, input, flush, &writer, &consumed);
    const progress: codec.Progress = .{ .consumed = consumed, .written = writer.position, .status = status };
    codec.check_progress(input.len, output.len, progress);
    return progress;
}

fn run(comptime options: deflate.EncoderOptions, self: *Encoder(options), input: []const u8, flush: codec.Flush, writer: *codec.Writer, consumed: *usize) codec.Status {
    for (0..constants.phases_per_call_max) |_| {
        switch (self.phase) {
            .header => {
                const octets = header(options.level);
                if (!write_field(self, writer, &octets)) return .needs_room;
                self.phase = .stream;
            },
            .stream => {
                const progress = self.stream.encode(input, writer.octets[writer.position..], flush);
                self.adler32 = checksum.adler32(self.adler32_path, self.adler32, input[0..progress.consumed]);
                consumed.* = progress.consumed;
                writer.position += progress.written;
                if (progress.status != .done) return progress.status;
                self.phase = .trailer;
            },
            .trailer => {
                var octets: [constants.trailer_len]u8 = undefined;
                // RFC 1950 §2.2: ADLER32, most significant octet first (§2.1).
                std.mem.writeInt(u32, &octets, self.adler32, .big);
                if (!write_field(self, writer, &octets)) return .needs_room;
                self.phase = .done;
                return .done;
            },
            .done => unreachable,
        }
    }
    unreachable;
}

/// Writes what the output takes of a field, from where the calls before stopped. Returns whether
/// all of it is written.
fn write_field(self: anytype, writer: *codec.Writer, octets: []const u8) bool {
    self.field_written += @intCast(writer.write_partial(octets[self.field_written..]));
    if (self.field_written < octets.len) return false;
    self.field_written = 0;
    return true;
}

test {
    _ = @import("encoder_test.zig");
}
