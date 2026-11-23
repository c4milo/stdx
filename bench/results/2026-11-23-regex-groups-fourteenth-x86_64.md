# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215450814 |
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
| literal: a word | 217 | 37955.64 ± 1.8% | 3783.75 ± 2.3% | 29.57 ± 1.7% | 36663.09 ± 8.4% | 11417.97 ± 2.5% | 12.32 ± 1.4% | 99.20 ± 4.1% | 37885.95 ± 2.4% | 10.03 | 1.00 | 1.04 | 3.32 |
| literal: a word that is not there | 0 | 55037.06 ± 4.3% | 3707.12 ± 6.7% | 29.88 ± 3.2% | 43637.04 ± 2.2% | 40765.17 ± 4.7% | 12.27 ± 2.5% | 95.13 ± 3.5% | 54765.36 ± 5.1% | 14.85 | 1.00 | 1.26 | 1.35 |
| literal: one of four words | 661 | 13327.41 ± 2.7% | 1601.01 ± 4.0% | 16.26 ± 9.3% | 10608.45 ± 5.8% | 23.96 ± 4.0% | 4.27 ± 4.1% | 8.30 ± 2.6% | 13297.51 ± 3.3% | 8.32 | 1.00 | 1.26 | 556.12 |
| literal: a word in any case | 217 | 33952.47 ± 3.4% | 1696.55 ± 2.5% | 22.75 ± 3.6% | 9603.60 ± 3.9% | 44.34 ± 8.3% | refused | differs | 33839.22 ± 1.6% | 20.01 | 1.00 | 3.54 | 765.66 |
| literal: an href attribute | 33 | 33963.26 ± 4.6% | 590.10 ± 5.0% | 28.62 ± 4.7% | 33509.64 ± 5.2% | 2919.00 ± 7.3% | 9.23 ± 4.5% | 87.89 ± 5.1% | 34283.39 ± 5.5% | 57.55 | 0.99 | 1.01 | 11.64 |
| literal: a word, second text | 123 | 42710.30 ± 4.5% | 3086.35 ± 1.8% | 29.81 ± 1.0% | 38819.19 ± 22.6% | 10364.79 ± 8.7% | 14.35 ± 1.1% | 87.50 ± 1.8% | 43353.22 ± 1.8% | 13.84 | 0.99 | 1.10 | 4.12 |
| class: two capitalized words | 1331 | 893.68 ± 4.6% | 599.17 ± 3.3% | 28.15 ± 1.5% | 568.63 ± 1.4% | 43.78 ± 3.7% | 10.84 ± 1.7% | 78.24 ± 1.7% | 892.57 ± 4.4% | 1.49 | 1.00 | 1.57 | 20.42 |
| class: a word that ends in ing | 3399 | 567.56 ± 3.5% | 563.30 ± 2.6% | 19.46 ± 3.9% | 537.51 ± 3.5% | 32.26 ± 4.2% | 6.15 ± 4.0% | 20.31 ± 14.1% | 564.51 ± 5.0% | 1.01 | 1.01 | 1.06 | 17.59 |
| class: a word in capitals | 2332 | 1132.98 ± 2.3% | 606.96 ± 3.1% | 30.31 ± 3.0% | 563.96 ± 2.8% | 47.13 ± 12.8% | 12.36 ± 1.3% | 100.69 ± 7.9% | 1129.87 ± 1.6% | 1.87 | 1.00 | 2.01 | 24.04 |
| class: a number | 8288 | 1755.52 ± 2.4% | 784.96 ± 2.9% | 29.80 ± 4.5% | 1721.72 ± 4.9% | 44.81 ± 8.8% | 0.37 ± 2.5% | 69.39 ± 6.5% | 1728.08 ± 1.8% | 2.24 | 1.02 | 1.02 | 39.17 |
| class: two capitalized words, second text | 5359 | 492.22 ± 2.8% | 492.11 ± 3.2% | 20.62 ± 5.3% | 463.81 ± 3.9% | 36.45 ± 4.7% | 12.10 ± 3.6% | 71.04 ± 3.9% | 490.48 ± 5.1% | 1.00 | 1.00 | 1.06 | 13.51 |
| other: a word between two words | 6104 | 804.59 ± 3.6% | 569.54 ± 2.8% | 24.72 ± 3.0% | 791.58 ± 2.3% | 120.69 ± 11.6% | 8.36 ± 1.4% | 80.16 ± 1.9% | 806.06 ± 2.1% | 1.41 | 1.00 | 1.02 | 6.67 |
| other: a number before a unit, second text | 1481 | 9562.38 ± 7.1% | 1020.31 ± 3.8% | 27.97 ± 5.6% | 8031.69 ± 2.4% | 44.01 ± 2.5% | 13.02 ± 3.8% | 75.29 ± 3.9% | 9508.93 ± 4.1% | 9.37 | 1.01 | 1.19 | 217.28 |
| other: a heading's start tag | 110 | 23976.87 ± 2.3% | 733.19 ± 0.7% | 30.19 ± 1.5% | 2541.96 ± 3.7% | 1962.36 ± 8.0% | 11.56 ± 2.1% | 105.65 ± 2.9% | 23842.90 ± 3.1% | 32.70 | 1.01 | 9.43 | 12.22 |
| other: a whole word | 217 | 28362.28 ± 3.8% | 594.56 ± 3.0% | 31.18 ± 3.1% | 27617.76 ± 2.3% | 53.19 ± 3.0% | 11.03 ± 1.3% | 62.44 ± 1.9% | 23992.64 ± 1.8% | 47.70 | 1.18 | 1.03 | 533.23 |
| other: a line's first word, second text | 3716 | 2469.80 ± 3.0% | 574.60 ± 3.9% | 35.01 ± 3.8% | 2272.84 ± 2.7% | 69.08 ± 5.0% | refused | refused | 2438.32 ± 1.9% | 4.30 | 1.01 | 1.09 | 35.75 |
| other: fourteen octets before an x | 87 | 35300.86 ± 3.4% | 256.44 ± 1.9% | 6.78 ± 1.3% | 3412.97 ± 1.7% | 11.18 ± 3.9% | differs | 20.87 ± 3.6% | 35070.38 ± 3.5% | 137.66 | 1.01 | 10.34 | 3156.61 |
| other: a Greek word | 21815 | 451.55 ± 2.2% | 388.38 ± 1.4% | 33.77 ± 1.0% | 296.75 ± 2.5% | 55.99 ± 7.1% | differs | refused | 450.82 ± 4.0% | 1.16 | 1.00 | 1.52 | 8.06 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 21.41 ± 2.1% | 21.62 ± 2.6% | 1.01 ± 1.4% | 19.63 ± 7.2% | 2.67 ± 1.1% | differs | 4.25 ± 12.9% | 21.48 ± 2.0% | 0.99 | 1.00 | 1.09 | 8.02 |
| a UUID | 32895 | 23.78 ± 2.9% | 23.79 ± 4.8% | 0.70 ± 4.3% | 14.90 ± 3.0% | 2.92 ± 4.7% | 0.51 ± 3.0% | 3.68 ± 3.4% | 23.61 ± 3.1% | 1.00 | 1.01 | 1.60 | 8.15 |
| an IPv4 address | 33176 | 40.15 ± 1.9% | 40.37 ± 0.6% | 2.27 ± 1.7% | 28.04 ± 1.9% | 6.91 ± 3.0% | differs | 4.12 ± 0.9% | 40.20 ± 2.9% | 0.99 | 1.00 | 1.43 | 5.81 |
| a date and time | 32954 | 34.70 ± 2.6% | 34.89 ± 1.8% | 1.63 ± 2.0% | 20.91 ± 1.6% | 7.96 ± 3.8% | 0.89 ± 1.9% | 7.44 ± 2.8% | 34.41 ± 3.1% | 0.99 | 1.01 | 1.66 | 4.36 |
| a field path | 32606 | 24.84 ± 5.4% | 25.17 ± 3.7% | 1.11 ± 2.9% | 22.58 ± 3.3% | 3.48 ± 6.6% | differs | 3.02 ± 6.2% | 24.86 ± 4.9% | 0.99 | 1.00 | 1.10 | 7.13 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.37 ± 1.5% | 10.40 ± 1.5% | 10.44 ± 3.0% | 12.63 ± 2.5% | 5.43 ± 3.1% | 0.72 ± 3.4% | none | 10.35 ± 1.8% | 1.00 | 1.00 | 0.82 | 1.91 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 223.09 ± 1.9% | 224.85 ± 2.0% | 263.06 ± 2.7% | 97.94 ± 3.5% | 231.29 ± 69.2% | 674.86 ± 7.5% | 4720.60 ± 15.1% | 226.67 ± 2.4% | 0.99 | 0.98 | 2.28 | 0.96 |
| a UUID | 62 | 147.29 ± 1.3% | 146.54 ± 2.5% | 163.51 ± 2.5% | 55.82 ± 2.9% | 111.87 ± 4.9% | 240.33 ± 3.1% | 5211.52 ± 3.4% | 145.34 ± 3.6% | 1.01 | 1.01 | 2.64 | 1.32 |
| an IPv4 address | 29 | 457.52 ± 11.2% | 459.04 ± 11.8% | 651.35 ± 10.3% | 81.57 ± 9.6% | 135.91 ± 9.9% | 380.91 ± 4.5% | 8442.36 ± 1.5% | 456.57 ± 3.0% | 1.00 | 1.00 | 5.61 | 3.37 |
| a date and time | 56 | 335.30 ± 2.0% | 338.37 ± 5.5% | 430.70 ± 6.4% | 82.30 ± 3.2% | 152.31 ± 3.7% | 460.93 ± 6.9% | 5401.03 ± 1.3% | 333.78 ± 3.2% | 0.99 | 1.00 | 4.07 | 2.20 |
| a field path | 39 | 215.29 ± 3.8% | 218.18 ± 5.7% | 253.81 ± 3.2% | 90.04 ± 7.8% | 219.23 ± 5.0% | 704.59 ± 4.5% | 5803.09 ± 5.1% | 222.43 ± 5.5% | 0.99 | 0.97 | 2.39 | 0.98 |
| literal: a word | 7 | 721.56 ± 1.9% | 765.71 ± 4.3% | 1387.26 ± 3.0% | 609.89 ± 2.0% | 750.94 ± 3.2% | 1582.53 ± 4.5% | 33015.48 ± 2.7% | 727.41 ± 2.7% | 0.94 | 0.99 | 1.18 | 0.96 |
| literal: a word that is not there | 8 | 669.18 ± 4.0% | 713.24 ± 3.9% | 1259.59 ± 4.8% | 569.82 ± 3.1% | 701.12 ± 4.7% | 1418.08 ± 3.7% | 31329.29 ± 3.7% | 672.23 ± 4.8% | 0.94 | 1.00 | 1.17 | 0.95 |
| literal: one of four words | 26 | 255.82 ± 9.4% | 431.31 ± 1.9% | 573.90 ± 4.9% | 51.62 ± 1.9% | 278.20 ± 2.9% | 549.86 ± 4.2% | 17346.51 ± 3.0% | 252.50 ± 8.4% | 0.59 | 1.01 | 4.96 | 0.92 |
| literal: a word in any case | 11 | 492.91 ± 2.2% | 517.10 ± 3.0% | 738.67 ± 2.4% | 17.94 ± 5.9% | 778.47 ± 4.4% | refused | 26012.27 ± 3.3% | 483.80 ± 2.2% | 0.95 | 1.02 | 27.48 | 0.63 |
| literal: an href attribute | 12 | 370.54 ± 2.7% | 383.68 ± 3.7% | 506.82 ± 1.5% | 47.37 ± 1.8% | 519.54 ± 4.7% | 1193.58 ± 2.3% | 22823.55 ± 1.3% | 369.31 ± 1.2% | 0.97 | 1.00 | 7.82 | 0.71 |
| literal: a word, second text | 10 | 639.51 ± 4.4% | 685.58 ± 4.8% | 1151.47 ± 4.2% | 508.13 ± 1.8% | 627.49 ± 27.9% | 1303.75 ± 3.3% | 30542.88 ± 3.1% | 634.14 ± 2.4% | 0.93 | 1.01 | 1.26 | 1.02 |
| class: two capitalized words | 23 | 495.22 ± 3.3% | 538.66 ± 3.2% | 784.23 ± 4.4% | 116.93 ± 3.3% | 567.73 ± 20.6% | 1168.25 ± 3.1% | 7917.63 ± 2.3% | 495.98 ± 2.7% | 0.92 | 1.00 | 4.24 | 0.87 |
| class: a word that ends in ing | 9 | 620.10 ± 4.5% | 686.12 ± 3.0% | 1221.86 ± 3.5% | 145.20 ± 4.2% | 823.50 ± 3.5% | 1757.98 ± 11.3% | 18320.75 ± 4.7% | 617.21 ± 6.7% | 0.90 | 1.00 | 4.27 | 0.75 |
| class: a word in capitals | 16 | 541.76 ± 4.7% | 585.02 ± 2.7% | 954.61 ± 1.4% | 150.19 ± 3.8% | 847.88 ± 5.6% | 1668.74 ± 2.7% | 10315.00 ± 3.6% | 543.34 ± 4.4% | 0.93 | 1.00 | 3.61 | 0.64 |
| class: a number | 6 | 682.21 ± 3.0% | 750.94 ± 2.5% | 1461.46 ± 1.5% | 45.45 ± 2.5% | 1536.32 ± 2.2% | 2916.44 ± 5.1% | 24805.81 ± 0.7% | 677.77 ± 3.0% | 0.91 | 1.01 | 15.01 | 0.44 |
| class: two capitalized words, second text | 23 | 499.10 ± 2.7% | 541.10 ± 2.1% | 792.90 ± 2.1% | 118.59 ± 2.0% | 565.59 ± 6.1% | 1228.52 ± 1.9% | 7968.76 ± 2.3% | 504.05 ± 3.5% | 0.92 | 0.99 | 4.21 | 0.88 |
| other: a word between two words | 13 | 623.53 ± 3.6% | 644.23 ± 1.8% | 1005.11 ± 2.1% | 153.88 ± 1.8% | 547.96 ± 8.0% | 1307.98 ± 15.2% | 17670.24 ± 3.7% | 616.84 ± 15.9% | 0.97 | 1.01 | 4.05 | 1.14 |
| other: a number before a unit, second text | 15 | 430.72 ± 1.1% | 483.54 ± 1.8% | 667.65 ± 1.4% | 43.76 ± 2.8% | 701.59 ± 34.4% | 1424.10 ± 1.9% | 17643.55 ± 0.8% | 431.24 ± 1.6% | 0.89 | 1.00 | 9.84 | 0.61 |
| other: a heading's start tag | 13 | 400.99 ± 2.9% | 410.22 ± 3.9% | 544.45 ± 1.9% | 47.82 ± 1.6% | 687.66 ± 26.2% | 1343.55 ± 3.0% | 20472.28 ± 2.6% | 404.66 ± 3.9% | 0.98 | 0.99 | 8.39 | 0.58 |
| other: a whole word | 11 | 642.58 ± 2.3% | 670.74 ± 3.9% | 1105.24 ± 3.5% | 140.85 ± 2.4% | 653.31 ± 4.3% | 1331.78 ± 1.3% | 31522.91 ± 1.3% | 638.91 ± 2.3% | 0.96 | 1.01 | 4.56 | 0.98 |
| other: a line's first word, second text | 17 | 581.36 ± 8.9% | 610.17 ± 2.6% | 997.15 ± 0.8% | 145.34 ± 3.3% | 769.13 ± 24.0% | refused | refused | 575.46 ± 13.3% | 0.95 | 1.01 | 4.00 | 0.76 |
| other: fourteen octets before an x | 16 | 114.11 ± 2.8% | 167.72 ± 5.6% | 192.74 ± 15.5% | 17.06 ± 4.8% | 491.86 ± 8.9% | 563.59 ± 2.6% | 15372.81 ± 1.2% | 114.12 ± 4.0% | 0.68 | 1.00 | 6.69 | 0.23 |
| other: a Greek word | 8 | 445.33 ± 1.9% | 645.23 ± 2.3% | 1058.10 ± 1.8% | 61.66 ± 1.2% | 1524.04 ± 6.2% | 2764.67 ± 8.7% | refused | 412.36 ± 7.9% | 0.69 | 1.08 | 7.22 | 0.29 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 28634.25 ± 2.7% | not timed | not timed | 33056.13 ± 3.1% | 2698.35 ± 5.3% | not timed | not timed | 28381.85 ± 1.9% | | 1.01 | 0.87 | 10.61 |
| 01-literal/sherlock-casei-en | 522 | 10375.36 ± 2.9% | not timed | not timed | 8903.15 ± 5.1% | 32.94 ± 6.3% | not timed | not timed | 10450.97 ± 4.6% | | 0.99 | 1.17 | 314.97 |
| 01-literal/sherlock-ru | 724 | 30401.51 ± 4.1% | not timed | not timed | 34331.51 ± 5.0% | 1241.90 ± 17.3% | not timed | not timed | 30202.76 ± 1.1% | | 1.01 | 0.89 | 24.48 |
| 01-literal/sherlock-casei-ru | 746 | 11825.98 ± 1.3% | not timed | not timed | 7678.24 ± 2.1% | 37.39 ± 2.0% | not timed | not timed | 11855.27 ± 13.7% | | 1.00 | 1.54 | 316.31 |
| 01-literal/sherlock-zh | 30 | 53018.39 ± 15.1% | not timed | not timed | 43049.42 ± 3.2% | 1634.57 ± 0.7% | not timed | not timed | 52843.71 ± 15.8% | | 1.00 | 1.23 | 32.44 |
| 02-literal-alternate/sherlock-en | 714 | 12375.11 ± 2.1% | not timed | not timed | 10859.75 ± 3.0% | 18.82 ± 6.4% | not timed | not timed | 12294.40 ± 2.9% | | 1.01 | 1.14 | 657.53 |
| 02-literal-alternate/sherlock-casei-en | 725 | 4694.15 ± 5.8% | not timed | not timed | 2234.88 ± 13.3% | 12.10 ± 3.6% | not timed | not timed | 4356.14 ± 1.9% | | 1.08 | 2.10 | 387.84 |
| 02-literal-alternate/sherlock-ru | 899 | 10218.07 ± 2.2% | not timed | not timed | 9714.99 ± 3.0% | 25.11 ± 4.0% | not timed | not timed | 10170.18 ± 2.5% | | 1.00 | 1.05 | 406.89 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2452.78 ± 5.2% | not timed | not timed | 1156.35 ± 2.6% | 10.21 ± 4.3% | not timed | not timed | 2363.60 ± 3.4% | | 1.04 | 2.12 | 240.28 |
| 02-literal-alternate/sherlock-zh | 207 | 17694.98 ± 2.4% | not timed | not timed | 12235.62 ± 3.1% | 34.37 ± 4.9% | not timed | not timed | 17482.07 ± 5.4% | | 1.01 | 1.45 | 514.84 |
| 03-date/ascii | 111817 | 126.16 ± 1.8% | not timed | not timed | 99.85 ± 2.9% | 0.22 ± 3.5% | not timed | not timed | 123.56 ± 5.7% | | 1.02 | 1.26 | 565.03 |
| 04-ruff-noqa/real | 84 | 470.64 ± 3.4% | not timed | not timed | 489.72 ± 4.7% | 19.29 ± 3.6% | not timed | not timed | 469.29 ± 4.2% | | 1.00 | 0.96 | 24.39 |
| 04-ruff-noqa/tweaked | 44 | 578.49 ± 1.2% | not timed | not timed | 487.12 ± 1.5% | 359.29 ± 2.6% | not timed | not timed | 578.19 ± 1.1% | | 1.00 | 1.19 | 1.61 |
| 05-lexer-veryl/single | 124800 | 4.55 ± 3.7% | not timed | not timed | 4.96 ± 2.2% | 0.25 ± 1.4% | not timed | not timed | 4.52 ± 3.0% | | 1.01 | 0.92 | 18.24 |
| 06-cloud-flare-redos/original | 107 | 396.31 ± 3.8% | not timed | not timed | 215.80 ± 19.3% | 24.37 ± 4.1% | not timed | not timed | 364.08 ± 3.3% | | 1.09 | 1.84 | 16.26 |
| 06-cloud-flare-redos/simplified-short | 102 | 385.80 ± 3.6% | not timed | not timed | 231.61 ± 2.9% | 26.46 ± 1.4% | not timed | not timed | 386.41 ± 3.4% | | 1.00 | 1.67 | 14.58 |
| 06-cloud-flare-redos/simplified-long | 10000 | 502.04 ± 3.3% | not timed | not timed | 254.26 ± 4.5% | 28.71 ± 2.8% | not timed | not timed | 497.64 ± 3.2% | | 1.01 | 1.97 | 17.49 |
| 07-unicode-character-data/parse-line | 558784 | 211.06 ± 1.7% | not timed | not timed | 197.20 ± 1.6% | 45.80 ± 9.0% | not timed | not timed | 238.25 ± 4.8% | | 0.89 | 1.07 | 4.61 |
| 08-words/all-english | 56691 | 109.29 ± 4.8% | not timed | not timed | 82.71 ± 2.6% | 14.54 ± 9.4% | not timed | not timed | 108.57 ± 1.3% | | 1.01 | 1.32 | 7.52 |
| 08-words/long-english | 839 | 602.41 ± 2.0% | not timed | not timed | 577.16 ± 2.8% | 34.28 ± 3.5% | not timed | not timed | 599.78 ± 0.9% | | 1.00 | 1.04 | 17.57 |
| 09-aws-keys/full | 0 | 479.28 ± 13.2% | not timed | not timed | 537.93 ± 6.7% | 60.77 ± 3.9% | not timed | not timed | 476.03 ± 2.3% | | 1.01 | 0.89 | 7.89 |
| 09-aws-keys/quick | 0 | 867.17 ± 4.0% | not timed | not timed | 921.08 ± 10.9% | 397.77 ± 4.4% | not timed | not timed | 862.43 ± 8.3% | | 1.01 | 0.94 | 2.18 |
| 10-bounded-repeat/letters-en | 1833 | 645.25 ± 2.7% | not timed | not timed | 532.77 ± 2.9% | 21.38 ± 1.8% | not timed | not timed | 640.43 ± 3.0% | | 1.01 | 1.21 | 30.18 |
| 10-bounded-repeat/letters-ru | 3475 | 491.34 ± 3.1% | not timed | not timed | 445.14 ± 3.0% | 22.80 ± 15.7% | not timed | not timed | 492.20 ± 3.5% | | 1.00 | 1.10 | 21.55 |
| 10-bounded-repeat/context | 53 | 74.17 ± 6.1% | not timed | not timed | 65.06 ± 6.3% | 20.83 ± 4.0% | not timed | not timed | 74.66 ± 5.5% | | 0.99 | 1.14 | 3.56 |
| 10-bounded-repeat/capitals | 11 | 597.36 ± 9.8% | not timed | not timed | 556.56 ± 4.3% | 37.67 ± 2.1% | not timed | not timed | 609.97 ± 8.9% | | 0.98 | 1.07 | 15.86 |
| 11-unstructured-to-json/extract | 600 | 59.95 ± 3.5% | not timed | not timed | 75.28 ± 3.6% | 47.18 ± 4.7% | not timed | not timed | 59.03 ± 4.2% | | 1.02 | 0.80 | 1.27 |
| 12-dictionary/single | 1 | 485.35 ± 3.1% | not timed | not timed | 452.06 ± 2.7% | 0.37 ± 3.8% | not timed | not timed | 486.65 ± 0.8% | | 1.00 | 1.07 | 1294.58 |
| 14-quadratic/1x | 100 | 24.62 ± 3.4% | not timed | not timed | 11.43 ± 6.4% | 0.92 ± 12.1% | not timed | not timed | 24.36 ± 1.6% | | 1.01 | 2.16 | 26.68 |
| 14-quadratic/2x | 200 | 18.60 ± 4.7% | not timed | not timed | 5.73 ± 4.5% | 0.49 ± 5.0% | not timed | not timed | 18.45 ± 3.9% | | 1.01 | 3.25 | 37.99 |
| 14-quadratic/10x | 1000 | 6.54 ± 2.5% | not timed | not timed | 1.16 ± 3.4% | 0.11 ± 3.4% | not timed | not timed | 6.55 ± 2.3% | | 1.00 | 5.65 | 59.84 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.34 ± 8.7% | not timed | not timed | 0.45 ± 3.9% | 0.56 ± 8.1% | not timed | not timed | 1.32 ± 1.3% | | 1.01 | 3.00 | 2.39 |
| 04-ruff-noqa/compile-real | 1 | 92.67 ± 1.9% | not timed | not timed | 16.09 ± 3.5% | 145.55 ± 21.5% | not timed | not timed | 91.68 ± 6.4% | | 1.01 | 5.76 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 14.78 ± 6.6% | not timed | not timed | 2.78 ± 18.7% | 6.99 ± 18.0% | not timed | not timed | 14.89 ± 4.7% | | 0.99 | 5.32 | 2.11 |
| 07-unicode-character-data/compile | 1 | 57.91 ± 14.3% | not timed | not timed | 28.95 ± 2.7% | 39.35 ± 6.5% | not timed | not timed | 57.58 ± 3.7% | | 1.01 | 2.00 | 1.47 |
| 09-aws-keys/compile-full | 1 | 41.47 ± 3.0% | not timed | not timed | 9.43 ± 2.7% | 25.82 ± 4.6% | not timed | not timed | 40.87 ± 4.1% | | 1.01 | 4.40 | 1.61 |
| 09-aws-keys/compile-quick | 1 | 181.88 ± 2.1% | not timed | not timed | 54.68 ± 4.5% | 141.79 ± 17.5% | not timed | not timed | 176.77 ± 4.7% | | 1.03 | 3.33 | 1.28 |
| 10-bounded-repeat/compile-context | 1 | 14.02 ± 17.1% | not timed | not timed | 13.66 ± 3.8% | 18.50 ± 4.3% | not timed | not timed | 13.95 ± 9.3% | | 1.01 | 1.03 | 0.76 |
| 10-bounded-repeat/compile-capitals | 1 | 86.50 ± 3.0% | not timed | not timed | 10.15 ± 4.6% | 25.95 ± 8.8% | not timed | not timed | 87.89 ± 5.3% | | 0.98 | 8.53 | 3.33 |
| 11-unstructured-to-json/compile | 1 | 90.45 ± 3.1% | not timed | not timed | 46.07 ± 1.9% | 71.93 ± 11.7% | not timed | not timed | 90.55 ± 4.0% | | 1.00 | 1.96 | 1.26 |
| 12-dictionary/compile-single | 1 | 0.33 ± 3.1% | not timed | not timed | 0.08 ± 2.8% | 0.10 ± 13.8% | not timed | not timed | 0.33 ± 14.7% | | 1.01 | 4.30 | 3.31 |

