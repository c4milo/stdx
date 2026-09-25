//! The oracles of decision 8, zlib and Wuffs, as Zig calls over `tools/oracle/oracle.c`, and the
//! sample code of RFC 1952 §8 and RFC 1950 §9, over `tools/oracle/rfc_samples.c`.
//!
//! Each decode and encode takes a whole input and a whole output and returns what the oracle did: a
//! verdict, the octets it consumed and the octets it wrote. Each checksum returns its value. The C file calls each oracle through its public API
//! alone, and nobody working on stdx reads either oracle's implementation (decision 9).
//!
//! This module is tooling. `build/oracle.zig` builds it for `tools/` and `bench/`, and no library
//! module can import it (invariant 14, `zig build graph-check`).

const std = @import("std");

/// The three containers of the DEFLATE family.
pub const Container = enum(c_int) { raw = 0, zlib = 1, gzip = 2 };

/// What an oracle did with an input. The values match `tools/oracle/oracle.c`.
pub const Verdict = enum(c_int) {
    /// The stream ended and every check passed.
    ok = 0,
    /// The oracle refused the input.
    refused = 1,
    /// The input ended before the stream did.
    incomplete = 2,
    /// The output filled before the stream ended.
    no_room = 3,
    /// The oracle could not run: an allocation or an argument failed.
    failed = 4,
};

/// One oracle call's result.
pub const Result = extern struct {
    verdict: Verdict,
    consumed: usize,
    written: usize,
};

/// zlib's strategies, as zlib.h numbers them.
pub const Strategy = enum(c_int) { default = 0, filtered = 1, huffman_only = 2, rle = 3, fixed = 4 };

/// zlib's levels: 0, stored, to 9.
pub const level_max: c_int = 9;

/// The largest window zlib's encoder takes: 2^15 octets, the DEFLATE window (RFC 1951 §3.2.5).
pub const window_bits_max: c_int = 15;

/// zlib's default memLevel.
pub const mem_level_default: c_int = 8;

extern fn oracle_zlib_bound(container: Container, input_len: usize) usize;
extern fn oracle_zlib_encode(
    container: Container,
    level: c_int,
    strategy: Strategy,
    window_bits: c_int,
    mem_level: c_int,
    input: [*]const u8,
    input_len: usize,
    output: [*]u8,
    output_len: usize,
) Result;
extern fn oracle_zlib_decode(container: Container, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) Result;
extern fn oracle_wuffs_decode(container: Container, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) Result;
extern fn oracle_zlib_crc32(crc: u32, input: [*]const u8, input_len: usize) u32;
extern fn oracle_zlib_adler32(adler: u32, input: [*]const u8, input_len: usize) u32;
extern fn oracle_wuffs_crc32(input: [*]const u8, input_len: usize) u32;
extern fn oracle_wuffs_adler32(input: [*]const u8, input_len: usize) u32;
extern fn oracle_rfc1952_update_crc(crc: u32, input: [*]const u8, input_len: usize) u32;
extern fn oracle_rfc1950_update_adler32(adler: u32, input: [*]const u8, input_len: usize) u32;

/// The most octets zlib writes when it encodes `input_len` octets in `container`, at any level and
/// strategy.
pub fn zlib_bound(container: Container, input_len: usize) usize {
    return oracle_zlib_bound(container, input_len);
}

/// The settings of one zlib encode.
pub const Encoding = struct {
    container: Container,
    level: c_int,
    strategy: Strategy,
    window_bits: c_int = window_bits_max,
    mem_level: c_int = mem_level_default,
};

pub fn zlib_encode(encoding: Encoding, input: []const u8, output: []u8) Result {
    return oracle_zlib_encode(
        encoding.container,
        encoding.level,
        encoding.strategy,
        encoding.window_bits,
        encoding.mem_level,
        input.ptr,
        input.len,
        output.ptr,
        output.len,
    );
}

pub fn zlib_decode(container: Container, input: []const u8, output: []u8) Result {
    return oracle_zlib_decode(container, input.ptr, input.len, output.ptr, output.len);
}

pub fn wuffs_decode(container: Container, input: []const u8, output: []u8) Result {
    return oracle_wuffs_decode(container, input.ptr, input.len, output.ptr, output.len);
}

/// zlib's crc32_z: the CRC-32 after `input`, from `crc`.
pub fn zlib_crc32(crc: u32, input: []const u8) u32 {
    return oracle_zlib_crc32(crc, input.ptr, input.len);
}

/// zlib's adler32_z: the Adler-32 after `input`, from `adler`.
pub fn zlib_adler32(adler: u32, input: []const u8) u32 {
    return oracle_zlib_adler32(adler, input.ptr, input.len);
}

/// Wuffs's CRC-32 hasher: the CRC-32 of `input`, from the start.
pub fn wuffs_crc32(input: []const u8) u32 {
    return oracle_wuffs_crc32(input.ptr, input.len);
}

/// Wuffs's Adler-32 hasher: the Adler-32 of `input`, from the start.
pub fn wuffs_adler32(input: []const u8) u32 {
    return oracle_wuffs_adler32(input.ptr, input.len);
}

/// RFC 1952 §8's update_crc, the RFC's own code: the CRC-32 after `input`, from `crc`.
pub fn rfc1952_update_crc(crc: u32, input: []const u8) u32 {
    return oracle_rfc1952_update_crc(crc, input.ptr, input.len);
}

