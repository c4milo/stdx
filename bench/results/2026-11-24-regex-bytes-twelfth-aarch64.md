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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391540000 |
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
| literal: a word | 217 | 19368.71 ± 2.3% | 5035.00 ± 0.5% | 27.65 ± 0.3% | 18184.24 ± 4.1% | 9252.89 ± 7.9% | 17.61 ± 2.3% | 84.36 ± 0.6% | 19345.68 ± 2.3% | 3.85 | 1.00 | 1.07 | 2.09 |
| literal: a word that is not there | 0 | 21353.49 ± 2.1% | 4912.67 ± 0.3% | 27.80 ± 0.1% | 19746.14 ± 2.9% | 28771.50 ± 1.6% | 17.42 ± 0.1% | 79.85 ± 0.7% | 21400.64 ± 4.5% | 4.35 | 1.00 | 1.08 | 0.74 |
| literal: one of four words | 661 | 6343.61 ± 0.4% | 1946.10 ± 0.1% | 14.19 ± 0.1% | 3939.88 ± 0.7% | 21.87 ± 0.1% | 5.31 ± 0.2% | 6.86 ± 0.4% | 6367.91 ± 0.6% | 3.26 | 1.00 | 1.61 | 290.09 |
| literal: a word in any case | 217 | 15059.06 ± 1.5% | 2089.87 ± 0.2% | 21.10 ± 2.5% | 3968.13 ± 0.3% | 38.04 ± 0.4% | refused | differs | 15113.27 ± 1.0% | 7.21 | 1.00 | 3.79 | 395.90 |
| literal: an href attribute | 33 | 16598.21 ± 2.9% | 609.83 ± 0.1% | 26.58 ± 0.3% | 16671.29 ± 4.1% | 2261.55 ± 0.2% | 13.42 ± 0.3% | 73.94 ± 0.5% | 16824.68 ± 2.1% | 27.22 | 0.99 | 1.00 | 7.34 |
| literal: a word, second text | 123 | 19860.05 ± 3.0% | 3389.55 ± 0.3% | 27.28 ± 0.1% | 18519.98 ± 2.4% | 7510.10 ± 6.0% | 19.76 ± 0.5% | 70.12 ± 1.0% | 19853.83 ± 3.8% | 5.86 | 1.00 | 1.07 | 2.64 |
| class: two capitalized words | 1331 | 1070.49 ± 0.8% | 598.00 ± 0.5% | 25.39 ± 0.1% | 585.19 ± 0.2% | 40.54 ± 7.5% | 14.98 ± 0.4% | 67.38 ± 0.4% | 1071.24 ± 0.2% | 1.79 | 1.00 | 1.83 | 26.41 |
| class: a word that ends in ing | 3399 | 572.69 ± 0.2% | 572.50 ± 0.4% | 17.73 ± 0.1% | 547.83 ± 0.1% | 29.57 ± 6.6% | 8.26 ± 0.2% | 18.42 ± 0.2% | 573.61 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.37 |
| class: a word in capitals | 2332 | 1378.30 ± 0.4% | 603.96 ± 0.1% | 26.87 ± 0.1% | 572.45 ± 0.3% | 43.57 ± 15.8% | 17.36 ± 0.3% | 82.63 ± 0.2% | 1378.01 ± 0.2% | 2.28 | 1.00 | 2.41 | 31.64 |
| class: a number | 8288 | 1996.02 ± 0.6% | 825.88 ± 0.3% | 27.10 ± 0.2% | 1732.76 ± 0.5% | 39.13 ± 15.4% | 0.57 ± 0.2% | 57.44 ± 0.3% | 1998.44 ± 0.4% | 2.42 | 1.00 | 1.15 | 51.01 |
| class: two capitalized words, second text | 5359 | 516.10 ± 0.4% | 523.63 ± 0.7% | 22.74 ± 0.1% | 484.97 ± 0.2% | 35.39 ± 10.6% | 16.73 ± 0.2% | 62.83 ± 0.3% | 516.50 ± 0.3% | 0.99 | 1.00 | 1.06 | 14.58 |
| other: a word between two words | 6104 | 792.89 ± 0.1% | 592.38 ± 0.2% | 23.07 ± 0.3% | 734.28 ± 0.3% | 105.53 ± 10.7% | 11.35 ± 0.2% | 68.35 ± 0.2% | 792.29 ± 0.1% | 1.34 | 1.00 | 1.08 | 7.51 |
| other: a number before a unit, second text | 1481 | 5954.71 ± 1.5% | 1122.34 ± 0.3% | 25.44 ± 0.2% | 5642.17 ± 0.6% | 40.75 ± 16.4% | 17.83 ± 0.2% | 65.79 ± 0.2% | 5947.57 ± 1.0% | 5.31 | 1.00 | 1.06 | 146.14 |
| other: a heading's start tag | 110 | 13824.54 ± 0.8% | 743.15 ± 0.2% | 26.77 ± 0.2% | 1708.19 ± 0.4% | 1566.98 ± 7.7% | 16.29 ± 1.9% | 86.11 ± 0.3% | 13922.82 ± 0.7% | 18.60 | 0.99 | 8.09 | 8.82 |
| other: a whole word | 217 | 15609.42 ± 1.6% | 603.23 ± 0.3% | 28.65 ± 0.2% | 14535.34 ± 2.1% | 49.42 ± 0.7% | 13.87 ± 0.4% | 54.93 ± 0.4% | 15847.56 ± 0.9% | 25.88 | 0.98 | 1.07 | 315.88 |
| other: a line's first word, second text | 3716 | 2038.25 ± 0.3% | 587.38 ± 0.3% | 29.99 ± 0.2% | 1724.98 ± 0.7% | 62.20 ± 4.3% | refused | refused | 2042.99 ± 0.6% | 3.47 | 1.00 | 1.18 | 32.77 |
| other: fourteen octets before an x | 87 | 23658.27 ± 1.5% | 239.24 ± 0.3% | 6.28 ± 0.1% | 3868.92 ± 1.4% | 10.63 ± 0.3% | differs | 17.77 ± 0.2% | 23622.31 ± 10.0% | 98.89 | 1.00 | 6.11 | 2224.74 |
| other: a Greek word | 21815 | 497.41 ± 0.1% | 412.57 ± 0.5% | 30.31 ± 0.4% | 289.63 ± 0.1% | 47.27 ± 11.4% | differs | refused | 500.50 ± 0.4% | 1.21 | 0.99 | 1.72 | 10.52 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.54 ± 0.2% | 19.49 ± 0.2% | 0.85 ± 0.2% | 19.77 ± 0.1% | 2.76 ± 0.4% | differs | 4.05 ± 0.1% | 19.50 ± 0.3% | 1.00 | 1.00 | 0.99 | 7.08 |
| a UUID | 32895 | 21.10 ± 0.2% | 21.06 ± 0.2% | 0.64 ± 0.1% | 15.07 ± 0.5% | 3.12 ± 1.0% | 0.72 ± 0.3% | 3.62 ± 1.1% | 21.05 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.76 |
| an IPv4 address | 33176 | 35.95 ± 0.2% | 35.93 ± 0.2% | 2.05 ± 0.3% | 28.97 ± 0.7% | 6.66 ± 0.2% | differs | 4.14 ± 0.2% | 35.93 ± 0.2% | 1.00 | 1.00 | 1.24 | 5.40 |
| a date and time | 32954 | 30.94 ± 0.5% | 30.96 ± 0.4% | 1.43 ± 0.2% | 21.11 ± 0.4% | 7.05 ± 0.2% | 1.20 ± 0.1% | 7.12 ± 0.2% | 30.95 ± 0.3% | 1.00 | 1.00 | 1.47 | 4.39 |
| a field path | 32606 | 23.19 ± 0.2% | 23.11 ± 0.2% | 1.01 ± 0.3% | 22.95 ± 0.3% | 3.48 ± 1.4% | differs | 2.98 ± 0.3% | 23.10 ± 0.2% | 1.00 | 1.00 | 1.01 | 6.66 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.17 ± 1.0% | 11.13 ± 2.6% | 11.11 ± 2.2% | 11.50 ± 0.0% | 4.95 ± 1.5% | 0.92 ± 0.7% | none | 11.14 ± 1.1% | 1.00 | 1.00 | 0.97 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 224.50 ± 0.9% | 226.08 ± 0.8% | 274.52 ± 1.0% | 86.30 ± 0.5% | 218.69 ± 1.2% | 476.72 ± 0.9% | 3778.58 ± 0.5% | 224.97 ± 0.8% | 0.99 | 1.00 | 2.60 | 1.03 |
| a UUID | 62 | 148.14 ± 1.4% | 149.02 ± 1.0% | 168.00 ± 1.3% | 45.89 ± 1.0% | 98.66 ± 1.0% | 186.16 ± 2.4% | 4164.60 ± 0.8% | 147.38 ± 1.2% | 0.99 | 1.01 | 3.23 | 1.50 |
| an IPv4 address | 29 | 404.96 ± 0.4% | 411.10 ± 0.4% | 593.39 ± 0.4% | 77.06 ± 0.9% | 130.36 ± 1.4% | 291.59 ± 1.0% | 7462.94 ± 0.5% | 406.08 ± 0.4% | 0.99 | 1.00 | 5.25 | 3.11 |
| a date and time | 56 | 294.22 ± 0.4% | 296.86 ± 0.1% | 381.02 ± 0.2% | 71.83 ± 0.7% | 134.82 ± 25.3% | 320.10 ± 1.6% | 4793.79 ± 0.7% | 294.57 ± 0.1% | 0.99 | 1.00 | 4.10 | 2.18 |
| a field path | 39 | 217.09 ± 1.6% | 219.47 ± 1.0% | 263.26 ± 1.9% | 78.47 ± 1.1% | 201.71 ± 0.6% | 494.02 ± 4.8% | 4835.22 ± 0.9% | 216.13 ± 1.7% | 0.99 | 1.00 | 2.77 | 1.08 |
| literal: a word | 7 | 596.74 ± 1.0% | 644.24 ± 0.5% | 1218.55 ± 0.3% | 516.58 ± 1.3% | 620.68 ± 5.1% | 949.95 ± 0.5% | 29724.43 ± 0.2% | 596.67 ± 0.5% | 0.93 | 1.00 | 1.16 | 0.96 |
| literal: a word that is not there | 8 | 574.33 ± 0.2% | 623.16 ± 0.5% | 1148.17 ± 0.1% | 464.01 ± 0.3% | 597.46 ± 1.4% | 894.72 ± 0.6% | 28629.97 ± 0.2% | 574.13 ± 0.4% | 0.92 | 1.00 | 1.24 | 0.96 |
| literal: one of four words | 26 | 234.86 ± 0.3% | 383.99 ± 0.1% | 541.09 ± 0.6% | 49.63 ± 0.5% | 239.56 ± 1.3% | 367.44 ± 0.7% | 15708.95 ± 0.2% | 234.95 ± 0.2% | 0.61 | 1.00 | 4.73 | 0.98 |
| literal: a word in any case | 11 | 432.76 ± 0.1% | 461.06 ± 0.3% | 707.38 ± 0.2% | 15.61 ± 0.2% | 645.17 ± 1.1% | refused | 23550.38 ± 0.3% | 433.05 ± 0.3% | 0.94 | 1.00 | 27.72 | 0.67 |
| literal: an href attribute | 12 | 328.98 ± 0.8% | 341.01 ± 1.5% | 464.38 ± 0.3% | 42.32 ± 0.5% | 489.12 ± 10.9% | 765.07 ± 0.8% | 21384.63 ± 0.2% | 329.92 ± 0.2% | 0.96 | 1.00 | 7.77 | 0.67 |
| literal: a word, second text | 10 | 533.48 ± 0.4% | 585.58 ± 0.6% | 1030.55 ± 0.5% | 402.02 ± 0.8% | 532.09 ± 1.0% | 797.87 ± 0.8% | 26601.13 ± 0.2% | 534.87 ± 0.4% | 0.91 | 1.00 | 1.33 | 1.00 |
| class: two capitalized words | 23 | 414.44 ± 0.2% | 449.16 ± 0.4% | 669.98 ± 0.6% | 100.84 ± 2.0% | 496.66 ± 2.2% | 746.09 ± 0.5% | 6426.78 ± 0.6% | 414.47 ± 0.3% | 0.92 | 1.00 | 4.11 | 0.83 |
| class: a word that ends in ing | 9 | 519.59 ± 0.2% | 587.72 ± 0.3% | 1088.07 ± 0.1% | 131.59 ± 0.9% | 750.63 ± 2.1% | 1096.28 ± 0.4% | 15823.55 ± 0.4% | 519.28 ± 0.3% | 0.88 | 1.00 | 3.95 | 0.69 |
| class: a word in capitals | 16 | 459.96 ± 0.4% | 504.32 ± 0.4% | 844.78 ± 0.1% | 135.06 ± 0.7% | 744.32 ± 1.1% | 1006.89 ± 0.5% | 8447.46 ± 0.1% | 459.55 ± 0.3% | 0.91 | 1.00 | 3.41 | 0.62 |
| class: a number | 6 | 576.91 ± 0.3% | 649.35 ± 0.6% | 1299.79 ± 0.2% | 41.52 ± 0.5% | 1395.33 ± 1.1% | 1866.55 ± 1.3% | 22424.17 ± 0.2% | 576.55 ± 0.2% | 0.89 | 1.00 | 13.89 | 0.41 |
| class: two capitalized words, second text | 23 | 413.97 ± 0.4% | 449.72 ± 0.5% | 671.52 ± 0.2% | 99.70 ± 0.5% | 499.40 ± 0.7% | 767.97 ± 1.2% | 6430.49 ± 0.3% | 414.94 ± 0.3% | 0.92 | 1.00 | 4.15 | 0.83 |
| other: a word between two words | 13 | 514.33 ± 0.4% | 532.75 ± 0.6% | 887.93 ± 0.1% | 132.67 ± 1.1% | 498.28 ± 0.5% | 815.93 ± 0.6% | 14451.10 ± 0.4% | 514.20 ± 0.4% | 0.97 | 1.00 | 3.88 | 1.03 |
| other: a number before a unit, second text | 15 | 375.92 ± 0.4% | 416.53 ± 0.3% | 604.40 ± 0.9% | 39.00 ± 0.7% | 628.51 ± 1.0% | 894.56 ± 4.0% | 15074.37 ± 0.4% | 376.17 ± 0.7% | 0.90 | 1.00 | 9.64 | 0.60 |
| other: a heading's start tag | 13 | 342.72 ± 0.6% | 349.91 ± 0.2% | 472.88 ± 0.6% | 42.75 ± 0.8% | 622.05 ± 1.7% | 855.58 ± 1.1% | 17707.68 ± 0.6% | 343.30 ± 0.3% | 0.98 | 1.00 | 8.02 | 0.55 |
| other: a whole word | 11 | 552.45 ± 0.4% | 588.64 ± 0.2% | 1033.11 ± 0.4% | 117.35 ± 0.6% | 559.89 ± 1.7% | 815.14 ± 0.8% | 26888.13 ± 0.5% | 552.18 ± 0.5% | 0.94 | 1.00 | 4.71 | 0.99 |
| other: a line's first word, second text | 17 | 495.72 ± 0.4% | 518.18 ± 0.4% | 872.85 ± 0.6% | 127.12 ± 0.6% | 705.11 ± 0.9% | refused | refused | 495.95 ± 0.3% | 0.96 | 1.00 | 3.90 | 0.70 |
| other: fourteen octets before an x | 16 | 107.12 ± 0.8% | 152.22 ± 0.8% | 179.87 ± 1.3% | 14.49 ± 0.5% | 449.76 ± 1.2% | 405.90 ± 0.2% | 12660.07 ± 0.5% | 106.97 ± 0.8% | 0.70 | 1.00 | 7.39 | 0.24 |
| other: a Greek word | 8 | 405.08 ± 0.2% | 557.49 ± 0.3% | 986.89 ± 0.8% | 58.56 ± 0.4% | 1371.09 ± 0.3% | 1833.48 ± 0.5% | refused | 405.15 ± 0.1% | 0.73 | 1.00 | 6.92 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15435.61 ± 1.5% | not timed | not timed | 15893.28 ± 1.6% | 2015.50 ± 16.8% | not timed | not timed | 15406.76 ± 1.1% | | 1.00 | 0.97 | 7.66 |
| 01-literal/sherlock-casei-en | 522 | 10975.83 ± 3.7% | not timed | not timed | 3587.66 ± 0.2% | 32.55 ± 0.2% | not timed | not timed | 11018.02 ± 0.9% | | 1.00 | 3.06 | 337.22 |
| 01-literal/sherlock-ru | 724 | 16991.93 ± 1.5% | not timed | not timed | 17127.93 ± 1.6% | 1527.31 ± 8.2% | not timed | not timed | 17082.81 ± 0.6% | | 0.99 | 0.99 | 11.13 |
| 01-literal/sherlock-casei-ru | 746 | 6166.58 ± 0.2% | not timed | not timed | 3323.16 ± 0.2% | 30.80 ± 0.6% | not timed | not timed | 6179.20 ± 0.4% | | 1.00 | 1.86 | 200.23 |
| 01-literal/sherlock-zh | 30 | 19227.77 ± 1.5% | not timed | not timed | 18102.57 ± 1.7% | 2721.87 ± 9.9% | not timed | not timed | 19266.53 ± 0.5% | | 1.00 | 1.06 | 7.06 |
| 02-literal-alternate/sherlock-en | 714 | 6050.78 ± 0.5% | not timed | not timed | 3937.98 ± 0.1% | 16.59 ± 0.1% | not timed | not timed | 6053.44 ± 0.5% | | 1.00 | 1.54 | 364.78 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1977.15 ± 1.8% | not timed | not timed | 697.20 ± 0.3% | 11.13 ± 0.2% | not timed | not timed | 1988.83 ± 0.7% | | 0.99 | 2.84 | 177.70 |
| 02-literal-alternate/sherlock-ru | 899 | 5558.12 ± 0.4% | not timed | not timed | 3259.71 ± 0.1% | 22.63 ± 0.0% | not timed | not timed | 5565.66 ± 0.1% | | 1.00 | 1.71 | 245.63 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2058.55 ± 0.6% | not timed | not timed | 1234.07 ± 0.2% | 9.11 ± 5.6% | not timed | not timed | 2056.44 ± 0.7% | | 1.00 | 1.67 | 225.92 |
| 02-literal-alternate/sherlock-zh | 207 | 7259.46 ± 0.5% | not timed | not timed | 4161.71 ± 0.0% | 31.47 ± 0.2% | not timed | not timed | 7262.71 ± 0.4% | | 1.00 | 1.74 | 230.67 |
| 03-date/ascii | 111817 | 124.43 ± 0.6% | not timed | not timed | 95.91 ± 0.3% | 0.20 ± 3.9% | not timed | not timed | 124.57 ± 0.7% | | 1.00 | 1.30 | 625.31 |
| 04-ruff-noqa/real | 84 | 404.01 ± 0.1% | not timed | not timed | 462.18 ± 0.2% | 19.66 ± 1.4% | not timed | not timed | 404.47 ± 0.1% | | 1.00 | 0.87 | 20.55 |
| 04-ruff-noqa/tweaked | 44 | 558.40 ± 0.4% | not timed | not timed | 454.48 ± 0.3% | 369.23 ± 0.7% | not timed | not timed | 557.97 ± 0.3% | | 1.00 | 1.23 | 1.51 |
| 05-lexer-veryl/single | 124800 | 5.30 ± 3.4% | not timed | not timed | 4.94 ± 0.2% | 0.20 ± 4.8% | not timed | not timed | 5.32 ± 0.8% | | 1.00 | 1.07 | 25.89 |
| 06-cloud-flare-redos/original | 107 | 414.87 ± 1.7% | not timed | not timed | 216.33 ± 0.0% | 24.96 ± 0.2% | not timed | not timed | 415.40 ± 0.9% | | 1.00 | 1.92 | 16.62 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.49 ± 0.0% | not timed | not timed | 228.17 ± 0.1% | 26.68 ± 0.1% | not timed | not timed | 409.31 ± 0.0% | | 1.02 | 1.82 | 15.57 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.28 ± 0.8% | not timed | not timed | 253.64 ± 0.2% | 28.77 ± 0.1% | not timed | not timed | 578.12 ± 1.3% | | 1.02 | 2.32 | 20.41 |
| 07-unicode-character-data/parse-line | 558784 | 242.95 ± 0.2% | not timed | not timed | 172.23 ± 0.2% | 43.30 ± 0.4% | not timed | not timed | 243.34 ± 0.8% | | 1.00 | 1.41 | 5.61 |
| 08-words/all-english | 56691 | 116.63 ± 0.4% | not timed | not timed | 82.18 ± 0.2% | 11.89 ± 5.2% | not timed | not timed | 116.49 ± 0.2% | | 1.00 | 1.42 | 9.81 |
| 08-words/long-english | 839 | 612.49 ± 0.5% | not timed | not timed | 597.24 ± 0.2% | 32.62 ± 0.3% | not timed | not timed | 614.48 ± 1.0% | | 1.00 | 1.03 | 18.78 |
| 09-aws-keys/full | 0 | 408.95 ± 0.1% | not timed | not timed | 464.35 ± 0.1% | 64.53 ± 0.6% | not timed | not timed | 410.16 ± 0.2% | | 1.00 | 0.88 | 6.34 |
| 09-aws-keys/quick | 0 | 874.04 ± 0.3% | not timed | not timed | 987.17 ± 0.3% | 423.24 ± 1.9% | not timed | not timed | 874.27 ± 0.2% | | 1.00 | 0.89 | 2.07 |
| 10-bounded-repeat/letters-en | 1833 | 584.35 ± 2.5% | not timed | not timed | 516.74 ± 0.3% | 19.50 ± 0.5% | not timed | not timed | 580.59 ± 3.4% | | 1.01 | 1.13 | 29.96 |
| 10-bounded-repeat/letters-ru | 3475 | 510.47 ± 1.4% | not timed | not timed | 478.82 ± 0.2% | 22.48 ± 17.6% | not timed | not timed | 509.46 ± 1.2% | | 1.00 | 1.07 | 22.71 |
| 10-bounded-repeat/context | 53 | 85.31 ± 1.8% | not timed | not timed | 65.95 ± 0.6% | 19.82 ± 0.2% | not timed | not timed | 85.20 ± 1.5% | | 1.00 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 641.92 ± 8.0% | not timed | not timed | 615.59 ± 0.1% | 36.41 ± 0.3% | not timed | not timed | 641.07 ± 8.2% | | 1.00 | 1.04 | 17.63 |
| 11-unstructured-to-json/extract | 600 | 56.90 ± 1.3% | not timed | not timed | 78.03 ± 0.2% | 49.03 ± 0.4% | not timed | not timed | 56.91 ± 0.2% | | 1.00 | 0.73 | 1.16 |
| 12-dictionary/single | 1 | 567.11 ± 0.3% | not timed | not timed | 559.38 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 569.00 ± 0.2% | | 1.00 | 1.01 | 1398.86 |
| 14-quadratic/1x | 100 | 21.08 ± 1.1% | not timed | not timed | 9.99 ± 0.4% | 0.96 ± 2.9% | not timed | not timed | 21.06 ± 1.5% | | 1.00 | 2.11 | 21.92 |
| 14-quadratic/2x | 200 | 17.41 ± 1.0% | not timed | not timed | 5.54 ± 0.4% | 0.53 ± 1.7% | not timed | not timed | 17.37 ± 0.2% | | 1.00 | 3.14 | 32.79 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.7% | not timed | not timed | 1.21 ± 0.5% | 0.12 ± 1.7% | not timed | not timed | 7.68 ± 2.9% | | 1.00 | 6.34 | 66.51 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 2.5% | not timed | not timed | 0.34 ± 0.6% | 0.56 ± 2.8% | not timed | not timed | 1.23 ± 2.4% | | 0.99 | 3.57 | 2.18 |
| 04-ruff-noqa/compile-real | 1 | 104.46 ± 0.4% | not timed | not timed | 13.81 ± 0.5% | 140.04 ± 2.5% | not timed | not timed | 104.32 ± 1.6% | | 1.00 | 7.57 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 14.02 ± 1.2% | not timed | not timed | 2.52 ± 0.3% | 6.45 ± 1.7% | not timed | not timed | 14.02 ± 1.6% | | 1.00 | 5.56 | 2.17 |
| 07-unicode-character-data/compile | 1 | 105.37 ± 1.5% | not timed | not timed | 26.15 ± 0.2% | 36.09 ± 4.4% | not timed | not timed | 105.96 ± 0.4% | | 0.99 | 4.03 | 2.92 |
| 09-aws-keys/compile-full | 1 | 52.62 ± 0.6% | not timed | not timed | 8.20 ± 0.2% | 23.32 ± 1.4% | not timed | not timed | 52.80 ± 0.2% | | 1.00 | 6.42 | 2.26 |
| 09-aws-keys/compile-quick | 1 | 181.63 ± 1.4% | not timed | not timed | 47.07 ± 0.2% | 133.92 ± 2.4% | not timed | not timed | 181.07 ± 1.1% | | 1.00 | 3.86 | 1.36 |
| 10-bounded-repeat/compile-context | 1 | 71.26 ± 0.7% | not timed | not timed | 11.17 ± 0.2% | 16.04 ± 1.4% | not timed | not timed | 71.45 ± 0.8% | | 1.00 | 6.38 | 4.44 |
| 10-bounded-repeat/compile-capitals | 1 | 84.32 ± 0.4% | not timed | not timed | 8.00 ± 0.5% | 23.63 ± 0.8% | not timed | not timed | 83.77 ± 1.1% | | 1.01 | 10.54 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 167.82 ± 0.6% | not timed | not timed | 40.73 ± 0.3% | 68.29 ± 1.3% | not timed | not timed | 167.88 ± 0.4% | | 1.00 | 4.12 | 2.46 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.5% | not timed | not timed | 0.07 ± 0.2% | 0.10 ± 6.3% | not timed | not timed | 0.35 ± 0.4% | | 1.00 | 5.14 | 3.66 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.42 ± 5.0% | not timed | not timed | 6.49 ± 0.2% | 0.54 ± 19.6% | not timed | not timed | 7.54 ± 2.3% | | 0.98 | 1.14 | 13.66 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.7% | not timed | not timed | 165.64 ± 1.0% | 0.00 ± 0.5% | not timed | not timed | 1.05 ± 0.3% | | 1.00 | 0.0063 | 375.23 |
| dictionary/search/english-15 | 15 | 559.26 ± 1.0% | not timed | not timed | 558.24 ± 0.2% | 0.37 ± 0.3% | not timed | not timed | 560.46 ± 0.6% | | 1.00 | 1.00 | 1509.72 |
| folly/awyer-inn-busted | 1 | 5588.59 ± 0.0% | not timed | not timed | 141.69 ± 0.1% | 43.98 ± 0.1% | not timed | not timed | 5576.09 ± 0.1% | | 1.00 | 39.44 | 127.07 |
| folly/literal-never-match-rare | 0 | 21166.60 ± 0.5% | not timed | not timed | 19964.25 ± 0.2% | 41082.50 ± 0.4% | not timed | not timed | 21160.36 ± 0.1% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12556.01 ± 1.7% | not timed | not timed | 19910.81 ± 0.2% | 2183.79 ± 0.9% | not timed | not timed | 12588.42 ± 1.5% | | 1.00 | 0.63 | 5.75 |
| folly/literal-never-match-tricksy | 1 | 3258.27 ± 0.3% | not timed | not timed | 4409.33 ± 3.3% | 3056.19 ± 1.0% | not timed | not timed | 3247.51 ± 0.7% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1313.19 ± 0.4% | not timed | not timed | 954.02 ± 0.3% | 380.68 ± 17.5% | not timed | not timed | 1314.69 ± 0.5% | | 1.00 | 1.38 | 3.45 |
| grep/long-words-ascii | 5073 | 459.65 ± 0.3% | not timed | not timed | 467.74 ± 0.1% | 46.24 ± 6.1% | not timed | not timed | 435.08 ± 0.4% | | 1.06 | 0.98 | 9.94 |
| imported/leipzig/twain | 811 | 20761.48 ± 1.6% | not timed | not timed | 19663.74 ± 0.7% | 11994.36 ± 8.9% | not timed | not timed | 20791.52 ± 0.4% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9060.80 ± 1.4% | not timed | not timed | 4254.53 ± 0.1% | 37.77 ± 0.1% | not timed | not timed | 9079.73 ± 0.9% | | 1.00 | 2.13 | 239.90 |
| imported/leipzig/shing | 1540 | 629.96 ± 0.1% | not timed | not timed | 13286.17 ± 2.4% | 34.09 ± 0.2% | not timed | not timed | 632.35 ± 0.1% | | 1.00 | 0.0474 | 18.48 |
| imported/leipzig/huck-saw | 262 | 8321.19 ± 3.0% | not timed | not timed | 5610.92 ± 0.1% | 31.70 ± 0.2% | not timed | not timed | 8475.91 ± 2.8% | | 0.98 | 1.48 | 262.49 |
| imported/leipzig/word-ending-nn | 262 | 607.96 ± 0.2% | not timed | not timed | 614.94 ± 0.3% | 24.78 ± 0.3% | not timed | not timed | 611.38 ± 0.1% | | 0.99 | 0.99 | 24.53 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11068.80 ± 0.8% | not timed | not timed | 4543.77 ± 0.3% | 11.52 ± 1.1% | not timed | not timed | 11116.21 ± 1.8% | | 1.00 | 2.44 | 961.10 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7814.61 ± 1.7% | not timed | not timed | 5494.03 ± 0.1% | 16.84 ± 0.1% | not timed | not timed | 7933.43 ± 1.9% | | 0.99 | 1.42 | 464.00 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4201.17 ± 1.4% | not timed | not timed | 417.07 ± 0.4% | 11.09 ± 0.0% | not timed | not timed | 4220.39 ± 0.8% | | 1.00 | 10.07 | 378.78 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 608.87 ± 0.2% | not timed | not timed | 615.08 ± 0.1% | 11.14 ± 0.1% | not timed | not timed | 609.56 ± 0.2% | | 1.00 | 0.99 | 54.68 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.63 ± 0.1% | not timed | not timed | 615.63 ± 0.1% | 9.73 ± 0.1% | not timed | not timed | 610.10 ± 0.2% | | 1.00 | 0.99 | 62.68 |
| imported/leipzig/tom-river | 2 | 6537.56 ± 1.6% | not timed | not timed | 5156.09 ± 0.1% | 30.98 ± 0.1% | not timed | not timed | 6616.73 ± 1.7% | | 0.99 | 1.27 | 211.00 |
| imported/leipzig/ing | 78424 | 609.15 ± 0.8% | not timed | not timed | 570.22 ± 0.1% | 28.33 ± 3.1% | not timed | not timed | 607.80 ± 0.8% | | 1.00 | 1.07 | 21.50 |
| imported/leipzig/ing-whitespace | 55248 | 758.92 ± 1.0% | not timed | not timed | 2086.42 ± 0.6% | 20.55 ± 2.6% | not timed | not timed | 760.83 ± 0.9% | | 1.00 | 0.36 | 36.94 |
| imported/leipzig/awyer-inn | 209 | 774.77 ± 1.3% | not timed | not timed | 4280.70 ± 0.1% | 22.73 ± 0.1% | not timed | not timed | 775.28 ± 1.3% | | 1.00 | 0.18 | 34.08 |
| imported/leipzig/quotes-bounded | 8886 | 2129.56 ± 0.2% | not timed | not timed | 3026.18 ± 0.3% | 38.23 ± 0.0% | not timed | not timed | 2124.94 ± 0.7% | | 1.00 | 0.70 | 55.70 |
| imported/leipzig/non-ascii-alternate | 2 | 12963.28 ± 1.6% | not timed | not timed | 5673.88 ± 0.4% | 50.71 ± 0.1% | not timed | not timed | 13109.23 ± 2.2% | | 0.99 | 2.28 | 255.65 |
| imported/leipzig/math-symbols | 69 | 1966.05 ± 0.5% | not timed | not timed | 613.48 ± 0.1% | 36.49 ± 0.1% | not timed | not timed | 1968.13 ± 0.2% | | 1.00 | 3.20 | 53.88 |
| imported/leipzig/bounded-strings-ending-z | 0 | 596.17 ± 0.4% | not timed | not timed | 616.21 ± 0.1% | 22.48 ± 0.3% | not timed | not timed | 595.21 ± 0.3% | | 1.00 | 0.97 | 26.52 |
| imported/lh3lh3-reb/uri | 17549 | 632.39 ± 0.1% | not timed | not timed | 1063.61 ± 0.2% | 28.38 ± 2.2% | not timed | not timed | 632.88 ± 0.3% | | 1.00 | 0.59 | 22.28 |
| imported/lh3lh3-reb/email | 15057 | 668.23 ± 0.1% | not timed | not timed | 1160.98 ± 0.1% | 31.01 ± 2.4% | not timed | not timed | 668.61 ± 0.1% | | 1.00 | 0.58 | 21.55 |
| imported/lh3lh3-reb/date | 668 | 865.77 ± 0.2% | not timed | not timed | 1035.67 ± 0.2% | 51.11 ± 3.9% | not timed | not timed | 864.44 ± 0.3% | | 1.00 | 0.84 | 16.94 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.17 ± 0.1% | not timed | not timed | 416.30 ± 0.3% | 15.78 ± 1.2% | not timed | not timed | 643.19 ± 0.1% | | 1.00 | 1.54 | 40.70 |
| imported/mariomka/email | 92 | 705.98 ± 0.4% | not timed | not timed | 29392.89 ± 1.6% | 32.84 ± 0.2% | not timed | not timed | 706.62 ± 0.1% | | 1.00 | 0.0240 | 21.50 |
| imported/mariomka/uri | 5301 | 608.76 ± 0.2% | not timed | not timed | 6098.15 ± 0.5% | 32.75 ± 0.5% | not timed | not timed | 605.64 ± 0.3% | | 1.01 | 0.0998 | 18.59 |
| imported/mariomka/ip | 5 | 2153.85 ± 2.2% | not timed | not timed | 2970.96 ± 0.1% | 21.03 ± 0.3% | not timed | not timed | 2154.39 ± 2.3% | | 1.00 | 0.72 | 102.42 |
| imported/rsc/no-exponential | 0 | 565.52 ± 1.9% | not timed | not timed | 319.79 ± 0.1% | 23.62 ± 0.4% | not timed | not timed | 567.43 ± 0.5% | | 1.00 | 1.77 | 23.94 |
| imported/rsc/literal | 1 | 740.56 ± 2.4% | not timed | not timed | 1564.63 ± 7.1% | 184.65 ± 17.3% | not timed | not timed | 738.28 ± 5.1% | | 1.00 | 0.47 | 4.01 |
| imported/rsc/not-literal | 2 | 706.11 ± 0.2% | not timed | not timed | 723.41 ± 0.3% | 45.98 ± 9.2% | not timed | not timed | 707.80 ± 1.7% | | 1.00 | 0.98 | 15.36 |
| imported/rsc/match-class | 1 | 1304.77 ± 2.2% | not timed | not timed | 1635.22 ± 0.4% | 58.51 ± 6.8% | not timed | not timed | 1309.99 ± 0.3% | | 1.00 | 0.80 | 22.30 |
| imported/rsc/match-class-in-range | 1 | 1310.33 ± 2.2% | not timed | not timed | 2267.27 ± 5.4% | 59.96 ± 6.0% | not timed | not timed | 1314.28 ± 0.3% | | 1.00 | 0.58 | 21.85 |
| imported/rsc/match-class-unicode | 1 | 525.08 ± 1.6% | not timed | not timed | 511.56 ± 0.0% | 72.60 ± 8.1% | not timed | not timed | 525.17 ± 0.1% | | 1.00 | 1.03 | 7.23 |
| imported/rsc/anchored-literal-short-non-match | 0 | 533.80 ± 0.7% | not timed | not timed | 955.37 ± 0.1% | 227.73 ± 0.6% | not timed | not timed | 531.97 ± 0.5% | | 1.00 | 0.56 | 2.34 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7944.96 ± 0.1% | not timed | not timed | 14310.32 ± 0.1% | 3426.41 ± 0.9% | not timed | not timed | 7941.07 ± 0.1% | | 1.00 | 0.56 | 2.32 |
| imported/rsc/anchored-literal-short-match | 4 | 422.15 ± 2.7% | not timed | not timed | 486.79 ± 0.3% | 85.50 ± 13.1% | not timed | not timed | 421.84 ± 6.2% | | 1.00 | 0.87 | 4.94 |
| imported/rsc/anchored-literal-long-match | 4 | 2988.57 ± 2.7% | not timed | not timed | 7270.60 ± 0.3% | 1266.10 ± 4.8% | not timed | not timed | 3029.87 ± 2.6% | | 0.99 | 0.41 | 2.36 |
| imported/rsc/one-pass-short | 17 | 312.25 ± 1.8% | not timed | not timed | 210.81 ± 0.1% | 31.86 ± 13.8% | not timed | not timed | 311.62 ± 10.2% | | 1.00 | 1.48 | 9.80 |
| imported/rsc/one-pass-short-not | 17 | 219.81 ± 1.2% | not timed | not timed | 224.06 ± 0.2% | 29.98 ± 14.6% | not timed | not timed | 220.01 ± 1.4% | | 1.00 | 0.98 | 7.33 |
| imported/rsc/one-pass-long-prefix | 26 | 236.34 ± 10.2% | not timed | not timed | 281.99 ± 0.2% | 98.02 ± 16.7% | not timed | not timed | 238.16 ± 2.1% | | 0.99 | 0.84 | 2.41 |
| imported/rsc/one-pass-long-prefix-not | 26 | 313.74 ± 1.5% | not timed | not timed | 281.26 ± 0.2% | 63.87 ± 20.3% | not timed | not timed | 313.33 ± 1.6% | | 1.00 | 1.12 | 4.91 |
| imported/rsc/long-needle1 | 31 | 21943.86 ± 0.2% | not timed | not timed | 20145.49 ± 0.3% | 3.77 ± 0.1% | not timed | not timed | 21963.31 ± 0.2% | | 1.00 | 1.09 | 5824.19 |
| imported/rsc/long-needle2 | 31 | 22107.94 ± 0.2% | not timed | not timed | 216.22 ± 0.2% | 3.76 ± 0.2% | not timed | not timed | 22118.97 ± 0.1% | | 1.00 | 102.25 | 5873.51 |
| imported/rsc/easy0-32 | 26 | 1049.62 ± 2.3% | not timed | not timed | 1584.69 ± 4.1% | 148.45 ± 12.7% | not timed | not timed | 1043.52 ± 10.2% | | 1.01 | 0.66 | 7.07 |
| imported/rsc/easy0-1k | 26 | 14971.82 ± 1.7% | not timed | not timed | 12547.98 ± 1.9% | 2292.85 ± 13.9% | not timed | not timed | 14971.75 ± 0.2% | | 1.00 | 1.19 | 6.53 |
| imported/rsc/easy0-32k | 26 | 22902.66 ± 0.1% | not timed | not timed | 20383.61 ± 0.1% | 18764.39 ± 0.2% | not timed | not timed | 22904.01 ± 0.2% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21256.82 ± 2.0% | not timed | not timed | 19452.51 ± 2.3% | 34129.64 ± 4.1% | not timed | not timed | 21088.37 ± 1.8% | | 1.01 | 1.09 | 0.62 |
| imported/rsc/easy1-32 | 19 | 359.84 ± 1.7% | not timed | not timed | 638.28 ± 0.2% | 138.00 ± 19.5% | not timed | not timed | 360.15 ± 7.2% | | 1.00 | 0.56 | 2.61 |
| imported/rsc/easy1-1k | 19 | 583.80 ± 0.4% | not timed | not timed | 13070.55 ± 0.1% | 2487.11 ± 15.4% | not timed | not timed | 578.71 ± 2.3% | | 1.01 | 0.0447 | 0.23 |
| imported/rsc/easy1-32k | 19 | 602.33 ± 3.4% | not timed | not timed | 411051.37 ± 0.1% | 20402.94 ± 29.6% | not timed | not timed | 600.13 ± 0.5% | | 1.00 | 0.0015 | 0.0295 |
| imported/rsc/easy1-1mb | 19 | 603.56 ± 0.9% | not timed | not timed | 13037780.82 ± 0.1% | 36760.40 ± 6.6% | not timed | not timed | 600.00 ± 0.8% | | 1.01 | 0.0000 | 0.0164 |
| imported/rsc/medium-32 | 27 | 424.93 ± 0.7% | not timed | not timed | 637.56 ± 0.1% | 70.00 ± 13.5% | not timed | not timed | 424.80 ± 2.4% | | 1.00 | 0.67 | 6.07 |
| imported/rsc/medium-1k | 27 | 6748.41 ± 0.3% | not timed | not timed | 11491.21 ± 0.6% | 72.37 ± 0.1% | not timed | not timed | 6739.66 ± 0.1% | | 1.00 | 0.59 | 93.25 |
| imported/rsc/medium-32k | 27 | 21570.87 ± 0.1% | not timed | not timed | 349492.00 ± 0.1% | 48.59 ± 0.2% | not timed | not timed | 21589.86 ± 0.1% | | 1.00 | 0.0617 | 443.98 |
| imported/rsc/medium-1mb | 27 | 20941.85 ± 8.2% | not timed | not timed | 11177973.16 ± 0.2% | 48.31 ± 0.3% | not timed | not timed | 20970.35 ± 4.7% | | 1.00 | 0.0019 | 433.53 |
| imported/rsc/hard-32 | 58 | 255.02 ± 0.3% | not timed | not timed | 368.15 ± 0.0% | 49.67 ± 7.7% | not timed | not timed | 255.52 ± 1.6% | | 1.00 | 0.69 | 5.13 |
| imported/rsc/hard-1k | 27 | 576.39 ± 0.3% | not timed | not timed | 11412.42 ± 1.0% | 40.83 ± 0.1% | not timed | not timed | 573.71 ± 0.3% | | 1.00 | 0.0505 | 14.12 |
| imported/rsc/hard-32k | 27 | 601.34 ± 0.6% | not timed | not timed | 361536.45 ± 0.3% | 29.43 ± 0.2% | not timed | not timed | 597.95 ± 0.5% | | 1.01 | 0.0017 | 20.43 |
| imported/rsc/hard-1mb | 51 | 603.43 ± 0.8% | not timed | not timed | 7307755.43 ± 0.1% | 29.50 ± 0.1% | not timed | not timed | 598.82 ± 0.8% | | 1.01 | 0.0001 | 20.45 |
| imported/rsc/reallyhard0-32 | 58 | 254.68 ± 0.2% | not timed | not timed | 223.05 ± 0.2% | 49.69 ± 6.8% | not timed | not timed | 254.88 ± 2.3% | | 1.00 | 1.14 | 5.12 |
| imported/rsc/reallyhard0-1k | 27 | 576.50 ± 0.4% | not timed | not timed | 585.38 ± 0.4% | 40.91 ± 0.1% | not timed | not timed | 580.29 ± 0.3% | | 0.99 | 0.98 | 14.09 |
| imported/rsc/reallyhard0-32k | 27 | 600.35 ± 0.4% | not timed | not timed | 618.39 ± 0.2% | 29.43 ± 0.1% | not timed | not timed | 603.88 ± 0.6% | | 0.99 | 0.97 | 20.40 |
| imported/rsc/reallyhard0-1mb | 51 | 592.84 ± 0.4% | not timed | not timed | 617.45 ± 0.3% | 29.43 ± 0.1% | not timed | not timed | 593.14 ± 1.0% | | 1.00 | 0.96 | 20.15 |
| imported/rsc/reallyreallyhard0-32 | 47 | 273.89 ± 0.1% | not timed | not timed | 196.88 ± 0.4% | 60.37 ± 16.4% | not timed | not timed | 273.93 ± 1.1% | | 1.00 | 1.39 | 4.54 |
| imported/rsc/reallyreallyhard0-1k | 16 | 860.00 ± 3.7% | not timed | not timed | 5972.17 ± 0.1% | 34.06 ± 1.1% | not timed | not timed | 855.97 ± 3.4% | | 1.00 | 0.14 | 25.25 |
| imported/rsc/reallyreallyhard0-32k | 16 | 638.15 ± 6.2% | not timed | not timed | 19226.28 ± 0.1% | 24.86 ± 1.0% | not timed | not timed | 636.09 ± 6.0% | | 1.00 | 0.0332 | 25.67 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 593.52 ± 0.4% | not timed | not timed | 19338.84 ± 3.2% | 24.95 ± 0.7% | not timed | not timed | 585.56 ± 1.7% | | 1.01 | 0.0307 | 23.79 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.30 ± 0.1% | not timed | not timed | 215.07 ± 0.2% | 60.53 ± 11.4% | not timed | not timed | 268.54 ± 3.3% | | 1.00 | 1.25 | 4.45 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 841.47 ± 1.3% | not timed | not timed | 6260.35 ± 0.1% | 34.62 ± 0.1% | not timed | not timed | 840.99 ± 1.0% | | 1.00 | 0.13 | 24.30 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 629.55 ± 3.2% | not timed | not timed | 19301.41 ± 0.1% | 24.68 ± 0.2% | not timed | not timed | 626.04 ± 3.9% | | 1.01 | 0.0326 | 25.51 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 591.76 ± 0.4% | not timed | not timed | 19240.04 ± 3.4% | 24.93 ± 1.5% | not timed | not timed | 586.63 ± 1.0% | | 1.01 | 0.0308 | 23.73 |
| imported/sherlock/name-sherlock | 776 | 19141.52 ± 1.9% | not timed | not timed | 17792.95 ± 1.5% | 9765.91 ± 24.7% | not timed | not timed | 19212.03 ± 2.1% | | 1.00 | 1.08 | 1.96 |
| imported/sherlock/name-holmes | 2766 | 14890.41 ± 4.5% | not timed | not timed | 15042.26 ± 1.3% | 3124.94 ± 23.7% | not timed | not timed | 15008.21 ± 1.8% | | 0.99 | 0.99 | 4.77 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19154.59 ± 1.9% | not timed | not timed | 17828.31 ± 1.7% | 7942.12 ± 37.0% | not timed | not timed | 19243.25 ± 1.0% | | 1.00 | 1.07 | 2.41 |
| imported/sherlock/name-sherlock-casei | 816 | 15357.53 ± 0.8% | not timed | not timed | 4006.54 ± 0.2% | 32.56 ± 1.0% | not timed | not timed | 15382.96 ± 0.6% | | 1.00 | 3.83 | 471.60 |
| imported/sherlock/name-holmes-casei | 2802 | 9287.02 ± 8.7% | not timed | not timed | 3310.04 ± 0.1% | 37.34 ± 0.7% | not timed | not timed | 9351.43 ± 5.3% | | 0.99 | 2.81 | 248.70 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12865.21 ± 6.6% | not timed | not timed | 3941.52 ± 0.1% | 32.60 ± 0.1% | not timed | not timed | 12893.84 ± 0.9% | | 1.00 | 3.26 | 394.68 |
| imported/sherlock/name-whitespace | 1461 | 14769.07 ± 6.5% | not timed | not timed | 14070.88 ± 0.5% | 7242.45 ± 30.9% | not timed | not timed | 14715.66 ± 7.3% | | 1.00 | 1.05 | 2.04 |
| imported/sherlock/name-alt1 | 1142 | 11409.71 ± 2.1% | not timed | not timed | 15764.63 ± 0.7% | 4116.04 ± 14.4% | not timed | not timed | 11406.18 ± 0.5% | | 1.00 | 0.72 | 2.77 |
| imported/sherlock/name-alt2 | 3542 | 8536.56 ± 0.5% | not timed | not timed | 3826.67 ± 0.1% | 31.33 ± 0.3% | not timed | not timed | 8518.60 ± 0.9% | | 1.00 | 2.23 | 272.47 |
| imported/sherlock/name-alt3 | 4507 | 5451.34 ± 0.3% | not timed | not timed | 3625.85 ± 0.2% | 9.93 ± 1.4% | not timed | not timed | 5454.90 ± 0.2% | | 1.00 | 1.50 | 548.79 |
| imported/sherlock/name-alt3-casei | 4593 | 1509.79 ± 2.2% | not timed | not timed | 285.61 ± 0.2% | 6.46 ± 0.0% | not timed | not timed | 1515.89 ± 0.7% | | 1.00 | 5.29 | 233.58 |
| imported/sherlock/name-alt4 | 3686 | 6178.44 ± 0.4% | not timed | not timed | 3788.51 ± 0.3% | 31.27 ± 35.4% | not timed | not timed | 6161.64 ± 2.6% | | 1.00 | 1.63 | 197.59 |
| imported/sherlock/name-alt4-casei | 4254 | 2751.70 ± 2.8% | not timed | not timed | 2593.59 ± 0.2% | 19.90 ± 0.2% | not timed | not timed | 2772.25 ± 1.0% | | 0.99 | 1.06 | 138.25 |
| imported/sherlock/name-alt5 | 4028 | 6216.43 ± 0.4% | not timed | not timed | 3745.00 ± 0.3% | 21.73 ± 0.2% | not timed | not timed | 6232.98 ± 0.3% | | 1.00 | 1.66 | 286.07 |
| imported/sherlock/name-alt5-casei | 4104 | 3439.52 ± 2.4% | not timed | not timed | 2226.58 ± 0.1% | 14.38 ± 0.1% | not timed | not timed | 3465.01 ± 1.1% | | 0.99 | 1.54 | 239.18 |
| imported/sherlock/no-match-uncommon | 0 | 20655.85 ± 0.8% | not timed | not timed | 18646.19 ± 1.2% | 32134.31 ± 0.4% | not timed | not timed | 20613.57 ± 0.5% | | 1.00 | 1.11 | 0.64 |
| imported/sherlock/no-match-common | 0 | 20501.72 ± 0.5% | not timed | not timed | 18633.25 ± 1.1% | 1271.20 ± 0.5% | not timed | not timed | 20417.72 ± 1.0% | | 1.00 | 1.10 | 16.13 |
| imported/sherlock/no-match-really-common | 0 | 15716.32 ± 3.0% | not timed | not timed | 18012.32 ± 1.3% | 1274.83 ± 1.1% | not timed | not timed | 15929.06 ± 1.5% | | 0.99 | 0.87 | 12.33 |
| imported/sherlock/the-lower | 21654 | 2323.12 ± 1.0% | not timed | not timed | 2339.83 ± 0.2% | 240.78 ± 22.1% | not timed | not timed | 2324.41 ± 0.9% | | 1.00 | 0.99 | 9.65 |
| imported/sherlock/the-upper | 2223 | 12564.36 ± 0.7% | not timed | not timed | 13268.76 ± 0.8% | 2727.34 ± 11.2% | not timed | not timed | 12577.76 ± 1.3% | | 1.00 | 0.95 | 4.61 |
| imported/sherlock/the-casei | 23961 | 2009.93 ± 1.2% | not timed | not timed | 1316.90 ± 0.7% | 34.96 ± 29.4% | not timed | not timed | 2011.63 ± 0.4% | | 1.00 | 1.53 | 57.50 |
| imported/sherlock/everything-greedy | 581881 | 270.13 ± 1.0% | not timed | not timed | 165.63 ± 0.2% | 29.01 ± 35.5% | not timed | not timed | 271.24 ± 0.3% | | 1.00 | 1.63 | 9.31 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.23 ± 0.1% | not timed | not timed | 211.94 ± 0.4% | 33.00 ± 0.1% | not timed | not timed | 462.81 ± 0.3% | | 1.00 | 2.18 | 14.01 |
| imported/sherlock/letters | 447175 | 54.41 ± 7.9% | not timed | not timed | 33.07 ± 0.2% | 6.29 ± 14.9% | not timed | not timed | 54.29 ± 5.7% | | 1.00 | 1.65 | 8.64 |
| imported/sherlock/letters-upper | 14180 | 432.87 ± 1.0% | not timed | not timed | 368.10 ± 0.4% | 29.69 ± 22.1% | not timed | not timed | 433.69 ± 0.7% | | 1.00 | 1.18 | 14.58 |
| imported/sherlock/letters-lower | 432995 | 55.33 ± 1.0% | not timed | not timed | 33.79 ± 0.1% | 5.33 ± 34.9% | not timed | not timed | 55.43 ± 1.0% | | 1.00 | 1.64 | 10.38 |
| imported/sherlock/words | 447639 | 107.11 ± 0.6% | not timed | not timed | 82.90 ± 0.2% | 15.82 ± 16.5% | not timed | not timed | 107.63 ± 0.5% | | 1.00 | 1.29 | 6.77 |
| imported/sherlock/before-holmes | 4073 | 597.56 ± 0.6% | not timed | not timed | 8378.05 ± 0.9% | 24.10 ± 1.5% | not timed | not timed | 597.48 ± 0.5% | | 1.00 | 0.0713 | 24.80 |
| imported/sherlock/before-after-holmes | 2593 | 596.84 ± 0.6% | not timed | not timed | 9378.99 ± 0.7% | 23.74 ± 0.9% | not timed | not timed | 596.78 ± 0.6% | | 1.00 | 0.0636 | 25.14 |
| imported/sherlock/holmes-cochar-watson | 150 | 5209.15 ± 0.3% | not timed | not timed | 3427.28 ± 0.3% | 30.94 ± 0.2% | not timed | not timed | 5218.58 ± 0.2% | | 1.00 | 1.52 | 168.35 |
| imported/sherlock/holmes-coword-watson | 14309 | 1260.23 ± 0.5% | not timed | not timed | 1123.50 ± 0.1% | 6.78 ± 0.2% | not timed | not timed | 1262.11 ± 1.5% | | 1.00 | 1.12 | 185.85 |
| imported/sherlock/quotes | 14437 | 1414.90 ± 0.2% | not timed | not timed | 1749.63 ± 0.7% | 35.09 ± 0.3% | not timed | not timed | 1411.70 ± 0.3% | | 1.00 | 0.81 | 40.32 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 599.75 ± 0.7% | not timed | not timed | 15503.64 ± 0.9% | 36.75 ± 0.1% | not timed | not timed | 597.83 ± 0.7% | | 1.00 | 0.0387 | 16.32 |
| imported/sherlock/word-ending-n | 35297 | 468.08 ± 0.2% | not timed | not timed | 410.01 ± 0.0% | 23.61 ± 24.8% | not timed | not timed | 467.42 ± 1.0% | | 1.00 | 1.14 | 19.82 |
| imported/sherlock/repeated-class-negation | 2130 | 14216.27 ± 0.6% | not timed | not timed | 10650.40 ± 1.1% | 11.60 ± 0.2% | not timed | not timed | 14181.97 ± 0.6% | | 1.00 | 1.33 | 1225.98 |
| imported/sherlock/ing-suffix | 20547 | 554.60 ± 1.1% | not timed | not timed | 516.64 ± 0.1% | 28.81 ± 23.5% | not timed | not timed | 553.58 ± 0.3% | | 1.00 | 1.07 | 19.25 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 594.76 ± 0.3% | not timed | not timed | 2096.34 ± 0.5% | 20.56 ± 0.1% | not timed | not timed | 593.03 ± 0.5% | | 1.00 | 0.28 | 28.93 |
| opt/accelerate/whole-line | 239963 | 459.28 ± 0.1% | not timed | not timed | 371.74 ± 0.1% | 92.77 ± 15.7% | not timed | not timed | 458.96 ± 0.3% | | 1.00 | 1.24 | 4.95 |
| opt/accelerate/non-dna | 16745 | 412.61 ± 1.1% | not timed | not timed | 401.15 ± 0.1% | 29.12 ± 17.1% | not timed | not timed | 413.73 ± 0.6% | | 1.00 | 1.03 | 14.17 |
| opt/backtrack/words-english | 40536 | 136.98 ± 1.9% | not timed | not timed | 94.79 ± 0.1% | 20.05 ± 7.4% | not timed | not timed | 134.53 ± 2.1% | | 1.02 | 1.45 | 6.83 |
| opt/fixed-length/too-small-ascii | 0 | 312.98 ± 0.6% | not timed | not timed | 680.48 ± 2.4% | 80.07 ± 0.5% | not timed | not timed | 310.36 ± 0.4% | | 1.01 | 0.46 | 3.91 |
| opt/fixed-length/too-big-ascii | 0 | 654.55 ± 0.5% | not timed | not timed | 5797.34 ± 0.4% | 127.22 ± 0.4% | not timed | not timed | 657.12 ± 0.8% | | 1.00 | 0.11 | 5.14 |
| opt/fixed-length/go33484-1 | 0 | 45.41 ± 0.2% | not timed | not timed | 1096697.00 ± 0.3% | 61534.30 ± 0.4% | not timed | not timed | 45.43 ± 0.1% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5527.51 ± 0.1% | not timed | not timed | 1102855.03 ± 0.1% | 31960.50 ± 3.3% | not timed | not timed | 5523.06 ± 0.3% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1806.24 ± 1.5% | not timed | not timed | 111180.72 ± 0.2% | 765.36 ± 0.5% | not timed | not timed | 1772.29 ± 1.5% | | 1.02 | 0.0162 | 2.36 |
| opt/literal-alt/one-pattern | 1 | 554.80 ± 10.5% | not timed | not timed | 543.30 ± 0.1% | 0.40 ± 0.3% | not timed | not timed | 555.42 ± 0.2% | | 1.00 | 1.02 | 1381.09 |
| opt/onepass/fn-predicate | 916 | 369.88 ± 0.9% | not timed | not timed | 331.97 ± 0.2% | 201.74 ± 13.8% | not timed | not timed | 370.92 ± 0.8% | | 1.00 | 1.11 | 1.83 |
| opt/onepass/first-three-words-english | 35128 | 148.35 ± 1.9% | not timed | not timed | 202.41 ± 0.2% | 81.77 ± 16.6% | not timed | not timed | 149.86 ± 6.2% | | 0.99 | 0.73 | 1.81 |
| opt/prefilter/literal-english | 1 | 20083.20 ± 0.7% | not timed | not timed | 19146.14 ± 0.5% | 17269.98 ± 0.2% | not timed | not timed | 20112.00 ± 0.6% | | 1.00 | 1.05 | 1.16 |
| opt/prefilter/literal-casei-english | 1 | 14343.09 ± 0.4% | not timed | not timed | 4316.86 ± 0.1% | 32.66 ± 0.5% | not timed | not timed | 14357.18 ± 0.3% | | 1.00 | 3.32 | 439.10 |
| opt/prefilter/literal-russian | 1 | 20775.89 ± 0.5% | not timed | not timed | 19747.28 ± 0.6% | 3328.76 ± 0.2% | not timed | not timed | 20712.99 ± 0.7% | | 1.00 | 1.05 | 6.24 |
| opt/prefilter/literal-casei-russian | 1 | 8593.48 ± 0.9% | not timed | not timed | 3889.02 ± 0.3% | 30.89 ± 0.5% | not timed | not timed | 8579.38 ± 1.0% | | 1.00 | 2.21 | 278.16 |
| opt/prefilter/rust-functions | 948 | 6808.61 ± 0.4% | not timed | not timed | 8936.99 ± 0.8% | 1872.51 ± 0.6% | not timed | not timed | 6818.44 ± 0.2% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 5579.67 ± 0.2% | not timed | not timed | 21351607.74 ± 0.2% | 50.18 ± 0.2% | not timed | not timed | 5581.13 ± 0.2% | | 1.00 | 0.0003 | 111.19 |
| opt/reverse-inner/holmes | 2593 | 596.74 ± 0.4% | not timed | not timed | 9370.42 ± 0.8% | 23.81 ± 0.6% | not timed | not timed | 597.70 ± 0.6% | | 1.00 | 0.0637 | 25.06 |
| opt/reverse-inner/email | 47 | 1045.32 ± 0.2% | not timed | not timed | 44524.40 ± 2.1% | 32.39 ± 0.4% | not timed | not timed | 1043.83 ± 0.2% | | 1.00 | 0.0235 | 32.27 |
| opt/reverse-inner/factored-prefix | 3542 | 589.57 ± 0.6% | not timed | not timed | 594.30 ± 0.1% | 12.57 ± 1.0% | not timed | not timed | 591.62 ± 0.4% | | 1.00 | 0.99 | 46.91 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5512.54 ± 0.1% | not timed | not timed | 616.92 ± 0.4% | 75.11 ± 0.1% | not timed | not timed | 5521.76 ± 0.0% | | 1.00 | 8.94 | 73.39 |
| opt/reverse-inner/no-quadratic-forward | 0 | 684.81 ± 2.3% | not timed | not timed | 287.29 ± 0.2% | 24.84 ± 0.1% | not timed | not timed | 689.14 ± 1.8% | | 0.99 | 2.38 | 27.57 |
| opt/reverse-suffix/holmes | 4073 | 597.44 ± 0.9% | not timed | not timed | 8377.52 ± 0.6% | 24.02 ± 1.6% | not timed | not timed | 596.54 ± 0.4% | | 1.00 | 0.0713 | 24.88 |
| opt/reverse-suffix/no-quadratic | 0 | 5522.03 ± 0.1% | not timed | not timed | 614.26 ± 0.3% | 75.05 ± 0.1% | not timed | not timed | 5506.95 ± 0.1% | | 1.00 | 8.99 | 73.57 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.06 ± 8.2% | not timed | not timed | 132.83 ± 0.1% | 13.64 ± 13.7% | not timed | not timed | 121.49 ± 2.3% | | 1.00 | 0.91 | 8.87 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.28 ± 1.9% | not timed | not timed | 131.08 ± 0.1% | 13.89 ± 14.4% | not timed | not timed | 120.86 ± 6.6% | | 1.00 | 0.93 | 8.73 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 4.0% | not timed | not timed | 0.54 ± 0.3% | 111.79 ± 7.4% | not timed | not timed | 0.28 ± 0.4% | | 1.00 | 0.52 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.76 ± 0.9% | not timed | not timed | 294.52 ± 0.2% | 104.32 ± 0.7% | not timed | not timed | 309.43 ± 0.3% | | 1.02 | 1.08 | 3.04 |
| reported/i13-subset-regex/original-ascii | 4094 | 10963.53 ± 1.2% | not timed | not timed | 4343.18 ± 5.1% | 11.51 ± 0.2% | not timed | not timed | 10902.25 ± 1.5% | | 1.01 | 2.52 | 952.36 |
| reported/i13-subset-regex/original-unicode | 4094 | 10894.92 ± 2.7% | not timed | not timed | 248.60 ± 3.1% | 11.51 ± 0.2% | not timed | not timed | 10986.98 ± 0.4% | | 0.99 | 43.82 | 946.35 |
| reported/i13-subset-regex/big-ascii | 1955 | 10554.30 ± 1.9% | not timed | not timed | 67.31 ± 3.6% | 9.85 ± 0.3% | not timed | not timed | 10654.74 ± 1.2% | | 0.99 | 156.80 | 1071.37 |
| reported/i13-subset-regex/big-unicode | 1955 | 10468.77 ± 3.1% | not timed | not timed | 12.18 ± 54.9% | 9.84 ± 1.2% | not timed | not timed | 10707.17 ± 0.9% | | 0.98 | 859.59 | 1063.47 |
| reported/i13-subset-regex/huge-ascii | 55 | 9838.83 ± 2.7% | not timed | not timed | 11.02 ± 0.1% | 8.75 ± 0.3% | not timed | not timed | 9884.79 ± 4.7% | | 1.00 | 892.58 | 1123.97 |
| reported/i13-subset-regex/huge-unicode | 55 | 9875.37 ± 4.2% | not timed | not timed | 10.96 ± 0.3% | 8.75 ± 0.3% | not timed | not timed | 9889.00 ± 1.8% | | 1.00 | 901.40 | 1128.75 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.0% | not timed | not timed | 11.02 ± 0.2% | 8.76 ± 1.2% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 11.01 ± 0.3% | 8.75 ± 0.2% | not timed | not timed | 5.02 ± 0.0% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 470.21 ± 0.2% | not timed | not timed | 104.71 ± 0.1% | 6.64 ± 0.4% | not timed | not timed | 469.61 ± 0.6% | | 1.00 | 4.49 | 70.80 |
| reported/i787-keywords/opt-ascii | 5674 | 470.73 ± 0.2% | not timed | not timed | 275.85 ± 0.3% | 10.30 ± 0.1% | not timed | not timed | 470.93 ± 0.6% | | 1.00 | 1.71 | 45.69 |
| slow/quadratic-regex-1x | 100 | 6.96 ± 0.2% | not timed | not timed | 4.95 ± 0.2% | 0.05 ± 0.3% | not timed | not timed | 6.93 ± 3.2% | | 1.00 | 1.40 | 141.02 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.2% | not timed | not timed | 2.76 ± 0.2% | 0.01 ± 0.2% | not timed | not timed | 3.39 ± 0.1% | | 1.00 | 1.23 | 267.85 |
| slow/quadratic-haystack-1x | 100 | 21.17 ± 7.2% | not timed | not timed | 10.01 ± 0.3% | 1.01 ± 14.0% | not timed | not timed | 21.13 ± 2.0% | | 1.00 | 2.11 | 20.92 |
| slow/quadratic-haystack-2x | 200 | 17.46 ± 0.9% | not timed | not timed | 5.55 ± 0.2% | 0.54 ± 1.6% | not timed | not timed | 17.40 ± 11.9% | | 1.00 | 3.14 | 32.17 |
| unicode/codepoints/any-one | 1112064 | 285.07 ± 0.3% | not timed | not timed | 174.02 ± 0.7% | 18.53 ± 2.5% | not timed | not timed | 283.98 ± 0.3% | | 1.00 | 1.64 | 15.39 |
| unicode/codepoints/any-all | 4382592 | 289.55 ± 0.6% | not timed | not timed | 246.55 ± 0.1% | 117.32 ± 0.1% | not timed | not timed | 290.00 ± 0.4% | | 1.00 | 1.17 | 2.47 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.77 ± 1.4% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 611.17 ± 0.3% | not timed | not timed | 616.22 ± 0.2% | 135.01 ± 0.2% | not timed | not timed | 609.86 ± 0.6% | | 1.00 | 0.99 | 4.53 |
| unicode/overlapping-words/ascii | 6156 | 31.78 ± 0.4% | not timed | not timed | 38.58 ± 0.2% | 3.92 ± 1.6% | not timed | not timed | 31.82 ± 0.4% | | 1.00 | 0.82 | 8.11 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.4% | not timed | not timed | 4.45 ± 0.2% | 2.34 ± 0.9% | not timed | not timed | 1.35 ± 0.1% | | 1.00 | 0.30 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 8.7% | not timed | not timed | 3.86 ± 0.3% | 6.23 ± 9.1% | not timed | not timed | 1.22 ± 0.5% | | 1.00 | 0.32 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 116.95 ± 6.1% | not timed | not timed | 82.06 ± 0.2% | 11.89 ± 26.3% | not timed | not timed | 117.21 ± 0.8% | | 1.00 | 1.43 | 9.83 |
| unicode/word/boundary-long-english | 3466 | 608.04 ± 0.5% | not timed | not timed | 604.14 ± 0.2% | 32.44 ± 0.6% | not timed | not timed | 606.79 ± 0.9% | | 1.00 | 1.01 | 18.74 |
| unicode/word/around-holmes-english | 27 | 601.43 ± 0.8% | not timed | not timed | 19014.44 ± 0.5% | 22.17 ± 1.2% | not timed | not timed | 602.35 ± 0.6% | | 1.00 | 0.0316 | 27.13 |
| wild/bibleref/long | 874 | 564.50 ± 0.4% | not timed | not timed | 580.88 ± 0.2% | 6.81 ± 0.1% | not timed | not timed | 564.53 ± 0.1% | | 1.00 | 0.97 | 82.91 |
| wild/bibleref/short | 30 | 24.57 ± 3.8% | not timed | not timed | 30.19 ± 0.2% | 14.18 ± 5.7% | not timed | not timed | 24.78 ± 1.2% | | 0.99 | 0.81 | 1.73 |
| wild/bibleref/line | 874 | 358.96 ± 0.0% | not timed | not timed | 213.38 ± 0.2% | 9.18 ± 0.1% | not timed | not timed | 359.43 ± 0.2% | | 1.00 | 1.68 | 39.09 |
| wild/caddy/caddy | 6 | 417.52 ± 7.9% | not timed | not timed | 247.87 ± 0.1% | 68.47 ± 16.6% | not timed | not timed | 417.43 ± 1.1% | | 1.00 | 1.68 | 6.10 |
| wild/dot-star-capture/rust-src-tools | 6 | 1047.78 ± 0.3% | not timed | not timed | 344.24 ± 0.5% | 13.49 ± 0.3% | not timed | not timed | 1047.47 ± 0.3% | | 1.00 | 3.04 | 77.69 |
| wild/ruff/noqa | 84 | 404.44 ± 0.2% | not timed | not timed | 457.93 ± 0.2% | 19.52 ± 1.7% | not timed | not timed | 404.57 ± 0.1% | | 1.00 | 0.88 | 20.72 |
| wild/ruff/unnecessary-coding-comment | 16 | 490.11 ± 0.7% | not timed | not timed | 702.53 ± 0.1% | 136.11 ± 10.7% | not timed | not timed | 489.73 ± 0.7% | | 1.00 | 0.70 | 3.60 |
| wild/ruff/string-quote-prefix | 2972 | 408.12 ± 0.7% | not timed | not timed | 443.77 ± 0.2% | 317.27 ± 26.1% | not timed | not timed | 408.32 ± 0.6% | | 1.00 | 0.92 | 1.29 |
| wild/ruff/space-around-operator | 1224378 | 217.65 ± 1.8% | not timed | not timed | 186.76 ± 0.1% | 18.51 ± 1.8% | not timed | not timed | 218.18 ± 1.9% | | 1.00 | 1.17 | 11.76 |
| wild/ruff/shebang | 282 | 401.64 ± 0.6% | not timed | not timed | 328.34 ± 0.1% | 111.33 ± 11.3% | not timed | not timed | 402.20 ± 0.5% | | 1.00 | 1.22 | 3.61 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13806.89 ± 0.3% | not timed | not timed | 13722.53 ± 0.9% | 6921.28 ± 1.0% | not timed | not timed | 13809.58 ± 0.3% | | 1.00 | 1.01 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12767.85 ± 0.6% | not timed | not timed | 13395.86 ± 0.5% | 6395.12 ± 0.3% | not timed | not timed | 12789.52 ± 0.6% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13157.21 ± 0.3% | not timed | not timed | 13590.82 ± 1.0% | 6596.16 ± 0.7% | not timed | not timed | 13203.91 ± 0.4% | | 1.00 | 0.97 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9552.29 ± 0.1% | not timed | not timed | 13458.00 ± 0.4% | 6711.19 ± 0.7% | not timed | not timed | 9559.25 ± 0.3% | | 1.00 | 0.71 | 1.42 |
| wild/url/search | 234965 | 122.14 ± 13.7% | not timed | not timed | 65.26 ± 1.0% | 2.21 ± 0.6% | not timed | not timed | 120.48 ± 12.8% | | 1.01 | 1.87 | 55.16 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 74.5% | not timed | not timed | 0.01 ± 1.1% | 0.01 ± 20.9% | not timed | not timed | 0.03 ± 2.7% | | 0.99 | 3.06 | 3.91 |
| dictionary/compile/english-15 | 1 | 0.35 ± 22.3% | not timed | not timed | 0.07 ± 1.9% | 0.10 ± 10.8% | not timed | not timed | 0.35 ± 2.8% | | 0.99 | 5.08 | 3.36 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 1.7% | not timed | not timed | 0.02 ± 2.8% | 35.26 ± 13.9% | not timed | not timed | 0.25 ± 3.9% | | 1.02 | 13.40 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.40 ± 4.7% | not timed | not timed | 11.54 ± 0.3% | 54.31 ± 18.4% | not timed | not timed | 46.68 ± 2.1% | | 0.99 | 4.02 | 0.85 |
| reported/i787-keywords/compile | 1 | 34.56 ± 4.6% | not timed | not timed | 2.11 ± 1.0% | 16.98 ± 36.5% | not timed | not timed | 34.63 ± 5.5% | | 1.00 | 16.41 | 2.04 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 339.12 ± 1.7% | not timed | not timed | 124.64 ± 0.3% | 555.57 ± 6.5% | not timed | not timed | 343.72 ± 1.6% | | 0.99 | 2.72 | 0.61 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.38 ± 17.4% | not timed | not timed | 4.09 ± 0.6% | 42.48 ± 16.4% | not timed | not timed | 47.71 ± 4.4% | | 0.99 | 11.58 | 1.12 |
| unicode/compile/one-letter | 53 | 6.65 ± 8.7% | not timed | not timed | 4.50 ± 1.0% | 65.26 ± 3.3% | not timed | not timed | 6.71 ± 13.9% | | 0.99 | 1.48 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.04 ± 11.3% | not timed | not timed | 0.10 ± 0.7% | 67.68 ± 14.7% | not timed | not timed | 1.08 ± 2.4% | | 0.97 | 10.48 | 0.0154 |
| unicode/compile/fifty-letters-ascii | 1 | 212.38 ± 2.8% | not timed | not timed | 53.78 ± 0.2% | 209.55 ± 38.4% | not timed | not timed | 215.65 ± 6.5% | | 0.98 | 3.95 | 1.01 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 365.74 ± 18.9% | not timed | not timed | 47.26 ± 0.6% | 670.29 ± 22.5% | not timed | not timed | 373.26 ± 18.6% | | 0.98 | 7.74 | 0.55 |
| unicode/compile/match-every-line-ascii | 4 | 562.23 ± 6.7% | not timed | not timed | 145.08 ± 0.3% | 664.87 ± 31.0% | not timed | not timed | 582.50 ± 1.7% | | 0.97 | 3.88 | 0.85 |
| unicode/compile/negated-class-matches-codepoint | 1 | 304.73 ± 6.1% | not timed | not timed | 51.55 ± 0.2% | 1328.56 ± 25.3% | not timed | not timed | 310.59 ± 7.3% | | 0.98 | 5.91 | 0.23 |
| wild/bibleref/compile | 3 | 5.73 ± 4.5% | not timed | not timed | 1.92 ± 1.0% | 30.44 ± 18.2% | not timed | not timed | 5.87 ± 23.6% | | 0.98 | 2.98 | 0.19 |
| wild/url/compile | 1 | 0.62 ± 19.0% | not timed | not timed | 0.14 ± 0.2% | 0.44 ± 28.3% | not timed | not timed | 0.63 ± 15.8% | | 0.98 | 4.30 | 1.41 |

