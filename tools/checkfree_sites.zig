//! The safety check sites each SIMD kernel of decision 21 reaches in a ReleaseSafe build, as
//! pepegrillo's `checkfree` engine counts them (decision 51). A change that moves a count changes
//! this table in the same commit, and its body says why. `zig build checkfree-check -- --record`
//! prints the table the build gives.

const pepegrillo = @import("pepegrillo");

pub const pins = [_]pepegrillo.checkfree.Pin{
    // x86-64.
    .{ .symbol = "stdx_checksum_crc32_pclmul", .sites = 5 },
    .{ .symbol = "stdx_checksum_adler32_avx2", .sites = 8 },
    .{ .symbol = "stdx_checksum_crc32_vpclmul", .sites = 6 },
    .{ .symbol = "stdx_checksum_crc32_avx512", .sites = 7 },
    .{ .symbol = "stdx_checksum_xxh64_avx512", .sites = 1 },
    .{ .symbol = "stdx_checksum_adler32_avx512", .sites = 8 },
    .{ .symbol = "stdx_checksum_adler32_vnni", .sites = 14 },
    .{ .symbol = "stdx_json_is_utf8_x86_64_avx2", .sites = 6 },
    .{ .symbol = "stdx_json_plain_len_x86_64_avx2", .sites = 4 },
    .{ .symbol = "stdx_json_copy_plain_x86_64_avx2", .sites = 3 },
    .{ .symbol = "stdx_json_hex_len_x86_64_avx2", .sites = 10 },
    .{ .symbol = "stdx_json_copy_rest_x86_64_avx2", .sites = 55 },
    .{ .symbol = "stdx_json_copy_escaped_x86_64_avx2", .sites = 36 },
    .{ .symbol = "stdx_json_copy_escaped_unchecked_x86_64_avx2", .sites = 29 },
    .{ .symbol = "stdx_json_is_utf8_x86_64_avx512", .sites = 6 },
    // aarch64.
    .{ .symbol = "stdx_checksum_crc32_armv8", .sites = 3 },
    .{ .symbol = "stdx_checksum_crc32_pmull", .sites = 17 },
    .{ .symbol = "stdx_checksum_adler32_udot", .sites = 8 },
};
