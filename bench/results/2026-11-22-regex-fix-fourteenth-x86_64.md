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
| literal: a word | 217 | 44244.90 ± 0.2% | 1028.30 ± 0.4% | 31.35 ± 0.5% | 40035.71 ± 3.1% | 12190.63 ± 4.6% | 12.58 ± 0.4% | 104.32 ± 1.7% | 44349.71 ± 1.3% | 43.03 | 1.00 | 1.11 | 3.63 |
| literal: a word that is not there | 0 | 62421.59 ± 1.5% | 1038.17 ± 0.3% | 31.37 ± 2.0% | 45797.74 ± 0.3% | 44459.69 ± 0.7% | 12.81 ± 0.6% | 98.79 ± 0.1% | 62450.09 ± 0.5% | 60.13 | 1.00 | 1.36 | 1.40 |
| literal: one of four words | 661 | 13349.22 ± 0.9% | 1006.72 ± 0.8% | 17.15 ± 0.5% | 11540.41 ± 1.9% | 24.24 ± 2.3% | 4.47 ± 0.1% | 7.99 ± 3.7% | 13313.58 ± 0.6% | 13.26 | 1.00 | 1.16 | 550.72 |
| literal: a word in any case | 217 | 38079.00 ± 0.1% | 1028.27 ± 0.4% | 24.05 ± 0.5% | 11451.43 ± 1.9% | 47.71 ± 9.7% | refused | differs | 37991.07 ± 9.4% | 37.03 | 1.00 | 3.33 | 798.11 |
| literal: an href attribute | 33 | 44280.21 ± 0.2% | 1034.83 ± 0.2% | 30.01 ± 2.6% | 35114.40 ± 2.0% | 3051.81 ± 6.1% | 9.72 ± 0.1% | 90.37 ± 3.5% | 44309.68 ± 0.3% | 42.79 | 1.00 | 1.26 | 14.51 |
| literal: a word, second text | 123 | 47354.16 ± 0.3% | 1028.55 ± 0.2% | 30.88 ± 0.5% | 40700.59 ± 0.3% | 10590.23 ± 9.1% | 14.50 ± 0.3% | 87.15 ± 1.6% | 47302.21 ± 0.2% | 46.04 | 1.00 | 1.16 | 4.47 |
| class: two capitalized words | 1331 | 915.34 ± 0.1% | 951.37 ± 0.2% | 29.20 ± 0.3% | 576.25 ± 0.2% | 44.81 ± 0.3% | 11.05 ± 0.2% | 80.33 ± 0.4% | 914.77 ± 0.2% | 0.96 | 1.00 | 1.59 | 20.43 |
| class: a word that ends in ing | 3399 | 876.27 ± 0.3% | 874.80 ± 0.6% | 19.96 ± 0.5% | 541.55 ± 0.2% | 32.66 ± 7.9% | 6.23 ± 3.4% | 20.21 ± 0.4% | 871.76 ± 0.4% | 1.00 | 1.01 | 1.62 | 26.83 |
| class: a word in capitals | 2332 | 1138.12 ± 0.2% | 930.99 ± 0.4% | 30.70 ± 1.7% | 566.33 ± 0.8% | 48.00 ± 18.7% | 12.43 ± 0.4% | 101.39 ± 1.8% | 1144.88 ± 0.2% | 1.22 | 0.99 | 2.01 | 23.71 |
| class: a number | 8288 | 1875.05 ± 0.5% | 792.32 ± 1.0% | 31.21 ± 0.4% | 1867.57 ± 0.5% | 48.67 ± 15.5% | 0.39 ± 0.4% | 73.76 ± 1.5% | 1871.17 ± 0.3% | 2.37 | 1.00 | 1.00 | 38.53 |
| class: two capitalized words, second text | 5359 | 691.69 ± 1.1% | 693.06 ± 0.2% | 26.43 ± 1.3% | 479.21 ± 0.6% | 39.45 ± 6.5% | 12.65 ± 0.7% | 74.42 ± 0.7% | 687.86 ± 0.2% | 1.00 | 1.01 | 1.44 | 17.54 |
| other: a word between two words | 6104 | 839.18 ± 0.3% | 740.07 ± 0.8% | 26.25 ± 0.4% | 836.27 ± 0.5% | 130.67 ± 11.1% | 8.57 ± 0.3% | 81.68 ± 0.2% | 838.72 ± 0.6% | 1.13 | 1.00 | 1.00 | 6.42 |
| other: a number before a unit, second text | 1481 | 10577.46 ± 1.2% | 979.53 ± 0.1% | 29.11 ± 0.2% | 9303.66 ± 0.7% | 45.76 ± 0.7% | 13.22 ± 0.2% | 77.93 ± 0.5% | 10543.81 ± 0.3% | 10.80 | 1.00 | 1.14 | 231.14 |
| other: a heading's start tag | 110 | 25536.00 ± 0.3% | 1025.09 ± 0.7% | 30.79 ± 0.0% | 2649.54 ± 1.3% | 1994.74 ± 9.1% | 11.86 ± 0.2% | 106.99 ± 5.6% | 25052.35 ± 0.1% | 24.91 | 1.02 | 9.64 | 12.80 |
| other: a whole word | 217 | 31352.69 ± 3.2% | 1028.33 ± 0.2% | 32.31 ± 0.7% | 29158.72 ± 0.3% | 54.50 ± 7.4% | 11.18 ± 0.2% | 62.95 ± 3.1% | 31473.68 ± 0.3% | 30.49 | 1.00 | 1.08 | 575.30 |
| other: a line's first word, second text | 3716 | 2520.91 ± 6.9% | 848.58 ± 0.1% | 36.70 ± 0.4% | 2435.36 ± 6.1% | 69.89 ± 11.0% | refused | refused | 2509.17 ± 4.8% | 2.97 | 1.00 | 1.04 | 36.07 |
| other: fourteen octets before an x | 87 | 38252.41 ± 0.6% | 1.74 ± 1.1% | 1.66 ± 1.7% | 3546.27 ± 0.1% | 11.57 ± 0.8% | differs | 21.59 ± 3.7% | 38138.59 ± 0.3% | 21961.27 | 1.00 | 10.79 | 3304.86 |
| other: a Greek word | 21815 | 465.65 ± 0.2% | 334.66 ± 0.2% | 34.87 ± 5.0% | 305.34 ± 0.4% | 57.63 ± 13.4% | differs | refused | 456.96 ± 3.2% | 1.39 | 1.02 | 1.53 | 8.08 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 30.69 ± 4.7% | 30.78 ± 0.5% | 0.61 ± 2.2% | 25.83 ± 0.4% | 2.84 ± 0.3% | differs | 4.03 ± 2.9% | 30.84 ± 2.1% | 1.00 | 1.00 | 1.19 | 10.82 |
| a UUID | 32895 | 25.74 ± 0.2% | 25.80 ± 0.1% | 0.75 ± 0.8% | 18.92 ± 0.3% | 3.09 ± 2.7% | 0.52 ± 0.1% | 3.63 ± 0.9% | 25.60 ± 0.2% | 1.00 | 1.01 | 1.36 | 8.32 |
| an IPv4 address | 33176 | 44.21 ± 0.9% | 44.18 ± 0.6% | 2.40 ± 0.9% | 35.80 ± 0.1% | 6.99 ± 1.3% | differs | 4.18 ± 1.8% | 44.27 ± 0.4% | 1.00 | 1.00 | 1.24 | 6.32 |
| a date and time | 32954 | 39.22 ± 2.1% | 39.01 ± 1.5% | 1.79 ± 0.5% | 29.47 ± 0.2% | 8.52 ± 0.5% | 0.91 ± 0.4% | 7.82 ± 1.2% | 39.38 ± 0.3% | 1.01 | 1.00 | 1.33 | 4.60 |
| a field path | 32606 | 34.79 ± 0.8% | 34.79 ± 0.3% | 0.95 ± 0.8% | 29.33 ± 0.4% | 3.58 ± 0.8% | differs | 3.00 ± 2.6% | 34.73 ± 0.3% | 1.00 | 1.00 | 1.19 | 9.73 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.50 ± 6.4% | 11.54 ± 1.2% | 11.55 ± 0.8% | 13.48 ± 1.1% | 5.87 ± 1.8% | 0.75 ± 0.3% | none | 11.51 ± 6.8% | 1.00 | 1.00 | 0.85 | 1.96 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 307.07 ± 0.2% | 308.54 ± 0.5% | 357.98 ± 0.4% | 101.06 ± 1.5% | 240.63 ± 1.5% | 700.51 ± 7.3% | 4823.04 ± 0.6% | 306.70 ± 2.3% | 1.00 | 1.00 | 3.04 | 1.28 |
| a UUID | 62 | 201.25 ± 4.4% | 201.84 ± 0.1% | 227.94 ± 5.0% | 57.71 ± 1.7% | 117.15 ± 1.1% | 249.88 ± 1.7% | 5183.64 ± 0.9% | 201.00 ± 4.6% | 1.00 | 1.00 | 3.49 | 1.72 |
| an IPv4 address | 29 | 558.15 ± 0.3% | 565.04 ± 0.4% | 762.30 ± 5.3% | 87.13 ± 3.9% | 148.45 ± 0.9% | 396.14 ± 4.4% | 8903.81 ± 0.1% | 559.58 ± 0.3% | 0.99 | 1.00 | 6.41 | 3.76 |
| a date and time | 56 | 402.37 ± 0.2% | 405.73 ± 0.4% | 495.65 ± 1.8% | 86.83 ± 0.6% | 156.24 ± 5.3% | 454.97 ± 3.3% | 5282.87 ± 0.1% | 402.86 ± 0.7% | 0.99 | 1.00 | 4.63 | 2.58 |
| a field path | 39 | 320.92 ± 0.2% | 322.72 ± 0.2% | 376.11 ± 0.4% | 95.70 ± 2.3% | 227.05 ± 1.2% | 716.20 ± 5.5% | 5763.05 ± 0.6% | 320.55 ± 0.6% | 0.99 | 1.00 | 3.35 | 1.41 |
| literal: a word | 7 | 924.27 ± 0.2% | 957.04 ± 0.3% | 1605.98 ± 0.6% | 662.07 ± 3.2% | 795.82 ± 44.1% | 1587.69 ± 0.8% | 33241.55 ± 0.2% | 924.14 ± 0.6% | 0.97 | 1.00 | 1.40 | 1.16 |
| literal: a word that is not there | 8 | 889.75 ± 0.3% | 918.86 ± 0.8% | 1509.01 ± 6.1% | 607.70 ± 0.5% | 758.48 ± 2.1% | 1501.06 ± 4.7% | 31525.08 ± 0.6% | 889.32 ± 0.3% | 0.97 | 1.00 | 1.46 | 1.17 |
| literal: one of four words | 26 | 464.10 ± 1.3% | 505.80 ± 6.0% | 656.62 ± 0.9% | 58.76 ± 1.2% | 287.88 ± 32.1% | 590.83 ± 1.8% | 15748.51 ± 8.9% | 465.06 ± 0.7% | 0.92 | 1.00 | 7.90 | 1.61 |
| literal: a word in any case | 11 | 690.07 ± 1.0% | 713.50 ± 0.6% | 1042.51 ± 0.4% | 19.77 ± 4.1% | 816.88 ± 1.7% | refused | 24980.63 ± 2.1% | 690.03 ± 1.2% | 0.97 | 1.00 | 34.91 | 0.84 |
| literal: an href attribute | 12 | 516.68 ± 0.2% | 528.16 ± 0.5% | 695.84 ± 1.2% | 50.45 ± 3.8% | 569.21 ± 7.7% | 1237.00 ± 6.6% | 22198.42 ± 10.8% | 516.35 ± 8.2% | 0.98 | 1.00 | 10.24 | 0.91 |
| literal: a word, second text | 10 | 826.22 ± 0.2% | 853.74 ± 0.7% | 1350.45 ± 0.1% | 542.86 ± 0.9% | 650.80 ± 21.5% | 1354.12 ± 0.8% | 28576.22 ± 0.8% | 825.05 ± 0.2% | 0.97 | 1.00 | 1.52 | 1.27 |
| class: two capitalized words | 23 | 612.73 ± 20.9% | 642.86 ± 5.6% | 881.93 ± 0.8% | 121.45 ± 0.9% | 586.60 ± 2.8% | 1256.14 ± 6.7% | 7782.85 ± 4.9% | 614.02 ± 13.6% | 0.95 | 1.00 | 5.04 | 1.04 |
| class: a word that ends in ing | 9 | 828.06 ± 0.2% | 891.18 ± 0.8% | 1426.60 ± 2.5% | 150.81 ± 1.1% | 865.73 ± 0.5% | 1914.35 ± 0.4% | 18976.54 ± 0.2% | 827.11 ± 5.1% | 0.93 | 1.00 | 5.49 | 0.96 |
| class: a word in capitals | 16 | 715.77 ± 0.5% | 757.13 ± 1.0% | 1109.57 ± 1.1% | 155.22 ± 7.3% | 887.97 ± 2.6% | 1652.83 ± 4.9% | 10374.64 ± 0.1% | 715.51 ± 0.7% | 0.95 | 1.00 | 4.61 | 0.81 |
| class: a number | 6 | 911.96 ± 0.3% | 975.75 ± 6.9% | 1662.75 ± 0.6% | 49.35 ± 0.7% | 1648.16 ± 2.0% | 3052.35 ± 3.9% | 25644.69 ± 5.7% | 912.02 ± 0.4% | 0.93 | 1.00 | 18.48 | 0.55 |
| class: two capitalized words, second text | 23 | 609.78 ± 2.0% | 645.09 ± 0.4% | 883.69 ± 0.6% | 119.47 ± 0.6% | 593.91 ± 1.3% | 1144.23 ± 7.0% | 7778.87 ± 0.2% | 615.34 ± 0.8% | 0.95 | 0.99 | 5.10 | 1.03 |
| other: a word between two words | 13 | 759.87 ± 0.3% | 778.59 ± 0.3% | 1148.46 ± 1.0% | 156.38 ± 1.6% | 582.56 ± 1.8% | 1351.84 ± 0.7% | 16494.60 ± 2.1% | 760.32 ± 1.2% | 0.98 | 1.00 | 4.86 | 1.30 |
| other: a number before a unit, second text | 15 | 600.50 ± 3.9% | 643.47 ± 2.1% | 890.34 ± 5.3% | 46.19 ± 1.0% | 716.83 ± 18.8% | 1486.87 ± 0.6% | 16469.35 ± 2.7% | 600.81 ± 0.3% | 0.93 | 1.00 | 13.00 | 0.84 |
| other: a heading's start tag | 13 | 514.84 ± 0.5% | 521.64 ± 0.3% | 708.05 ± 0.4% | 47.98 ± 0.1% | 710.58 ± 1.2% | 1306.15 ± 4.6% | 20434.27 ± 1.3% | 514.64 ± 0.2% | 0.99 | 1.00 | 10.73 | 0.72 |
| other: a whole word | 11 | 803.35 ± 0.9% | 824.37 ± 1.7% | 1264.44 ± 1.3% | 146.97 ± 0.3% | 678.87 ± 1.4% | 1346.80 ± 0.4% | 28744.99 ± 0.2% | 798.97 ± 0.7% | 0.97 | 1.01 | 5.47 | 1.18 |
| other: a line's first word, second text | 17 | 734.84 ± 0.3% | 769.89 ± 0.3% | 1166.48 ± 0.6% | 148.90 ± 2.6% | 789.74 ± 16.0% | refused | refused | 734.38 ± 0.8% | 0.95 | 1.00 | 4.94 | 0.93 |
| other: fourteen octets before an x | 16 | 124.83 ± 0.4% | 170.44 ± 0.2% | 203.47 ± 0.2% | 17.59 ± 1.2% | 511.46 ± 20.2% | 558.74 ± 0.4% | 15447.79 ± 0.3% | 124.62 ± 0.2% | 0.73 | 1.00 | 7.10 | 0.24 |
| other: a Greek word | 8 | 827.37 ± 12.1% | 897.96 ± 0.4% | 1444.90 ± 0.2% | 62.66 ± 1.0% | 1580.65 ± 25.8% | 2818.49 ± 1.1% | refused | 824.38 ± 1.2% | 0.92 | 1.00 | 13.20 | 0.52 |

