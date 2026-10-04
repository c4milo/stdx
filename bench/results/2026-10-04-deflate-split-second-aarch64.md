# bench-profile

| Field | Value |
|---|---|
| Commit | e6ee392 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37240834498 |
| Date | 2026-10-04 |

## Where a small body's gzip decode goes, gzip at zlib level 6

Each row's members, one a slice, are decoded one after another, each from a state started anew (decision 45). A numbered stage gives stdx's decoder every dynamic member cut at the same point of its block header; a stage's count less the one before it is what the part between the two cuts costs. Counts are a member's, the median of 5 runs, with the spread of the runs.

The CPU's features, as stdx detects them: .{ .pclmul = false, .avx2 = false, .avx512 = false, .vpclmul = false, .vnni = false, .bmi2 = false, .vpmullq_fast = false, .crc32 = true, .pmull = true, .dotprod = true, .madd_addend_slow = false }.

## http/html-1kx1024

1024 members, 38.0% of their slices: 1024 of one dynamic block, 388.8 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 415.7 bits, 13.4% of its member: HLIT + 257 is 276.0, HDIST + 1 is 19.4 and HCLEN + 4 is 15.2; 100.7 code length symbols, 10.3 of them repeats, give 63.5 literal/length codes of 8.4 bits at the longest and 13.8 distance codes of 5.8 bits. stdx's tables take 8.4 and 5.8 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 62.6 ± 0.8% | 760.0 | 155.0 | 0.13 ± 8.7% | 212.8 ± 1.1% |
| stdx, dynamic members: 2, through the code length code | 357.0 ± 0.3% | 3892.1 | 840.7 | 3.44 ± 2.0% | 1211.0 ± 0.2% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1647.3 ± 0.2% | 19971.9 | 4686.9 | 74.84 ± 0.7% | 5579.9 ± 0.1% |
| stdx, dynamic members: 4, through the block's header | 2817.8 ± 0.3% | 31319.8 | 7612.9 | 127.97 ± 0.7% | 9560.3 ± 0.1% |
| stdx, dynamic members: 5, whole, room past the slice | 4072.7 ± 0.2% | 38601.7 | 8868.9 | 213.99 ± 0.3% | 13825.1 ± 0.1% |
| stdx, dynamic members: 6, whole | 4447.8 ± 0.2% | 42564.8 | 9984.3 | 257.49 ± 0.2% | 15094.9 ± 0.1% |
| libdeflate, dynamic members: whole | 3243.0 ± 0.2% | 20537.1 | 3598.2 | 155.23 ± 0.4% | 11013.5 ± 0.2% |
| libdeflate, dynamic members: whole, room past the slice | 3108.4 ± 0.4% | 19990.5 | 3445.6 | 135.16 ± 0.3% | 10545.3 ± 0.4% |
| zlib-ng, dynamic members: whole | 3817.8 ± 0.2% | 29110.7 | 5439.9 | 217.32 ± 0.5% | 12937.9 ± 0.1% |
| zlib-ng, dynamic members: whole, room past the slice | 3468.3 ± 0.2% | 25078.4 | 4552.3 | 187.52 ± 0.5% | 11769.6 ± 0.1% |
| stdx, every member: whole | 4453.5 ± 0.6% | 42564.8 | 9984.3 | 256.89 ± 0.3% | 15089.0 ± 0.1% |
| libdeflate, every member: whole | 3248.0 ± 0.9% | 20537.1 | 3598.2 | 154.69 ± 0.6% | 11001.0 ± 0.4% |
| zlib-ng, every member: whole | 3821.1 ± 0.6% | 29110.7 | 5439.9 | 217.22 ± 0.6% | 12934.1 ± 0.1% |

## http/html-16kx64

