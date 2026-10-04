# bench-profile

| Field | Value |
|---|---|
| Commit | fa00b10 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37240035013 |
| Date | 2026-10-04 |

## Where a small body's gzip decode goes, gzip at zlib level 6

Each row's members, one a slice, are decoded one after another, each from a state started anew (decision 45). A numbered stage gives stdx's decoder every dynamic member cut at the same point of its block header; a stage's count less the one before it is what the part between the two cuts costs. Counts are a member's, the median of 5 runs, with the spread of the runs.

The CPU's features, as stdx detects them: .{ .pclmul = false, .avx2 = false, .avx512 = false, .vpclmul = false, .vnni = false, .bmi2 = false, .vpmullq_fast = false, .crc32 = true, .pmull = true, .dotprod = true, .madd_addend_slow = false }.

## http/html-1kx1024

1024 members, 38.0% of their slices: 1024 of one dynamic block, 388.8 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 415.7 bits, 13.4% of its member: HLIT + 257 is 276.0, HDIST + 1 is 19.4 and HCLEN + 4 is 15.2; 100.7 code length symbols, 10.3 of them repeats, give 63.5 literal/length codes of 8.4 bits at the longest and 13.8 distance codes of 5.8 bits. stdx's tables take 8.4 and 5.8 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 61.9 ± 0.8% | 760.0 | 155.0 | 0.12 ± 6.4% | 210.0 ± 0.2% |
| stdx, dynamic members: 2, through the code length code | 356.3 ± 0.2% | 3892.1 | 840.7 | 3.40 ± 2.8% | 1208.6 ± 0.4% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1636.3 ± 0.2% | 19971.9 | 4686.9 | 75.14 ± 0.6% | 5547.2 ± 0.1% |
| stdx, dynamic members: 4, through the block's header | 2812.9 ± 0.2% | 31319.8 | 7612.9 | 127.15 ± 0.7% | 9535.6 ± 0.2% |
| stdx, dynamic members: 5, whole, room past the slice | 4064.6 ± 0.2% | 38611.9 | 8868.9 | 212.05 ± 0.4% | 13786.1 ± 0.1% |
| stdx, dynamic members: 6, whole | 4447.6 ± 0.1% | 42575.0 | 9984.3 | 256.50 ± 0.2% | 15083.0 ± 0.1% |
| libdeflate, dynamic members: whole | 3239.6 ± 0.4% | 20537.1 | 3598.2 | 154.92 ± 1.0% | 10964.8 ± 0.1% |
| libdeflate, dynamic members: whole, room past the slice | 3105.4 ± 0.2% | 19990.5 | 3445.6 | 135.09 ± 0.3% | 10521.8 ± 0.2% |
| zlib-ng, dynamic members: whole | 3826.8 ± 0.2% | 29110.7 | 5439.9 | 217.57 ± 0.5% | 12945.5 ± 0.1% |
| zlib-ng, dynamic members: whole, room past the slice | 3470.1 ± 0.2% | 25078.4 | 4552.3 | 186.77 ± 0.3% | 11756.1 ± 0.1% |
| stdx, every member: whole | 4453.8 ± 0.1% | 42575.0 | 9984.3 | 256.37 ± 0.4% | 15081.9 ± 0.1% |
| libdeflate, every member: whole | 3235.3 ± 0.3% | 20537.1 | 3598.2 | 155.16 ± 0.6% | 10969.3 ± 0.2% |
| zlib-ng, every member: whole | 3843.7 ± 0.6% | 29110.7 | 5439.9 | 217.01 ± 0.2% | 12941.7 ± 0.1% |

## http/html-16kx64

