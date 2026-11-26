//! `stdx.crypto.hash`: chapulin's hashes, HMAC and HKDF (decision 87 as amended on 2026-11-25
//! and 2026-11-26). The type is also the value's field `hash`, so a program calls
//! `crypto.hash.sha256(&digest, bytes)`, and each hash runs on the instructions the program's CPU
//! features hold. A stream starts with `stdx.crypto.hash.Sha256.init(crypto)`. chapulin builds the
//! calls for a host target alone, and on another each names that in a compile error.
const chapulin = @import("chapulin");
const chapulin_hash = chapulin.tcp.hash;
const c = chapulin.tcp.c;
const init_file = @import("crypto_init.zig");
const Context = init_file.Context;
const Hash = @This();

/// chapulin's descriptions of the CPU for the TCP object's calls, which `init` made. stdx's own: a
/// program reads none of them.
description: init_file.Description(chapulin.tcp),

/// The digest lengths, in bytes.
pub const sha256_len = chapulin_hash.sha256_len;
pub const sha384_len = chapulin_hash.sha384_len;
pub const sha512_len = chapulin_hash.sha512_len;
pub const sha3_256_len = chapulin_hash.sha3_256_len;
pub const sha3_512_len = chapulin_hash.sha3_512_len;
/// The longest `info` that `hkdf_expand` takes.
pub const hkdf_info_len_max = chapulin_hash.hkdf_info_len_max;
/// The three hashes of HMAC and HKDF, and the options of each call.
pub const Algorithm = chapulin_hash.Algorithm;
pub const HmacOptions = chapulin_hash.HmacOptions;
pub const HkdfExtractOptions = chapulin_hash.HkdfExtractOptions;
pub const HkdfExpandOptions = chapulin_hash.HkdfExpandOptions;

/// SHA-256, SHA-384 and SHA-512 as a stream (FIPS 180-4): `init`, `update`, and `final`, which
/// wipes the state.
pub const Sha256 = Sha2(chapulin_hash.Sha256, c.ch_sha256_init);
pub const Sha384 = Sha2(chapulin_hash.Sha384, c.ch_sha384_init);
pub const Sha512 = Sha2(chapulin_hash.Sha512, c.ch_sha512_init);

/// SHAKE128 and SHAKE256 as a stream (FIPS 202): `init`, `absorb`, `squeeze`, and `wipe`.
pub const Shake128 = Shake(chapulin_hash.Shake128, c.ch_shake128_init);
pub const Shake256 = Shake(chapulin_hash.Shake256, c.ch_shake256_init);

/// chapulin's stream, which stdx starts with its C init call and the value `init` computed, and
/// then calls as chapulin does.
fn Sha2(comptime Inner: type, comptime init_call: anytype) type {
    return struct {
        inner: Inner,

        /// The digest's length in bytes.
        pub const digest_len = Inner.digest_len;

        /// A stream that hashes on the instructions the context's features hold.
        pub fn init(context: Context) error{Invalid}!@This() {
            var self: @This() = .{ .inner = .{} };
            try result(init_call(&self.inner.state, context.tcp_description.bits_on_thread()));
            return self;
        }

        pub fn update(self: *@This(), bytes: []const u8) void {
            self.inner.update(bytes);
        }

        /// The digest of every byte added, in `out`. The state is wiped.
        pub fn final(self: *@This(), out: *[digest_len]u8) void {
            self.inner.final(out);
        }
    };
}

fn Shake(comptime Inner: type, comptime init_call: anytype) type {
    return struct {
        inner: Inner,

        /// A stream that hashes on the instructions the context's features hold.
        pub fn init(context: Context) error{Invalid}!@This() {
            var self: @This() = .{ .inner = .{} };
            try result(init_call(&self.inner.state, context.tcp_description.bits_on_thread()));
            return self;
        }

        pub fn absorb(self: *@This(), bytes: []const u8) void {
            self.inner.absorb(bytes);
        }

        pub fn squeeze(self: *@This(), out: []u8) void {
            self.inner.squeeze(out);
        }

        pub fn wipe(self: *@This()) void {
            self.inner.wipe();
        }
    };
}

/// The digest of `bytes`, in `out`, over the whole input. Each call hands chapulin's C call the
/// value `init` computed, as chapulin's own call does after it converts a description.
pub fn sha256(self: *const Hash, out: *[sha256_len]u8, bytes: []const u8) error{Invalid}!void {
    return result(c.ch_sha256_hash(self.bits(), bytes.ptr, bytes.len, out));
}

pub fn sha384(self: *const Hash, out: *[sha384_len]u8, bytes: []const u8) error{Invalid}!void {
    return result(c.ch_sha384_hash(self.bits(), bytes.ptr, bytes.len, out));
}

