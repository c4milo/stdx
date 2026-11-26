//! stdx.crypto: chapulin's cryptography, through its Zig module (decision 87, design §8 step 23).
//! stdx writes no cryptography of its own. chapulin holds every cipher, signature, hash and MAC,
//! and its proofs and constant-time checks cover them. A program that names chapulin only through
//! stdx links one chapulin.
//!
//! The module exists when a dependent passes `.crypto = true` to stdx's dependency. It names the
//! module of chapulin's `TRANSPORT=nonblocking` request, whose two objects chapulin compiles apart:
//! `tls` holds the TCP object's sessions and types, and `quic` the QUIC object's, each in one flat
//! namespace. chapulin's docs/zig.md describes each name, under the object `tcp` or `quic` and its
//! sessions `tcp.tcp` or `quic.quic`. The calls of the TCP object that are not TLS stand beside
//! them: `jws`, `dnssec` and `scram`. chapulin builds those three for an arm64 target with
//! NEON or an x86-64 target with SSE2 alone, and on any other target each names that in a compile
//! error.
//!
//! chapulin's module defines `ch_assert_fail`, the hook its C calls on a failed assertion. A
//! program that reports one its own way declares `pub fn chapulinAssertFail(condition:
//! [*:0]const u8, file: [*:0]const u8, line: c_int) noreturn` in its root file.
const chapulin = @import("chapulin");

/// TLS 1.3 over TCP: record sessions over the bytes the caller reads and writes, as `tls.Client`
/// and `tls.Server`, and the options, keys and values of chapulin's TCP object. chapulin's
/// docs/zig.md names this object `tcp`, and its sessions `tcp.tcp`. The sessions and their options
/// are stdx's: a session's `init` takes the program's `Context` (decision 87 as amended on
/// 2026-11-26).
pub const tls = struct {
    // The sessions and options stdx owns, over chapulin's.
    pub const Client = tls_session.Client;
    pub const Server = tls_session.Server;
    pub const ClientOptions = tls_session.ClientOptions;
    pub const ServerOptions = tls_session.ServerOptions;
    // The session module's names.
    pub const Progress = chapulin.tcp.tcp.Progress;
    pub const Read = chapulin.tcp.tcp.Read;
    pub const alert_record_len = chapulin.tcp.tcp.alert_record_len;
    pub const key_update_record_len = chapulin.tcp.tcp.key_update_record_len;
    pub const parts_max = chapulin.tcp.tcp.parts_max;
    pub const InitError = chapulin.tcp.tcp.InitError;
    pub const RecordInError = chapulin.tcp.tcp.RecordInError;
    pub const ServerRecordInError = chapulin.tcp.tcp.ServerRecordInError;
    pub const RecordOutError = chapulin.tcp.tcp.RecordOutError;
    pub const ReadError = chapulin.tcp.tcp.ReadError;
    pub const WriteError = chapulin.tcp.tcp.WriteError;
    pub const EndError = chapulin.tcp.tcp.EndError;
    pub const FailError = chapulin.tcp.tcp.FailError;
    pub const ExportError = chapulin.tcp.tcp.ExportError;
    // The object's names: its options, keys, identities, negotiated values and checks.
    pub const c = chapulin.tcp.c;
    pub const Error = chapulin.tcp.Error;
    pub const from_code = chapulin.tcp.from_code;
    pub const TrustAnchor = chapulin.tcp.TrustAnchor;
    pub const Limits = chapulin.tcp.Limits;
    pub const SpkiPin = chapulin.tcp.SpkiPin;
    pub const Trust = chapulin.tcp.Trust;
    pub const Clock = chapulin.tcp.Clock;
    pub const Ticket = chapulin.tcp.Ticket;
    pub const Chain = chapulin.tcp.Chain;
    pub const EcdsaP256Key = chapulin.tcp.EcdsaP256Key;
    pub const RsaKey = chapulin.tcp.RsaKey;
    pub const MlDsa87Key = chapulin.tcp.MlDsa87Key;
    pub const Anchors = chapulin.tcp.Anchors;
    pub const EcdsaP256Identity = chapulin.tcp.EcdsaP256Identity;
    pub const RsaPssIdentity = chapulin.tcp.RsaPssIdentity;
    pub const MlDsa87Identity = chapulin.tcp.MlDsa87Identity;
    pub const Group = chapulin.tcp.Group;
    pub const Suite = chapulin.tcp.Suite;
    pub const State = chapulin.tcp.State;
    pub const CertType = chapulin.tcp.CertType;
    pub const AlertDescription = chapulin.tcp.AlertDescription;
    pub const alert_of = chapulin.tcp.alert_of;
    pub const build_matches = chapulin.tcp.build_matches;
    pub const Hook = chapulin.tcp.Hook;
    pub const RandomSource = chapulin.tcp.RandomSource;
    pub const hook_context = chapulin.tcp.hook_context;

    /// Reads a PEM key into `key`, an `*EcdsaP256Key`, `*RsaKey` or `*MlDsa87Key`, checked
    /// against the leaf certificate's key, on the instructions the context's features hold.
    pub fn init_from_pem(context: Context, key: anytype, pem: []const u8, leaf: []const u8) error{Invalid}!void {
        return key.init_from_pem(init_file.tcp_cpu(context), pem, leaf);
    }
};

