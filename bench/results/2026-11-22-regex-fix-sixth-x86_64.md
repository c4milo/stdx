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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063432984 |
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
| literal: a word | 217 | 36154.43 ± 47.0% | 1087.10 ± 2.4% | 35.22 ± 66.8% | 33259.57 ± 84.3% | 12677.39 ± 29.3% | 14.77 ± 0.2% | 115.62 ± 2.1% | 36102.31 ± 17.1% | 33.26 | 1.00 | 1.09 | 2.85 |
| literal: a word that is not there | 0 | 45894.00 ± 0.4% | 1099.19 ± 0.4% | 35.96 ± 0.4% | 36256.66 ± 1.2% | 40702.21 ± 1.0% | 14.34 ± 0.4% | 108.10 ± 0.8% | 45913.56 ± 0.7% | 41.75 | 1.00 | 1.27 | 1.13 |
| literal: one of four words | 661 | 12267.88 ± 1.6% | 1066.22 ± 0.3% | 20.06 ± 2.3% | 9843.31 ± 0.2% | 27.95 ± 10.9% | 4.33 ± 0.2% | 9.23 ± 1.3% | 12141.15 ± 1.0% | 11.51 | 1.01 | 1.25 | 438.97 |
| literal: a word in any case | 217 | 28742.36 ± 1.2% | 1085.22 ± 0.5% | 26.09 ± 0.9% | 10067.59 ± 1.5% | 58.26 ± 0.6% | refused | differs | 28686.42 ± 0.7% | 26.49 | 1.00 | 2.85 | 493.38 |
| literal: an href attribute | 33 | 34780.13 ± 0.5% | 1094.06 ± 0.6% | 32.01 ± 0.3% | 29539.19 ± 1.1% | 2591.05 ± 2.5% | 10.55 ± 0.5% | 99.21 ± 1.0% | 34798.01 ± 0.8% | 31.79 | 1.00 | 1.18 | 13.42 |
| literal: a word, second text | 123 | 37113.66 ± 0.3% | 1090.96 ± 1.6% | 34.87 ± 1.6% | 32989.59 ± 0.5% | 9112.10 ± 7.3% | 19.18 ± 0.6% | 96.60 ± 0.5% | 37205.84 ± 0.4% | 34.02 | 1.00 | 1.13 | 4.07 |
| class: two capitalized words | 1331 | 995.59 ± 0.5% | 1004.05 ± 0.3% | 33.34 ± 12.3% | 612.92 ± 0.3% | 47.99 ± 1.2% | 12.55 ± 0.5% | 81.55 ± 0.7% | 996.15 ± 0.2% | 0.99 | 1.00 | 1.62 | 20.74 |
| class: a word that ends in ing | 3399 | 918.16 ± 0.5% | 918.87 ± 0.6% | 22.12 ± 0.7% | 578.40 ± 0.2% | 35.75 ± 14.7% | 7.03 ± 0.2% | 22.76 ± 0.3% | 917.25 ± 0.2% | 1.00 | 1.00 | 1.59 | 25.68 |
| class: a word in capitals | 2332 | 1372.85 ± 0.1% | 986.31 ± 0.1% | 35.57 ± 1.2% | 606.37 ± 0.1% | 51.70 ± 1.1% | 15.15 ± 0.3% | 101.09 ± 1.4% | 1370.81 ± 1.6% | 1.39 | 1.00 | 2.26 | 26.55 |
| class: a number | 8288 | 2061.85 ± 0.2% | 840.06 ± 0.1% | 33.90 ± 0.5% | 2191.15 ± 0.1% | 48.47 ± 14.2% | 0.42 ± 0.0% | 71.11 ± 0.9% | 2060.28 ± 0.2% | 2.45 | 1.00 | 0.94 | 42.54 |
| class: two capitalized words, second text | 5359 | 731.36 ± 0.5% | 731.73 ± 0.2% | 29.73 ± 1.9% | 512.54 ± 0.2% | 41.98 ± 13.9% | 16.37 ± 0.3% | 74.34 ± 1.2% | 730.33 ± 0.2% | 1.00 | 1.00 | 1.43 | 17.42 |
| other: a word between two words | 6104 | 848.88 ± 0.5% | 783.48 ± 0.1% | 29.65 ± 0.9% | 885.97 ± 0.4% | 129.39 ± 17.9% | 9.62 ± 0.1% | 85.00 ± 0.3% | 849.21 ± 0.4% | 1.08 | 1.00 | 0.96 | 6.56 |
| other: a number before a unit, second text | 1481 | 10155.72 ± 1.9% | 1025.38 ± 0.2% | 33.42 ± 0.9% | 9962.57 ± 1.1% | 48.24 ± 0.6% | 17.13 ± 0.1% | 79.43 ± 0.3% | 9970.31 ± 0.7% | 9.90 | 1.02 | 1.02 | 210.50 |
| other: a heading's start tag | 110 | 21593.88 ± 0.8% | 1085.30 ± 0.3% | 34.12 ± 1.2% | 2661.67 ± 0.3% | 1890.62 ± 10.5% | 13.20 ± 0.3% | 117.22 ± 1.5% | 21542.99 ± 0.2% | 19.90 | 1.00 | 8.11 | 11.42 |
| other: a whole word | 217 | 27433.14 ± 0.4% | 1087.39 ± 0.3% | 35.94 ± 0.8% | 26533.96 ± 0.6% | 59.62 ± 0.6% | 12.55 ± 0.2% | 67.59 ± 0.3% | 27439.56 ± 0.5% | 25.23 | 1.00 | 1.03 | 460.13 |
| other: a line's first word, second text | 3716 | 2740.53 ± 0.4% | 902.11 ± 0.1% | 37.55 ± 1.3% | 2526.98 ± 0.4% | 78.58 ± 4.3% | refused | refused | 2726.54 ± 0.6% | 3.04 | 1.01 | 1.08 | 34.87 |
| other: fourteen octets before an x | 87 | 37524.60 ± 0.2% | 1.78 ± 0.1% | 1.75 ± 0.1% | 4179.38 ± 0.2% | 11.60 ± 0.6% | differs | 20.17 ± 1.0% | 37265.82 ± 2.1% | 21094.64 | 1.01 | 8.98 | 3235.79 |
| other: a Greek word | 21815 | 478.93 ± 0.2% | 347.73 ± 0.2% | 38.25 ± 0.2% | 319.13 ± 0.5% | 53.23 ± 1.8% | differs | refused | 478.90 ± 0.4% | 1.38 | 1.00 | 1.50 | 9.00 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.85 ± 0.3% | 30.83 ± 0.4% | 0.61 ± 0.4% | 28.70 ± 0.4% | 3.28 ± 0.7% | differs | 4.95 ± 0.9% | 30.79 ± 1.3% | 1.00 | 1.00 | 1.07 | 9.41 |
| a UUID | 32895 | 27.25 ± 0.2% | 27.25 ± 0.3% | 0.77 ± 0.6% | 21.30 ± 0.2% | 3.14 ± 0.2% | 0.71 ± 0.3% | 4.12 ± 0.4% | 27.27 ± 0.1% | 1.00 | 1.00 | 1.28 | 8.68 |
| an IPv4 address | 33176 | 41.87 ± 0.5% | 41.96 ± 1.2% | 2.48 ± 1.1% | 39.05 ± 0.6% | 7.93 ± 0.3% | differs | 4.65 ± 0.8% | 41.90 ± 0.8% | 1.00 | 1.00 | 1.07 | 5.28 |
| a date and time | 32954 | 40.51 ± 0.8% | 40.50 ± 0.9% | 1.77 ± 0.2% | 34.84 ± 0.5% | 10.15 ± 0.5% | 1.31 ± 0.1% | 9.06 ± 0.3% | 40.46 ± 0.7% | 1.00 | 1.00 | 1.16 | 3.99 |
| a field path | 32606 | 33.72 ± 0.3% | 33.71 ± 0.4% | 1.09 ± 0.7% | 31.07 ± 0.6% | 3.67 ± 0.5% | differs | 3.08 ± 0.5% | 33.57 ± 0.6% | 1.00 | 1.00 | 1.09 | 9.18 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.40 ± 0.3% | 11.40 ± 0.7% | 11.41 ± 0.5% | 14.71 ± 0.6% | 6.63 ± 1.1% | 1.03 ± 0.2% | none | 11.39 ± 0.6% | 1.00 | 1.00 | 0.77 | 1.72 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 352.90 ± 0.4% | 354.93 ± 0.2% | 407.26 ± 1.8% | 115.86 ± 1.6% | 262.04 ± 11.2% | 695.09 ± 2.1% | 3587.97 ± 2.5% | 352.12 ± 0.3% | 0.99 | 1.00 | 3.05 | 1.35 |
| a UUID | 62 | 237.50 ± 0.4% | 238.62 ± 0.3% | 267.43 ± 0.5% | 61.73 ± 1.1% | 118.84 ± 7.4% | 253.34 ± 1.8% | 4516.92 ± 3.9% | 237.38 ± 0.6% | 1.00 | 1.00 | 3.85 | 2.00 |
| an IPv4 address | 29 | 637.90 ± 0.7% | 641.57 ± 0.4% | 856.87 ± 0.6% | 99.36 ± 0.5% | 154.40 ± 4.3% | 422.15 ± 0.6% | 8426.49 ± 1.2% | 637.60 ± 0.4% | 0.99 | 1.00 | 6.42 | 4.13 |
| a date and time | 56 | 476.00 ± 0.2% | 477.00 ± 2.3% | 592.96 ± 0.3% | 94.85 ± 1.6% | 166.68 ± 20.8% | 451.46 ± 1.5% | 4709.38 ± 1.7% | 476.10 ± 2.1% | 1.00 | 1.00 | 5.02 | 2.86 |
| a field path | 39 | 368.16 ± 0.3% | 370.12 ± 0.3% | 426.84 ± 0.4% | 104.67 ± 1.4% | 245.69 ± 7.9% | 704.08 ± 1.2% | 4615.28 ± 1.6% | 368.19 ± 0.3% | 0.99 | 1.00 | 3.52 | 1.50 |
| literal: a word | 7 | 1135.86 ± 0.2% | 1182.10 ± 0.8% | 1922.22 ± 0.4% | 704.86 ± 0.6% | 819.48 ± 1.6% | 1442.23 ± 0.6% | 30925.92 ± 3.8% | 1133.42 ± 0.3% | 0.96 | 1.00 | 1.61 | 1.39 |
| literal: a word that is not there | 8 | 1095.30 ± 0.9% | 1139.21 ± 0.6% | 1811.03 ± 0.5% | 628.67 ± 0.3% | 780.67 ± 6.1% | 1351.42 ± 0.5% | 29222.40 ± 0.6% | 1094.01 ± 0.4% | 0.96 | 1.00 | 1.74 | 1.40 |
| literal: one of four words | 26 | 598.78 ± 2.9% | 672.69 ± 3.6% | 875.27 ± 2.8% | 52.04 ± 1.0% | 303.59 ± 6.7% | 501.44 ± 1.9% | 14557.62 ± 2.1% | 598.41 ± 0.6% | 0.89 | 1.00 | 11.51 | 1.97 |
| literal: a word in any case | 11 | 816.11 ± 0.3% | 853.50 ± 0.2% | 1188.88 ± 0.2% | 17.06 ± 0.7% | 854.42 ± 2.0% | refused | 22559.25 ± 0.7% | 815.11 ± 2.3% | 0.96 | 1.00 | 47.83 | 0.96 |
| literal: an href attribute | 12 | 590.64 ± 0.5% | 599.55 ± 0.6% | 758.15 ± 0.6% | 49.75 ± 0.4% | 622.67 ± 3.7% | 1140.74 ± 2.9% | 22086.93 ± 2.6% | 590.44 ± 0.4% | 0.99 | 1.00 | 11.87 | 0.95 |
| literal: a word, second text | 10 | 1023.31 ± 0.8% | 1069.06 ± 3.5% | 1647.28 ± 0.4% | 589.21 ± 2.4% | 682.65 ± 2.3% | 1165.47 ± 0.3% | 23280.82 ± 1.4% | 1024.25 ± 0.4% | 0.96 | 1.00 | 1.74 | 1.50 |
| class: two capitalized words | 23 | 766.73 ± 0.3% | 788.77 ± 0.3% | 1088.35 ± 2.6% | 134.50 ± 0.4% | 637.51 ± 0.9% | 1112.46 ± 1.0% | 7110.79 ± 1.2% | 767.21 ± 0.5% | 0.97 | 1.00 | 5.70 | 1.20 |
| class: a word that ends in ing | 9 | 1017.08 ± 2.3% | 1075.25 ± 0.4% | 1725.73 ± 0.2% | 170.22 ± 0.5% | 941.11 ± 0.4% | 1733.88 ± 0.8% | 18031.23 ± 3.7% | 1016.96 ± 0.6% | 0.95 | 1.00 | 5.98 | 1.08 |
| class: a word in capitals | 16 | 901.44 ± 0.3% | 935.89 ± 0.2% | 1379.73 ± 1.9% | 180.70 ± 1.9% | 936.66 ± 2.7% | 1640.08 ± 0.5% | 8804.70 ± 1.9% | 901.34 ± 2.2% | 0.96 | 1.00 | 4.99 | 0.96 |
| class: a number | 6 | 1139.67 ± 0.3% | 1197.31 ± 0.4% | 2020.07 ± 0.3% | 44.69 ± 1.4% | 1746.66 ± 0.8% | 3052.55 ± 2.2% | 24988.76 ± 2.8% | 1138.80 ± 0.3% | 0.95 | 1.00 | 25.50 | 0.65 |
| class: two capitalized words, second text | 23 | 767.50 ± 0.4% | 788.64 ± 0.3% | 1087.80 ± 0.3% | 134.08 ± 0.4% | 634.45 ± 9.1% | 1130.82 ± 2.1% | 7043.81 ± 2.0% | 768.22 ± 0.2% | 0.97 | 1.00 | 5.72 | 1.21 |
| other: a word between two words | 13 | 926.43 ± 0.4% | 941.42 ± 0.3% | 1397.34 ± 0.6% | 177.58 ± 0.8% | 631.14 ± 11.8% | 1206.81 ± 1.5% | 15720.63 ± 3.2% | 925.17 ± 0.2% | 0.98 | 1.00 | 5.22 | 1.47 |
| other: a number before a unit, second text | 15 | 711.93 ± 0.1% | 757.72 ± 0.3% | 1026.52 ± 0.2% | 41.89 ± 0.3% | 789.43 ± 35.6% | 1353.80 ± 1.9% | 15691.12 ± 2.2% | 711.18 ± 1.7% | 0.94 | 1.00 | 17.00 | 0.90 |
| other: a heading's start tag | 13 | 592.22 ± 1.1% | 600.15 ± 0.5% | 768.10 ± 0.2% | 47.76 ± 2.1% | 781.14 ± 1.3% | 1319.88 ± 0.5% | 19194.37 ± 2.5% | 594.81 ± 0.5% | 0.99 | 1.00 | 12.40 | 0.76 |
| other: a whole word | 11 | 1009.35 ± 0.2% | 1037.70 ± 0.7% | 1589.06 ± 1.1% | 163.24 ± 0.3% | 729.40 ± 14.6% | 1236.75 ± 0.8% | 26533.31 ± 2.6% | 1008.13 ± 0.1% | 0.97 | 1.00 | 6.18 | 1.38 |
| other: a line's first word, second text | 17 | 880.23 ± 0.4% | 926.02 ± 0.4% | 1389.05 ± 0.3% | 172.10 ± 0.2% | 882.34 ± 0.6% | refused | refused | 877.24 ± 0.6% | 0.95 | 1.00 | 5.11 | 1.00 |
| other: fourteen octets before an x | 16 | 143.35 ± 0.4% | 195.20 ± 0.2% | 224.69 ± 0.2% | 18.67 ± 0.3% | 556.37 ± 15.6% | 595.20 ± 0.5% | 14672.93 ± 1.8% | 142.94 ± 2.6% | 0.73 | 1.00 | 7.68 | 0.26 |
| other: a Greek word | 8 | 1029.39 ± 0.5% | 1094.36 ± 0.4% | 1756.01 ± 0.2% | 61.68 ± 0.3% | 1726.90 ± 1.0% | 2880.16 ± 0.6% | refused | 1029.45 ± 0.5% | 0.94 | 1.00 | 16.69 | 0.60 |