pub fn sha512(self: *const Hash, out: *[sha512_len]u8, bytes: []const u8) error{Invalid}!void {
    return result(c.ch_sha512_hash(self.bits(), bytes.ptr, bytes.len, out));
}

pub fn sha3_256(self: *const Hash, out: *[sha3_256_len]u8, bytes: []const u8) error{Invalid}!void {
    return result(c.ch_sha3_256_hash(self.bits(), bytes.ptr, bytes.len, out));
}

pub fn sha3_512(self: *const Hash, out: *[sha3_512_len]u8, bytes: []const u8) error{Invalid}!void {
    return result(c.ch_sha3_512_hash(self.bits(), bytes.ptr, bytes.len, out));
}

/// `out.len` bytes of SHAKE128's or SHAKE256's output over `bytes`.
pub fn shake128(self: *const Hash, out: []u8, bytes: []const u8) error{Invalid}!void {
    return result(c.ch_shake128_hash(self.bits(), bytes.ptr, bytes.len, out.ptr, out.len));
}

pub fn shake256(self: *const Hash, out: []u8, bytes: []const u8) error{Invalid}!void {
    return result(c.ch_shake256_hash(self.bits(), bytes.ptr, bytes.len, out.ptr, out.len));
}

/// HMAC (RFC 2104) under the options' hash, in `out`, which holds that hash's digest.
pub fn hmac(self: *const Hash, out: []u8, options: *const HmacOptions) error{Invalid}!void {
    const key = options.key;
    const message = options.message;
    return result(c.ch_hmac(self.bits(), @intFromEnum(options.algorithm), key.ptr, key.len, message.ptr, message.len, out.ptr, out.len));
}

/// HKDF's Extract and Expand (RFC 5869 §2.2 and §2.3).
pub fn hkdf_extract(self: *const Hash, prk: []u8, options: *const HkdfExtractOptions) error{Invalid}!void {
    const salt = options.salt;
    const ikm = options.ikm;
    return result(c.ch_hkdf_extract(self.bits(), @intFromEnum(options.algorithm), salt.ptr, salt.len, ikm.ptr, ikm.len, prk.ptr, prk.len));
}

pub fn hkdf_expand(self: *const Hash, out: []u8, options: *const HkdfExpandOptions) error{Invalid}!void {
    const prk = options.prk;
    const info = options.info;
    return result(c.ch_hkdf_expand(self.bits(), @intFromEnum(options.algorithm), prk.ptr, prk.len, info.ptr, info.len, out.ptr, out.len));
}

/// The C value for the calling thread.
fn bits(self: *const Hash) u32 {
    return self.description.bits_on_thread();
}

/// The C call's result: error.Invalid for a value or a length the object refuses.
fn result(code: c_int) error{Invalid}!void {
    return chapulin.tcp.from_code(error{Invalid}, code);
}

// Tests.

const std = @import("std");
const testing = std.testing;
const platform = @import("platform");

/// A fixed source for the tests, which writes zeros. It is no random source.
fn zeros(_: *anyopaque, bytes: []u8) void {
    @memset(bytes, 0);
}

test "each whole-input call gives what chapulin's own call gives" {
    var state: u8 = 0;
    const context = init_file.init(platform.CpuFeatures.detect(), .{ .ptr = &state, .fillFn = zeros });
    const cpu = context.tcp_description.on_thread();
    const bytes = "the message stdx and chapulin hash";
    var ours: [sha512_len]u8 = undefined;
    var theirs: [sha512_len]u8 = undefined;
    try context.hash.sha256(ours[0..sha256_len], bytes);
    try chapulin_hash.sha256(cpu, theirs[0..sha256_len], bytes);
    try testing.expectEqualSlices(u8, theirs[0..sha256_len], ours[0..sha256_len]);
    try context.hash.sha384(ours[0..sha384_len], bytes);
    try chapulin_hash.sha384(cpu, theirs[0..sha384_len], bytes);
    try testing.expectEqualSlices(u8, theirs[0..sha384_len], ours[0..sha384_len]);
    try context.hash.sha512(&ours, bytes);
    try chapulin_hash.sha512(cpu, &theirs, bytes);
    try testing.expectEqualSlices(u8, &theirs, &ours);
    try context.hash.sha3_256(ours[0..sha3_256_len], bytes);
    try chapulin_hash.sha3_256(cpu, theirs[0..sha3_256_len], bytes);
    try testing.expectEqualSlices(u8, theirs[0..sha3_256_len], ours[0..sha3_256_len]);
    try context.hash.sha3_512(ours[0..sha3_512_len], bytes);
    try chapulin_hash.sha3_512(cpu, theirs[0..sha3_512_len], bytes);
    try testing.expectEqualSlices(u8, theirs[0..sha3_512_len], ours[0..sha3_512_len]);
    try context.hash.shake128(ours[0..40], bytes);
    try chapulin_hash.shake128(cpu, theirs[0..40], bytes);
    try testing.expectEqualSlices(u8, theirs[0..40], ours[0..40]);
    try context.hash.shake256(ours[0..40], bytes);
    try chapulin_hash.shake256(cpu, theirs[0..40], bytes);
    try testing.expectEqualSlices(u8, theirs[0..40], ours[0..40]);
}

