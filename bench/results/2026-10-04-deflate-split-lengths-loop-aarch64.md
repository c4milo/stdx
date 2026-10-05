# bench-profile

| Field | Value |
|---|---|
| Commit | 8a95c0f |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37245299694 |
| Date | 2026-10-04 |

## Where a small body's gzip decode goes, gzip at zlib level 6

Each row's members, one a slice, are decoded one after another, each from a state started anew (decision 45). A numbered stage gives stdx's decoder every dynamic member cut at the same point of its block header; a stage's count less the one before it is what the part between the two cuts costs. Counts are a member's, the median of 5 runs, with the spread of the runs.

The CPU's features, as stdx detects them: .{ .pclmul = false, .avx2 = false, .avx512 = false, .vpclmul = false, .vnni = false, .bmi2 = false, .vpmullq_fast = false, .crc32 = true, .pmull = true, .dotprod = true, .madd_addend_slow = false }.

## http/html-1kx1024

1024 members, 38.0% of their slices: 1024 of one dynamic block, 388.8 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 415.7 bits, 13.4% of its member: HLIT + 257 is 276.0, HDIST + 1 is 19.4 and HCLEN + 4 is 15.2; 100.7 code length symbols, 10.3 of them repeats, give 63.5 literal/length codes of 8.4 bits at the longest and 13.8 distance codes of 5.8 bits. stdx's tables take 8.4 and 5.8 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 59.9 ± 0.4% | 759.0 | 155.0 | 0.10 ± 3.0% | 203.5 ± 0.3% |
| stdx, dynamic members: 2, through the code length code | 313.9 ± 0.1% | 3595.5 | 790.1 | 2.53 ± 0.7% | 1065.7 ± 0.1% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 686.1 ± 0.3% | 6360.0 | 1513.7 | 28.34 ± 4.3% | 2329.9 ± 0.9% |
| stdx, dynamic members: 4, through the block's header | 1839.3 ± 0.3% | 17410.0 | 4366.3 | 79.27 ± 0.8% | 6244.0 ± 0.1% |
| stdx, dynamic members: 5, whole, room past the slice | 2930.6 ± 0.3% | 22911.3 | 5203.8 | 151.59 ± 0.6% | 9942.6 ± 0.1% |
| stdx, dynamic members: 6, whole | 3282.2 ± 0.1% | 26874.4 | 6319.3 | 191.76 ± 0.1% | 11152.5 ± 0.1% |
| libdeflate, dynamic members: whole | 3194.8 ± 0.4% | 20537.1 | 3598.2 | 155.66 ± 0.7% | 10800.7 ± 0.2% |
| libdeflate, dynamic members: whole, room past the slice | 3052.0 ± 0.4% | 19990.5 | 3445.6 | 135.82 ± 0.3% | 10353.3 ± 0.1% |
| zlib-ng, dynamic members: whole | 3814.8 ± 0.7% | 29110.7 | 5439.9 | 215.10 ± 0.3% | 12916.5 ± 0.1% |
| zlib-ng, dynamic members: whole, room past the slice | 3463.7 ± 0.2% | 25078.4 | 4552.3 | 184.14 ± 0.7% | 11745.7 ± 0.2% |
| stdx, every member: whole | 3286.9 ± 0.2% | 26874.4 | 6319.3 | 190.10 ± 0.6% | 11136.7 ± 0.1% |
| libdeflate, every member: whole | 3184.4 ± 0.1% | 20537.1 | 3598.2 | 154.84 ± 0.8% | 10793.3 ± 0.2% |
| zlib-ng, every member: whole | 3813.2 ± 0.2% | 29110.7 | 5439.9 | 214.61 ± 0.6% | 12910.3 ± 0.2% |

## http/html-16kx64

