# bench-regex

| Field | Value |
|---|---|
| Commit | 4bd3bda |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45127337678 |
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
| literal: a word | 217 | 31799.59 ± 3.0% | 841.28 ± 0.4% | 19.84 ± 2.4% | 30740.78 ± 0.6% | 8913.40 ± 8.2% | 10.66 ± 0.2% | 76.33 ± 1.5% | 31419.72 ± 1.3% | 37.80 | 1.01 | 1.03 | 3.57 |
| literal: a word that is not there | 0 | 46561.98 ± 2.5% | 848.95 ± 0.4% | 19.68 ± 11.5% | 39350.13 ± 0.4% | 29923.10 ± 2.2% | 10.42 ± 0.7% | 72.24 ± 1.0% | 46267.81 ± 2.1% | 54.85 | 1.01 | 1.18 | 1.56 |
| literal: one of four words | 661 | 10893.68 ± 1.1% | 822.49 ± 0.8% | 10.97 ± 0.4% | 9059.47 ± 0.7% | 18.98 ± 2.4% | 3.99 ± 0.6% | 6.67 ± 1.2% | 10866.30 ± 1.2% | 13.24 | 1.00 | 1.20 | 574.01 |
| literal: a word in any case | 217 | 25242.78 ± 4.6% | 839.18 ± 0.5% | 14.81 ± 1.4% | 9211.79 ± 1.0% | 37.08 ± 1.4% | refused | differs | 25100.24 ± 6.9% | 30.08 | 1.01 | 2.74 | 680.75 |
| literal: an href attribute | 33 | 26324.84 ± 4.0% | 843.66 ± 0.3% | 18.16 ± 2.2% | 27183.98 ± 1.5% | 2053.94 ± 1.6% | 8.18 ± 1.6% | 61.34 ± 1.2% | 26221.78 ± 1.1% | 31.20 | 1.00 | 0.97 | 12.82 |
| literal: a word, second text | 123 | 32617.04 ± 2.1% | 843.89 ± 0.6% | 19.69 ± 1.7% | 31680.08 ± 1.2% | 7027.05 ± 6.8% | 11.73 ± 1.3% | 64.94 ± 1.4% | 32439.42 ± 4.0% | 38.65 | 1.01 | 1.03 | 4.64 |
| class: two capitalized words | 1331 | 785.06 ± 1.0% | 786.78 ± 0.1% | 18.73 ± 0.8% | 505.57 ± 0.3% | 34.23 ± 9.6% | 9.25 ± 0.2% | 55.81 ± 0.6% | 785.11 ± 0.2% | 1.00 | 1.00 | 1.55 | 22.93 |
| class: a word that ends in ing | 3399 | 715.82 ± 0.2% | 715.60 ± 1.2% | 12.75 ± 2.4% | 472.27 ± 0.3% | 25.52 ± 2.9% | 5.33 ± 0.1% | 17.21 ± 0.3% | 714.94 ± 0.4% | 1.00 | 1.00 | 1.52 | 28.05 |
| class: a word in capitals | 2332 | 987.61 ± 0.9% | 768.81 ± 0.3% | 19.58 ± 2.2% | 497.05 ± 0.4% | 36.52 ± 14.5% | 10.28 ± 0.5% | 76.30 ± 1.6% | 986.74 ± 11.9% | 1.28 | 1.00 | 1.99 | 27.04 |
| class: a number | 8288 | 1420.91 ± 2.0% | 658.39 ± 1.3% | 19.03 ± 8.8% | 1482.65 ± 3.1% | 34.70 ± 13.4% | 0.33 ± 0.3% | 55.69 ± 1.6% | 1416.12 ± 1.3% | 2.16 | 1.00 | 0.96 | 40.94 |
| class: two capitalized words, second text | 5359 | 593.80 ± 0.4% | 592.89 ± 0.6% | 16.84 ± 2.1% | 418.08 ± 0.2% | 29.00 ± 10.7% | 10.47 ± 0.4% | 51.63 ± 1.1% | 593.28 ± 0.1% | 1.00 | 1.00 | 1.42 | 20.48 |
| other: a word between two words | 6104 | 641.97 ± 0.2% | 618.88 ± 0.2% | 16.71 ± 0.5% | 698.48 ± 0.3% | 101.03 ± 8.7% | 7.23 ± 1.1% | 56.65 ± 1.1% | 641.63 ± 0.6% | 1.04 | 1.00 | 0.92 | 6.35 |
| other: a number before a unit, second text | 1481 | 6570.22 ± 1.1% | 792.99 ± 0.2% | 18.45 ± 3.5% | 6354.29 ± 1.2% | 35.12 ± 0.4% | 10.88 ± 0.5% | 55.06 ± 0.4% | 6545.18 ± 0.6% | 8.29 | 1.00 | 1.03 | 187.08 |
| other: a heading's start tag | 110 | 18549.35 ± 3.1% | 840.64 ± 0.3% | 19.01 ± 3.0% | 2005.08 ± 2.2% | 1473.48 ± 15.2% | 9.97 ± 5.2% | 72.61 ± 0.4% | 18169.35 ± 1.0% | 22.07 | 1.02 | 9.25 | 12.59 |
| other: a whole word | 217 | 21978.24 ± 4.9% | 840.98 ± 1.0% | 19.24 ± 2.8% | 22430.14 ± 14.9% | 40.65 ± 0.4% | 9.45 ± 0.2% | 46.83 ± 9.9% | 21167.23 ± 6.4% | 26.13 | 1.04 | 0.98 | 540.70 |
| other: a line's first word, second text | 3716 | 1716.47 ± 0.5% | 705.28 ± 0.4% | 21.92 ± 3.0% | 1695.16 ± 6.3% | 51.58 ± 12.3% | refused | refused | 1711.88 ± 4.6% | 2.43 | 1.00 | 1.01 | 33.28 |
| other: fourteen octets before an x | 87 | 24912.73 ± 1.4% | 194.52 ± 0.5% | 5.10 ± 2.8% | 2869.70 ± 1.5% | 8.99 ± 6.5% | differs | 15.44 ± 1.7% | 24809.78 ± 7.3% | 128.07 | 1.00 | 8.68 | 2771.44 |
| other: a Greek word | 21815 | 396.24 ± 0.5% | 289.96 ± 1.0% | 22.90 ± 1.3% | 262.71 ± 0.8% | 40.54 ± 13.0% | differs | refused | 394.94 ± 1.0% | 1.37 | 1.00 | 1.51 | 9.77 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.58 ± 1.5% | 24.13 ± 1.2% | 0.71 ± 0.5% | 16.76 ± 0.7% | 2.34 ± 0.5% | differs | 3.63 ± 0.5% | 24.72 ± 1.4% | 1.02 | 0.99 | 1.47 | 10.52 |
| a UUID | 32895 | 20.05 ± 1.6% | 20.55 ± 0.4% | 0.55 ± 0.2% | 12.79 ± 0.3% | 2.51 ± 1.0% | 0.44 ± 0.7% | 3.09 ± 1.0% | 20.60 ± 5.2% | 0.98 | 0.97 | 1.57 | 7.98 |
| an IPv4 address | 33176 | 33.74 ± 2.8% | 33.74 ± 5.2% | 1.75 ± 4.7% | 23.79 ± 1.0% | 5.65 ± 8.5% | differs | 3.38 ± 1.5% | 34.19 ± 1.0% | 1.00 | 0.99 | 1.42 | 5.97 |
| a date and time | 32954 | 29.82 ± 2.3% | 29.82 ± 2.6% | 1.25 ± 3.0% | 17.64 ± 2.0% | 6.59 ± 3.4% | 0.75 ± 1.6% | 6.08 ± 12.3% | 30.00 ± 1.8% | 1.00 | 0.99 | 1.69 | 4.53 |
| a field path | 32606 | 27.12 ± 0.9% | 27.25 ± 1.2% | 0.84 ± 2.3% | 19.25 ± 1.2% | 2.93 ± 1.2% | differs | 2.22 ± 13.1% | 27.29 ± 1.2% | 1.00 | 0.99 | 1.41 | 9.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.24 ± 16.8% | 8.24 ± 0.7% | 8.23 ± 0.2% | 10.63 ± 0.3% | 4.67 ± 1.8% | 0.62 ± 0.4% | none | 8.28 ± 17.8% | 1.00 | 1.00 | 0.78 | 1.77 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 185.35 ± 0.6% | 185.87 ± 7.3% | 215.78 ± 0.7% | 79.28 ± 4.1% | 173.43 ± 12.3% | 547.84 ± 2.9% | 3978.75 ± 0.5% | 185.30 ± 0.3% | 1.00 | 1.00 | 2.34 | 1.07 |
| a UUID | 62 | 120.73 ± 0.8% | 120.77 ± 0.4% | 133.37 ± 4.1% | 46.81 ± 6.5% | 88.34 ± 10.5% | 198.12 ± 2.3% | 4111.22 ± 0.4% | 120.53 ± 2.3% | 1.00 | 1.00 | 2.58 | 1.37 |
| an IPv4 address | 29 | 395.47 ± 3.3% | 397.32 ± 1.5% | 552.48 ± 8.7% | 69.59 ± 5.3% | 110.61 ± 6.2% | 334.09 ± 6.8% | 7174.29 ± 0.4% | 396.35 ± 0.7% | 1.00 | 1.00 | 5.68 | 3.58 |
| a date and time | 56 | 284.18 ± 12.8% | 286.23 ± 0.2% | 357.98 ± 0.5% | 68.72 ± 1.1% | 121.33 ± 2.5% | 370.14 ± 1.0% | 4227.48 ± 0.8% | 283.71 ± 11.4% | 0.99 | 1.00 | 4.14 | 2.34 |
| a field path | 39 | 180.62 ± 4.3% | 181.47 ± 0.7% | 209.00 ± 7.5% | 75.40 ± 2.5% | 166.39 ± 20.5% | 591.86 ± 3.5% | 4807.58 ± 0.5% | 180.55 ± 1.8% | 1.00 | 1.00 | 2.40 | 1.09 |
| literal: a word | 7 | 589.13 ± 0.3% | 628.79 ± 0.4% | 1108.75 ± 0.3% | 508.25 ± 1.1% | 569.77 ± 4.5% | 1254.12 ± 0.8% | 25122.49 ± 1.3% | 589.04 ± 0.4% | 0.94 | 1.00 | 1.16 | 1.03 |
| literal: a word that is not there | 8 | 568.31 ± 0.4% | 604.52 ± 14.9% | 1043.90 ± 3.0% | 467.98 ± 0.6% | 553.28 ± 2.2% | 1179.99 ± 0.8% | 23708.49 ± 1.0% | 568.80 ± 0.3% | 0.94 | 1.00 | 1.21 | 1.03 |
| literal: one of four words | 26 | 219.76 ± 0.4% | 363.75 ± 0.5% | 486.47 ± 0.4% | 41.75 ± 0.6% | 215.57 ± 2.2% | 454.70 ± 0.9% | 11423.54 ± 1.3% | 220.09 ± 8.5% | 0.60 | 1.00 | 5.26 | 1.02 |
| literal: a word in any case | 11 | 448.17 ± 0.5% | 475.35 ± 0.3% | 718.30 ± 0.4% | 14.55 ± 0.5% | 614.20 ± 4.2% | refused | 19428.40 ± 8.7% | 446.45 ± 11.6% | 0.94 | 1.00 | 30.80 | 0.73 |
| literal: an href attribute | 12 | 318.62 ± 15.0% | 329.64 ± 1.0% | 431.76 ± 0.5% | 37.30 ± 4.8% | 423.55 ± 1.8% | 960.44 ± 1.2% | 18633.55 ± 17.8% | 318.52 ± 2.5% | 0.97 | 1.00 | 8.54 | 0.75 |
| literal: a word, second text | 10 | 522.51 ± 1.6% | 568.62 ± 3.1% | 944.95 ± 2.2% | 425.30 ± 0.6% | 471.09 ± 24.8% | 1007.63 ± 11.3% | 21580.25 ± 16.3% | 522.26 ± 0.6% | 0.92 | 1.00 | 1.23 | 1.11 |
| class: two capitalized words | 23 | 421.31 ± 0.4% | 450.23 ± 10.0% | 652.37 ± 0.5% | 94.23 ± 0.6% | 445.65 ± 4.7% | 941.12 ± 17.8% | 6388.31 ± 0.3% | 421.47 ± 9.0% | 0.94 | 1.00 | 4.47 | 0.95 |
| class: a word that ends in ing | 9 | 512.75 ± 0.6% | 572.28 ± 0.6% | 1005.23 ± 0.6% | 115.48 ± 11.4% | 619.88 ± 15.4% | 1441.30 ± 4.1% | 15268.15 ± 3.4% | 511.81 ± 0.3% | 0.90 | 1.00 | 4.44 | 0.83 |
| class: a word in capitals | 16 | 444.69 ± 9.2% | 479.68 ± 0.7% | 784.00 ± 4.7% | 122.22 ± 2.1% | 643.72 ± 0.6% | 1325.79 ± 1.6% | 8377.24 ± 12.3% | 447.11 ± 0.7% | 0.93 | 0.99 | 3.64 | 0.69 |
| class: a number | 6 | 561.49 ± 0.4% | 613.64 ± 0.5% | 1160.05 ± 0.7% | 36.46 ± 0.8% | 1153.22 ± 2.2% | 2345.14 ± 15.0% | 20313.25 ± 1.3% | 561.20 ± 0.7% | 0.92 | 1.00 | 15.40 | 0.49 |
| class: two capitalized words, second text | 23 | 421.55 ± 1.9% | 449.34 ± 9.8% | 651.19 ± 3.5% | 94.74 ± 0.7% | 443.18 ± 40.7% | 946.96 ± 3.7% | 6393.82 ± 0.2% | 419.87 ± 0.6% | 0.94 | 1.00 | 4.45 | 0.95 |
| other: a word between two words | 13 | 503.17 ± 11.6% | 516.25 ± 12.4% | 806.17 ± 4.9% | 124.28 ± 6.9% | 426.45 ± 2.6% | 1034.46 ± 1.3% | 13893.81 ± 6.3% | 501.61 ± 1.0% | 0.97 | 1.00 | 4.05 | 1.18 |
| other: a number before a unit, second text | 15 | 355.86 ± 0.9% | 391.58 ± 2.0% | 538.24 ± 9.6% | 33.55 ± 9.9% | 535.60 ± 3.5% | 1116.53 ± 2.9% | 13826.67 ± 3.5% | 354.51 ± 1.2% | 0.91 | 1.00 | 10.61 | 0.66 |
| other: a heading's start tag | 13 | 331.35 ± 0.1% | 336.37 ± 1.1% | 441.95 ± 0.4% | 35.99 ± 1.4% | 519.13 ± 3.5% | 1085.06 ± 0.7% | 16406.17 ± 1.1% | 331.47 ± 1.1% | 0.99 | 1.00 | 9.21 | 0.64 |
| other: a whole word | 11 | 508.30 ± 2.5% | 539.18 ± 2.6% | 861.58 ± 2.8% | 112.05 ± 4.0% | 497.74 ± 21.2% | 1038.18 ± 14.1% | 20965.05 ± 4.7% | 504.27 ± 2.7% | 0.94 | 1.01 | 4.54 | 1.02 |
| other: a line's first word, second text | 17 | 483.36 ± 11.2% | 504.06 ± 0.4% | 821.26 ± 4.7% | 115.15 ± 4.8% | 588.83 ± 2.3% | refused | refused | 480.47 ± 0.5% | 0.96 | 1.01 | 4.20 | 0.82 |
| other: fourteen octets before an x | 16 | 87.48 ± 0.7% | 124.45 ± 0.2% | 142.82 ± 0.7% | 14.20 ± 0.6% | 383.05 ± 2.1% | 449.24 ± 1.3% | 11733.17 ± 1.1% | 87.58 ± 2.6% | 0.70 | 1.00 | 6.16 | 0.23 |
| other: a Greek word | 8 | 376.42 ± 0.4% | 506.43 ± 0.4% | 827.04 ± 0.8% | 45.93 ± 1.4% | 1133.86 ± 2.3% | 2193.05 ± 0.6% | refused | 376.40 ± 0.2% | 0.74 | 1.00 | 8.20 | 0.33 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20396.08 ± 1.9% | not timed | not timed | 26500.05 ± 1.6% | 1942.54 ± 20.0% | not timed | not timed | 20510.65 ± 2.8% | | 0.99 | 0.77 | 10.50 |
| 01-literal/sherlock-casei-en | 522 | 4506.65 ± 4.5% | not timed | not timed | 6455.82 ± 5.0% | 27.32 ± 7.6% | not timed | not timed | 4527.88 ± 3.1% | | 1.00 | 0.70 | 164.93 |
| 01-literal/sherlock-ru | 724 | 22203.60 ± 6.3% | not timed | not timed | 27053.60 ± 14.6% | 1038.68 ± 12.0% | not timed | not timed | 21991.37 ± 7.2% | | 1.01 | 0.82 | 21.38 |
| 01-literal/sherlock-casei-ru | 746 | 7208.52 ± 1.4% | not timed | not timed | 5451.06 ± 3.8% | 29.94 ± 1.8% | not timed | not timed | 7184.11 ± 0.9% | | 1.00 | 1.32 | 240.73 |
| 01-literal/sherlock-zh | 30 | 40866.45 ± 2.0% | not timed | not timed | 36559.58 ± 16.5% | 1254.70 ± 2.8% | not timed | not timed | 40986.09 ± 2.1% | | 1.00 | 1.12 | 32.57 |
| 02-literal-alternate/sherlock-en | 714 | 9474.41 ± 2.8% | not timed | not timed | 8862.22 ± 0.8% | 14.16 ± 4.2% | not timed | not timed | 9538.91 ± 0.9% | | 0.99 | 1.07 | 668.86 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1717.43 ± 1.4% | not timed | not timed | 1813.84 ± 1.9% | 9.43 ± 1.4% | not timed | not timed | 1722.31 ± 0.5% | | 1.00 | 0.95 | 182.08 |
| 02-literal-alternate/sherlock-ru | 899 | 5859.69 ± 1.2% | not timed | not timed | 4217.50 ± 2.3% | 19.16 ± 3.5% | not timed | not timed | 5850.96 ± 1.4% | | 1.00 | 1.39 | 305.76 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1781.88 ± 1.0% | not timed | not timed | 1042.31 ± 1.0% | 8.46 ± 2.3% | not timed | not timed | 1785.83 ± 1.4% | | 1.00 | 1.71 | 210.55 |
| 02-literal-alternate/sherlock-zh | 207 | 13685.49 ± 1.2% | not timed | not timed | 10391.07 ± 0.5% | 26.91 ± 0.7% | not timed | not timed | 13737.73 ± 0.9% | | 1.00 | 1.32 | 508.62 |
| 03-date/ascii | 111817 | 99.74 ± 1.0% | not timed | not timed | 85.51 ± 1.0% | 0.18 ± 3.8% | not timed | not timed | 99.27 ± 2.5% | | 1.00 | 1.17 | 566.53 |
| 04-ruff-noqa/real | 84 | 542.79 ± 0.6% | not timed | not timed | 425.78 ± 0.4% | 15.90 ± 1.0% | not timed | not timed | 545.00 ± 1.0% | | 1.00 | 1.27 | 34.13 |
| 04-ruff-noqa/tweaked | 44 | 480.49 ± 0.1% | not timed | not timed | 418.78 ± 0.6% | 293.43 ± 1.3% | not timed | not timed | 481.62 ± 0.3% | | 1.00 | 1.15 | 1.64 |
| 05-lexer-veryl/single | 124800 | 2.81 ± 2.0% | not timed | not timed | 4.08 ± 3.0% | 0.21 ± 8.9% | not timed | not timed | 2.75 ± 4.7% | | 1.02 | 0.69 | 13.32 |
| 06-cloud-flare-redos/original | 107 | 230.48 ± 0.3% | not timed | not timed | 191.69 ± 3.1% | 20.51 ± 0.3% | not timed | not timed | 230.60 ± 0.2% | | 1.00 | 1.20 | 11.24 |
| 06-cloud-flare-redos/simplified-short | 102 | 220.24 ± 0.9% | not timed | not timed | 192.48 ± 0.3% | 21.97 ± 0.4% | not timed | not timed | 220.07 ± 0.2% | | 1.00 | 1.14 | 10.02 |
| 06-cloud-flare-redos/simplified-long | 10000 | 246.77 ± 0.4% | not timed | not timed | 211.64 ± 0.6% | 24.09 ± 0.4% | not timed | not timed | 246.81 ± 0.6% | | 1.00 | 1.17 | 10.24 |
| 07-unicode-character-data/parse-line | 558784 | 196.69 ± 0.4% | not timed | not timed | 159.58 ± 1.4% | 36.94 ± 6.2% | not timed | not timed | 193.55 ± 2.7% | | 1.02 | 1.23 | 5.32 |
| 08-words/all-english | 56691 | 90.84 ± 0.7% | not timed | not timed | 72.89 ± 0.8% | 9.92 ± 7.7% | not timed | not timed | 89.54 ± 0.7% | | 1.01 | 1.25 | 9.15 |
| 08-words/long-english | 839 | 806.55 ± 1.7% | not timed | not timed | 513.80 ± 0.2% | 26.41 ± 0.7% | not timed | not timed | 802.50 ± 0.4% | | 1.01 | 1.57 | 30.54 |
| 09-aws-keys/full | 0 | 421.26 ± 0.6% | not timed | not timed | 437.98 ± 0.6% | 54.89 ± 5.0% | not timed | not timed | 423.90 ± 1.2% | | 0.99 | 0.96 | 7.67 |
| 09-aws-keys/quick | 0 | 825.85 ± 0.3% | not timed | not timed | 804.22 ± 0.2% | 330.30 ± 0.5% | not timed | not timed | 818.03 ± 0.3% | | 1.01 | 1.03 | 2.50 |
| 10-bounded-repeat/letters-en | 1833 | 490.71 ± 0.2% | not timed | not timed | 432.17 ± 0.2% | 16.74 ± 2.2% | not timed | not timed | 489.98 ± 0.9% | | 1.00 | 1.14 | 29.31 |
| 10-bounded-repeat/letters-ru | 3475 | 318.38 ± 0.6% | not timed | not timed | 408.20 ± 0.2% | 19.36 ± 12.9% | not timed | not timed | 317.98 ± 1.7% | | 1.00 | 0.78 | 16.44 |
| 10-bounded-repeat/context | 53 | 65.34 ± 5.2% | not timed | not timed | 55.70 ± 1.8% | 16.87 ± 0.8% | not timed | not timed | 65.65 ± 1.6% | | 1.00 | 1.17 | 3.87 |
| 10-bounded-repeat/capitals | 11 | 842.90 ± 0.5% | not timed | not timed | 531.39 ± 0.3% | 30.62 ± 6.0% | not timed | not timed | 841.61 ± 0.4% | | 1.00 | 1.59 | 27.53 |
| 11-unstructured-to-json/extract | 600 | 34.81 ± 0.9% | not timed | not timed | 62.14 ± 1.0% | 40.16 ± 6.4% | not timed | not timed | 34.69 ± 0.8% | | 1.00 | 0.56 | 0.87 |
| 12-dictionary/single | 1 | 455.47 ± 0.9% | not timed | not timed | 436.81 ± 2.3% | 0.31 ± 1.2% | not timed | not timed | 457.81 ± 0.5% | | 0.99 | 1.04 | 1454.31 |
| 14-quadratic/1x | 100 | 10.04 ± 0.7% | not timed | not timed | 9.11 ± 1.1% | 0.80 ± 2.2% | not timed | not timed | 9.98 ± 0.9% | | 1.01 | 1.10 | 12.58 |
| 14-quadratic/2x | 200 | 6.29 ± 0.5% | not timed | not timed | 4.92 ± 2.8% | 0.43 ± 20.4% | not timed | not timed | 6.29 ± 0.4% | | 1.00 | 1.28 | 14.67 |
| 14-quadratic/10x | 1000 | 1.50 ± 0.6% | not timed | not timed | 1.05 ± 0.2% | 0.09 ± 15.6% | not timed | not timed | 1.50 ± 1.0% | | 1.00 | 1.43 | 16.35 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.34 ± 3.0% | not timed | not timed | 0.38 ± 1.5% | 0.45 ± 3.3% | not timed | not timed | 1.34 ± 8.0% | | 1.00 | 3.54 | 3.00 |
| 04-ruff-noqa/compile-real | 1 | 80.01 ± 0.9% | not timed | not timed | 12.87 ± 1.6% | 111.27 ± 7.9% | not timed | not timed | 79.79 ± 0.5% | | 1.00 | 6.21 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 12.82 ± 3.5% | not timed | not timed | 2.36 ± 1.9% | 5.51 ± 11.7% | not timed | not timed | 12.73 ± 13.3% | | 1.01 | 5.44 | 2.32 |
| 07-unicode-character-data/compile | 1 | 50.80 ± 3.0% | not timed | not timed | 23.94 ± 1.8% | 32.10 ± 9.1% | not timed | not timed | 50.75 ± 11.7% | | 1.00 | 2.12 | 1.58 |
| 09-aws-keys/compile-full | 1 | 34.82 ± 0.4% | not timed | not timed | 7.40 ± 14.7% | 19.83 ± 5.4% | not timed | not timed | 34.64 ± 2.9% | | 1.01 | 4.71 | 1.76 |
| 09-aws-keys/compile-quick | 1 | 159.99 ± 0.4% | not timed | not timed | 45.19 ± 9.9% | 114.10 ± 20.4% | not timed | not timed | 159.11 ± 0.7% | | 1.01 | 3.54 | 1.40 |
| 10-bounded-repeat/compile-context | 1 | 10.62 ± 0.1% | not timed | not timed | 11.43 ± 8.9% | 14.57 ± 7.1% | not timed | not timed | 10.55 ± 0.8% | | 1.01 | 0.93 | 0.73 |
| 10-bounded-repeat/compile-capitals | 1 | 73.76 ± 3.2% | not timed | not timed | 8.77 ± 0.5% | 21.38 ± 19.6% | not timed | not timed | 73.55 ± 1.2% | | 1.00 | 8.41 | 3.45 |
| 11-unstructured-to-json/compile | 1 | 76.78 ± 2.2% | not timed | not timed | 36.72 ± 1.1% | 57.84 ± 3.0% | not timed | not timed | 76.34 ± 1.1% | | 1.01 | 2.09 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.7% | not timed | not timed | 0.07 ± 14.5% | 0.08 ± 8.2% | not timed | not timed | 0.28 ± 4.3% | | 1.03 | 4.46 | 3.58 |