64 members, 20.4% of their slices: 64 of one dynamic block, 3345.4 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 571.3 bits, 2.1% of its member: HLIT + 257 is 281.9, HDIST + 1 is 27.9 and HCLEN + 4 is 13.6; 136.8 code length symbols, 10.8 of them repeats, give 100.8 literal/length codes of 11.1 bits at the longest and 25.1 distance codes of 8.9 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 60.5 ± 0.5% | 760.5 | 155.1 | 0.14 ± 18.0% | 206.1 ± 1.3% |
| stdx, dynamic members: 2, through the code length code | 325.8 ± 0.2% | 3667.9 | 796.0 | 1.73 ± 7.8% | 1107.6 ± 0.4% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1924.3 ± 0.6% | 26226.5 | 6174.5 | 66.55 ± 9.8% | 6526.0 ± 1.7% |
| stdx, dynamic members: 4, through the block's header | 3262.9 ± 0.2% | 41281.7 | 10029.2 | 96.60 ± 8.2% | 11073.6 ± 1.0% |
| stdx, dynamic members: 5, whole, room past the slice | 14143.6 ± 0.7% | 117770.1 | 23115.6 | 1003.37 ± 1.5% | 47927.7 ± 0.6% |
| stdx, dynamic members: 6, whole | 14448.2 ± 1.7% | 120926.1 | 24033.1 | 1034.60 ± 1.8% | 49010.9 ± 1.1% |
| libdeflate, dynamic members: whole | 12724.2 ± 0.2% | 99038.6 | 14952.4 | 945.04 ± 3.1% | 43072.3 ± 0.7% |
| libdeflate, dynamic members: whole, room past the slice | 12605.1 ± 0.2% | 98806.9 | 14882.9 | 926.56 ± 0.8% | 42773.0 ± 0.2% |
| zlib-ng, dynamic members: whole | 18531.4 ± 0.1% | 123546.2 | 20863.2 | 1367.17 ± 1.0% | 62797.0 ± 0.3% |
| zlib-ng, dynamic members: whole, room past the slice | 18282.0 ± 0.5% | 121227.3 | 20364.3 | 1348.25 ± 0.7% | 62051.2 ± 0.2% |
| stdx, every member: whole | 14530.9 ± 0.9% | 120926.1 | 24033.1 | 1036.22 ± 1.6% | 48992.8 ± 0.5% |
| libdeflate, every member: whole | 12732.3 ± 0.2% | 99038.6 | 14952.4 | 949.63 ± 2.5% | 43144.9 ± 0.6% |
| zlib-ng, every member: whole | 18517.0 ± 0.1% | 123546.2 | 20863.2 | 1369.22 ± 1.1% | 62825.1 ± 0.3% |

## http/json-1kx1024

1024 members, 21.9% of their slices: 645 of one dynamic block, 256.0 octets each, and 379 of one fixed or stored block, 169.5 octets each. A dynamic block's header takes 374.1 bits, 18.3% of its member: HLIT + 257 is 275.2, HDIST + 1 is 19.2 and HCLEN + 4 is 17.0; 90.2 code length symbols, 10.9 of them repeats, give 54.7 literal/length codes of 7.5 bits at the longest and 11.6 distance codes of 5.5 bits. stdx's tables take 7.5 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 61.9 ± 0.2% | 754.1 | 153.0 | 0.14 ± 3.9% | 210.2 ± 0.3% |
| stdx, dynamic members: 2, through the code length code | 374.0 ± 0.4% | 4062.3 | 872.6 | 3.63 ± 1.2% | 1269.0 ± 0.1% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1599.0 ± 0.1% | 18383.9 | 4299.7 | 81.79 ± 1.8% | 5422.0 ± 0.3% |
| stdx, dynamic members: 4, through the block's header | 2731.1 ± 0.3% | 29094.1 | 7070.6 | 129.80 ± 0.7% | 9242.9 ± 0.2% |
| stdx, dynamic members: 5, whole, room past the slice | 3619.4 ± 0.2% | 34970.0 | 8104.3 | 192.14 ± 0.7% | 12270.6 ± 0.2% |
| stdx, dynamic members: 6, whole | 3862.7 ± 0.3% | 38060.0 | 8995.8 | 214.20 ± 0.5% | 13115.1 ± 0.1% |
| libdeflate, dynamic members: whole | 2735.0 ± 0.5% | 17637.8 | 3099.8 | 110.56 ± 1.5% | 9279.6 ± 0.3% |
| libdeflate, dynamic members: whole, room past the slice | 2689.0 ± 0.4% | 17359.7 | 3020.7 | 105.72 ± 0.8% | 9122.0 ± 0.4% |
| zlib-ng, dynamic members: whole | 3041.3 ± 0.3% | 23348.2 | 4482.8 | 175.82 ± 0.5% | 10303.7 ± 0.1% |
| zlib-ng, dynamic members: whole, room past the slice | 2812.6 ± 0.2% | 20854.3 | 3923.7 | 154.58 ± 0.3% | 9534.5 ± 0.1% |
| stdx, fixed members: whole | 784.1 ± 0.2% | 7550.7 | 1636.6 | 35.94 ± 7.8% | 2665.1 ± 1.4% |
| libdeflate, fixed members: whole | 2641.7 ± 0.3% | 16236.8 | 2658.2 | 42.92 ± 7.9% | 8962.1 ± 0.7% |
| zlib-ng, fixed members: whole | 808.5 ± 0.2% | 6452.7 | 1177.7 | 42.56 ± 4.2% | 2744.3 ± 0.9% |
| stdx, fixed members: whole, room past the slice | 633.8 ± 0.3% | 5393.0 | 1005.9 | 28.69 ± 9.6% | 2158.8 ± 1.7% |
| stdx, every member: whole | 2745.4 ± 0.2% | 26768.0 | 6272.0 | 152.88 ± 0.2% | 9305.7 ± 0.1% |
| libdeflate, every member: whole | 2716.7 ± 0.2% | 17119.3 | 2936.3 | 91.70 ± 0.5% | 9208.9 ± 0.3% |
| zlib-ng, every member: whole | 2233.1 ± 0.2% | 17094.8 | 3259.5 | 130.70 ± 0.2% | 7564.5 ± 0.2% |

