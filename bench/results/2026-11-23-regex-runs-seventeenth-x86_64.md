# bench-regex

| Field | Value |
|---|---|
| Commit | aa9cc13 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45148132263 |
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
| literal: a word | 217 | 31857.17 ± 0.4% | 801.95 ± 0.4% | 23.29 ± 0.3% | 30197.02 ± 0.7% | 9308.24 ± 7.7% | 10.03 ± 0.6% | 81.00 ± 1.3% | 31873.10 ± 0.3% | 39.72 | 1.00 | 1.05 | 3.42 |
| literal: a word that is not there | 0 | 44349.67 ± 1.0% | 810.07 ± 0.1% | 23.29 ± 0.4% | 35449.13 ± 1.0% | 33869.49 ± 2.4% | 9.93 ± 0.3% | 76.34 ± 1.5% | 44484.98 ± 3.9% | 54.75 | 1.00 | 1.25 | 1.31 |
| literal: one of four words | 661 | 11089.35 ± 0.8% | 786.04 ± 0.6% | 12.94 ± 5.9% | 8865.19 ± 0.2% | 19.21 ± 0.8% | 3.47 ± 0.7% | 6.42 ± 1.5% | 11045.70 ± 8.9% | 14.11 | 1.00 | 1.25 | 577.35 |
| literal: a word in any case | 217 | 28666.57 ± 6.0% | 800.98 ± 0.9% | 17.81 ± 0.5% | 8936.90 ± 1.2% | 36.42 ± 4.9% | refused | differs | 28622.07 ± 0.2% | 35.79 | 1.00 | 3.21 | 787.17 |
| literal: an href attribute | 33 | 27428.27 ± 0.5% | 806.55 ± 0.1% | 22.52 ± 10.9% | 27153.64 ± 0.4% | 2278.17 ± 6.0% | 7.53 ± 0.7% | 70.75 ± 5.4% | 27381.45 ± 0.5% | 34.01 | 1.00 | 1.01 | 12.04 |
| literal: a word, second text | 123 | 33989.29 ± 0.6% | 803.52 ± 0.3% | 23.03 ± 1.8% | 30637.46 ± 0.9% | 8758.03 ± 6.7% | 11.26 ± 1.0% | 67.96 ± 0.7% | 33972.04 ± 0.9% | 42.30 | 1.00 | 1.11 | 3.88 |
| class: two capitalized words | 1331 | 709.89 ± 0.2% | 747.66 ± 0.6% | 21.80 ± 0.3% | 446.69 ± 0.7% | 34.19 ± 1.8% | 8.59 ± 0.5% | 62.11 ± 12.3% | 709.39 ± 0.3% | 0.95 | 1.00 | 1.59 | 20.76 |
| class: a word that ends in ing | 3399 | 687.69 ± 6.7% | 687.41 ± 15.4% | 14.82 ± 7.0% | 418.59 ± 0.5% | 25.49 ± 10.2% | 4.84 ± 0.1% | 15.75 ± 2.0% | 686.67 ± 0.6% | 1.00 | 1.00 | 1.64 | 26.98 |
| class: a word in capitals | 2332 | 889.82 ± 0.2% | 730.50 ± 3.2% | 22.78 ± 0.9% | 438.15 ± 0.4% | 36.99 ± 5.3% | 9.70 ± 0.4% | 78.22 ± 1.6% | 888.92 ± 0.2% | 1.22 | 1.00 | 2.03 | 24.06 |
| class: a number | 8288 | 1316.43 ± 0.5% | 632.57 ± 0.6% | 22.88 ± 1.4% | 1394.67 ± 0.4% | 36.52 ± 8.9% | 0.30 ± 0.1% | 56.70 ± 0.3% | 1332.67 ± 1.6% | 2.08 | 0.99 | 0.94 | 36.05 |
| class: two capitalized words, second text | 5359 | 562.76 ± 0.3% | 561.77 ± 0.2% | 19.87 ± 0.9% | 370.53 ± 0.2% | 29.95 ± 13.6% | 9.89 ± 0.4% | 57.74 ± 2.2% | 561.52 ± 0.2% | 1.00 | 1.00 | 1.52 | 18.79 |
| other: a word between two words | 6104 | 652.84 ± 0.5% | 584.61 ± 0.2% | 19.71 ± 0.6% | 622.78 ± 0.7% | 96.96 ± 14.3% | 6.62 ± 0.4% | 63.17 ± 0.3% | 650.66 ± 1.4% | 1.12 | 1.00 | 1.05 | 6.73 |
| other: a number before a unit, second text | 1481 | 7635.21 ± 0.6% | 769.15 ± 0.4% | 21.76 ± 0.3% | 6368.07 ± 0.3% | 34.66 ± 1.4% | 10.36 ± 0.3% | 61.07 ± 1.2% | 7621.28 ± 7.1% | 9.93 | 1.00 | 1.20 | 220.28 |
| other: a heading's start tag | 110 | 18959.99 ± 0.2% | 799.05 ± 0.1% | 22.91 ± 5.7% | 2018.81 ± 2.3% | 1574.86 ± 4.7% | 9.18 ± 0.7% | 83.12 ± 0.3% | 18870.01 ± 0.4% | 23.73 | 1.00 | 9.39 | 12.04 |
| other: a whole word | 217 | 22429.33 ± 11.1% | 800.96 ± 0.1% | 23.34 ± 0.3% | 21738.86 ± 0.4% | 42.05 ± 0.9% | 8.70 ± 0.2% | 48.94 ± 1.1% | 22722.28 ± 0.2% | 28.00 | 0.99 | 1.03 | 533.45 |
| other: a line's first word, second text | 3716 | 1998.34 ± 0.5% | 669.71 ± 0.3% | 23.78 ± 9.8% | 1788.90 ± 11.2% | 55.26 ± 3.5% | refused | refused | 1986.10 ± 1.2% | 2.98 | 1.01 | 1.12 | 36.17 |
| other: fourteen octets before an x | 87 | 27718.74 ± 0.9% | 192.13 ± 1.9% | 5.95 ± 4.6% | 2662.40 ± 1.0% | 8.94 ± 1.1% | differs | 16.89 ± 0.8% | 27961.70 ± 0.3% | 144.27 | 0.99 | 10.41 | 3101.68 |
| other: a Greek word | 21815 | 371.72 ± 0.5% | 311.47 ± 0.2% | 26.13 ± 0.8% | 233.44 ± 1.9% | 39.33 ± 21.9% | differs | refused | 371.29 ± 0.4% | 1.19 | 1.00 | 1.59 | 9.45 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 22.61 ± 0.4% | 22.55 ± 0.7% | 0.80 ± 0.4% | 15.38 ± 0.4% | 2.18 ± 0.5% | differs | 3.32 ± 3.3% | 22.65 ± 5.0% | 1.00 | 1.00 | 1.47 | 10.35 |
| a UUID | 32895 | 18.72 ± 0.8% | 18.47 ± 0.1% | 0.56 ± 0.6% | 11.71 ± 0.8% | 2.34 ± 1.8% | 0.40 ± 0.1% | 3.05 ± 4.7% | 18.74 ± 0.3% | 1.01 | 1.00 | 1.60 | 7.98 |
| an IPv4 address | 33176 | 30.83 ± 5.3% | 30.82 ± 3.3% | 1.83 ± 0.2% | 21.77 ± 0.7% | 5.39 ± 0.6% | differs | 3.27 ± 38.7% | 30.94 ± 5.2% | 1.00 | 1.00 | 1.42 | 5.72 |
| a date and time | 32954 | 27.85 ± 0.4% | 27.86 ± 0.3% | 1.35 ± 0.2% | 16.78 ± 0.7% | 6.36 ± 2.1% | 0.71 ± 0.3% | 5.86 ± 4.4% | 27.86 ± 2.2% | 1.00 | 1.00 | 1.66 | 4.38 |
| a field path | 32606 | 24.66 ± 0.8% | 25.11 ± 0.4% | 0.89 ± 1.0% | 17.74 ± 0.2% | 2.74 ± 3.8% | differs | 2.36 ± 2.5% | 25.17 ± 0.4% | 0.98 | 0.98 | 1.39 | 8.98 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.52 ± 0.2% | 8.51 ± 0.4% | 8.55 ± 0.3% | 10.25 ± 2.0% | 4.14 ± 22.7% | 0.58 ± 0.3% | none | 8.55 ± 0.5% | 1.00 | 1.00 | 0.83 | 2.06 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 185.76 ± 0.3% | 186.88 ± 0.4% | 220.03 ± 0.9% | 79.33 ± 3.6% | 191.00 ± 1.4% | 552.66 ± 2.4% | 3648.59 ± 0.9% | 186.08 ± 0.8% | 0.99 | 1.00 | 2.34 | 0.97 |
| a UUID | 62 | 120.09 ± 5.4% | 120.66 ± 1.1% | 134.80 ± 0.3% | 45.85 ± 2.1% | 93.02 ± 1.9% | 196.53 ± 4.0% | 4187.67 ± 2.5% | 120.24 ± 0.2% | 1.00 | 1.00 | 2.62 | 1.29 |
| an IPv4 address | 29 | 380.63 ± 2.2% | 382.37 ± 5.4% | 568.19 ± 0.7% | 67.89 ± 1.0% | 116.30 ± 12.1% | 327.31 ± 2.2% | 6964.29 ± 0.5% | 379.91 ± 0.8% | 1.00 | 1.00 | 5.61 | 3.27 |
| a date and time | 56 | 285.30 ± 0.6% | 286.38 ± 1.5% | 371.50 ± 0.9% | 67.29 ± 0.6% | 125.43 ± 1.5% | 377.95 ± 1.5% | 4304.84 ± 1.8% | 284.99 ± 0.3% | 1.00 | 1.00 | 4.24 | 2.27 |
| a field path | 39 | 177.51 ± 0.4% | 178.31 ± 0.2% | 207.86 ± 1.8% | 74.27 ± 2.4% | 176.27 ± 29.4% | 615.71 ± 28.4% | 4357.44 ± 10.1% | 177.33 ± 0.2% | 1.00 | 1.00 | 2.39 | 1.01 |
| literal: a word | 7 | 569.20 ± 1.0% | 601.66 ± 3.0% | 1151.91 ± 0.2% | 499.94 ± 1.0% | 607.19 ± 2.2% | 1278.41 ± 1.5% | 26394.04 ± 0.8% | 570.38 ± 0.6% | 0.95 | 1.00 | 1.14 | 0.94 |
| literal: a word that is not there | 8 | 549.99 ± 0.9% | 584.14 ± 0.4% | 1087.32 ± 0.2% | 458.09 ± 1.1% | 581.66 ± 4.0% | 1192.83 ± 0.7% | 25863.97 ± 0.3% | 549.48 ± 2.5% | 0.94 | 1.00 | 1.20 | 0.95 |
| literal: one of four words | 26 | 209.11 ± 0.4% | 354.11 ± 0.4% | 494.16 ± 0.3% | 41.63 ± 0.6% | 227.28 ± 3.0% | 450.16 ± 2.1% | 14232.33 ± 0.7% | 209.07 ± 1.7% | 0.59 | 1.00 | 5.02 | 0.92 |
| literal: a word in any case | 11 | 446.96 ± 0.3% | 471.90 ± 0.5% | 757.31 ± 0.5% | 14.46 ± 1.0% | 626.17 ± 3.1% | refused | 19186.82 ± 1.8% | 446.98 ± 0.4% | 0.95 | 1.00 | 30.92 | 0.71 |
| literal: an href attribute | 12 | 309.87 ± 1.8% | 320.58 ± 1.2% | 437.53 ± 0.9% | 39.18 ± 0.6% | 444.12 ± 3.6% | 978.50 ± 2.8% | 18997.65 ± 1.0% | 309.70 ± 0.5% | 0.97 | 1.00 | 7.91 | 0.70 |
| literal: a word, second text | 10 | 510.48 ± 1.6% | 551.07 ± 1.8% | 978.55 ± 0.4% | 413.30 ± 0.6% | 512.06 ± 1.8% | 1026.89 ± 0.7% | 24728.09 ± 0.4% | 511.51 ± 0.4% | 0.93 | 1.00 | 1.24 | 1.00 |
| class: two capitalized words | 23 | 402.96 ± 0.4% | 436.69 ± 0.4% | 665.91 ± 0.4% | 93.16 ± 1.6% | 461.84 ± 1.9% | 943.07 ± 1.0% | 6078.08 ± 0.7% | 403.04 ± 0.4% | 0.92 | 1.00 | 4.33 | 0.87 |
| class: a word that ends in ing | 9 | 486.22 ± 2.4% | 558.31 ± 0.7% | 1044.17 ± 0.6% | 115.40 ± 0.8% | 653.14 ± 4.3% | 1383.68 ± 2.9% | 14840.55 ± 0.5% | 486.19 ± 0.6% | 0.87 | 1.00 | 4.21 | 0.74 |
| class: a word in capitals | 16 | 437.13 ± 0.6% | 477.34 ± 0.6% | 818.28 ± 0.2% | 121.39 ± 2.5% | 684.01 ± 2.0% | 1328.14 ± 4.1% | 8193.11 ± 0.7% | 436.18 ± 0.6% | 0.92 | 1.00 | 3.60 | 0.64 |
| class: a number | 6 | 532.82 ± 0.4% | 594.43 ± 0.4% | 1197.14 ± 0.8% | 36.32 ± 0.9% | 1251.34 ± 1.9% | 2247.15 ± 0.9% | 20070.44 ± 1.1% | 533.16 ± 1.7% | 0.90 | 1.00 | 14.67 | 0.43 |
| class: two capitalized words, second text | 23 | 403.38 ± 0.9% | 435.92 ± 0.5% | 665.13 ± 0.5% | 95.16 ± 0.7% | 460.48 ± 1.0% | 971.93 ± 7.0% | 6079.60 ± 25.1% | 402.86 ± 0.3% | 0.93 | 1.00 | 4.24 | 0.88 |
| other: a word between two words | 13 | 493.64 ± 0.4% | 509.58 ± 0.9% | 846.39 ± 1.8% | 123.90 ± 1.2% | 450.77 ± 1.9% | 1035.78 ± 0.4% | 13871.74 ± 0.7% | 493.30 ± 0.6% | 0.97 | 1.00 | 3.98 | 1.10 |
| other: a number before a unit, second text | 15 | 339.05 ± 6.3% | 378.07 ± 4.5% | 538.28 ± 8.4% | 34.36 ± 1.2% | 554.62 ± 1.1% | 1132.73 ± 3.4% | 13697.15 ± 6.7% | 339.01 ± 6.2% | 0.90 | 1.00 | 9.87 | 0.61 |
| other: a heading's start tag | 13 | 319.75 ± 0.5% | 323.85 ± 1.6% | 445.12 ± 0.9% | 37.01 ± 21.8% | 542.96 ± 9.7% | 1088.95 ± 15.8% | 15516.05 ± 2.1% | 320.35 ± 0.5% | 0.99 | 1.00 | 8.64 | 0.59 |
| other: a whole word | 11 | 506.62 ± 0.5% | 535.02 ± 0.7% | 927.36 ± 0.5% | 109.88 ± 0.4% | 515.34 ± 6.4% | 1077.17 ± 0.9% | 24499.72 ± 0.4% | 503.23 ± 0.6% | 0.95 | 1.01 | 4.61 | 0.98 |
| other: a line's first word, second text | 17 | 478.14 ± 1.0% | 499.78 ± 0.6% | 854.44 ± 4.6% | 116.66 ± 1.3% | 620.37 ± 0.5% | refused | refused | 476.55 ± 0.7% | 0.96 | 1.00 | 4.10 | 0.77 |
| other: fourteen octets before an x | 16 | 89.99 ± 0.4% | 134.30 ± 0.9% | 161.49 ± 0.7% | 14.01 ± 0.7% | 403.74 ± 3.0% | 450.46 ± 1.3% | 12248.60 ± 2.7% | 90.15 ± 0.4% | 0.67 | 1.00 | 6.42 | 0.22 |
| other: a Greek word | 8 | 333.03 ± 12.0% | 471.75 ± 2.2% | 780.33 ± 0.6% | 48.49 ± 0.7% | 1237.73 ± 1.0% | 2222.36 ± 1.0% | refused | 332.13 ± 6.1% | 0.71 | 1.00 | 6.87 | 0.27 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 22678.35 ± 0.3% | not timed | not timed | 26106.31 ± 1.7% | 1965.50 ± 48.1% | not timed | not timed | 22675.15 ± 2.8% | | 1.00 | 0.87 | 11.54 |
| 01-literal/sherlock-casei-en | 522 | 6612.45 ± 0.5% | not timed | not timed | 7107.58 ± 1.0% | 26.41 ± 1.0% | not timed | not timed | 6631.34 ± 0.4% | | 1.00 | 0.93 | 250.41 |
| 01-literal/sherlock-ru | 724 | 24006.74 ± 0.2% | not timed | not timed | 26714.83 ± 0.2% | 925.26 ± 6.7% | not timed | not timed | 23938.79 ± 1.5% | | 1.00 | 0.90 | 25.95 |
| 01-literal/sherlock-casei-ru | 746 | 6864.70 ± 8.8% | not timed | not timed | 6114.12 ± 9.2% | 29.08 ± 0.7% | not timed | not timed | 6874.15 ± 0.3% | | 1.00 | 1.12 | 236.07 |
| 01-literal/sherlock-zh | 30 | 40960.26 ± 0.3% | not timed | not timed | 33373.51 ± 0.4% | 1270.17 ± 0.6% | not timed | not timed | 40858.29 ± 1.0% | | 1.00 | 1.23 | 32.25 |
| 02-literal-alternate/sherlock-en | 714 | 10068.85 ± 1.9% | not timed | not timed | 8632.28 ± 0.2% | 14.73 ± 0.5% | not timed | not timed | 10062.82 ± 0.4% | | 1.00 | 1.17 | 683.40 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3247.14 ± 7.5% | not timed | not timed | 1776.52 ± 0.7% | 9.52 ± 5.7% | not timed | not timed | 3017.09 ± 1.0% | | 1.08 | 1.83 | 341.06 |
| 02-literal-alternate/sherlock-ru | 899 | 5821.05 ± 0.5% | not timed | not timed | 7717.15 ± 0.9% | 18.86 ± 2.0% | not timed | not timed | 5807.94 ± 0.1% | | 1.00 | 0.75 | 308.63 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1644.96 ± 3.7% | not timed | not timed | 919.16 ± 0.9% | 8.19 ± 6.2% | not timed | not timed | 1567.56 ± 2.2% | | 1.05 | 1.79 | 200.94 |
| 02-literal-alternate/sherlock-zh | 207 | 14464.94 ± 2.0% | not timed | not timed | 10037.99 ± 0.4% | 27.66 ± 1.0% | not timed | not timed | 14406.59 ± 19.6% | | 1.00 | 1.44 | 522.95 |
| 03-date/ascii | 111817 | 101.93 ± 0.2% | not timed | not timed | 77.65 ± 0.5% | 0.18 ± 1.9% | not timed | not timed | 101.17 ± 8.2% | | 1.01 | 1.31 | 565.81 |
| 04-ruff-noqa/real | 84 | 542.22 ± 0.6% | not timed | not timed | 392.30 ± 0.2% | 14.31 ± 1.4% | not timed | not timed | 543.11 ± 0.3% | | 1.00 | 1.38 | 37.89 |
| 04-ruff-noqa/tweaked | 44 | 458.73 ± 0.2% | not timed | not timed | 392.41 ± 5.0% | 276.84 ± 3.6% | not timed | not timed | 458.61 ± 0.2% | | 1.00 | 1.17 | 1.66 |
| 05-lexer-veryl/single | 124800 | 3.09 ± 5.2% | not timed | not timed | 4.19 ± 4.3% | 0.20 ± 6.2% | not timed | not timed | 3.13 ± 2.9% | | 0.99 | 0.74 | 15.77 |
| 06-cloud-flare-redos/original | 107 | 208.61 ± 0.5% | not timed | not timed | 176.61 ± 23.0% | 19.33 ± 1.0% | not timed | not timed | 208.30 ± 0.4% | | 1.00 | 1.18 | 10.79 |
| 06-cloud-flare-redos/simplified-short | 102 | 205.82 ± 0.2% | not timed | not timed | 183.16 ± 0.4% | 21.50 ± 0.4% | not timed | not timed | 205.59 ± 0.8% | | 1.00 | 1.12 | 9.58 |
| 06-cloud-flare-redos/simplified-long | 10000 | 217.90 ± 0.1% | not timed | not timed | 200.49 ± 1.6% | 23.02 ± 0.4% | not timed | not timed | 217.63 ± 0.3% | | 1.00 | 1.09 | 9.46 |
| 07-unicode-character-data/parse-line | 558784 | 189.13 ± 1.9% | not timed | not timed | 145.96 ± 3.7% | 36.80 ± 1.4% | not timed | not timed | 187.15 ± 2.6% | | 1.01 | 1.30 | 5.14 |
| 08-words/all-english | 56691 | 87.18 ± 0.4% | not timed | not timed | 65.01 ± 1.2% | 10.29 ± 2.7% | not timed | not timed | 86.08 ± 1.0% | | 1.01 | 1.34 | 8.47 |
| 08-words/long-english | 839 | 766.79 ± 0.9% | not timed | not timed | 453.57 ± 0.5% | 27.19 ± 7.3% | not timed | not timed | 765.60 ± 0.3% | | 1.00 | 1.69 | 28.20 |
| 09-aws-keys/full | 0 | 401.57 ± 0.4% | not timed | not timed | 415.41 ± 0.2% | 52.26 ± 4.5% | not timed | not timed | 401.60 ± 0.6% | | 1.00 | 0.97 | 7.68 |
| 09-aws-keys/quick | 0 | 770.80 ± 0.6% | not timed | not timed | 745.99 ± 0.7% | 328.03 ± 1.7% | not timed | not timed | 686.10 ± 1.2% | | 1.12 | 1.03 | 2.35 |
| 10-bounded-repeat/letters-en | 1833 | 521.89 ± 0.9% | not timed | not timed | 430.45 ± 0.5% | 17.56 ± 0.2% | not timed | not timed | 519.63 ± 1.2% | | 1.00 | 1.21 | 29.72 |
| 10-bounded-repeat/letters-ru | 3475 | 287.05 ± 0.3% | not timed | not timed | 374.98 ± 0.1% | 20.33 ± 14.3% | not timed | not timed | 285.52 ± 2.1% | | 1.01 | 0.77 | 14.12 |
| 10-bounded-repeat/context | 53 | 61.70 ± 10.1% | not timed | not timed | 54.76 ± 0.8% | 17.47 ± 1.2% | not timed | not timed | 64.33 ± 1.9% | | 0.96 | 1.13 | 3.53 |
| 10-bounded-repeat/capitals | 11 | 801.85 ± 0.6% | not timed | not timed | 469.21 ± 0.2% | 31.22 ± 0.7% | not timed | not timed | 799.75 ± 0.4% | | 1.00 | 1.71 | 25.69 |
| 11-unstructured-to-json/extract | 600 | 36.13 ± 8.0% | not timed | not timed | 62.64 ± 2.0% | 38.73 ± 1.9% | not timed | not timed | 36.38 ± 0.7% | | 0.99 | 0.58 | 0.93 |
| 12-dictionary/single | 1 | 394.80 ± 1.8% | not timed | not timed | 373.59 ± 0.1% | 0.30 ± 3.0% | not timed | not timed | 396.86 ± 0.2% | | 0.99 | 1.06 | 1303.76 |
| 14-quadratic/1x | 100 | 7.36 ± 0.2% | not timed | not timed | 9.44 ± 0.3% | 0.79 ± 1.4% | not timed | not timed | 7.23 ± 8.1% | | 1.02 | 0.78 | 9.28 |
| 14-quadratic/2x | 200 | 4.14 ± 0.4% | not timed | not timed | 4.74 ± 0.7% | 0.42 ± 2.2% | not timed | not timed | 4.13 ± 0.8% | | 1.00 | 0.87 | 9.77 |
| 14-quadratic/10x | 1000 | 0.92 ± 0.1% | not timed | not timed | 0.94 ± 0.3% | 0.09 ± 1.7% | not timed | not timed | 0.92 ± 1.4% | | 1.00 | 0.98 | 10.03 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.30 ± 0.5% | not timed | not timed | 0.37 ± 0.6% | 0.49 ± 7.0% | not timed | not timed | 1.29 ± 0.9% | | 1.01 | 3.52 | 2.66 |
| 04-ruff-noqa/compile-real | 1 | 79.44 ± 0.2% | not timed | not timed | 13.49 ± 0.6% | 129.89 ± 2.9% | not timed | not timed | 78.86 ± 1.6% | | 1.01 | 5.89 | 0.61 |
| 05-lexer-veryl/compile-single | 1 | 13.21 ± 0.4% | not timed | not timed | 2.32 ± 0.4% | 6.11 ± 2.6% | not timed | not timed | 12.96 ± 1.9% | | 1.02 | 5.68 | 2.16 |
| 07-unicode-character-data/compile | 1 | 48.93 ± 0.5% | not timed | not timed | 23.66 ± 1.0% | 34.32 ± 2.4% | not timed | not timed | 49.62 ± 0.8% | | 0.99 | 2.07 | 1.43 |
| 09-aws-keys/compile-full | 1 | 34.71 ± 0.6% | not timed | not timed | 7.76 ± 1.2% | 21.72 ± 3.1% | not timed | not timed | 34.58 ± 1.5% | | 1.00 | 4.47 | 1.60 |
| 09-aws-keys/compile-quick | 1 | 150.82 ± 0.4% | not timed | not timed | 45.12 ± 21.1% | 122.50 ± 1.5% | not timed | not timed | 149.02 ± 2.8% | | 1.01 | 3.34 | 1.23 |
| 10-bounded-repeat/compile-context | 1 | 11.81 ± 0.7% | not timed | not timed | 11.32 ± 1.0% | 15.65 ± 4.2% | not timed | not timed | 11.74 ± 1.0% | | 1.01 | 1.04 | 0.75 |
| 10-bounded-repeat/compile-capitals | 1 | 70.77 ± 1.1% | not timed | not timed | 8.29 ± 0.5% | 22.80 ± 2.0% | not timed | not timed | 70.07 ± 1.0% | | 1.01 | 8.54 | 3.10 |
| 11-unstructured-to-json/compile | 1 | 74.47 ± 15.1% | not timed | not timed | 36.63 ± 6.5% | 61.83 ± 9.1% | not timed | not timed | 75.31 ± 5.6% | | 0.99 | 2.03 | 1.20 |
| 12-dictionary/compile-single | 1 | 0.27 ± 0.3% | not timed | not timed | 0.07 ± 11.2% | 0.09 ± 21.7% | not timed | not timed | 0.27 ± 4.7% | | 1.02 | 4.07 | 3.14 |

