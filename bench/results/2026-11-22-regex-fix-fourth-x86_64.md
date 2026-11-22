# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.88.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1016-aws |
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
| literal: a word | 217 | 36259.41 ± 0.6% | 1089.47 ± 0.7% | 35.79 ± 1.4% | 33311.58 ± 0.7% | 13012.33 ± 2.8% | 14.82 ± 0.2% | 115.83 ± 0.5% | 36168.03 ± 10.5% | 33.28 | 1.00 | 1.09 | 2.79 |
| literal: a word that is not there | 0 | 45954.01 ± 0.8% | 1100.37 ± 0.2% | 36.01 ± 0.7% | 36318.48 ± 0.4% | 40816.01 ± 0.5% | 14.35 ± 0.3% | 108.69 ± 0.6% | 45953.45 ± 0.1% | 41.76 | 1.00 | 1.27 | 1.13 |
| literal: one of four words | 661 | 12104.55 ± 56.3% | 1063.02 ± 4.4% | 20.00 ± 75.6% | 9820.19 ± 0.4% | 27.81 ± 0.7% | 4.32 ± 0.3% | 9.19 ± 53.5% | 12146.02 ± 56.9% | 11.39 | 1.00 | 1.23 | 435.23 |
| literal: a word in any case | 217 | 28807.33 ± 0.5% | 1084.72 ± 0.6% | 26.05 ± 2.1% | 10039.22 ± 0.7% | 57.93 ± 1.2% | refused | differs | 28654.03 ± 0.8% | 26.56 | 1.01 | 2.87 | 497.26 |
| literal: an href attribute | 33 | 34848.00 ± 0.4% | 1092.78 ± 0.5% | 32.07 ± 1.6% | 29644.39 ± 0.4% | 2598.31 ± 2.0% | 10.55 ± 0.7% | 98.82 ± 0.5% | 34859.73 ± 0.4% | 31.89 | 1.00 | 1.18 | 13.41 |
| literal: a word, second text | 123 | 36333.93 ± 0.5% | 1091.27 ± 0.2% | 35.02 ± 0.4% | 32143.09 ± 3.8% | 9145.31 ± 4.9% | 19.08 ± 0.6% | 96.47 ± 0.5% | 36278.52 ± 0.5% | 33.30 | 1.00 | 1.13 | 3.97 |
| class: two capitalized words | 1331 | 995.09 ± 0.3% | 1000.16 ± 0.2% | 33.21 ± 1.9% | 612.11 ± 0.6% | 47.98 ± 10.3% | 12.50 ± 0.5% | 81.34 ± 0.5% | 994.12 ± 0.5% | 0.99 | 1.00 | 1.63 | 20.74 |
| class: a word that ends in ing | 3399 | 914.28 ± 0.4% | 916.34 ± 0.2% | 22.15 ± 0.6% | 577.07 ± 0.3% | 35.58 ± 7.2% | 7.08 ± 0.4% | 22.67 ± 0.6% | 914.81 ± 0.4% | 1.00 | 1.00 | 1.58 | 25.70 |
| class: a word in capitals | 2332 | 1369.68 ± 1.0% | 983.84 ± 0.4% | 35.40 ± 1.1% | 604.05 ± 0.4% | 51.75 ± 0.5% | 15.03 ± 0.6% | 100.20 ± 1.2% | 1367.47 ± 0.5% | 1.39 | 1.00 | 2.27 | 26.47 |
| class: a number | 8288 | 2051.08 ± 0.5% | 835.88 ± 0.7% | 33.70 ± 2.2% | 2180.69 ± 1.9% | 48.75 ± 15.0% | 0.42 ± 0.3% | 70.63 ± 0.8% | 2051.37 ± 0.4% | 2.45 | 1.00 | 0.94 | 42.07 |
| class: two capitalized words, second text | 5359 | 727.98 ± 0.4% | 728.94 ± 0.3% | 29.86 ± 0.3% | 511.01 ± 0.3% | 39.77 ± 13.5% | 16.31 ± 0.4% | 73.99 ± 0.9% | 729.18 ± 0.3% | 1.00 | 1.00 | 1.42 | 18.31 |
| other: a word between two words | 6104 | 843.27 ± 0.5% | 777.11 ± 0.5% | 29.79 ± 1.1% | 878.67 ± 0.5% | 132.71 ± 12.6% | 9.57 ± 0.4% | 84.76 ± 0.5% | 844.34 ± 1.1% | 1.09 | 1.00 | 0.96 | 6.35 |
| other: a number before a unit, second text | 1481 | 9950.98 ± 1.9% | 1020.00 ± 0.3% | 33.32 ± 0.8% | 9784.29 ± 0.3% | 47.67 ± 7.9% | 16.97 ± 0.9% | 79.06 ± 1.0% | 9821.90 ± 2.4% | 9.76 | 1.01 | 1.02 | 208.75 |
| other: a heading's start tag | 110 | 21493.21 ± 0.7% | 1081.49 ± 0.4% | 34.16 ± 0.8% | 2654.57 ± 0.4% | 1886.31 ± 2.2% | 13.07 ± 0.8% | 117.08 ± 0.8% | 21494.48 ± 1.8% | 19.87 | 1.00 | 8.10 | 11.39 |
| other: a whole word | 217 | 27367.69 ± 0.3% | 1084.98 ± 0.6% | 34.97 ± 0.9% | 26485.62 ± 0.7% | 59.45 ± 0.8% | 12.51 ± 0.5% | 67.10 ± 0.6% | 27373.56 ± 0.3% | 25.22 | 1.00 | 1.03 | 460.33 |
| other: a line's first word, second text | 3716 | 2701.71 ± 0.5% | 898.88 ± 0.4% | 37.47 ± 0.7% | 2507.36 ± 0.7% | 78.94 ± 3.7% | refused | refused | 2688.74 ± 0.6% | 3.01 | 1.00 | 1.08 | 34.22 |
| other: fourteen octets before an x | 87 | 37252.89 ± 1.1% | 1.77 ± 0.7% | 1.74 ± 0.3% | 4153.37 ± 1.1% | 11.53 ± 0.6% | differs | 20.08 ± 2.0% | 36990.92 ± 2.6% | 21089.31 | 1.01 | 8.97 | 3231.34 |
| other: a Greek word | 21815 | 476.87 ± 0.7% | 347.58 ± 0.9% | 38.12 ± 1.0% | 318.71 ± 0.7% | 56.46 ± 7.5% | differs | refused | 473.23 ± 1.1% | 1.37 | 1.01 | 1.50 | 8.45 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.71 ± 1.5% | 30.65 ± 1.6% | 0.61 ± 0.5% | 28.58 ± 0.8% | 3.27 ± 2.1% | differs | 4.96 ± 1.7% | 30.66 ± 2.0% | 1.00 | 1.00 | 1.07 | 9.40 |
| a UUID | 32895 | 27.22 ± 1.1% | 27.19 ± 1.1% | 0.77 ± 0.5% | 21.15 ± 1.1% | 3.11 ± 0.4% | 0.71 ± 1.0% | 4.09 ± 0.8% | 27.01 ± 1.3% | 1.00 | 1.01 | 1.29 | 8.74 |
| an IPv4 address | 33176 | 41.73 ± 0.8% | 41.73 ± 0.4% | 2.47 ± 0.8% | 38.93 ± 0.8% | 7.86 ± 0.4% | differs | 4.59 ± 0.8% | 41.79 ± 0.6% | 1.00 | 1.00 | 1.07 | 5.31 |
| a date and time | 32954 | 40.25 ± 0.8% | 40.41 ± 0.8% | 1.76 ± 0.9% | 34.74 ± 0.4% | 10.04 ± 0.4% | 1.31 ± 0.7% | 9.02 ± 0.6% | 40.36 ± 0.9% | 1.00 | 1.00 | 1.16 | 4.01 |
| a field path | 32606 | 33.52 ± 1.0% | 33.58 ± 0.5% | 1.08 ± 0.8% | 30.66 ± 1.2% | 3.65 ± 0.6% | differs | 3.07 ± 0.5% | 33.42 ± 0.7% | 1.00 | 1.00 | 1.09 | 9.18 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.33 ± 0.4% | 11.28 ± 0.9% | 11.31 ± 1.1% | 14.64 ± 0.7% | 6.55 ± 0.8% | 1.03 ± 0.8% | none | 11.32 ± 0.8% | 1.00 | 1.00 | 0.77 | 1.73 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 350.36 ± 0.5% | 353.21 ± 0.9% | 405.26 ± 0.6% | 115.88 ± 3.4% | 265.56 ± 1.8% | 695.77 ± 1.3% | 3592.75 ± 2.0% | 350.97 ± 0.4% | 0.99 | 1.00 | 3.02 | 1.32 |
| a UUID | 62 | 236.73 ± 0.6% | 237.79 ± 0.4% | 266.24 ± 0.3% | 61.72 ± 1.2% | 118.60 ± 4.9% | 252.90 ± 2.6% | 4470.47 ± 0.5% | 236.44 ± 1.1% | 1.00 | 1.00 | 3.84 | 2.00 |
| an IPv4 address | 29 | 634.32 ± 1.1% | 637.76 ± 0.7% | 853.76 ± 0.5% | 100.29 ± 0.4% | 156.82 ± 32.3% | 428.22 ± 1.6% | 8402.33 ± 0.6% | 633.98 ± 0.5% | 0.99 | 1.00 | 6.32 | 4.04 |
| a date and time | 56 | 473.75 ± 0.8% | 475.16 ± 1.0% | 592.22 ± 1.2% | 94.94 ± 0.9% | 168.90 ± 0.5% | 451.91 ± 0.7% | 4694.48 ± 0.9% | 473.11 ± 1.1% | 1.00 | 1.00 | 4.99 | 2.80 |
| a field path | 39 | 366.24 ± 0.5% | 366.71 ± 0.9% | 423.98 ± 0.6% | 104.96 ± 1.6% | 244.11 ± 2.3% | 701.89 ± 0.8% | 4581.16 ± 1.5% | 364.65 ± 0.9% | 1.00 | 1.00 | 3.49 | 1.50 |
| literal: a word | 7 | 1129.60 ± 0.7% | 1179.31 ± 0.8% | 1913.88 ± 0.8% | 704.42 ± 1.4% | 820.45 ± 1.8% | 1424.43 ± 0.4% | 29934.94 ± 3.3% | 1130.93 ± 0.9% | 0.96 | 1.00 | 1.60 | 1.38 |
| literal: a word that is not there | 8 | 1098.11 ± 1.0% | 1139.18 ± 0.8% | 1814.54 ± 0.7% | 629.77 ± 0.5% | 781.26 ± 2.5% | 1342.11 ± 0.4% | 29006.28 ± 3.1% | 1094.42 ± 0.5% | 0.96 | 1.00 | 1.74 | 1.41 |
| literal: one of four words | 26 | 599.48 ± 3.2% | 671.04 ± 0.4% | 873.89 ± 0.3% | 52.16 ± 1.2% | 301.50 ± 3.6% | 495.91 ± 2.2% | 14559.45 ± 1.9% | 598.48 ± 0.6% | 0.89 | 1.00 | 11.49 | 1.99 |
| literal: a word in any case | 11 | 732.84 ± 0.3% | 761.20 ± 0.4% | 1020.77 ± 0.3% | 17.07 ± 0.4% | 861.96 ± 0.9% | refused | 22713.63 ± 3.7% | 731.90 ± 1.7% | 0.96 | 1.00 | 42.93 | 0.85 |
| literal: an href attribute | 12 | 588.81 ± 0.8% | 597.41 ± 0.6% | 757.43 ± 0.5% | 49.72 ± 2.1% | 618.40 ± 16.6% | 1142.65 ± 2.3% | 20625.94 ± 0.4% | 589.62 ± 0.6% | 0.99 | 1.00 | 11.84 | 0.95 |
| literal: a word, second text | 10 | 1019.88 ± 0.6% | 1064.66 ± 3.4% | 1647.94 ± 0.6% | 589.00 ± 2.3% | 686.44 ± 1.5% | 1160.56 ± 0.7% | 23133.67 ± 3.1% | 1018.97 ± 3.0% | 0.96 | 1.00 | 1.73 | 1.49 |
| class: two capitalized words | 23 | 767.15 ± 0.4% | 786.88 ± 0.5% | 1087.51 ± 0.3% | 135.23 ± 0.9% | 637.64 ± 1.7% | 1108.95 ± 0.7% | 7054.47 ± 0.8% | 767.28 ± 0.7% | 0.97 | 1.00 | 5.67 | 1.20 |
| class: a word that ends in ing | 9 | 1014.90 ± 1.9% | 1071.20 ± 0.5% | 1720.55 ± 0.5% | 171.53 ± 0.5% | 947.83 ± 1.3% | 1719.16 ± 0.6% | 17693.60 ± 4.0% | 1013.72 ± 0.6% | 0.95 | 1.00 | 5.92 | 1.07 |
| class: a word in capitals | 16 | 902.62 ± 0.4% | 936.17 ± 0.7% | 1376.84 ± 0.3% | 180.84 ± 1.9% | 935.83 ± 1.7% | 1625.66 ± 0.6% | 8830.11 ± 1.0% | 899.92 ± 0.6% | 0.96 | 1.00 | 4.99 | 0.96 |
| class: a number | 6 | 1134.86 ± 3.0% | 1195.90 ± 0.6% | 2014.92 ± 0.6% | 44.49 ± 1.7% | 1738.68 ± 1.0% | 3002.55 ± 2.0% | 24821.72 ± 4.2% | 1134.00 ± 0.8% | 0.95 | 1.00 | 25.51 | 0.65 |
| class: two capitalized words, second text | 23 | 764.31 ± 0.7% | 785.94 ± 0.8% | 1080.66 ± 0.3% | 133.87 ± 0.6% | 627.34 ± 12.9% | 1121.23 ± 3.4% | 7081.72 ± 1.9% | 761.87 ± 0.6% | 0.97 | 1.00 | 5.71 | 1.22 |
| other: a word between two words | 13 | 916.30 ± 0.7% | 925.66 ± 1.4% | 1373.65 ± 0.6% | 178.21 ± 1.3% | 626.11 ± 2.0% | 1193.09 ± 2.0% | 15557.88 ± 3.1% | 914.72 ± 0.6% | 0.99 | 1.00 | 5.14 | 1.46 |
| other: a number before a unit, second text | 15 | 703.98 ± 0.5% | 750.96 ± 0.3% | 1022.12 ± 0.6% | 41.72 ± 0.5% | 795.04 ± 1.0% | 1361.94 ± 2.3% | 15604.77 ± 3.0% | 705.48 ± 0.6% | 0.94 | 1.00 | 16.88 | 0.89 |
| other: a heading's start tag | 13 | 588.47 ± 1.8% | 598.37 ± 1.6% | 759.74 ± 0.7% | 47.61 ± 0.8% | 775.47 ± 1.2% | 1304.79 ± 1.3% | 18228.43 ± 0.5% | 588.26 ± 0.9% | 0.98 | 1.00 | 12.36 | 0.76 |
| other: a whole word | 11 | 1003.77 ± 0.8% | 1033.50 ± 0.6% | 1586.20 ± 0.7% | 164.65 ± 0.4% | 729.22 ± 1.3% | 1236.88 ± 1.0% | 26587.28 ± 3.4% | 1007.08 ± 0.8% | 0.97 | 1.00 | 6.10 | 1.38 |
| other: a line's first word, second text | 17 | 879.61 ± 0.3% | 926.94 ± 0.5% | 1387.92 ± 0.6% | 172.88 ± 0.3% | 881.81 ± 1.2% | refused | refused | 878.87 ± 0.9% | 0.95 | 1.00 | 5.09 | 1.00 |
| other: fourteen octets before an x | 16 | 144.09 ± 0.6% | 196.76 ± 0.2% | 226.24 ± 0.7% | 18.69 ± 0.3% | 554.25 ± 2.6% | 592.61 ± 0.6% | 14504.62 ± 2.9% | 143.90 ± 0.7% | 0.73 | 1.00 | 7.71 | 0.26 |
| other: a Greek word | 8 | 1022.27 ± 0.8% | 1087.59 ± 0.7% | 1745.14 ± 0.5% | 61.60 ± 0.5% | 1728.58 ± 0.9% | 2888.45 ± 0.7% | refused | 1026.05 ± 0.6% | 0.94 | 1.00 | 16.60 | 0.59 |

