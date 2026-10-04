# bench-profile

| Field | Value |
|---|---|
| Commit | e6ee392 |
| Runner label | ubuntu-24.04 |
| Image version | 20260927.320.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37240834498 |
| Date | 2026-10-04 |

## Where a small body's gzip decode goes, gzip at zlib level 6

Each row's members, one a slice, are decoded one after another, each from a state started anew (decision 45). A numbered stage gives stdx's decoder every dynamic member cut at the same point of its block header; a stage's count less the one before it is what the part between the two cuts costs. Counts are a member's, the median of 5 runs, with the spread of the runs.

The CPU's features, as stdx detects them: .{ .pclmul = true, .avx2 = true, .avx512 = false, .vpclmul = true, .vnni = false, .bmi2 = true, .vpmullq_fast = false, .crc32 = false, .pmull = false, .dotprod = false, .madd_addend_slow = false }.

Hardware counters are unavailable on this host: the stages are timed alone.

## http/html-1kx1024

1024 members, 38.0% of their slices: 1024 of one dynamic block, 388.8 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 415.7 bits, 13.4% of its member: HLIT + 257 is 276.0, HDIST + 1 is 19.4 and HCLEN + 4 is 15.2; 100.7 code length symbols, 10.3 of them repeats, give 63.5 literal/length codes of 8.4 bits at the longest and 13.8 distance codes of 5.8 bits. stdx's tables take 8.4 and 5.8 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 70.9 ± 2.8% | | | | |
| stdx, dynamic members: 2, through the code length code | 409.9 ± 0.4% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 2459.1 ± 1.1% | | | | |
| stdx, dynamic members: 4, through the block's header | 4131.6 ± 0.1% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 6294.7 ± 0.2% | | | | |
| stdx, dynamic members: 6, whole | 6736.7 ± 0.4% | | | | |
| libdeflate, dynamic members: whole | 4485.4 ± 0.2% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 4285.8 ± 0.7% | | | | |
| zlib-ng, dynamic members: whole | 5225.7 ± 0.3% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 4624.2 ± 10.3% | | | | |
| stdx, every member: whole | 6692.8 ± 36.5% | | | | |
| libdeflate, every member: whole | 4487.4 ± 8.8% | | | | |
| zlib-ng, every member: whole | 5217.5 ± 3.9% | | | | |

## http/html-16kx64

64 members, 20.4% of their slices: 64 of one dynamic block, 3345.4 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 571.3 bits, 2.1% of its member: HLIT + 257 is 281.9, HDIST + 1 is 27.9 and HCLEN + 4 is 13.6; 136.8 code length symbols, 10.8 of them repeats, give 100.8 literal/length codes of 11.1 bits at the longest and 25.1 distance codes of 8.9 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 71.0 ± 0.6% | | | | |
| stdx, dynamic members: 2, through the code length code | 380.8 ± 0.2% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 2362.9 ± 0.3% | | | | |
| stdx, dynamic members: 4, through the block's header | 3922.3 ± 1.2% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 24932.7 ± 0.3% | | | | |
| stdx, dynamic members: 6, whole | 25349.5 ± 0.3% | | | | |
| libdeflate, dynamic members: whole | 18638.1 ± 0.7% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 18454.6 ± 0.3% | | | | |
| zlib-ng, dynamic members: whole | 24476.3 ± 0.4% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 24009.4 ± 4.4% | | | | |
| stdx, every member: whole | 25306.9 ± 14.7% | | | | |
| libdeflate, every member: whole | 18627.9 ± 0.1% | | | | |
| zlib-ng, every member: whole | 24464.1 ± 1.3% | | | | |

## http/json-1kx1024