## http/json-16kx64

64 members, 12.8% of their slices: 64 of one dynamic block, 2092.7 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 497.0 bits, 3.0% of its member: HLIT + 257 is 280.7, HDIST + 1 is 27.7 and HCLEN + 4 is 15.3; 118.6 code length symbols, 10.7 of them repeats, give 83.8 literal/length codes of 10.1 bits at the longest and 22.2 distance codes of 8.6 bits. stdx's tables take 10.0 and 7.9 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 61.1 ± 1.5% | 754.5 | 153.1 | 0.16 ± 27.1% | 208.2 ± 0.7% |
| stdx, dynamic members: 2, through the code length code | 356.3 ± 0.1% | 3931.2 | 849.5 | 3.08 ± 5.7% | 1209.4 ± 0.4% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1805.8 ± 0.3% | 23256.8 | 5463.0 | 76.17 ± 10.1% | 6165.4 ± 2.0% |
| stdx, dynamic members: 4, through the block's header | 3067.5 ± 0.4% | 36777.2 | 8936.8 | 109.48 ± 6.9% | 10434.2 ± 0.9% |
| stdx, dynamic members: 5, whole, room past the slice | 10566.8 ± 0.2% | 89791.0 | 17845.6 | 714.61 ± 0.9% | 35851.3 ± 0.2% |
| stdx, dynamic members: 6, whole | 10741.7 ± 0.2% | 92216.1 | 18556.9 | 728.82 ± 0.1% | 36382.3 ± 0.3% |
| libdeflate, dynamic members: whole | 9107.4 ± 0.1% | 69469.7 | 10273.5 | 618.91 ± 3.1% | 30893.2 ± 0.6% |
| libdeflate, dynamic members: whole, room past the slice | 9064.3 ± 0.1% | 69338.0 | 10234.3 | 610.32 ± 0.4% | 30728.0 ± 0.1% |
| zlib-ng, dynamic members: whole | 12572.2 ± 0.2% | 90095.4 | 15569.9 | 809.51 ± 1.1% | 42585.1 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 12402.9 ± 0.5% | 88716.1 | 15264.8 | 791.86 ± 0.7% | 42058.4 ± 0.2% |
| stdx, every member: whole | 10747.8 ± 0.2% | 92216.1 | 18556.9 | 728.14 ± 1.6% | 36488.4 ± 0.5% |
| libdeflate, every member: whole | 9108.8 ± 0.1% | 69469.7 | 10273.5 | 618.51 ± 2.6% | 30890.7 ± 0.6% |
| zlib-ng, every member: whole | 12567.8 ± 0.1% | 90095.4 | 15569.9 | 808.08 ± 1.3% | 42569.7 ± 0.3% |

## http/js-1kx1024

