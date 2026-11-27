# bench-regex

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
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
| literal: a word | 217 | 18653.06 ± 1.5% | 10814.84 ± 0.4% | 28.12 ± 0.6% | 17599.83 ± 4.9% | 9140.70 ± 7.4% | 17.43 ± 0.3% | 86.62 ± 1.0% | 18848.45 ± 2.1% | 1.72 | 0.99 | 1.06 | 2.04 |
| literal: a word that is not there | 0 | 21203.22 ± 3.4% | 9871.34 ± 0.6% | 28.40 ± 0.2% | 19531.28 ± 4.2% | 28245.96 ± 5.6% | 17.19 ± 0.2% | 80.85 ± 0.7% | 21416.13 ± 2.9% | 2.15 | 0.99 | 1.09 | 0.75 |
| literal: one of four words | 661 | 6434.67 ± 0.5% | 1789.85 ± 0.4% | 14.41 ± 0.1% | 3947.65 ± 0.3% | 21.90 ± 0.0% | 5.26 ± 0.1% | 6.94 ± 0.1% | 6437.88 ± 0.4% | 3.60 | 1.00 | 1.63 | 293.76 |
| literal: a word in any case | 217 | 15030.09 ± 0.4% | 1911.14 ± 0.3% | 21.54 ± 0.1% | 3967.02 ± 0.1% | 38.03 ± 0.4% | refused | differs | 15134.53 ± 1.0% | 7.86 | 0.99 | 3.79 | 395.20 |
| literal: an href attribute | 33 | 16268.02 ± 3.1% | 605.59 ± 0.6% | 27.24 ± 0.3% | 16416.76 ± 2.8% | 2255.26 ± 0.9% | 13.32 ± 0.4% | 75.55 ± 0.5% | 16276.29 ± 2.5% | 26.86 | 1.00 | 0.99 | 7.21 |
| literal: a word, second text | 123 | 19849.67 ± 4.8% | 4590.55 ± 0.3% | 27.94 ± 0.3% | 17811.86 ± 2.7% | 7643.99 ± 5.6% | 19.74 ± 0.2% | 70.99 ± 0.6% | 19758.44 ± 6.4% | 4.32 | 1.00 | 1.11 | 2.60 |
| class: two capitalized words | 1331 | 1180.29 ± 0.3% | 599.34 ± 0.3% | 25.93 ± 0.3% | 586.46 ± 0.3% | 40.65 ± 4.6% | 14.76 ± 0.2% | 68.09 ± 0.5% | 1177.38 ± 0.3% | 1.97 | 1.00 | 2.01 | 29.04 |
| class: a word that ends in ing | 3399 | 574.79 ± 0.1% | 573.75 ± 0.3% | 17.89 ± 0.2% | 548.44 ± 0.2% | 29.65 ± 12.5% | 8.12 ± 0.2% | 18.42 ± 0.2% | 575.51 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.38 |
| class: a word in capitals | 2332 | 1539.15 ± 0.4% | 605.48 ± 0.2% | 27.61 ± 0.4% | 573.18 ± 0.1% | 43.60 ± 13.4% | 17.22 ± 0.3% | 83.34 ± 0.6% | 1535.36 ± 0.4% | 2.54 | 1.00 | 2.69 | 35.30 |
| class: a number | 8288 | 2662.36 ± 0.6% | 836.38 ± 0.1% | 27.73 ± 0.3% | 1722.43 ± 0.3% | 42.96 ± 3.8% | 0.56 ± 0.1% | 57.22 ± 0.2% | 2671.37 ± 0.5% | 3.18 | 1.00 | 1.55 | 61.98 |
| class: two capitalized words, second text | 5359 | 521.37 ± 0.4% | 528.22 ± 0.5% | 23.25 ± 0.2% | 484.77 ± 0.1% | 35.51 ± 8.8% | 16.66 ± 0.1% | 63.32 ± 1.0% | 522.02 ± 0.3% | 0.99 | 1.00 | 1.08 | 14.68 |
| other: a word between two words | 6104 | 810.12 ± 0.1% | 602.46 ± 0.1% | 23.46 ± 0.3% | 738.74 ± 0.2% | 111.72 ± 23.4% | 11.25 ± 0.2% | 69.31 ± 1.0% | 811.88 ± 0.2% | 1.34 | 1.00 | 1.10 | 7.25 |
| other: a number before a unit, second text | 1481 | 6307.58 ± 1.8% | 1144.20 ± 0.5% | 25.98 ± 0.5% | 5643.96 ± 0.6% | 40.81 ± 0.1% | 17.72 ± 0.1% | 65.81 ± 0.2% | 6290.63 ± 1.3% | 5.51 | 1.00 | 1.12 | 154.57 |
| other: a heading's start tag | 110 | 13678.12 ± 1.9% | 739.27 ± 0.1% | 27.34 ± 0.3% | 1710.33 ± 0.2% | 1582.47 ± 5.2% | 16.33 ± 0.3% | 87.62 ± 0.6% | 13736.50 ± 1.6% | 18.50 | 1.00 | 8.00 | 8.64 |
| other: a whole word | 217 | 16018.78 ± 1.6% | 599.97 ± 0.6% | 28.74 ± 0.4% | 14331.77 ± 1.5% | 49.45 ± 0.2% | 13.49 ± 0.3% | 55.22 ± 0.6% | 16169.07 ± 2.5% | 26.70 | 0.99 | 1.12 | 323.95 |
| other: a line's first word, second text | 3716 | 2101.67 ± 0.5% | 592.30 ± 0.1% | 30.87 ± 0.4% | 1727.72 ± 0.5% | 62.63 ± 3.4% | refused | refused | 2105.92 ± 0.8% | 3.55 | 1.00 | 1.22 | 33.56 |
| other: fourteen octets before an x | 87 | 23552.51 ± 6.3% | 239.91 ± 0.3% | 6.48 ± 0.1% | 3994.52 ± 1.4% | 10.65 ± 0.2% | differs | 17.92 ± 0.1% | 22933.97 ± 9.1% | 98.17 | 1.03 | 5.90 | 2212.19 |
| other: a Greek word | 21815 | 528.81 ± 0.6% | 423.78 ± 0.1% | 30.43 ± 0.1% | 290.29 ± 0.5% | 43.95 ± 9.4% | differs | refused | 529.14 ± 0.8% | 1.25 | 1.00 | 1.82 | 12.03 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.72 ± 0.3% | 29.64 ± 0.2% | 0.86 ± 0.4% | 19.72 ± 0.5% | 2.77 ± 0.6% | differs | 4.04 ± 0.1% | 29.64 ± 0.3% | 1.00 | 1.00 | 1.51 | 10.72 |
| a UUID | 32895 | 24.67 ± 0.1% | 24.79 ± 0.2% | 0.64 ± 0.2% | 15.14 ± 0.6% | 3.12 ± 0.2% | 0.72 ± 0.2% | 3.60 ± 0.6% | 24.77 ± 0.1% | 1.00 | 1.00 | 1.63 | 7.92 |
| an IPv4 address | 33176 | 38.78 ± 0.2% | 38.84 ± 0.2% | 2.08 ± 0.5% | 29.19 ± 0.8% | 6.68 ± 0.2% | differs | 4.21 ± 0.2% | 38.81 ± 0.2% | 1.00 | 1.00 | 1.33 | 5.81 |
| a date and time | 32954 | 34.00 ± 0.2% | 34.19 ± 0.1% | 1.44 ± 0.3% | 21.42 ± 0.6% | 7.03 ± 0.3% | 1.19 ± 0.2% | 7.11 ± 0.1% | 34.16 ± 0.1% | 0.99 | 1.00 | 1.59 | 4.83 |
| a field path | 32606 | 32.80 ± 0.1% | 32.84 ± 0.1% | 1.02 ± 0.1% | 23.07 ± 0.1% | 3.51 ± 0.5% | differs | 2.96 ± 0.2% | 32.82 ± 0.1% | 1.00 | 1.00 | 1.42 | 9.35 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.24 ± 0.5% | 11.18 ± 0.6% | 11.19 ± 0.6% | 11.44 ± 0.2% | 4.95 ± 1.2% | 0.88 ± 0.4% | none | 11.19 ± 0.7% | 1.00 | 1.00 | 0.98 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 227.78 ± 0.2% | 227.72 ± 0.1% | 268.55 ± 0.2% | 85.50 ± 0.5% | 221.17 ± 3.7% | 481.98 ± 0.9% | 3743.59 ± 0.4% | 228.10 ± 0.2% | 1.00 | 1.00 | 2.66 | 1.03 |
| a UUID | 62 | 151.96 ± 0.3% | 152.02 ± 0.1% | 169.42 ± 0.3% | 45.68 ± 0.4% | 98.80 ± 7.0% | 181.63 ± 1.1% | 4368.04 ± 0.3% | 152.11 ± 0.4% | 1.00 | 1.00 | 3.33 | 1.54 |
| an IPv4 address | 29 | 418.18 ± 0.6% | 417.98 ± 0.4% | 581.72 ± 0.3% | 75.95 ± 0.7% | 131.38 ± 1.9% | 291.94 ± 1.0% | 7568.10 ± 0.2% | 418.03 ± 0.5% | 1.00 | 1.00 | 5.51 | 3.18 |
| a date and time | 56 | 300.77 ± 0.3% | 300.80 ± 0.1% | 376.30 ± 0.1% | 71.13 ± 1.4% | 137.75 ± 0.9% | 321.12 ± 1.1% | 4943.37 ± 0.4% | 300.94 ± 0.2% | 1.00 | 1.00 | 4.23 | 2.18 |
| a field path | 39 | 223.60 ± 0.3% | 223.57 ± 0.2% | 262.78 ± 0.1% | 79.61 ± 1.4% | 206.34 ± 1.5% | 491.18 ± 1.5% | 4744.17 ± 2.4% | 223.82 ± 0.1% | 1.00 | 1.00 | 2.81 | 1.08 |
| literal: a word | 7 | 603.92 ± 0.2% | 649.77 ± 0.5% | 1125.97 ± 0.1% | 497.93 ± 0.2% | 630.11 ± 2.1% | 927.72 ± 0.5% | 30400.92 ± 0.1% | 604.12 ± 0.6% | 0.93 | 1.00 | 1.21 | 0.96 |
| literal: a word that is not there | 8 | 585.66 ± 0.4% | 633.69 ± 1.2% | 1086.01 ± 0.2% | 456.05 ± 0.3% | 604.90 ± 2.2% | 895.92 ± 0.7% | 29142.30 ± 0.5% | 585.82 ± 0.3% | 0.92 | 1.00 | 1.28 | 0.97 |
| literal: one of four words | 26 | 244.04 ± 0.3% | 386.05 ± 0.2% | 522.27 ± 0.7% | 49.43 ± 1.1% | 242.81 ± 1.5% | 363.30 ± 0.6% | 15583.26 ± 0.2% | 244.13 ± 0.3% | 0.63 | 1.00 | 4.94 | 1.01 |
| literal: a word in any case | 11 | 436.20 ± 0.2% | 465.31 ± 0.3% | 677.44 ± 0.4% | 15.70 ± 0.2% | 650.19 ± 2.3% | refused | 23747.49 ± 0.2% | 437.07 ± 0.5% | 0.94 | 1.00 | 27.78 | 0.67 |
| literal: an href attribute | 12 | 339.38 ± 0.1% | 351.15 ± 0.0% | 459.15 ± 0.3% | 44.85 ± 1.5% | 500.14 ± 1.3% | 774.46 ± 1.2% | 21627.07 ± 0.3% | 339.22 ± 0.1% | 0.97 | 1.00 | 7.57 | 0.68 |
| literal: a word, second text | 10 | 539.83 ± 0.6% | 590.60 ± 0.2% | 969.74 ± 0.2% | 414.34 ± 0.5% | 539.72 ± 2.6% | 808.65 ± 0.3% | 27076.65 ± 0.2% | 539.85 ± 0.2% | 0.91 | 1.00 | 1.30 | 1.00 |
| class: two capitalized words | 23 | 432.48 ± 0.5% | 458.55 ± 0.3% | 659.12 ± 0.6% | 100.22 ± 2.7% | 497.81 ± 1.3% | 741.92 ± 0.7% | 6300.42 ± 0.3% | 432.37 ± 0.1% | 0.94 | 1.00 | 4.32 | 0.87 |
| class: a word that ends in ing | 9 | 552.28 ± 0.3% | 616.89 ± 0.4% | 1068.58 ± 0.1% | 132.47 ± 0.1% | 750.37 ± 1.3% | 1105.69 ± 0.4% | 15720.48 ± 0.1% | 553.10 ± 0.4% | 0.90 | 1.00 | 4.17 | 0.74 |
| class: a word in capitals | 16 | 493.42 ± 0.4% | 528.72 ± 0.4% | 836.29 ± 0.4% | 134.87 ± 1.0% | 747.09 ± 1.9% | 1028.76 ± 0.8% | 8296.69 ± 0.3% | 493.55 ± 0.1% | 0.93 | 1.00 | 3.66 | 0.66 |
| class: a number | 6 | 621.17 ± 0.2% | 677.17 ± 0.5% | 1248.12 ± 0.1% | 41.76 ± 1.1% | 1407.59 ± 0.7% | 1884.47 ± 1.0% | 22756.04 ± 0.1% | 620.67 ± 0.4% | 0.92 | 1.00 | 14.88 | 0.44 |
| class: two capitalized words, second text | 23 | 431.92 ± 0.4% | 458.99 ± 0.7% | 658.82 ± 0.9% | 101.30 ± 1.6% | 502.39 ± 0.8% | 761.58 ± 3.6% | 6305.15 ± 0.7% | 431.98 ± 0.4% | 0.94 | 1.00 | 4.26 | 0.86 |
| other: a word between two words | 13 | 527.54 ± 0.3% | 548.87 ± 0.3% | 864.26 ± 0.2% | 134.32 ± 0.5% | 500.57 ± 1.6% | 804.79 ± 0.5% | 14567.62 ± 0.4% | 527.92 ± 0.4% | 0.96 | 1.00 | 3.93 | 1.05 |
| other: a number before a unit, second text | 15 | 391.00 ± 0.3% | 428.76 ± 0.4% | 599.16 ± 0.2% | 39.60 ± 0.2% | 630.53 ± 1.3% | 889.76 ± 0.3% | 15132.48 ± 0.4% | 391.17 ± 0.1% | 0.91 | 1.00 | 9.87 | 0.62 |
| other: a heading's start tag | 13 | 349.63 ± 0.2% | 355.67 ± 0.6% | 467.09 ± 0.6% | 43.66 ± 0.5% | 628.75 ± 0.8% | 878.97 ± 0.2% | 18001.31 ± 0.3% | 349.99 ± 0.3% | 0.98 | 1.00 | 8.01 | 0.56 |
| other: a whole word | 11 | 562.32 ± 0.6% | 600.60 ± 0.6% | 988.86 ± 0.7% | 119.34 ± 0.2% | 564.06 ± 1.5% | 817.00 ± 0.4% | 26974.04 ± 0.7% | 560.31 ± 0.5% | 0.94 | 1.00 | 4.71 | 1.00 |
| other: a line's first word, second text | 17 | 508.41 ± 0.8% | 544.31 ± 0.2% | 863.10 ± 0.2% | 127.58 ± 0.2% | 707.05 ± 1.1% | refused | refused | 510.55 ± 0.2% | 0.93 | 1.00 | 3.99 | 0.72 |
| other: fourteen octets before an x | 16 | 108.39 ± 1.3% | 155.84 ± 0.8% | 178.05 ± 0.8% | 15.05 ± 0.5% | 451.97 ± 1.2% | 407.51 ± 0.5% | 12746.90 ± 0.2% | 108.62 ± 0.6% | 0.70 | 1.00 | 7.20 | 0.24 |
| other: a Greek word | 8 | 448.51 ± 0.4% | 588.95 ± 0.3% | 984.27 ± 0.5% | 58.17 ± 0.3% | 1392.06 ± 1.1% | 1846.76 ± 0.5% | refused | 448.70 ± 0.2% | 0.76 | 1.00 | 7.71 | 0.32 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15405.57 ± 1.2% | not timed | not timed | 15684.37 ± 1.7% | 1968.95 ± 15.3% | not timed | not timed | 15403.03 ± 1.3% | | 1.00 | 0.98 | 7.82 |
| 01-literal/sherlock-casei-en | 522 | 10946.32 ± 4.2% | not timed | not timed | 3600.86 ± 0.1% | 32.49 ± 0.3% | not timed | not timed | 10908.17 ± 2.0% | | 1.00 | 3.04 | 336.87 |
| 01-literal/sherlock-ru | 724 | 17137.11 ± 0.6% | not timed | not timed | 17219.57 ± 0.8% | 1509.86 ± 8.1% | not timed | not timed | 17158.86 ± 0.2% | | 1.00 | 1.00 | 11.35 |
| 01-literal/sherlock-casei-ru | 746 | 6138.48 ± 0.2% | not timed | not timed | 3334.52 ± 0.1% | 31.64 ± 1.2% | not timed | not timed | 6141.36 ± 0.2% | | 1.00 | 1.84 | 193.99 |
| 01-literal/sherlock-zh | 30 | 19352.29 ± 0.8% | not timed | not timed | 18269.43 ± 2.0% | 2805.11 ± 13.6% | not timed | not timed | 19314.86 ± 1.1% | | 1.00 | 1.06 | 6.90 |
| 02-literal-alternate/sherlock-en | 714 | 6143.39 ± 1.0% | not timed | not timed | 3942.90 ± 0.2% | 16.63 ± 0.3% | not timed | not timed | 6128.87 ± 0.6% | | 1.00 | 1.56 | 369.36 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1973.49 ± 1.3% | not timed | not timed | 697.52 ± 0.4% | 11.07 ± 0.1% | not timed | not timed | 1975.92 ± 0.9% | | 1.00 | 2.83 | 178.34 |
| 02-literal-alternate/sherlock-ru | 899 | 5507.14 ± 0.1% | not timed | not timed | 3253.38 ± 0.1% | 22.68 ± 0.2% | not timed | not timed | 5503.39 ± 0.3% | | 1.00 | 1.69 | 242.84 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2050.14 ± 0.5% | not timed | not timed | 1225.73 ± 0.6% | 9.16 ± 0.4% | not timed | not timed | 2050.82 ± 0.5% | | 1.00 | 1.67 | 223.92 |
| 02-literal-alternate/sherlock-zh | 207 | 7338.04 ± 1.0% | not timed | not timed | 4163.42 ± 0.4% | 31.55 ± 0.1% | not timed | not timed | 7298.70 ± 1.2% | | 1.01 | 1.76 | 232.60 |
| 03-date/ascii | 111817 | 133.75 ± 0.8% | not timed | not timed | 96.19 ± 0.2% | 0.20 ± 1.9% | not timed | not timed | 134.32 ± 0.5% | | 1.00 | 1.39 | 660.26 |
| 04-ruff-noqa/real | 84 | 438.46 ± 0.2% | not timed | not timed | 458.10 ± 0.2% | 19.57 ± 1.4% | not timed | not timed | 437.23 ± 0.3% | | 1.00 | 0.96 | 22.40 |
| 04-ruff-noqa/tweaked | 44 | 846.80 ± 0.1% | not timed | not timed | 459.66 ± 0.0% | 364.55 ± 0.4% | not timed | not timed | 845.69 ± 0.2% | | 1.00 | 1.84 | 2.32 |
| 05-lexer-veryl/single | 124800 | 5.25 ± 0.7% | not timed | not timed | 5.06 ± 0.2% | 0.20 ± 5.3% | not timed | not timed | 5.29 ± 0.5% | | 0.99 | 1.04 | 26.17 |
| 06-cloud-flare-redos/original | 107 | 439.67 ± 0.1% | not timed | not timed | 217.18 ± 0.1% | 24.72 ± 3.1% | not timed | not timed | 438.63 ± 4.8% | | 1.00 | 2.02 | 17.79 |
| 06-cloud-flare-redos/simplified-short | 102 | 439.01 ± 4.5% | not timed | not timed | 228.42 ± 0.1% | 25.92 ± 5.2% | not timed | not timed | 438.95 ± 0.6% | | 1.00 | 1.92 | 16.94 |
| 06-cloud-flare-redos/simplified-long | 10000 | 627.82 ± 0.3% | not timed | not timed | 256.22 ± 0.1% | 28.73 ± 0.4% | not timed | not timed | 629.29 ± 0.3% | | 1.00 | 2.45 | 21.85 |
| 07-unicode-character-data/parse-line | 558784 | 241.41 ± 0.4% | not timed | not timed | 171.36 ± 0.2% | 43.01 ± 1.3% | not timed | not timed | 243.14 ± 0.7% | | 0.99 | 1.41 | 5.61 |
| 08-words/all-english | 56691 | 129.00 ± 0.9% | not timed | not timed | 83.05 ± 0.2% | 13.22 ± 7.8% | not timed | not timed | 129.23 ± 0.5% | | 1.00 | 1.55 | 9.76 |
| 08-words/long-english | 839 | 614.65 ± 0.3% | not timed | not timed | 593.07 ± 0.1% | 32.79 ± 0.4% | not timed | not timed | 616.78 ± 0.7% | | 1.00 | 1.04 | 18.75 |
| 09-aws-keys/full | 0 | 442.78 ± 0.2% | not timed | not timed | 461.60 ± 0.2% | 64.53 ± 0.2% | not timed | not timed | 442.51 ± 0.2% | | 1.00 | 0.96 | 6.86 |
| 09-aws-keys/quick | 0 | 874.82 ± 0.2% | not timed | not timed | 995.61 ± 0.6% | 425.86 ± 0.4% | not timed | not timed | 875.17 ± 0.2% | | 1.00 | 0.88 | 2.05 |
| 10-bounded-repeat/letters-en | 1833 | 582.52 ± 3.0% | not timed | not timed | 517.42 ± 0.2% | 19.60 ± 0.3% | not timed | not timed | 578.18 ± 1.8% | | 1.01 | 1.13 | 29.72 |
| 10-bounded-repeat/letters-ru | 3475 | 505.84 ± 1.8% | not timed | not timed | 479.34 ± 0.2% | 23.72 ± 4.2% | not timed | not timed | 504.20 ± 0.9% | | 1.00 | 1.06 | 21.33 |
| 10-bounded-repeat/context | 53 | 84.99 ± 2.2% | not timed | not timed | 66.01 ± 0.7% | 19.78 ± 0.3% | not timed | not timed | 85.50 ± 1.3% | | 0.99 | 1.29 | 4.30 |
| 10-bounded-repeat/capitals | 11 | 638.17 ± 8.6% | not timed | not timed | 616.98 ± 0.1% | 36.62 ± 0.2% | not timed | not timed | 638.32 ± 8.7% | | 1.00 | 1.03 | 17.43 |
| 11-unstructured-to-json/extract | 600 | 57.95 ± 0.3% | not timed | not timed | 77.49 ± 0.2% | 49.09 ± 3.1% | not timed | not timed | 57.78 ± 0.3% | | 1.00 | 0.75 | 1.18 |
| 12-dictionary/single | 1 | 559.44 ± 1.6% | not timed | not timed | 558.66 ± 0.2% | 0.41 ± 0.3% | not timed | not timed | 560.67 ± 1.4% | | 1.00 | 1.00 | 1377.60 |
| 14-quadratic/1x | 100 | 21.98 ± 0.4% | not timed | not timed | 10.02 ± 0.1% | 0.97 ± 3.0% | not timed | not timed | 22.09 ± 1.3% | | 0.99 | 2.19 | 22.75 |
| 14-quadratic/2x | 200 | 19.80 ± 1.2% | not timed | not timed | 5.53 ± 0.2% | 0.53 ± 1.5% | not timed | not timed | 19.87 ± 0.6% | | 1.00 | 3.58 | 37.27 |
| 14-quadratic/10x | 1000 | 12.34 ± 0.2% | not timed | not timed | 1.21 ± 0.1% | 0.11 ± 1.5% | not timed | not timed | 12.34 ± 1.2% | | 1.00 | 10.17 | 107.79 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.27 ± 1.9% | not timed | not timed | 0.35 ± 0.5% | 0.56 ± 3.5% | not timed | not timed | 1.27 ± 1.8% | | 1.00 | 3.67 | 2.28 |
| 04-ruff-noqa/compile-real | 1 | 104.53 ± 1.6% | not timed | not timed | 13.65 ± 0.5% | 142.29 ± 2.4% | not timed | not timed | 105.05 ± 1.0% | | 1.00 | 7.66 | 0.73 |
| 05-lexer-veryl/compile-single | 1 | 14.06 ± 1.4% | not timed | not timed | 2.53 ± 0.9% | 6.50 ± 2.0% | not timed | not timed | 14.17 ± 0.6% | | 0.99 | 5.57 | 2.17 |
| 07-unicode-character-data/compile | 1 | 108.69 ± 1.9% | not timed | not timed | 25.46 ± 0.3% | 36.63 ± 1.7% | not timed | not timed | 108.86 ± 0.9% | | 1.00 | 4.27 | 2.97 |
| 09-aws-keys/compile-full | 1 | 53.07 ± 0.5% | not timed | not timed | 8.15 ± 0.2% | 23.46 ± 1.4% | not timed | not timed | 53.12 ± 0.3% | | 1.00 | 6.52 | 2.26 |
| 09-aws-keys/compile-quick | 1 | 187.86 ± 0.4% | not timed | not timed | 46.70 ± 0.1% | 136.18 ± 2.3% | not timed | not timed | 188.21 ± 0.2% | | 1.00 | 4.02 | 1.38 |
| 10-bounded-repeat/compile-context | 1 | 71.46 ± 1.8% | not timed | not timed | 11.16 ± 0.4% | 16.18 ± 1.1% | not timed | not timed | 71.38 ± 0.4% | | 1.00 | 6.41 | 4.42 |
| 10-bounded-repeat/compile-capitals | 1 | 86.01 ± 0.6% | not timed | not timed | 8.10 ± 0.2% | 23.74 ± 1.1% | not timed | not timed | 85.75 ± 1.0% | | 1.00 | 10.62 | 3.62 |
| 11-unstructured-to-json/compile | 1 | 173.38 ± 0.6% | not timed | not timed | 41.06 ± 0.2% | 69.29 ± 1.3% | not timed | not timed | 173.11 ± 1.6% | | 1.00 | 4.22 | 2.50 |
| 12-dictionary/compile-single | 1 | 0.35 ± 2.1% | not timed | not timed | 0.07 ± 39.4% | 0.09 ± 5.5% | not timed | not timed | 0.35 ± 2.0% | | 1.00 | 5.01 | 3.69 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.46 ± 1.7% | not timed | not timed | 6.51 ± 0.3% | 0.56 ± 17.2% | not timed | not timed | 7.42 ± 1.7% | | 1.00 | 1.15 | 13.22 |
| dictionary/search/english-10 | 690 | 207.03 ± 3.9% | not timed | not timed | 165.78 ± 0.5% | 0.00 ± 0.3% | not timed | not timed | 209.48 ± 1.3% | | 0.99 | 1.25 | 75685.82 |
| dictionary/search/english-15 | 15 | 557.54 ± 2.1% | not timed | not timed | 560.54 ± 0.1% | 0.37 ± 0.3% | not timed | not timed | 559.64 ± 1.8% | | 1.00 | 0.99 | 1487.48 |
| folly/awyer-inn-busted | 1 | 21498.10 ± 0.0% | not timed | not timed | 143.94 ± 0.4% | 43.84 ± 0.1% | not timed | not timed | 21571.55 ± 0.1% | | 1.00 | 149.36 | 490.43 |
| folly/literal-never-match-rare | 0 | 21177.45 ± 1.6% | not timed | not timed | 19944.08 ± 0.1% | 41069.33 ± 0.2% | not timed | not timed | 21175.93 ± 0.2% | | 1.00 | 1.06 | 0.52 |
| folly/literal-never-match-frequent | 0 | 12577.46 ± 0.9% | not timed | not timed | 19897.96 ± 0.2% | 2202.66 ± 1.0% | not timed | not timed | 12582.86 ± 0.5% | | 1.00 | 0.63 | 5.71 |
| folly/literal-never-match-tricksy | 1 | 3263.86 ± 0.6% | not timed | not timed | 4407.00 ± 0.3% | 3052.29 ± 0.0% | not timed | not timed | 3264.61 ± 0.6% | | 1.00 | 0.74 | 1.07 |
| grep/every-line | 239963 | 1301.48 ± 0.4% | not timed | not timed | 924.54 ± 0.2% | 371.35 ± 16.8% | not timed | not timed | 1303.68 ± 0.5% | | 1.00 | 1.41 | 3.50 |
| grep/long-words-ascii | 5073 | 459.12 ± 0.2% | not timed | not timed | 469.69 ± 0.2% | 46.16 ± 6.1% | not timed | not timed | 459.14 ± 0.1% | | 1.00 | 0.98 | 9.95 |
| imported/leipzig/twain | 811 | 20750.36 ± 6.6% | not timed | not timed | 19625.72 ± 0.5% | 12029.86 ± 9.3% | not timed | not timed | 20818.24 ± 0.3% | | 1.00 | 1.06 | 1.72 |
| imported/leipzig/twain-insensitive | 965 | 9081.28 ± 1.3% | not timed | not timed | 4252.98 ± 0.1% | 37.77 ± 0.5% | not timed | not timed | 9136.75 ± 0.7% | | 0.99 | 2.14 | 240.41 |
| imported/leipzig/shing | 1540 | 15302.97 ± 3.0% | not timed | not timed | 13529.55 ± 0.4% | 34.06 ± 0.1% | not timed | not timed | 15586.73 ± 3.4% | | 0.98 | 1.13 | 449.25 |
| imported/leipzig/huck-saw | 262 | 8285.34 ± 2.6% | not timed | not timed | 5608.58 ± 0.1% | 31.74 ± 0.1% | not timed | not timed | 8452.37 ± 2.0% | | 0.98 | 1.48 | 261.06 |
| imported/leipzig/word-ending-nn | 262 | 602.40 ± 0.8% | not timed | not timed | 617.61 ± 0.1% | 24.79 ± 0.2% | not timed | not timed | 603.58 ± 0.7% | | 1.00 | 0.98 | 24.30 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 11191.65 ± 1.2% | not timed | not timed | 4536.23 ± 0.6% | 11.51 ± 1.0% | not timed | not timed | 11271.14 ± 2.1% | | 0.99 | 2.47 | 972.37 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7762.07 ± 2.7% | not timed | not timed | 5492.90 ± 0.1% | 16.90 ± 0.1% | not timed | not timed | 7879.07 ± 2.4% | | 0.99 | 1.41 | 459.40 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4181.35 ± 0.6% | not timed | not timed | 417.86 ± 1.0% | 11.07 ± 0.2% | not timed | not timed | 4188.52 ± 0.5% | | 1.00 | 10.01 | 377.56 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 7233.30 ± 4.5% | not timed | not timed | 615.30 ± 0.1% | 11.11 ± 0.1% | not timed | not timed | 7466.89 ± 4.1% | | 0.97 | 11.76 | 650.99 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 7112.31 ± 4.3% | not timed | not timed | 616.06 ± 0.0% | 9.75 ± 0.0% | not timed | not timed | 7304.51 ± 3.1% | | 0.97 | 11.54 | 729.63 |
| imported/leipzig/tom-river | 2 | 6498.33 ± 1.9% | not timed | not timed | 5152.00 ± 0.1% | 30.86 ± 0.1% | not timed | not timed | 6600.96 ± 1.8% | | 0.98 | 1.26 | 210.55 |
| imported/leipzig/ing | 78424 | 601.02 ± 1.5% | not timed | not timed | 571.53 ± 0.1% | 28.31 ± 4.6% | not timed | not timed | 601.33 ± 1.4% | | 1.00 | 1.05 | 21.23 |
| imported/leipzig/ing-whitespace | 55248 | 1928.83 ± 0.7% | not timed | not timed | 2089.66 ± 1.0% | 20.57 ± 2.7% | not timed | not timed | 1938.86 ± 1.7% | | 0.99 | 0.92 | 93.77 |
| imported/leipzig/awyer-inn | 209 | 6373.88 ± 1.2% | not timed | not timed | 4284.87 ± 0.2% | 22.62 ± 0.1% | not timed | not timed | 6442.63 ± 1.2% | | 0.99 | 1.49 | 281.75 |
| imported/leipzig/quotes-bounded | 8886 | 2495.30 ± 1.3% | not timed | not timed | 3027.54 ± 0.2% | 38.29 ± 0.1% | not timed | not timed | 2515.56 ± 1.1% | | 0.99 | 0.82 | 65.16 |
| imported/leipzig/non-ascii-alternate | 2 | 12763.89 ± 2.7% | not timed | not timed | 5673.78 ± 0.1% | 50.50 ± 0.0% | not timed | not timed | 13080.80 ± 3.3% | | 0.98 | 2.25 | 252.73 |
| imported/leipzig/math-symbols | 69 | 1980.97 ± 0.4% | not timed | not timed | 613.40 ± 0.1% | 36.48 ± 0.1% | not timed | not timed | 1976.74 ± 0.3% | | 1.00 | 3.23 | 54.30 |
| imported/leipzig/bounded-strings-ending-z | 0 | 633.69 ± 2.5% | not timed | not timed | 617.75 ± 0.0% | 22.27 ± 0.1% | not timed | not timed | 631.51 ± 1.6% | | 1.00 | 1.03 | 28.45 |
| imported/lh3lh3-reb/uri | 17549 | 678.00 ± 0.1% | not timed | not timed | 1069.93 ± 0.1% | 27.89 ± 2.6% | not timed | not timed | 679.71 ± 0.1% | | 1.00 | 0.63 | 24.31 |
| imported/lh3lh3-reb/email | 15057 | 674.25 ± 0.1% | not timed | not timed | 1158.02 ± 0.3% | 30.75 ± 2.3% | not timed | not timed | 676.02 ± 0.1% | | 1.00 | 0.58 | 21.92 |
| imported/lh3lh3-reb/date | 668 | 892.79 ± 0.2% | not timed | not timed | 1033.90 ± 0.1% | 49.99 ± 3.7% | not timed | not timed | 893.61 ± 0.1% | | 1.00 | 0.86 | 17.86 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 645.65 ± 2.7% | not timed | not timed | 423.22 ± 0.1% | 15.70 ± 1.3% | not timed | not timed | 647.51 ± 1.6% | | 1.00 | 1.53 | 41.13 |
| imported/mariomka/email | 92 | 23498.72 ± 4.3% | not timed | not timed | 28571.48 ± 5.9% | 32.45 ± 2.5% | not timed | not timed | 23879.34 ± 4.1% | | 0.98 | 0.82 | 724.19 |
| imported/mariomka/uri | 5301 | 5537.77 ± 0.8% | not timed | not timed | 6121.50 ± 0.3% | 32.73 ± 0.3% | not timed | not timed | 5570.22 ± 0.8% | | 0.99 | 0.90 | 169.18 |
| imported/mariomka/ip | 5 | 2596.11 ± 2.6% | not timed | not timed | 2961.32 ± 0.2% | 21.02 ± 0.4% | not timed | not timed | 2602.40 ± 3.4% | | 1.00 | 0.88 | 123.53 |
| imported/rsc/no-exponential | 0 | 607.97 ± 0.1% | not timed | not timed | 318.52 ± 0.1% | 23.85 ± 0.3% | not timed | not timed | 608.21 ± 0.0% | | 1.00 | 1.91 | 25.49 |
| imported/rsc/literal | 1 | 1392.54 ± 7.5% | not timed | not timed | 1509.73 ± 6.6% | 208.91 ± 15.2% | not timed | not timed | 1491.32 ± 8.1% | | 0.93 | 0.92 | 6.67 |
| imported/rsc/not-literal | 2 | 773.46 ± 0.2% | not timed | not timed | 733.56 ± 0.2% | 46.05 ± 0.9% | not timed | not timed | 779.68 ± 7.7% | | 0.99 | 1.05 | 16.80 |
| imported/rsc/match-class | 1 | 1475.54 ± 3.0% | not timed | not timed | 1632.80 ± 0.4% | 58.44 ± 13.7% | not timed | not timed | 1476.54 ± 0.6% | | 1.00 | 0.90 | 25.25 |
| imported/rsc/match-class-in-range | 1 | 1472.92 ± 0.3% | not timed | not timed | 2299.29 ± 5.2% | 59.83 ± 0.5% | not timed | not timed | 1475.07 ± 0.4% | | 1.00 | 0.64 | 24.62 |
| imported/rsc/match-class-unicode | 1 | 539.99 ± 0.5% | not timed | not timed | 508.24 ± 0.2% | 72.16 ± 7.6% | not timed | not timed | 539.47 ± 2.0% | | 1.00 | 1.06 | 7.48 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1453.36 ± 0.1% | not timed | not timed | 959.76 ± 0.5% | 228.41 ± 0.6% | not timed | not timed | 1450.90 ± 0.2% | | 1.00 | 1.51 | 6.36 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21795.45 ± 0.1% | not timed | not timed | 14318.01 ± 0.0% | 3430.78 ± 1.0% | not timed | not timed | 21753.99 ± 0.1% | | 1.00 | 1.52 | 6.35 |
| imported/rsc/anchored-literal-short-match | 4 | 722.80 ± 1.7% | not timed | not timed | 496.97 ± 0.4% | 85.96 ± 10.0% | not timed | not timed | 723.65 ± 1.5% | | 1.00 | 1.45 | 8.41 |
| imported/rsc/anchored-literal-long-match | 4 | 10872.52 ± 2.1% | not timed | not timed | 7435.87 ± 0.1% | 1242.76 ± 9.2% | not timed | not timed | 10827.39 ± 5.9% | | 1.00 | 1.46 | 8.75 |
| imported/rsc/one-pass-short | 17 | 369.08 ± 1.1% | not timed | not timed | 217.37 ± 0.1% | 31.82 ± 10.4% | not timed | not timed | 369.94 ± 11.3% | | 1.00 | 1.70 | 11.60 |
| imported/rsc/one-pass-short-not | 17 | 270.05 ± 1.5% | not timed | not timed | 226.36 ± 0.2% | 30.12 ± 10.7% | not timed | not timed | 269.31 ± 2.4% | | 1.00 | 1.19 | 8.97 |
| imported/rsc/one-pass-long-prefix | 26 | 359.47 ± 8.0% | not timed | not timed | 284.43 ± 0.5% | 98.32 ± 13.3% | not timed | not timed | 361.46 ± 1.6% | | 0.99 | 1.26 | 3.66 |
| imported/rsc/one-pass-long-prefix-not | 26 | 359.33 ± 2.5% | not timed | not timed | 279.56 ± 0.2% | 58.76 ± 18.5% | not timed | not timed | 363.58 ± 2.4% | | 0.99 | 1.29 | 6.12 |
| imported/rsc/long-needle1 | 31 | 21939.53 ± 0.1% | not timed | not timed | 20139.17 ± 0.2% | 3.75 ± 0.2% | not timed | not timed | 21937.50 ± 0.1% | | 1.00 | 1.09 | 5851.66 |
| imported/rsc/long-needle2 | 31 | 22084.68 ± 0.1% | not timed | not timed | 216.26 ± 0.8% | 3.76 ± 0.2% | not timed | not timed | 22083.21 ± 0.2% | | 1.00 | 102.12 | 5878.54 |
| imported/rsc/easy0-32 | 26 | 1574.83 ± 2.4% | not timed | not timed | 1575.01 ± 3.5% | 148.56 ± 16.5% | not timed | not timed | 1562.70 ± 0.4% | | 1.01 | 1.00 | 10.60 |
| imported/rsc/easy0-1k | 26 | 13603.57 ± 1.6% | not timed | not timed | 12583.14 ± 1.7% | 2312.13 ± 16.3% | not timed | not timed | 13585.67 ± 1.4% | | 1.00 | 1.08 | 5.88 |
| imported/rsc/easy0-32k | 26 | 22752.65 ± 1.7% | not timed | not timed | 20297.32 ± 0.1% | 18728.00 ± 20.0% | not timed | not timed | 22759.04 ± 0.2% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21208.42 ± 1.7% | not timed | not timed | 19244.99 ± 1.8% | 35852.02 ± 1.8% | not timed | not timed | 21032.27 ± 0.8% | | 1.01 | 1.10 | 0.59 |
| imported/rsc/easy1-32 | 19 | 770.79 ± 2.3% | not timed | not timed | 635.85 ± 0.3% | 129.64 ± 13.9% | not timed | not timed | 769.35 ± 2.5% | | 1.00 | 1.21 | 5.95 |
| imported/rsc/easy1-1k | 19 | 15802.62 ± 0.4% | not timed | not timed | 13262.13 ± 0.5% | 2490.90 ± 13.6% | not timed | not timed | 15752.10 ± 2.2% | | 1.00 | 1.19 | 6.34 |
| imported/rsc/easy1-32k | 19 | 493771.34 ± 2.3% | not timed | not timed | 417018.09 ± 0.3% | 20463.45 ± 20.9% | not timed | not timed | 492869.88 ± 0.2% | | 1.00 | 1.18 | 24.13 |
| imported/rsc/easy1-1mb | 19 | 15890633.94 ± 0.3% | not timed | not timed | 13093172.61 ± 0.2% | 36151.37 ± 2.5% | not timed | not timed | 15838769.77 ± 0.5% | | 1.00 | 1.21 | 439.56 |
| imported/rsc/medium-32 | 27 | 739.49 ± 0.2% | not timed | not timed | 656.79 ± 0.4% | 69.72 ± 12.9% | not timed | not timed | 736.80 ± 1.8% | | 1.00 | 1.13 | 10.61 |
| imported/rsc/medium-1k | 27 | 13184.71 ± 0.3% | not timed | not timed | 11443.69 ± 0.2% | 72.21 ± 0.1% | not timed | not timed | 13098.85 ± 0.2% | | 1.01 | 1.15 | 182.58 |
| imported/rsc/medium-32k | 27 | 411229.22 ± 0.1% | not timed | not timed | 360279.74 ± 0.8% | 48.79 ± 0.2% | not timed | not timed | 409177.44 ± 0.3% | | 1.01 | 1.14 | 8427.80 |
| imported/rsc/medium-1mb | 27 | 13134341.35 ± 0.2% | not timed | not timed | 11602066.41 ± 0.3% | 48.87 ± 0.3% | not timed | not timed | 13031049.56 ± 0.2% | | 1.01 | 1.13 | 268749.24 |
| imported/rsc/hard-32 | 58 | 423.88 ± 0.3% | not timed | not timed | 371.02 ± 0.1% | 49.42 ± 8.4% | not timed | not timed | 421.11 ± 2.0% | | 1.01 | 1.14 | 8.58 |
| imported/rsc/hard-1k | 27 | 12881.28 ± 0.1% | not timed | not timed | 11702.40 ± 0.3% | 40.65 ± 0.1% | not timed | not timed | 12811.05 ± 0.4% | | 1.01 | 1.10 | 316.92 |
| imported/rsc/hard-32k | 27 | 402312.30 ± 0.2% | not timed | not timed | 366327.07 ± 0.3% | 29.36 ± 0.1% | not timed | not timed | 399973.10 ± 0.2% | | 1.01 | 1.10 | 13703.57 |
| imported/rsc/hard-1mb | 51 | 8382420.32 ± 0.2% | not timed | not timed | 7306315.74 ± 0.2% | 29.47 ± 0.1% | not timed | not timed | 8352433.73 ± 0.1% | | 1.00 | 1.15 | 284468.84 |
| imported/rsc/reallyhard0-32 | 58 | 263.03 ± 0.4% | not timed | not timed | 221.59 ± 0.0% | 49.45 ± 6.9% | not timed | not timed | 262.68 ± 2.4% | | 1.00 | 1.19 | 5.32 |
| imported/rsc/reallyhard0-1k | 27 | 577.66 ± 0.8% | not timed | not timed | 582.85 ± 0.3% | 40.58 ± 0.1% | not timed | not timed | 578.88 ± 0.7% | | 1.00 | 0.99 | 14.24 |
| imported/rsc/reallyhard0-32k | 27 | 600.72 ± 0.5% | not timed | not timed | 617.12 ± 0.1% | 29.35 ± 0.1% | not timed | not timed | 598.67 ± 0.5% | | 1.00 | 0.97 | 20.46 |
| imported/rsc/reallyhard0-1mb | 51 | 633.04 ± 1.2% | not timed | not timed | 616.35 ± 0.1% | 29.43 ± 0.2% | not timed | not timed | 623.28 ± 0.9% | | 1.02 | 1.03 | 21.51 |
| imported/rsc/reallyreallyhard0-32 | 47 | 284.80 ± 1.5% | not timed | not timed | 198.01 ± 1.1% | 60.59 ± 12.3% | not timed | not timed | 285.35 ± 1.8% | | 1.00 | 1.44 | 4.70 |
| imported/rsc/reallyreallyhard0-1k | 16 | 7014.52 ± 0.1% | not timed | not timed | 5960.03 ± 0.0% | 34.34 ± 0.9% | not timed | not timed | 6991.34 ± 0.1% | | 1.00 | 1.18 | 204.29 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21440.25 ± 0.5% | not timed | not timed | 19262.13 ± 0.1% | 25.09 ± 0.4% | not timed | not timed | 21456.96 ± 0.5% | | 1.00 | 1.11 | 854.64 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21735.35 ± 0.9% | not timed | not timed | 19622.43 ± 1.0% | 24.99 ± 3.4% | not timed | not timed | 21498.14 ± 1.2% | | 1.01 | 1.11 | 869.75 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 280.97 ± 1.2% | not timed | not timed | 213.66 ± 0.4% | 61.16 ± 14.6% | not timed | not timed | 281.60 ± 1.7% | | 1.00 | 1.32 | 4.59 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5918.86 ± 0.1% | not timed | not timed | 6190.17 ± 0.1% | 34.18 ± 1.8% | not timed | not timed | 5928.77 ± 0.1% | | 1.00 | 0.96 | 173.15 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21310.39 ± 0.1% | not timed | not timed | 19250.38 ± 0.0% | 24.91 ± 2.4% | not timed | not timed | 21371.27 ± 0.1% | | 1.00 | 1.11 | 855.47 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 20361.41 ± 1.4% | not timed | not timed | 18947.32 ± 2.0% | 24.65 ± 1.9% | not timed | not timed | 20374.76 ± 1.4% | | 1.00 | 1.07 | 826.15 |
| imported/sherlock/name-sherlock | 776 | 20116.17 ± 2.1% | not timed | not timed | 18813.62 ± 0.1% | 10070.31 ± 23.1% | not timed | not timed | 20110.74 ± 2.5% | | 1.00 | 1.07 | 2.00 |
| imported/sherlock/name-holmes | 2766 | 14877.23 ± 5.2% | not timed | not timed | 15753.40 ± 0.3% | 3170.06 ± 25.4% | not timed | not timed | 15498.56 ± 5.3% | | 0.96 | 0.94 | 4.69 |
| imported/sherlock/name-sherlock-holmes | 1365 | 20127.61 ± 1.9% | not timed | not timed | 18758.11 ± 0.2% | 8047.86 ± 33.2% | not timed | not timed | 20155.14 ± 0.1% | | 1.00 | 1.07 | 2.50 |
| imported/sherlock/name-sherlock-casei | 816 | 15864.49 ± 0.2% | not timed | not timed | 4019.44 ± 0.5% | 32.43 ± 0.8% | not timed | not timed | 15862.79 ± 0.2% | | 1.00 | 3.95 | 489.23 |
| imported/sherlock/name-holmes-casei | 2802 | 9322.26 ± 9.9% | not timed | not timed | 3326.75 ± 0.1% | 37.07 ± 1.0% | not timed | not timed | 9365.30 ± 2.7% | | 1.00 | 2.80 | 251.45 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 13056.50 ± 2.9% | not timed | not timed | 3956.97 ± 0.1% | 32.49 ± 0.2% | not timed | not timed | 13049.46 ± 0.8% | | 1.00 | 3.30 | 401.87 |
| imported/sherlock/name-whitespace | 1461 | 15544.80 ± 1.6% | not timed | not timed | 14632.59 ± 0.2% | 7338.88 ± 46.6% | not timed | not timed | 15593.83 ± 0.2% | | 1.00 | 1.06 | 2.12 |
| imported/sherlock/name-alt1 | 1142 | 11640.87 ± 2.5% | not timed | not timed | 16575.59 ± 0.8% | 4113.64 ± 21.2% | not timed | not timed | 11674.64 ± 0.3% | | 1.00 | 0.70 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8993.61 ± 0.3% | not timed | not timed | 3833.86 ± 0.2% | 31.24 ± 0.1% | not timed | not timed | 8993.30 ± 0.3% | | 1.00 | 2.35 | 287.91 |
| imported/sherlock/name-alt3 | 4507 | 5554.00 ± 0.6% | not timed | not timed | 3635.00 ± 0.1% | 9.96 ± 4.6% | not timed | not timed | 5547.22 ± 0.4% | | 1.00 | 1.53 | 557.67 |
| imported/sherlock/name-alt3-casei | 4593 | 1526.83 ± 1.2% | not timed | not timed | 285.06 ± 0.2% | 6.45 ± 0.2% | not timed | not timed | 1530.86 ± 1.5% | | 1.00 | 5.36 | 236.81 |
| imported/sherlock/name-alt4 | 3686 | 6439.37 ± 0.2% | not timed | not timed | 3783.88 ± 0.1% | 31.39 ± 0.2% | not timed | not timed | 6443.85 ± 0.1% | | 1.00 | 1.70 | 205.14 |
| imported/sherlock/name-alt4-casei | 4254 | 2820.06 ± 2.2% | not timed | not timed | 2592.60 ± 0.2% | 19.82 ± 0.3% | not timed | not timed | 2814.25 ± 1.0% | | 1.00 | 1.09 | 142.28 |
| imported/sherlock/name-alt5 | 4028 | 6407.04 ± 0.2% | not timed | not timed | 3751.55 ± 0.1% | 21.82 ± 0.1% | not timed | not timed | 6411.95 ± 0.1% | | 1.00 | 1.71 | 293.70 |
| imported/sherlock/name-alt5-casei | 4104 | 3487.12 ± 1.9% | not timed | not timed | 2230.09 ± 0.3% | 14.32 ± 0.1% | not timed | not timed | 3494.14 ± 0.8% | | 1.00 | 1.56 | 243.52 |
| imported/sherlock/no-match-uncommon | 0 | 22000.99 ± 0.3% | not timed | not timed | 19852.26 ± 0.4% | 37143.39 ± 0.2% | not timed | not timed | 21998.08 ± 0.2% | | 1.00 | 1.11 | 0.59 |
| imported/sherlock/no-match-common | 0 | 21870.66 ± 0.2% | not timed | not timed | 19903.96 ± 0.1% | 1282.40 ± 1.7% | not timed | not timed | 21894.84 ± 0.2% | | 1.00 | 1.10 | 17.05 |
| imported/sherlock/no-match-really-common | 0 | 16179.70 ± 2.3% | not timed | not timed | 18948.71 ± 0.2% | 1276.16 ± 0.3% | not timed | not timed | 16348.70 ± 3.1% | | 0.99 | 0.85 | 12.68 |
| imported/sherlock/the-lower | 21654 | 2304.56 ± 1.0% | not timed | not timed | 2341.77 ± 0.6% | 233.56 ± 15.7% | not timed | not timed | 2314.28 ± 8.2% | | 1.00 | 0.98 | 9.87 |
| imported/sherlock/the-upper | 2223 | 12788.84 ± 1.2% | not timed | not timed | 13665.02 ± 1.1% | 2653.50 ± 15.2% | not timed | not timed | 12847.66 ± 1.2% | | 1.00 | 0.94 | 4.82 |
| imported/sherlock/the-casei | 23961 | 1994.77 ± 0.3% | not timed | not timed | 1319.63 ± 0.3% | 34.77 ± 0.6% | not timed | not timed | 1999.63 ± 0.4% | | 1.00 | 1.51 | 57.37 |
| imported/sherlock/everything-greedy | 581881 | 282.58 ± 0.9% | not timed | not timed | 165.63 ± 0.1% | 28.65 ± 30.7% | not timed | not timed | 282.30 ± 0.9% | | 1.00 | 1.71 | 9.86 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.95 ± 0.1% | not timed | not timed | 212.42 ± 0.2% | 32.96 ± 0.1% | not timed | not timed | 490.39 ± 0.2% | | 1.00 | 2.31 | 14.90 |
| imported/sherlock/letters | 447175 | 61.64 ± 1.3% | not timed | not timed | 33.08 ± 0.1% | 6.70 ± 32.7% | not timed | not timed | 61.79 ± 0.9% | | 1.00 | 1.86 | 9.20 |
| imported/sherlock/letters-upper | 14180 | 448.69 ± 1.9% | not timed | not timed | 371.59 ± 0.0% | 29.80 ± 22.0% | not timed | not timed | 446.46 ± 0.4% | | 1.01 | 1.21 | 15.06 |
| imported/sherlock/letters-lower | 432995 | 62.62 ± 1.1% | not timed | not timed | 33.78 ± 0.1% | 5.33 ± 35.6% | not timed | not timed | 63.01 ± 1.2% | | 0.99 | 1.85 | 11.74 |
| imported/sherlock/words | 447639 | 112.49 ± 1.1% | not timed | not timed | 83.23 ± 0.2% | 15.71 ± 12.0% | not timed | not timed | 113.12 ± 0.5% | | 0.99 | 1.35 | 7.16 |
| imported/sherlock/before-holmes | 4073 | 10349.93 ± 0.9% | not timed | not timed | 8494.92 ± 0.4% | 23.92 ± 2.1% | not timed | not timed | 10342.76 ± 0.6% | | 1.00 | 1.22 | 432.77 |
| imported/sherlock/before-after-holmes | 2593 | 9989.12 ± 0.7% | not timed | not timed | 9569.53 ± 0.2% | 23.79 ± 1.0% | not timed | not timed | 10032.61 ± 0.7% | | 1.00 | 1.04 | 419.84 |
| imported/sherlock/holmes-cochar-watson | 150 | 5210.11 ± 0.5% | not timed | not timed | 3434.17 ± 0.2% | 30.94 ± 0.2% | not timed | not timed | 5217.02 ± 0.2% | | 1.00 | 1.52 | 168.40 |
| imported/sherlock/holmes-coword-watson | 14309 | 1153.43 ± 0.1% | not timed | not timed | 1123.16 ± 0.1% | 6.77 ± 0.1% | not timed | not timed | 1153.23 ± 0.1% | | 1.00 | 1.03 | 170.31 |
| imported/sherlock/quotes | 14437 | 1574.50 ± 0.3% | not timed | not timed | 1752.57 ± 0.7% | 35.19 ± 0.2% | not timed | not timed | 1573.52 ± 0.4% | | 1.00 | 0.90 | 44.75 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17522.74 ± 0.3% | not timed | not timed | 16207.61 ± 0.1% | 36.55 ± 0.2% | not timed | not timed | 17685.20 ± 0.3% | | 0.99 | 1.08 | 479.47 |
| imported/sherlock/word-ending-n | 35297 | 481.31 ± 0.3% | not timed | not timed | 409.74 ± 0.1% | 23.64 ± 16.7% | not timed | not timed | 481.28 ± 3.4% | | 1.00 | 1.17 | 20.36 |
| imported/sherlock/repeated-class-negation | 2130 | 14928.73 ± 0.9% | not timed | not timed | 11072.05 ± 0.3% | 11.58 ± 0.2% | not timed | not timed | 14909.49 ± 0.7% | | 1.00 | 1.35 | 1288.69 |
| imported/sherlock/ing-suffix | 20547 | 560.35 ± 0.3% | not timed | not timed | 517.66 ± 0.2% | 28.76 ± 0.3% | not timed | not timed | 559.42 ± 0.4% | | 1.00 | 1.08 | 19.49 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1667.35 ± 1.2% | not timed | not timed | 2107.93 ± 0.6% | 20.47 ± 23.2% | not timed | not timed | 1665.32 ± 0.4% | | 1.00 | 0.79 | 81.46 |
| opt/accelerate/whole-line | 239963 | 457.19 ± 0.3% | not timed | not timed | 372.69 ± 0.5% | 92.79 ± 16.4% | not timed | not timed | 457.36 ± 0.5% | | 1.00 | 1.23 | 4.93 |
| opt/accelerate/non-dna | 16745 | 431.86 ± 0.9% | not timed | not timed | 401.13 ± 0.1% | 28.33 ± 13.6% | not timed | not timed | 430.59 ± 0.1% | | 1.00 | 1.08 | 15.24 |
| opt/backtrack/words-english | 40536 | 141.68 ± 2.0% | not timed | not timed | 94.46 ± 0.0% | 19.60 ± 7.3% | not timed | not timed | 141.82 ± 0.2% | | 1.00 | 1.50 | 7.23 |
| opt/fixed-length/too-small-ascii | 0 | 310.93 ± 0.3% | not timed | not timed | 703.17 ± 1.2% | 80.32 ± 0.5% | not timed | not timed | 316.26 ± 0.5% | | 0.98 | 0.44 | 3.87 |
| opt/fixed-length/too-big-ascii | 0 | 3464.85 ± 0.2% | not timed | not timed | 5775.79 ± 1.4% | 126.45 ± 0.3% | not timed | not timed | 3453.13 ± 0.2% | | 1.00 | 0.60 | 27.40 |
| opt/fixed-length/go33484-1 | 0 | 664844.84 ± 0.1% | not timed | not timed | 1111031.88 ± 1.1% | 61684.49 ± 0.5% | not timed | not timed | 665072.89 ± 0.2% | | 1.00 | 0.60 | 10.78 |
| opt/fixed-length/go33484-2 | 0 | 665633.15 ± 0.2% | not timed | not timed | 1112035.31 ± 0.9% | 31935.47 ± 2.7% | not timed | not timed | 665130.94 ± 0.1% | | 1.00 | 0.60 | 20.84 |
| opt/fixed-length/go33484-3 | 0 | 66935.82 ± 0.9% | not timed | not timed | 111606.90 ± 1.4% | 767.90 ± 0.6% | not timed | not timed | 66479.82 ± 0.4% | | 1.01 | 0.60 | 87.17 |
| opt/literal-alt/one-pattern | 1 | 547.87 ± 1.4% | not timed | not timed | 542.23 ± 0.4% | 0.39 ± 0.1% | not timed | not timed | 546.72 ± 1.9% | | 1.00 | 1.01 | 1388.82 |
| opt/onepass/fn-predicate | 916 | 368.44 ± 0.7% | not timed | not timed | 337.98 ± 0.4% | 204.30 ± 11.2% | not timed | not timed | 370.73 ± 0.8% | | 0.99 | 1.09 | 1.80 |
| opt/onepass/first-three-words-english | 35128 | 180.00 ± 2.1% | not timed | not timed | 198.85 ± 0.1% | 82.36 ± 11.1% | not timed | not timed | 182.16 ± 3.9% | | 0.99 | 0.91 | 2.19 |
| opt/prefilter/literal-english | 1 | 20765.36 ± 0.5% | not timed | not timed | 19906.65 ± 0.2% | 17598.49 ± 0.4% | not timed | not timed | 20774.67 ± 0.4% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14569.65 ± 0.9% | not timed | not timed | 4319.74 ± 0.3% | 32.54 ± 0.4% | not timed | not timed | 14591.78 ± 0.5% | | 1.00 | 3.37 | 447.70 |
| opt/prefilter/literal-russian | 1 | 21346.79 ± 0.2% | not timed | not timed | 19917.55 ± 0.7% | 3329.36 ± 0.2% | not timed | not timed | 21342.12 ± 0.4% | | 1.00 | 1.07 | 6.41 |
| opt/prefilter/literal-casei-russian | 1 | 8553.20 ± 0.3% | not timed | not timed | 3892.19 ± 0.2% | 31.83 ± 0.3% | not timed | not timed | 8545.91 ± 0.3% | | 1.00 | 2.20 | 268.74 |
| opt/prefilter/rust-functions | 948 | 6817.05 ± 0.2% | not timed | not timed | 8935.18 ± 0.3% | 1870.91 ± 0.3% | not timed | not timed | 6812.85 ± 0.3% | | 1.00 | 0.76 | 3.64 |
| opt/reverse-anchored/word-end | 1 | 29620657.52 ± 0.1% | not timed | not timed | 21747030.51 ± 0.2% | 50.17 ± 0.2% | not timed | not timed | 29607449.23 ± 0.2% | | 1.00 | 1.36 | 590350.02 |
| opt/reverse-inner/holmes | 2593 | 9966.26 ± 0.9% | not timed | not timed | 9550.76 ± 0.3% | 24.13 ± 0.7% | not timed | not timed | 10020.73 ± 0.6% | | 0.99 | 1.04 | 413.08 |
| opt/reverse-inner/email | 47 | 36396.64 ± 1.5% | not timed | not timed | 45048.49 ± 0.6% | 32.44 ± 0.2% | not timed | not timed | 36858.57 ± 2.3% | | 0.99 | 0.81 | 1121.94 |
| opt/reverse-inner/factored-prefix | 3542 | 591.19 ± 0.8% | not timed | not timed | 598.11 ± 0.1% | 12.54 ± 0.3% | not timed | not timed | 589.99 ± 0.6% | | 1.00 | 0.99 | 47.13 |
| opt/reverse-inner/no-quadratic-backward | 0 | 20999.82 ± 0.1% | not timed | not timed | 616.78 ± 0.1% | 74.79 ± 0.1% | not timed | not timed | 21159.44 ± 0.1% | | 0.99 | 34.05 | 280.80 |
| opt/reverse-inner/no-quadratic-forward | 0 | 726.95 ± 1.6% | not timed | not timed | 288.31 ± 0.3% | 24.66 ± 0.1% | not timed | not timed | 730.12 ± 2.6% | | 1.00 | 2.52 | 29.48 |
| opt/reverse-suffix/holmes | 4073 | 10339.90 ± 0.5% | not timed | not timed | 8510.69 ± 0.2% | 24.25 ± 0.7% | not timed | not timed | 10321.44 ± 0.4% | | 1.00 | 1.21 | 426.44 |
| opt/reverse-suffix/no-quadratic | 0 | 21073.81 ± 0.1% | not timed | not timed | 616.66 ± 0.0% | 75.05 ± 0.1% | not timed | not timed | 21152.37 ± 0.1% | | 1.00 | 34.17 | 280.80 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 120.62 ± 6.3% | not timed | not timed | 131.70 ± 0.3% | 13.27 ± 16.8% | not timed | not timed | 120.87 ± 0.7% | | 1.00 | 0.92 | 9.09 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 121.16 ± 2.6% | not timed | not timed | 131.37 ± 0.1% | 13.16 ± 14.1% | not timed | not timed | 120.42 ± 3.3% | | 1.01 | 0.92 | 9.21 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 11.9% | not timed | not timed | 0.55 ± 0.2% | 109.50 ± 1.6% | not timed | not timed | 0.28 ± 0.3% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 322.45 ± 0.2% | not timed | not timed | 295.02 ± 0.1% | 103.40 ± 0.9% | not timed | not timed | 322.72 ± 0.2% | | 1.00 | 1.09 | 3.12 |
| reported/i13-subset-regex/original-ascii | 4094 | 11205.30 ± 1.1% | not timed | not timed | 4522.94 ± 0.5% | 11.50 ± 0.2% | not timed | not timed | 11283.72 ± 1.0% | | 0.99 | 2.48 | 974.44 |
| reported/i13-subset-regex/original-unicode | 4094 | 11078.61 ± 1.2% | not timed | not timed | 253.02 ± 3.0% | 11.52 ± 0.0% | not timed | not timed | 11278.59 ± 1.0% | | 0.98 | 43.79 | 961.92 |
| reported/i13-subset-regex/big-ascii | 1955 | 10715.96 ± 1.0% | not timed | not timed | 68.11 ± 3.6% | 9.87 ± 0.1% | not timed | not timed | 10807.31 ± 1.0% | | 0.99 | 157.34 | 1085.20 |
| reported/i13-subset-regex/big-unicode | 1955 | 10609.44 ± 1.5% | not timed | not timed | 12.16 ± 54.9% | 9.86 ± 1.0% | not timed | not timed | 10724.05 ± 2.4% | | 0.99 | 872.63 | 1075.89 |
| reported/i13-subset-regex/huge-ascii | 55 | 10090.45 ± 1.3% | not timed | not timed | 11.00 ± 0.1% | 8.77 ± 0.2% | not timed | not timed | 9926.47 ± 2.7% | | 1.02 | 917.46 | 1150.22 |
| reported/i13-subset-regex/huge-unicode | 55 | 9918.85 ± 2.6% | not timed | not timed | 10.97 ± 0.3% | 8.78 ± 0.1% | not timed | not timed | 9829.81 ± 2.9% | | 1.01 | 904.52 | 1129.26 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.54 ± 0.0% | not timed | not timed | 11.05 ± 0.1% | 8.77 ± 1.1% | not timed | not timed | 3.53 ± 0.1% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.1% | not timed | not timed | 10.95 ± 0.3% | 8.78 ± 0.1% | not timed | not timed | 4.97 ± 0.2% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 483.41 ± 0.2% | not timed | not timed | 104.51 ± 0.1% | 6.50 ± 0.3% | not timed | not timed | 484.50 ± 0.2% | | 1.00 | 4.63 | 74.39 |
| reported/i787-keywords/opt-ascii | 5674 | 485.07 ± 0.4% | not timed | not timed | 272.67 ± 0.3% | 10.23 ± 0.2% | not timed | not timed | 483.64 ± 0.5% | | 1.00 | 1.78 | 47.41 |
| slow/quadratic-regex-1x | 100 | 7.09 ± 0.5% | not timed | not timed | 4.94 ± 0.1% | 0.05 ± 0.2% | not timed | not timed | 7.08 ± 0.8% | | 1.00 | 1.43 | 144.65 |
| slow/quadratic-regex-2x | 199 | 3.41 ± 0.1% | not timed | not timed | 2.77 ± 0.1% | 0.01 ± 0.2% | not timed | not timed | 3.42 ± 0.5% | | 1.00 | 1.23 | 268.61 |
| slow/quadratic-haystack-1x | 100 | 22.07 ± 6.6% | not timed | not timed | 10.01 ± 0.2% | 1.01 ± 13.6% | not timed | not timed | 22.03 ± 1.5% | | 1.00 | 2.21 | 21.79 |
| slow/quadratic-haystack-2x | 200 | 19.68 ± 0.8% | not timed | not timed | 5.54 ± 0.2% | 0.55 ± 1.1% | not timed | not timed | 19.68 ± 6.9% | | 1.00 | 3.56 | 36.09 |
| unicode/codepoints/any-one | 1112064 | 281.42 ± 0.3% | not timed | not timed | 176.98 ± 0.2% | 18.51 ± 2.6% | not timed | not timed | 281.39 ± 0.4% | | 1.00 | 1.59 | 15.20 |
| unicode/codepoints/any-all | 4382592 | 278.78 ± 2.8% | not timed | not timed | 247.10 ± 0.3% | 117.64 ± 0.1% | not timed | not timed | 279.99 ± 0.7% | | 1.00 | 1.13 | 2.37 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.69 ± 1.3% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 600.15 ± 1.4% | not timed | not timed | 614.87 ± 0.3% | 135.40 ± 0.1% | not timed | not timed | 599.17 ± 1.7% | | 1.00 | 0.98 | 4.43 |
| unicode/overlapping-words/ascii | 6156 | 32.24 ± 0.5% | not timed | not timed | 38.81 ± 0.1% | 3.92 ± 0.9% | not timed | not timed | 32.31 ± 0.2% | | 1.00 | 0.83 | 8.23 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.1% | not timed | not timed | 4.12 ± 0.1% | 2.34 ± 0.5% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.35 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 9.7% | not timed | not timed | 3.87 ± 0.1% | 6.32 ± 10.2% | not timed | not timed | 1.28 ± 0.1% | | 1.00 | 0.33 | 0.20 |
| unicode/word/boundary-any-english | 450561 | 127.75 ± 3.4% | not timed | not timed | 83.16 ± 0.1% | 11.72 ± 16.2% | not timed | not timed | 129.65 ± 0.5% | | 0.99 | 1.54 | 10.90 |
| unicode/word/boundary-long-english | 3466 | 605.35 ± 0.6% | not timed | not timed | 604.91 ± 0.1% | 32.54 ± 1.0% | not timed | not timed | 604.35 ± 1.6% | | 1.00 | 1.00 | 18.60 |
| unicode/word/around-holmes-english | 27 | 19989.44 ± 0.2% | not timed | not timed | 19687.15 ± 0.5% | 22.20 ± 0.7% | not timed | not timed | 19960.74 ± 0.3% | | 1.00 | 1.02 | 900.35 |
| wild/bibleref/long | 874 | 564.63 ± 0.2% | not timed | not timed | 583.03 ± 0.1% | 6.74 ± 0.1% | not timed | not timed | 567.10 ± 0.3% | | 1.00 | 0.97 | 83.80 |
| wild/bibleref/short | 30 | 23.96 ± 1.7% | not timed | not timed | 30.93 ± 1.2% | 14.50 ± 9.8% | not timed | not timed | 24.46 ± 2.6% | | 0.98 | 0.77 | 1.65 |
| wild/bibleref/line | 874 | 399.11 ± 0.1% | not timed | not timed | 211.73 ± 0.4% | 9.22 ± 0.2% | not timed | not timed | 399.47 ± 0.2% | | 1.00 | 1.89 | 43.29 |
| wild/caddy/caddy | 6 | 420.19 ± 9.7% | not timed | not timed | 251.09 ± 0.1% | 68.51 ± 14.3% | not timed | not timed | 421.90 ± 1.0% | | 1.00 | 1.67 | 6.13 |
| wild/dot-star-capture/rust-src-tools | 6 | 1070.29 ± 0.4% | not timed | not timed | 348.63 ± 0.2% | 13.51 ± 0.3% | not timed | not timed | 1063.79 ± 0.2% | | 1.01 | 3.07 | 79.21 |
| wild/ruff/noqa | 84 | 439.10 ± 0.2% | not timed | not timed | 451.77 ± 0.1% | 19.54 ± 2.0% | not timed | not timed | 438.72 ± 2.2% | | 1.00 | 0.97 | 22.47 |
| wild/ruff/unnecessary-coding-comment | 16 | 958.08 ± 0.5% | not timed | not timed | 701.01 ± 0.2% | 137.05 ± 10.9% | not timed | not timed | 959.42 ± 0.3% | | 1.00 | 1.37 | 6.99 |
| wild/ruff/string-quote-prefix | 2972 | 1366.68 ± 0.6% | not timed | not timed | 407.57 ± 0.1% | 318.31 ± 25.7% | not timed | not timed | 1366.17 ± 0.7% | | 1.00 | 3.35 | 4.29 |
| wild/ruff/space-around-operator | 1224378 | 223.39 ± 1.7% | not timed | not timed | 186.52 ± 0.1% | 18.40 ± 1.6% | not timed | not timed | 223.86 ± 1.7% | | 1.00 | 1.20 | 12.14 |
| wild/ruff/shebang | 282 | 973.72 ± 0.4% | not timed | not timed | 328.90 ± 0.1% | 119.26 ± 9.5% | not timed | not timed | 978.49 ± 0.5% | | 1.00 | 2.96 | 8.16 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13851.90 ± 0.9% | not timed | not timed | 13867.90 ± 0.4% | 6960.01 ± 0.3% | not timed | not timed | 13870.13 ± 0.2% | | 1.00 | 1.00 | 1.99 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12860.91 ± 0.4% | not timed | not timed | 13479.45 ± 0.6% | 6426.22 ± 0.4% | not timed | not timed | 12857.04 ± 0.5% | | 1.00 | 0.95 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 13198.51 ± 2.0% | not timed | not timed | 13707.13 ± 0.4% | 6666.69 ± 0.9% | not timed | not timed | 13240.86 ± 0.4% | | 1.00 | 0.96 | 1.98 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 9571.07 ± 0.2% | not timed | not timed | 13606.83 ± 0.3% | 6782.53 ± 1.1% | not timed | not timed | 9582.57 ± 0.3% | | 1.00 | 0.70 | 1.41 |
| wild/url/search | 234965 | 121.47 ± 14.0% | not timed | not timed | 65.73 ± 0.2% | 2.21 ± 1.0% | not timed | not timed | 121.82 ± 13.9% | | 1.00 | 1.85 | 54.88 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.4% | not timed | not timed | 0.01 ± 0.5% | 0.01 ± 17.8% | not timed | not timed | 0.03 ± 11.6% | | 0.98 | 2.96 | 3.52 |
| dictionary/compile/english-15 | 1 | 0.35 ± 30.2% | not timed | not timed | 0.07 ± 0.4% | 0.10 ± 19.0% | not timed | not timed | 0.35 ± 4.0% | | 1.00 | 4.99 | 3.44 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.25 ± 7.9% | not timed | not timed | 0.02 ± 1.0% | 37.26 ± 12.0% | not timed | not timed | 0.25 ± 3.8% | | 0.98 | 12.76 | 0.0066 |
| reported/i1095-word-repetition/ascii-compile | 1 | 47.88 ± 6.2% | not timed | not timed | 11.65 ± 0.3% | 63.97 ± 11.4% | not timed | not timed | 47.98 ± 18.4% | | 1.00 | 4.11 | 0.75 |
| reported/i787-keywords/compile | 1 | 35.58 ± 1.4% | not timed | not timed | 2.14 ± 1.0% | 17.26 ± 21.8% | not timed | not timed | 35.61 ± 2.5% | | 1.00 | 16.62 | 2.06 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 365.19 ± 1.9% | not timed | not timed | 119.67 ± 0.1% | 577.44 ± 26.7% | not timed | not timed | 365.92 ± 2.6% | | 1.00 | 3.05 | 0.63 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 47.88 ± 2.0% | not timed | not timed | 4.11 ± 0.6% | 44.80 ± 4.0% | not timed | not timed | 48.59 ± 1.9% | | 0.99 | 11.65 | 1.07 |
| unicode/compile/one-letter | 53 | 6.73 ± 11.6% | not timed | not timed | 4.54 ± 0.3% | 68.54 ± 5.7% | not timed | not timed | 6.82 ± 1.1% | | 0.99 | 1.48 | 0.0982 |
| unicode/compile/fifty-letters | 1 | 0.97 ± 15.9% | not timed | not timed | 0.10 ± 0.8% | 68.24 ± 13.3% | not timed | not timed | 1.11 ± 3.5% | | 0.88 | 9.67 | 0.0143 |
| unicode/compile/fifty-letters-ascii | 1 | 223.67 ± 5.9% | not timed | not timed | 53.10 ± 0.1% | 222.24 ± 40.0% | not timed | not timed | 223.75 ± 11.9% | | 1.00 | 4.21 | 1.01 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 386.84 ± 2.2% | not timed | not timed | 47.07 ± 0.4% | 688.21 ± 32.3% | not timed | not timed | 386.68 ± 7.9% | | 1.00 | 8.22 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 595.87 ± 12.1% | not timed | not timed | 143.63 ± 0.4% | 696.63 ± 15.3% | not timed | not timed | 615.30 ± 1.4% | | 0.97 | 4.15 | 0.86 |
| unicode/compile/negated-class-matches-codepoint | 1 | 332.28 ± 13.1% | not timed | not timed | 51.72 ± 0.4% | 1308.29 ± 29.1% | not timed | not timed | 332.53 ± 2.7% | | 1.00 | 6.42 | 0.25 |
| wild/bibleref/compile | 3 | 5.85 ± 3.3% | not timed | not timed | 1.92 ± 0.5% | 33.83 ± 3.7% | not timed | not timed | 5.97 ± 3.5% | | 0.98 | 3.05 | 0.17 |
| wild/url/compile | 1 | 0.65 ± 17.7% | not timed | not timed | 0.15 ± 0.4% | 0.43 ± 28.9% | not timed | not timed | 0.66 ± 1.2% | | 1.00 | 4.49 | 1.53 |

