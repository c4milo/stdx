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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063422460 |
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
| literal: a word | 217 | 15336.12 ± 1.5% | 1048.33 ± 0.1% | 28.73 ± 0.4% | 18182.91 ± 2.5% | 9129.33 ± 7.6% | 17.42 ± 0.2% | 86.60 ± 0.4% | 15269.14 ± 1.0% | 14.63 | 1.00 | 0.84 | 1.68 |
| literal: a word that is not there | 0 | 17801.32 ± 4.2% | 1055.68 ± 0.2% | 28.66 ± 0.8% | 19203.82 ± 4.7% | 26820.77 ± 4.5% | 17.15 ± 0.2% | 81.01 ± 0.4% | 17756.62 ± 3.4% | 16.86 | 1.00 | 0.93 | 0.66 |
| literal: one of four words | 661 | 5824.92 ± 0.7% | 1025.31 ± 0.3% | 15.03 ± 0.9% | 3977.10 ± 0.5% | 21.50 ± 0.4% | 5.45 ± 0.3% | 6.94 ± 0.1% | 5815.15 ± 0.2% | 5.68 | 1.00 | 1.46 | 270.98 |
| literal: a word in any case | 217 | 11663.63 ± 0.6% | 1046.43 ± 0.1% | 21.52 ± 0.6% | 3983.29 ± 0.5% | 38.65 ± 0.4% | refused | differs | 11638.66 ± 0.3% | 11.15 | 1.00 | 2.93 | 301.79 |
| literal: an href attribute | 33 | 15941.24 ± 1.6% | 1053.20 ± 0.1% | 27.81 ± 0.4% | 16675.31 ± 1.4% | 2264.77 ± 0.6% | 13.19 ± 0.2% | 75.89 ± 0.4% | 15954.33 ± 2.2% | 15.14 | 1.00 | 0.96 | 7.04 |
| literal: a word, second text | 123 | 15453.03 ± 1.3% | 1050.84 ± 0.1% | 28.33 ± 0.3% | 18257.05 ± 3.1% | 7491.75 ± 6.1% | 20.15 ± 0.6% | 70.97 ± 0.5% | 15427.33 ± 1.6% | 14.71 | 1.00 | 0.85 | 2.06 |
| class: two capitalized words | 1331 | 1109.74 ± 0.6% | 963.73 ± 0.2% | 26.51 ± 0.3% | 587.33 ± 0.1% | 40.79 ± 3.4% | 14.77 ± 0.3% | 68.08 ± 0.4% | 1110.01 ± 0.7% | 1.15 | 1.00 | 1.89 | 27.21 |
| class: a word that ends in ing | 3399 | 888.09 ± 0.2% | 889.44 ± 0.1% | 18.66 ± 1.2% | 550.09 ± 0.1% | 29.43 ± 12.0% | 8.19 ± 0.3% | 18.37 ± 0.4% | 884.03 ± 0.1% | 1.00 | 1.00 | 1.61 | 30.17 |
| class: a word in capitals | 2332 | 1461.39 ± 0.6% | 960.99 ± 0.1% | 27.90 ± 0.4% | 575.25 ± 0.1% | 43.71 ± 15.9% | 17.09 ± 0.5% | 83.57 ± 0.3% | 1461.67 ± 0.5% | 1.52 | 1.00 | 2.54 | 33.43 |
| class: a number | 8288 | 2121.02 ± 0.4% | 812.41 ± 0.1% | 28.24 ± 0.1% | 1795.26 ± 0.1% | 42.18 ± 16.3% | 0.55 ± 0.1% | 57.66 ± 0.1% | 2117.16 ± 0.2% | 2.61 | 1.00 | 1.18 | 50.28 |
| class: two capitalized words, second text | 5359 | 701.45 ± 0.4% | 702.06 ± 0.2% | 23.86 ± 0.2% | 488.89 ± 0.2% | 35.23 ± 14.2% | 17.08 ± 0.2% | 63.35 ± 0.3% | 701.03 ± 0.1% | 1.00 | 1.00 | 1.43 | 19.91 |
| other: a word between two words | 6104 | 747.67 ± 0.2% | 754.42 ± 0.1% | 24.06 ± 0.3% | 752.15 ± 0.3% | 109.80 ± 21.1% | 11.17 ± 0.1% | 69.67 ± 0.3% | 747.28 ± 0.1% | 0.99 | 1.00 | 0.99 | 6.81 |
| other: a number before a unit, second text | 1481 | 5301.02 ± 0.6% | 984.52 ± 0.1% | 26.42 ± 0.1% | 5873.75 ± 1.9% | 40.80 ± 0.4% | 18.17 ± 0.1% | 65.83 ± 0.2% | 5290.95 ± 0.8% | 5.38 | 1.00 | 0.90 | 129.94 |
| other: a heading's start tag | 110 | 12349.54 ± 1.7% | 1041.56 ± 0.1% | 27.50 ± 0.2% | 1722.14 ± 0.1% | 1588.21 ± 5.0% | 16.24 ± 0.8% | 87.90 ± 2.3% | 12319.57 ± 1.7% | 11.86 | 1.00 | 7.17 | 7.78 |
| other: a whole word | 217 | 13488.81 ± 1.4% | 1047.05 ± 0.1% | 30.16 ± 0.3% | 14536.86 ± 2.5% | 49.15 ± 0.3% | 13.29 ± 0.1% | 55.67 ± 0.3% | 13482.10 ± 1.6% | 12.88 | 1.00 | 0.93 | 274.44 |
| other: a line's first word, second text | 3716 | 1927.00 ± 0.2% | 868.10 ± 0.1% | 31.74 ± 0.3% | 1756.70 ± 0.5% | 62.82 ± 6.4% | refused | refused | 1912.48 ± 0.5% | 2.22 | 1.01 | 1.10 | 30.68 |
| other: fourteen octets before an x | 87 | 18613.73 ± 1.8% | 1.54 ± 0.4% | 1.54 ± 0.8% | 3978.58 ± 0.4% | 10.65 ± 0.1% | differs | 17.92 ± 0.2% | 18572.81 ± 0.9% | 12110.89 | 1.00 | 4.68 | 1747.35 |
| other: a Greek word | 21815 | 481.57 ± 0.6% | 322.89 ± 0.4% | 31.51 ± 0.3% | 293.88 ± 0.2% | 47.54 ± 16.3% | differs | refused | 480.41 ± 0.5% | 1.49 | 1.00 | 1.64 | 10.13 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.95 ± 0.1% | 27.92 ± 0.2% | 0.50 ± 0.1% | 21.58 ± 0.3% | 2.78 ± 0.5% | differs | 4.04 ± 0.2% | 27.93 ± 0.2% | 1.00 | 1.00 | 1.29 | 10.05 |
| a UUID | 32895 | 23.24 ± 0.1% | 22.89 ± 0.1% | 0.67 ± 0.2% | 16.05 ± 0.2% | 3.10 ± 0.6% | 0.73 ± 0.1% | 3.65 ± 0.4% | 23.25 ± 0.1% | 1.02 | 1.00 | 1.45 | 7.50 |
| an IPv4 address | 33176 | 41.52 ± 0.4% | 41.50 ± 0.4% | 2.18 ± 0.2% | 32.82 ± 0.2% | 6.71 ± 0.3% | differs | 4.10 ± 0.1% | 41.51 ± 0.2% | 1.00 | 1.00 | 1.26 | 6.19 |
| a date and time | 32954 | 34.88 ± 0.4% | 34.90 ± 0.2% | 1.51 ± 0.2% | 23.50 ± 0.5% | 7.08 ± 0.1% | 1.25 ± 0.4% | 7.07 ± 0.3% | 34.89 ± 0.3% | 1.00 | 1.00 | 1.48 | 4.93 |
| a field path | 32606 | 32.33 ± 0.5% | 32.33 ± 0.3% | 0.83 ± 0.2% | 25.36 ± 0.4% | 3.52 ± 1.7% | differs | 2.92 ± 0.2% | 32.25 ± 0.3% | 1.00 | 1.00 | 1.27 | 9.19 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.30 ± 0.2% | 10.29 ± 0.1% | 10.30 ± 0.2% | 11.46 ± 0.1% | 5.00 ± 2.2% | 0.93 ± 0.4% | none | 10.28 ± 0.1% | 1.00 | 1.00 | 0.90 | 2.06 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 277.92 ± 1.2% | 278.86 ± 0.9% | 325.37 ± 0.9% | 85.08 ± 0.5% | 222.79 ± 1.2% | 486.90 ± 1.1% | 3767.40 ± 0.5% | 277.88 ± 1.2% | 1.00 | 1.00 | 3.27 | 1.25 |
| a UUID | 62 | 198.89 ± 0.3% | 198.83 ± 0.5% | 224.33 ± 0.4% | 45.89 ± 0.6% | 99.61 ± 1.6% | 188.86 ± 3.2% | 4448.33 ± 0.6% | 198.85 ± 0.3% | 1.00 | 1.00 | 4.33 | 2.00 |
| an IPv4 address | 29 | 479.71 ± 0.4% | 483.95 ± 0.5% | 646.07 ± 0.5% | 75.83 ± 0.7% | 132.40 ± 1.2% | 299.38 ± 1.4% | 7522.52 ± 0.3% | 479.35 ± 0.5% | 0.99 | 1.00 | 6.33 | 3.62 |
| a date and time | 56 | 337.36 ± 0.3% | 339.45 ± 0.3% | 411.38 ± 0.3% | 71.53 ± 0.1% | 138.54 ± 1.2% | 329.68 ± 2.0% | 4931.89 ± 0.5% | 336.97 ± 0.2% | 0.99 | 1.00 | 4.72 | 2.44 |
| a field path | 39 | 286.80 ± 0.3% | 287.34 ± 0.4% | 338.17 ± 0.7% | 80.13 ± 1.5% | 207.10 ± 1.8% | 507.77 ± 2.3% | 4822.62 ± 3.4% | 286.62 ± 0.7% | 1.00 | 1.00 | 3.58 | 1.38 |
| literal: a word | 7 | 761.16 ± 0.4% | 785.47 ± 0.4% | 1309.87 ± 0.3% | 492.72 ± 0.3% | 637.11 ± 3.0% | 959.42 ± 1.1% | 30325.79 ± 0.2% | 762.21 ± 0.4% | 0.97 | 1.00 | 1.54 | 1.19 |
| literal: a word that is not there | 8 | 731.68 ± 0.4% | 754.11 ± 0.2% | 1229.98 ± 0.2% | 458.95 ± 0.2% | 612.16 ± 1.4% | 909.34 ± 0.4% | 29041.69 ± 0.2% | 732.03 ± 0.2% | 0.97 | 1.00 | 1.59 | 1.20 |
| literal: one of four words | 26 | 404.22 ± 0.5% | 440.01 ± 0.4% | 572.94 ± 0.5% | 49.37 ± 1.7% | 243.36 ± 1.9% | 374.74 ± 0.9% | 15590.99 ± 0.2% | 404.41 ± 0.2% | 0.92 | 1.00 | 8.19 | 1.66 |
| literal: a word in any case | 11 | 573.54 ± 0.2% | 590.10 ± 0.4% | 867.78 ± 0.1% | 15.49 ± 0.4% | 663.00 ± 4.1% | refused | 23613.68 ± 0.3% | 573.25 ± 0.2% | 0.97 | 1.00 | 37.03 | 0.87 |
| literal: an href attribute | 12 | 441.78 ± 0.5% | 447.10 ± 0.2% | 585.87 ± 0.4% | 44.26 ± 0.4% | 507.80 ± 1.2% | 767.80 ± 0.5% | 21565.54 ± 0.1% | 442.19 ± 0.5% | 0.99 | 1.00 | 9.98 | 0.87 |
| literal: a word, second text | 10 | 678.69 ± 0.4% | 702.74 ± 0.3% | 1105.14 ± 0.1% | 378.31 ± 0.3% | 546.27 ± 1.2% | 803.68 ± 0.7% | 26947.86 ± 0.2% | 678.75 ± 0.2% | 0.97 | 1.00 | 1.79 | 1.24 |
| class: two capitalized words | 23 | 510.29 ± 0.4% | 528.35 ± 0.1% | 727.28 ± 0.6% | 98.64 ± 0.2% | 510.14 ± 0.8% | 750.72 ± 2.2% | 6286.85 ± 0.2% | 510.86 ± 0.1% | 0.97 | 1.00 | 5.17 | 1.00 |
| class: a word that ends in ing | 9 | 709.81 ± 0.4% | 757.28 ± 0.6% | 1229.32 ± 0.1% | 129.66 ± 0.3% | 765.71 ± 1.0% | 1102.04 ± 0.7% | 15674.79 ± 0.2% | 711.51 ± 0.5% | 0.94 | 1.00 | 5.47 | 0.93 |
| class: a word in capitals | 16 | 603.90 ± 0.3% | 632.00 ± 1.0% | 930.71 ± 0.2% | 132.76 ± 0.5% | 754.14 ± 4.9% | 1020.10 ± 0.8% | 8307.12 ± 0.2% | 604.22 ± 0.1% | 0.96 | 1.00 | 4.55 | 0.80 |
| class: a number | 6 | 797.37 ± 0.6% | 838.62 ± 0.6% | 1453.09 ± 0.0% | 41.66 ± 0.6% | 1405.02 ± 0.8% | 1851.52 ± 1.5% | 22638.47 ± 0.1% | 797.21 ± 0.2% | 0.95 | 1.00 | 19.14 | 0.57 |
| class: two capitalized words, second text | 23 | 510.13 ± 1.0% | 529.58 ± 0.5% | 728.84 ± 0.8% | 99.93 ± 0.9% | 505.04 ± 0.8% | 741.08 ± 0.5% | 6289.17 ± 0.2% | 510.54 ± 0.6% | 0.96 | 1.00 | 5.10 | 1.01 |
| other: a word between two words | 13 | 647.38 ± 0.2% | 656.18 ± 0.8% | 991.54 ± 0.3% | 130.26 ± 0.3% | 511.25 ± 1.8% | 806.64 ± 0.4% | 14633.77 ± 0.4% | 648.09 ± 0.4% | 0.99 | 1.00 | 4.97 | 1.27 |
| other: a number before a unit, second text | 15 | 521.49 ± 0.2% | 555.35 ± 0.2% | 780.91 ± 0.5% | 39.07 ± 0.6% | 642.67 ± 1.0% | 889.72 ± 0.1% | 15051.30 ± 0.1% | 521.01 ± 0.4% | 0.94 | 1.00 | 13.35 | 0.81 |
| other: a heading's start tag | 13 | 442.19 ± 0.3% | 446.28 ± 0.7% | 586.21 ± 0.5% | 43.45 ± 0.4% | 642.84 ± 0.6% | 875.53 ± 0.2% | 18016.84 ± 0.2% | 442.92 ± 0.3% | 0.99 | 1.00 | 10.18 | 0.69 |
| other: a whole word | 11 | 707.52 ± 0.3% | 721.96 ± 0.4% | 1146.80 ± 0.4% | 116.34 ± 0.3% | 568.26 ± 2.0% | 835.53 ± 0.8% | 26695.26 ± 1.2% | 708.86 ± 0.5% | 0.98 | 1.00 | 6.08 | 1.25 |
| other: a line's first word, second text | 17 | 641.35 ± 0.4% | 665.64 ± 0.3% | 999.95 ± 0.5% | 127.10 ± 0.4% | 713.64 ± 5.8% | refused | refused | 638.43 ± 0.6% | 0.96 | 1.00 | 5.05 | 0.90 |
| other: fourteen octets before an x | 16 | 121.42 ± 0.9% | 164.84 ± 0.5% | 190.10 ± 0.7% | 14.94 ± 0.2% | 457.06 ± 1.9% | 412.45 ± 1.1% | 12784.27 ± 0.2% | 121.14 ± 0.8% | 0.74 | 1.00 | 8.13 | 0.27 |
| other: a Greek word | 8 | 739.44 ± 0.6% | 793.84 ± 0.4% | 1317.06 ± 0.1% | 58.82 ± 0.4% | 1393.40 ± 1.9% | 1851.60 ± 0.5% | refused | 739.01 ± 0.6% | 0.93 | 1.00 | 12.57 | 0.53 |