64 members, 20.4% of their slices: 64 of one dynamic block, 3345.4 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 571.3 bits, 2.1% of its member: HLIT + 257 is 281.9, HDIST + 1 is 27.9 and HCLEN + 4 is 13.6; 136.8 code length symbols, 10.8 of them repeats, give 100.8 literal/length codes of 11.1 bits at the longest and 25.1 distance codes of 8.9 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 61.7 ± 0.5% | 760.5 | 155.1 | 0.14 ± 32.4% | 208.8 ± 1.2% |
| stdx, dynamic members: 2, through the code length code | 325.9 ± 0.8% | 3667.9 | 796.0 | 1.89 ± 5.4% | 1107.4 ± 0.3% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1939.7 ± 0.5% | 26226.5 | 6174.5 | 67.12 ± 9.6% | 6567.6 ± 1.6% |
| stdx, dynamic members: 4, through the block's header | 3265.8 ± 0.3% | 41281.7 | 10029.2 | 97.11 ± 8.4% | 11096.2 ± 1.1% |
| stdx, dynamic members: 5, whole, room past the slice | 14393.9 ± 0.9% | 117731.8 | 23115.6 | 1024.85 ± 0.3% | 48838.4 ± 0.3% |
| stdx, dynamic members: 6, whole | 14675.8 ± 0.3% | 120888.1 | 24033.1 | 1049.18 ± 0.6% | 49731.6 ± 0.3% |
| libdeflate, dynamic members: whole | 12721.3 ± 0.1% | 99038.6 | 14952.4 | 945.23 ± 3.1% | 43143.0 ± 0.7% |
| libdeflate, dynamic members: whole, room past the slice | 12602.1 ± 0.1% | 98806.9 | 14882.9 | 923.56 ± 0.2% | 42800.5 ± 0.2% |
| zlib-ng, dynamic members: whole | 18518.9 ± 0.6% | 123546.2 | 20863.2 | 1360.02 ± 1.0% | 62784.9 ± 0.3% |
| zlib-ng, dynamic members: whole, room past the slice | 18253.0 ± 0.1% | 121227.3 | 20364.3 | 1332.90 ± 0.5% | 61936.8 ± 0.1% |
| stdx, every member: whole | 14678.5 ± 0.4% | 120888.1 | 24033.1 | 1048.23 ± 2.5% | 49633.4 ± 0.9% |
| libdeflate, every member: whole | 12719.4 ± 0.4% | 99038.6 | 14952.4 | 944.76 ± 2.6% | 43136.4 ± 0.6% |
| zlib-ng, every member: whole | 18522.7 ± 0.4% | 123546.2 | 20863.2 | 1359.22 ± 0.8% | 62776.2 ± 0.2% |

## http/json-1kx1024

1024 members, 21.9% of their slices: 645 of one dynamic block, 256.0 octets each, and 379 of one fixed or stored block, 169.5 octets each. A dynamic block's header takes 374.1 bits, 18.3% of its member: HLIT + 257 is 275.2, HDIST + 1 is 19.2 and HCLEN + 4 is 17.0; 90.2 code length symbols, 10.9 of them repeats, give 54.7 literal/length codes of 7.5 bits at the longest and 11.6 distance codes of 5.5 bits. stdx's tables take 7.5 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 62.6 ± 0.4% | 754.1 | 153.0 | 0.16 ± 10.1% | 212.8 ± 0.6% |
| stdx, dynamic members: 2, through the code length code | 374.5 ± 0.1% | 4062.3 | 872.6 | 3.62 ± 1.7% | 1271.1 ± 0.1% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1611.3 ± 0.2% | 18383.9 | 4299.7 | 82.70 ± 0.8% | 5465.4 ± 0.1% |
| stdx, dynamic members: 4, through the block's header | 2732.1 ± 0.5% | 29094.1 | 7070.6 | 131.05 ± 0.5% | 9279.8 ± 0.1% |
| stdx, dynamic members: 5, whole, room past the slice | 3617.1 ± 0.4% | 34952.7 | 8104.3 | 191.60 ± 0.4% | 12281.6 ± 0.1% |
| stdx, dynamic members: 6, whole | 3863.6 ± 0.4% | 38042.7 | 8995.8 | 213.31 ± 0.3% | 13119.4 ± 0.1% |
| libdeflate, dynamic members: whole | 2737.7 ± 0.4% | 17637.8 | 3099.8 | 109.85 ± 1.1% | 9271.6 ± 0.3% |
| libdeflate, dynamic members: whole, room past the slice | 2691.2 ± 0.3% | 17359.7 | 3020.7 | 104.63 ± 0.3% | 9106.8 ± 0.4% |
| zlib-ng, dynamic members: whole | 3037.5 ± 0.4% | 23348.2 | 4482.8 | 176.91 ± 0.9% | 10297.5 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 2814.0 ± 0.2% | 20854.3 | 3923.7 | 156.11 ± 0.3% | 9544.1 ± 0.1% |
| stdx, fixed members: whole | 781.6 ± 0.1% | 7532.3 | 1636.6 | 36.33 ± 7.1% | 2663.6 ± 1.3% |
| libdeflate, fixed members: whole | 2630.0 ± 0.2% | 16236.8 | 2658.2 | 43.13 ± 8.6% | 8906.9 ± 0.5% |
| zlib-ng, fixed members: whole | 805.5 ± 0.1% | 6452.7 | 1177.7 | 41.28 ± 3.6% | 2735.3 ± 0.7% |
| stdx, fixed members: whole, room past the slice | 632.9 ± 0.4% | 5374.7 | 1005.9 | 28.49 ± 10.1% | 2152.6 ± 1.8% |
| stdx, every member: whole | 2743.6 ± 0.2% | 26750.2 | 6272.0 | 151.99 ± 0.7% | 9295.7 ± 0.2% |
| libdeflate, every member: whole | 2712.9 ± 0.2% | 17119.3 | 2936.3 | 90.92 ± 0.7% | 9176.7 ± 0.3% |
| zlib-ng, every member: whole | 2231.4 ± 0.1% | 17094.8 | 3259.5 | 131.98 ± 0.6% | 7569.1 ± 0.1% |

