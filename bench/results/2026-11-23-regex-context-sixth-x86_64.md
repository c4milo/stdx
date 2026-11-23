# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117651666 |
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
| literal: a word | 217 | 31684.13 ± 0.6% | 791.42 ± 0.3% | 23.72 ± 0.4% | 29994.82 ± 0.4% | 9129.00 ± 9.2% | 9.88 ± 0.6% | 80.87 ± 2.3% | 31763.54 ± 0.4% | 40.03 | 1.00 | 1.06 | 3.47 |
| literal: a word that is not there | 0 | 44226.98 ± 0.5% | 804.90 ± 0.7% | 23.75 ± 0.6% | 35287.05 ± 0.5% | 33651.02 ± 1.3% | 9.78 ± 0.1% | 75.50 ± 5.4% | 44222.47 ± 0.5% | 54.95 | 1.00 | 1.25 | 1.31 |
| literal: one of four words | 661 | 10804.26 ± 8.2% | 780.00 ± 0.4% | 13.16 ± 0.2% | 8817.25 ± 0.3% | 18.19 ± 0.2% | 3.45 ± 0.4% | 6.43 ± 0.6% | 10758.60 ± 8.4% | 13.85 | 1.00 | 1.23 | 594.13 |
| literal: a word in any case | 217 | 28742.50 ± 0.3% | 796.21 ± 0.2% | 17.87 ± 1.3% | 8967.40 ± 0.9% | 36.63 ± 1.6% | refused | differs | 28706.72 ± 0.3% | 36.10 | 1.00 | 3.21 | 784.73 |
| literal: an href attribute | 33 | 27385.47 ± 0.4% | 801.32 ± 0.3% | 22.82 ± 0.5% | 27140.09 ± 0.3% | 2235.34 ± 7.4% | 7.42 ± 0.1% | 70.73 ± 5.6% | 27343.36 ± 0.6% | 34.18 | 1.00 | 1.01 | 12.25 |
| literal: a word, second text | 123 | 34672.81 ± 0.4% | 798.50 ± 0.2% | 23.36 ± 3.2% | 30171.03 ± 7.9% | 8686.71 ± 4.9% | 11.15 ± 0.8% | 67.92 ± 0.2% | 34577.54 ± 7.6% | 43.42 | 1.00 | 1.15 | 3.99 |
| class: two capitalized words | 1331 | 695.44 ± 0.3% | 739.07 ± 0.6% | 22.18 ± 1.2% | 446.84 ± 0.4% | 34.53 ± 6.4% | 8.48 ± 0.4% | 61.32 ± 0.1% | 695.33 ± 1.6% | 0.94 | 1.00 | 1.56 | 20.14 |
| class: a word that ends in ing | 3399 | 674.05 ± 1.2% | 673.21 ± 0.4% | 15.49 ± 0.2% | 417.84 ± 0.3% | 23.30 ± 31.4% | 4.80 ± 0.7% | 16.06 ± 6.9% | 674.42 ± 3.2% | 1.00 | 1.00 | 1.61 | 28.93 |
| class: a word in capitals | 2332 | 886.13 ± 2.8% | 720.71 ± 0.5% | 23.26 ± 4.2% | 439.18 ± 0.5% | 37.09 ± 3.6% | 9.57 ± 0.6% | 78.09 ± 0.3% | 885.63 ± 0.2% | 1.23 | 1.00 | 2.02 | 23.89 |
| class: a number | 8288 | 1343.13 ± 7.0% | 612.57 ± 0.1% | 23.32 ± 0.5% | 1365.46 ± 1.5% | 37.63 ± 15.2% | 0.30 ± 0.1% | 54.89 ± 0.4% | 1344.42 ± 0.6% | 2.19 | 1.00 | 0.98 | 35.69 |
| class: two capitalized words, second text | 5359 | 533.99 ± 0.3% | 532.52 ± 0.2% | 19.96 ± 0.7% | 371.03 ± 0.1% | 30.08 ± 4.0% | 9.79 ± 0.0% | 57.00 ± 0.3% | 531.61 ± 0.5% | 1.00 | 1.00 | 1.44 | 17.75 |
| other: a word between two words | 6104 | 604.59 ± 2.1% | 567.02 ± 0.1% | 19.95 ± 0.4% | 629.93 ± 1.2% | 104.82 ± 10.1% | 6.57 ± 0.2% | 62.91 ± 0.4% | 600.57 ± 0.5% | 1.07 | 1.01 | 0.96 | 5.77 |
| other: a number before a unit, second text | 1481 | 7302.15 ± 0.5% | 757.98 ± 0.4% | 22.03 ± 0.6% | 6417.30 ± 0.6% | 35.16 ± 1.1% | 10.22 ± 0.6% | 60.27 ± 0.3% | 7279.51 ± 0.3% | 9.63 | 1.00 | 1.14 | 207.68 |
| other: a heading's start tag | 110 | 19093.15 ± 1.2% | 794.59 ± 0.2% | 23.36 ± 0.7% | 1935.01 ± 2.0% | 1502.44 ± 8.9% | 9.06 ± 0.9% | 83.08 ± 0.3% | 19071.70 ± 9.0% | 24.03 | 1.00 | 9.87 | 12.71 |
| other: a whole word | 217 | 22541.19 ± 1.5% | 797.37 ± 0.3% | 23.90 ± 3.9% | 21857.93 ± 0.3% | 42.03 ± 1.1% | 8.54 ± 0.3% | 48.47 ± 0.9% | 22631.95 ± 0.2% | 28.27 | 1.00 | 1.03 | 536.27 |
| other: a line's first word, second text | 3716 | 1817.42 ± 1.7% | 658.60 ± 0.2% | 25.15 ± 1.1% | 1792.01 ± 2.4% | 55.36 ± 5.9% | refused | refused | 1591.43 ± 0.8% | 2.76 | 1.14 | 1.01 | 32.83 |
| other: fourteen octets before an x | 87 | 27140.27 ± 1.9% | 192.93 ± 9.9% | 5.54 ± 4.8% | 2702.08 ± 0.4% | 8.97 ± 0.6% | differs | 15.41 ± 1.2% | 27305.60 ± 0.6% | 140.67 | 0.99 | 10.04 | 3026.28 |
| other: a Greek word | 21815 | 375.26 ± 0.1% | 255.07 ± 0.3% | 26.16 ± 0.4% | 236.78 ± 0.1% | 42.51 ± 17.5% | differs | refused | 372.65 ± 0.5% | 1.47 | 1.01 | 1.58 | 8.83 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 22.20 ± 4.0% | 22.17 ± 1.1% | 0.77 ± 10.4% | 15.35 ± 1.3% | 1.70 ± 0.8% | differs | 3.25 ± 2.1% | 22.22 ± 2.9% | 1.00 | 1.00 | 1.45 | 13.07 |
| a UUID | 32895 | 18.70 ± 1.4% | 18.79 ± 0.9% | 0.57 ± 0.5% | 11.72 ± 0.1% | 2.34 ± 2.0% | 0.41 ± 0.2% | 2.87 ± 5.5% | 18.77 ± 0.9% | 1.00 | 1.00 | 1.60 | 7.99 |
| an IPv4 address | 33176 | 31.03 ± 10.5% | 31.02 ± 0.3% | 1.82 ± 0.5% | 21.99 ± 0.3% | 5.39 ± 0.8% | differs | 3.25 ± 2.2% | 31.18 ± 9.6% | 1.00 | 1.00 | 1.41 | 5.76 |
| a date and time | 32954 | 28.25 ± 2.6% | 27.37 ± 6.6% | 1.35 ± 0.4% | 16.62 ± 0.3% | 6.40 ± 4.4% | 0.70 ± 0.5% | 5.90 ± 9.9% | 27.92 ± 1.9% | 1.03 | 1.01 | 1.70 | 4.42 |
| a field path | 32606 | 24.83 ± 0.2% | 24.78 ± 0.8% | 0.88 ± 1.1% | 17.69 ± 0.9% | 2.72 ± 2.3% | differs | 2.28 ± 1.3% | 24.78 ± 0.2% | 1.00 | 1.00 | 1.40 | 9.12 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.50 ± 0.3% | 8.51 ± 0.4% | 8.53 ± 0.3% | 10.38 ± 1.0% | 4.53 ± 6.4% | 0.58 ± 0.7% | none | 8.51 ± 0.4% | 1.00 | 1.00 | 0.82 | 1.87 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 181.24 ± 0.8% | 181.86 ± 0.8% | 210.16 ± 0.5% | 78.97 ± 2.8% | 188.57 ± 4.6% | 543.99 ± 26.7% | 3811.59 ± 0.4% | 181.13 ± 1.3% | 1.00 | 1.00 | 2.30 | 0.96 |
| a UUID | 62 | 116.72 ± 0.2% | 117.10 ± 0.3% | 129.36 ± 0.7% | 45.46 ± 0.9% | 90.73 ± 2.3% | 194.09 ± 2.6% | 4200.95 ± 0.6% | 116.72 ± 0.6% | 1.00 | 1.00 | 2.57 | 1.29 |
| an IPv4 address | 29 | 394.81 ± 0.4% | 400.32 ± 0.8% | 566.15 ± 2.1% | 67.42 ± 4.6% | 115.36 ± 1.3% | 316.42 ± 5.0% | 6994.04 ± 1.1% | 394.69 ± 0.5% | 0.99 | 1.00 | 5.86 | 3.42 |
| a date and time | 56 | 290.30 ± 0.3% | 292.64 ± 0.5% | 370.11 ± 0.3% | 66.53 ± 1.3% | 122.39 ± 4.7% | 368.89 ± 4.0% | 4303.70 ± 1.6% | 290.47 ± 0.2% | 0.99 | 1.00 | 4.36 | 2.37 |
| a field path | 39 | 171.34 ± 0.3% | 172.20 ± 1.2% | 196.47 ± 0.3% | 73.44 ± 3.0% | 176.30 ± 1.4% | 587.71 ± 7.6% | 4629.08 ± 1.1% | 171.32 ± 1.7% | 1.00 | 1.00 | 2.33 | 0.97 |
| literal: a word | 7 | 598.22 ± 0.2% | 639.01 ± 0.2% | 1153.57 ± 0.3% | 497.34 ± 0.6% | 607.74 ± 3.2% | 1268.25 ± 1.9% | 26834.27 ± 1.7% | 598.21 ± 0.3% | 0.94 | 1.00 | 1.20 | 0.98 |
| literal: a word that is not there | 8 | 574.62 ± 12.0% | 616.45 ± 0.3% | 1085.24 ± 0.5% | 454.63 ± 0.5% | 587.25 ± 1.9% | 1189.85 ± 0.5% | 26238.43 ± 0.3% | 573.20 ± 3.0% | 0.93 | 1.00 | 1.26 | 0.98 |
| literal: one of four words | 26 | 219.62 ± 7.5% | 366.51 ± 2.2% | 490.58 ± 0.7% | 41.64 ± 0.3% | 229.85 ± 2.0% | 447.85 ± 1.7% | 14232.03 ± 15.2% | 219.37 ± 0.3% | 0.60 | 1.00 | 5.27 | 0.96 |
| literal: a word in any case | 11 | 461.40 ± 7.3% | 492.56 ± 4.1% | 756.61 ± 0.2% | 14.70 ± 0.9% | 635.86 ± 3.0% | refused | 19178.26 ± 1.4% | 462.20 ± 9.4% | 0.94 | 1.00 | 31.39 | 0.73 |
| literal: an href attribute | 12 | 317.03 ± 0.3% | 327.48 ± 8.5% | 431.52 ± 10.7% | 39.11 ± 0.7% | 446.35 ± 1.2% | 954.29 ± 3.3% | 19340.23 ± 0.4% | 317.02 ± 0.4% | 0.97 | 1.00 | 8.11 | 0.71 |
| literal: a word, second text | 10 | 531.39 ± 0.9% | 581.26 ± 0.3% | 974.72 ± 0.7% | 415.19 ± 1.7% | 513.28 ± 1.5% | 1008.87 ± 0.7% | 24809.31 ± 1.2% | 530.05 ± 0.6% | 0.91 | 1.00 | 1.28 | 1.04 |
| class: two capitalized words | 23 | 418.59 ± 1.1% | 454.03 ± 0.4% | 661.39 ± 0.4% | 94.54 ± 1.4% | 454.66 ± 3.0% | 958.91 ± 4.3% | 6163.91 ± 0.1% | 418.42 ± 0.2% | 0.92 | 1.00 | 4.43 | 0.92 |
| class: a word that ends in ing | 9 | 515.59 ± 0.3% | 586.19 ± 7.6% | 1026.81 ± 2.3% | 114.86 ± 1.0% | 659.94 ± 2.8% | 1380.04 ± 0.7% | 14964.23 ± 3.0% | 515.38 ± 0.3% | 0.88 | 1.00 | 4.49 | 0.78 |
| class: a word in capitals | 16 | 461.83 ± 10.7% | 505.67 ± 0.2% | 819.98 ± 0.2% | 120.18 ± 1.4% | 685.03 ± 9.9% | 1301.29 ± 7.4% | 8190.62 ± 19.3% | 461.87 ± 6.4% | 0.91 | 1.00 | 3.84 | 0.67 |
| class: a number | 6 | 564.49 ± 0.2% | 634.80 ± 0.3% | 1186.28 ± 0.2% | 36.39 ± 0.9% | 1245.38 ± 2.3% | 2265.30 ± 1.6% | 20015.62 ± 0.5% | 564.65 ± 1.2% | 0.89 | 1.00 | 15.51 | 0.45 |
| class: two capitalized words, second text | 23 | 418.57 ± 0.5% | 453.71 ± 10.8% | 661.49 ± 0.5% | 95.05 ± 1.4% | 463.78 ± 3.0% | 940.79 ± 2.6% | 6169.00 ± 0.7% | 418.24 ± 0.2% | 0.92 | 1.00 | 4.40 | 0.90 |
| other: a word between two words | 13 | 509.87 ± 0.4% | 528.25 ± 0.8% | 836.81 ± 0.8% | 123.23 ± 1.4% | 455.37 ± 4.5% | 1050.90 ± 0.5% | 13901.34 ± 0.5% | 509.57 ± 0.3% | 0.97 | 1.00 | 4.14 | 1.12 |
| other: a number before a unit, second text | 15 | 343.25 ± 1.0% | 379.17 ± 0.2% | 516.55 ± 0.3% | 34.20 ± 7.5% | 560.04 ± 0.8% | 1129.05 ± 3.3% | 13754.98 ± 0.2% | 342.78 ± 14.7% | 0.91 | 1.00 | 10.04 | 0.61 |
| other: a heading's start tag | 13 | 326.96 ± 0.6% | 332.22 ± 0.5% | 439.62 ± 0.9% | 37.50 ± 0.7% | 544.14 ± 1.2% | 1099.91 ± 16.2% | 15890.10 ± 0.4% | 327.04 ± 2.8% | 0.98 | 1.00 | 8.72 | 0.60 |
| other: a whole word | 11 | 521.92 ± 1.2% | 552.49 ± 0.7% | 903.78 ± 0.7% | 109.76 ± 0.6% | 526.82 ± 3.9% | 1082.11 ± 1.0% | 24567.87 ± 0.9% | 517.44 ± 1.2% | 0.94 | 1.01 | 4.76 | 0.99 |
| other: a line's first word, second text | 17 | 495.20 ± 1.0% | 516.79 ± 0.6% | 824.87 ± 0.4% | 115.37 ± 0.6% | 616.10 ± 2.3% | refused | refused | 494.07 ± 0.9% | 0.96 | 1.00 | 4.29 | 0.80 |
| other: fourteen octets before an x | 16 | 92.36 ± 1.5% | 137.07 ± 0.5% | 161.89 ± 0.8% | 14.07 ± 10.7% | 408.70 ± 1.3% | 439.61 ± 0.7% | 12150.11 ± 0.6% | 92.48 ± 0.4% | 0.67 | 1.00 | 6.57 | 0.23 |
| other: a Greek word | 8 | 355.88 ± 0.6% | 490.47 ± 1.1% | 771.67 ± 5.8% | 48.57 ± 0.5% | 1205.93 ± 16.5% | 2181.60 ± 0.9% | refused | 356.26 ± 0.1% | 0.73 | 1.00 | 7.33 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 18265.08 ± 0.4% | not timed | not timed | 26073.17 ± 1.2% | 1961.92 ± 13.9% | not timed | not timed | 18240.35 ± 0.3% | | 1.00 | 0.70 | 9.31 |
| 01-literal/sherlock-casei-en | 522 | 4732.64 ± 11.3% | not timed | not timed | 7078.59 ± 0.5% | 26.39 ± 0.5% | not timed | not timed | 4662.88 ± 0.8% | | 1.01 | 0.67 | 179.33 |
| 01-literal/sherlock-ru | 724 | 20279.96 ± 1.7% | not timed | not timed | 26154.32 ± 1.9% | 982.03 ± 8.7% | not timed | not timed | 20236.10 ± 0.5% | | 1.00 | 0.78 | 20.65 |
| 01-literal/sherlock-casei-ru | 746 | 6514.82 ± 0.8% | not timed | not timed | 6073.32 ± 0.6% | 29.13 ± 0.9% | not timed | not timed | 6479.93 ± 0.5% | | 1.01 | 1.07 | 223.67 |
| 01-literal/sherlock-zh | 30 | 40615.56 ± 0.4% | not timed | not timed | 33316.17 ± 0.5% | 1272.52 ± 4.7% | not timed | not timed | 40562.71 ± 1.2% | | 1.00 | 1.22 | 31.92 |
| 02-literal-alternate/sherlock-en | 714 | 8925.03 ± 0.7% | not timed | not timed | 8603.66 ± 0.2% | 14.70 ± 0.9% | not timed | not timed | 8907.60 ± 0.5% | | 1.00 | 1.04 | 607.28 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1588.27 ± 0.9% | not timed | not timed | 1771.84 ± 0.6% | 9.57 ± 0.7% | not timed | not timed | 1556.91 ± 0.6% | | 1.02 | 0.90 | 165.94 |
| 02-literal-alternate/sherlock-ru | 899 | 5539.48 ± 1.2% | not timed | not timed | 7613.83 ± 2.9% | 19.02 ± 19.9% | not timed | not timed | 5510.09 ± 0.5% | | 1.01 | 0.73 | 291.22 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1544.44 ± 0.3% | not timed | not timed | 921.64 ± 0.5% | 8.21 ± 0.6% | not timed | not timed | 1542.92 ± 5.2% | | 1.00 | 1.68 | 188.14 |
| 02-literal-alternate/sherlock-zh | 207 | 13599.58 ± 0.9% | not timed | not timed | 9995.53 ± 0.3% | 27.63 ± 5.5% | not timed | not timed | 13576.19 ± 5.0% | | 1.00 | 1.36 | 492.13 |
| 03-date/ascii | 111817 | 81.15 ± 1.5% | not timed | not timed | 77.58 ± 1.2% | 0.18 ± 3.1% | not timed | not timed | 80.05 ± 0.6% | | 1.01 | 1.05 | 450.88 |
| 04-ruff-noqa/real | 84 | 534.00 ± 0.4% | not timed | not timed | 391.76 ± 0.7% | 16.05 ± 2.8% | not timed | not timed | 534.23 ± 0.6% | | 1.00 | 1.36 | 33.27 |
| 04-ruff-noqa/tweaked | 44 | 473.50 ± 0.9% | not timed | not timed | 399.61 ± 0.1% | 288.86 ± 5.0% | not timed | not timed | 472.79 ± 0.1% | | 1.00 | 1.18 | 1.64 |
| 05-lexer-veryl/single | 124800 | 2.88 ± 0.4% | not timed | not timed | 4.00 ± 7.5% | 0.20 ± 6.0% | not timed | not timed | 2.90 ± 3.5% | | 0.99 | 0.72 | 14.42 |
| 06-cloud-flare-redos/original | 107 | 163.28 ± 0.3% | not timed | not timed | 176.33 ± 0.6% | 19.21 ± 0.9% | not timed | not timed | 165.54 ± 1.9% | | 0.99 | 0.93 | 8.50 |
| 06-cloud-flare-redos/simplified-short | 102 | 123.69 ± 0.8% | not timed | not timed | 183.26 ± 0.3% | 20.22 ± 6.5% | not timed | not timed | 122.96 ± 0.6% | | 1.01 | 0.67 | 6.12 |
| 06-cloud-flare-redos/simplified-long | 10000 | 131.61 ± 4.6% | not timed | not timed | 199.55 ± 1.3% | 22.99 ± 2.0% | not timed | not timed | 131.59 ± 4.4% | | 1.00 | 0.66 | 5.72 |
| 07-unicode-character-data/parse-line | 558784 | 190.30 ± 0.8% | not timed | not timed | 156.74 ± 2.9% | 35.59 ± 4.4% | not timed | not timed | 185.72 ± 2.1% | | 1.02 | 1.21 | 5.35 |
| 08-words/all-english | 56691 | 63.38 ± 0.6% | not timed | not timed | 65.48 ± 0.3% | 9.92 ± 5.7% | not timed | not timed | 62.90 ± 1.1% | | 1.01 | 0.97 | 6.39 |
| 08-words/long-english | 839 | 755.99 ± 0.4% | not timed | not timed | 452.89 ± 0.3% | 27.30 ± 0.8% | not timed | not timed | 750.71 ± 0.1% | | 1.01 | 1.67 | 27.69 |
| 09-aws-keys/full | 0 | 404.20 ± 0.9% | not timed | not timed | 416.63 ± 0.2% | 51.49 ± 2.3% | not timed | not timed | 403.82 ± 0.4% | | 1.00 | 0.97 | 7.85 |
| 09-aws-keys/quick | 0 | 735.32 ± 3.2% | not timed | not timed | 743.60 ± 0.7% | 312.83 ± 7.0% | not timed | not timed | 734.90 ± 0.8% | | 1.00 | 0.99 | 2.35 |
| 10-bounded-repeat/letters-en | 1833 | 451.61 ± 1.6% | not timed | not timed | 430.81 ± 0.6% | 17.50 ± 2.2% | not timed | not timed | 447.80 ± 1.1% | | 1.01 | 1.05 | 25.81 |
| 10-bounded-repeat/letters-ru | 3475 | 269.35 ± 0.5% | not timed | not timed | 372.92 ± 0.4% | 20.08 ± 14.9% | not timed | not timed | 267.43 ± 1.4% | | 1.01 | 0.72 | 13.41 |
| 10-bounded-repeat/context | 53 | 65.30 ± 0.9% | not timed | not timed | 54.76 ± 0.4% | 17.47 ± 1.2% | not timed | not timed | 64.35 ± 1.8% | | 1.01 | 1.19 | 3.74 |
| 10-bounded-repeat/capitals | 11 | 799.51 ± 0.5% | not timed | not timed | 468.72 ± 0.1% | 31.31 ± 0.6% | not timed | not timed | 796.47 ± 1.1% | | 1.00 | 1.71 | 25.54 |
| 11-unstructured-to-json/extract | 600 | 35.78 ± 0.9% | not timed | not timed | 62.05 ± 3.4% | 24.49 ± 42.4% | not timed | not timed | 35.36 ± 0.5% | | 1.01 | 0.58 | 1.46 |
| 12-dictionary/single | 1 | 392.63 ± 0.4% | not timed | not timed | 374.63 ± 0.1% | 0.30 ± 3.4% | not timed | not timed | 395.59 ± 0.1% | | 0.99 | 1.05 | 1292.97 |
| 14-quadratic/1x | 100 | 9.08 ± 0.5% | not timed | not timed | 9.27 ± 0.3% | 0.79 ± 2.8% | not timed | not timed | 8.82 ± 1.0% | | 1.03 | 0.98 | 11.47 |
| 14-quadratic/2x | 200 | 5.74 ± 0.1% | not timed | not timed | 4.70 ± 4.6% | 0.42 ± 0.7% | not timed | not timed | 5.64 ± 8.6% | | 1.02 | 1.22 | 13.72 |
| 14-quadratic/10x | 1000 | 1.39 ± 0.3% | not timed | not timed | 0.94 ± 0.3% | 0.09 ± 1.7% | not timed | not timed | 1.39 ± 0.1% | | 1.00 | 1.48 | 15.40 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.28 ± 0.3% | not timed | not timed | 0.37 ± 1.2% | 0.49 ± 5.7% | not timed | not timed | 1.28 ± 0.4% | | 1.00 | 3.47 | 2.61 |
| 04-ruff-noqa/compile-real | 1 | 76.34 ± 1.3% | not timed | not timed | 13.43 ± 1.4% | 128.83 ± 2.4% | not timed | not timed | 75.14 ± 1.9% | | 1.02 | 5.68 | 0.59 |
| 05-lexer-veryl/compile-single | 1 | 12.57 ± 0.5% | not timed | not timed | 2.29 ± 1.1% | 6.08 ± 3.0% | not timed | not timed | 12.53 ± 0.9% | | 1.00 | 5.48 | 2.07 |
| 07-unicode-character-data/compile | 1 | 48.52 ± 0.5% | not timed | not timed | 23.70 ± 0.8% | 34.26 ± 2.6% | not timed | not timed | 48.45 ± 0.8% | | 1.00 | 2.05 | 1.42 |
| 09-aws-keys/compile-full | 1 | 34.05 ± 0.2% | not timed | not timed | 7.77 ± 0.7% | 21.20 ± 22.3% | not timed | not timed | 33.63 ± 1.7% | | 1.01 | 4.38 | 1.61 |
| 09-aws-keys/compile-quick | 1 | 153.70 ± 5.5% | not timed | not timed | 45.59 ± 6.0% | 118.88 ± 4.2% | not timed | not timed | 152.78 ± 4.9% | | 1.01 | 3.37 | 1.29 |
| 10-bounded-repeat/compile-context | 1 | 12.05 ± 0.3% | not timed | not timed | 11.28 ± 0.7% | 15.64 ± 1.5% | not timed | not timed | 12.03 ± 1.2% | | 1.00 | 1.07 | 0.77 |
| 10-bounded-repeat/compile-capitals | 1 | 73.44 ± 2.0% | not timed | not timed | 8.19 ± 0.8% | 22.68 ± 3.4% | not timed | not timed | 71.60 ± 0.8% | | 1.03 | 8.97 | 3.24 |
| 11-unstructured-to-json/compile | 1 | 75.40 ± 1.7% | not timed | not timed | 37.05 ± 0.7% | 62.78 ± 1.5% | not timed | not timed | 74.22 ± 1.3% | | 1.02 | 2.03 | 1.20 |
| 12-dictionary/compile-single | 1 | 0.27 ± 0.5% | not timed | not timed | 0.07 ± 0.3% | 0.08 ± 18.9% | not timed | not timed | 0.27 ± 1.5% | | 1.01 | 4.07 | 3.20 |