1024 members, 42.5% of their slices: 1023 of one dynamic block, 435.6 octets each, and 1 of one fixed or stored block, 159.0 octets each. A dynamic block's header takes 437.6 bits, 12.6% of its member: HLIT + 257 is 275.0, HDIST + 1 is 19.5 and HCLEN + 4 is 14.7; 108.8 code length symbols, 10.2 of them repeats, give 70.8 literal/length codes of 8.5 bits at the longest and 15.0 distance codes of 6.1 bits. stdx's tables take 8.5 and 6.1 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 61.6 ± 0.7% | 754.0 | 153.0 | 0.12 ± 10.1% | 209.0 ± 0.3% |
| stdx, dynamic members: 2, through the code length code | 348.9 ± 0.1% | 3835.0 | 828.6 | 3.06 ± 1.6% | 1183.1 ± 0.0% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1720.2 ± 0.1% | 21140.1 | 4971.7 | 79.15 ± 0.4% | 5834.2 ± 0.1% |
| stdx, dynamic members: 4, through the block's header | 2909.6 ± 0.2% | 32738.4 | 7959.1 | 133.37 ± 0.7% | 9865.7 ± 0.2% |
| stdx, dynamic members: 5, whole, room past the slice | 4352.6 ± 0.1% | 41078.9 | 9391.0 | 239.78 ± 0.8% | 14759.8 ± 0.0% |
| stdx, dynamic members: 6, whole | 4780.7 ± 0.1% | 45430.7 | 10612.1 | 290.73 ± 0.5% | 16217.0 ± 0.1% |
| libdeflate, dynamic members: whole | 3449.6 ± 0.2% | 22108.8 | 3856.9 | 178.49 ± 0.6% | 11682.7 ± 0.1% |
| libdeflate, dynamic members: whole, room past the slice | 3277.2 ± 0.3% | 21429.1 | 3665.7 | 152.89 ± 0.4% | 11090.3 ± 0.1% |
| zlib-ng, dynamic members: whole | 4158.5 ± 0.5% | 32028.9 | 5935.0 | 238.93 ± 0.5% | 14064.5 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 3733.5 ± 0.4% | 27200.8 | 4880.0 | 201.54 ± 0.4% | 12642.1 ± 0.1% |
| stdx, every member: whole | 4786.7 ± 0.1% | 45393.8 | 10603.3 | 290.50 ± 0.5% | 16208.9 ± 0.1% |
| libdeflate, every member: whole | 3447.4 ± 0.4% | 22103.0 | 3855.7 | 178.99 ± 0.6% | 11689.5 ± 0.3% |
| zlib-ng, every member: whole | 4150.6 ± 0.1% | 32003.6 | 5930.3 | 239.06 ± 0.7% | 14055.0 ± 0.1% |

## http/js-16kx64

64 members, 24.4% of their slices: 64 of one dynamic block, 3998.1 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 565.3 bits, 1.8% of its member: HLIT + 257 is 284.3, HDIST + 1 is 28.0 and HCLEN + 4 is 13.0; 142.6 code length symbols, 8.0 of them repeats, give 111.5 literal/length codes of 11.2 bits at the longest and 26.5 distance codes of 9.5 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 60.4 ± 0.1% | 754.5 | 153.1 | 0.14 ± 27.7% | 205.9 ± 1.0% |
| stdx, dynamic members: 2, through the code length code | 316.0 ± 0.1% | 3573.2 | 775.2 | 1.71 ± 10.3% | 1074.2 ± 0.5% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1922.9 ± 0.2% | 26550.2 | 6271.7 | 65.88 ± 9.2% | 6554.8 ± 1.6% |
| stdx, dynamic members: 4, through the block's header | 3283.9 ± 0.2% | 42060.8 | 10242.3 | 90.47 ± 9.1% | 11146.7 ± 1.0% |
| stdx, dynamic members: 5, whole, room past the slice | 16577.1 ± 0.3% | 133522.6 | 25905.4 | 1226.60 ± 0.6% | 56267.9 ± 0.1% |
| stdx, dynamic members: 6, whole | 16915.0 ± 0.2% | 137004.0 | 26912.0 | 1261.89 ± 0.9% | 57420.8 ± 0.5% |
| libdeflate, dynamic members: whole | 14742.9 ± 0.1% | 114837.0 | 17336.8 | 1131.71 ± 2.9% | 49930.6 ± 0.7% |
| libdeflate, dynamic members: whole, room past the slice | 14590.5 ± 0.1% | 114472.6 | 17228.7 | 1108.13 ± 0.5% | 49496.2 ± 0.1% |
| zlib-ng, dynamic members: whole | 21201.5 ± 0.1% | 141708.1 | 23608.8 | 1481.73 ± 0.8% | 71798.1 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 20890.9 ± 0.1% | 138709.5 | 22968.6 | 1452.26 ± 0.3% | 70807.0 ± 0.1% |
| stdx, every member: whole | 16948.8 ± 0.2% | 137004.0 | 26912.0 | 1263.10 ± 0.9% | 57442.4 ± 0.3% |
| libdeflate, every member: whole | 14742.9 ± 0.1% | 114837.0 | 17336.8 | 1134.64 ± 2.3% | 49959.0 ± 0.5% |
| zlib-ng, every member: whole | 21204.8 ± 0.2% | 141708.1 | 23608.8 | 1485.14 ± 0.8% | 71870.8 ± 0.2% |

