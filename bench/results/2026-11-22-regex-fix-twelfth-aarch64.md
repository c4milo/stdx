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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45065556363 |
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
| literal: a word | 217 | 15566.97 ± 0.6% | 1047.57 ± 0.4% | 28.75 ± 0.5% | 18277.51 ± 1.9% | 9145.42 ± 7.9% | 17.37 ± 0.4% | 87.02 ± 0.4% | 15572.84 ± 0.8% | 14.86 | 1.00 | 0.85 | 1.70 |
| literal: a word that is not there | 0 | 18186.25 ± 2.1% | 1055.15 ± 0.1% | 28.64 ± 0.2% | 19554.67 ± 2.4% | 29410.66 ± 1.2% | 17.18 ± 0.2% | 81.20 ± 0.6% | 18298.63 ± 1.5% | 17.24 | 0.99 | 0.93 | 0.62 |
| literal: one of four words | 661 | 5808.27 ± 0.7% | 1025.97 ± 0.1% | 14.98 ± 0.3% | 3929.95 ± 0.3% | 21.89 ± 0.2% | 5.25 ± 0.1% | 6.94 ± 0.4% | 5794.59 ± 0.8% | 5.66 | 1.00 | 1.48 | 265.37 |
| literal: a word in any case | 217 | 11711.38 ± 1.0% | 1044.38 ± 0.2% | 22.00 ± 2.3% | 3982.79 ± 0.4% | 38.72 ± 0.6% | refused | differs | 11695.86 ± 0.4% | 11.21 | 1.00 | 2.94 | 302.43 |
| literal: an href attribute | 33 | 16161.06 ± 0.5% | 1053.41 ± 0.1% | 27.74 ± 0.2% | 16976.57 ± 1.1% | 2265.04 ± 0.1% | 13.18 ± 0.2% | 75.74 ± 0.4% | 16166.67 ± 0.5% | 15.34 | 1.00 | 0.95 | 7.13 |
| literal: a word, second text | 123 | 15812.22 ± 1.6% | 1052.01 ± 0.3% | 28.25 ± 0.2% | 18802.22 ± 1.7% | 7683.99 ± 5.6% | 19.67 ± 0.3% | 71.39 ± 0.3% | 15814.52 ± 0.6% | 15.03 | 1.00 | 0.84 | 2.06 |
| class: two capitalized words | 1331 | 1108.57 ± 0.6% | 964.03 ± 0.1% | 26.47 ± 0.5% | 587.59 ± 0.1% | 40.91 ± 12.3% | 14.78 ± 0.3% | 67.95 ± 0.4% | 1108.57 ± 0.2% | 1.15 | 1.00 | 1.89 | 27.10 |
| class: a word that ends in ing | 3399 | 888.37 ± 0.2% | 889.89 ± 0.1% | 18.56 ± 0.3% | 550.07 ± 0.1% | 29.54 ± 2.9% | 8.16 ± 0.3% | 18.34 ± 0.5% | 888.14 ± 0.1% | 1.00 | 1.00 | 1.62 | 30.07 |
| class: a word in capitals | 2332 | 1462.66 ± 0.3% | 960.76 ± 0.2% | 27.92 ± 0.3% | 575.16 ± 0.1% | 43.75 ± 2.6% | 17.15 ± 0.2% | 83.31 ± 0.4% | 1460.85 ± 0.5% | 1.52 | 1.00 | 2.54 | 33.44 |
| class: a number | 8288 | 2117.05 ± 0.4% | 812.62 ± 0.1% | 28.15 ± 0.3% | 1799.76 ± 0.2% | 41.66 ± 16.3% | 0.54 ± 0.2% | 57.24 ± 0.2% | 2114.93 ± 0.4% | 2.61 | 1.00 | 1.18 | 50.82 |
| class: two capitalized words, second text | 5359 | 702.29 ± 0.1% | 703.01 ± 0.1% | 23.77 ± 0.2% | 486.29 ± 0.3% | 33.21 ± 12.3% | 16.67 ± 0.2% | 63.20 ± 0.4% | 701.96 ± 0.1% | 1.00 | 1.00 | 1.44 | 21.15 |
| other: a word between two words | 6104 | 746.74 ± 0.1% | 755.40 ± 0.1% | 23.98 ± 0.3% | 751.80 ± 0.3% | 108.38 ± 13.1% | 11.26 ± 0.3% | 69.71 ± 1.0% | 748.51 ± 0.2% | 0.99 | 1.00 | 0.99 | 6.89 |
| other: a number before a unit, second text | 1481 | 5304.15 ± 0.5% | 985.69 ± 0.1% | 26.35 ± 0.2% | 5942.20 ± 0.6% | 40.99 ± 11.3% | 17.83 ± 0.2% | 65.84 ± 0.3% | 5297.82 ± 1.3% | 5.38 | 1.00 | 0.89 | 129.42 |
| other: a heading's start tag | 110 | 12453.98 ± 0.6% | 1041.48 ± 0.0% | 27.48 ± 0.2% | 1723.45 ± 0.1% | 1586.31 ± 6.3% | 16.10 ± 0.6% | 88.13 ± 0.7% | 12475.36 ± 0.5% | 11.96 | 1.00 | 7.23 | 7.85 |
| other: a whole word | 217 | 13682.74 ± 0.5% | 1047.73 ± 0.0% | 29.65 ± 0.7% | 14562.35 ± 1.4% | 49.33 ± 0.2% | 13.46 ± 0.2% | 55.60 ± 0.7% | 13697.88 ± 0.2% | 13.06 | 1.00 | 0.94 | 277.36 |
| other: a line's first word, second text | 3716 | 1923.58 ± 0.4% | 859.00 ± 0.1% | 31.40 ± 0.6% | 1751.06 ± 0.9% | 62.28 ± 6.9% | refused | refused | 1919.11 ± 0.3% | 2.24 | 1.00 | 1.10 | 30.88 |
| other: fourteen octets before an x | 87 | 19243.98 ± 0.6% | 1.54 ± 0.6% | 1.54 ± 0.5% | 4046.77 ± 0.7% | 10.68 ± 0.1% | differs | 17.91 ± 0.2% | 19136.40 ± 0.5% | 12512.28 | 1.01 | 4.76 | 1801.93 |
| other: a Greek word | 21815 | 479.63 ± 0.2% | 322.86 ± 0.7% | 31.49 ± 0.2% | 294.43 ± 0.2% | 47.55 ± 10.3% | differs | refused | 479.23 ± 0.6% | 1.49 | 1.00 | 1.63 | 10.09 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.09 ± 0.1% | 28.09 ± 0.2% | 0.50 ± 0.2% | 21.46 ± 0.3% | 2.78 ± 0.5% | differs | 4.02 ± 0.1% | 28.09 ± 0.1% | 1.00 | 1.00 | 1.31 | 10.10 |
| a UUID | 32895 | 23.18 ± 0.1% | 23.19 ± 0.1% | 0.67 ± 0.1% | 16.01 ± 0.3% | 3.11 ± 0.8% | 0.72 ± 0.3% | 3.63 ± 0.8% | 23.20 ± 0.2% | 1.00 | 1.00 | 1.45 | 7.46 |
| an IPv4 address | 33176 | 41.52 ± 0.4% | 41.50 ± 0.2% | 2.19 ± 0.2% | 32.50 ± 0.3% | 6.68 ± 1.1% | differs | 4.08 ± 0.3% | 41.48 ± 0.3% | 1.00 | 1.00 | 1.28 | 6.22 |
| a date and time | 32954 | 34.92 ± 0.1% | 34.91 ± 0.3% | 1.51 ± 0.2% | 23.14 ± 0.1% | 7.11 ± 0.1% | 1.19 ± 0.1% | 7.06 ± 0.2% | 34.88 ± 0.1% | 1.00 | 1.00 | 1.51 | 4.91 |
| a field path | 32606 | 32.23 ± 0.3% | 32.26 ± 0.2% | 0.83 ± 0.1% | 25.20 ± 0.2% | 3.51 ± 0.6% | differs | 2.91 ± 0.2% | 32.19 ± 0.4% | 1.00 | 1.00 | 1.28 | 9.19 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.25 ± 0.2% | 10.25 ± 0.1% | 10.25 ± 0.2% | 11.27 ± 0.4% | 4.96 ± 2.7% | 0.91 ± 0.5% | none | 10.25 ± 0.1% | 1.00 | 1.00 | 0.91 | 2.07 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 269.50 ± 0.5% | 271.04 ± 0.3% | 317.28 ± 0.1% | 85.94 ± 0.3% | 223.67 ± 1.2% | 480.08 ± 1.7% | 3787.42 ± 0.3% | 269.40 ± 0.5% | 0.99 | 1.00 | 3.14 | 1.20 |
| a UUID | 62 | 190.52 ± 0.1% | 191.09 ± 0.3% | 216.57 ± 0.2% | 46.42 ± 0.8% | 100.01 ± 0.5% | 188.86 ± 2.7% | 4461.65 ± 0.2% | 190.46 ± 0.1% | 1.00 | 1.00 | 4.10 | 1.90 |
| an IPv4 address | 29 | 476.19 ± 0.4% | 480.32 ± 0.4% | 643.51 ± 0.3% | 76.79 ± 0.4% | 131.95 ± 2.0% | 301.33 ± 1.4% | 7560.91 ± 0.1% | 476.54 ± 0.3% | 0.99 | 1.00 | 6.20 | 3.61 |
| a date and time | 56 | 337.53 ± 0.2% | 338.90 ± 0.3% | 414.34 ± 0.6% | 72.93 ± 0.4% | 138.38 ± 1.7% | 323.39 ± 0.9% | 4969.41 ± 0.3% | 337.25 ± 0.3% | 1.00 | 1.00 | 4.63 | 2.44 |
| a field path | 39 | 270.49 ± 0.6% | 271.32 ± 0.6% | 318.12 ± 0.6% | 80.69 ± 1.1% | 208.24 ± 1.1% | 501.46 ± 3.0% | 4851.07 ± 2.9% | 270.40 ± 0.3% | 1.00 | 1.00 | 3.35 | 1.30 |
| literal: a word | 7 | 760.65 ± 0.5% | 789.62 ± 0.8% | 1332.12 ± 0.2% | 524.96 ± 0.1% | 638.88 ± 2.2% | 951.41 ± 0.3% | 30880.14 ± 1.6% | 761.49 ± 0.7% | 0.96 | 1.00 | 1.45 | 1.19 |
| literal: a word that is not there | 8 | 730.36 ± 0.4% | 758.33 ± 0.8% | 1248.47 ± 0.1% | 482.52 ± 0.4% | 609.08 ± 6.2% | 901.38 ± 1.2% | 29823.27 ± 0.4% | 731.12 ± 0.2% | 0.96 | 1.00 | 1.51 | 1.20 |
| literal: one of four words | 26 | 406.84 ± 0.4% | 445.63 ± 0.2% | 587.18 ± 0.2% | 49.70 ± 1.0% | 244.91 ± 1.9% | 371.39 ± 1.6% | 15811.33 ± 0.4% | 406.01 ± 0.5% | 0.91 | 1.00 | 8.19 | 1.66 |
| literal: a word in any case | 11 | 575.25 ± 0.4% | 595.14 ± 0.2% | 889.46 ± 0.3% | 15.83 ± 1.8% | 653.71 ± 2.1% | refused | 23917.83 ± 0.6% | 576.03 ± 0.2% | 0.97 | 1.00 | 36.33 | 0.88 |
| literal: an href attribute | 12 | 438.26 ± 0.4% | 445.90 ± 0.2% | 590.21 ± 0.2% | 45.78 ± 0.7% | 505.75 ± 1.1% | 765.95 ± 0.3% | 22337.81 ± 0.2% | 439.07 ± 0.5% | 0.98 | 1.00 | 9.57 | 0.87 |
| literal: a word, second text | 10 | 678.76 ± 0.4% | 708.51 ± 0.2% | 1129.54 ± 0.2% | 402.88 ± 0.3% | 537.57 ± 2.1% | 794.34 ± 0.4% | 27713.88 ± 0.6% | 679.12 ± 0.2% | 0.96 | 1.00 | 1.68 | 1.26 |
| class: two capitalized words | 23 | 507.75 ± 0.9% | 526.60 ± 0.5% | 732.63 ± 0.7% | 99.68 ± 0.2% | 503.32 ± 1.1% | 740.15 ± 0.3% | 6345.73 ± 0.3% | 507.69 ± 0.4% | 0.96 | 1.00 | 5.09 | 1.01 |
| class: a word that ends in ing | 9 | 701.42 ± 0.7% | 748.73 ± 0.3% | 1226.14 ± 0.2% | 131.29 ± 1.8% | 759.25 ± 1.4% | 1084.92 ± 0.4% | 15852.33 ± 0.1% | 702.98 ± 0.4% | 0.94 | 1.00 | 5.34 | 0.92 |
| class: a word in capitals | 16 | 594.73 ± 0.2% | 620.81 ± 0.3% | 910.91 ± 0.3% | 134.34 ± 0.5% | 754.83 ± 3.2% | 1015.80 ± 0.9% | 8343.19 ± 0.2% | 594.02 ± 0.4% | 0.96 | 1.00 | 4.43 | 0.79 |
| class: a number | 6 | 778.58 ± 0.3% | 818.83 ± 0.3% | 1403.67 ± 0.1% | 41.77 ± 0.6% | 1411.38 ± 4.1% | 1839.15 ± 1.0% | 22966.80 ± 0.1% | 778.12 ± 0.4% | 0.95 | 1.00 | 18.64 | 0.55 |
| class: two capitalized words, second text | 23 | 509.26 ± 1.0% | 525.81 ± 0.5% | 733.55 ± 0.4% | 101.00 ± 0.3% | 506.22 ± 1.0% | 760.86 ± 0.6% | 6339.53 ± 0.3% | 508.56 ± 0.6% | 0.97 | 1.00 | 5.04 | 1.01 |
| other: a word between two words | 13 | 642.85 ± 0.6% | 653.31 ± 0.6% | 994.99 ± 0.7% | 132.70 ± 0.8% | 511.91 ± 1.6% | 808.19 ± 0.5% | 14770.26 ± 0.2% | 642.43 ± 0.6% | 0.98 | 1.00 | 4.84 | 1.26 |
| other: a number before a unit, second text | 15 | 507.92 ± 0.3% | 541.44 ± 0.6% | 760.78 ± 0.3% | 39.59 ± 0.6% | 645.67 ± 1.2% | 887.18 ± 1.0% | 15276.22 ± 0.4% | 507.95 ± 0.2% | 0.94 | 1.00 | 12.83 | 0.79 |
| other: a heading's start tag | 13 | 434.09 ± 0.6% | 440.99 ± 0.3% | 586.60 ± 0.3% | 43.82 ± 0.4% | 641.74 ± 0.8% | 872.28 ± 0.7% | 18530.53 ± 0.4% | 433.77 ± 0.5% | 0.98 | 1.00 | 9.91 | 0.68 |
| other: a whole word | 11 | 704.75 ± 0.3% | 721.49 ± 0.3% | 1161.04 ± 0.2% | 117.36 ± 0.5% | 563.79 ± 2.9% | 831.14 ± 0.7% | 27175.00 ± 0.1% | 704.71 ± 0.2% | 0.98 | 1.00 | 6.00 | 1.25 |
| other: a line's first word, second text | 17 | 632.04 ± 0.4% | 654.99 ± 0.3% | 986.00 ± 0.1% | 127.86 ± 0.6% | 713.93 ± 0.8% | refused | refused | 628.95 ± 0.8% | 0.96 | 1.00 | 4.94 | 0.89 |
| other: fourteen octets before an x | 16 | 119.53 ± 0.4% | 161.14 ± 2.0% | 187.52 ± 0.6% | 15.15 ± 0.2% | 454.12 ± 1.2% | 409.68 ± 0.6% | 13025.54 ± 0.2% | 119.36 ± 0.9% | 0.74 | 1.00 | 7.89 | 0.26 |
| other: a Greek word | 8 | 726.63 ± 0.8% | 777.57 ± 0.6% | 1287.13 ± 0.6% | 59.07 ± 0.6% | 1399.26 ± 1.0% | 1774.35 ± 0.7% | refused | 726.55 ± 0.6% | 0.93 | 1.00 | 12.30 | 0.52 |

