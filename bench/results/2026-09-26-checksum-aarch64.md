# bench-checksum

| Field | Value |
|---|---|
| Commit | d273c5c |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260920.129.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/36203101031 |
| Date | 2026-09-26 |

## CRC-32, GB/s

| Octets | stdx table | stdx armv8 | stdx pmull | zlib | Wuffs | libdeflate | zlib-ng | stdx pmull / fastest baseline |
|---|---|---|---|---|---|---|---|---|
| 64 | 2.99 ± 0.5% | 7.49 ± 0.2% | 9.87 ± 0.1% | 10.84 ± 0.2% | 6.99 ± 3.5% | 14.94 ± 10.3% | 10.34 ± 0.1% | 0.66 (libdeflate) |
| 1024 | 2.59 ± 0.3% | 11.30 ± 0.4% | 28.52 ± 0.4% | 24.31 ± 0.5% | 23.98 ± 0.9% | 24.15 ± 1.4% | 24.23 ± 1.8% | 1.17 (zlib) |
| 16384 | 2.57 ± 0.0% | 11.49 ± 0.1% | 45.36 ± 0.1% | 26.74 ± 0.2% | 26.64 ± 0.4% | 26.92 ± 0.0% | 23.98 ± 3.9% | 1.68 (libdeflate) |
| 1048576 | 2.53 ± 0.3% | 11.38 ± 1.2% | 35.09 ± 0.9% | 26.27 ± 0.3% | 25.13 ± 1.4% | 26.85 ± 0.2% | 25.11 ± 2.3% | 1.31 (libdeflate) |

## Adler-32, GB/s

| Octets | stdx scalar | stdx vector | stdx udot | zlib | Wuffs | libdeflate | zlib-ng | stdx udot / fastest baseline |
|---|---|---|---|---|---|---|---|---|
| 64 | 1.68 ± 0.1% | 4.85 ± 0.3% | 5.71 ± 0.1% | 2.98 ± 0.1% | 2.68 ± 0.1% | 8.35 ± 0.0% | 2.80 ± 0.5% | 0.68 (libdeflate) |
| 1024 | 1.83 ± 0.1% | 18.29 ± 0.1% | 31.03 ± 0.1% | 3.25 ± 0.0% | 15.16 ± 0.2% | 32.23 ± 0.1% | 15.66 ± 0.1% | 0.96 (libdeflate) |
| 16384 | 1.85 ± 0.8% | 21.36 ± 0.1% | 46.68 ± 0.1% | 3.29 ± 0.0% | 21.55 ± 0.0% | 35.57 ± 0.0% | 23.30 ± 0.0% | 1.31 (libdeflate) |
| 1048576 | 1.84 ± 0.4% | 21.01 ± 1.1% | 40.69 ± 3.6% | 3.29 ± 0.1% | 21.62 ± 0.4% | 32.50 ± 1.5% | 23.14 ± 0.7% | 1.25 (libdeflate) |

