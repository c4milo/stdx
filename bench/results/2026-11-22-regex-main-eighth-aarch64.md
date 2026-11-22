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
| literal: a word | 217 | 15666.50 ± 0.8% | 1040.82 ± 0.2% | 28.57 ± 0.5% | 18195.19 ± 2.4% | 9089.50 ± 8.3% | 17.39 ± 0.6% | 84.20 ± 1.4% | 15618.82 ± 0.4% | 15.05 | 1.00 | 0.86 | 1.72 |
| literal: a word that is not there | 0 | 18583.13 ± 0.6% | 1047.40 ± 0.7% | 28.55 ± 0.6% | 19445.31 ± 2.8% | 28165.60 ± 1.8% | 17.14 ± 0.1% | 79.53 ± 2.1% | 18574.08 ± 1.2% | 17.74 | 1.00 | 0.96 | 0.66 |
| literal: one of four words | 661 | 5779.75 ± 0.5% | 1018.50 ± 0.2% | 15.01 ± 0.1% | 3981.53 ± 0.4% | 21.86 ± 0.1% | 5.43 ± 0.3% | 6.78 ± 0.6% | 5757.85 ± 0.5% | 5.67 | 1.00 | 1.45 | 264.39 |
| literal: a word in any case | 217 | 11562.12 ± 0.9% | 1037.90 ± 0.3% | 21.87 ± 1.8% | 3978.97 ± 0.3% | 38.66 ± 0.8% | refused | differs | 11542.45 ± 0.3% | 11.14 | 1.00 | 2.91 | 299.10 |
| literal: an href attribute | 33 | 15977.53 ± 1.6% | 1044.62 ± 0.2% | 27.69 ± 0.2% | 16737.20 ± 2.0% | 2263.39 ± 0.9% | 13.13 ± 0.3% | 74.28 ± 2.0% | 16001.37 ± 0.5% | 15.30 | 1.00 | 0.95 | 7.06 |
| literal: a word, second text | 123 | 15669.25 ± 0.9% | 1043.01 ± 0.1% | 28.25 ± 0.3% | 18155.58 ± 1.4% | 7612.25 ± 3.6% | 20.00 ± 0.4% | 70.41 ± 1.3% | 15718.26 ± 1.1% | 15.02 | 1.00 | 0.86 | 2.06 |
| class: two capitalized words | 1331 | 1110.87 ± 0.4% | 957.10 ± 0.3% | 26.37 ± 0.2% | 583.39 ± 0.3% | 40.87 ± 0.3% | 14.85 ± 0.3% | 67.38 ± 1.0% | 1109.25 ± 0.4% | 1.16 | 1.00 | 1.90 | 27.18 |
| class: a word that ends in ing | 3399 | 884.42 ± 0.2% | 885.39 ± 0.1% | 18.46 ± 0.2% | 547.82 ± 0.2% | 29.53 ± 2.5% | 8.20 ± 0.1% | 18.19 ± 0.5% | 875.53 ± 0.2% | 1.00 | 1.01 | 1.61 | 29.95 |
| class: a word in capitals | 2332 | 1475.98 ± 0.2% | 953.03 ± 0.4% | 27.86 ± 0.2% | 574.37 ± 0.3% | 43.73 ± 16.8% | 17.17 ± 0.3% | 82.65 ± 1.3% | 1474.88 ± 0.5% | 1.55 | 1.00 | 2.57 | 33.75 |
| class: a number | 8288 | 2116.55 ± 0.5% | 807.06 ± 0.1% | 28.07 ± 0.3% | 1791.90 ± 0.2% | 43.52 ± 5.9% | 0.56 ± 0.4% | 57.74 ± 0.4% | 2118.86 ± 0.4% | 2.62 | 1.00 | 1.18 | 48.64 |
| class: two capitalized words, second text | 5359 | 693.48 ± 0.3% | 695.93 ± 0.1% | 23.60 ± 0.2% | 490.74 ± 0.2% | 35.57 ± 11.5% | 17.36 ± 0.2% | 62.70 ± 0.4% | 693.08 ± 0.2% | 1.00 | 1.00 | 1.41 | 19.50 |
| other: a word between two words | 6104 | 725.55 ± 0.4% | 748.25 ± 0.6% | 23.85 ± 0.1% | 752.57 ± 0.3% | 102.55 ± 12.9% | 11.30 ± 0.2% | 68.25 ± 2.5% | 713.13 ± 0.3% | 0.97 | 1.02 | 0.96 | 7.08 |
| other: a number before a unit, second text | 1481 | 5458.68 ± 0.7% | 979.62 ± 0.2% | 26.32 ± 0.3% | 5890.77 ± 0.6% | 40.96 ± 0.2% | 18.20 ± 0.2% | 65.72 ± 0.4% | 5437.39 ± 0.8% | 5.57 | 1.00 | 0.93 | 133.27 |
| other: a heading's start tag | 110 | 12343.58 ± 0.6% | 1034.80 ± 0.1% | 27.47 ± 0.3% | 1725.11 ± 0.5% | 1591.56 ± 2.6% | 16.13 ± 0.4% | 86.41 ± 0.4% | 12308.05 ± 0.8% | 11.93 | 1.00 | 7.16 | 7.76 |
| other: a whole word | 217 | 13639.60 ± 0.7% | 1040.04 ± 0.2% | 30.08 ± 0.6% | 14485.04 ± 1.8% | 49.39 ± 0.4% | 13.33 ± 0.3% | 54.97 ± 1.0% | 13665.43 ± 0.5% | 13.11 | 1.00 | 0.94 | 276.15 |
| other: a line's first word, second text | 3716 | 1969.01 ± 0.4% | 862.28 ± 0.2% | 31.80 ± 0.3% | 1751.00 ± 0.4% | 62.53 ± 2.4% | refused | refused | 1958.44 ± 0.8% | 2.28 | 1.01 | 1.12 | 31.49 |
| other: fourteen octets before an x | 87 | 19222.48 ± 1.2% | 1.53 ± 0.2% | 1.53 ± 0.1% | 3968.73 ± 0.3% | 10.70 ± 0.1% | differs | 17.78 ± 0.3% | 19134.92 ± 1.7% | 12539.17 | 1.00 | 4.84 | 1796.31 |
| other: a Greek word | 21815 | 477.98 ± 0.8% | 322.98 ± 0.2% | 31.49 ± 0.5% | 293.85 ± 0.2% | 44.47 ± 9.5% | differs | refused | 477.99 ± 1.1% | 1.48 | 1.00 | 1.63 | 10.75 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.92 ± 0.2% | 27.91 ± 0.2% | 0.50 ± 0.1% | 21.34 ± 0.5% | 2.76 ± 0.6% | differs | 4.02 ± 0.2% | 27.93 ± 0.1% | 1.00 | 1.00 | 1.31 | 10.11 |
| a UUID | 32895 | 23.17 ± 0.3% | 23.22 ± 0.2% | 0.66 ± 0.1% | 15.98 ± 0.2% | 3.09 ± 0.5% | 0.73 ± 0.2% | 3.63 ± 0.3% | 23.18 ± 0.2% | 1.00 | 1.00 | 1.45 | 7.50 |
| an IPv4 address | 33176 | 41.45 ± 0.3% | 41.45 ± 0.2% | 2.17 ± 0.1% | 32.62 ± 0.3% | 6.69 ± 0.2% | differs | 4.07 ± 0.2% | 41.45 ± 0.3% | 1.00 | 1.00 | 1.27 | 6.19 |
| a date and time | 32954 | 34.65 ± 0.3% | 34.79 ± 0.1% | 1.50 ± 0.2% | 23.57 ± 0.2% | 7.05 ± 0.2% | 1.26 ± 0.5% | 7.11 ± 0.5% | 34.79 ± 0.1% | 1.00 | 1.00 | 1.47 | 4.91 |
| a field path | 32606 | 32.28 ± 0.3% | 32.30 ± 0.3% | 0.83 ± 0.1% | 25.50 ± 0.4% | 3.49 ± 1.3% | differs | 2.94 ± 0.4% | 32.24 ± 0.2% | 1.00 | 1.00 | 1.27 | 9.25 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.18 ± 0.6% | 10.18 ± 0.5% | 10.18 ± 0.2% | 11.48 ± 0.2% | 4.97 ± 1.2% | 0.93 ± 0.7% | none | 10.17 ± 0.4% | 1.00 | 1.00 | 0.89 | 2.05 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 226.65 ± 0.2% | 227.54 ± 0.2% | 257.86 ± 0.2% | 86.87 ± 0.2% | 221.70 ± 1.2% | 484.16 ± 0.8% | 3872.90 ± 0.7% | 226.59 ± 0.3% | 1.00 | 1.00 | 2.61 | 1.02 |
| a UUID | 62 | 170.29 ± 0.3% | 170.66 ± 0.2% | 189.35 ± 0.2% | 46.37 ± 0.3% | 99.28 ± 0.7% | 185.23 ± 2.8% | 4476.46 ± 0.4% | 170.14 ± 0.3% | 1.00 | 1.00 | 3.67 | 1.72 |
| an IPv4 address | 29 | 348.62 ± 0.3% | 350.41 ± 0.2% | 429.08 ± 0.1% | 76.84 ± 0.6% | 132.12 ± 1.6% | 293.85 ± 0.8% | 7631.73 ± 0.5% | 348.22 ± 0.3% | 0.99 | 1.00 | 4.54 | 2.64 |
| a date and time | 56 | 266.10 ± 0.5% | 267.98 ± 0.2% | 311.00 ± 0.2% | 73.02 ± 0.4% | 137.51 ± 1.3% | 320.97 ± 1.4% | 4931.93 ± 0.8% | 266.09 ± 0.3% | 0.99 | 1.00 | 3.64 | 1.94 |
| a field path | 39 | 233.31 ± 0.3% | 234.13 ± 0.2% | 266.85 ± 0.3% | 80.64 ± 0.5% | 208.31 ± 0.3% | 506.85 ± 1.3% | 4961.19 ± 0.3% | 233.07 ± 0.1% | 1.00 | 1.00 | 2.89 | 1.12 |
| literal: a word | 7 | 481.67 ± 0.5% | 490.98 ± 0.4% | 660.59 ± 0.6% | 521.14 ± 0.3% | 634.04 ± 5.7% | 949.89 ± 0.8% | 30301.26 ± 0.1% | 481.32 ± 0.4% | 0.98 | 1.00 | 0.92 | 0.76 |
| literal: a word that is not there | 8 | 469.94 ± 0.4% | 479.45 ± 0.2% | 640.25 ± 0.3% | 470.08 ± 0.3% | 607.62 ± 1.8% | 898.77 ± 0.4% | 29065.44 ± 0.1% | 469.71 ± 0.1% | 0.98 | 1.00 | 1.00 | 0.77 |
| literal: one of four words | 26 | 312.70 ± 0.8% | 333.75 ± 0.2% | 406.23 ± 0.3% | 48.83 ± 0.7% | 243.25 ± 1.6% | 369.60 ± 2.1% | 15547.45 ± 0.2% | 312.69 ± 0.5% | 0.94 | 1.00 | 6.40 | 1.29 |
| literal: a word in any case | 11 | 271.49 ± 0.1% | 275.23 ± 0.2% | 323.83 ± 0.0% | 15.67 ± 0.6% | 651.96 ± 2.6% | refused | 23519.54 ± 0.4% | 271.43 ± 0.4% | 0.99 | 1.00 | 17.33 | 0.42 |
| literal: an href attribute | 12 | 333.27 ± 0.3% | 335.20 ± 0.3% | 409.42 ± 0.1% | 45.52 ± 0.7% | 505.74 ± 0.9% | 775.60 ± 0.6% | 21568.44 ± 0.2% | 333.41 ± 0.3% | 0.99 | 1.00 | 7.32 | 0.66 |
| literal: a word, second text | 10 | 446.90 ± 0.4% | 458.43 ± 0.5% | 605.05 ± 0.3% | 423.10 ± 0.8% | 538.86 ± 2.0% | 810.42 ± 0.4% | 26903.59 ± 0.3% | 447.33 ± 0.3% | 0.97 | 1.00 | 1.06 | 0.83 |
| class: two capitalized words | 23 | 361.91 ± 0.6% | 370.50 ± 0.5% | 460.67 ± 0.8% | 100.55 ± 0.2% | 499.72 ± 10.4% | 760.51 ± 0.6% | 6496.18 ± 1.0% | 360.89 ± 0.6% | 0.98 | 1.00 | 3.60 | 0.72 |
| class: a word that ends in ing | 9 | 457.64 ± 0.5% | 477.11 ± 0.4% | 632.93 ± 0.2% | 131.34 ± 1.2% | 761.30 ± 0.8% | 1107.87 ± 2.5% | 15912.23 ± 0.3% | 457.61 ± 0.2% | 0.96 | 1.00 | 3.48 | 0.60 |
| class: a word in capitals | 16 | 407.49 ± 0.3% | 418.98 ± 0.2% | 534.55 ± 0.7% | 135.42 ± 0.4% | 753.04 ± 1.8% | 1008.83 ± 0.5% | 8588.45 ± 0.3% | 407.30 ± 0.3% | 0.97 | 1.00 | 3.01 | 0.54 |
| class: a number | 6 | 491.07 ± 0.2% | 508.44 ± 0.2% | 685.09 ± 0.2% | 41.83 ± 0.6% | 1411.71 ± 2.9% | 1925.90 ± 0.9% | 22788.52 ± 0.1% | 491.29 ± 0.4% | 0.97 | 1.00 | 11.74 | 0.35 |
| class: two capitalized words, second text | 23 | 361.75 ± 0.4% | 370.84 ± 0.3% | 460.69 ± 0.4% | 103.56 ± 0.4% | 500.40 ± 2.1% | 743.74 ± 1.2% | 6497.04 ± 1.4% | 362.42 ± 0.2% | 0.98 | 1.00 | 3.49 | 0.72 |
| other: a word between two words | 13 | 431.04 ± 0.1% | 435.30 ± 0.4% | 563.43 ± 0.2% | 134.45 ± 1.2% | 510.21 ± 0.7% | 816.24 ± 0.5% | 14811.34 ± 0.6% | 431.07 ± 0.3% | 0.99 | 1.00 | 3.21 | 0.84 |
| other: a number before a unit, second text | 15 | 374.05 ± 0.3% | 390.39 ± 0.3% | 491.17 ± 0.1% | 39.34 ± 0.4% | 642.72 ± 1.0% | 890.97 ± 0.5% | 15173.62 ± 0.2% | 373.88 ± 0.1% | 0.96 | 1.00 | 9.51 | 0.58 |
| other: a heading's start tag | 13 | 334.83 ± 0.4% | 337.22 ± 0.7% | 412.15 ± 0.4% | 44.41 ± 0.3% | 640.05 ± 1.4% | 868.45 ± 0.3% | 18096.38 ± 0.2% | 334.71 ± 0.4% | 0.99 | 1.00 | 7.54 | 0.52 |
| other: a whole word | 11 | 456.21 ± 0.3% | 461.62 ± 0.7% | 610.62 ± 0.2% | 121.39 ± 0.6% | 568.11 ± 2.1% | 818.78 ± 1.1% | 26809.53 ± 0.3% | 456.54 ± 0.3% | 0.99 | 1.00 | 3.76 | 0.80 |
| other: a line's first word, second text | 17 | 423.94 ± 0.2% | 433.36 ± 0.3% | 559.41 ± 0.1% | 129.06 ± 0.2% | 713.31 ± 1.4% | refused | refused | 423.52 ± 0.5% | 0.98 | 1.00 | 3.28 | 0.59 |
| other: fourteen octets before an x | 16 | 111.72 ± 0.7% | 147.91 ± 1.0% | 168.41 ± 1.2% | 14.94 ± 0.3% | 454.70 ± 1.0% | 407.01 ± 0.9% | 12929.94 ± 0.5% | 111.57 ± 0.6% | 0.76 | 1.00 | 7.48 | 0.25 |
| other: a Greek word | 8 | 475.15 ± 0.6% | 496.57 ± 0.2% | 666.98 ± 0.3% | 59.11 ± 0.3% | 1395.99 ± 1.8% | 1843.83 ± 0.6% | refused | 475.10 ± 0.4% | 0.96 | 1.00 | 8.04 | 0.34 |

