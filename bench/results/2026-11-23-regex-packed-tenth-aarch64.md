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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102084546 |
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
| literal: a word | 217 | 15804.39 ± 1.5% | 1042.58 ± 0.3% | 27.69 ± 0.2% | 17943.73 ± 1.2% | 8934.96 ± 8.1% | 17.17 ± 0.4% | 86.41 ± 0.1% | 15798.73 ± 1.2% | 15.16 | 1.00 | 0.88 | 1.77 |
| literal: a word that is not there | 0 | 18633.44 ± 3.6% | 1048.48 ± 0.5% | 27.67 ± 0.1% | 19731.35 ± 3.2% | 27997.09 ± 1.3% | 17.02 ± 0.4% | 82.09 ± 0.2% | 18748.51 ± 1.2% | 17.77 | 0.99 | 0.94 | 0.67 |
| literal: one of four words | 661 | 6145.19 ± 0.6% | 1019.60 ± 0.4% | 14.31 ± 0.1% | 3936.73 ± 0.3% | 21.91 ± 0.2% | 5.41 ± 0.2% | 6.92 ± 0.4% | 6124.76 ± 1.9% | 6.03 | 1.00 | 1.56 | 280.51 |
| literal: a word in any case | 217 | 12391.62 ± 1.3% | 1041.71 ± 0.4% | 20.75 ± 0.3% | 3972.54 ± 0.1% | 37.98 ± 1.2% | refused | differs | 12421.28 ± 0.9% | 11.90 | 1.00 | 3.12 | 326.24 |
| literal: an href attribute | 33 | 13646.35 ± 1.9% | 1048.25 ± 0.4% | 26.70 ± 0.1% | 16788.24 ± 1.7% | 2263.47 ± 0.4% | 13.12 ± 0.2% | 75.26 ± 0.1% | 13714.90 ± 1.8% | 13.02 | 1.00 | 0.81 | 6.03 |
| literal: a word, second text | 123 | 16321.85 ± 0.4% | 1048.16 ± 0.3% | 27.37 ± 0.2% | 18076.14 ± 2.9% | 7841.92 ± 6.1% | 20.14 ± 0.2% | 70.35 ± 0.4% | 16375.82 ± 0.9% | 15.57 | 1.00 | 0.90 | 2.08 |
| class: two capitalized words | 1331 | 1102.24 ± 0.4% | 957.42 ± 0.4% | 25.48 ± 0.2% | 585.01 ± 0.1% | 40.68 ± 10.6% | 14.67 ± 0.2% | 68.92 ± 0.7% | 1102.18 ± 0.2% | 1.15 | 1.00 | 1.88 | 27.10 |
| class: a word that ends in ing | 3399 | 879.18 ± 0.1% | 880.42 ± 0.2% | 17.72 ± 0.1% | 546.84 ± 0.1% | 29.64 ± 6.5% | 8.14 ± 0.1% | 18.42 ± 0.2% | 878.14 ± 0.2% | 1.00 | 1.00 | 1.61 | 29.66 |
| class: a word in capitals | 2332 | 1465.00 ± 0.4% | 944.64 ± 0.4% | 27.13 ± 0.3% | 572.21 ± 0.0% | 43.47 ± 13.2% | 17.09 ± 0.2% | 83.22 ± 1.9% | 1467.32 ± 0.5% | 1.55 | 1.00 | 2.56 | 33.70 |
| class: a number | 8288 | 2062.40 ± 0.1% | 792.00 ± 0.1% | 27.21 ± 0.2% | 1723.78 ± 0.2% | 41.33 ± 15.9% | 0.54 ± 0.1% | 56.71 ± 0.6% | 2063.83 ± 0.2% | 2.60 | 1.00 | 1.20 | 49.90 |
| class: two capitalized words, second text | 5359 | 688.94 ± 0.1% | 687.79 ± 0.1% | 22.88 ± 0.1% | 484.95 ± 0.1% | 35.33 ± 6.7% | 17.14 ± 0.3% | 63.95 ± 0.2% | 688.95 ± 0.1% | 1.00 | 1.00 | 1.42 | 19.50 |
| other: a word between two words | 6104 | 777.01 ± 0.1% | 740.99 ± 0.3% | 23.09 ± 0.0% | 735.78 ± 0.2% | 108.29 ± 15.1% | 11.14 ± 0.1% | 69.56 ± 0.1% | 777.48 ± 0.1% | 1.05 | 1.00 | 1.06 | 7.18 |
| other: a number before a unit, second text | 1481 | 5457.79 ± 0.4% | 978.48 ± 0.1% | 25.39 ± 0.2% | 5651.78 ± 0.3% | 40.76 ± 0.2% | 18.16 ± 0.1% | 66.78 ± 0.6% | 5449.46 ± 0.6% | 5.58 | 1.00 | 0.97 | 133.90 |
| other: a heading's start tag | 110 | 12721.82 ± 0.9% | 1031.21 ± 0.2% | 26.81 ± 0.1% | 1707.49 ± 0.1% | 1579.97 ± 6.9% | 15.95 ± 0.3% | 88.92 ± 0.4% | 12709.19 ± 0.6% | 12.34 | 1.00 | 7.45 | 8.05 |
| other: a whole word | 217 | 13840.23 ± 1.1% | 1040.05 ± 1.1% | 28.51 ± 0.6% | 14410.26 ± 1.8% | 49.38 ± 0.3% | 13.06 ± 0.2% | 55.70 ± 0.4% | 13843.59 ± 0.8% | 13.31 | 1.00 | 0.96 | 280.30 |
| other: a line's first word, second text | 3716 | 1947.66 ± 0.5% | 854.59 ± 0.1% | 30.04 ± 0.1% | 1720.79 ± 0.6% | 62.25 ± 4.6% | refused | refused | 1940.80 ± 0.8% | 2.28 | 1.00 | 1.13 | 31.29 |
| other: fourteen octets before an x | 87 | 18854.65 ± 1.3% | 241.44 ± 0.7% | 5.30 ± 0.1% | 4035.47 ± 0.5% | 10.66 ± 0.2% | differs | 17.80 ± 0.2% | 18925.98 ± 1.0% | 78.09 | 1.00 | 4.67 | 1768.55 |
| other: a Greek word | 21815 | 470.18 ± 1.1% | 315.67 ± 0.4% | 30.27 ± 0.2% | 289.61 ± 0.3% | 44.46 ± 9.2% | differs | refused | 468.39 ± 1.0% | 1.49 | 1.00 | 1.62 | 10.57 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 26.02 ± 0.2% | 26.04 ± 0.1% | 0.82 ± 0.4% | 19.85 ± 0.2% | 2.77 ± 0.7% | differs | 4.00 ± 0.2% | 25.97 ± 0.3% | 1.00 | 1.00 | 1.31 | 9.39 |
| a UUID | 32895 | 21.18 ± 0.3% | 21.31 ± 0.2% | 0.64 ± 0.1% | 15.07 ± 0.3% | 2.98 ± 0.3% | 0.73 ± 0.1% | 3.61 ± 0.4% | 21.33 ± 0.3% | 0.99 | 0.99 | 1.41 | 7.10 |
| an IPv4 address | 33176 | 36.88 ± 0.4% | 36.85 ± 0.2% | 2.08 ± 0.2% | 29.43 ± 0.4% | 6.68 ± 0.2% | differs | 4.12 ± 0.2% | 36.89 ± 0.3% | 1.00 | 1.00 | 1.25 | 5.52 |
| a date and time | 32954 | 31.14 ± 0.4% | 31.21 ± 0.2% | 1.45 ± 0.2% | 21.51 ± 0.3% | 7.04 ± 0.2% | 1.25 ± 0.2% | 7.17 ± 0.2% | 31.10 ± 0.4% | 1.00 | 1.00 | 1.45 | 4.42 |
| a field path | 32606 | 29.56 ± 0.2% | 29.50 ± 0.2% | 0.97 ± 0.2% | 23.26 ± 0.3% | 3.52 ± 1.1% | differs | 2.97 ± 0.4% | 29.42 ± 0.4% | 1.00 | 1.00 | 1.27 | 8.40 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 9.03 ± 0.2% | 9.06 ± 0.2% | 9.02 ± 0.4% | 11.57 ± 0.2% | 4.93 ± 1.1% | 0.93 ± 0.5% | none | 9.03 ± 0.2% | 1.00 | 1.00 | 0.78 | 1.83 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 234.95 ± 0.6% | 236.76 ± 0.2% | 288.23 ± 0.2% | 87.00 ± 0.2% | 217.79 ± 8.7% | 484.08 ± 1.0% | 3873.43 ± 1.9% | 234.79 ± 0.1% | 0.99 | 1.00 | 2.70 | 1.08 |
| a UUID | 62 | 157.42 ± 0.5% | 157.88 ± 0.3% | 179.14 ± 0.2% | 45.76 ± 0.2% | 97.31 ± 2.0% | 180.83 ± 1.0% | 4241.38 ± 1.1% | 157.31 ± 0.3% | 1.00 | 1.00 | 3.44 | 1.62 |
| an IPv4 address | 29 | 421.14 ± 0.5% | 424.52 ± 0.5% | 619.35 ± 0.8% | 77.07 ± 0.9% | 130.05 ± 0.9% | 290.19 ± 0.9% | 7563.83 ± 0.5% | 421.57 ± 0.5% | 0.99 | 1.00 | 5.46 | 3.24 |
| a date and time | 56 | 305.77 ± 0.1% | 307.50 ± 0.2% | 397.15 ± 0.3% | 72.66 ± 0.1% | 136.18 ± 0.7% | 318.67 ± 1.2% | 4856.34 ± 0.7% | 305.57 ± 0.2% | 0.99 | 1.00 | 4.21 | 2.25 |
| a field path | 39 | 227.46 ± 0.2% | 228.64 ± 0.3% | 275.62 ± 0.3% | 79.99 ± 0.7% | 202.19 ± 0.8% | 485.66 ± 1.1% | 4892.27 ± 1.5% | 227.45 ± 0.2% | 0.99 | 1.00 | 2.84 | 1.13 |
| literal: a word | 7 | 622.41 ± 0.6% | 667.74 ± 0.6% | 1276.33 ± 0.6% | 515.82 ± 1.6% | 626.48 ± 2.9% | 917.53 ± 0.3% | 29633.95 ± 0.1% | 621.35 ± 0.5% | 0.93 | 1.00 | 1.21 | 0.99 |
| literal: a word that is not there | 8 | 596.96 ± 0.4% | 646.05 ± 0.6% | 1197.37 ± 0.6% | 470.20 ± 0.1% | 602.07 ± 1.9% | 869.37 ± 0.4% | 28595.33 ± 0.1% | 595.51 ± 0.6% | 0.92 | 1.00 | 1.27 | 0.99 |
| literal: one of four words | 26 | 241.15 ± 0.4% | 400.23 ± 0.4% | 567.70 ± 0.5% | 49.65 ± 0.5% | 236.14 ± 8.6% | 353.76 ± 1.3% | 15454.64 ± 0.2% | 241.29 ± 0.4% | 0.60 | 1.00 | 4.86 | 1.02 |
| literal: a word in any case | 11 | 483.35 ± 0.8% | 516.64 ± 0.9% | 847.64 ± 1.4% | 15.82 ± 1.0% | 639.60 ± 2.3% | refused | 23459.85 ± 0.6% | 484.03 ± 0.2% | 0.94 | 1.00 | 30.55 | 0.76 |
| literal: an href attribute | 12 | 350.87 ± 0.8% | 361.85 ± 0.3% | 497.76 ± 0.4% | 45.38 ± 0.4% | 491.29 ± 1.6% | 765.68 ± 1.9% | 21460.55 ± 0.3% | 350.61 ± 0.5% | 0.97 | 1.00 | 7.73 | 0.71 |
| literal: a word, second text | 10 | 559.74 ± 0.9% | 612.93 ± 1.1% | 1085.58 ± 1.2% | 419.20 ± 0.4% | 526.81 ± 1.3% | 795.69 ± 0.5% | 26579.29 ± 0.3% | 560.23 ± 0.4% | 0.91 | 1.00 | 1.34 | 1.06 |
| class: two capitalized words | 23 | 435.76 ± 0.5% | 468.01 ± 0.9% | 709.16 ± 0.5% | 102.07 ± 0.2% | 489.05 ± 10.3% | 736.03 ± 0.5% | 6558.01 ± 0.2% | 435.84 ± 0.3% | 0.93 | 1.00 | 4.27 | 0.89 |
| class: a word that ends in ing | 9 | 556.61 ± 0.5% | 627.23 ± 0.3% | 1178.26 ± 0.2% | 133.49 ± 0.9% | 747.13 ± 1.8% | 1077.77 ± 2.2% | 16012.24 ± 0.1% | 556.11 ± 0.3% | 0.89 | 1.00 | 4.17 | 0.74 |
| class: a word in capitals | 16 | 491.60 ± 0.2% | 533.51 ± 0.3% | 916.18 ± 0.3% | 136.65 ± 0.9% | 745.32 ± 1.2% | 1009.83 ± 1.0% | 8622.54 ± 0.1% | 492.06 ± 0.6% | 0.92 | 1.00 | 3.60 | 0.66 |
| class: a number | 6 | 611.97 ± 0.4% | 682.22 ± 0.1% | 1390.31 ± 0.1% | 42.12 ± 0.5% | 1403.82 ± 0.6% | 1921.95 ± 1.5% | 22403.92 ± 0.1% | 611.06 ± 0.7% | 0.90 | 1.00 | 14.53 | 0.44 |
| class: two capitalized words, second text | 23 | 436.04 ± 0.3% | 467.86 ± 0.4% | 711.06 ± 0.5% | 103.67 ± 0.2% | 497.10 ± 3.2% | 737.55 ± 0.6% | 6566.13 ± 0.2% | 436.54 ± 0.4% | 0.93 | 1.00 | 4.21 | 0.88 |
| other: a word between two words | 13 | 550.88 ± 0.7% | 568.24 ± 0.3% | 958.73 ± 0.8% | 136.72 ± 0.5% | 496.40 ± 1.3% | 811.12 ± 0.6% | 14765.80 ± 0.4% | 550.70 ± 0.5% | 0.97 | 1.00 | 4.03 | 1.11 |
| other: a number before a unit, second text | 15 | 406.31 ± 0.4% | 446.90 ± 0.4% | 658.04 ± 0.2% | 39.47 ± 0.5% | 627.46 ± 0.8% | 892.78 ± 0.6% | 15086.49 ± 0.7% | 406.41 ± 0.2% | 0.91 | 1.00 | 10.30 | 0.65 |
| other: a heading's start tag | 13 | 359.90 ± 0.3% | 365.97 ± 0.3% | 502.42 ± 0.3% | 43.62 ± 0.3% | 625.60 ± 0.9% | 856.39 ± 0.2% | 17960.89 ± 0.3% | 359.16 ± 0.4% | 0.98 | 1.00 | 8.25 | 0.58 |
| other: a whole word | 11 | 581.97 ± 0.4% | 616.29 ± 0.3% | 1095.63 ± 0.4% | 121.19 ± 0.4% | 567.24 ± 2.0% | 819.16 ± 0.6% | 26666.14 ± 0.6% | 581.42 ± 0.4% | 0.94 | 1.00 | 4.80 | 1.03 |
| other: a line's first word, second text | 17 | 533.49 ± 0.1% | 551.00 ± 0.4% | 943.96 ± 0.3% | 128.92 ± 0.2% | 698.67 ± 9.5% | refused | refused | 532.17 ± 0.5% | 0.97 | 1.00 | 4.14 | 0.76 |
| other: fourteen octets before an x | 16 | 111.78 ± 0.6% | 160.95 ± 1.2% | 190.40 ± 0.6% | 14.98 ± 0.3% | 449.66 ± 8.6% | 417.27 ± 0.5% | 12450.94 ± 2.8% | 111.96 ± 0.5% | 0.69 | 1.00 | 7.46 | 0.25 |
| other: a Greek word | 8 | 422.88 ± 0.5% | 586.00 ± 0.3% | 1062.99 ± 0.1% | 58.84 ± 0.4% | 1380.51 ± 1.6% | 1832.58 ± 0.9% | refused | 423.82 ± 0.5% | 0.72 | 1.00 | 7.19 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12699.45 ± 0.6% | not timed | not timed | 16070.71 ± 1.3% | 2156.43 ± 16.4% | not timed | not timed | 12697.66 ± 0.7% | | 1.00 | 0.79 | 5.89 |
| 01-literal/sherlock-casei-en | 522 | 3946.11 ± 0.5% | not timed | not timed | 3587.52 ± 0.2% | 32.48 ± 0.3% | not timed | not timed | 3940.32 ± 0.3% | | 1.00 | 1.10 | 121.51 |
| 01-literal/sherlock-ru | 724 | 13548.05 ± 0.3% | not timed | not timed | 17228.04 ± 0.5% | 1501.78 ± 11.0% | not timed | not timed | 13523.13 ± 0.3% | | 1.00 | 0.79 | 9.02 |
| 01-literal/sherlock-casei-ru | 746 | 5392.75 ± 0.6% | not timed | not timed | 3325.76 ± 0.2% | 30.77 ± 0.2% | not timed | not timed | 5391.37 ± 0.2% | | 1.00 | 1.62 | 175.27 |
| 01-literal/sherlock-zh | 30 | 16782.55 ± 0.8% | not timed | not timed | 18293.40 ± 1.1% | 2667.64 ± 4.9% | not timed | not timed | 16793.47 ± 0.7% | | 1.00 | 0.92 | 6.29 |
| 02-literal-alternate/sherlock-en | 714 | 5908.11 ± 0.3% | not timed | not timed | 3932.40 ± 0.2% | 16.65 ± 0.1% | not timed | not timed | 5903.12 ± 0.3% | | 1.00 | 1.50 | 354.81 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1706.44 ± 0.9% | not timed | not timed | 698.85 ± 0.4% | 11.05 ± 0.2% | not timed | not timed | 1696.82 ± 0.4% | | 1.01 | 2.44 | 154.39 |
| 02-literal-alternate/sherlock-ru | 899 | 4796.99 ± 0.3% | not timed | not timed | 3253.16 ± 0.2% | 22.66 ± 0.1% | not timed | not timed | 4797.76 ± 0.2% | | 1.00 | 1.47 | 211.67 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1821.81 ± 0.9% | not timed | not timed | 1231.64 ± 0.8% | 9.09 ± 1.0% | not timed | not timed | 1812.86 ± 0.3% | | 1.00 | 1.48 | 200.42 |
| 02-literal-alternate/sherlock-zh | 207 | 7088.08 ± 0.8% | not timed | not timed | 4163.93 ± 0.2% | 31.49 ± 0.1% | not timed | not timed | 7087.76 ± 0.7% | | 1.00 | 1.70 | 225.09 |
| 03-date/ascii | 111817 | 123.98 ± 0.1% | not timed | not timed | 95.86 ± 0.1% | 0.20 ± 3.8% | not timed | not timed | 122.39 ± 0.5% | | 1.01 | 1.29 | 612.32 |
| 04-ruff-noqa/real | 84 | 551.20 ± 0.1% | not timed | not timed | 479.01 ± 0.1% | 19.66 ± 1.4% | not timed | not timed | 552.59 ± 0.2% | | 1.00 | 1.15 | 28.04 |
| 04-ruff-noqa/tweaked | 44 | 552.94 ± 0.5% | not timed | not timed | 461.38 ± 0.1% | 364.20 ± 0.5% | not timed | not timed | 552.39 ± 0.4% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 3.52 ± 0.2% | not timed | not timed | 5.16 ± 0.2% | 0.20 ± 4.3% | not timed | not timed | 3.61 ± 0.9% | | 0.97 | 0.68 | 17.34 |
| 06-cloud-flare-redos/original | 107 | 183.81 ± 0.2% | not timed | not timed | 217.12 ± 0.0% | 24.83 ± 0.1% | not timed | not timed | 182.88 ± 0.3% | | 1.01 | 0.85 | 7.40 |
| 06-cloud-flare-redos/simplified-short | 102 | 142.51 ± 1.1% | not timed | not timed | 227.39 ± 0.1% | 26.60 ± 0.3% | not timed | not timed | 144.51 ± 1.4% | | 0.99 | 0.63 | 5.36 |
| 06-cloud-flare-redos/simplified-long | 10000 | 157.07 ± 1.6% | not timed | not timed | 255.14 ± 0.4% | 28.86 ± 0.1% | not timed | not timed | 156.93 ± 1.8% | | 1.00 | 0.62 | 5.44 |
| 07-unicode-character-data/parse-line | 558784 | 40.04 ± 0.2% | not timed | not timed | 179.60 ± 0.1% | 42.46 ± 5.8% | not timed | not timed | 40.00 ± 0.7% | | 1.00 | 0.22 | 0.94 |
| 08-words/all-english | 56691 | 103.23 ± 0.2% | not timed | not timed | 82.98 ± 0.1% | 12.78 ± 13.5% | not timed | not timed | 102.34 ± 0.4% | | 1.01 | 1.24 | 8.08 |
| 08-words/long-english | 839 | 997.69 ± 0.2% | not timed | not timed | 595.55 ± 0.1% | 32.63 ± 0.2% | not timed | not timed | 997.77 ± 0.4% | | 1.00 | 1.68 | 30.57 |
| 09-aws-keys/full | 0 | 421.50 ± 0.1% | not timed | not timed | 493.81 ± 0.1% | 64.64 ± 3.2% | not timed | not timed | 421.32 ± 0.0% | | 1.00 | 0.85 | 6.52 |
| 09-aws-keys/quick | 0 | 413.77 ± 0.0% | not timed | not timed | 998.29 ± 0.3% | 420.10 ± 0.9% | not timed | not timed | 410.20 ± 0.1% | | 1.01 | 0.41 | 0.98 |
| 10-bounded-repeat/letters-en | 1833 | 592.55 ± 0.2% | not timed | not timed | 517.78 ± 0.1% | 19.49 ± 0.6% | not timed | not timed | 590.56 ± 0.4% | | 1.00 | 1.14 | 30.41 |
| 10-bounded-repeat/letters-ru | 3475 | 403.76 ± 0.3% | not timed | not timed | 479.41 ± 0.1% | 21.83 ± 15.9% | not timed | not timed | 402.39 ± 4.0% | | 1.00 | 0.84 | 18.49 |
| 10-bounded-repeat/context | 53 | 73.06 ± 0.9% | not timed | not timed | 65.72 ± 2.2% | 19.84 ± 0.2% | not timed | not timed | 73.25 ± 1.2% | | 1.00 | 1.11 | 3.68 |
| 10-bounded-repeat/capitals | 11 | 1039.78 ± 0.1% | not timed | not timed | 618.29 ± 0.0% | 36.61 ± 0.2% | not timed | not timed | 1039.29 ± 0.1% | | 1.00 | 1.68 | 28.40 |
| 11-unstructured-to-json/extract | 600 | 24.57 ± 0.1% | not timed | not timed | 76.80 ± 0.4% | 48.82 ± 0.5% | not timed | not timed | 24.51 ± 0.4% | | 1.00 | 0.32 | 0.50 |
| 12-dictionary/single | 1 | 599.69 ± 0.4% | not timed | not timed | 558.74 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 601.20 ± 0.2% | | 1.00 | 1.07 | 1495.38 |
| 14-quadratic/1x | 100 | 12.63 ± 0.7% | not timed | not timed | 10.05 ± 0.1% | 0.98 ± 3.3% | not timed | not timed | 12.56 ± 0.9% | | 1.01 | 1.26 | 12.88 |
| 14-quadratic/2x | 200 | 7.78 ± 0.7% | not timed | not timed | 5.52 ± 0.1% | 0.53 ± 2.1% | not timed | not timed | 7.78 ± 0.6% | | 1.00 | 1.41 | 14.69 |
| 14-quadratic/10x | 1000 | 1.83 ± 0.4% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 0.2% | not timed | not timed | 1.83 ± 2.1% | | 1.00 | 1.51 | 16.01 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.42 ± 0.2% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 2.4% | not timed | not timed | 1.41 ± 1.1% | | 1.00 | 4.14 | 2.58 |
| 04-ruff-noqa/compile-real | 1 | 92.86 ± 0.2% | not timed | not timed | 13.78 ± 0.1% | 138.15 ± 2.9% | not timed | not timed | 92.84 ± 1.3% | | 1.00 | 6.74 | 0.67 |
| 05-lexer-veryl/compile-single | 1 | 14.57 ± 0.1% | not timed | not timed | 2.52 ± 1.0% | 6.42 ± 1.6% | not timed | not timed | 14.52 ± 1.5% | | 1.00 | 5.78 | 2.27 |
| 07-unicode-character-data/compile | 1 | 58.45 ± 0.1% | not timed | not timed | 25.94 ± 0.1% | 35.37 ± 6.2% | not timed | not timed | 58.13 ± 1.3% | | 1.01 | 2.25 | 1.65 |
| 09-aws-keys/compile-full | 1 | 43.68 ± 0.1% | not timed | not timed | 8.20 ± 0.4% | 22.98 ± 1.6% | not timed | not timed | 43.54 ± 0.2% | | 1.00 | 5.33 | 1.90 |
| 09-aws-keys/compile-quick | 1 | 187.83 ± 0.2% | not timed | not timed | 47.50 ± 0.2% | 133.02 ± 3.7% | not timed | not timed | 187.94 ± 0.8% | | 1.00 | 3.95 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 14.67 ± 1.3% | not timed | not timed | 11.06 ± 0.6% | 15.90 ± 1.1% | not timed | not timed | 14.50 ± 1.9% | | 1.01 | 1.33 | 0.92 |
| 10-bounded-repeat/compile-capitals | 1 | 85.17 ± 0.4% | not timed | not timed | 7.95 ± 0.2% | 23.55 ± 1.8% | not timed | not timed | 85.19 ± 0.6% | | 1.00 | 10.71 | 3.62 |
| 11-unstructured-to-json/compile | 1 | 90.88 ± 0.2% | not timed | not timed | 41.41 ± 0.5% | 68.02 ± 3.3% | not timed | not timed | 90.55 ± 1.1% | | 1.00 | 2.19 | 1.34 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.7% | not timed | not timed | 0.07 ± 1.5% | 0.10 ± 13.2% | not timed | not timed | 0.35 ± 1.1% | | 1.01 | 5.28 | 3.75 |

