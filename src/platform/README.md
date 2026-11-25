# stdx.platform

`stdx.platform` says what the CPU offers. A program reads it once when it starts
([decision 40](../../docs/decisions.md)).

## Use

```zig
const features = stdx.platform.CpuFeatures.detect();
```

Pass the value to each codec's `init`, to each searcher's options and to
[`stdx.crypto`](../crypto/README.md)'s `init`. It tells them which instructions the CPU has. stdx
keeps no copy of it, and no codec probes the CPU.

## What it holds

- `CpuFeatures.detect()`: the features that the fast paths of the codecs read
  ([decision 21](../../docs/decisions.md)), and the instructions that `stdx.crypto` runs: `aes`,
  `sha256`, `sha512`, `sha3`, `sve2`, `dit` and `vaes`, beside `pclmul`, `pmull` and `avx2`. Each
  field is true where the CPU has the feature and false where it lacks it or nothing says. Detection
  makes no system call.
- `probe()`: a `Cpu`, the same instructions as `yes`, `no` or `not_known` answers. `CpuFeatures`
  holds each of them, and `probe` stays until the programs that read a `Cpu` read `CpuFeatures`
  instead.
- `data_independent_timing(features)`: whether the calling thread's timing is data-independent.
  On arm64 it is PSTATE.DIT, and false on a core whose features hold no FEAT_DIT. On x86-64 it is
  false, because only the operating system reads DOITM.
- `set_data_independent_timing(features, enabled)`: sets or clears the calling thread's PSTATE.DIT
  on arm64, and returns true. It returns false on x86-64, on another architecture, and on a core
  whose features hold no FEAT_DIT. A program calls it on each thread that runs code whose timing
  must not depend on a secret, such as `stdx.crypto`'s.
- `memset`: a vector `memset` that a program may export from its root on Linux under Zig 0.16,
  where `memset_applies` holds ([decision 41](../../docs/decisions.md)).

## The one system call

`probe` is the one call in stdx that may make a system call, because a program makes it once and
no codec path runs it:

- x86-64: CPUID and XGETBV. No system call.
- aarch64 Linux: the auxiliary vector, through `getauxval`. No system call.
- aarch64 macOS: `sysctlbyname`, a system call for each feature.

`probe` only reads. It changes no CPU state. `data_independent_timing` and
`set_data_independent_timing` make no system call: each runs one instruction on arm64, `mrs` or
`msr` of the register DIT, and acts on the calling thread alone. Each takes the program's
`CpuFeatures`, because that instruction faults on a core without FEAT_DIT. No library code calls
either one.
