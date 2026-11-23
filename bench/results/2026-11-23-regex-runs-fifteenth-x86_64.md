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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148122155 |
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
| literal: a word | 217 | 53363.36 ± 3.3% | 1203.79 ± 0.5% | 45.04 ± 1.1% | 51236.71 ± 2.0% | 16225.30 ± 8.4% | 15.58 ± 7.3% | 149.93 ± 3.8% | 53534.96 ± 8.0% | 44.33 | 1.00 | 1.04 | 3.29 |
| literal: a word that is not there | 0 | 77706.17 ± 2.4% | 1215.59 ± 0.7% | 44.78 ± 1.7% | 63205.31 ± 2.3% | 53999.86 ± 5.0% | 15.27 ± 2.2% | 140.21 ± 1.6% | 77870.74 ± 1.3% | 63.92 | 1.00 | 1.23 | 1.44 |
| literal: one of four words | 661 | 19185.22 ± 4.2% | 1181.44 ± 2.7% | 25.01 ± 1.4% | 14375.34 ± 2.6% | 38.32 ± 1.3% | 5.04 ± 2.0% | 11.60 ± 13.7% | 19149.53 ± 1.3% | 16.24 | 1.00 | 1.33 | 500.66 |
| literal: a word in any case | 217 | 47816.60 ± 2.0% | 1201.42 ± 1.0% | 32.86 ± 2.1% | 14073.65 ± 1.8% | 72.17 ± 19.9% | refused | differs | 47553.52 ± 38.9% | 39.80 | 1.01 | 3.40 | 662.56 |
| literal: an href attribute | 33 | 46283.09 ± 0.7% | 1215.23 ± 1.5% | 37.91 ± 4.3% | 44038.24 ± 5.5% | 3527.45 ± 2.8% | 11.17 ± 2.3% | 127.23 ± 7.8% | 46263.65 ± 2.4% | 38.09 | 1.00 | 1.05 | 13.12 |
| literal: a word, second text | 123 | 52580.26 ± 12.5% | 1213.87 ± 1.3% | 42.81 ± 3.2% | 48364.94 ± 11.0% | 14632.14 ± 4.2% | 20.68 ± 4.2% | 121.66 ± 1.0% | 53121.19 ± 2.7% | 43.32 | 0.99 | 1.09 | 3.59 |
| class: two capitalized words | 1331 | 1108.83 ± 3.4% | 1121.45 ± 1.1% | 40.57 ± 0.3% | 680.29 ± 1.3% | 60.70 ± 2.6% | 13.56 ± 1.3% | 101.73 ± 5.6% | 1103.55 ± 4.6% | 0.99 | 1.00 | 1.63 | 18.27 |
| class: a word that ends in ing | 3399 | 1033.05 ± 1.1% | 1033.06 ± 2.8% | 27.58 ± 0.6% | 637.15 ± 2.3% | 45.44 ± 22.0% | 7.91 ± 2.1% | 29.59 ± 2.7% | 1031.67 ± 3.2% | 1.00 | 1.00 | 1.62 | 22.73 |
| class: a word in capitals | 2332 | 1592.22 ± 2.3% | 1097.71 ± 1.0% | 42.27 ± 7.4% | 664.47 ± 3.2% | 65.46 ± 12.5% | 16.75 ± 5.0% | 132.82 ± 8.6% | 1578.97 ± 2.5% | 1.45 | 1.01 | 2.40 | 24.32 |
| class: a number | 8288 | 2465.94 ± 4.4% | 945.99 ± 21.3% | 41.93 ± 4.7% | 2318.21 ± 5.1% | 59.79 ± 18.7% | 0.46 ± 1.0% | 93.01 ± 4.0% | 2475.78 ± 5.1% | 2.61 | 1.00 | 1.06 | 41.24 |
| class: two capitalized words, second text | 5359 | 845.44 ± 1.6% | 849.37 ± 1.3% | 34.65 ± 3.0% | 573.87 ± 4.9% | 50.77 ± 22.4% | 17.67 ± 2.0% | 94.80 ± 3.8% | 851.01 ± 1.6% | 1.00 | 0.99 | 1.47 | 16.65 |
| other: a word between two words | 6104 | 1058.19 ± 2.9% | 892.88 ± 2.9% | 35.60 ± 3.5% | 971.72 ± 1.7% | 164.04 ± 12.0% | 10.32 ± 4.2% | 109.59 ± 3.6% | 1051.76 ± 3.6% | 1.19 | 1.01 | 1.09 | 6.45 |
| other: a number before a unit, second text | 1481 | 12526.01 ± 1.9% | 1149.82 ± 2.3% | 40.44 ± 2.0% | 10843.11 ± 4.4% | 59.68 ± 1.6% | 18.66 ± 4.2% | 103.28 ± 9.3% | 12606.20 ± 3.6% | 10.89 | 0.99 | 1.16 | 209.89 |
| other: a heading's start tag | 110 | 29800.97 ± 0.8% | 1206.01 ± 1.9% | 41.00 ± 3.7% | 3334.08 ± 1.9% | 2515.15 ± 10.4% | 13.98 ± 4.1% | 145.50 ± 6.0% | 29788.90 ± 1.6% | 24.71 | 1.00 | 8.94 | 11.85 |
| other: a whole word | 217 | 36841.00 ± 1.8% | 1202.24 ± 2.1% | 44.73 ± 1.1% | 35861.69 ± 10.0% | 74.08 ± 1.4% | 13.74 ± 1.6% | 82.96 ± 10.0% | 37207.74 ± 5.3% | 30.64 | 0.99 | 1.03 | 497.31 |
| other: a line's first word, second text | 3716 | 3321.68 ± 2.1% | 1009.73 ± 1.3% | 48.23 ± 1.8% | 3447.34 ± 1.5% | 99.11 ± 5.5% | refused | refused | 3312.10 ± 1.8% | 3.29 | 1.00 | 0.96 | 33.52 |
| other: fourteen octets before an x | 87 | 46362.72 ± 4.4% | 332.87 ± 2.0% | 9.43 ± 2.1% | 4751.85 ± 0.9% | 14.47 ± 1.9% | differs | 25.41 ± 7.8% | 46557.48 ± 1.7% | 139.28 | 1.00 | 9.76 | 3204.54 |
| other: a Greek word | 21815 | 594.99 ± 2.7% | 470.28 ± 1.3% | 45.15 ± 1.4% | 346.73 ± 2.9% | 58.66 ± 14.3% | differs | refused | 594.11 ± 3.8% | 1.27 | 1.00 | 1.72 | 10.14 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 34.29 ± 1.5% | 34.52 ± 1.1% | 1.49 ± 3.2% | 23.01 ± 1.1% | 3.59 ± 3.6% | differs | 5.76 ± 3.3% | 34.67 ± 0.9% | 0.99 | 0.99 | 1.49 | 9.55 |
| a UUID | 32895 | 29.37 ± 1.5% | 29.38 ± 1.8% | 1.03 ± 1.1% | 17.97 ± 0.7% | 3.56 ± 2.3% | 0.63 ± 2.5% | 4.64 ± 4.8% | 29.04 ± 2.3% | 1.00 | 1.01 | 1.63 | 8.25 |
| an IPv4 address | 33176 | 47.38 ± 0.9% | 47.55 ± 0.8% | 3.24 ± 3.8% | 34.93 ± 2.4% | 9.12 ± 4.2% | differs | 5.93 ± 3.0% | 47.39 ± 1.3% | 1.00 | 1.00 | 1.36 | 5.20 |
| a date and time | 32954 | 43.92 ± 2.8% | 44.10 ± 1.8% | 2.47 ± 3.5% | 26.22 ± 0.9% | 10.65 ± 4.5% | 1.12 ± 1.1% | 11.01 ± 13.9% | 44.07 ± 0.9% | 1.00 | 1.00 | 1.67 | 4.12 |
| a field path | 32606 | 37.98 ± 2.9% | 37.87 ± 2.5% | 1.67 ± 2.8% | 27.84 ± 1.6% | 4.60 ± 5.5% | differs | 4.16 ± 2.8% | 37.70 ± 4.7% | 1.00 | 1.01 | 1.36 | 8.25 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 12.96 ± 4.2% | 13.15 ± 3.8% | 13.20 ± 4.1% | 17.24 ± 4.0% | 7.63 ± 2.4% | 0.95 ± 0.9% | none | 13.20 ± 2.0% | 0.99 | 0.98 | 0.75 | 1.70 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 364.07 ± 5.6% | 368.03 ± 3.4% | 421.61 ± 5.4% | 133.88 ± 1.2% | 329.91 ± 2.4% | 881.87 ± 6.3% | 5664.99 ± 7.3% | 366.76 ± 6.3% | 0.99 | 0.99 | 2.72 | 1.10 |
| a UUID | 62 | 236.53 ± 1.3% | 236.11 ± 2.2% | 260.87 ± 3.4% | 74.39 ± 1.2% | 158.20 ± 17.6% | 308.40 ± 2.4% | 7048.60 ± 4.9% | 234.78 ± 3.7% | 1.00 | 1.01 | 3.18 | 1.50 |
| an IPv4 address | 29 | 743.75 ± 5.8% | 757.44 ± 5.5% | 1025.98 ± 5.6% | 119.71 ± 5.7% | 207.69 ± 4.4% | 558.41 ± 1.0% | 13042.18 ± 2.8% | 735.58 ± 1.6% | 0.98 | 1.01 | 6.21 | 3.58 |
| a date and time | 56 | 510.94 ± 1.6% | 513.96 ± 1.1% | 626.02 ± 2.7% | 115.88 ± 2.0% | 225.30 ± 4.7% | 573.19 ± 4.5% | 7643.95 ± 4.8% | 510.78 ± 1.4% | 0.99 | 1.00 | 4.41 | 2.27 |
| a field path | 39 | 355.33 ± 3.3% | 357.16 ± 3.4% | 416.22 ± 5.6% | 128.15 ± 4.6% | 307.28 ± 8.0% | 898.28 ± 6.8% | 6958.35 ± 7.9% | 356.37 ± 5.9% | 0.99 | 1.00 | 2.77 | 1.16 |
| literal: a word | 7 | 1136.41 ± 2.2% | 1215.96 ± 2.3% | 2105.76 ± 2.5% | 859.95 ± 3.3% | 1039.65 ± 4.1% | 1778.84 ± 0.8% | 46919.35 ± 6.3% | 1137.72 ± 2.9% | 0.93 | 1.00 | 1.32 | 1.09 |
| literal: a word that is not there | 8 | 1093.55 ± 4.1% | 1170.98 ± 4.4% | 1974.21 ± 3.0% | 798.20 ± 3.3% | 991.58 ± 6.8% | 1719.96 ± 6.1% | 46828.23 ± 3.3% | 1090.38 ± 5.4% | 0.93 | 1.00 | 1.37 | 1.10 |
| literal: one of four words | 26 | 427.39 ± 4.9% | 673.50 ± 2.3% | 866.16 ± 1.4% | 67.23 ± 2.0% | 383.75 ± 0.7% | 673.48 ± 2.8% | 24284.19 ± 3.9% | 429.61 ± 4.6% | 0.63 | 0.99 | 6.36 | 1.11 |
| literal: a word in any case | 11 | 863.97 ± 2.6% | 928.94 ± 4.1% | 1378.46 ± 3.9% | 23.19 ± 3.5% | 1075.80 ± 4.2% | refused | 37264.84 ± 5.1% | 868.96 ± 2.6% | 0.93 | 0.99 | 37.26 | 0.80 |
| literal: an href attribute | 12 | 597.55 ± 3.5% | 625.04 ± 4.7% | 794.14 ± 2.2% | 61.16 ± 8.2% | 749.76 ± 11.4% | 1491.43 ± 2.0% | 34209.54 ± 2.7% | 598.54 ± 2.3% | 0.96 | 1.00 | 9.77 | 0.80 |
| literal: a word, second text | 10 | 1005.21 ± 4.1% | 1085.01 ± 7.8% | 1745.29 ± 8.6% | 716.50 ± 3.5% | 862.78 ± 3.2% | 1536.80 ± 1.8% | 45223.18 ± 15.4% | 998.53 ± 1.5% | 0.93 | 1.01 | 1.40 | 1.17 |
| class: two capitalized words | 23 | 797.98 ± 1.8% | 864.81 ± 1.2% | 1232.24 ± 6.3% | 160.47 ± 2.5% | 797.98 ± 9.3% | 1444.24 ± 3.7% | 9447.03 ± 1.2% | 795.77 ± 1.9% | 0.92 | 1.00 | 4.97 | 1.00 |
| class: a word that ends in ing | 9 | 989.31 ± 3.0% | 1120.23 ± 3.4% | 1833.50 ± 3.7% | 204.92 ± 2.2% | 1123.91 ± 2.9% | 2209.38 ± 2.4% | 24399.42 ± 2.4% | 993.89 ± 5.2% | 0.88 | 1.00 | 4.83 | 0.88 |
| class: a word in capitals | 16 | 892.08 ± 1.9% | 956.86 ± 2.2% | 1509.64 ± 1.5% | 208.24 ± 1.3% | 1201.08 ± 2.3% | 2040.42 ± 1.0% | 12335.43 ± 2.1% | 893.87 ± 4.3% | 0.93 | 1.00 | 4.28 | 0.74 |
| class: a number | 6 | 1105.67 ± 3.1% | 1207.88 ± 1.1% | 2201.90 ± 3.2% | 58.79 ± 2.2% | 2188.60 ± 1.9% | 3640.72 ± 1.8% | 35651.82 ± 2.7% | 1102.35 ± 1.8% | 0.92 | 1.00 | 18.81 | 0.51 |
| class: two capitalized words, second text | 23 | 805.36 ± 2.3% | 867.27 ± 2.6% | 1230.27 ± 4.2% | 158.83 ± 3.3% | 807.64 ± 4.9% | 1429.29 ± 4.3% | 9387.76 ± 4.4% | 802.43 ± 5.4% | 0.93 | 1.00 | 5.07 | 1.00 |
| other: a word between two words | 13 | 960.40 ± 21.6% | 1005.85 ± 1.8% | 1551.91 ± 1.4% | 209.42 ± 5.3% | 772.73 ± 1.5% | 1532.09 ± 1.9% | 22808.87 ± 2.2% | 966.49 ± 10.5% | 0.95 | 0.99 | 4.59 | 1.24 |
| other: a number before a unit, second text | 15 | 684.06 ± 3.1% | 760.48 ± 1.2% | 1036.11 ± 3.2% | 56.57 ± 4.3% | 960.20 ± 14.3% | 1746.77 ± 2.7% | 24835.00 ± 1.8% | 686.27 ± 1.8% | 0.90 | 1.00 | 12.09 | 0.71 |
| other: a heading's start tag | 13 | 619.10 ± 2.6% | 629.34 ± 2.9% | 817.03 ± 4.9% | 58.54 ± 25.2% | 909.09 ± 5.5% | 1658.58 ± 1.6% | 29522.08 ± 2.8% | 620.78 ± 3.1% | 0.98 | 1.00 | 10.57 | 0.68 |
| other: a whole word | 11 | 1007.27 ± 4.2% | 1074.59 ± 2.9% | 1692.01 ± 2.3% | 184.02 ± 6.4% | 879.49 ± 12.0% | 1594.74 ± 1.5% | 42732.81 ± 1.9% | 1000.38 ± 4.0% | 0.94 | 1.01 | 5.47 | 1.15 |
| other: a line's first word, second text | 17 | 955.62 ± 3.5% | 1008.57 ± 7.7% | 1573.91 ± 2.9% | 195.93 ± 11.9% | 1014.29 ± 74.1% | refused | refused | 948.71 ± 3.7% | 0.95 | 1.01 | 4.88 | 0.94 |
| other: fourteen octets before an x | 16 | 178.71 ± 13.5% | 254.41 ± 1.4% | 290.50 ± 3.8% | 22.36 ± 4.7% | 689.40 ± 0.5% | 732.75 ± 7.2% | 20921.87 ± 0.9% | 178.47 ± 0.7% | 0.70 | 1.00 | 7.99 | 0.26 |
| other: a Greek word | 8 | 720.14 ± 5.2% | 956.02 ± 4.9% | 1501.05 ± 1.6% | 74.01 ± 0.7% | 2127.17 ± 33.1% | 3456.97 ± 6.1% | refused | 724.50 ± 6.3% | 0.75 | 0.99 | 9.73 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 36016.65 ± 1.1% | not timed | not timed | 43851.53 ± 3.4% | 3848.99 ± 18.0% | not timed | not timed | 35715.25 ± 1.6% | | 1.01 | 0.82 | 9.36 |
| 01-literal/sherlock-casei-en | 522 | 10827.57 ± 8.9% | not timed | not timed | 11392.49 ± 1.9% | 50.81 ± 4.4% | not timed | not timed | 10771.29 ± 2.0% | | 1.01 | 0.95 | 213.11 |
| 01-literal/sherlock-ru | 724 | 35877.64 ± 3.6% | not timed | not timed | 42603.01 ± 2.2% | 2389.46 ± 30.7% | not timed | not timed | 35753.84 ± 5.3% | | 1.00 | 0.84 | 15.01 |
| 01-literal/sherlock-casei-ru | 746 | 11060.68 ± 1.9% | not timed | not timed | 9222.82 ± 0.9% | 56.42 ± 3.6% | not timed | not timed | 10976.81 ± 8.2% | | 1.01 | 1.20 | 196.03 |
| 01-literal/sherlock-zh | 30 | 70573.99 ± 3.9% | not timed | not timed | 58666.22 ± 4.9% | 2086.48 ± 6.5% | not timed | not timed | 70425.71 ± 8.7% | | 1.00 | 1.20 | 33.82 |
| 02-literal-alternate/sherlock-en | 714 | 16049.42 ± 1.4% | not timed | not timed | 13215.05 ± 1.0% | 28.64 ± 1.4% | not timed | not timed | 16090.40 ± 1.1% | | 1.00 | 1.21 | 560.34 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2749.39 ± 5.6% | not timed | not timed | 2899.50 ± 1.7% | 17.69 ± 2.4% | not timed | not timed | 2644.88 ± 4.2% | | 1.04 | 0.95 | 155.40 |
| 02-literal-alternate/sherlock-ru | 899 | 9033.17 ± 1.1% | not timed | not timed | 7465.43 ± 2.8% | 37.97 ± 3.0% | not timed | not timed | 9061.16 ± 5.0% | | 1.00 | 1.21 | 237.88 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2456.58 ± 2.8% | not timed | not timed | 1426.53 ± 4.0% | 16.02 ± 0.4% | not timed | not timed | 2410.33 ± 3.5% | | 1.02 | 1.72 | 153.33 |
| 02-literal-alternate/sherlock-zh | 207 | 23103.46 ± 1.8% | not timed | not timed | 15662.14 ± 0.6% | 52.76 ± 11.6% | not timed | not timed | 23078.54 ± 2.5% | | 1.00 | 1.48 | 437.91 |
| 03-date/ascii | 111817 | 152.41 ± 1.0% | not timed | not timed | 123.12 ± 1.6% | 0.31 ± 4.7% | not timed | not timed | 144.68 ± 2.3% | | 1.05 | 1.24 | 494.24 |
| 04-ruff-noqa/real | 84 | 805.26 ± 6.5% | not timed | not timed | 685.62 ± 2.7% | 30.55 ± 2.6% | not timed | not timed | 818.51 ± 5.6% | | 0.98 | 1.17 | 26.36 |
| 04-ruff-noqa/tweaked | 44 | 788.81 ± 3.9% | not timed | not timed | 694.40 ± 0.3% | 476.66 ± 10.4% | not timed | not timed | 781.85 ± 28.5% | | 1.01 | 1.14 | 1.65 |
| 05-lexer-veryl/single | 124800 | 6.13 ± 3.4% | not timed | not timed | 7.72 ± 4.8% | 0.35 ± 8.4% | not timed | not timed | 6.03 ± 5.5% | | 1.02 | 0.79 | 17.49 |
| 06-cloud-flare-redos/original | 107 | 330.95 ± 4.7% | not timed | not timed | 284.71 ± 4.8% | 38.47 ± 4.6% | not timed | not timed | 321.91 ± 7.7% | | 1.03 | 1.16 | 8.60 |
| 06-cloud-flare-redos/simplified-short | 102 | 321.14 ± 2.9% | not timed | not timed | 299.12 ± 8.2% | 41.59 ± 4.9% | not timed | not timed | 318.19 ± 4.8% | | 1.01 | 1.07 | 7.72 |
| 06-cloud-flare-redos/simplified-long | 10000 | 331.40 ± 2.6% | not timed | not timed | 322.21 ± 5.4% | 45.40 ± 0.5% | not timed | not timed | 330.82 ± 2.6% | | 1.00 | 1.03 | 7.30 |
| 07-unicode-character-data/parse-line | 558784 | 317.31 ± 8.8% | not timed | not timed | 256.20 ± 3.5% | 63.97 ± 16.7% | not timed | not timed | 323.23 ± 7.4% | | 0.98 | 1.24 | 4.96 |
| 08-words/all-english | 56691 | 134.11 ± 4.5% | not timed | not timed | 107.87 ± 0.6% | 19.25 ± 12.6% | not timed | not timed | 132.03 ± 3.5% | | 1.02 | 1.24 | 6.97 |
| 08-words/long-english | 839 | 1164.04 ± 1.2% | not timed | not timed | 693.70 ± 1.3% | 49.40 ± 0.9% | not timed | not timed | 1160.54 ± 2.5% | | 1.00 | 1.68 | 23.56 |
| 09-aws-keys/full | 0 | 684.06 ± 3.2% | not timed | not timed | 727.22 ± 2.9% | 97.93 ± 4.8% | not timed | not timed | 662.03 ± 3.1% | | 1.03 | 0.94 | 6.99 |
| 09-aws-keys/quick | 0 | 1349.60 ± 3.9% | not timed | not timed | 1269.29 ± 11.8% | 564.86 ± 14.0% | not timed | not timed | 1346.83 ± 4.9% | | 1.00 | 1.06 | 2.39 |
| 10-bounded-repeat/letters-en | 1833 | 771.03 ± 3.5% | not timed | not timed | 742.30 ± 2.6% | 29.88 ± 4.8% | not timed | not timed | 758.74 ± 4.0% | | 1.02 | 1.04 | 25.81 |
| 10-bounded-repeat/letters-ru | 3475 | 453.18 ± 4.8% | not timed | not timed | 657.46 ± 4.0% | 29.68 ± 12.8% | not timed | not timed | 437.56 ± 5.8% | | 1.04 | 0.69 | 15.27 |
| 10-bounded-repeat/context | 53 | 109.58 ± 4.4% | not timed | not timed | 92.48 ± 2.6% | 29.26 ± 6.2% | not timed | not timed | 107.25 ± 4.1% | | 1.02 | 1.18 | 3.75 |
| 10-bounded-repeat/capitals | 11 | 1243.44 ± 4.2% | not timed | not timed | 724.76 ± 3.5% | 53.18 ± 2.1% | not timed | not timed | 1229.26 ± 8.8% | | 1.01 | 1.72 | 23.38 |
| 11-unstructured-to-json/extract | 600 | 63.43 ± 2.9% | not timed | not timed | 104.50 ± 11.6% | 75.47 ± 88.6% | not timed | not timed | 61.94 ± 8.0% | | 1.02 | 0.61 | 0.84 |
| 12-dictionary/single | 1 | 656.15 ± 4.8% | not timed | not timed | 641.15 ± 4.0% | 0.66 ± 5.1% | not timed | not timed | 666.84 ± 7.7% | | 0.98 | 1.02 | 997.74 |
| 14-quadratic/1x | 100 | 11.64 ± 0.9% | not timed | not timed | 17.51 ± 0.9% | 1.48 ± 3.6% | not timed | not timed | 11.80 ± 2.0% | | 0.99 | 0.66 | 7.85 |
| 14-quadratic/2x | 200 | 6.30 ± 4.1% | not timed | not timed | 7.95 ± 2.4% | 0.80 ± 4.0% | not timed | not timed | 6.36 ± 2.8% | | 0.99 | 0.79 | 7.88 |
| 14-quadratic/10x | 1000 | 1.44 ± 2.1% | not timed | not timed | 1.49 ± 4.5% | 0.18 ± 3.5% | not timed | not timed | 1.42 ± 23.8% | | 1.01 | 0.96 | 8.06 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.44 ± 4.8% | not timed | not timed | 0.54 ± 4.4% | 0.84 ± 4.4% | not timed | not timed | 2.44 ± 7.4% | | 1.00 | 4.52 | 2.90 |
| 04-ruff-noqa/compile-real | 1 | 159.05 ± 3.6% | not timed | not timed | 21.39 ± 3.6% | 222.28 ± 4.0% | not timed | not timed | 156.86 ± 4.0% | | 1.01 | 7.44 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 23.57 ± 4.6% | not timed | not timed | 4.03 ± 3.6% | 10.76 ± 3.8% | not timed | not timed | 23.42 ± 4.8% | | 1.01 | 5.85 | 2.19 |
| 07-unicode-character-data/compile | 1 | 91.74 ± 1.7% | not timed | not timed | 40.26 ± 1.7% | 58.76 ± 2.8% | not timed | not timed | 92.66 ± 5.2% | | 0.99 | 2.28 | 1.56 |
| 09-aws-keys/compile-full | 1 | 64.22 ± 7.6% | not timed | not timed | 12.86 ± 4.9% | 36.39 ± 14.2% | not timed | not timed | 62.96 ± 6.1% | | 1.02 | 5.00 | 1.76 |
| 09-aws-keys/compile-quick | 1 | 296.74 ± 8.9% | not timed | not timed | 78.33 ± 12.2% | 212.83 ± 14.0% | not timed | not timed | 298.13 ± 4.6% | | 1.00 | 3.79 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 23.10 ± 2.8% | not timed | not timed | 17.58 ± 1.6% | 26.55 ± 3.9% | not timed | not timed | 23.14 ± 4.2% | | 1.00 | 1.31 | 0.87 |
| 10-bounded-repeat/compile-capitals | 1 | 132.58 ± 3.8% | not timed | not timed | 13.17 ± 5.1% | 39.58 ± 5.8% | not timed | not timed | 134.68 ± 2.4% | | 0.98 | 10.07 | 3.35 |
| 11-unstructured-to-json/compile | 1 | 143.99 ± 12.1% | not timed | not timed | 66.29 ± 3.9% | 115.59 ± 4.1% | not timed | not timed | 145.49 ± 4.2% | | 0.99 | 2.17 | 1.25 |
| 12-dictionary/compile-single | 1 | 0.47 ± 1.5% | not timed | not timed | 0.09 ± 7.6% | 0.15 ± 27.2% | not timed | not timed | 0.45 ± 2.8% | | 1.04 | 4.98 | 3.22 |

