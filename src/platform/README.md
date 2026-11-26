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
  `sha256`, `sha512`, `sha3`, `sve2`, `dit` and `vaes`, beside `pclmul`, `pmull`, `ssse3`,
  `sse4_1` and `avx2`. Each of these fields is true where the CPU has the feature and false where
  it lacks it or nothing says. Detection makes no system call.
- `CpuFeatures.midr`: a `Midr`, the fields of MIDR_EL1 of the aarch64 core that detection ran
  on. A program tells one core from another by its implementer and part, as `stdx.crypto` tells an
  Arm Neoverse N2. It is null on x86-64, on macOS, and on Linux without HWCAP_CPUID. On a system
  with cores of more than one kind, it names the core where detection ran.
- `data_independent_timing(features)`: whether the calling thread's timing is data-independent.
  On arm64 it is PSTATE.DIT, and false on a core whose features hold no FEAT_DIT. On x86-64 it is
  false, because only the operating system reads DOITM.
- `set_data_independent_timing(features, enabled)`: sets or clears the calling thread's PSTATE.DIT
  on arm64, and returns true. It returns false on x86-64, on another architecture, and on a core
  whose features hold no FEAT_DIT. A program calls it on each thread that runs code whose timing
  must not depend on a secret, such as `stdx.crypto`'s.
- `memset`: a vector `memset` that a program may export from its root on Linux under Zig 0.16,
  where `memset_applies` holds ([decision 41](../../docs/decisions.md)).

## No system call

Detection makes no system call. A program makes it once, when it starts, and no codec path runs
it. It reads:

- x86-64: CPUID and XGETBV.
- aarch64 Linux: the auxiliary vector, through `getauxval`, which reads memory, and MIDR_EL1,
  through `mrs`, which the kernel traps and emulates where AT_HWCAP has HWCAP_CPUID.
- aarch64 macOS: the features every Apple M-series part has.
- Any other system: the build target's features.

Detection only reads. It changes no CPU state. `data_independent_timing` and
`set_data_independent_timing` make no system call either: each runs one instruction on arm64,
`mrs` or `msr` of the register DIT, and acts on the calling thread alone. Each takes the program's
`CpuFeatures`, because that instruction faults on a core without FEAT_DIT. Library code may read
the mode, as `stdx.crypto` does at each call. No library code sets it.
