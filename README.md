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
and zig-regex. Eighteen runs on GitHub's hosted runners ran it at commit 8dc8c1d
(`bench/results/2026-11-23-regex-literals-*`). This section reads the 18 jobs on a Neoverse N2, and
the 10 of 18 x86-64 jobs on an AMD EPYC 7763, the model that the most jobs drew. Each number is
stdx's speed over Rust's in one job, from the lowest job to the highest.

- 6 searches look for a literal. On the N2, stdx runs 1 of them at 0.98 to 1.01, and 5 at 1.04 to
  3.84. On the EPYC 7763, it runs all 6 at 1.06 to 3.33.
- 5 searches start with a class. stdx runs them at 1.04 to 2.40 on the N2. On the EPYC 7763, it
  runs 1 at 0.97 to 1.01, and 4 at 1.04 to 1.90.
- 7 searches have other shapes. On the N2, stdx runs all 7 at 1.05 to 8.34. On the EPYC 7763, it
  runs 1 at 1.00 to 1.04, and 6 at 1.03 to 10.02.
- A pattern that validates a short text runs at 0.93 to 1.37 on the N2, and at 0.94 to 1.53 on the
  EPYC 7763. The email address and the field path run at 0.93 to 0.95 on the N2, where they ran
  at about 1.00 at commit a281f4c. Commit 49aaef7, after these runs, restores the scan they lost
  (design §8 part 22n).
- Six capture groups run at 0.94 to 0.98 on the N2, and at 0.78 to 0.83 on the EPYC 7763.
- In the median job, stdx compiles each pattern at 1.23 to 28 times Rust's speed on the N2, and at
  1.20 to 27 times on the EPYC 7763.
- Outside compile, Go's regexp is faster than stdx on one search: a word that is not there, at
  0.73 to 0.77 on the N2. stdx is at least 4.0 times as fast as mvzr and 11.8 times as fast as
  zig-regex, wherever a library gives Go's answer.

The people who tuned stdx chose these patterns, so they can favor it. The charts below draw these
jobs by decision 85's rules: a bar is the median job, and its whisker an interval of that median.

![stdx's regular expressions against libraries in Rust, Go and Zig, on Neoverse-N2](docs/images/regex-aarch64.svg)

<details>
<summary>x86-64: AMD EPYC 7763 64-Core Processor</summary>

![stdx's regular expressions against libraries in Rust, Go and Zig, on AMD EPYC 7763 64-Core Processor](docs/images/regex-x86_64.svg)

</details>

#### rebar's curated set

The same runs time every benchmark of rebar's curated set whose engines name Go's regexp or RE2:
31 searches and 10 compiles, each under rebar's own model, pattern and haystack. Nobody who tuned
stdx chose them ([#44](https://github.com/c4milo/stdx/issues/44)). Design §8 part 22n then counted
every row and changed stdx by what they showed: claims R9 and R10 and the size of the cache came
from these rows. So this set is tuned now, as the tables above are, and it no longer shows how stdx
runs on patterns its tuning did not see. rebar's author also wrote Rust's crate, and rebar's
BIAS.md says the set may favor it.

- On the N2, stdx runs 24 of the 31 searches at 1.03 to 6.46, 2 at 1.00 to 1.06, and 5 at 0.82 to
  0.99.
- On the EPYC 7763, it runs 25 at 1.03 to 5.36, 2 at 0.99 to 1.03, and 4 at 0.81 to 0.97.
- The rows furthest behind: on the N2, the AWS key searches at 0.82 to 0.98 and ruff's noqa
  comments at 0.84 to 0.88; on the EPYC 7763, the lexer of the Veryl language at 0.81 to 0.85,
  and a log line turned into JSON at 0.88 to 0.92.
- stdx compiles all 10 patterns at 1.19 to 10.3 times Rust's speed on the N2. On the EPYC 7763 it
  compiles 9 at 1.91 to 8.35 times, and the context pattern at 0.89 to 0.90.
- Go's regexp is faster than stdx on no search of the set, on either model.

![stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, on Neoverse-N2](docs/images/regex-rebar-aarch64.svg)

<details>
<summary>x86-64: AMD EPYC 7763 64-Core Processor</summary>

![stdx's regular expressions on rebar's curated set against Rust's regex and Go's regexp, on AMD EPYC 7763 64-Core Processor](docs/images/regex-rebar-x86_64.svg)

</details>

### Arm Neoverse N2

![stdx's DEFLATE against its baselines, on Neoverse-N2](docs/images/deflate-aarch64.svg)

![stdx's Zstandard against its baselines, on Neoverse-N2](docs/images/zstd-aarch64.svg)

![stdx's brotli against its baselines, on Neoverse-N2](docs/images/brotli-aarch64.svg)

![stdx's JSON against its baselines, on Neoverse-N2](docs/images/json-aarch64.svg)

![stdx's checksums against its baselines, on Neoverse-N2](docs/images/checksum-aarch64.svg)

![stdx's base64 against its baselines, on Neoverse-N2](docs/images/base64-aarch64.svg)

<details>
<summary>x86-64: Intel Xeon Platinum 8370C, AMD EPYC 7763 and AMD EPYC 9V45</summary>

![stdx's DEFLATE against its baselines, on Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz](docs/images/deflate-x86_64.svg)

![stdx's Zstandard against its baselines, on Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz](docs/images/zstd-x86_64.svg)

![stdx's brotli against its baselines, on AMD EPYC 7763 64-Core Processor](docs/images/brotli-x86_64.svg)

![stdx's JSON against its baselines, on AMD EPYC 9V45 96-Core Processor](docs/images/json-x86_64.svg)

![stdx's checksums against its baselines, on AMD EPYC 7763 64-Core Processor](docs/images/checksum-x86_64.svg)

![stdx's base64 against its baselines, on AMD EPYC 7763 64-Core Processor](docs/images/base64-x86_64.svg)

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
