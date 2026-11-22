# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
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
| literal: a word | 217 | 50975.43 ± 1.6% | 1052.01 ± 2.3% | 39.23 ± 2.2% | 35038.94 ± 19.3% | 13675.22 ± 3.7% | 14.09 ± 1.9% | 137.61 ± 3.6% | 50826.80 ± 1.9% | 48.46 | 1.00 | 1.45 | 3.73 |
| literal: a word that is not there | 0 | 72560.29 ± 3.2% | 1090.46 ± 2.3% | 39.89 ± 3.1% | 46634.42 ± 2.1% | 48816.40 ± 1.0% | 13.84 ± 2.0% | 124.17 ± 1.8% | 72167.07 ± 1.8% | 66.54 | 1.01 | 1.56 | 1.49 |
| literal: one of four words | 661 | 16070.72 ± 1.7% | 1042.98 ± 2.0% | 21.56 ± 3.0% | 12661.46 ± 3.0% | 33.34 ± 8.2% | 4.47 ± 1.2% | 11.20 ± 10.4% | 16125.06 ± 3.5% | 15.41 | 1.00 | 1.27 | 482.07 |
| literal: a word in any case | 217 | 43688.45 ± 2.2% | 1055.80 ± 1.5% | 28.63 ± 1.2% | 12524.00 ± 1.8% | 62.08 ± 2.4% | refused | differs | 43571.02 ± 1.6% | 41.38 | 1.00 | 3.49 | 703.74 |
| literal: an href attribute | 33 | 49601.75 ± 2.1% | 1077.33 ± 0.7% | 33.88 ± 1.5% | 32894.62 ± 3.9% | 3098.50 ± 6.7% | 10.24 ± 1.7% | 113.68 ± 4.8% | 49199.32 ± 0.8% | 46.04 | 1.01 | 1.51 | 16.01 |
| literal: a word, second text | 123 | 49901.26 ± 3.8% | 1079.65 ± 1.1% | 38.63 ± 1.5% | 33177.57 ± 17.0% | 12986.30 ± 5.7% | 18.26 ± 1.4% | 110.39 ± 3.8% | 50139.89 ± 4.3% | 46.22 | 1.00 | 1.50 | 3.84 |
| class: two capitalized words | 1331 | 970.60 ± 3.0% | 989.38 ± 2.4% | 36.21 ± 10.8% | 601.77 ± 22.9% | 53.97 ± 23.2% | 12.18 ± 2.4% | 91.55 ± 2.9% | 969.54 ± 6.3% | 0.98 | 1.00 | 1.61 | 17.98 |
| class: a word that ends in ing | 3399 | 898.12 ± 1.6% | 900.99 ± 1.7% | 25.01 ± 2.5% | 567.32 ± 2.5% | 40.28 ± 4.0% | 6.89 ± 1.4% | 26.22 ± 3.1% | 897.39 ± 1.8% | 1.00 | 1.00 | 1.58 | 22.30 |
| class: a word in capitals | 2332 | 1410.95 ± 1.2% | 972.50 ± 3.5% | 37.72 ± 21.0% | 592.71 ± 2.3% | 58.19 ± 15.2% | 14.48 ± 1.6% | 120.07 ± 7.4% | 1399.70 ± 2.7% | 1.45 | 1.01 | 2.38 | 24.25 |
| class: a number | 8288 | 2319.90 ± 1.5% | 811.67 ± 3.0% | 37.62 ± 2.9% | 2051.37 ± 2.2% | 59.40 ± 23.0% | 0.40 ± 2.0% | 82.73 ± 34.9% | 2313.79 ± 1.9% | 2.86 | 1.00 | 1.13 | 39.05 |
| class: two capitalized words, second text | 5359 | 703.99 ± 0.5% | 701.01 ± 1.1% | 31.46 ± 1.7% | 492.52 ± 1.1% | 39.96 ± 15.2% | 14.93 ± 1.3% | 81.16 ± 3.2% | 701.35 ± 0.8% | 1.00 | 1.00 | 1.43 | 17.62 |
| other: a word between two words | 6104 | 877.72 ± 3.5% | 737.66 ± 0.8% | 30.67 ± 0.5% | 852.13 ± 2.6% | 150.25 ± 13.9% | 8.99 ± 0.9% | 94.40 ± 2.1% | 858.67 ± 3.7% | 1.19 | 1.02 | 1.03 | 5.84 |
| other: a number before a unit, second text | 1481 | 11436.06 ± 2.5% | 983.14 ± 2.1% | 35.69 ± 2.4% | 10200.67 ± 1.5% | 51.68 ± 2.6% | 15.89 ± 2.3% | 88.50 ± 2.0% | 11414.52 ± 1.9% | 11.63 | 1.00 | 1.12 | 221.28 |
| other: a heading's start tag | 110 | 26372.81 ± 2.2% | 1041.88 ± 1.9% | 35.69 ± 1.2% | 2857.85 ± 1.4% | 2188.37 ± 8.5% | 12.43 ± 1.0% | 131.77 ± 0.8% | 26497.72 ± 1.6% | 25.31 | 1.00 | 9.23 | 12.05 |
| other: a whole word | 217 | 33724.53 ± 2.8% | 1050.69 ± 3.6% | 38.97 ± 3.3% | 26171.65 ± 7.5% | 66.12 ± 3.5% | 11.77 ± 3.5% | 72.92 ± 5.9% | 33381.43 ± 1.7% | 32.10 | 1.01 | 1.29 | 510.06 |
| other: a line's first word, second text | 3716 | 2947.85 ± 0.6% | 862.49 ± 0.5% | 42.73 ± 1.6% | 3095.77 ± 0.5% | 85.90 ± 9.0% | refused | refused | 2933.65 ± 0.9% | 3.42 | 1.00 | 0.95 | 34.32 |
| other: fourteen octets before an x | 87 | 42422.96 ± 3.0% | 2.15 ± 1.7% | 2.11 ± 1.4% | 4110.91 ± 1.2% | 12.72 ± 2.1% | differs | 22.50 ± 2.2% | 42000.38 ± 4.2% | 19737.74 | 1.01 | 10.32 | 3336.35 |
| other: a Greek word | 21815 | 532.50 ± 2.7% | 355.69 ± 3.6% | 41.97 ± 2.3% | 315.87 ± 1.8% | 63.09 ± 29.3% | differs | refused | 526.19 ± 1.5% | 1.50 | 1.01 | 1.69 | 8.44 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 32.33 ± 3.2% | 32.15 ± 8.9% | 0.79 ± 1.7% | 27.59 ± 1.6% | 3.33 ± 4.2% | differs | 5.01 ± 7.1% | 32.64 ± 5.2% | 1.01 | 0.99 | 1.17 | 9.70 |
| a UUID | 32895 | 27.06 ± 3.3% | 27.16 ± 13.2% | 0.91 ± 2.5% | 22.47 ± 2.7% | 3.05 ± 4.6% | 0.63 ± 2.1% | 3.99 ± 6.6% | 26.83 ± 3.5% | 1.00 | 1.01 | 1.20 | 8.88 |
| an IPv4 address | 33176 | 44.95 ± 4.6% | 44.87 ± 5.4% | 2.94 ± 2.8% | 39.20 ± 1.6% | 7.83 ± 3.8% | differs | 4.83 ± 2.5% | 45.13 ± 1.9% | 1.00 | 1.00 | 1.15 | 5.74 |
| a date and time | 32954 | 41.14 ± 2.6% | 41.42 ± 4.0% | 2.19 ± 6.5% | 32.58 ± 1.2% | 9.11 ± 1.5% | 1.12 ± 3.2% | 8.87 ± 5.9% | 40.18 ± 1.4% | 0.99 | 1.02 | 1.26 | 4.52 |
| a field path | 32606 | 35.42 ± 2.7% | 34.98 ± 1.3% | 1.28 ± 2.8% | 31.06 ± 1.2% | 4.04 ± 1.4% | differs | 3.56 ± 1.8% | 35.33 ± 3.4% | 1.01 | 1.00 | 1.14 | 8.77 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 14.19 ± 5.3% | 13.75 ± 2.0% | 14.24 ± 7.8% | 15.31 ± 0.9% | 6.31 ± 4.9% | 0.90 ± 3.5% | none | 14.27 ± 7.3% | 1.03 | 0.99 | 0.93 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 289.05 ± 1.9% | 285.86 ± 2.0% | 319.81 ± 2.3% | 117.91 ± 2.2% | 269.51 ± 10.9% | 749.78 ± 4.8% | 4993.15 ± 1.2% | 288.65 ± 1.2% | 1.01 | 1.00 | 2.45 | 1.07 |
| a UUID | 62 | 210.28 ± 1.1% | 212.49 ± 2.0% | 229.51 ± 2.9% | 64.71 ± 1.6% | 128.28 ± 22.1% | 265.31 ± 2.1% | 6099.25 ± 2.8% | 210.73 ± 2.4% | 0.99 | 1.00 | 3.25 | 1.64 |
| an IPv4 address | 29 | 461.82 ± 1.7% | 462.89 ± 6.0% | 546.17 ± 2.1% | 104.95 ± 1.8% | 169.01 ± 9.9% | 478.06 ± 1.2% | 11174.86 ± 1.6% | 460.50 ± 1.7% | 1.00 | 1.00 | 4.40 | 2.73 |
| a date and time | 56 | 359.30 ± 1.0% | 360.39 ± 2.1% | 404.26 ± 2.3% | 101.34 ± 1.9% | 183.68 ± 3.3% | 494.41 ± 1.9% | 7054.07 ± 1.1% | 356.02 ± 1.2% | 1.00 | 1.01 | 3.55 | 1.96 |
| a field path | 39 | 308.74 ± 1.5% | 314.18 ± 1.5% | 346.19 ± 1.6% | 109.95 ± 4.1% | 257.96 ± 5.5% | 774.33 ± 2.2% | 6337.75 ± 2.3% | 310.83 ± 1.2% | 0.98 | 0.99 | 2.81 | 1.20 |
| literal: a word | 7 | 662.71 ± 2.7% | 675.78 ± 1.4% | 838.25 ± 2.3% | 743.89 ± 1.5% | 873.07 ± 10.1% | 1510.89 ± 0.8% | 41243.32 ± 2.0% | 663.63 ± 1.9% | 0.98 | 1.00 | 0.89 | 0.76 |
| literal: a word that is not there | 8 | 645.07 ± 0.5% | 653.74 ± 3.4% | 805.19 ± 11.5% | 686.98 ± 2.0% | 856.55 ± 38.7% | 1482.74 ± 3.3% | 40321.80 ± 4.8% | 640.43 ± 2.7% | 0.99 | 1.01 | 0.94 | 0.75 |
| literal: one of four words | 26 | 419.21 ± 1.2% | 447.10 ± 2.0% | 515.96 ± 2.1% | 63.12 ± 2.5% | 302.18 ± 14.0% | 572.03 ± 1.8% | 19944.77 ± 4.4% | 416.87 ± 0.8% | 0.94 | 1.01 | 6.64 | 1.39 |
| literal: a word in any case | 11 | 362.36 ± 2.0% | 367.14 ± 3.8% | 412.27 ± 3.8% | 20.86 ± 1.6% | 893.84 ± 35.9% | refused | 31602.40 ± 2.0% | 361.65 ± 3.8% | 0.99 | 1.00 | 17.37 | 0.41 |
| literal: an href attribute | 12 | 454.15 ± 3.8% | 461.40 ± 2.5% | 537.91 ± 2.3% | 52.86 ± 2.4% | 626.73 ± 6.4% | 1294.36 ± 1.4% | 29579.47 ± 1.3% | 453.52 ± 2.0% | 0.98 | 1.00 | 8.59 | 0.72 |
| literal: a word, second text | 10 | 615.98 ± 2.6% | 628.28 ± 2.4% | 769.24 ± 2.8% | 617.35 ± 1.7% | 737.57 ± 4.9% | 1338.26 ± 1.5% | 38607.85 ± 1.1% | 615.99 ± 6.3% | 0.98 | 1.00 | 1.00 | 0.84 |
| class: two capitalized words | 23 | 521.70 ± 2.5% | 532.17 ± 3.0% | 627.73 ± 3.4% | 141.57 ± 1.6% | 695.14 ± 1.8% | 1232.45 ± 2.3% | 8295.78 ± 1.9% | 520.29 ± 1.5% | 0.98 | 1.00 | 3.69 | 0.75 |
| class: a word that ends in ing | 9 | 630.10 ± 2.4% | 652.57 ± 2.7% | 798.85 ± 2.8% | 178.21 ± 3.6% | 932.83 ± 2.5% | 1873.91 ± 1.3% | 21674.87 ± 2.5% | 627.54 ± 1.4% | 0.97 | 1.00 | 3.54 | 0.68 |
| class: a word in capitals | 16 | 583.10 ± 1.9% | 596.80 ± 2.6% | 706.69 ± 2.3% | 181.74 ± 2.8% | 948.81 ± 9.7% | 1721.30 ± 2.3% | 10889.85 ± 2.7% | 572.26 ± 2.8% | 0.98 | 1.02 | 3.21 | 0.61 |
| class: a number | 6 | 663.62 ± 3.7% | 677.48 ± 3.3% | 841.42 ± 5.3% | 52.32 ± 2.2% | 1786.26 ± 16.6% | 3097.06 ± 3.2% | 31234.87 ± 4.3% | 663.69 ± 2.0% | 0.98 | 1.00 | 12.68 | 0.37 |
| class: two capitalized words, second text | 23 | 512.35 ± 1.1% | 524.24 ± 0.7% | 616.96 ± 2.1% | 137.90 ± 2.6% | 622.97 ± 6.9% | 1182.13 ± 7.2% | 8199.18 ± 7.7% | 513.29 ± 6.6% | 0.98 | 1.00 | 3.72 | 0.82 |
| other: a word between two words | 13 | 585.99 ± 1.7% | 590.09 ± 1.9% | 721.55 ± 2.3% | 181.51 ± 0.6% | 603.39 ± 23.5% | 1315.22 ± 3.1% | 19650.58 ± 12.3% | 585.06 ± 2.2% | 0.99 | 1.00 | 3.23 | 0.97 |
| other: a number before a unit, second text | 15 | 510.82 ± 1.8% | 532.41 ± 3.0% | 628.44 ± 2.8% | 50.86 ± 2.4% | 765.64 ± 6.7% | 1500.56 ± 1.8% | 21171.80 ± 2.1% | 506.26 ± 2.8% | 0.96 | 1.01 | 10.04 | 0.67 |
| other: a heading's start tag | 13 | 464.16 ± 2.7% | 464.56 ± 3.8% | 544.25 ± 2.4% | 51.28 ± 1.8% | 759.98 ± 1.9% | 1416.47 ± 0.8% | 25146.15 ± 1.7% | 462.71 ± 2.2% | 1.00 | 1.00 | 9.05 | 0.61 |
| other: a whole word | 11 | 611.57 ± 0.8% | 622.20 ± 1.9% | 759.19 ± 1.7% | 168.21 ± 1.4% | 729.90 ± 5.4% | 1388.30 ± 1.5% | 36032.13 ± 1.4% | 604.51 ± 1.1% | 0.98 | 1.01 | 3.64 | 0.84 |
| other: a line's first word, second text | 17 | 570.25 ± 2.4% | 588.13 ± 4.9% | 716.65 ± 4.2% | 171.79 ± 3.2% | 857.60 ± 11.9% | refused | refused | 567.08 ± 7.1% | 0.97 | 1.01 | 3.32 | 0.66 |
| other: fourteen octets before an x | 16 | 152.80 ± 3.2% | 199.36 ± 2.3% | 225.04 ± 1.7% | 19.20 ± 1.3% | 557.90 ± 4.5% | 643.70 ± 0.9% | 18261.48 ± 1.2% | 152.41 ± 1.5% | 0.77 | 1.00 | 7.96 | 0.27 |
| other: a Greek word | 8 | 624.39 ± 1.1% | 654.31 ± 1.9% | 808.49 ± 1.7% | 63.76 ± 2.1% | 1727.10 ± 15.8% | 2940.05 ± 4.2% | refused | 626.17 ± 1.2% | 0.95 | 1.00 | 9.79 | 0.36 |