/// TLS 1.3 under QUIC: the handshake and packet protection a QUIC stack drives, as `quic.Client`
/// and `quic.Server`, and the options, keys and values of chapulin's QUIC object. chapulin's
/// docs/zig.md names this object `quic`, and its sessions `quic.quic`. Its types are its own: a
/// QUIC session takes `quic.ClientOptions`, never `tls.ClientOptions`. The sessions and their
/// options are stdx's, as `tls`'s are.
pub const quic = struct {
    // The sessions and options stdx owns, over chapulin's.
    pub const Client = quic_session.Client;
    pub const Server = quic_session.Server;
    pub const ClientOptions = quic_session.ClientOptions;
    pub const ServerOptions = quic_session.ServerOptions;
    // The session module's names.
    pub const Level = chapulin.quic.quic.Level;
    pub const level_count = chapulin.quic.quic.level_count;
    pub const Direction = chapulin.quic.quic.Direction;
    pub const Version = chapulin.quic.quic.Version;
    pub const KeySet = chapulin.quic.quic.KeySet;
    pub const Outgoing = chapulin.quic.quic.Outgoing;
    pub const Opened = chapulin.quic.quic.Opened;
    pub const ChooseVersion = chapulin.quic.quic.ChooseVersion;
    pub const RetryConnectionIds = chapulin.quic.quic.RetryConnectionIds;
    pub const TokenCheck = chapulin.quic.quic.TokenCheck;
    pub const TokenMintError = chapulin.quic.quic.TokenMintError;
    pub const retry_tag = chapulin.quic.quic.retry_tag;
    pub const token_mint = chapulin.quic.quic.token_mint;
    pub const token_check = chapulin.quic.quic.token_check;
    pub const InitError = chapulin.quic.quic.InitError;
    pub const CryptoInError = chapulin.quic.quic.CryptoInError;
    pub const ServerCryptoInError = chapulin.quic.quic.ServerCryptoInError;
    pub const CryptoOutError = chapulin.quic.quic.CryptoOutError;
    pub const SealError = chapulin.quic.quic.SealError;
    pub const OpenError = chapulin.quic.quic.OpenError;
    // The object's names: its options, keys, identities, negotiated values and checks.
    pub const c = chapulin.quic.c;
    pub const Error = chapulin.quic.Error;
    pub const from_code = chapulin.quic.from_code;
    pub const TrustAnchor = chapulin.quic.TrustAnchor;
    pub const Limits = chapulin.quic.Limits;
    pub const SpkiPin = chapulin.quic.SpkiPin;
    pub const Trust = chapulin.quic.Trust;
    pub const Clock = chapulin.quic.Clock;
    pub const Ticket = chapulin.quic.Ticket;
    pub const Chain = chapulin.quic.Chain;
    pub const EcdsaP256Key = chapulin.quic.EcdsaP256Key;
    pub const RsaKey = chapulin.quic.RsaKey;
    pub const MlDsa87Key = chapulin.quic.MlDsa87Key;
    pub const Anchors = chapulin.quic.Anchors;
    pub const EcdsaP256Identity = chapulin.quic.EcdsaP256Identity;
    pub const RsaPssIdentity = chapulin.quic.RsaPssIdentity;
    pub const MlDsa87Identity = chapulin.quic.MlDsa87Identity;
    pub const Group = chapulin.quic.Group;
    pub const Suite = chapulin.quic.Suite;
    pub const State = chapulin.quic.State;
    pub const CertType = chapulin.quic.CertType;
    pub const AlertDescription = chapulin.quic.AlertDescription;
    pub const alert_of = chapulin.quic.alert_of;
    pub const build_matches = chapulin.quic.build_matches;
    pub const Hook = chapulin.quic.Hook;
    pub const RandomSource = chapulin.quic.RandomSource;
    pub const hook_context = chapulin.quic.hook_context;

    /// Reads a PEM key into `key`, the QUIC object's `*EcdsaP256Key`, `*RsaKey` or `*MlDsa87Key`.
    pub fn init_from_pem(context: Context, key: anytype, pem: []const u8, leaf: []const u8) error{Invalid}!void {
        return key.init_from_pem(init_file.quic_cpu(context), pem, leaf);
    }
};

