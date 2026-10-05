# bench-profile

| Field | Value |
|---|---|
| Commit | 8a95c0f |
| Runner label | ubuntu-24.04 |
| Image version | 20260927.320.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37245299694 |
| Date | 2026-10-04 |

## Where a small body's gzip decode goes, gzip at zlib level 6

Each row's members, one a slice, are decoded one after another, each from a state started anew (decision 45). A numbered stage gives stdx's decoder every dynamic member cut at the same point of its block header; a stage's count less the one before it is what the part between the two cuts costs. Counts are a member's, the median of 5 runs, with the spread of the runs.

The CPU's features, as stdx detects them: .{ .pclmul = true, .avx2 = true, .avx512 = true, .vpclmul = true, .vnni = true, .bmi2 = true, .vpmullq_fast = true, .crc32 = false, .pmull = false, .dotprod = false, .madd_addend_slow = false }.

Hardware counters are unavailable on this host: the stages are timed alone.

## http/html-1kx1024

1024 members, 38.0% of their slices: 1024 of one dynamic block, 388.8 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 415.7 bits, 13.4% of its member: HLIT + 257 is 276.0, HDIST + 1 is 19.4 and HCLEN + 4 is 15.2; 100.7 code length symbols, 10.3 of them repeats, give 63.5 literal/length codes of 8.4 bits at the longest and 13.8 distance codes of 5.8 bits. stdx's tables take 8.4 and 5.8 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 38.0 ± 3.9% | | | | |
| stdx, dynamic members: 2, through the code length code | 210.5 ± 9.7% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 602.5 ± 4.5% | | | | |
| stdx, dynamic members: 4, through the block's header | 1711.6 ± 3.3% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 2995.1 ± 1.3% | | | | |
| stdx, dynamic members: 6, whole | 3289.9 ± 7.2% | | | | |
| libdeflate, dynamic members: whole | 3032.9 ± 4.4% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 2883.3 ± 3.2% | | | | |
| zlib-ng, dynamic members: whole | 3345.7 ± 4.9% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 3010.5 ± 3.8% | | | | |
| stdx, every member: whole | 3292.5 ± 2.1% | | | | |
| libdeflate, every member: whole | 3062.9 ± 12.9% | | | | |
| zlib-ng, every member: whole | 3478.3 ± 6.1% | | | | |

## http/html-16kx64

64 members, 20.4% of their slices: 64 of one dynamic block, 3345.4 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 571.3 bits, 2.1% of its member: HLIT + 257 is 281.9, HDIST + 1 is 27.9 and HCLEN + 4 is 13.6; 136.8 code length symbols, 10.8 of them repeats, give 100.8 literal/length codes of 11.1 bits at the longest and 25.1 distance codes of 8.9 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 36.6 ± 8.2% | | | | |
| stdx, dynamic members: 2, through the code length code | 195.9 ± 9.5% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 499.1 ± 10.2% | | | | |
| stdx, dynamic members: 4, through the block's header | 1425.9 ± 10.1% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 15360.5 ± 9.5% | | | | |
| stdx, dynamic members: 6, whole | 15639.7 ± 10.9% | | | | |
| libdeflate, dynamic members: whole | 12569.7 ± 9.5% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 12300.0 ± 9.3% | | | | |
| zlib-ng, dynamic members: whole | 14830.1 ± 8.8% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 14579.2 ± 7.0% | | | | |
| stdx, every member: whole | 15771.5 ± 3.8% | | | | |
| libdeflate, every member: whole | 12788.2 ± 4.2% | | | | |
| zlib-ng, every member: whole | 15105.0 ± 4.1% | | | | |

## http/json-1kx1024

