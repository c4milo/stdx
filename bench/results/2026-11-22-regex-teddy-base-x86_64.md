# bench-regex

| Field | Value |
|---|---|
| Commit | 988748a |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45024984481 |
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
| literal: a word | 217 | 44158.94 ± 0.4% | 1027.67 ± 0.5% | 31.38 ± 0.4% | 40338.62 ± 0.4% | 11877.10 ± 2.2% | 12.89 ± 0.8% | 104.28 ± 1.0% | 44092.95 ± 0.6% | 42.97 | 1.00 | 1.09 | 3.72 |
| literal: a word that is not there | 0 | 61734.39 ± 6.4% | 1038.95 ± 0.7% | 30.81 ± 8.5% | 45820.29 ± 9.1% | 43662.87 ± 4.6% | 12.74 ± 1.2% | 98.57 ± 16.6% | 61556.90 ± 1.2% | 59.42 | 1.00 | 1.35 | 1.41 |
| literal: one of four words | 661 | 8325.82 ± 1.3% | 1005.48 ± 0.7% | 17.16 ± 0.4% | 11503.65 ± 0.4% | 24.21 ± 0.6% | 4.48 ± 0.1% | 8.65 ± 2.3% | 8292.75 ± 3.7% | 8.28 | 1.00 | 0.72 | 343.87 |
| literal: a word in any case | 217 | 37726.47 ± 0.3% | 1028.83 ± 0.8% | 24.38 ± 10.7% | 11432.79 ± 0.5% | 47.63 ± 8.9% | refused | differs | 37485.40 ± 0.8% | 36.67 | 1.01 | 3.30 | 792.05 |
| literal: an href attribute | 33 | 44650.54 ± 4.8% | 1032.68 ± 0.2% | 30.21 ± 0.6% | 35259.67 ± 2.8% | 2926.89 ± 2.9% | 9.68 ± 0.2% | 91.52 ± 0.7% | 44722.16 ± 2.0% | 43.24 | 1.00 | 1.27 | 15.26 |
| literal: a word, second text | 123 | 47596.78 ± 0.9% | 1031.72 ± 0.9% | 30.92 ± 0.3% | 39975.49 ± 0.7% | 10537.20 ± 8.0% | 14.48 ± 0.2% | 88.73 ± 1.3% | 47700.12 ± 0.6% | 46.13 | 1.00 | 1.19 | 4.52 |
| class: two capitalized words | 1331 | 906.80 ± 0.5% | 949.11 ± 0.2% | 28.96 ± 0.4% | 575.50 ± 0.4% | 44.54 ± 0.1% | 11.06 ± 0.2% | 79.31 ± 0.6% | 906.80 ± 0.4% | 0.96 | 1.00 | 1.58 | 20.36 |
| class: a word that ends in ing | 3399 | 874.34 ± 0.3% | 874.00 ± 0.6% | 20.70 ± 0.6% | 540.91 ± 0.1% | 32.59 ± 7.7% | 6.22 ± 2.9% | 20.50 ± 5.3% | 872.53 ± 0.5% | 1.00 | 1.00 | 1.62 | 26.83 |
| class: a word in capitals | 2332 | 1140.72 ± 2.9% | 930.78 ± 7.3% | 30.15 ± 13.9% | 567.11 ± 0.3% | 47.13 ± 4.9% | 12.49 ± 0.4% | 101.64 ± 0.2% | 1152.84 ± 1.0% | 1.23 | 0.99 | 2.01 | 24.20 |
| class: a number | 8288 | 1855.55 ± 0.4% | 790.89 ± 0.9% | 27.63 ± 0.2% | 1824.95 ± 0.4% | 44.94 ± 13.0% | 0.39 ± 0.3% | 72.57 ± 0.3% | 1863.08 ± 0.9% | 2.35 | 1.00 | 1.02 | 41.29 |
| class: two capitalized words, second text | 5359 | 689.85 ± 15.0% | 686.61 ± 18.7% | 26.35 ± 29.2% | 479.87 ± 0.4% | 39.03 ± 11.8% | 12.73 ± 1.1% | 73.51 ± 13.8% | 689.76 ± 2.0% | 1.00 | 1.00 | 1.44 | 17.67 |
| other: a word between two words | 6104 | 843.79 ± 2.5% | 735.97 ± 2.2% | 26.24 ± 3.0% | 825.40 ± 2.7% | 126.06 ± 13.4% | 8.57 ± 0.8% | 82.46 ± 5.0% | 844.04 ± 0.4% | 1.15 | 1.00 | 1.02 | 6.69 |
| other: a number before a unit, second text | 1481 | 10641.28 ± 0.5% | 979.36 ± 0.4% | 28.93 ± 3.5% | 9173.23 ± 0.8% | 45.72 ± 0.3% | 13.30 ± 0.6% | 78.17 ± 0.7% | 10628.95 ± 5.2% | 10.87 | 1.00 | 1.16 | 232.76 |
| other: a heading's start tag | 110 | 25818.55 ± 0.1% | 1024.08 ± 0.4% | 30.66 ± 0.5% | 2601.20 ± 2.8% | 2003.82 ± 9.9% | 11.82 ± 0.6% | 107.03 ± 0.3% | 25807.97 ± 0.4% | 25.21 | 1.00 | 9.93 | 12.88 |
| other: a whole word | 217 | 31530.88 ± 0.2% | 1027.83 ± 8.6% | 29.67 ± 1.1% | 29346.36 ± 0.5% | 54.53 ± 1.2% | 11.12 ± 0.1% | 63.59 ± 0.5% | 31505.81 ± 3.5% | 30.68 | 1.00 | 1.07 | 578.19 |
| other: a line's first word, second text | 3716 | 2612.26 ± 1.1% | 852.72 ± 0.5% | 36.50 ± 0.5% | 2363.35 ± 3.6% | 69.93 ± 5.6% | refused | refused | 2611.87 ± 1.1% | 3.06 | 1.00 | 1.11 | 37.36 |
| other: fourteen octets before an x | 87 | 37525.07 ± 0.6% | 1.76 ± 0.7% | 1.65 ± 1.9% | 3447.93 ± 0.9% | 11.69 ± 0.7% | differs | 21.01 ± 1.7% | 37503.93 ± 0.2% | 21299.42 | 1.00 | 10.88 | 3209.15 |
| other: a Greek word | 21815 | 467.49 ± 0.4% | 334.96 ± 0.2% | 34.68 ± 3.0% | 307.56 ± 0.3% | 56.79 ± 6.5% | differs | refused | 466.75 ± 3.3% | 1.40 | 1.00 | 1.52 | 8.23 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.00 ± 0.6% | 31.04 ± 0.8% | 0.62 ± 6.9% | 25.59 ± 0.2% | 2.77 ± 4.7% | differs | 4.34 ± 7.1% | 31.13 ± 3.2% | 1.00 | 1.00 | 1.21 | 11.20 |
| a UUID | 32895 | 25.62 ± 0.2% | 25.58 ± 0.5% | 0.74 ± 1.1% | 19.17 ± 1.7% | 3.09 ± 2.0% | 0.53 ± 1.2% | 3.79 ± 24.7% | 25.50 ± 16.3% | 1.00 | 1.00 | 1.34 | 8.29 |
| an IPv4 address | 33176 | 44.93 ± 2.2% | 44.28 ± 3.0% | 2.36 ± 0.4% | 36.36 ± 0.5% | 7.11 ± 8.0% | differs | 4.01 ± 0.7% | 44.98 ± 1.1% | 1.01 | 1.00 | 1.24 | 6.32 |
| a date and time | 32954 | 39.05 ± 0.4% | 39.04 ± 0.6% | 1.77 ± 4.1% | 29.60 ± 0.3% | 8.54 ± 0.7% | 0.92 ± 4.1% | 7.97 ± 0.8% | 39.07 ± 0.4% | 1.00 | 1.00 | 1.32 | 4.58 |
| a field path | 32606 | 35.16 ± 2.2% | 35.12 ± 1.1% | 0.94 ± 0.4% | 28.91 ± 0.3% | 3.56 ± 1.2% | differs | 3.06 ± 0.5% | 35.15 ± 0.3% | 1.00 | 1.00 | 1.22 | 9.87 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.20 ± 0.7% | 11.27 ± 0.9% | 10.84 ± 5.9% | 13.35 ± 0.9% | 5.92 ± 1.7% | 0.76 ± 0.2% | none | 11.27 ± 0.7% | 0.99 | 0.99 | 0.84 | 1.89 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 323.94 ± 0.4% | 326.20 ± 0.3% | 379.19 ± 0.3% | 101.86 ± 1.3% | 245.08 ± 2.2% | 709.53 ± 3.5% | 4846.06 ± 12.1% | 323.75 ± 8.3% | 0.99 | 1.00 | 3.18 | 1.32 |
| a UUID | 62 | 233.42 ± 0.4% | 234.78 ± 0.4% | 267.64 ± 0.3% | 58.32 ± 1.2% | 117.69 ± 4.5% | 253.75 ± 6.6% | 5201.13 ± 0.0% | 233.41 ± 0.2% | 0.99 | 1.00 | 4.00 | 1.98 |
| an IPv4 address | 29 | 533.31 ± 0.7% | 538.68 ± 0.4% | 699.49 ± 0.2% | 88.23 ± 0.4% | 150.22 ± 1.4% | 385.27 ± 0.7% | 8840.13 ± 1.1% | 533.85 ± 1.0% | 0.99 | 1.00 | 6.04 | 3.55 |
| a date and time | 56 | 338.75 ± 0.3% | 341.32 ± 0.2% | 399.00 ± 2.3% | 87.17 ± 2.8% | 162.69 ± 3.5% | 480.05 ± 1.9% | 5283.83 ± 5.8% | 338.86 ± 0.4% | 0.99 | 1.00 | 3.89 | 2.08 |
| a field path | 39 | 372.09 ± 0.3% | 375.14 ± 5.0% | 446.24 ± 0.2% | 96.89 ± 2.1% | 228.72 ± 1.8% | 739.27 ± 5.7% | 5837.10 ± 1.5% | 372.51 ± 0.1% | 0.99 | 1.00 | 3.84 | 1.63 |
| literal: a word | 7 | 949.64 ± 0.2% | 985.01 ± 0.8% | 1639.76 ± 0.7% | 657.42 ± 0.9% | 793.41 ± 2.8% | 1580.81 ± 11.7% | 34622.94 ± 6.1% | 948.12 ± 0.4% | 0.96 | 1.00 | 1.44 | 1.20 |
| literal: a word that is not there | 8 | 890.44 ± 0.2% | 925.46 ± 0.4% | 1528.45 ± 0.5% | 604.95 ± 4.4% | 765.03 ± 1.7% | 1482.78 ± 0.9% | 32644.50 ± 2.9% | 888.55 ± 7.2% | 0.96 | 1.00 | 1.47 | 1.16 |
| literal: one of four words | 26 | 483.86 ± 7.1% | 525.64 ± 8.3% | 680.63 ± 5.4% | 58.15 ± 1.6% | 294.36 ± 18.3% | 592.57 ± 0.5% | 15824.67 ± 0.8% | 485.00 ± 0.7% | 0.92 | 1.00 | 8.32 | 1.64 |
| literal: a word in any case | 11 | 814.39 ± 4.4% | 853.76 ± 10.7% | 1331.77 ± 0.3% | 19.83 ± 0.7% | 828.61 ± 3.0% | refused | 21920.03 ± 20.4% | 802.40 ± 6.1% | 0.95 | 1.01 | 41.06 | 0.98 |
| literal: an href attribute | 12 | 488.94 ± 0.3% | 496.30 ± 0.4% | 635.94 ± 0.7% | 50.47 ± 5.7% | 577.54 ± 6.6% | 1273.49 ± 0.6% | 24153.86 ± 2.8% | 489.31 ± 0.4% | 0.99 | 1.00 | 9.69 | 0.85 |
| literal: a word, second text | 10 | 838.18 ± 0.7% | 870.07 ± 6.9% | 1367.92 ± 6.3% | 538.85 ± 0.3% | 665.92 ± 3.3% | 1329.68 ± 4.4% | 29563.66 ± 0.7% | 838.72 ± 7.0% | 0.96 | 1.00 | 1.56 | 1.26 |
| class: two capitalized words | 23 | 520.46 ± 0.4% | 539.53 ± 0.4% | 688.93 ± 0.6% | 123.37 ± 0.4% | 602.87 ± 2.0% | 1264.50 ± 1.1% | 7856.70 ± 9.8% | 520.61 ± 7.0% | 0.96 | 1.00 | 4.22 | 0.86 |
| class: a word that ends in ing | 9 | 825.16 ± 8.7% | 871.06 ± 15.1% | 1342.69 ± 5.2% | 154.64 ± 0.7% | 868.23 ± 38.9% | 1894.52 ± 5.0% | 19185.94 ± 0.3% | 825.84 ± 0.2% | 0.95 | 1.00 | 5.34 | 0.95 |
| class: a word in capitals | 16 | 626.07 ± 8.6% | 649.47 ± 1.1% | 879.10 ± 3.6% | 158.04 ± 2.2% | 884.33 ± 15.1% | 1771.20 ± 2.5% | 10349.00 ± 7.7% | 624.37 ± 2.5% | 0.96 | 1.00 | 3.96 | 0.71 |
| class: a number | 6 | 903.05 ± 5.4% | 950.25 ± 5.3% | 1533.64 ± 4.2% | 49.04 ± 2.3% | 1662.00 ± 0.9% | 3008.24 ± 2.5% | 26084.05 ± 0.3% | 902.54 ± 4.8% | 0.95 | 1.00 | 18.42 | 0.54 |
| class: two capitalized words, second text | 23 | 521.10 ± 1.4% | 540.02 ± 1.1% | 689.47 ± 0.9% | 122.00 ± 13.5% | 601.39 ± 10.6% | 1248.38 ± 12.7% | 7854.64 ± 0.3% | 521.17 ± 0.6% | 0.96 | 1.00 | 4.27 | 0.87 |
| other: a word between two words | 13 | 747.11 ± 1.9% | 756.75 ± 0.5% | 1100.93 ± 0.5% | 158.98 ± 0.7% | 585.53 ± 20.2% | 1321.12 ± 4.1% | 17144.70 ± 1.3% | 747.02 ± 1.1% | 0.99 | 1.00 | 4.70 | 1.28 |
| other: a number before a unit, second text | 15 | 635.76 ± 0.5% | 678.48 ± 0.3% | 935.65 ± 0.9% | 45.78 ± 1.9% | 729.40 ± 0.8% | 1411.65 ± 4.4% | 16823.44 ± 0.4% | 634.74 ± 0.3% | 0.94 | 1.00 | 13.89 | 0.87 |
| other: a heading's start tag | 13 | 472.96 ± 0.4% | 477.90 ± 0.3% | 609.80 ± 0.5% | 48.22 ± 0.6% | 714.20 ± 1.5% | 1372.56 ± 0.5% | 20763.50 ± 0.5% | 472.46 ± 0.1% | 0.99 | 1.00 | 9.81 | 0.66 |
| other: a whole word | 11 | 841.09 ± 0.5% | 866.95 ± 0.8% | 1347.03 ± 0.1% | 142.80 ± 1.2% | 681.69 ± 22.8% | 1327.02 ± 1.4% | 29326.70 ± 1.5% | 839.74 ± 15.8% | 0.97 | 1.00 | 5.89 | 1.23 |
| other: a line's first word, second text | 17 | 720.54 ± 0.5% | 746.44 ± 1.9% | 1074.79 ± 1.3% | 149.95 ± 0.7% | 811.46 ± 2.2% | refused | refused | 719.58 ± 0.5% | 0.97 | 1.00 | 4.81 | 0.89 |
| other: fourteen octets before an x | 16 | 125.81 ± 0.6% | 172.67 ± 0.8% | 199.97 ± 0.6% | 18.24 ± 0.9% | 525.36 ± 18.4% | 573.42 ± 0.8% | 15531.90 ± 0.7% | 125.83 ± 0.7% | 0.73 | 1.00 | 6.90 | 0.24 |
| other: a Greek word | 8 | 828.59 ± 0.6% | 887.46 ± 0.4% | 1421.50 ± 0.5% | 62.35 ± 0.3% | 1654.38 ± 1.6% | 2694.77 ± 0.3% | refused | 828.82 ± 0.4% | 0.93 | 1.00 | 13.29 | 0.50 |