/// JSON Web Signatures: RS256, ES256 and EdDSA checks and signatures, and base64url
/// (RFC 7515, RFC 7518 §3.1, RFC 8037 §3.1). `sign` takes the program's `Context`, and draws its
/// noise from the context's random source.
pub const jws = struct {
    pub const Algorithm = chapulin.tcp.jws.Algorithm;
    pub const VerifyOptions = chapulin.tcp.jws.VerifyOptions;
    pub const verify = chapulin.tcp.jws.verify;
    pub const PrivateKey = chapulin.tcp.jws.PrivateKey;
    pub const base64url_len = chapulin.tcp.jws.base64url_len;
    pub const base64url_decoded_len_max = chapulin.tcp.jws.base64url_decoded_len_max;
    pub const base64url_encode = chapulin.tcp.jws.base64url_encode;
    pub const base64url_decode = chapulin.tcp.jws.base64url_decode;
    pub const sign = jws_file.sign;
};
/// DNSSEC: the check of an RRSIG over a record set, and the digests of NSEC3 and DS records
/// (RFC 4034, RFC 5155).
pub const dnssec = chapulin.tcp.dnssec;
/// SCRAM's calls (RFC 5802, RFC 7677): SHA-256, HMAC-SHA-256, PBKDF2, a compare in constant time,
/// base 64 and RFC 5929's tls-server-end-point.
pub const scram = chapulin.tcp.scram;
/// The hashes, HMAC and HKDF of chapulin's key schedule: SHA-256, SHA-384 and SHA-512 as a stream
/// and over a whole input (FIPS 180-4), SHA3-256 and SHA3-512, SHAKE128 and SHAKE256 (FIPS 202),
/// HMAC over the three SHA-2 hashes (RFC 2104), and HKDF's Extract and Expand (RFC 5869). Each
/// call takes the program's `Context`, and runs each hash on the instructions its features hold.
pub const hash = @import("crypto_hash.zig");

/// The value a program makes once, when it starts, from its `stdx.platform.CpuFeatures` and its
/// random source, and passes to each call that runs chapulin's code (decision 87 as amended on
/// 2026-11-25). stdx maps the features to chapulin's description of the CPU at each call.
pub const init = init_file.init;
/// What `init` returns.
pub const Context = init_file.Context;

const init_file = @import("crypto_init.zig");
const options_file = @import("crypto_options.zig");
const jws_file = @import("crypto_jws.zig");
const tls_session = @import("crypto_tls_session.zig");
const quic_session = @import("crypto_quic_session.zig");

comptime {
    // chapulin's module exports `ch_assert_fail` from a comptime block, which Zig runs only when
    // something references the module. A program that names this module links chapulin's objects,
    // even one that only asks whether a name exists, so this reference keeps the hook beside them.
    _ = chapulin;
}

const std = @import("std");
const platform = @import("platform");

/// The names of chapulin's object roots that `tls`, `quic`, `jws` and `hash` do not repeat: the
/// two session modules, which each namespace flattens, the calls `stdx.crypto` names once, the
/// API's own test helper, and chapulin's description of the CPU, which stdx maps from
/// `CpuFeatures` and no program names.
const left_out = [_][]const u8{ "tcp", "quic", "jws", "dnssec", "scram", "hash", "testing", "Cpu", "cpu_bits", "SignOptions" };

fn left_out_name(name: []const u8) bool {
    for (left_out) |out| {
        if (std.mem.eql(u8, out, name)) return true;
    }
    return false;
}

/// The first public declaration of `source` that `namespace` does not name, but those `left_out`
/// holds, or an empty name when it names all of them.
fn first_missing(comptime namespace: type, comptime source: type) []const u8 {
    inline for (@typeInfo(source).@"struct".decls) |decl| {
        if (!left_out_name(decl.name) and !@hasDecl(namespace, decl.name)) return decl.name;
    }
    return "";
}

