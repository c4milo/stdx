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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45065559244 |
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
| literal: a word | 217 | 15484.46 ± 0.9% | 1047.31 ± 0.3% | 28.66 ± 0.7% | 18449.85 ± 1.7% | 9201.14 ± 9.5% | 17.40 ± 0.4% | 86.61 ± 0.5% | 15505.69 ± 0.6% | 14.79 | 1.00 | 0.84 | 1.68 |
| literal: a word that is not there | 0 | 18238.48 ± 1.5% | 1056.27 ± 0.2% | 28.62 ± 0.1% | 19618.95 ± 2.1% | 28640.86 ± 3.5% | 17.13 ± 0.3% | 80.93 ± 0.5% | 18229.25 ± 2.3% | 17.27 | 1.00 | 0.93 | 0.64 |
| literal: one of four words | 661 | 5712.73 ± 0.3% | 1026.47 ± 0.1% | 15.03 ± 1.6% | 3981.36 ± 0.2% | 21.89 ± 0.1% | 5.45 ± 0.1% | 6.95 ± 0.3% | 5811.91 ± 0.8% | 5.57 | 0.98 | 1.43 | 260.98 |
| literal: a word in any case | 217 | 11637.97 ± 0.9% | 1045.95 ± 0.2% | 21.98 ± 2.3% | 3980.94 ± 0.2% | 38.66 ± 0.4% | refused | differs | 11623.16 ± 1.7% | 11.13 | 1.00 | 2.92 | 301.05 |
| literal: an href attribute | 33 | 16116.90 ± 1.5% | 1052.56 ± 0.3% | 27.77 ± 0.4% | 16977.06 ± 1.8% | 2271.08 ± 0.4% | 13.14 ± 0.3% | 75.28 ± 0.9% | 16206.62 ± 0.8% | 15.31 | 0.99 | 0.95 | 7.10 |
| literal: a word, second text | 123 | 15622.19 ± 1.1% | 1050.48 ± 0.1% | 28.36 ± 0.6% | 18473.01 ± 2.2% | 7667.71 ± 5.6% | 20.14 ± 0.4% | 71.05 ± 0.2% | 15670.70 ± 1.1% | 14.87 | 1.00 | 0.85 | 2.04 |
| class: two capitalized words | 1331 | 1107.83 ± 0.5% | 964.09 ± 0.1% | 26.53 ± 0.4% | 587.39 ± 0.0% | 40.94 ± 12.9% | 14.76 ± 0.3% | 68.01 ± 0.2% | 1107.17 ± 0.3% | 1.15 | 1.00 | 1.89 | 27.06 |
| class: a word that ends in ing | 3399 | 888.28 ± 0.1% | 889.86 ± 0.1% | 18.66 ± 0.1% | 549.12 ± 0.1% | 29.58 ± 7.9% | 8.21 ± 0.2% | 18.38 ± 0.4% | 887.73 ± 0.2% | 1.00 | 1.00 | 1.62 | 30.03 |
| class: a word in capitals | 2332 | 1463.67 ± 0.6% | 961.24 ± 0.1% | 27.95 ± 0.3% | 574.98 ± 0.2% | 43.81 ± 17.3% | 17.16 ± 0.4% | 83.52 ± 0.3% | 1462.63 ± 0.4% | 1.52 | 1.00 | 2.55 | 33.41 |
| class: a number | 8288 | 2123.59 ± 0.5% | 812.54 ± 0.1% | 28.28 ± 0.3% | 1771.71 ± 0.3% | 43.18 ± 4.0% | 0.55 ± 0.0% | 57.57 ± 0.3% | 2120.15 ± 0.3% | 2.61 | 1.00 | 1.20 | 49.18 |
| class: two capitalized words, second text | 5359 | 700.30 ± 0.1% | 702.23 ± 0.2% | 23.85 ± 0.2% | 488.79 ± 0.1% | 35.64 ± 9.3% | 17.04 ± 0.2% | 63.22 ± 0.3% | 700.84 ± 0.1% | 1.00 | 1.00 | 1.43 | 19.65 |
| other: a word between two words | 6104 | 745.89 ± 0.2% | 722.18 ± 0.2% | 24.01 ± 0.3% | 750.50 ± 0.6% | 112.49 ± 12.6% | 11.20 ± 0.2% | 69.51 ± 1.0% | 738.43 ± 0.3% | 1.03 | 1.01 | 0.99 | 6.63 |
| other: a number before a unit, second text | 1481 | 5325.33 ± 0.7% | 985.03 ± 0.3% | 26.37 ± 0.3% | 5951.64 ± 1.7% | 40.97 ± 0.2% | 18.18 ± 0.1% | 65.90 ± 0.2% | 5308.73 ± 0.5% | 5.41 | 1.00 | 0.89 | 129.98 |
| other: a heading's start tag | 110 | 12444.63 ± 0.6% | 1042.08 ± 0.2% | 27.48 ± 0.3% | 1721.05 ± 0.2% | 1580.06 ± 2.8% | 16.23 ± 0.3% | 87.91 ± 0.3% | 12438.65 ± 0.7% | 11.94 | 1.00 | 7.23 | 7.88 |
| other: a whole word | 217 | 13646.34 ± 0.6% | 1047.44 ± 0.1% | 30.10 ± 0.3% | 14612.62 ± 1.6% | 49.38 ± 0.6% | 13.28 ± 0.3% | 55.61 ± 0.6% | 13671.64 ± 0.4% | 13.03 | 1.00 | 0.93 | 276.35 |
| other: a line's first word, second text | 3716 | 1920.36 ± 0.4% | 863.03 ± 0.2% | 31.80 ± 0.4% | 1757.83 ± 0.2% | 62.63 ± 6.7% | refused | refused | 1914.47 ± 0.8% | 2.23 | 1.00 | 1.09 | 30.66 |
| other: fourteen octets before an x | 87 | 19254.06 ± 1.5% | 1.54 ± 0.6% | 1.53 ± 0.3% | 4056.36 ± 0.4% | 10.68 ± 0.1% | differs | 17.94 ± 0.3% | 19143.08 ± 2.3% | 12515.36 | 1.01 | 4.75 | 1802.49 |
| other: a Greek word | 21815 | 482.25 ± 0.9% | 322.42 ± 0.6% | 31.45 ± 0.2% | 293.98 ± 0.2% | 47.60 ± 14.4% | differs | refused | 480.92 ± 0.7% | 1.50 | 1.00 | 1.64 | 10.13 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 27.91 ± 0.1% | 27.90 ± 0.1% | 0.50 ± 0.4% | 21.09 ± 0.6% | 2.79 ± 0.4% | differs | 4.05 ± 0.2% | 27.91 ± 0.2% | 1.00 | 1.00 | 1.32 | 10.01 |
| a UUID | 32895 | 23.22 ± 0.0% | 23.22 ± 0.2% | 0.67 ± 0.2% | 16.03 ± 0.3% | 3.10 ± 0.1% | 0.71 ± 0.3% | 3.65 ± 0.4% | 23.08 ± 0.8% | 1.00 | 1.01 | 1.45 | 7.49 |
| an IPv4 address | 33176 | 41.44 ± 0.4% | 41.41 ± 0.4% | 2.19 ± 0.2% | 32.77 ± 0.2% | 6.72 ± 0.3% | differs | 4.10 ± 0.2% | 41.41 ± 0.3% | 1.00 | 1.00 | 1.26 | 6.17 |
| a date and time | 32954 | 34.89 ± 0.3% | 34.85 ± 0.4% | 1.52 ± 0.2% | 23.46 ± 0.5% | 7.07 ± 0.3% | 1.21 ± 0.3% | 7.07 ± 0.2% | 34.87 ± 0.2% | 1.00 | 1.00 | 1.49 | 4.93 |
| a field path | 32606 | 32.31 ± 0.3% | 32.31 ± 0.2% | 0.83 ± 0.5% | 25.34 ± 0.3% | 3.51 ± 0.8% | differs | 2.92 ± 0.2% | 32.25 ± 0.1% | 1.00 | 1.00 | 1.28 | 9.20 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.28 ± 0.1% | 10.29 ± 0.3% | 10.29 ± 0.2% | 11.45 ± 0.1% | 4.99 ± 2.2% | 0.91 ± 0.6% | none | 10.28 ± 0.2% | 1.00 | 1.00 | 0.90 | 2.06 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 277.76 ± 0.2% | 278.93 ± 0.2% | 325.59 ± 0.1% | 85.86 ± 0.5% | 222.99 ± 2.8% | 486.91 ± 1.4% | 3766.67 ± 0.2% | 277.45 ± 0.3% | 1.00 | 1.00 | 3.23 | 1.25 |
| a UUID | 62 | 197.98 ± 0.4% | 198.67 ± 0.4% | 224.08 ± 0.2% | 46.08 ± 0.7% | 101.16 ± 0.4% | 188.54 ± 3.2% | 4441.37 ± 0.4% | 198.06 ± 0.3% | 1.00 | 1.00 | 4.30 | 1.96 |
| an IPv4 address | 29 | 479.38 ± 0.4% | 483.40 ± 0.4% | 645.15 ± 0.6% | 76.25 ± 0.4% | 133.99 ± 1.2% | 299.43 ± 1.4% | 7521.09 ± 0.2% | 479.09 ± 0.3% | 0.99 | 1.00 | 6.29 | 3.58 |
| a date and time | 56 | 337.26 ± 0.4% | 339.78 ± 0.2% | 411.98 ± 0.1% | 72.06 ± 0.2% | 139.39 ± 1.4% | 330.28 ± 1.8% | 4939.66 ± 0.4% | 336.76 ± 0.4% | 0.99 | 1.00 | 4.68 | 2.42 |
| a field path | 39 | 286.96 ± 0.4% | 287.98 ± 0.4% | 338.45 ± 0.3% | 80.53 ± 1.4% | 211.11 ± 1.3% | 507.59 ± 2.4% | 4824.77 ± 3.5% | 287.03 ± 0.5% | 1.00 | 1.00 | 3.56 | 1.36 |
| literal: a word | 7 | 760.73 ± 0.3% | 784.57 ± 0.9% | 1310.59 ± 0.1% | 495.65 ± 0.2% | 642.18 ± 2.0% | 961.44 ± 0.4% | 30333.62 ± 0.6% | 760.38 ± 0.3% | 0.97 | 1.00 | 1.53 | 1.18 |
| literal: a word that is not there | 8 | 730.29 ± 0.2% | 753.84 ± 0.7% | 1230.64 ± 0.1% | 459.55 ± 0.2% | 611.68 ± 1.5% | 911.83 ± 0.7% | 29009.31 ± 0.3% | 730.94 ± 0.3% | 0.97 | 1.00 | 1.59 | 1.19 |
| literal: one of four words | 26 | 403.79 ± 0.5% | 439.58 ± 0.7% | 573.46 ± 0.3% | 49.49 ± 1.3% | 246.45 ± 2.4% | 373.37 ± 0.5% | 15591.66 ± 0.2% | 404.15 ± 0.6% | 0.92 | 1.00 | 8.16 | 1.64 |
| literal: a word in any case | 11 | 572.25 ± 0.3% | 589.98 ± 0.9% | 866.97 ± 0.1% | 15.53 ± 0.3% | 665.67 ± 2.6% | refused | 23641.88 ± 0.2% | 572.60 ± 0.2% | 0.97 | 1.00 | 36.84 | 0.86 |
| literal: an href attribute | 12 | 440.79 ± 0.7% | 447.09 ± 0.7% | 583.95 ± 1.0% | 43.24 ± 0.7% | 508.63 ± 2.3% | 769.63 ± 0.7% | 21520.80 ± 0.6% | 441.21 ± 0.6% | 0.99 | 1.00 | 10.19 | 0.87 |
| literal: a word, second text | 10 | 678.11 ± 0.3% | 702.26 ± 0.4% | 1105.47 ± 0.1% | 378.29 ± 0.5% | 553.47 ± 5.7% | 805.18 ± 0.7% | 26940.81 ± 0.4% | 678.64 ± 0.3% | 0.97 | 1.00 | 1.79 | 1.23 |
| class: two capitalized words | 23 | 510.36 ± 0.6% | 527.31 ± 0.5% | 727.38 ± 0.6% | 98.96 ± 0.2% | 511.08 ± 1.4% | 748.53 ± 2.1% | 6290.24 ± 0.1% | 509.44 ± 0.4% | 0.97 | 1.00 | 5.16 | 1.00 |
| class: a word that ends in ing | 9 | 709.78 ± 0.5% | 755.78 ± 0.4% | 1230.42 ± 0.3% | 129.88 ± 0.5% | 762.56 ± 2.5% | 1103.04 ± 0.5% | 15678.97 ± 0.2% | 710.49 ± 0.5% | 0.94 | 1.00 | 5.46 | 0.93 |
| class: a word in capitals | 16 | 603.87 ± 0.3% | 632.64 ± 0.5% | 931.31 ± 0.1% | 133.33 ± 0.6% | 758.35 ± 0.9% | 1019.90 ± 0.9% | 8310.76 ± 0.1% | 604.23 ± 0.5% | 0.95 | 1.00 | 4.53 | 0.80 |
| class: a number | 6 | 795.96 ± 0.4% | 839.34 ± 0.2% | 1453.31 ± 0.1% | 41.62 ± 0.5% | 1419.52 ± 2.0% | 1858.03 ± 1.2% | 22640.97 ± 0.4% | 796.35 ± 0.2% | 0.95 | 1.00 | 19.12 | 0.56 |
| class: two capitalized words, second text | 23 | 510.40 ± 0.5% | 528.06 ± 0.4% | 728.75 ± 0.4% | 100.51 ± 0.8% | 511.39 ± 0.7% | 740.98 ± 0.5% | 6282.19 ± 0.3% | 510.63 ± 0.2% | 0.97 | 1.00 | 5.08 | 1.00 |
| other: a word between two words | 13 | 647.67 ± 0.4% | 655.20 ± 0.6% | 991.25 ± 0.4% | 131.25 ± 0.3% | 511.13 ± 1.3% | 807.67 ± 0.5% | 14638.02 ± 0.3% | 648.17 ± 0.3% | 0.99 | 1.00 | 4.93 | 1.27 |
| other: a number before a unit, second text | 15 | 520.88 ± 0.4% | 555.23 ± 0.3% | 781.91 ± 0.4% | 39.15 ± 0.5% | 644.14 ± 0.4% | 892.21 ± 0.3% | 15045.39 ± 0.2% | 521.21 ± 0.4% | 0.94 | 1.00 | 13.31 | 0.81 |
| other: a heading's start tag | 13 | 442.50 ± 0.3% | 446.61 ± 0.2% | 587.66 ± 1.0% | 42.91 ± 0.4% | 645.69 ± 1.9% | 879.48 ± 0.2% | 18013.28 ± 0.1% | 442.38 ± 0.5% | 0.99 | 1.00 | 10.31 | 0.69 |
| other: a whole word | 11 | 706.78 ± 0.2% | 720.45 ± 0.2% | 1146.14 ± 0.5% | 116.63 ± 0.6% | 569.96 ± 2.2% | 833.09 ± 0.9% | 26710.84 ± 0.6% | 708.30 ± 0.4% | 0.98 | 1.00 | 6.06 | 1.24 |
| other: a line's first word, second text | 17 | 639.33 ± 0.2% | 664.17 ± 0.5% | 1000.87 ± 0.1% | 127.98 ± 0.7% | 719.86 ± 1.3% | refused | refused | 637.49 ± 0.7% | 0.96 | 1.00 | 5.00 | 0.89 |
| other: fourteen octets before an x | 16 | 121.28 ± 0.7% | 164.89 ± 1.1% | 190.75 ± 1.1% | 14.88 ± 0.2% | 460.34 ± 1.9% | 413.23 ± 0.7% | 12769.65 ± 0.4% | 121.26 ± 0.8% | 0.74 | 1.00 | 8.15 | 0.26 |
| other: a Greek word | 8 | 738.67 ± 0.4% | 793.33 ± 0.4% | 1316.56 ± 0.8% | 58.32 ± 0.4% | 1400.78 ± 1.4% | 1857.34 ± 0.4% | refused | 737.76 ± 0.4% | 0.93 | 1.00 | 12.66 | 0.53 |

