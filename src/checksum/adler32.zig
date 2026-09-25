//! Adler-32, the zlib stream's check (RFC 1950 §2.2), by the path the caller's features allow.
//!
//! `update` is RFC 1950 §9's update_adler32: it takes the Adler-32 of the octets before, 1 before
//! the first, and gives the Adler-32 with the new octets added. Every path gives the same value;
//! the scalar path is the oracle the others are tested against (decision 21).

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const constants = @import("constants.zig");
const adler32_scalar = @import("adler32_scalar.zig");
const adler32_vector = @import("adler32_vector.zig");
const Features = @import("features.zig").Features;

/// The octets one block of the vector path takes: two of the target's vector registers, which
/// measured faster than one on aarch64 (docs/design.md §8 step 4).
const vector_len = constants.adler32_registers_per_block *
    (std.simd.suggestVectorLength(u8) orelse constants.adler32_vector_len_fallback);

pub const Adler32Path = enum {
    /// One octet at a time, on every target.
    scalar,
    /// Vectors of the target's width, on every target.
    vector,
    /// Vectors of 32 octets, from the x86-64 AVX2 variant object.
    avx2,
    /// Vectors of 64 octets, from the x86-64 AVX-512 variant object.
    avx512,
    /// Arm's UDOT, from the aarch64 DotProd variant object.
    udot,

    /// The fastest path a CPU with `features` runs in this build.
    pub fn fastest(features: Features) Adler32Path {
        for ([_]Adler32Path{ .avx512, .avx2, .udot }) |path| {
            if (path.runs_on(features)) return path;
        }
        return .vector;
    }

    /// True when a CPU with `features` runs the path in this build.
    pub fn runs_on(path: Adler32Path, features: Features) bool {
        return path.built() and switch (path) {
            .scalar, .vector => true,
            .avx2 => features.avx2,
            .avx512 => features.avx512,
            .udot => features.dotprod,
        };
    }

    /// True when this build holds the path's code. Only an x86-64 build links the AVX2 and AVX-512
    /// objects, and only an aarch64 build the DotProd one.
    pub fn built(path: Adler32Path) bool {
        return switch (path) {
            .scalar, .vector => true,
            .avx2, .avx512 => builtin.cpu.arch == .x86_64,
            .udot => builtin.cpu.arch == .aarch64,
        };
    }
};

// The kernels of the variant objects: AVX2 and AVX-512 in an x86-64 build, DotProd in an aarch64
// build.
extern fn stdx_checksum_adler32_avx2(adler: u32, octets: [*]const u8, len: usize) callconv(.c) u32;
extern fn stdx_checksum_adler32_avx512(adler: u32, octets: [*]const u8, len: usize) callconv(.c) u32;
extern fn stdx_checksum_adler32_udot(adler: u32, octets: [*]const u8, len: usize) callconv(.c) u32;

/// The Adler-32 after the octets, from `adler`, by `path`. The caller has checked that the CPU has
/// the path's instructions, through `Adler32Path.fastest` or `runs_on`.
pub fn update(path: Adler32Path, adler: u32, octets: []const u8) u32 {
    assert(path.built());
    return switch (path) {
        .scalar => adler32_scalar.update(adler, octets),
        .vector => adler32_vector.update(vector_len, adler, octets),
        .avx2 => avx2(adler, octets),
        .avx512 => avx512(adler, octets),
        .udot => udot(adler, octets),
    };
}

fn udot(adler: u32, octets: []const u8) u32 {
    if (builtin.cpu.arch != .aarch64) unreachable;
    return stdx_checksum_adler32_udot(adler, octets.ptr, octets.len);
}

fn avx512(adler: u32, octets: []const u8) u32 {
    if (builtin.cpu.arch != .x86_64) unreachable;
    return stdx_checksum_adler32_avx512(adler, octets.ptr, octets.len);
}

fn avx2(adler: u32, octets: []const u8) u32 {
    if (builtin.cpu.arch != .x86_64) unreachable;
    return stdx_checksum_adler32_avx2(adler, octets.ptr, octets.len);
}

test {
    _ = @import("adler32_test.zig");
}
