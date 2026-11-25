//! stdx.crypto: chapulin's cryptography, through its Zig module (decision 87, design §8 step 23).
//! stdx writes no cryptography of its own. chapulin holds every cipher, signature, hash and MAC,
//! and its proofs and constant-time checks cover them. A program that names chapulin only through
//! stdx links one chapulin.
//!
//! The module exists when a dependent passes `.crypto = true` to stdx's dependency. It is the
//! module of chapulin's `TRANSPORT=nonblocking` request, so chapulin's docs/zig.md describes each
//! name: `tcp` is the TCP object, with TLS record sessions as `tcp.tcp`, and `quic` is the QUIC
//! object, with QUIC sessions as `quic.quic`. The calls of the TCP object that are not TLS stand
//! beside them: `jws`, `dnssec` and `scram`. chapulin builds those three for an arm64 target with
//! NEON or an x86-64 target with SSE2 alone, and on any other target each names that in a compile
//! error.
//!
//! chapulin's module defines `ch_assert_fail`, the hook its C calls on a failed assertion. A
//! program that reports one its own way declares `pub fn chapulinAssertFail(condition:
//! [*:0]const u8, file: [*:0]const u8, line: c_int) noreturn` in its root file.
const chapulin = @import("chapulin");

/// The TCP object: TLS 1.3 record sessions over the bytes the caller reads and writes, as
/// `tcp.tcp.Client` and `tcp.tcp.Server`, the options each takes, and the PEM readers of keys,
/// chains and anchors.
pub const tcp = chapulin.tcp;
/// The QUIC object: the TLS handshake and packet protection under a QUIC stack, as
/// `quic.quic.Client` and `quic.quic.Server`.
pub const quic = chapulin.quic;
/// JSON Web Signatures: RS256, ES256 and EdDSA checks and signatures, and base64url
/// (RFC 7515, RFC 7518 §3.1, RFC 8037 §3.1).
pub const jws = chapulin.tcp.jws;
/// DNSSEC: the check of an RRSIG over a record set, and the digests of NSEC3 and DS records
/// (RFC 4034, RFC 5155).
pub const dnssec = chapulin.tcp.dnssec;
/// SCRAM's calls (RFC 5802, RFC 7677): SHA-256, HMAC-SHA-256, PBKDF2, a compare in constant time,
/// base 64 and RFC 5929's tls-server-end-point.
pub const scram = chapulin.tcp.scram;
/// The CPU a session runs on, which the program describes from its one probe, `stdx.platform`.
pub const Cpu = chapulin.tcp.Cpu;

comptime {
    // chapulin's module exports `ch_assert_fail` from a comptime block, which Zig runs only when
    // something references the module. A program that names this module links chapulin's objects,
    // even one that only asks whether a name exists, so this reference keeps the hook beside them.
    _ = chapulin;
}

const std = @import("std");

test "the module names each part of chapulin's API" {
    try std.testing.expect(@hasDecl(tcp, "tcp"));
    try std.testing.expect(@hasDecl(quic, "quic"));
    try std.testing.expect(@hasDecl(jws, "verify"));
    try std.testing.expect(@hasDecl(dnssec, "verify"));
    try std.testing.expect(@hasDecl(scram, "sha256"));
    try std.testing.expect(@typeInfo(Cpu) == .@"struct");
}

test "SHA-256 of abc is RFC 6234's" {
    // RFC 6234 §8.5's first test of SHA-256: the input "abc".
    const expected = [_]u8{
        0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea, 0x41, 0x41, 0x40, 0xde, 0x5d, 0xae, 0x22, 0x23,
        0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c, 0xb4, 0x10, 0xff, 0x61, 0xf2, 0x00, 0x15, 0xad,
    };
    var digest: [scram.sha256_len]u8 = undefined;
    scram.sha256(&digest, "abc");
    try std.testing.expectEqualSlices(u8, &expected, &digest);
}
