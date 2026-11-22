# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45054925904 |
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
| literal: a word | 217 | 15284.63 ± 1.6% | 1039.41 ± 0.1% | 28.61 ± 0.2% | 17838.73 ± 2.1% | 9158.50 ± 8.7% | 17.25 ± 0.5% | 83.96 ± 1.1% | 15372.27 ± 2.2% | 14.71 | 0.99 | 0.86 | 1.67 |
| literal: a word that is not there | 0 | 18120.92 ± 2.8% | 1045.56 ± 0.3% | 28.61 ± 0.3% | 18808.26 ± 2.7% | 27734.86 ± 4.6% | 17.04 ± 0.3% | 79.33 ± 0.3% | 18307.77 ± 1.9% | 17.33 | 0.99 | 0.96 | 0.65 |
| literal: one of four words | 661 | 5738.53 ± 0.8% | 1017.38 ± 0.6% | 15.00 ± 0.2% | 3963.68 ± 0.3% | 21.87 ± 0.2% | 5.33 ± 0.2% | 6.85 ± 0.3% | 5728.75 ± 0.7% | 5.64 | 1.00 | 1.45 | 262.44 |
| literal: a word in any case | 217 | 11487.54 ± 1.1% | 1036.83 ± 0.3% | 21.63 ± 1.9% | 3976.76 ± 0.5% | 38.65 ± 0.1% | refused | differs | 11452.49 ± 0.7% | 11.08 | 1.00 | 2.89 | 297.19 |
| literal: an href attribute | 33 | 15989.20 ± 2.5% | 1044.17 ± 0.1% | 27.73 ± 0.2% | 16646.80 ± 1.8% | 2249.93 ± 6.0% | 13.10 ± 0.2% | 73.76 ± 0.4% | 16077.97 ± 1.6% | 15.31 | 0.99 | 0.96 | 7.11 |
| literal: a word, second text | 123 | 15821.56 ± 0.7% | 1042.03 ± 0.2% | 28.34 ± 0.1% | 18378.82 ± 1.2% | 7604.22 ± 3.3% | 20.11 ± 0.4% | 69.78 ± 0.3% | 15822.81 ± 1.1% | 15.18 | 1.00 | 0.86 | 2.08 |
| class: two capitalized words | 1331 | 1110.54 ± 0.7% | 957.66 ± 0.1% | 26.30 ± 0.4% | 586.75 ± 0.2% | 40.83 ± 8.5% | 14.77 ± 0.3% | 67.28 ± 0.3% | 1109.35 ± 0.4% | 1.16 | 1.00 | 1.89 | 27.20 |
| class: a word that ends in ing | 3399 | 883.33 ± 0.2% | 884.99 ± 0.2% | 18.46 ± 0.4% | 550.25 ± 0.1% | 29.52 ± 10.8% | 8.14 ± 0.3% | 18.21 ± 0.2% | 882.36 ± 0.2% | 1.00 | 1.00 | 1.61 | 29.92 |
| class: a word in capitals | 2332 | 1475.26 ± 0.6% | 952.87 ± 0.0% | 27.88 ± 0.7% | 575.12 ± 0.1% | 43.72 ± 0.2% | 17.18 ± 0.3% | 82.48 ± 0.8% | 1472.92 ± 0.5% | 1.55 | 1.00 | 2.57 | 33.74 |
| class: a number | 8288 | 2119.36 ± 0.5% | 805.92 ± 0.1% | 28.22 ± 0.2% | 1805.84 ± 0.3% | 40.20 ± 15.5% | 0.54 ± 0.2% | 57.29 ± 0.9% | 2120.95 ± 0.4% | 2.63 | 1.00 | 1.17 | 52.72 |
| class: two capitalized words, second text | 5359 | 686.22 ± 0.3% | 695.66 ± 1.7% | 23.67 ± 0.1% | 489.36 ± 0.1% | 34.20 ± 10.8% | 17.12 ± 0.1% | 62.42 ± 0.9% | 694.12 ± 0.2% | 0.99 | 0.99 | 1.40 | 20.07 |
| other: a word between two words | 6104 | 726.38 ± 0.3% | 747.90 ± 0.3% | 23.85 ± 0.1% | 756.15 ± 0.2% | 108.57 ± 10.7% | 11.18 ± 0.1% | 68.02 ± 0.4% | 725.74 ± 0.2% | 0.97 | 1.00 | 0.96 | 6.69 |
| other: a number before a unit, second text | 1481 | 5477.35 ± 0.8% | 978.74 ± 0.1% | 26.25 ± 0.2% | 5863.33 ± 0.5% | 40.83 ± 9.6% | 18.22 ± 0.3% | 65.61 ± 0.3% | 5457.56 ± 0.2% | 5.60 | 1.00 | 0.93 | 134.15 |
| other: a heading's start tag | 110 | 12275.99 ± 1.7% | 1035.00 ± 0.1% | 27.49 ± 0.2% | 1719.64 ± 0.2% | 1591.06 ± 6.4% | 15.99 ± 0.5% | 86.00 ± 0.7% | 12291.73 ± 1.4% | 11.86 | 1.00 | 7.14 | 7.72 |
| other: a whole word | 217 | 13416.35 ± 1.7% | 1038.72 ± 0.1% | 30.21 ± 0.4% | 14386.12 ± 1.6% | 49.33 ± 0.3% | 13.18 ± 0.2% | 54.68 ± 0.4% | 13416.88 ± 1.9% | 12.92 | 1.00 | 0.93 | 271.95 |
| other: a line's first word, second text | 3716 | 1964.38 ± 0.4% | 862.95 ± 0.2% | 31.95 ± 0.3% | 1737.51 ± 0.4% | 62.19 ± 7.6% | refused | refused | 1957.03 ± 0.3% | 2.28 | 1.00 | 1.13 | 31.59 |
| other: fourteen octets before an x | 87 | 18777.87 ± 2.1% | 1.53 ± 0.0% | 1.53 ± 0.0% | 3979.21 ± 0.6% | 10.68 ± 0.3% | differs | 17.77 ± 0.1% | 18774.53 ± 0.7% | 12251.53 | 1.00 | 4.72 | 1758.09 |
| other: a Greek word | 21815 | 478.71 ± 1.0% | 323.27 ± 0.3% | 31.49 ± 0.1% | 294.08 ± 0.1% | 44.44 ± 9.9% | differs | refused | 476.54 ± 0.7% | 1.48 | 1.00 | 1.63 | 10.77 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.07 ± 0.3% | 28.10 ± 0.1% | 0.50 ± 0.1% | 21.54 ± 0.4% | 2.74 ± 0.3% | differs | 4.01 ± 0.2% | 28.11 ± 0.3% | 1.00 | 1.00 | 1.30 | 10.25 |
| a UUID | 32895 | 23.07 ± 0.6% | 23.04 ± 0.5% | 0.67 ± 0.1% | 16.06 ± 0.4% | 3.08 ± 0.6% | 0.73 ± 0.5% | 3.65 ± 0.4% | 23.08 ± 0.2% | 1.00 | 1.00 | 1.44 | 7.50 |
| an IPv4 address | 33176 | 41.49 ± 0.2% | 41.51 ± 0.2% | 2.18 ± 0.2% | 32.71 ± 0.4% | 6.68 ± 0.3% | differs | 4.07 ± 0.2% | 41.48 ± 0.2% | 1.00 | 1.00 | 1.27 | 6.21 |
| a date and time | 32954 | 34.86 ± 0.2% | 34.87 ± 0.1% | 1.51 ± 0.2% | 23.29 ± 0.3% | 7.04 ± 0.1% | 1.25 ± 0.2% | 7.12 ± 0.5% | 34.86 ± 0.2% | 1.00 | 1.00 | 1.50 | 4.95 |
| a field path | 32606 | 32.28 ± 0.3% | 32.26 ± 0.2% | 0.83 ± 0.2% | 25.28 ± 0.4% | 3.48 ± 1.4% | differs | 2.93 ± 0.2% | 32.20 ± 0.2% | 1.00 | 1.00 | 1.28 | 9.28 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.19 ± 0.2% | 10.19 ± 0.3% | 10.19 ± 0.4% | 11.72 ± 0.1% | 4.90 ± 1.4% | 0.94 ± 0.8% | none | 10.16 ± 0.6% | 1.00 | 1.00 | 0.87 | 2.08 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 225.57 ± 0.4% | 226.11 ± 0.4% | 256.80 ± 0.3% | 85.72 ± 0.4% | 213.67 ± 2.8% | 477.14 ± 1.0% | 3833.84 ± 0.8% | 225.56 ± 0.3% | 1.00 | 1.00 | 2.63 | 1.06 |
| a UUID | 62 | 170.41 ± 0.3% | 170.70 ± 0.3% | 189.59 ± 0.2% | 46.30 ± 0.7% | 95.62 ± 2.5% | 187.22 ± 3.2% | 4467.88 ± 0.5% | 170.58 ± 0.3% | 1.00 | 1.00 | 3.68 | 1.78 |
| an IPv4 address | 29 | 347.16 ± 0.5% | 348.40 ± 0.4% | 427.13 ± 0.3% | 76.79 ± 0.3% | 126.72 ± 1.5% | 297.11 ± 3.4% | 7598.96 ± 0.1% | 347.25 ± 0.5% | 1.00 | 1.00 | 4.52 | 2.74 |
| a date and time | 56 | 265.91 ± 0.2% | 267.57 ± 0.4% | 311.50 ± 0.1% | 72.58 ± 0.6% | 130.12 ± 3.5% | 325.91 ± 1.2% | 4932.36 ± 0.4% | 265.71 ± 0.2% | 0.99 | 1.00 | 3.66 | 2.04 |
| a field path | 39 | 232.65 ± 0.2% | 233.30 ± 0.4% | 265.61 ± 0.4% | 80.62 ± 0.5% | 196.90 ± 2.7% | 500.03 ± 1.9% | 4926.23 ± 3.4% | 232.45 ± 0.1% | 1.00 | 1.00 | 2.89 | 1.18 |
| literal: a word | 7 | 478.81 ± 0.4% | 488.73 ± 0.1% | 657.74 ± 0.3% | 508.21 ± 0.7% | 616.04 ± 3.6% | 950.75 ± 0.7% | 29715.16 ± 0.1% | 478.16 ± 0.4% | 0.98 | 1.00 | 0.94 | 0.78 |
| literal: a word that is not there | 8 | 468.09 ± 0.1% | 478.50 ± 0.1% | 638.76 ± 0.3% | 463.98 ± 0.2% | 581.87 ± 2.3% | 907.74 ± 1.1% | 28626.14 ± 0.1% | 468.18 ± 0.2% | 0.98 | 1.00 | 1.01 | 0.80 |
| literal: one of four words | 26 | 312.04 ± 0.5% | 332.60 ± 0.5% | 405.10 ± 0.4% | 49.90 ± 0.9% | 228.19 ± 6.6% | 370.68 ± 2.5% | 15444.47 ± 0.3% | 312.12 ± 0.6% | 0.94 | 1.00 | 6.25 | 1.37 |
| literal: a word in any case | 11 | 271.48 ± 0.4% | 275.06 ± 0.3% | 324.19 ± 0.2% | 15.74 ± 0.3% | 620.93 ± 3.5% | refused | 23277.58 ± 0.3% | 271.58 ± 0.4% | 0.99 | 1.00 | 17.25 | 0.44 |
| literal: an href attribute | 12 | 331.70 ± 0.6% | 334.33 ± 0.6% | 408.06 ± 0.3% | 45.63 ± 0.4% | 479.09 ± 1.8% | 778.32 ± 1.3% | 21376.84 ± 0.2% | 331.51 ± 0.4% | 0.99 | 1.00 | 7.27 | 0.69 |
| literal: a word, second text | 10 | 447.16 ± 0.3% | 457.27 ± 0.4% | 604.59 ± 0.2% | 402.54 ± 0.2% | 512.23 ± 2.0% | 813.81 ± 0.5% | 26508.66 ± 0.6% | 447.09 ± 0.4% | 0.98 | 1.00 | 1.11 | 0.87 |
| class: two capitalized words | 23 | 360.66 ± 0.6% | 369.21 ± 0.6% | 457.86 ± 0.4% | 98.22 ± 0.7% | 482.47 ± 1.6% | 755.99 ± 1.0% | 6493.82 ± 1.4% | 361.05 ± 0.6% | 0.98 | 1.00 | 3.67 | 0.75 |
| class: a word that ends in ing | 9 | 454.67 ± 0.2% | 474.57 ± 0.2% | 629.31 ± 0.1% | 131.20 ± 0.9% | 732.20 ± 3.8% | 1083.57 ± 0.9% | 15839.07 ± 0.1% | 454.41 ± 0.3% | 0.96 | 1.00 | 3.47 | 0.62 |
| class: a word in capitals | 16 | 406.43 ± 0.4% | 417.26 ± 0.5% | 533.10 ± 0.2% | 135.32 ± 0.5% | 715.15 ± 4.2% | 1004.31 ± 1.6% | 8546.70 ± 1.0% | 405.94 ± 0.3% | 0.97 | 1.00 | 3.00 | 0.57 |
| class: a number | 6 | 489.14 ± 0.3% | 505.47 ± 0.7% | 681.63 ± 0.2% | 41.65 ± 0.6% | 1351.92 ± 1.3% | 1852.10 ± 1.6% | 22494.91 ± 0.1% | 489.06 ± 0.3% | 0.97 | 1.00 | 11.74 | 0.36 |
| class: two capitalized words, second text | 23 | 360.81 ± 0.6% | 369.71 ± 0.1% | 458.35 ± 0.3% | 99.50 ± 0.9% | 483.46 ± 2.7% | 765.72 ± 0.5% | 6498.52 ± 1.1% | 360.90 ± 0.2% | 0.98 | 1.00 | 3.63 | 0.75 |
| other: a word between two words | 13 | 429.07 ± 0.2% | 434.40 ± 0.3% | 562.20 ± 0.4% | 133.57 ± 1.0% | 479.74 ± 3.2% | 811.86 ± 0.5% | 14719.03 ± 0.3% | 429.18 ± 0.3% | 0.99 | 1.00 | 3.21 | 0.89 |
| other: a number before a unit, second text | 15 | 370.65 ± 0.2% | 386.31 ± 0.5% | 486.88 ± 0.4% | 39.30 ± 0.7% | 610.40 ± 2.4% | 885.38 ± 0.8% | 15060.52 ± 0.2% | 370.35 ± 0.2% | 0.96 | 1.00 | 9.43 | 0.61 |
| other: a heading's start tag | 13 | 333.27 ± 0.4% | 335.67 ± 0.4% | 410.72 ± 0.4% | 43.35 ± 0.5% | 611.58 ± 2.1% | 859.12 ± 0.8% | 17888.64 ± 0.3% | 333.04 ± 0.3% | 0.99 | 1.00 | 7.69 | 0.54 |
| other: a whole word | 11 | 454.53 ± 0.4% | 460.61 ± 0.7% | 609.02 ± 0.6% | 118.33 ± 0.4% | 537.29 ± 2.2% | 809.22 ± 0.5% | 26532.63 ± 0.2% | 454.13 ± 0.3% | 0.99 | 1.00 | 3.84 | 0.85 |
| other: a line's first word, second text | 17 | 421.91 ± 0.2% | 432.44 ± 0.8% | 557.97 ± 0.1% | 129.79 ± 0.2% | 681.41 ± 0.8% | refused | refused | 419.96 ± 0.7% | 0.98 | 1.00 | 3.25 | 0.62 |
| other: fourteen octets before an x | 16 | 110.95 ± 1.7% | 146.81 ± 1.3% | 167.11 ± 1.1% | 15.04 ± 0.6% | 434.41 ± 1.6% | 407.76 ± 0.5% | 12839.75 ± 0.4% | 111.38 ± 2.0% | 0.76 | 1.00 | 7.38 | 0.26 |
| other: a Greek word | 8 | 472.81 ± 0.4% | 493.89 ± 0.4% | 661.70 ± 0.4% | 59.31 ± 0.4% | 1342.48 ± 3.1% | 1855.67 ± 0.6% | refused | 472.63 ± 0.3% | 0.96 | 1.00 | 7.97 | 0.35 |

