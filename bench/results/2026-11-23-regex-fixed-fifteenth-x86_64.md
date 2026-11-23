# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) 6973P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159324506 |
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
| literal: a word | 217 | 31864.12 ± 8.8% | 1148.08 ± 5.1% | 38.98 ± 16.5% | 32656.03 ± 30.9% | 12484.14 ± 12.3% | 15.87 ± 19.1% | 123.40 ± 19.8% | 32510.72 ± 11.2% | 27.75 | 0.98 | 0.98 | 2.55 |
| literal: a word that is not there | 0 | 42695.29 ± 14.5% | 1180.72 ± 16.2% | 39.59 ± 8.9% | 36310.14 ± 1.9% | 40337.58 ± 6.8% | 15.18 ± 28.8% | 115.77 ± 17.7% | 42668.98 ± 39.6% | 36.16 | 1.00 | 1.18 | 1.06 |
| literal: one of four words | 661 | 13198.71 ± 16.0% | 1149.12 ± 16.4% | 20.84 ± 16.9% | 10436.40 ± 16.2% | 31.39 ± 17.2% | 4.58 ± 3.9% | 9.91 ± 24.5% | 14173.87 ± 16.9% | 11.49 | 0.93 | 1.26 | 420.45 |
| literal: a word in any case | 217 | 27642.17 ± 16.1% | 1166.84 ± 16.6% | 26.92 ± 20.2% | 9965.58 ± 17.5% | 61.74 ± 16.7% | refused | differs | 27388.69 ± 8.2% | 23.69 | 1.01 | 2.77 | 447.70 |
| literal: an href attribute | 33 | 28237.26 ± 9.5% | 1177.17 ± 1.0% | 34.67 ± 10.0% | 29205.35 ± 14.6% | 2680.76 ± 16.5% | 11.12 ± 22.9% | 93.60 ± 15.3% | 24812.54 ± 13.1% | 23.99 | 1.14 | 0.97 | 10.53 |
| literal: a word, second text | 123 | 33924.54 ± 12.9% | 1169.37 ± 1.0% | 37.89 ± 4.6% | 32502.49 ± 6.7% | 9014.02 ± 15.1% | 20.54 ± 11.6% | 104.50 ± 23.4% | 33871.27 ± 15.0% | 29.01 | 1.00 | 1.04 | 3.76 |
| class: two capitalized words | 1331 | 1098.19 ± 6.0% | 1088.07 ± 0.6% | 35.36 ± 6.3% | 659.01 ± 22.8% | 48.87 ± 17.1% | 13.56 ± 16.9% | 86.98 ± 16.7% | 1094.98 ± 18.3% | 1.01 | 1.00 | 1.67 | 22.47 |
| class: a word that ends in ing | 3399 | 989.96 ± 19.6% | 987.33 ± 31.3% | 22.87 ± 16.3% | 620.31 ± 16.9% | 37.89 ± 15.3% | 7.58 ± 15.1% | 24.13 ± 14.9% | 990.19 ± 12.2% | 1.00 | 1.00 | 1.60 | 26.12 |
| class: a word in capitals | 2332 | 1492.95 ± 17.6% | 1065.69 ± 16.4% | 37.60 ± 14.7% | 649.99 ± 10.8% | 56.56 ± 8.4% | 16.21 ± 7.3% | 108.88 ± 19.7% | 1493.23 ± 17.0% | 1.40 | 1.00 | 2.30 | 26.40 |
| class: a number | 8288 | 2150.62 ± 16.9% | 900.59 ± 15.6% | 36.32 ± 19.1% | 2284.25 ± 15.2% | 56.39 ± 29.4% | 0.45 ± 13.3% | 76.50 ± 16.9% | 2112.89 ± 16.3% | 2.39 | 1.02 | 0.94 | 38.14 |
| class: two capitalized words, second text | 5359 | 812.26 ± 16.2% | 813.04 ± 16.8% | 31.66 ± 11.4% | 545.74 ± 0.9% | 44.15 ± 15.9% | 17.64 ± 1.2% | 80.54 ± 0.8% | 812.66 ± 0.2% | 1.00 | 1.00 | 1.49 | 18.40 |
| other: a word between two words | 6104 | 896.06 ± 13.6% | 845.71 ± 13.8% | 29.85 ± 14.3% | 831.67 ± 17.6% | 136.03 ± 28.1% | 9.94 ± 14.8% | 92.04 ± 16.5% | 892.20 ± 15.7% | 1.06 | 1.00 | 1.08 | 6.59 |
| other: a number before a unit, second text | 1481 | 9883.18 ± 1.1% | 1102.68 ± 0.3% | 35.52 ± 4.7% | 9899.15 ± 3.6% | 52.87 ± 18.0% | 18.46 ± 0.3% | 86.15 ± 0.9% | 9768.22 ± 0.6% | 8.96 | 1.01 | 1.00 | 186.94 |
| other: a heading's start tag | 110 | 20611.91 ± 2.8% | 1163.14 ± 7.3% | 37.81 ± 1.2% | 2913.30 ± 1.2% | 2049.54 ± 9.9% | 14.13 ± 27.5% | 126.28 ± 16.9% | 20679.61 ± 14.8% | 17.72 | 1.00 | 7.08 | 10.06 |
| other: a whole word | 217 | 25447.56 ± 13.6% | 1166.86 ± 16.0% | 39.85 ± 17.0% | 26250.76 ± 14.5% | 65.15 ± 22.4% | 13.27 ± 20.4% | 70.40 ± 16.6% | 25442.31 ± 14.5% | 21.81 | 1.00 | 0.97 | 390.59 |
| other: a line's first word, second text | 3716 | 2743.99 ± 0.4% | 981.29 ± 0.9% | 40.53 ± 8.0% | 2654.10 ± 31.7% | 87.32 ± 8.1% | refused | refused | 2734.99 ± 0.4% | 2.80 | 1.00 | 1.03 | 31.42 |
| other: fourteen octets before an x | 87 | 36910.00 ± 16.4% | 322.63 ± 20.3% | 8.29 ± 15.8% | 4439.40 ± 12.3% | 12.54 ± 7.1% | differs | 21.66 ± 17.4% | 37415.87 ± 16.9% | 114.41 | 0.99 | 8.31 | 2943.00 |
| other: a Greek word | 21815 | 559.82 ± 15.3% | 435.40 ± 18.3% | 39.78 ± 16.9% | 337.11 ± 15.9% | 62.86 ± 21.2% | differs | refused | 564.03 ± 18.1% | 1.29 | 0.99 | 1.66 | 8.91 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.66 ± 0.8% | 31.47 ± 2.1% | 1.14 ± 7.0% | 23.08 ± 0.5% | 3.47 ± 8.9% | differs | 5.09 ± 20.7% | 30.46 ± 15.8% | 1.01 | 1.04 | 1.37 | 9.12 |
| a UUID | 32895 | 28.50 ± 0.6% | 28.42 ± 1.0% | 0.80 ± 0.7% | 17.78 ± 0.2% | 3.52 ± 0.8% | 0.76 ± 0.3% | 4.40 ± 0.8% | 28.51 ± 0.5% | 1.00 | 1.00 | 1.60 | 8.09 |
| an IPv4 address | 33176 | 41.78 ± 13.5% | 42.23 ± 16.9% | 2.59 ± 15.2% | 34.08 ± 22.0% | 8.64 ± 16.7% | differs | 5.02 ± 4.7% | 41.99 ± 1.1% | 0.99 | 1.00 | 1.23 | 4.83 |
| a date and time | 32954 | 42.41 ± 0.6% | 42.27 ± 0.5% | 1.85 ± 1.0% | 25.80 ± 0.8% | 11.06 ± 1.3% | 1.41 ± 1.8% | 9.83 ± 3.3% | 42.41 ± 2.3% | 1.00 | 1.00 | 1.64 | 3.84 |
| a field path | 32606 | 34.03 ± 14.8% | 34.13 ± 0.6% | 1.33 ± 2.2% | 26.72 ± 13.9% | 4.00 ± 33.0% | differs | 3.31 ± 17.0% | 33.88 ± 16.0% | 1.00 | 1.00 | 1.27 | 8.51 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 13.33 ± 1.2% | 13.29 ± 0.8% | 13.33 ± 0.7% | 15.84 ± 0.7% | 7.16 ± 9.3% | 1.11 ± 2.5% | none | 13.28 ± 0.4% | 1.00 | 1.00 | 0.84 | 1.86 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 301.70 ± 13.5% | 302.86 ± 13.4% | 349.29 ± 11.4% | 120.82 ± 10.8% | 257.07 ± 14.8% | 734.74 ± 32.1% | 4288.21 ± 15.8% | 300.68 ± 17.1% | 1.00 | 1.00 | 2.50 | 1.17 |
| a UUID | 62 | 193.59 ± 0.6% | 194.60 ± 0.4% | 214.54 ± 0.6% | 66.59 ± 2.2% | 125.00 ± 16.5% | 274.41 ± 1.2% | 6150.59 ± 0.3% | 193.26 ± 1.8% | 0.99 | 1.00 | 2.91 | 1.55 |
| an IPv4 address | 29 | 634.41 ± 32.6% | 626.84 ± 21.4% | 871.63 ± 16.3% | 106.47 ± 44.5% | 163.69 ± 24.2% | 463.77 ± 17.1% | 10754.28 ± 15.7% | 593.48 ± 15.9% | 1.01 | 1.07 | 5.96 | 3.88 |
| a date and time | 56 | 492.56 ± 5.6% | 495.91 ± 0.3% | 629.57 ± 0.6% | 102.69 ± 1.8% | 177.80 ± 2.1% | 490.68 ± 10.7% | 6246.43 ± 3.1% | 493.04 ± 4.4% | 0.99 | 1.00 | 4.80 | 2.77 |
| a field path | 39 | 285.62 ± 4.2% | 287.35 ± 0.8% | 327.78 ± 2.4% | 113.83 ± 1.4% | 262.40 ± 4.0% | 761.70 ± 0.3% | 5981.10 ± 10.9% | 284.87 ± 18.2% | 0.99 | 1.00 | 2.51 | 1.09 |
| literal: a word | 7 | 1000.00 ± 13.6% | 1093.02 ± 19.4% | 1967.62 ± 13.4% | 768.98 ± 22.8% | 871.76 ± 35.0% | 1557.21 ± 16.8% | 41307.92 ± 7.0% | 998.41 ± 4.3% | 0.91 | 1.00 | 1.30 | 1.15 |
| literal: a word that is not there | 8 | 958.62 ± 0.7% | 1059.90 ± 0.1% | 1857.09 ± 0.6% | 723.49 ± 0.7% | 833.34 ± 2.0% | 1458.69 ± 1.5% | 41048.18 ± 0.4% | 957.46 ± 4.6% | 0.90 | 1.00 | 1.32 | 1.15 |
| literal: one of four words | 26 | 375.66 ± 32.6% | 638.89 ± 28.4% | 800.48 ± 24.9% | 49.14 ± 45.9% | 288.35 ± 14.6% | 485.25 ± 14.4% | 22268.49 ± 10.1% | 372.67 ± 18.0% | 0.59 | 1.01 | 7.65 | 1.30 |
| literal: a word in any case | 11 | 741.52 ± 17.4% | 805.89 ± 16.6% | 1211.90 ± 16.0% | 18.73 ± 5.9% | 915.57 ± 16.2% | refused | 33222.06 ± 22.4% | 744.36 ± 16.9% | 0.92 | 1.00 | 39.59 | 0.81 |
| literal: an href attribute | 12 | 504.10 ± 0.7% | 520.91 ± 9.2% | 677.65 ± 1.2% | 53.66 ± 0.8% | 666.05 ± 15.7% | 1229.46 ± 0.8% | 29826.16 ± 0.7% | 504.75 ± 0.4% | 0.97 | 1.00 | 9.39 | 0.76 |
| literal: a word, second text | 10 | 855.38 ± 11.3% | 981.64 ± 12.5% | 1661.40 ± 9.4% | 633.42 ± 31.7% | 724.88 ± 17.0% | 1246.45 ± 12.5% | 36918.95 ± 10.3% | 852.33 ± 10.0% | 0.87 | 1.00 | 1.35 | 1.18 |
| class: two capitalized words | 23 | 710.48 ± 0.5% | 778.15 ± 0.5% | 1148.26 ± 0.9% | 145.85 ± 2.0% | 652.55 ± 22.2% | 1192.39 ± 12.4% | 8389.46 ± 10.6% | 712.06 ± 4.8% | 0.91 | 1.00 | 4.87 | 1.09 |
| class: a word that ends in ing | 9 | 847.98 ± 39.7% | 991.41 ± 20.0% | 1781.46 ± 2.4% | 186.66 ± 3.3% | 1004.78 ± 8.8% | 1839.44 ± 1.3% | 21910.14 ± 2.5% | 867.84 ± 17.0% | 0.86 | 0.98 | 4.54 | 0.84 |
| class: a word in capitals | 16 | 785.49 ± 0.7% | 862.92 ± 17.3% | 1444.91 ± 17.1% | 196.12 ± 7.9% | 1001.31 ± 7.5% | 1719.78 ± 18.1% | 11090.39 ± 20.1% | 784.67 ± 10.6% | 0.91 | 1.00 | 4.01 | 0.78 |
| class: a number | 6 | 951.81 ± 0.7% | 1076.26 ± 0.3% | 2064.89 ± 0.4% | 48.02 ± 1.0% | 1848.22 ± 1.6% | 3299.94 ± 2.5% | 32713.74 ± 0.8% | 952.32 ± 0.8% | 0.88 | 1.00 | 19.82 | 0.51 |
| class: two capitalized words, second text | 23 | 712.39 ± 21.9% | 780.29 ± 13.6% | 1153.90 ± 4.7% | 145.88 ± 8.6% | 629.89 ± 21.5% | 1228.36 ± 16.7% | 8361.83 ± 12.3% | 712.53 ± 10.0% | 0.91 | 1.00 | 4.88 | 1.13 |
| other: a word between two words | 13 | 859.05 ± 0.4% | 902.78 ± 3.5% | 1445.63 ± 11.8% | 195.98 ± 10.6% | 669.09 ± 15.6% | 1312.35 ± 1.6% | 20022.51 ± 4.6% | 859.44 ± 0.7% | 0.95 | 1.00 | 4.38 | 1.28 |
| other: a number before a unit, second text | 15 | 568.66 ± 0.6% | 632.42 ± 0.4% | 863.01 ± 0.3% | 45.17 ± 0.9% | 848.53 ± 1.7% | 1466.32 ± 4.0% | 21284.44 ± 1.7% | 568.12 ± 4.4% | 0.90 | 1.00 | 12.59 | 0.67 |
| other: a heading's start tag | 13 | 519.36 ± 0.7% | 528.63 ± 0.8% | 691.90 ± 3.0% | 51.77 ± 0.7% | 823.13 ± 2.0% | 1435.34 ± 0.4% | 25214.43 ± 1.4% | 517.93 ± 7.7% | 0.98 | 1.00 | 10.03 | 0.63 |
| other: a whole word | 11 | 904.12 ± 14.4% | 973.17 ± 18.0% | 1609.86 ± 17.2% | 173.80 ± 16.6% | 771.45 ± 8.7% | 1355.03 ± 1.1% | 37019.16 ± 6.0% | 903.53 ± 2.6% | 0.93 | 1.00 | 5.20 | 1.17 |
| other: a line's first word, second text | 17 | 820.05 ± 3.4% | 865.66 ± 0.6% | 1397.59 ± 0.6% | 186.94 ± 1.0% | 946.30 ± 1.2% | refused | refused | 821.03 ± 0.5% | 0.95 | 1.00 | 4.39 | 0.87 |
| other: fourteen octets before an x | 16 | 145.65 ± 0.4% | 210.54 ± 0.6% | 243.62 ± 0.4% | 20.04 ± 1.3% | 584.32 ± 2.9% | 652.33 ± 1.0% | 17924.11 ± 1.1% | 145.66 ± 0.4% | 0.69 | 1.00 | 7.27 | 0.25 |
| other: a Greek word | 8 | 540.68 ± 12.4% | 746.15 ± 13.9% | 1220.41 ± 14.5% | 57.42 ± 14.2% | 1632.23 ± 14.1% | 2702.76 ± 20.8% | refused | 539.91 ± 20.8% | 0.72 | 1.00 | 9.42 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21851.51 ± 11.0% | not timed | not timed | 25652.25 ± 12.7% | 2545.68 ± 16.8% | not timed | not timed | 21622.16 ± 12.8% | | 1.01 | 0.85 | 8.58 |
| 01-literal/sherlock-casei-en | 522 | 7568.32 ± 13.7% | not timed | not timed | 8275.40 ± 21.1% | 38.21 ± 17.8% | not timed | not timed | 7573.59 ± 14.5% | | 1.00 | 0.91 | 198.08 |
| 01-literal/sherlock-ru | 724 | 25305.11 ± 0.6% | not timed | not timed | 28460.77 ± 1.1% | 1667.11 ± 14.6% | not timed | not timed | 25242.88 ± 0.6% | | 1.00 | 0.89 | 15.18 |
| 01-literal/sherlock-casei-ru | 746 | 7708.46 ± 11.9% | not timed | not timed | 6114.86 ± 14.1% | 39.57 ± 17.7% | not timed | not timed | 7527.53 ± 25.1% | | 1.02 | 1.26 | 194.83 |
| 01-literal/sherlock-zh | 30 | 34013.18 ± 13.1% | not timed | not timed | 32332.19 ± 13.6% | 1723.00 ± 18.6% | not timed | not timed | 36362.87 ± 15.9% | | 0.94 | 1.05 | 19.74 |
| 02-literal-alternate/sherlock-en | 714 | 11450.74 ± 13.9% | not timed | not timed | 8703.05 ± 14.4% | 20.94 ± 5.2% | not timed | not timed | 11301.85 ± 15.0% | | 1.01 | 1.32 | 546.84 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2206.14 ± 17.0% | not timed | not timed | 2481.50 ± 12.4% | 14.64 ± 17.0% | not timed | not timed | 2180.62 ± 15.4% | | 1.01 | 0.89 | 150.67 |
| 02-literal-alternate/sherlock-ru | 899 | 6332.79 ± 19.7% | not timed | not timed | 4800.49 ± 19.5% | 27.53 ± 16.6% | not timed | not timed | 7169.44 ± 19.4% | | 0.88 | 1.32 | 230.06 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2165.98 ± 21.5% | not timed | not timed | 1340.46 ± 25.5% | 12.10 ± 15.2% | not timed | not timed | 2295.16 ± 15.3% | | 0.94 | 1.62 | 178.95 |
| 02-literal-alternate/sherlock-zh | 207 | 17599.19 ± 17.2% | not timed | not timed | 11598.40 ± 12.9% | 44.95 ± 18.8% | not timed | not timed | 17504.67 ± 16.8% | | 1.01 | 1.52 | 391.57 |
| 03-date/ascii | 111817 | 138.44 ± 0.8% | not timed | not timed | 118.38 ± 1.2% | 0.28 ± 4.0% | not timed | not timed | 133.92 ± 5.6% | | 1.03 | 1.17 | 489.79 |
| 04-ruff-noqa/real | 84 | 759.32 ± 1.9% | not timed | not timed | 612.35 ± 0.3% | 27.70 ± 0.9% | not timed | not timed | 762.37 ± 1.1% | | 1.00 | 1.24 | 27.41 |
| 04-ruff-noqa/tweaked | 44 | 668.54 ± 0.5% | not timed | not timed | 610.76 ± 0.4% | 385.97 ± 18.5% | not timed | not timed | 669.49 ± 1.1% | | 1.00 | 1.09 | 1.73 |
| 05-lexer-veryl/single | 124800 | 4.75 ± 0.5% | not timed | not timed | 6.21 ± 0.5% | 0.28 ± 5.8% | not timed | not timed | 4.73 ± 8.8% | | 1.00 | 0.76 | 17.01 |
| 06-cloud-flare-redos/original | 107 | 304.05 ± 4.7% | not timed | not timed | 282.07 ± 2.1% | 32.60 ± 1.3% | not timed | not timed | 304.04 ± 4.2% | | 1.00 | 1.08 | 9.33 |
| 06-cloud-flare-redos/simplified-short | 102 | 234.93 ± 6.7% | not timed | not timed | 249.21 ± 12.9% | 31.57 ± 5.9% | not timed | not timed | 234.26 ± 7.2% | | 1.00 | 0.94 | 7.44 |
| 06-cloud-flare-redos/simplified-long | 10000 | 292.36 ± 17.5% | not timed | not timed | 301.39 ± 3.9% | 41.03 ± 2.2% | not timed | not timed | 292.16 ± 0.5% | | 1.00 | 0.97 | 7.13 |
| 07-unicode-character-data/parse-line | 558784 | 285.64 ± 17.3% | not timed | not timed | 217.47 ± 16.4% | 56.82 ± 18.5% | not timed | not timed | 279.54 ± 17.1% | | 1.02 | 1.31 | 5.03 |
| 08-words/all-english | 56691 | 118.64 ± 17.5% | not timed | not timed | 92.69 ± 15.6% | 12.82 ± 24.6% | not timed | not timed | 106.60 ± 30.7% | | 1.11 | 1.28 | 9.25 |
| 08-words/long-english | 839 | 1131.92 ± 0.1% | not timed | not timed | 673.49 ± 0.5% | 40.67 ± 14.4% | not timed | not timed | 1130.62 ± 0.2% | | 1.00 | 1.68 | 27.83 |
| 09-aws-keys/full | 0 | 610.57 ± 1.8% | not timed | not timed | 624.19 ± 0.3% | 88.97 ± 5.0% | not timed | not timed | 605.11 ± 1.2% | | 1.01 | 0.98 | 6.86 |
| 09-aws-keys/quick | 0 | 1077.48 ± 15.2% | not timed | not timed | 918.26 ± 15.2% | 437.30 ± 10.5% | not timed | not timed | 1102.41 ± 11.3% | | 0.98 | 1.17 | 2.46 |
| 10-bounded-repeat/letters-en | 1833 | 673.42 ± 0.8% | not timed | not timed | 594.35 ± 0.4% | 26.02 ± 0.7% | not timed | not timed | 673.24 ± 0.9% | | 1.00 | 1.13 | 25.88 |
| 10-bounded-repeat/letters-ru | 3475 | 418.99 ± 5.9% | not timed | not timed | 533.42 ± 6.7% | 26.30 ± 8.0% | not timed | not timed | 419.58 ± 9.1% | | 1.00 | 0.79 | 15.93 |
| 10-bounded-repeat/context | 53 | 96.78 ± 18.3% | not timed | not timed | 78.39 ± 27.4% | 25.95 ± 2.8% | not timed | not timed | 97.13 ± 6.9% | | 1.00 | 1.23 | 3.73 |
| 10-bounded-repeat/capitals | 11 | 1170.96 ± 0.4% | not timed | not timed | 688.60 ± 0.6% | 47.48 ± 0.8% | not timed | not timed | 1162.11 ± 5.3% | | 1.01 | 1.70 | 24.66 |
| 11-unstructured-to-json/extract | 600 | 53.07 ± 1.6% | not timed | not timed | 87.17 ± 6.9% | 68.57 ± 1.8% | not timed | not timed | 52.83 ± 7.4% | | 1.00 | 0.61 | 0.77 |
| 12-dictionary/single | 1 | 612.96 ± 0.4% | not timed | not timed | 589.32 ± 3.1% | 0.57 ± 13.6% | not timed | not timed | 616.28 ± 0.7% | | 0.99 | 1.04 | 1075.95 |
| 14-quadratic/1x | 100 | 15.16 ± 0.2% | not timed | not timed | 14.52 ± 0.4% | 1.33 ± 1.8% | not timed | not timed | 15.12 ± 0.3% | | 1.00 | 1.04 | 11.44 |
| 14-quadratic/2x | 200 | 9.12 ± 3.5% | not timed | not timed | 7.13 ± 4.2% | 0.74 ± 14.9% | not timed | not timed | 9.07 ± 15.4% | | 1.01 | 1.28 | 12.32 |
| 14-quadratic/10x | 1000 | 2.08 ± 0.8% | not timed | not timed | 1.39 ± 0.6% | 0.16 ± 1.1% | not timed | not timed | 2.08 ± 0.5% | | 1.00 | 1.50 | 12.73 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.22 ± 0.4% | not timed | not timed | 0.48 ± 4.2% | 0.71 ± 2.9% | not timed | not timed | 2.20 ± 2.5% | | 1.01 | 4.62 | 3.12 |
| 04-ruff-noqa/compile-real | 1 | 142.07 ± 1.1% | not timed | not timed | 17.11 ± 0.7% | 187.44 ± 1.0% | not timed | not timed | 140.99 ± 1.0% | | 1.01 | 8.31 | 0.76 |
| 05-lexer-veryl/compile-single | 1 | 23.36 ± 0.9% | not timed | not timed | 3.29 ± 0.7% | 8.33 ± 2.0% | not timed | not timed | 23.31 ± 0.9% | | 1.00 | 7.11 | 2.81 |
| 07-unicode-character-data/compile | 1 | 85.67 ± 1.0% | not timed | not timed | 35.29 ± 4.9% | 46.69 ± 3.4% | not timed | not timed | 84.72 ± 1.6% | | 1.01 | 2.43 | 1.83 |
| 09-aws-keys/compile-full | 1 | 56.33 ± 15.0% | not timed | not timed | 8.78 ± 29.2% | 29.41 ± 16.2% | not timed | not timed | 55.87 ± 16.2% | | 1.01 | 6.41 | 1.92 |
| 09-aws-keys/compile-quick | 1 | 262.24 ± 9.7% | not timed | not timed | 64.66 ± 5.1% | 177.10 ± 0.6% | not timed | not timed | 261.24 ± 3.2% | | 1.00 | 4.06 | 1.48 |
| 10-bounded-repeat/compile-context | 1 | 17.84 ± 2.9% | not timed | not timed | 15.65 ± 0.2% | 22.16 ± 3.0% | not timed | not timed | 17.74 ± 0.9% | | 1.01 | 1.14 | 0.81 |
| 10-bounded-repeat/compile-capitals | 1 | 104.86 ± 21.7% | not timed | not timed | 11.77 ± 44.8% | 28.55 ± 15.7% | not timed | not timed | 103.04 ± 15.8% | | 1.02 | 8.91 | 3.67 |
| 11-unstructured-to-json/compile | 1 | 120.14 ± 14.2% | not timed | not timed | 47.88 ± 20.1% | 82.92 ± 17.3% | not timed | not timed | 125.64 ± 17.2% | | 0.96 | 2.51 | 1.45 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.0% | not timed | not timed | 0.08 ± 1.2% | 0.11 ± 15.9% | not timed | not timed | 0.34 ± 1.3% | | 1.02 | 4.64 | 3.08 |

