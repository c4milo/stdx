# bench-regex

| Field | Value |
|---|---|
| Commit | a697a7f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44949411942 |
| Date | 2026-11-21 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache, `stdx, no skip` the same with claim R1 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
- class: a distance, second text, in canterbury-large/world192.txt: `[0-9][0-9,]* km`
- other: a word between two words, in canterbury-large/bible.txt: `the [a-z]+ of`
- other: a heading's start tag, in http/html-1m: `<h[1-6][^>]*>`
- other: a whole word, in canterbury-large/bible.txt: `\bPharaoh\b`, which Rust's regex takes as `(?-u:\b)Pharaoh(?-u:\b)`
- other: a line's first word, second text, in canterbury-large/world192.txt: `(?m)^[A-Z][a-z]+:`
- other: fourteen octets before an x, in canterbury-large/bible.txt: `[a-q][^u-z]{13}x`
- other: a Greek word, in generated: words in four scripts: `[α-ω]+`

## Search in 1 MiB, MB/s

| Pattern | Matches | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| literal: a word | 217 | 5212.56 ± 0.4% | 573.63 ± 0.8% | 28.81 ± 0.3% | 18415.64 ± 2.5% | 9215.50 ± 7.4% | 17.39 ± 0.8% | 84.27 ± 0.5% | 9.09 | 0.28 | 0.57 |
| literal: a word that is not there | 0 | 5369.98 ± 1.0% | 576.11 ± 0.1% | 28.79 ± 0.5% | 19974.84 ± 2.9% | 29220.17 ± 1.5% | 17.19 ± 0.4% | 79.82 ± 0.5% | 9.32 | 0.27 | 0.18 |
| literal: one of four words | 661 | 2418.79 ± 1.0% | 566.09 ± 0.2% | 14.95 ± 0.2% | 3983.64 ± 0.2% | 21.90 ± 0.3% | 5.37 ± 0.2% | 6.85 ± 0.8% | 4.27 | 0.61 | 110.47 |
| literal: a word in any case | 217 | 2672.61 ± 1.0% | 572.95 ± 0.1% | 21.89 ± 0.4% | 3986.24 ± 0.2% | 38.66 ± 0.3% | refused | differs | 4.66 | 0.67 | 69.13 |
| literal: an href attribute | 33 | 1607.64 ± 0.6% | 575.53 ± 0.2% | 27.53 ± 0.3% | 16779.83 ± 3.8% | 2257.23 ± 1.1% | 13.14 ± 0.3% | 74.12 ± 0.4% | 2.79 | 0.10 | 0.71 |
| literal: a word, second text | 123 | 4066.95 ± 1.0% | 575.03 ± 0.3% | 28.39 ± 0.2% | 18216.93 ± 2.3% | 7590.65 ± 6.5% | 19.77 ± 0.5% | 70.44 ± 0.7% | 7.07 | 0.22 | 0.54 |
| class: two capitalized words | 1331 | 1119.18 ± 0.4% | 549.11 ± 0.1% | 26.46 ± 0.4% | 587.30 ± 0.0% | 40.86 ± 0.2% | 14.63 ± 0.3% | 67.49 ± 0.2% | 2.04 | 1.91 | 27.39 |
| class: a word that ends in ing | 3399 | 513.28 ± 0.1% | 515.15 ± 0.1% | 18.45 ± 0.1% | 550.66 ± 1.2% | 29.55 ± 2.1% | 8.16 ± 0.3% | 18.37 ± 0.3% | 1.00 | 0.93 | 17.37 |
| class: a word in capitals | 2332 | 1410.66 ± 0.3% | 540.55 ± 0.1% | 27.83 ± 0.5% | 575.20 ± 0.1% | 43.72 ± 17.2% | 16.81 ± 0.2% | 82.49 ± 0.9% | 2.61 | 2.45 | 32.27 |
| class: a number | 8288 | 1717.14 ± 0.1% | 482.95 ± 0.1% | 27.90 ± 0.3% | 1811.42 ± 0.3% | 43.02 ± 6.9% | 0.55 ± 0.4% | 57.53 ± 0.3% | 3.56 | 0.95 | 39.91 |
| class: a distance, second text | 1481 | 1364.18 ± 0.5% | 548.84 ± 0.0% | 26.49 ± 0.1% | 5914.80 ± 0.9% | 40.92 ± 2.9% | 17.78 ± 0.4% | 65.75 ± 0.3% | 2.49 | 0.23 | 33.34 |
| other: a word between two words | 6104 | 471.86 ± 0.0% | 472.52 ± 0.1% | 23.88 ± 0.1% | 755.60 ± 0.2% | 107.32 ± 8.4% | 10.65 ± 0.2% | 68.56 ± 0.6% | 1.00 | 0.62 | 4.40 |
| other: a heading's start tag | 110 | 1427.31 ± 0.4% | 573.48 ± 0.4% | 27.42 ± 0.1% | 1718.95 ± 0.2% | 1585.34 ± 5.1% | 16.27 ± 0.6% | 86.09 ± 1.7% | 2.49 | 0.83 | 0.90 |
| other: a whole word | 217 | 573.53 ± 0.3% | 573.24 ± 0.3% | 29.65 ± 0.3% | 14761.57 ± 1.7% | 49.30 ± 0.1% | 13.64 ± 0.4% | 55.16 ± 1.1% | 1.00 | 0.04 | 11.63 |
| other: a line's first word, second text | 3716 | 512.52 ± 0.2% | 513.50 ± 0.1% | 31.41 ± 0.3% | 1767.31 ± 0.2% | 62.42 ± 8.4% | refused | refused | 1.00 | 0.29 | 8.21 |
| other: fourteen octets before an x | 87 | 1.54 ± 0.3% | 1.54 ± 0.1% | 1.53 ± 0.1% | 3933.13 ± 0.3% | 10.68 ± 0.2% | differs | 17.74 ± 0.1% | 1.00 | 0.00 | 0.14 |
| other: a Greek word | 21815 | 393.06 ± 0.3% | 282.52 ± 0.2% | 31.59 ± 0.2% | 295.37 ± 0.3% | 47.50 ± 10.3% | differs | refused | 1.39 | 1.33 | 8.28 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.99 ± 0.3% | 20.01 ± 0.2% | 0.50 ± 0.1% | 21.40 ± 0.1% | 2.76 ± 0.6% | differs | 4.01 ± 0.3% | 0.95 | 0.89 | 6.89 |
| a UUID | 32895 | 13.64 ± 0.2% | 14.52 ± 0.5% | 0.67 ± 0.1% | 16.03 ± 0.0% | 3.09 ± 0.4% | 0.74 ± 0.2% | 3.65 ± 0.7% | 0.94 | 0.85 | 4.41 |
| an IPv4 address | 33176 | 31.06 ± 0.5% | 32.20 ± 0.4% | 2.17 ± 0.2% | 32.71 ± 0.2% | 6.68 ± 0.1% | differs | 4.17 ± 0.1% | 0.96 | 0.95 | 4.65 |
| a date and time | 32954 | 21.60 ± 0.3% | 22.74 ± 0.2% | 1.51 ± 0.2% | 23.36 ± 0.2% | 7.11 ± 0.1% | 1.25 ± 0.2% | 7.16 ± 0.2% | 0.95 | 0.92 | 3.04 |
| a field path | 32606 | 23.06 ± 0.3% | 24.08 ± 0.4% | 0.83 ± 0.2% | 25.39 ± 0.3% | 3.50 ± 1.5% | differs | 2.95 ± 0.1% | 0.96 | 0.91 | 6.59 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 2.45 ± 1.1% | 2.47 ± 0.5% | 1.13 ± 0.3% | 11.69 ± 0.1% | 4.94 ± 1.1% | 0.94 ± 0.9% | none | 0.99 | 0.21 | 0.49 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 253.43 ± 0.5% | 253.67 ± 0.3% | 355.87 ± 0.1% | 86.20 ± 0.3% | 215.25 ± 1.5% | 480.37 ± 0.4% | 3746.24 ± 2.9% | 1.00 | 2.94 | 1.18 |
| a UUID | 62 | 191.39 ± 0.5% | 191.66 ± 0.3% | 254.69 ± 0.1% | 45.72 ± 0.8% | 98.26 ± 12.3% | 184.14 ± 1.9% | 4313.64 ± 0.6% | 1.00 | 4.19 | 1.95 |
| an IPv4 address | 29 | 364.39 ± 0.5% | 365.12 ± 0.5% | 608.18 ± 0.5% | 76.35 ± 0.2% | 128.89 ± 4.7% | 301.04 ± 0.8% | 7596.51 ± 0.5% | 1.00 | 4.77 | 2.83 |
| a date and time | 56 | 242.02 ± 0.3% | 241.61 ± 0.3% | 358.29 ± 0.1% | 72.45 ± 1.2% | 133.61 ± 1.0% | 333.67 ± 0.7% | 4990.85 ± 0.1% | 1.00 | 3.34 | 1.81 |
| a field path | 39 | 246.85 ± 0.4% | 247.40 ± 0.1% | 409.19 ± 0.1% | 79.70 ± 1.2% | 199.79 ± 18.7% | 504.80 ± 1.2% | 4813.58 ± 0.5% | 1.00 | 3.10 | 1.24 |
| literal: a word | 7 | 418.48 ± 0.2% | 417.49 ± 0.4% | 1414.43 ± 0.9% | 505.92 ± 0.5% | 611.35 ± 1.1% | 969.34 ± 0.7% | 30198.38 ± 0.2% | 1.00 | 0.83 | 0.68 |
| literal: a word that is not there | 8 | 481.24 ± 0.2% | 479.86 ± 0.2% | 1323.99 ± 0.3% | 463.01 ± 0.7% | 586.85 ± 2.0% | 924.75 ± 0.5% | 29036.42 ± 0.2% | 1.00 | 1.04 | 0.82 |
| literal: one of four words | 26 | 344.50 ± 0.1% | 343.64 ± 0.6% | 600.47 ± 0.4% | 49.17 ± 0.7% | 235.31 ± 3.2% | 375.76 ± 0.6% | 15630.32 ± 0.6% | 1.00 | 7.01 | 1.46 |
| literal: a word in any case | 11 | 496.29 ± 0.9% | 497.19 ± 0.4% | 1131.85 ± 0.3% | 15.58 ± 0.5% | 634.74 ± 0.4% | refused | 23757.47 ± 0.5% | 1.00 | 31.85 | 0.78 |
| literal: an href attribute | 12 | 314.98 ± 0.2% | 314.55 ± 0.5% | 540.82 ± 0.2% | 44.09 ± 0.8% | 486.89 ± 2.6% | 770.51 ± 1.5% | 21630.82 ± 0.4% | 1.00 | 7.14 | 0.65 |
| literal: a word, second text | 10 | 545.67 ± 0.9% | 544.72 ± 0.3% | 1188.40 ± 0.6% | 400.22 ± 0.8% | 521.52 ± 12.9% | 800.93 ± 0.7% | 27016.08 ± 0.2% | 1.00 | 1.36 | 1.05 |
| class: two capitalized words | 23 | 322.69 ± 0.6% | 323.40 ± 0.7% | 620.02 ± 0.4% | 97.78 ± 0.3% | 486.48 ± 10.1% | 753.73 ± 1.3% | 6286.65 ± 0.2% | 1.00 | 3.30 | 0.66 |
| class: a word that ends in ing | 9 | 451.52 ± 0.5% | 452.43 ± 0.6% | 1181.04 ± 0.2% | 130.06 ± 0.6% | 741.87 ± 1.0% | 1104.37 ± 1.8% | 15611.64 ± 0.2% | 1.00 | 3.47 | 0.61 |
| class: a word in capitals | 16 | 314.56 ± 0.4% | 315.44 ± 0.5% | 801.57 ± 0.3% | 133.02 ± 1.0% | 735.96 ± 0.5% | 1006.64 ± 1.9% | 8270.09 ± 0.0% | 1.00 | 2.36 | 0.43 |
| class: a number | 6 | 422.16 ± 0.9% | 424.15 ± 0.9% | 1384.79 ± 0.1% | 41.66 ± 1.0% | 1372.33 ± 1.0% | 1916.78 ± 0.5% | 22803.95 ± 0.1% | 1.00 | 10.13 | 0.31 |
| class: a distance, second text | 15 | 433.84 ± 0.7% | 434.64 ± 0.9% | 841.42 ± 0.1% | 39.29 ± 0.5% | 620.56 ± 1.5% | 885.04 ± 0.2% | 15105.19 ± 0.2% | 1.00 | 11.04 | 0.70 |
| other: a word between two words | 13 | 409.63 ± 0.6% | 409.33 ± 0.4% | 976.34 ± 0.6% | 132.47 ± 0.3% | 492.77 ± 1.9% | 811.54 ± 0.7% | 14463.21 ± 0.2% | 1.00 | 3.09 | 0.83 |
| other: a heading's start tag | 13 | 303.00 ± 0.6% | 303.04 ± 0.2% | 522.06 ± 0.3% | 43.53 ± 0.4% | 620.18 ± 1.2% | 875.67 ± 0.5% | 18011.59 ± 0.1% | 1.00 | 6.96 | 0.49 |
| other: a whole word | 11 | 453.76 ± 0.6% | 451.19 ± 0.4% | 1225.56 ± 0.5% | 102.62 ± 1.1% | 553.26 ± 2.4% | 833.20 ± 0.7% | 26768.02 ± 0.7% | 1.01 | 4.42 | 0.82 |
| other: a line's first word, second text | 17 | 476.58 ± 1.0% | 477.69 ± 0.2% | 939.88 ± 0.4% | 125.75 ± 0.1% | 695.84 ± 1.8% | refused | refused | 1.00 | 3.79 | 0.68 |
| other: fourteen octets before an x | 16 | 146.01 ± 0.6% | 145.83 ± 0.5% | 185.15 ± 0.5% | 14.74 ± 0.1% | 445.44 ± 1.8% | 412.08 ± 0.4% | 12832.92 ± 0.1% | 1.00 | 9.91 | 0.33 |
| other: a Greek word | 8 | 372.00 ± 0.3% | 372.25 ± 0.6% | 1291.57 ± 0.7% | 58.82 ± 0.6% | 1368.85 ± 1.0% | 1865.23 ± 0.6% | refused | 1.00 | 6.32 | 0.27 |

