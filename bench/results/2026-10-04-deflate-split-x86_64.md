# bench-profile

| Field | Value |
|---|---|
| Commit | fa00b10 |
| Runner label | ubuntu-24.04 |
| Image version | 20260927.320.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37240035013 |
| Date | 2026-10-04 |

## Where a small body's gzip decode goes, gzip at zlib level 6

Each row's members, one a slice, are decoded one after another, each from a state started anew (decision 45). A numbered stage gives stdx's decoder every dynamic member cut at the same point of its block header; a stage's count less the one before it is what the part between the two cuts costs. Counts are a member's, the median of 5 runs, with the spread of the runs.

The CPU's features, as stdx detects them: .{ .pclmul = true, .avx2 = true, .avx512 = true, .vpclmul = true, .vnni = true, .bmi2 = true, .vpmullq_fast = true, .crc32 = false, .pmull = false, .dotprod = false, .madd_addend_slow = false }.

Hardware counters are unavailable on this host: the stages are timed alone.

## http/html-1kx1024

1024 members, 38.0% of their slices: 1024 of one dynamic block, 388.8 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 415.7 bits, 13.4% of its member: HLIT + 257 is 276.0, HDIST + 1 is 19.4 and HCLEN + 4 is 15.2; 100.7 code length symbols, 10.3 of them repeats, give 63.5 literal/length codes of 8.4 bits at the longest and 13.8 distance codes of 5.8 bits. stdx's tables take 8.4 and 5.8 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 36.2 ± 3.2% | | | | |
| stdx, dynamic members: 2, through the code length code | 227.3 ± 3.3% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1489.2 ± 2.3% | | | | |
| stdx, dynamic members: 4, through the block's header | 2560.1 ± 2.0% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 3964.9 ± 1.2% | | | | |
| stdx, dynamic members: 6, whole | 4237.4 ± 4.7% | | | | |
| libdeflate, dynamic members: whole | 2931.4 ± 5.7% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 2831.6 ± 3.6% | | | | |
| zlib-ng, dynamic members: whole | 3190.0 ± 3.2% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 2860.8 ± 5.0% | | | | |
| stdx, every member: whole | 4360.8 ± 5.5% | | | | |
| libdeflate, every member: whole | 2951.5 ± 4.2% | | | | |
| zlib-ng, every member: whole | 3207.2 ± 6.1% | | | | |

## http/html-16kx64

64 members, 20.4% of their slices: 64 of one dynamic block, 3345.4 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 571.3 bits, 2.1% of its member: HLIT + 257 is 281.9, HDIST + 1 is 27.9 and HCLEN + 4 is 13.6; 136.8 code length symbols, 10.8 of them repeats, give 100.8 literal/length codes of 11.1 bits at the longest and 25.1 distance codes of 8.9 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 37.2 ± 3.0% | | | | |
| stdx, dynamic members: 2, through the code length code | 220.0 ± 8.5% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1428.0 ± 39.6% | | | | |
| stdx, dynamic members: 4, through the block's header | 2388.7 ± 5.3% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 16890.3 ± 3.0% | | | | |
| stdx, dynamic members: 6, whole | 17194.0 ± 3.3% | | | | |
| libdeflate, dynamic members: whole | 12899.2 ± 5.9% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 12781.5 ± 4.9% | | | | |
| zlib-ng, dynamic members: whole | 14841.2 ± 5.8% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 14587.7 ± 5.8% | | | | |
| stdx, every member: whole | 16993.9 ± 5.6% | | | | |
| libdeflate, every member: whole | 13138.7 ± 4.9% | | | | |
| zlib-ng, every member: whole | 15035.5 ± 5.7% | | | | |

## http/json-1kx1024