## http/css-1kx1024

1024 members, 27.8% of their slices: 1023 of one dynamic block, 285.0 octets each, and 1 of one fixed or stored block, 163.0 octets each. A dynamic block's header takes 359.8 bits, 15.8% of its member: HLIT + 257 is 275.3, HDIST + 1 is 18.9 and HCLEN + 4 is 16.0; 86.9 code length symbols, 8.5 of them repeats, give 55.7 literal/length codes of 7.6 bits at the longest and 11.8 distance codes of 5.5 bits. stdx's tables take 7.6 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 61.5 ± 1.1% | 754.0 | 153.0 | 0.12 ± 2.1% | 208.9 ± 0.1% |
| stdx, dynamic members: 2, through the code length code | 365.0 ± 0.1% | 3971.8 | 855.0 | 3.59 ± 1.5% | 1238.7 ± 0.1% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1499.9 ± 0.1% | 17579.1 | 4115.0 | 72.84 ± 0.4% | 5088.5 ± 0.1% |
| stdx, dynamic members: 4, through the block's header | 2603.5 ± 0.2% | 28413.2 | 6915.4 | 111.22 ± 0.5% | 8821.0 ± 0.1% |
| stdx, dynamic members: 5, whole, room past the slice | 3506.1 ± 0.2% | 34103.4 | 7908.3 | 171.03 ± 0.5% | 11879.7 ± 0.1% |
| stdx, dynamic members: 6, whole | 3813.3 ± 0.1% | 37461.5 | 8872.6 | 204.88 ± 0.1% | 12925.6 ± 0.0% |
| libdeflate, dynamic members: whole | 2820.1 ± 0.2% | 17790.6 | 3128.4 | 120.50 ± 1.1% | 9529.7 ± 0.4% |
| libdeflate, dynamic members: whole, room past the slice | 2742.7 ± 0.2% | 17484.5 | 3042.8 | 109.06 ± 0.3% | 9282.2 ± 0.4% |
| zlib-ng, dynamic members: whole | 3083.5 ± 0.5% | 23609.1 | 4510.4 | 169.50 ± 0.4% | 10423.4 ± 0.1% |
| zlib-ng, dynamic members: whole, room past the slice | 2831.3 ± 0.5% | 20963.3 | 3926.3 | 144.97 ± 0.5% | 9569.4 ± 0.1% |
| stdx, every member: whole | 3815.8 ± 0.1% | 37431.5 | 8865.4 | 205.90 ± 0.3% | 12933.2 ± 0.1% |
| libdeflate, every member: whole | 2814.6 ± 0.2% | 17788.8 | 3127.9 | 121.64 ± 0.6% | 9549.9 ± 0.2% |
| zlib-ng, every member: whole | 3074.9 ± 0.2% | 23591.7 | 4507.0 | 170.80 ± 0.5% | 10446.1 ± 0.1% |

## http/css-16kx64