1024 members, 21.9% of their slices: 645 of one dynamic block, 256.0 octets each, and 379 of one fixed or stored block, 169.5 octets each. A dynamic block's header takes 374.1 bits, 18.3% of its member: HLIT + 257 is 275.2, HDIST + 1 is 19.2 and HCLEN + 4 is 17.0; 90.2 code length symbols, 10.9 of them repeats, give 54.7 literal/length codes of 7.5 bits at the longest and 11.6 distance codes of 5.5 bits. stdx's tables take 7.5 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 71.0 ± 0.4% | | | | |
| stdx, dynamic members: 2, through the code length code | 436.7 ± 0.9% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 2351.2 ± 0.6% | | | | |
| stdx, dynamic members: 4, through the block's header | 3950.9 ± 0.4% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 5406.3 ± 0.3% | | | | |
| stdx, dynamic members: 6, whole | 5649.1 ± 0.7% | | | | |
| libdeflate, dynamic members: whole | 3688.2 ± 0.3% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 3632.4 ± 0.3% | | | | |
| zlib-ng, dynamic members: whole | 4087.3 ± 0.3% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 3709.3 ± 0.7% | | | | |
| stdx, fixed members: whole | 810.3 ± 1.2% | | | | |
| libdeflate, fixed members: whole | 2477.4 ± 0.4% | | | | |
| zlib-ng, fixed members: whole | 756.8 ± 0.7% | | | | |
| stdx, fixed members: whole, room past the slice | 659.8 ± 0.6% | | | | |
| stdx, every member: whole | 3984.8 ± 0.3% | | | | |
| libdeflate, every member: whole | 3401.2 ± 0.1% | | | | |
| zlib-ng, every member: whole | 2993.9 ± 2.3% | | | | |

## http/json-16kx64

64 members, 12.8% of their slices: 64 of one dynamic block, 2092.7 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 497.0 bits, 3.0% of its member: HLIT + 257 is 280.7, HDIST + 1 is 27.7 and HCLEN + 4 is 15.3; 118.6 code length symbols, 10.7 of them repeats, give 83.8 literal/length codes of 10.1 bits at the longest and 22.2 distance codes of 8.6 bits. stdx's tables take 10.0 and 7.9 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 71.0 ± 0.7% | | | | |
| stdx, dynamic members: 2, through the code length code | 410.9 ± 0.4% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 2096.8 ± 1.0% | | | | |
| stdx, dynamic members: 4, through the block's header | 3542.3 ± 1.2% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 17037.8 ± 1.0% | | | | |
| stdx, dynamic members: 6, whole | 17417.0 ± 0.7% | | | | |
| libdeflate, dynamic members: whole | 13000.4 ± 0.4% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 12875.5 ± 0.5% | | | | |
| zlib-ng, dynamic members: whole | 16281.9 ± 0.4% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 15921.4 ± 0.5% | | | | |
| stdx, every member: whole | 17378.1 ± 0.3% | | | | |
| libdeflate, every member: whole | 12976.0 ± 0.3% | | | | |
| zlib-ng, every member: whole | 16276.5 ± 0.6% | | | | |

## http/js-1kx1024

1024 members, 42.5% of their slices: 1023 of one dynamic block, 435.6 octets each, and 1 of one fixed or stored block, 159.0 octets each. A dynamic block's header takes 437.6 bits, 12.6% of its member: HLIT + 257 is 275.0, HDIST + 1 is 19.5 and HCLEN + 4 is 14.7; 108.8 code length symbols, 10.2 of them repeats, give 70.8 literal/length codes of 8.5 bits at the longest and 15.0 distance codes of 6.1 bits. stdx's tables take 8.5 and 6.1 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 71.0 ± 4.3% | | | | |
| stdx, dynamic members: 2, through the code length code | 403.2 ± 16.1% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 2602.8 ± 0.3% | | | | |
| stdx, dynamic members: 4, through the block's header | 4311.9 ± 1.2% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 6760.7 ± 0.2% | | | | |
| stdx, dynamic members: 6, whole | 7275.4 ± 0.5% | | | | |
| libdeflate, dynamic members: whole | 4849.9 ± 0.2% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 4575.1 ± 0.2% | | | | |
| zlib-ng, dynamic members: whole | 5737.3 ± 0.3% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 5017.9 ± 0.6% | | | | |
| stdx, every member: whole | 7243.8 ± 0.4% | | | | |
| libdeflate, every member: whole | 4848.2 ± 0.3% | | | | |
| zlib-ng, every member: whole | 5735.2 ± 0.3% | | | | |

## http/js-16kx64

64 members, 24.4% of their slices: 64 of one dynamic block, 3998.1 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 565.3 bits, 1.8% of its member: HLIT + 257 is 284.3, HDIST + 1 is 28.0 and HCLEN + 4 is 13.0; 142.6 code length symbols, 8.0 of them repeats, give 111.5 literal/length codes of 11.2 bits at the longest and 26.5 distance codes of 9.5 bits. stdx's tables take 11.0 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 70.9 ± 0.3% | | | | |
| stdx, dynamic members: 2, through the code length code | 369.0 ± 0.3% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 2382.4 ± 0.4% | | | | |
| stdx, dynamic members: 4, through the block's header | 3970.8 ± 0.7% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 28438.7 ± 0.2% | | | | |
| stdx, dynamic members: 6, whole | 28973.0 ± 0.3% | | | | |
| libdeflate, dynamic members: whole | 21759.9 ± 0.1% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 21549.5 ± 0.1% | | | | |
| zlib-ng, dynamic members: whole | 27278.0 ± 3.5% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 26667.4 ± 1.5% | | | | |
| stdx, every member: whole | 29014.9 ± 0.5% | | | | |
| libdeflate, every member: whole | 21774.1 ± 0.7% | | | | |
| zlib-ng, every member: whole | 27283.6 ± 0.3% | | | | |

