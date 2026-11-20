# stdx

[![main](https://github.com/c4milo/stdx/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/c4milo/stdx/actions/workflows/main.yml?query=branch%3Amain)
[![license](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![zig](https://img.shields.io/badge/zig-0.16.0-f7a41d.svg)](https://ziglang.org/download/)
[![release](https://img.shields.io/github/v/release/c4milo/stdx)](https://github.com/c4milo/stdx/releases/latest)

The HTTP content codings in wide use, for Zig, each with an encoder and a decoder: `gzip`,
`deflate`, `br` and `zstd`. Beside them are JSON and base 64. All of it is written from the RFCs,
uses no allocator, and does no I/O.

A codec is a struct that your program places where it likes: on the stack, in a static, or inside
its own state. Your program gives it the octets it has and the room it has. The codec writes what
fits, and says whether it needs more input, more room, or is done. Nothing in stdx allocates,
opens a file, starts a thread or reads a clock, so it fits the hot path of a server.

Its benchmarks time stdx beside zlib, zlib-ng, libdeflate, libzstd, Google's brotli, Wuffs,
simdjson, yyjson, serde_json and Go's standard library, in one job on GitHub's x86-64 and aarch64
runners. Each report names the version of each library it times.

## At a glance

| | |
| --- | --- |
| Compression | gzip, zlib and raw DEFLATE ([RFC 1952](https://www.rfc-editor.org/rfc/rfc1952), [1950](https://www.rfc-editor.org/rfc/rfc1950), [1951](https://www.rfc-editor.org/rfc/rfc1951)), Zstandard ([RFC 8878](https://www.rfc-editor.org/rfc/rfc8878), with [RFC 9659](https://www.rfc-editor.org/rfc/rfc9659)'s limits for HTTP) and brotli ([RFC 7932](https://www.rfc-editor.org/rfc/rfc7932)) |
| Encoder levels | DEFLATE 1, 6 and 9 in all three containers, Zstandard 1 and 3, brotli 1 and 5 |
| Data | JSON ([RFC 8259](https://www.rfc-editor.org/rfc/rfc8259)) with JSON text sequences ([RFC 7464](https://www.rfc-editor.org/rfc/rfc7464)), and base 64 ([RFC 4648](https://www.rfc-editor.org/rfc/rfc4648)) |
| Checksums | CRC-32, Adler-32 and XXH64, with SIMD paths for x86-64 and aarch64 that the CPU selects at run time |
| Memory | No allocator anywhere in `src/`, tests included. Each state's size is a comptime constant. |
| I/O | None. A codec reads octets your program already has and writes into storage it owns. |
| Streaming | Every call takes any amount of input and resumes where the last one stopped. Each decoder is also a `std.Io.Reader`, and each encoder a `std.Io.Writer`. |
| Output | An encoder writes the same octets on every host, in every build mode, and for every split of its input across calls. |
| Threads | No global state: run codecs on as many threads as you like. |
| Safety | Assertions stay on in production. Hostile input returns an error value, and the code cites the RFC section behind each refusal. |
| Testing | Differential checks against zlib, Wuffs, libzstd and Google's brotli over public corpora, a fuzzer every night, and Lean proofs of JSON's UTF-8 and number machines |
| Language | Zig 0.16.0 |
| License | Apache-2.0 |

## Status

stdx is before 1.0, and its releases follow SemVer 2.0.0 ([decision 65](docs/decisions.md)). The
latest release is [0.2.0](https://github.com/c4milo/stdx/releases/tag/v0.2.0), and each release's
notes list what changed. Open work is in [the issues](https://github.com/c4milo/stdx/issues).

## Install

Add stdx to your `build.zig.zon`:

```bash
zig fetch --save git+https://github.com/c4milo/stdx#v0.2.0
```

Then import the modules your program uses in `build.zig`:

```zig
const stdx = b.dependency("stdx", .{ .target = target, .release = true });
exe.root_module.addImport("codec", stdx.module("codec"));
exe.root_module.addImport("gzip", stdx.module("gzip"));
```

Each module is separate, so a program compiles only the codecs it imports.

stdx builds in Debug or ReleaseSafe only, because its assertions stay on
([decision 17](docs/decisions.md)). `.release = true` selects ReleaseSafe. stdx takes no
`.optimize` option, and a program built ReleaseFast still gets stdx in ReleaseSafe.

## Example

Decode a gzip body into a buffer:

```zig
const codec = @import("codec");
const gzip = @import("gzip");

/// Decodes the gzip file `body` into `output`, and returns the decoded octets.
fn gunzip(features: codec.Features, body: []const u8, output: []u8) ![]u8 {
    var decoder: gzip.Decoder = undefined; // about 44 KiB
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}
```

- Call `codec.Features.detect()` once when the program starts, and pass the result to each
  codec's `init`. It tells the codecs which SIMD instructions the CPU has.
- `decode_all` returns `error.NoSpaceLeft` when `output` fills first, and `error.Truncated` when
  the input ends inside a stream. A corrupt stream returns a `gzip.Error`, with one value for each
  cause.
- For input that arrives in pieces, call `decode` with each piece. It returns the octets it read
  and wrote, and a status: `needs_input`, `needs_room` or `done`.

## Modules

| Module | What it holds |
|---|---|
| `codec` | The streaming contract every codec shares, and `Features` (decision 11) |
| `checksum` | CRC-32, Adler-32 and XXH64 |
| `deflate` | DEFLATE, RFC 1951: an encoder and a decoder |
| `zlib` | The zlib container, RFC 1950: the HTTP `deflate` coding |
| `gzip` | The gzip container, RFC 1952: the HTTP `gzip` coding |
| `zstd` | Zstandard, RFC 8878 and RFC 9659: the HTTP `zstd` coding |
| `brotli` | brotli, RFC 7932: the HTTP `br` coding |
| `json` | JSON, RFC 8259 and RFC 7464: an encoder, a pull decoder, and text sequences (decision 27) |
| `base64` | Base 64, RFC 4648: an encoder and a decoder (decision 68) |
| `platform` | What the CPU offers, probed once when a program starts (decision 40) |

`platform` is the one module that may make a system call: `sysctlbyname` on macOS.

## Development

```bash
zig build test
```

- The differential checks are separate steps, such as `zig build differential-deflate
  -Doracles`. The first build with `-Doracles` fetches about 265 MB of other implementations and
  corpora. [`CLAUDE.md`](CLAUDE.md) lists every step.
- [`docs/design.md`](docs/design.md) holds the design and the build plan, and
  [`docs/decisions.md`](docs/decisions.md) the numbered decisions.
- [`docs/invariants.md`](docs/invariants.md) holds the invariants, each with the check that
  proves it.
- [`docs/performance.md`](docs/performance.md) and [`docs/costs.md`](docs/costs.md) hold the
  performance method and the measured costs.
- [`CLAUDE.md`](CLAUDE.md) holds the rules every change follows.

## License

stdx is licensed under the [Apache License, Version 2.0](LICENSE) (decision 83).
