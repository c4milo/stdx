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
| Run URL | https://github.com/c4milo/stdx/actions/runs/44951166966 |
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
| literal: a word | 217 | 5287.97 ± 0.7% | 560.91 ± 0.5% | 27.98 ± 0.4% | 18178.32 ± 4.1% | 9186.19 ± 7.1% | 17.68 ± 0.2% | 86.68 ± 0.5% | 5299.29 ± 0.4% | 9.43 | 1.00 | 0.29 | 0.58 |
| literal: a word that is not there | 0 | 5365.65 ± 1.0% | 562.08 ± 0.3% | 28.12 ± 0.1% | 19929.01 ± 2.5% | 28210.59 ± 5.7% | 17.44 ± 0.9% | 81.03 ± 0.2% | 5375.33 ± 0.3% | 9.55 | 1.00 | 0.27 | 0.19 |
| literal: one of four words | 661 | 2462.74 ± 1.0% | 556.14 ± 0.0% | 14.92 ± 0.5% | 3979.57 ± 0.2% | 21.30 ± 0.2% | 5.41 ± 0.2% | 6.94 ± 0.4% | 2464.33 ± 2.1% | 4.43 | 1.00 | 0.62 | 115.60 |
| literal: a word in any case | 217 | 2716.42 ± 0.6% | 560.61 ± 0.4% | 21.71 ± 0.2% | 3989.98 ± 0.2% | 38.63 ± 0.4% | refused | differs | 2700.81 ± 0.8% | 4.85 | 1.01 | 0.68 | 70.33 |
| literal: an href attribute | 33 | 1605.75 ± 1.1% | 561.12 ± 0.3% | 27.16 ± 0.3% | 17011.16 ± 3.3% | 2264.23 ± 0.6% | 13.39 ± 0.2% | 75.56 ± 0.4% | 1608.07 ± 0.4% | 2.86 | 1.00 | 0.0944 | 0.71 |
| literal: a word, second text | 123 | 4096.20 ± 1.9% | 561.67 ± 0.1% | 27.91 ± 0.3% | 18745.69 ± 2.6% | 7696.54 ± 6.0% | 19.85 ± 0.4% | 70.63 ± 0.3% | 4068.90 ± 2.0% | 7.29 | 1.01 | 0.22 | 0.53 |
| class: two capitalized words | 1331 | 1155.86 ± 0.6% | 546.84 ± 0.2% | 26.01 ± 0.2% | 587.67 ± 0.1% | 40.93 ± 8.5% | 14.99 ± 0.4% | 67.87 ± 0.3% | 1157.12 ± 0.5% | 2.11 | 1.00 | 1.97 | 28.24 |
| class: a word that ends in ing | 3399 | 522.25 ± 0.1% | 523.02 ± 0.1% | 18.20 ± 0.3% | 550.33 ± 0.1% | 29.49 ± 5.6% | 8.22 ± 0.2% | 18.45 ± 0.1% | 521.94 ± 0.1% | 1.00 | 1.00 | 0.95 | 17.71 |
| class: a word in capitals | 2332 | 1501.18 ± 0.7% | 543.53 ± 0.1% | 27.50 ± 0.4% | 575.25 ± 0.1% | 43.73 ± 3.1% | 16.85 ± 0.5% | 83.36 ± 0.2% | 1501.29 ± 0.2% | 2.76 | 1.00 | 2.61 | 34.33 |
| class: a number | 8288 | 2193.50 ± 0.4% | 508.49 ± 0.1% | 27.69 ± 0.3% | 1806.83 ± 0.2% | 43.30 ± 15.6% | 0.57 ± 0.4% | 57.11 ± 0.5% | 2191.78 ± 0.4% | 4.31 | 1.00 | 1.21 | 50.66 |
| class: two capitalized words, second text | 5359 | 480.18 ± 0.2% | 480.00 ± 0.1% | 23.40 ± 0.2% | 488.51 ± 0.1% | 32.82 ± 14.4% | 16.65 ± 0.5% | 63.28 ± 0.1% | 480.10 ± 0.1% | 1.00 | 1.00 | 0.98 | 14.63 |
| other: a word between two words | 6104 | 484.06 ± 0.3% | 483.82 ± 0.2% | 23.54 ± 0.1% | 754.62 ± 0.1% | 108.73 ± 17.1% | 10.95 ± 0.4% | 69.49 ± 0.2% | 483.61 ± 0.1% | 1.00 | 1.00 | 0.64 | 4.45 |
| other: a number before a unit, second text | 1481 | 1429.59 ± 0.4% | 546.75 ± 0.1% | 26.01 ± 0.2% | 5949.13 ± 0.2% | 41.08 ± 0.1% | 17.65 ± 0.4% | 65.68 ± 0.3% | 1425.79 ± 0.2% | 2.61 | 1.00 | 0.24 | 34.80 |
| other: a heading's start tag | 110 | 1432.11 ± 0.4% | 559.66 ± 0.1% | 27.11 ± 0.3% | 1718.39 ± 0.1% | 1584.16 ± 3.7% | 16.39 ± 0.7% | 87.97 ± 0.6% | 1432.24 ± 0.5% | 2.56 | 1.00 | 0.83 | 0.90 |
| other: a whole word | 217 | 560.83 ± 0.3% | 561.00 ± 0.3% | 29.14 ± 0.4% | 14719.83 ± 1.6% | 49.36 ± 0.1% | 13.75 ± 0.1% | 54.97 ± 1.0% | 561.14 ± 0.2% | 1.00 | 1.00 | 0.0381 | 11.36 |
| other: a line's first word, second text | 3716 | 518.14 ± 0.2% | 518.62 ± 0.1% | 30.64 ± 0.3% | 1776.56 ± 0.8% | 62.15 ± 7.3% | refused | refused | 517.05 ± 0.3% | 1.00 | 1.00 | 0.29 | 8.34 |
| other: fourteen octets before an x | 87 | 1.54 ± 0.2% | 1.54 ± 0.1% | 1.54 ± 0.2% | 3957.81 ± 0.4% | 10.68 ± 0.2% | differs | 17.90 ± 0.1% | 1.54 ± 0.1% | 1.00 | 1.00 | 0.0004 | 0.14 |
| other: a Greek word | 21815 | 538.44 ± 0.7% | 354.91 ± 0.4% | 31.40 ± 0.2% | 294.90 ± 0.4% | 49.92 ± 10.5% | differs | refused | 535.42 ± 0.4% | 1.52 | 1.01 | 1.83 | 10.79 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 20.07 ± 0.2% | 20.11 ± 0.2% | 0.50 ± 0.1% | 21.56 ± 0.3% | 2.72 ± 1.0% | differs | 4.06 ± 0.3% | 20.09 ± 0.1% | 1.00 | 1.00 | 0.93 | 7.37 |
| a UUID | 32895 | 14.24 ± 0.5% | 14.25 ± 0.4% | 0.66 ± 0.1% | 16.11 ± 0.2% | 3.10 ± 0.8% | 0.72 ± 0.1% | 3.64 ± 0.6% | 14.22 ± 0.2% | 1.00 | 1.00 | 0.88 | 4.59 |
| an IPv4 address | 33176 | 34.82 ± 0.3% | 34.83 ± 0.3% | 2.16 ± 0.3% | 32.71 ± 0.2% | 6.69 ± 0.1% | differs | 4.19 ± 0.1% | 34.78 ± 0.5% | 1.00 | 1.00 | 1.06 | 5.20 |
| a date and time | 32954 | 23.81 ± 0.2% | 23.82 ± 0.5% | 1.50 ± 0.2% | 23.26 ± 0.1% | 7.07 ± 0.1% | 1.20 ± 0.3% | 7.07 ± 0.4% | 23.68 ± 0.4% | 1.00 | 1.01 | 1.02 | 3.37 |
| a field path | 32606 | 24.63 ± 0.2% | 24.61 ± 0.0% | 0.83 ± 0.8% | 25.31 ± 0.4% | 3.51 ± 0.3% | differs | 2.96 ± 0.1% | 24.60 ± 0.2% | 1.00 | 1.00 | 0.97 | 7.02 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 2.53 ± 0.6% | 2.47 ± 0.7% | 1.14 ± 0.2% | 10.96 ± 0.2% | 4.97 ± 2.4% | 0.90 ± 0.3% | none | 2.49 ± 0.5% | 1.02 | 1.01 | 0.23 | 0.51 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 236.81 ± 0.3% | 237.06 ± 0.4% | 345.49 ± 0.3% | 86.23 ± 1.6% | 222.73 ± 0.9% | 490.55 ± 2.7% | 3807.59 ± 0.9% | 236.30 ± 0.5% | 1.00 | 1.00 | 2.75 | 1.06 |
| a UUID | 62 | 179.94 ± 0.3% | 179.99 ± 0.4% | 248.31 ± 0.2% | 45.50 ± 0.8% | 99.94 ± 0.8% | 181.26 ± 2.5% | 4384.30 ± 1.4% | 180.00 ± 0.1% | 1.00 | 1.00 | 3.95 | 1.80 |
| an IPv4 address | 29 | 303.23 ± 0.3% | 303.42 ± 0.2% | 591.39 ± 0.3% | 75.85 ± 0.5% | 131.43 ± 1.2% | 290.16 ± 0.8% | 7586.48 ± 0.1% | 303.15 ± 0.1% | 1.00 | 1.00 | 4.00 | 2.31 |
| a date and time | 56 | 239.54 ± 0.2% | 239.98 ± 0.4% | 348.82 ± 0.2% | 71.23 ± 0.8% | 137.11 ± 28.4% | 316.15 ± 3.0% | 4928.92 ± 0.4% | 239.43 ± 0.5% | 1.00 | 1.00 | 3.36 | 1.75 |
| a field path | 39 | 261.54 ± 0.4% | 261.85 ± 0.5% | 402.79 ± 0.4% | 80.16 ± 0.3% | 205.74 ± 5.2% | 492.55 ± 0.8% | 4831.23 ± 3.3% | 261.69 ± 0.4% | 1.00 | 1.00 | 3.26 | 1.27 |
| literal: a word | 7 | 477.98 ± 0.6% | 479.03 ± 0.3% | 1392.24 ± 0.7% | 502.95 ± 2.0% | 630.80 ± 1.4% | 940.14 ± 0.5% | 29662.51 ± 0.1% | 477.81 ± 0.4% | 1.00 | 1.00 | 0.95 | 0.76 |
| literal: a word that is not there | 8 | 502.77 ± 0.3% | 503.31 ± 0.2% | 1313.68 ± 0.5% | 457.36 ± 0.4% | 606.87 ± 2.2% | 887.14 ± 0.5% | 28627.64 ± 0.2% | 502.23 ± 0.2% | 1.00 | 1.00 | 1.10 | 0.83 |
| literal: one of four words | 26 | 347.90 ± 0.6% | 347.50 ± 0.5% | 595.14 ± 0.9% | 49.00 ± 0.6% | 242.75 ± 2.0% | 359.47 ± 0.3% | 15683.82 ± 0.3% | 347.39 ± 0.5% | 1.00 | 1.00 | 7.10 | 1.43 |
| literal: a word in any case | 11 | 450.22 ± 0.4% | 451.34 ± 0.2% | 1133.46 ± 0.2% | 15.42 ± 0.3% | 655.06 ± 2.4% | refused | 23427.42 ± 0.2% | 450.43 ± 0.3% | 1.00 | 1.00 | 29.19 | 0.69 |
| literal: an href attribute | 12 | 332.94 ± 0.5% | 334.50 ± 0.5% | 531.60 ± 0.8% | 12.59 ± 29.0% | 500.68 ± 1.3% | 762.72 ± 0.5% | 21430.99 ± 0.2% | 333.38 ± 0.5% | 1.00 | 1.00 | 26.44 | 0.66 |
| literal: a word, second text | 10 | 463.12 ± 0.2% | 463.08 ± 0.4% | 1172.54 ± 0.5% | 408.74 ± 0.4% | 538.55 ± 1.2% | 787.70 ± 0.4% | 26660.56 ± 0.1% | 462.70 ± 0.2% | 1.00 | 1.00 | 1.13 | 0.86 |
| class: two capitalized words | 23 | 293.50 ± 0.5% | 293.68 ± 0.4% | 600.35 ± 0.7% | 100.82 ± 0.3% | 502.53 ± 0.8% | 734.81 ± 1.4% | 6440.03 ± 0.5% | 293.43 ± 1.1% | 1.00 | 1.00 | 2.91 | 0.58 |
| class: a word that ends in ing | 9 | 401.65 ± 0.4% | 401.71 ± 0.4% | 1160.73 ± 0.3% | 130.98 ± 1.4% | 756.50 ± 1.0% | 1087.52 ± 0.7% | 15954.92 ± 0.3% | 399.03 ± 0.9% | 1.00 | 1.01 | 3.07 | 0.53 |
| class: a word in capitals | 16 | 318.96 ± 0.3% | 318.76 ± 0.6% | 786.20 ± 0.2% | 133.29 ± 1.0% | 749.60 ± 1.0% | 1015.33 ± 2.9% | 8535.89 ± 0.8% | 318.74 ± 0.9% | 1.00 | 1.00 | 2.39 | 0.43 |
| class: a number | 6 | 366.05 ± 0.2% | 366.29 ± 0.1% | 1356.12 ± 0.2% | 41.36 ± 1.1% | 1395.61 ± 1.9% | 1853.71 ± 1.3% | 22576.15 ± 0.2% | 366.16 ± 0.1% | 1.00 | 1.00 | 8.85 | 0.26 |
| class: two capitalized words, second text | 23 | 294.16 ± 0.5% | 293.81 ± 1.3% | 600.22 ± 0.4% | 101.35 ± 0.2% | 502.73 ± 1.1% | 767.51 ± 5.4% | 6469.88 ± 0.6% | 293.90 ± 1.0% | 1.00 | 1.00 | 2.90 | 0.59 |
| other: a word between two words | 13 | 416.07 ± 0.4% | 417.25 ± 0.8% | 947.58 ± 0.3% | 132.65 ± 1.6% | 506.76 ± 0.7% | 799.81 ± 2.1% | 14740.28 ± 0.2% | 414.30 ± 1.2% | 1.00 | 1.00 | 3.14 | 0.82 |
| other: a number before a unit, second text | 15 | 345.19 ± 0.2% | 346.36 ± 0.2% | 817.40 ± 0.2% | 39.34 ± 0.4% | 637.21 ± 0.5% | 891.25 ± 1.2% | 15098.79 ± 0.1% | 344.72 ± 0.4% | 1.00 | 1.00 | 8.77 | 0.54 |
| other: a heading's start tag | 13 | 322.03 ± 0.4% | 321.77 ± 0.4% | 512.67 ± 0.3% | 10.68 ± 29.8% | 633.18 ± 0.9% | 870.70 ± 1.1% | 17879.88 ± 0.5% | 322.14 ± 0.2% | 1.00 | 1.00 | 30.15 | 0.51 |
| other: a whole word | 11 | 505.81 ± 0.4% | 506.01 ± 0.4% | 1190.57 ± 0.3% | 119.64 ± 0.3% | 565.20 ± 2.1% | 821.40 ± 0.6% | 26827.36 ± 0.2% | 504.62 ± 0.3% | 1.00 | 1.00 | 4.23 | 0.89 |
| other: a line's first word, second text | 17 | 410.80 ± 0.6% | 410.73 ± 0.5% | 903.82 ± 1.0% | 127.65 ± 0.2% | 708.50 ± 1.2% | refused | refused | 409.79 ± 0.5% | 1.00 | 1.00 | 3.22 | 0.58 |
| other: fourteen octets before an x | 16 | 137.66 ± 0.2% | 137.68 ± 0.3% | 176.72 ± 0.5% | 7.05 ± 18.7% | 453.35 ± 1.8% | 413.46 ± 0.4% | 12694.64 ± 1.0% | 137.55 ± 0.5% | 1.00 | 1.00 | 19.53 | 0.30 |
| other: a Greek word | 8 | 425.85 ± 0.2% | 426.08 ± 0.2% | 1270.79 ± 0.5% | 11.97 ± 26.4% | 1385.81 ± 1.9% | 1830.88 ± 0.2% | refused | 425.66 ± 0.2% | 1.00 | 1.00 | 35.58 | 0.31 |

