# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507046217 |
| Date | 2026-11-24 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. Each round times the other candidates from one place later than the round before, so none of them takes one place in every round. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 64929.17 ± 12.8% | 6337.03 ± 2.9% | 46.28 ± 5.8% | 53306.47 ± 4.9% | 16215.84 ± 5.5% | 15.91 ± 6.2% | 158.42 ± 14.9% | 65455.92 ± 12.9% | 10.25 | 0.99 | 1.22 | 4.00 |
| literal: a word that is not there | 0 | 86646.63 ± 4.1% | 6265.79 ± 5.1% | 44.03 ± 4.6% | 67148.26 ± 4.6% | 56229.17 ± 3.9% | 15.51 ± 5.2% | 151.83 ± 6.3% | 86209.14 ± 6.9% | 13.83 | 1.01 | 1.29 | 1.54 |
| literal: one of four words | 661 | 22228.29 ± 3.0% | 2388.88 ± 2.2% | 25.09 ± 2.4% | 14490.46 ± 6.0% | 39.01 ± 5.6% | 5.19 ± 4.3% | 13.79 ± 3.7% | 22428.59 ± 4.7% | 9.30 | 0.99 | 1.53 | 569.87 |
| literal: a word in any case | 217 | 60684.49 ± 3.2% | 2635.45 ± 4.3% | 33.68 ± 6.3% | 14789.46 ± 6.7% | 73.71 ± 6.9% | refused | differs | 61004.64 ± 4.3% | 23.03 | 0.99 | 4.10 | 823.31 |
| literal: an href attribute | 33 | 52726.53 ± 4.4% | 728.68 ± 4.1% | 39.57 ± 5.7% | 46351.20 ± 2.7% | 3612.03 ± 5.0% | 11.26 ± 0.7% | 134.50 ± 5.5% | 53253.67 ± 3.1% | 72.36 | 0.99 | 1.14 | 14.60 |
| literal: a word, second text | 123 | 66343.66 ± 5.3% | 4564.83 ± 3.6% | 45.62 ± 3.9% | 49517.91 ± 2.8% | 15321.84 ± 2.4% | 21.81 ± 3.9% | 135.26 ± 10.4% | 67553.09 ± 3.6% | 14.53 | 0.98 | 1.34 | 4.33 |
| class: two capitalized words | 1331 | 1111.51 ± 2.9% | 733.15 ± 1.4% | 41.99 ± 4.1% | 693.58 ± 5.2% | 60.97 ± 6.5% | 13.88 ± 4.1% | 106.93 ± 3.5% | 1144.27 ± 5.2% | 1.52 | 0.97 | 1.60 | 18.23 |
| class: a word that ends in ing | 3399 | 697.68 ± 4.9% | 699.73 ± 3.5% | 29.13 ± 7.7% | 666.71 ± 5.2% | 44.38 ± 20.2% | 8.23 ± 3.4% | 31.43 ± 7.5% | 718.26 ± 5.4% | 1.00 | 0.97 | 1.05 | 15.72 |
| class: a word in capitals | 2332 | 1669.45 ± 5.2% | 765.91 ± 16.2% | 43.09 ± 2.7% | 673.20 ± 3.0% | 65.54 ± 16.6% | 16.60 ± 3.5% | 138.66 ± 5.3% | 1674.79 ± 5.3% | 2.18 | 1.00 | 2.48 | 25.47 |
| class: a number | 8288 | 3014.19 ± 3.7% | 1043.35 ± 5.0% | 44.34 ± 5.3% | 2330.02 ± 5.3% | 65.22 ± 19.4% | 0.45 ± 2.3% | 99.05 ± 4.1% | 2971.93 ± 4.9% | 2.89 | 1.01 | 1.29 | 46.21 |
| class: two capitalized words, second text | 5359 | 623.77 ± 2.5% | 632.69 ± 1.2% | 37.49 ± 2.9% | 574.71 ± 2.4% | 49.56 ± 13.9% | 17.81 ± 1.9% | 97.37 ± 2.0% | 630.18 ± 2.8% | 0.99 | 0.99 | 1.09 | 12.58 |
| other: a word between two words | 6104 | 1202.62 ± 8.5% | 733.35 ± 4.1% | 34.05 ± 4.6% | 961.95 ± 2.4% | 176.18 ± 11.2% | 10.28 ± 4.7% | 114.47 ± 11.6% | 1174.39 ± 5.2% | 1.64 | 1.02 | 1.25 | 6.83 |
| other: a number before a unit, second text | 1481 | 13272.99 ± 6.3% | 1435.72 ± 4.4% | 41.34 ± 5.3% | 10715.21 ± 2.9% | 60.66 ± 24.8% | 18.95 ± 3.5% | 110.64 ± 3.4% | 13521.93 ± 5.3% | 9.24 | 0.98 | 1.24 | 218.82 |
| other: a heading's start tag | 110 | 31663.05 ± 5.5% | 883.86 ± 3.9% | 40.30 ± 4.1% | 3300.69 ± 1.5% | 2563.41 ± 9.4% | 13.89 ± 3.1% | 165.50 ± 3.2% | 31747.60 ± 1.3% | 35.82 | 1.00 | 9.59 | 12.35 |
| other: a whole word | 217 | 42298.33 ± 3.6% | 719.02 ± 1.2% | 44.65 ± 2.7% | 37023.01 ± 2.2% | 75.66 ± 10.0% | 13.69 ± 2.9% | 85.36 ± 2.0% | 42443.82 ± 3.6% | 58.83 | 1.00 | 1.14 | 559.03 |
| other: a line's first word, second text | 3716 | 3465.53 ± 3.0% | 715.51 ± 6.4% | 50.19 ± 5.8% | 3496.22 ± 4.8% | 101.12 ± 4.5% | refused | refused | 3470.79 ± 6.3% | 4.84 | 1.00 | 0.99 | 34.27 |
| other: fourteen octets before an x | 87 | 52469.30 ± 2.2% | 343.95 ± 2.3% | 9.53 ± 1.9% | 5163.31 ± 3.9% | 14.15 ± 1.4% | differs | 26.32 ± 3.2% | 52743.23 ± 3.5% | 152.55 | 0.99 | 10.16 | 3707.39 |
| other: a Greek word | 21815 | 670.31 ± 2.7% | 549.34 ± 6.9% | 49.71 ± 5.6% | 368.53 ± 5.5% | 68.34 ± 25.7% | differs | refused | 670.95 ± 7.5% | 1.22 | 1.00 | 1.82 | 9.81 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 37.78 ± 2.6% | 38.28 ± 3.6% | 1.52 ± 2.0% | 24.07 ± 3.5% | 3.63 ± 6.3% | differs | 6.08 ± 4.0% | 37.64 ± 5.7% | 0.99 | 1.00 | 1.57 | 10.41 |
| a UUID | 32895 | 33.95 ± 4.2% | 34.35 ± 2.2% | 1.02 ± 13.2% | 18.68 ± 7.2% | 3.59 ± 7.5% | 0.73 ± 1.6% | 4.68 ± 4.5% | 34.42 ± 4.7% | 0.99 | 0.99 | 1.82 | 9.47 |
| an IPv4 address | 33176 | 47.95 ± 2.5% | 47.88 ± 3.6% | 3.32 ± 3.6% | 35.49 ± 3.5% | 9.29 ± 8.1% | differs | 5.93 ± 12.2% | 48.99 ± 5.5% | 1.00 | 0.98 | 1.35 | 5.16 |
| a date and time | 32954 | 47.29 ± 2.6% | 45.40 ± 12.3% | 2.50 ± 3.8% | 27.10 ± 4.5% | 10.99 ± 4.4% | 1.33 ± 5.7% | 11.97 ± 12.4% | 46.50 ± 5.9% | 1.04 | 1.02 | 1.74 | 4.30 |
| a field path | 32606 | 41.14 ± 3.0% | 42.12 ± 1.8% | 1.79 ± 3.7% | 28.23 ± 3.7% | 4.90 ± 3.3% | differs | 4.15 ± 12.0% | 41.84 ± 4.3% | 0.98 | 0.98 | 1.46 | 8.39 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 15.97 ± 3.0% | 15.88 ± 5.7% | 15.41 ± 4.4% | 17.42 ± 6.2% | 7.97 ± 6.0% | 1.08 ± 4.4% | none | 15.67 ± 6.7% | 1.01 | 1.02 | 0.92 | 2.00 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 370.70 ± 4.7% | 373.08 ± 4.6% | 431.95 ± 2.5% | 137.14 ± 7.8% | 336.53 ± 7.0% | 904.48 ± 3.6% | 5933.35 ± 3.4% | 372.73 ± 5.1% | 0.99 | 0.99 | 2.70 | 1.10 |
| a UUID | 62 | 249.52 ± 6.8% | 244.45 ± 4.2% | 269.39 ± 9.1% | 77.42 ± 6.3% | 161.41 ± 8.4% | 316.48 ± 3.4% | 7445.60 ± 3.4% | 245.00 ± 5.8% | 1.02 | 1.02 | 3.22 | 1.55 |
| an IPv4 address | 29 | 720.74 ± 9.4% | 717.73 ± 4.8% | 970.96 ± 2.0% | 119.94 ± 2.0% | 204.90 ± 3.8% | 567.71 ± 5.7% | 12799.60 ± 28.5% | 697.20 ± 2.8% | 1.00 | 1.03 | 6.01 | 3.52 |
| a date and time | 56 | 526.74 ± 6.6% | 519.66 ± 6.6% | 644.39 ± 4.6% | 112.42 ± 5.2% | 227.19 ± 14.4% | 582.02 ± 6.4% | 8082.67 ± 12.2% | 512.48 ± 6.6% | 1.01 | 1.03 | 4.69 | 2.32 |
| a field path | 39 | 364.48 ± 3.8% | 363.59 ± 1.7% | 424.03 ± 4.2% | 127.99 ± 4.4% | 307.71 ± 8.1% | 953.40 ± 7.8% | 7800.12 ± 5.1% | 366.00 ± 2.8% | 1.00 | 1.00 | 2.85 | 1.18 |
| literal: a word | 7 | 1094.15 ± 6.3% | 1191.65 ± 7.5% | 2024.25 ± 8.2% | 871.53 ± 4.3% | 1040.66 ± 5.8% | 1887.29 ± 2.5% | 40533.35 ± 5.0% | 1095.68 ± 4.8% | 0.92 | 1.00 | 1.26 | 1.05 |
| literal: a word that is not there | 8 | 1026.69 ± 3.6% | 1100.98 ± 3.7% | 1851.73 ± 3.1% | 796.04 ± 3.8% | 1014.42 ± 10.3% | 1752.27 ± 2.7% | 39771.14 ± 7.7% | 1027.63 ± 6.3% | 0.93 | 1.00 | 1.29 | 1.01 |
| literal: one of four words | 26 | 413.02 ± 5.1% | 650.72 ± 3.9% | 857.18 ± 3.2% | 68.21 ± 3.4% | 403.31 ± 3.9% | 700.67 ± 0.9% | 28261.33 ± 2.9% | 411.85 ± 5.1% | 0.63 | 1.00 | 6.06 | 1.02 |
| literal: a word in any case | 11 | 764.00 ± 11.3% | 805.41 ± 38.7% | 1174.32 ± 4.5% | 23.04 ± 43.4% | 1088.21 ± 71.9% | refused | 35892.98 ± 29.3% | 762.06 ± 28.1% | 0.95 | 1.00 | 33.16 | 0.70 |
| literal: an href attribute | 12 | 544.26 ± 48.7% | 448.93 ± 43.9% | 684.56 ± 39.3% | 60.64 ± 62.2% | 533.87 ± 141.7% | 1330.31 ± 64.0% | 23328.79 ± 58.1% | 579.60 ± 63.8% | 1.21 | 0.94 | 8.98 | 1.02 |
| literal: a word, second text | 10 | 928.19 ± 3.9% | 1016.09 ± 5.3% | 1629.01 ± 34.1% | 696.41 ± 24.2% | 859.07 ± 3.1% | 1529.77 ± 4.8% | 38799.32 ± 3.5% | 927.66 ± 5.0% | 0.91 | 1.00 | 1.33 | 1.08 |
| class: two capitalized words | 23 | 751.24 ± 6.7% | 816.92 ± 6.7% | 1150.86 ± 11.4% | 166.20 ± 7.8% | 832.51 ± 21.5% | 1466.17 ± 53.3% | 9491.64 ± 6.8% | 734.16 ± 7.8% | 0.92 | 1.02 | 4.52 | 0.90 |
| class: a word that ends in ing | 9 | 898.14 ± 3.6% | 1027.61 ± 2.5% | 1743.40 ± 5.8% | 197.51 ± 7.9% | 1093.85 ± 6.1% | 2109.86 ± 2.6% | 23702.20 ± 2.6% | 896.98 ± 9.0% | 0.87 | 1.00 | 4.55 | 0.82 |
| class: a word in capitals | 16 | 854.22 ± 4.4% | 922.89 ± 13.8% | 1491.04 ± 6.7% | 202.25 ± 9.2% | 1204.50 ± 16.5% | 2016.53 ± 6.7% | 12126.52 ± 3.4% | 854.63 ± 5.7% | 0.93 | 1.00 | 4.22 | 0.71 |
| class: a number | 6 | 1044.80 ± 10.7% | 1160.88 ± 2.8% | 2135.72 ± 0.9% | 57.18 ± 4.7% | 2103.71 ± 7.3% | 3616.75 ± 1.8% | 31417.36 ± 0.7% | 1048.57 ± 4.8% | 0.90 | 1.00 | 18.27 | 0.50 |
| class: two capitalized words, second text | 23 | 742.64 ± 4.0% | 809.30 ± 1.9% | 1143.07 ± 3.9% | 157.44 ± 4.3% | 798.77 ± 53.3% | 1452.59 ± 5.4% | 9477.56 ± 9.1% | 750.87 ± 6.9% | 0.92 | 0.99 | 4.72 | 0.93 |
| other: a word between two words | 13 | 907.53 ± 16.3% | 952.01 ± 4.2% | 1469.10 ± 4.7% | 210.06 ± 6.3% | 771.71 ± 12.7% | 1516.94 ± 3.7% | 22740.14 ± 24.8% | 913.04 ± 8.1% | 0.95 | 0.99 | 4.32 | 1.18 |
| other: a number before a unit, second text | 15 | 644.17 ± 3.1% | 733.04 ± 1.9% | 1010.32 ± 13.0% | 55.51 ± 3.4% | 930.79 ± 2.7% | 1713.37 ± 5.5% | 22236.58 ± 14.3% | 646.08 ± 15.6% | 0.88 | 1.00 | 11.61 | 0.69 |
| other: a heading's start tag | 13 | 586.24 ± 2.4% | 599.42 ± 2.7% | 781.30 ± 2.5% | 58.17 ± 4.3% | 915.69 ± 12.4% | 1607.08 ± 13.5% | 25830.16 ± 2.7% | 589.27 ± 2.5% | 0.98 | 0.99 | 10.08 | 0.64 |
| other: a whole word | 11 | 938.60 ± 2.7% | 1007.58 ± 0.9% | 1557.54 ± 12.7% | 184.65 ± 2.3% | 884.14 ± 11.4% | 1588.69 ± 5.0% | 38237.31 ± 2.0% | 950.62 ± 2.2% | 0.93 | 0.99 | 5.08 | 1.06 |
| other: a line's first word, second text | 17 | 874.87 ± 2.4% | 929.03 ± 29.9% | 1496.80 ± 25.1% | 192.81 ± 2.3% | 1039.42 ± 1.8% | refused | refused | 888.05 ± 2.3% | 0.94 | 0.99 | 4.54 | 0.84 |
| other: fourteen octets before an x | 16 | 179.20 ± 2.5% | 259.07 ± 1.3% | 294.36 ± 4.6% | 21.84 ± 9.6% | 631.62 ± 14.4% | 733.23 ± 1.8% | 19617.10 ± 3.7% | 179.54 ± 6.1% | 0.69 | 1.00 | 8.21 | 0.28 |
| other: a Greek word | 8 | 715.39 ± 2.8% | 956.53 ± 5.5% | 1544.85 ± 7.7% | 72.99 ± 1.6% | 2070.59 ± 4.3% | 3383.93 ± 3.6% | refused | 713.35 ± 3.3% | 0.75 | 1.00 | 9.80 | 0.35 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 44209.99 ± 7.2% | not timed | not timed | 43776.41 ± 1.2% | 3795.40 ± 29.1% | not timed | not timed | 44266.21 ± 6.4% | | 1.00 | 1.01 | 11.65 |
| 01-literal/sherlock-casei-en | 522 | 40193.90 ± 3.6% | not timed | not timed | 11346.10 ± 3.4% | 51.21 ± 12.6% | not timed | not timed | 40224.86 ± 7.3% | | 1.00 | 3.54 | 784.87 |
| 01-literal/sherlock-ru | 724 | 45035.93 ± 7.7% | not timed | not timed | 42255.85 ± 5.0% | 2384.46 ± 25.5% | not timed | not timed | 45370.37 ± 1.3% | | 0.99 | 1.07 | 18.89 |
| 01-literal/sherlock-casei-ru | 746 | 14650.39 ± 2.4% | not timed | not timed | 9158.73 ± 3.7% | 55.67 ± 9.4% | not timed | not timed | 14697.74 ± 7.4% | | 1.00 | 1.60 | 263.16 |
| 01-literal/sherlock-zh | 30 | 78040.48 ± 19.7% | not timed | not timed | 58017.99 ± 12.6% | 2042.14 ± 4.0% | not timed | not timed | 77911.07 ± 1.4% | | 1.00 | 1.35 | 38.22 |
| 02-literal-alternate/sherlock-en | 714 | 18141.53 ± 3.1% | not timed | not timed | 13131.37 ± 9.3% | 28.79 ± 2.6% | not timed | not timed | 18123.98 ± 0.8% | | 1.00 | 1.38 | 630.06 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3006.30 ± 6.1% | not timed | not timed | 2896.47 ± 3.5% | 17.74 ± 2.9% | not timed | not timed | 3021.82 ± 5.9% | | 0.99 | 1.04 | 169.42 |
| 02-literal-alternate/sherlock-ru | 899 | 12272.97 ± 10.5% | not timed | not timed | 7363.75 ± 4.2% | 37.21 ± 3.8% | not timed | not timed | 12365.43 ± 4.0% | | 0.99 | 1.67 | 329.81 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2711.56 ± 1.8% | not timed | not timed | 1405.41 ± 1.5% | 15.72 ± 1.4% | not timed | not timed | 2712.13 ± 2.1% | | 1.00 | 1.93 | 172.52 |
| 02-literal-alternate/sherlock-zh | 207 | 24840.74 ± 2.5% | not timed | not timed | 15637.25 ± 2.3% | 52.52 ± 2.2% | not timed | not timed | 25075.05 ± 2.5% | | 0.99 | 1.59 | 473.01 |
| 03-date/ascii | 111817 | 182.53 ± 3.8% | not timed | not timed | 123.01 ± 4.0% | 0.31 ± 4.8% | not timed | not timed | 182.44 ± 2.5% | | 1.00 | 1.48 | 586.62 |
| 04-ruff-noqa/real | 84 | 668.49 ± 5.7% | not timed | not timed | 670.95 ± 5.5% | 29.71 ± 3.2% | not timed | not timed | 664.12 ± 4.1% | | 1.01 | 1.00 | 22.50 |
| 04-ruff-noqa/tweaked | 44 | 827.76 ± 8.2% | not timed | not timed | 669.30 ± 1.7% | 480.28 ± 3.7% | not timed | not timed | 828.76 ± 2.0% | | 1.00 | 1.24 | 1.72 |
| 05-lexer-veryl/single | 124800 | 7.25 ± 4.9% | not timed | not timed | 7.54 ± 4.7% | 0.34 ± 6.3% | not timed | not timed | 7.25 ± 5.5% | | 1.00 | 0.96 | 21.07 |
| 06-cloud-flare-redos/original | 107 | 553.52 ± 1.2% | not timed | not timed | 282.98 ± 1.6% | 38.61 ± 5.5% | not timed | not timed | 552.61 ± 1.3% | | 1.00 | 1.96 | 14.33 |
| 06-cloud-flare-redos/simplified-short | 102 | 554.45 ± 1.7% | not timed | not timed | 297.68 ± 22.4% | 41.67 ± 9.7% | not timed | not timed | 551.56 ± 1.5% | | 1.01 | 1.86 | 13.31 |
| 06-cloud-flare-redos/simplified-long | 10000 | 648.89 ± 5.0% | not timed | not timed | 322.18 ± 5.8% | 45.46 ± 1.1% | not timed | not timed | 651.56 ± 2.9% | | 1.00 | 2.01 | 14.27 |
| 07-unicode-character-data/parse-line | 558784 | 341.01 ± 4.4% | not timed | not timed | 254.49 ± 6.0% | 65.91 ± 9.1% | not timed | not timed | 336.78 ± 4.5% | | 1.01 | 1.34 | 5.17 |
| 08-words/all-english | 56691 | 171.73 ± 1.7% | not timed | not timed | 105.99 ± 1.3% | 19.31 ± 5.2% | not timed | not timed | 167.92 ± 1.9% | | 1.02 | 1.62 | 8.89 |
| 08-words/long-english | 839 | 726.67 ± 1.8% | not timed | not timed | 688.74 ± 2.2% | 48.14 ± 23.7% | not timed | not timed | 718.07 ± 5.5% | | 1.01 | 1.06 | 15.10 |
| 09-aws-keys/full | 0 | 684.97 ± 3.7% | not timed | not timed | 712.03 ± 4.3% | 98.30 ± 4.9% | not timed | not timed | 690.71 ± 4.4% | | 0.99 | 0.96 | 6.97 |
| 09-aws-keys/quick | 0 | 1468.29 ± 2.4% | not timed | not timed | 1244.72 ± 2.4% | 562.80 ± 14.1% | not timed | not timed | 1466.47 ± 2.2% | | 1.00 | 1.18 | 2.61 |
| 10-bounded-repeat/letters-en | 1833 | 840.96 ± 3.9% | not timed | not timed | 750.07 ± 5.4% | 30.04 ± 5.1% | not timed | not timed | 858.65 ± 4.2% | | 0.98 | 1.12 | 28.00 |
| 10-bounded-repeat/letters-ru | 3475 | 716.18 ± 5.0% | not timed | not timed | 645.65 ± 7.4% | 32.32 ± 13.5% | not timed | not timed | 707.59 ± 5.8% | | 1.01 | 1.11 | 22.16 |
| 10-bounded-repeat/context | 53 | 114.58 ± 1.9% | not timed | not timed | 90.34 ± 5.9% | 29.41 ± 21.0% | not timed | not timed | 115.99 ± 4.8% | | 0.99 | 1.27 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 768.81 ± 16.2% | not timed | not timed | 724.94 ± 4.7% | 53.38 ± 5.9% | not timed | not timed | 754.17 ± 8.6% | | 1.02 | 1.06 | 14.40 |
| 11-unstructured-to-json/extract | 600 | 73.82 ± 23.4% | not timed | not timed | 105.77 ± 3.9% | 75.64 ± 3.8% | not timed | not timed | 74.97 ± 27.2% | | 0.98 | 0.70 | 0.98 |
| 12-dictionary/single | 1 | 636.64 ± 4.9% | not timed | not timed | 616.72 ± 4.9% | 0.64 ± 26.7% | not timed | not timed | 639.65 ± 3.2% | | 1.00 | 1.03 | 989.34 |
| 14-quadratic/1x | 100 | 39.98 ± 4.3% | not timed | not timed | 16.98 ± 4.1% | 1.44 ± 5.0% | not timed | not timed | 39.15 ± 4.8% | | 1.02 | 2.35 | 27.79 |
| 14-quadratic/2x | 200 | 31.70 ± 1.9% | not timed | not timed | 7.58 ± 2.2% | 0.80 ± 4.3% | not timed | not timed | 31.90 ± 4.1% | | 0.99 | 4.18 | 39.73 |
| 14-quadratic/10x | 1000 | 10.82 ± 4.9% | not timed | not timed | 1.47 ± 3.0% | 0.17 ± 7.0% | not timed | not timed | 10.77 ± 3.7% | | 1.00 | 7.37 | 62.51 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.87 ± 3.0% | not timed | not timed | 0.52 ± 3.3% | 0.83 ± 3.4% | not timed | not timed | 1.90 ± 17.5% | | 0.99 | 3.57 | 2.26 |
| 04-ruff-noqa/compile-real | 1 | 185.47 ± 26.3% | not timed | not timed | 20.80 ± 2.0% | 224.24 ± 3.6% | not timed | not timed | 183.66 ± 13.0% | | 1.01 | 8.91 | 0.83 |
| 05-lexer-veryl/compile-single | 1 | 22.89 ± 7.2% | not timed | not timed | 3.88 ± 2.8% | 10.92 ± 4.6% | not timed | not timed | 22.80 ± 5.3% | | 1.00 | 5.89 | 2.10 |
| 07-unicode-character-data/compile | 1 | 177.14 ± 4.8% | not timed | not timed | 40.14 ± 8.8% | 61.03 ± 8.6% | not timed | not timed | 179.32 ± 3.5% | | 0.99 | 4.41 | 2.90 |
| 09-aws-keys/compile-full | 1 | 75.87 ± 4.5% | not timed | not timed | 12.27 ± 27.7% | 36.45 ± 4.6% | not timed | not timed | 77.04 ± 3.5% | | 0.98 | 6.18 | 2.08 |
| 09-aws-keys/compile-quick | 1 | 282.30 ± 3.5% | not timed | not timed | 75.85 ± 13.2% | 213.66 ± 2.7% | not timed | not timed | 282.00 ± 4.9% | | 1.00 | 3.72 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 85.83 ± 6.0% | not timed | not timed | 17.23 ± 2.3% | 26.39 ± 3.1% | not timed | not timed | 86.39 ± 1.8% | | 0.99 | 4.98 | 3.25 |
| 10-bounded-repeat/compile-capitals | 1 | 133.80 ± 4.7% | not timed | not timed | 12.84 ± 4.3% | 39.26 ± 6.0% | not timed | not timed | 134.36 ± 4.8% | | 1.00 | 10.42 | 3.41 |
| 11-unstructured-to-json/compile | 1 | 282.43 ± 4.4% | not timed | not timed | 63.95 ± 4.4% | 112.00 ± 6.0% | not timed | not timed | 281.37 ± 3.0% | | 1.00 | 4.42 | 2.52 |
| 12-dictionary/compile-single | 1 | 0.47 ± 4.0% | not timed | not timed | 0.10 ± 4.8% | 0.14 ± 16.8% | not timed | not timed | 0.46 ± 6.3% | | 1.01 | 4.73 | 3.22 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 10.09 ± 10.4% | not timed | not timed | 9.45 ± 21.2% | 0.83 ± 16.2% | not timed | not timed | 10.64 ± 11.3% | | 0.95 | 1.07 | 12.16 |
| dictionary/search/english-10 | 690 | 1.85 ± 4.5% | not timed | not timed | 225.71 ± 3.1% | 0.01 ± 1.4% | not timed | not timed | 1.85 ± 1.2% | | 1.00 | 0.0082 | 181.52 |
| dictionary/search/english-15 | 15 | 646.73 ± 3.1% | not timed | not timed | 608.03 ± 2.9% | 0.58 ± 19.9% | not timed | not timed | 638.48 ± 17.9% | | 1.01 | 1.06 | 1123.06 |
| folly/awyer-inn-busted | 1 | 6881.00 ± 4.0% | not timed | not timed | 162.77 ± 1.6% | 71.03 ± 1.5% | not timed | not timed | 6870.82 ± 1.1% | | 1.00 | 42.27 | 96.88 |
| folly/literal-never-match-rare | 0 | 84814.72 ± 1.1% | not timed | not timed | 66854.70 ± 2.2% | 89050.91 ± 0.9% | not timed | not timed | 84837.40 ± 1.3% | | 1.00 | 1.27 | 0.95 |
| folly/literal-never-match-frequent | 0 | 36713.88 ± 11.7% | not timed | not timed | 65369.77 ± 3.3% | 3000.49 ± 1.8% | not timed | not timed | 38587.62 ± 11.2% | | 0.95 | 0.56 | 12.24 |
| folly/literal-never-match-tricksy | 1 | 5090.25 ± 14.4% | not timed | not timed | 8484.97 ± 2.9% | 3763.79 ± 0.6% | not timed | not timed | 5460.39 ± 4.8% | | 0.93 | 0.60 | 1.35 |
| grep/every-line | 239963 | 1800.76 ± 2.8% | not timed | not timed | 1263.59 ± 4.9% | 501.89 ± 14.9% | not timed | not timed | 1790.02 ± 5.1% | | 1.01 | 1.43 | 3.59 |
| grep/long-words-ascii | 5073 | 657.75 ± 0.9% | not timed | not timed | 597.73 ± 5.4% | 65.21 ± 9.6% | not timed | not timed | 649.44 ± 5.7% | | 1.01 | 1.10 | 10.09 |
| imported/leipzig/twain | 811 | 61075.26 ± 54.6% | not timed | not timed | 60892.03 ± 3.1% | 14900.61 ± 52.6% | not timed | not timed | 72959.18 ± 53.4% | | 0.84 | 1.00 | 4.10 |
| imported/leipzig/twain-insensitive | 965 | 18633.52 ± 2.9% | not timed | not timed | 17114.60 ± 4.6% | 64.03 ± 10.7% | not timed | not timed | 18914.24 ± 1.7% | | 0.99 | 1.09 | 290.99 |
| imported/leipzig/shing | 1540 | 41512.21 ± 58.7% | not timed | not timed | 27567.39 ± 62.7% | 51.85 ± 11.4% | not timed | not timed | 41789.73 ± 61.5% | | 0.99 | 1.51 | 800.58 |
| imported/leipzig/huck-saw | 262 | 34248.37 ± 1.2% | not timed | not timed | 23372.38 ± 1.2% | 52.69 ± 4.6% | not timed | not timed | 34110.90 ± 4.6% | | 1.00 | 1.47 | 650.04 |
| imported/leipzig/word-ending-nn | 262 | 712.04 ± 3.4% | not timed | not timed | 720.60 ± 2.8% | 37.55 ± 8.4% | not timed | not timed | 716.44 ± 3.1% | | 0.99 | 0.99 | 18.96 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 14930.24 ± 5.5% | not timed | not timed | 5428.12 ± 1.7% | 15.08 ± 4.0% | not timed | not timed | 14964.98 ± 1.5% | | 1.00 | 2.75 | 990.20 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 28523.35 ± 11.8% | not timed | not timed | 21774.83 ± 6.1% | 29.89 ± 3.6% | not timed | not timed | 28938.39 ± 5.2% | | 0.99 | 1.31 | 954.29 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 6514.80 ± 3.1% | not timed | not timed | 1150.95 ± 4.9% | 17.96 ± 3.8% | not timed | not timed | 6517.24 ± 2.7% | | 1.00 | 5.66 | 362.79 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 711.04 ± 7.6% | not timed | not timed | 703.10 ± 3.9% | 17.44 ± 8.4% | not timed | not timed | 708.02 ± 36.4% | | 1.00 | 1.01 | 40.78 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 713.96 ± 4.4% | not timed | not timed | 723.02 ± 2.2% | 15.56 ± 3.8% | not timed | not timed | 719.41 ± 1.5% | | 0.99 | 0.99 | 45.87 |
| imported/leipzig/tom-river | 2 | 16675.27 ± 2.9% | not timed | not timed | 17454.72 ± 3.8% | 51.73 ± 1.8% | not timed | not timed | 16532.83 ± 2.7% | | 1.01 | 0.96 | 322.37 |
| imported/leipzig/ing | 78424 | 692.88 ± 1.6% | not timed | not timed | 653.48 ± 2.6% | 41.05 ± 24.3% | not timed | not timed | 695.80 ± 3.7% | | 1.00 | 1.06 | 16.88 |
| imported/leipzig/ing-whitespace | 55248 | 874.15 ± 2.6% | not timed | not timed | 2796.37 ± 1.3% | 32.34 ± 5.1% | not timed | not timed | 871.95 ± 2.3% | | 1.00 | 0.31 | 27.03 |
| imported/leipzig/awyer-inn | 209 | 900.69 ± 4.6% | not timed | not timed | 17703.28 ± 2.7% | 33.48 ± 7.9% | not timed | not timed | 902.97 ± 5.8% | | 1.00 | 0.0509 | 26.91 |
| imported/leipzig/quotes-bounded | 8886 | 2421.28 ± 2.2% | not timed | not timed | 3828.34 ± 1.2% | 57.82 ± 9.6% | not timed | not timed | 2429.93 ± 2.4% | | 1.00 | 0.63 | 41.88 |
| imported/leipzig/non-ascii-alternate | 2 | 61399.96 ± 3.3% | not timed | not timed | 24274.10 ± 2.0% | 80.50 ± 3.1% | not timed | not timed | 62095.06 ± 8.7% | | 0.99 | 2.53 | 762.77 |
| imported/leipzig/math-symbols | 69 | 4234.29 ± 4.2% | not timed | not timed | 707.29 ± 28.8% | 55.03 ± 5.0% | not timed | not timed | 4216.34 ± 1.7% | | 1.00 | 5.99 | 76.94 |
| imported/leipzig/bounded-strings-ending-z | 0 | 704.03 ± 3.5% | not timed | not timed | 706.87 ± 1.9% | 33.63 ± 5.3% | not timed | not timed | 708.20 ± 4.2% | | 0.99 | 1.00 | 20.93 |
| imported/lh3lh3-reb/uri | 17549 | 982.73 ± 2.4% | not timed | not timed | 1472.47 ± 3.6% | 39.30 ± 1.7% | not timed | not timed | 954.83 ± 6.0% | | 1.03 | 0.67 | 25.01 |
| imported/lh3lh3-reb/email | 15057 | 969.98 ± 1.2% | not timed | not timed | 1434.32 ± 2.0% | 41.80 ± 3.8% | not timed | not timed | 949.59 ± 2.4% | | 1.02 | 0.68 | 23.20 |
| imported/lh3lh3-reb/date | 668 | 1132.26 ± 4.1% | not timed | not timed | 1246.27 ± 28.8% | 69.39 ± 4.6% | not timed | not timed | 1118.66 ± 2.5% | | 1.01 | 0.91 | 16.32 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 918.22 ± 2.5% | not timed | not timed | 525.79 ± 5.3% | 21.46 ± 4.8% | not timed | not timed | 913.96 ± 0.8% | | 1.00 | 1.75 | 42.79 |
| imported/mariomka/email | 92 | 51498.09 ± 4.9% | not timed | not timed | 69889.27 ± 2.9% | 48.55 ± 1.7% | not timed | not timed | 50352.85 ± 8.6% | | 1.02 | 0.74 | 1060.80 |
| imported/mariomka/uri | 5301 | 8521.72 ± 4.0% | not timed | not timed | 9036.85 ± 9.0% | 49.40 ± 1.9% | not timed | not timed | 8561.26 ± 10.3% | | 1.00 | 0.94 | 172.49 |
| imported/mariomka/ip | 5 | 2367.92 ± 4.3% | not timed | not timed | 2733.39 ± 7.8% | 32.30 ± 1.9% | not timed | not timed | 2407.73 ± 5.5% | | 0.98 | 0.87 | 73.30 |
| imported/rsc/no-exponential | 0 | 1173.72 ± 1.0% | not timed | not timed | 746.73 ± 16.7% | 31.80 ± 2.8% | not timed | not timed | 1122.53 ± 0.5% | | 1.05 | 1.57 | 36.91 |
| imported/rsc/literal | 1 | 1337.99 ± 9.0% | not timed | not timed | 3030.84 ± 2.9% | 314.79 ± 5.6% | not timed | not timed | 1331.15 ± 5.7% | | 1.01 | 0.44 | 4.25 |
| imported/rsc/not-literal | 2 | 1430.74 ± 2.8% | not timed | not timed | 1307.24 ± 9.6% | 73.21 ± 7.2% | not timed | not timed | 1419.00 ± 1.8% | | 1.01 | 1.09 | 19.54 |
| imported/rsc/match-class | 1 | 2550.62 ± 2.8% | not timed | not timed | 3045.27 ± 1.7% | 94.70 ± 6.6% | not timed | not timed | 2508.40 ± 2.3% | | 1.02 | 0.84 | 26.93 |
| imported/rsc/match-class-in-range | 1 | 2508.75 ± 14.6% | not timed | not timed | 4695.63 ± 2.5% | 96.83 ± 9.4% | not timed | not timed | 2533.59 ± 8.7% | | 0.99 | 0.53 | 25.91 |
| imported/rsc/match-class-unicode | 1 | 668.90 ± 3.1% | not timed | not timed | 651.54 ± 2.8% | 115.73 ± 5.6% | not timed | not timed | 671.46 ± 2.2% | | 1.00 | 1.03 | 5.78 |
| imported/rsc/anchored-literal-short-non-match | 0 | 2490.09 ± 1.1% | not timed | not timed | 1675.77 ± 1.5% | 441.46 ± 3.0% | not timed | not timed | 2474.07 ± 5.3% | | 1.01 | 1.49 | 5.64 |
| imported/rsc/anchored-literal-long-non-match | 0 | 36981.49 ± 2.3% | not timed | not timed | 25675.79 ± 1.2% | 6531.53 ± 3.6% | not timed | not timed | 36405.99 ± 44.5% | | 1.02 | 1.44 | 5.66 |
| imported/rsc/anchored-literal-short-match | 4 | 1247.99 ± 6.2% | not timed | not timed | 936.39 ± 1.1% | 143.68 ± 6.5% | not timed | not timed | 1260.04 ± 3.3% | | 0.99 | 1.33 | 8.69 |
| imported/rsc/anchored-literal-long-match | 4 | 18841.86 ± 3.0% | not timed | not timed | 13853.32 ± 2.7% | 2150.60 ± 8.3% | not timed | not timed | 18281.51 ± 4.1% | | 1.03 | 1.36 | 8.76 |
| imported/rsc/one-pass-short | 17 | 705.50 ± 8.0% | not timed | not timed | 445.79 ± 2.8% | 49.09 ± 6.8% | not timed | not timed | 620.74 ± 2.7% | | 1.14 | 1.58 | 14.37 |
| imported/rsc/one-pass-short-not | 17 | 459.94 ± 2.5% | not timed | not timed | 468.69 ± 5.1% | 43.79 ± 6.2% | not timed | not timed | 441.25 ± 5.2% | | 1.04 | 0.98 | 10.50 |
| imported/rsc/one-pass-long-prefix | 26 | 537.88 ± 17.9% | not timed | not timed | 516.86 ± 2.1% | 158.01 ± 38.2% | not timed | not timed | 584.83 ± 46.8% | | 0.92 | 1.04 | 3.40 |
| imported/rsc/one-pass-long-prefix-not | 26 | 542.35 ± 3.0% | not timed | not timed | 486.72 ± 2.2% | 107.99 ± 14.3% | not timed | not timed | 574.31 ± 7.4% | | 0.94 | 1.11 | 5.02 |
| imported/rsc/long-needle1 | 31 | 86621.66 ± 15.3% | not timed | not timed | 66566.63 ± 2.3% | 5.93 ± 2.9% | not timed | not timed | 85628.52 ± 13.2% | | 1.01 | 1.30 | 14598.20 |
| imported/rsc/long-needle2 | 31 | 86894.64 ± 1.2% | not timed | not timed | 357.92 ± 1.8% | 5.91 ± 3.5% | not timed | not timed | 86894.01 ± 1.2% | | 1.00 | 242.77 | 14705.39 |
| imported/rsc/easy0-32 | 26 | 1941.29 ± 5.5% | not timed | not timed | 2799.27 ± 0.7% | 224.94 ± 9.1% | not timed | not timed | 1908.95 ± 8.2% | | 1.02 | 0.69 | 8.63 |
| imported/rsc/easy0-1k | 26 | 29787.26 ± 4.7% | not timed | not timed | 30764.48 ± 26.6% | 3417.03 ± 44.5% | not timed | not timed | 29888.91 ± 8.8% | | 1.00 | 0.97 | 8.72 |
| imported/rsc/easy0-32k | 26 | 82547.50 ± 3.4% | not timed | not timed | 64148.80 ± 2.8% | 39081.25 ± 32.8% | not timed | not timed | 83580.88 ± 3.3% | | 0.99 | 1.29 | 2.11 |
| imported/rsc/easy0-1mb | 26 | 84735.13 ± 3.6% | not timed | not timed | 66697.89 ± 2.9% | 98529.19 ± 5.3% | not timed | not timed | 84406.04 ± 4.1% | | 1.00 | 1.27 | 0.86 |
| imported/rsc/easy1-32 | 19 | 1318.69 ± 1.9% | not timed | not timed | 1231.67 ± 2.6% | 207.78 ± 10.9% | not timed | not timed | 1326.41 ± 1.6% | | 0.99 | 1.07 | 6.35 |
| imported/rsc/easy1-1k | 19 | 26992.80 ± 4.8% | not timed | not timed | 23636.79 ± 1.2% | 3527.52 ± 19.6% | not timed | not timed | 26858.97 ± 3.4% | | 1.00 | 1.14 | 7.65 |
| imported/rsc/easy1-32k | 19 | 859833.48 ± 1.7% | not timed | not timed | 848624.91 ± 2.2% | 41716.60 ± 15.6% | not timed | not timed | 853124.09 ± 4.2% | | 1.01 | 1.01 | 20.61 |
| imported/rsc/easy1-1mb | 19 | 27174186.23 ± 36.2% | not timed | not timed | 27051114.44 ± 4.0% | 100917.32 ± 2.0% | not timed | not timed | 27285902.94 ± 10.1% | | 1.00 | 1.00 | 269.27 |
| imported/rsc/medium-32 | 27 | 1182.78 ± 2.8% | not timed | not timed | 1136.80 ± 2.5% | 103.63 ± 22.2% | not timed | not timed | 1170.28 ± 2.7% | | 1.01 | 1.04 | 11.41 |
| imported/rsc/medium-1k | 27 | 20793.66 ± 1.5% | not timed | not timed | 19568.38 ± 3.0% | 113.39 ± 3.0% | not timed | not timed | 21070.26 ± 2.1% | | 0.99 | 1.06 | 183.38 |
| imported/rsc/medium-32k | 27 | 662333.34 ± 3.9% | not timed | not timed | 637091.75 ± 1.7% | 78.58 ± 3.4% | not timed | not timed | 664203.93 ± 1.2% | | 1.00 | 1.04 | 8428.65 |
| imported/rsc/medium-1mb | 27 | 20960216.78 ± 9.8% | not timed | not timed | 20668727.46 ± 3.8% | 78.26 ± 38.8% | not timed | not timed | 21170803.38 ± 1.3% | | 0.99 | 1.01 | 267814.40 |
| imported/rsc/hard-32 | 58 | 568.11 ± 10.4% | not timed | not timed | 523.83 ± 2.5% | 75.02 ± 10.4% | not timed | not timed | 557.46 ± 8.6% | | 1.02 | 1.08 | 7.57 |
| imported/rsc/hard-1k | 27 | 20074.69 ± 1.4% | not timed | not timed | 19098.65 ± 11.6% | 60.54 ± 2.7% | not timed | not timed | 20088.73 ± 2.8% | | 1.00 | 1.05 | 331.59 |
| imported/rsc/hard-32k | 27 | 626662.87 ± 3.1% | not timed | not timed | 629828.07 ± 1.5% | 47.71 ± 5.5% | not timed | not timed | 623781.25 ± 3.7% | | 1.00 | 0.99 | 13134.69 |
| imported/rsc/hard-1mb | 51 | 11401548.67 ± 2.7% | not timed | not timed | 9256797.67 ± 33.7% | 48.17 ± 1.8% | not timed | not timed | 11303798.84 ± 2.7% | | 1.01 | 1.23 | 236697.83 |
| imported/rsc/reallyhard0-32 | 58 | 366.74 ± 33.6% | not timed | not timed | 338.86 ± 38.2% | 75.08 ± 14.5% | not timed | not timed | 365.20 ± 6.0% | | 1.00 | 1.08 | 4.89 |
| imported/rsc/reallyhard0-1k | 27 | 697.95 ± 1.8% | not timed | not timed | 694.12 ± 14.0% | 60.89 ± 16.1% | not timed | not timed | 701.45 ± 3.9% | | 1.00 | 1.01 | 11.46 |
| imported/rsc/reallyhard0-32k | 27 | 697.98 ± 3.2% | not timed | not timed | 697.37 ± 1.4% | 47.52 ± 6.1% | not timed | not timed | 699.71 ± 3.4% | | 1.00 | 1.00 | 14.69 |
| imported/rsc/reallyhard0-1mb | 51 | 709.60 ± 1.6% | not timed | not timed | 703.58 ± 1.9% | 47.63 ± 11.2% | not timed | not timed | 711.61 ± 3.2% | | 1.00 | 1.01 | 14.90 |
| imported/rsc/reallyreallyhard0-32 | 47 | 427.24 ± 3.2% | not timed | not timed | 268.83 ± 1.9% | 91.47 ± 10.1% | not timed | not timed | 431.20 ± 17.7% | | 0.99 | 1.59 | 4.67 |
| imported/rsc/reallyreallyhard0-1k | 16 | 11480.48 ± 2.4% | not timed | not timed | 10763.52 ± 1.2% | 49.36 ± 2.4% | not timed | not timed | 11407.67 ± 3.1% | | 1.01 | 1.07 | 232.57 |
| imported/rsc/reallyreallyhard0-32k | 16 | 72558.31 ± 5.3% | not timed | not timed | 57816.57 ± 16.9% | 39.20 ± 3.0% | not timed | not timed | 72719.35 ± 4.5% | | 1.00 | 1.25 | 1850.93 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 95541.88 ± 2.8% | not timed | not timed | 66054.89 ± 2.8% | 39.47 ± 21.1% | not timed | not timed | 96073.75 ± 2.8% | | 0.99 | 1.45 | 2420.39 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 408.81 ± 1.6% | not timed | not timed | 275.02 ± 19.3% | 93.10 ± 11.8% | not timed | not timed | 404.89 ± 6.1% | | 1.01 | 1.49 | 4.39 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 9071.52 ± 33.6% | not timed | not timed | 10445.46 ± 4.2% | 50.29 ± 1.8% | not timed | not timed | 9193.89 ± 5.2% | | 0.99 | 0.87 | 180.39 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 70890.22 ± 5.6% | not timed | not timed | 57721.89 ± 3.0% | 39.67 ± 1.2% | not timed | not timed | 69413.22 ± 4.7% | | 1.02 | 1.23 | 1787.11 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 85322.42 ± 1.7% | not timed | not timed | 66672.44 ± 1.4% | 40.01 ± 20.0% | not timed | not timed | 84677.18 ± 21.6% | | 1.01 | 1.28 | 2132.76 |
| imported/sherlock/name-sherlock | 776 | 62508.35 ± 7.6% | not timed | not timed | 51632.06 ± 3.6% | 14555.60 ± 43.2% | not timed | not timed | 65338.05 ± 2.3% | | 0.96 | 1.21 | 4.29 |
| imported/sherlock/name-holmes | 2766 | 37158.39 ± 5.2% | not timed | not timed | 35937.85 ± 1.0% | 5117.65 ± 1.1% | not timed | not timed | 37029.49 ± 3.2% | | 1.00 | 1.03 | 7.26 |
| imported/sherlock/name-sherlock-holmes | 1365 | 63580.66 ± 6.5% | not timed | not timed | 51992.46 ± 3.7% | 13307.55 ± 2.6% | not timed | not timed | 65365.42 ± 6.8% | | 0.97 | 1.22 | 4.78 |
| imported/sherlock/name-sherlock-casei | 816 | 65677.09 ± 13.0% | not timed | not timed | 14422.22 ± 0.9% | 52.13 ± 1.5% | not timed | not timed | 65874.72 ± 3.7% | | 1.00 | 4.55 | 1259.86 |
| imported/sherlock/name-holmes-casei | 2802 | 31241.85 ± 2.8% | not timed | not timed | 8907.22 ± 2.5% | 63.42 ± 4.9% | not timed | not timed | 31482.32 ± 2.6% | | 0.99 | 3.51 | 492.64 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 50483.15 ± 4.3% | not timed | not timed | 13431.41 ± 13.3% | 50.79 ± 6.3% | not timed | not timed | 51277.84 ± 4.2% | | 0.98 | 3.76 | 994.04 |
| imported/sherlock/name-whitespace | 1461 | 37563.98 ± 2.6% | not timed | not timed | 36071.17 ± 4.6% | 11600.95 ± 22.1% | not timed | not timed | 37432.20 ± 1.1% | | 1.00 | 1.04 | 3.24 |
| imported/sherlock/name-alt1 | 1142 | 43979.79 ± 3.3% | not timed | not timed | 44169.06 ± 24.0% | 5691.83 ± 36.1% | not timed | not timed | 43744.65 ± 39.2% | | 1.01 | 1.00 | 7.73 |
| imported/sherlock/name-alt2 | 3542 | 27854.77 ± 2.8% | not timed | not timed | 11878.96 ± 5.5% | 53.58 ± 1.3% | not timed | not timed | 27849.18 ± 3.8% | | 1.00 | 2.34 | 519.84 |
| imported/sherlock/name-alt3 | 4507 | 17281.52 ± 1.1% | not timed | not timed | 11132.73 ± 2.4% | 16.96 ± 3.5% | not timed | not timed | 17307.83 ± 0.7% | | 1.00 | 1.55 | 1019.22 |
| imported/sherlock/name-alt3-casei | 4593 | 2500.85 ± 7.3% | not timed | not timed | 1660.80 ± 10.5% | 10.68 ± 2.9% | not timed | not timed | 2482.61 ± 8.5% | | 1.01 | 1.51 | 234.22 |
| imported/sherlock/name-alt4 | 3686 | 12492.53 ± 3.5% | not timed | not timed | 9234.92 ± 8.4% | 53.74 ± 1.9% | not timed | not timed | 12343.31 ± 1.3% | | 1.01 | 1.35 | 232.45 |
| imported/sherlock/name-alt4-casei | 4254 | 6968.41 ± 2.9% | not timed | not timed | 5040.23 ± 2.0% | 31.92 ± 2.4% | not timed | not timed | 6953.85 ± 0.9% | | 1.00 | 1.38 | 218.29 |
| imported/sherlock/name-alt5 | 4028 | 22599.06 ± 4.4% | not timed | not timed | 11767.36 ± 4.8% | 39.12 ± 3.6% | not timed | not timed | 22377.23 ± 6.1% | | 1.01 | 1.92 | 577.73 |
| imported/sherlock/name-alt5-casei | 4104 | 9233.61 ± 4.5% | not timed | not timed | 3814.25 ± 3.1% | 23.53 ± 12.5% | not timed | not timed | 9274.05 ± 5.2% | | 1.00 | 2.42 | 392.42 |
| imported/sherlock/no-match-uncommon | 0 | 89197.86 ± 6.1% | not timed | not timed | 89796.83 ± 3.3% | 78805.24 ± 7.2% | not timed | not timed | 88848.66 ± 4.7% | | 1.00 | 0.99 | 1.13 |
| imported/sherlock/no-match-common | 0 | 88789.32 ± 2.1% | not timed | not timed | 90868.66 ± 1.9% | 2377.57 ± 0.7% | not timed | not timed | 88095.37 ± 2.2% | | 1.01 | 0.98 | 37.34 |
| imported/sherlock/no-match-really-common | 0 | 59893.35 ± 1.3% | not timed | not timed | 66681.52 ± 0.8% | 2375.56 ± 2.3% | not timed | not timed | 61447.37 ± 2.3% | | 0.97 | 0.90 | 25.21 |
| imported/sherlock/the-lower | 21654 | 3898.41 ± 14.1% | not timed | not timed | 3856.09 ± 3.5% | 366.76 ± 23.3% | not timed | not timed | 3970.30 ± 2.8% | | 0.98 | 1.01 | 10.63 |
| imported/sherlock/the-upper | 2223 | 25608.51 ± 10.3% | not timed | not timed | 33339.11 ± 2.4% | 4306.90 ± 23.2% | not timed | not timed | 25843.10 ± 10.2% | | 0.99 | 0.77 | 5.95 |
| imported/sherlock/the-casei | 23961 | 3570.41 ± 2.5% | not timed | not timed | 1683.43 ± 1.4% | 58.18 ± 18.1% | not timed | not timed | 3572.14 ± 2.1% | | 1.00 | 2.12 | 61.36 |
| imported/sherlock/everything-greedy | 581881 | 366.72 ± 19.5% | not timed | not timed | 218.14 ± 0.4% | 47.29 ± 48.1% | not timed | not timed | 368.02 ± 3.4% | | 1.00 | 1.68 | 7.76 |
| imported/sherlock/everything-greedy-nl | 594933 | 554.88 ± 4.8% | not timed | not timed | 288.05 ± 3.2% | 51.86 ± 2.7% | not timed | not timed | 554.85 ± 2.3% | | 1.00 | 1.93 | 10.70 |
| imported/sherlock/letters | 447175 | 95.08 ± 8.4% | not timed | not timed | 44.89 ± 2.3% | 8.18 ± 26.1% | not timed | not timed | 98.29 ± 5.0% | | 0.97 | 2.12 | 11.62 |
| imported/sherlock/letters-upper | 14180 | 532.40 ± 1.5% | not timed | not timed | 451.11 ± 2.5% | 41.29 ± 31.7% | not timed | not timed | 551.50 ± 1.7% | | 0.97 | 1.18 | 12.89 |
| imported/sherlock/letters-lower | 432995 | 96.95 ± 4.3% | not timed | not timed | 44.15 ± 12.1% | 8.07 ± 35.6% | not timed | not timed | 96.85 ± 18.2% | | 1.00 | 2.20 | 12.02 |
| imported/sherlock/words | 447639 | 154.52 ± 8.9% | not timed | not timed | 106.09 ± 25.2% | 20.36 ± 26.1% | not timed | not timed | 155.66 ± 13.7% | | 0.99 | 1.46 | 7.59 |
| imported/sherlock/before-holmes | 4073 | 19163.25 ± 4.6% | not timed | not timed | 16662.14 ± 2.2% | 37.23 ± 2.1% | not timed | not timed | 19289.15 ± 4.0% | | 0.99 | 1.15 | 514.67 |
| imported/sherlock/before-after-holmes | 2593 | 19265.42 ± 2.1% | not timed | not timed | 19097.85 ± 3.9% | 37.24 ± 1.8% | not timed | not timed | 19363.05 ± 5.8% | | 0.99 | 1.01 | 517.33 |
| imported/sherlock/holmes-cochar-watson | 150 | 11975.74 ± 2.9% | not timed | not timed | 9714.52 ± 3.1% | 52.96 ± 1.5% | not timed | not timed | 11830.47 ± 2.5% | | 1.01 | 1.23 | 226.13 |
| imported/sherlock/holmes-coword-watson | 14309 | 1495.59 ± 1.6% | not timed | not timed | 1472.82 ± 1.7% | 10.94 ± 8.1% | not timed | not timed | 1501.24 ± 2.4% | | 1.00 | 1.02 | 136.65 |
| imported/sherlock/quotes | 14437 | 1679.85 ± 3.3% | not timed | not timed | 2882.70 ± 2.7% | 53.61 ± 3.1% | not timed | not timed | 1682.37 ± 2.9% | | 1.00 | 0.58 | 31.33 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 716.60 ± 4.4% | not timed | not timed | 41469.66 ± 5.5% | 60.85 ± 3.5% | not timed | not timed | 719.04 ± 3.7% | | 1.00 | 0.0173 | 11.78 |
| imported/sherlock/word-ending-n | 35297 | 558.77 ± 3.0% | not timed | not timed | 475.45 ± 8.4% | 33.87 ± 40.0% | not timed | not timed | 556.32 ± 4.0% | | 1.00 | 1.18 | 16.50 |
| imported/sherlock/repeated-class-negation | 2130 | 23904.17 ± 9.6% | not timed | not timed | 22865.26 ± 51.6% | 14.96 ± 7.3% | not timed | not timed | 23962.09 ± 3.1% | | 1.00 | 1.05 | 1597.78 |
| imported/sherlock/ing-suffix | 20547 | 691.28 ± 2.0% | not timed | not timed | 601.79 ± 1.9% | 43.81 ± 2.1% | not timed | not timed | 687.41 ± 6.6% | | 1.01 | 1.15 | 15.78 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 719.10 ± 4.2% | not timed | not timed | 3619.40 ± 1.6% | 31.21 ± 17.8% | not timed | not timed | 721.40 ± 6.5% | | 1.00 | 0.20 | 23.04 |
| opt/accelerate/whole-line | 239963 | 656.19 ± 2.6% | not timed | not timed | 498.43 ± 62.2% | 124.95 ± 33.6% | not timed | not timed | 644.86 ± 4.1% | | 1.02 | 1.32 | 5.25 |
| opt/accelerate/non-dna | 16745 | 584.09 ± 10.0% | not timed | not timed | 553.74 ± 4.0% | 47.08 ± 22.6% | not timed | not timed | 590.99 ± 0.9% | | 0.99 | 1.05 | 12.41 |
| opt/backtrack/words-english | 40536 | 179.82 ± 15.8% | not timed | not timed | 140.74 ± 21.9% | 29.50 ± 9.0% | not timed | not timed | 181.50 ± 1.5% | | 0.99 | 1.28 | 6.10 |
| opt/fixed-length/too-small-ascii | 0 | 566.85 ± 3.2% | not timed | not timed | 1119.89 ± 4.7% | 165.46 ± 5.5% | not timed | not timed | 567.38 ± 4.2% | | 1.00 | 0.51 | 3.43 |
| opt/fixed-length/too-big-ascii | 0 | 6304.76 ± 3.5% | not timed | not timed | 8819.23 ± 7.2% | 212.18 ± 10.6% | not timed | not timed | 6435.17 ± 3.4% | | 0.98 | 0.71 | 29.71 |
| opt/fixed-length/go33484-1 | 0 | 1230964.43 ± 16.8% | not timed | not timed | 1696230.39 ± 2.5% | 121760.51 ± 1.3% | not timed | not timed | 1236536.15 ± 57.6% | | 1.00 | 0.73 | 10.11 |
| opt/fixed-length/go33484-2 | 0 | 1207957.49 ± 52.6% | not timed | not timed | 1685382.20 ± 58.3% | 44847.46 ± 1.1% | not timed | not timed | 1234254.85 ± 0.8% | | 0.98 | 0.72 | 26.93 |
| opt/fixed-length/go33484-3 | 0 | 2916.99 ± 5.2% | not timed | not timed | 166539.38 ± 42.7% | 1292.21 ± 3.0% | not timed | not timed | 2968.05 ± 2.1% | | 0.98 | 0.0175 | 2.26 |
| opt/literal-alt/one-pattern | 1 | 708.86 ± 2.7% | not timed | not timed | 688.30 ± 5.0% | 0.62 ± 8.4% | not timed | not timed | 701.55 ± 5.8% | | 1.01 | 1.03 | 1152.07 |
| opt/onepass/fn-predicate | 916 | 591.40 ± 2.3% | not timed | not timed | 510.06 ± 0.8% | 282.33 ± 16.4% | not timed | not timed | 597.56 ± 14.1% | | 0.99 | 1.16 | 2.09 |
| opt/onepass/first-three-words-english | 35128 | 233.15 ± 8.0% | not timed | not timed | 302.11 ± 1.0% | 109.53 ± 7.1% | not timed | not timed | 233.48 ± 7.5% | | 1.00 | 0.77 | 2.13 |
| opt/prefilter/literal-english | 1 | 86641.64 ± 1.6% | not timed | not timed | 67354.57 ± 7.9% | 34272.46 ± 2.3% | not timed | not timed | 86836.14 ± 1.6% | | 1.00 | 1.29 | 2.53 |
| opt/prefilter/literal-casei-english | 1 | 66397.76 ± 3.4% | not timed | not timed | 18139.34 ± 2.3% | 51.61 ± 2.0% | not timed | not timed | 66971.16 ± 2.8% | | 0.99 | 3.66 | 1286.64 |
| opt/prefilter/literal-russian | 1 | 87272.04 ± 1.8% | not timed | not timed | 65425.01 ± 2.2% | 4055.22 ± 5.9% | not timed | not timed | 87116.14 ± 1.8% | | 1.00 | 1.33 | 21.52 |
| opt/prefilter/literal-casei-russian | 1 | 36412.97 ± 2.3% | not timed | not timed | 13003.55 ± 2.0% | 56.61 ± 4.7% | not timed | not timed | 36493.73 ± 0.6% | | 1.00 | 2.80 | 643.23 |
| opt/prefilter/rust-functions | 948 | 19881.38 ± 7.1% | not timed | not timed | 16157.62 ± 13.2% | 2378.00 ± 2.9% | not timed | not timed | 19525.88 ± 10.2% | | 1.02 | 1.23 | 8.36 |
| opt/reverse-anchored/word-end | 1 | 53185267.66 ± 3.6% | not timed | not timed | 36585213.09 ± 6.4% | 83.05 ± 2.2% | not timed | not timed | 53812751.75 ± 38.9% | | 0.99 | 1.45 | 640412.16 |
| opt/reverse-inner/holmes | 2593 | 19204.19 ± 1.3% | not timed | not timed | 18760.71 ± 2.3% | 36.14 ± 16.1% | not timed | not timed | 19099.72 ± 9.9% | | 1.01 | 1.02 | 531.40 |
| opt/reverse-inner/email | 47 | 92385.25 ± 2.6% | not timed | not timed | 95425.25 ± 64.0% | 48.43 ± 17.1% | not timed | not timed | 92412.37 ± 32.3% | | 1.00 | 0.97 | 1907.72 |
| opt/reverse-inner/factored-prefix | 3542 | 705.99 ± 1.8% | not timed | not timed | 695.40 ± 4.2% | 19.56 ± 6.2% | not timed | not timed | 706.11 ± 1.8% | | 1.00 | 1.02 | 36.10 |
| opt/reverse-inner/no-quadratic-backward | 0 | 6802.56 ± 4.6% | not timed | not timed | 708.63 ± 2.8% | 118.86 ± 4.0% | not timed | not timed | 6759.35 ± 4.8% | | 1.01 | 9.60 | 57.23 |
| opt/reverse-inner/no-quadratic-forward | 0 | 805.32 ± 10.9% | not timed | not timed | 328.23 ± 3.3% | 38.14 ± 12.2% | not timed | not timed | 812.68 ± 4.8% | | 0.99 | 2.45 | 21.12 |
| opt/reverse-suffix/holmes | 4073 | 19026.78 ± 2.9% | not timed | not timed | 16298.08 ± 3.2% | 36.92 ± 4.1% | not timed | not timed | 19201.53 ± 4.9% | | 0.99 | 1.17 | 515.30 |
| opt/reverse-suffix/no-quadratic | 0 | 6703.11 ± 5.5% | not timed | not timed | 711.66 ± 1.9% | 119.86 ± 16.4% | not timed | not timed | 6696.34 ± 30.2% | | 1.00 | 9.42 | 55.92 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 195.80 ± 53.6% | not timed | not timed | 250.09 ± 4.5% | 22.65 ± 108.8% | not timed | not timed | 213.21 ± 42.5% | | 0.92 | 0.78 | 8.65 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 208.62 ± 9.3% | not timed | not timed | 263.28 ± 2.5% | 22.59 ± 12.5% | not timed | not timed | 211.60 ± 5.9% | | 0.99 | 0.79 | 9.23 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.46 ± 1.3% | not timed | not timed | 0.77 ± 0.7% | 165.82 ± 3.4% | not timed | not timed | 0.47 ± 2.0% | | 0.98 | 0.60 | 0.0028 |
| reported/i1095-word-repetition/ascii-search | 256 | 376.50 ± 1.1% | not timed | not timed | 345.75 ± 1.0% | 155.75 ± 11.2% | not timed | not timed | 373.40 ± 2.3% | | 1.01 | 1.09 | 2.42 |
| reported/i13-subset-regex/original-ascii | 4094 | 14765.96 ± 23.7% | not timed | not timed | 5309.33 ± 4.8% | 15.05 ± 3.0% | not timed | not timed | 14802.14 ± 3.4% | | 1.00 | 2.78 | 981.07 |
| reported/i13-subset-regex/original-unicode | 4094 | 14847.25 ± 4.9% | not timed | not timed | 280.90 ± 2.4% | 15.24 ± 3.1% | not timed | not timed | 14735.02 ± 2.9% | | 1.01 | 52.86 | 974.08 |
| reported/i13-subset-regex/big-ascii | 1955 | 13729.14 ± 9.8% | not timed | not timed | 77.71 ± 4.5% | 13.12 ± 4.6% | not timed | not timed | 13763.35 ± 5.2% | | 1.00 | 176.68 | 1046.52 |
| reported/i13-subset-regex/big-unicode | 1955 | 13768.07 ± 8.5% | not timed | not timed | 13.82 ± 56.3% | 13.17 ± 2.2% | not timed | not timed | 13812.62 ± 2.7% | | 1.00 | 996.45 | 1045.48 |
| reported/i13-subset-regex/huge-ascii | 55 | 12662.92 ± 3.8% | not timed | not timed | 13.16 ± 4.5% | 12.26 ± 1.4% | not timed | not timed | 12365.79 ± 2.9% | | 1.02 | 961.92 | 1032.80 |
| reported/i13-subset-regex/huge-unicode | 55 | 12730.64 ± 7.5% | not timed | not timed | 13.41 ± 2.2% | 12.53 ± 3.7% | not timed | not timed | 12368.46 ± 58.3% | | 1.03 | 949.35 | 1016.13 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 5.61 ± 3.3% | not timed | not timed | 13.27 ± 6.4% | 12.29 ± 5.6% | not timed | not timed | 5.72 ± 2.6% | | 0.98 | 0.42 | 0.46 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 7.50 ± 2.6% | not timed | not timed | 13.08 ± 2.4% | 12.43 ± 7.6% | not timed | not timed | 7.53 ± 2.9% | | 1.00 | 0.57 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 672.79 ± 7.7% | not timed | not timed | 210.23 ± 1.6% | 9.69 ± 1.3% | not timed | not timed | 675.36 ± 13.1% | | 1.00 | 3.20 | 69.45 |
| reported/i787-keywords/opt-ascii | 5674 | 682.96 ± 4.3% | not timed | not timed | 343.57 ± 5.3% | 17.03 ± 26.3% | not timed | not timed | 676.85 ± 3.7% | | 1.01 | 1.99 | 40.10 |
| slow/quadratic-regex-1x | 100 | 10.54 ± 1.9% | not timed | not timed | 7.99 ± 2.2% | 0.08 ± 7.6% | not timed | not timed | 10.37 ± 5.3% | | 1.02 | 1.32 | 136.51 |
| slow/quadratic-regex-2x | 199 | 4.55 ± 5.1% | not timed | not timed | 3.96 ± 1.9% | 0.02 ± 2.1% | not timed | not timed | 4.47 ± 2.3% | | 1.02 | 1.15 | 225.21 |
| slow/quadratic-haystack-1x | 100 | 36.89 ± 32.7% | not timed | not timed | 16.14 ± 17.1% | 1.43 ± 7.8% | not timed | not timed | 38.96 ± 29.8% | | 0.95 | 2.29 | 25.82 |
| slow/quadratic-haystack-2x | 200 | 30.01 ± 6.5% | not timed | not timed | 7.92 ± 2.4% | 0.79 ± 15.9% | not timed | not timed | 31.25 ± 6.2% | | 0.96 | 3.79 | 37.86 |
| unicode/codepoints/any-one | 1112064 | 495.88 ± 7.6% | not timed | not timed | 365.13 ± 2.1% | 27.74 ± 31.7% | not timed | not timed | 494.55 ± 9.0% | | 1.00 | 1.36 | 17.87 |
| unicode/codepoints/any-all | 4382592 | 335.93 ± 1.7% | not timed | not timed | 334.78 ± 2.6% | 189.68 ± 6.5% | not timed | not timed | 337.51 ± 1.6% | | 1.00 | 1.00 | 1.77 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 11.63 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 717.93 ± 22.7% | not timed | not timed | 701.78 ± 30.7% | 221.98 ± 58.5% | not timed | not timed | 717.56 ± 4.3% | | 1.00 | 1.02 | 3.23 |
| unicode/overlapping-words/ascii | 6156 | 44.27 ± 6.4% | not timed | not timed | 54.96 ± 1.3% | 5.97 ± 5.2% | not timed | not timed | 43.34 ± 3.8% | | 1.02 | 0.81 | 7.41 |
| unicode/overlapping-words/english | 6156 | 2.09 ± 5.0% | not timed | not timed | 5.10 ± 2.2% | 3.63 ± 5.2% | not timed | not timed | 2.13 ± 3.4% | | 0.98 | 0.41 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 1.89 ± 7.7% | not timed | not timed | 4.92 ± 7.8% | 9.19 ± 15.4% | not timed | not timed | 1.91 ± 3.3% | | 0.99 | 0.38 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 171.82 ± 3.0% | not timed | not timed | 104.83 ± 11.2% | 17.34 ± 73.9% | not timed | not timed | 170.97 ± 0.9% | | 1.00 | 1.64 | 9.91 |
| unicode/word/boundary-long-english | 3466 | 709.67 ± 0.8% | not timed | not timed | 692.19 ± 1.6% | 48.49 ± 2.0% | not timed | not timed | 708.76 ± 0.9% | | 1.00 | 1.03 | 14.64 |
| unicode/word/around-holmes-english | 27 | 78184.28 ± 1.8% | not timed | not timed | 63123.04 ± 6.0% | 34.07 ± 1.8% | not timed | not timed | 77532.38 ± 2.3% | | 1.01 | 1.24 | 2295.13 |
| wild/bibleref/long | 874 | 665.45 ± 1.0% | not timed | not timed | 674.09 ± 2.4% | 10.94 ± 3.6% | not timed | not timed | 666.22 ± 1.1% | | 1.00 | 0.99 | 60.81 |
| wild/bibleref/short | 30 | 32.75 ± 21.1% | not timed | not timed | 44.30 ± 23.8% | 22.23 ± 7.9% | not timed | not timed | 32.49 ± 18.2% | | 1.01 | 0.74 | 1.47 |
| wild/bibleref/line | 874 | 682.17 ± 6.5% | not timed | not timed | 327.97 ± 2.1% | 12.77 ± 6.3% | not timed | not timed | 683.06 ± 1.0% | | 1.00 | 2.08 | 53.42 |
| wild/caddy/caddy | 6 | 609.15 ± 50.1% | not timed | not timed | 348.39 ± 2.4% | 102.39 ± 70.4% | not timed | not timed | 632.18 ± 5.7% | | 0.96 | 1.75 | 5.95 |
| wild/dot-star-capture/rust-src-tools | 6 | 2073.24 ± 1.7% | not timed | not timed | 460.49 ± 1.7% | 22.32 ± 7.0% | not timed | not timed | 2075.40 ± 4.9% | | 1.00 | 4.50 | 92.91 |
| wild/ruff/noqa | 84 | 631.57 ± 1.5% | not timed | not timed | 639.01 ± 6.6% | 29.01 ± 2.7% | not timed | not timed | 635.45 ± 4.0% | | 0.99 | 0.99 | 21.77 |
| wild/ruff/unnecessary-coding-comment | 16 | 1275.03 ± 11.0% | not timed | not timed | 844.02 ± 33.8% | 185.01 ± 13.3% | not timed | not timed | 1279.17 ± 1.1% | | 1.00 | 1.51 | 6.89 |
| wild/ruff/string-quote-prefix | 2972 | 1941.35 ± 2.6% | not timed | not timed | 637.67 ± 2.1% | 405.71 ± 29.0% | not timed | not timed | 1939.32 ± 1.1% | | 1.00 | 3.04 | 4.79 |
| wild/ruff/space-around-operator | 1224378 | 292.33 ± 3.4% | not timed | not timed | 268.32 ± 1.7% | 20.98 ± 1.9% | not timed | not timed | 293.25 ± 4.4% | | 1.00 | 1.09 | 13.93 |
| wild/ruff/shebang | 282 | 1353.35 ± 2.5% | not timed | not timed | 493.66 ± 2.2% | 166.71 ± 14.1% | not timed | not timed | 1362.34 ± 7.0% | | 0.99 | 2.74 | 8.12 |
| wild/rustsec-cargo-audit/original-unix | 471 | 27805.53 ± 32.1% | not timed | not timed | 30864.89 ± 2.0% | 11578.69 ± 13.1% | not timed | not timed | 27892.61 ± 49.4% | | 1.00 | 0.90 | 2.40 |
| wild/rustsec-cargo-audit/original-windows | 462 | 26079.41 ± 2.8% | not timed | not timed | 29303.46 ± 1.7% | 10739.75 ± 1.7% | not timed | not timed | 26317.09 ± 1.2% | | 0.99 | 0.89 | 2.43 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 28720.88 ± 4.1% | not timed | not timed | 30776.56 ± 2.4% | 11245.34 ± 25.6% | not timed | not timed | 28662.94 ± 4.9% | | 1.00 | 0.93 | 2.55 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 24934.15 ± 2.9% | not timed | not timed | 30982.68 ± 2.4% | 11544.73 ± 40.6% | not timed | not timed | 24908.13 ± 1.3% | | 1.00 | 0.80 | 2.16 |
| wild/url/search | 234965 | 167.66 ± 8.5% | not timed | not timed | 81.38 ± 6.7% | 3.48 ± 1.6% | not timed | not timed | 169.26 ± 10.7% | | 0.99 | 2.06 | 48.19 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.04 ± 1.8% | not timed | not timed | 0.01 ± 3.7% | 0.01 ± 16.5% | not timed | not timed | 0.04 ± 7.7% | | 1.00 | 3.06 | 5.09 |
| dictionary/compile/english-15 | 1 | 0.44 ± 13.0% | not timed | not timed | 0.10 ± 7.5% | 0.14 ± 5.4% | not timed | not timed | 0.45 ± 9.8% | | 0.98 | 4.44 | 3.16 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.38 ± 13.4% | not timed | not timed | 0.03 ± 8.9% | 46.10 ± 13.7% | not timed | not timed | 0.41 ± 13.7% | | 0.93 | 12.75 | 0.0082 |
| reported/i1095-word-repetition/ascii-compile | 1 | 59.25 ± 40.9% | not timed | not timed | 18.53 ± 12.7% | 76.84 ± 18.7% | not timed | not timed | 58.49 ± 8.8% | | 1.01 | 3.20 | 0.77 |
| reported/i787-keywords/compile | 1 | 52.48 ± 4.9% | not timed | not timed | 3.05 ± 2.9% | 23.33 ± 13.0% | not timed | not timed | 52.92 ± 2.9% | | 0.99 | 17.18 | 2.25 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 562.35 ± 5.3% | not timed | not timed | 187.65 ± 2.0% | 746.42 ± 11.9% | not timed | not timed | 586.38 ± 12.8% | | 0.96 | 3.00 | 0.75 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 76.66 ± 7.5% | not timed | not timed | 7.00 ± 2.0% | 58.13 ± 13.2% | not timed | not timed | 76.40 ± 6.1% | | 1.00 | 10.95 | 1.32 |
| unicode/compile/one-letter | 53 | 10.16 ± 15.8% | not timed | not timed | 7.65 ± 0.8% | 80.52 ± 7.3% | not timed | not timed | 10.17 ± 5.4% | | 1.00 | 1.33 | 0.13 |
| unicode/compile/fifty-letters | 1 | 1.81 ± 12.1% | not timed | not timed | 0.16 ± 2.3% | 75.93 ± 14.5% | not timed | not timed | 1.85 ± 4.5% | | 0.97 | 11.05 | 0.0238 |
| unicode/compile/fifty-letters-ascii | 1 | 299.06 ± 3.9% | not timed | not timed | 84.74 ± 0.9% | 241.18 ± 18.5% | not timed | not timed | 296.20 ± 16.1% | | 1.01 | 3.53 | 1.24 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 670.27 ± 13.2% | not timed | not timed | 60.73 ± 3.0% | 911.92 ± 16.0% | not timed | not timed | 662.55 ± 18.6% | | 1.01 | 11.04 | 0.74 |
| unicode/compile/match-every-line-ascii | 4 | 1050.50 ± 7.8% | not timed | not timed | 211.84 ± 7.6% | 880.39 ± 10.6% | not timed | not timed | 1073.13 ± 7.0% | | 0.98 | 4.96 | 1.19 |
| unicode/compile/negated-class-matches-codepoint | 1 | 522.98 ± 8.2% | not timed | not timed | 63.37 ± 6.1% | 1705.41 ± 7.8% | not timed | not timed | 548.49 ± 7.5% | | 0.95 | 8.25 | 0.31 |
| wild/bibleref/compile | 3 | 8.73 ± 16.4% | not timed | not timed | 3.23 ± 4.7% | 41.12 ± 26.0% | not timed | not timed | 9.06 ± 7.8% | | 0.96 | 2.70 | 0.21 |
| wild/url/compile | 1 | 0.98 ± 13.5% | not timed | not timed | 0.22 ± 3.2% | 0.56 ± 22.8% | not timed | not timed | 0.99 ± 7.1% | | 0.99 | 4.40 | 1.77 |

