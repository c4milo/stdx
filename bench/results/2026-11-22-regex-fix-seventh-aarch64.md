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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063435700 |
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
| literal: a word | 217 | 15432.90 ± 0.7% | 1047.48 ± 0.2% | 28.72 ± 0.4% | 18237.40 ± 3.9% | 9077.72 ± 8.4% | 17.44 ± 0.3% | 86.55 ± 0.5% | 15448.76 ± 1.9% | 14.73 | 1.00 | 0.85 | 1.70 |
| literal: a word that is not there | 0 | 18230.24 ± 2.0% | 1054.62 ± 0.5% | 28.69 ± 0.6% | 19509.31 ± 1.7% | 28685.58 ± 5.5% | 17.18 ± 0.2% | 81.15 ± 0.4% | 18275.34 ± 2.0% | 17.29 | 1.00 | 0.93 | 0.64 |
| literal: one of four words | 661 | 5815.13 ± 0.3% | 1025.22 ± 0.1% | 15.05 ± 1.8% | 3981.92 ± 0.7% | 21.87 ± 0.2% | 5.42 ± 0.1% | 6.95 ± 0.3% | 5808.33 ± 0.2% | 5.67 | 1.00 | 1.46 | 265.96 |
| literal: a word in any case | 217 | 11651.40 ± 0.4% | 1045.13 ± 0.2% | 21.95 ± 1.8% | 3980.45 ± 0.3% | 38.65 ± 1.2% | refused | differs | 11652.01 ± 0.6% | 11.15 | 1.00 | 2.93 | 301.48 |
| literal: an href attribute | 33 | 15796.32 ± 1.5% | 1052.01 ± 0.7% | 27.77 ± 0.3% | 16392.48 ± 2.3% | 2259.20 ± 0.6% | 13.10 ± 0.1% | 75.89 ± 0.6% | 15909.73 ± 1.6% | 15.02 | 0.99 | 0.96 | 6.99 |
| literal: a word, second text | 123 | 15543.39 ± 1.4% | 1048.95 ± 0.1% | 28.32 ± 0.3% | 18376.35 ± 1.9% | 7677.51 ± 4.7% | 20.13 ± 0.4% | 71.03 ± 0.3% | 15694.34 ± 0.5% | 14.82 | 0.99 | 0.85 | 2.02 |
| class: two capitalized words | 1331 | 1104.49 ± 0.4% | 963.78 ± 0.3% | 26.48 ± 0.2% | 587.38 ± 0.1% | 40.88 ± 13.4% | 14.77 ± 0.3% | 67.97 ± 0.3% | 1105.33 ± 0.3% | 1.15 | 1.00 | 1.88 | 27.02 |
| class: a word that ends in ing | 3399 | 887.54 ± 0.1% | 889.21 ± 0.1% | 18.59 ± 0.2% | 550.20 ± 0.2% | 29.51 ± 3.3% | 8.18 ± 0.3% | 18.36 ± 0.2% | 886.60 ± 0.1% | 1.00 | 1.00 | 1.61 | 30.08 |
| class: a word in capitals | 2332 | 1462.90 ± 0.6% | 960.21 ± 0.2% | 27.94 ± 0.3% | 574.92 ± 0.1% | 43.71 ± 2.8% | 17.13 ± 0.4% | 83.45 ± 0.2% | 1460.91 ± 0.2% | 1.52 | 1.00 | 2.54 | 33.47 |
| class: a number | 8288 | 2113.16 ± 0.5% | 811.79 ± 0.1% | 28.17 ± 0.4% | 1792.20 ± 0.3% | 40.78 ± 15.7% | 0.55 ± 0.2% | 57.59 ± 0.3% | 2112.82 ± 0.3% | 2.60 | 1.00 | 1.18 | 51.82 |
| class: two capitalized words, second text | 5359 | 700.45 ± 0.2% | 701.45 ± 0.1% | 23.83 ± 0.1% | 488.70 ± 0.1% | 35.16 ± 6.9% | 17.07 ± 0.4% | 63.31 ± 0.3% | 700.48 ± 0.1% | 1.00 | 1.00 | 1.43 | 19.92 |
| other: a word between two words | 6104 | 747.57 ± 0.2% | 754.44 ± 0.0% | 24.02 ± 0.5% | 750.75 ± 0.5% | 108.74 ± 8.6% | 11.18 ± 0.2% | 69.33 ± 0.4% | 747.06 ± 0.2% | 0.99 | 1.00 | 1.00 | 6.87 |
| other: a number before a unit, second text | 1481 | 5308.90 ± 0.7% | 983.64 ± 0.1% | 26.38 ± 0.4% | 5916.49 ± 0.5% | 40.99 ± 16.3% | 18.17 ± 0.1% | 65.86 ± 0.4% | 5289.45 ± 0.4% | 5.40 | 1.00 | 0.90 | 129.50 |
| other: a heading's start tag | 110 | 12232.75 ± 0.8% | 1039.74 ± 0.1% | 27.45 ± 0.3% | 1717.74 ± 0.3% | 1586.02 ± 0.7% | 16.19 ± 0.2% | 87.91 ± 1.2% | 12258.31 ± 0.6% | 11.77 | 1.00 | 7.12 | 7.71 |
| other: a whole word | 217 | 13551.73 ± 0.9% | 1046.67 ± 0.2% | 29.98 ± 0.4% | 14459.15 ± 1.4% | 49.27 ± 0.2% | 13.28 ± 0.2% | 55.50 ± 0.8% | 13467.20 ± 0.7% | 12.95 | 1.01 | 0.94 | 275.03 |
| other: a line's first word, second text | 3716 | 1922.78 ± 0.8% | 868.03 ± 0.2% | 31.77 ± 0.4% | 1755.50 ± 0.5% | 62.34 ± 6.0% | refused | refused | 1911.27 ± 0.9% | 2.22 | 1.01 | 1.10 | 30.84 |
| other: fourteen octets before an x | 87 | 18694.68 ± 1.4% | 1.54 ± 0.3% | 1.54 ± 0.2% | 3981.76 ± 0.6% | 10.68 ± 0.1% | differs | 17.92 ± 0.2% | 18574.12 ± 1.9% | 12144.22 | 1.01 | 4.70 | 1750.38 |
| other: a Greek word | 21815 | 480.28 ± 0.8% | 323.35 ± 0.4% | 31.47 ± 0.1% | 293.86 ± 0.2% | 44.13 ± 11.0% | differs | refused | 479.16 ± 0.4% | 1.49 | 1.00 | 1.63 | 10.88 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.93 ± 0.2% | 27.91 ± 0.2% | 0.50 ± 0.2% | 21.58 ± 0.3% | 2.76 ± 0.8% | differs | 3.85 ± 0.1% | 27.91 ± 0.1% | 1.00 | 1.00 | 1.29 | 10.11 |
| a UUID | 32895 | 23.23 ± 0.2% | 23.22 ± 0.1% | 0.67 ± 0.1% | 16.05 ± 0.1% | 3.09 ± 0.3% | 0.73 ± 0.1% | 3.64 ± 0.8% | 23.22 ± 0.2% | 1.00 | 1.00 | 1.45 | 7.51 |
| an IPv4 address | 33176 | 41.46 ± 0.4% | 41.43 ± 0.2% | 2.18 ± 0.4% | 32.84 ± 0.2% | 6.68 ± 0.3% | differs | 4.09 ± 0.3% | 41.49 ± 0.4% | 1.00 | 1.00 | 1.26 | 6.20 |
| a date and time | 32954 | 34.84 ± 0.1% | 34.85 ± 0.1% | 1.52 ± 0.2% | 23.52 ± 0.3% | 7.08 ± 0.2% | 1.25 ± 0.3% | 7.06 ± 0.2% | 34.85 ± 0.1% | 1.00 | 1.00 | 1.48 | 4.92 |
| a field path | 32606 | 32.31 ± 0.4% | 32.30 ± 0.2% | 0.83 ± 0.2% | 25.36 ± 0.2% | 3.45 ± 2.2% | differs | 2.87 ± 0.2% | 32.23 ± 0.2% | 1.00 | 1.00 | 1.27 | 9.37 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.28 ± 0.1% | 10.28 ± 0.1% | 10.29 ± 0.1% | 11.45 ± 0.2% | 4.92 ± 2.1% | 0.93 ± 0.8% | none | 10.28 ± 0.3% | 1.00 | 1.00 | 0.90 | 2.09 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 277.54 ± 0.4% | 278.86 ± 0.2% | 325.02 ± 0.2% | 85.78 ± 0.5% | 217.62 ± 1.2% | 487.14 ± 1.6% | 3767.95 ± 2.9% | 277.55 ± 0.3% | 1.00 | 1.00 | 3.24 | 1.28 |
| a UUID | 62 | 198.36 ± 0.2% | 198.88 ± 0.3% | 223.96 ± 0.3% | 46.18 ± 0.5% | 98.30 ± 1.5% | 189.28 ± 3.2% | 4444.87 ± 0.2% | 198.38 ± 0.4% | 1.00 | 1.00 | 4.30 | 2.02 |
| an IPv4 address | 29 | 479.50 ± 0.5% | 483.85 ± 0.3% | 644.55 ± 0.5% | 76.23 ± 0.3% | 130.53 ± 0.4% | 298.22 ± 2.3% | 7522.57 ± 0.4% | 478.97 ± 0.2% | 0.99 | 1.00 | 6.29 | 3.67 |
| a date and time | 56 | 336.98 ± 0.3% | 339.48 ± 0.4% | 411.62 ± 0.1% | 72.08 ± 0.2% | 134.65 ± 2.9% | 329.66 ± 1.4% | 4942.88 ± 0.2% | 337.09 ± 0.1% | 0.99 | 1.00 | 4.68 | 2.50 |
| a field path | 39 | 286.62 ± 0.6% | 287.69 ± 0.6% | 337.39 ± 0.3% | 80.54 ± 1.6% | 205.50 ± 1.6% | 506.23 ± 2.6% | 4827.28 ± 0.3% | 286.59 ± 0.4% | 1.00 | 1.00 | 3.56 | 1.39 |
| literal: a word | 7 | 760.94 ± 0.3% | 784.78 ± 0.1% | 1309.90 ± 0.3% | 493.77 ± 0.4% | 619.22 ± 2.0% | 960.85 ± 0.2% | 30457.53 ± 0.4% | 761.17 ± 0.3% | 0.97 | 1.00 | 1.54 | 1.23 |
| literal: a word that is not there | 8 | 731.09 ± 0.4% | 753.35 ± 0.4% | 1229.95 ± 0.1% | 458.71 ± 0.2% | 594.05 ± 2.2% | 910.95 ± 0.8% | 29190.99 ± 0.3% | 730.88 ± 0.5% | 0.97 | 1.00 | 1.59 | 1.23 |
| literal: one of four words | 26 | 405.50 ± 0.6% | 440.50 ± 0.2% | 574.36 ± 0.3% | 49.48 ± 1.5% | 233.72 ± 3.2% | 374.14 ± 0.7% | 15643.92 ± 0.3% | 405.48 ± 0.6% | 0.92 | 1.00 | 8.20 | 1.73 |
| literal: a word in any case | 11 | 572.85 ± 0.4% | 590.35 ± 0.2% | 867.94 ± 0.1% | 15.49 ± 0.3% | 636.82 ± 4.3% | refused | 23639.02 ± 0.6% | 572.17 ± 0.2% | 0.97 | 1.00 | 36.99 | 0.90 |
| literal: an href attribute | 12 | 440.67 ± 0.6% | 447.37 ± 0.6% | 585.11 ± 0.8% | 44.35 ± 0.8% | 487.01 ± 0.9% | 767.44 ± 0.8% | 21662.41 ± 0.0% | 441.90 ± 0.7% | 0.99 | 1.00 | 9.94 | 0.90 |
| literal: a word, second text | 10 | 677.98 ± 0.3% | 702.58 ± 0.2% | 1104.70 ± 0.1% | 377.41 ± 0.4% | 529.46 ± 1.3% | 801.79 ± 0.3% | 27072.28 ± 0.1% | 677.88 ± 0.2% | 0.96 | 1.00 | 1.80 | 1.28 |
| class: two capitalized words | 23 | 510.23 ± 0.3% | 527.88 ± 0.4% | 726.58 ± 0.6% | 99.05 ± 0.2% | 496.46 ± 1.2% | 746.91 ± 2.2% | 6294.04 ± 0.3% | 509.43 ± 0.4% | 0.97 | 1.00 | 5.15 | 1.03 |
| class: a word that ends in ing | 9 | 710.31 ± 0.3% | 755.37 ± 0.6% | 1228.78 ± 0.6% | 129.80 ± 0.5% | 750.20 ± 1.3% | 1103.81 ± 0.9% | 15715.49 ± 0.2% | 709.95 ± 0.1% | 0.94 | 1.00 | 5.47 | 0.95 |
| class: a word in capitals | 16 | 604.45 ± 0.4% | 630.79 ± 0.4% | 930.99 ± 0.1% | 133.43 ± 0.7% | 749.26 ± 1.7% | 1019.41 ± 0.7% | 8324.60 ± 0.2% | 603.76 ± 0.3% | 0.96 | 1.00 | 4.53 | 0.81 |
| class: a number | 6 | 796.46 ± 0.8% | 837.95 ± 0.4% | 1451.69 ± 0.1% | 41.68 ± 0.4% | 1386.85 ± 2.1% | 1857.86 ± 1.5% | 22729.55 ± 0.1% | 796.43 ± 0.3% | 0.95 | 1.00 | 19.11 | 0.57 |
| class: two capitalized words, second text | 23 | 510.05 ± 0.4% | 527.60 ± 0.4% | 727.13 ± 0.5% | 100.80 ± 0.7% | 497.95 ± 1.7% | 744.69 ± 0.5% | 6296.95 ± 0.1% | 510.13 ± 0.3% | 0.97 | 1.00 | 5.06 | 1.02 |
| other: a word between two words | 13 | 645.82 ± 0.3% | 654.81 ± 0.3% | 990.00 ± 0.3% | 130.60 ± 0.2% | 495.55 ± 2.1% | 808.11 ± 0.6% | 14685.63 ± 0.2% | 647.57 ± 0.4% | 0.99 | 1.00 | 4.94 | 1.30 |
| other: a number before a unit, second text | 15 | 522.19 ± 0.5% | 555.55 ± 0.1% | 780.99 ± 0.1% | 39.13 ± 0.3% | 621.53 ± 1.6% | 890.78 ± 0.7% | 15106.96 ± 0.1% | 521.29 ± 0.3% | 0.94 | 1.00 | 13.35 | 0.84 |
| other: a heading's start tag | 13 | 440.54 ± 1.9% | 445.41 ± 0.8% | 585.19 ± 0.5% | 43.28 ± 0.5% | 616.86 ± 3.0% | 877.76 ± 0.4% | 18065.53 ± 0.1% | 441.94 ± 2.3% | 0.99 | 1.00 | 10.18 | 0.71 |
| other: a whole word | 11 | 706.41 ± 0.3% | 720.28 ± 0.1% | 1145.48 ± 0.3% | 116.53 ± 0.1% | 561.64 ± 1.9% | 837.02 ± 1.2% | 26796.66 ± 1.1% | 708.92 ± 0.3% | 0.98 | 1.00 | 6.06 | 1.26 |
| other: a line's first word, second text | 17 | 639.88 ± 0.2% | 664.39 ± 0.3% | 1000.37 ± 0.2% | 127.71 ± 0.4% | 709.48 ± 0.7% | refused | refused | 637.82 ± 0.8% | 0.96 | 1.00 | 5.01 | 0.90 |
| other: fourteen octets before an x | 16 | 120.88 ± 1.1% | 163.72 ± 1.2% | 188.85 ± 1.5% | 14.88 ± 0.4% | 452.23 ± 0.9% | 413.04 ± 0.6% | 12829.42 ± 0.1% | 120.78 ± 1.0% | 0.74 | 1.00 | 8.12 | 0.27 |
| other: a Greek word | 8 | 739.75 ± 0.3% | 791.46 ± 0.7% | 1316.36 ± 0.2% | 58.97 ± 0.6% | 1383.53 ± 0.8% | 1848.63 ± 0.7% | refused | 738.87 ± 0.5% | 0.93 | 1.00 | 12.55 | 0.53 |