1024 members, 21.9% of their slices: 645 of one dynamic block, 256.0 octets each, and 379 of one fixed or stored block, 169.5 octets each. A dynamic block's header takes 374.1 bits, 18.3% of its member: HLIT + 257 is 275.2, HDIST + 1 is 19.2 and HCLEN + 4 is 17.0; 90.2 code length symbols, 10.9 of them repeats, give 54.7 literal/length codes of 7.5 bits at the longest and 11.6 distance codes of 5.5 bits. stdx's tables take 7.5 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 37.6 ± 6.7% | | | | |
| stdx, dynamic members: 2, through the code length code | 206.6 ± 6.0% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 503.5 ± 3.5% | | | | |
| stdx, dynamic members: 4, through the block's header | 1553.1 ± 2.1% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 2367.1 ± 4.6% | | | | |
| stdx, dynamic members: 6, whole | 2522.7 ± 3.6% | | | | |
| libdeflate, dynamic members: whole | 2394.3 ± 2.9% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 2347.8 ± 9.2% | | | | |
| zlib-ng, dynamic members: whole | 2623.8 ± 8.7% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 2367.5 ± 5.8% | | | | |
| stdx, fixed members: whole | 560.3 ± 2.2% | | | | |
| libdeflate, fixed members: whole | 1421.9 ± 5.1% | | | | |
| zlib-ng, fixed members: whole | 529.8 ± 5.0% | | | | |
| stdx, fixed members: whole, room past the slice | 420.3 ± 2.5% | | | | |
| stdx, every member: whole | 1891.6 ± 4.2% | | | | |
| libdeflate, every member: whole | 2136.0 ± 1.7% | | | | |
| zlib-ng, every member: whole | 1905.3 ± 4.4% | | | | |

## http/json-16kx64

64 members, 12.8% of their slices: 64 of one dynamic block, 2092.7 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 497.0 bits, 3.0% of its member: HLIT + 257 is 280.7, HDIST + 1 is 27.7 and HCLEN + 4 is 15.3; 118.6 code length symbols, 10.7 of them repeats, give 83.8 literal/length codes of 10.1 bits at the longest and 22.2 distance codes of 8.6 bits. stdx's tables take 10.0 and 7.9 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 36.6 ± 4.9% | | | | |
| stdx, dynamic members: 2, through the code length code | 208.2 ± 8.1% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 466.3 ± 6.4% | | | | |
| stdx, dynamic members: 4, through the block's header | 1341.8 ± 3.3% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 9508.1 ± 4.7% | | | | |
| stdx, dynamic members: 6, whole | 9527.9 ± 2.4% | | | | |
| libdeflate, dynamic members: whole | 8429.9 ± 2.3% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 8360.5 ± 4.4% | | | | |
| zlib-ng, dynamic members: whole | 9968.9 ± 3.8% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 9734.3 ± 2.0% | | | | |
| stdx, every member: whole | 9638.4 ± 7.5% | | | | |
| libdeflate, every member: whole | 8522.8 ± 4.9% | | | | |
| zlib-ng, every member: whole | 10134.7 ± 4.7% | | | | |

## http/js-1kx1024

1024 members, 42.5% of their slices: 1023 of one dynamic block, 435.6 octets each, and 1 of one fixed or stored block, 159.0 octets each. A dynamic block's header takes 437.6 bits, 12.6% of its member: HLIT + 257 is 275.0, HDIST + 1 is 19.5 and HCLEN + 4 is 14.7; 108.8 code length symbols, 10.2 of them repeats, give 70.8 literal/length codes of 8.5 bits at the longest and 15.0 distance codes of 6.1 bits. stdx's tables take 8.5 and 6.1 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 37.1 ± 2.9% | | | | |
| stdx, dynamic members: 2, through the code length code | 197.3 ± 5.3% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 581.4 ± 5.2% | | | | |
| stdx, dynamic members: 4, through the block's header | 1711.4 ± 5.7% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 3236.2 ± 12.9% | | | | |
| stdx, dynamic members: 6, whole | 3592.0 ± 33.0% | | | | |
| libdeflate, dynamic members: whole | 3303.0 ± 10.0% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 3076.6 ± 4.0% | | | | |
| zlib-ng, dynamic members: whole | 3661.2 ± 5.3% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 3146.6 ± 3.1% | | | | |
| stdx, every member: whole | 3466.3 ± 4.7% | | | | |
| libdeflate, every member: whole | 3296.7 ± 4.6% | | | | |
| zlib-ng, every member: whole | 3720.8 ± 8.8% | | | | |

## http/js-16kx64