## http/json-16kx64

64 members, 12.8% of their slices: 64 of one dynamic block, 2092.7 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 497.0 bits, 3.0% of its member: HLIT + 257 is 280.7, HDIST + 1 is 27.7 and HCLEN + 4 is 15.3; 118.6 code length symbols, 10.7 of them repeats, give 83.8 literal/length codes of 10.1 bits at the longest and 22.2 distance codes of 8.6 bits. stdx's tables take 10.0 and 7.9 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 61.7 ± 0.3% | 754.5 | 153.1 | 0.16 ± 29.8% | 209.2 ± 1.4% |
| stdx, dynamic members: 2, through the code length code | 355.6 ± 0.1% | 3931.2 | 849.5 | 3.16 ± 14.5% | 1208.1 ± 0.2% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1817.2 ± 0.3% | 23256.8 | 5463.0 | 75.05 ± 10.8% | 6181.7 ± 2.1% |
| stdx, dynamic members: 4, through the block's header | 3068.9 ± 0.4% | 36777.2 | 8936.8 | 107.59 ± 8.1% | 10413.4 ± 1.1% |
| stdx, dynamic members: 5, whole, room past the slice | 10573.9 ± 0.2% | 89760.2 | 17845.6 | 712.59 ± 1.0% | 35884.1 ± 0.2% |
| stdx, dynamic members: 6, whole | 10757.1 ± 0.1% | 92185.8 | 18556.9 | 726.48 ± 0.2% | 36508.0 ± 0.1% |
| libdeflate, dynamic members: whole | 9106.4 ± 0.2% | 69469.7 | 10273.5 | 614.76 ± 3.2% | 30881.3 ± 0.6% |
| libdeflate, dynamic members: whole, room past the slice | 9061.3 ± 0.2% | 69338.0 | 10234.3 | 608.11 ± 1.1% | 30742.4 ± 0.4% |
| zlib-ng, dynamic members: whole | 12564.7 ± 0.2% | 90095.4 | 15569.9 | 805.73 ± 1.5% | 42594.9 ± 0.4% |
| zlib-ng, dynamic members: whole, room past the slice | 12397.5 ± 0.1% | 88716.1 | 15264.8 | 787.43 ± 0.3% | 42067.3 ± 0.1% |
| stdx, every member: whole | 10764.0 ± 0.1% | 92185.8 | 18556.9 | 726.78 ± 1.9% | 36532.0 ± 0.5% |
| libdeflate, every member: whole | 9108.7 ± 0.1% | 69469.7 | 10273.5 | 614.28 ± 3.4% | 30877.3 ± 0.9% |
| zlib-ng, every member: whole | 12565.7 ± 0.1% | 90095.4 | 15569.9 | 807.23 ± 0.9% | 42618.7 ± 0.3% |

## http/js-1kx1024