64 members, 20.4% of their slices: 64 of one dynamic block, 3345.4 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 571.3 bits, 2.1% of its member: HLIT + 257 is 281.9, HDIST + 1 is 27.9 and HCLEN + 4 is 13.6; 136.8 code length symbols, 10.8 of them repeats, give 100.8 literal/length codes of 11.1 bits at the longest and 25.1 distance codes of 8.9 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 58.5 ± 0.5% | 759.5 | 155.1 | 0.13 ± 30.1% | 199.2 ± 0.8% |
| stdx, dynamic members: 2, through the code length code | 293.7 ± 0.5% | 3457.6 | 760.2 | 1.39 ± 3.1% | 996.5 ± 0.3% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 665.8 ± 0.5% | 6893.8 | 1647.1 | 4.91 ± 164.3% | 2269.9 ± 5.9% |
| stdx, dynamic members: 4, through the block's header | 1991.6 ± 0.6% | 21811.8 | 5468.5 | 30.51 ± 31.4% | 6780.3 ± 1.9% |
| stdx, dynamic members: 5, whole, room past the slice | 12850.2 ± 0.6% | 96469.0 | 18138.5 | 939.98 ± 1.6% | 43382.0 ± 0.8% |
| stdx, dynamic members: 6, whole | 13143.7 ± 0.5% | 99625.3 | 19056.0 | 976.04 ± 0.3% | 44590.5 ± 0.1% |
| libdeflate, dynamic members: whole | 12726.9 ± 0.6% | 99038.6 | 14952.4 | 948.93 ± 2.2% | 43101.7 ± 0.4% |
| libdeflate, dynamic members: whole, room past the slice | 12610.5 ± 0.1% | 98806.9 | 14882.9 | 930.21 ± 0.5% | 42787.7 ± 0.1% |
| zlib-ng, dynamic members: whole | 18473.6 ± 0.2% | 123546.2 | 20863.2 | 1343.65 ± 1.3% | 62554.9 ± 0.4% |
| zlib-ng, dynamic members: whole, room past the slice | 18203.4 ± 0.6% | 121227.3 | 20364.3 | 1319.80 ± 0.1% | 61761.7 ± 0.0% |
| stdx, every member: whole | 13160.4 ± 0.9% | 99625.3 | 19056.0 | 983.21 ± 2.6% | 44727.8 ± 0.7% |
| libdeflate, every member: whole | 12732.2 ± 0.2% | 99038.6 | 14952.4 | 950.80 ± 2.6% | 43111.1 ± 0.6% |
| zlib-ng, every member: whole | 18471.5 ± 0.1% | 123546.2 | 20863.2 | 1344.64 ± 1.2% | 62555.7 ± 0.3% |

## http/json-1kx1024

1024 members, 21.9% of their slices: 645 of one dynamic block, 256.0 octets each, and 379 of one fixed or stored block, 169.5 octets each. A dynamic block's header takes 374.1 bits, 18.3% of its member: HLIT + 257 is 275.2, HDIST + 1 is 19.2 and HCLEN + 4 is 17.0; 90.2 code length symbols, 10.9 of them repeats, give 54.7 literal/length codes of 7.5 bits at the longest and 11.6 distance codes of 5.5 bits. stdx's tables take 7.5 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 59.8 ± 0.4% | 753.1 | 153.0 | 0.12 ± 9.1% | 204.0 ± 0.5% |
| stdx, dynamic members: 2, through the code length code | 316.5 ± 0.2% | 3649.2 | 798.8 | 2.18 ± 3.1% | 1074.5 ± 0.1% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 659.2 ± 0.1% | 6212.8 | 1477.1 | 26.03 ± 6.6% | 2237.3 ± 1.1% |
| stdx, dynamic members: 4, through the block's header | 1754.3 ± 0.1% | 16526.2 | 4151.4 | 72.01 ± 1.9% | 5953.7 ± 0.3% |
| stdx, dynamic members: 5, whole, room past the slice | 2479.3 ± 0.4% | 20701.7 | 4790.2 | 118.92 ± 0.3% | 8407.6 ± 0.1% |
| stdx, dynamic members: 6, whole | 2718.2 ± 0.4% | 23791.7 | 5681.6 | 138.94 ± 0.2% | 9212.1 ± 0.1% |
| libdeflate, dynamic members: whole | 2677.2 ± 0.2% | 17637.8 | 3099.8 | 109.70 ± 2.4% | 9074.8 ± 0.5% |
| libdeflate, dynamic members: whole, room past the slice | 2631.4 ± 0.4% | 17359.7 | 3020.7 | 105.03 ± 0.6% | 8911.1 ± 0.1% |
| zlib-ng, dynamic members: whole | 3048.4 ± 0.3% | 23348.2 | 4482.8 | 176.74 ± 0.5% | 10332.5 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 2823.7 ± 0.7% | 20854.3 | 3923.7 | 155.89 ± 1.1% | 9585.5 ± 0.2% |
| stdx, fixed members: whole | 780.9 ± 0.1% | 7524.2 | 1636.6 | 35.71 ± 8.8% | 2654.7 ± 1.5% |
| libdeflate, fixed members: whole | 2584.1 ± 0.6% | 16236.8 | 2658.2 | 44.08 ± 9.2% | 8764.8 ± 0.6% |
| zlib-ng, fixed members: whole | 803.6 ± 0.2% | 6452.7 | 1177.7 | 41.38 ± 4.4% | 2725.8 ± 1.0% |
| stdx, fixed members: whole, room past the slice | 632.4 ± 0.5% | 5366.5 | 1005.9 | 28.34 ± 11.6% | 2153.9 ± 2.1% |
| stdx, every member: whole | 2024.5 ± 0.2% | 17770.8 | 4184.5 | 106.75 ± 0.6% | 6862.6 ± 0.1% |
| libdeflate, every member: whole | 2660.0 ± 0.6% | 17119.3 | 2936.3 | 91.57 ± 1.1% | 9016.6 ± 0.1% |
| zlib-ng, every member: whole | 2233.9 ± 0.2% | 17094.8 | 3259.5 | 130.63 ± 0.6% | 7581.4 ± 0.1% |

