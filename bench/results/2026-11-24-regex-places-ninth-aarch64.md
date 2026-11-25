# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507011788 |
| Date | 2026-11-24 |
| Rust regex | 1.13.2, rustc 1.100.0 |
| Go regexp | 1.27.4 |
| zig-regex | 49c5694 |
| mvzr | 3efcfe3 |

`stdx` is a searcher with its cache and the CPU features it detected at start, as Rust's regex detects them, `stdx, no skip` the same with claims R1 to R5 off, and `stdx, matcher alone` the matcher with no DFA (decision 86). `stdx, again` is a second searcher like the first, timed last in each round: `stdx / stdx, again` shows how far one code path differs from itself. Each round times the other candidates from one place later than the round before, so none of them takes one place in every round. A candidate that refuses a pattern, gives another answer than Go's regexp or has no such call is named so and not timed. A search finds both ends of each match, and its answer is the count of the matches and the sum of their offsets.

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
| literal: a word | 217 | 18925.01 ± 2.8% | 5072.96 ± 0.1% | 28.21 ± 0.3% | 17852.10 ± 2.3% | 8995.38 ± 9.8% | 17.55 ± 0.2% | 85.94 ± 0.3% | 19110.29 ± 2.2% | 3.73 | 0.99 | 1.06 | 2.10 |
| literal: a word that is not there | 0 | 20666.62 ± 4.3% | 4919.59 ± 0.2% | 28.24 ± 0.3% | 19184.04 ± 4.0% | 28397.52 ± 3.5% | 17.36 ± 0.3% | 81.76 ± 0.2% | 21312.57 ± 5.8% | 4.20 | 0.97 | 1.08 | 0.73 |
| literal: one of four words | 661 | 6419.59 ± 0.3% | 1971.10 ± 0.2% | 14.40 ± 0.1% | 3937.73 ± 0.5% | 21.86 ± 0.2% | 5.29 ± 0.2% | 6.74 ± 0.2% | 6417.82 ± 0.2% | 3.26 | 1.00 | 1.63 | 293.68 |
| literal: a word in any case | 217 | 15014.55 ± 2.2% | 2099.68 ± 0.5% | 21.44 ± 0.4% | 3953.18 ± 0.1% | 37.91 ± 0.4% | refused | differs | 15046.55 ± 0.6% | 7.15 | 1.00 | 3.80 | 396.07 |
| literal: an href attribute | 33 | 16749.14 ± 1.0% | 616.58 ± 0.2% | 27.19 ± 0.3% | 16842.70 ± 2.3% | 2248.84 ± 2.7% | 12.99 ± 0.9% | 75.08 ± 0.4% | 16836.01 ± 2.4% | 27.16 | 0.99 | 0.99 | 7.45 |
| literal: a word, second text | 123 | 19637.29 ± 1.8% | 3419.88 ± 0.3% | 27.90 ± 0.3% | 18059.17 ± 2.3% | 7445.72 ± 2.6% | 19.30 ± 0.3% | 68.76 ± 0.2% | 19578.39 ± 3.1% | 5.74 | 1.00 | 1.09 | 2.64 |
| class: two capitalized words | 1331 | 1064.58 ± 0.3% | 607.31 ± 0.3% | 25.91 ± 0.4% | 579.68 ± 0.6% | 40.48 ± 2.9% | 15.01 ± 0.6% | 68.11 ± 0.6% | 1060.42 ± 0.9% | 1.75 | 1.00 | 1.84 | 26.30 |
| class: a word that ends in ing | 3399 | 581.40 ± 0.2% | 582.01 ± 0.3% | 17.90 ± 2.6% | 543.61 ± 0.2% | 29.52 ± 9.8% | 8.18 ± 0.4% | 18.20 ± 0.6% | 581.25 ± 0.6% | 1.00 | 1.00 | 1.07 | 19.69 |
| class: a word in capitals | 2332 | 1388.46 ± 0.3% | 612.22 ± 0.4% | 27.52 ± 0.3% | 570.90 ± 0.5% | 43.57 ± 0.5% | 17.21 ± 0.4% | 82.81 ± 1.7% | 1384.97 ± 0.7% | 2.27 | 1.00 | 2.43 | 31.87 |
| class: a number | 8288 | 2124.92 ± 0.3% | 850.22 ± 0.4% | 27.76 ± 0.3% | 1714.02 ± 0.3% | 40.16 ± 14.0% | 0.57 ± 0.1% | 56.68 ± 0.6% | 2127.52 ± 0.3% | 2.50 | 1.00 | 1.24 | 52.91 |
| class: two capitalized words, second text | 5359 | 524.80 ± 0.2% | 533.80 ± 0.3% | 23.20 ± 0.2% | 484.18 ± 0.3% | 34.45 ± 13.4% | 16.91 ± 0.2% | 63.29 ± 0.5% | 524.90 ± 0.2% | 0.98 | 1.00 | 1.08 | 15.23 |
| other: a word between two words | 6104 | 809.48 ± 0.2% | 608.01 ± 0.2% | 23.45 ± 0.2% | 735.41 ± 0.2% | 108.15 ± 6.1% | 11.30 ± 0.3% | 69.15 ± 0.3% | 807.23 ± 0.2% | 1.33 | 1.00 | 1.10 | 7.49 |
| other: a number before a unit, second text | 1481 | 6155.35 ± 0.7% | 1126.70 ± 0.5% | 25.92 ± 0.4% | 5551.55 ± 0.7% | 40.67 ± 16.3% | 17.87 ± 0.6% | 66.59 ± 0.3% | 6145.41 ± 2.0% | 5.46 | 1.00 | 1.11 | 151.34 |
| other: a heading's start tag | 110 | 14057.92 ± 1.9% | 749.74 ± 0.2% | 27.36 ± 0.2% | 1706.89 ± 0.2% | 1579.39 ± 4.8% | 16.32 ± 0.2% | 88.35 ± 0.3% | 14102.23 ± 1.6% | 18.75 | 1.00 | 8.24 | 8.90 |
| other: a whole word | 217 | 16000.46 ± 2.5% | 607.41 ± 0.2% | 29.33 ± 0.6% | 14295.69 ± 1.7% | 47.89 ± 7.9% | 13.75 ± 0.3% | 55.41 ± 0.9% | 15986.11 ± 1.5% | 26.34 | 1.00 | 1.12 | 334.11 |
| other: a line's first word, second text | 3716 | 2097.03 ± 0.4% | 599.52 ± 0.2% | 30.94 ± 0.5% | 1726.90 ± 0.5% | 60.99 ± 9.9% | refused | refused | 2095.50 ± 0.4% | 3.50 | 1.00 | 1.21 | 34.39 |
| other: fourteen octets before an x | 87 | 23125.47 ± 1.9% | 229.27 ± 0.6% | 6.54 ± 0.1% | 4004.66 ± 1.1% | 10.64 ± 0.5% | differs | 17.46 ± 0.2% | 23095.02 ± 7.8% | 100.86 | 1.00 | 5.77 | 2174.04 |
| other: a Greek word | 21815 | 520.04 ± 0.5% | 423.57 ± 0.2% | 30.68 ± 0.3% | 289.27 ± 0.2% | 49.72 ± 6.3% | differs | refused | 521.09 ± 0.4% | 1.23 | 1.00 | 1.80 | 10.46 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.13 ± 0.3% | 29.17 ± 0.5% | 0.86 ± 0.1% | 19.45 ± 0.3% | 2.75 ± 1.1% | differs | 4.00 ± 0.2% | 29.12 ± 0.3% | 1.00 | 1.00 | 1.50 | 10.60 |
| a UUID | 32895 | 24.32 ± 0.2% | 24.30 ± 0.1% | 0.64 ± 0.2% | 15.09 ± 0.3% | 3.09 ± 0.2% | 0.72 ± 0.4% | 3.59 ± 0.4% | 24.35 ± 0.2% | 1.00 | 1.00 | 1.61 | 7.88 |
| an IPv4 address | 33176 | 38.17 ± 0.3% | 38.18 ± 0.3% | 2.07 ± 0.2% | 28.87 ± 0.3% | 6.65 ± 0.2% | differs | 4.15 ± 0.1% | 38.12 ± 0.2% | 1.00 | 1.00 | 1.32 | 5.74 |
| a date and time | 32954 | 33.83 ± 0.3% | 33.59 ± 0.3% | 1.44 ± 0.3% | 21.35 ± 0.5% | 7.03 ± 0.4% | 1.19 ± 0.2% | 7.02 ± 0.3% | 33.82 ± 0.2% | 1.01 | 1.00 | 1.58 | 4.81 |
| a field path | 32606 | 32.44 ± 0.7% | 32.44 ± 0.5% | 1.01 ± 0.7% | 23.02 ± 0.5% | 3.50 ± 0.9% | differs | 2.92 ± 0.2% | 32.42 ± 0.6% | 1.00 | 1.00 | 1.41 | 9.26 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.12 ± 0.1% | 11.02 ± 0.3% | 11.10 ± 0.3% | 11.46 ± 0.2% | 4.87 ± 3.8% | 0.90 ± 0.5% | none | 11.07 ± 0.2% | 1.01 | 1.00 | 0.97 | 2.28 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 222.27 ± 0.5% | 222.38 ± 0.5% | 259.99 ± 0.5% | 85.15 ± 0.2% | 217.54 ± 3.1% | 473.68 ± 1.1% | 3714.19 ± 0.7% | 222.55 ± 0.6% | 1.00 | 1.00 | 2.61 | 1.02 |
| a UUID | 62 | 144.16 ± 0.7% | 144.34 ± 0.2% | 159.54 ± 0.3% | 45.42 ± 0.5% | 97.52 ± 2.0% | 180.28 ± 1.2% | 4431.17 ± 1.1% | 144.11 ± 0.3% | 1.00 | 1.00 | 3.17 | 1.48 |
| an IPv4 address | 29 | 420.06 ± 0.3% | 420.43 ± 0.3% | 581.87 ± 0.6% | 76.97 ± 1.2% | 129.15 ± 1.7% | 289.13 ± 1.0% | 7579.16 ± 0.5% | 419.45 ± 0.3% | 1.00 | 1.00 | 5.46 | 3.25 |
| a date and time | 56 | 301.67 ± 0.4% | 301.70 ± 0.1% | 376.29 ± 0.3% | 71.88 ± 0.7% | 134.87 ± 2.9% | 315.74 ± 2.9% | 4925.74 ± 0.4% | 301.57 ± 0.2% | 1.00 | 1.00 | 4.20 | 2.24 |
| a field path | 39 | 213.21 ± 0.3% | 213.23 ± 0.9% | 247.82 ± 0.1% | 78.37 ± 0.3% | 203.19 ± 1.4% | 491.54 ± 1.6% | 4807.46 ± 0.7% | 213.21 ± 0.2% | 1.00 | 1.00 | 2.72 | 1.05 |
| literal: a word | 7 | 617.97 ± 0.4% | 669.15 ± 0.5% | 1185.20 ± 0.4% | 522.10 ± 0.1% | 614.74 ± 12.4% | 916.00 ± 0.9% | 29634.93 ± 0.3% | 619.37 ± 0.2% | 0.92 | 1.00 | 1.18 | 1.01 |
| literal: a word that is not there | 8 | 594.31 ± 0.7% | 653.01 ± 0.5% | 1112.38 ± 0.8% | 470.01 ± 0.3% | 592.12 ± 2.8% | 867.31 ± 0.7% | 28531.77 ± 0.3% | 596.26 ± 0.5% | 0.91 | 1.00 | 1.26 | 1.00 |
| literal: one of four words | 26 | 246.20 ± 0.1% | 396.10 ± 0.3% | 532.25 ± 0.2% | 49.33 ± 1.0% | 237.19 ± 1.4% | 351.24 ± 2.4% | 15407.17 ± 0.3% | 246.13 ± 0.1% | 0.62 | 1.00 | 4.99 | 1.04 |
| literal: a word in any case | 11 | 447.68 ± 0.3% | 479.32 ± 0.4% | 701.46 ± 0.3% | 15.67 ± 0.3% | 644.01 ± 1.3% | refused | 23226.41 ± 0.4% | 448.00 ± 0.3% | 0.93 | 1.00 | 28.56 | 0.70 |
| literal: an href attribute | 12 | 336.50 ± 0.4% | 347.88 ± 0.5% | 450.91 ± 1.9% | 44.93 ± 1.1% | 491.20 ± 1.4% | 768.50 ± 0.6% | 21498.42 ± 0.3% | 336.26 ± 0.1% | 0.97 | 1.00 | 7.49 | 0.69 |
| literal: a word, second text | 10 | 553.39 ± 0.5% | 614.64 ± 0.5% | 1011.94 ± 0.7% | 414.30 ± 3.8% | 525.30 ± 1.5% | 787.42 ± 0.6% | 26332.08 ± 0.3% | 553.16 ± 0.5% | 0.90 | 1.00 | 1.34 | 1.05 |
| class: two capitalized words | 23 | 436.03 ± 0.6% | 463.17 ± 0.7% | 661.03 ± 0.7% | 100.41 ± 0.2% | 490.62 ± 2.0% | 731.93 ± 1.4% | 6323.22 ± 0.4% | 435.10 ± 0.5% | 0.94 | 1.00 | 4.34 | 0.89 |
| class: a word that ends in ing | 9 | 547.47 ± 0.4% | 617.25 ± 0.7% | 1059.02 ± 0.2% | 132.88 ± 0.7% | 741.36 ± 1.7% | 1089.15 ± 0.9% | 15658.02 ± 0.2% | 548.18 ± 0.2% | 0.89 | 1.00 | 4.12 | 0.74 |
| class: a word in capitals | 16 | 490.96 ± 0.4% | 528.77 ± 0.4% | 829.13 ± 0.2% | 135.84 ± 1.4% | 734.16 ± 7.3% | 1002.77 ± 0.6% | 8306.57 ± 0.1% | 491.05 ± 0.3% | 0.93 | 1.00 | 3.61 | 0.67 |
| class: a number | 6 | 625.51 ± 0.3% | 686.47 ± 0.1% | 1259.74 ± 0.3% | 41.87 ± 0.5% | 1380.38 ± 1.1% | 1853.07 ± 0.5% | 22397.01 ± 0.2% | 625.60 ± 0.5% | 0.91 | 1.00 | 14.94 | 0.45 |
| class: two capitalized words, second text | 23 | 435.63 ± 0.2% | 462.92 ± 0.4% | 659.91 ± 0.3% | 99.92 ± 2.2% | 490.92 ± 0.8% | 757.82 ± 0.7% | 6322.05 ± 0.2% | 434.45 ± 0.4% | 0.94 | 1.00 | 4.36 | 0.89 |
| other: a word between two words | 13 | 531.21 ± 0.2% | 553.04 ± 0.5% | 868.32 ± 0.2% | 135.29 ± 0.6% | 489.96 ± 0.6% | 808.11 ± 0.9% | 14513.62 ± 0.3% | 530.82 ± 0.3% | 0.96 | 1.00 | 3.93 | 1.08 |
| other: a number before a unit, second text | 15 | 383.27 ± 0.2% | 423.84 ± 0.2% | 585.77 ± 0.5% | 39.33 ± 1.3% | 618.94 ± 1.0% | 878.66 ± 0.2% | 15043.02 ± 0.2% | 382.99 ± 0.4% | 0.90 | 1.00 | 9.75 | 0.62 |
| other: a heading's start tag | 13 | 345.37 ± 0.5% | 353.03 ± 0.3% | 459.88 ± 0.3% | 42.56 ± 1.1% | 607.10 ± 1.9% | 859.68 ± 0.3% | 17787.11 ± 0.2% | 346.09 ± 0.3% | 0.98 | 1.00 | 8.12 | 0.57 |
| other: a whole word | 11 | 571.46 ± 0.4% | 613.24 ± 0.5% | 1010.06 ± 0.3% | 120.25 ± 1.3% | 550.97 ± 2.3% | 823.48 ± 0.6% | 26181.09 ± 0.3% | 571.60 ± 0.2% | 0.93 | 1.00 | 4.75 | 1.04 |
| other: a line's first word, second text | 17 | 516.17 ± 0.6% | 546.21 ± 0.3% | 863.75 ± 0.1% | 128.58 ± 0.5% | 697.28 ± 0.9% | refused | refused | 516.08 ± 0.3% | 0.95 | 1.00 | 4.01 | 0.74 |
| other: fourteen octets before an x | 16 | 107.36 ± 0.2% | 153.77 ± 0.7% | 175.19 ± 1.1% | 15.11 ± 0.4% | 442.56 ± 1.7% | 407.91 ± 0.8% | 12576.68 ± 0.4% | 107.39 ± 0.6% | 0.70 | 1.00 | 7.11 | 0.24 |
| other: a Greek word | 8 | 442.63 ± 0.6% | 577.45 ± 0.3% | 945.71 ± 0.7% | 58.76 ± 0.7% | 1365.71 ± 1.1% | 1813.07 ± 0.4% | refused | 443.02 ± 0.4% | 0.77 | 1.00 | 7.53 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15542.49 ± 1.5% | not timed | not timed | 15998.82 ± 0.5% | 2022.66 ± 15.0% | not timed | not timed | 15538.43 ± 1.1% | | 1.00 | 0.97 | 7.68 |
| 01-literal/sherlock-casei-en | 522 | 11077.65 ± 7.1% | not timed | not timed | 3585.06 ± 0.2% | 32.51 ± 0.2% | not timed | not timed | 11055.53 ± 1.6% | | 1.00 | 3.09 | 340.77 |
| 01-literal/sherlock-ru | 724 | 17127.17 ± 0.8% | not timed | not timed | 17153.51 ± 0.6% | 1564.07 ± 11.1% | not timed | not timed | 17155.10 ± 0.4% | | 1.00 | 1.00 | 10.95 |
| 01-literal/sherlock-casei-ru | 746 | 6141.76 ± 0.2% | not timed | not timed | 3319.15 ± 0.2% | 31.66 ± 0.3% | not timed | not timed | 6087.55 ± 0.2% | | 1.01 | 1.85 | 194.00 |
| 01-literal/sherlock-zh | 30 | 19624.31 ± 0.3% | not timed | not timed | 18445.61 ± 0.7% | 2748.21 ± 12.6% | not timed | not timed | 19582.00 ± 0.3% | | 1.00 | 1.06 | 7.14 |
| 02-literal-alternate/sherlock-en | 714 | 6102.28 ± 0.4% | not timed | not timed | 3915.13 ± 0.6% | 16.58 ± 0.1% | not timed | not timed | 6124.49 ± 0.5% | | 1.00 | 1.56 | 368.09 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1966.22 ± 1.1% | not timed | not timed | 697.17 ± 0.4% | 11.12 ± 0.2% | not timed | not timed | 1966.79 ± 0.8% | | 1.00 | 2.82 | 176.88 |
| 02-literal-alternate/sherlock-ru | 899 | 5528.71 ± 0.2% | not timed | not timed | 3241.66 ± 0.2% | 22.59 ± 0.3% | not timed | not timed | 5514.74 ± 0.1% | | 1.00 | 1.71 | 244.73 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2050.21 ± 1.0% | not timed | not timed | 1230.70 ± 0.2% | 9.02 ± 5.6% | not timed | not timed | 2049.05 ± 0.6% | | 1.00 | 1.67 | 227.33 |
| 02-literal-alternate/sherlock-zh | 207 | 7319.25 ± 0.4% | not timed | not timed | 4150.80 ± 0.2% | 30.96 ± 0.2% | not timed | not timed | 7311.78 ± 0.5% | | 1.00 | 1.76 | 236.40 |
| 03-date/ascii | 111817 | 132.54 ± 0.7% | not timed | not timed | 95.42 ± 0.2% | 0.20 ± 2.1% | not timed | not timed | 134.01 ± 2.8% | | 0.99 | 1.39 | 654.39 |
| 04-ruff-noqa/real | 84 | 435.30 ± 0.2% | not timed | not timed | 464.06 ± 0.2% | 19.51 ± 1.4% | not timed | not timed | 434.16 ± 0.3% | | 1.00 | 0.94 | 22.32 |
| 04-ruff-noqa/tweaked | 44 | 593.31 ± 0.3% | not timed | not timed | 458.69 ± 0.1% | 361.97 ± 0.6% | not timed | not timed | 593.31 ± 0.5% | | 1.00 | 1.29 | 1.64 |
| 05-lexer-veryl/single | 124800 | 5.33 ± 3.1% | not timed | not timed | 4.90 ± 0.2% | 0.20 ± 3.0% | not timed | not timed | 5.51 ± 0.3% | | 0.97 | 1.09 | 26.09 |
| 06-cloud-flare-redos/original | 107 | 425.48 ± 0.3% | not timed | not timed | 214.75 ± 0.0% | 24.89 ± 0.4% | not timed | not timed | 430.83 ± 0.3% | | 0.99 | 1.98 | 17.09 |
| 06-cloud-flare-redos/simplified-short | 102 | 430.99 ± 0.2% | not timed | not timed | 226.95 ± 0.2% | 26.70 ± 0.3% | not timed | not timed | 429.46 ± 0.1% | | 1.00 | 1.90 | 16.14 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.20 ± 0.1% | not timed | not timed | 254.28 ± 0.6% | 28.80 ± 0.1% | not timed | not timed | 587.60 ± 0.1% | | 1.00 | 2.31 | 20.39 |
| 07-unicode-character-data/parse-line | 558784 | 232.79 ± 0.9% | not timed | not timed | 172.05 ± 0.1% | 42.71 ± 8.2% | not timed | not timed | 232.64 ± 3.0% | | 1.00 | 1.35 | 5.45 |
| 08-words/all-english | 56691 | 127.98 ± 0.3% | not timed | not timed | 82.76 ± 0.2% | 12.36 ± 12.0% | not timed | not timed | 127.55 ± 0.2% | | 1.00 | 1.55 | 10.36 |
| 08-words/long-english | 839 | 622.12 ± 0.3% | not timed | not timed | 594.25 ± 0.3% | 32.20 ± 1.3% | not timed | not timed | 622.58 ± 0.3% | | 1.00 | 1.05 | 19.32 |
| 09-aws-keys/full | 0 | 440.42 ± 0.2% | not timed | not timed | 461.25 ± 0.1% | 64.43 ± 3.6% | not timed | not timed | 438.96 ± 0.2% | | 1.00 | 0.95 | 6.84 |
| 09-aws-keys/quick | 0 | 873.43 ± 0.2% | not timed | not timed | 963.48 ± 0.3% | 418.71 ± 0.3% | not timed | not timed | 872.88 ± 0.2% | | 1.00 | 0.91 | 2.09 |
| 10-bounded-repeat/letters-en | 1833 | 583.33 ± 2.9% | not timed | not timed | 516.32 ± 0.2% | 19.47 ± 0.4% | not timed | not timed | 576.59 ± 2.9% | | 1.01 | 1.13 | 29.97 |
| 10-bounded-repeat/letters-ru | 3475 | 505.78 ± 1.1% | not timed | not timed | 476.69 ± 0.3% | 21.53 ± 16.7% | not timed | not timed | 507.48 ± 1.2% | | 1.00 | 1.06 | 23.49 |
| 10-bounded-repeat/context | 53 | 85.08 ± 1.8% | not timed | not timed | 65.55 ± 0.6% | 19.50 ± 0.3% | not timed | not timed | 85.53 ± 1.8% | | 0.99 | 1.30 | 4.36 |
| 10-bounded-repeat/capitals | 11 | 632.67 ± 8.3% | not timed | not timed | 616.22 ± 0.1% | 36.40 ± 0.2% | not timed | not timed | 632.11 ± 8.3% | | 1.00 | 1.03 | 17.38 |
| 11-unstructured-to-json/extract | 600 | 56.93 ± 0.8% | not timed | not timed | 77.80 ± 0.4% | 49.08 ± 1.7% | not timed | not timed | 57.17 ± 1.2% | | 1.00 | 0.73 | 1.16 |
| 12-dictionary/single | 1 | 559.52 ± 0.8% | not timed | not timed | 560.36 ± 0.3% | 0.40 ± 0.1% | not timed | not timed | 559.64 ± 0.9% | | 1.00 | 1.00 | 1385.20 |
| 14-quadratic/1x | 100 | 21.25 ± 0.9% | not timed | not timed | 9.99 ± 0.1% | 0.96 ± 2.7% | not timed | not timed | 21.26 ± 2.7% | | 1.00 | 2.13 | 22.08 |
| 14-quadratic/2x | 200 | 17.71 ± 0.8% | not timed | not timed | 5.55 ± 0.3% | 0.53 ± 1.6% | not timed | not timed | 17.83 ± 0.9% | | 0.99 | 3.19 | 33.46 |
| 14-quadratic/10x | 1000 | 7.75 ± 0.5% | not timed | not timed | 1.21 ± 0.3% | 0.12 ± 1.9% | not timed | not timed | 7.78 ± 0.4% | | 1.00 | 6.40 | 66.97 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 0.5% | not timed | not timed | 0.34 ± 0.5% | 0.54 ± 2.9% | not timed | not timed | 1.22 ± 2.2% | | 1.00 | 3.57 | 2.28 |
| 04-ruff-noqa/compile-real | 1 | 106.22 ± 0.8% | not timed | not timed | 13.81 ± 0.2% | 136.86 ± 2.1% | not timed | not timed | 106.43 ± 0.5% | | 1.00 | 7.69 | 0.78 |
| 05-lexer-veryl/compile-single | 1 | 14.05 ± 0.4% | not timed | not timed | 2.52 ± 1.2% | 6.31 ± 0.8% | not timed | not timed | 14.05 ± 0.4% | | 1.00 | 5.59 | 2.23 |
| 07-unicode-character-data/compile | 1 | 107.81 ± 1.7% | not timed | not timed | 26.04 ± 0.2% | 35.60 ± 3.1% | not timed | not timed | 108.14 ± 1.5% | | 1.00 | 4.14 | 3.03 |
| 09-aws-keys/compile-full | 1 | 53.14 ± 1.1% | not timed | not timed | 8.26 ± 0.6% | 23.14 ± 1.4% | not timed | not timed | 53.15 ± 0.4% | | 1.00 | 6.43 | 2.30 |
| 09-aws-keys/compile-quick | 1 | 186.80 ± 1.4% | not timed | not timed | 47.16 ± 0.3% | 130.77 ± 2.0% | not timed | not timed | 187.05 ± 1.4% | | 1.00 | 3.96 | 1.43 |
| 10-bounded-repeat/compile-context | 1 | 72.09 ± 1.2% | not timed | not timed | 11.26 ± 0.7% | 15.75 ± 2.3% | not timed | not timed | 72.02 ± 0.7% | | 1.00 | 6.40 | 4.58 |
| 10-bounded-repeat/compile-capitals | 1 | 84.64 ± 0.8% | not timed | not timed | 8.14 ± 0.4% | 23.33 ± 1.2% | not timed | not timed | 84.85 ± 1.1% | | 1.00 | 10.40 | 3.63 |
| 11-unstructured-to-json/compile | 1 | 170.04 ± 0.9% | not timed | not timed | 40.41 ± 0.2% | 67.55 ± 2.3% | not timed | not timed | 170.44 ± 0.9% | | 1.00 | 4.21 | 2.52 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.0% | not timed | not timed | 0.07 ± 29.6% | 0.09 ± 15.0% | not timed | not timed | 0.35 ± 0.9% | | 1.00 | 4.99 | 3.70 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.28 ± 4.5% | not timed | not timed | 6.48 ± 0.3% | 0.53 ± 14.9% | not timed | not timed | 7.37 ± 3.2% | | 0.99 | 1.12 | 13.64 |
| dictionary/search/english-10 | 690 | 1.15 ± 1.8% | not timed | not timed | 164.25 ± 0.4% | 0.00 ± 0.2% | not timed | not timed | 1.16 ± 0.5% | | 0.99 | 0.0070 | 463.63 |
| dictionary/search/english-15 | 15 | 565.36 ± 0.8% | not timed | not timed | 558.09 ± 0.1% | 0.36 ± 0.3% | not timed | not timed | 566.56 ± 1.0% | | 1.00 | 1.01 | 1551.35 |
| folly/awyer-inn-busted | 1 | 5581.53 ± 0.1% | not timed | not timed | 142.12 ± 0.4% | 43.66 ± 0.2% | not timed | not timed | 5602.57 ± 0.2% | | 1.00 | 39.27 | 127.85 |
| folly/literal-never-match-rare | 0 | 21076.77 ± 0.7% | not timed | not timed | 19856.57 ± 0.4% | 40772.42 ± 0.5% | not timed | not timed | 21078.12 ± 0.4% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12470.17 ± 1.5% | not timed | not timed | 19801.57 ± 0.6% | 2198.66 ± 0.6% | not timed | not timed | 12515.22 ± 1.2% | | 1.00 | 0.63 | 5.67 |
| folly/literal-never-match-tricksy | 1 | 3238.80 ± 0.6% | not timed | not timed | 4392.26 ± 0.3% | 3049.28 ± 0.2% | not timed | not timed | 3233.59 ± 0.5% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1317.81 ± 0.6% | not timed | not timed | 943.80 ± 0.4% | 386.08 ± 20.3% | not timed | not timed | 1321.91 ± 2.5% | | 1.00 | 1.40 | 3.41 |
| grep/long-words-ascii | 5073 | 458.64 ± 0.1% | not timed | not timed | 468.14 ± 0.2% | 46.15 ± 8.4% | not timed | not timed | 457.47 ± 0.5% | | 1.00 | 0.98 | 9.94 |
| imported/leipzig/twain | 811 | 20693.37 ± 1.3% | not timed | not timed | 19511.96 ± 0.6% | 11893.59 ± 21.3% | not timed | not timed | 20730.70 ± 0.8% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 9013.31 ± 10.8% | not timed | not timed | 4239.24 ± 0.2% | 37.67 ± 0.2% | not timed | not timed | 9096.34 ± 1.4% | | 0.99 | 2.13 | 239.26 |
| imported/leipzig/shing | 1540 | 15153.64 ± 3.7% | not timed | not timed | 13443.08 ± 0.4% | 33.37 ± 3.1% | not timed | not timed | 15377.89 ± 3.9% | | 0.99 | 1.13 | 454.10 |
| imported/leipzig/huck-saw | 262 | 8197.56 ± 3.3% | not timed | not timed | 5591.86 ± 0.1% | 30.99 ± 0.1% | not timed | not timed | 8430.31 ± 3.4% | | 0.97 | 1.47 | 264.49 |
| imported/leipzig/word-ending-nn | 262 | 601.77 ± 0.5% | not timed | not timed | 614.85 ± 0.5% | 24.40 ± 1.1% | not timed | not timed | 602.80 ± 0.2% | | 1.00 | 0.98 | 24.66 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11110.70 ± 1.0% | not timed | not timed | 4503.94 ± 0.2% | 11.43 ± 0.1% | not timed | not timed | 11174.11 ± 1.2% | | 0.99 | 2.47 | 972.28 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7768.18 ± 3.5% | not timed | not timed | 5465.64 ± 0.2% | 16.61 ± 0.1% | not timed | not timed | 7904.57 ± 2.0% | | 0.98 | 1.42 | 467.76 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4165.97 ± 1.0% | not timed | not timed | 413.37 ± 1.1% | 11.01 ± 0.1% | not timed | not timed | 4190.97 ± 1.1% | | 0.99 | 10.08 | 378.34 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 599.40 ± 0.7% | not timed | not timed | 614.21 ± 0.4% | 11.09 ± 0.1% | not timed | not timed | 597.71 ± 0.8% | | 1.00 | 0.98 | 54.07 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 598.35 ± 0.6% | not timed | not timed | 613.97 ± 0.2% | 9.74 ± 0.1% | not timed | not timed | 597.90 ± 0.4% | | 1.00 | 0.97 | 61.46 |
| imported/leipzig/tom-river | 2 | 6462.36 ± 2.2% | not timed | not timed | 5148.71 ± 0.2% | 30.76 ± 0.1% | not timed | not timed | 6582.21 ± 2.0% | | 0.98 | 1.26 | 210.10 |
| imported/leipzig/ing | 78424 | 598.83 ± 0.7% | not timed | not timed | 569.53 ± 0.3% | 28.14 ± 4.0% | not timed | not timed | 600.06 ± 0.9% | | 1.00 | 1.05 | 21.28 |
| imported/leipzig/ing-whitespace | 55248 | 748.49 ± 1.3% | not timed | not timed | 2077.18 ± 1.2% | 20.46 ± 2.8% | not timed | not timed | 752.03 ± 0.5% | | 1.00 | 0.36 | 36.59 |
| imported/leipzig/awyer-inn | 209 | 764.93 ± 1.4% | not timed | not timed | 4258.04 ± 0.7% | 22.57 ± 0.2% | not timed | not timed | 765.63 ± 1.3% | | 1.00 | 0.18 | 33.90 |
| imported/leipzig/quotes-bounded | 8886 | 2113.40 ± 0.6% | not timed | not timed | 3000.13 ± 0.9% | 38.05 ± 0.1% | not timed | not timed | 2124.70 ± 0.5% | | 0.99 | 0.70 | 55.54 |
| imported/leipzig/non-ascii-alternate | 2 | 12752.38 ± 2.6% | not timed | not timed | 5651.92 ± 0.4% | 50.83 ± 0.2% | not timed | not timed | 13015.92 ± 2.6% | | 0.98 | 2.26 | 250.90 |
| imported/leipzig/math-symbols | 69 | 1974.27 ± 0.6% | not timed | not timed | 613.02 ± 0.2% | 36.45 ± 0.2% | not timed | not timed | 1979.52 ± 0.5% | | 1.00 | 3.22 | 54.16 |
| imported/leipzig/bounded-strings-ending-z | 0 | 585.99 ± 0.7% | not timed | not timed | 613.02 ± 0.2% | 22.56 ± 0.1% | not timed | not timed | 585.98 ± 0.3% | | 1.00 | 0.96 | 25.98 |
| imported/lh3lh3-reb/uri | 17549 | 678.07 ± 0.3% | not timed | not timed | 1061.21 ± 0.5% | 28.02 ± 2.3% | not timed | not timed | 677.94 ± 0.3% | | 1.00 | 0.64 | 24.20 |
| imported/lh3lh3-reb/email | 15057 | 671.83 ± 0.1% | not timed | not timed | 1154.67 ± 0.4% | 30.78 ± 2.3% | not timed | not timed | 671.32 ± 0.4% | | 1.00 | 0.58 | 21.83 |
| imported/lh3lh3-reb/date | 668 | 858.05 ± 0.3% | not timed | not timed | 1032.16 ± 0.1% | 51.10 ± 3.8% | not timed | not timed | 858.55 ± 0.2% | | 1.00 | 0.83 | 16.79 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 643.88 ± 0.4% | not timed | not timed | 421.62 ± 0.2% | 15.74 ± 0.3% | not timed | not timed | 643.66 ± 0.3% | | 1.00 | 1.53 | 40.90 |
| imported/mariomka/email | 92 | 24076.88 ± 2.3% | not timed | not timed | 29122.28 ± 5.8% | 32.78 ± 0.2% | not timed | not timed | 24005.77 ± 2.0% | | 1.00 | 0.83 | 734.57 |
| imported/mariomka/uri | 5301 | 5321.25 ± 0.9% | not timed | not timed | 6087.52 ± 0.5% | 32.68 ± 0.5% | not timed | not timed | 5367.05 ± 0.9% | | 0.99 | 0.87 | 162.85 |
| imported/mariomka/ip | 5 | 2148.47 ± 2.1% | not timed | not timed | 2960.55 ± 0.1% | 21.02 ± 0.2% | not timed | not timed | 2150.49 ± 2.4% | | 1.00 | 0.73 | 102.19 |
| imported/rsc/no-exponential | 0 | 605.02 ± 0.2% | not timed | not timed | 320.07 ± 0.1% | 23.81 ± 0.4% | not timed | not timed | 600.85 ± 0.1% | | 1.01 | 1.89 | 25.42 |
| imported/rsc/literal | 1 | 758.12 ± 7.2% | not timed | not timed | 1485.95 ± 4.8% | 190.56 ± 17.9% | not timed | not timed | 756.46 ± 8.0% | | 1.00 | 0.51 | 3.98 |
| imported/rsc/not-literal | 2 | 778.84 ± 2.3% | not timed | not timed | 730.84 ± 0.4% | 46.18 ± 8.7% | not timed | not timed | 781.22 ± 0.3% | | 1.00 | 1.07 | 16.86 |
| imported/rsc/match-class | 1 | 1435.07 ± 0.4% | not timed | not timed | 1608.59 ± 0.2% | 58.76 ± 6.3% | not timed | not timed | 1435.98 ± 2.3% | | 1.00 | 0.89 | 24.42 |
| imported/rsc/match-class-in-range | 1 | 1442.84 ± 0.3% | not timed | not timed | 2281.70 ± 3.6% | 60.09 ± 7.5% | not timed | not timed | 1436.86 ± 0.2% | | 1.00 | 0.63 | 24.01 |
| imported/rsc/match-class-unicode | 1 | 547.00 ± 0.2% | not timed | not timed | 510.23 ± 0.2% | 72.24 ± 1.1% | not timed | not timed | 547.06 ± 7.3% | | 1.00 | 1.07 | 7.57 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1435.99 ± 0.4% | not timed | not timed | 949.64 ± 0.2% | 227.89 ± 0.4% | not timed | not timed | 1435.71 ± 0.2% | | 1.00 | 1.51 | 6.30 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21540.75 ± 0.1% | not timed | not timed | 14048.30 ± 0.3% | 3417.88 ± 0.7% | not timed | not timed | 21499.64 ± 0.2% | | 1.00 | 1.53 | 6.30 |
| imported/rsc/anchored-literal-short-match | 4 | 709.88 ± 1.5% | not timed | not timed | 504.14 ± 0.5% | 85.42 ± 10.4% | not timed | not timed | 706.03 ± 1.7% | | 1.01 | 1.41 | 8.31 |
| imported/rsc/anchored-literal-long-match | 4 | 10660.60 ± 1.9% | not timed | not timed | 7214.16 ± 0.5% | 1248.92 ± 10.4% | not timed | not timed | 10600.79 ± 0.9% | | 1.01 | 1.48 | 8.54 |
| imported/rsc/one-pass-short | 17 | 371.96 ± 0.2% | not timed | not timed | 212.19 ± 0.3% | 29.85 ± 11.7% | not timed | not timed | 369.94 ± 1.4% | | 1.01 | 1.75 | 12.46 |
| imported/rsc/one-pass-short-not | 17 | 280.06 ± 2.0% | not timed | not timed | 223.15 ± 0.1% | 29.53 ± 11.5% | not timed | not timed | 280.42 ± 3.0% | | 1.00 | 1.26 | 9.48 |
| imported/rsc/one-pass-long-prefix | 26 | 365.74 ± 1.9% | not timed | not timed | 282.34 ± 0.3% | 96.31 ± 17.2% | not timed | not timed | 367.23 ± 2.1% | | 1.00 | 1.30 | 3.80 |
| imported/rsc/one-pass-long-prefix-not | 26 | 362.97 ± 2.4% | not timed | not timed | 281.00 ± 0.3% | 66.19 ± 20.8% | not timed | not timed | 365.07 ± 2.0% | | 0.99 | 1.29 | 5.48 |
| imported/rsc/long-needle1 | 31 | 22175.75 ± 0.1% | not timed | not timed | 20106.98 ± 0.3% | 3.77 ± 0.1% | not timed | not timed | 22182.46 ± 0.2% | | 1.00 | 1.10 | 5888.23 |
| imported/rsc/long-needle2 | 31 | 22281.03 ± 0.1% | not timed | not timed | 215.84 ± 0.2% | 3.77 ± 0.3% | not timed | not timed | 22292.38 ± 0.3% | | 1.00 | 103.23 | 5915.27 |
| imported/rsc/easy0-32 | 26 | 1065.52 ± 3.0% | not timed | not timed | 1541.73 ± 3.4% | 147.88 ± 19.9% | not timed | not timed | 1068.63 ± 0.2% | | 1.00 | 0.69 | 7.21 |
| imported/rsc/easy0-1k | 26 | 14887.13 ± 1.9% | not timed | not timed | 12557.23 ± 1.3% | 2304.76 ± 12.3% | not timed | not timed | 14877.69 ± 2.1% | | 1.00 | 1.19 | 6.46 |
| imported/rsc/easy0-32k | 26 | 23010.96 ± 0.3% | not timed | not timed | 20254.07 ± 0.2% | 18726.63 ± 27.4% | not timed | not timed | 23002.05 ± 1.6% | | 1.00 | 1.14 | 1.23 |
| imported/rsc/easy0-1mb | 26 | 21067.64 ± 2.3% | not timed | not timed | 19292.04 ± 1.4% | 33621.86 ± 5.6% | not timed | not timed | 20812.60 ± 1.2% | | 1.01 | 1.09 | 0.63 |
| imported/rsc/easy1-32 | 19 | 805.23 ± 8.7% | not timed | not timed | 637.93 ± 0.2% | 137.85 ± 20.5% | not timed | not timed | 803.87 ± 2.0% | | 1.00 | 1.26 | 5.84 |
| imported/rsc/easy1-1k | 19 | 16451.69 ± 2.6% | not timed | not timed | 12804.11 ± 0.2% | 2477.34 ± 17.2% | not timed | not timed | 16438.46 ± 2.3% | | 1.00 | 1.28 | 6.64 |
| imported/rsc/easy1-32k | 19 | 515939.35 ± 2.6% | not timed | not timed | 405661.98 ± 0.1% | 20373.31 ± 24.9% | not timed | not timed | 515944.04 ± 0.3% | | 1.00 | 1.27 | 25.32 |
| imported/rsc/easy1-1mb | 19 | 16544559.10 ± 0.4% | not timed | not timed | 13150694.83 ± 0.2% | 36750.42 ± 1.2% | not timed | not timed | 16550948.75 ± 0.3% | | 1.00 | 1.26 | 450.19 |
| imported/rsc/medium-32 | 27 | 766.84 ± 7.3% | not timed | not timed | 634.92 ± 0.1% | 69.76 ± 2.1% | not timed | not timed | 771.51 ± 0.4% | | 0.99 | 1.21 | 10.99 |
| imported/rsc/medium-1k | 27 | 13634.42 ± 0.4% | not timed | not timed | 11402.85 ± 0.2% | 72.34 ± 0.1% | not timed | not timed | 13731.50 ± 0.7% | | 0.99 | 1.20 | 188.47 |
| imported/rsc/medium-32k | 27 | 427069.26 ± 0.4% | not timed | not timed | 352504.71 ± 0.1% | 48.60 ± 0.2% | not timed | not timed | 428427.48 ± 1.9% | | 1.00 | 1.21 | 8787.83 |
| imported/rsc/medium-1mb | 27 | 13627979.25 ± 0.4% | not timed | not timed | 11268252.57 ± 0.1% | 48.62 ± 0.2% | not timed | not timed | 13688535.60 ± 0.6% | | 1.00 | 1.21 | 280272.12 |
| imported/rsc/hard-32 | 58 | 420.83 ± 2.1% | not timed | not timed | 368.16 ± 0.4% | 49.44 ± 7.4% | not timed | not timed | 417.63 ± 0.3% | | 1.01 | 1.14 | 8.51 |
| imported/rsc/hard-1k | 27 | 13425.01 ± 0.5% | not timed | not timed | 11541.17 ± 0.6% | 40.84 ± 0.2% | not timed | not timed | 13327.02 ± 0.8% | | 1.01 | 1.16 | 328.69 |
| imported/rsc/hard-32k | 27 | 417663.44 ± 0.4% | not timed | not timed | 363859.18 ± 0.2% | 29.34 ± 0.2% | not timed | not timed | 417950.25 ± 0.5% | | 1.00 | 1.15 | 14234.31 |
| imported/rsc/hard-1mb | 51 | 8413252.56 ± 0.4% | not timed | not timed | 7274684.16 ± 0.1% | 29.40 ± 0.1% | not timed | not timed | 8299766.21 ± 0.8% | | 1.01 | 1.16 | 286207.35 |
| imported/rsc/reallyhard0-32 | 58 | 266.35 ± 2.8% | not timed | not timed | 221.79 ± 0.1% | 49.83 ± 9.0% | not timed | not timed | 266.96 ± 0.3% | | 1.00 | 1.20 | 5.34 |
| imported/rsc/reallyhard0-1k | 27 | 589.24 ± 0.1% | not timed | not timed | 583.75 ± 0.2% | 40.91 ± 0.2% | not timed | not timed | 588.86 ± 0.2% | | 1.00 | 1.01 | 14.40 |
| imported/rsc/reallyhard0-32k | 27 | 610.00 ± 0.2% | not timed | not timed | 612.97 ± 0.1% | 29.35 ± 0.1% | not timed | not timed | 610.07 ± 0.2% | | 1.00 | 1.00 | 20.78 |
| imported/rsc/reallyhard0-1mb | 51 | 589.90 ± 0.8% | not timed | not timed | 617.44 ± 0.1% | 29.40 ± 0.3% | not timed | not timed | 587.91 ± 0.8% | | 1.00 | 0.96 | 20.07 |
| imported/rsc/reallyreallyhard0-32 | 47 | 288.56 ± 1.8% | not timed | not timed | 196.44 ± 0.3% | 60.66 ± 15.4% | not timed | not timed | 288.49 ± 1.5% | | 1.00 | 1.47 | 4.76 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6760.10 ± 0.0% | not timed | not timed | 5935.84 ± 0.2% | 34.03 ± 0.7% | not timed | not timed | 6757.84 ± 0.2% | | 1.00 | 1.14 | 198.65 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21491.26 ± 0.1% | not timed | not timed | 19251.04 ± 0.1% | 24.83 ± 1.3% | not timed | not timed | 21490.77 ± 0.6% | | 1.00 | 1.12 | 865.51 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 22017.47 ± 1.0% | not timed | not timed | 19940.48 ± 0.5% | 25.04 ± 1.8% | not timed | not timed | 21994.64 ± 0.7% | | 1.00 | 1.10 | 879.13 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 282.61 ± 6.2% | not timed | not timed | 213.42 ± 0.3% | 61.17 ± 9.7% | not timed | not timed | 282.64 ± 1.3% | | 1.00 | 1.32 | 4.62 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5883.83 ± 0.1% | not timed | not timed | 6259.23 ± 0.2% | 34.50 ± 2.7% | not timed | not timed | 5867.62 ± 0.1% | | 1.00 | 0.94 | 170.53 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21196.04 ± 0.4% | not timed | not timed | 19248.64 ± 0.2% | 23.92 ± 4.2% | not timed | not timed | 21303.45 ± 0.2% | | 0.99 | 1.10 | 886.17 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21413.35 ± 0.5% | not timed | not timed | 19744.80 ± 0.4% | 25.13 ± 0.1% | not timed | not timed | 21410.69 ± 0.9% | | 1.00 | 1.08 | 852.07 |
| imported/sherlock/name-sherlock | 776 | 19759.15 ± 2.0% | not timed | not timed | 18356.08 ± 0.9% | 9889.32 ± 25.8% | not timed | not timed | 19724.33 ± 1.7% | | 1.00 | 1.08 | 2.00 |
| imported/sherlock/name-holmes | 2766 | 15100.29 ± 2.0% | not timed | not timed | 15508.22 ± 0.4% | 3130.26 ± 15.3% | not timed | not timed | 15252.21 ± 1.9% | | 0.99 | 0.97 | 4.82 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19777.48 ± 1.7% | not timed | not timed | 18451.13 ± 0.3% | 7915.60 ± 24.7% | not timed | not timed | 19747.39 ± 2.3% | | 1.00 | 1.07 | 2.50 |
| imported/sherlock/name-sherlock-casei | 816 | 15669.11 ± 0.2% | not timed | not timed | 4006.60 ± 0.1% | 32.53 ± 0.7% | not timed | not timed | 15682.76 ± 0.4% | | 1.00 | 3.91 | 481.74 |
| imported/sherlock/name-holmes-casei | 2802 | 9425.76 ± 6.4% | not timed | not timed | 3308.44 ± 0.3% | 37.61 ± 0.2% | not timed | not timed | 9339.83 ± 3.1% | | 1.01 | 2.85 | 250.59 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13123.77 ± 2.7% | not timed | not timed | 3942.83 ± 0.1% | 32.53 ± 0.1% | not timed | not timed | 13136.26 ± 0.8% | | 1.00 | 3.33 | 403.39 |
| imported/sherlock/name-whitespace | 1461 | 15251.69 ± 1.6% | not timed | not timed | 14492.73 ± 0.4% | 6391.57 ± 19.8% | not timed | not timed | 15332.36 ± 1.3% | | 0.99 | 1.05 | 2.39 |
| imported/sherlock/name-alt1 | 1142 | 11595.47 ± 0.6% | not timed | not timed | 16173.64 ± 0.8% | 4058.55 ± 40.9% | not timed | not timed | 11615.93 ± 6.0% | | 1.00 | 0.72 | 2.86 |
| imported/sherlock/name-alt2 | 3542 | 8912.53 ± 0.5% | not timed | not timed | 3826.54 ± 0.1% | 31.32 ± 0.1% | not timed | not timed | 8930.70 ± 0.2% | | 1.00 | 2.33 | 284.57 |
| imported/sherlock/name-alt3 | 4507 | 5555.70 ± 0.5% | not timed | not timed | 3627.86 ± 0.2% | 9.93 ± 2.4% | not timed | not timed | 5567.49 ± 0.3% | | 1.00 | 1.53 | 559.45 |
| imported/sherlock/name-alt3-casei | 4593 | 1530.74 ± 2.0% | not timed | not timed | 285.33 ± 0.1% | 6.48 ± 0.1% | not timed | not timed | 1531.21 ± 1.0% | | 1.00 | 5.36 | 236.12 |
| imported/sherlock/name-alt4 | 3686 | 6370.98 ± 0.2% | not timed | not timed | 3775.66 ± 0.2% | 31.24 ± 0.3% | not timed | not timed | 6364.39 ± 0.2% | | 1.00 | 1.69 | 203.92 |
| imported/sherlock/name-alt4-casei | 4254 | 2804.52 ± 2.2% | not timed | not timed | 2575.69 ± 0.2% | 19.82 ± 0.3% | not timed | not timed | 2811.46 ± 1.5% | | 1.00 | 1.09 | 141.47 |
| imported/sherlock/name-alt5 | 4028 | 6425.22 ± 0.4% | not timed | not timed | 3746.42 ± 0.2% | 21.76 ± 0.3% | not timed | not timed | 6438.41 ± 0.1% | | 1.00 | 1.72 | 295.33 |
| imported/sherlock/name-alt5-casei | 4104 | 3513.87 ± 1.8% | not timed | not timed | 2226.51 ± 0.1% | 14.39 ± 0.1% | not timed | not timed | 3511.28 ± 0.8% | | 1.00 | 1.58 | 244.21 |
| imported/sherlock/no-match-uncommon | 0 | 21615.60 ± 0.3% | not timed | not timed | 19371.92 ± 0.7% | 34753.91 ± 0.7% | not timed | not timed | 21509.01 ± 0.2% | | 1.00 | 1.12 | 0.62 |
| imported/sherlock/no-match-common | 0 | 21165.44 ± 0.8% | not timed | not timed | 19186.02 ± 0.7% | 1278.38 ± 0.5% | not timed | not timed | 21187.83 ± 0.4% | | 1.00 | 1.10 | 16.56 |
| imported/sherlock/no-match-really-common | 0 | 15931.35 ± 4.9% | not timed | not timed | 18565.10 ± 1.0% | 1284.01 ± 0.5% | not timed | not timed | 16023.05 ± 1.9% | | 0.99 | 0.86 | 12.41 |
| imported/sherlock/the-lower | 21654 | 2315.18 ± 0.9% | not timed | not timed | 2320.16 ± 0.4% | 240.43 ± 13.4% | not timed | not timed | 2327.25 ± 3.1% | | 0.99 | 1.00 | 9.63 |
| imported/sherlock/the-upper | 2223 | 12685.20 ± 1.0% | not timed | not timed | 13464.07 ± 0.3% | 2666.66 ± 2.2% | not timed | not timed | 12776.04 ± 1.4% | | 0.99 | 0.94 | 4.76 |
| imported/sherlock/the-casei | 23961 | 2010.82 ± 1.3% | not timed | not timed | 1320.25 ± 0.4% | 34.44 ± 34.9% | not timed | not timed | 2010.39 ± 0.5% | | 1.00 | 1.52 | 58.39 |
| imported/sherlock/everything-greedy | 581881 | 283.02 ± 0.3% | not timed | not timed | 165.83 ± 0.2% | 28.71 ± 20.6% | not timed | not timed | 283.18 ± 0.8% | | 1.00 | 1.71 | 9.86 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.10 ± 1.5% | not timed | not timed | 213.55 ± 0.3% | 33.00 ± 0.2% | not timed | not timed | 461.89 ± 0.1% | | 1.00 | 2.16 | 14.00 |
| imported/sherlock/letters | 447175 | 62.34 ± 1.3% | not timed | not timed | 32.84 ± 0.4% | 6.46 ± 20.3% | not timed | not timed | 62.50 ± 0.5% | | 1.00 | 1.90 | 9.65 |
| imported/sherlock/letters-upper | 14180 | 452.54 ± 2.8% | not timed | not timed | 368.76 ± 0.1% | 29.43 ± 21.8% | not timed | not timed | 452.26 ± 0.2% | | 1.00 | 1.23 | 15.38 |
| imported/sherlock/letters-lower | 432995 | 63.43 ± 0.8% | not timed | not timed | 33.79 ± 0.1% | 5.06 ± 29.2% | not timed | not timed | 63.64 ± 0.7% | | 1.00 | 1.88 | 12.53 |
| imported/sherlock/words | 447639 | 115.34 ± 5.9% | not timed | not timed | 82.87 ± 0.2% | 14.17 ± 10.6% | not timed | not timed | 116.04 ± 0.9% | | 0.99 | 1.39 | 8.14 |
| imported/sherlock/before-holmes | 4073 | 10248.26 ± 0.2% | not timed | not timed | 8415.60 ± 0.3% | 23.99 ± 1.9% | not timed | not timed | 10298.39 ± 0.4% | | 1.00 | 1.22 | 427.28 |
| imported/sherlock/before-after-holmes | 2593 | 9839.18 ± 0.8% | not timed | not timed | 9482.38 ± 0.3% | 23.90 ± 2.0% | not timed | not timed | 9874.52 ± 0.5% | | 1.00 | 1.04 | 411.70 |
| imported/sherlock/holmes-cochar-watson | 150 | 5173.43 ± 0.3% | not timed | not timed | 3422.50 ± 0.2% | 30.92 ± 0.4% | not timed | not timed | 5185.06 ± 0.6% | | 1.00 | 1.51 | 167.32 |
| imported/sherlock/holmes-coword-watson | 14309 | 1193.40 ± 0.3% | not timed | not timed | 1120.40 ± 0.6% | 6.78 ± 0.1% | not timed | not timed | 1186.83 ± 0.4% | | 1.01 | 1.07 | 176.07 |
| imported/sherlock/quotes | 14437 | 1398.43 ± 0.4% | not timed | not timed | 1764.37 ± 0.3% | 35.08 ± 0.5% | not timed | not timed | 1397.75 ± 0.3% | | 1.00 | 0.79 | 39.87 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 608.96 ± 0.2% | not timed | not timed | 15691.27 ± 0.6% | 36.52 ± 0.4% | not timed | not timed | 609.28 ± 0.6% | | 1.00 | 0.0388 | 16.68 |
| imported/sherlock/word-ending-n | 35297 | 480.63 ± 0.4% | not timed | not timed | 409.34 ± 0.1% | 23.39 ± 0.7% | not timed | not timed | 481.51 ± 0.4% | | 1.00 | 1.17 | 20.55 |
| imported/sherlock/repeated-class-negation | 2130 | 14649.77 ± 0.7% | not timed | not timed | 10976.07 ± 0.9% | 11.55 ± 0.3% | not timed | not timed | 14698.15 ± 0.6% | | 1.00 | 1.33 | 1268.40 |
| imported/sherlock/ing-suffix | 20547 | 564.39 ± 8.7% | not timed | not timed | 517.17 ± 0.2% | 28.84 ± 1.9% | not timed | not timed | 562.91 ± 0.1% | | 1.00 | 1.09 | 19.57 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 606.60 ± 0.6% | not timed | not timed | 2090.79 ± 0.9% | 20.50 ± 0.3% | not timed | not timed | 605.94 ± 0.6% | | 1.00 | 0.29 | 29.59 |
| opt/accelerate/whole-line | 239963 | 457.47 ± 0.2% | not timed | not timed | 372.54 ± 0.1% | 92.16 ± 14.5% | not timed | not timed | 457.37 ± 0.3% | | 1.00 | 1.23 | 4.96 |
| opt/accelerate/non-dna | 16745 | 425.26 ± 1.0% | not timed | not timed | 399.64 ± 0.2% | 29.32 ± 21.5% | not timed | not timed | 427.00 ± 0.3% | | 1.00 | 1.06 | 14.50 |
| opt/backtrack/words-english | 40536 | 136.56 ± 0.3% | not timed | not timed | 94.77 ± 0.2% | 19.90 ± 6.9% | not timed | not timed | 136.14 ± 7.8% | | 1.00 | 1.44 | 6.86 |
| opt/fixed-length/too-small-ascii | 0 | 310.69 ± 0.2% | not timed | not timed | 685.11 ± 0.8% | 80.01 ± 1.1% | not timed | not timed | 313.58 ± 0.3% | | 0.99 | 0.45 | 3.88 |
| opt/fixed-length/too-big-ascii | 0 | 3493.49 ± 0.5% | not timed | not timed | 5783.55 ± 0.3% | 124.61 ± 0.3% | not timed | not timed | 3464.97 ± 0.6% | | 1.01 | 0.60 | 28.04 |
| opt/fixed-length/go33484-1 | 0 | 670172.55 ± 0.2% | not timed | not timed | 1107680.64 ± 0.4% | 61383.73 ± 0.6% | not timed | not timed | 667820.69 ± 0.6% | | 1.00 | 0.61 | 10.92 |
| opt/fixed-length/go33484-2 | 0 | 670486.24 ± 0.4% | not timed | not timed | 1103419.07 ± 0.2% | 32192.83 ± 1.9% | not timed | not timed | 668387.13 ± 0.2% | | 1.00 | 0.61 | 20.83 |
| opt/fixed-length/go33484-3 | 0 | 2430.40 ± 2.9% | not timed | not timed | 109086.06 ± 0.4% | 754.30 ± 0.9% | not timed | not timed | 2461.72 ± 3.7% | | 0.99 | 0.0223 | 3.22 |
| opt/literal-alt/one-pattern | 1 | 546.06 ± 1.4% | not timed | not timed | 540.38 ± 0.1% | 0.39 ± 0.4% | not timed | not timed | 547.43 ± 1.7% | | 1.00 | 1.01 | 1394.68 |
| opt/onepass/fn-predicate | 916 | 369.18 ± 0.8% | not timed | not timed | 329.84 ± 0.2% | 200.18 ± 13.4% | not timed | not timed | 372.20 ± 1.0% | | 0.99 | 1.12 | 1.84 |
| opt/onepass/first-three-words-english | 35128 | 176.45 ± 1.7% | not timed | not timed | 198.89 ± 0.3% | 76.57 ± 14.5% | not timed | not timed | 176.43 ± 1.8% | | 1.00 | 0.89 | 2.30 |
| opt/prefilter/literal-english | 1 | 19525.92 ± 1.0% | not timed | not timed | 18786.29 ± 1.0% | 16927.90 ± 0.7% | not timed | not timed | 19551.91 ± 0.4% | | 1.00 | 1.04 | 1.15 |
| opt/prefilter/literal-casei-english | 1 | 14299.90 ± 0.4% | not timed | not timed | 4305.84 ± 0.2% | 32.69 ± 0.3% | not timed | not timed | 14275.30 ± 0.5% | | 1.00 | 3.32 | 437.50 |
| opt/prefilter/literal-russian | 1 | 20869.95 ± 0.4% | not timed | not timed | 19473.00 ± 1.5% | 3309.88 ± 0.4% | not timed | not timed | 20874.30 ± 0.4% | | 1.00 | 1.07 | 6.31 |
| opt/prefilter/literal-casei-russian | 1 | 8555.50 ± 0.8% | not timed | not timed | 3878.80 ± 0.3% | 31.73 ± 0.3% | not timed | not timed | 8558.39 ± 0.5% | | 1.00 | 2.21 | 269.65 |
| opt/prefilter/rust-functions | 948 | 6800.10 ± 1.6% | not timed | not timed | 8867.66 ± 0.9% | 1869.33 ± 27.8% | not timed | not timed | 6815.57 ± 0.4% | | 1.00 | 0.77 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29904007.12 ± 0.1% | not timed | not timed | 21613803.29 ± 0.3% | 50.51 ± 0.1% | not timed | not timed | 29858221.49 ± 0.1% | | 1.00 | 1.38 | 592006.37 |
| opt/reverse-inner/holmes | 2593 | 9871.01 ± 1.0% | not timed | not timed | 9463.20 ± 0.3% | 23.82 ± 2.1% | not timed | not timed | 9884.36 ± 0.6% | | 1.00 | 1.04 | 414.45 |
| opt/reverse-inner/email | 47 | 36049.12 ± 2.3% | not timed | not timed | 44637.81 ± 1.3% | 32.41 ± 0.3% | not timed | not timed | 36634.58 ± 2.5% | | 0.98 | 0.81 | 1112.29 |
| opt/reverse-inner/factored-prefix | 3542 | 599.50 ± 0.2% | not timed | not timed | 596.78 ± 0.2% | 12.38 ± 0.8% | not timed | not timed | 599.61 ± 0.2% | | 1.00 | 1.00 | 48.43 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5547.96 ± 0.1% | not timed | not timed | 615.71 ± 0.1% | 74.83 ± 0.2% | not timed | not timed | 5521.55 ± 0.1% | | 1.00 | 9.01 | 74.14 |
| opt/reverse-inner/no-quadratic-forward | 0 | 685.98 ± 6.9% | not timed | not timed | 287.60 ± 0.1% | 24.85 ± 0.2% | not timed | not timed | 686.79 ± 2.1% | | 1.00 | 2.39 | 27.61 |
| opt/reverse-suffix/holmes | 4073 | 10207.88 ± 0.2% | not timed | not timed | 8351.22 ± 0.3% | 24.17 ± 2.0% | not timed | not timed | 10266.94 ± 0.9% | | 0.99 | 1.22 | 422.37 |
| opt/reverse-suffix/no-quadratic | 0 | 5519.88 ± 0.4% | not timed | not timed | 613.46 ± 0.2% | 74.76 ± 0.2% | not timed | not timed | 5550.59 ± 0.2% | | 0.99 | 9.00 | 73.83 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.29 ± 2.8% | not timed | not timed | 132.87 ± 0.2% | 14.36 ± 18.0% | not timed | not timed | 122.13 ± 7.2% | | 0.99 | 0.91 | 8.45 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.63 ± 0.3% | not timed | not timed | 130.48 ± 2.0% | 13.04 ± 14.9% | not timed | not timed | 121.71 ± 2.5% | | 1.00 | 0.93 | 9.33 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.21 ± 0.8% | not timed | not timed | 0.55 ± 0.3% | 112.44 ± 7.3% | not timed | not timed | 0.21 ± 2.6% | | 1.00 | 0.38 | 0.0019 |
| reported/i1095-word-repetition/ascii-search | 256 | 318.21 ± 0.2% | not timed | not timed | 291.89 ± 1.3% | 102.79 ± 0.2% | not timed | not timed | 314.96 ± 0.5% | | 1.01 | 1.09 | 3.10 |
| reported/i13-subset-regex/original-ascii | 4094 | 11108.34 ± 1.0% | not timed | not timed | 4494.99 ± 1.1% | 11.50 ± 0.1% | not timed | not timed | 11156.91 ± 1.1% | | 1.00 | 2.47 | 965.82 |
| reported/i13-subset-regex/original-unicode | 4094 | 10960.63 ± 1.3% | not timed | not timed | 250.95 ± 3.5% | 11.50 ± 1.5% | not timed | not timed | 11113.10 ± 2.3% | | 0.99 | 43.68 | 953.34 |
| reported/i13-subset-regex/big-ascii | 1955 | 10582.82 ± 1.5% | not timed | not timed | 67.97 ± 3.7% | 9.77 ± 0.1% | not timed | not timed | 10645.46 ± 1.0% | | 0.99 | 155.70 | 1082.92 |
| reported/i13-subset-regex/big-unicode | 1955 | 10542.17 ± 1.3% | not timed | not timed | 12.22 ± 55.0% | 9.83 ± 0.1% | not timed | not timed | 10659.72 ± 0.9% | | 0.99 | 862.43 | 1071.97 |
| reported/i13-subset-regex/huge-ascii | 55 | 9904.23 ± 2.4% | not timed | not timed | 10.99 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 9861.55 ± 3.1% | | 1.00 | 900.97 | 1130.30 |
| reported/i13-subset-regex/huge-unicode | 55 | 9864.01 ± 3.7% | not timed | not timed | 10.96 ± 0.3% | 8.76 ± 0.1% | not timed | not timed | 9801.30 ± 2.6% | | 1.01 | 899.93 | 1125.95 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.56 ± 0.1% | not timed | not timed | 10.99 ± 0.2% | 8.74 ± 1.0% | not timed | not timed | 3.55 ± 0.1% | | 1.00 | 0.32 | 0.41 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.04 ± 0.1% | not timed | not timed | 10.94 ± 0.3% | 8.71 ± 0.3% | not timed | not timed | 5.03 ± 0.2% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 486.29 ± 0.4% | not timed | not timed | 104.13 ± 0.2% | 6.65 ± 0.1% | not timed | not timed | 486.98 ± 0.3% | | 1.00 | 4.67 | 73.16 |
| reported/i787-keywords/opt-ascii | 5674 | 487.74 ± 0.2% | not timed | not timed | 273.91 ± 0.4% | 10.27 ± 0.5% | not timed | not timed | 487.93 ± 0.4% | | 1.00 | 1.78 | 47.49 |
| slow/quadratic-regex-1x | 100 | 7.12 ± 0.2% | not timed | not timed | 4.91 ± 0.1% | 0.05 ± 0.5% | not timed | not timed | 7.14 ± 0.4% | | 1.00 | 1.45 | 144.41 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 9.8% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.3% | not timed | not timed | 3.41 ± 0.2% | | 1.00 | 1.24 | 268.34 |
| slow/quadratic-haystack-1x | 100 | 21.13 ± 1.2% | not timed | not timed | 9.99 ± 0.2% | 1.01 ± 6.8% | not timed | not timed | 21.18 ± 7.0% | | 1.00 | 2.12 | 20.83 |
| slow/quadratic-haystack-2x | 200 | 17.76 ± 1.4% | not timed | not timed | 5.52 ± 0.2% | 0.55 ± 12.6% | not timed | not timed | 17.83 ± 2.0% | | 1.00 | 3.22 | 32.59 |
| unicode/codepoints/any-one | 1112064 | 289.60 ± 0.3% | not timed | not timed | 175.48 ± 0.2% | 16.91 ± 28.4% | not timed | not timed | 289.31 ± 0.3% | | 1.00 | 1.65 | 17.13 |
| unicode/codepoints/any-all | 4382592 | 269.08 ± 0.3% | not timed | not timed | 246.51 ± 0.3% | 117.09 ± 0.1% | not timed | not timed | 269.12 ± 0.3% | | 1.00 | 1.09 | 2.30 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.72 ± 1.0% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 598.15 ± 0.5% | not timed | not timed | 614.80 ± 0.2% | 133.58 ± 0.2% | not timed | not timed | 598.42 ± 0.2% | | 1.00 | 0.97 | 4.48 |
| unicode/overlapping-words/ascii | 6156 | 31.53 ± 0.5% | not timed | not timed | 38.83 ± 0.3% | 3.88 ± 0.7% | not timed | not timed | 31.50 ± 0.5% | | 1.00 | 0.81 | 8.14 |
| unicode/overlapping-words/english | 6156 | 1.40 ± 0.4% | not timed | not timed | 4.45 ± 0.2% | 2.34 ± 1.1% | not timed | not timed | 1.40 ± 0.3% | | 1.00 | 0.31 | 0.60 |
| unicode/overlapping-words/russian | 5710 | 1.20 ± 0.2% | not timed | not timed | 4.11 ± 0.3% | 6.11 ± 8.9% | not timed | not timed | 1.19 ± 9.8% | | 1.01 | 0.29 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 128.69 ± 3.3% | not timed | not timed | 82.33 ± 0.4% | 11.67 ± 17.4% | not timed | not timed | 128.70 ± 0.7% | | 1.00 | 1.56 | 11.03 |
| unicode/word/boundary-long-english | 3466 | 614.00 ± 0.3% | not timed | not timed | 604.59 ± 0.6% | 32.36 ± 0.3% | not timed | not timed | 615.57 ± 0.2% | | 1.00 | 1.02 | 18.98 |
| unicode/word/around-holmes-english | 27 | 18793.44 ± 0.7% | not timed | not timed | 18580.97 ± 0.9% | 22.07 ± 0.8% | not timed | not timed | 18790.21 ± 0.6% | | 1.00 | 1.01 | 851.69 |
| wild/bibleref/long | 874 | 563.09 ± 0.2% | not timed | not timed | 582.57 ± 0.3% | 6.81 ± 0.2% | not timed | not timed | 563.09 ± 0.2% | | 1.00 | 0.97 | 82.73 |
| wild/bibleref/short | 30 | 24.84 ± 7.9% | not timed | not timed | 30.64 ± 0.7% | 14.14 ± 11.2% | not timed | not timed | 25.54 ± 2.7% | | 0.97 | 0.81 | 1.76 |
| wild/bibleref/line | 874 | 393.13 ± 0.1% | not timed | not timed | 211.85 ± 0.3% | 9.12 ± 0.3% | not timed | not timed | 393.48 ± 0.1% | | 1.00 | 1.86 | 43.12 |
| wild/caddy/caddy | 6 | 417.78 ± 9.3% | not timed | not timed | 245.12 ± 0.2% | 68.35 ± 16.5% | not timed | not timed | 418.01 ± 0.2% | | 1.00 | 1.70 | 6.11 |
| wild/dot-star-capture/rust-src-tools | 6 | 1065.58 ± 0.9% | not timed | not timed | 347.42 ± 0.3% | 13.53 ± 0.3% | not timed | not timed | 1065.06 ± 0.7% | | 1.00 | 3.07 | 78.73 |
| wild/ruff/noqa | 84 | 435.04 ± 0.3% | not timed | not timed | 460.25 ± 0.2% | 19.49 ± 2.0% | not timed | not timed | 432.84 ± 2.3% | | 1.01 | 0.95 | 22.32 |
| wild/ruff/unnecessary-coding-comment | 16 | 960.90 ± 0.3% | not timed | not timed | 697.85 ± 0.3% | 136.37 ± 11.1% | not timed | not timed | 958.06 ± 0.5% | | 1.00 | 1.38 | 7.05 |
| wild/ruff/string-quote-prefix | 2972 | 1355.31 ± 0.8% | not timed | not timed | 438.57 ± 0.2% | 376.52 ± 30.2% | not timed | not timed | 1355.52 ± 0.7% | | 1.00 | 3.09 | 3.60 |
| wild/ruff/space-around-operator | 1224378 | 219.83 ± 1.9% | not timed | not timed | 187.11 ± 0.2% | 18.42 ± 1.8% | not timed | not timed | 220.58 ± 1.9% | | 1.00 | 1.17 | 11.93 |
| wild/ruff/shebang | 282 | 981.27 ± 0.4% | not timed | not timed | 329.00 ± 0.3% | 111.23 ± 12.2% | not timed | not timed | 986.81 ± 0.5% | | 0.99 | 2.98 | 8.82 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13772.90 ± 0.4% | not timed | not timed | 13757.16 ± 1.5% | 6911.70 ± 3.2% | not timed | not timed | 13783.79 ± 0.2% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12812.46 ± 0.6% | not timed | not timed | 13313.01 ± 0.7% | 6369.81 ± 0.6% | not timed | not timed | 12823.44 ± 0.4% | | 1.00 | 0.96 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13160.01 ± 0.2% | not timed | not timed | 13540.36 ± 0.4% | 6593.82 ± 0.6% | not timed | not timed | 13193.94 ± 1.1% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9544.76 ± 0.3% | not timed | not timed | 13558.08 ± 0.6% | 6697.92 ± 1.4% | not timed | not timed | 9545.33 ± 0.2% | | 1.00 | 0.70 | 1.43 |
| wild/url/search | 234965 | 121.70 ± 13.5% | not timed | not timed | 65.56 ± 0.4% | 2.24 ± 0.8% | not timed | not timed | 122.31 ± 13.9% | | 1.00 | 1.86 | 54.32 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 37.4% | not timed | not timed | 0.01 ± 1.6% | 0.01 ± 13.4% | not timed | not timed | 0.03 ± 11.3% | | 0.99 | 3.06 | 3.95 |
| dictionary/compile/english-15 | 1 | 0.34 ± 21.2% | not timed | not timed | 0.07 ± 1.6% | 0.10 ± 9.3% | not timed | not timed | 0.35 ± 3.2% | | 0.98 | 4.91 | 3.27 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 18.2% | not timed | not timed | 0.02 ± 0.8% | 34.42 ± 10.8% | not timed | not timed | 0.25 ± 0.8% | | 1.00 | 13.03 | 0.0072 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.15 ± 2.5% | not timed | not timed | 11.60 ± 0.5% | 52.96 ± 17.9% | not timed | not timed | 47.37 ± 2.4% | | 1.00 | 4.07 | 0.89 |
| reported/i787-keywords/compile | 1 | 33.62 ± 4.7% | not timed | not timed | 2.11 ± 0.8% | 16.60 ± 38.0% | not timed | not timed | 34.55 ± 0.4% | | 0.97 | 15.92 | 2.03 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 368.40 ± 4.0% | not timed | not timed | 118.92 ± 0.2% | 569.63 ± 13.9% | not timed | not timed | 368.60 ± 4.7% | | 1.00 | 3.10 | 0.65 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.29 ± 2.0% | not timed | not timed | 4.09 ± 1.0% | 42.66 ± 18.6% | not timed | not timed | 47.87 ± 20.6% | | 0.99 | 11.57 | 1.11 |
| unicode/compile/one-letter | 53 | 6.71 ± 3.5% | not timed | not timed | 4.48 ± 0.8% | 61.87 ± 17.8% | not timed | not timed | 6.70 ± 9.6% | | 1.00 | 1.50 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 13.9% | not timed | not timed | 0.10 ± 0.4% | 63.14 ± 9.1% | not timed | not timed | 1.08 ± 17.8% | | 1.00 | 10.92 | 0.0170 |
| unicode/compile/fifty-letters-ascii | 1 | 219.70 ± 4.9% | not timed | not timed | 52.10 ± 0.1% | 198.72 ± 20.8% | not timed | not timed | 221.55 ± 12.6% | | 0.99 | 4.22 | 1.11 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 380.86 ± 17.8% | not timed | not timed | 45.86 ± 0.5% | 668.67 ± 21.0% | not timed | not timed | 386.04 ± 26.8% | | 0.99 | 8.31 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 616.74 ± 7.7% | not timed | not timed | 144.58 ± 0.3% | 638.15 ± 28.0% | not timed | not timed | 618.93 ± 3.3% | | 1.00 | 4.27 | 0.97 |
| unicode/compile/negated-class-matches-codepoint | 1 | 326.88 ± 6.9% | not timed | not timed | 51.11 ± 0.3% | 1228.02 ± 31.1% | not timed | not timed | 330.26 ± 8.2% | | 0.99 | 6.40 | 0.27 |
| wild/bibleref/compile | 3 | 5.83 ± 6.7% | not timed | not timed | 1.91 ± 0.8% | 30.49 ± 8.5% | not timed | not timed | 5.87 ± 4.2% | | 0.99 | 3.05 | 0.19 |
| wild/url/compile | 1 | 0.63 ± 18.1% | not timed | not timed | 0.14 ± 0.9% | 0.42 ± 28.6% | not timed | not timed | 0.63 ± 1.7% | | 0.99 | 4.34 | 1.50 |

