# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45058341871 |
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
| literal: a word | 217 | 35234.18 ± 3.7% | 895.16 ± 3.3% | 20.16 ± 2.4% | 32899.72 ± 0.7% | 8909.88 ± 9.6% | 10.72 ± 0.4% | 76.21 ± 3.4% | 34536.27 ± 3.5% | 39.36 | 1.02 | 1.07 | 3.95 |
| literal: a word that is not there | 0 | 52048.78 ± 1.6% | 906.05 ± 1.0% | 20.21 ± 4.2% | 39545.90 ± 11.0% | 30234.11 ± 1.0% | 10.66 ± 0.3% | 73.10 ± 0.7% | 50999.95 ± 1.3% | 57.45 | 1.02 | 1.32 | 1.72 |
| literal: one of four words | 661 | 10026.29 ± 0.7% | 871.55 ± 0.6% | 11.08 ± 0.4% | 9571.36 ± 0.2% | 18.80 ± 6.3% | 3.98 ± 0.2% | 6.52 ± 1.9% | 9980.79 ± 0.9% | 11.50 | 1.00 | 1.05 | 533.21 |
| literal: a word in any case | 217 | 26537.70 ± 1.4% | 893.77 ± 0.1% | 15.36 ± 1.2% | 9381.56 ± 0.2% | 36.81 ± 0.3% | refused | differs | 26381.63 ± 2.3% | 29.69 | 1.01 | 2.83 | 720.86 |
| literal: an href attribute | 33 | 35533.26 ± 29.6% | 903.09 ± 0.4% | 18.90 ± 0.8% | 24755.22 ± 1.1% | 2056.13 ± 0.9% | 8.19 ± 0.3% | 67.58 ± 0.9% | 35235.79 ± 3.3% | 39.35 | 1.01 | 1.44 | 17.28 |
| literal: a word, second text | 123 | 35325.36 ± 3.1% | 899.34 ± 0.5% | 20.23 ± 1.5% | 28428.83 ± 3.5% | 7158.75 ± 12.3% | 11.90 ± 0.2% | 65.78 ± 2.0% | 35302.68 ± 1.5% | 39.28 | 1.00 | 1.24 | 4.93 |
| class: two capitalized words | 1331 | 774.56 ± 0.4% | 817.19 ± 0.9% | 18.89 ± 2.2% | 506.71 ± 0.1% | 33.77 ± 4.0% | 9.29 ± 0.2% | 58.96 ± 0.7% | 775.34 ± 1.0% | 0.95 | 1.00 | 1.53 | 22.93 |
| class: a word that ends in ing | 3399 | 741.59 ± 0.9% | 742.58 ± 0.1% | 13.69 ± 1.3% | 474.00 ± 0.7% | 25.56 ± 1.1% | 5.32 ± 0.1% | 17.13 ± 5.7% | 742.15 ± 0.5% | 1.00 | 1.00 | 1.56 | 29.01 |
| class: a word in capitals | 2332 | 977.73 ± 1.6% | 798.86 ± 0.2% | 20.08 ± 0.7% | 498.01 ± 0.8% | 34.68 ± 19.3% | 10.28 ± 0.1% | 77.33 ± 1.0% | 977.73 ± 0.2% | 1.22 | 1.00 | 1.96 | 28.19 |
| class: a number | 8288 | 1521.81 ± 0.4% | 661.61 ± 0.2% | 19.79 ± 3.1% | 1555.93 ± 2.1% | 34.30 ± 13.4% | 0.33 ± 0.4% | 56.67 ± 0.3% | 1523.19 ± 0.1% | 2.30 | 1.00 | 0.98 | 44.37 |
| class: two capitalized words, second text | 5359 | 582.57 ± 0.2% | 585.70 ± 2.0% | 17.56 ± 4.1% | 420.73 ± 0.2% | 29.08 ± 4.1% | 10.46 ± 0.3% | 54.92 ± 8.2% | 585.79 ± 0.4% | 0.99 | 0.99 | 1.38 | 20.03 |
| other: a word between two words | 6104 | 694.84 ± 0.2% | 630.49 ± 0.4% | 17.54 ± 3.7% | 724.25 ± 1.6% | 95.65 ± 19.0% | 7.23 ± 0.1% | 60.02 ± 0.4% | 694.14 ± 1.6% | 1.10 | 1.00 | 0.96 | 7.26 |
| other: a number before a unit, second text | 1481 | 7581.87 ± 4.6% | 831.00 ± 0.9% | 19.12 ± 0.5% | 6914.14 ± 0.5% | 34.38 ± 13.0% | 10.83 ± 0.2% | 59.10 ± 1.8% | 7527.75 ± 2.8% | 9.12 | 1.01 | 1.10 | 220.55 |
| other: a heading's start tag | 110 | 19792.65 ± 4.7% | 893.44 ± 17.6% | 19.80 ± 2.3% | 2050.05 ± 1.6% | 1472.57 ± 2.8% | 9.98 ± 0.3% | 78.24 ± 1.2% | 19426.39 ± 2.5% | 22.15 | 1.02 | 9.65 | 13.44 |
| other: a whole word | 217 | 24004.19 ± 3.3% | 894.91 ± 0.2% | 19.78 ± 6.3% | 22333.19 ± 0.7% | 41.10 ± 5.0% | 9.45 ± 0.3% | 46.18 ± 4.8% | 23576.44 ± 2.1% | 26.82 | 1.02 | 1.07 | 583.97 |
| other: a line's first word, second text | 3716 | 1958.74 ± 4.3% | 728.55 ± 0.1% | 22.52 ± 1.9% | 1796.45 ± 6.0% | 54.07 ± 4.6% | refused | refused | 1958.70 ± 2.4% | 2.69 | 1.00 | 1.09 | 36.23 |
| other: fourteen octets before an x | 87 | 27098.83 ± 3.3% | 1.34 ± 2.5% | 1.30 ± 0.9% | 2793.88 ± 1.1% | 9.06 ± 2.4% | differs | 16.85 ± 5.6% | 28055.69 ± 31.8% | 20229.57 | 0.97 | 9.70 | 2990.13 |
| other: a Greek word | 21815 | 395.25 ± 1.6% | 272.20 ± 0.2% | 24.12 ± 2.7% | 269.87 ± 0.7% | 41.80 ± 4.7% | differs | refused | 394.52 ± 0.9% | 1.45 | 1.00 | 1.46 | 9.46 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.66 ± 2.0% | 26.30 ± 2.3% | 0.47 ± 0.4% | 20.13 ± 0.3% | 2.07 ± 0.6% | differs | 3.42 ± 3.9% | 26.72 ± 0.4% | 1.01 | 1.00 | 1.32 | 12.88 |
| a UUID | 32895 | 22.05 ± 0.3% | 22.04 ± 0.4% | 0.58 ± 3.8% | 14.74 ± 0.3% | 2.43 ± 3.1% | 0.44 ± 0.1% | 3.15 ± 1.5% | 22.03 ± 3.3% | 1.00 | 1.00 | 1.50 | 9.09 |
| an IPv4 address | 33176 | 37.25 ± 4.1% | 37.29 ± 10.9% | 1.87 ± 2.6% | 30.07 ± 2.3% | 5.57 ± 3.0% | differs | 3.30 ± 2.4% | 37.13 ± 2.5% | 1.00 | 1.00 | 1.24 | 6.68 |
| a date and time | 32954 | 33.57 ± 0.3% | 33.58 ± 0.4% | 1.33 ± 3.7% | 22.15 ± 2.3% | 6.50 ± 0.4% | 0.76 ± 0.2% | 6.05 ± 3.5% | 33.62 ± 5.9% | 1.00 | 1.00 | 1.52 | 5.16 |
| a field path | 32606 | 29.92 ± 6.3% | 30.01 ± 0.8% | 0.76 ± 0.7% | 23.45 ± 0.3% | 2.90 ± 0.7% | differs | 2.32 ± 5.0% | 29.87 ± 6.7% | 1.00 | 1.00 | 1.28 | 10.33 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.14 ± 1.8% | 8.06 ± 28.4% | 8.04 ± 1.0% | 10.70 ± 0.2% | 4.56 ± 1.4% | 0.63 ± 0.4% | none | 8.16 ± 8.0% | 1.01 | 1.00 | 0.76 | 1.78 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 165.12 ± 5.3% | 165.31 ± 0.4% | 184.09 ± 0.5% | 80.49 ± 8.9% | 189.36 ± 6.3% | 523.58 ± 2.3% | 3863.40 ± 1.5% | 165.40 ± 0.2% | 1.00 | 1.00 | 2.05 | 0.87 |
| a UUID | 62 | 123.52 ± 0.7% | 123.78 ± 0.8% | 136.20 ± 3.9% | 46.47 ± 1.0% | 90.43 ± 3.2% | 197.24 ± 1.4% | 4032.11 ± 0.5% | 123.66 ± 4.6% | 1.00 | 1.00 | 2.66 | 1.37 |
| an IPv4 address | 29 | 254.06 ± 0.2% | 254.13 ± 0.1% | 299.74 ± 0.1% | 70.57 ± 0.9% | 114.09 ± 3.5% | 321.76 ± 3.1% | 6938.32 ± 3.1% | 254.31 ± 0.3% | 1.00 | 1.00 | 3.60 | 2.23 |
| a date and time | 56 | 200.46 ± 0.3% | 200.63 ± 0.9% | 227.04 ± 0.3% | 69.07 ± 1.0% | 123.09 ± 3.3% | 372.06 ± 1.2% | 4109.11 ± 0.5% | 200.10 ± 0.8% | 1.00 | 1.00 | 2.90 | 1.63 |
| a field path | 39 | 173.19 ± 0.2% | 173.27 ± 3.6% | 193.40 ± 0.8% | 74.43 ± 1.1% | 170.54 ± 16.5% | 564.05 ± 1.7% | 4621.54 ± 0.7% | 172.93 ± 6.8% | 1.00 | 1.00 | 2.33 | 1.02 |
| literal: a word | 7 | 329.66 ± 0.7% | 333.95 ± 0.5% | 406.52 ± 0.2% | 485.11 ± 2.7% | 579.47 ± 7.9% | 1211.84 ± 4.3% | 24535.24 ± 2.7% | 329.58 ± 0.4% | 0.99 | 1.00 | 0.68 | 0.57 |
| literal: a word that is not there | 8 | 322.64 ± 0.3% | 326.64 ± 1.3% | 398.54 ± 3.7% | 460.89 ± 45.4% | 550.66 ± 4.0% | 1131.65 ± 1.2% | 21776.79 ± 3.2% | 322.20 ± 0.4% | 0.99 | 1.00 | 0.70 | 0.59 |
| literal: one of four words | 26 | 232.04 ± 1.0% | 243.88 ± 0.2% | 282.66 ± 4.6% | 44.82 ± 0.7% | 218.21 ± 2.0% | 443.00 ± 0.9% | 9977.87 ± 7.4% | 231.70 ± 1.2% | 0.95 | 1.00 | 5.18 | 1.06 |
| literal: a word in any case | 11 | 200.95 ± 0.3% | 203.09 ± 0.2% | 230.21 ± 20.4% | 15.22 ± 1.1% | 616.96 ± 1.3% | refused | 18956.21 ± 10.3% | 200.49 ± 0.1% | 0.99 | 1.00 | 13.20 | 0.33 |
| literal: an href attribute | 12 | 248.08 ± 0.3% | 249.09 ± 0.0% | 291.53 ± 0.3% | 37.03 ± 1.5% | 438.22 ± 3.8% | 931.23 ± 8.5% | 18188.37 ± 2.3% | 247.72 ± 0.3% | 1.00 | 1.00 | 6.70 | 0.57 |
| literal: a word, second text | 10 | 312.51 ± 0.5% | 316.03 ± 0.5% | 384.98 ± 0.3% | 416.72 ± 0.9% | 499.72 ± 1.6% | 999.50 ± 0.8% | 20238.80 ± 0.9% | 312.62 ± 0.4% | 0.99 | 1.00 | 0.75 | 0.63 |
| class: two capitalized words | 23 | 269.46 ± 0.3% | 273.94 ± 0.4% | 321.26 ± 0.4% | 95.04 ± 4.1% | 461.74 ± 7.3% | 912.09 ± 5.2% | 6127.02 ± 0.3% | 268.73 ± 0.7% | 0.98 | 1.00 | 2.84 | 0.58 |
| class: a word that ends in ing | 9 | 317.48 ± 0.7% | 327.26 ± 5.7% | 395.78 ± 0.2% | 114.45 ± 1.6% | 661.37 ± 5.1% | 1366.19 ± 9.1% | 14811.09 ± 0.3% | 317.46 ± 0.8% | 0.97 | 1.00 | 2.77 | 0.48 |
| class: a word in capitals | 16 | 287.71 ± 0.3% | 293.72 ± 0.7% | 347.69 ± 3.0% | 123.29 ± 0.8% | 673.82 ± 0.7% | 1252.57 ± 0.4% | 8221.67 ± 0.5% | 287.31 ± 0.7% | 0.98 | 1.00 | 2.33 | 0.43 |
| class: a number | 6 | 332.40 ± 5.6% | 340.40 ± 6.1% | 415.82 ± 0.7% | 37.41 ± 0.5% | 1212.18 ± 2.0% | 2425.06 ± 8.4% | 19827.09 ± 0.6% | 332.60 ± 0.1% | 0.98 | 1.00 | 8.88 | 0.27 |
| class: two capitalized words, second text | 23 | 269.73 ± 1.0% | 274.34 ± 1.1% | 320.95 ± 2.2% | 95.42 ± 0.7% | 460.92 ± 18.8% | 944.99 ± 0.5% | 6125.02 ± 1.0% | 269.22 ± 0.9% | 0.98 | 1.00 | 2.83 | 0.59 |
| other: a word between two words | 13 | 301.99 ± 0.3% | 304.28 ± 0.4% | 364.04 ± 0.5% | 121.83 ± 3.4% | 449.39 ± 0.9% | 1013.22 ± 0.6% | 13011.65 ± 6.4% | 301.82 ± 5.5% | 0.99 | 1.00 | 2.48 | 0.67 |
| other: a number before a unit, second text | 15 | 266.68 ± 0.3% | 274.64 ± 0.5% | 323.22 ± 1.1% | 34.62 ± 1.0% | 547.65 ± 2.3% | 1117.71 ± 2.6% | 13443.46 ± 0.3% | 266.29 ± 4.7% | 0.97 | 1.00 | 7.70 | 0.49 |
| other: a heading's start tag | 13 | 245.51 ± 2.1% | 242.55 ± 2.2% | 288.96 ± 2.7% | 35.29 ± 3.3% | 536.43 ± 5.3% | 1067.21 ± 4.1% | 15659.94 ± 2.5% | 245.74 ± 2.3% | 1.01 | 1.00 | 6.96 | 0.46 |
| other: a whole word | 11 | 306.71 ± 0.2% | 311.41 ± 0.6% | 373.80 ± 0.8% | 115.71 ± 1.2% | 516.18 ± 0.7% | 1042.16 ± 0.7% | 19642.46 ± 3.8% | 307.91 ± 0.1% | 0.98 | 1.00 | 2.65 | 0.59 |
| other: a line's first word, second text | 17 | 298.27 ± 0.9% | 307.68 ± 0.3% | 364.99 ± 3.0% | 116.67 ± 0.9% | 617.50 ± 1.9% | refused | refused | 298.75 ± 0.8% | 0.97 | 1.00 | 2.56 | 0.48 |
| other: fourteen octets before an x | 16 | 83.63 ± 0.3% | 103.94 ± 0.2% | 116.09 ± 0.1% | 14.30 ± 1.7% | 397.45 ± 7.2% | 442.30 ± 1.1% | 11838.37 ± 0.3% | 83.42 ± 3.6% | 0.80 | 1.00 | 5.85 | 0.21 |
| other: a Greek word | 8 | 326.24 ± 0.8% | 337.02 ± 0.3% | 411.27 ± 0.2% | 46.78 ± 0.5% | 1199.90 ± 1.3% | 2241.17 ± 0.6% | refused | 326.73 ± 0.6% | 0.97 | 1.00 | 6.97 | 0.27 |

