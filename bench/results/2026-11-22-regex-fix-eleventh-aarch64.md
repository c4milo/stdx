# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45065553285 |
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
| literal: a word | 217 | 15461.53 ± 1.0% | 1048.14 ± 0.2% | 28.77 ± 0.4% | 18140.20 ± 3.2% | 9172.72 ± 8.6% | 17.41 ± 0.4% | 87.02 ± 0.2% | 15452.29 ± 1.9% | 14.75 | 1.00 | 0.85 | 1.69 |
| literal: a word that is not there | 0 | 17895.37 ± 3.5% | 1055.72 ± 0.2% | 28.68 ± 0.3% | 19457.15 ± 3.4% | 28526.52 ± 3.2% | 17.20 ± 0.3% | 81.31 ± 0.6% | 18113.56 ± 4.3% | 16.95 | 0.99 | 0.92 | 0.63 |
| literal: one of four words | 661 | 5816.72 ± 0.2% | 1026.29 ± 0.6% | 15.00 ± 0.3% | 3978.57 ± 0.5% | 21.85 ± 0.2% | 5.25 ± 0.0% | 6.95 ± 0.4% | 5807.52 ± 0.5% | 5.67 | 1.00 | 1.46 | 266.18 |
| literal: a word in any case | 217 | 11654.55 ± 0.8% | 1046.06 ± 0.3% | 22.09 ± 0.6% | 3985.99 ± 0.4% | 38.67 ± 0.4% | refused | differs | 11651.61 ± 0.5% | 11.14 | 1.00 | 2.92 | 301.41 |
| literal: an href attribute | 33 | 16089.74 ± 1.0% | 1053.02 ± 0.1% | 27.72 ± 0.3% | 16948.88 ± 0.9% | 2264.76 ± 0.3% | 13.22 ± 0.3% | 76.15 ± 0.7% | 16107.41 ± 0.6% | 15.28 | 1.00 | 0.95 | 7.10 |
| literal: a word, second text | 123 | 15702.12 ± 1.6% | 1050.94 ± 0.1% | 28.29 ± 0.2% | 18658.77 ± 2.9% | 7729.21 ± 6.0% | 19.64 ± 0.5% | 71.29 ± 0.3% | 15816.27 ± 1.2% | 14.94 | 0.99 | 0.84 | 2.03 |
| class: two capitalized words | 1331 | 1107.17 ± 0.4% | 964.06 ± 0.1% | 26.48 ± 0.1% | 587.73 ± 0.0% | 40.96 ± 10.6% | 14.77 ± 0.2% | 67.99 ± 0.3% | 1105.85 ± 0.5% | 1.15 | 1.00 | 1.88 | 27.03 |
| class: a word that ends in ing | 3399 | 888.25 ± 0.1% | 890.00 ± 0.2% | 18.58 ± 0.3% | 550.30 ± 0.0% | 29.60 ± 11.3% | 8.17 ± 0.1% | 18.33 ± 0.2% | 887.62 ± 0.1% | 1.00 | 1.00 | 1.61 | 30.01 |
| class: a word in capitals | 2332 | 1463.25 ± 0.6% | 960.88 ± 0.2% | 27.93 ± 0.3% | 575.34 ± 0.0% | 43.82 ± 6.6% | 17.14 ± 0.3% | 83.32 ± 0.5% | 1461.54 ± 0.6% | 1.52 | 1.00 | 2.54 | 33.39 |
| class: a number | 8288 | 2115.10 ± 0.6% | 812.89 ± 0.2% | 28.12 ± 0.2% | 1798.28 ± 0.3% | 40.35 ± 16.4% | 0.55 ± 0.1% | 57.28 ± 0.1% | 2114.61 ± 0.2% | 2.60 | 1.00 | 1.18 | 52.42 |
| class: two capitalized words, second text | 5359 | 702.39 ± 0.2% | 702.72 ± 0.1% | 23.78 ± 0.2% | 489.08 ± 0.1% | 34.36 ± 10.4% | 16.67 ± 0.2% | 63.27 ± 0.3% | 702.07 ± 0.2% | 1.00 | 1.00 | 1.44 | 20.44 |
| other: a word between two words | 6104 | 748.78 ± 0.2% | 744.66 ± 0.1% | 23.98 ± 0.3% | 751.10 ± 0.6% | 108.90 ± 12.9% | 11.26 ± 0.2% | 69.80 ± 0.3% | 748.37 ± 0.2% | 1.01 | 1.00 | 1.00 | 6.88 |
| other: a number before a unit, second text | 1481 | 5308.11 ± 0.9% | 985.37 ± 0.2% | 26.37 ± 0.2% | 5943.13 ± 0.7% | 41.01 ± 11.2% | 17.83 ± 0.3% | 65.82 ± 0.3% | 5315.21 ± 0.5% | 5.39 | 1.00 | 0.89 | 129.42 |
| other: a heading's start tag | 110 | 12407.27 ± 0.4% | 1040.87 ± 0.2% | 27.53 ± 0.3% | 1720.71 ± 0.2% | 1587.86 ± 6.9% | 16.06 ± 0.3% | 88.04 ± 0.3% | 12437.54 ± 0.5% | 11.92 | 1.00 | 7.21 | 7.81 |
| other: a whole word | 217 | 13602.61 ± 0.5% | 1046.55 ± 0.1% | 29.80 ± 0.8% | 14713.96 ± 0.9% | 49.35 ± 0.2% | 13.46 ± 0.2% | 55.56 ± 1.0% | 13595.28 ± 0.6% | 13.00 | 1.00 | 0.92 | 275.63 |
| other: a line's first word, second text | 3716 | 1922.87 ± 0.6% | 869.63 ± 0.2% | 31.50 ± 0.4% | 1758.10 ± 0.3% | 62.23 ± 7.1% | refused | refused | 1916.76 ± 0.8% | 2.21 | 1.00 | 1.09 | 30.90 |
| other: fourteen octets before an x | 87 | 18831.42 ± 0.7% | 1.54 ± 0.5% | 1.54 ± 0.4% | 4019.36 ± 0.7% | 10.68 ± 0.2% | differs | 17.89 ± 0.3% | 18868.40 ± 1.0% | 12260.19 | 1.00 | 4.69 | 1763.52 |
| other: a Greek word | 21815 | 479.54 ± 0.2% | 323.28 ± 0.5% | 31.50 ± 0.2% | 294.64 ± 0.2% | 44.47 ± 10.1% | differs | refused | 477.27 ± 0.7% | 1.48 | 1.00 | 1.63 | 10.78 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.10 ± 0.5% | 28.09 ± 0.2% | 0.50 ± 0.3% | 21.42 ± 0.4% | 2.77 ± 0.8% | differs | 4.02 ± 0.2% | 28.10 ± 0.3% | 1.00 | 1.00 | 1.31 | 10.14 |
| a UUID | 32895 | 23.19 ± 0.3% | 23.14 ± 0.3% | 0.67 ± 0.1% | 16.04 ± 0.2% | 3.09 ± 0.4% | 0.72 ± 0.3% | 3.62 ± 0.7% | 23.21 ± 0.2% | 1.00 | 1.00 | 1.45 | 7.50 |
| an IPv4 address | 33176 | 41.50 ± 0.2% | 41.48 ± 0.2% | 2.18 ± 0.3% | 32.65 ± 0.7% | 6.70 ± 0.3% | differs | 4.09 ± 0.3% | 41.52 ± 0.2% | 1.00 | 1.00 | 1.27 | 6.19 |
| a date and time | 32954 | 34.91 ± 0.3% | 34.98 ± 0.2% | 1.52 ± 0.2% | 23.45 ± 0.1% | 7.07 ± 0.1% | 1.18 ± 0.2% | 7.06 ± 0.2% | 34.92 ± 0.2% | 1.00 | 1.00 | 1.49 | 4.94 |
| a field path | 32606 | 32.25 ± 0.2% | 32.27 ± 0.2% | 0.83 ± 0.1% | 25.28 ± 0.2% | 3.55 ± 1.7% | differs | 2.91 ± 0.4% | 32.21 ± 0.2% | 1.00 | 1.00 | 1.28 | 9.09 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.25 ± 0.1% | 10.25 ± 0.2% | 10.25 ± 0.1% | 11.07 ± 0.2% | 4.93 ± 1.0% | 0.91 ± 0.4% | none | 10.25 ± 0.1% | 1.00 | 1.00 | 0.93 | 2.08 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 270.24 ± 0.3% | 271.37 ± 0.3% | 315.81 ± 0.2% | 85.90 ± 0.6% | 216.80 ± 12.8% | 484.50 ± 0.5% | 3778.63 ± 5.1% | 269.84 ± 0.5% | 1.00 | 1.00 | 3.15 | 1.25 |
| a UUID | 62 | 189.51 ± 0.4% | 190.06 ± 0.4% | 215.95 ± 0.5% | 45.58 ± 0.9% | 98.22 ± 1.3% | 186.22 ± 1.9% | 4465.33 ± 0.4% | 190.02 ± 0.6% | 1.00 | 1.00 | 4.16 | 1.93 |
| an IPv4 address | 29 | 475.25 ± 0.3% | 479.37 ± 0.3% | 641.33 ± 0.4% | 77.58 ± 0.1% | 130.88 ± 2.1% | 296.84 ± 0.5% | 7543.15 ± 0.3% | 475.00 ± 0.3% | 0.99 | 1.00 | 6.13 | 3.63 |
| a date and time | 56 | 336.85 ± 0.3% | 338.64 ± 0.3% | 413.89 ± 0.2% | 72.62 ± 1.1% | 137.47 ± 2.0% | 328.74 ± 2.0% | 4972.08 ± 0.4% | 336.67 ± 0.1% | 0.99 | 1.00 | 4.64 | 2.45 |
| a field path | 39 | 270.71 ± 0.6% | 271.37 ± 0.2% | 317.91 ± 0.2% | 79.11 ± 0.6% | 203.95 ± 1.2% | 504.12 ± 2.2% | 4840.99 ± 0.6% | 270.26 ± 0.5% | 1.00 | 1.00 | 3.42 | 1.33 |
| literal: a word | 7 | 761.81 ± 0.4% | 789.96 ± 0.3% | 1330.88 ± 0.1% | 497.55 ± 0.9% | 630.63 ± 0.9% | 961.78 ± 0.8% | 30826.01 ± 0.7% | 762.23 ± 0.3% | 0.96 | 1.00 | 1.53 | 1.21 |
| literal: a word that is not there | 8 | 730.87 ± 0.2% | 757.71 ± 0.3% | 1247.00 ± 0.2% | 452.51 ± 0.7% | 603.06 ± 1.5% | 909.11 ± 0.4% | 29768.08 ± 0.5% | 731.06 ± 0.3% | 0.96 | 1.00 | 1.62 | 1.21 |
| literal: one of four words | 26 | 406.18 ± 0.3% | 445.02 ± 0.4% | 585.47 ± 0.4% | 50.51 ± 0.9% | 241.55 ± 2.8% | 377.63 ± 2.4% | 15802.16 ± 0.4% | 407.37 ± 0.7% | 0.91 | 1.00 | 8.04 | 1.68 |
| literal: a word in any case | 11 | 575.39 ± 0.4% | 594.91 ± 0.4% | 889.43 ± 0.4% | 15.43 ± 0.9% | 647.05 ± 2.5% | refused | 23897.70 ± 0.2% | 574.87 ± 0.6% | 0.97 | 1.00 | 37.28 | 0.89 |
| literal: an href attribute | 12 | 437.53 ± 0.8% | 444.77 ± 0.4% | 587.85 ± 0.4% | 45.64 ± 0.7% | 501.03 ± 1.6% | 757.50 ± 0.6% | 22353.18 ± 1.2% | 437.80 ± 0.7% | 0.98 | 1.00 | 9.59 | 0.87 |
| literal: a word, second text | 10 | 678.51 ± 0.5% | 706.35 ± 0.9% | 1128.93 ± 0.3% | 411.56 ± 0.3% | 536.37 ± 1.9% | 783.15 ± 0.5% | 27731.07 ± 0.7% | 678.06 ± 0.6% | 0.96 | 1.00 | 1.65 | 1.27 |
| class: two capitalized words | 23 | 506.91 ± 0.8% | 526.46 ± 0.3% | 731.09 ± 0.5% | 100.60 ± 0.3% | 503.75 ± 1.4% | 756.31 ± 0.4% | 6340.08 ± 0.2% | 506.08 ± 0.7% | 0.96 | 1.00 | 5.04 | 1.01 |
| class: a word that ends in ing | 9 | 702.66 ± 0.8% | 748.61 ± 0.7% | 1222.07 ± 0.4% | 131.60 ± 0.4% | 756.46 ± 1.8% | 1088.02 ± 0.6% | 15849.82 ± 0.2% | 702.83 ± 0.2% | 0.94 | 1.00 | 5.34 | 0.93 |
| class: a word in capitals | 16 | 594.06 ± 0.2% | 619.44 ± 0.4% | 909.77 ± 0.2% | 135.17 ± 0.3% | 750.16 ± 1.8% | 1008.43 ± 0.3% | 8338.95 ± 0.3% | 593.77 ± 0.2% | 0.96 | 1.00 | 4.39 | 0.79 |
| class: a number | 6 | 776.73 ± 0.3% | 817.71 ± 0.2% | 1398.16 ± 0.1% | 41.29 ± 2.2% | 1388.78 ± 1.6% | 1834.50 ± 1.1% | 22956.46 ± 0.4% | 775.36 ± 0.3% | 0.95 | 1.00 | 18.81 | 0.56 |
| class: two capitalized words, second text | 23 | 506.76 ± 0.5% | 525.93 ± 0.3% | 731.77 ± 0.5% | 101.74 ± 0.4% | 504.70 ± 1.0% | 732.73 ± 0.4% | 6337.23 ± 0.2% | 506.65 ± 0.5% | 0.96 | 1.00 | 4.98 | 1.00 |
| other: a word between two words | 13 | 644.44 ± 0.4% | 653.25 ± 0.3% | 993.85 ± 0.1% | 132.30 ± 0.4% | 498.69 ± 2.3% | 806.13 ± 0.5% | 14759.57 ± 0.4% | 644.55 ± 0.1% | 0.99 | 1.00 | 4.87 | 1.29 |
| other: a number before a unit, second text | 15 | 507.71 ± 0.5% | 540.72 ± 0.8% | 757.91 ± 0.2% | 38.93 ± 0.3% | 631.06 ± 0.5% | 890.07 ± 0.9% | 15274.06 ± 0.3% | 505.91 ± 0.6% | 0.94 | 1.00 | 13.04 | 0.80 |
| other: a heading's start tag | 13 | 434.28 ± 0.4% | 440.30 ± 0.4% | 585.20 ± 0.7% | 43.52 ± 0.2% | 634.60 ± 0.9% | 860.93 ± 0.3% | 18534.44 ± 0.1% | 433.56 ± 0.4% | 0.99 | 1.00 | 9.98 | 0.68 |
| other: a whole word | 11 | 707.28 ± 0.1% | 720.89 ± 0.5% | 1158.27 ± 0.5% | 117.48 ± 0.8% | 563.47 ± 1.4% | 829.93 ± 0.5% | 27159.77 ± 0.4% | 706.76 ± 0.3% | 0.98 | 1.00 | 6.02 | 1.26 |
| other: a line's first word, second text | 17 | 631.08 ± 0.2% | 653.84 ± 0.3% | 983.66 ± 0.2% | 127.10 ± 0.3% | 710.40 ± 10.6% | refused | refused | 628.31 ± 0.6% | 0.97 | 1.00 | 4.97 | 0.89 |
| other: fourteen octets before an x | 16 | 119.51 ± 0.6% | 161.01 ± 0.7% | 187.78 ± 0.6% | 15.24 ± 0.3% | 453.04 ± 0.7% | 417.41 ± 0.7% | 13036.28 ± 0.2% | 119.14 ± 0.8% | 0.74 | 1.00 | 7.84 | 0.26 |
| other: a Greek word | 8 | 724.98 ± 0.5% | 777.36 ± 0.4% | 1282.10 ± 0.6% | 59.00 ± 0.3% | 1381.23 ± 0.8% | 1805.84 ± 0.4% | refused | 725.06 ± 0.5% | 0.93 | 1.00 | 12.29 | 0.52 |