## http/json-16kx64

64 members, 12.8% of their slices: 64 of one dynamic block, 2092.7 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 497.0 bits, 3.0% of its member: HLIT + 257 is 280.7, HDIST + 1 is 27.7 and HCLEN + 4 is 15.3; 118.6 code length symbols, 10.7 of them repeats, give 83.8 literal/length codes of 10.1 bits at the longest and 22.2 distance codes of 8.6 bits. stdx's tables take 10.0 and 7.9 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 58.8 ± 0.1% | 753.5 | 153.1 | 0.14 ± 14.1% | 199.9 ± 0.4% |
| stdx, dynamic members: 2, through the code length code | 315.1 ± 0.1% | 3668.2 | 805.0 | 2.25 ± 7.1% | 1069.3 ± 0.3% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 626.9 ± 0.3% | 6674.4 | 1591.2 | 4.91 ± 164.8% | 2132.7 ± 6.1% |
| stdx, dynamic members: 4, through the block's header | 1844.7 ± 0.2% | 19930.8 | 5001.7 | 30.85 ± 35.0% | 6260.0 ± 2.6% |
| stdx, dynamic members: 5, whole, room past the slice | 9210.2 ± 0.2% | 71174.6 | 13504.7 | 624.98 ± 1.8% | 31169.4 ± 0.4% |
| stdx, dynamic members: 6, whole | 9379.3 ± 0.2% | 73600.4 | 14216.0 | 639.12 ± 0.8% | 31819.3 ± 0.2% |
| libdeflate, dynamic members: whole | 9122.6 ± 0.1% | 69469.7 | 10273.5 | 634.03 ± 2.7% | 30949.8 ± 0.8% |
| libdeflate, dynamic members: whole, room past the slice | 9076.8 ± 0.0% | 69338.0 | 10234.3 | 626.68 ± 0.5% | 30809.2 ± 0.2% |
| zlib-ng, dynamic members: whole | 12574.1 ± 0.2% | 90095.4 | 15569.9 | 803.31 ± 1.4% | 42566.3 ± 0.3% |
| zlib-ng, dynamic members: whole, room past the slice | 12390.0 ± 0.2% | 88716.1 | 15264.8 | 784.07 ± 0.3% | 42041.8 ± 0.1% |
| stdx, every member: whole | 9397.5 ± 0.2% | 73600.4 | 14216.0 | 643.58 ± 2.4% | 31860.0 ± 0.7% |
| libdeflate, every member: whole | 9123.8 ± 0.1% | 69469.7 | 10273.5 | 634.91 ± 3.1% | 30951.5 ± 0.5% |
| zlib-ng, every member: whole | 12562.7 ± 0.1% | 90095.4 | 15569.9 | 800.15 ± 1.5% | 42517.9 ± 0.4% |

## http/js-1kx1024