1024 members, 21.9% of their slices: 645 of one dynamic block, 256.0 octets each, and 379 of one fixed or stored block, 169.5 octets each. A dynamic block's header takes 374.1 bits, 18.3% of its member: HLIT + 257 is 275.2, HDIST + 1 is 19.2 and HCLEN + 4 is 17.0; 90.2 code length symbols, 10.9 of them repeats, give 54.7 literal/length codes of 7.5 bits at the longest and 11.6 distance codes of 5.5 bits. stdx's tables take 7.5 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 36.5 ± 4.0% | | | | |
| stdx, dynamic members: 2, through the code length code | 247.0 ± 6.0% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1496.4 ± 3.7% | | | | |
| stdx, dynamic members: 4, through the block's header | 2557.6 ± 5.6% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 3539.3 ± 4.3% | | | | |
| stdx, dynamic members: 6, whole | 3637.9 ± 6.2% | | | | |
| libdeflate, dynamic members: whole | 2354.7 ± 3.7% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 2316.8 ± 2.1% | | | | |
| zlib-ng, dynamic members: whole | 2542.2 ± 6.3% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 2297.7 ± 25.1% | | | | |
| stdx, fixed members: whole | 530.2 ± 13.1% | | | | |
| libdeflate, fixed members: whole | 1434.1 ± 10.8% | | | | |
| zlib-ng, fixed members: whole | 502.2 ± 20.5% | | | | |
| stdx, fixed members: whole, room past the slice | 400.4 ± 48.2% | | | | |
| stdx, every member: whole | 2527.1 ± 15.9% | | | | |
| libdeflate, every member: whole | 2203.5 ± 14.1% | | | | |
| zlib-ng, every member: whole | 1860.5 ± 3.2% | | | | |

## http/json-16kx64

64 members, 12.8% of their slices: 64 of one dynamic block, 2092.7 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 497.0 bits, 3.0% of its member: HLIT + 257 is 280.7, HDIST + 1 is 27.7 and HCLEN + 4 is 15.3; 118.6 code length symbols, 10.7 of them repeats, give 83.8 literal/length codes of 10.1 bits at the longest and 22.2 distance codes of 8.6 bits. stdx's tables take 10.0 and 7.9 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 35.5 ± 3.5% | | | | |
| stdx, dynamic members: 2, through the code length code | 232.0 ± 4.7% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1176.3 ± 4.1% | | | | |
| stdx, dynamic members: 4, through the block's header | 2049.6 ± 2.1% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 10536.1 ± 1.6% | | | | |
| stdx, dynamic members: 6, whole | 10850.2 ± 6.4% | | | | |
| libdeflate, dynamic members: whole | 8716.8 ± 6.5% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 8532.4 ± 3.8% | | | | |
| zlib-ng, dynamic members: whole | 9866.5 ± 3.7% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 9522.7 ± 5.6% | | | | |
| stdx, every member: whole | 10977.6 ± 2.1% | | | | |
| libdeflate, every member: whole | 8626.5 ± 4.4% | | | | |
| zlib-ng, every member: whole | 10036.3 ± 3.8% | | | | |

## http/js-1kx1024

1024 members, 42.5% of their slices: 1023 of one dynamic block, 435.6 octets each, and 1 of one fixed or stored block, 159.0 octets each. A dynamic block's header takes 437.6 bits, 12.6% of its member: HLIT + 257 is 275.0, HDIST + 1 is 19.5 and HCLEN + 4 is 14.7; 108.8 code length symbols, 10.2 of them repeats, give 70.8 literal/length codes of 8.5 bits at the longest and 15.0 distance codes of 6.1 bits. stdx's tables take 8.5 and 6.1 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 37.0 ± 3.9% | | | | |
| stdx, dynamic members: 2, through the code length code | 224.5 ± 5.6% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1632.0 ± 5.0% | | | | |
| stdx, dynamic members: 4, through the block's header | 2688.5 ± 4.3% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 4387.5 ± 5.3% | | | | |
| stdx, dynamic members: 6, whole | 4604.9 ± 3.3% | | | | |
| libdeflate, dynamic members: whole | 3170.2 ± 5.2% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 3097.9 ± 17.5% | | | | |
| zlib-ng, dynamic members: whole | 3634.6 ± 14.0% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 3171.3 ± 4.3% | | | | |
| stdx, every member: whole | 4739.3 ± 3.7% | | | | |
| libdeflate, every member: whole | 3203.2 ± 6.6% | | | | |
| zlib-ng, every member: whole | 3562.6 ± 5.1% | | | | |

## http/js-16kx64

