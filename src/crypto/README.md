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

A program makes one value when it starts, with `init`, and passes it to each call that runs
chapulin's code. The value holds the CPU features the program detected once, which its codecs take
too, and a cryptographically secure random source. `std.Random` is an interface over any
generator, so stdx cannot check the source: `std.Random.DefaultPrng` is not cryptographic, and a
`std.Random.DefaultCsprng` that two threads share races on its state. A program wraps
`io.randomSecure`, which is thread-safe, keeps no state that a fork copies, and has no weaker
fallback:

```zig
/// A random source over the operating system's entropy. Each draw calls `io.randomSecure`, which
/// is thread-safe, keeps no state that a fork copies, and has no weaker fallback. A draw that fails
/// halts the program, so no session runs on bytes the system did not give.
const SecureRandom = struct {
    io: std.Io,

    fn fill(pointer: *anyopaque, bytes: []u8) void {
        const self: *SecureRandom = @ptrCast(@alignCast(pointer));
        self.io.randomSecure(bytes) catch |err| std.debug.panic("no entropy: {t}", .{err});
    }

    fn random(self: *SecureRandom) std.Random {
        return .{ .ptr = self, .fillFn = fill };
    }
};
```

```zig
// The random source of every session and signature: the operating system's entropy.
var secure: SecureRandom = .{ .io = init.io };
// The CPU features the program detects once, for its codecs and for stdx.crypto alike.
const features = stdx.platform.CpuFeatures.detect();
// PSTATE.DIT on this thread, where the core has FEAT_DIT. Elsewhere the call changes nothing.
_ = stdx.platform.set_data_independent_timing(features, true);
const crypto = stdx.crypto.init(features, secure.random());
```

Each draw is a system call. stdx makes none itself (non-negotiable 1), so the program owns them.
It is a value and not a global, so no call runs before it exists, and no two threads race to set
it. A program calls chapulin's hashes through it, and signs with `crypto.jws.sign(&out, key,
input)`:

```zig
var digest: [stdx.crypto.hash.sha256_len]u8 = undefined;
try crypto.hash.sha256(&digest, "abc");
```

A program passes the value where a call starts something: a session's `init`, a hash stream's
`stdx.crypto.hash.Sha256.init(crypto)` and a key reader's `tls.init_from_pem(crypto, ...)`, as it
passes an allocator.

`init` computes chapulin's descriptions of the CPU once, so a call does no mapping: a hash of
"abc" spends 22 instructions outside chapulin's own code, where stdx spent 57 when it mapped the
features at each call (design §8 step 32).

The sessions and their options are stdx's. `tls.ClientOptions` and `tls.ServerOptions` hold every
field of chapulin's options but `cpu` and `random`, which stdx fills from the value. A session
starts with that value and stdx's options, and no program names chapulin's description of the CPU:

- `client.init(crypto, &options)` for a `tls.Client(receive_len, limits)`, and
  `server.init(crypto, &options, sni_buf)` for a `tls.Server`.
- `client.init(crypto, &options, transport_params, peer_params)` for a `quic.Client`, and the
  server's with `sni_buf` last.
- `options.check(crypto)` checks a server's keys before a session takes them.

Every other call of a session is chapulin's, which stdx's session forwards. `tls.init_from_pem`
reads a PEM key, and `jws.sign` draws its noise from the value's random source.

stdx maps the features to chapulin's description of the CPU, so a program names no type of
chapulin's. Each call states whether the calling thread runs AES, the carry-less multiply and the
widening multiply in data-independent time:

- arm64: when the features hold FEAT_DIT and the thread's PSTATE.DIT is 1. stdx reads the mode
  at each call with `stdx.platform.data_independent_timing`, one instruction. A program sets it with
  `stdx.platform.set_data_independent_timing`, on each thread that runs chapulin's code
  ([`stdx.platform`](../platform/README.md)).
- x86-64: always, as Go and BoringSSL state it. No program can read DOITM, the mode's bit on
  x86-64.
- Any other architecture: never.

Under the statement, chapulin runs AES-GCM and the widening multiplies on the instructions the
features hold. Without it, chapulin runs TLS_CHACHA20_POLY1305_SHA256 and its code that needs no
such mode. On arm64 under the statement, SHA-256, SHA-512 and SHA-3 run on the instructions the
features hold, except SHA-3 on an Arm Neoverse N2, which `CpuFeatures.midr` names. That core runs
Keccak faster in its general registers, and AES-GCM keeps the SHA-3 extension's EOR3 there. On x86-64, SHA-384 and SHA-512 run on AVX2 where the features hold it. Every other
hash runs chapulin's portable code.

stdx is the one place that asks chapulin for its module. So a program that names chapulin only
through stdx links one chapulin, which chapulin requires.

## What it holds

The module names chapulin's Zig module of `TRANSPORT=nonblocking`. chapulin compiles its two
objects apart, so each has its own types, and each gets one flat namespace here. chapulin's
[docs/zig.md](https://github.com/c4milo/chapulin/blob/main/docs/zig.md) describes each name, under
the object it comes from.

| Name | What it is | chapulin's name |
| --- | --- | --- |
| `tls` | TLS 1.3 over TCP: `tls.Client` and `tls.Server`, stdx's sessions over chapulin's, and stdx's options, the readers of PEM keys, chains and anchors, and the values a session negotiates. Each session's `init`, `ServerOptions.check` and `init_from_pem` take the `Context` | `tcp`, with its sessions in `tcp.tcp` |
| `quic` | TLS 1.3 under QUIC: `quic.Client` and `quic.Server`, stdx's sessions over chapulin's, the handshake and packet protection a QUIC stack drives, and the QUIC object's own options and keys, which take the `Context` as `tls`'s do | `quic`, with its sessions in `quic.quic` |
| `jws` | JSON Web Signatures: RS256, ES256 and EdDSA, and base64url ([RFC 7515](https://www.rfc-editor.org/rfc/rfc7515)). The value's field `jws` signs, as `crypto.jws.sign` | `tcp.jws` |
| `dnssec` | The check of an RRSIG, and the digests of NSEC3 and DS records ([RFC 4034](https://www.rfc-editor.org/rfc/rfc4034)) | `tcp.dnssec` |
| `scram` | SHA-256, HMAC-SHA-256, PBKDF2, a compare in constant time, and RFC 5929's tls-server-end-point ([RFC 7677](https://www.rfc-editor.org/rfc/rfc7677)) | `tcp.scram` |
| `hash` | SHA-256, SHA-384 and SHA-512 as a stream and over a whole input, SHA3-256 and SHA3-512, SHAKE128 and SHAKE256, HMAC over the three SHA-2 hashes, and HKDF's Extract and Expand ([RFC 5869](https://www.rfc-editor.org/rfc/rfc5869)). The value's field `hash` calls them, as `crypto.hash.sha256`, and a stream's `init` takes the value | `tcp.hash` |
| `init` and `Context` | The value a program makes once from its CPU features, [`stdx.platform.CpuFeatures`](../platform/README.md), and its random source | none: stdx's own |

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
