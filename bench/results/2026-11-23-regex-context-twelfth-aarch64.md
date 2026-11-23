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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45117681182 |
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
| literal: a word | 217 | 16204.94 ± 0.5% | 1036.31 ± 0.5% | 28.24 ± 0.3% | 18211.25 ± 1.0% | 9201.37 ± 9.1% | 17.31 ± 0.2% | 86.71 ± 0.1% | 16239.21 ± 0.7% | 15.64 | 1.00 | 0.89 | 1.76 |
| literal: a word that is not there | 0 | 18896.68 ± 0.9% | 1047.89 ± 0.1% | 28.31 ± 0.3% | 19927.12 ± 1.6% | 29292.71 ± 0.9% | 17.08 ± 0.1% | 82.70 ± 0.2% | 18863.17 ± 1.2% | 18.03 | 1.00 | 0.95 | 0.65 |
| literal: one of four words | 661 | 6084.73 ± 0.3% | 1014.78 ± 0.2% | 14.55 ± 0.3% | 3942.87 ± 0.2% | 21.88 ± 0.1% | 5.42 ± 0.3% | 6.96 ± 0.3% | 6076.08 ± 0.3% | 6.00 | 1.00 | 1.54 | 278.12 |
| literal: a word in any case | 217 | 12614.57 ± 0.7% | 1037.82 ± 0.1% | 21.64 ± 0.7% | 3970.91 ± 0.3% | 38.10 ± 0.3% | refused | differs | 12575.91 ± 0.2% | 12.15 | 1.00 | 3.18 | 331.12 |
| literal: an href attribute | 33 | 13939.81 ± 0.8% | 1046.21 ± 0.1% | 27.08 ± 0.2% | 17120.83 ± 1.0% | 2249.18 ± 0.6% | 13.09 ± 0.1% | 75.76 ± 0.5% | 13935.96 ± 0.7% | 13.32 | 1.00 | 0.81 | 6.20 |
| literal: a word, second text | 123 | 16601.37 ± 0.2% | 1042.18 ± 0.1% | 28.01 ± 0.2% | 18470.79 ± 0.6% | 7725.83 ± 6.4% | 20.03 ± 0.3% | 70.74 ± 0.4% | 16564.37 ± 0.7% | 15.93 | 1.00 | 0.90 | 2.15 |
| class: two capitalized words | 1331 | 1126.12 ± 0.5% | 953.96 ± 0.1% | 25.94 ± 0.3% | 585.12 ± 0.1% | 40.69 ± 12.3% | 14.65 ± 0.2% | 68.96 ± 0.6% | 1123.08 ± 0.3% | 1.18 | 1.00 | 1.92 | 27.68 |
| class: a word that ends in ing | 3399 | 877.01 ± 0.1% | 877.18 ± 0.1% | 17.99 ± 0.2% | 547.89 ± 0.1% | 29.64 ± 2.9% | 8.19 ± 0.1% | 18.37 ± 1.2% | 876.46 ± 0.2% | 1.00 | 1.00 | 1.60 | 29.59 |
| class: a word in capitals | 2332 | 1476.86 ± 0.5% | 937.33 ± 0.1% | 27.57 ± 0.3% | 572.75 ± 0.1% | 43.51 ± 6.2% | 17.04 ± 0.4% | 83.33 ± 0.4% | 1475.96 ± 0.3% | 1.58 | 1.00 | 2.58 | 33.94 |
| class: a number | 8288 | 2001.29 ± 0.2% | 786.88 ± 0.2% | 27.69 ± 0.2% | 1731.75 ± 0.2% | 41.18 ± 11.7% | 0.55 ± 0.2% | 57.06 ± 0.3% | 1987.93 ± 0.2% | 2.54 | 1.01 | 1.16 | 48.60 |
| class: two capitalized words, second text | 5359 | 680.34 ± 0.2% | 679.75 ± 0.0% | 23.25 ± 0.2% | 484.76 ± 0.1% | 32.82 ± 13.8% | 17.10 ± 0.3% | 64.13 ± 0.1% | 683.56 ± 0.2% | 1.00 | 1.00 | 1.40 | 20.73 |
| other: a word between two words | 6104 | 767.69 ± 0.4% | 739.36 ± 0.1% | 23.40 ± 0.2% | 736.39 ± 0.2% | 108.42 ± 17.2% | 11.15 ± 0.2% | 69.94 ± 0.2% | 766.54 ± 0.2% | 1.04 | 1.00 | 1.04 | 7.08 |
| other: a number before a unit, second text | 1481 | 5597.47 ± 1.0% | 972.75 ± 0.1% | 25.79 ± 0.1% | 5695.51 ± 0.3% | 40.92 ± 0.2% | 18.19 ± 0.1% | 66.92 ± 0.3% | 5594.70 ± 0.6% | 5.75 | 1.00 | 0.98 | 136.78 |
| other: a heading's start tag | 110 | 12734.81 ± 0.3% | 1035.37 ± 0.2% | 27.26 ± 0.3% | 1710.59 ± 0.4% | 1561.79 ± 3.0% | 16.06 ± 0.3% | 88.81 ± 0.4% | 12724.02 ± 0.7% | 12.30 | 1.00 | 7.44 | 8.15 |
| other: a whole word | 217 | 14089.45 ± 0.5% | 1036.39 ± 0.2% | 29.14 ± 0.7% | 14617.94 ± 0.5% | 49.46 ± 0.1% | 13.14 ± 0.1% | 56.34 ± 0.2% | 14087.44 ± 0.3% | 13.59 | 1.00 | 0.96 | 284.89 |
| other: a line's first word, second text | 3716 | 1979.25 ± 0.4% | 856.52 ± 0.1% | 30.80 ± 0.4% | 1723.18 ± 1.0% | 62.04 ± 7.9% | refused | refused | 1971.90 ± 0.3% | 2.31 | 1.00 | 1.15 | 31.90 |
| other: fourteen octets before an x | 87 | 19906.30 ± 1.3% | 245.10 ± 0.5% | 6.10 ± 0.1% | 4005.56 ± 0.4% | 10.63 ± 0.4% | differs | 17.81 ± 0.1% | 19900.17 ± 1.1% | 81.22 | 1.00 | 4.97 | 1872.45 |
| other: a Greek word | 21815 | 486.65 ± 0.5% | 308.73 ± 0.3% | 30.77 ± 0.4% | 289.03 ± 0.1% | 47.78 ± 9.0% | differs | refused | 484.27 ± 0.7% | 1.58 | 1.00 | 1.68 | 10.18 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.87 ± 0.1% | 25.90 ± 0.2% | 0.82 ± 0.5% | 19.91 ± 0.2% | 2.76 ± 0.3% | differs | 3.98 ± 0.4% | 25.88 ± 0.1% | 1.00 | 1.00 | 1.30 | 9.37 |
| a UUID | 32895 | 21.15 ± 0.3% | 21.22 ± 0.3% | 0.65 ± 0.1% | 15.12 ± 0.4% | 3.11 ± 0.1% | 0.73 ± 0.6% | 3.60 ± 0.7% | 21.15 ± 0.4% | 1.00 | 1.00 | 1.40 | 6.80 |
| an IPv4 address | 33176 | 36.82 ± 0.2% | 36.86 ± 0.2% | 2.11 ± 0.3% | 29.47 ± 0.3% | 6.66 ± 0.1% | differs | 4.14 ± 0.2% | 36.87 ± 0.3% | 1.00 | 1.00 | 1.25 | 5.53 |
| a date and time | 32954 | 31.08 ± 0.3% | 31.09 ± 0.6% | 1.47 ± 0.1% | 21.56 ± 0.3% | 7.07 ± 0.1% | 1.25 ± 0.4% | 7.15 ± 0.3% | 31.10 ± 0.3% | 1.00 | 1.00 | 1.44 | 4.39 |
| a field path | 32606 | 29.40 ± 0.2% | 29.38 ± 0.2% | 1.01 ± 0.4% | 23.36 ± 0.1% | 3.48 ± 0.7% | differs | 2.98 ± 0.2% | 29.40 ± 0.3% | 1.00 | 1.00 | 1.26 | 8.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.64 ± 1.1% | 11.66 ± 0.4% | 11.64 ± 0.3% | 11.84 ± 0.2% | 4.94 ± 1.4% | 0.93 ± 0.7% | none | 11.66 ± 0.5% | 1.00 | 1.00 | 0.98 | 2.36 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 235.91 ± 0.2% | 237.48 ± 0.2% | 287.04 ± 0.3% | 86.07 ± 0.5% | 220.10 ± 1.6% | 483.92 ± 1.0% | 3871.66 ± 1.5% | 235.92 ± 0.4% | 0.99 | 1.00 | 2.74 | 1.07 |
| a UUID | 62 | 157.24 ± 0.4% | 157.70 ± 0.3% | 178.41 ± 0.1% | 46.30 ± 0.8% | 98.42 ± 0.6% | 187.72 ± 3.4% | 4408.02 ± 1.7% | 157.06 ± 0.4% | 1.00 | 1.00 | 3.40 | 1.60 |
| an IPv4 address | 29 | 425.85 ± 0.3% | 430.68 ± 0.3% | 618.13 ± 0.5% | 76.47 ± 0.3% | 130.58 ± 1.8% | 298.00 ± 2.0% | 7636.93 ± 0.3% | 425.20 ± 0.5% | 0.99 | 1.00 | 5.57 | 3.26 |
| a date and time | 56 | 307.41 ± 0.5% | 310.03 ± 0.2% | 396.34 ± 0.1% | 72.39 ± 0.5% | 136.74 ± 1.0% | 327.40 ± 0.5% | 4904.00 ± 0.7% | 307.42 ± 0.2% | 0.99 | 1.00 | 4.25 | 2.25 |
| a field path | 39 | 226.86 ± 0.1% | 228.13 ± 0.4% | 272.84 ± 0.6% | 80.05 ± 1.1% | 202.28 ± 1.4% | 503.54 ± 3.1% | 4897.53 ± 1.5% | 226.54 ± 0.3% | 0.99 | 1.00 | 2.83 | 1.12 |
| literal: a word | 7 | 639.10 ± 0.7% | 685.49 ± 0.7% | 1293.68 ± 0.2% | 508.72 ± 0.2% | 629.20 ± 1.2% | 954.63 ± 0.2% | 30477.79 ± 0.1% | 639.73 ± 0.5% | 0.93 | 1.00 | 1.26 | 1.02 |
| literal: a word that is not there | 8 | 613.58 ± 0.3% | 664.43 ± 0.3% | 1217.97 ± 0.3% | 468.52 ± 0.2% | 607.57 ± 2.3% | 909.08 ± 0.4% | 29141.57 ± 0.1% | 613.36 ± 0.3% | 0.92 | 1.00 | 1.31 | 1.01 |
| literal: one of four words | 26 | 244.18 ± 0.3% | 407.89 ± 0.3% | 571.51 ± 0.3% | 49.84 ± 0.8% | 240.92 ± 1.7% | 378.47 ± 1.5% | 15637.80 ± 0.2% | 244.45 ± 0.3% | 0.60 | 1.00 | 4.90 | 1.01 |
| literal: a word in any case | 11 | 494.57 ± 0.3% | 527.75 ± 0.5% | 851.51 ± 0.1% | 15.45 ± 1.3% | 648.66 ± 0.8% | refused | 23731.80 ± 0.4% | 493.94 ± 0.4% | 0.94 | 1.00 | 32.01 | 0.76 |
| literal: an href attribute | 12 | 352.79 ± 0.3% | 366.06 ± 0.1% | 495.11 ± 0.3% | 45.21 ± 0.6% | 498.73 ± 1.3% | 774.07 ± 0.9% | 21663.33 ± 0.1% | 353.01 ± 0.3% | 0.96 | 1.00 | 7.80 | 0.71 |
| literal: a word, second text | 10 | 570.41 ± 0.6% | 628.66 ± 0.6% | 1094.70 ± 0.2% | 392.17 ± 0.3% | 535.75 ± 2.6% | 806.39 ± 0.4% | 27120.62 ± 0.1% | 571.00 ± 0.6% | 0.91 | 1.00 | 1.45 | 1.06 |
| class: two capitalized words | 23 | 443.90 ± 0.4% | 472.33 ± 0.4% | 710.03 ± 0.6% | 99.18 ± 0.1% | 507.13 ± 1.6% | 743.21 ± 0.3% | 6596.14 ± 0.2% | 444.36 ± 0.3% | 0.94 | 1.00 | 4.48 | 0.88 |
| class: a word that ends in ing | 9 | 575.19 ± 0.1% | 643.31 ± 0.4% | 1175.53 ± 0.2% | 131.17 ± 1.9% | 759.05 ± 10.6% | 1095.98 ± 0.3% | 16132.13 ± 0.4% | 575.25 ± 0.5% | 0.89 | 1.00 | 4.39 | 0.76 |
| class: a word in capitals | 16 | 507.32 ± 0.3% | 545.14 ± 0.3% | 906.64 ± 0.3% | 134.61 ± 0.9% | 755.80 ± 0.9% | 1022.77 ± 1.0% | 8696.34 ± 0.1% | 507.43 ± 0.2% | 0.93 | 1.00 | 3.77 | 0.67 |
| class: a number | 6 | 636.96 ± 0.2% | 702.51 ± 0.2% | 1385.85 ± 0.1% | 41.64 ± 0.7% | 1389.70 ± 2.1% | 1892.28 ± 1.3% | 22825.15 ± 0.1% | 638.47 ± 0.6% | 0.91 | 1.00 | 15.30 | 0.46 |
| class: two capitalized words, second text | 23 | 443.63 ± 0.5% | 472.03 ± 0.9% | 710.06 ± 0.3% | 100.49 ± 0.4% | 495.27 ± 1.5% | 766.87 ± 0.5% | 6584.57 ± 0.9% | 444.05 ± 0.2% | 0.94 | 1.00 | 4.41 | 0.90 |
| other: a word between two words | 13 | 563.21 ± 0.3% | 580.86 ± 0.3% | 968.03 ± 0.1% | 132.62 ± 0.5% | 499.46 ± 2.1% | 815.53 ± 0.6% | 14936.32 ± 0.1% | 563.07 ± 0.4% | 0.97 | 1.00 | 4.25 | 1.13 |
| other: a number before a unit, second text | 15 | 410.97 ± 0.5% | 449.80 ± 0.2% | 651.87 ± 0.3% | 39.40 ± 0.3% | 630.55 ± 1.4% | 890.89 ± 1.0% | 15182.97 ± 0.6% | 410.79 ± 0.2% | 0.91 | 1.00 | 10.43 | 0.65 |
| other: a heading's start tag | 13 | 361.74 ± 0.2% | 366.98 ± 0.2% | 498.36 ± 0.2% | 43.66 ± 0.3% | 629.65 ± 2.2% | 879.38 ± 1.0% | 18094.61 ± 0.4% | 361.41 ± 0.3% | 0.99 | 1.00 | 8.29 | 0.57 |
| other: a whole word | 11 | 596.13 ± 0.6% | 633.58 ± 0.4% | 1099.26 ± 0.3% | 117.07 ± 0.6% | 561.47 ± 2.0% | 834.54 ± 0.8% | 26948.13 ± 0.2% | 596.37 ± 0.2% | 0.94 | 1.00 | 5.09 | 1.06 |
| other: a line's first word, second text | 17 | 543.90 ± 0.5% | 564.64 ± 0.2% | 948.25 ± 0.6% | 128.70 ± 0.1% | 707.44 ± 1.1% | refused | refused | 540.86 ± 0.5% | 0.96 | 1.01 | 4.23 | 0.77 |
| other: fourteen octets before an x | 16 | 111.92 ± 0.6% | 162.70 ± 0.8% | 189.43 ± 1.1% | 15.06 ± 0.3% | 448.24 ± 1.3% | 403.92 ± 0.7% | 12666.06 ± 0.2% | 111.82 ± 1.1% | 0.69 | 1.00 | 7.43 | 0.25 |
| other: a Greek word | 8 | 434.12 ± 0.7% | 598.07 ± 0.2% | 1053.35 ± 0.1% | 58.84 ± 0.5% | 1380.58 ± 1.0% | 1844.86 ± 0.8% | refused | 434.05 ± 0.1% | 0.73 | 1.00 | 7.38 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 12991.31 ± 0.3% | not timed | not timed | 16572.20 ± 1.3% | 1994.95 ± 22.5% | not timed | not timed | 12967.11 ± 0.5% | | 1.00 | 0.78 | 6.51 |
| 01-literal/sherlock-casei-en | 522 | 3913.70 ± 0.7% | not timed | not timed | 3591.81 ± 0.2% | 32.42 ± 0.2% | not timed | not timed | 3912.72 ± 0.4% | | 1.00 | 1.09 | 120.72 |
| 01-literal/sherlock-ru | 724 | 13619.09 ± 0.5% | not timed | not timed | 17288.75 ± 0.2% | 1433.76 ± 8.4% | not timed | not timed | 13585.52 ± 0.7% | | 1.00 | 0.79 | 9.50 |
| 01-literal/sherlock-casei-ru | 746 | 5301.95 ± 0.6% | not timed | not timed | 3333.05 ± 0.3% | 30.66 ± 0.9% | not timed | not timed | 5301.21 ± 0.6% | | 1.00 | 1.59 | 172.90 |
| 01-literal/sherlock-zh | 30 | 17154.50 ± 0.6% | not timed | not timed | 18718.84 ± 1.1% | 2712.36 ± 26.0% | not timed | not timed | 17167.30 ± 0.4% | | 1.00 | 0.92 | 6.32 |
| 02-literal-alternate/sherlock-en | 714 | 5814.15 ± 0.2% | not timed | not timed | 3940.91 ± 0.2% | 16.62 ± 0.1% | not timed | not timed | 5814.63 ± 0.1% | | 1.00 | 1.48 | 349.79 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1680.51 ± 1.0% | not timed | not timed | 694.71 ± 0.3% | 11.04 ± 0.1% | not timed | not timed | 1673.09 ± 0.5% | | 1.00 | 2.42 | 152.18 |
| 02-literal-alternate/sherlock-ru | 899 | 4723.25 ± 0.5% | not timed | not timed | 3254.61 ± 0.2% | 22.70 ± 0.1% | not timed | not timed | 4724.37 ± 0.2% | | 1.00 | 1.45 | 208.08 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1796.38 ± 0.8% | not timed | not timed | 1229.10 ± 0.4% | 9.07 ± 0.2% | not timed | not timed | 1791.23 ± 0.3% | | 1.00 | 1.46 | 198.10 |
| 02-literal-alternate/sherlock-zh | 207 | 7063.98 ± 0.5% | not timed | not timed | 4159.90 ± 0.2% | 31.56 ± 8.6% | not timed | not timed | 7072.56 ± 0.5% | | 1.00 | 1.70 | 223.80 |
| 03-date/ascii | 111817 | 124.04 ± 0.8% | not timed | not timed | 96.27 ± 0.0% | 0.20 ± 6.5% | not timed | not timed | 122.37 ± 0.8% | | 1.01 | 1.29 | 607.73 |
| 04-ruff-noqa/real | 84 | 555.89 ± 0.1% | not timed | not timed | 477.98 ± 0.2% | 19.51 ± 1.0% | not timed | not timed | 555.06 ± 0.1% | | 1.00 | 1.16 | 28.50 |
| 04-ruff-noqa/tweaked | 44 | 559.30 ± 0.2% | not timed | not timed | 467.29 ± 0.1% | 365.82 ± 0.2% | not timed | not timed | 558.26 ± 0.1% | | 1.00 | 1.20 | 1.53 |
| 05-lexer-veryl/single | 124800 | 3.51 ± 0.4% | not timed | not timed | 5.23 ± 0.0% | 0.20 ± 3.2% | not timed | not timed | 3.60 ± 0.3% | | 0.98 | 0.67 | 17.22 |
| 06-cloud-flare-redos/original | 107 | 184.89 ± 0.5% | not timed | not timed | 217.94 ± 0.6% | 24.96 ± 0.1% | not timed | not timed | 183.14 ± 0.3% | | 1.01 | 0.85 | 7.41 |
| 06-cloud-flare-redos/simplified-short | 102 | 142.55 ± 0.2% | not timed | not timed | 228.19 ± 0.2% | 26.66 ± 0.2% | not timed | not timed | 144.79 ± 0.4% | | 0.98 | 0.62 | 5.35 |
| 06-cloud-flare-redos/simplified-long | 10000 | 154.85 ± 2.5% | not timed | not timed | 256.11 ± 0.2% | 28.86 ± 0.2% | not timed | not timed | 154.64 ± 2.0% | | 1.00 | 0.60 | 5.37 |
| 07-unicode-character-data/parse-line | 558784 | 231.28 ± 0.4% | not timed | not timed | 180.02 ± 0.1% | 42.64 ± 5.9% | not timed | not timed | 231.95 ± 1.9% | | 1.00 | 1.28 | 5.42 |
| 08-words/all-english | 56691 | 103.28 ± 0.3% | not timed | not timed | 83.02 ± 0.1% | 11.81 ± 5.1% | not timed | not timed | 102.43 ± 0.4% | | 1.01 | 1.24 | 8.74 |
| 08-words/long-english | 839 | 999.26 ± 0.1% | not timed | not timed | 596.29 ± 0.1% | 32.51 ± 8.0% | not timed | not timed | 998.82 ± 0.3% | | 1.00 | 1.68 | 30.74 |
| 09-aws-keys/full | 0 | 424.15 ± 0.3% | not timed | not timed | 490.58 ± 0.3% | 64.30 ± 3.5% | not timed | not timed | 424.64 ± 0.1% | | 1.00 | 0.86 | 6.60 |
| 09-aws-keys/quick | 0 | 743.94 ± 0.1% | not timed | not timed | 973.76 ± 0.3% | 418.69 ± 2.1% | not timed | not timed | 740.99 ± 0.1% | | 1.00 | 0.76 | 1.78 |
| 10-bounded-repeat/letters-en | 1833 | 586.85 ± 0.2% | not timed | not timed | 517.06 ± 0.6% | 19.58 ± 0.3% | not timed | not timed | 583.62 ± 0.2% | | 1.01 | 1.13 | 29.98 |
| 10-bounded-repeat/letters-ru | 3475 | 401.46 ± 0.2% | not timed | not timed | 481.05 ± 0.1% | 21.82 ± 10.5% | not timed | not timed | 400.72 ± 1.6% | | 1.00 | 0.83 | 18.40 |
| 10-bounded-repeat/context | 53 | 79.76 ± 2.1% | not timed | not timed | 66.29 ± 0.6% | 19.79 ± 0.5% | not timed | not timed | 79.83 ± 0.5% | | 1.00 | 1.20 | 4.03 |
| 10-bounded-repeat/capitals | 11 | 1046.95 ± 0.2% | not timed | not timed | 618.14 ± 0.1% | 36.57 ± 0.1% | not timed | not timed | 1045.89 ± 0.1% | | 1.00 | 1.69 | 28.63 |
| 11-unstructured-to-json/extract | 600 | 47.82 ± 0.2% | not timed | not timed | 77.00 ± 0.2% | 48.95 ± 0.5% | not timed | not timed | 47.57 ± 0.8% | | 1.01 | 0.62 | 0.98 |
| 12-dictionary/single | 1 | 603.38 ± 0.4% | not timed | not timed | 560.66 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 603.78 ± 0.3% | | 1.00 | 1.08 | 1487.95 |
| 14-quadratic/1x | 100 | 12.60 ± 0.2% | not timed | not timed | 10.07 ± 0.3% | 0.97 ± 4.4% | not timed | not timed | 12.52 ± 2.4% | | 1.01 | 1.25 | 12.92 |
| 14-quadratic/2x | 200 | 7.83 ± 0.6% | not timed | not timed | 5.56 ± 0.1% | 0.53 ± 1.7% | not timed | not timed | 7.80 ± 1.1% | | 1.00 | 1.41 | 14.81 |
| 14-quadratic/10x | 1000 | 1.87 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.4% | not timed | not timed | 1.86 ± 0.3% | | 1.00 | 1.54 | 16.21 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.45 ± 0.2% | not timed | not timed | 0.34 ± 0.4% | 0.55 ± 6.1% | not timed | not timed | 1.43 ± 1.5% | | 1.01 | 4.21 | 2.64 |
| 04-ruff-noqa/compile-real | 1 | 92.83 ± 0.2% | not timed | not timed | 13.84 ± 0.2% | 136.82 ± 2.6% | not timed | not timed | 92.82 ± 0.7% | | 1.00 | 6.71 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 14.68 ± 0.2% | not timed | not timed | 2.53 ± 0.6% | 6.48 ± 4.0% | not timed | not timed | 14.56 ± 1.8% | | 1.01 | 5.79 | 2.27 |
| 07-unicode-character-data/compile | 1 | 58.41 ± 0.2% | not timed | not timed | 26.06 ± 0.3% | 35.94 ± 10.9% | not timed | not timed | 58.32 ± 1.4% | | 1.00 | 2.24 | 1.63 |
| 09-aws-keys/compile-full | 1 | 43.71 ± 0.1% | not timed | not timed | 8.31 ± 0.4% | 23.48 ± 15.5% | not timed | not timed | 43.44 ± 0.9% | | 1.01 | 5.26 | 1.86 |
| 09-aws-keys/compile-quick | 1 | 188.34 ± 0.2% | not timed | not timed | 47.60 ± 0.4% | 134.48 ± 2.8% | not timed | not timed | 189.89 ± 1.4% | | 0.99 | 3.96 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 14.75 ± 0.7% | not timed | not timed | 11.13 ± 0.2% | 16.31 ± 1.1% | not timed | not timed | 14.60 ± 2.1% | | 1.01 | 1.33 | 0.90 |
| 10-bounded-repeat/compile-capitals | 1 | 85.93 ± 1.1% | not timed | not timed | 7.98 ± 0.1% | 24.04 ± 2.0% | not timed | not timed | 85.47 ± 1.5% | | 1.01 | 10.77 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 90.69 ± 0.2% | not timed | not timed | 40.70 ± 0.3% | 68.73 ± 3.4% | not timed | not timed | 90.57 ± 1.0% | | 1.00 | 2.23 | 1.32 |
| 12-dictionary/compile-single | 1 | 0.36 ± 0.2% | not timed | not timed | 0.07 ± 37.5% | 0.10 ± 13.4% | not timed | not timed | 0.36 ± 1.2% | | 1.00 | 5.31 | 3.68 |

