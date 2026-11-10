//! base64's vector steps compiled for x86-64 with AVX2 (decision 68): the decoder's nibble tables
//! through `vpshufb`, and the encoder's shuffles, which AVX2 gives LLVM. Each is exported under a
//! name that carries the level, and fast.zig calls it only when the caller's features name AVX2.

const fast = @import("../fast.zig");
const alphabet = @import("../alphabet.zig");
const level = @import("variant_level").level;

fn decode_blocks(mode: u8, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) usize {
    return switch (fast.Mode.from_code(mode)) {
        inline else => |known| fast.decode_blocks(known.letters(), input[0..input_len], output[0..output_len]),
    };
}

fn encode_blocks(letters: u8, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) callconv(.c) usize {
    return switch (@as(alphabet.Alphabet, @enumFromInt(letters))) {
        inline else => |known| fast.encode_blocks(known, input[0..input_len], output[0..output_len]),
    };
}

comptime {
    const suffix = @tagName(level);
    @export(&decode_blocks, .{ .name = "stdx_base64_decode_blocks_" ++ suffix });
    @export(&encode_blocks, .{ .name = "stdx_base64_encode_blocks_" ++ suffix });
}
