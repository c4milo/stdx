# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102081656 |
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
| literal: a word | 217 | 54079.26 ± 0.9% | 1204.42 ± 0.5% | 44.70 ± 1.9% | 52209.65 ± 0.4% | 16204.54 ± 6.6% | 16.11 ± 5.7% | 159.66 ± 1.9% | 54050.13 ± 0.9% | 44.90 | 1.00 | 1.04 | 3.34 |
| literal: a word that is not there | 0 | 78003.35 ± 0.8% | 1214.90 ± 1.2% | 44.41 ± 1.0% | 63915.59 ± 0.4% | 53633.88 ± 4.1% | 15.63 ± 2.9% | 145.46 ± 1.2% | 77917.21 ± 0.8% | 64.21 | 1.00 | 1.22 | 1.45 |
| literal: one of four words | 661 | 18097.92 ± 11.6% | 1164.02 ± 25.7% | 24.60 ± 0.6% | 14159.19 ± 4.2% | 38.10 ± 2.0% | 5.01 ± 1.3% | 13.20 ± 0.6% | 18090.39 ± 5.0% | 15.55 | 1.00 | 1.28 | 475.01 |
| literal: a word in any case | 217 | 48681.49 ± 0.7% | 1193.56 ± 0.6% | 32.08 ± 2.3% | 13998.84 ± 4.1% | 71.68 ± 0.6% | refused | differs | 48339.68 ± 1.8% | 40.79 | 1.01 | 3.48 | 679.13 |
| literal: an href attribute | 33 | 45096.32 ± 3.4% | 1194.33 ± 2.2% | 37.10 ± 3.4% | 44050.95 ± 4.2% | 3454.89 ± 5.1% | 11.37 ± 1.8% | 129.88 ± 4.3% | 44382.39 ± 5.5% | 37.76 | 1.02 | 1.02 | 13.05 |
| literal: a word, second text | 123 | 52298.14 ± 3.5% | 1196.24 ± 1.1% | 42.47 ± 5.3% | 47371.87 ± 6.8% | 14813.26 ± 3.8% | 20.49 ± 2.6% | 128.44 ± 2.6% | 52136.09 ± 2.6% | 43.72 | 1.00 | 1.10 | 3.53 |
| class: two capitalized words | 1331 | 1090.16 ± 3.0% | 1106.21 ± 1.6% | 40.63 ± 1.7% | 680.47 ± 0.8% | 60.91 ± 23.7% | 13.77 ± 32.5% | 105.58 ± 2.2% | 1086.35 ± 5.1% | 0.99 | 1.00 | 1.60 | 17.90 |
| class: a word that ends in ing | 3399 | 999.75 ± 1.3% | 1000.29 ± 1.5% | 27.34 ± 5.5% | 624.66 ± 7.7% | 44.75 ± 4.2% | 7.78 ± 0.8% | 30.13 ± 1.5% | 1002.76 ± 0.7% | 1.00 | 1.00 | 1.60 | 22.34 |
| class: a word in capitals | 2332 | 1554.90 ± 1.1% | 1066.55 ± 0.6% | 41.66 ± 18.7% | 661.64 ± 39.5% | 64.13 ± 11.1% | 16.29 ± 1.1% | 134.04 ± 2.3% | 1543.64 ± 2.0% | 1.46 | 1.01 | 2.35 | 24.25 |
| class: a number | 8288 | 2495.94 ± 0.7% | 903.19 ± 1.6% | 41.87 ± 9.5% | 2275.75 ± 1.8% | 62.12 ± 19.4% | 0.45 ± 1.9% | 95.53 ± 0.9% | 2473.42 ± 0.9% | 2.76 | 1.01 | 1.10 | 40.18 |
| class: two capitalized words, second text | 5359 | 803.91 ± 0.8% | 803.41 ± 1.5% | 34.93 ± 12.3% | 563.19 ± 0.7% | 49.87 ± 12.9% | 17.47 ± 4.5% | 96.50 ± 5.2% | 804.26 ± 1.0% | 1.00 | 1.00 | 1.43 | 16.12 |
| other: a word between two words | 6104 | 943.66 ± 2.5% | 847.40 ± 2.7% | 34.62 ± 2.7% | 937.48 ± 2.7% | 164.08 ± 11.6% | 10.28 ± 1.0% | 101.65 ± 1.4% | 940.28 ± 1.9% | 1.11 | 1.00 | 1.01 | 5.75 |
| other: a number before a unit, second text | 1481 | 11138.19 ± 18.5% | 1108.48 ± 2.2% | 39.75 ± 0.8% | 10593.58 ± 1.8% | 58.99 ± 18.3% | 18.14 ± 0.9% | 100.59 ± 2.6% | 11280.10 ± 2.7% | 10.05 | 0.99 | 1.05 | 188.82 |
| other: a heading's start tag | 110 | 29371.09 ± 3.5% | 1179.82 ± 1.4% | 40.07 ± 1.0% | 3248.70 ± 0.9% | 2483.72 ± 1.2% | 14.32 ± 2.1% | 161.41 ± 2.7% | 29394.57 ± 3.0% | 24.89 | 1.00 | 9.04 | 11.83 |
| other: a whole word | 217 | 37034.03 ± 3.3% | 1185.37 ± 1.1% | 42.93 ± 1.4% | 35178.32 ± 1.9% | 72.54 ± 22.9% | 13.59 ± 2.9% | 79.89 ± 1.2% | 36949.41 ± 0.9% | 31.24 | 1.00 | 1.05 | 510.50 |
| other: a line's first word, second text | 3716 | 2854.90 ± 1.2% | 969.20 ± 1.6% | 47.66 ± 3.2% | 3428.49 ± 3.7% | 98.14 ± 47.6% | refused | refused | 2849.12 ± 2.3% | 2.95 | 1.00 | 0.83 | 29.09 |
| other: fourteen octets before an x | 87 | 43817.25 ± 0.8% | 324.59 ± 0.9% | 7.65 ± 2.0% | 4619.31 ± 1.3% | 14.08 ± 3.6% | differs | 25.02 ± 3.5% | 44097.57 ± 1.6% | 134.99 | 0.99 | 9.49 | 3112.63 |
| other: a Greek word | 21815 | 573.12 ± 3.8% | 386.69 ± 4.4% | 45.43 ± 2.1% | 350.10 ± 25.3% | 59.06 ± 15.3% | differs | refused | 565.12 ± 5.2% | 1.48 | 1.01 | 1.64 | 9.70 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 34.49 ± 3.6% | 34.34 ± 3.1% | 1.34 ± 2.8% | 23.02 ± 4.7% | 3.46 ± 9.8% | differs | 5.86 ± 2.4% | 34.40 ± 3.7% | 1.00 | 1.00 | 1.50 | 9.97 |
| a UUID | 32895 | 29.34 ± 0.4% | 29.06 ± 1.1% | 1.00 ± 1.8% | 17.90 ± 1.1% | 3.48 ± 2.5% | 0.71 ± 0.9% | 4.69 ± 4.5% | 29.46 ± 1.8% | 1.01 | 1.00 | 1.64 | 8.42 |
| an IPv4 address | 33176 | 47.71 ± 2.0% | 47.75 ± 1.2% | 3.26 ± 1.8% | 34.35 ± 0.5% | 8.88 ± 1.2% | differs | 5.93 ± 1.9% | 47.57 ± 3.9% | 1.00 | 1.00 | 1.39 | 5.37 |
| a date and time | 32954 | 44.31 ± 0.3% | 44.33 ± 1.1% | 2.43 ± 2.3% | 26.05 ± 1.0% | 10.80 ± 3.1% | 1.28 ± 0.9% | 11.80 ± 6.8% | 44.34 ± 0.9% | 1.00 | 1.00 | 1.70 | 4.10 |
| a field path | 32606 | 38.66 ± 0.9% | 38.57 ± 1.4% | 1.66 ± 2.3% | 27.54 ± 5.2% | 4.68 ± 3.4% | differs | 4.21 ± 2.0% | 38.21 ± 0.6% | 1.00 | 1.01 | 1.40 | 8.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.35 ± 1.0% | 14.91 ± 0.7% | 15.26 ± 1.0% | 17.25 ± 1.6% | 7.71 ± 3.2% | 1.04 ± 0.3% | none | 14.20 ± 0.3% | 1.03 | 1.08 | 0.89 | 1.99 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 366.24 ± 3.5% | 370.38 ± 3.4% | 433.87 ± 3.9% | 131.79 ± 1.9% | 329.59 ± 6.8% | 878.65 ± 3.8% | 5693.66 ± 2.6% | 365.99 ± 3.5% | 0.99 | 1.00 | 2.78 | 1.11 |
| a UUID | 62 | 236.53 ± 4.7% | 237.26 ± 4.1% | 261.22 ± 3.2% | 72.29 ± 1.9% | 158.45 ± 4.1% | 304.75 ± 2.3% | 7186.70 ± 4.5% | 237.22 ± 4.3% | 1.00 | 1.00 | 3.27 | 1.49 |
| an IPv4 address | 29 | 726.65 ± 4.5% | 733.76 ± 2.6% | 1001.64 ± 3.0% | 119.51 ± 1.9% | 204.97 ± 1.3% | 538.34 ± 2.7% | 12728.25 ± 2.0% | 728.62 ± 2.3% | 0.99 | 1.00 | 6.08 | 3.55 |
| a date and time | 56 | 529.60 ± 2.1% | 529.22 ± 1.9% | 647.12 ± 4.4% | 114.59 ± 1.9% | 205.72 ± 47.2% | 553.16 ± 23.4% | 7689.64 ± 5.9% | 523.53 ± 2.0% | 1.00 | 1.01 | 4.62 | 2.57 |
| a field path | 39 | 371.29 ± 2.7% | 370.01 ± 17.2% | 409.50 ± 50.6% | 126.38 ± 25.6% | 308.40 ± 112.6% | 894.19 ± 4.4% | 7436.51 ± 21.4% | 368.02 ± 4.2% | 1.00 | 1.01 | 2.94 | 1.20 |
| literal: a word | 7 | 1158.35 ± 6.4% | 1235.64 ± 5.9% | 2173.56 ± 4.8% | 826.54 ± 14.3% | 1030.26 ± 8.0% | 1769.71 ± 4.8% | 47910.11 ± 7.7% | 1174.66 ± 4.0% | 0.94 | 0.99 | 1.40 | 1.12 |
| literal: a word that is not there | 8 | 1157.59 ± 2.2% | 1249.73 ± 1.4% | 2101.01 ± 4.2% | 808.93 ± 5.4% | 1032.12 ± 19.4% | 1799.49 ± 3.2% | 49893.78 ± 4.6% | 1162.11 ± 5.9% | 0.93 | 1.00 | 1.43 | 1.12 |
| literal: one of four words | 26 | 425.66 ± 11.0% | 690.12 ± 55.5% | 895.35 ± 6.2% | 68.72 ± 8.0% | 393.08 ± 9.4% | 674.41 ± 3.2% | 27896.94 ± 15.8% | 439.27 ± 7.6% | 0.62 | 0.97 | 6.19 | 1.08 |
| literal: a word in any case | 11 | 885.07 ± 2.8% | 933.19 ± 1.8% | 1407.63 ± 2.7% | 22.82 ± 1.8% | 1091.83 ± 2.1% | refused | 39305.33 ± 2.3% | 880.93 ± 3.6% | 0.95 | 1.00 | 38.79 | 0.81 |
| literal: an href attribute | 12 | 587.79 ± 20.3% | 596.67 ± 10.5% | 808.05 ± 3.7% | 60.13 ± 2.3% | 756.43 ± 7.1% | 1477.03 ± 47.7% | 31263.17 ± 11.5% | 591.77 ± 1.5% | 0.99 | 0.99 | 9.77 | 0.78 |
| literal: a word, second text | 10 | 1007.08 ± 1.0% | 1087.61 ± 2.0% | 1760.12 ± 2.3% | 694.89 ± 13.9% | 868.65 ± 1.5% | 1523.29 ± 4.2% | 45296.25 ± 1.3% | 997.48 ± 2.2% | 0.93 | 1.01 | 1.45 | 1.16 |
| class: two capitalized words | 23 | 793.66 ± 24.9% | 853.12 ± 48.7% | 1216.99 ± 2.7% | 159.63 ± 2.6% | 783.98 ± 9.3% | 1408.22 ± 4.2% | 9466.57 ± 2.6% | 780.45 ± 5.6% | 0.93 | 1.02 | 4.97 | 1.01 |
| class: a word that ends in ing | 9 | 985.93 ± 3.8% | 1114.41 ± 3.0% | 1787.16 ± 7.6% | 201.90 ± 3.3% | 1089.03 ± 2.2% | 2158.35 ± 2.0% | 24148.74 ± 2.3% | 995.13 ± 1.3% | 0.88 | 0.99 | 4.88 | 0.91 |
| class: a word in capitals | 16 | 894.74 ± 1.2% | 969.31 ± 2.1% | 1521.58 ± 2.1% | 206.27 ± 1.2% | 1176.81 ± 3.4% | 2015.33 ± 0.9% | 12500.96 ± 1.7% | 898.63 ± 1.0% | 0.92 | 1.00 | 4.34 | 0.76 |
| class: a number | 6 | 1096.71 ± 2.3% | 1216.88 ± 2.0% | 2177.58 ± 5.0% | 58.24 ± 3.4% | 2112.17 ± 11.2% | 3641.00 ± 5.7% | 35324.68 ± 0.7% | 1096.49 ± 1.7% | 0.90 | 1.00 | 18.83 | 0.52 |
| class: two capitalized words, second text | 23 | 788.65 ± 2.6% | 847.35 ± 4.0% | 1216.21 ± 4.0% | 155.71 ± 4.8% | 784.59 ± 41.5% | 1414.36 ± 36.3% | 9492.88 ± 3.2% | 798.40 ± 2.1% | 0.93 | 0.99 | 5.06 | 1.01 |
| other: a word between two words | 13 | 973.48 ± 18.9% | 1010.12 ± 1.7% | 1554.34 ± 4.9% | 209.85 ± 7.5% | 761.14 ± 9.3% | 1535.25 ± 1.8% | 23307.97 ± 8.3% | 973.85 ± 1.9% | 0.96 | 1.00 | 4.64 | 1.28 |
| other: a number before a unit, second text | 15 | 686.15 ± 1.3% | 771.71 ± 1.9% | 1053.66 ± 1.1% | 56.27 ± 1.4% | 954.23 ± 1.5% | 1736.22 ± 0.8% | 22751.61 ± 1.7% | 687.19 ± 0.9% | 0.89 | 1.00 | 12.19 | 0.72 |
| other: a heading's start tag | 13 | 618.41 ± 3.3% | 629.02 ± 2.2% | 831.24 ± 2.2% | 58.45 ± 6.0% | 933.13 ± 2.0% | 1647.14 ± 1.4% | 29163.73 ± 10.7% | 618.78 ± 1.2% | 0.98 | 1.00 | 10.58 | 0.66 |
| other: a whole word | 11 | 1009.46 ± 1.8% | 1076.52 ± 1.7% | 1701.75 ± 2.5% | 189.79 ± 2.5% | 839.60 ± 9.5% | 1479.49 ± 2.6% | 43956.29 ± 0.9% | 1014.51 ± 0.7% | 0.94 | 1.00 | 5.32 | 1.20 |
| other: a line's first word, second text | 17 | 953.14 ± 1.0% | 1010.42 ± 2.8% | 1587.33 ± 0.9% | 197.88 ± 0.6% | 1053.36 ± 12.5% | refused | refused | 949.09 ± 1.6% | 0.94 | 1.00 | 4.82 | 0.90 |
| other: fourteen octets before an x | 16 | 178.51 ± 1.6% | 257.58 ± 6.9% | 295.96 ± 3.1% | 22.25 ± 1.1% | 693.63 ± 1.8% | 732.09 ± 0.8% | 20881.33 ± 2.1% | 179.65 ± 4.7% | 0.69 | 0.99 | 8.02 | 0.26 |
| other: a Greek word | 8 | 727.80 ± 2.7% | 969.12 ± 1.9% | 1505.65 ± 5.3% | 73.44 ± 3.4% | 2066.18 ± 11.3% | 3333.98 ± 1.0% | refused | 727.15 ± 1.9% | 0.75 | 1.00 | 9.91 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 33689.51 ± 3.6% | not timed | not timed | 43540.85 ± 2.6% | 3604.86 ± 21.7% | not timed | not timed | 33649.15 ± 1.9% | | 1.00 | 0.77 | 9.35 |
| 01-literal/sherlock-casei-en | 522 | 7023.46 ± 10.5% | not timed | not timed | 11367.12 ± 5.0% | 51.14 ± 4.4% | not timed | not timed | 6940.24 ± 3.4% | | 1.01 | 0.62 | 137.33 |
| 01-literal/sherlock-ru | 724 | 34890.41 ± 0.6% | not timed | not timed | 42499.65 ± 6.4% | 2351.00 ± 7.6% | not timed | not timed | 35095.38 ± 1.5% | | 0.99 | 0.82 | 14.84 |
| 01-literal/sherlock-casei-ru | 746 | 10996.54 ± 1.2% | not timed | not timed | 9123.22 ± 0.5% | 55.62 ± 8.2% | not timed | not timed | 11046.96 ± 5.1% | | 1.00 | 1.21 | 197.72 |
| 01-literal/sherlock-zh | 30 | 69293.90 ± 1.9% | not timed | not timed | 57533.95 ± 2.7% | 2066.21 ± 10.9% | not timed | not timed | 69000.68 ± 55.4% | | 1.00 | 1.20 | 33.54 |
| 02-literal-alternate/sherlock-en | 714 | 15636.56 ± 4.3% | not timed | not timed | 13482.19 ± 3.4% | 28.75 ± 10.4% | not timed | not timed | 15403.89 ± 5.2% | | 1.02 | 1.16 | 543.96 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2803.74 ± 2.4% | not timed | not timed | 2891.88 ± 0.7% | 17.95 ± 3.0% | not timed | not timed | 2741.19 ± 2.8% | | 1.02 | 0.97 | 156.23 |
| 02-literal-alternate/sherlock-ru | 899 | 9056.73 ± 3.6% | not timed | not timed | 7205.39 ± 5.2% | 37.63 ± 2.5% | not timed | not timed | 9033.92 ± 3.3% | | 1.00 | 1.26 | 240.71 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2544.81 ± 4.0% | not timed | not timed | 1427.64 ± 3.9% | 16.02 ± 1.6% | not timed | not timed | 2528.54 ± 0.8% | | 1.01 | 1.78 | 158.86 |
| 02-literal-alternate/sherlock-zh | 207 | 22807.37 ± 5.2% | not timed | not timed | 16017.46 ± 5.1% | 53.45 ± 22.9% | not timed | not timed | 22693.94 ± 4.4% | | 1.00 | 1.42 | 426.74 |
| 03-date/ascii | 111817 | 150.60 ± 2.3% | not timed | not timed | 124.59 ± 2.9% | 0.31 ± 9.8% | not timed | not timed | 151.87 ± 2.8% | | 0.99 | 1.21 | 480.07 |
| 04-ruff-noqa/real | 84 | 839.72 ± 6.6% | not timed | not timed | 674.57 ± 7.4% | 30.22 ± 6.9% | not timed | not timed | 845.48 ± 9.3% | | 0.99 | 1.24 | 27.78 |
| 04-ruff-noqa/tweaked | 44 | 755.54 ± 2.6% | not timed | not timed | 645.27 ± 1.8% | 449.82 ± 12.9% | not timed | not timed | 753.97 ± 2.1% | | 1.00 | 1.17 | 1.68 |
| 05-lexer-veryl/single | 124800 | 5.05 ± 5.9% | not timed | not timed | 7.07 ± 43.5% | 0.34 ± 11.0% | not timed | not timed | 5.08 ± 4.5% | | 0.99 | 0.71 | 15.04 |
| 06-cloud-flare-redos/original | 107 | 274.49 ± 5.4% | not timed | not timed | 270.58 ± 1.3% | 37.06 ± 1.2% | not timed | not timed | 275.30 ± 4.7% | | 1.00 | 1.01 | 7.41 |
| 06-cloud-flare-redos/simplified-short | 102 | 208.16 ± 3.5% | not timed | not timed | 287.44 ± 0.5% | 40.11 ± 3.0% | not timed | not timed | 206.80 ± 5.1% | | 1.01 | 0.72 | 5.19 |
| 06-cloud-flare-redos/simplified-long | 10000 | 230.23 ± 2.1% | not timed | not timed | 305.63 ± 1.8% | 43.31 ± 4.1% | not timed | not timed | 228.34 ± 2.9% | | 1.01 | 0.75 | 5.32 |
| 07-unicode-character-data/parse-line | 558784 | 65.20 ± 1.8% | not timed | not timed | 242.70 ± 0.8% | 62.44 ± 8.3% | not timed | not timed | 65.59 ± 2.0% | | 0.99 | 0.27 | 1.04 |
| 08-words/all-english | 56691 | 119.82 ± 56.7% | not timed | not timed | 103.72 ± 19.2% | 20.32 ± 21.2% | not timed | not timed | 119.54 ± 39.1% | | 1.00 | 1.16 | 5.90 |
| 08-words/long-english | 839 | 1110.39 ± 3.5% | not timed | not timed | 664.80 ± 1.1% | 47.20 ± 2.2% | not timed | not timed | 1103.54 ± 5.0% | | 1.01 | 1.67 | 23.52 |
| 09-aws-keys/full | 0 | 643.26 ± 2.1% | not timed | not timed | 683.08 ± 16.4% | 91.77 ± 2.3% | not timed | not timed | 641.39 ± 2.6% | | 1.00 | 0.94 | 7.01 |
| 09-aws-keys/quick | 0 | 661.82 ± 1.2% | not timed | not timed | 1159.78 ± 3.2% | 521.62 ± 1.7% | not timed | not timed | 663.43 ± 1.4% | | 1.00 | 0.57 | 1.27 |
| 10-bounded-repeat/letters-en | 1833 | 664.26 ± 4.3% | not timed | not timed | 689.82 ± 1.8% | 28.35 ± 0.9% | not timed | not timed | 660.04 ± 3.5% | | 1.01 | 0.96 | 23.43 |
| 10-bounded-repeat/letters-ru | 3475 | 399.53 ± 7.8% | not timed | not timed | 599.76 ± 4.3% | 28.73 ± 7.4% | not timed | not timed | 404.66 ± 7.3% | | 0.99 | 0.67 | 13.90 |
| 10-bounded-repeat/context | 53 | 94.67 ± 3.0% | not timed | not timed | 84.54 ± 2.9% | 27.64 ± 2.8% | not timed | not timed | 94.16 ± 1.8% | | 1.01 | 1.12 | 3.43 |
| 10-bounded-repeat/capitals | 11 | 1164.04 ± 2.5% | not timed | not timed | 677.33 ± 1.1% | 49.55 ± 1.5% | not timed | not timed | 1156.78 ± 4.8% | | 1.01 | 1.72 | 23.49 |
| 11-unstructured-to-json/extract | 600 | 34.14 ± 2.1% | not timed | not timed | 99.92 ± 5.4% | 71.38 ± 5.3% | not timed | not timed | 34.00 ± 2.2% | | 1.00 | 0.34 | 0.48 |
| 12-dictionary/single | 1 | 604.50 ± 1.9% | not timed | not timed | 587.45 ± 1.3% | 0.61 ± 2.6% | not timed | not timed | 612.16 ± 3.4% | | 0.99 | 1.03 | 985.82 |
| 14-quadratic/1x | 100 | 15.54 ± 0.2% | not timed | not timed | 16.10 ± 0.4% | 1.39 ± 5.7% | not timed | not timed | 15.40 ± 2.4% | | 1.01 | 0.97 | 11.14 |
| 14-quadratic/2x | 200 | 9.16 ± 2.5% | not timed | not timed | 7.58 ± 1.3% | 0.76 ± 1.2% | not timed | not timed | 9.13 ± 0.7% | | 1.00 | 1.21 | 12.00 |
| 14-quadratic/10x | 1000 | 2.04 ± 2.5% | not timed | not timed | 1.40 ± 1.3% | 0.17 ± 14.3% | not timed | not timed | 2.03 ± 31.6% | | 1.00 | 1.46 | 12.33 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.32 ± 9.8% | not timed | not timed | 0.51 ± 44.2% | 0.81 ± 4.5% | not timed | not timed | 2.32 ± 1.7% | | 1.00 | 4.55 | 2.86 |
| 04-ruff-noqa/compile-real | 1 | 150.46 ± 1.7% | not timed | not timed | 20.17 ± 11.1% | 218.38 ± 4.8% | not timed | not timed | 149.21 ± 5.6% | | 1.01 | 7.46 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 22.50 ± 1.0% | not timed | not timed | 3.71 ± 8.8% | 10.16 ± 4.4% | not timed | not timed | 22.60 ± 1.1% | | 1.00 | 6.07 | 2.21 |
| 07-unicode-character-data/compile | 1 | 89.15 ± 2.2% | not timed | not timed | 38.32 ± 4.6% | 58.74 ± 3.3% | not timed | not timed | 89.12 ± 13.3% | | 1.00 | 2.33 | 1.52 |
| 09-aws-keys/compile-full | 1 | 60.08 ± 2.9% | not timed | not timed | 11.70 ± 2.9% | 34.75 ± 4.0% | not timed | not timed | 59.45 ± 3.5% | | 1.01 | 5.13 | 1.73 |
| 09-aws-keys/compile-quick | 1 | 284.25 ± 4.0% | not timed | not timed | 71.92 ± 4.5% | 201.29 ± 30.2% | not timed | not timed | 286.30 ± 3.6% | | 0.99 | 3.95 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 22.14 ± 1.6% | not timed | not timed | 16.53 ± 0.8% | 25.31 ± 1.5% | not timed | not timed | 22.06 ± 1.0% | | 1.00 | 1.34 | 0.87 |
| 10-bounded-repeat/compile-capitals | 1 | 127.73 ± 1.8% | not timed | not timed | 12.01 ± 1.0% | 37.05 ± 2.9% | not timed | not timed | 127.27 ± 1.1% | | 1.00 | 10.64 | 3.45 |
| 11-unstructured-to-json/compile | 1 | 137.09 ± 1.8% | not timed | not timed | 61.03 ± 0.5% | 103.42 ± 33.1% | not timed | not timed | 136.28 ± 4.5% | | 1.01 | 2.25 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.44 ± 1.9% | not timed | not timed | 0.09 ± 1.1% | 0.13 ± 13.7% | not timed | not timed | 0.43 ± 2.4% | | 1.01 | 4.75 | 3.36 |

