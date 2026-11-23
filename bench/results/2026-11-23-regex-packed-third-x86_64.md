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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45102059804 |
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
| literal: a word | 217 | 31779.32 ± 4.5% | 893.98 ± 1.8% | 20.18 ± 3.1% | 31106.81 ± 3.1% | 8946.78 ± 11.2% | 10.72 ± 1.2% | 76.33 ± 1.1% | 31347.53 ± 3.2% | 35.55 | 1.01 | 1.02 | 3.55 |
| literal: a word that is not there | 0 | 43593.77 ± 0.8% | 906.03 ± 0.1% | 20.37 ± 3.4% | 39477.32 ± 0.7% | 30302.89 ± 0.7% | 10.68 ± 0.1% | 72.21 ± 13.7% | 42704.16 ± 2.3% | 48.12 | 1.02 | 1.10 | 1.44 |
| literal: one of four words | 661 | 11332.66 ± 8.2% | 869.61 ± 0.1% | 11.24 ± 1.9% | 9108.91 ± 0.2% | 19.08 ± 0.8% | 3.96 ± 0.2% | 6.68 ± 0.5% | 11325.37 ± 0.6% | 13.03 | 1.00 | 1.24 | 594.01 |
| literal: a word in any case | 217 | 25467.48 ± 1.3% | 893.56 ± 1.0% | 15.44 ± 1.8% | 9260.55 ± 0.5% | 37.15 ± 0.3% | refused | differs | 25338.52 ± 4.1% | 28.50 | 1.01 | 2.75 | 685.58 |
| literal: an href attribute | 33 | 26217.90 ± 3.4% | 902.00 ± 0.0% | 18.27 ± 4.4% | 27101.88 ± 1.5% | 2049.57 ± 1.2% | 8.25 ± 0.1% | 61.37 ± 1.6% | 25995.74 ± 2.5% | 29.07 | 1.01 | 0.97 | 12.79 |
| literal: a word, second text | 123 | 32099.66 ± 0.4% | 898.48 ± 0.2% | 20.22 ± 0.7% | 32006.09 ± 0.6% | 7264.70 ± 5.6% | 11.66 ± 0.5% | 65.43 ± 2.1% | 32021.11 ± 0.7% | 35.73 | 1.00 | 1.00 | 4.42 |
| class: two capitalized words | 1331 | 765.69 ± 0.6% | 814.46 ± 0.2% | 18.81 ± 5.7% | 505.96 ± 0.1% | 34.35 ± 13.3% | 9.35 ± 0.2% | 55.69 ± 1.0% | 765.09 ± 1.0% | 0.94 | 1.00 | 1.51 | 22.29 |
| class: a word that ends in ing | 3399 | 733.64 ± 0.2% | 733.56 ± 0.6% | 13.20 ± 1.8% | 472.49 ± 0.2% | 25.65 ± 2.5% | 5.31 ± 0.2% | 17.20 ± 0.7% | 732.73 ± 0.1% | 1.00 | 1.00 | 1.55 | 28.60 |
| class: a word in capitals | 2332 | 983.41 ± 0.3% | 796.15 ± 0.2% | 19.87 ± 3.1% | 495.76 ± 0.5% | 36.71 ± 14.3% | 10.43 ± 0.1% | 76.38 ± 0.4% | 981.20 ± 0.3% | 1.24 | 1.00 | 1.98 | 26.79 |
| class: a number | 8288 | 1453.60 ± 0.2% | 648.31 ± 0.2% | 19.76 ± 2.9% | 1404.87 ± 0.4% | 36.25 ± 11.5% | 0.33 ± 0.3% | 55.74 ± 0.5% | 1458.74 ± 0.3% | 2.24 | 1.00 | 1.03 | 40.10 |
| class: two capitalized words, second text | 5359 | 577.69 ± 1.3% | 578.21 ± 1.5% | 17.57 ± 3.5% | 417.66 ± 2.5% | 29.65 ± 7.0% | 10.62 ± 0.6% | 51.66 ± 1.2% | 577.21 ± 1.7% | 1.00 | 1.00 | 1.38 | 19.48 |
| other: a word between two words | 6104 | 650.30 ± 0.2% | 617.66 ± 0.2% | 17.46 ± 3.8% | 695.32 ± 0.3% | 101.64 ± 9.8% | 7.22 ± 0.4% | 56.72 ± 1.3% | 653.22 ± 0.1% | 1.05 | 1.00 | 0.94 | 6.40 |
| other: a number before a unit, second text | 1481 | 6758.89 ± 2.9% | 826.44 ± 0.5% | 19.09 ± 1.9% | 6455.04 ± 0.5% | 35.18 ± 1.1% | 11.03 ± 0.1% | 55.09 ± 0.4% | 6761.52 ± 3.4% | 8.18 | 1.00 | 1.05 | 192.10 |
| other: a heading's start tag | 110 | 18687.04 ± 0.6% | 893.38 ± 0.3% | 19.81 ± 1.5% | 2008.63 ± 8.0% | 1472.88 ± 16.1% | 10.02 ± 0.4% | 72.67 ± 0.6% | 18696.50 ± 1.2% | 20.92 | 1.00 | 9.30 | 12.69 |
| other: a whole word | 217 | 22203.75 ± 2.1% | 893.66 ± 0.3% | 20.01 ± 2.9% | 22667.51 ± 0.7% | 41.29 ± 1.0% | 9.60 ± 0.3% | 47.05 ± 0.6% | 22117.46 ± 0.7% | 24.85 | 1.00 | 0.98 | 537.74 |
| other: a line's first word, second text | 3716 | 1758.13 ± 4.4% | 717.48 ± 0.1% | 22.31 ± 2.4% | 1700.93 ± 2.3% | 53.49 ± 7.1% | refused | refused | 1756.68 ± 0.7% | 2.45 | 1.00 | 1.03 | 32.87 |
| other: fourteen octets before an x | 87 | 25310.66 ± 1.4% | 196.95 ± 0.5% | 4.16 ± 1.9% | 2904.96 ± 1.6% | 8.98 ± 0.3% | differs | 15.46 ± 8.9% | 25315.58 ± 0.6% | 128.51 | 1.00 | 8.71 | 2817.71 |
| other: a Greek word | 21815 | 382.87 ± 0.4% | 264.89 ± 6.2% | 23.73 ± 1.8% | 264.10 ± 2.6% | 44.11 ± 13.5% | differs | refused | 384.71 ± 0.4% | 1.45 | 1.00 | 1.45 | 8.68 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 25.27 ± 0.9% | 25.28 ± 6.7% | 0.73 ± 0.3% | 16.78 ± 0.4% | 1.72 ± 0.2% | differs | 3.63 ± 13.0% | 25.30 ± 6.4% | 1.00 | 1.00 | 1.51 | 14.71 |
| a UUID | 32895 | 20.72 ± 10.2% | 19.46 ± 0.1% | 0.57 ± 6.7% | 12.82 ± 7.0% | 2.44 ± 17.2% | 0.43 ± 1.2% | 3.09 ± 1.6% | 20.72 ± 0.1% | 1.06 | 1.00 | 1.62 | 8.48 |
| an IPv4 address | 33176 | 35.69 ± 0.4% | 35.67 ± 0.6% | 1.84 ± 0.8% | 23.90 ± 0.5% | 5.32 ± 7.2% | differs | 3.35 ± 1.4% | 35.71 ± 5.7% | 1.00 | 1.00 | 1.49 | 6.71 |
| a date and time | 32954 | 31.06 ± 0.2% | 30.94 ± 0.3% | 1.29 ± 0.2% | 18.01 ± 0.3% | 6.67 ± 1.5% | 0.76 ± 1.0% | 6.20 ± 10.3% | 30.98 ± 8.8% | 1.00 | 1.00 | 1.72 | 4.66 |
| a field path | 32606 | 28.38 ± 8.0% | 28.36 ± 0.2% | 0.85 ± 0.8% | 19.16 ± 0.2% | 2.91 ± 1.3% | differs | 2.47 ± 0.8% | 28.39 ± 0.4% | 1.00 | 1.00 | 1.48 | 9.76 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 7.70 ± 1.1% | 7.69 ± 12.2% | 7.70 ± 4.1% | 10.60 ± 0.4% | 4.74 ± 8.9% | 0.62 ± 0.7% | none | 7.71 ± 0.5% | 1.00 | 1.00 | 0.73 | 1.62 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 194.09 ± 6.2% | 195.49 ± 0.3% | 229.73 ± 0.7% | 79.96 ± 3.8% | 184.49 ± 3.0% | 535.08 ± 3.0% | 3977.26 ± 14.0% | 194.08 ± 0.3% | 0.99 | 1.00 | 2.43 | 1.05 |
| a UUID | 62 | 125.56 ± 3.2% | 126.14 ± 0.8% | 140.82 ± 1.2% | 46.38 ± 1.1% | 90.40 ± 1.0% | 198.47 ± 4.6% | 4141.12 ± 0.5% | 125.50 ± 0.4% | 1.00 | 1.00 | 2.71 | 1.39 |
| an IPv4 address | 29 | 380.28 ± 11.0% | 386.23 ± 3.5% | 556.15 ± 0.9% | 68.68 ± 1.4% | 113.88 ± 2.0% | 328.42 ± 1.9% | 7182.69 ± 13.5% | 384.64 ± 1.4% | 0.98 | 0.99 | 5.54 | 3.34 |
| a date and time | 56 | 280.00 ± 0.2% | 282.44 ± 0.6% | 360.86 ± 15.4% | 67.88 ± 12.6% | 123.01 ± 13.7% | 377.82 ± 1.3% | 4234.14 ± 0.7% | 279.58 ± 0.3% | 0.99 | 1.00 | 4.12 | 2.28 |
| a field path | 39 | 189.29 ± 6.7% | 190.77 ± 2.3% | 224.27 ± 2.3% | 73.18 ± 3.1% | 171.46 ± 11.8% | 594.72 ± 4.1% | 4757.88 ± 15.6% | 189.28 ± 2.1% | 0.99 | 1.00 | 2.59 | 1.10 |
| literal: a word | 7 | 569.50 ± 2.4% | 605.96 ± 0.9% | 1122.93 ± 0.9% | 497.88 ± 0.1% | 576.54 ± 1.9% | 1243.39 ± 1.4% | 24763.38 ± 0.8% | 569.61 ± 0.4% | 0.94 | 1.00 | 1.14 | 0.99 |
| literal: a word that is not there | 8 | 547.73 ± 0.2% | 590.40 ± 0.6% | 1062.79 ± 0.3% | 461.03 ± 0.8% | 551.03 ± 1.4% | 1172.00 ± 11.1% | 23591.34 ± 1.9% | 549.58 ± 0.7% | 0.93 | 1.00 | 1.19 | 0.99 |
| literal: one of four words | 26 | 209.92 ± 0.5% | 361.07 ± 0.3% | 497.24 ± 0.4% | 41.65 ± 0.7% | 218.04 ± 3.0% | 455.70 ± 0.7% | 11539.75 ± 1.6% | 210.23 ± 0.4% | 0.58 | 1.00 | 5.04 | 0.96 |
| literal: a word in any case | 11 | 445.27 ± 17.4% | 474.37 ± 0.3% | 745.90 ± 0.6% | 14.44 ± 0.3% | 606.48 ± 1.5% | refused | 19590.06 ± 1.6% | 443.37 ± 6.8% | 0.94 | 1.00 | 30.84 | 0.73 |
| literal: an href attribute | 12 | 319.63 ± 0.5% | 331.10 ± 0.3% | 446.68 ± 1.9% | 37.08 ± 13.8% | 427.23 ± 1.2% | 948.57 ± 2.4% | 18944.65 ± 0.5% | 317.98 ± 1.0% | 0.97 | 1.01 | 8.62 | 0.75 |
| literal: a word, second text | 10 | 512.29 ± 5.5% | 556.17 ± 1.3% | 957.17 ± 0.5% | 418.07 ± 1.4% | 479.67 ± 2.6% | 1026.49 ± 0.4% | 21107.22 ± 3.7% | 511.44 ± 0.6% | 0.92 | 1.00 | 1.23 | 1.07 |
| class: two capitalized words | 23 | 413.82 ± 3.5% | 444.15 ± 1.9% | 665.94 ± 3.1% | 93.40 ± 1.2% | 447.30 ± 1.0% | 973.62 ± 12.1% | 6387.66 ± 0.3% | 413.99 ± 4.6% | 0.93 | 1.00 | 4.43 | 0.93 |
| class: a word that ends in ing | 9 | 496.83 ± 0.6% | 556.17 ± 0.4% | 1034.26 ± 0.5% | 114.77 ± 1.6% | 628.18 ± 0.9% | 1467.73 ± 4.5% | 15294.56 ± 2.1% | 495.92 ± 0.8% | 0.89 | 1.00 | 4.33 | 0.79 |
| class: a word in capitals | 16 | 428.82 ± 1.4% | 461.92 ± 3.4% | 789.12 ± 0.3% | 121.37 ± 1.4% | 650.71 ± 3.9% | 1302.36 ± 2.7% | 8363.26 ± 0.5% | 429.42 ± 0.6% | 0.93 | 1.00 | 3.53 | 0.66 |
| class: a number | 6 | 536.36 ± 0.5% | 589.53 ± 2.6% | 1175.54 ± 0.6% | 36.34 ± 1.7% | 1175.30 ± 2.5% | 2266.03 ± 0.9% | 20386.65 ± 1.4% | 535.15 ± 1.0% | 0.91 | 1.00 | 14.76 | 0.46 |
| class: two capitalized words, second text | 23 | 414.15 ± 0.3% | 443.08 ± 0.5% | 666.61 ± 0.5% | 93.87 ± 1.2% | 448.12 ± 2.6% | 935.86 ± 0.6% | 6389.31 ± 0.6% | 414.36 ± 8.1% | 0.93 | 1.00 | 4.41 | 0.92 |
| other: a word between two words | 13 | 491.36 ± 1.2% | 509.99 ± 0.5% | 834.19 ± 0.4% | 123.23 ± 0.9% | 434.65 ± 11.5% | 981.32 ± 1.1% | 14042.39 ± 11.8% | 491.12 ± 0.3% | 0.96 | 1.00 | 3.99 | 1.13 |
| other: a number before a unit, second text | 15 | 359.29 ± 6.6% | 395.57 ± 0.3% | 566.08 ± 0.9% | 33.84 ± 2.5% | 534.97 ± 2.5% | 1103.00 ± 8.4% | 13916.86 ± 0.4% | 359.30 ± 0.4% | 0.91 | 1.00 | 10.62 | 0.67 |
| other: a heading's start tag | 13 | 332.07 ± 0.4% | 338.49 ± 1.0% | 461.60 ± 0.3% | 35.51 ± 0.6% | 520.85 ± 10.1% | 1084.36 ± 0.9% | 16163.42 ± 1.5% | 331.82 ± 0.2% | 0.98 | 1.00 | 9.35 | 0.64 |
| other: a whole word | 11 | 504.75 ± 0.4% | 532.71 ± 0.9% | 887.77 ± 1.3% | 109.92 ± 2.1% | 502.94 ± 2.6% | 1029.63 ± 1.5% | 20825.16 ± 1.0% | 503.90 ± 0.4% | 0.95 | 1.00 | 4.59 | 1.00 |
| other: a line's first word, second text | 17 | 474.52 ± 0.5% | 499.49 ± 0.3% | 852.69 ± 1.1% | 112.55 ± 0.8% | 585.78 ± 1.6% | refused | refused | 472.70 ± 0.8% | 0.95 | 1.00 | 4.22 | 0.81 |
| other: fourteen octets before an x | 16 | 87.07 ± 0.5% | 123.29 ± 6.5% | 144.00 ± 4.0% | 14.11 ± 3.7% | 388.60 ± 5.9% | 451.04 ± 0.9% | 11738.42 ± 1.5% | 86.77 ± 12.5% | 0.71 | 1.00 | 6.17 | 0.22 |
| other: a Greek word | 8 | 363.84 ± 0.6% | 506.71 ± 0.9% | 868.02 ± 0.6% | 46.79 ± 0.8% | 1158.75 ± 1.7% | 2140.30 ± 0.6% | refused | 363.11 ± 0.6% | 0.72 | 1.00 | 7.78 | 0.31 |