1024 members, 42.5% of their slices: 1023 of one dynamic block, 435.6 octets each, and 1 of one fixed or stored block, 159.0 octets each. A dynamic block's header takes 437.6 bits, 12.6% of its member: HLIT + 257 is 275.0, HDIST + 1 is 19.5 and HCLEN + 4 is 14.7; 108.8 code length symbols, 10.2 of them repeats, give 70.8 literal/length codes of 8.5 bits at the longest and 15.0 distance codes of 6.1 bits. stdx's tables take 8.5 and 6.1 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 59.7 ± 0.4% | 753.0 | 153.0 | 0.10 ± 8.7% | 202.6 ± 0.3% |
| stdx, dynamic members: 2, through the code length code | 308.9 ± 0.1% | 3555.8 | 781.1 | 2.30 ± 1.4% | 1047.8 ± 0.2% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 700.7 ± 0.4% | 6473.4 | 1541.6 | 28.20 ± 3.3% | 2378.8 ± 0.6% |
| stdx, dynamic members: 4, through the block's header | 1869.4 ± 0.4% | 17788.8 | 4459.5 | 81.26 ± 1.4% | 6343.2 ± 0.3% |
| stdx, dynamic members: 5, whole, room past the slice | 3158.9 ± 0.2% | 24342.2 | 5474.0 | 174.93 ± 0.5% | 10712.8 ± 0.2% |
| stdx, dynamic members: 6, whole | 3560.6 ± 0.1% | 28694.0 | 6695.1 | 222.16 ± 0.3% | 12082.0 ± 0.1% |
| libdeflate, dynamic members: whole | 3392.7 ± 0.1% | 22108.8 | 3856.9 | 178.14 ± 0.7% | 11487.5 ± 0.2% |
| libdeflate, dynamic members: whole, room past the slice | 3218.1 ± 0.0% | 21429.1 | 3665.7 | 153.08 ± 0.2% | 10913.6 ± 0.1% |
| zlib-ng, dynamic members: whole | 4153.9 ± 0.3% | 32028.9 | 5935.0 | 237.44 ± 0.3% | 14054.6 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 3736.2 ± 0.2% | 27200.8 | 4880.0 | 201.37 ± 0.4% | 12668.4 ± 0.1% |
| stdx, every member: whole | 3565.9 ± 0.2% | 28673.3 | 6690.2 | 221.31 ± 0.4% | 12065.1 ± 0.1% |
| libdeflate, every member: whole | 3392.4 ± 0.1% | 22103.0 | 3855.7 | 178.19 ± 0.7% | 11491.1 ± 0.1% |
| zlib-ng, every member: whole | 4152.0 ± 0.2% | 32003.6 | 5930.3 | 237.02 ± 0.6% | 14040.9 ± 0.1% |

## http/js-16kx64

64 members, 24.4% of their slices: 64 of one dynamic block, 3998.1 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 565.3 bits, 1.8% of its member: HLIT + 257 is 284.3, HDIST + 1 is 28.0 and HCLEN + 4 is 13.0; 142.6 code length symbols, 8.0 of them repeats, give 111.5 literal/length codes of 11.2 bits at the longest and 26.5 distance codes of 9.5 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 58.5 ± 0.3% | 753.5 | 153.1 | 0.13 ± 27.1% | 198.4 ± 0.7% |
| stdx, dynamic members: 2, through the code length code | 285.3 ± 0.1% | 3370.3 | 739.2 | 1.47 ± 6.5% | 970.1 ± 0.2% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 678.6 ± 0.2% | 7045.4 | 1678.1 | 4.91 ± 75.5% | 2307.3 ± 2.7% |
| stdx, dynamic members: 4, through the block's header | 2018.2 ± 0.3% | 22322.7 | 5592.4 | 24.95 ± 39.0% | 6847.3 ± 2.1% |
| stdx, dynamic members: 5, whole, room past the slice | 15080.1 ± 0.2% | 111890.7 | 20833.8 | 1142.39 ± 0.7% | 51125.5 ± 0.2% |
| stdx, dynamic members: 6, whole | 15406.7 ± 0.4% | 115373.4 | 21840.4 | 1178.95 ± 0.6% | 52355.4 ± 0.4% |
| libdeflate, dynamic members: whole | 14747.7 ± 0.1% | 114837.0 | 17336.8 | 1136.65 ± 1.5% | 49971.6 ± 0.5% |
| libdeflate, dynamic members: whole, room past the slice | 14599.2 ± 0.3% | 114472.6 | 17228.7 | 1111.17 ± 0.7% | 49530.6 ± 0.2% |
| zlib-ng, dynamic members: whole | 21064.7 ± 0.2% | 141708.1 | 23608.8 | 1459.88 ± 1.0% | 71317.2 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 20739.0 ± 0.2% | 138709.5 | 22968.6 | 1429.62 ± 0.1% | 70329.3 ± 0.1% |
| stdx, every member: whole | 15466.3 ± 2.6% | 115373.4 | 21840.4 | 1187.16 ± 0.7% | 52556.0 ± 0.2% |
| libdeflate, every member: whole | 14752.2 ± 0.1% | 114837.0 | 17336.8 | 1141.08 ± 2.1% | 49995.5 ± 0.4% |
| zlib-ng, every member: whole | 21047.9 ± 0.2% | 141708.1 | 23608.8 | 1459.06 ± 0.8% | 71304.2 ± 0.2% |

