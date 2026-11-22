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
| literal: a word | 217 | 15642.85 ± 1.5% | 1039.52 ± 0.6% | 28.53 ± 0.4% | 18657.76 ± 2.5% | 9161.16 ± 8.3% | 17.39 ± 0.3% | 84.24 ± 0.6% | 15682.20 ± 1.9% | 15.05 | 1.00 | 0.84 | 1.71 |
| literal: a word that is not there | 0 | 18662.37 ± 1.8% | 1047.38 ± 0.2% | 28.52 ± 0.9% | 19973.82 ± 1.8% | 29159.36 ± 1.3% | 17.14 ± 0.1% | 79.91 ± 0.5% | 18843.58 ± 1.1% | 17.82 | 0.99 | 0.93 | 0.64 |
| literal: one of four words | 661 | 5785.21 ± 0.4% | 1017.92 ± 0.2% | 15.01 ± 0.2% | 3986.08 ± 0.1% | 21.85 ± 0.3% | 5.42 ± 0.4% | 6.88 ± 1.2% | 5776.00 ± 0.2% | 5.68 | 1.00 | 1.45 | 264.71 |
| literal: a word in any case | 217 | 11598.09 ± 0.4% | 1038.11 ± 0.1% | 21.60 ± 1.8% | 3987.42 ± 0.1% | 38.73 ± 0.5% | refused | differs | 11601.09 ± 0.2% | 11.17 | 1.00 | 2.91 | 299.48 |
| literal: an href attribute | 33 | 16273.16 ± 2.0% | 1045.65 ± 0.1% | 27.68 ± 0.2% | 16970.57 ± 2.0% | 2267.16 ± 0.3% | 13.16 ± 0.2% | 73.69 ± 2.0% | 16313.81 ± 2.8% | 15.56 | 1.00 | 0.96 | 7.18 |
| literal: a word, second text | 123 | 15697.73 ± 1.2% | 1042.27 ± 0.1% | 28.25 ± 0.1% | 18327.38 ± 2.1% | 7774.81 ± 3.7% | 20.14 ± 0.7% | 70.38 ± 0.4% | 15755.68 ± 0.9% | 15.06 | 1.00 | 0.86 | 2.02 |
| class: two capitalized words | 1331 | 1111.19 ± 0.2% | 957.32 ± 0.1% | 26.34 ± 0.2% | 587.23 ± 0.6% | 40.89 ± 7.7% | 14.74 ± 0.5% | 67.46 ± 0.4% | 1110.91 ± 0.2% | 1.16 | 1.00 | 1.89 | 27.18 |
| class: a word that ends in ing | 3399 | 885.23 ± 0.0% | 886.46 ± 0.1% | 18.45 ± 0.2% | 549.98 ± 0.1% | 29.59 ± 3.0% | 8.21 ± 0.2% | 18.26 ± 0.1% | 885.06 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.92 |
| class: a word in capitals | 2332 | 1477.33 ± 0.4% | 953.91 ± 0.2% | 27.85 ± 0.2% | 575.05 ± 0.1% | 43.71 ± 17.1% | 17.21 ± 0.2% | 82.76 ± 0.3% | 1479.64 ± 0.3% | 1.55 | 1.00 | 2.57 | 33.80 |
| class: a number | 8288 | 2124.19 ± 0.2% | 807.59 ± 0.1% | 28.08 ± 0.1% | 1793.92 ± 0.2% | 43.14 ± 4.5% | 0.55 ± 0.2% | 57.86 ± 0.4% | 2121.71 ± 0.2% | 2.63 | 1.00 | 1.18 | 49.23 |
| class: two capitalized words, second text | 5359 | 693.57 ± 0.1% | 695.84 ± 0.1% | 23.66 ± 0.1% | 489.04 ± 0.1% | 35.54 ± 9.0% | 17.13 ± 0.2% | 62.80 ± 0.4% | 693.30 ± 0.2% | 1.00 | 1.00 | 1.42 | 19.51 |
| other: a word between two words | 6104 | 726.00 ± 0.1% | 748.36 ± 0.2% | 23.84 ± 0.2% | 755.12 ± 0.7% | 108.28 ± 20.2% | 11.21 ± 0.1% | 68.26 ± 1.6% | 725.99 ± 0.1% | 0.97 | 1.00 | 0.96 | 6.70 |
| other: a number before a unit, second text | 1481 | 5464.12 ± 0.5% | 979.37 ± 0.1% | 26.27 ± 0.1% | 5906.99 ± 0.5% | 40.94 ± 0.2% | 18.23 ± 0.0% | 65.82 ± 0.2% | 5458.01 ± 0.3% | 5.58 | 1.00 | 0.93 | 133.46 |
| other: a heading's start tag | 110 | 12355.99 ± 0.2% | 1035.22 ± 0.1% | 27.43 ± 0.2% | 1720.95 ± 0.2% | 1588.81 ± 4.8% | 16.17 ± 0.7% | 86.43 ± 0.1% | 12354.15 ± 0.6% | 11.94 | 1.00 | 7.18 | 7.78 |
| other: a whole word | 217 | 13745.36 ± 1.5% | 1039.41 ± 0.1% | 30.13 ± 0.4% | 14722.82 ± 0.6% | 49.38 ± 0.4% | 13.38 ± 0.1% | 55.24 ± 1.1% | 13748.67 ± 1.6% | 13.22 | 1.00 | 0.93 | 278.36 |
| other: a line's first word, second text | 3716 | 1969.23 ± 0.6% | 862.48 ± 0.1% | 31.83 ± 0.2% | 1752.82 ± 0.2% | 62.55 ± 6.3% | refused | refused | 1962.93 ± 0.7% | 2.28 | 1.00 | 1.12 | 31.48 |
| other: fourteen octets before an x | 87 | 19249.47 ± 1.4% | 1.53 ± 0.1% | 1.53 ± 0.3% | 3894.14 ± 0.4% | 10.67 ± 0.1% | differs | 17.77 ± 0.5% | 19168.39 ± 0.6% | 12563.10 | 1.00 | 4.94 | 1804.53 |
| other: a Greek word | 21815 | 479.43 ± 0.6% | 323.22 ± 0.2% | 31.48 ± 0.2% | 293.75 ± 0.2% | 47.37 ± 16.5% | differs | refused | 478.41 ± 0.5% | 1.48 | 1.00 | 1.63 | 10.12 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.91 ± 0.2% | 27.92 ± 0.1% | 0.50 ± 0.2% | 21.62 ± 0.4% | 2.76 ± 0.3% | differs | 4.01 ± 0.3% | 27.91 ± 0.1% | 1.00 | 1.00 | 1.29 | 10.12 |
| a UUID | 32895 | 23.18 ± 0.3% | 23.17 ± 0.2% | 0.67 ± 0.1% | 16.07 ± 0.2% | 3.09 ± 0.5% | 0.73 ± 0.2% | 3.62 ± 0.9% | 23.16 ± 0.1% | 1.00 | 1.00 | 1.44 | 7.51 |
| an IPv4 address | 33176 | 41.41 ± 0.1% | 41.40 ± 0.1% | 2.17 ± 0.4% | 32.81 ± 0.1% | 6.68 ± 0.3% | differs | 4.06 ± 0.2% | 41.42 ± 0.2% | 1.00 | 1.00 | 1.26 | 6.20 |
| a date and time | 32954 | 34.86 ± 0.2% | 34.85 ± 0.1% | 1.51 ± 0.3% | 23.52 ± 0.1% | 7.05 ± 0.1% | 1.25 ± 0.3% | 7.09 ± 0.4% | 34.86 ± 0.2% | 1.00 | 1.00 | 1.48 | 4.94 |
| a field path | 32606 | 32.30 ± 0.3% | 32.31 ± 0.2% | 0.83 ± 0.2% | 25.31 ± 0.4% | 3.51 ± 0.4% | differs | 2.94 ± 0.4% | 32.26 ± 0.1% | 1.00 | 1.00 | 1.28 | 9.20 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.18 ± 0.1% | 10.19 ± 0.2% | 10.18 ± 0.1% | 11.56 ± 0.3% | 4.95 ± 2.2% | 0.93 ± 0.8% | none | 10.18 ± 0.4% | 1.00 | 1.00 | 0.88 | 2.06 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 224.71 ± 0.4% | 225.97 ± 0.7% | 256.29 ± 0.4% | 86.58 ± 0.2% | 220.91 ± 1.3% | 491.86 ± 0.3% | 3849.81 ± 0.2% | 225.20 ± 0.3% | 0.99 | 1.00 | 2.60 | 1.02 |
| a UUID | 62 | 170.01 ± 0.2% | 170.44 ± 0.2% | 188.86 ± 0.2% | 45.66 ± 0.2% | 98.29 ± 1.3% | 182.81 ± 0.8% | 4453.86 ± 0.2% | 169.83 ± 0.3% | 1.00 | 1.00 | 3.72 | 1.73 |
| an IPv4 address | 29 | 347.29 ± 0.2% | 349.35 ± 0.4% | 427.44 ± 0.4% | 76.72 ± 1.0% | 131.25 ± 1.0% | 290.81 ± 0.7% | 7585.73 ± 0.3% | 347.18 ± 0.4% | 0.99 | 1.00 | 4.53 | 2.65 |
| a date and time | 56 | 264.60 ± 0.3% | 266.26 ± 0.1% | 309.63 ± 0.2% | 72.41 ± 0.2% | 135.34 ± 0.3% | 322.84 ± 0.8% | 4922.12 ± 0.8% | 264.47 ± 0.4% | 0.99 | 1.00 | 3.65 | 1.96 |
| a field path | 39 | 232.03 ± 0.3% | 232.63 ± 0.2% | 265.34 ± 0.1% | 79.85 ± 0.4% | 204.81 ± 1.2% | 490.57 ± 1.0% | 4929.39 ± 0.8% | 231.80 ± 0.2% | 1.00 | 1.00 | 2.91 | 1.13 |
| literal: a word | 7 | 478.82 ± 0.3% | 489.60 ± 0.1% | 657.19 ± 0.2% | 514.58 ± 1.6% | 624.65 ± 3.4% | 927.47 ± 0.9% | 29301.94 ± 0.2% | 478.93 ± 0.3% | 0.98 | 1.00 | 0.93 | 0.77 |
| literal: a word that is not there | 8 | 467.97 ± 0.3% | 477.46 ± 0.1% | 637.13 ± 0.2% | 469.99 ± 0.2% | 602.08 ± 2.4% | 882.43 ± 0.3% | 28383.80 ± 0.4% | 467.60 ± 0.2% | 0.98 | 1.00 | 1.00 | 0.78 |
| literal: one of four words | 26 | 311.27 ± 0.3% | 331.82 ± 0.1% | 403.75 ± 0.1% | 49.13 ± 0.5% | 238.76 ± 1.5% | 362.20 ± 0.6% | 15516.45 ± 0.2% | 311.25 ± 0.2% | 0.94 | 1.00 | 6.34 | 1.30 |
| literal: a word in any case | 11 | 270.88 ± 0.2% | 274.53 ± 0.1% | 322.70 ± 0.3% | 15.73 ± 0.7% | 644.85 ± 1.7% | refused | 23057.14 ± 0.7% | 270.90 ± 0.1% | 0.99 | 1.00 | 17.22 | 0.42 |
| literal: an href attribute | 12 | 331.91 ± 0.4% | 334.15 ± 0.5% | 406.85 ± 0.4% | 45.19 ± 0.3% | 502.57 ± 0.9% | 774.30 ± 1.8% | 21207.30 ± 0.5% | 331.99 ± 0.3% | 0.99 | 1.00 | 7.35 | 0.66 |
| literal: a word, second text | 10 | 445.23 ± 0.2% | 455.64 ± 0.5% | 601.65 ± 0.2% | 417.02 ± 0.2% | 532.67 ± 1.2% | 801.72 ± 0.4% | 26286.51 ± 0.4% | 445.32 ± 0.2% | 0.98 | 1.00 | 1.07 | 0.84 |
| class: two capitalized words | 23 | 360.16 ± 0.5% | 369.14 ± 0.5% | 458.84 ± 0.4% | 101.81 ± 0.2% | 496.29 ± 7.6% | 746.51 ± 0.8% | 6475.38 ± 0.2% | 360.58 ± 0.3% | 0.98 | 1.00 | 3.54 | 0.73 |
| class: a word that ends in ing | 9 | 454.63 ± 0.6% | 474.11 ± 0.6% | 628.71 ± 0.4% | 133.29 ± 0.7% | 761.58 ± 1.0% | 1085.17 ± 1.6% | 15643.25 ± 0.2% | 454.53 ± 0.6% | 0.96 | 1.00 | 3.41 | 0.60 |
| class: a word in capitals | 16 | 406.97 ± 0.4% | 418.33 ± 0.5% | 533.26 ± 0.2% | 136.02 ± 0.8% | 752.40 ± 1.5% | 1016.11 ± 0.9% | 8538.65 ± 0.1% | 406.87 ± 0.2% | 0.97 | 1.00 | 2.99 | 0.54 |
| class: a number | 6 | 490.23 ± 0.3% | 506.87 ± 0.3% | 683.42 ± 0.1% | 41.98 ± 0.4% | 1405.79 ± 1.8% | 1946.26 ± 0.9% | 22479.38 ± 0.2% | 490.68 ± 0.3% | 0.97 | 1.00 | 11.68 | 0.35 |
| class: two capitalized words, second text | 23 | 361.08 ± 0.2% | 369.65 ± 0.4% | 457.71 ± 0.3% | 103.63 ± 0.4% | 504.69 ± 1.2% | 748.35 ± 0.5% | 6473.48 ± 0.4% | 360.38 ± 0.2% | 0.98 | 1.00 | 3.48 | 0.72 |
| other: a word between two words | 13 | 429.10 ± 0.3% | 432.87 ± 0.3% | 559.72 ± 0.1% | 136.32 ± 0.5% | 505.00 ± 2.1% | 818.60 ± 0.7% | 14604.53 ± 0.2% | 428.75 ± 0.2% | 0.99 | 1.00 | 3.15 | 0.85 |
| other: a number before a unit, second text | 15 | 372.76 ± 0.6% | 388.97 ± 0.4% | 489.05 ± 0.3% | 39.34 ± 0.5% | 631.42 ± 1.7% | 896.09 ± 0.3% | 14948.14 ± 0.3% | 372.69 ± 0.7% | 0.96 | 1.00 | 9.48 | 0.59 |
| other: a heading's start tag | 13 | 332.66 ± 0.5% | 335.04 ± 0.7% | 409.27 ± 0.6% | 43.67 ± 0.5% | 633.69 ± 0.5% | 867.79 ± 0.2% | 17785.37 ± 0.4% | 332.73 ± 0.5% | 0.99 | 1.00 | 7.62 | 0.52 |
| other: a whole word | 11 | 453.89 ± 0.4% | 459.59 ± 0.4% | 606.84 ± 0.4% | 120.87 ± 0.3% | 567.82 ± 2.3% | 827.76 ± 1.0% | 26012.61 ± 0.3% | 453.34 ± 0.3% | 0.99 | 1.00 | 3.76 | 0.80 |
| other: a line's first word, second text | 17 | 421.99 ± 0.4% | 432.37 ± 0.5% | 557.94 ± 0.2% | 128.70 ± 0.2% | 717.55 ± 0.5% | refused | refused | 420.43 ± 0.5% | 0.98 | 1.00 | 3.28 | 0.59 |
| other: fourteen octets before an x | 16 | 111.63 ± 0.5% | 147.59 ± 0.9% | 168.14 ± 0.9% | 15.13 ± 0.3% | 453.50 ± 2.1% | 420.29 ± 0.7% | 12736.24 ± 0.7% | 111.45 ± 0.3% | 0.76 | 1.00 | 7.38 | 0.25 |
| other: a Greek word | 8 | 474.17 ± 0.6% | 494.82 ± 0.5% | 663.95 ± 0.4% | 58.64 ± 0.4% | 1388.84 ± 0.7% | 1856.05 ± 0.3% | refused | 474.94 ± 0.3% | 0.96 | 1.00 | 8.09 | 0.34 |

