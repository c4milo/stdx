//! `stdx.crypto.jws`: JSON Web Signatures, RS256, ES256 and EdDSA checks and signatures, and
//! base64url (RFC 7515, RFC 7518 §3.1, RFC 8037 §3.1). The type is also the value's field `jws`,
//! so a program signs with `crypto.jws.sign(&out, key, input)`, which draws chapulin's 32 bytes of
//! noise from the value's random source (decision 87 as amended on 2026-11-25 and 2026-11-26).
//! chapulin builds the signature for a host object with a server role, and on another target it
//! names that in a compile error.
const std = @import("std");
const chapulin = @import("chapulin");
const init_file = @import("crypto_init.zig");
const Jws = @This();

/// chapulin's descriptions of the CPU for the TCP object's calls, which `init` made. stdx's own: a
/// program reads neither field.
description: init_file.Description(chapulin.tcp),
/// The program's random source, which each signature's noise is drawn from.
random: chapulin.tcp.RandomSource,

/// chapulin's names, which take no CPU value and no random source.
pub const Algorithm = chapulin.tcp.jws.Algorithm;
pub const VerifyOptions = chapulin.tcp.jws.VerifyOptions;
pub const verify = chapulin.tcp.jws.verify;
pub const PrivateKey = chapulin.tcp.jws.PrivateKey;
pub const base64url_len = chapulin.tcp.jws.base64url_len;
pub const base64url_decoded_len_max = chapulin.tcp.jws.base64url_decoded_len_max;
pub const base64url_encode = chapulin.tcp.jws.base64url_encode;
pub const base64url_decode = chapulin.tcp.jws.base64url_decode;

/// The noise each signature draws, in bytes: chapulin's `CH_JWS_NOISE_LEN`.
const noise_len = chapulin.tcp.c.CH_JWS_NOISE_LEN;

/// The signature of `input`, the JWS Signing Input, under `key`, in the first bytes of `out`.
/// error.Cap when `out` is shorter than the signature, and error.Invalid for a key chapulin
/// refuses. The noise is wiped before the call returns.
pub fn sign(self: *const Jws, out: []u8, key: PrivateKey, input: []const u8) error{ Cap, Invalid }![]u8 {
    var noise: [noise_len]u8 = undefined;
    self.random.bytes(&noise);
    defer std.crypto.secureZero(u8, &noise);
    return chapulin.tcp.jws.sign(out, &.{ .cpu = self.description.on_thread(), .key = key, .noise = &noise, .input = input });
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
    const written = try context.jws.sign(&signature, .{ .es256 = &scalar }, "e30.e30");
    try testing.expectEqual(@as(usize, 64), written.len);
    try testing.expectEqual(@as(usize, noise_len), counter.drawn);
    try testing.expectError(error.Cap, context.jws.sign(signature[0..8], .{ .es256 = &scalar }, "e30.e30"));
}
