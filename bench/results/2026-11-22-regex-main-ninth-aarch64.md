# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
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
| literal: a word | 217 | 15469.20 ± 1.5% | 1039.21 ± 0.8% | 27.98 ± 0.1% | 18182.54 ± 2.6% | 9282.93 ± 7.2% | 17.60 ± 0.4% | 84.25 ± 0.6% | 15538.65 ± 1.5% | 14.89 | 1.00 | 0.85 | 1.67 |
| literal: a word that is not there | 0 | 18466.77 ± 4.6% | 1047.97 ± 0.7% | 27.83 ± 0.4% | 19432.10 ± 4.6% | 28593.48 ± 1.6% | 17.43 ± 0.1% | 79.59 ± 0.4% | 18473.71 ± 3.1% | 17.62 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 5760.25 ± 0.3% | 1017.97 ± 0.2% | 14.78 ± 0.3% | 3976.98 ± 0.2% | 21.87 ± 0.1% | 5.32 ± 0.2% | 6.86 ± 0.6% | 5750.43 ± 0.4% | 5.66 | 1.00 | 1.45 | 263.37 |
| literal: a word in any case | 217 | 11526.82 ± 0.8% | 1037.39 ± 0.1% | 21.64 ± 2.0% | 3985.64 ± 0.2% | 38.78 ± 0.6% | refused | differs | 11519.44 ± 0.6% | 11.11 | 1.00 | 2.89 | 297.24 |
| literal: an href attribute | 33 | 16287.98 ± 1.6% | 1045.60 ± 0.2% | 27.12 ± 0.2% | 16860.44 ± 1.3% | 2267.25 ± 0.4% | 13.46 ± 0.3% | 73.94 ± 0.2% | 16345.33 ± 2.2% | 15.58 | 1.00 | 0.97 | 7.18 |
| literal: a word, second text | 123 | 15707.01 ± 1.8% | 1042.31 ± 0.1% | 27.54 ± 0.2% | 18311.95 ± 2.8% | 7664.13 ± 10.0% | 19.45 ± 0.4% | 70.20 ± 0.5% | 15868.15 ± 1.8% | 15.07 | 0.99 | 0.86 | 2.05 |
| class: two capitalized words | 1331 | 1111.85 ± 0.4% | 957.54 ± 0.1% | 25.86 ± 0.2% | 584.25 ± 0.0% | 40.83 ± 0.1% | 15.07 ± 0.1% | 67.20 ± 0.3% | 1110.33 ± 0.4% | 1.16 | 1.00 | 1.90 | 27.23 |
| class: a word that ends in ing | 3399 | 884.19 ± 0.1% | 885.66 ± 0.1% | 18.23 ± 0.2% | 548.24 ± 0.2% | 29.52 ± 12.1% | 8.21 ± 0.3% | 18.22 ± 0.3% | 883.49 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.95 |
| class: a word in capitals | 2332 | 1479.25 ± 0.5% | 952.74 ± 0.0% | 27.25 ± 0.2% | 574.56 ± 0.1% | 43.71 ± 6.0% | 17.24 ± 0.6% | 82.74 ± 0.1% | 1476.74 ± 0.4% | 1.55 | 1.00 | 2.57 | 33.84 |
| class: a number | 8288 | 2124.31 ± 0.4% | 807.98 ± 0.1% | 27.31 ± 0.1% | 1799.33 ± 0.1% | 43.30 ± 13.8% | 0.57 ± 0.2% | 57.40 ± 0.2% | 2122.20 ± 0.2% | 2.63 | 1.00 | 1.18 | 49.06 |
| class: two capitalized words, second text | 5359 | 694.46 ± 0.2% | 696.94 ± 0.1% | 23.27 ± 0.1% | 490.34 ± 0.1% | 34.66 ± 13.6% | 16.92 ± 0.2% | 62.58 ± 0.4% | 694.13 ± 0.2% | 1.00 | 1.00 | 1.42 | 20.04 |
| other: a word between two words | 6104 | 725.07 ± 0.2% | 747.83 ± 0.1% | 23.46 ± 0.2% | 757.02 ± 0.4% | 109.68 ± 9.8% | 11.49 ± 0.2% | 68.13 ± 1.2% | 725.28 ± 0.1% | 0.97 | 1.00 | 0.96 | 6.61 |
| other: a number before a unit, second text | 1481 | 5451.47 ± 1.2% | 979.83 ± 0.2% | 25.72 ± 0.1% | 5918.47 ± 0.7% | 40.95 ± 10.3% | 17.89 ± 0.3% | 65.44 ± 0.3% | 5443.43 ± 0.9% | 5.56 | 1.00 | 0.92 | 133.12 |
| other: a heading's start tag | 110 | 12363.31 ± 0.9% | 1034.93 ± 0.1% | 26.85 ± 0.3% | 1722.11 ± 0.2% | 1590.22 ± 4.2% | 16.40 ± 0.4% | 86.13 ± 1.9% | 12405.36 ± 1.0% | 11.95 | 1.00 | 7.18 | 7.77 |
| other: a whole word | 217 | 13547.13 ± 0.7% | 1039.22 ± 0.3% | 29.25 ± 0.5% | 14629.37 ± 0.7% | 49.39 ± 0.3% | 13.81 ± 0.1% | 54.50 ± 0.6% | 13519.98 ± 0.9% | 13.04 | 1.00 | 0.93 | 274.27 |
| other: a line's first word, second text | 3716 | 1968.61 ± 0.8% | 858.43 ± 0.1% | 30.90 ± 0.3% | 1762.56 ± 0.4% | 63.46 ± 5.3% | refused | refused | 1964.29 ± 0.9% | 2.29 | 1.00 | 1.12 | 31.02 |
| other: fourteen octets before an x | 87 | 18968.49 ± 2.5% | 1.53 ± 0.1% | 1.53 ± 0.1% | 3955.03 ± 0.5% | 10.67 ± 0.1% | differs | 17.78 ± 0.2% | 18892.47 ± 0.9% | 12396.54 | 1.00 | 4.80 | 1777.25 |
| other: a Greek word | 21815 | 466.67 ± 0.7% | 324.18 ± 0.2% | 31.13 ± 0.1% | 294.63 ± 0.4% | 44.51 ± 17.9% | differs | refused | 477.98 ± 0.2% | 1.44 | 0.98 | 1.58 | 10.48 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.00 ± 0.1% | 27.99 ± 0.1% | 0.50 ± 0.1% | 21.32 ± 0.2% | 2.75 ± 0.7% | differs | 4.00 ± 0.1% | 27.99 ± 0.2% | 1.00 | 1.00 | 1.31 | 10.19 |
| a UUID | 32895 | 23.11 ± 0.2% | 23.10 ± 0.2% | 0.66 ± 0.2% | 16.00 ± 0.3% | 3.09 ± 0.3% | 0.72 ± 0.2% | 3.63 ± 0.4% | 23.11 ± 0.3% | 1.00 | 1.00 | 1.44 | 7.49 |
| an IPv4 address | 33176 | 41.62 ± 0.3% | 41.56 ± 0.3% | 2.17 ± 0.1% | 32.53 ± 0.1% | 6.69 ± 0.3% | differs | 4.04 ± 0.1% | 41.63 ± 0.2% | 1.00 | 1.00 | 1.28 | 6.22 |
| a date and time | 32954 | 34.83 ± 0.2% | 34.84 ± 0.1% | 1.50 ± 0.2% | 23.46 ± 0.4% | 7.05 ± 0.1% | 1.19 ± 0.2% | 7.05 ± 0.5% | 34.84 ± 0.2% | 1.00 | 1.00 | 1.48 | 4.94 |
| a field path | 32606 | 32.35 ± 0.5% | 32.37 ± 0.3% | 0.83 ± 0.2% | 25.43 ± 0.1% | 3.53 ± 1.0% | differs | 2.92 ± 0.2% | 32.28 ± 0.5% | 1.00 | 1.00 | 1.27 | 9.18 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.16 ± 0.3% | 10.16 ± 0.2% | 10.16 ± 0.3% | 11.00 ± 0.2% | 4.96 ± 1.2% | 0.91 ± 0.5% | none | 10.16 ± 0.2% | 1.00 | 1.00 | 0.92 | 2.05 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 194.85 ± 0.3% | 195.20 ± 0.5% | 218.53 ± 0.3% | 86.92 ± 0.2% | 220.80 ± 0.5% | 485.91 ± 0.8% | 3876.18 ± 0.4% | 194.85 ± 0.2% | 1.00 | 1.00 | 2.24 | 0.88 |
| a UUID | 62 | 151.56 ± 0.2% | 152.02 ± 0.3% | 168.38 ± 0.2% | 46.37 ± 0.3% | 98.39 ± 1.4% | 186.10 ± 2.9% | 4503.03 ± 0.4% | 151.39 ± 0.1% | 1.00 | 1.00 | 3.27 | 1.54 |
| an IPv4 address | 29 | 285.65 ± 0.4% | 287.15 ± 0.3% | 340.12 ± 0.2% | 76.79 ± 0.5% | 131.41 ± 1.2% | 295.48 ± 0.9% | 7655.25 ± 0.3% | 285.73 ± 0.1% | 0.99 | 1.00 | 3.72 | 2.17 |
| a date and time | 56 | 229.02 ± 0.3% | 229.85 ± 0.3% | 263.19 ± 0.2% | 72.87 ± 0.6% | 136.16 ± 0.8% | 317.92 ± 0.7% | 4961.69 ± 0.6% | 228.96 ± 0.1% | 1.00 | 1.00 | 3.14 | 1.68 |
| a field path | 39 | 198.33 ± 0.0% | 199.19 ± 0.2% | 223.62 ± 0.4% | 80.52 ± 0.5% | 206.62 ± 1.8% | 507.66 ± 1.7% | 4959.58 ± 0.8% | 198.47 ± 0.0% | 1.00 | 1.00 | 2.46 | 0.96 |
| literal: a word | 7 | 369.06 ± 0.3% | 375.59 ± 0.4% | 469.89 ± 0.4% | 521.83 ± 0.3% | 626.43 ± 3.2% | 947.84 ± 0.5% | 30866.10 ± 0.1% | 368.86 ± 0.4% | 0.98 | 1.00 | 0.71 | 0.59 |
| literal: a word that is not there | 8 | 361.40 ± 0.1% | 367.77 ± 0.1% | 459.09 ± 0.5% | 470.68 ± 0.1% | 614.07 ± 2.0% | 896.27 ± 0.6% | 29309.41 ± 0.2% | 361.36 ± 0.1% | 0.98 | 1.00 | 0.77 | 0.59 |
| literal: one of four words | 26 | 258.66 ± 0.2% | 273.48 ± 0.4% | 323.05 ± 0.3% | 48.75 ± 0.4% | 235.37 ± 3.3% | 363.57 ± 2.0% | 15717.21 ± 0.2% | 258.32 ± 0.5% | 0.95 | 1.00 | 5.31 | 1.10 |
| literal: a word in any case | 11 | 231.06 ± 0.1% | 233.62 ± 0.1% | 268.81 ± 0.1% | 15.67 ± 0.6% | 645.37 ± 3.5% | refused | 23585.20 ± 0.4% | 231.01 ± 0.1% | 0.99 | 1.00 | 14.75 | 0.36 |
| literal: an href attribute | 12 | 272.76 ± 0.6% | 274.56 ± 0.5% | 325.21 ± 0.7% | 45.48 ± 0.8% | 497.66 ± 12.0% | 776.24 ± 0.9% | 22220.72 ± 0.2% | 272.55 ± 0.2% | 0.99 | 1.00 | 6.00 | 0.55 |
| literal: a word, second text | 10 | 347.51 ± 0.3% | 353.97 ± 0.4% | 440.81 ± 0.2% | 423.94 ± 0.7% | 535.28 ± 1.7% | 806.13 ± 0.6% | 27237.31 ± 0.2% | 347.49 ± 0.1% | 0.98 | 1.00 | 0.82 | 0.65 |
| class: two capitalized words | 23 | 295.67 ± 0.7% | 300.80 ± 0.5% | 360.22 ± 0.2% | 100.41 ± 0.2% | 494.45 ± 1.3% | 746.62 ± 0.6% | 6544.03 ± 0.4% | 295.63 ± 0.4% | 0.98 | 1.00 | 2.94 | 0.60 |
| class: a word that ends in ing | 9 | 354.00 ± 0.2% | 366.13 ± 0.4% | 454.39 ± 0.1% | 130.97 ± 1.2% | 732.61 ± 3.1% | 1105.51 ± 2.0% | 16089.20 ± 0.1% | 354.19 ± 0.2% | 0.97 | 1.00 | 2.70 | 0.48 |
| class: a word in capitals | 16 | 325.84 ± 0.7% | 333.29 ± 0.3% | 404.62 ± 0.1% | 134.97 ± 0.2% | 744.19 ± 1.0% | 1013.03 ± 0.7% | 8587.15 ± 0.6% | 325.53 ± 0.4% | 0.98 | 1.00 | 2.41 | 0.44 |
| class: a number | 6 | 375.40 ± 0.3% | 384.85 ± 0.2% | 483.87 ± 0.1% | 41.77 ± 0.2% | 1378.16 ± 1.1% | 1900.84 ± 1.9% | 22866.21 ± 0.0% | 375.42 ± 0.2% | 0.98 | 1.00 | 8.99 | 0.27 |
| class: two capitalized words, second text | 23 | 295.45 ± 0.4% | 301.57 ± 0.4% | 360.22 ± 0.2% | 103.12 ± 0.5% | 492.26 ± 2.8% | 737.46 ± 0.5% | 6539.36 ± 0.6% | 295.38 ± 0.7% | 0.98 | 1.00 | 2.87 | 0.60 |
| other: a word between two words | 13 | 337.25 ± 0.2% | 340.46 ± 0.2% | 416.61 ± 0.1% | 134.07 ± 1.0% | 500.89 ± 4.8% | 809.88 ± 1.1% | 14929.82 ± 0.2% | 337.01 ± 0.1% | 0.99 | 1.00 | 2.52 | 0.67 |
| other: a number before a unit, second text | 15 | 300.70 ± 0.4% | 311.42 ± 0.3% | 374.25 ± 0.3% | 39.18 ± 0.3% | 624.10 ± 1.2% | 891.40 ± 0.2% | 15376.54 ± 0.1% | 300.60 ± 0.1% | 0.97 | 1.00 | 7.68 | 0.48 |
| other: a heading's start tag | 13 | 273.48 ± 0.3% | 275.30 ± 0.3% | 325.98 ± 0.3% | 44.34 ± 0.3% | 625.78 ± 3.3% | 868.20 ± 0.2% | 18521.34 ± 0.1% | 273.21 ± 0.1% | 0.99 | 1.00 | 6.17 | 0.44 |
| other: a whole word | 11 | 353.76 ± 0.3% | 358.09 ± 0.1% | 444.77 ± 0.2% | 121.08 ± 0.6% | 555.87 ± 1.9% | 821.37 ± 1.0% | 27099.89 ± 0.3% | 354.11 ± 0.2% | 0.99 | 1.00 | 2.92 | 0.64 |
| other: a line's first word, second text | 17 | 334.62 ± 0.3% | 341.11 ± 0.4% | 416.31 ± 0.1% | 128.59 ± 0.1% | 696.19 ± 0.5% | refused | refused | 333.55 ± 0.5% | 0.98 | 1.00 | 2.60 | 0.48 |
| other: fourteen octets before an x | 16 | 101.61 ± 1.1% | 131.48 ± 0.9% | 151.54 ± 0.9% | 15.13 ± 0.3% | 447.75 ± 0.5% | 414.43 ± 0.6% | 13163.97 ± 0.5% | 101.40 ± 1.2% | 0.77 | 1.00 | 6.71 | 0.23 |
| other: a Greek word | 8 | 364.28 ± 0.4% | 378.13 ± 0.3% | 471.30 ± 0.3% | 59.14 ± 0.5% | 1372.80 ± 0.8% | 1785.86 ± 0.6% | refused | 364.35 ± 0.4% | 0.96 | 1.00 | 6.16 | 0.27 |

