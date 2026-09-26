//! The corruptions of decision 15 that belong to the containers. Each rewrites a valid stream zlib
//! encoded, whose header names no optional field, into one that holds a field at the value under
//! test:
//!
//! - zlib (RFC 1950 §2.2): FCHECK wrong, every CM but 8, every CINFO, every FLEVEL, and FDICT with
//!   a DICTID. A CINFO below the window zlib's encoder used is decision 12's case: a distance past
//!   the declared window.
//! - gzip (RFC 1952 §2.3): ID1 and ID2 wrong, CM at values other than 8, each reserved FLG bit,
//!   FTEXT, every combination of FEXTRA, FNAME, FCOMMENT and FHCRC, a CRC16 that does not match,
//!   and a second member after the first.

const std = @import("std");
const oracle = @import("oracle");
const differential = @import("deflate.zig");
const deflate_corrupt = @import("deflate_corrupt.zig");
const Case = deflate_corrupt.Case;

/// The octets of the headers zlib writes: zlib's CMF and FLG, and gzip's fixed ten, with no
/// optional field (RFC 1950 §2.2, RFC 1952 §2.3).
const zlib_header_len = 2;
const gzip_header_len = 10;

/// Where the DEFLATE stream starts in a stream zlib encoded.
pub fn deflate_start(container: oracle.Container) usize {
    return switch (container) {
        .raw => 0,
        .zlib => zlib_header_len,
        .gzip => gzip_header_len,
    };
}

/// The most octets a rewrite adds to a stream, and the most a stream takes.
const added_len_max = 64;
const stream_len_max = 2 * deflate_corrupt.base_input_len_max + added_len_max;

/// A rewritten stream.
const Rewrite = struct {
    octets: [stream_len_max]u8 = undefined,
    len: usize = 0,

    fn append(self: *Rewrite, octets: []const u8) void {
        @memcpy(self.octets[self.len..][0..octets.len], octets);
        self.len += octets.len;
    }

    fn slice(self: *const Rewrite) []const u8 {
        return self.octets[0..self.len];
    }
};

pub fn corrupt(stream: Case, buffers: differential.Buffers, tally: *deflate_corrupt.Tally) void {
    switch (stream.container) {
        .raw => {},
        .zlib => corrupt_zlib(stream, buffers, tally),
        .gzip => corrupt_gzip(stream, buffers, tally),
    }
}

// zlib (RFC 1950 §2.2).

const method_mask: u8 = 0x0f;
const method_deflate = 8;
const window_bits_shift = 4;
const window_bits_field_max = 7;
const check_mask: u8 = 0x1f;
const check_divisor = 31;
const dictionary_flag: u8 = 1 << 5;
const level_shift = 6;

/// FLG with the FCHECK that makes CMF * 256 + FLG a multiple of 31.
fn checked_flags(cmf: u8, flags: u8) u8 {
    const unchecked = flags & ~check_mask;
    const value = @as(u16, cmf) * 256 + unchecked;
    return unchecked | @as(u8, @intCast((check_divisor - value % check_divisor) % check_divisor));
}

/// The stream with CMF and FLG replaced, and `inserted` after them.
fn zlib_rewrite(stream: Case, cmf: u8, flags: u8, inserted: []const u8) Rewrite {
    var rewrite: Rewrite = .{};
    rewrite.append(&.{ cmf, flags });
    rewrite.append(inserted);
    rewrite.append(stream.input[zlib_header_len..]);
    return rewrite;
}

fn corrupt_zlib(stream: Case, buffers: differential.Buffers, tally: *deflate_corrupt.Tally) void {
    const cmf = stream.input[0];
    const flags = stream.input[1];
    var wrong_check = zlib_rewrite(stream, cmf, flags ^ 1, "");
    deflate_corrupt.judge_as(stream, "FCHECK wrong", wrong_check.slice(), buffers, tally);
    for (0..method_mask + 1) |method| {
        const method_cmf = (cmf & ~method_mask) | @as(u8, @intCast(method));
        var rewrite = zlib_rewrite(stream, method_cmf, checked_flags(method_cmf, flags), "");
        const judge = if (method == method_deflate) &deflate_corrupt.judge_valid_as else &deflate_corrupt.judge_as;
        judge(stream, "CM set", rewrite.slice(), buffers, tally);
    }
    for (0..(0xff >> window_bits_shift) + 1) |window_bits_field| {
        const window_cmf = (cmf & method_mask) | @as(u8, @intCast(window_bits_field << window_bits_shift));
        var rewrite = zlib_rewrite(stream, window_cmf, checked_flags(window_cmf, flags), "");
        const judge = if (window_bits_field == window_bits_field_max) &deflate_corrupt.judge_valid_as else &deflate_corrupt.judge_as;
        judge(stream, "CINFO set", rewrite.slice(), buffers, tally);
    }
    for (0..4) |level| {
        const level_flags = (flags & ~(@as(u8, 0b11) << level_shift)) | @as(u8, @intCast(level << level_shift));
        var rewrite = zlib_rewrite(stream, cmf, checked_flags(cmf, level_flags), "");
        deflate_corrupt.judge_valid_as(stream, "FLEVEL set", rewrite.slice(), buffers, tally);
    }
    // DICTID, the Adler-32 of an empty dictionary, most significant octet first.
    var dictionary = zlib_rewrite(stream, cmf, checked_flags(cmf, flags | dictionary_flag), &.{ 0, 0, 0, 1 });
    deflate_corrupt.judge_as(stream, "FDICT set", dictionary.slice(), buffers, tally);
}

