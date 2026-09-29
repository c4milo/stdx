//! Decision 38's check over a buffer on x86-64: `scan_utf8.valid` compiled into the AVX2 variant
//! object, where the check takes decision 37's lookup, VPSHUFB, which the module's own x86-64
//! target lacks. It is exported under a name that carries the level, and `wide.is_utf8` calls it
//! when the caller's features name the level.

const level = @import("variant_level").level;
const scan_utf8 = @import("../scan_utf8.zig");

comptime {
    if (level != .x86_64_avx2) @compileError("decision 38's check has no kernel at this level");
}

fn is_utf8(octets: [*]const u8, len: usize) callconv(.c) bool {
    return scan_utf8.valid(octets[0..len]);
}

comptime {
    @export(&is_utf8, .{ .name = "stdx_json_is_utf8_" ++ @tagName(level) });
}
