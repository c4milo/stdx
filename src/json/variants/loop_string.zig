//! Decision 37's UTF-8 check on x86-64: the loops' string functions, whole, compiled into the AVX2
//! variant object, where scan_utf8.zig's check takes its lookup, VPSHUFB. Each is exported under a
//! name that carries the level, and the loops call it once a string, when the caller's features
//! name the level. A call inside the walk's block loop instead kept the walk's state in memory
//! across the loop on every x86-64 CPU, the kernel called or not: x86-64 saves no vector register
//! across a call (design §8 step 18).

const level = @import("variant_level").level;
const Claims = @import("../claims.zig").Claims;
const decoder_string = @import("../decoder/decoder_loop_string.zig");
const encoder_string = @import("../encoder/encoder_loop_string.zig");

comptime {
    if (level != .x86_64_avx2) @compileError("decision 37's string functions have no kernel at this level");
}

/// `decoder_loop_string.copy_rest` with every claim on: `copied` gets what it took and wrote, and
/// the return says whether it took the string.
fn copy_rest(rest: [*]const u8, rest_len: usize, room: [*]u8, room_len: usize, copied: *decoder_string.Copied) callconv(.c) bool {
    copied.* = decoder_string.copy_rest(.{}, .avx2, rest[0..rest_len], room[0..room_len]) orelse return false;
    return true;
}

/// `encoder_loop_string.copy_escaped` with every claim on, and with claim J11's runtime safety off
/// at the caller's choice (decision 35): the octets written, or `encoder_string.left` for a string
/// left to the checked path.
fn copy_escaped(octets: [*]const u8, len: usize, room: [*]u8, room_len: usize) callconv(.c) usize {
    return encoder_string.copy_escaped(.{}, .avx2, octets[0..len], room[0..room_len]) orelse encoder_string.left;
}

fn copy_escaped_unchecked(octets: [*]const u8, len: usize, room: [*]u8, room_len: usize) callconv(.c) usize {
    return encoder_string.copy_escaped(Claims{ .encoder_token_loop_runtime_safety = false }, .avx2, octets[0..len], room[0..room_len]) orelse encoder_string.left;
}

comptime {
    const suffix = @tagName(level);
    @export(&copy_rest, .{ .name = "stdx_json_copy_rest_" ++ suffix });
    @export(&copy_escaped, .{ .name = "stdx_json_copy_escaped_" ++ suffix });
    @export(&copy_escaped_unchecked, .{ .name = "stdx_json_copy_escaped_unchecked_" ++ suffix });
}
