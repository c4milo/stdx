# stdx.platform

`stdx.platform` says what the CPU offers. A program reads it once when it starts
([decision 40](../../docs/decisions.md)).

## Use

```zig
const features = stdx.platform.CpuFeatures.detect();
```

Pass the value to each codec's `init`, and to each searcher's options. It tells them which SIMD
instructions the CPU has. stdx keeps no copy of it, and no codec probes the CPU.

## What it holds

- `CpuFeatures.detect()`: the features that the fast paths of the codecs read
  ([decision 21](../../docs/decisions.md)).
- `probe()`: a `Cpu`, the answers that a TLS stack asks for, each `yes`, `no` or `not_known`:
  the AES and carry-less multiply instructions, the SHA instructions, AVX2, and Arm's FEAT_DIT
  among them.
- `memset`: a vector `memset` that a program may export from its root on Linux under Zig 0.16,
  where `memset_applies` holds ([decision 41](../../docs/decisions.md)).

## The one system call

`probe` is the one call in stdx that may make a system call, because a program makes it once and
no codec path runs it:

- x86-64: CPUID and XGETBV. No system call.
- aarch64 Linux: the auxiliary vector, through `getauxval`. No system call.
- aarch64 macOS: `sysctlbyname`, a system call for each feature.

`probe` only reads. It changes no CPU state.