64 members, 24.4% of their slices: 64 of one dynamic block, 3998.1 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 565.3 bits, 1.8% of its member: HLIT + 257 is 284.3, HDIST + 1 is 28.0 and HCLEN + 4 is 13.0; 142.6 code length symbols, 8.0 of them repeats, give 111.5 literal/length codes of 11.2 bits at the longest and 26.5 distance codes of 9.5 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 36.8 ± 3.6% | | | | |
| stdx, dynamic members: 2, through the code length code | 209.5 ± 5.9% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1403.0 ± 5.5% | | | | |
| stdx, dynamic members: 4, through the block's header | 2373.8 ± 7.7% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 19467.9 ± 4.5% | | | | |
| stdx, dynamic members: 6, whole | 19711.4 ± 3.7% | | | | |
| libdeflate, dynamic members: whole | 15360.2 ± 3.6% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 15229.2 ± 1.9% | | | | |
| zlib-ng, dynamic members: whole | 17268.7 ± 3.6% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 16783.4 ± 5.5% | | | | |
| stdx, every member: whole | 19680.9 ± 6.5% | | | | |
| libdeflate, every member: whole | 15591.4 ± 18.8% | | | | |
| zlib-ng, every member: whole | 17270.1 ± 7.4% | | | | |

## http/css-1kx1024

1024 members, 27.8% of their slices: 1023 of one dynamic block, 285.0 octets each, and 1 of one fixed or stored block, 163.0 octets each. A dynamic block's header takes 359.8 bits, 15.8% of its member: HLIT + 257 is 275.3, HDIST + 1 is 18.9 and HCLEN + 4 is 16.0; 86.9 code length symbols, 8.5 of them repeats, give 55.7 literal/length codes of 7.6 bits at the longest and 11.8 distance codes of 5.5 bits. stdx's tables take 7.6 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 37.9 ± 42.1% | | | | |
| stdx, dynamic members: 2, through the code length code | 245.7 ± 10.9% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1410.7 ± 5.4% | | | | |
| stdx, dynamic members: 4, through the block's header | 2369.8 ± 3.9% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 3437.5 ± 5.7% | | | | |
| stdx, dynamic members: 6, whole | 3705.5 ± 5.9% | | | | |
| libdeflate, dynamic members: whole | 2523.8 ± 16.4% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 2450.3 ± 3.4% | | | | |
| zlib-ng, dynamic members: whole | 2549.8 ± 4.9% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 2273.8 ± 4.7% | | | | |
| stdx, every member: whole | 3754.2 ± 4.4% | | | | |
| libdeflate, every member: whole | 2577.7 ± 2.6% | | | | |
| zlib-ng, every member: whole | 2571.4 ± 9.9% | | | | |

## http/css-16kx64

64 members, 14.7% of their slices: 64 of one dynamic block, 2404.3 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 481.7 bits, 2.5% of its member: HLIT + 257 is 281.6, HDIST + 1 is 27.4 and HCLEN + 4 is 13.9; 113.7 code length symbols, 9.8 of them repeats, give 80.4 literal/length codes of 10.5 bits at the longest and 24.4 distance codes of 9.3 bits. stdx's tables take 10.5 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 36.4 ± 7.9% | | | | |
| stdx, dynamic members: 2, through the code length code | 215.4 ± 17.2% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 1133.9 ± 5.2% | | | | |
| stdx, dynamic members: 4, through the block's header | 2074.7 ± 6.0% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 11271.6 ± 5.0% | | | | |
| stdx, dynamic members: 6, whole | 11357.4 ± 5.3% | | | | |
| libdeflate, dynamic members: whole | 7275.7 ± 3.9% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 7138.9 ± 5.1% | | | | |
| zlib-ng, dynamic members: whole | 8649.2 ± 1.1% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 8331.8 ± 3.2% | | | | |
| stdx, every member: whole | 11212.7 ± 2.3% | | | | |
| libdeflate, every member: whole | 7281.7 ± 5.4% | | | | |
| zlib-ng, every member: whole | 8678.8 ± 4.8% | | | | |
## What each piece of a dynamic block's header costs, called apart

Each piece runs once a member, in the members' order, on the code lengths of that member's block header or on its slice. Counts are a member's, the median of 5 runs, with the spread of the runs. A table's own cost is its row less the row of its code alone. The CRC-32 takes the path avx512.

Hardware counters are unavailable on this host: the pieces are timed alone.

## http/html-1kx1024

