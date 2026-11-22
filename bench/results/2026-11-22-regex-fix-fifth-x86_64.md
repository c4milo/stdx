# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063430415 |
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
| literal: a word | 217 | 42758.18 ± 0.6% | 1028.96 ± 0.4% | 31.39 ± 0.3% | 39997.93 ± 1.0% | 11863.52 ± 2.9% | 12.91 ± 0.3% | 104.42 ± 0.2% | 42728.52 ± 1.1% | 41.55 | 1.00 | 1.07 | 3.60 |
| literal: a word that is not there | 0 | 59588.74 ± 0.6% | 1038.64 ± 0.2% | 31.41 ± 0.7% | 45341.86 ± 0.2% | 43880.39 ± 3.8% | 12.80 ± 0.4% | 94.99 ± 12.0% | 59746.48 ± 0.5% | 57.37 | 1.00 | 1.31 | 1.36 |
| literal: one of four words | 661 | 13223.04 ± 0.4% | 1006.41 ± 0.2% | 17.12 ± 4.2% | 11488.19 ± 0.2% | 24.20 ± 0.8% | 4.46 ± 0.9% | 8.02 ± 13.0% | 13231.20 ± 0.2% | 13.14 | 1.00 | 1.15 | 546.44 |
| literal: a word in any case | 217 | 36443.40 ± 0.8% | 1026.83 ± 0.2% | 24.21 ± 2.6% | 11338.29 ± 1.4% | 47.35 ± 1.4% | refused | differs | 36840.57 ± 0.8% | 35.49 | 0.99 | 3.21 | 769.63 |
| literal: an href attribute | 33 | 44282.59 ± 1.6% | 1034.07 ± 0.2% | 30.25 ± 0.3% | 35172.39 ± 0.4% | 3046.01 ± 16.3% | 9.67 ± 0.3% | 87.36 ± 0.1% | 44350.61 ± 0.7% | 42.82 | 1.00 | 1.26 | 14.54 |
| literal: a word, second text | 123 | 47682.78 ± 0.2% | 1029.82 ± 0.1% | 30.81 ± 2.5% | 40920.93 ± 0.6% | 11241.39 ± 7.7% | 14.50 ± 0.5% | 87.62 ± 0.3% | 47658.61 ± 0.2% | 46.30 | 1.00 | 1.17 | 4.24 |
| class: two capitalized words | 1331 | 915.65 ± 0.1% | 950.35 ± 0.2% | 29.14 ± 2.8% | 576.35 ± 0.3% | 44.89 ± 4.2% | 11.04 ± 0.2% | 80.35 ± 0.4% | 912.80 ± 0.9% | 0.96 | 1.00 | 1.59 | 20.40 |
| class: a word that ends in ing | 3399 | 873.62 ± 0.2% | 871.24 ± 0.8% | 20.80 ± 0.5% | 540.74 ± 2.5% | 33.03 ± 12.3% | 6.22 ± 0.3% | 20.05 ± 1.1% | 874.23 ± 0.1% | 1.00 | 1.00 | 1.62 | 26.45 |
| class: a word in capitals | 2332 | 1146.26 ± 0.5% | 930.69 ± 1.3% | 30.72 ± 9.4% | 566.29 ± 7.0% | 47.89 ± 9.3% | 12.53 ± 0.2% | 100.82 ± 0.3% | 1144.77 ± 1.9% | 1.23 | 1.00 | 2.02 | 23.94 |
| class: a number | 8288 | 1875.74 ± 0.1% | 791.48 ± 0.6% | 31.14 ± 0.5% | 1853.60 ± 0.6% | 48.57 ± 17.4% | 0.39 ± 0.6% | 73.09 ± 2.9% | 1870.16 ± 0.7% | 2.37 | 1.00 | 1.01 | 38.62 |
| class: two capitalized words, second text | 5359 | 690.69 ± 0.3% | 691.31 ± 0.2% | 26.45 ± 2.9% | 480.27 ± 0.3% | 39.25 ± 7.7% | 12.72 ± 1.0% | 74.36 ± 0.3% | 687.73 ± 0.4% | 1.00 | 1.00 | 1.44 | 17.60 |
| other: a word between two words | 6104 | 835.30 ± 1.2% | 737.08 ± 0.3% | 26.39 ± 0.7% | 833.06 ± 0.3% | 129.36 ± 8.3% | 8.55 ± 3.0% | 82.03 ± 0.4% | 836.42 ± 2.3% | 1.13 | 1.00 | 1.00 | 6.46 |
| other: a number before a unit, second text | 1481 | 10601.32 ± 0.2% | 978.02 ± 0.4% | 29.10 ± 3.5% | 9318.60 ± 0.5% | 45.72 ± 6.1% | 13.20 ± 0.1% | 77.99 ± 4.6% | 10558.42 ± 0.8% | 10.84 | 1.00 | 1.14 | 231.88 |
| other: a heading's start tag | 110 | 25586.60 ± 0.5% | 1024.09 ± 0.3% | 30.75 ± 0.3% | 2662.00 ± 1.4% | 2016.92 ± 2.7% | 11.83 ± 0.3% | 107.12 ± 1.1% | 25595.37 ± 0.4% | 24.98 | 1.00 | 9.61 | 12.69 |
| other: a whole word | 217 | 30778.38 ± 1.0% | 1025.16 ± 0.3% | 32.30 ± 0.3% | 29090.06 ± 0.1% | 53.68 ± 7.2% | 11.18 ± 4.5% | 62.88 ± 0.8% | 30760.30 ± 0.5% | 30.02 | 1.00 | 1.06 | 573.37 |
| other: a line's first word, second text | 3716 | 2648.29 ± 1.5% | 852.40 ± 0.7% | 36.67 ± 0.6% | 2427.81 ± 4.6% | 71.62 ± 3.3% | refused | refused | 2621.81 ± 4.4% | 3.11 | 1.01 | 1.09 | 36.98 |
| other: fourteen octets before an x | 87 | 37350.04 ± 0.3% | 1.74 ± 1.7% | 1.70 ± 0.6% | 3368.12 ± 1.1% | 11.70 ± 2.1% | differs | 21.94 ± 3.4% | 37237.48 ± 0.6% | 21522.05 | 1.00 | 11.09 | 3191.95 |
| other: a Greek word | 21815 | 467.32 ± 0.4% | 334.74 ± 1.3% | 34.53 ± 0.7% | 305.53 ± 0.7% | 56.31 ± 8.7% | differs | refused | 466.04 ± 0.4% | 1.40 | 1.00 | 1.53 | 8.30 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.79 ± 0.2% | 30.61 ± 4.6% | 0.60 ± 4.8% | 25.65 ± 0.4% | 2.83 ± 0.6% | differs | 4.02 ± 2.7% | 30.76 ± 4.8% | 1.01 | 1.00 | 1.20 | 10.87 |
| a UUID | 32895 | 25.79 ± 0.1% | 25.79 ± 0.9% | 0.75 ± 0.9% | 18.91 ± 0.5% | 3.05 ± 2.1% | 0.52 ± 0.6% | 3.80 ± 1.2% | 25.74 ± 0.5% | 1.00 | 1.00 | 1.36 | 8.47 |
| an IPv4 address | 33176 | 43.86 ± 1.1% | 44.12 ± 0.5% | 2.40 ± 1.2% | 36.30 ± 1.3% | 6.98 ± 7.0% | differs | 4.21 ± 2.1% | 44.33 ± 4.7% | 0.99 | 0.99 | 1.21 | 6.28 |
| a date and time | 32954 | 39.15 ± 7.3% | 38.66 ± 3.2% | 1.79 ± 0.1% | 29.46 ± 0.7% | 8.51 ± 2.1% | 0.91 ± 1.9% | 7.82 ± 6.5% | 39.48 ± 5.5% | 1.01 | 0.99 | 1.33 | 4.60 |
| a field path | 32606 | 34.75 ± 0.4% | 34.71 ± 0.4% | 0.95 ± 0.6% | 28.73 ± 0.5% | 3.56 ± 1.9% | differs | 2.97 ± 2.6% | 34.69 ± 0.5% | 1.00 | 1.00 | 1.21 | 9.76 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.48 ± 0.9% | 11.33 ± 1.9% | 11.47 ± 6.9% | 13.55 ± 1.5% | 5.81 ± 1.8% | 0.76 ± 1.6% | none | 11.45 ± 1.3% | 1.01 | 1.00 | 0.85 | 1.98 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 305.47 ± 0.7% | 306.79 ± 0.5% | 355.50 ± 0.6% | 100.33 ± 1.2% | 236.48 ± 1.4% | 692.58 ± 6.3% | 4674.34 ± 0.4% | 305.23 ± 6.9% | 1.00 | 1.00 | 3.04 | 1.29 |
| a UUID | 62 | 204.41 ± 0.2% | 205.13 ± 0.1% | 233.16 ± 0.6% | 57.13 ± 1.5% | 116.62 ± 2.2% | 248.70 ± 3.8% | 5064.18 ± 0.7% | 204.29 ± 0.1% | 1.00 | 1.00 | 3.58 | 1.75 |
| an IPv4 address | 29 | 555.06 ± 0.7% | 561.47 ± 0.4% | 757.20 ± 0.3% | 87.48 ± 0.6% | 145.77 ± 2.8% | 384.06 ± 2.6% | 8424.12 ± 0.8% | 555.01 ± 0.3% | 0.99 | 1.00 | 6.35 | 3.81 |
| a date and time | 56 | 396.50 ± 0.3% | 399.91 ± 0.2% | 486.20 ± 0.7% | 85.54 ± 7.2% | 157.57 ± 15.0% | 451.00 ± 0.9% | 5243.25 ± 0.5% | 397.00 ± 0.9% | 0.99 | 1.00 | 4.64 | 2.52 |
| a field path | 39 | 319.27 ± 5.1% | 321.10 ± 2.6% | 374.01 ± 0.5% | 93.96 ± 1.2% | 224.79 ± 16.8% | 736.60 ± 5.0% | 5602.52 ± 12.0% | 318.84 ± 0.9% | 0.99 | 1.00 | 3.40 | 1.42 |
| literal: a word | 7 | 925.92 ± 0.5% | 958.33 ± 0.3% | 1597.63 ± 6.5% | 657.40 ± 3.0% | 788.27 ± 3.2% | 1623.39 ± 4.2% | 26598.27 ± 5.8% | 924.29 ± 0.4% | 0.97 | 1.00 | 1.41 | 1.17 |
| literal: a word that is not there | 8 | 890.78 ± 1.9% | 918.88 ± 0.7% | 1500.67 ± 10.6% | 600.30 ± 9.2% | 760.93 ± 5.0% | 1520.94 ± 5.0% | 26302.74 ± 1.5% | 889.89 ± 0.5% | 0.97 | 1.00 | 1.48 | 1.17 |
| literal: one of four words | 26 | 464.41 ± 0.6% | 505.60 ± 1.0% | 654.04 ± 4.4% | 58.38 ± 6.4% | 287.04 ± 6.7% | 564.18 ± 1.2% | 15532.53 ± 1.7% | 465.05 ± 0.6% | 0.92 | 1.00 | 7.96 | 1.62 |
| literal: a word in any case | 11 | 685.98 ± 0.3% | 711.08 ± 0.5% | 1027.03 ± 1.2% | 19.23 ± 0.6% | 822.86 ± 2.0% | refused | 22643.84 ± 0.4% | 687.01 ± 1.4% | 0.96 | 1.00 | 35.66 | 0.83 |
| literal: an href attribute | 12 | 514.60 ± 1.8% | 526.30 ± 0.5% | 692.53 ± 0.8% | 50.57 ± 1.2% | 547.60 ± 22.7% | 1194.26 ± 1.1% | 19987.09 ± 0.8% | 516.26 ± 0.6% | 0.98 | 1.00 | 10.18 | 0.94 |
| literal: a word, second text | 10 | 824.87 ± 0.2% | 851.83 ± 0.4% | 1344.83 ± 0.4% | 544.51 ± 0.7% | 644.20 ± 21.3% | 1299.01 ± 0.7% | 24670.34 ± 0.5% | 823.37 ± 0.4% | 0.97 | 1.00 | 1.51 | 1.28 |
| class: two capitalized words | 23 | 608.19 ± 1.0% | 636.94 ± 1.0% | 864.41 ± 0.4% | 120.06 ± 1.0% | 593.13 ± 3.7% | 1251.94 ± 6.1% | 7564.57 ± 0.7% | 608.23 ± 0.4% | 0.95 | 1.00 | 5.07 | 1.03 |
| class: a word that ends in ing | 9 | 824.08 ± 0.4% | 884.89 ± 0.7% | 1408.31 ± 0.4% | 149.63 ± 1.2% | 841.08 ± 2.0% | 1842.82 ± 0.3% | 16874.25 ± 0.3% | 824.41 ± 0.3% | 0.93 | 1.00 | 5.51 | 0.98 |
| class: a word in capitals | 16 | 706.43 ± 0.4% | 752.17 ± 5.8% | 1097.37 ± 0.8% | 155.24 ± 1.0% | 884.69 ± 3.5% | 1618.61 ± 3.4% | 9878.44 ± 0.6% | 705.92 ± 0.4% | 0.94 | 1.00 | 4.55 | 0.80 |
| class: a number | 6 | 913.69 ± 0.3% | 975.54 ± 1.0% | 1653.24 ± 0.4% | 48.99 ± 0.7% | 1640.91 ± 13.7% | 2946.41 ± 3.1% | 21856.89 ± 0.3% | 913.27 ± 0.8% | 0.94 | 1.00 | 18.65 | 0.56 |
| class: two capitalized words, second text | 23 | 607.76 ± 0.7% | 637.28 ± 1.3% | 871.24 ± 1.4% | 119.76 ± 0.9% | 582.92 ± 21.5% | 1233.82 ± 6.3% | 7550.33 ± 0.1% | 608.91 ± 0.4% | 0.95 | 1.00 | 5.07 | 1.04 |
| other: a word between two words | 13 | 757.75 ± 0.1% | 771.30 ± 0.5% | 1134.54 ± 0.9% | 155.96 ± 0.7% | 577.54 ± 24.9% | 1332.22 ± 0.6% | 15598.81 ± 0.3% | 756.93 ± 0.4% | 0.98 | 1.00 | 4.86 | 1.31 |
| other: a number before a unit, second text | 15 | 598.40 ± 0.6% | 638.35 ± 1.0% | 880.74 ± 0.7% | 45.49 ± 1.5% | 723.68 ± 11.1% | 1461.02 ± 1.0% | 15843.71 ± 1.2% | 599.36 ± 0.3% | 0.94 | 1.00 | 13.15 | 0.83 |
| other: a heading's start tag | 13 | 513.78 ± 0.7% | 518.37 ± 0.6% | 703.23 ± 0.4% | 47.85 ± 0.7% | 659.92 ± 10.1% | 1299.62 ± 4.7% | 17768.16 ± 5.7% | 512.89 ± 4.2% | 0.99 | 1.00 | 10.74 | 0.78 |
| other: a whole word | 11 | 797.49 ± 1.3% | 821.17 ± 0.6% | 1264.28 ± 0.7% | 145.59 ± 0.5% | 683.44 ± 1.2% | 1337.13 ± 0.7% | 25784.32 ± 0.9% | 791.77 ± 0.9% | 0.97 | 1.01 | 5.48 | 1.17 |
| other: a line's first word, second text | 17 | 743.58 ± 0.7% | 779.44 ± 0.4% | 1154.77 ± 0.3% | 146.49 ± 2.1% | 796.48 ± 25.0% | refused | refused | 741.44 ± 0.9% | 0.95 | 1.00 | 5.08 | 0.93 |
| other: fourteen octets before an x | 16 | 126.66 ± 0.2% | 174.00 ± 0.2% | 208.91 ± 0.6% | 17.78 ± 0.6% | 500.09 ± 4.8% | 571.03 ± 0.5% | 14013.83 ± 0.5% | 126.51 ± 0.8% | 0.73 | 1.00 | 7.12 | 0.25 |
| other: a Greek word | 8 | 828.65 ± 0.5% | 898.75 ± 0.4% | 1441.98 ± 0.3% | 62.95 ± 0.9% | 1644.81 ± 1.2% | 2746.17 ± 1.0% | refused | 827.57 ± 1.7% | 0.92 | 1.00 | 13.16 | 0.50 |

