# bench-regex

| Field | Value |
|---|---|
| Commit | f2b7425 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45063435700 |
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
| literal: a word | 217 | 59435.49 ± 0.3% | 1264.98 ± 0.7% | 46.52 ± 0.5% | 41842.93 ± 2.6% | 16655.11 ± 4.7% | 16.71 ± 0.4% | 153.06 ± 1.1% | 59354.58 ± 0.4% | 46.99 | 1.00 | 1.42 | 3.57 |
| literal: a word that is not there | 0 | 84622.38 ± 1.2% | 1281.24 ± 5.8% | 46.66 ± 4.9% | 56188.18 ± 2.1% | 58246.99 ± 1.3% | 16.23 ± 0.7% | 153.85 ± 11.7% | 84685.41 ± 0.8% | 66.05 | 1.00 | 1.51 | 1.45 |
| literal: one of four words | 661 | 19187.08 ± 2.3% | 1239.62 ± 1.2% | 25.26 ± 1.7% | 15151.51 ± 0.4% | 39.52 ± 9.5% | 5.23 ± 1.6% | 13.42 ± 2.4% | 19221.39 ± 0.7% | 15.48 | 1.00 | 1.27 | 485.51 |
| literal: a word in any case | 217 | 51613.13 ± 1.6% | 1267.41 ± 0.2% | 33.95 ± 0.7% | 14978.48 ± 1.5% | 73.68 ± 9.9% | refused | differs | 51519.97 ± 4.3% | 40.72 | 1.00 | 3.45 | 700.50 |
| literal: an href attribute | 33 | 58669.39 ± 1.2% | 1277.91 ± 0.3% | 39.94 ± 0.9% | 38652.58 ± 6.7% | 3686.51 ± 2.7% | 11.88 ± 0.8% | 136.31 ± 3.4% | 58513.04 ± 4.8% | 45.91 | 1.00 | 1.52 | 15.91 |
| literal: a word, second text | 123 | 59229.30 ± 3.8% | 1272.58 ± 0.1% | 45.43 ± 1.0% | 43227.84 ± 20.6% | 15245.87 ± 5.6% | 21.85 ± 0.7% | 129.22 ± 0.7% | 59123.08 ± 3.2% | 46.54 | 1.00 | 1.37 | 3.88 |
| class: two capitalized words | 1331 | 1160.66 ± 1.9% | 1171.53 ± 1.2% | 43.32 ± 3.3% | 715.41 ± 0.5% | 64.52 ± 9.0% | 14.49 ± 0.7% | 109.66 ± 2.3% | 1161.39 ± 2.3% | 0.99 | 1.00 | 1.62 | 17.99 |
| class: a word that ends in ing | 3399 | 1073.91 ± 1.0% | 1073.07 ± 0.6% | 29.65 ± 0.4% | 669.16 ± 0.7% | 46.30 ± 4.4% | 8.22 ± 1.2% | 30.65 ± 4.2% | 1071.84 ± 0.2% | 1.00 | 1.00 | 1.60 | 23.19 |
| class: a word in capitals | 2332 | 1699.80 ± 1.5% | 1142.18 ± 0.7% | 44.26 ± 0.9% | 701.38 ± 0.4% | 69.16 ± 14.8% | 17.18 ± 0.4% | 141.81 ± 6.8% | 1669.08 ± 3.5% | 1.49 | 1.02 | 2.42 | 24.58 |
| class: a number | 8288 | 2810.46 ± 1.9% | 964.77 ± 0.3% | 44.27 ± 2.9% | 2459.30 ± 3.0% | 58.30 ± 25.1% | 0.47 ± 2.8% | 99.67 ± 3.5% | 2803.55 ± 5.8% | 2.91 | 1.00 | 1.14 | 48.20 |
| class: two capitalized words, second text | 5359 | 859.34 ± 0.7% | 859.41 ± 1.5% | 38.50 ± 2.9% | 599.10 ± 4.0% | 52.96 ± 9.9% | 18.50 ± 2.4% | 99.89 ± 3.1% | 859.83 ± 0.9% | 1.00 | 1.00 | 1.43 | 16.23 |
| other: a word between two words | 6104 | 1096.32 ± 2.3% | 891.12 ± 2.7% | 38.17 ± 1.9% | 993.17 ± 1.1% | 177.13 ± 5.4% | 10.85 ± 4.1% | 115.93 ± 2.3% | 1096.79 ± 1.3% | 1.23 | 1.00 | 1.10 | 6.19 |
| other: a number before a unit, second text | 1481 | 14044.45 ± 1.5% | 1200.62 ± 0.1% | 42.87 ± 0.7% | 12685.67 ± 3.9% | 62.70 ± 3.8% | 20.11 ± 0.9% | 106.46 ± 2.5% | 13766.87 ± 1.1% | 11.70 | 1.02 | 1.11 | 224.01 |
| other: a heading's start tag | 110 | 32163.59 ± 1.5% | 1266.17 ± 0.2% | 44.24 ± 4.5% | 3479.05 ± 0.8% | 2674.07 ± 6.3% | 14.74 ± 1.3% | 167.54 ± 6.3% | 32054.87 ± 2.4% | 25.40 | 1.00 | 9.24 | 12.03 |
| other: a whole word | 217 | 40112.61 ± 1.8% | 1267.55 ± 0.3% | 47.31 ± 1.2% | 31320.53 ± 5.0% | 78.55 ± 4.1% | 14.01 ± 1.2% | 85.10 ± 3.0% | 40177.12 ± 2.9% | 31.65 | 1.00 | 1.28 | 510.66 |
| other: a line's first word, second text | 3716 | 3555.73 ± 0.6% | 1042.85 ± 1.0% | 51.55 ± 1.7% | 3745.21 ± 5.2% | 103.15 ± 11.0% | refused | refused | 3543.12 ± 0.4% | 3.41 | 1.00 | 0.95 | 34.47 |
| other: fourteen octets before an x | 87 | 50898.81 ± 1.9% | 2.54 ± 0.8% | 2.51 ± 0.2% | 5035.70 ± 0.4% | 15.42 ± 1.1% | differs | 26.85 ± 1.1% | 50588.80 ± 1.4% | 20053.81 | 1.01 | 10.11 | 3300.99 |
| other: a Greek word | 21815 | 639.44 ± 7.2% | 432.47 ± 9.0% | 45.73 ± 1.1% | 378.29 ± 0.5% | 62.47 ± 6.7% | differs | refused | 637.40 ± 2.9% | 1.48 | 1.00 | 1.69 | 10.24 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 38.96 ± 1.1% | 39.14 ± 0.9% | 0.94 ± 1.7% | 33.34 ± 1.6% | 4.06 ± 4.6% | differs | 5.85 ± 4.2% | 39.19 ± 1.7% | 1.00 | 0.99 | 1.17 | 9.60 |
| a UUID | 32895 | 32.94 ± 3.2% | 32.97 ± 0.4% | 1.10 ± 7.3% | 27.28 ± 1.0% | 3.66 ± 1.9% | 0.77 ± 1.6% | 4.81 ± 5.7% | 33.03 ± 2.4% | 1.00 | 1.00 | 1.21 | 9.01 |
| an IPv4 address | 33176 | 54.76 ± 1.8% | 55.07 ± 5.0% | 3.61 ± 1.4% | 47.49 ± 5.5% | 9.45 ± 4.2% | differs | 6.19 ± 1.2% | 55.29 ± 1.2% | 0.99 | 0.99 | 1.15 | 5.79 |
| a date and time | 32954 | 49.41 ± 2.2% | 50.61 ± 0.5% | 2.66 ± 2.4% | 40.89 ± 4.3% | 10.92 ± 9.6% | 1.35 ± 0.6% | 11.34 ± 10.5% | 50.58 ± 0.4% | 0.98 | 0.98 | 1.21 | 4.52 |
| a field path | 32606 | 42.57 ± 1.8% | 42.35 ± 4.3% | 1.53 ± 1.1% | 37.71 ± 5.0% | 4.93 ± 1.5% | differs | 4.32 ± 0.4% | 42.58 ± 1.7% | 1.01 | 1.00 | 1.13 | 8.63 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 17.32 ± 0.5% | 17.36 ± 0.7% | 17.37 ± 0.4% | 18.63 ± 3.4% | 7.95 ± 5.8% | 1.10 ± 0.4% | none | 15.80 ± 0.1% | 1.00 | 1.10 | 0.93 | 2.18 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 473.23 ± 4.0% | 473.56 ± 1.1% | 547.90 ± 2.9% | 142.90 ± 1.9% | 350.39 ± 40.3% | 909.36 ± 8.8% | 6046.35 ± 3.8% | 471.19 ± 2.3% | 1.00 | 1.00 | 3.31 | 1.35 |
| a UUID | 62 | 311.97 ± 0.8% | 312.63 ± 1.1% | 347.88 ± 1.1% | 78.33 ± 1.7% | 170.35 ± 1.9% | 326.02 ± 5.1% | 7316.68 ± 2.6% | 311.73 ± 0.9% | 1.00 | 1.00 | 3.98 | 1.83 |
| an IPv4 address | 29 | 848.27 ± 3.9% | 858.85 ± 7.0% | 1104.05 ± 9.6% | 125.51 ± 1.4% | 214.01 ± 1.8% | 581.94 ± 1.2% | 13318.18 ± 0.9% | 849.17 ± 0.7% | 0.99 | 1.00 | 6.76 | 3.96 |
| a date and time | 56 | 605.14 ± 3.2% | 608.25 ± 0.3% | 715.74 ± 1.1% | 121.96 ± 0.5% | 235.00 ± 1.6% | 611.69 ± 0.7% | 7875.41 ± 1.1% | 602.55 ± 3.0% | 0.99 | 1.00 | 4.96 | 2.58 |
| a field path | 39 | 501.01 ± 0.8% | 504.74 ± 1.0% | 579.69 ± 0.9% | 133.30 ± 2.9% | 322.16 ± 4.9% | 962.49 ± 4.6% | 7573.22 ± 5.2% | 498.92 ± 4.2% | 0.99 | 1.00 | 3.76 | 1.56 |
| literal: a word | 7 | 1456.64 ± 2.5% | 1500.05 ± 4.3% | 2382.49 ± 0.7% | 858.57 ± 5.4% | 1086.50 ± 1.6% | 1929.36 ± 0.5% | 49313.12 ± 0.7% | 1454.40 ± 1.6% | 0.97 | 1.00 | 1.70 | 1.34 |
| literal: a word that is not there | 8 | 1395.19 ± 3.3% | 1454.04 ± 0.5% | 2240.24 ± 1.0% | 801.48 ± 1.1% | 1061.00 ± 9.1% | 1825.20 ± 1.1% | 49033.95 ± 1.8% | 1408.13 ± 14.3% | 0.96 | 0.99 | 1.74 | 1.31 |
| literal: one of four words | 26 | 715.75 ± 4.4% | 776.33 ± 2.4% | 971.48 ± 1.5% | 76.26 ± 0.7% | 410.63 ± 1.6% | 693.73 ± 1.7% | 25223.18 ± 4.8% | 715.65 ± 0.9% | 0.92 | 1.00 | 9.39 | 1.74 |
| literal: a word in any case | 11 | 1066.35 ± 0.8% | 1108.64 ± 0.8% | 1531.63 ± 1.3% | 25.12 ± 1.8% | 1142.72 ± 1.4% | refused | 37729.10 ± 2.0% | 1072.75 ± 1.1% | 0.96 | 0.99 | 42.45 | 0.93 |
| literal: an href attribute | 12 | 783.42 ± 5.1% | 791.59 ± 0.8% | 1012.48 ± 2.3% | 63.88 ± 3.4% | 794.62 ± 3.5% | 1557.96 ± 5.0% | 36761.94 ± 1.1% | 785.69 ± 1.1% | 0.99 | 1.00 | 12.26 | 0.99 |
| literal: a word, second text | 10 | 1258.41 ± 6.7% | 1319.26 ± 0.8% | 1939.74 ± 2.7% | 735.03 ± 1.4% | 912.39 ± 7.2% | 1609.96 ± 0.4% | 47441.06 ± 0.6% | 1269.18 ± 1.4% | 0.95 | 0.99 | 1.71 | 1.38 |
| class: two capitalized words | 23 | 976.42 ± 1.2% | 1010.87 ± 4.8% | 1336.64 ± 7.9% | 163.80 ± 1.3% | 842.29 ± 5.2% | 1497.21 ± 1.8% | 10083.00 ± 0.3% | 974.57 ± 4.7% | 0.97 | 1.00 | 5.96 | 1.16 |
| class: a word that ends in ing | 9 | 1310.46 ± 0.2% | 1399.01 ± 0.6% | 2117.34 ± 0.3% | 211.62 ± 1.0% | 1178.24 ± 2.6% | 2291.93 ± 4.2% | 26228.57 ± 1.1% | 1304.96 ± 1.1% | 0.94 | 1.00 | 6.19 | 1.11 |
| class: a word in capitals | 16 | 1145.39 ± 0.4% | 1198.00 ± 0.8% | 1679.01 ± 0.8% | 215.67 ± 0.9% | 1233.62 ± 27.6% | 2163.37 ± 0.9% | 13080.54 ± 0.4% | 1144.74 ± 2.6% | 0.96 | 1.00 | 5.31 | 0.93 |
| class: a number | 6 | 1463.46 ± 3.6% | 1551.62 ± 2.2% | 2467.77 ± 1.2% | 63.15 ± 0.6% | 2291.87 ± 7.5% | 3621.31 ± 1.1% | 37892.47 ± 6.0% | 1468.82 ± 3.5% | 0.94 | 1.00 | 23.17 | 0.64 |
| class: two capitalized words, second text | 23 | 970.22 ± 5.2% | 1008.07 ± 4.0% | 1318.29 ± 2.6% | 166.20 ± 1.2% | 836.70 ± 6.0% | 1521.07 ± 1.3% | 10104.15 ± 0.2% | 970.73 ± 2.1% | 0.96 | 1.00 | 5.84 | 1.16 |
| other: a word between two words | 13 | 1205.75 ± 0.9% | 1229.53 ± 1.0% | 1736.62 ± 4.3% | 219.15 ± 2.0% | 808.81 ± 27.0% | 1646.22 ± 1.0% | 24627.49 ± 0.3% | 1200.93 ± 2.9% | 0.98 | 1.00 | 5.50 | 1.49 |
| other: a number before a unit, second text | 15 | 953.42 ± 1.9% | 1019.57 ± 1.2% | 1363.89 ± 1.4% | 59.71 ± 4.8% | 1000.97 ± 1.7% | 1805.61 ± 3.4% | 25294.59 ± 0.6% | 954.04 ± 0.5% | 0.94 | 1.00 | 15.97 | 0.95 |
| other: a heading's start tag | 13 | 797.42 ± 0.6% | 803.39 ± 2.7% | 1042.14 ± 3.7% | 61.89 ± 0.1% | 979.17 ± 1.4% | 1748.57 ± 0.4% | 30025.32 ± 2.4% | 797.84 ± 1.1% | 0.99 | 1.00 | 12.89 | 0.81 |
| other: a whole word | 11 | 1258.97 ± 2.0% | 1294.24 ± 1.9% | 1871.04 ± 2.3% | 201.59 ± 1.1% | 945.71 ± 9.0% | 1690.05 ± 2.5% | 43548.15 ± 10.3% | 1260.06 ± 2.6% | 0.97 | 1.00 | 6.25 | 1.33 |
| other: a line's first word, second text | 17 | 1194.39 ± 1.7% | 1248.15 ± 0.9% | 1775.95 ± 0.8% | 208.26 ± 0.6% | 1119.22 ± 8.6% | refused | refused | 1194.49 ± 0.8% | 0.96 | 1.00 | 5.74 | 1.07 |
| other: fourteen octets before an x | 16 | 205.41 ± 0.3% | 276.98 ± 1.1% | 319.83 ± 2.2% | 23.39 ± 5.3% | 724.97 ± 5.4% | 783.42 ± 0.2% | 22083.86 ± 0.5% | 205.51 ± 3.6% | 0.74 | 1.00 | 8.78 | 0.28 |
| other: a Greek word | 8 | 1287.46 ± 0.5% | 1385.73 ± 0.9% | 2089.46 ± 1.9% | 78.05 ± 0.7% | 2239.68 ± 2.4% | 3594.18 ± 0.6% | refused | 1286.84 ± 2.2% | 0.93 | 1.00 | 16.50 | 0.57 |

