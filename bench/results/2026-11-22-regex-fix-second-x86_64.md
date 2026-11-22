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
| literal: a word | 217 | 44297.38 ± 0.5% | 1028.42 ± 0.2% | 32.73 ± 1.6% | 40287.89 ± 1.5% | 12122.65 ± 4.3% | 12.78 ± 0.2% | 104.37 ± 1.3% | 44321.56 ± 0.2% | 43.07 | 1.00 | 1.10 | 3.65 |
| literal: a word that is not there | 0 | 62611.34 ± 0.4% | 1038.33 ± 0.9% | 32.62 ± 0.5% | 45980.91 ± 0.2% | 43827.33 ± 2.7% | 12.65 ± 0.2% | 97.34 ± 2.1% | 62664.04 ± 2.1% | 60.30 | 1.00 | 1.36 | 1.43 |
| literal: one of four words | 661 | 13413.27 ± 1.2% | 1006.71 ± 0.5% | 17.05 ± 1.3% | 11558.90 ± 0.5% | 24.21 ± 5.6% | 4.48 ± 0.9% | 7.91 ± 2.6% | 13376.31 ± 5.4% | 13.32 | 1.00 | 1.16 | 554.08 |
| literal: a word in any case | 217 | 38052.36 ± 1.0% | 1028.66 ± 0.2% | 24.50 ± 0.9% | 11415.19 ± 0.3% | 47.73 ± 4.2% | refused | differs | 38062.12 ± 0.6% | 36.99 | 1.00 | 3.33 | 797.28 |
| literal: an href attribute | 33 | 44462.09 ± 0.4% | 1033.74 ± 0.4% | 31.60 ± 0.6% | 35317.68 ± 0.5% | 3021.14 ± 2.9% | 9.52 ± 0.4% | 91.54 ± 0.5% | 44326.98 ± 0.5% | 43.01 | 1.00 | 1.26 | 14.72 |
| literal: a word, second text | 123 | 48159.06 ± 0.6% | 1029.88 ± 0.1% | 32.12 ± 0.8% | 40996.21 ± 0.4% | 10979.13 ± 7.9% | 14.42 ± 0.3% | 88.16 ± 0.4% | 48139.54 ± 2.3% | 46.76 | 1.00 | 1.17 | 4.39 |
| class: two capitalized words | 1331 | 916.12 ± 0.3% | 950.57 ± 0.1% | 30.24 ± 0.5% | 576.51 ± 0.4% | 44.37 ± 0.8% | 10.92 ± 0.2% | 80.06 ± 0.6% | 914.19 ± 0.9% | 0.96 | 1.00 | 1.59 | 20.65 |
| class: a word that ends in ing | 3399 | 875.07 ± 0.3% | 875.12 ± 0.3% | 19.32 ± 0.3% | 541.06 ± 0.3% | 33.10 ± 11.7% | 6.19 ± 0.3% | 20.09 ± 0.9% | 873.70 ± 0.9% | 1.00 | 1.00 | 1.62 | 26.44 |
| class: a word in capitals | 2332 | 1146.27 ± 0.2% | 928.06 ± 0.5% | 32.04 ± 0.2% | 566.77 ± 1.0% | 47.78 ± 4.3% | 12.33 ± 0.3% | 101.72 ± 0.3% | 1144.38 ± 0.4% | 1.24 | 1.00 | 2.02 | 23.99 |
| class: a number | 8288 | 1876.95 ± 1.4% | 794.52 ± 0.2% | 32.67 ± 0.4% | 1865.61 ± 1.1% | 48.67 ± 14.3% | 0.38 ± 0.6% | 74.18 ± 8.6% | 1874.36 ± 3.6% | 2.36 | 1.00 | 1.01 | 38.57 |
| class: two capitalized words, second text | 5359 | 689.61 ± 0.5% | 692.44 ± 0.3% | 27.19 ± 0.2% | 480.60 ± 0.4% | 38.88 ± 12.3% | 12.61 ± 0.3% | 74.32 ± 0.5% | 689.78 ± 0.4% | 1.00 | 1.00 | 1.43 | 17.73 |
| other: a word between two words | 6104 | 838.98 ± 0.6% | 739.31 ± 0.1% | 27.09 ± 0.6% | 836.36 ± 0.4% | 128.83 ± 13.3% | 8.35 ± 0.1% | 82.09 ± 0.6% | 837.80 ± 0.9% | 1.13 | 1.00 | 1.00 | 6.51 |
| other: a number before a unit, second text | 1481 | 10643.60 ± 0.4% | 978.83 ± 0.4% | 29.26 ± 1.8% | 9339.79 ± 0.8% | 45.87 ± 0.1% | 13.22 ± 0.2% | 78.01 ± 0.7% | 10598.17 ± 0.6% | 10.87 | 1.00 | 1.14 | 232.02 |
| other: a heading's start tag | 110 | 25699.04 ± 0.3% | 1024.76 ± 0.2% | 32.08 ± 0.1% | 2662.38 ± 2.5% | 2020.21 ± 13.5% | 11.71 ± 0.2% | 107.26 ± 0.1% | 25629.70 ± 0.2% | 25.08 | 1.00 | 9.65 | 12.72 |
| other: a whole word | 217 | 31559.97 ± 0.6% | 1027.40 ± 0.6% | 32.50 ± 0.3% | 29008.99 ± 0.4% | 54.37 ± 1.4% | 11.06 ± 0.1% | 62.84 ± 0.4% | 31477.27 ± 0.3% | 30.72 | 1.00 | 1.09 | 580.45 |
| other: a line's first word, second text | 3716 | 2637.38 ± 1.3% | 846.23 ± 0.1% | 36.36 ± 0.6% | 2452.09 ± 0.9% | 71.35 ± 3.1% | refused | refused | 2619.43 ± 0.2% | 3.12 | 1.01 | 1.08 | 36.97 |
| other: fourteen octets before an x | 87 | 37970.86 ± 0.3% | 1.74 ± 1.1% | 1.70 ± 0.4% | 3449.13 ± 1.1% | 11.72 ± 0.5% | differs | 21.88 ± 1.2% | 38145.85 ± 0.3% | 21794.35 | 1.00 | 11.01 | 3240.64 |
| other: a Greek word | 21815 | 467.86 ± 0.3% | 334.84 ± 0.7% | 34.87 ± 0.6% | 305.68 ± 0.2% | 58.13 ± 9.5% | differs | refused | 467.39 ± 0.3% | 1.40 | 1.00 | 1.53 | 8.05 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.61 ± 1.9% | 30.74 ± 0.4% | 0.62 ± 2.1% | 25.70 ± 0.2% | 2.83 ± 0.4% | differs | 4.05 ± 4.7% | 30.81 ± 0.2% | 1.00 | 0.99 | 1.19 | 10.80 |
| a UUID | 32895 | 25.78 ± 1.8% | 25.73 ± 1.0% | 0.75 ± 0.8% | 18.92 ± 0.4% | 3.08 ± 1.0% | 0.52 ± 0.4% | 3.81 ± 1.1% | 25.81 ± 0.2% | 1.00 | 1.00 | 1.36 | 8.36 |
| an IPv4 address | 33176 | 44.16 ± 3.5% | 43.20 ± 0.4% | 2.41 ± 0.5% | 36.46 ± 0.3% | 7.04 ± 2.3% | differs | 4.24 ± 0.4% | 44.38 ± 0.5% | 1.02 | 0.99 | 1.21 | 6.27 |
| a date and time | 32954 | 39.31 ± 1.5% | 39.41 ± 1.8% | 1.79 ± 0.1% | 29.67 ± 0.4% | 8.54 ± 0.5% | 0.91 ± 0.2% | 7.88 ± 8.8% | 39.48 ± 7.0% | 1.00 | 1.00 | 1.32 | 4.60 |
| a field path | 32606 | 34.77 ± 6.2% | 34.77 ± 0.3% | 0.95 ± 0.7% | 29.30 ± 0.2% | 3.56 ± 1.3% | differs | 2.98 ± 1.0% | 34.68 ± 0.3% | 1.00 | 1.00 | 1.19 | 9.76 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.44 ± 6.4% | 11.54 ± 2.0% | 11.54 ± 0.3% | 13.61 ± 1.4% | 5.85 ± 1.6% | 0.75 ± 0.2% | none | 11.54 ± 6.3% | 0.99 | 0.99 | 0.84 | 1.95 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 309.86 ± 0.5% | 310.25 ± 0.2% | 357.22 ± 0.2% | 102.07 ± 3.3% | 239.57 ± 0.8% | 628.46 ± 5.6% | 4813.67 ± 3.2% | 309.56 ± 0.2% | 1.00 | 1.00 | 3.04 | 1.29 |
| a UUID | 62 | 205.91 ± 0.2% | 206.84 ± 4.8% | 232.77 ± 1.7% | 58.93 ± 4.5% | 119.67 ± 1.7% | 237.49 ± 2.2% | 5181.57 ± 0.6% | 205.94 ± 4.7% | 1.00 | 1.00 | 3.49 | 1.72 |
| an IPv4 address | 29 | 563.80 ± 0.7% | 569.25 ± 0.3% | 750.53 ± 0.2% | 87.53 ± 1.0% | 148.02 ± 2.0% | 376.19 ± 6.3% | 8894.32 ± 0.8% | 562.51 ± 2.8% | 0.99 | 1.00 | 6.44 | 3.81 |
| a date and time | 56 | 401.14 ± 0.3% | 404.80 ± 0.4% | 486.98 ± 0.5% | 84.65 ± 0.7% | 160.61 ± 1.9% | 417.81 ± 0.8% | 5286.32 ± 0.3% | 401.01 ± 0.7% | 0.99 | 1.00 | 4.74 | 2.50 |
| a field path | 39 | 321.15 ± 0.3% | 322.82 ± 0.2% | 374.35 ± 4.2% | 93.63 ± 1.5% | 223.26 ± 1.5% | 663.74 ± 0.8% | 5752.12 ± 1.3% | 321.29 ± 0.1% | 0.99 | 1.00 | 3.43 | 1.44 |
| literal: a word | 7 | 939.44 ± 7.4% | 973.45 ± 0.2% | 1584.47 ± 0.1% | 615.16 ± 0.5% | 776.71 ± 35.0% | 1646.22 ± 2.3% | 33169.11 ± 9.9% | 939.06 ± 0.2% | 0.97 | 1.00 | 1.53 | 1.21 |
| literal: a word that is not there | 8 | 902.48 ± 0.2% | 936.13 ± 1.0% | 1491.65 ± 6.1% | 559.17 ± 0.4% | 761.12 ± 2.5% | 1543.44 ± 5.3% | 31517.45 ± 0.3% | 903.26 ± 7.2% | 0.96 | 1.00 | 1.61 | 1.19 |
| literal: one of four words | 26 | 463.63 ± 0.3% | 509.67 ± 0.2% | 649.27 ± 0.4% | 58.38 ± 0.7% | 292.03 ± 9.2% | 598.57 ± 1.0% | 15700.99 ± 1.3% | 463.10 ± 0.5% | 0.91 | 1.00 | 7.94 | 1.59 |
| literal: a word in any case | 11 | 698.85 ± 0.9% | 724.38 ± 1.5% | 1034.08 ± 1.0% | 19.54 ± 0.7% | 820.49 ± 0.8% | refused | 25008.22 ± 0.5% | 699.50 ± 1.4% | 0.96 | 1.00 | 35.77 | 0.85 |
| literal: an href attribute | 12 | 520.55 ± 0.8% | 530.60 ± 0.8% | 684.96 ± 0.2% | 50.72 ± 0.4% | 573.20 ± 2.3% | 1279.94 ± 3.2% | 23735.34 ± 7.7% | 520.37 ± 1.1% | 0.98 | 1.00 | 10.26 | 0.91 |
| literal: a word, second text | 10 | 838.34 ± 0.4% | 866.50 ± 0.2% | 1338.42 ± 0.2% | 521.15 ± 0.9% | 654.27 ± 5.6% | 1368.45 ± 0.3% | 28562.66 ± 0.6% | 837.81 ± 0.1% | 0.97 | 1.00 | 1.61 | 1.28 |
| class: two capitalized words | 23 | 615.40 ± 0.4% | 646.41 ± 0.7% | 862.52 ± 5.4% | 121.90 ± 1.3% | 597.65 ± 1.5% | 1260.68 ± 5.7% | 7782.10 ± 0.2% | 615.04 ± 1.0% | 0.95 | 1.00 | 5.05 | 1.03 |
| class: a word that ends in ing | 9 | 829.22 ± 0.3% | 897.79 ± 0.4% | 1392.31 ± 0.4% | 150.32 ± 0.9% | 865.63 ± 4.3% | 1878.96 ± 4.8% | 18934.96 ± 2.1% | 828.62 ± 0.3% | 0.92 | 1.00 | 5.52 | 0.96 |
| class: a word in capitals | 16 | 711.36 ± 4.8% | 755.84 ± 1.2% | 1073.20 ± 1.6% | 157.10 ± 1.3% | 889.62 ± 0.8% | 1665.36 ± 4.9% | 10368.30 ± 0.2% | 711.41 ± 0.2% | 0.94 | 1.00 | 4.53 | 0.80 |
| class: a number | 6 | 905.83 ± 0.3% | 978.17 ± 0.4% | 1595.99 ± 0.6% | 48.64 ± 1.7% | 1662.28 ± 3.3% | 2967.48 ± 1.7% | 25717.32 ± 0.6% | 907.22 ± 0.8% | 0.93 | 1.00 | 18.62 | 0.54 |
| class: two capitalized words, second text | 23 | 613.42 ± 0.9% | 646.07 ± 2.0% | 871.26 ± 1.7% | 120.53 ± 1.7% | 594.14 ± 17.7% | 1207.39 ± 9.2% | 7756.82 ± 8.7% | 615.55 ± 0.7% | 0.95 | 1.00 | 5.09 | 1.03 |
| other: a word between two words | 13 | 762.33 ± 0.6% | 780.94 ± 0.4% | 1129.07 ± 0.5% | 155.68 ± 1.1% | 584.55 ± 2.9% | 1345.33 ± 3.5% | 16477.16 ± 0.8% | 762.91 ± 0.3% | 0.98 | 1.00 | 4.90 | 1.30 |
| other: a number before a unit, second text | 15 | 602.03 ± 0.3% | 645.52 ± 0.4% | 873.11 ± 0.8% | 45.31 ± 1.1% | 728.43 ± 2.0% | 1435.43 ± 6.3% | 16467.34 ± 0.8% | 601.18 ± 0.3% | 0.93 | 1.00 | 13.29 | 0.83 |
| other: a heading's start tag | 13 | 519.06 ± 0.2% | 525.58 ± 0.3% | 698.36 ± 0.4% | 48.19 ± 0.5% | 706.08 ± 19.7% | 1371.41 ± 2.5% | 20524.60 ± 0.4% | 519.51 ± 0.4% | 0.99 | 1.00 | 10.77 | 0.74 |
| other: a whole word | 11 | 801.65 ± 1.5% | 824.80 ± 0.9% | 1238.60 ± 1.4% | 145.19 ± 1.0% | 636.20 ± 13.9% | 1363.62 ± 1.6% | 28763.62 ± 0.2% | 789.72 ± 2.5% | 0.97 | 1.02 | 5.52 | 1.26 |
| other: a line's first word, second text | 17 | 755.51 ± 1.5% | 790.70 ± 6.5% | 1147.70 ± 5.5% | 148.37 ± 3.6% | 799.12 ± 5.5% | refused | refused | 753.26 ± 5.2% | 0.96 | 1.00 | 5.09 | 0.95 |
| other: fourteen octets before an x | 16 | 125.28 ± 0.4% | 173.27 ± 1.4% | 201.70 ± 0.2% | 17.62 ± 1.4% | 515.83 ± 9.6% | 567.15 ± 1.2% | 15426.59 ± 8.6% | 125.40 ± 0.3% | 0.72 | 1.00 | 7.11 | 0.24 |
| other: a Greek word | 8 | 829.70 ± 5.9% | 908.95 ± 0.3% | 1420.56 ± 4.9% | 62.40 ± 0.5% | 1634.13 ± 1.6% | 2758.68 ± 0.8% | refused | 828.76 ± 0.3% | 0.91 | 1.00 | 13.30 | 0.51 |

