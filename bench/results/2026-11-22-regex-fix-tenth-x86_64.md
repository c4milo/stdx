# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
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
| literal: a word | 217 | 36142.45 ± 1.8% | 892.27 ± 6.8% | 20.45 ± 46.9% | 32694.18 ± 1.1% | 9014.44 ± 8.5% | 10.89 ± 0.2% | 77.02 ± 2.6% | 35360.15 ± 3.3% | 40.51 | 1.02 | 1.11 | 4.01 |
| literal: a word that is not there | 0 | 53399.81 ± 2.7% | 906.36 ± 1.2% | 20.45 ± 2.2% | 38901.81 ± 20.9% | 30317.72 ± 2.7% | 10.80 ± 1.3% | 72.77 ± 6.7% | 53364.29 ± 2.6% | 58.92 | 1.00 | 1.37 | 1.76 |
| literal: one of four words | 661 | 9934.82 ± 0.3% | 867.56 ± 0.3% | 11.23 ± 0.4% | 9556.45 ± 1.0% | 18.76 ± 0.6% | 3.96 ± 0.4% | 6.51 ± 3.5% | 9986.45 ± 0.5% | 11.45 | 0.99 | 1.04 | 529.59 |
| literal: a word in any case | 217 | 26482.24 ± 1.7% | 894.58 ± 0.3% | 15.89 ± 0.4% | 9401.10 ± 3.5% | 36.67 ± 0.4% | refused | differs | 26303.41 ± 0.7% | 29.60 | 1.01 | 2.82 | 722.21 |
| literal: an href attribute | 33 | 36463.70 ± 2.0% | 901.18 ± 1.0% | 19.40 ± 0.4% | 24891.05 ± 0.7% | 2057.99 ± 0.5% | 8.30 ± 0.3% | 67.43 ± 3.3% | 35883.41 ± 0.4% | 40.46 | 1.02 | 1.46 | 17.72 |
| literal: a word, second text | 123 | 36289.53 ± 1.4% | 899.24 ± 0.1% | 20.25 ± 0.4% | 28698.02 ± 0.6% | 7108.01 ± 8.2% | 11.86 ± 0.5% | 65.91 ± 2.7% | 36243.19 ± 1.2% | 40.36 | 1.00 | 1.26 | 5.11 |
| class: two capitalized words | 1331 | 775.73 ± 0.2% | 814.69 ± 0.2% | 19.21 ± 0.3% | 507.03 ± 0.1% | 33.77 ± 0.7% | 9.41 ± 0.7% | 58.89 ± 0.4% | 775.55 ± 0.2% | 0.95 | 1.00 | 1.53 | 22.97 |
| class: a word that ends in ing | 3399 | 742.10 ± 1.0% | 742.80 ± 0.2% | 13.95 ± 0.9% | 473.60 ± 0.2% | 25.45 ± 5.3% | 5.34 ± 0.3% | 17.12 ± 0.6% | 742.05 ± 0.4% | 1.00 | 1.00 | 1.57 | 29.16 |
| class: a word in capitals | 2332 | 978.87 ± 0.1% | 797.41 ± 0.1% | 20.22 ± 0.4% | 496.62 ± 0.7% | 35.75 ± 10.4% | 10.48 ± 0.3% | 77.39 ± 0.1% | 978.78 ± 1.8% | 1.23 | 1.00 | 1.97 | 27.38 |
| class: a number | 8288 | 1504.95 ± 0.1% | 660.72 ± 0.1% | 20.09 ± 0.4% | 1522.83 ± 0.1% | 35.51 ± 14.0% | 0.34 ± 0.1% | 56.63 ± 0.3% | 1517.55 ± 0.2% | 2.28 | 0.99 | 0.99 | 42.38 |
| class: two capitalized words, second text | 5359 | 585.17 ± 0.1% | 582.64 ± 0.2% | 17.66 ± 0.3% | 421.02 ± 0.1% | 29.93 ± 0.8% | 10.63 ± 0.2% | 54.33 ± 5.0% | 584.58 ± 0.2% | 1.00 | 1.00 | 1.39 | 19.55 |
| other: a word between two words | 6104 | 693.38 ± 1.8% | 629.75 ± 1.5% | 17.57 ± 2.3% | 721.19 ± 3.3% | 98.54 ± 9.9% | 7.27 ± 1.3% | 59.36 ± 2.3% | 681.25 ± 3.1% | 1.10 | 1.02 | 0.96 | 7.04 |
| other: a number before a unit, second text | 1481 | 7300.89 ± 6.6% | 830.86 ± 0.1% | 19.22 ± 0.8% | 6957.75 ± 0.5% | 34.43 ± 1.9% | 11.13 ± 0.2% | 58.56 ± 1.8% | 7538.11 ± 6.1% | 8.79 | 0.97 | 1.05 | 212.08 |
| other: a heading's start tag | 110 | 19925.07 ± 2.5% | 893.54 ± 1.0% | 19.82 ± 0.2% | 2050.87 ± 0.4% | 1474.37 ± 3.3% | 10.12 ± 0.9% | 78.32 ± 4.2% | 19984.18 ± 1.2% | 22.30 | 1.00 | 9.72 | 13.51 |
| other: a whole word | 217 | 24359.92 ± 2.7% | 894.47 ± 0.3% | 20.81 ± 0.2% | 23489.31 ± 1.4% | 41.09 ± 0.3% | 9.56 ± 0.1% | 46.31 ± 0.4% | 24077.09 ± 1.3% | 27.23 | 1.01 | 1.04 | 592.77 |
| other: a line's first word, second text | 3716 | 1962.48 ± 4.0% | 727.43 ± 0.1% | 24.48 ± 0.2% | 1784.10 ± 4.3% | 54.32 ± 7.6% | refused | refused | 1956.98 ± 2.0% | 2.70 | 1.00 | 1.10 | 36.13 |
| other: fourteen octets before an x | 87 | 27971.55 ± 0.6% | 1.33 ± 0.2% | 1.32 ± 0.2% | 2797.97 ± 0.4% | 9.07 ± 0.1% | differs | 17.32 ± 2.7% | 27784.07 ± 0.7% | 20985.52 | 1.01 | 10.00 | 3082.57 |
| other: a Greek word | 21815 | 392.39 ± 0.8% | 272.77 ± 0.4% | 24.67 ± 0.2% | 269.43 ± 0.3% | 38.99 ± 8.4% | differs | refused | 392.81 ± 1.6% | 1.44 | 1.00 | 1.46 | 10.06 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.68 ± 1.1% | 26.29 ± 1.3% | 0.47 ± 0.5% | 20.09 ± 0.1% | 2.33 ± 0.3% | differs | 3.47 ± 3.2% | 26.67 ± 1.6% | 1.01 | 1.00 | 1.33 | 11.47 |
| a UUID | 32895 | 22.02 ± 0.1% | 22.01 ± 0.4% | 0.57 ± 4.0% | 14.44 ± 0.5% | 2.43 ± 0.8% | 0.43 ± 0.5% | 3.16 ± 0.6% | 21.64 ± 0.1% | 1.00 | 1.02 | 1.53 | 9.04 |
| an IPv4 address | 33176 | 37.36 ± 2.9% | 37.34 ± 3.3% | 1.86 ± 1.2% | 30.00 ± 4.6% | 5.61 ± 5.1% | differs | 3.29 ± 1.5% | 38.41 ± 1.2% | 1.00 | 0.97 | 1.25 | 6.66 |
| a date and time | 32954 | 33.56 ± 0.1% | 33.51 ± 0.2% | 1.32 ± 3.4% | 22.06 ± 0.5% | 6.48 ± 0.2% | 0.76 ± 0.5% | 6.01 ± 6.0% | 33.56 ± 0.4% | 1.00 | 1.00 | 1.52 | 5.18 |
| a field path | 32606 | 29.70 ± 1.1% | 29.81 ± 1.6% | 0.75 ± 0.4% | 23.41 ± 3.2% | 2.88 ± 0.3% | differs | 2.33 ± 1.1% | 29.80 ± 0.9% | 1.00 | 1.00 | 1.27 | 10.31 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.87 ± 1.9% | 9.06 ± 1.8% | 8.97 ± 2.3% | 10.74 ± 0.2% | 4.54 ± 7.5% | 0.63 ± 0.3% | none | 9.09 ± 2.1% | 0.98 | 0.98 | 0.83 | 1.96 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 238.49 ± 0.5% | 239.14 ± 0.5% | 278.17 ± 1.0% | 79.91 ± 3.6% | 180.22 ± 5.6% | 544.36 ± 5.3% | 3525.00 ± 1.0% | 238.07 ± 0.5% | 1.00 | 1.00 | 2.98 | 1.32 |
| a UUID | 62 | 158.53 ± 0.6% | 158.90 ± 0.2% | 180.79 ± 0.2% | 46.79 ± 1.0% | 88.71 ± 3.2% | 203.92 ± 2.4% | 3921.26 ± 0.8% | 158.50 ± 0.2% | 1.00 | 1.00 | 3.39 | 1.79 |
| an IPv4 address | 29 | 427.05 ± 3.6% | 428.81 ± 3.4% | 577.07 ± 3.6% | 69.10 ± 2.5% | 110.70 ± 3.7% | 331.51 ± 3.6% | 6659.86 ± 5.1% | 427.90 ± 4.1% | 1.00 | 1.00 | 6.18 | 3.86 |
| a date and time | 56 | 305.36 ± 2.5% | 306.89 ± 2.5% | 375.72 ± 2.4% | 69.26 ± 3.8% | 120.83 ± 5.3% | 375.47 ± 2.6% | 3882.63 ± 1.7% | 305.23 ± 1.0% | 0.99 | 1.00 | 4.41 | 2.53 |
| a field path | 39 | 253.80 ± 0.2% | 254.51 ± 0.4% | 298.41 ± 0.3% | 74.93 ± 1.8% | 171.05 ± 0.9% | 586.10 ± 0.8% | 4436.63 ± 3.3% | 253.65 ± 0.9% | 1.00 | 1.00 | 3.39 | 1.48 |
| literal: a word | 7 | 706.75 ± 0.4% | 720.96 ± 0.4% | 1224.90 ± 0.6% | 489.19 ± 1.3% | 573.26 ± 5.1% | 1226.99 ± 6.4% | 24648.95 ± 2.6% | 704.82 ± 10.4% | 0.98 | 1.00 | 1.44 | 1.23 |
| literal: a word that is not there | 8 | 684.36 ± 1.4% | 700.23 ± 0.6% | 1151.62 ± 9.0% | 457.03 ± 0.2% | 550.44 ± 1.8% | 1169.73 ± 0.5% | 23506.38 ± 0.6% | 683.56 ± 0.3% | 0.98 | 1.00 | 1.50 | 1.24 |
| literal: one of four words | 26 | 367.56 ± 0.3% | 399.07 ± 0.7% | 521.36 ± 0.2% | 44.82 ± 0.6% | 218.29 ± 2.2% | 457.61 ± 6.0% | 9739.44 ± 1.4% | 367.64 ± 0.4% | 0.92 | 1.00 | 8.20 | 1.68 |
| literal: a word in any case | 11 | 531.06 ± 0.5% | 543.54 ± 0.5% | 798.48 ± 0.5% | 15.16 ± 2.2% | 599.33 ± 2.4% | refused | 18169.81 ± 0.3% | 530.63 ± 0.3% | 0.98 | 1.00 | 35.04 | 0.89 |
| literal: an href attribute | 12 | 397.43 ± 0.2% | 400.80 ± 0.4% | 529.58 ± 1.8% | 37.38 ± 8.6% | 425.18 ± 2.6% | 973.80 ± 6.5% | 16818.91 ± 0.5% | 397.27 ± 6.2% | 0.99 | 1.00 | 10.63 | 0.93 |
| literal: a word, second text | 10 | 634.99 ± 0.6% | 653.92 ± 0.9% | 1033.36 ± 0.8% | 414.45 ± 1.6% | 483.13 ± 3.2% | 1027.83 ± 0.5% | 20634.39 ± 2.3% | 634.86 ± 0.2% | 0.97 | 1.00 | 1.53 | 1.31 |
| class: two capitalized words | 23 | 483.17 ± 0.2% | 500.55 ± 3.3% | 691.61 ± 3.2% | 95.69 ± 0.5% | 447.88 ± 2.2% | 995.73 ± 1.3% | 6099.53 ± 1.6% | 483.33 ± 0.2% | 0.97 | 1.00 | 5.05 | 1.08 |
| class: a word that ends in ing | 9 | 640.01 ± 0.3% | 686.52 ± 0.4% | 1091.30 ± 1.5% | 114.05 ± 7.6% | 620.73 ± 2.3% | 1466.07 ± 2.0% | 14654.26 ± 0.2% | 640.30 ± 0.4% | 0.93 | 1.00 | 5.61 | 1.03 |
| class: a word in capitals | 16 | 546.93 ± 0.2% | 572.03 ± 3.0% | 827.59 ± 0.2% | 121.91 ± 1.2% | 652.47 ± 0.9% | 1304.93 ± 2.8% | 8148.22 ± 0.3% | 546.78 ± 0.1% | 0.96 | 1.00 | 4.49 | 0.84 |
| class: a number | 6 | 714.91 ± 0.3% | 756.99 ± 1.0% | 1276.35 ± 0.4% | 37.51 ± 1.3% | 1189.73 ± 1.7% | 2276.94 ± 5.9% | 19558.66 ± 0.3% | 714.50 ± 0.3% | 0.94 | 1.00 | 19.06 | 0.60 |
| class: two capitalized words, second text | 23 | 482.94 ± 0.4% | 500.36 ± 0.3% | 692.79 ± 1.0% | 94.69 ± 0.7% | 448.57 ± 1.4% | 965.04 ± 1.5% | 6084.09 ± 0.6% | 482.58 ± 0.3% | 0.97 | 1.00 | 5.10 | 1.08 |
| other: a word between two words | 13 | 585.05 ± 0.6% | 591.41 ± 0.4% | 878.88 ± 0.6% | 121.39 ± 2.0% | 430.67 ± 1.7% | 1026.09 ± 2.5% | 12386.07 ± 0.5% | 584.77 ± 0.6% | 0.99 | 1.00 | 4.82 | 1.36 |
| other: a number before a unit, second text | 15 | 474.29 ± 1.4% | 503.58 ± 1.2% | 708.56 ± 0.5% | 34.60 ± 1.3% | 529.10 ± 1.6% | 1101.07 ± 3.6% | 12639.52 ± 1.7% | 475.19 ± 0.4% | 0.94 | 1.00 | 13.71 | 0.90 |
| other: a heading's start tag | 13 | 400.13 ± 0.2% | 402.31 ± 1.0% | 541.34 ± 0.5% | 35.83 ± 1.7% | 516.40 ± 1.8% | 1060.36 ± 0.4% | 14951.26 ± 1.6% | 400.06 ± 0.2% | 0.99 | 1.00 | 11.17 | 0.77 |
| other: a whole word | 11 | 606.69 ± 1.4% | 621.40 ± 1.0% | 942.24 ± 0.9% | 113.65 ± 0.9% | 499.03 ± 2.8% | 1043.67 ± 2.7% | 18812.56 ± 5.9% | 605.82 ± 0.5% | 0.98 | 1.00 | 5.34 | 1.22 |
| other: a line's first word, second text | 17 | 581.87 ± 8.6% | 615.57 ± 0.5% | 917.28 ± 0.4% | 114.22 ± 7.7% | 598.94 ± 7.9% | refused | refused | 580.84 ± 3.7% | 0.95 | 1.00 | 5.09 | 0.97 |
| other: fourteen octets before an x | 16 | 94.18 ± 3.2% | 120.34 ± 6.0% | 141.19 ± 0.4% | 14.41 ± 0.3% | 390.65 ± 6.9% | 459.27 ± 1.1% | 11728.37 ± 6.8% | 94.24 ± 0.2% | 0.78 | 1.00 | 6.54 | 0.24 |
| other: a Greek word | 8 | 659.71 ± 1.0% | 705.16 ± 0.2% | 1159.15 ± 0.5% | 47.18 ± 0.5% | 1172.90 ± 3.2% | 2167.44 ± 1.7% | refused | 659.38 ± 0.7% | 0.94 | 1.00 | 13.98 | 0.56 |

