# stdx.crypto

`stdx.crypto` is [chapulin](https://github.com/c4milo/chapulin)'s cryptography: TLS 1.3 over TCP
and under QUIC, JSON Web Signatures, DNSSEC, and SCRAM's hashes. stdx writes no cryptography of
its own ([decision 87](../../docs/decisions.md)). chapulin holds every cipher, signature, hash and
MAC, and its proofs and constant-time checks cover them.

## Use

A dependent asks for the module in its `build.zig`, with `.crypto = true`:

```zig
const stdx_crypto = b.dependency("stdx", .{ .target = target, .release = true, .crypto = true });
crypto_exe.root_module.addImport("stdx", stdx_crypto.module("stdx"));
```

Without the option, stdx fetches no chapulin and compiles no C, and `stdx.crypto` names the option
in a compile error. A program then calls chapulin's code under stdx's names:

```zig
var digest: [stdx.crypto.scram.sha256_len]u8 = undefined;
stdx.crypto.scram.sha256(&digest, "abc");
```

stdx is the one place that asks chapulin for its module. So a program that names chapulin only
through stdx links one chapulin, which chapulin requires.

## What it holds

The module names chapulin's Zig module of `TRANSPORT=nonblocking`. chapulin compiles its two
objects apart, so each has its own types, and each gets one flat namespace here. chapulin's
[docs/zig.md](https://github.com/c4milo/chapulin/blob/main/docs/zig.md) describes each name, under
the object it comes from.

| Name | What it is | chapulin's name |
| --- | --- | --- |
| `tls` | TLS 1.3 over TCP: `tls.Client` and `tls.Server`, their options, the readers of PEM keys, chains and anchors, and the values a session negotiates | `tcp`, with its sessions in `tcp.tcp` |
| `quic` | TLS 1.3 under QUIC: `quic.Client` and `quic.Server`, the handshake and packet protection a QUIC stack drives, and the QUIC object's own options and keys | `quic`, with its sessions in `quic.quic` |
| `jws` | JSON Web Signatures: RS256, ES256 and EdDSA, and base64url ([RFC 7515](https://www.rfc-editor.org/rfc/rfc7515)) | `tcp.jws` |
| `dnssec` | The check of an RRSIG, and the digests of NSEC3 and DS records ([RFC 4034](https://www.rfc-editor.org/rfc/rfc4034)) | `tcp.dnssec` |
| `scram` | SHA-256, HMAC-SHA-256, PBKDF2, a compare in constant time, and RFC 5929's tls-server-end-point ([RFC 7677](https://www.rfc-editor.org/rfc/rfc7677)) | `tcp.scram` |
| `Cpu` | The CPU the calls beside `tls` and `quic` take, which the program describes from its one probe, [`stdx.platform`](../platform/README.md): `tls.Cpu` | `tcp.Cpu` |

A QUIC session takes the QUIC object's types: `quic.ClientOptions`, never `tls.ClientOptions`.

## Options

- `crypto`: fetch chapulin and give `stdx.crypto`. Off for a dependent, on in stdx's own build.
- `crypto_keylog`: build chapulin with `KEYLOG=on`, so each session hands its traffic secrets to
  `ch_keylog`, which the program defines. It is for a program's tests that read a capture, never
  for a program that ships.

## Limits

- chapulin builds `jws`, `dnssec` and `scram` for an arm64 target with NEON or an x86-64 target
  with SSE2 alone. On any other target each names that in a compile error, and TLS runs
  TLS_CHACHA20_POLY1305_SHA256 alone.
- chapulin's module defines `ch_assert_fail`, the hook its C calls on a failed assertion. A
  program must not define it again. A program that reports a failed assertion its own way declares
  `pub fn chapulinAssertFail` in its root file, as chapulin's docs/zig.md shows.
