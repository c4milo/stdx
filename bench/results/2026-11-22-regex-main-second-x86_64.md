# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45054920956 |
| Date | 2026-11-22 |
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
| literal: a word | 217 | 43415.60 ± 0.5% | 1028.56 ± 0.2% | 31.36 ± 0.6% | 40414.80 ± 1.8% | 12075.62 ± 2.6% | 12.93 ± 0.2% | 94.99 ± 0.5% | 43383.03 ± 0.5% | 42.21 | 1.00 | 1.07 | 3.60 |
| literal: a word that is not there | 0 | 60342.92 ± 2.5% | 1038.82 ± 0.3% | 31.22 ± 0.2% | 45579.70 ± 0.7% | 44041.65 ± 0.5% | 12.78 ± 0.5% | 98.54 ± 6.0% | 60420.66 ± 4.8% | 58.09 | 1.00 | 1.32 | 1.37 |
| literal: one of four words | 661 | 13247.31 ± 1.4% | 1006.79 ± 0.6% | 17.18 ± 0.2% | 11486.10 ± 0.2% | 24.23 ± 0.5% | 4.47 ± 0.1% | 7.94 ± 1.7% | 13264.69 ± 0.5% | 13.16 | 1.00 | 1.15 | 546.72 |
| literal: a word in any case | 217 | 37314.15 ± 0.4% | 1027.03 ± 0.1% | 24.54 ± 0.2% | 11365.95 ± 1.5% | 47.52 ± 0.5% | refused | differs | 37292.04 ± 0.2% | 36.33 | 1.00 | 3.28 | 785.20 |
| literal: an href attribute | 33 | 44664.06 ± 0.5% | 1034.39 ± 0.3% | 30.24 ± 0.5% | 35398.87 ± 1.7% | 3022.04 ± 3.8% | 9.70 ± 0.3% | 91.35 ± 0.4% | 44662.64 ± 0.4% | 43.18 | 1.00 | 1.26 | 14.78 |
| literal: a word, second text | 123 | 47471.84 ± 0.3% | 1030.36 ± 0.3% | 30.88 ± 0.6% | 40894.88 ± 0.7% | 11063.00 ± 7.1% | 14.50 ± 0.4% | 87.77 ± 0.4% | 47463.69 ± 0.4% | 46.07 | 1.00 | 1.16 | 4.29 |
| class: two capitalized words | 1331 | 912.58 ± 0.5% | 950.68 ± 0.3% | 29.18 ± 0.3% | 576.52 ± 0.2% | 44.84 ± 1.7% | 10.99 ± 0.2% | 80.31 ± 0.4% | 912.11 ± 0.3% | 0.96 | 1.00 | 1.58 | 20.35 |
| class: a word that ends in ing | 3399 | 874.82 ± 0.1% | 873.08 ± 0.4% | 20.87 ± 0.5% | 541.80 ± 0.5% | 33.02 ± 14.8% | 6.24 ± 0.2% | 20.14 ± 0.6% | 873.93 ± 0.6% | 1.00 | 1.00 | 1.61 | 26.49 |
| class: a word in capitals | 2332 | 1146.03 ± 0.2% | 926.03 ± 0.5% | 30.72 ± 0.4% | 564.40 ± 0.7% | 47.64 ± 9.7% | 12.43 ± 0.4% | 101.42 ± 0.2% | 1144.36 ± 1.7% | 1.24 | 1.00 | 2.03 | 24.06 |
| class: a number | 8288 | 1871.27 ± 1.0% | 792.45 ± 0.3% | 31.16 ± 2.7% | 1862.18 ± 0.7% | 48.74 ± 5.9% | 0.39 ± 0.2% | 73.71 ± 1.6% | 1869.08 ± 0.6% | 2.36 | 1.00 | 1.00 | 38.39 |
| class: two capitalized words, second text | 5359 | 689.25 ± 0.3% | 691.12 ± 0.2% | 26.47 ± 0.1% | 480.81 ± 0.2% | 38.90 ± 8.0% | 12.69 ± 0.2% | 74.65 ± 3.4% | 688.71 ± 0.6% | 1.00 | 1.00 | 1.43 | 17.72 |
| other: a word between two words | 6104 | 833.74 ± 0.4% | 739.89 ± 0.2% | 26.44 ± 0.3% | 837.66 ± 0.5% | 124.65 ± 15.0% | 8.57 ± 0.0% | 82.15 ± 0.2% | 832.75 ± 0.4% | 1.13 | 1.00 | 1.00 | 6.69 |
| other: a number before a unit, second text | 1481 | 10598.73 ± 4.8% | 977.87 ± 2.7% | 29.08 ± 0.3% | 9360.51 ± 0.7% | 45.78 ± 12.0% | 13.25 ± 0.6% | 77.82 ± 2.5% | 10567.82 ± 9.0% | 10.84 | 1.00 | 1.13 | 231.54 |
| other: a heading's start tag | 110 | 25654.31 ± 2.3% | 1025.28 ± 0.2% | 30.76 ± 0.2% | 2658.50 ± 8.9% | 2008.71 ± 3.8% | 11.88 ± 0.4% | 107.01 ± 0.2% | 25627.05 ± 2.3% | 25.02 | 1.00 | 9.65 | 12.77 |
| other: a whole word | 217 | 31048.42 ± 3.3% | 1026.62 ± 0.4% | 32.32 ± 1.6% | 28938.20 ± 1.0% | 54.53 ± 0.4% | 11.21 ± 0.8% | 62.87 ± 0.3% | 31022.73 ± 0.3% | 30.24 | 1.00 | 1.07 | 569.37 |
| other: a line's first word, second text | 3716 | 2605.13 ± 1.9% | 846.75 ± 2.0% | 37.02 ± 1.1% | 2442.51 ± 5.7% | 70.89 ± 2.3% | refused | refused | 2609.29 ± 1.5% | 3.08 | 1.00 | 1.07 | 36.75 |
| other: fourteen octets before an x | 87 | 37502.91 ± 0.4% | 1.66 ± 0.4% | 1.70 ± 0.7% | 3452.39 ± 0.7% | 11.77 ± 0.4% | differs | 21.87 ± 0.5% | 37100.68 ± 0.4% | 22614.12 | 1.01 | 10.86 | 3186.36 |
| other: a Greek word | 21815 | 466.63 ± 0.6% | 333.13 ± 0.3% | 34.87 ± 0.3% | 302.93 ± 0.1% | 59.07 ± 12.4% | differs | refused | 465.16 ± 0.4% | 1.40 | 1.00 | 1.54 | 7.90 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.78 ± 0.9% | 30.75 ± 0.4% | 0.61 ± 0.4% | 25.80 ± 0.3% | 2.84 ± 0.1% | differs | 4.00 ± 2.2% | 30.82 ± 0.4% | 1.00 | 1.00 | 1.19 | 10.85 |
| a UUID | 32895 | 25.77 ± 1.3% | 25.77 ± 1.2% | 0.75 ± 1.0% | 18.95 ± 0.4% | 3.08 ± 1.6% | 0.52 ± 0.3% | 3.81 ± 1.4% | 25.75 ± 0.4% | 1.00 | 1.00 | 1.36 | 8.38 |
| an IPv4 address | 33176 | 44.11 ± 1.1% | 44.20 ± 1.3% | 2.42 ± 0.3% | 36.22 ± 0.6% | 7.04 ± 2.0% | differs | 4.17 ± 0.5% | 44.57 ± 1.7% | 1.00 | 0.99 | 1.22 | 6.26 |
| a date and time | 32954 | 39.45 ± 0.4% | 39.48 ± 0.4% | 1.79 ± 0.7% | 29.59 ± 0.2% | 8.53 ± 0.1% | 0.91 ± 0.2% | 7.87 ± 0.8% | 39.48 ± 0.8% | 1.00 | 1.00 | 1.33 | 4.62 |
| a field path | 32606 | 34.77 ± 6.0% | 34.73 ± 0.3% | 0.95 ± 0.9% | 29.31 ± 0.3% | 3.58 ± 1.2% | differs | 2.97 ± 0.9% | 34.71 ± 0.8% | 1.00 | 1.00 | 1.19 | 9.71 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.61 ± 6.6% | 11.63 ± 0.3% | 11.60 ± 6.5% | 13.37 ± 1.2% | 5.88 ± 6.1% | 0.76 ± 0.4% | none | 11.51 ± 0.2% | 1.00 | 1.01 | 0.87 | 1.97 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 212.56 ± 0.1% | 213.42 ± 0.8% | 238.42 ± 0.3% | 101.76 ± 1.7% | 244.94 ± 7.4% | 702.97 ± 3.2% | 4890.77 ± 11.2% | 212.41 ± 0.2% | 1.00 | 1.00 | 2.09 | 0.87 |
| a UUID | 62 | 157.15 ± 0.6% | 157.75 ± 0.3% | 175.22 ± 0.4% | 58.04 ± 1.4% | 117.58 ± 1.7% | 256.37 ± 3.1% | 5388.31 ± 0.5% | 157.28 ± 0.3% | 1.00 | 1.00 | 2.71 | 1.34 |
| an IPv4 address | 29 | 334.03 ± 0.2% | 335.34 ± 0.6% | 397.97 ± 0.6% | 87.85 ± 0.6% | 149.33 ± 1.4% | 408.90 ± 0.6% | 8957.11 ± 0.2% | 334.20 ± 0.4% | 1.00 | 1.00 | 3.80 | 2.24 |
| a date and time | 56 | 259.50 ± 9.4% | 260.62 ± 19.2% | 295.87 ± 0.3% | 86.94 ± 1.5% | 161.73 ± 2.3% | 482.08 ± 1.7% | 5521.61 ± 1.6% | 259.31 ± 18.0% | 1.00 | 1.00 | 2.98 | 1.60 |
| a field path | 39 | 221.87 ± 0.1% | 222.71 ± 0.9% | 249.15 ± 0.2% | 96.00 ± 2.4% | 228.40 ± 14.0% | 735.04 ± 1.2% | 5877.18 ± 5.8% | 221.78 ± 0.3% | 1.00 | 1.00 | 2.31 | 0.97 |
| literal: a word | 7 | 430.08 ± 4.4% | 438.55 ± 0.3% | 540.80 ± 1.9% | 670.16 ± 7.1% | 789.20 ± 21.8% | 1595.91 ± 5.4% | 34443.89 ± 1.2% | 430.73 ± 0.1% | 0.98 | 1.00 | 0.64 | 0.54 |
| literal: a word that is not there | 8 | 422.83 ± 0.3% | 429.96 ± 0.6% | 527.17 ± 0.3% | 612.18 ± 0.6% | 764.92 ± 1.6% | 1494.52 ± 0.8% | 33438.10 ± 0.5% | 423.19 ± 0.6% | 0.98 | 1.00 | 0.69 | 0.55 |
| literal: one of four words | 26 | 289.54 ± 0.1% | 305.36 ± 0.3% | 355.85 ± 1.1% | 58.53 ± 1.9% | 293.13 ± 2.7% | 597.43 ± 0.3% | 17226.09 ± 1.5% | 289.31 ± 0.2% | 0.95 | 1.00 | 4.95 | 0.99 |
| literal: a word in any case | 11 | 259.11 ± 0.3% | 262.85 ± 0.1% | 299.01 ± 0.2% | 19.84 ± 0.5% | 829.13 ± 20.3% | refused | 25681.80 ± 2.1% | 258.88 ± 1.2% | 0.99 | 1.00 | 13.06 | 0.31 |
| literal: an href attribute | 12 | 320.75 ± 0.3% | 323.91 ± 0.3% | 382.70 ± 0.2% | 50.43 ± 0.6% | 581.05 ± 3.4% | 1282.83 ± 0.9% | 24707.58 ± 0.5% | 320.31 ± 0.6% | 0.99 | 1.00 | 6.36 | 0.55 |
| literal: a word, second text | 10 | 404.40 ± 0.2% | 411.01 ± 0.2% | 502.21 ± 0.9% | 554.17 ± 0.7% | 669.19 ± 6.5% | 1352.66 ± 0.6% | 30723.57 ± 0.3% | 404.29 ± 0.6% | 0.98 | 1.00 | 0.73 | 0.60 |
| class: two capitalized words | 23 | 348.42 ± 0.2% | 357.02 ± 1.0% | 420.38 ± 0.1% | 123.15 ± 0.2% | 600.07 ± 24.8% | 1276.95 ± 1.0% | 7850.85 ± 0.2% | 348.24 ± 3.4% | 0.98 | 1.00 | 2.83 | 0.58 |
| class: a word that ends in ing | 9 | 419.06 ± 0.2% | 434.47 ± 0.2% | 530.21 ± 0.6% | 153.16 ± 1.0% | 874.06 ± 2.4% | 1896.35 ± 2.8% | 19286.26 ± 0.4% | 418.95 ± 0.3% | 0.96 | 1.00 | 2.74 | 0.48 |
| class: a word in capitals | 16 | 382.35 ± 0.4% | 392.42 ± 0.2% | 469.80 ± 0.1% | 156.86 ± 1.6% | 902.99 ± 13.9% | 1768.73 ± 2.3% | 10431.92 ± 1.1% | 382.82 ± 0.3% | 0.97 | 1.00 | 2.44 | 0.42 |
| class: a number | 6 | 447.41 ± 0.3% | 460.29 ± 0.5% | 570.37 ± 0.3% | 48.93 ± 1.8% | 1683.74 ± 1.2% | 3016.09 ± 1.3% | 25683.20 ± 0.8% | 447.87 ± 0.3% | 0.97 | 1.00 | 9.14 | 0.27 |
| class: two capitalized words, second text | 23 | 348.08 ± 1.1% | 356.90 ± 0.5% | 419.99 ± 0.2% | 121.16 ± 0.8% | 601.71 ± 1.3% | 1284.00 ± 1.2% | 7843.44 ± 0.4% | 348.12 ± 0.3% | 0.98 | 1.00 | 2.87 | 0.58 |
| other: a word between two words | 13 | 395.85 ± 0.2% | 399.91 ± 0.4% | 480.73 ± 0.4% | 155.91 ± 1.0% | 592.03 ± 1.5% | 1327.95 ± 0.3% | 17391.49 ± 0.6% | 396.07 ± 0.5% | 0.99 | 1.00 | 2.54 | 0.67 |
| other: a number before a unit, second text | 15 | 342.32 ± 0.2% | 356.11 ± 0.4% | 422.25 ± 0.2% | 46.01 ± 1.2% | 732.97 ± 1.4% | 1450.35 ± 2.4% | 17258.55 ± 1.3% | 342.43 ± 0.1% | 0.96 | 1.00 | 7.44 | 0.47 |
| other: a heading's start tag | 13 | 319.24 ± 0.4% | 321.37 ± 0.2% | 386.03 ± 0.5% | 48.52 ± 0.6% | 715.21 ± 0.5% | 1373.82 ± 0.3% | 20391.81 ± 1.2% | 318.43 ± 0.4% | 0.99 | 1.00 | 6.58 | 0.45 |
| other: a whole word | 11 | 405.83 ± 0.3% | 412.50 ± 4.2% | 502.36 ± 0.1% | 147.21 ± 8.2% | 690.41 ± 1.7% | 1340.19 ± 0.6% | 30093.74 ± 0.2% | 404.81 ± 0.8% | 0.98 | 1.00 | 2.76 | 0.59 |
| other: a line's first word, second text | 17 | 392.15 ± 0.3% | 402.46 ± 0.4% | 485.19 ± 4.2% | 148.76 ± 0.4% | 811.17 ± 6.5% | refused | refused | 391.14 ± 0.7% | 0.97 | 1.00 | 2.64 | 0.48 |
| other: fourteen octets before an x | 16 | 110.08 ± 0.2% | 144.45 ± 0.2% | 166.07 ± 0.6% | 17.85 ± 0.7% | 494.75 ± 10.1% | 566.74 ± 1.6% | 15718.34 ± 8.6% | 110.05 ± 0.3% | 0.76 | 1.00 | 6.17 | 0.22 |
| other: a Greek word | 8 | 431.27 ± 0.0% | 448.07 ± 0.6% | 552.40 ± 0.1% | 62.82 ± 0.2% | 1658.96 ± 1.7% | 2714.68 ± 1.5% | refused | 431.20 ± 0.2% | 0.96 | 1.00 | 6.86 | 0.26 |