// gzip (RFC 1952 §2.3).

const identification_1_offset = 0;
const identification_2_offset = 1;
const method_offset = 2;
const flags_offset = 3;
const flag_text: u8 = 1 << 0;
const flag_header_crc: u8 = 1 << 1;
const flag_extra: u8 = 1 << 2;
const flag_name: u8 = 1 << 3;
const flag_comment: u8 = 1 << 4;
const reserved_bits = [_]u3{ 5, 6, 7 };

/// The optional fields a rewrite adds: an extra field of one subfield, a name and a comment.
const extra_field = "XLEN" ++ "Sx\x03\x00abc";
const name = "name.txt\x00";
const comment = "a comment\x00";

/// The stream with FLG replaced and the optional fields it names added, the CRC16 of the header
/// included when FHCRC is set, flipped when `wrong_crc` says so.
fn gzip_rewrite(stream: Case, flags: u8, wrong_crc: bool) Rewrite {
    var rewrite: Rewrite = .{};
    rewrite.append(stream.input[0..gzip_header_len]);
    rewrite.octets[flags_offset] = flags;
    if (flags & flag_extra != 0) {
        const subfields = extra_field["XLEN".len..];
        var extra_len: [2]u8 = undefined;
        std.mem.writeInt(u16, &extra_len, subfields.len, .little);
        rewrite.append(&extra_len);
        rewrite.append(subfields);
    }
    if (flags & flag_name != 0) rewrite.append(name);
    if (flags & flag_comment != 0) rewrite.append(comment);
    if (flags & flag_header_crc != 0) {
        const crc: u16 = @truncate(oracle.zlib_crc32(0, rewrite.slice()));
        var header_crc: [2]u8 = undefined;
        std.mem.writeInt(u16, &header_crc, if (wrong_crc) crc ^ 1 else crc, .little);
        rewrite.append(&header_crc);
    }
    rewrite.append(stream.input[gzip_header_len..]);
    return rewrite;
}

fn corrupt_gzip(stream: Case, buffers: differential.Buffers, tally: *deflate_corrupt.Tally) void {
    var rewrite: Rewrite = .{};
    for ([_]usize{ identification_1_offset, identification_2_offset }) |offset| {
        rewrite = .{};
        rewrite.append(stream.input);
        rewrite.octets[offset] ^= 1;
        deflate_corrupt.judge_as(stream, "ID1 or ID2 wrong", rewrite.slice(), buffers, tally);
    }
    for ([_]u8{ 0, 7, 9, 15, 0xff }) |method| {
        rewrite = .{};
        rewrite.append(stream.input);
        rewrite.octets[method_offset] = method;
        deflate_corrupt.judge_as(stream, "CM set", rewrite.slice(), buffers, tally);
    }
    for (reserved_bits) |bit| {
        rewrite = gzip_rewrite(stream, @as(u8, 1) << bit, false);
        deflate_corrupt.judge_as(stream, "a reserved FLG bit set", rewrite.slice(), buffers, tally);
    }
    for (0..16) |combination| {
        const flags = flag_text | @as(u8, @intCast(combination << 1));
        rewrite = gzip_rewrite(stream, flags, false);
        deflate_corrupt.judge_valid_as(stream, "optional fields", rewrite.slice(), buffers, tally);
        if (flags & flag_header_crc == 0) continue;
        rewrite = gzip_rewrite(stream, flags, true);
        deflate_corrupt.judge_as(stream, "a CRC16 that does not match", rewrite.slice(), buffers, tally);
    }
    rewrite = .{};
    rewrite.append(stream.input);
    rewrite.append(stream.input);
    deflate_corrupt.judge_valid_as(stream, "a second member", rewrite.slice(), buffers, tally);
}
