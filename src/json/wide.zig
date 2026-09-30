//! Claim J7 (decision 30): a name's or a string's run and a hex string's digits at the widest
//! vector the caller's CPU features allow. On x86-64, AVX2's 32 octets run in a variant object of
//! their own (decision 21, variants.zig), called through the symbols below. Everywhere else, and
//! without AVX2, the module's own 16-octet paths run. A CPU with AVX-512 takes AVX2's: its 64-octet
//! kernels ran hex strings 14% slower on an Intel Xeon Platinum 8573C (design §8 step 18). The UTF-8
//! scan of claim J5 stays at 16 octets: at 64 it ran text of Cyrillic and CJK characters 37% slower,
//! rescanning the block each escape stopped it in (design §8 step 17).
//!
//! A call costs what a short run saves, so a run no longer than the level's width stays on the
//! 16-octet path, which compiles into its caller. A name's or a string's run starts there too, and
//! leaves its caller only once it passes its first 16 octets, for a function of its own at every
//! level.

const std = @import("std");
const builtin = @import("builtin");
const codec = @import("codec");
const constants = @import("constants.zig");
const scan = @import("scan.zig");
const scan_utf8 = @import("scan_utf8.zig");
const Claims = @import("claims.zig").Claims;

/// Whether this target has J7's kernels, and decision 37's block walk: x86-64 alone builds the
/// objects of its wider levels.
pub const has_kernels = builtin.cpu.arch == .x86_64;

/// The widest vector a caller's features allow, which each codec's state keeps from `init`.
pub const Level = enum(u8) {
    /// SSE2's and NEON's 16 octets: the module's own target.
    target,
    /// x86-64 with AVX2, whether or not the CPU has AVX-512: 32 octets.
    avx2,

    pub fn of(features: codec.Features) Level {
        if (!has_kernels) return .target;
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
        };
    }
};

extern fn stdx_json_plain_len_x86_64_avx2(octets: [*]const u8, len: usize) callconv(.c) usize;
extern fn stdx_json_hex_len_x86_64_avx2(input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) usize;
extern fn stdx_json_is_utf8_x86_64_avx2(octets: [*]const u8, len: usize) callconv(.c) bool;
extern fn stdx_json_is_utf8_x86_64_avx512(octets: [*]const u8, len: usize) callconv(.c) bool;

/// `scan.plain_len_vector` at `level`'s width: the first 16 octets inline, and a run past them out
/// of line.
pub inline fn plain_len(level: Level, octets: []const u8) usize {
    if (octets.len <= constants.vector_len) return @call(.always_inline, scan.plain_len_vector, .{ constants.vector_len, octets });
    const first_len = @call(.always_inline, scan.plain_len_vector, .{ constants.vector_len, octets[0..constants.vector_len] });
    if (first_len < constants.vector_len) return first_len;
    return constants.vector_len + plain_len_past_first(level, octets[constants.vector_len..]);
}

/// The rest of a run past its first 16 octets, in a function of its own: a long run's loop compiled
/// inside its caller's ran 13% slower on the N2 (design §8 step 17). The level's kernel takes what
/// the run holds past `wide_run_len_min` octets.
noinline fn plain_len_past_first(level: Level, octets: []const u8) align(constants.kernel_alignment) usize {
    const head_len_max = constants.wide_run_len_min - constants.vector_len;
    if (comptime !has_kernels) return scan.plain_len_vector(constants.vector_len, octets);
    if (level == .target or octets.len <= head_len_max + level.width()) return scan.plain_len_vector(constants.vector_len, octets);
    const head_len = scan.plain_len_vector(constants.vector_len, octets[0..head_len_max]);
    if (head_len < head_len_max) return head_len;
    const rest = octets[head_len_max..];
    return head_len_max + switch (level) {
        .avx2 => stdx_json_plain_len_x86_64_avx2(rest.ptr, rest.len),
        .target => unreachable,
    };
}

/// `scan.hex_len_vector` at `level`'s width, and a string shorter than a block inline.
pub inline fn hex_len(level: Level, input: []const u8, output: []u8) usize {
    if (input.len < constants.vector_len) return scan.hex_len_short(input, output);
    if (comptime !has_kernels) return scan.hex_len_vector(constants.vector_len, input, output);
    if (level == .target or input.len <= level.width()) return scan.hex_len_vector(constants.vector_len, input, output);
    return switch (level) {
        .avx2 => stdx_json_hex_len_x86_64_avx2(input.ptr, input.len, output.ptr, output.len),
        .target => unreachable,
    };
}

/// The widest copy of the UTF-8 check a caller's features allow (decision 39): AVX-512's 64 lanes,
/// AVX2's 32, or the module's own 16. `Level` gives the loops no AVX-512 width, since its 64-octet
/// kernels ran hex strings slower (above); the check is one pass over a buffer with no octet to
/// stop at, and takes the widest.
pub const CheckLevel = enum(u8) {
    target,
    avx2,
    avx512,

    pub fn of(features: codec.Features) CheckLevel {
        if (!has_kernels) return .target;
        if (features.avx512) return .avx512;
        if (features.avx2) return .avx2;
        return .target;
    }
};

/// `scan_utf8.valid` at `level` (decisions 38 and 39): the variant object's copies take decision
/// 37's lookup, VPSHUFB, at 32 lanes and at 64, which the module's own x86-64 target lacks;
/// everywhere else the module's own copy runs at 16.
pub fn is_utf8(level: CheckLevel, octets: []const u8) bool {
    if (comptime !has_kernels) return scan_utf8.valid(octets);
    return switch (level) {
        .target => scan_utf8.valid(octets),
        .avx2 => stdx_json_is_utf8_x86_64_avx2(octets.ptr, octets.len),
        .avx512 => stdx_json_is_utf8_x86_64_avx512(octets.ptr, octets.len),
    };
}

// Tests. scan_test.zig requires every level this CPU runs to scan as the scalar paths do; these pin
// which level the features pick.

const testing = std.testing;

test "Level.of picks the widest level the features name, and on x86-64 alone" {
    try testing.expectEqual(Level.target, Level.of(.none()));
    try testing.expectEqual(if (has_kernels) Level.avx2 else .target, Level.of(.{ .avx2 = true }));
    try testing.expectEqual(if (has_kernels) Level.avx2 else .target, Level.of(.{ .avx2 = true, .avx512 = true }));
}

test "Level.with keeps the level with claim J7 on, and takes the target's with it off" {
    for (std.enums.values(Level)) |level| {
        try testing.expectEqual(level, level.with(.{ .wide_vectors = true }));
        try testing.expectEqual(Level.target, level.with(.{ .wide_vectors = false }));
    }
}

test "CheckLevel.of picks AVX-512 for the check, where Level.of picks AVX2" {
    try testing.expectEqual(CheckLevel.target, CheckLevel.of(.none()));
    try testing.expectEqual(if (has_kernels) CheckLevel.avx2 else .target, CheckLevel.of(.{ .avx2 = true }));
    try testing.expectEqual(if (has_kernels) CheckLevel.avx512 else .target, CheckLevel.of(.{ .avx2 = true, .avx512 = true }));
}
