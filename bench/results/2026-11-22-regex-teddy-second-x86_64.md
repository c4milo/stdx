# bench-regex

| Field | Value |
|---|---|
| Commit | 822c457 |
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
| literal: a word | 217 | 50922.21 ± 2.5% | 1109.61 ± 1.0% | 39.86 ± 2.3% | 36612.29 ± 9.9% | 14168.30 ± 3.9% | 14.28 ± 0.9% | 141.51 ± 3.7% | 51618.13 ± 2.2% | 45.89 | 0.99 | 1.39 | 3.59 |
| literal: a word that is not there | 0 | 73882.32 ± 3.3% | 1133.21 ± 2.4% | 40.99 ± 2.9% | 48857.91 ± 4.9% | 50617.57 ± 1.9% | 13.95 ± 3.4% | 135.24 ± 2.9% | 73967.61 ± 2.5% | 65.20 | 1.00 | 1.51 | 1.46 |
| literal: one of four words | 661 | 11224.71 ± 2.5% | 1082.72 ± 2.8% | 22.22 ± 1.9% | 13241.59 ± 2.7% | 34.47 ± 12.5% | 4.68 ± 2.3% | 11.81 ± 1.2% | 11216.76 ± 2.4% | 10.37 | 1.00 | 0.85 | 325.61 |
| literal: a word in any case | 217 | 45515.64 ± 4.6% | 1123.28 ± 1.1% | 30.12 ± 1.2% | 13127.39 ± 2.0% | 66.21 ± 12.0% | refused | differs | 45417.15 ± 8.0% | 40.52 | 1.00 | 3.47 | 687.49 |
| literal: an href attribute | 33 | 50546.13 ± 1.9% | 1133.05 ± 1.0% | 34.88 ± 2.5% | 34320.49 ± 3.5% | 3246.60 ± 3.9% | 10.23 ± 2.2% | 119.32 ± 3.7% | 50673.90 ± 2.8% | 44.61 | 1.00 | 1.47 | 15.57 |
| literal: a word, second text | 123 | 51893.82 ± 3.0% | 1127.77 ± 1.7% | 40.07 ± 3.1% | 38509.47 ± 22.1% | 13428.95 ± 7.5% | 19.22 ± 1.8% | 114.37 ± 2.2% | 52019.32 ± 4.3% | 46.01 | 1.00 | 1.35 | 3.86 |
| class: two capitalized words | 1331 | 1024.67 ± 1.9% | 1038.13 ± 2.0% | 36.52 ± 1.4% | 630.83 ± 2.2% | 56.47 ± 2.2% | 12.40 ± 2.2% | 95.90 ± 3.8% | 1012.50 ± 1.3% | 0.99 | 1.01 | 1.62 | 18.15 |
| class: a word that ends in ing | 3399 | 960.84 ± 2.4% | 963.82 ± 3.3% | 26.13 ± 1.6% | 601.41 ± 1.6% | 42.45 ± 4.5% | 7.34 ± 2.4% | 27.41 ± 2.7% | 964.89 ± 1.8% | 1.00 | 1.00 | 1.60 | 22.63 |
| class: a word in capitals | 2332 | 1482.63 ± 4.9% | 1017.18 ± 2.7% | 39.63 ± 1.2% | 620.83 ± 1.7% | 60.78 ± 6.7% | 14.97 ± 2.1% | 126.64 ± 2.3% | 1468.62 ± 2.5% | 1.46 | 1.01 | 2.39 | 24.40 |
| class: a number | 8288 | 2500.85 ± 12.8% | 857.06 ± 8.3% | 39.23 ± 8.4% | 2183.76 ± 5.3% | 59.94 ± 13.0% | 0.41 ± 1.7% | 87.97 ± 11.5% | 2473.56 ± 17.5% | 2.92 | 1.01 | 1.15 | 41.72 |
| class: two capitalized words, second text | 5359 | 768.30 ± 1.6% | 771.04 ± 1.5% | 33.54 ± 1.3% | 533.93 ± 2.4% | 46.92 ± 12.8% | 16.29 ± 1.4% | 87.70 ± 3.9% | 769.08 ± 2.0% | 1.00 | 1.00 | 1.44 | 16.37 |
| other: a word between two words | 6104 | 968.24 ± 2.3% | 802.88 ± 2.9% | 32.48 ± 1.5% | 915.09 ± 1.3% | 164.48 ± 4.4% | 9.37 ± 2.1% | 103.51 ± 5.7% | 969.04 ± 3.9% | 1.21 | 1.00 | 1.06 | 5.89 |
| other: a number before a unit, second text | 1481 | 12520.37 ± 1.8% | 1055.29 ± 2.9% | 37.23 ± 2.1% | 10250.20 ± 1.7% | 54.99 ± 11.0% | 16.91 ± 3.6% | 92.55 ± 4.5% | 12401.79 ± 2.5% | 11.86 | 1.01 | 1.22 | 227.70 |
| other: a heading's start tag | 110 | 27352.93 ± 3.4% | 1092.23 ± 2.8% | 36.88 ± 1.8% | 2990.10 ± 2.3% | 2282.79 ± 2.9% | 12.52 ± 1.8% | 145.00 ± 3.5% | 27297.92 ± 4.5% | 25.04 | 1.00 | 9.15 | 11.98 |
| other: a whole word | 217 | 34858.69 ± 1.7% | 1109.12 ± 1.8% | 41.77 ± 2.3% | 27868.32 ± 1.7% | 67.21 ± 4.4% | 11.92 ± 3.6% | 74.91 ± 33.4% | 34730.69 ± 68.8% | 31.43 | 1.00 | 1.25 | 518.68 |
| other: a line's first word, second text | 3716 | 3072.76 ± 3.2% | 919.41 ± 2.1% | 44.60 ± 2.2% | 3232.81 ± 2.5% | 89.27 ± 9.9% | refused | refused | 3096.87 ± 1.7% | 3.34 | 0.99 | 0.95 | 34.42 |
| other: fourteen octets before an x | 87 | 44261.11 ± 4.9% | 2.26 ± 4.9% | 2.23 ± 3.2% | 4201.31 ± 3.6% | 13.20 ± 2.9% | differs | 23.77 ± 6.2% | 44041.74 ± 4.2% | 19609.33 | 1.00 | 10.54 | 3353.32 |
| other: a Greek word | 21815 | 547.92 ± 1.7% | 371.36 ± 9.5% | 42.26 ± 5.6% | 322.02 ± 1.9% | 55.08 ± 4.9% | differs | refused | 548.91 ± 2.5% | 1.48 | 1.00 | 1.70 | 9.95 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 33.76 ± 3.4% | 33.92 ± 3.0% | 0.80 ± 6.3% | 28.67 ± 2.6% | 3.43 ± 3.0% | differs | 5.02 ± 2.9% | 33.87 ± 1.9% | 1.00 | 1.00 | 1.18 | 9.84 |
| a UUID | 32895 | 28.62 ± 2.9% | 28.43 ± 1.7% | 0.94 ± 6.9% | 23.44 ± 1.7% | 3.17 ± 2.7% | 0.66 ± 2.7% | 4.09 ± 9.5% | 28.52 ± 2.4% | 1.01 | 1.00 | 1.22 | 9.02 |
| an IPv4 address | 33176 | 49.02 ± 3.2% | 49.38 ± 2.9% | 3.12 ± 3.7% | 41.84 ± 2.7% | 8.39 ± 3.1% | differs | 5.38 ± 1.7% | 49.26 ± 1.7% | 0.99 | 1.00 | 1.17 | 5.84 |
| a date and time | 32954 | 44.05 ± 2.9% | 44.11 ± 2.6% | 2.27 ± 8.7% | 34.93 ± 1.7% | 9.89 ± 3.5% | 1.17 ± 2.4% | 9.87 ± 5.2% | 44.47 ± 1.4% | 1.00 | 0.99 | 1.26 | 4.46 |
| a field path | 32606 | 38.66 ± 4.2% | 38.83 ± 2.0% | 1.34 ± 1.2% | 32.97 ± 1.5% | 4.37 ± 3.1% | differs | 3.78 ± 4.6% | 39.03 ± 3.6% | 1.00 | 0.99 | 1.17 | 8.85 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 14.31 ± 4.3% | 14.56 ± 3.7% | 14.55 ± 5.1% | 15.91 ± 3.5% | 6.74 ± 10.9% | 0.96 ± 2.5% | none | 14.56 ± 4.0% | 0.98 | 0.98 | 0.90 | 2.12 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 423.88 ± 1.9% | 426.06 ± 3.1% | 494.31 ± 2.4% | 125.47 ± 3.3% | 272.48 ± 5.8% | 820.75 ± 3.2% | 5405.22 ± 2.2% | 422.39 ± 1.5% | 0.99 | 1.00 | 3.38 | 1.56 |
| a UUID | 62 | 299.28 ± 1.1% | 297.12 ± 7.1% | 335.13 ± 1.1% | 67.95 ± 3.3% | 135.28 ± 5.9% | 289.05 ± 3.7% | 6746.70 ± 3.2% | 298.77 ± 1.4% | 1.01 | 1.00 | 4.40 | 2.21 |
| an IPv4 address | 29 | 694.99 ± 3.2% | 702.44 ± 3.6% | 889.84 ± 4.8% | 111.03 ± 2.5% | 172.09 ± 10.3% | 508.20 ± 0.9% | 11637.15 ± 7.5% | 687.68 ± 2.2% | 0.99 | 1.01 | 6.26 | 4.04 |
| a date and time | 56 | 453.61 ± 0.3% | 454.30 ± 2.2% | 524.56 ± 1.1% | 106.50 ± 1.8% | 191.36 ± 4.4% | 527.12 ± 3.3% | 7453.35 ± 2.5% | 451.65 ± 4.8% | 1.00 | 1.00 | 4.26 | 2.37 |
| a field path | 39 | 489.60 ± 3.1% | 493.47 ± 2.3% | 574.93 ± 2.6% | 116.57 ± 5.5% | 244.64 ± 21.5% | 810.32 ± 1.3% | 6758.84 ± 2.7% | 486.77 ± 1.3% | 0.99 | 1.01 | 4.20 | 2.00 |
| literal: a word | 7 | 1283.23 ± 3.1% | 1328.18 ± 4.8% | 2114.67 ± 4.2% | 756.58 ± 1.1% | 834.26 ± 42.0% | 1627.81 ± 2.2% | 43468.70 ± 1.6% | 1280.24 ± 1.9% | 0.97 | 1.00 | 1.70 | 1.54 |
| literal: a word that is not there | 8 | 1221.58 ± 2.6% | 1264.87 ± 3.4% | 1990.94 ± 2.5% | 720.82 ± 10.9% | 807.49 ± 16.6% | 1540.73 ± 1.9% | 42614.07 ± 1.2% | 1220.71 ± 4.3% | 0.97 | 1.00 | 1.69 | 1.51 |
| literal: one of four words | 26 | 623.98 ± 1.7% | 680.44 ± 7.4% | 840.22 ± 29.9% | 64.79 ± 10.2% | 295.85 ± 11.5% | 592.93 ± 2.7% | 24081.51 ± 9.7% | 622.29 ± 2.1% | 0.92 | 1.00 | 9.63 | 2.11 |
| literal: a word in any case | 11 | 1097.37 ± 6.3% | 1135.96 ± 6.9% | 1735.23 ± 3.0% | 21.37 ± 1.2% | 861.59 ± 10.0% | refused | 35345.79 ± 1.8% | 1105.68 ± 2.6% | 0.97 | 0.99 | 51.36 | 1.27 |
| literal: an href attribute | 12 | 627.49 ± 8.2% | 632.42 ± 6.2% | 794.58 ± 5.6% | 54.68 ± 1.3% | 550.70 ± 8.8% | 1327.49 ± 2.1% | 29997.98 ± 1.6% | 630.01 ± 2.1% | 0.99 | 1.00 | 11.48 | 1.14 |
| literal: a word, second text | 10 | 1108.91 ± 4.8% | 1147.81 ± 5.2% | 1739.96 ± 7.9% | 637.66 ± 2.5% | 676.44 ± 5.1% | 1383.16 ± 2.8% | 40666.50 ± 2.9% | 1112.66 ± 4.9% | 0.97 | 1.00 | 1.74 | 1.64 |
| class: two capitalized words | 23 | 665.54 ± 3.7% | 681.56 ± 8.7% | 855.88 ± 4.1% | 145.78 ± 1.4% | 624.17 ± 9.3% | 1283.47 ± 4.2% | 8729.89 ± 6.8% | 667.33 ± 8.1% | 0.98 | 1.00 | 4.57 | 1.07 |
| class: a word that ends in ing | 9 | 1108.66 ± 2.1% | 1183.82 ± 4.0% | 1741.97 ± 2.3% | 188.70 ± 2.0% | 894.36 ± 4.4% | 2016.77 ± 2.8% | 22566.22 ± 3.1% | 1097.71 ± 1.6% | 0.94 | 1.01 | 5.88 | 1.24 |
| class: a word in capitals | 16 | 842.90 ± 3.2% | 879.48 ± 3.4% | 1159.81 ± 1.5% | 189.16 ± 1.0% | 946.76 ± 6.3% | 1826.38 ± 5.1% | 11607.52 ± 1.6% | 832.92 ± 3.4% | 0.96 | 1.01 | 4.46 | 0.89 |
| class: a number | 6 | 1244.15 ± 7.7% | 1313.49 ± 0.9% | 2042.23 ± 1.7% | 55.21 ± 4.4% | 1848.30 ± 2.7% | 3253.75 ± 4.7% | 33576.91 ± 2.6% | 1251.77 ± 1.7% | 0.95 | 0.99 | 22.53 | 0.67 |
| class: two capitalized words, second text | 23 | 698.73 ± 5.6% | 724.52 ± 4.6% | 912.29 ± 5.5% | 147.90 ± 2.7% | 650.16 ± 19.1% | 1288.30 ± 1.4% | 8935.62 ± 3.1% | 693.49 ± 3.5% | 0.96 | 1.01 | 4.72 | 1.07 |
| other: a word between two words | 13 | 1034.20 ± 16.7% | 1034.76 ± 25.5% | 1466.08 ± 0.8% | 194.30 ± 2.1% | 649.01 ± 11.8% | 1429.29 ± 3.9% | 21845.11 ± 3.1% | 1021.60 ± 7.0% | 1.00 | 1.01 | 5.32 | 1.59 |
| other: a number before a unit, second text | 15 | 872.16 ± 6.6% | 926.69 ± 2.4% | 1249.77 ± 3.4% | 53.66 ± 5.0% | 827.50 ± 27.9% | 1593.67 ± 4.3% | 22238.00 ± 29.2% | 869.41 ± 53.3% | 0.94 | 1.00 | 16.25 | 1.05 |
| other: a heading's start tag | 13 | 632.33 ± 5.0% | 635.46 ± 20.9% | 785.84 ± 3.0% | 54.58 ± 5.9% | 769.96 ± 7.0% | 1503.19 ± 2.4% | 26157.22 ± 1.6% | 628.73 ± 2.5% | 1.00 | 1.01 | 11.58 | 0.82 |
| other: a whole word | 11 | 1161.74 ± 4.3% | 1201.55 ± 9.9% | 1783.87 ± 5.1% | 180.17 ± 1.5% | 774.01 ± 7.3% | 1461.08 ± 4.6% | 40502.51 ± 1.4% | 1140.75 ± 6.4% | 0.97 | 1.02 | 6.45 | 1.50 |
| other: a line's first word, second text | 17 | 972.36 ± 1.9% | 1012.24 ± 1.8% | 1386.90 ± 2.5% | 183.97 ± 2.8% | 920.05 ± 18.4% | refused | refused | 968.20 ± 6.8% | 0.96 | 1.00 | 5.29 | 1.06 |
| other: fourteen octets before an x | 16 | 178.19 ± 3.6% | 238.21 ± 2.5% | 272.63 ± 9.0% | 20.71 ± 1.6% | 588.61 ± 4.8% | 692.32 ± 3.0% | 19457.10 ± 2.5% | 179.22 ± 3.0% | 0.75 | 0.99 | 8.61 | 0.30 |
| other: a Greek word | 8 | 1163.71 ± 1.3% | 1255.81 ± 1.8% | 1890.39 ± 5.6% | 68.87 ± 1.6% | 1806.88 ± 4.2% | 3153.20 ± 1.1% | refused | 1165.83 ± 1.7% | 0.93 | 1.00 | 16.90 | 0.64 |

