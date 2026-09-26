//! The gzip encoder (RFC 1952): one member, its fixed header, the DEFLATE stream of `deflate`'s
//! encoder, and CRC32 and ISIZE over every octet the stream took, least significant octet first
//! (§2.1, §2.3). The header holds no optional field, no time and no host (invariant 5). The CRC-32
//! runs over each call's input once (decision 14, S10).

const std = @import("std");
const assert = std.debug.assert;
const codec = @import("codec");
const checksum = @import("checksum");
const deflate = @import("deflate");
const constants = @import("constants.zig");

/// The parts of a member, in the order RFC 1952 §2.3 gives them.
const Phase = enum(u8) { header, stream, trailer, done };

/// The phases one call passes through: the header, the stream and the trailer.
const phases_max = 3;

pub fn Encoder(comptime options: deflate.EncoderOptions) type {
    return struct {
        const Self = @This();

        stream: deflate.Encoder(options),
        phase: Phase,
        /// The octets of the header or the trailer written so far.
        field_written: u8,
        crc32: u32,
        crc32_path: checksum.Crc32Path,
        /// ISIZE: the input's length modulo 2^32 (RFC 1952 §2.3.1).
        size: u32,

        /// Starts a member, with the caller's CPU features (decision 21).
        pub fn init(self: *Self, features: codec.Features) void {
            self.stream.init(features);
            self.phase = .header;
            self.field_written = 0;
            self.crc32 = constants.crc32_initial;
            self.crc32_path = checksum.Crc32Path.fastest(checksum.Features.from(features));
            self.size = 0;
        }

        /// Encodes as much of `input` into `output` as both allow (decision 11).
        pub fn encode(self: *Self, input: []const u8, output: []u8, flush: codec.Flush) codec.Progress {
            return encode_call(options, self, input, output, flush);
        }

        /// Encodes all of `input` as one member in one call (decision 11).
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
            return constants.fixed_header_len + deflate.Encoder(options).encoded_len_max(input_len) + constants.trailer_len;
        }
    };
}

/// ID1, ID2, CM, FLG, MTIME, XFL and OS (RFC 1952 §2.3), MTIME least significant octet first.
fn header(comptime level: u4) [constants.fixed_header_len]u8 {
    var octets: [constants.fixed_header_len]u8 = undefined;
    octets[constants.identification_1_offset] = constants.identification_1;
    octets[constants.identification_2_offset] = constants.identification_2;
    octets[constants.method_offset] = constants.method_deflate;
    octets[constants.flags_offset] = constants.encoder_flags;
    std.mem.writeInt(u32, octets[constants.modification_time_offset..][0..@sizeOf(u32)], constants.encoder_modification_time, .little);
    octets[constants.extra_flags_offset] = constants.extra_flags(level);
    octets[constants.operating_system_offset] = constants.encoder_operating_system;
    return octets;
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
    for (0..phases_max) |_| {
        switch (self.phase) {
            .header => {
                const octets = header(options.level);
                if (!write_field(self, writer, &octets)) return .needs_room;
                self.phase = .stream;
            },
            .stream => {
                const progress = self.stream.encode(input, writer.octets[writer.position..], flush);
                self.crc32 = checksum.crc32(self.crc32_path, self.crc32, input[0..progress.consumed]);
                self.size +%= @truncate(progress.consumed);
                consumed.* = progress.consumed;
                writer.position += progress.written;
                if (progress.status != .done) return progress.status;
                self.phase = .trailer;
            },
            .trailer => {
                var octets: [constants.trailer_len]u8 = undefined;
                // RFC 1952 §2.3.1: CRC32, then ISIZE, least significant octet first (§2.1).
                std.mem.writeInt(u32, octets[0..constants.trailer_crc32_len], self.crc32, .little);
                std.mem.writeInt(u32, octets[constants.trailer_crc32_len..], self.size, .little);
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
