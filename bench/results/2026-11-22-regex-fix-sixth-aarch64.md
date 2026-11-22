# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063432984 |
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
| literal: a word | 217 | 15525.57 ± 0.8% | 1048.05 ± 0.3% | 28.73 ± 0.2% | 18428.24 ± 1.3% | 9157.94 ± 9.7% | 17.31 ± 0.3% | 86.32 ± 0.7% | 15531.24 ± 1.3% | 14.81 | 1.00 | 0.84 | 1.70 |
| literal: a word that is not there | 0 | 18347.33 ± 2.2% | 1054.96 ± 0.1% | 28.65 ± 0.5% | 19685.19 ± 2.6% | 27270.39 ± 2.8% | 17.15 ± 0.2% | 80.59 ± 0.6% | 18406.88 ± 1.2% | 17.39 | 1.00 | 0.93 | 0.67 |
| literal: one of four words | 661 | 5813.39 ± 0.3% | 1025.57 ± 0.4% | 15.05 ± 0.5% | 3977.82 ± 0.3% | 21.88 ± 0.2% | 5.37 ± 0.1% | 6.96 ± 0.3% | 5806.40 ± 0.3% | 5.67 | 1.00 | 1.46 | 265.69 |
| literal: a word in any case | 217 | 11672.01 ± 0.4% | 1044.72 ± 0.2% | 21.98 ± 0.5% | 3982.05 ± 0.4% | 38.63 ± 0.1% | refused | differs | 11675.19 ± 0.6% | 11.17 | 1.00 | 2.93 | 302.12 |
| literal: an href attribute | 33 | 16176.61 ± 0.6% | 1053.43 ± 0.2% | 27.72 ± 0.3% | 17130.43 ± 0.6% | 2264.82 ± 0.8% | 13.16 ± 0.4% | 75.50 ± 0.7% | 16119.34 ± 0.5% | 15.36 | 1.00 | 0.94 | 7.14 |
| literal: a word, second text | 123 | 15748.39 ± 1.0% | 1050.47 ± 0.2% | 28.22 ± 0.4% | 18655.82 ± 1.1% | 7667.75 ± 10.7% | 20.20 ± 0.4% | 70.23 ± 0.4% | 15807.55 ± 1.1% | 14.99 | 1.00 | 0.84 | 2.05 |
| class: two capitalized words | 1331 | 1106.83 ± 0.5% | 963.58 ± 0.1% | 26.48 ± 0.1% | 587.26 ± 0.3% | 40.96 ± 4.1% | 14.74 ± 0.2% | 67.84 ± 0.4% | 1106.23 ± 0.5% | 1.15 | 1.00 | 1.88 | 27.02 |
| class: a word that ends in ing | 3399 | 887.70 ± 0.1% | 889.85 ± 0.1% | 18.62 ± 0.1% | 550.55 ± 0.2% | 29.55 ± 3.4% | 8.17 ± 0.2% | 18.40 ± 0.2% | 887.31 ± 0.1% | 1.00 | 1.00 | 1.61 | 30.04 |
| class: a word in capitals | 2332 | 1459.72 ± 0.3% | 960.04 ± 0.2% | 28.03 ± 0.4% | 575.22 ± 0.1% | 43.79 ± 14.0% | 17.16 ± 0.3% | 83.16 ± 0.3% | 1455.67 ± 0.4% | 1.52 | 1.00 | 2.54 | 33.33 |
| class: a number | 8288 | 2120.70 ± 0.5% | 812.00 ± 0.2% | 28.26 ± 0.6% | 1804.28 ± 0.2% | 39.95 ± 15.4% | 0.55 ± 0.2% | 57.27 ± 0.2% | 2117.29 ± 0.3% | 2.61 | 1.00 | 1.18 | 53.08 |
| class: two capitalized words, second text | 5359 | 701.88 ± 0.3% | 702.15 ± 0.1% | 23.79 ± 0.2% | 489.12 ± 0.1% | 35.53 ± 14.9% | 17.10 ± 0.4% | 63.12 ± 0.2% | 701.71 ± 0.1% | 1.00 | 1.00 | 1.43 | 19.75 |
| other: a word between two words | 6104 | 748.52 ± 0.4% | 754.86 ± 0.1% | 23.97 ± 0.4% | 751.76 ± 0.2% | 110.99 ± 9.3% | 11.20 ± 0.2% | 69.36 ± 0.4% | 748.54 ± 0.2% | 0.99 | 1.00 | 1.00 | 6.74 |
| other: a number before a unit, second text | 1481 | 5339.49 ± 0.6% | 985.10 ± 0.4% | 26.31 ± 0.3% | 5923.65 ± 0.2% | 40.95 ± 0.2% | 18.17 ± 0.2% | 65.75 ± 0.2% | 5328.15 ± 0.4% | 5.42 | 1.00 | 0.90 | 130.41 |
| other: a heading's start tag | 110 | 12443.59 ± 0.5% | 1041.97 ± 0.1% | 27.45 ± 0.3% | 1722.70 ± 0.4% | 1587.11 ± 4.9% | 16.04 ± 0.4% | 87.85 ± 0.6% | 12451.68 ± 0.4% | 11.94 | 1.00 | 7.22 | 7.84 |
| other: a whole word | 217 | 13640.83 ± 0.7% | 1046.47 ± 0.2% | 30.08 ± 0.3% | 14709.27 ± 1.0% | 49.40 ± 0.3% | 13.12 ± 0.1% | 55.50 ± 0.4% | 13665.28 ± 0.8% | 13.04 | 1.00 | 0.93 | 276.16 |
| other: a line's first word, second text | 3716 | 1927.04 ± 0.2% | 869.68 ± 0.1% | 31.88 ± 0.4% | 1750.19 ± 0.6% | 61.23 ± 7.0% | refused | refused | 1921.70 ± 0.5% | 2.22 | 1.00 | 1.10 | 31.47 |
| other: fourteen octets before an x | 87 | 19075.18 ± 0.7% | 1.54 ± 0.2% | 1.54 ± 0.1% | 4052.41 ± 0.9% | 10.68 ± 0.2% | differs | 17.92 ± 0.2% | 19055.03 ± 0.5% | 12416.42 | 1.00 | 4.71 | 1785.29 |
| other: a Greek word | 21815 | 479.67 ± 0.5% | 323.24 ± 0.3% | 31.49 ± 0.2% | 294.10 ± 0.4% | 44.42 ± 9.0% | differs | refused | 478.92 ± 0.7% | 1.48 | 1.00 | 1.63 | 10.80 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.12 ± 0.3% | 28.11 ± 0.2% | 0.50 ± 0.4% | 21.37 ± 0.3% | 2.77 ± 0.7% | differs | 4.04 ± 0.2% | 28.12 ± 0.1% | 1.00 | 1.00 | 1.32 | 10.14 |
| a UUID | 32895 | 23.07 ± 0.1% | 23.05 ± 0.2% | 0.67 ± 0.1% | 14.79 ± 0.4% | 3.10 ± 0.7% | 0.73 ± 0.1% | 3.64 ± 0.6% | 23.07 ± 0.1% | 1.00 | 1.00 | 1.56 | 7.45 |
| an IPv4 address | 33176 | 41.51 ± 0.3% | 41.49 ± 0.3% | 2.20 ± 0.2% | 32.66 ± 0.3% | 6.69 ± 0.2% | differs | 4.10 ± 0.0% | 41.52 ± 0.3% | 1.00 | 1.00 | 1.27 | 6.20 |
| a date and time | 32954 | 34.86 ± 0.2% | 34.91 ± 0.1% | 1.52 ± 0.3% | 23.50 ± 0.1% | 7.09 ± 0.6% | 1.25 ± 0.4% | 7.10 ± 0.2% | 34.85 ± 0.1% | 1.00 | 1.00 | 1.48 | 4.92 |
| a field path | 32606 | 32.31 ± 0.4% | 32.30 ± 0.3% | 0.84 ± 0.0% | 25.55 ± 0.2% | 3.51 ± 1.5% | differs | 2.92 ± 0.2% | 32.25 ± 0.2% | 1.00 | 1.00 | 1.26 | 9.20 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.28 ± 0.3% | 10.29 ± 0.3% | 10.29 ± 0.2% | 11.64 ± 0.2% | 4.95 ± 1.2% | 0.94 ± 0.4% | none | 10.28 ± 0.2% | 1.00 | 1.00 | 0.88 | 2.08 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 278.02 ± 0.4% | 278.68 ± 0.5% | 325.96 ± 0.3% | 86.68 ± 0.6% | 224.60 ± 1.1% | 471.30 ± 0.5% | 3761.26 ± 0.2% | 277.86 ± 0.5% | 1.00 | 1.00 | 3.21 | 1.24 |
| a UUID | 62 | 197.88 ± 0.3% | 198.19 ± 0.3% | 224.05 ± 0.3% | 46.02 ± 0.9% | 100.54 ± 0.5% | 189.05 ± 3.1% | 4424.08 ± 0.7% | 197.77 ± 0.3% | 1.00 | 1.00 | 4.30 | 1.97 |
| an IPv4 address | 29 | 477.18 ± 0.5% | 479.87 ± 0.5% | 646.12 ± 0.9% | 76.93 ± 0.4% | 133.58 ± 1.3% | 299.13 ± 1.2% | 7498.50 ± 0.4% | 476.81 ± 0.3% | 0.99 | 1.00 | 6.20 | 3.57 |
| a date and time | 56 | 337.86 ± 0.2% | 340.19 ± 0.3% | 413.17 ± 0.4% | 72.29 ± 0.4% | 139.24 ± 1.4% | 334.22 ± 0.6% | 4938.93 ± 0.3% | 337.69 ± 0.2% | 0.99 | 1.00 | 4.67 | 2.43 |
| a field path | 39 | 285.90 ± 0.3% | 286.46 ± 0.4% | 336.75 ± 0.5% | 79.56 ± 1.6% | 209.44 ± 2.6% | 502.50 ± 4.2% | 4815.98 ± 3.5% | 285.61 ± 0.4% | 1.00 | 1.00 | 3.59 | 1.37 |
| literal: a word | 7 | 758.39 ± 0.4% | 783.16 ± 0.3% | 1309.08 ± 0.2% | 495.80 ± 0.1% | 640.89 ± 2.1% | 951.57 ± 0.3% | 29712.82 ± 0.1% | 758.91 ± 0.4% | 0.97 | 1.00 | 1.53 | 1.18 |
| literal: a word that is not there | 8 | 732.70 ± 0.2% | 756.25 ± 0.4% | 1233.73 ± 0.1% | 457.69 ± 0.4% | 611.92 ± 1.4% | 897.49 ± 0.3% | 28573.35 ± 0.1% | 732.29 ± 0.2% | 0.97 | 1.00 | 1.60 | 1.20 |
| literal: one of four words | 26 | 405.56 ± 0.9% | 442.48 ± 0.3% | 577.50 ± 0.5% | 49.98 ± 0.6% | 244.28 ± 1.1% | 368.69 ± 0.3% | 15385.95 ± 0.2% | 406.03 ± 0.6% | 0.92 | 1.00 | 8.11 | 1.66 |
| literal: a word in any case | 11 | 573.37 ± 0.3% | 590.76 ± 0.3% | 864.52 ± 0.2% | 15.63 ± 0.3% | 643.44 ± 4.7% | refused | 23278.27 ± 0.7% | 573.27 ± 0.1% | 0.97 | 1.00 | 36.67 | 0.89 |
| literal: an href attribute | 12 | 439.28 ± 0.7% | 445.65 ± 0.5% | 582.32 ± 0.8% | 45.48 ± 0.7% | 509.24 ± 1.1% | 773.58 ± 0.4% | 21286.74 ± 1.1% | 440.48 ± 1.0% | 0.99 | 1.00 | 9.66 | 0.86 |
| literal: a word, second text | 10 | 681.09 ± 0.1% | 704.76 ± 0.3% | 1113.11 ± 0.1% | 403.75 ± 1.3% | 546.45 ± 0.8% | 800.59 ± 0.5% | 26465.57 ± 0.2% | 681.47 ± 0.1% | 0.97 | 1.00 | 1.69 | 1.25 |
| class: two capitalized words | 23 | 510.47 ± 0.9% | 529.16 ± 0.7% | 728.15 ± 1.1% | 102.50 ± 0.1% | 510.47 ± 9.3% | 745.98 ± 0.8% | 6286.72 ± 0.2% | 510.49 ± 0.6% | 0.96 | 1.00 | 4.98 | 1.00 |
| class: a word that ends in ing | 9 | 708.49 ± 0.5% | 754.24 ± 0.8% | 1226.61 ± 0.3% | 131.86 ± 0.3% | 768.06 ± 1.9% | 1095.44 ± 0.7% | 15617.12 ± 0.1% | 710.01 ± 0.3% | 0.94 | 1.00 | 5.37 | 0.92 |
| class: a word in capitals | 16 | 603.80 ± 0.4% | 630.67 ± 0.3% | 930.98 ± 0.1% | 135.20 ± 0.6% | 761.26 ± 1.5% | 1037.89 ± 0.7% | 8280.53 ± 0.1% | 602.81 ± 0.4% | 0.96 | 1.00 | 4.47 | 0.79 |
| class: a number | 6 | 795.74 ± 0.2% | 836.43 ± 0.6% | 1450.42 ± 0.1% | 41.86 ± 0.6% | 1421.20 ± 1.3% | 1857.88 ± 1.1% | 22363.56 ± 0.0% | 795.34 ± 0.4% | 0.95 | 1.00 | 19.01 | 0.56 |
| class: two capitalized words, second text | 23 | 510.45 ± 0.2% | 529.36 ± 0.4% | 728.54 ± 0.6% | 99.67 ± 0.2% | 510.72 ± 0.5% | 737.03 ± 3.1% | 6292.77 ± 0.2% | 510.20 ± 0.2% | 0.96 | 1.00 | 5.12 | 1.00 |
| other: a word between two words | 13 | 648.77 ± 0.1% | 658.29 ± 0.5% | 996.50 ± 0.2% | 132.40 ± 1.0% | 513.10 ± 1.3% | 801.09 ± 0.4% | 14555.46 ± 0.1% | 649.09 ± 0.1% | 0.99 | 1.00 | 4.90 | 1.26 |
| other: a number before a unit, second text | 15 | 519.23 ± 0.4% | 553.40 ± 0.3% | 777.27 ± 0.1% | 39.43 ± 0.8% | 646.77 ± 1.3% | 885.89 ± 0.6% | 14954.90 ± 0.1% | 519.18 ± 0.4% | 0.94 | 1.00 | 13.17 | 0.80 |
| other: a heading's start tag | 13 | 440.17 ± 0.6% | 444.38 ± 1.2% | 584.03 ± 1.1% | 44.01 ± 0.2% | 644.44 ± 0.7% | 871.54 ± 0.1% | 17827.52 ± 0.1% | 440.36 ± 0.3% | 0.99 | 1.00 | 10.00 | 0.68 |
| other: a whole word | 11 | 709.71 ± 0.4% | 723.65 ± 0.6% | 1158.31 ± 0.2% | 118.94 ± 0.6% | 569.27 ± 1.8% | 813.51 ± 0.3% | 26419.09 ± 0.9% | 710.26 ± 0.1% | 0.98 | 1.00 | 5.97 | 1.25 |
| other: a line's first word, second text | 17 | 637.33 ± 0.9% | 662.61 ± 0.4% | 996.16 ± 0.6% | 128.56 ± 0.2% | 719.73 ± 0.9% | refused | refused | 634.46 ± 0.9% | 0.96 | 1.00 | 4.96 | 0.89 |
| other: fourteen octets before an x | 16 | 121.07 ± 0.5% | 163.65 ± 0.7% | 188.97 ± 1.5% | 15.13 ± 0.2% | 461.03 ± 2.1% | 403.20 ± 0.5% | 12736.09 ± 0.3% | 120.93 ± 0.7% | 0.74 | 1.00 | 8.00 | 0.26 |
| other: a Greek word | 8 | 739.81 ± 0.6% | 790.00 ± 0.5% | 1309.89 ± 0.3% | 59.05 ± 0.4% | 1407.45 ± 0.9% | 1833.56 ± 0.6% | refused | 739.24 ± 0.6% | 0.94 | 1.00 | 12.53 | 0.53 |

