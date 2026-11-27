# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
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
| literal: a word | 217 | 35581.22 ± 1.5% | 9424.55 ± 1.5% | 23.12 ± 3.5% | 29973.00 ± 0.8% | 9177.78 ± 11.1% | 9.90 ± 0.4% | 80.92 ± 0.4% | 35609.15 ± 1.1% | 3.78 | 1.00 | 1.19 | 3.88 |
| literal: a word that is not there | 0 | 50144.36 ± 1.0% | 8744.13 ± 0.2% | 23.28 ± 0.7% | 35477.50 ± 1.9% | 33825.38 ± 1.3% | 9.78 ± 0.8% | 75.43 ± 0.7% | 50327.82 ± 0.3% | 5.73 | 1.00 | 1.41 | 1.48 |
| literal: one of four words | 661 | 12452.00 ± 0.2% | 1283.51 ± 1.3% | 12.69 ± 1.9% | 8833.99 ± 0.7% | 19.24 ± 0.6% | 3.48 ± 0.2% | 6.41 ± 0.8% | 12420.34 ± 0.3% | 9.70 | 1.00 | 1.41 | 647.05 |
| literal: a word in any case | 217 | 31998.60 ± 0.4% | 1381.01 ± 0.8% | 17.41 ± 0.8% | 8980.55 ± 2.1% | 36.43 ± 0.1% | refused | differs | 32042.06 ± 0.4% | 23.17 | 1.00 | 3.56 | 878.26 |
| literal: an href attribute | 33 | 31541.38 ± 1.2% | 478.39 ± 0.1% | 22.40 ± 0.6% | 26972.04 ± 1.5% | 2306.68 ± 1.0% | 7.40 ± 0.3% | 70.82 ± 0.4% | 31696.56 ± 0.4% | 65.93 | 1.00 | 1.17 | 13.67 |
| literal: a word, second text | 123 | 37741.34 ± 0.6% | 4949.62 ± 1.5% | 22.92 ± 1.1% | 30391.78 ± 0.3% | 8614.52 ± 5.5% | 11.29 ± 0.5% | 67.78 ± 0.3% | 37774.87 ± 0.5% | 7.63 | 1.00 | 1.24 | 4.38 |
| class: two capitalized words | 1331 | 892.88 ± 6.2% | 475.14 ± 1.0% | 21.68 ± 6.4% | 446.63 ± 0.3% | 34.39 ± 11.4% | 8.48 ± 1.2% | 61.64 ± 0.4% | 893.41 ± 0.4% | 1.88 | 1.00 | 2.00 | 25.96 |
| class: a word that ends in ing | 3399 | 452.93 ± 0.6% | 453.30 ± 0.4% | 15.47 ± 0.7% | 419.26 ± 0.3% | 25.44 ± 28.3% | 4.78 ± 0.2% | 16.00 ± 0.7% | 453.67 ± 1.5% | 1.00 | 1.00 | 1.08 | 17.81 |
| class: a word in capitals | 2332 | 1220.45 ± 0.9% | 479.41 ± 0.2% | 22.79 ± 4.7% | 438.43 ± 3.0% | 36.39 ± 20.0% | 9.60 ± 1.2% | 78.89 ± 1.2% | 1224.71 ± 0.5% | 2.55 | 1.00 | 2.78 | 33.54 |
| class: a number | 8288 | 2470.89 ± 7.8% | 661.01 ± 7.1% | 22.96 ± 24.6% | 1405.22 ± 3.7% | 35.57 ± 13.8% | 0.30 ± 0.3% | 56.47 ± 1.2% | 2468.02 ± 1.0% | 3.74 | 1.00 | 1.76 | 69.47 |
| class: two capitalized words, second text | 5359 | 405.01 ± 1.0% | 410.88 ± 0.3% | 19.81 ± 0.6% | 370.26 ± 0.5% | 28.95 ± 4.0% | 9.89 ± 0.2% | 56.94 ± 3.5% | 405.35 ± 0.6% | 0.99 | 1.00 | 1.09 | 13.99 |
| other: a word between two words | 6104 | 669.60 ± 0.3% | 467.05 ± 2.6% | 19.64 ± 0.5% | 631.77 ± 0.5% | 96.37 ± 12.7% | 6.57 ± 0.1% | 62.53 ± 0.9% | 638.86 ± 0.1% | 1.43 | 1.05 | 1.06 | 6.95 |
| other: a number before a unit, second text | 1481 | 8189.07 ± 0.4% | 917.76 ± 2.7% | 21.62 ± 0.9% | 6410.26 ± 0.4% | 34.55 ± 13.8% | 10.32 ± 4.8% | 60.26 ± 2.5% | 8194.79 ± 6.0% | 8.92 | 1.00 | 1.28 | 237.03 |
| other: a heading's start tag | 110 | 19285.70 ± 0.8% | 580.40 ± 1.9% | 22.99 ± 0.6% | 1985.76 ± 1.6% | 1568.34 ± 2.3% | 9.07 ± 0.1% | 83.04 ± 0.1% | 19297.86 ± 0.4% | 33.23 | 1.00 | 9.71 | 12.30 |
| other: a whole word | 217 | 25330.30 ± 0.8% | 471.90 ± 0.7% | 23.74 ± 0.8% | 21984.48 ± 0.5% | 42.01 ± 9.1% | 8.43 ± 0.2% | 48.51 ± 15.2% | 25398.57 ± 0.5% | 53.68 | 1.00 | 1.15 | 602.97 |
| other: a line's first word, second text | 3716 | 1888.94 ± 1.8% | 464.80 ± 0.3% | 24.98 ± 0.1% | 1809.38 ± 1.0% | 55.35 ± 3.2% | refused | refused | 1904.72 ± 1.0% | 4.06 | 0.99 | 1.04 | 34.13 |
| other: fourteen octets before an x | 87 | 27606.68 ± 0.5% | 197.04 ± 1.2% | 5.92 ± 6.1% | 2761.73 ± 0.8% | 9.00 ± 0.7% | differs | 15.69 ± 0.6% | 27553.81 ± 0.5% | 140.11 | 1.00 | 10.00 | 3067.10 |
| other: a Greek word | 21815 | 444.18 ± 0.5% | 341.12 ± 0.1% | 25.74 ± 0.3% | 235.91 ± 0.3% | 43.61 ± 7.8% | differs | refused | 444.10 ± 21.4% | 1.30 | 1.00 | 1.88 | 10.19 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.64 ± 1.4% | 24.33 ± 0.5% | 0.79 ± 1.8% | 15.44 ± 0.2% | 2.18 ± 0.6% | differs | 3.30 ± 3.1% | 24.39 ± 1.1% | 1.01 | 1.01 | 1.60 | 11.28 |
| a UUID | 32895 | 21.50 ± 14.5% | 21.55 ± 0.2% | 0.51 ± 1.0% | 11.74 ± 1.0% | 2.32 ± 3.8% | 0.40 ± 0.3% | 3.00 ± 1.7% | 21.45 ± 0.4% | 1.00 | 1.00 | 1.83 | 9.29 |
| an IPv4 address | 33176 | 31.00 ± 1.4% | 30.87 ± 12.8% | 1.78 ± 15.0% | 22.13 ± 2.9% | 5.42 ± 12.9% | differs | 3.24 ± 7.3% | 30.87 ± 1.9% | 1.00 | 1.00 | 1.40 | 5.72 |
| a date and time | 32954 | 28.64 ± 2.3% | 29.49 ± 0.5% | 1.31 ± 3.4% | 16.82 ± 0.4% | 6.29 ± 2.1% | 0.70 ± 0.2% | 5.94 ± 4.8% | 29.55 ± 0.5% | 0.97 | 0.97 | 1.70 | 4.55 |
| a field path | 32606 | 26.49 ± 1.0% | 26.23 ± 2.1% | 0.88 ± 1.4% | 17.85 ± 0.2% | 2.67 ± 4.3% | differs | 2.32 ± 0.4% | 26.24 ± 1.6% | 1.01 | 1.01 | 1.48 | 9.91 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.48 ± 0.9% | 8.41 ± 0.4% | 8.51 ± 0.4% | 10.42 ± 1.0% | 4.48 ± 2.1% | 0.58 ± 0.8% | none | 8.47 ± 0.6% | 1.01 | 1.00 | 0.81 | 1.89 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 178.80 ± 0.3% | 179.03 ± 0.8% | 210.63 ± 0.4% | 78.83 ± 6.0% | 187.26 ± 17.4% | 547.67 ± 4.1% | 3788.63 ± 1.7% | 179.02 ± 1.0% | 1.00 | 1.00 | 2.27 | 0.95 |
| a UUID | 62 | 118.22 ± 1.6% | 118.43 ± 0.3% | 132.59 ± 0.5% | 45.35 ± 1.2% | 93.06 ± 1.7% | 196.08 ± 1.4% | 4196.82 ± 0.5% | 118.28 ± 0.2% | 1.00 | 1.00 | 2.61 | 1.27 |
| an IPv4 address | 29 | 370.48 ± 0.4% | 370.39 ± 0.7% | 522.50 ± 1.0% | 67.59 ± 2.1% | 115.61 ± 2.4% | 299.34 ± 1.3% | 6950.51 ± 0.1% | 369.37 ± 1.6% | 1.00 | 1.00 | 5.48 | 3.20 |
| a date and time | 56 | 270.31 ± 0.2% | 269.04 ± 1.4% | 344.02 ± 0.2% | 65.93 ± 0.7% | 124.93 ± 2.8% | 354.01 ± 6.9% | 4323.41 ± 0.5% | 270.54 ± 0.3% | 1.00 | 1.00 | 4.10 | 2.16 |
| a field path | 39 | 172.85 ± 1.5% | 173.50 ± 0.1% | 203.16 ± 0.1% | 71.70 ± 0.8% | 178.55 ± 1.2% | 580.02 ± 1.2% | 4584.79 ± 3.4% | 173.25 ± 1.1% | 1.00 | 1.00 | 2.41 | 0.97 |
| literal: a word | 7 | 543.30 ± 0.8% | 576.03 ± 0.3% | 1074.58 ± 0.5% | 484.48 ± 0.8% | 600.30 ± 5.0% | 1250.28 ± 0.8% | 21318.06 ± 0.7% | 543.15 ± 17.7% | 0.94 | 1.00 | 1.12 | 0.91 |
| literal: a word that is not there | 8 | 525.60 ± 0.4% | 561.08 ± 0.7% | 1008.73 ± 1.1% | 444.35 ± 1.7% | 578.46 ± 1.5% | 1171.93 ± 4.1% | 20892.58 ± 0.8% | 524.26 ± 10.8% | 0.94 | 1.00 | 1.18 | 0.91 |
| literal: one of four words | 26 | 206.94 ± 11.5% | 340.27 ± 4.5% | 469.48 ± 2.8% | 41.38 ± 0.7% | 227.51 ± 1.3% | 457.43 ± 0.4% | 14192.57 ± 10.1% | 207.19 ± 0.8% | 0.61 | 1.00 | 5.00 | 0.91 |
| literal: a word in any case | 11 | 377.50 ± 1.4% | 399.30 ± 0.6% | 594.96 ± 1.8% | 14.68 ± 0.3% | 625.99 ± 2.2% | refused | 18535.20 ± 3.2% | 379.90 ± 0.8% | 0.95 | 0.99 | 25.71 | 0.60 |
| literal: an href attribute | 12 | 294.63 ± 0.6% | 306.47 ± 0.1% | 410.95 ± 12.8% | 39.25 ± 1.0% | 440.23 ± 16.7% | 971.78 ± 2.6% | 15837.57 ± 0.1% | 294.93 ± 0.3% | 0.96 | 1.00 | 7.51 | 0.67 |
| literal: a word, second text | 10 | 486.93 ± 0.2% | 529.32 ± 1.6% | 904.42 ± 1.2% | 411.65 ± 2.0% | 502.98 ± 3.9% | 1025.11 ± 2.6% | 20091.64 ± 0.2% | 487.62 ± 0.4% | 0.92 | 1.00 | 1.18 | 0.97 |
| class: two capitalized words | 23 | 380.15 ± 0.8% | 410.92 ± 0.5% | 606.36 ± 1.0% | 92.41 ± 0.6% | 455.66 ± 16.4% | 968.74 ± 17.7% | 6150.32 ± 17.7% | 380.20 ± 17.0% | 0.93 | 1.00 | 4.11 | 0.83 |
| class: a word that ends in ing | 9 | 463.07 ± 1.3% | 531.34 ± 0.5% | 951.40 ± 0.5% | 116.61 ± 1.5% | 652.11 ± 4.3% | 1388.49 ± 0.7% | 14244.34 ± 2.7% | 464.14 ± 1.5% | 0.87 | 1.00 | 3.97 | 0.71 |
| class: a word in capitals | 16 | 414.59 ± 7.1% | 448.58 ± 5.1% | 745.65 ± 10.9% | 120.44 ± 2.7% | 680.39 ± 3.5% | 1303.35 ± 6.5% | 8068.81 ± 6.9% | 415.02 ± 12.2% | 0.92 | 1.00 | 3.44 | 0.61 |
| class: a number | 6 | 515.58 ± 2.0% | 573.16 ± 0.3% | 1120.35 ± 1.3% | 36.17 ± 0.6% | 1257.87 ± 2.9% | 2201.05 ± 5.3% | 17201.33 ± 1.4% | 515.84 ± 0.2% | 0.90 | 1.00 | 14.25 | 0.41 |
| class: two capitalized words, second text | 23 | 380.93 ± 0.4% | 410.97 ± 0.7% | 603.60 ± 1.1% | 93.74 ± 4.7% | 454.84 ± 15.4% | 968.27 ± 5.2% | 6140.99 ± 0.7% | 380.27 ± 0.5% | 0.93 | 1.00 | 4.06 | 0.84 |
| other: a word between two words | 13 | 469.13 ± 0.2% | 485.78 ± 0.3% | 780.33 ± 0.3% | 121.37 ± 1.5% | 450.86 ± 1.6% | 1028.54 ± 0.4% | 10837.18 ± 27.1% | 468.96 ± 0.2% | 0.97 | 1.00 | 3.87 | 1.04 |
| other: a number before a unit, second text | 15 | 321.21 ± 0.8% | 360.16 ± 0.2% | 505.52 ± 0.8% | 33.85 ± 1.8% | 553.67 ± 4.6% | 1128.59 ± 1.5% | 13267.62 ± 0.3% | 321.44 ± 0.3% | 0.89 | 1.00 | 9.49 | 0.58 |
| other: a heading's start tag | 13 | 304.23 ± 0.4% | 310.50 ± 1.6% | 417.05 ± 0.3% | 37.87 ± 0.7% | 544.93 ± 2.3% | 1067.73 ± 0.7% | 13770.47 ± 0.9% | 304.52 ± 0.2% | 0.98 | 1.00 | 8.03 | 0.56 |
| other: a whole word | 11 | 485.34 ± 0.2% | 513.44 ± 0.3% | 862.46 ± 0.4% | 112.02 ± 2.1% | 518.91 ± 4.0% | 1046.85 ± 3.1% | 20750.52 ± 0.3% | 486.13 ± 1.1% | 0.95 | 1.00 | 4.33 | 0.94 |
| other: a line's first word, second text | 17 | 440.98 ± 0.2% | 469.27 ± 1.4% | 777.54 ± 0.3% | 114.84 ± 0.4% | 617.46 ± 3.1% | refused | refused | 441.96 ± 0.5% | 0.94 | 1.00 | 3.84 | 0.71 |
| other: fourteen octets before an x | 16 | 86.55 ± 2.6% | 131.85 ± 0.2% | 158.66 ± 0.2% | 14.12 ± 0.6% | 403.63 ± 3.9% | 442.01 ± 1.4% | 11561.74 ± 0.6% | 87.31 ± 0.4% | 0.66 | 0.99 | 6.13 | 0.21 |
| other: a Greek word | 8 | 333.61 ± 1.2% | 476.24 ± 22.9% | 798.87 ± 1.7% | 49.37 ± 0.6% | 1241.16 ± 2.1% | 2143.99 ± 0.6% | refused | 333.51 ± 0.1% | 0.70 | 1.00 | 6.76 | 0.27 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 26614.12 ± 1.7% | not timed | not timed | 26012.20 ± 0.6% | 1853.74 ± 24.0% | not timed | not timed | 26647.14 ± 14.4% | | 1.00 | 1.02 | 14.36 |
| 01-literal/sherlock-casei-en | 522 | 21807.25 ± 1.9% | not timed | not timed | 7101.04 ± 14.3% | 26.27 ± 3.3% | not timed | not timed | 21787.66 ± 2.9% | | 1.00 | 3.07 | 829.96 |
| 01-literal/sherlock-ru | 724 | 27924.39 ± 1.4% | not timed | not timed | 26629.26 ± 3.1% | 945.47 ± 8.7% | not timed | not timed | 27928.68 ± 0.6% | | 1.00 | 1.05 | 29.53 |
| 01-literal/sherlock-casei-ru | 746 | 9852.72 ± 0.7% | not timed | not timed | 6114.90 ± 0.9% | 28.95 ± 1.0% | not timed | not timed | 9858.70 ± 0.7% | | 1.00 | 1.61 | 340.34 |
| 01-literal/sherlock-zh | 30 | 46627.65 ± 1.5% | not timed | not timed | 33284.29 ± 0.4% | 1270.91 ± 0.3% | not timed | not timed | 46924.96 ± 12.3% | | 0.99 | 1.40 | 36.69 |
| 02-literal-alternate/sherlock-en | 714 | 11238.15 ± 15.2% | not timed | not timed | 8580.60 ± 0.5% | 14.66 ± 3.8% | not timed | not timed | 11262.42 ± 0.2% | | 1.00 | 1.31 | 766.50 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3980.82 ± 4.9% | not timed | not timed | 1769.49 ± 14.5% | 9.47 ± 0.4% | not timed | not timed | 3965.00 ± 19.5% | | 1.00 | 2.25 | 420.21 |
| 02-literal-alternate/sherlock-ru | 899 | 8581.19 ± 0.5% | not timed | not timed | 7706.42 ± 8.9% | 19.75 ± 0.4% | not timed | not timed | 8591.62 ± 0.7% | | 1.00 | 1.11 | 434.46 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1930.37 ± 6.5% | not timed | not timed | 917.91 ± 0.2% | 8.19 ± 0.8% | not timed | not timed | 1923.39 ± 4.4% | | 1.00 | 2.10 | 235.76 |
| 02-literal-alternate/sherlock-zh | 207 | 16097.75 ± 28.3% | not timed | not timed | 10044.34 ± 0.2% | 27.48 ± 1.4% | not timed | not timed | 16071.71 ± 0.4% | | 1.00 | 1.60 | 585.83 |
| 03-date/ascii | 111817 | 112.90 ± 0.7% | not timed | not timed | 78.12 ± 0.4% | 0.18 ± 1.1% | not timed | not timed | 113.35 ± 1.2% | | 1.00 | 1.45 | 618.42 |
| 04-ruff-noqa/real | 84 | 393.22 ± 0.3% | not timed | not timed | 392.75 ± 0.4% | 16.19 ± 0.7% | not timed | not timed | 392.98 ± 0.9% | | 1.00 | 1.00 | 24.29 |
| 04-ruff-noqa/tweaked | 44 | 691.85 ± 0.2% | not timed | not timed | 391.95 ± 0.9% | 289.42 ± 0.8% | not timed | not timed | 691.99 ± 0.6% | | 1.00 | 1.77 | 2.39 |
| 05-lexer-veryl/single | 124800 | 3.66 ± 0.5% | not timed | not timed | 4.29 ± 1.9% | 0.20 ± 4.9% | not timed | not timed | 3.68 ± 0.9% | | 1.00 | 0.85 | 18.39 |
| 06-cloud-flare-redos/original | 107 | 350.07 ± 9.0% | not timed | not timed | 176.21 ± 6.2% | 19.86 ± 1.6% | not timed | not timed | 348.95 ± 1.7% | | 1.00 | 1.99 | 17.63 |
| 06-cloud-flare-redos/simplified-short | 102 | 350.00 ± 15.4% | not timed | not timed | 183.92 ± 4.0% | 21.32 ± 1.0% | not timed | not timed | 349.48 ± 7.5% | | 1.00 | 1.90 | 16.42 |
| 06-cloud-flare-redos/simplified-long | 10000 | 453.41 ± 0.5% | not timed | not timed | 200.67 ± 0.7% | 22.98 ± 21.5% | not timed | not timed | 452.80 ± 9.0% | | 1.00 | 2.26 | 19.73 |
| 07-unicode-character-data/parse-line | 558784 | 196.11 ± 2.2% | not timed | not timed | 155.31 ± 0.6% | 37.05 ± 3.9% | not timed | not timed | 195.86 ± 2.2% | | 1.00 | 1.26 | 5.29 |
| 08-words/all-english | 56691 | 102.28 ± 12.5% | not timed | not timed | 65.66 ± 1.3% | 10.45 ± 5.7% | not timed | not timed | 101.43 ± 9.3% | | 1.01 | 1.56 | 9.79 |
| 08-words/long-english | 839 | 481.09 ± 0.5% | not timed | not timed | 453.46 ± 0.1% | 27.23 ± 40.7% | not timed | not timed | 479.92 ± 0.4% | | 1.00 | 1.06 | 17.67 |
| 09-aws-keys/full | 0 | 397.25 ± 0.2% | not timed | not timed | 411.67 ± 0.2% | 51.19 ± 3.4% | not timed | not timed | 402.23 ± 0.4% | | 0.99 | 0.96 | 7.76 |
| 09-aws-keys/quick | 0 | 892.33 ± 0.8% | not timed | not timed | 743.96 ± 1.1% | 327.56 ± 3.5% | not timed | not timed | 890.28 ± 5.9% | | 1.00 | 1.20 | 2.72 |
| 10-bounded-repeat/letters-en | 1833 | 527.92 ± 1.3% | not timed | not timed | 432.24 ± 0.4% | 17.63 ± 1.1% | not timed | not timed | 525.84 ± 1.1% | | 1.00 | 1.22 | 29.94 |
| 10-bounded-repeat/letters-ru | 3475 | 408.58 ± 2.0% | not timed | not timed | 374.57 ± 0.7% | 18.53 ± 38.1% | not timed | not timed | 407.87 ± 6.1% | | 1.00 | 1.09 | 22.05 |
| 10-bounded-repeat/context | 53 | 70.65 ± 1.5% | not timed | not timed | 54.45 ± 8.3% | 17.43 ± 0.5% | not timed | not timed | 70.61 ± 3.8% | | 1.00 | 1.30 | 4.05 |
| 10-bounded-repeat/capitals | 11 | 498.71 ± 8.0% | not timed | not timed | 469.04 ± 0.2% | 30.34 ± 0.8% | not timed | not timed | 497.63 ± 8.0% | | 1.00 | 1.06 | 16.44 |
| 11-unstructured-to-json/extract | 600 | 40.31 ± 2.1% | not timed | not timed | 62.60 ± 7.0% | 39.29 ± 3.2% | not timed | not timed | 40.46 ± 1.6% | | 1.00 | 0.64 | 1.03 |
| 12-dictionary/single | 1 | 395.33 ± 3.0% | not timed | not timed | 370.52 ± 1.3% | 0.30 ± 0.6% | not timed | not timed | 400.49 ± 1.6% | | 0.99 | 1.07 | 1308.63 |
| 14-quadratic/1x | 100 | 21.58 ± 42.5% | not timed | not timed | 9.45 ± 0.8% | 0.79 ± 1.7% | not timed | not timed | 21.84 ± 1.1% | | 0.99 | 2.28 | 27.41 |
| 14-quadratic/2x | 200 | 19.60 ± 1.3% | not timed | not timed | 4.75 ± 0.4% | 0.42 ± 0.7% | not timed | not timed | 19.70 ± 5.4% | | 0.99 | 4.13 | 46.65 |
| 14-quadratic/10x | 1000 | 11.75 ± 1.1% | not timed | not timed | 0.94 ± 0.5% | 0.09 ± 0.8% | not timed | not timed | 11.74 ± 9.7% | | 1.00 | 12.45 | 127.78 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.06 ± 2.2% | not timed | not timed | 0.37 ± 0.2% | 0.49 ± 4.6% | not timed | not timed | 1.06 ± 1.3% | | 1.00 | 2.86 | 2.18 |
| 04-ruff-noqa/compile-real | 1 | 93.28 ± 5.6% | not timed | not timed | 13.28 ± 7.1% | 127.85 ± 8.8% | not timed | not timed | 93.36 ± 1.4% | | 1.00 | 7.03 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 12.78 ± 1.1% | not timed | not timed | 2.31 ± 1.4% | 6.02 ± 1.6% | not timed | not timed | 12.51 ± 0.6% | | 1.02 | 5.54 | 2.12 |
| 07-unicode-character-data/compile | 1 | 95.77 ± 1.2% | not timed | not timed | 23.39 ± 0.6% | 33.92 ± 1.6% | not timed | not timed | 96.14 ± 1.1% | | 1.00 | 4.10 | 2.82 |
| 09-aws-keys/compile-full | 1 | 43.00 ± 0.3% | not timed | not timed | 7.70 ± 0.9% | 21.14 ± 6.4% | not timed | not timed | 42.38 ± 0.4% | | 1.01 | 5.58 | 2.03 |
| 09-aws-keys/compile-quick | 1 | 147.92 ± 1.0% | not timed | not timed | 44.49 ± 0.6% | 121.92 ± 2.3% | not timed | not timed | 148.34 ± 0.5% | | 1.00 | 3.33 | 1.21 |
| 10-bounded-repeat/compile-context | 1 | 46.35 ± 16.5% | not timed | not timed | 11.38 ± 0.7% | 15.49 ± 2.7% | not timed | not timed | 44.65 ± 2.5% | | 1.04 | 4.07 | 2.99 |
| 10-bounded-repeat/compile-capitals | 1 | 72.77 ± 0.6% | not timed | not timed | 8.28 ± 1.9% | 22.13 ± 28.1% | not timed | not timed | 70.20 ± 0.2% | | 1.04 | 8.79 | 3.29 |
| 11-unstructured-to-json/compile | 1 | 142.82 ± 3.9% | not timed | not timed | 37.29 ± 0.7% | 62.78 ± 10.1% | not timed | not timed | 143.84 ± 11.2% | | 0.99 | 3.83 | 2.27 |
| 12-dictionary/compile-single | 1 | 0.26 ± 2.0% | not timed | not timed | 0.07 ± 0.4% | 0.09 ± 14.5% | not timed | not timed | 0.26 ± 4.2% | | 1.00 | 3.99 | 2.91 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.62 ± 1.7% | not timed | not timed | 5.33 ± 0.3% | 0.50 ± 9.7% | not timed | not timed | 5.61 ± 19.7% | | 1.00 | 1.05 | 11.33 |
| dictionary/search/english-10 | 690 | 165.33 ± 1.8% | not timed | not timed | 118.81 ± 3.7% | 0.01 ± 1.2% | not timed | not timed | 165.18 ± 2.4% | | 1.00 | 1.39 | 30589.77 |
| dictionary/search/english-15 | 15 | 396.04 ± 1.6% | not timed | not timed | 373.27 ± 0.2% | 0.29 ± 1.6% | not timed | not timed | 399.89 ± 2.1% | | 0.99 | 1.06 | 1368.18 |
| folly/awyer-inn-busted | 1 | 18676.97 ± 1.5% | not timed | not timed | 102.61 ± 0.6% | 37.37 ± 1.6% | not timed | not timed | 18707.80 ± 21.6% | | 1.00 | 182.02 | 499.79 |
| folly/literal-never-match-rare | 0 | 52720.10 ± 0.3% | not timed | not timed | 36059.80 ± 8.0% | 53817.76 ± 0.3% | not timed | not timed | 52772.85 ± 0.2% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 22159.94 ± 15.9% | not timed | not timed | 35702.14 ± 0.6% | 1989.75 ± 0.8% | not timed | not timed | 22903.96 ± 27.1% | | 0.97 | 0.62 | 11.14 |
| folly/literal-never-match-tricksy | 1 | 3089.17 ± 1.2% | not timed | not timed | 4760.16 ± 1.1% | 1336.09 ± 10.7% | not timed | not timed | 3091.99 ± 12.6% | | 1.00 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1096.95 ± 1.2% | not timed | not timed | 754.05 ± 1.2% | 299.86 ± 30.8% | not timed | not timed | 1102.60 ± 0.4% | | 0.99 | 1.45 | 3.66 |
| grep/long-words-ascii | 5073 | 387.93 ± 0.6% | not timed | not timed | 385.42 ± 1.0% | 40.25 ± 8.5% | not timed | not timed | 388.42 ± 1.0% | | 1.00 | 1.01 | 9.64 |
| imported/leipzig/twain | 811 | 43848.40 ± 1.7% | not timed | not timed | 33708.23 ± 0.4% | 10427.70 ± 11.5% | not timed | not timed | 43676.22 ± 11.8% | | 1.00 | 1.30 | 4.20 |
| imported/leipzig/twain-insensitive | 965 | 11735.63 ± 1.0% | not timed | not timed | 10687.12 ± 0.5% | 34.53 ± 0.9% | not timed | not timed | 11757.09 ± 0.9% | | 1.00 | 1.10 | 339.82 |
| imported/leipzig/shing | 1540 | 22453.74 ± 5.4% | not timed | not timed | 17270.48 ± 0.4% | 29.50 ± 1.1% | not timed | not timed | 22407.39 ± 5.1% | | 1.00 | 1.30 | 761.02 |
| imported/leipzig/huck-saw | 262 | 20123.57 ± 2.0% | not timed | not timed | 14758.91 ± 2.0% | 27.71 ± 0.4% | not timed | not timed | 20256.99 ± 1.1% | | 0.99 | 1.36 | 726.27 |
| imported/leipzig/word-ending-nn | 262 | 472.52 ± 0.5% | not timed | not timed | 468.26 ± 8.8% | 21.32 ± 0.7% | not timed | not timed | 472.94 ± 0.3% | | 1.00 | 1.01 | 22.16 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 8362.00 ± 0.5% | not timed | not timed | 3035.34 ± 1.8% | 9.44 ± 0.9% | not timed | not timed | 8383.57 ± 0.4% | | 1.00 | 2.75 | 886.12 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 17217.56 ± 2.5% | not timed | not timed | 13851.79 ± 1.7% | 14.96 ± 0.3% | not timed | not timed | 17213.79 ± 2.4% | | 1.00 | 1.24 | 1150.55 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4269.44 ± 0.5% | not timed | not timed | 612.95 ± 1.3% | 9.53 ± 3.7% | not timed | not timed | 4256.46 ± 0.3% | | 1.00 | 6.97 | 448.09 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 14359.10 ± 2.1% | not timed | not timed | 467.54 ± 0.4% | 9.61 ± 2.4% | not timed | not timed | 14396.44 ± 3.4% | | 1.00 | 30.71 | 1494.59 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 13568.41 ± 4.4% | not timed | not timed | 467.88 ± 0.1% | 8.24 ± 0.8% | not timed | not timed | 13584.40 ± 0.7% | | 1.00 | 29.00 | 1646.31 |
| imported/leipzig/tom-river | 2 | 10169.26 ± 3.0% | not timed | not timed | 10505.89 ± 1.0% | 26.80 ± 0.4% | not timed | not timed | 10160.91 ± 0.4% | | 1.00 | 0.97 | 379.50 |
| imported/leipzig/ing | 78424 | 463.82 ± 0.6% | not timed | not timed | 435.85 ± 0.1% | 23.73 ± 5.4% | not timed | not timed | 465.81 ± 0.1% | | 1.00 | 1.06 | 19.55 |
| imported/leipzig/ing-whitespace | 55248 | 1495.64 ± 0.3% | not timed | not timed | 1662.25 ± 0.3% | 17.33 ± 3.4% | not timed | not timed | 1493.51 ± 0.8% | | 1.00 | 0.90 | 86.30 |
| imported/leipzig/awyer-inn | 209 | 8483.24 ± 0.5% | not timed | not timed | 10944.56 ± 0.2% | 19.42 ± 0.9% | not timed | not timed | 8480.08 ± 0.6% | | 1.00 | 0.78 | 436.76 |
| imported/leipzig/quotes-bounded | 8886 | 1793.11 ± 0.3% | not timed | not timed | 2556.52 ± 0.2% | 31.76 ± 0.8% | not timed | not timed | 1796.79 ± 0.4% | | 1.00 | 0.70 | 56.45 |
| imported/leipzig/non-ascii-alternate | 2 | 31565.40 ± 63.3% | not timed | not timed | 15429.71 ± 76.6% | 43.49 ± 5.5% | not timed | not timed | 31567.49 ± 0.7% | | 1.00 | 2.05 | 725.81 |
| imported/leipzig/math-symbols | 69 | 1886.24 ± 0.7% | not timed | not timed | 467.88 ± 0.7% | 30.55 ± 2.8% | not timed | not timed | 1884.61 ± 0.2% | | 1.00 | 4.03 | 61.75 |
| imported/leipzig/bounded-strings-ending-z | 0 | 472.62 ± 1.1% | not timed | not timed | 468.96 ± 1.2% | 20.00 ± 2.0% | not timed | not timed | 472.70 ± 0.1% | | 1.00 | 1.01 | 23.64 |
| imported/lh3lh3-reb/uri | 17549 | 624.15 ± 3.6% | not timed | not timed | 876.80 ± 1.4% | 23.65 ± 3.9% | not timed | not timed | 625.35 ± 0.9% | | 1.00 | 0.71 | 26.39 |
| imported/lh3lh3-reb/email | 15057 | 622.95 ± 24.4% | not timed | not timed | 875.95 ± 2.4% | 25.86 ± 2.9% | not timed | not timed | 620.97 ± 1.7% | | 1.00 | 0.71 | 24.09 |
| imported/lh3lh3-reb/date | 668 | 733.86 ± 0.3% | not timed | not timed | 788.93 ± 1.3% | 41.71 ± 5.4% | not timed | not timed | 734.97 ± 0.6% | | 1.00 | 0.93 | 17.59 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 576.33 ± 4.8% | not timed | not timed | 343.92 ± 0.2% | 12.83 ± 1.5% | not timed | not timed | 576.65 ± 5.3% | | 1.00 | 1.68 | 44.92 |
| imported/mariomka/email | 92 | 30475.88 ± 2.5% | not timed | not timed | 46619.86 ± 0.6% | 27.91 ± 8.5% | not timed | not timed | 30634.23 ± 1.0% | | 0.99 | 0.65 | 1091.80 |
| imported/mariomka/uri | 5301 | 5098.94 ± 0.6% | not timed | not timed | 6014.06 ± 0.5% | 27.73 ± 8.5% | not timed | not timed | 5097.90 ± 0.6% | | 1.00 | 0.85 | 183.89 |
| imported/mariomka/ip | 5 | 1956.84 ± 3.9% | not timed | not timed | 1792.10 ± 0.3% | 17.78 ± 6.0% | not timed | not timed | 1968.25 ± 4.1% | | 0.99 | 1.09 | 110.05 |
| imported/rsc/no-exponential | 0 | 692.31 ± 0.4% | not timed | not timed | 327.42 ± 0.8% | 20.13 ± 24.0% | not timed | not timed | 690.91 ± 0.8% | | 1.00 | 2.11 | 34.40 |
| imported/rsc/literal | 1 | 1399.59 ± 9.2% | not timed | not timed | 1735.90 ± 0.3% | 208.96 ± 31.2% | not timed | not timed | 1498.60 ± 7.9% | | 0.93 | 0.81 | 6.70 |
| imported/rsc/not-literal | 2 | 747.20 ± 0.4% | not timed | not timed | 656.56 ± 0.3% | 42.43 ± 7.3% | not timed | not timed | 744.81 ± 2.6% | | 1.00 | 1.14 | 17.61 |
| imported/rsc/match-class | 1 | 1475.13 ± 0.3% | not timed | not timed | 1393.38 ± 12.2% | 52.59 ± 11.2% | not timed | not timed | 1471.60 ± 0.3% | | 1.00 | 1.06 | 28.05 |
| imported/rsc/match-class-in-range | 1 | 1475.52 ± 2.6% | not timed | not timed | 2492.62 ± 19.1% | 54.04 ± 13.5% | not timed | not timed | 1470.77 ± 3.9% | | 1.00 | 0.59 | 27.30 |
| imported/rsc/match-class-unicode | 1 | 443.50 ± 0.4% | not timed | not timed | 405.48 ± 0.4% | 64.32 ± 50.3% | not timed | not timed | 443.73 ± 0.1% | | 1.00 | 1.09 | 6.90 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1229.41 ± 0.9% | not timed | not timed | 883.55 ± 0.8% | 264.99 ± 3.0% | not timed | not timed | 1229.04 ± 0.4% | | 1.00 | 1.39 | 4.64 |
| imported/rsc/anchored-literal-long-non-match | 0 | 18463.86 ± 0.3% | not timed | not timed | 13172.71 ± 29.0% | 3978.32 ± 1.8% | not timed | not timed | 18464.61 ± 0.4% | | 1.00 | 1.40 | 4.64 |
| imported/rsc/anchored-literal-short-match | 4 | 644.91 ± 30.2% | not timed | not timed | 441.66 ± 1.2% | 84.44 ± 10.4% | not timed | not timed | 650.39 ± 1.6% | | 0.99 | 1.46 | 7.64 |
| imported/rsc/anchored-literal-long-match | 4 | 9772.43 ± 0.5% | not timed | not timed | 6625.18 ± 0.7% | 1290.66 ± 3.1% | not timed | not timed | 9752.64 ± 1.3% | | 1.00 | 1.48 | 7.57 |
| imported/rsc/one-pass-short | 17 | 371.75 ± 11.5% | not timed | not timed | 200.34 ± 0.6% | 28.15 ± 32.9% | not timed | not timed | 375.02 ± 1.5% | | 0.99 | 1.86 | 13.20 |
| imported/rsc/one-pass-short-not | 17 | 254.59 ± 2.7% | not timed | not timed | 209.49 ± 1.1% | 26.43 ± 13.0% | not timed | not timed | 256.52 ± 0.6% | | 0.99 | 1.22 | 9.63 |
| imported/rsc/one-pass-long-prefix | 26 | 341.06 ± 6.3% | not timed | not timed | 249.43 ± 1.7% | 101.89 ± 31.0% | not timed | not timed | 343.93 ± 11.1% | | 0.99 | 1.37 | 3.35 |
| imported/rsc/one-pass-long-prefix-not | 26 | 293.17 ± 1.3% | not timed | not timed | 230.64 ± 1.2% | 63.43 ± 15.5% | not timed | not timed | 311.55 ± 5.2% | | 0.94 | 1.27 | 4.62 |
| imported/rsc/long-needle1 | 31 | 52834.86 ± 0.4% | not timed | not timed | 35590.15 ± 12.5% | 3.26 ± 2.0% | not timed | not timed | 52858.36 ± 0.4% | | 1.00 | 1.48 | 16199.96 |
| imported/rsc/long-needle2 | 31 | 52477.93 ± 0.4% | not timed | not timed | 176.63 ± 0.5% | 3.26 ± 1.2% | not timed | not timed | 52509.00 ± 0.3% | | 1.00 | 297.11 | 16102.55 |
| imported/rsc/easy0-32 | 26 | 1555.79 ± 2.1% | not timed | not timed | 1503.36 ± 0.6% | 133.91 ± 17.4% | not timed | not timed | 1565.92 ± 1.4% | | 0.99 | 1.03 | 11.62 |
| imported/rsc/easy0-1k | 26 | 12903.25 ± 7.3% | not timed | not timed | 15801.07 ± 0.8% | 2046.30 ± 11.4% | not timed | not timed | 13081.23 ± 0.8% | | 0.99 | 0.82 | 6.31 |
| imported/rsc/easy0-32k | 26 | 49332.31 ± 0.9% | not timed | not timed | 34012.30 ± 0.5% | 19760.65 ± 1.4% | not timed | not timed | 49074.00 ± 0.6% | | 1.01 | 1.45 | 2.50 |
| imported/rsc/easy0-1mb | 26 | 52699.74 ± 1.2% | not timed | not timed | 35674.76 ± 1.7% | 52738.30 ± 1.1% | not timed | not timed | 52745.41 ± 0.6% | | 1.00 | 1.48 | 1.00 |
| imported/rsc/easy1-32 | 19 | 713.58 ± 1.7% | not timed | not timed | 593.56 ± 0.9% | 121.06 ± 19.6% | not timed | not timed | 721.30 ± 2.5% | | 0.99 | 1.20 | 5.89 |
| imported/rsc/easy1-1k | 19 | 14622.43 ± 2.9% | not timed | not timed | 11686.69 ± 1.4% | 1997.19 ± 21.1% | not timed | not timed | 14907.15 ± 0.6% | | 0.98 | 1.25 | 7.32 |
| imported/rsc/easy1-32k | 19 | 460624.59 ± 0.9% | not timed | not timed | 381212.69 ± 0.4% | 22439.19 ± 9.7% | not timed | not timed | 464980.69 ± 3.4% | | 0.99 | 1.21 | 20.53 |
| imported/rsc/easy1-1mb | 19 | 14656328.33 ± 15.7% | not timed | not timed | 12088858.04 ± 0.3% | 53024.76 ± 0.4% | not timed | not timed | 14958874.13 ± 0.3% | | 0.98 | 1.21 | 276.41 |
| imported/rsc/medium-32 | 27 | 670.64 ± 17.3% | not timed | not timed | 576.44 ± 0.4% | 62.99 ± 11.7% | not timed | not timed | 679.69 ± 1.8% | | 0.99 | 1.16 | 10.65 |
| imported/rsc/medium-1k | 27 | 12023.58 ± 0.5% | not timed | not timed | 10273.85 ± 0.5% | 63.99 ± 0.6% | not timed | not timed | 12075.73 ± 0.7% | | 1.00 | 1.17 | 187.90 |
| imported/rsc/medium-32k | 27 | 375138.73 ± 0.4% | not timed | not timed | 319550.73 ± 0.5% | 41.28 ± 0.9% | not timed | not timed | 375531.45 ± 0.8% | | 1.00 | 1.17 | 9087.12 |
| imported/rsc/medium-1mb | 27 | 11984375.66 ± 12.2% | not timed | not timed | 10233837.82 ± 0.6% | 41.93 ± 2.1% | not timed | not timed | 12011444.70 ± 0.8% | | 1.00 | 1.17 | 285834.24 |
| imported/rsc/hard-32 | 58 | 349.72 ± 0.4% | not timed | not timed | 301.87 ± 1.3% | 41.01 ± 21.2% | not timed | not timed | 348.80 ± 2.2% | | 1.00 | 1.16 | 8.53 |
| imported/rsc/hard-1k | 27 | 11534.46 ± 0.5% | not timed | not timed | 9926.94 ± 0.4% | 34.62 ± 0.6% | not timed | not timed | 11531.86 ± 0.4% | | 1.00 | 1.16 | 333.22 |
| imported/rsc/hard-32k | 27 | 360360.64 ± 0.3% | not timed | not timed | 315725.23 ± 7.9% | 25.65 ± 26.6% | not timed | not timed | 360243.65 ± 0.4% | | 1.00 | 1.14 | 14048.03 |
| imported/rsc/hard-1mb | 51 | 6968059.49 ± 2.5% | not timed | not timed | 6014123.82 ± 1.3% | 25.72 ± 0.3% | not timed | not timed | 6961507.16 ± 2.3% | | 1.00 | 1.16 | 270904.23 |
| imported/rsc/reallyhard0-32 | 58 | 218.06 ± 0.3% | not timed | not timed | 190.79 ± 0.7% | 41.05 ± 7.6% | not timed | not timed | 217.12 ± 1.9% | | 1.00 | 1.14 | 5.31 |
| imported/rsc/reallyhard0-1k | 27 | 458.19 ± 1.3% | not timed | not timed | 448.60 ± 2.9% | 34.64 ± 8.1% | not timed | not timed | 459.64 ± 3.1% | | 1.00 | 1.02 | 13.23 |
| imported/rsc/reallyhard0-32k | 27 | 472.34 ± 0.1% | not timed | not timed | 468.25 ± 0.6% | 25.47 ± 0.8% | not timed | not timed | 472.42 ± 0.2% | | 1.00 | 1.01 | 18.55 |
| imported/rsc/reallyhard0-1mb | 51 | 472.86 ± 0.5% | not timed | not timed | 467.61 ± 0.9% | 25.34 ± 18.1% | not timed | not timed | 473.24 ± 0.3% | | 1.00 | 1.01 | 18.66 |
| imported/rsc/reallyreallyhard0-32 | 47 | 257.51 ± 1.7% | not timed | not timed | 162.29 ± 12.7% | 51.25 ± 10.1% | not timed | not timed | 256.86 ± 1.6% | | 1.00 | 1.59 | 5.02 |
| imported/rsc/reallyreallyhard0-1k | 16 | 5916.75 ± 0.5% | not timed | not timed | 6009.22 ± 0.6% | 28.59 ± 6.5% | not timed | not timed | 5890.87 ± 0.6% | | 1.00 | 0.98 | 206.99 |
| imported/rsc/reallyreallyhard0-32k | 16 | 40281.50 ± 0.1% | not timed | not timed | 28359.87 ± 0.3% | 20.78 ± 0.4% | not timed | not timed | 40151.75 ± 22.0% | | 1.00 | 1.42 | 1938.74 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 54637.67 ± 0.9% | not timed | not timed | 35349.35 ± 1.9% | 20.89 ± 0.5% | not timed | not timed | 54437.56 ± 0.4% | | 1.00 | 1.55 | 2615.84 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 243.34 ± 3.2% | not timed | not timed | 167.06 ± 0.2% | 51.34 ± 0.8% | not timed | not timed | 245.39 ± 10.2% | | 0.99 | 1.46 | 4.74 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 4944.12 ± 0.5% | not timed | not timed | 5807.92 ± 0.1% | 28.66 ± 0.6% | not timed | not timed | 4948.06 ± 9.4% | | 1.00 | 0.85 | 172.50 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 37764.10 ± 0.3% | not timed | not timed | 28691.08 ± 1.4% | 21.00 ± 0.8% | not timed | not timed | 37887.97 ± 0.5% | | 1.00 | 1.32 | 1798.35 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 50057.04 ± 0.9% | not timed | not timed | 35113.25 ± 0.4% | 20.87 ± 0.5% | not timed | not timed | 50249.96 ± 0.5% | | 1.00 | 1.43 | 2398.22 |
| imported/sherlock/name-sherlock | 776 | 36429.31 ± 1.9% | not timed | not timed | 31299.68 ± 2.0% | 10911.46 ± 28.1% | not timed | not timed | 36411.10 ± 2.1% | | 1.00 | 1.16 | 3.34 |
| imported/sherlock/name-holmes | 2766 | 17884.26 ± 7.3% | not timed | not timed | 23423.19 ± 1.1% | 3184.98 ± 28.5% | not timed | not timed | 18217.58 ± 7.3% | | 0.98 | 0.76 | 5.62 |
| imported/sherlock/name-sherlock-holmes | 1365 | 36645.89 ± 1.7% | not timed | not timed | 31441.79 ± 0.3% | 8237.69 ± 18.2% | not timed | not timed | 36618.53 ± 0.3% | | 1.00 | 1.17 | 4.45 |
| imported/sherlock/name-sherlock-casei | 816 | 33999.93 ± 0.5% | not timed | not timed | 9158.74 ± 2.9% | 26.03 ± 1.3% | not timed | not timed | 34024.33 ± 0.5% | | 1.00 | 3.71 | 1306.01 |
| imported/sherlock/name-holmes-casei | 2802 | 15180.07 ± 0.8% | not timed | not timed | 6003.66 ± 0.6% | 33.44 ± 0.2% | not timed | not timed | 15200.54 ± 0.4% | | 1.00 | 2.53 | 453.96 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 26873.09 ± 1.7% | not timed | not timed | 8854.19 ± 0.3% | 26.34 ± 1.4% | not timed | not timed | 26895.40 ± 1.4% | | 1.00 | 3.04 | 1020.19 |
| imported/sherlock/name-whitespace | 1461 | 21349.07 ± 10.4% | not timed | not timed | 21673.69 ± 0.4% | 6827.14 ± 17.0% | not timed | not timed | 21487.42 ± 6.9% | | 0.99 | 0.99 | 3.13 |
| imported/sherlock/name-alt1 | 1142 | 22438.68 ± 0.7% | not timed | not timed | 22802.08 ± 3.7% | 4402.72 ± 24.0% | not timed | not timed | 22505.09 ± 2.7% | | 1.00 | 0.98 | 5.10 |
| imported/sherlock/name-alt2 | 3542 | 13863.02 ± 2.5% | not timed | not timed | 7989.79 ± 0.8% | 27.83 ± 0.3% | not timed | not timed | 13890.67 ± 1.1% | | 1.00 | 1.74 | 498.16 |
| imported/sherlock/name-alt3 | 4507 | 9287.43 ± 0.5% | not timed | not timed | 7297.06 ± 0.4% | 8.75 ± 0.5% | not timed | not timed | 9252.09 ± 1.7% | | 1.00 | 1.27 | 1061.78 |
| imported/sherlock/name-alt3-casei | 4593 | 2693.69 ± 5.0% | not timed | not timed | 1009.21 ± 0.3% | 5.83 ± 2.0% | not timed | not timed | 2701.03 ± 5.9% | | 1.00 | 2.67 | 461.80 |
| imported/sherlock/name-alt4 | 3686 | 7710.68 ± 0.4% | not timed | not timed | 6391.29 ± 0.9% | 27.64 ± 1.6% | not timed | not timed | 7630.27 ± 0.4% | | 1.01 | 1.21 | 278.96 |
| imported/sherlock/name-alt4-casei | 4254 | 4162.20 ± 1.2% | not timed | not timed | 3456.01 ± 0.8% | 16.25 ± 1.8% | not timed | not timed | 4234.77 ± 1.3% | | 0.98 | 1.20 | 256.17 |
| imported/sherlock/name-alt5 | 4028 | 11577.33 ± 2.1% | not timed | not timed | 7674.80 ± 0.4% | 19.40 ± 1.3% | not timed | not timed | 11610.92 ± 0.3% | | 1.00 | 1.51 | 596.80 |
| imported/sherlock/name-alt5-casei | 4104 | 5449.10 ± 2.3% | not timed | not timed | 2313.45 ± 1.3% | 12.08 ± 0.9% | not timed | not timed | 5434.29 ± 1.8% | | 1.00 | 2.36 | 451.15 |
| imported/sherlock/no-match-uncommon | 0 | 51343.28 ± 1.6% | not timed | not timed | 44811.23 ± 0.6% | 44430.40 ± 0.7% | not timed | not timed | 51313.06 ± 0.4% | | 1.00 | 1.15 | 1.16 |
| imported/sherlock/no-match-common | 0 | 50183.00 ± 0.2% | not timed | not timed | 44891.73 ± 0.6% | 1661.50 ± 0.6% | not timed | not timed | 50161.33 ± 1.0% | | 1.00 | 1.12 | 30.20 |
| imported/sherlock/no-match-really-common | 0 | 32586.08 ± 0.7% | not timed | not timed | 38596.98 ± 1.5% | 1661.79 ± 0.7% | not timed | not timed | 32584.01 ± 0.7% | | 1.00 | 0.84 | 19.61 |
| imported/sherlock/the-lower | 21654 | 2609.35 ± 0.7% | not timed | not timed | 3569.58 ± 1.2% | 218.45 ± 32.8% | not timed | not timed | 2618.00 ± 2.9% | | 1.00 | 0.73 | 11.94 |
| imported/sherlock/the-upper | 2223 | 13178.05 ± 0.9% | not timed | not timed | 22697.46 ± 0.5% | 2652.18 ± 16.6% | not timed | not timed | 13178.15 ± 0.9% | | 1.00 | 0.58 | 4.97 |
| imported/sherlock/the-casei | 23961 | 2348.77 ± 24.3% | not timed | not timed | 1059.51 ± 13.6% | 32.48 ± 1.5% | not timed | not timed | 2350.20 ± 1.1% | | 1.00 | 2.22 | 72.32 |
| imported/sherlock/everything-greedy | 581881 | 227.22 ± 3.1% | not timed | not timed | 131.81 ± 0.2% | 23.87 ± 29.4% | not timed | not timed | 226.11 ± 0.5% | | 1.00 | 1.72 | 9.52 |
| imported/sherlock/everything-greedy-nl | 594933 | 395.97 ± 0.1% | not timed | not timed | 174.45 ± 1.7% | 26.88 ± 0.4% | not timed | not timed | 396.16 ± 0.3% | | 1.00 | 2.27 | 14.73 |
| imported/sherlock/letters | 447175 | 52.90 ± 8.8% | not timed | not timed | 26.39 ± 1.6% | 4.88 ± 13.3% | not timed | not timed | 52.56 ± 25.1% | | 1.01 | 2.00 | 10.84 |
| imported/sherlock/letters-upper | 14180 | 350.35 ± 2.2% | not timed | not timed | 287.52 ± 0.2% | 23.83 ± 20.5% | not timed | not timed | 352.74 ± 0.4% | | 0.99 | 1.22 | 14.70 |
| imported/sherlock/letters-lower | 432995 | 51.43 ± 3.9% | not timed | not timed | 26.91 ± 21.8% | 5.00 ± 34.8% | not timed | not timed | 54.26 ± 1.5% | | 0.95 | 1.91 | 10.28 |
| imported/sherlock/words | 447639 | 94.42 ± 14.2% | not timed | not timed | 63.66 ± 16.9% | 10.90 ± 29.6% | not timed | not timed | 95.96 ± 1.0% | | 0.98 | 1.48 | 8.66 |
| imported/sherlock/before-holmes | 4073 | 10623.94 ± 0.8% | not timed | not timed | 10285.19 ± 0.8% | 20.03 ± 0.3% | not timed | not timed | 10594.13 ± 0.8% | | 1.00 | 1.03 | 530.51 |
| imported/sherlock/before-after-holmes | 2593 | 10326.08 ± 1.2% | not timed | not timed | 11576.79 ± 5.4% | 20.06 ± 5.5% | not timed | not timed | 10405.71 ± 4.7% | | 0.99 | 0.89 | 514.75 |
| imported/sherlock/holmes-cochar-watson | 150 | 7904.93 ± 1.2% | not timed | not timed | 6004.07 ± 3.2% | 25.67 ± 0.6% | not timed | not timed | 7951.60 ± 17.2% | | 0.99 | 1.32 | 307.93 |
| imported/sherlock/holmes-coword-watson | 14309 | 987.13 ± 1.0% | not timed | not timed | 957.02 ± 0.5% | 5.88 ± 18.1% | not timed | not timed | 989.54 ± 0.4% | | 1.00 | 1.03 | 167.83 |
| imported/sherlock/quotes | 14437 | 1198.09 ± 0.3% | not timed | not timed | 1760.87 ± 2.7% | 28.25 ± 1.2% | not timed | not timed | 1198.34 ± 1.1% | | 1.00 | 0.68 | 42.42 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 26747.08 ± 0.4% | not timed | not timed | 24449.46 ± 0.3% | 31.25 ± 39.7% | not timed | not timed | 26755.83 ± 0.6% | | 1.00 | 1.09 | 855.89 |
| imported/sherlock/word-ending-n | 35297 | 366.57 ± 5.0% | not timed | not timed | 313.99 ± 0.2% | 20.22 ± 23.9% | not timed | not timed | 367.53 ± 4.7% | | 1.00 | 1.17 | 18.13 |
| imported/sherlock/repeated-class-negation | 2130 | 12684.04 ± 0.6% | not timed | not timed | 12864.46 ± 0.5% | 9.54 ± 0.9% | not timed | not timed | 12725.67 ± 0.7% | | 1.00 | 0.99 | 1329.31 |
| imported/sherlock/ing-suffix | 20547 | 444.77 ± 1.0% | not timed | not timed | 396.64 ± 0.2% | 24.06 ± 0.3% | not timed | not timed | 444.14 ± 3.6% | | 1.00 | 1.12 | 18.49 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1338.36 ± 2.1% | not timed | not timed | 2218.36 ± 13.7% | 17.55 ± 2.3% | not timed | not timed | 1345.72 ± 1.8% | | 0.99 | 0.60 | 76.24 |
| opt/accelerate/whole-line | 239963 | 389.80 ± 1.0% | not timed | not timed | 321.22 ± 0.4% | 69.71 ± 16.1% | not timed | not timed | 390.14 ± 0.7% | | 1.00 | 1.21 | 5.59 |
| opt/accelerate/non-dna | 16745 | 355.61 ± 11.1% | not timed | not timed | 339.60 ± 0.2% | 25.09 ± 53.3% | not timed | not timed | 357.54 ± 0.3% | | 0.99 | 1.05 | 14.18 |
| opt/backtrack/words-english | 40536 | 105.28 ± 1.1% | not timed | not timed | 85.62 ± 0.4% | 16.67 ± 7.0% | not timed | not timed | 105.09 ± 2.5% | | 1.00 | 1.23 | 6.31 |
| opt/fixed-length/too-small-ascii | 0 | 288.63 ± 41.7% | not timed | not timed | 549.78 ± 0.2% | 95.47 ± 1.9% | not timed | not timed | 288.66 ± 5.0% | | 1.00 | 0.52 | 3.02 |
| opt/fixed-length/too-big-ascii | 0 | 3351.68 ± 0.3% | not timed | not timed | 4897.16 ± 0.3% | 116.88 ± 1.0% | not timed | not timed | 3333.61 ± 1.9% | | 1.01 | 0.68 | 28.68 |
| opt/fixed-length/go33484-1 | 0 | 644041.42 ± 23.7% | not timed | not timed | 943563.84 ± 0.5% | 69402.16 ± 1.0% | not timed | not timed | 643937.04 ± 4.9% | | 1.00 | 0.68 | 9.28 |
| opt/fixed-length/go33484-2 | 0 | 642141.65 ± 0.7% | not timed | not timed | 942997.68 ± 0.8% | 23059.59 ± 2.4% | not timed | not timed | 643219.42 ± 1.1% | | 1.00 | 0.68 | 27.85 |
| opt/fixed-length/go33484-3 | 0 | 64367.63 ± 1.4% | not timed | not timed | 94323.28 ± 4.4% | 727.12 ± 51.2% | not timed | not timed | 64330.61 ± 0.7% | | 1.00 | 0.68 | 88.52 |
| opt/literal-alt/one-pattern | 1 | 449.86 ± 2.5% | not timed | not timed | 442.25 ± 0.4% | 0.30 ± 3.9% | not timed | not timed | 451.15 ± 1.8% | | 1.00 | 1.02 | 1510.92 |
| opt/onepass/fn-predicate | 916 | 336.69 ± 3.1% | not timed | not timed | 304.40 ± 1.3% | 173.17 ± 36.5% | not timed | not timed | 338.27 ± 2.1% | | 1.00 | 1.11 | 1.94 |
| opt/onepass/first-three-words-english | 35128 | 138.78 ± 9.6% | not timed | not timed | 180.18 ± 0.7% | 64.06 ± 20.6% | not timed | not timed | 138.51 ± 1.5% | | 1.00 | 0.77 | 2.17 |
| opt/prefilter/literal-english | 1 | 51797.15 ± 4.3% | not timed | not timed | 35904.21 ± 0.8% | 20266.95 ± 0.3% | not timed | not timed | 51806.24 ± 4.4% | | 1.00 | 1.44 | 2.56 |
| opt/prefilter/literal-casei-english | 1 | 37392.13 ± 0.3% | not timed | not timed | 11352.09 ± 0.3% | 23.86 ± 8.6% | not timed | not timed | 37381.22 ± 0.4% | | 1.00 | 3.29 | 1567.44 |
| opt/prefilter/literal-russian | 1 | 53684.78 ± 1.0% | not timed | not timed | 35997.43 ± 1.2% | 1391.06 ± 1.3% | not timed | not timed | 53521.02 ± 31.3% | | 1.00 | 1.49 | 38.59 |
| opt/prefilter/literal-casei-russian | 1 | 21259.47 ± 0.5% | not timed | not timed | 8704.53 ± 1.9% | 27.70 ± 17.9% | not timed | not timed | 21144.95 ± 0.4% | | 1.01 | 2.44 | 767.41 |
| opt/prefilter/rust-functions | 948 | 11426.43 ± 0.6% | not timed | not timed | 9849.29 ± 0.8% | 1287.27 ± 0.4% | not timed | not timed | 11520.76 ± 1.1% | | 0.99 | 1.16 | 8.88 |
| opt/reverse-anchored/word-end | 1 | 26398004.91 ± 0.2% | not timed | not timed | 21043921.22 ± 2.9% | 37.77 ± 0.8% | not timed | not timed | 27961498.10 ± 0.9% | | 0.94 | 1.25 | 698846.76 |
| opt/reverse-inner/holmes | 2593 | 10339.50 ± 1.2% | not timed | not timed | 11636.47 ± 0.3% | 15.62 ± 0.5% | not timed | not timed | 10394.66 ± 0.4% | | 0.99 | 0.89 | 661.76 |
| opt/reverse-inner/email | 47 | 64681.29 ± 0.7% | not timed | not timed | 71672.61 ± 0.3% | 21.77 ± 5.0% | not timed | not timed | 64889.42 ± 0.9% | | 1.00 | 0.90 | 2971.54 |
| opt/reverse-inner/factored-prefix | 3542 | 465.34 ± 0.8% | not timed | not timed | 454.59 ± 0.2% | 8.85 ± 2.6% | not timed | not timed | 465.63 ± 0.2% | | 1.00 | 1.02 | 52.61 |
| opt/reverse-inner/no-quadratic-backward | 0 | 18044.64 ± 24.9% | not timed | not timed | 468.64 ± 0.2% | 66.36 ± 13.0% | not timed | not timed | 18067.57 ± 0.4% | | 1.00 | 38.50 | 271.91 |
| opt/reverse-inner/no-quadratic-forward | 0 | 548.68 ± 10.4% | not timed | not timed | 216.51 ± 0.5% | 20.65 ± 0.4% | not timed | not timed | 549.42 ± 4.8% | | 1.00 | 2.53 | 26.56 |
| opt/reverse-suffix/holmes | 4073 | 10606.38 ± 11.0% | not timed | not timed | 10290.71 ± 0.3% | 15.61 ± 0.3% | not timed | not timed | 10591.25 ± 8.4% | | 1.00 | 1.03 | 679.59 |
| opt/reverse-suffix/no-quadratic | 0 | 18048.35 ± 0.3% | not timed | not timed | 468.11 ± 0.7% | 66.37 ± 1.6% | not timed | not timed | 18034.97 ± 72.7% | | 1.00 | 38.56 | 271.94 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 109.23 ± 8.0% | not timed | not timed | 133.85 ± 0.9% | 12.78 ± 14.8% | not timed | not timed | 109.32 ± 1.5% | | 1.00 | 0.82 | 8.55 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 110.60 ± 7.8% | not timed | not timed | 142.29 ± 0.5% | 14.04 ± 16.6% | not timed | not timed | 110.63 ± 0.7% | | 1.00 | 0.78 | 7.88 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.25 ± 0.6% | not timed | not timed | 0.37 ± 0.9% | 93.45 ± 1.2% | not timed | not timed | 0.24 ± 0.4% | | 1.02 | 0.66 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 233.92 ± 0.5% | not timed | not timed | 220.57 ± 1.1% | 84.72 ± 13.2% | not timed | not timed | 220.67 ± 2.5% | | 1.06 | 1.06 | 2.76 |
| reported/i13-subset-regex/original-ascii | 4094 | 8260.42 ± 0.3% | not timed | not timed | 2941.20 ± 0.7% | 9.40 ± 1.6% | not timed | not timed | 8277.83 ± 0.6% | | 1.00 | 2.81 | 878.41 |
| reported/i13-subset-regex/original-unicode | 4094 | 8224.92 ± 0.4% | not timed | not timed | 155.38 ± 3.1% | 9.37 ± 1.2% | not timed | not timed | 8243.44 ± 0.9% | | 1.00 | 52.94 | 878.19 |
| reported/i13-subset-regex/big-ascii | 1955 | 7765.11 ± 0.6% | not timed | not timed | 42.06 ± 5.2% | 8.01 ± 0.4% | not timed | not timed | 7793.83 ± 2.8% | | 1.00 | 184.62 | 969.31 |
| reported/i13-subset-regex/big-unicode | 1955 | 7696.47 ± 0.5% | not timed | not timed | 7.44 ± 55.2% | 8.08 ± 1.4% | not timed | not timed | 7782.19 ± 0.2% | | 0.99 | 1034.81 | 951.95 |
| reported/i13-subset-regex/huge-ascii | 55 | 7154.02 ± 0.6% | not timed | not timed | 6.79 ± 0.5% | 7.28 ± 1.5% | not timed | not timed | 7152.33 ± 0.3% | | 1.00 | 1052.97 | 982.07 |
| reported/i13-subset-regex/huge-unicode | 55 | 6990.79 ± 0.9% | not timed | not timed | 6.68 ± 1.0% | 7.31 ± 1.5% | not timed | not timed | 7005.08 ± 0.2% | | 1.00 | 1046.16 | 956.65 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.23 ± 0.6% | not timed | not timed | 6.98 ± 0.4% | 7.36 ± 0.8% | not timed | not timed | 3.25 ± 0.8% | | 1.00 | 0.46 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.51 ± 0.7% | not timed | not timed | 6.70 ± 0.8% | 7.34 ± 0.8% | not timed | not timed | 4.38 ± 1.4% | | 1.03 | 0.67 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 432.74 ± 1.3% | not timed | not timed | 132.10 ± 0.7% | 5.48 ± 2.2% | not timed | not timed | 432.85 ± 0.9% | | 1.00 | 3.28 | 79.00 |
| reported/i787-keywords/opt-ascii | 5674 | 431.85 ± 1.3% | not timed | not timed | 210.66 ± 10.4% | 9.19 ± 0.5% | not timed | not timed | 432.99 ± 0.4% | | 1.00 | 2.05 | 47.00 |
| slow/quadratic-regex-1x | 100 | 6.26 ± 1.0% | not timed | not timed | 4.67 ± 1.2% | 0.04 ± 0.2% | not timed | not timed | 6.42 ± 0.4% | | 0.98 | 1.34 | 157.22 |
| slow/quadratic-regex-2x | 199 | 2.84 ± 0.2% | not timed | not timed | 2.35 ± 0.4% | 0.01 ± 0.2% | not timed | not timed | 2.88 ± 0.4% | | 0.99 | 1.21 | 277.01 |
| slow/quadratic-haystack-1x | 100 | 22.05 ± 1.7% | not timed | not timed | 9.44 ± 0.6% | 0.80 ± 11.8% | not timed | not timed | 21.93 ± 1.3% | | 1.01 | 2.34 | 27.72 |
| slow/quadratic-haystack-2x | 200 | 19.84 ± 0.6% | not timed | not timed | 4.75 ± 0.3% | 0.43 ± 0.7% | not timed | not timed | 19.75 ± 0.6% | | 1.00 | 4.18 | 46.03 |
| unicode/codepoints/any-one | 1112064 | 261.87 ± 1.1% | not timed | not timed | 183.94 ± 3.2% | 15.89 ± 11.2% | not timed | not timed | 261.97 ± 1.6% | | 1.00 | 1.42 | 16.48 |
| unicode/codepoints/any-all | 4382592 | 212.02 ± 0.5% | not timed | not timed | 199.92 ± 2.1% | 97.54 ± 47.7% | not timed | not timed | 211.21 ± 0.5% | | 1.00 | 1.06 | 2.17 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 5.26 ± 0.9% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 473.21 ± 0.2% | not timed | not timed | 468.17 ± 0.2% | 118.90 ± 0.4% | not timed | not timed | 472.90 ± 0.4% | | 1.00 | 1.01 | 3.98 |
| unicode/overlapping-words/ascii | 6156 | 23.48 ± 2.7% | not timed | not timed | 33.04 ± 1.0% | 3.38 ± 2.1% | not timed | not timed | 23.50 ± 2.8% | | 1.00 | 0.71 | 6.95 |
| unicode/overlapping-words/english | 6156 | 1.15 ± 0.9% | not timed | not timed | 2.31 ± 0.1% | 2.28 ± 0.3% | not timed | not timed | 1.10 ± 0.4% | | 1.05 | 0.50 | 0.50 |
| unicode/overlapping-words/russian | 5710 | 1.03 ± 0.1% | not timed | not timed | 2.28 ± 1.0% | 5.31 ± 3.1% | not timed | not timed | 0.98 ± 0.6% | | 1.05 | 0.45 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 104.95 ± 4.7% | not timed | not timed | 61.82 ± 0.3% | 10.29 ± 23.9% | not timed | not timed | 105.17 ± 1.9% | | 1.00 | 1.70 | 10.20 |
| unicode/word/boundary-long-english | 3466 | 473.95 ± 0.4% | not timed | not timed | 460.38 ± 0.2% | 27.44 ± 0.7% | not timed | not timed | 475.04 ± 1.3% | | 1.00 | 1.03 | 17.28 |
| unicode/word/around-holmes-english | 27 | 48492.76 ± 1.0% | not timed | not timed | 34764.14 ± 48.7% | 18.48 ± 5.5% | not timed | not timed | 48486.81 ± 0.9% | | 1.00 | 1.39 | 2624.06 |
| wild/bibleref/long | 874 | 439.59 ± 0.2% | not timed | not timed | 445.33 ± 0.9% | 6.13 ± 0.5% | not timed | not timed | 438.92 ± 0.7% | | 1.00 | 0.99 | 71.70 |
| wild/bibleref/short | 30 | 17.11 ± 8.8% | not timed | not timed | 23.75 ± 0.3% | 12.87 ± 18.5% | not timed | not timed | 16.93 ± 1.3% | | 1.01 | 0.72 | 1.33 |
| wild/bibleref/line | 874 | 393.89 ± 0.9% | not timed | not timed | 209.26 ± 2.3% | 7.73 ± 0.2% | not timed | not timed | 393.81 ± 0.8% | | 1.00 | 1.88 | 50.97 |
| wild/caddy/caddy | 6 | 353.77 ± 24.7% | not timed | not timed | 226.53 ± 14.8% | 61.15 ± 13.9% | not timed | not timed | 346.27 ± 10.4% | | 1.02 | 1.56 | 5.79 |
| wild/dot-star-capture/rust-src-tools | 6 | 1124.67 ± 0.6% | not timed | not timed | 313.26 ± 10.5% | 12.32 ± 2.6% | not timed | not timed | 1127.21 ± 0.5% | | 1.00 | 3.59 | 91.32 |
| wild/ruff/noqa | 84 | 393.48 ± 9.6% | not timed | not timed | 392.09 ± 0.6% | 15.87 ± 1.8% | not timed | not timed | 392.69 ± 0.2% | | 1.00 | 1.00 | 24.80 |
| wild/ruff/unnecessary-coding-comment | 16 | 829.73 ± 11.0% | not timed | not timed | 559.56 ± 0.2% | 109.01 ± 13.8% | not timed | not timed | 828.07 ± 0.4% | | 1.00 | 1.48 | 7.61 |
| wild/ruff/string-quote-prefix | 2972 | 1217.47 ± 12.6% | not timed | not timed | 356.97 ± 0.6% | 251.20 ± 37.3% | not timed | not timed | 1224.38 ± 0.5% | | 0.99 | 3.41 | 4.85 |
| wild/ruff/space-around-operator | 1224378 | 182.48 ± 1.5% | not timed | not timed | 175.17 ± 0.3% | 14.91 ± 1.9% | not timed | not timed | 180.90 ± 1.8% | | 1.01 | 1.04 | 12.24 |
| wild/ruff/shebang | 282 | 855.31 ± 0.8% | not timed | not timed | 301.16 ± 0.1% | 89.05 ± 12.9% | not timed | not timed | 852.43 ± 0.5% | | 1.00 | 2.84 | 9.60 |
| wild/rustsec-cargo-audit/original-unix | 471 | 17428.89 ± 1.7% | not timed | not timed | 18188.76 ± 1.6% | 6939.02 ± 3.1% | not timed | not timed | 17490.86 ± 1.1% | | 1.00 | 0.96 | 2.51 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15854.15 ± 1.5% | not timed | not timed | 17171.18 ± 20.6% | 6477.15 ± 1.0% | not timed | not timed | 15910.95 ± 13.6% | | 1.00 | 0.92 | 2.45 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 17726.19 ± 3.0% | not timed | not timed | 17997.83 ± 18.6% | 6562.22 ± 0.8% | not timed | not timed | 17636.48 ± 1.4% | | 1.01 | 0.98 | 2.70 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 14118.40 ± 1.4% | not timed | not timed | 17953.75 ± 0.3% | 6528.30 ± 1.8% | not timed | not timed | 14183.29 ± 11.8% | | 1.00 | 0.79 | 2.16 |
| wild/url/search | 234965 | 96.43 ± 15.3% | not timed | not timed | 47.81 ± 2.9% | 1.89 ± 2.2% | not timed | not timed | 100.87 ± 15.7% | | 0.96 | 2.02 | 51.12 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 1.9% | not timed | not timed | 0.01 ± 3.7% | 0.01 ± 19.9% | not timed | not timed | 0.02 ± 2.4% | | 0.99 | 2.45 | 4.18 |
| dictionary/compile/english-15 | 1 | 0.26 ± 30.8% | not timed | not timed | 0.07 ± 8.7% | 0.09 ± 10.2% | not timed | not timed | 0.26 ± 4.2% | | 1.00 | 3.58 | 2.86 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.23 ± 18.7% | not timed | not timed | 0.02 ± 6.5% | 30.02 ± 9.4% | not timed | not timed | 0.23 ± 17.7% | | 1.01 | 11.84 | 0.0077 |
| reported/i1095-word-repetition/ascii-compile | 1 | 33.77 ± 5.7% | not timed | not timed | 13.03 ± 0.5% | 46.95 ± 33.9% | not timed | not timed | 33.52 ± 10.2% | | 1.01 | 2.59 | 0.72 |
| reported/i787-keywords/compile | 1 | 31.21 ± 19.8% | not timed | not timed | 1.84 ± 18.3% | 15.89 ± 23.6% | not timed | not timed | 29.89 ± 16.8% | | 1.04 | 16.99 | 1.96 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 272.04 ± 10.6% | not timed | not timed | 121.15 ± 0.4% | 513.09 ± 31.9% | not timed | not timed | 277.67 ± 4.1% | | 0.98 | 2.25 | 0.53 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 40.76 ± 4.2% | not timed | not timed | 4.32 ± 0.8% | 38.72 ± 24.7% | not timed | not timed | 40.16 ± 14.1% | | 1.01 | 9.44 | 1.05 |
| unicode/compile/one-letter | 53 | 5.38 ± 15.5% | not timed | not timed | 4.50 ± 2.9% | 53.17 ± 9.6% | not timed | not timed | 5.44 ± 19.3% | | 0.99 | 1.20 | 0.10 |
| unicode/compile/fifty-letters | 1 | 0.97 ± 4.3% | not timed | not timed | 0.10 ± 3.9% | 55.13 ± 22.2% | not timed | not timed | 0.96 ± 4.0% | | 1.00 | 9.78 | 0.0175 |
| unicode/compile/fifty-letters-ascii | 1 | 153.85 ± 19.8% | not timed | not timed | 54.93 ± 0.8% | 184.29 ± 35.0% | not timed | not timed | 153.54 ± 4.4% | | 1.00 | 2.80 | 0.83 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 330.50 ± 10.4% | not timed | not timed | 39.75 ± 0.3% | 583.87 ± 23.2% | not timed | not timed | 334.13 ± 19.0% | | 0.99 | 8.31 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 515.60 ± 2.5% | not timed | not timed | 130.51 ± 0.8% | 581.77 ± 11.8% | not timed | not timed | 519.85 ± 4.4% | | 0.99 | 3.95 | 0.89 |
| unicode/compile/negated-class-matches-codepoint | 1 | 251.71 ± 8.3% | not timed | not timed | 43.05 ± 0.1% | 1098.52 ± 20.5% | not timed | not timed | 265.61 ± 12.3% | | 0.95 | 5.85 | 0.23 |
| wild/bibleref/compile | 3 | 4.38 ± 26.8% | not timed | not timed | 1.89 ± 0.9% | 28.97 ± 4.9% | not timed | not timed | 4.44 ± 14.7% | | 0.99 | 2.31 | 0.15 |
| wild/url/compile | 1 | 0.55 ± 11.8% | not timed | not timed | 0.16 ± 40.8% | 0.38 ± 14.3% | not timed | not timed | 0.55 ± 11.1% | | 1.00 | 3.47 | 1.46 |

