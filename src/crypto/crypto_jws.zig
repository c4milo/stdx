//! `stdx.crypto.jws.sign`: chapulin's JWS signature, which takes the program's `Context` in place
//! of chapulin's description of the CPU and draws its 32 bytes of noise from the context's random
//! source (decision 87 as amended on 2026-11-25). chapulin builds it for a host object with a
//! server role, and on another target it names that in a compile error.
const std = @import("std");
const chapulin = @import("chapulin");
const init_file = @import("crypto_init.zig");
const Context = init_file.Context;

/// The noise each signature draws, in bytes: chapulin's `CH_JWS_NOISE_LEN`.
const noise_len = chapulin.tcp.c.CH_JWS_NOISE_LEN;

/// The signature of `input`, the JWS Signing Input, under `key`, in the first bytes of `out`.
/// error.Cap when `out` is shorter than the signature, and error.Invalid for a key chapulin
/// refuses. The noise is wiped before the call returns.
pub fn sign(context: Context, out: []u8, key: chapulin.tcp.jws.PrivateKey, input: []const u8) error{ Cap, Invalid }![]u8 {
    var noise: [noise_len]u8 = undefined;
    context.random.bytes(&noise);
    defer std.crypto.secureZero(u8, &noise);
    return chapulin.tcp.jws.sign(out, &.{ .cpu = init_file.tcp_cpu(context), .key = key, .noise = &noise, .input = input });
}

// Tests.

const testing = std.testing;
const platform = @import("platform");

/// A fixed source for the tests, which counts the bytes drawn from it and writes the count after
/// each, because chapulin refuses noise of zeros alone. It is no random source.
const Counter = struct {
    drawn: usize = 0,

    fn fill(pointer: *anyopaque, bytes: []u8) void {
        const counter: *Counter = @ptrCast(@alignCast(pointer));
        for (bytes) |*byte| {
            counter.drawn += 1;
            byte.* = @truncate(counter.drawn);
        }
    }
};

test "a signature draws its noise from the context's random source" {
    var counter: Counter = .{};
    const context = init_file.init(platform.CpuFeatures.detect(), .{ .ptr = &counter, .fillFn = Counter.fill });
    // A P-256 scalar of 1, which every key check takes.
    var scalar = [_]u8{0} ** 32;
    scalar[31] = 1;
    var signature: [64]u8 = undefined;
    const written = try sign(context, &signature, .{ .es256 = &scalar }, "e30.e30");
    try testing.expectEqual(@as(usize, 64), written.len);
    try testing.expectEqual(@as(usize, noise_len), counter.drawn);
    try testing.expectError(error.Cap, sign(context, signature[0..8], .{ .es256 = &scalar }, "e30.e30"));
}
