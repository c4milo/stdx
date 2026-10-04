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
| Run URL | https://github.com/c4milo/stdx/actions/runs/37227179878 |
| Date | 2026-10-04 |

## Probe: one small input repeated against slices in rotation

Each 1 MiB HTTP payload is cut into slices. `first` takes the first slice again and again, as
bench-deflate times the 1 KiB and 16 KiB files today. `copies` takes copies of the first slice,
one after another in memory. `each` takes every slice 64 times before the next. `rotation`
takes every slice once a round, 8 rounds a repetition. Throughput counts the slices' octets.
The counters are unavailable on this host.

| Coding | File | Slice, octets | Slices | Level | Way | Candidate | MB/s | Spread, % | Compressed, % | Cycles / octet | Instructions / octet | Branch misses / KiB |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| decode | silesia/dickens | 65536 | 128 | 6 | first | zlib | 316.3 | 3.6 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | first | zlib-ng | 548.2 | 0.3 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | first | libdeflate | 856.1 | 3.2 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | first | Wuffs | 551.1 | 1.1 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | first | stdx | 1167.1 | 1.3 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | zlib | 317.6 | 4.7 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | zlib-ng | 547.4 | 0.4 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | libdeflate | 856.7 | 1.3 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | Wuffs | 553.2 | 0.6 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | stdx | 1170.7 | 1.3 | 40.1 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | zlib | 299.5 | 1.6 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | zlib-ng | 539.3 | 0.3 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | libdeflate | 793.0 | 2.0 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | Wuffs | 526.9 | 1.6 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | each | stdx | 1109.1 | 0.9 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | zlib | 281.1 | 0.3 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | zlib-ng | 510.6 | 0.3 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | libdeflate | 709.4 | 0.3 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | Wuffs | 459.9 | 0.2 | 39.9 | - | - | - |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | stdx | 732.1 | 2.0 | 39.9 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | zlib | 309.9 | 1.1 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | zlib-ng | 576.3 | 0.3 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | libdeflate | 846.4 | 0.5 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | Wuffs | 518.3 | 0.5 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | first | stdx | 896.3 | 0.8 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | zlib | 311.0 | 0.4 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | zlib-ng | 576.3 | 0.3 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | libdeflate | 844.2 | 1.7 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | Wuffs | 517.7 | 0.2 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | stdx | 898.2 | 1.0 | 37.8 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | zlib | 305.3 | 0.4 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | zlib-ng | 563.1 | 0.1 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | libdeflate | 822.8 | 0.3 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | Wuffs | 510.0 | 0.5 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | each | stdx | 868.0 | 1.2 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | zlib | 297.1 | 0.2 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | zlib-ng | 554.2 | 0.2 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | libdeflate | 779.9 | 0.2 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | Wuffs | 496.7 | 0.7 | 38.4 | - | - | - |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | stdx | 819.3 | 0.1 | 38.4 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | zlib | 308.3 | 0.3 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | zlib-ng | 588.3 | 1.3 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | libdeflate | 839.6 | 0.3 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | Wuffs | 518.8 | 0.2 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | stdx | 906.6 | 0.3 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | zlib | 308.5 | 0.2 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | zlib-ng | 588.6 | 0.2 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | libdeflate | 838.5 | 1.6 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | Wuffs | 520.2 | 0.7 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | stdx | 905.3 | 0.4 | 37.3 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | zlib | 302.8 | 0.2 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | zlib-ng | 574.9 | 0.1 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | libdeflate | 822.9 | 0.4 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | Wuffs | 517.0 | 0.2 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | stdx | 884.0 | 0.2 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | zlib | 302.1 | 0.5 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | zlib-ng | 570.4 | 0.1 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | libdeflate | 807.9 | 0.2 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | Wuffs | 512.2 | 0.3 | 38.1 | - | - | - |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | stdx | 866.1 | 0.3 | 38.1 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | zlib | 352.9 | 0.5 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | zlib-ng | 698.5 | 0.2 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | libdeflate | 989.4 | 0.3 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | Wuffs | 532.7 | 0.3 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | first | stdx | 947.4 | 0.4 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | zlib | 352.8 | 0.3 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | zlib-ng | 697.9 | 0.2 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | libdeflate | 987.5 | 0.2 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | Wuffs | 535.4 | 0.2 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | stdx | 944.5 | 0.6 | 29.2 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | zlib | 350.6 | 0.8 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | zlib-ng | 692.9 | 0.2 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | libdeflate | 974.7 | 0.1 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | Wuffs | 530.3 | 0.3 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | each | stdx | 936.3 | 0.2 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | zlib | 348.3 | 0.4 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | zlib-ng | 686.3 | 0.1 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | libdeflate | 956.8 | 0.1 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | Wuffs | 525.0 | 0.1 | 29.4 | - | - | - |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | stdx | 918.9 | 0.3 | 29.4 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | zlib | 349.7 | 1.0 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | zlib-ng | 681.8 | 0.1 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | libdeflate | 942.2 | 0.1 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | Wuffs | 525.3 | 1.7 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | first | stdx | 911.3 | 5.1 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | zlib | 349.7 | 0.5 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | zlib-ng | 681.5 | 0.2 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | libdeflate | 941.3 | 0.4 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | Wuffs | 527.9 | 2.4 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | stdx | 910.2 | 0.9 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | zlib | 349.8 | 0.1 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | zlib-ng | 684.4 | 0.0 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | libdeflate | 947.2 | 0.0 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | Wuffs | 526.0 | 0.1 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | each | stdx | 914.8 | 0.1 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | zlib | 349.6 | 2.8 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | zlib-ng | 683.1 | 0.1 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | libdeflate | 944.8 | 0.2 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | Wuffs | 527.3 | 0.3 | 29.3 | - | - | - |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | stdx | 912.4 | 1.6 | 29.3 | - | - | - |