1024 members, 42.5% of their slices: 1023 of one dynamic block, 435.6 octets each, and 1 of one fixed or stored block, 159.0 octets each. A dynamic block's header takes 437.6 bits, 12.6% of its member: HLIT + 257 is 275.0, HDIST + 1 is 19.5 and HCLEN + 4 is 14.7; 108.8 code length symbols, 10.2 of them repeats, give 70.8 literal/length codes of 8.5 bits at the longest and 15.0 distance codes of 6.1 bits. stdx's tables take 8.5 and 6.1 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 62.3 ± 1.3% | 754.0 | 153.0 | 0.15 ± 3.6% | 212.7 ± 0.6% |
| stdx, dynamic members: 2, through the code length code | 349.4 ± 0.1% | 3835.0 | 828.6 | 3.10 ± 1.6% | 1185.9 ± 0.1% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1731.2 ± 0.3% | 21140.1 | 4971.7 | 78.94 ± 0.5% | 5869.8 ± 0.1% |
| stdx, dynamic members: 4, through the block's header | 2911.3 ± 0.2% | 32738.4 | 7959.1 | 133.98 ± 1.3% | 9889.7 ± 0.3% |
| stdx, dynamic members: 5, whole, room past the slice | 4353.7 ± 0.1% | 41068.4 | 9391.0 | 238.58 ± 0.2% | 14771.0 ± 0.0% |
| stdx, dynamic members: 6, whole | 4774.6 ± 0.2% | 45420.2 | 10612.1 | 289.59 ± 0.2% | 16209.5 ± 0.1% |
| libdeflate, dynamic members: whole | 3452.0 ± 0.5% | 22108.8 | 3856.9 | 178.75 ± 0.9% | 11700.6 ± 0.3% |
| libdeflate, dynamic members: whole, room past the slice | 3277.2 ± 0.2% | 21429.1 | 3665.7 | 153.36 ± 0.2% | 11104.7 ± 0.1% |
| zlib-ng, dynamic members: whole | 4152.2 ± 0.1% | 32028.9 | 5935.0 | 239.02 ± 0.8% | 14049.1 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 3737.1 ± 0.1% | 27200.8 | 4880.0 | 203.26 ± 0.4% | 12668.3 ± 0.1% |
| stdx, every member: whole | 4781.9 ± 0.1% | 45383.3 | 10603.3 | 289.57 ± 0.4% | 16202.0 ± 0.1% |
| libdeflate, every member: whole | 3446.9 ± 0.1% | 22103.0 | 3855.7 | 178.05 ± 0.7% | 11678.3 ± 0.5% |
| zlib-ng, every member: whole | 4152.0 ± 0.1% | 32003.6 | 5930.3 | 239.30 ± 0.5% | 14041.7 ± 0.1% |

## http/js-16kx64

64 members, 24.4% of their slices: 64 of one dynamic block, 3998.1 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 565.3 bits, 1.8% of its member: HLIT + 257 is 284.3, HDIST + 1 is 28.0 and HCLEN + 4 is 13.0; 142.6 code length symbols, 8.0 of them repeats, give 111.5 literal/length codes of 11.2 bits at the longest and 26.5 distance codes of 9.5 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 61.2 ± 0.4% | 754.5 | 153.1 | 0.17 ± 30.7% | 208.1 ± 0.9% |
| stdx, dynamic members: 2, through the code length code | 315.9 ± 0.1% | 3573.2 | 775.2 | 1.70 ± 9.5% | 1074.3 ± 0.5% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1934.8 ± 0.2% | 26550.2 | 6271.7 | 63.96 ± 10.0% | 6556.9 ± 1.7% |
| stdx, dynamic members: 4, through the block's header | 3283.0 ± 0.5% | 42060.8 | 10242.3 | 89.86 ± 5.8% | 11145.2 ± 0.7% |
| stdx, dynamic members: 5, whole, room past the slice | 16549.3 ± 0.3% | 133452.5 | 25905.4 | 1218.96 ± 1.1% | 56089.3 ± 0.5% |
| stdx, dynamic members: 6, whole | 16882.0 ± 0.5% | 136934.8 | 26912.0 | 1258.60 ± 0.2% | 57406.3 ± 0.2% |
| libdeflate, dynamic members: whole | 14749.7 ± 0.1% | 114837.0 | 17336.8 | 1130.52 ± 2.3% | 50000.7 ± 0.5% |
| libdeflate, dynamic members: whole, room past the slice | 14589.2 ± 0.1% | 114472.6 | 17228.7 | 1099.52 ± 0.6% | 49498.2 ± 0.1% |
| zlib-ng, dynamic members: whole | 21086.3 ± 0.1% | 141708.1 | 23608.8 | 1473.64 ± 1.3% | 71543.3 ± 0.4% |
| zlib-ng, dynamic members: whole, room past the slice | 20764.4 ± 1.4% | 138709.5 | 22968.6 | 1436.30 ± 0.1% | 70419.6 ± 0.0% |
| stdx, every member: whole | 16940.8 ± 0.5% | 136934.8 | 26912.0 | 1259.03 ± 1.6% | 57375.4 ± 0.5% |
| libdeflate, every member: whole | 14758.0 ± 0.1% | 114837.0 | 17336.8 | 1125.89 ± 2.4% | 49955.3 ± 0.6% |
| zlib-ng, every member: whole | 21082.1 ± 0.2% | 141708.1 | 23608.8 | 1468.46 ± 0.7% | 71450.4 ± 0.2% |

