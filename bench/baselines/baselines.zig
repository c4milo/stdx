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
