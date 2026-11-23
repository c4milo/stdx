# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127352497 |
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
| literal: a word | 217 | 56461.32 ± 6.2% | 1270.09 ± 2.3% | 45.78 ± 3.3% | 54181.10 ± 1.8% | 16722.92 ± 4.5% | 16.42 ± 1.5% | 165.57 ± 10.5% | 55505.89 ± 2.5% | 44.45 | 1.02 | 1.04 | 3.38 |
| literal: a word that is not there | 0 | 82176.56 ± 3.7% | 1282.18 ± 0.9% | 46.95 ± 4.4% | 66586.84 ± 6.0% | 57450.41 ± 3.3% | 16.14 ± 0.5% | 153.50 ± 0.7% | 82686.38 ± 0.8% | 64.09 | 0.99 | 1.23 | 1.43 |
| literal: one of four words | 661 | 20061.97 ± 1.9% | 1243.09 ± 0.5% | 25.83 ± 3.5% | 15064.64 ± 3.4% | 39.57 ± 12.2% | 5.34 ± 0.8% | 14.03 ± 0.3% | 20065.61 ± 2.0% | 16.14 | 1.00 | 1.33 | 507.03 |
| literal: a word in any case | 217 | 50998.75 ± 5.5% | 1228.70 ± 4.8% | 33.07 ± 4.5% | 14805.57 ± 6.2% | 72.02 ± 4.1% | refused | differs | 51550.35 ± 5.9% | 41.51 | 0.99 | 3.44 | 708.08 |
| literal: an href attribute | 33 | 48196.81 ± 2.2% | 1278.91 ± 0.2% | 40.09 ± 0.4% | 47441.61 ± 4.5% | 3686.03 ± 2.1% | 11.71 ± 0.8% | 139.31 ± 4.2% | 48220.30 ± 5.5% | 37.69 | 1.00 | 1.02 | 13.08 |
| literal: a word, second text | 123 | 56991.58 ± 6.4% | 1272.59 ± 1.4% | 45.18 ± 0.4% | 50539.36 ± 5.9% | 15110.14 ± 10.5% | 21.68 ± 0.5% | 136.52 ± 4.9% | 56289.62 ± 4.8% | 44.78 | 1.01 | 1.13 | 3.77 |
| class: two capitalized words | 1331 | 1151.30 ± 0.5% | 1183.93 ± 1.6% | 42.81 ± 1.5% | 714.48 ± 5.3% | 62.81 ± 2.5% | 14.30 ± 5.0% | 108.90 ± 4.3% | 1137.64 ± 5.0% | 0.97 | 1.01 | 1.61 | 18.33 |
| class: a word that ends in ing | 3399 | 1084.94 ± 0.7% | 1084.08 ± 0.7% | 27.93 ± 0.9% | 672.64 ± 0.4% | 46.71 ± 7.4% | 8.31 ± 1.2% | 32.14 ± 7.6% | 1084.13 ± 1.4% | 1.00 | 1.00 | 1.61 | 23.22 |
| class: a word in capitals | 2332 | 1622.92 ± 2.7% | 1135.55 ± 3.9% | 44.49 ± 1.8% | 702.40 ± 1.7% | 66.03 ± 22.7% | 17.12 ± 1.5% | 141.92 ± 0.4% | 1646.67 ± 2.0% | 1.43 | 0.99 | 2.31 | 24.58 |
| class: a number | 8288 | 2599.05 ± 3.3% | 999.23 ± 4.5% | 44.78 ± 3.8% | 2411.08 ± 4.9% | 59.13 ± 17.7% | 0.47 ± 4.6% | 102.10 ± 0.9% | 2597.99 ± 4.4% | 2.60 | 1.00 | 1.08 | 43.95 |
| class: two capitalized words, second text | 5359 | 889.55 ± 3.3% | 889.07 ± 5.0% | 38.34 ± 5.3% | 600.66 ± 5.2% | 49.79 ± 8.3% | 18.50 ± 6.2% | 101.08 ± 5.8% | 889.58 ± 6.0% | 1.00 | 1.00 | 1.48 | 17.86 |
| other: a word between two words | 6104 | 971.80 ± 4.3% | 923.19 ± 4.5% | 36.76 ± 5.5% | 1011.94 ± 4.6% | 176.54 ± 11.5% | 10.77 ± 5.0% | 117.94 ± 3.1% | 1002.50 ± 4.9% | 1.05 | 0.97 | 0.96 | 5.50 |
| other: a number before a unit, second text | 1481 | 11943.30 ± 1.1% | 1209.93 ± 3.7% | 41.86 ± 8.4% | 11055.43 ± 2.0% | 62.78 ± 4.8% | 19.43 ± 3.8% | 110.52 ± 10.9% | 11889.53 ± 5.7% | 9.87 | 1.00 | 1.08 | 190.25 |
| other: a heading's start tag | 110 | 30890.82 ± 9.4% | 1268.46 ± 36.8% | 43.17 ± 12.7% | 3469.23 ± 7.1% | 2640.54 ± 3.7% | 14.59 ± 0.8% | 170.24 ± 1.1% | 30930.14 ± 1.5% | 24.35 | 1.00 | 8.90 | 11.70 |
| other: a whole word | 217 | 38898.22 ± 3.9% | 1271.69 ± 1.1% | 47.73 ± 1.0% | 37859.75 ± 0.6% | 76.89 ± 10.9% | 14.08 ± 1.3% | 88.88 ± 3.0% | 39071.01 ± 6.7% | 30.59 | 1.00 | 1.03 | 505.86 |
| other: a line's first word, second text | 3716 | 3015.78 ± 0.7% | 1062.81 ± 0.3% | 51.65 ± 8.0% | 3549.08 ± 0.9% | 105.80 ± 1.8% | refused | refused | 2965.66 ± 0.3% | 2.84 | 1.02 | 0.85 | 28.50 |
| other: fourteen octets before an x | 87 | 47876.75 ± 4.4% | 353.51 ± 2.7% | 9.16 ± 1.5% | 5092.40 ± 3.2% | 15.12 ± 2.0% | differs | 27.38 ± 4.4% | 48058.52 ± 1.5% | 135.43 | 1.00 | 9.40 | 3165.87 |
| other: a Greek word | 21815 | 593.30 ± 6.3% | 441.09 ± 6.5% | 47.08 ± 10.6% | 362.23 ± 26.7% | 58.02 ± 60.4% | differs | refused | 597.15 ± 5.8% | 1.35 | 0.99 | 1.64 | 10.23 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 35.16 ± 2.4% | 34.86 ± 1.1% | 1.39 ± 4.7% | 24.22 ± 8.8% | 3.47 ± 14.1% | differs | 6.10 ± 25.7% | 34.97 ± 40.8% | 1.01 | 1.01 | 1.45 | 10.14 |
| a UUID | 32895 | 29.86 ± 4.8% | 29.88 ± 4.7% | 1.03 ± 8.3% | 18.33 ± 19.3% | 3.58 ± 45.7% | 0.74 ± 3.8% | 4.80 ± 4.8% | 29.93 ± 14.9% | 1.00 | 1.00 | 1.63 | 8.34 |
| an IPv4 address | 33176 | 47.30 ± 29.3% | 48.31 ± 58.5% | 3.38 ± 5.2% | 35.21 ± 15.4% | 9.43 ± 4.7% | differs | 5.87 ± 5.3% | 49.00 ± 9.3% | 0.98 | 0.97 | 1.34 | 5.02 |
| a date and time | 32954 | 44.98 ± 3.3% | 44.29 ± 1.4% | 2.47 ± 3.6% | 26.40 ± 4.4% | 11.03 ± 7.6% | 1.30 ± 15.7% | 11.92 ± 6.2% | 43.75 ± 3.8% | 1.02 | 1.03 | 1.70 | 4.08 |
| a field path | 32606 | 38.11 ± 4.1% | 38.05 ± 3.9% | 1.75 ± 3.2% | 28.61 ± 6.2% | 4.83 ± 11.2% | differs | 4.27 ± 10.0% | 38.68 ± 9.2% | 1.00 | 0.99 | 1.33 | 7.90 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 13.95 ± 3.4% | 14.01 ± 3.1% | 13.66 ± 2.3% | 17.95 ± 3.2% | 7.82 ± 6.0% | 1.10 ± 5.3% | none | 13.74 ± 4.3% | 1.00 | 1.01 | 0.78 | 1.78 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 377.26 ± 34.3% | 380.48 ± 80.8% | 453.28 ± 5.1% | 136.03 ± 3.4% | 315.90 ± 12.7% | 887.32 ± 5.9% | 5861.31 ± 34.3% | 385.83 ± 4.8% | 0.99 | 0.98 | 2.77 | 1.19 |
| a UUID | 62 | 245.24 ± 4.0% | 244.68 ± 6.1% | 277.96 ± 4.3% | 77.87 ± 6.4% | 167.27 ± 7.8% | 317.22 ± 4.5% | 7324.45 ± 5.6% | 247.70 ± 5.0% | 1.00 | 0.99 | 3.15 | 1.47 |
| an IPv4 address | 29 | 750.21 ± 5.3% | 766.91 ± 6.6% | 1025.09 ± 3.0% | 119.68 ± 12.3% | 207.67 ± 12.8% | 556.44 ± 75.5% | 13154.56 ± 15.4% | 744.29 ± 22.8% | 0.98 | 1.01 | 6.27 | 3.61 |
| a date and time | 56 | 548.62 ± 2.7% | 556.00 ± 0.8% | 684.41 ± 0.8% | 119.50 ± 2.4% | 234.23 ± 5.2% | 607.07 ± 2.0% | 8099.28 ± 5.8% | 548.09 ± 3.6% | 0.99 | 1.00 | 4.59 | 2.34 |
| a field path | 39 | 389.73 ± 2.8% | 389.13 ± 3.4% | 449.61 ± 4.9% | 133.25 ± 2.8% | 317.71 ± 6.3% | 927.93 ± 6.5% | 7555.34 ± 5.5% | 389.37 ± 4.3% | 1.00 | 1.00 | 2.92 | 1.23 |
| literal: a word | 7 | 1225.09 ± 4.5% | 1314.73 ± 4.2% | 2280.43 ± 4.9% | 825.62 ± 0.8% | 1080.20 ± 0.8% | 1903.90 ± 1.2% | 50517.40 ± 2.9% | 1227.02 ± 1.2% | 0.93 | 1.00 | 1.48 | 1.13 |
| literal: a word that is not there | 8 | 1168.33 ± 1.2% | 1263.46 ± 0.9% | 2123.25 ± 2.1% | 758.78 ± 6.1% | 1034.67 ± 5.1% | 1824.22 ± 2.5% | 49778.92 ± 7.5% | 1167.13 ± 5.4% | 0.92 | 1.00 | 1.54 | 1.13 |
| literal: one of four words | 26 | 451.71 ± 4.4% | 709.06 ± 4.6% | 940.77 ± 6.0% | 68.31 ± 4.2% | 391.22 ± 9.7% | 705.68 ± 5.1% | 28377.26 ± 11.9% | 437.55 ± 6.2% | 0.64 | 1.03 | 6.61 | 1.15 |
| literal: a word in any case | 11 | 932.62 ± 14.7% | 1000.65 ± 2.4% | 1479.97 ± 3.1% | 24.33 ± 2.4% | 1145.60 ± 3.4% | refused | 41553.41 ± 10.7% | 936.63 ± 37.8% | 0.93 | 1.00 | 38.33 | 0.81 |
| literal: an href attribute | 12 | 616.34 ± 4.4% | 630.23 ± 5.5% | 822.06 ± 5.7% | 62.60 ± 2.4% | 785.18 ± 5.1% | 1553.36 ± 21.7% | 34284.84 ± 78.3% | 615.60 ± 26.2% | 0.98 | 1.00 | 9.85 | 0.78 |
| literal: a word, second text | 10 | 1042.89 ± 9.6% | 1154.71 ± 7.4% | 1784.94 ± 9.7% | 743.86 ± 9.5% | 902.14 ± 10.9% | 1613.98 ± 9.9% | 46884.25 ± 65.8% | 1051.31 ± 10.4% | 0.90 | 0.99 | 1.40 | 1.16 |
| class: two capitalized words | 23 | 850.55 ± 6.1% | 910.73 ± 2.1% | 1298.97 ± 1.6% | 166.01 ± 5.0% | 832.93 ± 3.7% | 1521.82 ± 4.1% | 9898.64 ± 1.7% | 847.33 ± 2.8% | 0.93 | 1.00 | 5.12 | 1.02 |
| class: a word that ends in ing | 9 | 1049.83 ± 1.5% | 1186.34 ± 1.5% | 1978.99 ± 2.5% | 214.76 ± 6.3% | 1160.60 ± 1.1% | 2352.34 ± 2.7% | 24656.51 ± 0.5% | 1045.63 ± 1.1% | 0.88 | 1.00 | 4.89 | 0.90 |
| class: a word in capitals | 16 | 939.49 ± 1.1% | 1014.10 ± 1.5% | 1600.65 ± 3.7% | 217.30 ± 5.6% | 1196.24 ± 11.4% | 2149.62 ± 2.1% | 13009.64 ± 0.9% | 941.38 ± 7.8% | 0.93 | 1.00 | 4.32 | 0.79 |
| class: a number | 6 | 1164.17 ± 5.2% | 1267.47 ± 5.4% | 2227.65 ± 6.2% | 61.91 ± 5.5% | 2186.21 ± 5.2% | 3627.55 ± 3.9% | 34958.18 ± 3.8% | 1125.15 ± 4.6% | 0.92 | 1.03 | 18.80 | 0.53 |
| class: two capitalized words, second text | 23 | 857.67 ± 6.4% | 913.78 ± 4.7% | 1290.25 ± 5.1% | 162.97 ± 3.6% | 840.23 ± 0.9% | 1441.75 ± 1.3% | 9969.61 ± 0.8% | 858.64 ± 1.6% | 0.94 | 1.00 | 5.26 | 1.02 |
| other: a word between two words | 13 | 1032.62 ± 3.5% | 1076.89 ± 1.7% | 1645.90 ± 4.3% | 221.58 ± 9.5% | 805.37 ± 68.0% | 1625.03 ± 11.1% | 24505.06 ± 1.3% | 1033.83 ± 0.9% | 0.96 | 1.00 | 4.66 | 1.28 |
| other: a number before a unit, second text | 15 | 719.85 ± 6.5% | 806.51 ± 3.5% | 1107.31 ± 10.1% | 59.00 ± 2.9% | 920.12 ± 10.2% | 1790.58 ± 2.4% | 25626.57 ± 4.3% | 722.78 ± 5.6% | 0.89 | 1.00 | 12.20 | 0.78 |
| other: a heading's start tag | 13 | 653.27 ± 1.6% | 668.46 ± 4.1% | 868.39 ± 1.8% | 61.05 ± 3.2% | 978.03 ± 4.8% | 1726.52 ± 1.4% | 30862.19 ± 3.2% | 646.24 ± 2.4% | 0.98 | 1.01 | 10.70 | 0.67 |
| other: a whole word | 11 | 1071.36 ± 0.2% | 1134.03 ± 3.0% | 1767.09 ± 1.9% | 188.07 ± 7.6% | 937.27 ± 8.7% | 1679.07 ± 9.3% | 46034.16 ± 1.0% | 1060.62 ± 2.9% | 0.94 | 1.01 | 5.70 | 1.14 |
| other: a line's first word, second text | 17 | 986.48 ± 4.0% | 1041.12 ± 4.1% | 1624.65 ± 4.4% | 207.13 ± 3.0% | 1099.95 ± 4.1% | refused | refused | 984.52 ± 3.3% | 0.95 | 1.00 | 4.76 | 0.90 |
| other: fourteen octets before an x | 16 | 188.47 ± 4.3% | 271.19 ± 3.6% | 309.18 ± 5.2% | 23.09 ± 5.7% | 696.05 ± 5.0% | 741.27 ± 5.5% | 20978.44 ± 5.2% | 185.18 ± 4.6% | 0.69 | 1.02 | 8.16 | 0.27 |
| other: a Greek word | 8 | 773.28 ± 5.2% | 1027.13 ± 5.5% | 1593.76 ± 3.7% | 77.22 ± 0.7% | 2209.88 ± 1.9% | 3586.78 ± 6.8% | refused | 775.67 ± 3.7% | 0.75 | 1.00 | 10.01 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 35806.20 ± 1.0% | not timed | not timed | 45211.84 ± 4.2% | 3707.79 ± 14.4% | not timed | not timed | 35642.40 ± 0.8% | | 1.00 | 0.79 | 9.66 |
| 01-literal/sherlock-casei-en | 522 | 7776.49 ± 1.5% | not timed | not timed | 11945.61 ± 1.2% | 53.17 ± 2.2% | not timed | not timed | 7747.52 ± 1.4% | | 1.00 | 0.65 | 146.27 |
| 01-literal/sherlock-ru | 724 | 37127.66 ± 2.1% | not timed | not timed | 44873.71 ± 7.6% | 2506.95 ± 4.4% | not timed | not timed | 36837.39 ± 1.6% | | 1.01 | 0.83 | 14.81 |
| 01-literal/sherlock-casei-ru | 746 | 11646.54 ± 0.4% | not timed | not timed | 9753.77 ± 4.7% | 58.50 ± 7.7% | not timed | not timed | 11651.22 ± 3.0% | | 1.00 | 1.19 | 199.07 |
| 01-literal/sherlock-zh | 30 | 74946.40 ± 1.8% | not timed | not timed | 59221.93 ± 4.3% | 2135.85 ± 5.1% | not timed | not timed | 74341.46 ± 4.2% | | 1.01 | 1.27 | 35.09 |
| 02-literal-alternate/sherlock-en | 714 | 16802.39 ± 2.3% | not timed | not timed | 14030.83 ± 0.8% | 30.38 ± 1.4% | not timed | not timed | 16809.20 ± 1.0% | | 1.00 | 1.20 | 553.02 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2960.63 ± 34.2% | not timed | not timed | 3021.87 ± 3.9% | 17.83 ± 9.8% | not timed | not timed | 2868.14 ± 50.2% | | 1.03 | 0.98 | 166.09 |
| 02-literal-alternate/sherlock-ru | 899 | 9574.53 ± 2.7% | not timed | not timed | 7633.32 ± 11.1% | 39.33 ± 1.1% | not timed | not timed | 9616.06 ± 1.7% | | 1.00 | 1.25 | 243.43 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2630.24 ± 5.0% | not timed | not timed | 1486.00 ± 8.5% | 16.52 ± 14.6% | not timed | not timed | 2591.31 ± 3.3% | | 1.02 | 1.77 | 159.17 |
| 02-literal-alternate/sherlock-zh | 207 | 23408.48 ± 4.0% | not timed | not timed | 16263.59 ± 12.6% | 55.27 ± 78.1% | not timed | not timed | 23257.63 ± 11.8% | | 1.01 | 1.44 | 423.50 |
| 03-date/ascii | 111817 | 157.24 ± 5.3% | not timed | not timed | 127.55 ± 4.2% | 0.32 ± 2.4% | not timed | not timed | 156.00 ± 3.9% | | 1.01 | 1.23 | 493.56 |
| 04-ruff-noqa/real | 84 | 888.05 ± 2.7% | not timed | not timed | 705.48 ± 1.2% | 32.23 ± 1.8% | not timed | not timed | 884.53 ± 6.1% | | 1.00 | 1.26 | 27.55 |
| 04-ruff-noqa/tweaked | 44 | 833.85 ± 4.1% | not timed | not timed | 704.64 ± 3.6% | 488.90 ± 10.8% | not timed | not timed | 820.04 ± 3.4% | | 1.02 | 1.18 | 1.71 |
| 05-lexer-veryl/single | 124800 | 5.21 ± 29.6% | not timed | not timed | 7.52 ± 27.6% | 0.35 ± 21.2% | not timed | not timed | 5.28 ± 4.8% | | 0.99 | 0.69 | 14.99 |
| 06-cloud-flare-redos/original | 107 | 330.45 ± 3.0% | not timed | not timed | 285.04 ± 15.3% | 38.35 ± 7.7% | not timed | not timed | 334.55 ± 3.5% | | 0.99 | 1.16 | 8.62 |
| 06-cloud-flare-redos/simplified-short | 102 | 325.92 ± 9.2% | not timed | not timed | 298.29 ± 2.0% | 42.09 ± 2.7% | not timed | not timed | 327.91 ± 3.8% | | 0.99 | 1.09 | 7.74 |
| 06-cloud-flare-redos/simplified-long | 10000 | 332.20 ± 1.2% | not timed | not timed | 323.04 ± 2.5% | 45.58 ± 3.9% | not timed | not timed | 331.90 ± 4.8% | | 1.00 | 1.03 | 7.29 |
| 07-unicode-character-data/parse-line | 558784 | 337.80 ± 9.5% | not timed | not timed | 255.96 ± 4.2% | 67.49 ± 4.2% | not timed | not timed | 342.62 ± 6.1% | | 0.99 | 1.32 | 5.01 |
| 08-words/all-english | 56691 | 135.52 ± 4.2% | not timed | not timed | 109.10 ± 6.0% | 18.90 ± 4.7% | not timed | not timed | 141.46 ± 5.1% | | 0.96 | 1.24 | 7.17 |
| 08-words/long-english | 839 | 1215.30 ± 1.0% | not timed | not timed | 724.17 ± 2.2% | 51.62 ± 15.5% | not timed | not timed | 1214.96 ± 0.6% | | 1.00 | 1.68 | 23.54 |
| 09-aws-keys/full | 0 | 672.33 ± 5.9% | not timed | not timed | 729.02 ± 3.5% | 99.38 ± 4.2% | not timed | not timed | 675.31 ± 1.6% | | 1.00 | 0.92 | 6.77 |
| 09-aws-keys/quick | 0 | 1385.44 ± 3.4% | not timed | not timed | 1287.72 ± 1.2% | 578.16 ± 6.9% | not timed | not timed | 1399.76 ± 1.5% | | 0.99 | 1.08 | 2.40 |
| 10-bounded-repeat/letters-en | 1833 | 767.16 ± 40.5% | not timed | not timed | 743.85 ± 59.6% | 30.76 ± 1.5% | not timed | not timed | 776.69 ± 4.6% | | 0.99 | 1.03 | 24.94 |
| 10-bounded-repeat/letters-ru | 3475 | 438.36 ± 7.5% | not timed | not timed | 648.48 ± 4.3% | 30.76 ± 16.3% | not timed | not timed | 437.94 ± 5.3% | | 1.00 | 0.68 | 14.25 |
| 10-bounded-repeat/context | 53 | 114.80 ± 3.6% | not timed | not timed | 94.51 ± 3.1% | 30.22 ± 5.8% | not timed | not timed | 114.21 ± 3.6% | | 1.01 | 1.21 | 3.80 |
| 10-bounded-repeat/capitals | 11 | 1286.52 ± 3.0% | not timed | not timed | 747.76 ± 1.8% | 53.53 ± 32.4% | not timed | not timed | 1285.11 ± 6.6% | | 1.00 | 1.72 | 24.03 |
| 11-unstructured-to-json/extract | 600 | 62.46 ± 62.7% | not timed | not timed | 108.14 ± 3.8% | 78.75 ± 11.1% | not timed | not timed | 62.68 ± 6.2% | | 1.00 | 0.58 | 0.79 |
| 12-dictionary/single | 1 | 665.16 ± 4.8% | not timed | not timed | 643.63 ± 6.5% | 0.66 ± 6.2% | not timed | not timed | 672.17 ± 4.7% | | 0.99 | 1.03 | 1011.77 |
| 14-quadratic/1x | 100 | 16.82 ± 4.4% | not timed | not timed | 17.10 ± 4.7% | 1.47 ± 5.6% | not timed | not timed | 17.56 ± 17.6% | | 0.96 | 0.98 | 11.43 |
| 14-quadratic/2x | 200 | 9.95 ± 1.5% | not timed | not timed | 8.18 ± 3.7% | 0.81 ± 9.9% | not timed | not timed | 10.10 ± 4.5% | | 0.98 | 1.22 | 12.25 |
| 14-quadratic/10x | 1000 | 2.25 ± 3.7% | not timed | not timed | 1.52 ± 2.9% | 0.18 ± 2.2% | not timed | not timed | 2.25 ± 3.4% | | 1.00 | 1.47 | 12.56 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.54 ± 5.1% | not timed | not timed | 0.56 ± 6.4% | 0.88 ± 3.0% | not timed | not timed | 2.52 ± 1.6% | | 1.01 | 4.56 | 2.88 |
| 04-ruff-noqa/compile-real | 1 | 158.34 ± 5.0% | not timed | not timed | 21.30 ± 18.2% | 224.51 ± 6.7% | not timed | not timed | 157.56 ± 5.3% | | 1.01 | 7.43 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 23.93 ± 8.8% | not timed | not timed | 3.95 ± 4.3% | 10.76 ± 11.6% | not timed | not timed | 23.83 ± 59.5% | | 1.00 | 6.06 | 2.22 |
| 07-unicode-character-data/compile | 1 | 92.26 ± 39.2% | not timed | not timed | 39.82 ± 15.3% | 55.66 ± 94.9% | not timed | not timed | 88.21 ± 58.6% | | 1.05 | 2.32 | 1.66 |
| 09-aws-keys/compile-full | 1 | 63.62 ± 12.7% | not timed | not timed | 12.46 ± 1.8% | 36.78 ± 0.7% | not timed | not timed | 63.30 ± 9.7% | | 1.01 | 5.10 | 1.73 |
| 09-aws-keys/compile-quick | 1 | 299.97 ± 11.7% | not timed | not timed | 79.64 ± 18.3% | 214.82 ± 2.6% | not timed | not timed | 301.44 ± 5.1% | | 1.00 | 3.77 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 24.02 ± 8.9% | not timed | not timed | 17.55 ± 4.6% | 26.99 ± 6.7% | not timed | not timed | 23.81 ± 2.7% | | 1.01 | 1.37 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 132.45 ± 12.9% | not timed | not timed | 13.25 ± 4.7% | 39.62 ± 5.5% | not timed | not timed | 132.09 ± 4.5% | | 1.00 | 10.00 | 3.34 |
| 11-unstructured-to-json/compile | 1 | 146.40 ± 7.1% | not timed | not timed | 65.99 ± 3.7% | 113.22 ± 5.4% | not timed | not timed | 145.84 ± 5.1% | | 1.00 | 2.22 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.48 ± 2.9% | not timed | not timed | 0.09 ± 21.4% | 0.14 ± 14.6% | not timed | not timed | 0.47 ± 4.2% | | 1.01 | 5.13 | 3.45 |

