# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102087012 |
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
| literal: a word | 217 | 31578.61 ± 7.0% | 893.24 ± 0.4% | 19.82 ± 2.5% | 31061.17 ± 1.4% | 9099.14 ± 8.4% | 10.76 ± 0.7% | 76.36 ± 0.9% | 31056.99 ± 1.9% | 35.35 | 1.02 | 1.02 | 3.47 |
| literal: a word that is not there | 0 | 43394.90 ± 3.3% | 906.08 ± 0.3% | 20.33 ± 3.2% | 39435.82 ± 4.5% | 29550.89 ± 0.9% | 10.73 ± 0.2% | 72.46 ± 1.2% | 42649.71 ± 2.9% | 47.89 | 1.02 | 1.10 | 1.47 |
| literal: one of four words | 661 | 11367.68 ± 1.1% | 868.28 ± 0.1% | 11.12 ± 2.0% | 9084.16 ± 1.5% | 19.23 ± 1.5% | 3.96 ± 0.6% | 6.69 ± 0.4% | 11326.62 ± 8.3% | 13.09 | 1.00 | 1.25 | 591.25 |
| literal: a word in any case | 217 | 25532.73 ± 2.5% | 893.67 ± 1.0% | 15.30 ± 2.7% | 9199.37 ± 17.4% | 37.21 ± 4.3% | refused | differs | 25418.17 ± 1.1% | 28.57 | 1.00 | 2.78 | 686.19 |
| literal: an href attribute | 33 | 26095.97 ± 1.1% | 901.06 ± 0.4% | 18.93 ± 1.0% | 27419.00 ± 0.6% | 2050.53 ± 0.9% | 8.26 ± 0.2% | 61.09 ± 0.9% | 25977.00 ± 1.1% | 28.96 | 1.00 | 0.95 | 12.73 |
| literal: a word, second text | 123 | 32031.74 ± 2.9% | 899.04 ± 0.1% | 19.74 ± 3.1% | 31726.41 ± 1.1% | 7167.81 ± 5.8% | 11.65 ± 0.8% | 62.45 ± 7.2% | 32020.75 ± 2.2% | 35.63 | 1.00 | 1.01 | 4.47 |
| class: two capitalized words | 1331 | 767.64 ± 0.5% | 812.99 ± 0.6% | 18.63 ± 4.5% | 505.57 ± 0.1% | 32.81 ± 5.6% | 9.39 ± 0.4% | 55.23 ± 2.1% | 765.40 ± 0.4% | 0.94 | 1.00 | 1.52 | 23.40 |
| class: a word that ends in ing | 3399 | 733.89 ± 0.7% | 734.20 ± 0.6% | 13.12 ± 1.6% | 470.27 ± 0.3% | 25.47 ± 22.6% | 5.33 ± 0.2% | 17.05 ± 2.8% | 733.40 ± 0.9% | 1.00 | 1.00 | 1.56 | 28.82 |
| class: a word in capitals | 2332 | 983.96 ± 0.9% | 796.74 ± 0.3% | 20.01 ± 4.6% | 496.80 ± 0.6% | 34.88 ± 10.4% | 10.47 ± 0.3% | 75.10 ± 3.2% | 983.48 ± 0.5% | 1.23 | 1.00 | 1.98 | 28.21 |
| class: a number | 8288 | 1459.44 ± 3.7% | 645.94 ± 0.8% | 19.79 ± 6.1% | 1481.52 ± 4.8% | 33.79 ± 18.8% | 0.34 ± 1.1% | 55.25 ± 1.8% | 1464.01 ± 0.4% | 2.26 | 1.00 | 0.99 | 43.19 |
| class: two capitalized words, second text | 5359 | 569.55 ± 0.8% | 576.08 ± 0.3% | 17.44 ± 1.3% | 408.79 ± 1.4% | 29.54 ± 14.0% | 10.61 ± 0.2% | 51.41 ± 1.1% | 575.41 ± 3.2% | 0.99 | 0.99 | 1.39 | 19.28 |
| other: a word between two words | 6104 | 648.34 ± 0.6% | 615.97 ± 1.0% | 17.11 ± 6.9% | 692.56 ± 0.3% | 99.77 ± 9.2% | 7.26 ± 0.2% | 56.37 ± 11.1% | 651.82 ± 0.3% | 1.05 | 0.99 | 0.94 | 6.50 |
| other: a number before a unit, second text | 1481 | 6706.33 ± 1.2% | 825.39 ± 0.4% | 18.56 ± 9.7% | 6348.04 ± 0.7% | 34.53 ± 13.5% | 11.04 ± 0.4% | 54.74 ± 1.0% | 6747.08 ± 4.0% | 8.12 | 0.99 | 1.06 | 194.20 |
| other: a heading's start tag | 110 | 18385.94 ± 2.7% | 892.82 ± 0.3% | 19.23 ± 3.0% | 2002.86 ± 0.6% | 1413.27 ± 5.7% | 10.06 ± 0.4% | 72.53 ± 0.6% | 17639.74 ± 1.3% | 20.59 | 1.04 | 9.18 | 13.01 |
| other: a whole word | 217 | 22011.32 ± 8.3% | 892.83 ± 0.1% | 19.93 ± 3.8% | 22380.83 ± 1.1% | 41.17 ± 7.8% | 9.55 ± 0.4% | 46.90 ± 0.7% | 20933.67 ± 0.5% | 24.65 | 1.05 | 0.98 | 534.58 |
| other: a line's first word, second text | 3716 | 1752.09 ± 5.8% | 716.44 ± 0.6% | 22.25 ± 1.1% | 1715.40 ± 2.8% | 52.01 ± 6.3% | refused | refused | 1752.51 ± 0.7% | 2.45 | 1.00 | 1.02 | 33.69 |
| other: fourteen octets before an x | 87 | 25405.22 ± 5.1% | 195.97 ± 0.4% | 4.33 ± 2.7% | 2850.24 ± 1.7% | 8.91 ± 2.7% | differs | 15.29 ± 2.0% | 24542.48 ± 7.7% | 129.64 | 1.04 | 8.91 | 2851.80 |
| other: a Greek word | 21815 | 383.84 ± 0.4% | 262.06 ± 2.1% | 23.77 ± 1.2% | 257.43 ± 0.7% | 38.39 ± 6.5% | differs | refused | 384.16 ± 0.4% | 1.46 | 1.00 | 1.49 | 10.00 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.57 ± 3.7% | 25.16 ± 3.0% | 0.73 ± 1.8% | 16.79 ± 0.5% | 1.65 ± 2.0% | differs | 3.60 ± 1.3% | 24.88 ± 0.8% | 0.98 | 0.99 | 1.46 | 14.85 |
| a UUID | 32895 | 20.71 ± 1.1% | 20.72 ± 0.6% | 0.56 ± 2.3% | 12.81 ± 0.2% | 2.53 ± 0.6% | 0.43 ± 0.4% | 3.07 ± 1.9% | 20.67 ± 0.5% | 1.00 | 1.00 | 1.62 | 8.19 |
| an IPv4 address | 33176 | 35.58 ± 0.6% | 35.50 ± 1.4% | 1.82 ± 2.6% | 23.80 ± 0.4% | 5.25 ± 0.7% | differs | 3.42 ± 0.7% | 35.25 ± 1.4% | 1.00 | 1.01 | 1.49 | 6.77 |
| a date and time | 32954 | 30.96 ± 1.6% | 30.92 ± 0.5% | 1.27 ± 2.2% | 17.97 ± 0.9% | 6.48 ± 2.5% | 0.75 ± 0.1% | 6.17 ± 0.4% | 30.92 ± 0.3% | 1.00 | 1.00 | 1.72 | 4.78 |
| a field path | 32606 | 28.01 ± 2.3% | 27.93 ± 1.8% | 0.85 ± 1.7% | 19.37 ± 0.2% | 2.90 ± 2.4% | differs | 2.42 ± 2.9% | 27.67 ± 3.3% | 1.00 | 1.01 | 1.45 | 9.67 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.61 ± 2.5% | 7.62 ± 2.1% | 7.58 ± 18.1% | 10.45 ± 0.4% | 4.71 ± 2.1% | 0.62 ± 0.2% | none | 7.48 ± 1.3% | 1.00 | 1.02 | 0.73 | 1.62 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 190.18 ± 1.3% | 191.23 ± 1.1% | 224.44 ± 1.1% | 79.48 ± 3.1% | 182.26 ± 4.0% | 527.97 ± 2.5% | 3933.10 ± 4.2% | 189.71 ± 0.8% | 0.99 | 1.00 | 2.39 | 1.04 |
| a UUID | 62 | 123.82 ± 2.4% | 124.26 ± 1.4% | 139.47 ± 0.4% | 46.52 ± 1.8% | 88.08 ± 18.7% | 195.65 ± 2.5% | 3907.40 ± 6.3% | 122.42 ± 2.1% | 1.00 | 1.01 | 2.66 | 1.41 |
| an IPv4 address | 29 | 374.36 ± 4.4% | 378.66 ± 2.5% | 551.39 ± 4.2% | 69.33 ± 3.6% | 113.02 ± 8.0% | 312.85 ± 3.8% | 6963.46 ± 4.5% | 379.09 ± 2.4% | 0.99 | 0.99 | 5.40 | 3.31 |
| a date and time | 56 | 278.20 ± 0.7% | 280.02 ± 0.8% | 360.28 ± 0.4% | 67.44 ± 3.0% | 122.72 ± 2.5% | 357.82 ± 3.2% | 4045.63 ± 5.5% | 278.11 ± 0.6% | 0.99 | 1.00 | 4.13 | 2.27 |
| a field path | 39 | 185.55 ± 5.4% | 187.14 ± 1.0% | 220.26 ± 2.0% | 73.35 ± 4.1% | 171.20 ± 1.7% | 586.31 ± 6.6% | 4647.28 ± 1.5% | 186.23 ± 0.8% | 0.99 | 1.00 | 2.53 | 1.08 |
| literal: a word | 7 | 555.88 ± 2.3% | 595.61 ± 0.7% | 1112.40 ± 1.0% | 495.52 ± 12.7% | 567.09 ± 3.6% | 1113.27 ± 1.7% | 24538.81 ± 1.3% | 557.41 ± 0.7% | 0.93 | 1.00 | 1.12 | 0.98 |
| literal: a word that is not there | 8 | 539.00 ± 1.0% | 577.65 ± 0.9% | 1038.61 ± 16.2% | 454.82 ± 10.8% | 547.78 ± 5.2% | 1085.05 ± 0.7% | 23407.71 ± 2.0% | 534.97 ± 0.9% | 0.93 | 1.01 | 1.19 | 0.98 |
| literal: one of four words | 26 | 211.08 ± 1.2% | 354.44 ± 0.7% | 489.21 ± 10.5% | 40.85 ± 1.6% | 218.33 ± 0.7% | 443.97 ± 2.8% | 11496.36 ± 1.7% | 211.67 ± 0.8% | 0.60 | 1.00 | 5.17 | 0.97 |
| literal: a word in any case | 11 | 440.13 ± 8.2% | 468.24 ± 0.5% | 742.60 ± 1.8% | 14.29 ± 7.3% | 604.80 ± 1.4% | refused | 19476.67 ± 3.4% | 438.09 ± 0.8% | 0.94 | 1.00 | 30.79 | 0.73 |
| literal: an href attribute | 12 | 312.80 ± 2.4% | 320.03 ± 2.0% | 439.07 ± 9.5% | 36.65 ± 12.6% | 424.19 ± 2.4% | 930.60 ± 1.3% | 18675.33 ± 3.9% | 312.81 ± 1.2% | 0.98 | 1.00 | 8.54 | 0.74 |
| literal: a word, second text | 10 | 496.54 ± 1.4% | 540.44 ± 2.4% | 933.19 ± 11.5% | 415.56 ± 0.7% | 484.35 ± 2.7% | 975.48 ± 0.7% | 20975.26 ± 2.1% | 496.54 ± 0.6% | 0.92 | 1.00 | 1.19 | 1.03 |
| class: two capitalized words | 23 | 405.16 ± 7.8% | 433.50 ± 0.8% | 656.23 ± 2.9% | 95.48 ± 6.6% | 441.29 ± 2.9% | 941.18 ± 4.2% | 6306.72 ± 6.6% | 405.50 ± 0.3% | 0.93 | 1.00 | 4.24 | 0.92 |
| class: a word that ends in ing | 9 | 488.40 ± 0.9% | 546.86 ± 0.8% | 1024.93 ± 1.2% | 114.37 ± 1.5% | 614.04 ± 2.1% | 1414.94 ± 0.4% | 15182.14 ± 1.7% | 488.62 ± 0.5% | 0.89 | 1.00 | 4.27 | 0.80 |
| class: a word in capitals | 16 | 422.51 ± 8.3% | 454.38 ± 1.1% | 788.47 ± 0.2% | 121.34 ± 0.9% | 637.41 ± 1.5% | 1293.90 ± 2.1% | 8345.61 ± 0.5% | 422.21 ± 5.2% | 0.93 | 1.00 | 3.48 | 0.66 |
| class: a number | 6 | 527.98 ± 10.5% | 578.69 ± 1.0% | 1170.40 ± 1.0% | 36.27 ± 1.6% | 1155.27 ± 0.8% | 2249.37 ± 3.2% | 20164.42 ± 6.5% | 526.17 ± 0.9% | 0.91 | 1.00 | 14.56 | 0.46 |
| class: two capitalized words, second text | 23 | 405.66 ± 2.3% | 434.17 ± 0.9% | 657.34 ± 7.8% | 93.48 ± 0.7% | 437.90 ± 1.6% | 923.56 ± 1.9% | 6368.55 ± 1.0% | 405.28 ± 8.2% | 0.93 | 1.00 | 4.34 | 0.93 |
| other: a word between two words | 13 | 485.85 ± 0.9% | 502.11 ± 0.4% | 828.02 ± 1.2% | 120.18 ± 2.0% | 430.85 ± 2.2% | 962.61 ± 3.1% | 13819.05 ± 2.9% | 483.08 ± 7.4% | 0.97 | 1.01 | 4.04 | 1.13 |
| other: a number before a unit, second text | 15 | 354.55 ± 2.2% | 389.06 ± 7.7% | 563.31 ± 0.6% | 33.91 ± 1.1% | 527.13 ± 2.4% | 1069.25 ± 1.5% | 13911.78 ± 2.2% | 354.13 ± 6.0% | 0.91 | 1.00 | 10.46 | 0.67 |
| other: a heading's start tag | 13 | 328.63 ± 0.6% | 334.66 ± 1.3% | 457.68 ± 0.7% | 34.91 ± 2.9% | 509.05 ± 2.2% | 1045.97 ± 1.5% | 16185.06 ± 1.3% | 327.63 ± 0.6% | 0.98 | 1.00 | 9.41 | 0.65 |
| other: a whole word | 11 | 496.91 ± 0.9% | 527.57 ± 16.4% | 882.63 ± 3.1% | 109.38 ± 2.8% | 496.76 ± 3.8% | 994.23 ± 0.5% | 21243.61 ± 1.9% | 497.96 ± 0.6% | 0.94 | 1.00 | 4.54 | 1.00 |
| other: a line's first word, second text | 17 | 470.39 ± 0.6% | 494.78 ± 1.0% | 850.75 ± 0.5% | 113.28 ± 0.7% | 572.73 ± 2.1% | refused | refused | 469.72 ± 1.0% | 0.95 | 1.00 | 4.15 | 0.82 |
| other: fourteen octets before an x | 16 | 87.18 ± 0.9% | 123.35 ± 2.2% | 144.68 ± 0.3% | 13.88 ± 3.3% | 382.15 ± 2.3% | 456.97 ± 1.3% | 11728.38 ± 0.7% | 87.28 ± 2.4% | 0.71 | 1.00 | 6.28 | 0.23 |
| other: a Greek word | 8 | 357.41 ± 1.8% | 500.58 ± 1.1% | 862.22 ± 0.9% | 45.62 ± 0.5% | 1129.71 ± 2.8% | 2129.76 ± 0.4% | refused | 358.97 ± 0.6% | 0.71 | 1.00 | 7.83 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20267.86 ± 3.4% | not timed | not timed | 27092.06 ± 1.0% | 1939.01 ± 28.3% | not timed | not timed | 20339.77 ± 1.3% | | 1.00 | 0.75 | 10.45 |
| 01-literal/sherlock-casei-en | 522 | 4486.06 ± 2.1% | not timed | not timed | 6885.84 ± 9.4% | 27.66 ± 3.5% | not timed | not timed | 4502.79 ± 2.0% | | 1.00 | 0.65 | 162.16 |
| 01-literal/sherlock-ru | 724 | 22002.86 ± 2.8% | not timed | not timed | 28035.32 ± 0.5% | 1064.26 ± 2.2% | not timed | not timed | 22141.67 ± 1.3% | | 0.99 | 0.78 | 20.67 |
| 01-literal/sherlock-casei-ru | 746 | 7346.69 ± 1.1% | not timed | not timed | 5547.59 ± 0.4% | 30.27 ± 10.0% | not timed | not timed | 7356.97 ± 0.4% | | 1.00 | 1.32 | 242.67 |
| 01-literal/sherlock-zh | 30 | 38921.63 ± 2.0% | not timed | not timed | 36914.87 ± 0.3% | 1262.20 ± 0.5% | not timed | not timed | 38658.07 ± 0.9% | | 1.01 | 1.05 | 30.84 |
| 02-literal-alternate/sherlock-en | 714 | 9907.34 ± 0.2% | not timed | not timed | 8872.43 ± 0.3% | 14.71 ± 5.4% | not timed | not timed | 9896.26 ± 18.4% | | 1.00 | 1.12 | 673.29 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1739.51 ± 9.1% | not timed | not timed | 1811.98 ± 0.2% | 9.51 ± 1.3% | not timed | not timed | 1719.17 ± 4.5% | | 1.01 | 0.96 | 182.91 |
| 02-literal-alternate/sherlock-ru | 899 | 6010.54 ± 1.0% | not timed | not timed | 4249.58 ± 0.8% | 19.59 ± 0.9% | not timed | not timed | 6002.63 ± 0.4% | | 1.00 | 1.41 | 306.83 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1814.85 ± 0.5% | not timed | not timed | 1046.04 ± 0.1% | 8.53 ± 6.7% | not timed | not timed | 1811.76 ± 0.3% | | 1.00 | 1.73 | 212.73 |
| 02-literal-alternate/sherlock-zh | 207 | 13975.71 ± 0.6% | not timed | not timed | 10423.75 ± 0.3% | 27.11 ± 15.7% | not timed | not timed | 13976.76 ± 0.8% | | 1.00 | 1.34 | 515.57 |
| 03-date/ascii | 111817 | 105.88 ± 1.8% | not timed | not timed | 84.55 ± 0.9% | 0.18 ± 3.5% | not timed | not timed | 107.28 ± 1.5% | | 0.99 | 1.25 | 602.59 |
| 04-ruff-noqa/real | 84 | 558.93 ± 0.7% | not timed | not timed | 429.57 ± 0.3% | 15.57 ± 2.8% | not timed | not timed | 555.45 ± 2.0% | | 1.01 | 1.30 | 35.91 |
| 04-ruff-noqa/tweaked | 44 | 489.49 ± 0.3% | not timed | not timed | 430.15 ± 10.3% | 286.96 ± 10.5% | not timed | not timed | 488.41 ± 0.3% | | 1.00 | 1.14 | 1.71 |
| 05-lexer-veryl/single | 124800 | 2.92 ± 1.1% | not timed | not timed | 4.14 ± 1.4% | 0.21 ± 1.3% | not timed | not timed | 2.92 ± 0.5% | | 1.00 | 0.71 | 13.65 |
| 06-cloud-flare-redos/original | 107 | 170.66 ± 1.5% | not timed | not timed | 186.51 ± 1.5% | 12.88 ± 0.7% | not timed | not timed | 169.69 ± 25.3% | | 1.01 | 0.92 | 13.25 |
| 06-cloud-flare-redos/simplified-short | 102 | 126.78 ± 4.1% | not timed | not timed | 192.76 ± 0.3% | 13.50 ± 1.1% | not timed | not timed | 125.01 ± 1.8% | | 1.01 | 0.66 | 9.39 |
| 06-cloud-flare-redos/simplified-long | 10000 | 129.67 ± 2.6% | not timed | not timed | 204.44 ± 2.2% | 14.64 ± 1.9% | not timed | not timed | 133.06 ± 4.1% | | 0.97 | 0.63 | 8.86 |
| 07-unicode-character-data/parse-line | 558784 | 36.01 ± 1.3% | not timed | not timed | 161.26 ± 2.1% | 36.70 ± 3.1% | not timed | not timed | 35.66 ± 2.4% | | 1.01 | 0.22 | 0.98 |
| 08-words/all-english | 56691 | 73.57 ± 2.4% | not timed | not timed | 73.91 ± 0.4% | 10.31 ± 10.7% | not timed | not timed | 73.24 ± 0.2% | | 1.00 | 1.00 | 7.14 |
| 08-words/long-english | 839 | 848.53 ± 1.8% | not timed | not timed | 512.19 ± 1.5% | 25.81 ± 4.5% | not timed | not timed | 834.41 ± 1.9% | | 1.02 | 1.66 | 32.87 |
| 09-aws-keys/full | 0 | 426.80 ± 3.6% | not timed | not timed | 448.43 ± 0.3% | 54.29 ± 4.8% | not timed | not timed | 429.96 ± 0.4% | | 0.99 | 0.95 | 7.86 |
| 09-aws-keys/quick | 0 | 443.46 ± 14.0% | not timed | not timed | 798.81 ± 9.2% | 295.76 ± 6.7% | not timed | not timed | 442.65 ± 0.5% | | 1.00 | 0.56 | 1.50 |
| 10-bounded-repeat/letters-en | 1833 | 470.22 ± 5.2% | not timed | not timed | 429.81 ± 0.3% | 16.67 ± 2.0% | not timed | not timed | 469.78 ± 5.0% | | 1.00 | 1.09 | 28.21 |
| 10-bounded-repeat/letters-ru | 3475 | 323.03 ± 3.3% | not timed | not timed | 407.11 ± 0.5% | 17.84 ± 13.2% | not timed | not timed | 321.16 ± 3.5% | | 1.01 | 0.79 | 18.11 |
| 10-bounded-repeat/context | 53 | 58.34 ± 2.1% | not timed | not timed | 55.49 ± 1.2% | 16.87 ± 2.3% | not timed | not timed | 58.21 ± 0.9% | | 1.00 | 1.05 | 3.46 |
| 10-bounded-repeat/capitals | 11 | 892.72 ± 0.5% | not timed | not timed | 531.95 ± 0.4% | 30.49 ± 2.5% | not timed | not timed | 892.07 ± 0.3% | | 1.00 | 1.68 | 29.28 |
| 11-unstructured-to-json/extract | 600 | 20.61 ± 0.4% | not timed | not timed | 62.20 ± 0.9% | 22.86 ± 2.0% | not timed | not timed | 20.57 ± 1.4% | | 1.00 | 0.33 | 0.90 |
| 12-dictionary/single | 1 | 458.47 ± 0.4% | not timed | not timed | 438.22 ± 0.5% | 0.30 ± 4.8% | not timed | not timed | 460.97 ± 0.4% | | 0.99 | 1.05 | 1506.63 |
| 14-quadratic/1x | 100 | 10.93 ± 0.7% | not timed | not timed | 8.98 ± 0.3% | 0.79 ± 2.0% | not timed | not timed | 10.87 ± 2.2% | | 1.01 | 1.22 | 13.87 |
| 14-quadratic/2x | 200 | 6.67 ± 1.3% | not timed | not timed | 4.89 ± 1.2% | 0.42 ± 0.9% | not timed | not timed | 6.76 ± 13.8% | | 0.99 | 1.36 | 15.80 |
| 14-quadratic/10x | 1000 | 1.56 ± 0.7% | not timed | not timed | 1.05 ± 0.8% | 0.09 ± 0.8% | not timed | not timed | 1.57 ± 1.0% | | 1.00 | 1.49 | 17.03 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.32 ± 0.2% | not timed | not timed | 0.39 ± 0.7% | 0.47 ± 17.5% | not timed | not timed | 1.31 ± 0.7% | | 1.01 | 3.43 | 2.84 |
| 04-ruff-noqa/compile-real | 1 | 79.51 ± 8.5% | not timed | not timed | 12.97 ± 4.2% | 120.72 ± 1.6% | not timed | not timed | 78.25 ± 3.0% | | 1.02 | 6.13 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 12.53 ± 6.1% | not timed | not timed | 2.35 ± 18.7% | 5.73 ± 5.6% | not timed | not timed | 12.44 ± 5.2% | | 1.01 | 5.32 | 2.19 |
| 07-unicode-character-data/compile | 1 | 51.21 ± 0.9% | not timed | not timed | 23.92 ± 0.8% | 32.01 ± 3.9% | not timed | not timed | 50.84 ± 0.6% | | 1.01 | 2.14 | 1.60 |
| 09-aws-keys/compile-full | 1 | 34.80 ± 0.4% | not timed | not timed | 7.31 ± 0.9% | 19.87 ± 3.7% | not timed | not timed | 34.74 ± 0.8% | | 1.00 | 4.76 | 1.75 |
| 09-aws-keys/compile-quick | 1 | 155.67 ± 0.9% | not timed | not timed | 44.30 ± 1.3% | 114.89 ± 4.0% | not timed | not timed | 153.36 ± 3.5% | | 1.02 | 3.51 | 1.35 |
| 10-bounded-repeat/compile-context | 1 | 10.48 ± 3.1% | not timed | not timed | 11.47 ± 5.0% | 14.83 ± 4.1% | not timed | not timed | 10.40 ± 3.9% | | 1.01 | 0.91 | 0.71 |
| 10-bounded-repeat/compile-capitals | 1 | 72.60 ± 1.3% | not timed | not timed | 8.72 ± 1.1% | 21.65 ± 2.6% | not timed | not timed | 71.50 ± 1.2% | | 1.02 | 8.33 | 3.35 |
| 11-unstructured-to-json/compile | 1 | 77.36 ± 0.8% | not timed | not timed | 36.78 ± 0.7% | 58.86 ± 19.8% | not timed | not timed | 76.32 ± 0.9% | | 1.01 | 2.10 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.29 ± 14.6% | not timed | not timed | 0.07 ± 4.4% | 0.08 ± 17.8% | not timed | not timed | 0.29 ± 0.9% | | 1.01 | 4.38 | 3.58 |