test "HMAC and HKDF give what chapulin's own calls give, each argument in its place" {
    var state: u8 = 0;
    const context = init_file.init(platform.CpuFeatures.detect(), .{ .ptr = &state, .fillFn = zeros });
    const cpu = context.tcp_description.on_thread();
    var ours: [sha384_len]u8 = undefined;
    var theirs: [sha384_len]u8 = undefined;
    const mac: HmacOptions = .{ .algorithm = .sha384, .key = "a key", .message = "a message" };
    try context.hash.hmac(&ours, &mac);
    try chapulin_hash.hmac(cpu, &theirs, &mac);
    try testing.expectEqualSlices(u8, &theirs, &ours);
    // The key and the message in each other's place give another MAC.
    const swapped: HmacOptions = .{ .algorithm = .sha384, .key = mac.message, .message = mac.key };
    try chapulin_hash.hmac(cpu, &theirs, &swapped);
    try testing.expect(!std.mem.eql(u8, &theirs, &ours));
    const extract: HkdfExtractOptions = .{ .algorithm = .sha384, .salt = "a salt", .ikm = "keying material" };
    try context.hash.hkdf_extract(&ours, &extract);
    try chapulin_hash.hkdf_extract(cpu, &theirs, &extract);
    try testing.expectEqualSlices(u8, &theirs, &ours);
    const expand: HkdfExpandOptions = .{ .algorithm = .sha384, .prk = &ours, .info = "info" };
    var okm: [42]u8 = undefined;
    var their_okm: [42]u8 = undefined;
    try context.hash.hkdf_expand(&okm, &expand);
    try chapulin_hash.hkdf_expand(cpu, &their_okm, &expand);
    try testing.expectEqualSlices(u8, &their_okm, &okm);
    // A PRK of the wrong length is refused, as chapulin refuses it.
    try testing.expectError(error.Invalid, context.hash.hkdf_extract(ours[0..1], &extract));
}

test "each stream gives what chapulin's own stream gives" {
    var state: u8 = 0;
    const context = init_file.init(platform.CpuFeatures.detect(), .{ .ptr = &state, .fillFn = zeros });
    const cpu = context.tcp_description.on_thread();
    var ours = try Sha384.init(context);
    var theirs = try chapulin_hash.Sha384.init(cpu);
    ours.update("two ");
    ours.update("parts");
    theirs.update("two parts");
    var our_digest: [sha384_len]u8 = undefined;
    var their_digest: [sha384_len]u8 = undefined;
    ours.final(&our_digest);
    theirs.final(&their_digest);
    try testing.expectEqualSlices(u8, &their_digest, &our_digest);
    var our_shake = try Shake256.init(context);
    var their_shake = try chapulin_hash.Shake256.init(cpu);
    our_shake.absorb("a message");
    their_shake.absorb("a message");
    our_shake.squeeze(our_digest[0..20]);
    their_shake.squeeze(their_digest[0..20]);
    our_shake.wipe();
    their_shake.wipe();
    try testing.expectEqualSlices(u8, their_digest[0..20], our_digest[0..20]);
}

test "a call and a stream hand chapulin the value init computed for the thread" {
    // chapulin refuses a value that names a bit of the other architecture, so a call that hands
    // over the stated value fails where that value carries one.
    const builtin = @import("builtin");
    if (builtin.cpu.arch != .x86_64 and builtin.cpu.arch != .aarch64) return error.SkipZigTest;
    const other_architecture = if (builtin.cpu.arch == .x86_64) c.CH_CPU_SVE2 else c.CH_CPU_AVX2;
    var state: u8 = 0;
    var context = init_file.init(platform.CpuFeatures.detect(), .{ .ptr = &state, .fillFn = zeros });
    context.hash.description.statement = .always;
    context.tcp_description.statement = .always;
    context.hash.description.stated_bits |= other_architecture;
    context.tcp_description.stated_bits |= other_architecture;
    var digest: [sha256_len]u8 = undefined;
    try testing.expectError(error.Invalid, context.hash.sha256(&digest, "abc"));
    try testing.expectError(error.Invalid, Sha256.init(context));
    try testing.expectError(error.Invalid, Shake128.init(context));
    // Without the statement the unstated value, which names no such bit, is handed over.
    context.hash.description.statement = .never;
    context.tcp_description.statement = .never;
    try context.hash.sha256(&digest, "abc");
    _ = try Sha256.init(context);
}