## http/css-1kx1024

1024 members, 27.8% of their slices: 1023 of one dynamic block, 285.0 octets each, and 1 of one fixed or stored block, 163.0 octets each. A dynamic block's header takes 359.8 bits, 15.8% of its member: HLIT + 257 is 275.3, HDIST + 1 is 18.9 and HCLEN + 4 is 16.0; 86.9 code length symbols, 8.5 of them repeats, give 55.7 literal/length codes of 7.6 bits at the longest and 11.8 distance codes of 5.5 bits. stdx's tables take 7.6 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 62.2 ± 0.7% | 754.0 | 153.0 | 0.14 ± 6.0% | 211.0 ± 0.4% |
| stdx, dynamic members: 2, through the code length code | 365.4 ± 0.1% | 3971.8 | 855.0 | 3.61 ± 0.9% | 1241.0 ± 0.1% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1509.6 ± 0.2% | 17579.1 | 4115.0 | 73.26 ± 1.2% | 5126.9 ± 0.2% |
| stdx, dynamic members: 4, through the block's header | 2600.3 ± 0.1% | 28413.2 | 6915.4 | 110.02 ± 0.9% | 8816.1 ± 0.2% |
| stdx, dynamic members: 5, whole, room past the slice | 3501.5 ± 0.2% | 34092.2 | 7908.3 | 170.54 ± 0.4% | 11879.0 ± 0.1% |
| stdx, dynamic members: 6, whole | 3809.8 ± 0.1% | 37450.3 | 8872.6 | 203.95 ± 0.2% | 12921.5 ± 0.0% |
| libdeflate, dynamic members: whole | 2815.7 ± 0.2% | 17790.6 | 3128.4 | 120.57 ± 1.4% | 9565.8 ± 0.4% |
| libdeflate, dynamic members: whole, room past the slice | 2744.4 ± 0.3% | 17484.5 | 3042.8 | 108.80 ± 0.4% | 9299.1 ± 0.4% |
| zlib-ng, dynamic members: whole | 3078.2 ± 0.1% | 23609.1 | 4510.4 | 171.60 ± 1.1% | 10436.0 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 2821.8 ± 0.1% | 20963.3 | 3926.3 | 145.98 ± 0.3% | 9575.5 ± 0.1% |
| stdx, every member: whole | 3809.9 ± 0.1% | 37420.3 | 8865.4 | 203.85 ± 0.3% | 12908.9 ± 0.1% |
| libdeflate, every member: whole | 2818.7 ± 0.2% | 17788.8 | 3127.9 | 120.16 ± 0.9% | 9566.0 ± 0.4% |
| zlib-ng, every member: whole | 3075.5 ± 0.1% | 23591.7 | 4507.0 | 171.15 ± 1.3% | 10419.3 ± 0.3% |

## http/css-16kx64

