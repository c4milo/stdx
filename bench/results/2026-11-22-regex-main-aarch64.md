# bench-regex

| Field | Value |
|---|---|
| Commit | 1667e8b |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45054918278 |
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
| literal: a word | 217 | 15568.54 ± 2.7% | 1040.38 ± 0.8% | 27.99 ± 0.2% | 18263.28 ± 2.8% | 9209.60 ± 8.8% | 17.61 ± 0.4% | 84.27 ± 0.7% | 15604.95 ± 2.6% | 14.96 | 1.00 | 0.85 | 1.69 |
| literal: a word that is not there | 0 | 18396.00 ± 2.6% | 1047.74 ± 0.7% | 27.86 ± 0.2% | 19447.67 ± 4.1% | 28330.03 ± 4.3% | 17.42 ± 0.1% | 79.63 ± 0.5% | 18691.46 ± 2.2% | 17.56 | 0.98 | 0.95 | 0.65 |
| literal: one of four words | 661 | 5767.29 ± 0.3% | 1017.74 ± 0.2% | 14.78 ± 0.3% | 3971.25 ± 0.6% | 21.91 ± 0.3% | 5.29 ± 0.2% | 6.88 ± 1.1% | 5748.39 ± 0.2% | 5.67 | 1.00 | 1.45 | 263.20 |
| literal: a word in any case | 217 | 11574.61 ± 0.5% | 1037.24 ± 0.1% | 21.66 ± 2.1% | 3985.35 ± 0.1% | 38.80 ± 0.2% | refused | differs | 11561.48 ± 0.1% | 11.16 | 1.00 | 2.90 | 298.30 |
| literal: an href attribute | 33 | 16143.90 ± 0.6% | 1045.44 ± 0.3% | 27.13 ± 0.2% | 16942.75 ± 1.2% | 2262.47 ± 0.3% | 13.38 ± 0.2% | 73.35 ± 2.5% | 16251.22 ± 1.3% | 15.44 | 0.99 | 0.95 | 7.14 |
| literal: a word, second text | 123 | 15877.94 ± 1.5% | 1043.39 ± 0.7% | 27.54 ± 0.3% | 18662.68 ± 2.4% | 7743.78 ± 12.9% | 19.70 ± 0.4% | 70.27 ± 0.3% | 15913.09 ± 0.8% | 15.22 | 1.00 | 0.85 | 2.05 |
| class: two capitalized words | 1331 | 1109.81 ± 0.3% | 957.12 ± 0.2% | 25.86 ± 0.2% | 587.16 ± 0.5% | 40.84 ± 8.7% | 14.97 ± 0.2% | 67.23 ± 1.2% | 1109.36 ± 0.3% | 1.16 | 1.00 | 1.89 | 27.18 |
| class: a word that ends in ing | 3399 | 884.11 ± 0.1% | 885.16 ± 0.1% | 18.24 ± 0.2% | 550.19 ± 0.1% | 29.58 ± 3.0% | 8.23 ± 0.2% | 18.24 ± 0.3% | 883.93 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.89 |
| class: a word in capitals | 2332 | 1471.72 ± 0.5% | 954.13 ± 0.1% | 27.25 ± 0.2% | 575.02 ± 0.1% | 43.75 ± 6.8% | 17.24 ± 0.2% | 82.45 ± 0.3% | 1476.49 ± 0.1% | 1.54 | 1.00 | 2.56 | 33.64 |
| class: a number | 8288 | 2120.45 ± 0.4% | 807.51 ± 0.1% | 27.34 ± 0.1% | 1800.27 ± 0.4% | 42.32 ± 16.7% | 0.55 ± 0.4% | 57.24 ± 0.6% | 2115.39 ± 0.6% | 2.63 | 1.00 | 1.18 | 50.11 |
| class: two capitalized words, second text | 5359 | 694.68 ± 0.2% | 696.85 ± 0.1% | 23.28 ± 0.2% | 489.26 ± 0.1% | 34.09 ± 9.7% | 16.68 ± 0.3% | 62.54 ± 0.5% | 694.72 ± 0.1% | 1.00 | 1.00 | 1.42 | 20.38 |
| other: a word between two words | 6104 | 724.71 ± 0.1% | 747.99 ± 0.1% | 23.47 ± 0.2% | 757.79 ± 0.3% | 109.75 ± 11.4% | 11.34 ± 0.2% | 68.15 ± 0.3% | 724.37 ± 0.1% | 0.97 | 1.00 | 0.96 | 6.60 |
| other: a number before a unit, second text | 1481 | 5464.75 ± 0.4% | 979.50 ± 0.1% | 25.71 ± 0.2% | 5953.13 ± 0.6% | 40.95 ± 11.8% | 17.80 ± 0.2% | 65.63 ± 0.3% | 5457.94 ± 0.7% | 5.58 | 1.00 | 0.92 | 133.46 |
| other: a heading's start tag | 110 | 12302.31 ± 1.7% | 1033.80 ± 0.2% | 26.84 ± 0.2% | 1721.60 ± 0.3% | 1588.95 ± 6.5% | 16.19 ± 0.4% | 86.11 ± 0.7% | 12327.78 ± 1.2% | 11.90 | 1.00 | 7.15 | 7.74 |
| other: a whole word | 217 | 13625.09 ± 2.2% | 1039.62 ± 0.1% | 29.26 ± 0.1% | 14799.20 ± 2.3% | 49.40 ± 0.2% | 13.87 ± 0.2% | 54.67 ± 0.4% | 13666.63 ± 2.5% | 13.11 | 1.00 | 0.92 | 275.79 |
| other: a line's first word, second text | 3716 | 1967.10 ± 0.4% | 861.91 ± 0.1% | 30.88 ± 0.2% | 1757.72 ± 0.2% | 61.77 ± 6.7% | refused | refused | 1956.58 ± 0.4% | 2.28 | 1.01 | 1.12 | 31.84 |
| other: fourteen octets before an x | 87 | 18955.78 ± 1.9% | 1.53 ± 0.1% | 1.53 ± 0.1% | 3922.20 ± 0.3% | 10.67 ± 0.2% | differs | 17.75 ± 0.2% | 19084.74 ± 2.0% | 12400.54 | 0.99 | 4.83 | 1777.00 |
| other: a Greek word | 21815 | 478.20 ± 0.7% | 323.82 ± 0.3% | 31.16 ± 0.2% | 294.35 ± 0.2% | 44.06 ± 10.0% | differs | refused | 477.75 ± 0.8% | 1.48 | 1.00 | 1.62 | 10.85 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 28.00 ± 0.3% | 28.01 ± 0.1% | 0.50 ± 0.2% | 21.54 ± 0.3% | 2.75 ± 0.6% | differs | 4.00 ± 0.2% | 28.00 ± 0.1% | 1.00 | 1.00 | 1.30 | 10.19 |
| a UUID | 32895 | 23.08 ± 0.3% | 23.07 ± 0.3% | 0.66 ± 0.1% | 16.06 ± 0.2% | 3.09 ± 0.3% | 0.72 ± 0.6% | 3.63 ± 0.7% | 23.09 ± 0.3% | 1.00 | 1.00 | 1.44 | 7.47 |
| an IPv4 address | 33176 | 41.50 ± 0.3% | 41.45 ± 0.3% | 2.17 ± 0.2% | 32.67 ± 0.2% | 6.68 ± 0.1% | differs | 4.04 ± 0.1% | 41.52 ± 0.4% | 1.00 | 1.00 | 1.27 | 6.21 |
| a date and time | 32954 | 34.87 ± 0.2% | 34.83 ± 0.4% | 1.50 ± 0.2% | 23.31 ± 0.1% | 7.05 ± 0.1% | 1.20 ± 0.6% | 7.05 ± 0.5% | 34.84 ± 0.2% | 1.00 | 1.00 | 1.50 | 4.95 |
| a field path | 32606 | 32.30 ± 0.2% | 32.33 ± 0.2% | 0.83 ± 0.2% | 25.25 ± 0.4% | 3.50 ± 0.7% | differs | 2.92 ± 0.1% | 32.29 ± 0.1% | 1.00 | 1.00 | 1.28 | 9.23 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.17 ± 0.1% | 10.17 ± 0.2% | 10.17 ± 0.1% | 10.99 ± 0.1% | 4.96 ± 1.1% | 0.91 ± 0.5% | none | 10.16 ± 0.1% | 1.00 | 1.00 | 0.93 | 2.05 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 194.86 ± 0.3% | 195.24 ± 0.2% | 218.71 ± 0.3% | 86.21 ± 0.3% | 221.06 ± 2.0% | 490.15 ± 0.6% | 3846.14 ± 0.9% | 194.76 ± 0.3% | 1.00 | 1.00 | 2.26 | 0.88 |
| a UUID | 62 | 151.55 ± 0.1% | 152.22 ± 0.2% | 168.64 ± 0.1% | 45.45 ± 0.5% | 98.83 ± 0.6% | 184.23 ± 1.0% | 4497.68 ± 0.4% | 151.60 ± 0.2% | 1.00 | 1.00 | 3.33 | 1.53 |
| an IPv4 address | 29 | 285.46 ± 0.2% | 286.81 ± 0.2% | 340.10 ± 0.2% | 76.25 ± 1.0% | 131.42 ± 1.5% | 294.40 ± 1.0% | 7670.28 ± 0.3% | 285.40 ± 0.0% | 1.00 | 1.00 | 3.74 | 2.17 |
| a date and time | 56 | 229.12 ± 0.2% | 230.02 ± 0.1% | 263.50 ± 0.2% | 71.86 ± 0.1% | 136.87 ± 2.2% | 322.13 ± 0.7% | 4926.66 ± 0.8% | 228.87 ± 0.2% | 1.00 | 1.00 | 3.19 | 1.67 |
| a field path | 39 | 198.60 ± 0.2% | 199.70 ± 0.1% | 224.36 ± 0.1% | 79.39 ± 0.3% | 208.88 ± 1.4% | 484.15 ± 0.3% | 4950.42 ± 0.3% | 198.66 ± 0.2% | 0.99 | 1.00 | 2.50 | 0.95 |
| literal: a word | 7 | 369.22 ± 0.3% | 375.59 ± 0.5% | 470.25 ± 0.1% | 506.17 ± 1.0% | 610.30 ± 8.2% | 923.17 ± 0.6% | 30924.42 ± 0.6% | 369.14 ± 0.1% | 0.98 | 1.00 | 0.73 | 0.60 |
| literal: a word that is not there | 8 | 361.36 ± 0.3% | 368.33 ± 0.2% | 459.35 ± 0.1% | 464.02 ± 0.2% | 606.82 ± 1.2% | 874.50 ± 0.8% | 29289.60 ± 0.2% | 361.33 ± 0.2% | 0.98 | 1.00 | 0.78 | 0.60 |
| literal: one of four words | 26 | 258.02 ± 0.3% | 273.21 ± 0.6% | 322.45 ± 0.4% | 49.13 ± 0.4% | 241.17 ± 2.2% | 354.12 ± 0.2% | 15740.64 ± 0.2% | 258.05 ± 0.3% | 0.94 | 1.00 | 5.25 | 1.07 |
| literal: a word in any case | 11 | 231.26 ± 0.2% | 233.63 ± 0.2% | 268.96 ± 0.1% | 15.73 ± 0.9% | 648.20 ± 1.4% | refused | 23614.04 ± 0.4% | 231.27 ± 0.2% | 0.99 | 1.00 | 14.70 | 0.36 |
| literal: an href attribute | 12 | 272.48 ± 0.9% | 275.14 ± 0.8% | 325.79 ± 0.7% | 44.81 ± 0.4% | 502.76 ± 0.7% | 782.62 ± 1.7% | 22213.39 ± 0.3% | 271.99 ± 0.9% | 0.99 | 1.00 | 6.08 | 0.54 |
| literal: a word, second text | 10 | 347.53 ± 0.4% | 354.31 ± 0.2% | 440.90 ± 0.1% | 414.25 ± 0.5% | 538.95 ± 1.9% | 801.63 ± 0.4% | 27287.72 ± 0.4% | 347.71 ± 0.2% | 0.98 | 1.00 | 0.84 | 0.64 |
| class: two capitalized words | 23 | 286.91 ± 0.5% | 292.54 ± 0.2% | 347.00 ± 0.4% | 100.74 ± 0.1% | 504.64 ± 0.8% | 749.45 ± 1.0% | 6396.00 ± 0.6% | 286.94 ± 0.4% | 0.98 | 1.00 | 2.85 | 0.57 |
| class: a word that ends in ing | 9 | 353.88 ± 0.3% | 365.90 ± 0.4% | 454.32 ± 0.1% | 131.89 ± 1.4% | 756.80 ± 1.6% | 1100.28 ± 0.8% | 16072.64 ± 0.5% | 353.82 ± 0.2% | 0.97 | 1.00 | 2.68 | 0.47 |
| class: a word in capitals | 16 | 320.88 ± 0.2% | 328.02 ± 0.2% | 396.55 ± 0.1% | 135.92 ± 1.0% | 750.17 ± 1.2% | 1050.35 ± 0.9% | 8414.21 ± 0.1% | 320.70 ± 0.1% | 0.98 | 1.00 | 2.36 | 0.43 |
| class: a number | 6 | 371.11 ± 0.3% | 380.79 ± 0.2% | 476.21 ± 0.0% | 41.73 ± 1.2% | 1402.33 ± 0.9% | 1897.13 ± 0.5% | 22531.41 ± 0.1% | 371.28 ± 0.1% | 0.97 | 1.00 | 8.89 | 0.26 |
| class: two capitalized words, second text | 23 | 286.90 ± 0.3% | 292.48 ± 0.1% | 347.11 ± 0.3% | 102.74 ± 0.1% | 504.77 ± 1.2% | 770.77 ± 1.0% | 6402.67 ± 1.0% | 287.10 ± 0.4% | 0.98 | 1.00 | 2.79 | 0.57 |
| other: a word between two words | 13 | 336.84 ± 0.2% | 340.34 ± 0.2% | 416.33 ± 0.2% | 134.23 ± 0.4% | 503.50 ± 1.0% | 815.82 ± 0.3% | 14942.88 ± 0.4% | 336.56 ± 0.3% | 0.99 | 1.00 | 2.51 | 0.67 |
| other: a number before a unit, second text | 15 | 300.16 ± 0.3% | 311.27 ± 0.2% | 374.55 ± 0.1% | 39.53 ± 0.5% | 631.55 ± 1.3% | 890.21 ± 0.5% | 15379.24 ± 0.3% | 299.90 ± 0.2% | 0.96 | 1.00 | 7.59 | 0.48 |
| other: a heading's start tag | 13 | 270.86 ± 0.3% | 272.79 ± 0.2% | 322.41 ± 0.2% | 43.69 ± 1.9% | 642.12 ± 1.5% | 878.04 ± 0.8% | 18510.00 ± 0.2% | 270.80 ± 0.3% | 0.99 | 1.00 | 6.20 | 0.42 |
| other: a whole word | 11 | 353.81 ± 0.3% | 357.73 ± 0.2% | 444.78 ± 0.2% | 120.26 ± 0.7% | 566.11 ± 9.0% | 826.47 ± 2.4% | 27117.25 ± 0.4% | 353.82 ± 0.2% | 0.99 | 1.00 | 2.94 | 0.62 |
| other: a line's first word, second text | 17 | 331.00 ± 0.4% | 336.67 ± 0.2% | 409.52 ± 0.2% | 126.71 ± 0.2% | 716.51 ± 0.9% | refused | refused | 330.62 ± 1.3% | 0.98 | 1.00 | 2.61 | 0.46 |
| other: fourteen octets before an x | 16 | 101.90 ± 0.4% | 131.55 ± 0.6% | 151.29 ± 0.9% | 15.03 ± 0.2% | 455.34 ± 0.7% | 414.55 ± 1.4% | 13140.26 ± 0.5% | 101.78 ± 0.4% | 0.77 | 1.00 | 6.78 | 0.22 |
| other: a Greek word | 8 | 360.24 ± 0.2% | 373.34 ± 0.4% | 463.47 ± 0.2% | 59.04 ± 0.4% | 1390.17 ± 0.9% | 1755.03 ± 0.4% | refused | 360.30 ± 0.2% | 0.96 | 1.00 | 6.10 | 0.26 |

