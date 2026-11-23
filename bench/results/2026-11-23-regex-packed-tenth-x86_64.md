# bench-regex

| Field | Value |
|---|---|
| Commit | c8a2b4f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
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
| literal: a word | 217 | 32056.31 ± 0.8% | 894.42 ± 0.2% | 20.50 ± 4.2% | 31126.42 ± 1.1% | 9092.96 ± 9.3% | 10.75 ± 0.5% | 76.60 ± 1.0% | 31834.39 ± 2.9% | 35.84 | 1.01 | 1.03 | 3.53 |
| literal: a word that is not there | 0 | 44329.89 ± 0.4% | 906.19 ± 0.1% | 20.04 ± 4.6% | 39671.20 ± 1.0% | 30043.26 ± 1.6% | 10.74 ± 0.2% | 72.15 ± 3.2% | 43981.59 ± 0.8% | 48.92 | 1.01 | 1.12 | 1.48 |
| literal: one of four words | 661 | 11350.78 ± 7.8% | 869.87 ± 1.5% | 11.17 ± 3.9% | 9079.80 ± 3.6% | 19.04 ± 1.7% | 3.85 ± 0.3% | 6.66 ± 0.4% | 11372.42 ± 0.6% | 13.05 | 1.00 | 1.25 | 596.22 |
| literal: a word in any case | 217 | 25503.89 ± 0.7% | 893.89 ± 0.2% | 15.34 ± 2.8% | 9212.65 ± 0.4% | 37.28 ± 5.7% | refused | differs | 25381.36 ± 3.7% | 28.53 | 1.00 | 2.77 | 684.03 |
| literal: an href attribute | 33 | 26248.06 ± 1.4% | 902.22 ± 0.1% | 18.84 ± 2.8% | 27159.72 ± 1.3% | 2048.52 ± 1.1% | 8.27 ± 0.1% | 61.66 ± 0.7% | 26198.66 ± 0.5% | 29.09 | 1.00 | 0.97 | 12.81 |
| literal: a word, second text | 123 | 32312.63 ± 0.2% | 898.92 ± 0.1% | 20.22 ± 2.4% | 31852.23 ± 1.3% | 7080.89 ± 4.3% | 11.64 ± 0.4% | 65.29 ± 1.4% | 32231.97 ± 0.8% | 35.95 | 1.00 | 1.01 | 4.56 |
| class: two capitalized words | 1331 | 767.04 ± 0.4% | 814.94 ± 0.5% | 19.05 ± 3.5% | 506.37 ± 0.4% | 34.40 ± 7.2% | 9.39 ± 0.1% | 55.78 ± 0.3% | 765.12 ± 0.4% | 0.94 | 1.00 | 1.51 | 22.30 |
| class: a word that ends in ing | 3399 | 734.00 ± 0.3% | 733.99 ± 0.3% | 13.48 ± 1.3% | 472.27 ± 1.0% | 25.72 ± 23.3% | 5.32 ± 0.2% | 17.19 ± 0.3% | 733.67 ± 2.5% | 1.00 | 1.00 | 1.55 | 28.54 |
| class: a word in capitals | 2332 | 983.81 ± 0.3% | 797.49 ± 0.3% | 20.05 ± 4.0% | 497.72 ± 0.8% | 36.60 ± 11.5% | 10.43 ± 0.2% | 76.57 ± 3.6% | 982.20 ± 0.3% | 1.23 | 1.00 | 1.98 | 26.88 |
| class: a number | 8288 | 1465.67 ± 0.5% | 646.46 ± 0.2% | 19.88 ± 2.0% | 1472.16 ± 5.1% | 36.74 ± 11.9% | 0.34 ± 0.5% | 55.77 ± 0.7% | 1452.15 ± 0.4% | 2.27 | 1.01 | 1.00 | 39.89 |
| class: two capitalized words, second text | 5359 | 578.65 ± 3.2% | 578.65 ± 0.4% | 17.58 ± 2.5% | 418.13 ± 0.1% | 30.16 ± 7.6% | 10.57 ± 0.3% | 51.67 ± 0.4% | 577.89 ± 0.3% | 1.00 | 1.00 | 1.38 | 19.19 |
| other: a word between two words | 6104 | 650.25 ± 0.2% | 617.80 ± 0.1% | 17.24 ± 1.7% | 693.25 ± 0.6% | 98.51 ± 12.0% | 7.25 ± 0.2% | 56.58 ± 0.5% | 652.14 ± 3.1% | 1.05 | 1.00 | 0.94 | 6.60 |
| other: a number before a unit, second text | 1481 | 6808.11 ± 4.2% | 826.43 ± 0.3% | 18.86 ± 3.1% | 6428.90 ± 0.6% | 35.19 ± 13.6% | 11.01 ± 0.3% | 55.08 ± 10.9% | 6804.09 ± 2.5% | 8.24 | 1.00 | 1.06 | 193.49 |
| other: a heading's start tag | 110 | 18788.11 ± 0.6% | 893.66 ± 1.5% | 19.76 ± 2.5% | 2010.00 ± 2.5% | 1484.16 ± 4.4% | 10.06 ± 0.3% | 72.72 ± 7.2% | 18753.25 ± 2.3% | 21.02 | 1.00 | 9.35 | 12.66 |
| other: a whole word | 217 | 22269.01 ± 8.1% | 893.48 ± 0.2% | 20.17 ± 3.1% | 22570.56 ± 1.0% | 41.31 ± 7.6% | 9.53 ± 0.6% | 46.86 ± 1.7% | 22098.67 ± 1.1% | 24.92 | 1.01 | 0.99 | 539.11 |
| other: a line's first word, second text | 3716 | 1764.90 ± 2.6% | 717.34 ± 0.2% | 22.11 ± 3.6% | 1699.64 ± 3.0% | 53.08 ± 3.8% | refused | refused | 1757.42 ± 2.0% | 2.46 | 1.00 | 1.04 | 33.25 |
| other: fourteen octets before an x | 87 | 25695.56 ± 2.3% | 199.43 ± 0.8% | 4.35 ± 2.5% | 2986.03 ± 0.7% | 9.01 ± 0.4% | differs | 15.47 ± 0.3% | 25574.58 ± 7.1% | 128.84 | 1.00 | 8.61 | 2850.45 |
| other: a Greek word | 21815 | 381.75 ± 0.7% | 265.54 ± 0.3% | 23.90 ± 1.1% | 264.93 ± 0.5% | 43.92 ± 14.2% | differs | refused | 384.14 ± 6.7% | 1.44 | 0.99 | 1.44 | 8.69 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.32 ± 0.7% | 25.30 ± 0.2% | 0.74 ± 0.1% | 16.74 ± 0.3% | 1.62 ± 1.3% | differs | 3.63 ± 11.3% | 25.07 ± 0.3% | 1.00 | 1.01 | 1.51 | 15.60 |
| a UUID | 32895 | 20.82 ± 0.2% | 20.82 ± 0.3% | 0.57 ± 0.7% | 12.56 ± 0.4% | 2.49 ± 6.2% | 0.44 ± 0.1% | 3.10 ± 1.2% | 20.80 ± 0.3% | 1.00 | 1.00 | 1.66 | 8.36 |
| an IPv4 address | 33176 | 35.56 ± 0.5% | 35.63 ± 1.9% | 1.83 ± 1.3% | 24.01 ± 0.3% | 5.68 ± 3.3% | differs | 3.42 ± 12.9% | 35.44 ± 0.6% | 1.00 | 1.00 | 1.48 | 6.26 |
| a date and time | 32954 | 31.03 ± 9.5% | 30.91 ± 0.2% | 1.26 ± 0.4% | 18.01 ± 0.3% | 6.64 ± 0.4% | 0.76 ± 0.1% | 6.20 ± 0.9% | 30.93 ± 9.0% | 1.00 | 1.00 | 1.72 | 4.68 |
| a field path | 32606 | 28.31 ± 7.6% | 28.41 ± 0.1% | 0.85 ± 1.0% | 19.39 ± 0.4% | 2.92 ± 0.4% | differs | 2.46 ± 1.1% | 28.37 ± 0.2% | 1.00 | 1.00 | 1.46 | 9.70 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.69 ± 0.6% | 7.71 ± 16.9% | 7.37 ± 1.8% | 10.61 ± 0.8% | 4.71 ± 3.3% | 0.62 ± 0.3% | none | 7.71 ± 0.3% | 1.00 | 1.00 | 0.73 | 1.63 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 193.63 ± 0.4% | 194.79 ± 0.1% | 229.58 ± 0.4% | 79.93 ± 2.6% | 184.27 ± 4.4% | 538.57 ± 3.8% | 3983.21 ± 0.7% | 193.87 ± 1.0% | 0.99 | 1.00 | 2.42 | 1.05 |
| a UUID | 62 | 125.27 ± 0.7% | 125.80 ± 1.7% | 140.67 ± 0.3% | 47.19 ± 1.0% | 90.33 ± 1.9% | 198.91 ± 1.8% | 4135.62 ± 0.4% | 124.88 ± 1.8% | 1.00 | 1.00 | 2.65 | 1.39 |
| an IPv4 address | 29 | 382.51 ± 0.6% | 387.18 ± 1.6% | 554.68 ± 1.0% | 69.79 ± 2.3% | 114.20 ± 1.6% | 321.45 ± 5.1% | 7181.60 ± 0.3% | 387.01 ± 2.1% | 0.99 | 0.99 | 5.48 | 3.35 |
| a date and time | 56 | 276.71 ± 2.4% | 280.09 ± 2.1% | 360.34 ± 2.4% | 68.23 ± 3.1% | 121.22 ± 10.7% | 364.55 ± 6.8% | 4185.37 ± 2.3% | 279.12 ± 3.8% | 0.99 | 0.99 | 4.06 | 2.28 |
| a field path | 39 | 190.20 ± 0.8% | 191.22 ± 0.2% | 224.18 ± 0.9% | 75.15 ± 3.6% | 172.95 ± 1.7% | 590.17 ± 5.0% | 4811.60 ± 1.9% | 189.78 ± 0.2% | 0.99 | 1.00 | 2.53 | 1.10 |
| literal: a word | 7 | 570.77 ± 1.5% | 607.99 ± 0.7% | 1123.27 ± 0.9% | 491.29 ± 0.8% | 576.59 ± 3.2% | 1225.99 ± 0.6% | 24725.56 ± 0.6% | 566.78 ± 1.2% | 0.94 | 1.01 | 1.16 | 0.99 |
| literal: a word that is not there | 8 | 546.82 ± 0.8% | 590.19 ± 0.7% | 1057.83 ± 0.4% | 454.26 ± 1.0% | 559.42 ± 1.8% | 1157.13 ± 0.7% | 23319.09 ± 0.6% | 544.39 ± 1.4% | 0.93 | 1.00 | 1.20 | 0.98 |
| literal: one of four words | 26 | 217.23 ± 0.4% | 359.54 ± 0.5% | 495.10 ± 0.4% | 41.92 ± 0.6% | 220.48 ± 3.5% | 444.37 ± 1.8% | 11529.35 ± 1.6% | 217.02 ± 0.3% | 0.60 | 1.00 | 5.18 | 0.99 |
| literal: a word in any case | 11 | 445.41 ± 0.7% | 475.74 ± 0.5% | 745.85 ± 0.6% | 14.57 ± 1.0% | 603.27 ± 2.0% | refused | 19593.27 ± 1.4% | 442.79 ± 0.7% | 0.94 | 1.01 | 30.57 | 0.74 |
| literal: an href attribute | 12 | 319.51 ± 0.6% | 330.47 ± 0.4% | 446.05 ± 0.6% | 37.14 ± 1.2% | 426.83 ± 19.6% | 934.58 ± 4.1% | 18818.97 ± 1.4% | 318.61 ± 0.9% | 0.97 | 1.00 | 8.60 | 0.75 |
| literal: a word, second text | 10 | 505.58 ± 1.1% | 554.64 ± 0.5% | 956.70 ± 1.3% | 407.08 ± 0.4% | 484.51 ± 2.3% | 977.79 ± 0.3% | 21147.60 ± 1.0% | 505.83 ± 0.5% | 0.91 | 1.00 | 1.24 | 1.04 |
| class: two capitalized words | 23 | 414.24 ± 1.1% | 444.18 ± 0.4% | 668.25 ± 1.0% | 95.32 ± 1.0% | 447.11 ± 3.5% | 921.55 ± 0.9% | 6394.39 ± 0.3% | 414.00 ± 3.2% | 0.93 | 1.00 | 4.35 | 0.93 |
| class: a word that ends in ing | 9 | 496.86 ± 0.5% | 555.96 ± 0.2% | 1031.65 ± 1.7% | 113.72 ± 8.3% | 630.46 ± 5.9% | 1401.14 ± 3.1% | 15269.22 ± 1.4% | 495.97 ± 0.2% | 0.89 | 1.00 | 4.37 | 0.79 |
| class: a word in capitals | 16 | 429.05 ± 3.6% | 461.23 ± 1.1% | 788.28 ± 1.0% | 120.92 ± 0.7% | 643.85 ± 2.2% | 1286.28 ± 2.7% | 8373.66 ± 0.3% | 429.38 ± 1.9% | 0.93 | 1.00 | 3.55 | 0.67 |
| class: a number | 6 | 537.30 ± 6.0% | 588.99 ± 16.8% | 1174.32 ± 8.8% | 36.37 ± 1.0% | 1166.72 ± 1.6% | 2218.36 ± 1.7% | 20419.26 ± 0.3% | 536.68 ± 0.4% | 0.91 | 1.00 | 14.77 | 0.46 |
| class: two capitalized words, second text | 23 | 414.23 ± 0.7% | 444.80 ± 2.1% | 667.98 ± 1.0% | 95.61 ± 0.8% | 447.16 ± 2.3% | 908.32 ± 1.7% | 6386.16 ± 0.2% | 414.89 ± 0.3% | 0.93 | 1.00 | 4.33 | 0.93 |
| other: a word between two words | 13 | 492.69 ± 0.8% | 509.76 ± 0.7% | 834.13 ± 0.4% | 122.53 ± 2.7% | 433.50 ± 2.6% | 1032.03 ± 1.9% | 14082.52 ± 0.9% | 492.10 ± 0.9% | 0.97 | 1.00 | 4.02 | 1.14 |
| other: a number before a unit, second text | 15 | 359.74 ± 0.8% | 396.14 ± 1.1% | 566.53 ± 1.0% | 33.87 ± 2.0% | 537.69 ± 0.2% | 1098.17 ± 4.6% | 13921.45 ± 0.4% | 359.59 ± 0.3% | 0.91 | 1.00 | 10.62 | 0.67 |
| other: a heading's start tag | 13 | 332.37 ± 1.2% | 337.41 ± 0.4% | 459.34 ± 7.1% | 35.41 ± 1.2% | 523.70 ± 1.3% | 1078.41 ± 0.6% | 16271.63 ± 0.6% | 331.64 ± 0.3% | 0.99 | 1.00 | 9.39 | 0.63 |
| other: a whole word | 11 | 504.89 ± 0.5% | 534.95 ± 1.0% | 892.49 ± 1.3% | 109.89 ± 0.7% | 508.27 ± 0.9% | 1033.44 ± 1.2% | 20849.27 ± 1.9% | 503.38 ± 0.5% | 0.94 | 1.00 | 4.59 | 0.99 |
| other: a line's first word, second text | 17 | 476.78 ± 0.7% | 500.01 ± 0.5% | 855.95 ± 0.3% | 115.17 ± 1.5% | 583.88 ± 0.9% | refused | refused | 474.95 ± 0.5% | 0.95 | 1.00 | 4.14 | 0.82 |
| other: fourteen octets before an x | 16 | 86.43 ± 0.7% | 122.75 ± 0.3% | 144.22 ± 0.5% | 14.21 ± 2.0% | 395.56 ± 1.9% | 445.34 ± 2.0% | 11762.56 ± 1.8% | 86.75 ± 0.3% | 0.70 | 1.00 | 6.08 | 0.22 |
| other: a Greek word | 8 | 364.09 ± 1.1% | 505.56 ± 1.6% | 865.37 ± 0.7% | 46.61 ± 0.8% | 1149.46 ± 1.1% | 2149.35 ± 0.4% | refused | 363.86 ± 0.3% | 0.72 | 1.00 | 7.81 | 0.32 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20522.53 ± 1.4% | not timed | not timed | 26672.16 ± 0.4% | 1938.60 ± 20.1% | not timed | not timed | 20384.25 ± 1.0% | | 1.01 | 0.77 | 10.59 |
| 01-literal/sherlock-casei-en | 522 | 4491.44 ± 0.3% | not timed | not timed | 7046.75 ± 0.4% | 28.51 ± 0.7% | not timed | not timed | 4558.94 ± 0.7% | | 0.99 | 0.64 | 157.57 |
| 01-literal/sherlock-ru | 724 | 22000.27 ± 4.2% | not timed | not timed | 27480.71 ± 0.8% | 1059.37 ± 5.0% | not timed | not timed | 22069.21 ± 1.7% | | 1.00 | 0.80 | 20.77 |
| 01-literal/sherlock-casei-ru | 746 | 7201.23 ± 0.4% | not timed | not timed | 5525.89 ± 5.8% | 30.48 ± 4.3% | not timed | not timed | 7327.63 ± 0.6% | | 0.98 | 1.30 | 236.26 |
| 01-literal/sherlock-zh | 30 | 38551.20 ± 2.0% | not timed | not timed | 35862.12 ± 10.8% | 1238.14 ± 2.1% | not timed | not timed | 38659.59 ± 2.2% | | 1.00 | 1.07 | 31.14 |
| 02-literal-alternate/sherlock-en | 714 | 9818.54 ± 5.4% | not timed | not timed | 8457.20 ± 0.3% | 14.15 ± 3.6% | not timed | not timed | 9852.77 ± 0.6% | | 1.00 | 1.16 | 693.67 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1671.92 ± 0.3% | not timed | not timed | 1814.17 ± 10.9% | 9.50 ± 0.4% | not timed | not timed | 1723.06 ± 8.9% | | 0.97 | 0.92 | 175.90 |
| 02-literal-alternate/sherlock-ru | 899 | 5860.47 ± 0.4% | not timed | not timed | 4194.04 ± 0.2% | 19.22 ± 14.6% | not timed | not timed | 5975.86 ± 0.6% | | 0.98 | 1.40 | 304.85 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1756.89 ± 0.4% | not timed | not timed | 1043.06 ± 5.1% | 8.54 ± 0.8% | not timed | not timed | 1813.66 ± 10.2% | | 0.97 | 1.68 | 205.83 |
| 02-literal-alternate/sherlock-zh | 207 | 13949.82 ± 8.9% | not timed | not timed | 10225.83 ± 0.7% | 27.53 ± 2.2% | not timed | not timed | 13972.56 ± 0.6% | | 1.00 | 1.36 | 506.76 |
| 03-date/ascii | 111817 | 108.24 ± 4.2% | not timed | not timed | 83.62 ± 0.6% | 0.18 ± 1.7% | not timed | not timed | 108.52 ± 0.2% | | 1.00 | 1.29 | 601.54 |
| 04-ruff-noqa/real | 84 | 520.23 ± 1.2% | not timed | not timed | 441.39 ± 0.9% | 15.45 ± 1.4% | not timed | not timed | 564.57 ± 0.1% | | 0.92 | 1.18 | 33.68 |
| 04-ruff-noqa/tweaked | 44 | 488.82 ± 1.6% | not timed | not timed | 433.38 ± 1.1% | 288.55 ± 1.4% | not timed | not timed | 488.92 ± 0.2% | | 1.00 | 1.13 | 1.69 |
| 05-lexer-veryl/single | 124800 | 2.91 ± 3.0% | not timed | not timed | 4.14 ± 2.6% | 0.21 ± 3.4% | not timed | not timed | 2.90 ± 2.9% | | 1.01 | 0.70 | 13.83 |
| 06-cloud-flare-redos/original | 107 | 178.50 ± 0.2% | not timed | not timed | 192.75 ± 1.0% | 12.92 ± 0.7% | not timed | not timed | 177.78 ± 1.3% | | 1.00 | 0.93 | 13.82 |
| 06-cloud-flare-redos/simplified-short | 102 | 127.08 ± 0.6% | not timed | not timed | 192.37 ± 0.2% | 13.53 ± 0.6% | not timed | not timed | 126.96 ± 1.9% | | 1.00 | 0.66 | 9.40 |
| 06-cloud-flare-redos/simplified-long | 10000 | 136.59 ± 1.4% | not timed | not timed | 211.48 ± 0.9% | 14.90 ± 8.8% | not timed | not timed | 136.54 ± 1.3% | | 1.00 | 0.65 | 9.17 |
| 07-unicode-character-data/parse-line | 558784 | 30.75 ± 1.2% | not timed | not timed | 161.20 ± 0.7% | 37.39 ± 2.2% | not timed | not timed | 35.54 ± 1.9% | | 0.87 | 0.19 | 0.82 |
| 08-words/all-english | 56691 | 73.39 ± 0.5% | not timed | not timed | 73.64 ± 0.2% | 10.22 ± 8.9% | not timed | not timed | 73.39 ± 0.5% | | 1.00 | 1.00 | 7.18 |
| 08-words/long-english | 839 | 843.41 ± 0.4% | not timed | not timed | 514.80 ± 0.1% | 26.71 ± 10.1% | not timed | not timed | 848.05 ± 0.2% | | 0.99 | 1.64 | 31.58 |
| 09-aws-keys/full | 0 | 431.69 ± 10.7% | not timed | not timed | 436.76 ± 2.1% | 54.59 ± 3.3% | not timed | not timed | 432.41 ± 1.9% | | 1.00 | 0.99 | 7.91 |
| 09-aws-keys/quick | 0 | 437.07 ± 0.3% | not timed | not timed | 803.72 ± 0.3% | 301.54 ± 4.3% | not timed | not timed | 442.94 ± 1.4% | | 0.99 | 0.54 | 1.45 |
| 10-bounded-repeat/letters-en | 1833 | 471.49 ± 0.2% | not timed | not timed | 430.37 ± 0.3% | 16.79 ± 1.1% | not timed | not timed | 470.32 ± 0.4% | | 1.00 | 1.10 | 28.07 |
| 10-bounded-repeat/letters-ru | 3475 | 325.24 ± 0.3% | not timed | not timed | 407.90 ± 1.2% | 19.75 ± 14.9% | not timed | not timed | 323.44 ± 0.4% | | 1.01 | 0.80 | 16.47 |
| 10-bounded-repeat/context | 53 | 59.28 ± 0.8% | not timed | not timed | 55.47 ± 1.1% | 16.75 ± 3.0% | not timed | not timed | 59.55 ± 1.3% | | 1.00 | 1.07 | 3.54 |
| 10-bounded-repeat/capitals | 11 | 894.64 ± 0.2% | not timed | not timed | 532.37 ± 0.6% | 30.98 ± 0.9% | not timed | not timed | 893.40 ± 1.1% | | 1.00 | 1.68 | 28.87 |
| 11-unstructured-to-json/extract | 600 | 20.55 ± 1.0% | not timed | not timed | 62.54 ± 0.6% | 23.17 ± 1.6% | not timed | not timed | 20.66 ± 0.3% | | 0.99 | 0.33 | 0.89 |
| 12-dictionary/single | 1 | 460.62 ± 1.6% | not timed | not timed | 443.01 ± 2.5% | 0.32 ± 0.5% | not timed | not timed | 463.36 ± 0.2% | | 0.99 | 1.04 | 1436.72 |
| 14-quadratic/1x | 100 | 11.41 ± 0.8% | not timed | not timed | 9.11 ± 0.2% | 0.79 ± 3.9% | not timed | not timed | 11.43 ± 0.9% | | 1.00 | 1.25 | 14.38 |
| 14-quadratic/2x | 200 | 6.88 ± 0.9% | not timed | not timed | 4.92 ± 0.3% | 0.43 ± 2.1% | not timed | not timed | 6.92 ± 0.6% | | 1.00 | 1.40 | 16.01 |
| 14-quadratic/10x | 1000 | 1.57 ± 0.7% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 2.7% | not timed | not timed | 1.57 ± 0.2% | | 1.00 | 1.49 | 16.87 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.32 ± 1.8% | not timed | not timed | 0.38 ± 0.8% | 0.49 ± 4.4% | not timed | not timed | 1.32 ± 1.2% | | 1.00 | 3.44 | 2.71 |
| 04-ruff-noqa/compile-real | 1 | 79.57 ± 3.8% | not timed | not timed | 13.05 ± 0.9% | 124.56 ± 2.6% | not timed | not timed | 78.71 ± 1.8% | | 1.01 | 6.10 | 0.64 |
| 05-lexer-veryl/compile-single | 1 | 12.35 ± 0.9% | not timed | not timed | 2.36 ± 0.5% | 5.91 ± 1.6% | not timed | not timed | 12.27 ± 1.2% | | 1.01 | 5.23 | 2.09 |
| 07-unicode-character-data/compile | 1 | 51.23 ± 2.0% | not timed | not timed | 24.31 ± 0.6% | 33.09 ± 15.6% | not timed | not timed | 50.86 ± 1.7% | | 1.01 | 2.11 | 1.55 |
| 09-aws-keys/compile-full | 1 | 34.92 ± 0.1% | not timed | not timed | 7.40 ± 2.1% | 20.32 ± 3.6% | not timed | not timed | 34.69 ± 0.9% | | 1.01 | 4.72 | 1.72 |
| 09-aws-keys/compile-quick | 1 | 156.12 ± 0.2% | not timed | not timed | 44.95 ± 0.6% | 118.67 ± 4.1% | not timed | not timed | 155.22 ± 1.1% | | 1.01 | 3.47 | 1.32 |
| 10-bounded-repeat/compile-context | 1 | 10.49 ± 8.1% | not timed | not timed | 11.62 ± 0.8% | 15.18 ± 1.9% | not timed | not timed | 10.47 ± 1.3% | | 1.00 | 0.90 | 0.69 |
| 10-bounded-repeat/compile-capitals | 1 | 72.67 ± 0.7% | not timed | not timed | 8.70 ± 0.5% | 22.21 ± 2.3% | not timed | not timed | 72.06 ± 1.1% | | 1.01 | 8.35 | 3.27 |
| 11-unstructured-to-json/compile | 1 | 77.42 ± 1.1% | not timed | not timed | 37.36 ± 2.0% | 60.43 ± 1.8% | not timed | not timed | 77.32 ± 0.4% | | 1.00 | 2.07 | 1.28 |
| 12-dictionary/compile-single | 1 | 0.29 ± 1.4% | not timed | not timed | 0.07 ± 15.7% | 0.08 ± 18.6% | not timed | not timed | 0.29 ± 3.5% | | 1.01 | 4.19 | 3.42 |