64 members, 14.7% of their slices: 64 of one dynamic block, 2404.3 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 481.7 bits, 2.5% of its member: HLIT + 257 is 281.6, HDIST + 1 is 27.4 and HCLEN + 4 is 13.9; 113.7 code length symbols, 9.8 of them repeats, give 80.4 literal/length codes of 10.5 bits at the longest and 24.4 distance codes of 9.3 bits. stdx's tables take 10.5 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 61.4 ± 0.5% | 754.5 | 153.1 | 0.17 ± 27.3% | 210.8 ± 1.9% |
| stdx, dynamic members: 2, through the code length code | 331.5 ± 0.0% | 3703.7 | 802.3 | 2.36 ± 8.6% | 1127.9 ± 0.2% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1701.2 ± 0.3% | 22353.3 | 5253.6 | 63.40 ± 11.5% | 5781.1 ± 2.0% |
| stdx, dynamic members: 4, through the block's header | 2963.2 ± 0.2% | 36364.6 | 8841.4 | 90.57 ± 6.0% | 10066.4 ± 0.8% |
| stdx, dynamic members: 5, whole, room past the slice | 10290.5 ± 0.4% | 95520.0 | 18925.3 | 521.49 ± 3.1% | 34950.6 ± 0.5% |
| stdx, dynamic members: 6, whole | 10507.7 ± 0.3% | 98163.3 | 19705.9 | 538.30 ± 0.6% | 35672.3 ± 0.1% |
| libdeflate, dynamic members: whole | 9021.7 ± 0.1% | 76783.6 | 11534.2 | 423.12 ± 6.3% | 30561.1 ± 0.9% |
| libdeflate, dynamic members: whole, room past the slice | 8965.3 ± 0.3% | 76680.6 | 11503.9 | 414.84 ± 0.4% | 30434.8 ± 0.1% |
| zlib-ng, dynamic members: whole | 13341.2 ± 0.4% | 99463.8 | 17164.7 | 790.45 ± 2.4% | 45197.3 ± 0.6% |
| zlib-ng, dynamic members: whole, room past the slice | 13165.9 ± 0.2% | 98113.9 | 16871.8 | 772.83 ± 0.4% | 44697.5 ± 0.1% |
| stdx, every member: whole | 10520.4 ± 0.2% | 98163.3 | 19705.9 | 538.12 ± 3.2% | 35680.5 ± 0.5% |
| libdeflate, every member: whole | 9022.5 ± 0.1% | 76783.6 | 11534.2 | 423.69 ± 5.9% | 30598.2 ± 0.9% |
| zlib-ng, every member: whole | 13345.6 ± 0.2% | 99463.8 | 17164.7 | 788.64 ± 2.3% | 45184.9 ± 0.5% |
## What each piece of a dynamic block's header costs, called apart

Each piece runs once a member, in the members' order, on the code lengths of that member's block header or on its slice. Counts are a member's, the median of 5 runs, with the spread of the runs. A table's own cost is its row less the row of its code alone. The CRC-32 takes the path pmull.

## http/html-1kx1024

1024 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.6 ± 2.8% | 25.0 | 3.0 | 0.00 ± 23.5% | 12.2 ± 8.4% |
| the code length code built | 54.3 ± 0.6% | 666.2 | 180.4 | 0.64 ± 23.4% | 184.8 ± 1.3% |
| the literal/length code built | 666.7 ± 2.4% | 5376.4 | 1629.5 | 23.80 ± 9.2% | 2278.5 ± 1.6% |
| the literal/length code and its table built | 873.2 ± 1.6% | 8016.6 | 2187.0 | 35.10 ± 4.4% | 2996.2 ± 2.0% |
| the distance code built | 59.1 ± 0.5% | 727.8 | 197.6 | 0.98 ± 90.5% | 202.3 ± 6.3% |
| the distance code and its table built | 153.0 ± 0.4% | 2097.9 | 481.2 | 4.25 ± 11.2% | 517.3 ± 1.6% |
| the slice's CRC-32 | 37.2 ± 0.7% | 461.0 | 35.0 | 0.00 ± 5.3% | 126.6 ± 1.7% |
| the slice copied into the window | 29.2 ± 1.6% | 344.0 | 82.0 | 0.00 ± 51.7% | 99.6 ± 0.9% |

