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
| Run URL | https://github.com/c4milo/stdx/actions/runs/37227185061 |
| Date | 2026-10-04 |

## Probe: one small input repeated against slices in rotation

Each 1 MiB HTTP payload is cut into slices. `first` takes the first slice again and again, as
bench-deflate times the 1 KiB and 16 KiB files today. `copies` takes copies of the first slice,
one after another in memory. `each` takes every slice 64 times before the next. `rotation`
takes every slice once a round, 8 rounds a repetition. Throughput counts the slices' octets.
The counters are one repetition's, in user space.

| Coding | File | Slice, octets | Slices | Level | Way | Candidate | MB/s | Spread, % | Compressed, % | Cycles / octet | Instructions / octet | Branch misses / KiB |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| decode | silesia/dickens | 65536 | 128 | 6 | first | zlib | 412.4 | 0.3 | 40.1 | 8.241 | 16.436 | 294.523 |
| decode | silesia/dickens | 65536 | 128 | 6 | first | zlib-ng | 663.0 | 0.3 | 40.1 | 5.115 | 11.198 | 63.823 |
| decode | silesia/dickens | 65536 | 128 | 6 | first | libdeflate | 936.0 | 2.1 | 40.1 | 3.653 | 10.094 | 62.155 |
| decode | silesia/dickens | 65536 | 128 | 6 | first | Wuffs | 640.8 | 0.3 | 40.1 | 5.296 | 11.767 | 98.811 |
| decode | silesia/dickens | 65536 | 128 | 6 | first | stdx | 1149.6 | 1.2 | 40.1 | 2.945 | 8.224 | 49.497 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | zlib | 409.9 | 0.3 | 40.1 | 8.276 | 16.436 | 294.504 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | zlib-ng | 653.8 | 0.3 | 40.1 | 5.193 | 11.197 | 64.005 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | libdeflate | 905.0 | 0.8 | 40.1 | 3.688 | 10.094 | 57.255 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | Wuffs | 629.8 | 0.2 | 40.1 | 5.364 | 11.767 | 98.981 |
| decode | silesia/dickens | 65536 | 128 | 6 | copies | stdx | 1109.7 | 0.6 | 40.1 | 3.034 | 8.224 | 49.457 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | zlib | 407.4 | 0.1 | 39.9 | 8.324 | 16.476 | 306.810 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | zlib-ng | 659.4 | 0.0 | 39.9 | 5.142 | 11.203 | 67.583 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | libdeflate | 916.8 | 0.2 | 39.9 | 3.695 | 10.137 | 68.324 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | Wuffs | 648.5 | 0.1 | 39.9 | 5.232 | 11.673 | 98.173 |
| decode | silesia/dickens | 65536 | 128 | 6 | each | stdx | 1138.8 | 0.0 | 39.9 | 2.977 | 8.152 | 55.932 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | zlib | 392.0 | 0.1 | 39.9 | 8.658 | 16.476 | 329.693 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | zlib-ng | 621.3 | 0.1 | 39.9 | 5.460 | 11.203 | 85.200 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | libdeflate | 865.3 | 0.9 | 39.9 | 3.912 | 10.137 | 82.851 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | Wuffs | 618.3 | 0.3 | 39.9 | 5.467 | 11.673 | 111.469 |
| decode | silesia/dickens | 65536 | 128 | 6 | rotation | stdx | 964.1 | 0.3 | 39.9 | 3.508 | 8.152 | 94.801 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | zlib | 426.8 | 0.1 | 37.8 | 7.955 | 15.742 | 298.622 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | zlib-ng | 702.9 | 0.2 | 37.8 | 4.828 | 10.500 | 65.504 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | libdeflate | 989.4 | 0.5 | 37.8 | 3.427 | 9.529 | 63.040 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | Wuffs | 682.5 | 0.3 | 37.8 | 4.970 | 10.945 | 99.000 |
| decode | silesia/dickens | 262144 | 32 | 6 | first | stdx | 1131.6 | 0.3 | 37.8 | 2.987 | 7.640 | 72.562 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | zlib | 424.1 | 0.1 | 37.8 | 7.982 | 15.742 | 298.339 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | zlib-ng | 695.6 | 0.4 | 37.8 | 4.871 | 10.500 | 65.235 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | libdeflate | 976.1 | 0.8 | 37.8 | 3.478 | 9.529 | 64.023 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | Wuffs | 675.0 | 0.2 | 37.8 | 5.012 | 10.945 | 98.894 |
| decode | silesia/dickens | 262144 | 32 | 6 | copies | stdx | 1110.7 | 0.4 | 37.8 | 3.044 | 7.640 | 72.959 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | zlib | 420.1 | 0.1 | 38.4 | 8.069 | 15.957 | 303.468 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | zlib-ng | 685.8 | 0.0 | 38.4 | 4.942 | 10.697 | 68.045 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | libdeflate | 966.1 | 0.1 | 38.4 | 3.509 | 9.708 | 66.501 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | Wuffs | 677.3 | 0.1 | 38.4 | 5.005 | 11.090 | 97.439 |
| decode | silesia/dickens | 262144 | 32 | 6 | each | stdx | 1105.0 | 0.1 | 38.4 | 3.066 | 7.725 | 78.011 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | zlib | 412.9 | 0.2 | 38.4 | 8.206 | 15.957 | 312.599 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | zlib-ng | 670.9 | 0.3 | 38.4 | 5.047 | 10.697 | 72.883 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | libdeflate | 944.4 | 0.1 | 38.4 | 3.571 | 9.708 | 70.341 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | Wuffs | 662.7 | 0.2 | 38.4 | 5.085 | 11.090 | 101.389 |
| decode | silesia/dickens | 262144 | 32 | 6 | rotation | stdx | 1068.9 | 0.3 | 38.4 | 3.159 | 7.725 | 82.024 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | zlib | 425.9 | 0.4 | 37.3 | 7.956 | 15.507 | 301.055 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | zlib-ng | 706.7 | 0.8 | 37.3 | 4.779 | 10.262 | 66.743 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | libdeflate | 998.8 | 0.2 | 37.3 | 3.375 | 9.346 | 64.313 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | Wuffs | 685.6 | 0.5 | 37.3 | 4.919 | 10.667 | 100.168 |
| decode | silesia/dickens | 1048576 | 9 | 6 | first | stdx | 1148.1 | 0.7 | 37.3 | 2.932 | 7.295 | 74.496 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | zlib | 425.9 | 0.8 | 37.3 | 7.943 | 15.507 | 300.787 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | zlib-ng | 703.9 | 0.6 | 37.3 | 4.828 | 10.262 | 66.585 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | libdeflate | 993.2 | 0.5 | 37.3 | 3.390 | 9.346 | 64.431 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | Wuffs | 682.2 | 0.5 | 37.3 | 4.938 | 10.667 | 100.387 |
| decode | silesia/dickens | 1048576 | 9 | 6 | copies | stdx | 1138.7 | 0.5 | 37.3 | 2.961 | 7.295 | 74.603 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | zlib | 420.2 | 0.1 | 38.1 | 8.045 | 15.802 | 304.764 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | zlib-ng | 688.5 | 0.4 | 38.1 | 4.903 | 10.529 | 67.900 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | libdeflate | 975.4 | 0.1 | 38.1 | 3.457 | 9.587 | 65.581 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | Wuffs | 680.3 | 0.4 | 38.1 | 4.974 | 10.888 | 96.939 |
| decode | silesia/dickens | 1048576 | 9 | 6 | each | stdx | 1121.0 | 0.3 | 38.1 | 3.003 | 7.495 | 76.479 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | zlib | 418.3 | 0.6 | 38.1 | 8.101 | 15.802 | 306.728 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | zlib-ng | 684.3 | 0.4 | 38.1 | 4.944 | 10.529 | 69.020 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | libdeflate | 965.9 | 0.3 | 38.1 | 3.485 | 9.587 | 67.140 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | Wuffs | 676.4 | 0.9 | 38.1 | 4.986 | 10.888 | 97.956 |
| decode | silesia/dickens | 1048576 | 9 | 6 | rotation | stdx | 1105.4 | 0.7 | 38.1 | 3.049 | 7.495 | 78.292 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | zlib | 485.2 | 0.4 | 29.2 | 6.960 | 12.931 | 271.413 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | zlib-ng | 812.9 | 0.2 | 29.2 | 4.159 | 8.009 | 82.756 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | libdeflate | 1199.8 | 0.3 | 29.2 | 2.809 | 7.133 | 65.581 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | Wuffs | 750.1 | 0.2 | 29.2 | 4.508 | 8.593 | 120.696 |
| decode | silesia/webster | 1048576 | 32 | 6 | first | stdx | 1247.5 | 0.3 | 29.2 | 2.701 | 5.810 | 84.749 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | zlib | 484.7 | 0.2 | 29.2 | 6.977 | 12.931 | 271.252 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | zlib-ng | 811.0 | 0.6 | 29.2 | 4.167 | 8.009 | 82.690 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | libdeflate | 1196.1 | 0.1 | 29.2 | 2.821 | 7.133 | 65.580 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | Wuffs | 748.5 | 0.5 | 29.2 | 4.510 | 8.593 | 121.064 |
| decode | silesia/webster | 1048576 | 32 | 6 | copies | stdx | 1241.5 | 0.3 | 29.2 | 2.716 | 5.810 | 84.795 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | zlib | 482.4 | 0.2 | 29.4 | 7.009 | 12.985 | 273.422 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | zlib-ng | 804.3 | 0.2 | 29.4 | 4.197 | 8.042 | 84.431 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | libdeflate | 1188.3 | 0.0 | 29.4 | 2.837 | 7.161 | 67.228 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | Wuffs | 744.1 | 0.2 | 29.4 | 4.544 | 8.635 | 121.841 |
| decode | silesia/webster | 1048576 | 32 | 6 | each | stdx | 1236.3 | 0.1 | 29.4 | 2.729 | 5.842 | 86.508 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | zlib | 479.6 | 0.2 | 29.4 | 7.047 | 12.985 | 276.251 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | zlib-ng | 799.6 | 0.2 | 29.4 | 4.230 | 8.042 | 85.693 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | libdeflate | 1178.1 | 0.4 | 29.4 | 2.860 | 7.161 | 68.874 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | Wuffs | 738.4 | 0.3 | 29.4 | 4.577 | 8.635 | 123.897 |
| decode | silesia/webster | 1048576 | 32 | 6 | rotation | stdx | 1219.8 | 0.4 | 29.4 | 2.761 | 5.842 | 88.550 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | zlib | 479.4 | 0.3 | 29.3 | 7.070 | 12.955 | 274.025 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | zlib-ng | 794.3 | 1.1 | 29.3 | 4.228 | 8.013 | 84.920 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | libdeflate | 1164.6 | 1.9 | 29.3 | 2.950 | 7.148 | 68.179 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | Wuffs | 734.9 | 0.6 | 29.3 | 4.561 | 8.592 | 122.788 |
| decode | silesia/webster | 4194304 | 9 | 6 | first | stdx | 1184.7 | 4.2 | 29.3 | 2.920 | 5.782 | 87.610 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | zlib | 479.5 | 0.2 | 29.3 | 7.044 | 12.955 | 273.951 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | zlib-ng | 795.3 | 0.7 | 29.3 | 4.228 | 8.013 | 84.444 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | libdeflate | 1159.9 | 2.0 | 29.3 | 2.893 | 7.148 | 68.180 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | Wuffs | 738.5 | 0.7 | 29.3 | 4.573 | 8.592 | 122.895 |
| decode | silesia/webster | 4194304 | 9 | 6 | copies | stdx | 1170.6 | 4.1 | 29.3 | 2.831 | 5.782 | 87.538 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | zlib | 480.1 | 0.2 | 29.3 | 7.049 | 12.941 | 274.488 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | zlib-ng | 797.9 | 0.4 | 29.3 | 4.234 | 7.998 | 84.741 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | libdeflate | 1166.7 | 0.6 | 29.3 | 2.877 | 7.126 | 67.556 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | Wuffs | 738.5 | 0.4 | 29.3 | 4.560 | 8.582 | 122.195 |
| decode | silesia/webster | 4194304 | 9 | 6 | each | stdx | 1172.4 | 2.2 | 29.3 | 2.809 | 5.783 | 86.909 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | zlib | 478.5 | 0.3 | 29.3 | 7.046 | 12.941 | 274.852 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | zlib-ng | 798.6 | 1.9 | 29.3 | 4.235 | 7.998 | 84.921 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | libdeflate | 1148.7 | 4.6 | 29.3 | 2.843 | 7.126 | 68.043 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | Wuffs | 738.1 | 1.5 | 29.3 | 4.580 | 8.582 | 122.997 |
| decode | silesia/webster | 4194304 | 9 | 6 | rotation | stdx | 1156.5 | 4.0 | 29.3 | 2.764 | 5.783 | 87.806 |
