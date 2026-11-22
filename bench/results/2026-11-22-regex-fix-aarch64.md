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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063408652 |
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
| literal: a word | 217 | 15447.26 ± 0.3% | 1049.08 ± 0.2% | 28.70 ± 0.7% | 18225.60 ± 2.7% | 9180.49 ± 6.9% | 17.40 ± 0.3% | 86.68 ± 0.4% | 15472.89 ± 0.8% | 14.72 | 1.00 | 0.85 | 1.68 |
| literal: a word that is not there | 0 | 18052.89 ± 1.7% | 1056.45 ± 0.2% | 28.62 ± 0.3% | 19352.21 ± 1.3% | 27485.82 ± 4.6% | 17.12 ± 0.6% | 81.07 ± 0.2% | 18181.59 ± 2.4% | 17.09 | 0.99 | 0.93 | 0.66 |
| literal: one of four words | 661 | 5837.62 ± 0.4% | 1026.17 ± 0.2% | 15.04 ± 0.4% | 3987.63 ± 0.3% | 21.90 ± 0.1% | 5.41 ± 0.1% | 6.93 ± 0.4% | 5823.56 ± 0.6% | 5.69 | 1.00 | 1.46 | 266.62 |
| literal: a word in any case | 217 | 11698.54 ± 0.3% | 1046.25 ± 0.1% | 22.01 ± 1.7% | 3988.78 ± 0.1% | 38.74 ± 1.1% | refused | differs | 11673.38 ± 0.5% | 11.18 | 1.00 | 2.93 | 301.95 |
| literal: an href attribute | 33 | 15945.68 ± 0.4% | 1054.17 ± 0.1% | 27.73 ± 0.3% | 16622.62 ± 1.7% | 2269.27 ± 0.4% | 13.13 ± 0.2% | 75.80 ± 0.2% | 15975.10 ± 0.5% | 15.13 | 1.00 | 0.96 | 7.03 |
| literal: a word, second text | 123 | 15650.61 ± 0.9% | 1052.05 ± 0.2% | 28.37 ± 0.3% | 18366.66 ± 2.3% | 7667.96 ± 7.0% | 20.14 ± 0.3% | 71.19 ± 0.4% | 15710.94 ± 1.7% | 14.88 | 1.00 | 0.85 | 2.04 |
| class: two capitalized words | 1331 | 1109.31 ± 0.2% | 963.65 ± 0.1% | 26.51 ± 0.4% | 587.31 ± 0.0% | 40.97 ± 8.3% | 14.72 ± 0.1% | 68.17 ± 0.4% | 1108.36 ± 0.4% | 1.15 | 1.00 | 1.89 | 27.08 |
| class: a word that ends in ing | 3399 | 888.32 ± 0.2% | 890.39 ± 0.1% | 18.66 ± 0.3% | 550.38 ± 0.1% | 29.59 ± 9.3% | 8.18 ± 0.2% | 18.38 ± 0.2% | 888.20 ± 0.1% | 1.00 | 1.00 | 1.61 | 30.02 |
| class: a word in capitals | 2332 | 1461.63 ± 0.6% | 961.30 ± 0.1% | 28.00 ± 0.4% | 575.30 ± 0.1% | 43.94 ± 14.4% | 17.11 ± 0.4% | 83.52 ± 0.2% | 1461.38 ± 0.5% | 1.52 | 1.00 | 2.54 | 33.27 |
| class: a number | 8288 | 2122.80 ± 0.5% | 812.99 ± 0.1% | 28.19 ± 0.5% | 1796.14 ± 0.2% | 39.99 ± 16.6% | 0.55 ± 0.1% | 57.64 ± 0.3% | 2120.07 ± 0.4% | 2.61 | 1.00 | 1.18 | 53.08 |
| class: two capitalized words, second text | 5359 | 701.36 ± 0.2% | 702.18 ± 0.1% | 23.86 ± 0.3% | 489.31 ± 0.1% | 35.58 ± 10.8% | 17.11 ± 0.2% | 63.35 ± 0.1% | 701.44 ± 0.1% | 1.00 | 1.00 | 1.43 | 19.71 |
| other: a word between two words | 6104 | 748.17 ± 0.1% | 755.49 ± 0.1% | 24.06 ± 0.2% | 750.83 ± 0.7% | 106.55 ± 10.4% | 11.18 ± 0.0% | 69.64 ± 0.4% | 747.93 ± 0.1% | 0.99 | 1.00 | 1.00 | 7.02 |
| other: a number before a unit, second text | 1481 | 5314.77 ± 0.4% | 985.63 ± 0.1% | 26.42 ± 0.3% | 5938.55 ± 0.7% | 40.99 ± 16.4% | 18.20 ± 0.2% | 65.91 ± 0.1% | 5301.12 ± 0.6% | 5.39 | 1.00 | 0.89 | 129.67 |
| other: a heading's start tag | 110 | 12400.34 ± 0.5% | 1041.93 ± 0.1% | 27.54 ± 0.4% | 1721.05 ± 0.3% | 1585.14 ± 7.9% | 16.18 ± 0.4% | 88.04 ± 0.3% | 12391.58 ± 0.4% | 11.90 | 1.00 | 7.21 | 7.82 |
| other: a whole word | 217 | 13598.86 ± 0.7% | 1048.14 ± 0.1% | 30.15 ± 0.2% | 14443.05 ± 1.7% | 49.43 ± 0.2% | 13.26 ± 0.1% | 55.68 ± 1.0% | 13600.30 ± 0.8% | 12.97 | 1.00 | 0.94 | 275.11 |
| other: a line's first word, second text | 3716 | 1926.49 ± 0.4% | 869.34 ± 0.1% | 31.80 ± 0.3% | 1763.84 ± 0.4% | 62.65 ± 4.3% | refused | refused | 1919.08 ± 0.2% | 2.22 | 1.00 | 1.09 | 30.75 |
| other: fourteen octets before an x | 87 | 18696.51 ± 2.3% | 1.54 ± 0.5% | 1.54 ± 0.1% | 4012.08 ± 0.4% | 10.68 ± 0.2% | differs | 17.94 ± 0.1% | 18619.27 ± 0.4% | 12146.72 | 1.00 | 4.66 | 1750.63 |
| other: a Greek word | 21815 | 481.85 ± 0.9% | 323.06 ± 0.4% | 31.52 ± 0.2% | 294.29 ± 0.1% | 49.58 ± 11.7% | differs | refused | 481.79 ± 0.5% | 1.49 | 1.00 | 1.64 | 9.72 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.99 ± 0.1% | 27.97 ± 0.1% | 0.50 ± 0.3% | 21.57 ± 0.1% | 2.77 ± 0.3% | differs | 4.05 ± 0.1% | 27.97 ± 0.1% | 1.00 | 1.00 | 1.30 | 10.10 |
| a UUID | 32895 | 23.22 ± 0.2% | 23.23 ± 0.2% | 0.67 ± 0.1% | 16.05 ± 0.1% | 3.11 ± 0.1% | 0.73 ± 0.3% | 3.65 ± 0.5% | 23.26 ± 0.2% | 1.00 | 1.00 | 1.45 | 7.47 |
| an IPv4 address | 33176 | 41.51 ± 0.2% | 41.49 ± 0.2% | 2.18 ± 0.3% | 32.81 ± 0.2% | 6.69 ± 0.2% | differs | 4.10 ± 0.1% | 41.52 ± 0.1% | 1.00 | 1.00 | 1.27 | 6.20 |
| a date and time | 32954 | 34.88 ± 0.2% | 34.92 ± 0.2% | 1.52 ± 0.7% | 23.42 ± 0.5% | 7.09 ± 0.3% | 1.25 ± 0.4% | 7.07 ± 0.2% | 34.89 ± 0.2% | 1.00 | 1.00 | 1.49 | 4.92 |
| a field path | 32606 | 32.29 ± 0.2% | 32.29 ± 0.4% | 0.83 ± 0.6% | 25.34 ± 0.4% | 3.50 ± 1.0% | differs | 2.92 ± 0.1% | 32.24 ± 0.2% | 1.00 | 1.00 | 1.27 | 9.22 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.29 ± 0.3% | 10.29 ± 0.2% | 10.29 ± 0.2% | 11.49 ± 0.2% | 4.99 ± 2.0% | 0.93 ± 0.4% | none | 10.28 ± 0.3% | 1.00 | 1.00 | 0.89 | 2.06 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 277.95 ± 0.2% | 279.16 ± 0.1% | 325.26 ± 0.2% | 86.24 ± 0.1% | 225.28 ± 0.6% | 490.82 ± 0.9% | 3763.88 ± 0.2% | 277.84 ± 0.1% | 1.00 | 1.00 | 3.22 | 1.23 |
| a UUID | 62 | 198.61 ± 0.3% | 198.83 ± 0.3% | 224.32 ± 0.3% | 45.43 ± 0.2% | 100.40 ± 1.1% | 182.18 ± 0.8% | 4431.36 ± 0.4% | 198.44 ± 0.2% | 1.00 | 1.00 | 4.37 | 1.98 |
| an IPv4 address | 29 | 479.92 ± 0.2% | 483.74 ± 0.8% | 644.82 ± 0.6% | 76.02 ± 0.9% | 133.49 ± 0.8% | 290.72 ± 0.6% | 7518.11 ± 0.4% | 479.38 ± 0.4% | 0.99 | 1.00 | 6.31 | 3.60 |
| a date and time | 56 | 337.33 ± 0.3% | 339.77 ± 0.3% | 411.30 ± 0.2% | 71.55 ± 0.3% | 138.98 ± 0.7% | 322.14 ± 0.6% | 4940.16 ± 0.2% | 336.88 ± 0.2% | 0.99 | 1.00 | 4.71 | 2.43 |
| a field path | 39 | 286.30 ± 0.8% | 287.45 ± 0.4% | 337.83 ± 0.4% | 79.23 ± 0.5% | 209.20 ± 1.4% | 492.14 ± 0.7% | 4832.44 ± 0.4% | 286.48 ± 0.4% | 1.00 | 1.00 | 3.61 | 1.37 |
| literal: a word | 7 | 760.98 ± 0.2% | 785.24 ± 0.3% | 1309.03 ± 0.1% | 499.15 ± 1.5% | 643.48 ± 1.7% | 930.79 ± 0.6% | 30312.86 ± 0.4% | 761.55 ± 0.1% | 0.97 | 1.00 | 1.52 | 1.18 |
| literal: a word that is not there | 8 | 730.76 ± 0.4% | 755.13 ± 0.2% | 1230.22 ± 0.1% | 458.02 ± 0.4% | 613.96 ± 1.3% | 885.58 ± 0.3% | 29069.47 ± 0.5% | 731.22 ± 0.3% | 0.97 | 1.00 | 1.60 | 1.19 |
| literal: one of four words | 26 | 404.68 ± 0.2% | 440.75 ± 0.3% | 574.08 ± 0.2% | 48.76 ± 0.3% | 245.81 ± 2.4% | 360.98 ± 0.4% | 15601.57 ± 0.3% | 404.74 ± 0.6% | 0.92 | 1.00 | 8.30 | 1.65 |
| literal: a word in any case | 11 | 572.93 ± 0.1% | 590.41 ± 0.7% | 868.15 ± 0.2% | 15.64 ± 0.8% | 668.27 ± 1.1% | refused | 23623.71 ± 0.1% | 573.28 ± 0.3% | 0.97 | 1.00 | 36.63 | 0.86 |
| literal: an href attribute | 12 | 441.57 ± 0.7% | 447.75 ± 0.4% | 585.13 ± 0.7% | 13.39 ± 11.1% | 512.87 ± 0.8% | 764.72 ± 2.8% | 21549.49 ± 0.1% | 442.23 ± 0.6% | 0.99 | 1.00 | 32.98 | 0.86 |
| literal: a word, second text | 10 | 678.05 ± 0.2% | 702.09 ± 0.3% | 1105.34 ± 0.1% | 407.75 ± 0.1% | 550.54 ± 1.8% | 806.34 ± 0.4% | 26911.53 ± 1.3% | 678.07 ± 0.1% | 0.97 | 1.00 | 1.66 | 1.23 |
| class: two capitalized words | 23 | 510.11 ± 0.5% | 528.90 ± 0.4% | 728.03 ± 0.3% | 99.64 ± 0.2% | 512.00 ± 1.5% | 744.20 ± 0.5% | 6287.84 ± 0.3% | 509.54 ± 0.4% | 0.96 | 1.00 | 5.12 | 1.00 |
| class: a word that ends in ing | 9 | 709.51 ± 0.6% | 755.82 ± 0.2% | 1229.36 ± 0.1% | 131.18 ± 1.0% | 768.18 ± 1.1% | 1097.25 ± 2.3% | 15680.03 ± 0.1% | 710.54 ± 0.3% | 0.94 | 1.00 | 5.41 | 0.92 |
| class: a word in capitals | 16 | 603.92 ± 0.3% | 631.54 ± 0.4% | 930.70 ± 0.2% | 134.12 ± 0.8% | 763.68 ± 0.8% | 1018.32 ± 2.7% | 8311.74 ± 0.1% | 603.88 ± 0.6% | 0.96 | 1.00 | 4.50 | 0.79 |
| class: a number | 6 | 795.97 ± 0.2% | 839.52 ± 0.7% | 1452.27 ± 0.1% | 41.76 ± 0.8% | 1416.43 ± 1.6% | 1859.22 ± 1.0% | 22631.47 ± 0.3% | 796.45 ± 0.3% | 0.95 | 1.00 | 19.06 | 0.56 |
| class: two capitalized words, second text | 23 | 510.02 ± 0.3% | 528.30 ± 0.6% | 727.22 ± 0.3% | 101.28 ± 0.5% | 512.43 ± 1.3% | 740.71 ± 0.5% | 6291.41 ± 0.2% | 510.04 ± 0.3% | 0.97 | 1.00 | 5.04 | 1.00 |
| other: a word between two words | 13 | 646.67 ± 0.6% | 656.43 ± 0.3% | 991.73 ± 0.1% | 134.06 ± 0.6% | 515.32 ± 0.8% | 817.81 ± 0.7% | 14644.82 ± 0.1% | 648.30 ± 0.4% | 0.99 | 1.00 | 4.82 | 1.25 |
| other: a number before a unit, second text | 15 | 521.79 ± 0.2% | 554.71 ± 0.4% | 781.19 ± 0.0% | 39.38 ± 0.7% | 645.84 ± 3.0% | 895.79 ± 0.4% | 15044.40 ± 0.2% | 522.17 ± 0.4% | 0.94 | 1.00 | 13.25 | 0.81 |
| other: a heading's start tag | 13 | 442.09 ± 0.5% | 446.47 ± 0.4% | 586.18 ± 0.4% | 13.20 ± 20.9% | 645.61 ± 1.3% | 871.75 ± 0.9% | 18019.11 ± 0.1% | 442.52 ± 0.3% | 0.99 | 1.00 | 33.50 | 0.68 |
| other: a whole word | 11 | 707.92 ± 0.3% | 720.95 ± 0.7% | 1145.85 ± 0.3% | 119.18 ± 0.4% | 574.12 ± 1.0% | 820.49 ± 0.6% | 26741.89 ± 1.0% | 708.05 ± 0.5% | 0.98 | 1.00 | 5.94 | 1.23 |
| other: a line's first word, second text | 17 | 641.09 ± 0.7% | 665.83 ± 0.3% | 1000.55 ± 0.1% | 126.49 ± 0.7% | 723.15 ± 1.0% | refused | refused | 637.51 ± 0.5% | 0.96 | 1.01 | 5.07 | 0.89 |
| other: fourteen octets before an x | 16 | 121.25 ± 0.6% | 164.64 ± 1.0% | 190.23 ± 1.3% | 8.06 ± 12.0% | 461.28 ± 1.2% | 410.33 ± 0.8% | 12783.05 ± 0.4% | 121.17 ± 0.7% | 0.74 | 1.00 | 15.04 | 0.26 |
| other: a Greek word | 8 | 739.16 ± 0.7% | 792.89 ± 0.3% | 1317.05 ± 0.2% | 14.00 ± 25.5% | 1407.94 ± 1.4% | 1785.38 ± 0.5% | refused | 739.79 ± 0.5% | 0.93 | 1.00 | 52.81 | 0.52 |

