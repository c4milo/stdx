# stdx

[![main](https://github.com/c4milo/stdx/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/c4milo/stdx/actions/workflows/main.yml?query=branch%3Amain)
[![coverage](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fc4milo%2Fstdx%2Fbadges%2F.github%2Fbadges%2Fcoverage.json)](https://github.com/c4milo/stdx/actions/workflows/main.yml?query=branch%3Amain)
[![license](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![zig](https://img.shields.io/badge/zig-0.16.0-f7a41d.svg)](https://ziglang.org/download/)
[![release](https://img.shields.io/github/v/release/c4milo/stdx)](https://github.com/c4milo/stdx/releases/latest)

stdx extends Zig's standard library. It groups its modules as `std` groups its own:

- `stdx.compress`: gzip, zlib, DEFLATE, Zstandard and brotli, each with an encoder and a decoder.
- `stdx.hash`: CRC-32, Adler-32 and XXH64.
- `stdx.json` and `stdx.base64`.
- `stdx.regex`: regular expressions that match in time linear in the text.
- `stdx.unicode`: Unicode 17.0.0's categories, scripts and case folding, and UTF-8.
- `stdx.platform`: what the CPU offers, which a program probes once when it starts.

Each module is written from its RFC, or from the specification that it names. stdx allocates no
memory and does no I/O. The one exception is the probe of `stdx.platform`, which makes one system
call on macOS.

A codec is a struct that your program places where it likes: on the stack, in a static, or inside
its own state. Your program gives it the octets it has and the room it has. The codec writes what
fits, and says whether it needs more input, more room, or is done. Nothing in stdx allocates,
opens a file, starts a thread or reads a clock, so it fits the hot path of a server.

On GitHub's Arm Neoverse N2 runner:

- stdx decodes brotli faster than Google's decoder on all 39 corpus files, at 1.10 to 3.36 times
  its speed.
- stdx decodes gzip faster than libdeflate on 31 of the 39 files.
- No level of zlib, zlib-ng or libdeflate encodes gzip both faster and smaller than any of stdx's
  levels 1, 6 and 9.
- `json`'s `TextWriter` writes JSON at 1.64 to 16.35 times serde_json's speed.
- On rebar's benchmarks that no tuning of stdx saw, `regex` runs 88 of 181 searches faster than
  Rust's regex crate on the N2, and 90 slower. The slowest is about 24,000 times slower. It
  compiles all 15 patterns faster. On the two sets that stdx was tuned on, it runs 17 of 18
  searches faster, and 25 of 31.
- stdx decodes Zstandard slower than libzstd on 25 of the 39 files. libzstd's level 3 is both
  faster and smaller than stdx's levels 1 and 3.

[Performance](#performance) shows every chart. [`docs/benchmarks.md`](docs/benchmarks.md) lists
the counts of each chart, the losses included.

## At a glance

| Area | What stdx does |
| --- | --- |
| Compression | gzip, zlib and raw DEFLATE ([RFC 1952](https://www.rfc-editor.org/rfc/rfc1952), [1950](https://www.rfc-editor.org/rfc/rfc1950), [1951](https://www.rfc-editor.org/rfc/rfc1951)), Zstandard ([RFC 8878](https://www.rfc-editor.org/rfc/rfc8878), with [RFC 9659](https://www.rfc-editor.org/rfc/rfc9659)'s limits for HTTP) and brotli ([RFC 7932](https://www.rfc-editor.org/rfc/rfc7932)) |
| Encoder levels | DEFLATE 1, 6 and 9 in all three containers, Zstandard 1 and 3, brotli 1 and 5 |
| Data | JSON ([RFC 8259](https://www.rfc-editor.org/rfc/rfc8259)) with JSON text sequences ([RFC 7464](https://www.rfc-editor.org/rfc/rfc7464)), and base 64 ([RFC 4648](https://www.rfc-editor.org/rfc/rfc4648)) |
| Text | Regular expressions in [RFC 9485](https://www.rfc-editor.org/rfc/rfc9485)'s grammar with RE2's syntax, matched in time linear in the text; Unicode 17.0.0's categories, scripts and case folding; UTF-8 ([RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)) |
| Checksums | CRC-32, Adler-32 and XXH64, with SIMD paths for x86-64 and aarch64 that the CPU selects at run time |
| Memory | No allocator anywhere in `src/`, tests included. Each codec's state has a comptime size, and a regex searcher takes the memory that its program needs. |
| I/O | None. A codec reads octets your program already has, and writes into storage that it owns. The probe of `stdx.platform` makes one system call on macOS. |
| Streaming | Each codec call takes any amount of input and resumes where the last one stopped. Each decoder is also a `std.Io.Reader`, and each encoder a `std.Io.Writer`. |
| Output | An encoder writes the same octets on every host, in every build mode, and for every split of its input across calls. |
| Threads | No global state: run codecs on as many threads as you like. |
| Safety | Assertions stay on in production. Hostile input returns an error value, and the code cites the RFC section behind each refusal. |
| Testing | Differential checks against zlib, Wuffs, libzstd and Google's brotli over public corpora, and against Go's regexp and RE2's own test logs. A fuzzer every night. Lean proofs of the UTF-8 validator, of the state machine that reads JSON numbers, and of how regex cuts a range of code points into UTF-8. |
| Language | Zig 0.16.0 |
| License | Apache-2.0 |

## Status

stdx is before 1.0, and its releases follow SemVer 2.0.0 ([decision 65](docs/decisions.md)). The
latest release is [0.3.0](https://github.com/c4milo/stdx/releases/tag/v0.3.0), and each release's
notes list what changed. Open work is in [the issues](https://github.com/c4milo/stdx/issues).

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

Zig compiles only the parts that a program uses.

stdx builds in Debug or ReleaseSafe only, because its assertions stay on
([decision 17](docs/decisions.md)). `.release = true` selects ReleaseSafe. stdx takes no
`.optimize` option, and a program built ReleaseFast still gets stdx in ReleaseSafe.

## Examples

Both examples come from [`tools/consumer/`](tools/consumer/), a program that `zig build test`
builds against this tree and runs.

Call `stdx.platform.CpuFeatures.detect()` once when the program starts, and pass the result to
each codec and searcher. It tells them which SIMD instructions the CPU has.

### Decode gzip

```zig
const stdx = @import("stdx");

/// Decodes the gzip file `body` into `output`, and returns the decoded octets.
fn gunzip(features: stdx.platform.CpuFeatures, body: []const u8, output: []u8) ![]u8 {
    var decoder: stdx.compress.gzip.Decoder = undefined; // about 44 KiB
    decoder.init(features);
    const whole = try decoder.decode_all(body, output);
    return output[0..whole.written];
}
```

- `decode_all` returns `error.NoSpaceLeft` when `output` fills first, and `error.Truncated` when
  the input ends inside a stream. A corrupt stream returns a `stdx.compress.gzip.Error`, with one
  value for each cause.
- For input that arrives in pieces, call `decode` with each piece. It returns the octets it read
  and wrote, and a status: `needs_input`, `needs_room` or `done`.

### Count the matches of a regular expression

```zig
const std = @import("std");
const stdx = @import("stdx");

/// The instructions a pattern of the regex example may take.
const instructions_len = 256;

/// Counts the matches of `pattern` in `haystack`. The program gives the searcher its memory: 4 MiB
/// of it is the default cache, and a smaller cache costs speed, never an answer.
fn count_matches(gpa: std.mem.Allocator, features: stdx.platform.CpuFeatures, pattern: []const u8, haystack: []const u8) !u64 {
    var storage: [instructions_len]stdx.regex.Instruction = undefined;
    const program = try stdx.regex.compile(pattern, .{}, &storage);
    const cache_words = stdx.regex.constants.cache_words_default;
    const memory = try gpa.alloc(u64, stdx.regex.Searcher.memory_len(program.forward_len, program.slot_count(), cache_words));
    defer gpa.free(memory);
    var searcher: stdx.regex.Searcher = undefined;
    searcher.init(&program, &.{ .features = features }, memory);
    var matches: stdx.regex.Matches = .{ .searcher = &searcher, .haystack = haystack };
    return matches.count();
}
```

- `compile` writes the pattern's program into `storage`. It returns a `stdx.regex.Error` for a
  pattern it refuses, with one value for each cause.
- The program reads `storage`, and the searcher reads `memory`. Keep both while the searcher runs.
- `Matches.next` gives each match's span in turn, and `count` counts the matches. A searcher also
  has `find`, `is_match` and `captures`.
- The syntax is RE2's, less the forms that need a backtracking matcher
  ([decision 86](docs/decisions.md)).

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
| `stdx.regex` | Regular expressions matched in time linear in the text, in UTF-8 or in bytes: RFC 9485's grammar with RE2's anchors, groups, named groups, flags and named classes, Unicode's properties and its case folding (decision 86) |
| `stdx.platform` | What the CPU offers, read once when a program starts: `probe`'s answers (decision 40), and `CpuFeatures`, which each codec takes (decision 21); and a vector `memset` (decision 41) |
| `stdx.codec` | The streaming contract every codec shares (decision 11) |

The modules' own names, such as `stdx.module("gzip")`, stay exported as aliases while the
projects that import them move to `stdx`, and a later release removes them. A new dependent
imports `stdx` alone.

## Performance

The charts compare stdx with other libraries on GitHub's hosted runners. Every library of a row
runs in the same job ([decision 20](docs/decisions.md)). [`docs/benchmarks.md`](docs/benchmarks.md)
says how to read each chart, lists the counts of each panel, and says how to run each benchmark
again.

### Regular expressions

The median of 18 runs at commit 1df5f9f, against Rust's regex crate 1.13.2 and Go's regexp. The
rows are rebar's benchmarks outside its curated set and its tests, whose engines name Go's regexp
or RE2: 197 of them, each under rebar's own model, pattern and haystack. No work on stdx timed them
or chose a constant with them ([decision 86](docs/decisions.md)).

One change was made for one of these rows: the bytes mode, for the answer of
`unicode/compile/match-every-line-ascii`. It was judged on that answer and on no speed. stdx now
runs each benchmark that leaves `unicode` off in bytes, as Rust's crate runs it.

![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, on Neoverse-N2](docs/images/regex-rebar-others-aarch64.svg)

<details>
<summary>x86-64: AMD EPYC 9V45 96-Core Processor</summary>

![stdx's regular expressions on rebar's other benchmarks against Rust's regex and Go's regexp, on AMD EPYC 9V45 96-Core Processor](docs/images/regex-rebar-others-x86_64.svg)

</details>

[`docs/benchmarks.md`](docs/benchmarks.md#regular-expressions) holds two more charts from the same
runs: the patterns written for this benchmark, and rebar's curated set. stdx was tuned on both.

### Compression, JSON, checksums and base 64

One job each, from the first runs on Ubuntu 26.04, at commit 0dd2e97. A blue bar is ahead, a gray
bar is level inside the noise, and an orange bar is behind. An encoder's panel plots speed against
compression ratio.

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
  performance method and the measured costs. [`docs/benchmarks.md`](docs/benchmarks.md) holds
  the counts of each chart.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) summarizes the rules a change keeps, and
  [`CLAUDE.md`](CLAUDE.md) holds all of them.
- [`SECURITY.md`](SECURITY.md) says how to report a vulnerability in private.

## License

stdx is licensed under the [Apache License, Version 2.0](LICENSE) (decision 83).
