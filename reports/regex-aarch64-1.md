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
| literal: a word | 217 | 19547.28 ± 2.4% | 10833.30 ± 0.8% | 28.32 ± 0.3% | 18281.77 ± 1.7% | 9135.77 ± 7.8% | 17.34 ± 0.3% | 86.52 ± 0.3% | 19591.99 ± 1.0% | 1.80 | 1.00 | 1.07 | 2.14 |
| literal: a word that is not there | 0 | 21607.94 ± 1.8% | 9877.69 ± 0.4% | 28.38 ± 0.1% | 19605.68 ± 2.7% | 29216.98 ± 1.0% | 17.16 ± 0.3% | 80.73 ± 0.6% | 21493.08 ± 1.2% | 2.19 | 1.01 | 1.10 | 0.74 |
| literal: one of four words | 661 | 6427.91 ± 0.4% | 1790.90 ± 0.2% | 14.34 ± 0.1% | 3955.22 ± 0.1% | 21.80 ± 0.1% | 5.45 ± 0.1% | 6.97 ± 0.2% | 6441.64 ± 0.3% | 3.59 | 1.00 | 1.63 | 294.89 |
| literal: a word in any case | 217 | 15205.56 ± 0.7% | 1916.75 ± 0.4% | 21.42 ± 0.1% | 3967.48 ± 0.1% | 38.05 ± 2.9% | refused | differs | 15220.57 ± 0.7% | 7.93 | 1.00 | 3.83 | 399.67 |
| literal: an href attribute | 33 | 16905.47 ± 2.5% | 608.69 ± 0.5% | 27.31 ± 0.1% | 17095.49 ± 2.7% | 2253.37 ± 8.9% | 13.12 ± 0.5% | 75.43 ± 0.7% | 17005.24 ± 1.9% | 27.77 | 0.99 | 0.99 | 7.50 |
| literal: a word, second text | 123 | 20126.21 ± 1.5% | 4593.74 ± 0.3% | 27.97 ± 0.3% | 18401.32 ± 0.6% | 7567.15 ± 2.8% | 20.04 ± 0.3% | 71.38 ± 0.4% | 19874.88 ± 2.5% | 4.38 | 1.01 | 1.09 | 2.66 |
| class: two capitalized words | 1331 | 1180.14 ± 0.1% | 599.03 ± 0.2% | 25.99 ± 0.3% | 586.17 ± 0.2% | 40.67 ± 2.7% | 14.82 ± 0.3% | 68.09 ± 0.3% | 1176.87 ± 0.3% | 1.97 | 1.00 | 2.01 | 29.01 |
| class: a word that ends in ing | 3399 | 574.95 ± 0.2% | 575.05 ± 0.3% | 17.76 ± 1.6% | 548.19 ± 0.1% | 29.60 ± 9.3% | 8.19 ± 0.2% | 18.47 ± 0.3% | 575.24 ± 0.3% | 1.00 | 1.00 | 1.05 | 19.42 |
| class: a word in capitals | 2332 | 1529.30 ± 0.1% | 609.18 ± 0.1% | 27.57 ± 0.6% | 572.67 ± 0.1% | 43.67 ± 0.3% | 17.14 ± 0.3% | 83.62 ± 0.2% | 1527.25 ± 0.4% | 2.51 | 1.00 | 2.67 | 35.02 |
| class: a number | 8288 | 2656.74 ± 0.5% | 840.99 ± 0.1% | 27.77 ± 0.2% | 1710.34 ± 0.2% | 40.91 ± 16.5% | 0.56 ± 0.4% | 57.48 ± 0.3% | 2631.62 ± 0.7% | 3.16 | 1.01 | 1.55 | 64.94 |
| class: two capitalized words, second text | 5359 | 521.77 ± 0.2% | 528.70 ± 0.3% | 23.14 ± 0.2% | 485.11 ± 0.2% | 32.73 ± 7.8% | 17.09 ± 0.2% | 63.33 ± 0.3% | 521.50 ± 0.3% | 0.99 | 1.00 | 1.08 | 15.94 |
| other: a word between two words | 6104 | 811.87 ± 0.2% | 602.30 ± 0.2% | 23.40 ± 0.2% | 738.26 ± 0.3% | 102.14 ± 9.4% | 11.23 ± 0.1% | 69.59 ± 0.7% | 814.33 ± 0.1% | 1.35 | 1.00 | 1.10 | 7.95 |
| other: a number before a unit, second text | 1481 | 6267.14 ± 0.9% | 1141.79 ± 0.3% | 25.93 ± 0.3% | 5624.39 ± 0.5% | 40.79 ± 6.8% | 18.08 ± 0.2% | 65.90 ± 0.3% | 6252.12 ± 1.7% | 5.49 | 1.00 | 1.11 | 153.64 |
| other: a heading's start tag | 110 | 14248.81 ± 2.0% | 740.14 ± 0.3% | 27.28 ± 0.3% | 1712.54 ± 0.3% | 1582.10 ± 1.1% | 16.20 ± 0.3% | 88.01 ± 0.3% | 14211.10 ± 1.9% | 19.25 | 1.00 | 8.32 | 9.01 |
| other: a whole word | 217 | 16270.57 ± 0.6% | 601.00 ± 0.5% | 28.51 ± 0.3% | 14539.31 ± 0.8% | 49.23 ± 8.9% | 13.35 ± 0.3% | 55.61 ± 0.5% | 16339.70 ± 1.1% | 27.07 | 1.00 | 1.12 | 330.50 |
| other: a line's first word, second text | 3716 | 2106.92 ± 0.5% | 592.08 ± 0.2% | 30.56 ± 0.3% | 1729.59 ± 0.5% | 62.34 ± 6.3% | refused | refused | 2115.95 ± 0.9% | 3.56 | 1.00 | 1.22 | 33.80 |
| other: fourteen octets before an x | 87 | 24322.39 ± 1.3% | 240.24 ± 1.1% | 6.46 ± 0.1% | 3967.20 ± 0.4% | 10.64 ± 0.3% | differs | 17.94 ± 0.2% | 24356.83 ± 1.6% | 101.24 | 1.00 | 6.13 | 2285.53 |
| other: a Greek word | 21815 | 525.42 ± 0.5% | 423.92 ± 0.1% | 30.42 ± 0.2% | 289.66 ± 0.2% | 46.42 ± 12.7% | differs | refused | 528.21 ± 0.4% | 1.24 | 0.99 | 1.81 | 11.32 |

## Match short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 32862 | 29.69 ± 0.3% | 29.66 ± 0.2% | 0.85 ± 0.3% | 19.84 ± 0.6% | 2.77 ± 0.2% | differs | 4.07 ± 0.1% | 29.64 ± 0.2% | 1.00 | 1.00 | 1.50 | 10.73 |
| a UUID | 32895 | 24.66 ± 0.1% | 24.77 ± 0.2% | 0.64 ± 0.2% | 15.19 ± 0.7% | 3.08 ± 0.2% | 0.73 ± 0.3% | 3.62 ± 0.8% | 24.78 ± 0.1% | 1.00 | 0.99 | 1.62 | 8.00 |
| an IPv4 address | 33176 | 38.54 ± 0.3% | 38.73 ± 0.4% | 2.07 ± 0.3% | 29.30 ± 0.1% | 6.65 ± 0.2% | differs | 4.22 ± 0.1% | 38.74 ± 0.2% | 1.00 | 1.00 | 1.32 | 5.79 |
| a date and time | 32954 | 33.77 ± 0.2% | 34.16 ± 0.2% | 1.43 ± 0.1% | 21.57 ± 0.4% | 7.03 ± 0.2% | 1.23 ± 0.1% | 7.17 ± 0.3% | 34.14 ± 0.2% | 0.99 | 0.99 | 1.57 | 4.80 |
| a field path | 32606 | 32.79 ± 0.3% | 32.67 ± 0.2% | 1.02 ± 0.1% | 23.25 ± 0.4% | 3.52 ± 0.4% | differs | 2.97 ± 0.2% | 32.86 ± 0.1% | 1.00 | 1.00 | 1.41 | 9.32 |

## Capture groups of short texts, millions of texts a second

| Pattern | Texts that match | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| a date and time, six groups | 32995 | 11.23 ± 0.5% | 11.19 ± 0.3% | 11.21 ± 1.4% | 11.85 ± 0.2% | 4.95 ± 2.9% | 0.94 ± 0.4% | none | 11.15 ± 0.2% | 1.00 | 1.01 | 0.95 | 2.27 |

## Compile, thousands of patterns a second