The held-out set: every benchmark of rebar's curated set, at commit 463d00f31887e84c38467805b9e3122c314b9521, whose engines name Go's regexp or RE2. rebar's author chose its patterns and haystacks, and no claim of decision 86 is judged on them. A candidate's answer is held to the count rebar gives Go's regexp, and a candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on it: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and its haystacks hold up to 32 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 20347.01 ± 1.4% | not timed | not timed | 26602.37 ± 1.1% | 1889.19 ± 20.7% | not timed | not timed | 20324.05 ± 0.7% | | 1.00 | 0.76 | 10.77 |
| 01-literal/sherlock-casei-en | 522 | 4577.83 ± 0.5% | not timed | not timed | 7031.35 ± 0.4% | 28.34 ± 11.5% | not timed | not timed | 4565.35 ± 1.2% | | 1.00 | 0.65 | 161.53 |
| 01-literal/sherlock-ru | 724 | 21847.25 ± 1.2% | not timed | not timed | 27711.85 ± 18.4% | 1048.05 ± 16.6% | not timed | not timed | 21767.45 ± 0.4% | | 1.00 | 0.79 | 20.85 |
| 01-literal/sherlock-casei-ru | 746 | 7309.08 ± 0.7% | not timed | not timed | 5431.64 ± 0.4% | 30.43 ± 1.4% | not timed | not timed | 7300.26 ± 0.1% | | 1.00 | 1.35 | 240.19 |
| 01-literal/sherlock-zh | 30 | 38409.74 ± 1.9% | not timed | not timed | 36615.66 ± 4.0% | 1262.18 ± 0.6% | not timed | not timed | 37853.25 ± 8.8% | | 1.01 | 1.05 | 30.43 |
| 02-literal-alternate/sherlock-en | 714 | 9812.43 ± 0.9% | not timed | not timed | 8871.01 ± 0.6% | 14.81 ± 7.5% | not timed | not timed | 9864.04 ± 1.3% | | 0.99 | 1.11 | 662.66 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1739.77 ± 2.2% | not timed | not timed | 1778.76 ± 2.3% | 9.29 ± 2.6% | not timed | not timed | 1689.93 ± 2.2% | | 1.03 | 0.98 | 187.31 |
| 02-literal-alternate/sherlock-ru | 899 | 6011.92 ± 3.0% | not timed | not timed | 4242.15 ± 1.2% | 17.64 ± 1.9% | not timed | not timed | 5998.08 ± 1.7% | | 1.00 | 1.42 | 340.72 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1809.77 ± 0.5% | not timed | not timed | 1044.80 ± 0.7% | 8.56 ± 1.0% | not timed | not timed | 1809.67 ± 0.8% | | 1.00 | 1.73 | 211.54 |
| 02-literal-alternate/sherlock-zh | 207 | 13835.13 ± 3.3% | not timed | not timed | 10335.18 ± 0.8% | 27.71 ± 1.5% | not timed | not timed | 13916.43 ± 1.3% | | 0.99 | 1.34 | 499.21 |
| 03-date/ascii | 111817 | 107.98 ± 0.8% | not timed | not timed | 83.88 ± 16.3% | 0.18 ± 2.4% | not timed | not timed | 108.35 ± 0.7% | | 1.00 | 1.29 | 607.33 |
| 04-ruff-noqa/real | 84 | 562.09 ± 0.3% | not timed | not timed | 445.81 ± 0.2% | 14.62 ± 0.9% | not timed | not timed | 563.83 ± 0.1% | | 1.00 | 1.26 | 38.45 |
| 04-ruff-noqa/tweaked | 44 | 489.21 ± 0.7% | not timed | not timed | 429.78 ± 0.6% | 281.32 ± 1.5% | not timed | not timed | 488.38 ± 0.4% | | 1.00 | 1.14 | 1.74 |
| 05-lexer-veryl/single | 124800 | 2.92 ± 1.8% | not timed | not timed | 4.15 ± 0.5% | 0.21 ± 2.0% | not timed | not timed | 2.91 ± 5.3% | | 1.00 | 0.70 | 14.25 |
| 06-cloud-flare-redos/original | 107 | 178.03 ± 1.7% | not timed | not timed | 192.24 ± 5.7% | 12.93 ± 0.1% | not timed | not timed | 177.20 ± 0.6% | | 1.00 | 0.93 | 13.77 |
| 06-cloud-flare-redos/simplified-short | 102 | 126.85 ± 0.2% | not timed | not timed | 192.18 ± 0.4% | 14.08 ± 0.8% | not timed | not timed | 126.83 ± 6.4% | | 1.00 | 0.66 | 9.01 |
| 06-cloud-flare-redos/simplified-long | 10000 | 136.45 ± 8.6% | not timed | not timed | 211.68 ± 0.2% | 14.83 ± 0.6% | not timed | not timed | 136.28 ± 1.2% | | 1.00 | 0.64 | 9.20 |
| 07-unicode-character-data/parse-line | 558784 | 36.05 ± 2.7% | not timed | not timed | 160.24 ± 0.6% | 37.27 ± 4.0% | not timed | not timed | 35.34 ± 2.3% | | 1.02 | 0.22 | 0.97 |
| 08-words/all-english | 56691 | 73.63 ± 0.7% | not timed | not timed | 73.92 ± 0.3% | 10.13 ± 10.9% | not timed | not timed | 73.13 ± 8.8% | | 1.01 | 1.00 | 7.26 |
| 08-words/long-english | 839 | 844.40 ± 0.5% | not timed | not timed | 513.97 ± 0.3% | 26.59 ± 0.7% | not timed | not timed | 848.58 ± 0.1% | | 1.00 | 1.64 | 31.76 |
| 09-aws-keys/full | 0 | 431.88 ± 1.2% | not timed | not timed | 448.52 ± 0.7% | 52.19 ± 5.2% | not timed | not timed | 431.76 ± 2.1% | | 1.00 | 0.96 | 8.28 |
| 09-aws-keys/quick | 0 | 441.29 ± 0.5% | not timed | not timed | 801.27 ± 0.4% | 300.27 ± 3.5% | not timed | not timed | 441.89 ± 0.3% | | 1.00 | 0.55 | 1.47 |
| 10-bounded-repeat/letters-en | 1833 | 470.35 ± 0.6% | not timed | not timed | 432.19 ± 0.6% | 16.91 ± 1.0% | not timed | not timed | 470.35 ± 0.1% | | 1.00 | 1.09 | 27.82 |
| 10-bounded-repeat/letters-ru | 3475 | 325.16 ± 0.4% | not timed | not timed | 408.77 ± 3.6% | 17.94 ± 33.3% | not timed | not timed | 323.53 ± 0.5% | | 1.01 | 0.80 | 18.13 |
| 10-bounded-repeat/context | 53 | 59.28 ± 1.3% | not timed | not timed | 54.96 ± 4.5% | 16.95 ± 1.7% | not timed | not timed | 50.23 ± 1.0% | | 1.18 | 1.08 | 3.50 |
| 10-bounded-repeat/capitals | 11 | 893.43 ± 0.4% | not timed | not timed | 532.38 ± 2.1% | 30.88 ± 0.3% | not timed | not timed | 892.30 ± 3.1% | | 1.00 | 1.68 | 28.93 |
| 11-unstructured-to-json/extract | 600 | 20.15 ± 0.1% | not timed | not timed | 62.51 ± 0.6% | 22.97 ± 3.4% | not timed | not timed | 20.66 ± 5.0% | | 0.98 | 0.32 | 0.88 |
| 12-dictionary/single | 1 | 460.26 ± 0.5% | not timed | not timed | 442.97 ± 1.7% | 0.32 ± 0.3% | not timed | not timed | 462.54 ± 0.2% | | 1.00 | 1.04 | 1437.77 |
| 14-quadratic/1x | 100 | 11.23 ± 15.4% | not timed | not timed | 9.12 ± 1.0% | 0.79 ± 2.6% | not timed | not timed | 11.45 ± 1.5% | | 0.98 | 1.23 | 14.20 |
| 14-quadratic/2x | 200 | 6.83 ± 0.6% | not timed | not timed | 4.91 ± 1.1% | 0.43 ± 1.1% | not timed | not timed | 6.91 ± 0.2% | | 0.99 | 1.39 | 15.86 |
| 14-quadratic/10x | 1000 | 1.56 ± 0.5% | not timed | not timed | 1.05 ± 0.1% | 0.09 ± 1.6% | not timed | not timed | 1.57 ± 1.7% | | 0.99 | 1.49 | 16.82 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.32 ± 7.4% | not timed | not timed | 0.38 ± 1.3% | 0.47 ± 4.4% | not timed | not timed | 1.30 ± 1.7% | | 1.01 | 3.45 | 2.79 |
| 04-ruff-noqa/compile-real | 1 | 80.42 ± 2.3% | not timed | not timed | 12.81 ± 2.9% | 117.89 ± 2.9% | not timed | not timed | 80.19 ± 2.0% | | 1.00 | 6.28 | 0.68 |
| 05-lexer-veryl/compile-single | 1 | 12.62 ± 6.3% | not timed | not timed | 2.34 ± 0.3% | 5.75 ± 29.1% | not timed | not timed | 12.69 ± 4.1% | | 0.99 | 5.39 | 2.19 |
| 07-unicode-character-data/compile | 1 | 51.38 ± 0.5% | not timed | not timed | 24.32 ± 1.0% | 31.64 ± 4.7% | not timed | not timed | 50.68 ± 1.0% | | 1.01 | 2.11 | 1.62 |
| 09-aws-keys/compile-full | 1 | 35.05 ± 0.3% | not timed | not timed | 7.32 ± 1.2% | 20.13 ± 3.0% | not timed | not timed | 34.44 ± 14.9% | | 1.02 | 4.79 | 1.74 |
| 09-aws-keys/compile-quick | 1 | 152.20 ± 14.2% | not timed | not timed | 44.75 ± 0.4% | 116.41 ± 2.2% | not timed | not timed | 151.64 ± 14.6% | | 1.00 | 3.40 | 1.31 |
| 10-bounded-repeat/compile-context | 1 | 10.47 ± 11.4% | not timed | not timed | 11.59 ± 0.5% | 14.83 ± 2.9% | not timed | not timed | 10.49 ± 2.6% | | 1.00 | 0.90 | 0.71 |
| 10-bounded-repeat/compile-capitals | 1 | 72.67 ± 2.2% | not timed | not timed | 8.76 ± 1.0% | 21.82 ± 3.3% | not timed | not timed | 72.20 ± 1.5% | | 1.01 | 8.30 | 3.33 |
| 11-unstructured-to-json/compile | 1 | 77.68 ± 0.9% | not timed | not timed | 36.42 ± 0.8% | 58.32 ± 5.2% | not timed | not timed | 77.61 ± 1.7% | | 1.00 | 2.13 | 1.33 |
| 12-dictionary/compile-single | 1 | 0.26 ± 0.7% | not timed | not timed | 0.07 ± 4.8% | 0.08 ± 12.2% | not timed | not timed | 0.26 ± 2.6% | | 1.00 | 3.92 | 3.16 |