## http/html-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 0.8% | 25.3 | 3.1 | 0.02 ± 17.6% | 12.6 ± 9.1% |
| the code length code built | 53.8 ± 0.4% | 692.8 | 187.7 | 0.27 ± 14.6% | 182.2 ± 1.7% |
| the literal/length code built | 575.7 ± 0.7% | 5881.3 | 1770.9 | 1.07 ± 40.4% | 1950.6 ± 0.6% |
| the literal/length code and its table built | 951.2 ± 1.3% | 10979.8 | 2904.9 | 7.54 ± 24.1% | 3216.5 ± 0.9% |
| the distance code built | 81.4 ± 0.3% | 988.2 | 274.0 | 0.42 ± 66.6% | 278.1 ± 2.1% |
| the distance code and its table built | 198.8 ± 0.7% | 2899.3 | 674.0 | 2.48 ± 15.7% | 680.4 ± 1.8% |
| the slice's CRC-32 | 470.4 ± 2.9% | 4788.3 | 112.1 | 0.02 ± 16.7% | 1597.9 ± 2.7% |
| the slice copied into the window | 393.5 ± 1.1% | 4184.3 | 1042.1 | 1.02 ± 0.8% | 1310.6 ± 2.5% |

## http/json-1kx1024

645 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 2.4% | 25.0 | 3.0 | 0.00 ± 23.5% | 12.3 ± 11.2% |
| the code length code built | 53.2 ± 0.8% | 662.7 | 179.5 | 0.42 ± 66.8% | 179.8 ± 3.4% |
| the literal/length code built | 645.4 ± 2.2% | 5267.3 | 1599.2 | 18.96 ± 12.7% | 2219.8 ± 2.2% |
| the literal/length code and its table built | 825.3 ± 1.5% | 7518.4 | 2070.2 | 28.26 ± 3.0% | 2809.7 ± 0.8% |
| the distance code built | 55.3 ± 0.7% | 699.1 | 189.6 | 0.51 ± 120.6% | 190.0 ± 5.1% |
| the distance code and its table built | 144.0 ± 0.5% | 1996.3 | 458.6 | 3.51 ± 24.5% | 488.7 ± 2.6% |
| the slice's CRC-32 | 43.0 ± 1.2% | 461.0 | 35.0 | 0.00 ± 11.1% | 146.0 ± 2.1% |
| the slice copied into the window | 34.3 ± 0.9% | 341.0 | 81.0 | 0.00 ± 65.0% | 116.7 ± 1.1% |

## http/json-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 0.4% | 25.3 | 3.1 | 0.02 ± 23.5% | 12.6 ± 8.7% |
| the code length code built | 52.9 ± 0.6% | 690.9 | 187.1 | 0.25 ± 44.9% | 183.1 ± 2.1% |
| the literal/length code built | 579.8 ± 1.0% | 5675.6 | 1714.0 | 1.17 ± 75.4% | 1962.0 ± 0.8% |
| the literal/length code and its table built | 863.7 ± 0.9% | 9653.1 | 2581.5 | 6.96 ± 45.1% | 2934.3 ± 1.9% |
| the distance code built | 71.8 ± 0.5% | 952.4 | 264.1 | 0.24 ± 89.3% | 246.2 ± 0.9% |
| the distance code and its table built | 184.6 ± 0.3% | 2794.3 | 649.5 | 1.73 ± 81.2% | 631.1 ± 3.6% |
| the slice's CRC-32 | 474.4 ± 4.2% | 4788.3 | 112.1 | 0.03 ± 11.4% | 1566.9 ± 2.6% |
| the slice copied into the window | 389.8 ± 1.5% | 4181.3 | 1041.1 | 1.02 ± 0.3% | 1293.1 ± 0.7% |

## http/js-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 1.8% | 25.0 | 3.0 | 0.00 ± 11.8% | 12.5 ± 4.5% |
| the code length code built | 54.3 ± 0.3% | 667.3 | 180.7 | 0.71 ± 17.3% | 185.1 ± 1.2% |
| the literal/length code built | 681.2 ± 1.4% | 5440.3 | 1646.2 | 26.66 ± 8.3% | 2327.5 ± 0.7% |
| the literal/length code and its table built | 909.7 ± 1.7% | 8220.5 | 2233.3 | 38.22 ± 5.9% | 3074.4 ± 1.1% |
| the distance code built | 60.1 ± 0.6% | 742.5 | 201.6 | 0.97 ± 56.6% | 205.5 ± 3.9% |
| the distance code and its table built | 156.0 ± 0.2% | 2165.9 | 496.1 | 4.16 ± 11.2% | 529.4 ± 1.3% |
| the slice's CRC-32 | 39.7 ± 0.7% | 461.0 | 35.0 | 0.00 ± 17.6% | 133.5 ± 1.8% |
| the slice copied into the window | 29.1 ± 0.4% | 341.0 | 81.0 | 0.00 ± 29.7% | 100.1 ± 0.8% |

