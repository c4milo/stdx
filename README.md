# stdx

[![main](https://github.com/c4milo/stdx/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/c4milo/stdx/actions/workflows/main.yml?query=branch%3Amain)
[![coverage](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fc4milo%2Fstdx%2Fbadges%2F.github%2Fbadges%2Fcoverage.json)](https://github.com/c4milo/stdx/actions/workflows/main.yml?query=branch%3Amain)
[![license](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![zig](https://img.shields.io/badge/zig-0.16.0-f7a41d.svg)](https://ziglang.org/download/)
[![release](https://img.shields.io/github/v/release/c4milo/stdx)](https://github.com/c4milo/stdx/releases/latest)

Zig's standard library, extended, and grouped as `std` groups its own: compression
(`stdx.compress`: gzip, zlib, DEFLATE, zstd and brotli, each with an encoder and a decoder),
checksums (`stdx.hash`), Unicode (`stdx.unicode`), JSON, base 64, regular expressions, and the CPU
probe a program runs once (`stdx.platform`). All of it is written from the RFCs, uses no
allocator, and does no I/O.

A codec is a struct that your program places where it likes: on the stack, in a static, or inside
its own state. Your program gives it the octets it has and the room it has. The codec writes what
fits, and says whether it needs more input, more room, or is done. Nothing in stdx allocates,
opens a file, starts a thread or reads a clock, so it fits the hot path of a server.

Its benchmarks time stdx beside zlib, zlib-ng, libdeflate, libzstd, Google's brotli, Wuffs,
simdjson, yyjson, serde_json and Go's standard library, in one job on GitHub's x86-64 and aarch64
runners. Each report names the version of each library it times. On the Arm Neoverse N2 runner:

- stdx decodes brotli faster than Google's decoder on all 39 corpus files, at 1.10 to 3.36 times
  its speed.
- stdx decodes gzip faster than libdeflate on 31 of the 39 files.
- No level of zlib, zlib-ng or libdeflate encodes gzip both faster and smaller than any of stdx's
  levels 1, 6 and 9.
- `json`'s `TextWriter` writes JSON at 1.64 to 16.35 times serde_json's speed.

[Performance](#performance) shows every chart, the rows where stdx is slower included.

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
| Testing | Differential checks against zlib, Wuffs, libzstd and Google's brotli over public corpora, and against Go's regexp and RE2's own test logs; a fuzzer every night; and Lean proofs of the UTF-8 and number machines |
| Language | Zig 0.16.0 |
| License | Apache-2.0 |

## Performance

Each chart shows stdx's speed in multiples of a baseline's, the one each panel's title names, in
one job on GitHub's hosted runners (decision 20). A blue bar right of the line at 1 is faster, a
gray bar is inside the noise, and an orange bar is slower. Each encoder's panel plots speed against
compression ratio. The charts come from the first runs on Ubuntu 26.04, at commit 0dd2e97, and
`tools/charts.py` draws them from the reports in [`bench/results/`](bench/results/).

### Regular expressions

`bench-regex` compares the `regex` module with Rust's regex crate 1.13.2, Go's regexp 1.27.4, mvzr
and zig-regex. Six jobs ran it at commit d355d8c on GitHub's hosted runners: three on a Neoverse
N2, and three on x86-64, an AMD EPYC 9V45, an Intel Xeon Platinum 8573C and an AMD EPYC 7763
(`bench/results/2026-11-22-regex-*`). Each number is stdx's speed over Rust's in one job, from the
lowest job to the highest.

- 12 searches have a literal that every match holds. On x86-64, stdx runs 11 of them at 0.93 to
  10.2 of Rust's speed. It runs the search for one of four words at 0.66 to 0.76: Rust's crate
  finds such a set with Teddy, and stdx does not yet. On the N2, stdx runs 7 of them at 0.84 to
  0.97, and 5 at 1.04 to 7.24.
- 6 searches start with a class and hold no literal. stdx runs them at 1.18 to 2.59 on the N2, and
  at 0.96 to 2.39 on x86-64.
- A pattern that validates a short text runs at 1.30 to 1.53 on the N2, and at 1.05 to 1.60 on
  x86-64.
- Six capture groups run at 0.88 to 0.93 on the N2, and at 0.70 to 0.91 on x86-64.
- stdx compiles a pattern at 1.5 to 58 times Rust's speed.
- On each class search, each short-text pattern and the capture groups, stdx is at least 1.66
  times as fast as Go's regexp, 4.1 times as fast as mvzr and 11 times as fast as zig-regex,
  wherever a library gives Go's answer. Go's regexp is faster than stdx on one search: a word that
  is not there, at 0.64 on the N2.

A chart of these numbers waits on two reviews of its method (decision 85).

### Arm Neoverse N2

![gzip decoding, in multiples of libdeflate's speed: ahead on 31, level on 2, behind on 6 of 39 files; 0.92 to 1.71. gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio: no other library's point is both faster and smaller than any of stdx's 3 levels](docs/images/deflate-aarch64.svg)

![Zstandard decoding, in multiples of libzstd's speed: ahead on 11, level on 3, behind on 25 of 39 files; 0.92 to 1.09. Zstandard encoding: speed in multiples of libzstd's level 3, against compression ratio: 2 of stdx's 2 levels have a faster and smaller point: level 1 by libzstd 3; level 3 by libzstd 3](docs/images/zstd-aarch64.svg)

![brotli decoding, in multiples of Google's speed: ahead on 39, level on 0, behind on 0 of 39 files; 1.10 to 3.36. brotli encoding: speed in multiples of Google's quality 5, against compression ratio: no other library's point is both faster and smaller than any of stdx's 2 levels](docs/images/brotli-aarch64.svg)

![JSON decoding, in multiples of simdjson's speed: ahead on 8, level on 0, behind on 1 of 9 rows (of 63 workloads, 1 behind); 0.87 to 5.36. JSON encoding, in multiples of simdjson's speed: ahead on 7, level on 0, behind on 1 of 8 rows (of 62 workloads, 1 behind); 0.80 to 11.18. TextWriter's methods, in multiples of serde_json's speed: ahead on 8, level on 0, behind on 0 of 8 rows (of 62 workloads, 0 behind); 1.64 to 16.35](docs/images/json-aarch64.svg)

![CRC-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 3, level on 0, behind on 1 of 4 sizes; 0.70 to 1.68. Adler-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 2, level on 0, behind on 2 of 4 sizes; 0.69 to 1.31. XXH64 by octets a call, the path the CPU runs, in multiples of libzstd's speed: ahead on 1, level on 2, behind on 1 of 4 sizes; 0.86 to 1.04](docs/images/checksum-aarch64.svg)

![base64 encoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 4, level on 0, behind on 1 of 5 sizes; 0.84 to 1.19. base64 decoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 4, level on 0, behind on 1 of 5 sizes; 0.82 to 1.70](docs/images/base64-aarch64.svg)

<details>
<summary>x86-64: Intel Xeon Platinum 8370C, AMD EPYC 7763 and AMD EPYC 9V45</summary>

![gzip decoding, in multiples of libdeflate's speed: ahead on 22, level on 6, behind on 11 of 39 files; 0.89 to 1.98. gzip encoding: speed in multiples of libdeflate's level 6, against compression ratio: no other library's point is both faster and smaller than any of stdx's 3 levels](docs/images/deflate-x86_64.svg)

![Zstandard decoding, in multiples of libzstd's speed: ahead on 31, level on 4, behind on 4 of 39 files; 0.88 to 1.27. Zstandard encoding: speed in multiples of libzstd's level 3, against compression ratio: 2 of stdx's 2 levels have a faster and smaller point: level 1 by libzstd 3; level 3 by libzstd 3](docs/images/zstd-x86_64.svg)

![brotli decoding, in multiples of Google's speed: ahead on 38, level on 1, behind on 0 of 39 files; 1.03 to 3.32. brotli encoding: speed in multiples of Google's quality 5, against compression ratio: no other library's point is both faster and smaller than any of stdx's 2 levels](docs/images/brotli-x86_64.svg)

![JSON decoding, in multiples of simdjson's speed: ahead on 3, level on 1, behind on 5 of 9 rows (of 63 workloads, 5 behind); 0.63 to 4.09. JSON encoding, in multiples of simdjson's speed: ahead on 5, level on 2, behind on 1 of 8 rows (of 62 workloads, 1 behind); 0.52 to 21.60. TextWriter's methods, in multiples of serde_json's speed: ahead on 8, level on 0, behind on 0 of 8 rows (of 62 workloads, 0 behind); 1.42 to 36.67](docs/images/json-x86_64.svg)

![CRC-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 0, level on 2, behind on 2 of 4 sizes; 0.79 to 1.00. Adler-32 by octets a call, the path the CPU runs, in multiples of libdeflate's speed: ahead on 2, level on 0, behind on 2 of 4 sizes; 0.72 to 1.19. XXH64 by octets a call, the path the CPU runs, in multiples of libzstd's speed: ahead on 0, level on 2, behind on 2 of 4 sizes; 0.82 to 1.00](docs/images/checksum-x86_64.svg)

![base64 encoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 5, level on 0, behind on 0 of 5 sizes; 1.35 to 4.40. base64 decoding by octets a call, in multiples of Rust's base64 crate's speed: ahead on 4, level on 0, behind on 1 of 5 sizes; 0.87 to 5.05](docs/images/base64-x86_64.svg)

</details>

## Status

stdx is before 1.0, and its releases follow SemVer 2.0.0 ([decision 65](docs/decisions.md)). The
latest release is [0.2.0](https://github.com/c4milo/stdx/releases/tag/v0.2.0), and each release's
notes list what changed. Open work is in [the issues](https://github.com/c4milo/stdx/issues).

## Install

Add stdx to your `build.zig.zon`:

```bash
zig fetch --save git+https://github.com/c4milo/stdx#v0.2.0
```

Then import it in `build.zig`:

```zig
const stdx = b.dependency("stdx", .{ .target = target, .release = true });
exe.root_module.addImport("stdx", stdx.module("stdx"));
```

Zig compiles only the parts a program uses. A new dependent imports `stdx` alone.

stdx builds in Debug or ReleaseSafe only, because its assertions stay on
([decision 17](docs/decisions.md)). `.release = true` selects ReleaseSafe. stdx takes no
`.optimize` option, and a program built ReleaseFast still gets stdx in ReleaseSafe.

## Example

Decode a gzip body into a buffer:

```zig
const stdx = @import("stdx");

/// Decodes the gzip file `body` into `output`, and returns the decoded octets.
fn gunzip(features: stdx.codec.Features, body: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.compress.gzip.Decoder = undefined; // about 44 KiB
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}
```

- Call `stdx.codec.Features.detect()` once when the program starts, and pass the result to each
  codec's `init`. It tells the codecs which SIMD instructions the CPU has.
- `decode_all` returns `error.NoSpaceLeft` when `output` fills first, and `error.Truncated` when
  the input ends inside a stream. A corrupt stream returns a `stdx.compress.gzip.Error`, with one
  value for each cause.
- For input that arrives in pieces, call `decode` with each piece. It returns the octets it read
  and wrote, and a status: `needs_input`, `needs_room` or `done`.

## Modules

| Name | What it holds |
|---|---|
| `stdx.compress.deflate` | DEFLATE, RFC 1951: an encoder and a decoder |
| `stdx.compress.zlib` | The zlib container, RFC 1950: the HTTP `deflate` coding |
| `stdx.compress.gzip` | The gzip container, RFC 1952: the HTTP `gzip` coding |
| `stdx.compress.zstd` | Zstandard, RFC 8878 and RFC 9659: the HTTP `zstd` coding |
| `stdx.compress.brotli` | brotli, RFC 7932: the HTTP `br` coding |
| `stdx.hash` | CRC-32, Adler-32 and XXH64 |
| `stdx.unicode` | Unicode 17.0.0's general categories, scripts and simple case folding, from tables written from the Unicode Character Database (decision 86) |
| `stdx.unicode.utf8` | UTF-8, RFC 3629: a validator proved in Lean, and the octets of one code point (decisions 28 and 86) |
| `stdx.json` | JSON, RFC 8259 and RFC 7464: an encoder, a pull decoder, and text sequences (decision 27) |
| `stdx.base64` | Base 64, RFC 4648: an encoder and a decoder (decision 68) |
| `stdx.regex` | Regular expressions matched in time linear in the text: RFC 9485's grammar with RE2's anchors, groups, named groups, flags and named classes, Unicode's properties and its case folding (decision 86) |
| `stdx.platform` | What the CPU offers, probed once when a program starts (decision 40), and a vector `memset` (decision 41) |
| `stdx.codec` | The streaming contract every codec shares, and `Features` (decision 11) |

The modules' own names, such as `stdx.module("gzip")`, stay exported as aliases while the
projects that import them move to `stdx`, and a later release removes them. A new dependent does
not use them.

`stdx.platform` is the one module that may make a system call: `sysctlbyname` on macOS.

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
- [`CONTRIBUTING.md`](CONTRIBUTING.md) summarizes the rules a change keeps, and
  [`CLAUDE.md`](CLAUDE.md) holds all of them.
- [`SECURITY.md`](SECURITY.md) says how to report a vulnerability in private.

## License

stdx is licensed under the [Apache License, Version 2.0](LICENSE) (decision 83).
