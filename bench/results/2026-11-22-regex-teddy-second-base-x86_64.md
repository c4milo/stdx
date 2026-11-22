# bench-regex

| Field | Value |
|---|---|
| Commit | 988748a |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45024986799 |
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
| literal: a word | 217 | 51120.76 ± 3.3% | 1090.65 ± 31.0% | 39.61 ± 8.0% | 28895.20 ± 2.1% | 13593.37 ± 5.8% | 14.24 ± 2.4% | 141.94 ± 4.7% | 51089.53 ± 5.4% | 46.87 | 1.00 | 1.77 | 3.76 |
| literal: a word that is not there | 0 | 73214.63 ± 3.3% | 1098.23 ± 3.9% | 40.19 ± 2.9% | 30811.21 ± 3.5% | 48763.51 ± 1.4% | 13.99 ± 3.2% | 131.11 ± 3.2% | 72583.20 ± 10.5% | 66.67 | 1.01 | 2.38 | 1.50 |
| literal: one of four words | 661 | 9396.82 ± 1.4% | 1046.94 ± 1.5% | 21.63 ± 2.2% | 12787.13 ± 2.3% | 33.01 ± 8.3% | 4.48 ± 1.8% | 11.70 ± 6.4% | 9318.00 ± 2.6% | 8.98 | 1.01 | 0.73 | 284.69 |
| literal: a word in any case | 217 | 44059.20 ± 2.6% | 1089.66 ± 0.9% | 29.28 ± 1.5% | 12848.51 ± 2.5% | 64.42 ± 3.7% | refused | differs | 43974.88 ± 3.0% | 40.43 | 1.00 | 3.43 | 683.92 |
| literal: an href attribute | 33 | 49802.57 ± 4.5% | 1094.47 ± 2.3% | 33.95 ± 3.3% | 26046.51 ± 3.4% | 3154.02 ± 3.4% | 10.08 ± 4.0% | 118.43 ± 3.8% | 50083.63 ± 3.1% | 45.50 | 0.99 | 1.91 | 15.79 |
| literal: a word, second text | 123 | 50749.70 ± 1.5% | 1095.92 ± 2.4% | 38.99 ± 2.0% | 27592.19 ± 2.3% | 13020.21 ± 4.5% | 18.69 ± 3.0% | 116.74 ± 1.9% | 50676.55 ± 2.1% | 46.31 | 1.00 | 1.84 | 3.90 |
| class: two capitalized words | 1331 | 1005.74 ± 2.0% | 1023.71 ± 2.1% | 36.74 ± 2.0% | 624.47 ± 2.0% | 55.93 ± 2.4% | 12.49 ± 1.8% | 96.65 ± 1.6% | 999.88 ± 3.3% | 0.98 | 1.01 | 1.61 | 17.98 |
| class: a word that ends in ing | 3399 | 933.83 ± 1.7% | 931.09 ± 1.7% | 25.57 ± 1.9% | 581.51 ± 1.5% | 41.33 ± 5.9% | 7.12 ± 1.2% | 28.38 ± 2.8% | 930.91 ± 2.0% | 1.00 | 1.00 | 1.61 | 22.59 |
| class: a word in capitals | 2332 | 1426.94 ± 2.9% | 996.16 ± 2.5% | 35.13 ± 7.8% | 605.84 ± 2.2% | 59.62 ± 7.3% | 14.99 ± 1.5% | 122.69 ± 3.9% | 1435.41 ± 2.5% | 1.43 | 0.99 | 2.36 | 23.93 |
| class: a number | 8288 | 2439.30 ± 8.0% | 845.30 ± 5.4% | 38.65 ± 5.8% | 2114.13 ± 2.0% | 61.99 ± 16.3% | 0.41 ± 5.1% | 88.11 ± 14.5% | 2436.03 ± 6.0% | 2.89 | 1.00 | 1.15 | 39.35 |
| class: two capitalized words, second text | 5359 | 746.01 ± 3.8% | 753.07 ± 3.4% | 33.06 ± 4.5% | 523.60 ± 5.7% | 45.76 ± 11.1% | 16.36 ± 4.8% | 87.98 ± 3.2% | 745.72 ± 2.8% | 0.99 | 1.00 | 1.42 | 16.30 |
| other: a word between two words | 6104 | 944.37 ± 1.5% | 784.93 ± 0.8% | 32.24 ± 2.5% | 893.46 ± 2.3% | 153.35 ± 12.8% | 9.35 ± 1.5% | 102.55 ± 4.4% | 944.48 ± 0.8% | 1.20 | 1.00 | 1.06 | 6.16 |
| other: a number before a unit, second text | 1481 | 12266.27 ± 2.3% | 1049.45 ± 0.8% | 37.06 ± 1.4% | 10914.03 ± 1.1% | 54.60 ± 1.9% | 16.97 ± 1.3% | 94.89 ± 1.2% | 12127.13 ± 1.5% | 11.69 | 1.01 | 1.12 | 224.67 |
| other: a heading's start tag | 110 | 28135.12 ± 2.2% | 1111.11 ± 2.2% | 36.05 ± 1.9% | 3028.91 ± 1.5% | 2305.93 ± 6.2% | 12.87 ± 4.4% | 140.70 ± 2.6% | 28048.23 ± 2.8% | 25.32 | 1.00 | 9.29 | 12.20 |
| other: a whole word | 217 | 35526.20 ± 2.2% | 1108.85 ± 2.3% | 39.42 ± 1.6% | 22952.51 ± 1.7% | 68.36 ± 2.1% | 12.71 ± 1.8% | 77.07 ± 1.5% | 35259.96 ± 1.7% | 32.04 | 1.01 | 1.55 | 519.70 |
| other: a line's first word, second text | 3716 | 3064.92 ± 1.7% | 903.49 ± 2.3% | 42.67 ± 2.3% | 3301.22 ± 4.7% | 90.26 ± 6.9% | refused | refused | 2988.26 ± 2.3% | 3.39 | 1.03 | 0.93 | 33.96 |
| other: fourteen octets before an x | 87 | 44378.92 ± 3.4% | 2.28 ± 1.9% | 2.24 ± 1.5% | 4362.83 ± 2.2% | 13.63 ± 0.9% | differs | 23.88 ± 2.0% | 44084.17 ± 2.8% | 19490.41 | 1.01 | 10.17 | 3256.64 |
| other: a Greek word | 21815 | 560.40 ± 1.9% | 383.14 ± 1.5% | 42.77 ± 1.3% | 324.33 ± 1.6% | 56.23 ± 3.5% | differs | refused | 557.76 ± 2.3% | 1.46 | 1.00 | 1.73 | 9.97 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 34.69 ± 2.1% | 34.68 ± 2.1% | 0.81 ± 2.4% | 29.13 ± 0.7% | 3.52 ± 1.6% | differs | 5.50 ± 3.0% | 34.47 ± 0.9% | 1.00 | 1.01 | 1.19 | 9.85 |
| a UUID | 32895 | 28.88 ± 2.0% | 29.03 ± 2.1% | 0.91 ± 1.3% | 23.84 ± 1.0% | 3.20 ± 2.6% | 0.68 ± 1.8% | 4.38 ± 2.8% | 28.71 ± 1.4% | 0.99 | 1.01 | 1.21 | 9.02 |
| an IPv4 address | 33176 | 48.01 ± 0.5% | 47.85 ± 0.9% | 3.04 ± 0.5% | 40.24 ± 2.7% | 8.21 ± 3.4% | differs | 5.33 ± 1.4% | 47.62 ± 2.3% | 1.00 | 1.01 | 1.19 | 5.85 |
| a date and time | 32954 | 42.91 ± 2.4% | 43.84 ± 3.1% | 2.20 ± 7.3% | 35.49 ± 2.5% | 9.67 ± 3.6% | 1.19 ± 3.1% | 11.00 ± 3.0% | 43.96 ± 3.1% | 0.98 | 0.98 | 1.21 | 4.44 |
| a field path | 32606 | 38.39 ± 1.2% | 38.01 ± 1.1% | 1.34 ± 2.3% | 32.50 ± 1.4% | 4.32 ± 1.6% | differs | 3.84 ± 0.5% | 37.93 ± 2.3% | 1.01 | 1.01 | 1.18 | 8.88 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 14.64 ± 8.9% | 14.66 ± 2.2% | 14.78 ± 2.5% | 16.31 ± 1.7% | 6.69 ± 2.8% | 0.98 ± 1.7% | none | 14.63 ± 7.6% | 1.00 | 1.00 | 0.90 | 2.19 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 421.23 ± 4.0% | 427.28 ± 3.9% | 491.99 ± 2.8% | 123.65 ± 2.4% | 249.31 ± 6.7% | 808.10 ± 2.7% | 5254.56 ± 6.8% | 420.11 ± 3.9% | 0.99 | 1.00 | 3.41 | 1.69 |
| a UUID | 62 | 304.22 ± 1.9% | 304.92 ± 2.1% | 341.11 ± 6.4% | 69.57 ± 3.0% | 135.49 ± 16.0% | 287.56 ± 0.9% | 6210.24 ± 4.0% | 306.39 ± 1.5% | 1.00 | 0.99 | 4.37 | 2.25 |
| an IPv4 address | 29 | 677.64 ± 8.7% | 699.59 ± 2.3% | 891.36 ± 3.0% | 112.85 ± 1.2% | 177.97 ± 27.6% | 523.77 ± 2.4% | 11061.92 ± 4.8% | 683.08 ± 1.6% | 0.97 | 0.99 | 6.01 | 3.81 |
| a date and time | 56 | 448.34 ± 2.0% | 452.26 ± 2.4% | 524.87 ± 1.6% | 106.54 ± 4.8% | 197.30 ± 16.5% | 533.65 ± 2.8% | 6705.79 ± 3.8% | 447.35 ± 3.2% | 0.99 | 1.00 | 4.21 | 2.27 |
| a field path | 39 | 479.71 ± 2.0% | 485.13 ± 2.8% | 573.12 ± 2.0% | 118.22 ± 5.0% | 260.51 ± 19.7% | 832.05 ± 2.5% | 6438.01 ± 8.9% | 477.96 ± 8.6% | 0.99 | 1.00 | 4.06 | 1.84 |
| literal: a word | 7 | 1242.33 ± 4.6% | 1295.27 ± 8.3% | 2084.53 ± 4.9% | 767.86 ± 4.8% | 913.82 ± 2.4% | 1618.19 ± 1.3% | 29633.44 ± 5.0% | 1237.89 ± 4.9% | 0.96 | 1.00 | 1.62 | 1.36 |
| literal: a word that is not there | 8 | 1163.42 ± 4.2% | 1245.08 ± 2.1% | 1972.20 ± 3.5% | 718.32 ± 1.2% | 862.48 ± 4.9% | 1559.19 ± 3.9% | 28986.85 ± 1.6% | 1159.94 ± 2.9% | 0.93 | 1.00 | 1.62 | 1.35 |
| literal: one of four words | 26 | 629.88 ± 3.2% | 691.03 ± 1.1% | 871.16 ± 0.2% | 67.38 ± 2.3% | 313.42 ± 20.2% | 606.43 ± 3.3% | 20323.23 ± 2.5% | 624.56 ± 1.2% | 0.91 | 1.01 | 9.35 | 2.01 |
| literal: a word in any case | 11 | 1039.78 ± 3.3% | 1126.00 ± 4.3% | 1733.81 ± 3.3% | 21.70 ± 0.8% | 921.40 ± 14.8% | refused | 27269.86 ± 2.0% | 1034.88 ± 1.9% | 0.92 | 1.00 | 47.92 | 1.13 |
| literal: an href attribute | 12 | 636.27 ± 4.2% | 648.77 ± 1.1% | 818.39 ± 2.6% | 54.75 ± 2.6% | 616.13 ± 22.2% | 1353.37 ± 4.1% | 23076.33 ± 14.3% | 637.15 ± 3.4% | 0.98 | 1.00 | 11.62 | 1.03 |
| literal: a word, second text | 10 | 1088.43 ± 1.6% | 1138.30 ± 1.8% | 1696.94 ± 1.3% | 630.57 ± 1.7% | 751.01 ± 6.3% | 1409.39 ± 2.7% | 28905.65 ± 2.4% | 1080.71 ± 2.7% | 0.96 | 1.01 | 1.73 | 1.45 |
| class: two capitalized words | 23 | 676.00 ± 4.9% | 694.83 ± 6.7% | 879.77 ± 5.1% | 145.75 ± 1.6% | 704.67 ± 10.9% | 1283.64 ± 4.0% | 8487.03 ± 3.0% | 674.01 ± 4.8% | 0.97 | 1.00 | 4.64 | 0.96 |
| class: a word that ends in ing | 9 | 1046.06 ± 1.5% | 1150.68 ± 2.2% | 1716.35 ± 2.1% | 186.20 ± 0.9% | 966.22 ± 4.6% | 1984.76 ± 1.8% | 21029.01 ± 1.4% | 1044.41 ± 2.4% | 0.91 | 1.00 | 5.62 | 1.08 |
| class: a word in capitals | 16 | 847.49 ± 2.2% | 871.99 ± 1.5% | 1171.00 ± 1.3% | 189.81 ± 1.8% | 1028.50 ± 18.2% | 1802.03 ± 3.8% | 11102.69 ± 1.2% | 847.79 ± 1.8% | 0.97 | 1.00 | 4.47 | 0.82 |
| class: a number | 6 | 1210.88 ± 3.1% | 1279.38 ± 3.9% | 2042.02 ± 2.8% | 56.60 ± 1.9% | 1931.09 ± 7.2% | 3297.44 ± 2.8% | 24876.11 ± 4.0% | 1198.36 ± 4.2% | 0.95 | 1.01 | 21.39 | 0.63 |
| class: two capitalized words, second text | 23 | 698.33 ± 3.5% | 714.69 ± 5.3% | 911.36 ± 6.5% | 145.42 ± 1.5% | 698.87 ± 8.8% | 1273.90 ± 1.5% | 8586.87 ± 2.1% | 685.96 ± 5.5% | 0.98 | 1.02 | 4.80 | 1.00 |
| other: a word between two words | 13 | 989.02 ± 4.3% | 1004.97 ± 3.2% | 1420.79 ± 2.9% | 190.65 ± 3.0% | 653.57 ± 9.5% | 1428.40 ± 2.3% | 20253.71 ± 1.1% | 994.17 ± 3.3% | 0.98 | 0.99 | 5.19 | 1.51 |
| other: a number before a unit, second text | 15 | 805.48 ± 9.6% | 920.96 ± 3.3% | 1241.74 ± 2.7% | 53.98 ± 2.7% | 856.19 ± 7.4% | 1616.31 ± 3.7% | 18883.12 ± 8.3% | 809.62 ± 35.9% | 0.87 | 0.99 | 14.92 | 0.94 |
| other: a heading's start tag | 13 | 629.48 ± 1.6% | 635.70 ± 1.6% | 795.47 ± 5.1% | 53.66 ± 3.1% | 823.44 ± 3.4% | 1522.48 ± 1.3% | 20706.72 ± 1.7% | 625.50 ± 11.3% | 0.99 | 1.01 | 11.73 | 0.76 |
| other: a whole word | 11 | 1119.43 ± 2.1% | 1188.77 ± 7.3% | 1795.79 ± 2.5% | 171.79 ± 3.7% | 799.17 ± 9.6% | 1452.86 ± 4.0% | 30951.48 ± 5.0% | 1137.23 ± 9.6% | 0.94 | 0.98 | 6.52 | 1.40 |
| other: a line's first word, second text | 17 | 878.93 ± 2.8% | 991.37 ± 3.7% | 1384.43 ± 4.8% | 179.99 ± 5.7% | 912.15 ± 4.9% | refused | refused | 881.09 ± 2.8% | 0.89 | 1.00 | 4.88 | 0.96 |
| other: fourteen octets before an x | 16 | 172.92 ± 4.9% | 234.68 ± 7.5% | 267.57 ± 6.7% | 20.11 ± 4.3% | 559.71 ± 9.6% | 668.00 ± 2.3% | 16525.43 ± 3.7% | 172.43 ± 1.8% | 0.74 | 1.00 | 8.60 | 0.31 |
| other: a Greek word | 8 | 1105.21 ± 6.7% | 1189.63 ± 6.9% | 1880.54 ± 2.6% | 68.20 ± 8.6% | 1861.54 ± 67.8% | 3086.96 ± 1.5% | refused | 1110.36 ± 2.9% | 0.93 | 1.00 | 16.21 | 0.59 |