test "tls and quic name every public name of chapulin's two objects" {
    // A name chapulin adds fails this test, which prints it, until its namespace repeats it.
    try std.testing.expectEqualStrings("", first_missing(tls, chapulin.tcp));
    try std.testing.expectEqualStrings("", first_missing(tls, chapulin.tcp.tcp));
    try std.testing.expectEqualStrings("", first_missing(quic, chapulin.quic));
    try std.testing.expectEqualStrings("", first_missing(quic, chapulin.quic.quic));
    try std.testing.expectEqualStrings("", first_missing(jws, chapulin.tcp.jws));
    try std.testing.expectEqualStrings("", first_missing(hash, chapulin.tcp.hash));
}

test "no namespace names chapulin's description of the CPU" {
    try std.testing.expect(!@hasDecl(tls, "Cpu") and !@hasDecl(tls, "cpu_bits"));
    try std.testing.expect(!@hasDecl(quic, "Cpu") and !@hasDecl(quic, "cpu_bits"));
    try std.testing.expect(!@hasDecl(@This(), "Cpu"));
    try std.testing.expect(!@hasDecl(jws, "SignOptions"));
}

test {
    _ = init_file;
    _ = options_file;
    _ = jws_file;
    _ = tls_session;
    _ = quic_session;
    _ = @import("crypto_session_test.zig");
}

test "each session names every call of chapulin's session" {
    // A call chapulin adds fails this test, which prints it, until stdx's session forwards it.
    const receive_len = 4096;
    try std.testing.expectEqualStrings("", first_missing(tls.Client(receive_len, .{}), chapulin.tcp.tcp.Client(receive_len, .{})));
    try std.testing.expectEqualStrings("", first_missing(tls.Server(receive_len, .{}), chapulin.tcp.tcp.Server(receive_len, .{})));
    try std.testing.expectEqualStrings("", first_missing(quic.Client(receive_len, .{}), chapulin.quic.quic.Client(receive_len, .{})));
    try std.testing.expectEqualStrings("", first_missing(quic.Server(receive_len, .{}), chapulin.quic.quic.Server(receive_len, .{})));
}

test "the module names each part of chapulin's API" {
    try std.testing.expect(@hasDecl(tls, "Client"));
    try std.testing.expect(@hasDecl(quic, "Server"));
    try std.testing.expect(@hasDecl(jws, "verify"));
    try std.testing.expect(@hasDecl(dnssec, "verify"));
    try std.testing.expect(@hasDecl(scram, "sha256"));
    try std.testing.expect(@hasDecl(hash, "Sha256"));
    try std.testing.expect(@typeInfo(Context) == .@"struct");
}

/// RFC 6234 §8.5's first test of SHA-256: the digest of the input "abc", in hex.
const abc_sha256_hex = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad";

fn abc_sha256() ![hash.sha256_len]u8 {
    var digest: [hash.sha256_len]u8 = undefined;
    _ = try std.fmt.hexToBytes(&digest, abc_sha256_hex);
    return digest;
}

/// A fixed source for the tests, which writes zeros. It is no random source.
fn zeros(_: *anyopaque, bytes: []u8) void {
    @memset(bytes, 0);
}

test "chapulin takes the description stdx maps from this host's features" {
    // A bit the object does not define for its architecture makes each call refuse the value,
    // so a digest shows that stdx gave chapulin a value it takes.
    var source_state: u8 = 0;
    const random: tls.RandomSource = .{ .ptr = &source_state, .fillFn = zeros };
    const context = init(platform.CpuFeatures.detect(), random);
    var digest: [hash.sha256_len]u8 = undefined;
    try hash.sha256(context, &digest, "abc");
    try std.testing.expectEqualSlices(u8, &(try abc_sha256()), &digest);
    var stream = try hash.Sha256.init(context);
    stream.update("a");
    stream.update("bc");
    stream.final(&digest);
    try std.testing.expectEqualSlices(u8, &(try abc_sha256()), &digest);
}

test "SHA-256 of abc is RFC 6234's" {
    var digest: [scram.sha256_len]u8 = undefined;
    scram.sha256(&digest, "abc");
    try std.testing.expectEqualSlices(u8, &(try abc_sha256()), &digest);
}
