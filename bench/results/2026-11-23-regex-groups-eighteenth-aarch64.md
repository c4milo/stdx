# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215476620 |
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
| literal: a word | 217 | 16088.16 ± 2.1% | 5000.21 ± 0.3% | 27.53 ± 0.3% | 18248.80 ± 2.3% | 9166.62 ± 7.6% | 17.46 ± 0.2% | 83.99 ± 0.4% | 16254.65 ± 2.6% | 3.22 | 0.99 | 0.88 | 1.76 |
| literal: a word that is not there | 0 | 18709.71 ± 1.0% | 4882.38 ± 0.5% | 27.58 ± 0.1% | 19767.32 ± 1.5% | 29116.92 ± 1.2% | 17.25 ± 0.2% | 79.80 ± 0.4% | 18706.38 ± 1.3% | 3.83 | 1.00 | 0.95 | 0.64 |
| literal: one of four words | 661 | 6077.18 ± 0.3% | 1932.21 ± 0.2% | 14.13 ± 0.2% | 3941.53 ± 0.4% | 21.85 ± 0.2% | 5.25 ± 0.2% | 6.88 ± 0.9% | 6065.09 ± 0.3% | 3.15 | 1.00 | 1.54 | 278.09 |
| literal: a word in any case | 217 | 12571.21 ± 0.8% | 2072.41 ± 0.2% | 20.64 ± 2.0% | 3969.95 ± 0.2% | 36.31 ± 1.1% | refused | differs | 12558.06 ± 0.5% | 6.07 | 1.00 | 3.17 | 346.25 |
| literal: an href attribute | 33 | 13708.94 ± 1.1% | 615.99 ± 0.1% | 26.35 ± 0.2% | 17129.83 ± 1.0% | 2256.11 ± 0.5% | 13.32 ± 0.1% | 73.65 ± 1.1% | 13688.04 ± 0.6% | 22.26 | 1.00 | 0.80 | 6.08 |
| literal: a word, second text | 123 | 16401.54 ± 1.2% | 3353.24 ± 0.4% | 27.19 ± 0.3% | 18080.01 ± 0.8% | 7564.02 ± 10.2% | 19.60 ± 0.6% | 69.84 ± 1.6% | 16516.87 ± 1.8% | 4.89 | 0.99 | 0.91 | 2.17 |
| class: two capitalized words | 1331 | 1063.79 ± 0.4% | 603.64 ± 0.1% | 25.21 ± 0.3% | 585.36 ± 0.1% | 40.47 ± 8.2% | 14.80 ± 0.2% | 66.78 ± 0.5% | 1061.85 ± 0.3% | 1.76 | 1.00 | 1.82 | 26.29 |
| class: a word that ends in ing | 3399 | 580.24 ± 0.2% | 578.98 ± 0.2% | 17.65 ± 0.4% | 547.85 ± 0.0% | 29.56 ± 10.1% | 8.16 ± 0.2% | 18.37 ± 0.4% | 579.79 ± 0.2% | 1.00 | 1.00 | 1.06 | 19.63 |
| class: a word in capitals | 2332 | 1374.17 ± 0.5% | 615.15 ± 0.3% | 26.79 ± 0.2% | 572.29 ± 0.1% | 43.05 ± 8.8% | 17.17 ± 0.4% | 82.43 ± 0.9% | 1372.92 ± 0.2% | 2.23 | 1.00 | 2.40 | 31.92 |
| class: a number | 8288 | 2002.79 ± 0.2% | 833.69 ± 0.2% | 27.07 ± 0.2% | 1723.35 ± 0.5% | 38.80 ± 13.9% | 0.56 ± 0.2% | 57.37 ± 0.9% | 2000.35 ± 0.3% | 2.40 | 1.00 | 1.16 | 51.61 |
| class: two capitalized words, second text | 5359 | 521.11 ± 0.2% | 527.99 ± 0.1% | 22.59 ± 0.2% | 485.47 ± 0.1% | 34.08 ± 14.1% | 16.64 ± 0.3% | 62.76 ± 0.8% | 520.49 ± 0.1% | 0.99 | 1.00 | 1.07 | 15.29 |
| other: a word between two words | 6104 | 742.32 ± 0.3% | 597.87 ± 0.1% | 22.94 ± 0.4% | 734.55 ± 0.4% | 104.36 ± 13.5% | 11.29 ± 0.2% | 68.12 ± 0.2% | 742.38 ± 0.3% | 1.24 | 1.00 | 1.01 | 7.11 |
| other: a number before a unit, second text | 1481 | 5353.11 ± 0.7% | 1108.88 ± 0.3% | 25.33 ± 0.1% | 5659.27 ± 0.4% | 40.66 ± 15.7% | 17.77 ± 0.2% | 65.88 ± 0.2% | 5324.16 ± 0.4% | 4.83 | 1.01 | 0.95 | 131.65 |
| other: a heading's start tag | 110 | 12545.90 ± 0.8% | 750.93 ± 0.1% | 26.58 ± 0.2% | 1705.77 ± 0.4% | 1578.30 ± 1.3% | 16.14 ± 7.9% | 85.69 ± 0.5% | 12568.61 ± 0.5% | 16.71 | 1.00 | 7.35 | 7.95 |
| other: a whole word | 217 | 13887.28 ± 0.5% | 608.70 ± 0.1% | 28.59 ± 0.3% | 14596.67 ± 0.3% | 47.67 ± 0.3% | 13.58 ± 0.1% | 54.95 ± 0.8% | 13891.45 ± 0.8% | 22.81 | 1.00 | 0.95 | 291.31 |
| other: a line's first word, second text | 3716 | 1948.98 ± 0.6% | 593.82 ± 0.1% | 29.88 ± 0.3% | 1722.23 ± 0.3% | 61.69 ± 8.1% | refused | refused | 1945.73 ± 0.2% | 3.28 | 1.00 | 1.13 | 31.59 |
| other: fourteen octets before an x | 87 | 19293.14 ± 0.7% | 238.95 ± 0.4% | 6.27 ± 0.1% | 3994.06 ± 0.5% | 10.62 ± 0.1% | differs | 17.75 ± 0.1% | 19297.46 ± 1.0% | 80.74 | 1.00 | 4.83 | 1816.01 |
| other: a Greek word | 21815 | 500.69 ± 1.3% | 412.61 ± 0.2% | 30.36 ± 0.3% | 289.68 ± 0.1% | 42.98 ± 10.5% | differs | refused | 497.97 ± 0.6% | 1.21 | 1.01 | 1.73 | 11.65 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.81 ± 0.1% | 19.88 ± 0.2% | 0.85 ± 0.1% | 19.85 ± 0.2% | 2.75 ± 0.9% | differs | 4.05 ± 0.1% | 19.88 ± 0.4% | 1.00 | 1.00 | 1.00 | 7.20 |
| a UUID | 32895 | 21.30 ± 0.2% | 21.33 ± 0.2% | 0.64 ± 0.2% | 15.12 ± 0.4% | 3.08 ± 0.2% | 0.72 ± 0.3% | 3.63 ± 0.7% | 21.33 ± 0.1% | 1.00 | 1.00 | 1.41 | 6.91 |
| an IPv4 address | 33176 | 36.82 ± 0.6% | 36.78 ± 0.5% | 2.06 ± 0.1% | 29.19 ± 0.4% | 6.65 ± 0.2% | differs | 4.13 ± 0.1% | 36.78 ± 0.4% | 1.00 | 1.00 | 1.26 | 5.54 |
| a date and time | 32954 | 31.39 ± 0.3% | 31.37 ± 0.3% | 1.41 ± 0.3% | 21.50 ± 0.4% | 7.03 ± 0.1% | 1.18 ± 0.1% | 7.14 ± 0.6% | 31.36 ± 0.1% | 1.00 | 1.00 | 1.46 | 4.47 |
| a field path | 32606 | 23.47 ± 0.3% | 23.53 ± 0.3% | 1.00 ± 0.3% | 23.22 ± 0.1% | 3.50 ± 0.9% | differs | 2.96 ± 0.3% | 23.51 ± 0.1% | 1.00 | 1.00 | 1.01 | 6.71 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.14 ± 0.4% | 11.09 ± 0.3% | 11.12 ± 0.2% | 11.37 ± 0.1% | 4.92 ± 1.2% | 0.91 ± 0.7% | none | 11.11 ± 0.2% | 1.00 | 1.00 | 0.98 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.60 ± 0.3% | 235.50 ± 0.2% | 277.07 ± 0.3% | 86.48 ± 0.6% | 222.00 ± 1.4% | 483.86 ± 0.3% | 3778.81 ± 0.6% | 234.68 ± 0.3% | 1.00 | 1.00 | 2.71 | 1.06 |
| a UUID | 62 | 151.77 ± 0.3% | 152.04 ± 0.4% | 169.42 ± 0.2% | 45.63 ± 1.1% | 98.54 ± 1.8% | 183.27 ± 2.4% | 4208.29 ± 0.2% | 151.77 ± 0.6% | 1.00 | 1.00 | 3.33 | 1.54 |
| an IPv4 address | 29 | 429.94 ± 0.2% | 433.66 ± 0.4% | 598.23 ± 0.5% | 77.95 ± 0.1% | 128.69 ± 4.2% | 291.92 ± 0.9% | 7497.62 ± 0.5% | 430.15 ± 0.1% | 0.99 | 1.00 | 5.52 | 3.34 |
| a date and time | 56 | 302.10 ± 0.4% | 303.32 ± 0.4% | 374.07 ± 0.4% | 72.98 ± 1.2% | 135.84 ± 2.0% | 328.98 ± 2.1% | 4884.00 ± 0.5% | 301.89 ± 0.4% | 1.00 | 1.00 | 4.14 | 2.22 |
| a field path | 39 | 227.65 ± 0.3% | 228.17 ± 0.2% | 267.33 ± 0.2% | 80.25 ± 0.8% | 203.19 ± 1.4% | 528.65 ± 6.1% | 4823.96 ± 1.2% | 227.72 ± 0.1% | 1.00 | 1.00 | 2.84 | 1.12 |
| literal: a word | 7 | 648.99 ± 0.4% | 695.92 ± 0.3% | 1222.69 ± 0.2% | 495.11 ± 0.1% | 628.90 ± 2.3% | 961.11 ± 0.7% | 29674.81 ± 0.3% | 648.00 ± 0.4% | 0.93 | 1.00 | 1.31 | 1.03 |
| literal: a word that is not there | 8 | 625.60 ± 0.3% | 675.87 ± 0.5% | 1157.34 ± 0.2% | 446.56 ± 0.2% | 600.62 ± 1.6% | 907.69 ± 0.6% | 28612.13 ± 0.1% | 625.11 ± 0.1% | 0.93 | 1.00 | 1.40 | 1.04 |
| literal: one of four words | 26 | 249.90 ± 0.2% | 406.70 ± 0.2% | 544.82 ± 0.5% | 50.31 ± 0.9% | 241.19 ± 1.8% | 381.20 ± 0.8% | 15803.14 ± 0.1% | 249.66 ± 0.4% | 0.61 | 1.00 | 4.97 | 1.04 |
| literal: a word in any case | 11 | 456.40 ± 0.3% | 486.32 ± 0.1% | 702.26 ± 0.1% | 15.41 ± 0.2% | 638.67 ± 2.8% | refused | 23354.73 ± 0.4% | 456.38 ± 0.5% | 0.94 | 1.00 | 29.61 | 0.71 |
| literal: an href attribute | 12 | 348.72 ± 0.1% | 359.12 ± 0.5% | 465.50 ± 0.6% | 45.69 ± 0.3% | 498.21 ± 1.9% | 777.51 ± 0.3% | 21060.79 ± 0.3% | 348.24 ± 0.4% | 0.97 | 1.00 | 7.63 | 0.70 |
| literal: a word, second text | 10 | 577.36 ± 0.3% | 632.23 ± 0.4% | 1042.18 ± 0.6% | 395.41 ± 0.2% | 535.61 ± 4.7% | 812.16 ± 0.9% | 26543.47 ± 0.3% | 577.56 ± 0.8% | 0.91 | 1.00 | 1.46 | 1.08 |
| class: two capitalized words | 23 | 445.46 ± 1.3% | 474.43 ± 0.6% | 677.27 ± 1.1% | 98.91 ± 0.1% | 497.81 ± 0.7% | 747.92 ± 0.5% | 6443.97 ± 0.1% | 446.45 ± 1.1% | 0.94 | 1.00 | 4.50 | 0.89 |
| class: a word that ends in ing | 9 | 580.37 ± 0.4% | 646.12 ± 0.4% | 1107.95 ± 0.3% | 131.06 ± 1.3% | 747.45 ± 1.5% | 1108.43 ± 0.3% | 15621.64 ± 0.3% | 578.80 ± 0.4% | 0.90 | 1.00 | 4.43 | 0.78 |
| class: a word in capitals | 16 | 506.78 ± 1.3% | 545.79 ± 1.2% | 862.93 ± 1.4% | 134.69 ± 1.1% | 745.80 ± 1.6% | 1028.93 ± 0.8% | 8484.41 ± 0.2% | 507.12 ± 0.3% | 0.93 | 1.00 | 3.76 | 0.68 |
| class: a number | 6 | 647.61 ± 0.4% | 711.23 ± 0.4% | 1320.35 ± 0.2% | 41.80 ± 1.0% | 1392.54 ± 1.8% | 1857.63 ± 1.0% | 22404.94 ± 0.0% | 647.40 ± 0.2% | 0.91 | 1.00 | 15.49 | 0.47 |
| class: two capitalized words, second text | 23 | 444.99 ± 0.5% | 474.70 ± 0.4% | 676.76 ± 0.4% | 99.99 ± 0.2% | 500.59 ± 2.2% | 739.50 ± 3.2% | 6441.58 ± 0.1% | 446.05 ± 0.4% | 0.94 | 1.00 | 4.45 | 0.89 |
| other: a word between two words | 13 | 559.57 ± 0.3% | 576.64 ± 0.5% | 901.62 ± 0.8% | 133.06 ± 0.5% | 488.59 ± 2.5% | 814.66 ± 1.0% | 14582.15 ± 0.2% | 558.65 ± 0.4% | 0.97 | 1.00 | 4.21 | 1.15 |
| other: a number before a unit, second text | 15 | 406.70 ± 0.8% | 443.91 ± 0.7% | 619.36 ± 0.2% | 39.49 ± 0.4% | 625.14 ± 0.5% | 892.93 ± 0.6% | 14895.24 ± 0.3% | 405.77 ± 0.5% | 0.92 | 1.00 | 10.30 | 0.65 |
| other: a heading's start tag | 13 | 359.81 ± 0.2% | 364.80 ± 0.4% | 476.02 ± 0.5% | 44.22 ± 0.1% | 614.77 ± 1.4% | 875.13 ± 0.2% | 17640.35 ± 0.4% | 359.81 ± 0.5% | 0.99 | 1.00 | 8.14 | 0.59 |
| other: a whole word | 11 | 593.06 ± 0.4% | 628.00 ± 0.3% | 1037.03 ± 0.2% | 118.79 ± 0.6% | 559.69 ± 0.5% | 834.59 ± 0.8% | 26417.83 ± 0.3% | 593.44 ± 0.3% | 0.94 | 1.00 | 4.99 | 1.06 |
| other: a line's first word, second text | 17 | 545.37 ± 0.2% | 564.80 ± 0.2% | 893.59 ± 0.2% | 128.85 ± 0.1% | 700.84 ± 1.6% | refused | refused | 543.56 ± 0.6% | 0.97 | 1.00 | 4.23 | 0.78 |
| other: fourteen octets before an x | 16 | 109.36 ± 0.4% | 156.72 ± 0.6% | 178.30 ± 0.3% | 14.89 ± 1.0% | 441.79 ± 3.6% | 414.88 ± 0.5% | 12583.60 ± 0.8% | 109.21 ± 0.3% | 0.70 | 1.00 | 7.35 | 0.25 |
| other: a Greek word | 8 | 463.56 ± 0.2% | 613.47 ± 0.6% | 1029.09 ± 0.1% | 59.16 ± 0.3% | 1378.25 ± 2.5% | 1824.66 ± 0.5% | refused | 463.27 ± 0.2% | 0.76 | 1.00 | 7.84 | 0.34 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12798.31 ± 0.5% | not timed | not timed | 16126.06 ± 0.8% | 1985.71 ± 15.9% | not timed | not timed | 12780.04 ± 0.7% | | 1.00 | 0.79 | 6.45 |
| 01-literal/sherlock-casei-en | 522 | 4948.79 ± 0.8% | not timed | not timed | 3596.51 ± 0.1% | 31.27 ± 1.1% | not timed | not timed | 4930.80 ± 0.3% | | 1.00 | 1.38 | 158.28 |
| 01-literal/sherlock-ru | 724 | 13561.45 ± 0.5% | not timed | not timed | 17287.24 ± 0.4% | 1591.53 ± 12.2% | not timed | not timed | 13518.22 ± 0.3% | | 1.00 | 0.78 | 8.52 |
| 01-literal/sherlock-casei-ru | 746 | 5978.99 ± 0.5% | not timed | not timed | 3335.26 ± 0.1% | 31.34 ± 7.9% | not timed | not timed | 5957.25 ± 0.7% | | 1.00 | 1.79 | 190.79 |
| 01-literal/sherlock-zh | 30 | 17072.61 ± 0.5% | not timed | not timed | 18611.84 ± 0.5% | 2568.30 ± 15.0% | not timed | not timed | 17041.97 ± 0.2% | | 1.00 | 0.92 | 6.65 |
| 02-literal-alternate/sherlock-en | 714 | 5760.29 ± 0.5% | not timed | not timed | 3940.96 ± 0.2% | 16.63 ± 0.1% | not timed | not timed | 5748.62 ± 0.3% | | 1.00 | 1.46 | 346.43 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1807.95 ± 1.0% | not timed | not timed | 696.49 ± 0.3% | 11.05 ± 0.2% | not timed | not timed | 1793.83 ± 0.4% | | 1.01 | 2.60 | 163.61 |
| 02-literal-alternate/sherlock-ru | 899 | 5339.63 ± 0.3% | not timed | not timed | 3264.57 ± 0.1% | 22.64 ± 0.1% | not timed | not timed | 5327.54 ± 0.1% | | 1.00 | 1.64 | 235.88 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1919.17 ± 0.9% | not timed | not timed | 1234.03 ± 0.2% | 9.14 ± 0.1% | not timed | not timed | 1911.08 ± 0.2% | | 1.00 | 1.56 | 209.98 |
| 02-literal-alternate/sherlock-zh | 207 | 7057.07 ± 0.2% | not timed | not timed | 4159.36 ± 0.2% | 31.49 ± 0.2% | not timed | not timed | 7052.26 ± 0.3% | | 1.00 | 1.70 | 224.12 |
| 03-date/ascii | 111817 | 126.76 ± 1.3% | not timed | not timed | 95.38 ± 0.1% | 0.20 ± 1.2% | not timed | not timed | 125.94 ± 0.2% | | 1.01 | 1.33 | 625.78 |
| 04-ruff-noqa/real | 84 | 409.96 ± 0.1% | not timed | not timed | 458.67 ± 0.1% | 19.67 ± 1.3% | not timed | not timed | 407.96 ± 0.1% | | 1.00 | 0.89 | 20.84 |
| 04-ruff-noqa/tweaked | 44 | 552.51 ± 0.1% | not timed | not timed | 460.62 ± 0.1% | 365.59 ± 1.6% | not timed | not timed | 551.99 ± 0.2% | | 1.00 | 1.20 | 1.51 |
| 05-lexer-veryl/single | 124800 | 5.24 ± 0.4% | not timed | not timed | 4.96 ± 0.1% | 0.21 ± 3.9% | not timed | not timed | 5.10 ± 6.7% | | 1.03 | 1.06 | 25.43 |
| 06-cloud-flare-redos/original | 107 | 413.92 ± 1.7% | not timed | not timed | 215.00 ± 0.4% | 24.44 ± 4.6% | not timed | not timed | 410.01 ± 5.3% | | 1.01 | 1.93 | 16.94 |
| 06-cloud-flare-redos/simplified-short | 102 | 410.54 ± 0.1% | not timed | not timed | 227.85 ± 3.6% | 26.74 ± 17.1% | not timed | not timed | 409.74 ± 0.4% | | 1.00 | 1.80 | 15.35 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.67 ± 0.1% | not timed | not timed | 255.04 ± 0.1% | 28.78 ± 0.2% | not timed | not timed | 586.34 ± 0.3% | | 1.00 | 2.30 | 20.42 |
| 07-unicode-character-data/parse-line | 558784 | 236.42 ± 0.1% | not timed | not timed | 170.00 ± 0.1% | 42.63 ± 0.8% | not timed | not timed | 236.91 ± 0.4% | | 1.00 | 1.39 | 5.55 |
| 08-words/all-english | 56691 | 117.10 ± 0.5% | not timed | not timed | 83.15 ± 0.1% | 12.73 ± 5.2% | not timed | not timed | 116.64 ± 0.6% | | 1.00 | 1.41 | 9.20 |
| 08-words/long-english | 839 | 621.03 ± 0.1% | not timed | not timed | 595.33 ± 0.2% | 32.21 ± 0.3% | not timed | not timed | 620.64 ± 0.1% | | 1.00 | 1.04 | 19.28 |
| 09-aws-keys/full | 0 | 415.82 ± 0.0% | not timed | not timed | 463.44 ± 0.2% | 64.70 ± 3.4% | not timed | not timed | 415.24 ± 0.1% | | 1.00 | 0.90 | 6.43 |
| 09-aws-keys/quick | 0 | 739.91 ± 0.2% | not timed | not timed | 982.04 ± 0.5% | 416.75 ± 0.8% | not timed | not timed | 736.24 ± 0.1% | | 1.00 | 0.75 | 1.78 |
| 10-bounded-repeat/letters-en | 1833 | 585.98 ± 3.3% | not timed | not timed | 519.00 ± 0.4% | 19.51 ± 0.6% | not timed | not timed | 586.71 ± 2.2% | | 1.00 | 1.13 | 30.03 |
| 10-bounded-repeat/letters-ru | 3475 | 509.36 ± 1.2% | not timed | not timed | 478.43 ± 0.2% | 21.83 ± 8.8% | not timed | not timed | 503.37 ± 1.3% | | 1.01 | 1.06 | 23.33 |
| 10-bounded-repeat/context | 53 | 77.28 ± 0.4% | not timed | not timed | 65.04 ± 0.5% | 19.81 ± 0.3% | not timed | not timed | 77.03 ± 0.6% | | 1.00 | 1.19 | 3.90 |
| 10-bounded-repeat/capitals | 11 | 631.30 ± 8.2% | not timed | not timed | 615.52 ± 0.1% | 36.14 ± 0.1% | not timed | not timed | 630.41 ± 8.5% | | 1.00 | 1.03 | 17.47 |
| 11-unstructured-to-json/extract | 600 | 82.99 ± 0.1% | not timed | not timed | 78.01 ± 0.3% | 48.75 ± 0.5% | not timed | not timed | 82.90 ± 0.7% | | 1.00 | 1.06 | 1.70 |
| 12-dictionary/single | 1 | 561.26 ± 0.6% | not timed | not timed | 558.57 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 559.63 ± 0.2% | | 1.00 | 1.00 | 1389.40 |
| 14-quadratic/1x | 100 | 21.15 ± 2.1% | not timed | not timed | 10.02 ± 0.1% | 0.98 ± 3.6% | not timed | not timed | 21.11 ± 2.6% | | 1.00 | 2.11 | 21.69 |
| 14-quadratic/2x | 200 | 17.64 ± 0.7% | not timed | not timed | 5.49 ± 0.9% | 0.53 ± 1.8% | not timed | not timed | 17.57 ± 0.4% | | 1.00 | 3.21 | 33.39 |
| 14-quadratic/10x | 1000 | 7.71 ± 2.0% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.8% | not timed | not timed | 7.67 ± 0.6% | | 1.00 | 6.36 | 66.77 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 0.4% | not timed | not timed | 0.34 ± 0.2% | 0.55 ± 4.5% | not timed | not timed | 1.26 ± 1.7% | | 1.01 | 3.68 | 2.31 |
| 04-ruff-noqa/compile-real | 1 | 93.05 ± 0.1% | not timed | not timed | 13.71 ± 0.2% | 135.66 ± 2.3% | not timed | not timed | 92.74 ± 0.9% | | 1.00 | 6.79 | 0.69 |
| 05-lexer-veryl/compile-single | 1 | 13.81 ± 0.2% | not timed | not timed | 2.55 ± 1.1% | 6.40 ± 2.9% | not timed | not timed | 13.73 ± 1.6% | | 1.01 | 5.42 | 2.16 |
| 07-unicode-character-data/compile | 1 | 55.15 ± 0.2% | not timed | not timed | 25.66 ± 0.3% | 35.49 ± 2.0% | not timed | not timed | 54.79 ± 0.7% | | 1.01 | 2.15 | 1.55 |
| 09-aws-keys/compile-full | 1 | 41.94 ± 0.2% | not timed | not timed | 8.25 ± 0.3% | 23.22 ± 1.6% | not timed | not timed | 40.84 ± 2.9% | | 1.03 | 5.08 | 1.81 |
| 09-aws-keys/compile-quick | 1 | 188.85 ± 0.3% | not timed | not timed | 46.24 ± 0.1% | 129.32 ± 3.6% | not timed | not timed | 187.46 ± 1.3% | | 1.01 | 4.08 | 1.46 |
| 10-bounded-repeat/compile-context | 1 | 14.00 ± 0.4% | not timed | not timed | 11.19 ± 0.1% | 15.90 ± 2.7% | not timed | not timed | 13.90 ± 0.5% | | 1.01 | 1.25 | 0.88 |
| 10-bounded-repeat/compile-capitals | 1 | 83.58 ± 0.3% | not timed | not timed | 7.97 ± 0.2% | 23.61 ± 3.3% | not timed | not timed | 83.62 ± 2.4% | | 1.00 | 10.48 | 3.54 |
| 11-unstructured-to-json/compile | 1 | 86.53 ± 0.3% | not timed | not timed | 41.33 ± 0.1% | 67.38 ± 2.9% | not timed | not timed | 85.94 ± 0.6% | | 1.01 | 2.09 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.2% | not timed | not timed | 0.07 ± 9.1% | 0.09 ± 6.2% | not timed | not timed | 0.35 ± 0.7% | | 1.01 | 5.18 | 3.74 |

