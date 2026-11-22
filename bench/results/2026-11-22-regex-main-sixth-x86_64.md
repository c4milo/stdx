# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45054931209 |
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
| literal: a word | 217 | 25991.94 ± 2.0% | 864.06 ± 0.6% | 28.14 ± 8.1% | 25000.13 ± 1.2% | 9399.63 ± 9.5% | 11.98 ± 0.6% | 91.53 ± 1.8% | 26401.71 ± 1.0% | 30.08 | 0.98 | 1.04 | 2.77 |
| literal: a word that is not there | 0 | 32601.08 ± 1.6% | 872.47 ± 0.7% | 25.67 ± 0.7% | 26861.68 ± 1.5% | 30077.74 ± 1.8% | 11.75 ± 0.7% | 85.84 ± 1.5% | 32483.09 ± 1.9% | 37.37 | 1.00 | 1.21 | 1.08 |
| literal: one of four words | 661 | 8851.37 ± 0.9% | 846.26 ± 0.7% | 14.69 ± 2.5% | 7791.72 ± 2.0% | 22.06 ± 1.2% | 3.53 ± 0.4% | 6.80 ± 1.4% | 8701.68 ± 1.2% | 10.46 | 1.02 | 1.14 | 401.17 |
| literal: a word in any case | 217 | 21753.59 ± 5.7% | 861.19 ± 2.6% | 19.95 ± 1.4% | 8004.57 ± 1.4% | 44.94 ± 1.6% | refused | differs | 21382.58 ± 3.5% | 25.26 | 1.02 | 2.72 | 484.05 |
| literal: an href attribute | 33 | 25787.47 ± 0.6% | 869.87 ± 0.7% | 25.18 ± 0.9% | 22157.00 ± 1.1% | 2065.68 ± 4.8% | 8.63 ± 0.5% | 78.88 ± 2.5% | 25672.09 ± 1.6% | 29.65 | 1.00 | 1.16 | 12.48 |
| literal: a word, second text | 123 | 27629.53 ± 1.3% | 866.03 ± 0.5% | 25.52 ± 1.0% | 24841.08 ± 1.0% | 7100.65 ± 5.6% | 15.73 ± 1.0% | 77.40 ± 0.6% | 27572.04 ± 0.8% | 31.90 | 1.00 | 1.11 | 3.89 |
| class: two capitalized words | 1331 | 796.03 ± 0.6% | 795.63 ± 0.8% | 26.11 ± 1.0% | 487.43 ± 0.5% | 38.45 ± 1.9% | 10.26 ± 0.7% | 65.56 ± 1.2% | 795.62 ± 0.4% | 1.00 | 1.00 | 1.63 | 20.70 |
| class: a word that ends in ing | 3399 | 728.17 ± 1.0% | 724.03 ± 0.7% | 17.36 ± 2.2% | 460.11 ± 1.0% | 27.45 ± 9.0% | 5.78 ± 0.3% | 17.53 ± 1.5% | 725.48 ± 0.8% | 1.01 | 1.00 | 1.58 | 26.52 |
| class: a word in capitals | 2332 | 1080.53 ± 1.1% | 781.08 ± 0.6% | 25.52 ± 1.0% | 480.88 ± 0.3% | 41.69 ± 11.6% | 12.34 ± 0.4% | 82.35 ± 1.5% | 1081.19 ± 0.8% | 1.38 | 1.00 | 2.25 | 25.92 |
| class: a number | 8288 | 1627.03 ± 1.3% | 665.42 ± 0.9% | 25.15 ± 0.4% | 1714.00 ± 0.6% | 42.26 ± 8.9% | 0.34 ± 0.5% | 57.12 ± 2.1% | 1621.79 ± 0.7% | 2.45 | 1.00 | 0.95 | 38.50 |
| class: two capitalized words, second text | 5359 | 576.90 ± 0.8% | 575.21 ± 0.5% | 23.22 ± 0.7% | 408.05 ± 0.4% | 33.47 ± 11.4% | 13.45 ± 1.0% | 59.67 ± 0.8% | 576.96 ± 1.3% | 1.00 | 1.00 | 1.41 | 17.24 |
| other: a word between two words | 6104 | 679.59 ± 0.7% | 614.74 ± 0.8% | 23.32 ± 1.0% | 690.00 ± 0.9% | 107.94 ± 10.0% | 7.86 ± 0.5% | 69.03 ± 0.4% | 678.49 ± 0.9% | 1.11 | 1.00 | 0.98 | 6.30 |
| other: a number before a unit, second text | 1481 | 7985.64 ± 3.8% | 814.33 ± 2.5% | 23.95 ± 3.1% | 7532.73 ± 0.6% | 38.92 ± 0.3% | 14.11 ± 0.6% | 63.96 ± 0.6% | 7723.69 ± 20.2% | 9.81 | 1.03 | 1.06 | 205.19 |
| other: a heading's start tag | 110 | 16825.48 ± 1.0% | 861.01 ± 0.6% | 24.91 ± 0.5% | 2084.61 ± 1.3% | 1531.79 ± 8.4% | 10.73 ± 0.4% | 93.55 ± 1.7% | 16775.21 ± 1.3% | 19.54 | 1.00 | 8.07 | 10.98 |
| other: a whole word | 217 | 20418.18 ± 1.8% | 864.64 ± 0.7% | 28.29 ± 0.6% | 19818.05 ± 1.3% | 44.88 ± 2.8% | 10.25 ± 0.8% | 53.53 ± 1.6% | 20404.70 ± 0.4% | 23.61 | 1.00 | 1.03 | 454.99 |
| other: a line's first word, second text | 3716 | 2136.32 ± 1.2% | 714.69 ± 0.9% | 29.06 ± 1.6% | 2011.44 ± 0.8% | 63.58 ± 7.7% | refused | refused | 2125.58 ± 1.2% | 2.99 | 1.01 | 1.06 | 33.60 |
| other: fourteen octets before an x | 87 | 28431.77 ± 1.5% | 1.55 ± 0.5% | 1.53 ± 0.4% | 3392.47 ± 0.4% | 9.20 ± 0.9% | differs | 16.42 ± 1.0% | 28276.26 ± 1.5% | 18338.34 | 1.01 | 8.38 | 3089.40 |
| other: a Greek word | 21815 | 396.85 ± 0.4% | 272.36 ± 1.0% | 29.59 ± 1.6% | 241.42 ± 1.4% | 49.94 ± 17.9% | differs | refused | 396.30 ± 0.9% | 1.46 | 1.00 | 1.64 | 7.95 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.17 ± 2.5% | 24.14 ± 1.4% | 0.51 ± 2.7% | 22.44 ± 0.9% | 2.51 ± 2.8% | differs | 3.86 ± 1.2% | 24.17 ± 0.7% | 1.00 | 1.00 | 1.08 | 9.64 |
| a UUID | 32895 | 21.28 ± 19.4% | 21.47 ± 2.1% | 0.58 ± 11.4% | 16.86 ± 2.3% | 2.46 ± 2.1% | 0.57 ± 1.4% | 3.19 ± 2.4% | 21.45 ± 3.5% | 0.99 | 0.99 | 1.26 | 8.64 |
| an IPv4 address | 33176 | 32.94 ± 1.3% | 32.63 ± 3.0% | 1.88 ± 1.0% | 30.44 ± 1.4% | 6.03 ± 0.9% | differs | 3.53 ± 1.5% | 33.13 ± 1.6% | 1.01 | 0.99 | 1.08 | 5.46 |
| a date and time | 32954 | 31.96 ± 0.9% | 32.00 ± 2.2% | 1.32 ± 1.6% | 27.41 ± 1.1% | 7.58 ± 1.1% | 1.07 ± 0.9% | 6.99 ± 0.4% | 31.86 ± 1.6% | 1.00 | 1.00 | 1.17 | 4.22 |
| a field path | 32606 | 26.47 ± 2.5% | 26.43 ± 0.9% | 0.83 ± 1.4% | 24.45 ± 0.8% | 2.82 ± 1.1% | differs | 2.36 ± 2.9% | 26.47 ± 2.1% | 1.00 | 1.00 | 1.08 | 9.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.10 ± 0.6% | 9.09 ± 2.2% | 9.09 ± 0.9% | 11.97 ± 1.1% | 4.99 ± 1.6% | 0.83 ± 0.6% | none | 9.03 ± 1.5% | 1.00 | 1.01 | 0.76 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 218.02 ± 0.5% | 217.46 ± 2.0% | 243.39 ± 1.1% | 86.00 ± 3.2% | 202.11 ± 3.4% | 556.50 ± 1.5% | 3209.56 ± 1.8% | 216.96 ± 5.2% | 1.00 | 1.00 | 2.54 | 1.08 |
| a UUID | 62 | 166.00 ± 3.8% | 167.10 ± 0.7% | 184.08 ± 1.6% | 47.14 ± 1.6% | 90.27 ± 24.4% | 196.36 ± 1.6% | 3951.06 ± 1.7% | 166.19 ± 1.3% | 0.99 | 1.00 | 3.52 | 1.84 |
| an IPv4 address | 29 | 337.24 ± 1.0% | 339.71 ± 0.9% | 398.79 ± 1.3% | 76.92 ± 2.1% | 121.20 ± 4.0% | 348.77 ± 1.4% | 6415.15 ± 5.4% | 337.10 ± 0.4% | 0.99 | 1.00 | 4.38 | 2.78 |
| a date and time | 56 | 261.14 ± 3.9% | 271.69 ± 1.0% | 305.96 ± 1.3% | 72.41 ± 0.9% | 128.40 ± 1.8% | 363.62 ± 1.8% | 4246.68 ± 2.2% | 269.81 ± 0.2% | 0.96 | 0.97 | 3.61 | 2.03 |
| a field path | 39 | 232.98 ± 0.9% | 234.32 ± 0.8% | 261.52 ± 1.4% | 79.02 ± 2.1% | 191.35 ± 1.5% | 575.85 ± 0.8% | 4039.23 ± 0.8% | 232.12 ± 2.9% | 0.99 | 1.00 | 2.95 | 1.22 |
| literal: a word | 7 | 461.55 ± 0.7% | 459.21 ± 2.1% | 580.72 ± 4.7% | 508.15 ± 7.3% | 606.49 ± 4.7% | 1139.37 ± 5.0% | 24965.21 ± 8.7% | 461.67 ± 0.7% | 1.01 | 1.00 | 0.91 | 0.76 |
| literal: a word that is not there | 8 | 450.60 ± 1.6% | 456.83 ± 2.6% | 565.00 ± 2.5% | 472.19 ± 0.7% | 592.76 ± 2.1% | 1076.87 ± 0.8% | 23523.20 ± 1.5% | 452.51 ± 0.8% | 0.99 | 1.00 | 0.95 | 0.76 |
| literal: one of four words | 26 | 316.81 ± 5.4% | 345.46 ± 0.5% | 403.94 ± 0.6% | 41.62 ± 3.6% | 204.05 ± 19.7% | 398.33 ± 2.2% | 11936.42 ± 1.3% | 319.03 ± 1.9% | 0.92 | 0.99 | 7.61 | 1.55 |
| literal: a word in any case | 11 | 264.70 ± 1.5% | 267.99 ± 0.8% | 301.77 ± 1.3% | 12.53 ± 3.7% | 634.51 ± 2.6% | refused | 18762.32 ± 2.0% | 263.04 ± 1.3% | 0.99 | 1.01 | 21.12 | 0.42 |
| literal: an href attribute | 12 | 323.90 ± 2.1% | 325.75 ± 2.8% | 383.68 ± 0.8% | 38.35 ± 2.9% | 464.92 ± 2.6% | 937.28 ± 1.5% | 16997.90 ± 3.7% | 325.03 ± 1.0% | 0.99 | 1.00 | 8.45 | 0.70 |
| literal: a word, second text | 10 | 439.53 ± 1.0% | 443.39 ± 2.5% | 546.40 ± 0.9% | 415.51 ± 1.0% | 519.53 ± 1.8% | 959.09 ± 2.0% | 21390.31 ± 1.1% | 437.68 ± 0.8% | 0.99 | 1.00 | 1.06 | 0.85 |
| class: two capitalized words | 23 | 369.45 ± 0.5% | 375.89 ± 1.1% | 447.03 ± 2.7% | 102.28 ± 1.5% | 478.65 ± 2.3% | 892.29 ± 1.1% | 5622.15 ± 2.3% | 369.54 ± 0.7% | 0.98 | 1.00 | 3.61 | 0.77 |
| class: a word that ends in ing | 9 | 438.56 ± 0.7% | 453.06 ± 2.9% | 554.76 ± 1.7% | 135.02 ± 1.5% | 702.18 ± 2.5% | 1339.67 ± 0.6% | 13339.09 ± 1.7% | 435.94 ± 2.0% | 0.97 | 1.01 | 3.25 | 0.62 |
| class: a word in capitals | 16 | 400.46 ± 1.0% | 408.61 ± 1.8% | 490.78 ± 1.4% | 139.17 ± 2.1% | 703.78 ± 1.1% | 1244.26 ± 1.6% | 7488.61 ± 1.1% | 400.40 ± 0.9% | 0.98 | 1.00 | 2.88 | 0.57 |
| class: a number | 6 | 460.04 ± 0.5% | 470.60 ± 1.1% | 588.65 ± 0.4% | 35.22 ± 0.7% | 1303.27 ± 3.2% | 2359.57 ± 1.1% | 20042.66 ± 2.3% | 460.20 ± 1.2% | 0.98 | 1.00 | 13.06 | 0.35 |
| class: two capitalized words, second text | 23 | 369.79 ± 1.6% | 375.02 ± 1.9% | 443.54 ± 1.0% | 103.89 ± 1.0% | 472.27 ± 18.5% | 900.15 ± 1.3% | 5623.25 ± 0.7% | 369.56 ± 1.4% | 0.99 | 1.00 | 3.56 | 0.78 |
| other: a word between two words | 13 | 419.88 ± 0.3% | 415.76 ± 0.4% | 511.63 ± 0.9% | 137.98 ± 2.2% | 471.21 ± 23.5% | 942.99 ± 1.5% | 11828.49 ± 1.7% | 419.26 ± 0.9% | 1.01 | 1.00 | 3.04 | 0.89 |
| other: a number before a unit, second text | 15 | 362.99 ± 0.4% | 377.39 ± 0.9% | 449.01 ± 1.3% | 33.64 ± 0.9% | 585.08 ± 21.6% | 1121.94 ± 0.9% | 12479.07 ± 2.1% | 361.41 ± 0.6% | 0.96 | 1.00 | 10.79 | 0.62 |
| other: a heading's start tag | 13 | 320.53 ± 4.0% | 324.14 ± 3.8% | 381.93 ± 0.5% | 37.95 ± 1.0% | 577.78 ± 1.9% | 1047.05 ± 0.8% | 14899.40 ± 2.0% | 322.25 ± 0.8% | 0.99 | 0.99 | 8.45 | 0.55 |
| other: a whole word | 11 | 433.72 ± 2.9% | 434.08 ± 0.8% | 542.15 ± 0.7% | 121.96 ± 1.0% | 540.05 ± 1.7% | 995.34 ± 0.9% | 20425.59 ± 1.9% | 436.36 ± 0.9% | 1.00 | 0.99 | 3.56 | 0.80 |
| other: a line's first word, second text | 17 | 401.18 ± 1.1% | 412.33 ± 0.6% | 499.27 ± 0.7% | 133.92 ± 1.6% | 651.12 ± 15.1% | refused | refused | 401.86 ± 0.8% | 0.97 | 1.00 | 3.00 | 0.62 |
| other: fourteen octets before an x | 16 | 95.78 ± 0.6% | 120.76 ± 1.2% | 151.09 ± 4.5% | 14.71 ± 1.0% | 419.62 ± 2.2% | 475.83 ± 1.5% | 10996.93 ± 1.6% | 95.62 ± 0.3% | 0.79 | 1.00 | 6.51 | 0.23 |
| other: a Greek word | 8 | 442.57 ± 1.1% | 460.16 ± 1.0% | 566.88 ± 1.1% | 48.18 ± 0.5% | 1286.22 ± 20.9% | 2293.39 ± 1.7% | refused | 442.69 ± 1.1% | 0.96 | 1.00 | 9.19 | 0.34 |