| Pattern | Octets | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| an email address | 48 | 213.24 ± 0.3% | 213.48 ± 0.3% | 255.45 ± 0.1% | 87.40 ± 0.7% | 214.84 ± 7.3% | 488.57 ± 3.5% | 3723.82 ± 3.4% | 213.27 ± 0.3% | 1.00 | 1.00 | 2.44 | 0.99 |
| a UUID | 62 | 140.39 ± 0.4% | 140.42 ± 0.2% | 158.18 ± 0.2% | 46.68 ± 1.1% | 91.31 ± 6.1% | 193.74 ± 1.8% | 4353.12 ± 0.4% | 140.51 ± 0.3% | 1.00 | 1.00 | 3.01 | 1.54 |
| an IPv4 address | 29 | 395.73 ± 0.4% | 396.33 ± 1.2% | 565.36 ± 0.4% | 78.37 ± 0.1% | 123.38 ± 6.5% | 306.55 ± 1.0% | 7505.99 ± 0.6% | 396.04 ± 1.2% | 1.00 | 1.00 | 5.05 | 3.21 |
| a date and time | 56 | 278.44 ± 0.3% | 278.78 ± 0.4% | 353.63 ± 0.2% | 71.13 ± 0.2% | 128.41 ± 3.4% | 326.42 ± 1.0% | 4926.42 ± 0.4% | 278.64 ± 0.1% | 1.00 | 1.00 | 3.91 | 2.17 |
| a field path | 39 | 206.35 ± 0.2% | 206.51 ± 0.4% | 244.99 ± 0.2% | 79.92 ± 0.3% | 194.01 ± 4.0% | 490.69 ± 1.1% | 4724.34 ± 0.2% | 206.41 ± 0.1% | 1.00 | 1.00 | 2.58 | 1.06 |
| literal: a word | 7 | 571.01 ± 0.4% | 610.32 ± 0.3% | 1119.10 ± 0.1% | 496.96 ± 1.6% | 611.01 ± 3.2% | 947.47 ± 1.2% | 29326.52 ± 0.3% | 571.52 ± 0.4% | 0.94 | 1.00 | 1.15 | 0.93 |
| literal: a word that is not there | 8 | 553.39 ± 0.3% | 595.82 ± 0.4% | 1080.75 ± 0.5% | 462.28 ± 0.1% | 582.89 ± 4.7% | 894.46 ± 0.8% | 28497.57 ± 0.5% | 553.52 ± 0.4% | 0.93 | 1.00 | 1.20 | 0.95 |
| literal: one of four words | 26 | 232.03 ± 0.3% | 372.35 ± 0.1% | 520.99 ± 0.3% | 50.52 ± 0.3% | 225.00 ± 2.8% | 366.87 ± 0.4% | 15335.64 ± 0.3% | 232.44 ± 0.2% | 0.62 | 1.00 | 4.59 | 1.03 |
| literal: a word in any case | 11 | 419.51 ± 0.2% | 447.66 ± 0.5% | 677.52 ± 0.4% | 16.06 ± 0.8% | 605.81 ± 4.3% | refused | 22807.38 ± 0.6% | 419.88 ± 0.8% | 0.94 | 1.00 | 26.12 | 0.69 |
| literal: an href attribute | 12 | 317.52 ± 0.4% | 329.08 ± 0.3% | 439.51 ± 0.1% | 44.96 ± 0.3% | 460.12 ± 6.7% | 773.43 ± 0.3% | 21298.40 ± 0.3% | 317.69 ± 0.2% | 0.96 | 1.00 | 7.06 | 0.69 |
| literal: a word, second text | 10 | 513.68 ± 0.2% | 559.70 ± 0.3% | 966.04 ± 0.2% | 411.44 ± 0.4% | 499.03 ± 2.9% | 802.60 ± 0.2% | 26310.29 ± 0.2% | 513.22 ± 0.2% | 0.92 | 1.00 | 1.25 | 1.03 |
| class: two capitalized words | 23 | 397.22 ± 0.3% | 426.67 ± 0.4% | 627.31 ± 0.6% | 100.34 ± 1.9% | 476.90 ± 1.2% | 744.92 ± 0.5% | 6243.93 ± 0.2% | 397.41 ± 0.5% | 0.93 | 1.00 | 3.96 | 0.83 |
| class: a word that ends in ing | 9 | 501.40 ± 0.4% | 568.20 ± 0.4% | 1031.88 ± 0.3% | 133.96 ± 0.6% | 729.15 ± 3.4% | 1099.50 ± 0.8% | 15350.18 ± 0.2% | 501.46 ± 0.5% | 0.88 | 1.00 | 3.74 | 0.69 |
| class: a word in capitals | 16 | 442.74 ± 0.2% | 480.28 ± 0.3% | 784.22 ± 0.1% | 136.62 ± 0.7% | 718.73 ± 3.7% | 1001.90 ± 1.0% | 8208.08 ± 0.4% | 443.07 ± 0.2% | 0.92 | 1.00 | 3.24 | 0.62 |
| class: a number | 6 | 562.93 ± 0.2% | 622.62 ± 0.7% | 1211.15 ± 0.1% | 42.15 ± 1.1% | 1362.90 ± 6.4% | 1866.07 ± 1.6% | 22192.36 ± 0.0% | 562.53 ± 0.2% | 0.90 | 1.00 | 13.36 | 0.41 |
| class: two capitalized words, second text | 23 | 397.29 ± 0.4% | 427.13 ± 0.2% | 627.37 ± 0.3% | 100.01 ± 1.7% | 474.85 ± 3.3% | 767.30 ± 0.5% | 6245.32 ± 0.1% | 397.31 ± 0.2% | 0.93 | 1.00 | 3.97 | 0.84 |
| other: a word between two words | 13 | 498.13 ± 0.5% | 516.35 ± 0.5% | 849.10 ± 0.5% | 132.16 ± 0.5% | 473.25 ± 4.3% | 811.83 ± 0.7% | 14321.94 ± 0.3% | 498.47 ± 0.4% | 0.96 | 1.00 | 3.77 | 1.05 |
| other: a number before a unit, second text | 15 | 356.77 ± 0.3% | 394.79 ± 0.1% | 562.69 ± 0.1% | 39.46 ± 0.6% | 615.52 ± 3.7% | 882.74 ± 0.4% | 14865.25 ± 0.2% | 356.59 ± 0.5% | 0.90 | 1.00 | 9.04 | 0.58 |
| other: a heading's start tag | 13 | 325.14 ± 0.3% | 332.10 ± 0.3% | 443.62 ± 0.4% | 43.98 ± 0.3% | 628.65 ± 1.5% | 873.48 ± 0.4% | 17671.77 ± 0.3% | 325.73 ± 0.2% | 0.98 | 1.00 | 7.39 | 0.52 |
| other: a whole word | 11 | 528.70 ± 0.8% | 564.64 ± 1.1% | 983.34 ± 1.7% | 119.81 ± 0.2% | 561.71 ± 2.0% | 831.11 ± 0.8% | 25372.67 ± 0.9% | 528.37 ± 0.7% | 0.94 | 1.00 | 4.41 | 0.94 |
| other: a line's first word, second text | 17 | 470.08 ± 0.4% | 502.49 ± 0.5% | 830.48 ± 0.4% | 129.20 ± 0.1% | 684.38 ± 8.7% | refused | refused | 472.15 ± 0.4% | 0.94 | 1.00 | 3.64 | 0.69 |
| other: fourteen octets before an x | 16 | 105.78 ± 0.6% | 149.99 ± 0.6% | 176.06 ± 0.5% | 15.08 ± 0.3% | 420.10 ± 3.9% | 415.07 ± 0.2% | 12571.00 ± 0.9% | 105.47 ± 2.2% | 0.71 | 1.00 | 7.01 | 0.25 |
| other: a Greek word | 8 | 397.95 ± 0.3% | 532.73 ± 0.5% | 922.07 ± 0.5% | 59.21 ± 0.7% | 1298.76 ± 4.4% | 1814.34 ± 0.7% | refused | 398.45 ± 0.3% | 0.75 | 1.00 | 6.72 | 0.31 |

rebar's benchmarks, at commit 463d00f31887e84c38467805b9e3122c314b9521: each one whose engines name Go's regexp or RE2 and whose model this benchmark runs. rebar's author chose their patterns and haystacks. The curated set's are tuned: design §8 part 22n tuned stdx on them. The other benchmarks' are not: no change to stdx was judged on their speed, and one, a mode of bytes, was made for one of their answers. A candidate's answer is held to the count rebar's definition gives its engine: Go's regexp's, Rust's crate's, and RE2's for stdx, which runs in bytes where the benchmark leaves `unicode` off, as Rust's crate does. A candidate that refuses a pattern or answers otherwise is named so and not timed. zig-regex and mvzr are not timed on them: the tables above time them at a hundredth to a four-thousandth of stdx's speed, and the haystacks hold up to 40 MB.

