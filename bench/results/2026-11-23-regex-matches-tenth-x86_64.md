# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127356161 |
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
| literal: a word | 217 | 32602.67 ± 0.6% | 1088.84 ± 0.2% | 36.83 ± 0.4% | 32888.23 ± 0.9% | 12071.49 ± 5.1% | 14.84 ± 0.4% | 115.76 ± 2.0% | 32572.89 ± 0.8% | 29.94 | 1.00 | 0.99 | 2.70 |
| literal: a word that is not there | 0 | 42774.82 ± 0.2% | 1101.67 ± 0.1% | 36.85 ± 0.4% | 36376.38 ± 0.1% | 40533.96 ± 0.6% | 14.36 ± 0.0% | 110.39 ± 0.4% | 42711.47 ± 0.2% | 38.83 | 1.00 | 1.18 | 1.06 |
| literal: one of four words | 661 | 13585.29 ± 1.5% | 1069.00 ± 0.2% | 19.54 ± 0.9% | 9750.39 ± 1.2% | 29.23 ± 0.6% | 4.33 ± 0.2% | 9.67 ± 0.7% | 13430.49 ± 0.9% | 12.71 | 1.01 | 1.39 | 464.81 |
| literal: a word in any case | 217 | 27772.09 ± 1.3% | 1089.38 ± 0.3% | 25.35 ± 1.2% | 10082.36 ± 0.1% | 58.63 ± 1.0% | refused | differs | 27785.19 ± 0.4% | 25.49 | 1.00 | 2.75 | 473.70 |
| literal: an href attribute | 33 | 28364.79 ± 0.1% | 1095.05 ± 0.1% | 32.41 ± 0.7% | 29318.68 ± 0.4% | 2584.63 ± 0.5% | 10.59 ± 1.8% | 102.04 ± 0.6% | 28289.28 ± 0.3% | 25.90 | 1.00 | 0.97 | 10.97 |
| literal: a word, second text | 123 | 34076.25 ± 0.7% | 1091.85 ± 0.3% | 35.45 ± 0.5% | 32734.27 ± 0.6% | 8999.42 ± 6.7% | 19.18 ± 0.3% | 99.27 ± 1.5% | 34136.99 ± 0.5% | 31.21 | 1.00 | 1.04 | 3.79 |
| class: two capitalized words | 1331 | 1010.56 ± 14.2% | 1015.08 ± 0.4% | 33.61 ± 0.7% | 612.00 ± 0.1% | 48.85 ± 17.1% | 12.62 ± 0.2% | 82.02 ± 0.2% | 1009.27 ± 0.2% | 1.00 | 1.00 | 1.65 | 20.69 |
| class: a word that ends in ing | 3399 | 919.77 ± 0.3% | 920.74 ± 0.1% | 21.89 ± 0.7% | 575.74 ± 0.2% | 35.52 ± 7.2% | 7.13 ± 0.3% | 23.27 ± 0.8% | 919.64 ± 0.1% | 1.00 | 1.00 | 1.60 | 25.90 |
| class: a word in capitals | 2332 | 1358.79 ± 0.1% | 985.00 ± 0.1% | 36.01 ± 1.0% | 603.20 ± 0.1% | 52.50 ± 2.1% | 15.17 ± 0.2% | 105.95 ± 0.2% | 1356.12 ± 0.8% | 1.38 | 1.00 | 2.25 | 25.88 |
| class: a number | 8288 | 1995.90 ± 0.2% | 856.08 ± 0.2% | 34.75 ± 0.8% | 2137.59 ± 0.3% | 54.17 ± 8.7% | 0.42 ± 0.2% | 80.41 ± 0.8% | 1995.57 ± 0.2% | 2.33 | 1.00 | 0.93 | 36.85 |
| class: two capitalized words, second text | 5359 | 756.23 ± 0.3% | 754.85 ± 0.1% | 30.03 ± 1.6% | 506.23 ± 0.2% | 42.58 ± 11.2% | 16.41 ± 0.4% | 75.16 ± 0.4% | 754.60 ± 0.1% | 1.00 | 1.00 | 1.49 | 17.76 |
| other: a word between two words | 6104 | 769.66 ± 0.6% | 794.33 ± 0.7% | 29.70 ± 0.3% | 876.63 ± 0.2% | 134.82 ± 17.4% | 9.62 ± 0.8% | 87.37 ± 0.2% | 769.51 ± 0.1% | 0.97 | 1.00 | 0.88 | 5.71 |
| other: a number before a unit, second text | 1481 | 8841.25 ± 1.7% | 1026.60 ± 0.1% | 33.62 ± 1.9% | 9513.58 ± 0.6% | 49.28 ± 0.5% | 17.16 ± 0.3% | 79.12 ± 0.2% | 8734.27 ± 0.5% | 8.61 | 1.01 | 0.93 | 179.39 |
| other: a heading's start tag | 110 | 20873.17 ± 0.4% | 1083.13 ± 0.1% | 35.44 ± 2.8% | 2701.82 ± 3.1% | 1902.33 ± 4.3% | 13.19 ± 0.2% | 119.74 ± 0.3% | 20814.33 ± 0.1% | 19.27 | 1.00 | 7.73 | 10.97 |
| other: a whole word | 217 | 25501.19 ± 0.4% | 1089.00 ± 0.6% | 37.11 ± 1.1% | 26348.27 ± 1.7% | 60.23 ± 0.6% | 12.57 ± 0.2% | 68.29 ± 0.4% | 25487.41 ± 0.3% | 23.42 | 1.00 | 0.97 | 423.41 |
| other: a line's first word, second text | 3716 | 2305.36 ± 0.4% | 911.78 ± 0.2% | 38.17 ± 3.4% | 2264.26 ± 0.4% | 82.35 ± 7.0% | refused | refused | 2293.89 ± 0.5% | 2.53 | 1.01 | 1.02 | 27.99 |
| other: fourteen octets before an x | 87 | 35517.11 ± 1.1% | 298.91 ± 0.3% | 7.49 ± 0.3% | 4152.96 ± 0.3% | 11.64 ± 1.0% | differs | 20.85 ± 0.5% | 35399.47 ± 3.2% | 118.82 | 1.00 | 8.55 | 3052.08 |
| other: a Greek word | 21815 | 491.83 ± 0.7% | 363.33 ± 1.4% | 37.62 ± 0.7% | 312.86 ± 0.5% | 53.48 ± 2.1% | differs | refused | 490.00 ± 0.2% | 1.35 | 1.00 | 1.57 | 9.20 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.96 ± 0.5% | 29.97 ± 0.8% | 1.08 ± 0.4% | 21.45 ± 0.1% | 3.21 ± 0.8% | differs | 5.01 ± 1.0% | 29.88 ± 0.8% | 1.00 | 1.00 | 1.40 | 9.34 |
| a UUID | 32895 | 26.57 ± 0.8% | 26.63 ± 0.2% | 0.77 ± 0.4% | 16.42 ± 0.4% | 3.24 ± 2.3% | 0.71 ± 0.2% | 4.10 ± 2.1% | 26.59 ± 0.3% | 1.00 | 1.00 | 1.62 | 8.19 |
| an IPv4 address | 33176 | 39.34 ± 0.4% | 39.56 ± 0.3% | 2.49 ± 0.6% | 31.38 ± 0.2% | 8.11 ± 0.4% | differs | 4.93 ± 0.4% | 39.56 ± 0.3% | 0.99 | 0.99 | 1.25 | 4.85 |
| a date and time | 32954 | 39.48 ± 1.2% | 39.50 ± 0.9% | 1.78 ± 0.6% | 23.81 ± 0.2% | 10.27 ± 3.1% | 1.29 ± 0.3% | 9.23 ± 0.9% | 39.46 ± 0.7% | 1.00 | 1.00 | 1.66 | 3.84 |
| a field path | 32606 | 32.22 ± 0.5% | 32.25 ± 0.4% | 1.27 ± 0.6% | 24.73 ± 0.3% | 3.70 ± 0.8% | differs | 3.13 ± 2.4% | 32.20 ± 0.5% | 1.00 | 1.00 | 1.30 | 8.72 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.36 ± 0.9% | 12.41 ± 0.6% | 12.41 ± 0.5% | 14.52 ± 2.6% | 6.67 ± 2.4% | 1.01 ± 0.5% | none | 12.40 ± 0.2% | 1.00 | 1.00 | 0.85 | 1.85 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 307.44 ± 0.3% | 309.14 ± 0.5% | 361.32 ± 3.0% | 116.36 ± 4.4% | 262.21 ± 1.5% | 683.35 ± 1.8% | 4325.73 ± 1.0% | 307.55 ± 0.2% | 0.99 | 1.00 | 2.64 | 1.17 |
| a UUID | 62 | 198.70 ± 1.1% | 199.45 ± 0.8% | 221.88 ± 0.8% | 61.80 ± 1.4% | 117.01 ± 10.9% | 257.34 ± 2.4% | 5610.54 ± 0.2% | 198.62 ± 0.5% | 1.00 | 1.00 | 3.22 | 1.70 |
| an IPv4 address | 29 | 584.08 ± 4.6% | 590.02 ± 0.5% | 827.41 ± 0.5% | 100.40 ± 0.2% | 155.31 ± 2.0% | 433.46 ± 0.2% | 10286.80 ± 0.7% | 586.02 ± 0.6% | 0.99 | 1.00 | 5.82 | 3.76 |
| a date and time | 56 | 451.51 ± 3.7% | 454.71 ± 0.4% | 577.69 ± 4.9% | 96.65 ± 0.6% | 166.29 ± 3.0% | 450.45 ± 2.4% | 5604.59 ± 0.6% | 451.53 ± 0.3% | 0.99 | 1.00 | 4.67 | 2.72 |
| a field path | 39 | 298.36 ± 4.9% | 299.37 ± 0.8% | 349.58 ± 0.4% | 105.23 ± 0.8% | 245.41 ± 0.3% | 705.13 ± 1.4% | 5402.79 ± 0.6% | 298.19 ± 1.1% | 1.00 | 1.00 | 2.84 | 1.22 |
| literal: a word | 7 | 925.25 ± 0.3% | 996.34 ± 0.5% | 1794.12 ± 0.7% | 709.35 ± 1.0% | 808.40 ± 2.0% | 1464.74 ± 0.5% | 37802.50 ± 4.6% | 924.96 ± 0.6% | 0.93 | 1.00 | 1.30 | 1.14 |
| literal: a word that is not there | 8 | 882.14 ± 0.3% | 964.46 ± 0.5% | 1684.26 ± 0.6% | 635.78 ± 0.5% | 769.19 ± 2.2% | 1371.27 ± 0.6% | 36086.35 ± 2.9% | 880.76 ± 0.5% | 0.91 | 1.00 | 1.39 | 1.15 |
| literal: one of four words | 26 | 348.68 ± 0.7% | 598.51 ± 0.6% | 820.80 ± 0.9% | 50.58 ± 1.0% | 299.67 ± 2.3% | 510.76 ± 2.7% | 19384.06 ± 0.8% | 347.95 ± 0.2% | 0.58 | 1.00 | 6.89 | 1.16 |
| literal: a word in any case | 11 | 692.68 ± 0.4% | 741.49 ± 0.4% | 1107.71 ± 4.0% | 17.81 ± 3.6% | 825.60 ± 7.4% | refused | 30331.31 ± 0.8% | 691.73 ± 0.3% | 0.93 | 1.00 | 38.88 | 0.84 |
| literal: an href attribute | 12 | 465.39 ± 0.7% | 478.68 ± 3.7% | 623.58 ± 0.6% | 50.09 ± 0.4% | 615.57 ± 0.8% | 1164.65 ± 0.7% | 26999.09 ± 0.6% | 465.07 ± 0.5% | 0.97 | 1.00 | 9.29 | 0.76 |
| literal: a word, second text | 10 | 819.85 ± 4.1% | 911.03 ± 0.1% | 1532.61 ± 0.3% | 595.73 ± 0.4% | 646.75 ± 17.9% | 1185.16 ± 2.5% | 33046.92 ± 3.7% | 819.15 ± 0.4% | 0.90 | 1.00 | 1.38 | 1.27 |
| class: two capitalized words | 23 | 663.42 ± 2.8% | 718.20 ± 0.3% | 1058.40 ± 4.6% | 136.18 ± 0.4% | 636.94 ± 17.0% | 1107.57 ± 1.0% | 7684.00 ± 0.3% | 663.39 ± 0.1% | 0.92 | 1.00 | 4.87 | 1.04 |
| class: a word that ends in ing | 9 | 803.15 ± 0.4% | 917.82 ± 4.2% | 1621.32 ± 0.2% | 171.99 ± 0.6% | 930.28 ± 14.6% | 1742.66 ± 0.8% | 20217.75 ± 4.2% | 802.66 ± 1.2% | 0.88 | 1.00 | 4.67 | 0.86 |
| class: a word in capitals | 16 | 732.26 ± 0.6% | 797.92 ± 0.7% | 1329.68 ± 0.2% | 180.09 ± 3.4% | 927.95 ± 12.8% | 1604.77 ± 0.7% | 10182.68 ± 0.4% | 731.94 ± 3.0% | 0.92 | 1.00 | 4.07 | 0.79 |
| class: a number | 6 | 891.81 ± 3.7% | 996.26 ± 0.2% | 1885.66 ± 0.2% | 44.68 ± 2.6% | 1721.44 ± 10.9% | 2988.76 ± 2.7% | 29973.19 ± 0.4% | 891.79 ± 0.2% | 0.90 | 1.00 | 19.96 | 0.52 |
| class: two capitalized words, second text | 23 | 662.76 ± 0.2% | 718.77 ± 0.5% | 1057.84 ± 0.7% | 135.26 ± 3.6% | 631.83 ± 12.8% | 1122.95 ± 1.2% | 7686.74 ± 0.4% | 663.05 ± 0.3% | 0.92 | 1.00 | 4.90 | 1.05 |
| other: a word between two words | 13 | 789.10 ± 0.3% | 825.41 ± 0.6% | 1310.62 ± 0.3% | 180.45 ± 0.8% | 624.37 ± 4.1% | 1210.99 ± 1.1% | 18406.00 ± 2.2% | 787.92 ± 0.3% | 0.96 | 1.00 | 4.37 | 1.26 |
| other: a number before a unit, second text | 15 | 562.75 ± 0.3% | 623.79 ± 0.2% | 872.20 ± 3.5% | 41.71 ± 3.0% | 792.11 ± 0.7% | 1346.55 ± 2.5% | 19158.70 ± 0.3% | 562.13 ± 4.5% | 0.90 | 1.00 | 13.49 | 0.71 |
| other: a heading's start tag | 13 | 482.18 ± 0.4% | 491.41 ± 0.2% | 641.90 ± 5.4% | 47.72 ± 0.3% | 771.76 ± 3.6% | 1295.04 ± 0.5% | 22807.95 ± 3.1% | 483.10 ± 0.4% | 0.98 | 1.00 | 10.10 | 0.62 |
| other: a whole word | 11 | 826.50 ± 0.8% | 887.80 ± 0.4% | 1460.83 ± 1.3% | 161.09 ± 1.4% | 724.34 ± 1.1% | 1241.84 ± 1.1% | 32595.34 ± 3.2% | 827.22 ± 0.1% | 0.93 | 1.00 | 5.13 | 1.14 |
| other: a line's first word, second text | 17 | 754.69 ± 0.4% | 787.41 ± 0.3% | 1251.84 ± 0.2% | 172.83 ± 0.3% | 878.44 ± 1.2% | refused | refused | 752.17 ± 0.6% | 0.96 | 1.00 | 4.37 | 0.86 |
| other: fourteen octets before an x | 16 | 135.82 ± 0.3% | 198.32 ± 0.3% | 228.46 ± 0.2% | 18.53 ± 0.3% | 553.22 ± 1.8% | 597.73 ± 1.0% | 16358.49 ± 0.9% | 135.79 ± 0.3% | 0.68 | 1.00 | 7.33 | 0.25 |
| other: a Greek word | 8 | 589.34 ± 0.6% | 817.65 ± 0.3% | 1333.42 ± 0.2% | 61.78 ± 0.2% | 1717.73 ± 1.2% | 2881.98 ± 0.3% | refused | 588.82 ± 0.2% | 0.72 | 1.00 | 9.54 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 23531.84 ± 0.3% | not timed | not timed | 28999.70 ± 0.8% | 2675.44 ± 21.7% | not timed | not timed | 23467.62 ± 0.3% | | 1.00 | 0.81 | 8.80 |
| 01-literal/sherlock-casei-en | 522 | 5574.58 ± 0.5% | not timed | not timed | 8505.30 ± 0.2% | 40.14 ± 0.4% | not timed | not timed | 5581.79 ± 0.3% | | 1.00 | 0.66 | 138.88 |
| 01-literal/sherlock-ru | 724 | 24529.03 ± 0.3% | not timed | not timed | 28404.22 ± 0.3% | 1595.11 ± 5.9% | not timed | not timed | 24493.22 ± 0.6% | | 1.00 | 0.86 | 15.38 |
| 01-literal/sherlock-casei-ru | 746 | 8546.94 ± 0.3% | not timed | not timed | 6426.60 ± 0.7% | 42.92 ± 0.4% | not timed | not timed | 8558.59 ± 0.2% | | 1.00 | 1.33 | 199.15 |
| 01-literal/sherlock-zh | 30 | 38324.70 ± 0.3% | not timed | not timed | 35284.97 ± 0.7% | 1624.34 ± 1.0% | not timed | not timed | 38286.97 ± 0.2% | | 1.00 | 1.09 | 23.59 |
| 02-literal-alternate/sherlock-en | 714 | 12219.33 ± 0.6% | not timed | not timed | 9440.47 ± 0.3% | 22.44 ± 4.1% | not timed | not timed | 12176.20 ± 0.4% | | 1.00 | 1.29 | 544.51 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2049.69 ± 0.7% | not timed | not timed | 2311.91 ± 0.2% | 13.61 ± 0.7% | not timed | not timed | 2032.19 ± 0.1% | | 1.01 | 0.89 | 150.55 |
| 02-literal-alternate/sherlock-ru | 899 | 7013.42 ± 0.6% | not timed | not timed | 5170.67 ± 0.3% | 28.94 ± 0.8% | not timed | not timed | 7026.66 ± 0.9% | | 1.00 | 1.36 | 242.35 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2131.98 ± 0.5% | not timed | not timed | 1248.45 ± 0.3% | 11.78 ± 0.3% | not timed | not timed | 2128.93 ± 0.2% | | 1.00 | 1.71 | 181.05 |
| 02-literal-alternate/sherlock-zh | 207 | 16510.04 ± 0.2% | not timed | not timed | 10770.72 ± 0.1% | 41.52 ± 0.7% | not timed | not timed | 16458.95 ± 0.2% | | 1.00 | 1.53 | 397.59 |
| 03-date/ascii | 111817 | 125.64 ± 0.4% | not timed | not timed | 110.73 ± 0.3% | 0.27 ± 1.8% | not timed | not timed | 124.77 ± 1.1% | | 1.01 | 1.13 | 464.71 |
| 04-ruff-noqa/real | 84 | 718.39 ± 2.4% | not timed | not timed | 569.94 ± 0.4% | 25.89 ± 1.5% | not timed | not timed | 724.33 ± 2.1% | | 0.99 | 1.26 | 27.75 |
| 04-ruff-noqa/tweaked | 44 | 632.11 ± 0.7% | not timed | not timed | 544.54 ± 0.2% | 376.70 ± 14.2% | not timed | not timed | 625.30 ± 0.7% | | 1.01 | 1.16 | 1.68 |
| 05-lexer-veryl/single | 124800 | 4.01 ± 0.3% | not timed | not timed | 5.70 ± 0.1% | 0.27 ± 8.1% | not timed | not timed | 4.00 ± 2.5% | | 1.00 | 0.70 | 14.83 |
| 06-cloud-flare-redos/original | 107 | 310.31 ± 0.3% | not timed | not timed | 263.02 ± 0.5% | 31.39 ± 5.4% | not timed | not timed | 309.73 ± 4.2% | | 1.00 | 1.18 | 9.88 |
| 06-cloud-flare-redos/simplified-short | 102 | 286.93 ± 1.4% | not timed | not timed | 267.81 ± 0.4% | 31.72 ± 3.0% | not timed | not timed | 286.86 ± 1.4% | | 1.00 | 1.07 | 9.05 |
| 06-cloud-flare-redos/simplified-long | 10000 | 296.93 ± 0.2% | not timed | not timed | 280.22 ± 0.2% | 38.10 ± 0.8% | not timed | not timed | 296.84 ± 0.3% | | 1.00 | 1.06 | 7.79 |
| 07-unicode-character-data/parse-line | 558784 | 275.30 ± 0.7% | not timed | not timed | 206.88 ± 0.3% | 53.38 ± 0.7% | not timed | not timed | 274.86 ± 0.3% | | 1.00 | 1.33 | 5.16 |
| 08-words/all-english | 56691 | 115.68 ± 0.6% | not timed | not timed | 93.03 ± 0.5% | 15.50 ± 8.6% | not timed | not timed | 115.25 ± 0.3% | | 1.00 | 1.24 | 7.47 |
| 08-words/long-english | 839 | 1047.84 ± 0.3% | not timed | not timed | 625.10 ± 0.1% | 38.15 ± 0.4% | not timed | not timed | 1047.44 ± 0.2% | | 1.00 | 1.68 | 27.46 |
| 09-aws-keys/full | 0 | 567.35 ± 0.5% | not timed | not timed | 577.02 ± 0.4% | 82.54 ± 2.7% | not timed | not timed | 567.32 ± 0.1% | | 1.00 | 0.98 | 6.87 |
| 09-aws-keys/quick | 0 | 997.01 ± 1.9% | not timed | not timed | 896.15 ± 0.8% | 408.15 ± 15.6% | not timed | not timed | 1005.00 ± 4.1% | | 0.99 | 1.11 | 2.44 |
| 10-bounded-repeat/letters-en | 1833 | 625.13 ± 0.4% | not timed | not timed | 550.96 ± 0.6% | 24.25 ± 0.4% | not timed | not timed | 623.59 ± 0.5% | | 1.00 | 1.13 | 25.77 |
| 10-bounded-repeat/letters-ru | 3475 | 385.27 ± 0.4% | not timed | not timed | 494.98 ± 0.5% | 24.98 ± 5.9% | not timed | not timed | 385.08 ± 0.3% | | 1.00 | 0.78 | 15.43 |
| 10-bounded-repeat/context | 53 | 89.82 ± 0.8% | not timed | not timed | 74.04 ± 0.4% | 24.34 ± 0.3% | not timed | not timed | 89.65 ± 1.2% | | 1.00 | 1.21 | 3.69 |
| 10-bounded-repeat/capitals | 11 | 1080.50 ± 0.5% | not timed | not timed | 641.79 ± 0.3% | 44.90 ± 0.4% | not timed | not timed | 1075.47 ± 0.3% | | 1.00 | 1.68 | 24.07 |
| 11-unstructured-to-json/extract | 600 | 47.55 ± 0.3% | not timed | not timed | 80.40 ± 0.3% | 64.38 ± 0.8% | not timed | not timed | 47.37 ± 0.6% | | 1.00 | 0.59 | 0.74 |
| 12-dictionary/single | 1 | 570.87 ± 0.2% | not timed | not timed | 547.87 ± 0.2% | 0.52 ± 0.4% | not timed | not timed | 573.20 ± 0.1% | | 1.00 | 1.04 | 1103.16 |
| 14-quadratic/1x | 100 | 14.62 ± 1.4% | not timed | not timed | 13.52 ± 2.4% | 1.24 ± 0.8% | not timed | not timed | 14.58 ± 0.1% | | 1.00 | 1.08 | 11.75 |
| 14-quadratic/2x | 200 | 8.70 ± 1.4% | not timed | not timed | 6.61 ± 0.1% | 0.69 ± 1.2% | not timed | not timed | 8.65 ± 1.2% | | 1.01 | 1.32 | 12.59 |
| 14-quadratic/10x | 1000 | 1.94 ± 0.8% | not timed | not timed | 1.30 ± 0.1% | 0.15 ± 0.9% | not timed | not timed | 1.94 ± 1.3% | | 1.00 | 1.50 | 12.72 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.99 ± 3.3% | not timed | not timed | 0.45 ± 1.1% | 0.65 ± 8.2% | not timed | not timed | 1.97 ± 4.7% | | 1.01 | 4.44 | 3.08 |
| 04-ruff-noqa/compile-real | 1 | 122.94 ± 0.2% | not timed | not timed | 15.90 ± 0.7% | 175.34 ± 1.2% | not timed | not timed | 122.21 ± 0.2% | | 1.01 | 7.73 | 0.70 |
| 05-lexer-veryl/compile-single | 1 | 21.49 ± 0.3% | not timed | not timed | 3.06 ± 1.4% | 7.73 ± 1.0% | not timed | not timed | 21.42 ± 0.6% | | 1.00 | 7.02 | 2.78 |
| 07-unicode-character-data/compile | 1 | 75.66 ± 6.1% | not timed | not timed | 32.69 ± 0.9% | 43.88 ± 1.1% | not timed | not timed | 75.19 ± 0.6% | | 1.01 | 2.31 | 1.72 |
| 09-aws-keys/compile-full | 1 | 52.67 ± 0.1% | not timed | not timed | 9.10 ± 4.3% | 27.96 ± 0.8% | not timed | not timed | 52.45 ± 3.7% | | 1.00 | 5.79 | 1.88 |
| 09-aws-keys/compile-quick | 1 | 245.77 ± 5.1% | not timed | not timed | 60.11 ± 0.7% | 162.35 ± 2.8% | not timed | not timed | 244.45 ± 0.7% | | 1.01 | 4.09 | 1.51 |
| 10-bounded-repeat/compile-context | 1 | 16.67 ± 1.3% | not timed | not timed | 14.55 ± 0.2% | 20.44 ± 2.6% | not timed | not timed | 16.53 ± 1.0% | | 1.01 | 1.15 | 0.82 |
| 10-bounded-repeat/compile-capitals | 1 | 102.83 ± 1.1% | not timed | not timed | 10.91 ± 0.2% | 29.49 ± 2.7% | not timed | not timed | 102.24 ± 4.6% | | 1.01 | 9.42 | 3.49 |
| 11-unstructured-to-json/compile | 1 | 116.05 ± 0.6% | not timed | not timed | 50.66 ± 3.2% | 83.01 ± 3.0% | not timed | not timed | 115.13 ± 0.7% | | 1.01 | 2.29 | 1.40 |
| 12-dictionary/compile-single | 1 | 0.38 ± 0.2% | not timed | not timed | 0.08 ± 17.7% | 0.11 ± 30.3% | not timed | not timed | 0.37 ± 2.4% | | 1.01 | 4.61 | 3.51 |

