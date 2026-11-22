# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063442063 |
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
| literal: a word | 217 | 43066.42 ± 0.5% | 1029.92 ± 0.5% | 32.54 ± 0.8% | 40392.56 ± 0.3% | 12036.04 ± 4.7% | 12.75 ± 0.4% | 104.39 ± 0.4% | 43037.62 ± 0.7% | 41.82 | 1.00 | 1.07 | 3.58 |
| literal: a word that is not there | 0 | 60363.93 ± 0.2% | 1038.36 ± 0.2% | 31.96 ± 0.4% | 45434.48 ± 0.9% | 42342.78 ± 3.7% | 12.65 ± 0.2% | 97.27 ± 0.9% | 60296.48 ± 0.4% | 58.13 | 1.00 | 1.33 | 1.43 |
| literal: one of four words | 661 | 12785.12 ± 0.2% | 1005.33 ± 0.3% | 16.86 ± 0.6% | 11500.57 ± 0.1% | 24.21 ± 0.5% | 4.48 ± 0.4% | 8.02 ± 2.4% | 13268.43 ± 0.1% | 12.72 | 0.96 | 1.11 | 528.16 |
| literal: a word in any case | 217 | 37147.45 ± 0.6% | 1028.48 ± 0.3% | 24.42 ± 2.0% | 11375.11 ± 0.7% | 47.60 ± 13.4% | refused | differs | 37045.42 ± 0.5% | 36.12 | 1.00 | 3.27 | 780.37 |
| literal: an href attribute | 33 | 44583.63 ± 4.5% | 1034.39 ± 2.2% | 31.32 ± 3.7% | 35000.93 ± 0.9% | 2933.70 ± 5.2% | 9.57 ± 0.5% | 91.45 ± 0.3% | 44730.38 ± 0.5% | 43.10 | 1.00 | 1.27 | 15.20 |
| literal: a word, second text | 123 | 47412.98 ± 5.3% | 1028.86 ± 7.3% | 32.16 ± 0.5% | 41041.14 ± 1.1% | 10887.51 ± 8.0% | 14.49 ± 1.0% | 87.91 ± 0.2% | 47383.54 ± 0.5% | 46.08 | 1.00 | 1.16 | 4.35 |
| class: two capitalized words | 1331 | 915.39 ± 0.5% | 950.40 ± 1.3% | 30.01 ± 3.1% | 577.24 ± 13.5% | 44.69 ± 7.3% | 10.94 ± 0.1% | 80.21 ± 0.6% | 913.76 ± 0.3% | 0.96 | 1.00 | 1.59 | 20.48 |
| class: a word that ends in ing | 3399 | 875.31 ± 0.7% | 875.36 ± 0.1% | 20.87 ± 0.7% | 541.17 ± 0.6% | 32.72 ± 4.1% | 6.19 ± 0.1% | 20.17 ± 0.3% | 874.06 ± 0.7% | 1.00 | 1.00 | 1.62 | 26.75 |
| class: a word in capitals | 2332 | 1145.58 ± 1.4% | 929.13 ± 0.4% | 30.90 ± 3.1% | 564.61 ± 0.4% | 47.66 ± 5.7% | 12.41 ± 0.3% | 101.58 ± 0.6% | 1144.98 ± 1.8% | 1.23 | 1.00 | 2.03 | 24.04 |
| class: a number | 8288 | 1847.86 ± 3.0% | 793.32 ± 0.2% | 32.56 ± 0.1% | 1860.00 ± 0.4% | 46.10 ± 13.0% | 0.38 ± 0.2% | 73.47 ± 0.9% | 1870.86 ± 0.3% | 2.33 | 0.99 | 0.99 | 40.08 |
| class: two capitalized words, second text | 5359 | 691.11 ± 0.2% | 691.92 ± 0.2% | 27.09 ± 0.8% | 480.67 ± 0.4% | 38.78 ± 15.0% | 12.71 ± 0.2% | 74.27 ± 18.1% | 690.30 ± 3.1% | 1.00 | 1.00 | 1.44 | 17.82 |
| other: a word between two words | 6104 | 834.16 ± 0.8% | 738.78 ± 0.4% | 26.79 ± 8.0% | 834.34 ± 9.3% | 123.53 ± 21.4% | 8.47 ± 0.3% | 82.13 ± 0.5% | 834.26 ± 1.2% | 1.13 | 1.00 | 1.00 | 6.75 |
| other: a number before a unit, second text | 1481 | 10597.06 ± 13.8% | 977.90 ± 8.3% | 29.19 ± 3.7% | 9330.88 ± 0.6% | 45.61 ± 2.7% | 12.96 ± 0.7% | 78.19 ± 0.7% | 10565.70 ± 0.6% | 10.84 | 1.00 | 1.14 | 232.32 |
| other: a heading's start tag | 110 | 25660.47 ± 1.2% | 1024.99 ± 0.7% | 32.07 ± 0.5% | 2658.40 ± 1.8% | 1993.19 ± 9.6% | 11.69 ± 0.4% | 106.99 ± 5.8% | 25643.03 ± 2.9% | 25.03 | 1.00 | 9.65 | 12.87 |
| other: a whole word | 217 | 31004.34 ± 1.1% | 1027.41 ± 0.3% | 33.33 ± 2.0% | 29180.36 ± 5.3% | 54.22 ± 0.4% | 11.04 ± 0.8% | 62.87 ± 3.4% | 30998.88 ± 0.7% | 30.18 | 1.00 | 1.06 | 571.84 |
| other: a line's first word, second text | 3716 | 2621.01 ± 2.1% | 851.95 ± 0.4% | 36.42 ± 0.7% | 2437.19 ± 1.6% | 69.98 ± 8.0% | refused | refused | 2557.07 ± 3.9% | 3.08 | 1.03 | 1.08 | 37.46 |
| other: fourteen octets before an x | 87 | 37561.82 ± 0.4% | 1.66 ± 0.6% | 1.71 ± 0.6% | 3378.24 ± 3.1% | 11.73 ± 0.4% | differs | 21.78 ± 2.9% | 37412.99 ± 0.3% | 22664.66 | 1.00 | 11.12 | 3202.13 |
| other: a Greek word | 21815 | 466.88 ± 1.5% | 334.86 ± 1.4% | 34.43 ± 4.8% | 307.14 ± 1.8% | 55.21 ± 10.7% | differs | refused | 465.54 ± 21.1% | 1.39 | 1.00 | 1.52 | 8.46 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.79 ± 0.3% | 30.76 ± 0.7% | 0.55 ± 4.5% | 25.88 ± 0.1% | 2.83 ± 6.0% | differs | 4.02 ± 4.7% | 30.84 ± 1.0% | 1.00 | 1.00 | 1.19 | 10.86 |
| a UUID | 32895 | 25.81 ± 4.2% | 25.66 ± 0.8% | 0.75 ± 0.9% | 18.86 ± 4.9% | 3.07 ± 2.7% | 0.50 ± 0.7% | 3.81 ± 19.6% | 25.80 ± 14.5% | 1.01 | 1.00 | 1.37 | 8.40 |
| an IPv4 address | 33176 | 44.03 ± 4.3% | 43.92 ± 4.8% | 2.41 ± 7.6% | 36.62 ± 0.3% | 7.05 ± 4.5% | differs | 3.64 ± 3.0% | 44.23 ± 0.9% | 1.00 | 1.00 | 1.20 | 6.25 |
| a date and time | 32954 | 39.52 ± 0.8% | 39.45 ± 2.0% | 1.79 ± 5.1% | 29.62 ± 5.1% | 8.52 ± 0.3% | 0.90 ± 0.2% | 7.89 ± 0.4% | 39.53 ± 0.2% | 1.00 | 1.00 | 1.33 | 4.64 |
| a field path | 32606 | 34.77 ± 0.3% | 34.81 ± 0.1% | 0.96 ± 0.8% | 29.32 ± 0.9% | 3.56 ± 1.3% | differs | 2.94 ± 2.7% | 34.68 ± 0.4% | 1.00 | 1.00 | 1.19 | 9.78 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.31 ± 0.6% | 11.53 ± 0.9% | 11.52 ± 0.5% | 13.30 ± 0.8% | 5.84 ± 1.5% | 0.75 ± 0.7% | none | 11.37 ± 0.6% | 0.98 | 1.00 | 0.85 | 1.94 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 307.09 ± 0.5% | 308.10 ± 0.3% | 355.08 ± 0.6% | 100.51 ± 1.4% | 239.23 ± 7.9% | 678.81 ± 4.6% | 4824.09 ± 0.8% | 307.31 ± 1.0% | 1.00 | 1.00 | 3.06 | 1.28 |
| a UUID | 62 | 205.29 ± 0.3% | 206.07 ± 0.3% | 232.98 ± 1.3% | 57.29 ± 3.5% | 117.30 ± 2.7% | 248.68 ± 2.7% | 5179.88 ± 25.9% | 204.45 ± 5.2% | 1.00 | 1.00 | 3.58 | 1.75 |
| an IPv4 address | 29 | 562.05 ± 0.6% | 566.62 ± 1.2% | 748.78 ± 1.3% | 87.74 ± 0.9% | 145.34 ± 7.6% | 396.79 ± 5.3% | 8893.84 ± 0.7% | 560.34 ± 0.9% | 0.99 | 1.00 | 6.41 | 3.87 |
| a date and time | 56 | 400.48 ± 0.3% | 404.61 ± 0.5% | 484.91 ± 1.1% | 85.31 ± 1.2% | 159.40 ± 2.2% | 445.47 ± 2.7% | 5291.81 ± 1.7% | 400.87 ± 0.5% | 0.99 | 1.00 | 4.69 | 2.51 |
| a field path | 39 | 321.23 ± 1.0% | 323.06 ± 0.5% | 373.35 ± 0.6% | 96.12 ± 2.6% | 227.20 ± 5.7% | 714.74 ± 4.8% | 5785.61 ± 1.5% | 321.48 ± 2.1% | 0.99 | 1.00 | 3.34 | 1.41 |
| literal: a word | 7 | 943.11 ± 0.2% | 976.83 ± 7.7% | 1597.14 ± 0.3% | 663.91 ± 10.8% | 794.11 ± 0.6% | 1602.29 ± 4.2% | 32949.34 ± 2.5% | 943.01 ± 0.2% | 0.97 | 1.00 | 1.42 | 1.19 |
| literal: a word that is not there | 8 | 904.17 ± 0.4% | 934.32 ± 7.6% | 1502.41 ± 0.2% | 607.34 ± 0.4% | 764.59 ± 5.1% | 1498.48 ± 0.6% | 31544.34 ± 0.6% | 904.77 ± 0.6% | 0.97 | 1.00 | 1.49 | 1.18 |
| literal: one of four words | 26 | 468.44 ± 0.2% | 512.08 ± 0.4% | 656.51 ± 0.2% | 58.78 ± 3.2% | 293.26 ± 1.4% | 577.44 ± 1.1% | 15772.40 ± 2.7% | 468.29 ± 0.4% | 0.91 | 1.00 | 7.97 | 1.60 |
| literal: a word in any case | 11 | 696.03 ± 1.0% | 718.66 ± 1.4% | 1029.61 ± 0.5% | 19.90 ± 0.7% | 826.21 ± 40.6% | refused | 24919.85 ± 0.9% | 690.66 ± 1.0% | 0.97 | 1.01 | 34.98 | 0.84 |
| literal: an href attribute | 12 | 517.38 ± 8.2% | 528.67 ± 8.7% | 680.70 ± 6.0% | 50.29 ± 5.9% | 570.91 ± 7.8% | 1221.29 ± 3.9% | 22173.79 ± 7.9% | 519.05 ± 0.7% | 0.98 | 1.00 | 10.29 | 0.91 |
| literal: a word, second text | 10 | 835.79 ± 6.7% | 869.35 ± 0.1% | 1344.89 ± 10.8% | 543.84 ± 0.6% | 652.74 ± 5.4% | 1330.83 ± 3.7% | 28589.88 ± 4.0% | 835.78 ± 0.2% | 0.96 | 1.00 | 1.54 | 1.28 |
| class: two capitalized words | 23 | 617.43 ± 1.2% | 649.68 ± 1.7% | 867.13 ± 3.1% | 121.99 ± 0.6% | 594.58 ± 1.3% | 1214.57 ± 7.7% | 7742.49 ± 0.8% | 616.92 ± 0.8% | 0.95 | 1.00 | 5.06 | 1.04 |
| class: a word that ends in ing | 9 | 830.05 ± 0.4% | 895.11 ± 1.8% | 1387.04 ± 0.7% | 151.58 ± 1.5% | 850.16 ± 31.2% | 1866.72 ± 4.0% | 18884.97 ± 2.3% | 828.76 ± 4.8% | 0.93 | 1.00 | 5.48 | 0.98 |
| class: a word in capitals | 16 | 712.59 ± 0.6% | 748.61 ± 0.4% | 1073.66 ± 0.6% | 157.45 ± 2.4% | 896.80 ± 1.6% | 1640.66 ± 1.5% | 10167.27 ± 0.4% | 712.31 ± 0.5% | 0.95 | 1.00 | 4.53 | 0.79 |
| class: a number | 6 | 911.36 ± 0.8% | 973.98 ± 0.5% | 1604.32 ± 1.4% | 49.42 ± 0.7% | 1661.10 ± 2.4% | 2985.24 ± 4.4% | 23099.35 ± 0.4% | 912.04 ± 0.3% | 0.94 | 1.00 | 18.44 | 0.55 |
| class: two capitalized words, second text | 23 | 616.07 ± 0.9% | 650.05 ± 1.3% | 871.48 ± 2.1% | 120.69 ± 0.5% | 596.27 ± 2.3% | 1259.46 ± 3.5% | 7744.72 ± 0.1% | 618.74 ± 0.3% | 0.95 | 1.00 | 5.10 | 1.03 |
| other: a word between two words | 13 | 759.74 ± 0.4% | 780.84 ± 0.2% | 1120.57 ± 0.5% | 155.25 ± 0.8% | 580.99 ± 4.1% | 1333.63 ± 1.8% | 16445.63 ± 1.8% | 760.59 ± 0.4% | 0.97 | 1.00 | 4.89 | 1.31 |
| other: a number before a unit, second text | 15 | 598.28 ± 0.3% | 646.23 ± 0.4% | 870.63 ± 0.4% | 45.53 ± 0.6% | 728.22 ± 2.6% | 1450.97 ± 1.6% | 16478.69 ± 0.3% | 597.73 ± 0.4% | 0.93 | 1.00 | 13.14 | 0.82 |
| other: a heading's start tag | 13 | 515.27 ± 1.0% | 521.68 ± 0.1% | 692.22 ± 0.3% | 48.26 ± 0.4% | 709.13 ± 1.4% | 1395.63 ± 1.3% | 20036.14 ± 1.0% | 515.70 ± 0.3% | 0.99 | 1.00 | 10.68 | 0.73 |
| other: a whole word | 11 | 801.78 ± 5.9% | 824.64 ± 0.4% | 1231.18 ± 0.5% | 147.50 ± 7.4% | 682.88 ± 2.1% | 1363.05 ± 6.5% | 28748.12 ± 2.7% | 791.51 ± 1.4% | 0.97 | 1.01 | 5.44 | 1.17 |
| other: a line's first word, second text | 17 | 738.02 ± 14.8% | 786.51 ± 0.4% | 1138.46 ± 1.0% | 149.15 ± 1.6% | 794.96 ± 2.6% | refused | refused | 740.17 ± 31.3% | 0.94 | 1.00 | 4.95 | 0.93 |
| other: fourteen octets before an x | 16 | 126.08 ± 0.8% | 177.07 ± 0.9% | 206.65 ± 0.8% | 17.85 ± 0.5% | 521.87 ± 21.8% | 583.75 ± 3.6% | 15373.00 ± 8.4% | 125.99 ± 0.6% | 0.71 | 1.00 | 7.06 | 0.24 |
| other: a Greek word | 8 | 834.57 ± 0.3% | 910.14 ± 0.3% | 1428.22 ± 0.6% | 62.90 ± 0.9% | 1639.26 ± 15.9% | 2694.76 ± 9.4% | refused | 835.03 ± 0.9% | 0.92 | 1.00 | 13.27 | 0.51 |

