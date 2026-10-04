# bench-deflate

| Field | Value |
|---|---|
| Commit | 7355ced |
| Runner label | ubuntu-24.04 |
| Image version | 20260927.320.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37227185061 |
| Date | 2026-10-04 |

## Probe: one small input repeated against slices in rotation

Each 1 MiB HTTP payload is cut into slices. `first` takes the first slice again and again, as
bench-deflate times the 1 KiB and 16 KiB files today. `copies` takes copies of the first slice,
one after another in memory. `each` takes every slice 64 times before the next. `rotation`
takes every slice once a round, 8 rounds a repetition. Throughput counts the slices' octets.
The counters are unavailable on this host.

| Coding | File | Slice, octets | Slices | Level | Way | Candidate | MB/s | Spread, % | Compressed, % | Cycles / octet | Instructions / octet | Branch misses / KiB |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| decode | silesia/dickens | 65536 | 128 | 6 | first | zlib | 306.7 | 2.4 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | first | zlib-ng | 525.1 | 1.5 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | first | libdeflate | 822.2 | 7.2 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | first | Wuffs | 535.4 | 2.2 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | first | stdx | 1155.2 | 4.7 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | zlib | 308.0 | 1.7 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | zlib-ng | 530.5 | 2.7 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | libdeflate | 827.2 | 4.7 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | Wuffs | 529.0 | 2.8 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | stdx | 1125.9 | 3.6 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | zlib | 287.5 | 4.9 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | zlib-ng | 521.6 | 5.2 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | libdeflate | 769.0 | 1.3 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | Wuffs | 510.9 | 4.1 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | stdx | 1058.9 | 3.7 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | zlib | 273.7 | 2.9 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | zlib-ng | 495.1 | 7.8 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | libdeflate | 688.6 | 6.3 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | Wuffs | 449.9 | 13.7 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | stdx | 709.0 | 4.3 | 39.9 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | zlib | 303.5 | 0.6 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | zlib-ng | 563.5 | 3.7 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | libdeflate | 817.6 | 5.3 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | Wuffs | 500.2 | 7.7 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | stdx | 871.7 | 6.1 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | zlib | 302.9 | 6.6 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | zlib-ng | 559.1 | 3.5 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | libdeflate | 815.3 | 4.8 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | Wuffs | 497.4 | 7.7 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | stdx | 876.2 | 10.1 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | zlib | 294.9 | 2.0 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | zlib-ng | 547.6 | 1.7 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | libdeflate | 803.3 | 1.3 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | Wuffs | 490.9 | 12.4 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | stdx | 846.5 | 1.8 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | zlib | 290.6 | 1.0 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | zlib-ng | 540.1 | 2.0 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | libdeflate | 762.5 | 2.4 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | Wuffs | 484.4 | 1.8 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | stdx | 801.7 | 3.4 | 38.4 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | zlib | 294.1 | 4.5 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | zlib-ng | 563.2 | 1.6 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | libdeflate | 821.3 | 8.3 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | Wuffs | 502.3 | 3.7 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | stdx | 876.1 | 0.8 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | zlib | 300.0 | 3.7 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | zlib-ng | 564.1 | 9.9 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | libdeflate | 808.9 | 9.6 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | Wuffs | 496.3 | 1.7 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | stdx | 881.9 | 2.4 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | zlib | 290.6 | 1.2 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | zlib-ng | 550.3 | 5.7 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | libdeflate | 791.6 | 4.8 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | Wuffs | 498.6 | 4.5 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | stdx | 852.1 | 1.9 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | zlib | 294.4 | 1.7 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | zlib-ng | 547.7 | 3.0 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | libdeflate | 781.5 | 1.5 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | Wuffs | 488.7 | 4.1 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | stdx | 832.7 | 2.8 | 38.1 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | zlib | 332.0 | 4.2 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | zlib-ng | 648.8 | 6.8 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | libdeflate | 941.9 | 4.1 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | Wuffs | 507.0 | 5.1 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | stdx | 886.9 | 4.9 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | zlib | 332.0 | 5.4 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | zlib-ng | 663.5 | 6.8 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | libdeflate | 929.5 | 4.1 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | Wuffs | 506.2 | 9.6 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | stdx | 888.4 | 7.5 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | zlib | 331.5 | 5.0 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | zlib-ng | 656.9 | 2.2 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | libdeflate | 916.9 | 6.7 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | Wuffs | 497.7 | 3.8 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | stdx | 879.0 | 5.1 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | zlib | 323.9 | 9.4 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | zlib-ng | 649.9 | 7.1 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | libdeflate | 912.4 | 7.8 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | Wuffs | 498.7 | 5.5 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | stdx | 857.8 | 4.9 | 29.4 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | zlib | 340.0 | 1.6 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | zlib-ng | 662.9 | 1.1 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | libdeflate | 915.0 | 1.5 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | Wuffs | 511.5 | 0.7 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | stdx | 888.2 | 1.7 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | zlib | 339.8 | 0.8 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | zlib-ng | 662.3 | 1.2 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | libdeflate | 918.3 | 1.1 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | Wuffs | 512.7 | 0.5 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | stdx | 884.6 | 2.0 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | zlib | 339.8 | 0.2 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | zlib-ng | 664.1 | 0.6 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | libdeflate | 920.9 | 1.2 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | Wuffs | 510.9 | 1.3 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | stdx | 888.8 | 5.4 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | zlib | 340.5 | 1.5 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | zlib-ng | 665.3 | 1.3 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | libdeflate | 915.4 | 16.7 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | Wuffs | 511.1 | 14.5 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | stdx | 880.7 | 2.7 | 29.3 | - | - | - |