## http/js-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 1.1% | 25.3 | 3.1 | 0.02 ± 16.7% | 12.7 ± 13.2% |
| the code length code built | 52.9 ± 0.4% | 690.0 | 186.9 | 0.36 ± 24.1% | 182.6 ± 3.0% |
| the literal/length code built | 587.1 ± 0.9% | 6037.1 | 1814.9 | 1.09 ± 71.9% | 1990.4 ± 1.5% |
| the literal/length code and its table built | 974.4 ± 0.8% | 11365.4 | 2998.7 | 6.81 ± 33.5% | 3300.6 ± 1.5% |
| the distance code built | 83.6 ± 0.7% | 1003.6 | 278.2 | 0.31 ± 70.6% | 283.4 ± 1.9% |
| the distance code and its table built | 202.0 ± 0.2% | 2934.6 | 684.6 | 2.29 ± 33.5% | 688.0 ± 1.6% |
| the slice's CRC-32 | 514.4 ± 6.6% | 4788.3 | 112.1 | 0.02 ± 50.0% | 1596.7 ± 0.6% |
| the slice copied into the window | 387.0 ± 0.8% | 4181.3 | 1041.1 | 1.02 ± 0.6% | 1289.3 ± 0.8% |

## http/css-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 0.5% | 25.0 | 3.0 | 0.00 ± 11.8% | 12.2 ± 5.1% |
| the code length code built | 53.6 ± 0.9% | 661.9 | 179.2 | 0.58 ± 40.0% | 182.7 ± 2.5% |
| the literal/length code built | 605.6 ± 1.1% | 5280.2 | 1602.8 | 8.21 ± 7.5% | 2094.4 ± 0.5% |
| the literal/length code and its table built | 799.2 ± 1.0% | 7627.2 | 2096.3 | 19.34 ± 2.9% | 2735.3 ± 0.4% |
| the distance code built | 57.0 ± 0.5% | 697.2 | 188.9 | 0.92 ± 104.3% | 195.1 ± 7.2% |
| the distance code and its table built | 147.0 ± 0.5% | 1997.8 | 458.5 | 4.27 ± 14.0% | 500.1 ± 2.1% |
| the slice's CRC-32 | 40.0 ± 1.7% | 461.0 | 35.0 | 0.00 ± 13.2% | 135.8 ± 1.4% |
| the slice copied into the window | 28.9 ± 1.1% | 341.0 | 81.0 | 0.00 ± 57.1% | 98.5 ± 0.6% |

## http/css-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 0.8% | 25.3 | 3.1 | 0.02 ± 5.6% | 12.5 ± 6.8% |
| the code length code built | 52.7 ± 0.5% | 687.8 | 186.3 | 0.27 ± 16.8% | 180.1 ± 0.6% |
| the literal/length code built | 589.9 ± 0.4% | 5652.0 | 1708.2 | 1.17 ± 49.0% | 2006.5 ± 0.7% |
| the literal/length code and its table built | 900.0 ± 0.8% | 9985.7 | 2663.0 | 5.81 ± 45.9% | 3050.4 ± 1.7% |
| the distance code built | 75.1 ± 0.1% | 972.5 | 269.4 | 0.19 ± 74.6% | 255.9 ± 1.6% |
| the distance code and its table built | 191.6 ± 0.4% | 2858.2 | 666.7 | 1.94 ± 47.7% | 648.0 ± 2.5% |
| the slice's CRC-32 | 507.4 ± 8.0% | 4788.3 | 112.1 | 0.02 ± 50.0% | 1558.7 ± 4.5% |
| the slice copied into the window | 385.3 ± 1.5% | 4181.3 | 1041.1 | 1.02 ± 0.8% | 1301.8 ± 1.7% |
