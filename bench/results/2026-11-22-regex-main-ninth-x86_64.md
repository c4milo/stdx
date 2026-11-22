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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45058347979 |
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
| literal: a word | 217 | 43380.78 ± 0.6% | 1029.40 ± 0.2% | 32.98 ± 0.4% | 40501.01 ± 0.3% | 12170.83 ± 1.7% | 12.78 ± 0.5% | 104.28 ± 0.3% | 43453.41 ± 0.2% | 42.14 | 1.00 | 1.07 | 3.56 |
| literal: a word that is not there | 0 | 61163.46 ± 9.0% | 1039.93 ± 3.7% | 32.89 ± 84.5% | 45760.83 ± 91.3% | 43392.45 ± 26.1% | 12.64 ± 0.6% | 97.40 ± 0.2% | 61173.18 ± 0.6% | 58.82 | 1.00 | 1.34 | 1.41 |
| literal: one of four words | 661 | 13318.89 ± 0.3% | 1008.23 ± 0.4% | 17.15 ± 0.6% | 11521.60 ± 0.4% | 24.27 ± 0.4% | 4.42 ± 0.1% | 8.00 ± 2.3% | 13321.83 ± 0.6% | 13.21 | 1.00 | 1.16 | 548.88 |
| literal: a word in any case | 217 | 37354.64 ± 0.3% | 1028.15 ± 0.2% | 24.62 ± 1.2% | 11386.79 ± 0.2% | 47.58 ± 4.6% | refused | differs | 37381.65 ± 1.0% | 36.33 | 1.00 | 3.28 | 785.14 |
| literal: an href attribute | 33 | 45035.97 ± 0.3% | 1035.23 ± 0.2% | 31.82 ± 0.7% | 35516.23 ± 0.2% | 3025.86 ± 4.9% | 9.57 ± 0.2% | 91.46 ± 0.4% | 45020.01 ± 0.3% | 43.50 | 1.00 | 1.27 | 14.88 |
| literal: a word, second text | 123 | 47548.18 ± 0.4% | 1029.05 ± 0.1% | 32.40 ± 0.4% | 40487.39 ± 0.1% | 11096.68 ± 6.6% | 14.46 ± 0.5% | 88.03 ± 0.3% | 47484.33 ± 0.4% | 46.21 | 1.00 | 1.17 | 4.28 |
| class: two capitalized words | 1331 | 914.22 ± 0.3% | 950.20 ± 0.5% | 30.51 ± 0.6% | 576.43 ± 0.3% | 45.02 ± 0.5% | 10.89 ± 0.3% | 80.21 ± 1.3% | 914.15 ± 0.1% | 0.96 | 1.00 | 1.59 | 20.31 |
| class: a word that ends in ing | 3399 | 874.29 ± 0.1% | 873.47 ± 0.5% | 20.97 ± 1.0% | 539.73 ± 0.3% | 33.04 ± 13.5% | 6.20 ± 0.3% | 20.13 ± 1.0% | 873.05 ± 0.3% | 1.00 | 1.00 | 1.62 | 26.46 |
| class: a word in capitals | 2332 | 1146.34 ± 0.1% | 930.17 ± 0.7% | 32.19 ± 0.9% | 564.72 ± 0.9% | 48.42 ± 13.9% | 12.31 ± 0.1% | 101.07 ± 0.3% | 1143.32 ± 0.3% | 1.23 | 1.00 | 2.03 | 23.67 |
| class: a number | 8288 | 1881.87 ± 3.9% | 792.46 ± 0.3% | 32.81 ± 3.5% | 1782.48 ± 2.6% | 48.27 ± 13.4% | 0.38 ± 0.2% | 73.64 ± 1.5% | 1881.07 ± 0.9% | 2.37 | 1.00 | 1.06 | 38.99 |
| class: two capitalized words, second text | 5359 | 690.82 ± 0.4% | 690.50 ± 0.5% | 27.36 ± 5.4% | 481.01 ± 6.9% | 39.39 ± 6.4% | 12.71 ± 4.3% | 74.33 ± 21.6% | 689.95 ± 0.3% | 1.00 | 1.00 | 1.44 | 17.54 |
| other: a word between two words | 6104 | 832.69 ± 0.8% | 729.11 ± 0.5% | 27.27 ± 0.1% | 837.08 ± 3.0% | 130.49 ± 15.5% | 8.46 ± 1.5% | 82.19 ± 0.3% | 833.89 ± 1.8% | 1.14 | 1.00 | 0.99 | 6.38 |
| other: a number before a unit, second text | 1481 | 10627.42 ± 1.0% | 977.15 ± 0.3% | 30.38 ± 0.6% | 9310.67 ± 1.0% | 45.83 ± 0.8% | 13.29 ± 0.4% | 77.98 ± 0.5% | 10573.23 ± 0.2% | 10.88 | 1.01 | 1.14 | 231.88 |
| other: a heading's start tag | 110 | 25752.51 ± 0.3% | 1024.96 ± 0.2% | 32.36 ± 0.6% | 2656.47 ± 4.2% | 2007.27 ± 9.1% | 11.69 ± 0.4% | 107.02 ± 5.8% | 25739.52 ± 0.5% | 25.13 | 1.00 | 9.69 | 12.83 |
| other: a whole word | 217 | 31227.16 ± 0.5% | 1027.62 ± 0.2% | 33.23 ± 0.8% | 29380.68 ± 0.4% | 54.48 ± 0.9% | 11.06 ± 0.2% | 63.03 ± 0.8% | 31090.77 ± 0.3% | 30.39 | 1.00 | 1.06 | 573.14 |
| other: a line's first word, second text | 3716 | 2649.61 ± 2.4% | 853.54 ± 0.3% | 36.67 ± 0.6% | 2444.78 ± 4.6% | 71.15 ± 3.2% | refused | refused | 2610.48 ± 1.3% | 3.10 | 1.01 | 1.08 | 37.24 |
| other: fourteen octets before an x | 87 | 37754.72 ± 4.8% | 1.67 ± 0.9% | 1.70 ± 0.7% | 3440.04 ± 0.2% | 11.79 ± 0.4% | differs | 21.96 ± 0.5% | 37775.39 ± 1.1% | 22577.44 | 1.00 | 10.98 | 3202.05 |
| other: a Greek word | 21815 | 468.25 ± 0.2% | 334.63 ± 2.4% | 34.98 ± 1.0% | 307.77 ± 0.4% | 59.79 ± 8.2% | differs | refused | 467.21 ± 0.4% | 1.40 | 1.00 | 1.52 | 7.83 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.70 ± 0.4% | 30.75 ± 2.5% | 0.62 ± 1.8% | 25.81 ± 0.5% | 2.72 ± 0.2% | differs | 4.05 ± 2.4% | 30.80 ± 0.7% | 1.00 | 1.00 | 1.19 | 11.27 |
| a UUID | 32895 | 25.79 ± 0.1% | 25.80 ± 0.2% | 0.74 ± 0.9% | 18.91 ± 0.5% | 3.11 ± 4.7% | 0.52 ± 0.3% | 3.80 ± 0.6% | 25.80 ± 2.8% | 1.00 | 1.00 | 1.36 | 8.29 |
| an IPv4 address | 33176 | 44.20 ± 1.4% | 44.13 ± 0.7% | 2.42 ± 0.8% | 36.70 ± 0.3% | 7.05 ± 0.6% | differs | 4.18 ± 0.6% | 44.38 ± 1.0% | 1.00 | 1.00 | 1.20 | 6.27 |
| a date and time | 32954 | 39.55 ± 0.4% | 39.47 ± 1.3% | 1.80 ± 0.3% | 29.26 ± 0.2% | 8.57 ± 0.9% | 0.91 ± 0.3% | 7.86 ± 1.3% | 39.60 ± 0.3% | 1.00 | 1.00 | 1.35 | 4.61 |
| a field path | 32606 | 34.51 ± 1.0% | 34.79 ± 0.2% | 0.96 ± 0.5% | 29.30 ± 0.2% | 3.58 ± 2.1% | differs | 2.97 ± 2.1% | 34.72 ± 0.9% | 0.99 | 0.99 | 1.18 | 9.65 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.61 ± 0.3% | 11.39 ± 0.6% | 11.47 ± 0.2% | 13.33 ± 1.5% | 5.84 ± 1.9% | 0.75 ± 2.8% | none | 11.62 ± 6.0% | 1.02 | 1.00 | 0.87 | 1.99 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 204.96 ± 3.2% | 205.56 ± 0.2% | 225.95 ± 0.2% | 102.09 ± 1.6% | 243.26 ± 1.4% | 695.96 ± 4.1% | 4904.76 ± 0.7% | 204.83 ± 0.4% | 1.00 | 1.00 | 2.01 | 0.84 |
| a UUID | 62 | 154.11 ± 0.3% | 154.42 ± 0.3% | 169.83 ± 0.0% | 57.95 ± 2.4% | 118.70 ± 1.4% | 256.41 ± 1.5% | 5368.51 ± 0.4% | 154.03 ± 0.2% | 1.00 | 1.00 | 2.66 | 1.30 |
| an IPv4 address | 29 | 312.10 ± 0.7% | 313.47 ± 0.3% | 366.43 ± 0.3% | 88.08 ± 0.4% | 149.42 ± 1.8% | 409.56 ± 1.0% | 8947.57 ± 0.4% | 312.45 ± 0.5% | 1.00 | 1.00 | 3.54 | 2.09 |
| a date and time | 56 | 252.39 ± 0.5% | 253.70 ± 0.1% | 285.03 ± 0.2% | 87.49 ± 2.6% | 162.03 ± 1.5% | 467.82 ± 1.3% | 5523.39 ± 0.6% | 252.28 ± 2.3% | 0.99 | 1.00 | 2.88 | 1.56 |
| a field path | 39 | 211.57 ± 3.0% | 212.23 ± 0.4% | 233.87 ± 0.3% | 96.18 ± 3.1% | 228.75 ± 1.1% | 734.21 ± 0.7% | 5877.93 ± 0.5% | 211.46 ± 0.9% | 1.00 | 1.00 | 2.20 | 0.92 |
| literal: a word | 7 | 397.16 ± 0.4% | 402.99 ± 4.1% | 480.59 ± 0.1% | 662.34 ± 1.5% | 799.50 ± 1.4% | 1606.22 ± 0.6% | 33371.46 ± 8.8% | 397.19 ± 0.5% | 0.99 | 1.00 | 0.60 | 0.50 |
| literal: a word that is not there | 8 | 390.04 ± 0.2% | 396.18 ± 0.2% | 471.85 ± 0.1% | 608.63 ± 1.6% | 760.44 ± 38.2% | 1491.50 ± 0.5% | 32935.34 ± 1.2% | 390.23 ± 0.2% | 0.98 | 1.00 | 0.64 | 0.51 |
| literal: one of four words | 26 | 277.58 ± 0.1% | 293.49 ± 0.2% | 336.68 ± 0.1% | 58.73 ± 0.9% | 294.76 ± 32.4% | 594.77 ± 6.2% | 17164.27 ± 2.9% | 277.41 ± 3.1% | 0.95 | 1.00 | 4.73 | 0.94 |
| literal: a word in any case | 11 | 245.36 ± 0.1% | 248.77 ± 0.1% | 278.46 ± 0.3% | 19.68 ± 0.7% | 831.08 ± 1.6% | refused | 25675.04 ± 1.7% | 245.06 ± 0.2% | 0.99 | 1.00 | 12.47 | 0.30 |
| literal: an href attribute | 12 | 301.18 ± 0.3% | 304.52 ± 0.3% | 352.58 ± 0.1% | 50.76 ± 0.9% | 575.48 ± 1.6% | 1278.42 ± 0.7% | 24463.17 ± 0.2% | 301.01 ± 0.2% | 0.99 | 1.00 | 5.93 | 0.52 |
| literal: a word, second text | 10 | 377.51 ± 0.3% | 383.43 ± 0.2% | 455.26 ± 0.4% | 545.57 ± 0.9% | 652.45 ± 36.9% | 1346.79 ± 0.6% | 30736.99 ± 0.3% | 377.64 ± 0.2% | 0.98 | 1.00 | 0.69 | 0.58 |
| class: two capitalized words | 23 | 327.86 ± 0.6% | 334.71 ± 0.5% | 387.38 ± 0.7% | 123.90 ± 1.8% | 592.46 ± 27.6% | 1275.25 ± 1.2% | 7841.05 ± 0.6% | 327.53 ± 0.8% | 0.98 | 1.00 | 2.65 | 0.55 |
| class: a word that ends in ing | 9 | 383.60 ± 10.1% | 394.13 ± 23.9% | 469.02 ± 0.3% | 152.34 ± 2.0% | 861.41 ± 1.9% | 1915.77 ± 0.3% | 19128.52 ± 0.8% | 383.88 ± 0.2% | 0.97 | 1.00 | 2.52 | 0.45 |
| class: a word in capitals | 16 | 352.19 ± 0.2% | 359.72 ± 0.4% | 421.58 ± 0.2% | 157.57 ± 0.9% | 894.78 ± 14.0% | 1783.87 ± 2.8% | 10418.07 ± 9.4% | 352.14 ± 0.2% | 0.98 | 1.00 | 2.24 | 0.39 |
| class: a number | 6 | 398.71 ± 0.2% | 407.61 ± 1.9% | 488.74 ± 0.4% | 49.29 ± 0.9% | 1668.54 ± 2.0% | 3044.48 ± 3.9% | 25902.78 ± 0.2% | 398.91 ± 0.4% | 0.98 | 1.00 | 8.09 | 0.24 |
| class: two capitalized words, second text | 23 | 326.43 ± 0.8% | 334.10 ± 0.5% | 385.56 ± 0.6% | 121.41 ± 0.7% | 596.75 ± 1.3% | 1200.79 ± 0.9% | 7843.08 ± 0.4% | 326.67 ± 0.3% | 0.98 | 1.00 | 2.69 | 0.55 |
| other: a word between two words | 13 | 367.82 ± 0.2% | 371.22 ± 0.2% | 436.11 ± 0.2% | 158.25 ± 1.1% | 584.34 ± 1.6% | 1348.92 ± 0.4% | 17407.52 ± 1.9% | 368.33 ± 0.7% | 0.99 | 1.00 | 2.32 | 0.63 |
| other: a number before a unit, second text | 15 | 319.09 ± 0.2% | 329.83 ± 3.1% | 383.89 ± 0.3% | 45.92 ± 4.2% | 726.55 ± 13.3% | 1462.13 ± 0.7% | 14772.94 ± 6.9% | 318.63 ± 0.5% | 0.97 | 1.00 | 6.95 | 0.44 |
| other: a heading's start tag | 13 | 297.23 ± 0.1% | 299.30 ± 6.3% | 351.79 ± 0.1% | 48.33 ± 0.2% | 705.99 ± 15.2% | 1363.59 ± 1.9% | 20500.38 ± 11.1% | 297.40 ± 0.3% | 0.99 | 1.00 | 6.15 | 0.42 |
| other: a whole word | 11 | 370.90 ± 0.4% | 374.95 ± 3.9% | 453.23 ± 3.8% | 147.07 ± 0.7% | 683.39 ± 5.8% | 1344.83 ± 0.5% | 30051.41 ± 2.6% | 370.89 ± 0.6% | 0.99 | 1.00 | 2.52 | 0.54 |
| other: a line's first word, second text | 17 | 363.15 ± 0.4% | 371.19 ± 3.6% | 435.26 ± 0.5% | 150.72 ± 0.8% | 807.80 ± 13.4% | refused | refused | 362.77 ± 0.4% | 0.98 | 1.00 | 2.41 | 0.45 |
| other: fourteen octets before an x | 16 | 106.59 ± 0.3% | 140.90 ± 0.2% | 157.07 ± 1.7% | 17.77 ± 5.7% | 524.11 ± 8.0% | 567.21 ± 5.8% | 15678.56 ± 2.3% | 106.74 ± 0.1% | 0.76 | 1.00 | 6.00 | 0.20 |
| other: a Greek word | 8 | 387.00 ± 0.2% | 399.88 ± 0.6% | 479.72 ± 0.2% | 62.65 ± 0.8% | 1647.26 ± 2.1% | 2802.61 ± 0.4% | refused | 386.57 ± 0.2% | 0.97 | 1.00 | 6.18 | 0.23 |

