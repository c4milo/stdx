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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148086974 |
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
| literal: a word | 217 | 54245.44 ± 35.2% | 1191.57 ± 0.8% | 44.52 ± 1.1% | 51352.95 ± 6.3% | 16006.74 ± 4.6% | 15.30 ± 5.2% | 149.30 ± 44.9% | 54490.00 ± 29.4% | 45.52 | 1.00 | 1.06 | 3.39 |
| literal: a word that is not there | 0 | 80847.20 ± 0.5% | 1208.29 ± 1.1% | 44.51 ± 2.3% | 64331.98 ± 4.3% | 54399.00 ± 3.1% | 14.90 ± 0.6% | 139.72 ± 1.2% | 80410.44 ± 11.6% | 66.91 | 1.01 | 1.26 | 1.49 |
| literal: one of four words | 661 | 18808.51 ± 2.9% | 1162.26 ± 2.2% | 24.49 ± 2.5% | 14151.52 ± 2.1% | 37.71 ± 1.8% | 4.90 ± 2.7% | 12.38 ± 3.5% | 18659.56 ± 3.2% | 16.18 | 1.01 | 1.33 | 498.73 |
| literal: a word in any case | 217 | 48264.41 ± 19.4% | 1187.14 ± 2.3% | 32.28 ± 3.7% | 13839.53 ± 2.8% | 70.25 ± 4.5% | refused | differs | 48268.40 ± 32.5% | 40.66 | 1.00 | 3.49 | 687.00 |
| literal: an href attribute | 33 | 45634.41 ± 4.1% | 1196.76 ± 11.6% | 36.33 ± 27.3% | 45072.40 ± 1.4% | 3477.97 ± 2.3% | 10.81 ± 3.6% | 125.36 ± 1.6% | 45825.17 ± 1.1% | 38.13 | 1.00 | 1.01 | 13.12 |
| literal: a word, second text | 123 | 51035.80 ± 4.2% | 1187.41 ± 5.9% | 42.67 ± 3.2% | 48164.10 ± 4.0% | 14859.31 ± 6.4% | 20.44 ± 2.0% | 119.41 ± 4.8% | 51670.45 ± 4.7% | 42.98 | 0.99 | 1.06 | 3.43 |
| class: two capitalized words | 1331 | 1088.73 ± 3.4% | 1100.22 ± 10.5% | 39.30 ± 28.2% | 669.35 ± 3.0% | 60.32 ± 1.9% | 13.29 ± 19.6% | 102.30 ± 11.9% | 1091.28 ± 4.1% | 0.99 | 1.00 | 1.63 | 18.05 |
| class: a word that ends in ing | 3399 | 1020.55 ± 1.9% | 1021.84 ± 5.2% | 26.95 ± 4.5% | 630.54 ± 2.6% | 44.68 ± 4.6% | 7.66 ± 2.1% | 28.59 ± 3.9% | 1019.90 ± 1.6% | 1.00 | 1.00 | 1.62 | 22.84 |
| class: a word in capitals | 2332 | 1587.52 ± 3.7% | 1081.64 ± 2.3% | 42.24 ± 2.4% | 664.29 ± 4.5% | 65.17 ± 32.3% | 16.23 ± 14.3% | 132.61 ± 3.9% | 1602.82 ± 5.6% | 1.47 | 0.99 | 2.39 | 24.36 |
| class: a number | 8288 | 2495.89 ± 5.4% | 955.19 ± 5.5% | 41.49 ± 5.0% | 2252.63 ± 2.1% | 63.46 ± 18.7% | 0.44 ± 1.7% | 92.70 ± 9.2% | 2488.52 ± 6.2% | 2.61 | 1.00 | 1.11 | 39.33 |
| class: two capitalized words, second text | 5359 | 871.89 ± 3.4% | 853.78 ± 2.2% | 36.60 ± 1.5% | 566.35 ± 0.5% | 50.87 ± 9.2% | 17.77 ± 0.9% | 94.94 ± 3.9% | 861.43 ± 2.8% | 1.02 | 1.01 | 1.54 | 17.14 |
| other: a word between two words | 6104 | 1054.80 ± 1.4% | 881.75 ± 1.7% | 35.06 ± 2.4% | 951.83 ± 3.9% | 171.61 ± 14.7% | 10.13 ± 2.3% | 108.76 ± 3.3% | 1042.29 ± 3.9% | 1.20 | 1.01 | 1.11 | 6.15 |
| other: a number before a unit, second text | 1481 | 12648.77 ± 3.1% | 1153.89 ± 1.8% | 39.90 ± 3.5% | 10524.74 ± 5.9% | 58.98 ± 12.7% | 18.48 ± 2.5% | 100.42 ± 36.0% | 12536.47 ± 1.9% | 10.96 | 1.01 | 1.20 | 214.45 |
| other: a heading's start tag | 110 | 29540.68 ± 5.8% | 1185.36 ± 4.7% | 40.29 ± 12.5% | 3272.99 ± 0.8% | 2513.20 ± 10.1% | 13.78 ± 9.2% | 147.87 ± 9.3% | 29436.01 ± 1.7% | 24.92 | 1.00 | 9.03 | 11.75 |
| other: a whole word | 217 | 37381.14 ± 0.9% | 1198.61 ± 2.2% | 43.96 ± 11.1% | 36218.79 ± 2.6% | 73.56 ± 9.3% | 13.55 ± 2.0% | 78.47 ± 1.1% | 37134.65 ± 2.5% | 31.19 | 1.01 | 1.03 | 508.18 |
| other: a line's first word, second text | 3716 | 3288.26 ± 2.3% | 1011.27 ± 3.9% | 47.45 ± 4.8% | 3393.56 ± 1.7% | 98.51 ± 5.9% | refused | refused | 3265.79 ± 4.4% | 3.25 | 1.01 | 0.97 | 33.38 |
| other: fourteen octets before an x | 87 | 46696.02 ± 2.6% | 334.81 ± 5.5% | 9.49 ± 0.6% | 4762.75 ± 1.2% | 14.42 ± 1.2% | differs | 24.76 ± 3.8% | 46950.42 ± 2.5% | 139.47 | 0.99 | 9.80 | 3239.10 |
| other: a Greek word | 21815 | 599.61 ± 1.0% | 474.49 ± 3.5% | 48.00 ± 2.9% | 361.92 ± 0.8% | 79.03 ± 6.6% | differs | refused | 587.59 ± 4.4% | 1.26 | 1.02 | 1.66 | 7.59 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 34.47 ± 5.5% | 34.91 ± 1.1% | 1.56 ± 3.5% | 23.87 ± 1.3% | 3.62 ± 3.0% | differs | 5.84 ± 2.7% | 34.95 ± 2.5% | 0.99 | 0.99 | 1.44 | 9.52 |
| a UUID | 32895 | 29.46 ± 1.2% | 29.07 ± 4.4% | 1.01 ± 1.4% | 17.94 ± 4.1% | 3.56 ± 4.6% | 0.73 ± 3.8% | 4.71 ± 16.8% | 29.35 ± 22.6% | 1.01 | 1.00 | 1.64 | 8.28 |
| an IPv4 address | 33176 | 46.98 ± 5.3% | 47.33 ± 2.2% | 3.32 ± 3.1% | 34.54 ± 1.3% | 8.92 ± 3.0% | differs | 5.89 ± 5.4% | 47.48 ± 1.6% | 0.99 | 0.99 | 1.36 | 5.27 |
| a date and time | 32954 | 43.04 ± 1.9% | 43.99 ± 0.7% | 2.42 ± 8.1% | 25.92 ± 1.7% | 10.70 ± 2.5% | 1.30 ± 2.4% | 11.03 ± 2.2% | 43.13 ± 0.6% | 0.98 | 1.00 | 1.66 | 4.02 |
| a field path | 32606 | 37.53 ± 0.9% | 36.99 ± 0.6% | 1.76 ± 15.0% | 26.37 ± 41.9% | 4.61 ± 22.8% | differs | 4.11 ± 2.8% | 37.14 ± 0.6% | 1.01 | 1.01 | 1.42 | 8.14 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 13.08 ± 0.8% | 12.99 ± 12.7% | 12.87 ± 0.8% | 17.16 ± 0.5% | 7.58 ± 5.2% | 1.06 ± 1.3% | none | 13.00 ± 1.3% | 1.01 | 1.01 | 0.76 | 1.73 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 368.30 ± 0.8% | 369.70 ± 5.2% | 426.99 ± 1.3% | 134.38 ± 3.5% | 319.87 ± 7.3% | 875.36 ± 5.5% | 5729.05 ± 13.7% | 366.97 ± 32.7% | 1.00 | 1.00 | 2.74 | 1.15 |
| a UUID | 62 | 237.82 ± 2.7% | 239.35 ± 0.6% | 262.12 ± 2.6% | 74.02 ± 5.2% | 158.21 ± 19.5% | 309.34 ± 49.2% | 7017.77 ± 17.6% | 238.40 ± 0.5% | 0.99 | 1.00 | 3.21 | 1.50 |
| an IPv4 address | 29 | 724.42 ± 2.3% | 739.37 ± 1.8% | 1012.78 ± 2.3% | 120.47 ± 2.1% | 202.55 ± 11.5% | 550.20 ± 0.9% | 12767.08 ± 12.7% | 729.73 ± 1.2% | 0.98 | 0.99 | 6.01 | 3.58 |
| a date and time | 56 | 519.39 ± 16.0% | 521.46 ± 37.7% | 644.75 ± 40.0% | 115.35 ± 3.8% | 219.62 ± 10.8% | 577.47 ± 1.7% | 7592.90 ± 11.7% | 519.81 ± 2.1% | 1.00 | 1.00 | 4.50 | 2.36 |
| a field path | 39 | 359.85 ± 2.7% | 364.64 ± 2.7% | 423.50 ± 3.3% | 126.16 ± 2.6% | 306.71 ± 3.8% | 900.45 ± 1.7% | 7193.94 ± 4.0% | 361.20 ± 25.3% | 0.99 | 1.00 | 2.85 | 1.17 |
| literal: a word | 7 | 1127.67 ± 11.5% | 1198.68 ± 2.1% | 2057.34 ± 2.2% | 822.38 ± 2.5% | 1019.71 ± 1.8% | 1819.93 ± 1.1% | 47053.45 ± 0.8% | 1119.68 ± 0.6% | 0.94 | 1.01 | 1.37 | 1.11 |
| literal: a word that is not there | 8 | 1060.34 ± 2.9% | 1142.79 ± 1.7% | 1957.14 ± 1.8% | 768.02 ± 1.9% | 986.40 ± 2.6% | 1715.16 ± 1.3% | 46639.61 ± 1.5% | 1076.08 ± 2.5% | 0.93 | 0.99 | 1.38 | 1.07 |
| literal: one of four words | 26 | 414.77 ± 1.5% | 654.63 ± 1.3% | 866.01 ± 3.1% | 66.80 ± 1.6% | 386.41 ± 24.3% | 668.71 ± 1.5% | 23944.44 ± 1.8% | 414.93 ± 1.2% | 0.63 | 1.00 | 6.21 | 1.07 |
| literal: a word in any case | 11 | 860.62 ± 0.9% | 915.60 ± 1.1% | 1350.74 ± 4.9% | 22.90 ± 1.1% | 1066.45 ± 9.8% | refused | 37463.66 ± 34.6% | 858.98 ± 1.6% | 0.94 | 1.00 | 37.58 | 0.81 |
| literal: an href attribute | 12 | 577.82 ± 28.4% | 605.53 ± 13.8% | 778.85 ± 31.4% | 60.74 ± 14.6% | 753.30 ± 3.6% | 1473.32 ± 4.5% | 35098.92 ± 8.8% | 576.53 ± 13.4% | 0.95 | 1.00 | 9.51 | 0.77 |
| literal: a word, second text | 10 | 964.21 ± 1.7% | 1054.65 ± 3.6% | 1711.26 ± 8.8% | 695.66 ± 0.4% | 860.30 ± 9.7% | 1538.70 ± 4.8% | 41991.64 ± 1.5% | 974.82 ± 2.6% | 0.91 | 0.99 | 1.39 | 1.12 |
| class: two capitalized words | 23 | 784.19 ± 2.0% | 836.63 ± 2.9% | 1186.30 ± 3.1% | 163.12 ± 2.1% | 798.03 ± 8.5% | 1445.35 ± 1.1% | 9445.57 ± 10.7% | 777.88 ± 1.6% | 0.94 | 1.01 | 4.81 | 0.98 |
| class: a word that ends in ing | 9 | 968.75 ± 1.9% | 1100.34 ± 3.3% | 1860.01 ± 10.7% | 205.60 ± 1.7% | 1114.08 ± 11.5% | 2198.77 ± 36.6% | 23575.32 ± 0.7% | 979.45 ± 3.6% | 0.88 | 0.99 | 4.71 | 0.87 |
| class: a word in capitals | 16 | 882.49 ± 1.9% | 951.36 ± 2.1% | 1497.70 ± 2.7% | 211.33 ± 1.8% | 1175.71 ± 1.7% | 2065.24 ± 3.1% | 12202.03 ± 8.0% | 884.62 ± 5.7% | 0.93 | 1.00 | 4.18 | 0.75 |
| class: a number | 6 | 1088.02 ± 1.0% | 1203.23 ± 2.6% | 2157.09 ± 3.5% | 58.55 ± 2.8% | 2125.31 ± 15.2% | 3680.74 ± 1.5% | 34837.56 ± 0.9% | 1086.71 ± 2.5% | 0.90 | 1.00 | 18.58 | 0.51 |
| class: two capitalized words, second text | 23 | 779.59 ± 1.2% | 843.34 ± 1.6% | 1183.06 ± 1.5% | 157.87 ± 1.4% | 795.13 ± 30.4% | 1423.15 ± 2.9% | 9453.11 ± 2.7% | 780.28 ± 1.5% | 0.92 | 1.00 | 4.94 | 0.98 |
| other: a word between two words | 13 | 960.21 ± 1.7% | 1000.82 ± 1.0% | 1531.71 ± 1.6% | 210.81 ± 2.1% | 767.50 ± 3.1% | 1536.82 ± 1.4% | 22874.26 ± 0.5% | 966.36 ± 1.5% | 0.96 | 0.99 | 4.55 | 1.25 |
| other: a number before a unit, second text | 15 | 683.98 ± 46.6% | 763.00 ± 1.0% | 1039.61 ± 2.1% | 55.85 ± 1.9% | 939.84 ± 3.6% | 1713.19 ± 6.4% | 24426.91 ± 59.0% | 676.28 ± 18.5% | 0.90 | 1.01 | 12.25 | 0.73 |
| other: a heading's start tag | 13 | 613.54 ± 1.4% | 618.07 ± 7.2% | 796.86 ± 4.3% | 58.07 ± 1.3% | 917.87 ± 1.5% | 1656.82 ± 7.5% | 28194.19 ± 49.0% | 609.43 ± 28.6% | 0.99 | 1.01 | 10.56 | 0.67 |
| other: a whole word | 11 | 975.22 ± 1.6% | 1037.83 ± 2.1% | 1625.73 ± 8.3% | 184.92 ± 2.6% | 880.57 ± 14.9% | 1580.81 ± 2.1% | 41760.03 ± 1.9% | 981.66 ± 2.2% | 0.94 | 0.99 | 5.27 | 1.11 |
| other: a line's first word, second text | 17 | 913.75 ± 2.6% | 978.96 ± 7.7% | 1502.17 ± 29.5% | 199.27 ± 1.5% | 1041.22 ± 2.7% | refused | refused | 923.81 ± 3.2% | 0.93 | 0.99 | 4.59 | 0.88 |
| other: fourteen octets before an x | 16 | 177.14 ± 1.3% | 248.64 ± 9.5% | 286.81 ± 2.2% | 21.87 ± 1.4% | 673.45 ± 4.8% | 738.37 ± 4.9% | 20166.60 ± 27.6% | 175.81 ± 21.6% | 0.71 | 1.01 | 8.10 | 0.26 |
| other: a Greek word | 8 | 700.39 ± 3.3% | 932.40 ± 8.5% | 1449.56 ± 5.4% | 73.16 ± 0.5% | 2096.41 ± 13.9% | 3363.39 ± 0.6% | refused | 700.16 ± 1.6% | 0.75 | 1.00 | 9.57 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 34875.15 ± 11.2% | not timed | not timed | 43606.07 ± 3.1% | 3441.54 ± 26.3% | not timed | not timed | 34776.25 ± 2.0% | | 1.00 | 0.80 | 10.13 |
| 01-literal/sherlock-casei-en | 522 | 10692.53 ± 1.3% | not timed | not timed | 11186.01 ± 2.3% | 50.76 ± 2.4% | not timed | not timed | 10753.17 ± 1.2% | | 0.99 | 0.96 | 210.66 |
| 01-literal/sherlock-ru | 724 | 35589.64 ± 2.1% | not timed | not timed | 42578.45 ± 3.9% | 2356.06 ± 6.5% | not timed | not timed | 35333.62 ± 1.8% | | 1.01 | 0.84 | 15.11 |
| 01-literal/sherlock-casei-ru | 746 | 10921.89 ± 0.4% | not timed | not timed | 9107.58 ± 2.5% | 55.53 ± 3.1% | not timed | not timed | 10937.35 ± 1.1% | | 1.00 | 1.20 | 196.69 |
| 01-literal/sherlock-zh | 30 | 71738.39 ± 0.8% | not timed | not timed | 58103.91 ± 12.3% | 2061.47 ± 2.4% | not timed | not timed | 72011.35 ± 1.9% | | 1.00 | 1.23 | 34.80 |
| 02-literal-alternate/sherlock-en | 714 | 15811.81 ± 1.8% | not timed | not timed | 13190.66 ± 2.3% | 28.60 ± 1.9% | not timed | not timed | 15926.76 ± 2.4% | | 0.99 | 1.20 | 552.87 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2738.96 ± 6.0% | not timed | not timed | 2867.05 ± 1.7% | 17.51 ± 3.7% | not timed | not timed | 2620.18 ± 2.0% | | 1.05 | 0.96 | 156.39 |
| 02-literal-alternate/sherlock-ru | 899 | 8963.34 ± 1.9% | not timed | not timed | 7289.56 ± 4.1% | 37.40 ± 15.0% | not timed | not timed | 8977.23 ± 2.0% | | 1.00 | 1.23 | 239.67 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2435.02 ± 47.0% | not timed | not timed | 1408.54 ± 0.5% | 15.77 ± 2.5% | not timed | not timed | 2423.99 ± 9.2% | | 1.00 | 1.73 | 154.38 |
| 02-literal-alternate/sherlock-zh | 207 | 22882.72 ± 1.9% | not timed | not timed | 15460.85 ± 0.7% | 52.44 ± 2.1% | not timed | not timed | 22828.25 ± 1.9% | | 1.00 | 1.48 | 436.37 |
| 03-date/ascii | 111817 | 148.77 ± 1.9% | not timed | not timed | 124.55 ± 2.9% | 0.31 ± 2.8% | not timed | not timed | 147.92 ± 2.4% | | 1.01 | 1.19 | 474.69 |
| 04-ruff-noqa/real | 84 | 847.93 ± 1.8% | not timed | not timed | 660.35 ± 1.2% | 30.12 ± 7.7% | not timed | not timed | 850.00 ± 7.5% | | 1.00 | 1.28 | 28.15 |
| 04-ruff-noqa/tweaked | 44 | 764.15 ± 23.8% | not timed | not timed | 674.83 ± 2.7% | 473.11 ± 11.9% | not timed | not timed | 774.23 ± 22.4% | | 0.99 | 1.13 | 1.62 |
| 05-lexer-veryl/single | 124800 | 5.99 ± 3.5% | not timed | not timed | 7.52 ± 2.5% | 0.34 ± 9.3% | not timed | not timed | 6.02 ± 1.6% | | 0.99 | 0.80 | 17.44 |
| 06-cloud-flare-redos/original | 107 | 321.72 ± 0.6% | not timed | not timed | 279.80 ± 3.0% | 35.27 ± 6.3% | not timed | not timed | 319.80 ± 1.3% | | 1.01 | 1.15 | 9.12 |
| 06-cloud-flare-redos/simplified-short | 102 | 317.57 ± 4.1% | not timed | not timed | 295.91 ± 1.4% | 40.87 ± 3.8% | not timed | not timed | 320.72 ± 9.4% | | 0.99 | 1.07 | 7.77 |
| 06-cloud-flare-redos/simplified-long | 10000 | 345.95 ± 4.2% | not timed | not timed | 332.08 ± 2.3% | 46.87 ± 4.1% | not timed | not timed | 342.32 ± 6.7% | | 1.01 | 1.04 | 7.38 |
| 07-unicode-character-data/parse-line | 558784 | 323.31 ± 3.9% | not timed | not timed | 263.18 ± 3.8% | 69.62 ± 7.4% | not timed | not timed | 327.32 ± 7.1% | | 0.99 | 1.23 | 4.64 |
| 08-words/all-english | 56691 | 133.14 ± 4.7% | not timed | not timed | 110.85 ± 8.4% | 21.63 ± 11.6% | not timed | not timed | 138.95 ± 5.1% | | 0.96 | 1.20 | 6.16 |
| 08-words/long-english | 839 | 1184.47 ± 3.6% | not timed | not timed | 700.76 ± 5.7% | 50.67 ± 40.4% | not timed | not timed | 1186.37 ± 33.5% | | 1.00 | 1.69 | 23.38 |
| 09-aws-keys/full | 0 | 686.79 ± 5.7% | not timed | not timed | 687.27 ± 4.2% | 98.56 ± 9.5% | not timed | not timed | 669.72 ± 7.5% | | 1.03 | 1.00 | 6.97 |
| 09-aws-keys/quick | 0 | 1352.01 ± 2.7% | not timed | not timed | 1208.33 ± 7.0% | 563.05 ± 29.5% | not timed | not timed | 1311.08 ± 30.7% | | 1.03 | 1.12 | 2.40 |
| 10-bounded-repeat/letters-en | 1833 | 748.73 ± 35.4% | not timed | not timed | 732.05 ± 11.6% | 29.91 ± 7.4% | not timed | not timed | 745.49 ± 18.9% | | 1.00 | 1.02 | 25.03 |
| 10-bounded-repeat/letters-ru | 3475 | 450.81 ± 6.6% | not timed | not timed | 645.46 ± 6.5% | 30.27 ± 14.8% | not timed | not timed | 438.96 ± 18.5% | | 1.03 | 0.70 | 14.89 |
| 10-bounded-repeat/context | 53 | 106.82 ± 89.6% | not timed | not timed | 88.45 ± 18.2% | 28.42 ± 7.9% | not timed | not timed | 104.06 ± 21.7% | | 1.03 | 1.21 | 3.76 |
| 10-bounded-repeat/capitals | 11 | 1230.50 ± 1.4% | not timed | not timed | 715.82 ± 2.9% | 52.39 ± 2.0% | not timed | not timed | 1222.70 ± 0.5% | | 1.01 | 1.72 | 23.49 |
| 11-unstructured-to-json/extract | 600 | 62.06 ± 3.8% | not timed | not timed | 103.46 ± 5.5% | 73.12 ± 9.8% | not timed | not timed | 60.69 ± 21.4% | | 1.02 | 0.60 | 0.85 |
| 12-dictionary/single | 1 | 639.16 ± 2.4% | not timed | not timed | 614.27 ± 4.0% | 0.66 ± 9.7% | not timed | not timed | 636.80 ± 1.6% | | 1.00 | 1.04 | 970.84 |
| 14-quadratic/1x | 100 | 11.52 ± 2.9% | not timed | not timed | 17.13 ± 3.9% | 1.43 ± 4.2% | not timed | not timed | 11.22 ± 5.2% | | 1.03 | 0.67 | 8.06 |
| 14-quadratic/2x | 200 | 6.30 ± 28.2% | not timed | not timed | 7.93 ± 1.8% | 0.78 ± 5.2% | not timed | not timed | 6.25 ± 3.5% | | 1.01 | 0.79 | 8.06 |
| 14-quadratic/10x | 1000 | 1.40 ± 2.4% | not timed | not timed | 1.46 ± 1.8% | 0.17 ± 2.9% | not timed | not timed | 1.40 ± 1.2% | | 1.00 | 0.96 | 8.09 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.36 ± 6.8% | not timed | not timed | 0.53 ± 1.3% | 0.83 ± 8.4% | not timed | not timed | 2.36 ± 8.5% | | 1.00 | 4.41 | 2.84 |
| 04-ruff-noqa/compile-real | 1 | 159.27 ± 2.7% | not timed | not timed | 21.56 ± 12.7% | 223.88 ± 2.8% | not timed | not timed | 160.59 ± 1.9% | | 0.99 | 7.39 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 23.33 ± 1.5% | not timed | not timed | 3.86 ± 1.2% | 10.67 ± 11.4% | not timed | not timed | 23.05 ± 2.2% | | 1.01 | 6.04 | 2.19 |
| 07-unicode-character-data/compile | 1 | 89.15 ± 23.3% | not timed | not timed | 40.25 ± 7.1% | 59.72 ± 3.3% | not timed | not timed | 88.27 ± 27.0% | | 1.01 | 2.21 | 1.49 |
| 09-aws-keys/compile-full | 1 | 61.94 ± 4.8% | not timed | not timed | 12.46 ± 9.2% | 37.10 ± 42.4% | not timed | not timed | 61.80 ± 2.9% | | 1.00 | 4.97 | 1.67 |
| 09-aws-keys/compile-quick | 1 | 295.67 ± 3.4% | not timed | not timed | 78.73 ± 2.0% | 215.98 ± 2.3% | not timed | not timed | 296.43 ± 1.7% | | 1.00 | 3.76 | 1.37 |
| 10-bounded-repeat/compile-context | 1 | 22.46 ± 13.3% | not timed | not timed | 18.02 ± 4.7% | 26.46 ± 3.4% | not timed | not timed | 22.42 ± 1.7% | | 1.00 | 1.25 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 129.33 ± 3.3% | not timed | not timed | 12.53 ± 2.0% | 38.39 ± 3.0% | not timed | not timed | 128.05 ± 1.6% | | 1.01 | 10.32 | 3.37 |
| 11-unstructured-to-json/compile | 1 | 138.72 ± 5.3% | not timed | not timed | 62.84 ± 2.3% | 111.50 ± 9.1% | not timed | not timed | 138.86 ± 2.5% | | 1.00 | 2.21 | 1.24 |
| 12-dictionary/compile-single | 1 | 0.45 ± 37.6% | not timed | not timed | 0.09 ± 16.6% | 0.13 ± 23.4% | not timed | not timed | 0.45 ± 8.0% | | 1.01 | 4.94 | 3.40 |