64 members, 24.4% of their slices: 64 of one dynamic block, 3998.1 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 565.3 bits, 1.8% of its member: HLIT + 257 is 284.3, HDIST + 1 is 28.0 and HCLEN + 4 is 13.0; 142.6 code length symbols, 8.0 of them repeats, give 111.5 literal/length codes of 11.2 bits at the longest and 26.5 distance codes of 9.5 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 37.1 ± 6.9% | | | | |
| stdx, dynamic members: 2, through the code length code | 193.4 ± 6.6% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 506.8 ± 7.4% | | | | |
| stdx, dynamic members: 4, through the block's header | 1461.6 ± 6.5% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 18011.4 ± 8.5% | | | | |
| stdx, dynamic members: 6, whole | 18498.0 ± 5.5% | | | | |
| libdeflate, dynamic members: whole | 15143.7 ± 4.0% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 15136.0 ± 5.6% | | | | |
| zlib-ng, dynamic members: whole | 17970.7 ± 7.4% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 17378.9 ± 5.6% | | | | |
| stdx, every member: whole | 18182.0 ± 6.7% | | | | |
| libdeflate, every member: whole | 14883.6 ± 28.9% | | | | |
| zlib-ng, every member: whole | 17827.6 ± 9.5% | | | | |

## http/css-1kx1024

1024 members, 27.8% of their slices: 1023 of one dynamic block, 285.0 octets each, and 1 of one fixed or stored block, 163.0 octets each. A dynamic block's header takes 359.8 bits, 15.8% of its member: HLIT + 257 is 275.3, HDIST + 1 is 18.9 and HCLEN + 4 is 16.0; 86.9 code length symbols, 8.5 of them repeats, give 55.7 literal/length codes of 7.6 bits at the longest and 11.8 distance codes of 5.5 bits. stdx's tables take 7.6 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 37.8 ± 4.0% | | | | |
| stdx, dynamic members: 2, through the code length code | 210.1 ± 2.5% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 553.7 ± 5.2% | | | | |
| stdx, dynamic members: 4, through the block's header | 1503.8 ± 7.1% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 2397.2 ± 4.7% | | | | |
| stdx, dynamic members: 6, whole | 2695.0 ± 8.5% | | | | |
| libdeflate, dynamic members: whole | 2576.1 ± 4.4% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 2467.6 ± 6.4% | | | | |
| zlib-ng, dynamic members: whole | 2573.0 ± 8.5% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 2267.0 ± 7.6% | | | | |
| stdx, every member: whole | 2588.7 ± 5.8% | | | | |
| libdeflate, every member: whole | 2550.2 ± 5.8% | | | | |
| zlib-ng, every member: whole | 2584.9 ± 6.0% | | | | |

## http/css-16kx64

64 members, 14.7% of their slices: 64 of one dynamic block, 2404.3 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 481.7 bits, 2.5% of its member: HLIT + 257 is 281.6, HDIST + 1 is 27.4 and HCLEN + 4 is 13.9; 113.7 code length symbols, 9.8 of them repeats, give 80.4 literal/length codes of 10.5 bits at the longest and 24.4 distance codes of 9.3 bits. stdx's tables take 10.5 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 36.1 ± 3.3% | | | | |
| stdx, dynamic members: 2, through the code length code | 194.1 ± 5.2% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 444.3 ± 5.1% | | | | |
| stdx, dynamic members: 4, through the block's header | 1349.1 ± 4.3% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 9931.5 ± 4.4% | | | | |
| stdx, dynamic members: 6, whole | 10311.7 ± 3.8% | | | | |
| libdeflate, dynamic members: whole | 7436.5 ± 3.2% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 7332.0 ± 4.8% | | | | |
| zlib-ng, dynamic members: whole | 9196.4 ± 5.4% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 8752.7 ± 3.8% | | | | |
| stdx, every member: whole | 10280.8 ± 6.7% | | | | |
| libdeflate, every member: whole | 7542.7 ± 23.6% | | | | |
| zlib-ng, every member: whole | 9132.0 ± 6.6% | | | | |
## What each piece of a dynamic block's header costs, called apart

Each piece runs once a member, in the members' order, on the code lengths of that member's block header or on its slice. Counts are a member's, the median of 5 runs, with the spread of the runs. A table's own cost is its row less the row of its code alone. The CRC-32 takes the path avx512.

Hardware counters are unavailable on this host: the pieces are timed alone.

## http/html-1kx1024

