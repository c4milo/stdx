# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391535126 |
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
| literal: a word | 217 | 18952.45 ± 1.6% | 5022.68 ± 0.3% | 28.12 ± 0.3% | 17835.20 ± 2.1% | 9049.92 ± 10.2% | 17.46 ± 0.6% | 84.50 ± 0.9% | 19043.32 ± 1.9% | 3.77 | 1.00 | 1.06 | 2.09 |
| literal: a word that is not there | 0 | 21243.62 ± 3.6% | 4914.00 ± 0.3% | 28.20 ± 0.5% | 19428.36 ± 4.3% | 27983.96 ± 3.0% | 17.29 ± 0.0% | 79.79 ± 0.5% | 21120.27 ± 2.4% | 4.32 | 1.01 | 1.09 | 0.76 |
| literal: one of four words | 661 | 6307.74 ± 0.3% | 1945.10 ± 0.2% | 14.25 ± 0.1% | 3945.62 ± 0.2% | 21.88 ± 0.3% | 5.25 ± 0.5% | 6.87 ± 0.6% | 6321.31 ± 0.3% | 3.24 | 1.00 | 1.60 | 288.35 |
| literal: a word in any case | 217 | 14968.00 ± 1.4% | 2081.45 ± 0.2% | 21.21 ± 0.5% | 3969.96 ± 0.3% | 37.98 ± 0.1% | refused | differs | 14976.85 ± 2.1% | 7.19 | 1.00 | 3.77 | 394.10 |
| literal: an href attribute | 33 | 16153.36 ± 1.3% | 607.63 ± 0.5% | 26.80 ± 0.3% | 16517.10 ± 1.6% | 2253.78 ± 7.0% | 13.34 ± 0.3% | 74.17 ± 0.3% | 16249.88 ± 1.4% | 26.58 | 0.99 | 0.98 | 7.17 |
| literal: a word, second text | 123 | 19523.81 ± 2.6% | 3385.28 ± 0.1% | 27.74 ± 0.3% | 18071.33 ± 1.9% | 7600.53 ± 3.9% | 19.65 ± 0.4% | 70.05 ± 1.5% | 19715.29 ± 0.7% | 5.77 | 0.99 | 1.08 | 2.57 |
| class: two capitalized words | 1331 | 1069.83 ± 0.4% | 598.80 ± 0.4% | 25.70 ± 0.4% | 584.64 ± 0.1% | 40.65 ± 8.3% | 14.81 ± 0.5% | 67.44 ± 0.5% | 1071.03 ± 0.2% | 1.79 | 1.00 | 1.83 | 26.32 |
| class: a word that ends in ing | 3399 | 572.99 ± 0.5% | 572.60 ± 0.5% | 17.79 ± 0.1% | 547.46 ± 0.4% | 29.60 ± 8.2% | 8.17 ± 0.3% | 18.39 ± 0.3% | 573.20 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.35 |
| class: a word in capitals | 2332 | 1376.95 ± 0.4% | 604.41 ± 0.3% | 27.27 ± 0.6% | 572.35 ± 0.1% | 43.75 ± 0.2% | 17.18 ± 0.2% | 82.57 ± 0.4% | 1379.12 ± 0.4% | 2.28 | 1.00 | 2.41 | 31.47 |
| class: a number | 8288 | 1997.86 ± 0.3% | 828.35 ± 0.0% | 27.50 ± 0.3% | 1735.36 ± 0.2% | 41.22 ± 8.7% | 0.56 ± 0.2% | 57.42 ± 0.2% | 2000.39 ± 0.3% | 2.41 | 1.00 | 1.15 | 48.46 |
| class: two capitalized words, second text | 5359 | 515.49 ± 0.2% | 523.58 ± 0.1% | 23.07 ± 0.2% | 485.50 ± 0.1% | 31.11 ± 12.8% | 16.67 ± 0.1% | 62.84 ± 0.3% | 515.14 ± 0.2% | 0.98 | 1.00 | 1.06 | 16.57 |
| other: a word between two words | 6104 | 789.41 ± 0.1% | 592.71 ± 0.2% | 23.27 ± 0.1% | 737.38 ± 0.1% | 104.99 ± 18.2% | 11.29 ± 0.1% | 68.40 ± 1.2% | 789.91 ± 0.2% | 1.33 | 1.00 | 1.07 | 7.52 |
| other: a number before a unit, second text | 1481 | 5942.26 ± 0.7% | 1121.28 ± 0.2% | 25.88 ± 0.1% | 5649.83 ± 0.9% | 40.85 ± 9.3% | 17.80 ± 0.1% | 65.78 ± 0.7% | 5968.79 ± 2.0% | 5.30 | 1.00 | 1.05 | 145.45 |
| other: a heading's start tag | 110 | 13665.76 ± 0.4% | 742.88 ± 0.2% | 27.17 ± 0.3% | 1709.85 ± 0.5% | 1569.73 ± 1.1% | 16.24 ± 0.3% | 86.08 ± 0.5% | 13770.11 ± 1.2% | 18.40 | 0.99 | 7.99 | 8.71 |
| other: a whole word | 217 | 15543.04 ± 1.0% | 602.56 ± 1.1% | 28.96 ± 0.5% | 14367.90 ± 1.5% | 49.38 ± 8.5% | 13.60 ± 0.4% | 54.98 ± 0.6% | 15581.32 ± 0.6% | 25.79 | 1.00 | 1.08 | 314.78 |
| other: a line's first word, second text | 3716 | 2030.55 ± 0.4% | 587.17 ± 0.2% | 30.46 ± 0.3% | 1718.95 ± 0.5% | 61.77 ± 6.5% | refused | refused | 2038.63 ± 0.7% | 3.46 | 1.00 | 1.18 | 32.87 |
| other: fourteen octets before an x | 87 | 22661.73 ± 1.0% | 244.26 ± 0.4% | 6.30 ± 0.1% | 3695.19 ± 1.6% | 10.62 ± 0.2% | differs | 17.77 ± 0.2% | 22752.98 ± 6.0% | 92.78 | 1.00 | 6.13 | 2133.97 |
| other: a Greek word | 21815 | 498.56 ± 0.2% | 413.74 ± 0.2% | 30.58 ± 0.2% | 289.58 ± 0.3% | 44.12 ± 12.1% | differs | refused | 501.99 ± 0.7% | 1.21 | 0.99 | 1.72 | 11.30 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.60 ± 0.2% | 19.57 ± 0.2% | 0.85 ± 0.1% | 19.61 ± 1.0% | 2.76 ± 0.9% | differs | 4.05 ± 0.1% | 19.57 ± 0.3% | 1.00 | 1.00 | 1.00 | 7.11 |
| a UUID | 32895 | 21.09 ± 0.2% | 21.05 ± 0.4% | 0.64 ± 0.1% | 15.21 ± 0.2% | 3.11 ± 0.5% | 0.72 ± 0.2% | 3.64 ± 0.3% | 21.08 ± 0.3% | 1.00 | 1.00 | 1.39 | 6.78 |
| an IPv4 address | 33176 | 35.90 ± 0.1% | 35.86 ± 0.1% | 2.05 ± 0.1% | 28.95 ± 0.5% | 6.66 ± 0.2% | differs | 4.16 ± 0.1% | 35.88 ± 0.3% | 1.00 | 1.00 | 1.24 | 5.39 |
| a date and time | 32954 | 30.92 ± 0.8% | 31.03 ± 0.7% | 1.43 ± 0.2% | 21.19 ± 0.2% | 7.04 ± 0.2% | 1.20 ± 0.3% | 7.12 ± 0.3% | 31.02 ± 0.5% | 1.00 | 1.00 | 1.46 | 4.39 |
| a field path | 32606 | 23.18 ± 0.2% | 23.15 ± 0.1% | 1.01 ± 0.6% | 23.07 ± 0.2% | 3.47 ± 1.7% | differs | 2.98 ± 0.1% | 23.15 ± 0.1% | 1.00 | 1.00 | 1.00 | 6.67 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.19 ± 1.0% | 11.17 ± 0.9% | 11.19 ± 1.3% | 11.38 ± 0.1% | 4.94 ± 1.3% | 0.91 ± 0.3% | none | 11.16 ± 1.2% | 1.00 | 1.00 | 0.98 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 170.03 ± 0.7% | 170.63 ± 0.2% | 195.33 ± 0.2% | 86.27 ± 0.1% | 217.44 ± 2.1% | 486.62 ± 0.3% | 3796.68 ± 4.2% | 170.05 ± 0.2% | 1.00 | 1.00 | 1.97 | 0.78 |
| a UUID | 62 | 111.52 ± 0.5% | 111.85 ± 0.3% | 122.35 ± 0.5% | 45.51 ± 0.8% | 97.29 ± 1.7% | 180.36 ± 1.0% | 4172.24 ± 0.5% | 111.47 ± 0.6% | 1.00 | 1.00 | 2.45 | 1.15 |
| an IPv4 address | 29 | 408.55 ± 0.3% | 413.03 ± 0.5% | 593.84 ± 0.4% | 75.70 ± 0.8% | 128.40 ± 1.2% | 291.72 ± 1.0% | 7484.50 ± 0.4% | 408.33 ± 0.3% | 0.99 | 1.00 | 5.40 | 3.18 |
| a date and time | 56 | 295.50 ± 0.6% | 298.14 ± 0.4% | 381.80 ± 0.1% | 72.01 ± 1.2% | 135.08 ± 1.7% | 323.90 ± 1.9% | 4766.82 ± 1.3% | 295.82 ± 0.5% | 0.99 | 1.00 | 4.10 | 2.19 |
| a field path | 39 | 153.30 ± 0.2% | 153.87 ± 0.5% | 173.99 ± 0.1% | 78.83 ± 0.2% | 202.71 ± 0.9% | 486.89 ± 1.2% | 4878.42 ± 0.4% | 153.64 ± 0.5% | 1.00 | 1.00 | 1.94 | 0.76 |
| literal: a word | 7 | 603.49 ± 0.5% | 651.29 ± 0.6% | 1222.82 ± 0.1% | 490.03 ± 1.3% | 621.17 ± 3.0% | 926.84 ± 0.7% | 30513.51 ± 0.2% | 603.79 ± 0.4% | 0.93 | 1.00 | 1.23 | 0.97 |
| literal: a word that is not there | 8 | 576.42 ± 0.6% | 629.04 ± 0.6% | 1144.19 ± 0.6% | 450.40 ± 0.4% | 594.23 ± 2.2% | 876.51 ± 0.8% | 29289.93 ± 0.1% | 578.37 ± 0.1% | 0.92 | 1.00 | 1.28 | 0.97 |
| literal: one of four words | 26 | 235.93 ± 0.2% | 385.08 ± 0.4% | 539.75 ± 0.2% | 49.14 ± 0.1% | 238.73 ± 1.6% | 361.41 ± 0.5% | 15945.22 ± 0.1% | 235.94 ± 0.2% | 0.61 | 1.00 | 4.80 | 0.99 |
| literal: a word in any case | 11 | 438.01 ± 0.3% | 466.24 ± 0.3% | 713.52 ± 0.2% | 15.62 ± 0.7% | 634.96 ± 3.4% | refused | 23818.91 ± 0.3% | 437.40 ± 0.3% | 0.94 | 1.00 | 28.03 | 0.69 |
| literal: an href attribute | 12 | 308.54 ± 0.6% | 318.91 ± 0.4% | 419.58 ± 0.2% | 9.81 ± 7.8% | 486.63 ± 2.2% | 757.11 ± 1.1% | 21616.68 ± 0.7% | 308.75 ± 0.4% | 0.97 | 1.00 | 31.46 | 0.63 |
| literal: a word, second text | 10 | 539.08 ± 0.3% | 591.66 ± 0.9% | 1036.77 ± 0.5% | 408.29 ± 0.3% | 527.25 ± 3.1% | 784.88 ± 0.5% | 27225.84 ± 0.1% | 539.29 ± 0.9% | 0.91 | 1.00 | 1.32 | 1.02 |
| class: two capitalized words | 23 | 423.41 ± 0.3% | 452.96 ± 0.4% | 671.90 ± 0.5% | 98.20 ± 1.1% | 502.43 ± 1.9% | 754.87 ± 0.8% | 6457.89 ± 0.3% | 423.72 ± 0.5% | 0.93 | 1.00 | 4.31 | 0.84 |
| class: a word that ends in ing | 9 | 532.27 ± 0.5% | 596.67 ± 0.7% | 1083.53 ± 0.1% | 130.99 ± 0.5% | 758.26 ± 1.0% | 1082.62 ± 1.3% | 15759.90 ± 1.4% | 532.84 ± 0.2% | 0.89 | 1.00 | 4.06 | 0.70 |
| class: a word in capitals | 16 | 473.95 ± 0.7% | 514.34 ± 0.5% | 844.95 ± 0.1% | 133.47 ± 1.5% | 747.97 ± 1.8% | 1022.86 ± 2.8% | 8516.12 ± 0.3% | 473.41 ± 0.2% | 0.92 | 1.00 | 3.55 | 0.63 |
| class: a number | 6 | 598.04 ± 0.6% | 664.04 ± 0.9% | 1303.37 ± 0.1% | 41.82 ± 0.7% | 1396.83 ± 1.4% | 1953.06 ± 0.9% | 22893.71 ± 0.1% | 597.30 ± 0.6% | 0.90 | 1.00 | 14.30 | 0.43 |
| class: two capitalized words, second text | 23 | 423.00 ± 1.1% | 453.11 ± 0.5% | 672.92 ± 1.0% | 99.68 ± 1.7% | 502.64 ± 0.5% | 747.83 ± 0.6% | 6459.29 ± 0.3% | 424.32 ± 0.2% | 0.93 | 1.00 | 4.24 | 0.84 |
| other: a word between two words | 13 | 519.37 ± 0.4% | 537.93 ± 0.6% | 887.70 ± 0.4% | 133.36 ± 1.4% | 499.76 ± 0.8% | 814.98 ± 0.6% | 14573.58 ± 0.4% | 519.10 ± 0.4% | 0.97 | 1.00 | 3.89 | 1.04 |
| other: a number before a unit, second text | 15 | 323.03 ± 0.6% | 350.74 ± 0.2% | 472.10 ± 0.4% | 39.48 ± 0.7% | 633.97 ± 1.9% | 891.13 ± 0.1% | 15187.88 ± 0.7% | 323.18 ± 0.4% | 0.92 | 1.00 | 8.18 | 0.51 |
| other: a heading's start tag | 13 | 320.11 ± 0.7% | 326.30 ± 0.9% | 428.53 ± 0.7% | 12.65 ± 57.3% | 623.94 ± 1.0% | 858.09 ± 0.7% | 18000.91 ± 0.6% | 320.90 ± 0.8% | 0.98 | 1.00 | 25.31 | 0.51 |
| other: a whole word | 11 | 557.58 ± 0.7% | 593.41 ± 0.5% | 1030.10 ± 0.5% | 119.35 ± 0.3% | 565.38 ± 1.2% | 827.84 ± 0.3% | 27181.46 ± 0.3% | 557.29 ± 0.7% | 0.94 | 1.00 | 4.67 | 0.99 |
| other: a line's first word, second text | 17 | 505.25 ± 0.4% | 529.22 ± 0.5% | 880.44 ± 0.9% | 128.95 ± 0.7% | 709.98 ± 0.8% | refused | refused | 507.30 ± 0.6% | 0.95 | 1.00 | 3.92 | 0.71 |
| other: fourteen octets before an x | 16 | 105.09 ± 0.7% | 148.33 ± 0.7% | 172.94 ± 0.7% | 6.86 ± 21.7% | 450.09 ± 1.2% | 410.71 ± 0.7% | 12780.25 ± 0.2% | 105.43 ± 0.6% | 0.71 | 1.00 | 15.32 | 0.23 |
| other: a Greek word | 8 | 377.96 ± 0.5% | 498.88 ± 0.3% | 798.87 ± 0.3% | 11.59 ± 36.3% | 1373.97 ± 1.5% | 1861.57 ± 0.3% | refused | 378.50 ± 0.4% | 0.76 | 1.00 | 32.61 | 0.28 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15166.99 ± 1.8% | not timed | not timed | 15747.82 ± 1.3% | 2059.25 ± 16.3% | not timed | not timed | 15115.53 ± 0.4% | | 1.00 | 0.96 | 7.37 |
| 01-literal/sherlock-casei-en | 522 | 10965.62 ± 4.6% | not timed | not timed | 3579.32 ± 0.4% | 32.52 ± 0.3% | not timed | not timed | 10969.16 ± 0.9% | | 1.00 | 3.06 | 337.21 |
| 01-literal/sherlock-ru | 724 | 17063.70 ± 0.8% | not timed | not timed | 16995.10 ± 2.9% | 1414.14 ± 15.5% | not timed | not timed | 17015.66 ± 0.6% | | 1.00 | 1.00 | 12.07 |
| 01-literal/sherlock-casei-ru | 746 | 6174.48 ± 0.5% | not timed | not timed | 3331.97 ± 0.2% | 30.73 ± 0.3% | not timed | not timed | 6180.30 ± 0.3% | | 1.00 | 1.85 | 200.92 |
| 01-literal/sherlock-zh | 30 | 19465.67 ± 0.4% | not timed | not timed | 18367.83 ± 1.0% | 2661.42 ± 13.5% | not timed | not timed | 19369.81 ± 1.2% | | 1.00 | 1.06 | 7.31 |
| 02-literal-alternate/sherlock-en | 714 | 6008.89 ± 0.5% | not timed | not timed | 3937.17 ± 0.3% | 16.61 ± 0.4% | not timed | not timed | 6029.28 ± 0.5% | | 1.00 | 1.53 | 361.86 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1979.21 ± 1.2% | not timed | not timed | 697.48 ± 0.4% | 11.12 ± 0.1% | not timed | not timed | 1978.64 ± 0.9% | | 1.00 | 2.84 | 178.01 |
| 02-literal-alternate/sherlock-ru | 899 | 5560.18 ± 0.3% | not timed | not timed | 3251.93 ± 0.1% | 22.60 ± 0.1% | not timed | not timed | 5565.14 ± 0.5% | | 1.00 | 1.71 | 246.05 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2055.09 ± 0.5% | not timed | not timed | 1229.88 ± 0.6% | 9.11 ± 0.1% | not timed | not timed | 2057.58 ± 0.5% | | 1.00 | 1.67 | 225.62 |
| 02-literal-alternate/sherlock-zh | 207 | 7286.52 ± 0.5% | not timed | not timed | 4157.78 ± 0.2% | 31.54 ± 0.1% | not timed | not timed | 7274.28 ± 0.7% | | 1.00 | 1.75 | 231.05 |
| 03-date/ascii | 111817 | 124.77 ± 0.8% | not timed | not timed | 95.80 ± 0.1% | 0.20 ± 3.2% | not timed | not timed | 124.86 ± 0.7% | | 1.00 | 1.30 | 616.78 |
| 04-ruff-noqa/real | 84 | 403.10 ± 0.1% | not timed | not timed | 462.89 ± 0.1% | 19.67 ± 1.2% | not timed | not timed | 403.24 ± 0.1% | | 1.00 | 0.87 | 20.49 |
| 04-ruff-noqa/tweaked | 44 | 555.36 ± 0.3% | not timed | not timed | 459.82 ± 0.1% | 365.87 ± 0.5% | not timed | not timed | 556.76 ± 0.3% | | 1.00 | 1.21 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.25 ± 0.2% | not timed | not timed | 5.03 ± 0.1% | 0.20 ± 4.1% | not timed | not timed | 5.18 ± 3.1% | | 1.01 | 1.04 | 25.67 |
| 06-cloud-flare-redos/original | 107 | 415.40 ± 0.2% | not timed | not timed | 216.44 ± 0.1% | 24.93 ± 0.1% | not timed | not timed | 416.17 ± 0.2% | | 1.00 | 1.92 | 16.66 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.05 ± 0.2% | not timed | not timed | 228.11 ± 0.4% | 26.61 ± 0.3% | not timed | not timed | 409.78 ± 0.1% | | 1.01 | 1.82 | 15.60 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.77 ± 0.3% | not timed | not timed | 254.89 ± 0.1% | 28.75 ± 0.1% | not timed | not timed | 578.49 ± 0.5% | | 1.02 | 2.31 | 20.45 |
| 07-unicode-character-data/parse-line | 558784 | 233.66 ± 1.8% | not timed | not timed | 169.99 ± 1.7% | 42.42 ± 5.4% | not timed | not timed | 234.59 ± 8.0% | | 1.00 | 1.37 | 5.51 |
| 08-words/all-english | 56691 | 116.67 ± 0.4% | not timed | not timed | 82.77 ± 0.1% | 12.70 ± 11.0% | not timed | not timed | 116.72 ± 0.8% | | 1.00 | 1.41 | 9.19 |
| 08-words/long-english | 839 | 614.59 ± 0.6% | not timed | not timed | 596.18 ± 0.2% | 32.64 ± 0.3% | not timed | not timed | 614.25 ± 0.8% | | 1.00 | 1.03 | 18.83 |
| 09-aws-keys/full | 0 | 408.24 ± 0.2% | not timed | not timed | 459.89 ± 0.1% | 66.00 ± 3.5% | not timed | not timed | 408.61 ± 0.1% | | 1.00 | 0.89 | 6.19 |
| 09-aws-keys/quick | 0 | 870.26 ± 0.3% | not timed | not timed | 983.50 ± 0.5% | 418.07 ± 0.4% | not timed | not timed | 871.45 ± 0.2% | | 1.00 | 0.88 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 584.66 ± 2.6% | not timed | not timed | 515.77 ± 0.7% | 19.58 ± 0.6% | not timed | not timed | 579.58 ± 1.4% | | 1.01 | 1.13 | 29.85 |
| 10-bounded-repeat/letters-ru | 3475 | 508.43 ± 1.4% | not timed | not timed | 478.00 ± 0.2% | 22.47 ± 17.1% | not timed | not timed | 511.99 ± 1.3% | | 0.99 | 1.06 | 22.62 |
| 10-bounded-repeat/context | 53 | 84.66 ± 1.8% | not timed | not timed | 65.49 ± 0.7% | 19.81 ± 0.1% | not timed | not timed | 85.20 ± 1.4% | | 0.99 | 1.29 | 4.27 |
| 10-bounded-repeat/capitals | 11 | 641.30 ± 8.0% | not timed | not timed | 615.69 ± 0.1% | 36.59 ± 0.2% | not timed | not timed | 640.63 ± 8.0% | | 1.00 | 1.04 | 17.53 |
| 11-unstructured-to-json/extract | 600 | 56.95 ± 0.6% | not timed | not timed | 77.85 ± 0.3% | 49.05 ± 1.1% | not timed | not timed | 56.92 ± 0.5% | | 1.00 | 0.73 | 1.16 |
| 12-dictionary/single | 1 | 567.41 ± 0.3% | not timed | not timed | 559.90 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 567.58 ± 0.2% | | 1.00 | 1.01 | 1420.81 |
| 14-quadratic/1x | 100 | 21.14 ± 1.2% | not timed | not timed | 10.00 ± 0.2% | 0.96 ± 2.6% | not timed | not timed | 21.15 ± 0.8% | | 1.00 | 2.11 | 22.02 |
| 14-quadratic/2x | 200 | 17.40 ± 0.6% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 1.8% | not timed | not timed | 17.39 ± 0.5% | | 1.00 | 3.14 | 32.87 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.5% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.9% | not timed | not timed | 7.69 ± 0.7% | | 1.00 | 6.37 | 66.69 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.21 ± 2.1% | not timed | not timed | 0.34 ± 0.5% | 0.54 ± 5.0% | not timed | not timed | 1.21 ± 1.0% | | 1.00 | 3.55 | 2.24 |
| 04-ruff-noqa/compile-real | 1 | 104.83 ± 0.9% | not timed | not timed | 13.76 ± 0.4% | 136.73 ± 2.3% | not timed | not timed | 105.07 ± 1.4% | | 1.00 | 7.62 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 13.97 ± 1.5% | not timed | not timed | 2.50 ± 0.6% | 6.16 ± 3.5% | not timed | not timed | 13.99 ± 0.4% | | 1.00 | 5.58 | 2.27 |
| 07-unicode-character-data/compile | 1 | 107.20 ± 1.3% | not timed | not timed | 25.90 ± 0.5% | 34.42 ± 5.3% | not timed | not timed | 107.55 ± 0.8% | | 1.00 | 4.14 | 3.11 |
| 09-aws-keys/compile-full | 1 | 52.89 ± 0.7% | not timed | not timed | 8.24 ± 0.5% | 22.87 ± 2.2% | not timed | not timed | 53.00 ± 1.3% | | 1.00 | 6.42 | 2.31 |
| 09-aws-keys/compile-quick | 1 | 181.71 ± 1.2% | not timed | not timed | 47.02 ± 0.3% | 129.11 ± 4.9% | not timed | not timed | 183.42 ± 0.5% | | 0.99 | 3.86 | 1.41 |
| 10-bounded-repeat/compile-context | 1 | 71.34 ± 2.0% | not timed | not timed | 11.05 ± 0.5% | 15.54 ± 3.3% | not timed | not timed | 71.83 ± 1.5% | | 0.99 | 6.46 | 4.59 |
| 10-bounded-repeat/compile-capitals | 1 | 84.83 ± 0.5% | not timed | not timed | 8.02 ± 0.2% | 23.23 ± 3.9% | not timed | not timed | 84.21 ± 0.9% | | 1.01 | 10.58 | 3.65 |
| 11-unstructured-to-json/compile | 1 | 169.41 ± 0.3% | not timed | not timed | 41.36 ± 0.2% | 66.19 ± 3.2% | not timed | not timed | 169.71 ± 0.3% | | 1.00 | 4.10 | 2.56 |
| 12-dictionary/compile-single | 1 | 0.34 ± 1.5% | not timed | not timed | 0.07 ± 31.5% | 0.10 ± 11.5% | not timed | not timed | 0.35 ± 1.6% | | 1.00 | 5.15 | 3.60 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.51 ± 5.5% | not timed | not timed | 6.42 ± 0.2% | 0.58 ± 18.6% | not timed | not timed | 7.54 ± 2.1% | | 1.00 | 1.17 | 13.02 |
| dictionary/search/english-10 | 690 | 1.04 ± 0.7% | not timed | not timed | 165.89 ± 0.7% | 0.00 ± 0.6% | not timed | not timed | 1.04 ± 0.6% | | 1.00 | 0.0063 | 419.80 |
| dictionary/search/english-15 | 15 | 559.84 ± 0.3% | not timed | not timed | 560.11 ± 0.0% | 0.37 ± 0.2% | not timed | not timed | 560.69 ± 0.5% | | 1.00 | 1.00 | 1530.26 |
| folly/awyer-inn-busted | 1 | 5585.57 ± 0.3% | not timed | not timed | 143.21 ± 0.1% | 44.09 ± 0.2% | not timed | not timed | 5571.83 ± 0.1% | | 1.00 | 39.00 | 126.70 |
| folly/literal-never-match-rare | 0 | 21015.06 ± 0.7% | not timed | not timed | 19810.53 ± 0.8% | 40715.69 ± 0.9% | not timed | not timed | 21020.16 ± 0.4% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12492.48 ± 1.1% | not timed | not timed | 19719.40 ± 0.8% | 2185.22 ± 0.7% | not timed | not timed | 12508.20 ± 0.6% | | 1.00 | 0.63 | 5.72 |
| folly/literal-never-match-tricksy | 1 | 3251.21 ± 0.5% | not timed | not timed | 4414.74 ± 0.6% | 3052.54 ± 0.4% | not timed | not timed | 3254.02 ± 0.5% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1303.00 ± 0.5% | not timed | not timed | 956.85 ± 0.3% | 368.78 ± 15.7% | not timed | not timed | 1308.96 ± 0.2% | | 1.00 | 1.36 | 3.53 |
| grep/long-words-ascii | 5073 | 458.83 ± 0.2% | not timed | not timed | 469.45 ± 0.1% | 45.93 ± 6.6% | not timed | not timed | 459.81 ± 0.1% | | 1.00 | 0.98 | 9.99 |
| imported/leipzig/twain | 811 | 20580.09 ± 1.3% | not timed | not timed | 19444.58 ± 1.3% | 11901.64 ± 8.6% | not timed | not timed | 20597.20 ± 0.7% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 8999.26 ± 1.1% | not timed | not timed | 4242.69 ± 0.2% | 37.65 ± 2.3% | not timed | not timed | 9072.79 ± 1.1% | | 0.99 | 2.12 | 239.03 |
| imported/leipzig/shing | 1540 | 629.37 ± 0.1% | not timed | not timed | 13049.83 ± 1.6% | 33.72 ± 0.1% | not timed | not timed | 631.56 ± 0.2% | | 1.00 | 0.0482 | 18.67 |
| imported/leipzig/huck-saw | 262 | 8102.07 ± 4.1% | not timed | not timed | 5581.10 ± 0.7% | 31.54 ± 0.1% | not timed | not timed | 8370.83 ± 3.4% | | 0.97 | 1.45 | 256.89 |
| imported/leipzig/word-ending-nn | 262 | 608.82 ± 0.2% | not timed | not timed | 616.62 ± 0.2% | 24.64 ± 0.3% | not timed | not timed | 611.27 ± 0.1% | | 1.00 | 0.99 | 24.71 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11024.88 ± 0.9% | not timed | not timed | 4495.89 ± 3.6% | 11.35 ± 1.4% | not timed | not timed | 10979.89 ± 2.8% | | 1.00 | 2.45 | 971.43 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7788.76 ± 3.4% | not timed | not timed | 5481.57 ± 0.4% | 16.69 ± 0.0% | not timed | not timed | 7803.09 ± 2.3% | | 1.00 | 1.42 | 466.57 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4164.32 ± 1.0% | not timed | not timed | 417.34 ± 0.8% | 10.96 ± 0.1% | not timed | not timed | 4176.47 ± 1.4% | | 1.00 | 9.98 | 379.98 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 609.30 ± 0.1% | not timed | not timed | 615.03 ± 0.2% | 10.85 ± 0.1% | not timed | not timed | 608.42 ± 0.2% | | 1.00 | 0.99 | 56.16 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.30 ± 0.4% | not timed | not timed | 615.42 ± 0.0% | 9.61 ± 0.1% | not timed | not timed | 610.18 ± 0.1% | | 1.00 | 0.99 | 63.42 |
| imported/leipzig/tom-river | 2 | 6462.09 ± 2.8% | not timed | not timed | 5122.59 ± 1.1% | 30.81 ± 0.1% | not timed | not timed | 6509.15 ± 3.0% | | 0.99 | 1.26 | 209.76 |
| imported/leipzig/ing | 78424 | 608.65 ± 0.7% | not timed | not timed | 571.76 ± 0.0% | 27.72 ± 4.1% | not timed | not timed | 607.47 ± 0.8% | | 1.00 | 1.06 | 21.96 |
| imported/leipzig/ing-whitespace | 55248 | 757.14 ± 0.6% | not timed | not timed | 2065.54 ± 0.5% | 20.41 ± 2.7% | not timed | not timed | 741.00 ± 0.7% | | 1.02 | 0.37 | 37.10 |
| imported/leipzig/awyer-inn | 209 | 774.57 ± 1.4% | not timed | not timed | 4259.11 ± 0.2% | 22.52 ± 0.0% | not timed | not timed | 773.62 ± 1.4% | | 1.00 | 0.18 | 34.40 |
| imported/leipzig/quotes-bounded | 8886 | 2113.52 ± 0.7% | not timed | not timed | 2982.63 ± 1.4% | 37.95 ± 0.2% | not timed | not timed | 2111.86 ± 1.1% | | 1.00 | 0.71 | 55.69 |
| imported/leipzig/non-ascii-alternate | 2 | 12749.49 ± 2.4% | not timed | not timed | 5662.42 ± 0.3% | 50.44 ± 0.1% | not timed | not timed | 13009.69 ± 2.6% | | 0.98 | 2.25 | 252.74 |
| imported/leipzig/math-symbols | 69 | 1968.99 ± 0.2% | not timed | not timed | 613.64 ± 0.1% | 36.61 ± 0.5% | not timed | not timed | 1973.21 ± 0.4% | | 1.00 | 3.21 | 53.78 |
| imported/leipzig/bounded-strings-ending-z | 0 | 593.59 ± 0.2% | not timed | not timed | 616.27 ± 0.1% | 22.22 ± 0.1% | not timed | not timed | 591.89 ± 0.5% | | 1.00 | 0.96 | 26.71 |
| imported/lh3lh3-reb/uri | 17549 | 631.57 ± 0.1% | not timed | not timed | 1067.17 ± 0.1% | 27.93 ± 2.2% | not timed | not timed | 632.72 ± 0.2% | | 1.00 | 0.59 | 22.61 |
| imported/lh3lh3-reb/email | 15057 | 666.58 ± 0.1% | not timed | not timed | 1173.53 ± 0.2% | 30.83 ± 2.4% | not timed | not timed | 668.27 ± 0.2% | | 1.00 | 0.57 | 21.62 |
| imported/lh3lh3-reb/date | 668 | 864.98 ± 0.2% | not timed | not timed | 1042.93 ± 0.2% | 51.64 ± 3.9% | not timed | not timed | 864.17 ± 0.2% | | 1.00 | 0.83 | 16.75 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 641.04 ± 0.3% | not timed | not timed | 422.62 ± 0.2% | 15.67 ± 1.2% | not timed | not timed | 642.50 ± 0.2% | | 1.00 | 1.52 | 40.92 |
| imported/mariomka/email | 92 | 705.32 ± 0.1% | not timed | not timed | 29243.55 ± 1.7% | 32.85 ± 0.1% | not timed | not timed | 706.22 ± 0.2% | | 1.00 | 0.0241 | 21.47 |
| imported/mariomka/uri | 5301 | 608.34 ± 0.1% | not timed | not timed | 6079.94 ± 0.4% | 32.79 ± 0.5% | not timed | not timed | 605.83 ± 0.1% | | 1.00 | 0.10 | 18.55 |
| imported/mariomka/ip | 5 | 2155.43 ± 2.0% | not timed | not timed | 2965.98 ± 0.2% | 21.06 ± 0.3% | not timed | not timed | 2154.04 ± 2.2% | | 1.00 | 0.73 | 102.35 |
| imported/rsc/no-exponential | 0 | 563.37 ± 0.1% | not timed | not timed | 317.31 ± 0.1% | 23.86 ± 0.4% | not timed | not timed | 564.22 ± 0.1% | | 1.00 | 1.78 | 23.61 |
| imported/rsc/literal | 1 | 742.90 ± 2.4% | not timed | not timed | 1547.46 ± 8.2% | 188.11 ± 17.7% | not timed | not timed | 738.74 ± 5.4% | | 1.01 | 0.48 | 3.95 |
| imported/rsc/not-literal | 2 | 708.96 ± 0.2% | not timed | not timed | 726.66 ± 0.4% | 46.43 ± 9.6% | not timed | not timed | 707.50 ± 2.2% | | 1.00 | 0.98 | 15.27 |
| imported/rsc/match-class | 1 | 1310.67 ± 0.1% | not timed | not timed | 1615.38 ± 0.2% | 58.63 ± 13.2% | not timed | not timed | 1302.46 ± 2.5% | | 1.01 | 0.81 | 22.36 |
| imported/rsc/match-class-in-range | 1 | 1310.37 ± 0.3% | not timed | not timed | 2327.43 ± 6.1% | 60.06 ± 6.3% | not timed | not timed | 1314.02 ± 2.3% | | 1.00 | 0.56 | 21.82 |
| imported/rsc/match-class-unicode | 1 | 525.58 ± 0.2% | not timed | not timed | 514.49 ± 0.0% | 73.00 ± 0.2% | not timed | not timed | 524.53 ± 0.1% | | 1.00 | 1.02 | 7.20 |
| imported/rsc/anchored-literal-short-non-match | 0 | 534.78 ± 0.4% | not timed | not timed | 952.97 ± 0.1% | 227.42 ± 0.6% | not timed | not timed | 533.36 ± 0.5% | | 1.00 | 0.56 | 2.35 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7963.21 ± 0.3% | not timed | not timed | 14367.79 ± 0.1% | 3410.74 ± 0.7% | not timed | not timed | 7973.01 ± 0.2% | | 1.00 | 0.55 | 2.33 |
| imported/rsc/anchored-literal-short-match | 4 | 420.88 ± 2.4% | not timed | not timed | 483.64 ± 0.2% | 85.25 ± 7.4% | not timed | not timed | 422.24 ± 7.0% | | 1.00 | 0.87 | 4.94 |
| imported/rsc/anchored-literal-long-match | 4 | 3002.95 ± 2.3% | not timed | not timed | 7395.30 ± 0.4% | 1216.07 ± 7.4% | not timed | not timed | 3021.91 ± 2.1% | | 0.99 | 0.41 | 2.47 |
| imported/rsc/one-pass-short | 17 | 311.40 ± 1.8% | not timed | not timed | 217.78 ± 0.2% | 31.79 ± 12.9% | not timed | not timed | 310.37 ± 10.9% | | 1.00 | 1.43 | 9.79 |
| imported/rsc/one-pass-short-not | 17 | 219.07 ± 6.0% | not timed | not timed | 224.15 ± 0.1% | 30.88 ± 10.6% | not timed | not timed | 218.90 ± 1.9% | | 1.00 | 0.98 | 7.10 |
| imported/rsc/one-pass-long-prefix | 26 | 235.77 ± 9.7% | not timed | not timed | 283.64 ± 0.4% | 97.33 ± 13.9% | not timed | not timed | 240.08 ± 1.8% | | 0.98 | 0.83 | 2.42 |
| imported/rsc/one-pass-long-prefix-not | 26 | 314.72 ± 2.8% | not timed | not timed | 278.16 ± 1.1% | 66.73 ± 17.3% | not timed | not timed | 312.15 ± 1.5% | | 1.01 | 1.13 | 4.72 |
| imported/rsc/long-needle1 | 31 | 21947.41 ± 0.3% | not timed | not timed | 20125.88 ± 0.1% | 3.77 ± 0.3% | not timed | not timed | 21956.84 ± 0.2% | | 1.00 | 1.09 | 5829.01 |
| imported/rsc/long-needle2 | 31 | 22113.20 ± 0.2% | not timed | not timed | 216.40 ± 0.2% | 3.77 ± 0.2% | not timed | not timed | 22122.65 ± 0.1% | | 1.00 | 102.19 | 5859.58 |
| imported/rsc/easy0-32 | 26 | 1064.10 ± 0.6% | not timed | not timed | 1598.76 ± 3.0% | 147.43 ± 20.7% | not timed | not timed | 1058.78 ± 3.0% | | 1.01 | 0.67 | 7.22 |
| imported/rsc/easy0-1k | 26 | 14952.30 ± 0.4% | not timed | not timed | 12623.89 ± 1.3% | 2301.35 ± 13.7% | not timed | not timed | 14987.09 ± 2.2% | | 1.00 | 1.18 | 6.50 |
| imported/rsc/easy0-32k | 26 | 22940.36 ± 0.4% | not timed | not timed | 20358.21 ± 0.0% | 18810.83 ± 11.2% | not timed | not timed | 22962.51 ± 10.2% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21436.43 ± 3.9% | not timed | not timed | 19625.91 ± 2.6% | 34752.40 ± 2.3% | not timed | not timed | 21209.19 ± 3.0% | | 1.01 | 1.09 | 0.62 |
| imported/rsc/easy1-32 | 19 | 359.70 ± 2.1% | not timed | not timed | 642.19 ± 0.3% | 133.99 ± 16.0% | not timed | not timed | 360.86 ± 5.2% | | 1.00 | 0.56 | 2.68 |
| imported/rsc/easy1-1k | 19 | 582.82 ± 2.8% | not timed | not timed | 12973.23 ± 0.2% | 2496.28 ± 15.1% | not timed | not timed | 583.10 ± 0.2% | | 1.00 | 0.0449 | 0.23 |
| imported/rsc/easy1-32k | 19 | 601.23 ± 0.3% | not timed | not timed | 409489.61 ± 0.2% | 20414.90 ± 0.2% | not timed | not timed | 600.05 ± 0.3% | | 1.00 | 0.0015 | 0.0295 |
| imported/rsc/easy1-1mb | 19 | 604.45 ± 0.8% | not timed | not timed | 12999873.57 ± 0.3% | 36752.92 ± 8.0% | not timed | not timed | 602.01 ± 1.3% | | 1.00 | 0.0000 | 0.0164 |
| imported/rsc/medium-32 | 27 | 425.14 ± 2.3% | not timed | not timed | 649.69 ± 0.3% | 70.23 ± 10.8% | not timed | not timed | 426.43 ± 0.5% | | 1.00 | 0.65 | 6.05 |
| imported/rsc/medium-1k | 27 | 6753.65 ± 0.2% | not timed | not timed | 11462.75 ± 0.1% | 72.15 ± 0.2% | not timed | not timed | 6762.72 ± 0.2% | | 1.00 | 0.59 | 93.61 |
| imported/rsc/medium-32k | 27 | 21579.97 ± 0.1% | not timed | not timed | 354191.07 ± 0.5% | 49.06 ± 0.1% | not timed | not timed | 21589.00 ± 0.0% | | 1.00 | 0.0609 | 439.86 |
| imported/rsc/medium-1mb | 27 | 20567.71 ± 1.7% | not timed | not timed | 11384517.17 ± 0.5% | 48.95 ± 0.3% | not timed | not timed | 20601.47 ± 2.4% | | 1.00 | 0.0018 | 420.18 |
| imported/rsc/hard-32 | 58 | 254.84 ± 2.5% | not timed | not timed | 366.97 ± 0.0% | 49.81 ± 9.0% | not timed | not timed | 255.97 ± 0.3% | | 1.00 | 0.69 | 5.12 |
| imported/rsc/hard-1k | 27 | 577.79 ± 0.5% | not timed | not timed | 11735.58 ± 0.2% | 36.66 ± 10.1% | not timed | not timed | 575.37 ± 0.4% | | 1.00 | 0.0492 | 15.76 |
| imported/rsc/hard-32k | 27 | 601.99 ± 0.5% | not timed | not timed | 360002.04 ± 0.2% | 29.35 ± 0.1% | not timed | not timed | 599.00 ± 0.4% | | 1.00 | 0.0017 | 20.51 |
| imported/rsc/hard-1mb | 51 | 601.23 ± 0.3% | not timed | not timed | 7314225.19 ± 0.3% | 29.39 ± 0.3% | not timed | not timed | 598.54 ± 0.5% | | 1.00 | 0.0001 | 20.46 |
| imported/rsc/reallyhard0-32 | 58 | 253.52 ± 2.5% | not timed | not timed | 223.68 ± 0.1% | 49.58 ± 8.5% | not timed | not timed | 254.39 ± 0.2% | | 1.00 | 1.13 | 5.11 |
| imported/rsc/reallyhard0-1k | 27 | 577.42 ± 0.2% | not timed | not timed | 585.95 ± 0.1% | 40.82 ± 0.1% | not timed | not timed | 577.97 ± 0.4% | | 1.00 | 0.99 | 14.15 |
| imported/rsc/reallyhard0-32k | 27 | 602.41 ± 0.4% | not timed | not timed | 616.85 ± 0.1% | 29.39 ± 0.2% | not timed | not timed | 603.39 ± 0.2% | | 1.00 | 0.98 | 20.50 |
| imported/rsc/reallyhard0-1mb | 51 | 594.22 ± 0.1% | not timed | not timed | 613.47 ± 0.1% | 29.33 ± 0.1% | not timed | not timed | 594.81 ± 0.6% | | 1.00 | 0.97 | 20.26 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.19 ± 1.7% | not timed | not timed | 194.01 ± 0.6% | 60.91 ± 17.0% | not timed | not timed | 274.41 ± 0.1% | | 1.00 | 1.41 | 4.50 |
| imported/rsc/reallyreallyhard0-1k | 16 | 860.30 ± 4.0% | not timed | not timed | 5981.09 ± 0.3% | 33.91 ± 2.3% | not timed | not timed | 875.29 ± 4.2% | | 0.98 | 0.14 | 25.37 |
| imported/rsc/reallyreallyhard0-32k | 16 | 660.68 ± 5.9% | not timed | not timed | 19258.53 ± 0.0% | 24.90 ± 3.0% | not timed | not timed | 650.11 ± 10.1% | | 1.02 | 0.0343 | 26.53 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 592.94 ± 0.3% | not timed | not timed | 19357.00 ± 0.9% | 24.74 ± 0.4% | not timed | not timed | 589.56 ± 1.1% | | 1.01 | 0.0306 | 23.97 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 268.95 ± 3.4% | not timed | not timed | 213.66 ± 0.5% | 60.49 ± 13.3% | not timed | not timed | 268.55 ± 0.1% | | 1.00 | 1.26 | 4.45 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 840.56 ± 1.3% | not timed | not timed | 6208.73 ± 0.1% | 34.32 ± 0.7% | not timed | not timed | 843.08 ± 0.7% | | 1.00 | 0.14 | 24.49 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 623.46 ± 4.7% | not timed | not timed | 19099.88 ± 0.1% | 24.84 ± 1.3% | not timed | not timed | 627.91 ± 4.4% | | 0.99 | 0.0326 | 25.10 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 589.00 ± 0.9% | not timed | not timed | 19789.97 ± 1.7% | 25.15 ± 0.0% | not timed | not timed | 594.62 ± 1.0% | | 0.99 | 0.0298 | 23.42 |
| imported/sherlock/name-sherlock | 776 | 19469.10 ± 6.8% | not timed | not timed | 18216.68 ± 1.0% | 10106.75 ± 17.7% | not timed | not timed | 19478.98 ± 2.9% | | 1.00 | 1.07 | 1.93 |
| imported/sherlock/name-holmes | 2766 | 15026.83 ± 1.9% | not timed | not timed | 15329.80 ± 0.7% | 3204.34 ± 14.2% | not timed | not timed | 15086.87 ± 1.7% | | 1.00 | 0.98 | 4.69 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19520.72 ± 2.8% | not timed | not timed | 18201.10 ± 0.7% | 8046.59 ± 51.4% | not timed | not timed | 19505.51 ± 2.9% | | 1.00 | 1.07 | 2.43 |
| imported/sherlock/name-sherlock-casei | 816 | 15495.99 ± 0.7% | not timed | not timed | 4016.64 ± 0.1% | 32.62 ± 0.4% | not timed | not timed | 15478.88 ± 0.4% | | 1.00 | 3.86 | 475.11 |
| imported/sherlock/name-holmes-casei | 2802 | 9332.48 ± 7.5% | not timed | not timed | 3318.29 ± 0.1% | 37.62 ± 0.2% | not timed | not timed | 9380.95 ± 5.9% | | 0.99 | 2.81 | 248.06 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12948.24 ± 2.0% | not timed | not timed | 3946.18 ± 0.1% | 32.57 ± 0.4% | not timed | not timed | 12967.80 ± 0.7% | | 1.00 | 3.28 | 397.58 |
| imported/sherlock/name-whitespace | 1461 | 14871.38 ± 1.7% | not timed | not timed | 14404.58 ± 0.4% | 6544.00 ± 18.0% | not timed | not timed | 14920.01 ± 1.8% | | 1.00 | 1.03 | 2.27 |
| imported/sherlock/name-alt1 | 1142 | 11417.64 ± 0.2% | not timed | not timed | 16186.18 ± 0.9% | 4131.54 ± 25.7% | not timed | not timed | 11429.44 ± 2.5% | | 1.00 | 0.71 | 2.76 |
| imported/sherlock/name-alt2 | 3542 | 8573.26 ± 0.6% | not timed | not timed | 3828.82 ± 0.1% | 31.33 ± 0.4% | not timed | not timed | 8583.93 ± 0.6% | | 1.00 | 2.24 | 273.64 |
| imported/sherlock/name-alt3 | 4507 | 5425.17 ± 0.3% | not timed | not timed | 3631.55 ± 0.0% | 9.78 ± 3.5% | not timed | not timed | 5432.93 ± 0.3% | | 1.00 | 1.49 | 554.88 |
| imported/sherlock/name-alt3-casei | 4593 | 1515.49 ± 2.8% | not timed | not timed | 285.57 ± 0.2% | 6.42 ± 0.1% | not timed | not timed | 1504.28 ± 2.0% | | 1.01 | 5.31 | 236.08 |
| imported/sherlock/name-alt4 | 3686 | 6158.94 ± 0.2% | not timed | not timed | 3788.91 ± 0.1% | 31.40 ± 0.1% | not timed | not timed | 6182.12 ± 0.4% | | 1.00 | 1.63 | 196.12 |
| imported/sherlock/name-alt4-casei | 4254 | 2752.71 ± 2.7% | not timed | not timed | 2595.41 ± 0.3% | 19.90 ± 0.2% | not timed | not timed | 2756.27 ± 1.3% | | 1.00 | 1.06 | 138.32 |
| imported/sherlock/name-alt5 | 4028 | 6217.08 ± 0.2% | not timed | not timed | 3742.29 ± 0.1% | 21.77 ± 0.1% | not timed | not timed | 6217.98 ± 0.2% | | 1.00 | 1.66 | 285.60 |
| imported/sherlock/name-alt5-casei | 4104 | 3456.78 ± 2.3% | not timed | not timed | 2221.13 ± 0.5% | 14.33 ± 0.0% | not timed | not timed | 3462.14 ± 1.1% | | 1.00 | 1.56 | 241.31 |
| imported/sherlock/no-match-uncommon | 0 | 21217.23 ± 0.3% | not timed | not timed | 19301.26 ± 0.5% | 35249.06 ± 0.7% | not timed | not timed | 21245.00 ± 0.4% | | 1.00 | 1.10 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21033.47 ± 1.0% | not timed | not timed | 19272.50 ± 0.6% | 1279.30 ± 1.0% | not timed | not timed | 21039.95 ± 0.6% | | 1.00 | 1.09 | 16.44 |
| imported/sherlock/no-match-really-common | 0 | 16141.80 ± 1.9% | not timed | not timed | 18512.41 ± 0.9% | 1267.09 ± 0.3% | not timed | not timed | 16174.70 ± 1.7% | | 1.00 | 0.87 | 12.74 |
| imported/sherlock/the-lower | 21654 | 2316.16 ± 1.0% | not timed | not timed | 2327.28 ± 0.4% | 230.59 ± 40.6% | not timed | not timed | 2327.13 ± 1.8% | | 1.00 | 1.00 | 10.04 |
| imported/sherlock/the-upper | 2223 | 11635.71 ± 10.9% | not timed | not timed | 13429.99 ± 0.9% | 2829.51 ± 19.5% | not timed | not timed | 12667.49 ± 9.4% | | 0.92 | 0.87 | 4.11 |
| imported/sherlock/the-casei | 23961 | 2014.55 ± 0.5% | not timed | not timed | 1312.89 ± 0.3% | 34.88 ± 0.5% | not timed | not timed | 2014.14 ± 0.3% | | 1.00 | 1.53 | 57.76 |
| imported/sherlock/everything-greedy | 581881 | 270.96 ± 0.6% | not timed | not timed | 166.12 ± 0.1% | 28.85 ± 20.8% | not timed | not timed | 271.24 ± 1.0% | | 1.00 | 1.63 | 9.39 |
| imported/sherlock/everything-greedy-nl | 594933 | 461.87 ± 0.1% | not timed | not timed | 212.79 ± 0.9% | 32.94 ± 0.3% | not timed | not timed | 462.95 ± 0.1% | | 1.00 | 2.17 | 14.02 |
| imported/sherlock/letters | 447175 | 54.46 ± 7.2% | not timed | not timed | 33.12 ± 0.2% | 5.33 ± 31.4% | not timed | not timed | 54.44 ± 0.4% | | 1.00 | 1.64 | 10.22 |
| imported/sherlock/letters-upper | 14180 | 433.91 ± 1.4% | not timed | not timed | 372.17 ± 0.0% | 29.69 ± 19.5% | not timed | not timed | 435.18 ± 0.4% | | 1.00 | 1.17 | 14.62 |
| imported/sherlock/letters-lower | 432995 | 55.51 ± 0.8% | not timed | not timed | 33.76 ± 0.1% | 5.27 ± 31.0% | not timed | not timed | 55.50 ± 0.9% | | 1.00 | 1.64 | 10.54 |
| imported/sherlock/words | 447639 | 106.70 ± 1.2% | not timed | not timed | 82.73 ± 0.2% | 13.65 ± 3.4% | not timed | not timed | 107.12 ± 0.8% | | 1.00 | 1.29 | 7.82 |
| imported/sherlock/before-holmes | 4073 | 599.18 ± 0.7% | not timed | not timed | 8440.68 ± 0.4% | 24.07 ± 1.4% | not timed | not timed | 597.50 ± 0.4% | | 1.00 | 0.0710 | 24.90 |
| imported/sherlock/before-after-holmes | 2593 | 596.05 ± 0.5% | not timed | not timed | 9464.80 ± 0.9% | 23.75 ± 1.3% | not timed | not timed | 597.72 ± 0.5% | | 1.00 | 0.0630 | 25.10 |
| imported/sherlock/holmes-cochar-watson | 150 | 5221.32 ± 0.2% | not timed | not timed | 3423.77 ± 0.1% | 31.08 ± 0.2% | not timed | not timed | 5235.25 ± 0.3% | | 1.00 | 1.53 | 167.97 |
| imported/sherlock/holmes-coword-watson | 14309 | 1263.57 ± 0.5% | not timed | not timed | 1123.51 ± 0.2% | 6.71 ± 0.2% | not timed | not timed | 1259.01 ± 0.7% | | 1.00 | 1.12 | 188.37 |
| imported/sherlock/quotes | 14437 | 1413.63 ± 0.9% | not timed | not timed | 1741.93 ± 1.0% | 35.10 ± 0.2% | not timed | not timed | 1400.59 ± 0.2% | | 1.01 | 0.81 | 40.27 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 600.33 ± 0.5% | not timed | not timed | 15840.33 ± 0.1% | 36.61 ± 0.4% | not timed | not timed | 601.42 ± 0.5% | | 1.00 | 0.0379 | 16.40 |
| imported/sherlock/word-ending-n | 35297 | 468.14 ± 1.0% | not timed | not timed | 409.31 ± 0.2% | 23.50 ± 20.5% | not timed | not timed | 467.53 ± 0.2% | | 1.00 | 1.14 | 19.92 |
| imported/sherlock/repeated-class-negation | 2130 | 14393.23 ± 1.4% | not timed | not timed | 10856.01 ± 1.0% | 11.57 ± 0.2% | not timed | not timed | 14383.75 ± 0.8% | | 1.00 | 1.33 | 1244.25 |
| imported/sherlock/ing-suffix | 20547 | 554.23 ± 0.3% | not timed | not timed | 516.78 ± 0.1% | 28.86 ± 0.1% | not timed | not timed | 553.59 ± 0.3% | | 1.00 | 1.07 | 19.20 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 594.26 ± 0.3% | not timed | not timed | 2085.96 ± 0.6% | 20.56 ± 0.2% | not timed | not timed | 593.56 ± 0.3% | | 1.00 | 0.28 | 28.91 |
| opt/accelerate/whole-line | 239963 | 458.35 ± 0.1% | not timed | not timed | 373.80 ± 0.5% | 92.59 ± 13.7% | not timed | not timed | 458.55 ± 0.4% | | 1.00 | 1.23 | 4.95 |
| opt/accelerate/non-dna | 16745 | 413.90 ± 0.9% | not timed | not timed | 398.41 ± 0.1% | 29.68 ± 50.1% | not timed | not timed | 412.22 ± 0.2% | | 1.00 | 1.04 | 13.94 |
| opt/backtrack/words-english | 40536 | 137.15 ± 1.4% | not timed | not timed | 94.60 ± 0.2% | 19.98 ± 7.7% | not timed | not timed | 137.19 ± 2.0% | | 1.00 | 1.45 | 6.86 |
| opt/fixed-length/too-small-ascii | 0 | 312.07 ± 0.3% | not timed | not timed | 712.24 ± 0.4% | 79.81 ± 0.8% | not timed | not timed | 316.36 ± 0.2% | | 0.99 | 0.44 | 3.91 |
| opt/fixed-length/too-big-ascii | 0 | 646.32 ± 0.8% | not timed | not timed | 5803.35 ± 1.1% | 121.61 ± 2.8% | not timed | not timed | 653.40 ± 1.1% | | 0.99 | 0.11 | 5.31 |
| opt/fixed-length/go33484-1 | 0 | 45.31 ± 0.4% | not timed | not timed | 1098451.27 ± 0.7% | 61289.67 ± 0.3% | not timed | not timed | 45.20 ± 0.0% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5528.21 ± 0.5% | not timed | not timed | 1120303.77 ± 0.5% | 32222.63 ± 1.0% | not timed | not timed | 5520.04 ± 0.1% | | 1.00 | 0.0049 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1816.88 ± 1.6% | not timed | not timed | 111175.97 ± 0.7% | 764.52 ± 0.3% | not timed | not timed | 1782.86 ± 1.6% | | 1.02 | 0.0163 | 2.38 |
| opt/literal-alt/one-pattern | 1 | 555.35 ± 6.6% | not timed | not timed | 539.56 ± 0.1% | 0.40 ± 0.7% | not timed | not timed | 556.34 ± 0.1% | | 1.00 | 1.03 | 1384.27 |
| opt/onepass/fn-predicate | 916 | 368.84 ± 0.7% | not timed | not timed | 333.04 ± 0.1% | 198.02 ± 14.0% | not timed | not timed | 368.29 ± 1.2% | | 1.00 | 1.11 | 1.86 |
| opt/onepass/first-three-words-english | 35128 | 148.63 ± 8.6% | not timed | not timed | 202.93 ± 0.2% | 80.89 ± 12.2% | not timed | not timed | 149.88 ± 5.4% | | 0.99 | 0.73 | 1.84 |
| opt/prefilter/literal-english | 1 | 20086.97 ± 0.7% | not timed | not timed | 19386.61 ± 0.3% | 17104.25 ± 0.6% | not timed | not timed | 20146.67 ± 0.8% | | 1.00 | 1.04 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14299.60 ± 0.6% | not timed | not timed | 4314.29 ± 0.1% | 32.79 ± 0.2% | not timed | not timed | 14300.24 ± 0.4% | | 1.00 | 3.31 | 436.03 |
| opt/prefilter/literal-russian | 1 | 21354.61 ± 0.2% | not timed | not timed | 19853.25 ± 0.4% | 3327.10 ± 0.1% | not timed | not timed | 21393.09 ± 0.5% | | 1.00 | 1.08 | 6.42 |
| opt/prefilter/literal-casei-russian | 1 | 8576.34 ± 0.5% | not timed | not timed | 3895.08 ± 0.0% | 30.92 ± 0.3% | not timed | not timed | 8581.82 ± 0.3% | | 1.00 | 2.20 | 277.36 |
| opt/prefilter/rust-functions | 948 | 6778.92 ± 0.4% | not timed | not timed | 8811.93 ± 1.5% | 1854.34 ± 0.7% | not timed | not timed | 6770.56 ± 1.4% | | 1.00 | 0.77 | 3.66 |
| opt/reverse-anchored/word-end | 1 | 5573.00 ± 0.3% | not timed | not timed | 21593192.06 ± 0.2% | 50.03 ± 0.2% | not timed | not timed | 5576.89 ± 0.6% | | 1.00 | 0.0003 | 111.40 |
| opt/reverse-inner/holmes | 2593 | 596.78 ± 0.1% | not timed | not timed | 9451.08 ± 0.3% | 24.10 ± 1.6% | not timed | not timed | 597.41 ± 0.4% | | 1.00 | 0.0631 | 24.76 |
| opt/reverse-inner/email | 47 | 1044.91 ± 0.1% | not timed | not timed | 43281.84 ± 3.2% | 32.39 ± 0.3% | not timed | not timed | 1043.70 ± 0.1% | | 1.00 | 0.0241 | 32.26 |
| opt/reverse-inner/factored-prefix | 3542 | 591.52 ± 0.5% | not timed | not timed | 597.35 ± 0.1% | 12.01 ± 0.2% | not timed | not timed | 591.31 ± 0.4% | | 1.00 | 0.99 | 49.24 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5511.46 ± 0.0% | not timed | not timed | 612.65 ± 0.1% | 75.21 ± 0.2% | not timed | not timed | 5520.91 ± 0.0% | | 1.00 | 9.00 | 73.28 |
| opt/reverse-inner/no-quadratic-forward | 0 | 690.62 ± 2.4% | not timed | not timed | 288.40 ± 0.5% | 24.84 ± 0.1% | not timed | not timed | 687.46 ± 3.9% | | 1.00 | 2.39 | 27.80 |
| opt/reverse-suffix/holmes | 4073 | 600.12 ± 0.4% | not timed | not timed | 8268.65 ± 0.5% | 23.96 ± 1.6% | not timed | not timed | 598.16 ± 0.1% | | 1.00 | 0.0726 | 25.05 |
| opt/reverse-suffix/no-quadratic | 0 | 5520.23 ± 0.2% | not timed | not timed | 613.04 ± 0.2% | 75.18 ± 0.2% | not timed | not timed | 5506.96 ± 0.0% | | 1.00 | 9.00 | 73.43 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.39 ± 8.7% | not timed | not timed | 132.13 ± 0.1% | 13.55 ± 16.6% | not timed | not timed | 120.99 ± 2.2% | | 1.00 | 0.91 | 8.88 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 120.96 ± 1.7% | not timed | not timed | 131.51 ± 0.3% | 13.06 ± 13.5% | not timed | not timed | 120.33 ± 3.2% | | 1.01 | 0.92 | 9.26 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.3% | not timed | not timed | 0.55 ± 0.2% | 112.91 ± 0.3% | not timed | not timed | 0.28 ± 0.4% | | 1.00 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.79 ± 0.3% | not timed | not timed | 289.75 ± 0.2% | 103.80 ± 7.0% | not timed | not timed | 309.01 ± 3.4% | | 1.03 | 1.09 | 3.05 |
| reported/i13-subset-regex/original-ascii | 4094 | 10997.67 ± 1.5% | not timed | not timed | 4436.21 ± 0.8% | 11.51 ± 0.2% | not timed | not timed | 10950.09 ± 1.5% | | 1.00 | 2.48 | 955.73 |
| reported/i13-subset-regex/original-unicode | 4094 | 10824.93 ± 1.3% | not timed | not timed | 250.35 ± 3.4% | 11.50 ± 0.1% | not timed | not timed | 11016.54 ± 1.6% | | 0.98 | 43.24 | 941.00 |
| reported/i13-subset-regex/big-ascii | 1955 | 10619.35 ± 1.1% | not timed | not timed | 68.18 ± 3.7% | 9.84 ± 0.2% | not timed | not timed | 10677.23 ± 0.8% | | 0.99 | 155.76 | 1079.14 |
| reported/i13-subset-regex/big-unicode | 1955 | 10527.55 ± 1.4% | not timed | not timed | 12.22 ± 54.9% | 9.86 ± 0.2% | not timed | not timed | 10717.45 ± 0.9% | | 0.98 | 861.82 | 1068.23 |
| reported/i13-subset-regex/huge-ascii | 55 | 10077.39 ± 1.0% | not timed | not timed | 11.00 ± 0.0% | 8.76 ± 0.2% | not timed | not timed | 10056.65 ± 2.3% | | 1.00 | 916.38 | 1150.37 |
| reported/i13-subset-regex/huge-unicode | 55 | 9901.29 ± 2.7% | not timed | not timed | 10.99 ± 0.4% | 8.76 ± 0.1% | not timed | not timed | 9863.36 ± 2.0% | | 1.00 | 900.60 | 1130.70 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.01 ± 0.0% | 8.75 ± 0.1% | not timed | not timed | 3.54 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.0% | not timed | not timed | 11.00 ± 0.3% | 8.74 ± 1.2% | not timed | not timed | 5.02 ± 0.0% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 467.91 ± 0.3% | not timed | not timed | 104.80 ± 0.1% | 6.63 ± 0.2% | not timed | not timed | 469.70 ± 0.2% | | 1.00 | 4.46 | 70.60 |
| reported/i787-keywords/opt-ascii | 5674 | 468.96 ± 0.3% | not timed | not timed | 276.49 ± 0.2% | 10.29 ± 0.1% | not timed | not timed | 471.42 ± 0.1% | | 0.99 | 1.70 | 45.55 |
| slow/quadratic-regex-1x | 100 | 6.96 ± 0.2% | not timed | not timed | 4.95 ± 0.4% | 0.05 ± 0.1% | not timed | not timed | 6.96 ± 0.3% | | 1.00 | 1.41 | 141.46 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 0.2% | not timed | not timed | 2.77 ± 0.2% | 0.01 ± 0.1% | not timed | not timed | 3.40 ± 0.3% | | 1.00 | 1.23 | 266.30 |
| slow/quadratic-haystack-1x | 100 | 21.28 ± 5.7% | not timed | not timed | 10.02 ± 0.1% | 1.01 ± 16.2% | not timed | not timed | 21.25 ± 1.9% | | 1.00 | 2.12 | 20.99 |
| slow/quadratic-haystack-2x | 200 | 17.51 ± 2.0% | not timed | not timed | 5.55 ± 0.1% | 0.54 ± 12.1% | not timed | not timed | 17.43 ± 0.2% | | 1.00 | 3.15 | 32.15 |
| unicode/codepoints/any-one | 1112064 | 286.22 ± 0.5% | not timed | not timed | 175.79 ± 0.5% | 18.36 ± 2.3% | not timed | not timed | 287.08 ± 0.2% | | 1.00 | 1.63 | 15.59 |
| unicode/codepoints/any-all | 4382592 | 289.10 ± 1.2% | not timed | not timed | 247.10 ± 0.2% | 117.26 ± 0.2% | not timed | not timed | 288.99 ± 0.4% | | 1.00 | 1.17 | 2.47 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.75 ± 0.7% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 611.05 ± 0.2% | not timed | not timed | 616.26 ± 0.2% | 135.25 ± 0.1% | not timed | not timed | 610.83 ± 0.1% | | 1.00 | 0.99 | 4.52 |
| unicode/overlapping-words/ascii | 6156 | 31.71 ± 0.6% | not timed | not timed | 38.87 ± 0.1% | 3.93 ± 0.7% | not timed | not timed | 31.85 ± 0.2% | | 1.00 | 0.82 | 8.06 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.4% | not timed | not timed | 4.12 ± 0.2% | 2.33 ± 0.5% | not timed | not timed | 1.35 ± 0.2% | | 1.00 | 0.33 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 9.6% | not timed | not timed | 3.86 ± 0.1% | 6.28 ± 8.8% | not timed | not timed | 1.22 ± 0.2% | | 1.00 | 0.31 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 117.18 ± 7.2% | not timed | not timed | 82.92 ± 0.2% | 11.80 ± 23.8% | not timed | not timed | 117.38 ± 0.9% | | 1.00 | 1.41 | 9.93 |
| unicode/word/boundary-long-english | 3466 | 597.61 ± 0.9% | not timed | not timed | 602.11 ± 0.2% | 32.68 ± 0.5% | not timed | not timed | 517.07 ± 1.7% | | 1.16 | 0.99 | 18.29 |
| unicode/word/around-holmes-english | 27 | 604.01 ± 0.5% | not timed | not timed | 18969.09 ± 0.5% | 22.12 ± 1.9% | not timed | not timed | 601.86 ± 0.3% | | 1.00 | 0.0318 | 27.31 |
| wild/bibleref/long | 874 | 563.21 ± 0.2% | not timed | not timed | 583.13 ± 0.2% | 6.77 ± 0.1% | not timed | not timed | 563.49 ± 0.2% | | 1.00 | 0.97 | 83.16 |
| wild/bibleref/short | 30 | 23.71 ± 3.0% | not timed | not timed | 30.39 ± 0.8% | 14.03 ± 10.0% | not timed | not timed | 24.25 ± 2.8% | | 0.98 | 0.78 | 1.69 |
| wild/bibleref/line | 874 | 357.91 ± 0.3% | not timed | not timed | 212.18 ± 0.2% | 9.22 ± 0.3% | not timed | not timed | 359.01 ± 0.3% | | 1.00 | 1.69 | 38.80 |
| wild/caddy/caddy | 6 | 414.02 ± 9.8% | not timed | not timed | 250.74 ± 0.4% | 68.20 ± 14.4% | not timed | not timed | 417.07 ± 0.5% | | 0.99 | 1.65 | 6.07 |
| wild/dot-star-capture/rust-src-tools | 6 | 1058.03 ± 0.4% | not timed | not timed | 347.86 ± 0.2% | 13.50 ± 0.2% | not timed | not timed | 1059.49 ± 0.3% | | 1.00 | 3.04 | 78.39 |
| wild/ruff/noqa | 84 | 403.77 ± 0.1% | not timed | not timed | 460.61 ± 0.2% | 19.54 ± 2.2% | not timed | not timed | 403.47 ± 0.6% | | 1.00 | 0.88 | 20.66 |
| wild/ruff/unnecessary-coding-comment | 16 | 488.36 ± 0.7% | not timed | not timed | 702.80 ± 0.1% | 135.86 ± 10.9% | not timed | not timed | 488.02 ± 0.5% | | 1.00 | 0.69 | 3.59 |
| wild/ruff/string-quote-prefix | 2972 | 406.67 ± 0.6% | not timed | not timed | 407.43 ± 0.1% | 315.08 ± 25.3% | not timed | not timed | 407.38 ± 0.6% | | 1.00 | 1.00 | 1.29 |
| wild/ruff/space-around-operator | 1224378 | 217.48 ± 1.9% | not timed | not timed | 186.50 ± 0.1% | 18.40 ± 1.8% | not timed | not timed | 217.85 ± 1.8% | | 1.00 | 1.17 | 11.82 |
| wild/ruff/shebang | 282 | 400.82 ± 0.6% | not timed | not timed | 329.70 ± 0.1% | 111.74 ± 9.1% | not timed | not timed | 400.79 ± 0.5% | | 1.00 | 1.22 | 3.59 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13700.11 ± 0.5% | not timed | not timed | 13536.06 ± 0.5% | 6897.87 ± 0.7% | not timed | not timed | 13685.01 ± 0.5% | | 1.00 | 1.01 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12742.63 ± 0.6% | not timed | not timed | 13219.39 ± 0.2% | 6367.61 ± 0.6% | not timed | not timed | 12738.88 ± 0.5% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13020.75 ± 2.5% | not timed | not timed | 13308.37 ± 1.7% | 6563.95 ± 0.5% | not timed | not timed | 13012.16 ± 1.9% | | 1.00 | 0.98 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9437.90 ± 1.0% | not timed | not timed | 13329.44 ± 0.6% | 6631.61 ± 1.7% | not timed | not timed | 9470.29 ± 0.4% | | 1.00 | 0.71 | 1.42 |
| wild/url/search | 234965 | 121.14 ± 12.7% | not timed | not timed | 64.34 ± 0.7% | 2.22 ± 0.8% | not timed | not timed | 120.21 ± 13.7% | | 1.01 | 1.88 | 54.68 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 73.0% | not timed | not timed | 0.01 ± 0.6% | 0.01 ± 17.6% | not timed | not timed | 0.03 ± 2.1% | | 0.98 | 3.02 | 4.23 |
| dictionary/compile/english-15 | 1 | 0.34 ± 2.2% | not timed | not timed | 0.07 ± 4.1% | 0.10 ± 9.2% | not timed | not timed | 0.35 ± 31.2% | | 1.00 | 5.14 | 3.41 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 19.0% | not timed | not timed | 0.02 ± 1.4% | 33.91 ± 1.5% | not timed | not timed | 0.24 ± 4.3% | | 1.03 | 13.82 | 0.0074 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.77 ± 2.3% | not timed | not timed | 11.54 ± 0.4% | 51.18 ± 17.2% | not timed | not timed | 46.92 ± 2.4% | | 1.00 | 4.05 | 0.91 |
| reported/i787-keywords/compile | 1 | 35.10 ± 4.5% | not timed | not timed | 2.09 ± 0.5% | 16.61 ± 34.3% | not timed | not timed | 35.22 ± 5.1% | | 1.00 | 16.79 | 2.11 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 351.92 ± 11.6% | not timed | not timed | 119.30 ± 0.2% | 559.35 ± 21.6% | not timed | not timed | 351.75 ± 1.9% | | 1.00 | 2.95 | 0.63 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.51 ± 7.7% | not timed | not timed | 4.08 ± 1.3% | 42.86 ± 20.6% | not timed | not timed | 47.76 ± 4.1% | | 0.99 | 11.64 | 1.11 |
| unicode/compile/one-letter | 53 | 6.67 ± 14.8% | not timed | not timed | 4.52 ± 0.6% | 64.34 ± 4.5% | not timed | not timed | 6.72 ± 4.0% | | 0.99 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.01 ± 15.2% | not timed | not timed | 0.10 ± 0.7% | 63.12 ± 17.8% | not timed | not timed | 1.06 ± 6.4% | | 0.95 | 10.28 | 0.0160 |
| unicode/compile/fifty-letters-ascii | 1 | 216.36 ± 3.8% | not timed | not timed | 53.38 ± 0.3% | 192.81 ± 14.2% | not timed | not timed | 217.39 ± 12.1% | | 1.00 | 4.05 | 1.12 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 369.37 ± 22.1% | not timed | not timed | 47.00 ± 0.6% | 653.64 ± 29.2% | not timed | not timed | 376.78 ± 5.7% | | 0.98 | 7.86 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 600.13 ± 7.5% | not timed | not timed | 145.80 ± 0.2% | 665.65 ± 29.5% | not timed | not timed | 604.77 ± 4.8% | | 0.99 | 4.12 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 300.95 ± 5.1% | not timed | not timed | 50.94 ± 0.2% | 1234.72 ± 6.0% | not timed | not timed | 314.18 ± 4.9% | | 0.96 | 5.91 | 0.24 |
| wild/bibleref/compile | 3 | 5.85 ± 3.1% | not timed | not timed | 1.92 ± 0.3% | 30.30 ± 4.1% | not timed | not timed | 5.88 ± 3.0% | | 0.99 | 3.05 | 0.19 |
| wild/url/compile | 1 | 0.62 ± 14.7% | not timed | not timed | 0.14 ± 1.1% | 0.40 ± 18.7% | not timed | not timed | 0.63 ± 9.8% | | 0.99 | 4.34 | 1.53 |

