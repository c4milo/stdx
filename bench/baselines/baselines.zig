//! The baselines of decision 8 that are not also oracles, libdeflate and zlib-ng, as Zig calls
//! over `bench/baselines/baselines.c`. Each call runs the library's own run-time CPU dispatch.
//!
//! This module is benchmark code. `build/baselines.zig` builds it for `bench/`, and no library
//! module can import it (invariant 14).

const std = @import("std");

extern fn baseline_libdeflate_crc32(crc: u32, input: [*]const u8, input_len: usize) u32;
extern fn baseline_libdeflate_adler32(adler: u32, input: [*]const u8, input_len: usize) u32;
extern fn baseline_zlib_ng_crc32(crc: u32, input: [*]const u8, input_len: usize) u32;
extern fn baseline_zlib_ng_adler32(adler: u32, input: [*]const u8, input_len: usize) u32;
extern fn baseline_libdeflate_gzip_decode(input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) usize;
extern fn baseline_zlib_ng_gzip_decode(input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) usize;

/// libdeflate_crc32: the CRC-32 after `input`, from `crc`.
pub fn libdeflate_crc32(crc: u32, input: []const u8) u32 {
    return baseline_libdeflate_crc32(crc, input.ptr, input.len);
}

/// libdeflate_adler32: the Adler-32 after `input`, from `adler`.
pub fn libdeflate_adler32(adler: u32, input: []const u8) u32 {
    return baseline_libdeflate_adler32(adler, input.ptr, input.len);
}

/// zng_crc32_z: the CRC-32 after `input`, from `crc`.
pub fn zlib_ng_crc32(crc: u32, input: []const u8) u32 {
    return baseline_zlib_ng_crc32(crc, input.ptr, input.len);
}

/// zng_adler32_z: the Adler-32 after `input`, from `adler`.
pub fn zlib_ng_adler32(adler: u32, input: []const u8) u32 {
    return baseline_zlib_ng_adler32(adler, input.ptr, input.len);
}

/// libdeflate_gzip_decompress: decodes one whole gzip member into `output`. Returns the octets
/// written, or null when libdeflate refused the input.
pub fn libdeflate_gzip_decode(input: []const u8, output: []u8) ?usize {
    const written = baseline_libdeflate_gzip_decode(input.ptr, input.len, output.ptr, output.len);
    return if (written == std.math.maxInt(usize)) null else written;
}

/// zng_inflate with the gzip container: decodes one whole gzip member into `output`. Returns the
/// octets written, or null when zlib-ng refused the input or did not reach its end.
pub fn zlib_ng_gzip_decode(input: []const u8, output: []u8) ?usize {
    const written = baseline_zlib_ng_gzip_decode(input.ptr, input.len, output.ptr, output.len);
    return if (written == std.math.maxInt(usize)) null else written;
}

// Tests. They check the bindings, not the baselines.

const testing = std.testing;

test "every binding gives the check values" {
    // The CRC-32 check value of RFC 1952's polynomial, and Adler-32 of "Wikipedia".
    try testing.expectEqual(0xcbf43926, libdeflate_crc32(0, "123456789"));
    try testing.expectEqual(0xcbf43926, zlib_ng_crc32(0, "123456789"));
    try testing.expectEqual(0x11e60398, libdeflate_adler32(1, "Wikipedia"));
    try testing.expectEqual(0x11e60398, zlib_ng_adler32(1, "Wikipedia"));
}

test "every binding carries a running value across calls, over enough octets for SIMD" {
    var input: [4096]u8 = undefined;
    for (&input, 0..) |*octet, index| octet.* = @truncate(index *% 2654435761 >> 13);
    const crc = libdeflate_crc32(0, &input);
    try testing.expectEqual(crc, zlib_ng_crc32(0, &input));
    try testing.expectEqual(crc, zlib_ng_crc32(libdeflate_crc32(0, input[0..1000]), input[1000..]));
    const adler = libdeflate_adler32(1, &input);
    try testing.expectEqual(adler, zlib_ng_adler32(1, &input));
    try testing.expectEqual(adler, libdeflate_adler32(zlib_ng_adler32(1, input[0..1000]), input[1000..]));
}

test "both gzip decoders decode a stored member, and refuse it with a wrong CRC32" {
    // A gzip member of one stored block (RFC 1952 §2.3, RFC 1951 §3.2.4): the fixed header, the
    // block, then CRC32 and ISIZE, least significant octet first.
    const text = "a stored member";
    var member: [10 + 5 + text.len + 8]u8 = undefined;
    @memcpy(member[0..10], &[_]u8{ 0x1f, 0x8b, 8, 0, 0, 0, 0, 0, 0, 0xff });
    @memcpy(member[10..15], &[_]u8{ 1, text.len, 0, ~@as(u8, text.len), 0xff });
    @memcpy(member[15..][0..text.len], text);
    std.mem.writeInt(u32, member[15 + text.len ..][0..4], libdeflate_crc32(0, text), .little);
    std.mem.writeInt(u32, member[19 + text.len ..][0..4], text.len, .little);
    var output: [64]u8 = undefined;
    for ([_]*const fn ([]const u8, []u8) ?usize{ libdeflate_gzip_decode, zlib_ng_gzip_decode }) |decode| {
        const written = decode(&member, &output) orelse return error.TestUnexpectedResult;
        try testing.expectEqualStrings(text, output[0..written]);
        var corrupt = member;
        corrupt[15 + text.len] ^= 1;
        try testing.expectEqual(null, decode(&corrupt, &output));
    }
}