1024 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 5.9 ± 4.2% | | | | |
| the code length code built | 35.6 ± 4.6% | | | | |
| the literal/length code built | 563.7 ± 13.5% | | | | |
| the literal/length code and its table built | 788.1 ± 3.9% | | | | |
| the distance code built | 35.0 ± 5.9% | | | | |
| the distance code and its table built | 108.5 ± 4.9% | | | | |
| the slice's CRC-32 | 20.7 ± 3.0% | | | | |
| the slice copied into the window | 16.1 ± 5.0% | | | | |

## http/html-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.2 ± 4.7% | | | | |
| the code length code built | 34.0 ± 6.8% | | | | |
| the literal/length code built | 461.9 ± 4.6% | | | | |
| the literal/length code and its table built | 710.6 ± 5.6% | | | | |
| the distance code built | 59.0 ± 5.5% | | | | |
| the distance code and its table built | 154.1 ± 5.2% | | | | |
| the slice's CRC-32 | 241.6 ± 7.0% | | | | |
| the slice copied into the window | 173.4 ± 6.2% | | | | |

## http/json-1kx1024

645 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 5.9 ± 6.9% | | | | |
| the code length code built | 30.9 ± 7.1% | | | | |
| the literal/length code built | 505.9 ± 7.5% | | | | |
| the literal/length code and its table built | 670.3 ± 6.3% | | | | |
| the distance code built | 33.6 ± 4.2% | | | | |
| the distance code and its table built | 96.3 ± 1.0% | | | | |
| the slice's CRC-32 | 20.3 ± 0.2% | | | | |
| the slice copied into the window | 15.8 ± 1.0% | | | | |

## http/json-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 5.9 ± 0.2% | | | | |
| the code length code built | 31.5 ± 1.5% | | | | |
| the literal/length code built | 477.3 ± 4.6% | | | | |
| the literal/length code and its table built | 676.4 ± 2.9% | | | | |
| the distance code built | 46.7 ± 1.2% | | | | |
| the distance code and its table built | 127.8 ± 1.1% | | | | |
| the slice's CRC-32 | 235.3 ± 0.6% | | | | |
| the slice copied into the window | 170.7 ± 0.7% | | | | |

## http/js-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.0 ± 33.1% | | | | |
| the code length code built | 35.4 ± 8.8% | | | | |
| the literal/length code built | 586.1 ± 5.1% | | | | |
| the literal/length code and its table built | 814.5 ± 7.9% | | | | |
| the distance code built | 36.0 ± 2.5% | | | | |
| the distance code and its table built | 108.6 ± 1.6% | | | | |
| the slice's CRC-32 | 20.8 ± 17.6% | | | | |
| the slice copied into the window | 16.3 ± 55.6% | | | | |

## http/js-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.1 ± 3.6% | | | | |
| the code length code built | 34.3 ± 6.3% | | | | |
| the literal/length code built | 454.3 ± 4.4% | | | | |
| the literal/length code and its table built | 750.3 ± 15.9% | | | | |
| the distance code built | 62.1 ± 11.8% | | | | |
| the distance code and its table built | 150.8 ± 5.1% | | | | |
| the slice's CRC-32 | 237.1 ± 5.8% | | | | |
| the slice copied into the window | 159.3 ± 3.5% | | | | |

## http/css-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.1 ± 6.3% | | | | |
| the code length code built | 33.3 ± 5.6% | | | | |
| the literal/length code built | 515.7 ± 5.2% | | | | |
| the literal/length code and its table built | 694.9 ± 5.1% | | | | |
| the distance code built | 33.2 ± 5.9% | | | | |
| the distance code and its table built | 99.7 ± 5.8% | | | | |
| the slice's CRC-32 | 20.8 ± 6.1% | | | | |
| the slice copied into the window | 16.4 ± 6.7% | | | | |

## http/css-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 6.1 ± 7.8% | | | | |
| the code length code built | 32.4 ± 4.7% | | | | |
| the literal/length code built | 488.2 ± 5.6% | | | | |
| the literal/length code and its table built | 706.8 ± 5.9% | | | | |
| the distance code built | 49.8 ± 4.9% | | | | |
| the distance code and its table built | 138.5 ± 7.5% | | | | |
| the slice's CRC-32 | 237.3 ± 5.8% | | | | |
| the slice copied into the window | 155.9 ± 5.2% | | | | |