64 members, 14.7% of their slices: 64 of one dynamic block, 2404.3 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 481.7 bits, 2.5% of its member: HLIT + 257 is 281.6, HDIST + 1 is 27.4 and HCLEN + 4 is 13.9; 113.7 code length symbols, 9.8 of them repeats, give 80.4 literal/length codes of 10.5 bits at the longest and 24.4 distance codes of 9.3 bits. stdx's tables take 10.5 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 60.6 ± 0.7% | 754.5 | 153.1 | 0.15 ± 24.5% | 206.5 ± 1.0% |
| stdx, dynamic members: 2, through the code length code | 331.5 ± 0.6% | 3703.7 | 802.3 | 2.25 ± 5.5% | 1124.6 ± 0.2% |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1690.9 ± 0.2% | 22353.3 | 5253.6 | 62.21 ± 12.5% | 5736.2 ± 2.2% |
| stdx, dynamic members: 4, through the block's header | 2958.2 ± 0.3% | 36364.6 | 8841.4 | 89.24 ± 6.0% | 10044.7 ± 0.8% |
| stdx, dynamic members: 5, whole, room past the slice | 10291.6 ± 0.3% | 95568.7 | 18925.3 | 521.49 ± 3.1% | 34877.2 ± 0.6% |
| stdx, dynamic members: 6, whole | 10489.2 ± 0.2% | 98210.8 | 19705.9 | 541.41 ± 0.7% | 35653.0 ± 0.2% |
| libdeflate, dynamic members: whole | 9004.5 ± 0.2% | 76783.6 | 11534.2 | 430.30 ± 5.4% | 30560.9 ± 0.9% |
| libdeflate, dynamic members: whole, room past the slice | 8957.2 ± 0.2% | 76680.6 | 11503.9 | 422.58 ± 0.5% | 30422.8 ± 0.1% |
| zlib-ng, dynamic members: whole | 13491.1 ± 0.1% | 99463.8 | 17164.7 | 829.81 ± 0.8% | 45722.6 ± 0.2% |
| zlib-ng, dynamic members: whole, room past the slice | 13314.6 ± 0.2% | 98113.9 | 16871.8 | 808.49 ± 0.6% | 45171.4 ± 0.1% |
| stdx, every member: whole | 10506.3 ± 0.2% | 98210.8 | 19705.9 | 537.24 ± 3.8% | 35616.9 ± 0.6% |
| libdeflate, every member: whole | 9003.4 ± 0.1% | 76783.6 | 11534.2 | 429.31 ± 5.6% | 30528.5 ± 0.8% |
| zlib-ng, every member: whole | 13502.1 ± 0.3% | 99463.8 | 17164.7 | 828.38 ± 1.6% | 45696.9 ± 0.4% |
## What each piece of a dynamic block's header costs, called apart

Each piece runs once a member, in the members' order, on the code lengths of that member's block header or on its slice. Counts are a member's, the median of 5 runs, with the spread of the runs. A table's own cost is its row less the row of its code alone. The CRC-32 takes the path pmull.

## http/html-1kx1024

1024 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 1.6% | 25.0 | 3.0 | 0.00 ± 27.8% | 12.2 ± 5.0% |
| the code length code built | 54.2 ± 0.5% | 666.2 | 180.4 | 0.64 ± 20.7% | 184.3 ± 1.3% |
| the literal/length code built | 666.8 ± 2.6% | 5376.4 | 1629.5 | 23.86 ± 3.9% | 2282.4 ± 1.6% |
| the literal/length code and its table built | 881.2 ± 1.3% | 8016.6 | 2187.0 | 36.48 ± 3.7% | 3025.2 ± 1.7% |
| the distance code built | 59.3 ± 0.4% | 727.8 | 197.6 | 0.95 ± 94.6% | 202.3 ± 6.4% |
| the distance code and its table built | 152.8 ± 0.2% | 2097.9 | 481.2 | 4.22 ± 10.8% | 518.3 ± 1.6% |
| the slice's CRC-32 | 37.8 ± 1.7% | 461.0 | 35.0 | 0.00 ± 13.9% | 129.4 ± 0.6% |
| the slice copied into the window | 29.6 ± 2.1% | 344.0 | 82.0 | 0.00 ± 20.0% | 100.5 ± 0.5% |