## Held-out search, rebar's curated set, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 01-literal/sherlock-en | 513 | 15681.17 ± 0.9% | not timed | not timed | 16356.72 ± 0.4% | 2014.66 ± 17.1% | not timed | not timed | 15661.88 ± 0.6% | | 1.00 | 0.96 | 7.78 |
| 01-literal/sherlock-casei-en | 522 | 10956.34 ± 5.6% | not timed | not timed | 3593.21 ± 0.2% | 32.49 ± 0.3% | not timed | not timed | 10966.29 ± 1.4% | | 1.00 | 3.05 | 337.23 |
| 01-literal/sherlock-ru | 724 | 17107.77 ± 0.6% | not timed | not timed | 17301.56 ± 0.6% | 1403.97 ± 11.6% | not timed | not timed | 17137.62 ± 0.5% | | 1.00 | 0.99 | 12.19 |
| 01-literal/sherlock-casei-ru | 746 | 6124.41 ± 0.4% | not timed | not timed | 3327.67 ± 0.2% | 31.64 ± 3.6% | not timed | not timed | 6132.32 ± 0.2% | | 1.00 | 1.84 | 193.55 |
| 01-literal/sherlock-zh | 30 | 19997.93 ± 0.7% | not timed | not timed | 18834.39 ± 0.5% | 2547.37 ± 12.3% | not timed | not timed | 19984.06 ± 0.9% | | 1.00 | 1.06 | 7.85 |
| 02-literal-alternate/sherlock-en | 714 | 6138.66 ± 0.5% | not timed | not timed | 3941.64 ± 0.2% | 16.59 ± 0.3% | not timed | not timed | 6147.81 ± 0.4% | | 1.00 | 1.56 | 369.99 |
| 02-literal-alternate/sherlock-casei-en | 725 | 1964.99 ± 1.6% | not timed | not timed | 696.84 ± 0.1% | 11.04 ± 0.4% | not timed | not timed | 1967.37 ± 0.8% | | 1.00 | 2.82 | 178.04 |
| 02-literal-alternate/sherlock-ru | 899 | 5493.77 ± 0.2% | not timed | not timed | 3251.20 ± 0.2% | 22.69 ± 0.1% | not timed | not timed | 5477.21 ± 0.4% | | 1.00 | 1.69 | 242.14 |
| 02-literal-alternate/sherlock-casei-ru | 971 | 2047.17 ± 0.6% | not timed | not timed | 1224.57 ± 0.6% | 9.15 ± 0.3% | not timed | not timed | 2046.59 ± 0.5% | | 1.00 | 1.67 | 223.86 |
| 02-literal-alternate/sherlock-zh | 207 | 7323.18 ± 0.5% | not timed | not timed | 4165.56 ± 0.0% | 31.49 ± 0.3% | not timed | not timed | 7324.21 ± 0.4% | | 1.00 | 1.76 | 232.55 |
| 03-date/ascii | 111817 | 133.42 ± 0.9% | not timed | not timed | 96.25 ± 0.2% | 0.20 ± 4.3% | not timed | not timed | 134.49 ± 0.7% | | 0.99 | 1.39 | 658.90 |
| 04-ruff-noqa/real | 84 | 437.14 ± 0.2% | not timed | not timed | 469.04 ± 0.1% | 19.78 ± 1.3% | not timed | not timed | 435.39 ± 0.1% | | 1.00 | 0.93 | 22.10 |
| 04-ruff-noqa/tweaked | 44 | 826.04 ± 0.1% | not timed | not timed | 461.52 ± 0.1% | 361.99 ± 1.3% | not timed | not timed | 826.23 ± 0.3% | | 1.00 | 1.79 | 2.28 |
| 05-lexer-veryl/single | 124800 | 5.42 ± 0.7% | not timed | not timed | 5.21 ± 0.3% | 0.20 ± 4.7% | not timed | not timed | 5.59 ± 0.4% | | 0.97 | 1.04 | 26.57 |
| 06-cloud-flare-redos/original | 107 | 439.46 ± 0.2% | not timed | not timed | 217.19 ± 0.2% | 24.83 ± 0.2% | not timed | not timed | 440.20 ± 0.1% | | 1.00 | 2.02 | 17.70 |
| 06-cloud-flare-redos/simplified-short | 102 | 437.72 ± 0.2% | not timed | not timed | 228.70 ± 0.2% | 26.58 ± 0.6% | not timed | not timed | 437.99 ± 0.3% | | 1.00 | 1.91 | 16.47 |
| 06-cloud-flare-redos/simplified-long | 10000 | 629.09 ± 0.2% | not timed | not timed | 256.18 ± 0.1% | 28.75 ± 0.1% | not timed | not timed | 629.36 ± 0.1% | | 1.00 | 2.46 | 21.88 |
| 07-unicode-character-data/parse-line | 558784 | 234.98 ± 1.6% | not timed | not timed | 179.39 ± 0.3% | 40.85 ± 6.2% | not timed | not timed | 236.70 ± 3.6% | | 0.99 | 1.31 | 5.75 |
| 08-words/all-english | 56691 | 128.33 ± 0.9% | not timed | not timed | 83.26 ± 0.1% | 12.62 ± 5.5% | not timed | not timed | 128.95 ± 0.9% | | 1.00 | 1.54 | 10.17 |
| 08-words/long-english | 839 | 617.00 ± 0.2% | not timed | not timed | 597.47 ± 0.1% | 32.67 ± 0.5% | not timed | not timed | 617.54 ± 0.3% | | 1.00 | 1.03 | 18.89 |
| 09-aws-keys/full | 0 | 441.55 ± 0.3% | not timed | not timed | 477.16 ± 0.1% | 63.82 ± 3.6% | not timed | not timed | 441.50 ± 0.2% | | 1.00 | 0.93 | 6.92 |
| 09-aws-keys/quick | 0 | 872.06 ± 0.2% | not timed | not timed | 1000.02 ± 0.6% | 414.22 ± 0.6% | not timed | not timed | 871.71 ± 0.2% | | 1.00 | 0.87 | 2.11 |
| 10-bounded-repeat/letters-en | 1833 | 585.19 ± 2.0% | not timed | not timed | 518.47 ± 0.4% | 19.58 ± 0.2% | not timed | not timed | 583.37 ± 1.6% | | 1.00 | 1.13 | 29.89 |
| 10-bounded-repeat/letters-ru | 3475 | 506.10 ± 1.7% | not timed | not timed | 479.95 ± 0.1% | 22.14 ± 9.5% | not timed | not timed | 508.48 ± 1.7% | | 1.00 | 1.05 | 22.85 |
| 10-bounded-repeat/context | 53 | 83.68 ± 2.2% | not timed | not timed | 64.42 ± 0.8% | 19.71 ± 0.2% | not timed | not timed | 84.05 ± 1.9% | | 1.00 | 1.30 | 4.25 |
| 10-bounded-repeat/capitals | 11 | 637.66 ± 7.8% | not timed | not timed | 616.58 ± 0.1% | 36.58 ± 0.2% | not timed | not timed | 639.22 ± 8.0% | | 1.00 | 1.03 | 17.43 |
| 11-unstructured-to-json/extract | 600 | 57.91 ± 0.9% | not timed | not timed | 76.50 ± 0.2% | 48.94 ± 0.9% | not timed | not timed | 57.69 ± 0.3% | | 1.00 | 0.76 | 1.18 |
| 12-dictionary/single | 1 | 560.76 ± 1.6% | not timed | not timed | 560.25 ± 0.1% | 0.41 ± 0.2% | not timed | not timed | 561.59 ± 1.4% | | 1.00 | 1.00 | 1380.70 |
| 14-quadratic/1x | 100 | 22.06 ± 0.7% | not timed | not timed | 10.01 ± 0.2% | 0.96 ± 4.6% | not timed | not timed | 22.10 ± 2.0% | | 1.00 | 2.20 | 22.91 |
| 14-quadratic/2x | 200 | 19.78 ± 0.9% | not timed | not timed | 5.55 ± 0.1% | 0.53 ± 2.2% | not timed | not timed | 19.88 ± 0.7% | | 1.00 | 3.56 | 37.44 |
| 14-quadratic/10x | 1000 | 12.34 ± 0.6% | not timed | not timed | 1.21 ± 0.2% | 0.12 ± 1.9% | not timed | not timed | 12.33 ± 1.2% | | 1.00 | 10.22 | 107.06 |

## Held-out compile, rebar's curated set, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 03-date/compile-ascii | 5 | 1.17 ± 1.0% | not timed | not timed | 0.34 ± 0.6% | 0.53 ± 3.8% | not timed | not timed | 1.19 ± 0.4% | | 0.99 | 3.44 | 2.20 |
| 04-ruff-noqa/compile-real | 1 | 102.87 ± 0.8% | not timed | not timed | 13.97 ± 1.1% | 127.25 ± 5.7% | not timed | not timed | 103.28 ± 0.3% | | 1.00 | 7.37 | 0.81 |
| 05-lexer-veryl/compile-single | 1 | 14.00 ± 0.5% | not timed | not timed | 2.52 ± 0.8% | 6.13 ± 6.2% | not timed | not timed | 14.00 ± 1.6% | | 1.00 | 5.55 | 2.28 |
| 07-unicode-character-data/compile | 1 | 107.23 ± 1.3% | not timed | not timed | 26.15 ± 0.2% | 33.95 ± 5.3% | not timed | not timed | 107.60 ± 0.6% | | 1.00 | 4.10 | 3.16 |
| 09-aws-keys/compile-full | 1 | 52.31 ± 0.8% | not timed | not timed | 8.32 ± 0.2% | 21.60 ± 11.2% | not timed | not timed | 52.54 ± 0.6% | | 1.00 | 6.29 | 2.42 |
| 09-aws-keys/compile-quick | 1 | 180.75 ± 0.4% | not timed | not timed | 47.69 ± 0.1% | 124.24 ± 2.4% | not timed | not timed | 182.42 ± 1.6% | | 0.99 | 3.79 | 1.45 |
| 10-bounded-repeat/compile-context | 1 | 70.54 ± 0.7% | not timed | not timed | 11.13 ± 0.4% | 15.11 ± 8.1% | not timed | not timed | 71.10 ± 2.4% | | 0.99 | 6.34 | 4.67 |
| 10-bounded-repeat/compile-capitals | 1 | 83.14 ± 3.3% | not timed | not timed | 8.06 ± 0.3% | 22.32 ± 7.6% | not timed | not timed | 84.46 ± 0.8% | | 0.98 | 10.31 | 3.73 |
| 11-unstructured-to-json/compile | 1 | 168.98 ± 1.0% | not timed | not timed | 41.26 ± 0.1% | 62.98 ± 3.1% | not timed | not timed | 170.34 ± 0.5% | | 0.99 | 4.10 | 2.68 |
| 12-dictionary/compile-single | 1 | 0.35 ± 0.5% | not timed | not timed | 0.07 ± 15.5% | 0.09 ± 15.4% | not timed | not timed | 0.35 ± 0.9% | | 1.00 | 5.33 | 3.73 |

