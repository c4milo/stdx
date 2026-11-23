# bench-regex

| Field | Value |
|---|---|
| Commit | a281f4c |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45215468936 |
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
| literal: a word | 217 | 33510.68 ± 8.7% | 3358.66 ± 0.3% | 20.09 ± 0.3% | 31031.90 ± 1.4% | 8906.20 ± 10.6% | 10.73 ± 0.5% | 76.39 ± 1.0% | 32946.21 ± 0.8% | 9.98 | 1.02 | 1.08 | 3.76 |
| literal: a word that is not there | 0 | 49854.72 ± 8.0% | 3252.09 ± 0.4% | 19.97 ± 0.2% | 39401.27 ± 0.5% | 30133.27 ± 0.7% | 10.70 ± 0.1% | 72.23 ± 0.7% | 49091.95 ± 1.0% | 15.33 | 1.02 | 1.27 | 1.65 |
| literal: one of four words | 661 | 11105.92 ± 0.9% | 1400.76 ± 0.9% | 10.92 ± 0.2% | 9101.52 ± 0.4% | 19.16 ± 1.8% | 3.95 ± 0.1% | 6.66 ± 0.6% | 11054.46 ± 0.7% | 7.93 | 1.00 | 1.22 | 579.79 |
| literal: a word in any case | 217 | 26064.83 ± 3.9% | 1496.75 ± 2.9% | 15.43 ± 7.4% | 9218.68 ± 0.2% | 37.23 ± 0.3% | refused | differs | 25689.23 ± 1.3% | 17.41 | 1.01 | 2.83 | 700.15 |
| literal: an href attribute | 33 | 26814.02 ± 5.6% | 538.35 ± 0.2% | 18.61 ± 0.5% | 27171.44 ± 1.4% | 2051.23 ± 0.9% | 8.24 ± 0.7% | 61.42 ± 1.7% | 26598.02 ± 2.5% | 49.81 | 1.01 | 0.99 | 13.07 |
| literal: a word, second text | 123 | 33798.14 ± 3.2% | 2389.15 ± 0.5% | 19.97 ± 0.5% | 31460.22 ± 6.3% | 7136.15 ± 6.8% | 11.70 ± 0.5% | 64.69 ± 1.6% | 32963.81 ± 1.7% | 14.15 | 1.03 | 1.07 | 4.74 |
| class: two capitalized words | 1331 | 769.57 ± 0.4% | 524.57 ± 0.5% | 18.61 ± 0.7% | 506.13 ± 0.1% | 34.16 ± 7.0% | 9.36 ± 0.1% | 55.59 ± 1.5% | 769.84 ± 2.0% | 1.47 | 1.00 | 1.52 | 22.53 |
| class: a word that ends in ing | 3399 | 498.07 ± 0.4% | 497.65 ± 1.6% | 12.97 ± 0.2% | 471.22 ± 0.8% | 25.63 ± 5.7% | 5.32 ± 0.5% | 17.02 ± 1.6% | 497.53 ± 0.8% | 1.00 | 1.00 | 1.06 | 19.43 |
| class: a word in capitals | 2332 | 953.06 ± 3.3% | 529.82 ± 0.5% | 19.68 ± 0.7% | 497.96 ± 1.0% | 36.45 ± 14.1% | 10.46 ± 0.5% | 76.31 ± 0.7% | 951.13 ± 0.1% | 1.80 | 1.00 | 1.91 | 26.14 |
| class: a number | 8288 | 1449.34 ± 0.2% | 695.16 ± 1.9% | 19.62 ± 1.2% | 1481.00 ± 0.4% | 35.29 ± 11.7% | 0.33 ± 0.2% | 55.73 ± 0.3% | 1443.12 ± 0.5% | 2.08 | 1.00 | 0.98 | 41.07 |
| class: two capitalized words, second text | 5359 | 440.47 ± 1.0% | 447.46 ± 0.3% | 15.56 ± 0.2% | 416.45 ± 0.4% | 30.17 ± 18.5% | 10.61 ± 0.3% | 51.63 ± 0.5% | 441.75 ± 0.5% | 0.98 | 1.00 | 1.06 | 14.60 |
| other: a word between two words | 6104 | 686.25 ± 7.4% | 509.43 ± 0.2% | 16.82 ± 0.3% | 694.34 ± 0.5% | 100.24 ± 10.4% | 7.25 ± 0.1% | 56.57 ± 0.7% | 684.77 ± 0.3% | 1.35 | 1.00 | 0.99 | 6.85 |
| other: a number before a unit, second text | 1481 | 7005.87 ± 1.2% | 861.27 ± 0.5% | 18.82 ± 2.6% | 6439.15 ± 0.9% | 35.14 ± 7.6% | 11.03 ± 0.1% | 55.07 ± 0.9% | 6995.36 ± 0.8% | 8.13 | 1.00 | 1.09 | 199.39 |
| other: a heading's start tag | 110 | 18675.37 ± 8.7% | 653.18 ± 0.2% | 19.46 ± 0.4% | 2003.19 ± 0.3% | 1447.76 ± 15.6% | 9.98 ± 0.7% | 72.65 ± 0.5% | 17959.69 ± 1.5% | 28.59 | 1.04 | 9.32 | 12.90 |
| other: a whole word | 217 | 23388.39 ± 17.0% | 530.30 ± 0.1% | 20.57 ± 0.9% | 22550.72 ± 0.8% | 39.94 ± 0.4% | 9.47 ± 0.8% | 46.92 ± 1.1% | 22816.08 ± 2.4% | 44.10 | 1.03 | 1.04 | 585.52 |
| other: a line's first word, second text | 3716 | 1887.32 ± 3.9% | 512.85 ± 0.2% | 24.21 ± 5.1% | 1697.88 ± 3.1% | 53.18 ± 5.0% | refused | refused | 1888.36 ± 0.7% | 3.68 | 1.00 | 1.11 | 35.49 |
| other: fourteen octets before an x | 87 | 26028.55 ± 3.8% | 204.44 ± 1.0% | 5.23 ± 0.4% | 2728.00 ± 0.5% | 8.98 ± 0.7% | differs | 15.48 ± 3.6% | 25543.26 ± 2.3% | 127.32 | 1.02 | 9.54 | 2897.38 |
| other: a Greek word | 21815 | 387.14 ± 0.5% | 334.47 ± 0.1% | 23.99 ± 5.0% | 265.05 ± 0.3% | 38.68 ± 17.8% | differs | refused | 384.09 ± 0.4% | 1.16 | 1.01 | 1.46 | 10.01 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 18.61 ± 0.6% | 18.62 ± 0.3% | 0.79 ± 0.3% | 16.99 ± 0.5% | 2.33 ± 1.3% | differs | 3.61 ± 12.4% | 18.62 ± 0.4% | 1.00 | 1.00 | 1.10 | 7.97 |
| a UUID | 32895 | 20.34 ± 9.8% | 20.16 ± 0.2% | 0.55 ± 0.4% | 12.87 ± 1.6% | 2.51 ± 2.1% | 0.43 ± 0.7% | 3.10 ± 1.0% | 20.39 ± 0.3% | 1.01 | 1.00 | 1.58 | 8.10 |
| an IPv4 address | 33176 | 33.91 ± 2.5% | 33.98 ± 2.2% | 1.74 ± 4.2% | 15.11 ± 3.0% | 5.76 ± 3.1% | differs | 3.41 ± 3.2% | 34.09 ± 2.4% | 1.00 | 0.99 | 2.24 | 5.88 |
| a date and time | 32954 | 30.02 ± 0.7% | 30.05 ± 0.3% | 1.23 ± 0.4% | 18.10 ± 0.2% | 6.69 ± 7.8% | 0.75 ± 1.7% | 6.13 ± 11.1% | 30.25 ± 1.0% | 1.00 | 0.99 | 1.66 | 4.49 |
| a field path | 32606 | 21.75 ± 0.7% | 21.80 ± 1.1% | 0.90 ± 0.7% | 19.65 ± 5.0% | 2.93 ± 1.4% | differs | 2.46 ± 0.9% | 21.80 ± 0.1% | 1.00 | 1.00 | 1.11 | 7.44 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.63 ± 3.2% | 8.78 ± 3.0% | 8.80 ± 2.9% | 10.62 ± 6.3% | 4.75 ± 2.6% | 0.62 ± 0.2% | none | 8.76 ± 1.4% | 0.98 | 0.99 | 0.81 | 1.82 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 183.85 ± 0.6% | 184.51 ± 0.5% | 215.37 ± 0.7% | 78.65 ± 3.3% | 184.59 ± 5.4% | 542.41 ± 3.6% | 3974.00 ± 14.0% | 183.66 ± 0.4% | 1.00 | 1.00 | 2.34 | 1.00 |
| a UUID | 62 | 121.03 ± 0.3% | 121.28 ± 0.4% | 135.20 ± 0.3% | 46.40 ± 1.2% | 89.14 ± 2.3% | 193.91 ± 3.4% | 4135.29 ± 0.3% | 120.55 ± 0.6% | 1.00 | 1.00 | 2.61 | 1.36 |
| an IPv4 address | 29 | 376.75 ± 1.2% | 378.82 ± 1.1% | 533.78 ± 1.5% | 69.51 ± 0.6% | 113.49 ± 5.3% | 324.99 ± 1.9% | 7135.70 ± 12.3% | 376.90 ± 1.9% | 0.99 | 1.00 | 5.42 | 3.32 |
| a date and time | 56 | 272.45 ± 0.4% | 273.15 ± 0.4% | 342.84 ± 1.3% | 67.95 ± 0.7% | 120.25 ± 11.2% | 370.19 ± 1.4% | 4250.65 ± 0.5% | 272.19 ± 1.2% | 1.00 | 1.00 | 4.01 | 2.27 |
| a field path | 39 | 183.56 ± 0.6% | 183.78 ± 0.2% | 214.22 ± 0.5% | 74.40 ± 2.7% | 173.38 ± 6.7% | 627.13 ± 6.6% | 4737.95 ± 2.3% | 183.15 ± 0.9% | 1.00 | 1.00 | 2.47 | 1.06 |
| literal: a word | 7 | 572.33 ± 0.6% | 612.28 ± 0.5% | 1098.89 ± 1.0% | 488.84 ± 1.5% | 572.83 ± 16.5% | 1266.34 ± 0.7% | 25027.21 ± 0.3% | 572.82 ± 1.2% | 0.93 | 1.00 | 1.17 | 1.00 |
| literal: a word that is not there | 8 | 551.45 ± 0.5% | 596.36 ± 0.7% | 1026.50 ± 0.8% | 452.63 ± 0.7% | 550.03 ± 18.6% | 1185.46 ± 0.4% | 23916.00 ± 0.8% | 551.03 ± 0.9% | 0.92 | 1.00 | 1.22 | 1.00 |
| literal: one of four words | 26 | 203.45 ± 0.5% | 339.93 ± 1.0% | 452.16 ± 1.5% | 41.58 ± 13.6% | 217.02 ± 2.1% | 444.67 ± 6.9% | 11400.64 ± 1.3% | 203.04 ± 0.7% | 0.60 | 1.00 | 4.89 | 0.94 |
| literal: a word in any case | 11 | 393.64 ± 7.2% | 412.05 ± 0.7% | 597.47 ± 0.4% | 14.19 ± 0.6% | 607.24 ± 1.9% | refused | 19522.12 ± 0.4% | 393.83 ± 0.9% | 0.96 | 1.00 | 27.74 | 0.65 |
| literal: an href attribute | 12 | 307.99 ± 0.4% | 318.21 ± 0.3% | 419.26 ± 1.2% | 35.96 ± 3.3% | 429.07 ± 2.3% | 951.91 ± 2.6% | 18872.16 ± 0.8% | 307.85 ± 0.3% | 0.97 | 1.00 | 8.57 | 0.72 |
| literal: a word, second text | 10 | 509.52 ± 0.7% | 555.08 ± 1.7% | 928.21 ± 0.5% | 404.81 ± 1.4% | 483.01 ± 3.3% | 989.85 ± 0.9% | 21601.25 ± 0.7% | 509.08 ± 12.5% | 0.92 | 1.00 | 1.26 | 1.05 |
| class: two capitalized words | 23 | 401.94 ± 2.0% | 431.07 ± 5.9% | 636.93 ± 7.8% | 94.49 ± 2.7% | 449.89 ± 4.9% | 930.79 ± 1.8% | 6387.65 ± 0.3% | 401.84 ± 1.3% | 0.93 | 1.00 | 4.25 | 0.89 |
| class: a word that ends in ing | 9 | 494.45 ± 2.8% | 552.69 ± 0.7% | 991.64 ± 0.7% | 113.04 ± 1.0% | 624.37 ± 6.4% | 1383.74 ± 1.7% | 15146.28 ± 1.6% | 494.91 ± 1.3% | 0.89 | 1.00 | 4.37 | 0.79 |
| class: a word in capitals | 16 | 420.46 ± 0.3% | 452.49 ± 1.0% | 760.77 ± 1.1% | 120.72 ± 1.0% | 639.12 ± 8.3% | 1261.51 ± 3.3% | 8374.18 ± 0.9% | 419.65 ± 1.8% | 0.93 | 1.00 | 3.48 | 0.66 |
| class: a number | 6 | 534.77 ± 0.4% | 588.38 ± 0.7% | 1151.08 ± 1.3% | 36.04 ± 1.9% | 1174.72 ± 1.8% | 2226.95 ± 1.6% | 20404.78 ± 9.1% | 535.24 ± 1.2% | 0.91 | 1.00 | 14.84 | 0.46 |
| class: two capitalized words, second text | 23 | 401.89 ± 8.9% | 432.86 ± 2.3% | 626.47 ± 13.1% | 95.30 ± 28.7% | 445.75 ± 2.4% | 944.40 ± 9.8% | 6384.69 ± 2.5% | 401.24 ± 1.7% | 0.93 | 1.00 | 4.22 | 0.90 |
| other: a word between two words | 13 | 489.20 ± 0.6% | 505.06 ± 0.5% | 807.60 ± 8.9% | 121.34 ± 0.6% | 433.60 ± 3.4% | 1035.08 ± 1.2% | 14063.09 ± 1.1% | 488.57 ± 1.2% | 0.97 | 1.00 | 4.03 | 1.13 |
| other: a number before a unit, second text | 15 | 347.14 ± 7.7% | 387.57 ± 2.6% | 547.11 ± 2.6% | 33.33 ± 5.1% | 521.38 ± 8.8% | 1139.35 ± 7.9% | 13876.11 ± 4.2% | 351.53 ± 2.5% | 0.90 | 0.99 | 10.42 | 0.67 |
| other: a heading's start tag | 13 | 319.20 ± 1.0% | 324.06 ± 1.0% | 433.62 ± 0.7% | 35.10 ± 0.8% | 523.25 ± 1.9% | 1080.76 ± 2.7% | 16308.20 ± 2.5% | 318.48 ± 0.3% | 0.99 | 1.00 | 9.09 | 0.61 |
| other: a whole word | 11 | 487.90 ± 0.4% | 517.70 ± 1.4% | 832.42 ± 1.0% | 109.89 ± 1.6% | 499.51 ± 2.1% | 1044.13 ± 0.6% | 21006.16 ± 1.5% | 488.31 ± 0.5% | 0.94 | 1.00 | 4.44 | 0.98 |
| other: a line's first word, second text | 17 | 468.25 ± 1.2% | 486.67 ± 1.2% | 812.08 ± 0.7% | 114.99 ± 1.3% | 587.48 ± 1.7% | refused | refused | 465.53 ± 0.9% | 0.96 | 1.01 | 4.07 | 0.80 |
| other: fourteen octets before an x | 16 | 86.62 ± 9.8% | 121.63 ± 0.5% | 140.55 ± 2.5% | 14.08 ± 0.3% | 395.15 ± 1.6% | 448.79 ± 1.1% | 11702.06 ± 0.8% | 86.65 ± 0.5% | 0.71 | 1.00 | 6.15 | 0.22 |
| other: a Greek word | 8 | 360.96 ± 0.6% | 504.57 ± 0.4% | 874.41 ± 0.3% | 47.10 ± 2.0% | 1153.39 ± 1.8% | 2261.56 ± 0.7% | refused | 360.81 ± 0.4% | 0.72 | 1.00 | 7.66 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 21783.12 ± 1.5% | not timed | not timed | 27073.47 ± 0.6% | 1966.14 ± 10.1% | not timed | not timed | 21707.57 ± 1.0% | | 1.00 | 0.80 | 11.08 |
| 01-literal/sherlock-casei-en | 522 | 7641.21 ± 1.0% | not timed | not timed | 7046.55 ± 0.2% | 28.59 ± 0.8% | not timed | not timed | 7570.55 ± 1.1% | | 1.01 | 1.08 | 267.28 |
| 01-literal/sherlock-ru | 724 | 23427.60 ± 1.5% | not timed | not timed | 27912.60 ± 0.9% | 1065.23 ± 2.6% | not timed | not timed | 23251.08 ± 2.2% | | 1.01 | 0.84 | 21.99 |
| 01-literal/sherlock-casei-ru | 746 | 9406.28 ± 0.7% | not timed | not timed | 5530.36 ± 0.2% | 30.47 ± 1.2% | not timed | not timed | 9394.35 ± 0.3% | | 1.00 | 1.70 | 308.76 |
| 01-literal/sherlock-zh | 30 | 42656.39 ± 1.8% | not timed | not timed | 36677.33 ± 0.6% | 1261.50 ± 1.3% | not timed | not timed | 42157.44 ± 1.2% | | 1.01 | 1.16 | 33.81 |
| 02-literal-alternate/sherlock-en | 714 | 9573.30 ± 3.0% | not timed | not timed | 8918.18 ± 10.2% | 14.73 ± 5.2% | not timed | not timed | 9568.23 ± 0.8% | | 1.00 | 1.07 | 649.77 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1988.21 ± 5.3% | not timed | not timed | 1817.15 ± 0.5% | 9.54 ± 0.7% | not timed | not timed | 1965.90 ± 0.2% | | 1.01 | 1.09 | 208.45 |
| 02-literal-alternate/sherlock-ru | 899 | 7814.95 ± 1.3% | not timed | not timed | 4267.01 ± 0.2% | 19.66 ± 1.1% | not timed | not timed | 7781.41 ± 12.1% | | 1.00 | 1.83 | 397.45 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2064.44 ± 0.2% | not timed | not timed | 1034.57 ± 0.1% | 8.53 ± 6.5% | not timed | not timed | 2063.40 ± 0.7% | | 1.00 | 2.00 | 241.95 |
| 02-literal-alternate/sherlock-zh | 207 | 13932.31 ± 0.4% | not timed | not timed | 10458.38 ± 0.2% | 27.22 ± 2.4% | not timed | not timed | 13923.48 ± 12.9% | | 1.00 | 1.33 | 511.83 |
| 03-date/ascii | 111817 | 95.88 ± 0.8% | not timed | not timed | 85.16 ± 0.6% | 0.18 ± 2.2% | not timed | not timed | 96.27 ± 1.2% | | 1.00 | 1.13 | 540.13 |
| 04-ruff-noqa/real | 84 | 418.20 ± 0.4% | not timed | not timed | 427.04 ± 3.6% | 15.98 ± 1.9% | not timed | not timed | 418.50 ± 1.7% | | 1.00 | 0.98 | 26.18 |
| 04-ruff-noqa/tweaked | 44 | 473.20 ± 0.8% | not timed | not timed | 417.55 ± 0.4% | 294.27 ± 7.1% | not timed | not timed | 473.56 ± 0.2% | | 1.00 | 1.13 | 1.61 |
| 05-lexer-veryl/single | 124800 | 3.26 ± 4.4% | not timed | not timed | 4.06 ± 1.3% | 0.21 ± 5.2% | not timed | not timed | 3.30 ± 2.8% | | 0.99 | 0.80 | 15.15 |
| 06-cloud-flare-redos/original | 107 | 335.17 ± 0.9% | not timed | not timed | 191.09 ± 5.5% | 20.10 ± 0.3% | not timed | not timed | 335.38 ± 0.5% | | 1.00 | 1.75 | 16.68 |
| 06-cloud-flare-redos/simplified-short | 102 | 333.22 ± 7.5% | not timed | not timed | 192.41 ± 12.7% | 21.74 ± 0.6% | not timed | not timed | 332.68 ± 0.4% | | 1.00 | 1.73 | 15.33 |
| 06-cloud-flare-redos/simplified-long | 10000 | 464.70 ± 0.1% | not timed | not timed | 211.58 ± 6.3% | 24.15 ± 5.6% | not timed | not timed | 464.08 ± 1.2% | | 1.00 | 2.20 | 19.24 |
| 07-unicode-character-data/parse-line | 558784 | 198.17 ± 0.8% | not timed | not timed | 160.01 ± 6.1% | 37.99 ± 6.1% | not timed | not timed | 197.62 ± 2.4% | | 1.00 | 1.24 | 5.22 |
| 08-words/all-english | 56691 | 95.08 ± 0.5% | not timed | not timed | 74.33 ± 0.4% | 11.15 ± 5.7% | not timed | not timed | 94.02 ± 14.6% | | 1.01 | 1.28 | 8.52 |
| 08-words/long-english | 839 | 535.10 ± 0.3% | not timed | not timed | 514.01 ± 0.2% | 25.87 ± 12.0% | not timed | not timed | 535.39 ± 0.8% | | 1.00 | 1.04 | 20.69 |
| 09-aws-keys/full | 0 | 425.70 ± 1.5% | not timed | not timed | 443.51 ± 0.6% | 54.68 ± 5.1% | not timed | not timed | 426.17 ± 0.3% | | 1.00 | 0.96 | 7.78 |
| 09-aws-keys/quick | 0 | 787.65 ± 0.5% | not timed | not timed | 803.06 ± 0.2% | 330.07 ± 0.6% | not timed | not timed | 779.93 ± 10.0% | | 1.01 | 0.98 | 2.39 |
| 10-bounded-repeat/letters-en | 1833 | 485.83 ± 0.5% | not timed | not timed | 432.39 ± 2.3% | 16.78 ± 2.2% | not timed | not timed | 486.42 ± 0.3% | | 1.00 | 1.12 | 28.95 |
| 10-bounded-repeat/letters-ru | 3475 | 431.25 ± 0.4% | not timed | not timed | 408.00 ± 0.2% | 19.55 ± 5.7% | not timed | not timed | 429.95 ± 1.4% | | 1.00 | 1.06 | 22.06 |
| 10-bounded-repeat/context | 53 | 64.68 ± 1.0% | not timed | not timed | 56.22 ± 0.4% | 16.89 ± 0.4% | not timed | not timed | 63.81 ± 0.9% | | 1.01 | 1.15 | 3.83 |
| 10-bounded-repeat/capitals | 11 | 557.38 ± 7.7% | not timed | not timed | 531.80 ± 0.3% | 30.94 ± 0.3% | not timed | not timed | 557.71 ± 8.7% | | 1.00 | 1.05 | 18.01 |
| 11-unstructured-to-json/extract | 600 | 54.53 ± 0.8% | not timed | not timed | 62.46 ± 0.7% | 40.68 ± 1.3% | not timed | not timed | 54.74 ± 1.4% | | 1.00 | 0.87 | 1.34 |
| 12-dictionary/single | 1 | 462.34 ± 1.9% | not timed | not timed | 442.78 ± 1.3% | 0.32 ± 2.3% | not timed | not timed | 460.78 ± 0.3% | | 1.00 | 1.04 | 1425.34 |
| 14-quadratic/1x | 100 | 20.76 ± 1.0% | not timed | not timed | 9.08 ± 3.0% | 0.80 ± 1.8% | not timed | not timed | 20.74 ± 0.6% | | 1.00 | 2.29 | 26.07 |
| 14-quadratic/2x | 200 | 15.99 ± 0.9% | not timed | not timed | 4.90 ± 0.3% | 0.43 ± 0.7% | not timed | not timed | 15.93 ± 12.5% | | 1.00 | 3.26 | 37.43 |
| 14-quadratic/10x | 1000 | 5.61 ± 2.5% | not timed | not timed | 1.05 ± 0.5% | 0.09 ± 3.9% | not timed | not timed | 5.61 ± 0.8% | | 1.00 | 5.34 | 60.93 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.14 ± 0.2% | not timed | not timed | 0.39 ± 0.6% | 0.48 ± 7.3% | not timed | not timed | 1.13 ± 0.9% | | 1.01 | 2.94 | 2.36 |
| 04-ruff-noqa/compile-real | 1 | 79.18 ± 0.4% | not timed | not timed | 12.92 ± 1.1% | 120.36 ± 4.2% | not timed | not timed | 77.92 ± 2.0% | | 1.02 | 6.13 | 0.66 |
| 05-lexer-veryl/compile-single | 1 | 12.41 ± 0.7% | not timed | not timed | 2.34 ± 0.6% | 5.92 ± 2.7% | not timed | not timed | 12.36 ± 1.0% | | 1.00 | 5.29 | 2.10 |
| 07-unicode-character-data/compile | 1 | 49.52 ± 0.6% | not timed | not timed | 24.04 ± 2.2% | 32.40 ± 18.2% | not timed | not timed | 49.09 ± 2.3% | | 1.01 | 2.06 | 1.53 |
| 09-aws-keys/compile-full | 1 | 33.98 ± 0.2% | not timed | not timed | 7.43 ± 0.9% | 19.96 ± 25.3% | not timed | not timed | 33.77 ± 1.4% | | 1.01 | 4.57 | 1.70 |
| 09-aws-keys/compile-quick | 1 | 151.12 ± 0.3% | not timed | not timed | 43.89 ± 0.7% | 116.68 ± 4.1% | not timed | not timed | 149.18 ± 1.5% | | 1.01 | 3.44 | 1.30 |
| 10-bounded-repeat/compile-context | 1 | 10.37 ± 0.4% | not timed | not timed | 11.74 ± 0.4% | 15.13 ± 2.3% | not timed | not timed | 10.32 ± 0.4% | | 1.00 | 0.88 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 71.79 ± 2.9% | not timed | not timed | 8.94 ± 1.5% | 22.59 ± 1.1% | not timed | not timed | 71.90 ± 0.8% | | 1.00 | 8.03 | 3.18 |
| 11-unstructured-to-json/compile | 1 | 73.01 ± 3.0% | not timed | not timed | 35.77 ± 5.1% | 56.86 ± 15.5% | not timed | not timed | 72.47 ± 4.0% | | 1.01 | 2.04 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.29 ± 18.1% | not timed | not timed | 0.07 ± 50.3% | 0.09 ± 15.2% | not timed | not timed | 0.29 ± 2.0% | | 1.00 | 4.27 | 3.20 |

