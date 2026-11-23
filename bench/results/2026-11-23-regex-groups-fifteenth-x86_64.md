# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215458463 |
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
| literal: a word | 217 | 33131.22 ± 4.9% | 3363.08 ± 0.4% | 19.93 ± 5.2% | 31142.74 ± 3.4% | 8804.69 ± 9.2% | 10.75 ± 0.2% | 76.26 ± 0.9% | 32395.06 ± 1.4% | 9.85 | 1.02 | 1.06 | 3.76 |
| literal: a word that is not there | 0 | 48437.94 ± 6.1% | 3247.63 ± 2.6% | 19.97 ± 21.0% | 39538.81 ± 0.6% | 30235.85 ± 0.9% | 10.69 ± 0.4% | 72.35 ± 0.9% | 47589.79 ± 1.4% | 14.91 | 1.02 | 1.23 | 1.60 |
| literal: one of four words | 661 | 11128.43 ± 3.8% | 1397.72 ± 2.4% | 10.96 ± 2.7% | 9117.83 ± 0.5% | 18.67 ± 8.3% | 4.00 ± 0.1% | 6.68 ± 0.8% | 11138.38 ± 0.7% | 7.96 | 1.00 | 1.22 | 596.19 |
| literal: a word in any case | 217 | 26136.33 ± 1.6% | 1494.23 ± 0.5% | 14.49 ± 5.3% | 9219.62 ± 1.8% | 37.16 ± 2.7% | refused | differs | 25534.74 ± 7.3% | 17.49 | 1.02 | 2.83 | 703.31 |
| literal: an href attribute | 33 | 27029.96 ± 3.1% | 538.09 ± 16.5% | 18.48 ± 7.6% | 27465.74 ± 2.0% | 2050.70 ± 0.3% | 8.19 ± 0.8% | 61.33 ± 0.9% | 26397.75 ± 0.8% | 50.23 | 1.02 | 0.98 | 13.18 |
| literal: a word, second text | 123 | 33723.49 ± 3.5% | 2388.77 ± 1.1% | 19.94 ± 4.6% | 32038.29 ± 0.7% | 7211.01 ± 5.8% | 11.77 ± 0.6% | 64.76 ± 5.3% | 33142.47 ± 2.2% | 14.12 | 1.02 | 1.05 | 4.68 |
| class: two capitalized words | 1331 | 768.31 ± 0.2% | 525.38 ± 0.2% | 18.55 ± 1.4% | 505.88 ± 0.3% | 34.23 ± 6.0% | 9.27 ± 0.2% | 55.69 ± 7.3% | 768.09 ± 2.0% | 1.46 | 1.00 | 1.52 | 22.44 |
| class: a word that ends in ing | 3399 | 499.74 ± 0.8% | 497.61 ± 0.9% | 12.94 ± 0.4% | 472.89 ± 0.9% | 25.67 ± 31.8% | 5.22 ± 0.7% | 17.14 ± 1.1% | 499.02 ± 0.1% | 1.00 | 1.00 | 1.06 | 19.47 |
| class: a word in capitals | 2332 | 955.43 ± 0.1% | 531.03 ± 0.3% | 19.60 ± 4.6% | 495.63 ± 2.9% | 35.96 ± 6.6% | 10.29 ± 0.3% | 76.36 ± 6.0% | 956.43 ± 0.3% | 1.80 | 1.00 | 1.93 | 26.57 |
| class: a number | 8288 | 1467.21 ± 0.7% | 702.86 ± 0.2% | 19.86 ± 4.0% | 1460.64 ± 0.6% | 35.25 ± 12.8% | 0.33 ± 1.1% | 55.75 ± 2.6% | 1469.02 ± 0.8% | 2.09 | 1.00 | 1.00 | 41.63 |
| class: two capitalized words, second text | 5359 | 443.50 ± 0.8% | 449.83 ± 0.2% | 15.48 ± 0.3% | 413.82 ± 1.4% | 30.24 ± 5.0% | 10.46 ± 0.4% | 51.48 ± 9.3% | 443.33 ± 1.0% | 0.99 | 1.00 | 1.07 | 14.67 |
| other: a word between two words | 6104 | 683.93 ± 7.4% | 512.09 ± 1.6% | 16.57 ± 6.3% | 617.23 ± 1.1% | 97.62 ± 13.2% | 7.23 ± 0.2% | 56.72 ± 1.0% | 673.01 ± 0.3% | 1.34 | 1.02 | 1.11 | 7.01 |
| other: a number before a unit, second text | 1481 | 7064.21 ± 5.2% | 862.51 ± 0.6% | 18.87 ± 0.5% | 6446.56 ± 2.2% | 35.10 ± 1.5% | 10.87 ± 0.3% | 55.11 ± 0.5% | 7054.02 ± 3.0% | 8.19 | 1.00 | 1.10 | 201.24 |
| other: a heading's start tag | 110 | 18760.37 ± 4.2% | 654.22 ± 0.1% | 19.62 ± 2.9% | 2005.72 ± 0.7% | 1476.20 ± 5.3% | 10.01 ± 0.6% | 72.62 ± 0.7% | 18438.34 ± 3.8% | 28.68 | 1.02 | 9.35 | 12.71 |
| other: a whole word | 217 | 23275.50 ± 4.8% | 530.85 ± 0.9% | 20.05 ± 0.4% | 22530.13 ± 2.8% | 39.91 ± 14.7% | 9.45 ± 1.0% | 46.98 ± 0.7% | 22471.30 ± 5.6% | 43.85 | 1.04 | 1.03 | 583.27 |
| other: a line's first word, second text | 3716 | 1923.89 ± 6.0% | 513.95 ± 0.2% | 22.35 ± 4.5% | 1705.94 ± 1.2% | 53.04 ± 3.0% | refused | refused | 1916.43 ± 6.2% | 3.74 | 1.00 | 1.13 | 36.27 |
| other: fourteen octets before an x | 87 | 25962.22 ± 1.3% | 205.03 ± 0.7% | 5.16 ± 0.5% | 2692.07 ± 1.3% | 9.00 ± 0.7% | differs | 15.12 ± 2.3% | 25525.12 ± 1.6% | 126.62 | 1.02 | 9.64 | 2884.49 |
| other: a Greek word | 21815 | 388.14 ± 0.4% | 328.30 ± 0.3% | 23.95 ± 2.4% | 265.38 ± 0.6% | 43.90 ± 13.8% | differs | refused | 384.18 ± 1.0% | 1.18 | 1.01 | 1.46 | 8.84 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.60 ± 0.3% | 18.46 ± 0.3% | 0.79 ± 0.3% | 16.85 ± 0.4% | 2.34 ± 0.4% | differs | 3.61 ± 1.0% | 18.63 ± 0.4% | 1.01 | 1.00 | 1.10 | 7.95 |
| a UUID | 32895 | 20.42 ± 10.9% | 20.18 ± 0.3% | 0.55 ± 0.3% | 12.91 ± 0.4% | 2.52 ± 5.1% | 0.44 ± 0.7% | 3.08 ± 1.2% | 20.44 ± 1.6% | 1.01 | 1.00 | 1.58 | 8.09 |
| an IPv4 address | 33176 | 34.08 ± 0.3% | 34.03 ± 0.3% | 1.75 ± 0.3% | 24.11 ± 0.5% | 5.75 ± 0.7% | differs | 3.41 ± 1.1% | 33.72 ± 7.2% | 1.00 | 1.01 | 1.41 | 5.93 |
| a date and time | 32954 | 30.11 ± 2.7% | 30.05 ± 0.1% | 1.25 ± 0.4% | 18.08 ± 0.3% | 6.69 ± 0.9% | 0.76 ± 0.5% | 6.19 ± 2.5% | 30.26 ± 0.3% | 1.00 | 0.99 | 1.66 | 4.50 |
| a field path | 32606 | 21.79 ± 0.2% | 21.80 ± 0.1% | 0.89 ± 0.6% | 19.14 ± 0.5% | 2.93 ± 1.8% | differs | 2.45 ± 1.7% | 21.71 ± 0.2% | 1.00 | 1.00 | 1.14 | 7.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.67 ± 3.2% | 8.75 ± 3.6% | 8.60 ± 3.4% | 10.71 ± 1.6% | 4.75 ± 1.1% | 0.62 ± 1.1% | none | 8.68 ± 2.0% | 0.99 | 1.00 | 0.81 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 205.83 ± 0.7% | 206.51 ± 0.7% | 241.98 ± 1.0% | 78.15 ± 5.0% | 179.28 ± 2.8% | 530.10 ± 12.7% | 3973.57 ± 0.8% | 206.24 ± 0.6% | 1.00 | 1.00 | 2.63 | 1.15 |
| a UUID | 62 | 131.56 ± 6.4% | 133.80 ± 12.0% | 149.09 ± 3.0% | 46.49 ± 6.6% | 81.86 ± 23.7% | 200.29 ± 4.3% | 4011.64 ± 12.7% | 133.51 ± 3.6% | 0.98 | 0.99 | 2.83 | 1.61 |
| an IPv4 address | 29 | 386.82 ± 1.2% | 387.06 ± 0.3% | 533.74 ± 1.6% | 69.73 ± 0.5% | 110.88 ± 4.1% | 329.04 ± 1.6% | 7153.81 ± 0.5% | 388.27 ± 0.5% | 1.00 | 1.00 | 5.55 | 3.49 |
| a date and time | 56 | 281.96 ± 0.6% | 281.95 ± 0.6% | 349.49 ± 0.2% | 69.10 ± 1.3% | 120.27 ± 2.8% | 379.39 ± 2.4% | 4235.10 ± 2.5% | 282.68 ± 0.4% | 1.00 | 1.00 | 4.08 | 2.34 |
| a field path | 39 | 206.84 ± 1.8% | 206.66 ± 5.2% | 242.72 ± 1.1% | 74.10 ± 1.3% | 172.16 ± 1.5% | 582.52 ± 2.3% | 4753.01 ± 2.0% | 206.61 ± 0.8% | 1.00 | 1.00 | 2.79 | 1.20 |
| literal: a word | 7 | 593.20 ± 14.6% | 631.72 ± 1.5% | 1089.07 ± 0.7% | 467.51 ± 0.6% | 577.73 ± 3.8% | 1264.70 ± 0.6% | 25124.32 ± 0.2% | 591.14 ± 15.7% | 0.94 | 1.00 | 1.27 | 1.03 |
| literal: a word that is not there | 8 | 564.93 ± 0.6% | 611.86 ± 0.6% | 1021.56 ± 0.4% | 434.83 ± 0.7% | 556.92 ± 2.1% | 1194.19 ± 0.9% | 23628.49 ± 1.0% | 567.13 ± 0.6% | 0.92 | 1.00 | 1.30 | 1.01 |
| literal: one of four words | 26 | 216.38 ± 1.5% | 362.45 ± 1.1% | 478.16 ± 0.6% | 41.91 ± 0.5% | 217.04 ± 2.7% | 436.82 ± 8.3% | 11430.44 ± 8.4% | 215.95 ± 1.0% | 0.60 | 1.00 | 5.16 | 1.00 |
| literal: a word in any case | 11 | 412.53 ± 0.9% | 434.22 ± 0.4% | 613.33 ± 0.3% | 14.35 ± 0.5% | 603.56 ± 2.7% | refused | 19393.41 ± 15.3% | 410.49 ± 1.2% | 0.95 | 1.00 | 28.74 | 0.68 |
| literal: an href attribute | 12 | 325.06 ± 0.5% | 334.88 ± 0.6% | 435.76 ± 0.4% | 36.69 ± 3.9% | 425.89 ± 3.4% | 965.11 ± 1.8% | 18338.91 ± 2.0% | 323.89 ± 2.0% | 0.97 | 1.00 | 8.86 | 0.76 |
| literal: a word, second text | 10 | 524.51 ± 1.0% | 570.79 ± 0.2% | 912.44 ± 2.8% | 400.12 ± 0.6% | 483.49 ± 2.0% | 1035.85 ± 7.2% | 21524.43 ± 0.4% | 524.78 ± 0.5% | 0.92 | 1.00 | 1.31 | 1.08 |
| class: two capitalized words | 23 | 420.86 ± 0.6% | 448.05 ± 8.5% | 646.79 ± 3.3% | 94.50 ± 6.8% | 440.39 ± 2.1% | 884.68 ± 1.2% | 6393.31 ± 9.2% | 420.17 ± 1.6% | 0.94 | 1.00 | 4.45 | 0.96 |
| class: a word that ends in ing | 9 | 513.69 ± 1.6% | 572.69 ± 2.1% | 983.87 ± 0.4% | 113.29 ± 0.3% | 611.65 ± 2.7% | 1424.46 ± 3.7% | 15235.05 ± 0.7% | 513.77 ± 0.3% | 0.90 | 1.00 | 4.53 | 0.84 |
| class: a word in capitals | 16 | 445.92 ± 0.4% | 478.07 ± 0.3% | 778.82 ± 0.6% | 121.69 ± 3.6% | 638.39 ± 3.4% | 1195.78 ± 10.7% | 8379.31 ± 0.8% | 445.28 ± 9.9% | 0.93 | 1.00 | 3.66 | 0.70 |
| class: a number | 6 | 567.76 ± 0.9% | 620.63 ± 11.9% | 1171.61 ± 0.7% | 35.90 ± 0.9% | 1179.16 ± 2.3% | 2310.68 ± 1.4% | 20380.49 ± 0.5% | 567.23 ± 12.9% | 0.91 | 1.00 | 15.82 | 0.48 |
| class: two capitalized words, second text | 23 | 420.03 ± 2.2% | 450.88 ± 9.6% | 648.49 ± 3.6% | 95.26 ± 1.2% | 441.59 ± 13.1% | 947.52 ± 1.7% | 6389.95 ± 10.8% | 421.79 ± 1.1% | 0.93 | 1.00 | 4.41 | 0.95 |
| other: a word between two words | 13 | 506.89 ± 0.4% | 519.17 ± 11.1% | 797.59 ± 9.6% | 122.52 ± 1.0% | 429.25 ± 2.9% | 1033.92 ± 1.6% | 14070.46 ± 0.5% | 505.77 ± 0.6% | 0.98 | 1.00 | 4.14 | 1.18 |
| other: a number before a unit, second text | 15 | 378.08 ± 2.4% | 416.76 ± 0.3% | 582.00 ± 0.1% | 33.46 ± 0.5% | 531.05 ± 5.4% | 1126.15 ± 1.1% | 13923.57 ± 5.7% | 377.47 ± 0.5% | 0.91 | 1.00 | 11.30 | 0.71 |
| other: a heading's start tag | 13 | 334.45 ± 1.3% | 339.16 ± 0.8% | 443.95 ± 2.1% | 34.53 ± 2.8% | 504.22 ± 2.1% | 1099.09 ± 11.6% | 16231.37 ± 0.5% | 336.03 ± 0.6% | 0.99 | 1.00 | 9.69 | 0.66 |
| other: a whole word | 11 | 510.89 ± 1.2% | 538.18 ± 0.6% | 834.05 ± 6.6% | 109.58 ± 1.1% | 496.16 ± 2.7% | 1064.33 ± 1.0% | 20522.42 ± 3.0% | 510.94 ± 0.3% | 0.95 | 1.00 | 4.66 | 1.03 |
| other: a line's first word, second text | 17 | 491.74 ± 11.3% | 508.55 ± 0.6% | 813.12 ± 0.8% | 113.41 ± 1.1% | 578.25 ± 2.1% | refused | refused | 487.66 ± 0.9% | 0.97 | 1.01 | 4.34 | 0.85 |
| other: fourteen octets before an x | 16 | 88.67 ± 0.4% | 126.18 ± 1.8% | 143.72 ± 10.6% | 14.10 ± 1.6% | 386.78 ± 1.7% | 454.70 ± 9.4% | 11899.37 ± 1.2% | 88.84 ± 4.5% | 0.70 | 1.00 | 6.29 | 0.23 |
| other: a Greek word | 8 | 395.27 ± 8.5% | 545.15 ± 0.7% | 922.00 ± 0.5% | 46.41 ± 0.6% | 1128.55 ± 3.0% | 2268.47 ± 1.1% | refused | 396.24 ± 0.4% | 0.73 | 1.00 | 8.52 | 0.35 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21249.25 ± 24.8% | not timed | not timed | 26429.44 ± 2.6% | 1848.51 ± 21.1% | not timed | not timed | 21133.46 ± 3.0% | | 1.01 | 0.80 | 11.50 |
| 01-literal/sherlock-casei-en | 522 | 7644.12 ± 2.5% | not timed | not timed | 7044.40 ± 0.5% | 28.36 ± 0.9% | not timed | not timed | 7620.30 ± 0.6% | | 1.00 | 1.09 | 269.55 |
| 01-literal/sherlock-ru | 724 | 23562.18 ± 10.4% | not timed | not timed | 27963.99 ± 0.3% | 1074.95 ± 9.1% | not timed | not timed | 23434.84 ± 4.6% | | 1.01 | 0.84 | 21.92 |
| 01-literal/sherlock-casei-ru | 746 | 9403.24 ± 0.4% | not timed | not timed | 5508.04 ± 3.6% | 30.45 ± 1.0% | not timed | not timed | 9391.67 ± 0.4% | | 1.00 | 1.71 | 308.84 |
| 01-literal/sherlock-zh | 30 | 42109.94 ± 5.0% | not timed | not timed | 36936.91 ± 0.5% | 1255.73 ± 9.3% | not timed | not timed | 41908.09 ± 1.8% | | 1.00 | 1.14 | 33.53 |
| 02-literal-alternate/sherlock-en | 714 | 9603.36 ± 0.9% | not timed | not timed | 8898.94 ± 2.6% | 14.78 ± 5.8% | not timed | not timed | 9601.33 ± 0.6% | | 1.00 | 1.08 | 649.82 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1988.33 ± 0.4% | not timed | not timed | 1802.55 ± 1.6% | 9.42 ± 19.0% | not timed | not timed | 1967.05 ± 1.2% | | 1.01 | 1.10 | 211.09 |
| 02-literal-alternate/sherlock-ru | 899 | 7816.71 ± 0.6% | not timed | not timed | 4250.61 ± 3.7% | 19.16 ± 1.1% | not timed | not timed | 7780.11 ± 1.3% | | 1.00 | 1.84 | 407.98 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2058.98 ± 6.7% | not timed | not timed | 1045.12 ± 0.9% | 8.60 ± 3.0% | not timed | not timed | 2066.93 ± 0.7% | | 1.00 | 1.97 | 239.36 |
| 02-literal-alternate/sherlock-zh | 207 | 13817.57 ± 0.8% | not timed | not timed | 10359.61 ± 0.4% | 27.13 ± 2.9% | not timed | not timed | 13875.87 ± 0.3% | | 1.00 | 1.33 | 509.35 |
| 03-date/ascii | 111817 | 97.70 ± 0.2% | not timed | not timed | 84.41 ± 3.1% | 0.18 ± 0.8% | not timed | not timed | 96.52 ± 2.1% | | 1.01 | 1.16 | 549.83 |
| 04-ruff-noqa/real | 84 | 417.95 ± 0.1% | not timed | not timed | 440.60 ± 3.0% | 15.69 ± 1.5% | not timed | not timed | 418.13 ± 1.9% | | 1.00 | 0.95 | 26.63 |
| 04-ruff-noqa/tweaked | 44 | 476.73 ± 2.4% | not timed | not timed | 431.63 ± 0.2% | 293.77 ± 0.4% | not timed | not timed | 472.76 ± 0.7% | | 1.01 | 1.10 | 1.62 |
| 05-lexer-veryl/single | 124800 | 3.36 ± 3.5% | not timed | not timed | 4.29 ± 0.2% | 0.21 ± 7.3% | not timed | not timed | 3.27 ± 24.1% | | 1.03 | 0.78 | 16.11 |
| 06-cloud-flare-redos/original | 107 | 348.19 ± 3.5% | not timed | not timed | 191.56 ± 1.8% | 20.30 ± 14.7% | not timed | not timed | 347.31 ± 5.0% | | 1.00 | 1.82 | 17.15 |
| 06-cloud-flare-redos/simplified-short | 102 | 331.85 ± 0.7% | not timed | not timed | 192.83 ± 0.1% | 21.82 ± 0.8% | not timed | not timed | 331.33 ± 0.2% | | 1.00 | 1.72 | 15.21 |
| 06-cloud-flare-redos/simplified-long | 10000 | 464.84 ± 0.1% | not timed | not timed | 211.38 ± 1.0% | 24.06 ± 0.5% | not timed | not timed | 464.79 ± 0.1% | | 1.00 | 2.20 | 19.32 |
| 07-unicode-character-data/parse-line | 558784 | 198.27 ± 3.0% | not timed | not timed | 160.44 ± 2.5% | 35.41 ± 7.1% | not timed | not timed | 194.99 ± 2.8% | | 1.02 | 1.24 | 5.60 |
| 08-words/all-english | 56691 | 93.84 ± 2.7% | not timed | not timed | 72.29 ± 2.5% | 10.74 ± 13.8% | not timed | not timed | 92.25 ± 2.4% | | 1.02 | 1.30 | 8.74 |
| 08-words/long-english | 839 | 533.01 ± 0.7% | not timed | not timed | 514.94 ± 0.7% | 25.97 ± 26.6% | not timed | not timed | 535.43 ± 0.1% | | 1.00 | 1.04 | 20.52 |
| 09-aws-keys/full | 0 | 425.54 ± 0.5% | not timed | not timed | 447.92 ± 2.3% | 49.01 ± 2.3% | not timed | not timed | 422.43 ± 0.1% | | 1.01 | 0.95 | 8.68 |
| 09-aws-keys/quick | 0 | 782.15 ± 0.5% | not timed | not timed | 801.56 ± 8.3% | 323.23 ± 12.4% | not timed | not timed | 781.20 ± 0.3% | | 1.00 | 0.98 | 2.42 |
| 10-bounded-repeat/letters-en | 1833 | 486.41 ± 3.5% | not timed | not timed | 432.39 ± 2.0% | 16.97 ± 0.8% | not timed | not timed | 484.10 ± 0.5% | | 1.00 | 1.12 | 28.66 |
| 10-bounded-repeat/letters-ru | 3475 | 431.91 ± 1.6% | not timed | not timed | 408.65 ± 0.7% | 19.49 ± 4.2% | not timed | not timed | 431.03 ± 0.5% | | 1.00 | 1.06 | 22.16 |
| 10-bounded-repeat/context | 53 | 64.13 ± 1.5% | not timed | not timed | 56.39 ± 0.9% | 16.82 ± 2.4% | not timed | not timed | 64.31 ± 1.7% | | 1.00 | 1.14 | 3.81 |
| 10-bounded-repeat/capitals | 11 | 558.40 ± 7.9% | not timed | not timed | 530.55 ± 1.4% | 29.67 ± 5.5% | not timed | not timed | 558.03 ± 8.1% | | 1.00 | 1.05 | 18.82 |
| 11-unstructured-to-json/extract | 600 | 53.83 ± 0.4% | not timed | not timed | 62.33 ± 0.8% | 40.73 ± 0.5% | not timed | not timed | 54.00 ± 0.3% | | 1.00 | 0.86 | 1.32 |
| 12-dictionary/single | 1 | 461.12 ± 0.9% | not timed | not timed | 442.62 ± 0.4% | 0.32 ± 1.3% | not timed | not timed | 464.08 ± 0.3% | | 0.99 | 1.04 | 1439.07 |
| 14-quadratic/1x | 100 | 20.79 ± 1.0% | not timed | not timed | 9.11 ± 0.3% | 0.80 ± 1.7% | not timed | not timed | 20.44 ± 1.1% | | 1.02 | 2.28 | 25.99 |
| 14-quadratic/2x | 200 | 15.88 ± 1.1% | not timed | not timed | 4.91 ± 0.5% | 0.43 ± 1.8% | not timed | not timed | 15.83 ± 0.7% | | 1.00 | 3.23 | 36.90 |
| 14-quadratic/10x | 1000 | 5.62 ± 0.4% | not timed | not timed | 1.05 ± 0.3% | 0.09 ± 15.9% | not timed | not timed | 5.61 ± 1.2% | | 1.00 | 5.35 | 60.54 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.19 ± 0.4% | not timed | not timed | 0.38 ± 0.3% | 0.46 ± 1.3% | not timed | not timed | 1.19 ± 1.9% | | 1.01 | 3.10 | 2.56 |
| 04-ruff-noqa/compile-real | 1 | 86.45 ± 0.9% | not timed | not timed | 12.78 ± 4.6% | 118.96 ± 3.5% | not timed | not timed | 85.96 ± 4.2% | | 1.01 | 6.76 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 12.80 ± 0.4% | not timed | not timed | 2.35 ± 1.0% | 5.83 ± 4.1% | not timed | not timed | 12.76 ± 0.8% | | 1.00 | 5.46 | 2.19 |
| 07-unicode-character-data/compile | 1 | 52.86 ± 0.2% | not timed | not timed | 24.00 ± 1.0% | 31.96 ± 20.5% | not timed | not timed | 52.52 ± 1.9% | | 1.01 | 2.20 | 1.65 |
| 09-aws-keys/compile-full | 1 | 35.73 ± 0.4% | not timed | not timed | 7.37 ± 0.6% | 19.45 ± 4.6% | not timed | not timed | 35.42 ± 1.4% | | 1.01 | 4.84 | 1.84 |
| 09-aws-keys/compile-quick | 1 | 160.39 ± 0.5% | not timed | not timed | 45.27 ± 0.6% | 112.04 ± 3.5% | not timed | not timed | 155.59 ± 1.2% | | 1.03 | 3.54 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 10.58 ± 0.7% | not timed | not timed | 11.66 ± 0.7% | 14.41 ± 20.4% | not timed | not timed | 10.62 ± 1.7% | | 1.00 | 0.91 | 0.73 |
| 10-bounded-repeat/compile-capitals | 1 | 73.71 ± 0.6% | not timed | not timed | 8.75 ± 4.3% | 22.06 ± 4.1% | not timed | not timed | 73.39 ± 2.1% | | 1.00 | 8.42 | 3.34 |
| 11-unstructured-to-json/compile | 1 | 78.80 ± 0.4% | not timed | not timed | 36.29 ± 0.5% | 57.40 ± 2.2% | not timed | not timed | 78.33 ± 19.7% | | 1.01 | 2.17 | 1.37 |
| 12-dictionary/compile-single | 1 | 0.29 ± 14.4% | not timed | not timed | 0.07 ± 23.7% | 0.08 ± 15.1% | not timed | not timed | 0.28 ± 1.6% | | 1.01 | 4.43 | 3.57 |