/// RFC 1950 §9's update_adler32, the RFC's own code: the Adler-32 after `input`, from `adler`.
pub fn rfc1950_update_adler32(adler: u32, input: []const u8) u32 {
    return oracle_rfc1950_update_adler32(adler, input.ptr, input.len);
}

// Tests. They check the bindings, not the oracles: that each container reaches the oracle as the
// container it names, and that each verdict comes back as the verdict it is.

const testing = std.testing;

const sample = "a line of text, a line of text, a line of text, and one more line of text.\n";

fn encode_sample(container: Container, output: []u8) !usize {
    const result = zlib_encode(.{ .container = container, .level = 6, .strategy = .default }, sample, output);
    try testing.expectEqual(Verdict.ok, result.verdict);
    try testing.expectEqual(sample.len, result.consumed);
    return result.written;
}

test "each container reaches zlib as the container it names" {
    var encoded: [256]u8 = undefined;
    // RFC 1952 §2.3.1: a gzip member starts with ID1 31 and ID2 139.
    const gzip_len = try encode_sample(.gzip, &encoded);
    try testing.expectEqualSlices(u8, &.{ 0x1f, 0x8b }, encoded[0..2]);
    try testing.expect(gzip_len > sample.len / 4);
    // RFC 1950 §2.2: CM 8 in the low bits of CMF, and CMF * 256 + FLG a multiple of 31.
    _ = try encode_sample(.zlib, &encoded);
    try testing.expectEqual(8, encoded[0] & 0x0f);
    try testing.expectEqual(0, (@as(u16, encoded[0]) * 256 + encoded[1]) % 31);
    // Raw DEFLATE has no header: its first three bits are a block header whose type is not 11
    // (RFC 1951 §3.2.3).
    _ = try encode_sample(.raw, &encoded);
    try testing.expect((encoded[0] >> 1) & 3 != 3);
}

test "both oracles decode each container back to its input" {
    inline for (.{ Container.raw, Container.zlib, Container.gzip }) |container| {
        var encoded: [256]u8 = undefined;
        const encoded_len = try encode_sample(container, &encoded);
        var decoded: [256]u8 = undefined;
        for ([_]*const fn (Container, []const u8, []u8) Result{ zlib_decode, wuffs_decode }) |decode| {
            const result = decode(container, encoded[0..encoded_len], &decoded);
            try testing.expectEqual(Verdict.ok, result.verdict);
            try testing.expectEqual(encoded_len, result.consumed);
            try testing.expectEqualStrings(sample, decoded[0..result.written]);
        }
    }
}

test "both oracles report a cut input, a full output and a wrong checksum" {
    var encoded: [256]u8 = undefined;
    const encoded_len = try encode_sample(.gzip, &encoded);
    var decoded: [256]u8 = undefined;
    for ([_]*const fn (Container, []const u8, []u8) Result{ zlib_decode, wuffs_decode }) |decode| {
        const cut = decode(.gzip, encoded[0 .. encoded_len - 1], &decoded);
        try testing.expect(cut.verdict == .incomplete or cut.verdict == .refused);
        try testing.expect(cut.verdict != .ok);
        try testing.expectEqual(Verdict.no_room, decode(.gzip, encoded[0..encoded_len], decoded[0..8]).verdict);
        // RFC 1952 §2.3.1: CRC32 is the first of the eight trailer octets.
        var corrupt = encoded;
        corrupt[encoded_len - 8] ^= 1;
        try testing.expectEqual(Verdict.refused, decode(.gzip, corrupt[0..encoded_len], &decoded).verdict);
    }
}

test "every checksum binding gives the check values" {
    const check = "123456789";
    // The CRC-32 check value of RFC 1952's polynomial, and Adler-32 of "Wikipedia".
    try testing.expectEqual(0xcbf43926, zlib_crc32(0, check));
    try testing.expectEqual(0xcbf43926, wuffs_crc32(check));
    try testing.expectEqual(0xcbf43926, rfc1952_update_crc(0, check));
    try testing.expectEqual(0x11e60398, zlib_adler32(1, "Wikipedia"));
    try testing.expectEqual(0x11e60398, wuffs_adler32("Wikipedia"));
    try testing.expectEqual(0x11e60398, rfc1950_update_adler32(1, "Wikipedia"));
    // A running value carries across calls.
    try testing.expectEqual(0xcbf43926, rfc1952_update_crc(rfc1952_update_crc(0, check[0..4]), check[4..]));
    try testing.expectEqual(0xcbf43926, zlib_crc32(zlib_crc32(0, check[0..4]), check[4..]));
}

test "the bound covers the largest stored encoding" {
    var input: [4096]u8 = undefined;
    for (&input, 0..) |*octet, index| octet.* = @truncate(index *% 2654435761 >> 13);
    const bound = zlib_bound(.gzip, input.len);
    var encoded: [8192]u8 = undefined;
    try testing.expect(bound <= encoded.len);
    const result = zlib_encode(.{ .container = .gzip, .level = 0, .strategy = .default }, &input, encoded[0..bound]);
    try testing.expectEqual(Verdict.ok, result.verdict);
    try testing.expect(result.written > input.len);
}
