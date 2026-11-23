# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159278988 |
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
| literal: a word | 217 | 53883.49 ± 3.9% | 1240.77 ± 3.3% | 46.35 ± 13.0% | 53172.56 ± 3.0% | 16248.68 ± 6.1% | 16.56 ± 3.0% | 159.70 ± 4.9% | 55297.59 ± 4.7% | 43.43 | 0.97 | 1.01 | 3.32 |
| literal: a word that is not there | 0 | 79064.73 ± 3.9% | 1235.13 ± 1.6% | 45.87 ± 3.2% | 63573.60 ± 2.9% | 54891.06 ± 3.5% | 15.75 ± 3.6% | 143.87 ± 12.7% | 78510.27 ± 5.3% | 64.01 | 1.01 | 1.24 | 1.44 |
| literal: one of four words | 661 | 20011.69 ± 1.3% | 1230.61 ± 12.7% | 25.34 ± 1.5% | 14835.18 ± 18.0% | 38.42 ± 27.2% | 5.21 ± 8.7% | 12.52 ± 9.5% | 19856.67 ± 5.2% | 16.26 | 1.01 | 1.35 | 520.90 |
| literal: a word in any case | 217 | 48894.05 ± 3.0% | 1252.16 ± 4.5% | 33.50 ± 3.7% | 14726.15 ± 3.2% | 73.44 ± 1.1% | refused | differs | 48661.16 ± 3.8% | 39.05 | 1.00 | 3.32 | 665.75 |
| literal: an href attribute | 33 | 46230.75 ± 15.2% | 1211.38 ± 16.7% | 37.63 ± 3.6% | 46318.13 ± 5.2% | 3507.88 ± 58.3% | 11.31 ± 10.0% | 133.56 ± 7.8% | 47964.21 ± 4.3% | 38.16 | 0.96 | 1.00 | 13.18 |
| literal: a word, second text | 123 | 53582.36 ± 7.7% | 1204.31 ± 3.6% | 43.13 ± 1.5% | 49371.60 ± 7.0% | 14422.32 ± 8.5% | 20.58 ± 6.6% | 121.05 ± 11.9% | 53702.52 ± 3.8% | 44.49 | 1.00 | 1.09 | 3.72 |
| class: two capitalized words | 1331 | 1102.18 ± 6.4% | 1123.74 ± 5.3% | 40.64 ± 4.4% | 680.07 ± 4.8% | 61.62 ± 5.9% | 13.74 ± 7.5% | 104.29 ± 6.4% | 1105.72 ± 10.6% | 0.98 | 1.00 | 1.62 | 17.89 |
| class: a word that ends in ing | 3399 | 1035.35 ± 4.7% | 1036.84 ± 4.8% | 27.64 ± 2.5% | 628.25 ± 3.7% | 45.39 ± 8.7% | 7.87 ± 3.4% | 30.10 ± 2.1% | 1033.90 ± 4.9% | 1.00 | 1.00 | 1.65 | 22.81 |
| class: a word in capitals | 2332 | 1586.85 ± 2.8% | 1085.06 ± 1.3% | 42.23 ± 0.6% | 660.46 ± 0.6% | 64.50 ± 22.5% | 16.32 ± 2.2% | 134.54 ± 1.6% | 1568.69 ± 1.4% | 1.46 | 1.01 | 2.40 | 24.60 |
| class: a number | 8288 | 2491.78 ± 6.6% | 953.37 ± 8.1% | 41.98 ± 2.7% | 2281.29 ± 3.8% | 59.65 ± 20.8% | 0.46 ± 3.3% | 92.23 ± 11.3% | 2525.55 ± 14.2% | 2.61 | 0.99 | 1.09 | 41.77 |
| class: two capitalized words, second text | 5359 | 849.64 ± 2.1% | 850.52 ± 0.9% | 35.96 ± 0.8% | 566.45 ± 12.8% | 51.07 ± 12.3% | 17.65 ± 2.4% | 94.39 ± 3.0% | 845.40 ± 5.2% | 1.00 | 1.01 | 1.50 | 16.64 |
| other: a word between two words | 6104 | 1076.15 ± 5.8% | 913.67 ± 4.0% | 36.04 ± 1.4% | 1004.93 ± 6.0% | 162.83 ± 22.7% | 10.85 ± 3.8% | 110.11 ± 9.4% | 1089.90 ± 6.1% | 1.18 | 0.99 | 1.07 | 6.61 |
| other: a number before a unit, second text | 1481 | 12698.81 ± 6.5% | 1152.51 ± 4.9% | 40.89 ± 3.7% | 11092.94 ± 5.1% | 60.24 ± 16.9% | 19.15 ± 6.2% | 104.69 ± 10.0% | 12786.53 ± 6.1% | 11.02 | 0.99 | 1.14 | 210.79 |
| other: a heading's start tag | 110 | 30045.62 ± 1.3% | 1197.75 ± 1.0% | 39.89 ± 0.8% | 3279.49 ± 8.3% | 2520.15 ± 8.6% | 14.15 ± 1.7% | 150.59 ± 1.3% | 30095.44 ± 0.7% | 25.08 | 1.00 | 9.16 | 11.92 |
| other: a whole word | 217 | 36442.96 ± 56.6% | 1199.37 ± 1.5% | 45.20 ± 7.3% | 35960.01 ± 1.6% | 74.61 ± 1.4% | 13.65 ± 1.2% | 83.85 ± 5.7% | 37000.83 ± 2.3% | 30.39 | 0.98 | 1.01 | 488.47 |
| other: a line's first word, second text | 3716 | 3327.36 ± 0.9% | 1010.41 ± 4.0% | 49.33 ± 8.5% | 3439.01 ± 1.8% | 100.96 ± 3.3% | refused | refused | 3330.86 ± 1.4% | 3.29 | 1.00 | 0.97 | 32.96 |
| other: fourteen octets before an x | 87 | 46549.91 ± 26.0% | 336.94 ± 43.7% | 9.85 ± 3.0% | 4846.84 ± 52.5% | 14.38 ± 14.0% | differs | 25.87 ± 2.3% | 46300.94 ± 4.0% | 138.15 | 1.01 | 9.60 | 3237.54 |
| other: a Greek word | 21815 | 599.38 ± 4.2% | 480.18 ± 3.5% | 47.84 ± 0.9% | 366.57 ± 3.1% | 60.32 ± 4.7% | differs | refused | 599.26 ± 6.8% | 1.25 | 1.00 | 1.64 | 9.94 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 35.92 ± 3.9% | 35.86 ± 3.3% | 1.53 ± 0.7% | 24.20 ± 3.5% | 3.60 ± 7.3% | differs | 5.85 ± 4.9% | 35.33 ± 3.7% | 1.00 | 1.02 | 1.48 | 9.98 |
| a UUID | 32895 | 29.46 ± 0.6% | 29.44 ± 0.6% | 1.04 ± 4.8% | 18.11 ± 3.3% | 3.59 ± 3.9% | 0.73 ± 1.0% | 4.47 ± 5.0% | 29.62 ± 4.0% | 1.00 | 0.99 | 1.63 | 8.20 |
| an IPv4 address | 33176 | 48.45 ± 3.9% | 47.82 ± 4.5% | 3.29 ± 12.9% | 34.74 ± 5.1% | 9.13 ± 2.0% | differs | 5.73 ± 6.9% | 46.89 ± 3.8% | 1.01 | 1.03 | 1.39 | 5.31 |
| a date and time | 32954 | 44.98 ± 69.6% | 45.55 ± 4.6% | 2.47 ± 3.1% | 26.87 ± 1.6% | 11.03 ± 5.4% | 1.33 ± 3.0% | 10.99 ± 8.8% | 45.04 ± 11.2% | 0.99 | 1.00 | 1.67 | 4.08 |
| a field path | 32606 | 37.74 ± 7.9% | 37.69 ± 5.5% | 1.74 ± 2.6% | 28.02 ± 6.0% | 4.72 ± 8.1% | differs | 4.10 ± 3.9% | 37.69 ± 5.2% | 1.00 | 1.00 | 1.35 | 7.99 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 13.15 ± 4.1% | 13.54 ± 4.2% | 13.54 ± 3.8% | 17.29 ± 3.8% | 7.44 ± 5.6% | 1.05 ± 1.3% | none | 13.53 ± 1.1% | 0.97 | 0.97 | 0.76 | 1.77 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 368.51 ± 4.3% | 369.20 ± 3.6% | 428.03 ± 3.1% | 133.86 ± 5.7% | 316.91 ± 10.2% | 896.84 ± 3.0% | 5926.61 ± 6.5% | 376.45 ± 4.1% | 1.00 | 0.98 | 2.75 | 1.16 |
| a UUID | 62 | 241.62 ± 4.9% | 241.98 ± 3.7% | 263.24 ± 7.0% | 75.04 ± 7.7% | 157.54 ± 7.1% | 316.30 ± 6.3% | 7228.19 ± 4.8% | 238.87 ± 3.5% | 1.00 | 1.01 | 3.22 | 1.53 |
| an IPv4 address | 29 | 717.58 ± 3.7% | 730.26 ± 2.8% | 984.40 ± 5.4% | 121.11 ± 4.4% | 203.30 ± 4.6% | 560.46 ± 3.6% | 12703.12 ± 4.0% | 712.03 ± 3.8% | 0.98 | 1.01 | 5.93 | 3.53 |
| a date and time | 56 | 521.82 ± 4.7% | 525.58 ± 7.1% | 645.08 ± 3.5% | 113.86 ± 3.2% | 216.82 ± 5.7% | 574.01 ± 6.9% | 8088.04 ± 4.9% | 525.16 ± 5.0% | 0.99 | 0.99 | 4.58 | 2.41 |
| a field path | 39 | 359.56 ± 3.6% | 359.57 ± 1.8% | 413.45 ± 10.6% | 124.49 ± 3.1% | 296.26 ± 28.1% | 892.87 ± 4.8% | 7311.41 ± 3.9% | 359.24 ± 4.5% | 1.00 | 1.00 | 2.89 | 1.21 |
| literal: a word | 7 | 1170.14 ± 5.9% | 1226.92 ± 3.6% | 2131.81 ± 3.1% | 828.91 ± 51.3% | 1015.65 ± 7.3% | 1870.95 ± 4.1% | 48586.21 ± 1.6% | 1142.26 ± 7.5% | 0.95 | 1.02 | 1.41 | 1.15 |
| literal: a word that is not there | 8 | 1088.75 ± 2.5% | 1170.33 ± 1.8% | 1965.14 ± 1.8% | 753.78 ± 2.3% | 963.89 ± 19.6% | 1707.43 ± 3.9% | 46505.09 ± 3.1% | 1083.82 ± 2.6% | 0.93 | 1.00 | 1.44 | 1.13 |
| literal: one of four words | 26 | 423.59 ± 12.7% | 682.39 ± 8.3% | 884.30 ± 7.5% | 67.40 ± 5.0% | 383.94 ± 13.0% | 645.29 ± 5.6% | 28208.04 ± 3.2% | 437.49 ± 6.3% | 0.62 | 0.97 | 6.28 | 1.10 |
| literal: a word in any case | 11 | 868.97 ± 6.0% | 914.56 ± 5.2% | 1361.91 ± 5.5% | 22.91 ± 6.0% | 1056.42 ± 4.8% | refused | 39037.70 ± 1.5% | 862.99 ± 6.5% | 0.95 | 1.01 | 37.93 | 0.82 |
| literal: an href attribute | 12 | 597.18 ± 4.8% | 621.86 ± 3.7% | 794.80 ± 5.4% | 60.59 ± 1.0% | 741.61 ± 1.5% | 1459.11 ± 0.9% | 32903.81 ± 1.9% | 599.31 ± 2.6% | 0.96 | 1.00 | 9.86 | 0.81 |
| literal: a word, second text | 10 | 981.22 ± 3.8% | 1069.32 ± 2.8% | 1728.74 ± 5.6% | 703.20 ± 11.2% | 846.40 ± 1.8% | 1526.15 ± 3.5% | 45087.94 ± 1.4% | 986.05 ± 1.4% | 0.92 | 1.00 | 1.40 | 1.16 |
| class: two capitalized words | 23 | 794.59 ± 2.3% | 857.21 ± 2.5% | 1223.37 ± 3.3% | 154.85 ± 2.0% | 785.91 ± 9.7% | 1428.32 ± 2.0% | 9542.48 ± 1.2% | 796.77 ± 0.7% | 0.93 | 1.00 | 5.13 | 1.01 |
| class: a word that ends in ing | 9 | 987.61 ± 6.0% | 1116.97 ± 3.5% | 1870.88 ± 1.7% | 199.54 ± 2.8% | 1103.34 ± 5.8% | 2181.37 ± 4.7% | 24580.07 ± 1.2% | 985.72 ± 7.8% | 0.88 | 1.00 | 4.95 | 0.90 |
| class: a word in capitals | 16 | 881.33 ± 10.6% | 953.14 ± 3.4% | 1499.06 ± 10.8% | 201.00 ± 2.1% | 1191.68 ± 12.1% | 1988.50 ± 1.7% | 12468.10 ± 4.8% | 870.03 ± 3.4% | 0.92 | 1.01 | 4.38 | 0.74 |
| class: a number | 6 | 1084.57 ± 45.3% | 1195.11 ± 2.6% | 2113.91 ± 4.3% | 58.67 ± 1.5% | 2097.03 ± 19.5% | 3522.14 ± 1.0% | 36110.29 ± 5.2% | 1091.43 ± 2.2% | 0.91 | 0.99 | 18.48 | 0.52 |
| class: two capitalized words, second text | 23 | 801.73 ± 5.6% | 860.17 ± 1.6% | 1222.91 ± 1.3% | 152.14 ± 2.0% | 781.31 ± 6.6% | 1390.70 ± 1.1% | 9540.88 ± 1.8% | 795.97 ± 1.5% | 0.93 | 1.01 | 5.27 | 1.03 |
| other: a word between two words | 13 | 955.54 ± 2.6% | 1001.92 ± 2.3% | 1548.65 ± 2.3% | 205.90 ± 1.5% | 760.93 ± 1.2% | 1537.83 ± 1.1% | 22385.01 ± 2.7% | 971.27 ± 4.3% | 0.95 | 0.98 | 4.64 | 1.26 |
| other: a number before a unit, second text | 15 | 678.72 ± 30.9% | 751.48 ± 2.6% | 1023.23 ± 3.4% | 55.68 ± 2.0% | 947.60 ± 3.3% | 1717.88 ± 4.9% | 24254.36 ± 7.0% | 678.93 ± 2.7% | 0.90 | 1.00 | 12.19 | 0.72 |
| other: a heading's start tag | 13 | 615.84 ± 3.1% | 626.56 ± 14.2% | 809.45 ± 3.8% | 58.36 ± 1.8% | 925.48 ± 2.5% | 1628.58 ± 1.9% | 27966.55 ± 3.9% | 615.47 ± 3.0% | 0.98 | 1.00 | 10.55 | 0.67 |
| other: a whole word | 11 | 990.27 ± 11.2% | 1048.95 ± 8.4% | 1654.19 ± 3.8% | 184.22 ± 3.0% | 874.03 ± 9.0% | 1577.73 ± 5.9% | 43560.76 ± 1.7% | 999.55 ± 5.2% | 0.94 | 0.99 | 5.38 | 1.13 |
| other: a line's first word, second text | 17 | 945.04 ± 1.5% | 999.79 ± 2.8% | 1560.99 ± 2.2% | 193.52 ± 1.2% | 1035.86 ± 18.0% | refused | refused | 943.25 ± 1.8% | 0.95 | 1.00 | 4.88 | 0.91 |
| other: fourteen octets before an x | 16 | 183.56 ± 3.1% | 260.95 ± 2.7% | 296.98 ± 1.9% | 21.93 ± 3.6% | 680.08 ± 3.2% | 746.72 ± 5.7% | 20783.47 ± 5.7% | 181.98 ± 4.5% | 0.70 | 1.01 | 8.37 | 0.27 |
| other: a Greek word | 8 | 712.77 ± 9.7% | 949.18 ± 55.4% | 1463.13 ± 1.1% | 73.31 ± 1.4% | 2104.88 ± 21.2% | 3329.12 ± 2.0% | refused | 712.46 ± 3.4% | 0.75 | 1.00 | 9.72 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 35368.36 ± 1.6% | not timed | not timed | 44259.70 ± 4.6% | 3743.92 ± 18.5% | not timed | not timed | 35204.79 ± 1.9% | | 1.00 | 0.80 | 9.45 |
| 01-literal/sherlock-casei-en | 522 | 10830.15 ± 1.2% | not timed | not timed | 11329.99 ± 1.1% | 51.03 ± 3.0% | not timed | not timed | 10777.44 ± 6.1% | | 1.00 | 0.96 | 212.22 |
| 01-literal/sherlock-ru | 724 | 36198.07 ± 1.4% | not timed | not timed | 41883.18 ± 4.6% | 2348.27 ± 8.6% | not timed | not timed | 36226.19 ± 2.2% | | 1.00 | 0.86 | 15.41 |
| 01-literal/sherlock-casei-ru | 746 | 11055.39 ± 0.9% | not timed | not timed | 9235.70 ± 5.0% | 55.99 ± 3.6% | not timed | not timed | 11040.35 ± 1.4% | | 1.00 | 1.20 | 197.45 |
| 01-literal/sherlock-zh | 30 | 71080.00 ± 2.7% | not timed | not timed | 57560.52 ± 5.9% | 2056.48 ± 6.5% | not timed | not timed | 71040.41 ± 51.1% | | 1.00 | 1.23 | 34.56 |
| 02-literal-alternate/sherlock-en | 714 | 16119.43 ± 4.0% | not timed | not timed | 13392.20 ± 2.7% | 28.86 ± 2.5% | not timed | not timed | 16031.95 ± 3.9% | | 1.01 | 1.20 | 558.44 |
| 02-literal-alternate/sherlock-casei-en | 725 | 2768.37 ± 6.0% | not timed | not timed | 2905.56 ± 4.7% | 17.56 ± 2.0% | not timed | not timed | 2635.16 ± 2.0% | | 1.05 | 0.95 | 157.68 |
| 02-literal-alternate/sherlock-ru | 899 | 9071.57 ± 0.7% | not timed | not timed | 7347.70 ± 1.0% | 37.06 ± 31.7% | not timed | not timed | 9036.55 ± 7.5% | | 1.00 | 1.23 | 244.80 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2482.85 ± 1.9% | not timed | not timed | 1411.73 ± 1.6% | 15.57 ± 12.9% | not timed | not timed | 2448.10 ± 0.5% | | 1.01 | 1.76 | 159.46 |
| 02-literal-alternate/sherlock-zh | 207 | 22916.22 ± 0.9% | not timed | not timed | 15565.69 ± 1.2% | 52.43 ± 1.4% | not timed | not timed | 22872.62 ± 6.1% | | 1.00 | 1.47 | 437.06 |
| 03-date/ascii | 111817 | 149.76 ± 0.7% | not timed | not timed | 118.63 ± 1.5% | 0.31 ± 3.8% | not timed | not timed | 148.53 ± 1.3% | | 1.01 | 1.26 | 486.04 |
| 04-ruff-noqa/real | 84 | 835.09 ± 3.8% | not timed | not timed | 674.53 ± 5.9% | 30.32 ± 2.7% | not timed | not timed | 836.43 ± 5.2% | | 1.00 | 1.24 | 27.55 |
| 04-ruff-noqa/tweaked | 44 | 775.41 ± 1.6% | not timed | not timed | 677.15 ± 1.4% | 474.63 ± 11.0% | not timed | not timed | 757.40 ± 0.6% | | 1.02 | 1.15 | 1.63 |
| 05-lexer-veryl/single | 124800 | 6.04 ± 1.3% | not timed | not timed | 7.61 ± 1.1% | 0.35 ± 9.3% | not timed | not timed | 6.01 ± 2.2% | | 1.01 | 0.79 | 17.47 |
| 06-cloud-flare-redos/original | 107 | 304.59 ± 1.9% | not timed | not timed | 279.88 ± 8.4% | 38.24 ± 6.1% | not timed | not timed | 304.67 ± 16.1% | | 1.00 | 1.09 | 7.96 |
| 06-cloud-flare-redos/simplified-short | 102 | 293.31 ± 6.4% | not timed | not timed | 295.68 ± 4.1% | 41.26 ± 6.0% | not timed | not timed | 303.75 ± 5.0% | | 0.97 | 0.99 | 7.11 |
| 06-cloud-flare-redos/simplified-long | 10000 | 324.67 ± 3.5% | not timed | not timed | 318.78 ± 0.3% | 44.93 ± 1.7% | not timed | not timed | 325.11 ± 2.9% | | 1.00 | 1.02 | 7.23 |
| 07-unicode-character-data/parse-line | 558784 | 316.56 ± 2.1% | not timed | not timed | 251.90 ± 0.8% | 66.83 ± 6.0% | not timed | not timed | 310.89 ± 2.0% | | 1.02 | 1.26 | 4.74 |
| 08-words/all-english | 56691 | 133.90 ± 43.4% | not timed | not timed | 105.32 ± 27.0% | 19.97 ± 26.4% | not timed | not timed | 133.83 ± 1.8% | | 1.00 | 1.27 | 6.70 |
| 08-words/long-english | 839 | 1204.28 ± 1.3% | not timed | not timed | 713.64 ± 1.0% | 49.73 ± 10.2% | not timed | not timed | 1198.95 ± 3.9% | | 1.00 | 1.69 | 24.21 |
| 09-aws-keys/full | 0 | 660.52 ± 7.2% | not timed | not timed | 734.89 ± 3.6% | 97.64 ± 2.6% | not timed | not timed | 667.62 ± 4.9% | | 0.99 | 0.90 | 6.77 |
| 09-aws-keys/quick | 0 | 1299.47 ± 0.8% | not timed | not timed | 1229.67 ± 1.5% | 544.62 ± 13.6% | not timed | not timed | 1304.64 ± 1.5% | | 1.00 | 1.06 | 2.39 |
| 10-bounded-repeat/letters-en | 1833 | 753.61 ± 2.1% | not timed | not timed | 720.35 ± 4.7% | 29.72 ± 1.4% | not timed | not timed | 755.07 ± 5.1% | | 1.00 | 1.05 | 25.35 |
| 10-bounded-repeat/letters-ru | 3475 | 438.62 ± 1.8% | not timed | not timed | 638.77 ± 3.3% | 30.03 ± 13.4% | not timed | not timed | 436.73 ± 1.2% | | 1.00 | 0.69 | 14.61 |
| 10-bounded-repeat/context | 53 | 107.56 ± 1.7% | not timed | not timed | 90.78 ± 16.6% | 29.38 ± 29.3% | not timed | not timed | 108.46 ± 3.6% | | 0.99 | 1.18 | 3.66 |
| 10-bounded-repeat/capitals | 11 | 1267.23 ± 3.6% | not timed | not timed | 733.44 ± 3.9% | 53.81 ± 2.5% | not timed | not timed | 1257.84 ± 4.8% | | 1.01 | 1.73 | 23.55 |
| 11-unstructured-to-json/extract | 600 | 63.07 ± 4.4% | not timed | not timed | 105.17 ± 4.1% | 76.96 ± 3.2% | not timed | not timed | 62.47 ± 3.1% | | 1.01 | 0.60 | 0.82 |
| 12-dictionary/single | 1 | 643.38 ± 2.1% | not timed | not timed | 625.07 ± 3.8% | 0.63 ± 6.5% | not timed | not timed | 647.42 ± 2.5% | | 0.99 | 1.03 | 1020.94 |
| 14-quadratic/1x | 100 | 15.98 ± 3.9% | not timed | not timed | 17.55 ± 2.2% | 1.46 ± 4.1% | not timed | not timed | 16.35 ± 2.6% | | 0.98 | 0.91 | 10.93 |
| 14-quadratic/2x | 200 | 9.37 ± 3.9% | not timed | not timed | 7.92 ± 4.3% | 0.79 ± 5.7% | not timed | not timed | 9.35 ± 1.9% | | 1.00 | 1.18 | 11.88 |
| 14-quadratic/10x | 1000 | 2.13 ± 2.8% | not timed | not timed | 1.44 ± 0.3% | 0.17 ± 1.4% | not timed | not timed | 2.15 ± 5.5% | | 0.99 | 1.48 | 12.30 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 2.44 ± 3.8% | not timed | not timed | 0.54 ± 3.0% | 0.86 ± 4.5% | not timed | not timed | 2.41 ± 8.0% | | 1.01 | 4.49 | 2.82 |
| 04-ruff-noqa/compile-real | 1 | 158.26 ± 8.7% | not timed | not timed | 21.20 ± 1.8% | 228.64 ± 3.6% | not timed | not timed | 158.23 ± 3.9% | | 1.00 | 7.46 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 23.51 ± 2.3% | not timed | not timed | 3.89 ± 1.9% | 10.94 ± 3.7% | not timed | not timed | 22.74 ± 5.4% | | 1.03 | 6.04 | 2.15 |
| 07-unicode-character-data/compile | 1 | 93.84 ± 4.9% | not timed | not timed | 39.84 ± 5.5% | 60.98 ± 3.1% | not timed | not timed | 91.21 ± 14.9% | | 1.03 | 2.36 | 1.54 |
| 09-aws-keys/compile-full | 1 | 63.38 ± 3.5% | not timed | not timed | 12.65 ± 3.5% | 38.53 ± 15.7% | not timed | not timed | 64.63 ± 3.1% | | 0.98 | 5.01 | 1.64 |
| 09-aws-keys/compile-quick | 1 | 299.35 ± 4.1% | not timed | not timed | 75.29 ± 4.1% | 215.18 ± 5.5% | not timed | not timed | 294.36 ± 3.7% | | 1.02 | 3.98 | 1.39 |
| 10-bounded-repeat/compile-context | 1 | 23.59 ± 13.8% | not timed | not timed | 17.27 ± 8.4% | 26.72 ± 3.9% | not timed | not timed | 23.60 ± 18.8% | | 1.00 | 1.37 | 0.88 |
| 10-bounded-repeat/compile-capitals | 1 | 132.68 ± 3.6% | not timed | not timed | 12.60 ± 4.0% | 38.28 ± 4.2% | not timed | not timed | 131.87 ± 12.7% | | 1.01 | 10.53 | 3.47 |
| 11-unstructured-to-json/compile | 1 | 141.18 ± 3.0% | not timed | not timed | 60.86 ± 3.0% | 110.52 ± 0.5% | not timed | not timed | 140.14 ± 1.8% | | 1.01 | 2.32 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.46 ± 5.8% | not timed | not timed | 0.10 ± 4.7% | 0.14 ± 23.7% | not timed | not timed | 0.45 ± 5.6% | | 1.02 | 4.71 | 3.29 |

