# bench-regex

| Field | Value |
|---|---|
| Commit | fbfd351 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117687915 |
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
| literal: a word | 217 | 16216.07 ± 2.4% | 1036.93 ± 0.1% | 27.85 ± 0.5% | 18113.73 ± 1.7% | 9049.90 ± 9.0% | 17.20 ± 0.3% | 86.38 ± 0.1% | 16315.10 ± 1.4% | 15.64 | 0.99 | 0.90 | 1.79 |
| literal: a word that is not there | 0 | 18674.83 ± 3.5% | 1047.38 ± 0.2% | 27.78 ± 0.4% | 19756.09 ± 1.5% | 28800.95 ± 1.4% | 17.00 ± 0.3% | 82.22 ± 0.2% | 18877.14 ± 0.6% | 17.83 | 0.99 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6084.21 ± 0.6% | 1014.09 ± 0.1% | 14.42 ± 0.2% | 3947.59 ± 0.3% | 21.82 ± 0.1% | 5.36 ± 0.2% | 6.91 ± 1.1% | 6068.59 ± 0.4% | 6.00 | 1.00 | 1.54 | 278.82 |
| literal: a word in any case | 217 | 12550.82 ± 0.6% | 1037.37 ± 0.1% | 21.27 ± 0.6% | 3973.97 ± 0.1% | 38.05 ± 4.6% | refused | differs | 12552.21 ± 0.4% | 12.10 | 1.00 | 3.16 | 329.88 |
| literal: an href attribute | 33 | 13755.99 ± 0.6% | 1045.38 ± 0.1% | 26.79 ± 0.3% | 16669.93 ± 2.1% | 2252.33 ± 5.4% | 12.67 ± 1.4% | 75.27 ± 0.2% | 13729.39 ± 0.5% | 13.16 | 1.00 | 0.83 | 6.11 |
| literal: a word, second text | 123 | 16333.09 ± 0.8% | 1042.03 ± 0.1% | 27.53 ± 0.1% | 18324.61 ± 1.8% | 7652.99 ± 4.1% | 20.03 ± 0.5% | 70.31 ± 0.1% | 16350.90 ± 1.3% | 15.67 | 1.00 | 0.89 | 2.13 |
| class: two capitalized words | 1331 | 1124.81 ± 0.5% | 953.74 ± 0.2% | 25.58 ± 0.2% | 582.13 ± 0.1% | 40.69 ± 4.9% | 14.72 ± 0.4% | 68.81 ± 0.2% | 1124.13 ± 0.6% | 1.18 | 1.00 | 1.93 | 27.65 |
| class: a word that ends in ing | 3399 | 876.37 ± 0.1% | 876.22 ± 0.1% | 17.85 ± 0.2% | 545.71 ± 0.1% | 29.66 ± 9.6% | 8.13 ± 0.1% | 18.39 ± 1.4% | 876.05 ± 0.1% | 1.00 | 1.00 | 1.61 | 29.54 |
| class: a word in capitals | 2332 | 1473.33 ± 0.9% | 937.47 ± 0.4% | 27.24 ± 0.4% | 572.72 ± 0.1% | 43.57 ± 16.7% | 17.11 ± 1.2% | 83.02 ± 0.1% | 1472.82 ± 0.3% | 1.57 | 1.00 | 2.57 | 33.82 |
| class: a number | 8288 | 1987.04 ± 0.5% | 786.71 ± 0.2% | 27.30 ± 0.3% | 1733.01 ± 0.1% | 43.08 ± 5.9% | 0.50 ± 0.9% | 56.69 ± 0.4% | 1988.90 ± 0.2% | 2.53 | 1.00 | 1.15 | 46.13 |
| class: two capitalized words, second text | 5359 | 682.89 ± 0.2% | 678.97 ± 0.5% | 22.98 ± 0.2% | 486.79 ± 0.1% | 35.53 ± 8.9% | 17.45 ± 0.6% | 63.97 ± 0.1% | 682.64 ± 0.1% | 1.01 | 1.00 | 1.40 | 19.22 |
| other: a word between two words | 6104 | 764.57 ± 0.4% | 737.99 ± 0.2% | 23.17 ± 0.4% | 737.55 ± 0.1% | 108.74 ± 19.2% | 11.21 ± 0.2% | 69.56 ± 0.3% | 752.45 ± 0.1% | 1.04 | 1.02 | 1.04 | 7.03 |
| other: a number before a unit, second text | 1481 | 5583.66 ± 1.5% | 972.67 ± 0.1% | 25.45 ± 0.2% | 5647.36 ± 0.6% | 40.88 ± 0.1% | 18.28 ± 0.1% | 66.85 ± 0.2% | 5573.49 ± 1.4% | 5.74 | 1.00 | 0.99 | 136.59 |
| other: a heading's start tag | 110 | 12613.23 ± 1.1% | 1034.99 ± 0.1% | 26.90 ± 0.3% | 1710.15 ± 0.5% | 1562.49 ± 6.0% | 15.96 ± 0.5% | 88.74 ± 0.3% | 12571.05 ± 1.1% | 12.19 | 1.00 | 7.38 | 8.07 |
| other: a whole word | 217 | 13796.05 ± 1.8% | 1036.23 ± 0.2% | 28.71 ± 0.6% | 14527.40 ± 0.9% | 49.47 ± 0.3% | 13.11 ± 0.1% | 55.76 ± 0.2% | 13847.55 ± 1.9% | 13.31 | 1.00 | 0.95 | 278.87 |
| other: a line's first word, second text | 3716 | 1981.55 ± 0.9% | 850.28 ± 0.1% | 30.34 ± 0.1% | 1735.55 ± 0.4% | 62.85 ± 8.3% | refused | refused | 1916.35 ± 0.6% | 2.33 | 1.03 | 1.14 | 31.53 |
| other: fourteen octets before an x | 87 | 19280.66 ± 1.4% | 233.83 ± 0.5% | 6.10 ± 0.1% | 4023.01 ± 0.7% | 10.61 ± 0.0% | differs | 17.78 ± 0.1% | 19303.37 ± 1.0% | 82.46 | 1.00 | 4.79 | 1816.91 |
| other: a Greek word | 21815 | 485.84 ± 0.1% | 307.30 ± 0.4% | 30.69 ± 0.3% | 290.45 ± 0.3% | 44.61 ± 10.1% | differs | refused | 479.01 ± 0.7% | 1.58 | 1.01 | 1.67 | 10.89 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.3% | 25.88 ± 0.2% | 0.82 ± 0.4% | 19.78 ± 0.4% | 2.78 ± 0.7% | differs | 4.01 ± 0.3% | 25.86 ± 0.2% | 1.00 | 1.00 | 1.31 | 9.31 |
| a UUID | 32895 | 21.11 ± 0.2% | 21.14 ± 0.2% | 0.65 ± 0.2% | 15.16 ± 0.4% | 3.13 ± 0.1% | 0.73 ± 0.1% | 3.62 ± 0.6% | 21.20 ± 0.4% | 1.00 | 1.00 | 1.39 | 6.75 |
| an IPv4 address | 33176 | 36.90 ± 0.1% | 36.88 ± 0.1% | 2.10 ± 0.3% | 29.30 ± 0.1% | 6.65 ± 0.2% | differs | 4.15 ± 0.3% | 36.93 ± 0.2% | 1.00 | 1.00 | 1.26 | 5.55 |
| a date and time | 32954 | 31.06 ± 0.3% | 31.08 ± 0.3% | 1.46 ± 0.3% | 21.63 ± 0.6% | 7.07 ± 0.1% | 1.25 ± 0.8% | 7.16 ± 0.3% | 31.03 ± 0.4% | 1.00 | 1.00 | 1.44 | 4.39 |
| a field path | 32606 | 29.38 ± 0.2% | 29.31 ± 0.3% | 1.01 ± 0.5% | 23.34 ± 0.4% | 3.49 ± 0.7% | differs | 2.97 ± 0.3% | 29.36 ± 0.2% | 1.00 | 1.00 | 1.26 | 8.42 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.58 ± 0.6% | 11.64 ± 0.9% | 11.64 ± 1.0% | 11.54 ± 0.2% | 4.97 ± 1.0% | 0.93 ± 0.3% | none | 11.64 ± 0.4% | 1.00 | 0.99 | 1.00 | 2.33 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.02 ± 0.4% | 236.42 ± 0.2% | 287.30 ± 0.2% | 86.65 ± 0.2% | 219.74 ± 0.9% | 478.03 ± 0.4% | 3861.13 ± 1.6% | 235.12 ± 0.2% | 0.99 | 1.00 | 2.71 | 1.07 |
| a UUID | 62 | 157.40 ± 0.2% | 157.62 ± 0.2% | 178.93 ± 0.3% | 46.24 ± 0.2% | 98.21 ± 0.9% | 182.67 ± 1.7% | 4387.28 ± 1.9% | 157.31 ± 0.3% | 1.00 | 1.00 | 3.40 | 1.60 |
| an IPv4 address | 29 | 421.71 ± 0.7% | 427.03 ± 0.7% | 620.02 ± 0.8% | 77.02 ± 0.7% | 128.47 ± 1.9% | 290.80 ± 0.8% | 7607.89 ± 0.5% | 421.60 ± 0.5% | 0.99 | 1.00 | 5.48 | 3.28 |
| a date and time | 56 | 306.53 ± 0.3% | 309.30 ± 0.3% | 398.10 ± 0.4% | 72.70 ± 0.5% | 134.94 ± 1.7% | 315.75 ± 0.8% | 4896.99 ± 0.3% | 306.36 ± 0.2% | 0.99 | 1.00 | 4.22 | 2.27 |
| a field path | 39 | 227.02 ± 0.5% | 228.53 ± 0.4% | 274.82 ± 0.2% | 80.08 ± 0.5% | 203.03 ± 1.7% | 501.90 ± 2.4% | 4886.59 ± 0.9% | 226.90 ± 0.2% | 0.99 | 1.00 | 2.83 | 1.12 |
| literal: a word | 7 | 626.04 ± 0.2% | 668.63 ± 0.3% | 1270.54 ± 0.2% | 518.17 ± 0.2% | 626.18 ± 2.3% | 937.19 ± 0.5% | 29598.51 ± 0.3% | 625.28 ± 0.1% | 0.94 | 1.00 | 1.21 | 1.00 |
| literal: a word that is not there | 8 | 601.23 ± 0.4% | 646.86 ± 0.3% | 1193.82 ± 0.1% | 466.47 ± 0.2% | 604.46 ± 1.9% | 889.27 ± 0.3% | 28590.48 ± 0.2% | 601.59 ± 0.3% | 0.93 | 1.00 | 1.29 | 0.99 |
| literal: one of four words | 26 | 242.13 ± 0.3% | 401.66 ± 0.2% | 564.19 ± 0.4% | 49.13 ± 0.5% | 240.80 ± 0.8% | 360.68 ± 2.0% | 15459.12 ± 0.2% | 242.16 ± 0.4% | 0.60 | 1.00 | 4.93 | 1.01 |
| literal: a word in any case | 11 | 485.22 ± 0.3% | 517.82 ± 0.3% | 846.04 ± 0.1% | 15.41 ± 0.2% | 647.52 ± 0.9% | refused | 23468.13 ± 0.4% | 485.41 ± 0.3% | 0.94 | 1.00 | 31.48 | 0.75 |
| literal: an href attribute | 12 | 351.13 ± 0.6% | 363.28 ± 0.4% | 495.74 ± 0.5% | 45.60 ± 0.8% | 495.53 ± 2.0% | 773.96 ± 0.4% | 21506.02 ± 0.2% | 350.74 ± 0.6% | 0.97 | 1.00 | 7.70 | 0.71 |
| literal: a word, second text | 10 | 561.85 ± 0.5% | 615.46 ± 0.3% | 1085.19 ± 0.6% | 421.92 ± 0.9% | 532.06 ± 2.5% | 801.24 ± 0.9% | 26590.79 ± 0.1% | 562.55 ± 0.3% | 0.91 | 1.00 | 1.33 | 1.06 |
| class: two capitalized words | 23 | 437.94 ± 0.7% | 469.42 ± 0.2% | 711.28 ± 0.4% | 100.64 ± 0.2% | 496.78 ± 1.4% | 739.67 ± 0.3% | 6576.76 ± 0.3% | 437.59 ± 0.4% | 0.93 | 1.00 | 4.35 | 0.88 |
| class: a word that ends in ing | 9 | 556.49 ± 0.3% | 628.17 ± 0.2% | 1177.42 ± 0.1% | 131.83 ± 1.0% | 750.34 ± 1.1% | 1089.20 ± 1.9% | 15995.86 ± 0.1% | 555.79 ± 0.4% | 0.89 | 1.00 | 4.22 | 0.74 |
| class: a word in capitals | 16 | 492.33 ± 0.4% | 533.87 ± 0.7% | 914.19 ± 0.2% | 135.01 ± 0.4% | 746.31 ± 1.6% | 1013.90 ± 0.8% | 8617.06 ± 0.3% | 491.57 ± 0.1% | 0.92 | 1.00 | 3.65 | 0.66 |
| class: a number | 6 | 613.62 ± 0.5% | 684.79 ± 0.3% | 1387.39 ± 0.3% | 41.98 ± 0.4% | 1386.18 ± 7.6% | 1906.78 ± 2.2% | 22313.93 ± 0.2% | 612.86 ± 0.3% | 0.90 | 1.00 | 14.62 | 0.44 |
| class: two capitalized words, second text | 23 | 437.69 ± 0.2% | 468.93 ± 0.4% | 711.04 ± 0.1% | 103.52 ± 0.3% | 498.35 ± 1.8% | 727.04 ± 0.3% | 6578.46 ± 0.4% | 437.74 ± 0.3% | 0.93 | 1.00 | 4.23 | 0.88 |
| other: a word between two words | 13 | 552.63 ± 0.3% | 571.06 ± 0.3% | 959.08 ± 0.4% | 135.16 ± 1.0% | 503.94 ± 0.9% | 808.01 ± 1.1% | 14832.00 ± 0.2% | 552.23 ± 0.1% | 0.97 | 1.00 | 4.09 | 1.10 |
| other: a number before a unit, second text | 15 | 406.78 ± 0.4% | 447.75 ± 0.3% | 657.05 ± 0.1% | 39.39 ± 0.4% | 628.44 ± 1.1% | 883.76 ± 0.5% | 15091.05 ± 0.2% | 406.42 ± 0.1% | 0.91 | 1.00 | 10.33 | 0.65 |
| other: a heading's start tag | 13 | 360.32 ± 0.1% | 365.47 ± 0.4% | 501.24 ± 0.3% | 44.45 ± 0.3% | 622.98 ± 1.2% | 862.42 ± 0.3% | 17857.31 ± 0.6% | 360.10 ± 0.1% | 0.99 | 1.00 | 8.11 | 0.58 |
| other: a whole word | 11 | 585.77 ± 0.3% | 619.70 ± 0.3% | 1089.39 ± 0.3% | 121.52 ± 0.6% | 561.86 ± 2.2% | 812.08 ± 1.0% | 26708.25 ± 0.9% | 586.07 ± 0.2% | 0.95 | 1.00 | 4.82 | 1.04 |
| other: a line's first word, second text | 17 | 532.37 ± 0.5% | 550.99 ± 0.5% | 941.27 ± 0.9% | 129.11 ± 0.4% | 706.88 ± 1.1% | refused | refused | 531.24 ± 0.9% | 0.97 | 1.00 | 4.12 | 0.75 |
| other: fourteen octets before an x | 16 | 110.84 ± 0.6% | 160.92 ± 1.1% | 190.11 ± 0.8% | 15.22 ± 0.2% | 449.69 ± 3.5% | 404.23 ± 0.5% | 12525.92 ± 2.4% | 110.77 ± 0.6% | 0.69 | 1.00 | 7.28 | 0.25 |
| other: a Greek word | 8 | 423.54 ± 0.2% | 586.83 ± 0.3% | 1057.12 ± 0.1% | 59.26 ± 0.5% | 1389.14 ± 1.7% | 1832.79 ± 0.7% | refused | 422.96 ± 0.2% | 0.72 | 1.00 | 7.15 | 0.30 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12759.10 ± 0.6% | not timed | not timed | 15946.17 ± 0.7% | 2096.65 ± 15.3% | not timed | not timed | 12776.05 ± 0.6% | | 1.00 | 0.80 | 6.09 |
| 01-literal/sherlock-casei-en | 522 | 3894.99 ± 0.8% | not timed | not timed | 3591.29 ± 0.4% | 32.39 ± 0.3% | not timed | not timed | 3887.71 ± 0.4% | | 1.00 | 1.08 | 120.27 |
| 01-literal/sherlock-ru | 724 | 13635.53 ± 0.3% | not timed | not timed | 17270.52 ± 0.3% | 1572.43 ± 14.3% | not timed | not timed | 13603.65 ± 1.0% | | 1.00 | 0.79 | 8.67 |
| 01-literal/sherlock-casei-ru | 746 | 5295.65 ± 0.4% | not timed | not timed | 3332.57 ± 0.4% | 30.80 ± 0.3% | not timed | not timed | 5304.48 ± 0.4% | | 1.00 | 1.59 | 171.94 |
| 01-literal/sherlock-zh | 30 | 16839.04 ± 1.0% | not timed | not timed | 18364.33 ± 1.2% | 2757.24 ± 5.7% | not timed | not timed | 16819.29 ± 0.8% | | 1.00 | 0.92 | 6.11 |
| 02-literal-alternate/sherlock-en | 714 | 5802.31 ± 0.7% | not timed | not timed | 3937.97 ± 0.3% | 16.59 ± 0.1% | not timed | not timed | 5808.73 ± 0.4% | | 1.00 | 1.47 | 349.79 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1677.60 ± 0.9% | not timed | not timed | 694.18 ± 0.2% | 11.04 ± 0.2% | not timed | not timed | 1671.14 ± 0.4% | | 1.00 | 2.42 | 151.98 |
| 02-literal-alternate/sherlock-ru | 899 | 4696.24 ± 0.6% | not timed | not timed | 3254.30 ± 0.2% | 22.68 ± 0.2% | not timed | not timed | 4700.93 ± 2.7% | | 1.00 | 1.44 | 207.07 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1795.77 ± 0.5% | not timed | not timed | 1232.46 ± 0.1% | 9.07 ± 0.1% | not timed | not timed | 1790.09 ± 0.3% | | 1.00 | 1.46 | 197.91 |
| 02-literal-alternate/sherlock-zh | 207 | 7044.42 ± 0.6% | not timed | not timed | 4163.08 ± 0.2% | 31.52 ± 0.1% | not timed | not timed | 7061.66 ± 0.4% | | 1.00 | 1.69 | 223.52 |
| 03-date/ascii | 111817 | 123.99 ± 0.4% | not timed | not timed | 95.77 ± 0.1% | 0.20 ± 2.7% | not timed | not timed | 122.72 ± 0.2% | | 1.01 | 1.29 | 612.87 |
| 04-ruff-noqa/real | 84 | 555.14 ± 0.1% | not timed | not timed | 479.84 ± 0.1% | 19.54 ± 0.9% | not timed | not timed | 555.40 ± 0.1% | | 1.00 | 1.16 | 28.41 |
| 04-ruff-noqa/tweaked | 44 | 560.00 ± 0.1% | not timed | not timed | 460.76 ± 0.1% | 367.32 ± 0.3% | not timed | not timed | 558.34 ± 0.1% | | 1.00 | 1.22 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.50 ± 0.2% | not timed | not timed | 5.24 ± 0.3% | 0.21 ± 2.4% | not timed | not timed | 3.65 ± 0.2% | | 0.96 | 0.67 | 17.04 |
| 06-cloud-flare-redos/original | 107 | 185.07 ± 0.8% | not timed | not timed | 215.21 ± 0.1% | 24.97 ± 0.3% | not timed | not timed | 184.20 ± 0.6% | | 1.00 | 0.86 | 7.41 |
| 06-cloud-flare-redos/simplified-short | 102 | 142.74 ± 1.7% | not timed | not timed | 226.78 ± 0.1% | 26.74 ± 0.1% | not timed | not timed | 142.84 ± 1.2% | | 1.00 | 0.63 | 5.34 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.80 ± 2.3% | not timed | not timed | 254.85 ± 0.1% | 28.88 ± 0.1% | not timed | not timed | 154.65 ± 2.5% | | 1.00 | 0.61 | 5.36 |
| 07-unicode-character-data/parse-line | 558784 | 233.14 ± 2.4% | not timed | not timed | 180.67 ± 0.1% | 43.28 ± 6.3% | not timed | not timed | 227.21 ± 1.9% | | 1.03 | 1.29 | 5.39 |
| 08-words/all-english | 56691 | 103.19 ± 0.3% | not timed | not timed | 83.33 ± 0.7% | 12.06 ± 12.0% | not timed | not timed | 102.53 ± 0.3% | | 1.01 | 1.24 | 8.56 |
| 08-words/long-english | 839 | 999.01 ± 0.1% | not timed | not timed | 597.88 ± 0.0% | 32.49 ± 11.8% | not timed | not timed | 998.85 ± 0.3% | | 1.00 | 1.67 | 30.75 |
| 09-aws-keys/full | 0 | 424.68 ± 0.1% | not timed | not timed | 491.80 ± 0.1% | 64.90 ± 0.2% | not timed | not timed | 425.13 ± 0.1% | | 1.00 | 0.86 | 6.54 |
| 09-aws-keys/quick | 0 | 738.99 ± 0.1% | not timed | not timed | 997.77 ± 0.5% | 424.37 ± 4.1% | not timed | not timed | 737.52 ± 0.1% | | 1.00 | 0.74 | 1.74 |
| 10-bounded-repeat/letters-en | 1833 | 587.29 ± 0.2% | not timed | not timed | 519.12 ± 0.4% | 19.43 ± 0.6% | not timed | not timed | 585.76 ± 0.1% | | 1.00 | 1.13 | 30.23 |
| 10-bounded-repeat/letters-ru | 3475 | 400.77 ± 0.2% | not timed | not timed | 479.26 ± 0.2% | 22.17 ± 10.4% | not timed | not timed | 398.96 ± 0.6% | | 1.00 | 0.84 | 18.08 |
| 10-bounded-repeat/context | 53 | 79.09 ± 1.1% | not timed | not timed | 65.93 ± 0.4% | 19.76 ± 0.2% | not timed | not timed | 79.91 ± 1.3% | | 0.99 | 1.20 | 4.00 |
| 10-bounded-repeat/capitals | 11 | 1046.95 ± 0.2% | not timed | not timed | 618.07 ± 0.1% | 36.29 ± 0.2% | not timed | not timed | 1046.87 ± 0.1% | | 1.00 | 1.69 | 28.85 |
| 11-unstructured-to-json/extract | 600 | 47.79 ± 0.0% | not timed | not timed | 76.65 ± 0.1% | 48.68 ± 0.5% | not timed | not timed | 47.57 ± 0.1% | | 1.00 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 603.34 ± 0.4% | not timed | not timed | 561.71 ± 0.1% | 0.40 ± 0.4% | not timed | not timed | 604.34 ± 0.2% | | 1.00 | 1.07 | 1504.52 |
| 14-quadratic/1x | 100 | 12.61 ± 0.3% | not timed | not timed | 10.03 ± 0.1% | 0.96 ± 3.7% | not timed | not timed | 12.57 ± 0.6% | | 1.00 | 1.26 | 13.19 |
| 14-quadratic/2x | 200 | 7.84 ± 0.3% | not timed | not timed | 5.53 ± 0.1% | 0.53 ± 1.9% | not timed | not timed | 7.79 ± 0.4% | | 1.01 | 1.42 | 14.86 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.1% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.7% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.54 | 16.11 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.44 ± 0.3% | not timed | not timed | 0.34 ± 0.7% | 0.54 ± 3.2% | not timed | not timed | 1.44 ± 0.9% | | 1.00 | 4.21 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 92.22 ± 0.3% | not timed | not timed | 13.70 ± 0.2% | 139.97 ± 2.3% | not timed | not timed | 92.31 ± 1.0% | | 1.00 | 6.73 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.45 ± 0.2% | not timed | not timed | 2.53 ± 0.5% | 6.42 ± 2.1% | not timed | not timed | 14.39 ± 1.0% | | 1.00 | 5.72 | 2.25 |
| 07-unicode-character-data/compile | 1 | 58.11 ± 0.1% | not timed | not timed | 25.91 ± 0.3% | 36.01 ± 2.4% | not timed | not timed | 57.71 ± 1.3% | | 1.01 | 2.24 | 1.61 |
| 09-aws-keys/compile-full | 1 | 43.22 ± 0.4% | not timed | not timed | 8.34 ± 0.4% | 23.32 ± 0.7% | not timed | not timed | 43.09 ± 0.3% | | 1.00 | 5.18 | 1.85 |
| 09-aws-keys/compile-quick | 1 | 184.59 ± 0.1% | not timed | not timed | 47.88 ± 0.2% | 134.05 ± 1.6% | not timed | not timed | 184.67 ± 1.0% | | 1.00 | 3.86 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 14.49 ± 2.8% | not timed | not timed | 11.10 ± 0.2% | 15.96 ± 2.9% | not timed | not timed | 14.26 ± 2.6% | | 1.02 | 1.31 | 0.91 |
| 10-bounded-repeat/compile-capitals | 1 | 85.47 ± 0.2% | not timed | not timed | 7.96 ± 0.1% | 23.64 ± 2.2% | not timed | not timed | 85.36 ± 0.8% | | 1.00 | 10.73 | 3.62 |
| 11-unstructured-to-json/compile | 1 | 90.23 ± 0.2% | not timed | not timed | 40.09 ± 0.3% | 67.98 ± 2.3% | not timed | not timed | 89.87 ± 1.0% | | 1.00 | 2.25 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 0.1% | 0.10 ± 17.7% | not timed | not timed | 0.36 ± 1.7% | | 1.00 | 5.22 | 3.74 |

