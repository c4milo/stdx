# bench-regex

| Field | Value |
|---|---|
| Commit | b49e0f9 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45507035927 |
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
| literal: a word | 217 | 37468.29 ± 5.2% | 3153.29 ± 4.4% | 24.30 ± 0.5% | 30155.89 ± 1.0% | 9372.19 ± 5.4% | 9.89 ± 0.3% | 79.78 ± 3.5% | 37407.41 ± 4.9% | 11.88 | 1.00 | 1.24 | 4.00 |
| literal: a word that is not there | 0 | 48836.70 ± 3.8% | 3075.40 ± 5.5% | 23.98 ± 4.5% | 35595.37 ± 0.4% | 34012.98 ± 1.3% | 9.77 ± 2.0% | 76.47 ± 80.0% | 48698.31 ± 2.3% | 15.88 | 1.00 | 1.37 | 1.44 |
| literal: one of four words | 661 | 13452.76 ± 0.7% | 1298.96 ± 0.6% | 13.12 ± 0.8% | 8764.14 ± 6.4% | 19.21 ± 1.0% | 3.47 ± 0.2% | 6.71 ± 0.7% | 13521.47 ± 0.3% | 10.36 | 0.99 | 1.53 | 700.18 |
| literal: a word in any case | 217 | 33420.71 ± 0.3% | 1392.27 ± 4.6% | 18.71 ± 0.6% | 8964.26 ± 1.3% | 36.41 ± 1.3% | refused | differs | 33441.28 ± 0.6% | 24.00 | 1.00 | 3.73 | 918.01 |
| literal: an href attribute | 33 | 32189.65 ± 0.6% | 477.90 ± 0.2% | 22.92 ± 0.1% | 27287.06 ± 0.3% | 2295.50 ± 3.1% | 7.38 ± 0.4% | 70.77 ± 1.1% | 32152.92 ± 0.7% | 67.36 | 1.00 | 1.18 | 14.02 |
| literal: a word, second text | 123 | 39426.20 ± 1.0% | 2452.88 ± 1.6% | 23.89 ± 0.6% | 30301.64 ± 0.3% | 8857.29 ± 2.6% | 11.27 ± 0.3% | 68.40 ± 1.4% | 39477.28 ± 0.3% | 16.07 | 1.00 | 1.30 | 4.45 |
| class: two capitalized words | 1331 | 714.39 ± 0.5% | 474.78 ± 0.2% | 22.14 ± 5.5% | 446.83 ± 0.5% | 34.56 ± 12.3% | 8.48 ± 0.3% | 61.92 ± 0.1% | 714.80 ± 0.1% | 1.50 | 1.00 | 1.60 | 20.67 |
| class: a word that ends in ing | 3399 | 453.87 ± 0.5% | 454.34 ± 0.8% | 15.77 ± 2.9% | 417.91 ± 0.4% | 25.46 ± 6.2% | 4.80 ± 0.0% | 15.95 ± 1.3% | 453.97 ± 0.6% | 1.00 | 1.00 | 1.09 | 17.83 |
| class: a word in capitals | 2332 | 891.80 ± 0.4% | 479.60 ± 0.4% | 23.75 ± 0.4% | 438.50 ± 0.4% | 36.94 ± 6.3% | 9.64 ± 0.3% | 79.37 ± 0.4% | 891.18 ± 0.4% | 1.86 | 1.00 | 2.03 | 24.14 |
| class: a number | 8288 | 1571.51 ± 0.3% | 664.43 ± 0.4% | 24.04 ± 0.2% | 1403.96 ± 0.5% | 37.41 ± 14.0% | 0.30 ± 0.3% | 56.22 ± 1.4% | 1579.39 ± 0.6% | 2.37 | 1.00 | 1.12 | 42.00 |
| class: two capitalized words, second text | 5359 | 405.21 ± 0.2% | 410.64 ± 0.4% | 20.17 ± 1.8% | 370.94 ± 0.8% | 29.55 ± 3.9% | 9.92 ± 0.3% | 57.25 ± 0.2% | 405.20 ± 0.3% | 0.99 | 1.00 | 1.09 | 13.71 |
| other: a word between two words | 6104 | 715.68 ± 3.9% | 467.53 ± 0.2% | 19.91 ± 0.4% | 630.82 ± 0.3% | 100.78 ± 9.1% | 6.58 ± 0.7% | 63.93 ± 0.4% | 717.78 ± 0.3% | 1.53 | 1.00 | 1.13 | 7.10 |
| other: a number before a unit, second text | 1481 | 8707.05 ± 0.5% | 828.11 ± 0.6% | 22.46 ± 5.5% | 6411.87 ± 2.6% | 35.13 ± 0.9% | 10.34 ± 0.5% | 60.41 ± 0.2% | 8730.83 ± 0.8% | 10.51 | 1.00 | 1.36 | 247.85 |
| other: a heading's start tag | 110 | 20439.44 ± 0.2% | 580.13 ± 0.1% | 23.85 ± 0.2% | 1966.94 ± 2.7% | 1544.41 ± 2.6% | 9.02 ± 0.3% | 83.11 ± 0.9% | 20462.31 ± 0.4% | 35.23 | 1.00 | 10.39 | 13.23 |
| other: a whole word | 217 | 26427.71 ± 0.3% | 471.72 ± 0.5% | 24.34 ± 0.4% | 21691.70 ± 0.5% | 42.24 ± 0.5% | 8.56 ± 0.2% | 49.16 ± 0.6% | 26451.89 ± 1.2% | 56.02 | 1.00 | 1.22 | 625.64 |
| other: a line's first word, second text | 3716 | 2151.70 ± 0.8% | 466.04 ± 0.4% | 27.34 ± 0.9% | 1803.79 ± 7.7% | 54.95 ± 2.2% | refused | refused | 2159.85 ± 1.8% | 4.62 | 1.00 | 1.19 | 39.16 |
| other: fourteen octets before an x | 87 | 29709.39 ± 0.4% | 187.61 ± 0.7% | 5.92 ± 0.2% | 2695.82 ± 0.2% | 9.00 ± 1.3% | differs | 16.48 ± 6.4% | 29966.99 ± 0.3% | 158.36 | 0.99 | 11.02 | 3302.15 |
| other: a Greek word | 21815 | 398.39 ± 0.4% | 342.25 ± 1.0% | 26.65 ± 1.3% | 232.52 ± 0.3% | 43.48 ± 11.8% | differs | refused | 400.82 ± 0.3% | 1.16 | 0.99 | 1.71 | 9.16 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 24.88 ± 0.4% | 25.09 ± 0.6% | 0.78 ± 2.8% | 15.29 ± 0.5% | 1.70 ± 4.2% | differs | 3.32 ± 1.8% | 25.07 ± 0.6% | 0.99 | 0.99 | 1.63 | 14.66 |
| a UUID | 32895 | 21.27 ± 0.9% | 21.17 ± 2.2% | 0.54 ± 1.7% | 11.73 ± 0.2% | 2.34 ± 3.7% | 0.40 ± 0.3% | 2.98 ± 0.7% | 21.09 ± 0.9% | 1.00 | 1.01 | 1.81 | 9.08 |
| an IPv4 address | 33176 | 31.51 ± 0.2% | 31.58 ± 0.4% | 1.73 ± 0.8% | 22.02 ± 0.7% | 5.43 ± 1.4% | differs | 3.04 ± 3.1% | 31.54 ± 1.3% | 1.00 | 1.00 | 1.43 | 5.80 |
| a date and time | 32954 | 29.12 ± 6.9% | 29.16 ± 2.0% | 1.29 ± 4.2% | 16.82 ± 0.3% | 6.36 ± 3.7% | 0.70 ± 0.2% | 6.23 ± 1.2% | 28.70 ± 9.2% | 1.00 | 1.01 | 1.73 | 4.57 |
| a field path | 32606 | 26.94 ± 0.2% | 27.15 ± 0.5% | 0.81 ± 1.3% | 17.86 ± 5.9% | 2.70 ± 2.8% | differs | 2.39 ± 10.8% | 27.19 ± 0.7% | 0.99 | 0.99 | 1.51 | 9.99 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.31 ± 0.7% | 8.38 ± 17.7% | 8.42 ± 1.1% | 10.20 ± 0.8% | 4.61 ± 2.7% | 0.58 ± 1.0% | none | 8.32 ± 0.3% | 0.99 | 1.00 | 0.81 | 1.80 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 197.41 ± 0.2% | 197.55 ± 0.2% | 231.67 ± 0.8% | 78.90 ± 5.0% | 186.37 ± 16.8% | 546.66 ± 3.2% | 3839.34 ± 0.8% | 197.47 ± 0.4% | 1.00 | 1.00 | 2.50 | 1.06 |
| a UUID | 62 | 130.10 ± 0.1% | 130.20 ± 0.1% | 145.59 ± 0.1% | 45.16 ± 1.0% | 91.62 ± 1.7% | 198.70 ± 0.9% | 4279.83 ± 0.7% | 130.20 ± 0.6% | 1.00 | 1.00 | 2.88 | 1.42 |
| an IPv4 address | 29 | 382.47 ± 0.2% | 381.90 ± 1.2% | 534.05 ± 1.1% | 68.25 ± 0.4% | 115.54 ± 0.6% | 320.38 ± 0.8% | 6990.20 ± 0.2% | 382.57 ± 0.4% | 1.00 | 1.00 | 5.60 | 3.31 |
| a date and time | 56 | 275.01 ± 5.9% | 274.98 ± 6.0% | 346.76 ± 5.8% | 67.05 ± 3.2% | 124.34 ± 14.0% | 373.22 ± 4.3% | 4428.59 ± 0.5% | 275.52 ± 0.2% | 1.00 | 1.00 | 4.10 | 2.21 |
| a field path | 39 | 194.97 ± 0.4% | 194.87 ± 0.4% | 228.22 ± 0.2% | 71.94 ± 1.6% | 176.22 ± 1.0% | 570.23 ± 2.4% | 4677.11 ± 2.1% | 194.88 ± 0.4% | 1.00 | 1.00 | 2.71 | 1.11 |
| literal: a word | 7 | 556.15 ± 0.5% | 598.85 ± 0.3% | 1061.61 ± 0.3% | 482.28 ± 1.1% | 605.78 ± 1.0% | 1240.22 ± 0.5% | 26957.55 ± 0.6% | 556.81 ± 1.0% | 0.93 | 1.00 | 1.15 | 0.92 |
| literal: a word that is not there | 8 | 539.94 ± 0.4% | 577.77 ± 0.7% | 1009.80 ± 0.3% | 441.86 ± 0.6% | 577.23 ± 29.1% | 1167.18 ± 2.5% | 26419.35 ± 1.0% | 538.32 ± 0.8% | 0.93 | 1.00 | 1.22 | 0.94 |
| literal: one of four words | 26 | 208.92 ± 1.5% | 347.30 ± 2.1% | 467.90 ± 3.5% | 41.43 ± 0.7% | 226.95 ± 3.3% | 444.56 ± 1.4% | 13918.40 ± 0.8% | 209.94 ± 1.3% | 0.60 | 1.00 | 5.04 | 0.92 |
| literal: a word in any case | 11 | 384.31 ± 0.7% | 405.33 ± 0.4% | 576.76 ± 5.6% | 14.21 ± 1.8% | 621.89 ± 3.0% | refused | 21570.50 ± 0.5% | 384.33 ± 0.8% | 0.95 | 1.00 | 27.05 | 0.62 |
| literal: an href attribute | 12 | 312.18 ± 0.5% | 322.07 ± 0.2% | 425.53 ± 1.0% | 39.51 ± 0.5% | 440.52 ± 1.8% | 971.77 ± 0.5% | 18792.17 ± 0.7% | 312.42 ± 0.2% | 0.97 | 1.00 | 7.90 | 0.71 |
| literal: a word, second text | 10 | 502.12 ± 0.3% | 546.28 ± 0.8% | 903.78 ± 11.7% | 403.10 ± 7.3% | 501.11 ± 2.8% | 1024.80 ± 0.8% | 24953.96 ± 0.4% | 501.24 ± 5.8% | 0.92 | 1.00 | 1.25 | 1.00 |
| class: two capitalized words | 23 | 392.62 ± 0.4% | 424.08 ± 0.2% | 611.91 ± 0.4% | 93.97 ± 1.2% | 461.30 ± 1.4% | 972.21 ± 1.6% | 5739.91 ± 1.2% | 393.45 ± 0.4% | 0.93 | 1.00 | 4.18 | 0.85 |
| class: a word that ends in ing | 9 | 488.59 ± 0.2% | 555.01 ± 0.2% | 957.19 ± 0.4% | 117.88 ± 0.7% | 655.19 ± 3.2% | 1405.21 ± 1.3% | 15051.53 ± 0.4% | 488.00 ± 0.5% | 0.88 | 1.00 | 4.14 | 0.75 |
| class: a word in capitals | 16 | 436.31 ± 0.3% | 473.89 ± 1.2% | 755.18 ± 0.2% | 122.33 ± 0.8% | 691.37 ± 2.3% | 1367.68 ± 2.4% | 7158.47 ± 1.4% | 436.16 ± 0.8% | 0.92 | 1.00 | 3.57 | 0.63 |
| class: a number | 6 | 544.93 ± 0.6% | 606.31 ± 0.3% | 1125.49 ± 3.2% | 36.75 ± 0.6% | 1230.54 ± 4.7% | 2325.60 ± 3.8% | 20225.40 ± 0.3% | 545.55 ± 0.1% | 0.90 | 1.00 | 14.83 | 0.44 |
| class: two capitalized words, second text | 23 | 392.20 ± 0.7% | 422.30 ± 1.1% | 612.31 ± 0.6% | 93.59 ± 1.4% | 465.62 ± 1.6% | 944.19 ± 1.8% | 5716.33 ± 0.7% | 392.70 ± 1.0% | 0.93 | 1.00 | 4.19 | 0.84 |
| other: a word between two words | 13 | 480.50 ± 0.4% | 498.69 ± 0.2% | 781.97 ± 0.2% | 121.18 ± 1.7% | 447.22 ± 0.9% | 1028.64 ± 1.2% | 13964.29 ± 0.3% | 480.99 ± 0.3% | 0.96 | 1.00 | 3.97 | 1.07 |
| other: a number before a unit, second text | 15 | 350.91 ± 0.2% | 390.29 ± 0.6% | 545.10 ± 0.2% | 34.28 ± 1.0% | 552.58 ± 1.6% | 1107.63 ± 1.7% | 13846.01 ± 1.3% | 350.91 ± 0.3% | 0.90 | 1.00 | 10.24 | 0.64 |
| other: a heading's start tag | 13 | 317.80 ± 1.8% | 324.42 ± 0.4% | 432.23 ± 0.5% | 37.40 ± 1.6% | 542.21 ± 0.9% | 1055.32 ± 1.4% | 16021.29 ± 0.5% | 318.99 ± 0.2% | 0.98 | 1.00 | 8.50 | 0.59 |
| other: a whole word | 11 | 496.89 ± 0.4% | 525.67 ± 0.3% | 861.02 ± 0.5% | 110.24 ± 2.3% | 513.45 ± 2.6% | 1053.87 ± 1.1% | 24867.50 ± 0.9% | 496.91 ± 0.4% | 0.95 | 1.00 | 4.51 | 0.97 |
| other: a line's first word, second text | 17 | 459.52 ± 0.2% | 485.19 ± 0.6% | 766.06 ± 0.2% | 115.29 ± 0.6% | 618.09 ± 2.1% | refused | refused | 460.69 ± 11.8% | 0.95 | 1.00 | 3.99 | 0.74 |
| other: fourteen octets before an x | 16 | 90.64 ± 2.6% | 135.57 ± 0.3% | 159.16 ± 0.6% | 14.09 ± 0.6% | 401.71 ± 0.7% | 445.03 ± 0.9% | 12218.47 ± 0.5% | 90.55 ± 1.9% | 0.67 | 1.00 | 6.43 | 0.23 |
| other: a Greek word | 8 | 362.35 ± 0.4% | 517.33 ± 0.4% | 869.33 ± 0.6% | 49.04 ± 0.5% | 1222.55 ± 4.2% | 2106.28 ± 1.0% | refused | 360.33 ± 1.7% | 0.70 | 1.01 | 7.39 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 28966.52 ± 0.3% | not timed | not timed | 26014.57 ± 0.9% | 1962.03 ± 21.4% | not timed | not timed | 29002.42 ± 0.5% | | 1.00 | 1.11 | 14.76 |
| 01-literal/sherlock-casei-en | 522 | 23069.30 ± 2.0% | not timed | not timed | 7083.46 ± 4.6% | 26.20 ± 6.7% | not timed | not timed | 23104.80 ± 18.8% | | 1.00 | 3.26 | 880.39 |
| 01-literal/sherlock-ru | 724 | 30183.92 ± 1.2% | not timed | not timed | 26655.32 ± 2.4% | 955.25 ± 12.5% | not timed | not timed | 30298.41 ± 0.6% | | 1.00 | 1.13 | 31.60 |
| 01-literal/sherlock-casei-ru | 746 | 9798.37 ± 4.8% | not timed | not timed | 6111.82 ± 5.6% | 28.94 ± 3.7% | not timed | not timed | 9845.74 ± 3.3% | | 1.00 | 1.60 | 338.56 |
| 01-literal/sherlock-zh | 30 | 47159.99 ± 0.3% | not timed | not timed | 33331.16 ± 0.4% | 1274.70 ± 3.5% | not timed | not timed | 47109.89 ± 4.2% | | 1.00 | 1.41 | 37.00 |
| 02-literal-alternate/sherlock-en | 714 | 12350.92 ± 0.6% | not timed | not timed | 8553.05 ± 0.6% | 14.68 ± 4.5% | not timed | not timed | 12499.15 ± 15.7% | | 0.99 | 1.44 | 841.14 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3822.69 ± 7.8% | not timed | not timed | 1775.91 ± 0.7% | 9.47 ± 4.9% | not timed | not timed | 3840.06 ± 14.4% | | 1.00 | 2.15 | 403.54 |
| 02-literal-alternate/sherlock-ru | 899 | 8542.43 ± 17.2% | not timed | not timed | 7707.19 ± 1.1% | 18.75 ± 0.8% | not timed | not timed | 8576.85 ± 0.5% | | 1.00 | 1.11 | 455.56 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1944.03 ± 5.5% | not timed | not timed | 926.30 ± 0.4% | 8.20 ± 0.8% | not timed | not timed | 1912.22 ± 2.0% | | 1.02 | 2.10 | 237.20 |
| 02-literal-alternate/sherlock-zh | 207 | 16716.78 ± 0.5% | not timed | not timed | 10025.55 ± 0.2% | 27.63 ± 0.5% | not timed | not timed | 16824.14 ± 0.2% | | 0.99 | 1.67 | 604.99 |
| 03-date/ascii | 111817 | 115.07 ± 1.2% | not timed | not timed | 76.62 ± 0.3% | 0.18 ± 3.8% | not timed | not timed | 113.55 ± 0.7% | | 1.01 | 1.50 | 638.23 |
| 04-ruff-noqa/real | 84 | 398.30 ± 0.3% | not timed | not timed | 387.42 ± 0.3% | 15.30 ± 1.4% | not timed | not timed | 397.32 ± 0.1% | | 1.00 | 1.03 | 26.02 |
| 04-ruff-noqa/tweaked | 44 | 505.93 ± 0.9% | not timed | not timed | 389.90 ± 1.5% | 289.34 ± 1.0% | not timed | not timed | 506.48 ± 7.4% | | 1.00 | 1.30 | 1.75 |
| 05-lexer-veryl/single | 124800 | 3.72 ± 0.2% | not timed | not timed | 4.20 ± 0.4% | 0.20 ± 4.1% | not timed | not timed | 3.73 ± 0.7% | | 1.00 | 0.88 | 18.42 |
| 06-cloud-flare-redos/original | 107 | 340.02 ± 0.5% | not timed | not timed | 176.97 ± 0.3% | 19.77 ± 15.8% | not timed | not timed | 333.77 ± 2.6% | | 1.02 | 1.92 | 17.20 |
| 06-cloud-flare-redos/simplified-short | 102 | 328.93 ± 0.5% | not timed | not timed | 183.78 ± 0.3% | 21.25 ± 0.7% | not timed | not timed | 328.53 ± 0.6% | | 1.00 | 1.79 | 15.48 |
| 06-cloud-flare-redos/simplified-long | 10000 | 412.65 ± 0.4% | not timed | not timed | 201.21 ± 2.9% | 22.58 ± 20.8% | not timed | not timed | 411.25 ± 0.5% | | 1.00 | 2.05 | 18.27 |
| 07-unicode-character-data/parse-line | 558784 | 195.71 ± 1.7% | not timed | not timed | 155.13 ± 0.4% | 36.88 ± 26.4% | not timed | not timed | 194.85 ± 2.7% | | 1.00 | 1.26 | 5.31 |
| 08-words/all-english | 56691 | 104.06 ± 19.7% | not timed | not timed | 65.18 ± 0.4% | 11.23 ± 1.8% | not timed | not timed | 100.06 ± 9.0% | | 1.04 | 1.60 | 9.27 |
| 08-words/long-english | 839 | 480.26 ± 0.1% | not timed | not timed | 452.48 ± 0.2% | 27.10 ± 5.4% | not timed | not timed | 479.77 ± 1.1% | | 1.00 | 1.06 | 17.72 |
| 09-aws-keys/full | 0 | 406.16 ± 0.2% | not timed | not timed | 422.25 ± 0.5% | 52.22 ± 0.3% | not timed | not timed | 405.64 ± 0.5% | | 1.00 | 0.96 | 7.78 |
| 09-aws-keys/quick | 0 | 881.86 ± 0.2% | not timed | not timed | 741.73 ± 0.7% | 305.93 ± 2.8% | not timed | not timed | 886.40 ± 0.3% | | 0.99 | 1.19 | 2.88 |
| 10-bounded-repeat/letters-en | 1833 | 526.78 ± 1.4% | not timed | not timed | 428.55 ± 0.4% | 17.59 ± 2.7% | not timed | not timed | 519.52 ± 1.6% | | 1.01 | 1.23 | 29.95 |
| 10-bounded-repeat/letters-ru | 3475 | 401.66 ± 2.2% | not timed | not timed | 372.71 ± 0.5% | 21.19 ± 8.7% | not timed | not timed | 398.49 ± 2.3% | | 1.01 | 1.08 | 18.95 |
| 10-bounded-repeat/context | 53 | 65.29 ± 4.2% | not timed | not timed | 55.00 ± 4.8% | 15.74 ± 0.2% | not timed | not timed | 69.83 ± 1.4% | | 0.93 | 1.19 | 4.15 |
| 10-bounded-repeat/capitals | 11 | 494.61 ± 8.3% | not timed | not timed | 469.22 ± 0.4% | 31.23 ± 1.2% | not timed | not timed | 495.16 ± 8.0% | | 1.00 | 1.05 | 15.84 |
| 11-unstructured-to-json/extract | 600 | 40.02 ± 1.2% | not timed | not timed | 61.53 ± 0.3% | 26.77 ± 26.4% | not timed | not timed | 39.65 ± 9.3% | | 1.01 | 0.65 | 1.50 |
| 12-dictionary/single | 1 | 399.19 ± 1.4% | not timed | not timed | 372.41 ± 1.0% | 0.30 ± 7.4% | not timed | not timed | 398.46 ± 0.8% | | 1.00 | 1.07 | 1310.91 |
| 14-quadratic/1x | 100 | 20.40 ± 1.3% | not timed | not timed | 9.44 ± 0.6% | 0.77 ± 20.9% | not timed | not timed | 20.21 ± 0.9% | | 1.01 | 2.16 | 26.45 |
| 14-quadratic/2x | 200 | 15.68 ± 0.6% | not timed | not timed | 4.75 ± 4.8% | 0.42 ± 0.9% | not timed | not timed | 15.59 ± 1.1% | | 1.01 | 3.30 | 37.68 |
| 14-quadratic/10x | 1000 | 5.42 ± 5.6% | not timed | not timed | 0.94 ± 0.1% | 0.09 ± 1.7% | not timed | not timed | 5.36 ± 11.0% | | 1.01 | 5.75 | 59.75 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.07 ± 1.2% | not timed | not timed | 0.37 ± 0.2% | 0.49 ± 19.5% | not timed | not timed | 1.08 ± 1.5% | | 1.00 | 2.91 | 2.20 |
| 04-ruff-noqa/compile-real | 1 | 93.43 ± 1.6% | not timed | not timed | 13.51 ± 0.8% | 129.61 ± 19.9% | not timed | not timed | 93.52 ± 0.7% | | 1.00 | 6.92 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 12.76 ± 1.3% | not timed | not timed | 2.31 ± 18.9% | 6.10 ± 4.3% | not timed | not timed | 12.74 ± 2.5% | | 1.00 | 5.51 | 2.09 |
| 07-unicode-character-data/compile | 1 | 97.60 ± 0.3% | not timed | not timed | 23.79 ± 0.3% | 33.95 ± 1.3% | not timed | not timed | 97.49 ± 0.5% | | 1.00 | 4.10 | 2.88 |
| 09-aws-keys/compile-full | 1 | 43.04 ± 0.4% | not timed | not timed | 7.77 ± 16.5% | 21.74 ± 2.0% | not timed | not timed | 42.77 ± 0.3% | | 1.01 | 5.54 | 1.98 |
| 09-aws-keys/compile-quick | 1 | 152.23 ± 2.1% | not timed | not timed | 44.94 ± 23.9% | 121.78 ± 3.3% | not timed | not timed | 152.27 ± 5.9% | | 1.00 | 3.39 | 1.25 |
| 10-bounded-repeat/compile-context | 1 | 47.05 ± 1.7% | not timed | not timed | 11.18 ± 0.7% | 15.83 ± 2.3% | not timed | not timed | 46.93 ± 0.4% | | 1.00 | 4.21 | 2.97 |
| 10-bounded-repeat/compile-capitals | 1 | 73.30 ± 1.5% | not timed | not timed | 8.10 ± 1.8% | 22.88 ± 4.3% | not timed | not timed | 73.54 ± 1.7% | | 1.00 | 9.05 | 3.20 |
| 11-unstructured-to-json/compile | 1 | 148.68 ± 1.3% | not timed | not timed | 36.52 ± 0.6% | 62.90 ± 1.6% | not timed | not timed | 149.16 ± 3.6% | | 1.00 | 4.07 | 2.36 |
| 12-dictionary/compile-single | 1 | 0.27 ± 1.7% | not timed | not timed | 0.07 ± 12.5% | 0.09 ± 22.0% | not timed | not timed | 0.27 ± 0.9% | | 1.00 | 4.08 | 2.89 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.66 ± 1.1% | not timed | not timed | 5.42 ± 0.4% | 0.51 ± 20.3% | not timed | not timed | 5.66 ± 1.8% | | 1.00 | 1.04 | 10.98 |
| dictionary/search/english-10 | 690 | 1.00 ± 26.6% | not timed | not timed | 118.56 ± 13.4% | 0.01 ± 0.4% | not timed | not timed | 1.01 ± 1.3% | | 0.99 | 0.0084 | 186.34 |
| dictionary/search/english-15 | 15 | 397.75 ± 0.8% | not timed | not timed | 373.75 ± 1.8% | 0.28 ± 4.2% | not timed | not timed | 397.71 ± 0.7% | | 1.00 | 1.06 | 1408.03 |
| folly/awyer-inn-busted | 1 | 3344.64 ± 1.0% | not timed | not timed | 102.15 ± 4.2% | 37.58 ± 0.1% | not timed | not timed | 3369.32 ± 0.3% | | 0.99 | 32.74 | 89.00 |
| folly/literal-never-match-rare | 0 | 52621.13 ± 0.4% | not timed | not timed | 36019.06 ± 15.6% | 53419.22 ± 0.6% | not timed | not timed | 52671.64 ± 0.6% | | 1.00 | 1.46 | 0.99 |
| folly/literal-never-match-frequent | 0 | 20324.18 ± 9.2% | not timed | not timed | 35808.27 ± 0.4% | 1995.42 ± 0.4% | not timed | not timed | 20710.19 ± 3.7% | | 0.98 | 0.57 | 10.19 |
| folly/literal-never-match-tricksy | 1 | 3081.16 ± 0.9% | not timed | not timed | 4768.68 ± 1.3% | 1337.13 ± 0.7% | not timed | not timed | 3094.31 ± 1.9% | | 1.00 | 0.65 | 2.30 |
| grep/every-line | 239963 | 1135.61 ± 0.7% | not timed | not timed | 753.38 ± 1.0% | 308.93 ± 40.7% | not timed | not timed | 1137.48 ± 0.2% | | 1.00 | 1.51 | 3.68 |
| grep/long-words-ascii | 5073 | 390.53 ± 0.5% | not timed | not timed | 380.91 ± 14.6% | 39.40 ± 5.2% | not timed | not timed | 390.34 ± 0.6% | | 1.00 | 1.03 | 9.91 |
| imported/leipzig/twain | 811 | 45493.65 ± 0.9% | not timed | not timed | 33935.61 ± 28.2% | 10094.44 ± 13.7% | not timed | not timed | 45561.10 ± 0.6% | | 1.00 | 1.34 | 4.51 |
| imported/leipzig/twain-insensitive | 965 | 12004.93 ± 6.0% | not timed | not timed | 10713.38 ± 0.4% | 32.48 ± 3.1% | not timed | not timed | 12013.77 ± 0.4% | | 1.00 | 1.12 | 369.55 |
| imported/leipzig/shing | 1540 | 23572.32 ± 4.5% | not timed | not timed | 17307.80 ± 0.3% | 27.98 ± 3.1% | not timed | not timed | 23624.08 ± 1.4% | | 1.00 | 1.36 | 842.41 |
| imported/leipzig/huck-saw | 262 | 20329.20 ± 1.3% | not timed | not timed | 14781.40 ± 0.4% | 25.42 ± 2.3% | not timed | not timed | 20343.80 ± 0.5% | | 1.00 | 1.38 | 799.83 |
| imported/leipzig/word-ending-nn | 262 | 472.88 ± 0.3% | not timed | not timed | 468.53 ± 0.6% | 20.57 ± 0.1% | not timed | not timed | 472.95 ± 0.4% | | 1.00 | 1.01 | 22.99 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 9265.88 ± 0.6% | not timed | not timed | 3036.78 ± 0.3% | 9.13 ± 1.8% | not timed | not timed | 9270.88 ± 4.6% | | 1.00 | 3.05 | 1015.24 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 17721.29 ± 1.6% | not timed | not timed | 13882.49 ± 0.6% | 14.10 ± 1.4% | not timed | not timed | 17791.90 ± 2.6% | | 1.00 | 1.28 | 1256.85 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4299.10 ± 0.6% | not timed | not timed | 611.77 ± 1.1% | 9.29 ± 1.2% | not timed | not timed | 4289.81 ± 0.2% | | 1.00 | 7.03 | 462.72 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 471.59 ± 0.3% | not timed | not timed | 467.08 ± 0.1% | 8.95 ± 0.6% | not timed | not timed | 471.50 ± 0.1% | | 1.00 | 1.01 | 52.70 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 471.82 ± 0.1% | not timed | not timed | 467.63 ± 0.3% | 7.72 ± 1.0% | not timed | not timed | 471.49 ± 0.4% | | 1.00 | 1.01 | 61.10 |
| imported/leipzig/tom-river | 2 | 10161.66 ± 1.1% | not timed | not timed | 10499.12 ± 0.8% | 25.21 ± 0.9% | not timed | not timed | 10189.83 ± 0.6% | | 1.00 | 0.97 | 403.01 |
| imported/leipzig/ing | 78424 | 463.27 ± 0.6% | not timed | not timed | 435.18 ± 2.3% | 22.59 ± 1.5% | not timed | not timed | 464.14 ± 0.1% | | 1.00 | 1.06 | 20.51 |
| imported/leipzig/ing-whitespace | 55248 | 568.61 ± 0.7% | not timed | not timed | 1667.82 ± 0.7% | 17.51 ± 1.4% | not timed | not timed | 573.88 ± 0.7% | | 0.99 | 0.34 | 32.47 |
| imported/leipzig/awyer-inn | 209 | 597.64 ± 2.0% | not timed | not timed | 10946.37 ± 0.3% | 18.60 ± 1.8% | not timed | not timed | 597.95 ± 1.2% | | 1.00 | 0.0546 | 32.14 |
| imported/leipzig/quotes-bounded | 8886 | 1439.14 ± 7.2% | not timed | not timed | 2553.47 ± 3.7% | 31.00 ± 1.5% | not timed | not timed | 1435.91 ± 0.1% | | 1.00 | 0.56 | 46.42 |
| imported/leipzig/non-ascii-alternate | 2 | 31611.32 ± 0.3% | not timed | not timed | 15456.10 ± 0.2% | 44.19 ± 0.9% | not timed | not timed | 31639.21 ± 0.4% | | 1.00 | 2.05 | 715.29 |
| imported/leipzig/math-symbols | 69 | 1885.73 ± 0.7% | not timed | not timed | 467.72 ± 0.9% | 30.50 ± 3.8% | not timed | not timed | 1883.24 ± 0.6% | | 1.00 | 4.03 | 61.83 |
| imported/leipzig/bounded-strings-ending-z | 0 | 473.50 ± 0.2% | not timed | not timed | 468.74 ± 0.7% | 19.06 ± 1.8% | not timed | not timed | 473.37 ± 0.3% | | 1.00 | 1.01 | 24.84 |
| imported/lh3lh3-reb/uri | 17549 | 630.80 ± 0.3% | not timed | not timed | 876.77 ± 0.5% | 18.93 ± 2.6% | not timed | not timed | 627.81 ± 0.3% | | 1.00 | 0.72 | 33.32 |
| imported/lh3lh3-reb/email | 15057 | 624.42 ± 0.6% | not timed | not timed | 877.03 ± 0.9% | 19.81 ± 2.5% | not timed | not timed | 624.20 ± 0.2% | | 1.00 | 0.71 | 31.52 |
| imported/lh3lh3-reb/date | 668 | 724.06 ± 2.3% | not timed | not timed | 785.48 ± 0.8% | 40.11 ± 5.5% | not timed | not timed | 724.36 ± 0.4% | | 1.00 | 0.92 | 18.05 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 582.27 ± 0.3% | not timed | not timed | 344.04 ± 4.1% | 9.92 ± 1.8% | not timed | not timed | 579.54 ± 1.1% | | 1.00 | 1.69 | 58.71 |
| imported/mariomka/email | 92 | 33150.02 ± 1.7% | not timed | not timed | 46592.19 ± 10.7% | 27.40 ± 6.0% | not timed | not timed | 33312.37 ± 0.9% | | 1.00 | 0.71 | 1209.75 |
| imported/mariomka/uri | 5301 | 5179.29 ± 7.1% | not timed | not timed | 6162.48 ± 1.0% | 26.72 ± 0.8% | not timed | not timed | 5188.10 ± 1.2% | | 1.00 | 0.84 | 193.84 |
| imported/mariomka/ip | 5 | 1409.00 ± 6.5% | not timed | not timed | 1785.50 ± 3.4% | 17.14 ± 4.4% | not timed | not timed | 1410.21 ± 4.4% | | 1.00 | 0.79 | 82.18 |
| imported/rsc/no-exponential | 0 | 694.59 ± 1.1% | not timed | not timed | 326.34 ± 0.6% | 19.90 ± 1.9% | not timed | not timed | 652.35 ± 1.0% | | 1.06 | 2.13 | 34.90 |
| imported/rsc/literal | 1 | 692.24 ± 4.1% | not timed | not timed | 1630.89 ± 3.5% | 168.14 ± 14.6% | not timed | not timed | 693.74 ± 11.5% | | 1.00 | 0.42 | 4.12 |
| imported/rsc/not-literal | 2 | 751.82 ± 1.0% | not timed | not timed | 658.75 ± 0.3% | 38.07 ± 16.6% | not timed | not timed | 732.73 ± 1.7% | | 1.03 | 1.14 | 19.75 |
| imported/rsc/match-class | 1 | 1317.79 ± 28.0% | not timed | not timed | 1397.60 ± 1.6% | 52.32 ± 0.2% | not timed | not timed | 1295.21 ± 0.5% | | 1.02 | 0.94 | 25.19 |
| imported/rsc/match-class-in-range | 1 | 1314.97 ± 0.6% | not timed | not timed | 2418.17 ± 1.1% | 54.36 ± 6.4% | not timed | not timed | 1310.54 ± 2.0% | | 1.00 | 0.54 | 24.19 |
| imported/rsc/match-class-unicode | 1 | 442.67 ± 0.8% | not timed | not timed | 403.31 ± 0.4% | 64.39 ± 6.4% | not timed | not timed | 441.51 ± 6.6% | | 1.00 | 1.10 | 6.88 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1318.67 ± 0.2% | not timed | not timed | 883.10 ± 0.7% | 267.89 ± 1.5% | not timed | not timed | 1300.87 ± 0.1% | | 1.01 | 1.49 | 4.92 |
| imported/rsc/anchored-literal-long-non-match | 0 | 19771.96 ± 0.1% | not timed | not timed | 13409.05 ± 0.6% | 3990.10 ± 1.4% | not timed | not timed | 19525.91 ± 0.2% | | 1.01 | 1.47 | 4.96 |
| imported/rsc/anchored-literal-short-match | 4 | 690.39 ± 3.7% | not timed | not timed | 439.96 ± 0.9% | 85.93 ± 14.6% | not timed | not timed | 671.62 ± 1.4% | | 1.03 | 1.57 | 8.03 |
| imported/rsc/anchored-literal-long-match | 4 | 10305.02 ± 0.7% | not timed | not timed | 6646.87 ± 0.8% | 1264.61 ± 5.3% | not timed | not timed | 10105.97 ± 1.6% | | 1.02 | 1.55 | 8.15 |
| imported/rsc/one-pass-short | 17 | 381.82 ± 1.8% | not timed | not timed | 201.64 ± 0.9% | 27.60 ± 10.9% | not timed | not timed | 361.90 ± 3.0% | | 1.06 | 1.89 | 13.83 |
| imported/rsc/one-pass-short-not | 17 | 253.62 ± 1.8% | not timed | not timed | 210.50 ± 1.0% | 25.80 ± 21.6% | not timed | not timed | 253.37 ± 2.0% | | 1.00 | 1.20 | 9.83 |
| imported/rsc/one-pass-long-prefix | 26 | 348.40 ± 2.3% | not timed | not timed | 251.38 ± 1.8% | 98.32 ± 20.1% | not timed | not timed | 335.70 ± 28.4% | | 1.04 | 1.39 | 3.54 |
| imported/rsc/one-pass-long-prefix-not | 26 | 343.76 ± 1.9% | not timed | not timed | 249.23 ± 2.4% | 64.96 ± 29.9% | not timed | not timed | 346.27 ± 11.2% | | 0.99 | 1.38 | 5.29 |
| imported/rsc/long-needle1 | 31 | 52907.13 ± 0.2% | not timed | not timed | 35569.27 ± 0.1% | 3.17 ± 3.0% | not timed | not timed | 52943.16 ± 0.5% | | 1.00 | 1.49 | 16715.48 |
| imported/rsc/long-needle2 | 31 | 52594.00 ± 0.5% | not timed | not timed | 176.31 ± 0.3% | 3.16 ± 0.4% | not timed | not timed | 52604.33 ± 0.4% | | 1.00 | 298.30 | 16643.03 |
| imported/rsc/easy0-32 | 26 | 982.93 ± 2.3% | not timed | not timed | 1497.98 ± 35.6% | 116.78 ± 24.1% | not timed | not timed | 984.53 ± 0.3% | | 1.00 | 0.66 | 8.42 |
| imported/rsc/easy0-1k | 26 | 16699.37 ± 3.4% | not timed | not timed | 15840.05 ± 1.1% | 1822.87 ± 85.5% | not timed | not timed | 16575.62 ± 0.8% | | 1.01 | 1.05 | 9.16 |
| imported/rsc/easy0-32k | 26 | 50130.38 ± 1.6% | not timed | not timed | 34023.80 ± 0.2% | 18725.67 ± 29.3% | not timed | not timed | 50092.69 ± 0.6% | | 1.00 | 1.47 | 2.68 |
| imported/rsc/easy0-1mb | 26 | 50660.41 ± 0.5% | not timed | not timed | 35815.45 ± 0.2% | 52218.47 ± 4.2% | not timed | not timed | 50584.09 ± 10.5% | | 1.00 | 1.41 | 0.97 |
| imported/rsc/easy1-32 | 19 | 712.73 ± 4.2% | not timed | not timed | 593.94 ± 17.9% | 116.48 ± 19.1% | not timed | not timed | 721.48 ± 3.1% | | 0.99 | 1.20 | 6.12 |
| imported/rsc/easy1-1k | 19 | 14631.19 ± 2.2% | not timed | not timed | 12098.37 ± 1.0% | 1823.02 ± 12.0% | not timed | not timed | 14773.59 ± 0.4% | | 0.99 | 1.21 | 8.03 |
| imported/rsc/easy1-32k | 19 | 465098.05 ± 1.9% | not timed | not timed | 381939.51 ± 8.2% | 22805.89 ± 15.4% | not timed | not timed | 464401.53 ± 0.4% | | 1.00 | 1.22 | 20.39 |
| imported/rsc/easy1-1mb | 19 | 14798847.55 ± 11.5% | not timed | not timed | 12197121.29 ± 0.4% | 52678.62 ± 0.3% | not timed | not timed | 14853245.79 ± 1.6% | | 1.00 | 1.21 | 280.93 |
| imported/rsc/medium-32 | 27 | 674.11 ± 1.5% | not timed | not timed | 574.28 ± 0.7% | 60.48 ± 15.4% | not timed | not timed | 675.26 ± 0.3% | | 1.00 | 1.17 | 11.15 |
| imported/rsc/medium-1k | 27 | 12048.54 ± 0.5% | not timed | not timed | 10076.70 ± 0.2% | 63.71 ± 1.2% | not timed | not timed | 11975.00 ± 11.1% | | 1.01 | 1.20 | 189.10 |
| imported/rsc/medium-32k | 27 | 376427.18 ± 0.2% | not timed | not timed | 313127.61 ± 0.6% | 42.14 ± 0.6% | not timed | not timed | 374724.06 ± 4.7% | | 1.00 | 1.20 | 8933.81 |
| imported/rsc/medium-1mb | 27 | 12034823.63 ± 0.4% | not timed | not timed | 10245840.86 ± 0.6% | 42.19 ± 21.7% | not timed | not timed | 12001944.85 ± 1.5% | | 1.00 | 1.17 | 285261.94 |
| imported/rsc/hard-32 | 58 | 344.49 ± 1.4% | not timed | not timed | 302.11 ± 9.1% | 38.40 ± 13.4% | not timed | not timed | 348.43 ± 0.3% | | 0.99 | 1.14 | 8.97 |
| imported/rsc/hard-1k | 27 | 11182.16 ± 0.4% | not timed | not timed | 10120.51 ± 5.7% | 34.07 ± 8.6% | not timed | not timed | 11564.46 ± 1.0% | | 0.97 | 1.10 | 328.17 |
| imported/rsc/hard-32k | 27 | 350744.67 ± 0.6% | not timed | not timed | 315277.93 ± 0.3% | 24.59 ± 1.1% | not timed | not timed | 361959.14 ± 0.7% | | 0.97 | 1.11 | 14261.34 |
| imported/rsc/hard-1mb | 51 | 6828917.35 ± 0.8% | not timed | not timed | 6022996.80 ± 0.8% | 24.75 ± 0.3% | not timed | not timed | 6940007.38 ± 1.0% | | 0.98 | 1.13 | 275895.55 |
| imported/rsc/reallyhard0-32 | 58 | 219.03 ± 0.4% | not timed | not timed | 190.63 ± 0.7% | 40.14 ± 29.9% | not timed | not timed | 218.18 ± 0.7% | | 1.00 | 1.15 | 5.46 |
| imported/rsc/reallyhard0-1k | 27 | 458.85 ± 0.7% | not timed | not timed | 450.46 ± 1.6% | 34.55 ± 1.7% | not timed | not timed | 458.65 ± 0.2% | | 1.00 | 1.02 | 13.28 |
| imported/rsc/reallyhard0-32k | 27 | 471.66 ± 0.2% | not timed | not timed | 467.81 ± 0.6% | 23.76 ± 0.4% | not timed | not timed | 471.89 ± 0.2% | | 1.00 | 1.01 | 19.85 |
| imported/rsc/reallyhard0-1mb | 51 | 473.19 ± 0.2% | not timed | not timed | 467.47 ± 0.5% | 24.14 ± 0.8% | not timed | not timed | 472.75 ± 0.2% | | 1.00 | 1.01 | 19.61 |
| imported/rsc/reallyreallyhard0-32 | 47 | 260.67 ± 1.5% | not timed | not timed | 162.42 ± 0.3% | 50.56 ± 9.9% | not timed | not timed | 257.67 ± 5.3% | | 1.01 | 1.60 | 5.16 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6365.97 ± 0.5% | not timed | not timed | 5990.05 ± 0.1% | 28.48 ± 1.6% | not timed | not timed | 6384.87 ± 0.7% | | 1.00 | 1.06 | 223.55 |
| imported/rsc/reallyreallyhard0-32k | 16 | 40749.47 ± 5.2% | not timed | not timed | 27748.66 ± 6.7% | 18.97 ± 6.8% | not timed | not timed | 40421.17 ± 21.4% | | 1.01 | 1.47 | 2148.33 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 54130.14 ± 17.1% | not timed | not timed | 35331.34 ± 2.7% | 20.17 ± 0.8% | not timed | not timed | 54325.97 ± 0.2% | | 1.00 | 1.53 | 2683.25 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 251.58 ± 2.3% | not timed | not timed | 167.36 ± 1.1% | 50.18 ± 11.4% | not timed | not timed | 249.26 ± 4.8% | | 1.01 | 1.50 | 5.01 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5296.08 ± 0.7% | not timed | not timed | 5836.26 ± 20.6% | 28.25 ± 0.9% | not timed | not timed | 5286.89 ± 0.4% | | 1.00 | 0.91 | 187.49 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 38487.77 ± 0.1% | not timed | not timed | 28563.04 ± 20.8% | 20.21 ± 0.6% | not timed | not timed | 37573.46 ± 0.2% | | 1.02 | 1.35 | 1904.59 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 50679.30 ± 0.1% | not timed | not timed | 35414.07 ± 0.6% | 20.23 ± 1.2% | not timed | not timed | 50573.99 ± 13.6% | | 1.00 | 1.43 | 2505.29 |
| imported/sherlock/name-sherlock | 776 | 39270.64 ± 18.9% | not timed | not timed | 31029.57 ± 3.7% | 11034.71 ± 87.1% | not timed | not timed | 39951.93 ± 2.0% | | 0.98 | 1.27 | 3.56 |
| imported/sherlock/name-holmes | 2766 | 20449.33 ± 10.6% | not timed | not timed | 23530.86 ± 1.7% | 3082.18 ± 13.3% | not timed | not timed | 21932.29 ± 2.4% | | 0.93 | 0.87 | 6.63 |
| imported/sherlock/name-sherlock-holmes | 1365 | 40382.76 ± 10.6% | not timed | not timed | 31184.61 ± 22.4% | 8230.78 ± 19.8% | not timed | not timed | 40299.47 ± 1.9% | | 1.00 | 1.29 | 4.91 |
| imported/sherlock/name-sherlock-casei | 816 | 37255.90 ± 0.2% | not timed | not timed | 9152.29 ± 0.7% | 26.10 ± 2.1% | not timed | not timed | 37234.97 ± 0.5% | | 1.00 | 4.07 | 1427.66 |
| imported/sherlock/name-holmes-casei | 2802 | 17653.17 ± 2.8% | not timed | not timed | 6020.33 ± 10.0% | 34.15 ± 18.4% | not timed | not timed | 17666.93 ± 0.5% | | 1.00 | 2.93 | 516.92 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 28872.70 ± 0.3% | not timed | not timed | 8875.23 ± 1.7% | 26.18 ± 1.6% | not timed | not timed | 28916.49 ± 0.6% | | 1.00 | 3.25 | 1102.93 |
| imported/sherlock/name-whitespace | 1461 | 23341.15 ± 2.6% | not timed | not timed | 21843.58 ± 1.9% | 6704.95 ± 21.2% | not timed | not timed | 23585.10 ± 2.0% | | 0.99 | 1.07 | 3.48 |
| imported/sherlock/name-alt1 | 1142 | 24353.16 ± 0.7% | not timed | not timed | 23357.03 ± 1.8% | 4410.97 ± 25.3% | not timed | not timed | 24514.00 ± 4.6% | | 0.99 | 1.04 | 5.52 |
| imported/sherlock/name-alt2 | 3542 | 16451.19 ± 0.6% | not timed | not timed | 7995.87 ± 0.2% | 27.80 ± 2.1% | not timed | not timed | 16496.38 ± 0.6% | | 1.00 | 2.06 | 591.81 |
| imported/sherlock/name-alt3 | 4507 | 10736.35 ± 3.3% | not timed | not timed | 7291.54 ± 0.8% | 8.17 ± 0.6% | not timed | not timed | 10818.53 ± 0.6% | | 0.99 | 1.47 | 1314.31 |
| imported/sherlock/name-alt3-casei | 4593 | 2664.65 ± 6.8% | not timed | not timed | 1007.45 ± 0.4% | 5.49 ± 3.5% | not timed | not timed | 2499.44 ± 5.4% | | 1.07 | 2.64 | 485.29 |
| imported/sherlock/name-alt4 | 3686 | 7723.96 ± 17.4% | not timed | not timed | 6402.21 ± 14.2% | 25.69 ± 0.7% | not timed | not timed | 7650.87 ± 0.3% | | 1.01 | 1.21 | 300.67 |
| imported/sherlock/name-alt4-casei | 4254 | 4256.48 ± 1.2% | not timed | not timed | 3484.04 ± 0.9% | 16.06 ± 2.9% | not timed | not timed | 3957.48 ± 1.4% | | 1.08 | 1.22 | 265.07 |
| imported/sherlock/name-alt5 | 4028 | 13520.26 ± 3.0% | not timed | not timed | 7673.79 ± 0.8% | 17.92 ± 0.4% | not timed | not timed | 13506.29 ± 3.5% | | 1.00 | 1.76 | 754.39 |
| imported/sherlock/name-alt5-casei | 4104 | 5483.47 ± 1.4% | not timed | not timed | 2345.26 ± 0.5% | 11.66 ± 34.6% | not timed | not timed | 5374.37 ± 0.8% | | 1.02 | 2.34 | 470.31 |
| imported/sherlock/no-match-uncommon | 0 | 53722.92 ± 0.7% | not timed | not timed | 44928.31 ± 0.3% | 45202.84 ± 1.1% | not timed | not timed | 53758.11 ± 0.5% | | 1.00 | 1.20 | 1.19 |
| imported/sherlock/no-match-common | 0 | 52420.00 ± 1.0% | not timed | not timed | 44949.44 ± 0.6% | 1657.67 ± 1.0% | not timed | not timed | 52145.35 ± 1.5% | | 1.01 | 1.17 | 31.62 |
| imported/sherlock/no-match-really-common | 0 | 33442.85 ± 0.8% | not timed | not timed | 38433.20 ± 2.0% | 1659.15 ± 0.9% | not timed | not timed | 33524.76 ± 1.2% | | 1.00 | 0.87 | 20.16 |
| imported/sherlock/the-lower | 21654 | 3092.52 ± 1.6% | not timed | not timed | 3521.27 ± 4.0% | 221.30 ± 12.9% | not timed | not timed | 3107.60 ± 13.4% | | 1.00 | 0.88 | 13.97 |
| imported/sherlock/the-upper | 2223 | 16204.60 ± 1.4% | not timed | not timed | 22776.93 ± 0.5% | 2457.82 ± 12.6% | not timed | not timed | 16337.70 ± 1.0% | | 0.99 | 0.71 | 6.59 |
| imported/sherlock/the-casei | 23961 | 2706.26 ± 28.2% | not timed | not timed | 1057.80 ± 2.0% | 30.31 ± 0.9% | not timed | not timed | 2710.34 ± 0.2% | | 1.00 | 2.56 | 89.30 |
| imported/sherlock/everything-greedy | 581881 | 229.49 ± 0.9% | not timed | not timed | 134.40 ± 6.3% | 21.24 ± 22.8% | not timed | not timed | 225.37 ± 6.0% | | 1.02 | 1.71 | 10.80 |
| imported/sherlock/everything-greedy-nl | 594933 | 361.29 ± 0.2% | not timed | not timed | 174.68 ± 1.4% | 24.52 ± 1.2% | not timed | not timed | 361.37 ± 0.2% | | 1.00 | 2.07 | 14.73 |
| imported/sherlock/letters | 447175 | 52.39 ± 8.0% | not timed | not timed | 26.38 ± 0.3% | 4.71 ± 28.2% | not timed | not timed | 51.93 ± 1.8% | | 1.01 | 1.99 | 11.11 |
| imported/sherlock/letters-upper | 14180 | 350.91 ± 6.2% | not timed | not timed | 284.01 ± 3.2% | 22.39 ± 22.9% | not timed | not timed | 350.09 ± 0.2% | | 1.00 | 1.24 | 15.68 |
| imported/sherlock/letters-lower | 432995 | 53.15 ± 3.7% | not timed | not timed | 26.89 ± 0.4% | 5.80 ± 5.2% | not timed | not timed | 52.69 ± 20.7% | | 1.01 | 1.98 | 9.17 |
| imported/sherlock/words | 447639 | 97.15 ± 10.9% | not timed | not timed | 65.22 ± 15.0% | 11.76 ± 10.6% | not timed | not timed | 92.93 ± 24.5% | | 1.05 | 1.49 | 8.26 |
| imported/sherlock/before-holmes | 4073 | 11833.51 ± 0.5% | not timed | not timed | 10211.01 ± 2.8% | 18.77 ± 16.3% | not timed | not timed | 11885.97 ± 0.5% | | 1.00 | 1.16 | 630.39 |
| imported/sherlock/before-after-holmes | 2593 | 11668.32 ± 8.4% | not timed | not timed | 11643.47 ± 0.7% | 19.11 ± 11.0% | not timed | not timed | 11698.75 ± 0.5% | | 1.00 | 1.00 | 610.55 |
| imported/sherlock/holmes-cochar-watson | 150 | 7961.44 ± 0.4% | not timed | not timed | 6014.87 ± 1.2% | 26.72 ± 1.5% | not timed | not timed | 7403.84 ± 0.3% | | 1.08 | 1.32 | 297.99 |
| imported/sherlock/holmes-coword-watson | 14309 | 986.87 ± 0.3% | not timed | not timed | 941.91 ± 0.1% | 5.92 ± 0.8% | not timed | not timed | 986.42 ± 0.3% | | 1.00 | 1.05 | 166.76 |
| imported/sherlock/quotes | 14437 | 1057.80 ± 0.4% | not timed | not timed | 1743.53 ± 2.4% | 28.42 ± 3.2% | not timed | not timed | 1054.33 ± 8.3% | | 1.00 | 0.61 | 37.22 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 469.56 ± 0.9% | not timed | not timed | 24188.15 ± 0.6% | 30.58 ± 0.5% | not timed | not timed | 470.03 ± 0.2% | | 1.00 | 0.0194 | 15.36 |
| imported/sherlock/word-ending-n | 35297 | 370.57 ± 0.4% | not timed | not timed | 310.07 ± 0.2% | 20.19 ± 1.4% | not timed | not timed | 367.47 ± 1.2% | | 1.01 | 1.20 | 18.35 |
| imported/sherlock/repeated-class-negation | 2130 | 14858.66 ± 23.0% | not timed | not timed | 12737.00 ± 5.8% | 9.19 ± 5.8% | not timed | not timed | 14902.04 ± 6.2% | | 1.00 | 1.17 | 1616.19 |
| imported/sherlock/ing-suffix | 20547 | 445.27 ± 0.4% | not timed | not timed | 394.77 ± 2.2% | 23.77 ± 23.9% | not timed | not timed | 442.95 ± 2.1% | | 1.01 | 1.13 | 18.73 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 469.28 ± 0.3% | not timed | not timed | 2267.83 ± 1.1% | 17.49 ± 2.6% | not timed | not timed | 469.29 ± 0.6% | | 1.00 | 0.21 | 26.82 |
| opt/accelerate/whole-line | 239963 | 385.14 ± 4.3% | not timed | not timed | 321.52 ± 0.3% | 64.87 ± 14.8% | not timed | not timed | 391.18 ± 0.9% | | 0.98 | 1.20 | 5.94 |
| opt/accelerate/non-dna | 16745 | 352.86 ± 0.7% | not timed | not timed | 339.06 ± 0.1% | 25.84 ± 17.1% | not timed | not timed | 353.64 ± 0.3% | | 1.00 | 1.04 | 13.66 |
| opt/backtrack/words-english | 40536 | 109.42 ± 16.8% | not timed | not timed | 86.31 ± 0.3% | 16.77 ± 7.1% | not timed | not timed | 108.77 ± 8.0% | | 1.01 | 1.27 | 6.52 |
| opt/fixed-length/too-small-ascii | 0 | 303.75 ± 34.2% | not timed | not timed | 549.71 ± 10.3% | 95.70 ± 15.0% | not timed | not timed | 295.06 ± 0.3% | | 1.03 | 0.55 | 3.17 |
| opt/fixed-length/too-big-ascii | 0 | 3355.50 ± 0.9% | not timed | not timed | 4906.58 ± 30.3% | 116.92 ± 3.8% | not timed | not timed | 3378.18 ± 0.4% | | 0.99 | 0.68 | 28.70 |
| opt/fixed-length/go33484-1 | 0 | 648517.26 ± 0.4% | not timed | not timed | 943785.88 ± 0.7% | 68688.69 ± 2.8% | not timed | not timed | 649729.63 ± 0.9% | | 1.00 | 0.69 | 9.44 |
| opt/fixed-length/go33484-2 | 0 | 646717.06 ± 0.3% | not timed | not timed | 945072.41 ± 0.3% | 18760.28 ± 19.8% | not timed | not timed | 647563.94 ± 0.8% | | 1.00 | 0.68 | 34.47 |
| opt/fixed-length/go33484-3 | 0 | 1903.56 ± 0.6% | not timed | not timed | 94417.09 ± 0.3% | 708.65 ± 38.1% | not timed | not timed | 1898.24 ± 0.4% | | 1.00 | 0.0202 | 2.69 |
| opt/literal-alt/one-pattern | 1 | 435.05 ± 3.0% | not timed | not timed | 442.70 ± 0.2% | 0.29 ± 3.0% | not timed | not timed | 446.91 ± 2.2% | | 0.97 | 0.98 | 1495.75 |
| opt/onepass/fn-predicate | 916 | 333.14 ± 1.7% | not timed | not timed | 309.45 ± 0.5% | 159.12 ± 29.9% | not timed | not timed | 332.57 ± 0.9% | | 1.00 | 1.08 | 2.09 |
| opt/onepass/first-three-words-english | 35128 | 137.67 ± 2.6% | not timed | not timed | 180.38 ± 1.5% | 61.60 ± 13.8% | not timed | not timed | 137.83 ± 0.8% | | 1.00 | 0.76 | 2.23 |
| opt/prefilter/literal-english | 1 | 52506.28 ± 0.4% | not timed | not timed | 36025.37 ± 0.4% | 20439.87 ± 17.6% | not timed | not timed | 52554.11 ± 0.3% | | 1.00 | 1.46 | 2.57 |
| opt/prefilter/literal-casei-english | 1 | 37254.65 ± 1.3% | not timed | not timed | 11335.46 ± 0.3% | 25.76 ± 2.6% | not timed | not timed | 37342.62 ± 0.6% | | 1.00 | 3.29 | 1446.42 |
| opt/prefilter/literal-russian | 1 | 52941.57 ± 0.2% | not timed | not timed | 35972.02 ± 0.5% | 1393.56 ± 1.0% | not timed | not timed | 53052.84 ± 0.4% | | 1.00 | 1.47 | 37.99 |
| opt/prefilter/literal-casei-russian | 1 | 21133.33 ± 0.8% | not timed | not timed | 8629.56 ± 0.3% | 28.95 ± 0.6% | not timed | not timed | 21131.89 ± 0.2% | | 1.00 | 2.45 | 729.90 |
| opt/prefilter/rust-functions | 948 | 11559.41 ± 1.2% | not timed | not timed | 9938.99 ± 0.8% | 1479.14 ± 0.4% | not timed | not timed | 11541.38 ± 1.1% | | 1.00 | 1.16 | 7.81 |
| opt/reverse-anchored/word-end | 1 | 27356257.40 ± 0.3% | not timed | not timed | 20963662.11 ± 1.5% | 39.59 ± 0.3% | not timed | not timed | 27611367.72 ± 0.3% | | 0.99 | 1.30 | 691008.56 |
| opt/reverse-inner/holmes | 2593 | 11679.41 ± 0.5% | not timed | not timed | 11628.85 ± 0.4% | 18.68 ± 0.9% | not timed | not timed | 11648.61 ± 0.8% | | 1.00 | 1.00 | 625.29 |
| opt/reverse-inner/email | 47 | 65607.90 ± 0.5% | not timed | not timed | 71703.02 ± 0.4% | 25.78 ± 5.8% | not timed | not timed | 65556.24 ± 0.5% | | 1.00 | 0.91 | 2545.36 |
| opt/reverse-inner/factored-prefix | 3542 | 464.76 ± 0.7% | not timed | not timed | 454.24 ± 0.8% | 10.26 ± 16.8% | not timed | not timed | 465.49 ± 0.2% | | 1.00 | 1.02 | 45.28 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3327.75 ± 0.4% | not timed | not timed | 468.47 ± 0.3% | 66.41 ± 0.2% | not timed | not timed | 3331.38 ± 0.4% | | 1.00 | 7.10 | 50.11 |
| opt/reverse-inner/no-quadratic-forward | 0 | 551.05 ± 5.0% | not timed | not timed | 216.91 ± 0.6% | 17.87 ± 26.0% | not timed | not timed | 550.31 ± 4.6% | | 1.00 | 2.54 | 30.84 |
| opt/reverse-suffix/holmes | 4073 | 11849.05 ± 0.6% | not timed | not timed | 10267.60 ± 0.3% | 19.94 ± 11.3% | not timed | not timed | 11853.95 ± 19.6% | | 1.00 | 1.15 | 594.14 |
| opt/reverse-suffix/no-quadratic | 0 | 3328.89 ± 0.4% | not timed | not timed | 469.18 ± 0.7% | 65.99 ± 0.5% | not timed | not timed | 3332.36 ± 0.2% | | 1.00 | 7.10 | 50.44 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 110.19 ± 0.5% | not timed | not timed | 141.80 ± 1.7% | 11.33 ± 34.7% | not timed | not timed | 106.95 ± 8.2% | | 1.03 | 0.78 | 9.73 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 110.78 ± 0.5% | not timed | not timed | 141.97 ± 0.9% | 11.92 ± 37.6% | not timed | not timed | 108.66 ± 3.1% | | 1.02 | 0.78 | 9.29 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.24 ± 0.5% | not timed | not timed | 0.38 ± 0.7% | 93.62 ± 5.6% | not timed | not timed | 0.25 ± 4.0% | | 0.99 | 0.65 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 220.64 ± 0.4% | not timed | not timed | 220.13 ± 0.3% | 84.77 ± 1.5% | not timed | not timed | 230.36 ± 0.8% | | 0.96 | 1.00 | 2.60 |
| reported/i13-subset-regex/original-ascii | 4094 | 9246.61 ± 0.7% | not timed | not timed | 3058.01 ± 0.6% | 9.22 ± 1.3% | not timed | not timed | 9257.14 ± 0.2% | | 1.00 | 3.02 | 1002.49 |
| reported/i13-subset-regex/original-unicode | 4094 | 9217.21 ± 7.5% | not timed | not timed | 164.34 ± 1.4% | 9.23 ± 1.1% | not timed | not timed | 9253.75 ± 0.6% | | 1.00 | 56.09 | 998.48 |
| reported/i13-subset-regex/big-ascii | 1955 | 8626.34 ± 1.8% | not timed | not timed | 42.33 ± 2.5% | 8.05 ± 2.1% | not timed | not timed | 8642.31 ± 7.2% | | 1.00 | 203.79 | 1071.52 |
| reported/i13-subset-regex/big-unicode | 1955 | 8592.71 ± 0.5% | not timed | not timed | 7.52 ± 55.1% | 8.04 ± 0.2% | not timed | not timed | 8647.60 ± 0.5% | | 0.99 | 1143.00 | 1068.52 |
| reported/i13-subset-regex/huge-ascii | 55 | 7932.89 ± 0.5% | not timed | not timed | 6.77 ± 1.6% | 7.34 ± 1.2% | not timed | not timed | 7921.53 ± 0.6% | | 1.00 | 1172.58 | 1080.83 |
| reported/i13-subset-regex/huge-unicode | 55 | 7834.55 ± 0.6% | not timed | not timed | 6.83 ± 1.0% | 7.32 ± 1.7% | not timed | not timed | 7825.95 ± 3.9% | | 1.00 | 1147.91 | 1070.04 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.27 ± 0.6% | not timed | not timed | 6.92 ± 0.9% | 7.36 ± 3.5% | not timed | not timed | 3.14 ± 0.4% | | 1.04 | 0.47 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.53 ± 1.2% | not timed | not timed | 6.95 ± 0.6% | 7.37 ± 2.8% | not timed | not timed | 4.54 ± 1.1% | | 1.00 | 0.65 | 0.62 |
| reported/i787-keywords/ascii | 5674 | 431.44 ± 1.0% | not timed | not timed | 132.96 ± 1.0% | 5.65 ± 0.5% | not timed | not timed | 432.00 ± 0.4% | | 1.00 | 3.24 | 76.37 |
| reported/i787-keywords/opt-ascii | 5674 | 434.40 ± 0.4% | not timed | not timed | 208.38 ± 1.7% | 9.43 ± 2.5% | not timed | not timed | 431.39 ± 1.5% | | 1.01 | 2.08 | 46.09 |
| slow/quadratic-regex-1x | 100 | 6.39 ± 0.4% | not timed | not timed | 4.67 ± 7.4% | 0.04 ± 0.7% | not timed | not timed | 6.36 ± 0.3% | | 1.00 | 1.37 | 161.30 |
| slow/quadratic-regex-2x | 199 | 2.84 ± 1.0% | not timed | not timed | 2.37 ± 3.1% | 0.01 ± 3.4% | not timed | not timed | 2.87 ± 3.6% | | 0.99 | 1.20 | 280.79 |
| slow/quadratic-haystack-1x | 100 | 20.30 ± 7.9% | not timed | not timed | 9.44 ± 0.4% | 0.79 ± 14.8% | not timed | not timed | 20.24 ± 21.2% | | 1.00 | 2.15 | 25.53 |
| slow/quadratic-haystack-2x | 200 | 15.59 ± 0.8% | not timed | not timed | 4.74 ± 0.2% | 0.42 ± 26.3% | not timed | not timed | 15.61 ± 0.8% | | 1.00 | 3.29 | 37.46 |
| unicode/codepoints/any-one | 1112064 | 260.79 ± 4.7% | not timed | not timed | 184.84 ± 23.6% | 17.42 ± 23.3% | not timed | not timed | 256.18 ± 0.9% | | 1.02 | 1.41 | 14.97 |
| unicode/codepoints/any-all | 4382592 | 207.64 ± 3.9% | not timed | not timed | 203.55 ± 0.9% | 82.08 ± 0.7% | not timed | not timed | 208.22 ± 0.6% | | 1.00 | 1.02 | 2.53 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 6.15 ± 0.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 472.90 ± 0.9% | not timed | not timed | 468.48 ± 0.7% | 119.28 ± 3.3% | not timed | not timed | 473.64 ± 0.2% | | 1.00 | 1.01 | 3.96 |
| unicode/overlapping-words/ascii | 6156 | 22.48 ± 37.5% | not timed | not timed | 33.36 ± 0.6% | 3.24 ± 2.9% | not timed | not timed | 22.15 ± 1.7% | | 1.01 | 0.67 | 6.93 |
| unicode/overlapping-words/english | 6156 | 1.12 ± 0.5% | not timed | not timed | 2.32 ± 7.1% | 2.20 ± 2.3% | not timed | not timed | 1.13 ± 1.1% | | 0.99 | 0.48 | 0.51 |
| unicode/overlapping-words/russian | 5710 | 1.00 ± 0.5% | not timed | not timed | 2.28 ± 0.2% | 5.40 ± 4.5% | not timed | not timed | 1.00 ± 0.6% | | 0.99 | 0.44 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 106.55 ± 7.7% | not timed | not timed | 65.92 ± 1.5% | 10.97 ± 23.9% | not timed | not timed | 102.51 ± 31.9% | | 1.04 | 1.62 | 9.71 |
| unicode/word/boundary-long-english | 3466 | 474.14 ± 0.6% | not timed | not timed | 459.50 ± 0.7% | 27.47 ± 1.9% | not timed | not timed | 473.33 ± 0.7% | | 1.00 | 1.03 | 17.26 |
| unicode/word/around-holmes-english | 27 | 49585.13 ± 0.5% | not timed | not timed | 34851.10 ± 0.4% | 18.58 ± 1.0% | not timed | not timed | 49242.26 ± 4.2% | | 1.01 | 1.42 | 2669.26 |
| wild/bibleref/long | 874 | 441.31 ± 0.5% | not timed | not timed | 444.76 ± 0.1% | 6.16 ± 0.7% | not timed | not timed | 442.84 ± 0.3% | | 1.00 | 0.99 | 71.66 |
| wild/bibleref/short | 30 | 17.66 ± 7.9% | not timed | not timed | 25.45 ± 1.5% | 11.39 ± 24.7% | not timed | not timed | 18.48 ± 4.1% | | 0.96 | 0.69 | 1.55 |
| wild/bibleref/line | 874 | 397.93 ± 0.5% | not timed | not timed | 214.43 ± 0.2% | 7.38 ± 1.4% | not timed | not timed | 399.14 ± 0.7% | | 1.00 | 1.86 | 53.93 |
| wild/caddy/caddy | 6 | 345.42 ± 1.5% | not timed | not timed | 226.92 ± 7.1% | 61.75 ± 12.8% | not timed | not timed | 347.71 ± 31.0% | | 0.99 | 1.52 | 5.59 |
| wild/dot-star-capture/rust-src-tools | 6 | 1129.05 ± 11.2% | not timed | not timed | 314.16 ± 0.6% | 12.33 ± 2.3% | not timed | not timed | 1123.93 ± 13.3% | | 1.00 | 3.59 | 91.57 |
| wild/ruff/noqa | 84 | 397.50 ± 0.4% | not timed | not timed | 395.70 ± 1.3% | 16.45 ± 7.8% | not timed | not timed | 397.15 ± 13.5% | | 1.00 | 1.00 | 24.16 |
| wild/ruff/unnecessary-coding-comment | 16 | 831.58 ± 0.6% | not timed | not timed | 563.05 ± 1.5% | 71.00 ± 8.6% | not timed | not timed | 827.56 ± 0.4% | | 1.00 | 1.48 | 11.71 |
| wild/ruff/string-quote-prefix | 2972 | 1236.65 ± 1.3% | not timed | not timed | 358.49 ± 0.2% | 251.96 ± 28.3% | not timed | not timed | 1235.49 ± 0.8% | | 1.00 | 3.45 | 4.91 |
| wild/ruff/space-around-operator | 1224378 | 183.16 ± 1.5% | not timed | not timed | 176.00 ± 0.5% | 14.52 ± 2.2% | not timed | not timed | 183.77 ± 1.9% | | 1.00 | 1.04 | 12.62 |
| wild/ruff/shebang | 282 | 870.32 ± 0.6% | not timed | not timed | 304.63 ± 0.4% | 91.00 ± 16.9% | not timed | not timed | 841.22 ± 0.5% | | 1.03 | 2.86 | 9.56 |
| wild/rustsec-cargo-audit/original-unix | 471 | 17491.06 ± 1.8% | not timed | not timed | 18222.41 ± 23.6% | 6700.97 ± 4.4% | not timed | not timed | 17005.90 ± 0.7% | | 1.03 | 0.96 | 2.61 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15956.17 ± 0.4% | not timed | not timed | 17336.32 ± 7.9% | 6322.35 ± 1.9% | not timed | not timed | 15944.10 ± 6.5% | | 1.00 | 0.92 | 2.52 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 17816.03 ± 1.2% | not timed | not timed | 17897.58 ± 8.4% | 6201.11 ± 32.9% | not timed | not timed | 17742.09 ± 1.5% | | 1.00 | 1.00 | 2.87 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 14095.29 ± 0.9% | not timed | not timed | 18140.84 ± 1.0% | 6482.00 ± 0.8% | not timed | not timed | 14041.51 ± 0.7% | | 1.00 | 0.78 | 2.17 |
| wild/url/search | 234965 | 102.05 ± 14.2% | not timed | not timed | 47.37 ± 5.4% | 1.88 ± 0.9% | not timed | not timed | 102.14 ± 13.2% | | 1.00 | 2.15 | 54.28 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 20.3% | not timed | not timed | 0.01 ± 1.3% | 0.01 ± 25.1% | not timed | not timed | 0.02 ± 1.5% | | 0.99 | 2.40 | 3.61 |
| dictionary/compile/english-15 | 1 | 0.27 ± 25.9% | not timed | not timed | 0.07 ± 0.6% | 0.10 ± 25.6% | not timed | not timed | 0.27 ± 0.7% | | 0.99 | 3.55 | 2.68 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.23 ± 13.2% | not timed | not timed | 0.02 ± 42.4% | 31.52 ± 12.7% | not timed | not timed | 0.23 ± 2.1% | | 1.01 | 13.04 | 0.0074 |
| reported/i1095-word-repetition/ascii-compile | 1 | 32.09 ± 16.8% | not timed | not timed | 12.99 ± 11.9% | 50.11 ± 37.7% | not timed | not timed | 33.42 ± 3.3% | | 0.96 | 2.47 | 0.64 |
| reported/i787-keywords/compile | 1 | 31.48 ± 3.0% | not timed | not timed | 1.87 ± 0.7% | 16.81 ± 38.7% | not timed | not timed | 31.41 ± 1.8% | | 1.00 | 16.87 | 1.87 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 285.51 ± 5.3% | not timed | not timed | 113.39 ± 0.8% | 501.90 ± 28.7% | not timed | not timed | 288.61 ± 5.8% | | 0.99 | 2.52 | 0.57 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 41.69 ± 3.0% | not timed | not timed | 4.30 ± 0.9% | 39.06 ± 10.3% | not timed | not timed | 42.15 ± 4.1% | | 0.99 | 9.69 | 1.07 |
| unicode/compile/one-letter | 53 | 5.35 ± 2.5% | not timed | not timed | 4.40 ± 1.7% | 55.73 ± 15.9% | not timed | not timed | 5.38 ± 2.4% | | 0.99 | 1.22 | 0.0960 |
| unicode/compile/fifty-letters | 1 | 0.95 ± 4.9% | not timed | not timed | 0.10 ± 1.2% | 55.96 ± 29.1% | not timed | not timed | 0.97 ± 6.1% | | 0.98 | 9.68 | 0.0169 |
| unicode/compile/fifty-letters-ascii | 1 | 158.84 ± 14.8% | not timed | not timed | 53.69 ± 0.3% | 188.37 ± 30.7% | not timed | not timed | 159.53 ± 7.5% | | 1.00 | 2.96 | 0.84 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 355.62 ± 2.9% | not timed | not timed | 40.01 ± 0.7% | 589.22 ± 21.7% | not timed | not timed | 353.78 ± 1.0% | | 1.01 | 8.89 | 0.60 |
| unicode/compile/match-every-line-ascii | 4 | 550.73 ± 2.5% | not timed | not timed | 129.97 ± 0.7% | 582.67 ± 14.1% | not timed | not timed | 554.33 ± 2.8% | | 0.99 | 4.24 | 0.95 |
| unicode/compile/negated-class-matches-codepoint | 1 | 290.55 ± 5.7% | not timed | not timed | 43.68 ± 0.2% | 1070.10 ± 20.4% | not timed | not timed | 285.34 ± 11.5% | | 1.02 | 6.65 | 0.27 |
| wild/bibleref/compile | 3 | 4.33 ± 12.5% | not timed | not timed | 1.89 ± 0.5% | 30.46 ± 4.3% | not timed | not timed | 4.30 ± 11.7% | | 1.01 | 2.29 | 0.14 |
| wild/url/compile | 1 | 0.56 ± 1.4% | not timed | not timed | 0.16 ± 0.4% | 0.38 ± 32.1% | not timed | not timed | 0.56 ± 20.0% | | 1.00 | 3.50 | 1.47 |