## http/css-1kx1024

1024 members, 27.8% of their slices: 1023 of one dynamic block, 285.0 octets each, and 1 of one fixed or stored block, 163.0 octets each. A dynamic block's header takes 359.8 bits, 15.8% of its member: HLIT + 257 is 275.3, HDIST + 1 is 18.9 and HCLEN + 4 is 16.0; 86.9 code length symbols, 8.5 of them repeats, give 55.7 literal/length codes of 7.6 bits at the longest and 11.8 distance codes of 5.5 bits. stdx's tables take 7.6 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 59.7 ± 0.1% | 753.0 | 153.0 | 0.10 ± 5.3% | 202.7 ± 0.5% |
| stdx, dynamic members: 2, through the code length code | 316.0 ± 0.5% | 3619.9 | 793.9 | 2.46 ± 1.1% | 1072.0 ± 0.1% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 653.7 ± 0.2% | 6205.2 | 1470.1 | 25.62 ± 4.7% | 2212.4 ± 0.8% |
| stdx, dynamic members: 4, through the block's header | 1713.3 ± 0.1% | 16585.2 | 4160.0 | 59.66 ± 1.6% | 5801.1 ± 0.2% |
| stdx, dynamic members: 5, whole, room past the slice | 2435.9 ± 0.2% | 20505.8 | 4739.4 | 103.29 ± 0.8% | 8256.0 ± 0.2% |
| stdx, dynamic members: 6, whole | 2729.8 ± 0.1% | 23863.9 | 5703.6 | 135.09 ± 0.2% | 9264.7 ± 0.1% |
| libdeflate, dynamic members: whole | 2759.9 ± 0.2% | 17790.6 | 3128.4 | 121.98 ± 0.6% | 9360.1 ± 0.1% |
| libdeflate, dynamic members: whole, room past the slice | 2685.4 ± 0.1% | 17484.5 | 3042.8 | 110.61 ± 0.6% | 9112.9 ± 0.1% |
| zlib-ng, dynamic members: whole | 3080.9 ± 0.3% | 23609.1 | 4510.4 | 169.47 ± 1.4% | 10425.8 ± 0.6% |
| zlib-ng, dynamic members: whole, room past the slice | 2825.1 ± 0.3% | 20963.3 | 3926.3 | 144.05 ± 0.6% | 9579.0 ± 0.1% |
| stdx, every member: whole | 2729.8 ± 0.2% | 23847.3 | 5699.5 | 135.31 ± 0.8% | 9256.8 ± 0.1% |
| libdeflate, every member: whole | 2761.8 ± 0.1% | 17788.8 | 3127.9 | 121.76 ± 0.7% | 9357.0 ± 0.1% |
| zlib-ng, every member: whole | 3075.2 ± 0.1% | 23591.7 | 4507.0 | 169.09 ± 1.2% | 10424.3 ± 0.2% |

## http/css-16kx64

