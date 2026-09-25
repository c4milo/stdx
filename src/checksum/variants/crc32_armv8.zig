//! CRC-32 on aarch64: the variant object of decision 21, compiled with the CRC and PMULL extensions
//! whatever the module's target, and called only when `Features` has `crc32`, and `pmull` for the
//! folding path.
//!
//! Arm's CRC32 instructions use gzip's polynomial, in the reflected order of RFC 1952 §8, so each
//! advances the register as crc32_table.update_register does, eight octets or one at a time. The
//! folding path is crc32_fold.zig's over PMULL, with the CRC32 instructions for the last lane and
//! the tail.

const std = @import("std");
const constants = @import("../constants.zig");
const crc32_fold = @import("crc32_fold.zig");
const Lane = crc32_fold.Lane;

/// The octets one CRC32X instruction takes.
const word_len = @sizeOf(u64);

fn crc32_word(register: u32, word: u64) u32 {
    return asm ("crc32x %[out:w], %[register:w], %[word:x]"
        : [out] "=r" (-> u32),
        : [register] "r" (register),
          [word] "r" (word),
    );
}

fn crc32_octet(register: u32, octet: u8) u32 {
    return asm ("crc32b %[out:w], %[register:w], %[octet:w]"
        : [out] "=r" (-> u32),
        : [register] "r" (register),
          [octet] "r" (@as(u32, octet)),
    );
}

/// The register after the octets by the CRC32 instructions alone.
fn update_crc32(register: u32, octets: []const u8) u32 {
    var value = register;
    var position: usize = 0;
    while (octets.len - position >= word_len) : (position += word_len) {
        value = crc32_word(value, std.mem.readInt(u64, octets[position..][0..word_len], .little));
    }
    for (octets[position..]) |octet| value = crc32_octet(value, octet);
    return value;
}

const Multiply = struct {
    pub fn first_halves(lane: Lane, by: Lane) Lane {
        return asm ("pmull %[out].1q, %[lane].1d, %[by].1d"
            : [out] "=w" (-> Lane),
            : [lane] "w" (lane),
              [by] "w" (by),
        );
    }

    pub fn last_halves(lane: Lane, by: Lane) Lane {
        return asm ("pmull2 %[out].1q, %[lane].2d, %[by].2d"
            : [out] "=w" (-> Lane),
            : [lane] "w" (lane),
              [by] "w" (by),
        );
    }
};

/// Folding over `crc32_lanes_pmull` lanes, handing an input too short for it to folding over
/// fewer lanes, and one too short for that to the CRC32 instructions.
const ShortFolding = crc32_fold.Folding(Multiply, constants.crc32_lanes_pmull_short, update_crc32);
const Folding = crc32_fold.Folding(Multiply, constants.crc32_lanes_pmull, ShortFolding.update);

/// The CRC register after `len` octets from `register`, by the CRC32 instructions.
export fn stdx_checksum_crc32_armv8(register: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return update_crc32(register, octets_pointer[0..len]);
}

/// The CRC register after `len` octets from `register`, by folding with PMULL.
export fn stdx_checksum_crc32_pmull(register: u32, octets_pointer: [*]const u8, len: usize) callconv(.c) u32 {
    return Folding.update(register, octets_pointer[0..len]);
}
