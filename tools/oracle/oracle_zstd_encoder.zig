//! A libzstd compression context at one level with no checksum, kept across encodes as a server
//! keeps one, over `tools/oracle/oracle_zstd.c`. A piece of oracle.zig, which exports it as
//! `zstd_encoder`.

const std = @import("std");

pub const Context = opaque {};

extern fn oracle_zstd_encoder_create(level: c_int) ?*Context;
extern fn oracle_zstd_encoder_free(context: *Context) void;
extern fn oracle_zstd_encode_with(context: *Context, input: [*]const u8, input_len: usize, output: [*]u8, output_len: usize) usize;

/// A new context at `level`, or null when libzstd could not allocate or set one.
pub fn create(level: c_int) ?*Context {
    return oracle_zstd_encoder_create(level);
}

pub fn free(context: *Context) void {
    oracle_zstd_encoder_free(context);
}

/// libzstd's frame of `input` into `output` with `context`, or null when libzstd failed or
/// `output` had no room.
pub fn encode(context: *Context, input: []const u8, output: []u8) ?usize {
    const written = oracle_zstd_encode_with(context, input.ptr, input.len, output.ptr, output.len);
    return if (written == std.math.maxInt(usize)) null else written;
}
