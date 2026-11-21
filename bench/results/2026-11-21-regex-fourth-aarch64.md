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
| Run URL | https://github.com/c4milo/stdx/actions/runs/44951169916 |
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
| literal: a word | 217 | 5290.00 ± 0.5% | 560.76 ± 0.1% | 27.98 ± 0.5% | 18205.98 ± 1.8% | 9083.51 ± 10.8% | 17.68 ± 0.7% | 86.54 ± 0.5% | 5296.57 ± 0.5% | 9.43 | 1.00 | 0.29 | 0.58 |
| literal: a word that is not there | 0 | 5355.64 ± 0.8% | 562.06 ± 0.2% | 28.04 ± 0.4% | 19625.00 ± 1.7% | 28190.86 ± 1.7% | 17.50 ± 0.1% | 80.92 ± 0.2% | 5370.59 ± 0.4% | 9.53 | 1.00 | 0.27 | 0.19 |
| literal: one of four words | 661 | 2484.00 ± 1.2% | 555.92 ± 0.1% | 14.92 ± 0.1% | 3978.10 ± 0.2% | 21.91 ± 0.4% | 5.42 ± 0.2% | 6.94 ± 0.5% | 2482.23 ± 0.4% | 4.47 | 1.00 | 0.62 | 113.35 |
| literal: a word in any case | 217 | 2703.13 ± 0.9% | 560.06 ± 0.1% | 21.73 ± 0.1% | 3987.96 ± 0.1% | 38.60 ± 0.3% | refused | differs | 2699.12 ± 1.4% | 4.83 | 1.00 | 0.68 | 70.02 |
| literal: an href attribute | 33 | 1606.73 ± 0.4% | 561.75 ± 0.1% | 27.16 ± 0.6% | 16716.51 ± 1.0% | 2262.43 ± 5.2% | 12.87 ± 0.9% | 75.50 ± 0.1% | 1605.81 ± 0.5% | 2.86 | 1.00 | 0.0961 | 0.71 |
| literal: a word, second text | 123 | 4131.52 ± 2.1% | 561.05 ± 0.1% | 27.89 ± 0.1% | 18594.02 ± 1.3% | 7504.95 ± 5.0% | 19.81 ± 0.5% | 70.47 ± 1.0% | 4109.30 ± 1.5% | 7.36 | 1.01 | 0.22 | 0.55 |
| class: two capitalized words | 1331 | 1156.41 ± 0.8% | 546.66 ± 0.1% | 25.97 ± 0.3% | 584.13 ± 0.1% | 40.99 ± 2.0% | 15.11 ± 0.4% | 67.97 ± 0.2% | 1155.41 ± 0.5% | 2.12 | 1.00 | 1.98 | 28.21 |
| class: a word that ends in ing | 3399 | 522.65 ± 0.1% | 523.17 ± 0.0% | 18.23 ± 0.2% | 550.18 ± 0.1% | 29.54 ± 9.2% | 8.16 ± 0.2% | 18.45 ± 0.1% | 522.32 ± 0.1% | 1.00 | 1.00 | 0.95 | 17.69 |
| class: a word in capitals | 2332 | 1500.50 ± 0.5% | 543.55 ± 0.1% | 27.45 ± 0.3% | 574.84 ± 0.1% | 43.97 ± 0.3% | 17.14 ± 0.4% | 83.45 ± 0.3% | 1501.83 ± 0.3% | 2.76 | 1.00 | 2.61 | 34.12 |
| class: a number | 8288 | 2193.09 ± 0.4% | 508.37 ± 0.1% | 27.69 ± 0.3% | 1802.44 ± 0.1% | 39.35 ± 14.1% | 0.57 ± 0.5% | 57.12 ± 0.2% | 2190.07 ± 0.2% | 4.31 | 1.00 | 1.22 | 55.74 |
| class: two capitalized words, second text | 5359 | 480.08 ± 0.3% | 479.84 ± 0.1% | 23.38 ± 0.2% | 491.66 ± 0.1% | 32.83 ± 7.9% | 16.86 ± 0.1% | 63.22 ± 0.1% | 480.10 ± 0.1% | 1.00 | 1.00 | 0.98 | 14.62 |
| other: a word between two words | 6104 | 483.43 ± 0.2% | 483.43 ± 0.2% | 23.54 ± 0.3% | 756.79 ± 0.2% | 107.45 ± 17.7% | 11.46 ± 0.2% | 69.42 ± 0.4% | 483.44 ± 0.2% | 1.00 | 1.00 | 0.64 | 4.50 |
| other: a number before a unit, second text | 1481 | 1429.06 ± 0.4% | 546.37 ± 0.1% | 26.01 ± 0.2% | 5940.90 ± 0.5% | 40.94 ± 4.6% | 17.69 ± 0.8% | 65.78 ± 0.5% | 1424.11 ± 0.3% | 2.62 | 1.00 | 0.24 | 34.90 |
| other: a heading's start tag | 110 | 1431.70 ± 0.8% | 559.24 ± 0.3% | 27.10 ± 0.1% | 1715.11 ± 0.6% | 1584.74 ± 5.3% | 16.44 ± 0.3% | 87.69 ± 0.6% | 1431.54 ± 0.4% | 2.56 | 1.00 | 0.83 | 0.90 |
| other: a whole word | 217 | 560.98 ± 0.1% | 560.90 ± 0.1% | 29.11 ± 0.4% | 14740.04 ± 4.5% | 49.39 ± 0.4% | 13.76 ± 0.1% | 55.08 ± 0.8% | 561.17 ± 0.1% | 1.00 | 1.00 | 0.0381 | 11.36 |
| other: a line's first word, second text | 3716 | 517.74 ± 0.2% | 516.76 ± 0.1% | 30.50 ± 0.5% | 1782.01 ± 0.5% | 62.01 ± 7.2% | refused | refused | 516.64 ± 0.3% | 1.00 | 1.00 | 0.29 | 8.35 |
| other: fourteen octets before an x | 87 | 1.53 ± 0.1% | 1.53 ± 0.2% | 1.53 ± 0.1% | 4030.78 ± 0.3% | 10.69 ± 0.4% | differs | 17.91 ± 0.2% | 1.53 ± 0.3% | 1.00 | 1.00 | 0.0004 | 0.14 |
| other: a Greek word | 21815 | 539.21 ± 0.7% | 354.08 ± 0.6% | 31.38 ± 0.1% | 294.28 ± 0.2% | 44.35 ± 9.8% | differs | refused | 536.63 ± 0.3% | 1.52 | 1.00 | 1.83 | 12.16 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 20.05 ± 0.1% | 20.06 ± 0.1% | 0.50 ± 0.5% | 21.42 ± 0.3% | 2.77 ± 0.5% | differs | 4.06 ± 0.1% | 20.06 ± 0.1% | 1.00 | 1.00 | 0.94 | 7.23 |
| a UUID | 32895 | 14.22 ± 0.2% | 14.22 ± 0.2% | 0.66 ± 0.3% | 16.10 ± 0.4% | 3.09 ± 0.2% | 0.72 ± 0.3% | 3.63 ± 0.2% | 14.21 ± 0.2% | 1.00 | 1.00 | 0.88 | 4.60 |
| an IPv4 address | 33176 | 34.76 ± 0.3% | 34.82 ± 0.2% | 2.16 ± 0.2% | 32.55 ± 0.2% | 6.70 ± 0.7% | differs | 4.21 ± 0.1% | 34.74 ± 0.3% | 1.00 | 1.00 | 1.07 | 5.19 |
| a date and time | 32954 | 23.86 ± 0.4% | 23.80 ± 0.4% | 1.50 ± 0.2% | 23.32 ± 0.3% | 7.03 ± 0.1% | 1.19 ± 0.4% | 7.07 ± 0.2% | 23.74 ± 0.8% | 1.00 | 1.01 | 1.02 | 3.39 |
| a field path | 32606 | 24.60 ± 0.1% | 24.60 ± 0.1% | 0.83 ± 0.6% | 25.21 ± 0.4% | 3.46 ± 1.2% | differs | 2.96 ± 0.1% | 24.59 ± 0.2% | 1.00 | 1.00 | 0.98 | 7.11 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 2.53 ± 0.2% | 2.48 ± 0.3% | 1.14 ± 0.2% | 10.91 ± 0.2% | 4.94 ± 1.0% | 0.91 ± 0.2% | none | 2.49 ± 0.2% | 1.02 | 1.01 | 0.23 | 0.51 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 236.42 ± 0.5% | 236.82 ± 0.3% | 345.52 ± 0.2% | 87.36 ± 1.0% | 219.27 ± 1.7% | 474.06 ± 2.1% | 3784.87 ± 1.6% | 236.44 ± 0.4% | 1.00 | 1.00 | 2.71 | 1.08 |
| a UUID | 62 | 179.77 ± 0.3% | 179.83 ± 0.2% | 247.46 ± 0.2% | 45.72 ± 0.5% | 97.69 ± 0.9% | 182.08 ± 2.1% | 4357.55 ± 1.3% | 179.73 ± 0.2% | 1.00 | 1.00 | 3.93 | 1.84 |
| an IPv4 address | 29 | 302.54 ± 0.3% | 302.44 ± 0.4% | 588.43 ± 0.2% | 76.58 ± 0.3% | 128.67 ± 0.4% | 289.33 ± 1.3% | 7595.39 ± 0.3% | 301.95 ± 0.4% | 1.00 | 1.00 | 3.95 | 2.35 |
| a date and time | 56 | 238.97 ± 0.2% | 239.05 ± 0.2% | 347.17 ± 0.2% | 71.67 ± 0.4% | 134.42 ± 1.9% | 314.16 ± 0.6% | 4933.94 ± 0.6% | 238.89 ± 0.3% | 1.00 | 1.00 | 3.33 | 1.78 |
| a field path | 39 | 261.31 ± 0.1% | 261.38 ± 0.3% | 402.04 ± 0.3% | 77.82 ± 1.0% | 203.81 ± 1.1% | 492.44 ± 4.5% | 4864.20 ± 0.6% | 261.52 ± 0.1% | 1.00 | 1.00 | 3.36 | 1.28 |
| literal: a word | 7 | 478.92 ± 0.2% | 479.56 ± 0.3% | 1393.01 ± 0.3% | 490.52 ± 0.2% | 620.09 ± 3.3% | 921.38 ± 0.6% | 29548.24 ± 0.0% | 479.22 ± 0.2% | 1.00 | 1.00 | 0.98 | 0.77 |
| literal: a word that is not there | 8 | 502.98 ± 0.3% | 503.48 ± 0.3% | 1313.69 ± 0.3% | 443.76 ± 0.2% | 594.60 ± 2.6% | 875.04 ± 0.7% | 28480.18 ± 0.2% | 502.23 ± 0.8% | 1.00 | 1.00 | 1.13 | 0.85 |
| literal: one of four words | 26 | 349.02 ± 0.2% | 348.89 ± 0.4% | 596.16 ± 0.5% | 49.48 ± 1.1% | 237.37 ± 2.5% | 354.75 ± 1.3% | 15632.54 ± 0.1% | 349.17 ± 0.3% | 1.00 | 1.00 | 7.05 | 1.47 |
| literal: a word in any case | 11 | 449.86 ± 0.2% | 451.43 ± 0.3% | 1133.39 ± 0.4% | 15.75 ± 0.9% | 645.58 ± 3.2% | refused | 23353.94 ± 0.2% | 450.55 ± 0.2% | 1.00 | 1.00 | 28.57 | 0.70 |
| literal: an href attribute | 12 | 333.54 ± 0.5% | 334.30 ± 0.6% | 530.16 ± 0.6% | 45.42 ± 0.5% | 493.07 ± 1.2% | 766.94 ± 0.6% | 21295.65 ± 0.1% | 333.12 ± 0.2% | 1.00 | 1.00 | 7.34 | 0.68 |
| literal: a word, second text | 10 | 463.19 ± 0.2% | 463.43 ± 0.1% | 1173.59 ± 0.3% | 416.88 ± 0.3% | 535.33 ± 2.0% | 793.77 ± 0.3% | 26471.34 ± 0.2% | 462.55 ± 0.2% | 1.00 | 1.00 | 1.11 | 0.87 |
| class: two capitalized words | 23 | 293.33 ± 0.7% | 293.75 ± 0.6% | 598.00 ± 0.3% | 100.04 ± 0.1% | 496.69 ± 1.5% | 751.56 ± 1.3% | 6468.26 ± 0.2% | 293.26 ± 0.3% | 1.00 | 1.00 | 2.93 | 0.59 |
| class: a word that ends in ing | 9 | 399.56 ± 0.5% | 398.87 ± 0.5% | 1152.68 ± 0.3% | 133.08 ± 0.3% | 748.46 ± 1.0% | 1120.90 ± 1.0% | 15927.20 ± 0.1% | 399.46 ± 0.4% | 1.00 | 1.00 | 3.00 | 0.53 |
| class: a word in capitals | 16 | 318.92 ± 0.7% | 318.11 ± 0.4% | 781.65 ± 0.2% | 135.93 ± 0.4% | 738.46 ± 2.1% | 1028.62 ± 1.6% | 8527.38 ± 0.6% | 319.14 ± 0.4% | 1.00 | 1.00 | 2.35 | 0.43 |
| class: a number | 6 | 365.38 ± 0.2% | 365.35 ± 0.1% | 1348.40 ± 0.1% | 41.77 ± 0.9% | 1392.17 ± 0.8% | 1852.32 ± 1.4% | 22474.83 ± 0.1% | 365.57 ± 0.2% | 1.00 | 1.00 | 8.75 | 0.26 |
| class: two capitalized words, second text | 23 | 291.96 ± 0.3% | 292.42 ± 0.4% | 599.06 ± 0.4% | 99.93 ± 1.5% | 492.43 ± 2.5% | 738.54 ± 1.8% | 6442.30 ± 0.4% | 292.03 ± 0.3% | 1.00 | 1.00 | 2.92 | 0.59 |
| other: a word between two words | 13 | 413.09 ± 0.5% | 413.69 ± 0.4% | 944.18 ± 0.1% | 133.26 ± 0.4% | 495.15 ± 2.8% | 789.61 ± 0.7% | 14691.59 ± 0.1% | 412.82 ± 0.3% | 1.00 | 1.00 | 3.10 | 0.83 |
| other: a number before a unit, second text | 15 | 345.18 ± 0.5% | 344.89 ± 0.4% | 814.08 ± 0.2% | 39.53 ± 0.6% | 621.34 ± 1.4% | 882.94 ± 0.1% | 15008.85 ± 0.2% | 344.83 ± 0.4% | 1.00 | 1.00 | 8.73 | 0.56 |
| other: a heading's start tag | 13 | 321.49 ± 0.7% | 321.31 ± 0.7% | 511.12 ± 1.0% | 44.21 ± 0.3% | 626.87 ± 1.4% | 861.94 ± 0.1% | 17838.24 ± 0.3% | 321.69 ± 0.8% | 1.00 | 1.00 | 7.27 | 0.51 |
| other: a whole word | 11 | 506.01 ± 0.3% | 506.05 ± 0.3% | 1193.72 ± 0.3% | 120.67 ± 0.6% | 551.30 ± 1.0% | 812.00 ± 1.3% | 26772.55 ± 0.6% | 505.42 ± 0.3% | 1.00 | 1.00 | 4.19 | 0.92 |
| other: a line's first word, second text | 17 | 409.66 ± 0.4% | 409.96 ± 0.4% | 901.12 ± 0.4% | 128.29 ± 0.3% | 701.36 ± 1.2% | refused | refused | 408.81 ± 0.5% | 1.00 | 1.00 | 3.19 | 0.58 |
| other: fourteen octets before an x | 16 | 136.82 ± 0.9% | 136.98 ± 0.5% | 176.02 ± 0.3% | 15.01 ± 0.4% | 441.88 ± 2.1% | 419.22 ± 0.5% | 12662.23 ± 0.8% | 136.81 ± 0.8% | 1.00 | 1.00 | 9.12 | 0.31 |
| other: a Greek word | 8 | 425.77 ± 0.2% | 426.41 ± 0.2% | 1270.87 ± 0.1% | 59.34 ± 0.3% | 1361.81 ± 1.2% | 1762.85 ± 0.3% | refused | 425.57 ± 0.1% | 1.00 | 1.00 | 7.17 | 0.31 |

