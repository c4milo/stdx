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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148077778 |
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
| literal: a word | 217 | 50605.99 ± 5.3% | 1178.54 ± 2.2% | 43.80 ± 17.9% | 46288.35 ± 0.7% | 15499.83 ± 7.9% | 15.68 ± 3.0% | 142.84 ± 12.6% | 51177.44 ± 7.3% | 42.94 | 0.99 | 1.09 | 3.26 |
| literal: a word that is not there | 0 | 75754.13 ± 1.9% | 1193.46 ± 0.7% | 43.83 ± 1.7% | 61635.38 ± 6.6% | 52968.49 ± 2.9% | 15.25 ± 0.9% | 136.39 ± 5.2% | 76032.27 ± 1.4% | 63.47 | 1.00 | 1.23 | 1.43 |
| literal: one of four words | 661 | 18818.27 ± 2.5% | 1160.52 ± 1.1% | 24.31 ± 3.5% | 14039.92 ± 1.3% | 37.12 ± 4.1% | 4.97 ± 1.5% | 12.13 ± 9.5% | 18599.29 ± 2.7% | 16.22 | 1.01 | 1.34 | 506.96 |
| literal: a word in any case | 217 | 45638.98 ± 1.4% | 1181.00 ± 0.6% | 32.06 ± 1.5% | 13939.78 ± 1.3% | 70.46 ± 2.4% | refused | differs | 46266.02 ± 3.1% | 38.64 | 0.99 | 3.27 | 647.72 |
| literal: an href attribute | 33 | 45277.71 ± 2.2% | 1197.88 ± 0.7% | 37.43 ± 0.7% | 44417.73 ± 2.4% | 3493.04 ± 2.2% | 11.31 ± 1.0% | 124.32 ± 1.9% | 45365.25 ± 3.2% | 37.80 | 1.00 | 1.02 | 12.96 |
| literal: a word, second text | 123 | 51637.74 ± 3.7% | 1191.63 ± 0.9% | 42.63 ± 0.9% | 45056.36 ± 1.7% | 14753.26 ± 1.9% | 20.34 ± 0.8% | 120.82 ± 1.3% | 52523.26 ± 3.8% | 43.33 | 0.98 | 1.15 | 3.50 |
| class: two capitalized words | 1331 | 1089.96 ± 2.1% | 1105.05 ± 1.0% | 25.01 ± 4.0% | 667.25 ± 1.3% | 58.35 ± 3.8% | 13.46 ± 1.5% | 100.24 ± 3.5% | 1083.17 ± 2.0% | 0.99 | 1.01 | 1.63 | 18.68 |
| class: a word that ends in ing | 3399 | 1005.14 ± 0.4% | 1008.12 ± 5.8% | 26.42 ± 60.5% | 619.05 ± 7.5% | 43.71 ± 46.1% | 7.67 ± 0.7% | 27.42 ± 5.5% | 1003.54 ± 1.5% | 1.00 | 1.00 | 1.62 | 22.99 |
| class: a word in capitals | 2332 | 1520.29 ± 7.6% | 1065.49 ± 1.8% | 40.91 ± 1.3% | 643.80 ± 1.5% | 62.61 ± 16.1% | 15.86 ± 1.3% | 128.90 ± 1.1% | 1529.76 ± 3.3% | 1.43 | 0.99 | 2.36 | 24.28 |
| class: a number | 8288 | 2381.98 ± 5.9% | 924.76 ± 24.3% | 40.22 ± 13.8% | 2245.55 ± 1.5% | 60.54 ± 14.5% | 0.44 ± 0.9% | 90.77 ± 2.6% | 2395.46 ± 2.2% | 2.58 | 0.99 | 1.06 | 39.35 |
| class: two capitalized words, second text | 5359 | 826.95 ± 1.9% | 828.10 ± 2.6% | 35.11 ± 2.5% | 554.21 ± 5.7% | 45.87 ± 9.0% | 17.14 ± 1.8% | 92.43 ± 4.1% | 831.83 ± 2.0% | 1.00 | 0.99 | 1.49 | 18.03 |
| other: a word between two words | 6104 | 1018.72 ± 4.2% | 864.38 ± 1.8% | 33.54 ± 3.2% | 941.18 ± 2.5% | 165.74 ± 2.8% | 10.12 ± 0.6% | 106.05 ± 1.8% | 988.02 ± 1.5% | 1.18 | 1.03 | 1.08 | 6.15 |
| other: a number before a unit, second text | 1481 | 12186.85 ± 2.3% | 1121.93 ± 1.2% | 38.90 ± 1.2% | 10511.22 ± 2.2% | 58.16 ± 2.4% | 18.20 ± 2.0% | 99.40 ± 8.0% | 12236.85 ± 4.6% | 10.86 | 1.00 | 1.16 | 209.55 |
| other: a heading's start tag | 110 | 28785.44 ± 3.1% | 1178.27 ± 1.8% | 39.51 ± 1.8% | 3212.32 ± 0.9% | 2482.06 ± 7.0% | 13.93 ± 2.0% | 146.22 ± 3.1% | 28861.29 ± 3.1% | 24.43 | 1.00 | 8.96 | 11.60 |
| other: a whole word | 217 | 35725.95 ± 1.9% | 1181.20 ± 1.0% | 43.79 ± 1.6% | 35050.15 ± 2.3% | 72.83 ± 1.0% | 13.58 ± 2.0% | 80.21 ± 1.7% | 36200.18 ± 1.0% | 30.25 | 0.99 | 1.02 | 490.55 |
| other: a line's first word, second text | 3716 | 3236.63 ± 2.2% | 988.21 ± 0.7% | 46.45 ± 1.2% | 3415.39 ± 1.3% | 97.15 ± 5.7% | refused | refused | 3243.29 ± 1.6% | 3.28 | 1.00 | 0.95 | 33.31 |
| other: fourteen octets before an x | 87 | 43624.33 ± 14.3% | 331.42 ± 1.7% | 9.56 ± 6.1% | 4625.48 ± 1.6% | 13.96 ± 11.0% | differs | 20.83 ± 51.2% | 43442.35 ± 14.5% | 131.63 | 1.00 | 9.43 | 3125.36 |
| other: a Greek word | 21815 | 585.10 ± 1.2% | 462.44 ± 1.0% | 45.78 ± 1.7% | 352.01 ± 23.4% | 57.54 ± 1.8% | differs | refused | 582.77 ± 1.2% | 1.27 | 1.00 | 1.66 | 10.17 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 34.04 ± 3.1% | 33.64 ± 2.6% | 1.48 ± 19.5% | 23.59 ± 7.1% | 3.57 ± 3.0% | differs | 5.64 ± 3.9% | 34.20 ± 3.1% | 1.01 | 1.00 | 1.44 | 9.52 |
| a UUID | 32895 | 28.99 ± 2.5% | 29.50 ± 2.5% | 1.01 ± 3.5% | 18.08 ± 1.8% | 3.56 ± 2.3% | 0.73 ± 0.7% | 4.60 ± 8.6% | 29.33 ± 2.8% | 0.98 | 0.99 | 1.60 | 8.15 |
| an IPv4 address | 33176 | 47.57 ± 7.2% | 47.29 ± 6.9% | 3.24 ± 7.2% | 35.23 ± 5.6% | 9.20 ± 5.8% | differs | 5.89 ± 6.2% | 48.76 ± 6.5% | 1.01 | 0.98 | 1.35 | 5.17 |
| a date and time | 32954 | 44.68 ± 4.5% | 45.59 ± 4.4% | 2.57 ± 6.1% | 27.21 ± 2.6% | 11.41 ± 3.9% | 1.35 ± 5.3% | 11.19 ± 14.1% | 44.81 ± 4.7% | 0.98 | 1.00 | 1.64 | 3.91 |
| a field path | 32606 | 37.67 ± 3.6% | 38.30 ± 5.7% | 1.76 ± 6.9% | 28.44 ± 3.8% | 4.75 ± 2.4% | differs | 4.20 ± 4.2% | 38.41 ± 4.7% | 0.98 | 0.98 | 1.32 | 7.92 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 13.72 ± 3.7% | 13.45 ± 7.3% | 13.28 ± 6.5% | 17.70 ± 5.1% | 7.75 ± 3.5% | 1.10 ± 3.4% | none | 13.76 ± 4.4% | 1.02 | 1.00 | 0.78 | 1.77 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 381.11 ± 6.2% | 382.55 ± 5.0% | 439.04 ± 5.1% | 133.64 ± 7.7% | 326.01 ± 24.1% | 875.09 ± 4.5% | 5817.65 ± 10.2% | 375.26 ± 7.0% | 1.00 | 1.02 | 2.85 | 1.17 |
| a UUID | 62 | 243.05 ± 3.8% | 247.76 ± 5.3% | 260.21 ± 7.4% | 75.49 ± 8.2% | 157.40 ± 7.5% | 308.43 ± 7.7% | 6574.01 ± 9.3% | 238.02 ± 4.7% | 0.98 | 1.02 | 3.22 | 1.54 |
| an IPv4 address | 29 | 760.61 ± 7.5% | 770.20 ± 1.4% | 1040.25 ± 4.7% | 122.03 ± 4.0% | 210.66 ± 8.7% | 580.83 ± 1.4% | 12834.01 ± 2.0% | 754.04 ± 1.8% | 0.99 | 1.01 | 6.23 | 3.61 |
| a date and time | 56 | 544.64 ± 1.5% | 549.70 ± 2.5% | 676.50 ± 1.3% | 120.35 ± 1.9% | 227.44 ± 5.7% | 604.38 ± 4.8% | 8139.53 ± 7.8% | 543.62 ± 2.7% | 0.99 | 1.00 | 4.53 | 2.39 |
| a field path | 39 | 371.41 ± 64.2% | 377.46 ± 22.3% | 432.01 ± 3.1% | 129.15 ± 37.0% | 305.53 ± 31.4% | 927.18 ± 3.4% | 7656.06 ± 10.5% | 369.51 ± 30.8% | 0.98 | 1.01 | 2.88 | 1.22 |
| literal: a word | 7 | 1151.58 ± 2.7% | 1238.08 ± 4.5% | 2141.69 ± 4.1% | 861.50 ± 3.6% | 1031.07 ± 1.6% | 1797.16 ± 5.0% | 39389.58 ± 3.8% | 1145.23 ± 4.5% | 0.93 | 1.01 | 1.34 | 1.12 |
| literal: a word that is not there | 8 | 1109.14 ± 3.7% | 1172.88 ± 3.6% | 1979.51 ± 65.7% | 787.18 ± 12.9% | 1002.38 ± 14.4% | 1753.45 ± 4.5% | 39018.12 ± 5.1% | 1094.86 ± 6.1% | 0.95 | 1.01 | 1.41 | 1.11 |
| literal: one of four words | 26 | 428.46 ± 4.8% | 683.49 ± 5.3% | 888.28 ± 6.9% | 67.60 ± 7.1% | 381.42 ± 39.4% | 673.50 ± 10.6% | 24683.76 ± 65.7% | 425.08 ± 5.0% | 0.63 | 1.01 | 6.34 | 1.12 |
| literal: a word in any case | 11 | 873.72 ± 36.9% | 920.51 ± 13.4% | 1376.37 ± 3.6% | 22.97 ± 3.0% | 1062.76 ± 2.3% | refused | 36296.41 ± 1.4% | 880.86 ± 6.2% | 0.95 | 0.99 | 38.03 | 0.82 |
| literal: an href attribute | 12 | 612.79 ± 4.4% | 625.64 ± 3.0% | 806.69 ± 4.3% | 61.80 ± 9.7% | 757.49 ± 20.4% | 1525.42 ± 5.4% | 29877.62 ± 3.1% | 610.81 ± 4.0% | 0.98 | 1.00 | 9.92 | 0.81 |
| literal: a word, second text | 10 | 988.28 ± 8.0% | 1061.16 ± 11.7% | 1684.82 ± 8.0% | 690.96 ± 9.2% | 818.76 ± 18.2% | 1493.09 ± 6.3% | 38219.50 ± 6.9% | 972.94 ± 6.8% | 0.93 | 1.02 | 1.43 | 1.21 |
| class: two capitalized words | 23 | 793.06 ± 6.0% | 860.15 ± 6.4% | 1229.17 ± 3.9% | 161.11 ± 6.0% | 794.79 ± 7.2% | 1428.92 ± 6.7% | 9355.34 ± 6.3% | 799.08 ± 5.5% | 0.92 | 0.99 | 4.92 | 1.00 |
| class: a word that ends in ing | 9 | 995.33 ± 3.7% | 1126.49 ± 4.0% | 1842.01 ± 2.8% | 204.29 ± 3.8% | 1102.91 ± 2.5% | 2184.09 ± 7.6% | 24023.08 ± 1.5% | 975.39 ± 2.9% | 0.88 | 1.02 | 4.87 | 0.90 |
| class: a word in capitals | 16 | 881.21 ± 8.4% | 950.22 ± 2.8% | 1488.54 ± 8.2% | 207.47 ± 3.4% | 1187.95 ± 16.4% | 2016.16 ± 3.1% | 12291.01 ± 7.8% | 886.05 ± 2.0% | 0.93 | 0.99 | 4.25 | 0.74 |
| class: a number | 6 | 1091.36 ± 3.0% | 1204.40 ± 4.0% | 2179.25 ± 4.8% | 58.46 ± 2.1% | 2051.43 ± 14.0% | 3660.50 ± 1.5% | 31893.65 ± 2.3% | 1084.44 ± 4.1% | 0.91 | 1.01 | 18.67 | 0.53 |
| class: two capitalized words, second text | 23 | 822.22 ± 4.2% | 892.07 ± 4.3% | 1275.59 ± 5.2% | 162.89 ± 5.7% | 801.15 ± 6.3% | 1417.07 ± 5.5% | 9543.70 ± 6.3% | 819.33 ± 4.6% | 0.92 | 1.00 | 5.05 | 1.03 |
| other: a word between two words | 13 | 967.39 ± 1.3% | 1007.02 ± 2.6% | 1558.53 ± 5.1% | 211.37 ± 21.7% | 768.33 ± 49.5% | 1549.26 ± 1.1% | 22561.03 ± 0.5% | 970.97 ± 1.4% | 0.96 | 1.00 | 4.58 | 1.26 |
| other: a number before a unit, second text | 15 | 688.12 ± 3.3% | 762.97 ± 2.1% | 1040.51 ± 1.6% | 56.68 ± 2.7% | 964.80 ± 1.9% | 1694.87 ± 7.3% | 22582.30 ± 4.1% | 681.75 ± 24.9% | 0.90 | 1.01 | 12.14 | 0.71 |
| other: a heading's start tag | 13 | 618.25 ± 4.8% | 624.18 ± 2.3% | 804.20 ± 3.7% | 58.23 ± 1.1% | 925.50 ± 1.8% | 1625.59 ± 1.5% | 25421.70 ± 2.5% | 616.67 ± 4.8% | 0.99 | 1.00 | 10.62 | 0.67 |
| other: a whole word | 11 | 1005.49 ± 8.9% | 1055.85 ± 8.3% | 1691.46 ± 6.6% | 186.53 ± 21.4% | 890.51 ± 204.6% | 1596.83 ± 1.2% | 39689.61 ± 1.8% | 1006.00 ± 3.1% | 0.95 | 1.00 | 5.39 | 1.13 |
| other: a line's first word, second text | 17 | 953.47 ± 2.9% | 1003.94 ± 3.1% | 1570.17 ± 2.2% | 198.18 ± 5.0% | 1048.71 ± 11.3% | refused | refused | 946.75 ± 2.1% | 0.95 | 1.01 | 4.81 | 0.91 |
| other: fourteen octets before an x | 16 | 179.27 ± 5.2% | 255.19 ± 2.6% | 289.38 ± 1.3% | 22.19 ± 4.4% | 675.47 ± 7.7% | 731.13 ± 6.0% | 19409.39 ± 7.6% | 176.80 ± 6.8% | 0.70 | 1.01 | 8.08 | 0.27 |
| other: a Greek word | 8 | 721.44 ± 5.2% | 952.27 ± 2.8% | 1464.06 ± 2.9% | 74.07 ± 3.9% | 2046.00 ± 17.8% | 3395.94 ± 3.8% | refused | 714.86 ± 4.2% | 0.76 | 1.01 | 9.74 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 35463.56 ± 3.3% | not timed | not timed | 44407.50 ± 4.5% | 3832.37 ± 20.1% | not timed | not timed | 35432.24 ± 9.9% | | 1.00 | 0.80 | 9.25 |
| 01-literal/sherlock-casei-en | 522 | 10783.15 ± 9.3% | not timed | not timed | 11278.34 ± 12.0% | 52.02 ± 7.4% | not timed | not timed | 10723.61 ± 64.6% | | 1.01 | 0.96 | 207.30 |
| 01-literal/sherlock-ru | 724 | 35982.26 ± 5.9% | not timed | not timed | 42451.55 ± 14.0% | 2425.61 ± 3.3% | not timed | not timed | 36199.90 ± 10.7% | | 0.99 | 0.85 | 14.83 |
| 01-literal/sherlock-casei-ru | 746 | 11513.38 ± 2.6% | not timed | not timed | 9642.32 ± 10.2% | 59.06 ± 2.0% | not timed | not timed | 11548.13 ± 2.5% | | 1.00 | 1.19 | 194.94 |
| 01-literal/sherlock-zh | 30 | 71222.30 ± 5.9% | not timed | not timed | 58745.50 ± 6.7% | 2174.20 ± 1.7% | not timed | not timed | 71414.11 ± 5.3% | | 1.00 | 1.21 | 32.76 |
| 02-literal-alternate/sherlock-en | 714 | 16520.60 ± 4.9% | not timed | not timed | 13924.21 ± 2.8% | 29.84 ± 4.9% | not timed | not timed | 16634.98 ± 4.8% | | 0.99 | 1.19 | 553.67 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2837.20 ± 5.9% | not timed | not timed | 3024.61 ± 2.0% | 17.98 ± 8.4% | not timed | not timed | 2745.91 ± 1.3% | | 1.03 | 0.94 | 157.80 |
| 02-literal-alternate/sherlock-ru | 899 | 9372.83 ± 4.9% | not timed | not timed | 7594.69 ± 4.0% | 38.07 ± 2.5% | not timed | not timed | 9148.65 ± 3.0% | | 1.02 | 1.23 | 246.22 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2587.82 ± 5.5% | not timed | not timed | 1483.77 ± 3.9% | 16.11 ± 5.1% | not timed | not timed | 2570.61 ± 3.2% | | 1.01 | 1.74 | 160.65 |
| 02-literal-alternate/sherlock-zh | 207 | 23217.71 ± 3.1% | not timed | not timed | 15956.75 ± 6.4% | 52.68 ± 31.9% | not timed | not timed | 23236.61 ± 5.5% | | 1.00 | 1.46 | 440.76 |
| 03-date/ascii | 111817 | 153.68 ± 14.2% | not timed | not timed | 125.92 ± 60.4% | 0.31 ± 9.9% | not timed | not timed | 156.34 ± 5.6% | | 0.98 | 1.22 | 501.44 |
| 04-ruff-noqa/real | 84 | 854.41 ± 95.2% | not timed | not timed | 684.77 ± 6.9% | 31.24 ± 1.7% | not timed | not timed | 867.37 ± 3.9% | | 0.99 | 1.25 | 27.35 |
| 04-ruff-noqa/tweaked | 44 | 798.65 ± 8.3% | not timed | not timed | 709.50 ± 6.0% | 486.86 ± 4.0% | not timed | not timed | 790.04 ± 3.3% | | 1.01 | 1.13 | 1.64 |
| 05-lexer-veryl/single | 124800 | 6.23 ± 5.8% | not timed | not timed | 7.80 ± 4.9% | 0.35 ± 6.7% | not timed | not timed | 6.10 ± 6.5% | | 1.02 | 0.80 | 17.59 |
| 06-cloud-flare-redos/original | 107 | 326.29 ± 4.3% | not timed | not timed | 284.68 ± 30.2% | 38.53 ± 39.7% | not timed | not timed | 330.68 ± 4.9% | | 0.99 | 1.15 | 8.47 |
| 06-cloud-flare-redos/simplified-short | 102 | 320.74 ± 2.5% | not timed | not timed | 299.08 ± 2.1% | 41.85 ± 0.7% | not timed | not timed | 319.63 ± 1.6% | | 1.00 | 1.07 | 7.66 |
| 06-cloud-flare-redos/simplified-long | 10000 | 331.95 ± 2.0% | not timed | not timed | 325.59 ± 2.9% | 46.66 ± 4.0% | not timed | not timed | 335.86 ± 10.5% | | 0.99 | 1.02 | 7.11 |
| 07-unicode-character-data/parse-line | 558784 | 323.43 ± 4.7% | not timed | not timed | 252.72 ± 4.1% | 68.02 ± 9.6% | not timed | not timed | 323.86 ± 5.3% | | 1.00 | 1.28 | 4.75 |
| 08-words/all-english | 56691 | 139.15 ± 4.2% | not timed | not timed | 111.75 ± 6.0% | 21.63 ± 10.2% | not timed | not timed | 137.49 ± 5.7% | | 1.01 | 1.25 | 6.43 |
| 08-words/long-english | 839 | 1157.28 ± 3.4% | not timed | not timed | 691.18 ± 3.9% | 49.41 ± 28.2% | not timed | not timed | 1157.89 ± 0.9% | | 1.00 | 1.67 | 23.42 |
| 09-aws-keys/full | 0 | 678.80 ± 11.5% | not timed | not timed | 737.85 ± 5.4% | 98.17 ± 5.0% | not timed | not timed | 680.09 ± 22.8% | | 1.00 | 0.92 | 6.91 |
| 09-aws-keys/quick | 0 | 1367.06 ± 3.3% | not timed | not timed | 1280.16 ± 2.7% | 562.61 ± 9.1% | not timed | not timed | 1376.23 ± 5.4% | | 0.99 | 1.07 | 2.43 |
| 10-bounded-repeat/letters-en | 1833 | 773.49 ± 4.4% | not timed | not timed | 752.89 ± 4.4% | 30.89 ± 3.1% | not timed | not timed | 782.93 ± 10.8% | | 0.99 | 1.03 | 25.04 |
| 10-bounded-repeat/letters-ru | 3475 | 463.76 ± 4.3% | not timed | not timed | 652.45 ± 4.0% | 31.29 ± 13.9% | not timed | not timed | 452.75 ± 3.6% | | 1.02 | 0.71 | 14.82 |
| 10-bounded-repeat/context | 53 | 112.26 ± 5.4% | not timed | not timed | 91.29 ± 12.0% | 29.20 ± 15.7% | not timed | not timed | 111.76 ± 1.8% | | 1.00 | 1.23 | 3.84 |
| 10-bounded-repeat/capitals | 11 | 1232.10 ± 4.4% | not timed | not timed | 715.03 ± 4.8% | 51.95 ± 11.6% | not timed | not timed | 1224.60 ± 7.3% | | 1.01 | 1.72 | 23.72 |
| 11-unstructured-to-json/extract | 600 | 63.24 ± 4.9% | not timed | not timed | 103.75 ± 5.6% | 74.75 ± 6.0% | not timed | not timed | 62.24 ± 8.2% | | 1.02 | 0.61 | 0.85 |
| 12-dictionary/single | 1 | 658.49 ± 4.7% | not timed | not timed | 628.46 ± 44.1% | 0.65 ± 21.7% | not timed | not timed | 666.89 ± 4.8% | | 0.99 | 1.05 | 1010.48 |
| 14-quadratic/1x | 100 | 11.80 ± 4.0% | not timed | not timed | 17.62 ± 1.4% | 1.44 ± 4.1% | not timed | not timed | 11.19 ± 5.4% | | 1.06 | 0.67 | 8.20 |
| 14-quadratic/2x | 200 | 6.50 ± 4.0% | not timed | not timed | 8.01 ± 4.0% | 0.79 ± 22.2% | not timed | not timed | 6.29 ± 5.2% | | 1.03 | 0.81 | 8.28 |
| 14-quadratic/10x | 1000 | 1.43 ± 3.9% | not timed | not timed | 1.48 ± 6.8% | 0.17 ± 6.8% | not timed | not timed | 1.41 ± 4.3% | | 1.01 | 0.97 | 8.37 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.42 ± 3.7% | not timed | not timed | 0.54 ± 5.6% | 0.84 ± 6.2% | not timed | not timed | 2.42 ± 2.1% | | 1.00 | 4.50 | 2.89 |
| 04-ruff-noqa/compile-real | 1 | 158.85 ± 13.2% | not timed | not timed | 21.44 ± 5.3% | 211.59 ± 13.4% | not timed | not timed | 156.46 ± 3.5% | | 1.02 | 7.41 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 23.30 ± 4.9% | not timed | not timed | 3.90 ± 6.8% | 9.81 ± 10.9% | not timed | not timed | 23.07 ± 4.4% | | 1.01 | 5.97 | 2.38 |
| 07-unicode-character-data/compile | 1 | 90.08 ± 0.6% | not timed | not timed | 39.72 ± 4.9% | 57.33 ± 6.5% | not timed | not timed | 90.40 ± 1.4% | | 1.00 | 2.27 | 1.57 |
| 09-aws-keys/compile-full | 1 | 61.58 ± 5.2% | not timed | not timed | 12.36 ± 5.4% | 35.33 ± 11.9% | not timed | not timed | 61.51 ± 5.6% | | 1.00 | 4.98 | 1.74 |
| 09-aws-keys/compile-quick | 1 | 296.68 ± 6.6% | not timed | not timed | 77.07 ± 6.4% | 206.71 ± 109.1% | not timed | not timed | 294.34 ± 3.3% | | 1.01 | 3.85 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 22.46 ± 2.1% | not timed | not timed | 17.21 ± 3.2% | 26.28 ± 2.1% | not timed | not timed | 22.37 ± 1.3% | | 1.00 | 1.30 | 0.85 |
| 10-bounded-repeat/compile-capitals | 1 | 130.91 ± 4.8% | not timed | not timed | 12.75 ± 3.8% | 39.33 ± 5.1% | not timed | not timed | 128.71 ± 6.0% | | 1.02 | 10.27 | 3.33 |
| 11-unstructured-to-json/compile | 1 | 137.03 ± 4.6% | not timed | not timed | 61.05 ± 2.4% | 105.87 ± 10.2% | not timed | not timed | 135.90 ± 6.1% | | 1.01 | 2.24 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.45 ± 8.7% | not timed | not timed | 0.09 ± 54.5% | 0.12 ± 50.6% | not timed | not timed | 0.45 ± 2.8% | | 1.00 | 4.98 | 3.62 |

