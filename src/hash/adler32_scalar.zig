//! Adler-32's scalar path: RFC 1950 §9's update_adler32, with the reduction modulo 65521 deferred
//! to once per 5552 octets, as RFC 1950 §8.2 allows. It is the path every target has, the oracle
//! the vector paths are tested against, and their tail.

const std = @import("std");
const assert = std.debug.assert;
const constants = @import("constants.zig");

/// The Adler-32 value after the octets, from `adler`.
pub fn update(adler: u32, octets: []const u8) u32 {
    var s1: u32 = adler & std.math.maxInt(u16);
    var s2: u32 = adler >> @bitSizeOf(u16);
    // RFC 1950 §8.2's bound holds only for sums that start reduced.
    assert(s1 < constants.adler32_base and s2 < constants.adler32_base);
    var rest = octets;
    while (rest.len > 0) {
        const run = rest[0..@min(rest.len, constants.adler32_deferral_len)];
        for (run) |octet| {
            s1 += octet;
            s2 += s1;
        }
        s1 %= constants.adler32_base;
        s2 %= constants.adler32_base;
        rest = rest[run.len..];
    }
    return (s2 << @bitSizeOf(u16)) | s1;
}
