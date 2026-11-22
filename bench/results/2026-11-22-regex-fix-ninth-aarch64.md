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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063442063 |
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
| literal: a word | 217 | 15210.12 ± 1.8% | 1048.01 ± 0.2% | 28.71 ± 0.3% | 17779.92 ± 2.9% | 9022.00 ± 7.7% | 17.39 ± 0.4% | 87.09 ± 0.8% | 15229.37 ± 1.0% | 14.51 | 1.00 | 0.86 | 1.69 |
| literal: a word that is not there | 0 | 18000.64 ± 2.8% | 1054.40 ± 0.6% | 27.74 ± 0.3% | 19224.58 ± 4.1% | 28007.72 ± 3.9% | 17.18 ± 0.3% | 81.19 ± 0.7% | 17960.78 ± 2.2% | 17.07 | 1.00 | 0.94 | 0.64 |
| literal: one of four words | 661 | 5800.53 ± 0.5% | 1025.48 ± 0.1% | 15.00 ± 0.2% | 3975.14 ± 0.2% | 21.90 ± 0.1% | 5.25 ± 0.2% | 6.95 ± 0.3% | 5798.73 ± 0.4% | 5.66 | 1.00 | 1.46 | 264.85 |
| literal: a word in any case | 217 | 11628.80 ± 0.9% | 1044.65 ± 0.1% | 22.09 ± 1.8% | 3979.05 ± 0.2% | 38.66 ± 0.5% | refused | differs | 11612.59 ± 0.2% | 11.13 | 1.00 | 2.92 | 300.81 |
| literal: an href attribute | 33 | 15953.08 ± 0.9% | 1052.95 ± 0.0% | 27.78 ± 0.3% | 16833.45 ± 1.4% | 2261.80 ± 0.3% | 13.22 ± 0.4% | 75.84 ± 0.3% | 15853.21 ± 1.2% | 15.15 | 1.01 | 0.95 | 7.05 |
| literal: a word, second text | 123 | 15589.84 ± 3.2% | 1050.88 ± 0.2% | 28.26 ± 0.1% | 18427.00 ± 4.5% | 7651.00 ± 8.2% | 19.58 ± 0.6% | 71.38 ± 0.2% | 15715.94 ± 3.2% | 14.84 | 0.99 | 0.85 | 2.04 |
| class: two capitalized words | 1331 | 1107.42 ± 0.4% | 963.55 ± 0.1% | 26.50 ± 0.3% | 587.47 ± 0.1% | 40.97 ± 7.2% | 14.77 ± 0.3% | 68.08 ± 0.5% | 1105.85 ± 0.4% | 1.15 | 1.00 | 1.89 | 27.03 |
| class: a word that ends in ing | 3399 | 888.50 ± 0.1% | 889.96 ± 0.1% | 18.59 ± 0.1% | 549.88 ± 0.2% | 29.56 ± 3.0% | 8.15 ± 0.1% | 18.33 ± 0.4% | 887.56 ± 0.3% | 1.00 | 1.00 | 1.62 | 30.06 |
| class: a word in capitals | 2332 | 1460.17 ± 0.3% | 960.50 ± 0.1% | 27.98 ± 0.3% | 575.24 ± 0.0% | 43.65 ± 3.2% | 17.12 ± 0.4% | 83.17 ± 0.4% | 1458.39 ± 0.3% | 1.52 | 1.00 | 2.54 | 33.46 |
| class: a number | 8288 | 2112.74 ± 0.3% | 812.25 ± 0.1% | 28.15 ± 0.2% | 1799.14 ± 0.2% | 40.72 ± 16.5% | 0.56 ± 0.1% | 57.28 ± 0.1% | 2110.39 ± 0.2% | 2.60 | 1.00 | 1.17 | 51.89 |
| class: two capitalized words, second text | 5359 | 702.28 ± 0.3% | 702.83 ± 0.2% | 23.78 ± 0.2% | 488.90 ± 0.1% | 35.31 ± 7.1% | 16.66 ± 0.2% | 63.28 ± 0.4% | 702.33 ± 0.1% | 1.00 | 1.00 | 1.44 | 19.89 |
| other: a word between two words | 6104 | 748.36 ± 0.1% | 754.75 ± 0.2% | 23.99 ± 0.3% | 752.36 ± 0.2% | 108.44 ± 11.8% | 11.26 ± 0.3% | 69.75 ± 0.3% | 745.79 ± 0.1% | 0.99 | 1.00 | 0.99 | 6.90 |
| other: a number before a unit, second text | 1481 | 5290.39 ± 0.5% | 985.13 ± 0.1% | 26.32 ± 0.3% | 5887.01 ± 0.8% | 40.97 ± 9.7% | 17.83 ± 0.4% | 65.84 ± 0.1% | 5279.42 ± 0.4% | 5.37 | 1.00 | 0.90 | 129.14 |
| other: a heading's start tag | 110 | 12315.07 ± 1.0% | 1040.96 ± 0.2% | 27.52 ± 0.5% | 1719.35 ± 0.1% | 1586.04 ± 5.6% | 16.19 ± 0.5% | 88.07 ± 1.1% | 12303.59 ± 1.7% | 11.83 | 1.00 | 7.16 | 7.76 |
| other: a whole word | 217 | 13528.13 ± 1.2% | 1046.28 ± 0.1% | 29.85 ± 0.5% | 14467.64 ± 2.5% | 49.35 ± 0.1% | 13.47 ± 0.1% | 55.45 ± 0.9% | 13473.51 ± 1.0% | 12.93 | 1.00 | 0.94 | 274.12 |
| other: a line's first word, second text | 3716 | 1922.56 ± 0.8% | 869.21 ± 0.1% | 31.37 ± 0.4% | 1752.62 ± 0.7% | 62.15 ± 7.2% | refused | refused | 1914.99 ± 0.3% | 2.21 | 1.00 | 1.10 | 30.93 |
| other: fourteen octets before an x | 87 | 18534.17 ± 1.9% | 1.54 ± 0.1% | 1.54 ± 0.1% | 3885.98 ± 0.3% | 10.70 ± 0.1% | differs | 17.88 ± 0.3% | 18513.24 ± 0.8% | 12048.90 | 1.00 | 4.77 | 1732.68 |
| other: a Greek word | 21815 | 478.58 ± 0.6% | 322.44 ± 0.3% | 31.46 ± 0.1% | 294.36 ± 0.1% | 48.58 ± 9.0% | differs | refused | 477.59 ± 0.8% | 1.48 | 1.00 | 1.63 | 9.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.09 ± 0.2% | 28.08 ± 0.2% | 0.50 ± 0.3% | 21.47 ± 0.2% | 2.77 ± 11.6% | differs | 4.03 ± 0.2% | 28.09 ± 0.1% | 1.00 | 1.00 | 1.31 | 10.13 |
| a UUID | 32895 | 23.19 ± 0.4% | 23.18 ± 0.4% | 0.67 ± 0.2% | 16.02 ± 0.1% | 3.11 ± 0.2% | 0.72 ± 0.3% | 3.62 ± 0.3% | 23.22 ± 0.2% | 1.00 | 1.00 | 1.45 | 7.47 |
| an IPv4 address | 33176 | 41.46 ± 0.4% | 41.45 ± 0.4% | 2.19 ± 0.2% | 32.48 ± 0.2% | 6.69 ± 0.2% | differs | 4.08 ± 0.1% | 41.50 ± 0.5% | 1.00 | 1.00 | 1.28 | 6.20 |
| a date and time | 32954 | 34.93 ± 0.5% | 34.89 ± 0.7% | 1.51 ± 0.3% | 23.17 ± 0.2% | 7.09 ± 0.1% | 1.20 ± 0.2% | 7.06 ± 0.3% | 34.91 ± 0.2% | 1.00 | 1.00 | 1.51 | 4.93 |
| a field path | 32606 | 32.24 ± 0.2% | 32.26 ± 0.5% | 0.83 ± 0.1% | 25.19 ± 0.5% | 3.51 ± 0.9% | differs | 2.91 ± 0.3% | 32.22 ± 0.6% | 1.00 | 1.00 | 1.28 | 9.18 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.25 ± 0.2% | 10.24 ± 0.1% | 10.25 ± 0.2% | 11.18 ± 0.3% | 4.94 ± 1.0% | 0.90 ± 0.8% | none | 10.24 ± 0.1% | 1.00 | 1.00 | 0.92 | 2.07 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 270.40 ± 0.5% | 271.58 ± 0.2% | 317.53 ± 0.2% | 86.62 ± 0.1% | 219.47 ± 1.6% | 487.07 ± 0.9% | 3783.37 ± 0.3% | 270.32 ± 0.8% | 1.00 | 1.00 | 3.12 | 1.23 |
| a UUID | 62 | 190.28 ± 0.1% | 190.74 ± 0.2% | 216.30 ± 0.1% | 45.84 ± 0.2% | 98.52 ± 12.0% | 183.95 ± 1.0% | 4458.34 ± 0.6% | 190.52 ± 0.2% | 1.00 | 1.00 | 4.15 | 1.93 |
| an IPv4 address | 29 | 475.87 ± 0.3% | 479.81 ± 0.3% | 643.09 ± 0.4% | 76.94 ± 1.0% | 130.56 ± 1.1% | 293.85 ± 0.8% | 7186.81 ± 0.3% | 475.77 ± 0.3% | 0.99 | 1.00 | 6.19 | 3.64 |
| a date and time | 56 | 336.99 ± 0.3% | 338.55 ± 0.2% | 413.95 ± 0.2% | 72.56 ± 0.1% | 135.94 ± 2.4% | 321.53 ± 1.0% | 4971.01 ± 0.3% | 337.09 ± 0.1% | 1.00 | 1.00 | 4.64 | 2.48 |
| a field path | 39 | 270.49 ± 0.2% | 271.25 ± 0.3% | 318.11 ± 0.2% | 80.05 ± 0.4% | 203.92 ± 1.5% | 489.04 ± 0.7% | 4855.44 ± 0.5% | 269.98 ± 0.4% | 1.00 | 1.00 | 3.38 | 1.33 |
| literal: a word | 7 | 762.42 ± 0.4% | 788.68 ± 0.6% | 1332.44 ± 0.1% | 514.82 ± 1.6% | 627.97 ± 3.2% | 926.20 ± 0.4% | 30871.33 ± 0.7% | 760.97 ± 0.2% | 0.97 | 1.00 | 1.48 | 1.21 |
| literal: a word that is not there | 8 | 730.36 ± 0.3% | 758.73 ± 0.3% | 1249.12 ± 0.1% | 470.90 ± 0.4% | 598.16 ± 1.1% | 877.26 ± 0.7% | 29674.95 ± 0.6% | 730.50 ± 0.2% | 0.96 | 1.00 | 1.55 | 1.22 |
| literal: one of four words | 26 | 407.65 ± 0.2% | 445.31 ± 0.3% | 587.16 ± 0.3% | 49.20 ± 0.4% | 240.40 ± 1.5% | 355.33 ± 0.5% | 15824.79 ± 0.2% | 407.10 ± 0.4% | 0.92 | 1.00 | 8.28 | 1.70 |
| literal: a word in any case | 11 | 574.49 ± 0.3% | 593.53 ± 0.5% | 889.23 ± 0.1% | 15.76 ± 0.9% | 646.69 ± 1.7% | refused | 23884.74 ± 0.7% | 575.21 ± 0.2% | 0.97 | 1.00 | 36.45 | 0.89 |
| literal: an href attribute | 12 | 438.59 ± 0.2% | 446.39 ± 0.6% | 590.80 ± 0.4% | 9.27 ± 34.5% | 496.42 ± 2.8% | 754.92 ± 0.9% | 22344.13 ± 0.3% | 438.90 ± 0.3% | 0.98 | 1.00 | 47.30 | 0.88 |
| literal: a word, second text | 10 | 677.81 ± 0.3% | 708.59 ± 0.3% | 1128.64 ± 0.1% | 422.91 ± 0.5% | 536.44 ± 1.7% | 780.23 ± 0.7% | 27734.53 ± 0.3% | 678.11 ± 0.2% | 0.96 | 1.00 | 1.60 | 1.26 |
| class: two capitalized words | 23 | 507.03 ± 0.4% | 525.44 ± 0.9% | 732.99 ± 0.4% | 100.95 ± 0.3% | 501.76 ± 1.0% | 725.62 ± 0.4% | 6339.77 ± 0.3% | 507.77 ± 0.2% | 0.96 | 1.00 | 5.02 | 1.01 |
| class: a word that ends in ing | 9 | 702.16 ± 0.6% | 748.07 ± 0.4% | 1224.01 ± 0.3% | 132.27 ± 1.4% | 756.05 ± 0.8% | 1092.65 ± 0.2% | 15856.84 ± 0.3% | 701.57 ± 0.5% | 0.94 | 1.00 | 5.31 | 0.93 |
| class: a word in capitals | 16 | 594.54 ± 0.3% | 619.50 ± 0.3% | 912.48 ± 0.1% | 137.21 ± 1.2% | 750.08 ± 0.3% | 994.22 ± 0.7% | 8351.67 ± 0.1% | 593.77 ± 0.3% | 0.96 | 1.00 | 4.33 | 0.79 |
| class: a number | 6 | 776.76 ± 0.5% | 819.28 ± 0.4% | 1402.39 ± 0.1% | 42.04 ± 0.8% | 1396.27 ± 0.3% | 1871.11 ± 1.5% | 22909.45 ± 0.3% | 777.51 ± 0.3% | 0.95 | 1.00 | 18.48 | 0.56 |
| class: two capitalized words, second text | 23 | 506.49 ± 0.7% | 526.62 ± 0.3% | 733.24 ± 0.4% | 100.66 ± 0.3% | 503.60 ± 1.1% | 741.10 ± 0.4% | 6339.96 ± 0.1% | 507.34 ± 0.8% | 0.96 | 1.00 | 5.03 | 1.01 |
| other: a word between two words | 13 | 643.64 ± 0.3% | 654.40 ± 0.4% | 996.25 ± 0.2% | 134.17 ± 0.6% | 504.11 ± 2.1% | 806.61 ± 0.4% | 14769.30 ± 0.1% | 642.49 ± 0.2% | 0.98 | 1.00 | 4.80 | 1.28 |
| other: a number before a unit, second text | 15 | 506.73 ± 0.8% | 540.84 ± 0.2% | 759.50 ± 0.1% | 39.58 ± 0.4% | 633.58 ± 0.8% | 884.46 ± 1.3% | 15272.43 ± 0.3% | 506.26 ± 0.9% | 0.94 | 1.00 | 12.80 | 0.80 |
| other: a heading's start tag | 13 | 431.95 ± 0.9% | 439.25 ± 0.5% | 582.67 ± 0.6% | 9.80 ± 23.2% | 625.67 ± 1.6% | 874.45 ± 0.9% | 18528.21 ± 0.1% | 433.15 ± 0.5% | 0.98 | 1.00 | 44.07 | 0.69 |
| other: a whole word | 11 | 704.73 ± 0.3% | 719.91 ± 0.7% | 1160.43 ± 0.3% | 120.04 ± 0.4% | 558.47 ± 1.2% | 827.05 ± 0.7% | 27193.06 ± 1.2% | 705.56 ± 0.2% | 0.98 | 1.00 | 5.87 | 1.26 |
| other: a line's first word, second text | 17 | 630.69 ± 0.4% | 653.63 ± 0.4% | 984.97 ± 0.2% | 128.82 ± 0.3% | 709.21 ± 0.8% | refused | refused | 628.46 ± 0.6% | 0.96 | 1.00 | 4.90 | 0.89 |
| other: fourteen octets before an x | 16 | 119.62 ± 0.5% | 161.23 ± 0.9% | 187.84 ± 1.4% | 7.07 ± 15.6% | 451.53 ± 1.5% | 419.10 ± 0.5% | 13039.22 ± 0.1% | 119.62 ± 0.3% | 0.74 | 1.00 | 16.92 | 0.26 |
| other: a Greek word | 8 | 725.68 ± 0.6% | 778.31 ± 0.5% | 1286.48 ± 0.1% | 10.34 ± 26.9% | 1380.67 ± 1.5% | 1787.96 ± 0.4% | refused | 724.75 ± 0.3% | 0.93 | 1.00 | 70.21 | 0.53 |

