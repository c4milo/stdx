# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261122.195.1 |
| CPU model | Neoverse-N2 |
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
| literal: a word | 217 | 19530.75 ± 0.7% | 10877.51 ± 0.4% | 27.63 ± 0.2% | 18239.64 ± 1.2% | 9434.39 ± 6.2% | 17.36 ± 0.5% | 86.08 ± 0.4% | 19430.63 ± 0.7% | 1.80 | 1.01 | 1.07 | 2.07 |
| literal: a word that is not there | 0 | 21623.67 ± 1.0% | 9914.03 ± 0.8% | 27.71 ± 0.4% | 19774.76 ± 2.2% | 28066.55 ± 3.5% | 17.09 ± 0.3% | 80.44 ± 0.2% | 21446.75 ± 2.7% | 2.18 | 1.01 | 1.09 | 0.77 |
| literal: one of four words | 661 | 6435.31 ± 0.6% | 1781.41 ± 0.3% | 14.25 ± 0.1% | 3947.37 ± 0.4% | 21.88 ± 0.2% | 5.38 ± 0.1% | 6.95 ± 0.1% | 6442.87 ± 0.3% | 3.61 | 1.00 | 1.63 | 294.11 |
| literal: a word in any case | 217 | 15261.21 ± 0.6% | 1919.88 ± 0.3% | 21.28 ± 0.1% | 3974.06 ± 0.1% | 38.04 ± 0.2% | refused | differs | 15266.59 ± 1.1% | 7.95 | 1.00 | 3.84 | 401.16 |
| literal: an href attribute | 33 | 16811.97 ± 0.5% | 608.80 ± 0.8% | 26.89 ± 0.1% | 16928.22 ± 1.1% | 2265.84 ± 0.5% | 13.10 ± 0.1% | 74.85 ± 0.5% | 16835.66 ± 0.7% | 27.62 | 1.00 | 0.99 | 7.42 |
| literal: a word, second text | 123 | 19874.06 ± 1.7% | 4588.89 ± 0.4% | 27.45 ± 0.4% | 18371.97 ± 0.8% | 7687.17 ± 5.1% | 20.02 ± 0.5% | 70.25 ± 0.9% | 19846.16 ± 1.5% | 4.33 | 1.00 | 1.08 | 2.59 |
| class: two capitalized words | 1331 | 1178.47 ± 0.5% | 597.58 ± 0.7% | 25.58 ± 0.3% | 586.36 ± 0.0% | 40.72 ± 7.9% | 14.76 ± 0.2% | 67.83 ± 0.4% | 1179.10 ± 0.2% | 1.97 | 1.00 | 2.01 | 28.94 |
| class: a word that ends in ing | 3399 | 574.61 ± 0.4% | 573.36 ± 0.4% | 17.68 ± 0.1% | 548.17 ± 0.1% | 29.64 ± 6.3% | 8.15 ± 0.1% | 18.39 ± 0.2% | 575.14 ± 0.4% | 1.00 | 1.00 | 1.05 | 19.39 |
| class: a word in capitals | 2332 | 1534.12 ± 0.2% | 607.17 ± 0.5% | 27.08 ± 0.2% | 572.76 ± 0.2% | 43.55 ± 3.2% | 17.13 ± 0.2% | 82.93 ± 0.9% | 1534.09 ± 0.4% | 2.53 | 1.00 | 2.68 | 35.23 |
| class: a number | 8288 | 2661.13 ± 0.8% | 840.94 ± 0.1% | 27.26 ± 0.3% | 1714.84 ± 0.4% | 40.05 ± 15.5% | 0.55 ± 0.1% | 57.20 ± 0.4% | 2680.53 ± 0.4% | 3.16 | 0.99 | 1.55 | 66.45 |
| class: two capitalized words, second text | 5359 | 521.24 ± 0.1% | 528.25 ± 0.2% | 22.91 ± 0.1% | 484.88 ± 0.0% | 35.41 ± 10.8% | 17.05 ± 0.2% | 63.16 ± 0.2% | 522.29 ± 0.4% | 0.99 | 1.00 | 1.07 | 14.72 |
| other: a word between two words | 6104 | 814.36 ± 0.2% | 602.64 ± 0.1% | 23.16 ± 0.1% | 739.61 ± 0.1% | 107.60 ± 10.2% | 11.15 ± 0.1% | 69.16 ± 0.3% | 813.73 ± 0.3% | 1.35 | 1.00 | 1.10 | 7.57 |
| other: a number before a unit, second text | 1481 | 6257.54 ± 0.8% | 1143.31 ± 0.2% | 25.53 ± 0.3% | 5641.80 ± 0.3% | 40.80 ± 9.0% | 17.96 ± 0.4% | 65.49 ± 0.2% | 6250.80 ± 1.4% | 5.47 | 1.00 | 1.11 | 153.37 |
| other: a heading's start tag | 110 | 14136.84 ± 0.5% | 739.98 ± 0.2% | 26.85 ± 0.2% | 1708.36 ± 0.4% | 1581.29 ± 6.5% | 16.22 ± 0.3% | 87.77 ± 0.4% | 14182.88 ± 0.4% | 19.10 | 1.00 | 8.28 | 8.94 |
| other: a whole word | 217 | 16376.89 ± 1.5% | 594.71 ± 1.3% | 28.18 ± 0.2% | 14613.16 ± 1.5% | 49.41 ± 0.1% | 13.16 ± 0.2% | 55.06 ± 0.4% | 16386.68 ± 0.4% | 27.54 | 1.00 | 1.12 | 331.44 |
| other: a line's first word, second text | 3716 | 2102.67 ± 0.7% | 592.50 ± 0.2% | 30.00 ± 0.2% | 1730.17 ± 0.4% | 63.49 ± 7.3% | refused | refused | 2112.58 ± 0.5% | 3.55 | 1.00 | 1.22 | 33.12 |
| other: fourteen octets before an x | 87 | 23958.20 ± 3.5% | 249.46 ± 0.6% | 6.46 ± 0.2% | 4014.59 ± 1.1% | 10.65 ± 0.1% | differs | 17.93 ± 0.2% | 23885.27 ± 5.0% | 96.04 | 1.00 | 5.97 | 2250.60 |
| other: a Greek word | 21815 | 529.25 ± 0.3% | 423.86 ± 0.1% | 30.18 ± 0.3% | 290.17 ± 0.4% | 50.69 ± 12.1% | differs | refused | 530.22 ± 0.5% | 1.25 | 1.00 | 1.82 | 10.44 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.59 ± 0.3% | 29.60 ± 0.2% | 0.86 ± 0.3% | 19.66 ± 0.4% | 2.73 ± 0.6% | differs | 4.06 ± 0.3% | 29.56 ± 0.2% | 1.00 | 1.00 | 1.51 | 10.82 |
| a UUID | 32895 | 24.70 ± 0.1% | 24.80 ± 0.1% | 0.64 ± 0.2% | 15.22 ± 0.5% | 3.10 ± 0.8% | 0.74 ± 0.4% | 3.62 ± 0.3% | 24.40 ± 0.5% | 1.00 | 1.01 | 1.62 | 7.96 |
| an IPv4 address | 33176 | 38.80 ± 0.4% | 38.72 ± 0.1% | 2.07 ± 0.7% | 29.23 ± 0.5% | 6.68 ± 0.3% | differs | 4.22 ± 0.2% | 38.84 ± 0.1% | 1.00 | 1.00 | 1.33 | 5.81 |
| a date and time | 32954 | 34.02 ± 0.3% | 34.23 ± 0.4% | 1.44 ± 0.4% | 21.51 ± 0.7% | 7.03 ± 0.2% | 1.26 ± 0.2% | 7.18 ± 0.3% | 34.20 ± 0.1% | 0.99 | 0.99 | 1.58 | 4.84 |
| a field path | 32606 | 32.85 ± 0.3% | 32.78 ± 0.3% | 1.02 ± 0.3% | 23.24 ± 0.3% | 3.48 ± 0.9% | differs | 2.94 ± 0.2% | 32.86 ± 0.2% | 1.00 | 1.00 | 1.41 | 9.45 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.24 ± 0.3% | 11.21 ± 0.9% | 11.26 ± 0.9% | 11.46 ± 0.1% | 5.01 ± 1.4% | 0.95 ± 0.4% | none | 11.15 ± 1.7% | 1.00 | 1.01 | 0.98 | 2.25 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 223.41 ± 0.5% | 224.02 ± 0.3% | 269.28 ± 0.3% | 86.41 ± 0.6% | 225.32 ± 1.3% | 477.88 ± 1.1% | 3756.69 ± 0.3% | 224.05 ± 0.4% | 1.00 | 1.00 | 2.59 | 0.99 |
| a UUID | 62 | 146.38 ± 1.0% | 146.82 ± 0.3% | 166.37 ± 0.3% | 46.18 ± 0.5% | 101.39 ± 0.4% | 183.97 ± 1.1% | 4385.04 ± 0.3% | 146.87 ± 0.8% | 1.00 | 1.00 | 3.17 | 1.44 |
| an IPv4 address | 29 | 403.86 ± 0.4% | 403.21 ± 0.4% | 578.42 ± 0.7% | 76.88 ± 0.7% | 133.40 ± 1.2% | 296.89 ± 0.6% | 7565.48 ± 0.6% | 404.11 ± 0.1% | 1.00 | 1.00 | 5.25 | 3.03 |
| a date and time | 56 | 290.74 ± 0.1% | 290.72 ± 0.1% | 371.42 ± 0.1% | 71.92 ± 1.3% | 139.07 ± 1.3% | 320.20 ± 1.2% | 4964.96 ± 0.4% | 290.68 ± 0.2% | 1.00 | 1.00 | 4.04 | 2.09 |
| a field path | 39 | 217.78 ± 0.6% | 217.29 ± 1.4% | 259.66 ± 0.7% | 80.76 ± 1.3% | 209.87 ± 0.9% | 487.79 ± 1.9% | 4761.74 ± 0.3% | 217.41 ± 0.7% | 1.00 | 1.00 | 2.70 | 1.04 |
| literal: a word | 7 | 573.64 ± 0.6% | 614.54 ± 0.7% | 1122.42 ± 0.2% | 517.42 ± 0.1% | 643.66 ± 1.6% | 934.54 ± 0.4% | 30784.99 ± 0.4% | 574.23 ± 0.3% | 0.93 | 1.00 | 1.11 | 0.89 |
| literal: a word that is not there | 8 | 557.22 ± 0.5% | 600.57 ± 0.4% | 1084.26 ± 0.6% | 472.85 ± 0.1% | 618.40 ± 1.9% | 896.55 ± 0.3% | 29470.45 ± 0.2% | 557.72 ± 0.3% | 0.93 | 1.00 | 1.18 | 0.90 |
| literal: one of four words | 26 | 233.03 ± 0.3% | 374.80 ± 0.2% | 524.05 ± 0.6% | 49.87 ± 0.9% | 248.72 ± 2.1% | 360.31 ± 0.2% | 15802.85 ± 0.6% | 232.84 ± 0.6% | 0.62 | 1.00 | 4.67 | 0.94 |
| literal: a word in any case | 11 | 420.07 ± 0.2% | 448.09 ± 0.1% | 672.81 ± 0.3% | 15.82 ± 0.6% | 668.11 ± 2.0% | refused | 23935.43 ± 0.4% | 420.12 ± 0.3% | 0.94 | 1.00 | 26.55 | 0.63 |
| literal: an href attribute | 12 | 324.88 ± 0.6% | 336.10 ± 0.2% | 448.10 ± 0.4% | 45.90 ± 0.6% | 509.20 ± 1.4% | 775.04 ± 1.4% | 22328.10 ± 0.3% | 324.89 ± 0.4% | 0.97 | 1.00 | 7.08 | 0.64 |
| literal: a word, second text | 10 | 516.24 ± 0.4% | 562.97 ± 0.4% | 967.75 ± 0.2% | 430.57 ± 0.4% | 546.37 ± 1.6% | 805.98 ± 0.5% | 27609.79 ± 0.6% | 516.34 ± 0.1% | 0.92 | 1.00 | 1.20 | 0.94 |
| class: two capitalized words | 23 | 413.18 ± 0.1% | 441.56 ± 0.2% | 654.23 ± 0.1% | 101.59 ± 2.6% | 511.51 ± 2.1% | 745.62 ± 0.4% | 6340.79 ± 0.1% | 412.85 ± 0.5% | 0.94 | 1.00 | 4.07 | 0.81 |
| class: a word that ends in ing | 9 | 519.02 ± 0.3% | 581.97 ± 0.5% | 1049.63 ± 0.1% | 133.90 ± 0.5% | 769.31 ± 0.8% | 1118.82 ± 0.3% | 15870.09 ± 0.1% | 519.13 ± 0.2% | 0.89 | 1.00 | 3.88 | 0.67 |
| class: a word in capitals | 16 | 465.04 ± 0.4% | 500.86 ± 0.6% | 814.68 ± 0.0% | 136.39 ± 1.1% | 761.74 ± 1.7% | 1033.04 ± 0.6% | 8350.84 ± 0.1% | 465.68 ± 0.2% | 0.93 | 1.00 | 3.41 | 0.61 |
| class: a number | 6 | 583.36 ± 0.5% | 639.28 ± 0.3% | 1230.89 ± 0.1% | 42.02 ± 1.1% | 1434.92 ± 2.0% | 1856.86 ± 0.4% | 23152.61 ± 0.1% | 583.59 ± 0.6% | 0.91 | 1.00 | 13.88 | 0.41 |
| class: two capitalized words, second text | 23 | 413.69 ± 0.6% | 441.26 ± 0.3% | 653.67 ± 0.3% | 102.62 ± 1.8% | 515.06 ± 0.8% | 763.32 ± 2.5% | 6331.74 ± 0.4% | 413.35 ± 0.4% | 0.94 | 1.00 | 4.03 | 0.80 |
| other: a word between two words | 13 | 504.43 ± 0.2% | 522.53 ± 0.6% | 857.07 ± 0.3% | 135.72 ± 0.6% | 513.20 ± 0.8% | 801.71 ± 0.6% | 14695.35 ± 0.1% | 504.64 ± 0.4% | 0.97 | 1.00 | 3.72 | 0.98 |
| other: a number before a unit, second text | 15 | 370.36 ± 0.4% | 408.75 ± 0.4% | 587.25 ± 0.4% | 39.93 ± 0.1% | 646.91 ± 0.8% | 890.04 ± 0.1% | 15307.92 ± 0.5% | 371.26 ± 0.6% | 0.91 | 1.00 | 9.27 | 0.57 |
| other: a heading's start tag | 13 | 333.92 ± 0.4% | 341.77 ± 0.5% | 457.62 ± 0.3% | 44.49 ± 0.9% | 643.46 ± 0.9% | 879.05 ± 0.1% | 18449.12 ± 0.3% | 335.11 ± 0.3% | 0.98 | 1.00 | 7.50 | 0.52 |
| other: a whole word | 11 | 534.01 ± 0.9% | 569.03 ± 0.9% | 984.34 ± 1.6% | 120.63 ± 0.4% | 579.35 ± 0.8% | 821.84 ± 0.9% | 27089.40 ± 0.7% | 533.28 ± 0.4% | 0.94 | 1.00 | 4.43 | 0.92 |
| other: a line's first word, second text | 17 | 484.10 ± 0.4% | 515.70 ± 0.1% | 850.84 ± 0.6% | 129.71 ± 0.1% | 722.83 ± 1.4% | refused | refused | 484.28 ± 0.3% | 0.94 | 1.00 | 3.73 | 0.67 |
| other: fourteen octets before an x | 16 | 106.01 ± 0.6% | 151.27 ± 0.6% | 177.08 ± 0.8% | 15.24 ± 0.3% | 464.00 ± 1.4% | 417.40 ± 0.2% | 12989.37 ± 0.3% | 106.34 ± 0.3% | 0.70 | 1.00 | 6.96 | 0.23 |
| other: a Greek word | 8 | 406.12 ± 0.2% | 556.27 ± 0.6% | 964.13 ± 0.3% | 59.00 ± 0.5% | 1412.11 ± 1.6% | 1820.36 ± 0.2% | refused | 406.25 ± 0.1% | 0.73 | 1.00 | 6.88 | 0.29 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15870.44 ± 0.8% | not timed | not timed | 16527.80 ± 0.8% | 2198.51 ± 9.3% | not timed | not timed | 15909.51 ± 0.7% | | 1.00 | 0.96 | 7.22 |
| 01-literal/sherlock-casei-en | 522 | 10965.59 ± 7.5% | not timed | not timed | 3603.85 ± 0.1% | 32.50 ± 0.1% | not timed | not timed | 10979.36 ± 1.4% | | 1.00 | 3.04 | 337.40 |
| 01-literal/sherlock-ru | 724 | 17167.91 ± 0.8% | not timed | not timed | 17383.28 ± 0.3% | 1502.05 ± 13.0% | not timed | not timed | 17192.59 ± 0.4% | | 1.00 | 0.99 | 11.43 |
| 01-literal/sherlock-casei-ru | 746 | 6146.32 ± 0.2% | not timed | not timed | 3336.58 ± 0.1% | 31.68 ± 7.7% | not timed | not timed | 6148.45 ± 0.6% | | 1.00 | 1.84 | 194.02 |
| 01-literal/sherlock-zh | 30 | 20016.93 ± 0.5% | not timed | not timed | 18884.62 ± 0.7% | 2729.24 ± 10.1% | not timed | not timed | 19985.58 ± 0.3% | | 1.00 | 1.06 | 7.33 |
| 02-literal-alternate/sherlock-en | 714 | 6146.45 ± 0.1% | not timed | not timed | 3948.94 ± 0.2% | 16.61 ± 0.2% | not timed | not timed | 6154.08 ± 0.1% | | 1.00 | 1.56 | 369.96 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1971.71 ± 1.4% | not timed | not timed | 697.55 ± 0.1% | 11.05 ± 0.1% | not timed | not timed | 1977.19 ± 0.8% | | 1.00 | 2.83 | 178.42 |
| 02-literal-alternate/sherlock-ru | 899 | 5513.31 ± 0.1% | not timed | not timed | 3255.96 ± 0.1% | 22.68 ± 0.2% | not timed | not timed | 5516.92 ± 0.0% | | 1.00 | 1.69 | 243.14 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2050.87 ± 0.4% | not timed | not timed | 1225.11 ± 0.7% | 9.14 ± 0.4% | not timed | not timed | 2050.84 ± 0.5% | | 1.00 | 1.67 | 224.29 |
| 02-literal-alternate/sherlock-zh | 207 | 7337.01 ± 0.3% | not timed | not timed | 4169.39 ± 0.1% | 31.53 ± 0.1% | not timed | not timed | 7351.55 ± 0.5% | | 1.00 | 1.76 | 232.67 |
| 03-date/ascii | 111817 | 134.58 ± 0.3% | not timed | not timed | 96.29 ± 0.1% | 0.20 ± 4.1% | not timed | not timed | 134.06 ± 0.5% | | 1.00 | 1.40 | 657.69 |
| 04-ruff-noqa/real | 84 | 436.12 ± 0.4% | not timed | not timed | 477.80 ± 0.1% | 19.42 ± 1.5% | not timed | not timed | 435.38 ± 0.2% | | 1.00 | 0.91 | 22.46 |
| 04-ruff-noqa/tweaked | 44 | 845.39 ± 0.1% | not timed | not timed | 461.58 ± 0.1% | 368.95 ± 0.4% | not timed | not timed | 846.98 ± 0.2% | | 1.00 | 1.83 | 2.29 |
| 05-lexer-veryl/single | 124800 | 5.43 ± 4.0% | not timed | not timed | 5.18 ± 0.1% | 0.20 ± 8.2% | not timed | not timed | 5.59 ± 0.4% | | 0.97 | 1.05 | 26.62 |
| 06-cloud-flare-redos/original | 107 | 440.76 ± 0.2% | not timed | not timed | 216.01 ± 0.1% | 24.85 ± 0.1% | not timed | not timed | 441.07 ± 0.1% | | 1.00 | 2.04 | 17.74 |
| 06-cloud-flare-redos/simplified-short | 102 | 439.86 ± 0.1% | not timed | not timed | 229.00 ± 0.1% | 26.58 ± 0.1% | not timed | not timed | 439.15 ± 0.1% | | 1.00 | 1.92 | 16.55 |
| 06-cloud-flare-redos/simplified-long | 10000 | 628.96 ± 0.1% | not timed | not timed | 253.85 ± 0.2% | 28.85 ± 0.2% | not timed | not timed | 629.19 ± 0.1% | | 1.00 | 2.48 | 21.80 |
| 07-unicode-character-data/parse-line | 558784 | 236.35 ± 2.5% | not timed | not timed | 178.36 ± 0.1% | 43.83 ± 4.2% | not timed | not timed | 236.19 ± 0.4% | | 1.00 | 1.33 | 5.39 |
| 08-words/all-english | 56691 | 129.17 ± 0.7% | not timed | not timed | 83.17 ± 0.2% | 11.91 ± 3.1% | not timed | not timed | 129.02 ± 0.4% | | 1.00 | 1.55 | 10.84 |
| 08-words/long-english | 839 | 614.05 ± 0.7% | not timed | not timed | 597.45 ± 0.2% | 32.38 ± 0.4% | not timed | not timed | 615.55 ± 0.5% | | 1.00 | 1.03 | 18.96 |
| 09-aws-keys/full | 0 | 441.32 ± 0.3% | not timed | not timed | 476.79 ± 0.1% | 64.61 ± 2.0% | not timed | not timed | 440.29 ± 0.2% | | 1.00 | 0.93 | 6.83 |
| 09-aws-keys/quick | 0 | 877.03 ± 0.3% | not timed | not timed | 1001.13 ± 0.1% | 427.13 ± 0.7% | not timed | not timed | 876.95 ± 0.2% | | 1.00 | 0.88 | 2.05 |
| 10-bounded-repeat/letters-en | 1833 | 587.80 ± 3.1% | not timed | not timed | 515.08 ± 0.2% | 19.54 ± 0.5% | not timed | not timed | 575.92 ± 3.3% | | 1.02 | 1.14 | 30.07 |
| 10-bounded-repeat/letters-ru | 3475 | 505.17 ± 1.6% | not timed | not timed | 478.47 ± 0.1% | 22.31 ± 14.1% | not timed | not timed | 503.75 ± 2.3% | | 1.00 | 1.06 | 22.64 |
| 10-bounded-repeat/context | 53 | 85.35 ± 2.0% | not timed | not timed | 66.57 ± 0.7% | 19.82 ± 0.2% | not timed | not timed | 86.00 ± 1.7% | | 0.99 | 1.28 | 4.31 |
| 10-bounded-repeat/capitals | 11 | 637.56 ± 8.3% | not timed | not timed | 617.10 ± 0.0% | 36.29 ± 0.1% | not timed | not timed | 636.15 ± 8.5% | | 1.00 | 1.03 | 17.57 |
| 11-unstructured-to-json/extract | 600 | 57.51 ± 0.8% | not timed | not timed | 76.62 ± 0.3% | 49.20 ± 0.4% | not timed | not timed | 57.45 ± 0.5% | | 1.00 | 0.75 | 1.17 |
| 12-dictionary/single | 1 | 559.73 ± 1.8% | not timed | not timed | 563.06 ± 0.0% | 0.41 ± 0.1% | not timed | not timed | 560.69 ± 1.0% | | 1.00 | 0.99 | 1376.37 |
| 14-quadratic/1x | 100 | 21.93 ± 1.9% | not timed | not timed | 10.00 ± 0.0% | 0.98 ± 4.5% | not timed | not timed | 22.09 ± 1.1% | | 0.99 | 2.19 | 22.40 |
| 14-quadratic/2x | 200 | 19.78 ± 1.3% | not timed | not timed | 5.52 ± 0.3% | 0.54 ± 1.2% | not timed | not timed | 19.77 ± 1.2% | | 1.00 | 3.58 | 36.88 |
| 14-quadratic/10x | 1000 | 12.34 ± 0.2% | not timed | not timed | 1.21 ± 0.4% | 0.12 ± 1.7% | not timed | not timed | 12.34 ± 0.8% | | 1.00 | 10.17 | 106.99 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.21 ± 2.2% | not timed | not timed | 0.35 ± 0.4% | 0.57 ± 3.3% | not timed | not timed | 1.22 ± 1.2% | | 1.00 | 3.47 | 2.14 |
| 04-ruff-noqa/compile-real | 1 | 102.83 ± 0.8% | not timed | not timed | 13.91 ± 0.4% | 144.95 ± 2.1% | not timed | not timed | 103.19 ± 1.3% | | 1.00 | 7.39 | 0.71 |
| 05-lexer-veryl/compile-single | 1 | 13.96 ± 1.4% | not timed | not timed | 2.55 ± 0.7% | 6.62 ± 1.4% | not timed | not timed | 13.96 ± 1.2% | | 1.00 | 5.47 | 2.11 |
| 07-unicode-character-data/compile | 1 | 107.09 ± 0.2% | not timed | not timed | 26.26 ± 0.3% | 37.50 ± 1.9% | not timed | not timed | 107.20 ± 0.6% | | 1.00 | 4.08 | 2.86 |
| 09-aws-keys/compile-full | 1 | 52.32 ± 0.7% | not timed | not timed | 8.34 ± 0.3% | 23.97 ± 0.9% | not timed | not timed | 52.47 ± 0.7% | | 1.00 | 6.28 | 2.18 |
| 09-aws-keys/compile-quick | 1 | 180.86 ± 0.9% | not timed | not timed | 48.86 ± 0.2% | 138.71 ± 2.8% | not timed | not timed | 182.19 ± 1.2% | | 0.99 | 3.70 | 1.30 |
| 10-bounded-repeat/compile-context | 1 | 69.90 ± 1.4% | not timed | not timed | 11.24 ± 0.2% | 16.80 ± 3.0% | not timed | not timed | 71.03 ± 1.6% | | 0.98 | 6.22 | 4.16 |
| 10-bounded-repeat/compile-capitals | 1 | 83.46 ± 0.8% | not timed | not timed | 8.11 ± 0.3% | 24.65 ± 1.7% | not timed | not timed | 83.84 ± 0.3% | | 1.00 | 10.29 | 3.39 |
| 11-unstructured-to-json/compile | 1 | 168.65 ± 0.2% | not timed | not timed | 40.92 ± 1.0% | 70.66 ± 2.0% | not timed | not timed | 169.22 ± 0.3% | | 1.00 | 4.12 | 2.39 |
| 12-dictionary/compile-single | 1 | 0.35 ± 1.5% | not timed | not timed | 0.07 ± 0.3% | 0.10 ± 7.9% | not timed | not timed | 0.35 ± 0.5% | | 1.00 | 4.91 | 3.41 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.54 ± 4.2% | not timed | not timed | 6.55 ± 0.1% | 0.55 ± 15.6% | not timed | not timed | 7.56 ± 1.8% | | 1.00 | 1.15 | 13.80 |
| dictionary/search/english-10 | 690 | 212.13 ± 1.4% | not timed | not timed | 166.31 ± 1.0% | 0.00 ± 0.5% | not timed | not timed | 207.01 ± 1.6% | | 1.02 | 1.28 | 67038.01 |
| dictionary/search/english-15 | 15 | 558.39 ± 1.6% | not timed | not timed | 561.12 ± 0.1% | 0.37 ± 0.5% | not timed | not timed | 559.76 ± 1.6% | | 1.00 | 1.00 | 1499.50 |
| folly/awyer-inn-busted | 1 | 21513.81 ± 0.1% | not timed | not timed | 129.09 ± 0.1% | 43.82 ± 0.3% | not timed | not timed | 21577.83 ± 0.2% | | 1.00 | 166.66 | 491.00 |
| folly/literal-never-match-rare | 0 | 21187.07 ± 1.2% | not timed | not timed | 19977.23 ± 0.1% | 41184.30 ± 0.3% | not timed | not timed | 21192.58 ± 0.1% | | 1.00 | 1.06 | 0.51 |
| folly/literal-never-match-frequent | 0 | 12549.09 ± 0.7% | not timed | not timed | 19942.98 ± 0.1% | 2197.49 ± 0.8% | not timed | not timed | 12550.70 ± 0.5% | | 1.00 | 0.63 | 5.71 |
| folly/literal-never-match-tricksy | 1 | 3262.26 ± 0.4% | not timed | not timed | 4407.91 ± 0.1% | 3057.54 ± 1.6% | not timed | not timed | 3261.48 ± 0.5% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1301.38 ± 0.4% | not timed | not timed | 956.98 ± 0.2% | 386.32 ± 16.5% | not timed | not timed | 1308.55 ± 0.4% | | 0.99 | 1.36 | 3.37 |
| grep/long-words-ascii | 5073 | 458.72 ± 0.2% | not timed | not timed | 470.24 ± 0.2% | 46.18 ± 6.6% | not timed | not timed | 459.51 ± 0.3% | | 1.00 | 0.98 | 9.93 |
| imported/leipzig/twain | 811 | 20833.22 ± 6.4% | not timed | not timed | 19663.28 ± 0.2% | 11947.06 ± 9.8% | not timed | not timed | 20847.84 ± 0.5% | | 1.00 | 1.06 | 1.74 |
| imported/leipzig/twain-insensitive | 965 | 9094.05 ± 1.2% | not timed | not timed | 4258.18 ± 0.2% | 36.25 ± 0.1% | not timed | not timed | 9157.79 ± 1.3% | | 0.99 | 2.14 | 250.86 |
| imported/leipzig/shing | 1540 | 15285.72 ± 3.2% | not timed | not timed | 13355.72 ± 0.1% | 32.91 ± 0.1% | not timed | not timed | 15597.81 ± 3.6% | | 0.98 | 1.14 | 464.47 |
| imported/leipzig/huck-saw | 262 | 8282.42 ± 3.0% | not timed | not timed | 5609.38 ± 0.1% | 30.89 ± 1.0% | not timed | not timed | 8465.16 ± 2.9% | | 0.98 | 1.48 | 268.16 |
| imported/leipzig/word-ending-nn | 262 | 598.25 ± 0.2% | not timed | not timed | 615.61 ± 0.1% | 24.24 ± 0.9% | not timed | not timed | 604.48 ± 1.6% | | 0.99 | 0.97 | 24.68 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11251.52 ± 1.3% | not timed | not timed | 4473.90 ± 1.0% | 11.39 ± 0.2% | not timed | not timed | 11342.62 ± 1.4% | | 0.99 | 2.51 | 987.51 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7800.27 ± 2.3% | not timed | not timed | 5495.46 ± 0.1% | 16.88 ± 0.1% | not timed | not timed | 7954.80 ± 2.7% | | 0.98 | 1.42 | 462.15 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4174.40 ± 0.8% | not timed | not timed | 418.33 ± 1.3% | 11.10 ± 0.1% | not timed | not timed | 4203.37 ± 0.8% | | 0.99 | 9.98 | 376.13 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7286.95 ± 4.0% | not timed | not timed | 615.65 ± 0.1% | 10.84 ± 0.1% | not timed | not timed | 7494.33 ± 3.1% | | 0.97 | 11.84 | 672.01 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7137.62 ± 4.1% | not timed | not timed | 615.08 ± 0.1% | 9.53 ± 0.1% | not timed | not timed | 7314.29 ± 3.3% | | 0.98 | 11.60 | 748.95 |
| imported/leipzig/tom-river | 2 | 6543.90 ± 2.0% | not timed | not timed | 5159.10 ± 0.1% | 30.24 ± 0.3% | not timed | not timed | 6607.85 ± 1.8% | | 0.99 | 1.27 | 216.43 |
| imported/leipzig/ing | 78424 | 602.01 ± 0.9% | not timed | not timed | 571.20 ± 0.1% | 27.63 ± 3.9% | not timed | not timed | 601.48 ± 0.8% | | 1.00 | 1.05 | 21.79 |
| imported/leipzig/ing-whitespace | 55248 | 1927.76 ± 1.3% | not timed | not timed | 1976.77 ± 0.3% | 20.28 ± 2.5% | not timed | not timed | 1939.12 ± 1.1% | | 0.99 | 0.98 | 95.07 |
| imported/leipzig/awyer-inn | 209 | 6418.44 ± 1.1% | not timed | not timed | 4282.29 ± 0.1% | 22.14 ± 0.1% | not timed | not timed | 6433.23 ± 1.1% | | 1.00 | 1.50 | 289.91 |
| imported/leipzig/quotes-bounded | 8886 | 2504.41 ± 0.7% | not timed | not timed | 3032.99 ± 0.1% | 37.74 ± 0.2% | not timed | not timed | 2517.05 ± 0.8% | | 0.99 | 0.83 | 66.35 |
| imported/leipzig/non-ascii-alternate | 2 | 12826.08 ± 2.8% | not timed | not timed | 5675.07 ± 0.2% | 50.82 ± 0.1% | not timed | not timed | 13111.66 ± 2.3% | | 0.98 | 2.26 | 252.38 |
| imported/leipzig/math-symbols | 69 | 1978.10 ± 1.3% | not timed | not timed | 618.63 ± 0.0% | 36.57 ± 0.2% | not timed | not timed | 1969.62 ± 1.0% | | 1.00 | 3.20 | 54.09 |
| imported/leipzig/bounded-strings-ending-z | 0 | 632.71 ± 2.5% | not timed | not timed | 615.33 ± 0.1% | 22.18 ± 0.9% | not timed | not timed | 626.64 ± 2.4% | | 1.01 | 1.03 | 28.52 |
| imported/lh3lh3-reb/uri | 17549 | 673.97 ± 0.2% | not timed | not timed | 1079.28 ± 0.5% | 28.30 ± 2.0% | not timed | not timed | 681.26 ± 0.3% | | 0.99 | 0.62 | 23.81 |
| imported/lh3lh3-reb/email | 15057 | 674.58 ± 0.2% | not timed | not timed | 1163.39 ± 0.2% | 30.72 ± 2.3% | not timed | not timed | 676.51 ± 0.0% | | 1.00 | 0.58 | 21.96 |
| imported/lh3lh3-reb/date | 668 | 892.03 ± 0.3% | not timed | not timed | 1040.85 ± 0.1% | 49.76 ± 3.7% | not timed | not timed | 890.87 ± 0.4% | | 1.00 | 0.86 | 17.93 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 644.76 ± 0.1% | not timed | not timed | 424.17 ± 0.1% | 15.68 ± 1.3% | not timed | not timed | 647.48 ± 0.1% | | 1.00 | 1.52 | 41.12 |
| imported/mariomka/email | 92 | 24292.30 ± 2.9% | not timed | not timed | 29265.58 ± 0.9% | 32.85 ± 0.2% | not timed | not timed | 24575.79 ± 0.5% | | 0.99 | 0.83 | 739.39 |
| imported/mariomka/uri | 5301 | 5577.15 ± 0.5% | not timed | not timed | 5917.16 ± 0.1% | 32.80 ± 0.5% | not timed | not timed | 5590.29 ± 0.7% | | 1.00 | 0.94 | 170.04 |
| imported/mariomka/ip | 5 | 2605.54 ± 2.9% | not timed | not timed | 2969.93 ± 0.1% | 21.07 ± 0.2% | not timed | not timed | 2609.09 ± 2.6% | | 1.00 | 0.88 | 123.67 |
| imported/rsc/no-exponential | 0 | 607.03 ± 0.3% | not timed | not timed | 317.79 ± 0.2% | 23.74 ± 0.3% | not timed | not timed | 608.49 ± 0.6% | | 1.00 | 1.91 | 25.57 |
| imported/rsc/literal | 1 | 1519.87 ± 1.8% | not timed | not timed | 1500.51 ± 8.1% | 184.67 ± 18.2% | not timed | not timed | 1518.90 ± 3.7% | | 1.00 | 1.01 | 8.23 |
| imported/rsc/not-literal | 2 | 778.26 ± 8.6% | not timed | not timed | 744.79 ± 0.1% | 46.29 ± 0.7% | not timed | not timed | 780.19 ± 0.2% | | 1.00 | 1.04 | 16.81 |
| imported/rsc/match-class | 1 | 1474.60 ± 2.5% | not timed | not timed | 1668.93 ± 0.5% | 58.72 ± 12.6% | not timed | not timed | 1476.32 ± 0.6% | | 1.00 | 0.88 | 25.11 |
| imported/rsc/match-class-in-range | 1 | 1470.95 ± 2.7% | not timed | not timed | 2272.70 ± 6.6% | 59.86 ± 6.2% | not timed | not timed | 1478.72 ± 0.4% | | 0.99 | 0.65 | 24.57 |
| imported/rsc/match-class-unicode | 1 | 538.02 ± 0.6% | not timed | not timed | 510.01 ± 0.1% | 72.13 ± 0.0% | not timed | not timed | 541.72 ± 0.5% | | 0.99 | 1.05 | 7.46 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1459.85 ± 0.3% | not timed | not timed | 938.42 ± 0.1% | 227.65 ± 0.6% | not timed | not timed | 1452.91 ± 0.0% | | 1.00 | 1.56 | 6.41 |
| imported/rsc/anchored-literal-long-non-match | 0 | 20954.96 ± 0.1% | not timed | not timed | 14172.76 ± 0.1% | 3413.93 ± 0.7% | not timed | not timed | 21797.99 ± 0.3% | | 0.96 | 1.48 | 6.14 |
| imported/rsc/anchored-literal-short-match | 4 | 722.58 ± 1.6% | not timed | not timed | 489.29 ± 0.2% | 83.15 ± 9.6% | not timed | not timed | 721.33 ± 0.4% | | 1.00 | 1.48 | 8.69 |
| imported/rsc/anchored-literal-long-match | 4 | 10507.59 ± 0.7% | not timed | not timed | 7296.15 ± 0.3% | 1240.29 ± 1.7% | not timed | not timed | 10803.75 ± 0.7% | | 0.97 | 1.44 | 8.47 |
| imported/rsc/one-pass-short | 17 | 369.14 ± 10.8% | not timed | not timed | 217.43 ± 0.2% | 31.24 ± 12.4% | not timed | not timed | 368.58 ± 1.3% | | 1.00 | 1.70 | 11.82 |
| imported/rsc/one-pass-short-not | 17 | 269.90 ± 2.8% | not timed | not timed | 226.52 ± 0.3% | 29.92 ± 11.0% | not timed | not timed | 270.61 ± 1.8% | | 1.00 | 1.19 | 9.02 |
| imported/rsc/one-pass-long-prefix | 26 | 361.98 ± 1.6% | not timed | not timed | 284.91 ± 0.1% | 99.40 ± 15.0% | not timed | not timed | 361.08 ± 5.8% | | 1.00 | 1.27 | 3.64 |
| imported/rsc/one-pass-long-prefix-not | 26 | 358.85 ± 4.6% | not timed | not timed | 286.67 ± 0.8% | 65.50 ± 20.8% | not timed | not timed | 361.73 ± 1.4% | | 0.99 | 1.25 | 5.48 |
| imported/rsc/long-needle1 | 31 | 21941.84 ± 0.1% | not timed | not timed | 20152.53 ± 0.1% | 3.75 ± 0.2% | not timed | not timed | 21944.20 ± 0.1% | | 1.00 | 1.09 | 5845.87 |
| imported/rsc/long-needle2 | 31 | 22078.63 ± 0.2% | not timed | not timed | 216.14 ± 0.2% | 3.74 ± 0.3% | not timed | not timed | 22086.41 ± 0.0% | | 1.00 | 102.15 | 5897.05 |
| imported/rsc/easy0-32 | 26 | 1585.18 ± 1.4% | not timed | not timed | 1511.65 ± 0.4% | 148.98 ± 17.0% | not timed | not timed | 1571.95 ± 0.7% | | 1.01 | 1.05 | 10.64 |
| imported/rsc/easy0-1k | 26 | 13595.25 ± 1.3% | not timed | not timed | 12357.92 ± 0.4% | 2312.80 ± 11.8% | not timed | not timed | 13530.69 ± 2.0% | | 1.00 | 1.10 | 5.88 |
| imported/rsc/easy0-32k | 26 | 22767.08 ± 0.1% | not timed | not timed | 20312.27 ± 0.1% | 18705.55 ± 27.2% | not timed | not timed | 22754.27 ± 1.1% | | 1.00 | 1.12 | 1.22 |
| imported/rsc/easy0-1mb | 26 | 22061.36 ± 0.7% | not timed | not timed | 19971.43 ± 1.5% | 38358.47 ± 1.0% | not timed | not timed | 22036.28 ± 0.9% | | 1.00 | 1.10 | 0.58 |
| imported/rsc/easy1-32 | 19 | 774.95 ± 7.9% | not timed | not timed | 627.58 ± 0.4% | 137.34 ± 20.8% | not timed | not timed | 769.46 ± 2.0% | | 1.01 | 1.23 | 5.64 |
| imported/rsc/easy1-1k | 19 | 15865.92 ± 3.0% | not timed | not timed | 12738.50 ± 0.1% | 2479.81 ± 17.6% | not timed | not timed | 15737.81 ± 1.6% | | 1.01 | 1.25 | 6.40 |
| imported/rsc/easy1-32k | 19 | 495853.14 ± 2.2% | not timed | not timed | 399837.79 ± 0.1% | 20355.46 ± 30.0% | not timed | not timed | 492951.14 ± 0.3% | | 1.01 | 1.24 | 24.36 |
| imported/rsc/easy1-1mb | 19 | 15931611.66 ± 0.5% | not timed | not timed | 12989306.90 ± 0.5% | 38055.93 ± 2.9% | not timed | not timed | 15842644.39 ± 0.2% | | 1.01 | 1.23 | 418.64 |
| imported/rsc/medium-32 | 27 | 739.33 ± 6.4% | not timed | not timed | 632.87 ± 0.5% | 69.74 ± 1.8% | not timed | not timed | 740.42 ± 0.1% | | 1.00 | 1.17 | 10.60 |
| imported/rsc/medium-1k | 27 | 13168.28 ± 0.3% | not timed | not timed | 11182.33 ± 0.3% | 72.31 ± 0.1% | not timed | not timed | 13099.86 ± 0.2% | | 1.01 | 1.18 | 182.10 |
| imported/rsc/medium-32k | 27 | 410967.97 ± 0.2% | not timed | not timed | 350465.00 ± 0.2% | 48.85 ± 0.1% | not timed | not timed | 409177.38 ± 0.3% | | 1.00 | 1.17 | 8412.58 |
| imported/rsc/medium-1mb | 27 | 13153146.24 ± 0.2% | not timed | not timed | 11128082.84 ± 0.1% | 48.91 ± 0.2% | not timed | not timed | 13065561.86 ± 0.4% | | 1.01 | 1.18 | 268899.19 |
| imported/rsc/hard-32 | 58 | 423.49 ± 1.7% | not timed | not timed | 365.10 ± 0.1% | 49.48 ± 7.1% | not timed | not timed | 421.37 ± 0.3% | | 1.01 | 1.16 | 8.56 |
| imported/rsc/hard-1k | 27 | 12945.64 ± 0.2% | not timed | not timed | 11511.13 ± 0.1% | 40.72 ± 0.1% | not timed | not timed | 12856.47 ± 0.2% | | 1.01 | 1.12 | 317.89 |
| imported/rsc/hard-32k | 27 | 404396.95 ± 0.1% | not timed | not timed | 362170.02 ± 0.1% | 29.37 ± 0.1% | not timed | not timed | 401495.28 ± 0.1% | | 1.01 | 1.12 | 13766.99 |
| imported/rsc/hard-1mb | 51 | 8415200.87 ± 0.1% | not timed | not timed | 7272053.93 ± 0.1% | 29.46 ± 0.3% | not timed | not timed | 8378588.47 ± 0.3% | | 1.00 | 1.16 | 285651.60 |
| imported/rsc/reallyhard0-32 | 58 | 263.91 ± 2.2% | not timed | not timed | 223.92 ± 0.1% | 49.71 ± 8.6% | not timed | not timed | 264.55 ± 0.3% | | 1.00 | 1.18 | 5.31 |
| imported/rsc/reallyhard0-1k | 27 | 580.71 ± 0.9% | not timed | not timed | 585.27 ± 0.2% | 40.68 ± 0.2% | not timed | not timed | 579.41 ± 0.6% | | 1.00 | 0.99 | 14.28 |
| imported/rsc/reallyhard0-32k | 27 | 604.26 ± 1.0% | not timed | not timed | 613.17 ± 0.2% | 29.42 ± 0.1% | not timed | not timed | 599.89 ± 0.6% | | 1.01 | 0.99 | 20.54 |
| imported/rsc/reallyhard0-1mb | 51 | 626.14 ± 0.7% | not timed | not timed | 617.69 ± 0.1% | 29.45 ± 0.1% | not timed | not timed | 625.03 ± 1.1% | | 1.00 | 1.01 | 21.26 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.91 ± 1.6% | not timed | not timed | 197.52 ± 1.0% | 60.04 ± 13.7% | not timed | not timed | 286.42 ± 1.5% | | 0.99 | 1.44 | 4.75 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7069.30 ± 0.2% | not timed | not timed | 5923.71 ± 0.2% | 34.19 ± 0.8% | not timed | not timed | 7092.21 ± 0.1% | | 1.00 | 1.19 | 206.73 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21457.13 ± 0.1% | not timed | not timed | 19269.55 ± 0.1% | 24.70 ± 2.2% | not timed | not timed | 21478.01 ± 0.1% | | 1.00 | 1.11 | 868.57 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21586.58 ± 1.0% | not timed | not timed | 19800.38 ± 0.4% | 24.83 ± 0.4% | not timed | not timed | 21622.13 ± 0.4% | | 1.00 | 1.09 | 869.30 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 281.08 ± 1.7% | not timed | not timed | 146.56 ± 0.4% | 60.89 ± 11.8% | not timed | not timed | 281.93 ± 1.6% | | 1.00 | 1.92 | 4.62 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5929.04 ± 0.1% | not timed | not timed | 6170.15 ± 0.1% | 33.89 ± 2.5% | not timed | not timed | 5936.59 ± 0.1% | | 1.00 | 0.96 | 174.93 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21377.46 ± 0.1% | not timed | not timed | 19315.45 ± 0.1% | 24.29 ± 2.8% | not timed | not timed | 21389.26 ± 0.1% | | 1.00 | 1.11 | 880.19 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21384.08 ± 1.0% | not timed | not timed | 19817.96 ± 0.6% | 25.01 ± 1.0% | not timed | not timed | 21447.47 ± 0.4% | | 1.00 | 1.08 | 855.04 |
| imported/sherlock/name-sherlock | 776 | 19669.06 ± 1.8% | not timed | not timed | 18483.09 ± 0.5% | 10308.34 ± 28.7% | not timed | not timed | 19685.89 ± 1.5% | | 1.00 | 1.06 | 1.91 |
| imported/sherlock/name-holmes | 2766 | 15082.78 ± 1.5% | not timed | not timed | 15537.91 ± 0.1% | 3214.91 ± 13.6% | not timed | not timed | 15225.05 ± 1.6% | | 0.99 | 0.97 | 4.69 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19690.41 ± 1.3% | not timed | not timed | 18470.84 ± 0.4% | 8206.70 ± 25.5% | not timed | not timed | 19719.04 ± 1.5% | | 1.00 | 1.07 | 2.40 |
| imported/sherlock/name-sherlock-casei | 816 | 15668.31 ± 0.3% | not timed | not timed | 4025.25 ± 0.1% | 32.39 ± 0.2% | not timed | not timed | 15650.89 ± 0.1% | | 1.00 | 3.89 | 483.67 |
| imported/sherlock/name-holmes-casei | 2802 | 9344.08 ± 6.3% | not timed | not timed | 3316.26 ± 0.2% | 37.70 ± 3.5% | not timed | not timed | 9384.39 ± 1.6% | | 1.00 | 2.82 | 247.83 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12877.50 ± 7.3% | not timed | not timed | 3959.69 ± 0.1% | 32.53 ± 0.1% | not timed | not timed | 12849.97 ± 1.3% | | 1.00 | 3.25 | 395.90 |
| imported/sherlock/name-whitespace | 1461 | 15265.64 ± 1.0% | not timed | not timed | 14431.74 ± 0.2% | 6695.66 ± 19.6% | not timed | not timed | 15410.62 ± 1.4% | | 0.99 | 1.06 | 2.28 |
| imported/sherlock/name-alt1 | 1142 | 11653.82 ± 0.2% | not timed | not timed | 16423.45 ± 1.3% | 4154.91 ± 24.0% | not timed | not timed | 11646.17 ± 1.9% | | 1.00 | 0.71 | 2.80 |
| imported/sherlock/name-alt2 | 3542 | 8956.04 ± 0.4% | not timed | not timed | 3833.89 ± 0.3% | 31.21 ± 0.1% | not timed | not timed | 8979.59 ± 0.2% | | 1.00 | 2.34 | 286.95 |
| imported/sherlock/name-alt3 | 4507 | 5559.09 ± 0.6% | not timed | not timed | 3636.35 ± 0.1% | 9.95 ± 4.2% | not timed | not timed | 5544.04 ± 0.4% | | 1.00 | 1.53 | 558.89 |
| imported/sherlock/name-alt3-casei | 4593 | 1531.05 ± 2.7% | not timed | not timed | 286.04 ± 0.1% | 6.44 ± 0.3% | not timed | not timed | 1528.16 ± 1.3% | | 1.00 | 5.35 | 237.85 |
| imported/sherlock/name-alt4 | 3686 | 6461.03 ± 0.1% | not timed | not timed | 3779.84 ± 0.1% | 31.40 ± 0.4% | not timed | not timed | 6455.16 ± 0.1% | | 1.00 | 1.71 | 205.76 |
| imported/sherlock/name-alt4-casei | 4254 | 2821.72 ± 2.3% | not timed | not timed | 2590.39 ± 0.1% | 19.88 ± 0.2% | not timed | not timed | 2826.09 ± 1.1% | | 1.00 | 1.09 | 141.93 |
| imported/sherlock/name-alt5 | 4028 | 6386.10 ± 0.3% | not timed | not timed | 3755.77 ± 0.0% | 21.90 ± 0.1% | not timed | not timed | 6400.47 ± 0.4% | | 1.00 | 1.70 | 291.63 |
| imported/sherlock/name-alt5-casei | 4104 | 3501.58 ± 1.7% | not timed | not timed | 2225.57 ± 0.1% | 14.31 ± 0.4% | not timed | not timed | 3504.49 ± 1.0% | | 1.00 | 1.57 | 244.70 |
| imported/sherlock/no-match-uncommon | 0 | 21580.56 ± 0.4% | not timed | not timed | 19663.18 ± 0.5% | 36331.85 ± 0.5% | not timed | not timed | 21546.11 ± 0.6% | | 1.00 | 1.10 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21256.28 ± 0.3% | not timed | not timed | 19528.01 ± 0.7% | 1294.86 ± 1.4% | not timed | not timed | 21297.06 ± 0.5% | | 1.00 | 1.09 | 16.42 |
| imported/sherlock/no-match-really-common | 0 | 15980.70 ± 2.7% | not timed | not timed | 18663.52 ± 0.5% | 1293.50 ± 1.3% | not timed | not timed | 16106.21 ± 1.3% | | 0.99 | 0.86 | 12.35 |
| imported/sherlock/the-lower | 21654 | 2298.41 ± 0.9% | not timed | not timed | 2337.23 ± 0.3% | 237.88 ± 19.1% | not timed | not timed | 2305.66 ± 1.1% | | 1.00 | 0.98 | 9.66 |
| imported/sherlock/the-upper | 2223 | 12701.51 ± 0.8% | not timed | not timed | 13547.39 ± 1.6% | 2794.87 ± 15.0% | not timed | not timed | 12743.05 ± 1.0% | | 1.00 | 0.94 | 4.54 |
| imported/sherlock/the-casei | 23961 | 1993.99 ± 0.2% | not timed | not timed | 1309.82 ± 0.3% | 35.33 ± 28.3% | not timed | not timed | 1992.50 ± 1.2% | | 1.00 | 1.52 | 56.44 |
| imported/sherlock/everything-greedy | 581881 | 282.61 ± 1.0% | not timed | not timed | 164.03 ± 0.1% | 29.05 ± 33.1% | not timed | not timed | 280.85 ± 0.9% | | 1.01 | 1.72 | 9.73 |
| imported/sherlock/everything-greedy-nl | 594933 | 491.76 ± 0.1% | not timed | not timed | 214.34 ± 0.4% | 33.03 ± 0.2% | not timed | not timed | 490.81 ± 0.1% | | 1.00 | 2.29 | 14.89 |
| imported/sherlock/letters | 447175 | 61.78 ± 0.4% | not timed | not timed | 32.81 ± 0.2% | 6.84 ± 1.8% | not timed | not timed | 61.44 ± 0.2% | | 1.01 | 1.88 | 9.03 |
| imported/sherlock/letters-upper | 14180 | 447.57 ± 1.3% | not timed | not timed | 370.90 ± 0.0% | 29.69 ± 22.9% | not timed | not timed | 445.75 ± 0.2% | | 1.00 | 1.21 | 15.08 |
| imported/sherlock/letters-lower | 432995 | 62.54 ± 0.4% | not timed | not timed | 33.73 ± 0.2% | 5.89 ± 18.2% | not timed | not timed | 62.46 ± 0.2% | | 1.00 | 1.85 | 10.61 |
| imported/sherlock/words | 447639 | 113.20 ± 1.0% | not timed | not timed | 82.72 ± 0.2% | 14.06 ± 4.3% | not timed | not timed | 113.19 ± 0.3% | | 1.00 | 1.37 | 8.05 |
| imported/sherlock/before-holmes | 4073 | 10244.17 ± 0.5% | not timed | not timed | 8491.13 ± 0.3% | 23.91 ± 1.3% | not timed | not timed | 10274.63 ± 0.2% | | 1.00 | 1.21 | 428.43 |
| imported/sherlock/before-after-holmes | 2593 | 9874.32 ± 1.3% | not timed | not timed | 9550.26 ± 0.5% | 24.12 ± 0.7% | not timed | not timed | 9899.13 ± 0.5% | | 1.00 | 1.03 | 409.39 |
| imported/sherlock/holmes-cochar-watson | 150 | 5212.64 ± 0.2% | not timed | not timed | 3430.81 ± 0.1% | 31.11 ± 0.2% | not timed | not timed | 5216.20 ± 0.2% | | 1.00 | 1.52 | 167.57 |
| imported/sherlock/holmes-coword-watson | 14309 | 1157.73 ± 0.3% | not timed | not timed | 1122.17 ± 0.1% | 6.78 ± 0.2% | not timed | not timed | 1156.80 ± 0.3% | | 1.00 | 1.03 | 170.66 |
| imported/sherlock/quotes | 14437 | 1577.04 ± 0.1% | not timed | not timed | 1757.85 ± 1.0% | 35.25 ± 0.1% | not timed | not timed | 1577.97 ± 0.2% | | 1.00 | 0.90 | 44.74 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17467.24 ± 0.3% | not timed | not timed | 16107.15 ± 0.4% | 36.72 ± 0.4% | not timed | not timed | 17330.62 ± 0.2% | | 1.01 | 1.08 | 475.64 |
| imported/sherlock/word-ending-n | 35297 | 481.21 ± 0.9% | not timed | not timed | 409.88 ± 0.1% | 23.65 ± 22.2% | not timed | not timed | 480.55 ± 0.4% | | 1.00 | 1.17 | 20.35 |
| imported/sherlock/repeated-class-negation | 2130 | 14848.18 ± 0.9% | not timed | not timed | 10989.02 ± 0.8% | 11.60 ± 0.5% | not timed | not timed | 14835.85 ± 0.6% | | 1.00 | 1.35 | 1280.46 |
| imported/sherlock/ing-suffix | 20547 | 558.96 ± 0.4% | not timed | not timed | 516.67 ± 0.1% | 28.86 ± 0.1% | not timed | not timed | 559.21 ± 0.3% | | 1.00 | 1.08 | 19.37 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1675.27 ± 0.2% | not timed | not timed | 2110.06 ± 0.3% | 20.53 ± 0.2% | not timed | not timed | 1677.86 ± 0.4% | | 1.00 | 0.79 | 81.59 |
| opt/accelerate/whole-line | 239963 | 457.41 ± 0.3% | not timed | not timed | 375.13 ± 0.3% | 92.49 ± 16.4% | not timed | not timed | 457.70 ± 0.2% | | 1.00 | 1.22 | 4.95 |
| opt/accelerate/non-dna | 16745 | 432.45 ± 0.2% | not timed | not timed | 397.89 ± 0.3% | 29.57 ± 18.7% | not timed | not timed | 431.77 ± 0.7% | | 1.00 | 1.09 | 14.62 |
| opt/backtrack/words-english | 40536 | 141.69 ± 7.0% | not timed | not timed | 94.30 ± 0.2% | 19.75 ± 7.0% | not timed | not timed | 141.51 ± 1.1% | | 1.00 | 1.50 | 7.17 |
| opt/fixed-length/too-small-ascii | 0 | 315.35 ± 0.3% | not timed | not timed | 675.11 ± 1.2% | 80.46 ± 1.0% | not timed | not timed | 314.81 ± 0.6% | | 1.00 | 0.47 | 3.92 |
| opt/fixed-length/too-big-ascii | 0 | 3473.80 ± 0.4% | not timed | not timed | 5791.45 ± 0.2% | 126.09 ± 0.3% | not timed | not timed | 3476.97 ± 0.4% | | 1.00 | 0.60 | 27.55 |
| opt/fixed-length/go33484-1 | 0 | 668381.93 ± 0.3% | not timed | not timed | 1121300.67 ± 0.6% | 61376.51 ± 0.5% | not timed | not timed | 667426.81 ± 0.5% | | 1.00 | 0.60 | 10.89 |
| opt/fixed-length/go33484-2 | 0 | 670178.88 ± 0.3% | not timed | not timed | 1116939.06 ± 0.6% | 31872.43 ± 1.0% | not timed | not timed | 668124.35 ± 0.5% | | 1.00 | 0.60 | 21.03 |
| opt/fixed-length/go33484-3 | 0 | 66789.67 ± 0.7% | not timed | not timed | 112231.72 ± 0.2% | 768.68 ± 0.6% | not timed | not timed | 66735.42 ± 0.4% | | 1.00 | 0.60 | 86.89 |
| opt/literal-alt/one-pattern | 1 | 549.73 ± 1.5% | not timed | not timed | 544.11 ± 0.1% | 0.39 ± 0.1% | not timed | not timed | 549.18 ± 1.7% | | 1.00 | 1.01 | 1398.86 |
| opt/onepass/fn-predicate | 916 | 364.80 ± 0.4% | not timed | not timed | 341.49 ± 0.1% | 204.75 ± 12.7% | not timed | not timed | 367.74 ± 1.0% | | 0.99 | 1.07 | 1.78 |
| opt/onepass/first-three-words-english | 35128 | 180.15 ± 5.3% | not timed | not timed | 201.98 ± 0.1% | 79.41 ± 10.5% | not timed | not timed | 181.81 ± 1.1% | | 0.99 | 0.89 | 2.27 |
| opt/prefilter/literal-english | 1 | 20499.91 ± 0.3% | not timed | not timed | 19870.46 ± 0.3% | 17565.64 ± 0.4% | not timed | not timed | 20451.86 ± 0.5% | | 1.00 | 1.03 | 1.17 |
| opt/prefilter/literal-casei-english | 1 | 14454.99 ± 0.5% | not timed | not timed | 4320.62 ± 0.1% | 32.80 ± 0.1% | not timed | not timed | 14441.03 ± 0.3% | | 1.00 | 3.35 | 440.66 |
| opt/prefilter/literal-russian | 1 | 21341.68 ± 0.5% | not timed | not timed | 19880.76 ± 0.6% | 3335.62 ± 0.1% | not timed | not timed | 21358.11 ± 0.8% | | 1.00 | 1.07 | 6.40 |
| opt/prefilter/literal-casei-russian | 1 | 8597.43 ± 0.6% | not timed | not timed | 3896.30 ± 0.3% | 31.86 ± 0.1% | not timed | not timed | 8587.60 ± 0.5% | | 1.00 | 2.21 | 269.83 |
| opt/prefilter/rust-functions | 948 | 6831.85 ± 0.8% | not timed | not timed | 9045.78 ± 0.2% | 1877.56 ± 0.3% | not timed | not timed | 6829.98 ± 0.2% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29531967.79 ± 0.1% | not timed | not timed | 20926718.12 ± 0.4% | 50.63 ± 0.3% | not timed | not timed | 29569126.89 ± 0.1% | | 1.00 | 1.41 | 583318.99 |
| opt/reverse-inner/holmes | 2593 | 9871.41 ± 0.8% | not timed | not timed | 9558.05 ± 0.5% | 23.83 ± 1.1% | not timed | not timed | 9903.96 ± 0.6% | | 1.00 | 1.03 | 414.32 |
| opt/reverse-inner/email | 47 | 37019.02 ± 0.6% | not timed | not timed | 45203.94 ± 0.7% | 32.34 ± 0.3% | not timed | not timed | 37020.59 ± 0.3% | | 1.00 | 0.82 | 1144.55 |
| opt/reverse-inner/factored-prefix | 3542 | 594.38 ± 0.7% | not timed | not timed | 598.41 ± 0.1% | 12.57 ± 0.1% | not timed | not timed | 590.03 ± 0.5% | | 1.01 | 0.99 | 47.29 |
| opt/reverse-inner/no-quadratic-backward | 0 | 21024.72 ± 0.1% | not timed | not timed | 615.05 ± 0.5% | 74.77 ± 0.1% | not timed | not timed | 21177.94 ± 0.1% | | 0.99 | 34.18 | 281.19 |
| opt/reverse-inner/no-quadratic-forward | 0 | 729.78 ± 1.9% | not timed | not timed | 288.17 ± 0.6% | 24.66 ± 0.1% | not timed | not timed | 738.75 ± 4.5% | | 0.99 | 2.53 | 29.59 |
| opt/reverse-suffix/holmes | 4073 | 10278.54 ± 0.6% | not timed | not timed | 8505.09 ± 0.1% | 23.95 ± 1.8% | not timed | not timed | 10290.93 ± 0.3% | | 1.00 | 1.21 | 429.17 |
| opt/reverse-suffix/no-quadratic | 0 | 21073.42 ± 0.1% | not timed | not timed | 616.16 ± 0.1% | 74.64 ± 0.1% | not timed | not timed | 21149.50 ± 0.1% | | 1.00 | 34.20 | 282.32 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 119.90 ± 7.2% | not timed | not timed | 132.30 ± 0.1% | 13.80 ± 16.3% | not timed | not timed | 119.84 ± 2.2% | | 1.00 | 0.91 | 8.69 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 119.84 ± 1.9% | not timed | not timed | 131.53 ± 0.1% | 13.19 ± 15.2% | not timed | not timed | 120.10 ± 1.1% | | 1.00 | 0.91 | 9.08 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.5% | not timed | not timed | 0.55 ± 0.2% | 112.41 ± 0.6% | not timed | not timed | 0.28 ± 0.2% | | 0.99 | 0.51 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 322.78 ± 0.2% | not timed | not timed | 294.27 ± 0.5% | 103.58 ± 7.4% | not timed | not timed | 323.63 ± 3.2% | | 1.00 | 1.10 | 3.12 |
| reported/i13-subset-regex/original-ascii | 4094 | 11225.89 ± 1.4% | not timed | not timed | 4471.72 ± 0.2% | 11.51 ± 0.1% | not timed | not timed | 11364.01 ± 1.0% | | 0.99 | 2.51 | 975.34 |
| reported/i13-subset-regex/original-unicode | 4094 | 10781.17 ± 1.7% | not timed | not timed | 254.54 ± 2.9% | 11.52 ± 0.1% | not timed | not timed | 11365.60 ± 1.5% | | 0.95 | 42.36 | 935.86 |
| reported/i13-subset-regex/big-ascii | 1955 | 10744.59 ± 1.6% | not timed | not timed | 68.20 ± 3.4% | 9.87 ± 0.1% | not timed | not timed | 10847.23 ± 1.2% | | 0.99 | 157.54 | 1088.97 |
| reported/i13-subset-regex/big-unicode | 1955 | 10629.81 ± 1.9% | not timed | not timed | 12.23 ± 54.9% | 9.86 ± 0.1% | not timed | not timed | 10805.03 ± 1.2% | | 0.98 | 869.31 | 1077.70 |
| reported/i13-subset-regex/huge-ascii | 55 | 10110.71 ± 3.9% | not timed | not timed | 10.99 ± 0.1% | 8.77 ± 0.2% | not timed | not timed | 10129.92 ± 3.9% | | 1.00 | 919.61 | 1152.60 |
| reported/i13-subset-regex/huge-unicode | 55 | 10115.57 ± 3.7% | not timed | not timed | 10.95 ± 0.3% | 8.78 ± 0.1% | not timed | not timed | 9886.09 ± 3.8% | | 1.02 | 923.96 | 1151.81 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.03 ± 0.1% | 8.78 ± 0.2% | not timed | not timed | 3.53 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.2% | not timed | not timed | 11.03 ± 0.3% | 8.77 ± 1.0% | not timed | not timed | 4.97 ± 0.1% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.00 ± 0.3% | not timed | not timed | 104.39 ± 0.1% | 6.64 ± 0.2% | not timed | not timed | 484.38 ± 0.1% | | 1.00 | 4.63 | 72.79 |
| reported/i787-keywords/opt-ascii | 5674 | 485.24 ± 0.2% | not timed | not timed | 274.33 ± 0.2% | 10.31 ± 0.1% | not timed | not timed | 483.36 ± 0.3% | | 1.00 | 1.77 | 47.06 |
| slow/quadratic-regex-1x | 100 | 7.08 ± 0.2% | not timed | not timed | 4.96 ± 0.1% | 0.05 ± 0.3% | not timed | not timed | 7.13 ± 0.4% | | 0.99 | 1.43 | 143.98 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.2% | not timed | not timed | 2.77 ± 0.2% | 0.01 ± 0.3% | not timed | not timed | 3.42 ± 0.2% | | 1.00 | 1.23 | 269.55 |
| slow/quadratic-haystack-1x | 100 | 22.04 ± 6.3% | not timed | not timed | 9.97 ± 0.2% | 1.01 ± 13.7% | not timed | not timed | 21.89 ± 2.2% | | 1.01 | 2.21 | 21.74 |
| slow/quadratic-haystack-2x | 200 | 19.76 ± 0.9% | not timed | not timed | 5.53 ± 0.2% | 0.55 ± 1.3% | not timed | not timed | 19.73 ± 6.7% | | 1.00 | 3.57 | 36.21 |
| unicode/codepoints/any-one | 1112064 | 282.28 ± 0.5% | not timed | not timed | 177.80 ± 0.2% | 18.77 ± 2.9% | not timed | not timed | 281.78 ± 0.3% | | 1.00 | 1.59 | 15.04 |
| unicode/codepoints/any-all | 4382592 | 281.47 ± 3.1% | not timed | not timed | 247.45 ± 0.4% | 117.58 ± 0.1% | not timed | not timed | 278.83 ± 0.8% | | 1.01 | 1.14 | 2.39 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.79 ± 0.5% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 600.61 ± 0.9% | not timed | not timed | 615.26 ± 0.3% | 135.74 ± 0.2% | not timed | not timed | 600.31 ± 1.0% | | 1.00 | 0.98 | 4.42 |
| unicode/overlapping-words/ascii | 6156 | 31.74 ± 0.1% | not timed | not timed | 38.22 ± 0.0% | 3.95 ± 1.2% | not timed | not timed | 31.85 ± 0.2% | | 1.00 | 0.83 | 8.04 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.1% | not timed | not timed | 3.76 ± 0.4% | 2.34 ± 0.7% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.38 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 9.6% | not timed | not timed | 3.61 ± 0.2% | 6.20 ± 9.8% | not timed | not timed | 1.27 ± 0.3% | | 1.01 | 0.35 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 128.22 ± 7.6% | not timed | not timed | 83.00 ± 0.2% | 13.52 ± 25.6% | not timed | not timed | 129.95 ± 0.5% | | 0.99 | 1.54 | 9.48 |
| unicode/word/boundary-long-english | 3466 | 605.13 ± 0.6% | not timed | not timed | 604.11 ± 0.2% | 32.71 ± 0.5% | not timed | not timed | 606.59 ± 0.6% | | 1.00 | 1.00 | 18.50 |
| unicode/word/around-holmes-english | 27 | 19778.53 ± 0.6% | not timed | not timed | 19628.67 ± 0.2% | 22.18 ± 1.5% | not timed | not timed | 19635.10 ± 0.4% | | 1.01 | 1.01 | 891.80 |
| wild/bibleref/long | 874 | 566.69 ± 0.2% | not timed | not timed | 582.32 ± 0.1% | 6.83 ± 0.2% | not timed | not timed | 568.99 ± 0.3% | | 1.00 | 0.97 | 83.03 |
| wild/bibleref/short | 30 | 25.14 ± 4.2% | not timed | not timed | 31.39 ± 0.7% | 14.08 ± 14.3% | not timed | not timed | 26.02 ± 0.8% | | 0.97 | 0.80 | 1.79 |
| wild/bibleref/line | 874 | 395.59 ± 0.1% | not timed | not timed | 219.00 ± 0.1% | 9.21 ± 0.1% | not timed | not timed | 396.29 ± 0.1% | | 1.00 | 1.81 | 42.96 |
| wild/caddy/caddy | 6 | 420.50 ± 0.8% | not timed | not timed | 242.23 ± 0.2% | 67.66 ± 12.9% | not timed | not timed | 419.51 ± 1.9% | | 1.00 | 1.74 | 6.21 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.45 ± 0.3% | not timed | not timed | 348.16 ± 0.2% | 13.54 ± 0.1% | not timed | not timed | 1064.06 ± 0.3% | | 1.01 | 3.07 | 79.08 |
| wild/ruff/noqa | 84 | 437.25 ± 0.5% | not timed | not timed | 467.38 ± 0.1% | 19.55 ± 2.0% | not timed | not timed | 436.69 ± 1.3% | | 1.00 | 0.94 | 22.36 |
| wild/ruff/unnecessary-coding-comment | 16 | 958.94 ± 0.5% | not timed | not timed | 701.24 ± 0.2% | 135.91 ± 10.7% | not timed | not timed | 962.65 ± 0.4% | | 1.00 | 1.37 | 7.06 |
| wild/ruff/string-quote-prefix | 2972 | 1366.85 ± 0.7% | not timed | not timed | 430.15 ± 0.1% | 318.12 ± 25.7% | not timed | not timed | 1365.70 ± 0.5% | | 1.00 | 3.18 | 4.30 |
| wild/ruff/space-around-operator | 1224378 | 222.12 ± 1.6% | not timed | not timed | 186.13 ± 0.0% | 18.36 ± 1.7% | not timed | not timed | 223.12 ± 1.7% | | 1.00 | 1.19 | 12.10 |
| wild/ruff/shebang | 282 | 970.91 ± 0.4% | not timed | not timed | 325.88 ± 0.1% | 112.16 ± 10.9% | not timed | not timed | 973.85 ± 0.3% | | 1.00 | 2.98 | 8.66 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13853.40 ± 0.6% | not timed | not timed | 13918.85 ± 0.2% | 6937.60 ± 1.1% | not timed | not timed | 13869.96 ± 0.2% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12865.15 ± 1.1% | not timed | not timed | 13563.93 ± 0.2% | 6442.71 ± 0.5% | not timed | not timed | 12902.59 ± 0.3% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13248.07 ± 1.5% | not timed | not timed | 13730.98 ± 0.5% | 6662.03 ± 1.4% | not timed | not timed | 13272.64 ± 0.4% | | 1.00 | 0.96 | 1.99 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9590.93 ± 0.2% | not timed | not timed | 13686.11 ± 0.1% | 6734.03 ± 0.9% | not timed | not timed | 9611.15 ± 0.3% | | 1.00 | 0.70 | 1.42 |
| wild/url/search | 234965 | 122.06 ± 14.0% | not timed | not timed | 66.59 ± 0.5% | 2.24 ± 0.9% | not timed | not timed | 122.60 ± 13.6% | | 1.00 | 1.83 | 54.38 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 8.5% | not timed | not timed | 0.01 ± 0.4% | 0.01 ± 20.0% | not timed | not timed | 0.03 ± 59.6% | | 0.99 | 2.99 | 3.55 |
| dictionary/compile/english-15 | 1 | 0.34 ± 0.4% | not timed | not timed | 0.07 ± 1.5% | 0.10 ± 14.8% | not timed | not timed | 0.35 ± 23.1% | | 1.00 | 4.87 | 3.30 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 1.5% | not timed | not timed | 0.02 ± 0.7% | 36.59 ± 6.8% | not timed | not timed | 0.24 ± 2.8% | | 0.98 | 12.28 | 0.0066 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.38 ± 1.3% | not timed | not timed | 11.54 ± 0.2% | 64.11 ± 23.5% | not timed | not timed | 46.53 ± 2.4% | | 1.00 | 4.02 | 0.72 |
| reported/i787-keywords/compile | 1 | 35.07 ± 2.6% | not timed | not timed | 2.15 ± 0.6% | 16.76 ± 20.4% | not timed | not timed | 35.04 ± 1.2% | | 1.00 | 16.28 | 2.09 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 339.53 ± 1.9% | not timed | not timed | 128.90 ± 0.3% | 626.11 ± 27.8% | not timed | not timed | 344.30 ± 2.3% | | 0.99 | 2.63 | 0.54 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.98 ± 1.7% | not timed | not timed | 4.10 ± 0.3% | 45.29 ± 8.4% | not timed | not timed | 47.65 ± 1.7% | | 0.99 | 11.45 | 1.04 |
| unicode/compile/one-letter | 53 | 6.59 ± 7.2% | not timed | not timed | 4.64 ± 0.4% | 71.77 ± 9.1% | not timed | not timed | 6.73 ± 4.2% | | 0.98 | 1.42 | 0.0918 |
| unicode/compile/fifty-letters | 1 | 1.03 ± 3.4% | not timed | not timed | 0.10 ± 0.7% | 72.43 ± 5.8% | not timed | not timed | 1.08 ± 16.8% | | 0.96 | 10.19 | 0.0142 |
| unicode/compile/fifty-letters-ascii | 1 | 193.51 ± 13.0% | not timed | not timed | 53.09 ± 0.2% | 205.75 ± 21.2% | not timed | not timed | 214.34 ± 6.4% | | 0.90 | 3.65 | 0.94 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 361.59 ± 14.0% | not timed | not timed | 47.35 ± 0.2% | 690.84 ± 19.8% | not timed | not timed | 366.64 ± 1.8% | | 0.99 | 7.64 | 0.52 |
| unicode/compile/match-every-line-ascii | 4 | 563.42 ± 2.5% | not timed | not timed | 146.46 ± 0.2% | 708.37 ± 22.6% | not timed | not timed | 578.05 ± 13.5% | | 0.97 | 3.85 | 0.80 |
| unicode/compile/negated-class-matches-codepoint | 1 | 297.50 ± 3.2% | not timed | not timed | 49.44 ± 0.3% | 1275.92 ± 5.1% | not timed | not timed | 307.64 ± 3.5% | | 0.97 | 6.02 | 0.23 |
| wild/bibleref/compile | 3 | 5.79 ± 4.3% | not timed | not timed | 1.95 ± 0.7% | 33.43 ± 3.1% | not timed | not timed | 5.90 ± 3.7% | | 0.98 | 2.97 | 0.17 |
| wild/url/compile | 1 | 0.63 ± 3.6% | not timed | not timed | 0.15 ± 0.6% | 0.41 ± 25.0% | not timed | not timed | 0.63 ± 0.7% | | 1.00 | 4.27 | 1.52 |