## Search, rebar's other benchmarks, MB/s

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| captures/contiguous-letters | 81494 | 7.53 ± 5.9% | not timed | not timed | 6.54 ± 0.1% | 0.58 ± 18.2% | not timed | not timed | 7.52 ± 2.4% | | 1.00 | 1.15 | 12.90 |
| dictionary/search/english-10 | 690 | 198.93 ± 4.8% | not timed | not timed | 166.07 ± 0.6% | 0.00 ± 1.4% | not timed | not timed | 208.35 ± 1.8% | | 0.95 | 1.20 | 71081.62 |
| dictionary/search/english-15 | 15 | 561.64 ± 1.8% | not timed | not timed | 558.42 ± 0.1% | 0.37 ± 0.4% | not timed | not timed | 561.31 ± 1.4% | | 1.00 | 1.01 | 1538.35 |
| folly/awyer-inn-busted | 1 | 21501.89 ± 0.1% | not timed | not timed | 143.19 ± 0.1% | 43.89 ± 0.2% | not timed | not timed | 21572.14 ± 0.2% | | 1.00 | 150.17 | 489.91 |
| folly/literal-never-match-rare | 0 | 20491.02 ± 1.8% | not timed | not timed | 19398.26 ± 3.3% | 40086.15 ± 1.6% | not timed | not timed | 20320.61 ± 3.2% | | 1.01 | 1.06 | 0.51 |
| folly/literal-never-match-frequent | 0 | 12021.03 ± 2.0% | not timed | not timed | 18595.34 ± 2.8% | 2187.51 ± 1.1% | not timed | not timed | 12064.09 ± 1.4% | | 1.00 | 0.65 | 5.50 |
| folly/literal-never-match-tricksy | 1 | 3251.67 ± 0.5% | not timed | not timed | 4408.94 ± 0.2% | 3055.24 ± 0.1% | not timed | not timed | 3249.30 ± 0.2% | | 1.00 | 0.74 | 1.06 |
| grep/every-line | 239963 | 1297.33 ± 1.4% | not timed | not timed | 961.45 ± 0.2% | 379.86 ± 26.5% | not timed | not timed | 1306.89 ± 0.5% | | 0.99 | 1.35 | 3.42 |
| grep/long-words-ascii | 5073 | 458.49 ± 0.3% | not timed | not timed | 471.30 ± 0.1% | 45.97 ± 6.5% | not timed | not timed | 457.72 ± 0.3% | | 1.00 | 0.97 | 9.97 |
| imported/leipzig/twain | 811 | 18830.82 ± 3.4% | not timed | not timed | 17955.94 ± 3.5% | 11466.92 ± 22.1% | not timed | not timed | 19110.43 ± 5.5% | | 0.99 | 1.05 | 1.64 |
| imported/leipzig/twain-insensitive | 965 | 9069.10 ± 1.1% | not timed | not timed | 4200.75 ± 1.8% | 37.72 ± 0.1% | not timed | not timed | 9066.78 ± 1.0% | | 1.00 | 2.16 | 240.44 |
| imported/leipzig/shing | 1540 | 14519.37 ± 4.7% | not timed | not timed | 12498.39 ± 4.3% | 34.00 ± 0.1% | not timed | not timed | 14084.96 ± 4.8% | | 1.03 | 1.16 | 427.02 |
| imported/leipzig/huck-saw | 262 | 8025.72 ± 3.1% | not timed | not timed | 5514.90 ± 2.3% | 31.83 ± 0.2% | not timed | not timed | 8115.64 ± 3.1% | | 0.99 | 1.46 | 252.11 |
| imported/leipzig/word-ending-nn | 262 | 604.12 ± 0.7% | not timed | not timed | 616.97 ± 0.1% | 24.79 ± 0.4% | not timed | not timed | 606.03 ± 0.2% | | 1.00 | 0.98 | 24.37 |
| imported/leipzig/certain-long-strings-ending-x | 4094 | 10356.39 ± 11.5% | not timed | not timed | 4183.06 ± 5.6% | 11.49 ± 0.4% | not timed | not timed | 10643.91 ± 11.3% | | 0.97 | 2.48 | 901.14 |
| imported/leipzig/tom-sawyer-huckle-finn | 2598 | 7217.21 ± 4.0% | not timed | not timed | 5262.22 ± 2.6% | 16.85 ± 0.1% | not timed | not timed | 7189.76 ± 5.4% | | 1.00 | 1.37 | 428.20 |
| imported/leipzig/tom-sawyer-huckle-fin-insensitive | 4152 | 4027.42 ± 1.2% | not timed | not timed | 416.00 ± 1.0% | 11.06 ± 0.0% | not timed | not timed | 4039.02 ± 1.5% | | 1.00 | 9.68 | 363.99 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-short | 2598 | 6504.75 ± 9.1% | not timed | not timed | 614.44 ± 0.2% | 11.11 ± 0.0% | not timed | not timed | 6831.98 ± 11.5% | | 0.95 | 10.59 | 585.35 |
| imported/leipzig/tom-sawyer-huckle-fin-prefix-long | 1976 | 6874.44 ± 6.3% | not timed | not timed | 615.92 ± 0.1% | 9.75 ± 0.0% | not timed | not timed | 7003.15 ± 1.8% | | 0.98 | 11.16 | 704.81 |
| imported/leipzig/tom-river | 2 | 6132.46 ± 5.9% | not timed | not timed | 4913.35 ± 2.4% | 30.83 ± 0.2% | not timed | not timed | 5978.29 ± 6.1% | | 1.03 | 1.25 | 198.92 |
| imported/leipzig/ing | 78424 | 602.94 ± 0.4% | not timed | not timed | 570.37 ± 0.1% | 28.09 ± 3.4% | not timed | not timed | 602.35 ± 0.7% | | 1.00 | 1.06 | 21.46 |
| imported/leipzig/ing-whitespace | 55248 | 1893.04 ± 2.4% | not timed | not timed | 2058.65 ± 1.0% | 20.52 ± 3.1% | not timed | not timed | 1896.76 ± 1.0% | | 1.00 | 0.92 | 92.26 |
| imported/leipzig/awyer-inn | 209 | 6172.16 ± 3.2% | not timed | not timed | 4188.56 ± 1.7% | 22.54 ± 0.1% | not timed | not timed | 6169.41 ± 2.0% | | 1.00 | 1.47 | 273.78 |
| imported/leipzig/quotes-bounded | 8886 | 2411.53 ± 1.2% | not timed | not timed | 2905.33 ± 0.8% | 38.26 ± 0.2% | not timed | not timed | 2404.62 ± 0.8% | | 1.00 | 0.83 | 63.03 |
| imported/leipzig/non-ascii-alternate | 2 | 12404.61 ± 5.0% | not timed | not timed | 5518.03 ± 3.4% | 50.64 ± 0.1% | not timed | not timed | 12521.35 ± 3.5% | | 0.99 | 2.25 | 244.95 |
| imported/leipzig/math-symbols | 69 | 1980.00 ± 0.4% | not timed | not timed | 613.72 ± 0.1% | 36.48 ± 0.1% | not timed | not timed | 1975.93 ± 0.2% | | 1.00 | 3.23 | 54.28 |
| imported/leipzig/bounded-strings-ending-z | 0 | 630.21 ± 1.8% | not timed | not timed | 616.14 ± 0.1% | 22.45 ± 0.2% | not timed | not timed | 628.51 ± 1.7% | | 1.00 | 1.02 | 28.07 |
| imported/lh3lh3-reb/uri | 17549 | 676.41 ± 0.1% | not timed | not timed | 1083.09 ± 0.2% | 28.32 ± 2.3% | not timed | not timed | 679.06 ± 0.2% | | 1.00 | 0.62 | 23.88 |
| imported/lh3lh3-reb/email | 15057 | 673.75 ± 0.2% | not timed | not timed | 1159.41 ± 0.1% | 30.36 ± 2.5% | not timed | not timed | 675.56 ± 0.2% | | 1.00 | 0.58 | 22.19 |
| imported/lh3lh3-reb/date | 668 | 889.29 ± 0.2% | not timed | not timed | 1041.45 ± 0.2% | 49.53 ± 3.9% | not timed | not timed | 888.88 ± 0.4% | | 1.00 | 0.85 | 17.96 |
| imported/lh3lh3-reb/uri-or-email | 32539 | 644.96 ± 0.4% | not timed | not timed | 425.34 ± 0.1% | 15.64 ± 1.4% | not timed | not timed | 646.09 ± 0.4% | | 1.00 | 1.52 | 41.24 |
| imported/mariomka/email | 92 | 23597.13 ± 3.0% | not timed | not timed | 28795.83 ± 2.1% | 32.84 ± 0.1% | not timed | not timed | 23540.03 ± 3.7% | | 1.00 | 0.82 | 718.51 |
| imported/mariomka/uri | 5301 | 5154.24 ± 4.0% | not timed | not timed | 5777.43 ± 1.2% | 32.79 ± 0.4% | not timed | not timed | 5173.09 ± 5.0% | | 1.00 | 0.89 | 157.20 |
| imported/mariomka/ip | 5 | 2522.96 ± 3.5% | not timed | not timed | 2808.59 ± 2.4% | 21.03 ± 0.2% | not timed | not timed | 2500.23 ± 3.2% | | 1.01 | 0.90 | 119.99 |
| imported/rsc/no-exponential | 0 | 610.58 ± 0.2% | not timed | not timed | 322.76 ± 0.2% | 23.78 ± 0.3% | not timed | not timed | 612.41 ± 0.4% | | 1.00 | 1.89 | 25.67 |
| imported/rsc/literal | 1 | 1432.17 ± 8.3% | not timed | not timed | 1635.75 ± 0.4% | 213.33 ± 13.4% | not timed | not timed | 1545.66 ± 8.3% | | 0.93 | 0.88 | 6.71 |
| imported/rsc/not-literal | 2 | 776.20 ± 0.2% | not timed | not timed | 737.13 ± 0.4% | 46.10 ± 1.5% | not timed | not timed | 777.42 ± 8.5% | | 1.00 | 1.05 | 16.84 |
| imported/rsc/match-class | 1 | 1470.35 ± 3.3% | not timed | not timed | 1640.06 ± 0.5% | 58.39 ± 13.4% | not timed | not timed | 1471.82 ± 0.5% | | 1.00 | 0.90 | 25.18 |
| imported/rsc/match-class-in-range | 1 | 1470.10 ± 0.6% | not timed | not timed | 2360.10 ± 0.3% | 60.00 ± 0.2% | not timed | not timed | 1474.20 ± 0.3% | | 1.00 | 0.62 | 24.50 |
| imported/rsc/match-class-unicode | 1 | 541.84 ± 0.3% | not timed | not timed | 512.29 ± 0.2% | 70.91 ± 7.7% | not timed | not timed | 542.41 ± 2.3% | | 1.00 | 1.06 | 7.64 |
| imported/rsc/anchored-literal-short-non-match | 0 | 1435.64 ± 0.1% | not timed | not timed | 953.04 ± 0.1% | 228.54 ± 0.4% | not timed | not timed | 1424.91 ± 0.1% | | 1.01 | 1.51 | 6.28 |
| imported/rsc/anchored-literal-long-non-match | 0 | 21495.94 ± 0.2% | not timed | not timed | 14221.24 ± 0.2% | 3423.35 ± 0.6% | not timed | not timed | 21357.27 ± 0.1% | | 1.01 | 1.51 | 6.28 |
| imported/rsc/anchored-literal-short-match | 4 | 717.53 ± 4.7% | not timed | not timed | 491.97 ± 0.1% | 82.49 ± 9.9% | not timed | not timed | 717.23 ± 2.6% | | 1.00 | 1.46 | 8.70 |
| imported/rsc/anchored-literal-long-match | 4 | 10790.08 ± 2.0% | not timed | not timed | 7315.52 ± 0.3% | 1253.94 ± 5.1% | not timed | not timed | 10765.09 ± 2.7% | | 1.00 | 1.47 | 8.60 |
| imported/rsc/one-pass-short | 17 | 362.16 ± 12.4% | not timed | not timed | 214.22 ± 0.2% | 31.47 ± 13.0% | not timed | not timed | 363.48 ± 3.1% | | 1.00 | 1.69 | 11.51 |
| imported/rsc/one-pass-short-not | 17 | 265.86 ± 4.0% | not timed | not timed | 225.93 ± 0.3% | 29.70 ± 10.4% | not timed | not timed | 265.36 ± 1.1% | | 1.00 | 1.18 | 8.95 |
| imported/rsc/one-pass-long-prefix | 26 | 352.86 ± 2.3% | not timed | not timed | 277.05 ± 0.2% | 107.19 ± 17.4% | not timed | not timed | 354.82 ± 8.2% | | 0.99 | 1.27 | 3.29 |
| imported/rsc/one-pass-long-prefix-not | 26 | 353.51 ± 2.0% | not timed | not timed | 283.17 ± 0.9% | 64.12 ± 19.2% | not timed | not timed | 356.58 ± 2.3% | | 0.99 | 1.25 | 5.51 |
| imported/rsc/long-needle1 | 31 | 21912.84 ± 0.3% | not timed | not timed | 20131.66 ± 0.1% | 3.75 ± 0.2% | not timed | not timed | 21911.52 ± 0.3% | | 1.00 | 1.09 | 5845.61 |
| imported/rsc/long-needle2 | 31 | 22067.67 ± 0.2% | not timed | not timed | 216.77 ± 0.2% | 3.74 ± 0.2% | not timed | not timed | 22061.02 ± 0.1% | | 1.00 | 101.80 | 5893.81 |
| imported/rsc/easy0-32 | 26 | 1596.44 ± 0.1% | not timed | not timed | 1624.35 ± 0.1% | 148.96 ± 22.8% | not timed | not timed | 1590.04 ± 2.1% | | 1.00 | 0.98 | 10.72 |
| imported/rsc/easy0-1k | 26 | 13735.94 ± 0.1% | not timed | not timed | 12548.81 ± 0.2% | 2300.33 ± 15.6% | not timed | not timed | 13724.64 ± 2.0% | | 1.00 | 1.09 | 5.97 |
| imported/rsc/easy0-32k | 26 | 22738.74 ± 1.2% | not timed | not timed | 20319.58 ± 0.2% | 18739.15 ± 24.0% | not timed | not timed | 22759.50 ± 0.4% | | 1.00 | 1.12 | 1.21 |
| imported/rsc/easy0-1mb | 26 | 21364.85 ± 1.4% | not timed | not timed | 19534.03 ± 0.8% | 35747.18 ± 2.6% | not timed | not timed | 21220.65 ± 1.6% | | 1.01 | 1.09 | 0.60 |
| imported/rsc/easy1-32 | 19 | 751.35 ± 2.8% | not timed | not timed | 635.19 ± 0.5% | 129.19 ± 16.3% | not timed | not timed | 762.53 ± 0.2% | | 0.99 | 1.18 | 5.82 |
| imported/rsc/easy1-1k | 19 | 15657.27 ± 2.1% | not timed | not timed | 12836.64 ± 0.2% | 2470.23 ± 17.3% | not timed | not timed | 15635.15 ± 0.1% | | 1.00 | 1.22 | 6.34 |
| imported/rsc/easy1-32k | 19 | 491512.37 ± 0.2% | not timed | not timed | 400529.23 ± 0.0% | 20342.45 ± 24.2% | not timed | not timed | 489292.41 ± 2.4% | | 1.00 | 1.23 | 24.16 |
| imported/rsc/easy1-1mb | 19 | 15763621.20 ± 0.4% | not timed | not timed | 12802590.52 ± 0.2% | 38428.67 ± 1.5% | not timed | not timed | 15707151.59 ± 3.1% | | 1.00 | 1.23 | 410.20 |
| imported/rsc/medium-32 | 27 | 729.14 ± 0.2% | not timed | not timed | 641.22 ± 0.3% | 69.74 ± 14.4% | not timed | not timed | 732.17 ± 0.4% | | 1.00 | 1.14 | 10.45 |
| imported/rsc/medium-1k | 27 | 12972.82 ± 0.2% | not timed | not timed | 11352.99 ± 0.1% | 72.13 ± 0.1% | not timed | not timed | 13003.34 ± 0.1% | | 1.00 | 1.14 | 179.86 |
| imported/rsc/medium-32k | 27 | 404871.88 ± 0.2% | not timed | not timed | 349487.61 ± 0.1% | 48.88 ± 0.2% | not timed | not timed | 405550.19 ± 0.2% | | 1.00 | 1.16 | 8283.50 |
| imported/rsc/medium-1mb | 27 | 12921247.18 ± 0.2% | not timed | not timed | 11386234.38 ± 0.2% | 48.62 ± 0.4% | not timed | not timed | 12970549.04 ± 0.2% | | 1.00 | 1.13 | 265753.84 |
| imported/rsc/hard-32 | 58 | 422.21 ± 2.3% | not timed | not timed | 367.65 ± 0.2% | 49.45 ± 9.0% | not timed | not timed | 422.12 ± 0.1% | | 1.00 | 1.15 | 8.54 |
| imported/rsc/hard-1k | 27 | 12835.38 ± 0.2% | not timed | not timed | 11515.70 ± 0.3% | 40.75 ± 0.0% | not timed | not timed | 12802.58 ± 0.2% | | 1.00 | 1.11 | 315.01 |
| imported/rsc/hard-32k | 27 | 401105.53 ± 0.3% | not timed | not timed | 362955.71 ± 0.3% | 29.37 ± 0.1% | not timed | not timed | 399912.11 ± 0.2% | | 1.00 | 1.11 | 13655.74 |
| imported/rsc/hard-1mb | 51 | 8351619.39 ± 0.1% | not timed | not timed | 7265103.27 ± 0.1% | 29.35 ± 0.1% | not timed | not timed | 8366992.78 ± 0.2% | | 1.00 | 1.15 | 284552.28 |
| imported/rsc/reallyhard0-32 | 58 | 263.64 ± 2.6% | not timed | not timed | 223.04 ± 0.2% | 49.65 ± 7.1% | not timed | not timed | 263.45 ± 0.2% | | 1.00 | 1.18 | 5.31 |
| imported/rsc/reallyhard0-1k | 27 | 583.10 ± 0.2% | not timed | not timed | 580.95 ± 0.2% | 40.64 ± 0.2% | not timed | not timed | 581.86 ± 0.3% | | 1.00 | 1.00 | 14.35 |
| imported/rsc/reallyhard0-32k | 27 | 602.14 ± 0.5% | not timed | not timed | 618.01 ± 0.1% | 29.38 ± 0.1% | not timed | not timed | 600.26 ± 0.2% | | 1.00 | 0.97 | 20.50 |
| imported/rsc/reallyhard0-1mb | 51 | 623.56 ± 1.4% | not timed | not timed | 613.10 ± 0.5% | 29.31 ± 0.2% | not timed | not timed | 619.97 ± 0.8% | | 1.01 | 1.02 | 21.27 |
| imported/rsc/reallyreallyhard0-32 | 47 | 223.77 ± 4.0% | not timed | not timed | 196.70 ± 0.2% | 60.77 ± 13.7% | not timed | not timed | 285.42 ± 1.4% | | 0.78 | 1.14 | 3.68 |
| imported/rsc/reallyreallyhard0-1k | 16 | 6932.69 ± 0.1% | not timed | not timed | 5934.41 ± 0.1% | 34.13 ± 0.8% | not timed | not timed | 7061.79 ± 0.1% | | 0.98 | 1.17 | 203.12 |
| imported/rsc/reallyreallyhard0-32k | 16 | 21503.83 ± 0.2% | not timed | not timed | 19289.67 ± 0.1% | 24.38 ± 0.8% | not timed | not timed | 21540.73 ± 0.0% | | 1.00 | 1.11 | 882.01 |
| imported/rsc/reallyreallyhard0-1mb | 40 | 21655.54 ± 1.9% | not timed | not timed | 19849.76 ± 1.4% | 24.76 ± 1.9% | not timed | not timed | 21638.56 ± 2.0% | | 1.00 | 1.09 | 874.54 |
| imported/rsc/reallyreallyreallyhard0-32 | 51 | 278.94 ± 2.0% | not timed | not timed | 212.14 ± 0.3% | 61.32 ± 11.2% | not timed | not timed | 281.19 ± 1.3% | | 0.99 | 1.31 | 4.55 |
| imported/rsc/reallyreallyreallyhard0-1k | 20 | 5939.53 ± 0.1% | not timed | not timed | 6188.66 ± 0.1% | 34.45 ± 3.1% | not timed | not timed | 5937.01 ± 0.1% | | 1.00 | 0.96 | 172.39 |
| imported/rsc/reallyreallyreallyhard0-32k | 20 | 21286.49 ± 0.0% | not timed | not timed | 19155.79 ± 0.2% | 24.76 ± 0.4% | not timed | not timed | 21397.63 ± 0.1% | | 0.99 | 1.11 | 859.62 |
| imported/rsc/reallyreallyreallyhard0-1mb | 44 | 21198.20 ± 2.3% | not timed | not timed | 19567.51 ± 1.5% | 24.77 ± 0.2% | not timed | not timed | 21193.07 ± 1.2% | | 1.00 | 1.08 | 855.94 |
| imported/sherlock/name-sherlock | 776 | 19711.45 ± 7.7% | not timed | not timed | 18348.78 ± 1.2% | 10109.06 ± 14.2% | not timed | not timed | 19699.84 ± 3.0% | | 1.00 | 1.07 | 1.95 |
| imported/sherlock/name-holmes | 2766 | 15071.90 ± 1.5% | not timed | not timed | 15461.59 ± 0.5% | 3146.97 ± 11.0% | not timed | not timed | 15210.04 ± 1.3% | | 0.99 | 0.97 | 4.79 |
| imported/sherlock/name-sherlock-holmes | 1365 | 19659.01 ± 2.2% | not timed | not timed | 18348.40 ± 0.9% | 8061.72 ± 48.5% | not timed | not timed | 19684.43 ± 2.3% | | 1.00 | 1.07 | 2.44 |
| imported/sherlock/name-sherlock-casei | 816 | 15646.11 ± 0.6% | not timed | not timed | 4019.57 ± 0.2% | 32.45 ± 0.2% | not timed | not timed | 15660.26 ± 0.6% | | 1.00 | 3.89 | 482.13 |
| imported/sherlock/name-holmes-casei | 2802 | 9372.08 ± 5.6% | not timed | not timed | 3312.23 ± 0.1% | 37.08 ± 1.9% | not timed | not timed | 9405.26 ± 2.0% | | 1.00 | 2.83 | 252.73 |
| imported/sherlock/name-sherlock-holmes-casei | 1440 | 12805.48 ± 8.0% | not timed | not timed | 3956.06 ± 0.1% | 32.49 ± 0.2% | not timed | not timed | 12828.74 ± 1.7% | | 1.00 | 3.24 | 394.13 |
| imported/sherlock/name-whitespace | 1461 | 14838.76 ± 1.9% | not timed | not timed | 14372.75 ± 0.5% | 6572.17 ± 19.6% | not timed | not timed | 15293.05 ± 1.5% | | 0.97 | 1.03 | 2.26 |
| imported/sherlock/name-alt1 | 1142 | 11615.57 ± 0.4% | not timed | not timed | 16283.11 ± 1.0% | 4111.02 ± 25.4% | not timed | not timed | 11629.85 ± 2.5% | | 1.00 | 0.71 | 2.83 |
| imported/sherlock/name-alt2 | 3542 | 8946.46 ± 0.3% | not timed | not timed | 3824.69 ± 0.3% | 31.46 ± 0.1% | not timed | not timed | 8961.24 ± 0.2% | | 1.00 | 2.34 | 284.40 |
| imported/sherlock/name-alt3 | 4507 | 5555.40 ± 0.7% | not timed | not timed | 3629.82 ± 0.1% | 9.96 ± 0.4% | not timed | not timed | 5536.35 ± 0.5% | | 1.00 | 1.53 | 557.94 |
| imported/sherlock/name-alt3-casei | 4593 | 1527.40 ± 2.4% | not timed | not timed | 285.51 ± 0.1% | 6.44 ± 0.2% | not timed | not timed | 1527.66 ± 0.6% | | 1.00 | 5.35 | 237.24 |
| imported/sherlock/name-alt4 | 3686 | 6404.15 ± 0.2% | not timed | not timed | 3793.03 ± 0.2% | 31.35 ± 0.2% | not timed | not timed | 6406.98 ± 0.3% | | 1.00 | 1.69 | 204.28 |
| imported/sherlock/name-alt4-casei | 4254 | 2801.82 ± 2.2% | not timed | not timed | 2584.91 ± 0.3% | 19.82 ± 0.1% | not timed | not timed | 2814.51 ± 0.9% | | 1.00 | 1.08 | 141.40 |
| imported/sherlock/name-alt5 | 4028 | 6388.29 ± 0.4% | not timed | not timed | 3744.91 ± 0.1% | 21.86 ± 0.1% | not timed | not timed | 6392.79 ± 0.2% | | 1.00 | 1.71 | 292.22 |
| imported/sherlock/name-alt5-casei | 4104 | 3479.28 ± 2.1% | not timed | not timed | 2224.58 ± 0.1% | 14.33 ± 0.1% | not timed | not timed | 3492.19 ± 0.8% | | 1.00 | 1.56 | 242.83 |
| imported/sherlock/no-match-uncommon | 0 | 21379.67 ± 0.6% | not timed | not timed | 19351.82 ± 0.9% | 34768.37 ± 0.4% | not timed | not timed | 21402.13 ± 0.7% | | 1.00 | 1.10 | 0.61 |
| imported/sherlock/no-match-common | 0 | 21212.03 ± 0.3% | not timed | not timed | 19240.23 ± 0.4% | 1291.47 ± 1.3% | not timed | not timed | 21188.50 ± 0.4% | | 1.00 | 1.10 | 16.42 |
| imported/sherlock/no-match-really-common | 0 | 15996.80 ± 2.6% | not timed | not timed | 18473.04 ± 1.0% | 1279.06 ± 0.8% | not timed | not timed | 16072.04 ± 0.8% | | 1.00 | 0.87 | 12.51 |
| imported/sherlock/the-lower | 21654 | 2296.65 ± 1.4% | not timed | not timed | 2333.20 ± 0.2% | 237.07 ± 16.2% | not timed | not timed | 2307.44 ± 1.6% | | 1.00 | 0.98 | 9.69 |
| imported/sherlock/the-upper | 2223 | 12676.46 ± 0.9% | not timed | not timed | 13508.30 ± 0.7% | 2699.44 ± 15.2% | not timed | not timed | 12694.32 ± 1.2% | | 1.00 | 0.94 | 4.70 |
| imported/sherlock/the-casei | 23961 | 1991.79 ± 0.1% | not timed | not timed | 1318.05 ± 0.2% | 34.49 ± 36.2% | not timed | not timed | 1991.40 ± 1.5% | | 1.00 | 1.51 | 57.74 |
| imported/sherlock/everything-greedy | 581881 | 281.96 ± 1.0% | not timed | not timed | 163.70 ± 0.1% | 28.96 ± 36.1% | not timed | not timed | 282.29 ± 1.2% | | 1.00 | 1.72 | 9.74 |
| imported/sherlock/everything-greedy-nl | 594933 | 490.95 ± 0.1% | not timed | not timed | 213.92 ± 0.1% | 33.05 ± 0.2% | not timed | not timed | 489.85 ± 0.1% | | 1.00 | 2.29 | 14.85 |
| imported/sherlock/letters | 447175 | 61.30 ± 0.8% | not timed | not timed | 32.98 ± 0.2% | 6.46 ± 4.7% | not timed | not timed | 61.74 ± 0.8% | | 0.99 | 1.86 | 9.50 |
| imported/sherlock/letters-upper | 14180 | 447.85 ± 1.3% | not timed | not timed | 369.18 ± 0.0% | 29.51 ± 20.9% | not timed | not timed | 445.98 ± 0.2% | | 1.00 | 1.21 | 15.18 |
| imported/sherlock/letters-lower | 432995 | 62.45 ± 0.9% | not timed | not timed | 33.65 ± 0.1% | 4.87 ± 30.7% | not timed | not timed | 62.71 ± 0.6% | | 1.00 | 1.86 | 12.82 |
| imported/sherlock/words | 447639 | 112.60 ± 1.1% | not timed | not timed | 82.99 ± 0.2% | 13.63 ± 5.3% | not timed | not timed | 112.95 ± 0.9% | | 1.00 | 1.36 | 8.26 |
| imported/sherlock/before-holmes | 4073 | 9951.93 ± 0.5% | not timed | not timed | 8444.64 ± 0.5% | 23.87 ± 1.8% | not timed | not timed | 10237.22 ± 0.2% | | 0.97 | 1.18 | 416.98 |
| imported/sherlock/before-after-holmes | 2593 | 9802.98 ± 0.8% | not timed | not timed | 9502.22 ± 0.3% | 24.18 ± 1.7% | not timed | not timed | 9861.26 ± 0.7% | | 0.99 | 1.03 | 405.49 |
| imported/sherlock/holmes-cochar-watson | 150 | 5190.83 ± 0.2% | not timed | not timed | 3427.68 ± 0.2% | 31.02 ± 0.3% | not timed | not timed | 5206.59 ± 0.2% | | 1.00 | 1.51 | 167.34 |
| imported/sherlock/holmes-coword-watson | 14309 | 1157.41 ± 0.2% | not timed | not timed | 1122.23 ± 0.1% | 6.70 ± 0.1% | not timed | not timed | 1153.25 ± 0.2% | | 1.00 | 1.03 | 172.65 |
| imported/sherlock/quotes | 14437 | 1571.37 ± 0.5% | not timed | not timed | 1757.32 ± 1.1% | 35.10 ± 0.1% | not timed | not timed | 1570.01 ± 0.3% | | 1.00 | 0.89 | 44.77 |
| imported/sherlock/line-boundary-sherlock-holmes | 510 | 17287.56 ± 0.5% | not timed | not timed | 15992.44 ± 0.9% | 36.84 ± 0.3% | not timed | not timed | 17183.63 ± 1.0% | | 1.01 | 1.08 | 469.22 |
| imported/sherlock/word-ending-n | 35297 | 477.23 ± 0.3% | not timed | not timed | 409.21 ± 0.2% | 23.58 ± 23.0% | not timed | not timed | 480.14 ± 1.3% | | 0.99 | 1.17 | 20.24 |
| imported/sherlock/repeated-class-negation | 2130 | 14679.69 ± 1.0% | not timed | not timed | 10978.65 ± 2.0% | 11.59 ± 0.3% | not timed | not timed | 14671.98 ± 0.5% | | 1.00 | 1.34 | 1266.45 |
| imported/sherlock/ing-suffix | 20547 | 558.71 ± 0.3% | not timed | not timed | 517.14 ± 0.1% | 28.91 ± 0.1% | not timed | not timed | 559.47 ± 0.4% | | 1.00 | 1.08 | 19.33 |
| imported/sherlock/ing-suffix-limited-space | 19658 | 1663.00 ± 0.3% | not timed | not timed | 2112.10 ± 0.5% | 20.53 ± 0.1% | not timed | not timed | 1661.73 ± 0.5% | | 1.00 | 0.79 | 80.99 |
| opt/accelerate/whole-line | 239963 | 458.01 ± 0.4% | not timed | not timed | 374.36 ± 0.1% | 91.74 ± 14.0% | not timed | not timed | 457.64 ± 0.1% | | 1.00 | 1.22 | 4.99 |
| opt/accelerate/non-dna | 16745 | 429.80 ± 1.0% | not timed | not timed | 398.78 ± 0.2% | 29.38 ± 67.5% | not timed | not timed | 428.95 ± 0.6% | | 1.00 | 1.08 | 14.63 |
| opt/backtrack/words-english | 40536 | 140.71 ± 1.8% | not timed | not timed | 93.41 ± 0.2% | 19.57 ± 7.7% | not timed | not timed | 140.85 ± 2.8% | | 1.00 | 1.51 | 7.19 |
| opt/fixed-length/too-small-ascii | 0 | 311.35 ± 0.2% | not timed | not timed | 707.81 ± 0.3% | 80.08 ± 0.7% | not timed | not timed | 313.00 ± 0.2% | | 0.99 | 0.44 | 3.89 |
| opt/fixed-length/too-big-ascii | 0 | 3348.18 ± 0.1% | not timed | not timed | 5825.42 ± 0.1% | 122.32 ± 3.8% | not timed | not timed | 3336.40 ± 0.1% | | 1.00 | 0.57 | 27.37 |
| opt/fixed-length/go33484-1 | 0 | 644243.50 ± 0.4% | not timed | not timed | 1111756.67 ± 0.2% | 61516.61 ± 0.3% | not timed | not timed | 640996.71 ± 0.1% | | 1.01 | 0.58 | 10.47 |
| opt/fixed-length/go33484-2 | 0 | 644059.36 ± 0.1% | not timed | not timed | 1124982.07 ± 0.0% | 32022.31 ± 0.5% | not timed | not timed | 641056.90 ± 0.1% | | 1.00 | 0.57 | 20.11 |
| opt/fixed-length/go33484-3 | 0 | 64416.19 ± 0.6% | not timed | not timed | 111826.28 ± 0.1% | 763.50 ± 0.1% | not timed | not timed | 64088.70 ± 0.5% | | 1.01 | 0.58 | 84.37 |
| opt/literal-alt/one-pattern | 1 | 548.70 ± 12.3% | not timed | not timed | 536.07 ± 0.2% | 0.40 ± 0.5% | not timed | not timed | 548.76 ± 1.5% | | 1.00 | 1.02 | 1371.66 |
| opt/onepass/fn-predicate | 916 | 364.16 ± 0.7% | not timed | not timed | 335.78 ± 0.1% | 196.24 ± 13.2% | not timed | not timed | 365.54 ± 1.0% | | 1.00 | 1.08 | 1.86 |
| opt/onepass/first-three-words-english | 35128 | 177.85 ± 11.5% | not timed | not timed | 199.77 ± 0.1% | 80.36 ± 9.5% | not timed | not timed | 180.37 ± 2.2% | | 0.99 | 0.89 | 2.21 |
| opt/prefilter/literal-english | 1 | 20508.40 ± 0.6% | not timed | not timed | 19666.42 ± 0.5% | 17413.95 ± 0.5% | not timed | not timed | 20470.89 ± 0.6% | | 1.00 | 1.04 | 1.18 |
| opt/prefilter/literal-casei-english | 1 | 14439.85 ± 0.7% | not timed | not timed | 4316.53 ± 0.2% | 32.59 ± 0.5% | not timed | not timed | 14455.32 ± 0.2% | | 1.00 | 3.35 | 443.10 |
| opt/prefilter/literal-russian | 1 | 20737.31 ± 0.6% | not timed | not timed | 19568.16 ± 0.7% | 3316.32 ± 0.3% | not timed | not timed | 20731.03 ± 1.1% | | 1.00 | 1.06 | 6.25 |
| opt/prefilter/literal-casei-russian | 1 | 8574.48 ± 0.2% | not timed | not timed | 3880.64 ± 0.1% | 31.72 ± 0.5% | not timed | not timed | 8571.11 ± 0.1% | | 1.00 | 2.21 | 270.30 |
| opt/prefilter/rust-functions | 948 | 6464.22 ± 1.9% | not timed | not timed | 8182.44 ± 2.0% | 1844.72 ± 0.5% | not timed | not timed | 6543.70 ± 5.0% | | 0.99 | 0.79 | 3.50 |
| opt/reverse-anchored/word-end | 1 | 29074634.92 ± 0.1% | not timed | not timed | 21272167.75 ± 0.6% | 50.22 ± 0.3% | not timed | not timed | 29053652.89 ± 0.1% | | 1.00 | 1.37 | 578889.39 |
| opt/reverse-inner/holmes | 2593 | 9821.13 ± 1.1% | not timed | not timed | 9527.85 ± 0.5% | 23.98 ± 2.4% | not timed | not timed | 9852.19 ± 0.9% | | 1.00 | 1.03 | 409.58 |
| opt/reverse-inner/email | 47 | 35540.44 ± 2.5% | not timed | not timed | 43101.08 ± 1.8% | 32.43 ± 0.4% | not timed | not timed | 35312.35 ± 4.2% | | 1.01 | 0.82 | 1095.99 |
| opt/reverse-inner/factored-prefix | 3542 | 592.13 ± 0.4% | not timed | not timed | 595.89 ± 0.0% | 12.54 ± 0.3% | not timed | not timed | 591.27 ± 0.4% | | 1.00 | 0.99 | 47.22 |
| opt/reverse-inner/no-quadratic-backward | 0 | 21023.56 ± 0.2% | not timed | not timed | 618.92 ± 0.2% | 75.04 ± 3.6% | not timed | not timed | 21172.06 ± 0.0% | | 0.99 | 33.97 | 280.15 |
| opt/reverse-inner/no-quadratic-forward | 0 | 739.16 ± 4.3% | not timed | not timed | 288.99 ± 0.2% | 24.25 ± 0.2% | not timed | not timed | 744.11 ± 2.2% | | 0.99 | 2.56 | 30.49 |
| opt/reverse-suffix/holmes | 4073 | 9924.25 ± 0.4% | not timed | not timed | 8477.41 ± 0.4% | 24.12 ± 1.2% | not timed | not timed | 10218.90 ± 0.3% | | 0.97 | 1.17 | 411.39 |
| opt/reverse-suffix/no-quadratic | 0 | 21087.66 ± 0.0% | not timed | not timed | 618.39 ± 0.8% | 71.54 ± 0.1% | not timed | not timed | 21160.52 ± 0.0% | | 1.00 | 34.10 | 294.76 |
| opt/reverse-suffix/unsound-leftmost-first | 1 | 119.12 ± 4.3% | not timed | not timed | 133.90 ± 0.1% | 13.30 ± 15.9% | not timed | not timed | 119.56 ± 3.0% | | 1.00 | 0.89 | 8.96 |
| opt/reverse-suffix/unsound-start-literal-order-mismatch | 1 | 117.78 ± 2.5% | not timed | not timed | 135.81 ± 0.1% | 12.99 ± 13.5% | not timed | not timed | 119.89 ± 0.4% | | 0.98 | 0.87 | 9.07 |
| reported/i1095-word-repetition/unicode-search | 512 | 0.28 ± 0.1% | not timed | not timed | 0.55 ± 0.4% | 112.27 ± 0.2% | not timed | not timed | 0.28 ± 0.1% | | 0.99 | 0.50 | 0.0025 |
| reported/i1095-word-repetition/ascii-search | 256 | 320.35 ± 0.2% | not timed | not timed | 294.08 ± 0.1% | 104.27 ± 8.0% | not timed | not timed | 318.94 ± 3.6% | | 1.00 | 1.09 | 3.07 |
| reported/i13-subset-regex/original-ascii | 4094 | 10538.24 ± 12.5% | not timed | not timed | 4218.44 ± 5.7% | 11.50 ± 0.1% | not timed | not timed | 10566.40 ± 2.1% | | 1.00 | 2.50 | 916.26 |
| reported/i13-subset-regex/original-unicode | 4094 | 10704.57 ± 2.4% | not timed | not timed | 247.11 ± 3.1% | 11.52 ± 0.1% | not timed | not timed | 10885.29 ± 3.7% | | 0.98 | 43.32 | 929.28 |
| reported/i13-subset-regex/big-ascii | 1955 | 9592.11 ± 18.2% | not timed | not timed | 67.71 ± 3.7% | 9.84 ± 0.1% | not timed | not timed | 9561.79 ± 7.5% | | 1.00 | 141.66 | 974.34 |
| reported/i13-subset-regex/big-unicode | 1955 | 9407.99 ± 8.0% | not timed | not timed | 12.19 ± 55.0% | 9.86 ± 0.2% | not timed | not timed | 9777.66 ± 8.6% | | 0.96 | 771.98 | 954.23 |
| reported/i13-subset-regex/huge-ascii | 55 | 8669.38 ± 4.0% | not timed | not timed | 11.03 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 8658.73 ± 8.1% | | 1.00 | 786.10 | 989.99 |
| reported/i13-subset-regex/huge-unicode | 55 | 9605.99 ± 12.1% | not timed | not timed | 10.94 ± 0.2% | 8.76 ± 0.1% | not timed | not timed | 9530.07 ± 9.4% | | 1.01 | 878.06 | 1096.10 |
| reported/i13-subset-regex/huge-ascii-nosuffixlit | 55 | 3.53 ± 0.1% | not timed | not timed | 11.05 ± 0.1% | 8.76 ± 0.1% | not timed | not timed | 3.52 ± 0.0% | | 1.00 | 0.32 | 0.40 |
| reported/i13-subset-regex/huge-unicode-nosuffixlit | 55 | 4.97 ± 0.1% | not timed | not timed | 11.00 ± 0.3% | 8.77 ± 1.3% | not timed | not timed | 4.97 ± 0.0% | | 1.00 | 0.45 | 0.57 |
| reported/i787-keywords/ascii | 5674 | 476.42 ± 0.4% | not timed | not timed | 104.62 ± 0.2% | 6.63 ± 0.2% | not timed | not timed | 485.11 ± 0.3% | | 0.98 | 4.55 | 71.83 |
| reported/i787-keywords/opt-ascii | 5674 | 485.43 ± 0.3% | not timed | not timed | 271.22 ± 0.1% | 10.27 ± 0.2% | not timed | not timed | 483.94 ± 0.5% | | 1.00 | 1.79 | 47.28 |
| slow/quadratic-regex-1x | 100 | 7.09 ± 0.3% | not timed | not timed | 5.00 ± 0.2% | 0.05 ± 0.3% | not timed | not timed | 7.15 ± 0.4% | | 0.99 | 1.42 | 143.68 |
| slow/quadratic-regex-2x | 199 | 3.42 ± 0.2% | not timed | not timed | 2.77 ± 0.1% | 0.01 ± 0.3% | not timed | not timed | 3.43 ± 0.2% | | 1.00 | 1.24 | 269.72 |
| slow/quadratic-haystack-1x | 100 | 22.20 ± 7.9% | not timed | not timed | 10.05 ± 0.1% | 1.01 ± 14.6% | not timed | not timed | 22.11 ± 1.5% | | 1.00 | 2.21 | 22.07 |
| slow/quadratic-haystack-2x | 200 | 19.69 ± 1.0% | not timed | not timed | 5.55 ± 0.2% | 0.54 ± 0.8% | not timed | not timed | 19.67 ± 6.9% | | 1.00 | 3.55 | 36.22 |
| unicode/codepoints/any-one | 1112064 | 282.16 ± 0.2% | not timed | not timed | 176.68 ± 0.2% | 18.06 ± 21.3% | not timed | not timed | 282.33 ± 0.5% | | 1.00 | 1.60 | 15.62 |
| unicode/codepoints/any-all | 4382592 | 282.51 ± 1.0% | not timed | not timed | 247.14 ± 0.2% | 117.42 ± 0.1% | not timed | not timed | 283.34 ± 0.4% | | 1.00 | 1.14 | 2.41 |
| unicode/codepoints/letters-one | Go 1244, Rust 1289, RE2 1250 | differs | not timed | not timed | 8.70 ± 0.5% | differs | not timed | not timed | differs | | | | |
| unicode/codepoints/contiguous-greek | 36 | 602.99 ± 0.3% | not timed | not timed | 615.82 ± 0.2% | 135.30 ± 0.2% | not timed | not timed | 603.35 ± 0.4% | | 1.00 | 0.98 | 4.46 |
| unicode/overlapping-words/ascii | 6156 | 31.78 ± 0.4% | not timed | not timed | 38.96 ± 0.1% | 3.94 ± 0.5% | not timed | not timed | 31.77 ± 0.3% | | 1.00 | 0.82 | 8.06 |
| unicode/overlapping-words/english | 6156 | 1.44 ± 0.2% | not timed | not timed | 3.01 ± 0.3% | 2.33 ± 0.9% | not timed | not timed | 1.43 ± 0.1% | | 1.01 | 0.48 | 0.62 |
| unicode/overlapping-words/russian | 5710 | 1.28 ± 10.7% | not timed | not timed | 2.85 ± 0.2% | 6.18 ± 10.0% | not timed | not timed | 1.27 ± 0.1% | | 1.00 | 0.45 | 0.21 |
| unicode/word/boundary-any-english | 450561 | 128.59 ± 3.5% | not timed | not timed | 83.10 ± 0.4% | 11.23 ± 16.5% | not timed | not timed | 129.45 ± 1.2% | | 0.99 | 1.55 | 11.45 |
| unicode/word/boundary-long-english | 3466 | 608.77 ± 0.4% | not timed | not timed | 607.29 ± 0.1% | 32.38 ± 0.4% | not timed | not timed | 607.71 ± 0.2% | | 1.00 | 1.00 | 18.80 |
| unicode/word/around-holmes-english | 27 | 19781.58 ± 0.8% | not timed | not timed | 19379.85 ± 0.3% | 22.19 ± 0.9% | not timed | not timed | 19743.24 ± 0.6% | | 1.00 | 1.02 | 891.60 |
| wild/bibleref/long | 874 | 566.28 ± 0.1% | not timed | not timed | 584.25 ± 0.0% | 6.78 ± 0.1% | not timed | not timed | 569.19 ± 0.1% | | 0.99 | 0.97 | 83.50 |
| wild/bibleref/short | 30 | 25.30 ± 3.9% | not timed | not timed | 31.45 ± 0.4% | 14.20 ± 9.3% | not timed | not timed | 25.62 ± 3.6% | | 0.99 | 0.80 | 1.78 |
| wild/bibleref/line | 874 | 396.68 ± 1.9% | not timed | not timed | 220.11 ± 0.1% | 9.18 ± 8.5% | not timed | not timed | 398.06 ± 2.1% | | 1.00 | 1.80 | 43.21 |
| wild/caddy/caddy | 6 | 421.98 ± 3.8% | not timed | not timed | 243.91 ± 0.3% | 67.91 ± 12.4% | not timed | not timed | 423.31 ± 0.2% | | 1.00 | 1.73 | 6.21 |
| wild/dot-star-capture/rust-src-tools | 6 | 1067.28 ± 0.6% | not timed | not timed | 345.09 ± 0.3% | 13.55 ± 0.2% | not timed | not timed | 1064.61 ± 0.2% | | 1.00 | 3.09 | 78.75 |
| wild/ruff/noqa | 84 | 437.56 ± 0.1% | not timed | not timed | 462.93 ± 0.4% | 19.54 ± 2.2% | not timed | not timed | 436.58 ± 0.2% | | 1.00 | 0.95 | 22.39 |
| wild/ruff/unnecessary-coding-comment | 16 | 950.90 ± 0.5% | not timed | not timed | 702.68 ± 0.3% | 135.35 ± 11.3% | not timed | not timed | 954.02 ± 0.2% | | 1.00 | 1.35 | 7.03 |
| wild/ruff/string-quote-prefix | 2972 | 1317.55 ± 0.7% | not timed | not timed | 440.98 ± 0.1% | 371.06 ± 31.8% | not timed | not timed | 1318.50 ± 0.3% | | 1.00 | 2.99 | 3.55 |
| wild/ruff/space-around-operator | 1224378 | 222.46 ± 1.9% | not timed | not timed | 187.59 ± 0.2% | 18.36 ± 1.7% | not timed | not timed | 223.04 ± 1.9% | | 1.00 | 1.19 | 12.12 |
| wild/ruff/shebang | 282 | 953.59 ± 0.5% | not timed | not timed | 328.65 ± 0.1% | 118.25 ± 9.4% | not timed | not timed | 958.42 ± 0.7% | | 0.99 | 2.90 | 8.06 |
| wild/rustsec-cargo-audit/original-unix | 471 | 13291.07 ± 2.1% | not timed | not timed | 13242.75 ± 1.8% | 6633.19 ± 3.5% | not timed | not timed | 13318.70 ± 5.6% | | 1.00 | 1.00 | 2.00 |
| wild/rustsec-cargo-audit/original-windows | 462 | 12426.52 ± 2.6% | not timed | not timed | 13154.86 ± 1.7% | 6198.89 ± 2.2% | not timed | not timed | 12508.58 ± 2.8% | | 0.99 | 0.94 | 2.00 |
| wild/rustsec-cargo-audit/both-slashes | 471 | 12644.87 ± 2.3% | not timed | not timed | 13110.96 ± 4.6% | 6328.82 ± 1.9% | not timed | not timed | 12696.61 ± 1.5% | | 1.00 | 0.96 | 2.00 |
| wild/rustsec-cargo-audit/both-alternate | 471 | 8949.50 ± 3.5% | not timed | not timed | 13040.81 ± 3.1% | 6350.66 ± 0.8% | not timed | not timed | 9135.50 ± 3.4% | | 0.98 | 0.69 | 1.41 |
| wild/url/search | 234965 | 120.32 ± 16.3% | not timed | not timed | 64.82 ± 1.9% | 2.18 ± 0.7% | not timed | not timed | 120.44 ± 16.3% | | 1.00 | 1.86 | 55.19 |

