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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45058350686 |
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
| literal: a word | 217 | 43693.51 ± 0.2% | 1029.49 ± 0.2% | 32.95 ± 0.8% | 40473.92 ± 0.8% | 12151.57 ± 3.1% | 12.77 ± 0.2% | 103.88 ± 2.0% | 43546.59 ± 0.3% | 42.44 | 1.00 | 1.08 | 3.60 |
| literal: a word that is not there | 0 | 61499.38 ± 0.9% | 1039.49 ± 0.2% | 32.83 ± 0.6% | 45894.49 ± 0.8% | 44147.19 ± 1.0% | 12.62 ± 0.3% | 97.77 ± 13.8% | 61574.03 ± 0.3% | 59.16 | 1.00 | 1.34 | 1.39 |
| literal: one of four words | 661 | 13363.90 ± 1.5% | 1007.92 ± 0.3% | 17.17 ± 0.4% | 11515.03 ± 1.9% | 24.24 ± 0.4% | 4.48 ± 0.3% | 7.98 ± 3.1% | 13337.35 ± 1.7% | 13.26 | 1.00 | 1.16 | 551.40 |
| literal: a word in any case | 217 | 37608.78 ± 0.4% | 1028.36 ± 0.5% | 24.60 ± 0.8% | 11397.54 ± 3.1% | 47.78 ± 18.4% | refused | differs | 37619.63 ± 5.8% | 36.57 | 1.00 | 3.30 | 787.16 |
| literal: an href attribute | 33 | 44850.54 ± 1.5% | 1034.61 ± 0.3% | 31.84 ± 0.7% | 34813.89 ± 7.3% | 3038.34 ± 8.9% | 9.56 ± 0.6% | 90.72 ± 0.3% | 44949.39 ± 1.7% | 43.35 | 1.00 | 1.29 | 14.76 |
| literal: a word, second text | 123 | 47561.67 ± 0.9% | 1030.20 ± 0.4% | 32.36 ± 0.5% | 40886.90 ± 0.3% | 11579.13 ± 4.0% | 14.42 ± 1.0% | 87.80 ± 0.6% | 47572.09 ± 0.2% | 46.17 | 1.00 | 1.16 | 4.11 |
| class: two capitalized words | 1331 | 914.67 ± 0.2% | 951.11 ± 0.1% | 30.29 ± 3.1% | 575.97 ± 2.6% | 44.82 ± 12.3% | 10.86 ± 1.9% | 78.73 ± 3.1% | 913.71 ± 0.4% | 0.96 | 1.00 | 1.59 | 20.41 |
| class: a word that ends in ing | 3399 | 874.12 ± 0.1% | 869.26 ± 0.2% | 20.94 ± 0.6% | 540.60 ± 0.2% | 32.92 ± 3.2% | 6.20 ± 0.2% | 20.07 ± 0.7% | 873.53 ± 0.2% | 1.01 | 1.00 | 1.62 | 26.55 |
| class: a word in capitals | 2332 | 1146.32 ± 0.9% | 930.08 ± 0.9% | 32.16 ± 0.4% | 566.17 ± 0.6% | 48.08 ± 23.4% | 12.29 ± 0.4% | 101.79 ± 0.7% | 1144.97 ± 0.3% | 1.23 | 1.00 | 2.02 | 23.84 |
| class: a number | 8288 | 1872.78 ± 1.1% | 793.33 ± 0.2% | 32.89 ± 0.5% | 1856.10 ± 1.3% | 48.93 ± 14.8% | 0.38 ± 0.2% | 73.88 ± 0.9% | 1876.83 ± 0.7% | 2.36 | 1.00 | 1.01 | 38.28 |
| class: two capitalized words, second text | 5359 | 690.10 ± 0.3% | 691.04 ± 1.0% | 27.39 ± 0.5% | 480.95 ± 0.1% | 39.41 ± 7.4% | 12.63 ± 0.2% | 74.51 ± 1.3% | 691.30 ± 0.3% | 1.00 | 1.00 | 1.43 | 17.51 |
| other: a word between two words | 6104 | 835.17 ± 0.4% | 739.71 ± 0.1% | 27.06 ± 0.1% | 838.76 ± 0.6% | 126.71 ± 18.9% | 8.45 ± 0.3% | 82.13 ± 0.1% | 833.95 ± 0.4% | 1.13 | 1.00 | 1.00 | 6.59 |
| other: a number before a unit, second text | 1481 | 10600.05 ± 0.3% | 979.57 ± 0.3% | 30.40 ± 0.5% | 8369.70 ± 0.5% | 45.88 ± 0.5% | 13.18 ± 0.3% | 78.20 ± 0.5% | 10569.09 ± 0.6% | 10.82 | 1.00 | 1.27 | 231.06 |
| other: a heading's start tag | 110 | 25743.94 ± 2.3% | 1025.47 ± 0.2% | 32.32 ± 0.9% | 2701.69 ± 2.1% | 1953.43 ± 10.1% | 11.67 ± 0.3% | 107.14 ± 0.2% | 25744.11 ± 0.2% | 25.10 | 1.00 | 9.53 | 13.18 |
| other: a whole word | 217 | 31248.94 ± 0.2% | 1027.68 ± 0.5% | 33.42 ± 0.5% | 29232.72 ± 0.7% | 54.50 ± 0.1% | 11.06 ± 0.4% | 63.01 ± 0.3% | 31261.66 ± 0.4% | 30.41 | 1.00 | 1.07 | 573.39 |
| other: a line's first word, second text | 3716 | 2632.25 ± 2.1% | 852.48 ± 0.6% | 36.59 ± 0.3% | 2446.14 ± 5.3% | 70.80 ± 3.4% | refused | refused | 2610.58 ± 0.6% | 3.09 | 1.01 | 1.08 | 37.18 |
| other: fourteen octets before an x | 87 | 38007.84 ± 0.3% | 1.73 ± 1.1% | 1.71 ± 5.6% | 3438.28 ± 0.4% | 11.73 ± 0.7% | differs | 21.87 ± 2.9% | 37786.63 ± 5.0% | 21940.69 | 1.01 | 11.05 | 3239.34 |
| other: a Greek word | 21815 | 464.24 ± 0.2% | 334.99 ± 0.4% | 35.01 ± 0.3% | 307.51 ± 3.2% | 57.09 ± 9.8% | differs | refused | 467.31 ± 2.7% | 1.39 | 0.99 | 1.51 | 8.13 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.74 ± 1.9% | 30.72 ± 4.9% | 0.62 ± 1.5% | 25.84 ± 0.6% | 2.83 ± 0.7% | differs | 4.05 ± 8.9% | 30.77 ± 4.8% | 1.00 | 1.00 | 1.19 | 10.85 |
| a UUID | 32895 | 25.75 ± 0.1% | 25.80 ± 0.1% | 0.75 ± 6.2% | 18.94 ± 0.4% | 3.07 ± 4.3% | 0.52 ± 0.3% | 3.82 ± 0.8% | 25.70 ± 2.9% | 1.00 | 1.00 | 1.36 | 8.38 |
| an IPv4 address | 33176 | 44.22 ± 0.3% | 44.13 ± 0.9% | 2.43 ± 1.4% | 36.57 ± 0.5% | 7.06 ± 0.8% | differs | 4.14 ± 0.7% | 43.90 ± 1.6% | 1.00 | 1.01 | 1.21 | 6.26 |
| a date and time | 32954 | 39.56 ± 0.3% | 39.56 ± 0.9% | 1.80 ± 0.4% | 29.61 ± 0.4% | 8.54 ± 0.4% | 0.90 ± 0.2% | 7.90 ± 1.0% | 39.50 ± 2.0% | 1.00 | 1.00 | 1.34 | 4.63 |
| a field path | 32606 | 34.71 ± 2.0% | 34.78 ± 0.3% | 0.96 ± 1.0% | 29.30 ± 0.3% | 3.59 ± 0.7% | differs | 2.99 ± 1.8% | 34.72 ± 0.3% | 1.00 | 1.00 | 1.18 | 9.68 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.22 ± 0.4% | 11.51 ± 0.2% | 11.42 ± 0.8% | 13.43 ± 1.2% | 5.90 ± 2.8% | 0.75 ± 0.3% | none | 11.63 ± 0.4% | 0.97 | 0.96 | 0.84 | 1.90 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 204.78 ± 0.4% | 205.67 ± 0.1% | 227.29 ± 0.2% | 101.37 ± 1.6% | 242.83 ± 4.5% | 703.85 ± 5.4% | 4909.07 ± 0.7% | 204.68 ± 0.3% | 1.00 | 1.00 | 2.02 | 0.84 |
| a UUID | 62 | 154.25 ± 0.3% | 154.69 ± 0.4% | 169.99 ± 0.3% | 57.98 ± 1.5% | 119.26 ± 22.4% | 250.34 ± 6.7% | 5386.05 ± 1.7% | 154.13 ± 3.9% | 1.00 | 1.00 | 2.66 | 1.29 |
| an IPv4 address | 29 | 311.54 ± 0.7% | 312.55 ± 0.9% | 365.08 ± 1.5% | 86.83 ± 7.7% | 149.33 ± 1.8% | 403.21 ± 0.7% | 8971.54 ± 0.7% | 312.69 ± 0.6% | 1.00 | 1.00 | 3.59 | 2.09 |
| a date and time | 56 | 252.81 ± 0.3% | 254.09 ± 5.3% | 284.09 ± 0.2% | 86.45 ± 1.3% | 161.44 ± 1.3% | 472.43 ± 1.3% | 5532.76 ± 11.7% | 252.63 ± 5.3% | 0.99 | 1.00 | 2.92 | 1.57 |
| a field path | 39 | 211.69 ± 0.2% | 212.31 ± 0.1% | 234.78 ± 0.2% | 95.08 ± 2.8% | 230.27 ± 2.2% | 726.22 ± 1.8% | 5883.36 ± 0.4% | 211.77 ± 0.3% | 1.00 | 1.00 | 2.23 | 0.92 |
| literal: a word | 7 | 396.33 ± 0.4% | 402.60 ± 0.1% | 480.25 ± 0.2% | 652.98 ± 1.1% | 797.58 ± 1.9% | 1608.14 ± 0.4% | 33969.61 ± 0.2% | 396.76 ± 0.2% | 0.98 | 1.00 | 0.61 | 0.50 |
| literal: a word that is not there | 8 | 390.23 ± 0.2% | 395.90 ± 0.1% | 470.87 ± 0.2% | 609.34 ± 0.4% | 770.03 ± 20.1% | 1486.77 ± 1.0% | 33302.81 ± 0.2% | 390.51 ± 0.1% | 0.99 | 1.00 | 0.64 | 0.51 |
| literal: one of four words | 26 | 279.30 ± 0.1% | 293.76 ± 0.3% | 336.84 ± 0.1% | 58.04 ± 0.7% | 296.37 ± 1.5% | 550.42 ± 3.6% | 17296.06 ± 1.1% | 279.38 ± 0.2% | 0.95 | 1.00 | 4.81 | 0.94 |
| literal: a word in any case | 11 | 246.41 ± 0.1% | 249.65 ± 0.2% | 280.25 ± 0.2% | 19.36 ± 0.4% | 823.43 ± 2.2% | refused | 25506.28 ± 1.9% | 246.22 ± 0.1% | 0.99 | 1.00 | 12.73 | 0.30 |
| literal: an href attribute | 12 | 300.80 ± 0.3% | 304.06 ± 0.1% | 351.98 ± 1.1% | 48.98 ± 0.8% | 572.96 ± 1.9% | 1239.53 ± 0.7% | 24575.01 ± 1.2% | 300.91 ± 0.3% | 0.99 | 1.00 | 6.14 | 0.52 |
| literal: a word, second text | 10 | 377.34 ± 6.6% | 383.62 ± 0.1% | 453.76 ± 0.3% | 553.12 ± 1.8% | 673.12 ± 0.8% | 1317.33 ± 0.5% | 30647.89 ± 7.0% | 377.15 ± 19.1% | 0.98 | 1.00 | 0.68 | 0.56 |
| class: two capitalized words | 23 | 326.42 ± 0.7% | 333.64 ± 0.6% | 384.96 ± 0.1% | 120.55 ± 2.6% | 601.36 ± 13.1% | 1211.34 ± 0.5% | 7847.76 ± 0.3% | 327.02 ± 0.4% | 0.98 | 1.00 | 2.71 | 0.54 |
| class: a word that ends in ing | 9 | 384.34 ± 0.4% | 395.81 ± 0.4% | 468.90 ± 0.2% | 149.63 ± 1.5% | 862.06 ± 8.6% | 1750.04 ± 6.4% | 19217.51 ± 3.6% | 384.93 ± 0.2% | 0.97 | 1.00 | 2.57 | 0.45 |
| class: a word in capitals | 16 | 353.11 ± 0.4% | 359.94 ± 2.1% | 420.55 ± 0.5% | 154.66 ± 0.6% | 898.09 ± 1.2% | 1679.52 ± 0.8% | 10430.83 ± 0.3% | 353.00 ± 0.1% | 0.98 | 1.00 | 2.28 | 0.39 |
| class: a number | 6 | 401.48 ± 0.4% | 410.26 ± 3.7% | 491.03 ± 0.2% | 48.57 ± 0.8% | 1663.84 ± 11.3% | 2820.33 ± 2.4% | 25751.51 ± 7.3% | 401.56 ± 0.3% | 0.98 | 1.00 | 8.27 | 0.24 |
| class: two capitalized words, second text | 23 | 327.05 ± 0.3% | 333.56 ± 6.2% | 384.79 ± 3.6% | 120.34 ± 1.9% | 602.33 ± 11.8% | 1247.67 ± 2.5% | 7851.17 ± 0.6% | 327.01 ± 0.4% | 0.98 | 1.00 | 2.72 | 0.54 |
| other: a word between two words | 13 | 367.80 ± 0.5% | 371.18 ± 1.3% | 434.94 ± 0.3% | 155.91 ± 0.4% | 591.62 ± 1.3% | 1344.84 ± 8.8% | 17435.26 ± 0.3% | 367.86 ± 3.2% | 0.99 | 1.00 | 2.36 | 0.62 |
| other: a number before a unit, second text | 15 | 318.93 ± 0.3% | 330.11 ± 0.2% | 382.72 ± 2.9% | 45.30 ± 0.6% | 729.65 ± 1.8% | 1472.09 ± 4.8% | 17307.38 ± 0.2% | 318.92 ± 0.2% | 0.97 | 1.00 | 7.04 | 0.44 |
| other: a heading's start tag | 13 | 300.20 ± 0.1% | 301.50 ± 0.2% | 353.66 ± 0.1% | 48.30 ± 0.3% | 717.72 ± 2.0% | 1354.59 ± 0.6% | 20536.99 ± 0.6% | 300.08 ± 0.8% | 1.00 | 1.00 | 6.21 | 0.42 |
| other: a whole word | 11 | 376.59 ± 0.2% | 382.27 ± 1.1% | 451.87 ± 0.2% | 145.87 ± 1.1% | 685.62 ± 0.5% | 1331.93 ± 0.3% | 30063.28 ± 0.2% | 376.69 ± 1.0% | 0.99 | 1.00 | 2.58 | 0.55 |
| other: a line's first word, second text | 17 | 363.32 ± 0.3% | 371.73 ± 0.2% | 437.09 ± 0.1% | 148.32 ± 0.7% | 811.46 ± 9.2% | refused | refused | 362.87 ± 0.6% | 0.98 | 1.00 | 2.45 | 0.45 |
| other: fourteen octets before an x | 16 | 108.33 ± 0.9% | 141.58 ± 2.4% | 158.33 ± 1.2% | 17.98 ± 1.5% | 516.26 ± 26.8% | 579.42 ± 6.2% | 15750.07 ± 0.5% | 108.46 ± 0.6% | 0.77 | 1.00 | 6.03 | 0.21 |
| other: a Greek word | 8 | 389.11 ± 4.9% | 403.26 ± 0.2% | 481.43 ± 0.6% | 63.30 ± 0.9% | 1648.77 ± 2.0% | 2737.38 ± 0.4% | refused | 388.72 ± 5.2% | 0.96 | 1.00 | 6.15 | 0.24 |