## http/html-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 1.2% | 25.3 | 3.1 | 0.02 ± 5.9% | 12.6 ± 8.7% |
| the code length code built | 53.9 ± 0.5% | 692.8 | 187.7 | 0.32 ± 8.0% | 183.6 ± 1.1% |
| the literal/length code built | 578.0 ± 1.5% | 5881.3 | 1770.9 | 1.10 ± 57.1% | 1963.6 ± 1.6% |
| the literal/length code and its table built | 952.6 ± 1.4% | 10979.8 | 2904.9 | 7.20 ± 35.7% | 3219.7 ± 1.5% |
| the distance code built | 81.2 ± 0.5% | 988.2 | 274.0 | 0.36 ± 51.0% | 274.3 ± 3.3% |
| the distance code and its table built | 198.9 ± 0.3% | 2899.3 | 674.0 | 2.39 ± 25.8% | 676.8 ± 1.4% |
| the slice's CRC-32 | 474.9 ± 2.9% | 4788.3 | 112.1 | 0.02 ± 50.0% | 1607.6 ± 1.5% |
| the slice copied into the window | 407.3 ± 3.3% | 4184.3 | 1042.1 | 1.02 ± 0.5% | 1335.8 ± 1.5% |

## http/json-1kx1024

645 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 0.7% | 25.0 | 3.0 | 0.00 ± 23.5% | 12.2 ± 11.1% |
| the code length code built | 53.1 ± 0.2% | 662.7 | 179.5 | 0.48 ± 59.4% | 181.6 ± 3.1% |
| the literal/length code built | 647.3 ± 2.0% | 5267.3 | 1599.2 | 18.03 ± 7.4% | 2177.6 ± 0.6% |
| the literal/length code and its table built | 822.3 ± 1.1% | 7518.4 | 2070.2 | 28.53 ± 4.1% | 2791.5 ± 0.9% |
| the distance code built | 55.4 ± 0.3% | 699.1 | 189.6 | 0.48 ± 138.5% | 188.1 ± 6.2% |
| the distance code and its table built | 144.2 ± 0.5% | 1996.3 | 458.6 | 3.60 ± 20.4% | 490.0 ± 2.3% |
| the slice's CRC-32 | 43.7 ± 1.4% | 461.0 | 35.0 | 0.00 ± 23.5% | 146.8 ± 3.4% |
| the slice copied into the window | 35.1 ± 2.0% | 341.0 | 81.0 | 0.00 ± 44.4% | 117.9 ± 0.8% |

## http/json-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 0.7% | 25.3 | 3.1 | 0.02 ± 17.6% | 12.5 ± 9.9% |
| the code length code built | 53.0 ± 0.2% | 690.9 | 187.1 | 0.30 ± 66.3% | 182.1 ± 2.9% |
| the literal/length code built | 589.0 ± 1.8% | 5675.6 | 1714.0 | 1.54 ± 28.5% | 1994.0 ± 0.4% |
| the literal/length code and its table built | 869.6 ± 0.4% | 9653.1 | 2581.5 | 5.72 ± 58.7% | 2948.5 ± 2.8% |
| the distance code built | 71.6 ± 0.3% | 952.4 | 264.1 | 0.01 ± 5461.5% | 244.1 ± 4.6% |
| the distance code and its table built | 184.3 ± 0.3% | 2794.3 | 649.5 | 2.02 ± 56.7% | 629.4 ± 2.3% |
| the slice's CRC-32 | 497.5 ± 5.0% | 4788.3 | 112.1 | 0.02 ± 20.0% | 1812.0 ± 4.1% |
| the slice copied into the window | 387.7 ± 1.2% | 4181.3 | 1041.1 | 1.02 ± 0.2% | 1325.7 ± 0.7% |

## http/js-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 2.3% | 25.0 | 3.0 | 0.00 ± 17.6% | 12.2 ± 5.1% |
| the code length code built | 54.4 ± 0.3% | 667.3 | 180.7 | 0.72 ± 21.1% | 185.4 ± 1.4% |
| the literal/length code built | 677.4 ± 3.0% | 5440.3 | 1646.2 | 26.95 ± 5.4% | 2310.2 ± 0.9% |
| the literal/length code and its table built | 903.1 ± 1.4% | 8220.5 | 2233.3 | 39.37 ± 1.6% | 3074.6 ± 0.5% |
| the distance code built | 60.1 ± 0.2% | 742.5 | 201.6 | 0.94 ± 52.3% | 204.7 ± 3.2% |
| the distance code and its table built | 156.0 ± 0.2% | 2165.9 | 496.1 | 4.14 ± 9.9% | 528.4 ± 1.6% |
| the slice's CRC-32 | 40.8 ± 2.0% | 461.0 | 35.0 | 0.00 ± 28.9% | 139.6 ± 4.1% |
| the slice copied into the window | 29.0 ± 1.7% | 341.0 | 81.0 | 0.00 ± 140.9% | 99.4 ± 1.5% |

