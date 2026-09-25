//! CRC-32, the gzip member's check (RFC 1952 §2.3.1), by the path the caller's features allow.
//!
//! `update` is RFC 1952 §8's update_crc: it takes the CRC-32 of the octets before, 0 before the
//! first, and gives the CRC-32 with the new octets added. Every path gives the same value; the
//! table path is the oracle the others are tested against (decision 21).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const crc32_table = @import("crc32_table.zig");
const Features = @import("features.zig").Features;

pub const Crc32Path = enum {
    /// Slice-by-8 tables, on every target.
    table,
    /// Carry-less multiplication, from the x86-64 variant object.
    pclmul,
    /// Arm's CRC32 instructions, from the aarch64 variant object.
    armv8,
    /// Carry-less multiplication by PMULL, with the CRC32 instructions for the tail, from the
    /// aarch64 variant object.
    pmull,

    /// The fastest path a CPU with `features` runs in this build.
    pub fn fastest(features: Features) Crc32Path {
        for ([_]Crc32Path{ .pclmul, .pmull, .armv8 }) |path| {
            if (path.runs_on(features)) return path;
        }
        return .table;
    }

    /// True when a CPU with `features` runs the path in this build.
    pub fn runs_on(path: Crc32Path, features: Features) bool {
        return path.built() and switch (path) {
            .table => true,
            .pclmul => features.pclmul,
            .armv8 => features.crc32,
            .pmull => features.pmull and features.crc32,
        };
    }

    /// True when this build holds the path's code. Only an x86-64 build links the PCLMULQDQ
    /// object, and only an aarch64 build the CRC32 and PMULL one.
    pub fn built(path: Crc32Path) bool {
        return switch (path) {
            .table => true,
            .pclmul => builtin.cpu.arch == .x86_64,
            .armv8, .pmull => builtin.cpu.arch == .aarch64,
        };
    }
};

// The kernels of the variant objects, which build/variants.zig links into this module. Each is
// referenced only on the architecture that links it.
extern fn stdx_checksum_crc32_pclmul(register: u32, octets: [*]const u8, len: usize) callconv(.c) u32;
extern fn stdx_checksum_crc32_armv8(register: u32, octets: [*]const u8, len: usize) callconv(.c) u32;
extern fn stdx_checksum_crc32_pmull(register: u32, octets: [*]const u8, len: usize) callconv(.c) u32;

/// The CRC-32 after the octets, from `crc`, by `path`. The caller has checked that the CPU has the
/// path's instructions, through `Crc32Path.fastest` or `runs_on`.
pub fn update(path: Crc32Path, crc: u32, octets: []const u8) u32 {
    assert(path.built());
    // RFC 1952 §8, update_crc: the register is the one's complement of the CRC on entry and exit.
    const register = crc ^ constants.crc32_conditioning;
    const result = switch (path) {
        .table => crc32_table.update_register(register, octets),
        .pclmul => pclmul(register, octets),
        .armv8 => armv8(register, octets),
        .pmull => pmull(register, octets),
    };
    return result ^ constants.crc32_conditioning;
}

fn pclmul(register: u32, octets: []const u8) u32 {
    if (builtin.cpu.arch != .x86_64) unreachable;
    return stdx_checksum_crc32_pclmul(register, octets.ptr, octets.len);
}

fn pmull(register: u32, octets: []const u8) u32 {
    if (builtin.cpu.arch != .aarch64) unreachable;
    return stdx_checksum_crc32_pmull(register, octets.ptr, octets.len);
}

fn armv8(register: u32, octets: []const u8) u32 {
    if (builtin.cpu.arch != .aarch64) unreachable;
    return stdx_checksum_crc32_armv8(register, octets.ptr, octets.len);
}

test {
    _ = @import("crc32_test.zig");
}