## http/css-1kx1024

1024 members, 27.8% of their slices: 1023 of one dynamic block, 285.0 octets each, and 1 of one fixed or stored block, 163.0 octets each. A dynamic block's header takes 359.8 bits, 15.8% of its member: HLIT + 257 is 275.3, HDIST + 1 is 18.9 and HCLEN + 4 is 16.0; 86.9 code length symbols, 8.5 of them repeats, give 55.7 literal/length codes of 7.6 bits at the longest and 11.8 distance codes of 5.5 bits. stdx's tables take 7.6 and 5.5 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 70.9 ± 0.3% | | | | |
| stdx, dynamic members: 2, through the code length code | 421.3 ± 0.2% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 2223.8 ± 0.5% | | | | |
| stdx, dynamic members: 4, through the block's header | 3768.0 ± 0.5% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 5357.4 ± 0.2% | | | | |
| stdx, dynamic members: 6, whole | 5671.5 ± 0.3% | | | | |
| libdeflate, dynamic members: whole | 3844.7 ± 0.1% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 3737.9 ± 0.2% | | | | |
| zlib-ng, dynamic members: whole | 4132.8 ± 0.2% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 3685.3 ± 0.8% | | | | |
| stdx, every member: whole | 5670.4 ± 1.5% | | | | |
| libdeflate, every member: whole | 3844.2 ± 0.3% | | | | |
| zlib-ng, every member: whole | 4132.7 ± 0.2% | | | | |

## http/css-16kx64

64 members, 14.7% of their slices: 64 of one dynamic block, 2404.3 octets each, and 0 of one fixed or stored block. A dynamic block's header takes 481.7 bits, 2.5% of its member: HLIT + 257 is 281.6, HDIST + 1 is 27.4 and HCLEN + 4 is 13.9; 113.7 code length symbols, 9.8 of them repeats, give 80.4 literal/length codes of 10.5 bits at the longest and 24.4 distance codes of 9.3 bits. stdx's tables take 10.5 and 8.0 bits.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| stdx, dynamic members: 1, the member's header | 70.7 ± 0.5% | | | | |
| stdx, dynamic members: 2, through the code length code | 384.3 ± 0.6% | | | | |
| stdx, dynamic members: 3, through the code lengths but the last octet's | 2009.6 ± 0.2% | | | | |
| stdx, dynamic members: 4, through the block's header | 3492.2 ± 0.8% | | | | |
| stdx, dynamic members: 5, whole, room past the slice | 17165.9 ± 0.5% | | | | |
| stdx, dynamic members: 6, whole | 17515.8 ± 0.7% | | | | |
| libdeflate, dynamic members: whole | 10808.2 ± 2.6% | | | | |
| libdeflate, dynamic members: whole, room past the slice | 10946.0 ± 1.6% | | | | |
| zlib-ng, dynamic members: whole | 15204.4 ± 0.2% | | | | |
| zlib-ng, dynamic members: whole, room past the slice | 14833.2 ± 0.1% | | | | |
| stdx, every member: whole | 17481.1 ± 0.6% | | | | |
| libdeflate, every member: whole | 10816.6 ± 2.9% | | | | |
| zlib-ng, every member: whole | 15199.7 ± 0.3% | | | | |
## What each piece of a dynamic block's header costs, called apart

Each piece runs once a member, in the members' order, on the code lengths of that member's block header or on its slice. Counts are a member's, the median of 5 runs, with the spread of the runs. A table's own cost is its row less the row of its code alone. The CRC-32 takes the path vpclmul.

Hardware counters are unavailable on this host: the pieces are timed alone.

## http/html-1kx1024