## http/js-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 0.4% | 25.3 | 3.1 | 0.02 ± 17.6% | 12.6 ± 6.1% |
| the code length code built | 52.9 ± 0.4% | 690.0 | 186.9 | 0.38 ± 17.0% | 180.1 ± 1.5% |
| the literal/length code built | 586.6 ± 0.9% | 6037.1 | 1814.9 | 0.89 ± 78.3% | 1984.2 ± 0.5% |
| the literal/length code and its table built | 976.6 ± 0.9% | 11365.4 | 2998.7 | 7.16 ± 32.3% | 3306.8 ± 1.1% |
| the distance code built | 83.4 ± 0.6% | 1003.6 | 278.2 | 0.32 ± 86.5% | 280.1 ± 3.4% |
| the distance code and its table built | 201.8 ± 0.3% | 2934.6 | 684.6 | 2.42 ± 21.3% | 692.0 ± 1.2% |
| the slice's CRC-32 | 496.3 ± 7.8% | 4788.3 | 112.1 | 0.02 ± 42.1% | 1574.0 ± 2.8% |
| the slice copied into the window | 406.8 ± 2.0% | 4181.3 | 1041.1 | 1.02 ± 0.8% | 1326.9 ± 4.9% |

## http/css-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.6 ± 0.9% | 25.0 | 3.0 | 0.00 ± 22.2% | 12.2 ± 4.7% |
| the code length code built | 53.8 ± 0.8% | 661.9 | 179.2 | 0.56 ± 35.7% | 182.4 ± 2.1% |
| the literal/length code built | 611.9 ± 1.9% | 5280.2 | 1602.8 | 8.24 ± 17.2% | 2059.9 ± 1.3% |
| the literal/length code and its table built | 805.9 ± 1.8% | 7627.2 | 2096.3 | 19.57 ± 2.8% | 2704.6 ± 1.0% |
| the distance code built | 57.2 ± 0.5% | 697.2 | 188.9 | 0.88 ± 82.2% | 195.3 ± 5.1% |
| the distance code and its table built | 146.9 ± 0.4% | 1997.8 | 458.5 | 4.24 ± 13.5% | 499.6 ± 2.0% |
| the slice's CRC-32 | 40.2 ± 0.7% | 461.0 | 35.0 | 0.00 ± 14.7% | 135.5 ± 3.8% |
| the slice copied into the window | 29.1 ± 1.2% | 341.0 | 81.0 | 0.00 ± 55.0% | 98.6 ± 1.3% |

## http/css-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 3.7 ± 0.6% | 25.3 | 3.1 | 0.02 ± 22.2% | 12.6 ± 7.9% |
| the code length code built | 52.7 ± 0.9% | 687.8 | 186.3 | 0.22 ± 18.3% | 179.0 ± 1.1% |
| the literal/length code built | 591.2 ± 1.8% | 5652.0 | 1708.2 | 1.05 ± 54.1% | 1994.5 ± 0.8% |
| the literal/length code and its table built | 902.7 ± 1.8% | 9985.7 | 2663.0 | 6.05 ± 37.5% | 3002.3 ± 2.1% |
| the distance code built | 75.2 ± 0.2% | 972.5 | 269.4 | 0.21 ± 42.0% | 257.8 ± 2.5% |
| the distance code and its table built | 190.8 ± 0.5% | 2858.2 | 666.7 | 1.92 ± 43.8% | 652.3 ± 2.7% |
| the slice's CRC-32 | 476.5 ± 13.3% | 4788.3 | 112.1 | 0.04 ± 29.7% | 1577.5 ± 3.6% |
| the slice copied into the window | 392.6 ± 1.8% | 4181.3 | 1041.1 | 1.02 ± 0.7% | 1284.7 ± 0.8% |
