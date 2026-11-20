# stdx

Compression and data codecs for Zig 0.16, written from the RFCs. They use no heap and do no I/O.

- **Compression:** DEFLATE with its zlib and gzip containers (RFC 1951, 1950 and 1952), Zstandard
  (RFC 8878, with RFC 9659's limits for HTTP) and brotli (RFC 7932). These are the HTTP content
  codings `deflate`, `gzip`, `zstd` and `br`.
- **Data:** JSON (RFC 8259) with JSON text sequences (RFC 7464), and base 64 (RFC 4648).
- **Support:** CRC-32, Adler-32 and XXH64, and a probe of what the CPU offers.

Each codec has an encoder and a decoder.

## Properties

- **No I/O.** A codec reads octets the caller already has, and writes into storage the caller
  owns.
- **No heap.** The caller owns every state, window and table. Each size is a comptime constant, so
  a codec can live on the stack, in a static, or inside another struct.
- **Streaming.** A call takes the input there is and writes what fits. It then says whether it
  needs more input, needs more room, or is done, and the next call continues. A whole-buffer
  helper calls it for you.
- **Deterministic.** An encoder's output depends on its input and its options alone. It is the
  same on every host, in every build mode, and for every split of the input and the output across
  calls.
- **No global state.** A program can run codecs on as many threads as it likes.
- **Checked.** Assertions stay on in production builds, for programmer error only. Hostile input
  returns an error value and never reaches an assertion. The code cites the RFC section behind
  each refusal.
- **Tested against other implementations.** Differential checks compare stdx with zlib, Wuffs,
  libzstd and Google's brotli over public corpora, and a fuzzer runs every night.

## Status

The current release is 0.2.0. Releases follow SemVer 2.0.0
([decision 65](docs/decisions.md)).

- Each codec has its decoder. The Zstandard decoder refuses a window larger than RFC 9659 allows
  for HTTP.
- The encoders offer these levels: DEFLATE 1, 6 and 9 in all three containers, Zstandard 1 and 3,
  and brotli 1 and 5.
- Each codec offers its decoder as a `std.Io.Reader` and its encoder as a `std.Io.Writer`.

Open work is in [the issues](https://github.com/c4milo/stdx/issues).

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
