//! Claim J7 (decision 30): a name's or a string's run and a hex string's digits at AVX2's 32
//! octets, compiled into that level's variant object. Each is exported under a name that carries
//! the level, and wide.zig calls it only when the caller's features name the level.

const constants = @import("../constants.zig");
const scan = @import("../scan.zig");
const level = @import("variant_level").level;

/// The octets one vector holds at this level.
const width: usize = switch (level) {
    .x86_64_avx2 => constants.avx2_vector_len,
    else => @compileError("claim J7 has no kernels at this level"),
};

fn plain_len(octets: [*]const u8, len: usize) callconv(.c) usize {
    return scan.plain_len_vector(width, octets[0..len]);
}

fn hex_len(input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) usize {
    return scan.hex_len_vector(width, input[0..input_len], output[0..output_len]);
}

comptime {
    const suffix = @tagName(level);
    @export(&plain_len, .{ .name = "stdx_json_plain_len_" ++ suffix });
    @export(&hex_len, .{ .name = "stdx_json_hex_len_" ++ suffix });
}
