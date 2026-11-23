# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148061474 |
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
| literal: a word | 217 | 51023.93 ± 10.4% | 1142.66 ± 6.7% | 42.82 ± 4.2% | 48736.30 ± 4.9% | 15060.41 ± 67.7% | 14.91 ± 25.0% | 139.57 ± 6.1% | 50171.14 ± 59.5% | 44.65 | 1.02 | 1.05 | 3.39 |
| literal: a word that is not there | 0 | 73233.08 ± 4.8% | 1126.98 ± 4.7% | 42.06 ± 4.9% | 60344.05 ± 3.6% | 52099.96 ± 4.3% | 14.63 ± 3.7% | 132.96 ± 4.8% | 74587.80 ± 6.1% | 64.98 | 0.98 | 1.21 | 1.41 |
| literal: one of four words | 661 | 18438.76 ± 2.5% | 1128.04 ± 4.1% | 23.08 ± 20.9% | 13287.87 ± 3.6% | 36.05 ± 6.3% | 4.70 ± 4.3% | 11.63 ± 3.4% | 18171.46 ± 7.4% | 16.35 | 1.01 | 1.39 | 511.54 |
| literal: a word in any case | 217 | 45806.82 ± 1.0% | 1144.29 ± 3.5% | 30.11 ± 15.2% | 13067.32 ± 6.5% | 66.93 ± 6.4% | refused | differs | 44606.48 ± 6.7% | 40.03 | 1.03 | 3.51 | 684.39 |
| literal: an href attribute | 33 | 42872.71 ± 16.1% | 1145.93 ± 7.8% | 35.47 ± 7.4% | 42648.84 ± 5.1% | 3209.50 ± 8.5% | 10.55 ± 18.6% | 117.46 ± 48.2% | 42899.28 ± 17.5% | 37.41 | 1.00 | 1.01 | 13.36 |
| literal: a word, second text | 123 | 51450.03 ± 5.8% | 1155.16 ± 3.2% | 40.42 ± 3.7% | 46184.45 ± 7.5% | 14031.00 ± 7.2% | 19.83 ± 3.8% | 117.34 ± 4.5% | 51639.66 ± 6.2% | 44.54 | 1.00 | 1.11 | 3.67 |
| class: two capitalized words | 1331 | 1048.17 ± 6.1% | 1065.19 ± 6.4% | 37.78 ± 7.6% | 638.46 ± 23.2% | 54.24 ± 22.1% | 12.56 ± 5.0% | 95.64 ± 7.7% | 1038.03 ± 5.1% | 0.98 | 1.01 | 1.64 | 19.32 |
| class: a word that ends in ing | 3399 | 943.28 ± 5.5% | 977.53 ± 4.1% | 25.98 ± 7.4% | 600.37 ± 3.8% | 42.56 ± 17.0% | 7.29 ± 5.3% | 26.76 ± 5.7% | 964.01 ± 5.3% | 0.96 | 0.98 | 1.57 | 22.16 |
| class: a word in capitals | 2332 | 1515.70 ± 5.3% | 1049.28 ± 3.9% | 40.57 ± 10.3% | 640.70 ± 4.7% | 60.33 ± 11.2% | 15.80 ± 2.1% | 126.19 ± 6.3% | 1506.23 ± 6.9% | 1.44 | 1.01 | 2.37 | 25.12 |
| class: a number | 8288 | 2320.45 ± 5.7% | 893.48 ± 5.0% | 39.31 ± 3.6% | 2179.00 ± 3.2% | 59.37 ± 20.9% | 0.42 ± 3.3% | 86.13 ± 6.4% | 2283.41 ± 7.2% | 2.60 | 1.02 | 1.06 | 39.08 |
| class: two capitalized words, second text | 5359 | 777.72 ± 7.6% | 780.05 ± 10.5% | 34.21 ± 7.3% | 534.46 ± 5.0% | 47.74 ± 11.2% | 16.66 ± 5.9% | 87.63 ± 3.6% | 806.30 ± 6.6% | 1.00 | 0.96 | 1.46 | 16.29 |
| other: a word between two words | 6104 | 1000.73 ± 6.3% | 844.47 ± 3.3% | 33.38 ± 2.7% | 907.47 ± 5.7% | 165.11 ± 19.0% | 9.81 ± 3.2% | 101.14 ± 6.2% | 1004.84 ± 10.5% | 1.19 | 1.00 | 1.10 | 6.06 |
| other: a number before a unit, second text | 1481 | 12146.35 ± 3.3% | 1104.15 ± 5.8% | 38.56 ± 7.8% | 10261.55 ± 6.1% | 57.54 ± 10.4% | 17.84 ± 6.2% | 97.57 ± 58.5% | 12093.61 ± 7.1% | 11.00 | 1.00 | 1.18 | 211.11 |
| other: a heading's start tag | 110 | 27988.04 ± 5.7% | 1130.40 ± 6.5% | 37.23 ± 4.0% | 3110.70 ± 4.8% | 2404.88 ± 7.9% | 13.47 ± 7.0% | 135.95 ± 8.4% | 27372.75 ± 6.7% | 24.76 | 1.02 | 9.00 | 11.64 |
| other: a whole word | 217 | 34764.14 ± 6.2% | 1131.89 ± 4.7% | 41.32 ± 8.9% | 33810.05 ± 5.5% | 70.08 ± 3.0% | 13.07 ± 7.0% | 78.85 ± 5.5% | 35450.69 ± 4.3% | 30.71 | 0.98 | 1.03 | 496.03 |
| other: a line's first word, second text | 3716 | 3223.67 ± 5.7% | 938.08 ± 6.2% | 43.96 ± 6.0% | 3329.51 ± 3.4% | 92.32 ± 13.6% | refused | refused | 3176.11 ± 4.1% | 3.44 | 1.01 | 0.97 | 34.92 |
| other: fourteen octets before an x | 87 | 43649.11 ± 3.8% | 311.83 ± 5.0% | 9.22 ± 6.1% | 4525.92 ± 7.3% | 13.51 ± 7.1% | differs | 23.78 ± 5.4% | 43467.67 ± 6.1% | 139.98 | 1.00 | 9.64 | 3230.85 |
| other: a Greek word | 21815 | 550.27 ± 3.3% | 428.09 ± 3.1% | 43.60 ± 6.7% | 334.29 ± 11.4% | 61.86 ± 25.8% | differs | refused | 560.83 ± 3.6% | 1.29 | 0.98 | 1.65 | 8.90 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.76 ± 7.7% | 32.84 ± 19.3% | 1.44 ± 8.6% | 21.81 ± 7.9% | 3.37 ± 3.3% | differs | 5.24 ± 9.9% | 31.45 ± 6.0% | 0.97 | 1.01 | 1.46 | 9.43 |
| a UUID | 32895 | 27.97 ± 34.5% | 28.21 ± 5.8% | 0.98 ± 7.1% | 16.91 ± 6.6% | 3.31 ± 6.6% | 0.69 ± 3.5% | 4.38 ± 8.2% | 27.27 ± 4.9% | 0.99 | 1.03 | 1.65 | 8.45 |
| an IPv4 address | 33176 | 44.62 ± 2.4% | 45.13 ± 3.0% | 2.99 ± 37.4% | 30.68 ± 7.3% | 8.58 ± 6.7% | differs | 5.66 ± 2.4% | 45.51 ± 5.7% | 0.99 | 0.98 | 1.45 | 5.20 |
| a date and time | 32954 | 41.48 ± 4.8% | 41.93 ± 2.6% | 2.34 ± 3.7% | 24.64 ± 4.8% | 9.95 ± 7.0% | 1.23 ± 4.5% | 9.92 ± 8.8% | 40.04 ± 5.2% | 0.99 | 1.04 | 1.68 | 4.17 |
| a field path | 32606 | 35.86 ± 4.5% | 35.91 ± 6.1% | 1.63 ± 4.9% | 25.14 ± 4.8% | 4.38 ± 6.0% | differs | 3.92 ± 10.7% | 35.33 ± 6.4% | 1.00 | 1.02 | 1.43 | 8.18 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.25 ± 6.0% | 12.09 ± 5.5% | 11.86 ± 5.0% | 15.45 ± 20.9% | 6.86 ± 19.5% | 0.99 ± 6.3% | none | 12.00 ± 7.7% | 1.01 | 1.02 | 0.79 | 1.78 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 342.64 ± 12.4% | 354.91 ± 6.1% | 404.27 ± 5.6% | 124.60 ± 6.5% | 305.58 ± 7.4% | 830.53 ± 35.3% | 5373.77 ± 4.1% | 356.28 ± 9.8% | 0.97 | 0.96 | 2.75 | 1.12 |
| a UUID | 62 | 225.23 ± 4.4% | 226.63 ± 5.8% | 232.79 ± 9.9% | 70.20 ± 11.4% | 151.52 ± 3.6% | 294.94 ± 3.8% | 6346.31 ± 8.6% | 223.01 ± 6.7% | 0.99 | 1.01 | 3.21 | 1.49 |
| an IPv4 address | 29 | 699.88 ± 7.8% | 686.91 ± 9.6% | 956.61 ± 6.4% | 111.84 ± 4.5% | 192.03 ± 7.1% | 500.67 ± 25.2% | 11855.49 ± 21.7% | 654.87 ± 26.7% | 1.02 | 1.07 | 6.26 | 3.64 |
| a date and time | 56 | 480.27 ± 5.2% | 491.09 ± 40.5% | 603.96 ± 3.2% | 103.02 ± 7.3% | 199.78 ± 7.7% | 520.51 ± 7.0% | 7246.04 ± 16.7% | 473.62 ± 4.2% | 0.98 | 1.01 | 4.66 | 2.40 |
| a field path | 39 | 327.03 ± 6.4% | 327.40 ± 5.6% | 381.19 ± 8.6% | 117.78 ± 4.7% | 289.01 ± 8.0% | 812.41 ± 7.1% | 6697.65 ± 16.1% | 322.74 ± 6.7% | 1.00 | 1.01 | 2.78 | 1.13 |
| literal: a word | 7 | 992.43 ± 9.3% | 1048.75 ± 8.8% | 1847.65 ± 7.7% | 756.45 ± 6.7% | 902.60 ± 3.4% | 1584.38 ± 6.4% | 41644.05 ± 6.6% | 988.32 ± 9.2% | 0.95 | 1.00 | 1.31 | 1.10 |
| literal: a word that is not there | 8 | 935.86 ± 9.3% | 1016.60 ± 7.7% | 1728.34 ± 10.9% | 686.15 ± 14.9% | 857.89 ± 18.7% | 1518.23 ± 7.5% | 40499.82 ± 9.3% | 935.47 ± 10.5% | 0.92 | 1.00 | 1.36 | 1.09 |
| literal: one of four words | 26 | 375.36 ± 5.9% | 607.11 ± 6.8% | 777.07 ± 6.3% | 61.40 ± 8.4% | 352.15 ± 5.6% | 616.36 ± 3.5% | 22520.07 ± 3.1% | 389.57 ± 3.1% | 0.62 | 0.96 | 6.11 | 1.07 |
| literal: a word in any case | 11 | 774.61 ± 4.1% | 822.22 ± 8.7% | 1246.94 ± 6.4% | 20.83 ± 7.3% | 1011.18 ± 4.9% | refused | 34850.48 ± 4.4% | 788.29 ± 10.1% | 0.94 | 0.98 | 37.19 | 0.77 |
| literal: an href attribute | 12 | 532.48 ± 9.7% | 543.34 ± 29.1% | 722.28 ± 8.6% | 55.93 ± 4.0% | 684.54 ± 18.8% | 1336.81 ± 5.7% | 31112.63 ± 12.3% | 517.37 ± 8.3% | 0.98 | 1.03 | 9.52 | 0.78 |
| literal: a word, second text | 10 | 899.69 ± 8.6% | 952.56 ± 6.2% | 1543.61 ± 5.7% | 653.92 ± 5.4% | 791.34 ± 6.7% | 1415.02 ± 5.2% | 41742.56 ± 8.6% | 895.64 ± 6.4% | 0.94 | 1.00 | 1.38 | 1.14 |
| class: two capitalized words | 23 | 719.46 ± 9.1% | 753.93 ± 11.1% | 1130.49 ± 5.9% | 149.06 ± 3.6% | 742.39 ± 4.8% | 1348.36 ± 4.7% | 8966.24 ± 6.6% | 738.60 ± 6.5% | 0.95 | 0.97 | 4.83 | 0.97 |
| class: a word that ends in ing | 9 | 897.78 ± 8.1% | 997.64 ± 8.1% | 1695.75 ± 14.5% | 182.30 ± 8.8% | 1015.44 ± 7.2% | 2045.17 ± 42.0% | 21662.19 ± 5.6% | 876.23 ± 5.3% | 0.90 | 1.02 | 4.92 | 0.88 |
| class: a word in capitals | 16 | 789.21 ± 11.4% | 867.21 ± 5.2% | 1360.75 ± 4.5% | 191.09 ± 10.0% | 1070.24 ± 11.1% | 1919.08 ± 6.8% | 11461.72 ± 12.8% | 775.94 ± 59.6% | 0.91 | 1.02 | 4.13 | 0.74 |
| class: a number | 6 | 1006.87 ± 9.1% | 1104.36 ± 10.0% | 2007.52 ± 10.3% | 55.29 ± 10.6% | 1973.33 ± 17.8% | 3313.28 ± 7.3% | 33030.88 ± 5.2% | 1007.35 ± 7.2% | 0.91 | 1.00 | 18.21 | 0.51 |
| class: two capitalized words, second text | 23 | 743.09 ± 5.9% | 803.47 ± 7.1% | 1150.24 ± 6.5% | 147.91 ± 4.2% | 758.44 ± 20.0% | 1329.71 ± 6.1% | 8913.85 ± 7.2% | 731.60 ± 5.5% | 0.92 | 1.02 | 5.02 | 0.98 |
| other: a word between two words | 13 | 855.64 ± 4.3% | 878.60 ± 8.2% | 1412.57 ± 10.2% | 194.08 ± 6.5% | 697.94 ± 6.3% | 1413.24 ± 4.2% | 21034.98 ± 1.4% | 878.75 ± 4.3% | 0.97 | 0.97 | 4.41 | 1.23 |
| other: a number before a unit, second text | 15 | 623.11 ± 7.5% | 691.33 ± 14.7% | 944.29 ± 57.0% | 51.28 ± 7.3% | 875.04 ± 7.0% | 1562.87 ± 7.5% | 22756.23 ± 10.5% | 642.31 ± 9.4% | 0.90 | 0.97 | 12.15 | 0.71 |
| other: a heading's start tag | 13 | 562.50 ± 46.2% | 572.69 ± 5.5% | 759.87 ± 4.8% | 53.97 ± 4.2% | 855.15 ± 19.7% | 1497.39 ± 5.2% | 26623.46 ± 7.0% | 574.92 ± 7.5% | 0.98 | 0.98 | 10.42 | 0.66 |
| other: a whole word | 11 | 911.68 ± 6.5% | 937.18 ± 6.2% | 1471.82 ± 8.7% | 170.35 ± 13.7% | 823.50 ± 5.6% | 1467.34 ± 4.2% | 38852.16 ± 2.2% | 896.07 ± 7.8% | 0.97 | 1.02 | 5.35 | 1.11 |
| other: a line's first word, second text | 17 | 843.60 ± 7.9% | 910.33 ± 23.9% | 1404.00 ± 12.2% | 181.47 ± 7.0% | 966.77 ± 7.2% | refused | refused | 856.94 ± 7.0% | 0.93 | 0.98 | 4.65 | 0.87 |
| other: fourteen octets before an x | 16 | 166.15 ± 8.2% | 229.90 ± 7.6% | 264.05 ± 9.0% | 19.96 ± 11.6% | 596.54 ± 11.1% | 689.41 ± 4.5% | 17874.11 ± 4.3% | 162.97 ± 7.0% | 0.72 | 1.02 | 8.32 | 0.28 |
| other: a Greek word | 8 | 632.01 ± 10.3% | 860.98 ± 13.2% | 1356.46 ± 9.6% | 67.68 ± 5.3% | 1952.20 ± 15.9% | 3112.16 ± 4.8% | refused | 635.66 ± 10.0% | 0.73 | 0.99 | 9.34 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 31658.89 ± 4.9% | not timed | not timed | 39753.95 ± 5.8% | 3542.66 ± 28.0% | not timed | not timed | 32688.00 ± 10.1% | | 0.97 | 0.80 | 8.94 |
| 01-literal/sherlock-casei-en | 522 | 10037.71 ± 45.8% | not timed | not timed | 10508.61 ± 5.5% | 48.06 ± 7.1% | not timed | not timed | 9807.55 ± 26.8% | | 1.02 | 0.96 | 208.86 |
| 01-literal/sherlock-ru | 724 | 32927.14 ± 8.3% | not timed | not timed | 39509.88 ± 8.3% | 2022.02 ± 11.5% | not timed | not timed | 31991.98 ± 7.6% | | 1.03 | 0.83 | 16.28 |
| 01-literal/sherlock-casei-ru | 746 | 10258.37 ± 7.7% | not timed | not timed | 8573.95 ± 10.5% | 52.95 ± 5.2% | not timed | not timed | 10170.20 ± 6.6% | | 1.01 | 1.20 | 193.74 |
| 01-literal/sherlock-zh | 30 | 70055.90 ± 9.4% | not timed | not timed | 55344.14 ± 5.8% | 1911.26 ± 6.1% | not timed | not timed | 69647.81 ± 6.0% | | 1.01 | 1.27 | 36.65 |
| 02-literal-alternate/sherlock-en | 714 | 14722.53 ± 5.9% | not timed | not timed | 12293.00 ± 4.6% | 27.12 ± 6.5% | not timed | not timed | 15007.63 ± 8.4% | | 0.98 | 1.20 | 542.95 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2452.70 ± 9.4% | not timed | not timed | 2584.27 ± 8.5% | 16.38 ± 6.3% | not timed | not timed | 2429.28 ± 5.3% | | 1.01 | 0.95 | 149.70 |
| 02-literal-alternate/sherlock-ru | 899 | 8454.70 ± 7.3% | not timed | not timed | 6880.77 ± 6.4% | 34.78 ± 6.6% | not timed | not timed | 8321.29 ± 3.4% | | 1.02 | 1.23 | 243.06 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2213.33 ± 7.4% | not timed | not timed | 1272.00 ± 5.4% | 14.34 ± 6.6% | not timed | not timed | 2286.46 ± 6.1% | | 0.97 | 1.74 | 154.30 |
| 02-literal-alternate/sherlock-zh | 207 | 21493.73 ± 8.6% | not timed | not timed | 14539.58 ± 7.5% | 49.39 ± 6.8% | not timed | not timed | 21576.79 ± 5.9% | | 1.00 | 1.48 | 435.17 |
| 03-date/ascii | 111817 | 142.78 ± 4.1% | not timed | not timed | 117.46 ± 6.8% | 0.31 ± 9.5% | not timed | not timed | 142.37 ± 5.8% | | 1.00 | 1.22 | 463.83 |
| 04-ruff-noqa/real | 84 | 795.55 ± 6.2% | not timed | not timed | 633.55 ± 6.8% | 28.64 ± 1.3% | not timed | not timed | 810.46 ± 3.9% | | 0.98 | 1.26 | 27.78 |
| 04-ruff-noqa/tweaked | 44 | 731.11 ± 5.2% | not timed | not timed | 638.70 ± 5.1% | 453.05 ± 44.1% | not timed | not timed | 716.09 ± 9.1% | | 1.02 | 1.14 | 1.61 |
| 05-lexer-veryl/single | 124800 | 5.88 ± 2.3% | not timed | not timed | 7.35 ± 5.1% | 0.33 ± 9.9% | not timed | not timed | 5.94 ± 4.3% | | 0.99 | 0.80 | 17.97 |
| 06-cloud-flare-redos/original | 107 | 302.25 ± 12.2% | not timed | not timed | 274.91 ± 7.4% | 36.75 ± 3.6% | not timed | not timed | 306.68 ± 3.3% | | 0.99 | 1.10 | 8.22 |
| 06-cloud-flare-redos/simplified-short | 102 | 302.63 ± 2.7% | not timed | not timed | 280.67 ± 2.4% | 38.97 ± 26.6% | not timed | not timed | 297.21 ± 4.5% | | 1.02 | 1.08 | 7.76 |
| 06-cloud-flare-redos/simplified-long | 10000 | 306.86 ± 2.9% | not timed | not timed | 297.57 ± 3.5% | 41.74 ± 3.8% | not timed | not timed | 308.15 ± 3.2% | | 1.00 | 1.03 | 7.35 |
| 07-unicode-character-data/parse-line | 558784 | 296.07 ± 2.9% | not timed | not timed | 234.55 ± 8.0% | 61.78 ± 6.6% | not timed | not timed | 298.51 ± 4.9% | | 0.99 | 1.26 | 4.79 |
| 08-words/all-english | 56691 | 124.82 ± 1.2% | not timed | not timed | 98.54 ± 2.8% | 19.99 ± 12.3% | not timed | not timed | 122.52 ± 5.1% | | 1.02 | 1.27 | 6.24 |
| 08-words/long-english | 839 | 1100.10 ± 2.8% | not timed | not timed | 655.10 ± 4.2% | 44.96 ± 13.8% | not timed | not timed | 1085.76 ± 4.5% | | 1.01 | 1.68 | 24.47 |
| 09-aws-keys/full | 0 | 623.22 ± 4.9% | not timed | not timed | 636.86 ± 5.5% | 90.79 ± 7.2% | not timed | not timed | 618.44 ± 3.7% | | 1.01 | 0.98 | 6.86 |
| 09-aws-keys/quick | 0 | 1216.97 ± 5.3% | not timed | not timed | 1145.63 ± 2.8% | 518.70 ± 8.2% | not timed | not timed | 1229.32 ± 3.8% | | 0.99 | 1.06 | 2.35 |
| 10-bounded-repeat/letters-en | 1833 | 698.98 ± 43.5% | not timed | not timed | 696.24 ± 4.4% | 27.74 ± 3.7% | not timed | not timed | 714.25 ± 34.4% | | 0.98 | 1.00 | 25.20 |
| 10-bounded-repeat/letters-ru | 3475 | 407.77 ± 5.7% | not timed | not timed | 599.78 ± 4.8% | 31.36 ± 21.2% | not timed | not timed | 413.52 ± 3.0% | | 0.99 | 0.68 | 13.00 |
| 10-bounded-repeat/context | 53 | 102.89 ± 5.5% | not timed | not timed | 86.11 ± 5.5% | 27.91 ± 2.3% | not timed | not timed | 103.32 ± 4.2% | | 1.00 | 1.19 | 3.69 |
| 10-bounded-repeat/capitals | 11 | 1157.28 ± 3.5% | not timed | not timed | 678.21 ± 3.5% | 49.75 ± 1.8% | not timed | not timed | 1169.54 ± 5.5% | | 0.99 | 1.71 | 23.26 |
| 11-unstructured-to-json/extract | 600 | 58.00 ± 4.8% | not timed | not timed | 98.37 ± 4.6% | 69.91 ± 4.9% | not timed | not timed | 57.39 ± 3.5% | | 1.01 | 0.59 | 0.83 |
| 12-dictionary/single | 1 | 590.11 ± 6.3% | not timed | not timed | 557.78 ± 6.0% | 0.57 ± 6.1% | not timed | not timed | 585.93 ± 5.0% | | 1.01 | 1.06 | 1040.26 |
| 14-quadratic/1x | 100 | 10.46 ± 5.5% | not timed | not timed | 15.98 ± 6.2% | 1.35 ± 6.9% | not timed | not timed | 10.22 ± 8.5% | | 1.02 | 0.65 | 7.73 |
| 14-quadratic/2x | 200 | 5.85 ± 11.3% | not timed | not timed | 7.47 ± 5.5% | 0.72 ± 6.4% | not timed | not timed | 5.95 ± 5.6% | | 0.98 | 0.78 | 8.08 |
| 14-quadratic/10x | 1000 | 1.31 ± 5.3% | not timed | not timed | 1.34 ± 21.6% | 0.16 ± 7.5% | not timed | not timed | 1.32 ± 3.4% | | 0.99 | 0.98 | 8.01 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.27 ± 5.2% | not timed | not timed | 0.51 ± 4.8% | 0.80 ± 8.8% | not timed | not timed | 2.25 ± 8.5% | | 1.01 | 4.48 | 2.84 |
| 04-ruff-noqa/compile-real | 1 | 146.61 ± 6.2% | not timed | not timed | 19.85 ± 9.0% | 213.34 ± 9.1% | not timed | not timed | 151.14 ± 8.8% | | 0.97 | 7.38 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 22.27 ± 2.9% | not timed | not timed | 3.67 ± 4.2% | 10.06 ± 7.3% | not timed | not timed | 21.81 ± 3.3% | | 1.02 | 6.07 | 2.21 |
| 07-unicode-character-data/compile | 1 | 85.67 ± 3.6% | not timed | not timed | 37.75 ± 10.4% | 58.08 ± 6.0% | not timed | not timed | 87.14 ± 3.5% | | 0.98 | 2.27 | 1.48 |
| 09-aws-keys/compile-full | 1 | 58.85 ± 6.1% | not timed | not timed | 11.61 ± 5.3% | 34.71 ± 6.4% | not timed | not timed | 58.24 ± 6.5% | | 1.01 | 5.07 | 1.70 |
| 09-aws-keys/compile-quick | 1 | 279.18 ± 6.7% | not timed | not timed | 72.13 ± 4.7% | 204.30 ± 3.1% | not timed | not timed | 278.69 ± 4.2% | | 1.00 | 3.87 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 20.88 ± 4.3% | not timed | not timed | 16.11 ± 2.6% | 24.70 ± 4.8% | not timed | not timed | 20.72 ± 3.8% | | 1.01 | 1.30 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 120.21 ± 3.1% | not timed | not timed | 11.79 ± 9.0% | 35.44 ± 4.7% | not timed | not timed | 118.79 ± 4.0% | | 1.01 | 10.20 | 3.39 |
| 11-unstructured-to-json/compile | 1 | 128.63 ± 8.2% | not timed | not timed | 58.82 ± 7.3% | 101.19 ± 6.8% | not timed | not timed | 128.28 ± 7.0% | | 1.00 | 2.19 | 1.27 |
| 12-dictionary/compile-single | 1 | 0.43 ± 4.5% | not timed | not timed | 0.09 ± 4.3% | 0.13 ± 16.1% | not timed | not timed | 0.43 ± 6.8% | | 1.01 | 4.73 | 3.23 |