64 members, 14.7% of their slices: 64 of one dynamic block, 2404.3 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 481.7 bits, 2.5% of its member: HLIT + 257 is 281.6, HDIST + 1 is 27.4 and HCLEN + 4 is 13.9; 113.7 code length symbols, 9.8 of them repeats, give 80.4 literal/length codes of 10.5 bits at the longest and 24.4 distance codes of 9.3 bits. stdx's tables take 10.5 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 58.6 ± 0.3% | 753.5 | 153.1 | 0.13 ± 15.3% | 199.3 ± 0.7% |
| stdx, dynamic members: 2, through the code length code | 296.8 ± 0.2% | 3477.5 | 763.9 | 1.78 ± 15.4% | 1008.8 ± 0.4% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 603.9 ± 0.2% | 6468.8 | 1542.9 | 4.34 ± 145.6% | 2051.5 ± 5.2% |
| stdx, dynamic members: 4, through the block's header | 1847.3 ± 0.3% | 20364.1 | 5102.1 | 25.33 ± 23.5% | 6274.0 ± 1.3% |
| stdx, dynamic members: 5, whole, room past the slice | 9011.4 ± 0.2% | 77735.8 | 14769.4 | 440.04 ± 4.5% | 30550.4 ± 0.8% |
| stdx, dynamic members: 6, whole | 9220.9 ± 0.1% | 80379.5 | 15550.1 | 458.29 ± 0.2% | 31295.5 ± 0.1% |
| libdeflate, dynamic members: whole | 9093.3 ± 0.0% | 76783.6 | 11534.2 | 465.18 ± 4.5% | 30786.0 ± 0.8% |
| libdeflate, dynamic members: whole, room past the slice | 9041.2 ± 0.1% | 76680.6 | 11503.9 | 458.01 ± 1.0% | 30665.2 ± 0.2% |
| zlib-ng, dynamic members: whole | 13365.3 ± 0.1% | 99463.8 | 17164.7 | 791.23 ± 1.7% | 45260.2 ± 0.4% |
| zlib-ng, dynamic members: whole, room past the slice | 13182.7 ± 0.2% | 98113.9 | 16871.8 | 773.70 ± 0.1% | 44739.7 ± 0.1% |
| stdx, every member: whole | 9235.1 ± 0.2% | 80379.5 | 15550.1 | 460.98 ± 3.7% | 31332.9 ± 0.7% |
| libdeflate, every member: whole | 9101.6 ± 0.3% | 76783.6 | 11534.2 | 469.74 ± 4.7% | 30855.8 ± 0.8% |
| zlib-ng, every member: whole | 13365.2 ± 0.1% | 99463.8 | 17164.7 | 793.06 ± 2.1% | 45281.2 ± 0.5% |
## What each piece of a dynamic block's header costs, called apart

Each piece runs once a member, in the members' order, on the code lengths of that member's block header or on its slice. Counts are a member's, the median of 5 runs, with the spread of the runs. A table's own cost is its row less the row of its code alone. The CRC-32 takes the path pmull.

## http/html-1kx1024

1024 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.8 ± 0.8% | 25.0 | 3.0 | 0.00 ± 29.4% | 12.6 ± 1.9% |
| the code length code built | 54.1 ± 0.5% | 666.2 | 180.4 | 0.65 ± 22.0% | 184.6 ± 1.1% |
| the literal/length code built | 664.7 ± 2.7% | 5376.4 | 1629.5 | 23.26 ± 9.1% | 2244.4 ± 2.6% |
| the literal/length code and its table built | 879.6 ± 1.4% | 8016.6 | 2187.0 | 35.47 ± 1.4% | 2970.0 ± 0.3% |
| the distance code built | 59.0 ± 0.2% | 727.8 | 197.6 | 0.96 ± 92.6% | 201.8 ± 6.3% |
| the distance code and its table built | 153.0 ± 0.3% | 2097.9 | 481.2 | 4.22 ± 12.1% | 519.9 ± 1.4% |
| the slice's CRC-32 | 38.0 ± 0.9% | 461.0 | 35.0 | 0.00 ± 9.1% | 128.5 ± 0.2% |
| the slice copied into the window | 29.7 ± 1.3% | 344.0 | 82.0 | 0.00 ± 42.1% | 101.3 ± 0.7% |

