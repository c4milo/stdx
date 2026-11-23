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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102065472 |
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
| literal: a word | 217 | 57973.44 ± 1.9% | 1265.39 ± 0.3% | 46.72 ± 2.3% | 54787.82 ± 7.2% | 16230.52 ± 6.2% | 16.80 ± 5.6% | 166.21 ± 1.4% | 57697.90 ± 2.0% | 45.81 | 1.00 | 1.06 | 3.57 |
| literal: a word that is not there | 0 | 83226.72 ± 3.8% | 1279.38 ± 1.5% | 46.83 ± 6.6% | 67760.56 ± 2.3% | 57864.64 ± 2.3% | 16.37 ± 0.2% | 152.98 ± 2.0% | 82674.51 ± 3.8% | 65.05 | 1.01 | 1.23 | 1.44 |
| literal: one of four words | 661 | 19012.34 ± 9.3% | 1231.71 ± 5.5% | 25.53 ± 3.7% | 14594.93 ± 4.1% | 39.71 ± 14.3% | 5.22 ± 6.4% | 13.89 ± 2.2% | 19231.38 ± 6.9% | 15.44 | 0.99 | 1.30 | 478.77 |
| literal: a word in any case | 217 | 52675.55 ± 1.4% | 1265.57 ± 1.1% | 34.10 ± 4.3% | 14873.20 ± 1.4% | 75.69 ± 8.0% | refused | differs | 51869.26 ± 1.2% | 41.62 | 1.02 | 3.54 | 695.95 |
| literal: an href attribute | 33 | 46834.20 ± 11.9% | 1260.88 ± 3.8% | 39.84 ± 1.6% | 47154.91 ± 0.8% | 3672.21 ± 7.5% | 11.91 ± 1.2% | 137.60 ± 7.9% | 47864.77 ± 1.5% | 37.14 | 0.98 | 0.99 | 12.75 |
| literal: a word, second text | 123 | 56563.45 ± 14.2% | 1265.34 ± 5.1% | 44.26 ± 15.4% | 49838.65 ± 6.2% | 15048.60 ± 4.5% | 21.88 ± 4.8% | 136.22 ± 6.9% | 56361.09 ± 9.0% | 44.70 | 1.00 | 1.13 | 3.76 |
| class: two capitalized words | 1331 | 1144.13 ± 2.7% | 1168.02 ± 2.6% | 42.43 ± 5.1% | 712.06 ± 3.9% | 62.55 ± 5.5% | 14.50 ± 1.5% | 110.31 ± 2.6% | 1131.56 ± 5.3% | 0.98 | 1.01 | 1.61 | 18.29 |
| class: a word that ends in ing | 3399 | 1053.69 ± 4.2% | 1061.41 ± 6.6% | 29.04 ± 4.6% | 667.99 ± 3.4% | 47.80 ± 19.6% | 8.22 ± 0.5% | 32.12 ± 1.1% | 1061.40 ± 3.3% | 0.99 | 0.99 | 1.58 | 22.04 |
| class: a word in capitals | 2332 | 1625.14 ± 2.3% | 1138.21 ± 7.3% | 44.17 ± 1.8% | 693.72 ± 4.8% | 65.83 ± 25.0% | 17.24 ± 0.6% | 142.91 ± 1.0% | 1611.39 ± 3.6% | 1.43 | 1.01 | 2.34 | 24.69 |
| class: a number | 8288 | 2667.84 ± 4.7% | 959.47 ± 5.0% | 43.35 ± 3.6% | 2340.03 ± 2.4% | 68.37 ± 21.8% | 0.46 ± 1.1% | 96.11 ± 3.1% | 2619.37 ± 3.4% | 2.78 | 1.02 | 1.14 | 39.02 |
| class: two capitalized words, second text | 5359 | 818.64 ± 6.8% | 842.99 ± 5.8% | 37.01 ± 4.6% | 584.80 ± 5.5% | 51.47 ± 18.7% | 18.58 ± 6.2% | 101.05 ± 7.6% | 825.30 ± 6.3% | 0.97 | 0.99 | 1.40 | 15.91 |
| other: a word between two words | 6104 | 944.54 ± 24.3% | 876.26 ± 44.8% | 36.35 ± 11.4% | 1008.29 ± 5.6% | 168.62 ± 18.2% | 10.89 ± 4.3% | 118.59 ± 4.5% | 996.71 ± 6.0% | 1.08 | 0.95 | 0.94 | 5.60 |
| other: a number before a unit, second text | 1481 | 12080.56 ± 8.5% | 1192.40 ± 11.0% | 42.57 ± 3.7% | 10713.59 ± 11.3% | 61.27 ± 47.2% | 19.40 ± 4.8% | 111.46 ± 20.9% | 12047.51 ± 3.9% | 10.13 | 1.00 | 1.13 | 197.18 |
| other: a heading's start tag | 110 | 30086.71 ± 13.4% | 1251.04 ± 5.8% | 41.63 ± 5.8% | 3337.32 ± 5.5% | 2584.00 ± 30.3% | 14.30 ± 36.4% | 163.22 ± 11.5% | 29706.28 ± 56.9% | 24.05 | 1.01 | 9.02 | 11.64 |
| other: a whole word | 217 | 38599.80 ± 4.4% | 1249.05 ± 3.5% | 46.33 ± 2.1% | 36091.08 ± 5.4% | 75.48 ± 5.6% | 13.91 ± 5.0% | 85.79 ± 5.6% | 37648.73 ± 6.9% | 30.90 | 1.03 | 1.07 | 511.41 |
| other: a line's first word, second text | 3716 | 2975.05 ± 5.0% | 1032.81 ± 5.8% | 49.31 ± 3.7% | 3617.99 ± 3.6% | 101.98 ± 1.8% | refused | refused | 2947.89 ± 4.2% | 2.88 | 1.01 | 0.82 | 29.17 |
| other: fourteen octets before an x | 87 | 46075.28 ± 2.5% | 333.46 ± 13.2% | 7.85 ± 16.0% | 4802.79 ± 2.9% | 14.34 ± 7.2% | differs | 26.32 ± 6.4% | 45516.01 ± 2.5% | 138.17 | 1.01 | 9.59 | 3213.35 |
| other: a Greek word | 21815 | 600.91 ± 6.7% | 418.47 ± 9.3% | 49.27 ± 5.6% | 358.29 ± 5.9% | 81.66 ± 5.7% | differs | refused | 591.05 ± 8.2% | 1.44 | 1.02 | 1.68 | 7.36 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 34.71 ± 5.4% | 35.28 ± 6.5% | 1.36 ± 9.8% | 23.68 ± 6.2% | 3.32 ± 2.9% | differs | 6.04 ± 4.5% | 34.63 ± 2.0% | 0.98 | 1.00 | 1.47 | 10.45 |
| a UUID | 32895 | 31.37 ± 19.8% | 30.06 ± 6.2% | 1.06 ± 14.1% | 18.71 ± 3.6% | 3.70 ± 1.8% | 0.76 ± 1.9% | 4.88 ± 6.1% | 31.16 ± 28.9% | 1.04 | 1.01 | 1.68 | 8.48 |
| an IPv4 address | 33176 | 49.97 ± 5.4% | 50.37 ± 5.4% | 3.26 ± 4.8% | 34.39 ± 13.3% | 9.09 ± 5.2% | differs | 6.08 ± 6.9% | 48.41 ± 4.1% | 0.99 | 1.03 | 1.45 | 5.50 |
| a date and time | 32954 | 42.89 ± 3.0% | 44.82 ± 4.3% | 2.46 ± 6.5% | 25.91 ± 8.2% | 10.38 ± 12.9% | 1.29 ± 3.4% | 11.98 ± 2.2% | 44.68 ± 0.9% | 0.96 | 0.96 | 1.66 | 4.13 |
| a field path | 32606 | 38.13 ± 3.0% | 38.02 ± 3.1% | 1.67 ± 2.4% | 27.32 ± 3.1% | 4.69 ± 2.7% | differs | 4.26 ± 2.9% | 38.26 ± 3.4% | 1.00 | 1.00 | 1.40 | 8.13 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 14.95 ± 5.1% | 15.37 ± 4.8% | 15.34 ± 3.3% | 17.24 ± 1.1% | 7.54 ± 2.0% | 1.05 ± 4.0% | none | 15.47 ± 4.1% | 0.97 | 0.97 | 0.87 | 1.98 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 380.33 ± 20.2% | 378.95 ± 5.1% | 441.02 ± 7.2% | 134.56 ± 4.4% | 322.70 ± 9.2% | 902.95 ± 4.2% | 5838.64 ± 6.2% | 372.20 ± 5.7% | 1.00 | 1.02 | 2.83 | 1.18 |
| a UUID | 62 | 237.89 ± 1.3% | 237.91 ± 0.7% | 265.03 ± 2.0% | 74.07 ± 3.4% | 159.75 ± 16.4% | 312.71 ± 3.7% | 7098.59 ± 3.8% | 238.53 ± 0.8% | 1.00 | 1.00 | 3.21 | 1.49 |
| an IPv4 address | 29 | 730.58 ± 5.3% | 740.33 ± 9.6% | 1014.66 ± 5.7% | 120.54 ± 5.1% | 202.74 ± 4.7% | 540.08 ± 1.6% | 12361.41 ± 10.1% | 736.24 ± 5.4% | 0.99 | 0.99 | 6.06 | 3.60 |
| a date and time | 56 | 545.95 ± 13.8% | 553.06 ± 40.6% | 678.16 ± 5.4% | 119.08 ± 5.6% | 227.06 ± 4.3% | 603.06 ± 6.2% | 8283.11 ± 4.3% | 548.38 ± 4.7% | 0.99 | 1.00 | 4.58 | 2.40 |
| a field path | 39 | 379.43 ± 23.1% | 375.50 ± 46.5% | 433.02 ± 5.1% | 130.17 ± 8.2% | 315.70 ± 4.6% | 910.18 ± 4.9% | 7290.39 ± 4.3% | 374.27 ± 6.8% | 1.01 | 1.01 | 2.91 | 1.20 |
| literal: a word | 7 | 1182.52 ± 5.0% | 1294.40 ± 5.6% | 2238.52 ± 4.9% | 868.22 ± 1.8% | 1062.95 ± 4.0% | 1831.26 ± 5.1% | 40042.79 ± 4.8% | 1201.02 ± 6.0% | 0.91 | 0.98 | 1.36 | 1.11 |
| literal: a word that is not there | 8 | 1153.85 ± 4.9% | 1250.28 ± 4.6% | 2129.48 ± 5.5% | 801.36 ± 4.0% | 1004.48 ± 7.9% | 1774.97 ± 7.9% | 38570.92 ± 4.3% | 1143.41 ± 5.8% | 0.92 | 1.01 | 1.44 | 1.15 |
| literal: one of four words | 26 | 451.50 ± 4.2% | 711.80 ± 5.0% | 939.06 ± 4.1% | 70.77 ± 3.5% | 399.52 ± 1.3% | 659.78 ± 7.9% | 28648.22 ± 10.1% | 452.87 ± 3.3% | 0.63 | 1.00 | 6.38 | 1.13 |
| literal: a word in any case | 11 | 931.62 ± 40.0% | 992.38 ± 2.8% | 1494.99 ± 0.2% | 24.13 ± 1.0% | 1122.31 ± 2.5% | refused | 36061.47 ± 2.2% | 930.12 ± 2.3% | 0.94 | 1.00 | 38.61 | 0.83 |
| literal: an href attribute | 12 | 628.69 ± 6.0% | 652.30 ± 4.7% | 846.15 ± 5.1% | 62.91 ± 6.3% | 771.70 ± 2.7% | 1558.46 ± 1.9% | 29448.54 ± 5.2% | 623.86 ± 6.4% | 0.96 | 1.01 | 9.99 | 0.81 |
| literal: a word, second text | 10 | 1045.39 ± 6.4% | 1092.18 ± 8.0% | 1845.94 ± 4.3% | 693.35 ± 14.8% | 876.36 ± 13.3% | 1603.30 ± 3.9% | 38754.51 ± 2.9% | 1056.40 ± 1.8% | 0.96 | 0.99 | 1.51 | 1.19 |
| class: two capitalized words | 23 | 825.42 ± 15.9% | 902.91 ± 15.8% | 1282.82 ± 4.9% | 167.30 ± 6.3% | 801.25 ± 27.1% | 1446.07 ± 19.5% | 9879.20 ± 37.4% | 825.36 ± 67.2% | 0.91 | 1.00 | 4.93 | 1.03 |
| class: a word that ends in ing | 9 | 997.13 ± 4.1% | 1138.96 ± 6.0% | 1867.88 ± 2.3% | 204.46 ± 4.7% | 1092.87 ± 4.0% | 2182.54 ± 1.7% | 23859.80 ± 2.1% | 1003.01 ± 3.9% | 0.88 | 0.99 | 4.88 | 0.91 |
| class: a word in capitals | 16 | 895.32 ± 5.2% | 973.58 ± 5.3% | 1537.33 ± 1.1% | 205.17 ± 1.3% | 1178.98 ± 1.9% | 2008.71 ± 0.8% | 12493.70 ± 1.4% | 895.37 ± 2.8% | 0.92 | 1.00 | 4.36 | 0.76 |
| class: a number | 6 | 1094.22 ± 2.6% | 1207.51 ± 2.5% | 2176.49 ± 4.6% | 57.22 ± 1.6% | 2118.82 ± 12.3% | 3606.96 ± 1.8% | 30755.27 ± 1.5% | 1094.06 ± 2.2% | 0.91 | 1.00 | 19.12 | 0.52 |
| class: two capitalized words, second text | 23 | 800.64 ± 1.2% | 858.57 ± 0.9% | 1233.12 ± 7.0% | 159.16 ± 8.5% | 786.21 ± 3.1% | 1398.84 ± 2.4% | 9530.66 ± 0.9% | 800.50 ± 1.6% | 0.93 | 1.00 | 5.03 | 1.02 |
| other: a word between two words | 13 | 968.53 ± 8.3% | 1008.60 ± 2.7% | 1580.65 ± 2.0% | 208.32 ± 4.2% | 763.27 ± 4.0% | 1534.57 ± 6.8% | 22621.60 ± 1.3% | 983.83 ± 2.6% | 0.96 | 0.98 | 4.65 | 1.27 |
| other: a number before a unit, second text | 15 | 691.10 ± 1.2% | 779.04 ± 3.2% | 1066.07 ± 2.9% | 56.49 ± 3.4% | 942.67 ± 2.9% | 1727.28 ± 1.9% | 22658.41 ± 1.8% | 690.31 ± 2.5% | 0.89 | 1.00 | 12.23 | 0.73 |
| other: a heading's start tag | 13 | 621.08 ± 2.8% | 631.21 ± 1.4% | 831.08 ± 2.6% | 58.60 ± 3.6% | 921.97 ± 2.9% | 1660.64 ± 31.4% | 25624.80 ± 0.8% | 620.24 ± 1.4% | 0.98 | 1.00 | 10.60 | 0.67 |
| other: a whole word | 11 | 1012.90 ± 3.0% | 1090.79 ± 3.7% | 1738.86 ± 3.8% | 184.08 ± 4.3% | 893.39 ± 5.1% | 1598.15 ± 2.1% | 39003.92 ± 1.3% | 1008.21 ± 2.8% | 0.93 | 1.00 | 5.50 | 1.13 |
| other: a line's first word, second text | 17 | 945.57 ± 7.4% | 1007.93 ± 3.9% | 1613.01 ± 6.1% | 200.67 ± 2.9% | 1049.75 ± 20.7% | refused | refused | 965.81 ± 12.9% | 0.94 | 0.98 | 4.71 | 0.90 |
| other: fourteen octets before an x | 16 | 182.06 ± 6.6% | 260.70 ± 10.1% | 303.21 ± 2.7% | 22.57 ± 33.9% | 651.78 ± 184.0% | 742.75 ± 2.3% | 20125.76 ± 4.0% | 181.75 ± 3.5% | 0.70 | 1.00 | 8.07 | 0.28 |
| other: a Greek word | 8 | 718.97 ± 6.0% | 976.79 ± 5.5% | 1515.09 ± 9.9% | 73.65 ± 5.8% | 2086.50 ± 60.1% | 3418.37 ± 5.2% | refused | 721.36 ± 3.1% | 0.74 | 1.00 | 9.76 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 33756.76 ± 3.0% | not timed | not timed | 43730.16 ± 2.7% | 3625.12 ± 17.7% | not timed | not timed | 34000.81 ± 4.6% | | 0.99 | 0.77 | 9.31 |
| 01-literal/sherlock-casei-en | 522 | 7099.86 ± 3.4% | not timed | not timed | 11826.72 ± 3.0% | 53.87 ± 5.9% | not timed | not timed | 7146.08 ± 14.0% | | 0.99 | 0.60 | 131.80 |
| 01-literal/sherlock-ru | 724 | 36879.87 ± 6.2% | not timed | not timed | 44468.13 ± 11.1% | 2427.24 ± 8.2% | not timed | not timed | 37396.39 ± 3.0% | | 0.99 | 0.83 | 15.19 |
| 01-literal/sherlock-casei-ru | 746 | 11620.77 ± 1.1% | not timed | not timed | 9509.62 ± 5.6% | 58.95 ± 51.3% | not timed | not timed | 11574.33 ± 4.6% | | 1.00 | 1.22 | 197.13 |
| 01-literal/sherlock-zh | 30 | 72604.71 ± 4.7% | not timed | not timed | 59959.02 ± 4.2% | 2142.74 ± 4.0% | not timed | not timed | 73762.41 ± 4.2% | | 0.98 | 1.21 | 33.88 |
| 02-literal-alternate/sherlock-en | 714 | 15698.75 ± 2.7% | not timed | not timed | 13771.22 ± 4.2% | 29.43 ± 2.3% | not timed | not timed | 15845.48 ± 6.6% | | 0.99 | 1.14 | 533.40 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2960.25 ± 11.2% | not timed | not timed | 3046.63 ± 61.5% | 18.46 ± 5.9% | not timed | not timed | 2885.81 ± 5.5% | | 1.03 | 0.97 | 160.36 |
| 02-literal-alternate/sherlock-ru | 899 | 9644.88 ± 1.1% | not timed | not timed | 7461.97 ± 3.7% | 37.97 ± 25.0% | not timed | not timed | 9635.52 ± 3.6% | | 1.00 | 1.29 | 254.01 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2687.52 ± 3.5% | not timed | not timed | 1486.63 ± 4.3% | 16.29 ± 3.7% | not timed | not timed | 2608.08 ± 4.4% | | 1.03 | 1.81 | 164.93 |
| 02-literal-alternate/sherlock-zh | 207 | 22943.87 ± 4.4% | not timed | not timed | 16095.04 ± 10.3% | 55.19 ± 9.5% | not timed | not timed | 22547.93 ± 5.8% | | 1.02 | 1.43 | 415.71 |
| 03-date/ascii | 111817 | 156.47 ± 13.9% | not timed | not timed | 119.49 ± 7.7% | 0.32 ± 5.0% | not timed | not timed | 153.77 ± 22.2% | | 1.02 | 1.31 | 495.57 |
| 04-ruff-noqa/real | 84 | 855.78 ± 7.1% | not timed | not timed | 677.74 ± 6.7% | 26.17 ± 2.7% | not timed | not timed | 880.95 ± 3.5% | | 0.97 | 1.26 | 32.70 |
| 04-ruff-noqa/tweaked | 44 | 845.96 ± 4.2% | not timed | not timed | 713.25 ± 4.4% | 497.08 ± 16.4% | not timed | not timed | 817.75 ± 3.0% | | 1.03 | 1.19 | 1.70 |
| 05-lexer-veryl/single | 124800 | 5.66 ± 4.0% | not timed | not timed | 7.90 ± 6.0% | 0.36 ± 7.7% | not timed | not timed | 5.65 ± 3.6% | | 1.00 | 0.72 | 15.54 |
| 06-cloud-flare-redos/original | 107 | 288.06 ± 3.2% | not timed | not timed | 289.94 ± 8.3% | 39.52 ± 5.5% | not timed | not timed | 275.40 ± 10.1% | | 1.05 | 0.99 | 7.29 |
| 06-cloud-flare-redos/simplified-short | 102 | 225.50 ± 2.8% | not timed | not timed | 309.89 ± 1.5% | 43.36 ± 4.6% | not timed | not timed | 222.20 ± 12.7% | | 1.01 | 0.73 | 5.20 |
| 06-cloud-flare-redos/simplified-long | 10000 | 240.76 ± 4.8% | not timed | not timed | 324.89 ± 3.7% | 46.85 ± 4.4% | not timed | not timed | 244.98 ± 4.3% | | 0.98 | 0.74 | 5.14 |
| 07-unicode-character-data/parse-line | 558784 | 69.34 ± 5.8% | not timed | not timed | 262.25 ± 4.5% | 69.45 ± 5.1% | not timed | not timed | 71.81 ± 2.0% | | 0.97 | 0.26 | 1.00 |
| 08-words/all-english | 56691 | 130.78 ± 3.8% | not timed | not timed | 108.43 ± 2.1% | 21.40 ± 11.3% | not timed | not timed | 130.06 ± 0.5% | | 1.01 | 1.21 | 6.11 |
| 08-words/long-english | 839 | 1204.06 ± 6.2% | not timed | not timed | 719.02 ± 1.8% | 50.52 ± 2.0% | not timed | not timed | 1198.15 ± 5.0% | | 1.00 | 1.67 | 23.84 |
| 09-aws-keys/full | 0 | 656.13 ± 5.4% | not timed | not timed | 738.73 ± 4.6% | 99.80 ± 1.9% | not timed | not timed | 688.54 ± 3.0% | | 0.95 | 0.89 | 6.57 |
| 09-aws-keys/quick | 0 | 727.45 ± 4.6% | not timed | not timed | 1284.30 ± 6.8% | 565.02 ± 10.0% | not timed | not timed | 724.75 ± 1.8% | | 1.00 | 0.57 | 1.29 |
| 10-bounded-repeat/letters-en | 1833 | 737.35 ± 4.1% | not timed | not timed | 732.04 ± 5.5% | 30.61 ± 5.9% | not timed | not timed | 734.29 ± 4.2% | | 1.00 | 1.01 | 24.09 |
| 10-bounded-repeat/letters-ru | 3475 | 455.49 ± 4.4% | not timed | not timed | 664.25 ± 2.1% | 31.06 ± 14.8% | not timed | not timed | 438.48 ± 36.8% | | 1.04 | 0.69 | 14.66 |
| 10-bounded-repeat/context | 53 | 100.65 ± 2.5% | not timed | not timed | 90.70 ± 3.1% | 29.09 ± 7.5% | not timed | not timed | 100.50 ± 13.3% | | 1.00 | 1.11 | 3.46 |
| 10-bounded-repeat/capitals | 11 | 1220.41 ± 4.2% | not timed | not timed | 711.27 ± 5.8% | 52.14 ± 2.1% | not timed | not timed | 1217.20 ± 2.6% | | 1.00 | 1.72 | 23.41 |
| 11-unstructured-to-json/extract | 600 | 35.82 ± 2.3% | not timed | not timed | 105.09 ± 3.7% | 77.15 ± 3.2% | not timed | not timed | 36.58 ± 4.9% | | 0.98 | 0.34 | 0.46 |
| 12-dictionary/single | 1 | 662.70 ± 4.2% | not timed | not timed | 624.09 ± 5.3% | 0.66 ± 5.2% | not timed | not timed | 591.21 ± 59.1% | | 1.12 | 1.06 | 1001.48 |
| 14-quadratic/1x | 100 | 16.99 ± 4.2% | not timed | not timed | 14.85 ± 7.9% | 1.43 ± 6.4% | not timed | not timed | 16.65 ± 5.9% | | 1.02 | 1.14 | 11.91 |
| 14-quadratic/2x | 200 | 9.69 ± 6.6% | not timed | not timed | 8.09 ± 8.7% | 0.77 ± 8.0% | not timed | not timed | 9.55 ± 4.4% | | 1.01 | 1.20 | 12.53 |
| 14-quadratic/10x | 1000 | 2.14 ± 4.7% | not timed | not timed | 1.48 ± 7.7% | 0.17 ± 4.8% | not timed | not timed | 2.14 ± 4.6% | | 1.00 | 1.45 | 12.27 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.43 ± 10.2% | not timed | not timed | 0.53 ± 6.4% | 0.84 ± 3.5% | not timed | not timed | 2.42 ± 2.2% | | 1.00 | 4.59 | 2.90 |
| 04-ruff-noqa/compile-real | 1 | 159.43 ± 3.1% | not timed | not timed | 21.28 ± 2.6% | 225.54 ± 5.3% | not timed | not timed | 160.00 ± 3.2% | | 1.00 | 7.49 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 23.67 ± 3.5% | not timed | not timed | 3.89 ± 3.1% | 10.73 ± 26.9% | not timed | not timed | 23.38 ± 4.9% | | 1.01 | 6.08 | 2.21 |
| 07-unicode-character-data/compile | 1 | 93.03 ± 1.9% | not timed | not timed | 40.41 ± 4.7% | 60.10 ± 4.3% | not timed | not timed | 92.60 ± 6.2% | | 1.00 | 2.30 | 1.55 |
| 09-aws-keys/compile-full | 1 | 63.89 ± 9.3% | not timed | not timed | 12.35 ± 6.6% | 36.66 ± 38.1% | not timed | not timed | 63.70 ± 74.2% | | 1.00 | 5.17 | 1.74 |
| 09-aws-keys/compile-quick | 1 | 305.26 ± 6.8% | not timed | not timed | 78.84 ± 5.3% | 213.45 ± 5.5% | not timed | not timed | 299.23 ± 6.6% | | 1.02 | 3.87 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 22.76 ± 20.5% | not timed | not timed | 17.16 ± 2.6% | 26.14 ± 2.7% | not timed | not timed | 22.74 ± 2.4% | | 1.00 | 1.33 | 0.87 |
| 10-bounded-repeat/compile-capitals | 1 | 132.12 ± 2.4% | not timed | not timed | 12.48 ± 4.8% | 37.88 ± 9.6% | not timed | not timed | 131.66 ± 67.4% | | 1.00 | 10.58 | 3.49 |
| 11-unstructured-to-json/compile | 1 | 142.27 ± 13.0% | not timed | not timed | 62.56 ± 5.6% | 111.11 ± 1.9% | not timed | not timed | 141.13 ± 2.3% | | 1.01 | 2.27 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.46 ± 2.2% | not timed | not timed | 0.10 ± 15.3% | 0.14 ± 13.1% | not timed | not timed | 0.46 ± 2.7% | | 1.01 | 4.76 | 3.19 |

