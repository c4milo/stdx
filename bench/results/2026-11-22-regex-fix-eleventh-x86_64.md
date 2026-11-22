# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) 6973P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45065553285 |
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
| literal: a word | 217 | 34116.10 ± 2.5% | 1110.02 ± 1.2% | 36.89 ± 1.2% | 31931.45 ± 14.0% | 12039.40 ± 2.8% | 15.36 ± 1.6% | 119.86 ± 3.9% | 34464.47 ± 1.5% | 30.73 | 0.99 | 1.07 | 2.83 |
| literal: a word that is not there | 0 | 42787.40 ± 3.6% | 1107.06 ± 14.0% | 37.20 ± 14.2% | 34751.53 ± 11.5% | 38201.36 ± 4.9% | 14.67 ± 6.8% | 110.12 ± 13.8% | 43770.37 ± 10.2% | 38.65 | 0.98 | 1.23 | 1.12 |
| literal: one of four words | 661 | 11556.71 ± 1.8% | 1093.30 ± 2.6% | 20.45 ± 2.3% | 10131.99 ± 1.6% | 28.58 ± 2.2% | 4.46 ± 0.4% | 9.44 ± 1.3% | 11544.32 ± 2.8% | 10.57 | 1.00 | 1.14 | 404.32 |
| literal: a word in any case | 217 | 27420.73 ± 1.4% | 1118.78 ± 4.1% | 26.73 ± 3.1% | 10338.16 ± 2.9% | 60.23 ± 2.7% | refused | differs | 27335.88 ± 2.7% | 24.51 | 1.00 | 2.65 | 455.26 |
| literal: an href attribute | 33 | 33168.17 ± 1.0% | 1117.76 ± 3.0% | 32.99 ± 4.1% | 28397.84 ± 0.8% | 2663.31 ± 6.0% | 10.79 ± 1.1% | 102.76 ± 3.1% | 33553.14 ± 2.4% | 29.67 | 0.99 | 1.17 | 12.45 |
| literal: a word, second text | 123 | 35491.10 ± 3.0% | 1123.57 ± 2.2% | 36.12 ± 4.6% | 31436.77 ± 3.8% | 9330.16 ± 7.2% | 20.05 ± 2.2% | 100.35 ± 3.9% | 35290.66 ± 3.6% | 31.59 | 1.01 | 1.13 | 3.80 |
| class: two capitalized words | 1331 | 1018.19 ± 3.2% | 1041.98 ± 2.8% | 34.28 ± 2.7% | 630.98 ± 2.4% | 48.89 ± 1.0% | 13.17 ± 6.5% | 85.81 ± 3.2% | 1029.53 ± 1.2% | 0.98 | 0.99 | 1.61 | 20.83 |
| class: a word that ends in ing | 3399 | 910.71 ± 13.3% | 940.43 ± 12.9% | 22.56 ± 8.7% | 595.07 ± 10.8% | 36.58 ± 10.2% | 7.32 ± 3.2% | 23.39 ± 2.6% | 943.51 ± 8.1% | 0.97 | 0.97 | 1.53 | 24.89 |
| class: a word in capitals | 2332 | 1374.15 ± 12.7% | 1025.14 ± 13.1% | 35.38 ± 5.7% | 599.59 ± 10.8% | 50.93 ± 16.2% | 15.73 ± 9.4% | 104.04 ± 5.7% | 1404.56 ± 12.7% | 1.34 | 0.98 | 2.29 | 26.98 |
| class: a number | 8288 | 2148.16 ± 8.7% | 871.65 ± 5.2% | 35.70 ± 2.7% | 2274.32 ± 3.1% | 52.81 ± 16.4% | 0.44 ± 4.3% | 74.38 ± 2.4% | 2172.62 ± 3.0% | 2.46 | 0.99 | 0.94 | 40.68 |
| class: two capitalized words, second text | 5359 | 763.67 ± 11.9% | 760.04 ± 1.4% | 30.88 ± 6.6% | 531.01 ± 13.0% | 43.48 ± 18.6% | 16.96 ± 9.2% | 77.26 ± 13.2% | 762.08 ± 10.5% | 1.00 | 1.00 | 1.44 | 17.56 |
| other: a word between two words | 6104 | 867.08 ± 3.8% | 803.18 ± 11.3% | 30.53 ± 14.9% | 893.82 ± 13.4% | 127.38 ± 17.9% | 9.82 ± 12.3% | 87.76 ± 13.7% | 868.87 ± 8.8% | 1.08 | 1.00 | 0.97 | 6.81 |
| other: a number before a unit, second text | 1481 | 10349.37 ± 5.4% | 1062.31 ± 1.8% | 34.59 ± 2.8% | 10145.33 ± 1.1% | 49.90 ± 1.1% | 18.05 ± 3.2% | 83.87 ± 12.1% | 10341.29 ± 13.6% | 9.74 | 1.00 | 1.02 | 207.42 |
| other: a heading's start tag | 110 | 20932.20 ± 2.5% | 1124.92 ± 1.0% | 35.95 ± 1.7% | 2806.20 ± 0.4% | 1978.92 ± 6.9% | 13.62 ± 1.1% | 123.58 ± 1.0% | 21122.05 ± 2.0% | 18.61 | 0.99 | 7.46 | 10.58 |
| other: a whole word | 217 | 26761.83 ± 11.9% | 1130.91 ± 12.5% | 37.17 ± 9.9% | 25724.39 ± 1.3% | 62.11 ± 2.5% | 13.19 ± 1.2% | 70.24 ± 7.4% | 26405.99 ± 8.5% | 23.66 | 1.01 | 1.04 | 430.91 |
| other: a line's first word, second text | 3716 | 2828.59 ± 16.7% | 936.23 ± 13.1% | 39.42 ± 4.5% | 2611.13 ± 3.9% | 83.03 ± 3.9% | refused | refused | 2869.41 ± 1.9% | 3.02 | 0.99 | 1.08 | 34.07 |
| other: fourteen octets before an x | 87 | 37027.32 ± 13.3% | 1.76 ± 10.2% | 1.72 ± 6.7% | 4283.10 ± 6.9% | 12.01 ± 9.7% | differs | 20.69 ± 13.6% | 36847.23 ± 13.6% | 21021.02 | 1.00 | 8.64 | 3081.92 |
| other: a Greek word | 21815 | 495.86 ± 12.7% | 361.07 ± 12.7% | 39.47 ± 13.5% | 327.20 ± 11.8% | 62.14 ± 18.4% | differs | refused | 491.65 ± 13.3% | 1.37 | 1.01 | 1.52 | 7.98 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.45 ± 13.3% | 31.64 ± 12.3% | 0.63 ± 5.4% | 29.68 ± 1.6% | 3.35 ± 2.4% | differs | 5.17 ± 6.0% | 32.13 ± 2.0% | 0.99 | 0.98 | 1.06 | 9.40 |
| a UUID | 32895 | 28.41 ± 3.1% | 28.12 ± 3.6% | 0.80 ± 1.4% | 22.17 ± 1.9% | 3.27 ± 2.4% | 0.73 ± 2.6% | 4.24 ± 3.2% | 28.22 ± 3.1% | 1.01 | 1.01 | 1.28 | 8.69 |
| an IPv4 address | 33176 | 43.67 ± 11.1% | 43.29 ± 16.8% | 2.58 ± 12.7% | 40.78 ± 13.4% | 8.27 ± 13.9% | differs | 4.78 ± 9.6% | 43.44 ± 3.0% | 1.01 | 1.01 | 1.07 | 5.28 |
| a date and time | 32954 | 41.79 ± 13.9% | 41.33 ± 12.4% | 1.84 ± 8.8% | 36.03 ± 2.2% | 10.09 ± 10.7% | 1.35 ± 16.2% | 9.27 ± 6.9% | 42.16 ± 13.3% | 1.01 | 0.99 | 1.16 | 4.14 |
| a field path | 32606 | 34.32 ± 5.9% | 34.78 ± 12.3% | 1.09 ± 12.6% | 31.88 ± 8.0% | 3.81 ± 12.7% | differs | 3.01 ± 12.2% | 32.29 ± 9.0% | 0.99 | 1.06 | 1.08 | 9.01 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.88 ± 2.5% | 12.01 ± 2.2% | 11.87 ± 5.1% | 14.87 ± 4.1% | 6.76 ± 5.3% | 1.03 ± 1.7% | none | 11.71 ± 5.2% | 0.99 | 1.01 | 0.80 | 1.76 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 372.51 ± 8.9% | 379.77 ± 3.5% | 433.64 ± 4.8% | 115.85 ± 5.2% | 274.77 ± 7.1% | 734.24 ± 4.1% | 3765.02 ± 3.1% | 372.36 ± 3.9% | 0.98 | 1.00 | 3.22 | 1.36 |
| a UUID | 62 | 253.96 ± 16.0% | 249.80 ± 17.7% | 286.39 ± 14.4% | 58.56 ± 12.3% | 120.30 ± 13.2% | 267.01 ± 17.6% | 4763.02 ± 15.7% | 256.05 ± 2.1% | 1.02 | 0.99 | 4.34 | 2.11 |
| an IPv4 address | 29 | 667.24 ± 21.2% | 647.21 ± 20.7% | 895.11 ± 17.3% | 104.38 ± 14.9% | 150.85 ± 16.0% | 397.14 ± 15.0% | 8589.30 ± 17.0% | 665.99 ± 15.6% | 1.03 | 1.00 | 6.39 | 4.42 |
| a date and time | 56 | 500.92 ± 1.7% | 508.81 ± 0.5% | 638.12 ± 2.5% | 101.16 ± 1.0% | 178.10 ± 1.6% | 486.89 ± 1.1% | 5083.23 ± 2.0% | 501.18 ± 0.6% | 0.98 | 1.00 | 4.95 | 2.81 |
| a field path | 39 | 410.45 ± 1.4% | 410.86 ± 3.2% | 481.00 ± 2.1% | 110.51 ± 4.5% | 257.05 ± 15.8% | 753.73 ± 2.4% | 4980.43 ± 2.5% | 407.12 ± 3.8% | 1.00 | 1.01 | 3.71 | 1.60 |
| literal: a word | 7 | 1160.18 ± 19.0% | 1186.24 ± 14.3% | 2056.03 ± 11.9% | 762.59 ± 3.6% | 856.53 ± 12.2% | 1528.55 ± 16.6% | 32934.24 ± 18.5% | 1167.40 ± 13.8% | 0.98 | 0.99 | 1.52 | 1.35 |
| literal: a word that is not there | 8 | 1153.59 ± 2.6% | 1182.11 ± 2.2% | 1925.57 ± 2.4% | 699.88 ± 1.6% | 818.92 ± 8.2% | 1436.22 ± 2.0% | 31104.02 ± 2.6% | 1145.29 ± 1.9% | 0.98 | 1.01 | 1.65 | 1.41 |
| literal: one of four words | 26 | 618.09 ± 2.4% | 681.51 ± 1.2% | 921.72 ± 4.4% | 56.69 ± 1.1% | 320.91 ± 32.0% | 531.22 ± 0.9% | 15554.03 ± 1.6% | 627.25 ± 2.3% | 0.91 | 0.99 | 10.90 | 1.93 |
| literal: a word in any case | 11 | 856.87 ± 1.9% | 894.74 ± 1.7% | 1253.30 ± 4.0% | 17.62 ± 4.0% | 914.37 ± 11.2% | refused | 25107.42 ± 3.1% | 849.92 ± 1.7% | 0.96 | 1.01 | 48.62 | 0.94 |
| literal: an href attribute | 12 | 613.49 ± 16.6% | 612.36 ± 8.6% | 787.31 ± 6.9% | 52.19 ± 18.1% | 643.27 ± 12.2% | 1207.32 ± 7.5% | 23505.22 ± 16.4% | 623.11 ± 19.7% | 1.00 | 0.98 | 11.76 | 0.95 |
| literal: a word, second text | 10 | 1066.32 ± 2.0% | 1097.46 ± 3.0% | 1758.01 ± 2.0% | 630.18 ± 0.6% | 715.31 ± 1.0% | 1259.13 ± 3.5% | 25087.06 ± 3.4% | 1073.31 ± 7.4% | 0.97 | 0.99 | 1.69 | 1.49 |
| class: two capitalized words | 23 | 794.51 ± 10.9% | 829.07 ± 16.5% | 1127.57 ± 15.7% | 142.60 ± 13.5% | 684.51 ± 17.8% | 1218.39 ± 16.3% | 7454.98 ± 9.4% | 800.20 ± 2.2% | 0.96 | 0.99 | 5.57 | 1.16 |
| class: a word that ends in ing | 9 | 1067.74 ± 0.5% | 1128.75 ± 1.2% | 1816.84 ± 3.7% | 186.34 ± 3.0% | 1006.73 ± 2.3% | 1893.65 ± 2.0% | 18976.07 ± 2.8% | 1062.53 ± 3.3% | 0.95 | 1.00 | 5.73 | 1.06 |
| class: a word in capitals | 16 | 922.82 ± 3.0% | 981.12 ± 1.1% | 1454.27 ± 3.6% | 192.86 ± 1.9% | 1006.33 ± 3.1% | 1765.51 ± 10.8% | 9272.32 ± 10.7% | 916.34 ± 12.2% | 0.94 | 1.01 | 4.78 | 0.92 |
| class: a number | 6 | 1167.68 ± 16.3% | 1229.52 ± 9.6% | 2094.07 ± 2.0% | 46.72 ± 13.2% | 1845.12 ± 2.5% | 3159.73 ± 2.4% | 26569.55 ± 3.7% | 1166.25 ± 1.7% | 0.95 | 1.00 | 24.99 | 0.63 |
| class: two capitalized words, second text | 23 | 786.74 ± 14.6% | 798.54 ± 8.6% | 1129.78 ± 11.7% | 137.98 ± 15.5% | 650.27 ± 19.8% | 1186.88 ± 12.0% | 7444.31 ± 9.9% | 780.18 ± 18.2% | 0.99 | 1.01 | 5.70 | 1.21 |
| other: a word between two words | 13 | 954.07 ± 3.1% | 968.68 ± 1.9% | 1449.50 ± 7.7% | 183.23 ± 13.8% | 656.94 ± 18.5% | 1253.19 ± 11.7% | 16043.95 ± 11.1% | 949.89 ± 5.5% | 0.98 | 1.00 | 5.21 | 1.45 |
| other: a number before a unit, second text | 15 | 754.44 ± 3.3% | 805.64 ± 3.7% | 1123.47 ± 3.2% | 44.61 ± 2.9% | 843.93 ± 2.2% | 1444.03 ± 4.5% | 16589.22 ± 4.1% | 759.69 ± 2.3% | 0.94 | 0.99 | 16.91 | 0.89 |
| other: a heading's start tag | 13 | 605.50 ± 5.1% | 603.77 ± 12.8% | 801.18 ± 16.1% | 51.06 ± 16.4% | 802.50 ± 5.3% | 1362.14 ± 1.6% | 20218.30 ± 3.6% | 616.27 ± 7.1% | 1.00 | 0.98 | 11.86 | 0.75 |
| other: a whole word | 11 | 1036.77 ± 4.4% | 1064.14 ± 10.5% | 1663.73 ± 17.6% | 167.92 ± 15.7% | 754.57 ± 21.5% | 1267.98 ± 1.8% | 28054.13 ± 3.8% | 1035.84 ± 2.4% | 0.97 | 1.00 | 6.17 | 1.37 |
| other: a line's first word, second text | 17 | 902.00 ± 1.2% | 948.80 ± 1.8% | 1428.94 ± 2.3% | 178.41 ± 1.5% | 920.74 ± 2.7% | refused | refused | 901.44 ± 0.9% | 0.95 | 1.00 | 5.06 | 0.98 |
| other: fourteen octets before an x | 16 | 149.97 ± 5.2% | 203.69 ± 4.6% | 238.88 ± 9.4% | 19.30 ± 13.7% | 560.88 ± 16.0% | 617.21 ± 17.0% | 15359.06 ± 10.1% | 147.63 ± 14.1% | 0.74 | 1.02 | 7.77 | 0.27 |
| other: a Greek word | 8 | 1055.72 ± 3.9% | 1120.20 ± 3.7% | 1840.18 ± 8.4% | 64.88 ± 1.8% | 1813.03 ± 2.7% | 3040.72 ± 1.9% | refused | 1059.51 ± 2.6% | 0.94 | 1.00 | 16.27 | 0.58 |

