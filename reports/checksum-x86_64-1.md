# bench-checksum

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261122.9.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
| zlib | 1.3.2 |
| zlib-ng | 2.3.3 |
| libdeflate | 1.26 |
| Wuffs | 7411f48 |
| libzstd | 1.5.7 |

## CRC-32, GB/s

zlib and Wuffs are built for the architecture's baseline CPU, as every candidate is (decision 75). On aarch64 that CPU has no CRC-32 instruction, and zlib and Wuffs take the instruction from the build's CPU alone. On x86-64, Wuffs asks CPUID each time a decoder or a hasher starts, which takes about a microsecond on a virtual machine.

| Octets | stdx table | stdx pclmul | stdx vpclmul | zlib | Wuffs | libdeflate | zlib-ng | stdx vpclmul / fastest baseline |
|---|---|---|---|---|---|---|---|---|
| 64 | 2.09 ± 1.7% | 5.77 ± 0.4% | 5.78 ± 0.3% | 0.52 ± 0.3% | 0.04 ± 0.1% | 7.34 ± 0.5% | 2.16 ± 1.7% | 0.79 (libdeflate) |
| 1024 | 1.75 ± 0.5% | 12.14 ± 1.5% | 22.19 ± 0.2% | 2.45 ± 1.3% | 0.63 ± 4.7% | 22.64 ± 1.1% | 10.97 ± 1.6% | 0.98 (libdeflate) |
| 16384 | 1.74 ± 0.5% | 12.72 ± 0.6% | 25.12 ± 2.3% | 3.44 ± 1.0% | 5.77 ± 0.1% | 25.51 ± 0.1% | 14.76 ± 13.8% | 0.98 (libdeflate) |
| 1048576 | 1.73 ± 0.2% | 12.73 ± 0.6% | 25.34 ± 0.9% | 3.47 ± 1.6% | 12.43 ± 0.7% | 25.33 ± 0.4% | 14.81 ± 0.2% | 1.00 (libdeflate) |

## Adler-32, GB/s

zlib and Wuffs are built for the architecture's baseline CPU, as every candidate is (decision 75). On aarch64 that CPU has no CRC-32 instruction, and zlib and Wuffs take the instruction from the build's CPU alone. On x86-64, Wuffs asks CPUID each time a decoder or a hasher starts, which takes about a microsecond on a virtual machine.

| Octets | stdx scalar | stdx vector | stdx avx2 | zlib | Wuffs | libdeflate | zlib-ng | stdx avx2 / fastest baseline |
|---|---|---|---|---|---|---|---|---|
| 64 | 1.59 ± 0.3% | 4.19 ± 2.7% | 4.89 ± 3.6% | 3.08 ± 0.3% | 0.04 ± 0.1% | 6.84 ± 0.2% | 8.22 ± 0.4% | 0.60 (zlib-ng) |
| 1024 | 1.60 ± 0.3% | 18.24 ± 1.1% | 32.01 ± 2.0% | 3.22 ± 0.4% | 0.66 ± 0.4% | 36.01 ± 0.2% | 39.71 ± 0.4% | 0.81 (zlib-ng) |
| 16384 | 1.61 ± 0.1% | 22.50 ± 0.8% | 62.95 ± 1.7% | 3.17 ± 0.1% | 7.71 ± 0.3% | 53.14 ± 5.6% | 53.34 ± 1.0% | 1.18 (zlib-ng) |
| 1048576 | 1.60 ± 1.7% | 22.48 ± 6.1% | 56.65 ± 2.8% | 3.19 ± 1.1% | 25.40 ± 2.3% | 50.84 ± 2.1% | 49.65 ± 2.0% | 1.11 (libdeflate) |

## XXH64, GB/s

| Octets | stdx scalar | libzstd | CRC-32 by stdx vpclmul | scalar / scalar | scalar / libzstd | scalar / CRC-32 |
|---|---|---|---|---|---|---|
| 64 | 4.28 ± 2.9% | 5.05 ± 0.7% | 5.78 ± 0.4% | 1.00 | 0.85 | 0.74 |
| 1024 | 11.40 ± 0.5% | 11.67 ± 1.1% | 22.20 ± 0.4% | 1.00 | 0.98 | 0.51 |
| 16384 | 12.71 ± 0.8% | 12.74 ± 0.5% | 25.15 ± 0.2% | 1.00 | 1.00 | 0.51 |
| 1048576 | 12.79 ± 0.6% | 12.79 ± 1.2% | 25.39 ± 0.3% | 1.00 | 1.00 | 0.50 |

