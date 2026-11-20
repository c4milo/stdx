# bench-checksum

| Field | Value |
|---|---|
| Commit | 0dd2e97 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261111.184.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1019-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44677298419 |
| Date | 2026-11-20 |
| zlib | 1.3.2 |
| zlib-ng | 2.3.3 |
| libdeflate | 1.26 |
| Wuffs | 7411f48 |
| libzstd | 1.5.7 |

## CRC-32, GB/s

zlib and Wuffs are built for the architecture's baseline CPU, as every candidate is (decision 75). On aarch64 that CPU has no CRC-32 instruction, and zlib and Wuffs take the instruction from the build's CPU alone. On x86-64, Wuffs asks CPUID each time a decoder or a hasher starts, which takes about a microsecond on a virtual machine.

| Octets | stdx table | stdx armv8 | stdx pmull | zlib | Wuffs | libdeflate | zlib-ng | stdx pmull / fastest baseline |
|---|---|---|---|---|---|---|---|---|
| 64 | 2.94 ± 0.3% | 7.49 ± 0.1% | 9.87 ± 0.4% | 0.67 ± 0.1% | 3.14 ± 0.2% | 14.00 ± 0.2% | 12.72 ± 0.4% | 0.70 (libdeflate) |
| 1024 | 2.60 ± 0.8% | 11.69 ± 0.5% | 28.18 ± 0.2% | 3.28 ± 0.1% | 4.41 ± 0.1% | 23.81 ± 0.5% | 22.48 ± 4.6% | 1.18 (libdeflate) |
| 16384 | 2.56 ± 0.1% | 11.97 ± 2.6% | 45.25 ± 0.2% | 4.97 ± 0.5% | 4.41 ± 0.4% | 26.94 ± 0.2% | 24.26 ± 4.4% | 1.68 (libdeflate) |
| 1048576 | 2.53 ± 0.1% | 11.36 ± 0.6% | 34.20 ± 4.2% | 5.07 ± 0.3% | 4.35 ± 0.2% | 26.86 ± 0.3% | 23.72 ± 1.3% | 1.27 (libdeflate) |

## Adler-32, GB/s

zlib and Wuffs are built for the architecture's baseline CPU, as every candidate is (decision 75). On aarch64 that CPU has no CRC-32 instruction, and zlib and Wuffs take the instruction from the build's CPU alone. On x86-64, Wuffs asks CPUID each time a decoder or a hasher starts, which takes about a microsecond on a virtual machine.

| Octets | stdx scalar | stdx vector | stdx udot | zlib | Wuffs | libdeflate | zlib-ng | stdx udot / fastest baseline |
|---|---|---|---|---|---|---|---|---|
| 64 | 1.68 ± 0.0% | 4.78 ± 0.2% | 5.73 ± 0.1% | 2.99 ± 0.1% | 2.54 ± 0.1% | 8.35 ± 0.1% | 2.79 ± 0.1% | 0.69 (libdeflate) |
| 1024 | 1.83 ± 0.3% | 18.24 ± 0.0% | 31.11 ± 0.0% | 3.27 ± 0.0% | 15.03 ± 0.4% | 32.29 ± 0.0% | 15.72 ± 0.1% | 0.96 (libdeflate) |
| 16384 | 1.85 ± 0.0% | 21.36 ± 0.1% | 46.66 ± 0.0% | 3.32 ± 0.0% | 22.52 ± 0.1% | 35.56 ± 0.0% | 23.32 ± 0.0% | 1.31 (libdeflate) |
| 1048576 | 1.84 ± 0.5% | 20.73 ± 0.5% | 38.05 ± 5.5% | 3.32 ± 0.2% | 22.10 ± 1.4% | 31.09 ± 1.1% | 22.71 ± 0.9% | 1.22 (libdeflate) |

## XXH64, GB/s

| Octets | stdx scalar | stdx aarch64 | libzstd | CRC-32 by stdx pmull | scalar / scalar | scalar / libzstd | scalar / CRC-32 |
|---|---|---|---|---|---|---|---|
| 64 | 5.64 ± 0.3% | 5.03 ± 0.2% | 6.57 ± 0.1% | 9.87 ± 0.2% | 1.00 | 0.86 | 0.57 |
| 1024 | 17.44 ± 0.3% | 16.44 ± 0.0% | 17.47 ± 0.4% | 28.20 ± 0.2% | 1.00 | 1.00 | 0.62 |
| 16384 | 19.90 ± 2.3% | 19.18 ± 0.0% | 19.08 ± 0.1% | 45.26 ± 0.0% | 1.00 | 1.04 | 0.44 |
| 1048576 | 18.36 ± 0.2% | 18.17 ± 0.9% | 18.02 ± 1.9% | 34.44 ± 2.8% | 1.00 | 1.02 | 0.53 |