## http/html-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.8 ± 0.4% | 25.3 | 3.1 | 0.02 ± 23.5% | 12.6 ± 4.8% |
| the code length code built | 53.4 ± 0.6% | 692.8 | 187.7 | 0.30 ± 13.9% | 181.4 ± 1.6% |
| the literal/length code built | 578.1 ± 0.6% | 5881.3 | 1770.9 | 1.00 ± 61.8% | 1964.9 ± 1.0% |
| the literal/length code and its table built | 953.4 ± 0.9% | 10979.8 | 2904.9 | 7.27 ± 27.9% | 3232.3 ± 0.9% |
| the distance code built | 80.9 ± 0.4% | 988.2 | 274.0 | 0.51 ± 83.5% | 274.1 ± 4.9% |
| the distance code and its table built | 198.8 ± 0.2% | 2899.3 | 674.0 | 2.60 ± 17.5% | 679.4 ± 0.7% |
| the slice's CRC-32 | 491.2 ± 4.6% | 4788.3 | 112.1 | 0.02 ± 42.1% | 1599.7 ± 4.2% |
| the slice copied into the window | 399.7 ± 3.0% | 4184.3 | 1042.1 | 1.02 ± 0.8% | 1317.3 ± 2.1% |

## http/json-1kx1024

645 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.8 ± 0.9% | 25.0 | 3.0 | 0.00 ± 17.6% | 12.6 ± 0.6% |
| the code length code built | 52.9 ± 0.5% | 662.7 | 179.5 | 0.49 ± 49.5% | 180.9 ± 2.6% |
| the literal/length code built | 644.4 ± 1.1% | 5267.3 | 1599.2 | 18.22 ± 9.5% | 2183.2 ± 1.0% |
| the literal/length code and its table built | 822.6 ± 1.8% | 7518.4 | 2070.2 | 28.16 ± 2.7% | 2786.9 ± 0.4% |
| the distance code built | 55.2 ± 0.6% | 699.1 | 189.6 | 0.47 ± 155.4% | 188.4 ± 6.3% |
| the distance code and its table built | 144.3 ± 0.4% | 1996.3 | 458.6 | 3.56 ± 20.1% | 489.3 ± 2.3% |
| the slice's CRC-32 | 43.7 ± 0.7% | 461.0 | 35.0 | 0.00 ± 16.7% | 146.4 ± 2.6% |
| the slice copied into the window | 35.5 ± 1.5% | 341.0 | 81.0 | 0.00 ± 25.7% | 118.5 ± 0.6% |

## http/json-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.8 ± 0.9% | 25.3 | 3.1 | 0.02 ± 5.9% | 12.6 ± 0.7% |
| the code length code built | 52.4 ± 0.6% | 690.9 | 187.1 | 0.13 ± 66.4% | 178.0 ± 1.5% |
| the literal/length code built | 581.0 ± 2.4% | 5675.6 | 1714.0 | 1.22 ± 42.5% | 1992.3 ± 0.6% |
| the literal/length code and its table built | 864.2 ± 0.9% | 9653.1 | 2581.5 | 5.76 ± 71.3% | 2942.0 ± 2.7% |
| the distance code built | 71.4 ± 0.1% | 952.4 | 264.1 | 0.01 ± 5333.3% | 243.1 ± 2.7% |
| the distance code and its table built | 184.2 ± 0.5% | 2794.3 | 649.5 | 1.83 ± 76.5% | 631.8 ± 2.6% |
| the slice's CRC-32 | 484.7 ± 3.4% | 4788.3 | 112.1 | 0.02 ± 16.7% | 1613.1 ± 2.8% |
| the slice copied into the window | 409.6 ± 2.1% | 4181.3 | 1041.1 | 1.02 ± 0.4% | 1346.5 ± 3.3% |

## http/js-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.8 ± 0.5% | 25.0 | 3.0 | 0.00 ± 35.3% | 13.4 ± 1.0% |
| the code length code built | 54.2 ± 0.6% | 667.3 | 180.7 | 0.70 ± 14.3% | 185.0 ± 1.3% |
| the literal/length code built | 670.1 ± 1.9% | 5440.3 | 1646.2 | 26.26 ± 8.3% | 2286.5 ± 1.8% |
| the literal/length code and its table built | 893.7 ± 1.1% | 8220.5 | 2233.3 | 38.55 ± 2.3% | 3033.0 ± 0.7% |
| the distance code built | 59.9 ± 0.4% | 742.5 | 201.6 | 0.98 ± 53.0% | 204.9 ± 3.9% |
| the distance code and its table built | 155.9 ± 0.3% | 2165.9 | 496.1 | 4.15 ± 9.1% | 529.5 ± 1.4% |
| the slice's CRC-32 | 40.3 ± 2.3% | 461.0 | 35.0 | 0.00 ± 15.8% | 135.8 ± 5.5% |
| the slice copied into the window | 29.3 ± 1.2% | 341.0 | 81.0 | 0.00 ± 100.0% | 100.9 ± 1.8% |

