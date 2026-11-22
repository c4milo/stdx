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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45054928587 |
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
| literal: a word | 217 | 15493.29 ± 1.5% | 1039.25 ± 0.3% | 28.00 ± 0.2% | 18497.25 ± 2.4% | 9165.54 ± 8.7% | 17.57 ± 0.6% | 84.03 ± 0.5% | 15559.59 ± 1.5% | 14.91 | 1.00 | 0.84 | 1.69 |
| literal: a word that is not there | 0 | 18688.54 ± 2.5% | 1047.16 ± 0.3% | 27.86 ± 0.2% | 19729.00 ± 1.9% | 28785.37 ± 3.9% | 17.40 ± 0.4% | 79.67 ± 0.7% | 18703.99 ± 1.4% | 17.85 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 5771.56 ± 1.0% | 1018.17 ± 0.1% | 14.79 ± 0.5% | 3985.10 ± 0.5% | 21.88 ± 0.2% | 5.30 ± 0.1% | 6.88 ± 0.8% | 5760.41 ± 0.2% | 5.67 | 1.00 | 1.45 | 263.84 |
| literal: a word in any case | 217 | 11552.59 ± 0.6% | 1037.34 ± 0.2% | 21.29 ± 0.6% | 3987.74 ± 0.6% | 38.74 ± 2.8% | refused | differs | 11524.07 ± 0.6% | 11.14 | 1.00 | 2.90 | 298.17 |
| literal: an href attribute | 33 | 16102.09 ± 1.4% | 1044.64 ± 0.1% | 27.11 ± 0.2% | 16751.99 ± 1.1% | 2256.25 ± 0.6% | 13.45 ± 0.4% | 73.84 ± 1.0% | 16106.11 ± 2.2% | 15.41 | 1.00 | 0.96 | 7.14 |
| literal: a word, second text | 123 | 15803.57 ± 1.2% | 1042.85 ± 0.1% | 27.53 ± 0.1% | 18577.93 ± 1.3% | 7613.69 ± 7.6% | 19.69 ± 0.6% | 70.21 ± 0.4% | 15791.00 ± 1.0% | 15.15 | 1.00 | 0.85 | 2.08 |
| class: two capitalized words | 1331 | 1109.64 ± 0.3% | 957.50 ± 0.1% | 25.85 ± 0.2% | 587.46 ± 0.1% | 40.83 ± 4.9% | 14.99 ± 0.2% | 67.10 ± 0.8% | 1107.90 ± 0.3% | 1.16 | 1.00 | 1.89 | 27.18 |
| class: a word that ends in ing | 3399 | 884.38 ± 0.1% | 885.40 ± 0.3% | 18.25 ± 0.2% | 550.54 ± 0.2% | 29.50 ± 12.6% | 8.23 ± 0.4% | 18.24 ± 0.5% | 883.68 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.98 |
| class: a word in capitals | 2332 | 1474.81 ± 0.3% | 954.39 ± 0.2% | 27.26 ± 0.1% | 575.12 ± 0.2% | 43.74 ± 10.5% | 17.23 ± 0.3% | 82.44 ± 0.8% | 1473.95 ± 0.2% | 1.55 | 1.00 | 2.56 | 33.72 |
| class: a number | 8288 | 2115.79 ± 0.5% | 807.56 ± 0.2% | 27.32 ± 0.3% | 1802.27 ± 0.1% | 42.18 ± 17.3% | 0.57 ± 0.2% | 57.36 ± 0.8% | 2111.87 ± 0.5% | 2.62 | 1.00 | 1.17 | 50.16 |
| class: two capitalized words, second text | 5359 | 694.66 ± 0.2% | 696.97 ± 0.2% | 23.28 ± 0.2% | 489.25 ± 0.1% | 35.48 ± 5.4% | 16.67 ± 0.3% | 62.47 ± 1.0% | 694.46 ± 0.1% | 1.00 | 1.00 | 1.42 | 19.58 |
| other: a word between two words | 6104 | 724.90 ± 0.3% | 748.19 ± 0.1% | 23.46 ± 0.1% | 757.51 ± 0.5% | 109.32 ± 20.6% | 11.34 ± 0.2% | 68.15 ± 0.6% | 724.93 ± 0.1% | 0.97 | 1.00 | 0.96 | 6.63 |
| other: a number before a unit, second text | 1481 | 5447.52 ± 1.0% | 979.31 ± 0.2% | 25.70 ± 0.3% | 5956.96 ± 1.0% | 41.01 ± 0.2% | 17.80 ± 0.2% | 65.41 ± 0.7% | 5439.03 ± 0.5% | 5.56 | 1.00 | 0.91 | 132.83 |
| other: a heading's start tag | 110 | 12276.60 ± 0.6% | 1034.31 ± 0.2% | 26.83 ± 0.2% | 1720.19 ± 0.4% | 1586.66 ± 2.7% | 16.39 ± 0.6% | 86.11 ± 0.6% | 12278.91 ± 0.6% | 11.87 | 1.00 | 7.14 | 7.74 |
| other: a whole word | 217 | 13649.59 ± 1.3% | 1039.48 ± 0.1% | 29.21 ± 0.5% | 14744.41 ± 2.5% | 49.42 ± 0.1% | 13.85 ± 0.1% | 54.75 ± 0.3% | 13627.52 ± 0.9% | 13.13 | 1.00 | 0.93 | 276.18 |
| other: a line's first word, second text | 3716 | 1965.15 ± 0.4% | 861.59 ± 0.1% | 30.89 ± 0.3% | 1754.00 ± 0.6% | 62.11 ± 11.0% | refused | refused | 1957.16 ± 0.1% | 2.28 | 1.00 | 1.12 | 31.64 |
| other: fourteen octets before an x | 87 | 19101.58 ± 1.5% | 1.53 ± 0.1% | 1.53 ± 0.2% | 4029.85 ± 0.3% | 10.67 ± 0.2% | differs | 17.74 ± 0.1% | 19064.55 ± 0.9% | 12490.81 | 1.00 | 4.74 | 1789.44 |
| other: a Greek word | 21815 | 477.59 ± 0.7% | 323.27 ± 0.3% | 31.12 ± 0.3% | 294.53 ± 0.4% | 48.80 ± 9.8% | differs | refused | 476.44 ± 0.6% | 1.48 | 1.00 | 1.62 | 9.79 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.03 ± 0.3% | 28.04 ± 0.3% | 0.50 ± 0.2% | 21.48 ± 0.2% | 2.74 ± 0.4% | differs | 4.00 ± 0.1% | 28.02 ± 0.3% | 1.00 | 1.00 | 1.31 | 10.24 |
| a UUID | 32895 | 23.09 ± 0.3% | 23.08 ± 0.3% | 0.67 ± 0.2% | 16.05 ± 0.1% | 3.09 ± 0.4% | 0.71 ± 0.1% | 3.63 ± 0.3% | 23.10 ± 0.3% | 1.00 | 1.00 | 1.44 | 7.46 |
| an IPv4 address | 33176 | 41.62 ± 0.4% | 41.59 ± 0.3% | 2.17 ± 0.1% | 32.70 ± 0.3% | 6.67 ± 0.2% | differs | 4.06 ± 0.2% | 41.63 ± 0.3% | 1.00 | 1.00 | 1.27 | 6.24 |
| a date and time | 32954 | 34.90 ± 0.2% | 34.88 ± 0.3% | 1.50 ± 0.1% | 23.29 ± 0.3% | 7.05 ± 0.1% | 1.19 ± 0.3% | 7.04 ± 0.3% | 34.89 ± 0.3% | 1.00 | 1.00 | 1.50 | 4.95 |
| a field path | 32606 | 32.34 ± 0.2% | 32.35 ± 0.2% | 0.83 ± 0.1% | 25.24 ± 0.4% | 3.53 ± 0.3% | differs | 2.92 ± 0.3% | 32.31 ± 0.5% | 1.00 | 1.00 | 1.28 | 9.17 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.15 ± 0.1% | 10.16 ± 0.4% | 10.17 ± 0.2% | 10.99 ± 0.1% | 4.94 ± 2.0% | 0.91 ± 0.6% | none | 10.16 ± 0.2% | 1.00 | 1.00 | 0.92 | 2.05 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 189.96 ± 0.2% | 191.05 ± 0.3% | 218.56 ± 0.2% | 86.40 ± 0.3% | 221.73 ± 1.1% | 489.99 ± 0.3% | 3871.96 ± 0.4% | 190.06 ± 0.3% | 0.99 | 1.00 | 2.20 | 0.86 |
| a UUID | 62 | 145.86 ± 0.4% | 146.57 ± 0.2% | 168.35 ± 0.2% | 45.47 ± 0.1% | 99.24 ± 1.5% | 183.75 ± 0.7% | 4497.94 ± 0.7% | 145.89 ± 0.1% | 1.00 | 1.00 | 3.21 | 1.47 |
| an IPv4 address | 29 | 276.82 ± 0.4% | 278.25 ± 0.2% | 340.61 ± 0.1% | 75.81 ± 0.9% | 131.81 ± 1.6% | 294.67 ± 0.4% | 7654.02 ± 0.3% | 276.73 ± 0.2% | 0.99 | 1.00 | 3.65 | 2.10 |
| a date and time | 56 | 224.11 ± 0.2% | 225.20 ± 0.1% | 262.98 ± 0.2% | 71.56 ± 0.1% | 136.86 ± 2.5% | 323.83 ± 1.0% | 4950.07 ± 0.3% | 224.19 ± 0.1% | 1.00 | 1.00 | 3.13 | 1.64 |
| a field path | 39 | 195.04 ± 0.7% | 195.73 ± 0.2% | 223.93 ± 0.3% | 79.09 ± 0.5% | 206.03 ± 1.5% | 488.16 ± 1.2% | 4969.54 ± 0.7% | 194.89 ± 0.3% | 1.00 | 1.00 | 2.47 | 0.95 |
| literal: a word | 7 | 358.85 ± 0.2% | 368.19 ± 0.4% | 470.14 ± 0.1% | 500.46 ± 1.7% | 627.65 ± 1.9% | 926.28 ± 0.6% | 30872.62 ± 0.3% | 358.66 ± 0.3% | 0.97 | 1.00 | 0.72 | 0.57 |
| literal: a word that is not there | 8 | 352.14 ± 0.2% | 361.41 ± 0.3% | 459.36 ± 0.2% | 458.58 ± 0.2% | 604.76 ± 2.2% | 878.34 ± 0.9% | 29290.03 ± 0.9% | 352.08 ± 0.1% | 0.97 | 1.00 | 0.77 | 0.58 |
| literal: one of four words | 26 | 252.02 ± 0.2% | 266.06 ± 0.5% | 322.63 ± 0.4% | 48.83 ± 0.3% | 240.98 ± 0.6% | 356.63 ± 0.3% | 15739.85 ± 0.2% | 252.21 ± 0.1% | 0.95 | 1.00 | 5.16 | 1.05 |
| literal: a word in any case | 11 | 225.23 ± 0.3% | 228.32 ± 0.2% | 268.80 ± 0.1% | 15.67 ± 0.9% | 661.28 ± 2.8% | refused | 23616.22 ± 0.5% | 225.50 ± 0.1% | 0.99 | 1.00 | 14.37 | 0.34 |
| literal: an href attribute | 12 | 263.06 ± 0.5% | 265.77 ± 0.5% | 325.47 ± 0.3% | 44.81 ± 0.5% | 502.01 ± 10.5% | 772.04 ± 1.5% | 22231.76 ± 0.2% | 263.07 ± 0.5% | 0.99 | 1.00 | 5.87 | 0.52 |
| literal: a word, second text | 10 | 337.73 ± 0.4% | 347.32 ± 0.3% | 440.97 ± 0.0% | 405.95 ± 0.5% | 537.60 ± 0.8% | 802.76 ± 0.7% | 27234.53 ± 0.5% | 337.83 ± 0.4% | 0.97 | 1.00 | 0.83 | 0.63 |
| class: two capitalized words | 23 | 290.10 ± 0.4% | 297.24 ± 0.2% | 360.57 ± 0.3% | 100.42 ± 0.1% | 500.67 ± 5.0% | 748.16 ± 1.1% | 6532.00 ± 0.8% | 289.76 ± 0.3% | 0.98 | 1.00 | 2.89 | 0.58 |
| class: a word that ends in ing | 9 | 349.70 ± 0.3% | 360.62 ± 0.1% | 454.29 ± 0.4% | 131.87 ± 1.2% | 764.70 ± 1.4% | 1090.24 ± 1.9% | 16076.38 ± 0.2% | 349.55 ± 0.1% | 0.97 | 1.00 | 2.65 | 0.46 |
| class: a word in capitals | 16 | 320.61 ± 0.3% | 329.06 ± 0.2% | 404.28 ± 0.1% | 134.87 ± 0.8% | 749.49 ± 2.4% | 1013.80 ± 1.2% | 8583.87 ± 0.3% | 320.66 ± 0.2% | 0.97 | 1.00 | 2.38 | 0.43 |
| class: a number | 6 | 368.41 ± 0.3% | 379.49 ± 0.4% | 483.66 ± 0.2% | 41.58 ± 0.4% | 1403.70 ± 0.9% | 1904.23 ± 0.6% | 22871.82 ± 0.1% | 368.79 ± 0.2% | 0.97 | 1.00 | 8.86 | 0.26 |
| class: two capitalized words, second text | 23 | 290.33 ± 0.3% | 297.06 ± 0.3% | 360.62 ± 0.2% | 102.31 ± 0.2% | 505.17 ± 1.4% | 751.12 ± 0.8% | 6534.33 ± 0.9% | 290.44 ± 0.2% | 0.98 | 1.00 | 2.84 | 0.57 |
| other: a word between two words | 13 | 330.09 ± 0.3% | 334.54 ± 0.1% | 416.37 ± 0.1% | 134.47 ± 0.6% | 507.19 ± 1.7% | 814.09 ± 0.3% | 14937.62 ± 0.2% | 330.11 ± 0.2% | 0.99 | 1.00 | 2.45 | 0.65 |
| other: a number before a unit, second text | 15 | 295.45 ± 0.5% | 306.65 ± 0.3% | 373.84 ± 0.2% | 38.94 ± 0.5% | 636.75 ± 2.9% | 892.07 ± 0.4% | 15373.89 ± 0.1% | 296.37 ± 0.5% | 0.96 | 1.00 | 7.59 | 0.46 |
| other: a heading's start tag | 13 | 263.49 ± 0.4% | 265.30 ± 0.3% | 325.88 ± 0.3% | 43.07 ± 0.3% | 637.25 ± 1.3% | 863.95 ± 0.2% | 18518.99 ± 0.1% | 263.48 ± 0.1% | 0.99 | 1.00 | 6.12 | 0.41 |
| other: a whole word | 11 | 345.48 ± 0.3% | 351.72 ± 0.6% | 444.87 ± 0.3% | 118.96 ± 0.3% | 565.81 ± 0.9% | 828.41 ± 0.9% | 27101.65 ± 0.2% | 345.52 ± 0.3% | 0.98 | 1.00 | 2.90 | 0.61 |
| other: a line's first word, second text | 17 | 329.26 ± 0.2% | 335.01 ± 0.3% | 415.93 ± 0.2% | 126.84 ± 0.9% | 709.51 ± 1.2% | refused | refused | 328.98 ± 0.9% | 0.98 | 1.00 | 2.60 | 0.46 |
| other: fourteen octets before an x | 16 | 90.44 ± 0.6% | 113.04 ± 0.5% | 151.41 ± 0.9% | 14.95 ± 0.4% | 454.25 ± 1.7% | 426.79 ± 0.8% | 13146.83 ± 0.8% | 90.66 ± 0.5% | 0.80 | 1.00 | 6.05 | 0.20 |
| other: a Greek word | 8 | 356.63 ± 0.5% | 370.58 ± 0.3% | 470.65 ± 0.3% | 58.44 ± 0.3% | 1391.41 ± 0.5% | 1787.49 ± 0.5% | refused | 356.96 ± 0.4% | 0.96 | 1.00 | 6.10 | 0.26 |

