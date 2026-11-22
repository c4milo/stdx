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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45065561576 |
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
| literal: a word | 217 | 15558.43 ± 1.5% | 1048.64 ± 0.1% | 28.73 ± 0.2% | 18347.41 ± 2.1% | 9189.19 ± 7.2% | 17.38 ± 0.3% | 87.07 ± 0.7% | 15529.36 ± 0.7% | 14.84 | 1.00 | 0.85 | 1.69 |
| literal: a word that is not there | 0 | 18177.25 ± 1.1% | 1054.95 ± 0.8% | 28.64 ± 0.2% | 19473.36 ± 3.1% | 29084.94 ± 1.6% | 17.23 ± 0.3% | 81.17 ± 0.8% | 18196.31 ± 1.2% | 17.23 | 1.00 | 0.93 | 0.62 |
| literal: one of four words | 661 | 5805.77 ± 0.4% | 1025.48 ± 0.4% | 14.99 ± 1.6% | 3978.81 ± 0.3% | 21.88 ± 0.1% | 5.25 ± 0.1% | 6.96 ± 0.2% | 5800.28 ± 0.2% | 5.66 | 1.00 | 1.46 | 265.35 |
| literal: a word in any case | 217 | 11705.13 ± 0.6% | 1045.91 ± 0.3% | 22.10 ± 0.6% | 3980.63 ± 0.2% | 38.39 ± 4.6% | refused | differs | 11701.82 ± 0.3% | 11.19 | 1.00 | 2.94 | 304.90 |
| literal: an href attribute | 33 | 16124.50 ± 0.3% | 1052.99 ± 0.2% | 27.75 ± 0.2% | 16871.23 ± 1.4% | 2260.55 ± 0.4% | 13.25 ± 0.2% | 76.03 ± 0.9% | 16134.90 ± 0.4% | 15.31 | 1.00 | 0.96 | 7.13 |
| literal: a word, second text | 123 | 15720.70 ± 0.6% | 1050.22 ± 0.2% | 28.24 ± 0.2% | 18323.10 ± 2.0% | 7678.99 ± 5.5% | 19.62 ± 0.9% | 71.45 ± 0.4% | 15740.17 ± 0.5% | 14.97 | 1.00 | 0.86 | 2.05 |
| class: two capitalized words | 1331 | 1105.15 ± 0.3% | 963.24 ± 0.5% | 26.46 ± 0.3% | 587.18 ± 0.1% | 40.93 ± 8.8% | 14.76 ± 0.3% | 68.06 ± 0.4% | 1105.45 ± 0.4% | 1.15 | 1.00 | 1.88 | 27.00 |
| class: a word that ends in ing | 3399 | 883.21 ± 0.1% | 889.83 ± 0.4% | 18.60 ± 0.2% | 550.30 ± 0.1% | 29.58 ± 6.3% | 8.16 ± 0.3% | 18.33 ± 0.4% | 887.06 ± 0.2% | 0.99 | 1.00 | 1.60 | 29.86 |
| class: a word in capitals | 2332 | 1462.32 ± 0.5% | 960.43 ± 0.1% | 28.03 ± 0.3% | 574.84 ± 0.1% | 43.76 ± 16.6% | 17.14 ± 0.3% | 83.31 ± 0.5% | 1460.21 ± 0.3% | 1.52 | 1.00 | 2.54 | 33.41 |
| class: a number | 8288 | 2113.19 ± 0.5% | 812.42 ± 0.1% | 28.13 ± 0.6% | 1800.16 ± 0.2% | 43.40 ± 4.7% | 0.56 ± 0.1% | 57.27 ± 0.2% | 2113.33 ± 0.1% | 2.60 | 1.00 | 1.17 | 48.69 |
| class: two capitalized words, second text | 5359 | 701.66 ± 0.4% | 702.60 ± 0.1% | 23.77 ± 0.2% | 488.92 ± 0.1% | 35.65 ± 9.6% | 16.69 ± 0.2% | 63.01 ± 0.6% | 701.42 ± 0.2% | 1.00 | 1.00 | 1.44 | 19.68 |
| other: a word between two words | 6104 | 748.28 ± 0.2% | 754.93 ± 0.1% | 24.00 ± 0.3% | 751.60 ± 0.5% | 109.13 ± 20.1% | 11.26 ± 0.2% | 69.68 ± 0.7% | 748.09 ± 0.0% | 0.99 | 1.00 | 1.00 | 6.86 |
| other: a number before a unit, second text | 1481 | 5296.22 ± 1.0% | 984.70 ± 0.2% | 26.35 ± 0.1% | 5923.10 ± 0.5% | 40.99 ± 0.0% | 17.80 ± 0.5% | 65.84 ± 0.2% | 5286.90 ± 0.3% | 5.38 | 1.00 | 0.89 | 129.20 |
| other: a heading's start tag | 110 | 12459.36 ± 0.3% | 1041.12 ± 0.2% | 27.51 ± 0.2% | 1720.64 ± 0.2% | 1589.41 ± 3.0% | 16.09 ± 0.4% | 87.88 ± 0.5% | 12444.11 ± 0.4% | 11.97 | 1.00 | 7.24 | 7.84 |
| other: a whole word | 217 | 13670.40 ± 0.6% | 1047.20 ± 0.0% | 29.76 ± 0.8% | 14598.98 ± 0.5% | 49.31 ± 0.2% | 13.48 ± 0.2% | 55.47 ± 0.5% | 13698.96 ± 0.9% | 13.05 | 1.00 | 0.94 | 277.22 |
| other: a line's first word, second text | 3716 | 1916.47 ± 0.6% | 869.11 ± 0.2% | 31.40 ± 0.3% | 1755.80 ± 0.3% | 62.79 ± 6.5% | refused | refused | 1914.09 ± 0.4% | 2.21 | 1.00 | 1.09 | 30.52 |
| other: fourteen octets before an x | 87 | 19137.66 ± 1.0% | 1.54 ± 0.1% | 1.54 ± 0.2% | 3995.59 ± 0.5% | 10.68 ± 0.2% | differs | 17.90 ± 0.1% | 19037.49 ± 1.2% | 12439.88 | 1.01 | 4.79 | 1791.89 |
| other: a Greek word | 21815 | 478.92 ± 0.4% | 322.85 ± 0.8% | 31.46 ± 0.2% | 294.40 ± 0.3% | 45.76 ± 20.5% | differs | refused | 477.33 ± 0.5% | 1.48 | 1.00 | 1.63 | 10.47 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.11 ± 0.2% | 28.09 ± 0.2% | 0.50 ± 0.2% | 21.51 ± 0.2% | 2.78 ± 6.5% | differs | 4.03 ± 0.2% | 28.09 ± 0.2% | 1.00 | 1.00 | 1.31 | 10.11 |
| a UUID | 32895 | 23.16 ± 0.2% | 23.18 ± 0.2% | 0.67 ± 0.1% | 16.01 ± 0.1% | 3.11 ± 0.5% | 0.72 ± 0.1% | 3.63 ± 0.4% | 23.18 ± 0.1% | 1.00 | 1.00 | 1.45 | 7.45 |
| an IPv4 address | 33176 | 41.41 ± 0.2% | 41.43 ± 0.2% | 2.19 ± 0.1% | 32.43 ± 0.1% | 6.68 ± 0.2% | differs | 4.08 ± 0.1% | 41.45 ± 0.3% | 1.00 | 1.00 | 1.28 | 6.20 |
| a date and time | 32954 | 34.86 ± 0.2% | 34.91 ± 0.2% | 1.52 ± 1.3% | 23.14 ± 0.1% | 7.11 ± 0.0% | 1.19 ± 0.2% | 7.06 ± 0.3% | 34.83 ± 0.2% | 1.00 | 1.00 | 1.51 | 4.90 |
| a field path | 32606 | 32.22 ± 0.4% | 32.31 ± 0.4% | 0.83 ± 0.3% | 25.22 ± 0.2% | 3.52 ± 1.6% | differs | 2.91 ± 0.1% | 32.22 ± 0.2% | 1.00 | 1.00 | 1.28 | 9.17 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.24 ± 0.2% | 10.25 ± 0.1% | 10.24 ± 0.2% | 11.20 ± 0.2% | 4.89 ± 1.9% | 0.90 ± 0.6% | none | 10.23 ± 0.2% | 1.00 | 1.00 | 0.91 | 2.10 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 270.03 ± 0.8% | 271.22 ± 0.5% | 317.01 ± 0.2% | 86.16 ± 0.2% | 221.88 ± 0.9% | 490.18 ± 0.4% | 3778.05 ± 0.2% | 269.93 ± 0.5% | 1.00 | 1.00 | 3.13 | 1.22 |
| a UUID | 62 | 189.93 ± 0.3% | 190.28 ± 0.6% | 216.37 ± 0.3% | 45.51 ± 0.2% | 98.87 ± 1.2% | 183.84 ± 1.1% | 4461.77 ± 0.3% | 190.00 ± 0.2% | 1.00 | 1.00 | 4.17 | 1.92 |
| an IPv4 address | 29 | 475.62 ± 0.4% | 479.61 ± 0.5% | 642.62 ± 0.5% | 76.03 ± 1.2% | 130.82 ± 1.2% | 294.00 ± 1.1% | 7541.37 ± 0.5% | 475.33 ± 0.5% | 0.99 | 1.00 | 6.26 | 3.64 |
| a date and time | 56 | 337.29 ± 0.2% | 338.55 ± 0.1% | 414.11 ± 0.3% | 71.70 ± 0.3% | 137.28 ± 0.7% | 322.23 ± 0.6% | 4967.37 ± 0.4% | 336.94 ± 0.1% | 1.00 | 1.00 | 4.70 | 2.46 |
| a field path | 39 | 270.15 ± 0.2% | 271.40 ± 0.3% | 317.81 ± 0.3% | 79.14 ± 0.4% | 204.72 ± 1.1% | 489.63 ± 0.9% | 4843.24 ± 0.2% | 270.16 ± 0.4% | 1.00 | 1.00 | 3.41 | 1.32 |
| literal: a word | 7 | 762.73 ± 1.1% | 790.51 ± 0.3% | 1332.91 ± 0.2% | 500.89 ± 1.6% | 640.62 ± 2.0% | 928.08 ± 0.5% | 30827.08 ± 0.2% | 761.66 ± 0.4% | 0.96 | 1.00 | 1.52 | 1.19 |
| literal: a word that is not there | 8 | 730.98 ± 0.3% | 757.50 ± 0.9% | 1249.04 ± 0.2% | 459.38 ± 0.5% | 612.15 ± 1.2% | 882.56 ± 0.6% | 29794.80 ± 0.8% | 731.19 ± 0.2% | 0.96 | 1.00 | 1.59 | 1.19 |
| literal: one of four words | 26 | 406.58 ± 0.4% | 444.98 ± 0.3% | 587.14 ± 0.1% | 48.98 ± 0.9% | 242.00 ± 2.9% | 355.51 ± 0.1% | 15810.16 ± 0.3% | 407.27 ± 0.3% | 0.91 | 1.00 | 8.30 | 1.68 |
| literal: a word in any case | 11 | 577.02 ± 0.3% | 596.62 ± 0.6% | 891.70 ± 0.4% | 15.63 ± 1.1% | 664.11 ± 2.7% | refused | 23888.27 ± 0.5% | 577.93 ± 0.5% | 0.97 | 1.00 | 36.92 | 0.87 |
| literal: an href attribute | 12 | 438.07 ± 0.5% | 445.98 ± 0.5% | 590.18 ± 0.4% | 14.31 ± 5.1% | 503.04 ± 1.1% | 755.58 ± 2.4% | 22343.64 ± 0.2% | 438.92 ± 0.3% | 0.98 | 1.00 | 30.61 | 0.87 |
| literal: a word, second text | 10 | 678.45 ± 0.3% | 708.40 ± 0.2% | 1129.36 ± 0.1% | 408.55 ± 0.4% | 540.43 ± 0.8% | 796.90 ± 0.5% | 27731.14 ± 1.1% | 678.69 ± 0.2% | 0.96 | 1.00 | 1.66 | 1.26 |
| class: two capitalized words | 23 | 507.57 ± 0.6% | 526.19 ± 0.2% | 732.70 ± 0.6% | 99.56 ± 0.2% | 496.78 ± 1.6% | 742.21 ± 0.5% | 6341.40 ± 0.3% | 508.16 ± 0.6% | 0.96 | 1.00 | 5.10 | 1.02 |
| class: a word that ends in ing | 9 | 702.56 ± 0.3% | 746.60 ± 0.5% | 1223.36 ± 0.4% | 130.68 ± 0.9% | 754.91 ± 2.2% | 1104.92 ± 2.2% | 15850.98 ± 0.1% | 701.92 ± 0.2% | 0.94 | 1.00 | 5.38 | 0.93 |
| class: a word in capitals | 16 | 594.02 ± 0.4% | 619.41 ± 0.3% | 910.41 ± 0.2% | 133.83 ± 0.8% | 758.32 ± 2.9% | 1017.65 ± 3.5% | 8345.98 ± 0.3% | 593.71 ± 0.1% | 0.96 | 1.00 | 4.44 | 0.78 |
| class: a number | 6 | 777.24 ± 0.5% | 819.05 ± 0.3% | 1399.31 ± 0.1% | 41.80 ± 0.6% | 1397.03 ± 1.6% | 1843.48 ± 1.6% | 22959.10 ± 0.2% | 777.03 ± 0.5% | 0.95 | 1.00 | 18.60 | 0.56 |
| class: two capitalized words, second text | 23 | 507.28 ± 0.9% | 525.61 ± 1.0% | 732.99 ± 0.4% | 101.07 ± 0.5% | 498.73 ± 2.0% | 734.08 ± 0.5% | 6339.52 ± 0.2% | 508.27 ± 0.5% | 0.97 | 1.00 | 5.02 | 1.02 |
| other: a word between two words | 13 | 642.72 ± 0.5% | 653.72 ± 0.3% | 993.82 ± 0.2% | 134.24 ± 0.8% | 505.17 ± 1.3% | 811.15 ± 0.5% | 14772.99 ± 0.3% | 642.70 ± 0.3% | 0.98 | 1.00 | 4.79 | 1.27 |
| other: a number before a unit, second text | 15 | 506.37 ± 0.4% | 540.59 ± 0.5% | 758.85 ± 0.4% | 39.39 ± 0.5% | 637.77 ± 0.7% | 892.87 ± 0.4% | 15277.78 ± 0.1% | 506.38 ± 0.2% | 0.94 | 1.00 | 12.85 | 0.79 |
| other: a heading's start tag | 13 | 433.16 ± 0.7% | 440.06 ± 0.4% | 584.89 ± 0.4% | 10.46 ± 3.5% | 633.95 ± 0.8% | 871.07 ± 0.1% | 18526.45 ± 0.1% | 433.17 ± 0.7% | 0.98 | 1.00 | 41.41 | 0.68 |
| other: a whole word | 11 | 704.12 ± 0.2% | 720.77 ± 0.9% | 1159.08 ± 0.3% | 119.16 ± 0.3% | 570.51 ± 1.3% | 819.20 ± 0.5% | 27164.55 ± 0.7% | 704.39 ± 0.2% | 0.98 | 1.00 | 5.91 | 1.23 |
| other: a line's first word, second text | 17 | 631.36 ± 0.8% | 653.12 ± 0.2% | 983.54 ± 0.1% | 126.55 ± 0.2% | 703.30 ± 10.0% | refused | refused | 629.65 ± 0.3% | 0.97 | 1.00 | 4.99 | 0.90 |
| other: fourteen octets before an x | 16 | 119.38 ± 0.9% | 160.73 ± 0.8% | 187.76 ± 0.7% | 6.85 ± 2.0% | 454.27 ± 0.8% | 415.87 ± 0.8% | 13022.98 ± 0.2% | 119.26 ± 0.7% | 0.74 | 1.00 | 17.43 | 0.26 |
| other: a Greek word | 8 | 724.79 ± 0.2% | 775.94 ± 0.4% | 1281.69 ± 0.2% | 11.54 ± 17.5% | 1378.21 ± 2.6% | 1725.44 ± 0.6% | refused | 725.94 ± 0.2% | 0.93 | 1.00 | 62.83 | 0.53 |