## Compile, rebar's other benchmarks, thousands of patterns a second

| Benchmark | Answer | stdx | stdx, no skip | stdx, matcher alone | Rust regex | Go regexp | zig-regex | mvzr | stdx, again | stdx / stdx, no skip | stdx / stdx, again | stdx / Rust regex | stdx / Go regexp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| dictionary/compile/english-10 | 1 | 0.03 ± 1.2% | not timed | not timed | 0.01 ± 1.3% | 0.01 ± 12.3% | not timed | not timed | 0.03 ± 11.1% | | 1.00 | 3.07 | 4.11 |
| dictionary/compile/english-15 | 1 | 0.35 ± 24.3% | not timed | not timed | 0.07 ± 0.8% | 0.10 ± 9.5% | not timed | not timed | 0.35 ± 4.8% | | 0.99 | 4.96 | 3.38 |
| reported/i1095-word-repetition/unicode-compile | 1 | 0.24 ± 4.7% | not timed | not timed | 0.02 ± 1.4% | 35.22 ± 13.0% | not timed | not timed | 0.24 ± 4.8% | | 0.98 | 12.49 | 0.0067 |
| reported/i1095-word-repetition/ascii-compile | 1 | 46.05 ± 2.4% | not timed | not timed | 11.63 ± 0.5% | 51.66 ± 18.7% | not timed | not timed | 46.60 ± 2.4% | | 0.99 | 3.96 | 0.89 |
| reported/i787-keywords/compile | 1 | 34.44 ± 4.9% | not timed | not timed | 2.13 ± 0.5% | 17.23 ± 38.0% | not timed | not timed | 34.45 ± 5.3% | | 1.00 | 16.14 | 2.00 |
| reported/i988-cloudflare-compile/javascript-obfuscation | 1 | 339.42 ± 1.5% | not timed | not timed | 127.10 ± 0.4% | 566.42 ± 5.9% | not timed | not timed | 349.05 ± 1.1% | | 0.97 | 2.67 | 0.60 |
| reported/i988-cloudflare-compile/sql-injection | 1 | 46.20 ± 21.2% | not timed | not timed | 4.12 ± 0.8% | 42.24 ± 15.7% | not timed | not timed | 46.93 ± 1.6% | | 0.98 | 11.20 | 1.09 |
| unicode/compile/one-letter | 53 | 6.64 ± 3.8% | not timed | not timed | 4.53 ± 0.5% | 63.71 ± 15.6% | not timed | not timed | 6.71 ± 12.2% | | 0.99 | 1.47 | 0.10 |
| unicode/compile/fifty-letters | 1 | 0.98 ± 14.4% | not timed | not timed | 0.10 ± 1.5% | 62.45 ± 15.3% | not timed | not timed | 1.05 ± 2.2% | | 0.93 | 10.27 | 0.0156 |
| unicode/compile/fifty-letters-ascii | 1 | 209.61 ± 5.0% | not timed | not timed | 52.75 ± 0.3% | 186.89 ± 28.9% | not timed | not timed | 215.58 ± 4.2% | | 0.97 | 3.97 | 1.12 |
| unicode/compile/match-every-line | Go 4, Rust 3, RE2 3 | 364.16 ± 1.7% | not timed | not timed | 47.38 ± 0.2% | 645.51 ± 5.5% | not timed | not timed | 373.71 ± 1.7% | | 0.97 | 7.69 | 0.56 |
| unicode/compile/match-every-line-ascii | 4 | 580.27 ± 5.1% | not timed | not timed | 146.79 ± 0.2% | 652.01 ± 30.0% | not timed | not timed | 599.14 ± 8.0% | | 0.97 | 3.95 | 0.89 |
| unicode/compile/negated-class-matches-codepoint | 1 | 306.02 ± 11.0% | not timed | not timed | 51.50 ± 0.4% | 1162.27 ± 27.9% | not timed | not timed | 311.65 ± 2.4% | | 0.98 | 5.94 | 0.26 |
| wild/bibleref/compile | 3 | 5.68 ± 21.1% | not timed | not timed | 1.92 ± 0.4% | 30.98 ± 13.3% | not timed | not timed | 5.88 ± 24.6% | | 0.97 | 2.96 | 0.18 |
| wild/url/compile | 1 | 0.60 ± 7.0% | not timed | not timed | 0.14 ± 1.6% | 0.41 ± 14.8% | not timed | not timed | 0.60 ± 7.5% | | 1.00 | 4.31 | 1.46 |

