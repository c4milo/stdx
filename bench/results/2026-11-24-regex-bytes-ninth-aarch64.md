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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391520861 |
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
| literal: a word | 217 | 19611.17 ± 3.5% | 5039.84 ± 0.3% | 27.66 ± 0.5% | 17973.92 ± 2.2% | 9259.09 ± 5.6% | 17.42 ± 0.4% | 84.23 ± 0.7% | 19465.46 ± 3.0% | 3.89 | 1.01 | 1.09 | 2.12 |
| literal: a word that is not there | 0 | 21411.73 ± 3.1% | 4924.30 ± 0.3% | 27.79 ± 0.3% | 19392.79 ± 1.9% | 28939.28 ± 1.6% | 17.26 ± 0.1% | 79.67 ± 0.4% | 21368.13 ± 3.6% | 4.35 | 1.00 | 1.10 | 0.74 |
| literal: one of four words | 661 | 6343.94 ± 0.3% | 1949.90 ± 0.1% | 14.20 ± 0.5% | 3946.79 ± 0.2% | 21.89 ± 0.1% | 5.31 ± 0.2% | 6.87 ± 0.5% | 6349.21 ± 0.3% | 3.25 | 1.00 | 1.61 | 289.82 |
| literal: a word in any case | 217 | 15026.58 ± 1.0% | 2089.41 ± 0.1% | 21.07 ± 0.9% | 3964.89 ± 0.2% | 39.29 ± 4.2% | refused | differs | 15037.09 ± 0.9% | 7.19 | 1.00 | 3.79 | 382.48 |
| literal: an href attribute | 33 | 16860.40 ± 3.0% | 609.16 ± 0.3% | 26.55 ± 0.3% | 16746.27 ± 2.1% | 2257.91 ± 0.4% | 13.36 ± 0.3% | 74.16 ± 0.1% | 16721.84 ± 2.5% | 27.68 | 1.01 | 1.01 | 7.47 |
| literal: a word, second text | 123 | 19743.73 ± 3.1% | 3391.12 ± 0.2% | 27.26 ± 0.1% | 18129.58 ± 1.5% | 7598.05 ± 6.0% | 19.05 ± 0.4% | 70.30 ± 0.2% | 19538.21 ± 2.6% | 5.82 | 1.01 | 1.09 | 2.60 |
| class: two capitalized words | 1331 | 1069.90 ± 0.3% | 598.79 ± 0.5% | 25.32 ± 0.1% | 585.30 ± 0.1% | 40.63 ± 2.7% | 14.85 ± 0.4% | 67.42 ± 0.2% | 1070.53 ± 0.4% | 1.79 | 1.00 | 1.83 | 26.33 |
| class: a word that ends in ing | 3399 | 573.40 ± 0.3% | 572.77 ± 0.3% | 17.71 ± 0.1% | 547.75 ± 0.1% | 29.07 ± 4.9% | 8.16 ± 0.1% | 18.43 ± 0.1% | 573.49 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.73 |
| class: a word in capitals | 2332 | 1376.94 ± 1.0% | 604.46 ± 0.2% | 26.82 ± 0.2% | 572.59 ± 0.1% | 43.58 ± 18.2% | 16.94 ± 0.4% | 82.67 ± 0.4% | 1380.29 ± 0.4% | 2.28 | 1.00 | 2.40 | 31.60 |
| class: a number | 8288 | 1999.71 ± 0.3% | 829.17 ± 0.2% | 27.05 ± 0.2% | 1731.81 ± 0.4% | 43.63 ± 12.2% | 0.57 ± 0.1% | 57.53 ± 0.3% | 2001.36 ± 0.1% | 2.41 | 1.00 | 1.15 | 45.83 |
| class: two capitalized words, second text | 5359 | 516.65 ± 0.2% | 524.49 ± 0.3% | 22.69 ± 0.1% | 485.26 ± 0.1% | 34.99 ± 6.0% | 16.32 ± 0.3% | 62.76 ± 0.1% | 516.17 ± 0.2% | 0.99 | 1.00 | 1.06 | 14.77 |
| other: a word between two words | 6104 | 792.96 ± 0.1% | 592.84 ± 0.2% | 22.98 ± 0.2% | 735.33 ± 0.2% | 107.37 ± 10.3% | 11.26 ± 0.1% | 68.34 ± 0.2% | 792.12 ± 0.2% | 1.34 | 1.00 | 1.08 | 7.39 |
| other: a number before a unit, second text | 1481 | 5965.99 ± 1.3% | 1122.32 ± 0.4% | 25.40 ± 0.2% | 5646.54 ± 0.2% | 40.73 ± 9.7% | 17.41 ± 0.2% | 65.77 ± 0.2% | 5963.70 ± 1.4% | 5.32 | 1.00 | 1.06 | 146.48 |
| other: a heading's start tag | 110 | 14162.52 ± 2.0% | 743.82 ± 0.3% | 26.78 ± 0.2% | 1711.03 ± 0.2% | 1573.73 ± 6.7% | 16.30 ± 0.5% | 86.56 ± 0.5% | 14169.08 ± 1.0% | 19.04 | 1.00 | 8.28 | 9.00 |
| other: a whole word | 217 | 16050.82 ± 3.0% | 603.60 ± 0.4% | 28.61 ± 0.6% | 14479.42 ± 2.2% | 49.46 ± 0.3% | 13.82 ± 0.1% | 54.77 ± 0.5% | 16030.16 ± 1.5% | 26.59 | 1.00 | 1.11 | 324.55 |
| other: a line's first word, second text | 3716 | 2038.77 ± 0.3% | 587.73 ± 0.2% | 30.01 ± 0.2% | 1720.86 ± 0.9% | 63.40 ± 4.2% | refused | refused | 2046.80 ± 0.9% | 3.47 | 1.00 | 1.18 | 32.16 |
| other: fourteen octets before an x | 87 | 23673.69 ± 1.9% | 251.44 ± 0.3% | 6.28 ± 0.1% | 4015.53 ± 1.9% | 10.65 ± 0.2% | differs | 17.77 ± 0.2% | 23707.53 ± 7.6% | 94.15 | 1.00 | 5.90 | 2223.37 |
| other: a Greek word | 21815 | 498.21 ± 0.4% | 413.34 ± 0.3% | 30.25 ± 0.1% | 289.98 ± 0.1% | 49.64 ± 13.5% | differs | refused | 500.23 ± 0.4% | 1.21 | 1.00 | 1.72 | 10.04 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.58 ± 0.3% | 19.53 ± 0.2% | 0.85 ± 0.1% | 19.73 ± 0.5% | 2.76 ± 1.2% | differs | 4.05 ± 0.2% | 19.51 ± 0.5% | 1.00 | 1.00 | 0.99 | 7.11 |
| a UUID | 32895 | 21.15 ± 0.3% | 21.09 ± 0.1% | 0.64 ± 0.2% | 15.09 ± 0.5% | 3.10 ± 0.2% | 0.72 ± 0.4% | 3.64 ± 0.9% | 21.10 ± 0.2% | 1.00 | 1.00 | 1.40 | 6.82 |
| an IPv4 address | 33176 | 35.96 ± 0.3% | 35.93 ± 0.2% | 2.05 ± 0.3% | 28.85 ± 0.3% | 6.66 ± 0.3% | differs | 4.16 ± 0.1% | 35.92 ± 0.3% | 1.00 | 1.00 | 1.25 | 5.40 |
| a date and time | 32954 | 31.00 ± 0.5% | 31.08 ± 0.7% | 1.43 ± 0.2% | 21.13 ± 0.7% | 7.04 ± 0.2% | 1.20 ± 0.1% | 7.11 ± 0.7% | 30.99 ± 0.6% | 1.00 | 1.00 | 1.47 | 4.41 |
| a field path | 32606 | 23.19 ± 0.1% | 23.12 ± 0.1% | 1.00 ± 0.4% | 23.03 ± 0.3% | 3.50 ± 0.8% | differs | 2.98 ± 0.3% | 23.11 ± 0.1% | 1.00 | 1.00 | 1.01 | 6.62 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.17 ± 0.9% | 11.15 ± 0.4% | 11.17 ± 0.2% | 11.50 ± 0.2% | 4.94 ± 0.9% | 0.92 ± 0.8% | none | 10.99 ± 2.0% | 1.00 | 1.02 | 0.97 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 224.85 ± 1.0% | 226.45 ± 0.7% | 275.57 ± 0.6% | 86.56 ± 0.7% | 216.36 ± 17.2% | 475.55 ± 1.0% | 3777.51 ± 0.3% | 225.14 ± 1.3% | 0.99 | 1.00 | 2.60 | 1.04 |
| a UUID | 62 | 148.15 ± 0.8% | 148.50 ± 0.7% | 169.42 ± 0.4% | 45.99 ± 1.0% | 96.69 ± 24.7% | 187.07 ± 3.6% | 4151.85 ± 1.1% | 147.73 ± 1.4% | 1.00 | 1.00 | 3.22 | 1.53 |
| an IPv4 address | 29 | 405.18 ± 0.5% | 410.42 ± 0.4% | 593.18 ± 0.4% | 77.15 ± 1.1% | 129.21 ± 1.6% | 291.94 ± 1.0% | 7457.29 ± 0.4% | 405.80 ± 0.1% | 0.99 | 1.00 | 5.25 | 3.14 |
| a date and time | 56 | 293.99 ± 0.2% | 296.51 ± 0.2% | 381.46 ± 0.2% | 72.28 ± 0.1% | 135.89 ± 1.6% | 323.48 ± 2.6% | 4775.66 ± 0.6% | 294.29 ± 0.2% | 0.99 | 1.00 | 4.07 | 2.16 |
| a field path | 39 | 216.50 ± 0.6% | 218.44 ± 0.7% | 264.44 ± 0.2% | 79.23 ± 2.6% | 201.99 ± 0.9% | 509.80 ± 5.0% | 4841.36 ± 1.1% | 217.29 ± 0.9% | 0.99 | 1.00 | 2.73 | 1.07 |
| literal: a word | 7 | 595.45 ± 0.2% | 641.17 ± 0.4% | 1219.35 ± 0.7% | 501.00 ± 0.4% | 617.54 ± 1.6% | 962.76 ± 0.4% | 29762.86 ± 0.2% | 596.34 ± 0.6% | 0.93 | 1.00 | 1.19 | 0.96 |
| literal: a word that is not there | 8 | 574.40 ± 0.5% | 623.36 ± 0.5% | 1147.45 ± 0.6% | 457.98 ± 0.3% | 595.39 ± 2.0% | 907.88 ± 0.6% | 28809.10 ± 0.2% | 574.01 ± 0.3% | 0.92 | 1.00 | 1.25 | 0.96 |
| literal: one of four words | 26 | 235.48 ± 0.5% | 384.74 ± 0.4% | 541.59 ± 0.3% | 49.47 ± 0.9% | 239.92 ± 2.6% | 366.86 ± 0.3% | 15788.08 ± 0.2% | 235.48 ± 0.2% | 0.61 | 1.00 | 4.76 | 0.98 |
| literal: a word in any case | 11 | 432.83 ± 0.2% | 461.42 ± 0.2% | 707.35 ± 0.1% | 15.50 ± 0.3% | 636.87 ± 1.6% | refused | 23500.49 ± 0.3% | 432.65 ± 0.2% | 0.94 | 1.00 | 27.93 | 0.68 |
| literal: an href attribute | 12 | 329.21 ± 0.7% | 341.00 ± 0.7% | 465.42 ± 0.7% | 43.98 ± 0.2% | 488.19 ± 1.1% | 773.81 ± 0.5% | 21626.97 ± 0.5% | 329.92 ± 0.2% | 0.97 | 1.00 | 7.49 | 0.67 |
| literal: a word, second text | 10 | 533.58 ± 0.4% | 584.66 ± 0.7% | 1029.77 ± 0.8% | 417.79 ± 2.1% | 525.91 ± 2.1% | 791.31 ± 0.6% | 26689.54 ± 0.1% | 532.24 ± 0.5% | 0.91 | 1.00 | 1.28 | 1.01 |
| class: two capitalized words | 23 | 414.81 ± 0.2% | 448.93 ± 0.2% | 672.12 ± 0.6% | 100.18 ± 0.3% | 495.45 ± 0.8% | 737.34 ± 0.6% | 6434.45 ± 0.5% | 414.61 ± 0.3% | 0.92 | 1.00 | 4.14 | 0.84 |
| class: a word that ends in ing | 9 | 518.41 ± 0.3% | 587.82 ± 0.3% | 1089.62 ± 0.3% | 132.90 ± 1.8% | 748.85 ± 1.4% | 1130.55 ± 0.4% | 15705.14 ± 1.3% | 518.51 ± 0.3% | 0.88 | 1.00 | 3.90 | 0.69 |
| class: a word in capitals | 16 | 460.23 ± 0.3% | 504.69 ± 0.5% | 849.58 ± 0.4% | 137.18 ± 0.8% | 741.86 ± 2.9% | 1043.63 ± 0.8% | 8483.52 ± 0.2% | 460.32 ± 0.4% | 0.91 | 1.00 | 3.35 | 0.62 |
| class: a number | 6 | 577.04 ± 0.5% | 649.17 ± 0.6% | 1303.75 ± 0.0% | 41.90 ± 1.0% | 1389.93 ± 1.2% | 1868.04 ± 0.7% | 22480.64 ± 0.3% | 576.62 ± 0.4% | 0.89 | 1.00 | 13.77 | 0.42 |
| class: two capitalized words, second text | 23 | 415.03 ± 0.9% | 449.10 ± 0.5% | 671.66 ± 0.5% | 99.98 ± 0.5% | 494.95 ± 0.9% | 736.41 ± 1.1% | 6450.32 ± 0.3% | 414.96 ± 0.3% | 0.92 | 1.00 | 4.15 | 0.84 |
| other: a word between two words | 13 | 514.88 ± 0.3% | 534.15 ± 0.1% | 889.75 ± 0.1% | 131.95 ± 0.3% | 497.83 ± 1.6% | 803.96 ± 0.3% | 14515.79 ± 0.5% | 514.57 ± 0.3% | 0.96 | 1.00 | 3.90 | 1.03 |
| other: a number before a unit, second text | 15 | 376.76 ± 0.3% | 417.53 ± 0.6% | 609.15 ± 0.3% | 39.28 ± 1.1% | 625.19 ± 1.4% | 896.26 ± 1.3% | 15099.90 ± 0.4% | 377.15 ± 0.7% | 0.90 | 1.00 | 9.59 | 0.60 |
| other: a heading's start tag | 13 | 343.19 ± 0.9% | 350.60 ± 0.3% | 474.99 ± 0.5% | 42.14 ± 0.7% | 614.78 ± 2.6% | 860.64 ± 1.1% | 17781.45 ± 0.5% | 343.12 ± 0.4% | 0.98 | 1.00 | 8.14 | 0.56 |
| other: a whole word | 11 | 552.40 ± 0.2% | 588.99 ± 0.3% | 1035.31 ± 0.1% | 119.85 ± 1.5% | 559.84 ± 2.0% | 831.62 ± 0.6% | 26908.91 ± 0.2% | 552.78 ± 0.4% | 0.94 | 1.00 | 4.61 | 0.99 |
| other: a line's first word, second text | 17 | 494.98 ± 0.9% | 518.96 ± 0.4% | 874.70 ± 1.2% | 127.98 ± 0.3% | 702.96 ± 1.4% | refused | refused | 497.14 ± 0.4% | 0.95 | 1.00 | 3.87 | 0.70 |
| other: fourteen octets before an x | 16 | 107.38 ± 0.5% | 152.73 ± 0.9% | 179.54 ± 0.8% | 14.50 ± 0.7% | 448.44 ± 2.5% | 406.58 ± 2.0% | 12677.94 ± 2.5% | 107.51 ± 1.3% | 0.70 | 1.00 | 7.41 | 0.24 |
| other: a Greek word | 8 | 405.58 ± 0.1% | 558.31 ± 0.2% | 999.17 ± 1.0% | 56.46 ± 0.4% | 1358.13 ± 4.2% | 1810.35 ± 0.9% | refused | 406.19 ± 0.2% | 0.73 | 1.00 | 7.18 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15702.45 ± 4.4% | not timed | not timed | 16287.70 ± 1.6% | 1927.37 ± 19.4% | not timed | not timed | 15659.82 ± 2.0% | | 1.00 | 0.96 | 8.15 |
| 01-literal/sherlock-casei-en | 522 | 11067.24 ± 7.1% | not timed | not timed | 3594.52 ± 0.1% | 31.48 ± 0.3% | not timed | not timed | 11035.65 ± 3.6% | | 1.00 | 3.08 | 351.57 |
| 01-literal/sherlock-ru | 724 | 17128.13 ± 0.5% | not timed | not timed | 17216.29 ± 0.7% | 1511.89 ± 4.7% | not timed | not timed | 17132.45 ± 0.3% | | 1.00 | 0.99 | 11.33 |
| 01-literal/sherlock-casei-ru | 746 | 6172.46 ± 0.1% | not timed | not timed | 3330.85 ± 0.1% | 30.69 ± 0.5% | not timed | not timed | 6186.31 ± 0.3% | | 1.00 | 1.85 | 201.10 |
| 01-literal/sherlock-zh | 30 | 19297.63 ± 0.8% | not timed | not timed | 18356.53 ± 0.9% | 2634.31 ± 14.6% | not timed | not timed | 19336.91 ± 0.8% | | 1.00 | 1.05 | 7.33 |
| 02-literal-alternate/sherlock-en | 714 | 6065.32 ± 0.5% | not timed | not timed | 3941.28 ± 0.2% | 15.92 ± 10.5% | not timed | not timed | 6050.88 ± 0.9% | | 1.00 | 1.54 | 380.99 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1984.92 ± 0.6% | not timed | not timed | 699.15 ± 0.2% | 10.79 ± 2.7% | not timed | not timed | 1981.14 ± 0.7% | | 1.00 | 2.84 | 183.98 |
| 02-literal-alternate/sherlock-ru | 899 | 5556.10 ± 0.2% | not timed | not timed | 3261.79 ± 0.2% | 21.98 ± 0.2% | not timed | not timed | 5562.81 ± 0.1% | | 1.00 | 1.70 | 252.74 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2057.14 ± 0.7% | not timed | not timed | 1232.26 ± 0.1% | 9.03 ± 0.1% | not timed | not timed | 2047.63 ± 0.5% | | 1.00 | 1.67 | 227.79 |
| 02-literal-alternate/sherlock-zh | 207 | 7312.55 ± 0.3% | not timed | not timed | 4161.62 ± 0.1% | 30.39 ± 0.3% | not timed | not timed | 7303.15 ± 0.5% | | 1.00 | 1.76 | 240.66 |
| 03-date/ascii | 111817 | 124.27 ± 0.8% | not timed | not timed | 96.47 ± 0.2% | 0.20 ± 1.2% | not timed | not timed | 124.76 ± 0.9% | | 1.00 | 1.29 | 613.75 |
| 04-ruff-noqa/real | 84 | 404.12 ± 0.1% | not timed | not timed | 459.65 ± 0.0% | 19.51 ± 2.1% | not timed | not timed | 404.61 ± 0.1% | | 1.00 | 0.88 | 20.71 |
| 04-ruff-noqa/tweaked | 44 | 559.61 ± 0.6% | not timed | not timed | 462.45 ± 0.1% | 366.62 ± 0.3% | not timed | not timed | 557.61 ± 0.2% | | 1.00 | 1.21 | 1.53 |
| 05-lexer-veryl/single | 124800 | 5.31 ± 6.6% | not timed | not timed | 5.03 ± 0.2% | 0.21 ± 3.7% | not timed | not timed | 5.31 ± 3.9% | | 1.00 | 1.06 | 25.72 |
| 06-cloud-flare-redos/original | 107 | 410.68 ± 0.3% | not timed | not timed | 216.49 ± 0.1% | 24.80 ± 0.2% | not timed | not timed | 410.75 ± 0.1% | | 1.00 | 1.90 | 16.56 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.97 ± 0.3% | not timed | not timed | 227.09 ± 0.1% | 26.58 ± 0.1% | not timed | not timed | 410.08 ± 0.3% | | 1.01 | 1.83 | 15.65 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.91 ± 0.1% | not timed | not timed | 254.92 ± 0.1% | 28.68 ± 1.1% | not timed | not timed | 578.34 ± 0.1% | | 1.02 | 2.31 | 20.50 |
| 07-unicode-character-data/parse-line | 558784 | 235.47 ± 1.3% | not timed | not timed | 172.28 ± 0.1% | 43.00 ± 2.9% | not timed | not timed | 243.52 ± 0.6% | | 0.97 | 1.37 | 5.48 |
| 08-words/all-english | 56691 | 116.22 ± 0.6% | not timed | not timed | 83.50 ± 0.1% | 11.98 ± 14.3% | not timed | not timed | 116.31 ± 0.7% | | 1.00 | 1.39 | 9.70 |
| 08-words/long-english | 839 | 614.90 ± 0.3% | not timed | not timed | 596.16 ± 0.1% | 32.50 ± 0.5% | not timed | not timed | 614.11 ± 0.4% | | 1.00 | 1.03 | 18.92 |
| 09-aws-keys/full | 0 | 409.06 ± 0.1% | not timed | not timed | 464.34 ± 0.1% | 64.60 ± 0.1% | not timed | not timed | 410.16 ± 0.1% | | 1.00 | 0.88 | 6.33 |
| 09-aws-keys/quick | 0 | 873.41 ± 0.1% | not timed | not timed | 985.44 ± 0.5% | 423.19 ± 1.4% | not timed | not timed | 874.55 ± 0.4% | | 1.00 | 0.89 | 2.06 |
| 10-bounded-repeat/letters-en | 1833 | 573.18 ± 1.8% | not timed | not timed | 516.58 ± 0.5% | 19.57 ± 0.5% | not timed | not timed | 579.03 ± 3.1% | | 0.99 | 1.11 | 29.29 |
| 10-bounded-repeat/letters-ru | 3475 | 509.30 ± 1.5% | not timed | not timed | 478.24 ± 0.2% | 21.95 ± 9.2% | not timed | not timed | 509.57 ± 1.3% | | 1.00 | 1.06 | 23.20 |
| 10-bounded-repeat/context | 53 | 85.38 ± 1.9% | not timed | not timed | 65.73 ± 0.5% | 19.82 ± 0.1% | not timed | not timed | 85.26 ± 1.7% | | 1.00 | 1.30 | 4.31 |
| 10-bounded-repeat/capitals | 11 | 641.65 ± 7.8% | not timed | not timed | 618.52 ± 0.1% | 36.59 ± 0.1% | not timed | not timed | 640.89 ± 8.0% | | 1.00 | 1.04 | 17.53 |
| 11-unstructured-to-json/extract | 600 | 56.81 ± 0.5% | not timed | not timed | 77.90 ± 0.2% | 49.02 ± 1.3% | not timed | not timed | 56.95 ± 0.2% | | 1.00 | 0.73 | 1.16 |
| 12-dictionary/single | 1 | 567.77 ± 0.4% | not timed | not timed | 560.04 ± 0.1% | 0.41 ± 0.1% | not timed | not timed | 569.08 ± 0.2% | | 1.00 | 1.01 | 1393.03 |
| 14-quadratic/1x | 100 | 21.17 ± 1.1% | not timed | not timed | 10.01 ± 0.4% | 0.98 ± 3.0% | not timed | not timed | 21.16 ± 2.3% | | 1.00 | 2.11 | 21.60 |
| 14-quadratic/2x | 200 | 17.43 ± 0.6% | not timed | not timed | 5.53 ± 0.3% | 0.54 ± 2.1% | not timed | not timed | 17.41 ± 0.8% | | 1.00 | 3.15 | 32.50 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.7% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.6% | not timed | not timed | 7.69 ± 0.6% | | 1.00 | 6.37 | 66.72 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.22 ± 2.0% | not timed | not timed | 0.34 ± 0.6% | 0.55 ± 3.9% | not timed | not timed | 1.22 ± 0.9% | | 1.00 | 3.55 | 2.21 |
| 04-ruff-noqa/compile-real | 1 | 104.79 ± 0.4% | not timed | not timed | 13.72 ± 0.3% | 139.45 ± 3.1% | not timed | not timed | 104.75 ± 1.4% | | 1.00 | 7.64 | 0.75 |
| 05-lexer-veryl/compile-single | 1 | 14.00 ± 0.4% | not timed | not timed | 2.53 ± 0.5% | 6.45 ± 2.2% | not timed | not timed | 14.05 ± 0.4% | | 1.00 | 5.54 | 2.17 |
| 07-unicode-character-data/compile | 1 | 106.86 ± 1.4% | not timed | not timed | 25.58 ± 0.5% | 36.88 ± 2.9% | not timed | not timed | 107.16 ± 1.4% | | 1.00 | 4.18 | 2.90 |
| 09-aws-keys/compile-full | 1 | 52.59 ± 1.5% | not timed | not timed | 8.21 ± 0.5% | 23.42 ± 2.3% | not timed | not timed | 52.90 ± 0.5% | | 0.99 | 6.41 | 2.25 |
| 09-aws-keys/compile-quick | 1 | 181.44 ± 0.4% | not timed | not timed | 47.23 ± 0.4% | 135.80 ± 3.6% | not timed | not timed | 181.55 ± 1.1% | | 1.00 | 3.84 | 1.34 |
| 10-bounded-repeat/compile-context | 1 | 70.42 ± 2.0% | not timed | not timed | 11.20 ± 0.2% | 16.21 ± 1.7% | not timed | not timed | 71.42 ± 0.4% | | 0.99 | 6.29 | 4.34 |
| 10-bounded-repeat/compile-capitals | 1 | 84.13 ± 1.3% | not timed | not timed | 8.01 ± 0.4% | 24.01 ± 1.5% | not timed | not timed | 83.81 ± 0.7% | | 1.00 | 10.50 | 3.50 |
| 11-unstructured-to-json/compile | 1 | 168.93 ± 1.2% | not timed | not timed | 40.88 ± 0.6% | 69.53 ± 3.1% | not timed | not timed | 169.01 ± 0.3% | | 1.00 | 4.13 | 2.43 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.2% | not timed | not timed | 0.07 ± 12.3% | 0.09 ± 9.0% | not timed | not timed | 0.35 ± 0.6% | | 0.99 | 5.07 | 3.68 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.45 ± 5.4% | not timed | not timed | 6.49 ± 0.2% | 0.58 ± 22.3% | not timed | not timed | 7.53 ± 2.1% | | 0.99 | 1.15 | 12.78 |
| dictionary/search/english-10 | 690 | 1.05 ± 0.3% | not timed | not timed | 165.64 ± 1.3% | 0.00 ± 0.3% | not timed | not timed | 1.05 ± 0.6% | | 1.00 | 0.0063 | 384.21 |
| dictionary/search/english-15 | 15 | 559.10 ± 0.5% | not timed | not timed | 561.42 ± 0.3% | 0.37 ± 0.2% | not timed | not timed | 561.57 ± 0.3% | | 1.00 | 1.00 | 1522.36 |
| folly/awyer-inn-busted | 1 | 5588.37 ± 0.1% | not timed | not timed | 141.69 ± 0.2% | 43.77 ± 0.3% | not timed | not timed | 5574.17 ± 0.2% | | 1.00 | 39.44 | 127.69 |
| folly/literal-never-match-rare | 0 | 21139.05 ± 0.8% | not timed | not timed | 19948.47 ± 0.3% | 40896.24 ± 0.8% | not timed | not timed | 21149.31 ± 0.1% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12552.56 ± 2.0% | not timed | not timed | 19876.53 ± 0.1% | 2185.89 ± 1.0% | not timed | not timed | 12580.56 ± 1.5% | | 1.00 | 0.63 | 5.74 |
| folly/literal-never-match-tricksy | 1 | 3258.25 ± 0.3% | not timed | not timed | 4412.97 ± 0.2% | 2992.88 ± 2.5% | not timed | not timed | 3239.32 ± 0.5% | | 1.01 | 0.74 | 1.09 |
| grep/every-line | 239963 | 1313.42 ± 0.6% | not timed | not timed | 952.96 ± 0.3% | 385.15 ± 18.4% | not timed | not timed | 1315.44 ± 0.7% | | 1.00 | 1.38 | 3.41 |
| grep/long-words-ascii | 5073 | 459.72 ± 0.2% | not timed | not timed | 468.70 ± 0.2% | 46.31 ± 6.9% | not timed | not timed | 460.07 ± 0.4% | | 1.00 | 0.98 | 9.93 |
| imported/leipzig/twain | 811 | 20733.78 ± 1.3% | not timed | not timed | 19639.26 ± 0.6% | 11988.53 ± 10.2% | not timed | not timed | 20756.31 ± 0.5% | | 1.00 | 1.06 | 1.73 |
| imported/leipzig/twain-insensitive | 965 | 9062.04 ± 1.4% | not timed | not timed | 4253.96 ± 0.1% | 37.79 ± 0.8% | not timed | not timed | 9094.49 ± 1.5% | | 1.00 | 2.13 | 239.82 |
| imported/leipzig/shing | 1540 | 629.75 ± 0.2% | not timed | not timed | 13275.04 ± 2.3% | 34.08 ± 0.1% | not timed | not timed | 632.33 ± 0.2% | | 1.00 | 0.0474 | 18.48 |
| imported/leipzig/huck-saw | 262 | 8267.72 ± 3.0% | not timed | not timed | 5604.94 ± 0.2% | 30.99 ± 0.1% | not timed | not timed | 8477.49 ± 2.8% | | 0.98 | 1.48 | 266.82 |
| imported/leipzig/word-ending-nn | 262 | 607.73 ± 0.2% | not timed | not timed | 616.01 ± 0.3% | 24.49 ± 0.6% | not timed | not timed | 611.46 ± 1.6% | | 0.99 | 0.99 | 24.81 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10916.80 ± 0.6% | not timed | not timed | 4533.37 ± 0.6% | 11.51 ± 0.1% | not timed | not timed | 11081.98 ± 1.2% | | 0.99 | 2.41 | 948.38 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7777.83 ± 2.2% | not timed | not timed | 5492.20 ± 0.1% | 16.89 ± 0.1% | not timed | not timed | 7910.71 ± 2.6% | | 0.98 | 1.42 | 460.53 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4169.06 ± 1.8% | not timed | not timed | 416.75 ± 1.0% | 11.09 ± 0.0% | not timed | not timed | 4217.86 ± 1.7% | | 0.99 | 10.00 | 375.92 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 610.18 ± 0.1% | not timed | not timed | 615.21 ± 0.1% | 11.14 ± 0.0% | not timed | not timed | 609.27 ± 0.2% | | 1.00 | 0.99 | 54.80 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.70 ± 0.1% | not timed | not timed | 615.64 ± 0.1% | 9.76 ± 0.1% | not timed | not timed | 610.30 ± 0.2% | | 1.00 | 0.99 | 62.49 |
| imported/leipzig/tom-river | 2 | 6521.16 ± 2.6% | not timed | not timed | 5150.78 ± 0.2% | 31.00 ± 0.1% | not timed | not timed | 6580.25 ± 1.9% | | 0.99 | 1.27 | 210.38 |
| imported/leipzig/ing | 78424 | 608.84 ± 0.4% | not timed | not timed | 571.03 ± 0.3% | 28.27 ± 3.2% | not timed | not timed | 607.94 ± 0.6% | | 1.00 | 1.07 | 21.54 |
| imported/leipzig/ing-whitespace | 55248 | 758.43 ± 1.0% | not timed | not timed | 2079.47 ± 0.3% | 20.50 ± 2.9% | not timed | not timed | 758.59 ± 0.6% | | 1.00 | 0.36 | 37.00 |
| imported/leipzig/awyer-inn | 209 | 771.22 ± 1.1% | not timed | not timed | 4264.12 ± 0.7% | 22.71 ± 0.0% | not timed | not timed | 775.25 ± 1.4% | | 0.99 | 0.18 | 33.97 |
| imported/leipzig/quotes-bounded | 8886 | 2127.13 ± 0.5% | not timed | not timed | 3024.07 ± 0.6% | 38.23 ± 0.1% | not timed | not timed | 2123.83 ± 0.5% | | 1.00 | 0.70 | 55.64 |
| imported/leipzig/non-ascii-alternate | 2 | 12855.41 ± 2.1% | not timed | not timed | 5675.37 ± 0.0% | 50.52 ± 0.2% | not timed | not timed | 13105.49 ± 2.3% | | 0.98 | 2.27 | 254.44 |
| imported/leipzig/math-symbols | 69 | 1974.14 ± 0.6% | not timed | not timed | 619.28 ± 0.1% | 36.44 ± 0.0% | not timed | not timed | 1969.49 ± 0.4% | | 1.00 | 3.19 | 54.17 |
| imported/leipzig/bounded-strings-ending-z | 0 | 596.85 ± 0.4% | not timed | not timed | 617.94 ± 0.1% | 22.59 ± 0.2% | not timed | not timed | 595.33 ± 0.4% | | 1.00 | 0.97 | 26.42 |
| imported/lh3lh3-reb/uri | 17549 | 632.16 ± 0.1% | not timed | not timed | 1061.11 ± 0.1% | 28.29 ± 2.2% | not timed | not timed | 633.24 ± 0.1% | | 1.00 | 0.60 | 22.35 |
| imported/lh3lh3-reb/email | 15057 | 668.67 ± 0.0% | not timed | not timed | 1147.53 ± 0.4% | 30.92 ± 2.7% | not timed | not timed | 668.56 ± 0.2% | | 1.00 | 0.58 | 21.63 |
| imported/lh3lh3-reb/date | 668 | 865.84 ± 0.1% | not timed | not timed | 1035.69 ± 0.3% | 50.13 ± 3.9% | not timed | not timed | 865.40 ± 0.3% | | 1.00 | 0.84 | 17.27 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.66 ± 0.6% | not timed | not timed | 422.10 ± 0.1% | 15.81 ± 1.4% | not timed | not timed | 643.23 ± 0.2% | | 1.00 | 1.52 | 40.64 |
| imported/mariomka/email | 92 | 689.53 ± 0.8% | not timed | not timed | 29859.61 ± 1.1% | 32.53 ± 0.8% | not timed | not timed | 705.65 ± 0.3% | | 0.98 | 0.0231 | 21.20 |
| imported/mariomka/uri | 5301 | 607.17 ± 0.2% | not timed | not timed | 6051.62 ± 0.9% | 32.67 ± 0.4% | not timed | not timed | 605.53 ± 0.2% | | 1.00 | 0.10 | 18.59 |
| imported/mariomka/ip | 5 | 2125.41 ± 2.7% | not timed | not timed | 2964.53 ± 0.4% | 21.05 ± 0.4% | not timed | not timed | 2156.08 ± 2.5% | | 0.99 | 0.72 | 100.95 |
| imported/rsc/no-exponential | 0 | 566.79 ± 0.3% | not timed | not timed | 317.00 ± 0.1% | 23.78 ± 0.2% | not timed | not timed | 568.69 ± 0.3% | | 1.00 | 1.79 | 23.83 |
| imported/rsc/literal | 1 | 738.53 ± 2.9% | not timed | not timed | 1615.76 ± 3.5% | 187.38 ± 20.8% | not timed | not timed | 742.82 ± 5.6% | | 0.99 | 0.46 | 3.94 |
| imported/rsc/not-literal | 2 | 706.86 ± 0.2% | not timed | not timed | 727.75 ± 0.6% | 46.35 ± 3.8% | not timed | not timed | 695.02 ± 7.1% | | 1.02 | 0.97 | 15.25 |
| imported/rsc/match-class | 1 | 1304.74 ± 0.1% | not timed | not timed | 1634.84 ± 0.4% | 58.89 ± 14.5% | not timed | not timed | 1214.44 ± 2.2% | | 1.07 | 0.80 | 22.16 |
| imported/rsc/match-class-in-range | 1 | 1311.14 ± 0.2% | not timed | not timed | 2363.11 ± 2.0% | 60.12 ± 7.4% | not timed | not timed | 1216.99 ± 2.2% | | 1.08 | 0.55 | 21.81 |
| imported/rsc/match-class-unicode | 1 | 524.96 ± 0.2% | not timed | not timed | 512.39 ± 0.1% | 72.32 ± 0.8% | not timed | not timed | 525.16 ± 0.2% | | 1.00 | 1.02 | 7.26 |
| imported/rsc/anchored-literal-short-non-match | 0 | 535.27 ± 1.0% | not timed | not timed | 940.88 ± 0.1% | 227.07 ± 0.9% | not timed | not timed | 532.63 ± 0.8% | | 1.00 | 0.57 | 2.36 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7944.53 ± 0.1% | not timed | not timed | 14269.46 ± 0.1% | 3420.68 ± 1.2% | not timed | not timed | 7934.31 ± 0.2% | | 1.00 | 0.56 | 2.32 |
| imported/rsc/anchored-literal-short-match | 4 | 423.25 ± 2.5% | not timed | not timed | 484.13 ± 0.5% | 84.74 ± 7.3% | not timed | not timed | 420.95 ± 5.9% | | 1.01 | 0.87 | 4.99 |
| imported/rsc/anchored-literal-long-match | 4 | 2980.65 ± 2.2% | not timed | not timed | 7346.30 ± 0.6% | 1236.16 ± 9.5% | not timed | not timed | 3028.41 ± 2.2% | | 0.98 | 0.41 | 2.41 |
| imported/rsc/one-pass-short | 17 | 312.75 ± 2.1% | not timed | not timed | 215.50 ± 0.3% | 31.24 ± 9.7% | not timed | not timed | 312.96 ± 9.2% | | 1.00 | 1.45 | 10.01 |
| imported/rsc/one-pass-short-not | 17 | 219.34 ± 5.8% | not timed | not timed | 227.06 ± 0.5% | 30.61 ± 9.3% | not timed | not timed | 219.85 ± 1.9% | | 1.00 | 0.97 | 7.17 |
| imported/rsc/one-pass-long-prefix | 26 | 235.65 ± 10.2% | not timed | not timed | 286.49 ± 0.8% | 96.40 ± 15.0% | not timed | not timed | 236.53 ± 2.0% | | 1.00 | 0.82 | 2.44 |
| imported/rsc/one-pass-long-prefix-not | 26 | 314.40 ± 1.6% | not timed | not timed | 284.19 ± 0.3% | 61.23 ± 18.5% | not timed | not timed | 313.50 ± 1.8% | | 1.00 | 1.11 | 5.13 |
| imported/rsc/long-needle1 | 31 | 21956.88 ± 0.2% | not timed | not timed | 20176.76 ± 0.1% | 3.76 ± 0.2% | not timed | not timed | 21961.37 ± 0.2% | | 1.00 | 1.09 | 5840.47 |
| imported/rsc/long-needle2 | 31 | 22097.94 ± 0.1% | not timed | not timed | 216.56 ± 0.3% | 3.76 ± 0.1% | not timed | not timed | 22094.31 ± 0.1% | | 1.00 | 102.04 | 5873.87 |
| imported/rsc/easy0-32 | 26 | 1048.63 ± 3.4% | not timed | not timed | 1602.72 ± 4.1% | 147.50 ± 17.4% | not timed | not timed | 1047.90 ± 0.2% | | 1.00 | 0.65 | 7.11 |
| imported/rsc/easy0-1k | 26 | 14973.77 ± 2.0% | not timed | not timed | 12501.13 ± 1.9% | 2312.96 ± 12.5% | not timed | not timed | 14970.40 ± 0.1% | | 1.00 | 1.20 | 6.47 |
| imported/rsc/easy0-32k | 26 | 22948.38 ± 0.3% | not timed | not timed | 20382.04 ± 0.2% | 18810.75 ± 0.3% | not timed | not timed | 22939.87 ± 2.2% | | 1.00 | 1.13 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 21634.83 ± 2.4% | not timed | not timed | 19862.07 ± 1.8% | 36765.79 ± 8.2% | not timed | not timed | 21638.64 ± 3.2% | | 1.00 | 1.09 | 0.59 |
| imported/rsc/easy1-32 | 19 | 360.13 ± 2.4% | not timed | not timed | 642.48 ± 0.3% | 129.49 ± 21.2% | not timed | not timed | 361.78 ± 6.4% | | 1.00 | 0.56 | 2.78 |
| imported/rsc/easy1-1k | 19 | 582.94 ± 3.0% | not timed | not timed | 13065.51 ± 0.3% | 2495.17 ± 18.4% | not timed | not timed | 580.00 ± 0.3% | | 1.01 | 0.0446 | 0.23 |
| imported/rsc/easy1-32k | 19 | 602.72 ± 0.6% | not timed | not timed | 407439.17 ± 0.3% | 20455.46 ± 28.8% | not timed | not timed | 599.65 ± 3.1% | | 1.01 | 0.0015 | 0.0295 |
| imported/rsc/easy1-1mb | 19 | 603.35 ± 0.6% | not timed | not timed | 13148257.35 ± 0.3% | 38447.24 ± 2.3% | not timed | not timed | 599.48 ± 0.5% | | 1.01 | 0.0000 | 0.0157 |
| imported/rsc/medium-32 | 27 | 417.72 ± 0.6% | not timed | not timed | 639.15 ± 0.7% | 70.16 ± 15.6% | not timed | not timed | 425.61 ± 0.8% | | 0.98 | 0.65 | 5.95 |
| imported/rsc/medium-1k | 27 | 6662.28 ± 0.0% | not timed | not timed | 11399.92 ± 0.3% | 72.24 ± 0.1% | not timed | not timed | 6760.52 ± 0.3% | | 0.99 | 0.58 | 92.22 |
| imported/rsc/medium-32k | 27 | 21650.31 ± 0.1% | not timed | not timed | 352672.88 ± 0.0% | 48.51 ± 0.1% | not timed | not timed | 21574.04 ± 0.1% | | 1.00 | 0.0614 | 446.29 |
| imported/rsc/medium-1mb | 27 | 21095.29 ± 1.1% | not timed | not timed | 11268479.26 ± 0.1% | 48.51 ± 0.1% | not timed | not timed | 21056.66 ± 2.0% | | 1.00 | 0.0019 | 434.86 |
| imported/rsc/hard-32 | 58 | 256.35 ± 2.5% | not timed | not timed | 366.38 ± 0.3% | 49.74 ± 8.8% | not timed | not timed | 255.80 ± 0.2% | | 1.00 | 0.70 | 5.15 |
| imported/rsc/hard-1k | 27 | 580.62 ± 0.3% | not timed | not timed | 11561.37 ± 0.5% | 40.72 ± 10.4% | not timed | not timed | 578.39 ± 0.4% | | 1.00 | 0.0502 | 14.26 |
| imported/rsc/hard-32k | 27 | 602.53 ± 0.4% | not timed | not timed | 358744.90 ± 0.2% | 29.39 ± 0.0% | not timed | not timed | 598.25 ± 0.3% | | 1.01 | 0.0017 | 20.50 |
| imported/rsc/hard-1mb | 51 | 602.33 ± 0.6% | not timed | not timed | 7323423.77 ± 0.1% | 29.42 ± 0.1% | not timed | not timed | 598.91 ± 0.8% | | 1.01 | 0.0001 | 20.47 |
| imported/rsc/reallyhard0-32 | 58 | 254.81 ± 2.2% | not timed | not timed | 224.05 ± 0.1% | 49.66 ± 7.0% | not timed | not timed | 254.43 ± 0.2% | | 1.00 | 1.14 | 5.13 |
| imported/rsc/reallyhard0-1k | 27 | 576.33 ± 0.3% | not timed | not timed | 582.25 ± 0.2% | 40.88 ± 0.2% | not timed | not timed | 579.43 ± 0.4% | | 0.99 | 0.99 | 14.10 |
| imported/rsc/reallyhard0-32k | 27 | 600.99 ± 0.7% | not timed | not timed | 618.60 ± 0.1% | 29.34 ± 0.2% | not timed | not timed | 603.12 ± 0.5% | | 1.00 | 0.97 | 20.48 |
| imported/rsc/reallyhard0-1mb | 51 | 596.90 ± 0.8% | not timed | not timed | 616.31 ± 0.2% | 29.42 ± 0.1% | not timed | not timed | 592.94 ± 1.5% | | 1.01 | 0.97 | 20.29 |
| imported/rsc/reallyreallyhard0-32 | 47 | 274.16 ± 1.9% | not timed | not timed | 196.80 ± 2.0% | 60.69 ± 11.8% | not timed | not timed | 274.36 ± 0.3% | | 1.00 | 1.39 | 4.52 |
| imported/rsc/reallyreallyhard0-1k | 16 | 862.26 ± 2.3% | not timed | not timed | 5951.80 ± 0.1% | 34.16 ± 1.4% | not timed | not timed | 857.98 ± 0.8% | | 1.00 | 0.14 | 25.24 |
| imported/rsc/reallyreallyhard0-32k | 16 | 635.99 ± 6.0% | not timed | not timed | 19289.23 ± 0.1% | 24.54 ± 2.3% | not timed | not timed | 630.83 ± 7.1% | | 1.01 | 0.0330 | 25.92 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 595.34 ± 0.5% | not timed | not timed | 19580.51 ± 3.7% | 24.58 ± 2.1% | not timed | not timed | 586.93 ± 1.7% | | 1.01 | 0.0304 | 24.23 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 269.45 ± 2.8% | not timed | not timed | 214.75 ± 0.4% | 59.06 ± 11.3% | not timed | not timed | 268.95 ± 0.2% | | 1.00 | 1.25 | 4.56 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 843.57 ± 0.7% | not timed | not timed | 6256.90 ± 0.2% | 34.46 ± 1.4% | not timed | not timed | 841.50 ± 0.8% | | 1.00 | 0.13 | 24.48 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 625.44 ± 4.8% | not timed | not timed | 19229.43 ± 0.1% | 24.80 ± 1.9% | not timed | not timed | 622.45 ± 5.1% | | 1.00 | 0.0325 | 25.22 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 591.80 ± 1.1% | not timed | not timed | 19311.85 ± 1.4% | 24.95 ± 0.8% | not timed | not timed | 585.87 ± 1.2% | | 1.01 | 0.0306 | 23.72 |
| imported/sherlock/name-sherlock | 776 | 19747.49 ± 0.4% | not timed | not timed | 18603.58 ± 0.2% | 10208.42 ± 15.0% | not timed | not timed | 19747.04 ± 7.1% | | 1.00 | 1.06 | 1.93 |
| imported/sherlock/name-holmes | 2766 | 15262.90 ± 1.1% | not timed | not timed | 15558.81 ± 0.2% | 3318.64 ± 10.8% | not timed | not timed | 15294.92 ± 0.8% | | 1.00 | 0.98 | 4.60 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19773.89 ± 2.3% | not timed | not timed | 18608.11 ± 0.4% | 8129.33 ± 37.4% | not timed | not timed | 19761.03 ± 4.2% | | 1.00 | 1.06 | 2.43 |
| imported/sherlock/name-sherlock-casei | 816 | 15666.07 ± 0.5% | not timed | not timed | 4014.19 ± 0.1% | 32.58 ± 0.2% | not timed | not timed | 15662.68 ± 0.3% | | 1.00 | 3.90 | 480.81 |
| imported/sherlock/name-holmes-casei | 2802 | 9348.53 ± 9.9% | not timed | not timed | 3322.75 ± 0.0% | 37.99 ± 2.5% | not timed | not timed | 9254.38 ± 6.5% | | 1.01 | 2.81 | 246.07 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12947.76 ± 7.8% | not timed | not timed | 3952.09 ± 0.2% | 32.59 ± 0.5% | not timed | not timed | 12984.25 ± 0.7% | | 1.00 | 3.28 | 397.32 |
| imported/sherlock/name-whitespace | 1461 | 15124.41 ± 0.3% | not timed | not timed | 14453.81 ± 0.1% | 7437.75 ± 24.7% | not timed | not timed | 15091.81 ± 1.9% | | 1.00 | 1.05 | 2.03 |
| imported/sherlock/name-alt1 | 1142 | 11446.86 ± 2.1% | not timed | not timed | 16581.39 ± 1.3% | 4151.80 ± 52.5% | not timed | not timed | 11488.39 ± 0.3% | | 1.00 | 0.69 | 2.76 |
| imported/sherlock/name-alt2 | 3542 | 8612.95 ± 0.3% | not timed | not timed | 3811.72 ± 0.3% | 31.30 ± 0.2% | not timed | not timed | 8619.51 ± 0.3% | | 1.00 | 2.26 | 275.20 |
| imported/sherlock/name-alt3 | 4507 | 5453.10 ± 0.2% | not timed | not timed | 3612.01 ± 0.1% | 9.93 ± 3.2% | not timed | not timed | 5454.75 ± 0.3% | | 1.00 | 1.51 | 549.37 |
| imported/sherlock/name-alt3-casei | 4593 | 1518.72 ± 1.8% | not timed | not timed | 286.19 ± 0.4% | 6.48 ± 0.1% | not timed | not timed | 1517.35 ± 1.2% | | 1.00 | 5.31 | 234.51 |
| imported/sherlock/name-alt4 | 3686 | 6195.86 ± 0.2% | not timed | not timed | 3777.17 ± 0.2% | 31.43 ± 0.1% | not timed | not timed | 6207.27 ± 0.2% | | 1.00 | 1.64 | 197.14 |
| imported/sherlock/name-alt4-casei | 4254 | 2769.80 ± 3.9% | not timed | not timed | 2595.11 ± 0.3% | 19.91 ± 14.1% | not timed | not timed | 2756.85 ± 1.3% | | 1.00 | 1.07 | 139.10 |
| imported/sherlock/name-alt5 | 4028 | 6234.06 ± 0.3% | not timed | not timed | 3748.67 ± 0.2% | 21.68 ± 0.1% | not timed | not timed | 6235.71 ± 0.3% | | 1.00 | 1.66 | 287.51 |
| imported/sherlock/name-alt5-casei | 4104 | 3462.33 ± 2.7% | not timed | not timed | 2236.31 ± 0.1% | 14.35 ± 0.1% | not timed | not timed | 3467.47 ± 1.6% | | 1.00 | 1.55 | 241.31 |
| imported/sherlock/no-match-uncommon | 0 | 21621.06 ± 0.4% | not timed | not timed | 19619.49 ± 0.7% | 36456.67 ± 0.4% | not timed | not timed | 21595.25 ± 3.2% | | 1.00 | 1.10 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21306.55 ± 0.5% | not timed | not timed | 19612.87 ± 0.6% | 1277.17 ± 0.9% | not timed | not timed | 21312.98 ± 0.5% | | 1.00 | 1.09 | 16.68 |
| imported/sherlock/no-match-really-common | 0 | 16058.40 ± 2.7% | not timed | not timed | 18827.86 ± 0.4% | 1268.66 ± 0.6% | not timed | not timed | 16292.64 ± 1.5% | | 0.99 | 0.85 | 12.66 |
| imported/sherlock/the-lower | 21654 | 2317.27 ± 1.0% | not timed | not timed | 2338.26 ± 0.3% | 241.88 ± 18.8% | not timed | not timed | 2323.05 ± 0.9% | | 1.00 | 0.99 | 9.58 |
| imported/sherlock/the-upper | 2223 | 12713.48 ± 1.1% | not timed | not timed | 13637.76 ± 1.8% | 2716.96 ± 12.1% | not timed | not timed | 12752.56 ± 0.8% | | 1.00 | 0.93 | 4.68 |
| imported/sherlock/the-casei | 23961 | 2009.21 ± 1.1% | not timed | not timed | 1316.02 ± 0.3% | 34.52 ± 36.3% | not timed | not timed | 2013.55 ± 0.3% | | 1.00 | 1.53 | 58.20 |
| imported/sherlock/everything-greedy | 581881 | 270.21 ± 1.2% | not timed | not timed | 165.57 ± 0.2% | 29.05 ± 23.1% | not timed | not timed | 271.22 ± 0.5% | | 1.00 | 1.63 | 9.30 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.21 ± 0.1% | not timed | not timed | 212.19 ± 0.7% | 32.97 ± 0.1% | not timed | not timed | 463.27 ± 0.2% | | 1.00 | 2.18 | 14.02 |
| imported/sherlock/letters | 447175 | 54.40 ± 6.0% | not timed | not timed | 32.91 ± 0.2% | 5.46 ± 18.5% | not timed | not timed | 54.26 ± 0.5% | | 1.00 | 1.65 | 9.97 |
| imported/sherlock/letters-upper | 14180 | 432.59 ± 1.2% | not timed | not timed | 371.03 ± 0.2% | 28.51 ± 28.6% | not timed | not timed | 434.75 ± 0.3% | | 1.00 | 1.17 | 15.17 |
| imported/sherlock/letters-lower | 432995 | 55.45 ± 0.4% | not timed | not timed | 33.81 ± 0.2% | 5.74 ± 1.3% | not timed | not timed | 55.44 ± 0.6% | | 1.00 | 1.64 | 9.65 |
| imported/sherlock/words | 447639 | 107.00 ± 1.3% | not timed | not timed | 82.96 ± 0.2% | 14.43 ± 6.5% | not timed | not timed | 107.74 ± 0.8% | | 0.99 | 1.29 | 7.41 |
| imported/sherlock/before-holmes | 4073 | 596.97 ± 0.5% | not timed | not timed | 8527.76 ± 0.4% | 23.85 ± 1.2% | not timed | not timed | 597.95 ± 0.6% | | 1.00 | 0.0700 | 25.03 |
| imported/sherlock/before-after-holmes | 2593 | 595.95 ± 0.7% | not timed | not timed | 9333.35 ± 0.3% | 23.84 ± 2.2% | not timed | not timed | 597.84 ± 0.6% | | 1.00 | 0.0639 | 25.00 |
| imported/sherlock/holmes-cochar-watson | 150 | 5222.93 ± 0.2% | not timed | not timed | 3427.54 ± 0.1% | 30.45 ± 0.1% | not timed | not timed | 5228.95 ± 0.2% | | 1.00 | 1.52 | 171.54 |
| imported/sherlock/holmes-coword-watson | 14309 | 1266.99 ± 0.8% | not timed | not timed | 1124.52 ± 0.1% | 6.80 ± 0.3% | not timed | not timed | 1268.07 ± 0.4% | | 1.00 | 1.13 | 186.43 |
| imported/sherlock/quotes | 14437 | 1416.01 ± 0.3% | not timed | not timed | 1747.00 ± 0.5% | 35.15 ± 0.1% | not timed | not timed | 1412.92 ± 0.1% | | 1.00 | 0.81 | 40.28 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 599.86 ± 0.6% | not timed | not timed | 16089.08 ± 0.4% | 36.85 ± 0.4% | not timed | not timed | 602.17 ± 1.3% | | 1.00 | 0.0373 | 16.28 |
| imported/sherlock/word-ending-n | 35297 | 456.80 ± 0.2% | not timed | not timed | 409.00 ± 0.7% | 23.56 ± 0.4% | not timed | not timed | 468.31 ± 0.2% | | 0.98 | 1.12 | 19.39 |
| imported/sherlock/repeated-class-negation | 2130 | 14568.01 ± 0.7% | not timed | not timed | 11021.51 ± 0.7% | 11.58 ± 0.2% | not timed | not timed | 14571.58 ± 0.5% | | 1.00 | 1.32 | 1257.67 |
| imported/sherlock/ing-suffix | 20547 | 555.13 ± 1.4% | not timed | not timed | 516.18 ± 0.1% | 28.82 ± 30.9% | not timed | not timed | 554.82 ± 0.3% | | 1.00 | 1.08 | 19.26 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 594.81 ± 0.4% | not timed | not timed | 2101.25 ± 0.2% | 20.56 ± 0.2% | not timed | not timed | 593.63 ± 1.6% | | 1.00 | 0.28 | 28.94 |
| opt/accelerate/whole-line | 239963 | 459.42 ± 0.1% | not timed | not timed | 370.93 ± 0.1% | 92.26 ± 16.3% | not timed | not timed | 458.88 ± 0.2% | | 1.00 | 1.24 | 4.98 |
| opt/accelerate/non-dna | 16745 | 412.74 ± 0.8% | not timed | not timed | 402.06 ± 0.1% | 29.47 ± 14.1% | not timed | not timed | 413.52 ± 6.2% | | 1.00 | 1.03 | 14.00 |
| opt/backtrack/words-english | 40536 | 136.90 ± 7.1% | not timed | not timed | 94.38 ± 0.3% | 19.89 ± 8.1% | not timed | not timed | 137.44 ± 1.1% | | 1.00 | 1.45 | 6.88 |
| opt/fixed-length/too-small-ascii | 0 | 293.46 ± 0.2% | not timed | not timed | 693.86 ± 2.1% | 80.22 ± 0.4% | not timed | not timed | 310.22 ± 0.5% | | 0.95 | 0.42 | 3.66 |
| opt/fixed-length/too-big-ascii | 0 | 642.79 ± 0.8% | not timed | not timed | 5822.33 ± 0.5% | 122.60 ± 3.9% | not timed | not timed | 655.07 ± 1.0% | | 0.98 | 0.11 | 5.24 |
| opt/fixed-length/go33484-1 | 0 | 45.47 ± 0.4% | not timed | not timed | 1103498.63 ± 0.2% | 61462.80 ± 0.4% | not timed | not timed | 45.48 ± 0.3% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5535.44 ± 0.1% | not timed | not timed | 1111393.58 ± 0.4% | 32432.23 ± 2.0% | not timed | not timed | 5522.26 ± 0.1% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1824.29 ± 1.9% | not timed | not timed | 111841.93 ± 0.2% | 767.74 ± 0.1% | not timed | not timed | 1788.89 ± 1.3% | | 1.02 | 0.0163 | 2.38 |
| opt/literal-alt/one-pattern | 1 | 555.37 ± 1.8% | not timed | not timed | 544.64 ± 0.1% | 0.40 ± 0.6% | not timed | not timed | 555.93 ± 0.1% | | 1.00 | 1.02 | 1392.87 |
| opt/onepass/fn-predicate | 916 | 366.76 ± 0.7% | not timed | not timed | 335.75 ± 0.2% | 202.85 ± 13.4% | not timed | not timed | 371.01 ± 0.8% | | 0.99 | 1.09 | 1.81 |
| opt/onepass/first-three-words-english | 35128 | 146.47 ± 9.0% | not timed | not timed | 200.70 ± 0.2% | 82.31 ± 6.1% | not timed | not timed | 150.04 ± 6.0% | | 0.98 | 0.73 | 1.78 |
| opt/prefilter/literal-english | 1 | 20654.56 ± 0.2% | not timed | not timed | 19899.23 ± 0.2% | 17321.05 ± 0.4% | not timed | not timed | 20651.36 ± 0.4% | | 1.00 | 1.04 | 1.19 |
| opt/prefilter/literal-casei-english | 1 | 14510.05 ± 0.4% | not timed | not timed | 4311.93 ± 0.1% | 32.75 ± 0.3% | not timed | not timed | 14517.33 ± 0.3% | | 1.00 | 3.37 | 443.04 |
| opt/prefilter/literal-russian | 1 | 21717.43 ± 0.2% | not timed | not timed | 20280.16 ± 0.3% | 3322.02 ± 0.7% | not timed | not timed | 21719.62 ± 0.1% | | 1.00 | 1.07 | 6.54 |
| opt/prefilter/literal-casei-russian | 1 | 8607.65 ± 0.2% | not timed | not timed | 3895.53 ± 0.1% | 30.89 ± 0.7% | not timed | not timed | 8604.68 ± 0.2% | | 1.00 | 2.21 | 278.69 |
| opt/prefilter/rust-functions | 948 | 6832.97 ± 0.0% | not timed | not timed | 8954.05 ± 0.5% | 1879.24 ± 0.4% | not timed | not timed | 6823.37 ± 0.4% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 5578.25 ± 0.1% | not timed | not timed | 21582266.15 ± 0.2% | 50.61 ± 0.2% | not timed | not timed | 5585.28 ± 0.5% | | 1.00 | 0.0003 | 110.22 |
| opt/reverse-inner/holmes | 2593 | 597.22 ± 0.3% | not timed | not timed | 9519.33 ± 0.3% | 23.90 ± 1.1% | not timed | not timed | 598.34 ± 0.2% | | 1.00 | 0.0627 | 24.98 |
| opt/reverse-inner/email | 47 | 1045.70 ± 0.0% | not timed | not timed | 44792.76 ± 3.0% | 32.33 ± 0.5% | not timed | not timed | 1044.37 ± 0.1% | | 1.00 | 0.0233 | 32.34 |
| opt/reverse-inner/factored-prefix | 3542 | 592.07 ± 0.3% | not timed | not timed | 596.19 ± 0.1% | 12.05 ± 0.1% | not timed | not timed | 592.32 ± 0.7% | | 1.00 | 0.99 | 49.15 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5512.33 ± 0.1% | not timed | not timed | 616.91 ± 0.2% | 75.19 ± 0.3% | not timed | not timed | 5521.45 ± 0.0% | | 1.00 | 8.94 | 73.31 |
| opt/reverse-inner/no-quadratic-forward | 0 | 686.66 ± 0.4% | not timed | not timed | 288.86 ± 0.2% | 24.81 ± 0.1% | not timed | not timed | 691.88 ± 2.6% | | 0.99 | 2.38 | 27.67 |
| opt/reverse-suffix/holmes | 4073 | 599.33 ± 0.6% | not timed | not timed | 8485.94 ± 0.2% | 23.73 ± 1.3% | not timed | not timed | 597.81 ± 0.3% | | 1.00 | 0.0706 | 25.25 |
| opt/reverse-suffix/no-quadratic | 0 | 5521.79 ± 0.0% | not timed | not timed | 617.26 ± 0.1% | 75.01 ± 0.1% | not timed | not timed | 5509.19 ± 0.1% | | 1.00 | 8.95 | 73.61 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 121.37 ± 8.2% | not timed | not timed | 132.13 ± 0.1% | 13.36 ± 14.9% | not timed | not timed | 120.70 ± 1.9% | | 1.01 | 0.92 | 9.08 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.20 ± 2.0% | not timed | not timed | 131.99 ± 0.3% | 13.52 ± 13.9% | not timed | not timed | 121.31 ± 6.8% | | 1.00 | 0.92 | 8.96 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 4.0% | not timed | not timed | 0.55 ± 0.3% | 112.17 ± 8.1% | not timed | not timed | 0.28 ± 0.2% | | 1.01 | 0.52 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.74 ± 0.5% | not timed | not timed | 294.17 ± 0.1% | 104.09 ± 1.3% | not timed | not timed | 309.71 ± 0.2% | | 1.02 | 1.08 | 3.04 |
| reported/i13-subset-regex/original-ascii | 4094 | 10918.22 ± 0.9% | not timed | not timed | 4491.62 ± 0.8% | 11.51 ± 0.1% | not timed | not timed | 11086.62 ± 1.1% | | 0.98 | 2.43 | 948.61 |
| reported/i13-subset-regex/original-unicode | 4094 | 10869.52 ± 0.5% | not timed | not timed | 251.00 ± 3.5% | 11.53 ± 0.2% | not timed | not timed | 11076.24 ± 1.8% | | 0.98 | 43.30 | 942.97 |
| reported/i13-subset-regex/big-ascii | 1955 | 10631.05 ± 1.5% | not timed | not timed | 68.03 ± 3.6% | 9.85 ± 0.1% | not timed | not timed | 10714.90 ± 0.8% | | 0.99 | 156.26 | 1078.98 |
| reported/i13-subset-regex/big-unicode | 1955 | 10602.41 ± 2.0% | not timed | not timed | 12.25 ± 55.0% | 9.85 ± 1.2% | not timed | not timed | 10729.42 ± 1.0% | | 0.99 | 865.35 | 1076.09 |
| reported/i13-subset-regex/huge-ascii | 55 | 10139.16 ± 1.0% | not timed | not timed | 11.06 ± 0.1% | 8.77 ± 0.1% | not timed | not timed | 10107.64 ± 3.1% | | 1.00 | 917.01 | 1155.80 |
| reported/i13-subset-regex/huge-unicode | 55 | 10062.95 ± 2.8% | not timed | not timed | 10.99 ± 0.3% | 8.77 ± 0.2% | not timed | not timed | 9888.32 ± 2.8% | | 1.02 | 915.99 | 1147.66 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.1% | not timed | not timed | 11.03 ± 0.1% | 8.75 ± 1.1% | not timed | not timed | 3.53 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.02 ± 0.1% | not timed | not timed | 10.97 ± 0.3% | 8.77 ± 0.2% | not timed | not timed | 5.01 ± 0.1% | | 1.00 | 0.46 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 470.03 ± 0.4% | not timed | not timed | 104.69 ± 0.1% | 6.64 ± 0.2% | not timed | not timed | 470.10 ± 0.4% | | 1.00 | 4.49 | 70.83 |
| reported/i787-keywords/opt-ascii | 5674 | 470.85 ± 0.3% | not timed | not timed | 272.61 ± 0.4% | 10.30 ± 0.1% | not timed | not timed | 470.41 ± 0.4% | | 1.00 | 1.73 | 45.70 |
| slow/quadratic-regex-1x | 100 | 6.97 ± 0.1% | not timed | not timed | 4.93 ± 0.2% | 0.05 ± 0.3% | not timed | not timed | 6.95 ± 0.1% | | 1.00 | 1.41 | 141.78 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.2% | not timed | not timed | 2.74 ± 0.0% | 0.01 ± 0.2% | not timed | not timed | 3.40 ± 0.1% | | 1.00 | 1.24 | 267.46 |
| slow/quadratic-haystack-1x | 100 | 21.13 ± 6.3% | not timed | not timed | 9.99 ± 0.2% | 1.01 ± 13.8% | not timed | not timed | 21.15 ± 1.1% | | 1.00 | 2.11 | 20.86 |
| slow/quadratic-haystack-2x | 200 | 17.50 ± 0.6% | not timed | not timed | 5.54 ± 0.3% | 0.54 ± 1.5% | not timed | not timed | 17.46 ± 12.3% | | 1.00 | 3.16 | 32.14 |
| unicode/codepoints/any-one | 1112064 | 285.50 ± 1.4% | not timed | not timed | 175.18 ± 0.1% | 18.03 ± 20.1% | not timed | not timed | 284.10 ± 0.4% | | 1.00 | 1.63 | 15.84 |
| unicode/codepoints/any-all | 4382592 | 289.70 ± 0.3% | not timed | not timed | 247.23 ± 0.2% | 117.55 ± 0.1% | not timed | not timed | 289.34 ± 0.2% | | 1.00 | 1.17 | 2.46 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.73 ± 1.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 611.50 ± 0.5% | not timed | not timed | 615.70 ± 0.3% | 135.43 ± 0.3% | not timed | not timed | 610.48 ± 0.1% | | 1.00 | 0.99 | 4.52 |
| unicode/overlapping-words/ascii | 6156 | 31.77 ± 0.4% | not timed | not timed | 38.72 ± 0.1% | 3.96 ± 0.4% | not timed | not timed | 31.92 ± 0.4% | | 1.00 | 0.82 | 8.02 |
| unicode/overlapping-words/english | 6156 | 1.35 ± 0.1% | not timed | not timed | 4.46 ± 0.2% | 2.34 ± 0.2% | not timed | not timed | 1.35 ± 0.1% | | 1.00 | 0.30 | 0.58 |
| unicode/overlapping-words/russian | 5710 | 1.22 ± 9.4% | not timed | not timed | 3.88 ± 0.2% | 6.23 ± 9.5% | not timed | not timed | 1.22 ± 0.3% | | 1.00 | 0.31 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 115.61 ± 7.4% | not timed | not timed | 82.55 ± 0.3% | 12.07 ± 20.3% | not timed | not timed | 117.33 ± 1.1% | | 0.99 | 1.40 | 9.58 |
| unicode/word/boundary-long-english | 3466 | 606.60 ± 0.5% | not timed | not timed | 604.78 ± 2.9% | 32.58 ± 0.8% | not timed | not timed | 606.24 ± 0.5% | | 1.00 | 1.00 | 18.62 |
| unicode/word/around-holmes-english | 27 | 600.27 ± 1.0% | not timed | not timed | 19484.08 ± 0.3% | 22.02 ± 2.0% | not timed | not timed | 602.93 ± 0.3% | | 1.00 | 0.0308 | 27.26 |
| wild/bibleref/long | 874 | 564.48 ± 0.2% | not timed | not timed | 584.33 ± 0.1% | 6.82 ± 0.2% | not timed | not timed | 564.86 ± 0.2% | | 1.00 | 0.97 | 82.81 |
| wild/bibleref/short | 30 | 24.60 ± 2.5% | not timed | not timed | 30.62 ± 0.6% | 14.09 ± 13.6% | not timed | not timed | 24.79 ± 4.3% | | 0.99 | 0.80 | 1.75 |
| wild/bibleref/line | 874 | 359.02 ± 0.1% | not timed | not timed | 212.18 ± 0.2% | 9.21 ± 9.2% | not timed | not timed | 359.46 ± 6.0% | | 1.00 | 1.69 | 38.98 |
| wild/caddy/caddy | 6 | 409.67 ± 2.2% | not timed | not timed | 246.74 ± 0.1% | 68.53 ± 14.9% | not timed | not timed | 418.38 ± 0.4% | | 0.98 | 1.66 | 5.98 |
| wild/dot-star-capture/rust-src-tools | 6 | 1058.28 ± 0.8% | not timed | not timed | 348.52 ± 0.4% | 13.58 ± 0.1% | not timed | not timed | 1057.29 ± 0.4% | | 1.00 | 3.04 | 77.92 |
| wild/ruff/noqa | 84 | 404.48 ± 0.1% | not timed | not timed | 460.70 ± 0.3% | 19.54 ± 1.9% | not timed | not timed | 404.80 ± 0.1% | | 1.00 | 0.88 | 20.70 |
| wild/ruff/unnecessary-coding-comment | 16 | 490.04 ± 0.5% | not timed | not timed | 702.13 ± 0.1% | 137.16 ± 11.0% | not timed | not timed | 489.90 ± 0.6% | | 1.00 | 0.70 | 3.57 |
| wild/ruff/string-quote-prefix | 2972 | 408.24 ± 0.9% | not timed | not timed | 443.84 ± 0.3% | 378.60 ± 30.4% | not timed | not timed | 408.36 ± 0.5% | | 1.00 | 0.92 | 1.08 |
| wild/ruff/space-around-operator | 1224378 | 216.47 ± 1.7% | not timed | not timed | 185.51 ± 0.1% | 18.37 ± 1.9% | not timed | not timed | 218.19 ± 1.8% | | 0.99 | 1.17 | 11.78 |
| wild/ruff/shebang | 282 | 401.76 ± 0.4% | not timed | not timed | 327.45 ± 0.2% | 112.16 ± 9.4% | not timed | not timed | 402.15 ± 0.5% | | 1.00 | 1.23 | 3.58 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13856.58 ± 0.3% | not timed | not timed | 13872.74 ± 0.3% | 6941.27 ± 0.9% | not timed | not timed | 13859.84 ± 0.2% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12783.82 ± 0.6% | not timed | not timed | 13451.55 ± 0.6% | 6408.12 ± 0.9% | not timed | not timed | 12812.97 ± 0.4% | | 1.00 | 0.95 | 1.99 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13199.36 ± 0.7% | not timed | not timed | 13648.37 ± 1.0% | 6608.56 ± 0.7% | not timed | not timed | 13233.90 ± 0.9% | | 1.00 | 0.97 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9568.17 ± 0.3% | not timed | not timed | 13601.63 ± 0.5% | 6728.23 ± 1.4% | not timed | not timed | 9567.51 ± 0.1% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 121.97 ± 14.1% | not timed | not timed | 65.54 ± 0.7% | 2.21 ± 0.6% | not timed | not timed | 121.78 ± 14.1% | | 1.00 | 1.86 | 55.29 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 42.0% | not timed | not timed | 0.01 ± 1.2% | 0.01 ± 13.7% | not timed | not timed | 0.03 ± 59.8% | | 0.99 | 3.06 | 3.69 |
| dictionary/compile/english-15 | 1 | 0.35 ± 0.4% | not timed | not timed | 0.07 ± 1.8% | 0.10 ± 17.7% | not timed | not timed | 0.35 ± 33.1% | | 1.00 | 5.04 | 3.49 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 14.6% | not timed | not timed | 0.02 ± 1.0% | 36.97 ± 11.2% | not timed | not timed | 0.25 ± 2.9% | | 1.01 | 13.19 | 0.0068 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.52 ± 4.4% | not timed | not timed | 11.50 ± 0.3% | 55.33 ± 17.9% | not timed | not timed | 46.71 ± 5.5% | | 1.00 | 4.04 | 0.84 |
| reported/i787-keywords/compile | 1 | 34.46 ± 2.9% | not timed | not timed | 2.13 ± 0.5% | 17.74 ± 26.8% | not timed | not timed | 34.52 ± 2.9% | | 1.00 | 16.15 | 1.94 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 341.19 ± 2.0% | not timed | not timed | 119.14 ± 0.3% | 556.28 ± 26.0% | not timed | not timed | 344.05 ± 6.1% | | 0.99 | 2.86 | 0.61 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.37 ± 6.3% | not timed | not timed | 4.13 ± 0.5% | 42.44 ± 20.8% | not timed | not timed | 47.80 ± 1.9% | | 0.99 | 11.48 | 1.12 |
| unicode/compile/one-letter | 53 | 6.60 ± 13.0% | not timed | not timed | 4.49 ± 0.3% | 64.38 ± 4.6% | not timed | not timed | 6.71 ± 2.5% | | 0.98 | 1.47 | 0.10 |
| unicode/compile/fifty-letters | 1 | 1.05 ± 12.9% | not timed | not timed | 0.10 ± 0.1% | 63.69 ± 5.9% | not timed | not timed | 1.08 ± 13.3% | | 0.97 | 10.61 | 0.0164 |
| unicode/compile/fifty-letters-ascii | 1 | 210.48 ± 3.6% | not timed | not timed | 52.53 ± 0.1% | 177.79 ± 14.8% | not timed | not timed | 214.64 ± 3.5% | | 0.98 | 4.01 | 1.18 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 374.21 ± 16.5% | not timed | not timed | 47.26 ± 0.6% | 681.90 ± 21.0% | not timed | not timed | 373.51 ± 3.2% | | 1.00 | 7.92 | 0.55 |
| unicode/compile/match-every-line-ascii | 4 | 570.69 ± 15.0% | not timed | not timed | 144.86 ± 0.3% | 642.13 ± 27.6% | not timed | not timed | 585.30 ± 7.4% | | 0.98 | 3.94 | 0.89 |
| unicode/compile/negated-class-matches-codepoint | 1 | 298.01 ± 4.0% | not timed | not timed | 51.69 ± 0.4% | 1261.40 ± 6.8% | not timed | not timed | 310.43 ± 4.6% | | 0.96 | 5.77 | 0.24 |
| wild/bibleref/compile | 3 | 5.84 ± 16.1% | not timed | not timed | 1.94 ± 1.2% | 31.25 ± 17.7% | not timed | not timed | 5.88 ± 5.0% | | 0.99 | 3.01 | 0.19 |
| wild/url/compile | 1 | 0.54 ± 16.4% | not timed | not timed | 0.14 ± 0.3% | 0.46 ± 6.8% | not timed | not timed | 0.63 ± 18.6% | | 0.86 | 3.76 | 1.17 |

