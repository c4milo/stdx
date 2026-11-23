# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215406562 |
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
| literal: a word | 217 | 55817.84 ± 4.2% | 6465.10 ± 3.9% | 44.69 ± 3.4% | 53430.67 ± 2.6% | 16545.12 ± 12.4% | 16.27 ± 3.5% | 163.87 ± 4.2% | 55149.67 ± 5.6% | 8.63 | 1.01 | 1.04 | 3.37 |
| literal: a word that is not there | 0 | 83081.18 ± 2.5% | 6226.95 ± 2.5% | 44.98 ± 3.4% | 66230.89 ± 4.3% | 56522.16 ± 4.5% | 15.62 ± 42.1% | 150.86 ± 3.9% | 82048.50 ± 4.4% | 13.34 | 1.01 | 1.25 | 1.47 |
| literal: one of four words | 661 | 20221.90 ± 1.1% | 2417.74 ± 2.1% | 24.91 ± 3.0% | 14991.38 ± 2.5% | 40.04 ± 5.0% | 5.29 ± 5.3% | 13.61 ± 8.1% | 20144.25 ± 2.5% | 8.36 | 1.00 | 1.35 | 505.10 |
| literal: a word in any case | 217 | 47689.64 ± 6.4% | 2598.41 ± 4.4% | 33.82 ± 1.6% | 14887.96 ± 0.5% | 74.60 ± 34.6% | refused | differs | 48757.31 ± 8.5% | 18.35 | 0.98 | 3.20 | 639.24 |
| literal: an href attribute | 33 | 48021.92 ± 2.2% | 754.06 ± 1.3% | 39.17 ± 2.0% | 47931.41 ± 3.1% | 3684.30 ± 1.0% | 11.38 ± 6.7% | 137.91 ± 2.3% | 48013.10 ± 5.3% | 63.68 | 1.00 | 1.00 | 13.03 |
| literal: a word, second text | 123 | 54138.47 ± 9.8% | 4399.56 ± 5.8% | 43.96 ± 5.0% | 49555.81 ± 4.7% | 14346.41 ± 9.4% | 20.88 ± 4.1% | 128.46 ± 8.6% | 53176.39 ± 11.1% | 12.31 | 1.02 | 1.09 | 3.77 |
| class: two capitalized words | 1331 | 1110.97 ± 5.7% | 725.85 ± 4.9% | 40.09 ± 9.2% | 705.92 ± 5.9% | 61.72 ± 7.7% | 13.93 ± 4.6% | 103.39 ± 28.7% | 1095.19 ± 49.8% | 1.53 | 1.01 | 1.57 | 18.00 |
| class: a word that ends in ing | 3399 | 690.23 ± 5.3% | 694.54 ± 5.7% | 26.74 ± 5.8% | 638.59 ± 8.3% | 44.45 ± 17.2% | 7.84 ± 2.9% | 30.97 ± 1.2% | 693.64 ± 4.6% | 0.99 | 1.00 | 1.08 | 15.53 |
| class: a word in capitals | 2332 | 1597.51 ± 60.1% | 714.08 ± 14.1% | 41.30 ± 7.1% | 677.27 ± 3.7% | 64.35 ± 5.5% | 16.41 ± 5.8% | 131.62 ± 11.0% | 1572.70 ± 7.8% | 2.24 | 1.02 | 2.36 | 24.83 |
| class: a number | 8288 | 2800.41 ± 0.7% | 1006.50 ± 1.4% | 44.23 ± 3.1% | 2396.82 ± 2.7% | 62.36 ± 25.2% | 0.46 ± 2.3% | 99.19 ± 7.1% | 2775.75 ± 0.8% | 2.78 | 1.01 | 1.17 | 44.91 |
| class: two capitalized words, second text | 5359 | 598.96 ± 3.2% | 605.79 ± 1.3% | 31.76 ± 1.1% | 563.23 ± 2.1% | 47.81 ± 15.4% | 17.82 ± 1.5% | 96.43 ± 1.3% | 594.68 ± 3.9% | 0.99 | 1.01 | 1.06 | 12.53 |
| other: a word between two words | 6104 | 1061.48 ± 4.0% | 687.98 ± 4.4% | 35.71 ± 8.1% | 1000.13 ± 5.9% | 165.24 ± 16.6% | 10.41 ± 4.2% | 118.35 ± 4.9% | 1084.74 ± 4.3% | 1.54 | 0.98 | 1.06 | 6.42 |
| other: a number before a unit, second text | 1481 | 13041.01 ± 4.8% | 1431.68 ± 5.3% | 42.03 ± 8.9% | 11181.38 ± 5.0% | 62.21 ± 8.4% | 19.49 ± 5.5% | 107.25 ± 5.7% | 12817.16 ± 6.3% | 9.11 | 1.02 | 1.17 | 209.62 |
| other: a heading's start tag | 110 | 28733.29 ± 2.3% | 842.87 ± 0.4% | 38.98 ± 2.4% | 3175.76 ± 1.8% | 2445.83 ± 8.7% | 13.18 ± 2.3% | 157.94 ± 5.7% | 28593.55 ± 3.5% | 34.09 | 1.00 | 9.05 | 11.75 |
| other: a whole word | 217 | 36630.98 ± 0.6% | 687.64 ± 1.2% | 43.12 ± 6.6% | 35654.50 ± 0.7% | 71.52 ± 2.2% | 12.76 ± 0.6% | 82.37 ± 1.2% | 36574.96 ± 0.4% | 53.27 | 1.00 | 1.03 | 512.15 |
| other: a line's first word, second text | 3716 | 3189.82 ± 5.1% | 669.27 ± 2.4% | 46.77 ± 2.2% | 3371.95 ± 8.0% | 95.88 ± 7.9% | refused | refused | 3164.21 ± 4.8% | 4.77 | 1.01 | 0.95 | 33.27 |
| other: fourteen octets before an x | 87 | 45054.97 ± 6.3% | 356.83 ± 8.8% | 9.23 ± 7.9% | 5044.95 ± 6.0% | 14.92 ± 9.1% | differs | 27.54 ± 11.0% | 46759.58 ± 9.7% | 126.26 | 0.96 | 8.93 | 3020.09 |
| other: a Greek word | 21815 | 600.06 ± 5.4% | 492.29 ± 4.0% | 49.66 ± 3.4% | 370.32 ± 1.8% | 60.69 ± 10.4% | differs | refused | 623.72 ± 0.6% | 1.22 | 0.96 | 1.62 | 9.89 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.30 ± 0.9% | 28.39 ± 1.6% | 1.61 ± 2.1% | 24.90 ± 2.6% | 3.68 ± 2.3% | differs | 6.21 ± 5.2% | 28.15 ± 2.0% | 1.00 | 1.01 | 1.14 | 7.70 |
| a UUID | 32895 | 30.91 ± 2.1% | 30.90 ± 0.5% | 1.07 ± 0.8% | 18.99 ± 0.4% | 3.66 ± 2.9% | 0.77 ± 0.5% | 4.94 ± 2.9% | 30.88 ± 7.1% | 1.00 | 1.00 | 1.63 | 8.45 |
| an IPv4 address | 33176 | 46.42 ± 2.9% | 46.34 ± 2.6% | 3.12 ± 21.2% | 33.96 ± 48.6% | 8.91 ± 5.7% | differs | 5.81 ± 5.5% | 46.26 ± 5.5% | 1.00 | 1.00 | 1.37 | 5.21 |
| a date and time | 32954 | 44.74 ± 5.6% | 44.71 ± 6.0% | 2.35 ± 29.9% | 26.25 ± 5.7% | 10.59 ± 8.9% | 1.33 ± 5.1% | 11.35 ± 6.8% | 44.05 ± 6.0% | 1.00 | 1.02 | 1.70 | 4.22 |
| a field path | 32606 | 31.21 ± 4.5% | 30.80 ± 4.7% | 1.73 ± 2.9% | 27.32 ± 2.3% | 4.63 ± 5.1% | differs | 4.15 ± 20.7% | 30.10 ± 44.1% | 1.01 | 1.04 | 1.14 | 6.74 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.09 ± 4.0% | 14.29 ± 5.8% | 15.07 ± 8.8% | 17.10 ± 5.0% | 7.42 ± 5.1% | 1.06 ± 5.0% | none | 13.88 ± 5.3% | 1.06 | 1.09 | 0.88 | 2.03 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 363.49 ± 7.5% | 366.76 ± 7.3% | 426.59 ± 6.7% | 133.06 ± 8.1% | 319.31 ± 2.9% | 883.02 ± 4.1% | 5717.64 ± 1.9% | 361.67 ± 3.5% | 0.99 | 1.01 | 2.73 | 1.14 |
| a UUID | 62 | 234.45 ± 1.8% | 237.21 ± 3.0% | 262.03 ± 3.0% | 73.75 ± 2.9% | 155.28 ± 3.1% | 306.46 ± 1.4% | 7141.49 ± 2.2% | 236.09 ± 1.8% | 0.99 | 0.99 | 3.18 | 1.51 |
| an IPv4 address | 29 | 687.18 ± 6.5% | 695.98 ± 3.9% | 936.13 ± 2.1% | 118.90 ± 3.7% | 198.92 ± 15.4% | 551.51 ± 3.2% | 12258.48 ± 3.3% | 687.95 ± 5.4% | 0.99 | 1.00 | 5.78 | 3.45 |
| a date and time | 56 | 497.17 ± 6.3% | 507.75 ± 7.5% | 618.50 ± 6.8% | 114.03 ± 13.9% | 219.21 ± 4.7% | 580.80 ± 6.7% | 7725.94 ± 3.6% | 514.72 ± 6.7% | 0.98 | 0.97 | 4.36 | 2.27 |
| a field path | 39 | 378.10 ± 4.0% | 380.18 ± 4.9% | 441.32 ± 4.8% | 131.97 ± 3.1% | 315.92 ± 5.7% | 922.70 ± 4.1% | 7667.59 ± 6.2% | 379.60 ± 5.4% | 0.99 | 1.00 | 2.87 | 1.20 |
| literal: a word | 7 | 1100.23 ± 4.2% | 1178.59 ± 5.1% | 2001.08 ± 6.8% | 847.33 ± 6.0% | 1003.01 ± 17.4% | 1773.82 ± 4.1% | 39074.79 ± 3.9% | 1098.11 ± 5.7% | 0.93 | 1.00 | 1.30 | 1.10 |
| literal: a word that is not there | 8 | 1040.63 ± 0.5% | 1124.99 ± 1.6% | 1846.15 ± 5.0% | 798.49 ± 4.0% | 968.80 ± 5.6% | 1733.47 ± 5.2% | 38448.11 ± 2.2% | 1031.89 ± 2.8% | 0.93 | 1.01 | 1.30 | 1.07 |
| literal: one of four words | 26 | 398.79 ± 1.2% | 624.65 ± 2.2% | 799.47 ± 6.9% | 65.90 ± 2.3% | 370.16 ± 2.4% | 659.19 ± 8.4% | 26829.93 ± 10.2% | 397.46 ± 4.0% | 0.64 | 1.00 | 6.05 | 1.08 |
| literal: a word in any case | 11 | 739.96 ± 3.6% | 791.62 ± 1.7% | 1098.57 ± 3.4% | 22.78 ± 2.3% | 1038.18 ± 6.2% | refused | 34706.25 ± 1.4% | 746.68 ± 2.7% | 0.93 | 0.99 | 32.48 | 0.71 |
| literal: an href attribute | 12 | 564.86 ± 3.6% | 584.57 ± 2.5% | 759.10 ± 1.6% | 60.06 ± 2.7% | 722.88 ± 5.4% | 1442.66 ± 2.5% | 29118.36 ± 10.3% | 558.62 ± 2.6% | 0.97 | 1.01 | 9.40 | 0.78 |
| literal: a word, second text | 10 | 940.08 ± 3.2% | 1016.45 ± 4.3% | 1593.58 ± 6.9% | 694.46 ± 1.6% | 839.26 ± 11.0% | 1509.59 ± 2.7% | 37444.73 ± 2.9% | 943.76 ± 1.9% | 0.92 | 1.00 | 1.35 | 1.12 |
| class: two capitalized words | 23 | 770.66 ± 32.2% | 825.85 ± 3.6% | 1167.81 ± 5.1% | 158.23 ± 11.0% | 762.67 ± 1.2% | 1417.88 ± 3.2% | 9483.56 ± 9.8% | 767.71 ± 32.7% | 0.93 | 1.00 | 4.87 | 1.01 |
| class: a word that ends in ing | 9 | 934.49 ± 9.7% | 1080.62 ± 3.7% | 1791.01 ± 3.8% | 202.93 ± 2.9% | 1049.03 ± 2.4% | 2165.90 ± 7.0% | 23860.70 ± 4.5% | 941.40 ± 5.3% | 0.86 | 0.99 | 4.60 | 0.89 |
| class: a word in capitals | 16 | 869.95 ± 2.6% | 943.65 ± 1.2% | 1453.02 ± 2.7% | 205.67 ± 1.6% | 1118.34 ± 1.4% | 2031.66 ± 1.9% | 12457.07 ± 2.7% | 870.65 ± 3.2% | 0.92 | 1.00 | 4.23 | 0.78 |
| class: a number | 6 | 1069.86 ± 1.7% | 1169.87 ± 2.5% | 2092.12 ± 2.4% | 58.35 ± 3.7% | 1996.00 ± 10.3% | 3698.39 ± 3.4% | 30544.82 ± 1.6% | 1063.04 ± 0.5% | 0.91 | 1.01 | 18.33 | 0.54 |
| class: two capitalized words, second text | 23 | 779.22 ± 7.5% | 843.18 ± 1.0% | 1194.79 ± 11.5% | 158.54 ± 4.2% | 767.25 ± 10.7% | 1454.32 ± 5.6% | 9647.99 ± 4.4% | 768.08 ± 4.8% | 0.92 | 1.01 | 4.91 | 1.02 |
| other: a word between two words | 13 | 913.78 ± 10.4% | 963.60 ± 2.5% | 1467.85 ± 1.4% | 208.15 ± 6.3% | 741.82 ± 21.5% | 1518.73 ± 0.9% | 22696.98 ± 2.0% | 926.60 ± 4.6% | 0.95 | 0.99 | 4.39 | 1.23 |
| other: a number before a unit, second text | 15 | 671.13 ± 1.5% | 746.87 ± 1.8% | 1027.41 ± 2.2% | 54.25 ± 5.1% | 910.94 ± 4.0% | 1716.13 ± 1.8% | 22099.55 ± 2.4% | 662.78 ± 3.1% | 0.90 | 1.01 | 12.37 | 0.74 |
| other: a heading's start tag | 13 | 590.29 ± 4.1% | 602.82 ± 3.3% | 779.77 ± 2.7% | 58.16 ± 1.8% | 896.78 ± 1.8% | 1594.57 ± 2.2% | 24587.98 ± 3.2% | 584.54 ± 2.6% | 0.98 | 1.01 | 10.15 | 0.66 |
| other: a whole word | 11 | 935.08 ± 6.3% | 993.85 ± 2.4% | 1538.57 ± 27.6% | 179.42 ± 46.8% | 838.96 ± 9.6% | 1552.10 ± 3.3% | 37203.42 ± 3.1% | 936.62 ± 2.3% | 0.94 | 1.00 | 5.21 | 1.11 |
| other: a line's first word, second text | 17 | 899.28 ± 4.2% | 954.94 ± 3.2% | 1503.14 ± 3.9% | 193.68 ± 2.8% | 997.53 ± 3.1% | refused | refused | 897.68 ± 3.7% | 0.94 | 1.00 | 4.64 | 0.90 |
| other: fourteen octets before an x | 16 | 177.41 ± 2.0% | 253.33 ± 1.3% | 289.75 ± 0.9% | 22.19 ± 2.5% | 651.14 ± 4.5% | 743.54 ± 4.5% | 19399.39 ± 4.3% | 178.44 ± 3.4% | 0.70 | 0.99 | 8.00 | 0.27 |
| other: a Greek word | 8 | 728.50 ± 3.2% | 971.93 ± 1.0% | 1555.87 ± 2.9% | 74.29 ± 1.8% | 1949.80 ± 2.0% | 3384.62 ± 1.2% | refused | 734.41 ± 1.8% | 0.75 | 0.99 | 9.81 | 0.37 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 34495.20 ± 4.2% | not timed | not timed | 43388.11 ± 3.6% | 3826.89 ± 23.9% | not timed | not timed | 34125.08 ± 3.7% | | 1.01 | 0.80 | 9.01 |
| 01-literal/sherlock-casei-en | 522 | 14209.45 ± 12.4% | not timed | not timed | 11316.46 ± 4.5% | 50.25 ± 20.9% | not timed | not timed | 14219.63 ± 56.6% | | 1.00 | 1.26 | 282.76 |
| 01-literal/sherlock-ru | 724 | 36156.83 ± 3.2% | not timed | not timed | 43248.47 ± 3.5% | 2388.92 ± 9.6% | not timed | not timed | 36451.58 ± 3.8% | | 0.99 | 0.84 | 15.14 |
| 01-literal/sherlock-casei-ru | 746 | 14996.19 ± 5.6% | not timed | not timed | 9281.79 ± 7.0% | 55.49 ± 3.8% | not timed | not timed | 14759.78 ± 3.2% | | 1.02 | 1.62 | 270.26 |
| 01-literal/sherlock-zh | 30 | 71213.61 ± 4.5% | not timed | not timed | 57931.52 ± 4.5% | 2109.93 ± 6.8% | not timed | not timed | 72856.14 ± 3.6% | | 0.98 | 1.23 | 33.75 |
| 02-literal-alternate/sherlock-en | 714 | 16464.09 ± 5.1% | not timed | not timed | 13878.96 ± 7.0% | 29.50 ± 16.0% | not timed | not timed | 16280.77 ± 4.4% | | 1.01 | 1.19 | 558.04 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3100.34 ± 14.1% | not timed | not timed | 3057.78 ± 4.2% | 18.71 ± 5.2% | not timed | not timed | 2936.89 ± 3.3% | | 1.06 | 1.01 | 165.73 |
| 02-literal-alternate/sherlock-ru | 899 | 12289.68 ± 5.7% | not timed | not timed | 7316.07 ± 5.9% | 37.20 ± 29.3% | not timed | not timed | 12232.63 ± 6.9% | | 1.00 | 1.68 | 330.36 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2809.25 ± 4.4% | not timed | not timed | 1484.87 ± 4.9% | 16.27 ± 4.2% | not timed | not timed | 2757.07 ± 5.5% | | 1.02 | 1.89 | 172.63 |
| 02-literal-alternate/sherlock-zh | 207 | 23990.91 ± 5.7% | not timed | not timed | 16054.02 ± 5.1% | 54.97 ± 3.7% | not timed | not timed | 23991.50 ± 4.7% | | 1.00 | 1.49 | 436.43 |
| 03-date/ascii | 111817 | 154.90 ± 22.5% | not timed | not timed | 121.94 ± 19.3% | 0.32 ± 2.2% | not timed | not timed | 158.48 ± 1.3% | | 0.98 | 1.27 | 486.14 |
| 04-ruff-noqa/real | 84 | 627.55 ± 1.8% | not timed | not timed | 714.15 ± 2.4% | 31.45 ± 2.2% | not timed | not timed | 681.83 ± 6.6% | | 0.92 | 0.88 | 19.95 |
| 04-ruff-noqa/tweaked | 44 | 820.80 ± 4.1% | not timed | not timed | 722.29 ± 3.6% | 496.75 ± 2.6% | not timed | not timed | 818.90 ± 0.8% | | 1.00 | 1.14 | 1.65 |
| 05-lexer-veryl/single | 124800 | 7.56 ± 5.3% | not timed | not timed | 7.89 ± 5.7% | 0.36 ± 8.2% | not timed | not timed | 7.46 ± 3.4% | | 1.01 | 0.96 | 21.06 |
| 06-cloud-flare-redos/original | 107 | 552.74 ± 4.2% | not timed | not timed | 292.46 ± 3.9% | 38.69 ± 5.9% | not timed | not timed | 545.19 ± 4.2% | | 1.01 | 1.89 | 14.29 |
| 06-cloud-flare-redos/simplified-short | 102 | 547.51 ± 25.5% | not timed | not timed | 307.43 ± 4.3% | 43.40 ± 2.7% | not timed | not timed | 554.64 ± 33.4% | | 0.99 | 1.78 | 12.61 |
| 06-cloud-flare-redos/simplified-long | 10000 | 674.22 ± 3.2% | not timed | not timed | 333.66 ± 0.5% | 47.22 ± 2.5% | not timed | not timed | 673.82 ± 3.7% | | 1.00 | 2.02 | 14.28 |
| 07-unicode-character-data/parse-line | 558784 | 329.04 ± 4.0% | not timed | not timed | 264.99 ± 0.8% | 64.95 ± 13.2% | not timed | not timed | 325.89 ± 5.9% | | 1.01 | 1.24 | 5.07 |
| 08-words/all-english | 56691 | 137.95 ± 4.3% | not timed | not timed | 111.57 ± 2.1% | 20.27 ± 17.6% | not timed | not timed | 135.99 ± 1.9% | | 1.01 | 1.24 | 6.80 |
| 08-words/long-english | 839 | 716.28 ± 2.0% | not timed | not timed | 689.37 ± 1.6% | 49.19 ± 2.5% | not timed | not timed | 715.82 ± 2.1% | | 1.00 | 1.04 | 14.56 |
| 09-aws-keys/full | 0 | 662.28 ± 3.0% | not timed | not timed | 720.73 ± 5.6% | 98.03 ± 11.1% | not timed | not timed | 695.61 ± 7.6% | | 0.95 | 0.92 | 6.76 |
| 09-aws-keys/quick | 0 | 1300.76 ± 9.7% | not timed | not timed | 1234.76 ± 5.7% | 541.95 ± 4.9% | not timed | not timed | 1280.06 ± 3.9% | | 1.02 | 1.05 | 2.40 |
| 10-bounded-repeat/letters-en | 1833 | 821.88 ± 0.2% | not timed | not timed | 724.62 ± 1.2% | 28.99 ± 15.5% | not timed | not timed | 823.45 ± 0.4% | | 1.00 | 1.13 | 28.35 |
| 10-bounded-repeat/letters-ru | 3475 | 706.66 ± 2.6% | not timed | not timed | 631.45 ± 1.4% | 30.51 ± 12.0% | not timed | not timed | 700.78 ± 5.3% | | 1.01 | 1.12 | 23.16 |
| 10-bounded-repeat/context | 53 | 108.00 ± 3.2% | not timed | not timed | 90.55 ± 10.4% | 29.73 ± 3.7% | not timed | not timed | 107.76 ± 1.9% | | 1.00 | 1.19 | 3.63 |
| 10-bounded-repeat/capitals | 11 | 786.63 ± 7.9% | not timed | not timed | 737.63 ± 4.3% | 54.13 ± 4.7% | not timed | not timed | 769.77 ± 12.7% | | 1.02 | 1.07 | 14.53 |
| 11-unstructured-to-json/extract | 600 | 107.63 ± 3.9% | not timed | not timed | 106.82 ± 6.4% | 75.82 ± 13.2% | not timed | not timed | 108.57 ± 5.6% | | 0.99 | 1.01 | 1.42 |
| 12-dictionary/single | 1 | 643.76 ± 0.7% | not timed | not timed | 616.02 ± 1.8% | 0.65 ± 1.8% | not timed | not timed | 644.83 ± 2.4% | | 1.00 | 1.05 | 990.73 |
| 14-quadratic/1x | 100 | 38.79 ± 17.9% | not timed | not timed | 16.91 ± 25.5% | 1.44 ± 16.1% | not timed | not timed | 38.67 ± 6.0% | | 1.00 | 2.29 | 26.92 |
| 14-quadratic/2x | 200 | 31.33 ± 5.2% | not timed | not timed | 8.05 ± 4.0% | 0.78 ± 17.5% | not timed | not timed | 30.48 ± 1.9% | | 1.03 | 3.89 | 39.97 |
| 14-quadratic/10x | 1000 | 10.94 ± 3.6% | not timed | not timed | 1.48 ± 4.0% | 0.18 ± 6.1% | not timed | not timed | 10.71 ± 6.1% | | 1.02 | 7.37 | 62.23 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.12 ± 3.7% | not timed | not timed | 0.56 ± 4.5% | 0.86 ± 7.5% | not timed | not timed | 2.05 ± 4.3% | | 1.03 | 3.78 | 2.47 |
| 04-ruff-noqa/compile-real | 1 | 158.30 ± 7.2% | not timed | not timed | 21.37 ± 4.7% | 231.91 ± 4.0% | not timed | not timed | 163.44 ± 4.9% | | 0.97 | 7.41 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 23.20 ± 50.7% | not timed | not timed | 4.03 ± 74.4% | 10.83 ± 140.6% | not timed | not timed | 22.55 ± 55.4% | | 1.03 | 5.76 | 2.14 |
| 07-unicode-character-data/compile | 1 | 89.79 ± 2.3% | not timed | not timed | 40.00 ± 12.2% | 59.85 ± 6.3% | not timed | not timed | 88.93 ± 5.5% | | 1.01 | 2.24 | 1.50 |
| 09-aws-keys/compile-full | 1 | 61.60 ± 4.3% | not timed | not timed | 12.47 ± 10.1% | 36.83 ± 4.8% | not timed | not timed | 61.57 ± 3.9% | | 1.00 | 4.94 | 1.67 |
| 09-aws-keys/compile-quick | 1 | 291.44 ± 6.3% | not timed | not timed | 78.92 ± 8.1% | 218.27 ± 12.4% | not timed | not timed | 294.98 ± 3.6% | | 0.99 | 3.69 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 22.91 ± 13.2% | not timed | not timed | 17.81 ± 5.7% | 25.97 ± 13.4% | not timed | not timed | 22.91 ± 23.4% | | 1.00 | 1.29 | 0.88 |
| 10-bounded-repeat/compile-capitals | 1 | 128.23 ± 5.8% | not timed | not timed | 12.62 ± 5.1% | 37.74 ± 4.5% | not timed | not timed | 129.52 ± 4.9% | | 0.99 | 10.16 | 3.40 |
| 11-unstructured-to-json/compile | 1 | 137.67 ± 4.9% | not timed | not timed | 63.15 ± 5.8% | 111.62 ± 5.6% | not timed | not timed | 136.61 ± 6.6% | | 1.01 | 2.18 | 1.23 |
| 12-dictionary/compile-single | 1 | 0.46 ± 4.9% | not timed | not timed | 0.10 ± 95.2% | 0.14 ± 44.8% | not timed | not timed | 0.45 ± 4.8% | | 1.01 | 4.74 | 3.35 |

