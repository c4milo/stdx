//! `stdx.crypto.hash`: chapulin's hashes, HMAC and HKDF, each taking the program's `Context` in
//! place of chapulin's description of the CPU (decision 87 as amended on 2026-11-25). stdx maps
//! the context's CPU features at each call, so each hash runs on the instructions they hold.
//! chapulin builds the calls for a host target alone, and on another each names that in a compile
//! error.
const chapulin_hash = @import("chapulin").tcp.hash;
const init_file = @import("crypto_init.zig");
const Context = init_file.Context;

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
pub const Sha256 = Sha2(chapulin_hash.Sha256);
pub const Sha384 = Sha2(chapulin_hash.Sha384);
pub const Sha512 = Sha2(chapulin_hash.Sha512);

/// SHAKE128 and SHAKE256 as a stream (FIPS 202): `init`, `absorb`, `squeeze`, and `wipe`.
pub const Shake128 = Shake(chapulin_hash.Shake128);
pub const Shake256 = Shake(chapulin_hash.Shake256);

fn Sha2(comptime Inner: type) type {
    return struct {
        inner: Inner,

        /// The digest's length in bytes.
        pub const digest_len = Inner.digest_len;

        /// A stream that hashes on the instructions the context's features hold.
        pub fn init(context: Context) error{Invalid}!@This() {
            return .{ .inner = try Inner.init(init_file.tcp_cpu(context)) };
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

fn Shake(comptime Inner: type) type {
    return struct {
        inner: Inner,

        /// A stream that hashes on the instructions the context's features hold.
        pub fn init(context: Context) error{Invalid}!@This() {
            return .{ .inner = try Inner.init(init_file.tcp_cpu(context)) };
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

/// The digest of `bytes`, in `out`, over the whole input.
pub fn sha256(context: Context, out: *[sha256_len]u8, bytes: []const u8) error{Invalid}!void {
    return chapulin_hash.sha256(init_file.tcp_cpu(context), out, bytes);
}

pub fn sha384(context: Context, out: *[sha384_len]u8, bytes: []const u8) error{Invalid}!void {
    return chapulin_hash.sha384(init_file.tcp_cpu(context), out, bytes);
}

pub fn sha512(context: Context, out: *[sha512_len]u8, bytes: []const u8) error{Invalid}!void {
    return chapulin_hash.sha512(init_file.tcp_cpu(context), out, bytes);
}

pub fn sha3_256(context: Context, out: *[sha3_256_len]u8, bytes: []const u8) error{Invalid}!void {
    return chapulin_hash.sha3_256(init_file.tcp_cpu(context), out, bytes);
}

pub fn sha3_512(context: Context, out: *[sha3_512_len]u8, bytes: []const u8) error{Invalid}!void {
    return chapulin_hash.sha3_512(init_file.tcp_cpu(context), out, bytes);
}

/// `out.len` bytes of SHAKE128's or SHAKE256's output over `bytes`.
pub fn shake128(context: Context, out: []u8, bytes: []const u8) error{Invalid}!void {
    return chapulin_hash.shake128(init_file.tcp_cpu(context), out, bytes);
}

pub fn shake256(context: Context, out: []u8, bytes: []const u8) error{Invalid}!void {
    return chapulin_hash.shake256(init_file.tcp_cpu(context), out, bytes);
}

/// HMAC (RFC 2104) under the options' hash, in `out`, which holds that hash's digest.
pub fn hmac(context: Context, out: []u8, options: *const HmacOptions) error{Invalid}!void {
    return chapulin_hash.hmac(init_file.tcp_cpu(context), out, options);
}

/// HKDF's Extract and Expand (RFC 5869 §2.2 and §2.3).
pub fn hkdf_extract(context: Context, prk: []u8, options: *const HkdfExtractOptions) error{Invalid}!void {
    return chapulin_hash.hkdf_extract(init_file.tcp_cpu(context), prk, options);
}

pub fn hkdf_expand(context: Context, out: []u8, options: *const HkdfExpandOptions) error{Invalid}!void {
    return chapulin_hash.hkdf_expand(init_file.tcp_cpu(context), out, options);
}
