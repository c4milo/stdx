# bench-checksum

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
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

| Octets | stdx table | stdx armv8 | stdx pmull | zlib | Wuffs | libdeflate | zlib-ng | stdx pmull / fastest baseline |
|---|---|---|---|---|---|---|---|---|
| 64 | 2.95 ± 0.2% | 7.48 ± 0.1% | 9.87 ± 0.1% | 0.67 ± 0.8% | 3.15 ± 0.9% | 14.48 ± 0.1% | 10.34 ± 4.8% | 0.68 (libdeflate) |
| 1024 | 2.61 ± 0.1% | 11.69 ± 0.1% | 28.32 ± 0.1% | 3.28 ± 0.4% | 4.40 ± 0.2% | 23.93 ± 0.4% | 23.94 ± 10.3% | 1.18 (zlib-ng) |
| 16384 | 2.56 ± 0.1% | 11.97 ± 0.8% | 45.30 ± 0.2% | 4.96 ± 0.3% | 4.42 ± 0.3% | 26.92 ± 0.1% | 24.79 ± 4.3% | 1.68 (libdeflate) |
| 1048576 | 2.52 ± 0.7% | 11.34 ± 1.0% | 36.52 ± 0.7% | 5.09 ± 0.3% | 4.36 ± 0.2% | 26.80 ± 0.2% | 23.19 ± 1.5% | 1.36 (libdeflate) |

## Adler-32, GB/s

zlib and Wuffs are built for the architecture's baseline CPU, as every candidate is (decision 75). On aarch64 that CPU has no CRC-32 instruction, and zlib and Wuffs take the instruction from the build's CPU alone. On x86-64, Wuffs asks CPUID each time a decoder or a hasher starts, which takes about a microsecond on a virtual machine.

| Octets | stdx scalar | stdx vector | stdx udot | zlib | Wuffs | libdeflate | zlib-ng | stdx udot / fastest baseline |
|---|---|---|---|---|---|---|---|---|
| 64 | 1.68 ± 0.1% | 4.84 ± 0.2% | 5.62 ± 0.1% | 2.98 ± 0.3% | 2.53 ± 0.6% | 8.35 ± 0.0% | 2.82 ± 0.0% | 0.67 (libdeflate) |
| 1024 | 1.83 ± 0.0% | 18.25 ± 0.0% | 30.99 ± 0.1% | 3.26 ± 0.0% | 15.04 ± 0.1% | 32.27 ± 0.3% | 15.78 ± 0.5% | 0.96 (libdeflate) |
| 16384 | 1.85 ± 0.4% | 21.36 ± 0.0% | 46.66 ± 0.0% | 3.32 ± 0.1% | 22.56 ± 0.2% | 35.56 ± 0.1% | 23.34 ± 0.0% | 1.31 (libdeflate) |
| 1048576 | 1.84 ± 2.1% | 20.75 ± 2.1% | 38.77 ± 3.2% | 3.32 ± 0.4% | 22.17 ± 0.6% | 31.35 ± 1.2% | 22.83 ± 0.5% | 1.24 (libdeflate) |

## XXH64, GB/s

| Octets | stdx scalar | stdx aarch64 | libzstd | CRC-32 by stdx pmull | scalar / scalar | scalar / libzstd | scalar / CRC-32 |
|---|---|---|---|---|---|---|---|
| 64 | 5.64 ± 0.1% | 5.03 ± 0.1% | 6.58 ± 0.1% | 9.87 ± 0.1% | 1.00 | 0.86 | 0.57 |
| 1024 | 17.44 ± 0.3% | 16.43 ± 0.0% | 17.47 ± 0.3% | 28.33 ± 0.2% | 1.00 | 1.00 | 0.62 |
| 16384 | 19.49 ± 1.6% | 19.17 ± 0.0% | 19.05 ± 0.1% | 45.29 ± 0.0% | 1.00 | 1.02 | 0.43 |
| 1048576 | 18.65 ± 1.4% | 18.36 ± 1.4% | 18.36 ± 2.1% | 35.56 ± 3.5% | 1.00 | 1.02 | 0.52 |