1024 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 5.9 ± 3.3% | | | | |
| the code length code built | 34.8 ± 4.8% | | | | |
| the literal/length code built | 570.7 ± 4.4% | | | | |
| the literal/length code and its table built | 793.3 ± 3.7% | | | | |
| the distance code built | 34.9 ± 3.1% | | | | |
| the distance code and its table built | 105.1 ± 10.0% | | | | |
| the slice's CRC-32 | 20.4 ± 32.9% | | | | |
| the slice copied into the window | 16.4 ± 2.6% | | | | |

## http/html-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.0 ± 17.2% | | | | |
| the code length code built | 33.1 ± 6.7% | | | | |
| the literal/length code built | 449.2 ± 6.6% | | | | |
| the literal/length code and its table built | 699.9 ± 6.6% | | | | |
| the distance code built | 59.9 ± 6.5% | | | | |
| the distance code and its table built | 147.8 ± 5.7% | | | | |
| the slice's CRC-32 | 241.4 ± 3.0% | | | | |
| the slice copied into the window | 175.4 ± 6.0% | | | | |

## http/json-1kx1024

645 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.2 ± 3.7% | | | | |
| the code length code built | 32.3 ± 3.9% | | | | |
| the literal/length code built | 525.8 ± 5.3% | | | | |
| the literal/length code and its table built | 682.9 ± 4.0% | | | | |
| the distance code built | 34.3 ± 4.3% | | | | |
| the distance code and its table built | 98.8 ± 4.1% | | | | |
| the slice's CRC-32 | 21.0 ± 3.7% | | | | |
| the slice copied into the window | 16.3 ± 4.1% | | | | |

## http/json-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.0 ± 5.0% | | | | |
| the code length code built | 31.3 ± 3.8% | | | | |
| the literal/length code built | 471.3 ± 4.2% | | | | |
| the literal/length code and its table built | 674.4 ± 4.0% | | | | |
| the distance code built | 46.9 ± 4.8% | | | | |
| the distance code and its table built | 129.2 ± 2.9% | | | | |
| the slice's CRC-32 | 241.1 ± 4.8% | | | | |
| the slice copied into the window | 166.1 ± 6.4% | | | | |

## http/js-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 5.9 ± 39.3% | | | | |
| the code length code built | 34.5 ± 6.3% | | | | |
| the literal/length code built | 578.6 ± 6.7% | | | | |
| the literal/length code and its table built | 816.1 ± 4.9% | | | | |
| the distance code built | 36.2 ± 4.9% | | | | |
| the distance code and its table built | 108.9 ± 4.8% | | | | |
| the slice's CRC-32 | 20.8 ± 2.9% | | | | |
| the slice copied into the window | 16.2 ± 13.2% | | | | |

## http/js-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.2 ± 5.4% | | | | |
| the code length code built | 34.5 ± 10.2% | | | | |
| the literal/length code built | 467.9 ± 5.4% | | | | |
| the literal/length code and its table built | 749.7 ± 4.9% | | | | |
| the distance code built | 62.4 ± 6.0% | | | | |
| the distance code and its table built | 154.1 ± 5.4% | | | | |
| the slice's CRC-32 | 250.6 ± 5.5% | | | | |
| the slice copied into the window | 155.8 ± 3.3% | | | | |

## http/css-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.1 ± 4.1% | | | | |
| the code length code built | 33.8 ± 4.9% | | | | |
| the literal/length code built | 528.7 ± 4.9% | | | | |
| the literal/length code and its table built | 702.1 ± 4.7% | | | | |
| the distance code built | 34.0 ± 4.5% | | | | |
| the distance code and its table built | 100.4 ± 4.9% | | | | |
| the slice's CRC-32 | 20.6 ± 3.6% | | | | |
| the slice copied into the window | 16.2 ± 5.4% | | | | |

## http/css-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.0 ± 4.1% | | | | |
| the code length code built | 33.1 ± 6.2% | | | | |
| the literal/length code built | 499.0 ± 18.8% | | | | |
| the literal/length code and its table built | 709.5 ± 2.4% | | | | |
| the distance code built | 48.9 ± 4.8% | | | | |
| the distance code and its table built | 134.4 ± 5.8% | | | | |
| the slice's CRC-32 | 243.9 ± 4.6% | | | | |
| the slice copied into the window | 153.4 ± 4.7% | | | | |
