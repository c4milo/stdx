# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117684414 |
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
| literal: a word | 217 | 55155.57 ± 4.0% | 1242.98 ± 3.8% | 45.25 ± 4.0% | 53963.99 ± 2.8% | 16067.52 ± 28.3% | 15.82 ± 32.7% | 156.13 ± 2.9% | 55283.03 ± 3.1% | 44.37 | 1.00 | 1.02 | 3.43 |
| literal: a word that is not there | 0 | 79101.28 ± 4.2% | 1244.06 ± 2.4% | 43.85 ± 3.7% | 63012.96 ± 6.8% | 56369.34 ± 2.0% | 15.35 ± 3.7% | 141.29 ± 5.3% | 78904.81 ± 4.1% | 63.58 | 1.00 | 1.26 | 1.40 |
| literal: one of four words | 661 | 19957.82 ± 4.9% | 1219.35 ± 4.8% | 25.13 ± 6.3% | 14447.33 ± 16.2% | 38.06 ± 9.4% | 5.22 ± 3.4% | 12.44 ± 9.3% | 19556.44 ± 3.8% | 16.37 | 1.02 | 1.38 | 524.43 |
| literal: a word in any case | 217 | 50001.00 ± 2.2% | 1239.94 ± 2.2% | 33.82 ± 3.8% | 14837.73 ± 2.8% | 74.68 ± 3.7% | refused | differs | 52006.89 ± 5.6% | 40.33 | 0.96 | 3.37 | 669.54 |
| literal: an href attribute | 33 | 48144.09 ± 3.1% | 1244.91 ± 3.5% | 37.70 ± 5.6% | 46108.52 ± 4.6% | 3644.91 ± 16.9% | 12.03 ± 6.6% | 132.12 ± 6.2% | 46950.86 ± 4.1% | 38.67 | 1.03 | 1.04 | 13.21 |
| literal: a word, second text | 123 | 53498.61 ± 3.3% | 1243.56 ± 3.1% | 42.65 ± 2.8% | 48688.62 ± 1.5% | 14475.06 ± 3.7% | 20.96 ± 1.4% | 122.36 ± 6.0% | 52769.95 ± 2.0% | 43.02 | 1.01 | 1.10 | 3.70 |
| class: two capitalized words | 1331 | 1110.43 ± 6.3% | 1122.06 ± 4.9% | 41.01 ± 4.8% | 702.66 ± 6.0% | 61.45 ± 11.1% | 14.39 ± 2.9% | 105.44 ± 3.9% | 1124.14 ± 4.7% | 0.99 | 0.99 | 1.58 | 18.07 |
| class: a word that ends in ing | 3399 | 1064.57 ± 10.3% | 1071.65 ± 2.0% | 27.84 ± 5.7% | 654.13 ± 3.2% | 46.64 ± 4.2% | 8.04 ± 8.6% | 29.35 ± 53.9% | 1052.48 ± 5.8% | 0.99 | 1.01 | 1.63 | 22.83 |
| class: a word in capitals | 2332 | 1633.51 ± 4.8% | 1126.72 ± 0.8% | 43.49 ± 37.9% | 689.60 ± 31.0% | 66.88 ± 20.2% | 17.06 ± 3.9% | 138.53 ± 2.3% | 1615.65 ± 6.9% | 1.45 | 1.01 | 2.37 | 24.43 |
| class: a number | 8288 | 2564.21 ± 4.8% | 934.32 ± 4.7% | 42.70 ± 7.8% | 2345.59 ± 5.8% | 65.82 ± 23.2% | 0.46 ± 1.4% | 96.92 ± 6.5% | 2591.34 ± 5.0% | 2.74 | 0.99 | 1.09 | 38.96 |
| class: two capitalized words, second text | 5359 | 854.83 ± 7.0% | 822.00 ± 9.6% | 37.00 ± 26.7% | 590.92 ± 3.9% | 51.76 ± 13.3% | 17.86 ± 6.0% | 96.21 ± 7.4% | 836.51 ± 5.7% | 1.04 | 1.02 | 1.45 | 16.51 |
| other: a word between two words | 6104 | 1010.65 ± 42.1% | 887.68 ± 4.3% | 35.92 ± 66.9% | 973.88 ± 29.1% | 165.16 ± 106.3% | 10.24 ± 22.2% | 109.82 ± 183.8% | 1005.86 ± 77.9% | 1.14 | 1.00 | 1.04 | 6.12 |
| other: a number before a unit, second text | 1481 | 11992.71 ± 3.7% | 1166.36 ± 5.3% | 40.59 ± 4.5% | 10859.20 ± 6.6% | 60.49 ± 1.4% | 19.71 ± 6.1% | 108.85 ± 11.1% | 12000.87 ± 3.4% | 10.28 | 1.00 | 1.10 | 198.25 |
| other: a heading's start tag | 110 | 30955.04 ± 5.9% | 1228.99 ± 15.1% | 41.20 ± 24.5% | 3411.09 ± 2.0% | 2606.67 ± 7.6% | 14.21 ± 3.7% | 155.25 ± 6.0% | 30380.32 ± 7.6% | 25.19 | 1.02 | 9.07 | 11.88 |
| other: a whole word | 217 | 38111.77 ± 4.7% | 1264.99 ± 3.3% | 47.18 ± 2.5% | 37107.30 ± 4.4% | 76.36 ± 4.5% | 13.43 ± 3.3% | 83.57 ± 1.9% | 37807.95 ± 3.6% | 30.13 | 1.01 | 1.03 | 499.09 |
| other: a line's first word, second text | 3716 | 2989.87 ± 5.0% | 1032.46 ± 2.9% | 48.55 ± 3.1% | 3506.05 ± 4.4% | 99.59 ± 11.6% | refused | refused | 2907.20 ± 8.2% | 2.90 | 1.03 | 0.85 | 30.02 |
| other: fourteen octets before an x | 87 | 45560.21 ± 4.3% | 337.07 ± 5.2% | 8.86 ± 2.3% | 4904.53 ± 4.4% | 13.97 ± 21.7% | differs | 25.05 ± 64.6% | 45222.44 ± 6.2% | 135.17 | 1.01 | 9.29 | 3262.28 |
| other: a Greek word | 21815 | 612.37 ± 2.1% | 408.18 ± 5.7% | 46.95 ± 2.7% | 352.38 ± 1.6% | 59.75 ± 8.6% | differs | refused | 606.39 ± 2.6% | 1.50 | 1.01 | 1.74 | 10.25 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 35.83 ± 5.3% | 35.83 ± 6.7% | 1.43 ± 4.9% | 24.78 ± 5.5% | 3.33 ± 9.2% | differs | 5.82 ± 6.4% | 36.37 ± 4.3% | 1.00 | 0.99 | 1.45 | 10.76 |
| a UUID | 32895 | 31.40 ± 3.3% | 30.73 ± 5.0% | 1.06 ± 6.4% | 18.46 ± 4.1% | 3.60 ± 4.1% | 0.76 ± 2.9% | 4.67 ± 33.3% | 30.72 ± 1.0% | 1.02 | 1.02 | 1.70 | 8.71 |
| an IPv4 address | 33176 | 48.74 ± 7.1% | 47.32 ± 6.0% | 3.39 ± 7.3% | 35.07 ± 6.0% | 9.11 ± 4.9% | differs | 6.06 ± 6.4% | 49.19 ± 4.9% | 1.03 | 0.99 | 1.39 | 5.35 |
| a date and time | 32954 | 45.95 ± 25.5% | 46.30 ± 4.1% | 2.57 ± 3.8% | 27.01 ± 1.4% | 11.14 ± 4.0% | 1.35 ± 3.4% | 10.93 ± 12.9% | 46.83 ± 37.2% | 0.99 | 0.98 | 1.70 | 4.13 |
| a field path | 32606 | 39.22 ± 3.6% | 38.40 ± 3.5% | 1.79 ± 6.2% | 28.67 ± 4.6% | 4.91 ± 5.2% | differs | 4.27 ± 2.0% | 39.37 ± 1.2% | 1.02 | 1.00 | 1.37 | 8.00 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.18 ± 1.4% | 15.13 ± 7.5% | 14.84 ± 5.8% | 18.11 ± 42.0% | 7.69 ± 1.3% | 1.10 ± 19.3% | none | 15.25 ± 4.7% | 1.00 | 1.00 | 0.84 | 1.97 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 372.88 ± 6.4% | 371.51 ± 5.6% | 437.56 ± 5.1% | 135.51 ± 6.3% | 327.02 ± 7.3% | 882.67 ± 14.5% | 5710.43 ± 44.2% | 375.76 ± 2.8% | 1.00 | 0.99 | 2.75 | 1.14 |
| a UUID | 62 | 241.51 ± 60.4% | 245.48 ± 47.6% | 270.82 ± 52.5% | 77.02 ± 5.5% | 161.66 ± 9.2% | 317.68 ± 3.3% | 7405.90 ± 21.1% | 240.71 ± 71.1% | 0.98 | 1.00 | 3.14 | 1.49 |
| an IPv4 address | 29 | 754.63 ± 4.9% | 766.29 ± 5.1% | 1071.87 ± 5.5% | 127.00 ± 4.7% | 215.49 ± 1.2% | 569.99 ± 4.3% | 13406.79 ± 9.4% | 752.23 ± 3.4% | 0.98 | 1.00 | 5.94 | 3.50 |
| a date and time | 56 | 547.49 ± 11.9% | 554.12 ± 2.1% | 676.74 ± 8.6% | 117.37 ± 9.1% | 230.15 ± 8.5% | 591.32 ± 6.2% | 7953.70 ± 6.8% | 550.55 ± 6.0% | 0.99 | 0.99 | 4.66 | 2.38 |
| a field path | 39 | 386.73 ± 4.2% | 384.26 ± 5.2% | 447.77 ± 11.0% | 130.44 ± 37.3% | 323.64 ± 22.8% | 938.83 ± 1.1% | 7496.50 ± 5.3% | 385.44 ± 8.2% | 1.01 | 1.00 | 2.96 | 1.19 |
| literal: a word | 7 | 1190.32 ± 4.4% | 1248.77 ± 5.4% | 2243.61 ± 3.8% | 884.70 ± 5.0% | 1054.76 ± 5.4% | 1833.50 ± 5.2% | 48996.52 ± 6.9% | 1202.33 ± 5.3% | 0.95 | 0.99 | 1.35 | 1.13 |
| literal: a word that is not there | 8 | 1165.35 ± 2.7% | 1261.38 ± 2.7% | 2110.91 ± 3.6% | 838.77 ± 2.2% | 1022.29 ± 2.5% | 1815.93 ± 9.6% | 49493.18 ± 2.4% | 1168.06 ± 4.9% | 0.92 | 1.00 | 1.39 | 1.14 |
| literal: one of four words | 26 | 453.49 ± 6.9% | 711.04 ± 2.6% | 908.99 ± 8.0% | 69.46 ± 4.0% | 390.54 ± 10.5% | 684.69 ± 60.1% | 24952.08 ± 31.6% | 452.30 ± 3.5% | 0.64 | 1.00 | 6.53 | 1.16 |
| literal: a word in any case | 11 | 905.85 ± 4.4% | 988.37 ± 4.1% | 1478.89 ± 4.3% | 24.09 ± 1.0% | 1128.93 ± 3.4% | refused | 39313.74 ± 2.3% | 920.71 ± 4.1% | 0.92 | 0.98 | 37.60 | 0.80 |
| literal: an href attribute | 12 | 619.96 ± 6.2% | 652.54 ± 5.2% | 852.51 ± 2.2% | 63.75 ± 5.3% | 785.76 ± 38.2% | 1549.38 ± 4.0% | 35027.02 ± 3.6% | 615.60 ± 6.2% | 0.95 | 1.01 | 9.72 | 0.79 |
| literal: a word, second text | 10 | 1035.41 ± 5.0% | 1136.90 ± 6.5% | 1865.93 ± 4.3% | 732.95 ± 2.8% | 866.96 ± 3.8% | 1610.88 ± 3.8% | 46943.38 ± 3.2% | 1055.13 ± 1.9% | 0.91 | 0.98 | 1.41 | 1.19 |
| class: two capitalized words | 23 | 861.33 ± 4.3% | 917.91 ± 6.1% | 1316.29 ± 2.3% | 167.47 ± 1.1% | 844.86 ± 1.1% | 1501.13 ± 3.2% | 10082.80 ± 6.1% | 850.98 ± 4.8% | 0.94 | 1.01 | 5.14 | 1.02 |
| class: a word that ends in ing | 9 | 1067.95 ± 4.8% | 1195.57 ± 4.9% | 2034.35 ± 7.0% | 212.98 ± 5.6% | 1155.57 ± 5.5% | 2293.17 ± 3.6% | 25522.88 ± 5.5% | 1067.82 ± 1.5% | 0.89 | 1.00 | 5.01 | 0.92 |
| class: a word in capitals | 16 | 952.17 ± 1.4% | 1026.82 ± 1.1% | 1606.11 ± 2.6% | 217.06 ± 1.6% | 1233.49 ± 15.2% | 2110.87 ± 1.5% | 13141.56 ± 0.4% | 955.46 ± 0.2% | 0.93 | 1.00 | 4.39 | 0.77 |
| class: a number | 6 | 1151.64 ± 3.2% | 1262.31 ± 5.7% | 2249.91 ± 3.8% | 60.99 ± 5.9% | 2237.83 ± 2.4% | 3716.00 ± 2.5% | 38193.81 ± 2.3% | 1149.18 ± 3.0% | 0.91 | 1.00 | 18.88 | 0.51 |
| class: two capitalized words, second text | 23 | 837.41 ± 4.7% | 918.77 ± 2.0% | 1322.19 ± 1.8% | 164.00 ± 4.3% | 813.52 ± 35.1% | 1469.28 ± 34.8% | 10123.12 ± 1.4% | 852.42 ± 1.6% | 0.91 | 0.98 | 5.11 | 1.03 |
| other: a word between two words | 13 | 1015.65 ± 4.1% | 1056.62 ± 5.2% | 1653.68 ± 4.2% | 219.93 ± 3.7% | 785.99 ± 9.5% | 1609.89 ± 3.0% | 24005.49 ± 3.9% | 1029.89 ± 3.4% | 0.96 | 0.99 | 4.62 | 1.29 |
| other: a number before a unit, second text | 15 | 720.16 ± 3.4% | 796.98 ± 4.0% | 1112.17 ± 4.2% | 58.10 ± 5.3% | 976.99 ± 3.9% | 1811.40 ± 4.5% | 25110.65 ± 8.2% | 718.65 ± 3.8% | 0.90 | 1.00 | 12.40 | 0.74 |
| other: a heading's start tag | 13 | 654.61 ± 4.7% | 664.61 ± 3.9% | 854.75 ± 6.5% | 61.32 ± 1.7% | 966.64 ± 5.6% | 1678.44 ± 10.0% | 29362.63 ± 57.3% | 653.42 ± 5.1% | 0.98 | 1.00 | 10.67 | 0.68 |
| other: a whole word | 11 | 1045.10 ± 6.3% | 1120.95 ± 5.8% | 1796.83 ± 5.1% | 195.86 ± 1.9% | 936.72 ± 1.6% | 1651.39 ± 2.4% | 44674.75 ± 2.4% | 1052.11 ± 2.0% | 0.93 | 0.99 | 5.34 | 1.12 |
| other: a line's first word, second text | 17 | 1029.42 ± 2.1% | 1059.31 ± 3.1% | 1716.66 ± 3.7% | 212.49 ± 0.6% | 1087.03 ± 25.7% | refused | refused | 1018.37 ± 5.9% | 0.97 | 1.01 | 4.84 | 0.95 |
| other: fourteen octets before an x | 16 | 193.96 ± 3.6% | 275.81 ± 4.4% | 317.55 ± 4.9% | 23.62 ± 4.1% | 722.13 ± 4.2% | 769.23 ± 3.7% | 21612.02 ± 3.7% | 193.41 ± 5.4% | 0.70 | 1.00 | 8.21 | 0.27 |
| other: a Greek word | 8 | 768.73 ± 53.1% | 1024.94 ± 29.8% | 1591.46 ± 6.0% | 77.10 ± 3.5% | 2165.29 ± 15.4% | 3582.37 ± 4.9% | refused | 772.33 ± 5.3% | 0.75 | 1.00 | 9.97 | 0.36 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 36485.81 ± 1.5% | not timed | not timed | 46741.36 ± 3.0% | 3771.00 ± 13.6% | not timed | not timed | 35983.24 ± 4.3% | | 1.01 | 0.78 | 9.68 |
| 01-literal/sherlock-casei-en | 522 | 7697.97 ± 3.6% | not timed | not timed | 12034.56 ± 2.9% | 53.63 ± 5.9% | not timed | not timed | 7782.50 ± 7.9% | | 0.99 | 0.64 | 143.54 |
| 01-literal/sherlock-ru | 724 | 37304.38 ± 2.9% | not timed | not timed | 45988.52 ± 8.7% | 2408.48 ± 6.7% | not timed | not timed | 36933.60 ± 21.8% | | 1.01 | 0.81 | 15.49 |
| 01-literal/sherlock-casei-ru | 746 | 11710.40 ± 2.5% | not timed | not timed | 9505.97 ± 4.7% | 58.29 ± 3.4% | not timed | not timed | 11733.50 ± 5.3% | | 1.00 | 1.23 | 200.90 |
| 01-literal/sherlock-zh | 30 | 73957.51 ± 6.0% | not timed | not timed | 59929.03 ± 2.5% | 2172.19 ± 2.4% | not timed | not timed | 74368.63 ± 5.9% | | 0.99 | 1.23 | 34.05 |
| 02-literal-alternate/sherlock-en | 714 | 16779.62 ± 1.3% | not timed | not timed | 14042.97 ± 0.4% | 30.61 ± 0.4% | not timed | not timed | 16828.69 ± 1.0% | | 1.00 | 1.19 | 548.14 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3003.95 ± 2.8% | not timed | not timed | 3039.06 ± 2.5% | 19.06 ± 2.5% | not timed | not timed | 2934.77 ± 1.8% | | 1.02 | 0.99 | 157.58 |
| 02-literal-alternate/sherlock-ru | 899 | 9672.81 ± 6.5% | not timed | not timed | 7704.79 ± 4.3% | 39.49 ± 1.0% | not timed | not timed | 9708.48 ± 0.8% | | 1.00 | 1.26 | 244.93 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2667.68 ± 1.3% | not timed | not timed | 1490.43 ± 0.4% | 16.55 ± 0.9% | not timed | not timed | 2640.92 ± 0.8% | | 1.01 | 1.79 | 161.20 |
| 02-literal-alternate/sherlock-zh | 207 | 24183.57 ± 44.6% | not timed | not timed | 16481.85 ± 4.3% | 56.18 ± 4.2% | not timed | not timed | 24097.01 ± 7.1% | | 1.00 | 1.47 | 430.46 |
| 03-date/ascii | 111817 | 160.78 ± 4.9% | not timed | not timed | 127.57 ± 4.1% | 0.32 ± 6.9% | not timed | not timed | 158.75 ± 17.4% | | 1.01 | 1.26 | 503.19 |
| 04-ruff-noqa/real | 84 | 878.15 ± 3.2% | not timed | not timed | 709.14 ± 3.3% | 32.35 ± 1.8% | not timed | not timed | 896.16 ± 1.4% | | 0.98 | 1.24 | 27.15 |
| 04-ruff-noqa/tweaked | 44 | 832.23 ± 7.7% | not timed | not timed | 720.32 ± 5.0% | 501.55 ± 3.0% | not timed | not timed | 830.03 ± 0.7% | | 1.00 | 1.16 | 1.66 |
| 05-lexer-veryl/single | 124800 | 5.83 ± 2.4% | not timed | not timed | 8.05 ± 1.5% | 0.36 ± 7.4% | not timed | not timed | 5.80 ± 3.6% | | 1.01 | 0.72 | 16.21 |
| 06-cloud-flare-redos/original | 107 | 296.10 ± 3.3% | not timed | not timed | 298.44 ± 2.4% | 40.68 ± 2.5% | not timed | not timed | 293.47 ± 5.0% | | 1.01 | 0.99 | 7.28 |
| 06-cloud-flare-redos/simplified-short | 102 | 223.21 ± 11.2% | not timed | not timed | 310.89 ± 4.1% | 43.95 ± 2.7% | not timed | not timed | 214.75 ± 1.9% | | 1.04 | 0.72 | 5.08 |
| 06-cloud-flare-redos/simplified-long | 10000 | 249.72 ± 2.6% | not timed | not timed | 332.37 ± 5.6% | 47.70 ± 5.2% | not timed | not timed | 236.59 ± 3.1% | | 1.06 | 0.75 | 5.23 |
| 07-unicode-character-data/parse-line | 558784 | 347.71 ± 7.5% | not timed | not timed | 262.72 ± 4.1% | 68.44 ± 4.9% | not timed | not timed | 341.36 ± 5.8% | | 1.02 | 1.32 | 5.08 |
| 08-words/all-english | 56691 | 130.43 ± 2.0% | not timed | not timed | 103.64 ± 2.1% | 22.78 ± 13.6% | not timed | not timed | 128.63 ± 2.9% | | 1.01 | 1.26 | 5.73 |
| 08-words/long-english | 839 | 1215.83 ± 4.8% | not timed | not timed | 726.43 ± 3.4% | 51.74 ± 0.8% | not timed | not timed | 1213.08 ± 0.2% | | 1.00 | 1.67 | 23.50 |
| 09-aws-keys/full | 0 | 698.96 ± 0.8% | not timed | not timed | 746.22 ± 3.7% | 101.49 ± 10.6% | not timed | not timed | 691.72 ± 16.0% | | 1.01 | 0.94 | 6.89 |
| 09-aws-keys/quick | 0 | 1371.94 ± 5.0% | not timed | not timed | 1269.08 ± 10.1% | 579.79 ± 1.7% | not timed | not timed | 1368.51 ± 49.3% | | 1.00 | 1.08 | 2.37 |
| 10-bounded-repeat/letters-en | 1833 | 754.93 ± 4.6% | not timed | not timed | 743.70 ± 3.8% | 31.39 ± 14.6% | not timed | not timed | 755.30 ± 4.1% | | 1.00 | 1.02 | 24.05 |
| 10-bounded-repeat/letters-ru | 3475 | 460.48 ± 5.0% | not timed | not timed | 667.58 ± 5.5% | 31.33 ± 8.6% | not timed | not timed | 465.79 ± 3.9% | | 0.99 | 0.69 | 14.70 |
| 10-bounded-repeat/context | 53 | 115.61 ± 4.4% | not timed | not timed | 95.34 ± 11.8% | 30.81 ± 5.0% | not timed | not timed | 116.38 ± 2.5% | | 0.99 | 1.21 | 3.75 |
| 10-bounded-repeat/capitals | 11 | 1252.54 ± 4.1% | not timed | not timed | 720.70 ± 4.9% | 54.24 ± 5.1% | not timed | not timed | 1289.97 ± 4.1% | | 0.97 | 1.74 | 23.09 |
| 11-unstructured-to-json/extract | 600 | 62.21 ± 2.5% | not timed | not timed | 109.16 ± 1.5% | 78.40 ± 8.4% | not timed | not timed | 61.80 ± 5.0% | | 1.01 | 0.57 | 0.79 |
| 12-dictionary/single | 1 | 663.67 ± 2.4% | not timed | not timed | 644.96 ± 23.8% | 0.67 ± 2.2% | not timed | not timed | 672.60 ± 2.5% | | 0.99 | 1.03 | 996.37 |
| 14-quadratic/1x | 100 | 17.31 ± 2.1% | not timed | not timed | 17.37 ± 14.3% | 1.46 ± 18.1% | not timed | not timed | 17.16 ± 1.5% | | 1.01 | 1.00 | 11.86 |
| 14-quadratic/2x | 200 | 10.08 ± 2.8% | not timed | not timed | 8.21 ± 3.4% | 0.82 ± 9.3% | not timed | not timed | 9.83 ± 3.7% | | 1.03 | 1.23 | 12.36 |
| 14-quadratic/10x | 1000 | 2.22 ± 3.2% | not timed | not timed | 1.53 ± 4.9% | 0.18 ± 2.1% | not timed | not timed | 2.21 ± 44.5% | | 1.00 | 1.45 | 12.24 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.54 ± 1.3% | not timed | not timed | 0.56 ± 1.0% | 0.87 ± 15.6% | not timed | not timed | 2.54 ± 1.5% | | 1.00 | 4.53 | 2.92 |
| 04-ruff-noqa/compile-real | 1 | 162.87 ± 39.8% | not timed | not timed | 21.66 ± 5.3% | 231.10 ± 3.7% | not timed | not timed | 165.64 ± 5.7% | | 0.98 | 7.52 | 0.70 |
| 05-lexer-veryl/compile-single | 1 | 24.30 ± 26.1% | not timed | not timed | 4.03 ± 1.8% | 11.22 ± 3.1% | not timed | not timed | 24.47 ± 2.4% | | 0.99 | 6.03 | 2.17 |
| 07-unicode-character-data/compile | 1 | 96.55 ± 4.6% | not timed | not timed | 40.50 ± 1.4% | 61.38 ± 15.8% | not timed | not timed | 96.18 ± 4.7% | | 1.00 | 2.38 | 1.57 |
| 09-aws-keys/compile-full | 1 | 61.70 ± 4.8% | not timed | not timed | 12.20 ± 6.9% | 35.84 ± 7.0% | not timed | not timed | 61.78 ± 8.5% | | 1.00 | 5.06 | 1.72 |
| 09-aws-keys/compile-quick | 1 | 304.15 ± 9.4% | not timed | not timed | 79.40 ± 7.7% | 219.93 ± 7.8% | not timed | not timed | 314.12 ± 7.6% | | 0.97 | 3.83 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 24.31 ± 5.7% | not timed | not timed | 18.04 ± 0.7% | 27.22 ± 3.9% | not timed | not timed | 24.03 ± 3.4% | | 1.01 | 1.35 | 0.89 |
| 10-bounded-repeat/compile-capitals | 1 | 138.64 ± 3.1% | not timed | not timed | 13.30 ± 1.3% | 39.50 ± 16.5% | not timed | not timed | 138.15 ± 4.2% | | 1.00 | 10.42 | 3.51 |
| 11-unstructured-to-json/compile | 1 | 146.95 ± 12.3% | not timed | not timed | 65.97 ± 8.1% | 114.22 ± 3.8% | not timed | not timed | 146.08 ± 5.0% | | 1.01 | 2.23 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.48 ± 1.2% | not timed | not timed | 0.10 ± 24.1% | 0.14 ± 9.7% | not timed | not timed | 0.48 ± 5.5% | | 1.01 | 4.77 | 3.44 |

