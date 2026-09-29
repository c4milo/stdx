//! Decision 37's UTF-8 check on x86-64: the walk's block loop (string_walk.zig), compiled into the
//! AVX2 variant object, where scan_utf8.zig's check takes its lookup, VPSHUFB. It is exported under
//! a name that carries the level, and string_walk.zig calls it only when the caller's features name
//! the level and the run's first block holds a non-ASCII octet.

const level = @import("variant_level").level;
const string_walk = @import("../string_walk.zig");
const Walk = string_walk.Walk;

comptime {
    if (level != .x86_64_avx2) @compileError("decision 37's block walk has no kernel at this level");
}

fn take_blocks(walk: *Walk, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) u8 {
    return @intFromEnum(walk.take_blocks(input[0..input_len], output[0..output_len]));
}

comptime {
    @export(&take_blocks, .{ .name = "stdx_json_take_blocks_" ++ @tagName(level) });
}
