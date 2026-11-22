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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063427559 |
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
| literal: a word | 217 | 15611.32 ± 1.0% | 1048.30 ± 0.2% | 28.67 ± 0.2% | 18567.59 ± 2.8% | 9110.26 ± 9.1% | 17.30 ± 0.3% | 86.25 ± 0.4% | 15656.40 ± 1.0% | 14.89 | 1.00 | 0.84 | 1.71 |
| literal: a word that is not there | 0 | 18374.39 ± 2.3% | 1055.87 ± 0.2% | 28.55 ± 0.3% | 19713.64 ± 3.2% | 28940.99 ± 1.9% | 17.11 ± 0.6% | 80.76 ± 0.2% | 18473.60 ± 1.6% | 17.40 | 0.99 | 0.93 | 0.63 |
| literal: one of four words | 661 | 5818.64 ± 0.5% | 1025.74 ± 0.2% | 15.05 ± 0.4% | 3979.79 ± 0.2% | 21.88 ± 0.2% | 5.36 ± 0.1% | 6.87 ± 0.2% | 5801.56 ± 0.4% | 5.67 | 1.00 | 1.46 | 265.92 |
| literal: a word in any case | 217 | 11661.28 ± 0.8% | 1045.48 ± 0.2% | 21.94 ± 1.4% | 3984.68 ± 0.4% | 38.62 ± 0.1% | refused | differs | 11647.20 ± 0.7% | 11.15 | 1.00 | 2.93 | 301.98 |
| literal: an href attribute | 33 | 15950.46 ± 0.9% | 1052.84 ± 0.3% | 27.74 ± 0.2% | 16613.10 ± 1.5% | 2264.47 ± 0.5% | 13.18 ± 0.1% | 75.43 ± 0.4% | 15928.63 ± 1.2% | 15.15 | 1.00 | 0.96 | 7.04 |
| literal: a word, second text | 123 | 15652.50 ± 1.9% | 1050.29 ± 0.2% | 28.29 ± 0.2% | 18498.98 ± 3.0% | 7777.78 ± 4.6% | 20.07 ± 1.0% | 70.30 ± 0.3% | 15746.72 ± 1.6% | 14.90 | 0.99 | 0.85 | 2.01 |
| class: two capitalized words | 1331 | 1107.35 ± 0.6% | 963.37 ± 0.2% | 26.43 ± 0.4% | 587.20 ± 0.1% | 40.92 ± 12.4% | 14.75 ± 0.2% | 67.80 ± 0.3% | 1104.54 ± 0.3% | 1.15 | 1.00 | 1.89 | 27.06 |
| class: a word that ends in ing | 3399 | 888.17 ± 0.1% | 890.25 ± 0.2% | 18.62 ± 0.2% | 550.28 ± 0.1% | 29.55 ± 4.8% | 8.13 ± 0.1% | 18.39 ± 0.2% | 886.62 ± 0.2% | 1.00 | 1.00 | 1.61 | 30.06 |
| class: a word in capitals | 2332 | 1461.37 ± 0.4% | 960.57 ± 0.2% | 27.99 ± 0.4% | 575.38 ± 0.2% | 43.69 ± 14.3% | 17.18 ± 0.5% | 83.12 ± 0.3% | 1459.84 ± 0.3% | 1.52 | 1.00 | 2.54 | 33.45 |
| class: a number | 8288 | 2116.77 ± 0.7% | 811.92 ± 0.1% | 28.28 ± 0.5% | 1802.32 ± 0.4% | 38.76 ± 15.4% | 0.55 ± 0.1% | 57.23 ± 0.2% | 2107.84 ± 0.5% | 2.61 | 1.00 | 1.17 | 54.61 |
| class: two capitalized words, second text | 5359 | 701.61 ± 0.2% | 702.39 ± 0.2% | 23.75 ± 0.1% | 489.24 ± 0.0% | 35.28 ± 8.7% | 17.06 ± 0.3% | 63.12 ± 0.6% | 701.15 ± 0.2% | 1.00 | 1.00 | 1.43 | 19.89 |
| other: a word between two words | 6104 | 748.11 ± 0.2% | 754.84 ± 0.2% | 24.03 ± 0.4% | 748.88 ± 0.2% | 108.52 ± 17.0% | 11.21 ± 0.2% | 69.29 ± 0.3% | 747.76 ± 0.2% | 0.99 | 1.00 | 1.00 | 6.89 |
| other: a number before a unit, second text | 1481 | 5318.36 ± 1.0% | 984.88 ± 0.3% | 26.31 ± 0.3% | 5878.40 ± 0.6% | 41.04 ± 0.0% | 18.19 ± 0.1% | 65.72 ± 0.2% | 5304.24 ± 0.4% | 5.40 | 1.00 | 0.90 | 129.59 |
| other: a heading's start tag | 110 | 12340.29 ± 1.2% | 1040.94 ± 0.0% | 27.44 ± 0.2% | 1719.54 ± 0.2% | 1584.47 ± 3.8% | 16.05 ± 0.4% | 87.76 ± 0.9% | 12344.37 ± 1.0% | 11.85 | 1.00 | 7.18 | 7.79 |
| other: a whole word | 217 | 13637.21 ± 1.1% | 1045.38 ± 0.2% | 30.02 ± 0.2% | 14625.16 ± 0.5% | 49.32 ± 0.5% | 13.12 ± 0.3% | 55.29 ± 0.5% | 13629.90 ± 1.8% | 13.05 | 1.00 | 0.93 | 276.51 |
| other: a line's first word, second text | 3716 | 1924.13 ± 0.3% | 868.92 ± 0.0% | 31.96 ± 0.3% | 1749.18 ± 0.7% | 62.16 ± 7.5% | refused | refused | 1915.38 ± 0.5% | 2.21 | 1.00 | 1.10 | 30.95 |
| other: fourteen octets before an x | 87 | 18991.27 ± 2.1% | 1.54 ± 0.2% | 1.54 ± 0.0% | 3962.19 ± 0.3% | 10.67 ± 0.1% | differs | 17.92 ± 0.2% | 19090.70 ± 1.3% | 12352.54 | 0.99 | 4.79 | 1780.14 |
| other: a Greek word | 21815 | 480.77 ± 0.2% | 322.61 ± 0.4% | 31.49 ± 0.2% | 294.51 ± 0.4% | 49.33 ± 10.2% | differs | refused | 478.98 ± 0.5% | 1.49 | 1.00 | 1.63 | 9.75 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.12 ± 0.1% | 28.10 ± 0.4% | 0.50 ± 0.3% | 21.57 ± 0.3% | 2.77 ± 0.4% | differs | 4.04 ± 0.2% | 28.10 ± 0.1% | 1.00 | 1.00 | 1.30 | 10.16 |
| a UUID | 32895 | 23.08 ± 0.3% | 23.06 ± 0.2% | 0.67 ± 0.1% | 16.04 ± 0.1% | 3.10 ± 0.8% | 0.73 ± 0.2% | 3.65 ± 0.4% | 23.08 ± 0.7% | 1.00 | 1.00 | 1.44 | 7.44 |
| an IPv4 address | 33176 | 41.50 ± 0.5% | 41.47 ± 0.1% | 2.19 ± 0.3% | 32.75 ± 0.2% | 6.68 ± 0.1% | differs | 4.09 ± 0.1% | 41.55 ± 0.2% | 1.00 | 1.00 | 1.27 | 6.21 |
| a date and time | 32954 | 34.85 ± 0.4% | 34.82 ± 0.2% | 1.52 ± 0.3% | 23.26 ± 0.3% | 7.07 ± 0.1% | 1.26 ± 0.2% | 7.07 ± 0.3% | 34.91 ± 0.2% | 1.00 | 1.00 | 1.50 | 4.93 |
| a field path | 32606 | 32.27 ± 0.2% | 32.24 ± 0.3% | 0.84 ± 0.2% | 25.36 ± 0.2% | 3.51 ± 1.2% | differs | 2.92 ± 0.2% | 32.21 ± 0.2% | 1.00 | 1.00 | 1.27 | 9.18 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.27 ± 0.5% | 10.27 ± 0.2% | 10.27 ± 0.2% | 11.65 ± 0.1% | 4.93 ± 1.2% | 0.94 ± 0.6% | none | 10.27 ± 0.3% | 1.00 | 1.00 | 0.88 | 2.08 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 277.69 ± 1.2% | 279.19 ± 0.3% | 325.61 ± 0.3% | 86.30 ± 1.3% | 219.82 ± 1.5% | 482.53 ± 2.9% | 3761.15 ± 3.6% | 277.66 ± 0.2% | 0.99 | 1.00 | 3.22 | 1.26 |
| a UUID | 62 | 198.34 ± 0.3% | 198.61 ± 0.5% | 224.20 ± 0.4% | 45.96 ± 0.6% | 97.37 ± 4.8% | 188.18 ± 2.2% | 4433.43 ± 0.7% | 198.13 ± 0.3% | 1.00 | 1.00 | 4.32 | 2.04 |
| an IPv4 address | 29 | 481.61 ± 0.6% | 485.16 ± 0.5% | 645.69 ± 0.4% | 77.58 ± 0.8% | 130.05 ± 1.3% | 296.89 ± 0.8% | 7488.06 ± 0.2% | 481.68 ± 0.4% | 0.99 | 1.00 | 6.21 | 3.70 |
| a date and time | 56 | 337.85 ± 0.2% | 340.12 ± 0.2% | 412.68 ± 0.2% | 73.41 ± 0.5% | 134.91 ± 1.5% | 324.25 ± 0.9% | 4928.93 ± 0.8% | 337.54 ± 0.2% | 0.99 | 1.00 | 4.60 | 2.50 |
| a field path | 39 | 285.41 ± 0.4% | 285.84 ± 0.6% | 336.26 ± 0.4% | 79.23 ± 0.7% | 203.21 ± 1.2% | 497.55 ± 2.9% | 4815.71 ± 0.2% | 285.52 ± 0.4% | 1.00 | 1.00 | 3.60 | 1.40 |
| literal: a word | 7 | 758.27 ± 1.0% | 783.60 ± 0.5% | 1309.26 ± 0.1% | 521.96 ± 0.4% | 624.04 ± 1.1% | 953.12 ± 0.6% | 29724.00 ± 0.1% | 758.25 ± 0.6% | 0.97 | 1.00 | 1.45 | 1.22 |
| literal: a word that is not there | 8 | 732.38 ± 0.3% | 756.46 ± 0.4% | 1233.36 ± 0.1% | 467.69 ± 0.6% | 600.15 ± 1.8% | 899.22 ± 0.3% | 28650.49 ± 0.0% | 732.26 ± 0.2% | 0.97 | 1.00 | 1.57 | 1.22 |
| literal: one of four words | 26 | 405.64 ± 0.4% | 442.61 ± 0.4% | 577.77 ± 0.5% | 49.87 ± 1.5% | 237.24 ± 10.8% | 376.75 ± 3.4% | 15390.20 ± 0.3% | 406.15 ± 0.7% | 0.92 | 1.00 | 8.13 | 1.71 |
| literal: a word in any case | 11 | 572.98 ± 0.2% | 589.97 ± 0.3% | 865.40 ± 0.3% | 15.39 ± 0.5% | 645.38 ± 0.8% | refused | 23323.90 ± 0.4% | 572.92 ± 0.2% | 0.97 | 1.00 | 37.23 | 0.89 |
| literal: an href attribute | 12 | 438.85 ± 0.2% | 445.39 ± 0.2% | 583.06 ± 0.4% | 44.65 ± 0.4% | 500.01 ± 3.1% | 767.26 ± 0.5% | 21348.37 ± 0.2% | 439.67 ± 0.4% | 0.99 | 1.00 | 9.83 | 0.88 |
| literal: a word, second text | 10 | 680.86 ± 0.3% | 704.65 ± 0.4% | 1111.94 ± 0.2% | 416.26 ± 0.7% | 536.98 ± 1.0% | 800.85 ± 1.1% | 26487.45 ± 0.1% | 681.27 ± 0.2% | 0.97 | 1.00 | 1.64 | 1.27 |
| class: two capitalized words | 23 | 510.82 ± 0.3% | 528.55 ± 0.1% | 728.99 ± 0.7% | 99.18 ± 0.6% | 502.84 ± 1.2% | 745.30 ± 0.5% | 6290.79 ± 0.2% | 510.35 ± 0.4% | 0.97 | 1.00 | 5.15 | 1.02 |
| class: a word that ends in ing | 9 | 710.14 ± 0.5% | 755.34 ± 0.4% | 1226.17 ± 0.2% | 131.41 ± 1.2% | 758.95 ± 1.1% | 1086.27 ± 1.3% | 15624.66 ± 0.2% | 709.98 ± 0.3% | 0.94 | 1.00 | 5.40 | 0.94 |
| class: a word in capitals | 16 | 603.27 ± 0.5% | 631.27 ± 0.6% | 930.34 ± 0.2% | 134.50 ± 0.8% | 750.11 ± 0.8% | 1033.22 ± 0.8% | 8281.45 ± 0.2% | 603.40 ± 0.1% | 0.96 | 1.00 | 4.49 | 0.80 |
| class: a number | 6 | 793.98 ± 0.4% | 836.37 ± 0.5% | 1449.79 ± 0.1% | 42.03 ± 1.1% | 1391.28 ± 1.2% | 1853.30 ± 1.0% | 22379.63 ± 0.3% | 795.84 ± 0.2% | 0.95 | 1.00 | 18.89 | 0.57 |
| class: two capitalized words, second text | 23 | 510.47 ± 0.3% | 528.80 ± 0.4% | 728.75 ± 0.8% | 100.19 ± 0.4% | 502.58 ± 1.2% | 755.06 ± 4.4% | 6289.14 ± 0.1% | 510.67 ± 0.5% | 0.97 | 1.00 | 5.10 | 1.02 |
| other: a word between two words | 13 | 648.60 ± 0.3% | 658.11 ± 0.6% | 995.20 ± 0.6% | 135.07 ± 1.2% | 500.72 ± 1.5% | 797.55 ± 0.5% | 14569.07 ± 0.2% | 647.52 ± 0.3% | 0.99 | 1.00 | 4.80 | 1.30 |
| other: a number before a unit, second text | 15 | 520.00 ± 0.5% | 553.80 ± 0.4% | 776.93 ± 0.2% | 39.30 ± 0.7% | 631.36 ± 0.9% | 879.99 ± 0.6% | 14983.54 ± 0.1% | 519.85 ± 0.2% | 0.94 | 1.00 | 13.23 | 0.82 |
| other: a heading's start tag | 13 | 439.60 ± 0.3% | 444.19 ± 0.4% | 583.74 ± 0.8% | 43.74 ± 0.5% | 629.05 ± 2.2% | 870.30 ± 0.8% | 17866.93 ± 0.1% | 439.85 ± 0.4% | 0.99 | 1.00 | 10.05 | 0.70 |
| other: a whole word | 11 | 709.91 ± 0.3% | 724.17 ± 0.4% | 1157.50 ± 0.3% | 119.09 ± 1.2% | 560.57 ± 2.0% | 825.93 ± 0.5% | 26454.26 ± 0.6% | 711.71 ± 0.3% | 0.98 | 1.00 | 5.96 | 1.27 |
| other: a line's first word, second text | 17 | 639.62 ± 0.7% | 662.88 ± 0.3% | 994.73 ± 0.3% | 129.46 ± 0.7% | 704.38 ± 1.0% | refused | refused | 636.52 ± 0.8% | 0.96 | 1.00 | 4.94 | 0.91 |
| other: fourteen octets before an x | 16 | 120.88 ± 0.5% | 163.87 ± 0.9% | 189.07 ± 1.0% | 15.13 ± 0.4% | 450.77 ± 3.4% | 413.55 ± 0.9% | 12760.45 ± 0.4% | 120.53 ± 0.9% | 0.74 | 1.00 | 7.99 | 0.27 |
| other: a Greek word | 8 | 738.46 ± 0.4% | 791.41 ± 0.5% | 1309.07 ± 0.2% | 59.35 ± 0.1% | 1385.51 ± 1.6% | 1861.93 ± 0.5% | refused | 737.88 ± 0.7% | 0.93 | 1.00 | 12.44 | 0.53 |

