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
| Run URL | https://github.com/c4milo/stdx/actions/runs/45391480100 |
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
| literal: a word | 217 | 19642.96 ± 2.1% | 5035.35 ± 0.4% | 28.10 ± 0.2% | 18300.31 ± 1.5% | 9271.25 ± 7.5% | 17.31 ± 0.8% | 84.13 ± 0.3% | 19693.87 ± 3.0% | 3.90 | 1.00 | 1.07 | 2.12 |
| literal: a word that is not there | 0 | 21625.10 ± 5.7% | 4923.96 ± 1.2% | 28.24 ± 0.6% | 19763.65 ± 0.7% | 29233.39 ± 1.6% | 17.13 ± 0.2% | 79.42 ± 0.1% | 21559.44 ± 1.7% | 4.39 | 1.00 | 1.09 | 0.74 |
| literal: one of four words | 661 | 6357.52 ± 0.1% | 1948.48 ± 0.2% | 14.36 ± 0.2% | 3940.37 ± 0.3% | 21.88 ± 0.1% | 5.35 ± 0.2% | 6.88 ± 0.5% | 6360.00 ± 0.4% | 3.26 | 1.00 | 1.61 | 290.50 |
| literal: a word in any case | 217 | 15095.10 ± 0.7% | 2086.39 ± 0.2% | 21.33 ± 0.3% | 3970.37 ± 0.2% | 37.98 ± 0.4% | refused | differs | 15159.76 ± 1.2% | 7.24 | 1.00 | 3.80 | 397.48 |
| literal: an href attribute | 33 | 16725.22 ± 2.0% | 609.27 ± 0.3% | 27.17 ± 0.3% | 17074.06 ± 2.5% | 2259.37 ± 0.6% | 13.14 ± 0.3% | 73.96 ± 0.2% | 16949.44 ± 1.9% | 27.45 | 0.99 | 0.98 | 7.40 |
| literal: a word, second text | 123 | 19905.95 ± 1.5% | 3387.88 ± 0.4% | 27.72 ± 0.5% | 18291.33 ± 1.1% | 7676.59 ± 9.9% | 20.15 ± 0.3% | 69.91 ± 0.4% | 19880.51 ± 1.2% | 5.88 | 1.00 | 1.09 | 2.59 |
| class: two capitalized words | 1331 | 1070.34 ± 0.4% | 598.35 ± 0.2% | 26.02 ± 0.2% | 584.92 ± 0.1% | 40.59 ± 2.5% | 14.75 ± 0.4% | 67.50 ± 0.3% | 1070.63 ± 1.5% | 1.79 | 1.00 | 1.83 | 26.37 |
| class: a word that ends in ing | 3399 | 573.17 ± 0.1% | 573.09 ± 0.2% | 17.97 ± 0.2% | 547.57 ± 0.2% | 29.61 ± 2.4% | 8.16 ± 0.1% | 18.42 ± 0.6% | 573.98 ± 0.2% | 1.00 | 1.00 | 1.05 | 19.35 |
| class: a word in capitals | 2332 | 1376.09 ± 0.3% | 604.24 ± 0.1% | 27.57 ± 0.4% | 572.38 ± 0.1% | 43.51 ± 13.2% | 17.21 ± 0.3% | 82.57 ± 0.1% | 1377.76 ± 0.5% | 2.28 | 1.00 | 2.40 | 31.63 |
| class: a number | 8288 | 1998.56 ± 0.3% | 828.22 ± 0.3% | 27.51 ± 0.3% | 1730.74 ± 0.3% | 43.14 ± 13.7% | 0.55 ± 0.1% | 57.32 ± 0.2% | 1998.79 ± 0.3% | 2.41 | 1.00 | 1.15 | 46.33 |
| class: two capitalized words, second text | 5359 | 516.20 ± 0.3% | 521.48 ± 0.3% | 23.33 ± 0.1% | 485.27 ± 0.1% | 35.44 ± 6.9% | 17.11 ± 0.3% | 62.89 ± 0.3% | 516.62 ± 0.3% | 0.99 | 1.00 | 1.06 | 14.57 |
| other: a word between two words | 6104 | 788.81 ± 0.3% | 592.45 ± 0.1% | 23.50 ± 0.1% | 736.89 ± 0.3% | 107.14 ± 10.1% | 11.19 ± 0.2% | 68.12 ± 0.5% | 788.17 ± 0.1% | 1.33 | 1.00 | 1.07 | 7.36 |
| other: a number before a unit, second text | 1481 | 5954.14 ± 0.9% | 1119.66 ± 0.1% | 25.92 ± 0.3% | 5657.34 ± 0.5% | 40.78 ± 9.8% | 18.20 ± 0.2% | 65.79 ± 0.2% | 5964.48 ± 1.4% | 5.32 | 1.00 | 1.05 | 146.01 |
| other: a heading's start tag | 110 | 14084.12 ± 1.4% | 743.56 ± 0.2% | 27.27 ± 0.2% | 1710.12 ± 0.3% | 1573.40 ± 5.8% | 16.06 ± 0.5% | 86.14 ± 0.1% | 14114.68 ± 1.3% | 18.94 | 1.00 | 8.24 | 8.95 |
| other: a whole word | 217 | 15936.91 ± 2.5% | 602.36 ± 0.8% | 29.25 ± 0.3% | 14690.02 ± 0.9% | 49.29 ± 0.5% | 13.25 ± 0.2% | 54.98 ± 0.2% | 15894.37 ± 1.3% | 26.46 | 1.00 | 1.08 | 323.30 |
| other: a line's first word, second text | 3716 | 2045.04 ± 0.3% | 587.80 ± 0.4% | 30.97 ± 0.4% | 1725.81 ± 0.7% | 62.95 ± 7.2% | refused | refused | 2049.64 ± 0.7% | 3.48 | 1.00 | 1.18 | 32.48 |
| other: fourteen octets before an x | 87 | 24093.86 ± 1.1% | 250.02 ± 0.5% | 6.31 ± 0.1% | 4045.38 ± 1.4% | 10.65 ± 0.2% | differs | 17.76 ± 0.1% | 24013.50 ± 4.3% | 96.37 | 1.00 | 5.96 | 2263.29 |
| other: a Greek word | 21815 | 496.85 ± 0.2% | 412.03 ± 0.1% | 30.61 ± 0.4% | 289.69 ± 0.7% | 50.59 ± 10.2% | differs | refused | 501.47 ± 1.0% | 1.21 | 0.99 | 1.72 | 9.82 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 19.61 ± 0.2% | 19.55 ± 0.3% | 0.85 ± 0.3% | 19.84 ± 0.2% | 2.76 ± 0.4% | differs | 4.07 ± 0.1% | 19.54 ± 0.2% | 1.00 | 1.00 | 0.99 | 7.10 |
| a UUID | 32895 | 21.12 ± 0.3% | 21.11 ± 0.2% | 0.64 ± 0.1% | 15.05 ± 0.5% | 3.09 ± 0.4% | 0.70 ± 0.1% | 3.65 ± 0.6% | 21.09 ± 0.3% | 1.00 | 1.00 | 1.40 | 6.84 |
| an IPv4 address | 33176 | 35.95 ± 0.3% | 35.94 ± 0.3% | 2.05 ± 0.1% | 29.30 ± 0.2% | 6.66 ± 0.2% | differs | 4.17 ± 0.9% | 35.94 ± 0.1% | 1.00 | 1.00 | 1.23 | 5.40 |
| a date and time | 32954 | 31.02 ± 0.4% | 30.45 ± 0.3% | 1.43 ± 0.2% | 21.48 ± 0.3% | 7.04 ± 0.5% | 1.19 ± 0.1% | 7.15 ± 0.5% | 31.08 ± 0.4% | 1.02 | 1.00 | 1.44 | 4.41 |
| a field path | 32606 | 23.19 ± 0.4% | 23.14 ± 0.2% | 1.01 ± 0.4% | 23.23 ± 0.2% | 3.48 ± 0.6% | differs | 2.99 ± 0.2% | 23.13 ± 0.2% | 1.00 | 1.00 | 1.00 | 6.67 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.15 ± 4.5% | 11.19 ± 0.5% | 11.14 ± 1.1% | 11.52 ± 0.2% | 4.93 ± 1.1% | 0.91 ± 0.4% | none | 11.15 ± 1.2% | 1.00 | 1.00 | 0.97 | 2.26 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 231.44 ± 0.2% | 232.38 ± 0.1% | 274.37 ± 0.1% | 87.34 ± 1.1% | 217.00 ± 1.4% | 489.64 ± 3.0% | 3787.32 ± 0.8% | 231.48 ± 0.3% | 1.00 | 1.00 | 2.65 | 1.07 |
| a UUID | 62 | 152.80 ± 0.2% | 153.18 ± 0.4% | 170.53 ± 0.3% | 46.31 ± 0.9% | 97.23 ± 1.7% | 191.08 ± 1.8% | 4164.03 ± 0.4% | 152.88 ± 0.2% | 1.00 | 1.00 | 3.30 | 1.57 |
| an IPv4 address | 29 | 427.65 ± 0.4% | 431.42 ± 0.4% | 599.21 ± 0.2% | 77.86 ± 0.3% | 129.17 ± 1.0% | 301.28 ± 0.8% | 7432.74 ± 0.7% | 427.15 ± 0.4% | 0.99 | 1.00 | 5.49 | 3.31 |
| a date and time | 56 | 307.15 ± 0.2% | 309.95 ± 0.1% | 387.61 ± 0.2% | 73.93 ± 0.6% | 134.54 ± 1.1% | 328.95 ± 1.0% | 4788.92 ± 0.1% | 307.17 ± 0.2% | 0.99 | 1.00 | 4.15 | 2.28 |
| a field path | 39 | 224.89 ± 0.3% | 226.70 ± 0.1% | 265.53 ± 0.3% | 80.97 ± 1.8% | 200.58 ± 2.0% | 495.63 ± 1.2% | 4828.83 ± 1.1% | 225.37 ± 0.4% | 0.99 | 1.00 | 2.78 | 1.12 |
| literal: a word | 7 | 634.26 ± 0.4% | 686.81 ± 0.4% | 1229.68 ± 0.3% | 503.18 ± 0.8% | 621.66 ± 1.4% | 944.19 ± 0.5% | 29956.79 ± 0.1% | 635.15 ± 0.4% | 0.92 | 1.00 | 1.26 | 1.02 |
| literal: a word that is not there | 8 | 609.91 ± 0.6% | 662.45 ± 0.5% | 1159.01 ± 0.5% | 463.26 ± 0.3% | 595.63 ± 2.9% | 894.71 ± 0.5% | 28479.97 ± 0.2% | 610.38 ± 0.4% | 0.92 | 1.00 | 1.32 | 1.02 |
| literal: one of four words | 26 | 245.95 ± 0.2% | 397.48 ± 0.6% | 541.59 ± 0.4% | 50.25 ± 0.3% | 237.99 ± 9.8% | 379.27 ± 1.5% | 15922.36 ± 0.5% | 245.95 ± 0.3% | 0.62 | 1.00 | 4.89 | 1.03 |
| literal: a word in any case | 11 | 453.96 ± 0.1% | 486.42 ± 0.4% | 715.94 ± 0.1% | 15.63 ± 0.4% | 640.93 ± 1.5% | refused | 23293.87 ± 0.2% | 453.90 ± 0.2% | 0.93 | 1.00 | 29.05 | 0.71 |
| literal: an href attribute | 12 | 347.00 ± 0.3% | 359.23 ± 0.4% | 469.11 ± 0.3% | 45.52 ± 0.5% | 495.76 ± 1.5% | 777.28 ± 0.4% | 21682.46 ± 0.4% | 346.91 ± 0.5% | 0.97 | 1.00 | 7.62 | 0.70 |
| literal: a word, second text | 10 | 564.63 ± 0.5% | 623.83 ± 0.4% | 1046.12 ± 0.7% | 416.03 ± 0.3% | 528.64 ± 2.3% | 813.20 ± 0.4% | 26586.75 ± 0.4% | 564.24 ± 0.5% | 0.91 | 1.00 | 1.36 | 1.07 |
| class: two capitalized words | 23 | 438.82 ± 0.3% | 470.30 ± 0.4% | 674.19 ± 0.3% | 102.53 ± 0.2% | 497.86 ± 2.2% | 780.00 ± 0.4% | 6452.82 ± 0.5% | 439.02 ± 0.5% | 0.93 | 1.00 | 4.28 | 0.88 |
| class: a word that ends in ing | 9 | 569.33 ± 0.5% | 636.96 ± 0.2% | 1114.59 ± 0.2% | 133.90 ± 0.8% | 747.89 ± 1.3% | 1129.77 ± 0.6% | 15724.07 ± 0.7% | 569.62 ± 0.2% | 0.89 | 1.00 | 4.25 | 0.76 |
| class: a word in capitals | 16 | 495.50 ± 0.2% | 538.65 ± 0.3% | 850.00 ± 0.3% | 137.01 ± 0.7% | 750.08 ± 2.0% | 1010.35 ± 1.9% | 8497.21 ± 0.3% | 495.68 ± 0.1% | 0.92 | 1.00 | 3.62 | 0.66 |
| class: a number | 6 | 632.48 ± 0.3% | 695.28 ± 0.5% | 1298.29 ± 0.1% | 42.56 ± 0.7% | 1408.96 ± 1.1% | 1907.23 ± 1.5% | 22655.64 ± 0.1% | 633.11 ± 0.4% | 0.91 | 1.00 | 14.86 | 0.45 |
| class: two capitalized words, second text | 23 | 438.48 ± 0.2% | 469.96 ± 0.3% | 672.63 ± 0.3% | 103.52 ± 2.4% | 497.59 ± 2.1% | 756.93 ± 1.2% | 6437.13 ± 0.4% | 438.54 ± 0.2% | 0.93 | 1.00 | 4.24 | 0.88 |
| other: a word between two words | 13 | 549.72 ± 0.4% | 570.17 ± 0.2% | 904.13 ± 0.2% | 136.10 ± 1.9% | 498.54 ± 1.3% | 793.26 ± 1.0% | 14423.95 ± 0.2% | 550.93 ± 0.6% | 0.96 | 1.00 | 4.04 | 1.10 |
| other: a number before a unit, second text | 15 | 403.04 ± 1.1% | 442.40 ± 0.2% | 619.98 ± 0.2% | 39.99 ± 0.4% | 629.09 ± 1.5% | 882.11 ± 3.1% | 15117.22 ± 1.0% | 402.52 ± 0.3% | 0.91 | 1.00 | 10.08 | 0.64 |
| other: a heading's start tag | 13 | 358.60 ± 0.3% | 365.67 ± 0.4% | 479.08 ± 0.3% | 43.59 ± 0.2% | 623.11 ± 1.4% | 857.06 ± 0.2% | 17944.83 ± 0.3% | 358.93 ± 0.3% | 0.98 | 1.00 | 8.23 | 0.58 |
| other: a whole word | 11 | 581.66 ± 0.8% | 620.63 ± 0.4% | 1040.75 ± 0.4% | 119.76 ± 1.4% | 560.96 ± 1.7% | 817.21 ± 0.5% | 26672.00 ± 0.5% | 582.59 ± 0.5% | 0.94 | 1.00 | 4.86 | 1.04 |
| other: a line's first word, second text | 17 | 530.75 ± 0.4% | 556.55 ± 0.5% | 890.24 ± 0.3% | 128.90 ± 0.3% | 707.19 ± 2.8% | refused | refused | 532.32 ± 0.5% | 0.95 | 1.00 | 4.12 | 0.75 |
| other: fourteen octets before an x | 16 | 110.00 ± 0.2% | 157.92 ± 0.5% | 180.38 ± 0.9% | 15.21 ± 0.4% | 453.53 ± 1.3% | 415.08 ± 0.4% | 12774.39 ± 0.3% | 109.85 ± 0.7% | 0.70 | 1.00 | 7.23 | 0.24 |
| other: a Greek word | 8 | 454.41 ± 0.2% | 604.13 ± 0.2% | 1014.33 ± 0.1% | 58.55 ± 0.5% | 1380.83 ± 0.7% | 1789.76 ± 0.6% | refused | 454.59 ± 0.3% | 0.75 | 1.00 | 7.76 | 0.33 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15842.53 ± 1.3% | not timed | not timed | 16347.83 ± 1.3% | 2044.51 ± 14.2% | not timed | not timed | 15806.57 ± 0.5% | | 1.00 | 0.97 | 7.75 |
| 01-literal/sherlock-casei-en | 522 | 11099.46 ± 6.8% | not timed | not timed | 3585.04 ± 0.2% | 32.55 ± 0.2% | not timed | not timed | 11097.06 ± 1.7% | | 1.00 | 3.10 | 341.03 |
| 01-literal/sherlock-ru | 724 | 17084.29 ± 1.2% | not timed | not timed | 17312.10 ± 0.6% | 1554.81 ± 19.6% | not timed | not timed | 17159.04 ± 0.3% | | 1.00 | 0.99 | 10.99 |
| 01-literal/sherlock-casei-ru | 746 | 6188.29 ± 0.2% | not timed | not timed | 3324.97 ± 0.3% | 30.78 ± 0.3% | not timed | not timed | 6183.81 ± 0.2% | | 1.00 | 1.86 | 201.04 |
| 01-literal/sherlock-zh | 30 | 19880.63 ± 0.9% | not timed | not timed | 18846.20 ± 1.6% | 2627.44 ± 13.3% | not timed | not timed | 19940.64 ± 1.2% | | 1.00 | 1.05 | 7.57 |
| 02-literal-alternate/sherlock-en | 714 | 6046.33 ± 0.4% | not timed | not timed | 3940.45 ± 0.2% | 16.61 ± 0.3% | not timed | not timed | 6050.55 ± 0.1% | | 1.00 | 1.53 | 363.92 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1977.38 ± 1.3% | not timed | not timed | 698.09 ± 0.2% | 11.10 ± 0.2% | not timed | not timed | 1988.85 ± 1.0% | | 0.99 | 2.83 | 178.13 |
| 02-literal-alternate/sherlock-ru | 899 | 5573.11 ± 0.1% | not timed | not timed | 3260.04 ± 0.2% | 22.61 ± 0.2% | not timed | not timed | 5571.18 ± 0.3% | | 1.00 | 1.71 | 246.49 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2062.17 ± 0.5% | not timed | not timed | 1234.68 ± 0.3% | 9.11 ± 0.1% | not timed | not timed | 2058.78 ± 0.7% | | 1.00 | 1.67 | 226.42 |
| 02-literal-alternate/sherlock-zh | 207 | 7307.85 ± 0.2% | not timed | not timed | 4165.34 ± 0.2% | 31.53 ± 0.2% | not timed | not timed | 7305.11 ± 0.4% | | 1.00 | 1.75 | 231.76 |
| 03-date/ascii | 111817 | 123.83 ± 0.6% | not timed | not timed | 95.51 ± 0.2% | 0.20 ± 6.8% | not timed | not timed | 124.59 ± 0.7% | | 0.99 | 1.30 | 611.67 |
| 04-ruff-noqa/real | 84 | 404.06 ± 0.1% | not timed | not timed | 476.72 ± 0.1% | 19.56 ± 1.5% | not timed | not timed | 403.48 ± 0.1% | | 1.00 | 0.85 | 20.66 |
| 04-ruff-noqa/tweaked | 44 | 555.49 ± 0.4% | not timed | not timed | 464.85 ± 0.2% | 366.52 ± 0.3% | not timed | not timed | 555.19 ± 0.8% | | 1.00 | 1.20 | 1.52 |
| 05-lexer-veryl/single | 124800 | 5.50 ± 1.1% | not timed | not timed | 5.15 ± 0.2% | 0.20 ± 2.9% | not timed | not timed | 5.41 ± 0.5% | | 1.02 | 1.07 | 26.99 |
| 06-cloud-flare-redos/original | 107 | 415.04 ± 0.2% | not timed | not timed | 217.00 ± 0.0% | 24.80 ± 0.1% | not timed | not timed | 415.73 ± 0.2% | | 1.00 | 1.91 | 16.74 |
| 06-cloud-flare-redos/simplified-short | 102 | 415.44 ± 0.2% | not timed | not timed | 226.56 ± 0.1% | 26.69 ± 0.4% | not timed | not timed | 410.00 ± 0.2% | | 1.01 | 1.83 | 15.56 |
| 06-cloud-flare-redos/simplified-long | 10000 | 587.94 ± 0.2% | not timed | not timed | 255.45 ± 0.1% | 28.82 ± 0.1% | not timed | not timed | 578.30 ± 0.2% | | 1.02 | 2.30 | 20.40 |
| 07-unicode-character-data/parse-line | 558784 | 237.48 ± 1.1% | not timed | not timed | 180.04 ± 0.1% | 42.67 ± 6.3% | not timed | not timed | 238.34 ± 2.9% | | 1.00 | 1.32 | 5.57 |
| 08-words/all-english | 56691 | 116.51 ± 0.8% | not timed | not timed | 82.59 ± 0.1% | 11.83 ± 4.5% | not timed | not timed | 117.11 ± 0.4% | | 0.99 | 1.41 | 9.85 |
| 08-words/long-english | 839 | 613.20 ± 0.4% | not timed | not timed | 594.00 ± 0.2% | 32.32 ± 9.7% | not timed | not timed | 613.32 ± 0.4% | | 1.00 | 1.03 | 18.97 |
| 09-aws-keys/full | 0 | 408.19 ± 0.1% | not timed | not timed | 478.54 ± 0.2% | 64.53 ± 0.2% | not timed | not timed | 408.95 ± 0.2% | | 1.00 | 0.85 | 6.33 |
| 09-aws-keys/quick | 0 | 872.30 ± 0.2% | not timed | not timed | 998.20 ± 0.5% | 420.28 ± 0.7% | not timed | not timed | 873.02 ± 0.3% | | 1.00 | 0.87 | 2.08 |
| 10-bounded-repeat/letters-en | 1833 | 582.53 ± 1.2% | not timed | not timed | 514.30 ± 0.4% | 19.47 ± 0.7% | not timed | not timed | 580.80 ± 2.1% | | 1.00 | 1.13 | 29.92 |
| 10-bounded-repeat/letters-ru | 3475 | 509.38 ± 1.3% | not timed | not timed | 479.43 ± 0.1% | 22.17 ± 18.0% | not timed | not timed | 510.62 ± 0.4% | | 1.00 | 1.06 | 22.97 |
| 10-bounded-repeat/context | 53 | 83.99 ± 1.7% | not timed | not timed | 66.06 ± 0.2% | 19.77 ± 0.3% | not timed | not timed | 85.55 ± 1.6% | | 0.98 | 1.27 | 4.25 |
| 10-bounded-repeat/capitals | 11 | 641.80 ± 8.5% | not timed | not timed | 615.58 ± 0.1% | 36.57 ± 0.1% | not timed | not timed | 640.45 ± 8.1% | | 1.00 | 1.04 | 17.55 |
| 11-unstructured-to-json/extract | 600 | 56.53 ± 1.1% | not timed | not timed | 77.01 ± 0.1% | 48.94 ± 1.1% | not timed | not timed | 56.77 ± 0.7% | | 1.00 | 0.73 | 1.16 |
| 12-dictionary/single | 1 | 567.22 ± 0.0% | not timed | not timed | 562.06 ± 0.1% | 0.40 ± 0.1% | not timed | not timed | 568.76 ± 0.4% | | 1.00 | 1.01 | 1405.72 |
| 14-quadratic/1x | 100 | 21.21 ± 1.2% | not timed | not timed | 9.99 ± 0.2% | 0.96 ± 2.8% | not timed | not timed | 21.21 ± 1.3% | | 1.00 | 2.12 | 22.04 |
| 14-quadratic/2x | 200 | 17.46 ± 1.0% | not timed | not timed | 5.55 ± 0.2% | 0.53 ± 1.0% | not timed | not timed | 17.41 ± 1.2% | | 1.00 | 3.15 | 32.79 |
| 14-quadratic/10x | 1000 | 7.69 ± 0.5% | not timed | not timed | 1.21 ± 0.1% | 0.12 ± 1.9% | not timed | not timed | 7.70 ± 0.6% | | 1.00 | 6.34 | 66.67 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 2.0% | not timed | not timed | 0.34 ± 0.7% | 0.55 ± 3.8% | not timed | not timed | 1.27 ± 1.6% | | 1.00 | 3.68 | 2.31 |
| 04-ruff-noqa/compile-real | 1 | 107.00 ± 0.7% | not timed | not timed | 13.90 ± 0.5% | 138.96 ± 1.3% | not timed | not timed | 106.98 ± 1.6% | | 1.00 | 7.70 | 0.77 |
| 05-lexer-veryl/compile-single | 1 | 14.07 ± 1.7% | not timed | not timed | 2.55 ± 0.7% | 6.41 ± 1.6% | not timed | not timed | 14.14 ± 1.3% | | 1.00 | 5.52 | 2.19 |
| 07-unicode-character-data/compile | 1 | 109.84 ± 0.6% | not timed | not timed | 26.22 ± 0.4% | 35.83 ± 1.1% | not timed | not timed | 110.07 ± 0.4% | | 1.00 | 4.19 | 3.07 |
| 09-aws-keys/compile-full | 1 | 53.67 ± 0.3% | not timed | not timed | 8.38 ± 0.5% | 23.17 ± 1.5% | not timed | not timed | 53.60 ± 0.2% | | 1.00 | 6.40 | 2.32 |
| 09-aws-keys/compile-quick | 1 | 189.62 ± 0.4% | not timed | not timed | 47.91 ± 0.2% | 131.80 ± 2.3% | not timed | not timed | 189.81 ± 0.4% | | 1.00 | 3.96 | 1.44 |
| 10-bounded-repeat/compile-context | 1 | 72.92 ± 0.6% | not timed | not timed | 11.02 ± 0.9% | 15.74 ± 3.9% | not timed | not timed | 73.09 ± 0.7% | | 1.00 | 6.62 | 4.63 |
| 10-bounded-repeat/compile-capitals | 1 | 84.42 ± 1.1% | not timed | not timed | 7.96 ± 0.3% | 23.67 ± 2.0% | not timed | not timed | 85.40 ± 0.9% | | 0.99 | 10.61 | 3.57 |
| 11-unstructured-to-json/compile | 1 | 174.02 ± 0.9% | not timed | not timed | 41.17 ± 0.2% | 67.25 ± 4.1% | not timed | not timed | 174.37 ± 0.9% | | 1.00 | 4.23 | 2.59 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.1% | not timed | not timed | 0.07 ± 35.3% | 0.10 ± 6.8% | not timed | not timed | 0.35 ± 1.4% | | 1.00 | 5.21 | 3.64 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.60 ± 1.0% | not timed | not timed | 6.53 ± 0.3% | 0.56 ± 9.4% | not timed | not timed | 7.63 ± 0.4% | | 1.00 | 1.16 | 13.53 |
| dictionary/search/english-10 | 690 | 1.05 ± 1.0% | not timed | not timed | 164.56 ± 1.0% | 0.00 ± 0.8% | not timed | not timed | 1.05 ± 0.5% | | 1.00 | 0.0064 | 400.71 |
| dictionary/search/english-15 | 15 | 559.17 ± 0.4% | not timed | not timed | 554.39 ± 0.9% | 0.36 ± 0.5% | not timed | not timed | 561.53 ± 0.5% | | 1.00 | 1.01 | 1547.56 |
| folly/awyer-inn-busted | 1 | 5582.59 ± 0.3% | not timed | not timed | 143.23 ± 0.1% | 43.73 ± 0.2% | not timed | not timed | 5570.13 ± 0.1% | | 1.00 | 38.98 | 127.66 |
| folly/literal-never-match-rare | 0 | 21078.34 ± 0.5% | not timed | not timed | 19864.85 ± 0.4% | 40800.46 ± 0.5% | not timed | not timed | 21085.11 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12496.88 ± 0.8% | not timed | not timed | 19760.77 ± 0.6% | 2178.81 ± 0.6% | not timed | not timed | 12522.12 ± 0.8% | | 1.00 | 0.63 | 5.74 |
| folly/literal-never-match-tricksy | 1 | 3244.61 ± 0.3% | not timed | not timed | 4413.71 ± 0.1% | 3022.52 ± 0.8% | not timed | not timed | 3250.11 ± 0.3% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1307.19 ± 0.7% | not timed | not timed | 956.95 ± 0.7% | 384.75 ± 19.4% | not timed | not timed | 1310.55 ± 2.0% | | 1.00 | 1.37 | 3.40 |
| grep/long-words-ascii | 5073 | 459.72 ± 0.1% | not timed | not timed | 468.01 ± 0.1% | 46.17 ± 8.3% | not timed | not timed | 456.28 ± 0.3% | | 1.01 | 0.98 | 9.96 |
| imported/leipzig/twain | 811 | 20481.06 ± 2.2% | not timed | not timed | 19338.78 ± 1.6% | 11765.06 ± 10.2% | not timed | not timed | 20462.06 ± 2.0% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 9036.22 ± 1.1% | not timed | not timed | 4241.25 ± 0.3% | 37.64 ± 0.4% | not timed | not timed | 9072.31 ± 1.2% | | 1.00 | 2.13 | 240.06 |
| imported/leipzig/shing | 1540 | 629.43 ± 0.1% | not timed | not timed | 13111.40 ± 1.8% | 34.07 ± 0.5% | not timed | not timed | 631.59 ± 0.1% | | 1.00 | 0.0480 | 18.48 |
| imported/leipzig/huck-saw | 262 | 8210.17 ± 3.2% | not timed | not timed | 5589.30 ± 0.1% | 31.96 ± 0.2% | not timed | not timed | 8353.62 ± 3.2% | | 0.98 | 1.47 | 256.90 |
| imported/leipzig/word-ending-nn | 262 | 608.13 ± 0.3% | not timed | not timed | 615.63 ± 0.4% | 24.57 ± 0.5% | not timed | not timed | 610.80 ± 0.1% | | 1.00 | 0.99 | 24.75 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10996.10 ± 1.2% | not timed | not timed | 4497.30 ± 0.6% | 11.50 ± 0.1% | not timed | not timed | 11034.12 ± 1.2% | | 1.00 | 2.45 | 956.60 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7717.88 ± 1.0% | not timed | not timed | 5458.37 ± 1.1% | 16.81 ± 0.1% | not timed | not timed | 7797.90 ± 1.3% | | 0.99 | 1.41 | 459.07 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4179.89 ± 0.8% | not timed | not timed | 415.89 ± 1.4% | 11.10 ± 0.1% | not timed | not timed | 4174.11 ± 1.5% | | 1.00 | 10.05 | 376.52 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 608.89 ± 0.3% | not timed | not timed | 615.51 ± 0.1% | 11.14 ± 0.1% | not timed | not timed | 609.33 ± 0.2% | | 1.00 | 0.99 | 54.67 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 609.73 ± 0.1% | not timed | not timed | 615.33 ± 0.1% | 9.39 ± 0.1% | not timed | not timed | 610.10 ± 0.2% | | 1.00 | 0.99 | 64.94 |
| imported/leipzig/tom-river | 2 | 6450.47 ± 2.0% | not timed | not timed | 5129.66 ± 0.7% | 30.83 ± 0.2% | not timed | not timed | 6519.19 ± 2.2% | | 0.99 | 1.26 | 209.20 |
| imported/leipzig/ing | 78424 | 608.94 ± 0.6% | not timed | not timed | 570.62 ± 0.2% | 28.10 ± 3.9% | not timed | not timed | 607.68 ± 0.7% | | 1.00 | 1.07 | 21.67 |
| imported/leipzig/ing-whitespace | 55248 | 757.07 ± 0.8% | not timed | not timed | 2064.05 ± 0.8% | 20.53 ± 2.9% | not timed | not timed | 757.88 ± 0.1% | | 1.00 | 0.37 | 36.87 |
| imported/leipzig/awyer-inn | 209 | 773.11 ± 1.5% | not timed | not timed | 4221.28 ± 0.9% | 22.67 ± 0.1% | not timed | not timed | 774.36 ± 1.3% | | 1.00 | 0.18 | 34.10 |
| imported/leipzig/quotes-bounded | 8886 | 2101.16 ± 0.9% | not timed | not timed | 2961.45 ± 0.7% | 38.24 ± 0.1% | not timed | not timed | 2110.79 ± 0.6% | | 1.00 | 0.71 | 54.94 |
| imported/leipzig/non-ascii-alternate | 2 | 12654.55 ± 2.7% | not timed | not timed | 5632.45 ± 1.3% | 50.76 ± 0.1% | not timed | not timed | 12872.21 ± 1.8% | | 0.98 | 2.25 | 249.31 |
| imported/leipzig/math-symbols | 69 | 1973.74 ± 0.4% | not timed | not timed | 619.11 ± 0.0% | 36.42 ± 0.2% | not timed | not timed | 1973.56 ± 0.5% | | 1.00 | 3.19 | 54.19 |
| imported/leipzig/bounded-strings-ending-z | 0 | 595.53 ± 0.3% | not timed | not timed | 615.00 ± 0.1% | 22.56 ± 0.1% | not timed | not timed | 592.65 ± 0.3% | | 1.00 | 0.97 | 26.40 |
| imported/lh3lh3-reb/uri | 17549 | 633.09 ± 0.1% | not timed | not timed | 1072.54 ± 0.2% | 27.93 ± 2.1% | not timed | not timed | 633.39 ± 0.3% | | 1.00 | 0.59 | 22.67 |
| imported/lh3lh3-reb/email | 15057 | 667.77 ± 0.2% | not timed | not timed | 1169.18 ± 0.2% | 30.87 ± 2.3% | not timed | not timed | 669.51 ± 0.2% | | 1.00 | 0.57 | 21.63 |
| imported/lh3lh3-reb/date | 668 | 865.68 ± 0.2% | not timed | not timed | 1042.34 ± 0.3% | 51.32 ± 3.8% | not timed | not timed | 866.19 ± 0.2% | | 1.00 | 0.83 | 16.87 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 642.53 ± 0.2% | not timed | not timed | 421.90 ± 0.1% | 15.82 ± 1.5% | not timed | not timed | 643.18 ± 0.2% | | 1.00 | 1.52 | 40.61 |
| imported/mariomka/email | 92 | 705.06 ± 0.2% | not timed | not timed | 29410.31 ± 1.5% | 32.46 ± 0.2% | not timed | not timed | 705.95 ± 0.1% | | 1.00 | 0.0240 | 21.72 |
| imported/mariomka/uri | 5301 | 608.07 ± 0.2% | not timed | not timed | 6082.33 ± 0.4% | 32.48 ± 0.5% | not timed | not timed | 605.51 ± 0.3% | | 1.00 | 0.1000 | 18.72 |
| imported/mariomka/ip | 5 | 2150.69 ± 2.0% | not timed | not timed | 2968.66 ± 0.3% | 20.88 ± 0.4% | not timed | not timed | 2153.05 ± 2.3% | | 1.00 | 0.72 | 103.02 |
| imported/rsc/no-exponential | 0 | 564.34 ± 0.4% | not timed | not timed | 318.88 ± 0.0% | 23.86 ± 0.0% | not timed | not timed | 564.74 ± 0.0% | | 1.00 | 1.77 | 23.65 |
| imported/rsc/literal | 1 | 752.46 ± 2.3% | not timed | not timed | 1623.40 ± 1.4% | 187.62 ± 18.5% | not timed | not timed | 750.05 ± 5.2% | | 1.00 | 0.46 | 4.01 |
| imported/rsc/not-literal | 2 | 707.31 ± 0.1% | not timed | not timed | 730.50 ± 0.4% | 46.49 ± 9.0% | not timed | not timed | 706.16 ± 2.1% | | 1.00 | 0.97 | 15.22 |
| imported/rsc/match-class | 1 | 1304.35 ± 8.4% | not timed | not timed | 1666.05 ± 0.2% | 58.74 ± 2.2% | not timed | not timed | 1305.21 ± 0.3% | | 1.00 | 0.78 | 22.20 |
| imported/rsc/match-class-in-range | 1 | 1312.35 ± 2.3% | not timed | not timed | 2376.22 ± 0.9% | 60.30 ± 6.4% | not timed | not timed | 1312.13 ± 0.3% | | 1.00 | 0.55 | 21.76 |
| imported/rsc/match-class-unicode | 1 | 524.73 ± 1.7% | not timed | not timed | 516.41 ± 0.0% | 72.64 ± 7.9% | not timed | not timed | 523.68 ± 0.1% | | 1.00 | 1.02 | 7.22 |
| imported/rsc/anchored-literal-short-non-match | 0 | 539.73 ± 0.3% | not timed | not timed | 940.53 ± 0.2% | 227.13 ± 0.3% | not timed | not timed | 536.24 ± 0.5% | | 1.01 | 0.57 | 2.38 |
| imported/rsc/anchored-literal-long-non-match | 0 | 7573.74 ± 0.1% | not timed | not timed | 14190.02 ± 0.3% | 3399.78 ± 0.4% | not timed | not timed | 7529.25 ± 0.2% | | 1.01 | 0.53 | 2.23 |
| imported/rsc/anchored-literal-short-match | 4 | 417.00 ± 2.1% | not timed | not timed | 485.69 ± 0.6% | 85.21 ± 8.2% | not timed | not timed | 419.59 ± 1.7% | | 0.99 | 0.86 | 4.89 |
| imported/rsc/anchored-literal-long-match | 4 | 2898.10 ± 2.3% | not timed | not timed | 7348.29 ± 0.2% | 1233.99 ± 9.2% | not timed | not timed | 2943.60 ± 2.1% | | 0.98 | 0.39 | 2.35 |
| imported/rsc/one-pass-short | 17 | 309.37 ± 2.8% | not timed | not timed | 215.35 ± 0.5% | 30.02 ± 14.2% | not timed | not timed | 309.70 ± 3.2% | | 1.00 | 1.44 | 10.31 |
| imported/rsc/one-pass-short-not | 17 | 219.66 ± 1.7% | not timed | not timed | 223.38 ± 0.2% | 29.07 ± 12.2% | not timed | not timed | 218.84 ± 1.9% | | 1.00 | 0.98 | 7.56 |
| imported/rsc/one-pass-long-prefix | 26 | 236.91 ± 10.6% | not timed | not timed | 283.97 ± 0.1% | 99.04 ± 12.6% | not timed | not timed | 240.21 ± 2.7% | | 0.99 | 0.83 | 2.39 |
| imported/rsc/one-pass-long-prefix-not | 26 | 310.42 ± 1.9% | not timed | not timed | 285.73 ± 0.3% | 63.54 ± 19.0% | not timed | not timed | 308.09 ± 2.0% | | 1.01 | 1.09 | 4.89 |
| imported/rsc/long-needle1 | 31 | 21908.59 ± 0.2% | not timed | not timed | 20159.73 ± 0.1% | 3.76 ± 0.1% | not timed | not timed | 21918.29 ± 0.1% | | 1.00 | 1.09 | 5825.24 |
| imported/rsc/long-needle2 | 31 | 22090.73 ± 0.1% | not timed | not timed | 216.27 ± 0.2% | 3.75 ± 0.1% | not timed | not timed | 22091.08 ± 0.1% | | 1.00 | 102.14 | 5883.54 |
| imported/rsc/easy0-32 | 26 | 1072.68 ± 2.9% | not timed | not timed | 1514.67 ± 0.2% | 148.37 ± 18.7% | not timed | not timed | 1071.56 ± 0.6% | | 1.00 | 0.71 | 7.23 |
| imported/rsc/easy0-1k | 26 | 15022.44 ± 2.5% | not timed | not timed | 12334.02 ± 0.3% | 2313.88 ± 17.0% | not timed | not timed | 15003.63 ± 0.1% | | 1.00 | 1.22 | 6.49 |
| imported/rsc/easy0-32k | 26 | 22895.04 ± 1.8% | not timed | not timed | 20393.21 ± 0.2% | 18807.31 ± 20.3% | not timed | not timed | 22897.55 ± 0.1% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 22030.22 ± 1.2% | not timed | not timed | 20043.37 ± 1.7% | 37741.72 ± 3.7% | not timed | not timed | 21917.11 ± 1.7% | | 1.01 | 1.10 | 0.58 |
| imported/rsc/easy1-32 | 19 | 360.17 ± 2.3% | not timed | not timed | 625.69 ± 0.1% | 123.30 ± 23.6% | not timed | not timed | 360.00 ± 0.1% | | 1.00 | 0.58 | 2.92 |
| imported/rsc/easy1-1k | 19 | 584.60 ± 3.2% | not timed | not timed | 12697.23 ± 0.1% | 2488.92 ± 17.0% | not timed | not timed | 582.11 ± 0.2% | | 1.00 | 0.0460 | 0.23 |
| imported/rsc/easy1-32k | 19 | 602.59 ± 0.5% | not timed | not timed | 399896.98 ± 0.8% | 20512.00 ± 0.1% | not timed | not timed | 600.50 ± 0.4% | | 1.00 | 0.0015 | 0.0294 |
| imported/rsc/easy1-1mb | 19 | 602.65 ± 0.4% | not timed | not timed | 12925317.27 ± 0.5% | 38857.91 ± 2.9% | not timed | not timed | 599.80 ± 0.5% | | 1.00 | 0.0000 | 0.0155 |
| imported/rsc/medium-32 | 27 | 430.12 ± 2.6% | not timed | not timed | 628.53 ± 0.1% | 70.05 ± 13.6% | not timed | not timed | 429.51 ± 0.2% | | 1.00 | 0.68 | 6.14 |
| imported/rsc/medium-1k | 27 | 6814.74 ± 0.2% | not timed | not timed | 11327.17 ± 0.6% | 72.34 ± 0.1% | not timed | not timed | 6795.88 ± 0.3% | | 1.00 | 0.60 | 94.20 |
| imported/rsc/medium-32k | 27 | 21636.58 ± 0.1% | not timed | not timed | 348344.81 ± 0.7% | 48.39 ± 0.3% | not timed | not timed | 21596.57 ± 0.1% | | 1.00 | 0.0621 | 447.16 |
| imported/rsc/medium-1mb | 27 | 21288.35 ± 2.1% | not timed | not timed | 11166960.89 ± 0.6% | 48.50 ± 0.2% | not timed | not timed | 21249.94 ± 1.1% | | 1.00 | 0.0019 | 438.90 |
| imported/rsc/hard-32 | 58 | 255.82 ± 2.4% | not timed | not timed | 363.98 ± 0.0% | 49.62 ± 7.9% | not timed | not timed | 254.41 ± 0.2% | | 1.01 | 0.70 | 5.16 |
| imported/rsc/hard-1k | 27 | 577.09 ± 0.7% | not timed | not timed | 11511.28 ± 0.1% | 40.79 ± 0.1% | not timed | not timed | 574.93 ± 0.2% | | 1.00 | 0.0501 | 14.15 |
| imported/rsc/hard-32k | 27 | 602.44 ± 0.2% | not timed | not timed | 358934.58 ± 0.2% | 29.35 ± 0.0% | not timed | not timed | 598.42 ± 0.4% | | 1.01 | 0.0017 | 20.53 |
| imported/rsc/hard-1mb | 51 | 603.21 ± 0.3% | not timed | not timed | 7272104.14 ± 0.2% | 29.37 ± 0.1% | not timed | not timed | 600.83 ± 0.2% | | 1.00 | 0.0001 | 20.54 |
| imported/rsc/reallyhard0-32 | 58 | 254.36 ± 2.7% | not timed | not timed | 222.94 ± 0.1% | 49.71 ± 8.9% | not timed | not timed | 254.11 ± 0.2% | | 1.00 | 1.14 | 5.12 |
| imported/rsc/reallyhard0-1k | 27 | 574.55 ± 0.1% | not timed | not timed | 583.79 ± 0.2% | 40.83 ± 0.1% | not timed | not timed | 579.15 ± 0.3% | | 0.99 | 0.98 | 14.07 |
| imported/rsc/reallyhard0-32k | 27 | 600.14 ± 0.3% | not timed | not timed | 612.85 ± 0.0% | 29.13 ± 0.2% | not timed | not timed | 602.72 ± 0.6% | | 1.00 | 0.98 | 20.60 |
| imported/rsc/reallyhard0-1mb | 51 | 593.50 ± 0.7% | not timed | not timed | 618.25 ± 0.1% | 29.40 ± 0.1% | not timed | not timed | 595.79 ± 0.6% | | 1.00 | 0.96 | 20.19 |
| imported/rsc/reallyreallyhard0-32 | 47 | 273.87 ± 5.5% | not timed | not timed | 197.15 ± 0.1% | 60.57 ± 8.2% | not timed | not timed | 273.90 ± 0.2% | | 1.00 | 1.39 | 4.52 |
| imported/rsc/reallyreallyhard0-1k | 16 | 854.91 ± 3.6% | not timed | not timed | 5931.45 ± 0.2% | 34.41 ± 0.5% | not timed | not timed | 858.03 ± 4.0% | | 1.00 | 0.14 | 24.85 |
| imported/rsc/reallyreallyhard0-32k | 16 | 632.41 ± 5.7% | not timed | not timed | 19291.38 ± 0.1% | 24.61 ± 2.1% | not timed | not timed | 634.84 ± 7.0% | | 1.00 | 0.0328 | 25.70 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 588.64 ± 0.3% | not timed | not timed | 19841.27 ± 0.6% | 24.35 ± 0.6% | not timed | not timed | 591.51 ± 0.4% | | 1.00 | 0.0297 | 24.17 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 268.88 ± 3.5% | not timed | not timed | 212.87 ± 0.4% | 60.75 ± 11.0% | not timed | not timed | 268.07 ± 0.1% | | 1.00 | 1.26 | 4.43 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 840.93 ± 0.4% | not timed | not timed | 6091.63 ± 0.1% | 34.43 ± 1.1% | not timed | not timed | 840.07 ± 1.1% | | 1.00 | 0.14 | 24.43 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 634.48 ± 5.5% | not timed | not timed | 19171.75 ± 0.5% | 24.78 ± 1.0% | not timed | not timed | 635.80 ± 4.9% | | 1.00 | 0.0331 | 25.60 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 588.57 ± 0.4% | not timed | not timed | 19760.08 ± 1.2% | 24.26 ± 2.1% | not timed | not timed | 588.08 ± 0.3% | | 1.00 | 0.0298 | 24.26 |
| imported/sherlock/name-sherlock | 776 | 19656.03 ± 7.2% | not timed | not timed | 18532.15 ± 0.6% | 10179.16 ± 15.0% | not timed | not timed | 19651.97 ± 2.8% | | 1.00 | 1.06 | 1.93 |
| imported/sherlock/name-holmes | 2766 | 15112.89 ± 1.7% | not timed | not timed | 15530.92 ± 0.1% | 3161.15 ± 13.5% | not timed | not timed | 15239.10 ± 1.4% | | 0.99 | 0.97 | 4.78 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19685.32 ± 1.6% | not timed | not timed | 18480.00 ± 0.4% | 8046.86 ± 36.3% | not timed | not timed | 19711.02 ± 2.2% | | 1.00 | 1.07 | 2.45 |
| imported/sherlock/name-sherlock-casei | 816 | 15629.54 ± 0.5% | not timed | not timed | 4016.10 ± 0.1% | 32.59 ± 0.6% | not timed | not timed | 15611.02 ± 0.3% | | 1.00 | 3.89 | 479.54 |
| imported/sherlock/name-holmes-casei | 2802 | 9394.35 ± 6.6% | not timed | not timed | 3294.70 ± 0.1% | 37.63 ± 0.3% | not timed | not timed | 9390.54 ± 3.0% | | 1.00 | 2.85 | 249.63 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12917.62 ± 6.0% | not timed | not timed | 3952.56 ± 0.1% | 32.54 ± 0.3% | not timed | not timed | 12947.04 ± 0.9% | | 1.00 | 3.27 | 396.99 |
| imported/sherlock/name-whitespace | 1461 | 14984.17 ± 1.8% | not timed | not timed | 14513.88 ± 0.6% | 6554.28 ± 15.7% | not timed | not timed | 14986.03 ± 2.1% | | 1.00 | 1.03 | 2.29 |
| imported/sherlock/name-alt1 | 1142 | 11449.36 ± 0.2% | not timed | not timed | 16287.27 ± 1.0% | 4139.10 ± 15.5% | not timed | not timed | 11469.16 ± 2.7% | | 1.00 | 0.70 | 2.77 |
| imported/sherlock/name-alt2 | 3542 | 8588.64 ± 0.3% | not timed | not timed | 3831.59 ± 0.2% | 31.25 ± 0.1% | not timed | not timed | 8618.69 ± 0.3% | | 1.00 | 2.24 | 274.87 |
| imported/sherlock/name-alt3 | 4507 | 5435.57 ± 0.2% | not timed | not timed | 3635.26 ± 0.2% | 9.93 ± 3.4% | not timed | not timed | 5441.99 ± 0.4% | | 1.00 | 1.50 | 547.43 |
| imported/sherlock/name-alt3-casei | 4593 | 1509.93 ± 1.5% | not timed | not timed | 286.84 ± 0.2% | 6.47 ± 0.3% | not timed | not timed | 1517.71 ± 0.9% | | 0.99 | 5.26 | 233.45 |
| imported/sherlock/name-alt4 | 3686 | 6171.44 ± 0.2% | not timed | not timed | 3797.35 ± 0.1% | 31.30 ± 0.1% | not timed | not timed | 6167.10 ± 0.5% | | 1.00 | 1.63 | 197.15 |
| imported/sherlock/name-alt4-casei | 4254 | 2759.46 ± 2.4% | not timed | not timed | 2600.78 ± 0.2% | 19.52 ± 0.2% | not timed | not timed | 2763.43 ± 1.4% | | 1.00 | 1.06 | 141.39 |
| imported/sherlock/name-alt5 | 4028 | 6209.47 ± 0.3% | not timed | not timed | 3751.21 ± 0.1% | 21.76 ± 0.1% | not timed | not timed | 6233.19 ± 0.3% | | 1.00 | 1.66 | 285.34 |
| imported/sherlock/name-alt5-casei | 4104 | 3459.06 ± 2.2% | not timed | not timed | 2217.57 ± 0.1% | 14.37 ± 0.2% | not timed | not timed | 3467.79 ± 1.1% | | 1.00 | 1.56 | 240.79 |
| imported/sherlock/no-match-uncommon | 0 | 21526.03 ± 0.9% | not timed | not timed | 19617.00 ± 0.8% | 35747.66 ± 0.7% | not timed | not timed | 21525.98 ± 0.5% | | 1.00 | 1.10 | 0.60 |
| imported/sherlock/no-match-common | 0 | 21262.00 ± 1.0% | not timed | not timed | 19483.89 ± 1.1% | 1271.29 ± 1.1% | not timed | not timed | 21205.49 ± 1.0% | | 1.00 | 1.09 | 16.72 |
| imported/sherlock/no-match-really-common | 0 | 16076.39 ± 3.8% | not timed | not timed | 18762.15 ± 0.3% | 1276.41 ± 1.6% | not timed | not timed | 16105.13 ± 2.3% | | 1.00 | 0.86 | 12.60 |
| imported/sherlock/the-lower | 21654 | 2303.04 ± 1.5% | not timed | not timed | 2341.52 ± 0.3% | 227.69 ± 16.8% | not timed | not timed | 2315.05 ± 1.1% | | 0.99 | 0.98 | 10.12 |
| imported/sherlock/the-upper | 2223 | 12560.78 ± 11.1% | not timed | not timed | 13603.71 ± 1.1% | 2702.26 ± 20.8% | not timed | not timed | 12721.56 ± 12.2% | | 0.99 | 0.92 | 4.65 |
| imported/sherlock/the-casei | 23961 | 2004.53 ± 0.7% | not timed | not timed | 1324.06 ± 0.3% | 34.79 ± 1.0% | not timed | not timed | 2002.55 ± 0.4% | | 1.00 | 1.51 | 57.62 |
| imported/sherlock/everything-greedy | 581881 | 271.04 ± 1.0% | not timed | not timed | 166.43 ± 0.2% | 28.77 ± 34.8% | not timed | not timed | 270.99 ± 0.8% | | 1.00 | 1.63 | 9.42 |
| imported/sherlock/everything-greedy-nl | 594933 | 462.23 ± 0.1% | not timed | not timed | 213.10 ± 0.5% | 32.95 ± 0.3% | not timed | not timed | 463.39 ± 0.0% | | 1.00 | 2.17 | 14.03 |
| imported/sherlock/letters | 447175 | 54.24 ± 7.7% | not timed | not timed | 32.86 ± 0.2% | 5.23 ± 26.1% | not timed | not timed | 54.45 ± 8.5% | | 1.00 | 1.65 | 10.36 |
| imported/sherlock/letters-upper | 14180 | 434.13 ± 0.3% | not timed | not timed | 370.58 ± 0.0% | 29.69 ± 0.8% | not timed | not timed | 434.90 ± 1.2% | | 1.00 | 1.17 | 14.62 |
| imported/sherlock/letters-lower | 432995 | 55.59 ± 0.6% | not timed | not timed | 33.78 ± 0.1% | 5.66 ± 46.3% | not timed | not timed | 55.51 ± 0.6% | | 1.00 | 1.65 | 9.82 |
| imported/sherlock/words | 447639 | 106.49 ± 0.9% | not timed | not timed | 82.82 ± 0.2% | 13.44 ± 4.2% | not timed | not timed | 105.28 ± 0.5% | | 1.01 | 1.29 | 7.92 |
| imported/sherlock/before-holmes | 4073 | 599.90 ± 0.2% | not timed | not timed | 8519.74 ± 0.2% | 23.83 ± 2.3% | not timed | not timed | 598.05 ± 0.3% | | 1.00 | 0.0704 | 25.17 |
| imported/sherlock/before-after-holmes | 2593 | 596.97 ± 0.7% | not timed | not timed | 9540.22 ± 0.4% | 24.11 ± 1.7% | not timed | not timed | 598.19 ± 0.5% | | 1.00 | 0.0626 | 24.76 |
| imported/sherlock/holmes-cochar-watson | 150 | 5219.16 ± 0.4% | not timed | not timed | 3426.94 ± 0.1% | 31.05 ± 0.4% | not timed | not timed | 5233.06 ± 0.4% | | 1.00 | 1.52 | 168.09 |
| imported/sherlock/holmes-coword-watson | 14309 | 1260.72 ± 1.1% | not timed | not timed | 1127.02 ± 0.4% | 6.75 ± 0.2% | not timed | not timed | 1265.23 ± 4.3% | | 1.00 | 1.12 | 186.78 |
| imported/sherlock/quotes | 14437 | 1381.23 ± 0.2% | not timed | not timed | 1754.55 ± 0.5% | 35.04 ± 0.3% | not timed | not timed | 1414.59 ± 0.2% | | 0.98 | 0.79 | 39.42 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 602.15 ± 0.5% | not timed | not timed | 16083.92 ± 0.3% | 36.70 ± 0.5% | not timed | not timed | 602.59 ± 0.4% | | 1.00 | 0.0374 | 16.41 |
| imported/sherlock/word-ending-n | 35297 | 468.84 ± 0.2% | not timed | not timed | 409.13 ± 0.1% | 23.42 ± 22.9% | not timed | not timed | 467.82 ± 2.3% | | 1.00 | 1.15 | 20.02 |
| imported/sherlock/repeated-class-negation | 2130 | 14590.75 ± 0.8% | not timed | not timed | 10890.43 ± 0.5% | 11.59 ± 1.4% | not timed | not timed | 14610.15 ± 0.6% | | 1.00 | 1.34 | 1258.40 |
| imported/sherlock/ing-suffix | 20547 | 555.18 ± 0.2% | not timed | not timed | 516.91 ± 0.1% | 28.86 ± 0.1% | not timed | not timed | 553.81 ± 0.3% | | 1.00 | 1.07 | 19.23 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 595.71 ± 0.4% | not timed | not timed | 2007.62 ± 0.3% | 20.53 ± 0.1% | not timed | not timed | 595.01 ± 0.3% | | 1.00 | 0.30 | 29.02 |
| opt/accelerate/whole-line | 239963 | 458.38 ± 0.3% | not timed | not timed | 373.03 ± 0.3% | 92.36 ± 16.4% | not timed | not timed | 459.38 ± 0.1% | | 1.00 | 1.23 | 4.96 |
| opt/accelerate/non-dna | 16745 | 412.83 ± 0.3% | not timed | not timed | 399.74 ± 0.2% | 29.41 ± 24.9% | not timed | not timed | 413.74 ± 1.1% | | 1.00 | 1.03 | 14.04 |
| opt/backtrack/words-english | 40536 | 136.42 ± 8.4% | not timed | not timed | 94.25 ± 0.3% | 19.45 ± 7.6% | not timed | not timed | 136.83 ± 1.5% | | 1.00 | 1.45 | 7.01 |
| opt/fixed-length/too-small-ascii | 0 | 313.12 ± 0.2% | not timed | not timed | 687.95 ± 5.6% | 80.14 ± 1.0% | not timed | not timed | 312.27 ± 0.3% | | 1.00 | 0.46 | 3.91 |
| opt/fixed-length/too-big-ascii | 0 | 644.78 ± 0.3% | not timed | not timed | 5764.24 ± 0.3% | 126.38 ± 0.6% | not timed | not timed | 651.82 ± 0.5% | | 0.99 | 0.11 | 5.10 |
| opt/fixed-length/go33484-1 | 0 | 45.18 ± 0.4% | not timed | not timed | 1117316.77 ± 0.1% | 61336.89 ± 0.5% | not timed | not timed | 45.23 ± 0.4% | | 1.00 | 0.0000 | 0.0007 |
| opt/fixed-length/go33484-2 | 0 | 5535.47 ± 0.1% | not timed | not timed | 1105712.88 ± 0.1% | 31816.45 ± 2.7% | not timed | not timed | 5521.07 ± 0.0% | | 1.00 | 0.0050 | 0.17 |
| opt/fixed-length/go33484-3 | 0 | 1797.46 ± 2.0% | not timed | not timed | 111476.71 ± 0.3% | 753.44 ± 1.4% | not timed | not timed | 1782.56 ± 1.7% | | 1.01 | 0.0161 | 2.39 |
| opt/literal-alt/one-pattern | 1 | 554.61 ± 1.5% | not timed | not timed | 543.84 ± 0.2% | 0.39 ± 0.5% | not timed | not timed | 555.78 ± 0.3% | | 1.00 | 1.02 | 1418.15 |
| opt/onepass/fn-predicate | 916 | 364.80 ± 0.7% | not timed | not timed | 333.34 ± 0.2% | 200.92 ± 11.5% | not timed | not timed | 368.55 ± 0.9% | | 0.99 | 1.09 | 1.82 |
| opt/onepass/first-three-words-english | 35128 | 148.88 ± 2.5% | not timed | not timed | 201.61 ± 0.2% | 76.67 ± 11.2% | not timed | not timed | 149.83 ± 1.1% | | 0.99 | 0.74 | 1.94 |
| opt/prefilter/literal-english | 1 | 20809.72 ± 0.5% | not timed | not timed | 19921.35 ± 0.5% | 17611.37 ± 0.4% | not timed | not timed | 20817.87 ± 0.3% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14508.95 ± 0.7% | not timed | not timed | 4314.14 ± 0.3% | 32.58 ± 0.6% | not timed | not timed | 14515.74 ± 0.1% | | 1.00 | 3.36 | 445.33 |
| opt/prefilter/literal-russian | 1 | 21104.76 ± 0.5% | not timed | not timed | 19740.41 ± 1.0% | 3322.02 ± 0.5% | not timed | not timed | 21143.67 ± 0.4% | | 1.00 | 1.07 | 6.35 |
| opt/prefilter/literal-casei-russian | 1 | 8579.82 ± 0.5% | not timed | not timed | 3891.31 ± 0.3% | 30.93 ± 0.6% | not timed | not timed | 8589.22 ± 0.1% | | 1.00 | 2.20 | 277.43 |
| opt/prefilter/rust-functions | 948 | 6734.62 ± 0.8% | not timed | not timed | 8858.44 ± 0.8% | 1866.54 ± 0.3% | not timed | not timed | 6741.15 ± 1.5% | | 1.00 | 0.76 | 3.61 |
| opt/reverse-anchored/word-end | 1 | 5576.27 ± 0.3% | not timed | not timed | 21134721.67 ± 0.2% | 50.03 ± 0.2% | not timed | not timed | 5579.16 ± 0.3% | | 1.00 | 0.0003 | 111.47 |
| opt/reverse-inner/holmes | 2593 | 597.55 ± 0.6% | not timed | not timed | 9529.01 ± 0.7% | 23.91 ± 1.3% | not timed | not timed | 598.22 ± 0.2% | | 1.00 | 0.0627 | 24.99 |
| opt/reverse-inner/email | 47 | 1044.60 ± 0.2% | not timed | not timed | 44409.08 ± 1.8% | 32.35 ± 1.2% | not timed | not timed | 1044.14 ± 0.1% | | 1.00 | 0.0235 | 32.29 |
| opt/reverse-inner/factored-prefix | 3542 | 591.02 ± 0.2% | not timed | not timed | 557.08 ± 1.1% | 12.00 ± 0.2% | not timed | not timed | 591.75 ± 0.5% | | 1.00 | 1.06 | 49.27 |
| opt/reverse-inner/no-quadratic-backward | 0 | 5509.46 ± 0.1% | not timed | not timed | 615.04 ± 0.4% | 75.16 ± 0.0% | not timed | not timed | 5519.39 ± 0.1% | | 1.00 | 8.96 | 73.30 |
| opt/reverse-inner/no-quadratic-forward | 0 | 686.74 ± 2.3% | not timed | not timed | 288.83 ± 0.3% | 24.81 ± 0.1% | not timed | not timed | 686.92 ± 2.2% | | 1.00 | 2.38 | 27.68 |
| opt/reverse-suffix/holmes | 4073 | 600.56 ± 0.6% | not timed | not timed | 8471.42 ± 0.5% | 24.09 ± 0.9% | not timed | not timed | 598.08 ± 0.2% | | 1.00 | 0.0709 | 24.93 |
| opt/reverse-suffix/no-quadratic | 0 | 5519.58 ± 0.1% | not timed | not timed | 611.99 ± 0.2% | 75.20 ± 0.0% | not timed | not timed | 5506.68 ± 0.1% | | 1.00 | 9.02 | 73.39 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.83 ± 2.4% | not timed | not timed | 132.53 ± 0.1% | 13.16 ± 13.8% | not timed | not timed | 120.86 ± 3.1% | | 1.00 | 0.91 | 9.18 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.19 ± 4.0% | not timed | not timed | 129.55 ± 0.2% | 12.81 ± 14.9% | not timed | not timed | 121.34 ± 0.2% | | 1.00 | 0.94 | 9.46 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.23 ± 0.6% | not timed | not timed | 0.55 ± 0.3% | 113.04 ± 0.4% | not timed | not timed | 0.22 ± 0.4% | | 1.01 | 0.41 | 0.0020 |
| reported/i1095-word-repetition/ascii-search | 256 | 316.70 ± 0.3% | not timed | not timed | 294.25 ± 0.1% | 103.62 ± 7.8% | not timed | not timed | 309.67 ± 3.2% | | 1.02 | 1.08 | 3.06 |
| reported/i13-subset-regex/original-ascii | 4094 | 10817.77 ± 0.6% | not timed | not timed | 4309.87 ± 2.9% | 11.50 ± 0.1% | not timed | not timed | 10787.72 ± 1.5% | | 1.00 | 2.51 | 940.50 |
| reported/i13-subset-regex/original-unicode | 4094 | 10593.06 ± 3.2% | not timed | not timed | 247.61 ± 3.3% | 11.51 ± 0.2% | not timed | not timed | 10851.01 ± 2.0% | | 0.98 | 42.78 | 920.31 |
| reported/i13-subset-regex/big-ascii | 1955 | 10416.09 ± 3.3% | not timed | not timed | 67.98 ± 3.7% | 9.84 ± 0.1% | not timed | not timed | 10513.72 ± 1.1% | | 0.99 | 153.23 | 1058.38 |
| reported/i13-subset-regex/big-unicode | 1955 | 10300.49 ± 3.9% | not timed | not timed | 12.17 ± 54.9% | 9.84 ± 0.3% | not timed | not timed | 10519.96 ± 1.3% | | 0.98 | 846.54 | 1046.93 |
| reported/i13-subset-regex/huge-ascii | 55 | 9607.15 ± 4.2% | not timed | not timed | 11.02 ± 0.1% | 8.74 ± 0.3% | not timed | not timed | 9721.27 ± 2.9% | | 0.99 | 871.55 | 1098.68 |
| reported/i13-subset-regex/huge-unicode | 55 | 9521.93 ± 6.1% | not timed | not timed | 10.99 ± 0.3% | 8.75 ± 0.1% | not timed | not timed | 9528.70 ± 1.5% | | 1.00 | 866.10 | 1088.44 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.05 ± 0.1% | 8.75 ± 0.3% | not timed | not timed | 3.54 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 5.03 ± 0.1% | not timed | not timed | 11.00 ± 0.3% | 8.74 ± 1.1% | not timed | not timed | 5.03 ± 0.1% | | 1.00 | 0.46 | 0.58 |
| reported/i787-keywords/ascii | 5674 | 467.59 ± 0.3% | not timed | not timed | 104.46 ± 0.1% | 6.59 ± 0.2% | not timed | not timed | 469.74 ± 0.2% | | 1.00 | 4.48 | 71.00 |
| reported/i787-keywords/opt-ascii | 5674 | 469.00 ± 0.2% | not timed | not timed | 276.14 ± 0.2% | 10.21 ± 0.1% | not timed | not timed | 470.85 ± 0.4% | | 1.00 | 1.70 | 45.92 |
| slow/quadratic-regex-1x | 100 | 6.96 ± 0.2% | not timed | not timed | 4.93 ± 0.2% | 0.05 ± 0.4% | not timed | not timed | 6.95 ± 0.4% | | 1.00 | 1.41 | 140.82 |
| slow/quadratic-regex-2x | 199 | 3.40 ± 0.0% | not timed | not timed | 2.77 ± 0.1% | 0.01 ± 0.3% | not timed | not timed | 3.40 ± 0.1% | | 1.00 | 1.23 | 267.70 |
| slow/quadratic-haystack-1x | 100 | 21.05 ± 6.9% | not timed | not timed | 10.00 ± 0.2% | 0.95 ± 13.5% | not timed | not timed | 21.21 ± 1.9% | | 0.99 | 2.11 | 22.21 |
| slow/quadratic-haystack-2x | 200 | 17.49 ± 1.8% | not timed | not timed | 5.55 ± 0.1% | 0.54 ± 1.3% | not timed | not timed | 17.44 ± 13.1% | | 1.00 | 3.15 | 32.16 |
| unicode/codepoints/any-one | 1112064 | 285.47 ± 0.5% | not timed | not timed | 175.28 ± 0.1% | 17.20 ± 24.9% | not timed | not timed | 285.20 ± 0.4% | | 1.00 | 1.63 | 16.60 |
| unicode/codepoints/any-all | 4382592 | 288.31 ± 1.9% | not timed | not timed | 246.54 ± 0.2% | 117.25 ± 0.2% | not timed | not timed | 288.57 ± 0.4% | | 1.00 | 1.17 | 2.46 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.74 ± 0.8% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 610.19 ± 0.2% | not timed | not timed | 613.84 ± 0.2% | 135.31 ± 0.1% | not timed | not timed | 609.62 ± 0.2% | | 1.00 | 0.99 | 4.51 |
| unicode/overlapping-words/ascii | 6156 | 31.02 ± 3.0% | not timed | not timed | 38.97 ± 0.1% | 3.73 ± 6.3% | not timed | not timed | 31.18 ± 2.6% | | 0.99 | 0.80 | 8.31 |
| unicode/overlapping-words/english | 6156 | 1.32 ± 1.3% | not timed | not timed | 3.76 ± 0.2% | 2.38 ± 7.2% | not timed | not timed | 1.33 ± 0.2% | | 0.99 | 0.35 | 0.55 |
| unicode/overlapping-words/russian | 5710 | 1.15 ± 9.2% | not timed | not timed | 3.59 ± 0.4% | 6.28 ± 4.5% | not timed | not timed | 1.14 ± 0.3% | | 1.01 | 0.32 | 0.18 |
| unicode/word/boundary-any-english | 450561 | 117.05 ± 2.6% | not timed | not timed | 82.66 ± 0.2% | 11.37 ± 13.3% | not timed | not timed | 117.67 ± 3.1% | | 0.99 | 1.42 | 10.30 |
| unicode/word/boundary-long-english | 3466 | 607.07 ± 0.8% | not timed | not timed | 605.01 ± 0.4% | 32.60 ± 0.8% | not timed | not timed | 606.69 ± 0.4% | | 1.00 | 1.00 | 18.62 |
| unicode/word/around-holmes-english | 27 | 602.53 ± 0.5% | not timed | not timed | 19641.40 ± 0.4% | 22.15 ± 0.4% | not timed | not timed | 602.10 ± 0.3% | | 1.00 | 0.0307 | 27.20 |
| wild/bibleref/long | 874 | 565.31 ± 0.3% | not timed | not timed | 584.16 ± 0.2% | 6.81 ± 0.2% | not timed | not timed | 566.23 ± 0.1% | | 1.00 | 0.97 | 83.05 |
| wild/bibleref/short | 30 | 24.42 ± 4.9% | not timed | not timed | 31.25 ± 0.4% | 14.12 ± 10.0% | not timed | not timed | 25.63 ± 3.0% | | 0.95 | 0.78 | 1.73 |
| wild/bibleref/line | 874 | 357.22 ± 0.2% | not timed | not timed | 215.65 ± 0.1% | 9.21 ± 0.3% | not timed | not timed | 357.83 ± 0.2% | | 1.00 | 1.66 | 38.80 |
| wild/caddy/caddy | 6 | 417.91 ± 0.6% | not timed | not timed | 243.48 ± 0.1% | 67.27 ± 13.2% | not timed | not timed | 416.75 ± 8.0% | | 1.00 | 1.72 | 6.21 |
| wild/dot-star-capture/rust-src-tools | 6 | 1058.24 ± 0.2% | not timed | not timed | 344.63 ± 0.3% | 13.37 ± 0.2% | not timed | not timed | 1060.48 ± 0.5% | | 1.00 | 3.07 | 79.18 |
| wild/ruff/noqa | 84 | 404.13 ± 0.1% | not timed | not timed | 480.21 ± 0.3% | 19.48 ± 1.6% | not timed | not timed | 403.40 ± 0.2% | | 1.00 | 0.84 | 20.74 |
| wild/ruff/unnecessary-coding-comment | 16 | 488.52 ± 0.6% | not timed | not timed | 705.15 ± 0.1% | 135.89 ± 11.4% | not timed | not timed | 488.97 ± 0.7% | | 1.00 | 0.69 | 3.59 |
| wild/ruff/string-quote-prefix | 2972 | 406.91 ± 0.7% | not timed | not timed | 440.37 ± 0.1% | 313.42 ± 25.4% | not timed | not timed | 407.25 ± 0.6% | | 1.00 | 0.92 | 1.30 |
| wild/ruff/space-around-operator | 1224378 | 217.03 ± 1.9% | not timed | not timed | 187.49 ± 0.0% | 18.38 ± 1.9% | not timed | not timed | 217.05 ± 1.8% | | 1.00 | 1.16 | 11.80 |
| wild/ruff/shebang | 282 | 401.69 ± 0.6% | not timed | not timed | 328.89 ± 0.1% | 115.62 ± 14.6% | not timed | not timed | 401.28 ± 0.6% | | 1.00 | 1.22 | 3.47 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13836.76 ± 0.4% | not timed | not timed | 13807.55 ± 0.4% | 6929.09 ± 0.6% | not timed | not timed | 13824.84 ± 0.2% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12800.99 ± 0.6% | not timed | not timed | 13445.79 ± 0.7% | 6362.47 ± 0.6% | not timed | not timed | 12759.89 ± 0.5% | | 1.00 | 0.95 | 2.01 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13118.31 ± 0.8% | not timed | not timed | 13646.62 ± 0.4% | 6570.99 ± 1.9% | not timed | not timed | 13182.33 ± 0.8% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9542.69 ± 0.6% | not timed | not timed | 13652.11 ± 0.6% | 6679.18 ± 1.5% | not timed | not timed | 9550.37 ± 0.8% | | 1.00 | 0.70 | 1.43 |
| wild/url/search | 234965 | 122.31 ± 12.2% | not timed | not timed | 65.75 ± 1.1% | 2.20 ± 0.8% | not timed | not timed | 121.60 ± 14.0% | | 1.01 | 1.86 | 55.55 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 2.3% | not timed | not timed | 0.01 ± 0.6% | 0.01 ± 22.5% | not timed | not timed | 0.03 ± 2.3% | | 0.99 | 3.11 | 4.25 |
| dictionary/compile/english-15 | 1 | 0.35 ± 21.5% | not timed | not timed | 0.07 ± 0.8% | 0.10 ± 27.9% | not timed | not timed | 0.35 ± 0.7% | | 1.00 | 5.12 | 3.54 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 1.9% | not timed | not timed | 0.02 ± 1.5% | 34.39 ± 12.4% | not timed | not timed | 0.25 ± 3.6% | | 0.95 | 12.79 | 0.0070 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.51 ± 2.5% | not timed | not timed | 11.58 ± 0.4% | 50.89 ± 17.7% | not timed | not timed | 47.77 ± 2.2% | | 0.99 | 4.10 | 0.93 |
| reported/i787-keywords/compile | 1 | 35.50 ± 4.8% | not timed | not timed | 2.12 ± 0.6% | 16.55 ± 37.3% | not timed | not timed | 35.53 ± 5.0% | | 1.00 | 16.77 | 2.14 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 375.69 ± 5.0% | not timed | not timed | 122.73 ± 0.2% | 557.53 ± 22.9% | not timed | not timed | 375.17 ± 6.6% | | 1.00 | 3.06 | 0.67 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 48.43 ± 1.6% | not timed | not timed | 4.08 ± 0.3% | 42.77 ± 6.3% | not timed | not timed | 48.92 ± 2.4% | | 0.99 | 11.87 | 1.13 |
| unicode/compile/one-letter | 53 | 6.81 ± 3.7% | not timed | not timed | 4.55 ± 0.4% | 64.70 ± 20.0% | not timed | not timed | 6.80 ± 11.7% | | 1.00 | 1.50 | 0.11 |
| unicode/compile/fifty-letters | 1 | 1.07 ± 15.7% | not timed | not timed | 0.10 ± 0.6% | 63.93 ± 7.3% | not timed | not timed | 1.11 ± 1.8% | | 0.97 | 10.91 | 0.0168 |
| unicode/compile/fifty-letters-ascii | 1 | 223.22 ± 3.9% | not timed | not timed | 52.45 ± 0.4% | 198.88 ± 16.9% | not timed | not timed | 226.27 ± 4.0% | | 0.99 | 4.26 | 1.12 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 387.94 ± 4.9% | not timed | not timed | 46.97 ± 0.6% | 645.12 ± 30.5% | not timed | not timed | 396.09 ± 2.3% | | 0.98 | 8.26 | 0.60 |
| unicode/compile/match-every-line-ascii | 4 | 621.51 ± 9.7% | not timed | not timed | 145.33 ± 0.2% | 656.68 ± 32.6% | not timed | not timed | 634.05 ± 19.8% | | 0.98 | 4.28 | 0.95 |
| unicode/compile/negated-class-matches-codepoint | 1 | 324.80 ± 4.5% | not timed | not timed | 50.76 ± 0.3% | 1209.48 ± 6.8% | not timed | not timed | 337.26 ± 5.0% | | 0.96 | 6.40 | 0.27 |
| wild/bibleref/compile | 3 | 5.64 ± 23.3% | not timed | not timed | 1.93 ± 0.7% | 31.44 ± 15.7% | not timed | not timed | 6.00 ± 4.9% | | 0.94 | 2.93 | 0.18 |
| wild/url/compile | 1 | 0.64 ± 20.0% | not timed | not timed | 0.14 ± 0.8% | 0.43 ± 26.2% | not timed | not timed | 0.66 ± 17.3% | | 0.97 | 4.43 | 1.50 |

