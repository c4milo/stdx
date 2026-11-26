# stdx

[![main](https://github.com/c4milo/stdx/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/c4milo/stdx/actions/workflows/main.yml?query=branch%3Amain)
[![coverage](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fc4milo%2Fstdx%2Fbadges%2F.github%2Fbadges%2Fcoverage.json)](https://github.com/c4milo/stdx/actions/workflows/main.yml?query=branch%3Amain)
[![license](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![zig](https://img.shields.io/badge/zig-0.16.0-f7a41d.svg)](https://ziglang.org/download/)
[![release](https://img.shields.io/github/v/release/c4milo/stdx)](https://github.com/c4milo/stdx/releases/latest)

stdx extends Zig's standard library with compression, checksums, JSON, base 64, regular
expressions and Unicode. It groups its modules as `std` groups its own, and each is written from
its RFC or from the specification that it names. Nothing in stdx allocates, opens a file, starts a
thread or reads a clock, so it fits the hot path of a server.

## Modules

Each module's folder holds a README with its examples, its options, its limits and its speed.

| Module | What it holds |
| --- | --- |
| [`stdx.compress.deflate`](src/compress/deflate/README.md) | DEFLATE ([RFC 1951](https://www.rfc-editor.org/rfc/rfc1951)): an encoder and a decoder |
| [`stdx.compress.zlib`](src/compress/zlib/README.md) | The zlib container ([RFC 1950](https://www.rfc-editor.org/rfc/rfc1950)): HTTP's `deflate` coding |
| [`stdx.compress.gzip`](src/compress/gzip/README.md) | The gzip container ([RFC 1952](https://www.rfc-editor.org/rfc/rfc1952)): HTTP's `gzip` coding |
| [`stdx.compress.zstd`](src/compress/zstd/README.md) | Zstandard ([RFC 8878](https://www.rfc-editor.org/rfc/rfc8878), with [RFC 9659](https://www.rfc-editor.org/rfc/rfc9659)'s limits for HTTP): HTTP's `zstd` coding |
| [`stdx.compress.brotli`](src/compress/brotli/README.md) | brotli ([RFC 7932](https://www.rfc-editor.org/rfc/rfc7932)): HTTP's `br` coding |
| [`stdx.hash`](src/hash/README.md) | CRC-32, Adler-32 and XXH64, with SIMD paths that the CPU selects at run time |
| [`stdx.encoding.json`](src/encoding/json/README.md) | JSON ([RFC 8259](https://www.rfc-editor.org/rfc/rfc8259)) with JSON text sequences ([RFC 7464](https://www.rfc-editor.org/rfc/rfc7464)): an encoder and a pull decoder |
| [`stdx.encoding.base64`](src/encoding/base64/README.md) | Base 64 ([RFC 4648](https://www.rfc-editor.org/rfc/rfc4648)): an encoder and a decoder |
| [`stdx.regex`](src/regex/README.md) | Regular expressions in [RFC 9485](https://www.rfc-editor.org/rfc/rfc9485)'s grammar with RE2's syntax, matched in time linear in the text |
| [`stdx.unicode`](src/unicode/README.md) | Unicode 17.0.0's categories, scripts and case folding |
| [`stdx.unicode.utf8`](src/unicode/utf8/README.md) | UTF-8 ([RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)), with a validator proved in Lean |
| [`stdx.platform`](src/platform/README.md) | What the CPU offers, which a program detects once when it starts |
| [`stdx.crypto`](src/crypto/README.md) | chapulin's TLS 1.3, JSON Web Signatures, DNSSEC, SCRAM's calls, and its hashes, HMAC and HKDF, for a dependent that passes `.crypto = true` |
| [`stdx.codec`](src/codec/README.md) | The streaming contract that every codec shares |

## At a glance

| Area | What stdx does |
| --- | --- |
| Memory | No allocator anywhere in `src/`, tests included. Your program owns each state and buffer, and each codec's state has a comptime size. |
| I/O | None. `stdx.platform` reads the CPU with instructions and the auxiliary vector, and makes no system call. |
| Streaming | A call takes any amount of input, writes what fits, and says whether it needs more input, more room, or is done. Each decoder is also a `std.Io.Reader`, and each encoder a `std.Io.Writer`. |
| Output | An encoder writes the same bytes on every host, in every build mode, and for every split of its input. |
| Threads | No global state: run codecs on as many threads as you like. |
| Safety | Assertions stay on in production. Hostile input returns an error value, and the code cites the RFC section behind each refusal. |
| Testing | Differential checks against zlib, Wuffs, libzstd, Google's brotli, Go's regexp and RE2's own test logs. A fuzzer every night. Lean proofs of the UTF-8 validator, of the state machine that reads JSON numbers, and of a model of the regex matcher. |

## Install

Run `zig fetch` to add stdx to your `build.zig.zon`:

```bash
zig fetch --save git+https://github.com/c4milo/stdx#v0.3.0
```

Then import it in `build.zig`:

```zig
const stdx = b.dependency("stdx", .{ .target = target, .release = true });
exe.root_module.addImport("stdx", stdx.module("stdx"));
```

- Zig compiles only the parts that a program uses.
- stdx builds in Debug or ReleaseSafe only, because its assertions stay on
  ([decision 17](docs/decisions.md)). `.release = true` selects ReleaseSafe, and stdx takes no
  `.optimize` option.
- The package exports `stdx` alone. A module's own name, such as `stdx.module("gzip")`, stops
  the build: use `stdx.compress.gzip`.

## Example

Call `stdx.platform.CpuFeatures.detect()` once when the program starts, and pass the result to
each codec and searcher.

```zig
/// Decodes the gzip file `body` into `output`, and returns the decoded octets.
fn gunzip(features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.compress.gzip.Decoder = undefined; // about 43 KiB
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}
```

Each module's README holds its own examples. Every example comes from
[`tools/consumer/`](tools/consumer), a program that `zig build test` builds against this tree and
runs.

## Performance

The benchmarks compare stdx with other libraries on GitHub's hosted runners. Every library of a
row runs in the same job ([decision 20](docs/decisions.md)). On the Arm Neoverse N2 runner:

- [brotli](src/compress/brotli/README.md#performance) decodes faster than Google's decoder on all 39 corpus
  files, at 1.10 to 3.36 times its speed.
- [gzip](src/compress/deflate/README.md#performance) decodes faster than libdeflate on 31 of the 39 files.
- [`json`](src/encoding/json/README.md#performance)'s `TextWriter` writes JSON at 1.64 to 16.35 times
  serde_json's speed.
- [`regex`](src/regex/README.md#performance) was tuned on each set that measures it. On rebar's
  benchmarks outside its curated set it runs 125 of 181 searches faster than Rust's regex crate,
  and 55 slower, the slowest by about 140 times.
- [Zstandard](src/compress/zstd/README.md#performance) decodes slower than libzstd on 25 of the 39 files,
  and libzstd's level 3 is both faster and smaller than stdx's levels 1 and 3.

Each module's README shows its chart. [`docs/benchmarks.md`](docs/benchmarks.md) shows every
chart, lists the counts of each, the losses included, and says how to run each benchmark again.

## Status

stdx is before 1.0, and its releases follow SemVer 2.0.0 ([decision 65](docs/decisions.md)). The
latest release is [0.3.0](https://github.com/c4milo/stdx/releases/tag/v0.3.0). Open work is in
[the issues](https://github.com/c4milo/stdx/issues).

## Development

```bash
zig build test
```

- The differential checks are separate steps, such as `zig build differential-deflate
  -Doracles`. The first build with `-Doracles` fetches about 265 MB of other implementations and
  corpora.
- [`docs/design.md`](docs/design.md) holds the design and the build plan,
  [`docs/decisions.md`](docs/decisions.md) the numbered decisions, and
  [`docs/invariants.md`](docs/invariants.md) the invariants.
- [`docs/performance.md`](docs/performance.md) and [`docs/costs.md`](docs/costs.md) hold the
  performance method and the measured costs.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) summarizes the rules a change keeps, and
  [`CLAUDE.md`](CLAUDE.md) holds all of them, with every build step.
- [`SECURITY.md`](SECURITY.md) says how to report a vulnerability in private.

## License

stdx is licensed under the [Apache License, Version 2.0](LICENSE) (decision 83).