## http/js-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.8 ± 0.5% | 25.3 | 3.1 | 0.02 ± 5.9% | 12.6 ± 0.9% |
| the code length code built | 52.4 ± 0.9% | 690.0 | 186.9 | 0.39 ± 20.0% | 179.1 ± 1.2% |
| the literal/length code built | 587.1 ± 1.3% | 6037.1 | 1814.9 | 0.89 ± 65.1% | 1995.2 ± 0.6% |
| the literal/length code and its table built | 979.2 ± 0.8% | 11365.4 | 2998.7 | 6.82 ± 28.1% | 3316.5 ± 1.2% |
| the distance code built | 82.7 ± 0.4% | 1003.6 | 278.2 | 0.30 ± 39.0% | 282.8 ± 2.5% |
| the distance code and its table built | 202.0 ± 0.2% | 2934.6 | 684.6 | 2.31 ± 17.4% | 685.0 ± 2.0% |
| the slice's CRC-32 | 510.6 ± 8.4% | 4788.3 | 112.1 | 0.02 ± 21.1% | 1625.0 ± 1.8% |
| the slice copied into the window | 407.6 ± 1.8% | 4181.3 | 1041.1 | 1.02 ± 0.5% | 1338.2 ± 1.7% |

## http/css-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.8 ± 0.5% | 25.0 | 3.0 | 0.00 ± 11.8% | 13.2 ± 2.0% |
| the code length code built | 53.5 ± 0.7% | 661.9 | 179.2 | 0.56 ± 30.9% | 182.3 ± 1.7% |
| the literal/length code built | 609.4 ± 2.1% | 5280.2 | 1602.8 | 8.28 ± 8.0% | 2049.9 ± 3.0% |
| the literal/length code and its table built | 805.2 ± 1.9% | 7627.2 | 2096.3 | 19.61 ± 3.5% | 2700.9 ± 0.5% |
| the distance code built | 56.8 ± 0.5% | 697.2 | 188.9 | 0.92 ± 78.2% | 194.6 ± 6.1% |
| the distance code and its table built | 147.1 ± 0.2% | 1997.8 | 458.5 | 4.20 ± 14.2% | 499.4 ± 1.8% |
| the slice's CRC-32 | 40.4 ± 1.5% | 461.0 | 35.0 | 0.00 ± 10.5% | 137.1 ± 1.3% |
| the slice copied into the window | 29.2 ± 1.0% | 341.0 | 81.0 | 0.00 ± 34.4% | 99.8 ± 1.7% |

## http/css-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.8 ± 0.5% | 25.3 | 3.1 | 0.02 ± 33.3% | 13.7 ± 7.4% |
| the code length code built | 52.1 ± 0.1% | 687.8 | 186.3 | 0.22 ± 24.5% | 178.2 ± 1.2% |
| the literal/length code built | 587.1 ± 1.3% | 5652.0 | 1708.2 | 1.40 ± 18.1% | 2004.8 ± 0.6% |
| the literal/length code and its table built | 900.0 ± 1.0% | 9985.7 | 2663.0 | 5.42 ± 41.2% | 3048.9 ± 1.4% |
| the distance code built | 74.9 ± 0.2% | 972.5 | 269.4 | 0.18 ± 88.6% | 256.2 ± 2.2% |
| the distance code and its table built | 190.5 ± 0.3% | 2858.2 | 666.7 | 2.03 ± 19.2% | 654.0 ± 1.1% |
| the slice's CRC-32 | 532.6 ± 12.4% | 4788.3 | 112.1 | 0.02 ± 22.2% | 1666.6 ± 1.7% |
| the slice copied into the window | 391.7 ± 0.6% | 4181.3 | 1041.1 | 1.02 ± 0.3% | 1315.7 ± 3.7% |
