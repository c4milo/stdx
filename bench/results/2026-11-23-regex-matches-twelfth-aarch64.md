# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127362752 |
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
| literal: a word | 217 | 15949.36 ± 1.9% | 1039.28 ± 0.1% | 27.93 ± 0.3% | 17951.16 ± 2.9% | 9066.50 ± 10.3% | 17.27 ± 0.2% | 85.96 ± 0.2% | 16162.57 ± 2.1% | 15.35 | 0.99 | 0.89 | 1.76 |
| literal: a word that is not there | 0 | 18658.66 ± 2.1% | 1047.78 ± 0.2% | 27.91 ± 0.2% | 19385.34 ± 0.7% | 27836.78 ± 3.5% | 17.11 ± 0.2% | 81.81 ± 0.2% | 18762.48 ± 0.9% | 17.81 | 0.99 | 0.96 | 0.67 |
| literal: one of four words | 661 | 6069.96 ± 0.1% | 1021.02 ± 0.3% | 14.56 ± 0.3% | 3944.32 ± 0.2% | 21.88 ± 0.1% | 5.36 ± 0.3% | 6.72 ± 0.1% | 6064.61 ± 0.2% | 5.94 | 1.00 | 1.54 | 277.39 |
| literal: a word in any case | 217 | 12541.27 ± 0.9% | 1040.05 ± 0.1% | 21.46 ± 2.5% | 3975.03 ± 0.2% | 37.96 ± 0.3% | refused | differs | 12535.62 ± 0.2% | 12.06 | 1.00 | 3.16 | 330.36 |
| literal: an href attribute | 33 | 13767.07 ± 1.4% | 1046.30 ± 0.1% | 26.90 ± 0.1% | 17102.98 ± 0.7% | 2266.50 ± 5.5% | 13.14 ± 0.3% | 75.21 ± 0.1% | 13789.95 ± 0.4% | 13.16 | 1.00 | 0.80 | 6.07 |
| literal: a word, second text | 123 | 16417.13 ± 1.5% | 1042.91 ± 0.2% | 27.75 ± 0.4% | 18375.86 ± 5.2% | 7620.12 ± 3.3% | 20.05 ± 0.5% | 68.20 ± 0.8% | 16396.37 ± 2.1% | 15.74 | 1.00 | 0.89 | 2.15 |
| class: two capitalized words | 1331 | 1129.20 ± 0.4% | 977.11 ± 0.1% | 25.70 ± 0.1% | 585.37 ± 0.0% | 40.58 ± 7.8% | 14.77 ± 0.3% | 68.38 ± 0.3% | 1126.50 ± 0.4% | 1.16 | 1.00 | 1.93 | 27.82 |
| class: a word that ends in ing | 3399 | 889.34 ± 0.1% | 890.00 ± 0.1% | 17.93 ± 0.2% | 547.42 ± 0.2% | 29.66 ± 10.9% | 8.14 ± 0.2% | 18.25 ± 0.2% | 888.62 ± 0.1% | 1.00 | 1.00 | 1.62 | 29.98 |
| class: a word in capitals | 2332 | 1450.97 ± 0.4% | 949.52 ± 0.1% | 27.39 ± 0.2% | 572.54 ± 0.1% | 43.60 ± 0.3% | 17.16 ± 0.3% | 82.84 ± 0.3% | 1452.54 ± 0.3% | 1.53 | 1.00 | 2.53 | 33.28 |
| class: a number | 8288 | 1994.53 ± 0.3% | 827.41 ± 0.0% | 27.52 ± 0.2% | 1716.41 ± 0.3% | 40.27 ± 16.2% | 0.54 ± 0.5% | 56.64 ± 0.6% | 1996.36 ± 0.2% | 2.41 | 1.00 | 1.16 | 49.53 |
| class: two capitalized words, second text | 5359 | 737.25 ± 0.1% | 736.95 ± 0.2% | 23.12 ± 0.3% | 484.65 ± 0.1% | 34.01 ± 10.0% | 17.11 ± 0.2% | 63.38 ± 0.4% | 737.62 ± 0.2% | 1.00 | 1.00 | 1.52 | 21.67 |
| other: a word between two words | 6104 | 762.20 ± 0.2% | 763.91 ± 0.1% | 23.35 ± 0.1% | 739.58 ± 0.3% | 109.14 ± 11.5% | 11.16 ± 0.1% | 69.11 ± 0.3% | 762.73 ± 0.1% | 1.00 | 1.00 | 1.03 | 6.98 |
| other: a number before a unit, second text | 1481 | 5405.31 ± 0.7% | 982.18 ± 0.1% | 25.58 ± 0.1% | 5652.44 ± 0.6% | 40.76 ± 8.7% | 18.14 ± 0.2% | 66.83 ± 0.1% | 5519.18 ± 0.6% | 5.50 | 0.98 | 0.96 | 132.60 |
| other: a heading's start tag | 110 | 12556.21 ± 0.6% | 1035.79 ± 0.1% | 27.05 ± 0.3% | 1709.08 ± 0.2% | 1585.77 ± 6.2% | 15.92 ± 3.4% | 88.40 ± 0.2% | 12561.12 ± 0.3% | 12.12 | 1.00 | 7.35 | 7.92 |
| other: a whole word | 217 | 13962.61 ± 0.3% | 1038.54 ± 0.1% | 29.20 ± 0.3% | 14630.66 ± 0.3% | 49.34 ± 0.4% | 13.11 ± 0.2% | 55.46 ± 0.3% | 13953.39 ± 0.4% | 13.44 | 1.00 | 0.95 | 282.96 |
| other: a line's first word, second text | 3716 | 1947.98 ± 0.5% | 872.88 ± 0.1% | 30.44 ± 0.2% | 1726.88 ± 0.2% | 62.32 ± 5.3% | refused | refused | 1937.61 ± 0.9% | 2.23 | 1.01 | 1.13 | 31.26 |
| other: fourteen octets before an x | 87 | 19497.64 ± 2.2% | 238.82 ± 0.4% | 6.12 ± 0.1% | 3933.94 ± 0.5% | 10.63 ± 0.1% | differs | 17.65 ± 0.1% | 19480.45 ± 0.6% | 81.64 | 1.00 | 4.96 | 1833.78 |
| other: a Greek word | 21815 | 470.23 ± 0.6% | 357.66 ± 0.2% | 30.84 ± 0.3% | 289.55 ± 0.1% | 47.29 ± 15.5% | differs | refused | 469.01 ± 0.4% | 1.31 | 1.00 | 1.62 | 9.94 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.75 ± 0.3% | 25.83 ± 0.3% | 0.82 ± 0.2% | 19.71 ± 0.7% | 2.78 ± 1.1% | differs | 4.03 ± 0.2% | 25.84 ± 0.3% | 1.00 | 1.00 | 1.31 | 9.28 |
| a UUID | 32895 | 21.06 ± 0.7% | 21.10 ± 0.2% | 0.65 ± 0.3% | 15.06 ± 0.3% | 3.10 ± 1.0% | 0.73 ± 0.2% | 3.62 ± 0.5% | 21.16 ± 0.4% | 1.00 | 1.00 | 1.40 | 6.79 |
| an IPv4 address | 33176 | 36.96 ± 0.2% | 36.88 ± 0.2% | 2.09 ± 0.1% | 29.27 ± 0.7% | 6.67 ± 0.1% | differs | 4.16 ± 0.2% | 36.72 ± 0.3% | 1.00 | 1.01 | 1.26 | 5.54 |
| a date and time | 32954 | 31.02 ± 0.4% | 31.10 ± 0.5% | 1.41 ± 0.2% | 21.50 ± 1.0% | 7.04 ± 0.7% | 1.25 ± 0.2% | 7.11 ± 0.3% | 31.01 ± 0.4% | 1.00 | 1.00 | 1.44 | 4.41 |
| a field path | 32606 | 29.51 ± 0.1% | 29.47 ± 0.1% | 1.01 ± 0.7% | 23.12 ± 0.1% | 3.51 ± 0.8% | differs | 2.92 ± 0.1% | 29.47 ± 0.2% | 1.00 | 1.00 | 1.28 | 8.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.49 ± 0.3% | 11.52 ± 0.3% | 11.55 ± 0.4% | 11.45 ± 0.3% | 4.95 ± 3.0% | 0.93 ± 0.4% | none | 11.55 ± 0.1% | 1.00 | 0.99 | 1.00 | 2.32 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.02 ± 0.3% | 236.03 ± 0.2% | 286.16 ± 0.2% | 86.81 ± 0.2% | 222.34 ± 2.3% | 483.68 ± 0.8% | 3716.46 ± 1.7% | 234.11 ± 0.3% | 0.99 | 1.00 | 2.70 | 1.05 |
| a UUID | 62 | 157.35 ± 0.2% | 157.68 ± 0.1% | 178.85 ± 0.1% | 45.74 ± 0.1% | 98.22 ± 1.3% | 181.39 ± 0.6% | 4444.68 ± 0.2% | 157.29 ± 0.2% | 1.00 | 1.00 | 3.44 | 1.60 |
| an IPv4 address | 29 | 420.93 ± 0.6% | 426.73 ± 0.3% | 617.23 ± 0.4% | 76.92 ± 1.1% | 131.17 ± 1.1% | 289.07 ± 0.5% | 7653.65 ± 0.6% | 420.20 ± 0.6% | 0.99 | 1.00 | 5.47 | 3.21 |
| a date and time | 56 | 306.74 ± 0.6% | 309.41 ± 0.3% | 398.29 ± 0.5% | 72.36 ± 0.2% | 137.59 ± 1.6% | 318.72 ± 0.8% | 4945.41 ± 0.7% | 306.73 ± 0.5% | 0.99 | 1.00 | 4.24 | 2.23 |
| a field path | 39 | 226.94 ± 0.2% | 228.22 ± 0.4% | 274.60 ± 0.4% | 79.97 ± 0.3% | 205.87 ± 1.2% | 484.64 ± 0.6% | 4817.44 ± 3.3% | 226.74 ± 0.3% | 0.99 | 1.00 | 2.84 | 1.10 |
| literal: a word | 7 | 627.93 ± 0.7% | 672.72 ± 1.1% | 1274.97 ± 0.6% | 509.80 ± 2.0% | 622.54 ± 2.3% | 909.87 ± 0.5% | 29572.73 ± 0.4% | 628.09 ± 0.3% | 0.93 | 1.00 | 1.23 | 1.01 |
| literal: a word that is not there | 8 | 604.97 ± 0.3% | 653.69 ± 0.1% | 1202.17 ± 0.1% | 465.92 ± 0.3% | 599.80 ± 1.4% | 865.56 ± 0.6% | 28601.51 ± 0.2% | 604.22 ± 0.2% | 0.93 | 1.00 | 1.30 | 1.01 |
| literal: one of four words | 26 | 242.93 ± 0.3% | 403.49 ± 0.3% | 567.86 ± 0.6% | 49.57 ± 0.2% | 242.25 ± 1.1% | 353.24 ± 0.3% | 15394.35 ± 0.1% | 242.71 ± 0.3% | 0.60 | 1.00 | 4.90 | 1.00 |
| literal: a word in any case | 11 | 488.55 ± 0.3% | 521.70 ± 0.2% | 850.55 ± 0.5% | 15.82 ± 0.8% | 643.52 ± 1.2% | refused | 23252.64 ± 0.3% | 488.18 ± 0.2% | 0.94 | 1.00 | 30.88 | 0.76 |
| literal: an href attribute | 12 | 351.15 ± 0.4% | 364.44 ± 0.3% | 496.04 ± 0.3% | 45.02 ± 0.2% | 497.92 ± 1.7% | 779.15 ± 1.7% | 21401.78 ± 0.3% | 351.11 ± 0.5% | 0.96 | 1.00 | 7.80 | 0.71 |
| literal: a word, second text | 10 | 564.15 ± 0.1% | 618.53 ± 0.2% | 1083.11 ± 0.2% | 415.16 ± 0.3% | 537.13 ± 2.3% | 797.33 ± 0.3% | 26430.97 ± 0.5% | 564.02 ± 0.2% | 0.91 | 1.00 | 1.36 | 1.05 |
| class: two capitalized words | 23 | 437.84 ± 0.3% | 469.65 ± 0.6% | 709.57 ± 0.3% | 101.33 ± 0.2% | 499.37 ± 3.6% | 743.44 ± 0.7% | 6329.69 ± 0.1% | 438.18 ± 0.3% | 0.93 | 1.00 | 4.32 | 0.88 |
| class: a word that ends in ing | 9 | 557.74 ± 0.2% | 629.46 ± 0.7% | 1178.16 ± 0.2% | 132.70 ± 1.3% | 751.04 ± 0.3% | 1084.78 ± 0.7% | 15680.88 ± 0.1% | 557.52 ± 0.2% | 0.89 | 1.00 | 4.20 | 0.74 |
| class: a word in capitals | 16 | 490.51 ± 0.6% | 533.33 ± 0.3% | 905.75 ± 0.4% | 136.83 ± 1.1% | 748.98 ± 1.4% | 1034.68 ± 0.8% | 8315.58 ± 0.1% | 491.18 ± 0.8% | 0.92 | 1.00 | 3.58 | 0.65 |
| class: a number | 6 | 613.15 ± 0.1% | 684.71 ± 0.2% | 1379.96 ± 0.0% | 41.90 ± 0.9% | 1384.06 ± 0.6% | 1932.20 ± 0.9% | 22421.19 ± 0.1% | 613.75 ± 0.4% | 0.90 | 1.00 | 14.63 | 0.44 |
| class: two capitalized words, second text | 23 | 438.31 ± 0.5% | 469.92 ± 0.5% | 710.92 ± 0.3% | 103.24 ± 0.1% | 497.44 ± 1.3% | 765.15 ± 0.5% | 6330.40 ± 0.2% | 438.54 ± 0.3% | 0.93 | 1.00 | 4.25 | 0.88 |
| other: a word between two words | 13 | 555.02 ± 0.3% | 574.94 ± 0.3% | 964.18 ± 0.4% | 135.16 ± 0.6% | 500.02 ± 2.0% | 812.01 ± 0.5% | 14522.85 ± 0.3% | 555.25 ± 0.4% | 0.97 | 1.00 | 4.11 | 1.11 |
| other: a number before a unit, second text | 15 | 407.44 ± 0.3% | 449.70 ± 0.5% | 658.15 ± 0.4% | 39.69 ± 0.4% | 629.88 ± 1.7% | 887.74 ± 0.3% | 15050.60 ± 0.1% | 407.49 ± 0.2% | 0.91 | 1.00 | 10.27 | 0.65 |
| other: a heading's start tag | 13 | 360.69 ± 0.3% | 366.14 ± 0.2% | 500.80 ± 0.4% | 43.93 ± 1.9% | 623.39 ± 9.7% | 874.77 ± 1.0% | 17823.05 ± 0.1% | 360.51 ± 0.2% | 0.99 | 1.00 | 8.21 | 0.58 |
| other: a whole word | 11 | 587.32 ± 0.4% | 623.89 ± 0.6% | 1097.14 ± 0.7% | 121.17 ± 0.5% | 557.03 ± 1.7% | 819.90 ± 2.3% | 26120.86 ± 0.5% | 587.08 ± 0.4% | 0.94 | 1.00 | 4.85 | 1.05 |
| other: a line's first word, second text | 17 | 534.50 ± 0.4% | 552.43 ± 0.4% | 943.25 ± 0.6% | 128.05 ± 0.3% | 694.87 ± 0.9% | refused | refused | 534.01 ± 0.8% | 0.97 | 1.00 | 4.17 | 0.77 |
| other: fourteen octets before an x | 16 | 111.65 ± 0.2% | 161.05 ± 0.3% | 189.75 ± 0.6% | 15.04 ± 0.6% | 446.98 ± 1.2% | 407.31 ± 1.4% | 12776.58 ± 0.3% | 111.75 ± 0.5% | 0.69 | 1.00 | 7.42 | 0.25 |
| other: a Greek word | 8 | 424.74 ± 0.2% | 586.21 ± 0.4% | 1050.03 ± 0.3% | 59.02 ± 0.4% | 1365.56 ± 1.7% | 1815.54 ± 0.4% | refused | 424.18 ± 0.3% | 0.72 | 1.00 | 7.20 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12677.80 ± 1.1% | not timed | not timed | 15997.11 ± 2.0% | 1968.36 ± 13.3% | not timed | not timed | 12662.96 ± 0.8% | | 1.00 | 0.79 | 6.44 |
| 01-literal/sherlock-casei-en | 522 | 3868.00 ± 0.5% | not timed | not timed | 3589.17 ± 0.2% | 31.52 ± 14.1% | not timed | not timed | 3868.81 ± 1.1% | | 1.00 | 1.08 | 122.73 |
| 01-literal/sherlock-ru | 724 | 13550.21 ± 0.8% | not timed | not timed | 17302.59 ± 0.3% | 1568.04 ± 11.0% | not timed | not timed | 13547.62 ± 0.2% | | 1.00 | 0.78 | 8.64 |
| 01-literal/sherlock-casei-ru | 746 | 5243.81 ± 0.3% | not timed | not timed | 3330.34 ± 0.2% | 31.19 ± 9.8% | not timed | not timed | 5254.78 ± 0.3% | | 1.00 | 1.57 | 168.14 |
| 01-literal/sherlock-zh | 30 | 16868.02 ± 1.2% | not timed | not timed | 18475.77 ± 0.9% | 2564.12 ± 21.1% | not timed | not timed | 16795.60 ± 0.8% | | 1.00 | 0.91 | 6.58 |
| 02-literal-alternate/sherlock-en | 714 | 5814.93 ± 0.3% | not timed | not timed | 3941.08 ± 0.3% | 16.00 ± 3.3% | not timed | not timed | 5816.60 ± 0.7% | | 1.00 | 1.48 | 363.50 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1668.76 ± 1.3% | not timed | not timed | 697.29 ± 0.2% | 10.79 ± 0.5% | not timed | not timed | 1661.37 ± 0.4% | | 1.00 | 2.39 | 154.71 |
| 02-literal-alternate/sherlock-ru | 899 | 4654.83 ± 0.3% | not timed | not timed | 3258.45 ± 0.1% | 21.94 ± 0.3% | not timed | not timed | 4655.07 ± 0.2% | | 1.00 | 1.43 | 212.16 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1784.12 ± 0.6% | not timed | not timed | 1230.42 ± 0.3% | 9.06 ± 0.3% | not timed | not timed | 1775.71 ± 0.3% | | 1.00 | 1.45 | 196.95 |
| 02-literal-alternate/sherlock-zh | 207 | 7073.81 ± 0.2% | not timed | not timed | 4159.48 ± 0.2% | 30.41 ± 0.1% | not timed | not timed | 7065.62 ± 0.1% | | 1.00 | 1.70 | 232.65 |
| 03-date/ascii | 111817 | 124.35 ± 0.4% | not timed | not timed | 96.04 ± 0.0% | 0.20 ± 3.1% | not timed | not timed | 123.67 ± 0.1% | | 1.01 | 1.29 | 614.19 |
| 04-ruff-noqa/real | 84 | 554.02 ± 0.1% | not timed | not timed | 468.44 ± 0.1% | 19.65 ± 0.2% | not timed | not timed | 554.92 ± 0.1% | | 1.00 | 1.18 | 28.19 |
| 04-ruff-noqa/tweaked | 44 | 545.71 ± 0.1% | not timed | not timed | 462.16 ± 0.0% | 364.00 ± 0.7% | not timed | not timed | 543.90 ± 0.2% | | 1.00 | 1.18 | 1.50 |
| 05-lexer-veryl/single | 124800 | 3.50 ± 0.2% | not timed | not timed | 5.22 ± 0.2% | 0.20 ± 4.7% | not timed | not timed | 3.64 ± 2.2% | | 0.96 | 0.67 | 17.34 |
| 06-cloud-flare-redos/original | 107 | 270.25 ± 0.3% | not timed | not timed | 216.32 ± 0.2% | 24.93 ± 0.1% | not timed | not timed | 269.72 ± 0.2% | | 1.00 | 1.25 | 10.84 |
| 06-cloud-flare-redos/simplified-short | 102 | 264.94 ± 0.8% | not timed | not timed | 227.43 ± 0.1% | 26.74 ± 0.2% | not timed | not timed | 265.21 ± 1.3% | | 1.00 | 1.16 | 9.91 |
| 06-cloud-flare-redos/simplified-long | 10000 | 294.36 ± 0.2% | not timed | not timed | 255.80 ± 0.1% | 28.82 ± 0.1% | not timed | not timed | 294.33 ± 0.1% | | 1.00 | 1.15 | 10.21 |
| 07-unicode-character-data/parse-line | 558784 | 233.70 ± 0.2% | not timed | not timed | 176.26 ± 0.4% | 42.68 ± 14.3% | not timed | not timed | 228.89 ± 17.2% | | 1.02 | 1.33 | 5.48 |
| 08-words/all-english | 56691 | 119.37 ± 0.3% | not timed | not timed | 83.13 ± 0.3% | 12.17 ± 13.8% | not timed | not timed | 118.86 ± 0.3% | | 1.00 | 1.44 | 9.81 |
| 08-words/long-english | 839 | 1005.26 ± 0.1% | not timed | not timed | 597.81 ± 0.2% | 32.36 ± 0.6% | not timed | not timed | 1004.97 ± 0.1% | | 1.00 | 1.68 | 31.06 |
| 09-aws-keys/full | 0 | 412.72 ± 0.4% | not timed | not timed | 471.62 ± 0.3% | 64.57 ± 0.5% | not timed | not timed | 401.04 ± 0.1% | | 1.03 | 0.88 | 6.39 |
| 09-aws-keys/quick | 0 | 741.04 ± 0.1% | not timed | not timed | 1000.15 ± 0.2% | 420.17 ± 0.7% | not timed | not timed | 740.24 ± 0.1% | | 1.00 | 0.74 | 1.76 |
| 10-bounded-repeat/letters-en | 1833 | 634.50 ± 0.5% | not timed | not timed | 516.89 ± 0.7% | 19.55 ± 0.3% | not timed | not timed | 632.79 ± 0.2% | | 1.00 | 1.23 | 32.45 |
| 10-bounded-repeat/letters-ru | 3475 | 380.70 ± 0.2% | not timed | not timed | 478.24 ± 0.2% | 21.71 ± 7.7% | not timed | not timed | 379.23 ± 0.5% | | 1.00 | 0.80 | 17.53 |
| 10-bounded-repeat/context | 53 | 79.05 ± 1.0% | not timed | not timed | 65.78 ± 0.3% | 19.80 ± 0.1% | not timed | not timed | 79.18 ± 1.0% | | 1.00 | 1.20 | 3.99 |
| 10-bounded-repeat/capitals | 11 | 1046.15 ± 0.2% | not timed | not timed | 618.32 ± 0.0% | 36.56 ± 0.1% | not timed | not timed | 1045.80 ± 0.0% | | 1.00 | 1.69 | 28.62 |
| 11-unstructured-to-json/extract | 600 | 47.69 ± 0.2% | not timed | not timed | 76.80 ± 0.4% | 49.07 ± 0.6% | not timed | not timed | 47.57 ± 0.1% | | 1.00 | 0.62 | 0.97 |
| 12-dictionary/single | 1 | 572.86 ± 0.1% | not timed | not timed | 561.46 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 572.84 ± 0.2% | | 1.00 | 1.02 | 1409.10 |
| 14-quadratic/1x | 100 | 12.98 ± 0.1% | not timed | not timed | 10.01 ± 0.1% | 0.97 ± 2.9% | not timed | not timed | 12.96 ± 0.3% | | 1.00 | 1.30 | 13.34 |
| 14-quadratic/2x | 200 | 7.97 ± 0.3% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 2.0% | not timed | not timed | 7.97 ± 0.3% | | 1.00 | 1.44 | 14.92 |
| 14-quadratic/10x | 1000 | 1.86 ± 0.2% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.6% | not timed | not timed | 1.86 ± 1.1% | | 1.00 | 1.53 | 16.10 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.4% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 3.8% | not timed | not timed | 1.44 ± 1.8% | | 1.01 | 4.25 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 92.75 ± 0.1% | not timed | not timed | 13.91 ± 0.1% | 140.32 ± 1.5% | not timed | not timed | 92.10 ± 1.2% | | 1.01 | 6.67 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 14.59 ± 1.3% | not timed | not timed | 2.53 ± 0.5% | 6.43 ± 1.8% | not timed | not timed | 14.55 ± 0.3% | | 1.00 | 5.78 | 2.27 |
| 07-unicode-character-data/compile | 1 | 58.32 ± 0.2% | not timed | not timed | 26.04 ± 0.2% | 35.81 ± 2.2% | not timed | not timed | 58.37 ± 1.2% | | 1.00 | 2.24 | 1.63 |
| 09-aws-keys/compile-full | 1 | 43.58 ± 0.5% | not timed | not timed | 8.30 ± 0.7% | 23.24 ± 1.4% | not timed | not timed | 43.37 ± 0.9% | | 1.00 | 5.25 | 1.87 |
| 09-aws-keys/compile-quick | 1 | 187.92 ± 0.1% | not timed | not timed | 47.90 ± 0.2% | 133.86 ± 1.9% | not timed | not timed | 188.69 ± 0.6% | | 1.00 | 3.92 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.59 ± 0.8% | not timed | not timed | 11.14 ± 0.1% | 15.90 ± 0.9% | not timed | not timed | 14.52 ± 1.2% | | 1.01 | 1.31 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.50 ± 0.6% | not timed | not timed | 8.07 ± 0.2% | 23.28 ± 2.6% | not timed | not timed | 85.62 ± 1.1% | | 1.00 | 10.59 | 3.67 |
| 11-unstructured-to-json/compile | 1 | 90.39 ± 0.2% | not timed | not timed | 40.80 ± 0.5% | 68.96 ± 2.6% | not timed | not timed | 90.37 ± 1.1% | | 1.00 | 2.22 | 1.31 |
| 12-dictionary/compile-single | 1 | 0.36 ± 1.0% | not timed | not timed | 0.07 ± 0.9% | 0.10 ± 9.9% | not timed | not timed | 0.35 ± 1.8% | | 1.01 | 5.18 | 3.75 |

