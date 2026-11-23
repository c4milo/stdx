# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102094978 |
| Date | 2026-11-23 |
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
| literal: a word | 217 | 15961.76 ± 1.7% | 1042.35 ± 0.1% | 27.69 ± 0.1% | 17979.01 ± 1.0% | 9175.94 ± 7.0% | 17.19 ± 0.3% | 86.36 ± 0.2% | 15959.69 ± 1.5% | 15.31 | 1.00 | 0.89 | 1.74 |
| literal: a word that is not there | 0 | 18730.29 ± 1.9% | 1048.94 ± 0.8% | 27.65 ± 0.1% | 19579.27 ± 3.0% | 28909.84 ± 1.4% | 17.04 ± 0.1% | 82.18 ± 0.1% | 18848.78 ± 1.9% | 17.86 | 0.99 | 0.96 | 0.65 |
| literal: one of four words | 661 | 6158.70 ± 0.7% | 1020.42 ± 0.3% | 14.31 ± 0.1% | 3949.29 ± 0.3% | 21.90 ± 0.1% | 5.32 ± 0.2% | 6.71 ± 0.2% | 6137.81 ± 0.3% | 6.04 | 1.00 | 1.56 | 281.21 |
| literal: a word in any case | 217 | 12504.27 ± 0.4% | 1042.56 ± 0.3% | 21.19 ± 2.2% | 3973.47 ± 0.3% | 38.08 ± 0.5% | refused | differs | 12510.79 ± 0.7% | 11.99 | 1.00 | 3.15 | 328.39 |
| literal: an href attribute | 33 | 13684.55 ± 1.4% | 1045.65 ± 0.6% | 26.70 ± 0.1% | 16877.39 ± 1.1% | 2264.53 ± 0.7% | 13.06 ± 0.4% | 75.30 ± 0.2% | 13700.16 ± 1.2% | 13.09 | 1.00 | 0.81 | 6.04 |
| literal: a word, second text | 123 | 16248.35 ± 0.9% | 1047.97 ± 0.3% | 27.37 ± 0.3% | 18205.76 ± 2.2% | 7633.77 ± 6.9% | 20.06 ± 0.7% | 70.36 ± 0.2% | 16353.32 ± 1.7% | 15.50 | 0.99 | 0.89 | 2.13 |
| class: two capitalized words | 1331 | 1105.39 ± 0.8% | 959.28 ± 0.2% | 25.47 ± 0.3% | 585.09 ± 0.1% | 40.65 ± 13.2% | 14.75 ± 0.3% | 68.88 ± 0.3% | 1103.26 ± 0.2% | 1.15 | 1.00 | 1.89 | 27.19 |
| class: a word that ends in ing | 3399 | 879.07 ± 0.1% | 863.13 ± 0.2% | 17.71 ± 0.3% | 547.06 ± 0.1% | 29.64 ± 7.9% | 8.19 ± 0.1% | 18.44 ± 0.4% | 879.25 ± 0.1% | 1.02 | 1.00 | 1.61 | 29.66 |
| class: a word in capitals | 2332 | 1466.01 ± 0.7% | 945.41 ± 0.1% | 27.14 ± 0.1% | 572.41 ± 0.1% | 43.47 ± 16.7% | 17.13 ± 0.3% | 83.21 ± 0.3% | 1468.11 ± 0.7% | 1.55 | 1.00 | 2.56 | 33.73 |
| class: a number | 8288 | 2061.67 ± 0.5% | 791.55 ± 0.1% | 27.19 ± 0.2% | 1723.01 ± 0.4% | 43.04 ± 4.8% | 0.52 ± 0.5% | 56.65 ± 0.4% | 2062.30 ± 0.2% | 2.60 | 1.00 | 1.20 | 47.90 |
| class: two capitalized words, second text | 5359 | 688.45 ± 0.3% | 687.08 ± 0.2% | 22.86 ± 0.1% | 484.76 ± 0.1% | 35.52 ± 8.5% | 17.10 ± 0.4% | 63.97 ± 0.3% | 688.03 ± 0.1% | 1.00 | 1.00 | 1.42 | 19.38 |
| other: a word between two words | 6104 | 777.66 ± 0.3% | 743.00 ± 0.1% | 23.08 ± 0.3% | 733.15 ± 0.3% | 111.60 ± 13.5% | 11.15 ± 0.2% | 69.63 ± 0.2% | 777.93 ± 0.1% | 1.05 | 1.00 | 1.06 | 6.97 |
| other: a number before a unit, second text | 1481 | 5465.81 ± 0.5% | 978.65 ± 0.1% | 25.41 ± 0.1% | 5635.95 ± 0.5% | 40.76 ± 0.2% | 18.14 ± 0.2% | 66.87 ± 0.2% | 5458.68 ± 0.4% | 5.59 | 1.00 | 0.97 | 134.09 |
| other: a heading's start tag | 110 | 12664.41 ± 0.6% | 1030.32 ± 0.3% | 26.82 ± 0.1% | 1707.05 ± 0.2% | 1583.63 ± 5.0% | 15.76 ± 0.8% | 88.79 ± 0.3% | 12674.96 ± 0.3% | 12.29 | 1.00 | 7.42 | 8.00 |
| other: a whole word | 217 | 13956.32 ± 1.0% | 1041.00 ± 0.2% | 28.56 ± 0.2% | 14515.15 ± 1.9% | 49.34 ± 0.5% | 13.03 ± 0.2% | 55.67 ± 0.3% | 13999.94 ± 0.4% | 13.41 | 1.00 | 0.96 | 282.87 |
| other: a line's first word, second text | 3716 | 1947.49 ± 0.5% | 854.81 ± 0.2% | 30.06 ± 0.5% | 1721.72 ± 0.3% | 62.71 ± 8.1% | refused | refused | 1943.01 ± 1.0% | 2.28 | 1.00 | 1.13 | 31.05 |
| other: fourteen octets before an x | 87 | 19438.86 ± 1.5% | 245.14 ± 0.6% | 5.30 ± 0.1% | 3974.61 ± 0.6% | 10.64 ± 0.1% | differs | 17.78 ± 0.2% | 19360.05 ± 1.3% | 79.30 | 1.00 | 4.89 | 1826.30 |
| other: a Greek word | 21815 | 472.44 ± 0.4% | 311.43 ± 0.3% | 30.27 ± 0.1% | 289.64 ± 0.5% | 47.29 ± 15.1% | differs | refused | 470.53 ± 0.6% | 1.52 | 1.00 | 1.63 | 9.99 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.01 ± 0.2% | 26.03 ± 0.2% | 0.82 ± 0.2% | 19.85 ± 0.9% | 2.76 ± 1.1% | differs | 4.00 ± 0.5% | 25.99 ± 0.1% | 1.00 | 1.00 | 1.31 | 9.43 |
| a UUID | 32895 | 21.19 ± 0.2% | 21.32 ± 0.1% | 0.64 ± 0.4% | 15.05 ± 0.6% | 3.12 ± 0.5% | 0.73 ± 0.3% | 3.60 ± 0.7% | 21.33 ± 0.2% | 0.99 | 0.99 | 1.41 | 6.80 |
| an IPv4 address | 33176 | 36.87 ± 0.2% | 36.88 ± 0.3% | 2.08 ± 0.1% | 29.28 ± 0.8% | 6.67 ± 0.2% | differs | 4.12 ± 0.2% | 36.91 ± 0.1% | 1.00 | 1.00 | 1.26 | 5.52 |
| a date and time | 32954 | 31.06 ± 0.5% | 30.30 ± 0.5% | 1.45 ± 0.1% | 21.46 ± 0.2% | 7.04 ± 0.2% | 1.26 ± 0.0% | 7.17 ± 0.4% | 31.14 ± 0.4% | 1.03 | 1.00 | 1.45 | 4.41 |
| a field path | 32606 | 29.57 ± 0.2% | 29.51 ± 0.2% | 0.97 ± 0.1% | 23.18 ± 0.7% | 3.51 ± 0.5% | differs | 2.97 ± 0.1% | 29.61 ± 0.3% | 1.00 | 1.00 | 1.28 | 8.43 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.04 ± 0.5% | 9.06 ± 0.3% | 9.02 ± 0.2% | 11.56 ± 0.1% | 5.00 ± 1.4% | 0.93 ± 0.5% | none | 9.04 ± 0.3% | 1.00 | 1.00 | 0.78 | 1.81 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.98 ± 0.2% | 236.67 ± 0.1% | 287.95 ± 0.2% | 86.67 ± 0.5% | 219.86 ± 0.6% | 478.01 ± 1.4% | 3873.40 ± 0.7% | 234.79 ± 0.3% | 0.99 | 1.00 | 2.71 | 1.07 |
| a UUID | 62 | 157.55 ± 0.3% | 157.84 ± 0.3% | 179.40 ± 0.2% | 46.58 ± 0.7% | 98.14 ± 0.8% | 187.15 ± 3.2% | 4243.97 ± 0.6% | 157.75 ± 0.3% | 1.00 | 1.00 | 3.38 | 1.61 |
| an IPv4 address | 29 | 421.54 ± 0.6% | 424.65 ± 0.6% | 617.58 ± 0.8% | 77.28 ± 0.3% | 131.44 ± 1.5% | 296.89 ± 2.0% | 7562.63 ± 0.3% | 421.11 ± 0.6% | 0.99 | 1.00 | 5.45 | 3.21 |
| a date and time | 56 | 305.81 ± 0.4% | 307.66 ± 0.7% | 397.50 ± 0.4% | 73.33 ± 0.5% | 136.57 ± 8.9% | 323.23 ± 1.3% | 4855.94 ± 0.3% | 305.74 ± 0.2% | 0.99 | 1.00 | 4.17 | 2.24 |
| a field path | 39 | 226.96 ± 0.3% | 227.93 ± 0.4% | 274.70 ± 0.3% | 81.00 ± 1.1% | 204.38 ± 1.3% | 498.05 ± 3.3% | 4912.81 ± 1.8% | 226.78 ± 0.1% | 1.00 | 1.00 | 2.80 | 1.11 |
| literal: a word | 7 | 623.07 ± 0.4% | 666.84 ± 0.3% | 1275.46 ± 0.7% | 522.06 ± 0.1% | 633.68 ± 2.2% | 940.63 ± 0.4% | 29582.36 ± 0.3% | 623.05 ± 0.7% | 0.93 | 1.00 | 1.19 | 0.98 |
| literal: a word that is not there | 8 | 595.43 ± 0.5% | 643.38 ± 0.8% | 1190.44 ± 0.7% | 478.50 ± 0.1% | 611.07 ± 6.3% | 892.45 ± 0.5% | 28590.81 ± 0.1% | 595.58 ± 0.4% | 0.93 | 1.00 | 1.24 | 0.97 |
| literal: one of four words | 26 | 241.46 ± 0.4% | 400.08 ± 0.6% | 565.79 ± 0.7% | 50.14 ± 1.3% | 241.75 ± 3.5% | 371.11 ± 1.2% | 15463.31 ± 0.1% | 241.57 ± 0.5% | 0.60 | 1.00 | 4.82 | 1.00 |
| literal: a word in any case | 11 | 484.15 ± 0.1% | 516.79 ± 0.5% | 847.43 ± 0.2% | 15.85 ± 1.7% | 645.28 ± 1.5% | refused | 23471.81 ± 0.3% | 484.22 ± 0.2% | 0.94 | 1.00 | 30.55 | 0.75 |
| literal: an href attribute | 12 | 350.29 ± 0.4% | 361.90 ± 0.5% | 497.87 ± 0.6% | 45.83 ± 0.4% | 499.81 ± 11.5% | 764.35 ± 1.1% | 21492.36 ± 0.4% | 350.59 ± 0.5% | 0.97 | 1.00 | 7.64 | 0.70 |
| literal: a word, second text | 10 | 561.45 ± 1.2% | 615.67 ± 0.9% | 1085.10 ± 1.2% | 398.11 ± 0.1% | 538.43 ± 0.6% | 794.64 ± 0.7% | 26592.55 ± 0.2% | 560.98 ± 0.8% | 0.91 | 1.00 | 1.41 | 1.04 |
| class: two capitalized words | 23 | 435.33 ± 0.5% | 467.14 ± 0.8% | 707.75 ± 0.1% | 100.25 ± 0.1% | 503.58 ± 2.0% | 735.44 ± 0.3% | 6569.87 ± 0.3% | 435.56 ± 0.5% | 0.93 | 1.00 | 4.34 | 0.86 |
| class: a word that ends in ing | 9 | 556.44 ± 0.7% | 625.77 ± 0.9% | 1178.99 ± 0.6% | 132.33 ± 1.8% | 761.71 ± 0.8% | 1080.70 ± 0.3% | 16024.51 ± 0.2% | 555.82 ± 0.4% | 0.89 | 1.00 | 4.20 | 0.73 |
| class: a word in capitals | 16 | 491.22 ± 0.3% | 533.25 ± 0.6% | 916.24 ± 0.2% | 135.89 ± 0.6% | 755.84 ± 2.4% | 1008.75 ± 1.2% | 8623.37 ± 0.2% | 491.34 ± 0.1% | 0.92 | 1.00 | 3.61 | 0.65 |
| class: a number | 6 | 611.03 ± 0.5% | 680.20 ± 0.8% | 1389.65 ± 0.1% | 41.86 ± 0.6% | 1408.78 ± 5.1% | 1862.89 ± 1.8% | 22426.41 ± 0.1% | 611.07 ± 0.2% | 0.90 | 1.00 | 14.60 | 0.43 |
| class: two capitalized words, second text | 23 | 436.38 ± 0.3% | 467.13 ± 0.3% | 710.07 ± 0.4% | 101.72 ± 0.4% | 502.00 ± 1.8% | 749.24 ± 0.5% | 6563.08 ± 0.4% | 435.58 ± 0.4% | 0.93 | 1.00 | 4.29 | 0.87 |
| other: a word between two words | 13 | 551.62 ± 0.2% | 567.50 ± 0.4% | 957.57 ± 0.2% | 133.41 ± 0.6% | 503.65 ± 1.6% | 801.87 ± 0.5% | 14775.87 ± 0.3% | 550.54 ± 0.4% | 0.97 | 1.00 | 4.13 | 1.10 |
| other: a number before a unit, second text | 15 | 406.45 ± 0.2% | 446.62 ± 0.3% | 658.11 ± 0.4% | 39.61 ± 0.5% | 630.47 ± 1.0% | 880.61 ± 1.1% | 15063.26 ± 0.6% | 406.23 ± 0.1% | 0.91 | 1.00 | 10.26 | 0.64 |
| other: a heading's start tag | 13 | 359.82 ± 0.3% | 365.87 ± 0.4% | 502.49 ± 0.3% | 43.89 ± 0.1% | 622.55 ± 1.8% | 872.85 ± 1.0% | 17953.96 ± 0.5% | 359.33 ± 0.2% | 0.98 | 1.00 | 8.20 | 0.58 |
| other: a whole word | 11 | 581.89 ± 0.4% | 616.21 ± 0.2% | 1094.36 ± 0.1% | 117.91 ± 0.5% | 566.94 ± 2.9% | 822.28 ± 0.5% | 26679.06 ± 0.3% | 581.14 ± 0.1% | 0.94 | 1.00 | 4.93 | 1.03 |
| other: a line's first word, second text | 17 | 532.59 ± 0.3% | 550.53 ± 0.5% | 942.73 ± 0.4% | 129.16 ± 0.3% | 708.16 ± 0.9% | refused | refused | 531.85 ± 0.3% | 0.97 | 1.00 | 4.12 | 0.75 |
| other: fourteen octets before an x | 16 | 112.00 ± 0.5% | 161.09 ± 1.1% | 189.99 ± 1.7% | 15.17 ± 0.2% | 451.71 ± 3.1% | 401.07 ± 0.3% | 12386.04 ± 0.6% | 111.93 ± 0.4% | 0.70 | 1.00 | 7.38 | 0.25 |
| other: a Greek word | 8 | 422.19 ± 0.4% | 584.53 ± 0.3% | 1062.28 ± 0.6% | 59.13 ± 0.3% | 1392.08 ± 1.5% | 1824.04 ± 0.5% | refused | 422.12 ± 0.5% | 0.72 | 1.00 | 7.14 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12771.48 ± 0.8% | not timed | not timed | 15935.63 ± 0.5% | 2025.58 ± 12.8% | not timed | not timed | 12752.60 ± 0.7% | | 1.00 | 0.80 | 6.31 |
| 01-literal/sherlock-casei-en | 522 | 3943.65 ± 0.3% | not timed | not timed | 3592.81 ± 0.3% | 32.48 ± 0.2% | not timed | not timed | 3943.77 ± 0.2% | | 1.00 | 1.10 | 121.43 |
| 01-literal/sherlock-ru | 724 | 13546.10 ± 0.5% | not timed | not timed | 17203.25 ± 0.6% | 1432.53 ± 6.5% | not timed | not timed | 13527.31 ± 0.6% | | 1.00 | 0.79 | 9.46 |
| 01-literal/sherlock-casei-ru | 746 | 5399.54 ± 0.3% | not timed | not timed | 3328.10 ± 0.3% | 30.76 ± 0.6% | not timed | not timed | 5403.34 ± 0.4% | | 1.00 | 1.62 | 175.52 |
| 01-literal/sherlock-zh | 30 | 16890.21 ± 0.1% | not timed | not timed | 18352.40 ± 0.7% | 2811.74 ± 9.7% | not timed | not timed | 16895.36 ± 0.4% | | 1.00 | 0.92 | 6.01 |
| 02-literal-alternate/sherlock-en | 714 | 5859.71 ± 0.3% | not timed | not timed | 3932.52 ± 0.3% | 16.66 ± 0.1% | not timed | not timed | 5863.33 ± 0.5% | | 1.00 | 1.49 | 351.79 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1705.61 ± 1.0% | not timed | not timed | 698.24 ± 0.2% | 11.05 ± 0.4% | not timed | not timed | 1697.77 ± 0.6% | | 1.00 | 2.44 | 154.36 |
| 02-literal-alternate/sherlock-ru | 899 | 4801.44 ± 0.3% | not timed | not timed | 3258.63 ± 0.1% | 22.67 ± 0.2% | not timed | not timed | 4804.59 ± 0.2% | | 1.00 | 1.47 | 211.80 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1819.77 ± 0.4% | not timed | not timed | 1234.67 ± 0.1% | 9.10 ± 0.1% | not timed | not timed | 1813.24 ± 0.4% | | 1.00 | 1.47 | 199.98 |
| 02-literal-alternate/sherlock-zh | 207 | 7032.93 ± 0.8% | not timed | not timed | 4157.95 ± 0.1% | 31.54 ± 0.1% | not timed | not timed | 7050.05 ± 1.2% | | 1.00 | 1.69 | 222.96 |
| 03-date/ascii | 111817 | 123.97 ± 0.6% | not timed | not timed | 96.21 ± 0.1% | 0.20 ± 3.2% | not timed | not timed | 123.17 ± 0.2% | | 1.01 | 1.29 | 621.92 |
| 04-ruff-noqa/real | 84 | 550.97 ± 0.2% | not timed | not timed | 479.95 ± 0.1% | 19.69 ± 1.3% | not timed | not timed | 551.91 ± 0.2% | | 1.00 | 1.15 | 27.99 |
| 04-ruff-noqa/tweaked | 44 | 552.50 ± 0.0% | not timed | not timed | 459.70 ± 0.1% | 363.61 ± 0.3% | not timed | not timed | 552.59 ± 0.4% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.52 ± 0.2% | not timed | not timed | 5.19 ± 0.2% | 0.21 ± 2.7% | not timed | not timed | 3.61 ± 1.7% | | 0.97 | 0.68 | 17.12 |
| 06-cloud-flare-redos/original | 107 | 183.65 ± 0.5% | not timed | not timed | 217.92 ± 0.7% | 24.82 ± 0.5% | not timed | not timed | 183.26 ± 0.5% | | 1.00 | 0.84 | 7.40 |
| 06-cloud-flare-redos/simplified-short | 102 | 147.43 ± 1.0% | not timed | not timed | 227.70 ± 0.1% | 26.63 ± 0.1% | not timed | not timed | 147.10 ± 0.9% | | 1.00 | 0.65 | 5.54 |
| 06-cloud-flare-redos/simplified-long | 10000 | 156.81 ± 1.9% | not timed | not timed | 255.90 ± 0.2% | 28.83 ± 0.4% | not timed | not timed | 156.68 ± 1.8% | | 1.00 | 0.61 | 5.44 |
| 07-unicode-character-data/parse-line | 558784 | 40.04 ± 0.2% | not timed | not timed | 179.54 ± 0.1% | 41.95 ± 6.9% | not timed | not timed | 39.97 ± 0.8% | | 1.00 | 0.22 | 0.95 |
| 08-words/all-english | 56691 | 103.03 ± 0.6% | not timed | not timed | 82.65 ± 0.3% | 11.90 ± 4.1% | not timed | not timed | 102.35 ± 0.2% | | 1.01 | 1.25 | 8.66 |
| 08-words/long-english | 839 | 997.83 ± 0.3% | not timed | not timed | 597.53 ± 0.2% | 32.67 ± 9.8% | not timed | not timed | 996.69 ± 0.2% | | 1.00 | 1.67 | 30.55 |
| 09-aws-keys/full | 0 | 421.83 ± 0.1% | not timed | not timed | 495.69 ± 0.1% | 63.33 ± 3.4% | not timed | not timed | 421.49 ± 0.1% | | 1.00 | 0.85 | 6.66 |
| 09-aws-keys/quick | 0 | 413.84 ± 0.1% | not timed | not timed | 963.92 ± 0.5% | 417.79 ± 1.1% | not timed | not timed | 410.25 ± 0.1% | | 1.01 | 0.43 | 0.99 |
| 10-bounded-repeat/letters-en | 1833 | 592.41 ± 0.4% | not timed | not timed | 517.79 ± 0.2% | 19.58 ± 0.4% | not timed | not timed | 591.54 ± 0.2% | | 1.00 | 1.14 | 30.25 |
| 10-bounded-repeat/letters-ru | 3475 | 404.10 ± 0.4% | not timed | not timed | 478.49 ± 0.2% | 22.71 ± 17.0% | not timed | not timed | 400.65 ± 0.6% | | 1.01 | 0.84 | 17.80 |
| 10-bounded-repeat/context | 53 | 73.41 ± 1.1% | not timed | not timed | 65.71 ± 0.4% | 19.71 ± 0.5% | not timed | not timed | 73.27 ± 0.9% | | 1.00 | 1.12 | 3.72 |
| 10-bounded-repeat/capitals | 11 | 1039.07 ± 0.4% | not timed | not timed | 618.62 ± 0.1% | 35.57 ± 0.1% | not timed | not timed | 1039.18 ± 0.2% | | 1.00 | 1.68 | 29.21 |
| 11-unstructured-to-json/extract | 600 | 24.58 ± 0.1% | not timed | not timed | 76.93 ± 0.1% | 48.81 ± 1.0% | not timed | not timed | 24.38 ± 0.9% | | 1.01 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 603.50 ± 0.6% | not timed | not timed | 559.68 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 602.01 ± 0.3% | | 1.00 | 1.08 | 1488.38 |
| 14-quadratic/1x | 100 | 12.61 ± 0.4% | not timed | not timed | 10.03 ± 0.2% | 0.96 ± 3.0% | not timed | not timed | 12.57 ± 1.0% | | 1.00 | 1.26 | 13.08 |
| 14-quadratic/2x | 200 | 7.78 ± 0.6% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 0.6% | not timed | not timed | 7.72 ± 0.9% | | 1.01 | 1.40 | 14.63 |
| 14-quadratic/10x | 1000 | 1.82 ± 0.5% | not timed | not timed | 1.21 ± 0.0% | 0.12 ± 1.6% | not timed | not timed | 1.81 ± 0.8% | | 1.00 | 1.50 | 15.82 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.43 ± 0.2% | not timed | not timed | 0.34 ± 0.3% | 0.55 ± 1.2% | not timed | not timed | 1.42 ± 1.1% | | 1.01 | 4.18 | 2.63 |
| 04-ruff-noqa/compile-real | 1 | 92.71 ± 0.0% | not timed | not timed | 14.03 ± 0.2% | 138.79 ± 2.4% | not timed | not timed | 92.81 ± 1.4% | | 1.00 | 6.61 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 14.56 ± 1.5% | not timed | not timed | 2.56 ± 1.1% | 6.46 ± 0.6% | not timed | not timed | 14.40 ± 2.0% | | 1.01 | 5.70 | 2.26 |
| 07-unicode-character-data/compile | 1 | 58.47 ± 0.1% | not timed | not timed | 26.28 ± 0.2% | 36.06 ± 2.0% | not timed | not timed | 58.08 ± 0.8% | | 1.01 | 2.22 | 1.62 |
| 09-aws-keys/compile-full | 1 | 43.64 ± 0.2% | not timed | not timed | 8.35 ± 0.4% | 23.36 ± 0.4% | not timed | not timed | 43.47 ± 0.2% | | 1.00 | 5.23 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 187.98 ± 0.1% | not timed | not timed | 48.07 ± 0.4% | 134.39 ± 2.8% | not timed | not timed | 188.97 ± 0.9% | | 0.99 | 3.91 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.58 ± 1.3% | not timed | not timed | 11.23 ± 0.2% | 15.98 ± 2.8% | not timed | not timed | 14.40 ± 0.5% | | 1.01 | 1.30 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.34 ± 0.1% | not timed | not timed | 8.06 ± 0.3% | 23.65 ± 0.6% | not timed | not timed | 84.90 ± 1.1% | | 1.01 | 10.59 | 3.61 |
| 11-unstructured-to-json/compile | 1 | 90.88 ± 0.2% | not timed | not timed | 40.71 ± 0.3% | 67.92 ± 1.1% | not timed | not timed | 90.67 ± 1.0% | | 1.00 | 2.23 | 1.34 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.4% | not timed | not timed | 0.07 ± 2.7% | 0.09 ± 19.3% | not timed | not timed | 0.35 ± 1.6% | | 1.01 | 5.16 | 3.84 |

