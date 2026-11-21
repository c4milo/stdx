# bench-regex

| Field | Value |
|---|---|
| Commit | 22f6bba |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44951161023 |
| Date | 2026-11-21 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache, `stdx, no skip` the same with claim R1 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 5303.70 ± 0.3% | 560.95 ± 0.1% | 28.84 ± 0.3% | 18254.53 ± 1.9% | 9237.86 ± 7.3% | 17.34 ± 0.4% | 86.26 ± 0.2% | 5302.44 ± 0.2% | 9.45 | 1.00 | 0.29 | 0.57 |
| literal: a word that is not there | 0 | 5364.15 ± 0.7% | 560.76 ± 0.7% | 28.98 ± 0.4% | 19539.52 ± 3.1% | 27090.37 ± 1.9% | 17.03 ± 0.3% | 80.57 ± 0.6% | 5371.18 ± 0.4% | 9.57 | 1.00 | 0.27 | 0.20 |
| literal: one of four words | 661 | 2455.32 ± 2.8% | 556.29 ± 0.4% | 15.10 ± 0.1% | 3979.38 ± 0.4% | 21.92 ± 0.2% | 5.37 ± 0.1% | 6.96 ± 0.2% | 2460.98 ± 1.8% | 4.41 | 1.00 | 0.62 | 112.03 |
| literal: a word in any case | 217 | 2708.62 ± 1.2% | 560.74 ± 0.1% | 21.97 ± 0.3% | 3978.47 ± 0.3% | 38.61 ± 0.3% | refused | differs | 2700.97 ± 1.3% | 4.83 | 1.00 | 0.68 | 70.16 |
| literal: an href attribute | 33 | 1609.51 ± 0.6% | 561.67 ± 0.2% | 27.74 ± 0.3% | 17181.48 ± 1.2% | 2263.92 ± 0.6% | 13.04 ± 0.4% | 75.32 ± 0.4% | 1607.13 ± 0.4% | 2.87 | 1.00 | 0.0937 | 0.71 |
| literal: a word, second text | 123 | 4085.22 ± 1.6% | 561.43 ± 0.0% | 28.52 ± 0.5% | 18416.21 ± 1.5% | 7618.57 ± 4.8% | 20.11 ± 0.4% | 70.10 ± 0.2% | 4097.84 ± 1.8% | 7.28 | 1.00 | 0.22 | 0.54 |
| class: two capitalized words | 1331 | 1156.25 ± 0.5% | 546.64 ± 0.3% | 26.44 ± 0.5% | 587.51 ± 0.1% | 40.92 ± 0.1% | 14.67 ± 0.1% | 67.98 ± 0.3% | 1157.68 ± 0.2% | 2.12 | 1.00 | 1.97 | 28.25 |
| class: a word that ends in ing | 3399 | 522.78 ± 0.1% | 522.90 ± 0.1% | 18.49 ± 0.3% | 550.10 ± 0.7% | 29.51 ± 2.6% | 8.12 ± 0.2% | 18.43 ± 0.2% | 522.37 ± 0.1% | 1.00 | 1.00 | 0.95 | 17.72 |
| class: a word in capitals | 2332 | 1505.98 ± 0.6% | 543.49 ± 0.1% | 28.08 ± 0.3% | 575.34 ± 0.3% | 43.74 ± 16.3% | 16.70 ± 0.4% | 83.32 ± 0.3% | 1502.00 ± 0.7% | 2.77 | 1.00 | 2.62 | 34.43 |
| class: a number | 8288 | 2203.93 ± 0.3% | 508.35 ± 0.1% | 28.44 ± 0.7% | 1810.61 ± 0.2% | 43.29 ± 16.7% | 0.53 ± 0.3% | 57.18 ± 0.3% | 2106.07 ± 0.4% | 4.34 | 1.05 | 1.22 | 50.91 |
| class: two capitalized words, second text | 5359 | 480.85 ± 0.2% | 480.32 ± 0.1% | 23.79 ± 0.2% | 487.02 ± 0.0% | 35.48 ± 6.8% | 17.04 ± 0.5% | 63.23 ± 0.1% | 480.53 ± 0.1% | 1.00 | 1.00 | 0.99 | 13.55 |
| other: a word between two words | 6104 | 483.93 ± 0.3% | 483.90 ± 0.1% | 23.80 ± 0.3% | 753.09 ± 0.1% | 106.45 ± 10.4% | 10.62 ± 0.1% | 69.27 ± 0.1% | 483.81 ± 0.5% | 1.00 | 1.00 | 0.64 | 4.55 |
| other: a number before a unit, second text | 1481 | 1429.92 ± 0.1% | 546.84 ± 0.1% | 26.50 ± 0.4% | 5776.75 ± 1.1% | 40.92 ± 17.0% | 18.05 ± 0.7% | 65.74 ± 0.3% | 1424.93 ± 0.3% | 2.61 | 1.00 | 0.25 | 34.94 |
| other: a heading's start tag | 110 | 1430.90 ± 0.9% | 559.72 ± 0.1% | 27.73 ± 0.5% | 1721.01 ± 0.2% | 1586.80 ± 8.1% | 16.12 ± 0.5% | 87.58 ± 0.7% | 1429.32 ± 0.3% | 2.56 | 1.00 | 0.83 | 0.90 |
| other: a whole word | 217 | 560.55 ± 0.3% | 561.00 ± 0.3% | 29.96 ± 0.5% | 14826.05 ± 1.2% | 49.39 ± 0.3% | 13.17 ± 0.2% | 55.22 ± 0.8% | 560.83 ± 0.6% | 1.00 | 1.00 | 0.0378 | 11.35 |
| other: a line's first word, second text | 3716 | 517.90 ± 0.1% | 518.30 ± 0.1% | 31.88 ± 0.3% | 1743.87 ± 0.5% | 62.30 ± 4.2% | refused | refused | 516.83 ± 0.3% | 1.00 | 1.00 | 0.30 | 8.31 |
| other: fourteen octets before an x | 87 | 1.53 ± 0.1% | 1.53 ± 0.2% | 1.54 ± 0.1% | 4027.15 ± 0.6% | 10.68 ± 0.2% | differs | 17.94 ± 0.1% | 1.53 ± 0.1% | 1.00 | 1.00 | 0.0004 | 0.14 |
| other: a Greek word | 21815 | 539.84 ± 1.2% | 354.68 ± 0.7% | 31.77 ± 0.2% | 295.08 ± 0.3% | 49.26 ± 11.8% | differs | refused | 538.28 ± 1.1% | 1.52 | 1.00 | 1.83 | 10.96 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 20.10 ± 0.2% | 20.09 ± 0.1% | 0.50 ± 0.2% | 21.53 ± 0.4% | 2.76 ± 11.6% | differs | 4.07 ± 0.2% | 20.10 ± 0.1% | 1.00 | 1.00 | 0.93 | 7.29 |
| a UUID | 32895 | 14.27 ± 0.3% | 14.25 ± 0.3% | 0.66 ± 0.2% | 16.07 ± 0.2% | 3.10 ± 1.0% | 0.73 ± 0.3% | 3.65 ± 0.6% | 14.24 ± 0.4% | 1.00 | 1.00 | 0.89 | 4.61 |
| an IPv4 address | 33176 | 34.86 ± 0.5% | 34.74 ± 0.5% | 2.18 ± 0.1% | 32.60 ± 0.2% | 6.70 ± 0.2% | differs | 4.22 ± 0.2% | 34.75 ± 0.0% | 1.00 | 1.00 | 1.07 | 5.21 |
| a date and time | 32954 | 23.85 ± 0.3% | 23.78 ± 0.4% | 1.51 ± 0.2% | 23.20 ± 0.3% | 7.09 ± 0.2% | 1.25 ± 0.1% | 7.17 ± 0.2% | 23.82 ± 0.3% | 1.00 | 1.00 | 1.03 | 3.36 |
| a field path | 32606 | 24.64 ± 0.3% | 24.63 ± 0.2% | 0.84 ± 1.0% | 25.29 ± 0.3% | 3.49 ± 1.6% | differs | 2.96 ± 0.1% | 24.57 ± 0.2% | 1.00 | 1.00 | 0.97 | 7.07 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 2.53 ± 0.7% | 2.48 ± 0.4% | 1.15 ± 0.2% | 11.73 ± 0.2% | 4.99 ± 1.7% | 0.94 ± 0.3% | none | 2.49 ± 0.3% | 1.02 | 1.01 | 0.22 | 0.51 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 256.22 ± 0.5% | 256.60 ± 0.4% | 334.49 ± 0.4% | 86.34 ± 1.8% | 224.89 ± 0.6% | 497.04 ± 2.5% | 3807.63 ± 2.1% | 256.48 ± 0.3% | 1.00 | 1.00 | 2.97 | 1.14 |
| a UUID | 62 | 193.16 ± 0.7% | 193.46 ± 0.3% | 240.87 ± 0.3% | 45.78 ± 0.6% | 100.27 ± 0.7% | 185.63 ± 2.2% | 4391.74 ± 1.3% | 193.44 ± 0.2% | 1.00 | 1.00 | 4.22 | 1.93 |
| an IPv4 address | 29 | 359.19 ± 0.7% | 359.90 ± 0.5% | 569.39 ± 0.5% | 76.30 ± 0.5% | 132.12 ± 9.5% | 295.14 ± 1.0% | 7647.88 ± 0.3% | 359.06 ± 0.4% | 1.00 | 1.00 | 4.71 | 2.72 |
| a date and time | 56 | 256.64 ± 0.2% | 256.86 ± 0.2% | 338.83 ± 0.2% | 71.78 ± 1.4% | 138.85 ± 1.5% | 318.39 ± 0.6% | 4955.65 ± 0.3% | 256.53 ± 0.3% | 1.00 | 1.00 | 3.58 | 1.85 |
| a field path | 39 | 277.77 ± 0.4% | 277.95 ± 0.6% | 388.48 ± 0.2% | 80.82 ± 0.1% | 207.81 ± 1.5% | 496.26 ± 0.6% | 4868.73 ± 3.7% | 277.66 ± 0.1% | 1.00 | 1.00 | 3.44 | 1.34 |
| literal: a word | 7 | 566.07 ± 0.8% | 566.52 ± 0.5% | 1396.69 ± 0.4% | 513.18 ± 1.7% | 639.81 ± 1.7% | 946.65 ± 0.3% | 30789.10 ± 0.2% | 566.39 ± 0.4% | 1.00 | 1.00 | 1.10 | 0.88 |
| literal: a word that is not there | 8 | 588.36 ± 0.3% | 588.83 ± 0.3% | 1321.16 ± 0.1% | 466.02 ± 0.3% | 612.91 ± 4.1% | 895.15 ± 0.4% | 29603.28 ± 0.3% | 588.81 ± 0.5% | 1.00 | 1.00 | 1.26 | 0.96 |
| literal: one of four words | 26 | 393.96 ± 0.2% | 395.12 ± 0.5% | 601.50 ± 0.2% | 49.43 ± 0.5% | 245.75 ± 2.8% | 360.55 ± 0.3% | 16057.38 ± 0.1% | 394.39 ± 0.2% | 1.00 | 1.00 | 7.97 | 1.60 |
| literal: a word in any case | 11 | 554.65 ± 0.5% | 556.36 ± 0.4% | 1115.15 ± 0.4% | 15.50 ± 0.2% | 664.72 ± 2.5% | refused | 23746.16 ± 0.1% | 554.53 ± 0.6% | 1.00 | 1.00 | 35.77 | 0.83 |
| literal: an href attribute | 12 | 360.14 ± 0.9% | 360.22 ± 0.8% | 520.79 ± 0.6% | 45.69 ± 0.2% | 510.15 ± 1.4% | 775.75 ± 0.6% | 22406.71 ± 0.2% | 360.03 ± 0.8% | 1.00 | 1.00 | 7.88 | 0.71 |
| literal: a word, second text | 10 | 557.76 ± 0.6% | 557.73 ± 0.4% | 1177.29 ± 0.2% | 419.86 ± 0.4% | 549.69 ± 1.8% | 805.44 ± 0.4% | 27562.70 ± 0.2% | 557.31 ± 0.1% | 1.00 | 1.00 | 1.33 | 1.01 |
| class: two capitalized words | 23 | 344.16 ± 0.6% | 344.97 ± 0.2% | 578.58 ± 0.9% | 102.18 ± 0.5% | 504.48 ± 1.4% | 749.69 ± 0.4% | 6522.19 ± 1.3% | 344.86 ± 0.3% | 1.00 | 1.00 | 3.37 | 0.68 |
| class: a word that ends in ing | 9 | 497.31 ± 0.6% | 497.34 ± 0.5% | 1102.28 ± 0.4% | 131.61 ± 0.3% | 760.35 ± 2.7% | 1111.66 ± 0.1% | 16247.13 ± 0.4% | 497.74 ± 0.1% | 1.00 | 1.00 | 3.78 | 0.65 |
| class: a word in capitals | 16 | 377.66 ± 0.4% | 377.33 ± 0.3% | 754.05 ± 0.2% | 134.22 ± 1.5% | 755.67 ± 0.7% | 1022.13 ± 0.8% | 8584.35 ± 0.1% | 377.22 ± 0.3% | 1.00 | 1.00 | 2.81 | 0.50 |
| class: a number | 6 | 479.13 ± 0.4% | 479.09 ± 0.2% | 1291.07 ± 0.2% | 41.54 ± 1.8% | 1410.91 ± 1.2% | 1847.16 ± 1.0% | 23222.10 ± 0.3% | 479.03 ± 0.3% | 1.00 | 1.00 | 11.53 | 0.34 |
| class: two capitalized words, second text | 23 | 344.06 ± 0.8% | 344.30 ± 0.3% | 578.18 ± 0.1% | 102.13 ± 0.3% | 504.63 ± 2.9% | 732.94 ± 0.9% | 6544.60 ± 0.4% | 344.48 ± 0.5% | 1.00 | 1.00 | 3.37 | 0.68 |
| other: a word between two words | 13 | 480.21 ± 0.3% | 480.10 ± 0.6% | 918.20 ± 0.1% | 134.80 ± 0.3% | 513.29 ± 0.6% | 812.73 ± 0.5% | 14929.89 ± 0.2% | 480.08 ± 0.3% | 1.00 | 1.00 | 3.56 | 0.94 |
| other: a number before a unit, second text | 15 | 430.39 ± 0.5% | 430.82 ± 0.4% | 787.82 ± 0.1% | 39.50 ± 0.8% | 644.43 ± 3.2% | 886.99 ± 0.6% | 15363.61 ± 0.5% | 430.76 ± 0.3% | 1.00 | 1.00 | 10.90 | 0.67 |
| other: a heading's start tag | 13 | 343.94 ± 0.6% | 344.13 ± 0.5% | 497.57 ± 0.7% | 44.12 ± 0.5% | 645.76 ± 1.0% | 859.52 ± 1.6% | 18524.10 ± 0.5% | 344.01 ± 0.6% | 1.00 | 1.00 | 7.80 | 0.53 |
| other: a whole word | 11 | 583.70 ± 0.5% | 584.41 ± 0.5% | 1199.81 ± 0.5% | 120.87 ± 0.1% | 569.50 ± 1.8% | 830.19 ± 0.3% | 27279.94 ± 0.1% | 584.52 ± 0.8% | 1.00 | 1.00 | 4.83 | 1.02 |
| other: a line's first word, second text | 17 | 461.20 ± 0.6% | 460.56 ± 0.4% | 871.48 ± 0.4% | 128.97 ± 0.1% | 715.64 ± 1.0% | refused | refused | 460.40 ± 0.6% | 1.00 | 1.00 | 3.58 | 0.64 |
| other: fourteen octets before an x | 16 | 145.93 ± 0.6% | 145.86 ± 0.3% | 174.61 ± 0.5% | 15.03 ± 0.2% | 459.78 ± 0.7% | 425.34 ± 0.6% | 12979.14 ± 0.5% | 146.18 ± 0.4% | 1.00 | 1.00 | 9.71 | 0.32 |
| other: a Greek word | 8 | 500.86 ± 0.3% | 501.59 ± 0.5% | 1232.51 ± 0.6% | 59.21 ± 0.3% | 1406.50 ± 1.0% | 1793.31 ± 0.6% | refused | 501.29 ± 0.3% | 1.00 | 1.00 | 8.46 | 0.36 |

