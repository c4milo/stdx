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

The chart is the latest release's: one job on each of GitHub's runners, which the `bench` workflow
runs on each release tag. A blue bar is ahead, a gray bar is level inside the noise, and an orange
bar is behind. A green ▲ or a red ▼ after a row's name marks a row 5% or more faster or
slower than at the previous release, where both ran on one CPU model.
[The page of the branch `charts`](https://github.com/c4milo/stdx/blob/charts/benchmarks.md) lists the counts of each panel, and
[`docs/benchmarks.md`](../../docs/benchmarks.md#checksums) says how to read the chart and run the
benchmark again.

![stdx's checksums against its baselines, at the latest release, on GitHub's Arm Neoverse N2 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/checksum-aarch64.svg)

<details>
<summary>x86-64: the CPU model of the release's job</summary>

![stdx's checksums against its baselines, at the latest release, on GitHub's x86-64 runner](https://raw.githubusercontent.com/c4milo/stdx/charts/checksum-x86_64.svg)

</details>
