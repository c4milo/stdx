# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148102727 |
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
| literal: a word | 217 | 40295.44 ± 0.5% | 1032.25 ± 0.3% | 29.97 ± 0.6% | 38405.77 ± 1.6% | 12237.04 ± 4.0% | 12.74 ± 0.2% | 104.33 ± 3.0% | 40292.13 ± 0.5% | 39.04 | 1.00 | 1.05 | 3.29 |
| literal: a word that is not there | 0 | 55975.98 ± 0.1% | 1043.09 ± 0.3% | 30.04 ± 0.3% | 45121.05 ± 2.0% | 43422.99 ± 1.7% | 12.59 ± 0.2% | 96.89 ± 0.5% | 55935.42 ± 2.5% | 53.66 | 1.00 | 1.24 | 1.29 |
| literal: one of four words | 661 | 13017.30 ± 0.3% | 1013.08 ± 0.4% | 16.74 ± 0.8% | 11172.03 ± 1.9% | 24.95 ± 0.6% | 4.47 ± 0.3% | 8.22 ± 1.2% | 14147.27 ± 0.5% | 12.85 | 0.92 | 1.17 | 521.81 |
| literal: a word in any case | 217 | 36122.99 ± 0.5% | 1030.80 ± 1.4% | 22.80 ± 20.2% | 11360.07 ± 6.2% | 47.17 ± 0.4% | refused | differs | 36078.01 ± 19.7% | 35.04 | 1.00 | 3.18 | 765.80 |
| literal: an href attribute | 33 | 35182.92 ± 0.4% | 1038.89 ± 0.1% | 29.01 ± 0.2% | 34812.34 ± 7.7% | 2963.41 ± 3.8% | 9.55 ± 0.3% | 91.02 ± 6.2% | 35073.29 ± 7.2% | 33.87 | 1.00 | 1.01 | 11.87 |
| literal: a word, second text | 123 | 44325.12 ± 0.9% | 1033.69 ± 0.3% | 29.55 ± 4.8% | 39423.88 ± 1.2% | 11022.73 ± 7.4% | 14.44 ± 0.7% | 87.10 ± 6.6% | 44312.43 ± 0.6% | 42.88 | 1.00 | 1.12 | 4.02 |
| class: two capitalized words | 1331 | 918.67 ± 0.3% | 962.54 ± 0.3% | 28.10 ± 0.3% | 575.78 ± 0.2% | 44.17 ± 1.8% | 10.92 ± 0.3% | 79.73 ± 1.0% | 917.65 ± 0.3% | 0.95 | 1.00 | 1.60 | 20.80 |
| class: a word that ends in ing | 3399 | 884.43 ± 0.5% | 885.03 ± 0.2% | 19.77 ± 1.1% | 537.70 ± 1.7% | 32.85 ± 4.1% | 6.05 ± 0.1% | 20.33 ± 0.7% | 884.07 ± 0.8% | 1.00 | 1.00 | 1.64 | 26.92 |
| class: a word in capitals | 2332 | 1158.06 ± 0.3% | 940.53 ± 0.1% | 29.46 ± 2.2% | 565.77 ± 0.6% | 47.11 ± 9.0% | 12.37 ± 0.3% | 100.65 ± 1.6% | 1156.40 ± 0.1% | 1.23 | 1.00 | 2.05 | 24.58 |
| class: a number | 8288 | 1717.32 ± 0.7% | 815.40 ± 0.1% | 29.62 ± 0.5% | 1811.75 ± 1.0% | 49.44 ± 13.5% | 0.38 ± 0.5% | 72.34 ± 0.2% | 1713.81 ± 0.6% | 2.11 | 1.00 | 0.95 | 34.74 |
| class: two capitalized words, second text | 5359 | 721.75 ± 0.5% | 724.27 ± 0.4% | 25.76 ± 0.2% | 478.27 ± 0.5% | 38.55 ± 14.7% | 12.75 ± 0.2% | 74.15 ± 0.9% | 723.47 ± 5.8% | 1.00 | 1.00 | 1.51 | 18.72 |
| other: a word between two words | 6104 | 837.76 ± 0.7% | 754.21 ± 0.1% | 25.34 ± 0.2% | 816.71 ± 0.4% | 122.61 ± 13.4% | 8.41 ± 0.1% | 80.48 ± 0.3% | 837.76 ± 2.8% | 1.11 | 1.00 | 1.03 | 6.83 |
| other: a number before a unit, second text | 1481 | 9851.19 ± 1.0% | 992.07 ± 0.1% | 28.20 ± 0.4% | 8310.73 ± 0.4% | 44.94 ± 1.2% | 13.30 ± 0.3% | 77.59 ± 3.7% | 9841.10 ± 0.6% | 9.93 | 1.00 | 1.19 | 219.19 |
| other: a heading's start tag | 110 | 24407.12 ± 0.2% | 1030.20 ± 0.1% | 29.91 ± 1.1% | 2607.82 ± 1.8% | 1997.71 ± 10.7% | 11.72 ± 0.2% | 107.08 ± 0.1% | 24431.23 ± 0.2% | 23.69 | 1.00 | 9.36 | 12.22 |
| other: a whole word | 217 | 28980.92 ± 0.1% | 1032.55 ± 0.1% | 30.47 ± 0.5% | 27983.70 ± 1.7% | 54.30 ± 1.5% | 10.94 ± 0.1% | 63.02 ± 0.5% | 28916.86 ± 0.3% | 28.07 | 1.00 | 1.04 | 533.74 |
| other: a line's first word, second text | 3716 | 2583.03 ± 7.5% | 864.10 ± 0.2% | 32.21 ± 0.7% | 2327.20 ± 0.4% | 70.44 ± 10.7% | refused | refused | 2572.89 ± 0.4% | 2.99 | 1.00 | 1.11 | 36.67 |
| other: fourteen octets before an x | 87 | 35502.21 ± 0.2% | 251.62 ± 0.3% | 7.60 ± 0.4% | 3461.58 ± 0.4% | 11.63 ± 1.8% | differs | 20.83 ± 2.3% | 35656.34 ± 0.3% | 141.09 | 1.00 | 10.26 | 3052.62 |
| other: a Greek word | 21815 | 480.77 ± 0.4% | 402.03 ± 0.1% | 33.57 ± 0.8% | 303.31 ± 0.3% | 57.82 ± 10.3% | differs | refused | 480.54 ± 0.3% | 1.20 | 1.00 | 1.59 | 8.31 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.12 ± 1.7% | 29.11 ± 0.4% | 1.04 ± 0.2% | 19.77 ± 1.9% | 2.69 ± 9.7% | differs | 4.28 ± 0.5% | 29.28 ± 1.1% | 1.00 | 0.99 | 1.47 | 10.83 |
| a UUID | 32895 | 23.95 ± 0.3% | 24.11 ± 0.2% | 0.73 ± 0.6% | 15.14 ± 0.2% | 3.04 ± 1.3% | 0.52 ± 0.1% | 3.87 ± 2.2% | 24.11 ± 1.2% | 0.99 | 0.99 | 1.58 | 7.88 |
| an IPv4 address | 33176 | 39.85 ± 0.9% | 37.41 ± 0.5% | 2.35 ± 0.5% | 28.01 ± 4.4% | 6.97 ± 1.5% | differs | 4.20 ± 20.4% | 39.96 ± 5.3% | 1.07 | 1.00 | 1.42 | 5.72 |
| a date and time | 32954 | 35.96 ± 0.3% | 35.96 ± 0.3% | 1.74 ± 2.2% | 21.68 ± 6.9% | 8.04 ± 7.0% | 0.90 ± 1.4% | 7.60 ± 3.4% | 35.43 ± 0.6% | 1.00 | 1.02 | 1.66 | 4.47 |
| a field path | 32606 | 32.19 ± 3.9% | 32.69 ± 0.7% | 1.14 ± 0.9% | 23.04 ± 0.2% | 3.51 ± 2.0% | differs | 3.01 ± 1.0% | 32.39 ± 9.3% | 0.98 | 0.99 | 1.40 | 9.16 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.94 ± 0.4% | 10.97 ± 0.5% | 10.95 ± 0.6% | 13.31 ± 1.1% | 5.86 ± 3.0% | 0.74 ± 3.5% | none | 10.78 ± 5.5% | 1.00 | 1.02 | 0.82 | 1.87 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 233.55 ± 3.6% | 235.12 ± 0.4% | 271.63 ± 0.4% | 100.14 ± 1.7% | 243.06 ± 22.0% | 698.20 ± 4.9% | 4714.48 ± 1.4% | 233.77 ± 0.4% | 0.99 | 1.00 | 2.33 | 0.96 |
| a UUID | 62 | 151.61 ± 0.5% | 151.87 ± 0.5% | 166.96 ± 0.3% | 57.96 ± 12.5% | 119.10 ± 2.6% | 252.22 ± 1.3% | 5402.49 ± 0.6% | 151.35 ± 1.0% | 1.00 | 1.00 | 2.62 | 1.27 |
| an IPv4 address | 29 | 505.72 ± 0.6% | 511.46 ± 2.2% | 727.12 ± 2.6% | 87.70 ± 0.7% | 148.86 ± 1.6% | 409.80 ± 1.4% | 8991.53 ± 0.5% | 506.17 ± 0.4% | 0.99 | 1.00 | 5.77 | 3.40 |
| a date and time | 56 | 374.16 ± 0.4% | 376.50 ± 0.8% | 474.96 ± 1.3% | 86.98 ± 1.8% | 160.62 ± 1.6% | 477.94 ± 2.8% | 5537.72 ± 0.7% | 373.73 ± 1.8% | 0.99 | 1.00 | 4.30 | 2.33 |
| a field path | 39 | 221.14 ± 0.4% | 222.51 ± 7.3% | 253.23 ± 0.3% | 95.54 ± 3.1% | 230.07 ± 7.7% | 745.86 ± 1.7% | 5621.23 ± 1.4% | 220.93 ± 1.5% | 0.99 | 1.00 | 2.31 | 0.96 |
| literal: a word | 7 | 772.73 ± 0.3% | 821.63 ± 0.7% | 1508.21 ± 0.2% | 662.44 ± 1.5% | 791.68 ± 3.2% | 1599.81 ± 0.5% | 34529.07 ± 0.5% | 773.32 ± 0.4% | 0.94 | 1.00 | 1.17 | 0.98 |
| literal: a word that is not there | 8 | 745.58 ± 0.4% | 795.92 ± 7.8% | 1418.82 ± 1.7% | 613.57 ± 1.0% | 760.45 ± 24.5% | 1515.28 ± 1.7% | 33434.48 ± 1.3% | 746.24 ± 0.2% | 0.94 | 1.00 | 1.22 | 0.98 |
| literal: one of four words | 26 | 282.02 ± 0.4% | 473.14 ± 0.5% | 643.65 ± 0.2% | 53.69 ± 1.0% | 280.42 ± 11.3% | 561.09 ± 0.5% | 18301.27 ± 0.4% | 281.91 ± 0.8% | 0.60 | 1.00 | 5.25 | 1.01 |
| literal: a word in any case | 11 | 599.47 ± 1.9% | 635.12 ± 0.6% | 980.72 ± 2.3% | 18.78 ± 1.0% | 823.89 ± 24.2% | refused | 24703.26 ± 1.4% | 598.32 ± 0.7% | 0.94 | 1.00 | 31.92 | 0.73 |
| literal: an href attribute | 12 | 404.90 ± 0.3% | 418.45 ± 0.9% | 551.35 ± 0.3% | 50.84 ± 1.1% | 569.46 ± 24.1% | 1285.39 ± 2.6% | 24122.60 ± 0.3% | 405.10 ± 0.3% | 0.97 | 1.00 | 7.96 | 0.71 |
| literal: a word, second text | 10 | 690.83 ± 0.3% | 748.64 ± 0.3% | 1275.68 ± 0.6% | 539.28 ± 4.0% | 652.70 ± 2.5% | 1358.43 ± 0.5% | 31878.54 ± 0.8% | 689.80 ± 0.5% | 0.92 | 1.00 | 1.28 | 1.06 |
| class: two capitalized words | 23 | 532.86 ± 0.3% | 581.63 ± 0.4% | 850.64 ± 0.4% | 122.46 ± 0.5% | 604.48 ± 1.0% | 1255.90 ± 1.3% | 7807.49 ± 12.2% | 533.18 ± 0.2% | 0.92 | 1.00 | 4.35 | 0.88 |
| class: a word that ends in ing | 9 | 654.68 ± 0.2% | 755.57 ± 0.2% | 1329.73 ± 1.1% | 152.31 ± 1.6% | 860.78 ± 13.7% | 1937.78 ± 0.3% | 19250.89 ± 0.3% | 655.08 ± 0.4% | 0.87 | 1.00 | 4.30 | 0.76 |
| class: a word in capitals | 16 | 586.47 ± 0.4% | 646.57 ± 0.4% | 1043.87 ± 0.6% | 155.45 ± 1.9% | 897.74 ± 14.8% | 1802.18 ± 0.4% | 10445.55 ± 0.9% | 586.45 ± 0.2% | 0.91 | 1.00 | 3.77 | 0.65 |
| class: a number | 6 | 721.58 ± 6.2% | 813.97 ± 1.0% | 1526.30 ± 0.3% | 46.87 ± 0.9% | 1647.76 ± 1.8% | 3061.77 ± 3.0% | 25872.28 ± 0.2% | 722.90 ± 1.3% | 0.89 | 1.00 | 15.40 | 0.44 |
| class: two capitalized words, second text | 23 | 532.15 ± 0.2% | 581.66 ± 0.3% | 850.60 ± 0.3% | 119.30 ± 0.5% | 605.41 ± 2.2% | 1222.58 ± 2.1% | 7847.36 ± 0.5% | 532.64 ± 0.9% | 0.91 | 1.00 | 4.46 | 0.88 |
| other: a word between two words | 13 | 659.52 ± 0.5% | 680.96 ± 0.2% | 1092.67 ± 0.5% | 155.42 ± 1.3% | 584.09 ± 4.4% | 1354.05 ± 1.3% | 17871.15 ± 0.7% | 660.19 ± 1.4% | 0.97 | 1.00 | 4.24 | 1.13 |
| other: a number before a unit, second text | 15 | 436.79 ± 1.0% | 485.90 ± 0.3% | 662.31 ± 0.1% | 44.07 ± 0.7% | 727.90 ± 1.3% | 1481.06 ± 0.8% | 17703.48 ± 0.4% | 437.07 ± 0.4% | 0.90 | 1.00 | 9.91 | 0.60 |
| other: a heading's start tag | 13 | 416.76 ± 0.3% | 423.91 ± 1.9% | 559.24 ± 1.4% | 48.50 ± 0.4% | 714.15 ± 1.7% | 1356.83 ± 0.9% | 20110.47 ± 2.4% | 416.11 ± 0.7% | 0.98 | 1.00 | 8.59 | 0.58 |
| other: a whole word | 11 | 680.57 ± 1.1% | 718.21 ± 0.7% | 1187.05 ± 0.6% | 141.26 ± 0.7% | 684.05 ± 0.8% | 1351.76 ± 0.8% | 31671.45 ± 0.5% | 674.17 ± 0.3% | 0.95 | 1.01 | 4.82 | 0.99 |
| other: a line's first word, second text | 17 | 630.73 ± 0.8% | 664.63 ± 0.3% | 1074.32 ± 0.7% | 150.19 ± 5.7% | 812.93 ± 8.2% | refused | refused | 628.20 ± 5.7% | 0.95 | 1.00 | 4.20 | 0.78 |
| other: fourteen octets before an x | 16 | 118.24 ± 0.3% | 177.61 ± 1.8% | 208.19 ± 1.7% | 18.22 ± 0.3% | 522.73 ± 2.7% | 568.21 ± 2.1% | 15773.05 ± 12.5% | 118.01 ± 10.7% | 0.67 | 1.00 | 6.49 | 0.23 |
| other: a Greek word | 8 | 453.09 ± 0.4% | 628.14 ± 0.8% | 977.56 ± 0.4% | 63.18 ± 0.3% | 1623.60 ± 1.4% | 2825.97 ± 0.5% | refused | 453.19 ± 0.2% | 0.72 | 1.00 | 7.17 | 0.28 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 28685.10 ± 1.1% | not timed | not timed | 33818.75 ± 2.0% | 2852.58 ± 13.4% | not timed | not timed | 29192.75 ± 0.9% | | 0.98 | 0.85 | 10.06 |
| 01-literal/sherlock-casei-en | 522 | 8404.44 ± 0.5% | not timed | not timed | 8992.42 ± 0.2% | 33.94 ± 2.2% | not timed | not timed | 8420.98 ± 1.5% | | 1.00 | 0.93 | 247.63 |
| 01-literal/sherlock-ru | 724 | 30462.77 ± 0.6% | not timed | not timed | 34523.77 ± 1.6% | 1246.87 ± 6.2% | not timed | not timed | 30738.13 ± 0.8% | | 0.99 | 0.88 | 24.43 |
| 01-literal/sherlock-casei-ru | 746 | 8831.81 ± 0.6% | not timed | not timed | 7769.54 ± 0.5% | 37.77 ± 0.8% | not timed | not timed | 8827.72 ± 1.0% | | 1.00 | 1.14 | 233.81 |
| 01-literal/sherlock-zh | 30 | 52981.55 ± 0.3% | not timed | not timed | 42976.23 ± 0.4% | 1650.88 ± 1.0% | not timed | not timed | 52587.99 ± 2.7% | | 1.01 | 1.23 | 32.09 |
| 02-literal-alternate/sherlock-en | 714 | 12787.74 ± 1.2% | not timed | not timed | 10921.83 ± 0.7% | 19.08 ± 0.2% | not timed | not timed | 12833.92 ± 0.2% | | 1.00 | 1.17 | 670.24 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4191.98 ± 6.3% | not timed | not timed | 2302.07 ± 0.9% | 12.08 ± 2.9% | not timed | not timed | 3863.16 ± 1.1% | | 1.09 | 1.82 | 347.05 |
| 02-literal-alternate/sherlock-ru | 899 | 7490.44 ± 0.4% | not timed | not timed | 9758.42 ± 0.7% | 25.43 ± 1.1% | not timed | not timed | 7495.59 ± 0.2% | | 1.00 | 0.77 | 294.52 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2152.40 ± 3.6% | not timed | not timed | 1191.62 ± 1.4% | 10.57 ± 0.7% | not timed | not timed | 2123.82 ± 2.7% | | 1.01 | 1.81 | 203.70 |
| 02-literal-alternate/sherlock-zh | 207 | 18481.98 ± 0.7% | not timed | not timed | 12583.41 ± 0.2% | 35.53 ± 0.4% | not timed | not timed | 18525.27 ± 0.2% | | 1.00 | 1.47 | 520.20 |
| 03-date/ascii | 111817 | 127.54 ± 3.6% | not timed | not timed | 100.90 ± 4.8% | 0.22 ± 1.5% | not timed | not timed | 130.36 ± 0.5% | | 0.98 | 1.26 | 566.90 |
| 04-ruff-noqa/real | 84 | 698.23 ± 0.2% | not timed | not timed | 501.08 ± 2.0% | 20.86 ± 1.6% | not timed | not timed | 696.89 ± 0.8% | | 1.00 | 1.39 | 33.47 |
| 04-ruff-noqa/tweaked | 44 | 590.80 ± 0.4% | not timed | not timed | 515.27 ± 0.9% | 368.37 ± 0.8% | not timed | not timed | 589.20 ± 0.2% | | 1.00 | 1.15 | 1.60 |
| 05-lexer-veryl/single | 124800 | 4.13 ± 2.2% | not timed | not timed | 5.34 ± 0.3% | 0.26 ± 5.0% | not timed | not timed | 4.15 ± 0.7% | | 1.00 | 0.77 | 15.96 |
| 06-cloud-flare-redos/original | 107 | 265.44 ± 0.4% | not timed | not timed | 228.39 ± 1.7% | 25.58 ± 1.8% | not timed | not timed | 268.82 ± 0.4% | | 0.99 | 1.16 | 10.38 |
| 06-cloud-flare-redos/simplified-short | 102 | 263.13 ± 0.6% | not timed | not timed | 236.11 ± 0.5% | 27.66 ± 0.5% | not timed | not timed | 264.86 ± 1.5% | | 0.99 | 1.11 | 9.51 |
| 06-cloud-flare-redos/simplified-long | 10000 | 280.30 ± 0.6% | not timed | not timed | 257.23 ± 8.3% | 29.81 ± 1.8% | not timed | not timed | 280.41 ± 0.3% | | 1.00 | 1.09 | 9.40 |
| 07-unicode-character-data/parse-line | 558784 | 242.08 ± 0.6% | not timed | not timed | 199.92 ± 0.3% | 47.95 ± 9.3% | not timed | not timed | 243.27 ± 3.6% | | 1.00 | 1.21 | 5.05 |
| 08-words/all-english | 56691 | 110.61 ± 2.1% | not timed | not timed | 84.43 ± 0.6% | 14.97 ± 12.2% | not timed | not timed | 110.27 ± 1.1% | | 1.00 | 1.31 | 7.39 |
| 08-words/long-english | 839 | 986.83 ± 1.6% | not timed | not timed | 583.23 ± 0.9% | 35.09 ± 6.8% | not timed | not timed | 985.86 ± 2.7% | | 1.00 | 1.69 | 28.12 |
| 09-aws-keys/full | 0 | 517.46 ± 0.2% | not timed | not timed | 544.01 ± 0.3% | 62.51 ± 4.1% | not timed | not timed | 514.96 ± 9.8% | | 1.00 | 0.95 | 8.28 |
| 09-aws-keys/quick | 0 | 960.81 ± 2.0% | not timed | not timed | 959.50 ± 1.4% | 413.79 ± 1.2% | not timed | not timed | 962.28 ± 1.1% | | 1.00 | 1.00 | 2.32 |
| 10-bounded-repeat/letters-en | 1833 | 668.87 ± 2.5% | not timed | not timed | 556.76 ± 0.6% | 22.92 ± 1.4% | not timed | not timed | 668.60 ± 6.4% | | 1.00 | 1.20 | 29.18 |
| 10-bounded-repeat/letters-ru | 3475 | 368.85 ± 2.2% | not timed | not timed | 482.77 ± 1.2% | 24.19 ± 18.2% | not timed | not timed | 368.86 ± 0.5% | | 1.00 | 0.76 | 15.25 |
| 10-bounded-repeat/context | 53 | 81.35 ± 1.4% | not timed | not timed | 70.66 ± 0.9% | 22.61 ± 1.0% | not timed | not timed | 82.51 ± 1.1% | | 0.99 | 1.15 | 3.60 |
| 10-bounded-repeat/capitals | 11 | 1033.00 ± 0.4% | not timed | not timed | 603.86 ± 0.1% | 39.10 ± 6.4% | not timed | not timed | 1031.67 ± 0.5% | | 1.00 | 1.71 | 26.42 |
| 11-unstructured-to-json/extract | 600 | 46.07 ± 0.9% | not timed | not timed | 80.60 ± 1.0% | 50.03 ± 15.6% | not timed | not timed | 45.98 ± 0.5% | | 1.00 | 0.57 | 0.92 |
| 12-dictionary/single | 1 | 508.40 ± 0.3% | not timed | not timed | 481.58 ± 0.5% | 0.39 ± 5.4% | not timed | not timed | 510.95 ± 0.4% | | 1.00 | 1.06 | 1306.79 |
| 14-quadratic/1x | 100 | 9.41 ± 0.4% | not timed | not timed | 12.14 ± 0.6% | 1.01 ± 3.0% | not timed | not timed | 9.47 ± 0.4% | | 0.99 | 0.78 | 9.35 |
| 14-quadratic/2x | 200 | 5.33 ± 2.9% | not timed | not timed | 6.08 ± 1.7% | 0.55 ± 16.8% | not timed | not timed | 5.34 ± 0.7% | | 1.00 | 0.88 | 9.70 |
| 14-quadratic/10x | 1000 | 1.18 ± 0.3% | not timed | not timed | 1.22 ± 0.4% | 0.12 ± 1.6% | not timed | not timed | 1.18 ± 0.6% | | 1.00 | 0.97 | 10.03 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.69 ± 0.5% | not timed | not timed | 0.48 ± 0.2% | 0.64 ± 7.7% | not timed | not timed | 1.68 ± 0.6% | | 1.01 | 3.53 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 100.05 ± 7.9% | not timed | not timed | 17.21 ± 1.0% | 171.75 ± 1.6% | not timed | not timed | 99.84 ± 8.1% | | 1.00 | 5.81 | 0.58 |
| 05-lexer-veryl/compile-single | 1 | 16.80 ± 1.4% | not timed | not timed | 3.02 ± 0.6% | 7.90 ± 2.3% | not timed | not timed | 16.84 ± 1.7% | | 1.00 | 5.57 | 2.13 |
| 07-unicode-character-data/compile | 1 | 62.97 ± 0.2% | not timed | not timed | 30.43 ± 1.0% | 44.97 ± 1.4% | not timed | not timed | 62.77 ± 1.1% | | 1.00 | 2.07 | 1.40 |
| 09-aws-keys/compile-full | 1 | 44.61 ± 0.2% | not timed | not timed | 9.85 ± 1.4% | 28.14 ± 0.6% | not timed | not timed | 44.29 ± 0.3% | | 1.01 | 4.53 | 1.59 |
| 09-aws-keys/compile-quick | 1 | 198.25 ± 0.0% | not timed | not timed | 57.63 ± 0.4% | 158.47 ± 3.5% | not timed | not timed | 196.38 ± 1.0% | | 1.01 | 3.44 | 1.25 |
| 10-bounded-repeat/compile-context | 1 | 15.56 ± 2.8% | not timed | not timed | 14.52 ± 0.3% | 20.19 ± 4.0% | not timed | not timed | 15.41 ± 2.2% | | 1.01 | 1.07 | 0.77 |
| 10-bounded-repeat/compile-capitals | 1 | 93.28 ± 0.2% | not timed | not timed | 10.65 ± 0.3% | 29.72 ± 1.9% | not timed | not timed | 91.44 ± 0.8% | | 1.02 | 8.76 | 3.14 |
| 11-unstructured-to-json/compile | 1 | 98.25 ± 1.8% | not timed | not timed | 47.22 ± 8.3% | 80.59 ± 4.0% | not timed | not timed | 97.65 ± 0.7% | | 1.01 | 2.08 | 1.22 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.5% | not timed | not timed | 0.09 ± 0.2% | 0.10 ± 28.6% | not timed | not timed | 0.35 ± 2.2% | | 1.01 | 4.08 | 3.57 |

