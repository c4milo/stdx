# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148046818 |
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
| literal: a word | 217 | 33492.60 ± 7.0% | 904.00 ± 0.4% | 20.06 ± 1.2% | 31127.54 ± 1.0% | 9008.12 ± 8.8% | 10.83 ± 0.2% | 75.65 ± 1.2% | 32831.81 ± 3.9% | 37.05 | 1.02 | 1.08 | 3.72 |
| literal: a word that is not there | 0 | 50129.68 ± 1.7% | 911.70 ± 1.5% | 20.04 ± 0.4% | 39805.27 ± 1.1% | 30108.96 ± 0.7% | 10.78 ± 0.2% | 71.06 ± 3.7% | 49323.32 ± 1.5% | 54.98 | 1.02 | 1.26 | 1.66 |
| literal: one of four words | 661 | 11144.85 ± 2.6% | 883.82 ± 0.4% | 11.28 ± 0.3% | 9096.06 ± 0.5% | 19.29 ± 1.3% | 3.96 ± 0.5% | 6.45 ± 3.0% | 11251.87 ± 0.9% | 12.61 | 0.99 | 1.23 | 577.85 |
| literal: a word in any case | 217 | 26084.25 ± 1.3% | 902.72 ± 0.1% | 15.96 ± 0.2% | 9219.57 ± 0.3% | 37.24 ± 0.3% | refused | differs | 25999.15 ± 0.7% | 28.90 | 1.00 | 2.83 | 700.40 |
| literal: an href attribute | 33 | 27083.33 ± 1.3% | 908.70 ± 0.6% | 18.89 ± 0.5% | 27137.71 ± 0.9% | 2054.41 ± 0.9% | 8.29 ± 0.4% | 60.44 ± 1.8% | 26759.17 ± 0.8% | 29.80 | 1.01 | 1.00 | 13.18 |
| literal: a word, second text | 123 | 34176.74 ± 2.8% | 906.90 ± 0.2% | 19.91 ± 8.2% | 32065.31 ± 0.8% | 7141.59 ± 4.6% | 11.80 ± 0.4% | 64.03 ± 2.6% | 33831.45 ± 8.9% | 37.69 | 1.01 | 1.07 | 4.79 |
| class: two capitalized words | 1331 | 781.22 ± 0.4% | 839.21 ± 1.0% | 18.86 ± 0.6% | 505.38 ± 0.6% | 34.33 ± 0.6% | 9.49 ± 0.1% | 54.80 ± 1.1% | 781.22 ± 0.1% | 0.93 | 1.00 | 1.55 | 22.76 |
| class: a word that ends in ing | 3399 | 765.92 ± 1.6% | 766.37 ± 0.4% | 13.41 ± 6.5% | 471.69 ± 1.2% | 25.65 ± 1.4% | 5.32 ± 0.4% | 15.75 ± 0.6% | 765.82 ± 0.1% | 1.00 | 1.00 | 1.62 | 29.86 |
| class: a word in capitals | 2332 | 981.51 ± 2.6% | 820.49 ± 0.1% | 19.77 ± 0.3% | 495.43 ± 1.4% | 36.67 ± 11.6% | 10.59 ± 1.1% | 76.45 ± 0.3% | 980.84 ± 1.4% | 1.20 | 1.00 | 1.98 | 26.77 |
| class: a number | 8288 | 1379.91 ± 2.9% | 702.03 ± 0.6% | 19.50 ± 0.4% | 1481.74 ± 1.0% | 36.98 ± 10.5% | 0.34 ± 0.4% | 54.12 ± 2.6% | 1388.68 ± 1.1% | 1.97 | 0.99 | 0.93 | 37.32 |
| class: two capitalized words, second text | 5359 | 628.34 ± 0.2% | 628.36 ± 0.3% | 17.37 ± 0.3% | 416.84 ± 0.3% | 30.23 ± 6.0% | 10.78 ± 1.0% | 50.48 ± 3.3% | 628.21 ± 0.3% | 1.00 | 1.00 | 1.51 | 20.79 |
| other: a word between two words | 6104 | 694.48 ± 2.4% | 656.75 ± 0.1% | 17.13 ± 0.5% | 690.35 ± 3.0% | 96.85 ± 14.5% | 7.28 ± 0.2% | 55.59 ± 12.2% | 692.86 ± 1.6% | 1.06 | 1.00 | 1.01 | 7.17 |
| other: a number before a unit, second text | 1481 | 6998.80 ± 4.2% | 839.60 ± 1.6% | 18.73 ± 0.4% | 6354.96 ± 5.9% | 35.20 ± 0.6% | 11.26 ± 0.2% | 53.94 ± 11.3% | 7093.10 ± 0.3% | 8.34 | 0.99 | 1.10 | 198.82 |
| other: a heading's start tag | 110 | 19021.84 ± 5.3% | 900.63 ± 1.3% | 19.55 ± 0.5% | 2006.00 ± 0.6% | 1473.44 ± 8.8% | 10.10 ± 0.3% | 71.04 ± 0.8% | 18174.86 ± 2.0% | 21.12 | 1.05 | 9.48 | 12.91 |
| other: a whole word | 217 | 22575.98 ± 6.5% | 903.41 ± 0.1% | 20.73 ± 1.0% | 22582.39 ± 10.9% | 41.32 ± 3.5% | 9.54 ± 0.3% | 46.12 ± 0.8% | 21397.17 ± 4.5% | 24.99 | 1.06 | 1.00 | 546.38 |
| other: a line's first word, second text | 3716 | 1912.73 ± 0.7% | 746.73 ± 0.1% | 24.00 ± 0.9% | 1717.85 ± 3.8% | 53.33 ± 1.2% | refused | refused | 1899.66 ± 2.1% | 2.56 | 1.01 | 1.11 | 35.86 |
| other: fourteen octets before an x | 87 | 25602.96 ± 3.0% | 197.09 ± 1.9% | 5.59 ± 1.4% | 2855.64 ± 1.4% | 8.94 ± 2.2% | differs | 14.96 ± 0.5% | 25383.12 ± 0.9% | 129.91 | 1.01 | 8.97 | 2862.90 |
| other: a Greek word | 21815 | 413.61 ± 0.4% | 350.12 ± 0.3% | 24.25 ± 0.8% | 261.45 ± 0.9% | 44.64 ± 9.6% | differs | refused | 412.60 ± 0.3% | 1.18 | 1.00 | 1.58 | 9.26 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.35 ± 1.7% | 24.34 ± 1.2% | 0.80 ± 2.0% | 16.77 ± 0.3% | 2.32 ± 2.3% | differs | 3.42 ± 0.5% | 24.66 ± 1.3% | 1.00 | 0.99 | 1.45 | 10.48 |
| a UUID | 32895 | 20.43 ± 9.5% | 20.34 ± 0.2% | 0.56 ± 7.2% | 12.78 ± 0.5% | 2.51 ± 2.3% | 0.43 ± 0.2% | 3.03 ± 3.7% | 20.47 ± 1.1% | 1.00 | 1.00 | 1.60 | 8.14 |
| an IPv4 address | 33176 | 33.62 ± 0.7% | 33.55 ± 0.5% | 1.81 ± 1.5% | 23.13 ± 0.3% | 5.78 ± 0.3% | differs | 3.38 ± 4.3% | 33.81 ± 1.5% | 1.00 | 0.99 | 1.45 | 5.82 |
| a date and time | 32954 | 30.23 ± 0.6% | 30.16 ± 0.3% | 1.27 ± 1.7% | 17.99 ± 0.3% | 6.67 ± 0.6% | 0.75 ± 0.4% | 5.69 ± 2.2% | 30.21 ± 1.0% | 1.00 | 1.00 | 1.68 | 4.53 |
| a field path | 32606 | 26.78 ± 0.6% | 27.21 ± 0.3% | 0.92 ± 0.8% | 19.29 ± 0.2% | 2.93 ± 3.3% | differs | 2.37 ± 0.7% | 27.16 ± 8.9% | 0.98 | 0.99 | 1.39 | 9.15 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.24 ± 0.4% | 8.13 ± 15.4% | 8.25 ± 15.7% | 10.48 ± 0.2% | 4.72 ± 1.6% | 0.62 ± 0.4% | none | 8.26 ± 2.9% | 1.01 | 1.00 | 0.79 | 1.74 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 189.48 ± 0.8% | 190.85 ± 2.7% | 224.56 ± 7.5% | 79.56 ± 3.9% | 178.74 ± 2.4% | 542.63 ± 6.6% | 3721.01 ± 0.2% | 189.54 ± 0.9% | 0.99 | 1.00 | 2.38 | 1.06 |
| a UUID | 62 | 123.14 ± 2.2% | 123.88 ± 0.2% | 138.04 ± 0.6% | 46.92 ± 1.7% | 88.25 ± 3.6% | 196.90 ± 9.2% | 3909.47 ± 0.7% | 123.06 ± 5.1% | 0.99 | 1.00 | 2.62 | 1.40 |
| an IPv4 address | 29 | 371.33 ± 2.2% | 376.44 ± 3.0% | 537.74 ± 3.8% | 69.50 ± 3.7% | 108.32 ± 5.8% | 320.56 ± 6.6% | 6580.31 ± 3.5% | 374.27 ± 3.6% | 0.99 | 0.99 | 5.34 | 3.43 |
| a date and time | 56 | 275.70 ± 0.7% | 278.55 ± 0.1% | 352.87 ± 0.4% | 67.70 ± 2.0% | 117.96 ± 3.0% | 368.01 ± 3.8% | 3984.51 ± 0.8% | 276.22 ± 0.4% | 0.99 | 1.00 | 4.07 | 2.34 |
| a field path | 39 | 186.20 ± 0.6% | 186.92 ± 0.5% | 219.66 ± 0.2% | 74.18 ± 2.9% | 162.84 ± 3.1% | 593.67 ± 8.1% | 4399.44 ± 1.5% | 185.97 ± 2.3% | 1.00 | 1.00 | 2.51 | 1.14 |
| literal: a word | 7 | 553.19 ± 0.3% | 604.38 ± 0.7% | 1118.97 ± 0.4% | 501.74 ± 0.2% | 560.98 ± 15.3% | 1213.44 ± 14.8% | 24275.08 ± 0.6% | 554.40 ± 0.5% | 0.92 | 1.00 | 1.10 | 0.99 |
| literal: a word that is not there | 8 | 532.86 ± 0.5% | 587.23 ± 1.2% | 1058.12 ± 0.7% | 461.75 ± 3.2% | 541.58 ± 3.3% | 1157.93 ± 14.0% | 23262.28 ± 0.8% | 532.10 ± 0.5% | 0.91 | 1.00 | 1.15 | 0.98 |
| literal: one of four words | 26 | 215.37 ± 0.4% | 357.81 ± 0.3% | 493.75 ± 0.6% | 41.97 ± 1.0% | 209.94 ± 11.5% | 438.17 ± 2.6% | 10570.71 ± 2.4% | 215.58 ± 2.0% | 0.60 | 1.00 | 5.13 | 1.03 |
| literal: a word in any case | 11 | 435.97 ± 6.4% | 465.04 ± 2.1% | 728.10 ± 0.6% | 14.60 ± 0.9% | 584.50 ± 4.0% | refused | 19249.21 ± 1.6% | 427.04 ± 4.5% | 0.94 | 1.02 | 29.85 | 0.75 |
| literal: an href attribute | 12 | 313.52 ± 0.6% | 326.38 ± 0.5% | 441.21 ± 0.5% | 36.26 ± 1.4% | 413.02 ± 4.1% | 925.70 ± 0.5% | 16601.80 ± 0.5% | 313.09 ± 0.3% | 0.96 | 1.00 | 8.65 | 0.76 |
| literal: a word, second text | 10 | 494.74 ± 0.2% | 549.35 ± 11.7% | 949.17 ± 13.1% | 412.61 ± 1.1% | 470.76 ± 1.7% | 979.74 ± 0.8% | 20003.49 ± 1.3% | 494.36 ± 0.5% | 0.90 | 1.00 | 1.20 | 1.05 |
| class: two capitalized words | 23 | 405.21 ± 8.7% | 433.28 ± 2.2% | 654.73 ± 4.0% | 94.53 ± 3.3% | 439.42 ± 8.7% | 928.09 ± 0.8% | 5579.41 ± 0.4% | 405.42 ± 9.5% | 0.94 | 1.00 | 4.29 | 0.92 |
| class: a word that ends in ing | 9 | 486.50 ± 0.6% | 543.67 ± 0.4% | 1010.57 ± 0.4% | 112.42 ± 11.8% | 619.80 ± 24.0% | 1396.48 ± 1.0% | 14566.13 ± 2.6% | 486.13 ± 0.4% | 0.89 | 1.00 | 4.33 | 0.78 |
| class: a word in capitals | 16 | 420.75 ± 9.5% | 451.95 ± 10.0% | 776.22 ± 1.0% | 119.87 ± 2.6% | 635.35 ± 2.1% | 1269.26 ± 1.7% | 7869.07 ± 1.1% | 419.42 ± 9.1% | 0.93 | 1.00 | 3.51 | 0.66 |
| class: a number | 6 | 527.52 ± 11.9% | 576.56 ± 0.3% | 1154.60 ± 0.3% | 36.24 ± 0.4% | 1137.19 ± 1.2% | 2181.42 ± 3.9% | 20456.70 ± 0.7% | 527.84 ± 0.7% | 0.91 | 1.00 | 14.56 | 0.46 |
| class: two capitalized words, second text | 23 | 406.04 ± 10.5% | 434.32 ± 10.6% | 655.18 ± 0.9% | 94.84 ± 1.1% | 432.75 ± 4.2% | 913.10 ± 0.4% | 5574.46 ± 1.6% | 406.11 ± 0.5% | 0.93 | 1.00 | 4.28 | 0.94 |
| other: a word between two words | 13 | 476.37 ± 0.3% | 499.48 ± 0.8% | 818.26 ± 10.7% | 121.13 ± 1.6% | 427.33 ± 8.0% | 1022.66 ± 0.9% | 12709.97 ± 8.9% | 476.46 ± 0.3% | 0.95 | 1.00 | 3.93 | 1.11 |
| other: a number before a unit, second text | 15 | 351.68 ± 16.1% | 388.19 ± 0.7% | 555.35 ± 0.5% | 33.79 ± 0.8% | 520.23 ± 1.0% | 1092.42 ± 4.5% | 12110.07 ± 10.2% | 352.37 ± 0.3% | 0.91 | 1.00 | 10.41 | 0.68 |
| other: a heading's start tag | 13 | 325.65 ± 0.4% | 331.57 ± 8.4% | 451.57 ± 0.8% | 34.34 ± 1.6% | 500.13 ± 2.7% | 1077.89 ± 1.2% | 13586.69 ± 1.3% | 324.71 ± 0.3% | 0.98 | 1.00 | 9.48 | 0.65 |
| other: a whole word | 11 | 486.02 ± 0.5% | 523.19 ± 12.6% | 872.38 ± 1.3% | 108.02 ± 7.2% | 485.27 ± 4.7% | 1051.21 ± 0.3% | 20185.62 ± 4.0% | 485.17 ± 12.0% | 0.93 | 1.00 | 4.50 | 1.00 |
| other: a line's first word, second text | 17 | 468.81 ± 0.5% | 491.46 ± 0.5% | 840.38 ± 0.5% | 112.59 ± 1.5% | 579.50 ± 2.9% | refused | refused | 468.40 ± 0.9% | 0.95 | 1.00 | 4.16 | 0.81 |
| other: fourteen octets before an x | 16 | 86.09 ± 2.6% | 121.28 ± 0.2% | 141.68 ± 1.0% | 13.88 ± 1.2% | 382.96 ± 3.8% | 453.32 ± 1.2% | 10494.29 ± 1.7% | 86.23 ± 2.6% | 0.71 | 1.00 | 6.20 | 0.22 |
| other: a Greek word | 8 | 352.18 ± 2.7% | 491.20 ± 0.2% | 850.20 ± 1.3% | 44.83 ± 8.1% | 1106.61 ± 2.4% | 2142.55 ± 0.7% | refused | 351.81 ± 0.5% | 0.72 | 1.00 | 7.86 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21981.70 ± 4.3% | not timed | not timed | 26764.27 ± 7.9% | 1794.75 ± 17.6% | not timed | not timed | 21885.00 ± 1.5% | | 1.00 | 0.82 | 12.25 |
| 01-literal/sherlock-casei-en | 522 | 6248.40 ± 0.7% | not timed | not timed | 7016.61 ± 4.9% | 28.51 ± 0.8% | not timed | not timed | 6211.12 ± 0.8% | | 1.01 | 0.89 | 219.20 |
| 01-literal/sherlock-ru | 724 | 23229.31 ± 1.7% | not timed | not timed | 27058.03 ± 2.5% | 1034.85 ± 10.3% | not timed | not timed | 23157.96 ± 2.6% | | 1.00 | 0.86 | 22.45 |
| 01-literal/sherlock-casei-ru | 746 | 7289.26 ± 1.0% | not timed | not timed | 5509.41 ± 0.5% | 30.29 ± 7.6% | not timed | not timed | 7272.81 ± 1.1% | | 1.00 | 1.32 | 240.63 |
| 01-literal/sherlock-zh | 30 | 42786.44 ± 14.5% | not timed | not timed | 36788.55 ± 0.9% | 1258.68 ± 0.1% | not timed | not timed | 42383.88 ± 1.3% | | 1.01 | 1.16 | 33.99 |
| 02-literal-alternate/sherlock-en | 714 | 9674.78 ± 1.3% | not timed | not timed | 8883.40 ± 0.3% | 14.52 ± 4.6% | not timed | not timed | 9631.01 ± 0.8% | | 1.00 | 1.09 | 666.32 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1800.31 ± 1.2% | not timed | not timed | 1817.45 ± 0.5% | 9.53 ± 0.5% | not timed | not timed | 1819.70 ± 0.6% | | 0.99 | 0.99 | 189.00 |
| 02-literal-alternate/sherlock-ru | 899 | 5930.00 ± 1.0% | not timed | not timed | 4245.43 ± 1.1% | 19.64 ± 0.5% | not timed | not timed | 5957.01 ± 0.6% | | 1.00 | 1.40 | 301.97 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1846.41 ± 0.6% | not timed | not timed | 1040.46 ± 0.6% | 8.53 ± 1.7% | not timed | not timed | 1867.81 ± 5.8% | | 0.99 | 1.77 | 216.41 |
| 02-literal-alternate/sherlock-zh | 207 | 13890.34 ± 1.6% | not timed | not timed | 10401.04 ± 0.4% | 27.07 ± 2.8% | not timed | not timed | 13878.82 ± 0.3% | | 1.00 | 1.34 | 513.18 |
| 03-date/ascii | 111817 | 101.61 ± 0.4% | not timed | not timed | 83.96 ± 0.4% | 0.18 ± 3.9% | not timed | not timed | 100.16 ± 0.5% | | 1.01 | 1.21 | 570.66 |
| 04-ruff-noqa/real | 84 | 561.91 ± 0.3% | not timed | not timed | 432.73 ± 0.6% | 15.91 ± 1.9% | not timed | not timed | 562.43 ± 18.2% | | 1.00 | 1.30 | 35.31 |
| 04-ruff-noqa/tweaked | 44 | 473.79 ± 1.1% | not timed | not timed | 422.11 ± 0.6% | 292.51 ± 1.0% | not timed | not timed | 471.64 ± 14.3% | | 1.00 | 1.12 | 1.62 |
| 05-lexer-veryl/single | 124800 | 3.01 ± 0.9% | not timed | not timed | 4.19 ± 0.8% | 0.21 ± 4.4% | not timed | not timed | 2.97 ± 1.5% | | 1.01 | 0.72 | 14.24 |
| 06-cloud-flare-redos/original | 107 | 228.44 ± 0.4% | not timed | not timed | 192.05 ± 1.5% | 20.67 ± 0.5% | not timed | not timed | 228.08 ± 0.5% | | 1.00 | 1.19 | 11.05 |
| 06-cloud-flare-redos/simplified-short | 102 | 218.35 ± 0.5% | not timed | not timed | 192.19 ± 0.3% | 21.96 ± 12.2% | not timed | not timed | 218.07 ± 2.2% | | 1.00 | 1.14 | 9.94 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.49 ± 1.7% | not timed | not timed | 211.80 ± 0.6% | 24.01 ± 0.6% | not timed | not timed | 246.69 ± 0.3% | | 1.00 | 1.16 | 10.27 |
| 07-unicode-character-data/parse-line | 558784 | 187.26 ± 0.7% | not timed | not timed | 159.76 ± 7.7% | 36.94 ± 5.1% | not timed | not timed | 186.48 ± 2.6% | | 1.00 | 1.17 | 5.07 |
| 08-words/all-english | 56691 | 96.98 ± 1.4% | not timed | not timed | 72.57 ± 0.4% | 9.94 ± 4.4% | not timed | not timed | 96.03 ± 1.7% | | 1.01 | 1.34 | 9.75 |
| 08-words/long-english | 839 | 865.06 ± 0.3% | not timed | not timed | 513.77 ± 0.2% | 25.33 ± 25.0% | not timed | not timed | 863.43 ± 0.3% | | 1.00 | 1.68 | 34.16 |
| 09-aws-keys/full | 0 | 426.67 ± 8.5% | not timed | not timed | 425.64 ± 0.3% | 53.89 ± 6.8% | not timed | not timed | 426.32 ± 0.3% | | 1.00 | 1.00 | 7.92 |
| 09-aws-keys/quick | 0 | 821.71 ± 0.2% | not timed | not timed | 801.98 ± 0.2% | 328.36 ± 1.2% | not timed | not timed | 809.67 ± 3.0% | | 1.01 | 1.02 | 2.50 |
| 10-bounded-repeat/letters-en | 1833 | 515.69 ± 0.8% | not timed | not timed | 431.92 ± 2.8% | 16.35 ± 1.1% | not timed | not timed | 524.58 ± 0.6% | | 0.98 | 1.19 | 31.53 |
| 10-bounded-repeat/letters-ru | 3475 | 321.79 ± 3.8% | not timed | not timed | 406.84 ± 4.1% | 19.23 ± 13.3% | not timed | not timed | 321.89 ± 1.1% | | 1.00 | 0.79 | 16.73 |
| 10-bounded-repeat/context | 53 | 65.25 ± 5.1% | not timed | not timed | 55.10 ± 2.0% | 16.94 ± 0.2% | not timed | not timed | 65.62 ± 6.9% | | 0.99 | 1.18 | 3.85 |
| 10-bounded-repeat/capitals | 11 | 900.54 ± 0.6% | not timed | not timed | 532.81 ± 0.2% | 30.90 ± 0.9% | not timed | not timed | 899.35 ± 0.4% | | 1.00 | 1.69 | 29.15 |
| 11-unstructured-to-json/extract | 600 | 37.09 ± 1.2% | not timed | not timed | 61.92 ± 9.1% | 40.60 ± 1.0% | not timed | not timed | 36.91 ± 0.3% | | 1.00 | 0.60 | 0.91 |
| 12-dictionary/single | 1 | 461.01 ± 0.8% | not timed | not timed | 441.69 ± 0.4% | 0.33 ± 0.6% | not timed | not timed | 463.16 ± 0.6% | | 1.00 | 1.04 | 1412.43 |
| 14-quadratic/1x | 100 | 7.61 ± 0.7% | not timed | not timed | 9.07 ± 0.2% | 0.80 ± 3.4% | not timed | not timed | 7.49 ± 2.0% | | 1.02 | 0.84 | 9.56 |
| 14-quadratic/2x | 200 | 4.45 ± 0.3% | not timed | not timed | 4.91 ± 0.1% | 0.42 ± 2.5% | not timed | not timed | 4.44 ± 2.7% | | 1.00 | 0.91 | 10.52 |
| 14-quadratic/10x | 1000 | 1.03 ± 1.2% | not timed | not timed | 1.05 ± 1.5% | 0.09 ± 0.8% | not timed | not timed | 1.03 ± 1.8% | | 1.00 | 0.98 | 11.11 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.31 ± 0.8% | not timed | not timed | 0.39 ± 0.2% | 0.47 ± 0.6% | not timed | not timed | 1.30 ± 0.7% | | 1.01 | 3.39 | 2.76 |
| 04-ruff-noqa/compile-real | 1 | 79.63 ± 0.3% | not timed | not timed | 13.03 ± 1.2% | 120.09 ± 7.2% | not timed | not timed | 79.45 ± 1.0% | | 1.00 | 6.11 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 12.76 ± 1.0% | not timed | not timed | 2.38 ± 1.1% | 5.70 ± 3.9% | not timed | not timed | 12.66 ± 11.3% | | 1.01 | 5.37 | 2.24 |
| 07-unicode-character-data/compile | 1 | 50.80 ± 10.0% | not timed | not timed | 24.35 ± 1.0% | 32.61 ± 6.2% | not timed | not timed | 51.01 ± 31.5% | | 1.00 | 2.09 | 1.56 |
| 09-aws-keys/compile-full | 1 | 35.03 ± 0.5% | not timed | not timed | 7.43 ± 1.1% | 20.03 ± 5.3% | not timed | not timed | 34.36 ± 15.7% | | 1.02 | 4.72 | 1.75 |
| 09-aws-keys/compile-quick | 1 | 156.25 ± 17.6% | not timed | not timed | 44.71 ± 0.7% | 116.10 ± 4.4% | not timed | not timed | 154.90 ± 17.7% | | 1.01 | 3.49 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 10.51 ± 0.7% | not timed | not timed | 11.85 ± 1.1% | 15.02 ± 3.7% | not timed | not timed | 10.50 ± 4.4% | | 1.00 | 0.89 | 0.70 |
| 10-bounded-repeat/compile-capitals | 1 | 72.98 ± 20.4% | not timed | not timed | 8.87 ± 0.6% | 22.22 ± 0.8% | not timed | not timed | 71.85 ± 0.4% | | 1.02 | 8.23 | 3.28 |
| 11-unstructured-to-json/compile | 1 | 77.95 ± 1.8% | not timed | not timed | 37.25 ± 1.2% | 58.34 ± 5.9% | not timed | not timed | 77.29 ± 2.3% | | 1.01 | 2.09 | 1.34 |
| 12-dictionary/compile-single | 1 | 0.29 ± 0.6% | not timed | not timed | 0.07 ± 0.8% | 0.08 ± 13.7% | not timed | not timed | 0.28 ± 4.3% | | 1.02 | 4.36 | 3.65 |

