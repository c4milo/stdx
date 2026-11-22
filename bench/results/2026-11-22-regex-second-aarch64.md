# bench-regex

| Field | Value |
|---|---|
| Commit | 43d309e |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44986665628 |
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
| literal: a word | 217 | 15642.12 ± 1.0% | 1040.70 ± 0.7% | 28.68 ± 0.5% | 18440.78 ± 1.1% | 9381.44 ± 6.0% | 17.32 ± 0.3% | 86.61 ± 0.2% | 15647.45 ± 1.1% | 15.03 | 1.00 | 0.85 | 1.67 |
| literal: a word that is not there | 0 | 18673.12 ± 0.8% | 1046.50 ± 0.5% | 28.53 ± 0.3% | 19749.91 ± 3.1% | 29153.85 ± 1.3% | 17.12 ± 0.5% | 82.38 ± 0.2% | 18801.52 ± 0.3% | 17.84 | 0.99 | 0.95 | 0.64 |
| literal: one of four words | 661 | 4146.25 ± 0.6% | 1021.79 ± 0.2% | 14.94 ± 0.1% | 3983.10 ± 0.7% | 21.92 ± 0.1% | 5.35 ± 0.2% | 6.93 ± 0.5% | 4146.56 ± 0.3% | 4.06 | 1.00 | 1.04 | 189.13 |
| literal: a word in any case | 217 | 11611.97 ± 0.6% | 1039.88 ± 0.3% | 21.87 ± 0.1% | 3985.70 ± 0.1% | 38.68 ± 0.6% | refused | differs | 11639.67 ± 0.4% | 11.17 | 1.00 | 2.91 | 300.18 |
| literal: an href attribute | 33 | 16272.84 ± 0.6% | 1050.08 ± 0.6% | 27.64 ± 0.2% | 17057.31 ± 0.9% | 2258.01 ± 0.7% | 13.21 ± 0.2% | 75.64 ± 0.4% | 16318.52 ± 1.0% | 15.50 | 1.00 | 0.95 | 7.21 |
| literal: a word, second text | 123 | 15763.59 ± 1.1% | 1039.84 ± 0.1% | 28.31 ± 0.1% | 18614.96 ± 2.0% | 7699.49 ± 5.7% | 20.02 ± 0.4% | 70.41 ± 0.6% | 15823.48 ± 1.3% | 15.16 | 1.00 | 0.85 | 2.05 |
| class: two capitalized words | 1331 | 1106.23 ± 0.3% | 960.02 ± 0.1% | 26.46 ± 0.2% | 587.48 ± 0.0% | 40.91 ± 0.2% | 14.74 ± 0.2% | 68.85 ± 0.2% | 1105.97 ± 0.3% | 1.15 | 1.00 | 1.88 | 27.04 |
| class: a word that ends in ing | 3399 | 887.20 ± 0.1% | 888.65 ± 0.1% | 18.35 ± 0.1% | 550.50 ± 0.1% | 29.42 ± 2.6% | 8.15 ± 0.1% | 18.43 ± 0.3% | 886.92 ± 0.1% | 1.00 | 1.00 | 1.61 | 30.15 |
| class: a word in capitals | 2332 | 1488.34 ± 0.6% | 960.74 ± 0.1% | 27.76 ± 0.1% | 575.14 ± 0.0% | 43.63 ± 16.6% | 17.15 ± 0.2% | 83.14 ± 0.5% | 1486.72 ± 0.3% | 1.55 | 1.00 | 2.59 | 34.11 |
| class: a number | 8288 | 2148.90 ± 0.4% | 809.42 ± 0.1% | 28.00 ± 0.2% | 1814.18 ± 0.1% | 43.04 ± 7.4% | 0.55 ± 0.1% | 56.54 ± 0.3% | 2149.12 ± 0.2% | 2.65 | 1.00 | 1.18 | 49.93 |
| class: two capitalized words, second text | 5359 | 698.82 ± 0.4% | 700.17 ± 0.2% | 23.76 ± 0.1% | 489.48 ± 0.1% | 35.57 ± 8.3% | 17.05 ± 0.2% | 63.97 ± 0.3% | 698.21 ± 0.1% | 1.00 | 1.00 | 1.43 | 19.65 |
| other: a word between two words | 6104 | 725.81 ± 0.1% | 754.23 ± 0.1% | 23.81 ± 0.2% | 752.08 ± 0.5% | 109.58 ± 7.6% | 11.20 ± 0.2% | 69.86 ± 0.3% | 725.42 ± 0.3% | 0.96 | 1.00 | 0.97 | 6.62 |
| other: a number before a unit, second text | 1481 | 5456.03 ± 0.8% | 980.76 ± 0.1% | 26.29 ± 0.1% | 5884.94 ± 0.6% | 41.01 ± 0.2% | 18.24 ± 0.1% | 66.98 ± 0.1% | 5433.53 ± 0.6% | 5.56 | 1.00 | 0.93 | 133.03 |
| other: a heading's start tag | 110 | 12457.85 ± 0.8% | 992.29 ± 2.4% | 27.40 ± 0.2% | 1720.50 ± 0.7% | 1586.81 ± 1.3% | 16.04 ± 0.6% | 88.86 ± 0.4% | 12512.77 ± 0.9% | 12.55 | 1.00 | 7.24 | 7.85 |
| other: a whole word | 217 | 13739.46 ± 2.1% | 1040.06 ± 0.4% | 30.19 ± 0.2% | 14778.51 ± 0.4% | 49.32 ± 0.2% | 13.13 ± 0.1% | 55.90 ± 0.3% | 13729.64 ± 3.0% | 13.21 | 1.00 | 0.93 | 278.60 |
| other: a line's first word, second text | 3716 | 1969.89 ± 0.7% | 866.74 ± 0.1% | 31.85 ± 0.1% | 1727.94 ± 0.2% | 61.69 ± 3.1% | refused | refused | 1960.02 ± 0.5% | 2.27 | 1.01 | 1.14 | 31.93 |
| other: fourteen octets before an x | 87 | 19366.00 ± 0.9% | 1.53 ± 0.1% | 1.53 ± 0.0% | 4025.85 ± 2.2% | 10.71 ± 0.2% | differs | 17.78 ± 0.2% | 19315.22 ± 0.8% | 12644.52 | 1.00 | 4.81 | 1807.41 |
| other: a Greek word | 21815 | 472.58 ± 0.3% | 320.35 ± 0.4% | 31.36 ± 0.2% | 294.80 ± 0.2% | 47.70 ± 13.5% | differs | refused | 471.32 ± 0.8% | 1.48 | 1.00 | 1.60 | 9.91 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.78 ± 0.4% | 28.79 ± 0.4% | 0.50 ± 0.2% | 21.57 ± 0.4% | 2.76 ± 0.4% | differs | 4.03 ± 0.2% | 28.78 ± 0.1% | 1.00 | 1.00 | 1.33 | 10.41 |
| a UUID | 32895 | 23.47 ± 0.3% | 23.47 ± 0.4% | 0.67 ± 0.1% | 16.03 ± 0.1% | 3.08 ± 0.5% | 0.72 ± 0.1% | 3.60 ± 0.6% | 23.46 ± 0.3% | 1.00 | 1.00 | 1.46 | 7.61 |
| an IPv4 address | 33176 | 42.60 ± 0.3% | 42.60 ± 0.2% | 2.18 ± 0.2% | 32.77 ± 0.3% | 6.70 ± 0.2% | differs | 4.14 ± 0.3% | 42.58 ± 0.2% | 1.00 | 1.00 | 1.30 | 6.36 |
| a date and time | 32954 | 35.66 ± 0.5% | 35.68 ± 0.4% | 1.52 ± 0.2% | 23.30 ± 0.2% | 7.07 ± 0.1% | 1.23 ± 0.1% | 7.03 ± 0.7% | 35.73 ± 0.4% | 1.00 | 1.00 | 1.53 | 5.04 |
| a field path | 32606 | 33.25 ± 0.1% | 33.26 ± 0.1% | 0.83 ± 0.2% | 25.05 ± 0.1% | 3.52 ± 1.1% | differs | 2.96 ± 0.2% | 33.23 ± 0.3% | 1.00 | 1.00 | 1.33 | 9.46 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.29 ± 0.3% | 10.30 ± 0.2% | 10.29 ± 0.3% | 11.70 ± 0.1% | 4.93 ± 1.5% | 0.92 ± 0.3% | none | 10.29 ± 0.5% | 1.00 | 1.00 | 0.88 | 2.09 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 293.66 ± 0.5% | 296.72 ± 0.3% | 352.29 ± 0.3% | 86.40 ± 0.2% | 220.50 ± 0.6% | 484.07 ± 0.8% | 3881.22 ± 2.0% | 294.15 ± 0.3% | 0.99 | 1.00 | 3.40 | 1.33 |
| a UUID | 62 | 216.90 ± 0.2% | 218.18 ± 0.2% | 252.32 ± 0.4% | 45.58 ± 0.1% | 98.96 ± 1.4% | 183.86 ± 1.3% | 4500.97 ± 0.1% | 216.59 ± 0.4% | 0.99 | 1.00 | 4.76 | 2.19 |
| an IPv4 address | 29 | 451.23 ± 0.2% | 457.49 ± 0.1% | 603.21 ± 0.2% | 76.20 ± 0.9% | 130.55 ± 1.3% | 292.79 ± 1.2% | 7687.91 ± 0.4% | 451.40 ± 0.4% | 0.99 | 1.00 | 5.92 | 3.46 |
| a date and time | 56 | 295.24 ± 0.3% | 297.39 ± 0.3% | 355.65 ± 0.1% | 71.92 ± 0.2% | 136.04 ± 3.5% | 319.53 ± 0.8% | 4998.11 ± 0.5% | 295.20 ± 0.5% | 0.99 | 1.00 | 4.11 | 2.17 |
| a field path | 39 | 330.35 ± 0.2% | 332.43 ± 0.5% | 405.89 ± 0.4% | 79.36 ± 0.4% | 204.93 ± 3.2% | 483.76 ± 0.9% | 4959.48 ± 0.4% | 330.47 ± 0.4% | 0.99 | 1.00 | 4.16 | 1.61 |
| literal: a word | 7 | 783.77 ± 0.4% | 807.47 ± 0.5% | 1410.24 ± 0.1% | 507.10 ± 1.7% | 626.40 ± 2.2% | 923.03 ± 0.3% | 30501.06 ± 0.5% | 784.17 ± 0.1% | 0.97 | 1.00 | 1.55 | 1.25 |
| literal: a word that is not there | 8 | 750.23 ± 0.2% | 777.99 ± 0.7% | 1321.90 ± 0.1% | 464.00 ± 0.4% | 598.10 ± 2.2% | 874.08 ± 0.3% | 29232.47 ± 0.2% | 749.27 ± 0.1% | 0.96 | 1.00 | 1.62 | 1.25 |
| literal: one of four words | 26 | 416.47 ± 0.1% | 453.64 ± 0.4% | 604.46 ± 0.2% | 48.11 ± 0.6% | 237.42 ± 3.2% | 355.31 ± 0.4% | 15739.65 ± 0.3% | 417.16 ± 0.6% | 0.92 | 1.00 | 8.66 | 1.75 |
| literal: a word in any case | 11 | 681.54 ± 0.3% | 713.43 ± 0.5% | 1148.39 ± 0.7% | 15.72 ± 0.9% | 646.61 ± 2.1% | refused | 23564.79 ± 0.8% | 682.02 ± 0.1% | 0.96 | 1.00 | 43.35 | 1.05 |
| literal: an href attribute | 12 | 411.49 ± 0.3% | 418.14 ± 0.6% | 542.47 ± 0.7% | 44.89 ± 0.8% | 497.25 ± 1.8% | 783.61 ± 1.6% | 22298.58 ± 0.1% | 411.79 ± 0.7% | 0.98 | 1.00 | 9.17 | 0.83 |
| literal: a word, second text | 10 | 701.18 ± 0.2% | 722.10 ± 0.9% | 1182.17 ± 0.1% | 413.08 ± 0.3% | 536.53 ± 3.0% | 800.50 ± 0.4% | 27282.19 ± 0.3% | 700.79 ± 0.2% | 0.97 | 1.00 | 1.70 | 1.31 |
| class: two capitalized words | 23 | 449.84 ± 0.4% | 463.37 ± 0.2% | 615.65 ± 0.5% | 100.85 ± 0.1% | 502.28 ± 9.7% | 743.53 ± 0.6% | 6524.04 ± 0.6% | 449.23 ± 0.2% | 0.97 | 1.00 | 4.46 | 0.90 |
| class: a word that ends in ing | 9 | 689.70 ± 0.3% | 731.74 ± 1.0% | 1176.38 ± 0.3% | 132.32 ± 1.5% | 750.55 ± 3.9% | 1097.29 ± 1.2% | 15993.57 ± 0.3% | 687.91 ± 0.6% | 0.94 | 1.00 | 5.21 | 0.92 |
| class: a word in capitals | 16 | 540.48 ± 0.3% | 558.01 ± 0.3% | 791.69 ± 0.1% | 135.85 ± 1.1% | 744.54 ± 1.2% | 1038.22 ± 0.9% | 8573.97 ± 1.3% | 540.34 ± 0.1% | 0.97 | 1.00 | 3.98 | 0.73 |
| class: a number | 6 | 767.06 ± 0.4% | 803.02 ± 0.3% | 1369.60 ± 0.1% | 41.78 ± 1.0% | 1396.04 ± 0.9% | 1892.52 ± 0.8% | 22805.59 ± 0.1% | 767.91 ± 0.5% | 0.96 | 1.00 | 18.36 | 0.55 |
| class: two capitalized words, second text | 23 | 449.35 ± 0.3% | 462.47 ± 0.3% | 615.64 ± 0.2% | 102.72 ± 0.2% | 499.42 ± 3.2% | 764.85 ± 0.4% | 6503.90 ± 0.7% | 449.70 ± 0.6% | 0.97 | 1.00 | 4.37 | 0.90 |
| other: a word between two words | 13 | 628.74 ± 0.2% | 642.62 ± 0.5% | 967.97 ± 0.2% | 134.62 ± 0.5% | 501.65 ± 5.2% | 812.87 ± 0.4% | 14976.88 ± 0.5% | 629.26 ± 0.7% | 0.98 | 1.00 | 4.67 | 1.25 |
| other: a number before a unit, second text | 15 | 542.21 ± 0.6% | 580.42 ± 0.1% | 831.37 ± 0.9% | 39.44 ± 0.4% | 626.79 ± 3.9% | 885.80 ± 0.6% | 15307.73 ± 0.1% | 542.80 ± 0.8% | 0.93 | 1.00 | 13.75 | 0.87 |
| other: a heading's start tag | 13 | 399.12 ± 0.2% | 404.43 ± 0.6% | 521.06 ± 0.6% | 43.84 ± 1.3% | 629.31 ± 1.5% | 875.64 ± 0.2% | 18429.21 ± 0.1% | 398.67 ± 0.2% | 0.99 | 1.00 | 9.10 | 0.63 |
| other: a whole word | 11 | 719.81 ± 0.4% | 739.39 ± 0.5% | 1211.14 ± 0.1% | 120.94 ± 0.8% | 556.35 ± 2.2% | 822.90 ± 1.5% | 27149.12 ± 0.6% | 719.46 ± 0.2% | 0.97 | 1.00 | 5.95 | 1.29 |
| other: a line's first word, second text | 17 | 602.83 ± 0.4% | 624.97 ± 0.3% | 919.48 ± 0.2% | 126.93 ± 0.2% | 708.14 ± 2.1% | refused | refused | 602.05 ± 0.5% | 0.96 | 1.00 | 4.75 | 0.85 |
| other: fourteen octets before an x | 16 | 115.22 ± 1.2% | 154.46 ± 0.5% | 181.92 ± 0.4% | 15.08 ± 0.4% | 449.48 ± 3.8% | 414.74 ± 1.2% | 12977.25 ± 0.3% | 115.15 ± 1.1% | 0.75 | 1.00 | 7.64 | 0.26 |
| other: a Greek word | 8 | 715.93 ± 0.2% | 771.81 ± 0.6% | 1264.29 ± 0.1% | 58.99 ± 1.1% | 1381.50 ± 1.6% | 1758.07 ± 0.4% | refused | 715.79 ± 0.4% | 0.93 | 1.00 | 12.14 | 0.52 |

