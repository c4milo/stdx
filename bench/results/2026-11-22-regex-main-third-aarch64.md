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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45054923452 |
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
| literal: a word | 217 | 15552.51 ± 2.9% | 1040.11 ± 0.1% | 28.00 ± 0.2% | 18350.82 ± 0.8% | 9048.65 ± 8.1% | 17.62 ± 0.8% | 84.22 ± 0.3% | 15623.34 ± 2.5% | 14.95 | 1.00 | 0.85 | 1.72 |
| literal: a word that is not there | 0 | 18749.97 ± 2.0% | 1047.75 ± 0.2% | 27.86 ± 0.3% | 19269.31 ± 3.7% | 28416.45 ± 2.8% | 17.44 ± 0.4% | 79.59 ± 0.5% | 18807.87 ± 0.8% | 17.90 | 1.00 | 0.97 | 0.66 |
| literal: one of four words | 661 | 5764.77 ± 0.5% | 1017.82 ± 0.1% | 14.82 ± 0.4% | 3976.92 ± 0.7% | 21.88 ± 0.2% | 5.30 ± 0.3% | 6.88 ± 1.1% | 5758.15 ± 0.1% | 5.66 | 1.00 | 1.45 | 263.42 |
| literal: a word in any case | 217 | 11538.06 ± 0.3% | 1036.94 ± 0.4% | 21.26 ± 0.3% | 3987.27 ± 0.4% | 38.65 ± 0.1% | refused | differs | 11524.64 ± 0.4% | 11.13 | 1.00 | 2.89 | 298.55 |
| literal: an href attribute | 33 | 16141.81 ± 2.0% | 1044.49 ± 0.2% | 27.11 ± 0.3% | 17006.47 ± 3.6% | 2262.41 ± 0.4% | 13.46 ± 0.3% | 73.93 ± 0.6% | 16152.27 ± 1.8% | 15.45 | 1.00 | 0.95 | 7.13 |
| literal: a word, second text | 123 | 15897.71 ± 2.2% | 1043.06 ± 0.2% | 27.54 ± 0.2% | 18726.62 ± 2.2% | 7654.13 ± 6.3% | 19.72 ± 0.5% | 70.23 ± 0.5% | 15944.53 ± 0.6% | 15.24 | 1.00 | 0.85 | 2.08 |
| class: two capitalized words | 1331 | 1109.24 ± 0.5% | 957.27 ± 0.5% | 25.87 ± 0.2% | 586.96 ± 0.1% | 40.88 ± 12.5% | 14.98 ± 0.4% | 67.15 ± 0.7% | 1109.57 ± 0.3% | 1.16 | 1.00 | 1.89 | 27.14 |
| class: a word that ends in ing | 3399 | 884.29 ± 0.1% | 885.02 ± 0.0% | 18.25 ± 0.1% | 550.40 ± 0.1% | 29.58 ± 3.1% | 8.26 ± 0.9% | 18.26 ± 0.4% | 883.60 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.89 |
| class: a word in capitals | 2332 | 1476.47 ± 0.6% | 953.45 ± 0.3% | 27.22 ± 0.2% | 574.83 ± 0.2% | 43.76 ± 3.1% | 17.05 ± 0.3% | 82.67 ± 1.3% | 1476.86 ± 0.3% | 1.55 | 1.00 | 2.57 | 33.74 |
| class: a number | 8288 | 2116.26 ± 0.3% | 807.68 ± 0.1% | 27.29 ± 0.2% | 1802.03 ± 0.6% | 41.03 ± 16.0% | 0.57 ± 0.2% | 57.25 ± 0.5% | 2110.83 ± 0.6% | 2.62 | 1.00 | 1.17 | 51.58 |
| class: two capitalized words, second text | 5359 | 694.67 ± 0.5% | 696.54 ± 0.2% | 23.28 ± 0.2% | 488.88 ± 0.1% | 35.31 ± 11.0% | 16.68 ± 0.1% | 62.49 ± 0.2% | 693.83 ± 0.1% | 1.00 | 1.00 | 1.42 | 19.67 |
| other: a word between two words | 6104 | 725.27 ± 0.4% | 741.60 ± 0.1% | 23.47 ± 0.2% | 757.55 ± 0.3% | 107.08 ± 13.3% | 11.34 ± 0.1% | 68.06 ± 0.2% | 724.66 ± 0.3% | 0.98 | 1.00 | 0.96 | 6.77 |
| other: a number before a unit, second text | 1481 | 5458.28 ± 0.7% | 968.73 ± 0.2% | 25.72 ± 0.3% | 5948.82 ± 0.4% | 40.96 ± 15.6% | 17.80 ± 0.2% | 65.50 ± 0.5% | 5451.28 ± 0.4% | 5.63 | 1.00 | 0.92 | 133.27 |
| other: a heading's start tag | 110 | 12312.27 ± 0.6% | 1034.54 ± 0.2% | 26.85 ± 0.6% | 1719.29 ± 0.2% | 1598.34 ± 0.9% | 16.40 ± 0.4% | 86.24 ± 2.4% | 12273.14 ± 0.5% | 11.90 | 1.00 | 7.16 | 7.70 |
| other: a whole word | 217 | 13676.42 ± 0.4% | 1039.41 ± 0.1% | 29.18 ± 0.3% | 14760.15 ± 0.9% | 49.45 ± 0.7% | 13.83 ± 0.3% | 54.70 ± 0.7% | 13642.21 ± 0.5% | 13.16 | 1.00 | 0.93 | 276.58 |
| other: a line's first word, second text | 3716 | 1960.04 ± 0.9% | 861.15 ± 0.2% | 30.77 ± 0.3% | 1756.51 ± 0.2% | 62.22 ± 5.8% | refused | refused | 1955.66 ± 0.7% | 2.28 | 1.00 | 1.12 | 31.50 |
| other: fourteen octets before an x | 87 | 19100.16 ± 1.9% | 1.53 ± 0.1% | 1.53 ± 0.2% | 4000.29 ± 0.6% | 10.68 ± 0.2% | differs | 17.74 ± 0.4% | 19087.66 ± 0.4% | 12480.95 | 1.00 | 4.77 | 1788.69 |
| other: a Greek word | 21815 | 477.62 ± 0.8% | 323.31 ± 0.3% | 31.15 ± 0.2% | 294.95 ± 0.3% | 44.06 ± 9.0% | differs | refused | 474.18 ± 0.6% | 1.48 | 1.01 | 1.62 | 10.84 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.98 ± 0.1% | 27.98 ± 0.2% | 0.50 ± 0.2% | 21.47 ± 0.2% | 2.76 ± 0.5% | differs | 4.00 ± 0.2% | 27.98 ± 0.2% | 1.00 | 1.00 | 1.30 | 10.15 |
| a UUID | 32895 | 23.07 ± 0.3% | 23.04 ± 0.5% | 0.66 ± 0.2% | 16.03 ± 0.3% | 3.08 ± 1.9% | 0.72 ± 0.3% | 3.62 ± 0.6% | 23.07 ± 0.1% | 1.00 | 1.00 | 1.44 | 7.50 |
| an IPv4 address | 33176 | 41.53 ± 0.4% | 41.50 ± 0.2% | 2.17 ± 0.1% | 32.64 ± 0.3% | 6.67 ± 0.3% | differs | 4.06 ± 0.0% | 41.54 ± 0.2% | 1.00 | 1.00 | 1.27 | 6.23 |
| a date and time | 32954 | 34.88 ± 0.2% | 34.89 ± 0.1% | 1.50 ± 0.2% | 23.26 ± 0.2% | 7.06 ± 0.1% | 1.20 ± 0.1% | 7.04 ± 0.4% | 34.88 ± 0.2% | 1.00 | 1.00 | 1.50 | 4.94 |
| a field path | 32606 | 32.32 ± 0.2% | 32.32 ± 0.3% | 0.83 ± 0.2% | 25.22 ± 0.3% | 3.48 ± 1.1% | differs | 2.92 ± 0.3% | 32.30 ± 0.3% | 1.00 | 1.00 | 1.28 | 9.28 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.16 ± 0.3% | 10.16 ± 0.1% | 10.16 ± 0.3% | 10.87 ± 0.2% | 4.91 ± 1.4% | 0.91 ± 0.2% | none | 10.14 ± 0.3% | 1.00 | 1.00 | 0.93 | 2.07 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 194.58 ± 0.1% | 195.00 ± 0.2% | 218.12 ± 0.4% | 86.47 ± 0.9% | 217.25 ± 1.6% | 489.16 ± 3.2% | 3868.43 ± 0.6% | 194.63 ± 0.3% | 1.00 | 1.00 | 2.25 | 0.90 |
| a UUID | 62 | 151.42 ± 0.3% | 152.01 ± 0.2% | 168.31 ± 0.1% | 45.91 ± 0.5% | 98.12 ± 1.3% | 191.01 ± 2.1% | 4502.31 ± 0.6% | 151.25 ± 0.3% | 1.00 | 1.00 | 3.30 | 1.54 |
| an IPv4 address | 29 | 285.85 ± 0.2% | 287.35 ± 0.1% | 340.68 ± 0.1% | 77.22 ± 0.7% | 130.56 ± 5.8% | 303.04 ± 0.5% | 7663.03 ± 0.4% | 285.78 ± 0.3% | 0.99 | 1.00 | 3.70 | 2.19 |
| a date and time | 56 | 229.03 ± 0.2% | 229.76 ± 0.6% | 263.25 ± 0.3% | 73.29 ± 0.3% | 136.35 ± 1.3% | 329.97 ± 0.5% | 4964.78 ± 0.5% | 229.10 ± 0.2% | 1.00 | 1.00 | 3.12 | 1.68 |
| a field path | 39 | 198.32 ± 0.2% | 199.24 ± 0.3% | 224.00 ± 0.3% | 80.22 ± 1.2% | 205.06 ± 2.0% | 501.97 ± 1.2% | 4965.66 ± 0.8% | 198.52 ± 0.1% | 1.00 | 1.00 | 2.47 | 0.97 |
| literal: a word | 7 | 369.02 ± 0.2% | 375.69 ± 0.1% | 470.33 ± 0.2% | 508.91 ± 1.4% | 620.15 ± 2.3% | 958.98 ± 0.7% | 30946.62 ± 0.9% | 368.78 ± 0.3% | 0.98 | 1.00 | 0.73 | 0.60 |
| literal: a word that is not there | 8 | 361.41 ± 0.3% | 367.85 ± 0.2% | 459.50 ± 0.0% | 467.35 ± 0.2% | 599.77 ± 1.3% | 906.85 ± 0.8% | 29313.57 ± 0.1% | 361.28 ± 0.2% | 0.98 | 1.00 | 0.77 | 0.60 |
| literal: one of four words | 26 | 257.95 ± 0.2% | 273.43 ± 0.3% | 322.59 ± 0.3% | 50.28 ± 0.7% | 238.03 ± 1.1% | 375.69 ± 2.3% | 15739.76 ± 0.3% | 258.01 ± 0.4% | 0.94 | 1.00 | 5.13 | 1.08 |
| literal: a word in any case | 11 | 231.16 ± 0.3% | 233.51 ± 0.2% | 268.95 ± 0.1% | 15.44 ± 0.2% | 639.12 ± 1.9% | refused | 23614.45 ± 0.7% | 231.08 ± 0.2% | 0.99 | 1.00 | 14.97 | 0.36 |
| literal: an href attribute | 12 | 273.01 ± 0.4% | 274.84 ± 0.6% | 325.53 ± 0.4% | 45.13 ± 1.2% | 497.58 ± 1.2% | 773.99 ± 1.2% | 22222.15 ± 0.3% | 272.94 ± 0.4% | 0.99 | 1.00 | 6.05 | 0.55 |
| literal: a word, second text | 10 | 347.56 ± 0.1% | 354.10 ± 0.2% | 440.61 ± 0.3% | 418.67 ± 0.4% | 530.61 ± 1.2% | 803.56 ± 0.6% | 27269.60 ± 0.4% | 347.56 ± 0.1% | 0.98 | 1.00 | 0.83 | 0.66 |
| class: two capitalized words | 23 | 295.55 ± 0.5% | 301.54 ± 0.3% | 360.32 ± 0.2% | 98.98 ± 0.2% | 496.39 ± 1.0% | 732.17 ± 2.0% | 6533.68 ± 1.4% | 295.72 ± 0.6% | 0.98 | 1.00 | 2.99 | 0.60 |
| class: a word that ends in ing | 9 | 353.63 ± 0.3% | 366.00 ± 0.4% | 454.20 ± 0.2% | 131.22 ± 0.7% | 751.56 ± 1.0% | 1102.25 ± 1.8% | 16083.23 ± 0.2% | 353.76 ± 0.3% | 0.97 | 1.00 | 2.69 | 0.47 |
| class: a word in capitals | 16 | 325.45 ± 0.3% | 333.02 ± 0.6% | 404.34 ± 0.2% | 134.09 ± 1.0% | 743.92 ± 1.8% | 1044.14 ± 1.8% | 8585.86 ± 0.1% | 325.31 ± 0.3% | 0.98 | 1.00 | 2.43 | 0.44 |
| class: a number | 6 | 375.33 ± 0.2% | 385.19 ± 0.2% | 483.78 ± 0.0% | 41.62 ± 0.7% | 1395.49 ± 1.9% | 1909.29 ± 0.8% | 22876.11 ± 0.3% | 375.12 ± 0.2% | 0.97 | 1.00 | 9.02 | 0.27 |
| class: two capitalized words, second text | 23 | 295.45 ± 1.5% | 301.76 ± 0.2% | 360.30 ± 0.5% | 100.28 ± 1.5% | 491.02 ± 2.3% | 744.38 ± 1.4% | 6518.68 ± 0.5% | 295.28 ± 0.4% | 0.98 | 1.00 | 2.95 | 0.60 |
| other: a word between two words | 13 | 337.01 ± 0.2% | 340.56 ± 0.3% | 416.22 ± 0.3% | 133.74 ± 0.4% | 498.70 ± 1.7% | 816.34 ± 0.5% | 14945.37 ± 0.1% | 336.88 ± 0.3% | 0.99 | 1.00 | 2.52 | 0.68 |
| other: a number before a unit, second text | 15 | 300.13 ± 0.4% | 311.29 ± 0.3% | 374.46 ± 0.3% | 39.32 ± 0.2% | 624.37 ± 1.7% | 887.89 ± 0.2% | 15383.58 ± 0.2% | 299.95 ± 0.5% | 0.96 | 1.00 | 7.63 | 0.48 |
| other: a heading's start tag | 13 | 273.29 ± 0.4% | 275.33 ± 0.2% | 326.02 ± 0.2% | 43.57 ± 0.7% | 630.08 ± 1.4% | 878.05 ± 0.2% | 18519.82 ± 0.2% | 272.68 ± 0.4% | 0.99 | 1.00 | 6.27 | 0.43 |
| other: a whole word | 11 | 353.59 ± 0.2% | 357.89 ± 0.1% | 444.64 ± 0.2% | 118.48 ± 0.6% | 557.13 ± 2.0% | 840.51 ± 0.8% | 27133.61 ± 1.7% | 353.54 ± 0.1% | 0.99 | 1.00 | 2.98 | 0.63 |
| other: a line's first word, second text | 17 | 334.27 ± 0.3% | 341.32 ± 0.3% | 416.08 ± 0.3% | 125.25 ± 0.2% | 704.68 ± 0.8% | refused | refused | 334.08 ± 0.5% | 0.98 | 1.00 | 2.67 | 0.47 |
| other: fourteen octets before an x | 16 | 101.37 ± 1.3% | 131.43 ± 0.5% | 151.51 ± 0.8% | 15.06 ± 0.1% | 448.54 ± 1.3% | 419.31 ± 1.2% | 13150.71 ± 0.7% | 101.47 ± 1.2% | 0.77 | 1.00 | 6.73 | 0.23 |
| other: a Greek word | 8 | 363.67 ± 0.4% | 377.87 ± 0.4% | 471.28 ± 0.1% | 59.13 ± 0.9% | 1369.51 ± 0.9% | 1773.04 ± 0.7% | refused | 364.21 ± 0.1% | 0.96 | 1.00 | 6.15 | 0.27 |

