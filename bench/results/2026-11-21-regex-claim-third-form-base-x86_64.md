# bench-regex

| Field | Value |
|---|---|
| Commit | a697a7f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
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
| literal: a word | 217 | 4281.17 ± 3.6% | 596.53 ± 1.8% | 31.56 ± 0.3% | 40085.70 ± 1.6% | 12079.75 ± 3.5% | 12.86 ± 0.4% | 104.07 ± 3.7% | 7.18 | 0.11 | 0.35 |
| literal: a word that is not there | 0 | 4305.37 ± 0.1% | 601.22 ± 1.6% | 31.60 ± 0.6% | 45754.22 ± 9.8% | 43690.61 ± 0.2% | 12.78 ± 0.2% | 98.52 ± 0.5% | 7.16 | 0.09 | 0.10 |
| literal: one of four words | 661 | 1932.93 ± 0.7% | 575.78 ± 2.5% | 17.03 ± 0.3% | 11554.24 ± 0.5% | 23.89 ± 1.3% | 4.47 ± 0.3% | 8.67 ± 0.6% | 3.36 | 0.17 | 80.91 |
| literal: a word in any case | 217 | 2122.57 ± 0.6% | 586.15 ± 2.0% | 24.65 ± 0.3% | 11442.16 ± 0.3% | 47.04 ± 1.4% | refused | differs | 3.62 | 0.19 | 45.12 |
| literal: an href attribute | 33 | 1351.72 ± 0.4% | 589.45 ± 3.1% | 29.79 ± 0.3% | 35824.45 ± 0.3% | 3028.21 ± 4.5% | 9.70 ± 0.2% | 91.64 ± 0.4% | 2.29 | 0.04 | 0.45 |
| literal: a word, second text | 123 | 3607.61 ± 0.4% | 575.95 ± 0.1% | 31.24 ± 0.3% | 40935.79 ± 0.7% | 10968.96 ± 6.9% | 14.42 ± 0.3% | 88.70 ± 0.3% | 6.26 | 0.09 | 0.33 |
| class: two capitalized words | 1331 | 915.38 ± 0.3% | 551.89 ± 0.4% | 29.39 ± 0.2% | 576.63 ± 0.3% | 44.94 ± 0.8% | 11.05 ± 0.2% | 79.43 ± 0.4% | 1.66 | 1.59 | 20.37 |
| class: a word that ends in ing | 3399 | 523.09 ± 0.9% | 528.25 ± 3.0% | 20.85 ± 0.7% | 540.84 ± 0.1% | 33.10 ± 8.2% | 6.22 ± 4.6% | 20.55 ± 0.6% | 0.99 | 0.97 | 15.80 |
| class: a word in capitals | 2332 | 1149.72 ± 0.3% | 542.72 ± 0.2% | 30.76 ± 0.3% | 566.75 ± 0.6% | 48.33 ± 5.5% | 12.47 ± 0.1% | 102.47 ± 1.3% | 2.12 | 2.03 | 23.79 |
| class: a number | 8288 | 1653.72 ± 0.6% | 485.81 ± 0.2% | 32.18 ± 0.4% | 1844.33 ± 0.5% | 48.78 ± 14.1% | 0.39 ± 0.2% | 73.34 ± 0.8% | 3.40 | 0.90 | 33.90 |
| class: a distance, second text | 1481 | 1219.99 ± 0.7% | 555.39 ± 0.2% | 29.03 ± 0.2% | 9129.62 ± 0.6% | 46.03 ± 15.1% | 13.27 ± 0.9% | 77.96 ± 0.1% | 2.20 | 0.13 | 26.50 |
| other: a word between two words | 6104 | 475.70 ± 0.4% | 473.64 ± 0.4% | 26.47 ± 0.1% | 837.43 ± 0.4% | 127.73 ± 12.4% | 8.58 ± 0.2% | 82.28 ± 0.4% | 1.00 | 0.57 | 3.72 |
| other: a heading's start tag | 110 | 1258.92 ± 0.4% | 581.05 ± 2.1% | 30.93 ± 0.2% | 2659.14 ± 1.2% | 1993.22 ± 7.7% | 11.83 ± 0.2% | 107.23 ± 9.8% | 2.17 | 0.47 | 0.63 |
| other: a whole word | 217 | 603.30 ± 2.1% | 591.60 ± 2.0% | 32.35 ± 0.2% | 28794.34 ± 0.6% | 54.66 ± 0.6% | 11.18 ± 0.1% | 63.53 ± 0.2% | 1.02 | 0.02 | 11.04 |
| other: a line's first word, second text | 3716 | 519.29 ± 0.2% | 519.25 ± 0.2% | 36.86 ± 0.3% | 2445.58 ± 2.0% | 70.54 ± 4.9% | refused | refused | 1.00 | 0.21 | 7.36 |
| other: fourteen octets before an x | 87 | 1.75 ± 0.3% | 1.79 ± 0.8% | 1.69 ± 0.8% | 3452.44 ± 2.2% | 11.84 ± 5.8% | differs | 21.44 ± 1.3% | 0.98 | 0.00 | 0.15 |
| other: a Greek word | 21815 | 419.79 ± 3.7% | 298.81 ± 0.2% | 35.80 ± 0.3% | 307.71 ± 0.2% | 57.14 ± 10.2% | differs | refused | 1.40 | 1.36 | 7.35 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.64 ± 0.3% | 19.21 ± 6.1% | 0.60 ± 1.3% | 25.79 ± 1.2% | 2.89 ± 0.6% | differs | 4.30 ± 1.4% | 1.02 | 0.76 | 6.80 |
| a UUID | 32895 | 13.94 ± 2.9% | 14.10 ± 0.3% | 0.75 ± 0.5% | 18.89 ± 0.3% | 3.06 ± 1.1% | 0.52 ± 0.2% | 3.83 ± 8.8% | 0.99 | 0.74 | 4.56 |
| an IPv4 address | 33176 | 31.01 ± 1.2% | 31.16 ± 4.4% | 2.41 ± 0.8% | 36.47 ± 1.5% | 6.91 ± 8.1% | differs | 3.93 ± 0.6% | 0.99 | 0.85 | 4.49 |
| a date and time | 32954 | 22.71 ± 0.4% | 22.77 ± 0.1% | 1.79 ± 0.7% | 29.67 ± 0.4% | 8.51 ± 13.9% | 0.91 ± 1.4% | 8.06 ± 0.7% | 1.00 | 0.77 | 2.67 |
| a field path | 32606 | 23.58 ± 4.0% | 23.62 ± 0.3% | 0.95 ± 0.8% | 29.34 ± 0.2% | 3.57 ± 1.2% | differs | 3.09 ± 0.8% | 1.00 | 0.80 | 6.61 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 2.30 ± 0.5% | 2.36 ± 0.4% | 1.17 ± 0.5% | 13.54 ± 0.6% | 5.71 ± 8.4% | 0.75 ± 2.0% | none | 0.98 | 0.17 | 0.40 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.91 ± 5.3% | 244.38 ± 0.2% | 379.56 ± 0.5% | 102.19 ± 2.8% | 240.71 ± 4.1% | 725.92 ± 3.0% | 4797.32 ± 1.2% | 0.95 | 2.27 | 0.96 |
| a UUID | 62 | 185.24 ± 4.5% | 185.62 ± 0.1% | 268.40 ± 0.7% | 59.03 ± 1.3% | 119.00 ± 1.0% | 253.15 ± 2.1% | 5166.68 ± 0.6% | 1.00 | 3.14 | 1.56 |
| an IPv4 address | 29 | 327.33 ± 7.5% | 327.41 ± 0.3% | 713.34 ± 0.4% | 87.15 ± 1.1% | 147.10 ± 2.4% | 416.73 ± 3.8% | 8692.34 ± 12.7% | 1.00 | 3.76 | 2.23 |
| a date and time | 56 | 250.59 ± 4.4% | 249.96 ± 3.0% | 403.86 ± 0.4% | 85.30 ± 0.8% | 161.89 ± 2.4% | 475.66 ± 0.7% | 5239.05 ± 5.4% | 1.00 | 2.94 | 1.55 |
| a field path | 39 | 255.98 ± 0.3% | 256.16 ± 0.4% | 448.57 ± 0.3% | 94.17 ± 2.6% | 228.51 ± 3.0% | 741.62 ± 1.9% | 5785.57 ± 0.6% | 1.00 | 2.72 | 1.12 |
| literal: a word | 7 | 433.63 ± 0.5% | 433.98 ± 0.2% | 1704.92 ± 19.7% | 652.73 ± 0.9% | 791.43 ± 26.8% | 1470.76 ± 0.9% | 32935.11 ± 0.3% | 1.00 | 0.66 | 0.55 |
| literal: a word that is not there | 8 | 510.80 ± 0.5% | 510.74 ± 6.3% | 1601.14 ± 22.9% | 593.82 ± 10.1% | 763.46 ± 4.2% | 1389.82 ± 0.1% | 31275.72 ± 4.4% | 1.00 | 0.86 | 0.67 |
| literal: one of four words | 26 | 358.35 ± 0.1% | 356.90 ± 0.7% | 692.93 ± 7.7% | 58.12 ± 2.5% | 294.22 ± 4.5% | 560.02 ± 2.8% | 15526.86 ± 1.3% | 1.00 | 6.17 | 1.22 |
| literal: a word in any case | 11 | 458.68 ± 0.6% | 459.24 ± 0.2% | 1355.47 ± 0.7% | 19.24 ± 1.6% | 822.53 ± 5.1% | refused | 21080.07 ± 0.7% | 1.00 | 23.84 | 0.56 |
| literal: an href attribute | 12 | 341.55 ± 0.4% | 341.70 ± 0.2% | 645.76 ± 0.5% | 49.72 ± 1.3% | 572.99 ± 5.0% | 1238.57 ± 1.1% | 23304.09 ± 1.1% | 1.00 | 6.87 | 0.60 |
| literal: a word, second text | 10 | 537.77 ± 2.4% | 537.85 ± 0.3% | 1422.55 ± 0.4% | 527.01 ± 1.8% | 645.92 ± 4.5% | 1310.68 ± 1.2% | 28327.53 ± 2.2% | 1.00 | 1.02 | 0.83 |
| class: two capitalized words | 23 | 293.80 ± 0.3% | 294.30 ± 0.3% | 696.12 ± 0.4% | 120.92 ± 0.4% | 585.35 ± 31.8% | 1234.32 ± 2.6% | 7762.20 ± 0.8% | 1.00 | 2.43 | 0.50 |
| class: a word that ends in ing | 9 | 392.34 ± 0.2% | 392.49 ± 0.2% | 1383.14 ± 0.4% | 148.00 ± 0.5% | 854.43 ± 4.4% | 1807.55 ± 0.4% | 18568.25 ± 0.3% | 1.00 | 2.65 | 0.46 |
| class: a word in capitals | 16 | 300.53 ± 0.2% | 300.55 ± 0.9% | 894.60 ± 0.2% | 153.40 ± 9.1% | 872.27 ± 4.6% | 1681.22 ± 1.3% | 10339.22 ± 3.4% | 1.00 | 1.96 | 0.34 |
| class: a number | 6 | 351.72 ± 0.3% | 351.31 ± 0.2% | 1570.26 ± 0.1% | 48.45 ± 6.0% | 1657.41 ± 1.3% | 2935.11 ± 1.0% | 25515.00 ± 1.2% | 1.00 | 7.26 | 0.21 |
| class: a distance, second text | 15 | 361.39 ± 0.2% | 361.42 ± 0.3% | 957.95 ± 0.3% | 44.96 ± 6.8% | 728.33 ± 1.8% | 1423.46 ± 1.9% | 16393.65 ± 0.7% | 1.00 | 8.04 | 0.50 |
| other: a word between two words | 13 | 404.28 ± 0.2% | 404.55 ± 0.2% | 1136.59 ± 0.7% | 154.24 ± 0.3% | 585.38 ± 0.6% | 1290.80 ± 0.6% | 16487.16 ± 1.8% | 1.00 | 2.62 | 0.69 |
| other: a heading's start tag | 13 | 329.32 ± 0.8% | 329.61 ± 0.4% | 621.77 ± 0.6% | 47.76 ± 1.4% | 710.43 ± 2.3% | 1412.29 ± 1.4% | 20220.51 ± 0.5% | 1.00 | 6.90 | 0.46 |
| other: a whole word | 11 | 476.83 ± 0.4% | 476.50 ± 0.2% | 1394.38 ± 0.2% | 126.67 ± 1.8% | 688.81 ± 0.6% | 1366.20 ± 1.0% | 27890.47 ± 0.3% | 1.00 | 3.76 | 0.69 |
| other: a line's first word, second text | 17 | 498.70 ± 1.7% | 500.75 ± 0.4% | 1090.88 ± 0.3% | 146.86 ± 0.7% | 814.27 ± 46.3% | refused | refused | 1.00 | 3.40 | 0.61 |
| other: fourteen octets before an x | 16 | 147.67 ± 0.6% | 147.84 ± 0.2% | 199.25 ± 0.5% | 17.69 ± 1.0% | 519.98 ± 31.8% | 580.79 ± 4.1% | 15501.16 ± 0.1% | 1.00 | 8.35 | 0.28 |
| other: a Greek word | 8 | 375.35 ± 0.3% | 375.15 ± 0.1% | 1480.01 ± 0.4% | 62.57 ± 0.4% | 1665.30 ± 1.9% | 2739.83 ± 0.5% | refused | 1.00 | 6.00 | 0.23 |

