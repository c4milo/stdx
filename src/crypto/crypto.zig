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
/// docs/zig.md names this object `tcp`, and its sessions `tcp.tcp`.
pub const tls = struct {
    // The session module's names.
    pub const Client = chapulin.tcp.tcp.Client;
    pub const Server = chapulin.tcp.tcp.Server;
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
    pub const ClientOptions = chapulin.tcp.ClientOptions;
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
    pub const ServerOptions = chapulin.tcp.ServerOptions;
    pub const Cpu = chapulin.tcp.Cpu;
    pub const cpu_bits = chapulin.tcp.cpu_bits;
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
};

/// TLS 1.3 under QUIC: the handshake and packet protection a QUIC stack drives, as `quic.Client`
/// and `quic.Server`, and the options, keys and values of chapulin's QUIC object. chapulin's
/// docs/zig.md names this object `quic`, and its sessions `quic.quic`. Its types are its own: a
/// QUIC session takes `quic.ClientOptions`, never `tls.ClientOptions`.
pub const quic = struct {
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
    pub const Client = chapulin.quic.quic.Client;
    pub const Server = chapulin.quic.quic.Server;
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
    pub const ClientOptions = chapulin.quic.ClientOptions;
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
    pub const ServerOptions = chapulin.quic.ServerOptions;
    pub const Cpu = chapulin.quic.Cpu;
    pub const cpu_bits = chapulin.quic.cpu_bits;
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
};

/// JSON Web Signatures: RS256, ES256 and EdDSA checks and signatures, and base64url
/// (RFC 7515, RFC 7518 §3.1, RFC 8037 §3.1).
pub const jws = chapulin.tcp.jws;
/// DNSSEC: the check of an RRSIG over a record set, and the digests of NSEC3 and DS records
/// (RFC 4034, RFC 5155).
pub const dnssec = chapulin.tcp.dnssec;
/// SCRAM's calls (RFC 5802, RFC 7677): SHA-256, HMAC-SHA-256, PBKDF2, a compare in constant time,
/// base 64 and RFC 5929's tls-server-end-point.
pub const scram = chapulin.tcp.scram;
/// The CPU the calls beside `tls` and `quic` take, which the program describes from its one probe,
/// `stdx.platform`. It is `tls.Cpu`.
pub const Cpu = tls.Cpu;

/// The value a program makes once, when it starts, from its probe, its statement of timing and its
/// random source, and passes to each session and call (decision 87 as amended on 2026-11-25).
pub const init = init_file.init;
/// What `init` takes.
pub const Options = init_file.Options;
/// What `init` returns: the CPU as each chapulin object takes it, and the random source.
pub const Context = init_file.Context;
/// The timing mode of the threads that run chapulin's code, which only the program can state.
pub const Timing = init_file.Timing;

const init_file = @import("crypto_init.zig");

comptime {
    // chapulin's module exports `ch_assert_fail` from a comptime block, which Zig runs only when
    // something references the module. A program that names this module links chapulin's objects,
    // even one that only asks whether a name exists, so this reference keeps the hook beside them.
    _ = chapulin;
}

const std = @import("std");

/// The names of chapulin's object roots that `tls` and `quic` do not repeat: the two session
/// modules, which each namespace flattens, the calls `stdx.crypto` names once, and the API's own
/// test helper.
const left_out = [_][]const u8{ "tcp", "quic", "jws", "dnssec", "scram", "testing" };

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
}

test {
    _ = init_file;
}

test "the module names each part of chapulin's API" {
    try std.testing.expect(@hasDecl(tls, "Client"));
    try std.testing.expect(@hasDecl(quic, "Server"));
    try std.testing.expect(@hasDecl(jws, "verify"));
    try std.testing.expect(@hasDecl(dnssec, "verify"));
    try std.testing.expect(@hasDecl(scram, "sha256"));
    try std.testing.expect(@typeInfo(Cpu) == .@"struct");
    try std.testing.expect(@typeInfo(Context) == .@"struct");
    try std.testing.expect(@typeInfo(Timing) == .@"enum");
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