1024 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 19.4 ± 0.6% | | | | |
| the code length code built | 50.1 ± 0.9% | | | | |
| the literal/length code built | 861.4 ± 1.8% | | | | |
| the literal/length code and its table built | 1224.4 ± 1.1% | | | | |
| the distance code built | 58.6 ± 0.4% | | | | |
| the distance code and its table built | 182.5 ± 0.8% | | | | |
| the slice's CRC-32 | 54.8 ± 0.3% | | | | |
| the slice copied into the window | 30.2 ± 0.5% | | | | |

## http/html-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 19.4 ± 0.1% | | | | |
| the code length code built | 52.8 ± 0.1% | | | | |
| the literal/length code built | 704.3 ± 1.0% | | | | |
| the literal/length code and its table built | 1164.3 ± 0.6% | | | | |
| the distance code built | 87.9 ± 0.3% | | | | |
| the distance code and its table built | 259.6 ± 0.2% | | | | |
| the slice's CRC-32 | 737.8 ± 0.3% | | | | |
| the slice copied into the window | 396.7 ± 2.5% | | | | |

## http/json-1kx1024

645 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 19.3 ± 0.5% | | | | |
| the code length code built | 48.7 ± 0.4% | | | | |
| the literal/length code built | 804.5 ± 1.0% | | | | |
| the literal/length code and its table built | 1088.9 ± 0.6% | | | | |
| the distance code built | 55.6 ± 0.5% | | | | |
| the distance code and its table built | 170.3 ± 0.4% | | | | |
| the slice's CRC-32 | 54.8 ± 14.9% | | | | |
| the slice copied into the window | 27.8 ± 0.4% | | | | |

## http/json-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 19.3 ± 0.1% | | | | |
| the code length code built | 51.7 ± 0.4% | | | | |
| the literal/length code built | 724.3 ± 0.9% | | | | |
| the literal/length code and its table built | 1084.8 ± 0.3% | | | | |
| the distance code built | 75.3 ± 0.2% | | | | |
| the distance code and its table built | 240.9 ± 0.6% | | | | |
| the slice's CRC-32 | 739.0 ± 0.3% | | | | |
| the slice copied into the window | 388.2 ± 1.9% | | | | |

## http/js-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 19.4 ± 0.2% | | | | |
| the code length code built | 50.2 ± 4.0% | | | | |
| the literal/length code built | 885.0 ± 1.7% | | | | |
| the literal/length code and its table built | 1258.6 ± 0.4% | | | | |
| the distance code built | 59.9 ± 0.3% | | | | |
| the distance code and its table built | 191.7 ± 3.1% | | | | |
| the slice's CRC-32 | 55.0 ± 0.6% | | | | |
| the slice copied into the window | 29.5 ± 0.7% | | | | |

## http/js-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 19.3 ± 0.2% | | | | |
| the code length code built | 52.6 ± 0.4% | | | | |
| the literal/length code built | 698.9 ± 0.8% | | | | |
| the literal/length code and its table built | 1188.5 ± 0.5% | | | | |
| the distance code built | 90.0 ± 0.0% | | | | |
| the distance code and its table built | 261.2 ± 0.5% | | | | |
| the slice's CRC-32 | 738.6 ± 0.3% | | | | |
| the slice copied into the window | 376.9 ± 1.9% | | | | |

## http/css-1kx1024

1023 of its 1024 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 19.4 ± 0.7% | | | | |
| the code length code built | 49.0 ± 0.3% | | | | |
| the literal/length code built | 793.1 ± 0.2% | | | | |
| the literal/length code and its table built | 1079.3 ± 0.6% | | | | |
| the distance code built | 55.2 ± 0.6% | | | | |
| the distance code and its table built | 170.7 ± 0.3% | | | | |
| the slice's CRC-32 | 54.9 ± 0.5% | | | | |
| the slice copied into the window | 29.3 ± 0.3% | | | | |

## http/css-16kx64

64 of its 64 members are one dynamic block.

| Stage | Nanoseconds a member | Instructions | Branches | Branch misses | Cycles |
|---|---|---|---|---|---|
| the code lengths cleared | 19.4 ± 0.2% | | | | |
| the code length code built | 51.1 ± 0.6% | | | | |
| the literal/length code built | 727.9 ± 0.8% | | | | |
| the literal/length code and its table built | 1114.5 ± 0.6% | | | | |
| the distance code built | 77.1 ± 0.4% | | | | |
| the distance code and its table built | 246.2 ± 0.3% | | | | |
| the slice's CRC-32 | 736.7 ± 0.7% | | | | |
| the slice copied into the window | 371.7 ± 0.4% | | | | |
