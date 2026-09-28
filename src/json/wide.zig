//! Claim J7 (decision 29): the scans of scan.zig at the widest vector the caller's CPU features
//! allow. On x86-64, AVX2's 32 octets and AVX-512's 64 run in variant objects of their own
//! (decision 21, variants.zig), called through the symbols below. Everywhere else, and without
//! those features, the module's own 16-octet paths run.
//!
//! A call costs what a short run saves, so a run no longer than the level's width stays on the
//! 16-octet path, which compiles into its caller. A name's or a string's run starts there too, and
//! reaches the level's kernel only once it passes its first 16 octets.

const std = @import("std");
const builtin = @import("builtin");
const codec = @import("codec");
const constants = @import("constants.zig");
const scan = @import("scan.zig");
const Claims = @import("claims.zig").Claims;

/// Whether this target has J7's kernels: x86-64 alone builds the objects of its wider levels.
const has_kernels = builtin.cpu.arch == .x86_64;

/// The widest vector a caller's features allow, which each codec's state keeps from `init`.
pub const Level = enum(u8) {
    /// SSE2's and NEON's 16 octets: the module's own target.
    target,
    /// x86-64 with AVX2: 32 octets.
    avx2,
    /// x86-64 with AVX-512 F, BW, DQ and VL: 64 octets.
    avx512,

    pub fn of(features: codec.Features) Level {
        if (!has_kernels) return .target;
        if (features.avx512) return .avx512;
        if (features.avx2) return .avx2;
        return .target;
    }

    /// `self`, or the target's level with claim J7 off.
    pub fn with(self: Level, comptime claims: Claims) Level {
        return if (claims.wide_vectors) self else .target;
    }

    fn width(self: Level) usize {
        return switch (self) {
            .target => constants.vector_len,
            .avx2 => constants.avx2_vector_len,
            .avx512 => constants.avx512_vector_len,
        };
    }
};

extern fn stdx_json_plain_len_x86_64_avx2(octets: [*]const u8, len: usize) callconv(.c) usize;
extern fn stdx_json_plain_len_x86_64_avx512(octets: [*]const u8, len: usize) callconv(.c) usize;
extern fn stdx_json_content_len_x86_64_avx2(octets: [*]const u8, len: usize) callconv(.c) usize;
extern fn stdx_json_content_len_x86_64_avx512(octets: [*]const u8, len: usize) callconv(.c) usize;
extern fn stdx_json_hex_len_x86_64_avx2(input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) usize;
extern fn stdx_json_hex_len_x86_64_avx512(input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) usize;

/// `scan.plain_len_vector` at `level`'s width: the first 16 octets inline, and a run past them in
/// the level's kernel.
pub inline fn plain_len(level: Level, octets: []const u8) usize {
    if (comptime !has_kernels) return scan.plain_len_vector(constants.vector_len, octets);
    if (level == .target or octets.len <= level.width()) return scan.plain_len_vector(constants.vector_len, octets);
    const first_len = scan.plain_len_vector(constants.vector_len, octets[0..constants.vector_len]);
    if (first_len < constants.vector_len) return first_len;
    const rest = octets[constants.vector_len..];
    return constants.vector_len + switch (level) {
        .avx2 => stdx_json_plain_len_x86_64_avx2(rest.ptr, rest.len),
        .avx512 => stdx_json_plain_len_x86_64_avx512(rest.ptr, rest.len),
        .target => unreachable,
    };
}

/// `scan.content_len_vector` at `level`'s width.
pub inline fn content_len(level: Level, octets: []const u8) usize {
    if (comptime !has_kernels) return scan.content_len_vector(constants.vector_len, octets);
    if (level == .target or octets.len <= level.width()) return scan.content_len_vector(constants.vector_len, octets);
    return switch (level) {
        .avx2 => stdx_json_content_len_x86_64_avx2(octets.ptr, octets.len),
        .avx512 => stdx_json_content_len_x86_64_avx512(octets.ptr, octets.len),
        .target => unreachable,
    };
}

/// `scan.hex_len_vector` at `level`'s width.
pub inline fn hex_len(level: Level, input: []const u8, output: []u8) usize {
    if (comptime !has_kernels) return scan.hex_len_vector(constants.vector_len, input, output);
    if (level == .target or input.len <= level.width()) return scan.hex_len_vector(constants.vector_len, input, output);
    return switch (level) {
        .avx2 => stdx_json_hex_len_x86_64_avx2(input.ptr, input.len, output.ptr, output.len),
        .avx512 => stdx_json_hex_len_x86_64_avx512(input.ptr, input.len, output.ptr, output.len),
        .target => unreachable,
    };
}

// Tests. scan_test.zig requires every level this CPU runs to scan as the scalar paths do; these pin
// which level the features pick.

const testing = std.testing;

test "Level.of picks the widest level the features name, and on x86-64 alone" {
    try testing.expectEqual(Level.target, Level.of(.none()));
    try testing.expectEqual(if (has_kernels) Level.avx2 else .target, Level.of(.{ .avx2 = true }));
    try testing.expectEqual(if (has_kernels) Level.avx512 else .target, Level.of(.{ .avx2 = true, .avx512 = true }));
}

test "Level.with keeps the level with claim J7 on, and takes the target's with it off" {
    for (std.enums.values(Level)) |level| {
        try testing.expectEqual(level, level.with(.{ .wide_vectors = true }));
        try testing.expectEqual(Level.target, level.with(.{ .wide_vectors = false }));
    }
}
