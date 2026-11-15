# stdx

Compression codecs in Zig 0.16, written from the RFCs: DEFLATE with its zlib and gzip containers
(RFC 1951, 1950 and 1952), Zstandard (RFC 8878 and RFC 9659) and brotli (RFC 7932). Beside them, a
JSON encoder and decoder (RFC 8259) with JSON text sequences (RFC 7464), and RFC 4648's base 64.
Each has an encoder and a decoder. Each one:

- performs no I/O: it reads octets the caller already has and writes into storage the caller
  owns;
- uses no heap: the caller owns every state, window and table, and each size is a comptime
  constant;
- streams and resumes: a call takes what input there is, writes what fits, and says whether it
  needs more input, needs more room, or is done;
- is deterministic: an encoder's output depends on its input and its parameters alone.

0.1.0 is the first release (decision 65). Every module below is written and tested:

- the decoder of each codec;
- the encoders at the levels decision 13 sets: DEFLATE at levels 1, 6 and 9 in all three
  containers, Zstandard at levels 1 and 3, and brotli at levels 1 and 5;
- each codec's decoder behind `std.Io.Reader` and its encoder behind `std.Io.Writer` (decision 56).

The owner's rulings are in [docs/decisions.md](docs/decisions.md), and the build plan is
[docs/design.md](docs/design.md) §8. Open work is tracked in
[the issues](https://github.com/c4milo/stdx/issues).

## Modules

Each module is exported by name, so a project that depends on stdx imports it with
`dependency.module("gzip")`.

| Module | What it holds |
|---|---|
| `codec` | The streaming contract every codec shares (decision 11) |
| `checksum` | CRC-32, Adler-32 and XXH64 |
| `deflate` | RFC 1951 |
| `zlib` | RFC 1950, the HTTP `deflate` coding |
| `gzip` | RFC 1952, the HTTP `gzip` coding |
| `zstd` | RFC 8878 and RFC 9659, the HTTP `zstd` coding |
| `brotli` | RFC 7932, the HTTP `br` coding |
| `json` | RFC 8259 and RFC 7464: a JSON encoder, a pull decoder, and text sequences (decision 27) |
| `base64` | RFC 4648's base 64: an encoder and a decoder (decision 68) |
| `platform` | What the CPU offers, probed once when a program starts: the one module that makes a syscall (decision 40) |

## Building

```bash
zig build test
```

`CLAUDE.md` holds the rules every change follows.
