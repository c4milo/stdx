# bench-regex

| Field | Value |
|---|---|
| Commit | 1df5f9f |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391528096 |
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
| literal: a word | 217 | 38323.87 ± 0.7% | 3113.35 ± 1.7% | 23.34 ± 2.7% | 30238.13 ± 0.2% | 9286.84 ± 6.2% | 9.89 ± 0.3% | 80.89 ± 3.0% | 38307.28 ± 0.3% | 12.31 | 1.00 | 1.27 | 4.13 |
| literal: a word that is not there | 0 | 50058.91 ± 0.3% | 3053.91 ± 0.2% | 23.34 ± 0.8% | 35346.87 ± 0.7% | 33288.52 ± 2.4% | 9.75 ± 1.0% | 75.40 ± 0.9% | 50088.00 ± 0.5% | 16.39 | 1.00 | 1.42 | 1.50 |
| literal: one of four words | 661 | 12088.97 ± 0.3% | 1285.75 ± 1.2% | 12.39 ± 0.7% | 8837.14 ± 0.1% | 19.19 ± 83.9% | 3.47 ± 0.1% | 6.41 ± 4.3% | 12135.37 ± 0.5% | 9.40 | 1.00 | 1.37 | 630.11 |
| literal: a word in any case | 217 | 34029.31 ± 0.9% | 1378.97 ± 1.1% | 17.46 ± 2.5% | 8906.89 ± 1.7% | 35.60 ± 0.8% | refused | differs | 33878.84 ± 0.6% | 24.68 | 1.00 | 3.82 | 955.80 |
| literal: an href attribute | 33 | 31739.13 ± 0.6% | 477.69 ± 0.1% | 22.47 ± 12.8% | 27188.20 ± 0.6% | 2291.70 ± 1.2% | 7.40 ± 1.5% | 70.77 ± 0.3% | 31758.69 ± 0.4% | 66.44 | 1.00 | 1.17 | 13.85 |
| literal: a word, second text | 123 | 39739.03 ± 0.4% | 2411.35 ± 0.7% | 23.16 ± 0.7% | 30677.65 ± 0.8% | 8577.16 ± 3.0% | 11.18 ± 1.1% | 68.09 ± 0.3% | 39800.87 ± 0.5% | 16.48 | 1.00 | 1.30 | 4.63 |
| class: two capitalized words | 1331 | 697.00 ± 0.3% | 468.36 ± 0.2% | 21.69 ± 9.7% | 447.39 ± 0.3% | 34.44 ± 7.5% | 8.47 ± 0.5% | 61.95 ± 0.5% | 695.67 ± 0.8% | 1.49 | 1.00 | 1.56 | 20.24 |
| class: a word that ends in ing | 3399 | 444.50 ± 0.9% | 446.15 ± 0.1% | 15.11 ± 0.4% | 419.31 ± 0.3% | 24.97 ± 6.0% | 4.81 ± 0.3% | 15.57 ± 9.5% | 445.84 ± 0.2% | 1.00 | 1.00 | 1.06 | 17.80 |
| class: a word in capitals | 2332 | 878.81 ± 1.1% | 473.06 ± 1.7% | 22.95 ± 5.9% | 439.52 ± 2.9% | 37.03 ± 1.3% | 9.59 ± 0.2% | 78.13 ± 1.4% | 878.16 ± 1.2% | 1.86 | 1.00 | 2.00 | 23.74 |
| class: a number | 8288 | 1426.33 ± 0.4% | 631.61 ± 0.4% | 23.20 ± 1.0% | 1400.41 ± 0.4% | 37.47 ± 14.8% | 0.30 ± 0.4% | 56.62 ± 0.5% | 1425.20 ± 1.6% | 2.26 | 1.00 | 1.02 | 38.07 |
| class: two capitalized words, second text | 5359 | 397.27 ± 0.1% | 402.72 ± 1.1% | 19.73 ± 1.2% | 369.47 ± 0.2% | 29.01 ± 8.1% | 9.86 ± 0.2% | 57.28 ± 15.0% | 396.55 ± 1.3% | 0.99 | 1.00 | 1.08 | 13.69 |
| other: a word between two words | 6104 | 661.74 ± 1.0% | 454.44 ± 0.5% | 19.58 ± 0.2% | 632.53 ± 0.8% | 96.50 ± 14.7% | 6.58 ± 0.4% | 62.95 ± 0.5% | 662.16 ± 0.6% | 1.46 | 1.00 | 1.05 | 6.86 |
| other: a number before a unit, second text | 1481 | 8054.45 ± 0.6% | 819.11 ± 0.7% | 21.88 ± 0.8% | 6409.76 ± 0.4% | 34.78 ± 3.6% | 10.29 ± 0.3% | 60.91 ± 15.6% | 8066.13 ± 2.8% | 9.83 | 1.00 | 1.26 | 231.55 |
| other: a heading's start tag | 110 | 19832.42 ± 1.2% | 579.34 ± 0.2% | 23.17 ± 0.8% | 1958.20 ± 2.1% | 1562.47 ± 5.4% | 9.08 ± 0.4% | 83.06 ± 2.6% | 19794.32 ± 0.2% | 34.23 | 1.00 | 10.13 | 12.69 |
| other: a whole word | 217 | 24660.08 ± 0.2% | 471.20 ± 0.5% | 23.66 ± 0.4% | 22051.67 ± 0.4% | 42.19 ± 0.3% | 8.58 ± 0.2% | 48.10 ± 1.9% | 24650.64 ± 0.3% | 52.33 | 1.00 | 1.12 | 584.56 |
| other: a line's first word, second text | 3716 | 2000.83 ± 0.8% | 456.19 ± 1.2% | 25.05 ± 0.4% | 1799.66 ± 1.5% | 54.14 ± 4.0% | refused | refused | 2011.58 ± 3.6% | 4.39 | 0.99 | 1.11 | 36.96 |
| other: fourteen octets before an x | 87 | 29361.09 ± 2.1% | 204.67 ± 1.2% | 5.57 ± 0.2% | 2783.37 ± 0.8% | 8.94 ± 1.4% | differs | 16.47 ± 1.7% | 29385.95 ± 0.7% | 143.45 | 1.00 | 10.55 | 3282.83 |
| other: a Greek word | 21815 | 356.69 ± 1.3% | 306.52 ± 0.4% | 25.74 ± 7.6% | 236.09 ± 0.3% | 44.31 ± 17.3% | differs | refused | 355.94 ± 0.2% | 1.16 | 1.00 | 1.51 | 8.05 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 16.69 ± 3.9% | 16.69 ± 4.3% | 0.80 ± 0.9% | 15.36 ± 2.6% | 2.18 ± 9.5% | differs | 3.23 ± 8.8% | 16.67 ± 4.9% | 1.00 | 1.00 | 1.09 | 7.65 |
| a UUID | 32895 | 18.73 ± 0.5% | 18.73 ± 0.4% | 0.56 ± 5.1% | 11.54 ± 0.1% | 2.34 ± 1.4% | 0.41 ± 0.3% | 2.90 ± 7.3% | 18.72 ± 0.4% | 1.00 | 1.00 | 1.62 | 7.99 |
| an IPv4 address | 33176 | 30.89 ± 3.8% | 30.80 ± 2.7% | 1.79 ± 1.2% | 21.94 ± 0.2% | 5.28 ± 0.9% | differs | 3.15 ± 3.6% | 30.73 ± 4.6% | 1.00 | 1.01 | 1.41 | 5.85 |
| a date and time | 32954 | 27.86 ± 0.7% | 27.82 ± 1.6% | 1.32 ± 2.1% | 16.79 ± 0.6% | 6.17 ± 3.1% | 0.71 ± 0.2% | 5.61 ± 3.5% | 27.50 ± 0.4% | 1.00 | 1.01 | 1.66 | 4.52 |
| a field path | 32606 | 18.73 ± 0.7% | 19.31 ± 0.3% | 0.88 ± 0.3% | 17.76 ± 0.2% | 2.69 ± 3.3% | differs | 2.28 ± 2.1% | 19.57 ± 1.0% | 0.97 | 0.96 | 1.06 | 6.97 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 8.53 ± 20.8% | 8.53 ± 0.6% | 8.51 ± 0.3% | 10.48 ± 1.7% | 4.34 ± 27.1% | 0.56 ± 6.2% | none | 8.48 ± 1.3% | 1.00 | 1.01 | 0.81 | 1.96 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 196.18 ± 0.5% | 196.49 ± 0.8% | 232.03 ± 3.4% | 78.30 ± 9.9% | 186.19 ± 32.1% | 550.62 ± 1.6% | 3694.45 ± 0.6% | 195.93 ± 1.3% | 1.00 | 1.00 | 2.51 | 1.05 |
| a UUID | 62 | 128.88 ± 0.4% | 129.44 ± 0.2% | 145.93 ± 0.2% | 44.92 ± 1.3% | 92.52 ± 5.5% | 196.29 ± 2.4% | 4073.84 ± 0.7% | 128.93 ± 0.8% | 1.00 | 1.00 | 2.87 | 1.39 |
| an IPv4 address | 29 | 374.89 ± 15.3% | 380.33 ± 0.3% | 540.89 ± 1.6% | 68.17 ± 0.2% | 114.62 ± 25.5% | 318.62 ± 3.6% | 6561.75 ± 2.7% | 376.76 ± 2.7% | 0.99 | 1.00 | 5.50 | 3.27 |
| a date and time | 56 | 272.02 ± 0.3% | 274.02 ± 0.6% | 346.08 ± 16.8% | 66.25 ± 8.0% | 125.10 ± 20.0% | 372.69 ± 0.2% | 4230.26 ± 0.4% | 271.90 ± 0.2% | 0.99 | 1.00 | 4.11 | 2.17 |
| a field path | 39 | 194.87 ± 5.4% | 194.44 ± 7.3% | 231.03 ± 2.6% | 72.54 ± 2.4% | 174.45 ± 2.8% | 581.50 ± 2.3% | 4407.45 ± 18.5% | 195.11 ± 0.4% | 1.00 | 1.00 | 2.69 | 1.12 |
| literal: a word | 7 | 556.14 ± 0.4% | 599.85 ± 0.3% | 1096.49 ± 0.7% | 496.87 ± 1.6% | 600.45 ± 2.9% | 1228.48 ± 0.1% | 20887.12 ± 1.2% | 555.98 ± 0.3% | 0.93 | 1.00 | 1.12 | 0.93 |
| literal: a word that is not there | 8 | 539.19 ± 6.2% | 580.89 ± 1.0% | 1034.34 ± 0.3% | 454.11 ± 0.5% | 584.54 ± 3.9% | 1168.53 ± 1.0% | 20712.66 ± 13.9% | 538.76 ± 1.2% | 0.93 | 1.00 | 1.19 | 0.92 |
| literal: one of four words | 26 | 213.86 ± 2.1% | 346.57 ± 0.3% | 472.59 ± 0.6% | 41.61 ± 1.2% | 220.80 ± 2.9% | 460.58 ± 0.9% | 13370.89 ± 0.9% | 213.54 ± 2.5% | 0.62 | 1.00 | 5.14 | 0.97 |
| literal: a word in any case | 11 | 367.73 ± 0.9% | 393.60 ± 0.4% | 563.56 ± 0.5% | 14.53 ± 1.1% | 629.57 ± 4.4% | refused | 17724.22 ± 1.5% | 367.96 ± 1.0% | 0.93 | 1.00 | 25.31 | 0.58 |
| literal: an href attribute | 12 | 307.97 ± 15.8% | 320.86 ± 0.3% | 433.33 ± 5.3% | 39.44 ± 10.0% | 427.07 ± 5.7% | 974.26 ± 13.3% | 16078.12 ± 0.3% | 308.17 ± 3.6% | 0.96 | 1.00 | 7.81 | 0.72 |
| literal: a word, second text | 10 | 499.09 ± 0.8% | 547.90 ± 0.3% | 928.65 ± 0.5% | 411.89 ± 3.7% | 508.26 ± 3.0% | 1029.53 ± 0.5% | 19607.57 ± 14.8% | 499.29 ± 0.5% | 0.91 | 1.00 | 1.21 | 0.98 |
| class: two capitalized words | 23 | 391.40 ± 0.3% | 420.35 ± 0.8% | 620.57 ± 4.0% | 94.36 ± 1.5% | 453.60 ± 4.6% | 941.19 ± 1.5% | 5928.40 ± 1.2% | 391.58 ± 0.2% | 0.93 | 1.00 | 4.15 | 0.86 |
| class: a word that ends in ing | 9 | 491.67 ± 0.3% | 558.28 ± 0.3% | 987.62 ± 0.8% | 116.64 ± 1.9% | 647.55 ± 17.7% | 1415.84 ± 1.7% | 13123.36 ± 0.5% | 491.97 ± 0.2% | 0.88 | 1.00 | 4.22 | 0.76 |
| class: a word in capitals | 16 | 436.82 ± 0.2% | 474.33 ± 0.2% | 767.55 ± 0.9% | 119.78 ± 0.2% | 687.84 ± 8.6% | 1345.83 ± 1.1% | 7636.39 ± 0.4% | 437.51 ± 1.5% | 0.92 | 1.00 | 3.65 | 0.64 |
| class: a number | 6 | 545.42 ± 0.2% | 604.78 ± 0.3% | 1154.40 ± 0.5% | 36.71 ± 2.0% | 1241.92 ± 3.7% | 2356.05 ± 6.1% | 16811.30 ± 0.7% | 545.03 ± 1.7% | 0.90 | 1.00 | 14.86 | 0.44 |
| class: two capitalized words, second text | 23 | 390.96 ± 0.9% | 420.28 ± 1.1% | 620.73 ± 1.5% | 94.95 ± 2.8% | 454.87 ± 8.9% | 983.54 ± 6.7% | 5932.89 ± 5.1% | 391.00 ± 2.1% | 0.93 | 1.00 | 4.12 | 0.86 |
| other: a word between two words | 13 | 481.70 ± 0.8% | 501.84 ± 0.1% | 804.07 ± 0.8% | 123.12 ± 1.0% | 445.29 ± 2.6% | 1039.95 ± 1.2% | 12206.29 ± 0.6% | 481.42 ± 3.0% | 0.96 | 1.00 | 3.91 | 1.08 |
| other: a number before a unit, second text | 15 | 350.20 ± 0.2% | 390.16 ± 0.8% | 558.15 ± 0.3% | 34.03 ± 0.5% | 552.06 ± 1.3% | 1111.12 ± 1.7% | 12334.96 ± 0.6% | 350.02 ± 0.6% | 0.90 | 1.00 | 10.29 | 0.63 |
| other: a heading's start tag | 13 | 315.46 ± 0.6% | 323.07 ± 9.8% | 437.14 ± 21.5% | 37.51 ± 1.8% | 528.18 ± 2.0% | 1088.87 ± 1.5% | 13612.47 ± 0.6% | 312.85 ± 5.9% | 0.98 | 1.01 | 8.41 | 0.60 |
| other: a whole word | 11 | 497.45 ± 3.4% | 530.51 ± 0.5% | 881.12 ± 0.6% | 110.69 ± 0.9% | 513.79 ± 3.8% | 1071.48 ± 0.7% | 19998.03 ± 1.2% | 497.68 ± 13.6% | 0.94 | 1.00 | 4.49 | 0.97 |
| other: a line's first word, second text | 17 | 453.81 ± 4.7% | 481.48 ± 11.9% | 789.42 ± 0.9% | 116.33 ± 0.4% | 612.36 ± 1.1% | refused | refused | 459.44 ± 0.4% | 0.94 | 0.99 | 3.90 | 0.74 |
| other: fourteen octets before an x | 16 | 90.65 ± 2.7% | 134.14 ± 0.6% | 159.54 ± 0.8% | 14.16 ± 0.2% | 396.89 ± 24.4% | 445.84 ± 0.6% | 10778.52 ± 0.8% | 90.31 ± 1.4% | 0.68 | 1.00 | 6.40 | 0.23 |
| other: a Greek word | 8 | 370.22 ± 0.5% | 513.57 ± 13.5% | 880.20 ± 2.8% | 48.87 ± 0.5% | 1219.65 ± 2.8% | 2184.65 ± 15.4% | refused | 371.11 ± 0.6% | 0.72 | 1.00 | 7.58 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 28476.29 ± 12.8% | not timed | not timed | 26151.80 ± 1.3% | 2050.12 ± 8.8% | not timed | not timed | 28554.23 ± 0.9% | | 1.00 | 1.09 | 13.89 |
| 01-literal/sherlock-casei-en | 522 | 22911.81 ± 0.3% | not timed | not timed | 6965.56 ± 0.5% | 26.19 ± 7.3% | not timed | not timed | 22865.40 ± 0.4% | | 1.00 | 3.29 | 874.92 |
| 01-literal/sherlock-ru | 724 | 30292.03 ± 0.2% | not timed | not timed | 26533.30 ± 0.5% | 969.40 ± 10.4% | not timed | not timed | 30300.83 ± 0.7% | | 1.00 | 1.14 | 31.25 |
| 01-literal/sherlock-casei-ru | 746 | 9784.75 ± 0.3% | not timed | not timed | 6105.70 ± 2.4% | 28.98 ± 1.5% | not timed | not timed | 9760.31 ± 0.3% | | 1.00 | 1.60 | 337.68 |
| 01-literal/sherlock-zh | 30 | 47515.87 ± 0.6% | not timed | not timed | 33174.63 ± 1.6% | 1266.78 ± 1.0% | not timed | not timed | 47572.76 ± 0.4% | | 1.00 | 1.43 | 37.51 |
| 02-literal-alternate/sherlock-en | 714 | 10829.69 ± 0.6% | not timed | not timed | 8581.14 ± 0.2% | 12.32 ± 14.8% | not timed | not timed | 10841.21 ± 0.3% | | 1.00 | 1.26 | 878.73 |
| 02-literal-alternate/sherlock-casei-en | 725 | 3845.55 ± 10.6% | not timed | not timed | 1770.51 ± 0.7% | 8.68 ± 1.6% | not timed | not timed | 3866.66 ± 7.3% | | 0.99 | 2.17 | 442.88 |
| 02-literal-alternate/sherlock-ru | 899 | 8507.44 ± 1.3% | not timed | not timed | 7662.69 ± 1.4% | 18.67 ± 2.1% | not timed | not timed | 8521.30 ± 0.5% | | 1.00 | 1.11 | 455.67 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 1921.12 ± 3.4% | not timed | not timed | 928.64 ± 0.3% | 8.01 ± 1.2% | not timed | not timed | 1923.03 ± 4.7% | | 1.00 | 2.07 | 239.82 |
| 02-literal-alternate/sherlock-zh | 207 | 15758.71 ± 0.6% | not timed | not timed | 10026.28 ± 0.2% | 26.20 ± 0.3% | not timed | not timed | 15747.08 ± 1.4% | | 1.00 | 1.57 | 601.44 |
| 03-date/ascii | 111817 | 98.03 ± 0.5% | not timed | not timed | 76.36 ± 2.7% | 0.18 ± 2.8% | not timed | not timed | 97.26 ± 0.7% | | 1.01 | 1.28 | 544.60 |
| 04-ruff-noqa/real | 84 | 380.79 ± 0.5% | not timed | not timed | 390.61 ± 0.3% | 16.09 ± 3.6% | not timed | not timed | 369.95 ± 0.8% | | 1.03 | 0.97 | 23.67 |
| 04-ruff-noqa/tweaked | 44 | 481.59 ± 0.8% | not timed | not timed | 400.47 ± 1.0% | 291.27 ± 0.5% | not timed | not timed | 476.37 ± 0.6% | | 1.01 | 1.20 | 1.65 |
| 05-lexer-veryl/single | 124800 | 3.94 ± 1.2% | not timed | not timed | 4.23 ± 0.6% | 0.20 ± 8.5% | not timed | not timed | 3.93 ± 2.1% | | 1.00 | 0.93 | 19.87 |
| 06-cloud-flare-redos/original | 107 | 317.27 ± 0.5% | not timed | not timed | 176.22 ± 0.7% | 19.24 ± 4.8% | not timed | not timed | 316.21 ± 0.6% | | 1.00 | 1.80 | 16.49 |
| 06-cloud-flare-redos/simplified-short | 102 | 306.93 ± 19.1% | not timed | not timed | 182.80 ± 1.0% | 21.46 ± 3.1% | not timed | not timed | 307.36 ± 0.5% | | 1.00 | 1.68 | 14.30 |
| 06-cloud-flare-redos/simplified-long | 10000 | 391.28 ± 0.7% | not timed | not timed | 200.88 ± 0.3% | 23.00 ± 0.4% | not timed | not timed | 389.19 ± 1.0% | | 1.01 | 1.95 | 17.01 |
| 07-unicode-character-data/parse-line | 558784 | 193.72 ± 2.6% | not timed | not timed | 155.85 ± 9.5% | 30.65 ± 1.8% | not timed | not timed | 196.84 ± 4.1% | | 0.98 | 1.24 | 6.32 |
| 08-words/all-english | 56691 | 86.24 ± 0.7% | not timed | not timed | 65.23 ± 0.2% | 11.51 ± 2.1% | not timed | not timed | 85.86 ± 15.2% | | 1.00 | 1.32 | 7.49 |
| 08-words/long-english | 839 | 476.88 ± 0.2% | not timed | not timed | 452.56 ± 0.8% | 27.26 ± 0.5% | not timed | not timed | 476.74 ± 0.2% | | 1.00 | 1.05 | 17.49 |
| 09-aws-keys/full | 0 | 384.83 ± 4.2% | not timed | not timed | 418.47 ± 0.4% | 52.34 ± 6.2% | not timed | not timed | 374.73 ± 1.3% | | 1.03 | 0.92 | 7.35 |
| 09-aws-keys/quick | 0 | 890.91 ± 10.7% | not timed | not timed | 741.82 ± 0.6% | 327.95 ± 0.4% | not timed | not timed | 891.88 ± 10.7% | | 1.00 | 1.20 | 2.72 |
| 10-bounded-repeat/letters-en | 1833 | 527.29 ± 0.9% | not timed | not timed | 431.16 ± 0.4% | 17.59 ± 1.3% | not timed | not timed | 526.94 ± 0.9% | | 1.00 | 1.22 | 29.97 |
| 10-bounded-repeat/letters-ru | 3475 | 408.27 ± 1.9% | not timed | not timed | 373.90 ± 3.9% | 20.26 ± 9.4% | not timed | not timed | 408.56 ± 2.7% | | 1.00 | 1.09 | 20.15 |
| 10-bounded-repeat/context | 53 | 70.31 ± 1.6% | not timed | not timed | 54.93 ± 2.2% | 17.41 ± 1.4% | not timed | not timed | 70.47 ± 6.2% | | 1.00 | 1.28 | 4.04 |
| 10-bounded-repeat/capitals | 11 | 495.60 ± 8.1% | not timed | not timed | 469.26 ± 0.2% | 31.28 ± 3.4% | not timed | not timed | 496.13 ± 8.0% | | 1.00 | 1.06 | 15.85 |
| 11-unstructured-to-json/extract | 600 | 38.00 ± 2.4% | not timed | not timed | 62.86 ± 1.6% | 39.65 ± 2.0% | not timed | not timed | 37.84 ± 33.2% | | 1.00 | 0.60 | 0.96 |
| 12-dictionary/single | 1 | 398.84 ± 0.2% | not timed | not timed | 374.41 ± 0.2% | 0.30 ± 1.4% | not timed | not timed | 399.54 ± 1.0% | | 1.00 | 1.07 | 1315.20 |
| 14-quadratic/1x | 100 | 20.23 ± 1.4% | not timed | not timed | 9.43 ± 0.5% | 0.78 ± 2.3% | not timed | not timed | 20.39 ± 1.1% | | 0.99 | 2.15 | 25.94 |
| 14-quadratic/2x | 200 | 15.60 ± 2.2% | not timed | not timed | 4.75 ± 0.2% | 0.42 ± 22.2% | not timed | not timed | 15.62 ± 1.8% | | 1.00 | 3.29 | 37.19 |
| 14-quadratic/10x | 1000 | 5.44 ± 1.1% | not timed | not timed | 0.94 ± 0.2% | 0.09 ± 3.0% | not timed | not timed | 5.45 ± 1.8% | | 1.00 | 5.77 | 59.86 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.05 ± 0.7% | not timed | not timed | 0.37 ± 26.7% | 0.49 ± 3.4% | not timed | not timed | 1.05 ± 0.4% | | 1.00 | 2.84 | 2.15 |
| 04-ruff-noqa/compile-real | 1 | 93.87 ± 1.5% | not timed | not timed | 13.48 ± 1.8% | 127.63 ± 5.4% | not timed | not timed | 94.52 ± 1.5% | | 0.99 | 6.96 | 0.74 |
| 05-lexer-veryl/compile-single | 1 | 12.57 ± 0.7% | not timed | not timed | 2.32 ± 0.3% | 5.96 ± 4.1% | not timed | not timed | 12.61 ± 1.3% | | 1.00 | 5.43 | 2.11 |
| 07-unicode-character-data/compile | 1 | 95.39 ± 9.7% | not timed | not timed | 23.72 ± 0.6% | 33.16 ± 2.4% | not timed | not timed | 95.61 ± 0.7% | | 1.00 | 4.02 | 2.88 |
| 09-aws-keys/compile-full | 1 | 42.62 ± 6.2% | not timed | not timed | 7.74 ± 6.7% | 20.53 ± 12.0% | not timed | not timed | 42.35 ± 4.6% | | 1.01 | 5.50 | 2.08 |
| 09-aws-keys/compile-quick | 1 | 147.41 ± 2.7% | not timed | not timed | 45.27 ± 0.7% | 120.14 ± 3.1% | not timed | not timed | 147.39 ± 1.8% | | 1.00 | 3.26 | 1.23 |
| 10-bounded-repeat/compile-context | 1 | 46.00 ± 7.7% | not timed | not timed | 10.83 ± 0.3% | 15.63 ± 1.5% | not timed | not timed | 46.03 ± 0.5% | | 1.00 | 4.25 | 2.94 |
| 10-bounded-repeat/compile-capitals | 1 | 70.67 ± 0.5% | not timed | not timed | 8.09 ± 15.3% | 22.54 ± 0.9% | not timed | not timed | 70.71 ± 2.9% | | 1.00 | 8.73 | 3.14 |
| 11-unstructured-to-json/compile | 1 | 145.08 ± 2.2% | not timed | not timed | 37.08 ± 0.5% | 61.05 ± 4.1% | not timed | not timed | 144.93 ± 1.4% | | 1.00 | 3.91 | 2.38 |
| 12-dictionary/compile-single | 1 | 0.25 ± 1.3% | not timed | not timed | 0.06 ± 11.0% | 0.09 ± 20.5% | not timed | not timed | 0.25 ± 0.8% | | 1.00 | 3.87 | 2.78 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.53 ± 1.1% | not timed | not timed | 5.19 ± 1.5% | 0.52 ± 2.1% | not timed | not timed | 5.53 ± 1.7% | | 1.00 | 1.07 | 10.62 |
| dictionary/search/english-10 | 690 | 1.00 ± 2.5% | not timed | not timed | 118.89 ± 1.7% | 0.01 ± 0.2% | not timed | not timed | 1.00 ± 1.4% | | 1.00 | 0.0084 | 189.06 |
| dictionary/search/english-15 | 15 | 398.24 ± 0.2% | not timed | not timed | 373.93 ± 0.3% | 0.27 ± 6.3% | not timed | not timed | 397.49 ± 1.1% | | 1.00 | 1.07 | 1454.09 |
| folly/awyer-inn-busted | 1 | 3367.05 ± 16.7% | not timed | not timed | 102.58 ± 0.3% | 37.03 ± 1.6% | not timed | not timed | 3360.95 ± 11.2% | | 1.00 | 32.82 | 90.92 |
| folly/literal-never-match-rare | 0 | 52275.96 ± 15.9% | not timed | not timed | 35948.11 ± 0.4% | 53635.67 ± 0.6% | not timed | not timed | 52503.77 ± 0.7% | | 1.00 | 1.45 | 0.97 |
| folly/literal-never-match-frequent | 0 | 20869.17 ± 7.4% | not timed | not timed | 35694.50 ± 33.9% | 1995.40 ± 0.2% | not timed | not timed | 21085.76 ± 8.7% | | 0.99 | 0.58 | 10.46 |
| folly/literal-never-match-tricksy | 1 | 3085.88 ± 0.4% | not timed | not timed | 4774.05 ± 1.2% | 1337.28 ± 0.4% | not timed | not timed | 3083.06 ± 1.3% | | 1.00 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1107.46 ± 0.5% | not timed | not timed | 750.04 ± 1.2% | 315.00 ± 39.2% | not timed | not timed | 1102.65 ± 2.5% | | 1.00 | 1.48 | 3.52 |
| grep/long-words-ascii | 5073 | 390.04 ± 20.1% | not timed | not timed | 385.19 ± 1.9% | 39.96 ± 8.0% | not timed | not timed | 390.34 ± 0.6% | | 1.00 | 1.01 | 9.76 |
| imported/leipzig/twain | 811 | 44291.57 ± 1.7% | not timed | not timed | 33593.02 ± 1.7% | 10188.39 ± 24.6% | not timed | not timed | 44508.02 ± 0.9% | | 1.00 | 1.32 | 4.35 |
| imported/leipzig/twain-insensitive | 965 | 11993.77 ± 0.4% | not timed | not timed | 10653.95 ± 0.2% | 34.45 ± 1.2% | not timed | not timed | 11980.99 ± 4.0% | | 1.00 | 1.13 | 348.12 |
| imported/leipzig/shing | 1540 | 488.48 ± 0.4% | not timed | not timed | 17082.45 ± 0.5% | 29.40 ± 4.2% | not timed | not timed | 488.61 ± 0.6% | | 1.00 | 0.0286 | 16.61 |
| imported/leipzig/huck-saw | 262 | 20005.79 ± 3.8% | not timed | not timed | 14708.62 ± 0.4% | 27.21 ± 2.8% | not timed | not timed | 19976.51 ± 12.0% | | 1.00 | 1.36 | 735.22 |
| imported/leipzig/word-ending-nn | 262 | 472.61 ± 0.1% | not timed | not timed | 467.52 ± 0.7% | 21.36 ± 0.3% | not timed | not timed | 472.77 ± 0.2% | | 1.00 | 1.01 | 22.13 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 9136.51 ± 0.9% | not timed | not timed | 3007.80 ± 0.6% | 9.40 ± 1.8% | not timed | not timed | 9129.84 ± 0.8% | | 1.00 | 3.04 | 972.36 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 16909.48 ± 1.7% | not timed | not timed | 13767.63 ± 9.5% | 14.89 ± 1.8% | not timed | not timed | 17006.40 ± 1.2% | | 0.99 | 1.23 | 1135.31 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4257.99 ± 0.6% | not timed | not timed | 613.28 ± 19.6% | 9.46 ± 1.3% | not timed | not timed | 4259.21 ± 0.6% | | 1.00 | 6.94 | 450.24 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 470.97 ± 0.2% | not timed | not timed | 467.12 ± 0.3% | 9.68 ± 0.1% | not timed | not timed | 471.31 ± 0.2% | | 1.00 | 1.01 | 48.64 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 471.55 ± 0.3% | not timed | not timed | 467.43 ± 0.1% | 8.34 ± 0.5% | not timed | not timed | 471.85 ± 0.1% | | 1.00 | 1.01 | 56.57 |
| imported/leipzig/tom-river | 2 | 10082.90 ± 1.0% | not timed | not timed | 10399.08 ± 1.3% | 27.08 ± 0.8% | not timed | not timed | 10049.55 ± 0.9% | | 1.00 | 0.97 | 372.39 |
| imported/leipzig/ing | 78424 | 463.43 ± 0.7% | not timed | not timed | 432.63 ± 1.0% | 23.64 ± 4.2% | not timed | not timed | 464.06 ± 0.7% | | 1.00 | 1.07 | 19.60 |
| imported/leipzig/ing-whitespace | 55248 | 571.45 ± 2.3% | not timed | not timed | 1668.43 ± 8.8% | 16.60 ± 1.9% | not timed | not timed | 574.52 ± 0.3% | | 0.99 | 0.34 | 34.43 |
| imported/leipzig/awyer-inn | 209 | 597.74 ± 1.4% | not timed | not timed | 10856.09 ± 0.4% | 18.47 ± 0.2% | not timed | not timed | 598.09 ± 2.3% | | 1.00 | 0.0551 | 32.36 |
| imported/leipzig/quotes-bounded | 8886 | 1433.03 ± 0.3% | not timed | not timed | 2533.78 ± 0.5% | 31.79 ± 3.6% | not timed | not timed | 1438.38 ± 0.7% | | 1.00 | 0.57 | 45.08 |
| imported/leipzig/non-ascii-alternate | 2 | 31252.53 ± 2.1% | not timed | not timed | 15423.65 ± 0.1% | 44.16 ± 4.7% | not timed | not timed | 31383.16 ± 1.8% | | 1.00 | 2.03 | 707.65 |
| imported/leipzig/math-symbols | 69 | 1881.62 ± 0.3% | not timed | not timed | 468.00 ± 0.4% | 30.48 ± 0.6% | not timed | not timed | 1883.78 ± 0.2% | | 1.00 | 4.02 | 61.72 |
| imported/leipzig/bounded-strings-ending-z | 0 | 472.70 ± 0.5% | not timed | not timed | 469.03 ± 0.6% | 19.66 ± 2.4% | not timed | not timed | 472.90 ± 1.3% | | 1.00 | 1.01 | 24.04 |
| imported/lh3lh3-reb/uri | 17549 | 562.47 ± 2.2% | not timed | not timed | 876.49 ± 0.7% | 23.59 ± 2.7% | not timed | not timed | 564.70 ± 0.3% | | 1.00 | 0.64 | 23.84 |
| imported/lh3lh3-reb/email | 15057 | 619.55 ± 21.5% | not timed | not timed | 874.88 ± 0.6% | 26.24 ± 3.6% | not timed | not timed | 622.01 ± 1.3% | | 1.00 | 0.71 | 23.61 |
| imported/lh3lh3-reb/date | 668 | 720.27 ± 0.6% | not timed | not timed | 790.46 ± 0.6% | 41.28 ± 6.5% | not timed | not timed | 712.60 ± 0.6% | | 1.01 | 0.91 | 17.45 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 576.12 ± 1.4% | not timed | not timed | 343.74 ± 0.1% | 12.84 ± 1.6% | not timed | not timed | 577.56 ± 0.3% | | 1.00 | 1.68 | 44.86 |
| imported/mariomka/email | 92 | 545.95 ± 2.4% | not timed | not timed | 46620.36 ± 0.7% | 27.76 ± 1.0% | not timed | not timed | 545.94 ± 2.4% | | 1.00 | 0.0117 | 19.67 |
| imported/mariomka/uri | 5301 | 466.91 ± 0.1% | not timed | not timed | 6174.86 ± 0.9% | 27.77 ± 0.8% | not timed | not timed | 467.02 ± 0.6% | | 1.00 | 0.0756 | 16.82 |
| imported/mariomka/ip | 5 | 1401.63 ± 3.2% | not timed | not timed | 1806.98 ± 0.4% | 17.44 ± 3.3% | not timed | not timed | 1407.40 ± 4.4% | | 1.00 | 0.78 | 80.38 |
| imported/rsc/no-exponential | 0 | 635.32 ± 1.1% | not timed | not timed | 325.81 ± 0.9% | 20.32 ± 0.4% | not timed | not timed | 619.29 ± 1.2% | | 1.03 | 1.95 | 31.27 |
| imported/rsc/literal | 1 | 634.52 ± 9.6% | not timed | not timed | 1638.26 ± 1.0% | 213.95 ± 19.2% | not timed | not timed | 688.26 ± 11.9% | | 0.92 | 0.39 | 2.97 |
| imported/rsc/not-literal | 2 | 624.54 ± 20.0% | not timed | not timed | 658.03 ± 0.4% | 42.27 ± 7.0% | not timed | not timed | 601.50 ± 2.1% | | 1.04 | 0.95 | 14.77 |
| imported/rsc/match-class | 1 | 1111.37 ± 1.4% | not timed | not timed | 1407.61 ± 2.2% | 52.21 ± 1.1% | not timed | not timed | 1111.35 ± 0.9% | | 1.00 | 0.79 | 21.28 |
| imported/rsc/match-class-in-range | 1 | 1108.17 ± 2.0% | not timed | not timed | 2632.27 ± 0.9% | 53.61 ± 14.7% | not timed | not timed | 1110.60 ± 0.8% | | 1.00 | 0.42 | 20.67 |
| imported/rsc/match-class-unicode | 1 | 426.24 ± 0.2% | not timed | not timed | 402.11 ± 0.4% | 64.49 ± 43.7% | not timed | not timed | 423.18 ± 0.2% | | 1.01 | 1.06 | 6.61 |
| imported/rsc/anchored-literal-short-non-match | 0 | 488.27 ± 0.4% | not timed | not timed | 880.14 ± 5.0% | 264.40 ± 4.3% | not timed | not timed | 488.82 ± 0.5% | | 1.00 | 0.55 | 1.85 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7936.87 ± 0.7% | not timed | not timed | 13176.64 ± 0.4% | 4017.39 ± 3.3% | not timed | not timed | 7941.80 ± 0.6% | | 1.00 | 0.60 | 1.98 |
| imported/rsc/anchored-literal-short-match | 4 | 395.42 ± 1.9% | not timed | not timed | 431.83 ± 0.4% | 83.59 ± 10.2% | not timed | not timed | 391.74 ± 2.6% | | 1.01 | 0.92 | 4.73 |
| imported/rsc/anchored-literal-long-match | 4 | 2180.24 ± 8.2% | not timed | not timed | 6489.47 ± 10.5% | 1263.68 ± 2.1% | not timed | not timed | 2158.60 ± 0.7% | | 1.01 | 0.34 | 1.73 |
| imported/rsc/one-pass-short | 17 | 274.08 ± 13.4% | not timed | not timed | 200.80 ± 0.7% | 26.95 ± 12.9% | not timed | not timed | 264.85 ± 13.8% | | 1.03 | 1.36 | 10.17 |
| imported/rsc/one-pass-short-not | 17 | 191.16 ± 2.0% | not timed | not timed | 210.40 ± 0.3% | 26.66 ± 12.5% | not timed | not timed | 190.15 ± 9.8% | | 1.01 | 0.91 | 7.17 |
| imported/rsc/one-pass-long-prefix | 26 | 192.76 ± 9.8% | not timed | not timed | 250.97 ± 1.9% | 114.29 ± 78.1% | not timed | not timed | 194.71 ± 0.2% | | 0.99 | 0.77 | 1.69 |
| imported/rsc/one-pass-long-prefix-not | 26 | 286.21 ± 4.3% | not timed | not timed | 249.33 ± 0.4% | 61.71 ± 16.8% | not timed | not timed | 284.74 ± 10.0% | | 1.01 | 1.15 | 4.64 |
| imported/rsc/long-needle1 | 31 | 52460.56 ± 1.6% | not timed | not timed | 35488.84 ± 0.2% | 2.98 ± 0.4% | not timed | not timed | 52475.63 ± 1.5% | | 1.00 | 1.48 | 17607.85 |
| imported/rsc/long-needle2 | 31 | 52638.62 ± 1.7% | not timed | not timed | 176.36 ± 0.4% | 2.98 ± 1.7% | not timed | not timed | 52581.83 ± 0.3% | | 1.00 | 298.48 | 17678.28 |
| imported/rsc/easy0-32 | 26 | 984.30 ± 3.4% | not timed | not timed | 1510.51 ± 1.1% | 131.74 ± 18.5% | not timed | not timed | 985.09 ± 0.2% | | 1.00 | 0.65 | 7.47 |
| imported/rsc/easy0-1k | 26 | 16561.17 ± 8.6% | not timed | not timed | 15871.50 ± 0.2% | 2009.08 ± 13.9% | not timed | not timed | 16667.63 ± 1.8% | | 0.99 | 1.04 | 8.24 |
| imported/rsc/easy0-32k | 26 | 50277.78 ± 0.7% | not timed | not timed | 33975.25 ± 0.3% | 20498.16 ± 0.9% | not timed | not timed | 50261.66 ± 0.8% | | 1.00 | 1.48 | 2.45 |
| imported/rsc/easy0-1mb | 26 | 51258.38 ± 5.9% | not timed | not timed | 35811.37 ± 0.3% | 52401.85 ± 17.2% | not timed | not timed | 51144.83 ± 9.3% | | 1.00 | 1.43 | 0.98 |
| imported/rsc/easy1-32 | 19 | 298.99 ± 0.3% | not timed | not timed | 590.96 ± 0.3% | 125.60 ± 18.8% | not timed | not timed | 298.09 ± 13.7% | | 1.00 | 0.51 | 2.38 |
| imported/rsc/easy1-1k | 19 | 459.86 ± 1.8% | not timed | not timed | 12032.72 ± 4.8% | 2176.81 ± 21.4% | not timed | not timed | 459.89 ± 8.8% | | 1.00 | 0.0382 | 0.21 |
| imported/rsc/easy1-32k | 19 | 471.52 ± 1.8% | not timed | not timed | 382621.60 ± 0.8% | 22853.56 ± 12.4% | not timed | not timed | 472.14 ± 0.1% | | 1.00 | 0.0012 | 0.0206 |
| imported/rsc/easy1-1mb | 19 | 472.46 ± 0.3% | not timed | not timed | 11719486.18 ± 0.6% | 52966.11 ± 2.2% | not timed | not timed | 472.66 ± 0.7% | | 1.00 | 0.0000 | 0.0089 |
| imported/rsc/medium-32 | 27 | 367.52 ± 1.7% | not timed | not timed | 574.94 ± 0.6% | 64.49 ± 11.3% | not timed | not timed | 364.75 ± 8.4% | | 1.01 | 0.64 | 5.70 |
| imported/rsc/medium-1k | 27 | 6044.09 ± 1.0% | not timed | not timed | 9790.89 ± 0.5% | 63.66 ± 1.9% | not timed | not timed | 6059.50 ± 1.0% | | 1.00 | 0.62 | 94.94 |
| imported/rsc/medium-32k | 27 | 41186.54 ± 0.4% | not timed | not timed | 318133.83 ± 0.6% | 41.27 ± 1.8% | not timed | not timed | 36155.57 ± 1.4% | | 1.14 | 0.13 | 997.99 |
| imported/rsc/medium-1mb | 27 | 50134.43 ± 1.1% | not timed | not timed | 10108972.93 ± 0.3% | 42.00 ± 0.8% | not timed | not timed | 50104.60 ± 0.4% | | 1.00 | 0.0050 | 1193.60 |
| imported/rsc/hard-32 | 58 | 209.70 ± 2.0% | not timed | not timed | 303.82 ± 0.9% | 41.00 ± 7.2% | not timed | not timed | 208.64 ± 0.6% | | 1.01 | 0.69 | 5.11 |
| imported/rsc/hard-1k | 27 | 456.70 ± 0.5% | not timed | not timed | 9976.52 ± 0.5% | 34.65 ± 0.6% | not timed | not timed | 456.31 ± 0.2% | | 1.00 | 0.0458 | 13.18 |
| imported/rsc/hard-32k | 27 | 472.01 ± 0.1% | not timed | not timed | 316836.35 ± 1.2% | 25.61 ± 0.4% | not timed | not timed | 471.78 ± 0.5% | | 1.00 | 0.0015 | 18.43 |
| imported/rsc/hard-1mb | 51 | 471.34 ± 0.7% | not timed | not timed | 6064795.94 ± 0.9% | 25.73 ± 3.8% | not timed | not timed | 472.74 ± 5.9% | | 1.00 | 0.0001 | 18.32 |
| imported/rsc/reallyhard0-32 | 58 | 208.48 ± 2.8% | not timed | not timed | 189.01 ± 1.9% | 41.26 ± 18.1% | not timed | not timed | 207.40 ± 0.4% | | 1.01 | 1.10 | 5.05 |
| imported/rsc/reallyhard0-1k | 27 | 456.46 ± 1.5% | not timed | not timed | 449.93 ± 0.2% | 34.65 ± 0.9% | not timed | not timed | 456.20 ± 0.2% | | 1.00 | 1.01 | 13.17 |
| imported/rsc/reallyhard0-32k | 27 | 471.91 ± 2.4% | not timed | not timed | 467.20 ± 0.3% | 24.44 ± 21.1% | not timed | not timed | 470.80 ± 2.3% | | 1.00 | 1.01 | 19.31 |
| imported/rsc/reallyhard0-1mb | 51 | 472.64 ± 0.4% | not timed | not timed | 468.90 ± 2.4% | 25.72 ± 1.2% | not timed | not timed | 472.75 ± 0.4% | | 1.00 | 1.01 | 18.37 |
| imported/rsc/reallyreallyhard0-32 | 47 | 239.91 ± 0.2% | not timed | not timed | 162.39 ± 1.0% | 50.97 ± 8.6% | not timed | not timed | 238.64 ± 2.7% | | 1.01 | 1.48 | 4.71 |
| imported/rsc/reallyreallyhard0-1k | 16 | 677.28 ± 1.8% | not timed | not timed | 6007.06 ± 0.5% | 28.59 ± 1.5% | not timed | not timed | 675.67 ± 1.6% | | 1.00 | 0.11 | 23.69 |
| imported/rsc/reallyreallyhard0-32k | 16 | 493.42 ± 4.9% | not timed | not timed | 28627.20 ± 0.4% | 20.79 ± 2.5% | not timed | not timed | 494.25 ± 4.9% | | 1.00 | 0.0172 | 23.74 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 472.95 ± 0.6% | not timed | not timed | 35107.71 ± 1.4% | 20.87 ± 1.6% | not timed | not timed | 472.58 ± 0.4% | | 1.00 | 0.0135 | 22.66 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 235.84 ± 0.4% | not timed | not timed | 168.27 ± 1.8% | 51.20 ± 11.3% | not timed | not timed | 234.24 ± 3.7% | | 1.01 | 1.40 | 4.61 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 654.78 ± 2.5% | not timed | not timed | 5846.55 ± 15.9% | 28.55 ± 13.1% | not timed | not timed | 655.96 ± 1.5% | | 1.00 | 0.11 | 22.94 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 493.60 ± 4.7% | not timed | not timed | 28436.28 ± 1.7% | 20.99 ± 36.9% | not timed | not timed | 493.42 ± 5.7% | | 1.00 | 0.0174 | 23.51 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 472.96 ± 1.7% | not timed | not timed | 35222.95 ± 0.5% | 20.90 ± 0.4% | not timed | not timed | 473.06 ± 0.4% | | 1.00 | 0.0134 | 22.63 |
| imported/sherlock/name-sherlock | 776 | 39824.95 ± 2.3% | not timed | not timed | 31162.73 ± 1.6% | 10938.48 ± 34.2% | not timed | not timed | 39786.51 ± 3.1% | | 1.00 | 1.28 | 3.64 |
| imported/sherlock/name-holmes | 2766 | 20500.29 ± 9.3% | not timed | not timed | 23301.27 ± 4.9% | 3140.56 ± 27.8% | not timed | not timed | 21343.82 ± 4.0% | | 0.96 | 0.88 | 6.53 |
| imported/sherlock/name-sherlock-holmes | 1365 | 40130.53 ± 10.4% | not timed | not timed | 31153.15 ± 0.5% | 8343.21 ± 18.5% | not timed | not timed | 40267.12 ± 3.4% | | 1.00 | 1.29 | 4.81 |
| imported/sherlock/name-sherlock-casei | 816 | 36971.66 ± 0.8% | not timed | not timed | 8454.21 ± 0.3% | 26.29 ± 1.2% | not timed | not timed | 36964.62 ± 0.5% | | 1.00 | 4.37 | 1406.47 |
| imported/sherlock/name-holmes-casei | 2802 | 17587.43 ± 0.5% | not timed | not timed | 5975.37 ± 15.2% | 34.36 ± 0.6% | not timed | not timed | 17565.76 ± 0.8% | | 1.00 | 2.94 | 511.79 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 28636.43 ± 1.4% | not timed | not timed | 8831.29 ± 1.4% | 26.12 ± 2.3% | not timed | not timed | 28730.51 ± 0.4% | | 1.00 | 3.24 | 1096.47 |
| imported/sherlock/name-whitespace | 1461 | 21848.45 ± 5.8% | not timed | not timed | 21640.47 ± 1.2% | 6701.05 ± 16.6% | not timed | not timed | 21826.25 ± 2.8% | | 1.00 | 1.01 | 3.26 |
| imported/sherlock/name-alt1 | 1142 | 22012.17 ± 0.3% | not timed | not timed | 22866.83 ± 0.4% | 4400.06 ± 25.0% | not timed | not timed | 22114.13 ± 2.6% | | 1.00 | 0.96 | 5.00 |
| imported/sherlock/name-alt2 | 3542 | 13178.13 ± 2.2% | not timed | not timed | 8002.31 ± 0.5% | 27.77 ± 0.5% | not timed | not timed | 13216.94 ± 0.2% | | 1.00 | 1.65 | 474.54 |
| imported/sherlock/name-alt3 | 4507 | 8923.36 ± 0.4% | not timed | not timed | 7287.10 ± 0.6% | 8.29 ± 0.8% | not timed | not timed | 8911.64 ± 1.5% | | 1.00 | 1.22 | 1076.57 |
| imported/sherlock/name-alt3-casei | 4593 | 2591.33 ± 10.1% | not timed | not timed | 1011.85 ± 0.4% | 5.63 ± 0.5% | not timed | not timed | 2552.45 ± 5.0% | | 1.02 | 2.56 | 459.87 |
| imported/sherlock/name-alt4 | 3686 | 7122.52 ± 0.3% | not timed | not timed | 6368.87 ± 0.3% | 27.78 ± 0.7% | not timed | not timed | 7035.26 ± 1.6% | | 1.01 | 1.12 | 256.40 |
| imported/sherlock/name-alt4-casei | 4254 | 4016.08 ± 1.9% | not timed | not timed | 3461.45 ± 0.5% | 16.12 ± 1.0% | not timed | not timed | 3968.47 ± 1.3% | | 1.01 | 1.16 | 249.16 |
| imported/sherlock/name-alt5 | 4028 | 11050.80 ± 0.3% | not timed | not timed | 7669.08 ± 0.2% | 19.20 ± 0.7% | not timed | not timed | 11080.39 ± 1.5% | | 1.00 | 1.44 | 575.68 |
| imported/sherlock/name-alt5-casei | 4104 | 5115.13 ± 1.2% | not timed | not timed | 2328.44 ± 0.5% | 12.07 ± 3.0% | not timed | not timed | 5024.36 ± 2.2% | | 1.02 | 2.20 | 423.78 |
| imported/sherlock/no-match-uncommon | 0 | 53506.16 ± 1.0% | not timed | not timed | 45061.24 ± 0.4% | 44419.04 ± 0.9% | not timed | not timed | 53595.34 ± 0.6% | | 1.00 | 1.19 | 1.20 |
| imported/sherlock/no-match-common | 0 | 52236.39 ± 0.6% | not timed | not timed | 45045.39 ± 0.7% | 1659.96 ± 0.9% | not timed | not timed | 52328.97 ± 0.3% | | 1.00 | 1.16 | 31.47 |
| imported/sherlock/no-match-really-common | 0 | 33469.02 ± 0.4% | not timed | not timed | 38483.85 ± 0.4% | 1660.00 ± 1.0% | not timed | not timed | 33495.33 ± 20.7% | | 1.00 | 0.87 | 20.16 |
| imported/sherlock/the-lower | 21654 | 3106.51 ± 1.8% | not timed | not timed | 3495.93 ± 15.7% | 224.64 ± 16.0% | not timed | not timed | 3104.42 ± 4.2% | | 1.00 | 0.89 | 13.83 |
| imported/sherlock/the-upper | 2223 | 16158.11 ± 1.9% | not timed | not timed | 22619.76 ± 0.4% | 2617.91 ± 2.4% | not timed | not timed | 16291.95 ± 1.2% | | 0.99 | 0.71 | 6.17 |
| imported/sherlock/the-casei | 23961 | 2715.71 ± 1.7% | not timed | not timed | 1057.57 ± 0.7% | 31.34 ± 36.8% | not timed | not timed | 2721.35 ± 0.9% | | 1.00 | 2.57 | 86.64 |
| imported/sherlock/everything-greedy | 581881 | 211.54 ± 0.8% | not timed | not timed | 134.03 ± 1.1% | 23.69 ± 20.6% | not timed | not timed | 211.04 ± 0.5% | | 1.00 | 1.58 | 8.93 |
| imported/sherlock/everything-greedy-nl | 594933 | 361.45 ± 0.2% | not timed | not timed | 174.63 ± 0.9% | 26.66 ± 2.3% | not timed | not timed | 361.22 ± 0.2% | | 1.00 | 2.07 | 13.56 |
| imported/sherlock/letters | 447175 | 43.09 ± 3.9% | not timed | not timed | 26.12 ± 0.5% | 5.68 ± 32.4% | not timed | not timed | 42.97 ± 17.3% | | 1.00 | 1.65 | 7.58 |
| imported/sherlock/letters-upper | 14180 | 332.15 ± 3.6% | not timed | not timed | 286.62 ± 0.2% | 24.04 ± 25.2% | not timed | not timed | 332.11 ± 6.1% | | 1.00 | 1.16 | 13.82 |
| imported/sherlock/letters-lower | 432995 | 41.10 ± 16.6% | not timed | not timed | 26.73 ± 0.4% | 5.23 ± 13.6% | not timed | not timed | 43.66 ± 1.8% | | 0.94 | 1.54 | 7.86 |
| imported/sherlock/words | 447639 | 81.45 ± 12.8% | not timed | not timed | 64.43 ± 8.2% | 11.61 ± 28.6% | not timed | not timed | 81.15 ± 2.9% | | 1.00 | 1.26 | 7.02 |
| imported/sherlock/before-holmes | 4073 | 467.14 ± 0.4% | not timed | not timed | 10272.44 ± 19.7% | 20.03 ± 19.7% | not timed | not timed | 467.04 ± 0.4% | | 1.00 | 0.0455 | 23.32 |
| imported/sherlock/before-after-holmes | 2593 | 468.63 ± 0.3% | not timed | not timed | 11497.32 ± 1.3% | 20.07 ± 0.1% | not timed | not timed | 468.92 ± 0.2% | | 1.00 | 0.0408 | 23.35 |
| imported/sherlock/holmes-cochar-watson | 150 | 7910.70 ± 13.8% | not timed | not timed | 6016.23 ± 0.2% | 27.28 ± 0.9% | not timed | not timed | 7810.06 ± 0.6% | | 1.01 | 1.31 | 289.94 |
| imported/sherlock/holmes-coword-watson | 14309 | 985.16 ± 0.3% | not timed | not timed | 956.01 ± 3.2% | 5.47 ± 5.1% | not timed | not timed | 983.98 ± 3.5% | | 1.00 | 1.03 | 179.97 |
| imported/sherlock/quotes | 14437 | 1035.07 ± 0.7% | not timed | not timed | 1744.24 ± 4.2% | 29.09 ± 0.5% | not timed | not timed | 1036.83 ± 0.6% | | 1.00 | 0.59 | 35.58 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 470.81 ± 0.6% | not timed | not timed | 24253.13 ± 0.4% | 31.13 ± 0.9% | not timed | not timed | 471.37 ± 0.2% | | 1.00 | 0.0194 | 15.13 |
| imported/sherlock/word-ending-n | 35297 | 354.75 ± 1.4% | not timed | not timed | 312.49 ± 5.0% | 20.11 ± 5.2% | not timed | not timed | 353.91 ± 0.7% | | 1.00 | 1.14 | 17.64 |
| imported/sherlock/repeated-class-negation | 2130 | 14454.58 ± 0.3% | not timed | not timed | 12668.67 ± 0.2% | 9.56 ± 26.3% | not timed | not timed | 14408.53 ± 0.4% | | 1.00 | 1.14 | 1512.25 |
| imported/sherlock/ing-suffix | 20547 | 429.08 ± 2.5% | not timed | not timed | 397.47 ± 0.3% | 23.84 ± 21.3% | not timed | not timed | 433.52 ± 0.3% | | 0.99 | 1.08 | 18.00 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 459.15 ± 1.4% | not timed | not timed | 2220.00 ± 10.3% | 17.74 ± 0.6% | not timed | not timed | 454.32 ± 3.0% | | 1.01 | 0.21 | 25.88 |
| opt/accelerate/whole-line | 239963 | 390.87 ± 1.2% | not timed | not timed | 321.82 ± 4.0% | 68.27 ± 16.5% | not timed | not timed | 391.15 ± 1.1% | | 1.00 | 1.21 | 5.73 |
| opt/accelerate/non-dna | 16745 | 326.49 ± 1.2% | not timed | not timed | 338.94 ± 0.3% | 24.70 ± 17.8% | not timed | not timed | 319.63 ± 0.2% | | 1.02 | 0.96 | 13.22 |
| opt/backtrack/words-english | 40536 | 107.82 ± 5.4% | not timed | not timed | 83.59 ± 1.7% | 17.27 ± 9.2% | not timed | not timed | 110.86 ± 3.1% | | 0.97 | 1.29 | 6.24 |
| opt/fixed-length/too-small-ascii | 0 | 297.40 ± 1.5% | not timed | not timed | 547.84 ± 1.3% | 94.81 ± 3.2% | not timed | not timed | 302.97 ± 0.4% | | 0.98 | 0.54 | 3.14 |
| opt/fixed-length/too-big-ascii | 0 | 633.46 ± 1.2% | not timed | not timed | 4903.50 ± 0.4% | 116.61 ± 0.7% | not timed | not timed | 635.71 ± 0.6% | | 1.00 | 0.13 | 5.43 |
| opt/fixed-length/go33484-1 | 0 | 50.28 ± 0.7% | not timed | not timed | 945023.61 ± 0.2% | 69808.49 ± 2.6% | not timed | not timed | 50.33 ± 0.3% | | 1.00 | 0.0001 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 3355.98 ± 0.7% | not timed | not timed | 945987.21 ± 0.5% | 23083.55 ± 2.1% | not timed | not timed | 3361.96 ± 3.9% | | 1.00 | 0.0035 | 0.15 |
| opt/fixed-length/go33484-3 | 0 | 1308.70 ± 0.2% | not timed | not timed | 93147.34 ± 0.2% | 674.08 ± 6.9% | not timed | not timed | 1303.48 ± 2.2% | | 1.00 | 0.0140 | 1.94 |
| opt/literal-alt/one-pattern | 1 | 451.42 ± 0.2% | not timed | not timed | 437.31 ± 1.2% | 0.30 ± 1.9% | not timed | not timed | 452.50 ± 0.1% | | 1.00 | 1.03 | 1503.35 |
| opt/onepass/fn-predicate | 916 | 335.92 ± 1.2% | not timed | not timed | 308.81 ± 1.5% | 162.19 ± 35.6% | not timed | not timed | 334.79 ± 0.5% | | 1.00 | 1.09 | 2.07 |
| opt/onepass/first-three-words-english | 35128 | 120.72 ± 3.2% | not timed | not timed | 181.32 ± 0.6% | 63.84 ± 19.7% | not timed | not timed | 121.36 ± 1.3% | | 0.99 | 0.67 | 1.89 |
| opt/prefilter/literal-english | 1 | 51997.06 ± 0.4% | not timed | not timed | 35811.97 ± 2.3% | 20532.51 ± 0.4% | not timed | not timed | 52015.12 ± 0.4% | | 1.00 | 1.45 | 2.53 |
| opt/prefilter/literal-casei-english | 1 | 37048.91 ± 0.5% | not timed | not timed | 11342.36 ± 0.6% | 26.43 ± 0.7% | not timed | not timed | 36941.46 ± 1.4% | | 1.00 | 3.27 | 1401.65 |
| opt/prefilter/literal-russian | 1 | 54181.46 ± 1.0% | not timed | not timed | 36064.68 ± 0.4% | 1387.85 ± 1.2% | not timed | not timed | 54240.35 ± 1.1% | | 1.00 | 1.50 | 39.04 |
| opt/prefilter/literal-casei-russian | 1 | 21251.11 ± 15.4% | not timed | not timed | 8680.27 ± 1.2% | 29.03 ± 1.2% | not timed | not timed | 21288.69 ± 0.2% | | 1.00 | 2.45 | 732.00 |
| opt/prefilter/rust-functions | 948 | 11710.60 ± 1.5% | not timed | not timed | 9987.99 ± 0.5% | 1502.81 ± 0.5% | not timed | not timed | 11654.63 ± 1.3% | | 1.00 | 1.17 | 7.79 |
| opt/reverse-anchored/word-end | 1 | 3397.36 ± 0.8% | not timed | not timed | 21146069.15 ± 0.5% | 43.67 ± 0.4% | not timed | not timed | 3400.27 ± 0.2% | | 1.00 | 0.0002 | 77.80 |
| opt/reverse-inner/holmes | 2593 | 468.83 ± 0.6% | not timed | not timed | 11547.74 ± 1.6% | 19.93 ± 0.3% | not timed | not timed | 468.93 ± 1.9% | | 1.00 | 0.0406 | 23.52 |
| opt/reverse-inner/email | 47 | 805.17 ± 0.7% | not timed | not timed | 71704.14 ± 0.4% | 27.49 ± 0.4% | not timed | not timed | 803.93 ± 0.6% | | 1.00 | 0.0112 | 29.29 |
| opt/reverse-inner/factored-prefix | 3542 | 462.60 ± 0.1% | not timed | not timed | 454.23 ± 0.3% | 10.75 ± 0.6% | not timed | not timed | 462.42 ± 0.2% | | 1.00 | 1.02 | 43.02 |
| opt/reverse-inner/no-quadratic-backward | 0 | 3304.48 ± 0.1% | not timed | not timed | 469.25 ± 0.7% | 65.09 ± 2.1% | not timed | not timed | 3312.01 ± 0.8% | | 1.00 | 7.04 | 50.77 |
| opt/reverse-inner/no-quadratic-forward | 0 | 550.15 ± 4.7% | not timed | not timed | 215.08 ± 0.6% | 20.55 ± 0.5% | not timed | not timed | 549.21 ± 4.8% | | 1.00 | 2.56 | 26.78 |
| opt/reverse-suffix/holmes | 4073 | 467.10 ± 0.2% | not timed | not timed | 10204.92 ± 0.7% | 19.94 ± 1.3% | not timed | not timed | 467.37 ± 0.2% | | 1.00 | 0.0458 | 23.43 |
| opt/reverse-suffix/no-quadratic | 0 | 3300.34 ± 0.3% | not timed | not timed | 468.41 ± 0.7% | 66.52 ± 0.7% | not timed | not timed | 3313.42 ± 1.0% | | 1.00 | 7.05 | 49.61 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 107.81 ± 8.8% | not timed | not timed | 140.66 ± 0.2% | 12.96 ± 19.1% | not timed | not timed | 110.64 ± 1.9% | | 0.97 | 0.77 | 8.32 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 108.01 ± 2.8% | not timed | not timed | 141.80 ± 1.0% | 12.84 ± 16.8% | not timed | not timed | 110.51 ± 1.1% | | 0.98 | 0.76 | 8.41 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.25 ± 0.8% | not timed | not timed | 0.38 ± 1.0% | 93.57 ± 0.6% | not timed | not timed | 0.25 ± 0.7% | | 1.00 | 0.65 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 225.66 ± 2.4% | not timed | not timed | 218.45 ± 0.1% | 84.01 ± 6.3% | not timed | not timed | 224.38 ± 0.9% | | 1.01 | 1.03 | 2.69 |
| reported/i13-subset-regex/original-ascii | 4094 | 9160.68 ± 1.0% | not timed | not timed | 3017.35 ± 1.8% | 9.36 ± 1.5% | not timed | not timed | 9143.19 ± 0.6% | | 1.00 | 3.04 | 978.65 |
| reported/i13-subset-regex/original-unicode | 4094 | 9088.54 ± 1.0% | not timed | not timed | 162.93 ± 3.2% | 9.35 ± 1.4% | not timed | not timed | 9110.30 ± 1.0% | | 1.00 | 55.78 | 971.86 |
| reported/i13-subset-regex/big-ascii | 1955 | 8558.23 ± 1.0% | not timed | not timed | 42.25 ± 2.3% | 8.15 ± 1.2% | not timed | not timed | 8576.16 ± 0.8% | | 1.00 | 202.55 | 1050.22 |
| reported/i13-subset-regex/big-unicode | 1955 | 8461.75 ± 6.7% | not timed | not timed | 6.56 ± 55.4% | 8.13 ± 1.1% | not timed | not timed | 8369.89 ± 4.7% | | 1.01 | 1289.42 | 1040.51 |
| reported/i13-subset-regex/huge-ascii | 55 | 7907.54 ± 0.8% | not timed | not timed | 6.91 ± 0.6% | 7.09 ± 1.1% | not timed | not timed | 7922.61 ± 0.5% | | 1.00 | 1144.62 | 1115.19 |
| reported/i13-subset-regex/huge-unicode | 55 | 7795.55 ± 2.2% | not timed | not timed | 6.90 ± 1.3% | 7.33 ± 1.8% | not timed | not timed | 6926.74 ± 1.3% | | 1.13 | 1129.45 | 1063.55 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.14 ± 1.0% | not timed | not timed | 6.93 ± 0.5% | 7.33 ± 0.7% | not timed | not timed | 3.22 ± 1.2% | | 0.98 | 0.45 | 0.43 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.49 ± 0.6% | not timed | not timed | 6.92 ± 0.7% | 7.32 ± 0.5% | not timed | not timed | 4.49 ± 1.2% | | 1.00 | 0.65 | 0.61 |
| reported/i787-keywords/ascii | 5674 | 379.93 ± 0.4% | not timed | not timed | 130.80 ± 1.9% | 5.57 ± 0.2% | not timed | not timed | 383.68 ± 0.9% | | 0.99 | 2.90 | 68.27 |
| reported/i787-keywords/opt-ascii | 5674 | 381.82 ± 0.2% | not timed | not timed | 210.77 ± 1.0% | 9.12 ± 0.7% | not timed | not timed | 384.15 ± 0.3% | | 0.99 | 1.81 | 41.88 |
| slow/quadratic-regex-1x | 100 | 6.37 ± 0.7% | not timed | not timed | 4.65 ± 0.3% | 0.04 ± 0.5% | not timed | not timed | 6.38 ± 3.5% | | 1.00 | 1.37 | 157.84 |
| slow/quadratic-regex-2x | 199 | 2.87 ± 1.6% | not timed | not timed | 2.37 ± 0.1% | 0.01 ± 24.1% | not timed | not timed | 2.87 ± 0.7% | | 1.00 | 1.21 | 277.89 |
| slow/quadratic-haystack-1x | 100 | 20.48 ± 1.7% | not timed | not timed | 9.45 ± 0.4% | 0.81 ± 11.9% | not timed | not timed | 20.48 ± 12.0% | | 1.00 | 2.17 | 25.43 |
| slow/quadratic-haystack-2x | 200 | 15.68 ± 0.4% | not timed | not timed | 4.73 ± 0.5% | 0.43 ± 1.0% | not timed | not timed | 15.71 ± 0.9% | | 1.00 | 3.31 | 36.73 |
| unicode/codepoints/any-one | 1112064 | 261.13 ± 0.5% | not timed | not timed | 181.68 ± 1.3% | 16.63 ± 8.9% | not timed | not timed | 261.66 ± 0.8% | | 1.00 | 1.44 | 15.70 |
| unicode/codepoints/any-all | 4382592 | 206.21 ± 0.7% | not timed | not timed | 206.25 ± 1.3% | 86.18 ± 1.7% | not timed | not timed | 194.28 ± 0.3% | | 1.06 | 1.00 | 2.39 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 6.11 ± 1.1% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 473.35 ± 0.3% | not timed | not timed | 468.38 ± 0.7% | 119.02 ± 1.0% | not timed | not timed | 473.30 ± 0.2% | | 1.00 | 1.01 | 3.98 |
| unicode/overlapping-words/ascii | 6156 | 21.81 ± 7.5% | not timed | not timed | 33.44 ± 1.0% | 3.44 ± 4.6% | not timed | not timed | 21.67 ± 6.7% | | 1.01 | 0.65 | 6.35 |
| unicode/overlapping-words/english | 6156 | 1.12 ± 1.2% | not timed | not timed | 2.32 ± 0.2% | 2.29 ± 1.8% | not timed | not timed | 1.15 ± 1.3% | | 0.97 | 0.48 | 0.49 |
| unicode/overlapping-words/russian | 5710 | 1.02 ± 8.0% | not timed | not timed | 2.08 ± 0.1% | 5.66 ± 9.6% | not timed | not timed | 1.03 ± 7.3% | | 0.99 | 0.49 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 87.69 ± 5.0% | not timed | not timed | 50.16 ± 9.8% | 9.95 ± 19.7% | not timed | not timed | 86.97 ± 0.4% | | 1.01 | 1.75 | 8.81 |
| unicode/word/boundary-long-english | 3466 | 472.15 ± 0.5% | not timed | not timed | 459.78 ± 0.4% | 27.36 ± 0.7% | not timed | not timed | 473.61 ± 0.3% | | 1.00 | 1.03 | 17.26 |
| unicode/word/around-holmes-english | 27 | 472.67 ± 0.1% | not timed | not timed | 34663.27 ± 1.2% | 18.39 ± 2.0% | not timed | not timed | 472.50 ± 0.2% | | 1.00 | 0.0136 | 25.70 |
| wild/bibleref/long | 874 | 442.07 ± 0.4% | not timed | not timed | 444.99 ± 0.2% | 6.17 ± 0.8% | not timed | not timed | 443.02 ± 0.6% | | 1.00 | 0.99 | 71.68 |
| wild/bibleref/short | 30 | 16.37 ± 11.9% | not timed | not timed | 25.65 ± 1.7% | 13.45 ± 25.1% | not timed | not timed | 18.38 ± 7.9% | | 0.89 | 0.64 | 1.22 |
| wild/bibleref/line | 874 | 373.94 ± 0.4% | not timed | not timed | 209.16 ± 0.9% | 6.57 ± 1.5% | not timed | not timed | 373.11 ± 0.3% | | 1.00 | 1.79 | 56.90 |
| wild/caddy/caddy | 6 | 352.36 ± 2.1% | not timed | not timed | 227.56 ± 0.5% | 59.99 ± 13.5% | not timed | not timed | 353.64 ± 0.4% | | 1.00 | 1.55 | 5.87 |
| wild/dot-star-capture/rust-src-tools | 6 | 1127.93 ± 0.3% | not timed | not timed | 313.63 ± 1.3% | 12.34 ± 0.3% | not timed | not timed | 1127.86 ± 23.2% | | 1.00 | 3.60 | 91.43 |
| wild/ruff/noqa | 84 | 380.53 ± 0.4% | not timed | not timed | 391.85 ± 4.8% | 16.63 ± 4.0% | not timed | not timed | 369.42 ± 2.5% | | 1.03 | 0.97 | 22.88 |
| wild/ruff/unnecessary-coding-comment | 16 | 415.55 ± 0.6% | not timed | not timed | 544.96 ± 13.5% | 109.91 ± 13.3% | not timed | not timed | 415.65 ± 0.6% | | 1.00 | 0.76 | 3.78 |
| wild/ruff/string-quote-prefix | 2972 | 383.12 ± 1.0% | not timed | not timed | 357.65 ± 0.2% | 253.58 ± 29.3% | not timed | not timed | 372.17 ± 0.7% | | 1.03 | 1.07 | 1.51 |
| wild/ruff/space-around-operator | 1224378 | 183.82 ± 1.4% | not timed | not timed | 174.61 ± 4.2% | 14.79 ± 1.4% | not timed | not timed | 181.27 ± 1.2% | | 1.01 | 1.05 | 12.43 |
| wild/ruff/shebang | 282 | 377.70 ± 0.8% | not timed | not timed | 301.37 ± 0.7% | 79.58 ± 9.2% | not timed | not timed | 366.48 ± 0.2% | | 1.03 | 1.25 | 4.75 |
| wild/rustsec-cargo-audit/original-unix | 471 | 16833.38 ± 5.4% | not timed | not timed | 18254.68 ± 0.7% | 6917.79 ± 11.3% | not timed | not timed | 16924.74 ± 0.7% | | 0.99 | 0.92 | 2.43 |
| wild/rustsec-cargo-audit/original-windows | 462 | 15533.23 ± 0.5% | not timed | not timed | 17261.91 ± 1.1% | 6452.14 ± 2.3% | not timed | not timed | 15554.43 ± 0.6% | | 1.00 | 0.90 | 2.41 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 17680.82 ± 4.5% | not timed | not timed | 17993.36 ± 0.2% | 6556.30 ± 39.3% | not timed | not timed | 17769.21 ± 0.5% | | 1.00 | 0.98 | 2.70 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 13781.31 ± 0.6% | not timed | not timed | 18160.50 ± 1.7% | 6703.71 ± 6.0% | not timed | not timed | 13741.77 ± 0.8% | | 1.00 | 0.76 | 2.06 |
| wild/url/search | 234965 | 100.55 ± 13.9% | not timed | not timed | 46.68 ± 2.4% | 1.89 ± 2.0% | not timed | not timed | 99.00 ± 13.8% | | 1.02 | 2.15 | 53.29 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.02 ± 13.0% | not timed | not timed | 0.01 ± 1.2% | 0.01 ± 11.8% | not timed | not timed | 0.02 ± 47.6% | | 0.99 | 2.22 | 3.61 |
| dictionary/compile/english-15 | 1 | 0.24 ± 15.4% | not timed | not timed | 0.07 ± 2.0% | 0.09 ± 19.0% | not timed | not timed | 0.25 ± 23.2% | | 0.97 | 3.33 | 2.76 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.22 ± 10.1% | not timed | not timed | 0.02 ± 21.6% | 30.73 ± 12.2% | not timed | not timed | 0.23 ± 4.5% | | 0.95 | 12.37 | 0.0071 |
| reported/i1095-word-repetition/ascii-compile | 1 | 32.51 ± 17.2% | not timed | not timed | 13.15 ± 1.2% | 47.51 ± 32.8% | not timed | not timed | 33.61 ± 2.3% | | 0.97 | 2.47 | 0.68 |
| reported/i787-keywords/compile | 1 | 30.81 ± 9.5% | not timed | not timed | 1.86 ± 14.6% | 15.78 ± 32.8% | not timed | not timed | 31.13 ± 10.6% | | 0.99 | 16.60 | 1.95 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 275.52 ± 6.9% | not timed | not timed | 114.72 ± 0.3% | 478.48 ± 25.9% | not timed | not timed | 277.94 ± 0.5% | | 0.99 | 2.40 | 0.58 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 40.06 ± 10.3% | not timed | not timed | 4.33 ± 1.2% | 36.26 ± 12.5% | not timed | not timed | 41.64 ± 8.9% | | 0.96 | 9.26 | 1.10 |
| unicode/compile/one-letter | 53 | 5.44 ± 3.0% | not timed | not timed | 4.51 ± 7.7% | 53.89 ± 20.3% | not timed | not timed | 5.47 ± 25.4% | | 1.00 | 1.21 | 0.10 |
| unicode/compile/fifty-letters | 1 | 0.93 ± 3.5% | not timed | not timed | 0.10 ± 9.2% | 55.66 ± 15.8% | not timed | not timed | 0.94 ± 12.0% | | 0.99 | 9.56 | 0.0167 |
| unicode/compile/fifty-letters-ascii | 1 | 153.72 ± 3.8% | not timed | not timed | 53.63 ± 0.2% | 152.55 ± 34.5% | not timed | not timed | 154.12 ± 11.3% | | 1.00 | 2.87 | 1.01 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 334.96 ± 6.2% | not timed | not timed | 39.71 ± 22.0% | 591.58 ± 29.1% | not timed | not timed | 333.83 ± 10.7% | | 1.00 | 8.43 | 0.57 |
| unicode/compile/match-every-line-ascii | 4 | 528.14 ± 1.6% | not timed | not timed | 128.33 ± 0.7% | 586.89 ± 28.1% | not timed | not timed | 524.86 ± 7.6% | | 1.01 | 4.12 | 0.90 |
| unicode/compile/negated-class-matches-codepoint | 1 | 264.29 ± 8.7% | not timed | not timed | 43.72 ± 0.2% | 1120.88 ± 24.0% | not timed | not timed | 266.37 ± 10.4% | | 0.99 | 6.05 | 0.24 |
| wild/bibleref/compile | 3 | 4.54 ± 18.3% | not timed | not timed | 1.90 ± 0.9% | 27.46 ± 18.3% | not timed | not timed | 4.84 ± 10.1% | | 0.94 | 2.39 | 0.17 |
| wild/url/compile | 1 | 0.55 ± 15.6% | not timed | not timed | 0.16 ± 1.3% | 0.38 ± 18.1% | not timed | not timed | 0.55 ± 10.8% | | 1.00 | 3.45 | 1.45 |

