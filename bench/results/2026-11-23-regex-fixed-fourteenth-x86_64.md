# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159319674 |
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
| literal: a word | 217 | 40573.39 ± 0.3% | 1033.22 ± 0.4% | 31.53 ± 0.3% | 38033.90 ± 1.4% | 12082.19 ± 17.6% | 12.91 ± 5.2% | 96.61 ± 1.7% | 40500.50 ± 1.0% | 39.27 | 1.00 | 1.07 | 3.36 |
| literal: a word that is not there | 0 | 57799.49 ± 2.2% | 1043.32 ± 0.2% | 31.53 ± 0.2% | 45601.06 ± 13.0% | 43880.92 ± 2.7% | 12.84 ± 0.3% | 91.01 ± 1.0% | 58109.97 ± 0.5% | 55.40 | 0.99 | 1.27 | 1.32 |
| literal: one of four words | 661 | 14127.16 ± 0.2% | 1013.23 ± 0.5% | 17.40 ± 0.2% | 11151.47 ± 5.6% | 24.97 ± 2.3% | 4.48 ± 0.1% | 7.98 ± 1.7% | 14066.39 ± 0.9% | 13.94 | 1.00 | 1.27 | 565.77 |
| literal: a word in any case | 217 | 36504.65 ± 0.4% | 1033.32 ± 0.2% | 24.39 ± 0.7% | 11335.69 ± 1.2% | 47.03 ± 0.6% | refused | differs | 36325.82 ± 0.5% | 35.33 | 1.00 | 3.22 | 776.19 |
| literal: an href attribute | 33 | 35511.57 ± 0.5% | 1039.65 ± 0.3% | 30.33 ± 0.4% | 35230.09 ± 0.3% | 2930.56 ± 13.6% | 9.71 ± 15.4% | 87.07 ± 46.3% | 35543.42 ± 34.5% | 34.16 | 1.00 | 1.01 | 12.12 |
| literal: a word, second text | 123 | 44006.57 ± 4.2% | 1035.37 ± 0.1% | 31.18 ± 0.1% | 39460.76 ± 1.0% | 11178.30 ± 8.1% | 14.44 ± 1.0% | 85.95 ± 1.8% | 43799.44 ± 0.5% | 42.50 | 1.00 | 1.12 | 3.94 |
| class: two capitalized words | 1331 | 916.22 ± 0.2% | 961.35 ± 0.2% | 29.23 ± 0.2% | 576.28 ± 0.5% | 44.09 ± 8.9% | 11.00 ± 0.2% | 76.30 ± 0.4% | 915.86 ± 0.1% | 0.95 | 1.00 | 1.59 | 20.78 |
| class: a word that ends in ing | 3399 | 883.12 ± 0.4% | 884.45 ± 0.8% | 19.44 ± 7.1% | 540.83 ± 6.2% | 32.80 ± 2.8% | 6.23 ± 0.2% | 19.61 ± 1.2% | 883.46 ± 0.5% | 1.00 | 1.00 | 1.63 | 26.92 |
| class: a word in capitals | 2332 | 1156.53 ± 11.1% | 941.11 ± 0.4% | 30.74 ± 0.5% | 566.55 ± 0.8% | 47.94 ± 2.4% | 12.44 ± 0.1% | 94.23 ± 0.3% | 1156.51 ± 3.1% | 1.23 | 1.00 | 2.04 | 24.13 |
| class: a number | 8288 | 1599.94 ± 0.6% | 805.63 ± 0.2% | 31.48 ± 0.5% | 1783.88 ± 1.2% | 45.64 ± 13.2% | 0.39 ± 0.4% | 65.68 ± 0.5% | 1700.59 ± 0.3% | 1.99 | 0.94 | 0.90 | 35.06 |
| class: two capitalized words, second text | 5359 | 713.49 ± 0.4% | 714.75 ± 0.7% | 26.49 ± 10.7% | 476.81 ± 0.4% | 37.46 ± 14.3% | 12.65 ± 0.3% | 68.59 ± 0.8% | 716.00 ± 0.7% | 1.00 | 1.00 | 1.50 | 19.04 |
| other: a word between two words | 6104 | 832.38 ± 0.9% | 751.14 ± 0.2% | 26.23 ± 0.5% | 816.05 ± 0.5% | 126.00 ± 13.6% | 8.58 ± 0.5% | 79.14 ± 1.0% | 832.11 ± 0.1% | 1.11 | 1.00 | 1.02 | 6.61 |
| other: a number before a unit, second text | 1481 | 9834.70 ± 1.0% | 991.31 ± 0.3% | 29.09 ± 0.5% | 8278.02 ± 0.7% | 44.92 ± 10.9% | 13.22 ± 1.0% | 73.86 ± 10.4% | 9740.78 ± 0.8% | 9.92 | 1.01 | 1.19 | 218.94 |
| other: a heading's start tag | 110 | 24340.23 ± 4.8% | 1030.34 ± 0.6% | 31.05 ± 0.3% | 2563.88 ± 11.4% | 1984.26 ± 3.9% | 11.89 ± 1.2% | 99.04 ± 0.4% | 24438.92 ± 0.6% | 23.62 | 1.00 | 9.49 | 12.27 |
| other: a whole word | 217 | 29279.45 ± 1.0% | 1032.03 ± 0.4% | 32.16 ± 0.7% | 27829.13 ± 9.2% | 54.25 ± 1.5% | 11.20 ± 0.2% | 58.06 ± 0.3% | 28920.55 ± 0.2% | 28.37 | 1.01 | 1.05 | 539.75 |
| other: a line's first word, second text | 3716 | 2518.80 ± 1.2% | 855.06 ± 0.6% | 36.00 ± 1.9% | 2306.49 ± 0.3% | 70.19 ± 13.3% | refused | refused | 2500.97 ± 3.3% | 2.95 | 1.01 | 1.09 | 35.88 |
| other: fourteen octets before an x | 87 | 35723.46 ± 0.4% | 250.34 ± 0.5% | 7.63 ± 16.0% | 3502.20 ± 4.3% | 11.53 ± 4.6% | differs | 21.46 ± 2.2% | 35807.51 ± 0.5% | 142.70 | 1.00 | 10.20 | 3099.31 |
| other: a Greek word | 21815 | 467.07 ± 0.9% | 389.86 ± 0.3% | 34.97 ± 0.3% | 303.11 ± 0.2% | 56.88 ± 11.4% | differs | refused | 466.90 ± 0.6% | 1.20 | 1.00 | 1.54 | 8.21 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.55 ± 1.3% | 29.46 ± 1.3% | 1.04 ± 0.8% | 19.79 ± 0.2% | 2.69 ± 0.8% | differs | 4.04 ± 4.8% | 29.50 ± 0.6% | 1.00 | 1.00 | 1.49 | 11.00 |
| a UUID | 32895 | 23.98 ± 0.2% | 24.14 ± 0.3% | 0.73 ± 1.3% | 15.08 ± 0.5% | 3.00 ± 2.4% | 0.52 ± 0.5% | 3.69 ± 1.5% | 24.11 ± 0.6% | 0.99 | 0.99 | 1.59 | 7.99 |
| an IPv4 address | 33176 | 40.50 ± 0.6% | 40.55 ± 1.5% | 2.35 ± 0.4% | 28.39 ± 0.2% | 7.00 ± 0.5% | differs | 4.14 ± 1.6% | 40.52 ± 0.4% | 1.00 | 1.00 | 1.43 | 5.79 |
| a date and time | 32954 | 36.00 ± 0.2% | 35.99 ± 1.0% | 1.70 ± 0.5% | 21.56 ± 0.7% | 8.22 ± 1.3% | 0.91 ± 0.5% | 7.76 ± 1.6% | 36.00 ± 0.8% | 1.00 | 1.00 | 1.67 | 4.38 |
| a field path | 32606 | 32.68 ± 1.2% | 32.72 ± 1.3% | 1.15 ± 2.9% | 22.89 ± 1.7% | 3.51 ± 19.8% | differs | 2.96 ± 1.5% | 32.63 ± 1.1% | 1.00 | 1.00 | 1.43 | 9.32 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.84 ± 0.7% | 10.85 ± 3.0% | 10.85 ± 0.6% | 13.23 ± 1.8% | 5.83 ± 3.3% | 0.76 ± 0.3% | none | 10.83 ± 1.4% | 1.00 | 1.00 | 0.82 | 1.86 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 239.43 ± 3.2% | 240.61 ± 0.2% | 283.45 ± 0.5% | 100.71 ± 1.8% | 240.66 ± 2.1% | 705.12 ± 4.8% | 4768.79 ± 0.3% | 239.58 ± 0.3% | 1.00 | 1.00 | 2.38 | 0.99 |
| a UUID | 62 | 155.04 ± 1.7% | 155.70 ± 8.2% | 173.01 ± 9.9% | 58.31 ± 1.5% | 118.30 ± 2.2% | 257.63 ± 2.3% | 5514.78 ± 0.4% | 154.94 ± 8.0% | 1.00 | 1.00 | 2.66 | 1.31 |
| an IPv4 address | 29 | 492.17 ± 0.5% | 495.57 ± 2.3% | 719.66 ± 24.3% | 87.89 ± 10.4% | 146.30 ± 1.9% | 407.55 ± 1.5% | 8727.49 ± 0.9% | 489.60 ± 0.8% | 0.99 | 1.01 | 5.60 | 3.36 |
| a date and time | 56 | 366.81 ± 0.1% | 369.16 ± 0.6% | 476.98 ± 1.1% | 86.65 ± 0.9% | 158.86 ± 29.1% | 472.69 ± 2.0% | 5687.22 ± 0.3% | 366.57 ± 1.7% | 0.99 | 1.00 | 4.23 | 2.31 |
| a field path | 39 | 229.17 ± 7.6% | 230.94 ± 0.7% | 268.42 ± 0.8% | 93.65 ± 4.0% | 225.96 ± 2.7% | 749.92 ± 4.7% | 5837.05 ± 2.0% | 229.04 ± 5.6% | 0.99 | 1.00 | 2.45 | 1.01 |
| literal: a word | 7 | 736.04 ± 2.7% | 780.73 ± 5.8% | 1494.18 ± 0.1% | 623.20 ± 2.8% | 779.10 ± 1.7% | 1594.48 ± 0.7% | 33099.04 ± 14.8% | 737.96 ± 0.3% | 0.94 | 1.00 | 1.18 | 0.94 |
| literal: a word that is not there | 8 | 713.73 ± 0.4% | 758.17 ± 0.8% | 1407.91 ± 1.0% | 583.69 ± 1.7% | 749.09 ± 6.7% | 1483.91 ± 0.6% | 32509.52 ± 0.4% | 713.69 ± 15.7% | 0.94 | 1.00 | 1.22 | 0.95 |
| literal: one of four words | 26 | 271.56 ± 2.2% | 456.81 ± 0.7% | 637.60 ± 0.4% | 53.64 ± 8.6% | 288.71 ± 18.0% | 565.75 ± 0.9% | 20636.91 ± 2.9% | 272.03 ± 0.2% | 0.59 | 1.00 | 5.06 | 0.94 |
| literal: a word in any case | 11 | 571.31 ± 1.0% | 600.15 ± 0.2% | 954.84 ± 0.5% | 18.85 ± 10.6% | 821.64 ± 3.6% | refused | 25921.44 ± 0.6% | 568.14 ± 1.0% | 0.95 | 1.01 | 30.30 | 0.70 |
| literal: an href attribute | 12 | 401.52 ± 1.4% | 415.67 ± 0.2% | 568.61 ± 0.7% | 50.56 ± 0.7% | 557.55 ± 4.9% | 1237.80 ± 1.0% | 24084.10 ± 1.3% | 401.00 ± 0.6% | 0.97 | 1.00 | 7.94 | 0.72 |
| literal: a word, second text | 10 | 659.17 ± 1.5% | 712.21 ± 3.5% | 1258.80 ± 14.4% | 540.30 ± 1.1% | 636.51 ± 4.2% | 1297.62 ± 1.4% | 30635.22 ± 0.4% | 660.73 ± 0.5% | 0.93 | 1.00 | 1.22 | 1.04 |
| class: two capitalized words | 23 | 520.40 ± 2.2% | 560.15 ± 1.0% | 854.85 ± 0.4% | 121.12 ± 0.7% | 586.08 ± 20.0% | 1217.66 ± 2.9% | 7247.66 ± 12.6% | 522.14 ± 0.3% | 0.93 | 1.00 | 4.30 | 0.89 |
| class: a word that ends in ing | 9 | 629.41 ± 0.3% | 711.82 ± 0.3% | 1335.06 ± 0.8% | 150.27 ± 11.8% | 852.64 ± 3.2% | 1799.52 ± 0.8% | 18801.22 ± 0.5% | 629.18 ± 0.6% | 0.88 | 1.00 | 4.19 | 0.74 |
| class: a word in capitals | 16 | 560.47 ± 5.2% | 608.96 ± 6.1% | 1024.74 ± 10.0% | 156.11 ± 0.9% | 881.31 ± 17.6% | 1717.47 ± 1.7% | 10513.11 ± 1.0% | 561.16 ± 5.2% | 0.92 | 1.00 | 3.59 | 0.64 |
| class: a number | 6 | 689.17 ± 1.4% | 768.84 ± 0.4% | 1540.25 ± 0.5% | 47.59 ± 0.7% | 1619.22 ± 1.9% | 3045.61 ± 3.3% | 25145.91 ± 0.7% | 688.66 ± 0.2% | 0.90 | 1.00 | 14.48 | 0.43 |
| class: two capitalized words, second text | 23 | 521.76 ± 0.5% | 557.61 ± 0.5% | 855.67 ± 0.3% | 120.98 ± 0.7% | 583.74 ± 19.1% | 1265.01 ± 2.1% | 8091.56 ± 0.4% | 521.56 ± 0.4% | 0.94 | 1.00 | 4.31 | 0.89 |
| other: a word between two words | 13 | 638.43 ± 0.5% | 656.34 ± 2.3% | 1087.03 ± 13.5% | 158.85 ± 0.8% | 573.35 ± 4.6% | 1302.71 ± 2.7% | 17577.39 ± 0.8% | 638.36 ± 0.4% | 0.97 | 1.00 | 4.02 | 1.11 |
| other: a number before a unit, second text | 15 | 437.51 ± 0.2% | 489.57 ± 0.2% | 691.79 ± 6.4% | 44.62 ± 1.2% | 717.77 ± 1.6% | 1450.22 ± 1.8% | 17366.19 ± 0.6% | 437.01 ± 0.7% | 0.89 | 1.00 | 9.81 | 0.61 |
| other: a heading's start tag | 13 | 414.53 ± 0.8% | 421.15 ± 9.0% | 572.58 ± 7.2% | 48.82 ± 0.4% | 706.20 ± 1.3% | 1371.61 ± 1.4% | 19971.18 ± 1.1% | 412.73 ± 0.4% | 0.98 | 1.00 | 8.49 | 0.59 |
| other: a whole word | 11 | 657.45 ± 0.6% | 693.81 ± 10.3% | 1198.86 ± 0.8% | 141.88 ± 0.8% | 671.91 ± 1.8% | 1345.74 ± 2.5% | 28756.86 ± 9.5% | 654.92 ± 0.6% | 0.95 | 1.00 | 4.63 | 0.98 |
| other: a line's first word, second text | 17 | 605.57 ± 0.8% | 637.97 ± 0.4% | 1073.04 ± 9.8% | 150.17 ± 0.3% | 804.54 ± 1.7% | refused | refused | 603.19 ± 0.9% | 0.95 | 1.00 | 4.03 | 0.75 |
| other: fourteen octets before an x | 16 | 118.60 ± 4.2% | 175.42 ± 0.4% | 210.37 ± 0.7% | 18.25 ± 0.8% | 515.61 ± 2.6% | 582.44 ± 0.7% | 15529.56 ± 0.8% | 118.63 ± 2.7% | 0.68 | 1.00 | 6.50 | 0.23 |
| other: a Greek word | 8 | 431.85 ± 2.6% | 616.85 ± 1.2% | 1018.66 ± 0.9% | 63.01 ± 0.2% | 1593.22 ± 3.9% | 2808.08 ± 1.2% | refused | 435.44 ± 10.6% | 0.70 | 0.99 | 6.85 | 0.27 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 29360.30 ± 0.6% | not timed | not timed | 33453.67 ± 0.6% | 2913.02 ± 16.0% | not timed | not timed | 29324.52 ± 2.3% | | 1.00 | 0.88 | 10.08 |
| 01-literal/sherlock-casei-en | 522 | 8421.05 ± 0.7% | not timed | not timed | 8994.03 ± 0.2% | 33.80 ± 8.0% | not timed | not timed | 8419.95 ± 1.3% | | 1.00 | 0.94 | 249.13 |
| 01-literal/sherlock-ru | 724 | 30772.68 ± 0.4% | not timed | not timed | 33971.08 ± 2.5% | 1281.81 ± 3.3% | not timed | not timed | 30571.86 ± 0.4% | | 1.01 | 0.91 | 24.01 |
| 01-literal/sherlock-casei-ru | 746 | 8838.03 ± 0.3% | not timed | not timed | 7793.33 ± 1.5% | 37.46 ± 1.6% | not timed | not timed | 8854.53 ± 0.1% | | 1.00 | 1.13 | 235.92 |
| 01-literal/sherlock-zh | 30 | 53575.50 ± 1.4% | not timed | not timed | 43177.57 ± 0.6% | 1617.57 ± 1.7% | not timed | not timed | 53462.42 ± 0.7% | | 1.00 | 1.24 | 33.12 |
| 02-literal-alternate/sherlock-en | 714 | 12831.26 ± 0.3% | not timed | not timed | 10884.88 ± 0.2% | 18.78 ± 0.8% | not timed | not timed | 12814.45 ± 0.2% | | 1.00 | 1.18 | 683.10 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4178.82 ± 6.8% | not timed | not timed | 2300.13 ± 2.2% | 12.26 ± 1.5% | not timed | not timed | 3844.06 ± 3.7% | | 1.09 | 1.82 | 340.92 |
| 02-literal-alternate/sherlock-ru | 899 | 7438.64 ± 2.1% | not timed | not timed | 9778.10 ± 0.3% | 25.35 ± 0.5% | not timed | not timed | 7337.47 ± 2.1% | | 1.01 | 0.76 | 293.38 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2197.37 ± 0.9% | not timed | not timed | 1187.66 ± 0.4% | 10.54 ± 2.5% | not timed | not timed | 2167.80 ± 0.7% | | 1.01 | 1.85 | 208.47 |
| 02-literal-alternate/sherlock-zh | 207 | 18599.95 ± 0.3% | not timed | not timed | 12687.46 ± 0.2% | 35.38 ± 0.9% | not timed | not timed | 18580.11 ± 24.4% | | 1.00 | 1.47 | 525.72 |
| 03-date/ascii | 111817 | 127.95 ± 0.5% | not timed | not timed | 99.98 ± 1.5% | 0.22 ± 6.7% | not timed | not timed | 127.43 ± 1.4% | | 1.00 | 1.28 | 590.63 |
| 04-ruff-noqa/real | 84 | 691.09 ± 0.7% | not timed | not timed | 502.32 ± 1.1% | 20.73 ± 2.5% | not timed | not timed | 692.02 ± 5.4% | | 1.00 | 1.38 | 33.34 |
| 04-ruff-noqa/tweaked | 44 | 590.33 ± 1.1% | not timed | not timed | 511.23 ± 4.4% | 362.57 ± 1.0% | not timed | not timed | 585.11 ± 20.7% | | 1.01 | 1.15 | 1.63 |
| 05-lexer-veryl/single | 124800 | 4.02 ± 9.2% | not timed | not timed | 5.58 ± 0.4% | 0.25 ± 4.1% | not timed | not timed | 4.01 ± 1.8% | | 1.00 | 0.72 | 15.90 |
| 06-cloud-flare-redos/original | 107 | 260.02 ± 1.6% | not timed | not timed | 224.58 ± 11.3% | 25.27 ± 18.0% | not timed | not timed | 259.74 ± 0.3% | | 1.00 | 1.16 | 10.29 |
| 06-cloud-flare-redos/simplified-short | 102 | 256.18 ± 0.3% | not timed | not timed | 236.52 ± 0.4% | 15.36 ± 1.1% | not timed | not timed | 254.91 ± 0.3% | | 1.01 | 1.08 | 16.68 |
| 06-cloud-flare-redos/simplified-long | 10000 | 280.79 ± 8.9% | not timed | not timed | 258.90 ± 4.3% | 29.79 ± 17.9% | not timed | not timed | 280.89 ± 0.1% | | 1.00 | 1.08 | 9.43 |
| 07-unicode-character-data/parse-line | 558784 | 245.19 ± 1.7% | not timed | not timed | 200.03 ± 0.3% | 45.90 ± 1.9% | not timed | not timed | 246.42 ± 1.2% | | 1.00 | 1.23 | 5.34 |
| 08-words/all-english | 56691 | 112.61 ± 7.8% | not timed | not timed | 84.15 ± 0.4% | 14.50 ± 8.0% | not timed | not timed | 112.02 ± 1.2% | | 1.01 | 1.34 | 7.77 |
| 08-words/long-english | 839 | 988.94 ± 0.2% | not timed | not timed | 584.21 ± 0.2% | 35.17 ± 19.2% | not timed | not timed | 988.38 ± 0.1% | | 1.00 | 1.69 | 28.12 |
| 09-aws-keys/full | 0 | 519.63 ± 4.4% | not timed | not timed | 528.91 ± 4.9% | 62.28 ± 8.1% | not timed | not timed | 520.23 ± 1.1% | | 1.00 | 0.98 | 8.34 |
| 09-aws-keys/quick | 0 | 952.13 ± 11.4% | not timed | not timed | 961.88 ± 1.3% | 413.65 ± 2.4% | not timed | not timed | 962.82 ± 0.8% | | 0.99 | 0.99 | 2.30 |
| 10-bounded-repeat/letters-en | 1833 | 663.81 ± 2.0% | not timed | not timed | 555.12 ± 0.8% | 22.87 ± 0.5% | not timed | not timed | 657.29 ± 0.4% | | 1.01 | 1.20 | 29.03 |
| 10-bounded-repeat/letters-ru | 3475 | 364.82 ± 0.2% | not timed | not timed | 481.23 ± 0.4% | 24.72 ± 7.2% | not timed | not timed | 365.76 ± 0.5% | | 1.00 | 0.76 | 14.76 |
| 10-bounded-repeat/context | 53 | 80.68 ± 3.0% | not timed | not timed | 68.75 ± 3.0% | 22.65 ± 4.0% | not timed | not timed | 80.22 ± 15.0% | | 1.01 | 1.17 | 3.56 |
| 10-bounded-repeat/capitals | 11 | 1033.10 ± 0.6% | not timed | not timed | 603.67 ± 0.3% | 40.15 ± 0.6% | not timed | not timed | 1028.09 ± 0.8% | | 1.00 | 1.71 | 25.73 |
| 11-unstructured-to-json/extract | 600 | 46.70 ± 5.1% | not timed | not timed | 79.68 ± 9.6% | 49.96 ± 1.4% | not timed | not timed | 46.83 ± 0.6% | | 1.00 | 0.59 | 0.93 |
| 12-dictionary/single | 1 | 508.99 ± 0.5% | not timed | not timed | 480.00 ± 0.2% | 0.39 ± 5.4% | not timed | not timed | 511.76 ± 0.2% | | 0.99 | 1.06 | 1299.20 |
| 14-quadratic/1x | 100 | 12.86 ± 0.6% | not timed | not timed | 12.17 ± 7.9% | 1.00 ± 3.2% | not timed | not timed | 12.70 ± 1.0% | | 1.01 | 1.06 | 12.84 |
| 14-quadratic/2x | 200 | 7.80 ± 0.6% | not timed | not timed | 6.12 ± 1.9% | 0.55 ± 18.4% | not timed | not timed | 7.79 ± 1.1% | | 1.00 | 1.28 | 14.30 |
| 14-quadratic/10x | 1000 | 1.82 ± 0.2% | not timed | not timed | 1.22 ± 1.2% | 0.12 ± 9.2% | not timed | not timed | 1.82 ± 0.3% | | 1.00 | 1.49 | 15.36 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.65 ± 6.9% | not timed | not timed | 0.48 ± 14.2% | 0.61 ± 8.8% | not timed | not timed | 1.64 ± 2.7% | | 1.01 | 3.47 | 2.70 |
| 04-ruff-noqa/compile-real | 1 | 103.58 ± 0.2% | not timed | not timed | 17.20 ± 0.5% | 156.07 ± 6.5% | not timed | not timed | 102.32 ± 6.7% | | 1.01 | 6.02 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 17.17 ± 1.1% | not timed | not timed | 2.99 ± 6.7% | 7.37 ± 5.3% | not timed | not timed | 17.08 ± 0.9% | | 1.00 | 5.75 | 2.33 |
| 07-unicode-character-data/compile | 1 | 64.79 ± 0.4% | not timed | not timed | 30.52 ± 0.4% | 39.82 ± 9.0% | not timed | not timed | 64.74 ± 0.5% | | 1.00 | 2.12 | 1.63 |
| 09-aws-keys/compile-full | 1 | 45.36 ± 1.3% | not timed | not timed | 9.92 ± 0.5% | 26.20 ± 4.9% | not timed | not timed | 44.85 ± 0.8% | | 1.01 | 4.57 | 1.73 |
| 09-aws-keys/compile-quick | 1 | 194.87 ± 8.2% | not timed | not timed | 57.54 ± 13.9% | 144.27 ± 8.4% | not timed | not timed | 194.09 ± 8.1% | | 1.00 | 3.39 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 15.52 ± 0.4% | not timed | not timed | 14.27 ± 1.6% | 19.91 ± 3.2% | not timed | not timed | 15.53 ± 1.8% | | 1.00 | 1.09 | 0.78 |
| 10-bounded-repeat/compile-capitals | 1 | 92.36 ± 0.6% | not timed | not timed | 10.50 ± 1.1% | 28.44 ± 6.2% | not timed | not timed | 86.37 ± 0.8% | | 1.07 | 8.80 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 99.50 ± 5.2% | not timed | not timed | 46.75 ± 5.2% | 74.44 ± 12.1% | not timed | not timed | 98.63 ± 1.2% | | 1.01 | 2.13 | 1.34 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.4% | not timed | not timed | 0.08 ± 2.0% | 0.11 ± 27.3% | not timed | not timed | 0.35 ± 1.9% | | 1.02 | 4.46 | 3.13 |

