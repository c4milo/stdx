# bench-regex

| Field | Value |
|---|---|
| Commit | c519449 |
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
| literal: a word | 217 | 5273.84 ± 0.4% | 560.79 ± 0.5% | 28.92 ± 0.7% | 18533.92 ± 3.2% | 9265.48 ± 8.7% | 17.38 ± 0.4% | 84.01 ± 0.7% | 9.40 | 0.28 | 0.57 |
| literal: a word that is not there | 0 | 5371.00 ± 1.0% | 562.42 ± 0.2% | 28.90 ± 0.5% | 19722.74 ± 1.3% | 28793.66 ± 1.9% | 17.16 ± 0.9% | 79.67 ± 0.3% | 9.55 | 0.27 | 0.19 |
| literal: one of four words | 661 | 2450.67 ± 0.9% | 556.09 ± 0.2% | 15.06 ± 0.6% | 3977.88 ± 0.6% | 21.89 ± 0.1% | 5.43 ± 0.2% | 6.85 ± 3.7% | 4.41 | 0.62 | 111.93 |
| literal: a word in any case | 217 | 2698.24 ± 0.9% | 561.08 ± 0.4% | 22.17 ± 0.4% | 3972.40 ± 0.2% | 38.60 ± 0.1% | refused | differs | 4.81 | 0.68 | 69.91 |
| literal: an href attribute | 33 | 1612.41 ± 0.4% | 561.84 ± 0.3% | 27.49 ± 1.1% | 16714.26 ± 3.9% | 2262.16 ± 0.2% | 13.09 ± 0.3% | 73.79 ± 0.2% | 2.87 | 0.10 | 0.71 |
| literal: a word, second text | 123 | 4103.53 ± 1.3% | 566.67 ± 2.0% | 28.69 ± 0.9% | 18505.94 ± 2.1% | 7657.55 ± 6.7% | 20.23 ± 0.3% | 70.24 ± 0.5% | 7.24 | 0.22 | 0.54 |
| class: two capitalized words | 1331 | 1128.42 ± 0.6% | 546.60 ± 0.1% | 26.64 ± 0.3% | 587.32 ± 0.6% | 40.91 ± 12.6% | 14.74 ± 0.2% | 67.66 ± 0.2% | 2.06 | 1.92 | 27.58 |
| class: a word that ends in ing | 3399 | 522.68 ± 0.2% | 523.25 ± 0.1% | 18.70 ± 0.3% | 550.27 ± 0.1% | 29.59 ± 6.6% | 8.25 ± 0.2% | 18.42 ± 0.3% | 1.00 | 0.95 | 17.66 |
| class: a word in capitals | 2332 | 1497.25 ± 0.2% | 544.25 ± 0.2% | 28.23 ± 0.5% | 574.56 ± 0.1% | 43.73 ± 14.2% | 16.86 ± 0.4% | 82.64 ± 0.2% | 2.75 | 2.61 | 34.24 |
| class: a number | 8288 | 2189.89 ± 0.3% | 509.73 ± 0.1% | 28.68 ± 0.6% | 1590.88 ± 0.3% | 40.77 ± 16.6% | 0.52 ± 0.6% | 57.68 ± 0.5% | 4.30 | 1.38 | 53.71 |
| class: a distance, second text | 1481 | 1414.34 ± 0.3% | 546.73 ± 0.2% | 26.63 ± 0.4% | 5890.80 ± 0.4% | 40.99 ± 5.3% | 18.17 ± 0.3% | 65.89 ± 0.2% | 2.59 | 0.24 | 34.50 |
| other: a word between two words | 6104 | 481.12 ± 0.2% | 481.01 ± 0.3% | 24.04 ± 0.2% | 751.75 ± 0.4% | 103.51 ± 11.7% | 10.68 ± 0.1% | 68.36 ± 0.2% | 1.00 | 0.64 | 4.65 |
| other: a heading's start tag | 110 | 1414.61 ± 0.2% | 559.52 ± 0.4% | 27.91 ± 0.2% | 1728.84 ± 0.7% | 1584.90 ± 7.6% | 16.04 ± 0.5% | 86.22 ± 0.2% | 2.53 | 0.82 | 0.89 |
| other: a whole word | 217 | 561.89 ± 0.5% | 561.12 ± 0.5% | 30.18 ± 0.3% | 14457.00 ± 1.6% | 49.32 ± 0.2% | 13.42 ± 0.2% | 55.19 ± 0.4% | 1.00 | 0.04 | 11.39 |
| other: a line's first word, second text | 3716 | 518.39 ± 0.2% | 519.20 ± 0.4% | 31.68 ± 0.6% | 1763.83 ± 0.4% | 62.75 ± 8.5% | refused | refused | 1.00 | 0.29 | 8.26 |
| other: fourteen octets before an x | 87 | 1.53 ± 0.0% | 1.53 ± 0.0% | 1.53 ± 0.1% | 3957.31 ± 0.3% | 10.68 ± 0.3% | differs | 17.75 ± 0.2% | 1.00 | 0.00 | 0.14 |
| other: a Greek word | 21815 | 519.01 ± 0.6% | 356.63 ± 0.6% | 31.72 ± 0.4% | 294.62 ± 0.2% | 47.14 ± 11.8% | differs | refused | 1.46 | 1.76 | 11.01 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 20.19 ± 0.1% | 20.20 ± 0.1% | 0.50 ± 0.1% | 21.24 ± 0.3% | 2.77 ± 0.6% | differs | 4.06 ± 0.2% | 1.00 | 0.95 | 7.29 |
| a UUID | 32895 | 14.35 ± 0.7% | 14.33 ± 0.8% | 0.67 ± 0.1% | 16.02 ± 0.1% | 3.09 ± 0.2% | 0.72 ± 0.5% | 3.65 ± 0.8% | 1.00 | 0.90 | 4.64 |
| an IPv4 address | 33176 | 35.06 ± 0.5% | 34.98 ± 0.5% | 2.18 ± 0.2% | 32.53 ± 0.1% | 6.69 ± 0.3% | differs | 4.13 ± 0.2% | 1.00 | 1.08 | 5.24 |
| a date and time | 32954 | 23.91 ± 1.3% | 24.07 ± 0.9% | 1.52 ± 0.1% | 23.37 ± 0.1% | 7.07 ± 0.1% | 1.19 ± 0.1% | 7.11 ± 1.0% | 0.99 | 1.02 | 3.38 |
| a field path | 32606 | 24.64 ± 0.2% | 24.67 ± 0.1% | 0.82 ± 0.6% | 25.20 ± 0.3% | 3.49 ± 1.1% | differs | 2.96 ± 0.1% | 1.00 | 0.98 | 7.07 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 2.49 ± 0.8% | 2.54 ± 0.9% | 1.14 ± 0.2% | 11.24 ± 0.3% | 4.94 ± 1.1% | 0.91 ± 0.7% | none | 0.98 | 0.22 | 0.50 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx / stdx, no skip | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 257.37 ± 0.3% | 257.57 ± 0.2% | 336.18 ± 0.2% | 87.17 ± 1.5% | 221.56 ± 5.7% | 478.04 ± 3.4% | 3762.96 ± 2.4% | 1.00 | 2.95 | 1.16 |
| a UUID | 62 | 194.82 ± 0.2% | 195.24 ± 0.5% | 243.99 ± 0.2% | 46.30 ± 1.1% | 99.23 ± 1.4% | 184.23 ± 2.5% | 4362.72 ± 0.3% | 1.00 | 4.21 | 1.96 |
| an IPv4 address | 29 | 362.60 ± 0.4% | 363.69 ± 0.7% | 576.51 ± 0.3% | 75.43 ± 0.6% | 132.61 ± 1.3% | 296.21 ± 0.5% | 7555.36 ± 0.1% | 1.00 | 4.81 | 2.73 |
| a date and time | 56 | 256.13 ± 0.1% | 256.78 ± 0.3% | 339.08 ± 0.5% | 71.76 ± 0.4% | 136.98 ± 13.4% | 314.81 ± 0.8% | 5015.06 ± 0.3% | 1.00 | 3.57 | 1.87 |
| a field path | 39 | 277.15 ± 1.0% | 277.62 ± 0.3% | 388.41 ± 0.1% | 79.24 ± 0.3% | 206.95 ± 2.0% | 487.18 ± 0.6% | 4849.35 ± 0.2% | 1.00 | 3.50 | 1.34 |
| literal: a word | 7 | 565.60 ± 0.4% | 567.13 ± 0.5% | 1410.58 ± 0.2% | 522.45 ± 0.2% | 628.74 ± 2.5% | 935.29 ± 0.5% | 30807.38 ± 0.2% | 1.00 | 1.08 | 0.90 |
| literal: a word that is not there | 8 | 584.61 ± 0.4% | 585.59 ± 0.3% | 1329.97 ± 0.1% | 469.69 ± 0.2% | 610.00 ± 2.7% | 883.34 ± 0.5% | 29229.09 ± 0.3% | 1.00 | 1.24 | 0.96 |
| literal: one of four words | 26 | 396.17 ± 0.3% | 396.72 ± 0.2% | 608.31 ± 0.2% | 49.21 ± 0.6% | 241.93 ± 1.9% | 356.43 ± 0.4% | 15763.05 ± 0.3% | 1.00 | 8.05 | 1.64 |
| literal: a word in any case | 11 | 558.69 ± 0.7% | 560.89 ± 0.5% | 1137.91 ± 0.2% | 15.63 ± 0.4% | 654.31 ± 3.1% | refused | 23762.64 ± 0.6% | 1.00 | 35.74 | 0.85 |
| literal: an href attribute | 12 | 360.12 ± 0.2% | 361.05 ± 0.6% | 523.50 ± 0.5% | 45.30 ± 0.6% | 503.84 ± 1.7% | 778.37 ± 0.2% | 22242.43 ± 0.3% | 1.00 | 7.95 | 0.71 |
| literal: a word, second text | 10 | 559.17 ± 0.3% | 560.04 ± 0.3% | 1194.78 ± 0.2% | 416.75 ± 0.6% | 539.12 ± 15.7% | 804.85 ± 0.4% | 27388.95 ± 0.1% | 1.00 | 1.34 | 1.04 |
| class: two capitalized words | 23 | 343.76 ± 0.5% | 343.56 ± 0.5% | 580.65 ± 0.6% | 102.02 ± 0.7% | 502.01 ± 0.9% | 746.84 ± 0.8% | 6335.29 ± 0.1% | 1.00 | 3.37 | 0.68 |
| class: a word that ends in ing | 9 | 498.71 ± 0.2% | 499.51 ± 0.3% | 1112.79 ± 0.2% | 132.40 ± 0.8% | 755.48 ± 1.1% | 1103.70 ± 2.0% | 15833.38 ± 0.2% | 1.00 | 3.77 | 0.66 |
| class: a word in capitals | 16 | 373.90 ± 0.2% | 374.37 ± 0.3% | 739.38 ± 0.2% | 136.54 ± 1.0% | 749.54 ± 1.2% | 1009.44 ± 1.8% | 8329.97 ± 0.3% | 1.00 | 2.74 | 0.50 |
| class: a number | 6 | 477.49 ± 0.2% | 478.48 ± 0.3% | 1276.60 ± 0.1% | 41.81 ± 0.4% | 1403.13 ± 1.0% | 1825.85 ± 1.7% | 23086.37 ± 0.2% | 1.00 | 11.42 | 0.34 |
| class: a distance, second text | 15 | 431.64 ± 0.6% | 430.86 ± 0.4% | 795.97 ± 0.9% | 39.31 ± 1.1% | 638.22 ± 1.7% | 889.36 ± 0.0% | 15310.46 ± 0.2% | 1.00 | 10.98 | 0.68 |
| other: a word between two words | 13 | 483.86 ± 0.4% | 483.55 ± 0.3% | 929.01 ± 0.4% | 133.45 ± 1.0% | 502.76 ± 0.8% | 807.72 ± 0.2% | 14711.94 ± 0.1% | 1.00 | 3.63 | 0.96 |
| other: a heading's start tag | 13 | 345.40 ± 0.5% | 346.07 ± 0.4% | 501.35 ± 0.5% | 44.45 ± 0.2% | 630.31 ± 12.6% | 869.90 ± 2.6% | 18358.80 ± 0.4% | 1.00 | 7.77 | 0.55 |
| other: a whole word | 11 | 585.59 ± 0.5% | 587.39 ± 0.4% | 1213.82 ± 0.3% | 102.89 ± 0.5% | 558.40 ± 1.6% | 829.57 ± 0.3% | 26924.06 ± 0.2% | 1.00 | 5.69 | 1.05 |
| other: a line's first word, second text | 17 | 463.24 ± 0.3% | 463.41 ± 0.2% | 886.13 ± 0.2% | 128.15 ± 0.2% | 710.52 ± 2.1% | refused | refused | 1.00 | 3.61 | 0.65 |
| other: fourteen octets before an x | 16 | 150.80 ± 0.7% | 151.14 ± 0.2% | 182.13 ± 0.3% | 15.04 ± 0.4% | 452.43 ± 1.5% | 417.14 ± 0.8% | 13108.50 ± 0.3% | 1.00 | 10.03 | 0.33 |
| other: a Greek word | 8 | 501.08 ± 0.3% | 500.80 ± 0.4% | 1249.24 ± 0.7% | 59.52 ± 0.5% | 1379.96 ± 0.9% | 1812.96 ± 0.2% | refused | 1.00 | 8.42 | 0.36 |

