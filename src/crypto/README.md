# stdx.crypto

`stdx.crypto` is [chapulin](https://github.com/c4milo/chapulin)'s cryptography: TLS 1.3 over TCP
and under QUIC, JSON Web Signatures, DNSSEC, SCRAM's calls, and the hashes, HMAC and HKDF of
chapulin's key schedule. stdx writes no cryptography of
its own ([decision 87](../../docs/decisions.md)). chapulin holds every cipher, signature, hash and
MAC, and its proofs and constant-time checks cover them.

## Use

A dependent asks for the module in its `build.zig`, with `.crypto = true`:

```zig
const stdx_crypto = b.dependency("stdx", .{ .target = target, .release = true, .crypto = true });
crypto_exe.root_module.addImport("stdx", stdx_crypto.module("stdx"));
```

Without the option, stdx fetches no chapulin and compiles no C, and `stdx.crypto` names the option
in a compile error.

A program makes one value when it starts, with `init`, and passes it to each session and call. The
value holds the answers of the program's one probe, its statement of its threads' timing, and a
cryptographically secure random source:

```zig
const probe = stdx.platform.probe();
// Data-independent timing on this thread where a program can set it: arm64 with FEAT_DIT.
// On x86-64 only the operating system sets DOITM, so this program states nothing there.
const set = stdx.platform.set_data_independent_timing(probe, true);
const timing: stdx.crypto.Timing = if (set) .data_independent else .not_stated;
const crypto = stdx.crypto.init(.{
    .probe = probe,
    .timing = timing,
    .random = csprng.random(),
});
```

`timing` has no default, because only the program knows its threads' mode. `.data_independent`
states that each thread that runs chapulin's code has set PSTATE.DIT on arm64, or runs on an
x86-64 part whose operating system has set DOITM. Under it, chapulin runs AES-GCM and the widening
multiplies on the CPU's instructions where the probe found them. `.not_stated` keeps chapulin's code
that needs no such mode. `stdx.platform.set_data_independent_timing` sets PSTATE.DIT on the calling
thread alone, so a program calls it on each thread that runs chapulin's code, and
`stdx.platform.data_independent_timing` reads it ([`stdx.platform`](../platform/README.md)).

A program passes the value's `cpu` to the TCP object's sessions and calls, its `quic_cpu` to the
QUIC object's, and its `random` to both. It is a value and not a global, so no call runs before it
exists, and no two threads race to set it. A program then calls chapulin's code under stdx's
names:

```zig
var digest: [stdx.crypto.hash.sha256_len]u8 = undefined;
try stdx.crypto.hash.sha256(crypto.cpu, &digest, "abc");
```

Each hash runs where `crypto.cpu` puts it. On arm64 under `.data_independent`, SHA-256, SHA-512
and SHA-3 run on the instructions the probe found. On x86-64, SHA-384 and SHA-512 run on AVX2
where the probe found it. Every other hash runs chapulin's portable code.

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
| `hash` | SHA-256, SHA-384 and SHA-512 as a stream and over a whole input, SHA3-256 and SHA3-512, SHAKE128 and SHAKE256, HMAC over the three SHA-2 hashes, and HKDF's Extract and Expand ([RFC 5869](https://www.rfc-editor.org/rfc/rfc5869)), each taking `Context.cpu` | `tcp.hash` |
| `Cpu` | The CPU the calls beside `tls` and `quic` take, which the program describes from its one probe, [`stdx.platform`](../platform/README.md): `tls.Cpu` | `tcp.Cpu` |
| `init`, `Options`, `Context` and `Timing` | The value a program makes once from its probe, [`stdx.platform`](../platform/README.md), its statement of timing and its random source | none: stdx's own |

A QUIC session takes the QUIC object's types: `quic.ClientOptions`, never `tls.ClientOptions`.

## Options

- `crypto`: fetch chapulin and give `stdx.crypto`. Off for a dependent, on in stdx's own build.
- `crypto_keylog`: build chapulin with `KEYLOG=on`, so each session hands its traffic secrets to
  `ch_keylog`, which the program defines. It is for a program's tests that read a capture, never
  for a program that ships.
  Zig gives each file to one module of a compile, so one image holds one stdx. A test image over
  the stdx of `crypto_keylog` builds its own copy of each module of the program that imports stdx.

## Limits

- chapulin builds `jws`, `dnssec`, `scram` and `hash` for an arm64 target with NEON or an x86-64
  target with SSE2 alone. On any other target each names that in a compile error, and TLS runs
  TLS_CHACHA20_POLY1305_SHA256 alone.
- chapulin's module defines `ch_assert_fail`, the hook its C calls on a failed assertion. The root
  `stdx` references the module in a build with `.crypto = true`. So every program over that build
  keeps the hook, and a program that names no `stdx.crypto` keeps it too. A program must not
  define the hook again. A program that reports a failed assertion its own way declares `pub fn
  chapulinAssertFail` in its root file, as chapulin's docs/zig.md shows.
