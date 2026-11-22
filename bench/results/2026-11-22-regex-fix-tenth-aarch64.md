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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063445182 |
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
| literal: a word | 217 | 15571.05 ± 1.7% | 1048.53 ± 0.2% | 28.77 ± 0.4% | 18517.47 ± 1.9% | 9201.14 ± 6.9% | 17.38 ± 0.4% | 87.09 ± 1.0% | 15521.69 ± 1.6% | 14.85 | 1.00 | 0.84 | 1.69 |
| literal: a word that is not there | 0 | 18192.62 ± 1.0% | 1055.61 ± 0.1% | 28.62 ± 0.3% | 19778.73 ± 1.5% | 28132.02 ± 4.7% | 17.17 ± 0.5% | 80.95 ± 0.6% | 18174.97 ± 0.8% | 17.23 | 1.00 | 0.92 | 0.65 |
| literal: one of four words | 661 | 5820.57 ± 0.2% | 1025.82 ± 0.1% | 15.02 ± 0.3% | 3981.31 ± 0.5% | 21.90 ± 0.1% | 5.25 ± 0.2% | 6.94 ± 0.2% | 5804.85 ± 0.2% | 5.67 | 1.00 | 1.46 | 265.77 |
| literal: a word in any case | 217 | 11714.26 ± 0.4% | 1045.65 ± 0.6% | 22.09 ± 0.3% | 3986.69 ± 0.2% | 38.68 ± 0.1% | refused | differs | 11693.26 ± 0.5% | 11.20 | 1.00 | 2.94 | 302.81 |
| literal: an href attribute | 33 | 16021.02 ± 0.5% | 1052.04 ± 0.3% | 27.75 ± 0.2% | 17038.08 ± 1.2% | 2264.17 ± 0.5% | 13.18 ± 0.2% | 76.00 ± 0.4% | 16076.64 ± 0.5% | 15.23 | 1.00 | 0.94 | 7.08 |
| literal: a word, second text | 123 | 15556.02 ± 1.8% | 1050.47 ± 0.4% | 28.25 ± 0.2% | 18460.97 ± 4.0% | 7618.34 ± 7.7% | 19.62 ± 0.6% | 71.30 ± 0.3% | 15550.51 ± 2.2% | 14.81 | 1.00 | 0.84 | 2.04 |
| class: two capitalized words | 1331 | 1108.45 ± 0.2% | 963.82 ± 0.2% | 26.47 ± 0.5% | 587.19 ± 0.1% | 40.99 ± 3.3% | 14.78 ± 0.3% | 68.03 ± 0.4% | 1107.80 ± 0.4% | 1.15 | 1.00 | 1.89 | 27.04 |
| class: a word that ends in ing | 3399 | 887.92 ± 0.2% | 889.81 ± 0.1% | 18.57 ± 0.3% | 550.22 ± 0.1% | 29.58 ± 12.3% | 8.16 ± 0.1% | 18.32 ± 0.2% | 887.87 ± 0.1% | 1.00 | 1.00 | 1.61 | 30.02 |
| class: a word in capitals | 2332 | 1465.05 ± 0.8% | 960.49 ± 0.3% | 27.96 ± 0.3% | 575.05 ± 0.1% | 43.81 ± 16.9% | 17.15 ± 0.1% | 83.43 ± 0.2% | 1462.32 ± 0.2% | 1.53 | 1.00 | 2.55 | 33.44 |
| class: a number | 8288 | 2117.99 ± 0.5% | 812.65 ± 0.1% | 28.16 ± 0.2% | 1799.97 ± 0.3% | 42.28 ± 15.2% | 0.54 ± 0.4% | 57.24 ± 0.4% | 2113.67 ± 0.4% | 2.61 | 1.00 | 1.18 | 50.09 |
| class: two capitalized words, second text | 5359 | 702.57 ± 0.2% | 702.98 ± 0.2% | 23.77 ± 0.2% | 488.79 ± 0.1% | 35.60 ± 13.5% | 16.69 ± 0.6% | 63.23 ± 0.1% | 701.93 ± 0.2% | 1.00 | 1.00 | 1.44 | 19.74 |
| other: a word between two words | 6104 | 748.52 ± 0.3% | 754.97 ± 0.1% | 24.02 ± 0.3% | 752.59 ± 0.1% | 109.76 ± 13.4% | 11.25 ± 0.1% | 69.70 ± 0.3% | 748.66 ± 0.3% | 0.99 | 1.00 | 0.99 | 6.82 |
| other: a number before a unit, second text | 1481 | 5300.72 ± 0.5% | 985.29 ± 0.0% | 26.37 ± 0.3% | 5926.63 ± 0.5% | 41.03 ± 0.2% | 17.78 ± 0.1% | 65.78 ± 0.1% | 5285.75 ± 0.3% | 5.38 | 1.00 | 0.89 | 129.18 |
| other: a heading's start tag | 110 | 12432.56 ± 0.9% | 1041.17 ± 0.2% | 27.51 ± 0.3% | 1720.93 ± 0.2% | 1585.09 ± 2.7% | 16.09 ± 0.3% | 88.03 ± 1.9% | 12463.12 ± 0.9% | 11.94 | 1.00 | 7.22 | 7.84 |
| other: a whole word | 217 | 13686.91 ± 1.0% | 1048.06 ± 0.1% | 29.84 ± 0.4% | 14784.28 ± 1.8% | 49.41 ± 0.2% | 13.43 ± 0.1% | 55.55 ± 0.4% | 13705.61 ± 0.9% | 13.06 | 1.00 | 0.93 | 276.98 |
| other: a line's first word, second text | 3716 | 1920.71 ± 0.5% | 869.98 ± 0.1% | 31.47 ± 0.3% | 1758.84 ± 0.5% | 62.70 ± 6.6% | refused | refused | 1914.82 ± 0.8% | 2.21 | 1.00 | 1.09 | 30.63 |
| other: fourteen octets before an x | 87 | 19332.39 ± 2.3% | 1.54 ± 0.4% | 1.54 ± 0.1% | 3988.47 ± 0.4% | 10.69 ± 0.1% | differs | 17.91 ± 0.1% | 19251.16 ± 1.7% | 12565.21 | 1.00 | 4.85 | 1808.51 |
| other: a Greek word | 21815 | 479.30 ± 0.2% | 323.39 ± 0.4% | 31.48 ± 0.1% | 293.31 ± 0.1% | 49.46 ± 12.8% | differs | refused | 478.12 ± 0.5% | 1.48 | 1.00 | 1.63 | 9.69 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.12 ± 0.2% | 28.09 ± 0.2% | 0.50 ± 0.3% | 21.46 ± 0.2% | 2.77 ± 0.7% | differs | 4.02 ± 0.1% | 28.10 ± 0.1% | 1.00 | 1.00 | 1.31 | 10.14 |
| a UUID | 32895 | 23.21 ± 0.4% | 23.16 ± 0.6% | 0.67 ± 0.0% | 16.01 ± 0.2% | 3.10 ± 0.1% | 0.72 ± 0.0% | 3.63 ± 0.7% | 22.70 ± 0.3% | 1.00 | 1.02 | 1.45 | 7.48 |
| an IPv4 address | 33176 | 41.48 ± 0.3% | 41.49 ± 0.2% | 2.19 ± 0.2% | 32.50 ± 0.2% | 6.70 ± 0.1% | differs | 4.08 ± 0.1% | 41.49 ± 0.2% | 1.00 | 1.00 | 1.28 | 6.19 |
| a date and time | 32954 | 34.91 ± 0.7% | 34.98 ± 0.3% | 1.52 ± 0.2% | 23.18 ± 0.1% | 7.08 ± 0.1% | 1.19 ± 0.3% | 7.06 ± 0.2% | 34.93 ± 0.2% | 1.00 | 1.00 | 1.51 | 4.93 |
| a field path | 32606 | 32.24 ± 0.3% | 32.25 ± 0.2% | 0.83 ± 0.1% | 25.23 ± 0.3% | 3.51 ± 1.2% | differs | 2.90 ± 0.2% | 32.21 ± 0.2% | 1.00 | 1.00 | 1.28 | 9.19 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.25 ± 0.4% | 10.26 ± 0.1% | 10.26 ± 0.2% | 11.26 ± 0.1% | 4.96 ± 1.2% | 0.90 ± 0.3% | none | 10.25 ± 0.2% | 1.00 | 1.00 | 0.91 | 2.06 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 269.91 ± 0.3% | 271.02 ± 0.4% | 317.56 ± 0.3% | 86.20 ± 0.5% | 223.83 ± 1.0% | 485.36 ± 0.9% | 3777.47 ± 0.2% | 269.85 ± 0.4% | 1.00 | 1.00 | 3.13 | 1.21 |
| a UUID | 62 | 190.18 ± 0.3% | 190.88 ± 0.3% | 216.63 ± 0.2% | 46.50 ± 0.8% | 99.41 ± 0.5% | 190.39 ± 3.0% | 4464.84 ± 0.5% | 190.28 ± 0.5% | 1.00 | 1.00 | 4.09 | 1.91 |
| an IPv4 address | 29 | 476.30 ± 0.2% | 479.82 ± 0.4% | 643.33 ± 0.6% | 76.94 ± 0.3% | 132.23 ± 1.4% | 304.25 ± 1.8% | 7557.62 ± 0.4% | 474.99 ± 0.3% | 0.99 | 1.00 | 6.19 | 3.60 |
| a date and time | 56 | 337.25 ± 0.4% | 338.17 ± 0.3% | 413.90 ± 0.2% | 73.06 ± 0.4% | 136.22 ± 21.2% | 325.92 ± 1.0% | 4959.99 ± 0.6% | 336.78 ± 0.2% | 1.00 | 1.00 | 4.62 | 2.48 |
| a field path | 39 | 270.38 ± 0.4% | 271.63 ± 0.2% | 318.30 ± 0.4% | 80.58 ± 1.0% | 204.71 ± 2.4% | 506.43 ± 3.3% | 4813.68 ± 3.2% | 270.50 ± 0.6% | 1.00 | 1.00 | 3.36 | 1.32 |
| literal: a word | 7 | 761.06 ± 0.4% | 788.92 ± 0.4% | 1332.25 ± 0.1% | 523.43 ± 0.1% | 628.11 ± 1.1% | 958.30 ± 0.7% | 30895.55 ± 0.3% | 761.98 ± 0.1% | 0.96 | 1.00 | 1.45 | 1.21 |
| literal: a word that is not there | 8 | 730.45 ± 0.3% | 757.85 ± 0.6% | 1248.60 ± 0.1% | 481.07 ± 1.0% | 599.87 ± 0.9% | 907.78 ± 0.5% | 29798.57 ± 0.3% | 730.64 ± 0.2% | 0.96 | 1.00 | 1.52 | 1.22 |
| literal: one of four words | 26 | 407.34 ± 0.3% | 445.49 ± 0.4% | 586.76 ± 0.1% | 49.81 ± 1.4% | 242.79 ± 5.4% | 374.80 ± 1.5% | 15796.06 ± 0.6% | 406.35 ± 0.5% | 0.91 | 1.00 | 8.18 | 1.68 |
| literal: a word in any case | 11 | 574.81 ± 0.1% | 593.66 ± 0.4% | 887.80 ± 0.7% | 15.83 ± 1.7% | 654.90 ± 1.7% | refused | 23943.89 ± 1.1% | 574.93 ± 0.1% | 0.97 | 1.00 | 36.31 | 0.88 |
| literal: an href attribute | 12 | 438.26 ± 1.4% | 444.51 ± 0.8% | 588.60 ± 0.8% | 45.74 ± 0.2% | 506.99 ± 1.4% | 772.05 ± 0.8% | 22325.22 ± 0.4% | 438.84 ± 1.0% | 0.99 | 1.00 | 9.58 | 0.86 |
| literal: a word, second text | 10 | 678.46 ± 0.4% | 708.09 ± 0.5% | 1129.51 ± 0.1% | 401.75 ± 0.2% | 540.67 ± 2.8% | 801.95 ± 0.5% | 27702.77 ± 0.9% | 678.37 ± 0.3% | 0.96 | 1.00 | 1.69 | 1.25 |
| class: two capitalized words | 23 | 507.24 ± 0.6% | 526.73 ± 0.7% | 733.61 ± 0.4% | 99.57 ± 0.1% | 503.51 ± 1.2% | 744.57 ± 0.4% | 6344.86 ± 0.1% | 508.10 ± 0.4% | 0.96 | 1.00 | 5.09 | 1.01 |
| class: a word that ends in ing | 9 | 701.61 ± 0.4% | 747.54 ± 0.4% | 1224.49 ± 0.4% | 131.28 ± 1.9% | 757.05 ± 1.3% | 1103.01 ± 0.6% | 15853.25 ± 0.1% | 701.96 ± 0.5% | 0.94 | 1.00 | 5.34 | 0.93 |
| class: a word in capitals | 16 | 594.20 ± 0.7% | 618.79 ± 0.7% | 911.81 ± 0.2% | 134.54 ± 0.5% | 751.18 ± 1.5% | 1024.36 ± 1.6% | 8350.01 ± 0.2% | 594.74 ± 0.3% | 0.96 | 1.00 | 4.42 | 0.79 |
| class: a number | 6 | 775.71 ± 0.5% | 819.07 ± 1.0% | 1402.39 ± 0.1% | 41.78 ± 0.8% | 1409.29 ± 1.0% | 1851.39 ± 1.2% | 22963.50 ± 0.1% | 777.57 ± 0.3% | 0.95 | 1.00 | 18.56 | 0.55 |
| class: two capitalized words, second text | 23 | 507.18 ± 0.7% | 525.22 ± 0.6% | 732.45 ± 0.2% | 100.96 ± 0.5% | 503.50 ± 9.2% | 764.79 ± 0.2% | 6336.18 ± 0.2% | 506.54 ± 0.8% | 0.97 | 1.00 | 5.02 | 1.01 |
| other: a word between two words | 13 | 641.15 ± 0.6% | 653.81 ± 0.9% | 994.43 ± 0.8% | 132.82 ± 0.7% | 504.17 ± 0.9% | 813.91 ± 0.6% | 14769.48 ± 0.2% | 641.53 ± 0.5% | 0.98 | 1.00 | 4.83 | 1.27 |
| other: a number before a unit, second text | 15 | 508.25 ± 0.6% | 539.92 ± 0.5% | 759.41 ± 0.1% | 39.51 ± 0.5% | 640.11 ± 1.6% | 891.67 ± 1.1% | 15277.80 ± 0.1% | 507.34 ± 0.4% | 0.94 | 1.00 | 12.86 | 0.79 |
| other: a heading's start tag | 13 | 433.33 ± 0.9% | 439.64 ± 0.5% | 584.72 ± 0.6% | 43.72 ± 0.2% | 637.91 ± 0.5% | 877.55 ± 0.7% | 18534.33 ± 0.2% | 433.96 ± 1.1% | 0.99 | 1.00 | 9.91 | 0.68 |
| other: a whole word | 11 | 704.21 ± 0.2% | 720.47 ± 0.1% | 1158.87 ± 0.2% | 117.40 ± 0.4% | 565.59 ± 2.3% | 837.46 ± 0.7% | 27167.46 ± 2.1% | 705.35 ± 0.5% | 0.98 | 1.00 | 6.00 | 1.25 |
| other: a line's first word, second text | 17 | 632.08 ± 0.3% | 654.21 ± 0.6% | 984.37 ± 0.1% | 128.08 ± 0.2% | 704.42 ± 3.9% | refused | refused | 629.24 ± 2.4% | 0.97 | 1.00 | 4.94 | 0.90 |
| other: fourteen octets before an x | 16 | 119.65 ± 0.8% | 161.21 ± 1.4% | 188.41 ± 1.8% | 15.09 ± 0.3% | 454.54 ± 1.7% | 412.00 ± 0.4% | 13049.83 ± 0.4% | 119.20 ± 0.4% | 0.74 | 1.00 | 7.93 | 0.26 |
| other: a Greek word | 8 | 724.55 ± 0.8% | 776.49 ± 0.9% | 1285.10 ± 1.2% | 59.18 ± 0.2% | 1392.97 ± 1.1% | 1784.70 ± 0.5% | refused | 724.07 ± 0.6% | 0.93 | 1.00 | 12.24 | 0.52 |

