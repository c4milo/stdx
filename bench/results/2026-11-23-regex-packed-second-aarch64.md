# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102057264 |
| Date | 2026-11-23 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

The patterns of the search table:

- literal: a word, in canterbury-large/bible.txt: `Pharaoh`
- literal: a word that is not there, in canterbury-large/bible.txt: `Sherlock`
- literal: one of four words, in canterbury-large/bible.txt: `Abraham|Isaac|Jacob|Joseph`
- literal: a word in any case, in canterbury-large/bible.txt: `(?i)pharaoh`
- literal: an href attribute, in http/html-1m: `href="[^"]*"`
- literal: a word, second text, in canterbury-large/world192.txt: `Population`
- class: two capitalized words, in canterbury-large/bible.txt: `[A-Z][a-z]+ [A-Z][a-z]+`
- class: a word that ends in ing, in canterbury-large/bible.txt: `[a-z]+ing`
- class: a word in capitals, in canterbury-large/bible.txt: `[A-Z][A-Z][A-Z]+`
- class: a number, in http/html-1m: `[0-9]+`
- class: two capitalized words, second text, in canterbury-large/world192.txt: `[A-Z][a-z]+ [A-Z][a-z]+`
- other: a word between two words, in canterbury-large/bible.txt: `the [a-z]+ of`
- other: a number before a unit, second text, in canterbury-large/world192.txt: `[0-9][0-9,]* km`
- other: a heading's start tag, in http/html-1m: `<h[1-6][^>]*>`
- other: a whole word, in canterbury-large/bible.txt: `\bPharaoh\b`, which Rust's regex takes as `(?-u:\b)Pharaoh(?-u:\b)`
- other: a line's first word, second text, in canterbury-large/world192.txt: `(?m)^[A-Z][a-z]+:`
- other: fourteen octets before an x, in canterbury-large/bible.txt: `[a-q][^u-z]{13}x`
- other: a Greek word, in generated: words in four scripts: `[α-ω]+`

## Search in 1 MiB, MB/s

