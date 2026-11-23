# bench-regex

| Field | Value |
|---|---|
| Commit | 871c6df |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45159303707 |
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
| literal: a word | 217 | 33296.21 ± 2.2% | 896.93 ± 0.3% | 19.94 ± 0.5% | 31089.90 ± 1.6% | 8957.40 ± 9.0% | 10.84 ± 0.2% | 76.29 ± 1.9% | 32683.31 ± 2.8% | 37.12 | 1.02 | 1.07 | 3.72 |
| literal: a word that is not there | 0 | 50427.87 ± 3.8% | 905.60 ± 0.4% | 19.97 ± 0.7% | 39166.32 ± 0.8% | 29950.04 ± 0.6% | 10.78 ± 0.8% | 72.53 ± 0.7% | 49591.17 ± 1.0% | 55.68 | 1.02 | 1.29 | 1.68 |
| literal: one of four words | 661 | 11030.94 ± 4.1% | 873.87 ± 0.3% | 11.12 ± 2.3% | 9090.04 ± 0.5% | 18.08 ± 8.0% | 3.95 ± 1.0% | 6.30 ± 4.0% | 11092.92 ± 7.4% | 12.62 | 0.99 | 1.21 | 610.27 |
| literal: a word in any case | 217 | 26141.08 ± 3.7% | 896.41 ± 0.1% | 15.72 ± 0.8% | 9214.82 ± 0.3% | 37.23 ± 5.8% | refused | differs | 25740.36 ± 2.5% | 29.16 | 1.02 | 2.84 | 702.08 |
| literal: an href attribute | 33 | 26500.67 ± 2.0% | 902.11 ± 1.2% | 18.83 ± 0.9% | 26736.51 ± 5.4% | 2048.11 ± 0.6% | 8.28 ± 0.2% | 67.25 ± 11.9% | 26812.48 ± 1.7% | 29.38 | 0.99 | 0.99 | 12.94 |
| literal: a word, second text | 123 | 33608.21 ± 1.8% | 900.28 ± 0.1% | 19.78 ± 1.0% | 31425.86 ± 8.5% | 7242.08 ± 3.7% | 11.85 ± 0.6% | 65.68 ± 1.5% | 33671.01 ± 7.7% | 37.33 | 1.00 | 1.07 | 4.64 |
| class: two capitalized words | 1331 | 777.60 ± 0.1% | 827.46 ± 0.2% | 18.62 ± 1.5% | 506.21 ± 0.5% | 32.65 ± 4.6% | 9.40 ± 0.1% | 59.26 ± 3.0% | 777.22 ± 0.2% | 0.94 | 1.00 | 1.54 | 23.82 |
| class: a word that ends in ing | 3399 | 756.62 ± 0.6% | 757.27 ± 0.1% | 13.24 ± 1.7% | 470.50 ± 0.3% | 25.39 ± 1.3% | 5.35 ± 0.2% | 16.76 ± 2.6% | 756.58 ± 0.2% | 1.00 | 1.00 | 1.61 | 29.80 |
| class: a word in capitals | 2332 | 976.93 ± 0.2% | 805.54 ± 0.2% | 19.67 ± 2.2% | 497.99 ± 0.3% | 35.89 ± 10.4% | 9.96 ± 0.1% | 76.89 ± 0.2% | 976.03 ± 0.3% | 1.21 | 1.00 | 1.96 | 27.22 |
| class: a number | 8288 | 1359.05 ± 1.8% | 683.87 ± 2.1% | 19.36 ± 0.9% | 1482.41 ± 4.5% | 34.27 ± 20.4% | 0.34 ± 0.5% | 56.14 ± 4.5% | 1358.29 ± 0.2% | 1.99 | 1.00 | 0.92 | 39.66 |
| class: two capitalized words, second text | 5359 | 619.62 ± 0.4% | 619.20 ± 0.4% | 17.25 ± 1.2% | 411.71 ± 0.5% | 29.71 ± 10.6% | 10.64 ± 0.2% | 54.40 ± 3.1% | 617.95 ± 0.4% | 1.00 | 1.00 | 1.50 | 20.86 |
| other: a word between two words | 6104 | 686.77 ± 0.5% | 648.54 ± 0.5% | 16.97 ± 0.9% | 695.46 ± 0.3% | 96.47 ± 14.4% | 7.29 ± 0.3% | 59.21 ± 0.8% | 689.65 ± 0.6% | 1.06 | 1.00 | 0.99 | 7.12 |
| other: a number before a unit, second text | 1481 | 6987.63 ± 1.6% | 836.07 ± 0.5% | 18.38 ± 7.0% | 6403.27 ± 0.4% | 32.75 ± 4.8% | 11.06 ± 0.3% | 57.88 ± 4.1% | 6952.86 ± 4.6% | 8.36 | 1.01 | 1.09 | 213.36 |
| other: a heading's start tag | 110 | 18889.24 ± 1.6% | 895.82 ± 0.1% | 19.47 ± 0.6% | 2006.49 ± 10.1% | 1442.90 ± 1.9% | 10.05 ± 0.3% | 78.46 ± 1.3% | 18895.83 ± 4.2% | 21.09 | 1.00 | 9.41 | 13.09 |
| other: a whole word | 217 | 22300.15 ± 2.1% | 895.41 ± 0.1% | 20.83 ± 0.4% | 22537.65 ± 1.3% | 41.28 ± 10.3% | 9.57 ± 0.1% | 46.29 ± 0.5% | 22095.40 ± 11.1% | 24.91 | 1.01 | 0.99 | 540.23 |
| other: a line's first word, second text | 3716 | 1909.65 ± 1.9% | 744.07 ± 0.3% | 24.20 ± 0.6% | 1700.52 ± 1.3% | 52.34 ± 5.9% | refused | refused | 1896.57 ± 0.9% | 2.57 | 1.01 | 1.12 | 36.48 |
| other: fourteen octets before an x | 87 | 25973.31 ± 1.5% | 194.95 ± 0.7% | 5.61 ± 0.1% | 2710.92 ± 0.5% | 8.90 ± 0.7% | differs | 16.87 ± 3.0% | 25887.46 ± 1.2% | 133.23 | 1.00 | 9.58 | 2917.22 |
| other: a Greek word | 21815 | 397.04 ± 0.5% | 336.05 ± 0.4% | 24.31 ± 6.1% | 261.76 ± 1.3% | 43.71 ± 7.5% | differs | refused | 396.23 ± 1.0% | 1.18 | 1.00 | 1.52 | 9.08 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.35 ± 1.8% | 24.22 ± 1.3% | 0.80 ± 9.6% | 17.02 ± 0.1% | 2.33 ± 0.2% | differs | 3.56 ± 1.6% | 24.53 ± 2.6% | 1.01 | 0.99 | 1.43 | 10.44 |
| a UUID | 32895 | 20.42 ± 0.2% | 20.42 ± 0.1% | 0.54 ± 1.0% | 12.86 ± 0.4% | 2.50 ± 2.9% | 0.43 ± 0.2% | 3.17 ± 1.6% | 20.43 ± 0.3% | 1.00 | 1.00 | 1.59 | 8.17 |
| an IPv4 address | 33176 | 34.13 ± 1.3% | 34.08 ± 1.8% | 1.80 ± 1.5% | 24.22 ± 0.9% | 5.77 ± 1.6% | differs | 3.46 ± 1.3% | 34.19 ± 0.7% | 1.00 | 1.00 | 1.41 | 5.91 |
| a date and time | 32954 | 29.28 ± 2.1% | 30.00 ± 1.9% | 1.27 ± 2.5% | 18.08 ± 1.3% | 6.57 ± 3.1% | 0.74 ± 1.3% | 5.98 ± 10.9% | 29.96 ± 2.5% | 0.98 | 0.98 | 1.62 | 4.45 |
| a field path | 32606 | 26.96 ± 1.5% | 26.94 ± 1.9% | 0.91 ± 2.7% | 19.58 ± 2.9% | 2.93 ± 11.1% | differs | 2.31 ± 2.1% | 26.98 ± 1.2% | 1.00 | 1.00 | 1.38 | 9.19 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.25 ± 0.5% | 8.25 ± 0.2% | 8.24 ± 0.6% | 10.65 ± 0.2% | 4.72 ± 2.2% | 0.62 ± 2.6% | none | 8.15 ± 1.7% | 1.00 | 1.01 | 0.77 | 1.75 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 188.47 ± 1.9% | 189.94 ± 0.7% | 225.25 ± 0.5% | 79.11 ± 3.3% | 180.36 ± 1.9% | 526.06 ± 2.4% | 3917.92 ± 1.4% | 188.75 ± 1.0% | 0.99 | 1.00 | 2.38 | 1.04 |
| a UUID | 62 | 123.31 ± 0.4% | 123.76 ± 0.4% | 138.93 ± 1.3% | 46.66 ± 1.5% | 87.67 ± 22.5% | 196.99 ± 2.5% | 4035.46 ± 0.8% | 123.04 ± 0.6% | 1.00 | 1.00 | 2.64 | 1.41 |
| an IPv4 address | 29 | 375.76 ± 9.4% | 380.44 ± 0.7% | 549.83 ± 0.9% | 69.85 ± 13.1% | 109.75 ± 15.9% | 326.67 ± 2.3% | 6709.53 ± 13.1% | 376.23 ± 1.9% | 0.99 | 1.00 | 5.38 | 3.42 |
| a date and time | 56 | 274.86 ± 1.3% | 276.65 ± 12.6% | 355.80 ± 0.1% | 68.10 ± 0.7% | 121.16 ± 3.4% | 361.83 ± 6.6% | 4157.59 ± 14.9% | 275.18 ± 10.6% | 0.99 | 1.00 | 4.04 | 2.27 |
| a field path | 39 | 186.12 ± 7.6% | 187.06 ± 0.5% | 220.50 ± 8.1% | 73.79 ± 0.7% | 169.14 ± 4.4% | 585.78 ± 12.5% | 4783.01 ± 0.7% | 186.31 ± 0.5% | 0.99 | 1.00 | 2.52 | 1.10 |
| literal: a word | 7 | 552.15 ± 1.4% | 590.18 ± 2.1% | 1113.90 ± 0.6% | 495.18 ± 1.7% | 554.48 ± 3.0% | 1218.77 ± 0.7% | 25166.54 ± 1.0% | 547.72 ± 14.4% | 0.94 | 1.01 | 1.12 | 1.00 |
| literal: a word that is not there | 8 | 535.11 ± 1.1% | 574.25 ± 1.3% | 1053.50 ± 1.0% | 450.64 ± 1.5% | 538.21 ± 3.0% | 1128.31 ± 1.2% | 23959.43 ± 0.8% | 533.18 ± 13.7% | 0.93 | 1.00 | 1.19 | 0.99 |
| literal: one of four words | 26 | 214.64 ± 0.6% | 354.40 ± 11.8% | 492.00 ± 1.3% | 41.58 ± 1.4% | 214.19 ± 2.4% | 437.98 ± 9.0% | 12749.38 ± 8.4% | 214.42 ± 2.4% | 0.61 | 1.00 | 5.16 | 1.00 |
| literal: a word in any case | 11 | 438.53 ± 1.0% | 465.83 ± 1.4% | 743.04 ± 0.4% | 14.32 ± 11.3% | 585.94 ± 17.0% | refused | 19822.72 ± 2.4% | 437.59 ± 1.4% | 0.94 | 1.00 | 30.63 | 0.75 |
| literal: an href attribute | 12 | 313.81 ± 0.4% | 324.83 ± 0.8% | 442.70 ± 0.2% | 36.77 ± 0.8% | 418.41 ± 0.7% | 927.78 ± 1.3% | 17896.54 ± 1.6% | 314.28 ± 0.5% | 0.97 | 1.00 | 8.53 | 0.75 |
| literal: a word, second text | 10 | 504.59 ± 3.3% | 549.64 ± 2.6% | 951.76 ± 2.4% | 410.60 ± 0.9% | 466.61 ± 2.1% | 983.92 ± 1.7% | 21765.40 ± 3.0% | 503.81 ± 1.7% | 0.92 | 1.00 | 1.23 | 1.08 |
| class: two capitalized words | 23 | 402.46 ± 10.9% | 431.42 ± 0.7% | 651.65 ± 5.3% | 95.85 ± 5.8% | 440.19 ± 1.8% | 922.28 ± 10.9% | 6293.11 ± 0.6% | 402.79 ± 6.6% | 0.93 | 1.00 | 4.20 | 0.91 |
| class: a word that ends in ing | 9 | 484.97 ± 0.8% | 540.64 ± 1.0% | 1018.74 ± 0.5% | 114.90 ± 0.1% | 609.46 ± 0.7% | 1389.35 ± 0.9% | 15239.86 ± 0.7% | 484.29 ± 1.0% | 0.90 | 1.00 | 4.22 | 0.80 |
| class: a word in capitals | 16 | 417.06 ± 0.5% | 447.86 ± 0.6% | 773.63 ± 0.4% | 120.58 ± 2.6% | 636.92 ± 2.5% | 1215.20 ± 2.2% | 8290.83 ± 0.7% | 417.65 ± 0.2% | 0.93 | 1.00 | 3.46 | 0.65 |
| class: a number | 6 | 518.19 ± 1.8% | 565.06 ± 1.7% | 1163.68 ± 1.1% | 36.29 ± 2.6% | 1163.75 ± 2.8% | 2321.39 ± 2.8% | 20706.35 ± 0.5% | 517.22 ± 1.2% | 0.92 | 1.00 | 14.28 | 0.45 |
| class: two capitalized words, second text | 23 | 402.65 ± 0.5% | 429.90 ± 1.1% | 652.33 ± 3.3% | 95.82 ± 1.4% | 445.95 ± 2.5% | 905.73 ± 1.0% | 6292.87 ± 0.3% | 402.02 ± 1.0% | 0.94 | 1.00 | 4.20 | 0.90 |
| other: a word between two words | 13 | 481.59 ± 1.6% | 499.24 ± 1.4% | 824.29 ± 0.7% | 123.41 ± 1.3% | 426.32 ± 2.1% | 1007.50 ± 2.1% | 14077.28 ± 0.9% | 483.96 ± 0.7% | 0.96 | 1.00 | 3.90 | 1.13 |
| other: a number before a unit, second text | 15 | 349.74 ± 14.8% | 387.78 ± 1.0% | 554.86 ± 1.7% | 33.67 ± 1.3% | 526.43 ± 1.6% | 1107.56 ± 0.9% | 12551.22 ± 10.5% | 350.59 ± 0.3% | 0.90 | 1.00 | 10.39 | 0.66 |
| other: a heading's start tag | 13 | 324.16 ± 0.9% | 329.11 ± 2.1% | 452.93 ± 0.9% | 34.13 ± 1.2% | 503.39 ± 11.2% | 1075.25 ± 13.6% | 14932.95 ± 1.7% | 323.47 ± 2.4% | 0.98 | 1.00 | 9.50 | 0.64 |
| other: a whole word | 11 | 488.23 ± 3.1% | 514.04 ± 3.0% | 873.77 ± 3.2% | 110.08 ± 3.9% | 482.24 ± 6.1% | 1058.64 ± 2.0% | 22015.60 ± 3.3% | 488.24 ± 2.8% | 0.95 | 1.00 | 4.44 | 1.01 |
| other: a line's first word, second text | 17 | 465.38 ± 1.5% | 483.61 ± 0.3% | 837.43 ± 10.9% | 114.10 ± 0.5% | 575.00 ± 16.8% | refused | refused | 463.90 ± 0.8% | 0.96 | 1.00 | 4.08 | 0.81 |
| other: fourteen octets before an x | 16 | 85.43 ± 1.5% | 122.08 ± 1.2% | 143.45 ± 1.2% | 14.16 ± 1.3% | 383.76 ± 1.4% | 454.29 ± 1.5% | 11434.98 ± 3.1% | 85.32 ± 0.7% | 0.70 | 1.00 | 6.03 | 0.22 |
| other: a Greek word | 8 | 352.22 ± 1.2% | 485.88 ± 0.4% | 858.43 ± 1.7% | 45.44 ± 1.2% | 1144.49 ± 1.9% | 2254.57 ± 0.8% | refused | 351.66 ± 0.6% | 0.72 | 1.00 | 7.75 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21951.57 ± 1.3% | not timed | not timed | 26603.60 ± 16.6% | 1926.46 ± 11.9% | not timed | not timed | 21883.69 ± 23.7% | | 1.00 | 0.83 | 11.39 |
| 01-literal/sherlock-casei-en | 522 | 6230.45 ± 4.1% | not timed | not timed | 6984.96 ± 0.3% | 27.20 ± 12.6% | not timed | not timed | 6131.36 ± 5.3% | | 1.02 | 0.89 | 229.03 |
| 01-literal/sherlock-ru | 724 | 23490.62 ± 2.5% | not timed | not timed | 27284.04 ± 0.9% | 1044.07 ± 14.8% | not timed | not timed | 23432.87 ± 1.0% | | 1.00 | 0.86 | 22.50 |
| 01-literal/sherlock-casei-ru | 746 | 7150.12 ± 3.0% | not timed | not timed | 5514.06 ± 6.4% | 29.30 ± 3.2% | not timed | not timed | 7158.51 ± 1.7% | | 1.00 | 1.30 | 244.03 |
| 01-literal/sherlock-zh | 30 | 42201.22 ± 12.3% | not timed | not timed | 36082.64 ± 1.0% | 1260.88 ± 1.6% | not timed | not timed | 42514.52 ± 0.9% | | 0.99 | 1.17 | 33.47 |
| 02-literal-alternate/sherlock-en | 714 | 9633.52 ± 0.9% | not timed | not timed | 8858.01 ± 0.7% | 13.92 ± 6.0% | not timed | not timed | 9632.43 ± 0.5% | | 1.00 | 1.09 | 692.10 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1827.00 ± 0.9% | not timed | not timed | 1817.06 ± 0.5% | 9.44 ± 4.6% | not timed | not timed | 1808.06 ± 0.2% | | 1.01 | 1.01 | 193.56 |
| 02-literal-alternate/sherlock-ru | 899 | 5811.09 ± 1.7% | not timed | not timed | 4245.72 ± 1.0% | 18.49 ± 5.2% | not timed | not timed | 5844.41 ± 0.9% | | 0.99 | 1.37 | 314.29 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1879.24 ± 0.7% | not timed | not timed | 1045.30 ± 0.5% | 8.46 ± 8.6% | not timed | not timed | 1873.54 ± 0.3% | | 1.00 | 1.80 | 222.05 |
| 02-literal-alternate/sherlock-zh | 207 | 14010.58 ± 1.0% | not timed | not timed | 10404.38 ± 0.3% | 26.98 ± 15.6% | not timed | not timed | 14006.18 ± 0.6% | | 1.00 | 1.35 | 519.33 |
| 03-date/ascii | 111817 | 98.39 ± 4.4% | not timed | not timed | 84.32 ± 0.7% | 0.18 ± 1.8% | not timed | not timed | 99.29 ± 3.5% | | 0.99 | 1.17 | 552.84 |
| 04-ruff-noqa/real | 84 | 566.07 ± 2.8% | not timed | not timed | 435.37 ± 0.3% | 14.33 ± 1.3% | not timed | not timed | 558.32 ± 10.8% | | 1.01 | 1.30 | 39.50 |
| 04-ruff-noqa/tweaked | 44 | 482.41 ± 15.4% | not timed | not timed | 433.56 ± 11.3% | 293.31 ± 11.6% | not timed | not timed | 481.67 ± 1.5% | | 1.00 | 1.11 | 1.64 |
| 05-lexer-veryl/single | 124800 | 2.97 ± 21.3% | not timed | not timed | 4.19 ± 0.7% | 0.21 ± 2.9% | not timed | not timed | 3.01 ± 5.0% | | 0.99 | 0.71 | 14.31 |
| 06-cloud-flare-redos/original | 107 | 221.56 ± 1.3% | not timed | not timed | 179.07 ± 2.9% | 20.20 ± 1.3% | not timed | not timed | 221.92 ± 1.0% | | 1.00 | 1.24 | 10.97 |
| 06-cloud-flare-redos/simplified-short | 102 | 213.33 ± 1.1% | not timed | not timed | 186.59 ± 3.5% | 21.50 ± 0.9% | not timed | not timed | 213.01 ± 1.0% | | 1.00 | 1.14 | 9.92 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.02 ± 1.5% | not timed | not timed | 194.07 ± 4.4% | 23.93 ± 0.6% | not timed | not timed | 245.64 ± 0.9% | | 1.00 | 1.27 | 10.28 |
| 07-unicode-character-data/parse-line | 558784 | 186.47 ± 3.3% | not timed | not timed | 160.60 ± 0.4% | 36.30 ± 6.9% | not timed | not timed | 183.63 ± 6.6% | | 1.02 | 1.16 | 5.14 |
| 08-words/all-english | 56691 | 89.75 ± 1.5% | not timed | not timed | 74.00 ± 1.7% | 9.83 ± 27.7% | not timed | not timed | 92.49 ± 2.0% | | 0.97 | 1.21 | 9.13 |
| 08-words/long-english | 839 | 857.79 ± 0.2% | not timed | not timed | 513.35 ± 0.3% | 25.88 ± 3.5% | not timed | not timed | 856.02 ± 2.9% | | 1.00 | 1.67 | 33.14 |
| 09-aws-keys/full | 0 | 426.09 ± 9.1% | not timed | not timed | 447.59 ± 0.7% | 53.93 ± 5.5% | not timed | not timed | 426.53 ± 1.0% | | 1.00 | 0.95 | 7.90 |
| 09-aws-keys/quick | 0 | 822.72 ± 0.3% | not timed | not timed | 774.25 ± 5.7% | 331.23 ± 5.6% | not timed | not timed | 811.42 ± 0.6% | | 1.01 | 1.06 | 2.48 |
| 10-bounded-repeat/letters-en | 1833 | 502.39 ± 0.2% | not timed | not timed | 429.55 ± 0.8% | 15.68 ± 3.3% | not timed | not timed | 502.00 ± 0.2% | | 1.00 | 1.17 | 32.04 |
| 10-bounded-repeat/letters-ru | 3475 | 316.76 ± 1.1% | not timed | not timed | 403.77 ± 0.6% | 18.38 ± 11.6% | not timed | not timed | 315.78 ± 2.1% | | 1.00 | 0.78 | 17.23 |
| 10-bounded-repeat/context | 53 | 63.63 ± 0.7% | not timed | not timed | 55.49 ± 2.2% | 15.84 ± 3.3% | not timed | not timed | 63.68 ± 1.2% | | 1.00 | 1.15 | 4.02 |
| 10-bounded-repeat/capitals | 11 | 898.68 ± 0.4% | not timed | not timed | 531.67 ± 0.4% | 29.47 ± 6.6% | not timed | not timed | 897.54 ± 0.8% | | 1.00 | 1.69 | 30.50 |
| 11-unstructured-to-json/extract | 600 | 36.93 ± 0.2% | not timed | not timed | 62.16 ± 1.6% | 40.83 ± 1.1% | not timed | not timed | 36.81 ± 1.3% | | 1.00 | 0.59 | 0.90 |
| 12-dictionary/single | 1 | 461.41 ± 0.4% | not timed | not timed | 439.36 ± 0.8% | 0.31 ± 3.1% | not timed | not timed | 464.20 ± 0.4% | | 0.99 | 1.05 | 1484.24 |
| 14-quadratic/1x | 100 | 9.93 ± 1.2% | not timed | not timed | 9.00 ± 1.0% | 0.79 ± 6.3% | not timed | not timed | 10.08 ± 1.3% | | 0.99 | 1.10 | 12.54 |
| 14-quadratic/2x | 200 | 6.39 ± 1.1% | not timed | not timed | 4.89 ± 2.9% | 0.43 ± 1.9% | not timed | not timed | 6.42 ± 1.4% | | 1.00 | 1.31 | 14.94 |
| 14-quadratic/10x | 1000 | 1.57 ± 0.6% | not timed | not timed | 1.05 ± 1.0% | 0.09 ± 1.0% | not timed | not timed | 1.57 ± 0.7% | | 1.00 | 1.49 | 16.94 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.32 ± 9.3% | not timed | not timed | 0.39 ± 0.6% | 0.48 ± 4.5% | not timed | not timed | 1.32 ± 1.3% | | 1.00 | 3.42 | 2.74 |
| 04-ruff-noqa/compile-real | 1 | 80.42 ± 14.4% | not timed | not timed | 12.82 ± 0.7% | 122.46 ± 5.6% | not timed | not timed | 79.96 ± 1.9% | | 1.01 | 6.27 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 12.62 ± 1.8% | not timed | not timed | 2.37 ± 2.0% | 5.79 ± 3.0% | not timed | not timed | 12.54 ± 26.0% | | 1.01 | 5.32 | 2.18 |
| 07-unicode-character-data/compile | 1 | 51.09 ± 0.4% | not timed | not timed | 24.29 ± 1.1% | 32.40 ± 2.2% | not timed | not timed | 51.03 ± 0.2% | | 1.00 | 2.10 | 1.58 |
| 09-aws-keys/compile-full | 1 | 34.76 ± 0.4% | not timed | not timed | 7.33 ± 0.9% | 19.92 ± 4.8% | not timed | not timed | 34.21 ± 2.1% | | 1.02 | 4.74 | 1.75 |
| 09-aws-keys/compile-quick | 1 | 153.07 ± 0.9% | not timed | not timed | 44.77 ± 2.5% | 114.37 ± 1.7% | not timed | not timed | 152.53 ± 2.6% | | 1.00 | 3.42 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 10.47 ± 1.8% | not timed | not timed | 11.77 ± 0.7% | 14.76 ± 1.0% | not timed | not timed | 10.41 ± 1.2% | | 1.01 | 0.89 | 0.71 |
| 10-bounded-repeat/compile-capitals | 1 | 72.42 ± 1.9% | not timed | not timed | 8.91 ± 1.1% | 22.29 ± 2.5% | not timed | not timed | 71.49 ± 1.6% | | 1.01 | 8.13 | 3.25 |
| 11-unstructured-to-json/compile | 1 | 77.65 ± 1.2% | not timed | not timed | 36.62 ± 0.9% | 59.98 ± 4.3% | not timed | not timed | 77.10 ± 2.1% | | 1.01 | 2.12 | 1.29 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.3% | not timed | not timed | 0.07 ± 2.3% | 0.09 ± 11.4% | not timed | not timed | 0.29 ± 18.2% | | 1.01 | 4.25 | 3.28 |

