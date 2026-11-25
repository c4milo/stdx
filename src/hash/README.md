# stdx.hash

`stdx.hash` holds the three checksums that the compression formats carry. Its folder is
`src/hash`.

- CRC-32, the check of a gzip member ([RFC 1952](https://www.rfc-editor.org/rfc/rfc1952) §8).
- Adler-32, the check of a zlib stream ([RFC 1950](https://www.rfc-editor.org/rfc/rfc1950) §9).
- XXH64, whose low 32 bits are the checksum of a Zstandard frame
  ([RFC 8878](https://www.rfc-editor.org/rfc/rfc8878) §3.1.1).

## Use

```zig
/// The CRC-32 of `bytes`, by the fastest path that the CPU runs.
fn crc32_of(features: stdx.platform.CpuFeatures, bytes: []const u8) u32 {
    const path = stdx.hash.Crc32Path.fastest(stdx.hash.Features.from(features));
    return stdx.hash.crc32(path, 0, bytes);
}
```

Each example is an excerpt of [`tools/consumer/main.zig`](../../tools/consumer/main.zig), a program
that `zig build test` builds against this tree and runs.

## What it holds

- `crc32(path, crc, bytes)` and `adler32(path, adler, bytes)`: the checksum after the bytes, from
  the checksum before them. A program feeds a text in pieces this way.
- `xxh64(path, seed, bytes)`: the hash of one buffer. `Xxh64` is the state of a hash that a
  program feeds in pieces.
- `Crc32Path`, `Adler32Path` and `Xxh64Path`: the paths of each checksum. Each has a path that
  runs on every CPU, and faster paths for the instructions that an x86-64 or aarch64 CPU has.
- `fastest`: the fastest path that a CPU runs. A program chooses the path once for each stream.
- `Features`: the CPU features that the paths read. `Features.from` copies them out of a
  `stdx.platform.CpuFeatures`.

## Performance

One job, from the first runs on Ubuntu 26.04, at commit 0dd2e97. A blue bar is ahead, a gray bar is
level inside the noise, and an orange bar is behind. An encoder's panel plots speed against
compression ratio. [`docs/benchmarks.md`](../../docs/benchmarks.md#checksums) lists the counts of each panel, and
says how to run the benchmark again.

![stdx's checksums against its baselines, on Neoverse-N2](../../docs/images/checksum-aarch64.svg)

<details>
<summary>x86-64: AMD EPYC 7763</summary>

![stdx's checksums against its baselines, on AMD EPYC 7763 64-Core Processor](../../docs/images/checksum-x86_64.svg)

</details>
