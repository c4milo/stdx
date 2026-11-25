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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45506988364 |
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
| literal: a word | 217 | 48130.62 ± 1.3% | 3996.61 ± 0.3% | 31.26 ± 0.4% | 38542.20 ± 2.5% | 12129.20 ± 3.1% | 12.72 ± 0.1% | 103.22 ± 0.8% | 48089.31 ± 0.3% | 12.04 | 1.00 | 1.25 | 3.97 |
| literal: a word that is not there | 0 | 62591.09 ± 4.8% | 3889.51 ± 0.7% | 31.26 ± 0.5% | 45941.14 ± 14.8% | 43903.85 ± 2.7% | 12.62 ± 1.4% | 96.33 ± 6.3% | 62609.96 ± 5.9% | 16.09 | 1.00 | 1.36 | 1.43 |
| literal: one of four words | 661 | 16903.23 ± 0.5% | 1683.64 ± 0.3% | 16.94 ± 0.5% | 11167.61 ± 0.2% | 24.92 ± 0.8% | 4.48 ± 0.1% | 8.65 ± 0.6% | 16916.78 ± 0.7% | 10.04 | 1.00 | 1.51 | 678.42 |
| literal: a word in any case | 217 | 42525.58 ± 0.1% | 1807.85 ± 0.4% | 24.10 ± 0.3% | 11393.34 ± 0.2% | 47.21 ± 1.7% | refused | differs | 42574.17 ± 0.4% | 23.52 | 1.00 | 3.73 | 900.76 |
| literal: an href attribute | 33 | 41447.56 ± 7.9% | 615.52 ± 0.1% | 29.97 ± 0.9% | 34880.40 ± 0.8% | 3018.32 ± 3.3% | 9.53 ± 0.2% | 91.37 ± 0.5% | 41537.31 ± 0.1% | 67.34 | 1.00 | 1.19 | 13.73 |
| literal: a word, second text | 123 | 51378.55 ± 0.2% | 3134.53 ± 0.6% | 30.94 ± 0.1% | 39621.92 ± 0.4% | 10953.19 ± 6.6% | 14.50 ± 0.3% | 88.16 ± 1.2% | 51353.88 ± 0.2% | 16.39 | 1.00 | 1.30 | 4.69 |
| class: two capitalized words | 1331 | 925.45 ± 0.4% | 611.32 ± 0.5% | 28.88 ± 0.3% | 574.88 ± 0.6% | 44.56 ± 0.2% | 10.97 ± 0.2% | 79.83 ± 0.4% | 927.25 ± 0.7% | 1.51 | 1.00 | 1.61 | 20.77 |
| class: a word that ends in ing | 3399 | 583.81 ± 1.3% | 585.13 ± 0.3% | 20.22 ± 0.5% | 538.92 ± 0.5% | 32.84 ± 4.0% | 6.18 ± 0.3% | 20.64 ± 0.8% | 585.08 ± 0.3% | 1.00 | 1.00 | 1.08 | 17.78 |
| class: a word in capitals | 2332 | 1158.84 ± 0.2% | 618.05 ± 0.1% | 30.51 ± 0.3% | 566.32 ± 1.0% | 47.76 ± 6.0% | 12.41 ± 0.3% | 102.27 ± 0.3% | 1159.14 ± 0.3% | 1.88 | 1.00 | 2.05 | 24.26 |
| class: a number | 8288 | 2031.43 ± 0.2% | 856.91 ± 0.4% | 30.89 ± 0.9% | 1817.23 ± 0.4% | 47.89 ± 13.9% | 0.38 ± 0.5% | 73.31 ± 0.2% | 2025.76 ± 1.4% | 2.37 | 1.00 | 1.12 | 42.42 |
| class: two capitalized words, second text | 5359 | 522.72 ± 0.1% | 529.67 ± 0.3% | 26.15 ± 0.7% | 478.42 ± 0.3% | 38.90 ± 15.1% | 12.75 ± 0.3% | 73.83 ± 0.3% | 522.47 ± 0.5% | 0.99 | 1.00 | 1.09 | 13.44 |
| other: a word between two words | 6104 | 926.60 ± 0.2% | 606.61 ± 0.3% | 25.83 ± 5.7% | 782.81 ± 0.9% | 125.16 ± 13.7% | 6.55 ± 1.3% | 82.46 ± 0.1% | 925.71 ± 0.7% | 1.53 | 1.00 | 1.18 | 7.40 |
| other: a number before a unit, second text | 1481 | 11273.00 ± 0.2% | 1071.63 ± 6.1% | 28.90 ± 0.7% | 8290.88 ± 6.8% | 45.40 ± 0.3% | 13.31 ± 0.2% | 77.66 ± 0.8% | 11241.59 ± 0.5% | 10.52 | 1.00 | 1.36 | 248.29 |
| other: a heading's start tag | 110 | 26393.71 ± 0.8% | 748.03 ± 0.3% | 30.72 ± 0.2% | 2567.34 ± 3.3% | 1997.44 ± 9.9% | 11.70 ± 1.4% | 107.29 ± 6.7% | 26339.79 ± 4.5% | 35.28 | 1.00 | 10.28 | 13.21 |
| other: a whole word | 217 | 34041.09 ± 0.2% | 607.91 ± 0.6% | 31.47 ± 0.4% | 27912.33 ± 9.8% | 54.22 ± 0.4% | 11.03 ± 0.1% | 63.45 ± 0.5% | 34089.98 ± 8.4% | 56.00 | 1.00 | 1.22 | 627.79 |
| other: a line's first word, second text | 3716 | 2782.22 ± 0.4% | 600.52 ± 0.2% | 34.89 ± 8.9% | 2327.25 ± 0.5% | 69.43 ± 7.8% | refused | refused | 2799.15 ± 1.7% | 4.63 | 0.99 | 1.20 | 40.07 |
| other: fourteen octets before an x | 87 | 37944.61 ± 1.1% | 251.97 ± 0.3% | 7.39 ± 0.5% | 3592.95 ± 0.3% | 11.57 ± 0.4% | differs | 21.54 ± 2.4% | 38058.17 ± 1.0% | 150.59 | 1.00 | 10.56 | 3280.74 |
| other: a Greek word | 21815 | 516.81 ± 0.4% | 441.59 ± 0.3% | 34.41 ± 0.3% | 304.69 ± 0.4% | 57.89 ± 9.0% | differs | refused | 518.73 ± 0.8% | 1.17 | 1.00 | 1.70 | 8.93 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 31.96 ± 0.2% | 31.60 ± 3.4% | 1.00 ± 1.4% | 19.89 ± 0.4% | 2.49 ± 17.9% | differs | 4.28 ± 3.6% | 32.35 ± 3.2% | 1.01 | 0.99 | 1.61 | 12.86 |
| a UUID | 32895 | 27.51 ± 0.3% | 27.43 ± 1.0% | 0.69 ± 1.1% | 15.13 ± 0.7% | 3.01 ± 1.5% | 0.52 ± 0.3% | 3.84 ± 1.6% | 27.46 ± 2.1% | 1.00 | 1.00 | 1.82 | 9.14 |
| an IPv4 address | 33176 | 40.52 ± 0.9% | 40.39 ± 0.9% | 2.20 ± 2.7% | 28.49 ± 3.2% | 7.00 ± 1.4% | differs | 3.91 ± 2.2% | 40.53 ± 0.7% | 1.00 | 1.00 | 1.42 | 5.79 |
| a date and time | 32954 | 37.26 ± 1.6% | 37.52 ± 0.7% | 1.66 ± 9.3% | 21.61 ± 2.2% | 8.21 ± 3.9% | 0.90 ± 0.4% | 8.06 ± 0.8% | 37.92 ± 1.1% | 0.99 | 0.98 | 1.72 | 4.54 |
| a field path | 32606 | 34.40 ± 1.0% | 34.28 ± 0.8% | 1.04 ± 1.7% | 23.03 ± 0.3% | 3.45 ± 2.8% | differs | 3.09 ± 0.4% | 34.29 ± 0.5% | 1.00 | 1.00 | 1.49 | 9.97 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 10.90 ± 0.2% | 10.84 ± 0.5% | 10.78 ± 1.2% | 11.85 ± 8.2% | 5.79 ± 1.0% | 0.75 ± 0.4% | none | 10.31 ± 5.6% | 1.01 | 1.06 | 0.92 | 1.88 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 255.47 ± 0.4% | 255.67 ± 0.1% | 298.36 ± 0.6% | 101.14 ± 1.7% | 231.55 ± 12.2% | 698.42 ± 12.7% | 4957.55 ± 0.5% | 255.48 ± 0.3% | 1.00 | 1.00 | 2.53 | 1.10 |
| a UUID | 62 | 167.93 ± 0.3% | 168.01 ± 0.4% | 188.09 ± 0.3% | 59.10 ± 2.2% | 117.98 ± 0.4% | 247.43 ± 2.4% | 5475.15 ± 0.8% | 168.06 ± 0.4% | 1.00 | 1.00 | 2.84 | 1.42 |
| an IPv4 address | 29 | 495.98 ± 0.3% | 495.92 ± 0.3% | 690.67 ± 1.0% | 86.42 ± 5.9% | 147.85 ± 8.0% | 415.31 ± 1.0% | 9028.77 ± 0.3% | 494.44 ± 0.8% | 1.00 | 1.00 | 5.74 | 3.35 |
| a date and time | 56 | 357.78 ± 0.3% | 357.62 ± 0.3% | 448.89 ± 0.2% | 86.98 ± 1.2% | 158.07 ± 1.5% | 473.91 ± 3.3% | 5718.70 ± 0.4% | 358.04 ± 0.2% | 1.00 | 1.00 | 4.11 | 2.26 |
| a field path | 39 | 252.54 ± 0.2% | 253.24 ± 0.5% | 294.79 ± 0.3% | 93.15 ± 15.2% | 229.05 ± 4.0% | 757.23 ± 3.3% | 6099.36 ± 0.8% | 252.66 ± 0.4% | 1.00 | 1.00 | 2.71 | 1.10 |
| literal: a word | 7 | 730.58 ± 0.3% | 783.69 ± 0.3% | 1381.74 ± 0.7% | 614.61 ± 1.7% | 771.01 ± 2.6% | 1606.60 ± 0.4% | 34790.42 ± 0.7% | 730.83 ± 0.2% | 0.93 | 1.00 | 1.19 | 0.95 |
| literal: a word that is not there | 8 | 706.44 ± 0.2% | 759.84 ± 1.0% | 1313.80 ± 0.6% | 574.77 ± 0.8% | 748.78 ± 2.9% | 1527.07 ± 0.5% | 34026.13 ± 0.9% | 706.81 ± 0.2% | 0.93 | 1.00 | 1.23 | 0.94 |
| literal: one of four words | 26 | 269.54 ± 0.3% | 448.31 ± 9.1% | 600.77 ± 0.5% | 53.84 ± 1.3% | 290.25 ± 2.0% | 575.99 ± 0.4% | 18070.51 ± 0.6% | 269.92 ± 0.1% | 0.60 | 1.00 | 5.01 | 0.93 |
| literal: a word in any case | 11 | 500.45 ± 1.0% | 529.08 ± 0.3% | 750.70 ± 0.9% | 18.96 ± 7.9% | 798.89 ± 2.7% | refused | 27755.94 ± 0.5% | 498.80 ± 5.1% | 0.95 | 1.00 | 26.40 | 0.63 |
| literal: an href attribute | 12 | 405.02 ± 4.3% | 418.08 ± 0.5% | 546.02 ± 1.2% | 50.89 ± 0.2% | 555.83 ± 15.5% | 1274.51 ± 2.4% | 24293.95 ± 0.8% | 404.34 ± 0.6% | 0.97 | 1.00 | 7.96 | 0.73 |
| literal: a word, second text | 10 | 651.64 ± 0.2% | 709.40 ± 0.2% | 1163.04 ± 0.6% | 539.22 ± 0.9% | 647.12 ± 0.6% | 1343.75 ± 0.2% | 32259.77 ± 0.9% | 653.31 ± 0.5% | 0.92 | 1.00 | 1.21 | 1.01 |
| class: two capitalized words | 23 | 514.33 ± 0.7% | 551.27 ± 0.5% | 794.62 ± 0.6% | 122.90 ± 1.1% | 597.08 ± 2.4% | 1256.79 ± 13.7% | 8135.89 ± 0.4% | 515.45 ± 0.5% | 0.93 | 1.00 | 4.19 | 0.86 |
| class: a word that ends in ing | 9 | 637.70 ± 13.6% | 727.93 ± 0.5% | 1255.70 ± 0.1% | 152.99 ± 0.8% | 845.97 ± 10.5% | 1846.97 ± 0.7% | 19435.71 ± 0.6% | 638.26 ± 0.6% | 0.88 | 1.00 | 4.17 | 0.75 |
| class: a word in capitals | 16 | 572.27 ± 0.2% | 618.19 ± 0.9% | 980.59 ± 1.0% | 156.83 ± 1.3% | 878.48 ± 1.3% | 1721.03 ± 0.6% | 10682.74 ± 0.2% | 572.37 ± 0.3% | 0.93 | 1.00 | 3.65 | 0.65 |
| class: a number | 6 | 718.59 ± 0.1% | 794.11 ± 0.2% | 1466.28 ± 0.5% | 47.90 ± 0.9% | 1577.48 ± 2.5% | 2988.37 ± 1.1% | 26095.31 ± 0.3% | 717.58 ± 0.5% | 0.90 | 1.00 | 15.00 | 0.46 |
| class: two capitalized words, second text | 23 | 512.93 ± 15.3% | 551.95 ± 1.0% | 794.23 ± 0.1% | 122.16 ± 0.7% | 590.63 ± 20.4% | 1244.56 ± 3.9% | 8163.14 ± 0.8% | 515.70 ± 0.4% | 0.93 | 0.99 | 4.20 | 0.87 |
| other: a word between two words | 13 | 628.57 ± 4.2% | 653.25 ± 15.9% | 1020.54 ± 0.7% | 159.39 ± 0.6% | 573.27 ± 21.1% | 1350.96 ± 16.4% | 18055.03 ± 0.7% | 627.54 ± 0.5% | 0.96 | 1.00 | 3.94 | 1.10 |
| other: a number before a unit, second text | 15 | 456.32 ± 0.1% | 509.33 ± 0.7% | 708.15 ± 0.7% | 44.47 ± 1.7% | 708.47 ± 1.3% | 1464.96 ± 0.7% | 17906.47 ± 0.9% | 456.69 ± 0.4% | 0.90 | 1.00 | 10.26 | 0.64 |
| other: a heading's start tag | 13 | 413.60 ± 0.6% | 420.92 ± 2.9% | 555.93 ± 9.9% | 48.29 ± 9.1% | 694.03 ± 2.0% | 1407.60 ± 0.4% | 19649.28 ± 2.4% | 413.17 ± 0.3% | 0.98 | 1.00 | 8.56 | 0.60 |
| other: a whole word | 11 | 648.32 ± 0.4% | 687.37 ± 0.3% | 1116.44 ± 12.6% | 144.75 ± 1.2% | 671.69 ± 1.0% | 1381.38 ± 3.8% | 31776.24 ± 1.2% | 648.39 ± 0.2% | 0.94 | 1.00 | 4.48 | 0.97 |
| other: a line's first word, second text | 17 | 598.36 ± 0.9% | 632.21 ± 0.2% | 992.70 ± 1.5% | 150.57 ± 0.4% | 788.70 ± 3.4% | refused | refused | 599.63 ± 0.8% | 0.95 | 1.00 | 3.97 | 0.76 |
| other: fourteen octets before an x | 16 | 116.81 ± 4.1% | 174.26 ± 5.2% | 205.15 ± 0.2% | 18.15 ± 0.7% | 496.94 ± 15.8% | 568.49 ± 2.1% | 15852.42 ± 0.4% | 116.71 ± 0.5% | 0.67 | 1.00 | 6.44 | 0.24 |
| other: a Greek word | 8 | 479.66 ± 0.1% | 671.89 ± 0.3% | 1111.28 ± 0.4% | 62.87 ± 0.6% | 1581.79 ± 11.5% | 2795.95 ± 8.9% | refused | 479.43 ± 0.7% | 0.71 | 1.00 | 7.63 | 0.30 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 37985.58 ± 0.2% | not timed | not timed | 33997.85 ± 21.2% | 2657.59 ± 19.8% | not timed | not timed | 37713.91 ± 0.5% | | 1.01 | 1.12 | 14.29 |
| 01-literal/sherlock-casei-en | 522 | 30089.04 ± 1.2% | not timed | not timed | 9008.20 ± 0.6% | 33.85 ± 0.7% | not timed | not timed | 29874.13 ± 0.5% | | 1.01 | 3.34 | 888.81 |
| 01-literal/sherlock-ru | 724 | 38949.63 ± 0.5% | not timed | not timed | 34527.54 ± 0.2% | 1295.61 ± 2.7% | not timed | not timed | 38861.53 ± 0.4% | | 1.00 | 1.13 | 30.06 |
| 01-literal/sherlock-casei-ru | 746 | 12396.36 ± 0.5% | not timed | not timed | 7795.49 ± 1.3% | 37.22 ± 2.9% | not timed | not timed | 12359.21 ± 1.0% | | 1.00 | 1.59 | 333.04 |
| 01-literal/sherlock-zh | 30 | 60345.52 ± 0.5% | not timed | not timed | 43005.98 ± 0.3% | 1640.94 ± 3.1% | not timed | not timed | 60319.14 ± 1.1% | | 1.00 | 1.40 | 36.77 |
| 02-literal-alternate/sherlock-en | 714 | 15687.73 ± 0.9% | not timed | not timed | 10929.00 ± 0.4% | 19.10 ± 0.5% | not timed | not timed | 15727.26 ± 0.4% | | 1.00 | 1.44 | 821.31 |
| 02-literal-alternate/sherlock-casei-en | 725 | 5070.37 ± 6.3% | not timed | not timed | 2307.95 ± 0.4% | 12.32 ± 0.8% | not timed | not timed | 5088.89 ± 4.8% | | 1.00 | 2.20 | 411.47 |
| 02-literal-alternate/sherlock-ru | 899 | 10766.10 ± 0.5% | not timed | not timed | 9800.04 ± 0.5% | 25.48 ± 7.5% | not timed | not timed | 10749.66 ± 0.5% | | 1.00 | 1.10 | 422.60 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2534.56 ± 2.5% | not timed | not timed | 1196.64 ± 0.8% | 10.56 ± 0.5% | not timed | not timed | 2547.53 ± 3.2% | | 0.99 | 2.12 | 240.06 |
| 02-literal-alternate/sherlock-zh | 207 | 20752.63 ± 0.2% | not timed | not timed | 12652.65 ± 0.3% | 35.48 ± 13.2% | not timed | not timed | 20759.54 ± 2.5% | | 1.00 | 1.64 | 584.95 |
| 03-date/ascii | 111817 | 146.85 ± 3.1% | not timed | not timed | 100.63 ± 0.4% | 0.23 ± 1.8% | not timed | not timed | 147.41 ± 5.2% | | 1.00 | 1.46 | 640.50 |
| 04-ruff-noqa/real | 84 | 510.45 ± 0.7% | not timed | not timed | 505.69 ± 0.8% | 20.44 ± 3.8% | not timed | not timed | 513.32 ± 0.4% | | 0.99 | 1.01 | 24.97 |
| 04-ruff-noqa/tweaked | 44 | 648.26 ± 0.5% | not timed | not timed | 515.62 ± 0.5% | 363.44 ± 0.8% | not timed | not timed | 653.42 ± 0.6% | | 0.99 | 1.26 | 1.78 |
| 05-lexer-veryl/single | 124800 | 4.67 ± 5.5% | not timed | not timed | 5.39 ± 0.8% | 0.25 ± 4.2% | not timed | not timed | 4.85 ± 0.8% | | 0.96 | 0.87 | 18.37 |
| 06-cloud-flare-redos/original | 107 | 430.83 ± 0.2% | not timed | not timed | 226.01 ± 1.3% | 25.43 ± 16.7% | not timed | not timed | 431.92 ± 0.5% | | 1.00 | 1.91 | 16.94 |
| 06-cloud-flare-redos/simplified-short | 102 | 425.05 ± 1.0% | not timed | not timed | 234.70 ± 1.0% | 27.27 ± 1.8% | not timed | not timed | 418.04 ± 0.9% | | 1.02 | 1.81 | 15.59 |
| 06-cloud-flare-redos/simplified-long | 10000 | 531.39 ± 1.0% | not timed | not timed | 259.13 ± 0.6% | 29.44 ± 1.3% | not timed | not timed | 530.16 ± 0.5% | | 1.00 | 2.05 | 18.05 |
| 07-unicode-character-data/parse-line | 558784 | 250.63 ± 1.4% | not timed | not timed | 201.70 ± 0.6% | 47.80 ± 5.5% | not timed | not timed | 249.78 ± 2.1% | | 1.00 | 1.24 | 5.24 |
| 08-words/all-english | 56691 | 134.19 ± 0.8% | not timed | not timed | 79.81 ± 11.4% | 15.00 ± 8.8% | not timed | not timed | 134.97 ± 0.9% | | 0.99 | 1.68 | 8.95 |
| 08-words/long-english | 839 | 619.43 ± 0.3% | not timed | not timed | 584.47 ± 0.4% | 35.20 ± 20.2% | not timed | not timed | 618.59 ± 0.3% | | 1.00 | 1.06 | 17.60 |
| 09-aws-keys/full | 0 | 515.86 ± 0.3% | not timed | not timed | 537.16 ± 0.3% | 57.92 ± 1.3% | not timed | not timed | 522.91 ± 1.0% | | 0.99 | 0.96 | 8.91 |
| 09-aws-keys/quick | 0 | 1152.04 ± 0.5% | not timed | not timed | 962.80 ± 1.0% | 393.84 ± 4.8% | not timed | not timed | 1151.12 ± 1.6% | | 1.00 | 1.20 | 2.93 |
| 10-bounded-repeat/letters-en | 1833 | 680.10 ± 0.7% | not timed | not timed | 555.38 ± 0.3% | 22.75 ± 9.5% | not timed | not timed | 679.21 ± 2.8% | | 1.00 | 1.22 | 29.90 |
| 10-bounded-repeat/letters-ru | 3475 | 524.78 ± 1.2% | not timed | not timed | 480.43 ± 0.2% | 23.59 ± 22.6% | not timed | not timed | 527.23 ± 2.1% | | 1.00 | 1.09 | 22.25 |
| 10-bounded-repeat/context | 53 | 88.30 ± 1.9% | not timed | not timed | 70.21 ± 2.2% | 22.74 ± 1.2% | not timed | not timed | 89.63 ± 1.4% | | 0.99 | 1.26 | 3.88 |
| 10-bounded-repeat/capitals | 11 | 637.01 ± 8.0% | not timed | not timed | 603.26 ± 0.4% | 40.17 ± 2.1% | not timed | not timed | 638.22 ± 8.0% | | 1.00 | 1.06 | 15.86 |
| 11-unstructured-to-json/extract | 600 | 52.37 ± 22.6% | not timed | not timed | 80.50 ± 1.3% | 34.01 ± 35.5% | not timed | not timed | 52.08 ± 1.0% | | 1.01 | 0.65 | 1.54 |
| 12-dictionary/single | 1 | 513.33 ± 0.7% | not timed | not timed | 480.35 ± 1.1% | 0.39 ± 8.7% | not timed | not timed | 512.90 ± 1.2% | | 1.00 | 1.07 | 1304.62 |
| 14-quadratic/1x | 100 | 25.94 ± 0.7% | not timed | not timed | 12.15 ± 0.7% | 0.98 ± 3.1% | not timed | not timed | 26.08 ± 1.7% | | 0.99 | 2.14 | 26.44 |
| 14-quadratic/2x | 200 | 19.72 ± 1.0% | not timed | not timed | 6.12 ± 0.3% | 0.54 ± 2.2% | not timed | not timed | 19.88 ± 0.5% | | 0.99 | 3.22 | 36.52 |
| 14-quadratic/10x | 1000 | 6.80 ± 12.3% | not timed | not timed | 1.22 ± 0.8% | 0.12 ± 1.6% | not timed | not timed | 6.81 ± 1.1% | | 1.00 | 5.59 | 58.25 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.38 ± 2.6% | not timed | not timed | 0.48 ± 0.7% | 0.63 ± 5.6% | not timed | not timed | 1.39 ± 2.3% | | 1.00 | 2.90 | 2.20 |
| 04-ruff-noqa/compile-real | 1 | 120.05 ± 5.2% | not timed | not timed | 17.34 ± 8.2% | 167.57 ± 10.7% | not timed | not timed | 120.56 ± 1.1% | | 1.00 | 6.92 | 0.72 |
| 05-lexer-veryl/compile-single | 1 | 16.39 ± 1.6% | not timed | not timed | 2.98 ± 6.7% | 7.85 ± 2.9% | not timed | not timed | 16.52 ± 2.9% | | 0.99 | 5.50 | 2.09 |
| 07-unicode-character-data/compile | 1 | 123.44 ± 1.0% | not timed | not timed | 30.79 ± 0.6% | 44.35 ± 1.7% | not timed | not timed | 125.93 ± 0.4% | | 0.98 | 4.01 | 2.78 |
| 09-aws-keys/compile-full | 1 | 55.11 ± 0.3% | not timed | not timed | 9.97 ± 1.4% | 27.41 ± 16.7% | not timed | not timed | 55.63 ± 1.1% | | 0.99 | 5.53 | 2.01 |
| 09-aws-keys/compile-quick | 1 | 191.54 ± 7.0% | not timed | not timed | 58.20 ± 0.4% | 154.62 ± 6.6% | not timed | not timed | 197.11 ± 0.4% | | 0.97 | 3.29 | 1.24 |
| 10-bounded-repeat/compile-context | 1 | 59.96 ± 0.5% | not timed | not timed | 14.51 ± 0.8% | 20.20 ± 1.4% | not timed | not timed | 60.38 ± 8.8% | | 0.99 | 4.13 | 2.97 |
| 10-bounded-repeat/compile-capitals | 1 | 92.57 ± 0.3% | not timed | not timed | 10.45 ± 1.2% | 29.47 ± 4.3% | not timed | not timed | 94.93 ± 27.7% | | 0.98 | 8.86 | 3.14 |
| 11-unstructured-to-json/compile | 1 | 191.10 ± 1.7% | not timed | not timed | 47.79 ± 0.6% | 78.36 ± 5.0% | not timed | not timed | 193.09 ± 1.6% | | 0.99 | 4.00 | 2.44 |
| 12-dictionary/compile-single | 1 | 0.34 ± 10.7% | not timed | not timed | 0.08 ± 2.9% | 0.11 ± 26.8% | not timed | not timed | 0.34 ± 1.8% | | 1.00 | 4.13 | 2.99 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 5.86 ± 5.2% | not timed | not timed | 6.07 ± 0.3% | 0.51 ± 11.3% | not timed | not timed | 7.33 ± 1.0% | | 0.80 | 0.96 | 11.40 |
| dictionary/search/english-10 | 690 | 1.30 ± 1.8% | not timed | not timed | 152.85 ± 1.2% | 0.01 ± 0.6% | not timed | not timed | 1.30 ± 1.2% | | 1.00 | 0.0085 | 188.22 |
| dictionary/search/english-15 | 15 | 507.97 ± 3.9% | not timed | not timed | 476.27 ± 1.7% | 0.37 ± 2.5% | not timed | not timed | 508.33 ± 0.9% | | 1.00 | 1.07 | 1377.11 |
| folly/awyer-inn-busted | 1 | 4146.35 ± 2.5% | not timed | not timed | 129.18 ± 3.2% | 47.37 ± 3.9% | not timed | not timed | 4161.73 ± 3.1% | | 1.00 | 32.10 | 87.53 |
| folly/literal-never-match-rare | 0 | 64924.87 ± 2.7% | not timed | not timed | 44909.23 ± 23.6% | 66733.42 ± 2.7% | not timed | not timed | 63981.62 ± 6.5% | | 1.01 | 1.45 | 0.97 |
| folly/literal-never-match-frequent | 0 | 25719.92 ± 4.9% | not timed | not timed | 45125.34 ± 3.0% | 2540.72 ± 1.8% | not timed | not timed | 26080.17 ± 6.2% | | 0.99 | 0.57 | 10.12 |
| folly/literal-never-match-tricksy | 1 | 3937.19 ± 0.9% | not timed | not timed | 6087.04 ± 39.2% | 1718.07 ± 0.5% | not timed | not timed | 3957.13 ± 0.6% | | 0.99 | 0.65 | 2.29 |
| grep/every-line | 239963 | 1470.22 ± 3.2% | not timed | not timed | 972.08 ± 1.1% | 376.02 ± 20.7% | not timed | not timed | 1477.04 ± 2.3% | | 1.00 | 1.51 | 3.91 |
| grep/long-words-ascii | 5073 | 504.08 ± 6.1% | not timed | not timed | 497.25 ± 0.2% | 50.70 ± 9.3% | not timed | not timed | 503.98 ± 0.9% | | 1.00 | 1.01 | 9.94 |
| imported/leipzig/twain | 811 | 57914.97 ± 1.6% | not timed | not timed | 43586.48 ± 0.2% | 12895.51 ± 11.3% | not timed | not timed | 57521.55 ± 1.8% | | 1.01 | 1.33 | 4.49 |
| imported/leipzig/twain-insensitive | 965 | 15472.31 ± 0.6% | not timed | not timed | 13444.54 ± 1.9% | 44.19 ± 1.9% | not timed | not timed | 15472.16 ± 0.7% | | 1.00 | 1.15 | 350.11 |
| imported/leipzig/shing | 1540 | 29229.75 ± 3.3% | not timed | not timed | 22220.91 ± 1.0% | 38.22 ± 0.6% | not timed | not timed | 30337.12 ± 2.8% | | 0.96 | 1.32 | 764.84 |
| imported/leipzig/huck-saw | 262 | 24985.59 ± 1.1% | not timed | not timed | 18747.70 ± 0.5% | 35.69 ± 0.2% | not timed | not timed | 24712.03 ± 17.1% | | 1.01 | 1.33 | 700.11 |
| imported/leipzig/word-ending-nn | 262 | 609.54 ± 0.7% | not timed | not timed | 603.84 ± 0.3% | 27.57 ± 0.5% | not timed | not timed | 609.68 ± 0.7% | | 1.00 | 1.01 | 22.11 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11542.88 ± 3.3% | not timed | not timed | 3776.15 ± 4.8% | 12.18 ± 2.5% | not timed | not timed | 11655.41 ± 3.2% | | 0.99 | 3.06 | 947.80 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 22053.79 ± 1.2% | not timed | not timed | 17527.59 ± 1.8% | 19.30 ± 1.3% | not timed | not timed | 22219.08 ± 1.9% | | 0.99 | 1.26 | 1142.55 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 5566.27 ± 0.1% | not timed | not timed | 790.33 ± 1.8% | 11.77 ± 2.3% | not timed | not timed | 5555.23 ± 0.6% | | 1.00 | 7.04 | 473.12 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 607.77 ± 0.1% | not timed | not timed | 602.35 ± 0.2% | 12.50 ± 1.3% | not timed | not timed | 607.90 ± 0.1% | | 1.00 | 1.01 | 48.63 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 608.23 ± 0.4% | not timed | not timed | 603.00 ± 0.1% | 10.80 ± 1.1% | not timed | not timed | 608.06 ± 0.2% | | 1.00 | 1.01 | 56.29 |
| imported/leipzig/tom-river | 2 | 12845.36 ± 1.1% | not timed | not timed | 13321.05 ± 0.7% | 35.07 ± 2.6% | not timed | not timed | 12844.44 ± 0.8% | | 1.00 | 0.96 | 366.32 |
| imported/leipzig/ing | 78424 | 599.10 ± 0.5% | not timed | not timed | 561.81 ± 0.1% | 30.66 ± 4.1% | not timed | not timed | 599.53 ± 0.7% | | 1.00 | 1.07 | 19.54 |
| imported/leipzig/ing-whitespace | 55248 | 730.15 ± 0.9% | not timed | not timed | 2144.55 ± 0.4% | 23.01 ± 2.9% | not timed | not timed | 742.31 ± 0.5% | | 0.98 | 0.34 | 31.73 |
| imported/leipzig/awyer-inn | 209 | 769.68 ± 1.5% | not timed | not timed | 13478.40 ± 6.0% | 25.15 ± 1.7% | not timed | not timed | 769.50 ± 1.2% | | 1.00 | 0.0571 | 30.60 |
| imported/leipzig/quotes-bounded | 8886 | 1847.31 ± 0.2% | not timed | not timed | 3264.90 ± 1.9% | 41.05 ± 2.6% | not timed | not timed | 1841.56 ± 0.5% | | 1.00 | 0.57 | 45.00 |
| imported/leipzig/non-ascii-alternate | 2 | 39780.47 ± 1.2% | not timed | not timed | 19445.05 ± 1.6% | 56.97 ± 0.4% | not timed | not timed | 39738.75 ± 2.2% | | 1.00 | 2.05 | 698.22 |
| imported/leipzig/math-symbols | 69 | 2427.15 ± 1.3% | not timed | not timed | 603.25 ± 0.7% | 39.24 ± 1.0% | not timed | not timed | 2427.36 ± 0.5% | | 1.00 | 4.02 | 61.85 |
| imported/leipzig/bounded-strings-ending-z | 0 | 609.40 ± 0.2% | not timed | not timed | 603.31 ± 0.4% | 25.91 ± 0.3% | not timed | not timed | 609.13 ± 0.6% | | 1.00 | 1.01 | 23.52 |
| imported/lh3lh3-reb/uri | 17549 | 815.65 ± 2.9% | not timed | not timed | 1130.65 ± 1.0% | 24.22 ± 2.0% | not timed | not timed | 812.83 ± 11.1% | | 1.00 | 0.72 | 33.67 |
| imported/lh3lh3-reb/email | 15057 | 808.75 ± 11.4% | not timed | not timed | 1131.36 ± 1.3% | 25.20 ± 24.6% | not timed | not timed | 809.48 ± 4.0% | | 1.00 | 0.71 | 32.10 |
| imported/lh3lh3-reb/date | 668 | 931.90 ± 3.3% | not timed | not timed | 1016.15 ± 0.8% | 53.13 ± 3.5% | not timed | not timed | 934.53 ± 0.2% | | 1.00 | 0.92 | 17.54 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 750.54 ± 0.8% | not timed | not timed | 443.20 ± 0.1% | 12.66 ± 11.5% | not timed | not timed | 746.50 ± 0.8% | | 1.01 | 1.69 | 59.29 |
| imported/mariomka/email | 92 | 35366.13 ± 0.9% | not timed | not timed | 60136.75 ± 0.5% | 35.94 ± 0.6% | not timed | not timed | 42822.42 ± 1.8% | | 0.83 | 0.59 | 984.03 |
| imported/mariomka/uri | 5301 | 6002.66 ± 0.4% | not timed | not timed | 7898.60 ± 0.6% | 35.97 ± 0.4% | not timed | not timed | 6645.17 ± 1.9% | | 0.90 | 0.76 | 166.90 |
| imported/mariomka/ip | 5 | 1811.14 ± 3.4% | not timed | not timed | 2307.42 ± 5.4% | 23.25 ± 4.4% | not timed | not timed | 1808.01 ± 5.9% | | 1.00 | 0.78 | 77.89 |
| imported/rsc/no-exponential | 0 | 895.23 ± 27.3% | not timed | not timed | 423.63 ± 0.9% | 25.98 ± 1.5% | not timed | not timed | 899.20 ± 1.1% | | 1.00 | 2.11 | 34.46 |
| imported/rsc/literal | 1 | 894.64 ± 9.1% | not timed | not timed | 2229.50 ± 0.7% | 219.44 ± 15.2% | not timed | not timed | 848.43 ± 13.6% | | 1.05 | 0.40 | 4.08 |
| imported/rsc/not-literal | 2 | 968.34 ± 31.5% | not timed | not timed | 839.00 ± 1.2% | 48.41 ± 37.9% | not timed | not timed | 971.02 ± 3.1% | | 1.00 | 1.15 | 20.00 |
| imported/rsc/match-class | 1 | 1671.17 ± 2.1% | not timed | not timed | 1828.34 ± 9.8% | 67.92 ± 7.3% | not timed | not timed | 1672.60 ± 2.0% | | 1.00 | 0.91 | 24.61 |
| imported/rsc/match-class-in-range | 1 | 1672.00 ± 7.4% | not timed | not timed | 3440.64 ± 0.5% | 69.91 ± 6.9% | not timed | not timed | 1665.47 ± 0.6% | | 1.00 | 0.49 | 23.92 |
| imported/rsc/match-class-unicode | 1 | 569.75 ± 0.5% | not timed | not timed | 521.24 ± 3.6% | 82.75 ± 0.3% | not timed | not timed | 567.83 ± 0.5% | | 1.00 | 1.09 | 6.89 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1700.75 ± 0.4% | not timed | not timed | 1149.30 ± 0.7% | 346.18 ± 1.2% | not timed | not timed | 1699.50 ± 0.2% | | 1.00 | 1.48 | 4.91 |
| imported/rsc/anchored-literal-long-non-match | 0 | 25477.09 ± 0.4% | not timed | not timed | 17368.32 ± 0.6% | 5178.57 ± 2.3% | not timed | not timed | 25518.82 ± 0.3% | | 1.00 | 1.47 | 4.92 |
| imported/rsc/anchored-literal-short-match | 4 | 874.86 ± 6.9% | not timed | not timed | 567.26 ± 4.7% | 107.03 ± 10.9% | not timed | not timed | 888.23 ± 1.7% | | 0.98 | 1.54 | 8.17 |
| imported/rsc/anchored-literal-long-match | 4 | 13059.38 ± 7.8% | not timed | not timed | 8477.96 ± 0.3% | 1643.73 ± 6.0% | not timed | not timed | 13276.28 ± 29.0% | | 0.98 | 1.54 | 7.94 |
| imported/rsc/one-pass-short | 17 | 485.46 ± 23.4% | not timed | not timed | 250.24 ± 0.7% | 35.62 ± 12.6% | not timed | not timed | 503.96 ± 0.4% | | 0.96 | 1.94 | 13.63 |
| imported/rsc/one-pass-short-not | 17 | 325.28 ± 2.8% | not timed | not timed | 271.28 ± 9.8% | 34.99 ± 11.3% | not timed | not timed | 326.67 ± 11.2% | | 1.00 | 1.20 | 9.30 |
| imported/rsc/one-pass-long-prefix | 26 | 443.77 ± 6.9% | not timed | not timed | 320.01 ± 1.0% | 130.36 ± 5.3% | not timed | not timed | 443.67 ± 5.5% | | 1.00 | 1.39 | 3.40 |
| imported/rsc/one-pass-long-prefix-not | 26 | 448.05 ± 2.5% | not timed | not timed | 320.68 ± 0.7% | 83.78 ± 11.9% | not timed | not timed | 451.47 ± 2.7% | | 0.99 | 1.40 | 5.35 |
| imported/rsc/long-needle1 | 31 | 68162.20 ± 0.2% | not timed | not timed | 45865.57 ± 1.2% | 4.18 ± 1.3% | not timed | not timed | 68054.65 ± 0.1% | | 1.00 | 1.49 | 16292.19 |
| imported/rsc/long-needle2 | 31 | 67691.46 ± 0.8% | not timed | not timed | 227.51 ± 0.3% | 4.18 ± 0.3% | not timed | not timed | 67702.23 ± 0.4% | | 1.00 | 297.53 | 16182.65 |
| imported/rsc/easy0-32 | 26 | 1258.81 ± 11.2% | not timed | not timed | 1901.43 ± 3.0% | 142.49 ± 43.5% | not timed | not timed | 1261.00 ± 1.6% | | 1.00 | 0.66 | 8.83 |
| imported/rsc/easy0-1k | 26 | 21405.36 ± 3.3% | not timed | not timed | 20381.99 ± 0.4% | 2257.56 ± 77.3% | not timed | not timed | 21403.35 ± 0.7% | | 1.00 | 1.05 | 9.48 |
| imported/rsc/easy0-32k | 26 | 64431.81 ± 2.2% | not timed | not timed | 43913.28 ± 14.8% | 25996.04 ± 22.8% | not timed | not timed | 64745.94 ± 10.3% | | 1.00 | 1.47 | 2.48 |
| imported/rsc/easy0-1mb | 26 | 64916.12 ± 8.4% | not timed | not timed | 46094.79 ± 0.2% | 67990.11 ± 0.6% | not timed | not timed | 64848.20 ± 8.1% | | 1.00 | 1.41 | 0.95 |
| imported/rsc/easy1-32 | 19 | 929.38 ± 3.8% | not timed | not timed | 727.12 ± 0.3% | 146.18 ± 35.7% | not timed | not timed | 929.66 ± 2.3% | | 1.00 | 1.28 | 6.36 |
| imported/rsc/easy1-1k | 19 | 18950.02 ± 8.7% | not timed | not timed | 15727.58 ± 11.3% | 2284.79 ± 33.4% | not timed | not timed | 19011.64 ± 1.2% | | 1.00 | 1.20 | 8.29 |
| imported/rsc/easy1-32k | 19 | 596979.68 ± 1.0% | not timed | not timed | 487162.17 ± 0.8% | 29337.56 ± 16.7% | not timed | not timed | 598457.80 ± 2.8% | | 1.00 | 1.23 | 20.35 |
| imported/rsc/easy1-1mb | 19 | 19121361.42 ± 0.6% | not timed | not timed | 15858657.23 ± 1.4% | 68063.22 ± 1.1% | not timed | not timed | 19137653.28 ± 0.6% | | 1.00 | 1.21 | 280.94 |
| imported/rsc/medium-32 | 27 | 875.90 ± 2.0% | not timed | not timed | 738.49 ± 0.9% | 73.02 ± 21.5% | not timed | not timed | 871.77 ± 0.4% | | 1.00 | 1.19 | 12.00 |
| imported/rsc/medium-1k | 27 | 15440.12 ± 0.7% | not timed | not timed | 12893.28 ± 0.3% | 82.44 ± 1.7% | not timed | not timed | 15505.46 ± 0.9% | | 1.00 | 1.20 | 187.30 |
| imported/rsc/medium-32k | 27 | 486020.61 ± 1.7% | not timed | not timed | 412580.98 ± 4.1% | 53.78 ± 7.7% | not timed | not timed | 483518.24 ± 0.8% | | 1.01 | 1.18 | 9037.07 |
| imported/rsc/medium-1mb | 27 | 15515601.33 ± 6.0% | not timed | not timed | 12513476.87 ± 4.0% | 54.53 ± 1.0% | not timed | not timed | 15469657.10 ± 0.4% | | 1.00 | 1.24 | 284536.29 |
| imported/rsc/hard-32 | 58 | 447.16 ± 4.9% | not timed | not timed | 388.94 ± 1.4% | 48.69 ± 8.3% | not timed | not timed | 448.32 ± 0.2% | | 1.00 | 1.15 | 9.18 |
| imported/rsc/hard-1k | 27 | 14784.07 ± 0.3% | not timed | not timed | 13043.72 ± 0.9% | 44.24 ± 12.5% | not timed | not timed | 14912.65 ± 1.1% | | 0.99 | 1.13 | 334.15 |
| imported/rsc/hard-32k | 27 | 463486.41 ± 2.4% | not timed | not timed | 407899.47 ± 0.5% | 32.97 ± 0.3% | not timed | not timed | 466353.31 ± 1.1% | | 0.99 | 1.14 | 14055.70 |
| imported/rsc/hard-1mb | 51 | 8959645.60 ± 0.6% | not timed | not timed | 7830991.80 ± 10.8% | 32.94 ± 18.2% | not timed | not timed | 8972541.33 ± 0.6% | | 1.00 | 1.14 | 271980.79 |
| imported/rsc/reallyhard0-32 | 58 | 281.29 ± 2.6% | not timed | not timed | 246.84 ± 10.9% | 51.82 ± 7.2% | not timed | not timed | 282.81 ± 0.2% | | 0.99 | 1.14 | 5.43 |
| imported/rsc/reallyhard0-1k | 27 | 591.38 ± 1.5% | not timed | not timed | 581.08 ± 0.3% | 44.47 ± 10.1% | not timed | not timed | 591.65 ± 0.9% | | 1.00 | 1.02 | 13.30 |
| imported/rsc/reallyhard0-32k | 27 | 608.12 ± 0.1% | not timed | not timed | 604.18 ± 0.6% | 32.52 ± 26.7% | not timed | not timed | 608.44 ± 0.2% | | 1.00 | 1.01 | 18.70 |
| imported/rsc/reallyhard0-1mb | 51 | 609.12 ± 0.5% | not timed | not timed | 604.13 ± 0.5% | 33.02 ± 12.7% | not timed | not timed | 609.64 ± 0.2% | | 1.00 | 1.01 | 18.45 |
| imported/rsc/reallyreallyhard0-32 | 47 | 332.72 ± 1.7% | not timed | not timed | 209.51 ± 0.3% | 61.39 ± 18.1% | not timed | not timed | 335.79 ± 3.6% | | 0.99 | 1.59 | 5.42 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7290.40 ± 4.7% | not timed | not timed | 7730.42 ± 0.2% | 36.47 ± 1.1% | not timed | not timed | 8216.19 ± 1.7% | | 0.89 | 0.94 | 199.88 |
| imported/rsc/reallyreallyhard0-32k | 16 | 51300.59 ± 0.3% | not timed | not timed | 36704.73 ± 0.3% | 26.28 ± 0.7% | not timed | not timed | 52862.80 ± 8.9% | | 0.97 | 1.40 | 1952.05 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 71151.14 ± 0.5% | not timed | not timed | 45616.87 ± 0.5% | 26.70 ± 0.1% | not timed | not timed | 71514.51 ± 9.7% | | 0.99 | 1.56 | 2664.95 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 323.67 ± 4.8% | not timed | not timed | 216.24 ± 1.5% | 64.99 ± 8.7% | not timed | not timed | 324.23 ± 1.3% | | 1.00 | 1.50 | 4.98 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 6070.04 ± 1.4% | not timed | not timed | 7556.45 ± 0.7% | 36.76 ± 1.1% | not timed | not timed | 6816.04 ± 0.5% | | 0.89 | 0.80 | 165.12 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 48043.98 ± 0.2% | not timed | not timed | 36833.38 ± 0.4% | 27.05 ± 0.6% | not timed | not timed | 48170.22 ± 0.2% | | 1.00 | 1.30 | 1776.03 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 66933.44 ± 0.8% | not timed | not timed | 45919.84 ± 0.6% | 27.10 ± 0.7% | not timed | not timed | 66998.26 ± 0.5% | | 1.00 | 1.46 | 2469.86 |
| imported/sherlock/name-sherlock | 776 | 51121.49 ± 10.7% | not timed | not timed | 40270.69 ± 1.4% | 13959.63 ± 3.3% | not timed | not timed | 51397.90 ± 11.8% | | 0.99 | 1.27 | 3.66 |
| imported/sherlock/name-holmes | 2766 | 27842.90 ± 4.6% | not timed | not timed | 30268.36 ± 0.8% | 3936.99 ± 11.2% | not timed | not timed | 28097.92 ± 3.3% | | 0.99 | 0.92 | 7.07 |
| imported/sherlock/name-sherlock-holmes | 1365 | 51948.72 ± 9.6% | not timed | not timed | 40500.11 ± 0.6% | 10636.52 ± 17.3% | not timed | not timed | 51791.26 ± 0.9% | | 1.00 | 1.28 | 4.88 |
| imported/sherlock/name-sherlock-casei | 816 | 46661.26 ± 0.5% | not timed | not timed | 11616.07 ± 0.3% | 33.72 ± 1.8% | not timed | not timed | 46671.21 ± 1.3% | | 1.00 | 4.02 | 1383.62 |
| imported/sherlock/name-holmes-casei | 2802 | 22573.43 ± 0.5% | not timed | not timed | 7680.89 ± 0.3% | 44.45 ± 1.2% | not timed | not timed | 22540.45 ± 0.7% | | 1.00 | 2.94 | 507.86 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 36446.00 ± 0.3% | not timed | not timed | 11192.73 ± 1.3% | 34.11 ± 1.1% | not timed | not timed | 36474.77 ± 0.4% | | 1.00 | 3.26 | 1068.59 |
| imported/sherlock/name-whitespace | 1461 | 29952.15 ± 1.3% | not timed | not timed | 28021.55 ± 0.4% | 8390.57 ± 22.6% | not timed | not timed | 30338.37 ± 1.3% | | 0.99 | 1.07 | 3.57 |
| imported/sherlock/name-alt1 | 1142 | 31522.84 ± 0.2% | not timed | not timed | 30016.57 ± 1.2% | 5647.16 ± 29.9% | not timed | not timed | 31561.64 ± 2.3% | | 1.00 | 1.05 | 5.58 |
| imported/sherlock/name-alt2 | 3542 | 21221.70 ± 0.3% | not timed | not timed | 10095.64 ± 0.5% | 35.97 ± 1.3% | not timed | not timed | 21285.65 ± 0.3% | | 1.00 | 2.10 | 590.06 |
| imported/sherlock/name-alt3 | 4507 | 13518.12 ± 0.4% | not timed | not timed | 9222.14 ± 0.5% | 11.27 ± 1.7% | not timed | not timed | 13583.79 ± 0.7% | | 1.00 | 1.47 | 1199.25 |
| imported/sherlock/name-alt3-casei | 4593 | 3536.70 ± 5.5% | not timed | not timed | 1303.47 ± 0.2% | 7.54 ± 0.5% | not timed | not timed | 3558.24 ± 3.3% | | 0.99 | 2.71 | 469.06 |
| imported/sherlock/name-alt4 | 3686 | 9448.19 ± 1.6% | not timed | not timed | 8064.30 ± 0.6% | 35.54 ± 2.6% | not timed | not timed | 9986.77 ± 0.6% | | 0.95 | 1.17 | 265.81 |
| imported/sherlock/name-alt4-casei | 4254 | 5448.03 ± 1.3% | not timed | not timed | 4490.27 ± 0.9% | 20.70 ± 1.5% | not timed | not timed | 5484.72 ± 1.4% | | 0.99 | 1.21 | 263.25 |
| imported/sherlock/name-alt5 | 4028 | 17308.69 ± 0.3% | not timed | not timed | 9705.39 ± 1.0% | 24.83 ± 0.4% | not timed | not timed | 17327.71 ± 0.3% | | 1.00 | 1.78 | 696.98 |
| imported/sherlock/name-alt5-casei | 4104 | 7010.70 ± 0.7% | not timed | not timed | 3005.09 ± 0.7% | 15.49 ± 1.4% | not timed | not timed | 7043.34 ± 0.6% | | 1.00 | 2.33 | 452.47 |
| imported/sherlock/no-match-uncommon | 0 | 69139.51 ± 0.5% | not timed | not timed | 58113.63 ± 1.1% | 58264.04 ± 0.7% | not timed | not timed | 69220.37 ± 0.5% | | 1.00 | 1.19 | 1.19 |
| imported/sherlock/no-match-common | 0 | 67537.47 ± 0.5% | not timed | not timed | 58131.21 ± 1.2% | 2138.76 ± 0.3% | not timed | not timed | 67442.96 ± 1.7% | | 1.00 | 1.16 | 31.58 |
| imported/sherlock/no-match-really-common | 0 | 43085.61 ± 0.2% | not timed | not timed | 49755.51 ± 2.4% | 2158.39 ± 0.3% | not timed | not timed | 43030.23 ± 1.1% | | 1.00 | 0.87 | 19.96 |
| imported/sherlock/the-lower | 21654 | 3993.78 ± 1.1% | not timed | not timed | 4561.51 ± 1.6% | 271.73 ± 14.9% | not timed | not timed | 3990.89 ± 1.0% | | 1.00 | 0.88 | 14.70 |
| imported/sherlock/the-upper | 2223 | 20949.37 ± 1.9% | not timed | not timed | 29371.85 ± 0.2% | 3079.73 ± 15.0% | not timed | not timed | 20788.25 ± 1.8% | | 1.01 | 0.71 | 6.80 |
| imported/sherlock/the-casei | 23961 | 3488.36 ± 1.9% | not timed | not timed | 1361.57 ± 2.3% | 41.67 ± 13.1% | not timed | not timed | 3482.60 ± 0.6% | | 1.00 | 2.56 | 83.72 |
| imported/sherlock/everything-greedy | 581881 | 294.06 ± 1.0% | not timed | not timed | 173.73 ± 1.0% | 30.56 ± 31.8% | not timed | not timed | 294.48 ± 0.7% | | 1.00 | 1.69 | 9.62 |
| imported/sherlock/everything-greedy-nl | 594933 | 464.74 ± 2.3% | not timed | not timed | 225.21 ± 3.3% | 34.77 ± 6.7% | not timed | not timed | 464.17 ± 1.2% | | 1.00 | 2.06 | 13.37 |
| imported/sherlock/letters | 447175 | 67.00 ± 7.6% | not timed | not timed | 34.03 ± 2.7% | 6.23 ± 18.3% | not timed | not timed | 67.24 ± 0.8% | | 1.00 | 1.97 | 10.76 |
| imported/sherlock/letters-upper | 14180 | 451.79 ± 1.2% | not timed | not timed | 365.90 ± 4.9% | 30.86 ± 24.4% | not timed | not timed | 453.30 ± 2.4% | | 1.00 | 1.23 | 14.64 |
| imported/sherlock/letters-lower | 432995 | 68.23 ± 1.9% | not timed | not timed | 33.72 ± 0.2% | 6.74 ± 25.6% | not timed | not timed | 68.20 ± 18.6% | | 1.00 | 2.02 | 10.13 |
| imported/sherlock/words | 447639 | 124.63 ± 0.9% | not timed | not timed | 83.91 ± 2.3% | 15.66 ± 23.1% | not timed | not timed | 125.49 ± 6.0% | | 0.99 | 1.49 | 7.96 |
| imported/sherlock/before-holmes | 4073 | 13566.82 ± 0.2% | not timed | not timed | 13311.43 ± 0.4% | 25.78 ± 0.1% | not timed | not timed | 15308.80 ± 0.1% | | 0.89 | 1.02 | 526.30 |
| imported/sherlock/before-after-holmes | 2593 | 13227.58 ± 0.2% | not timed | not timed | 15030.91 ± 0.3% | 25.82 ± 0.4% | not timed | not timed | 15072.43 ± 0.4% | | 0.88 | 0.88 | 512.30 |
| imported/sherlock/holmes-cochar-watson | 150 | 9995.67 ± 0.5% | not timed | not timed | 7680.95 ± 1.0% | 35.33 ± 5.0% | not timed | not timed | 10088.21 ± 0.6% | | 0.99 | 1.30 | 282.89 |
| imported/sherlock/holmes-coword-watson | 14309 | 1272.26 ± 0.5% | not timed | not timed | 1232.66 ± 0.7% | 7.59 ± 0.7% | not timed | not timed | 1277.41 ± 0.4% | | 1.00 | 1.03 | 167.67 |
| imported/sherlock/quotes | 14437 | 1364.10 ± 0.5% | not timed | not timed | 2223.57 ± 3.9% | 37.56 ± 0.8% | not timed | not timed | 1362.31 ± 4.9% | | 1.00 | 0.61 | 36.32 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 605.51 ± 0.8% | not timed | not timed | 31357.53 ± 1.5% | 40.27 ± 0.8% | not timed | not timed | 605.63 ± 0.4% | | 1.00 | 0.0193 | 15.04 |
| imported/sherlock/word-ending-n | 35297 | 477.52 ± 0.1% | not timed | not timed | 400.08 ± 0.4% | 25.93 ± 1.9% | not timed | not timed | 477.50 ± 0.7% | | 1.00 | 1.19 | 18.42 |
| imported/sherlock/repeated-class-negation | 2130 | 19191.52 ± 0.5% | not timed | not timed | 16578.71 ± 0.2% | 12.39 ± 1.6% | not timed | not timed | 19120.87 ± 1.0% | | 1.00 | 1.16 | 1549.18 |
| imported/sherlock/ing-suffix | 20547 | 571.31 ± 0.9% | not timed | not timed | 510.51 ± 0.4% | 30.68 ± 31.9% | not timed | not timed | 571.59 ± 1.3% | | 1.00 | 1.12 | 18.62 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 605.66 ± 1.9% | not timed | not timed | 2907.48 ± 1.2% | 22.79 ± 2.8% | not timed | not timed | 606.14 ± 1.1% | | 1.00 | 0.21 | 26.58 |
| opt/accelerate/whole-line | 239963 | 505.19 ± 0.2% | not timed | not timed | 414.16 ± 1.0% | 92.63 ± 16.6% | not timed | not timed | 504.63 ± 1.5% | | 1.00 | 1.22 | 5.45 |
| opt/accelerate/non-dna | 16745 | 452.14 ± 0.7% | not timed | not timed | 439.07 ± 0.3% | 32.86 ± 19.8% | not timed | not timed | 453.67 ± 0.9% | | 1.00 | 1.03 | 13.76 |
| opt/backtrack/words-english | 40536 | 139.70 ± 3.7% | not timed | not timed | 108.38 ± 0.9% | 19.82 ± 9.2% | not timed | not timed | 137.05 ± 3.9% | | 1.02 | 1.29 | 7.05 |
| opt/fixed-length/too-small-ascii | 0 | 390.24 ± 0.3% | not timed | not timed | 708.89 ± 0.1% | 123.13 ± 3.3% | not timed | not timed | 391.77 ± 0.9% | | 1.00 | 0.55 | 3.17 |
| opt/fixed-length/too-big-ascii | 0 | 4271.62 ± 2.7% | not timed | not timed | 6309.35 ± 1.2% | 146.41 ± 1.0% | not timed | not timed | 4346.41 ± 0.4% | | 0.98 | 0.68 | 29.18 |
| opt/fixed-length/go33484-1 | 0 | 836345.24 ± 0.6% | not timed | not timed | 1216030.68 ± 0.5% | 75646.65 ± 1.3% | not timed | not timed | 836744.92 ± 0.7% | | 1.00 | 0.69 | 11.06 |
| opt/fixed-length/go33484-2 | 0 | 836942.24 ± 0.5% | not timed | not timed | 1213598.61 ± 3.7% | 25943.17 ± 20.1% | not timed | not timed | 836011.86 ± 0.7% | | 1.00 | 0.69 | 32.26 |
| opt/fixed-length/go33484-3 | 0 | 2437.25 ± 0.6% | not timed | not timed | 121789.99 ± 0.6% | 941.00 ± 0.7% | not timed | not timed | 2434.80 ± 0.4% | | 1.00 | 0.0200 | 2.59 |
| opt/literal-alt/one-pattern | 1 | 560.35 ± 1.4% | not timed | not timed | 570.29 ± 0.3% | 0.38 ± 1.5% | not timed | not timed | 581.96 ± 1.4% | | 0.96 | 0.98 | 1487.47 |
| opt/onepass/fn-predicate | 916 | 435.55 ± 3.2% | not timed | not timed | 395.08 ± 0.6% | 205.24 ± 23.1% | not timed | not timed | 438.70 ± 0.6% | | 0.99 | 1.10 | 2.12 |
| opt/onepass/first-three-words-english | 35128 | 176.62 ± 0.9% | not timed | not timed | 229.99 ± 2.9% | 72.54 ± 27.2% | not timed | not timed | 177.59 ± 2.5% | | 0.99 | 0.77 | 2.43 |
| opt/prefilter/literal-english | 1 | 68138.26 ± 0.3% | not timed | not timed | 46504.19 ± 0.3% | 26914.89 ± 20.6% | not timed | not timed | 68213.64 ± 0.6% | | 1.00 | 1.47 | 2.53 |
| opt/prefilter/literal-casei-english | 1 | 47172.27 ± 0.7% | not timed | not timed | 14281.00 ± 0.1% | 34.14 ± 1.2% | not timed | not timed | 47183.37 ± 0.8% | | 1.00 | 3.30 | 1381.86 |
| opt/prefilter/literal-russian | 1 | 68990.24 ± 1.7% | not timed | not timed | 46444.07 ± 0.3% | 1805.46 ± 0.1% | not timed | not timed | 68925.76 ± 1.9% | | 1.00 | 1.49 | 38.21 |
| opt/prefilter/literal-casei-russian | 1 | 26002.69 ± 19.4% | not timed | not timed | 11041.12 ± 0.1% | 37.58 ± 13.0% | not timed | not timed | 26009.42 ± 0.3% | | 1.00 | 2.36 | 691.90 |
| opt/prefilter/rust-functions | 948 | 14601.81 ± 1.3% | not timed | not timed | 12820.17 ± 15.3% | 1954.31 ± 0.5% | not timed | not timed | 14594.95 ± 1.4% | | 1.00 | 1.14 | 7.47 |
| opt/reverse-anchored/word-end | 1 | 35659292.65 ± 0.5% | not timed | not timed | 26789039.96 ± 0.6% | 56.63 ± 0.3% | not timed | not timed | 35549623.54 ± 0.8% | | 1.00 | 1.33 | 629692.48 |
| opt/reverse-inner/holmes | 2593 | 13224.99 ± 1.0% | not timed | not timed | 14972.32 ± 0.3% | 25.14 ± 0.9% | not timed | not timed | 15086.77 ± 0.5% | | 0.88 | 0.88 | 525.97 |
| opt/reverse-inner/email | 47 | 81930.00 ± 0.7% | not timed | not timed | 92662.27 ± 0.5% | 34.77 ± 6.0% | not timed | not timed | 85040.89 ± 0.6% | | 0.96 | 0.88 | 2356.33 |
| opt/reverse-inner/factored-prefix | 3542 | 599.53 ± 0.5% | not timed | not timed | 586.11 ± 0.4% | 13.79 ± 0.4% | not timed | not timed | 600.20 ± 0.7% | | 1.00 | 1.02 | 43.49 |
| opt/reverse-inner/no-quadratic-backward | 0 | 4198.95 ± 0.2% | not timed | not timed | 604.65 ± 0.3% | 86.04 ± 0.6% | not timed | not timed | 4196.96 ± 12.0% | | 1.00 | 6.94 | 48.80 |
| opt/reverse-inner/no-quadratic-forward | 0 | 708.48 ± 2.0% | not timed | not timed | 279.64 ± 0.2% | 26.14 ± 1.4% | not timed | not timed | 709.54 ± 2.1% | | 1.00 | 2.53 | 27.10 |
| opt/reverse-suffix/holmes | 4073 | 13567.94 ± 0.4% | not timed | not timed | 13328.53 ± 17.6% | 25.24 ± 4.7% | not timed | not timed | 15292.78 ± 0.2% | | 0.89 | 1.02 | 537.46 |
| opt/reverse-suffix/no-quadratic | 0 | 4199.39 ± 0.4% | not timed | not timed | 603.48 ± 0.7% | 85.33 ± 0.1% | not timed | not timed | 4196.74 ± 1.3% | | 1.00 | 6.96 | 49.22 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 141.80 ± 3.5% | not timed | not timed | 181.51 ± 0.3% | 15.05 ± 26.0% | not timed | not timed | 142.85 ± 1.7% | | 0.99 | 0.78 | 9.42 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 141.33 ± 4.1% | not timed | not timed | 181.41 ± 0.6% | 13.59 ± 16.1% | not timed | not timed | 139.09 ± 6.5% | | 1.02 | 0.78 | 10.40 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.31 ± 0.6% | not timed | not timed | 0.49 ± 0.3% | 119.71 ± 8.0% | not timed | not timed | 0.31 ± 2.8% | | 0.99 | 0.64 | 0.0026 |
| reported/i1095-word-repetition/ascii-search | 256 | 299.51 ± 0.4% | not timed | not timed | 284.40 ± 0.8% | 106.97 ± 0.2% | not timed | not timed | 300.50 ± 0.9% | | 1.00 | 1.05 | 2.80 |
| reported/i13-subset-regex/original-ascii | 4094 | 11908.27 ± 0.6% | not timed | not timed | 3940.02 ± 1.6% | 11.71 ± 1.1% | not timed | not timed | 11941.34 ± 4.3% | | 1.00 | 3.02 | 1016.63 |
| reported/i13-subset-regex/original-unicode | 4094 | 11866.11 ± 0.5% | not timed | not timed | 213.89 ± 1.6% | 11.74 ± 1.6% | not timed | not timed | 11875.30 ± 0.5% | | 1.00 | 55.48 | 1011.09 |
| reported/i13-subset-regex/big-ascii | 1955 | 11125.46 ± 1.2% | not timed | not timed | 54.43 ± 2.3% | 10.11 ± 0.9% | not timed | not timed | 11149.05 ± 0.3% | | 1.00 | 204.41 | 1100.53 |
| reported/i13-subset-regex/big-unicode | 1955 | 10990.49 ± 1.7% | not timed | not timed | 9.61 ± 55.3% | 10.14 ± 1.3% | not timed | not timed | 11088.60 ± 1.2% | | 0.99 | 1143.11 | 1084.07 |
| reported/i13-subset-regex/huge-ascii | 55 | 10145.79 ± 1.7% | not timed | not timed | 8.68 ± 0.9% | 9.14 ± 1.0% | not timed | not timed | 10142.48 ± 0.6% | | 1.00 | 1168.36 | 1110.33 |
| reported/i13-subset-regex/huge-unicode | 55 | 10125.74 ± 0.5% | not timed | not timed | 9.02 ± 0.8% | 9.20 ± 0.5% | not timed | not timed | 10097.19 ± 1.3% | | 1.00 | 1122.61 | 1101.19 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 4.20 ± 0.5% | not timed | not timed | 9.14 ± 0.8% | 9.17 ± 0.3% | not timed | not timed | 4.14 ± 0.3% | | 1.01 | 0.46 | 0.46 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.72 ± 0.6% | not timed | not timed | 8.81 ± 1.2% | 9.15 ± 2.6% | not timed | not timed | 5.84 ± 0.7% | | 0.98 | 0.65 | 0.63 |
| reported/i787-keywords/ascii | 5674 | 554.97 ± 0.7% | not timed | not timed | 171.16 ± 0.3% | 7.46 ± 1.9% | not timed | not timed | 559.13 ± 1.3% | | 0.99 | 3.24 | 74.43 |
| reported/i787-keywords/opt-ascii | 5674 | 557.83 ± 0.5% | not timed | not timed | 272.20 ± 1.2% | 12.23 ± 0.4% | not timed | not timed | 557.26 ± 0.5% | | 1.00 | 2.05 | 45.63 |
| slow/quadratic-regex-1x | 100 | 8.20 ± 0.8% | not timed | not timed | 6.02 ± 0.4% | 0.05 ± 11.7% | not timed | not timed | 8.24 ± 1.9% | | 1.00 | 1.36 | 162.45 |
| slow/quadratic-regex-2x | 199 | 3.69 ± 0.5% | not timed | not timed | 3.04 ± 0.2% | 0.01 ± 1.4% | not timed | not timed | 3.70 ± 0.2% | | 1.00 | 1.21 | 277.82 |
| slow/quadratic-haystack-1x | 100 | 25.94 ± 2.8% | not timed | not timed | 12.20 ± 0.4% | 1.04 ± 7.9% | not timed | not timed | 26.17 ± 2.0% | | 0.99 | 2.13 | 25.02 |
| slow/quadratic-haystack-2x | 200 | 19.58 ± 7.3% | not timed | not timed | 5.98 ± 1.8% | 0.55 ± 0.7% | not timed | not timed | 19.91 ± 0.6% | | 0.98 | 3.27 | 35.62 |
| unicode/codepoints/any-one | 1112064 | 337.04 ± 0.3% | not timed | not timed | 240.61 ± 0.4% | 21.86 ± 14.7% | not timed | not timed | 338.59 ± 0.2% | | 1.00 | 1.40 | 15.42 |
| unicode/codepoints/any-all | 4382592 | 267.69 ± 0.5% | not timed | not timed | 259.98 ± 3.2% | 125.77 ± 0.7% | not timed | not timed | 268.99 ± 0.4% | | 1.00 | 1.03 | 2.13 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 7.91 ± 2.4% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.08 ± 0.3% | not timed | not timed | 604.34 ± 0.2% | 151.91 ± 2.4% | not timed | not timed | 610.58 ± 0.2% | | 1.00 | 1.01 | 4.02 |
| unicode/overlapping-words/ascii | 6156 | 27.37 ± 8.7% | not timed | not timed | 42.40 ± 2.0% | 4.23 ± 4.6% | not timed | not timed | 28.65 ± 21.0% | | 0.96 | 0.65 | 6.47 |
| unicode/overlapping-words/english | 6156 | 1.47 ± 2.8% | not timed | not timed | 2.95 ± 0.2% | 2.76 ± 10.2% | not timed | not timed | 1.47 ± 6.9% | | 1.00 | 0.50 | 0.53 |
| unicode/overlapping-words/russian | 5710 | 1.32 ± 1.5% | not timed | not timed | 2.71 ± 1.2% | 6.97 ± 9.3% | not timed | not timed | 1.33 ± 6.7% | | 1.00 | 0.49 | 0.19 |
| unicode/word/boundary-any-english | 450561 | 138.05 ± 1.1% | not timed | not timed | 85.09 ± 0.8% | 13.92 ± 13.5% | not timed | not timed | 138.32 ± 5.9% | | 1.00 | 1.62 | 9.92 |
| unicode/word/boundary-long-english | 3466 | 611.82 ± 0.1% | not timed | not timed | 593.17 ± 0.2% | 32.01 ± 2.0% | not timed | not timed | 612.00 ± 0.2% | | 1.00 | 1.03 | 19.11 |
| unicode/word/around-holmes-english | 27 | 63816.09 ± 0.3% | not timed | not timed | 45074.47 ± 0.6% | 23.87 ± 0.9% | not timed | not timed | 64108.49 ± 1.4% | | 1.00 | 1.42 | 2673.10 |
| wild/bibleref/long | 874 | 569.81 ± 0.4% | not timed | not timed | 573.50 ± 0.4% | 6.49 ± 0.3% | not timed | not timed | 571.13 ± 0.1% | | 1.00 | 0.99 | 87.76 |
| wild/bibleref/short | 30 | 22.85 ± 1.3% | not timed | not timed | 32.59 ± 0.9% | 15.51 ± 34.2% | not timed | not timed | 23.82 ± 33.2% | | 0.96 | 0.70 | 1.47 |
| wild/bibleref/line | 874 | 508.91 ± 15.8% | not timed | not timed | 268.65 ± 0.4% | 9.50 ± 2.0% | not timed | not timed | 514.70 ± 1.0% | | 0.99 | 1.89 | 53.57 |
| wild/caddy/caddy | 6 | 448.22 ± 1.8% | not timed | not timed | 282.69 ± 2.2% | 75.50 ± 14.9% | not timed | not timed | 412.21 ± 26.0% | | 1.09 | 1.59 | 5.94 |
| wild/dot-star-capture/rust-src-tools | 6 | 1453.50 ± 2.3% | not timed | not timed | 404.41 ± 3.8% | 15.91 ± 2.3% | not timed | not timed | 1450.79 ± 1.1% | | 1.00 | 3.59 | 91.39 |
| wild/ruff/noqa | 84 | 507.24 ± 1.0% | not timed | not timed | 502.17 ± 1.6% | 20.62 ± 10.7% | not timed | not timed | 512.25 ± 1.2% | | 0.99 | 1.01 | 24.60 |
| wild/ruff/unnecessary-coding-comment | 16 | 1074.02 ± 1.0% | not timed | not timed | 723.00 ± 2.2% | 89.72 ± 11.3% | not timed | not timed | 1074.49 ± 3.3% | | 1.00 | 1.49 | 11.97 |
| wild/ruff/string-quote-prefix | 2972 | 1541.29 ± 2.5% | not timed | not timed | 453.07 ± 2.6% | 315.93 ± 30.0% | not timed | not timed | 1575.31 ± 3.3% | | 0.98 | 3.40 | 4.88 |
| wild/ruff/space-around-operator | 1224378 | 230.11 ± 10.6% | not timed | not timed | 218.69 ± 2.7% | 18.50 ± 4.9% | not timed | not timed | 236.73 ± 1.6% | | 0.97 | 1.05 | 12.44 |
| wild/ruff/shebang | 282 | 1102.25 ± 2.1% | not timed | not timed | 381.77 ± 1.4% | 103.77 ± 12.1% | not timed | not timed | 1099.25 ± 2.0% | | 1.00 | 2.89 | 10.62 |
| wild/rustsec-cargo-audit/original-unix | 471 | 22414.52 ± 2.0% | not timed | not timed | 23462.80 ± 2.4% | 8787.52 ± 3.0% | not timed | not timed | 21865.87 ± 2.8% | | 1.03 | 0.96 | 2.55 |
| wild/rustsec-cargo-audit/original-windows | 462 | 20490.98 ± 2.5% | not timed | not timed | 22270.88 ± 2.0% | 8361.69 ± 2.3% | not timed | not timed | 20512.88 ± 0.9% | | 1.00 | 0.92 | 2.45 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 22541.01 ± 2.7% | not timed | not timed | 23178.72 ± 0.8% | 8634.91 ± 1.9% | not timed | not timed | 22640.91 ± 3.9% | | 1.00 | 0.97 | 2.61 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 17580.11 ± 4.2% | not timed | not timed | 22927.97 ± 3.9% | 8379.86 ± 23.1% | not timed | not timed | 17907.25 ± 1.2% | | 0.98 | 0.77 | 2.10 |
| wild/url/search | 234965 | 126.00 ± 19.4% | not timed | not timed | 60.88 ± 2.7% | 2.43 ± 2.2% | not timed | not timed | 127.61 ± 14.7% | | 0.99 | 2.07 | 51.87 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 3.1% | not timed | not timed | 0.01 ± 5.4% | 0.01 ± 8.6% | not timed | not timed | 0.03 ± 2.6% | | 0.98 | 2.55 | 4.05 |
| dictionary/compile/english-15 | 1 | 0.33 ± 2.7% | not timed | not timed | 0.09 ± 1.0% | 0.12 ± 28.3% | not timed | not timed | 0.34 ± 2.1% | | 0.98 | 3.51 | 2.81 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.30 ± 15.1% | not timed | not timed | 0.02 ± 1.7% | 35.58 ± 7.0% | not timed | not timed | 0.29 ± 4.4% | | 1.01 | 13.23 | 0.0083 |
| reported/i1095-word-repetition/ascii-compile | 1 | 43.57 ± 6.5% | not timed | not timed | 16.89 ± 0.3% | 61.10 ± 20.6% | not timed | not timed | 44.30 ± 18.3% | | 0.98 | 2.58 | 0.71 |
| reported/i787-keywords/compile | 1 | 38.97 ± 17.4% | not timed | not timed | 2.39 ± 0.9% | 16.49 ± 22.2% | not timed | not timed | 40.35 ± 3.4% | | 0.97 | 16.33 | 2.36 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 370.88 ± 3.7% | not timed | not timed | 140.07 ± 0.6% | 665.86 ± 26.2% | not timed | not timed | 381.70 ± 3.5% | | 0.97 | 2.65 | 0.56 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 52.36 ± 3.8% | not timed | not timed | 5.55 ± 0.9% | 45.64 ± 8.2% | not timed | not timed | 54.04 ± 6.1% | | 0.97 | 9.44 | 1.15 |
| unicode/compile/one-letter | 53 | 6.97 ± 13.7% | not timed | not timed | 5.66 ± 1.4% | 61.06 ± 12.1% | not timed | not timed | 6.91 ± 6.9% | | 1.01 | 1.23 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.22 ± 17.8% | not timed | not timed | 0.12 ± 1.6% | 64.12 ± 5.5% | not timed | not timed | 1.22 ± 21.7% | | 1.00 | 9.88 | 0.0191 |
| unicode/compile/fifty-letters-ascii | 1 | 194.73 ± 6.9% | not timed | not timed | 69.07 ± 2.7% | 211.69 ± 17.5% | not timed | not timed | 206.66 ± 10.8% | | 0.94 | 2.82 | 0.92 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 440.97 ± 5.5% | not timed | not timed | 51.39 ± 0.5% | 736.07 ± 12.0% | not timed | not timed | 450.75 ± 18.0% | | 0.98 | 8.58 | 0.60 |
| unicode/compile/match-every-line-ascii | 4 | 684.09 ± 2.3% | not timed | not timed | 168.92 ± 12.9% | 742.61 ± 6.5% | not timed | not timed | 708.42 ± 3.5% | | 0.97 | 4.05 | 0.92 |
| unicode/compile/negated-class-matches-codepoint | 1 | 359.85 ± 3.3% | not timed | not timed | 55.87 ± 0.5% | 1303.43 ± 24.7% | not timed | not timed | 368.06 ± 3.0% | | 0.98 | 6.44 | 0.28 |
| wild/bibleref/compile | 3 | 6.19 ± 2.3% | not timed | not timed | 2.43 ± 1.1% | 33.68 ± 6.1% | not timed | not timed | 6.19 ± 2.2% | | 1.00 | 2.55 | 0.18 |
| wild/url/compile | 1 | 0.72 ± 0.6% | not timed | not timed | 0.20 ± 0.9% | 0.48 ± 36.9% | not timed | not timed | 0.73 ± 20.9% | | 1.00 | 3.55 | 1.51 |

