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
| literal: a word | 217 | 49005.01 ± 0.3% | 3931.36 ± 0.7% | 29.73 ± 0.6% | 38716.27 ± 1.3% | 12190.91 ± 2.1% | 12.88 ± 0.5% | 104.46 ± 0.2% | 48894.59 ± 1.2% | 12.47 | 1.00 | 1.27 | 4.02 |
| literal: a word that is not there | 0 | 63705.73 ± 0.9% | 3870.14 ± 0.6% | 30.06 ± 11.8% | 45934.94 ± 0.7% | 43863.92 ± 0.7% | 12.78 ± 0.2% | 98.57 ± 1.4% | 63769.37 ± 0.4% | 16.46 | 1.00 | 1.39 | 1.45 |
| literal: one of four words | 661 | 15073.84 ± 6.2% | 1668.81 ± 0.9% | 15.31 ± 0.4% | 11193.05 ± 6.6% | 24.93 ± 5.1% | 4.47 ± 0.4% | 8.24 ± 1.4% | 15110.82 ± 0.4% | 9.03 | 1.00 | 1.35 | 604.55 |
| literal: a word in any case | 217 | 42702.70 ± 11.6% | 1795.64 ± 1.2% | 22.30 ± 10.1% | 11396.94 ± 7.7% | 47.06 ± 16.0% | refused | differs | 42798.67 ± 0.9% | 23.78 | 1.00 | 3.75 | 907.35 |
| literal: an href attribute | 33 | 40285.82 ± 2.1% | 616.17 ± 0.1% | 28.85 ± 5.1% | 34686.83 ± 0.9% | 2934.72 ± 2.3% | 9.67 ± 0.2% | 91.35 ± 0.4% | 40313.43 ± 4.6% | 65.38 | 1.00 | 1.16 | 13.73 |
| literal: a word, second text | 123 | 51132.26 ± 4.4% | 3092.99 ± 0.2% | 29.83 ± 0.7% | 39392.33 ± 11.9% | 11432.12 ± 6.9% | 14.49 ± 0.6% | 87.66 ± 1.3% | 51161.02 ± 19.2% | 16.53 | 1.00 | 1.30 | 4.47 |
| class: two capitalized words | 1331 | 906.04 ± 1.1% | 605.05 ± 3.2% | 27.76 ± 4.8% | 574.93 ± 0.7% | 44.47 ± 7.7% | 11.09 ± 0.4% | 80.11 ± 1.1% | 899.71 ± 2.0% | 1.50 | 1.01 | 1.58 | 20.37 |
| class: a word that ends in ing | 3399 | 575.30 ± 0.2% | 575.23 ± 0.3% | 19.69 ± 1.5% | 540.46 ± 0.4% | 30.98 ± 13.1% | 6.10 ± 0.6% | 20.02 ± 1.7% | 575.23 ± 0.6% | 1.00 | 1.00 | 1.06 | 18.57 |
| class: a word in capitals | 2332 | 1145.96 ± 0.2% | 609.85 ± 0.2% | 29.58 ± 6.0% | 565.30 ± 0.8% | 46.96 ± 9.5% | 12.50 ± 0.3% | 100.69 ± 3.6% | 1138.81 ± 1.5% | 1.88 | 1.01 | 2.03 | 24.40 |
| class: a number | 8288 | 1812.13 ± 0.4% | 815.85 ± 0.5% | 29.81 ± 4.4% | 1793.13 ± 0.8% | 49.19 ± 12.1% | 0.39 ± 1.6% | 72.55 ± 0.2% | 1813.79 ± 1.0% | 2.22 | 1.00 | 1.01 | 36.84 |
| class: two capitalized words, second text | 5359 | 512.48 ± 0.1% | 518.04 ± 0.2% | 25.21 ± 0.3% | 478.59 ± 0.3% | 38.62 ± 8.2% | 12.71 ± 0.6% | 73.79 ± 1.0% | 512.71 ± 0.2% | 0.99 | 1.00 | 1.07 | 13.27 |
| other: a word between two words | 6104 | 855.18 ± 0.3% | 584.98 ± 0.3% | 24.91 ± 0.2% | 816.00 ± 0.2% | 129.22 ± 6.3% | 8.54 ± 0.3% | 81.36 ± 0.7% | 855.55 ± 0.3% | 1.46 | 1.00 | 1.05 | 6.62 |
| other: a number before a unit, second text | 1481 | 10433.53 ± 0.7% | 1056.60 ± 0.5% | 28.07 ± 0.8% | 8219.29 ± 1.5% | 44.91 ± 5.7% | 13.29 ± 0.2% | 78.45 ± 0.3% | 10346.62 ± 0.9% | 9.87 | 1.01 | 1.27 | 232.30 |
| other: a heading's start tag | 110 | 25400.96 ± 1.5% | 747.61 ± 0.1% | 29.81 ± 0.3% | 2550.82 ± 3.8% | 2031.60 ± 2.5% | 11.83 ± 5.6% | 107.07 ± 1.0% | 25399.08 ± 0.3% | 33.98 | 1.00 | 9.96 | 12.50 |
| other: a whole word | 217 | 31745.41 ± 0.2% | 607.73 ± 0.5% | 30.18 ± 0.5% | 27922.32 ± 1.4% | 54.31 ± 0.6% | 11.18 ± 0.2% | 62.79 ± 1.0% | 31780.89 ± 0.4% | 52.24 | 1.00 | 1.14 | 584.52 |
| other: a line's first word, second text | 3716 | 2604.56 ± 2.1% | 588.18 ± 0.4% | 31.96 ± 1.0% | 2332.75 ± 1.6% | 71.64 ± 3.1% | refused | refused | 2607.46 ± 1.9% | 4.43 | 1.00 | 1.12 | 36.35 |
| other: fourteen octets before an x | 87 | 38077.85 ± 0.5% | 266.15 ± 0.4% | 7.35 ± 4.8% | 3595.92 ± 0.7% | 11.56 ± 11.4% | differs | 20.41 ± 2.6% | 37989.91 ± 0.9% | 143.07 | 1.00 | 10.59 | 3294.36 |
| other: a Greek word | 21815 | 462.28 ± 0.4% | 396.37 ± 0.2% | 33.23 ± 0.4% | 303.57 ± 0.5% | 57.15 ± 7.9% | differs | refused | 463.25 ± 0.2% | 1.17 | 1.00 | 1.52 | 8.09 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 21.53 ± 0.4% | 21.52 ± 0.2% | 1.03 ± 0.6% | 19.91 ± 0.2% | 2.68 ± 0.5% | differs | 4.16 ± 3.0% | 21.51 ± 0.5% | 1.00 | 1.00 | 1.08 | 8.03 |
| a UUID | 32895 | 24.02 ± 3.7% | 24.15 ± 0.1% | 0.72 ± 0.2% | 15.16 ± 2.5% | 2.97 ± 4.0% | 0.52 ± 0.3% | 3.74 ± 3.5% | 24.13 ± 0.6% | 0.99 | 1.00 | 1.58 | 8.08 |
| an IPv4 address | 33176 | 39.63 ± 0.6% | 39.73 ± 0.7% | 2.31 ± 0.7% | 28.52 ± 1.1% | 6.86 ± 1.6% | differs | 4.10 ± 0.9% | 39.18 ± 10.2% | 1.00 | 1.01 | 1.39 | 5.78 |
| a date and time | 32954 | 36.00 ± 0.4% | 35.93 ± 0.9% | 1.72 ± 4.6% | 21.67 ± 0.5% | 7.98 ± 2.7% | 0.92 ± 0.3% | 7.21 ± 2.6% | 36.02 ± 6.8% | 1.00 | 1.00 | 1.66 | 4.51 |
| a field path | 32606 | 25.13 ± 0.5% | 25.22 ± 0.6% | 1.14 ± 0.9% | 23.03 ± 0.4% | 3.41 ± 1.0% | differs | 2.97 ± 1.7% | 25.25 ± 0.8% | 1.00 | 1.00 | 1.09 | 7.38 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.02 ± 1.4% | 11.05 ± 0.3% | 11.05 ± 6.3% | 12.87 ± 1.0% | 5.63 ± 5.4% | 0.76 ± 0.3% | none | 11.05 ± 7.6% | 1.00 | 1.00 | 0.86 | 1.96 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 229.63 ± 0.1% | 231.57 ± 0.1% | 274.74 ± 0.2% | 100.26 ± 1.7% | 244.06 ± 1.4% | 719.50 ± 2.5% | 4914.85 ± 0.5% | 229.58 ± 0.6% | 0.99 | 1.00 | 2.29 | 0.94 |
| a UUID | 62 | 150.57 ± 1.1% | 151.27 ± 0.2% | 170.07 ± 0.4% | 58.79 ± 1.3% | 119.16 ± 1.1% | 254.31 ± 0.8% | 5405.30 ± 0.6% | 150.79 ± 0.2% | 1.00 | 1.00 | 2.56 | 1.26 |
| an IPv4 address | 29 | 464.07 ± 0.6% | 466.52 ± 0.9% | 682.44 ± 0.6% | 87.10 ± 0.9% | 148.63 ± 3.1% | 423.41 ± 0.8% | 8991.94 ± 0.6% | 463.35 ± 0.8% | 0.99 | 1.00 | 5.33 | 3.12 |
| a date and time | 56 | 340.86 ± 0.3% | 343.82 ± 0.1% | 444.68 ± 0.2% | 84.89 ± 0.7% | 162.80 ± 2.6% | 472.26 ± 1.3% | 5540.64 ± 0.3% | 340.91 ± 0.7% | 0.99 | 1.00 | 4.02 | 2.09 |
| a field path | 39 | 222.43 ± 0.2% | 223.31 ± 0.3% | 262.20 ± 0.3% | 94.26 ± 1.8% | 228.09 ± 0.6% | 762.68 ± 2.0% | 5946.42 ± 0.3% | 222.34 ± 0.9% | 1.00 | 1.00 | 2.36 | 0.98 |
| literal: a word | 7 | 683.84 ± 0.7% | 732.15 ± 0.3% | 1405.29 ± 0.1% | 644.28 ± 1.9% | 787.05 ± 18.8% | 1631.02 ± 0.6% | 34212.56 ± 0.5% | 686.58 ± 0.2% | 0.93 | 1.00 | 1.06 | 0.87 |
| literal: a word that is not there | 8 | 668.06 ± 0.7% | 713.18 ± 0.6% | 1322.38 ± 0.3% | 592.58 ± 1.9% | 758.24 ± 2.8% | 1533.66 ± 0.3% | 33506.38 ± 0.6% | 668.05 ± 0.0% | 0.94 | 1.00 | 1.13 | 0.88 |
| literal: one of four words | 26 | 261.19 ± 0.5% | 432.52 ± 1.0% | 604.45 ± 0.4% | 53.52 ± 1.5% | 291.62 ± 15.7% | 582.86 ± 10.3% | 17550.41 ± 3.4% | 261.10 ± 0.7% | 0.60 | 1.00 | 4.88 | 0.90 |
| literal: a word in any case | 11 | 467.53 ± 1.1% | 493.20 ± 0.5% | 738.85 ± 0.8% | 18.81 ± 2.1% | 819.80 ± 17.5% | refused | 26573.80 ± 0.8% | 466.39 ± 0.9% | 0.95 | 1.00 | 24.85 | 0.57 |
| literal: an href attribute | 12 | 378.49 ± 0.3% | 392.11 ± 0.1% | 537.51 ± 0.4% | 50.53 ± 0.9% | 576.00 ± 26.2% | 1246.94 ± 7.4% | 24732.65 ± 0.3% | 378.75 ± 0.2% | 0.97 | 1.00 | 7.49 | 0.66 |
| literal: a word, second text | 10 | 618.81 ± 0.2% | 670.83 ± 0.4% | 1180.98 ± 0.3% | 533.84 ± 1.7% | 654.05 ± 25.8% | 1306.20 ± 0.4% | 32230.08 ± 1.8% | 618.25 ± 0.8% | 0.92 | 1.00 | 1.16 | 0.95 |
| class: two capitalized words | 23 | 467.96 ± 0.6% | 510.14 ± 0.5% | 777.73 ± 0.4% | 120.92 ± 0.8% | 595.75 ± 2.2% | 1252.24 ± 0.4% | 7948.10 ± 0.5% | 468.56 ± 0.9% | 0.92 | 1.00 | 3.87 | 0.79 |
| class: a word that ends in ing | 9 | 582.47 ± 0.7% | 673.84 ± 0.5% | 1257.09 ± 0.7% | 150.52 ± 1.4% | 863.17 ± 11.9% | 1861.07 ± 1.6% | 19348.95 ± 16.9% | 584.04 ± 0.4% | 0.86 | 1.00 | 3.87 | 0.67 |
| class: a word in capitals | 16 | 514.02 ± 1.2% | 567.44 ± 1.6% | 984.66 ± 2.1% | 154.90 ± 1.8% | 894.55 ± 1.8% | 1778.54 ± 2.7% | 10582.43 ± 0.2% | 513.99 ± 1.6% | 0.91 | 1.00 | 3.32 | 0.57 |
| class: a number | 6 | 644.37 ± 0.4% | 731.52 ± 0.3% | 1498.13 ± 0.5% | 47.39 ± 1.2% | 1657.03 ± 1.3% | 2983.05 ± 1.9% | 25939.33 ± 0.8% | 645.41 ± 0.2% | 0.88 | 1.00 | 13.60 | 0.39 |
| class: two capitalized words, second text | 23 | 467.40 ± 0.5% | 511.43 ± 0.2% | 777.43 ± 0.4% | 120.09 ± 0.6% | 604.19 ± 1.8% | 1237.53 ± 1.6% | 7930.22 ± 0.9% | 467.93 ± 0.7% | 0.91 | 1.00 | 3.89 | 0.77 |
| other: a word between two words | 13 | 588.97 ± 0.8% | 611.05 ± 8.4% | 1015.16 ± 0.6% | 156.88 ± 2.3% | 586.86 ± 4.7% | 1341.11 ± 2.2% | 17836.26 ± 0.8% | 589.23 ± 1.0% | 0.96 | 1.00 | 3.75 | 1.00 |
| other: a number before a unit, second text | 15 | 407.70 ± 0.3% | 458.56 ± 0.8% | 658.04 ± 0.5% | 44.02 ± 12.1% | 728.14 ± 14.9% | 1457.08 ± 0.8% | 17713.71 ± 0.7% | 407.62 ± 0.3% | 0.89 | 1.00 | 9.26 | 0.56 |
| other: a heading's start tag | 13 | 386.71 ± 7.0% | 393.84 ± 7.5% | 542.59 ± 3.6% | 48.34 ± 5.3% | 709.96 ± 0.3% | 1379.02 ± 1.1% | 20591.76 ± 2.7% | 386.86 ± 0.2% | 0.98 | 1.00 | 8.00 | 0.54 |
| other: a whole word | 11 | 603.93 ± 0.3% | 639.96 ± 0.2% | 1095.56 ± 8.2% | 139.19 ± 0.8% | 680.56 ± 47.7% | 1360.11 ± 6.8% | 31375.27 ± 0.8% | 602.45 ± 5.8% | 0.94 | 1.00 | 4.34 | 0.89 |
| other: a line's first word, second text | 17 | 561.60 ± 7.9% | 586.52 ± 1.2% | 1008.73 ± 1.1% | 146.70 ± 0.8% | 797.81 ± 4.5% | refused | refused | 563.14 ± 3.1% | 0.96 | 1.00 | 3.83 | 0.70 |
| other: fourteen octets before an x | 16 | 113.49 ± 0.3% | 168.15 ± 0.4% | 203.12 ± 1.3% | 18.14 ± 0.4% | 522.30 ± 18.3% | 576.92 ± 1.1% | 15768.64 ± 0.3% | 113.18 ± 1.4% | 0.67 | 1.00 | 6.26 | 0.22 |
| other: a Greek word | 8 | 433.93 ± 0.1% | 607.57 ± 0.3% | 1075.57 ± 0.9% | 63.02 ± 1.1% | 1630.38 ± 0.2% | 2863.27 ± 0.4% | refused | 433.95 ± 1.5% | 0.71 | 1.00 | 6.89 | 0.27 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 37593.16 ± 0.3% | not timed | not timed | 33909.54 ± 1.0% | 2280.15 ± 20.0% | not timed | not timed | 37591.95 ± 0.4% | | 1.00 | 1.11 | 16.49 |
| 01-literal/sherlock-casei-en | 522 | 29668.45 ± 0.4% | not timed | not timed | 9031.23 ± 0.2% | 33.40 ± 0.9% | not timed | not timed | 29632.39 ± 1.6% | | 1.00 | 3.29 | 888.19 |
| 01-literal/sherlock-ru | 724 | 39078.83 ± 0.3% | not timed | not timed | 34224.85 ± 0.4% | 1237.64 ± 6.0% | not timed | not timed | 38983.07 ± 0.1% | | 1.00 | 1.14 | 31.58 |
| 01-literal/sherlock-casei-ru | 746 | 12418.51 ± 13.2% | not timed | not timed | 7793.55 ± 1.5% | 37.13 ± 8.6% | not timed | not timed | 12442.56 ± 1.1% | | 1.00 | 1.59 | 334.42 |
| 01-literal/sherlock-zh | 30 | 60653.62 ± 0.3% | not timed | not timed | 42653.90 ± 0.4% | 1625.42 ± 0.3% | not timed | not timed | 60559.30 ± 0.9% | | 1.00 | 1.42 | 37.32 |
| 02-literal-alternate/sherlock-en | 714 | 13713.45 ± 0.3% | not timed | not timed | 10913.31 ± 5.0% | 16.84 ± 0.5% | not timed | not timed | 13681.20 ± 0.8% | | 1.00 | 1.26 | 814.18 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5162.93 ± 4.0% | not timed | not timed | 2300.97 ± 1.3% | 11.42 ± 1.2% | not timed | not timed | 5109.34 ± 3.7% | | 1.01 | 2.24 | 451.92 |
| 02-literal-alternate/sherlock-ru | 899 | 10831.70 ± 1.2% | not timed | not timed | 9734.72 ± 0.8% | 25.46 ± 0.4% | not timed | not timed | 10816.77 ± 0.6% | | 1.00 | 1.11 | 425.39 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2525.48 ± 3.1% | not timed | not timed | 1195.59 ± 4.5% | 10.36 ± 9.8% | not timed | not timed | 2533.75 ± 2.7% | | 1.00 | 2.11 | 243.71 |
| 02-literal-alternate/sherlock-zh | 207 | 19572.58 ± 0.3% | not timed | not timed | 12639.93 ± 6.8% | 34.99 ± 15.1% | not timed | not timed | 19574.66 ± 3.0% | | 1.00 | 1.55 | 559.34 |
| 03-date/ascii | 111817 | 127.71 ± 1.2% | not timed | not timed | 100.00 ± 0.4% | 0.23 ± 2.6% | not timed | not timed | 127.41 ± 2.5% | | 1.00 | 1.28 | 559.70 |
| 04-ruff-noqa/real | 84 | 491.22 ± 1.6% | not timed | not timed | 507.88 ± 8.2% | 20.77 ± 2.7% | not timed | not timed | 488.72 ± 0.1% | | 1.01 | 0.97 | 23.65 |
| 04-ruff-noqa/tweaked | 44 | 621.10 ± 0.7% | not timed | not timed | 498.98 ± 0.4% | 368.37 ± 0.6% | not timed | not timed | 622.96 ± 0.4% | | 1.00 | 1.24 | 1.69 |
| 05-lexer-veryl/single | 124800 | 4.95 ± 11.1% | not timed | not timed | 5.26 ± 0.6% | 0.26 ± 4.0% | not timed | not timed | 5.01 ± 1.0% | | 0.99 | 0.94 | 19.41 |
| 06-cloud-flare-redos/original | 107 | 410.70 ± 1.9% | not timed | not timed | 226.79 ± 14.5% | 25.83 ± 1.5% | not timed | not timed | 403.02 ± 16.6% | | 1.02 | 1.81 | 15.90 |
| 06-cloud-flare-redos/simplified-short | 102 | 396.28 ± 1.4% | not timed | not timed | 236.36 ± 0.4% | 27.58 ± 18.5% | not timed | not timed | 394.88 ± 0.2% | | 1.00 | 1.68 | 14.37 |
| 06-cloud-flare-redos/simplified-long | 10000 | 502.60 ± 0.9% | not timed | not timed | 258.54 ± 0.4% | 29.86 ± 0.2% | not timed | not timed | 501.53 ± 2.7% | | 1.00 | 1.94 | 16.83 |
| 07-unicode-character-data/parse-line | 558784 | 253.10 ± 2.6% | not timed | not timed | 202.12 ± 0.7% | 47.39 ± 3.8% | not timed | not timed | 254.47 ± 0.5% | | 0.99 | 1.25 | 5.34 |
| 08-words/all-english | 56691 | 112.09 ± 4.8% | not timed | not timed | 84.43 ± 2.6% | 14.49 ± 14.7% | not timed | not timed | 111.87 ± 3.5% | | 1.00 | 1.33 | 7.74 |
| 08-words/long-english | 839 | 615.09 ± 0.2% | not timed | not timed | 584.65 ± 0.1% | 35.22 ± 16.0% | not timed | not timed | 614.92 ± 0.6% | | 1.00 | 1.05 | 17.47 |
| 09-aws-keys/full | 0 | 496.05 ± 0.4% | not timed | not timed | 553.80 ± 0.5% | 67.46 ± 6.0% | not timed | not timed | 496.23 ± 0.3% | | 1.00 | 0.90 | 7.35 |
| 09-aws-keys/quick | 0 | 1150.56 ± 2.3% | not timed | not timed | 958.79 ± 0.7% | 410.13 ± 0.2% | not timed | not timed | 1152.18 ± 9.4% | | 1.00 | 1.20 | 2.81 |
| 10-bounded-repeat/letters-en | 1833 | 680.35 ± 2.8% | not timed | not timed | 557.18 ± 4.4% | 22.80 ± 0.8% | not timed | not timed | 681.46 ± 1.0% | | 1.00 | 1.22 | 29.84 |
| 10-bounded-repeat/letters-ru | 3475 | 527.31 ± 3.4% | not timed | not timed | 482.56 ± 0.4% | 25.15 ± 10.3% | not timed | not timed | 528.71 ± 1.5% | | 1.00 | 1.09 | 20.96 |
| 10-bounded-repeat/context | 53 | 89.29 ± 1.7% | not timed | not timed | 71.13 ± 4.9% | 21.27 ± 0.5% | not timed | not timed | 91.20 ± 3.0% | | 0.98 | 1.26 | 4.20 |
| 10-bounded-repeat/capitals | 11 | 641.88 ± 8.5% | not timed | not timed | 604.08 ± 0.2% | 40.16 ± 5.2% | not timed | not timed | 640.41 ± 8.1% | | 1.00 | 1.06 | 15.98 |
| 11-unstructured-to-json/extract | 600 | 48.87 ± 0.7% | not timed | not timed | 80.56 ± 1.4% | 51.08 ± 2.3% | not timed | not timed | 49.14 ± 0.6% | | 0.99 | 0.61 | 0.96 |
| 12-dictionary/single | 1 | 513.90 ± 8.6% | not timed | not timed | 481.18 ± 2.9% | 0.41 ± 8.3% | not timed | not timed | 513.93 ± 3.6% | | 1.00 | 1.07 | 1265.33 |
| 14-quadratic/1x | 100 | 26.10 ± 1.1% | not timed | not timed | 12.19 ± 0.3% | 1.00 ± 1.9% | not timed | not timed | 26.18 ± 1.6% | | 1.00 | 2.14 | 26.19 |
| 14-quadratic/2x | 200 | 19.60 ± 5.3% | not timed | not timed | 6.12 ± 0.3% | 0.54 ± 9.2% | not timed | not timed | 19.84 ± 0.8% | | 0.99 | 3.20 | 36.24 |
| 14-quadratic/10x | 1000 | 6.83 ± 9.7% | not timed | not timed | 1.22 ± 0.1% | 0.12 ± 1.4% | not timed | not timed | 6.87 ± 1.5% | | 0.99 | 5.62 | 58.40 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.36 ± 0.7% | not timed | not timed | 0.48 ± 0.6% | 0.64 ± 1.8% | not timed | not timed | 1.36 ± 0.3% | | 1.00 | 2.84 | 2.11 |
| 04-ruff-noqa/compile-real | 1 | 123.84 ± 0.6% | not timed | not timed | 17.05 ± 3.2% | 169.37 ± 1.6% | not timed | not timed | 123.36 ± 0.4% | | 1.00 | 7.26 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 16.46 ± 1.3% | not timed | not timed | 2.98 ± 9.3% | 7.87 ± 1.3% | not timed | not timed | 16.57 ± 0.7% | | 0.99 | 5.51 | 2.09 |
| 07-unicode-character-data/compile | 1 | 124.95 ± 1.4% | not timed | not timed | 30.28 ± 2.7% | 45.16 ± 1.3% | not timed | not timed | 124.66 ± 1.5% | | 1.00 | 4.13 | 2.77 |
| 09-aws-keys/compile-full | 1 | 55.19 ± 0.7% | not timed | not timed | 9.91 ± 0.5% | 27.99 ± 3.1% | not timed | not timed | 55.33 ± 0.6% | | 1.00 | 5.57 | 1.97 |
| 09-aws-keys/compile-quick | 1 | 193.55 ± 1.2% | not timed | not timed | 57.49 ± 24.2% | 158.76 ± 11.5% | not timed | not timed | 194.53 ± 17.4% | | 0.99 | 3.37 | 1.22 |
| 10-bounded-repeat/compile-context | 1 | 59.68 ± 1.2% | not timed | not timed | 14.39 ± 0.3% | 20.06 ± 5.2% | not timed | not timed | 60.21 ± 7.4% | | 0.99 | 4.15 | 2.97 |
| 10-bounded-repeat/compile-capitals | 1 | 92.38 ± 1.1% | not timed | not timed | 10.64 ± 9.4% | 29.14 ± 9.8% | not timed | not timed | 93.61 ± 1.3% | | 0.99 | 8.68 | 3.17 |
| 11-unstructured-to-json/compile | 1 | 189.81 ± 0.7% | not timed | not timed | 47.56 ± 0.9% | 82.32 ± 2.0% | not timed | not timed | 190.31 ± 0.6% | | 1.00 | 3.99 | 2.31 |
| 12-dictionary/compile-single | 1 | 0.34 ± 0.5% | not timed | not timed | 0.08 ± 0.8% | 0.11 ± 23.4% | not timed | not timed | 0.35 ± 4.2% | | 1.00 | 4.06 | 3.00 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.15 ± 1.6% | not timed | not timed | 6.91 ± 15.5% | 0.59 ± 18.5% | not timed | not timed | 7.15 ± 2.7% | | 1.00 | 1.03 | 12.02 |
| dictionary/search/english-10 | 690 | 1.31 ± 1.0% | not timed | not timed | 152.68 ± 1.6% | 0.01 ± 0.5% | not timed | not timed | 1.29 ± 0.4% | | 1.02 | 0.0086 | 187.72 |
| dictionary/search/english-15 | 15 | 513.63 ± 2.4% | not timed | not timed | 478.83 ± 1.2% | 0.36 ± 1.6% | not timed | not timed | 514.32 ± 0.2% | | 1.00 | 1.07 | 1434.17 |
| folly/awyer-inn-busted | 1 | 4243.67 ± 0.4% | not timed | not timed | 132.20 ± 3.1% | 48.15 ± 14.5% | not timed | not timed | 4248.53 ± 7.9% | | 1.00 | 32.10 | 88.14 |
| folly/literal-never-match-rare | 0 | 67799.19 ± 0.8% | not timed | not timed | 46387.14 ± 0.8% | 69335.91 ± 0.2% | not timed | not timed | 67884.56 ± 0.7% | | 1.00 | 1.46 | 0.98 |
| folly/literal-never-match-frequent | 0 | 27624.29 ± 15.6% | not timed | not timed | 46042.62 ± 1.8% | 2577.93 ± 4.5% | not timed | not timed | 26500.73 ± 12.9% | | 1.04 | 0.60 | 10.72 |
| folly/literal-never-match-tricksy | 1 | 3972.44 ± 12.6% | not timed | not timed | 6152.55 ± 0.2% | 1723.01 ± 0.4% | not timed | not timed | 3970.07 ± 0.2% | | 1.00 | 0.65 | 2.31 |
| grep/every-line | 239963 | 1417.60 ± 1.8% | not timed | not timed | 970.58 ± 0.7% | 385.23 ± 30.6% | not timed | not timed | 1433.73 ± 0.6% | | 0.99 | 1.46 | 3.68 |
| grep/long-words-ascii | 5073 | 504.95 ± 0.2% | not timed | not timed | 497.67 ± 0.2% | 51.62 ± 7.7% | not timed | not timed | 504.22 ± 0.3% | | 1.00 | 1.01 | 9.78 |
| imported/leipzig/twain | 811 | 56813.26 ± 3.8% | not timed | not timed | 43152.27 ± 10.7% | 13098.06 ± 8.8% | not timed | not timed | 57067.32 ± 15.1% | | 1.00 | 1.32 | 4.34 |
| imported/leipzig/twain-insensitive | 965 | 15517.33 ± 0.6% | not timed | not timed | 13465.29 ± 0.4% | 44.58 ± 0.7% | not timed | not timed | 15535.89 ± 0.5% | | 1.00 | 1.15 | 348.06 |
| imported/leipzig/shing | 1540 | 629.88 ± 0.2% | not timed | not timed | 22184.60 ± 1.6% | 38.32 ± 1.7% | not timed | not timed | 630.55 ± 0.2% | | 1.00 | 0.0284 | 16.44 |
| imported/leipzig/huck-saw | 262 | 24880.49 ± 0.4% | not timed | not timed | 18749.01 ± 0.4% | 35.91 ± 0.6% | not timed | not timed | 24971.17 ± 0.5% | | 1.00 | 1.33 | 692.91 |
| imported/leipzig/word-ending-nn | 262 | 609.80 ± 0.1% | not timed | not timed | 603.42 ± 0.2% | 27.18 ± 3.4% | not timed | not timed | 609.94 ± 0.2% | | 1.00 | 1.01 | 22.43 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11926.79 ± 0.5% | not timed | not timed | 3885.35 ± 0.6% | 12.17 ± 2.4% | not timed | not timed | 11875.43 ± 0.6% | | 1.00 | 3.07 | 979.91 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 21259.00 ± 1.5% | not timed | not timed | 17574.14 ± 0.5% | 19.34 ± 0.4% | not timed | not timed | 21255.05 ± 1.2% | | 1.00 | 1.21 | 1098.96 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5547.40 ± 0.4% | not timed | not timed | 791.96 ± 2.1% | 12.36 ± 2.7% | not timed | not timed | 5549.11 ± 0.6% | | 1.00 | 7.00 | 448.69 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 608.08 ± 0.3% | not timed | not timed | 602.11 ± 0.1% | 12.50 ± 1.3% | not timed | not timed | 608.20 ± 0.1% | | 1.00 | 1.01 | 48.63 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 608.02 ± 2.2% | not timed | not timed | 602.32 ± 2.2% | 10.81 ± 0.7% | not timed | not timed | 608.51 ± 0.7% | | 1.00 | 1.01 | 56.25 |
| imported/leipzig/tom-river | 2 | 12872.14 ± 0.5% | not timed | not timed | 13433.74 ± 0.4% | 34.91 ± 2.9% | not timed | not timed | 12869.38 ± 10.6% | | 1.00 | 0.96 | 368.73 |
| imported/leipzig/ing | 78424 | 599.53 ± 0.8% | not timed | not timed | 561.45 ± 0.4% | 30.76 ± 5.4% | not timed | not timed | 599.40 ± 0.6% | | 1.00 | 1.07 | 19.49 |
| imported/leipzig/ing-whitespace | 55248 | 735.97 ± 0.6% | not timed | not timed | 2139.96 ± 1.7% | 22.67 ± 2.6% | not timed | not timed | 741.15 ± 0.2% | | 0.99 | 0.34 | 32.46 |
| imported/leipzig/awyer-inn | 209 | 771.05 ± 1.7% | not timed | not timed | 13731.71 ± 0.7% | 25.09 ± 0.4% | not timed | not timed | 770.73 ± 1.3% | | 1.00 | 0.0562 | 30.73 |
| imported/leipzig/quotes-bounded | 8886 | 1847.53 ± 0.9% | not timed | not timed | 3292.56 ± 0.5% | 41.04 ± 0.4% | not timed | not timed | 1848.94 ± 0.3% | | 1.00 | 0.56 | 45.01 |
| imported/leipzig/non-ascii-alternate | 2 | 40574.13 ± 0.7% | not timed | not timed | 19627.39 ± 0.1% | 56.57 ± 1.9% | not timed | not timed | 40657.93 ± 0.5% | | 1.00 | 2.07 | 717.22 |
| imported/leipzig/math-symbols | 69 | 2430.37 ± 0.4% | not timed | not timed | 604.60 ± 0.3% | 38.94 ± 3.3% | not timed | not timed | 2432.13 ± 0.3% | | 1.00 | 4.02 | 62.41 |
| imported/leipzig/bounded-strings-ending-z | 0 | 610.21 ± 0.2% | not timed | not timed | 604.74 ± 0.1% | 25.88 ± 1.9% | not timed | not timed | 610.44 ± 0.1% | | 1.00 | 1.01 | 23.58 |
| imported/lh3lh3-reb/uri | 17549 | 726.14 ± 2.2% | not timed | not timed | 1123.70 ± 9.0% | 30.11 ± 2.7% | not timed | not timed | 728.42 ± 2.2% | | 1.00 | 0.65 | 24.12 |
| imported/lh3lh3-reb/email | 15057 | 800.99 ± 7.2% | not timed | not timed | 1125.77 ± 4.5% | 33.16 ± 4.1% | not timed | not timed | 801.08 ± 1.1% | | 1.00 | 0.71 | 24.15 |
| imported/lh3lh3-reb/date | 668 | 930.55 ± 0.8% | not timed | not timed | 1017.11 ± 1.0% | 54.07 ± 4.9% | not timed | not timed | 931.04 ± 8.3% | | 1.00 | 0.91 | 17.21 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 739.61 ± 2.1% | not timed | not timed | 443.73 ± 0.1% | 16.60 ± 1.9% | not timed | not timed | 745.76 ± 0.7% | | 0.99 | 1.67 | 44.55 |
| imported/mariomka/email | 92 | 704.08 ± 0.2% | not timed | not timed | 60012.68 ± 0.7% | 35.79 ± 7.4% | not timed | not timed | 703.61 ± 0.8% | | 1.00 | 0.0117 | 19.67 |
| imported/mariomka/uri | 5301 | 601.28 ± 0.4% | not timed | not timed | 7932.88 ± 2.4% | 35.89 ± 1.6% | not timed | not timed | 602.61 ± 0.3% | | 1.00 | 0.0758 | 16.76 |
| imported/mariomka/ip | 5 | 1811.22 ± 3.2% | not timed | not timed | 2334.31 ± 0.3% | 23.00 ± 0.5% | not timed | not timed | 1813.03 ± 2.5% | | 1.00 | 0.78 | 78.73 |
| imported/rsc/no-exponential | 0 | 827.95 ± 1.3% | not timed | not timed | 423.36 ± 19.0% | 25.96 ± 33.0% | not timed | not timed | 826.36 ± 21.5% | | 1.00 | 1.96 | 31.89 |
| imported/rsc/literal | 1 | 887.46 ± 2.2% | not timed | not timed | 2224.45 ± 1.7% | 232.06 ± 13.8% | not timed | not timed | 884.18 ± 15.3% | | 1.00 | 0.40 | 3.82 |
| imported/rsc/not-literal | 2 | 809.74 ± 1.6% | not timed | not timed | 839.64 ± 9.3% | 54.32 ± 9.3% | not timed | not timed | 811.40 ± 1.5% | | 1.00 | 0.96 | 14.91 |
| imported/rsc/match-class | 1 | 1434.07 ± 2.0% | not timed | not timed | 1822.61 ± 1.2% | 68.18 ± 7.7% | not timed | not timed | 1425.09 ± 1.8% | | 1.01 | 0.79 | 21.03 |
| imported/rsc/match-class-in-range | 1 | 1437.04 ± 8.7% | not timed | not timed | 3425.23 ± 7.6% | 69.79 ± 9.0% | not timed | not timed | 1439.07 ± 20.5% | | 1.00 | 0.42 | 20.59 |
| imported/rsc/match-class-unicode | 1 | 548.29 ± 0.5% | not timed | not timed | 521.78 ± 0.2% | 82.99 ± 0.9% | not timed | not timed | 549.63 ± 3.6% | | 1.00 | 1.05 | 6.61 |
| imported/rsc/anchored-literal-short-non-match | 0 | 636.82 ± 0.8% | not timed | not timed | 1148.14 ± 0.3% | 344.29 ± 1.3% | not timed | not timed | 636.33 ± 1.1% | | 1.00 | 0.55 | 1.85 |
| imported/rsc/anchored-literal-long-non-match | 0 | 10260.68 ± 1.4% | not timed | not timed | 17210.56 ± 0.9% | 5162.58 ± 1.1% | not timed | not timed | 10273.76 ± 0.6% | | 1.00 | 0.60 | 1.99 |
| imported/rsc/anchored-literal-short-match | 4 | 515.44 ± 1.8% | not timed | not timed | 570.21 ± 0.5% | 104.51 ± 6.3% | not timed | not timed | 515.31 ± 1.8% | | 1.00 | 0.90 | 4.93 |
| imported/rsc/anchored-literal-long-match | 4 | 2774.04 ± 1.3% | not timed | not timed | 8601.95 ± 0.9% | 1618.20 ± 1.8% | not timed | not timed | 2783.74 ± 1.5% | | 1.00 | 0.32 | 1.71 |
| imported/rsc/one-pass-short | 17 | 364.11 ± 2.9% | not timed | not timed | 261.33 ± 0.8% | 37.84 ± 17.4% | not timed | not timed | 364.45 ± 8.8% | | 1.00 | 1.39 | 9.62 |
| imported/rsc/one-pass-short-not | 17 | 246.47 ± 5.5% | not timed | not timed | 270.92 ± 0.5% | 34.59 ± 20.6% | not timed | not timed | 246.35 ± 1.4% | | 1.00 | 0.91 | 7.13 |
| imported/rsc/one-pass-long-prefix | 26 | 247.32 ± 7.4% | not timed | not timed | 322.99 ± 3.8% | 125.25 ± 41.2% | not timed | not timed | 179.59 ± 6.3% | | 1.38 | 0.77 | 1.97 |
| imported/rsc/one-pass-long-prefix-not | 26 | 375.05 ± 7.0% | not timed | not timed | 323.53 ± 2.4% | 90.70 ± 3.3% | not timed | not timed | 270.14 ± 11.4% | | 1.39 | 1.16 | 4.13 |
| imported/rsc/long-needle1 | 31 | 68336.94 ± 1.8% | not timed | not timed | 45844.00 ± 0.2% | 4.20 ± 2.7% | not timed | not timed | 68328.97 ± 0.7% | | 1.00 | 1.49 | 16258.23 |
| imported/rsc/long-needle2 | 31 | 67784.32 ± 0.3% | not timed | not timed | 227.53 ± 0.3% | 4.20 ± 0.1% | not timed | not timed | 67722.00 ± 0.5% | | 1.00 | 297.92 | 16134.81 |
| imported/rsc/easy0-32 | 26 | 1258.98 ± 15.1% | not timed | not timed | 1943.22 ± 8.9% | 163.81 ± 11.2% | not timed | not timed | 1270.42 ± 10.9% | | 0.99 | 0.65 | 7.69 |
| imported/rsc/easy0-1k | 26 | 21443.65 ± 1.6% | not timed | not timed | 20417.27 ± 0.2% | 2562.67 ± 12.4% | not timed | not timed | 21430.87 ± 2.3% | | 1.00 | 1.05 | 8.37 |
| imported/rsc/easy0-32k | 26 | 64505.81 ± 2.0% | not timed | not timed | 43670.22 ± 0.5% | 26542.20 ± 44.5% | not timed | not timed | 64824.96 ± 0.9% | | 1.00 | 1.48 | 2.43 |
| imported/rsc/easy0-1mb | 26 | 65526.81 ± 1.0% | not timed | not timed | 45925.76 ± 0.6% | 68212.19 ± 0.3% | not timed | not timed | 65431.76 ± 0.4% | | 1.00 | 1.43 | 0.96 |
| imported/rsc/easy1-32 | 19 | 386.41 ± 11.8% | not timed | not timed | 742.12 ± 0.6% | 151.30 ± 19.3% | not timed | not timed | 386.71 ± 1.1% | | 1.00 | 0.52 | 2.55 |
| imported/rsc/easy1-1k | 19 | 584.10 ± 1.9% | not timed | not timed | 15576.19 ± 0.2% | 2667.28 ± 12.0% | not timed | not timed | 592.77 ± 0.6% | | 0.99 | 0.0375 | 0.22 |
| imported/rsc/easy1-32k | 19 | 608.39 ± 2.0% | not timed | not timed | 489158.64 ± 2.9% | 29468.58 ± 12.9% | not timed | not timed | 608.27 ± 0.6% | | 1.00 | 0.0012 | 0.0206 |
| imported/rsc/easy1-1mb | 19 | 609.53 ± 0.1% | not timed | not timed | 15631997.89 ± 1.0% | 68316.13 ± 0.5% | not timed | not timed | 609.49 ± 0.2% | | 1.00 | 0.0000 | 0.0089 |
| imported/rsc/medium-32 | 27 | 476.26 ± 1.8% | not timed | not timed | 739.30 ± 0.4% | 83.17 ± 30.6% | not timed | not timed | 475.98 ± 10.8% | | 1.00 | 0.64 | 5.73 |
| imported/rsc/medium-1k | 27 | 7847.66 ± 10.1% | not timed | not timed | 13258.33 ± 0.5% | 82.68 ± 8.2% | not timed | not timed | 7827.57 ± 1.8% | | 1.00 | 0.59 | 94.91 |
| imported/rsc/medium-32k | 27 | 53116.06 ± 1.2% | not timed | not timed | 413504.73 ± 10.5% | 53.41 ± 1.1% | not timed | not timed | 46215.74 ± 0.3% | | 1.15 | 0.13 | 994.45 |
| imported/rsc/medium-1mb | 27 | 64618.67 ± 0.9% | not timed | not timed | 13131260.52 ± 0.3% | 54.18 ± 0.4% | not timed | not timed | 64491.60 ± 0.1% | | 1.00 | 0.0049 | 1192.57 |
| imported/rsc/hard-32 | 58 | 270.26 ± 2.4% | not timed | not timed | 393.48 ± 0.3% | 53.30 ± 6.5% | not timed | not timed | 271.03 ± 0.3% | | 1.00 | 0.69 | 5.07 |
| imported/rsc/hard-1k | 27 | 588.91 ± 0.3% | not timed | not timed | 13109.36 ± 1.0% | 44.90 ± 0.5% | not timed | not timed | 589.34 ± 0.6% | | 1.00 | 0.0449 | 13.12 |
| imported/rsc/hard-32k | 27 | 608.88 ± 0.2% | not timed | not timed | 409807.26 ± 0.4% | 33.05 ± 0.2% | not timed | not timed | 607.09 ± 0.8% | | 1.00 | 0.0015 | 18.42 |
| imported/rsc/hard-1mb | 51 | 609.32 ± 0.2% | not timed | not timed | 7752512.45 ± 1.5% | 33.18 ± 16.4% | not timed | not timed | 609.53 ± 0.2% | | 1.00 | 0.0001 | 18.37 |
| imported/rsc/reallyhard0-32 | 58 | 267.45 ± 2.2% | not timed | not timed | 245.81 ± 11.7% | 51.18 ± 22.3% | not timed | not timed | 269.45 ± 0.1% | | 0.99 | 1.09 | 5.23 |
| imported/rsc/reallyhard0-1k | 27 | 586.63 ± 0.8% | not timed | not timed | 580.14 ± 0.4% | 45.04 ± 0.4% | not timed | not timed | 589.20 ± 0.2% | | 1.00 | 1.01 | 13.02 |
| imported/rsc/reallyhard0-32k | 27 | 608.43 ± 0.2% | not timed | not timed | 603.00 ± 3.6% | 32.84 ± 18.4% | not timed | not timed | 608.20 ± 0.3% | | 1.00 | 1.01 | 18.53 |
| imported/rsc/reallyhard0-1mb | 51 | 609.31 ± 2.1% | not timed | not timed | 603.79 ± 0.1% | 33.18 ± 1.9% | not timed | not timed | 609.81 ± 0.2% | | 1.00 | 1.01 | 18.37 |
| imported/rsc/reallyreallyhard0-32 | 47 | 309.58 ± 1.4% | not timed | not timed | 209.90 ± 0.1% | 64.35 ± 18.8% | not timed | not timed | 310.05 ± 3.7% | | 1.00 | 1.47 | 4.81 |
| imported/rsc/reallyreallyhard0-1k | 16 | 871.96 ± 1.5% | not timed | not timed | 7697.72 ± 1.1% | 36.86 ± 15.0% | not timed | not timed | 872.39 ± 1.0% | | 1.00 | 0.11 | 23.66 |
| imported/rsc/reallyreallyhard0-32k | 16 | 636.85 ± 4.7% | not timed | not timed | 36639.90 ± 0.6% | 26.83 ± 0.6% | not timed | not timed | 635.50 ± 6.9% | | 1.00 | 0.0174 | 23.74 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 609.24 ± 12.7% | not timed | not timed | 45366.59 ± 0.2% | 27.19 ± 0.3% | not timed | not timed | 609.56 ± 1.9% | | 1.00 | 0.0134 | 22.40 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 304.84 ± 25.0% | not timed | not timed | 216.32 ± 1.4% | 66.03 ± 9.2% | not timed | not timed | 305.19 ± 0.3% | | 1.00 | 1.41 | 4.62 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 850.12 ± 2.7% | not timed | not timed | 7548.68 ± 0.4% | 36.42 ± 19.8% | not timed | not timed | 849.88 ± 0.8% | | 1.00 | 0.11 | 23.34 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 636.64 ± 4.8% | not timed | not timed | 37119.46 ± 0.3% | 27.11 ± 0.2% | not timed | not timed | 636.83 ± 4.8% | | 1.00 | 0.0172 | 23.48 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 609.79 ± 0.2% | not timed | not timed | 45615.07 ± 30.3% | 27.15 ± 11.8% | not timed | not timed | 609.98 ± 0.7% | | 1.00 | 0.0134 | 22.46 |
| imported/sherlock/name-sherlock | 776 | 50717.25 ± 1.3% | not timed | not timed | 39779.88 ± 1.5% | 11836.10 ± 32.1% | not timed | not timed | 50622.78 ± 1.4% | | 1.00 | 1.27 | 4.28 |
| imported/sherlock/name-holmes | 2766 | 27742.48 ± 1.1% | not timed | not timed | 29564.98 ± 1.5% | 4183.66 ± 1.1% | not timed | not timed | 27976.83 ± 1.2% | | 0.99 | 0.94 | 6.63 |
| imported/sherlock/name-sherlock-holmes | 1365 | 51175.15 ± 8.5% | not timed | not timed | 40079.72 ± 16.4% | 10165.39 ± 31.6% | not timed | not timed | 51114.98 ± 1.5% | | 1.00 | 1.28 | 5.03 |
| imported/sherlock/name-sherlock-casei | 816 | 46264.64 ± 2.0% | not timed | not timed | 11564.57 ± 0.2% | 34.05 ± 3.2% | not timed | not timed | 46228.00 ± 0.8% | | 1.00 | 4.00 | 1358.72 |
| imported/sherlock/name-holmes-casei | 2802 | 22583.99 ± 0.3% | not timed | not timed | 7655.22 ± 0.7% | 44.48 ± 4.0% | not timed | not timed | 22607.24 ± 0.3% | | 1.00 | 2.95 | 507.69 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 36497.03 ± 1.5% | not timed | not timed | 11181.28 ± 0.1% | 33.73 ± 1.5% | not timed | not timed | 36462.80 ± 0.5% | | 1.00 | 3.26 | 1082.08 |
| imported/sherlock/name-whitespace | 1461 | 28048.77 ± 1.6% | not timed | not timed | 27856.30 ± 14.1% | 8404.78 ± 31.7% | not timed | not timed | 28133.52 ± 1.4% | | 1.00 | 1.01 | 3.34 |
| imported/sherlock/name-alt1 | 1142 | 28379.68 ± 0.4% | not timed | not timed | 29228.59 ± 22.5% | 5681.93 ± 37.4% | not timed | not timed | 28372.86 ± 1.2% | | 1.00 | 0.97 | 4.99 |
| imported/sherlock/name-alt2 | 3542 | 17000.52 ± 1.3% | not timed | not timed | 10076.39 ± 13.1% | 35.83 ± 13.0% | not timed | not timed | 17012.77 ± 15.7% | | 1.00 | 1.69 | 474.54 |
| imported/sherlock/name-alt3 | 4507 | 11343.87 ± 0.5% | not timed | not timed | 9208.61 ± 7.0% | 11.29 ± 0.6% | not timed | not timed | 11331.86 ± 0.2% | | 1.00 | 1.23 | 1004.98 |
| imported/sherlock/name-alt3-casei | 4593 | 3445.95 ± 4.7% | not timed | not timed | 1308.48 ± 5.2% | 7.52 ± 6.9% | not timed | not timed | 3454.69 ± 4.1% | | 1.00 | 2.63 | 458.54 |
| imported/sherlock/name-alt4 | 3686 | 9202.64 ± 0.3% | not timed | not timed | 8150.21 ± 0.8% | 30.09 ± 2.5% | not timed | not timed | 9179.90 ± 1.4% | | 1.00 | 1.13 | 305.88 |
| imported/sherlock/name-alt4-casei | 4254 | 5160.48 ± 1.2% | not timed | not timed | 4487.39 ± 3.3% | 20.59 ± 1.8% | not timed | not timed | 5156.02 ± 1.1% | | 1.00 | 1.15 | 250.59 |
| imported/sherlock/name-alt5 | 4028 | 14235.77 ± 0.6% | not timed | not timed | 9689.84 ± 0.6% | 24.78 ± 0.6% | not timed | not timed | 14199.50 ± 0.4% | | 1.00 | 1.47 | 574.41 |
| imported/sherlock/name-alt5-casei | 4104 | 6644.87 ± 0.4% | not timed | not timed | 2958.55 ± 2.2% | 15.50 ± 33.6% | not timed | not timed | 6636.37 ± 0.6% | | 1.00 | 2.25 | 428.75 |
| imported/sherlock/no-match-uncommon | 0 | 67865.74 ± 0.2% | not timed | not timed | 57197.16 ± 2.2% | 57113.63 ± 0.7% | not timed | not timed | 68030.19 ± 0.4% | | 1.00 | 1.19 | 1.19 |
| imported/sherlock/no-match-common | 0 | 66576.86 ± 0.9% | not timed | not timed | 57260.28 ± 2.3% | 2138.74 ± 0.2% | not timed | not timed | 66510.90 ± 0.2% | | 1.00 | 1.16 | 31.13 |
| imported/sherlock/no-match-really-common | 0 | 42642.73 ± 0.5% | not timed | not timed | 49214.91 ± 0.6% | 2143.97 ± 0.4% | not timed | not timed | 42755.30 ± 10.8% | | 1.00 | 0.87 | 19.89 |
| imported/sherlock/the-lower | 21654 | 4001.23 ± 3.8% | not timed | not timed | 4521.35 ± 0.8% | 295.90 ± 22.7% | not timed | not timed | 3998.91 ± 7.0% | | 1.00 | 0.88 | 13.52 |
| imported/sherlock/the-upper | 2223 | 20854.72 ± 1.2% | not timed | not timed | 28702.23 ± 1.8% | 3084.80 ± 41.6% | not timed | not timed | 20904.18 ± 1.5% | | 1.00 | 0.73 | 6.76 |
| imported/sherlock/the-casei | 23961 | 3519.45 ± 0.4% | not timed | not timed | 1367.23 ± 0.9% | 41.23 ± 42.9% | not timed | not timed | 3517.59 ± 0.9% | | 1.00 | 2.57 | 85.36 |
| imported/sherlock/everything-greedy | 581881 | 268.49 ± 8.5% | not timed | not timed | 172.52 ± 0.8% | 30.82 ± 31.2% | not timed | not timed | 275.20 ± 0.2% | | 0.98 | 1.56 | 8.71 |
| imported/sherlock/everything-greedy-nl | 594933 | 465.25 ± 0.2% | not timed | not timed | 223.96 ± 0.7% | 34.73 ± 0.2% | not timed | not timed | 464.90 ± 0.2% | | 1.00 | 2.08 | 13.40 |
| imported/sherlock/letters | 447175 | 56.39 ± 8.0% | not timed | not timed | 33.79 ± 0.5% | 6.67 ± 31.0% | not timed | not timed | 56.14 ± 1.4% | | 1.00 | 1.67 | 8.46 |
| imported/sherlock/letters-upper | 14180 | 431.28 ± 0.6% | not timed | not timed | 363.64 ± 0.1% | 31.15 ± 21.5% | not timed | not timed | 430.67 ± 0.6% | | 1.00 | 1.19 | 13.85 |
| imported/sherlock/letters-lower | 432995 | 57.49 ± 1.3% | not timed | not timed | 34.87 ± 0.3% | 6.57 ± 36.1% | not timed | not timed | 57.63 ± 0.6% | | 1.00 | 1.65 | 8.75 |
| imported/sherlock/words | 447639 | 106.75 ± 1.9% | not timed | not timed | 83.71 ± 0.7% | 16.90 ± 13.1% | not timed | not timed | 106.53 ± 0.9% | | 1.00 | 1.28 | 6.32 |
| imported/sherlock/before-holmes | 4073 | 602.49 ± 0.4% | not timed | not timed | 13190.88 ± 0.3% | 25.77 ± 8.3% | not timed | not timed | 602.80 ± 0.6% | | 1.00 | 0.0457 | 23.38 |
| imported/sherlock/before-after-holmes | 2593 | 604.84 ± 0.1% | not timed | not timed | 14928.33 ± 24.4% | 25.89 ± 0.2% | not timed | not timed | 604.74 ± 0.2% | | 1.00 | 0.0405 | 23.36 |
| imported/sherlock/holmes-cochar-watson | 150 | 9987.17 ± 12.6% | not timed | not timed | 7712.26 ± 0.2% | 35.17 ± 3.7% | not timed | not timed | 10028.98 ± 0.3% | | 1.00 | 1.29 | 283.98 |
| imported/sherlock/holmes-coword-watson | 14309 | 1269.75 ± 0.2% | not timed | not timed | 1234.44 ± 0.1% | 7.63 ± 1.2% | not timed | not timed | 1272.69 ± 0.2% | | 1.00 | 1.03 | 166.50 |
| imported/sherlock/quotes | 14437 | 1339.52 ± 1.0% | not timed | not timed | 2253.37 ± 1.3% | 37.76 ± 0.9% | not timed | not timed | 1338.36 ± 2.0% | | 1.00 | 0.59 | 35.47 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 607.76 ± 0.1% | not timed | not timed | 31225.34 ± 0.4% | 40.11 ± 32.6% | not timed | not timed | 608.25 ± 0.1% | | 1.00 | 0.0195 | 15.15 |
| imported/sherlock/word-ending-n | 35297 | 458.75 ± 0.7% | not timed | not timed | 399.19 ± 2.7% | 26.06 ± 26.1% | not timed | not timed | 459.48 ± 0.4% | | 1.00 | 1.15 | 17.60 |
| imported/sherlock/repeated-class-negation | 2130 | 18591.10 ± 1.2% | not timed | not timed | 16492.23 ± 2.6% | 12.44 ± 11.0% | not timed | not timed | 18589.37 ± 0.5% | | 1.00 | 1.13 | 1494.67 |
| imported/sherlock/ing-suffix | 20547 | 560.52 ± 0.9% | not timed | not timed | 498.57 ± 0.2% | 30.98 ± 2.7% | not timed | not timed | 560.25 ± 2.6% | | 1.00 | 1.12 | 18.09 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 587.94 ± 2.5% | not timed | not timed | 2883.50 ± 2.0% | 22.75 ± 15.8% | not timed | not timed | 592.14 ± 6.4% | | 0.99 | 0.20 | 25.84 |
| opt/accelerate/whole-line | 239963 | 504.72 ± 0.6% | not timed | not timed | 414.46 ± 0.2% | 91.97 ± 17.6% | not timed | not timed | 504.78 ± 0.3% | | 1.00 | 1.22 | 5.49 |
| opt/accelerate/non-dna | 16745 | 423.35 ± 1.2% | not timed | not timed | 437.99 ± 0.2% | 33.13 ± 22.1% | not timed | not timed | 424.17 ± 0.1% | | 1.00 | 0.97 | 12.78 |
| opt/backtrack/words-english | 40536 | 142.76 ± 4.9% | not timed | not timed | 110.81 ± 0.5% | 22.10 ± 11.5% | not timed | not timed | 143.27 ± 4.6% | | 1.00 | 1.29 | 6.46 |
| opt/fixed-length/too-small-ascii | 0 | 391.21 ± 16.5% | not timed | not timed | 709.79 ± 0.2% | 123.67 ± 3.3% | not timed | not timed | 391.42 ± 0.5% | | 1.00 | 0.55 | 3.16 |
| opt/fixed-length/too-big-ascii | 0 | 819.47 ± 0.3% | not timed | not timed | 6249.87 ± 1.8% | 143.93 ± 0.7% | not timed | not timed | 821.10 ± 0.4% | | 1.00 | 0.13 | 5.69 |
| opt/fixed-length/go33484-1 | 0 | 65.36 ± 0.1% | not timed | not timed | 1216161.46 ± 0.9% | 89828.63 ± 1.1% | not timed | not timed | 65.34 ± 0.5% | | 1.00 | 0.0001 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 4241.18 ± 0.2% | not timed | not timed | 1216413.32 ± 0.4% | 30226.01 ± 1.6% | not timed | not timed | 4240.31 ± 1.4% | | 1.00 | 0.0035 | 0.14 |
| opt/fixed-length/go33484-3 | 0 | 1654.65 ± 0.4% | not timed | not timed | 120950.46 ± 0.3% | 893.42 ± 0.4% | not timed | not timed | 1648.72 ± 0.4% | | 1.00 | 0.0137 | 1.85 |
| opt/literal-alt/one-pattern | 1 | 582.37 ± 0.1% | not timed | not timed | 570.82 ± 0.6% | 0.39 ± 5.5% | not timed | not timed | 566.57 ± 0.3% | | 1.03 | 1.02 | 1508.06 |
| opt/onepass/fn-predicate | 916 | 432.71 ± 1.1% | not timed | not timed | 399.51 ± 0.2% | 210.18 ± 13.6% | not timed | not timed | 432.26 ± 1.4% | | 1.00 | 1.08 | 2.06 |
| opt/onepass/first-three-words-english | 35128 | 155.39 ± 3.4% | not timed | not timed | 232.51 ± 1.4% | 85.64 ± 18.9% | not timed | not timed | 156.36 ± 2.0% | | 0.99 | 0.67 | 1.81 |
| opt/prefilter/literal-english | 1 | 67636.17 ± 0.5% | not timed | not timed | 46317.83 ± 32.3% | 26609.10 ± 0.6% | not timed | not timed | 67402.04 ± 5.6% | | 1.00 | 1.46 | 2.54 |
| opt/prefilter/literal-casei-english | 1 | 47196.32 ± 1.0% | not timed | not timed | 14185.36 ± 0.7% | 33.93 ± 1.2% | not timed | not timed | 47056.45 ± 0.6% | | 1.00 | 3.33 | 1390.88 |
| opt/prefilter/literal-russian | 1 | 69065.52 ± 0.4% | not timed | not timed | 46368.80 ± 6.2% | 1802.93 ± 5.1% | not timed | not timed | 68921.27 ± 5.6% | | 1.00 | 1.49 | 38.31 |
| opt/prefilter/literal-casei-russian | 1 | 26186.23 ± 0.4% | not timed | not timed | 10949.33 ± 0.8% | 37.86 ± 3.1% | not timed | not timed | 26193.57 ± 1.0% | | 1.00 | 2.39 | 691.69 |
| opt/prefilter/rust-functions | 948 | 14779.95 ± 18.7% | not timed | not timed | 12889.01 ± 0.4% | 1958.90 ± 0.2% | not timed | not timed | 14803.01 ± 0.9% | | 1.00 | 1.15 | 7.55 |
| opt/reverse-anchored/word-end | 1 | 4277.22 ± 0.4% | not timed | not timed | 27152200.49 ± 13.2% | 55.78 ± 1.9% | not timed | not timed | 4290.25 ± 2.6% | | 1.00 | 0.0002 | 76.68 |
| opt/reverse-inner/holmes | 2593 | 604.49 ± 0.3% | not timed | not timed | 14914.87 ± 0.2% | 25.64 ± 0.5% | not timed | not timed | 604.73 ± 0.3% | | 1.00 | 0.0405 | 23.57 |
| opt/reverse-inner/email | 47 | 1038.99 ± 0.2% | not timed | not timed | 92186.36 ± 1.4% | 34.83 ± 1.4% | not timed | not timed | 1039.13 ± 0.1% | | 1.00 | 0.0113 | 29.83 |
| opt/reverse-inner/factored-prefix | 3542 | 596.47 ± 1.1% | not timed | not timed | 586.14 ± 0.6% | 13.93 ± 10.9% | not timed | not timed | 596.46 ± 0.1% | | 1.00 | 1.02 | 42.81 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4168.82 ± 0.1% | not timed | not timed | 602.20 ± 0.8% | 86.21 ± 2.0% | not timed | not timed | 4176.99 ± 0.2% | | 1.00 | 6.92 | 48.36 |
| opt/reverse-inner/no-quadratic-forward | 0 | 708.10 ± 1.6% | not timed | not timed | 278.64 ± 0.6% | 25.80 ± 0.2% | not timed | not timed | 708.99 ± 13.2% | | 1.00 | 2.54 | 27.44 |
| opt/reverse-suffix/holmes | 4073 | 602.50 ± 0.1% | not timed | not timed | 13199.08 ± 0.8% | 25.59 ± 0.3% | not timed | not timed | 603.08 ± 0.1% | | 1.00 | 0.0456 | 23.55 |
| opt/reverse-suffix/no-quadratic | 0 | 4167.69 ± 0.2% | not timed | not timed | 604.13 ± 0.1% | 86.15 ± 0.2% | not timed | not timed | 4174.97 ± 0.5% | | 1.00 | 6.90 | 48.38 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 142.48 ± 7.7% | not timed | not timed | 180.97 ± 0.3% | 16.38 ± 16.7% | not timed | not timed | 141.65 ± 21.4% | | 1.01 | 0.79 | 8.70 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 142.67 ± 1.9% | not timed | not timed | 182.88 ± 22.8% | 16.53 ± 15.4% | not timed | not timed | 142.95 ± 2.4% | | 1.00 | 0.78 | 8.63 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.30 ± 2.8% | not timed | not timed | 0.48 ± 0.7% | 120.38 ± 7.5% | not timed | not timed | 0.31 ± 5.0% | | 0.97 | 0.63 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 292.68 ± 0.2% | not timed | not timed | 263.61 ± 0.1% | 109.12 ± 1.3% | not timed | not timed | 293.74 ± 0.4% | | 1.00 | 1.11 | 2.68 |
| reported/i13-subset-regex/original-ascii | 4094 | 11901.89 ± 0.6% | not timed | not timed | 3974.05 ± 1.6% | 12.13 ± 1.2% | not timed | not timed | 11933.87 ± 0.8% | | 1.00 | 2.99 | 981.42 |
| reported/i13-subset-regex/original-unicode | 4094 | 11866.90 ± 3.7% | not timed | not timed | 210.75 ± 1.3% | 12.22 ± 1.3% | not timed | not timed | 11892.42 ± 0.5% | | 1.00 | 56.31 | 970.71 |
| reported/i13-subset-regex/big-ascii | 1955 | 11202.85 ± 0.4% | not timed | not timed | 54.35 ± 2.0% | 10.50 ± 1.5% | not timed | not timed | 11195.80 ± 0.4% | | 1.00 | 206.12 | 1067.04 |
| reported/i13-subset-regex/big-unicode | 1955 | 11134.66 ± 0.6% | not timed | not timed | 9.49 ± 55.3% | 10.48 ± 1.1% | not timed | not timed | 11164.26 ± 2.6% | | 1.00 | 1173.47 | 1062.38 |
| reported/i13-subset-regex/huge-ascii | 55 | 10309.29 ± 0.6% | not timed | not timed | 8.99 ± 0.6% | 9.57 ± 0.5% | not timed | not timed | 10298.85 ± 0.8% | | 1.00 | 1146.81 | 1077.60 |
| reported/i13-subset-regex/huge-unicode | 55 | 10159.64 ± 0.7% | not timed | not timed | 8.69 ± 0.6% | 9.53 ± 1.1% | not timed | not timed | 10172.17 ± 1.1% | | 1.00 | 1168.89 | 1065.95 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.15 ± 1.3% | not timed | not timed | 8.98 ± 0.5% | 9.51 ± 3.2% | not timed | not timed | 4.16 ± 1.7% | | 1.00 | 0.46 | 0.44 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.77 ± 0.8% | not timed | not timed | 8.78 ± 0.6% | 9.57 ± 1.2% | not timed | not timed | 5.61 ± 1.3% | | 1.03 | 0.66 | 0.60 |
| reported/i787-keywords/ascii | 5674 | 487.40 ± 0.8% | not timed | not timed | 170.36 ± 0.5% | 7.28 ± 0.3% | not timed | not timed | 498.89 ± 1.1% | | 0.98 | 2.86 | 66.92 |
| reported/i787-keywords/opt-ascii | 5674 | 491.81 ± 1.1% | not timed | not timed | 271.54 ± 0.8% | 12.21 ± 1.3% | not timed | not timed | 499.05 ± 0.4% | | 0.99 | 1.81 | 40.28 |
| slow/quadratic-regex-1x | 100 | 8.23 ± 0.1% | not timed | not timed | 6.01 ± 0.2% | 0.05 ± 0.6% | not timed | not timed | 8.24 ± 0.3% | | 1.00 | 1.37 | 158.51 |
| slow/quadratic-regex-2x | 199 | 3.70 ± 1.3% | not timed | not timed | 3.05 ± 0.5% | 0.01 ± 0.4% | not timed | not timed | 3.10 ± 1.3% | | 1.19 | 1.21 | 275.22 |
| slow/quadratic-haystack-1x | 100 | 25.84 ± 29.7% | not timed | not timed | 12.18 ± 0.3% | 1.04 ± 7.8% | not timed | not timed | 26.22 ± 1.5% | | 0.99 | 2.12 | 24.73 |
| slow/quadratic-haystack-2x | 200 | 19.81 ± 1.2% | not timed | not timed | 6.13 ± 0.3% | 0.55 ± 5.7% | not timed | not timed | 19.92 ± 3.1% | | 0.99 | 3.23 | 35.74 |
| unicode/codepoints/any-one | 1112064 | 338.10 ± 1.5% | not timed | not timed | 228.43 ± 0.3% | 22.21 ± 17.9% | not timed | not timed | 338.31 ± 1.3% | | 1.00 | 1.48 | 15.22 |
| unicode/codepoints/any-all | 4382592 | 265.16 ± 2.5% | not timed | not timed | 260.62 ± 7.5% | 125.52 ± 1.9% | not timed | not timed | 266.13 ± 0.9% | | 1.00 | 1.02 | 2.11 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.93 ± 1.9% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 609.59 ± 0.4% | not timed | not timed | 602.80 ± 0.9% | 153.73 ± 0.4% | not timed | not timed | 610.84 ± 0.2% | | 1.00 | 1.01 | 3.97 |
| unicode/overlapping-words/ascii | 6156 | 27.91 ± 5.0% | not timed | not timed | 42.50 ± 0.7% | 4.29 ± 4.7% | not timed | not timed | 28.08 ± 5.5% | | 0.99 | 0.66 | 6.50 |
| unicode/overlapping-words/english | 6156 | 1.49 ± 4.5% | not timed | not timed | 3.11 ± 0.2% | 2.94 ± 0.6% | not timed | not timed | 1.48 ± 0.5% | | 1.00 | 0.48 | 0.51 |
| unicode/overlapping-words/russian | 5710 | 1.31 ± 8.8% | not timed | not timed | 3.00 ± 0.3% | 7.27 ± 12.4% | not timed | not timed | 1.32 ± 0.4% | | 1.00 | 0.44 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 114.74 ± 0.8% | not timed | not timed | 84.40 ± 0.3% | 14.08 ± 20.0% | not timed | not timed | 114.58 ± 2.1% | | 1.00 | 1.36 | 8.15 |
| unicode/word/boundary-long-english | 3466 | 609.92 ± 0.0% | not timed | not timed | 594.09 ± 0.0% | 35.41 ± 0.8% | not timed | not timed | 610.79 ± 0.8% | | 1.00 | 1.03 | 17.22 |
| unicode/word/around-holmes-english | 27 | 609.38 ± 0.1% | not timed | not timed | 45003.65 ± 1.8% | 23.88 ± 1.1% | not timed | not timed | 609.28 ± 0.1% | | 1.00 | 0.0135 | 25.52 |
| wild/bibleref/long | 874 | 569.52 ± 2.9% | not timed | not timed | 571.02 ± 1.4% | 7.81 ± 13.0% | not timed | not timed | 570.94 ± 1.0% | | 1.00 | 1.00 | 72.96 |
| wild/bibleref/short | 30 | 22.12 ± 8.6% | not timed | not timed | 32.84 ± 0.2% | 15.08 ± 20.5% | not timed | not timed | 23.35 ± 3.0% | | 0.95 | 0.67 | 1.47 |
| wild/bibleref/line | 874 | 485.56 ± 0.6% | not timed | not timed | 274.90 ± 0.7% | 9.41 ± 1.1% | not timed | not timed | 485.13 ± 6.8% | | 1.00 | 1.77 | 51.60 |
| wild/caddy/caddy | 6 | 452.38 ± 3.0% | not timed | not timed | 293.15 ± 0.7% | 72.98 ± 14.6% | not timed | not timed | 456.93 ± 2.5% | | 0.99 | 1.54 | 6.20 |
| wild/dot-star-capture/rust-src-tools | 6 | 1457.02 ± 0.3% | not timed | not timed | 404.23 ± 0.5% | 15.21 ± 1.7% | not timed | not timed | 1454.03 ± 1.0% | | 1.00 | 3.60 | 95.79 |
| wild/ruff/noqa | 84 | 490.30 ± 0.2% | not timed | not timed | 515.85 ± 1.1% | 21.53 ± 2.6% | not timed | not timed | 490.72 ± 0.2% | | 1.00 | 0.95 | 22.78 |
| wild/ruff/unnecessary-coding-comment | 16 | 534.82 ± 0.6% | not timed | not timed | 722.51 ± 0.7% | 141.45 ± 13.8% | not timed | not timed | 535.44 ± 0.7% | | 1.00 | 0.74 | 3.78 |
| wild/ruff/string-quote-prefix | 2972 | 493.63 ± 0.7% | not timed | not timed | 487.43 ± 0.2% | 322.27 ± 29.5% | not timed | not timed | 487.97 ± 0.6% | | 1.01 | 1.01 | 1.53 |
| wild/ruff/space-around-operator | 1224378 | 236.88 ± 1.5% | not timed | not timed | 225.60 ± 0.6% | 17.05 ± 2.4% | not timed | not timed | 236.60 ± 1.5% | | 1.00 | 1.05 | 13.90 |
| wild/ruff/shebang | 282 | 470.85 ± 0.7% | not timed | not timed | 394.19 ± 0.3% | 114.63 ± 13.2% | not timed | not timed | 487.86 ± 0.5% | | 0.97 | 1.19 | 4.11 |
| wild/rustsec-cargo-audit/original-unix | 471 | 21712.60 ± 0.8% | not timed | not timed | 23729.91 ± 1.7% | 8957.04 ± 1.6% | not timed | not timed | 21575.06 ± 1.9% | | 1.01 | 0.91 | 2.42 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20111.38 ± 2.2% | not timed | not timed | 22473.82 ± 0.3% | 8423.68 ± 1.2% | not timed | not timed | 19355.96 ± 0.8% | | 1.04 | 0.89 | 2.39 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 23024.22 ± 2.1% | not timed | not timed | 23334.49 ± 0.8% | 8672.52 ± 1.1% | not timed | not timed | 22040.19 ± 1.9% | | 1.04 | 0.99 | 2.65 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 17695.52 ± 4.1% | not timed | not timed | 23297.10 ± 1.7% | 8623.71 ± 22.9% | not timed | not timed | 17839.83 ± 0.3% | | 0.99 | 0.76 | 2.05 |
| wild/url/search | 234965 | 127.09 ± 13.5% | not timed | not timed | 61.56 ± 7.1% | 2.45 ± 2.3% | not timed | not timed | 126.45 ± 29.7% | | 1.01 | 2.06 | 51.88 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.9% | not timed | not timed | 0.01 ± 1.8% | 0.01 ± 18.7% | not timed | not timed | 0.03 ± 63.9% | | 1.00 | 2.51 | 3.74 |
| dictionary/compile/english-15 | 1 | 0.34 ± 2.0% | not timed | not timed | 0.10 ± 0.5% | 0.11 ± 7.9% | not timed | not timed | 0.35 ± 2.1% | | 1.00 | 3.59 | 3.03 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.29 ± 2.4% | not timed | not timed | 0.02 ± 1.0% | 36.01 ± 14.2% | not timed | not timed | 0.30 ± 1.9% | | 0.99 | 11.95 | 0.0082 |
| reported/i1095-word-repetition/ascii-compile | 1 | 42.22 ± 10.1% | not timed | not timed | 17.00 ± 0.5% | 59.80 ± 22.2% | not timed | not timed | 44.01 ± 3.5% | | 0.96 | 2.48 | 0.71 |
| reported/i787-keywords/compile | 1 | 40.46 ± 3.5% | not timed | not timed | 2.41 ± 0.6% | 21.13 ± 28.7% | not timed | not timed | 40.58 ± 3.6% | | 1.00 | 16.80 | 1.91 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 379.69 ± 2.7% | not timed | not timed | 151.09 ± 1.8% | 651.78 ± 24.0% | not timed | not timed | 382.14 ± 7.4% | | 0.99 | 2.51 | 0.58 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 53.50 ± 3.1% | not timed | not timed | 5.60 ± 2.8% | 48.55 ± 5.4% | not timed | not timed | 54.84 ± 10.2% | | 0.98 | 9.55 | 1.10 |
| unicode/compile/one-letter | 53 | 7.01 ± 13.4% | not timed | not timed | 5.83 ± 0.8% | 65.91 ± 4.3% | not timed | not timed | 7.08 ± 13.4% | | 0.99 | 1.20 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.23 ± 4.2% | not timed | not timed | 0.12 ± 3.0% | 64.76 ± 19.8% | not timed | not timed | 1.21 ± 17.8% | | 1.02 | 9.87 | 0.0191 |
| unicode/compile/fifty-letters-ascii | 1 | 190.27 ± 10.0% | not timed | not timed | 68.39 ± 0.3% | 219.94 ± 10.2% | not timed | not timed | 203.65 ± 9.0% | | 0.93 | 2.78 | 0.87 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 448.84 ± 4.0% | not timed | not timed | 51.12 ± 0.3% | 745.02 ± 9.6% | not timed | not timed | 444.82 ± 7.9% | | 1.01 | 8.78 | 0.60 |
| unicode/compile/match-every-line-ascii | 4 | 701.02 ± 14.0% | not timed | not timed | 165.54 ± 8.0% | 764.22 ± 5.0% | not timed | not timed | 711.76 ± 9.8% | | 0.98 | 4.23 | 0.92 |
| unicode/compile/negated-class-matches-codepoint | 1 | 369.28 ± 3.2% | not timed | not timed | 56.33 ± 0.7% | 1408.62 ± 8.7% | not timed | not timed | 366.78 ± 5.1% | | 1.01 | 6.56 | 0.26 |
| wild/bibleref/compile | 3 | 6.14 ± 7.2% | not timed | not timed | 2.44 ± 0.6% | 35.39 ± 11.6% | not timed | not timed | 6.32 ± 8.3% | | 0.97 | 2.51 | 0.17 |
| wild/url/compile | 1 | 0.72 ± 17.5% | not timed | not timed | 0.21 ± 0.6% | 0.51 ± 21.5% | not timed | not timed | 0.72 ± 18.7% | | 1.00 | 3.53 | 1.42 |

