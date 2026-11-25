//! Decisions 38 and 39's check over a buffer on x86-64: `scan_utf8.valid_by` compiled into the
//! variant object at AVX2's 32 lanes and AVX-512's 64, by the lookup, VPSHUFB, which the module's
//! own x86-64 target lacks. Each level's copy is exported under a name that carries the level, and
//! `wide.is_utf8` calls it when the caller's features name the level.

const level = @import("variant_level").level;
const constants = @import("../constants.zig");
const scan_utf8 = @import("../scan_utf8.zig");

/// The lanes this level's check takes a block.
const width = switch (level) {
    .x86_64_avx2 => constants.avx2_vector_len,
    .x86_64_avx512 => constants.avx512_vector_len,
    else => @compileError("decision 39's check has no kernel at this level"),
};

fn is_utf8(octets: [*]const u8, len: usize) align(constants.kernel_alignment) callconv(.c) bool {
    return @call(.always_inline, scan_utf8.valid_by, .{ width, .lookup, octets[0..len] });
}

comptime {
    @export(&is_utf8, .{ .name = "stdx_json_is_utf8_" ++ @tagName(level) });
}
