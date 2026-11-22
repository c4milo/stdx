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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45058344790 |
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
| literal: a word | 217 | 43494.99 ± 1.4% | 1026.87 ± 2.4% | 32.94 ± 1.4% | 40476.18 ± 0.3% | 12220.59 ± 2.1% | 12.77 ± 0.5% | 104.36 ± 2.9% | 43427.20 ± 0.8% | 42.36 | 1.00 | 1.07 | 3.56 |
| literal: a word that is not there | 0 | 61415.20 ± 0.3% | 1038.65 ± 0.4% | 32.83 ± 0.4% | 45746.67 ± 1.9% | 44287.76 ± 0.7% | 12.64 ± 0.1% | 97.10 ± 2.0% | 61332.38 ± 1.5% | 59.13 | 1.00 | 1.34 | 1.39 |
| literal: one of four words | 661 | 13329.56 ± 0.4% | 1007.25 ± 0.3% | 17.18 ± 0.1% | 11502.31 ± 0.1% | 24.24 ± 0.2% | 4.47 ± 0.5% | 8.04 ± 3.7% | 12448.40 ± 2.0% | 13.23 | 1.07 | 1.16 | 549.99 |
| literal: a word in any case | 217 | 37469.93 ± 0.9% | 1028.94 ± 0.3% | 24.61 ± 0.4% | 11386.80 ± 2.1% | 47.70 ± 1.6% | refused | differs | 37489.64 ± 0.4% | 36.42 | 1.00 | 3.29 | 785.50 |
| literal: an href attribute | 33 | 44868.07 ± 1.1% | 1035.12 ± 0.2% | 31.83 ± 0.4% | 34917.99 ± 1.5% | 3047.35 ± 6.2% | 9.56 ± 0.2% | 91.47 ± 0.4% | 44896.72 ± 0.1% | 43.35 | 1.00 | 1.28 | 14.72 |
| literal: a word, second text | 123 | 47820.30 ± 0.2% | 1030.07 ± 0.5% | 32.38 ± 0.4% | 40821.73 ± 0.3% | 11248.13 ± 7.2% | 14.44 ± 0.5% | 88.11 ± 0.3% | 47833.86 ± 0.1% | 46.42 | 1.00 | 1.17 | 4.25 |
| class: two capitalized words | 1331 | 914.48 ± 0.1% | 950.71 ± 0.1% | 30.50 ± 0.2% | 577.68 ± 0.2% | 44.98 ± 8.6% | 10.86 ± 0.4% | 80.38 ± 0.3% | 913.16 ± 0.2% | 0.96 | 1.00 | 1.58 | 20.33 |
| class: a word that ends in ing | 3399 | 871.75 ± 0.7% | 873.44 ± 0.8% | 20.65 ± 0.5% | 538.96 ± 0.5% | 33.08 ± 8.7% | 6.20 ± 0.4% | 20.12 ± 0.8% | 872.11 ± 0.2% | 1.00 | 1.00 | 1.62 | 26.35 |
| class: a word in capitals | 2332 | 1147.18 ± 0.2% | 930.27 ± 0.2% | 32.22 ± 0.4% | 565.23 ± 0.5% | 47.89 ± 8.8% | 12.27 ± 0.4% | 101.43 ± 0.6% | 1145.85 ± 0.2% | 1.23 | 1.00 | 2.03 | 23.96 |
| class: a number | 8288 | 1881.16 ± 0.4% | 793.42 ± 0.3% | 32.84 ± 0.8% | 1819.65 ± 0.7% | 50.41 ± 15.1% | 0.38 ± 0.4% | 73.45 ± 1.5% | 1874.50 ± 0.5% | 2.37 | 1.00 | 1.03 | 37.32 |
| class: two capitalized words, second text | 5359 | 690.51 ± 0.3% | 688.18 ± 0.6% | 26.26 ± 0.4% | 480.18 ± 0.3% | 39.21 ± 12.8% | 12.58 ± 0.3% | 74.06 ± 1.2% | 691.03 ± 0.2% | 1.00 | 1.00 | 1.44 | 17.61 |
| other: a word between two words | 6104 | 833.30 ± 0.2% | 739.49 ± 0.2% | 27.26 ± 0.4% | 831.27 ± 0.2% | 129.59 ± 9.0% | 8.45 ± 0.1% | 82.17 ± 0.4% | 832.62 ± 0.1% | 1.13 | 1.00 | 1.00 | 6.43 |
| other: a number before a unit, second text | 1481 | 10640.36 ± 0.6% | 979.54 ± 0.3% | 30.39 ± 0.5% | 9324.54 ± 0.2% | 45.86 ± 0.4% | 13.17 ± 0.1% | 78.24 ± 1.6% | 10615.33 ± 0.3% | 10.86 | 1.00 | 1.14 | 232.01 |
| other: a heading's start tag | 110 | 25785.14 ± 0.2% | 1025.64 ± 0.2% | 32.35 ± 0.4% | 2633.87 ± 0.2% | 2003.47 ± 14.7% | 11.70 ± 0.4% | 107.09 ± 0.2% | 25792.90 ± 0.3% | 25.14 | 1.00 | 9.79 | 12.87 |
| other: a whole word | 217 | 31323.00 ± 0.1% | 1028.17 ± 0.2% | 33.43 ± 0.4% | 29008.67 ± 0.2% | 54.58 ± 0.6% | 11.04 ± 0.1% | 62.85 ± 0.3% | 31288.94 ± 1.3% | 30.46 | 1.00 | 1.08 | 573.92 |
| other: a line's first word, second text | 3716 | 2654.36 ± 2.1% | 847.12 ± 0.1% | 36.61 ± 0.7% | 2403.58 ± 1.9% | 70.92 ± 3.9% | refused | refused | 2604.10 ± 1.5% | 3.13 | 1.02 | 1.10 | 37.43 |
| other: fourteen octets before an x | 87 | 37554.33 ± 0.2% | 1.73 ± 0.4% | 1.71 ± 0.6% | 3533.57 ± 0.6% | 11.77 ± 0.1% | differs | 21.91 ± 0.8% | 37656.13 ± 0.6% | 21750.21 | 1.00 | 10.63 | 3189.71 |
| other: a Greek word | 21815 | 467.63 ± 0.8% | 335.70 ± 0.3% | 34.97 ± 0.5% | 304.76 ± 0.7% | 57.34 ± 7.7% | differs | refused | 466.57 ± 0.4% | 1.39 | 1.00 | 1.53 | 8.15 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.74 ± 2.0% | 30.72 ± 4.4% | 0.62 ± 1.5% | 25.79 ± 0.6% | 2.83 ± 0.1% | differs | 4.08 ± 5.3% | 30.79 ± 0.7% | 1.00 | 1.00 | 1.19 | 10.85 |
| a UUID | 32895 | 25.77 ± 0.2% | 25.77 ± 2.6% | 0.75 ± 1.2% | 18.82 ± 0.4% | 3.07 ± 5.4% | 0.53 ± 0.4% | 3.81 ± 4.4% | 25.79 ± 0.7% | 1.00 | 1.00 | 1.37 | 8.41 |
| an IPv4 address | 33176 | 44.20 ± 3.3% | 44.18 ± 0.9% | 2.41 ± 0.7% | 36.54 ± 6.4% | 7.01 ± 1.3% | differs | 4.18 ± 3.8% | 44.54 ± 0.8% | 1.00 | 0.99 | 1.21 | 6.30 |
| a date and time | 32954 | 39.43 ± 0.4% | 39.42 ± 1.1% | 1.80 ± 0.2% | 29.45 ± 0.4% | 8.56 ± 0.4% | 0.91 ± 0.4% | 7.84 ± 1.3% | 39.35 ± 0.8% | 1.00 | 1.00 | 1.34 | 4.60 |
| a field path | 32606 | 34.66 ± 5.5% | 34.81 ± 25.0% | 0.95 ± 6.0% | 29.30 ± 4.8% | 3.56 ± 5.6% | differs | 2.96 ± 2.5% | 34.71 ± 0.5% | 1.00 | 1.00 | 1.18 | 9.74 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.60 ± 2.4% | 11.46 ± 6.3% | 11.60 ± 0.4% | 13.16 ± 5.4% | 5.94 ± 1.2% | 0.74 ± 1.2% | none | 11.60 ± 2.7% | 1.01 | 1.00 | 0.88 | 1.95 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 204.72 ± 0.2% | 205.21 ± 0.6% | 226.08 ± 3.9% | 101.67 ± 3.0% | 243.25 ± 1.3% | 698.12 ± 5.7% | 4912.14 ± 0.5% | 204.57 ± 0.5% | 1.00 | 1.00 | 2.01 | 0.84 |
| a UUID | 62 | 154.38 ± 5.8% | 154.88 ± 0.2% | 169.79 ± 0.1% | 58.10 ± 1.2% | 119.90 ± 1.0% | 256.20 ± 1.6% | 5382.60 ± 6.2% | 154.35 ± 0.1% | 1.00 | 1.00 | 2.66 | 1.29 |
| an IPv4 address | 29 | 312.14 ± 0.6% | 313.27 ± 0.7% | 363.31 ± 0.6% | 87.89 ± 0.9% | 149.01 ± 18.9% | 413.73 ± 1.6% | 8976.70 ± 0.4% | 311.67 ± 0.3% | 1.00 | 1.00 | 3.55 | 2.09 |
| a date and time | 56 | 252.15 ± 0.3% | 253.00 ± 0.2% | 284.05 ± 0.2% | 87.49 ± 1.0% | 160.88 ± 24.1% | 475.15 ± 1.1% | 5485.22 ± 0.8% | 252.09 ± 0.1% | 1.00 | 1.00 | 2.88 | 1.57 |
| a field path | 39 | 211.08 ± 3.8% | 212.07 ± 0.3% | 233.60 ± 0.1% | 96.50 ± 3.7% | 223.11 ± 16.1% | 726.92 ± 5.4% | 5882.99 ± 0.5% | 211.30 ± 0.2% | 1.00 | 1.00 | 2.19 | 0.95 |
| literal: a word | 7 | 395.39 ± 0.4% | 400.61 ± 0.2% | 479.92 ± 0.4% | 670.07 ± 9.6% | 791.33 ± 13.0% | 1618.98 ± 1.1% | 33862.87 ± 0.2% | 395.45 ± 0.1% | 0.99 | 1.00 | 0.59 | 0.50 |
| literal: a word that is not there | 8 | 387.82 ± 4.0% | 393.76 ± 4.0% | 471.26 ± 0.3% | 613.31 ± 8.7% | 758.22 ± 21.8% | 1497.64 ± 3.8% | 32953.24 ± 3.3% | 388.24 ± 2.8% | 0.98 | 1.00 | 0.63 | 0.51 |
| literal: one of four words | 26 | 279.05 ± 6.1% | 293.65 ± 0.8% | 337.24 ± 0.3% | 59.24 ± 1.3% | 290.91 ± 30.0% | 597.38 ± 0.8% | 17181.94 ± 1.4% | 279.48 ± 0.2% | 0.95 | 1.00 | 4.71 | 0.96 |
| literal: a word in any case | 11 | 245.17 ± 0.3% | 248.60 ± 4.2% | 278.35 ± 0.1% | 19.77 ± 0.8% | 833.88 ± 0.8% | refused | 25650.14 ± 0.7% | 245.05 ± 0.2% | 0.99 | 1.00 | 12.40 | 0.29 |
| literal: an href attribute | 12 | 298.41 ± 6.7% | 300.81 ± 6.7% | 347.87 ± 3.5% | 50.60 ± 0.5% | 569.41 ± 2.2% | 1273.54 ± 1.0% | 24447.16 ± 1.1% | 298.66 ± 0.2% | 0.99 | 1.00 | 5.90 | 0.52 |
| literal: a word, second text | 10 | 374.96 ± 0.5% | 380.65 ± 0.3% | 454.80 ± 0.2% | 549.29 ± 7.9% | 653.25 ± 3.3% | 1337.81 ± 0.2% | 30728.52 ± 8.8% | 374.50 ± 3.8% | 0.99 | 1.00 | 0.68 | 0.57 |
| class: two capitalized words | 23 | 326.76 ± 0.9% | 333.67 ± 0.4% | 385.58 ± 0.5% | 122.87 ± 0.7% | 594.38 ± 20.5% | 1259.53 ± 10.0% | 7857.25 ± 0.2% | 326.19 ± 0.3% | 0.98 | 1.00 | 2.66 | 0.55 |
| class: a word that ends in ing | 9 | 382.43 ± 0.2% | 392.12 ± 0.3% | 467.06 ± 0.5% | 152.19 ± 0.9% | 854.43 ± 35.6% | 1908.30 ± 1.9% | 19159.39 ± 1.2% | 381.91 ± 0.4% | 0.98 | 1.00 | 2.51 | 0.45 |
| class: a word in capitals | 16 | 351.92 ± 0.2% | 358.88 ± 0.4% | 421.08 ± 0.2% | 156.59 ± 1.2% | 886.75 ± 16.0% | 1745.26 ± 4.3% | 10423.76 ± 0.5% | 351.04 ± 0.4% | 0.98 | 1.00 | 2.25 | 0.40 |
| class: a number | 6 | 398.40 ± 0.2% | 407.18 ± 0.2% | 488.68 ± 1.2% | 48.98 ± 5.6% | 1661.62 ± 1.3% | 3012.76 ± 3.6% | 25747.49 ± 0.2% | 396.67 ± 3.5% | 0.98 | 1.00 | 8.13 | 0.24 |
| class: two capitalized words, second text | 23 | 326.92 ± 0.7% | 333.26 ± 2.7% | 385.13 ± 2.5% | 121.02 ± 1.0% | 601.39 ± 2.7% | 1231.50 ± 1.8% | 7849.69 ± 0.3% | 326.86 ± 0.2% | 0.98 | 1.00 | 2.70 | 0.54 |
| other: a word between two words | 13 | 364.75 ± 0.1% | 367.37 ± 0.3% | 432.81 ± 0.2% | 155.39 ± 5.3% | 587.14 ± 2.6% | 1326.94 ± 0.3% | 17421.81 ± 10.0% | 364.40 ± 0.2% | 0.99 | 1.00 | 2.35 | 0.62 |
| other: a number before a unit, second text | 15 | 318.40 ± 0.3% | 327.28 ± 0.9% | 381.05 ± 0.1% | 45.48 ± 4.4% | 723.78 ± 15.4% | 1415.47 ± 0.5% | 17321.23 ± 0.6% | 318.21 ± 0.3% | 0.97 | 1.00 | 7.00 | 0.44 |
| other: a heading's start tag | 13 | 297.13 ± 0.7% | 298.64 ± 5.2% | 352.01 ± 0.2% | 47.81 ± 1.0% | 715.57 ± 2.3% | 1296.42 ± 1.2% | 20508.49 ± 1.8% | 297.16 ± 0.2% | 0.99 | 1.00 | 6.22 | 0.42 |
| other: a whole word | 11 | 376.07 ± 1.1% | 380.85 ± 12.8% | 452.80 ± 4.3% | 147.45 ± 6.1% | 675.85 ± 8.8% | 1332.33 ± 3.3% | 30033.15 ± 1.1% | 375.88 ± 0.2% | 0.99 | 1.00 | 2.55 | 0.56 |
| other: a line's first word, second text | 17 | 361.83 ± 0.2% | 369.78 ± 0.4% | 434.72 ± 0.1% | 147.88 ± 4.6% | 805.34 ± 3.0% | refused | refused | 360.54 ± 1.1% | 0.98 | 1.00 | 2.45 | 0.45 |
| other: fourteen octets before an x | 16 | 108.73 ± 0.7% | 141.63 ± 0.1% | 158.57 ± 0.3% | 17.96 ± 0.3% | 518.53 ± 10.6% | 553.20 ± 7.1% | 15730.40 ± 0.3% | 108.57 ± 0.1% | 0.77 | 1.00 | 6.05 | 0.21 |
| other: a Greek word | 8 | 387.54 ± 0.8% | 400.26 ± 12.6% | 479.44 ± 1.7% | 61.83 ± 2.3% | 1654.02 ± 2.0% | 2787.32 ± 0.4% | refused | 387.47 ± 1.1% | 0.97 | 1.00 | 6.27 | 0.23 |

