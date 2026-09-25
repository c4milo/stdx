//! CRC-32's table path: RFC 1952 §8's table, extended to eight tables so each step takes eight
//! octets. It is the path every target has, the oracle every faster path is tested against, and
//! the tail of each faster path.
//!
//! The functions here work on the CRC register: the value RFC 1952 §8's update_crc keeps in `c`,
//! between its entry and exit conditioning.

const std = @import("std");
const constants = @import("constants.zig");

/// The number of values an octet takes, and so the entries of each table.
const octet_values = std.math.maxInt(u8) + 1;

/// The comptime branches building the tables takes: eight tables of 256 entries, eight bits each.
const table_build_quota = 100_000;

/// `tables[0]` is RFC 1952 §8's crc_table. `tables[k][n]` is the register after the octet `n`
/// followed by `k` zero octets, so eight lookups advance the register by eight octets at once.
pub const tables: [constants.crc32_slice_len][octet_values]u32 = build_tables();

fn build_tables() [constants.crc32_slice_len][octet_values]u32 {
    @setEvalBranchQuota(table_build_quota);
    var result: [constants.crc32_slice_len][octet_values]u32 = undefined;
    for (0..octet_values) |octet| {
        // RFC 1952 §8, make_crc_table.
        var register: u32 = @intCast(octet);
        for (0..@bitSizeOf(u8)) |_| {
            register = if (register & 1 != 0) constants.crc32_polynomial_reflected ^ (register >> 1) else register >> 1;
        }
        result[0][octet] = register;
    }
    for (1..constants.crc32_slice_len) |slice| {
        for (0..octet_values) |octet| result[slice][octet] = step(result[0], result[slice - 1][octet]);
    }
    return result;
}

/// The register after one zero octet, from `register`, by RFC 1952 §8's update_crc.
fn step(table: [octet_values]u32, register: u32) u32 {
    return table[@as(u8, @truncate(register))] ^ (register >> @bitSizeOf(u8));
}

/// The register after the octets, from `register`.
pub fn update_register(register: u32, octets: []const u8) u32 {
    var value = register;
    var rest = octets;
    while (rest.len >= constants.crc32_slice_len) : (rest = rest[constants.crc32_slice_len..]) {
        const word = std.mem.readInt(u64, rest[0..constants.crc32_slice_len], .little) ^ value;
        var next: u32 = 0;
        // Octet k of the word, counted from the first, has 7 - k octets after it in the step,
        // so it takes tables[7 - k].
        inline for (0..constants.crc32_slice_len) |k| {
            const octet: u8 = @truncate(word >> (k * @bitSizeOf(u8)));
            next ^= tables[constants.crc32_slice_len - 1 - k][octet];
        }
        value = next;
    }
    // RFC 1952 §8, update_crc, one octet at a time for the rest.
    for (rest) |octet| value = step(tables[0], value ^ octet);
    return value;
}