| Pattern | Matches | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| literal: a word | 217 | 15665.14 ± 0.9% | 1041.30 ± 0.3% | 27.71 ± 0.1% | 17566.83 ± 1.8% | 8926.97 ± 8.5% | 17.21 ± 0.5% | 86.42 ± 0.2% | 15621.22 ± 1.6% | 15.04 | 1.00 | 0.89 | 1.75 |
| literal: a word that is not there | 0 | 18317.96 ± 1.8% | 1049.11 ± 0.2% | 27.68 ± 0.1% | 19263.19 ± 4.4% | 26583.39 ± 6.6% | 17.02 ± 0.2% | 82.13 ± 0.3% | 18238.64 ± 1.6% | 17.46 | 1.00 | 0.95 | 0.69 |
| literal: one of four words | 661 | 6126.27 ± 0.4% | 1019.90 ± 0.3% | 14.32 ± 0.1% | 3945.30 ± 0.5% | 21.93 ± 0.1% | 5.35 ± 0.1% | 6.92 ± 0.4% | 6127.72 ± 0.4% | 6.01 | 1.00 | 1.55 | 279.42 |
| literal: a word in any case | 217 | 12477.63 ± 0.9% | 1042.43 ± 0.2% | 21.16 ± 2.7% | 3977.71 ± 0.2% | 38.00 ± 0.6% | refused | differs | 12445.88 ± 0.9% | 11.97 | 1.00 | 3.14 | 328.39 |
| literal: an href attribute | 33 | 13568.10 ± 1.9% | 1047.05 ± 0.3% | 26.71 ± 0.1% | 16467.53 ± 4.7% | 2265.03 ± 0.3% | 13.10 ± 0.1% | 75.20 ± 0.3% | 13571.43 ± 2.1% | 12.96 | 1.00 | 0.82 | 5.99 |
| literal: a word, second text | 123 | 16114.51 ± 0.7% | 1048.27 ± 0.1% | 27.40 ± 0.3% | 17639.63 ± 2.4% | 7681.31 ± 5.6% | 20.14 ± 0.2% | 70.16 ± 0.8% | 16163.48 ± 1.2% | 15.37 | 1.00 | 0.91 | 2.10 |
| class: two capitalized words | 1331 | 1103.59 ± 0.3% | 958.28 ± 0.1% | 25.50 ± 0.1% | 585.08 ± 0.1% | 40.73 ± 7.7% | 14.66 ± 0.3% | 68.84 ± 0.4% | 1103.26 ± 0.2% | 1.15 | 1.00 | 1.89 | 27.09 |
| class: a word that ends in ing | 3399 | 879.67 ± 0.1% | 881.54 ± 0.2% | 17.71 ± 0.5% | 547.25 ± 0.1% | 29.68 ± 3.3% | 8.13 ± 0.2% | 18.42 ± 0.1% | 862.10 ± 0.8% | 1.00 | 1.02 | 1.61 | 29.64 |
| class: a word in capitals | 2332 | 1468.50 ± 0.5% | 944.99 ± 0.2% | 27.14 ± 0.2% | 572.53 ± 0.1% | 43.49 ± 2.2% | 17.12 ± 0.4% | 83.16 ± 0.2% | 1468.04 ± 0.5% | 1.55 | 1.00 | 2.56 | 33.76 |
| class: a number | 8288 | 2059.03 ± 0.5% | 791.57 ± 0.3% | 27.20 ± 0.2% | 1723.25 ± 0.2% | 42.82 ± 7.0% | 0.54 ± 0.2% | 56.71 ± 0.4% | 2061.08 ± 0.2% | 2.60 | 1.00 | 1.19 | 48.08 |
| class: two capitalized words, second text | 5359 | 688.41 ± 0.2% | 686.78 ± 0.1% | 22.85 ± 0.3% | 485.20 ± 0.2% | 34.82 ± 12.2% | 17.13 ± 0.2% | 63.99 ± 0.2% | 687.68 ± 0.2% | 1.00 | 1.00 | 1.42 | 19.77 |
| other: a word between two words | 6104 | 777.42 ± 0.2% | 742.32 ± 0.2% | 23.10 ± 0.1% | 736.48 ± 0.2% | 106.58 ± 12.4% | 11.15 ± 0.2% | 69.54 ± 0.1% | 778.07 ± 0.1% | 1.05 | 1.00 | 1.06 | 7.29 |
| other: a number before a unit, second text | 1481 | 5457.23 ± 0.7% | 979.12 ± 0.1% | 25.40 ± 0.1% | 5199.03 ± 0.5% | 40.80 ± 9.8% | 18.16 ± 0.5% | 66.86 ± 0.3% | 5458.71 ± 0.6% | 5.57 | 1.00 | 1.05 | 133.74 |
| other: a heading's start tag | 110 | 12485.37 ± 1.9% | 1030.15 ± 0.3% | 26.82 ± 0.1% | 1705.89 ± 0.2% | 1585.20 ± 1.5% | 15.95 ± 0.4% | 88.88 ± 0.5% | 12491.87 ± 1.3% | 12.12 | 1.00 | 7.32 | 7.88 |
| other: a whole word | 217 | 13871.59 ± 0.7% | 1040.49 ± 0.3% | 28.61 ± 0.3% | 14242.56 ± 1.8% | 49.35 ± 0.2% | 13.08 ± 0.1% | 55.61 ± 0.4% | 13955.99 ± 0.8% | 13.33 | 0.99 | 0.97 | 281.09 |
| other: a line's first word, second text | 3716 | 1949.52 ± 0.8% | 851.14 ± 0.2% | 30.05 ± 0.2% | 1564.28 ± 0.3% | 62.25 ± 5.7% | refused | refused | 1918.91 ± 0.5% | 2.29 | 1.02 | 1.25 | 31.32 |
| other: fourteen octets before an x | 87 | 19038.06 ± 2.5% | 243.64 ± 0.6% | 5.30 ± 0.1% | 3927.09 ± 0.3% | 10.67 ± 0.1% | differs | 17.80 ± 0.1% | 19062.65 ± 0.8% | 78.14 | 1.00 | 4.85 | 1785.02 |
| other: a Greek word | 21815 | 471.94 ± 1.2% | 315.64 ± 0.7% | 30.29 ± 0.2% | 289.18 ± 0.4% | 43.73 ± 12.0% | differs | refused | 467.07 ± 1.0% | 1.50 | 1.01 | 1.63 | 10.79 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.04 ± 0.1% | 26.05 ± 0.3% | 0.82 ± 0.3% | 19.80 ± 0.3% | 2.77 ± 0.6% | differs | 4.01 ± 0.2% | 26.01 ± 0.1% | 1.00 | 1.00 | 1.32 | 9.39 |
| a UUID | 32895 | 21.19 ± 0.2% | 21.31 ± 0.2% | 0.64 ± 0.3% | 15.04 ± 0.3% | 3.11 ± 0.6% | 0.73 ± 0.1% | 3.61 ± 0.4% | 21.33 ± 0.1% | 0.99 | 0.99 | 1.41 | 6.81 |
| an IPv4 address | 33176 | 36.82 ± 0.3% | 36.81 ± 0.2% | 2.08 ± 0.4% | 29.38 ± 0.3% | 6.67 ± 0.3% | differs | 4.12 ± 0.2% | 36.88 ± 0.2% | 1.00 | 1.00 | 1.25 | 5.52 |
| a date and time | 32954 | 31.14 ± 0.3% | 31.20 ± 0.3% | 1.45 ± 0.2% | 21.42 ± 1.1% | 7.03 ± 0.2% | 1.25 ± 0.3% | 7.16 ± 0.3% | 31.16 ± 0.3% | 1.00 | 1.00 | 1.45 | 4.43 |
| a field path | 32606 | 29.54 ± 0.3% | 29.48 ± 0.2% | 0.97 ± 0.2% | 23.22 ± 0.2% | 3.51 ± 0.9% | differs | 2.96 ± 0.4% | 29.52 ± 0.1% | 1.00 | 1.00 | 1.27 | 8.41 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.97 ± 0.4% | 9.06 ± 0.4% | 9.04 ± 0.3% | 11.57 ± 0.2% | 4.96 ± 3.3% | 0.93 ± 0.7% | none | 9.04 ± 0.2% | 0.99 | 0.99 | 0.78 | 1.81 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.05 ± 0.1% | 236.93 ± 0.3% | 287.95 ± 0.1% | 86.57 ± 0.4% | 221.40 ± 1.9% | 475.52 ± 1.0% | 3856.74 ± 2.0% | 234.79 ± 0.4% | 0.99 | 1.00 | 2.72 | 1.06 |
| a UUID | 62 | 157.77 ± 0.3% | 158.11 ± 0.2% | 179.63 ± 0.2% | 46.60 ± 0.7% | 98.76 ± 0.9% | 186.38 ± 2.9% | 4248.96 ± 0.4% | 157.80 ± 0.5% | 1.00 | 1.00 | 3.39 | 1.60 |
| an IPv4 address | 29 | 421.87 ± 0.5% | 425.80 ± 0.3% | 619.90 ± 0.5% | 77.29 ± 0.3% | 130.39 ± 3.7% | 298.67 ± 1.6% | 7559.21 ± 0.4% | 421.96 ± 0.4% | 0.99 | 1.00 | 5.46 | 3.24 |
| a date and time | 56 | 305.77 ± 0.3% | 307.55 ± 0.6% | 397.63 ± 0.5% | 73.15 ± 0.5% | 135.96 ± 10.2% | 323.03 ± 0.7% | 4851.53 ± 0.6% | 305.79 ± 0.2% | 0.99 | 1.00 | 4.18 | 2.25 |
| a field path | 39 | 227.08 ± 0.2% | 228.57 ± 0.2% | 275.57 ± 0.3% | 80.93 ± 1.4% | 205.06 ± 1.3% | 497.99 ± 3.3% | 4888.53 ± 0.7% | 227.01 ± 0.4% | 0.99 | 1.00 | 2.81 | 1.11 |
| literal: a word | 7 | 623.45 ± 1.0% | 666.27 ± 0.5% | 1275.37 ± 0.9% | 519.44 ± 0.2% | 630.61 ± 1.6% | 947.36 ± 0.4% | 29539.72 ± 0.2% | 623.15 ± 0.7% | 0.94 | 1.00 | 1.20 | 0.99 |
| literal: a word that is not there | 8 | 598.11 ± 0.4% | 640.76 ± 0.2% | 1197.11 ± 0.8% | 479.41 ± 0.7% | 610.42 ± 1.1% | 895.14 ± 0.4% | 28599.25 ± 0.1% | 597.88 ± 0.2% | 0.93 | 1.00 | 1.25 | 0.98 |
| literal: one of four words | 26 | 241.38 ± 0.2% | 400.70 ± 0.4% | 566.33 ± 0.3% | 50.08 ± 2.8% | 243.90 ± 1.9% | 371.75 ± 1.3% | 15463.90 ± 0.8% | 241.56 ± 0.2% | 0.60 | 1.00 | 4.82 | 0.99 |
| literal: a word in any case | 11 | 484.60 ± 0.5% | 516.50 ± 0.7% | 847.06 ± 0.6% | 15.80 ± 1.6% | 649.12 ± 3.4% | refused | 23447.57 ± 0.2% | 484.70 ± 0.2% | 0.94 | 1.00 | 30.66 | 0.75 |
| literal: an href attribute | 12 | 350.10 ± 0.4% | 361.79 ± 0.4% | 496.90 ± 0.6% | 45.75 ± 0.8% | 501.85 ± 1.5% | 766.26 ± 1.1% | 21483.86 ± 0.3% | 350.10 ± 0.5% | 0.97 | 1.00 | 7.65 | 0.70 |
| literal: a word, second text | 10 | 562.06 ± 0.5% | 613.19 ± 0.7% | 1085.45 ± 0.6% | 399.17 ± 0.4% | 540.56 ± 1.2% | 796.79 ± 0.8% | 26573.68 ± 0.2% | 561.41 ± 0.3% | 0.92 | 1.00 | 1.41 | 1.04 |
| class: two capitalized words | 23 | 435.67 ± 0.5% | 467.87 ± 0.3% | 710.63 ± 0.6% | 100.16 ± 0.2% | 500.84 ± 1.0% | 738.45 ± 0.3% | 6569.21 ± 0.2% | 435.63 ± 0.1% | 0.93 | 1.00 | 4.35 | 0.87 |
| class: a word that ends in ing | 9 | 556.36 ± 0.7% | 626.17 ± 0.4% | 1178.73 ± 0.5% | 131.73 ± 2.2% | 762.12 ± 0.9% | 1094.06 ± 0.4% | 16002.73 ± 0.4% | 555.39 ± 0.5% | 0.89 | 1.00 | 4.22 | 0.73 |
| class: a word in capitals | 16 | 490.83 ± 0.5% | 533.23 ± 0.8% | 916.35 ± 0.8% | 135.66 ± 0.6% | 750.90 ± 2.5% | 1019.06 ± 1.4% | 8629.72 ± 0.1% | 489.22 ± 0.7% | 0.92 | 1.00 | 3.62 | 0.65 |
| class: a number | 6 | 611.83 ± 0.8% | 681.04 ± 1.1% | 1391.32 ± 2.0% | 41.86 ± 0.5% | 1411.42 ± 1.7% | 1851.13 ± 1.4% | 22428.22 ± 0.1% | 610.49 ± 0.6% | 0.90 | 1.00 | 14.62 | 0.43 |
| class: two capitalized words, second text | 23 | 435.48 ± 0.4% | 467.47 ± 0.4% | 710.15 ± 0.5% | 101.63 ± 0.3% | 501.69 ± 1.1% | 757.61 ± 0.3% | 6554.16 ± 0.3% | 435.65 ± 0.4% | 0.93 | 1.00 | 4.28 | 0.87 |
| other: a word between two words | 13 | 551.75 ± 0.3% | 569.20 ± 0.4% | 958.87 ± 0.5% | 133.06 ± 0.5% | 507.71 ± 2.0% | 806.79 ± 0.6% | 14759.55 ± 0.4% | 551.75 ± 0.5% | 0.97 | 1.00 | 4.15 | 1.09 |
| other: a number before a unit, second text | 15 | 405.95 ± 0.4% | 446.70 ± 0.4% | 657.32 ± 0.5% | 39.53 ± 0.6% | 636.95 ± 0.8% | 888.83 ± 1.0% | 15004.46 ± 1.0% | 406.40 ± 0.2% | 0.91 | 1.00 | 10.27 | 0.64 |
| other: a heading's start tag | 13 | 359.43 ± 0.4% | 365.60 ± 0.3% | 502.24 ± 0.8% | 43.88 ± 0.2% | 632.77 ± 0.7% | 876.30 ± 0.9% | 17923.06 ± 0.2% | 359.99 ± 0.6% | 0.98 | 1.00 | 8.19 | 0.57 |
| other: a whole word | 11 | 581.37 ± 0.2% | 617.74 ± 0.2% | 1091.88 ± 0.6% | 117.79 ± 0.4% | 569.85 ± 2.6% | 828.12 ± 0.7% | 26739.69 ± 0.5% | 581.69 ± 0.3% | 0.94 | 1.00 | 4.94 | 1.02 |
| other: a line's first word, second text | 17 | 533.71 ± 0.3% | 551.05 ± 0.3% | 944.74 ± 0.1% | 129.10 ± 0.2% | 705.06 ± 1.8% | refused | refused | 532.12 ± 0.7% | 0.97 | 1.00 | 4.13 | 0.76 |
| other: fourteen octets before an x | 16 | 111.69 ± 0.6% | 160.64 ± 0.3% | 189.79 ± 0.9% | 15.20 ± 0.4% | 452.93 ± 4.3% | 402.22 ± 0.2% | 12406.25 ± 0.3% | 111.37 ± 0.6% | 0.70 | 1.00 | 7.35 | 0.25 |
| other: a Greek word | 8 | 422.38 ± 1.0% | 586.14 ± 0.4% | 1062.44 ± 1.0% | 59.28 ± 0.5% | 1401.21 ± 1.4% | 1803.88 ± 0.5% | refused | 422.86 ± 0.5% | 0.72 | 1.00 | 7.13 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12646.92 ± 0.9% | not timed | not timed | 15762.10 ± 1.8% | 2100.70 ± 8.5% | not timed | not timed | 12678.76 ± 0.9% | | 1.00 | 0.80 | 6.02 |
| 01-literal/sherlock-casei-en | 522 | 3919.40 ± 0.9% | not timed | not timed | 3586.73 ± 0.3% | 32.46 ± 0.2% | not timed | not timed | 3938.16 ± 0.6% | | 1.00 | 1.09 | 120.75 |
| 01-literal/sherlock-ru | 724 | 13566.98 ± 0.5% | not timed | not timed | 17192.98 ± 0.6% | 1422.64 ± 5.7% | not timed | not timed | 13550.07 ± 0.5% | | 1.00 | 0.79 | 9.54 |
| 01-literal/sherlock-casei-ru | 746 | 5399.96 ± 0.2% | not timed | not timed | 3331.57 ± 0.1% | 30.73 ± 0.6% | not timed | not timed | 5396.15 ± 0.3% | | 1.00 | 1.62 | 175.73 |
| 01-literal/sherlock-zh | 30 | 16787.15 ± 0.4% | not timed | not timed | 18350.85 ± 0.5% | 2635.12 ± 17.2% | not timed | not timed | 16752.41 ± 0.5% | | 1.00 | 0.91 | 6.37 |
| 02-literal-alternate/sherlock-en | 714 | 5880.03 ± 0.4% | not timed | not timed | 3932.19 ± 0.2% | 16.54 ± 0.1% | not timed | not timed | 5876.15 ± 0.3% | | 1.00 | 1.50 | 355.49 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1708.48 ± 0.8% | not timed | not timed | 697.99 ± 0.2% | 11.05 ± 0.1% | not timed | not timed | 1698.42 ± 0.7% | | 1.01 | 2.45 | 154.66 |
| 02-literal-alternate/sherlock-ru | 899 | 4801.74 ± 0.2% | not timed | not timed | 3258.83 ± 0.2% | 22.64 ± 0.2% | not timed | not timed | 4804.90 ± 0.1% | | 1.00 | 1.47 | 212.07 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1822.05 ± 0.5% | not timed | not timed | 1231.25 ± 0.1% | 9.11 ± 0.2% | not timed | not timed | 1814.21 ± 0.3% | | 1.00 | 1.48 | 200.09 |
| 02-literal-alternate/sherlock-zh | 207 | 7085.46 ± 1.0% | not timed | not timed | 4162.58 ± 0.1% | 31.48 ± 0.1% | not timed | not timed | 7078.40 ± 0.4% | | 1.00 | 1.70 | 225.05 |
| 03-date/ascii | 111817 | 124.12 ± 0.5% | not timed | not timed | 96.18 ± 0.1% | 0.20 ± 2.1% | not timed | not timed | 123.34 ± 0.4% | | 1.01 | 1.29 | 613.02 |
| 04-ruff-noqa/real | 84 | 551.25 ± 0.2% | not timed | not timed | 479.90 ± 0.1% | 19.46 ± 1.2% | not timed | not timed | 551.99 ± 0.2% | | 1.00 | 1.15 | 28.33 |
| 04-ruff-noqa/tweaked | 44 | 544.37 ± 0.3% | not timed | not timed | 460.85 ± 0.1% | 365.91 ± 1.2% | not timed | not timed | 552.76 ± 0.3% | | 0.98 | 1.18 | 1.49 |
| 05-lexer-veryl/single | 124800 | 3.50 ± 0.8% | not timed | not timed | 5.19 ± 0.2% | 0.21 ± 3.2% | not timed | not timed | 3.59 ± 1.7% | | 0.97 | 0.67 | 17.01 |
| 06-cloud-flare-redos/original | 107 | 183.70 ± 0.6% | not timed | not timed | 216.28 ± 0.1% | 22.95 ± 0.2% | not timed | not timed | 183.63 ± 0.4% | | 1.00 | 0.85 | 8.01 |
| 06-cloud-flare-redos/simplified-short | 102 | 147.45 ± 1.0% | not timed | not timed | 226.47 ± 0.2% | 26.71 ± 0.2% | not timed | not timed | 146.80 ± 1.1% | | 1.00 | 0.65 | 5.52 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.99 ± 1.9% | not timed | not timed | 255.61 ± 0.3% | 28.86 ± 0.1% | not timed | not timed | 156.72 ± 1.9% | | 1.00 | 0.61 | 5.44 |
| 07-unicode-character-data/parse-line | 558784 | 40.01 ± 0.3% | not timed | not timed | 179.59 ± 0.1% | 43.07 ± 5.0% | not timed | not timed | 39.98 ± 0.8% | | 1.00 | 0.22 | 0.93 |
| 08-words/all-english | 56691 | 103.15 ± 0.2% | not timed | not timed | 82.62 ± 0.1% | 11.96 ± 10.1% | not timed | not timed | 102.38 ± 0.3% | | 1.01 | 1.25 | 8.63 |
| 08-words/long-english | 839 | 997.51 ± 0.2% | not timed | not timed | 597.49 ± 0.1% | 32.61 ± 0.4% | not timed | not timed | 997.38 ± 0.1% | | 1.00 | 1.67 | 30.59 |
| 09-aws-keys/full | 0 | 421.62 ± 0.1% | not timed | not timed | 491.53 ± 0.1% | 64.37 ± 3.5% | not timed | not timed | 421.19 ± 0.1% | | 1.00 | 0.86 | 6.55 |
| 09-aws-keys/quick | 0 | 403.66 ± 0.0% | not timed | not timed | 996.35 ± 0.5% | 422.68 ± 0.9% | not timed | not timed | 410.38 ± 0.1% | | 0.98 | 0.41 | 0.95 |
| 10-bounded-repeat/letters-en | 1833 | 592.25 ± 0.3% | not timed | not timed | 517.79 ± 0.5% | 19.43 ± 0.6% | not timed | not timed | 590.95 ± 0.1% | | 1.00 | 1.14 | 30.48 |
| 10-bounded-repeat/letters-ru | 3475 | 404.50 ± 0.2% | not timed | not timed | 478.94 ± 0.2% | 21.93 ± 8.0% | not timed | not timed | 401.64 ± 0.5% | | 1.01 | 0.84 | 18.44 |
| 10-bounded-repeat/context | 53 | 73.62 ± 1.0% | not timed | not timed | 65.92 ± 0.2% | 19.79 ± 0.3% | not timed | not timed | 73.19 ± 1.0% | | 1.01 | 1.12 | 3.72 |
| 10-bounded-repeat/capitals | 11 | 1040.05 ± 0.2% | not timed | not timed | 616.86 ± 0.1% | 36.66 ± 0.2% | not timed | not timed | 1039.01 ± 0.1% | | 1.00 | 1.69 | 28.37 |
| 11-unstructured-to-json/extract | 600 | 24.58 ± 0.1% | not timed | not timed | 77.10 ± 0.2% | 49.02 ± 0.4% | not timed | not timed | 24.49 ± 0.1% | | 1.00 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 602.37 ± 0.4% | not timed | not timed | 561.39 ± 0.1% | 0.40 ± 0.2% | not timed | not timed | 602.14 ± 0.3% | | 1.00 | 1.07 | 1494.82 |
| 14-quadratic/1x | 100 | 12.62 ± 0.8% | not timed | not timed | 10.03 ± 0.1% | 0.97 ± 2.6% | not timed | not timed | 12.57 ± 1.3% | | 1.00 | 1.26 | 13.07 |
| 14-quadratic/2x | 200 | 7.79 ± 0.3% | not timed | not timed | 5.54 ± 0.1% | 0.53 ± 1.6% | not timed | not timed | 7.77 ± 0.6% | | 1.00 | 1.40 | 14.71 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.6% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 1.83 ± 0.4% | | 1.00 | 1.51 | 15.85 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.3% | not timed | not timed | 0.34 ± 0.5% | 0.55 ± 6.2% | not timed | not timed | 1.44 ± 0.3% | | 1.00 | 4.21 | 2.62 |
| 04-ruff-noqa/compile-real | 1 | 92.76 ± 0.2% | not timed | not timed | 13.89 ± 0.1% | 140.78 ± 2.8% | not timed | not timed | 92.69 ± 0.4% | | 1.00 | 6.68 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.58 ± 1.2% | not timed | not timed | 2.53 ± 0.5% | 6.45 ± 2.3% | not timed | not timed | 14.47 ± 1.2% | | 1.01 | 5.76 | 2.26 |
| 07-unicode-character-data/compile | 1 | 58.44 ± 0.1% | not timed | not timed | 26.24 ± 0.5% | 36.84 ± 2.2% | not timed | not timed | 58.43 ± 1.3% | | 1.00 | 2.23 | 1.59 |
| 09-aws-keys/compile-full | 1 | 43.66 ± 0.3% | not timed | not timed | 8.28 ± 0.2% | 23.41 ± 0.7% | not timed | not timed | 43.48 ± 1.2% | | 1.00 | 5.27 | 1.86 |
| 09-aws-keys/compile-quick | 1 | 187.85 ± 0.2% | not timed | not timed | 47.89 ± 0.1% | 135.81 ± 3.1% | not timed | not timed | 188.68 ± 0.4% | | 1.00 | 3.92 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.66 ± 0.8% | not timed | not timed | 11.07 ± 0.2% | 16.14 ± 2.2% | not timed | not timed | 14.53 ± 0.9% | | 1.01 | 1.32 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.21 ± 0.4% | not timed | not timed | 8.00 ± 0.2% | 23.88 ± 3.0% | not timed | not timed | 85.13 ± 0.7% | | 1.00 | 10.65 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 90.84 ± 0.2% | not timed | not timed | 40.77 ± 0.4% | 69.08 ± 2.7% | not timed | not timed | 90.76 ± 1.1% | | 1.00 | 2.23 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 0.7% | 0.10 ± 14.7% | not timed | not timed | 0.36 ± 1.3% | | 1.00 | 5.14 | 3.63 |

