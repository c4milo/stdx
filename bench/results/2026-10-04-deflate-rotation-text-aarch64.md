# bench-deflate

| Field | Value |
|---|---|
| Commit | 7355ced |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
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
The counters are one repetition's, in user space.

| Coding | File | Slice, octets | Slices | Level | Way | Candidate | MB/s | Spread, % | Compressed, % | Cycles / octet | Instructions / octet | Branch misses / KiB |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| decode | silesia/dickens | 65536 | 128 | 6 | first | zlib | 413.4 | 0.4 | 40.1 | 8.204 | 16.436 | 292.940 |
| decode | silesia/dickens | 65536 | 128 | 6 | first | zlib-ng | 663.0 | 0.3 | 40.1 | 5.104 | 11.198 | 63.311 |
| decode | silesia/dickens | 65536 | 128 | 6 | first | libdeflate | 932.7 | 1.0 | 40.1 | 3.630 | 10.094 | 60.471 |
| decode | silesia/dickens | 65536 | 128 | 6 | first | Wuffs | 645.5 | 0.3 | 40.1 | 5.259 | 11.767 | 98.840 |
| decode | silesia/dickens | 65536 | 128 | 6 | first | stdx | 1147.3 | 0.3 | 40.1 | 2.954 | 8.224 | 49.413 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | zlib | 411.8 | 0.6 | 40.1 | 8.249 | 16.436 | 293.108 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | zlib-ng | 658.0 | 0.9 | 40.1 | 5.139 | 11.197 | 63.225 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | libdeflate | 924.4 | 1.0 | 40.1 | 3.634 | 10.094 | 57.424 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | Wuffs | 639.9 | 0.6 | 40.1 | 5.318 | 11.767 | 98.977 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | stdx | 1139.4 | 1.1 | 40.1 | 2.991 | 8.224 | 49.538 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | zlib | 407.9 | 0.1 | 39.9 | 8.319 | 16.476 | 306.878 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | zlib-ng | 659.5 | 0.1 | 39.9 | 5.144 | 11.203 | 67.587 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | libdeflate | 919.0 | 0.1 | 39.9 | 3.695 | 10.137 | 68.885 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | Wuffs | 652.5 | 0.1 | 39.9 | 5.201 | 11.673 | 98.203 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | stdx | 1139.8 | 0.1 | 39.9 | 2.977 | 8.152 | 56.122 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | zlib | 393.5 | 0.2 | 39.9 | 8.620 | 16.476 | 329.018 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | zlib-ng | 624.6 | 0.4 | 39.9 | 5.429 | 11.203 | 85.238 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | libdeflate | 877.1 | 0.8 | 39.9 | 3.871 | 10.137 | 83.074 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | Wuffs | 625.7 | 0.4 | 39.9 | 5.428 | 11.673 | 111.502 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | stdx | 983.2 | 0.3 | 39.9 | 3.443 | 8.152 | 95.013 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | zlib | 426.4 | 0.1 | 37.8 | 7.950 | 15.742 | 297.575 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | zlib-ng | 702.2 | 0.4 | 37.8 | 4.837 | 10.500 | 66.306 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | libdeflate | 991.5 | 0.5 | 37.8 | 3.424 | 9.529 | 62.758 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | Wuffs | 685.4 | 0.2 | 37.8 | 4.944 | 10.945 | 98.713 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | stdx | 1134.5 | 0.9 | 37.8 | 2.986 | 7.640 | 72.665 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | zlib | 425.0 | 0.2 | 37.8 | 7.964 | 15.742 | 297.129 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | zlib-ng | 698.3 | 0.3 | 37.8 | 4.843 | 10.500 | 65.456 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | libdeflate | 984.1 | 0.5 | 37.8 | 3.445 | 9.529 | 64.168 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | Wuffs | 681.9 | 0.3 | 37.8 | 4.954 | 10.945 | 98.681 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | stdx | 1121.8 | 0.8 | 37.8 | 3.011 | 7.640 | 73.588 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | zlib | 420.2 | 0.1 | 38.4 | 8.067 | 15.957 | 303.789 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | zlib-ng | 685.8 | 0.1 | 38.4 | 4.948 | 10.697 | 68.395 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | libdeflate | 967.5 | 0.1 | 38.4 | 3.505 | 9.708 | 66.410 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | Wuffs | 681.7 | 0.1 | 38.4 | 4.973 | 11.090 | 97.355 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | stdx | 1107.3 | 0.1 | 38.4 | 3.063 | 7.725 | 77.995 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | zlib | 413.2 | 0.2 | 38.4 | 8.195 | 15.957 | 312.286 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | zlib-ng | 673.3 | 0.2 | 38.4 | 5.037 | 10.697 | 73.010 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | libdeflate | 953.8 | 0.3 | 38.4 | 3.561 | 9.708 | 70.458 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | Wuffs | 671.3 | 0.5 | 38.4 | 5.048 | 11.090 | 101.140 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | stdx | 1083.1 | 0.2 | 38.4 | 3.139 | 7.725 | 82.221 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | zlib | 427.4 | 0.1 | 37.3 | 7.917 | 15.507 | 301.709 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | zlib-ng | 708.5 | 0.1 | 37.3 | 4.767 | 10.262 | 66.758 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | libdeflate | 999.8 | 0.2 | 37.3 | 3.375 | 9.346 | 64.408 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | Wuffs | 692.2 | 0.2 | 37.3 | 4.882 | 10.667 | 100.283 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | stdx | 1148.4 | 0.2 | 37.3 | 2.936 | 7.295 | 74.571 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | zlib | 426.6 | 0.2 | 37.3 | 7.925 | 15.507 | 300.477 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | zlib-ng | 706.4 | 0.2 | 37.3 | 4.788 | 10.262 | 67.043 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | libdeflate | 997.7 | 0.4 | 37.3 | 3.380 | 9.346 | 64.205 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | Wuffs | 690.0 | 0.2 | 37.3 | 4.896 | 10.667 | 100.438 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | stdx | 1142.9 | 0.1 | 37.3 | 2.945 | 7.295 | 74.716 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | zlib | 421.5 | 0.1 | 38.1 | 8.021 | 15.802 | 304.545 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | zlib-ng | 690.7 | 0.1 | 38.1 | 4.889 | 10.529 | 67.804 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | libdeflate | 977.5 | 0.1 | 38.1 | 3.454 | 9.587 | 65.561 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | Wuffs | 686.7 | 0.1 | 38.1 | 4.918 | 10.888 | 96.976 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | stdx | 1122.2 | 0.2 | 38.1 | 3.005 | 7.495 | 76.485 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | zlib | 418.7 | 0.1 | 38.1 | 8.074 | 15.802 | 306.903 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | zlib-ng | 686.8 | 0.2 | 38.1 | 4.923 | 10.529 | 69.111 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | libdeflate | 970.6 | 0.2 | 38.1 | 3.479 | 9.587 | 67.193 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | Wuffs | 683.0 | 0.3 | 38.1 | 4.950 | 10.888 | 97.869 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | stdx | 1111.7 | 0.4 | 38.1 | 3.036 | 7.495 | 78.289 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | zlib | 486.7 | 0.1 | 29.2 | 6.945 | 12.931 | 271.467 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | zlib-ng | 815.3 | 0.1 | 29.2 | 4.141 | 8.009 | 82.598 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | libdeflate | 1202.4 | 0.1 | 29.2 | 2.808 | 7.133 | 65.605 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | Wuffs | 756.1 | 0.1 | 29.2 | 4.467 | 8.593 | 121.230 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | stdx | 1252.8 | 0.4 | 29.2 | 2.696 | 5.810 | 84.838 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | zlib | 486.0 | 0.1 | 29.2 | 6.950 | 12.931 | 271.245 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | zlib-ng | 813.6 | 0.1 | 29.2 | 4.151 | 8.009 | 82.652 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | libdeflate | 1198.0 | 0.4 | 29.2 | 2.813 | 7.133 | 65.604 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | Wuffs | 753.9 | 0.1 | 29.2 | 4.475 | 8.593 | 121.149 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | stdx | 1246.5 | 0.3 | 29.2 | 2.702 | 5.810 | 84.662 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | zlib | 483.7 | 0.1 | 29.4 | 6.986 | 12.985 | 272.907 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | zlib-ng | 807.0 | 0.1 | 29.4 | 4.185 | 8.042 | 84.441 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | libdeflate | 1190.6 | 0.0 | 29.4 | 2.833 | 7.161 | 67.251 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | Wuffs | 749.7 | 0.1 | 29.4 | 4.505 | 8.635 | 121.991 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | stdx | 1239.5 | 0.1 | 29.4 | 2.721 | 5.842 | 86.514 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | zlib | 481.0 | 0.1 | 29.4 | 7.031 | 12.985 | 276.372 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | zlib-ng | 802.1 | 0.1 | 29.4 | 4.208 | 8.042 | 85.715 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | libdeflate | 1181.2 | 0.2 | 29.4 | 2.855 | 7.161 | 68.897 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | Wuffs | 743.8 | 0.3 | 29.4 | 4.530 | 8.635 | 123.524 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | stdx | 1224.3 | 0.2 | 29.4 | 2.755 | 5.842 | 88.710 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | zlib | 484.6 | 0.1 | 29.3 | 6.987 | 12.955 | 273.990 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | zlib-ng | 809.7 | 0.2 | 29.3 | 4.171 | 8.013 | 84.526 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | libdeflate | 1190.8 | 0.1 | 29.3 | 2.837 | 7.148 | 68.238 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | Wuffs | 753.2 | 0.3 | 29.3 | 4.497 | 8.592 | 122.886 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | stdx | 1237.7 | 0.2 | 29.3 | 2.726 | 5.782 | 87.534 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | zlib | 484.4 | 0.1 | 29.3 | 6.985 | 12.955 | 273.836 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | zlib-ng | 809.2 | 0.3 | 29.3 | 4.181 | 8.013 | 84.571 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | libdeflate | 1188.8 | 0.1 | 29.3 | 2.839 | 7.148 | 68.102 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | Wuffs | 751.3 | 0.4 | 29.3 | 4.497 | 8.592 | 122.910 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | stdx | 1236.5 | 0.2 | 29.3 | 2.733 | 5.782 | 87.572 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | zlib | 485.0 | 0.1 | 29.3 | 6.983 | 12.941 | 274.234 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | zlib-ng | 811.3 | 0.1 | 29.3 | 4.166 | 7.998 | 84.563 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | libdeflate | 1195.3 | 0.1 | 29.3 | 2.824 | 7.126 | 67.635 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | Wuffs | 753.1 | 0.2 | 29.3 | 4.492 | 8.582 | 122.670 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | stdx | 1243.8 | 0.0 | 29.3 | 2.714 | 5.783 | 86.877 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | zlib | 484.2 | 0.1 | 29.3 | 6.996 | 12.941 | 274.966 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | zlib-ng | 810.0 | 0.1 | 29.3 | 4.174 | 7.998 | 84.831 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | libdeflate | 1191.6 | 0.2 | 29.3 | 2.833 | 7.126 | 68.057 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | Wuffs | 751.4 | 0.3 | 29.3 | 4.503 | 8.582 | 122.882 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | stdx | 1235.4 | 0.2 | 29.3 | 2.732 | 5.783 | 87.719 |
